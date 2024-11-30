// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct {
  struct spinlock lock;
  int ref[PHYSTOP/PGSIZE];
} pageref;

// Initialize reference count for a new physical page
void 
refcnt_init(void *pa){
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_init");  // Raise an error if pa is invalid
  acquire(&pageref.lock);   // Acquire lock to protect reference count from concurrent access
  PG_REFCNT(pa) = 1;        // Set initial reference count to 1, as the page is now in use
  release(&pageref.lock);   // Release lock after initializing the reference count
}

// Increment reference count of a physical page
void
refcnt_inc(void *pa){
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_inc");   // Raise an error if pa is invalid
  acquire(&pageref.lock);    // Acquire lock to protect reference count from concurrent access
  PG_REFCNT(pa)++;           // Increment the reference count of the page
  release(&pageref.lock);    // Release lock after updating the reference count
}

// Decrement reference count of a physical page
void 
refcnt_dec(void *pa){
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_dec");  // Raise an error if pa is invalid
  acquire(&pageref.lock);   // Acquire lock to protect reference count from concurrent access
  PG_REFCNT(pa)--;          // Decrement the reference count of the page
  release(&pageref.lock);   // Release lock after updating the reference count
}


// Retrieve the reference count for a physical page
int get_refcnt(void *pa){
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("get_refcnt");  // Raise an error if pa is invalid
  acquire(&pageref.lock);   // Acquire lock to protect reference count from concurrent access
  int ret = PG_REFCNT(pa);  // Retrieve the current reference count
  release(&pageref.lock);   // Release lock after reading the reference count
  return ret;               // Return the retrieved reference count
}


void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&pageref.lock, "ref_cnt");
  memset(pageref.ref, 0, sizeof(pageref.ref));
  freerange(end, (void*)PHYSTOP);
}


void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  if(get_refcnt(pa) > 1){
    refcnt_dec(pa);
    return;
  }

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    refcnt_init((void*)r);    // Initialize reference count for the page
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
