#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/memlayout.h"

#define PGSIZE 4096
#define NUM_PAGES 16

// Test Read-only process
void test_read_only() {
    int pid = fork();
    if (pid == 0) {
        char *p = (char *)0x1000;
        for (int i = 0; i < PGSIZE; i++) {
            printf("%c", p[i]);
        }
        exit(0);
    } else {
        int status;
        wait(&status);
    }
}

// Test Read-only and Modifying processes
void test_read_and_modify() {
    int pid1 = fork();
    if (pid1 == 0) {
        char *p = (char *)0x1000;
        for (int i = 0; i < PGSIZE; i++) {
            printf("%c", p[i]);
        }
        exit(0);
    } else {
        int pid2 = fork();
        if (pid2 == 0) {
            char *p = (char *)0x1000;
            for (int i = 0; i < PGSIZE; i++) {
                p[i] = 'a';
            }
            exit(0);
        } else {
            int status;
            wait(&status);
            // wait(&status);
        }
    }
}

// Test Complex Modify process
void test_complex_modify() {
    int pid = fork();
    if (pid == 0) {
        char *p = (char *)0x1000;
        for (int i = 0; i < NUM_PAGES; i += 2) {
            for (int j = 0; j < PGSIZE; j++) {
                p[i * PGSIZE + j] = 'a';
            }
        }
        for (int i = 0; i < NUM_PAGES; i += 2) {
            for (int j = 0; j < PGSIZE; j++) {
                if (p[i * PGSIZE + j] != 'a') {
                    // printf("Child (pid=%d): Verification failed at address %p\n", getpid(), p + i * PGSIZE + j);
                    exit(1);
                }
            }
        }
        exit(0);
    } else {
        int status;
        wait(&status);
    }
}


// File test
int fds[2];
char buf[4096];

void
filetest()
{
  printf("file: ");
  buf[0] = 99;
  for(int i = 0; i < 4; i++){
    if(pipe(fds) != 0){
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
      sleep(1);
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
        printf("error: read failed\n");
        exit(1);
      }
      sleep(1);
      int j = *(int*)buf;
      if(j != i){
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
      printf("error: write failed\n");
      exit(-1);
    }
  }
  int xstatus = 0;
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
    if(xstatus != 0) {
      exit(1);
    }
  }
  if(buf[0] != 99){
    printf("error: child overwrote parent\n");
    exit(1);
  }
  printf("ok\n");
}

int main() {
    printf("Running COW tests...\n");
    printf("Test 1 starting\n");
    test_read_only();
    printf("Test 1 finished\n");
    printf("Test 2 starting\n");
    test_read_and_modify();
    printf("Test 2 finished\n");
    printf("Test 3 starting\n");
    test_complex_modify();
    printf("Test 3 finished\n");
    printf("Test 4 starting\n");
    filetest();
    printf("Test 4 finished\n");
    printf("ALL COW TESTS FINISHED\n");
    exit(0);
}