
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ae010113          	addi	sp,sp,-1312 # 80008ae0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	94e70713          	addi	a4,a4,-1714 # 800089a0 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	14c78793          	addi	a5,a5,332 # 800061b0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbc5d7>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	fda78793          	addi	a5,a5,-38 # 80001088 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00002097          	auipc	ra,0x2
    80000130:	710080e7          	jalr	1808(ra) # 8000283c <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	95650513          	addi	a0,a0,-1706 # 80010ae0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	c54080e7          	jalr	-940(ra) # 80000de6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	94648493          	addi	s1,s1,-1722 # 80010ae0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	9d690913          	addi	s2,s2,-1578 # 80010b78 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	b36080e7          	jalr	-1226(ra) # 80001cf6 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	4be080e7          	jalr	1214(ra) # 80002686 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	1fc080e7          	jalr	508(ra) # 800023d2 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	5d4080e7          	jalr	1492(ra) # 800027e6 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	8ba50513          	addi	a0,a0,-1862 # 80010ae0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	c6c080e7          	jalr	-916(ra) # 80000e9a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	8a450513          	addi	a0,a0,-1884 # 80010ae0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	c56080e7          	jalr	-938(ra) # 80000e9a <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	90f72323          	sw	a5,-1786(a4) # 80010b78 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00011517          	auipc	a0,0x11
    800002d0:	81450513          	addi	a0,a0,-2028 # 80010ae0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	b12080e7          	jalr	-1262(ra) # 80000de6 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	5a0080e7          	jalr	1440(ra) # 80002892 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	7e650513          	addi	a0,a0,2022 # 80010ae0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	b98080e7          	jalr	-1128(ra) # 80000e9a <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	7c270713          	addi	a4,a4,1986 # 80010ae0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	79878793          	addi	a5,a5,1944 # 80010ae0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00011797          	auipc	a5,0x11
    8000037a:	8027a783          	lw	a5,-2046(a5) # 80010b78 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	75670713          	addi	a4,a4,1878 # 80010ae0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	74648493          	addi	s1,s1,1862 # 80010ae0 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	70a70713          	addi	a4,a4,1802 # 80010ae0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	78f72a23          	sw	a5,1940(a4) # 80010b80 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	6ce78793          	addi	a5,a5,1742 # 80010ae0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	74c7a323          	sw	a2,1862(a5) # 80010b7c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	73a50513          	addi	a0,a0,1850 # 80010b78 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	ff0080e7          	jalr	-16(ra) # 80002436 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	68050513          	addi	a0,a0,1664 # 80010ae0 <cons>
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	8ee080e7          	jalr	-1810(ra) # 80000d56 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00241797          	auipc	a5,0x241
    8000047c:	c1878793          	addi	a5,a5,-1000 # 80241090 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	33660613          	addi	a2,a2,822 # 800087f0 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	6407ab23          	sw	zero,1622(a5) # 80010ba0 <pr+0x18>
  printf("panic: ");
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	ab450513          	addi	a0,a0,-1356 # 80008020 <etext+0x20>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	3ef72123          	sw	a5,994(a4) # 80008960 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	5e6dad83          	lw	s11,1510(s11) # 80010ba0 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	20ab0b13          	addi	s6,s6,522 # 800087f0 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	59050513          	addi	a0,a0,1424 # 80010b88 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	7e6080e7          	jalr	2022(ra) # 80000de6 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a2650513          	addi	a0,a0,-1498 # 80008030 <etext+0x30>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00008497          	auipc	s1,0x8
    80000708:	92448493          	addi	s1,s1,-1756 # 80008028 <etext+0x28>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	43250513          	addi	a0,a0,1074 # 80010b88 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	73c080e7          	jalr	1852(ra) # 80000e9a <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00010497          	auipc	s1,0x10
    80000776:	41648493          	addi	s1,s1,1046 # 80010b88 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8c658593          	addi	a1,a1,-1850 # 80008040 <etext+0x40>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	5d2080e7          	jalr	1490(ra) # 80000d56 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	87e58593          	addi	a1,a1,-1922 # 80008048 <etext+0x48>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	3d650513          	addi	a0,a0,982 # 80010ba8 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	57c080e7          	jalr	1404(ra) # 80000d56 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	5a4080e7          	jalr	1444(ra) # 80000d9a <push_off>

  if(panicked){
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	1627a783          	lw	a5,354(a5) # 80008960 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	zext.b	a0,s1
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	616080e7          	jalr	1558(ra) # 80000e3a <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	1327b783          	ld	a5,306(a5) # 80008968 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	13273703          	ld	a4,306(a4) # 80008970 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	348a0a13          	addi	s4,s4,840 # 80010ba8 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	10048493          	addi	s1,s1,256 # 80008968 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	10098993          	addi	s3,s3,256 # 80008970 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	ba4080e7          	jalr	-1116(ra) # 80002436 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	2da50513          	addi	a0,a0,730 # 80010ba8 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	510080e7          	jalr	1296(ra) # 80000de6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	0827a783          	lw	a5,130(a5) # 80008960 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	08873703          	ld	a4,136(a4) # 80008970 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	0787b783          	ld	a5,120(a5) # 80008968 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	2ac98993          	addi	s3,s3,684 # 80010ba8 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	06448493          	addi	s1,s1,100 # 80008968 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	06490913          	addi	s2,s2,100 # 80008970 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	ab6080e7          	jalr	-1354(ra) # 800023d2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	27648493          	addi	s1,s1,630 # 80010ba8 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	02e7b523          	sd	a4,42(a5) # 80008970 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	542080e7          	jalr	1346(ra) # 80000e9a <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	1ec48493          	addi	s1,s1,492 # 80010ba8 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	420080e7          	jalr	1056(ra) # 80000de6 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	4c2080e7          	jalr	1218(ra) # 80000e9a <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <refcnt_init>:
  int ref[PHYSTOP/PGSIZE];
} pageref;

// Initialize reference count for a new physical page
void 
refcnt_init(void *pa){
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	1000                	addi	s0,sp,32
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_init");  // Raise an error if pa is invalid
    800009f4:	03451793          	slli	a5,a0,0x34
    800009f8:	e7b9                	bnez	a5,80000a46 <refcnt_init+0x5c>
    800009fa:	84aa                	mv	s1,a0
    800009fc:	00242797          	auipc	a5,0x242
    80000a00:	82c78793          	addi	a5,a5,-2004 # 80242228 <end>
    80000a04:	04f56163          	bltu	a0,a5,80000a46 <refcnt_init+0x5c>
    80000a08:	47c5                	li	a5,17
    80000a0a:	07ee                	slli	a5,a5,0x1b
    80000a0c:	02f57d63          	bgeu	a0,a5,80000a46 <refcnt_init+0x5c>
  acquire(&pageref.lock);   // Acquire lock to protect reference count from concurrent access
    80000a10:	00010517          	auipc	a0,0x10
    80000a14:	1f050513          	addi	a0,a0,496 # 80010c00 <pageref>
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	3ce080e7          	jalr	974(ra) # 80000de6 <acquire>
  PG_REFCNT(pa) = 1;        // Set initial reference count to 1, as the page is now in use
    80000a20:	00010517          	auipc	a0,0x10
    80000a24:	1e050513          	addi	a0,a0,480 # 80010c00 <pageref>
    80000a28:	80b1                	srli	s1,s1,0xc
    80000a2a:	0491                	addi	s1,s1,4
    80000a2c:	048a                	slli	s1,s1,0x2
    80000a2e:	94aa                	add	s1,s1,a0
    80000a30:	4785                	li	a5,1
    80000a32:	c49c                	sw	a5,8(s1)
  release(&pageref.lock);   // Release lock after initializing the reference count
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	466080e7          	jalr	1126(ra) # 80000e9a <release>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_init");  // Raise an error if pa is invalid
    80000a46:	00007517          	auipc	a0,0x7
    80000a4a:	60a50513          	addi	a0,a0,1546 # 80008050 <etext+0x50>
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	af0080e7          	jalr	-1296(ra) # 8000053e <panic>

0000000080000a56 <refcnt_inc>:

// Increment reference count of a physical page
void
refcnt_inc(void *pa){
    80000a56:	1101                	addi	sp,sp,-32
    80000a58:	ec06                	sd	ra,24(sp)
    80000a5a:	e822                	sd	s0,16(sp)
    80000a5c:	e426                	sd	s1,8(sp)
    80000a5e:	1000                	addi	s0,sp,32
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_inc");   // Raise an error if pa is invalid
    80000a60:	03451793          	slli	a5,a0,0x34
    80000a64:	eba1                	bnez	a5,80000ab4 <refcnt_inc+0x5e>
    80000a66:	84aa                	mv	s1,a0
    80000a68:	00241797          	auipc	a5,0x241
    80000a6c:	7c078793          	addi	a5,a5,1984 # 80242228 <end>
    80000a70:	04f56263          	bltu	a0,a5,80000ab4 <refcnt_inc+0x5e>
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	02f57e63          	bgeu	a0,a5,80000ab4 <refcnt_inc+0x5e>
  acquire(&pageref.lock);    // Acquire lock to protect reference count from concurrent access
    80000a7c:	00010517          	auipc	a0,0x10
    80000a80:	18450513          	addi	a0,a0,388 # 80010c00 <pageref>
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	362080e7          	jalr	866(ra) # 80000de6 <acquire>
  PG_REFCNT(pa)++;           // Increment the reference count of the page
    80000a8c:	80b1                	srli	s1,s1,0xc
    80000a8e:	00010517          	auipc	a0,0x10
    80000a92:	17250513          	addi	a0,a0,370 # 80010c00 <pageref>
    80000a96:	0491                	addi	s1,s1,4
    80000a98:	048a                	slli	s1,s1,0x2
    80000a9a:	94aa                	add	s1,s1,a0
    80000a9c:	449c                	lw	a5,8(s1)
    80000a9e:	2785                	addiw	a5,a5,1
    80000aa0:	c49c                	sw	a5,8(s1)
  release(&pageref.lock);    // Release lock after updating the reference count
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	3f8080e7          	jalr	1016(ra) # 80000e9a <release>
}
    80000aaa:	60e2                	ld	ra,24(sp)
    80000aac:	6442                	ld	s0,16(sp)
    80000aae:	64a2                	ld	s1,8(sp)
    80000ab0:	6105                	addi	sp,sp,32
    80000ab2:	8082                	ret
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_inc");   // Raise an error if pa is invalid
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	5ac50513          	addi	a0,a0,1452 # 80008060 <etext+0x60>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	a82080e7          	jalr	-1406(ra) # 8000053e <panic>

0000000080000ac4 <refcnt_dec>:

// Decrement reference count of a physical page
void 
refcnt_dec(void *pa){
    80000ac4:	1101                	addi	sp,sp,-32
    80000ac6:	ec06                	sd	ra,24(sp)
    80000ac8:	e822                	sd	s0,16(sp)
    80000aca:	e426                	sd	s1,8(sp)
    80000acc:	1000                	addi	s0,sp,32
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_dec");  // Raise an error if pa is invalid
    80000ace:	03451793          	slli	a5,a0,0x34
    80000ad2:	eba1                	bnez	a5,80000b22 <refcnt_dec+0x5e>
    80000ad4:	84aa                	mv	s1,a0
    80000ad6:	00241797          	auipc	a5,0x241
    80000ada:	75278793          	addi	a5,a5,1874 # 80242228 <end>
    80000ade:	04f56263          	bltu	a0,a5,80000b22 <refcnt_dec+0x5e>
    80000ae2:	47c5                	li	a5,17
    80000ae4:	07ee                	slli	a5,a5,0x1b
    80000ae6:	02f57e63          	bgeu	a0,a5,80000b22 <refcnt_dec+0x5e>
  acquire(&pageref.lock);   // Acquire lock to protect reference count from concurrent access
    80000aea:	00010517          	auipc	a0,0x10
    80000aee:	11650513          	addi	a0,a0,278 # 80010c00 <pageref>
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	2f4080e7          	jalr	756(ra) # 80000de6 <acquire>
  PG_REFCNT(pa)--;          // Decrement the reference count of the page
    80000afa:	80b1                	srli	s1,s1,0xc
    80000afc:	00010517          	auipc	a0,0x10
    80000b00:	10450513          	addi	a0,a0,260 # 80010c00 <pageref>
    80000b04:	0491                	addi	s1,s1,4
    80000b06:	048a                	slli	s1,s1,0x2
    80000b08:	94aa                	add	s1,s1,a0
    80000b0a:	449c                	lw	a5,8(s1)
    80000b0c:	37fd                	addiw	a5,a5,-1
    80000b0e:	c49c                	sw	a5,8(s1)
  release(&pageref.lock);   // Release lock after updating the reference count
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	38a080e7          	jalr	906(ra) # 80000e9a <release>
}
    80000b18:	60e2                	ld	ra,24(sp)
    80000b1a:	6442                	ld	s0,16(sp)
    80000b1c:	64a2                	ld	s1,8(sp)
    80000b1e:	6105                	addi	sp,sp,32
    80000b20:	8082                	ret
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("refcnt_dec");  // Raise an error if pa is invalid
    80000b22:	00007517          	auipc	a0,0x7
    80000b26:	54e50513          	addi	a0,a0,1358 # 80008070 <etext+0x70>
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	a14080e7          	jalr	-1516(ra) # 8000053e <panic>

0000000080000b32 <get_refcnt>:


// Retrieve the reference count for a physical page
int get_refcnt(void *pa){
    80000b32:	1101                	addi	sp,sp,-32
    80000b34:	ec06                	sd	ra,24(sp)
    80000b36:	e822                	sd	s0,16(sp)
    80000b38:	e426                	sd	s1,8(sp)
    80000b3a:	1000                	addi	s0,sp,32
  // Check if pa is page-aligned, within physical memory bounds, and above the end marker
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("get_refcnt");  // Raise an error if pa is invalid
    80000b3c:	03451793          	slli	a5,a0,0x34
    80000b40:	e7b9                	bnez	a5,80000b8e <get_refcnt+0x5c>
    80000b42:	84aa                	mv	s1,a0
    80000b44:	00241797          	auipc	a5,0x241
    80000b48:	6e478793          	addi	a5,a5,1764 # 80242228 <end>
    80000b4c:	04f56163          	bltu	a0,a5,80000b8e <get_refcnt+0x5c>
    80000b50:	47c5                	li	a5,17
    80000b52:	07ee                	slli	a5,a5,0x1b
    80000b54:	02f57d63          	bgeu	a0,a5,80000b8e <get_refcnt+0x5c>
  acquire(&pageref.lock);   // Acquire lock to protect reference count from concurrent access
    80000b58:	00010517          	auipc	a0,0x10
    80000b5c:	0a850513          	addi	a0,a0,168 # 80010c00 <pageref>
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	286080e7          	jalr	646(ra) # 80000de6 <acquire>
  int ret = PG_REFCNT(pa);  // Retrieve the current reference count
    80000b68:	00010517          	auipc	a0,0x10
    80000b6c:	09850513          	addi	a0,a0,152 # 80010c00 <pageref>
    80000b70:	80b1                	srli	s1,s1,0xc
    80000b72:	0491                	addi	s1,s1,4
    80000b74:	048a                	slli	s1,s1,0x2
    80000b76:	94aa                	add	s1,s1,a0
    80000b78:	4484                	lw	s1,8(s1)
  release(&pageref.lock);   // Release lock after reading the reference count
    80000b7a:	00000097          	auipc	ra,0x0
    80000b7e:	320080e7          	jalr	800(ra) # 80000e9a <release>
  return ret;               // Return the retrieved reference count
}
    80000b82:	8526                	mv	a0,s1
    80000b84:	60e2                	ld	ra,24(sp)
    80000b86:	6442                	ld	s0,16(sp)
    80000b88:	64a2                	ld	s1,8(sp)
    80000b8a:	6105                	addi	sp,sp,32
    80000b8c:	8082                	ret
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) panic("get_refcnt");  // Raise an error if pa is invalid
    80000b8e:	00007517          	auipc	a0,0x7
    80000b92:	4f250513          	addi	a0,a0,1266 # 80008080 <etext+0x80>
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	9a8080e7          	jalr	-1624(ra) # 8000053e <panic>

0000000080000b9e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000b9e:	1101                	addi	sp,sp,-32
    80000ba0:	ec06                	sd	ra,24(sp)
    80000ba2:	e822                	sd	s0,16(sp)
    80000ba4:	e426                	sd	s1,8(sp)
    80000ba6:	e04a                	sd	s2,0(sp)
    80000ba8:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000baa:	03451793          	slli	a5,a0,0x34
    80000bae:	e3bd                	bnez	a5,80000c14 <kfree+0x76>
    80000bb0:	84aa                	mv	s1,a0
    80000bb2:	00241797          	auipc	a5,0x241
    80000bb6:	67678793          	addi	a5,a5,1654 # 80242228 <end>
    80000bba:	04f56d63          	bltu	a0,a5,80000c14 <kfree+0x76>
    80000bbe:	47c5                	li	a5,17
    80000bc0:	07ee                	slli	a5,a5,0x1b
    80000bc2:	04f57963          	bgeu	a0,a5,80000c14 <kfree+0x76>
    panic("kfree");

  if(get_refcnt(pa) > 1){
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	f6c080e7          	jalr	-148(ra) # 80000b32 <get_refcnt>
    80000bce:	4785                	li	a5,1
    80000bd0:	04a7ca63          	blt	a5,a0,80000c24 <kfree+0x86>
    refcnt_dec(pa);
    return;
  }

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000bd4:	6605                	lui	a2,0x1
    80000bd6:	4585                	li	a1,1
    80000bd8:	8526                	mv	a0,s1
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	308080e7          	jalr	776(ra) # 80000ee2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000be2:	00010917          	auipc	s2,0x10
    80000be6:	ffe90913          	addi	s2,s2,-2 # 80010be0 <kmem>
    80000bea:	854a                	mv	a0,s2
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	1fa080e7          	jalr	506(ra) # 80000de6 <acquire>
  r->next = kmem.freelist;
    80000bf4:	01893783          	ld	a5,24(s2)
    80000bf8:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000bfa:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000bfe:	854a                	mv	a0,s2
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	29a080e7          	jalr	666(ra) # 80000e9a <release>
}
    80000c08:	60e2                	ld	ra,24(sp)
    80000c0a:	6442                	ld	s0,16(sp)
    80000c0c:	64a2                	ld	s1,8(sp)
    80000c0e:	6902                	ld	s2,0(sp)
    80000c10:	6105                	addi	sp,sp,32
    80000c12:	8082                	ret
    panic("kfree");
    80000c14:	00007517          	auipc	a0,0x7
    80000c18:	47c50513          	addi	a0,a0,1148 # 80008090 <etext+0x90>
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	922080e7          	jalr	-1758(ra) # 8000053e <panic>
    refcnt_dec(pa);
    80000c24:	8526                	mv	a0,s1
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	e9e080e7          	jalr	-354(ra) # 80000ac4 <refcnt_dec>
    return;
    80000c2e:	bfe9                	j	80000c08 <kfree+0x6a>

0000000080000c30 <freerange>:
{
    80000c30:	7179                	addi	sp,sp,-48
    80000c32:	f406                	sd	ra,40(sp)
    80000c34:	f022                	sd	s0,32(sp)
    80000c36:	ec26                	sd	s1,24(sp)
    80000c38:	e84a                	sd	s2,16(sp)
    80000c3a:	e44e                	sd	s3,8(sp)
    80000c3c:	e052                	sd	s4,0(sp)
    80000c3e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000c40:	6785                	lui	a5,0x1
    80000c42:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000c46:	94aa                	add	s1,s1,a0
    80000c48:	757d                	lui	a0,0xfffff
    80000c4a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000c4c:	94be                	add	s1,s1,a5
    80000c4e:	0095ee63          	bltu	a1,s1,80000c6a <freerange+0x3a>
    80000c52:	892e                	mv	s2,a1
    kfree(p);
    80000c54:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000c56:	6985                	lui	s3,0x1
    kfree(p);
    80000c58:	01448533          	add	a0,s1,s4
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	f42080e7          	jalr	-190(ra) # 80000b9e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000c64:	94ce                	add	s1,s1,s3
    80000c66:	fe9979e3          	bgeu	s2,s1,80000c58 <freerange+0x28>
}
    80000c6a:	70a2                	ld	ra,40(sp)
    80000c6c:	7402                	ld	s0,32(sp)
    80000c6e:	64e2                	ld	s1,24(sp)
    80000c70:	6942                	ld	s2,16(sp)
    80000c72:	69a2                	ld	s3,8(sp)
    80000c74:	6a02                	ld	s4,0(sp)
    80000c76:	6145                	addi	sp,sp,48
    80000c78:	8082                	ret

0000000080000c7a <kinit>:
{
    80000c7a:	1141                	addi	sp,sp,-16
    80000c7c:	e406                	sd	ra,8(sp)
    80000c7e:	e022                	sd	s0,0(sp)
    80000c80:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000c82:	00007597          	auipc	a1,0x7
    80000c86:	41658593          	addi	a1,a1,1046 # 80008098 <etext+0x98>
    80000c8a:	00010517          	auipc	a0,0x10
    80000c8e:	f5650513          	addi	a0,a0,-170 # 80010be0 <kmem>
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	0c4080e7          	jalr	196(ra) # 80000d56 <initlock>
  initlock(&pageref.lock, "ref_cnt");
    80000c9a:	00007597          	auipc	a1,0x7
    80000c9e:	40658593          	addi	a1,a1,1030 # 800080a0 <etext+0xa0>
    80000ca2:	00010517          	auipc	a0,0x10
    80000ca6:	f5e50513          	addi	a0,a0,-162 # 80010c00 <pageref>
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	0ac080e7          	jalr	172(ra) # 80000d56 <initlock>
  memset(pageref.ref, 0, sizeof(pageref.ref));
    80000cb2:	00220637          	lui	a2,0x220
    80000cb6:	4581                	li	a1,0
    80000cb8:	00010517          	auipc	a0,0x10
    80000cbc:	f6050513          	addi	a0,a0,-160 # 80010c18 <pageref+0x18>
    80000cc0:	00000097          	auipc	ra,0x0
    80000cc4:	222080e7          	jalr	546(ra) # 80000ee2 <memset>
  freerange(end, (void*)PHYSTOP);
    80000cc8:	45c5                	li	a1,17
    80000cca:	05ee                	slli	a1,a1,0x1b
    80000ccc:	00241517          	auipc	a0,0x241
    80000cd0:	55c50513          	addi	a0,a0,1372 # 80242228 <end>
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	f5c080e7          	jalr	-164(ra) # 80000c30 <freerange>
}
    80000cdc:	60a2                	ld	ra,8(sp)
    80000cde:	6402                	ld	s0,0(sp)
    80000ce0:	0141                	addi	sp,sp,16
    80000ce2:	8082                	ret

0000000080000ce4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ce4:	1101                	addi	sp,sp,-32
    80000ce6:	ec06                	sd	ra,24(sp)
    80000ce8:	e822                	sd	s0,16(sp)
    80000cea:	e426                	sd	s1,8(sp)
    80000cec:	e04a                	sd	s2,0(sp)
    80000cee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000cf0:	00010497          	auipc	s1,0x10
    80000cf4:	ef048493          	addi	s1,s1,-272 # 80010be0 <kmem>
    80000cf8:	8526                	mv	a0,s1
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	0ec080e7          	jalr	236(ra) # 80000de6 <acquire>
  r = kmem.freelist;
    80000d02:	6c84                	ld	s1,24(s1)
  if(r) {
    80000d04:	c0a1                	beqz	s1,80000d44 <kalloc+0x60>
    kmem.freelist = r->next;
    80000d06:	609c                	ld	a5,0(s1)
    80000d08:	00010917          	auipc	s2,0x10
    80000d0c:	ed890913          	addi	s2,s2,-296 # 80010be0 <kmem>
    80000d10:	00f93c23          	sd	a5,24(s2)
    refcnt_init((void*)r);    // Initialize reference count for the page
    80000d14:	8526                	mv	a0,s1
    80000d16:	00000097          	auipc	ra,0x0
    80000d1a:	cd4080e7          	jalr	-812(ra) # 800009ea <refcnt_init>
  }
  release(&kmem.lock);
    80000d1e:	854a                	mv	a0,s2
    80000d20:	00000097          	auipc	ra,0x0
    80000d24:	17a080e7          	jalr	378(ra) # 80000e9a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000d28:	6605                	lui	a2,0x1
    80000d2a:	4595                	li	a1,5
    80000d2c:	8526                	mv	a0,s1
    80000d2e:	00000097          	auipc	ra,0x0
    80000d32:	1b4080e7          	jalr	436(ra) # 80000ee2 <memset>
  return (void*)r;
}
    80000d36:	8526                	mv	a0,s1
    80000d38:	60e2                	ld	ra,24(sp)
    80000d3a:	6442                	ld	s0,16(sp)
    80000d3c:	64a2                	ld	s1,8(sp)
    80000d3e:	6902                	ld	s2,0(sp)
    80000d40:	6105                	addi	sp,sp,32
    80000d42:	8082                	ret
  release(&kmem.lock);
    80000d44:	00010517          	auipc	a0,0x10
    80000d48:	e9c50513          	addi	a0,a0,-356 # 80010be0 <kmem>
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	14e080e7          	jalr	334(ra) # 80000e9a <release>
  if(r)
    80000d54:	b7cd                	j	80000d36 <kalloc+0x52>

0000000080000d56 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000d5c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d5e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d62:	00053823          	sd	zero,16(a0)
}
    80000d66:	6422                	ld	s0,8(sp)
    80000d68:	0141                	addi	sp,sp,16
    80000d6a:	8082                	ret

0000000080000d6c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d6c:	411c                	lw	a5,0(a0)
    80000d6e:	e399                	bnez	a5,80000d74 <holding+0x8>
    80000d70:	4501                	li	a0,0
  return r;
}
    80000d72:	8082                	ret
{
    80000d74:	1101                	addi	sp,sp,-32
    80000d76:	ec06                	sd	ra,24(sp)
    80000d78:	e822                	sd	s0,16(sp)
    80000d7a:	e426                	sd	s1,8(sp)
    80000d7c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d7e:	6904                	ld	s1,16(a0)
    80000d80:	00001097          	auipc	ra,0x1
    80000d84:	f5a080e7          	jalr	-166(ra) # 80001cda <mycpu>
    80000d88:	40a48533          	sub	a0,s1,a0
    80000d8c:	00153513          	seqz	a0,a0
}
    80000d90:	60e2                	ld	ra,24(sp)
    80000d92:	6442                	ld	s0,16(sp)
    80000d94:	64a2                	ld	s1,8(sp)
    80000d96:	6105                	addi	sp,sp,32
    80000d98:	8082                	ret

0000000080000d9a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d9a:	1101                	addi	sp,sp,-32
    80000d9c:	ec06                	sd	ra,24(sp)
    80000d9e:	e822                	sd	s0,16(sp)
    80000da0:	e426                	sd	s1,8(sp)
    80000da2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000da4:	100024f3          	csrr	s1,sstatus
    80000da8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000dac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000dae:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000db2:	00001097          	auipc	ra,0x1
    80000db6:	f28080e7          	jalr	-216(ra) # 80001cda <mycpu>
    80000dba:	5d3c                	lw	a5,120(a0)
    80000dbc:	cf89                	beqz	a5,80000dd6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000dbe:	00001097          	auipc	ra,0x1
    80000dc2:	f1c080e7          	jalr	-228(ra) # 80001cda <mycpu>
    80000dc6:	5d3c                	lw	a5,120(a0)
    80000dc8:	2785                	addiw	a5,a5,1
    80000dca:	dd3c                	sw	a5,120(a0)
}
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret
    mycpu()->intena = old;
    80000dd6:	00001097          	auipc	ra,0x1
    80000dda:	f04080e7          	jalr	-252(ra) # 80001cda <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000dde:	8085                	srli	s1,s1,0x1
    80000de0:	8885                	andi	s1,s1,1
    80000de2:	dd64                	sw	s1,124(a0)
    80000de4:	bfe9                	j	80000dbe <push_off+0x24>

0000000080000de6 <acquire>:
{
    80000de6:	1101                	addi	sp,sp,-32
    80000de8:	ec06                	sd	ra,24(sp)
    80000dea:	e822                	sd	s0,16(sp)
    80000dec:	e426                	sd	s1,8(sp)
    80000dee:	1000                	addi	s0,sp,32
    80000df0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000df2:	00000097          	auipc	ra,0x0
    80000df6:	fa8080e7          	jalr	-88(ra) # 80000d9a <push_off>
  if(holding(lk))
    80000dfa:	8526                	mv	a0,s1
    80000dfc:	00000097          	auipc	ra,0x0
    80000e00:	f70080e7          	jalr	-144(ra) # 80000d6c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000e04:	4705                	li	a4,1
  if(holding(lk))
    80000e06:	e115                	bnez	a0,80000e2a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000e08:	87ba                	mv	a5,a4
    80000e0a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000e0e:	2781                	sext.w	a5,a5
    80000e10:	ffe5                	bnez	a5,80000e08 <acquire+0x22>
  __sync_synchronize();
    80000e12:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000e16:	00001097          	auipc	ra,0x1
    80000e1a:	ec4080e7          	jalr	-316(ra) # 80001cda <mycpu>
    80000e1e:	e888                	sd	a0,16(s1)
}
    80000e20:	60e2                	ld	ra,24(sp)
    80000e22:	6442                	ld	s0,16(sp)
    80000e24:	64a2                	ld	s1,8(sp)
    80000e26:	6105                	addi	sp,sp,32
    80000e28:	8082                	ret
    panic("acquire");
    80000e2a:	00007517          	auipc	a0,0x7
    80000e2e:	27e50513          	addi	a0,a0,638 # 800080a8 <etext+0xa8>
    80000e32:	fffff097          	auipc	ra,0xfffff
    80000e36:	70c080e7          	jalr	1804(ra) # 8000053e <panic>

0000000080000e3a <pop_off>:

void
pop_off(void)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e406                	sd	ra,8(sp)
    80000e3e:	e022                	sd	s0,0(sp)
    80000e40:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000e42:	00001097          	auipc	ra,0x1
    80000e46:	e98080e7          	jalr	-360(ra) # 80001cda <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e4a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000e4e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000e50:	e78d                	bnez	a5,80000e7a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000e52:	5d3c                	lw	a5,120(a0)
    80000e54:	02f05b63          	blez	a5,80000e8a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000e58:	37fd                	addiw	a5,a5,-1
    80000e5a:	0007871b          	sext.w	a4,a5
    80000e5e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000e60:	eb09                	bnez	a4,80000e72 <pop_off+0x38>
    80000e62:	5d7c                	lw	a5,124(a0)
    80000e64:	c799                	beqz	a5,80000e72 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e6a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e6e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e72:	60a2                	ld	ra,8(sp)
    80000e74:	6402                	ld	s0,0(sp)
    80000e76:	0141                	addi	sp,sp,16
    80000e78:	8082                	ret
    panic("pop_off - interruptible");
    80000e7a:	00007517          	auipc	a0,0x7
    80000e7e:	23650513          	addi	a0,a0,566 # 800080b0 <etext+0xb0>
    80000e82:	fffff097          	auipc	ra,0xfffff
    80000e86:	6bc080e7          	jalr	1724(ra) # 8000053e <panic>
    panic("pop_off");
    80000e8a:	00007517          	auipc	a0,0x7
    80000e8e:	23e50513          	addi	a0,a0,574 # 800080c8 <etext+0xc8>
    80000e92:	fffff097          	auipc	ra,0xfffff
    80000e96:	6ac080e7          	jalr	1708(ra) # 8000053e <panic>

0000000080000e9a <release>:
{
    80000e9a:	1101                	addi	sp,sp,-32
    80000e9c:	ec06                	sd	ra,24(sp)
    80000e9e:	e822                	sd	s0,16(sp)
    80000ea0:	e426                	sd	s1,8(sp)
    80000ea2:	1000                	addi	s0,sp,32
    80000ea4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ea6:	00000097          	auipc	ra,0x0
    80000eaa:	ec6080e7          	jalr	-314(ra) # 80000d6c <holding>
    80000eae:	c115                	beqz	a0,80000ed2 <release+0x38>
  lk->cpu = 0;
    80000eb0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000eb4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000eb8:	0f50000f          	fence	iorw,ow
    80000ebc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000ec0:	00000097          	auipc	ra,0x0
    80000ec4:	f7a080e7          	jalr	-134(ra) # 80000e3a <pop_off>
}
    80000ec8:	60e2                	ld	ra,24(sp)
    80000eca:	6442                	ld	s0,16(sp)
    80000ecc:	64a2                	ld	s1,8(sp)
    80000ece:	6105                	addi	sp,sp,32
    80000ed0:	8082                	ret
    panic("release");
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1fe50513          	addi	a0,a0,510 # 800080d0 <etext+0xd0>
    80000eda:	fffff097          	auipc	ra,0xfffff
    80000ede:	664080e7          	jalr	1636(ra) # 8000053e <panic>

0000000080000ee2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ee2:	1141                	addi	sp,sp,-16
    80000ee4:	e422                	sd	s0,8(sp)
    80000ee6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ee8:	ca19                	beqz	a2,80000efe <memset+0x1c>
    80000eea:	87aa                	mv	a5,a0
    80000eec:	1602                	slli	a2,a2,0x20
    80000eee:	9201                	srli	a2,a2,0x20
    80000ef0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ef4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ef8:	0785                	addi	a5,a5,1
    80000efa:	fee79de3          	bne	a5,a4,80000ef4 <memset+0x12>
  }
  return dst;
}
    80000efe:	6422                	ld	s0,8(sp)
    80000f00:	0141                	addi	sp,sp,16
    80000f02:	8082                	ret

0000000080000f04 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000f04:	1141                	addi	sp,sp,-16
    80000f06:	e422                	sd	s0,8(sp)
    80000f08:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000f0a:	ca05                	beqz	a2,80000f3a <memcmp+0x36>
    80000f0c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000f10:	1682                	slli	a3,a3,0x20
    80000f12:	9281                	srli	a3,a3,0x20
    80000f14:	0685                	addi	a3,a3,1
    80000f16:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000f18:	00054783          	lbu	a5,0(a0)
    80000f1c:	0005c703          	lbu	a4,0(a1)
    80000f20:	00e79863          	bne	a5,a4,80000f30 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000f24:	0505                	addi	a0,a0,1
    80000f26:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000f28:	fed518e3          	bne	a0,a3,80000f18 <memcmp+0x14>
  }

  return 0;
    80000f2c:	4501                	li	a0,0
    80000f2e:	a019                	j	80000f34 <memcmp+0x30>
      return *s1 - *s2;
    80000f30:	40e7853b          	subw	a0,a5,a4
}
    80000f34:	6422                	ld	s0,8(sp)
    80000f36:	0141                	addi	sp,sp,16
    80000f38:	8082                	ret
  return 0;
    80000f3a:	4501                	li	a0,0
    80000f3c:	bfe5                	j	80000f34 <memcmp+0x30>

0000000080000f3e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e422                	sd	s0,8(sp)
    80000f42:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000f44:	c205                	beqz	a2,80000f64 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000f46:	02a5e263          	bltu	a1,a0,80000f6a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000f4a:	1602                	slli	a2,a2,0x20
    80000f4c:	9201                	srli	a2,a2,0x20
    80000f4e:	00c587b3          	add	a5,a1,a2
{
    80000f52:	872a                	mv	a4,a0
      *d++ = *s++;
    80000f54:	0585                	addi	a1,a1,1
    80000f56:	0705                	addi	a4,a4,1
    80000f58:	fff5c683          	lbu	a3,-1(a1)
    80000f5c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000f60:	fef59ae3          	bne	a1,a5,80000f54 <memmove+0x16>

  return dst;
}
    80000f64:	6422                	ld	s0,8(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret
  if(s < d && s + n > d){
    80000f6a:	02061693          	slli	a3,a2,0x20
    80000f6e:	9281                	srli	a3,a3,0x20
    80000f70:	00d58733          	add	a4,a1,a3
    80000f74:	fce57be3          	bgeu	a0,a4,80000f4a <memmove+0xc>
    d += n;
    80000f78:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000f7a:	fff6079b          	addiw	a5,a2,-1
    80000f7e:	1782                	slli	a5,a5,0x20
    80000f80:	9381                	srli	a5,a5,0x20
    80000f82:	fff7c793          	not	a5,a5
    80000f86:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000f88:	177d                	addi	a4,a4,-1
    80000f8a:	16fd                	addi	a3,a3,-1
    80000f8c:	00074603          	lbu	a2,0(a4)
    80000f90:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000f94:	fee79ae3          	bne	a5,a4,80000f88 <memmove+0x4a>
    80000f98:	b7f1                	j	80000f64 <memmove+0x26>

0000000080000f9a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000f9a:	1141                	addi	sp,sp,-16
    80000f9c:	e406                	sd	ra,8(sp)
    80000f9e:	e022                	sd	s0,0(sp)
    80000fa0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000fa2:	00000097          	auipc	ra,0x0
    80000fa6:	f9c080e7          	jalr	-100(ra) # 80000f3e <memmove>
}
    80000faa:	60a2                	ld	ra,8(sp)
    80000fac:	6402                	ld	s0,0(sp)
    80000fae:	0141                	addi	sp,sp,16
    80000fb0:	8082                	ret

0000000080000fb2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000fb2:	1141                	addi	sp,sp,-16
    80000fb4:	e422                	sd	s0,8(sp)
    80000fb6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000fb8:	ce11                	beqz	a2,80000fd4 <strncmp+0x22>
    80000fba:	00054783          	lbu	a5,0(a0)
    80000fbe:	cf89                	beqz	a5,80000fd8 <strncmp+0x26>
    80000fc0:	0005c703          	lbu	a4,0(a1)
    80000fc4:	00f71a63          	bne	a4,a5,80000fd8 <strncmp+0x26>
    n--, p++, q++;
    80000fc8:	367d                	addiw	a2,a2,-1
    80000fca:	0505                	addi	a0,a0,1
    80000fcc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000fce:	f675                	bnez	a2,80000fba <strncmp+0x8>
  if(n == 0)
    return 0;
    80000fd0:	4501                	li	a0,0
    80000fd2:	a809                	j	80000fe4 <strncmp+0x32>
    80000fd4:	4501                	li	a0,0
    80000fd6:	a039                	j	80000fe4 <strncmp+0x32>
  if(n == 0)
    80000fd8:	ca09                	beqz	a2,80000fea <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000fda:	00054503          	lbu	a0,0(a0)
    80000fde:	0005c783          	lbu	a5,0(a1)
    80000fe2:	9d1d                	subw	a0,a0,a5
}
    80000fe4:	6422                	ld	s0,8(sp)
    80000fe6:	0141                	addi	sp,sp,16
    80000fe8:	8082                	ret
    return 0;
    80000fea:	4501                	li	a0,0
    80000fec:	bfe5                	j	80000fe4 <strncmp+0x32>

0000000080000fee <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000fee:	1141                	addi	sp,sp,-16
    80000ff0:	e422                	sd	s0,8(sp)
    80000ff2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000ff4:	872a                	mv	a4,a0
    80000ff6:	8832                	mv	a6,a2
    80000ff8:	367d                	addiw	a2,a2,-1
    80000ffa:	01005963          	blez	a6,8000100c <strncpy+0x1e>
    80000ffe:	0705                	addi	a4,a4,1
    80001000:	0005c783          	lbu	a5,0(a1)
    80001004:	fef70fa3          	sb	a5,-1(a4)
    80001008:	0585                	addi	a1,a1,1
    8000100a:	f7f5                	bnez	a5,80000ff6 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000100c:	86ba                	mv	a3,a4
    8000100e:	00c05c63          	blez	a2,80001026 <strncpy+0x38>
    *s++ = 0;
    80001012:	0685                	addi	a3,a3,1
    80001014:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80001018:	fff6c793          	not	a5,a3
    8000101c:	9fb9                	addw	a5,a5,a4
    8000101e:	010787bb          	addw	a5,a5,a6
    80001022:	fef048e3          	bgtz	a5,80001012 <strncpy+0x24>
  return os;
}
    80001026:	6422                	ld	s0,8(sp)
    80001028:	0141                	addi	sp,sp,16
    8000102a:	8082                	ret

000000008000102c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000102c:	1141                	addi	sp,sp,-16
    8000102e:	e422                	sd	s0,8(sp)
    80001030:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80001032:	02c05363          	blez	a2,80001058 <safestrcpy+0x2c>
    80001036:	fff6069b          	addiw	a3,a2,-1
    8000103a:	1682                	slli	a3,a3,0x20
    8000103c:	9281                	srli	a3,a3,0x20
    8000103e:	96ae                	add	a3,a3,a1
    80001040:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001042:	00d58963          	beq	a1,a3,80001054 <safestrcpy+0x28>
    80001046:	0585                	addi	a1,a1,1
    80001048:	0785                	addi	a5,a5,1
    8000104a:	fff5c703          	lbu	a4,-1(a1)
    8000104e:	fee78fa3          	sb	a4,-1(a5)
    80001052:	fb65                	bnez	a4,80001042 <safestrcpy+0x16>
    ;
  *s = 0;
    80001054:	00078023          	sb	zero,0(a5)
  return os;
}
    80001058:	6422                	ld	s0,8(sp)
    8000105a:	0141                	addi	sp,sp,16
    8000105c:	8082                	ret

000000008000105e <strlen>:

int
strlen(const char *s)
{
    8000105e:	1141                	addi	sp,sp,-16
    80001060:	e422                	sd	s0,8(sp)
    80001062:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001064:	00054783          	lbu	a5,0(a0)
    80001068:	cf91                	beqz	a5,80001084 <strlen+0x26>
    8000106a:	0505                	addi	a0,a0,1
    8000106c:	87aa                	mv	a5,a0
    8000106e:	4685                	li	a3,1
    80001070:	9e89                	subw	a3,a3,a0
    80001072:	00f6853b          	addw	a0,a3,a5
    80001076:	0785                	addi	a5,a5,1
    80001078:	fff7c703          	lbu	a4,-1(a5)
    8000107c:	fb7d                	bnez	a4,80001072 <strlen+0x14>
    ;
  return n;
}
    8000107e:	6422                	ld	s0,8(sp)
    80001080:	0141                	addi	sp,sp,16
    80001082:	8082                	ret
  for(n = 0; s[n]; n++)
    80001084:	4501                	li	a0,0
    80001086:	bfe5                	j	8000107e <strlen+0x20>

0000000080001088 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001088:	1141                	addi	sp,sp,-16
    8000108a:	e406                	sd	ra,8(sp)
    8000108c:	e022                	sd	s0,0(sp)
    8000108e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001090:	00001097          	auipc	ra,0x1
    80001094:	c3a080e7          	jalr	-966(ra) # 80001cca <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001098:	00008717          	auipc	a4,0x8
    8000109c:	8e070713          	addi	a4,a4,-1824 # 80008978 <started>
  if(cpuid() == 0){
    800010a0:	c139                	beqz	a0,800010e6 <main+0x5e>
    while(started == 0)
    800010a2:	431c                	lw	a5,0(a4)
    800010a4:	2781                	sext.w	a5,a5
    800010a6:	dff5                	beqz	a5,800010a2 <main+0x1a>
      ;
    __sync_synchronize();
    800010a8:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800010ac:	00001097          	auipc	ra,0x1
    800010b0:	c1e080e7          	jalr	-994(ra) # 80001cca <cpuid>
    800010b4:	85aa                	mv	a1,a0
    800010b6:	00007517          	auipc	a0,0x7
    800010ba:	03a50513          	addi	a0,a0,58 # 800080f0 <etext+0xf0>
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	4ca080e7          	jalr	1226(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	0d8080e7          	jalr	216(ra) # 8000119e <kvminithart>
    trapinithart();   // install kernel trap vector
    800010ce:	00002097          	auipc	ra,0x2
    800010d2:	aae080e7          	jalr	-1362(ra) # 80002b7c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010d6:	00005097          	auipc	ra,0x5
    800010da:	11a080e7          	jalr	282(ra) # 800061f0 <plicinithart>
  }

  scheduler();        
    800010de:	00001097          	auipc	ra,0x1
    800010e2:	122080e7          	jalr	290(ra) # 80002200 <scheduler>
    consoleinit();
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	36a080e7          	jalr	874(ra) # 80000450 <consoleinit>
    printfinit();
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	67a080e7          	jalr	1658(ra) # 80000768 <printfinit>
    printf("\n");
    800010f6:	00007517          	auipc	a0,0x7
    800010fa:	f2a50513          	addi	a0,a0,-214 # 80008020 <etext+0x20>
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	48a080e7          	jalr	1162(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    80001106:	00007517          	auipc	a0,0x7
    8000110a:	fd250513          	addi	a0,a0,-46 # 800080d8 <etext+0xd8>
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	47a080e7          	jalr	1146(ra) # 80000588 <printf>
    printf("\n");
    80001116:	00007517          	auipc	a0,0x7
    8000111a:	f0a50513          	addi	a0,a0,-246 # 80008020 <etext+0x20>
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	46a080e7          	jalr	1130(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	b54080e7          	jalr	-1196(ra) # 80000c7a <kinit>
    kvminit();       // create kernel page table
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	326080e7          	jalr	806(ra) # 80001454 <kvminit>
    kvminithart();   // turn on paging
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	068080e7          	jalr	104(ra) # 8000119e <kvminithart>
    procinit();      // process table
    8000113e:	00001097          	auipc	ra,0x1
    80001142:	ad8080e7          	jalr	-1320(ra) # 80001c16 <procinit>
    trapinit();      // trap vectors
    80001146:	00002097          	auipc	ra,0x2
    8000114a:	a0e080e7          	jalr	-1522(ra) # 80002b54 <trapinit>
    trapinithart();  // install kernel trap vector
    8000114e:	00002097          	auipc	ra,0x2
    80001152:	a2e080e7          	jalr	-1490(ra) # 80002b7c <trapinithart>
    plicinit();      // set up interrupt controller
    80001156:	00005097          	auipc	ra,0x5
    8000115a:	084080e7          	jalr	132(ra) # 800061da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	092080e7          	jalr	146(ra) # 800061f0 <plicinithart>
    binit();         // buffer cache
    80001166:	00002097          	auipc	ra,0x2
    8000116a:	238080e7          	jalr	568(ra) # 8000339e <binit>
    iinit();         // inode table
    8000116e:	00003097          	auipc	ra,0x3
    80001172:	8dc080e7          	jalr	-1828(ra) # 80003a4a <iinit>
    fileinit();      // file table
    80001176:	00004097          	auipc	ra,0x4
    8000117a:	87a080e7          	jalr	-1926(ra) # 800049f0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000117e:	00005097          	auipc	ra,0x5
    80001182:	17a080e7          	jalr	378(ra) # 800062f8 <virtio_disk_init>
    userinit();      // first user process
    80001186:	00001097          	auipc	ra,0x1
    8000118a:	e5c080e7          	jalr	-420(ra) # 80001fe2 <userinit>
    __sync_synchronize();
    8000118e:	0ff0000f          	fence
    started = 1;
    80001192:	4785                	li	a5,1
    80001194:	00007717          	auipc	a4,0x7
    80001198:	7ef72223          	sw	a5,2020(a4) # 80008978 <started>
    8000119c:	b789                	j	800010de <main+0x56>

000000008000119e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e422                	sd	s0,8(sp)
    800011a2:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800011a4:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800011a8:	00007797          	auipc	a5,0x7
    800011ac:	7d87b783          	ld	a5,2008(a5) # 80008980 <kernel_pagetable>
    800011b0:	83b1                	srli	a5,a5,0xc
    800011b2:	577d                	li	a4,-1
    800011b4:	177e                	slli	a4,a4,0x3f
    800011b6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800011b8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800011bc:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800011c0:	6422                	ld	s0,8(sp)
    800011c2:	0141                	addi	sp,sp,16
    800011c4:	8082                	ret

00000000800011c6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800011c6:	7139                	addi	sp,sp,-64
    800011c8:	fc06                	sd	ra,56(sp)
    800011ca:	f822                	sd	s0,48(sp)
    800011cc:	f426                	sd	s1,40(sp)
    800011ce:	f04a                	sd	s2,32(sp)
    800011d0:	ec4e                	sd	s3,24(sp)
    800011d2:	e852                	sd	s4,16(sp)
    800011d4:	e456                	sd	s5,8(sp)
    800011d6:	e05a                	sd	s6,0(sp)
    800011d8:	0080                	addi	s0,sp,64
    800011da:	84aa                	mv	s1,a0
    800011dc:	89ae                	mv	s3,a1
    800011de:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800011e0:	57fd                	li	a5,-1
    800011e2:	83e9                	srli	a5,a5,0x1a
    800011e4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800011e6:	4b31                	li	s6,12
  if(va >= MAXVA)
    800011e8:	04b7f263          	bgeu	a5,a1,8000122c <walk+0x66>
    panic("walk");
    800011ec:	00007517          	auipc	a0,0x7
    800011f0:	f1c50513          	addi	a0,a0,-228 # 80008108 <etext+0x108>
    800011f4:	fffff097          	auipc	ra,0xfffff
    800011f8:	34a080e7          	jalr	842(ra) # 8000053e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800011fc:	060a8663          	beqz	s5,80001268 <walk+0xa2>
    80001200:	00000097          	auipc	ra,0x0
    80001204:	ae4080e7          	jalr	-1308(ra) # 80000ce4 <kalloc>
    80001208:	84aa                	mv	s1,a0
    8000120a:	c529                	beqz	a0,80001254 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000120c:	6605                	lui	a2,0x1
    8000120e:	4581                	li	a1,0
    80001210:	00000097          	auipc	ra,0x0
    80001214:	cd2080e7          	jalr	-814(ra) # 80000ee2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001218:	00c4d793          	srli	a5,s1,0xc
    8000121c:	07aa                	slli	a5,a5,0xa
    8000121e:	0017e793          	ori	a5,a5,1
    80001222:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001226:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fdbcdcf>
    80001228:	036a0063          	beq	s4,s6,80001248 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000122c:	0149d933          	srl	s2,s3,s4
    80001230:	1ff97913          	andi	s2,s2,511
    80001234:	090e                	slli	s2,s2,0x3
    80001236:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001238:	00093483          	ld	s1,0(s2)
    8000123c:	0014f793          	andi	a5,s1,1
    80001240:	dfd5                	beqz	a5,800011fc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001242:	80a9                	srli	s1,s1,0xa
    80001244:	04b2                	slli	s1,s1,0xc
    80001246:	b7c5                	j	80001226 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001248:	00c9d513          	srli	a0,s3,0xc
    8000124c:	1ff57513          	andi	a0,a0,511
    80001250:	050e                	slli	a0,a0,0x3
    80001252:	9526                	add	a0,a0,s1
}
    80001254:	70e2                	ld	ra,56(sp)
    80001256:	7442                	ld	s0,48(sp)
    80001258:	74a2                	ld	s1,40(sp)
    8000125a:	7902                	ld	s2,32(sp)
    8000125c:	69e2                	ld	s3,24(sp)
    8000125e:	6a42                	ld	s4,16(sp)
    80001260:	6aa2                	ld	s5,8(sp)
    80001262:	6b02                	ld	s6,0(sp)
    80001264:	6121                	addi	sp,sp,64
    80001266:	8082                	ret
        return 0;
    80001268:	4501                	li	a0,0
    8000126a:	b7ed                	j	80001254 <walk+0x8e>

000000008000126c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000126c:	57fd                	li	a5,-1
    8000126e:	83e9                	srli	a5,a5,0x1a
    80001270:	00b7f463          	bgeu	a5,a1,80001278 <walkaddr+0xc>
    return 0;
    80001274:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001276:	8082                	ret
{
    80001278:	1141                	addi	sp,sp,-16
    8000127a:	e406                	sd	ra,8(sp)
    8000127c:	e022                	sd	s0,0(sp)
    8000127e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001280:	4601                	li	a2,0
    80001282:	00000097          	auipc	ra,0x0
    80001286:	f44080e7          	jalr	-188(ra) # 800011c6 <walk>
  if(pte == 0)
    8000128a:	c105                	beqz	a0,800012aa <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000128c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000128e:	0117f693          	andi	a3,a5,17
    80001292:	4745                	li	a4,17
    return 0;
    80001294:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001296:	00e68663          	beq	a3,a4,800012a2 <walkaddr+0x36>
}
    8000129a:	60a2                	ld	ra,8(sp)
    8000129c:	6402                	ld	s0,0(sp)
    8000129e:	0141                	addi	sp,sp,16
    800012a0:	8082                	ret
  pa = PTE2PA(*pte);
    800012a2:	00a7d513          	srli	a0,a5,0xa
    800012a6:	0532                	slli	a0,a0,0xc
  return pa;
    800012a8:	bfcd                	j	8000129a <walkaddr+0x2e>
    return 0;
    800012aa:	4501                	li	a0,0
    800012ac:	b7fd                	j	8000129a <walkaddr+0x2e>

00000000800012ae <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800012ae:	715d                	addi	sp,sp,-80
    800012b0:	e486                	sd	ra,72(sp)
    800012b2:	e0a2                	sd	s0,64(sp)
    800012b4:	fc26                	sd	s1,56(sp)
    800012b6:	f84a                	sd	s2,48(sp)
    800012b8:	f44e                	sd	s3,40(sp)
    800012ba:	f052                	sd	s4,32(sp)
    800012bc:	ec56                	sd	s5,24(sp)
    800012be:	e85a                	sd	s6,16(sp)
    800012c0:	e45e                	sd	s7,8(sp)
    800012c2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800012c4:	c639                	beqz	a2,80001312 <mappages+0x64>
    800012c6:	8aaa                	mv	s5,a0
    800012c8:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800012ca:	77fd                	lui	a5,0xfffff
    800012cc:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800012d0:	15fd                	addi	a1,a1,-1
    800012d2:	00c589b3          	add	s3,a1,a2
    800012d6:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800012da:	8952                	mv	s2,s4
    800012dc:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800012e0:	6b85                	lui	s7,0x1
    800012e2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800012e6:	4605                	li	a2,1
    800012e8:	85ca                	mv	a1,s2
    800012ea:	8556                	mv	a0,s5
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	eda080e7          	jalr	-294(ra) # 800011c6 <walk>
    800012f4:	cd1d                	beqz	a0,80001332 <mappages+0x84>
    if(*pte & PTE_V)
    800012f6:	611c                	ld	a5,0(a0)
    800012f8:	8b85                	andi	a5,a5,1
    800012fa:	e785                	bnez	a5,80001322 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800012fc:	80b1                	srli	s1,s1,0xc
    800012fe:	04aa                	slli	s1,s1,0xa
    80001300:	0164e4b3          	or	s1,s1,s6
    80001304:	0014e493          	ori	s1,s1,1
    80001308:	e104                	sd	s1,0(a0)
    if(a == last)
    8000130a:	05390063          	beq	s2,s3,8000134a <mappages+0x9c>
    a += PGSIZE;
    8000130e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001310:	bfc9                	j	800012e2 <mappages+0x34>
    panic("mappages: size");
    80001312:	00007517          	auipc	a0,0x7
    80001316:	dfe50513          	addi	a0,a0,-514 # 80008110 <etext+0x110>
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	224080e7          	jalr	548(ra) # 8000053e <panic>
      panic("mappages: remap");
    80001322:	00007517          	auipc	a0,0x7
    80001326:	dfe50513          	addi	a0,a0,-514 # 80008120 <etext+0x120>
    8000132a:	fffff097          	auipc	ra,0xfffff
    8000132e:	214080e7          	jalr	532(ra) # 8000053e <panic>
      return -1;
    80001332:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001334:	60a6                	ld	ra,72(sp)
    80001336:	6406                	ld	s0,64(sp)
    80001338:	74e2                	ld	s1,56(sp)
    8000133a:	7942                	ld	s2,48(sp)
    8000133c:	79a2                	ld	s3,40(sp)
    8000133e:	7a02                	ld	s4,32(sp)
    80001340:	6ae2                	ld	s5,24(sp)
    80001342:	6b42                	ld	s6,16(sp)
    80001344:	6ba2                	ld	s7,8(sp)
    80001346:	6161                	addi	sp,sp,80
    80001348:	8082                	ret
  return 0;
    8000134a:	4501                	li	a0,0
    8000134c:	b7e5                	j	80001334 <mappages+0x86>

000000008000134e <kvmmap>:
{
    8000134e:	1141                	addi	sp,sp,-16
    80001350:	e406                	sd	ra,8(sp)
    80001352:	e022                	sd	s0,0(sp)
    80001354:	0800                	addi	s0,sp,16
    80001356:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001358:	86b2                	mv	a3,a2
    8000135a:	863e                	mv	a2,a5
    8000135c:	00000097          	auipc	ra,0x0
    80001360:	f52080e7          	jalr	-174(ra) # 800012ae <mappages>
    80001364:	e509                	bnez	a0,8000136e <kvmmap+0x20>
}
    80001366:	60a2                	ld	ra,8(sp)
    80001368:	6402                	ld	s0,0(sp)
    8000136a:	0141                	addi	sp,sp,16
    8000136c:	8082                	ret
    panic("kvmmap");
    8000136e:	00007517          	auipc	a0,0x7
    80001372:	dc250513          	addi	a0,a0,-574 # 80008130 <etext+0x130>
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	1c8080e7          	jalr	456(ra) # 8000053e <panic>

000000008000137e <kvmmake>:
{
    8000137e:	1101                	addi	sp,sp,-32
    80001380:	ec06                	sd	ra,24(sp)
    80001382:	e822                	sd	s0,16(sp)
    80001384:	e426                	sd	s1,8(sp)
    80001386:	e04a                	sd	s2,0(sp)
    80001388:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	95a080e7          	jalr	-1702(ra) # 80000ce4 <kalloc>
    80001392:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001394:	6605                	lui	a2,0x1
    80001396:	4581                	li	a1,0
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	b4a080e7          	jalr	-1206(ra) # 80000ee2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800013a0:	4719                	li	a4,6
    800013a2:	6685                	lui	a3,0x1
    800013a4:	10000637          	lui	a2,0x10000
    800013a8:	100005b7          	lui	a1,0x10000
    800013ac:	8526                	mv	a0,s1
    800013ae:	00000097          	auipc	ra,0x0
    800013b2:	fa0080e7          	jalr	-96(ra) # 8000134e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800013b6:	4719                	li	a4,6
    800013b8:	6685                	lui	a3,0x1
    800013ba:	10001637          	lui	a2,0x10001
    800013be:	100015b7          	lui	a1,0x10001
    800013c2:	8526                	mv	a0,s1
    800013c4:	00000097          	auipc	ra,0x0
    800013c8:	f8a080e7          	jalr	-118(ra) # 8000134e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800013cc:	4719                	li	a4,6
    800013ce:	004006b7          	lui	a3,0x400
    800013d2:	0c000637          	lui	a2,0xc000
    800013d6:	0c0005b7          	lui	a1,0xc000
    800013da:	8526                	mv	a0,s1
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	f72080e7          	jalr	-142(ra) # 8000134e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800013e4:	00007917          	auipc	s2,0x7
    800013e8:	c1c90913          	addi	s2,s2,-996 # 80008000 <etext>
    800013ec:	4729                	li	a4,10
    800013ee:	80007697          	auipc	a3,0x80007
    800013f2:	c1268693          	addi	a3,a3,-1006 # 8000 <_entry-0x7fff8000>
    800013f6:	4605                	li	a2,1
    800013f8:	067e                	slli	a2,a2,0x1f
    800013fa:	85b2                	mv	a1,a2
    800013fc:	8526                	mv	a0,s1
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	f50080e7          	jalr	-176(ra) # 8000134e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001406:	4719                	li	a4,6
    80001408:	46c5                	li	a3,17
    8000140a:	06ee                	slli	a3,a3,0x1b
    8000140c:	412686b3          	sub	a3,a3,s2
    80001410:	864a                	mv	a2,s2
    80001412:	85ca                	mv	a1,s2
    80001414:	8526                	mv	a0,s1
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	f38080e7          	jalr	-200(ra) # 8000134e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000141e:	4729                	li	a4,10
    80001420:	6685                	lui	a3,0x1
    80001422:	00006617          	auipc	a2,0x6
    80001426:	bde60613          	addi	a2,a2,-1058 # 80007000 <_trampoline>
    8000142a:	040005b7          	lui	a1,0x4000
    8000142e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001430:	05b2                	slli	a1,a1,0xc
    80001432:	8526                	mv	a0,s1
    80001434:	00000097          	auipc	ra,0x0
    80001438:	f1a080e7          	jalr	-230(ra) # 8000134e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000143c:	8526                	mv	a0,s1
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	742080e7          	jalr	1858(ra) # 80001b80 <proc_mapstacks>
}
    80001446:	8526                	mv	a0,s1
    80001448:	60e2                	ld	ra,24(sp)
    8000144a:	6442                	ld	s0,16(sp)
    8000144c:	64a2                	ld	s1,8(sp)
    8000144e:	6902                	ld	s2,0(sp)
    80001450:	6105                	addi	sp,sp,32
    80001452:	8082                	ret

0000000080001454 <kvminit>:
{
    80001454:	1141                	addi	sp,sp,-16
    80001456:	e406                	sd	ra,8(sp)
    80001458:	e022                	sd	s0,0(sp)
    8000145a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	f22080e7          	jalr	-222(ra) # 8000137e <kvmmake>
    80001464:	00007797          	auipc	a5,0x7
    80001468:	50a7be23          	sd	a0,1308(a5) # 80008980 <kernel_pagetable>
}
    8000146c:	60a2                	ld	ra,8(sp)
    8000146e:	6402                	ld	s0,0(sp)
    80001470:	0141                	addi	sp,sp,16
    80001472:	8082                	ret

0000000080001474 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001474:	715d                	addi	sp,sp,-80
    80001476:	e486                	sd	ra,72(sp)
    80001478:	e0a2                	sd	s0,64(sp)
    8000147a:	fc26                	sd	s1,56(sp)
    8000147c:	f84a                	sd	s2,48(sp)
    8000147e:	f44e                	sd	s3,40(sp)
    80001480:	f052                	sd	s4,32(sp)
    80001482:	ec56                	sd	s5,24(sp)
    80001484:	e85a                	sd	s6,16(sp)
    80001486:	e45e                	sd	s7,8(sp)
    80001488:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000148a:	03459793          	slli	a5,a1,0x34
    8000148e:	e795                	bnez	a5,800014ba <uvmunmap+0x46>
    80001490:	8a2a                	mv	s4,a0
    80001492:	892e                	mv	s2,a1
    80001494:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001496:	0632                	slli	a2,a2,0xc
    80001498:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000149c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000149e:	6b05                	lui	s6,0x1
    800014a0:	0735e263          	bltu	a1,s3,80001504 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800014a4:	60a6                	ld	ra,72(sp)
    800014a6:	6406                	ld	s0,64(sp)
    800014a8:	74e2                	ld	s1,56(sp)
    800014aa:	7942                	ld	s2,48(sp)
    800014ac:	79a2                	ld	s3,40(sp)
    800014ae:	7a02                	ld	s4,32(sp)
    800014b0:	6ae2                	ld	s5,24(sp)
    800014b2:	6b42                	ld	s6,16(sp)
    800014b4:	6ba2                	ld	s7,8(sp)
    800014b6:	6161                	addi	sp,sp,80
    800014b8:	8082                	ret
    panic("uvmunmap: not aligned");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	c7e50513          	addi	a0,a0,-898 # 80008138 <etext+0x138>
    800014c2:	fffff097          	auipc	ra,0xfffff
    800014c6:	07c080e7          	jalr	124(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    800014ca:	00007517          	auipc	a0,0x7
    800014ce:	c8650513          	addi	a0,a0,-890 # 80008150 <etext+0x150>
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	06c080e7          	jalr	108(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	c8650513          	addi	a0,a0,-890 # 80008160 <etext+0x160>
    800014e2:	fffff097          	auipc	ra,0xfffff
    800014e6:	05c080e7          	jalr	92(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	c8e50513          	addi	a0,a0,-882 # 80008178 <etext+0x178>
    800014f2:	fffff097          	auipc	ra,0xfffff
    800014f6:	04c080e7          	jalr	76(ra) # 8000053e <panic>
    *pte = 0;
    800014fa:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014fe:	995a                	add	s2,s2,s6
    80001500:	fb3972e3          	bgeu	s2,s3,800014a4 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001504:	4601                	li	a2,0
    80001506:	85ca                	mv	a1,s2
    80001508:	8552                	mv	a0,s4
    8000150a:	00000097          	auipc	ra,0x0
    8000150e:	cbc080e7          	jalr	-836(ra) # 800011c6 <walk>
    80001512:	84aa                	mv	s1,a0
    80001514:	d95d                	beqz	a0,800014ca <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001516:	6108                	ld	a0,0(a0)
    80001518:	00157793          	andi	a5,a0,1
    8000151c:	dfdd                	beqz	a5,800014da <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000151e:	3ff57793          	andi	a5,a0,1023
    80001522:	fd7784e3          	beq	a5,s7,800014ea <uvmunmap+0x76>
    if(do_free){
    80001526:	fc0a8ae3          	beqz	s5,800014fa <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000152a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000152c:	0532                	slli	a0,a0,0xc
    8000152e:	fffff097          	auipc	ra,0xfffff
    80001532:	670080e7          	jalr	1648(ra) # 80000b9e <kfree>
    80001536:	b7d1                	j	800014fa <uvmunmap+0x86>

0000000080001538 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001538:	1101                	addi	sp,sp,-32
    8000153a:	ec06                	sd	ra,24(sp)
    8000153c:	e822                	sd	s0,16(sp)
    8000153e:	e426                	sd	s1,8(sp)
    80001540:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	7a2080e7          	jalr	1954(ra) # 80000ce4 <kalloc>
    8000154a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000154c:	c519                	beqz	a0,8000155a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000154e:	6605                	lui	a2,0x1
    80001550:	4581                	li	a1,0
    80001552:	00000097          	auipc	ra,0x0
    80001556:	990080e7          	jalr	-1648(ra) # 80000ee2 <memset>
  return pagetable;
}
    8000155a:	8526                	mv	a0,s1
    8000155c:	60e2                	ld	ra,24(sp)
    8000155e:	6442                	ld	s0,16(sp)
    80001560:	64a2                	ld	s1,8(sp)
    80001562:	6105                	addi	sp,sp,32
    80001564:	8082                	ret

0000000080001566 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001566:	7179                	addi	sp,sp,-48
    80001568:	f406                	sd	ra,40(sp)
    8000156a:	f022                	sd	s0,32(sp)
    8000156c:	ec26                	sd	s1,24(sp)
    8000156e:	e84a                	sd	s2,16(sp)
    80001570:	e44e                	sd	s3,8(sp)
    80001572:	e052                	sd	s4,0(sp)
    80001574:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001576:	6785                	lui	a5,0x1
    80001578:	04f67863          	bgeu	a2,a5,800015c8 <uvmfirst+0x62>
    8000157c:	8a2a                	mv	s4,a0
    8000157e:	89ae                	mv	s3,a1
    80001580:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	762080e7          	jalr	1890(ra) # 80000ce4 <kalloc>
    8000158a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000158c:	6605                	lui	a2,0x1
    8000158e:	4581                	li	a1,0
    80001590:	00000097          	auipc	ra,0x0
    80001594:	952080e7          	jalr	-1710(ra) # 80000ee2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001598:	4779                	li	a4,30
    8000159a:	86ca                	mv	a3,s2
    8000159c:	6605                	lui	a2,0x1
    8000159e:	4581                	li	a1,0
    800015a0:	8552                	mv	a0,s4
    800015a2:	00000097          	auipc	ra,0x0
    800015a6:	d0c080e7          	jalr	-756(ra) # 800012ae <mappages>
  memmove(mem, src, sz);
    800015aa:	8626                	mv	a2,s1
    800015ac:	85ce                	mv	a1,s3
    800015ae:	854a                	mv	a0,s2
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	98e080e7          	jalr	-1650(ra) # 80000f3e <memmove>
}
    800015b8:	70a2                	ld	ra,40(sp)
    800015ba:	7402                	ld	s0,32(sp)
    800015bc:	64e2                	ld	s1,24(sp)
    800015be:	6942                	ld	s2,16(sp)
    800015c0:	69a2                	ld	s3,8(sp)
    800015c2:	6a02                	ld	s4,0(sp)
    800015c4:	6145                	addi	sp,sp,48
    800015c6:	8082                	ret
    panic("uvmfirst: more than a page");
    800015c8:	00007517          	auipc	a0,0x7
    800015cc:	bc850513          	addi	a0,a0,-1080 # 80008190 <etext+0x190>
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	f6e080e7          	jalr	-146(ra) # 8000053e <panic>

00000000800015d8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800015d8:	1101                	addi	sp,sp,-32
    800015da:	ec06                	sd	ra,24(sp)
    800015dc:	e822                	sd	s0,16(sp)
    800015de:	e426                	sd	s1,8(sp)
    800015e0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800015e2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800015e4:	00b67d63          	bgeu	a2,a1,800015fe <uvmdealloc+0x26>
    800015e8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800015ea:	6785                	lui	a5,0x1
    800015ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ee:	00f60733          	add	a4,a2,a5
    800015f2:	767d                	lui	a2,0xfffff
    800015f4:	8f71                	and	a4,a4,a2
    800015f6:	97ae                	add	a5,a5,a1
    800015f8:	8ff1                	and	a5,a5,a2
    800015fa:	00f76863          	bltu	a4,a5,8000160a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800015fe:	8526                	mv	a0,s1
    80001600:	60e2                	ld	ra,24(sp)
    80001602:	6442                	ld	s0,16(sp)
    80001604:	64a2                	ld	s1,8(sp)
    80001606:	6105                	addi	sp,sp,32
    80001608:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000160a:	8f99                	sub	a5,a5,a4
    8000160c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000160e:	4685                	li	a3,1
    80001610:	0007861b          	sext.w	a2,a5
    80001614:	85ba                	mv	a1,a4
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	e5e080e7          	jalr	-418(ra) # 80001474 <uvmunmap>
    8000161e:	b7c5                	j	800015fe <uvmdealloc+0x26>

0000000080001620 <uvmalloc>:
  if(newsz < oldsz)
    80001620:	0ab66563          	bltu	a2,a1,800016ca <uvmalloc+0xaa>
{
    80001624:	7139                	addi	sp,sp,-64
    80001626:	fc06                	sd	ra,56(sp)
    80001628:	f822                	sd	s0,48(sp)
    8000162a:	f426                	sd	s1,40(sp)
    8000162c:	f04a                	sd	s2,32(sp)
    8000162e:	ec4e                	sd	s3,24(sp)
    80001630:	e852                	sd	s4,16(sp)
    80001632:	e456                	sd	s5,8(sp)
    80001634:	e05a                	sd	s6,0(sp)
    80001636:	0080                	addi	s0,sp,64
    80001638:	8aaa                	mv	s5,a0
    8000163a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000163c:	6985                	lui	s3,0x1
    8000163e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80001640:	95ce                	add	a1,a1,s3
    80001642:	79fd                	lui	s3,0xfffff
    80001644:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001648:	08c9f363          	bgeu	s3,a2,800016ce <uvmalloc+0xae>
    8000164c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000164e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001652:	fffff097          	auipc	ra,0xfffff
    80001656:	692080e7          	jalr	1682(ra) # 80000ce4 <kalloc>
    8000165a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000165c:	c51d                	beqz	a0,8000168a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000165e:	6605                	lui	a2,0x1
    80001660:	4581                	li	a1,0
    80001662:	00000097          	auipc	ra,0x0
    80001666:	880080e7          	jalr	-1920(ra) # 80000ee2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000166a:	875a                	mv	a4,s6
    8000166c:	86a6                	mv	a3,s1
    8000166e:	6605                	lui	a2,0x1
    80001670:	85ca                	mv	a1,s2
    80001672:	8556                	mv	a0,s5
    80001674:	00000097          	auipc	ra,0x0
    80001678:	c3a080e7          	jalr	-966(ra) # 800012ae <mappages>
    8000167c:	e90d                	bnez	a0,800016ae <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000167e:	6785                	lui	a5,0x1
    80001680:	993e                	add	s2,s2,a5
    80001682:	fd4968e3          	bltu	s2,s4,80001652 <uvmalloc+0x32>
  return newsz;
    80001686:	8552                	mv	a0,s4
    80001688:	a809                	j	8000169a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000168a:	864e                	mv	a2,s3
    8000168c:	85ca                	mv	a1,s2
    8000168e:	8556                	mv	a0,s5
    80001690:	00000097          	auipc	ra,0x0
    80001694:	f48080e7          	jalr	-184(ra) # 800015d8 <uvmdealloc>
      return 0;
    80001698:	4501                	li	a0,0
}
    8000169a:	70e2                	ld	ra,56(sp)
    8000169c:	7442                	ld	s0,48(sp)
    8000169e:	74a2                	ld	s1,40(sp)
    800016a0:	7902                	ld	s2,32(sp)
    800016a2:	69e2                	ld	s3,24(sp)
    800016a4:	6a42                	ld	s4,16(sp)
    800016a6:	6aa2                	ld	s5,8(sp)
    800016a8:	6b02                	ld	s6,0(sp)
    800016aa:	6121                	addi	sp,sp,64
    800016ac:	8082                	ret
      kfree(mem);
    800016ae:	8526                	mv	a0,s1
    800016b0:	fffff097          	auipc	ra,0xfffff
    800016b4:	4ee080e7          	jalr	1262(ra) # 80000b9e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800016b8:	864e                	mv	a2,s3
    800016ba:	85ca                	mv	a1,s2
    800016bc:	8556                	mv	a0,s5
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	f1a080e7          	jalr	-230(ra) # 800015d8 <uvmdealloc>
      return 0;
    800016c6:	4501                	li	a0,0
    800016c8:	bfc9                	j	8000169a <uvmalloc+0x7a>
    return oldsz;
    800016ca:	852e                	mv	a0,a1
}
    800016cc:	8082                	ret
  return newsz;
    800016ce:	8532                	mv	a0,a2
    800016d0:	b7e9                	j	8000169a <uvmalloc+0x7a>

00000000800016d2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800016d2:	7179                	addi	sp,sp,-48
    800016d4:	f406                	sd	ra,40(sp)
    800016d6:	f022                	sd	s0,32(sp)
    800016d8:	ec26                	sd	s1,24(sp)
    800016da:	e84a                	sd	s2,16(sp)
    800016dc:	e44e                	sd	s3,8(sp)
    800016de:	e052                	sd	s4,0(sp)
    800016e0:	1800                	addi	s0,sp,48
    800016e2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800016e4:	84aa                	mv	s1,a0
    800016e6:	6905                	lui	s2,0x1
    800016e8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800016ea:	4985                	li	s3,1
    800016ec:	a821                	j	80001704 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800016ee:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800016f0:	0532                	slli	a0,a0,0xc
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	fe0080e7          	jalr	-32(ra) # 800016d2 <freewalk>
      pagetable[i] = 0;
    800016fa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800016fe:	04a1                	addi	s1,s1,8
    80001700:	03248163          	beq	s1,s2,80001722 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001704:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001706:	00f57793          	andi	a5,a0,15
    8000170a:	ff3782e3          	beq	a5,s3,800016ee <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000170e:	8905                	andi	a0,a0,1
    80001710:	d57d                	beqz	a0,800016fe <freewalk+0x2c>
      panic("freewalk: leaf");
    80001712:	00007517          	auipc	a0,0x7
    80001716:	a9e50513          	addi	a0,a0,-1378 # 800081b0 <etext+0x1b0>
    8000171a:	fffff097          	auipc	ra,0xfffff
    8000171e:	e24080e7          	jalr	-476(ra) # 8000053e <panic>
    }
  }
  kfree((void*)pagetable);
    80001722:	8552                	mv	a0,s4
    80001724:	fffff097          	auipc	ra,0xfffff
    80001728:	47a080e7          	jalr	1146(ra) # 80000b9e <kfree>
}
    8000172c:	70a2                	ld	ra,40(sp)
    8000172e:	7402                	ld	s0,32(sp)
    80001730:	64e2                	ld	s1,24(sp)
    80001732:	6942                	ld	s2,16(sp)
    80001734:	69a2                	ld	s3,8(sp)
    80001736:	6a02                	ld	s4,0(sp)
    80001738:	6145                	addi	sp,sp,48
    8000173a:	8082                	ret

000000008000173c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000173c:	1101                	addi	sp,sp,-32
    8000173e:	ec06                	sd	ra,24(sp)
    80001740:	e822                	sd	s0,16(sp)
    80001742:	e426                	sd	s1,8(sp)
    80001744:	1000                	addi	s0,sp,32
    80001746:	84aa                	mv	s1,a0
  if(sz > 0)
    80001748:	e999                	bnez	a1,8000175e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000174a:	8526                	mv	a0,s1
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	f86080e7          	jalr	-122(ra) # 800016d2 <freewalk>
}
    80001754:	60e2                	ld	ra,24(sp)
    80001756:	6442                	ld	s0,16(sp)
    80001758:	64a2                	ld	s1,8(sp)
    8000175a:	6105                	addi	sp,sp,32
    8000175c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000175e:	6605                	lui	a2,0x1
    80001760:	167d                	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001762:	962e                	add	a2,a2,a1
    80001764:	4685                	li	a3,1
    80001766:	8231                	srli	a2,a2,0xc
    80001768:	4581                	li	a1,0
    8000176a:	00000097          	auipc	ra,0x0
    8000176e:	d0a080e7          	jalr	-758(ra) # 80001474 <uvmunmap>
    80001772:	bfe1                	j	8000174a <uvmfree+0xe>

0000000080001774 <cowalloc>:
#include "proc.h"

int
cowalloc(pagetable_t pagetable, uint64 va)
{
  if(va >= MAXVA) return -1; // Check if the virtual address is within limits
    80001774:	57fd                	li	a5,-1
    80001776:	83e9                	srli	a5,a5,0x1a
    80001778:	0eb7eb63          	bltu	a5,a1,8000186e <cowalloc+0xfa>
{
    8000177c:	7139                	addi	sp,sp,-64
    8000177e:	fc06                	sd	ra,56(sp)
    80001780:	f822                	sd	s0,48(sp)
    80001782:	f426                	sd	s1,40(sp)
    80001784:	f04a                	sd	s2,32(sp)
    80001786:	ec4e                	sd	s3,24(sp)
    80001788:	e852                	sd	s4,16(sp)
    8000178a:	e456                	sd	s5,8(sp)
    8000178c:	0080                	addi	s0,sp,64
    8000178e:	89aa                	mv	s3,a0
    80001790:	84ae                	mv	s1,a1

  uint64 pa, new_pa, va_rounded;
  int flags;

  pte_t *pte = walk(pagetable, va, 0);   // Locate page table entry for virtual address
    80001792:	4601                	li	a2,0
    80001794:	00000097          	auipc	ra,0x0
    80001798:	a32080e7          	jalr	-1486(ra) # 800011c6 <walk>
    8000179c:	892a                	mv	s2,a0

  // Check if PTE is invalid, not present, or not accessible from user mode
  if( pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    8000179e:	c971                	beqz	a0,80001872 <cowalloc+0xfe>
    800017a0:	00053a03          	ld	s4,0(a0)
    800017a4:	011a7713          	andi	a4,s4,17
    800017a8:	47c5                	li	a5,17
    800017aa:	0cf71663          	bne	a4,a5,80001876 <cowalloc+0x102>
  // struct proc *p = myproc();
  // // printing the pid and virtual address of the process that caused the COW fault
  // if(*pte & PTE_C) printf("COW fault: pid=%d va=%p\n", p->pid, va);

  // If not a COW page and no write permission, treat as invalid
  if(!(*pte & PTE_C) && !(*pte & PTE_W)) return -1;
    800017ae:	104a7793          	andi	a5,s4,260
    800017b2:	c7e1                	beqz	a5,8000187a <cowalloc+0x106>

  // If page is writable or not marked COW, it’s already suitable for writing
  if( (*pte & PTE_W) || !(*pte & PTE_C)) return 0;
    800017b4:	10000713          	li	a4,256
    800017b8:	4501                	li	a0,0
    800017ba:	00e78b63          	beq	a5,a4,800017d0 <cowalloc+0x5c>
    *pte &= ~PTE_C;     // Clear COW flag
    return 0;           // Return 0 as no additional COW handling is needed
  }

  return -1;
}
    800017be:	70e2                	ld	ra,56(sp)
    800017c0:	7442                	ld	s0,48(sp)
    800017c2:	74a2                	ld	s1,40(sp)
    800017c4:	7902                	ld	s2,32(sp)
    800017c6:	69e2                	ld	s3,24(sp)
    800017c8:	6a42                	ld	s4,16(sp)
    800017ca:	6aa2                	ld	s5,8(sp)
    800017cc:	6121                	addi	sp,sp,64
    800017ce:	8082                	ret
  pa = PTE2PA(*pte);             // Get the physical address from the PTE
    800017d0:	00aa5a93          	srli	s5,s4,0xa
    800017d4:	0ab2                	slli	s5,s5,0xc
  if(get_refcnt((void *) pa) > 1){
    800017d6:	8556                	mv	a0,s5
    800017d8:	fffff097          	auipc	ra,0xfffff
    800017dc:	35a080e7          	jalr	858(ra) # 80000b32 <get_refcnt>
    800017e0:	4785                	li	a5,1
    800017e2:	06a7d463          	bge	a5,a0,8000184a <cowalloc+0xd6>
    if((new_pa = (uint64) kalloc()) == 0) panic("cowalloc: kalloc");  // Allocate new page
    800017e6:	fffff097          	auipc	ra,0xfffff
    800017ea:	4fe080e7          	jalr	1278(ra) # 80000ce4 <kalloc>
    800017ee:	892a                	mv	s2,a0
    800017f0:	c529                	beqz	a0,8000183a <cowalloc+0xc6>
  va_rounded = PGROUNDDOWN(va);  // Round the virtual address down to page boundary
    800017f2:	75fd                	lui	a1,0xfffff
    800017f4:	8ced                	and	s1,s1,a1
    memmove((void *)new_pa, (const void *) pa, PGSIZE);   // Copy data to new page
    800017f6:	6605                	lui	a2,0x1
    800017f8:	85d6                	mv	a1,s5
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	744080e7          	jalr	1860(ra) # 80000f3e <memmove>
    uvmunmap(pagetable, va_rounded, 1, 1);                // Unmap original page
    80001802:	4685                	li	a3,1
    80001804:	4605                	li	a2,1
    80001806:	85a6                	mv	a1,s1
    80001808:	854e                	mv	a0,s3
    8000180a:	00000097          	auipc	ra,0x0
    8000180e:	c6a080e7          	jalr	-918(ra) # 80001474 <uvmunmap>
    flags &= ~PTE_C;                                      // Clear COW flag
    80001812:	2ffa7713          	andi	a4,s4,767
    if(mappages(pagetable, va_rounded, PGSIZE, new_pa, flags) != 0){
    80001816:	00476713          	ori	a4,a4,4
    8000181a:	86ca                	mv	a3,s2
    8000181c:	6605                	lui	a2,0x1
    8000181e:	85a6                	mv	a1,s1
    80001820:	854e                	mv	a0,s3
    80001822:	00000097          	auipc	ra,0x0
    80001826:	a8c080e7          	jalr	-1396(ra) # 800012ae <mappages>
    8000182a:	d951                	beqz	a0,800017be <cowalloc+0x4a>
      kfree((void *)new_pa);                              // Free new page if mapping fails
    8000182c:	854a                	mv	a0,s2
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	370080e7          	jalr	880(ra) # 80000b9e <kfree>
      return -1;
    80001836:	557d                	li	a0,-1
    80001838:	b759                	j	800017be <cowalloc+0x4a>
    if((new_pa = (uint64) kalloc()) == 0) panic("cowalloc: kalloc");  // Allocate new page
    8000183a:	00007517          	auipc	a0,0x7
    8000183e:	98650513          	addi	a0,a0,-1658 # 800081c0 <etext+0x1c0>
    80001842:	fffff097          	auipc	ra,0xfffff
    80001846:	cfc080e7          	jalr	-772(ra) # 8000053e <panic>
  } else if(get_refcnt((void *) pa) == 1){
    8000184a:	8556                	mv	a0,s5
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	2e6080e7          	jalr	742(ra) # 80000b32 <get_refcnt>
    80001854:	4785                	li	a5,1
    80001856:	02f51463          	bne	a0,a5,8000187e <cowalloc+0x10a>
    *pte &= ~PTE_C;     // Clear COW flag
    8000185a:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    8000185e:	eff7f793          	andi	a5,a5,-257
    80001862:	0047e793          	ori	a5,a5,4
    80001866:	00f93023          	sd	a5,0(s2)
    return 0;           // Return 0 as no additional COW handling is needed
    8000186a:	4501                	li	a0,0
    8000186c:	bf89                	j	800017be <cowalloc+0x4a>
  if(va >= MAXVA) return -1; // Check if the virtual address is within limits
    8000186e:	557d                	li	a0,-1
}
    80001870:	8082                	ret
  if( pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    80001872:	557d                	li	a0,-1
    80001874:	b7a9                	j	800017be <cowalloc+0x4a>
    80001876:	557d                	li	a0,-1
    80001878:	b799                	j	800017be <cowalloc+0x4a>
  if(!(*pte & PTE_C) && !(*pte & PTE_W)) return -1;
    8000187a:	557d                	li	a0,-1
    8000187c:	b789                	j	800017be <cowalloc+0x4a>
  return -1;
    8000187e:	557d                	li	a0,-1
    80001880:	bf3d                	j	800017be <cowalloc+0x4a>

0000000080001882 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001882:	7139                	addi	sp,sp,-64
    80001884:	fc06                	sd	ra,56(sp)
    80001886:	f822                	sd	s0,48(sp)
    80001888:	f426                	sd	s1,40(sp)
    8000188a:	f04a                	sd	s2,32(sp)
    8000188c:	ec4e                	sd	s3,24(sp)
    8000188e:	e852                	sd	s4,16(sp)
    80001890:	e456                	sd	s5,8(sp)
    80001892:	e05a                	sd	s6,0(sp)
    80001894:	0080                	addi	s0,sp,64
  pte_t *pte;       // Pointer to the page table entry 
  uint64 pa, i;     // pa stores the physical address
  int flags;        // Stores flags (permissions) of the page table entry

  // Loop through each page in the address space up to sz (size of the address space in bytes) 
  for(i = 0; i < sz; i += PGSIZE){
    80001896:	ca69                	beqz	a2,80001968 <uvmcopy+0xe6>
    80001898:	8b2a                	mv	s6,a0
    8000189a:	8aae                	mv	s5,a1
    8000189c:	8a32                	mv	s4,a2
    8000189e:	4901                	li	s2,0
    800018a0:	a8b9                	j	800018fe <uvmcopy+0x7c>
    
    // Walk the old page table to find the PTE for the current virtual address i
    if((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist"); // Ensure PTE exists in the old page table
    800018a2:	00007517          	auipc	a0,0x7
    800018a6:	93650513          	addi	a0,a0,-1738 # 800081d8 <etext+0x1d8>
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	c94080e7          	jalr	-876(ra) # 8000053e <panic>
    
    // Verify the page is present (PTE_V flag is set)
    // *pte & PTE_V performs a bitwise AND operation between *pte(64-bit value representing various attributes of the memory page) and PTE_V
    if((*pte & PTE_V) == 0) panic("uvmcopy: page not present"); // Panic if page is not valid
    800018b2:	00007517          	auipc	a0,0x7
    800018b6:	94650513          	addi	a0,a0,-1722 # 800081f8 <etext+0x1f8>
    800018ba:	fffff097          	auipc	ra,0xfffff
    800018be:	c84080e7          	jalr	-892(ra) # 8000053e <panic>
    
    // Extract the physical address from the page table entry
    if((pa = PTE2PA(*pte)) == 0) panic("uvmcopy: address should exist"); // Ensure physical address exists
    800018c2:	00007517          	auipc	a0,0x7
    800018c6:	95650513          	addi	a0,a0,-1706 # 80008218 <etext+0x218>
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	c74080e7          	jalr	-908(ra) # 8000053e <panic>
      *pte |= PTE_C;     // Set the Copy-On-Write (COW) flag (PTE_C) on writable pages
      *pte &= ~PTE_W;    // Clear the write flag (PTE_W) to make the page read-only and trigger a page fault on write
    }

    // Extract and store the flags from the current page table entry
    flags = PTE_FLAGS(*pte);
    800018d2:	6118                	ld	a4,0(a0)

    // Map the page in the new page table to the same physical address pa with the extracted flags
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    800018d4:	3ff77713          	andi	a4,a4,1023
    800018d8:	86a6                	mv	a3,s1
    800018da:	6605                	lui	a2,0x1
    800018dc:	85ca                	mv	a1,s2
    800018de:	8556                	mv	a0,s5
    800018e0:	00000097          	auipc	ra,0x0
    800018e4:	9ce080e7          	jalr	-1586(ra) # 800012ae <mappages>
    800018e8:	89aa                	mv	s3,a0
    800018ea:	e131                	bnez	a0,8000192e <uvmcopy+0xac>
      printf("uvmcopy: mappages\n"); // Print error message if mapping fails
      goto err;                       // Jump to error handling
    }

    // Increment the reference count of the physical page to track shared access between processes
    refcnt_inc((void *) pa);
    800018ec:	8526                	mv	a0,s1
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	168080e7          	jalr	360(ra) # 80000a56 <refcnt_inc>
  for(i = 0; i < sz; i += PGSIZE){
    800018f6:	6785                	lui	a5,0x1
    800018f8:	993e                	add	s2,s2,a5
    800018fa:	05497c63          	bgeu	s2,s4,80001952 <uvmcopy+0xd0>
    if((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist"); // Ensure PTE exists in the old page table
    800018fe:	4601                	li	a2,0
    80001900:	85ca                	mv	a1,s2
    80001902:	855a                	mv	a0,s6
    80001904:	00000097          	auipc	ra,0x0
    80001908:	8c2080e7          	jalr	-1854(ra) # 800011c6 <walk>
    8000190c:	d959                	beqz	a0,800018a2 <uvmcopy+0x20>
    if((*pte & PTE_V) == 0) panic("uvmcopy: page not present"); // Panic if page is not valid
    8000190e:	611c                	ld	a5,0(a0)
    80001910:	0017f713          	andi	a4,a5,1
    80001914:	df59                	beqz	a4,800018b2 <uvmcopy+0x30>
    if((pa = PTE2PA(*pte)) == 0) panic("uvmcopy: address should exist"); // Ensure physical address exists
    80001916:	00a7d493          	srli	s1,a5,0xa
    8000191a:	04b2                	slli	s1,s1,0xc
    8000191c:	d0dd                	beqz	s1,800018c2 <uvmcopy+0x40>
    if(*pte & PTE_W){ 
    8000191e:	0047f713          	andi	a4,a5,4
    80001922:	db45                	beqz	a4,800018d2 <uvmcopy+0x50>
      *pte &= ~PTE_W;    // Clear the write flag (PTE_W) to make the page read-only and trigger a page fault on write
    80001924:	9bed                	andi	a5,a5,-5
    80001926:	1007e793          	ori	a5,a5,256
    8000192a:	e11c                	sd	a5,0(a0)
    8000192c:	b75d                	j	800018d2 <uvmcopy+0x50>
      printf("uvmcopy: mappages\n"); // Print error message if mapping fails
    8000192e:	00007517          	auipc	a0,0x7
    80001932:	90a50513          	addi	a0,a0,-1782 # 80008238 <etext+0x238>
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	c52080e7          	jalr	-942(ra) # 80000588 <printf>
  }
  return 0;  // Successfully copied the memory

 err:
  // uvmunmap(new, 0, i / PGSIZE, 1) unmaps and frees all pages that were mapped so far in the new page table in case of an error, as part of cleanup
  uvmunmap(new, 0, i / PGSIZE, 1); // i / PGSIZE gives the number of pages copied
    8000193e:	4685                	li	a3,1
    80001940:	00c95613          	srli	a2,s2,0xc
    80001944:	4581                	li	a1,0
    80001946:	8556                	mv	a0,s5
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	b2c080e7          	jalr	-1236(ra) # 80001474 <uvmunmap>
  return -1;  // Return an error status
    80001950:	59fd                	li	s3,-1
}
    80001952:	854e                	mv	a0,s3
    80001954:	70e2                	ld	ra,56(sp)
    80001956:	7442                	ld	s0,48(sp)
    80001958:	74a2                	ld	s1,40(sp)
    8000195a:	7902                	ld	s2,32(sp)
    8000195c:	69e2                	ld	s3,24(sp)
    8000195e:	6a42                	ld	s4,16(sp)
    80001960:	6aa2                	ld	s5,8(sp)
    80001962:	6b02                	ld	s6,0(sp)
    80001964:	6121                	addi	sp,sp,64
    80001966:	8082                	ret
  return 0;  // Successfully copied the memory
    80001968:	4981                	li	s3,0
    8000196a:	b7e5                	j	80001952 <uvmcopy+0xd0>

000000008000196c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000196c:	1141                	addi	sp,sp,-16
    8000196e:	e406                	sd	ra,8(sp)
    80001970:	e022                	sd	s0,0(sp)
    80001972:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001974:	4601                	li	a2,0
    80001976:	00000097          	auipc	ra,0x0
    8000197a:	850080e7          	jalr	-1968(ra) # 800011c6 <walk>
  if(pte == 0)
    8000197e:	c901                	beqz	a0,8000198e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001980:	611c                	ld	a5,0(a0)
    80001982:	9bbd                	andi	a5,a5,-17
    80001984:	e11c                	sd	a5,0(a0)
}
    80001986:	60a2                	ld	ra,8(sp)
    80001988:	6402                	ld	s0,0(sp)
    8000198a:	0141                	addi	sp,sp,16
    8000198c:	8082                	ret
    panic("uvmclear");
    8000198e:	00007517          	auipc	a0,0x7
    80001992:	8c250513          	addi	a0,a0,-1854 # 80008250 <etext+0x250>
    80001996:	fffff097          	auipc	ra,0xfffff
    8000199a:	ba8080e7          	jalr	-1112(ra) # 8000053e <panic>

000000008000199e <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;   // Declare variables for copying process
  while(len > 0) {    // Continue until all data has been copied
    8000199e:	cebd                	beqz	a3,80001a1c <copyout+0x7e>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    800019a0:	715d                	addi	sp,sp,-80
    800019a2:	e486                	sd	ra,72(sp)
    800019a4:	e0a2                	sd	s0,64(sp)
    800019a6:	fc26                	sd	s1,56(sp)
    800019a8:	f84a                	sd	s2,48(sp)
    800019aa:	f44e                	sd	s3,40(sp)
    800019ac:	f052                	sd	s4,32(sp)
    800019ae:	ec56                	sd	s5,24(sp)
    800019b0:	e85a                	sd	s6,16(sp)
    800019b2:	e45e                	sd	s7,8(sp)
    800019b4:	e062                	sd	s8,0(sp)
    800019b6:	0880                	addi	s0,sp,80
    800019b8:	8b2a                	mv	s6,a0
    800019ba:	892e                	mv	s2,a1
    800019bc:	8ab2                	mv	s5,a2
    800019be:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);   // Align dstva to page boundary to start copying from the beginning of a page
    800019c0:	7c7d                	lui	s8,0xfffff
      return -1;    // Return -1 if COW allocation fails, as it can't proceed

    pa0 = walkaddr(pagetable, va0);   // Retrieve physical address corresponding to `va0`
    if(pa0 == 0) return -1;    // Return -1 if no valid physical address is found

    n = PGSIZE - (dstva - va0);   // Calculate the remaining bytes in the current page
    800019c2:	6b85                	lui	s7,0x1
    800019c4:	a015                	j	800019e8 <copyout+0x4a>
    if(n > len) n = len;          // If remaining bytes exceed length, limit n to length
      
    // Copy `n` bytes from kernel `src` to destination in user page at `dstva`
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800019c6:	41390933          	sub	s2,s2,s3
    800019ca:	0004861b          	sext.w	a2,s1
    800019ce:	85d6                	mv	a1,s5
    800019d0:	954a                	add	a0,a0,s2
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	56c080e7          	jalr	1388(ra) # 80000f3e <memmove>

    len -= n;    // Reduce `len` by `n` bytes, as they've been copied
    800019da:	409a0a33          	sub	s4,s4,s1
    src += n;    // Move `src` pointer forward by `n` bytes
    800019de:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;   // Move `dstva` to the start of the next page
    800019e0:	01798933          	add	s2,s3,s7
  while(len > 0) {    // Continue until all data has been copied
    800019e4:	020a0a63          	beqz	s4,80001a18 <copyout+0x7a>
    va0 = PGROUNDDOWN(dstva);   // Align dstva to page boundary to start copying from the beginning of a page
    800019e8:	018979b3          	and	s3,s2,s8
    if(cowalloc(pagetable, va0) < 0)
    800019ec:	85ce                	mv	a1,s3
    800019ee:	855a                	mv	a0,s6
    800019f0:	00000097          	auipc	ra,0x0
    800019f4:	d84080e7          	jalr	-636(ra) # 80001774 <cowalloc>
    800019f8:	02054463          	bltz	a0,80001a20 <copyout+0x82>
    pa0 = walkaddr(pagetable, va0);   // Retrieve physical address corresponding to `va0`
    800019fc:	85ce                	mv	a1,s3
    800019fe:	855a                	mv	a0,s6
    80001a00:	00000097          	auipc	ra,0x0
    80001a04:	86c080e7          	jalr	-1940(ra) # 8000126c <walkaddr>
    if(pa0 == 0) return -1;    // Return -1 if no valid physical address is found
    80001a08:	c90d                	beqz	a0,80001a3a <copyout+0x9c>
    n = PGSIZE - (dstva - va0);   // Calculate the remaining bytes in the current page
    80001a0a:	412984b3          	sub	s1,s3,s2
    80001a0e:	94de                	add	s1,s1,s7
    if(n > len) n = len;          // If remaining bytes exceed length, limit n to length
    80001a10:	fa9a7be3          	bgeu	s4,s1,800019c6 <copyout+0x28>
    80001a14:	84d2                	mv	s1,s4
    80001a16:	bf45                	j	800019c6 <copyout+0x28>
  }
  return 0;    // Return 0 upon successful copying of all bytes
    80001a18:	4501                	li	a0,0
    80001a1a:	a021                	j	80001a22 <copyout+0x84>
    80001a1c:	4501                	li	a0,0
}
    80001a1e:	8082                	ret
      return -1;    // Return -1 if COW allocation fails, as it can't proceed
    80001a20:	557d                	li	a0,-1
}
    80001a22:	60a6                	ld	ra,72(sp)
    80001a24:	6406                	ld	s0,64(sp)
    80001a26:	74e2                	ld	s1,56(sp)
    80001a28:	7942                	ld	s2,48(sp)
    80001a2a:	79a2                	ld	s3,40(sp)
    80001a2c:	7a02                	ld	s4,32(sp)
    80001a2e:	6ae2                	ld	s5,24(sp)
    80001a30:	6b42                	ld	s6,16(sp)
    80001a32:	6ba2                	ld	s7,8(sp)
    80001a34:	6c02                	ld	s8,0(sp)
    80001a36:	6161                	addi	sp,sp,80
    80001a38:	8082                	ret
    if(pa0 == 0) return -1;    // Return -1 if no valid physical address is found
    80001a3a:	557d                	li	a0,-1
    80001a3c:	b7dd                	j	80001a22 <copyout+0x84>

0000000080001a3e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001a3e:	caa5                	beqz	a3,80001aae <copyin+0x70>
{
    80001a40:	715d                	addi	sp,sp,-80
    80001a42:	e486                	sd	ra,72(sp)
    80001a44:	e0a2                	sd	s0,64(sp)
    80001a46:	fc26                	sd	s1,56(sp)
    80001a48:	f84a                	sd	s2,48(sp)
    80001a4a:	f44e                	sd	s3,40(sp)
    80001a4c:	f052                	sd	s4,32(sp)
    80001a4e:	ec56                	sd	s5,24(sp)
    80001a50:	e85a                	sd	s6,16(sp)
    80001a52:	e45e                	sd	s7,8(sp)
    80001a54:	e062                	sd	s8,0(sp)
    80001a56:	0880                	addi	s0,sp,80
    80001a58:	8b2a                	mv	s6,a0
    80001a5a:	8a2e                	mv	s4,a1
    80001a5c:	8c32                	mv	s8,a2
    80001a5e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001a60:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a62:	6a85                	lui	s5,0x1
    80001a64:	a01d                	j	80001a8a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a66:	018505b3          	add	a1,a0,s8
    80001a6a:	0004861b          	sext.w	a2,s1
    80001a6e:	412585b3          	sub	a1,a1,s2
    80001a72:	8552                	mv	a0,s4
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	4ca080e7          	jalr	1226(ra) # 80000f3e <memmove>

    len -= n;
    80001a7c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001a80:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a82:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001a86:	02098263          	beqz	s3,80001aaa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001a8a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a8e:	85ca                	mv	a1,s2
    80001a90:	855a                	mv	a0,s6
    80001a92:	fffff097          	auipc	ra,0xfffff
    80001a96:	7da080e7          	jalr	2010(ra) # 8000126c <walkaddr>
    if(pa0 == 0)
    80001a9a:	cd01                	beqz	a0,80001ab2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001a9c:	418904b3          	sub	s1,s2,s8
    80001aa0:	94d6                	add	s1,s1,s5
    if(n > len)
    80001aa2:	fc99f2e3          	bgeu	s3,s1,80001a66 <copyin+0x28>
    80001aa6:	84ce                	mv	s1,s3
    80001aa8:	bf7d                	j	80001a66 <copyin+0x28>
  }
  return 0;
    80001aaa:	4501                	li	a0,0
    80001aac:	a021                	j	80001ab4 <copyin+0x76>
    80001aae:	4501                	li	a0,0
}
    80001ab0:	8082                	ret
      return -1;
    80001ab2:	557d                	li	a0,-1
}
    80001ab4:	60a6                	ld	ra,72(sp)
    80001ab6:	6406                	ld	s0,64(sp)
    80001ab8:	74e2                	ld	s1,56(sp)
    80001aba:	7942                	ld	s2,48(sp)
    80001abc:	79a2                	ld	s3,40(sp)
    80001abe:	7a02                	ld	s4,32(sp)
    80001ac0:	6ae2                	ld	s5,24(sp)
    80001ac2:	6b42                	ld	s6,16(sp)
    80001ac4:	6ba2                	ld	s7,8(sp)
    80001ac6:	6c02                	ld	s8,0(sp)
    80001ac8:	6161                	addi	sp,sp,80
    80001aca:	8082                	ret

0000000080001acc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001acc:	c6c5                	beqz	a3,80001b74 <copyinstr+0xa8>
{
    80001ace:	715d                	addi	sp,sp,-80
    80001ad0:	e486                	sd	ra,72(sp)
    80001ad2:	e0a2                	sd	s0,64(sp)
    80001ad4:	fc26                	sd	s1,56(sp)
    80001ad6:	f84a                	sd	s2,48(sp)
    80001ad8:	f44e                	sd	s3,40(sp)
    80001ada:	f052                	sd	s4,32(sp)
    80001adc:	ec56                	sd	s5,24(sp)
    80001ade:	e85a                	sd	s6,16(sp)
    80001ae0:	e45e                	sd	s7,8(sp)
    80001ae2:	0880                	addi	s0,sp,80
    80001ae4:	8a2a                	mv	s4,a0
    80001ae6:	8b2e                	mv	s6,a1
    80001ae8:	8bb2                	mv	s7,a2
    80001aea:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001aec:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001aee:	6985                	lui	s3,0x1
    80001af0:	a035                	j	80001b1c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001af2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001af6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001af8:	0017b793          	seqz	a5,a5
    80001afc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001b00:	60a6                	ld	ra,72(sp)
    80001b02:	6406                	ld	s0,64(sp)
    80001b04:	74e2                	ld	s1,56(sp)
    80001b06:	7942                	ld	s2,48(sp)
    80001b08:	79a2                	ld	s3,40(sp)
    80001b0a:	7a02                	ld	s4,32(sp)
    80001b0c:	6ae2                	ld	s5,24(sp)
    80001b0e:	6b42                	ld	s6,16(sp)
    80001b10:	6ba2                	ld	s7,8(sp)
    80001b12:	6161                	addi	sp,sp,80
    80001b14:	8082                	ret
    srcva = va0 + PGSIZE;
    80001b16:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001b1a:	c8a9                	beqz	s1,80001b6c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001b1c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001b20:	85ca                	mv	a1,s2
    80001b22:	8552                	mv	a0,s4
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	748080e7          	jalr	1864(ra) # 8000126c <walkaddr>
    if(pa0 == 0)
    80001b2c:	c131                	beqz	a0,80001b70 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001b2e:	41790833          	sub	a6,s2,s7
    80001b32:	984e                	add	a6,a6,s3
    if(n > max)
    80001b34:	0104f363          	bgeu	s1,a6,80001b3a <copyinstr+0x6e>
    80001b38:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001b3a:	955e                	add	a0,a0,s7
    80001b3c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001b40:	fc080be3          	beqz	a6,80001b16 <copyinstr+0x4a>
    80001b44:	985a                	add	a6,a6,s6
    80001b46:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001b48:	41650633          	sub	a2,a0,s6
    80001b4c:	14fd                	addi	s1,s1,-1
    80001b4e:	9b26                	add	s6,s6,s1
    80001b50:	00f60733          	add	a4,a2,a5
    80001b54:	00074703          	lbu	a4,0(a4)
    80001b58:	df49                	beqz	a4,80001af2 <copyinstr+0x26>
        *dst = *p;
    80001b5a:	00e78023          	sb	a4,0(a5)
      --max;
    80001b5e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001b62:	0785                	addi	a5,a5,1
    while(n > 0){
    80001b64:	ff0796e3          	bne	a5,a6,80001b50 <copyinstr+0x84>
      dst++;
    80001b68:	8b42                	mv	s6,a6
    80001b6a:	b775                	j	80001b16 <copyinstr+0x4a>
    80001b6c:	4781                	li	a5,0
    80001b6e:	b769                	j	80001af8 <copyinstr+0x2c>
      return -1;
    80001b70:	557d                	li	a0,-1
    80001b72:	b779                	j	80001b00 <copyinstr+0x34>
  int got_null = 0;
    80001b74:	4781                	li	a5,0
  if(got_null){
    80001b76:	0017b793          	seqz	a5,a5
    80001b7a:	40f00533          	neg	a0,a5
}
    80001b7e:	8082                	ret

0000000080001b80 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001b80:	7139                	addi	sp,sp,-64
    80001b82:	fc06                	sd	ra,56(sp)
    80001b84:	f822                	sd	s0,48(sp)
    80001b86:	f426                	sd	s1,40(sp)
    80001b88:	f04a                	sd	s2,32(sp)
    80001b8a:	ec4e                	sd	s3,24(sp)
    80001b8c:	e852                	sd	s4,16(sp)
    80001b8e:	e456                	sd	s5,8(sp)
    80001b90:	e05a                	sd	s6,0(sp)
    80001b92:	0080                	addi	s0,sp,64
    80001b94:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001b96:	0022f497          	auipc	s1,0x22f
    80001b9a:	4b248493          	addi	s1,s1,1202 # 80231048 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001b9e:	8b26                	mv	s6,s1
    80001ba0:	00006a97          	auipc	s5,0x6
    80001ba4:	460a8a93          	addi	s5,s5,1120 # 80008000 <etext>
    80001ba8:	04000937          	lui	s2,0x4000
    80001bac:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001bae:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001bb0:	00235a17          	auipc	s4,0x235
    80001bb4:	298a0a13          	addi	s4,s4,664 # 80236e48 <tickslock>
    char *pa = kalloc();
    80001bb8:	fffff097          	auipc	ra,0xfffff
    80001bbc:	12c080e7          	jalr	300(ra) # 80000ce4 <kalloc>
    80001bc0:	862a                	mv	a2,a0
    if (pa == 0)
    80001bc2:	c131                	beqz	a0,80001c06 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001bc4:	416485b3          	sub	a1,s1,s6
    80001bc8:	858d                	srai	a1,a1,0x3
    80001bca:	000ab783          	ld	a5,0(s5)
    80001bce:	02f585b3          	mul	a1,a1,a5
    80001bd2:	2585                	addiw	a1,a1,1 # fffffffffffff001 <end+0xffffffff7fdbcdd9>
    80001bd4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bd8:	4719                	li	a4,6
    80001bda:	6685                	lui	a3,0x1
    80001bdc:	40b905b3          	sub	a1,s2,a1
    80001be0:	854e                	mv	a0,s3
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	76c080e7          	jalr	1900(ra) # 8000134e <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001bea:	17848493          	addi	s1,s1,376
    80001bee:	fd4495e3          	bne	s1,s4,80001bb8 <proc_mapstacks+0x38>
  }
}
    80001bf2:	70e2                	ld	ra,56(sp)
    80001bf4:	7442                	ld	s0,48(sp)
    80001bf6:	74a2                	ld	s1,40(sp)
    80001bf8:	7902                	ld	s2,32(sp)
    80001bfa:	69e2                	ld	s3,24(sp)
    80001bfc:	6a42                	ld	s4,16(sp)
    80001bfe:	6aa2                	ld	s5,8(sp)
    80001c00:	6b02                	ld	s6,0(sp)
    80001c02:	6121                	addi	sp,sp,64
    80001c04:	8082                	ret
      panic("kalloc");
    80001c06:	00006517          	auipc	a0,0x6
    80001c0a:	65a50513          	addi	a0,a0,1626 # 80008260 <etext+0x260>
    80001c0e:	fffff097          	auipc	ra,0xfffff
    80001c12:	930080e7          	jalr	-1744(ra) # 8000053e <panic>

0000000080001c16 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001c16:	7139                	addi	sp,sp,-64
    80001c18:	fc06                	sd	ra,56(sp)
    80001c1a:	f822                	sd	s0,48(sp)
    80001c1c:	f426                	sd	s1,40(sp)
    80001c1e:	f04a                	sd	s2,32(sp)
    80001c20:	ec4e                	sd	s3,24(sp)
    80001c22:	e852                	sd	s4,16(sp)
    80001c24:	e456                	sd	s5,8(sp)
    80001c26:	e05a                	sd	s6,0(sp)
    80001c28:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001c2a:	00006597          	auipc	a1,0x6
    80001c2e:	63e58593          	addi	a1,a1,1598 # 80008268 <etext+0x268>
    80001c32:	0022f517          	auipc	a0,0x22f
    80001c36:	fe650513          	addi	a0,a0,-26 # 80230c18 <pid_lock>
    80001c3a:	fffff097          	auipc	ra,0xfffff
    80001c3e:	11c080e7          	jalr	284(ra) # 80000d56 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001c42:	00006597          	auipc	a1,0x6
    80001c46:	62e58593          	addi	a1,a1,1582 # 80008270 <etext+0x270>
    80001c4a:	0022f517          	auipc	a0,0x22f
    80001c4e:	fe650513          	addi	a0,a0,-26 # 80230c30 <wait_lock>
    80001c52:	fffff097          	auipc	ra,0xfffff
    80001c56:	104080e7          	jalr	260(ra) # 80000d56 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001c5a:	0022f497          	auipc	s1,0x22f
    80001c5e:	3ee48493          	addi	s1,s1,1006 # 80231048 <proc>
  {
    initlock(&p->lock, "proc");
    80001c62:	00006b17          	auipc	s6,0x6
    80001c66:	61eb0b13          	addi	s6,s6,1566 # 80008280 <etext+0x280>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001c6a:	8aa6                	mv	s5,s1
    80001c6c:	00006a17          	auipc	s4,0x6
    80001c70:	394a0a13          	addi	s4,s4,916 # 80008000 <etext>
    80001c74:	04000937          	lui	s2,0x4000
    80001c78:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001c7a:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001c7c:	00235997          	auipc	s3,0x235
    80001c80:	1cc98993          	addi	s3,s3,460 # 80236e48 <tickslock>
    initlock(&p->lock, "proc");
    80001c84:	85da                	mv	a1,s6
    80001c86:	8526                	mv	a0,s1
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	0ce080e7          	jalr	206(ra) # 80000d56 <initlock>
    p->state = UNUSED;
    80001c90:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001c94:	415487b3          	sub	a5,s1,s5
    80001c98:	878d                	srai	a5,a5,0x3
    80001c9a:	000a3703          	ld	a4,0(s4)
    80001c9e:	02e787b3          	mul	a5,a5,a4
    80001ca2:	2785                	addiw	a5,a5,1
    80001ca4:	00d7979b          	slliw	a5,a5,0xd
    80001ca8:	40f907b3          	sub	a5,s2,a5
    80001cac:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001cae:	17848493          	addi	s1,s1,376
    80001cb2:	fd3499e3          	bne	s1,s3,80001c84 <procinit+0x6e>
  }
}
    80001cb6:	70e2                	ld	ra,56(sp)
    80001cb8:	7442                	ld	s0,48(sp)
    80001cba:	74a2                	ld	s1,40(sp)
    80001cbc:	7902                	ld	s2,32(sp)
    80001cbe:	69e2                	ld	s3,24(sp)
    80001cc0:	6a42                	ld	s4,16(sp)
    80001cc2:	6aa2                	ld	s5,8(sp)
    80001cc4:	6b02                	ld	s6,0(sp)
    80001cc6:	6121                	addi	sp,sp,64
    80001cc8:	8082                	ret

0000000080001cca <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001cca:	1141                	addi	sp,sp,-16
    80001ccc:	e422                	sd	s0,8(sp)
    80001cce:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cd0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001cd2:	2501                	sext.w	a0,a0
    80001cd4:	6422                	ld	s0,8(sp)
    80001cd6:	0141                	addi	sp,sp,16
    80001cd8:	8082                	ret

0000000080001cda <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001cda:	1141                	addi	sp,sp,-16
    80001cdc:	e422                	sd	s0,8(sp)
    80001cde:	0800                	addi	s0,sp,16
    80001ce0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001ce2:	2781                	sext.w	a5,a5
    80001ce4:	079e                	slli	a5,a5,0x7
  return c;
}
    80001ce6:	0022f517          	auipc	a0,0x22f
    80001cea:	f6250513          	addi	a0,a0,-158 # 80230c48 <cpus>
    80001cee:	953e                	add	a0,a0,a5
    80001cf0:	6422                	ld	s0,8(sp)
    80001cf2:	0141                	addi	sp,sp,16
    80001cf4:	8082                	ret

0000000080001cf6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001cf6:	1101                	addi	sp,sp,-32
    80001cf8:	ec06                	sd	ra,24(sp)
    80001cfa:	e822                	sd	s0,16(sp)
    80001cfc:	e426                	sd	s1,8(sp)
    80001cfe:	1000                	addi	s0,sp,32
  push_off();
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	09a080e7          	jalr	154(ra) # 80000d9a <push_off>
    80001d08:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001d0a:	2781                	sext.w	a5,a5
    80001d0c:	079e                	slli	a5,a5,0x7
    80001d0e:	0022f717          	auipc	a4,0x22f
    80001d12:	f0a70713          	addi	a4,a4,-246 # 80230c18 <pid_lock>
    80001d16:	97ba                	add	a5,a5,a4
    80001d18:	7b84                	ld	s1,48(a5)
  pop_off();
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	120080e7          	jalr	288(ra) # 80000e3a <pop_off>
  return p;
}
    80001d22:	8526                	mv	a0,s1
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	64a2                	ld	s1,8(sp)
    80001d2a:	6105                	addi	sp,sp,32
    80001d2c:	8082                	ret

0000000080001d2e <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d2e:	1141                	addi	sp,sp,-16
    80001d30:	e406                	sd	ra,8(sp)
    80001d32:	e022                	sd	s0,0(sp)
    80001d34:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	fc0080e7          	jalr	-64(ra) # 80001cf6 <myproc>
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	15c080e7          	jalr	348(ra) # 80000e9a <release>

  if (first)
    80001d46:	00007797          	auipc	a5,0x7
    80001d4a:	bca7a783          	lw	a5,-1078(a5) # 80008910 <first.1>
    80001d4e:	eb89                	bnez	a5,80001d60 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001d50:	00001097          	auipc	ra,0x1
    80001d54:	e44080e7          	jalr	-444(ra) # 80002b94 <usertrapret>
}
    80001d58:	60a2                	ld	ra,8(sp)
    80001d5a:	6402                	ld	s0,0(sp)
    80001d5c:	0141                	addi	sp,sp,16
    80001d5e:	8082                	ret
    first = 0;
    80001d60:	00007797          	auipc	a5,0x7
    80001d64:	ba07a823          	sw	zero,-1104(a5) # 80008910 <first.1>
    fsinit(ROOTDEV);
    80001d68:	4505                	li	a0,1
    80001d6a:	00002097          	auipc	ra,0x2
    80001d6e:	c60080e7          	jalr	-928(ra) # 800039ca <fsinit>
    80001d72:	bff9                	j	80001d50 <forkret+0x22>

0000000080001d74 <allocpid>:
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	e426                	sd	s1,8(sp)
    80001d7c:	e04a                	sd	s2,0(sp)
    80001d7e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001d80:	0022f917          	auipc	s2,0x22f
    80001d84:	e9890913          	addi	s2,s2,-360 # 80230c18 <pid_lock>
    80001d88:	854a                	mv	a0,s2
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	05c080e7          	jalr	92(ra) # 80000de6 <acquire>
  pid = nextpid;
    80001d92:	00007797          	auipc	a5,0x7
    80001d96:	b8278793          	addi	a5,a5,-1150 # 80008914 <nextpid>
    80001d9a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d9c:	0014871b          	addiw	a4,s1,1
    80001da0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001da2:	854a                	mv	a0,s2
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	0f6080e7          	jalr	246(ra) # 80000e9a <release>
}
    80001dac:	8526                	mv	a0,s1
    80001dae:	60e2                	ld	ra,24(sp)
    80001db0:	6442                	ld	s0,16(sp)
    80001db2:	64a2                	ld	s1,8(sp)
    80001db4:	6902                	ld	s2,0(sp)
    80001db6:	6105                	addi	sp,sp,32
    80001db8:	8082                	ret

0000000080001dba <proc_pagetable>:
{
    80001dba:	1101                	addi	sp,sp,-32
    80001dbc:	ec06                	sd	ra,24(sp)
    80001dbe:	e822                	sd	s0,16(sp)
    80001dc0:	e426                	sd	s1,8(sp)
    80001dc2:	e04a                	sd	s2,0(sp)
    80001dc4:	1000                	addi	s0,sp,32
    80001dc6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	770080e7          	jalr	1904(ra) # 80001538 <uvmcreate>
    80001dd0:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001dd2:	c121                	beqz	a0,80001e12 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001dd4:	4729                	li	a4,10
    80001dd6:	00005697          	auipc	a3,0x5
    80001dda:	22a68693          	addi	a3,a3,554 # 80007000 <_trampoline>
    80001dde:	6605                	lui	a2,0x1
    80001de0:	040005b7          	lui	a1,0x4000
    80001de4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001de6:	05b2                	slli	a1,a1,0xc
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	4c6080e7          	jalr	1222(ra) # 800012ae <mappages>
    80001df0:	02054863          	bltz	a0,80001e20 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001df4:	4719                	li	a4,6
    80001df6:	05893683          	ld	a3,88(s2)
    80001dfa:	6605                	lui	a2,0x1
    80001dfc:	020005b7          	lui	a1,0x2000
    80001e00:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e02:	05b6                	slli	a1,a1,0xd
    80001e04:	8526                	mv	a0,s1
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	4a8080e7          	jalr	1192(ra) # 800012ae <mappages>
    80001e0e:	02054163          	bltz	a0,80001e30 <proc_pagetable+0x76>
}
    80001e12:	8526                	mv	a0,s1
    80001e14:	60e2                	ld	ra,24(sp)
    80001e16:	6442                	ld	s0,16(sp)
    80001e18:	64a2                	ld	s1,8(sp)
    80001e1a:	6902                	ld	s2,0(sp)
    80001e1c:	6105                	addi	sp,sp,32
    80001e1e:	8082                	ret
    uvmfree(pagetable, 0);
    80001e20:	4581                	li	a1,0
    80001e22:	8526                	mv	a0,s1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	918080e7          	jalr	-1768(ra) # 8000173c <uvmfree>
    return 0;
    80001e2c:	4481                	li	s1,0
    80001e2e:	b7d5                	j	80001e12 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e30:	4681                	li	a3,0
    80001e32:	4605                	li	a2,1
    80001e34:	040005b7          	lui	a1,0x4000
    80001e38:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e3a:	05b2                	slli	a1,a1,0xc
    80001e3c:	8526                	mv	a0,s1
    80001e3e:	fffff097          	auipc	ra,0xfffff
    80001e42:	636080e7          	jalr	1590(ra) # 80001474 <uvmunmap>
    uvmfree(pagetable, 0);
    80001e46:	4581                	li	a1,0
    80001e48:	8526                	mv	a0,s1
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	8f2080e7          	jalr	-1806(ra) # 8000173c <uvmfree>
    return 0;
    80001e52:	4481                	li	s1,0
    80001e54:	bf7d                	j	80001e12 <proc_pagetable+0x58>

0000000080001e56 <proc_freepagetable>:
{
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	e426                	sd	s1,8(sp)
    80001e5e:	e04a                	sd	s2,0(sp)
    80001e60:	1000                	addi	s0,sp,32
    80001e62:	84aa                	mv	s1,a0
    80001e64:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e66:	4681                	li	a3,0
    80001e68:	4605                	li	a2,1
    80001e6a:	040005b7          	lui	a1,0x4000
    80001e6e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e70:	05b2                	slli	a1,a1,0xc
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	602080e7          	jalr	1538(ra) # 80001474 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e7a:	4681                	li	a3,0
    80001e7c:	4605                	li	a2,1
    80001e7e:	020005b7          	lui	a1,0x2000
    80001e82:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e84:	05b6                	slli	a1,a1,0xd
    80001e86:	8526                	mv	a0,s1
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	5ec080e7          	jalr	1516(ra) # 80001474 <uvmunmap>
  uvmfree(pagetable, sz);
    80001e90:	85ca                	mv	a1,s2
    80001e92:	8526                	mv	a0,s1
    80001e94:	00000097          	auipc	ra,0x0
    80001e98:	8a8080e7          	jalr	-1880(ra) # 8000173c <uvmfree>
}
    80001e9c:	60e2                	ld	ra,24(sp)
    80001e9e:	6442                	ld	s0,16(sp)
    80001ea0:	64a2                	ld	s1,8(sp)
    80001ea2:	6902                	ld	s2,0(sp)
    80001ea4:	6105                	addi	sp,sp,32
    80001ea6:	8082                	ret

0000000080001ea8 <freeproc>:
{
    80001ea8:	1101                	addi	sp,sp,-32
    80001eaa:	ec06                	sd	ra,24(sp)
    80001eac:	e822                	sd	s0,16(sp)
    80001eae:	e426                	sd	s1,8(sp)
    80001eb0:	1000                	addi	s0,sp,32
    80001eb2:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001eb4:	6d28                	ld	a0,88(a0)
    80001eb6:	c509                	beqz	a0,80001ec0 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	ce6080e7          	jalr	-794(ra) # 80000b9e <kfree>
  p->trapframe = 0;
    80001ec0:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ec4:	68a8                	ld	a0,80(s1)
    80001ec6:	c511                	beqz	a0,80001ed2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001ec8:	64ac                	ld	a1,72(s1)
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	f8c080e7          	jalr	-116(ra) # 80001e56 <proc_freepagetable>
  p->pagetable = 0;
    80001ed2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ed6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001eda:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ede:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ee2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ee6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001eea:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001eee:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ef2:	0004ac23          	sw	zero,24(s1)
}
    80001ef6:	60e2                	ld	ra,24(sp)
    80001ef8:	6442                	ld	s0,16(sp)
    80001efa:	64a2                	ld	s1,8(sp)
    80001efc:	6105                	addi	sp,sp,32
    80001efe:	8082                	ret

0000000080001f00 <allocproc>:
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	e04a                	sd	s2,0(sp)
    80001f0a:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001f0c:	0022f497          	auipc	s1,0x22f
    80001f10:	13c48493          	addi	s1,s1,316 # 80231048 <proc>
    80001f14:	00235917          	auipc	s2,0x235
    80001f18:	f3490913          	addi	s2,s2,-204 # 80236e48 <tickslock>
    acquire(&p->lock);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	ec8080e7          	jalr	-312(ra) # 80000de6 <acquire>
    if (p->state == UNUSED)
    80001f26:	4c9c                	lw	a5,24(s1)
    80001f28:	cf81                	beqz	a5,80001f40 <allocproc+0x40>
      release(&p->lock);
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	f6e080e7          	jalr	-146(ra) # 80000e9a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001f34:	17848493          	addi	s1,s1,376
    80001f38:	ff2492e3          	bne	s1,s2,80001f1c <allocproc+0x1c>
  return 0;
    80001f3c:	4481                	li	s1,0
    80001f3e:	a09d                	j	80001fa4 <allocproc+0xa4>
  p->pid = allocpid();
    80001f40:	00000097          	auipc	ra,0x0
    80001f44:	e34080e7          	jalr	-460(ra) # 80001d74 <allocpid>
    80001f48:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001f4a:	4785                	li	a5,1
    80001f4c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	d96080e7          	jalr	-618(ra) # 80000ce4 <kalloc>
    80001f56:	892a                	mv	s2,a0
    80001f58:	eca8                	sd	a0,88(s1)
    80001f5a:	cd21                	beqz	a0,80001fb2 <allocproc+0xb2>
  p->pagetable = proc_pagetable(p);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	e5c080e7          	jalr	-420(ra) # 80001dba <proc_pagetable>
    80001f66:	892a                	mv	s2,a0
    80001f68:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001f6a:	c125                	beqz	a0,80001fca <allocproc+0xca>
  memset(&p->context, 0, sizeof(p->context));
    80001f6c:	07000613          	li	a2,112
    80001f70:	4581                	li	a1,0
    80001f72:	06048513          	addi	a0,s1,96
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	f6c080e7          	jalr	-148(ra) # 80000ee2 <memset>
  p->context.ra = (uint64)forkret;
    80001f7e:	00000797          	auipc	a5,0x0
    80001f82:	db078793          	addi	a5,a5,-592 # 80001d2e <forkret>
    80001f86:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001f88:	60bc                	ld	a5,64(s1)
    80001f8a:	6705                	lui	a4,0x1
    80001f8c:	97ba                	add	a5,a5,a4
    80001f8e:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001f90:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001f94:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001f98:	00007797          	auipc	a5,0x7
    80001f9c:	9f87a783          	lw	a5,-1544(a5) # 80008990 <ticks>
    80001fa0:	16f4a623          	sw	a5,364(s1)
}
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	60e2                	ld	ra,24(sp)
    80001fa8:	6442                	ld	s0,16(sp)
    80001faa:	64a2                	ld	s1,8(sp)
    80001fac:	6902                	ld	s2,0(sp)
    80001fae:	6105                	addi	sp,sp,32
    80001fb0:	8082                	ret
    freeproc(p);
    80001fb2:	8526                	mv	a0,s1
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	ef4080e7          	jalr	-268(ra) # 80001ea8 <freeproc>
    release(&p->lock);
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	edc080e7          	jalr	-292(ra) # 80000e9a <release>
    return 0;
    80001fc6:	84ca                	mv	s1,s2
    80001fc8:	bff1                	j	80001fa4 <allocproc+0xa4>
    freeproc(p);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	edc080e7          	jalr	-292(ra) # 80001ea8 <freeproc>
    release(&p->lock);
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	ec4080e7          	jalr	-316(ra) # 80000e9a <release>
    return 0;
    80001fde:	84ca                	mv	s1,s2
    80001fe0:	b7d1                	j	80001fa4 <allocproc+0xa4>

0000000080001fe2 <userinit>:
{
    80001fe2:	1101                	addi	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	1000                	addi	s0,sp,32
  p = allocproc();
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	f14080e7          	jalr	-236(ra) # 80001f00 <allocproc>
    80001ff4:	84aa                	mv	s1,a0
  initproc = p;
    80001ff6:	00007797          	auipc	a5,0x7
    80001ffa:	98a7b923          	sd	a0,-1646(a5) # 80008988 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ffe:	03400613          	li	a2,52
    80002002:	00007597          	auipc	a1,0x7
    80002006:	91e58593          	addi	a1,a1,-1762 # 80008920 <initcode>
    8000200a:	6928                	ld	a0,80(a0)
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	55a080e7          	jalr	1370(ra) # 80001566 <uvmfirst>
  p->sz = PGSIZE;
    80002014:	6785                	lui	a5,0x1
    80002016:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80002018:	6cb8                	ld	a4,88(s1)
    8000201a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    8000201e:	6cb8                	ld	a4,88(s1)
    80002020:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002022:	4641                	li	a2,16
    80002024:	00006597          	auipc	a1,0x6
    80002028:	26458593          	addi	a1,a1,612 # 80008288 <etext+0x288>
    8000202c:	15848513          	addi	a0,s1,344
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	ffc080e7          	jalr	-4(ra) # 8000102c <safestrcpy>
  p->cwd = namei("/");
    80002038:	00006517          	auipc	a0,0x6
    8000203c:	26050513          	addi	a0,a0,608 # 80008298 <etext+0x298>
    80002040:	00002097          	auipc	ra,0x2
    80002044:	3ac080e7          	jalr	940(ra) # 800043ec <namei>
    80002048:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000204c:	478d                	li	a5,3
    8000204e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002050:	8526                	mv	a0,s1
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	e48080e7          	jalr	-440(ra) # 80000e9a <release>
}
    8000205a:	60e2                	ld	ra,24(sp)
    8000205c:	6442                	ld	s0,16(sp)
    8000205e:	64a2                	ld	s1,8(sp)
    80002060:	6105                	addi	sp,sp,32
    80002062:	8082                	ret

0000000080002064 <growproc>:
{
    80002064:	1101                	addi	sp,sp,-32
    80002066:	ec06                	sd	ra,24(sp)
    80002068:	e822                	sd	s0,16(sp)
    8000206a:	e426                	sd	s1,8(sp)
    8000206c:	e04a                	sd	s2,0(sp)
    8000206e:	1000                	addi	s0,sp,32
    80002070:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002072:	00000097          	auipc	ra,0x0
    80002076:	c84080e7          	jalr	-892(ra) # 80001cf6 <myproc>
    8000207a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000207c:	652c                	ld	a1,72(a0)
  if (n > 0)
    8000207e:	01204c63          	bgtz	s2,80002096 <growproc+0x32>
  else if (n < 0)
    80002082:	02094663          	bltz	s2,800020ae <growproc+0x4a>
  p->sz = sz;
    80002086:	e4ac                	sd	a1,72(s1)
  return 0;
    80002088:	4501                	li	a0,0
}
    8000208a:	60e2                	ld	ra,24(sp)
    8000208c:	6442                	ld	s0,16(sp)
    8000208e:	64a2                	ld	s1,8(sp)
    80002090:	6902                	ld	s2,0(sp)
    80002092:	6105                	addi	sp,sp,32
    80002094:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002096:	4691                	li	a3,4
    80002098:	00b90633          	add	a2,s2,a1
    8000209c:	6928                	ld	a0,80(a0)
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	582080e7          	jalr	1410(ra) # 80001620 <uvmalloc>
    800020a6:	85aa                	mv	a1,a0
    800020a8:	fd79                	bnez	a0,80002086 <growproc+0x22>
      return -1;
    800020aa:	557d                	li	a0,-1
    800020ac:	bff9                	j	8000208a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800020ae:	00b90633          	add	a2,s2,a1
    800020b2:	6928                	ld	a0,80(a0)
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	524080e7          	jalr	1316(ra) # 800015d8 <uvmdealloc>
    800020bc:	85aa                	mv	a1,a0
    800020be:	b7e1                	j	80002086 <growproc+0x22>

00000000800020c0 <fork>:
{
    800020c0:	7139                	addi	sp,sp,-64
    800020c2:	fc06                	sd	ra,56(sp)
    800020c4:	f822                	sd	s0,48(sp)
    800020c6:	f426                	sd	s1,40(sp)
    800020c8:	f04a                	sd	s2,32(sp)
    800020ca:	ec4e                	sd	s3,24(sp)
    800020cc:	e852                	sd	s4,16(sp)
    800020ce:	e456                	sd	s5,8(sp)
    800020d0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	c24080e7          	jalr	-988(ra) # 80001cf6 <myproc>
    800020da:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	e24080e7          	jalr	-476(ra) # 80001f00 <allocproc>
    800020e4:	10050c63          	beqz	a0,800021fc <fork+0x13c>
    800020e8:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800020ea:	048ab603          	ld	a2,72(s5)
    800020ee:	692c                	ld	a1,80(a0)
    800020f0:	050ab503          	ld	a0,80(s5)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	78e080e7          	jalr	1934(ra) # 80001882 <uvmcopy>
    800020fc:	04054863          	bltz	a0,8000214c <fork+0x8c>
  np->sz = p->sz;
    80002100:	048ab783          	ld	a5,72(s5)
    80002104:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002108:	058ab683          	ld	a3,88(s5)
    8000210c:	87b6                	mv	a5,a3
    8000210e:	058a3703          	ld	a4,88(s4)
    80002112:	12068693          	addi	a3,a3,288
    80002116:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000211a:	6788                	ld	a0,8(a5)
    8000211c:	6b8c                	ld	a1,16(a5)
    8000211e:	6f90                	ld	a2,24(a5)
    80002120:	01073023          	sd	a6,0(a4)
    80002124:	e708                	sd	a0,8(a4)
    80002126:	eb0c                	sd	a1,16(a4)
    80002128:	ef10                	sd	a2,24(a4)
    8000212a:	02078793          	addi	a5,a5,32
    8000212e:	02070713          	addi	a4,a4,32
    80002132:	fed792e3          	bne	a5,a3,80002116 <fork+0x56>
  np->trapframe->a0 = 0;
    80002136:	058a3783          	ld	a5,88(s4)
    8000213a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000213e:	0d0a8493          	addi	s1,s5,208
    80002142:	0d0a0913          	addi	s2,s4,208
    80002146:	150a8993          	addi	s3,s5,336
    8000214a:	a00d                	j	8000216c <fork+0xac>
    freeproc(np);
    8000214c:	8552                	mv	a0,s4
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	d5a080e7          	jalr	-678(ra) # 80001ea8 <freeproc>
    release(&np->lock);
    80002156:	8552                	mv	a0,s4
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	d42080e7          	jalr	-702(ra) # 80000e9a <release>
    return -1;
    80002160:	597d                	li	s2,-1
    80002162:	a059                	j	800021e8 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    80002164:	04a1                	addi	s1,s1,8
    80002166:	0921                	addi	s2,s2,8
    80002168:	01348b63          	beq	s1,s3,8000217e <fork+0xbe>
    if (p->ofile[i])
    8000216c:	6088                	ld	a0,0(s1)
    8000216e:	d97d                	beqz	a0,80002164 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002170:	00003097          	auipc	ra,0x3
    80002174:	912080e7          	jalr	-1774(ra) # 80004a82 <filedup>
    80002178:	00a93023          	sd	a0,0(s2)
    8000217c:	b7e5                	j	80002164 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000217e:	150ab503          	ld	a0,336(s5)
    80002182:	00002097          	auipc	ra,0x2
    80002186:	a86080e7          	jalr	-1402(ra) # 80003c08 <idup>
    8000218a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000218e:	4641                	li	a2,16
    80002190:	158a8593          	addi	a1,s5,344
    80002194:	158a0513          	addi	a0,s4,344
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	e94080e7          	jalr	-364(ra) # 8000102c <safestrcpy>
  pid = np->pid;
    800021a0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800021a4:	8552                	mv	a0,s4
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	cf4080e7          	jalr	-780(ra) # 80000e9a <release>
  acquire(&wait_lock);
    800021ae:	0022f497          	auipc	s1,0x22f
    800021b2:	a8248493          	addi	s1,s1,-1406 # 80230c30 <wait_lock>
    800021b6:	8526                	mv	a0,s1
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	c2e080e7          	jalr	-978(ra) # 80000de6 <acquire>
  np->parent = p;
    800021c0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	cd4080e7          	jalr	-812(ra) # 80000e9a <release>
  acquire(&np->lock);
    800021ce:	8552                	mv	a0,s4
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	c16080e7          	jalr	-1002(ra) # 80000de6 <acquire>
  np->state = RUNNABLE;
    800021d8:	478d                	li	a5,3
    800021da:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800021de:	8552                	mv	a0,s4
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	cba080e7          	jalr	-838(ra) # 80000e9a <release>
}
    800021e8:	854a                	mv	a0,s2
    800021ea:	70e2                	ld	ra,56(sp)
    800021ec:	7442                	ld	s0,48(sp)
    800021ee:	74a2                	ld	s1,40(sp)
    800021f0:	7902                	ld	s2,32(sp)
    800021f2:	69e2                	ld	s3,24(sp)
    800021f4:	6a42                	ld	s4,16(sp)
    800021f6:	6aa2                	ld	s5,8(sp)
    800021f8:	6121                	addi	sp,sp,64
    800021fa:	8082                	ret
    return -1;
    800021fc:	597d                	li	s2,-1
    800021fe:	b7ed                	j	800021e8 <fork+0x128>

0000000080002200 <scheduler>:
{
    80002200:	715d                	addi	sp,sp,-80
    80002202:	e486                	sd	ra,72(sp)
    80002204:	e0a2                	sd	s0,64(sp)
    80002206:	fc26                	sd	s1,56(sp)
    80002208:	f84a                	sd	s2,48(sp)
    8000220a:	f44e                	sd	s3,40(sp)
    8000220c:	f052                	sd	s4,32(sp)
    8000220e:	ec56                	sd	s5,24(sp)
    80002210:	e85a                	sd	s6,16(sp)
    80002212:	e45e                	sd	s7,8(sp)
    80002214:	e062                	sd	s8,0(sp)
    80002216:	0880                	addi	s0,sp,80
    80002218:	8792                	mv	a5,tp
  int id = r_tp();
    8000221a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000221c:	00779b13          	slli	s6,a5,0x7
    80002220:	0022f717          	auipc	a4,0x22f
    80002224:	9f870713          	addi	a4,a4,-1544 # 80230c18 <pid_lock>
    80002228:	975a                	add	a4,a4,s6
    8000222a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000222e:	0022f717          	auipc	a4,0x22f
    80002232:	a2270713          	addi	a4,a4,-1502 # 80230c50 <cpus+0x8>
    80002236:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80002238:	4c11                	li	s8,4
        c->proc = p;
    8000223a:	079e                	slli	a5,a5,0x7
    8000223c:	0022fa17          	auipc	s4,0x22f
    80002240:	9dca0a13          	addi	s4,s4,-1572 # 80230c18 <pid_lock>
    80002244:	9a3e                	add	s4,s4,a5
        found = 1;
    80002246:	4b85                	li	s7,1
    for (p = proc; p < &proc[NPROC]; p++)
    80002248:	00235997          	auipc	s3,0x235
    8000224c:	c0098993          	addi	s3,s3,-1024 # 80236e48 <tickslock>
    80002250:	a899                	j	800022a6 <scheduler+0xa6>
      release(&p->lock);
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	c46080e7          	jalr	-954(ra) # 80000e9a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000225c:	17848493          	addi	s1,s1,376
    80002260:	03348963          	beq	s1,s3,80002292 <scheduler+0x92>
      acquire(&p->lock);
    80002264:	8526                	mv	a0,s1
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	b80080e7          	jalr	-1152(ra) # 80000de6 <acquire>
      if (p->state == RUNNABLE)
    8000226e:	4c9c                	lw	a5,24(s1)
    80002270:	ff2791e3          	bne	a5,s2,80002252 <scheduler+0x52>
        p->state = RUNNING;
    80002274:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80002278:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000227c:	06048593          	addi	a1,s1,96
    80002280:	855a                	mv	a0,s6
    80002282:	00001097          	auipc	ra,0x1
    80002286:	868080e7          	jalr	-1944(ra) # 80002aea <swtch>
        c->proc = 0;
    8000228a:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000228e:	8ade                	mv	s5,s7
    80002290:	b7c9                	j	80002252 <scheduler+0x52>
    if(found == 0) {
    80002292:	000a9a63          	bnez	s5,800022a6 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002296:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000229a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000229e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800022a2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800022aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800022ae:	10079073          	csrw	sstatus,a5
    int found = 0;
    800022b2:	4a81                	li	s5,0
    for (p = proc; p < &proc[NPROC]; p++)
    800022b4:	0022f497          	auipc	s1,0x22f
    800022b8:	d9448493          	addi	s1,s1,-620 # 80231048 <proc>
      if (p->state == RUNNABLE)
    800022bc:	490d                	li	s2,3
    800022be:	b75d                	j	80002264 <scheduler+0x64>

00000000800022c0 <sched>:
{
    800022c0:	7179                	addi	sp,sp,-48
    800022c2:	f406                	sd	ra,40(sp)
    800022c4:	f022                	sd	s0,32(sp)
    800022c6:	ec26                	sd	s1,24(sp)
    800022c8:	e84a                	sd	s2,16(sp)
    800022ca:	e44e                	sd	s3,8(sp)
    800022cc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	a28080e7          	jalr	-1496(ra) # 80001cf6 <myproc>
    800022d6:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	a94080e7          	jalr	-1388(ra) # 80000d6c <holding>
    800022e0:	c93d                	beqz	a0,80002356 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022e2:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800022e4:	2781                	sext.w	a5,a5
    800022e6:	079e                	slli	a5,a5,0x7
    800022e8:	0022f717          	auipc	a4,0x22f
    800022ec:	93070713          	addi	a4,a4,-1744 # 80230c18 <pid_lock>
    800022f0:	97ba                	add	a5,a5,a4
    800022f2:	0a87a703          	lw	a4,168(a5)
    800022f6:	4785                	li	a5,1
    800022f8:	06f71763          	bne	a4,a5,80002366 <sched+0xa6>
  if (p->state == RUNNING)
    800022fc:	4c98                	lw	a4,24(s1)
    800022fe:	4791                	li	a5,4
    80002300:	06f70b63          	beq	a4,a5,80002376 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002304:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002308:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000230a:	efb5                	bnez	a5,80002386 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000230c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000230e:	0022f917          	auipc	s2,0x22f
    80002312:	90a90913          	addi	s2,s2,-1782 # 80230c18 <pid_lock>
    80002316:	2781                	sext.w	a5,a5
    80002318:	079e                	slli	a5,a5,0x7
    8000231a:	97ca                	add	a5,a5,s2
    8000231c:	0ac7a983          	lw	s3,172(a5)
    80002320:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002322:	2781                	sext.w	a5,a5
    80002324:	079e                	slli	a5,a5,0x7
    80002326:	0022f597          	auipc	a1,0x22f
    8000232a:	92a58593          	addi	a1,a1,-1750 # 80230c50 <cpus+0x8>
    8000232e:	95be                	add	a1,a1,a5
    80002330:	06048513          	addi	a0,s1,96
    80002334:	00000097          	auipc	ra,0x0
    80002338:	7b6080e7          	jalr	1974(ra) # 80002aea <swtch>
    8000233c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000233e:	2781                	sext.w	a5,a5
    80002340:	079e                	slli	a5,a5,0x7
    80002342:	97ca                	add	a5,a5,s2
    80002344:	0b37a623          	sw	s3,172(a5)
}
    80002348:	70a2                	ld	ra,40(sp)
    8000234a:	7402                	ld	s0,32(sp)
    8000234c:	64e2                	ld	s1,24(sp)
    8000234e:	6942                	ld	s2,16(sp)
    80002350:	69a2                	ld	s3,8(sp)
    80002352:	6145                	addi	sp,sp,48
    80002354:	8082                	ret
    panic("sched p->lock");
    80002356:	00006517          	auipc	a0,0x6
    8000235a:	f4a50513          	addi	a0,a0,-182 # 800082a0 <etext+0x2a0>
    8000235e:	ffffe097          	auipc	ra,0xffffe
    80002362:	1e0080e7          	jalr	480(ra) # 8000053e <panic>
    panic("sched locks");
    80002366:	00006517          	auipc	a0,0x6
    8000236a:	f4a50513          	addi	a0,a0,-182 # 800082b0 <etext+0x2b0>
    8000236e:	ffffe097          	auipc	ra,0xffffe
    80002372:	1d0080e7          	jalr	464(ra) # 8000053e <panic>
    panic("sched running");
    80002376:	00006517          	auipc	a0,0x6
    8000237a:	f4a50513          	addi	a0,a0,-182 # 800082c0 <etext+0x2c0>
    8000237e:	ffffe097          	auipc	ra,0xffffe
    80002382:	1c0080e7          	jalr	448(ra) # 8000053e <panic>
    panic("sched interruptible");
    80002386:	00006517          	auipc	a0,0x6
    8000238a:	f4a50513          	addi	a0,a0,-182 # 800082d0 <etext+0x2d0>
    8000238e:	ffffe097          	auipc	ra,0xffffe
    80002392:	1b0080e7          	jalr	432(ra) # 8000053e <panic>

0000000080002396 <yield>:
{
    80002396:	1101                	addi	sp,sp,-32
    80002398:	ec06                	sd	ra,24(sp)
    8000239a:	e822                	sd	s0,16(sp)
    8000239c:	e426                	sd	s1,8(sp)
    8000239e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800023a0:	00000097          	auipc	ra,0x0
    800023a4:	956080e7          	jalr	-1706(ra) # 80001cf6 <myproc>
    800023a8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	a3c080e7          	jalr	-1476(ra) # 80000de6 <acquire>
  p->state = RUNNABLE;
    800023b2:	478d                	li	a5,3
    800023b4:	cc9c                	sw	a5,24(s1)
  sched();
    800023b6:	00000097          	auipc	ra,0x0
    800023ba:	f0a080e7          	jalr	-246(ra) # 800022c0 <sched>
  release(&p->lock);
    800023be:	8526                	mv	a0,s1
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	ada080e7          	jalr	-1318(ra) # 80000e9a <release>
}
    800023c8:	60e2                	ld	ra,24(sp)
    800023ca:	6442                	ld	s0,16(sp)
    800023cc:	64a2                	ld	s1,8(sp)
    800023ce:	6105                	addi	sp,sp,32
    800023d0:	8082                	ret

00000000800023d2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800023d2:	7179                	addi	sp,sp,-48
    800023d4:	f406                	sd	ra,40(sp)
    800023d6:	f022                	sd	s0,32(sp)
    800023d8:	ec26                	sd	s1,24(sp)
    800023da:	e84a                	sd	s2,16(sp)
    800023dc:	e44e                	sd	s3,8(sp)
    800023de:	1800                	addi	s0,sp,48
    800023e0:	89aa                	mv	s3,a0
    800023e2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800023e4:	00000097          	auipc	ra,0x0
    800023e8:	912080e7          	jalr	-1774(ra) # 80001cf6 <myproc>
    800023ec:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	9f8080e7          	jalr	-1544(ra) # 80000de6 <acquire>
  release(lk);
    800023f6:	854a                	mv	a0,s2
    800023f8:	fffff097          	auipc	ra,0xfffff
    800023fc:	aa2080e7          	jalr	-1374(ra) # 80000e9a <release>

  // Go to sleep.
  p->chan = chan;
    80002400:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002404:	4789                	li	a5,2
    80002406:	cc9c                	sw	a5,24(s1)

  sched();
    80002408:	00000097          	auipc	ra,0x0
    8000240c:	eb8080e7          	jalr	-328(ra) # 800022c0 <sched>

  // Tidy up.
  p->chan = 0;
    80002410:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	a84080e7          	jalr	-1404(ra) # 80000e9a <release>
  acquire(lk);
    8000241e:	854a                	mv	a0,s2
    80002420:	fffff097          	auipc	ra,0xfffff
    80002424:	9c6080e7          	jalr	-1594(ra) # 80000de6 <acquire>
}
    80002428:	70a2                	ld	ra,40(sp)
    8000242a:	7402                	ld	s0,32(sp)
    8000242c:	64e2                	ld	s1,24(sp)
    8000242e:	6942                	ld	s2,16(sp)
    80002430:	69a2                	ld	s3,8(sp)
    80002432:	6145                	addi	sp,sp,48
    80002434:	8082                	ret

0000000080002436 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002436:	7139                	addi	sp,sp,-64
    80002438:	fc06                	sd	ra,56(sp)
    8000243a:	f822                	sd	s0,48(sp)
    8000243c:	f426                	sd	s1,40(sp)
    8000243e:	f04a                	sd	s2,32(sp)
    80002440:	ec4e                	sd	s3,24(sp)
    80002442:	e852                	sd	s4,16(sp)
    80002444:	e456                	sd	s5,8(sp)
    80002446:	0080                	addi	s0,sp,64
    80002448:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000244a:	0022f497          	auipc	s1,0x22f
    8000244e:	bfe48493          	addi	s1,s1,-1026 # 80231048 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002452:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    80002454:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002456:	00235917          	auipc	s2,0x235
    8000245a:	9f290913          	addi	s2,s2,-1550 # 80236e48 <tickslock>
    8000245e:	a811                	j	80002472 <wakeup+0x3c>
      }
      release(&p->lock);
    80002460:	8526                	mv	a0,s1
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	a38080e7          	jalr	-1480(ra) # 80000e9a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000246a:	17848493          	addi	s1,s1,376
    8000246e:	03248663          	beq	s1,s2,8000249a <wakeup+0x64>
    if (p != myproc())
    80002472:	00000097          	auipc	ra,0x0
    80002476:	884080e7          	jalr	-1916(ra) # 80001cf6 <myproc>
    8000247a:	fea488e3          	beq	s1,a0,8000246a <wakeup+0x34>
      acquire(&p->lock);
    8000247e:	8526                	mv	a0,s1
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	966080e7          	jalr	-1690(ra) # 80000de6 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80002488:	4c9c                	lw	a5,24(s1)
    8000248a:	fd379be3          	bne	a5,s3,80002460 <wakeup+0x2a>
    8000248e:	709c                	ld	a5,32(s1)
    80002490:	fd4798e3          	bne	a5,s4,80002460 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002494:	0154ac23          	sw	s5,24(s1)
    80002498:	b7e1                	j	80002460 <wakeup+0x2a>
    }
  }
}
    8000249a:	70e2                	ld	ra,56(sp)
    8000249c:	7442                	ld	s0,48(sp)
    8000249e:	74a2                	ld	s1,40(sp)
    800024a0:	7902                	ld	s2,32(sp)
    800024a2:	69e2                	ld	s3,24(sp)
    800024a4:	6a42                	ld	s4,16(sp)
    800024a6:	6aa2                	ld	s5,8(sp)
    800024a8:	6121                	addi	sp,sp,64
    800024aa:	8082                	ret

00000000800024ac <reparent>:
{
    800024ac:	7179                	addi	sp,sp,-48
    800024ae:	f406                	sd	ra,40(sp)
    800024b0:	f022                	sd	s0,32(sp)
    800024b2:	ec26                	sd	s1,24(sp)
    800024b4:	e84a                	sd	s2,16(sp)
    800024b6:	e44e                	sd	s3,8(sp)
    800024b8:	e052                	sd	s4,0(sp)
    800024ba:	1800                	addi	s0,sp,48
    800024bc:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800024be:	0022f497          	auipc	s1,0x22f
    800024c2:	b8a48493          	addi	s1,s1,-1142 # 80231048 <proc>
      pp->parent = initproc;
    800024c6:	00006a17          	auipc	s4,0x6
    800024ca:	4c2a0a13          	addi	s4,s4,1218 # 80008988 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800024ce:	00235997          	auipc	s3,0x235
    800024d2:	97a98993          	addi	s3,s3,-1670 # 80236e48 <tickslock>
    800024d6:	a029                	j	800024e0 <reparent+0x34>
    800024d8:	17848493          	addi	s1,s1,376
    800024dc:	01348d63          	beq	s1,s3,800024f6 <reparent+0x4a>
    if (pp->parent == p)
    800024e0:	7c9c                	ld	a5,56(s1)
    800024e2:	ff279be3          	bne	a5,s2,800024d8 <reparent+0x2c>
      pp->parent = initproc;
    800024e6:	000a3503          	ld	a0,0(s4)
    800024ea:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800024ec:	00000097          	auipc	ra,0x0
    800024f0:	f4a080e7          	jalr	-182(ra) # 80002436 <wakeup>
    800024f4:	b7d5                	j	800024d8 <reparent+0x2c>
}
    800024f6:	70a2                	ld	ra,40(sp)
    800024f8:	7402                	ld	s0,32(sp)
    800024fa:	64e2                	ld	s1,24(sp)
    800024fc:	6942                	ld	s2,16(sp)
    800024fe:	69a2                	ld	s3,8(sp)
    80002500:	6a02                	ld	s4,0(sp)
    80002502:	6145                	addi	sp,sp,48
    80002504:	8082                	ret

0000000080002506 <exit>:
{
    80002506:	7179                	addi	sp,sp,-48
    80002508:	f406                	sd	ra,40(sp)
    8000250a:	f022                	sd	s0,32(sp)
    8000250c:	ec26                	sd	s1,24(sp)
    8000250e:	e84a                	sd	s2,16(sp)
    80002510:	e44e                	sd	s3,8(sp)
    80002512:	e052                	sd	s4,0(sp)
    80002514:	1800                	addi	s0,sp,48
    80002516:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002518:	fffff097          	auipc	ra,0xfffff
    8000251c:	7de080e7          	jalr	2014(ra) # 80001cf6 <myproc>
    80002520:	89aa                	mv	s3,a0
  if (p == initproc)
    80002522:	00006797          	auipc	a5,0x6
    80002526:	4667b783          	ld	a5,1126(a5) # 80008988 <initproc>
    8000252a:	0d050493          	addi	s1,a0,208
    8000252e:	15050913          	addi	s2,a0,336
    80002532:	02a79363          	bne	a5,a0,80002558 <exit+0x52>
    panic("init exiting");
    80002536:	00006517          	auipc	a0,0x6
    8000253a:	db250513          	addi	a0,a0,-590 # 800082e8 <etext+0x2e8>
    8000253e:	ffffe097          	auipc	ra,0xffffe
    80002542:	000080e7          	jalr	ra # 8000053e <panic>
      fileclose(f);
    80002546:	00002097          	auipc	ra,0x2
    8000254a:	58e080e7          	jalr	1422(ra) # 80004ad4 <fileclose>
      p->ofile[fd] = 0;
    8000254e:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002552:	04a1                	addi	s1,s1,8
    80002554:	01248563          	beq	s1,s2,8000255e <exit+0x58>
    if (p->ofile[fd])
    80002558:	6088                	ld	a0,0(s1)
    8000255a:	f575                	bnez	a0,80002546 <exit+0x40>
    8000255c:	bfdd                	j	80002552 <exit+0x4c>
  begin_op();
    8000255e:	00002097          	auipc	ra,0x2
    80002562:	0aa080e7          	jalr	170(ra) # 80004608 <begin_op>
  iput(p->cwd);
    80002566:	1509b503          	ld	a0,336(s3)
    8000256a:	00002097          	auipc	ra,0x2
    8000256e:	896080e7          	jalr	-1898(ra) # 80003e00 <iput>
  end_op();
    80002572:	00002097          	auipc	ra,0x2
    80002576:	116080e7          	jalr	278(ra) # 80004688 <end_op>
  p->cwd = 0;
    8000257a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000257e:	0022e497          	auipc	s1,0x22e
    80002582:	6b248493          	addi	s1,s1,1714 # 80230c30 <wait_lock>
    80002586:	8526                	mv	a0,s1
    80002588:	fffff097          	auipc	ra,0xfffff
    8000258c:	85e080e7          	jalr	-1954(ra) # 80000de6 <acquire>
  reparent(p);
    80002590:	854e                	mv	a0,s3
    80002592:	00000097          	auipc	ra,0x0
    80002596:	f1a080e7          	jalr	-230(ra) # 800024ac <reparent>
  wakeup(p->parent);
    8000259a:	0389b503          	ld	a0,56(s3)
    8000259e:	00000097          	auipc	ra,0x0
    800025a2:	e98080e7          	jalr	-360(ra) # 80002436 <wakeup>
  acquire(&p->lock);
    800025a6:	854e                	mv	a0,s3
    800025a8:	fffff097          	auipc	ra,0xfffff
    800025ac:	83e080e7          	jalr	-1986(ra) # 80000de6 <acquire>
  p->xstate = status;
    800025b0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800025b4:	4795                	li	a5,5
    800025b6:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800025ba:	00006797          	auipc	a5,0x6
    800025be:	3d67a783          	lw	a5,982(a5) # 80008990 <ticks>
    800025c2:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    800025c6:	8526                	mv	a0,s1
    800025c8:	fffff097          	auipc	ra,0xfffff
    800025cc:	8d2080e7          	jalr	-1838(ra) # 80000e9a <release>
  sched();
    800025d0:	00000097          	auipc	ra,0x0
    800025d4:	cf0080e7          	jalr	-784(ra) # 800022c0 <sched>
  panic("zombie exit");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	d2050513          	addi	a0,a0,-736 # 800082f8 <etext+0x2f8>
    800025e0:	ffffe097          	auipc	ra,0xffffe
    800025e4:	f5e080e7          	jalr	-162(ra) # 8000053e <panic>

00000000800025e8 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800025e8:	7179                	addi	sp,sp,-48
    800025ea:	f406                	sd	ra,40(sp)
    800025ec:	f022                	sd	s0,32(sp)
    800025ee:	ec26                	sd	s1,24(sp)
    800025f0:	e84a                	sd	s2,16(sp)
    800025f2:	e44e                	sd	s3,8(sp)
    800025f4:	1800                	addi	s0,sp,48
    800025f6:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800025f8:	0022f497          	auipc	s1,0x22f
    800025fc:	a5048493          	addi	s1,s1,-1456 # 80231048 <proc>
    80002600:	00235997          	auipc	s3,0x235
    80002604:	84898993          	addi	s3,s3,-1976 # 80236e48 <tickslock>
  {
    acquire(&p->lock);
    80002608:	8526                	mv	a0,s1
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	7dc080e7          	jalr	2012(ra) # 80000de6 <acquire>
    if (p->pid == pid)
    80002612:	589c                	lw	a5,48(s1)
    80002614:	01278d63          	beq	a5,s2,8000262e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002618:	8526                	mv	a0,s1
    8000261a:	fffff097          	auipc	ra,0xfffff
    8000261e:	880080e7          	jalr	-1920(ra) # 80000e9a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002622:	17848493          	addi	s1,s1,376
    80002626:	ff3491e3          	bne	s1,s3,80002608 <kill+0x20>
  }
  return -1;
    8000262a:	557d                	li	a0,-1
    8000262c:	a829                	j	80002646 <kill+0x5e>
      p->killed = 1;
    8000262e:	4785                	li	a5,1
    80002630:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002632:	4c98                	lw	a4,24(s1)
    80002634:	4789                	li	a5,2
    80002636:	00f70f63          	beq	a4,a5,80002654 <kill+0x6c>
      release(&p->lock);
    8000263a:	8526                	mv	a0,s1
    8000263c:	fffff097          	auipc	ra,0xfffff
    80002640:	85e080e7          	jalr	-1954(ra) # 80000e9a <release>
      return 0;
    80002644:	4501                	li	a0,0
}
    80002646:	70a2                	ld	ra,40(sp)
    80002648:	7402                	ld	s0,32(sp)
    8000264a:	64e2                	ld	s1,24(sp)
    8000264c:	6942                	ld	s2,16(sp)
    8000264e:	69a2                	ld	s3,8(sp)
    80002650:	6145                	addi	sp,sp,48
    80002652:	8082                	ret
        p->state = RUNNABLE;
    80002654:	478d                	li	a5,3
    80002656:	cc9c                	sw	a5,24(s1)
    80002658:	b7cd                	j	8000263a <kill+0x52>

000000008000265a <setkilled>:

void setkilled(struct proc *p)
{
    8000265a:	1101                	addi	sp,sp,-32
    8000265c:	ec06                	sd	ra,24(sp)
    8000265e:	e822                	sd	s0,16(sp)
    80002660:	e426                	sd	s1,8(sp)
    80002662:	1000                	addi	s0,sp,32
    80002664:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002666:	ffffe097          	auipc	ra,0xffffe
    8000266a:	780080e7          	jalr	1920(ra) # 80000de6 <acquire>
  p->killed = 1;
    8000266e:	4785                	li	a5,1
    80002670:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002672:	8526                	mv	a0,s1
    80002674:	fffff097          	auipc	ra,0xfffff
    80002678:	826080e7          	jalr	-2010(ra) # 80000e9a <release>
}
    8000267c:	60e2                	ld	ra,24(sp)
    8000267e:	6442                	ld	s0,16(sp)
    80002680:	64a2                	ld	s1,8(sp)
    80002682:	6105                	addi	sp,sp,32
    80002684:	8082                	ret

0000000080002686 <killed>:

int killed(struct proc *p)
{
    80002686:	1101                	addi	sp,sp,-32
    80002688:	ec06                	sd	ra,24(sp)
    8000268a:	e822                	sd	s0,16(sp)
    8000268c:	e426                	sd	s1,8(sp)
    8000268e:	e04a                	sd	s2,0(sp)
    80002690:	1000                	addi	s0,sp,32
    80002692:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	752080e7          	jalr	1874(ra) # 80000de6 <acquire>
  k = p->killed;
    8000269c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800026a0:	8526                	mv	a0,s1
    800026a2:	ffffe097          	auipc	ra,0xffffe
    800026a6:	7f8080e7          	jalr	2040(ra) # 80000e9a <release>
  return k;
}
    800026aa:	854a                	mv	a0,s2
    800026ac:	60e2                	ld	ra,24(sp)
    800026ae:	6442                	ld	s0,16(sp)
    800026b0:	64a2                	ld	s1,8(sp)
    800026b2:	6902                	ld	s2,0(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret

00000000800026b8 <wait>:
{
    800026b8:	715d                	addi	sp,sp,-80
    800026ba:	e486                	sd	ra,72(sp)
    800026bc:	e0a2                	sd	s0,64(sp)
    800026be:	fc26                	sd	s1,56(sp)
    800026c0:	f84a                	sd	s2,48(sp)
    800026c2:	f44e                	sd	s3,40(sp)
    800026c4:	f052                	sd	s4,32(sp)
    800026c6:	ec56                	sd	s5,24(sp)
    800026c8:	e85a                	sd	s6,16(sp)
    800026ca:	e45e                	sd	s7,8(sp)
    800026cc:	e062                	sd	s8,0(sp)
    800026ce:	0880                	addi	s0,sp,80
    800026d0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800026d2:	fffff097          	auipc	ra,0xfffff
    800026d6:	624080e7          	jalr	1572(ra) # 80001cf6 <myproc>
    800026da:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800026dc:	0022e517          	auipc	a0,0x22e
    800026e0:	55450513          	addi	a0,a0,1364 # 80230c30 <wait_lock>
    800026e4:	ffffe097          	auipc	ra,0xffffe
    800026e8:	702080e7          	jalr	1794(ra) # 80000de6 <acquire>
    havekids = 0;
    800026ec:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    800026ee:	4a15                	li	s4,5
        havekids = 1;
    800026f0:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800026f2:	00234997          	auipc	s3,0x234
    800026f6:	75698993          	addi	s3,s3,1878 # 80236e48 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800026fa:	0022ec17          	auipc	s8,0x22e
    800026fe:	536c0c13          	addi	s8,s8,1334 # 80230c30 <wait_lock>
    havekids = 0;
    80002702:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002704:	0022f497          	auipc	s1,0x22f
    80002708:	94448493          	addi	s1,s1,-1724 # 80231048 <proc>
    8000270c:	a0bd                	j	8000277a <wait+0xc2>
          pid = pp->pid;
    8000270e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002712:	000b0e63          	beqz	s6,8000272e <wait+0x76>
    80002716:	4691                	li	a3,4
    80002718:	02c48613          	addi	a2,s1,44
    8000271c:	85da                	mv	a1,s6
    8000271e:	05093503          	ld	a0,80(s2)
    80002722:	fffff097          	auipc	ra,0xfffff
    80002726:	27c080e7          	jalr	636(ra) # 8000199e <copyout>
    8000272a:	02054563          	bltz	a0,80002754 <wait+0x9c>
          freeproc(pp);
    8000272e:	8526                	mv	a0,s1
    80002730:	fffff097          	auipc	ra,0xfffff
    80002734:	778080e7          	jalr	1912(ra) # 80001ea8 <freeproc>
          release(&pp->lock);
    80002738:	8526                	mv	a0,s1
    8000273a:	ffffe097          	auipc	ra,0xffffe
    8000273e:	760080e7          	jalr	1888(ra) # 80000e9a <release>
          release(&wait_lock);
    80002742:	0022e517          	auipc	a0,0x22e
    80002746:	4ee50513          	addi	a0,a0,1262 # 80230c30 <wait_lock>
    8000274a:	ffffe097          	auipc	ra,0xffffe
    8000274e:	750080e7          	jalr	1872(ra) # 80000e9a <release>
          return pid;
    80002752:	a0b5                	j	800027be <wait+0x106>
            release(&pp->lock);
    80002754:	8526                	mv	a0,s1
    80002756:	ffffe097          	auipc	ra,0xffffe
    8000275a:	744080e7          	jalr	1860(ra) # 80000e9a <release>
            release(&wait_lock);
    8000275e:	0022e517          	auipc	a0,0x22e
    80002762:	4d250513          	addi	a0,a0,1234 # 80230c30 <wait_lock>
    80002766:	ffffe097          	auipc	ra,0xffffe
    8000276a:	734080e7          	jalr	1844(ra) # 80000e9a <release>
            return -1;
    8000276e:	59fd                	li	s3,-1
    80002770:	a0b9                	j	800027be <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002772:	17848493          	addi	s1,s1,376
    80002776:	03348463          	beq	s1,s3,8000279e <wait+0xe6>
      if (pp->parent == p)
    8000277a:	7c9c                	ld	a5,56(s1)
    8000277c:	ff279be3          	bne	a5,s2,80002772 <wait+0xba>
        acquire(&pp->lock);
    80002780:	8526                	mv	a0,s1
    80002782:	ffffe097          	auipc	ra,0xffffe
    80002786:	664080e7          	jalr	1636(ra) # 80000de6 <acquire>
        if (pp->state == ZOMBIE)
    8000278a:	4c9c                	lw	a5,24(s1)
    8000278c:	f94781e3          	beq	a5,s4,8000270e <wait+0x56>
        release(&pp->lock);
    80002790:	8526                	mv	a0,s1
    80002792:	ffffe097          	auipc	ra,0xffffe
    80002796:	708080e7          	jalr	1800(ra) # 80000e9a <release>
        havekids = 1;
    8000279a:	8756                	mv	a4,s5
    8000279c:	bfd9                	j	80002772 <wait+0xba>
    if (!havekids || killed(p))
    8000279e:	c719                	beqz	a4,800027ac <wait+0xf4>
    800027a0:	854a                	mv	a0,s2
    800027a2:	00000097          	auipc	ra,0x0
    800027a6:	ee4080e7          	jalr	-284(ra) # 80002686 <killed>
    800027aa:	c51d                	beqz	a0,800027d8 <wait+0x120>
      release(&wait_lock);
    800027ac:	0022e517          	auipc	a0,0x22e
    800027b0:	48450513          	addi	a0,a0,1156 # 80230c30 <wait_lock>
    800027b4:	ffffe097          	auipc	ra,0xffffe
    800027b8:	6e6080e7          	jalr	1766(ra) # 80000e9a <release>
      return -1;
    800027bc:	59fd                	li	s3,-1
}
    800027be:	854e                	mv	a0,s3
    800027c0:	60a6                	ld	ra,72(sp)
    800027c2:	6406                	ld	s0,64(sp)
    800027c4:	74e2                	ld	s1,56(sp)
    800027c6:	7942                	ld	s2,48(sp)
    800027c8:	79a2                	ld	s3,40(sp)
    800027ca:	7a02                	ld	s4,32(sp)
    800027cc:	6ae2                	ld	s5,24(sp)
    800027ce:	6b42                	ld	s6,16(sp)
    800027d0:	6ba2                	ld	s7,8(sp)
    800027d2:	6c02                	ld	s8,0(sp)
    800027d4:	6161                	addi	sp,sp,80
    800027d6:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800027d8:	85e2                	mv	a1,s8
    800027da:	854a                	mv	a0,s2
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	bf6080e7          	jalr	-1034(ra) # 800023d2 <sleep>
    havekids = 0;
    800027e4:	bf39                	j	80002702 <wait+0x4a>

00000000800027e6 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800027e6:	7179                	addi	sp,sp,-48
    800027e8:	f406                	sd	ra,40(sp)
    800027ea:	f022                	sd	s0,32(sp)
    800027ec:	ec26                	sd	s1,24(sp)
    800027ee:	e84a                	sd	s2,16(sp)
    800027f0:	e44e                	sd	s3,8(sp)
    800027f2:	e052                	sd	s4,0(sp)
    800027f4:	1800                	addi	s0,sp,48
    800027f6:	84aa                	mv	s1,a0
    800027f8:	892e                	mv	s2,a1
    800027fa:	89b2                	mv	s3,a2
    800027fc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800027fe:	fffff097          	auipc	ra,0xfffff
    80002802:	4f8080e7          	jalr	1272(ra) # 80001cf6 <myproc>
  if (user_dst)
    80002806:	c08d                	beqz	s1,80002828 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002808:	86d2                	mv	a3,s4
    8000280a:	864e                	mv	a2,s3
    8000280c:	85ca                	mv	a1,s2
    8000280e:	6928                	ld	a0,80(a0)
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	18e080e7          	jalr	398(ra) # 8000199e <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002818:	70a2                	ld	ra,40(sp)
    8000281a:	7402                	ld	s0,32(sp)
    8000281c:	64e2                	ld	s1,24(sp)
    8000281e:	6942                	ld	s2,16(sp)
    80002820:	69a2                	ld	s3,8(sp)
    80002822:	6a02                	ld	s4,0(sp)
    80002824:	6145                	addi	sp,sp,48
    80002826:	8082                	ret
    memmove((char *)dst, src, len);
    80002828:	000a061b          	sext.w	a2,s4
    8000282c:	85ce                	mv	a1,s3
    8000282e:	854a                	mv	a0,s2
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	70e080e7          	jalr	1806(ra) # 80000f3e <memmove>
    return 0;
    80002838:	8526                	mv	a0,s1
    8000283a:	bff9                	j	80002818 <either_copyout+0x32>

000000008000283c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000283c:	7179                	addi	sp,sp,-48
    8000283e:	f406                	sd	ra,40(sp)
    80002840:	f022                	sd	s0,32(sp)
    80002842:	ec26                	sd	s1,24(sp)
    80002844:	e84a                	sd	s2,16(sp)
    80002846:	e44e                	sd	s3,8(sp)
    80002848:	e052                	sd	s4,0(sp)
    8000284a:	1800                	addi	s0,sp,48
    8000284c:	892a                	mv	s2,a0
    8000284e:	84ae                	mv	s1,a1
    80002850:	89b2                	mv	s3,a2
    80002852:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002854:	fffff097          	auipc	ra,0xfffff
    80002858:	4a2080e7          	jalr	1186(ra) # 80001cf6 <myproc>
  if (user_src)
    8000285c:	c08d                	beqz	s1,8000287e <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    8000285e:	86d2                	mv	a3,s4
    80002860:	864e                	mv	a2,s3
    80002862:	85ca                	mv	a1,s2
    80002864:	6928                	ld	a0,80(a0)
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	1d8080e7          	jalr	472(ra) # 80001a3e <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000286e:	70a2                	ld	ra,40(sp)
    80002870:	7402                	ld	s0,32(sp)
    80002872:	64e2                	ld	s1,24(sp)
    80002874:	6942                	ld	s2,16(sp)
    80002876:	69a2                	ld	s3,8(sp)
    80002878:	6a02                	ld	s4,0(sp)
    8000287a:	6145                	addi	sp,sp,48
    8000287c:	8082                	ret
    memmove(dst, (char *)src, len);
    8000287e:	000a061b          	sext.w	a2,s4
    80002882:	85ce                	mv	a1,s3
    80002884:	854a                	mv	a0,s2
    80002886:	ffffe097          	auipc	ra,0xffffe
    8000288a:	6b8080e7          	jalr	1720(ra) # 80000f3e <memmove>
    return 0;
    8000288e:	8526                	mv	a0,s1
    80002890:	bff9                	j	8000286e <either_copyin+0x32>

0000000080002892 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002892:	715d                	addi	sp,sp,-80
    80002894:	e486                	sd	ra,72(sp)
    80002896:	e0a2                	sd	s0,64(sp)
    80002898:	fc26                	sd	s1,56(sp)
    8000289a:	f84a                	sd	s2,48(sp)
    8000289c:	f44e                	sd	s3,40(sp)
    8000289e:	f052                	sd	s4,32(sp)
    800028a0:	ec56                	sd	s5,24(sp)
    800028a2:	e85a                	sd	s6,16(sp)
    800028a4:	e45e                	sd	s7,8(sp)
    800028a6:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800028a8:	00005517          	auipc	a0,0x5
    800028ac:	77850513          	addi	a0,a0,1912 # 80008020 <etext+0x20>
    800028b0:	ffffe097          	auipc	ra,0xffffe
    800028b4:	cd8080e7          	jalr	-808(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800028b8:	0022f497          	auipc	s1,0x22f
    800028bc:	8e848493          	addi	s1,s1,-1816 # 802311a0 <proc+0x158>
    800028c0:	00234917          	auipc	s2,0x234
    800028c4:	6e090913          	addi	s2,s2,1760 # 80236fa0 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028c8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800028ca:	00006997          	auipc	s3,0x6
    800028ce:	a3e98993          	addi	s3,s3,-1474 # 80008308 <etext+0x308>
    printf("%d %s %s", p->pid, state, p->name);
    800028d2:	00006a97          	auipc	s5,0x6
    800028d6:	a3ea8a93          	addi	s5,s5,-1474 # 80008310 <etext+0x310>
    printf("\n");
    800028da:	00005a17          	auipc	s4,0x5
    800028de:	746a0a13          	addi	s4,s4,1862 # 80008020 <etext+0x20>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028e2:	00006b97          	auipc	s7,0x6
    800028e6:	f26b8b93          	addi	s7,s7,-218 # 80008808 <states.0>
    800028ea:	a00d                	j	8000290c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800028ec:	ed86a583          	lw	a1,-296(a3)
    800028f0:	8556                	mv	a0,s5
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	c96080e7          	jalr	-874(ra) # 80000588 <printf>
    printf("\n");
    800028fa:	8552                	mv	a0,s4
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	c8c080e7          	jalr	-884(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002904:	17848493          	addi	s1,s1,376
    80002908:	03248163          	beq	s1,s2,8000292a <procdump+0x98>
    if (p->state == UNUSED)
    8000290c:	86a6                	mv	a3,s1
    8000290e:	ec04a783          	lw	a5,-320(s1)
    80002912:	dbed                	beqz	a5,80002904 <procdump+0x72>
      state = "???";
    80002914:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002916:	fcfb6be3          	bltu	s6,a5,800028ec <procdump+0x5a>
    8000291a:	1782                	slli	a5,a5,0x20
    8000291c:	9381                	srli	a5,a5,0x20
    8000291e:	078e                	slli	a5,a5,0x3
    80002920:	97de                	add	a5,a5,s7
    80002922:	6390                	ld	a2,0(a5)
    80002924:	f661                	bnez	a2,800028ec <procdump+0x5a>
      state = "???";
    80002926:	864e                	mv	a2,s3
    80002928:	b7d1                	j	800028ec <procdump+0x5a>
  }
}
    8000292a:	60a6                	ld	ra,72(sp)
    8000292c:	6406                	ld	s0,64(sp)
    8000292e:	74e2                	ld	s1,56(sp)
    80002930:	7942                	ld	s2,48(sp)
    80002932:	79a2                	ld	s3,40(sp)
    80002934:	7a02                	ld	s4,32(sp)
    80002936:	6ae2                	ld	s5,24(sp)
    80002938:	6b42                	ld	s6,16(sp)
    8000293a:	6ba2                	ld	s7,8(sp)
    8000293c:	6161                	addi	sp,sp,80
    8000293e:	8082                	ret

0000000080002940 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002940:	711d                	addi	sp,sp,-96
    80002942:	ec86                	sd	ra,88(sp)
    80002944:	e8a2                	sd	s0,80(sp)
    80002946:	e4a6                	sd	s1,72(sp)
    80002948:	e0ca                	sd	s2,64(sp)
    8000294a:	fc4e                	sd	s3,56(sp)
    8000294c:	f852                	sd	s4,48(sp)
    8000294e:	f456                	sd	s5,40(sp)
    80002950:	f05a                	sd	s6,32(sp)
    80002952:	ec5e                	sd	s7,24(sp)
    80002954:	e862                	sd	s8,16(sp)
    80002956:	e466                	sd	s9,8(sp)
    80002958:	e06a                	sd	s10,0(sp)
    8000295a:	1080                	addi	s0,sp,96
    8000295c:	8b2a                	mv	s6,a0
    8000295e:	8bae                	mv	s7,a1
    80002960:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002962:	fffff097          	auipc	ra,0xfffff
    80002966:	394080e7          	jalr	916(ra) # 80001cf6 <myproc>
    8000296a:	892a                	mv	s2,a0

  acquire(&wait_lock);
    8000296c:	0022e517          	auipc	a0,0x22e
    80002970:	2c450513          	addi	a0,a0,708 # 80230c30 <wait_lock>
    80002974:	ffffe097          	auipc	ra,0xffffe
    80002978:	472080e7          	jalr	1138(ra) # 80000de6 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    8000297c:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    8000297e:	4a15                	li	s4,5
        havekids = 1;
    80002980:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002982:	00234997          	auipc	s3,0x234
    80002986:	4c698993          	addi	s3,s3,1222 # 80236e48 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000298a:	0022ed17          	auipc	s10,0x22e
    8000298e:	2a6d0d13          	addi	s10,s10,678 # 80230c30 <wait_lock>
    havekids = 0;
    80002992:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002994:	0022e497          	auipc	s1,0x22e
    80002998:	6b448493          	addi	s1,s1,1716 # 80231048 <proc>
    8000299c:	a059                	j	80002a22 <waitx+0xe2>
          pid = np->pid;
    8000299e:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    800029a2:	1684a703          	lw	a4,360(s1)
    800029a6:	00ec2023          	sw	a4,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    800029aa:	16c4a783          	lw	a5,364(s1)
    800029ae:	9f3d                	addw	a4,a4,a5
    800029b0:	1704a783          	lw	a5,368(s1)
    800029b4:	9f99                	subw	a5,a5,a4
    800029b6:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800029ba:	000b0e63          	beqz	s6,800029d6 <waitx+0x96>
    800029be:	4691                	li	a3,4
    800029c0:	02c48613          	addi	a2,s1,44
    800029c4:	85da                	mv	a1,s6
    800029c6:	05093503          	ld	a0,80(s2)
    800029ca:	fffff097          	auipc	ra,0xfffff
    800029ce:	fd4080e7          	jalr	-44(ra) # 8000199e <copyout>
    800029d2:	02054563          	bltz	a0,800029fc <waitx+0xbc>
          freeproc(np);
    800029d6:	8526                	mv	a0,s1
    800029d8:	fffff097          	auipc	ra,0xfffff
    800029dc:	4d0080e7          	jalr	1232(ra) # 80001ea8 <freeproc>
          release(&np->lock);
    800029e0:	8526                	mv	a0,s1
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	4b8080e7          	jalr	1208(ra) # 80000e9a <release>
          release(&wait_lock);
    800029ea:	0022e517          	auipc	a0,0x22e
    800029ee:	24650513          	addi	a0,a0,582 # 80230c30 <wait_lock>
    800029f2:	ffffe097          	auipc	ra,0xffffe
    800029f6:	4a8080e7          	jalr	1192(ra) # 80000e9a <release>
          return pid;
    800029fa:	a09d                	j	80002a60 <waitx+0x120>
            release(&np->lock);
    800029fc:	8526                	mv	a0,s1
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	49c080e7          	jalr	1180(ra) # 80000e9a <release>
            release(&wait_lock);
    80002a06:	0022e517          	auipc	a0,0x22e
    80002a0a:	22a50513          	addi	a0,a0,554 # 80230c30 <wait_lock>
    80002a0e:	ffffe097          	auipc	ra,0xffffe
    80002a12:	48c080e7          	jalr	1164(ra) # 80000e9a <release>
            return -1;
    80002a16:	59fd                	li	s3,-1
    80002a18:	a0a1                	j	80002a60 <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    80002a1a:	17848493          	addi	s1,s1,376
    80002a1e:	03348463          	beq	s1,s3,80002a46 <waitx+0x106>
      if (np->parent == p)
    80002a22:	7c9c                	ld	a5,56(s1)
    80002a24:	ff279be3          	bne	a5,s2,80002a1a <waitx+0xda>
        acquire(&np->lock);
    80002a28:	8526                	mv	a0,s1
    80002a2a:	ffffe097          	auipc	ra,0xffffe
    80002a2e:	3bc080e7          	jalr	956(ra) # 80000de6 <acquire>
        if (np->state == ZOMBIE)
    80002a32:	4c9c                	lw	a5,24(s1)
    80002a34:	f74785e3          	beq	a5,s4,8000299e <waitx+0x5e>
        release(&np->lock);
    80002a38:	8526                	mv	a0,s1
    80002a3a:	ffffe097          	auipc	ra,0xffffe
    80002a3e:	460080e7          	jalr	1120(ra) # 80000e9a <release>
        havekids = 1;
    80002a42:	8756                	mv	a4,s5
    80002a44:	bfd9                	j	80002a1a <waitx+0xda>
    if (!havekids || p->killed)
    80002a46:	c701                	beqz	a4,80002a4e <waitx+0x10e>
    80002a48:	02892783          	lw	a5,40(s2)
    80002a4c:	cb8d                	beqz	a5,80002a7e <waitx+0x13e>
      release(&wait_lock);
    80002a4e:	0022e517          	auipc	a0,0x22e
    80002a52:	1e250513          	addi	a0,a0,482 # 80230c30 <wait_lock>
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	444080e7          	jalr	1092(ra) # 80000e9a <release>
      return -1;
    80002a5e:	59fd                	li	s3,-1
  }
}
    80002a60:	854e                	mv	a0,s3
    80002a62:	60e6                	ld	ra,88(sp)
    80002a64:	6446                	ld	s0,80(sp)
    80002a66:	64a6                	ld	s1,72(sp)
    80002a68:	6906                	ld	s2,64(sp)
    80002a6a:	79e2                	ld	s3,56(sp)
    80002a6c:	7a42                	ld	s4,48(sp)
    80002a6e:	7aa2                	ld	s5,40(sp)
    80002a70:	7b02                	ld	s6,32(sp)
    80002a72:	6be2                	ld	s7,24(sp)
    80002a74:	6c42                	ld	s8,16(sp)
    80002a76:	6ca2                	ld	s9,8(sp)
    80002a78:	6d02                	ld	s10,0(sp)
    80002a7a:	6125                	addi	sp,sp,96
    80002a7c:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002a7e:	85ea                	mv	a1,s10
    80002a80:	854a                	mv	a0,s2
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	950080e7          	jalr	-1712(ra) # 800023d2 <sleep>
    havekids = 0;
    80002a8a:	b721                	j	80002992 <waitx+0x52>

0000000080002a8c <update_time>:

void update_time()
{
    80002a8c:	7179                	addi	sp,sp,-48
    80002a8e:	f406                	sd	ra,40(sp)
    80002a90:	f022                	sd	s0,32(sp)
    80002a92:	ec26                	sd	s1,24(sp)
    80002a94:	e84a                	sd	s2,16(sp)
    80002a96:	e44e                	sd	s3,8(sp)
    80002a98:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002a9a:	0022e497          	auipc	s1,0x22e
    80002a9e:	5ae48493          	addi	s1,s1,1454 # 80231048 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002aa2:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002aa4:	00234917          	auipc	s2,0x234
    80002aa8:	3a490913          	addi	s2,s2,932 # 80236e48 <tickslock>
    80002aac:	a811                	j	80002ac0 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002aae:	8526                	mv	a0,s1
    80002ab0:	ffffe097          	auipc	ra,0xffffe
    80002ab4:	3ea080e7          	jalr	1002(ra) # 80000e9a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002ab8:	17848493          	addi	s1,s1,376
    80002abc:	03248063          	beq	s1,s2,80002adc <update_time+0x50>
    acquire(&p->lock);
    80002ac0:	8526                	mv	a0,s1
    80002ac2:	ffffe097          	auipc	ra,0xffffe
    80002ac6:	324080e7          	jalr	804(ra) # 80000de6 <acquire>
    if (p->state == RUNNING)
    80002aca:	4c9c                	lw	a5,24(s1)
    80002acc:	ff3791e3          	bne	a5,s3,80002aae <update_time+0x22>
      p->rtime++;
    80002ad0:	1684a783          	lw	a5,360(s1)
    80002ad4:	2785                	addiw	a5,a5,1
    80002ad6:	16f4a423          	sw	a5,360(s1)
    80002ada:	bfd1                	j	80002aae <update_time+0x22>
  }
    80002adc:	70a2                	ld	ra,40(sp)
    80002ade:	7402                	ld	s0,32(sp)
    80002ae0:	64e2                	ld	s1,24(sp)
    80002ae2:	6942                	ld	s2,16(sp)
    80002ae4:	69a2                	ld	s3,8(sp)
    80002ae6:	6145                	addi	sp,sp,48
    80002ae8:	8082                	ret

0000000080002aea <swtch>:
    80002aea:	00153023          	sd	ra,0(a0)
    80002aee:	00253423          	sd	sp,8(a0)
    80002af2:	e900                	sd	s0,16(a0)
    80002af4:	ed04                	sd	s1,24(a0)
    80002af6:	03253023          	sd	s2,32(a0)
    80002afa:	03353423          	sd	s3,40(a0)
    80002afe:	03453823          	sd	s4,48(a0)
    80002b02:	03553c23          	sd	s5,56(a0)
    80002b06:	05653023          	sd	s6,64(a0)
    80002b0a:	05753423          	sd	s7,72(a0)
    80002b0e:	05853823          	sd	s8,80(a0)
    80002b12:	05953c23          	sd	s9,88(a0)
    80002b16:	07a53023          	sd	s10,96(a0)
    80002b1a:	07b53423          	sd	s11,104(a0)
    80002b1e:	0005b083          	ld	ra,0(a1)
    80002b22:	0085b103          	ld	sp,8(a1)
    80002b26:	6980                	ld	s0,16(a1)
    80002b28:	6d84                	ld	s1,24(a1)
    80002b2a:	0205b903          	ld	s2,32(a1)
    80002b2e:	0285b983          	ld	s3,40(a1)
    80002b32:	0305ba03          	ld	s4,48(a1)
    80002b36:	0385ba83          	ld	s5,56(a1)
    80002b3a:	0405bb03          	ld	s6,64(a1)
    80002b3e:	0485bb83          	ld	s7,72(a1)
    80002b42:	0505bc03          	ld	s8,80(a1)
    80002b46:	0585bc83          	ld	s9,88(a1)
    80002b4a:	0605bd03          	ld	s10,96(a1)
    80002b4e:	0685bd83          	ld	s11,104(a1)
    80002b52:	8082                	ret

0000000080002b54 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b54:	1141                	addi	sp,sp,-16
    80002b56:	e406                	sd	ra,8(sp)
    80002b58:	e022                	sd	s0,0(sp)
    80002b5a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b5c:	00005597          	auipc	a1,0x5
    80002b60:	7f458593          	addi	a1,a1,2036 # 80008350 <etext+0x350>
    80002b64:	00234517          	auipc	a0,0x234
    80002b68:	2e450513          	addi	a0,a0,740 # 80236e48 <tickslock>
    80002b6c:	ffffe097          	auipc	ra,0xffffe
    80002b70:	1ea080e7          	jalr	490(ra) # 80000d56 <initlock>
}
    80002b74:	60a2                	ld	ra,8(sp)
    80002b76:	6402                	ld	s0,0(sp)
    80002b78:	0141                	addi	sp,sp,16
    80002b7a:	8082                	ret

0000000080002b7c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002b7c:	1141                	addi	sp,sp,-16
    80002b7e:	e422                	sd	s0,8(sp)
    80002b80:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b82:	00003797          	auipc	a5,0x3
    80002b86:	59e78793          	addi	a5,a5,1438 # 80006120 <kernelvec>
    80002b8a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b8e:	6422                	ld	s0,8(sp)
    80002b90:	0141                	addi	sp,sp,16
    80002b92:	8082                	ret

0000000080002b94 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002b94:	1141                	addi	sp,sp,-16
    80002b96:	e406                	sd	ra,8(sp)
    80002b98:	e022                	sd	s0,0(sp)
    80002b9a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b9c:	fffff097          	auipc	ra,0xfffff
    80002ba0:	15a080e7          	jalr	346(ra) # 80001cf6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ba4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002ba8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002baa:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002bae:	00004617          	auipc	a2,0x4
    80002bb2:	45260613          	addi	a2,a2,1106 # 80007000 <_trampoline>
    80002bb6:	00004697          	auipc	a3,0x4
    80002bba:	44a68693          	addi	a3,a3,1098 # 80007000 <_trampoline>
    80002bbe:	8e91                	sub	a3,a3,a2
    80002bc0:	040007b7          	lui	a5,0x4000
    80002bc4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bc6:	07b2                	slli	a5,a5,0xc
    80002bc8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bca:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002bce:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002bd0:	180026f3          	csrr	a3,satp
    80002bd4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002bd6:	6d38                	ld	a4,88(a0)
    80002bd8:	6134                	ld	a3,64(a0)
    80002bda:	6585                	lui	a1,0x1
    80002bdc:	96ae                	add	a3,a3,a1
    80002bde:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002be0:	6d38                	ld	a4,88(a0)
    80002be2:	00000697          	auipc	a3,0x0
    80002be6:	13e68693          	addi	a3,a3,318 # 80002d20 <usertrap>
    80002bea:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002bec:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bee:	8692                	mv	a3,tp
    80002bf0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bf2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bf6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bfa:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bfe:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002c02:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c04:	6f18                	ld	a4,24(a4)
    80002c06:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c0a:	6928                	ld	a0,80(a0)
    80002c0c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c0e:	00004717          	auipc	a4,0x4
    80002c12:	48e70713          	addi	a4,a4,1166 # 8000709c <userret>
    80002c16:	8f11                	sub	a4,a4,a2
    80002c18:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002c1a:	577d                	li	a4,-1
    80002c1c:	177e                	slli	a4,a4,0x3f
    80002c1e:	8d59                	or	a0,a0,a4
    80002c20:	9782                	jalr	a5
}
    80002c22:	60a2                	ld	ra,8(sp)
    80002c24:	6402                	ld	s0,0(sp)
    80002c26:	0141                	addi	sp,sp,16
    80002c28:	8082                	ret

0000000080002c2a <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	e04a                	sd	s2,0(sp)
    80002c34:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002c36:	00234917          	auipc	s2,0x234
    80002c3a:	21290913          	addi	s2,s2,530 # 80236e48 <tickslock>
    80002c3e:	854a                	mv	a0,s2
    80002c40:	ffffe097          	auipc	ra,0xffffe
    80002c44:	1a6080e7          	jalr	422(ra) # 80000de6 <acquire>
  ticks++;
    80002c48:	00006497          	auipc	s1,0x6
    80002c4c:	d4848493          	addi	s1,s1,-696 # 80008990 <ticks>
    80002c50:	409c                	lw	a5,0(s1)
    80002c52:	2785                	addiw	a5,a5,1
    80002c54:	c09c                	sw	a5,0(s1)
  update_time();
    80002c56:	00000097          	auipc	ra,0x0
    80002c5a:	e36080e7          	jalr	-458(ra) # 80002a8c <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002c5e:	8526                	mv	a0,s1
    80002c60:	fffff097          	auipc	ra,0xfffff
    80002c64:	7d6080e7          	jalr	2006(ra) # 80002436 <wakeup>
  release(&tickslock);
    80002c68:	854a                	mv	a0,s2
    80002c6a:	ffffe097          	auipc	ra,0xffffe
    80002c6e:	230080e7          	jalr	560(ra) # 80000e9a <release>
}
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6902                	ld	s2,0(sp)
    80002c7a:	6105                	addi	sp,sp,32
    80002c7c:	8082                	ret

0000000080002c7e <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	e426                	sd	s1,8(sp)
    80002c86:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c88:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002c8c:	00074d63          	bltz	a4,80002ca6 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002c90:	57fd                	li	a5,-1
    80002c92:	17fe                	slli	a5,a5,0x3f
    80002c94:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002c96:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002c98:	06f70363          	beq	a4,a5,80002cfe <devintr+0x80>
  }
}
    80002c9c:	60e2                	ld	ra,24(sp)
    80002c9e:	6442                	ld	s0,16(sp)
    80002ca0:	64a2                	ld	s1,8(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret
      (scause & 0xff) == 9)
    80002ca6:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80002caa:	46a5                	li	a3,9
    80002cac:	fed792e3          	bne	a5,a3,80002c90 <devintr+0x12>
    int irq = plic_claim();
    80002cb0:	00003097          	auipc	ra,0x3
    80002cb4:	578080e7          	jalr	1400(ra) # 80006228 <plic_claim>
    80002cb8:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002cba:	47a9                	li	a5,10
    80002cbc:	02f50763          	beq	a0,a5,80002cea <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002cc0:	4785                	li	a5,1
    80002cc2:	02f50963          	beq	a0,a5,80002cf4 <devintr+0x76>
    return 1;
    80002cc6:	4505                	li	a0,1
    else if (irq)
    80002cc8:	d8f1                	beqz	s1,80002c9c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002cca:	85a6                	mv	a1,s1
    80002ccc:	00005517          	auipc	a0,0x5
    80002cd0:	68c50513          	addi	a0,a0,1676 # 80008358 <etext+0x358>
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	8b4080e7          	jalr	-1868(ra) # 80000588 <printf>
      plic_complete(irq);
    80002cdc:	8526                	mv	a0,s1
    80002cde:	00003097          	auipc	ra,0x3
    80002ce2:	56e080e7          	jalr	1390(ra) # 8000624c <plic_complete>
    return 1;
    80002ce6:	4505                	li	a0,1
    80002ce8:	bf55                	j	80002c9c <devintr+0x1e>
      uartintr();
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	cb0080e7          	jalr	-848(ra) # 8000099a <uartintr>
    80002cf2:	b7ed                	j	80002cdc <devintr+0x5e>
      virtio_disk_intr();
    80002cf4:	00004097          	auipc	ra,0x4
    80002cf8:	a24080e7          	jalr	-1500(ra) # 80006718 <virtio_disk_intr>
    80002cfc:	b7c5                	j	80002cdc <devintr+0x5e>
    if (cpuid() == 0)
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	fcc080e7          	jalr	-52(ra) # 80001cca <cpuid>
    80002d06:	c901                	beqz	a0,80002d16 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002d08:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002d0c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002d0e:	14479073          	csrw	sip,a5
    return 2;
    80002d12:	4509                	li	a0,2
    80002d14:	b761                	j	80002c9c <devintr+0x1e>
      clockintr();
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	f14080e7          	jalr	-236(ra) # 80002c2a <clockintr>
    80002d1e:	b7ed                	j	80002d08 <devintr+0x8a>

0000000080002d20 <usertrap>:
{
    80002d20:	1101                	addi	sp,sp,-32
    80002d22:	ec06                	sd	ra,24(sp)
    80002d24:	e822                	sd	s0,16(sp)
    80002d26:	e426                	sd	s1,8(sp)
    80002d28:	e04a                	sd	s2,0(sp)
    80002d2a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d2c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80002d30:	1007f793          	andi	a5,a5,256
    80002d34:	efad                	bnez	a5,80002dae <usertrap+0x8e>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d36:	00003797          	auipc	a5,0x3
    80002d3a:	3ea78793          	addi	a5,a5,1002 # 80006120 <kernelvec>
    80002d3e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();   // Get the current process structure
    80002d42:	fffff097          	auipc	ra,0xfffff
    80002d46:	fb4080e7          	jalr	-76(ra) # 80001cf6 <myproc>
    80002d4a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d4c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d4e:	14102773          	csrr	a4,sepc
    80002d52:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d54:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002d58:	47a1                	li	a5,8
    80002d5a:	06f70263          	beq	a4,a5,80002dbe <usertrap+0x9e>
  else if ((which_dev = devintr()) != 0)
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	f20080e7          	jalr	-224(ra) # 80002c7e <devintr>
    80002d66:	892a                	mv	s2,a0
    80002d68:	ed69                	bnez	a0,80002e42 <usertrap+0x122>
    80002d6a:	14202773          	csrr	a4,scause
  else if(r_scause() == 15) {  // value of r_sause 15 means a page fault on write
    80002d6e:	47bd                	li	a5,15
    80002d70:	0af70063          	beq	a4,a5,80002e10 <usertrap+0xf0>
    80002d74:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002d78:	5890                	lw	a2,48(s1)
    80002d7a:	00005517          	auipc	a0,0x5
    80002d7e:	63e50513          	addi	a0,a0,1598 # 800083b8 <etext+0x3b8>
    80002d82:	ffffe097          	auipc	ra,0xffffe
    80002d86:	806080e7          	jalr	-2042(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d8a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d8e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d92:	00005517          	auipc	a0,0x5
    80002d96:	65650513          	addi	a0,a0,1622 # 800083e8 <etext+0x3e8>
    80002d9a:	ffffd097          	auipc	ra,0xffffd
    80002d9e:	7ee080e7          	jalr	2030(ra) # 80000588 <printf>
    setkilled(p);     // Kill process for unexpected exceptions
    80002da2:	8526                	mv	a0,s1
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	8b6080e7          	jalr	-1866(ra) # 8000265a <setkilled>
    80002dac:	a825                	j	80002de4 <usertrap+0xc4>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80002dae:	00005517          	auipc	a0,0x5
    80002db2:	5ca50513          	addi	a0,a0,1482 # 80008378 <etext+0x378>
    80002db6:	ffffd097          	auipc	ra,0xffffd
    80002dba:	788080e7          	jalr	1928(ra) # 8000053e <panic>
    if (killed(p)) exit(-1);
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	8c8080e7          	jalr	-1848(ra) # 80002686 <killed>
    80002dc6:	ed1d                	bnez	a0,80002e04 <usertrap+0xe4>
    p->trapframe->epc += 4;
    80002dc8:	6cb8                	ld	a4,88(s1)
    80002dca:	6f1c                	ld	a5,24(a4)
    80002dcc:	0791                	addi	a5,a5,4
    80002dce:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002dd4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dd8:	10079073          	csrw	sstatus,a5
    syscall();  // Call the syscall handler
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	2da080e7          	jalr	730(ra) # 800030b6 <syscall>
  if (killed(p)) exit(-1);
    80002de4:	8526                	mv	a0,s1
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	8a0080e7          	jalr	-1888(ra) # 80002686 <killed>
    80002dee:	e12d                	bnez	a0,80002e50 <usertrap+0x130>
  usertrapret();   // Return from user trap and resume execution in user mode
    80002df0:	00000097          	auipc	ra,0x0
    80002df4:	da4080e7          	jalr	-604(ra) # 80002b94 <usertrapret>
}
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6902                	ld	s2,0(sp)
    80002e00:	6105                	addi	sp,sp,32
    80002e02:	8082                	ret
    if (killed(p)) exit(-1);
    80002e04:	557d                	li	a0,-1
    80002e06:	fffff097          	auipc	ra,0xfffff
    80002e0a:	700080e7          	jalr	1792(ra) # 80002506 <exit>
    80002e0e:	bf6d                	j	80002dc8 <usertrap+0xa8>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e10:	14302973          	csrr	s2,stval
    if(cowalloc(p->pagetable, addr) < 0){
    80002e14:	85ca                	mv	a1,s2
    80002e16:	68a8                	ld	a0,80(s1)
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	95c080e7          	jalr	-1700(ra) # 80001774 <cowalloc>
    80002e20:	fc0552e3          	bgez	a0,80002de4 <usertrap+0xc4>
      printf("alloc user page fault addr=%p\n", addr);
    80002e24:	85ca                	mv	a1,s2
    80002e26:	00005517          	auipc	a0,0x5
    80002e2a:	57250513          	addi	a0,a0,1394 # 80008398 <etext+0x398>
    80002e2e:	ffffd097          	auipc	ra,0xffffd
    80002e32:	75a080e7          	jalr	1882(ra) # 80000588 <printf>
      setkilled(p);   // Terminate process if COW allocation fails
    80002e36:	8526                	mv	a0,s1
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	822080e7          	jalr	-2014(ra) # 8000265a <setkilled>
    80002e40:	b755                	j	80002de4 <usertrap+0xc4>
  if (killed(p)) exit(-1);
    80002e42:	8526                	mv	a0,s1
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	842080e7          	jalr	-1982(ra) # 80002686 <killed>
    80002e4c:	c901                	beqz	a0,80002e5c <usertrap+0x13c>
    80002e4e:	a011                	j	80002e52 <usertrap+0x132>
    80002e50:	4901                	li	s2,0
    80002e52:	557d                	li	a0,-1
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	6b2080e7          	jalr	1714(ra) # 80002506 <exit>
  if (which_dev == 2) yield();
    80002e5c:	4789                	li	a5,2
    80002e5e:	f8f919e3          	bne	s2,a5,80002df0 <usertrap+0xd0>
    80002e62:	fffff097          	auipc	ra,0xfffff
    80002e66:	534080e7          	jalr	1332(ra) # 80002396 <yield>
    80002e6a:	b759                	j	80002df0 <usertrap+0xd0>

0000000080002e6c <kerneltrap>:
{
    80002e6c:	7179                	addi	sp,sp,-48
    80002e6e:	f406                	sd	ra,40(sp)
    80002e70:	f022                	sd	s0,32(sp)
    80002e72:	ec26                	sd	s1,24(sp)
    80002e74:	e84a                	sd	s2,16(sp)
    80002e76:	e44e                	sd	s3,8(sp)
    80002e78:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e7a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e7e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e82:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002e86:	1004f793          	andi	a5,s1,256
    80002e8a:	cb85                	beqz	a5,80002eba <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e8c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e90:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002e92:	ef85                	bnez	a5,80002eca <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	dea080e7          	jalr	-534(ra) # 80002c7e <devintr>
    80002e9c:	cd1d                	beqz	a0,80002eda <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e9e:	4789                	li	a5,2
    80002ea0:	06f50a63          	beq	a0,a5,80002f14 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ea4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ea8:	10049073          	csrw	sstatus,s1
}
    80002eac:	70a2                	ld	ra,40(sp)
    80002eae:	7402                	ld	s0,32(sp)
    80002eb0:	64e2                	ld	s1,24(sp)
    80002eb2:	6942                	ld	s2,16(sp)
    80002eb4:	69a2                	ld	s3,8(sp)
    80002eb6:	6145                	addi	sp,sp,48
    80002eb8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002eba:	00005517          	auipc	a0,0x5
    80002ebe:	54e50513          	addi	a0,a0,1358 # 80008408 <etext+0x408>
    80002ec2:	ffffd097          	auipc	ra,0xffffd
    80002ec6:	67c080e7          	jalr	1660(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002eca:	00005517          	auipc	a0,0x5
    80002ece:	56650513          	addi	a0,a0,1382 # 80008430 <etext+0x430>
    80002ed2:	ffffd097          	auipc	ra,0xffffd
    80002ed6:	66c080e7          	jalr	1644(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002eda:	85ce                	mv	a1,s3
    80002edc:	00005517          	auipc	a0,0x5
    80002ee0:	57450513          	addi	a0,a0,1396 # 80008450 <etext+0x450>
    80002ee4:	ffffd097          	auipc	ra,0xffffd
    80002ee8:	6a4080e7          	jalr	1700(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002eec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ef0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ef4:	00005517          	auipc	a0,0x5
    80002ef8:	56c50513          	addi	a0,a0,1388 # 80008460 <etext+0x460>
    80002efc:	ffffd097          	auipc	ra,0xffffd
    80002f00:	68c080e7          	jalr	1676(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002f04:	00005517          	auipc	a0,0x5
    80002f08:	57450513          	addi	a0,a0,1396 # 80008478 <etext+0x478>
    80002f0c:	ffffd097          	auipc	ra,0xffffd
    80002f10:	632080e7          	jalr	1586(ra) # 8000053e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	de2080e7          	jalr	-542(ra) # 80001cf6 <myproc>
    80002f1c:	d541                	beqz	a0,80002ea4 <kerneltrap+0x38>
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	dd8080e7          	jalr	-552(ra) # 80001cf6 <myproc>
    80002f26:	4d18                	lw	a4,24(a0)
    80002f28:	4791                	li	a5,4
    80002f2a:	f6f71de3          	bne	a4,a5,80002ea4 <kerneltrap+0x38>
    yield();
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	468080e7          	jalr	1128(ra) # 80002396 <yield>
    80002f36:	b7bd                	j	80002ea4 <kerneltrap+0x38>

0000000080002f38 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f38:	1101                	addi	sp,sp,-32
    80002f3a:	ec06                	sd	ra,24(sp)
    80002f3c:	e822                	sd	s0,16(sp)
    80002f3e:	e426                	sd	s1,8(sp)
    80002f40:	1000                	addi	s0,sp,32
    80002f42:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	db2080e7          	jalr	-590(ra) # 80001cf6 <myproc>
  switch (n) {
    80002f4c:	4795                	li	a5,5
    80002f4e:	0497e163          	bltu	a5,s1,80002f90 <argraw+0x58>
    80002f52:	048a                	slli	s1,s1,0x2
    80002f54:	00006717          	auipc	a4,0x6
    80002f58:	8e470713          	addi	a4,a4,-1820 # 80008838 <states.0+0x30>
    80002f5c:	94ba                	add	s1,s1,a4
    80002f5e:	409c                	lw	a5,0(s1)
    80002f60:	97ba                	add	a5,a5,a4
    80002f62:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002f64:	6d3c                	ld	a5,88(a0)
    80002f66:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f68:	60e2                	ld	ra,24(sp)
    80002f6a:	6442                	ld	s0,16(sp)
    80002f6c:	64a2                	ld	s1,8(sp)
    80002f6e:	6105                	addi	sp,sp,32
    80002f70:	8082                	ret
    return p->trapframe->a1;
    80002f72:	6d3c                	ld	a5,88(a0)
    80002f74:	7fa8                	ld	a0,120(a5)
    80002f76:	bfcd                	j	80002f68 <argraw+0x30>
    return p->trapframe->a2;
    80002f78:	6d3c                	ld	a5,88(a0)
    80002f7a:	63c8                	ld	a0,128(a5)
    80002f7c:	b7f5                	j	80002f68 <argraw+0x30>
    return p->trapframe->a3;
    80002f7e:	6d3c                	ld	a5,88(a0)
    80002f80:	67c8                	ld	a0,136(a5)
    80002f82:	b7dd                	j	80002f68 <argraw+0x30>
    return p->trapframe->a4;
    80002f84:	6d3c                	ld	a5,88(a0)
    80002f86:	6bc8                	ld	a0,144(a5)
    80002f88:	b7c5                	j	80002f68 <argraw+0x30>
    return p->trapframe->a5;
    80002f8a:	6d3c                	ld	a5,88(a0)
    80002f8c:	6fc8                	ld	a0,152(a5)
    80002f8e:	bfe9                	j	80002f68 <argraw+0x30>
  panic("argraw");
    80002f90:	00005517          	auipc	a0,0x5
    80002f94:	4f850513          	addi	a0,a0,1272 # 80008488 <etext+0x488>
    80002f98:	ffffd097          	auipc	ra,0xffffd
    80002f9c:	5a6080e7          	jalr	1446(ra) # 8000053e <panic>

0000000080002fa0 <fetchaddr>:
{
    80002fa0:	1101                	addi	sp,sp,-32
    80002fa2:	ec06                	sd	ra,24(sp)
    80002fa4:	e822                	sd	s0,16(sp)
    80002fa6:	e426                	sd	s1,8(sp)
    80002fa8:	e04a                	sd	s2,0(sp)
    80002faa:	1000                	addi	s0,sp,32
    80002fac:	84aa                	mv	s1,a0
    80002fae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	d46080e7          	jalr	-698(ra) # 80001cf6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002fb8:	653c                	ld	a5,72(a0)
    80002fba:	02f4f863          	bgeu	s1,a5,80002fea <fetchaddr+0x4a>
    80002fbe:	00848713          	addi	a4,s1,8
    80002fc2:	02e7e663          	bltu	a5,a4,80002fee <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002fc6:	46a1                	li	a3,8
    80002fc8:	8626                	mv	a2,s1
    80002fca:	85ca                	mv	a1,s2
    80002fcc:	6928                	ld	a0,80(a0)
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	a70080e7          	jalr	-1424(ra) # 80001a3e <copyin>
    80002fd6:	00a03533          	snez	a0,a0
    80002fda:	40a00533          	neg	a0,a0
}
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	64a2                	ld	s1,8(sp)
    80002fe4:	6902                	ld	s2,0(sp)
    80002fe6:	6105                	addi	sp,sp,32
    80002fe8:	8082                	ret
    return -1;
    80002fea:	557d                	li	a0,-1
    80002fec:	bfcd                	j	80002fde <fetchaddr+0x3e>
    80002fee:	557d                	li	a0,-1
    80002ff0:	b7fd                	j	80002fde <fetchaddr+0x3e>

0000000080002ff2 <fetchstr>:
{
    80002ff2:	7179                	addi	sp,sp,-48
    80002ff4:	f406                	sd	ra,40(sp)
    80002ff6:	f022                	sd	s0,32(sp)
    80002ff8:	ec26                	sd	s1,24(sp)
    80002ffa:	e84a                	sd	s2,16(sp)
    80002ffc:	e44e                	sd	s3,8(sp)
    80002ffe:	1800                	addi	s0,sp,48
    80003000:	892a                	mv	s2,a0
    80003002:	84ae                	mv	s1,a1
    80003004:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	cf0080e7          	jalr	-784(ra) # 80001cf6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000300e:	86ce                	mv	a3,s3
    80003010:	864a                	mv	a2,s2
    80003012:	85a6                	mv	a1,s1
    80003014:	6928                	ld	a0,80(a0)
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	ab6080e7          	jalr	-1354(ra) # 80001acc <copyinstr>
    8000301e:	00054e63          	bltz	a0,8000303a <fetchstr+0x48>
  return strlen(buf);
    80003022:	8526                	mv	a0,s1
    80003024:	ffffe097          	auipc	ra,0xffffe
    80003028:	03a080e7          	jalr	58(ra) # 8000105e <strlen>
}
    8000302c:	70a2                	ld	ra,40(sp)
    8000302e:	7402                	ld	s0,32(sp)
    80003030:	64e2                	ld	s1,24(sp)
    80003032:	6942                	ld	s2,16(sp)
    80003034:	69a2                	ld	s3,8(sp)
    80003036:	6145                	addi	sp,sp,48
    80003038:	8082                	ret
    return -1;
    8000303a:	557d                	li	a0,-1
    8000303c:	bfc5                	j	8000302c <fetchstr+0x3a>

000000008000303e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	e426                	sd	s1,8(sp)
    80003046:	1000                	addi	s0,sp,32
    80003048:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	eee080e7          	jalr	-274(ra) # 80002f38 <argraw>
    80003052:	c088                	sw	a0,0(s1)
}
    80003054:	60e2                	ld	ra,24(sp)
    80003056:	6442                	ld	s0,16(sp)
    80003058:	64a2                	ld	s1,8(sp)
    8000305a:	6105                	addi	sp,sp,32
    8000305c:	8082                	ret

000000008000305e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000305e:	1101                	addi	sp,sp,-32
    80003060:	ec06                	sd	ra,24(sp)
    80003062:	e822                	sd	s0,16(sp)
    80003064:	e426                	sd	s1,8(sp)
    80003066:	1000                	addi	s0,sp,32
    80003068:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	ece080e7          	jalr	-306(ra) # 80002f38 <argraw>
    80003072:	e088                	sd	a0,0(s1)
}
    80003074:	60e2                	ld	ra,24(sp)
    80003076:	6442                	ld	s0,16(sp)
    80003078:	64a2                	ld	s1,8(sp)
    8000307a:	6105                	addi	sp,sp,32
    8000307c:	8082                	ret

000000008000307e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000307e:	7179                	addi	sp,sp,-48
    80003080:	f406                	sd	ra,40(sp)
    80003082:	f022                	sd	s0,32(sp)
    80003084:	ec26                	sd	s1,24(sp)
    80003086:	e84a                	sd	s2,16(sp)
    80003088:	1800                	addi	s0,sp,48
    8000308a:	84ae                	mv	s1,a1
    8000308c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000308e:	fd840593          	addi	a1,s0,-40
    80003092:	00000097          	auipc	ra,0x0
    80003096:	fcc080e7          	jalr	-52(ra) # 8000305e <argaddr>
  return fetchstr(addr, buf, max);
    8000309a:	864a                	mv	a2,s2
    8000309c:	85a6                	mv	a1,s1
    8000309e:	fd843503          	ld	a0,-40(s0)
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	f50080e7          	jalr	-176(ra) # 80002ff2 <fetchstr>
}
    800030aa:	70a2                	ld	ra,40(sp)
    800030ac:	7402                	ld	s0,32(sp)
    800030ae:	64e2                	ld	s1,24(sp)
    800030b0:	6942                	ld	s2,16(sp)
    800030b2:	6145                	addi	sp,sp,48
    800030b4:	8082                	ret

00000000800030b6 <syscall>:
[SYS_waitx]   sys_waitx,
};

void
syscall(void)
{
    800030b6:	1101                	addi	sp,sp,-32
    800030b8:	ec06                	sd	ra,24(sp)
    800030ba:	e822                	sd	s0,16(sp)
    800030bc:	e426                	sd	s1,8(sp)
    800030be:	e04a                	sd	s2,0(sp)
    800030c0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800030c2:	fffff097          	auipc	ra,0xfffff
    800030c6:	c34080e7          	jalr	-972(ra) # 80001cf6 <myproc>
    800030ca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800030cc:	05853903          	ld	s2,88(a0)
    800030d0:	0a893783          	ld	a5,168(s2)
    800030d4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800030d8:	37fd                	addiw	a5,a5,-1
    800030da:	4755                	li	a4,21
    800030dc:	00f76f63          	bltu	a4,a5,800030fa <syscall+0x44>
    800030e0:	00369713          	slli	a4,a3,0x3
    800030e4:	00005797          	auipc	a5,0x5
    800030e8:	76c78793          	addi	a5,a5,1900 # 80008850 <syscalls>
    800030ec:	97ba                	add	a5,a5,a4
    800030ee:	639c                	ld	a5,0(a5)
    800030f0:	c789                	beqz	a5,800030fa <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800030f2:	9782                	jalr	a5
    800030f4:	06a93823          	sd	a0,112(s2)
    800030f8:	a839                	j	80003116 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800030fa:	15848613          	addi	a2,s1,344
    800030fe:	588c                	lw	a1,48(s1)
    80003100:	00005517          	auipc	a0,0x5
    80003104:	39050513          	addi	a0,a0,912 # 80008490 <etext+0x490>
    80003108:	ffffd097          	auipc	ra,0xffffd
    8000310c:	480080e7          	jalr	1152(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003110:	6cbc                	ld	a5,88(s1)
    80003112:	577d                	li	a4,-1
    80003114:	fbb8                	sd	a4,112(a5)
  }
}
    80003116:	60e2                	ld	ra,24(sp)
    80003118:	6442                	ld	s0,16(sp)
    8000311a:	64a2                	ld	s1,8(sp)
    8000311c:	6902                	ld	s2,0(sp)
    8000311e:	6105                	addi	sp,sp,32
    80003120:	8082                	ret

0000000080003122 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003122:	1101                	addi	sp,sp,-32
    80003124:	ec06                	sd	ra,24(sp)
    80003126:	e822                	sd	s0,16(sp)
    80003128:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000312a:	fec40593          	addi	a1,s0,-20
    8000312e:	4501                	li	a0,0
    80003130:	00000097          	auipc	ra,0x0
    80003134:	f0e080e7          	jalr	-242(ra) # 8000303e <argint>
  exit(n);
    80003138:	fec42503          	lw	a0,-20(s0)
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	3ca080e7          	jalr	970(ra) # 80002506 <exit>
  return 0; // not reached
}
    80003144:	4501                	li	a0,0
    80003146:	60e2                	ld	ra,24(sp)
    80003148:	6442                	ld	s0,16(sp)
    8000314a:	6105                	addi	sp,sp,32
    8000314c:	8082                	ret

000000008000314e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000314e:	1141                	addi	sp,sp,-16
    80003150:	e406                	sd	ra,8(sp)
    80003152:	e022                	sd	s0,0(sp)
    80003154:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003156:	fffff097          	auipc	ra,0xfffff
    8000315a:	ba0080e7          	jalr	-1120(ra) # 80001cf6 <myproc>
}
    8000315e:	5908                	lw	a0,48(a0)
    80003160:	60a2                	ld	ra,8(sp)
    80003162:	6402                	ld	s0,0(sp)
    80003164:	0141                	addi	sp,sp,16
    80003166:	8082                	ret

0000000080003168 <sys_fork>:

uint64
sys_fork(void)
{
    80003168:	1141                	addi	sp,sp,-16
    8000316a:	e406                	sd	ra,8(sp)
    8000316c:	e022                	sd	s0,0(sp)
    8000316e:	0800                	addi	s0,sp,16
  return fork();
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	f50080e7          	jalr	-176(ra) # 800020c0 <fork>
}
    80003178:	60a2                	ld	ra,8(sp)
    8000317a:	6402                	ld	s0,0(sp)
    8000317c:	0141                	addi	sp,sp,16
    8000317e:	8082                	ret

0000000080003180 <sys_wait>:

uint64
sys_wait(void)
{
    80003180:	1101                	addi	sp,sp,-32
    80003182:	ec06                	sd	ra,24(sp)
    80003184:	e822                	sd	s0,16(sp)
    80003186:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003188:	fe840593          	addi	a1,s0,-24
    8000318c:	4501                	li	a0,0
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	ed0080e7          	jalr	-304(ra) # 8000305e <argaddr>
  return wait(p);
    80003196:	fe843503          	ld	a0,-24(s0)
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	51e080e7          	jalr	1310(ra) # 800026b8 <wait>
}
    800031a2:	60e2                	ld	ra,24(sp)
    800031a4:	6442                	ld	s0,16(sp)
    800031a6:	6105                	addi	sp,sp,32
    800031a8:	8082                	ret

00000000800031aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800031aa:	7179                	addi	sp,sp,-48
    800031ac:	f406                	sd	ra,40(sp)
    800031ae:	f022                	sd	s0,32(sp)
    800031b0:	ec26                	sd	s1,24(sp)
    800031b2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800031b4:	fdc40593          	addi	a1,s0,-36
    800031b8:	4501                	li	a0,0
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	e84080e7          	jalr	-380(ra) # 8000303e <argint>
  addr = myproc()->sz;
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	b34080e7          	jalr	-1228(ra) # 80001cf6 <myproc>
    800031ca:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800031cc:	fdc42503          	lw	a0,-36(s0)
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	e94080e7          	jalr	-364(ra) # 80002064 <growproc>
    800031d8:	00054863          	bltz	a0,800031e8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800031dc:	8526                	mv	a0,s1
    800031de:	70a2                	ld	ra,40(sp)
    800031e0:	7402                	ld	s0,32(sp)
    800031e2:	64e2                	ld	s1,24(sp)
    800031e4:	6145                	addi	sp,sp,48
    800031e6:	8082                	ret
    return -1;
    800031e8:	54fd                	li	s1,-1
    800031ea:	bfcd                	j	800031dc <sys_sbrk+0x32>

00000000800031ec <sys_sleep>:

uint64
sys_sleep(void)
{
    800031ec:	7139                	addi	sp,sp,-64
    800031ee:	fc06                	sd	ra,56(sp)
    800031f0:	f822                	sd	s0,48(sp)
    800031f2:	f426                	sd	s1,40(sp)
    800031f4:	f04a                	sd	s2,32(sp)
    800031f6:	ec4e                	sd	s3,24(sp)
    800031f8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800031fa:	fcc40593          	addi	a1,s0,-52
    800031fe:	4501                	li	a0,0
    80003200:	00000097          	auipc	ra,0x0
    80003204:	e3e080e7          	jalr	-450(ra) # 8000303e <argint>
  acquire(&tickslock);
    80003208:	00234517          	auipc	a0,0x234
    8000320c:	c4050513          	addi	a0,a0,-960 # 80236e48 <tickslock>
    80003210:	ffffe097          	auipc	ra,0xffffe
    80003214:	bd6080e7          	jalr	-1066(ra) # 80000de6 <acquire>
  ticks0 = ticks;
    80003218:	00005917          	auipc	s2,0x5
    8000321c:	77892903          	lw	s2,1912(s2) # 80008990 <ticks>
  while (ticks - ticks0 < n)
    80003220:	fcc42783          	lw	a5,-52(s0)
    80003224:	cf9d                	beqz	a5,80003262 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003226:	00234997          	auipc	s3,0x234
    8000322a:	c2298993          	addi	s3,s3,-990 # 80236e48 <tickslock>
    8000322e:	00005497          	auipc	s1,0x5
    80003232:	76248493          	addi	s1,s1,1890 # 80008990 <ticks>
    if (killed(myproc()))
    80003236:	fffff097          	auipc	ra,0xfffff
    8000323a:	ac0080e7          	jalr	-1344(ra) # 80001cf6 <myproc>
    8000323e:	fffff097          	auipc	ra,0xfffff
    80003242:	448080e7          	jalr	1096(ra) # 80002686 <killed>
    80003246:	ed15                	bnez	a0,80003282 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003248:	85ce                	mv	a1,s3
    8000324a:	8526                	mv	a0,s1
    8000324c:	fffff097          	auipc	ra,0xfffff
    80003250:	186080e7          	jalr	390(ra) # 800023d2 <sleep>
  while (ticks - ticks0 < n)
    80003254:	409c                	lw	a5,0(s1)
    80003256:	412787bb          	subw	a5,a5,s2
    8000325a:	fcc42703          	lw	a4,-52(s0)
    8000325e:	fce7ece3          	bltu	a5,a4,80003236 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003262:	00234517          	auipc	a0,0x234
    80003266:	be650513          	addi	a0,a0,-1050 # 80236e48 <tickslock>
    8000326a:	ffffe097          	auipc	ra,0xffffe
    8000326e:	c30080e7          	jalr	-976(ra) # 80000e9a <release>
  return 0;
    80003272:	4501                	li	a0,0
}
    80003274:	70e2                	ld	ra,56(sp)
    80003276:	7442                	ld	s0,48(sp)
    80003278:	74a2                	ld	s1,40(sp)
    8000327a:	7902                	ld	s2,32(sp)
    8000327c:	69e2                	ld	s3,24(sp)
    8000327e:	6121                	addi	sp,sp,64
    80003280:	8082                	ret
      release(&tickslock);
    80003282:	00234517          	auipc	a0,0x234
    80003286:	bc650513          	addi	a0,a0,-1082 # 80236e48 <tickslock>
    8000328a:	ffffe097          	auipc	ra,0xffffe
    8000328e:	c10080e7          	jalr	-1008(ra) # 80000e9a <release>
      return -1;
    80003292:	557d                	li	a0,-1
    80003294:	b7c5                	j	80003274 <sys_sleep+0x88>

0000000080003296 <sys_kill>:

uint64
sys_kill(void)
{
    80003296:	1101                	addi	sp,sp,-32
    80003298:	ec06                	sd	ra,24(sp)
    8000329a:	e822                	sd	s0,16(sp)
    8000329c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000329e:	fec40593          	addi	a1,s0,-20
    800032a2:	4501                	li	a0,0
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	d9a080e7          	jalr	-614(ra) # 8000303e <argint>
  return kill(pid);
    800032ac:	fec42503          	lw	a0,-20(s0)
    800032b0:	fffff097          	auipc	ra,0xfffff
    800032b4:	338080e7          	jalr	824(ra) # 800025e8 <kill>
}
    800032b8:	60e2                	ld	ra,24(sp)
    800032ba:	6442                	ld	s0,16(sp)
    800032bc:	6105                	addi	sp,sp,32
    800032be:	8082                	ret

00000000800032c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800032c0:	1101                	addi	sp,sp,-32
    800032c2:	ec06                	sd	ra,24(sp)
    800032c4:	e822                	sd	s0,16(sp)
    800032c6:	e426                	sd	s1,8(sp)
    800032c8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800032ca:	00234517          	auipc	a0,0x234
    800032ce:	b7e50513          	addi	a0,a0,-1154 # 80236e48 <tickslock>
    800032d2:	ffffe097          	auipc	ra,0xffffe
    800032d6:	b14080e7          	jalr	-1260(ra) # 80000de6 <acquire>
  xticks = ticks;
    800032da:	00005497          	auipc	s1,0x5
    800032de:	6b64a483          	lw	s1,1718(s1) # 80008990 <ticks>
  release(&tickslock);
    800032e2:	00234517          	auipc	a0,0x234
    800032e6:	b6650513          	addi	a0,a0,-1178 # 80236e48 <tickslock>
    800032ea:	ffffe097          	auipc	ra,0xffffe
    800032ee:	bb0080e7          	jalr	-1104(ra) # 80000e9a <release>
  return xticks;
}
    800032f2:	02049513          	slli	a0,s1,0x20
    800032f6:	9101                	srli	a0,a0,0x20
    800032f8:	60e2                	ld	ra,24(sp)
    800032fa:	6442                	ld	s0,16(sp)
    800032fc:	64a2                	ld	s1,8(sp)
    800032fe:	6105                	addi	sp,sp,32
    80003300:	8082                	ret

0000000080003302 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003302:	7139                	addi	sp,sp,-64
    80003304:	fc06                	sd	ra,56(sp)
    80003306:	f822                	sd	s0,48(sp)
    80003308:	f426                	sd	s1,40(sp)
    8000330a:	f04a                	sd	s2,32(sp)
    8000330c:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    8000330e:	fd840593          	addi	a1,s0,-40
    80003312:	4501                	li	a0,0
    80003314:	00000097          	auipc	ra,0x0
    80003318:	d4a080e7          	jalr	-694(ra) # 8000305e <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000331c:	fd040593          	addi	a1,s0,-48
    80003320:	4505                	li	a0,1
    80003322:	00000097          	auipc	ra,0x0
    80003326:	d3c080e7          	jalr	-708(ra) # 8000305e <argaddr>
  argaddr(2, &addr2);
    8000332a:	fc840593          	addi	a1,s0,-56
    8000332e:	4509                	li	a0,2
    80003330:	00000097          	auipc	ra,0x0
    80003334:	d2e080e7          	jalr	-722(ra) # 8000305e <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    80003338:	fc040613          	addi	a2,s0,-64
    8000333c:	fc440593          	addi	a1,s0,-60
    80003340:	fd843503          	ld	a0,-40(s0)
    80003344:	fffff097          	auipc	ra,0xfffff
    80003348:	5fc080e7          	jalr	1532(ra) # 80002940 <waitx>
    8000334c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000334e:	fffff097          	auipc	ra,0xfffff
    80003352:	9a8080e7          	jalr	-1624(ra) # 80001cf6 <myproc>
    80003356:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003358:	4691                	li	a3,4
    8000335a:	fc440613          	addi	a2,s0,-60
    8000335e:	fd043583          	ld	a1,-48(s0)
    80003362:	6928                	ld	a0,80(a0)
    80003364:	ffffe097          	auipc	ra,0xffffe
    80003368:	63a080e7          	jalr	1594(ra) # 8000199e <copyout>
    return -1;
    8000336c:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000336e:	00054f63          	bltz	a0,8000338c <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003372:	4691                	li	a3,4
    80003374:	fc040613          	addi	a2,s0,-64
    80003378:	fc843583          	ld	a1,-56(s0)
    8000337c:	68a8                	ld	a0,80(s1)
    8000337e:	ffffe097          	auipc	ra,0xffffe
    80003382:	620080e7          	jalr	1568(ra) # 8000199e <copyout>
    80003386:	00054a63          	bltz	a0,8000339a <sys_waitx+0x98>
    return -1;
  return ret;
    8000338a:	87ca                	mv	a5,s2
    8000338c:	853e                	mv	a0,a5
    8000338e:	70e2                	ld	ra,56(sp)
    80003390:	7442                	ld	s0,48(sp)
    80003392:	74a2                	ld	s1,40(sp)
    80003394:	7902                	ld	s2,32(sp)
    80003396:	6121                	addi	sp,sp,64
    80003398:	8082                	ret
    return -1;
    8000339a:	57fd                	li	a5,-1
    8000339c:	bfc5                	j	8000338c <sys_waitx+0x8a>

000000008000339e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000339e:	7179                	addi	sp,sp,-48
    800033a0:	f406                	sd	ra,40(sp)
    800033a2:	f022                	sd	s0,32(sp)
    800033a4:	ec26                	sd	s1,24(sp)
    800033a6:	e84a                	sd	s2,16(sp)
    800033a8:	e44e                	sd	s3,8(sp)
    800033aa:	e052                	sd	s4,0(sp)
    800033ac:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800033ae:	00005597          	auipc	a1,0x5
    800033b2:	10258593          	addi	a1,a1,258 # 800084b0 <etext+0x4b0>
    800033b6:	00234517          	auipc	a0,0x234
    800033ba:	aaa50513          	addi	a0,a0,-1366 # 80236e60 <bcache>
    800033be:	ffffe097          	auipc	ra,0xffffe
    800033c2:	998080e7          	jalr	-1640(ra) # 80000d56 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800033c6:	0023c797          	auipc	a5,0x23c
    800033ca:	a9a78793          	addi	a5,a5,-1382 # 8023ee60 <bcache+0x8000>
    800033ce:	0023c717          	auipc	a4,0x23c
    800033d2:	cfa70713          	addi	a4,a4,-774 # 8023f0c8 <bcache+0x8268>
    800033d6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800033da:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033de:	00234497          	auipc	s1,0x234
    800033e2:	a9a48493          	addi	s1,s1,-1382 # 80236e78 <bcache+0x18>
    b->next = bcache.head.next;
    800033e6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033e8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033ea:	00005a17          	auipc	s4,0x5
    800033ee:	0cea0a13          	addi	s4,s4,206 # 800084b8 <etext+0x4b8>
    b->next = bcache.head.next;
    800033f2:	2b893783          	ld	a5,696(s2)
    800033f6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033f8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033fc:	85d2                	mv	a1,s4
    800033fe:	01048513          	addi	a0,s1,16
    80003402:	00001097          	auipc	ra,0x1
    80003406:	4c4080e7          	jalr	1220(ra) # 800048c6 <initsleeplock>
    bcache.head.next->prev = b;
    8000340a:	2b893783          	ld	a5,696(s2)
    8000340e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003410:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003414:	45848493          	addi	s1,s1,1112
    80003418:	fd349de3          	bne	s1,s3,800033f2 <binit+0x54>
  }
}
    8000341c:	70a2                	ld	ra,40(sp)
    8000341e:	7402                	ld	s0,32(sp)
    80003420:	64e2                	ld	s1,24(sp)
    80003422:	6942                	ld	s2,16(sp)
    80003424:	69a2                	ld	s3,8(sp)
    80003426:	6a02                	ld	s4,0(sp)
    80003428:	6145                	addi	sp,sp,48
    8000342a:	8082                	ret

000000008000342c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000342c:	7179                	addi	sp,sp,-48
    8000342e:	f406                	sd	ra,40(sp)
    80003430:	f022                	sd	s0,32(sp)
    80003432:	ec26                	sd	s1,24(sp)
    80003434:	e84a                	sd	s2,16(sp)
    80003436:	e44e                	sd	s3,8(sp)
    80003438:	1800                	addi	s0,sp,48
    8000343a:	892a                	mv	s2,a0
    8000343c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000343e:	00234517          	auipc	a0,0x234
    80003442:	a2250513          	addi	a0,a0,-1502 # 80236e60 <bcache>
    80003446:	ffffe097          	auipc	ra,0xffffe
    8000344a:	9a0080e7          	jalr	-1632(ra) # 80000de6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000344e:	0023c497          	auipc	s1,0x23c
    80003452:	cca4b483          	ld	s1,-822(s1) # 8023f118 <bcache+0x82b8>
    80003456:	0023c797          	auipc	a5,0x23c
    8000345a:	c7278793          	addi	a5,a5,-910 # 8023f0c8 <bcache+0x8268>
    8000345e:	02f48f63          	beq	s1,a5,8000349c <bread+0x70>
    80003462:	873e                	mv	a4,a5
    80003464:	a021                	j	8000346c <bread+0x40>
    80003466:	68a4                	ld	s1,80(s1)
    80003468:	02e48a63          	beq	s1,a4,8000349c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000346c:	449c                	lw	a5,8(s1)
    8000346e:	ff279ce3          	bne	a5,s2,80003466 <bread+0x3a>
    80003472:	44dc                	lw	a5,12(s1)
    80003474:	ff3799e3          	bne	a5,s3,80003466 <bread+0x3a>
      b->refcnt++;
    80003478:	40bc                	lw	a5,64(s1)
    8000347a:	2785                	addiw	a5,a5,1
    8000347c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000347e:	00234517          	auipc	a0,0x234
    80003482:	9e250513          	addi	a0,a0,-1566 # 80236e60 <bcache>
    80003486:	ffffe097          	auipc	ra,0xffffe
    8000348a:	a14080e7          	jalr	-1516(ra) # 80000e9a <release>
      acquiresleep(&b->lock);
    8000348e:	01048513          	addi	a0,s1,16
    80003492:	00001097          	auipc	ra,0x1
    80003496:	46e080e7          	jalr	1134(ra) # 80004900 <acquiresleep>
      return b;
    8000349a:	a8b9                	j	800034f8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000349c:	0023c497          	auipc	s1,0x23c
    800034a0:	c744b483          	ld	s1,-908(s1) # 8023f110 <bcache+0x82b0>
    800034a4:	0023c797          	auipc	a5,0x23c
    800034a8:	c2478793          	addi	a5,a5,-988 # 8023f0c8 <bcache+0x8268>
    800034ac:	00f48863          	beq	s1,a5,800034bc <bread+0x90>
    800034b0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800034b2:	40bc                	lw	a5,64(s1)
    800034b4:	cf81                	beqz	a5,800034cc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034b6:	64a4                	ld	s1,72(s1)
    800034b8:	fee49de3          	bne	s1,a4,800034b2 <bread+0x86>
  panic("bget: no buffers");
    800034bc:	00005517          	auipc	a0,0x5
    800034c0:	00450513          	addi	a0,a0,4 # 800084c0 <etext+0x4c0>
    800034c4:	ffffd097          	auipc	ra,0xffffd
    800034c8:	07a080e7          	jalr	122(ra) # 8000053e <panic>
      b->dev = dev;
    800034cc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800034d0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800034d4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800034d8:	4785                	li	a5,1
    800034da:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034dc:	00234517          	auipc	a0,0x234
    800034e0:	98450513          	addi	a0,a0,-1660 # 80236e60 <bcache>
    800034e4:	ffffe097          	auipc	ra,0xffffe
    800034e8:	9b6080e7          	jalr	-1610(ra) # 80000e9a <release>
      acquiresleep(&b->lock);
    800034ec:	01048513          	addi	a0,s1,16
    800034f0:	00001097          	auipc	ra,0x1
    800034f4:	410080e7          	jalr	1040(ra) # 80004900 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034f8:	409c                	lw	a5,0(s1)
    800034fa:	cb89                	beqz	a5,8000350c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034fc:	8526                	mv	a0,s1
    800034fe:	70a2                	ld	ra,40(sp)
    80003500:	7402                	ld	s0,32(sp)
    80003502:	64e2                	ld	s1,24(sp)
    80003504:	6942                	ld	s2,16(sp)
    80003506:	69a2                	ld	s3,8(sp)
    80003508:	6145                	addi	sp,sp,48
    8000350a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000350c:	4581                	li	a1,0
    8000350e:	8526                	mv	a0,s1
    80003510:	00003097          	auipc	ra,0x3
    80003514:	fd4080e7          	jalr	-44(ra) # 800064e4 <virtio_disk_rw>
    b->valid = 1;
    80003518:	4785                	li	a5,1
    8000351a:	c09c                	sw	a5,0(s1)
  return b;
    8000351c:	b7c5                	j	800034fc <bread+0xd0>

000000008000351e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000351e:	1101                	addi	sp,sp,-32
    80003520:	ec06                	sd	ra,24(sp)
    80003522:	e822                	sd	s0,16(sp)
    80003524:	e426                	sd	s1,8(sp)
    80003526:	1000                	addi	s0,sp,32
    80003528:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000352a:	0541                	addi	a0,a0,16
    8000352c:	00001097          	auipc	ra,0x1
    80003530:	46e080e7          	jalr	1134(ra) # 8000499a <holdingsleep>
    80003534:	cd01                	beqz	a0,8000354c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003536:	4585                	li	a1,1
    80003538:	8526                	mv	a0,s1
    8000353a:	00003097          	auipc	ra,0x3
    8000353e:	faa080e7          	jalr	-86(ra) # 800064e4 <virtio_disk_rw>
}
    80003542:	60e2                	ld	ra,24(sp)
    80003544:	6442                	ld	s0,16(sp)
    80003546:	64a2                	ld	s1,8(sp)
    80003548:	6105                	addi	sp,sp,32
    8000354a:	8082                	ret
    panic("bwrite");
    8000354c:	00005517          	auipc	a0,0x5
    80003550:	f8c50513          	addi	a0,a0,-116 # 800084d8 <etext+0x4d8>
    80003554:	ffffd097          	auipc	ra,0xffffd
    80003558:	fea080e7          	jalr	-22(ra) # 8000053e <panic>

000000008000355c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000355c:	1101                	addi	sp,sp,-32
    8000355e:	ec06                	sd	ra,24(sp)
    80003560:	e822                	sd	s0,16(sp)
    80003562:	e426                	sd	s1,8(sp)
    80003564:	e04a                	sd	s2,0(sp)
    80003566:	1000                	addi	s0,sp,32
    80003568:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000356a:	01050913          	addi	s2,a0,16
    8000356e:	854a                	mv	a0,s2
    80003570:	00001097          	auipc	ra,0x1
    80003574:	42a080e7          	jalr	1066(ra) # 8000499a <holdingsleep>
    80003578:	c92d                	beqz	a0,800035ea <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000357a:	854a                	mv	a0,s2
    8000357c:	00001097          	auipc	ra,0x1
    80003580:	3da080e7          	jalr	986(ra) # 80004956 <releasesleep>

  acquire(&bcache.lock);
    80003584:	00234517          	auipc	a0,0x234
    80003588:	8dc50513          	addi	a0,a0,-1828 # 80236e60 <bcache>
    8000358c:	ffffe097          	auipc	ra,0xffffe
    80003590:	85a080e7          	jalr	-1958(ra) # 80000de6 <acquire>
  b->refcnt--;
    80003594:	40bc                	lw	a5,64(s1)
    80003596:	37fd                	addiw	a5,a5,-1
    80003598:	0007871b          	sext.w	a4,a5
    8000359c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000359e:	eb05                	bnez	a4,800035ce <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035a0:	68bc                	ld	a5,80(s1)
    800035a2:	64b8                	ld	a4,72(s1)
    800035a4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800035a6:	64bc                	ld	a5,72(s1)
    800035a8:	68b8                	ld	a4,80(s1)
    800035aa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800035ac:	0023c797          	auipc	a5,0x23c
    800035b0:	8b478793          	addi	a5,a5,-1868 # 8023ee60 <bcache+0x8000>
    800035b4:	2b87b703          	ld	a4,696(a5)
    800035b8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800035ba:	0023c717          	auipc	a4,0x23c
    800035be:	b0e70713          	addi	a4,a4,-1266 # 8023f0c8 <bcache+0x8268>
    800035c2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800035c4:	2b87b703          	ld	a4,696(a5)
    800035c8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800035ca:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800035ce:	00234517          	auipc	a0,0x234
    800035d2:	89250513          	addi	a0,a0,-1902 # 80236e60 <bcache>
    800035d6:	ffffe097          	auipc	ra,0xffffe
    800035da:	8c4080e7          	jalr	-1852(ra) # 80000e9a <release>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6902                	ld	s2,0(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret
    panic("brelse");
    800035ea:	00005517          	auipc	a0,0x5
    800035ee:	ef650513          	addi	a0,a0,-266 # 800084e0 <etext+0x4e0>
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	f4c080e7          	jalr	-180(ra) # 8000053e <panic>

00000000800035fa <bpin>:

void
bpin(struct buf *b) {
    800035fa:	1101                	addi	sp,sp,-32
    800035fc:	ec06                	sd	ra,24(sp)
    800035fe:	e822                	sd	s0,16(sp)
    80003600:	e426                	sd	s1,8(sp)
    80003602:	1000                	addi	s0,sp,32
    80003604:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003606:	00234517          	auipc	a0,0x234
    8000360a:	85a50513          	addi	a0,a0,-1958 # 80236e60 <bcache>
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	7d8080e7          	jalr	2008(ra) # 80000de6 <acquire>
  b->refcnt++;
    80003616:	40bc                	lw	a5,64(s1)
    80003618:	2785                	addiw	a5,a5,1
    8000361a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000361c:	00234517          	auipc	a0,0x234
    80003620:	84450513          	addi	a0,a0,-1980 # 80236e60 <bcache>
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	876080e7          	jalr	-1930(ra) # 80000e9a <release>
}
    8000362c:	60e2                	ld	ra,24(sp)
    8000362e:	6442                	ld	s0,16(sp)
    80003630:	64a2                	ld	s1,8(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <bunpin>:

void
bunpin(struct buf *b) {
    80003636:	1101                	addi	sp,sp,-32
    80003638:	ec06                	sd	ra,24(sp)
    8000363a:	e822                	sd	s0,16(sp)
    8000363c:	e426                	sd	s1,8(sp)
    8000363e:	1000                	addi	s0,sp,32
    80003640:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003642:	00234517          	auipc	a0,0x234
    80003646:	81e50513          	addi	a0,a0,-2018 # 80236e60 <bcache>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	79c080e7          	jalr	1948(ra) # 80000de6 <acquire>
  b->refcnt--;
    80003652:	40bc                	lw	a5,64(s1)
    80003654:	37fd                	addiw	a5,a5,-1
    80003656:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003658:	00234517          	auipc	a0,0x234
    8000365c:	80850513          	addi	a0,a0,-2040 # 80236e60 <bcache>
    80003660:	ffffe097          	auipc	ra,0xffffe
    80003664:	83a080e7          	jalr	-1990(ra) # 80000e9a <release>
}
    80003668:	60e2                	ld	ra,24(sp)
    8000366a:	6442                	ld	s0,16(sp)
    8000366c:	64a2                	ld	s1,8(sp)
    8000366e:	6105                	addi	sp,sp,32
    80003670:	8082                	ret

0000000080003672 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003672:	1101                	addi	sp,sp,-32
    80003674:	ec06                	sd	ra,24(sp)
    80003676:	e822                	sd	s0,16(sp)
    80003678:	e426                	sd	s1,8(sp)
    8000367a:	e04a                	sd	s2,0(sp)
    8000367c:	1000                	addi	s0,sp,32
    8000367e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003680:	00d5d59b          	srliw	a1,a1,0xd
    80003684:	0023c797          	auipc	a5,0x23c
    80003688:	eb87a783          	lw	a5,-328(a5) # 8023f53c <sb+0x1c>
    8000368c:	9dbd                	addw	a1,a1,a5
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	d9e080e7          	jalr	-610(ra) # 8000342c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003696:	0074f713          	andi	a4,s1,7
    8000369a:	4785                	li	a5,1
    8000369c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800036a0:	14ce                	slli	s1,s1,0x33
    800036a2:	90d9                	srli	s1,s1,0x36
    800036a4:	00950733          	add	a4,a0,s1
    800036a8:	05874703          	lbu	a4,88(a4)
    800036ac:	00e7f6b3          	and	a3,a5,a4
    800036b0:	c69d                	beqz	a3,800036de <bfree+0x6c>
    800036b2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800036b4:	94aa                	add	s1,s1,a0
    800036b6:	fff7c793          	not	a5,a5
    800036ba:	8ff9                	and	a5,a5,a4
    800036bc:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800036c0:	00001097          	auipc	ra,0x1
    800036c4:	120080e7          	jalr	288(ra) # 800047e0 <log_write>
  brelse(bp);
    800036c8:	854a                	mv	a0,s2
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	e92080e7          	jalr	-366(ra) # 8000355c <brelse>
}
    800036d2:	60e2                	ld	ra,24(sp)
    800036d4:	6442                	ld	s0,16(sp)
    800036d6:	64a2                	ld	s1,8(sp)
    800036d8:	6902                	ld	s2,0(sp)
    800036da:	6105                	addi	sp,sp,32
    800036dc:	8082                	ret
    panic("freeing free block");
    800036de:	00005517          	auipc	a0,0x5
    800036e2:	e0a50513          	addi	a0,a0,-502 # 800084e8 <etext+0x4e8>
    800036e6:	ffffd097          	auipc	ra,0xffffd
    800036ea:	e58080e7          	jalr	-424(ra) # 8000053e <panic>

00000000800036ee <balloc>:
{
    800036ee:	711d                	addi	sp,sp,-96
    800036f0:	ec86                	sd	ra,88(sp)
    800036f2:	e8a2                	sd	s0,80(sp)
    800036f4:	e4a6                	sd	s1,72(sp)
    800036f6:	e0ca                	sd	s2,64(sp)
    800036f8:	fc4e                	sd	s3,56(sp)
    800036fa:	f852                	sd	s4,48(sp)
    800036fc:	f456                	sd	s5,40(sp)
    800036fe:	f05a                	sd	s6,32(sp)
    80003700:	ec5e                	sd	s7,24(sp)
    80003702:	e862                	sd	s8,16(sp)
    80003704:	e466                	sd	s9,8(sp)
    80003706:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003708:	0023c797          	auipc	a5,0x23c
    8000370c:	e1c7a783          	lw	a5,-484(a5) # 8023f524 <sb+0x4>
    80003710:	10078163          	beqz	a5,80003812 <balloc+0x124>
    80003714:	8baa                	mv	s7,a0
    80003716:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003718:	0023cb17          	auipc	s6,0x23c
    8000371c:	e08b0b13          	addi	s6,s6,-504 # 8023f520 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003720:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003722:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003724:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003726:	6c89                	lui	s9,0x2
    80003728:	a061                	j	800037b0 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000372a:	974a                	add	a4,a4,s2
    8000372c:	8fd5                	or	a5,a5,a3
    8000372e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003732:	854a                	mv	a0,s2
    80003734:	00001097          	auipc	ra,0x1
    80003738:	0ac080e7          	jalr	172(ra) # 800047e0 <log_write>
        brelse(bp);
    8000373c:	854a                	mv	a0,s2
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	e1e080e7          	jalr	-482(ra) # 8000355c <brelse>
  bp = bread(dev, bno);
    80003746:	85a6                	mv	a1,s1
    80003748:	855e                	mv	a0,s7
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	ce2080e7          	jalr	-798(ra) # 8000342c <bread>
    80003752:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003754:	40000613          	li	a2,1024
    80003758:	4581                	li	a1,0
    8000375a:	05850513          	addi	a0,a0,88
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	784080e7          	jalr	1924(ra) # 80000ee2 <memset>
  log_write(bp);
    80003766:	854a                	mv	a0,s2
    80003768:	00001097          	auipc	ra,0x1
    8000376c:	078080e7          	jalr	120(ra) # 800047e0 <log_write>
  brelse(bp);
    80003770:	854a                	mv	a0,s2
    80003772:	00000097          	auipc	ra,0x0
    80003776:	dea080e7          	jalr	-534(ra) # 8000355c <brelse>
}
    8000377a:	8526                	mv	a0,s1
    8000377c:	60e6                	ld	ra,88(sp)
    8000377e:	6446                	ld	s0,80(sp)
    80003780:	64a6                	ld	s1,72(sp)
    80003782:	6906                	ld	s2,64(sp)
    80003784:	79e2                	ld	s3,56(sp)
    80003786:	7a42                	ld	s4,48(sp)
    80003788:	7aa2                	ld	s5,40(sp)
    8000378a:	7b02                	ld	s6,32(sp)
    8000378c:	6be2                	ld	s7,24(sp)
    8000378e:	6c42                	ld	s8,16(sp)
    80003790:	6ca2                	ld	s9,8(sp)
    80003792:	6125                	addi	sp,sp,96
    80003794:	8082                	ret
    brelse(bp);
    80003796:	854a                	mv	a0,s2
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	dc4080e7          	jalr	-572(ra) # 8000355c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037a0:	015c87bb          	addw	a5,s9,s5
    800037a4:	00078a9b          	sext.w	s5,a5
    800037a8:	004b2703          	lw	a4,4(s6)
    800037ac:	06eaf363          	bgeu	s5,a4,80003812 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800037b0:	41fad79b          	sraiw	a5,s5,0x1f
    800037b4:	0137d79b          	srliw	a5,a5,0x13
    800037b8:	015787bb          	addw	a5,a5,s5
    800037bc:	40d7d79b          	sraiw	a5,a5,0xd
    800037c0:	01cb2583          	lw	a1,28(s6)
    800037c4:	9dbd                	addw	a1,a1,a5
    800037c6:	855e                	mv	a0,s7
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	c64080e7          	jalr	-924(ra) # 8000342c <bread>
    800037d0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037d2:	004b2503          	lw	a0,4(s6)
    800037d6:	000a849b          	sext.w	s1,s5
    800037da:	8662                	mv	a2,s8
    800037dc:	faa4fde3          	bgeu	s1,a0,80003796 <balloc+0xa8>
      m = 1 << (bi % 8);
    800037e0:	41f6579b          	sraiw	a5,a2,0x1f
    800037e4:	01d7d69b          	srliw	a3,a5,0x1d
    800037e8:	00c6873b          	addw	a4,a3,a2
    800037ec:	00777793          	andi	a5,a4,7
    800037f0:	9f95                	subw	a5,a5,a3
    800037f2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800037f6:	4037571b          	sraiw	a4,a4,0x3
    800037fa:	00e906b3          	add	a3,s2,a4
    800037fe:	0586c683          	lbu	a3,88(a3)
    80003802:	00d7f5b3          	and	a1,a5,a3
    80003806:	d195                	beqz	a1,8000372a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003808:	2605                	addiw	a2,a2,1
    8000380a:	2485                	addiw	s1,s1,1
    8000380c:	fd4618e3          	bne	a2,s4,800037dc <balloc+0xee>
    80003810:	b759                	j	80003796 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003812:	00005517          	auipc	a0,0x5
    80003816:	cee50513          	addi	a0,a0,-786 # 80008500 <etext+0x500>
    8000381a:	ffffd097          	auipc	ra,0xffffd
    8000381e:	d6e080e7          	jalr	-658(ra) # 80000588 <printf>
  return 0;
    80003822:	4481                	li	s1,0
    80003824:	bf99                	j	8000377a <balloc+0x8c>

0000000080003826 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003826:	7179                	addi	sp,sp,-48
    80003828:	f406                	sd	ra,40(sp)
    8000382a:	f022                	sd	s0,32(sp)
    8000382c:	ec26                	sd	s1,24(sp)
    8000382e:	e84a                	sd	s2,16(sp)
    80003830:	e44e                	sd	s3,8(sp)
    80003832:	e052                	sd	s4,0(sp)
    80003834:	1800                	addi	s0,sp,48
    80003836:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003838:	47ad                	li	a5,11
    8000383a:	02b7e763          	bltu	a5,a1,80003868 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000383e:	02059493          	slli	s1,a1,0x20
    80003842:	9081                	srli	s1,s1,0x20
    80003844:	048a                	slli	s1,s1,0x2
    80003846:	94aa                	add	s1,s1,a0
    80003848:	0504a903          	lw	s2,80(s1)
    8000384c:	06091e63          	bnez	s2,800038c8 <bmap+0xa2>
      addr = balloc(ip->dev);
    80003850:	4108                	lw	a0,0(a0)
    80003852:	00000097          	auipc	ra,0x0
    80003856:	e9c080e7          	jalr	-356(ra) # 800036ee <balloc>
    8000385a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000385e:	06090563          	beqz	s2,800038c8 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003862:	0524a823          	sw	s2,80(s1)
    80003866:	a08d                	j	800038c8 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003868:	ff45849b          	addiw	s1,a1,-12
    8000386c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003870:	0ff00793          	li	a5,255
    80003874:	08e7e563          	bltu	a5,a4,800038fe <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003878:	08052903          	lw	s2,128(a0)
    8000387c:	00091d63          	bnez	s2,80003896 <bmap+0x70>
      addr = balloc(ip->dev);
    80003880:	4108                	lw	a0,0(a0)
    80003882:	00000097          	auipc	ra,0x0
    80003886:	e6c080e7          	jalr	-404(ra) # 800036ee <balloc>
    8000388a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000388e:	02090d63          	beqz	s2,800038c8 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003892:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003896:	85ca                	mv	a1,s2
    80003898:	0009a503          	lw	a0,0(s3)
    8000389c:	00000097          	auipc	ra,0x0
    800038a0:	b90080e7          	jalr	-1136(ra) # 8000342c <bread>
    800038a4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038a6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800038aa:	02049593          	slli	a1,s1,0x20
    800038ae:	9181                	srli	a1,a1,0x20
    800038b0:	058a                	slli	a1,a1,0x2
    800038b2:	00b784b3          	add	s1,a5,a1
    800038b6:	0004a903          	lw	s2,0(s1)
    800038ba:	02090063          	beqz	s2,800038da <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800038be:	8552                	mv	a0,s4
    800038c0:	00000097          	auipc	ra,0x0
    800038c4:	c9c080e7          	jalr	-868(ra) # 8000355c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800038c8:	854a                	mv	a0,s2
    800038ca:	70a2                	ld	ra,40(sp)
    800038cc:	7402                	ld	s0,32(sp)
    800038ce:	64e2                	ld	s1,24(sp)
    800038d0:	6942                	ld	s2,16(sp)
    800038d2:	69a2                	ld	s3,8(sp)
    800038d4:	6a02                	ld	s4,0(sp)
    800038d6:	6145                	addi	sp,sp,48
    800038d8:	8082                	ret
      addr = balloc(ip->dev);
    800038da:	0009a503          	lw	a0,0(s3)
    800038de:	00000097          	auipc	ra,0x0
    800038e2:	e10080e7          	jalr	-496(ra) # 800036ee <balloc>
    800038e6:	0005091b          	sext.w	s2,a0
      if(addr){
    800038ea:	fc090ae3          	beqz	s2,800038be <bmap+0x98>
        a[bn] = addr;
    800038ee:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800038f2:	8552                	mv	a0,s4
    800038f4:	00001097          	auipc	ra,0x1
    800038f8:	eec080e7          	jalr	-276(ra) # 800047e0 <log_write>
    800038fc:	b7c9                	j	800038be <bmap+0x98>
  panic("bmap: out of range");
    800038fe:	00005517          	auipc	a0,0x5
    80003902:	c1a50513          	addi	a0,a0,-998 # 80008518 <etext+0x518>
    80003906:	ffffd097          	auipc	ra,0xffffd
    8000390a:	c38080e7          	jalr	-968(ra) # 8000053e <panic>

000000008000390e <iget>:
{
    8000390e:	7179                	addi	sp,sp,-48
    80003910:	f406                	sd	ra,40(sp)
    80003912:	f022                	sd	s0,32(sp)
    80003914:	ec26                	sd	s1,24(sp)
    80003916:	e84a                	sd	s2,16(sp)
    80003918:	e44e                	sd	s3,8(sp)
    8000391a:	e052                	sd	s4,0(sp)
    8000391c:	1800                	addi	s0,sp,48
    8000391e:	89aa                	mv	s3,a0
    80003920:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003922:	0023c517          	auipc	a0,0x23c
    80003926:	c1e50513          	addi	a0,a0,-994 # 8023f540 <itable>
    8000392a:	ffffd097          	auipc	ra,0xffffd
    8000392e:	4bc080e7          	jalr	1212(ra) # 80000de6 <acquire>
  empty = 0;
    80003932:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003934:	0023c497          	auipc	s1,0x23c
    80003938:	c2448493          	addi	s1,s1,-988 # 8023f558 <itable+0x18>
    8000393c:	0023d697          	auipc	a3,0x23d
    80003940:	6ac68693          	addi	a3,a3,1708 # 80240fe8 <log>
    80003944:	a039                	j	80003952 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003946:	02090b63          	beqz	s2,8000397c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000394a:	08848493          	addi	s1,s1,136
    8000394e:	02d48a63          	beq	s1,a3,80003982 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003952:	449c                	lw	a5,8(s1)
    80003954:	fef059e3          	blez	a5,80003946 <iget+0x38>
    80003958:	4098                	lw	a4,0(s1)
    8000395a:	ff3716e3          	bne	a4,s3,80003946 <iget+0x38>
    8000395e:	40d8                	lw	a4,4(s1)
    80003960:	ff4713e3          	bne	a4,s4,80003946 <iget+0x38>
      ip->ref++;
    80003964:	2785                	addiw	a5,a5,1
    80003966:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003968:	0023c517          	auipc	a0,0x23c
    8000396c:	bd850513          	addi	a0,a0,-1064 # 8023f540 <itable>
    80003970:	ffffd097          	auipc	ra,0xffffd
    80003974:	52a080e7          	jalr	1322(ra) # 80000e9a <release>
      return ip;
    80003978:	8926                	mv	s2,s1
    8000397a:	a03d                	j	800039a8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000397c:	f7f9                	bnez	a5,8000394a <iget+0x3c>
    8000397e:	8926                	mv	s2,s1
    80003980:	b7e9                	j	8000394a <iget+0x3c>
  if(empty == 0)
    80003982:	02090c63          	beqz	s2,800039ba <iget+0xac>
  ip->dev = dev;
    80003986:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000398a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000398e:	4785                	li	a5,1
    80003990:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003994:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003998:	0023c517          	auipc	a0,0x23c
    8000399c:	ba850513          	addi	a0,a0,-1112 # 8023f540 <itable>
    800039a0:	ffffd097          	auipc	ra,0xffffd
    800039a4:	4fa080e7          	jalr	1274(ra) # 80000e9a <release>
}
    800039a8:	854a                	mv	a0,s2
    800039aa:	70a2                	ld	ra,40(sp)
    800039ac:	7402                	ld	s0,32(sp)
    800039ae:	64e2                	ld	s1,24(sp)
    800039b0:	6942                	ld	s2,16(sp)
    800039b2:	69a2                	ld	s3,8(sp)
    800039b4:	6a02                	ld	s4,0(sp)
    800039b6:	6145                	addi	sp,sp,48
    800039b8:	8082                	ret
    panic("iget: no inodes");
    800039ba:	00005517          	auipc	a0,0x5
    800039be:	b7650513          	addi	a0,a0,-1162 # 80008530 <etext+0x530>
    800039c2:	ffffd097          	auipc	ra,0xffffd
    800039c6:	b7c080e7          	jalr	-1156(ra) # 8000053e <panic>

00000000800039ca <fsinit>:
fsinit(int dev) {
    800039ca:	7179                	addi	sp,sp,-48
    800039cc:	f406                	sd	ra,40(sp)
    800039ce:	f022                	sd	s0,32(sp)
    800039d0:	ec26                	sd	s1,24(sp)
    800039d2:	e84a                	sd	s2,16(sp)
    800039d4:	e44e                	sd	s3,8(sp)
    800039d6:	1800                	addi	s0,sp,48
    800039d8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800039da:	4585                	li	a1,1
    800039dc:	00000097          	auipc	ra,0x0
    800039e0:	a50080e7          	jalr	-1456(ra) # 8000342c <bread>
    800039e4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039e6:	0023c997          	auipc	s3,0x23c
    800039ea:	b3a98993          	addi	s3,s3,-1222 # 8023f520 <sb>
    800039ee:	02000613          	li	a2,32
    800039f2:	05850593          	addi	a1,a0,88
    800039f6:	854e                	mv	a0,s3
    800039f8:	ffffd097          	auipc	ra,0xffffd
    800039fc:	546080e7          	jalr	1350(ra) # 80000f3e <memmove>
  brelse(bp);
    80003a00:	8526                	mv	a0,s1
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	b5a080e7          	jalr	-1190(ra) # 8000355c <brelse>
  if(sb.magic != FSMAGIC)
    80003a0a:	0009a703          	lw	a4,0(s3)
    80003a0e:	102037b7          	lui	a5,0x10203
    80003a12:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a16:	02f71263          	bne	a4,a5,80003a3a <fsinit+0x70>
  initlog(dev, &sb);
    80003a1a:	0023c597          	auipc	a1,0x23c
    80003a1e:	b0658593          	addi	a1,a1,-1274 # 8023f520 <sb>
    80003a22:	854a                	mv	a0,s2
    80003a24:	00001097          	auipc	ra,0x1
    80003a28:	b40080e7          	jalr	-1216(ra) # 80004564 <initlog>
}
    80003a2c:	70a2                	ld	ra,40(sp)
    80003a2e:	7402                	ld	s0,32(sp)
    80003a30:	64e2                	ld	s1,24(sp)
    80003a32:	6942                	ld	s2,16(sp)
    80003a34:	69a2                	ld	s3,8(sp)
    80003a36:	6145                	addi	sp,sp,48
    80003a38:	8082                	ret
    panic("invalid file system");
    80003a3a:	00005517          	auipc	a0,0x5
    80003a3e:	b0650513          	addi	a0,a0,-1274 # 80008540 <etext+0x540>
    80003a42:	ffffd097          	auipc	ra,0xffffd
    80003a46:	afc080e7          	jalr	-1284(ra) # 8000053e <panic>

0000000080003a4a <iinit>:
{
    80003a4a:	7179                	addi	sp,sp,-48
    80003a4c:	f406                	sd	ra,40(sp)
    80003a4e:	f022                	sd	s0,32(sp)
    80003a50:	ec26                	sd	s1,24(sp)
    80003a52:	e84a                	sd	s2,16(sp)
    80003a54:	e44e                	sd	s3,8(sp)
    80003a56:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a58:	00005597          	auipc	a1,0x5
    80003a5c:	b0058593          	addi	a1,a1,-1280 # 80008558 <etext+0x558>
    80003a60:	0023c517          	auipc	a0,0x23c
    80003a64:	ae050513          	addi	a0,a0,-1312 # 8023f540 <itable>
    80003a68:	ffffd097          	auipc	ra,0xffffd
    80003a6c:	2ee080e7          	jalr	750(ra) # 80000d56 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a70:	0023c497          	auipc	s1,0x23c
    80003a74:	af848493          	addi	s1,s1,-1288 # 8023f568 <itable+0x28>
    80003a78:	0023d997          	auipc	s3,0x23d
    80003a7c:	58098993          	addi	s3,s3,1408 # 80240ff8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a80:	00005917          	auipc	s2,0x5
    80003a84:	ae090913          	addi	s2,s2,-1312 # 80008560 <etext+0x560>
    80003a88:	85ca                	mv	a1,s2
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	00001097          	auipc	ra,0x1
    80003a90:	e3a080e7          	jalr	-454(ra) # 800048c6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a94:	08848493          	addi	s1,s1,136
    80003a98:	ff3498e3          	bne	s1,s3,80003a88 <iinit+0x3e>
}
    80003a9c:	70a2                	ld	ra,40(sp)
    80003a9e:	7402                	ld	s0,32(sp)
    80003aa0:	64e2                	ld	s1,24(sp)
    80003aa2:	6942                	ld	s2,16(sp)
    80003aa4:	69a2                	ld	s3,8(sp)
    80003aa6:	6145                	addi	sp,sp,48
    80003aa8:	8082                	ret

0000000080003aaa <ialloc>:
{
    80003aaa:	715d                	addi	sp,sp,-80
    80003aac:	e486                	sd	ra,72(sp)
    80003aae:	e0a2                	sd	s0,64(sp)
    80003ab0:	fc26                	sd	s1,56(sp)
    80003ab2:	f84a                	sd	s2,48(sp)
    80003ab4:	f44e                	sd	s3,40(sp)
    80003ab6:	f052                	sd	s4,32(sp)
    80003ab8:	ec56                	sd	s5,24(sp)
    80003aba:	e85a                	sd	s6,16(sp)
    80003abc:	e45e                	sd	s7,8(sp)
    80003abe:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ac0:	0023c717          	auipc	a4,0x23c
    80003ac4:	a6c72703          	lw	a4,-1428(a4) # 8023f52c <sb+0xc>
    80003ac8:	4785                	li	a5,1
    80003aca:	04e7fa63          	bgeu	a5,a4,80003b1e <ialloc+0x74>
    80003ace:	8aaa                	mv	s5,a0
    80003ad0:	8bae                	mv	s7,a1
    80003ad2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003ad4:	0023ca17          	auipc	s4,0x23c
    80003ad8:	a4ca0a13          	addi	s4,s4,-1460 # 8023f520 <sb>
    80003adc:	00048b1b          	sext.w	s6,s1
    80003ae0:	0044d793          	srli	a5,s1,0x4
    80003ae4:	018a2583          	lw	a1,24(s4)
    80003ae8:	9dbd                	addw	a1,a1,a5
    80003aea:	8556                	mv	a0,s5
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	940080e7          	jalr	-1728(ra) # 8000342c <bread>
    80003af4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003af6:	05850993          	addi	s3,a0,88
    80003afa:	00f4f793          	andi	a5,s1,15
    80003afe:	079a                	slli	a5,a5,0x6
    80003b00:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b02:	00099783          	lh	a5,0(s3)
    80003b06:	c3a1                	beqz	a5,80003b46 <ialloc+0x9c>
    brelse(bp);
    80003b08:	00000097          	auipc	ra,0x0
    80003b0c:	a54080e7          	jalr	-1452(ra) # 8000355c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b10:	0485                	addi	s1,s1,1
    80003b12:	00ca2703          	lw	a4,12(s4)
    80003b16:	0004879b          	sext.w	a5,s1
    80003b1a:	fce7e1e3          	bltu	a5,a4,80003adc <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003b1e:	00005517          	auipc	a0,0x5
    80003b22:	a4a50513          	addi	a0,a0,-1462 # 80008568 <etext+0x568>
    80003b26:	ffffd097          	auipc	ra,0xffffd
    80003b2a:	a62080e7          	jalr	-1438(ra) # 80000588 <printf>
  return 0;
    80003b2e:	4501                	li	a0,0
}
    80003b30:	60a6                	ld	ra,72(sp)
    80003b32:	6406                	ld	s0,64(sp)
    80003b34:	74e2                	ld	s1,56(sp)
    80003b36:	7942                	ld	s2,48(sp)
    80003b38:	79a2                	ld	s3,40(sp)
    80003b3a:	7a02                	ld	s4,32(sp)
    80003b3c:	6ae2                	ld	s5,24(sp)
    80003b3e:	6b42                	ld	s6,16(sp)
    80003b40:	6ba2                	ld	s7,8(sp)
    80003b42:	6161                	addi	sp,sp,80
    80003b44:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b46:	04000613          	li	a2,64
    80003b4a:	4581                	li	a1,0
    80003b4c:	854e                	mv	a0,s3
    80003b4e:	ffffd097          	auipc	ra,0xffffd
    80003b52:	394080e7          	jalr	916(ra) # 80000ee2 <memset>
      dip->type = type;
    80003b56:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b5a:	854a                	mv	a0,s2
    80003b5c:	00001097          	auipc	ra,0x1
    80003b60:	c84080e7          	jalr	-892(ra) # 800047e0 <log_write>
      brelse(bp);
    80003b64:	854a                	mv	a0,s2
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	9f6080e7          	jalr	-1546(ra) # 8000355c <brelse>
      return iget(dev, inum);
    80003b6e:	85da                	mv	a1,s6
    80003b70:	8556                	mv	a0,s5
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	d9c080e7          	jalr	-612(ra) # 8000390e <iget>
    80003b7a:	bf5d                	j	80003b30 <ialloc+0x86>

0000000080003b7c <iupdate>:
{
    80003b7c:	1101                	addi	sp,sp,-32
    80003b7e:	ec06                	sd	ra,24(sp)
    80003b80:	e822                	sd	s0,16(sp)
    80003b82:	e426                	sd	s1,8(sp)
    80003b84:	e04a                	sd	s2,0(sp)
    80003b86:	1000                	addi	s0,sp,32
    80003b88:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b8a:	415c                	lw	a5,4(a0)
    80003b8c:	0047d79b          	srliw	a5,a5,0x4
    80003b90:	0023c597          	auipc	a1,0x23c
    80003b94:	9a85a583          	lw	a1,-1624(a1) # 8023f538 <sb+0x18>
    80003b98:	9dbd                	addw	a1,a1,a5
    80003b9a:	4108                	lw	a0,0(a0)
    80003b9c:	00000097          	auipc	ra,0x0
    80003ba0:	890080e7          	jalr	-1904(ra) # 8000342c <bread>
    80003ba4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ba6:	05850793          	addi	a5,a0,88
    80003baa:	40c8                	lw	a0,4(s1)
    80003bac:	893d                	andi	a0,a0,15
    80003bae:	051a                	slli	a0,a0,0x6
    80003bb0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003bb2:	04449703          	lh	a4,68(s1)
    80003bb6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003bba:	04649703          	lh	a4,70(s1)
    80003bbe:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003bc2:	04849703          	lh	a4,72(s1)
    80003bc6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003bca:	04a49703          	lh	a4,74(s1)
    80003bce:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003bd2:	44f8                	lw	a4,76(s1)
    80003bd4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003bd6:	03400613          	li	a2,52
    80003bda:	05048593          	addi	a1,s1,80
    80003bde:	0531                	addi	a0,a0,12
    80003be0:	ffffd097          	auipc	ra,0xffffd
    80003be4:	35e080e7          	jalr	862(ra) # 80000f3e <memmove>
  log_write(bp);
    80003be8:	854a                	mv	a0,s2
    80003bea:	00001097          	auipc	ra,0x1
    80003bee:	bf6080e7          	jalr	-1034(ra) # 800047e0 <log_write>
  brelse(bp);
    80003bf2:	854a                	mv	a0,s2
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	968080e7          	jalr	-1688(ra) # 8000355c <brelse>
}
    80003bfc:	60e2                	ld	ra,24(sp)
    80003bfe:	6442                	ld	s0,16(sp)
    80003c00:	64a2                	ld	s1,8(sp)
    80003c02:	6902                	ld	s2,0(sp)
    80003c04:	6105                	addi	sp,sp,32
    80003c06:	8082                	ret

0000000080003c08 <idup>:
{
    80003c08:	1101                	addi	sp,sp,-32
    80003c0a:	ec06                	sd	ra,24(sp)
    80003c0c:	e822                	sd	s0,16(sp)
    80003c0e:	e426                	sd	s1,8(sp)
    80003c10:	1000                	addi	s0,sp,32
    80003c12:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c14:	0023c517          	auipc	a0,0x23c
    80003c18:	92c50513          	addi	a0,a0,-1748 # 8023f540 <itable>
    80003c1c:	ffffd097          	auipc	ra,0xffffd
    80003c20:	1ca080e7          	jalr	458(ra) # 80000de6 <acquire>
  ip->ref++;
    80003c24:	449c                	lw	a5,8(s1)
    80003c26:	2785                	addiw	a5,a5,1
    80003c28:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c2a:	0023c517          	auipc	a0,0x23c
    80003c2e:	91650513          	addi	a0,a0,-1770 # 8023f540 <itable>
    80003c32:	ffffd097          	auipc	ra,0xffffd
    80003c36:	268080e7          	jalr	616(ra) # 80000e9a <release>
}
    80003c3a:	8526                	mv	a0,s1
    80003c3c:	60e2                	ld	ra,24(sp)
    80003c3e:	6442                	ld	s0,16(sp)
    80003c40:	64a2                	ld	s1,8(sp)
    80003c42:	6105                	addi	sp,sp,32
    80003c44:	8082                	ret

0000000080003c46 <ilock>:
{
    80003c46:	1101                	addi	sp,sp,-32
    80003c48:	ec06                	sd	ra,24(sp)
    80003c4a:	e822                	sd	s0,16(sp)
    80003c4c:	e426                	sd	s1,8(sp)
    80003c4e:	e04a                	sd	s2,0(sp)
    80003c50:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c52:	c115                	beqz	a0,80003c76 <ilock+0x30>
    80003c54:	84aa                	mv	s1,a0
    80003c56:	451c                	lw	a5,8(a0)
    80003c58:	00f05f63          	blez	a5,80003c76 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003c5c:	0541                	addi	a0,a0,16
    80003c5e:	00001097          	auipc	ra,0x1
    80003c62:	ca2080e7          	jalr	-862(ra) # 80004900 <acquiresleep>
  if(ip->valid == 0){
    80003c66:	40bc                	lw	a5,64(s1)
    80003c68:	cf99                	beqz	a5,80003c86 <ilock+0x40>
}
    80003c6a:	60e2                	ld	ra,24(sp)
    80003c6c:	6442                	ld	s0,16(sp)
    80003c6e:	64a2                	ld	s1,8(sp)
    80003c70:	6902                	ld	s2,0(sp)
    80003c72:	6105                	addi	sp,sp,32
    80003c74:	8082                	ret
    panic("ilock");
    80003c76:	00005517          	auipc	a0,0x5
    80003c7a:	90a50513          	addi	a0,a0,-1782 # 80008580 <etext+0x580>
    80003c7e:	ffffd097          	auipc	ra,0xffffd
    80003c82:	8c0080e7          	jalr	-1856(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c86:	40dc                	lw	a5,4(s1)
    80003c88:	0047d79b          	srliw	a5,a5,0x4
    80003c8c:	0023c597          	auipc	a1,0x23c
    80003c90:	8ac5a583          	lw	a1,-1876(a1) # 8023f538 <sb+0x18>
    80003c94:	9dbd                	addw	a1,a1,a5
    80003c96:	4088                	lw	a0,0(s1)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	794080e7          	jalr	1940(ra) # 8000342c <bread>
    80003ca0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ca2:	05850593          	addi	a1,a0,88
    80003ca6:	40dc                	lw	a5,4(s1)
    80003ca8:	8bbd                	andi	a5,a5,15
    80003caa:	079a                	slli	a5,a5,0x6
    80003cac:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003cae:	00059783          	lh	a5,0(a1)
    80003cb2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003cb6:	00259783          	lh	a5,2(a1)
    80003cba:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003cbe:	00459783          	lh	a5,4(a1)
    80003cc2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003cc6:	00659783          	lh	a5,6(a1)
    80003cca:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003cce:	459c                	lw	a5,8(a1)
    80003cd0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003cd2:	03400613          	li	a2,52
    80003cd6:	05b1                	addi	a1,a1,12
    80003cd8:	05048513          	addi	a0,s1,80
    80003cdc:	ffffd097          	auipc	ra,0xffffd
    80003ce0:	262080e7          	jalr	610(ra) # 80000f3e <memmove>
    brelse(bp);
    80003ce4:	854a                	mv	a0,s2
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	876080e7          	jalr	-1930(ra) # 8000355c <brelse>
    ip->valid = 1;
    80003cee:	4785                	li	a5,1
    80003cf0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003cf2:	04449783          	lh	a5,68(s1)
    80003cf6:	fbb5                	bnez	a5,80003c6a <ilock+0x24>
      panic("ilock: no type");
    80003cf8:	00005517          	auipc	a0,0x5
    80003cfc:	89050513          	addi	a0,a0,-1904 # 80008588 <etext+0x588>
    80003d00:	ffffd097          	auipc	ra,0xffffd
    80003d04:	83e080e7          	jalr	-1986(ra) # 8000053e <panic>

0000000080003d08 <iunlock>:
{
    80003d08:	1101                	addi	sp,sp,-32
    80003d0a:	ec06                	sd	ra,24(sp)
    80003d0c:	e822                	sd	s0,16(sp)
    80003d0e:	e426                	sd	s1,8(sp)
    80003d10:	e04a                	sd	s2,0(sp)
    80003d12:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d14:	c905                	beqz	a0,80003d44 <iunlock+0x3c>
    80003d16:	84aa                	mv	s1,a0
    80003d18:	01050913          	addi	s2,a0,16
    80003d1c:	854a                	mv	a0,s2
    80003d1e:	00001097          	auipc	ra,0x1
    80003d22:	c7c080e7          	jalr	-900(ra) # 8000499a <holdingsleep>
    80003d26:	cd19                	beqz	a0,80003d44 <iunlock+0x3c>
    80003d28:	449c                	lw	a5,8(s1)
    80003d2a:	00f05d63          	blez	a5,80003d44 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d2e:	854a                	mv	a0,s2
    80003d30:	00001097          	auipc	ra,0x1
    80003d34:	c26080e7          	jalr	-986(ra) # 80004956 <releasesleep>
}
    80003d38:	60e2                	ld	ra,24(sp)
    80003d3a:	6442                	ld	s0,16(sp)
    80003d3c:	64a2                	ld	s1,8(sp)
    80003d3e:	6902                	ld	s2,0(sp)
    80003d40:	6105                	addi	sp,sp,32
    80003d42:	8082                	ret
    panic("iunlock");
    80003d44:	00005517          	auipc	a0,0x5
    80003d48:	85450513          	addi	a0,a0,-1964 # 80008598 <etext+0x598>
    80003d4c:	ffffc097          	auipc	ra,0xffffc
    80003d50:	7f2080e7          	jalr	2034(ra) # 8000053e <panic>

0000000080003d54 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d54:	7179                	addi	sp,sp,-48
    80003d56:	f406                	sd	ra,40(sp)
    80003d58:	f022                	sd	s0,32(sp)
    80003d5a:	ec26                	sd	s1,24(sp)
    80003d5c:	e84a                	sd	s2,16(sp)
    80003d5e:	e44e                	sd	s3,8(sp)
    80003d60:	e052                	sd	s4,0(sp)
    80003d62:	1800                	addi	s0,sp,48
    80003d64:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d66:	05050493          	addi	s1,a0,80
    80003d6a:	08050913          	addi	s2,a0,128
    80003d6e:	a021                	j	80003d76 <itrunc+0x22>
    80003d70:	0491                	addi	s1,s1,4
    80003d72:	01248d63          	beq	s1,s2,80003d8c <itrunc+0x38>
    if(ip->addrs[i]){
    80003d76:	408c                	lw	a1,0(s1)
    80003d78:	dde5                	beqz	a1,80003d70 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003d7a:	0009a503          	lw	a0,0(s3)
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	8f4080e7          	jalr	-1804(ra) # 80003672 <bfree>
      ip->addrs[i] = 0;
    80003d86:	0004a023          	sw	zero,0(s1)
    80003d8a:	b7dd                	j	80003d70 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d8c:	0809a583          	lw	a1,128(s3)
    80003d90:	e185                	bnez	a1,80003db0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d92:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d96:	854e                	mv	a0,s3
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	de4080e7          	jalr	-540(ra) # 80003b7c <iupdate>
}
    80003da0:	70a2                	ld	ra,40(sp)
    80003da2:	7402                	ld	s0,32(sp)
    80003da4:	64e2                	ld	s1,24(sp)
    80003da6:	6942                	ld	s2,16(sp)
    80003da8:	69a2                	ld	s3,8(sp)
    80003daa:	6a02                	ld	s4,0(sp)
    80003dac:	6145                	addi	sp,sp,48
    80003dae:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003db0:	0009a503          	lw	a0,0(s3)
    80003db4:	fffff097          	auipc	ra,0xfffff
    80003db8:	678080e7          	jalr	1656(ra) # 8000342c <bread>
    80003dbc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003dbe:	05850493          	addi	s1,a0,88
    80003dc2:	45850913          	addi	s2,a0,1112
    80003dc6:	a021                	j	80003dce <itrunc+0x7a>
    80003dc8:	0491                	addi	s1,s1,4
    80003dca:	01248b63          	beq	s1,s2,80003de0 <itrunc+0x8c>
      if(a[j])
    80003dce:	408c                	lw	a1,0(s1)
    80003dd0:	dde5                	beqz	a1,80003dc8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003dd2:	0009a503          	lw	a0,0(s3)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	89c080e7          	jalr	-1892(ra) # 80003672 <bfree>
    80003dde:	b7ed                	j	80003dc8 <itrunc+0x74>
    brelse(bp);
    80003de0:	8552                	mv	a0,s4
    80003de2:	fffff097          	auipc	ra,0xfffff
    80003de6:	77a080e7          	jalr	1914(ra) # 8000355c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003dea:	0809a583          	lw	a1,128(s3)
    80003dee:	0009a503          	lw	a0,0(s3)
    80003df2:	00000097          	auipc	ra,0x0
    80003df6:	880080e7          	jalr	-1920(ra) # 80003672 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003dfa:	0809a023          	sw	zero,128(s3)
    80003dfe:	bf51                	j	80003d92 <itrunc+0x3e>

0000000080003e00 <iput>:
{
    80003e00:	1101                	addi	sp,sp,-32
    80003e02:	ec06                	sd	ra,24(sp)
    80003e04:	e822                	sd	s0,16(sp)
    80003e06:	e426                	sd	s1,8(sp)
    80003e08:	e04a                	sd	s2,0(sp)
    80003e0a:	1000                	addi	s0,sp,32
    80003e0c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e0e:	0023b517          	auipc	a0,0x23b
    80003e12:	73250513          	addi	a0,a0,1842 # 8023f540 <itable>
    80003e16:	ffffd097          	auipc	ra,0xffffd
    80003e1a:	fd0080e7          	jalr	-48(ra) # 80000de6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e1e:	4498                	lw	a4,8(s1)
    80003e20:	4785                	li	a5,1
    80003e22:	02f70363          	beq	a4,a5,80003e48 <iput+0x48>
  ip->ref--;
    80003e26:	449c                	lw	a5,8(s1)
    80003e28:	37fd                	addiw	a5,a5,-1
    80003e2a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e2c:	0023b517          	auipc	a0,0x23b
    80003e30:	71450513          	addi	a0,a0,1812 # 8023f540 <itable>
    80003e34:	ffffd097          	auipc	ra,0xffffd
    80003e38:	066080e7          	jalr	102(ra) # 80000e9a <release>
}
    80003e3c:	60e2                	ld	ra,24(sp)
    80003e3e:	6442                	ld	s0,16(sp)
    80003e40:	64a2                	ld	s1,8(sp)
    80003e42:	6902                	ld	s2,0(sp)
    80003e44:	6105                	addi	sp,sp,32
    80003e46:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e48:	40bc                	lw	a5,64(s1)
    80003e4a:	dff1                	beqz	a5,80003e26 <iput+0x26>
    80003e4c:	04a49783          	lh	a5,74(s1)
    80003e50:	fbf9                	bnez	a5,80003e26 <iput+0x26>
    acquiresleep(&ip->lock);
    80003e52:	01048913          	addi	s2,s1,16
    80003e56:	854a                	mv	a0,s2
    80003e58:	00001097          	auipc	ra,0x1
    80003e5c:	aa8080e7          	jalr	-1368(ra) # 80004900 <acquiresleep>
    release(&itable.lock);
    80003e60:	0023b517          	auipc	a0,0x23b
    80003e64:	6e050513          	addi	a0,a0,1760 # 8023f540 <itable>
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	032080e7          	jalr	50(ra) # 80000e9a <release>
    itrunc(ip);
    80003e70:	8526                	mv	a0,s1
    80003e72:	00000097          	auipc	ra,0x0
    80003e76:	ee2080e7          	jalr	-286(ra) # 80003d54 <itrunc>
    ip->type = 0;
    80003e7a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	cfc080e7          	jalr	-772(ra) # 80003b7c <iupdate>
    ip->valid = 0;
    80003e88:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e8c:	854a                	mv	a0,s2
    80003e8e:	00001097          	auipc	ra,0x1
    80003e92:	ac8080e7          	jalr	-1336(ra) # 80004956 <releasesleep>
    acquire(&itable.lock);
    80003e96:	0023b517          	auipc	a0,0x23b
    80003e9a:	6aa50513          	addi	a0,a0,1706 # 8023f540 <itable>
    80003e9e:	ffffd097          	auipc	ra,0xffffd
    80003ea2:	f48080e7          	jalr	-184(ra) # 80000de6 <acquire>
    80003ea6:	b741                	j	80003e26 <iput+0x26>

0000000080003ea8 <iunlockput>:
{
    80003ea8:	1101                	addi	sp,sp,-32
    80003eaa:	ec06                	sd	ra,24(sp)
    80003eac:	e822                	sd	s0,16(sp)
    80003eae:	e426                	sd	s1,8(sp)
    80003eb0:	1000                	addi	s0,sp,32
    80003eb2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	e54080e7          	jalr	-428(ra) # 80003d08 <iunlock>
  iput(ip);
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	f42080e7          	jalr	-190(ra) # 80003e00 <iput>
}
    80003ec6:	60e2                	ld	ra,24(sp)
    80003ec8:	6442                	ld	s0,16(sp)
    80003eca:	64a2                	ld	s1,8(sp)
    80003ecc:	6105                	addi	sp,sp,32
    80003ece:	8082                	ret

0000000080003ed0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003ed0:	1141                	addi	sp,sp,-16
    80003ed2:	e422                	sd	s0,8(sp)
    80003ed4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ed6:	411c                	lw	a5,0(a0)
    80003ed8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003eda:	415c                	lw	a5,4(a0)
    80003edc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003ede:	04451783          	lh	a5,68(a0)
    80003ee2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003ee6:	04a51783          	lh	a5,74(a0)
    80003eea:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003eee:	04c56783          	lwu	a5,76(a0)
    80003ef2:	e99c                	sd	a5,16(a1)
}
    80003ef4:	6422                	ld	s0,8(sp)
    80003ef6:	0141                	addi	sp,sp,16
    80003ef8:	8082                	ret

0000000080003efa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003efa:	457c                	lw	a5,76(a0)
    80003efc:	0ed7e963          	bltu	a5,a3,80003fee <readi+0xf4>
{
    80003f00:	7159                	addi	sp,sp,-112
    80003f02:	f486                	sd	ra,104(sp)
    80003f04:	f0a2                	sd	s0,96(sp)
    80003f06:	eca6                	sd	s1,88(sp)
    80003f08:	e8ca                	sd	s2,80(sp)
    80003f0a:	e4ce                	sd	s3,72(sp)
    80003f0c:	e0d2                	sd	s4,64(sp)
    80003f0e:	fc56                	sd	s5,56(sp)
    80003f10:	f85a                	sd	s6,48(sp)
    80003f12:	f45e                	sd	s7,40(sp)
    80003f14:	f062                	sd	s8,32(sp)
    80003f16:	ec66                	sd	s9,24(sp)
    80003f18:	e86a                	sd	s10,16(sp)
    80003f1a:	e46e                	sd	s11,8(sp)
    80003f1c:	1880                	addi	s0,sp,112
    80003f1e:	8b2a                	mv	s6,a0
    80003f20:	8bae                	mv	s7,a1
    80003f22:	8a32                	mv	s4,a2
    80003f24:	84b6                	mv	s1,a3
    80003f26:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f28:	9f35                	addw	a4,a4,a3
    return 0;
    80003f2a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f2c:	0ad76063          	bltu	a4,a3,80003fcc <readi+0xd2>
  if(off + n > ip->size)
    80003f30:	00e7f463          	bgeu	a5,a4,80003f38 <readi+0x3e>
    n = ip->size - off;
    80003f34:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f38:	0a0a8963          	beqz	s5,80003fea <readi+0xf0>
    80003f3c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f3e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f42:	5c7d                	li	s8,-1
    80003f44:	a82d                	j	80003f7e <readi+0x84>
    80003f46:	020d1d93          	slli	s11,s10,0x20
    80003f4a:	020ddd93          	srli	s11,s11,0x20
    80003f4e:	05890793          	addi	a5,s2,88
    80003f52:	86ee                	mv	a3,s11
    80003f54:	963e                	add	a2,a2,a5
    80003f56:	85d2                	mv	a1,s4
    80003f58:	855e                	mv	a0,s7
    80003f5a:	fffff097          	auipc	ra,0xfffff
    80003f5e:	88c080e7          	jalr	-1908(ra) # 800027e6 <either_copyout>
    80003f62:	05850d63          	beq	a0,s8,80003fbc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f66:	854a                	mv	a0,s2
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	5f4080e7          	jalr	1524(ra) # 8000355c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f70:	013d09bb          	addw	s3,s10,s3
    80003f74:	009d04bb          	addw	s1,s10,s1
    80003f78:	9a6e                	add	s4,s4,s11
    80003f7a:	0559f763          	bgeu	s3,s5,80003fc8 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003f7e:	00a4d59b          	srliw	a1,s1,0xa
    80003f82:	855a                	mv	a0,s6
    80003f84:	00000097          	auipc	ra,0x0
    80003f88:	8a2080e7          	jalr	-1886(ra) # 80003826 <bmap>
    80003f8c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f90:	cd85                	beqz	a1,80003fc8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003f92:	000b2503          	lw	a0,0(s6)
    80003f96:	fffff097          	auipc	ra,0xfffff
    80003f9a:	496080e7          	jalr	1174(ra) # 8000342c <bread>
    80003f9e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fa0:	3ff4f613          	andi	a2,s1,1023
    80003fa4:	40cc87bb          	subw	a5,s9,a2
    80003fa8:	413a873b          	subw	a4,s5,s3
    80003fac:	8d3e                	mv	s10,a5
    80003fae:	2781                	sext.w	a5,a5
    80003fb0:	0007069b          	sext.w	a3,a4
    80003fb4:	f8f6f9e3          	bgeu	a3,a5,80003f46 <readi+0x4c>
    80003fb8:	8d3a                	mv	s10,a4
    80003fba:	b771                	j	80003f46 <readi+0x4c>
      brelse(bp);
    80003fbc:	854a                	mv	a0,s2
    80003fbe:	fffff097          	auipc	ra,0xfffff
    80003fc2:	59e080e7          	jalr	1438(ra) # 8000355c <brelse>
      tot = -1;
    80003fc6:	59fd                	li	s3,-1
  }
  return tot;
    80003fc8:	0009851b          	sext.w	a0,s3
}
    80003fcc:	70a6                	ld	ra,104(sp)
    80003fce:	7406                	ld	s0,96(sp)
    80003fd0:	64e6                	ld	s1,88(sp)
    80003fd2:	6946                	ld	s2,80(sp)
    80003fd4:	69a6                	ld	s3,72(sp)
    80003fd6:	6a06                	ld	s4,64(sp)
    80003fd8:	7ae2                	ld	s5,56(sp)
    80003fda:	7b42                	ld	s6,48(sp)
    80003fdc:	7ba2                	ld	s7,40(sp)
    80003fde:	7c02                	ld	s8,32(sp)
    80003fe0:	6ce2                	ld	s9,24(sp)
    80003fe2:	6d42                	ld	s10,16(sp)
    80003fe4:	6da2                	ld	s11,8(sp)
    80003fe6:	6165                	addi	sp,sp,112
    80003fe8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fea:	89d6                	mv	s3,s5
    80003fec:	bff1                	j	80003fc8 <readi+0xce>
    return 0;
    80003fee:	4501                	li	a0,0
}
    80003ff0:	8082                	ret

0000000080003ff2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ff2:	457c                	lw	a5,76(a0)
    80003ff4:	10d7e863          	bltu	a5,a3,80004104 <writei+0x112>
{
    80003ff8:	7159                	addi	sp,sp,-112
    80003ffa:	f486                	sd	ra,104(sp)
    80003ffc:	f0a2                	sd	s0,96(sp)
    80003ffe:	eca6                	sd	s1,88(sp)
    80004000:	e8ca                	sd	s2,80(sp)
    80004002:	e4ce                	sd	s3,72(sp)
    80004004:	e0d2                	sd	s4,64(sp)
    80004006:	fc56                	sd	s5,56(sp)
    80004008:	f85a                	sd	s6,48(sp)
    8000400a:	f45e                	sd	s7,40(sp)
    8000400c:	f062                	sd	s8,32(sp)
    8000400e:	ec66                	sd	s9,24(sp)
    80004010:	e86a                	sd	s10,16(sp)
    80004012:	e46e                	sd	s11,8(sp)
    80004014:	1880                	addi	s0,sp,112
    80004016:	8aaa                	mv	s5,a0
    80004018:	8bae                	mv	s7,a1
    8000401a:	8a32                	mv	s4,a2
    8000401c:	8936                	mv	s2,a3
    8000401e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004020:	00e687bb          	addw	a5,a3,a4
    80004024:	0ed7e263          	bltu	a5,a3,80004108 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004028:	00043737          	lui	a4,0x43
    8000402c:	0ef76063          	bltu	a4,a5,8000410c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004030:	0c0b0863          	beqz	s6,80004100 <writei+0x10e>
    80004034:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004036:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000403a:	5c7d                	li	s8,-1
    8000403c:	a091                	j	80004080 <writei+0x8e>
    8000403e:	020d1d93          	slli	s11,s10,0x20
    80004042:	020ddd93          	srli	s11,s11,0x20
    80004046:	05848793          	addi	a5,s1,88
    8000404a:	86ee                	mv	a3,s11
    8000404c:	8652                	mv	a2,s4
    8000404e:	85de                	mv	a1,s7
    80004050:	953e                	add	a0,a0,a5
    80004052:	ffffe097          	auipc	ra,0xffffe
    80004056:	7ea080e7          	jalr	2026(ra) # 8000283c <either_copyin>
    8000405a:	07850263          	beq	a0,s8,800040be <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000405e:	8526                	mv	a0,s1
    80004060:	00000097          	auipc	ra,0x0
    80004064:	780080e7          	jalr	1920(ra) # 800047e0 <log_write>
    brelse(bp);
    80004068:	8526                	mv	a0,s1
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	4f2080e7          	jalr	1266(ra) # 8000355c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004072:	013d09bb          	addw	s3,s10,s3
    80004076:	012d093b          	addw	s2,s10,s2
    8000407a:	9a6e                	add	s4,s4,s11
    8000407c:	0569f663          	bgeu	s3,s6,800040c8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004080:	00a9559b          	srliw	a1,s2,0xa
    80004084:	8556                	mv	a0,s5
    80004086:	fffff097          	auipc	ra,0xfffff
    8000408a:	7a0080e7          	jalr	1952(ra) # 80003826 <bmap>
    8000408e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004092:	c99d                	beqz	a1,800040c8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004094:	000aa503          	lw	a0,0(s5)
    80004098:	fffff097          	auipc	ra,0xfffff
    8000409c:	394080e7          	jalr	916(ra) # 8000342c <bread>
    800040a0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040a2:	3ff97513          	andi	a0,s2,1023
    800040a6:	40ac87bb          	subw	a5,s9,a0
    800040aa:	413b073b          	subw	a4,s6,s3
    800040ae:	8d3e                	mv	s10,a5
    800040b0:	2781                	sext.w	a5,a5
    800040b2:	0007069b          	sext.w	a3,a4
    800040b6:	f8f6f4e3          	bgeu	a3,a5,8000403e <writei+0x4c>
    800040ba:	8d3a                	mv	s10,a4
    800040bc:	b749                	j	8000403e <writei+0x4c>
      brelse(bp);
    800040be:	8526                	mv	a0,s1
    800040c0:	fffff097          	auipc	ra,0xfffff
    800040c4:	49c080e7          	jalr	1180(ra) # 8000355c <brelse>
  }

  if(off > ip->size)
    800040c8:	04caa783          	lw	a5,76(s5)
    800040cc:	0127f463          	bgeu	a5,s2,800040d4 <writei+0xe2>
    ip->size = off;
    800040d0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800040d4:	8556                	mv	a0,s5
    800040d6:	00000097          	auipc	ra,0x0
    800040da:	aa6080e7          	jalr	-1370(ra) # 80003b7c <iupdate>

  return tot;
    800040de:	0009851b          	sext.w	a0,s3
}
    800040e2:	70a6                	ld	ra,104(sp)
    800040e4:	7406                	ld	s0,96(sp)
    800040e6:	64e6                	ld	s1,88(sp)
    800040e8:	6946                	ld	s2,80(sp)
    800040ea:	69a6                	ld	s3,72(sp)
    800040ec:	6a06                	ld	s4,64(sp)
    800040ee:	7ae2                	ld	s5,56(sp)
    800040f0:	7b42                	ld	s6,48(sp)
    800040f2:	7ba2                	ld	s7,40(sp)
    800040f4:	7c02                	ld	s8,32(sp)
    800040f6:	6ce2                	ld	s9,24(sp)
    800040f8:	6d42                	ld	s10,16(sp)
    800040fa:	6da2                	ld	s11,8(sp)
    800040fc:	6165                	addi	sp,sp,112
    800040fe:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004100:	89da                	mv	s3,s6
    80004102:	bfc9                	j	800040d4 <writei+0xe2>
    return -1;
    80004104:	557d                	li	a0,-1
}
    80004106:	8082                	ret
    return -1;
    80004108:	557d                	li	a0,-1
    8000410a:	bfe1                	j	800040e2 <writei+0xf0>
    return -1;
    8000410c:	557d                	li	a0,-1
    8000410e:	bfd1                	j	800040e2 <writei+0xf0>

0000000080004110 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004110:	1141                	addi	sp,sp,-16
    80004112:	e406                	sd	ra,8(sp)
    80004114:	e022                	sd	s0,0(sp)
    80004116:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004118:	4639                	li	a2,14
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	e98080e7          	jalr	-360(ra) # 80000fb2 <strncmp>
}
    80004122:	60a2                	ld	ra,8(sp)
    80004124:	6402                	ld	s0,0(sp)
    80004126:	0141                	addi	sp,sp,16
    80004128:	8082                	ret

000000008000412a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000412a:	7139                	addi	sp,sp,-64
    8000412c:	fc06                	sd	ra,56(sp)
    8000412e:	f822                	sd	s0,48(sp)
    80004130:	f426                	sd	s1,40(sp)
    80004132:	f04a                	sd	s2,32(sp)
    80004134:	ec4e                	sd	s3,24(sp)
    80004136:	e852                	sd	s4,16(sp)
    80004138:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000413a:	04451703          	lh	a4,68(a0)
    8000413e:	4785                	li	a5,1
    80004140:	00f71a63          	bne	a4,a5,80004154 <dirlookup+0x2a>
    80004144:	892a                	mv	s2,a0
    80004146:	89ae                	mv	s3,a1
    80004148:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000414a:	457c                	lw	a5,76(a0)
    8000414c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000414e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004150:	e79d                	bnez	a5,8000417e <dirlookup+0x54>
    80004152:	a8a5                	j	800041ca <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004154:	00004517          	auipc	a0,0x4
    80004158:	44c50513          	addi	a0,a0,1100 # 800085a0 <etext+0x5a0>
    8000415c:	ffffc097          	auipc	ra,0xffffc
    80004160:	3e2080e7          	jalr	994(ra) # 8000053e <panic>
      panic("dirlookup read");
    80004164:	00004517          	auipc	a0,0x4
    80004168:	45450513          	addi	a0,a0,1108 # 800085b8 <etext+0x5b8>
    8000416c:	ffffc097          	auipc	ra,0xffffc
    80004170:	3d2080e7          	jalr	978(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004174:	24c1                	addiw	s1,s1,16
    80004176:	04c92783          	lw	a5,76(s2)
    8000417a:	04f4f763          	bgeu	s1,a5,800041c8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000417e:	4741                	li	a4,16
    80004180:	86a6                	mv	a3,s1
    80004182:	fc040613          	addi	a2,s0,-64
    80004186:	4581                	li	a1,0
    80004188:	854a                	mv	a0,s2
    8000418a:	00000097          	auipc	ra,0x0
    8000418e:	d70080e7          	jalr	-656(ra) # 80003efa <readi>
    80004192:	47c1                	li	a5,16
    80004194:	fcf518e3          	bne	a0,a5,80004164 <dirlookup+0x3a>
    if(de.inum == 0)
    80004198:	fc045783          	lhu	a5,-64(s0)
    8000419c:	dfe1                	beqz	a5,80004174 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000419e:	fc240593          	addi	a1,s0,-62
    800041a2:	854e                	mv	a0,s3
    800041a4:	00000097          	auipc	ra,0x0
    800041a8:	f6c080e7          	jalr	-148(ra) # 80004110 <namecmp>
    800041ac:	f561                	bnez	a0,80004174 <dirlookup+0x4a>
      if(poff)
    800041ae:	000a0463          	beqz	s4,800041b6 <dirlookup+0x8c>
        *poff = off;
    800041b2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041b6:	fc045583          	lhu	a1,-64(s0)
    800041ba:	00092503          	lw	a0,0(s2)
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	750080e7          	jalr	1872(ra) # 8000390e <iget>
    800041c6:	a011                	j	800041ca <dirlookup+0xa0>
  return 0;
    800041c8:	4501                	li	a0,0
}
    800041ca:	70e2                	ld	ra,56(sp)
    800041cc:	7442                	ld	s0,48(sp)
    800041ce:	74a2                	ld	s1,40(sp)
    800041d0:	7902                	ld	s2,32(sp)
    800041d2:	69e2                	ld	s3,24(sp)
    800041d4:	6a42                	ld	s4,16(sp)
    800041d6:	6121                	addi	sp,sp,64
    800041d8:	8082                	ret

00000000800041da <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800041da:	711d                	addi	sp,sp,-96
    800041dc:	ec86                	sd	ra,88(sp)
    800041de:	e8a2                	sd	s0,80(sp)
    800041e0:	e4a6                	sd	s1,72(sp)
    800041e2:	e0ca                	sd	s2,64(sp)
    800041e4:	fc4e                	sd	s3,56(sp)
    800041e6:	f852                	sd	s4,48(sp)
    800041e8:	f456                	sd	s5,40(sp)
    800041ea:	f05a                	sd	s6,32(sp)
    800041ec:	ec5e                	sd	s7,24(sp)
    800041ee:	e862                	sd	s8,16(sp)
    800041f0:	e466                	sd	s9,8(sp)
    800041f2:	1080                	addi	s0,sp,96
    800041f4:	84aa                	mv	s1,a0
    800041f6:	8aae                	mv	s5,a1
    800041f8:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800041fa:	00054703          	lbu	a4,0(a0)
    800041fe:	02f00793          	li	a5,47
    80004202:	02f70363          	beq	a4,a5,80004228 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004206:	ffffe097          	auipc	ra,0xffffe
    8000420a:	af0080e7          	jalr	-1296(ra) # 80001cf6 <myproc>
    8000420e:	15053503          	ld	a0,336(a0)
    80004212:	00000097          	auipc	ra,0x0
    80004216:	9f6080e7          	jalr	-1546(ra) # 80003c08 <idup>
    8000421a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000421c:	02f00913          	li	s2,47
  len = path - s;
    80004220:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004222:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004224:	4b85                	li	s7,1
    80004226:	a865                	j	800042de <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004228:	4585                	li	a1,1
    8000422a:	4505                	li	a0,1
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	6e2080e7          	jalr	1762(ra) # 8000390e <iget>
    80004234:	89aa                	mv	s3,a0
    80004236:	b7dd                	j	8000421c <namex+0x42>
      iunlockput(ip);
    80004238:	854e                	mv	a0,s3
    8000423a:	00000097          	auipc	ra,0x0
    8000423e:	c6e080e7          	jalr	-914(ra) # 80003ea8 <iunlockput>
      return 0;
    80004242:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004244:	854e                	mv	a0,s3
    80004246:	60e6                	ld	ra,88(sp)
    80004248:	6446                	ld	s0,80(sp)
    8000424a:	64a6                	ld	s1,72(sp)
    8000424c:	6906                	ld	s2,64(sp)
    8000424e:	79e2                	ld	s3,56(sp)
    80004250:	7a42                	ld	s4,48(sp)
    80004252:	7aa2                	ld	s5,40(sp)
    80004254:	7b02                	ld	s6,32(sp)
    80004256:	6be2                	ld	s7,24(sp)
    80004258:	6c42                	ld	s8,16(sp)
    8000425a:	6ca2                	ld	s9,8(sp)
    8000425c:	6125                	addi	sp,sp,96
    8000425e:	8082                	ret
      iunlock(ip);
    80004260:	854e                	mv	a0,s3
    80004262:	00000097          	auipc	ra,0x0
    80004266:	aa6080e7          	jalr	-1370(ra) # 80003d08 <iunlock>
      return ip;
    8000426a:	bfe9                	j	80004244 <namex+0x6a>
      iunlockput(ip);
    8000426c:	854e                	mv	a0,s3
    8000426e:	00000097          	auipc	ra,0x0
    80004272:	c3a080e7          	jalr	-966(ra) # 80003ea8 <iunlockput>
      return 0;
    80004276:	89e6                	mv	s3,s9
    80004278:	b7f1                	j	80004244 <namex+0x6a>
  len = path - s;
    8000427a:	40b48633          	sub	a2,s1,a1
    8000427e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004282:	099c5463          	bge	s8,s9,8000430a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80004286:	4639                	li	a2,14
    80004288:	8552                	mv	a0,s4
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	cb4080e7          	jalr	-844(ra) # 80000f3e <memmove>
  while(*path == '/')
    80004292:	0004c783          	lbu	a5,0(s1)
    80004296:	01279763          	bne	a5,s2,800042a4 <namex+0xca>
    path++;
    8000429a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000429c:	0004c783          	lbu	a5,0(s1)
    800042a0:	ff278de3          	beq	a5,s2,8000429a <namex+0xc0>
    ilock(ip);
    800042a4:	854e                	mv	a0,s3
    800042a6:	00000097          	auipc	ra,0x0
    800042aa:	9a0080e7          	jalr	-1632(ra) # 80003c46 <ilock>
    if(ip->type != T_DIR){
    800042ae:	04499783          	lh	a5,68(s3)
    800042b2:	f97793e3          	bne	a5,s7,80004238 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800042b6:	000a8563          	beqz	s5,800042c0 <namex+0xe6>
    800042ba:	0004c783          	lbu	a5,0(s1)
    800042be:	d3cd                	beqz	a5,80004260 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800042c0:	865a                	mv	a2,s6
    800042c2:	85d2                	mv	a1,s4
    800042c4:	854e                	mv	a0,s3
    800042c6:	00000097          	auipc	ra,0x0
    800042ca:	e64080e7          	jalr	-412(ra) # 8000412a <dirlookup>
    800042ce:	8caa                	mv	s9,a0
    800042d0:	dd51                	beqz	a0,8000426c <namex+0x92>
    iunlockput(ip);
    800042d2:	854e                	mv	a0,s3
    800042d4:	00000097          	auipc	ra,0x0
    800042d8:	bd4080e7          	jalr	-1068(ra) # 80003ea8 <iunlockput>
    ip = next;
    800042dc:	89e6                	mv	s3,s9
  while(*path == '/')
    800042de:	0004c783          	lbu	a5,0(s1)
    800042e2:	05279763          	bne	a5,s2,80004330 <namex+0x156>
    path++;
    800042e6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042e8:	0004c783          	lbu	a5,0(s1)
    800042ec:	ff278de3          	beq	a5,s2,800042e6 <namex+0x10c>
  if(*path == 0)
    800042f0:	c79d                	beqz	a5,8000431e <namex+0x144>
    path++;
    800042f2:	85a6                	mv	a1,s1
  len = path - s;
    800042f4:	8cda                	mv	s9,s6
    800042f6:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800042f8:	01278963          	beq	a5,s2,8000430a <namex+0x130>
    800042fc:	dfbd                	beqz	a5,8000427a <namex+0xa0>
    path++;
    800042fe:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004300:	0004c783          	lbu	a5,0(s1)
    80004304:	ff279ce3          	bne	a5,s2,800042fc <namex+0x122>
    80004308:	bf8d                	j	8000427a <namex+0xa0>
    memmove(name, s, len);
    8000430a:	2601                	sext.w	a2,a2
    8000430c:	8552                	mv	a0,s4
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	c30080e7          	jalr	-976(ra) # 80000f3e <memmove>
    name[len] = 0;
    80004316:	9cd2                	add	s9,s9,s4
    80004318:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000431c:	bf9d                	j	80004292 <namex+0xb8>
  if(nameiparent){
    8000431e:	f20a83e3          	beqz	s5,80004244 <namex+0x6a>
    iput(ip);
    80004322:	854e                	mv	a0,s3
    80004324:	00000097          	auipc	ra,0x0
    80004328:	adc080e7          	jalr	-1316(ra) # 80003e00 <iput>
    return 0;
    8000432c:	4981                	li	s3,0
    8000432e:	bf19                	j	80004244 <namex+0x6a>
  if(*path == 0)
    80004330:	d7fd                	beqz	a5,8000431e <namex+0x144>
  while(*path != '/' && *path != 0)
    80004332:	0004c783          	lbu	a5,0(s1)
    80004336:	85a6                	mv	a1,s1
    80004338:	b7d1                	j	800042fc <namex+0x122>

000000008000433a <dirlink>:
{
    8000433a:	7139                	addi	sp,sp,-64
    8000433c:	fc06                	sd	ra,56(sp)
    8000433e:	f822                	sd	s0,48(sp)
    80004340:	f426                	sd	s1,40(sp)
    80004342:	f04a                	sd	s2,32(sp)
    80004344:	ec4e                	sd	s3,24(sp)
    80004346:	e852                	sd	s4,16(sp)
    80004348:	0080                	addi	s0,sp,64
    8000434a:	892a                	mv	s2,a0
    8000434c:	8a2e                	mv	s4,a1
    8000434e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004350:	4601                	li	a2,0
    80004352:	00000097          	auipc	ra,0x0
    80004356:	dd8080e7          	jalr	-552(ra) # 8000412a <dirlookup>
    8000435a:	e93d                	bnez	a0,800043d0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000435c:	04c92483          	lw	s1,76(s2)
    80004360:	c49d                	beqz	s1,8000438e <dirlink+0x54>
    80004362:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004364:	4741                	li	a4,16
    80004366:	86a6                	mv	a3,s1
    80004368:	fc040613          	addi	a2,s0,-64
    8000436c:	4581                	li	a1,0
    8000436e:	854a                	mv	a0,s2
    80004370:	00000097          	auipc	ra,0x0
    80004374:	b8a080e7          	jalr	-1142(ra) # 80003efa <readi>
    80004378:	47c1                	li	a5,16
    8000437a:	06f51163          	bne	a0,a5,800043dc <dirlink+0xa2>
    if(de.inum == 0)
    8000437e:	fc045783          	lhu	a5,-64(s0)
    80004382:	c791                	beqz	a5,8000438e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004384:	24c1                	addiw	s1,s1,16
    80004386:	04c92783          	lw	a5,76(s2)
    8000438a:	fcf4ede3          	bltu	s1,a5,80004364 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000438e:	4639                	li	a2,14
    80004390:	85d2                	mv	a1,s4
    80004392:	fc240513          	addi	a0,s0,-62
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	c58080e7          	jalr	-936(ra) # 80000fee <strncpy>
  de.inum = inum;
    8000439e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043a2:	4741                	li	a4,16
    800043a4:	86a6                	mv	a3,s1
    800043a6:	fc040613          	addi	a2,s0,-64
    800043aa:	4581                	li	a1,0
    800043ac:	854a                	mv	a0,s2
    800043ae:	00000097          	auipc	ra,0x0
    800043b2:	c44080e7          	jalr	-956(ra) # 80003ff2 <writei>
    800043b6:	1541                	addi	a0,a0,-16
    800043b8:	00a03533          	snez	a0,a0
    800043bc:	40a00533          	neg	a0,a0
}
    800043c0:	70e2                	ld	ra,56(sp)
    800043c2:	7442                	ld	s0,48(sp)
    800043c4:	74a2                	ld	s1,40(sp)
    800043c6:	7902                	ld	s2,32(sp)
    800043c8:	69e2                	ld	s3,24(sp)
    800043ca:	6a42                	ld	s4,16(sp)
    800043cc:	6121                	addi	sp,sp,64
    800043ce:	8082                	ret
    iput(ip);
    800043d0:	00000097          	auipc	ra,0x0
    800043d4:	a30080e7          	jalr	-1488(ra) # 80003e00 <iput>
    return -1;
    800043d8:	557d                	li	a0,-1
    800043da:	b7dd                	j	800043c0 <dirlink+0x86>
      panic("dirlink read");
    800043dc:	00004517          	auipc	a0,0x4
    800043e0:	1ec50513          	addi	a0,a0,492 # 800085c8 <etext+0x5c8>
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	15a080e7          	jalr	346(ra) # 8000053e <panic>

00000000800043ec <namei>:

struct inode*
namei(char *path)
{
    800043ec:	1101                	addi	sp,sp,-32
    800043ee:	ec06                	sd	ra,24(sp)
    800043f0:	e822                	sd	s0,16(sp)
    800043f2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800043f4:	fe040613          	addi	a2,s0,-32
    800043f8:	4581                	li	a1,0
    800043fa:	00000097          	auipc	ra,0x0
    800043fe:	de0080e7          	jalr	-544(ra) # 800041da <namex>
}
    80004402:	60e2                	ld	ra,24(sp)
    80004404:	6442                	ld	s0,16(sp)
    80004406:	6105                	addi	sp,sp,32
    80004408:	8082                	ret

000000008000440a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000440a:	1141                	addi	sp,sp,-16
    8000440c:	e406                	sd	ra,8(sp)
    8000440e:	e022                	sd	s0,0(sp)
    80004410:	0800                	addi	s0,sp,16
    80004412:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004414:	4585                	li	a1,1
    80004416:	00000097          	auipc	ra,0x0
    8000441a:	dc4080e7          	jalr	-572(ra) # 800041da <namex>
}
    8000441e:	60a2                	ld	ra,8(sp)
    80004420:	6402                	ld	s0,0(sp)
    80004422:	0141                	addi	sp,sp,16
    80004424:	8082                	ret

0000000080004426 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004426:	1101                	addi	sp,sp,-32
    80004428:	ec06                	sd	ra,24(sp)
    8000442a:	e822                	sd	s0,16(sp)
    8000442c:	e426                	sd	s1,8(sp)
    8000442e:	e04a                	sd	s2,0(sp)
    80004430:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004432:	0023d917          	auipc	s2,0x23d
    80004436:	bb690913          	addi	s2,s2,-1098 # 80240fe8 <log>
    8000443a:	01892583          	lw	a1,24(s2)
    8000443e:	02892503          	lw	a0,40(s2)
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	fea080e7          	jalr	-22(ra) # 8000342c <bread>
    8000444a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000444c:	02c92683          	lw	a3,44(s2)
    80004450:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004452:	02d05763          	blez	a3,80004480 <write_head+0x5a>
    80004456:	0023d797          	auipc	a5,0x23d
    8000445a:	bc278793          	addi	a5,a5,-1086 # 80241018 <log+0x30>
    8000445e:	05c50713          	addi	a4,a0,92
    80004462:	36fd                	addiw	a3,a3,-1
    80004464:	1682                	slli	a3,a3,0x20
    80004466:	9281                	srli	a3,a3,0x20
    80004468:	068a                	slli	a3,a3,0x2
    8000446a:	0023d617          	auipc	a2,0x23d
    8000446e:	bb260613          	addi	a2,a2,-1102 # 8024101c <log+0x34>
    80004472:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004474:	4390                	lw	a2,0(a5)
    80004476:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004478:	0791                	addi	a5,a5,4
    8000447a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000447c:	fed79ce3          	bne	a5,a3,80004474 <write_head+0x4e>
  }
  bwrite(buf);
    80004480:	8526                	mv	a0,s1
    80004482:	fffff097          	auipc	ra,0xfffff
    80004486:	09c080e7          	jalr	156(ra) # 8000351e <bwrite>
  brelse(buf);
    8000448a:	8526                	mv	a0,s1
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	0d0080e7          	jalr	208(ra) # 8000355c <brelse>
}
    80004494:	60e2                	ld	ra,24(sp)
    80004496:	6442                	ld	s0,16(sp)
    80004498:	64a2                	ld	s1,8(sp)
    8000449a:	6902                	ld	s2,0(sp)
    8000449c:	6105                	addi	sp,sp,32
    8000449e:	8082                	ret

00000000800044a0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044a0:	0023d797          	auipc	a5,0x23d
    800044a4:	b747a783          	lw	a5,-1164(a5) # 80241014 <log+0x2c>
    800044a8:	0af05d63          	blez	a5,80004562 <install_trans+0xc2>
{
    800044ac:	7139                	addi	sp,sp,-64
    800044ae:	fc06                	sd	ra,56(sp)
    800044b0:	f822                	sd	s0,48(sp)
    800044b2:	f426                	sd	s1,40(sp)
    800044b4:	f04a                	sd	s2,32(sp)
    800044b6:	ec4e                	sd	s3,24(sp)
    800044b8:	e852                	sd	s4,16(sp)
    800044ba:	e456                	sd	s5,8(sp)
    800044bc:	e05a                	sd	s6,0(sp)
    800044be:	0080                	addi	s0,sp,64
    800044c0:	8b2a                	mv	s6,a0
    800044c2:	0023da97          	auipc	s5,0x23d
    800044c6:	b56a8a93          	addi	s5,s5,-1194 # 80241018 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ca:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044cc:	0023d997          	auipc	s3,0x23d
    800044d0:	b1c98993          	addi	s3,s3,-1252 # 80240fe8 <log>
    800044d4:	a00d                	j	800044f6 <install_trans+0x56>
    brelse(lbuf);
    800044d6:	854a                	mv	a0,s2
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	084080e7          	jalr	132(ra) # 8000355c <brelse>
    brelse(dbuf);
    800044e0:	8526                	mv	a0,s1
    800044e2:	fffff097          	auipc	ra,0xfffff
    800044e6:	07a080e7          	jalr	122(ra) # 8000355c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ea:	2a05                	addiw	s4,s4,1
    800044ec:	0a91                	addi	s5,s5,4
    800044ee:	02c9a783          	lw	a5,44(s3)
    800044f2:	04fa5e63          	bge	s4,a5,8000454e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044f6:	0189a583          	lw	a1,24(s3)
    800044fa:	014585bb          	addw	a1,a1,s4
    800044fe:	2585                	addiw	a1,a1,1
    80004500:	0289a503          	lw	a0,40(s3)
    80004504:	fffff097          	auipc	ra,0xfffff
    80004508:	f28080e7          	jalr	-216(ra) # 8000342c <bread>
    8000450c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000450e:	000aa583          	lw	a1,0(s5)
    80004512:	0289a503          	lw	a0,40(s3)
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	f16080e7          	jalr	-234(ra) # 8000342c <bread>
    8000451e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004520:	40000613          	li	a2,1024
    80004524:	05890593          	addi	a1,s2,88
    80004528:	05850513          	addi	a0,a0,88
    8000452c:	ffffd097          	auipc	ra,0xffffd
    80004530:	a12080e7          	jalr	-1518(ra) # 80000f3e <memmove>
    bwrite(dbuf);  // write dst to disk
    80004534:	8526                	mv	a0,s1
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	fe8080e7          	jalr	-24(ra) # 8000351e <bwrite>
    if(recovering == 0)
    8000453e:	f80b1ce3          	bnez	s6,800044d6 <install_trans+0x36>
      bunpin(dbuf);
    80004542:	8526                	mv	a0,s1
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	0f2080e7          	jalr	242(ra) # 80003636 <bunpin>
    8000454c:	b769                	j	800044d6 <install_trans+0x36>
}
    8000454e:	70e2                	ld	ra,56(sp)
    80004550:	7442                	ld	s0,48(sp)
    80004552:	74a2                	ld	s1,40(sp)
    80004554:	7902                	ld	s2,32(sp)
    80004556:	69e2                	ld	s3,24(sp)
    80004558:	6a42                	ld	s4,16(sp)
    8000455a:	6aa2                	ld	s5,8(sp)
    8000455c:	6b02                	ld	s6,0(sp)
    8000455e:	6121                	addi	sp,sp,64
    80004560:	8082                	ret
    80004562:	8082                	ret

0000000080004564 <initlog>:
{
    80004564:	7179                	addi	sp,sp,-48
    80004566:	f406                	sd	ra,40(sp)
    80004568:	f022                	sd	s0,32(sp)
    8000456a:	ec26                	sd	s1,24(sp)
    8000456c:	e84a                	sd	s2,16(sp)
    8000456e:	e44e                	sd	s3,8(sp)
    80004570:	1800                	addi	s0,sp,48
    80004572:	892a                	mv	s2,a0
    80004574:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004576:	0023d497          	auipc	s1,0x23d
    8000457a:	a7248493          	addi	s1,s1,-1422 # 80240fe8 <log>
    8000457e:	00004597          	auipc	a1,0x4
    80004582:	05a58593          	addi	a1,a1,90 # 800085d8 <etext+0x5d8>
    80004586:	8526                	mv	a0,s1
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	7ce080e7          	jalr	1998(ra) # 80000d56 <initlock>
  log.start = sb->logstart;
    80004590:	0149a583          	lw	a1,20(s3)
    80004594:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004596:	0109a783          	lw	a5,16(s3)
    8000459a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000459c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045a0:	854a                	mv	a0,s2
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	e8a080e7          	jalr	-374(ra) # 8000342c <bread>
  log.lh.n = lh->n;
    800045aa:	4d34                	lw	a3,88(a0)
    800045ac:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800045ae:	02d05563          	blez	a3,800045d8 <initlog+0x74>
    800045b2:	05c50793          	addi	a5,a0,92
    800045b6:	0023d717          	auipc	a4,0x23d
    800045ba:	a6270713          	addi	a4,a4,-1438 # 80241018 <log+0x30>
    800045be:	36fd                	addiw	a3,a3,-1
    800045c0:	1682                	slli	a3,a3,0x20
    800045c2:	9281                	srli	a3,a3,0x20
    800045c4:	068a                	slli	a3,a3,0x2
    800045c6:	06050613          	addi	a2,a0,96
    800045ca:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800045cc:	4390                	lw	a2,0(a5)
    800045ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045d0:	0791                	addi	a5,a5,4
    800045d2:	0711                	addi	a4,a4,4
    800045d4:	fed79ce3          	bne	a5,a3,800045cc <initlog+0x68>
  brelse(buf);
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	f84080e7          	jalr	-124(ra) # 8000355c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045e0:	4505                	li	a0,1
    800045e2:	00000097          	auipc	ra,0x0
    800045e6:	ebe080e7          	jalr	-322(ra) # 800044a0 <install_trans>
  log.lh.n = 0;
    800045ea:	0023d797          	auipc	a5,0x23d
    800045ee:	a207a523          	sw	zero,-1494(a5) # 80241014 <log+0x2c>
  write_head(); // clear the log
    800045f2:	00000097          	auipc	ra,0x0
    800045f6:	e34080e7          	jalr	-460(ra) # 80004426 <write_head>
}
    800045fa:	70a2                	ld	ra,40(sp)
    800045fc:	7402                	ld	s0,32(sp)
    800045fe:	64e2                	ld	s1,24(sp)
    80004600:	6942                	ld	s2,16(sp)
    80004602:	69a2                	ld	s3,8(sp)
    80004604:	6145                	addi	sp,sp,48
    80004606:	8082                	ret

0000000080004608 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004608:	1101                	addi	sp,sp,-32
    8000460a:	ec06                	sd	ra,24(sp)
    8000460c:	e822                	sd	s0,16(sp)
    8000460e:	e426                	sd	s1,8(sp)
    80004610:	e04a                	sd	s2,0(sp)
    80004612:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004614:	0023d517          	auipc	a0,0x23d
    80004618:	9d450513          	addi	a0,a0,-1580 # 80240fe8 <log>
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	7ca080e7          	jalr	1994(ra) # 80000de6 <acquire>
  while(1){
    if(log.committing){
    80004624:	0023d497          	auipc	s1,0x23d
    80004628:	9c448493          	addi	s1,s1,-1596 # 80240fe8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000462c:	4979                	li	s2,30
    8000462e:	a039                	j	8000463c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004630:	85a6                	mv	a1,s1
    80004632:	8526                	mv	a0,s1
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	d9e080e7          	jalr	-610(ra) # 800023d2 <sleep>
    if(log.committing){
    8000463c:	50dc                	lw	a5,36(s1)
    8000463e:	fbed                	bnez	a5,80004630 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004640:	509c                	lw	a5,32(s1)
    80004642:	0017871b          	addiw	a4,a5,1
    80004646:	0007069b          	sext.w	a3,a4
    8000464a:	0027179b          	slliw	a5,a4,0x2
    8000464e:	9fb9                	addw	a5,a5,a4
    80004650:	0017979b          	slliw	a5,a5,0x1
    80004654:	54d8                	lw	a4,44(s1)
    80004656:	9fb9                	addw	a5,a5,a4
    80004658:	00f95963          	bge	s2,a5,8000466a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000465c:	85a6                	mv	a1,s1
    8000465e:	8526                	mv	a0,s1
    80004660:	ffffe097          	auipc	ra,0xffffe
    80004664:	d72080e7          	jalr	-654(ra) # 800023d2 <sleep>
    80004668:	bfd1                	j	8000463c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000466a:	0023d517          	auipc	a0,0x23d
    8000466e:	97e50513          	addi	a0,a0,-1666 # 80240fe8 <log>
    80004672:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004674:	ffffd097          	auipc	ra,0xffffd
    80004678:	826080e7          	jalr	-2010(ra) # 80000e9a <release>
      break;
    }
  }
}
    8000467c:	60e2                	ld	ra,24(sp)
    8000467e:	6442                	ld	s0,16(sp)
    80004680:	64a2                	ld	s1,8(sp)
    80004682:	6902                	ld	s2,0(sp)
    80004684:	6105                	addi	sp,sp,32
    80004686:	8082                	ret

0000000080004688 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004688:	7139                	addi	sp,sp,-64
    8000468a:	fc06                	sd	ra,56(sp)
    8000468c:	f822                	sd	s0,48(sp)
    8000468e:	f426                	sd	s1,40(sp)
    80004690:	f04a                	sd	s2,32(sp)
    80004692:	ec4e                	sd	s3,24(sp)
    80004694:	e852                	sd	s4,16(sp)
    80004696:	e456                	sd	s5,8(sp)
    80004698:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000469a:	0023d497          	auipc	s1,0x23d
    8000469e:	94e48493          	addi	s1,s1,-1714 # 80240fe8 <log>
    800046a2:	8526                	mv	a0,s1
    800046a4:	ffffc097          	auipc	ra,0xffffc
    800046a8:	742080e7          	jalr	1858(ra) # 80000de6 <acquire>
  log.outstanding -= 1;
    800046ac:	509c                	lw	a5,32(s1)
    800046ae:	37fd                	addiw	a5,a5,-1
    800046b0:	0007891b          	sext.w	s2,a5
    800046b4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800046b6:	50dc                	lw	a5,36(s1)
    800046b8:	e7b9                	bnez	a5,80004706 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800046ba:	04091e63          	bnez	s2,80004716 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800046be:	0023d497          	auipc	s1,0x23d
    800046c2:	92a48493          	addi	s1,s1,-1750 # 80240fe8 <log>
    800046c6:	4785                	li	a5,1
    800046c8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800046ca:	8526                	mv	a0,s1
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	7ce080e7          	jalr	1998(ra) # 80000e9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800046d4:	54dc                	lw	a5,44(s1)
    800046d6:	06f04763          	bgtz	a5,80004744 <end_op+0xbc>
    acquire(&log.lock);
    800046da:	0023d497          	auipc	s1,0x23d
    800046de:	90e48493          	addi	s1,s1,-1778 # 80240fe8 <log>
    800046e2:	8526                	mv	a0,s1
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	702080e7          	jalr	1794(ra) # 80000de6 <acquire>
    log.committing = 0;
    800046ec:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046f0:	8526                	mv	a0,s1
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	d44080e7          	jalr	-700(ra) # 80002436 <wakeup>
    release(&log.lock);
    800046fa:	8526                	mv	a0,s1
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	79e080e7          	jalr	1950(ra) # 80000e9a <release>
}
    80004704:	a03d                	j	80004732 <end_op+0xaa>
    panic("log.committing");
    80004706:	00004517          	auipc	a0,0x4
    8000470a:	eda50513          	addi	a0,a0,-294 # 800085e0 <etext+0x5e0>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	e30080e7          	jalr	-464(ra) # 8000053e <panic>
    wakeup(&log);
    80004716:	0023d497          	auipc	s1,0x23d
    8000471a:	8d248493          	addi	s1,s1,-1838 # 80240fe8 <log>
    8000471e:	8526                	mv	a0,s1
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	d16080e7          	jalr	-746(ra) # 80002436 <wakeup>
  release(&log.lock);
    80004728:	8526                	mv	a0,s1
    8000472a:	ffffc097          	auipc	ra,0xffffc
    8000472e:	770080e7          	jalr	1904(ra) # 80000e9a <release>
}
    80004732:	70e2                	ld	ra,56(sp)
    80004734:	7442                	ld	s0,48(sp)
    80004736:	74a2                	ld	s1,40(sp)
    80004738:	7902                	ld	s2,32(sp)
    8000473a:	69e2                	ld	s3,24(sp)
    8000473c:	6a42                	ld	s4,16(sp)
    8000473e:	6aa2                	ld	s5,8(sp)
    80004740:	6121                	addi	sp,sp,64
    80004742:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004744:	0023da97          	auipc	s5,0x23d
    80004748:	8d4a8a93          	addi	s5,s5,-1836 # 80241018 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000474c:	0023da17          	auipc	s4,0x23d
    80004750:	89ca0a13          	addi	s4,s4,-1892 # 80240fe8 <log>
    80004754:	018a2583          	lw	a1,24(s4)
    80004758:	012585bb          	addw	a1,a1,s2
    8000475c:	2585                	addiw	a1,a1,1
    8000475e:	028a2503          	lw	a0,40(s4)
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	cca080e7          	jalr	-822(ra) # 8000342c <bread>
    8000476a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000476c:	000aa583          	lw	a1,0(s5)
    80004770:	028a2503          	lw	a0,40(s4)
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	cb8080e7          	jalr	-840(ra) # 8000342c <bread>
    8000477c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000477e:	40000613          	li	a2,1024
    80004782:	05850593          	addi	a1,a0,88
    80004786:	05848513          	addi	a0,s1,88
    8000478a:	ffffc097          	auipc	ra,0xffffc
    8000478e:	7b4080e7          	jalr	1972(ra) # 80000f3e <memmove>
    bwrite(to);  // write the log
    80004792:	8526                	mv	a0,s1
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	d8a080e7          	jalr	-630(ra) # 8000351e <bwrite>
    brelse(from);
    8000479c:	854e                	mv	a0,s3
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	dbe080e7          	jalr	-578(ra) # 8000355c <brelse>
    brelse(to);
    800047a6:	8526                	mv	a0,s1
    800047a8:	fffff097          	auipc	ra,0xfffff
    800047ac:	db4080e7          	jalr	-588(ra) # 8000355c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047b0:	2905                	addiw	s2,s2,1
    800047b2:	0a91                	addi	s5,s5,4
    800047b4:	02ca2783          	lw	a5,44(s4)
    800047b8:	f8f94ee3          	blt	s2,a5,80004754 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	c6a080e7          	jalr	-918(ra) # 80004426 <write_head>
    install_trans(0); // Now install writes to home locations
    800047c4:	4501                	li	a0,0
    800047c6:	00000097          	auipc	ra,0x0
    800047ca:	cda080e7          	jalr	-806(ra) # 800044a0 <install_trans>
    log.lh.n = 0;
    800047ce:	0023d797          	auipc	a5,0x23d
    800047d2:	8407a323          	sw	zero,-1978(a5) # 80241014 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800047d6:	00000097          	auipc	ra,0x0
    800047da:	c50080e7          	jalr	-944(ra) # 80004426 <write_head>
    800047de:	bdf5                	j	800046da <end_op+0x52>

00000000800047e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800047e0:	1101                	addi	sp,sp,-32
    800047e2:	ec06                	sd	ra,24(sp)
    800047e4:	e822                	sd	s0,16(sp)
    800047e6:	e426                	sd	s1,8(sp)
    800047e8:	e04a                	sd	s2,0(sp)
    800047ea:	1000                	addi	s0,sp,32
    800047ec:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800047ee:	0023c917          	auipc	s2,0x23c
    800047f2:	7fa90913          	addi	s2,s2,2042 # 80240fe8 <log>
    800047f6:	854a                	mv	a0,s2
    800047f8:	ffffc097          	auipc	ra,0xffffc
    800047fc:	5ee080e7          	jalr	1518(ra) # 80000de6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004800:	02c92603          	lw	a2,44(s2)
    80004804:	47f5                	li	a5,29
    80004806:	06c7c563          	blt	a5,a2,80004870 <log_write+0x90>
    8000480a:	0023c797          	auipc	a5,0x23c
    8000480e:	7fa7a783          	lw	a5,2042(a5) # 80241004 <log+0x1c>
    80004812:	37fd                	addiw	a5,a5,-1
    80004814:	04f65e63          	bge	a2,a5,80004870 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004818:	0023c797          	auipc	a5,0x23c
    8000481c:	7f07a783          	lw	a5,2032(a5) # 80241008 <log+0x20>
    80004820:	06f05063          	blez	a5,80004880 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004824:	4781                	li	a5,0
    80004826:	06c05563          	blez	a2,80004890 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000482a:	44cc                	lw	a1,12(s1)
    8000482c:	0023c717          	auipc	a4,0x23c
    80004830:	7ec70713          	addi	a4,a4,2028 # 80241018 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004834:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004836:	4314                	lw	a3,0(a4)
    80004838:	04b68c63          	beq	a3,a1,80004890 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000483c:	2785                	addiw	a5,a5,1
    8000483e:	0711                	addi	a4,a4,4
    80004840:	fef61be3          	bne	a2,a5,80004836 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004844:	0621                	addi	a2,a2,8
    80004846:	060a                	slli	a2,a2,0x2
    80004848:	0023c797          	auipc	a5,0x23c
    8000484c:	7a078793          	addi	a5,a5,1952 # 80240fe8 <log>
    80004850:	963e                	add	a2,a2,a5
    80004852:	44dc                	lw	a5,12(s1)
    80004854:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004856:	8526                	mv	a0,s1
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	da2080e7          	jalr	-606(ra) # 800035fa <bpin>
    log.lh.n++;
    80004860:	0023c717          	auipc	a4,0x23c
    80004864:	78870713          	addi	a4,a4,1928 # 80240fe8 <log>
    80004868:	575c                	lw	a5,44(a4)
    8000486a:	2785                	addiw	a5,a5,1
    8000486c:	d75c                	sw	a5,44(a4)
    8000486e:	a835                	j	800048aa <log_write+0xca>
    panic("too big a transaction");
    80004870:	00004517          	auipc	a0,0x4
    80004874:	d8050513          	addi	a0,a0,-640 # 800085f0 <etext+0x5f0>
    80004878:	ffffc097          	auipc	ra,0xffffc
    8000487c:	cc6080e7          	jalr	-826(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004880:	00004517          	auipc	a0,0x4
    80004884:	d8850513          	addi	a0,a0,-632 # 80008608 <etext+0x608>
    80004888:	ffffc097          	auipc	ra,0xffffc
    8000488c:	cb6080e7          	jalr	-842(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004890:	00878713          	addi	a4,a5,8
    80004894:	00271693          	slli	a3,a4,0x2
    80004898:	0023c717          	auipc	a4,0x23c
    8000489c:	75070713          	addi	a4,a4,1872 # 80240fe8 <log>
    800048a0:	9736                	add	a4,a4,a3
    800048a2:	44d4                	lw	a3,12(s1)
    800048a4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800048a6:	faf608e3          	beq	a2,a5,80004856 <log_write+0x76>
  }
  release(&log.lock);
    800048aa:	0023c517          	auipc	a0,0x23c
    800048ae:	73e50513          	addi	a0,a0,1854 # 80240fe8 <log>
    800048b2:	ffffc097          	auipc	ra,0xffffc
    800048b6:	5e8080e7          	jalr	1512(ra) # 80000e9a <release>
}
    800048ba:	60e2                	ld	ra,24(sp)
    800048bc:	6442                	ld	s0,16(sp)
    800048be:	64a2                	ld	s1,8(sp)
    800048c0:	6902                	ld	s2,0(sp)
    800048c2:	6105                	addi	sp,sp,32
    800048c4:	8082                	ret

00000000800048c6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800048c6:	1101                	addi	sp,sp,-32
    800048c8:	ec06                	sd	ra,24(sp)
    800048ca:	e822                	sd	s0,16(sp)
    800048cc:	e426                	sd	s1,8(sp)
    800048ce:	e04a                	sd	s2,0(sp)
    800048d0:	1000                	addi	s0,sp,32
    800048d2:	84aa                	mv	s1,a0
    800048d4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048d6:	00004597          	auipc	a1,0x4
    800048da:	d5258593          	addi	a1,a1,-686 # 80008628 <etext+0x628>
    800048de:	0521                	addi	a0,a0,8
    800048e0:	ffffc097          	auipc	ra,0xffffc
    800048e4:	476080e7          	jalr	1142(ra) # 80000d56 <initlock>
  lk->name = name;
    800048e8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048ec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048f0:	0204a423          	sw	zero,40(s1)
}
    800048f4:	60e2                	ld	ra,24(sp)
    800048f6:	6442                	ld	s0,16(sp)
    800048f8:	64a2                	ld	s1,8(sp)
    800048fa:	6902                	ld	s2,0(sp)
    800048fc:	6105                	addi	sp,sp,32
    800048fe:	8082                	ret

0000000080004900 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004900:	1101                	addi	sp,sp,-32
    80004902:	ec06                	sd	ra,24(sp)
    80004904:	e822                	sd	s0,16(sp)
    80004906:	e426                	sd	s1,8(sp)
    80004908:	e04a                	sd	s2,0(sp)
    8000490a:	1000                	addi	s0,sp,32
    8000490c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000490e:	00850913          	addi	s2,a0,8
    80004912:	854a                	mv	a0,s2
    80004914:	ffffc097          	auipc	ra,0xffffc
    80004918:	4d2080e7          	jalr	1234(ra) # 80000de6 <acquire>
  while (lk->locked) {
    8000491c:	409c                	lw	a5,0(s1)
    8000491e:	cb89                	beqz	a5,80004930 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004920:	85ca                	mv	a1,s2
    80004922:	8526                	mv	a0,s1
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	aae080e7          	jalr	-1362(ra) # 800023d2 <sleep>
  while (lk->locked) {
    8000492c:	409c                	lw	a5,0(s1)
    8000492e:	fbed                	bnez	a5,80004920 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004930:	4785                	li	a5,1
    80004932:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004934:	ffffd097          	auipc	ra,0xffffd
    80004938:	3c2080e7          	jalr	962(ra) # 80001cf6 <myproc>
    8000493c:	591c                	lw	a5,48(a0)
    8000493e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004940:	854a                	mv	a0,s2
    80004942:	ffffc097          	auipc	ra,0xffffc
    80004946:	558080e7          	jalr	1368(ra) # 80000e9a <release>
}
    8000494a:	60e2                	ld	ra,24(sp)
    8000494c:	6442                	ld	s0,16(sp)
    8000494e:	64a2                	ld	s1,8(sp)
    80004950:	6902                	ld	s2,0(sp)
    80004952:	6105                	addi	sp,sp,32
    80004954:	8082                	ret

0000000080004956 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004956:	1101                	addi	sp,sp,-32
    80004958:	ec06                	sd	ra,24(sp)
    8000495a:	e822                	sd	s0,16(sp)
    8000495c:	e426                	sd	s1,8(sp)
    8000495e:	e04a                	sd	s2,0(sp)
    80004960:	1000                	addi	s0,sp,32
    80004962:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004964:	00850913          	addi	s2,a0,8
    80004968:	854a                	mv	a0,s2
    8000496a:	ffffc097          	auipc	ra,0xffffc
    8000496e:	47c080e7          	jalr	1148(ra) # 80000de6 <acquire>
  lk->locked = 0;
    80004972:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004976:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000497a:	8526                	mv	a0,s1
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	aba080e7          	jalr	-1350(ra) # 80002436 <wakeup>
  release(&lk->lk);
    80004984:	854a                	mv	a0,s2
    80004986:	ffffc097          	auipc	ra,0xffffc
    8000498a:	514080e7          	jalr	1300(ra) # 80000e9a <release>
}
    8000498e:	60e2                	ld	ra,24(sp)
    80004990:	6442                	ld	s0,16(sp)
    80004992:	64a2                	ld	s1,8(sp)
    80004994:	6902                	ld	s2,0(sp)
    80004996:	6105                	addi	sp,sp,32
    80004998:	8082                	ret

000000008000499a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000499a:	7179                	addi	sp,sp,-48
    8000499c:	f406                	sd	ra,40(sp)
    8000499e:	f022                	sd	s0,32(sp)
    800049a0:	ec26                	sd	s1,24(sp)
    800049a2:	e84a                	sd	s2,16(sp)
    800049a4:	e44e                	sd	s3,8(sp)
    800049a6:	1800                	addi	s0,sp,48
    800049a8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800049aa:	00850913          	addi	s2,a0,8
    800049ae:	854a                	mv	a0,s2
    800049b0:	ffffc097          	auipc	ra,0xffffc
    800049b4:	436080e7          	jalr	1078(ra) # 80000de6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800049b8:	409c                	lw	a5,0(s1)
    800049ba:	ef99                	bnez	a5,800049d8 <holdingsleep+0x3e>
    800049bc:	4481                	li	s1,0
  release(&lk->lk);
    800049be:	854a                	mv	a0,s2
    800049c0:	ffffc097          	auipc	ra,0xffffc
    800049c4:	4da080e7          	jalr	1242(ra) # 80000e9a <release>
  return r;
}
    800049c8:	8526                	mv	a0,s1
    800049ca:	70a2                	ld	ra,40(sp)
    800049cc:	7402                	ld	s0,32(sp)
    800049ce:	64e2                	ld	s1,24(sp)
    800049d0:	6942                	ld	s2,16(sp)
    800049d2:	69a2                	ld	s3,8(sp)
    800049d4:	6145                	addi	sp,sp,48
    800049d6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800049d8:	0284a983          	lw	s3,40(s1)
    800049dc:	ffffd097          	auipc	ra,0xffffd
    800049e0:	31a080e7          	jalr	794(ra) # 80001cf6 <myproc>
    800049e4:	5904                	lw	s1,48(a0)
    800049e6:	413484b3          	sub	s1,s1,s3
    800049ea:	0014b493          	seqz	s1,s1
    800049ee:	bfc1                	j	800049be <holdingsleep+0x24>

00000000800049f0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049f0:	1141                	addi	sp,sp,-16
    800049f2:	e406                	sd	ra,8(sp)
    800049f4:	e022                	sd	s0,0(sp)
    800049f6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800049f8:	00004597          	auipc	a1,0x4
    800049fc:	c4058593          	addi	a1,a1,-960 # 80008638 <etext+0x638>
    80004a00:	0023c517          	auipc	a0,0x23c
    80004a04:	73050513          	addi	a0,a0,1840 # 80241130 <ftable>
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	34e080e7          	jalr	846(ra) # 80000d56 <initlock>
}
    80004a10:	60a2                	ld	ra,8(sp)
    80004a12:	6402                	ld	s0,0(sp)
    80004a14:	0141                	addi	sp,sp,16
    80004a16:	8082                	ret

0000000080004a18 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a18:	1101                	addi	sp,sp,-32
    80004a1a:	ec06                	sd	ra,24(sp)
    80004a1c:	e822                	sd	s0,16(sp)
    80004a1e:	e426                	sd	s1,8(sp)
    80004a20:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a22:	0023c517          	auipc	a0,0x23c
    80004a26:	70e50513          	addi	a0,a0,1806 # 80241130 <ftable>
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	3bc080e7          	jalr	956(ra) # 80000de6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a32:	0023c497          	auipc	s1,0x23c
    80004a36:	71648493          	addi	s1,s1,1814 # 80241148 <ftable+0x18>
    80004a3a:	0023d717          	auipc	a4,0x23d
    80004a3e:	6ae70713          	addi	a4,a4,1710 # 802420e8 <disk>
    if(f->ref == 0){
    80004a42:	40dc                	lw	a5,4(s1)
    80004a44:	cf99                	beqz	a5,80004a62 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a46:	02848493          	addi	s1,s1,40
    80004a4a:	fee49ce3          	bne	s1,a4,80004a42 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a4e:	0023c517          	auipc	a0,0x23c
    80004a52:	6e250513          	addi	a0,a0,1762 # 80241130 <ftable>
    80004a56:	ffffc097          	auipc	ra,0xffffc
    80004a5a:	444080e7          	jalr	1092(ra) # 80000e9a <release>
  return 0;
    80004a5e:	4481                	li	s1,0
    80004a60:	a819                	j	80004a76 <filealloc+0x5e>
      f->ref = 1;
    80004a62:	4785                	li	a5,1
    80004a64:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a66:	0023c517          	auipc	a0,0x23c
    80004a6a:	6ca50513          	addi	a0,a0,1738 # 80241130 <ftable>
    80004a6e:	ffffc097          	auipc	ra,0xffffc
    80004a72:	42c080e7          	jalr	1068(ra) # 80000e9a <release>
}
    80004a76:	8526                	mv	a0,s1
    80004a78:	60e2                	ld	ra,24(sp)
    80004a7a:	6442                	ld	s0,16(sp)
    80004a7c:	64a2                	ld	s1,8(sp)
    80004a7e:	6105                	addi	sp,sp,32
    80004a80:	8082                	ret

0000000080004a82 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a82:	1101                	addi	sp,sp,-32
    80004a84:	ec06                	sd	ra,24(sp)
    80004a86:	e822                	sd	s0,16(sp)
    80004a88:	e426                	sd	s1,8(sp)
    80004a8a:	1000                	addi	s0,sp,32
    80004a8c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a8e:	0023c517          	auipc	a0,0x23c
    80004a92:	6a250513          	addi	a0,a0,1698 # 80241130 <ftable>
    80004a96:	ffffc097          	auipc	ra,0xffffc
    80004a9a:	350080e7          	jalr	848(ra) # 80000de6 <acquire>
  if(f->ref < 1)
    80004a9e:	40dc                	lw	a5,4(s1)
    80004aa0:	02f05263          	blez	a5,80004ac4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004aa4:	2785                	addiw	a5,a5,1
    80004aa6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004aa8:	0023c517          	auipc	a0,0x23c
    80004aac:	68850513          	addi	a0,a0,1672 # 80241130 <ftable>
    80004ab0:	ffffc097          	auipc	ra,0xffffc
    80004ab4:	3ea080e7          	jalr	1002(ra) # 80000e9a <release>
  return f;
}
    80004ab8:	8526                	mv	a0,s1
    80004aba:	60e2                	ld	ra,24(sp)
    80004abc:	6442                	ld	s0,16(sp)
    80004abe:	64a2                	ld	s1,8(sp)
    80004ac0:	6105                	addi	sp,sp,32
    80004ac2:	8082                	ret
    panic("filedup");
    80004ac4:	00004517          	auipc	a0,0x4
    80004ac8:	b7c50513          	addi	a0,a0,-1156 # 80008640 <etext+0x640>
    80004acc:	ffffc097          	auipc	ra,0xffffc
    80004ad0:	a72080e7          	jalr	-1422(ra) # 8000053e <panic>

0000000080004ad4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004ad4:	7139                	addi	sp,sp,-64
    80004ad6:	fc06                	sd	ra,56(sp)
    80004ad8:	f822                	sd	s0,48(sp)
    80004ada:	f426                	sd	s1,40(sp)
    80004adc:	f04a                	sd	s2,32(sp)
    80004ade:	ec4e                	sd	s3,24(sp)
    80004ae0:	e852                	sd	s4,16(sp)
    80004ae2:	e456                	sd	s5,8(sp)
    80004ae4:	0080                	addi	s0,sp,64
    80004ae6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ae8:	0023c517          	auipc	a0,0x23c
    80004aec:	64850513          	addi	a0,a0,1608 # 80241130 <ftable>
    80004af0:	ffffc097          	auipc	ra,0xffffc
    80004af4:	2f6080e7          	jalr	758(ra) # 80000de6 <acquire>
  if(f->ref < 1)
    80004af8:	40dc                	lw	a5,4(s1)
    80004afa:	06f05163          	blez	a5,80004b5c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004afe:	37fd                	addiw	a5,a5,-1
    80004b00:	0007871b          	sext.w	a4,a5
    80004b04:	c0dc                	sw	a5,4(s1)
    80004b06:	06e04363          	bgtz	a4,80004b6c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b0a:	0004a903          	lw	s2,0(s1)
    80004b0e:	0094ca83          	lbu	s5,9(s1)
    80004b12:	0104ba03          	ld	s4,16(s1)
    80004b16:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b1a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b1e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b22:	0023c517          	auipc	a0,0x23c
    80004b26:	60e50513          	addi	a0,a0,1550 # 80241130 <ftable>
    80004b2a:	ffffc097          	auipc	ra,0xffffc
    80004b2e:	370080e7          	jalr	880(ra) # 80000e9a <release>

  if(ff.type == FD_PIPE){
    80004b32:	4785                	li	a5,1
    80004b34:	04f90d63          	beq	s2,a5,80004b8e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b38:	3979                	addiw	s2,s2,-2
    80004b3a:	4785                	li	a5,1
    80004b3c:	0527e063          	bltu	a5,s2,80004b7c <fileclose+0xa8>
    begin_op();
    80004b40:	00000097          	auipc	ra,0x0
    80004b44:	ac8080e7          	jalr	-1336(ra) # 80004608 <begin_op>
    iput(ff.ip);
    80004b48:	854e                	mv	a0,s3
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	2b6080e7          	jalr	694(ra) # 80003e00 <iput>
    end_op();
    80004b52:	00000097          	auipc	ra,0x0
    80004b56:	b36080e7          	jalr	-1226(ra) # 80004688 <end_op>
    80004b5a:	a00d                	j	80004b7c <fileclose+0xa8>
    panic("fileclose");
    80004b5c:	00004517          	auipc	a0,0x4
    80004b60:	aec50513          	addi	a0,a0,-1300 # 80008648 <etext+0x648>
    80004b64:	ffffc097          	auipc	ra,0xffffc
    80004b68:	9da080e7          	jalr	-1574(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004b6c:	0023c517          	auipc	a0,0x23c
    80004b70:	5c450513          	addi	a0,a0,1476 # 80241130 <ftable>
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	326080e7          	jalr	806(ra) # 80000e9a <release>
  }
}
    80004b7c:	70e2                	ld	ra,56(sp)
    80004b7e:	7442                	ld	s0,48(sp)
    80004b80:	74a2                	ld	s1,40(sp)
    80004b82:	7902                	ld	s2,32(sp)
    80004b84:	69e2                	ld	s3,24(sp)
    80004b86:	6a42                	ld	s4,16(sp)
    80004b88:	6aa2                	ld	s5,8(sp)
    80004b8a:	6121                	addi	sp,sp,64
    80004b8c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b8e:	85d6                	mv	a1,s5
    80004b90:	8552                	mv	a0,s4
    80004b92:	00000097          	auipc	ra,0x0
    80004b96:	34c080e7          	jalr	844(ra) # 80004ede <pipeclose>
    80004b9a:	b7cd                	j	80004b7c <fileclose+0xa8>

0000000080004b9c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b9c:	715d                	addi	sp,sp,-80
    80004b9e:	e486                	sd	ra,72(sp)
    80004ba0:	e0a2                	sd	s0,64(sp)
    80004ba2:	fc26                	sd	s1,56(sp)
    80004ba4:	f84a                	sd	s2,48(sp)
    80004ba6:	f44e                	sd	s3,40(sp)
    80004ba8:	0880                	addi	s0,sp,80
    80004baa:	84aa                	mv	s1,a0
    80004bac:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	148080e7          	jalr	328(ra) # 80001cf6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004bb6:	409c                	lw	a5,0(s1)
    80004bb8:	37f9                	addiw	a5,a5,-2
    80004bba:	4705                	li	a4,1
    80004bbc:	04f76763          	bltu	a4,a5,80004c0a <filestat+0x6e>
    80004bc0:	892a                	mv	s2,a0
    ilock(f->ip);
    80004bc2:	6c88                	ld	a0,24(s1)
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	082080e7          	jalr	130(ra) # 80003c46 <ilock>
    stati(f->ip, &st);
    80004bcc:	fb840593          	addi	a1,s0,-72
    80004bd0:	6c88                	ld	a0,24(s1)
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	2fe080e7          	jalr	766(ra) # 80003ed0 <stati>
    iunlock(f->ip);
    80004bda:	6c88                	ld	a0,24(s1)
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	12c080e7          	jalr	300(ra) # 80003d08 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004be4:	46e1                	li	a3,24
    80004be6:	fb840613          	addi	a2,s0,-72
    80004bea:	85ce                	mv	a1,s3
    80004bec:	05093503          	ld	a0,80(s2)
    80004bf0:	ffffd097          	auipc	ra,0xffffd
    80004bf4:	dae080e7          	jalr	-594(ra) # 8000199e <copyout>
    80004bf8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004bfc:	60a6                	ld	ra,72(sp)
    80004bfe:	6406                	ld	s0,64(sp)
    80004c00:	74e2                	ld	s1,56(sp)
    80004c02:	7942                	ld	s2,48(sp)
    80004c04:	79a2                	ld	s3,40(sp)
    80004c06:	6161                	addi	sp,sp,80
    80004c08:	8082                	ret
  return -1;
    80004c0a:	557d                	li	a0,-1
    80004c0c:	bfc5                	j	80004bfc <filestat+0x60>

0000000080004c0e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c0e:	7179                	addi	sp,sp,-48
    80004c10:	f406                	sd	ra,40(sp)
    80004c12:	f022                	sd	s0,32(sp)
    80004c14:	ec26                	sd	s1,24(sp)
    80004c16:	e84a                	sd	s2,16(sp)
    80004c18:	e44e                	sd	s3,8(sp)
    80004c1a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c1c:	00854783          	lbu	a5,8(a0)
    80004c20:	c3d5                	beqz	a5,80004cc4 <fileread+0xb6>
    80004c22:	84aa                	mv	s1,a0
    80004c24:	89ae                	mv	s3,a1
    80004c26:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c28:	411c                	lw	a5,0(a0)
    80004c2a:	4705                	li	a4,1
    80004c2c:	04e78963          	beq	a5,a4,80004c7e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c30:	470d                	li	a4,3
    80004c32:	04e78d63          	beq	a5,a4,80004c8c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c36:	4709                	li	a4,2
    80004c38:	06e79e63          	bne	a5,a4,80004cb4 <fileread+0xa6>
    ilock(f->ip);
    80004c3c:	6d08                	ld	a0,24(a0)
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	008080e7          	jalr	8(ra) # 80003c46 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c46:	874a                	mv	a4,s2
    80004c48:	5094                	lw	a3,32(s1)
    80004c4a:	864e                	mv	a2,s3
    80004c4c:	4585                	li	a1,1
    80004c4e:	6c88                	ld	a0,24(s1)
    80004c50:	fffff097          	auipc	ra,0xfffff
    80004c54:	2aa080e7          	jalr	682(ra) # 80003efa <readi>
    80004c58:	892a                	mv	s2,a0
    80004c5a:	00a05563          	blez	a0,80004c64 <fileread+0x56>
      f->off += r;
    80004c5e:	509c                	lw	a5,32(s1)
    80004c60:	9fa9                	addw	a5,a5,a0
    80004c62:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c64:	6c88                	ld	a0,24(s1)
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	0a2080e7          	jalr	162(ra) # 80003d08 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004c6e:	854a                	mv	a0,s2
    80004c70:	70a2                	ld	ra,40(sp)
    80004c72:	7402                	ld	s0,32(sp)
    80004c74:	64e2                	ld	s1,24(sp)
    80004c76:	6942                	ld	s2,16(sp)
    80004c78:	69a2                	ld	s3,8(sp)
    80004c7a:	6145                	addi	sp,sp,48
    80004c7c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c7e:	6908                	ld	a0,16(a0)
    80004c80:	00000097          	auipc	ra,0x0
    80004c84:	3c6080e7          	jalr	966(ra) # 80005046 <piperead>
    80004c88:	892a                	mv	s2,a0
    80004c8a:	b7d5                	j	80004c6e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c8c:	02451783          	lh	a5,36(a0)
    80004c90:	03079693          	slli	a3,a5,0x30
    80004c94:	92c1                	srli	a3,a3,0x30
    80004c96:	4725                	li	a4,9
    80004c98:	02d76863          	bltu	a4,a3,80004cc8 <fileread+0xba>
    80004c9c:	0792                	slli	a5,a5,0x4
    80004c9e:	0023c717          	auipc	a4,0x23c
    80004ca2:	3f270713          	addi	a4,a4,1010 # 80241090 <devsw>
    80004ca6:	97ba                	add	a5,a5,a4
    80004ca8:	639c                	ld	a5,0(a5)
    80004caa:	c38d                	beqz	a5,80004ccc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004cac:	4505                	li	a0,1
    80004cae:	9782                	jalr	a5
    80004cb0:	892a                	mv	s2,a0
    80004cb2:	bf75                	j	80004c6e <fileread+0x60>
    panic("fileread");
    80004cb4:	00004517          	auipc	a0,0x4
    80004cb8:	9a450513          	addi	a0,a0,-1628 # 80008658 <etext+0x658>
    80004cbc:	ffffc097          	auipc	ra,0xffffc
    80004cc0:	882080e7          	jalr	-1918(ra) # 8000053e <panic>
    return -1;
    80004cc4:	597d                	li	s2,-1
    80004cc6:	b765                	j	80004c6e <fileread+0x60>
      return -1;
    80004cc8:	597d                	li	s2,-1
    80004cca:	b755                	j	80004c6e <fileread+0x60>
    80004ccc:	597d                	li	s2,-1
    80004cce:	b745                	j	80004c6e <fileread+0x60>

0000000080004cd0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004cd0:	715d                	addi	sp,sp,-80
    80004cd2:	e486                	sd	ra,72(sp)
    80004cd4:	e0a2                	sd	s0,64(sp)
    80004cd6:	fc26                	sd	s1,56(sp)
    80004cd8:	f84a                	sd	s2,48(sp)
    80004cda:	f44e                	sd	s3,40(sp)
    80004cdc:	f052                	sd	s4,32(sp)
    80004cde:	ec56                	sd	s5,24(sp)
    80004ce0:	e85a                	sd	s6,16(sp)
    80004ce2:	e45e                	sd	s7,8(sp)
    80004ce4:	e062                	sd	s8,0(sp)
    80004ce6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004ce8:	00954783          	lbu	a5,9(a0)
    80004cec:	10078663          	beqz	a5,80004df8 <filewrite+0x128>
    80004cf0:	892a                	mv	s2,a0
    80004cf2:	8aae                	mv	s5,a1
    80004cf4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cf6:	411c                	lw	a5,0(a0)
    80004cf8:	4705                	li	a4,1
    80004cfa:	02e78263          	beq	a5,a4,80004d1e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cfe:	470d                	li	a4,3
    80004d00:	02e78663          	beq	a5,a4,80004d2c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d04:	4709                	li	a4,2
    80004d06:	0ee79163          	bne	a5,a4,80004de8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d0a:	0ac05d63          	blez	a2,80004dc4 <filewrite+0xf4>
    int i = 0;
    80004d0e:	4981                	li	s3,0
    80004d10:	6b05                	lui	s6,0x1
    80004d12:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004d16:	6b85                	lui	s7,0x1
    80004d18:	c00b8b9b          	addiw	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004d1c:	a861                	j	80004db4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004d1e:	6908                	ld	a0,16(a0)
    80004d20:	00000097          	auipc	ra,0x0
    80004d24:	22e080e7          	jalr	558(ra) # 80004f4e <pipewrite>
    80004d28:	8a2a                	mv	s4,a0
    80004d2a:	a045                	j	80004dca <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d2c:	02451783          	lh	a5,36(a0)
    80004d30:	03079693          	slli	a3,a5,0x30
    80004d34:	92c1                	srli	a3,a3,0x30
    80004d36:	4725                	li	a4,9
    80004d38:	0cd76263          	bltu	a4,a3,80004dfc <filewrite+0x12c>
    80004d3c:	0792                	slli	a5,a5,0x4
    80004d3e:	0023c717          	auipc	a4,0x23c
    80004d42:	35270713          	addi	a4,a4,850 # 80241090 <devsw>
    80004d46:	97ba                	add	a5,a5,a4
    80004d48:	679c                	ld	a5,8(a5)
    80004d4a:	cbdd                	beqz	a5,80004e00 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004d4c:	4505                	li	a0,1
    80004d4e:	9782                	jalr	a5
    80004d50:	8a2a                	mv	s4,a0
    80004d52:	a8a5                	j	80004dca <filewrite+0xfa>
    80004d54:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004d58:	00000097          	auipc	ra,0x0
    80004d5c:	8b0080e7          	jalr	-1872(ra) # 80004608 <begin_op>
      ilock(f->ip);
    80004d60:	01893503          	ld	a0,24(s2)
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	ee2080e7          	jalr	-286(ra) # 80003c46 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d6c:	8762                	mv	a4,s8
    80004d6e:	02092683          	lw	a3,32(s2)
    80004d72:	01598633          	add	a2,s3,s5
    80004d76:	4585                	li	a1,1
    80004d78:	01893503          	ld	a0,24(s2)
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	276080e7          	jalr	630(ra) # 80003ff2 <writei>
    80004d84:	84aa                	mv	s1,a0
    80004d86:	00a05763          	blez	a0,80004d94 <filewrite+0xc4>
        f->off += r;
    80004d8a:	02092783          	lw	a5,32(s2)
    80004d8e:	9fa9                	addw	a5,a5,a0
    80004d90:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d94:	01893503          	ld	a0,24(s2)
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	f70080e7          	jalr	-144(ra) # 80003d08 <iunlock>
      end_op();
    80004da0:	00000097          	auipc	ra,0x0
    80004da4:	8e8080e7          	jalr	-1816(ra) # 80004688 <end_op>

      if(r != n1){
    80004da8:	009c1f63          	bne	s8,s1,80004dc6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004dac:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004db0:	0149db63          	bge	s3,s4,80004dc6 <filewrite+0xf6>
      int n1 = n - i;
    80004db4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004db8:	84be                	mv	s1,a5
    80004dba:	2781                	sext.w	a5,a5
    80004dbc:	f8fb5ce3          	bge	s6,a5,80004d54 <filewrite+0x84>
    80004dc0:	84de                	mv	s1,s7
    80004dc2:	bf49                	j	80004d54 <filewrite+0x84>
    int i = 0;
    80004dc4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004dc6:	013a1f63          	bne	s4,s3,80004de4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004dca:	8552                	mv	a0,s4
    80004dcc:	60a6                	ld	ra,72(sp)
    80004dce:	6406                	ld	s0,64(sp)
    80004dd0:	74e2                	ld	s1,56(sp)
    80004dd2:	7942                	ld	s2,48(sp)
    80004dd4:	79a2                	ld	s3,40(sp)
    80004dd6:	7a02                	ld	s4,32(sp)
    80004dd8:	6ae2                	ld	s5,24(sp)
    80004dda:	6b42                	ld	s6,16(sp)
    80004ddc:	6ba2                	ld	s7,8(sp)
    80004dde:	6c02                	ld	s8,0(sp)
    80004de0:	6161                	addi	sp,sp,80
    80004de2:	8082                	ret
    ret = (i == n ? n : -1);
    80004de4:	5a7d                	li	s4,-1
    80004de6:	b7d5                	j	80004dca <filewrite+0xfa>
    panic("filewrite");
    80004de8:	00004517          	auipc	a0,0x4
    80004dec:	88050513          	addi	a0,a0,-1920 # 80008668 <etext+0x668>
    80004df0:	ffffb097          	auipc	ra,0xffffb
    80004df4:	74e080e7          	jalr	1870(ra) # 8000053e <panic>
    return -1;
    80004df8:	5a7d                	li	s4,-1
    80004dfa:	bfc1                	j	80004dca <filewrite+0xfa>
      return -1;
    80004dfc:	5a7d                	li	s4,-1
    80004dfe:	b7f1                	j	80004dca <filewrite+0xfa>
    80004e00:	5a7d                	li	s4,-1
    80004e02:	b7e1                	j	80004dca <filewrite+0xfa>

0000000080004e04 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e04:	7179                	addi	sp,sp,-48
    80004e06:	f406                	sd	ra,40(sp)
    80004e08:	f022                	sd	s0,32(sp)
    80004e0a:	ec26                	sd	s1,24(sp)
    80004e0c:	e84a                	sd	s2,16(sp)
    80004e0e:	e44e                	sd	s3,8(sp)
    80004e10:	e052                	sd	s4,0(sp)
    80004e12:	1800                	addi	s0,sp,48
    80004e14:	84aa                	mv	s1,a0
    80004e16:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e18:	0005b023          	sd	zero,0(a1)
    80004e1c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e20:	00000097          	auipc	ra,0x0
    80004e24:	bf8080e7          	jalr	-1032(ra) # 80004a18 <filealloc>
    80004e28:	e088                	sd	a0,0(s1)
    80004e2a:	c551                	beqz	a0,80004eb6 <pipealloc+0xb2>
    80004e2c:	00000097          	auipc	ra,0x0
    80004e30:	bec080e7          	jalr	-1044(ra) # 80004a18 <filealloc>
    80004e34:	00aa3023          	sd	a0,0(s4)
    80004e38:	c92d                	beqz	a0,80004eaa <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e3a:	ffffc097          	auipc	ra,0xffffc
    80004e3e:	eaa080e7          	jalr	-342(ra) # 80000ce4 <kalloc>
    80004e42:	892a                	mv	s2,a0
    80004e44:	c125                	beqz	a0,80004ea4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004e46:	4985                	li	s3,1
    80004e48:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e4c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e50:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e54:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e58:	00004597          	auipc	a1,0x4
    80004e5c:	82058593          	addi	a1,a1,-2016 # 80008678 <etext+0x678>
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	ef6080e7          	jalr	-266(ra) # 80000d56 <initlock>
  (*f0)->type = FD_PIPE;
    80004e68:	609c                	ld	a5,0(s1)
    80004e6a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e6e:	609c                	ld	a5,0(s1)
    80004e70:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e74:	609c                	ld	a5,0(s1)
    80004e76:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e7a:	609c                	ld	a5,0(s1)
    80004e7c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e80:	000a3783          	ld	a5,0(s4)
    80004e84:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e88:	000a3783          	ld	a5,0(s4)
    80004e8c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e90:	000a3783          	ld	a5,0(s4)
    80004e94:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e98:	000a3783          	ld	a5,0(s4)
    80004e9c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ea0:	4501                	li	a0,0
    80004ea2:	a025                	j	80004eca <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ea4:	6088                	ld	a0,0(s1)
    80004ea6:	e501                	bnez	a0,80004eae <pipealloc+0xaa>
    80004ea8:	a039                	j	80004eb6 <pipealloc+0xb2>
    80004eaa:	6088                	ld	a0,0(s1)
    80004eac:	c51d                	beqz	a0,80004eda <pipealloc+0xd6>
    fileclose(*f0);
    80004eae:	00000097          	auipc	ra,0x0
    80004eb2:	c26080e7          	jalr	-986(ra) # 80004ad4 <fileclose>
  if(*f1)
    80004eb6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004eba:	557d                	li	a0,-1
  if(*f1)
    80004ebc:	c799                	beqz	a5,80004eca <pipealloc+0xc6>
    fileclose(*f1);
    80004ebe:	853e                	mv	a0,a5
    80004ec0:	00000097          	auipc	ra,0x0
    80004ec4:	c14080e7          	jalr	-1004(ra) # 80004ad4 <fileclose>
  return -1;
    80004ec8:	557d                	li	a0,-1
}
    80004eca:	70a2                	ld	ra,40(sp)
    80004ecc:	7402                	ld	s0,32(sp)
    80004ece:	64e2                	ld	s1,24(sp)
    80004ed0:	6942                	ld	s2,16(sp)
    80004ed2:	69a2                	ld	s3,8(sp)
    80004ed4:	6a02                	ld	s4,0(sp)
    80004ed6:	6145                	addi	sp,sp,48
    80004ed8:	8082                	ret
  return -1;
    80004eda:	557d                	li	a0,-1
    80004edc:	b7fd                	j	80004eca <pipealloc+0xc6>

0000000080004ede <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ede:	1101                	addi	sp,sp,-32
    80004ee0:	ec06                	sd	ra,24(sp)
    80004ee2:	e822                	sd	s0,16(sp)
    80004ee4:	e426                	sd	s1,8(sp)
    80004ee6:	e04a                	sd	s2,0(sp)
    80004ee8:	1000                	addi	s0,sp,32
    80004eea:	84aa                	mv	s1,a0
    80004eec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004eee:	ffffc097          	auipc	ra,0xffffc
    80004ef2:	ef8080e7          	jalr	-264(ra) # 80000de6 <acquire>
  if(writable){
    80004ef6:	02090d63          	beqz	s2,80004f30 <pipeclose+0x52>
    pi->writeopen = 0;
    80004efa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004efe:	21848513          	addi	a0,s1,536
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	534080e7          	jalr	1332(ra) # 80002436 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f0a:	2204b783          	ld	a5,544(s1)
    80004f0e:	eb95                	bnez	a5,80004f42 <pipeclose+0x64>
    release(&pi->lock);
    80004f10:	8526                	mv	a0,s1
    80004f12:	ffffc097          	auipc	ra,0xffffc
    80004f16:	f88080e7          	jalr	-120(ra) # 80000e9a <release>
    kfree((char*)pi);
    80004f1a:	8526                	mv	a0,s1
    80004f1c:	ffffc097          	auipc	ra,0xffffc
    80004f20:	c82080e7          	jalr	-894(ra) # 80000b9e <kfree>
  } else
    release(&pi->lock);
}
    80004f24:	60e2                	ld	ra,24(sp)
    80004f26:	6442                	ld	s0,16(sp)
    80004f28:	64a2                	ld	s1,8(sp)
    80004f2a:	6902                	ld	s2,0(sp)
    80004f2c:	6105                	addi	sp,sp,32
    80004f2e:	8082                	ret
    pi->readopen = 0;
    80004f30:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f34:	21c48513          	addi	a0,s1,540
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	4fe080e7          	jalr	1278(ra) # 80002436 <wakeup>
    80004f40:	b7e9                	j	80004f0a <pipeclose+0x2c>
    release(&pi->lock);
    80004f42:	8526                	mv	a0,s1
    80004f44:	ffffc097          	auipc	ra,0xffffc
    80004f48:	f56080e7          	jalr	-170(ra) # 80000e9a <release>
}
    80004f4c:	bfe1                	j	80004f24 <pipeclose+0x46>

0000000080004f4e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f4e:	711d                	addi	sp,sp,-96
    80004f50:	ec86                	sd	ra,88(sp)
    80004f52:	e8a2                	sd	s0,80(sp)
    80004f54:	e4a6                	sd	s1,72(sp)
    80004f56:	e0ca                	sd	s2,64(sp)
    80004f58:	fc4e                	sd	s3,56(sp)
    80004f5a:	f852                	sd	s4,48(sp)
    80004f5c:	f456                	sd	s5,40(sp)
    80004f5e:	f05a                	sd	s6,32(sp)
    80004f60:	ec5e                	sd	s7,24(sp)
    80004f62:	e862                	sd	s8,16(sp)
    80004f64:	1080                	addi	s0,sp,96
    80004f66:	84aa                	mv	s1,a0
    80004f68:	8aae                	mv	s5,a1
    80004f6a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	d8a080e7          	jalr	-630(ra) # 80001cf6 <myproc>
    80004f74:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f76:	8526                	mv	a0,s1
    80004f78:	ffffc097          	auipc	ra,0xffffc
    80004f7c:	e6e080e7          	jalr	-402(ra) # 80000de6 <acquire>
  while(i < n){
    80004f80:	0b405663          	blez	s4,8000502c <pipewrite+0xde>
  int i = 0;
    80004f84:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f86:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f88:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f8c:	21c48b93          	addi	s7,s1,540
    80004f90:	a089                	j	80004fd2 <pipewrite+0x84>
      release(&pi->lock);
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffc097          	auipc	ra,0xffffc
    80004f98:	f06080e7          	jalr	-250(ra) # 80000e9a <release>
      return -1;
    80004f9c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004f9e:	854a                	mv	a0,s2
    80004fa0:	60e6                	ld	ra,88(sp)
    80004fa2:	6446                	ld	s0,80(sp)
    80004fa4:	64a6                	ld	s1,72(sp)
    80004fa6:	6906                	ld	s2,64(sp)
    80004fa8:	79e2                	ld	s3,56(sp)
    80004faa:	7a42                	ld	s4,48(sp)
    80004fac:	7aa2                	ld	s5,40(sp)
    80004fae:	7b02                	ld	s6,32(sp)
    80004fb0:	6be2                	ld	s7,24(sp)
    80004fb2:	6c42                	ld	s8,16(sp)
    80004fb4:	6125                	addi	sp,sp,96
    80004fb6:	8082                	ret
      wakeup(&pi->nread);
    80004fb8:	8562                	mv	a0,s8
    80004fba:	ffffd097          	auipc	ra,0xffffd
    80004fbe:	47c080e7          	jalr	1148(ra) # 80002436 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004fc2:	85a6                	mv	a1,s1
    80004fc4:	855e                	mv	a0,s7
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	40c080e7          	jalr	1036(ra) # 800023d2 <sleep>
  while(i < n){
    80004fce:	07495063          	bge	s2,s4,8000502e <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004fd2:	2204a783          	lw	a5,544(s1)
    80004fd6:	dfd5                	beqz	a5,80004f92 <pipewrite+0x44>
    80004fd8:	854e                	mv	a0,s3
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	6ac080e7          	jalr	1708(ra) # 80002686 <killed>
    80004fe2:	f945                	bnez	a0,80004f92 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004fe4:	2184a783          	lw	a5,536(s1)
    80004fe8:	21c4a703          	lw	a4,540(s1)
    80004fec:	2007879b          	addiw	a5,a5,512
    80004ff0:	fcf704e3          	beq	a4,a5,80004fb8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ff4:	4685                	li	a3,1
    80004ff6:	01590633          	add	a2,s2,s5
    80004ffa:	faf40593          	addi	a1,s0,-81
    80004ffe:	0509b503          	ld	a0,80(s3)
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	a3c080e7          	jalr	-1476(ra) # 80001a3e <copyin>
    8000500a:	03650263          	beq	a0,s6,8000502e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000500e:	21c4a783          	lw	a5,540(s1)
    80005012:	0017871b          	addiw	a4,a5,1
    80005016:	20e4ae23          	sw	a4,540(s1)
    8000501a:	1ff7f793          	andi	a5,a5,511
    8000501e:	97a6                	add	a5,a5,s1
    80005020:	faf44703          	lbu	a4,-81(s0)
    80005024:	00e78c23          	sb	a4,24(a5)
      i++;
    80005028:	2905                	addiw	s2,s2,1
    8000502a:	b755                	j	80004fce <pipewrite+0x80>
  int i = 0;
    8000502c:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000502e:	21848513          	addi	a0,s1,536
    80005032:	ffffd097          	auipc	ra,0xffffd
    80005036:	404080e7          	jalr	1028(ra) # 80002436 <wakeup>
  release(&pi->lock);
    8000503a:	8526                	mv	a0,s1
    8000503c:	ffffc097          	auipc	ra,0xffffc
    80005040:	e5e080e7          	jalr	-418(ra) # 80000e9a <release>
  return i;
    80005044:	bfa9                	j	80004f9e <pipewrite+0x50>

0000000080005046 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005046:	715d                	addi	sp,sp,-80
    80005048:	e486                	sd	ra,72(sp)
    8000504a:	e0a2                	sd	s0,64(sp)
    8000504c:	fc26                	sd	s1,56(sp)
    8000504e:	f84a                	sd	s2,48(sp)
    80005050:	f44e                	sd	s3,40(sp)
    80005052:	f052                	sd	s4,32(sp)
    80005054:	ec56                	sd	s5,24(sp)
    80005056:	e85a                	sd	s6,16(sp)
    80005058:	0880                	addi	s0,sp,80
    8000505a:	84aa                	mv	s1,a0
    8000505c:	892e                	mv	s2,a1
    8000505e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005060:	ffffd097          	auipc	ra,0xffffd
    80005064:	c96080e7          	jalr	-874(ra) # 80001cf6 <myproc>
    80005068:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000506a:	8526                	mv	a0,s1
    8000506c:	ffffc097          	auipc	ra,0xffffc
    80005070:	d7a080e7          	jalr	-646(ra) # 80000de6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005074:	2184a703          	lw	a4,536(s1)
    80005078:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000507c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005080:	02f71763          	bne	a4,a5,800050ae <piperead+0x68>
    80005084:	2244a783          	lw	a5,548(s1)
    80005088:	c39d                	beqz	a5,800050ae <piperead+0x68>
    if(killed(pr)){
    8000508a:	8552                	mv	a0,s4
    8000508c:	ffffd097          	auipc	ra,0xffffd
    80005090:	5fa080e7          	jalr	1530(ra) # 80002686 <killed>
    80005094:	e941                	bnez	a0,80005124 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005096:	85a6                	mv	a1,s1
    80005098:	854e                	mv	a0,s3
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	338080e7          	jalr	824(ra) # 800023d2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050a2:	2184a703          	lw	a4,536(s1)
    800050a6:	21c4a783          	lw	a5,540(s1)
    800050aa:	fcf70de3          	beq	a4,a5,80005084 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050ae:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050b0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050b2:	05505363          	blez	s5,800050f8 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800050b6:	2184a783          	lw	a5,536(s1)
    800050ba:	21c4a703          	lw	a4,540(s1)
    800050be:	02f70d63          	beq	a4,a5,800050f8 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800050c2:	0017871b          	addiw	a4,a5,1
    800050c6:	20e4ac23          	sw	a4,536(s1)
    800050ca:	1ff7f793          	andi	a5,a5,511
    800050ce:	97a6                	add	a5,a5,s1
    800050d0:	0187c783          	lbu	a5,24(a5)
    800050d4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050d8:	4685                	li	a3,1
    800050da:	fbf40613          	addi	a2,s0,-65
    800050de:	85ca                	mv	a1,s2
    800050e0:	050a3503          	ld	a0,80(s4)
    800050e4:	ffffd097          	auipc	ra,0xffffd
    800050e8:	8ba080e7          	jalr	-1862(ra) # 8000199e <copyout>
    800050ec:	01650663          	beq	a0,s6,800050f8 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050f0:	2985                	addiw	s3,s3,1
    800050f2:	0905                	addi	s2,s2,1
    800050f4:	fd3a91e3          	bne	s5,s3,800050b6 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800050f8:	21c48513          	addi	a0,s1,540
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	33a080e7          	jalr	826(ra) # 80002436 <wakeup>
  release(&pi->lock);
    80005104:	8526                	mv	a0,s1
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	d94080e7          	jalr	-620(ra) # 80000e9a <release>
  return i;
}
    8000510e:	854e                	mv	a0,s3
    80005110:	60a6                	ld	ra,72(sp)
    80005112:	6406                	ld	s0,64(sp)
    80005114:	74e2                	ld	s1,56(sp)
    80005116:	7942                	ld	s2,48(sp)
    80005118:	79a2                	ld	s3,40(sp)
    8000511a:	7a02                	ld	s4,32(sp)
    8000511c:	6ae2                	ld	s5,24(sp)
    8000511e:	6b42                	ld	s6,16(sp)
    80005120:	6161                	addi	sp,sp,80
    80005122:	8082                	ret
      release(&pi->lock);
    80005124:	8526                	mv	a0,s1
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	d74080e7          	jalr	-652(ra) # 80000e9a <release>
      return -1;
    8000512e:	59fd                	li	s3,-1
    80005130:	bff9                	j	8000510e <piperead+0xc8>

0000000080005132 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005132:	1141                	addi	sp,sp,-16
    80005134:	e422                	sd	s0,8(sp)
    80005136:	0800                	addi	s0,sp,16
    80005138:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000513a:	8905                	andi	a0,a0,1
    8000513c:	c111                	beqz	a0,80005140 <flags2perm+0xe>
      perm = PTE_X;
    8000513e:	4521                	li	a0,8
    if(flags & 0x2)
    80005140:	8b89                	andi	a5,a5,2
    80005142:	c399                	beqz	a5,80005148 <flags2perm+0x16>
      perm |= PTE_W;
    80005144:	00456513          	ori	a0,a0,4
    return perm;
}
    80005148:	6422                	ld	s0,8(sp)
    8000514a:	0141                	addi	sp,sp,16
    8000514c:	8082                	ret

000000008000514e <exec>:

int
exec(char *path, char **argv)
{
    8000514e:	de010113          	addi	sp,sp,-544
    80005152:	20113c23          	sd	ra,536(sp)
    80005156:	20813823          	sd	s0,528(sp)
    8000515a:	20913423          	sd	s1,520(sp)
    8000515e:	21213023          	sd	s2,512(sp)
    80005162:	ffce                	sd	s3,504(sp)
    80005164:	fbd2                	sd	s4,496(sp)
    80005166:	f7d6                	sd	s5,488(sp)
    80005168:	f3da                	sd	s6,480(sp)
    8000516a:	efde                	sd	s7,472(sp)
    8000516c:	ebe2                	sd	s8,464(sp)
    8000516e:	e7e6                	sd	s9,456(sp)
    80005170:	e3ea                	sd	s10,448(sp)
    80005172:	ff6e                	sd	s11,440(sp)
    80005174:	1400                	addi	s0,sp,544
    80005176:	892a                	mv	s2,a0
    80005178:	dea43423          	sd	a0,-536(s0)
    8000517c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005180:	ffffd097          	auipc	ra,0xffffd
    80005184:	b76080e7          	jalr	-1162(ra) # 80001cf6 <myproc>
    80005188:	84aa                	mv	s1,a0

  begin_op();
    8000518a:	fffff097          	auipc	ra,0xfffff
    8000518e:	47e080e7          	jalr	1150(ra) # 80004608 <begin_op>

  if((ip = namei(path)) == 0){
    80005192:	854a                	mv	a0,s2
    80005194:	fffff097          	auipc	ra,0xfffff
    80005198:	258080e7          	jalr	600(ra) # 800043ec <namei>
    8000519c:	c93d                	beqz	a0,80005212 <exec+0xc4>
    8000519e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	aa6080e7          	jalr	-1370(ra) # 80003c46 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800051a8:	04000713          	li	a4,64
    800051ac:	4681                	li	a3,0
    800051ae:	e5040613          	addi	a2,s0,-432
    800051b2:	4581                	li	a1,0
    800051b4:	8556                	mv	a0,s5
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	d44080e7          	jalr	-700(ra) # 80003efa <readi>
    800051be:	04000793          	li	a5,64
    800051c2:	00f51a63          	bne	a0,a5,800051d6 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800051c6:	e5042703          	lw	a4,-432(s0)
    800051ca:	464c47b7          	lui	a5,0x464c4
    800051ce:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800051d2:	04f70663          	beq	a4,a5,8000521e <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800051d6:	8556                	mv	a0,s5
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	cd0080e7          	jalr	-816(ra) # 80003ea8 <iunlockput>
    end_op();
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	4a8080e7          	jalr	1192(ra) # 80004688 <end_op>
  }
  return -1;
    800051e8:	557d                	li	a0,-1
}
    800051ea:	21813083          	ld	ra,536(sp)
    800051ee:	21013403          	ld	s0,528(sp)
    800051f2:	20813483          	ld	s1,520(sp)
    800051f6:	20013903          	ld	s2,512(sp)
    800051fa:	79fe                	ld	s3,504(sp)
    800051fc:	7a5e                	ld	s4,496(sp)
    800051fe:	7abe                	ld	s5,488(sp)
    80005200:	7b1e                	ld	s6,480(sp)
    80005202:	6bfe                	ld	s7,472(sp)
    80005204:	6c5e                	ld	s8,464(sp)
    80005206:	6cbe                	ld	s9,456(sp)
    80005208:	6d1e                	ld	s10,448(sp)
    8000520a:	7dfa                	ld	s11,440(sp)
    8000520c:	22010113          	addi	sp,sp,544
    80005210:	8082                	ret
    end_op();
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	476080e7          	jalr	1142(ra) # 80004688 <end_op>
    return -1;
    8000521a:	557d                	li	a0,-1
    8000521c:	b7f9                	j	800051ea <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000521e:	8526                	mv	a0,s1
    80005220:	ffffd097          	auipc	ra,0xffffd
    80005224:	b9a080e7          	jalr	-1126(ra) # 80001dba <proc_pagetable>
    80005228:	8b2a                	mv	s6,a0
    8000522a:	d555                	beqz	a0,800051d6 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000522c:	e7042783          	lw	a5,-400(s0)
    80005230:	e8845703          	lhu	a4,-376(s0)
    80005234:	c735                	beqz	a4,800052a0 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005236:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005238:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000523c:	6a05                	lui	s4,0x1
    8000523e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005242:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80005246:	6d85                	lui	s11,0x1
    80005248:	7d7d                	lui	s10,0xfffff
    8000524a:	a481                	j	8000548a <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000524c:	00003517          	auipc	a0,0x3
    80005250:	43450513          	addi	a0,a0,1076 # 80008680 <etext+0x680>
    80005254:	ffffb097          	auipc	ra,0xffffb
    80005258:	2ea080e7          	jalr	746(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000525c:	874a                	mv	a4,s2
    8000525e:	009c86bb          	addw	a3,s9,s1
    80005262:	4581                	li	a1,0
    80005264:	8556                	mv	a0,s5
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	c94080e7          	jalr	-876(ra) # 80003efa <readi>
    8000526e:	2501                	sext.w	a0,a0
    80005270:	1aa91a63          	bne	s2,a0,80005424 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80005274:	009d84bb          	addw	s1,s11,s1
    80005278:	013d09bb          	addw	s3,s10,s3
    8000527c:	1f74f763          	bgeu	s1,s7,8000546a <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80005280:	02049593          	slli	a1,s1,0x20
    80005284:	9181                	srli	a1,a1,0x20
    80005286:	95e2                	add	a1,a1,s8
    80005288:	855a                	mv	a0,s6
    8000528a:	ffffc097          	auipc	ra,0xffffc
    8000528e:	fe2080e7          	jalr	-30(ra) # 8000126c <walkaddr>
    80005292:	862a                	mv	a2,a0
    if(pa == 0)
    80005294:	dd45                	beqz	a0,8000524c <exec+0xfe>
      n = PGSIZE;
    80005296:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005298:	fd49f2e3          	bgeu	s3,s4,8000525c <exec+0x10e>
      n = sz - i;
    8000529c:	894e                	mv	s2,s3
    8000529e:	bf7d                	j	8000525c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052a0:	4901                	li	s2,0
  iunlockput(ip);
    800052a2:	8556                	mv	a0,s5
    800052a4:	fffff097          	auipc	ra,0xfffff
    800052a8:	c04080e7          	jalr	-1020(ra) # 80003ea8 <iunlockput>
  end_op();
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	3dc080e7          	jalr	988(ra) # 80004688 <end_op>
  p = myproc();
    800052b4:	ffffd097          	auipc	ra,0xffffd
    800052b8:	a42080e7          	jalr	-1470(ra) # 80001cf6 <myproc>
    800052bc:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800052be:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800052c2:	6785                	lui	a5,0x1
    800052c4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800052c6:	993e                	add	s2,s2,a5
    800052c8:	77fd                	lui	a5,0xfffff
    800052ca:	00f977b3          	and	a5,s2,a5
    800052ce:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800052d2:	4691                	li	a3,4
    800052d4:	6609                	lui	a2,0x2
    800052d6:	963e                	add	a2,a2,a5
    800052d8:	85be                	mv	a1,a5
    800052da:	855a                	mv	a0,s6
    800052dc:	ffffc097          	auipc	ra,0xffffc
    800052e0:	344080e7          	jalr	836(ra) # 80001620 <uvmalloc>
    800052e4:	8c2a                	mv	s8,a0
  ip = 0;
    800052e6:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800052e8:	12050e63          	beqz	a0,80005424 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800052ec:	75f9                	lui	a1,0xffffe
    800052ee:	95aa                	add	a1,a1,a0
    800052f0:	855a                	mv	a0,s6
    800052f2:	ffffc097          	auipc	ra,0xffffc
    800052f6:	67a080e7          	jalr	1658(ra) # 8000196c <uvmclear>
  stackbase = sp - PGSIZE;
    800052fa:	7afd                	lui	s5,0xfffff
    800052fc:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800052fe:	df043783          	ld	a5,-528(s0)
    80005302:	6388                	ld	a0,0(a5)
    80005304:	c925                	beqz	a0,80005374 <exec+0x226>
    80005306:	e9040993          	addi	s3,s0,-368
    8000530a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000530e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005310:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005312:	ffffc097          	auipc	ra,0xffffc
    80005316:	d4c080e7          	jalr	-692(ra) # 8000105e <strlen>
    8000531a:	0015079b          	addiw	a5,a0,1
    8000531e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005322:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005326:	13596663          	bltu	s2,s5,80005452 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000532a:	df043d83          	ld	s11,-528(s0)
    8000532e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005332:	8552                	mv	a0,s4
    80005334:	ffffc097          	auipc	ra,0xffffc
    80005338:	d2a080e7          	jalr	-726(ra) # 8000105e <strlen>
    8000533c:	0015069b          	addiw	a3,a0,1
    80005340:	8652                	mv	a2,s4
    80005342:	85ca                	mv	a1,s2
    80005344:	855a                	mv	a0,s6
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	658080e7          	jalr	1624(ra) # 8000199e <copyout>
    8000534e:	10054663          	bltz	a0,8000545a <exec+0x30c>
    ustack[argc] = sp;
    80005352:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005356:	0485                	addi	s1,s1,1
    80005358:	008d8793          	addi	a5,s11,8
    8000535c:	def43823          	sd	a5,-528(s0)
    80005360:	008db503          	ld	a0,8(s11)
    80005364:	c911                	beqz	a0,80005378 <exec+0x22a>
    if(argc >= MAXARG)
    80005366:	09a1                	addi	s3,s3,8
    80005368:	fb3c95e3          	bne	s9,s3,80005312 <exec+0x1c4>
  sz = sz1;
    8000536c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005370:	4a81                	li	s5,0
    80005372:	a84d                	j	80005424 <exec+0x2d6>
  sp = sz;
    80005374:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005376:	4481                	li	s1,0
  ustack[argc] = 0;
    80005378:	00349793          	slli	a5,s1,0x3
    8000537c:	f9040713          	addi	a4,s0,-112
    80005380:	97ba                	add	a5,a5,a4
    80005382:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7fdbccd8>
  sp -= (argc+1) * sizeof(uint64);
    80005386:	00148693          	addi	a3,s1,1
    8000538a:	068e                	slli	a3,a3,0x3
    8000538c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005390:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005394:	01597663          	bgeu	s2,s5,800053a0 <exec+0x252>
  sz = sz1;
    80005398:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000539c:	4a81                	li	s5,0
    8000539e:	a059                	j	80005424 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800053a0:	e9040613          	addi	a2,s0,-368
    800053a4:	85ca                	mv	a1,s2
    800053a6:	855a                	mv	a0,s6
    800053a8:	ffffc097          	auipc	ra,0xffffc
    800053ac:	5f6080e7          	jalr	1526(ra) # 8000199e <copyout>
    800053b0:	0a054963          	bltz	a0,80005462 <exec+0x314>
  p->trapframe->a1 = sp;
    800053b4:	058bb783          	ld	a5,88(s7)
    800053b8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800053bc:	de843783          	ld	a5,-536(s0)
    800053c0:	0007c703          	lbu	a4,0(a5)
    800053c4:	cf11                	beqz	a4,800053e0 <exec+0x292>
    800053c6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800053c8:	02f00693          	li	a3,47
    800053cc:	a039                	j	800053da <exec+0x28c>
      last = s+1;
    800053ce:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800053d2:	0785                	addi	a5,a5,1
    800053d4:	fff7c703          	lbu	a4,-1(a5)
    800053d8:	c701                	beqz	a4,800053e0 <exec+0x292>
    if(*s == '/')
    800053da:	fed71ce3          	bne	a4,a3,800053d2 <exec+0x284>
    800053de:	bfc5                	j	800053ce <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800053e0:	4641                	li	a2,16
    800053e2:	de843583          	ld	a1,-536(s0)
    800053e6:	158b8513          	addi	a0,s7,344
    800053ea:	ffffc097          	auipc	ra,0xffffc
    800053ee:	c42080e7          	jalr	-958(ra) # 8000102c <safestrcpy>
  oldpagetable = p->pagetable;
    800053f2:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800053f6:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800053fa:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800053fe:	058bb783          	ld	a5,88(s7)
    80005402:	e6843703          	ld	a4,-408(s0)
    80005406:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005408:	058bb783          	ld	a5,88(s7)
    8000540c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005410:	85ea                	mv	a1,s10
    80005412:	ffffd097          	auipc	ra,0xffffd
    80005416:	a44080e7          	jalr	-1468(ra) # 80001e56 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000541a:	0004851b          	sext.w	a0,s1
    8000541e:	b3f1                	j	800051ea <exec+0x9c>
    80005420:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005424:	df843583          	ld	a1,-520(s0)
    80005428:	855a                	mv	a0,s6
    8000542a:	ffffd097          	auipc	ra,0xffffd
    8000542e:	a2c080e7          	jalr	-1492(ra) # 80001e56 <proc_freepagetable>
  if(ip){
    80005432:	da0a92e3          	bnez	s5,800051d6 <exec+0x88>
  return -1;
    80005436:	557d                	li	a0,-1
    80005438:	bb4d                	j	800051ea <exec+0x9c>
    8000543a:	df243c23          	sd	s2,-520(s0)
    8000543e:	b7dd                	j	80005424 <exec+0x2d6>
    80005440:	df243c23          	sd	s2,-520(s0)
    80005444:	b7c5                	j	80005424 <exec+0x2d6>
    80005446:	df243c23          	sd	s2,-520(s0)
    8000544a:	bfe9                	j	80005424 <exec+0x2d6>
    8000544c:	df243c23          	sd	s2,-520(s0)
    80005450:	bfd1                	j	80005424 <exec+0x2d6>
  sz = sz1;
    80005452:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005456:	4a81                	li	s5,0
    80005458:	b7f1                	j	80005424 <exec+0x2d6>
  sz = sz1;
    8000545a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000545e:	4a81                	li	s5,0
    80005460:	b7d1                	j	80005424 <exec+0x2d6>
  sz = sz1;
    80005462:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005466:	4a81                	li	s5,0
    80005468:	bf75                	j	80005424 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000546a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000546e:	e0843783          	ld	a5,-504(s0)
    80005472:	0017869b          	addiw	a3,a5,1
    80005476:	e0d43423          	sd	a3,-504(s0)
    8000547a:	e0043783          	ld	a5,-512(s0)
    8000547e:	0387879b          	addiw	a5,a5,56
    80005482:	e8845703          	lhu	a4,-376(s0)
    80005486:	e0e6dee3          	bge	a3,a4,800052a2 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000548a:	2781                	sext.w	a5,a5
    8000548c:	e0f43023          	sd	a5,-512(s0)
    80005490:	03800713          	li	a4,56
    80005494:	86be                	mv	a3,a5
    80005496:	e1840613          	addi	a2,s0,-488
    8000549a:	4581                	li	a1,0
    8000549c:	8556                	mv	a0,s5
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	a5c080e7          	jalr	-1444(ra) # 80003efa <readi>
    800054a6:	03800793          	li	a5,56
    800054aa:	f6f51be3          	bne	a0,a5,80005420 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800054ae:	e1842783          	lw	a5,-488(s0)
    800054b2:	4705                	li	a4,1
    800054b4:	fae79de3          	bne	a5,a4,8000546e <exec+0x320>
    if(ph.memsz < ph.filesz)
    800054b8:	e4043483          	ld	s1,-448(s0)
    800054bc:	e3843783          	ld	a5,-456(s0)
    800054c0:	f6f4ede3          	bltu	s1,a5,8000543a <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800054c4:	e2843783          	ld	a5,-472(s0)
    800054c8:	94be                	add	s1,s1,a5
    800054ca:	f6f4ebe3          	bltu	s1,a5,80005440 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800054ce:	de043703          	ld	a4,-544(s0)
    800054d2:	8ff9                	and	a5,a5,a4
    800054d4:	fbad                	bnez	a5,80005446 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800054d6:	e1c42503          	lw	a0,-484(s0)
    800054da:	00000097          	auipc	ra,0x0
    800054de:	c58080e7          	jalr	-936(ra) # 80005132 <flags2perm>
    800054e2:	86aa                	mv	a3,a0
    800054e4:	8626                	mv	a2,s1
    800054e6:	85ca                	mv	a1,s2
    800054e8:	855a                	mv	a0,s6
    800054ea:	ffffc097          	auipc	ra,0xffffc
    800054ee:	136080e7          	jalr	310(ra) # 80001620 <uvmalloc>
    800054f2:	dea43c23          	sd	a0,-520(s0)
    800054f6:	d939                	beqz	a0,8000544c <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800054f8:	e2843c03          	ld	s8,-472(s0)
    800054fc:	e2042c83          	lw	s9,-480(s0)
    80005500:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005504:	f60b83e3          	beqz	s7,8000546a <exec+0x31c>
    80005508:	89de                	mv	s3,s7
    8000550a:	4481                	li	s1,0
    8000550c:	bb95                	j	80005280 <exec+0x132>

000000008000550e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000550e:	7179                	addi	sp,sp,-48
    80005510:	f406                	sd	ra,40(sp)
    80005512:	f022                	sd	s0,32(sp)
    80005514:	ec26                	sd	s1,24(sp)
    80005516:	e84a                	sd	s2,16(sp)
    80005518:	1800                	addi	s0,sp,48
    8000551a:	892e                	mv	s2,a1
    8000551c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000551e:	fdc40593          	addi	a1,s0,-36
    80005522:	ffffe097          	auipc	ra,0xffffe
    80005526:	b1c080e7          	jalr	-1252(ra) # 8000303e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000552a:	fdc42703          	lw	a4,-36(s0)
    8000552e:	47bd                	li	a5,15
    80005530:	02e7eb63          	bltu	a5,a4,80005566 <argfd+0x58>
    80005534:	ffffc097          	auipc	ra,0xffffc
    80005538:	7c2080e7          	jalr	1986(ra) # 80001cf6 <myproc>
    8000553c:	fdc42703          	lw	a4,-36(s0)
    80005540:	01a70793          	addi	a5,a4,26
    80005544:	078e                	slli	a5,a5,0x3
    80005546:	953e                	add	a0,a0,a5
    80005548:	611c                	ld	a5,0(a0)
    8000554a:	c385                	beqz	a5,8000556a <argfd+0x5c>
    return -1;
  if(pfd)
    8000554c:	00090463          	beqz	s2,80005554 <argfd+0x46>
    *pfd = fd;
    80005550:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005554:	4501                	li	a0,0
  if(pf)
    80005556:	c091                	beqz	s1,8000555a <argfd+0x4c>
    *pf = f;
    80005558:	e09c                	sd	a5,0(s1)
}
    8000555a:	70a2                	ld	ra,40(sp)
    8000555c:	7402                	ld	s0,32(sp)
    8000555e:	64e2                	ld	s1,24(sp)
    80005560:	6942                	ld	s2,16(sp)
    80005562:	6145                	addi	sp,sp,48
    80005564:	8082                	ret
    return -1;
    80005566:	557d                	li	a0,-1
    80005568:	bfcd                	j	8000555a <argfd+0x4c>
    8000556a:	557d                	li	a0,-1
    8000556c:	b7fd                	j	8000555a <argfd+0x4c>

000000008000556e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000556e:	1101                	addi	sp,sp,-32
    80005570:	ec06                	sd	ra,24(sp)
    80005572:	e822                	sd	s0,16(sp)
    80005574:	e426                	sd	s1,8(sp)
    80005576:	1000                	addi	s0,sp,32
    80005578:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000557a:	ffffc097          	auipc	ra,0xffffc
    8000557e:	77c080e7          	jalr	1916(ra) # 80001cf6 <myproc>
    80005582:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005584:	0d050793          	addi	a5,a0,208
    80005588:	4501                	li	a0,0
    8000558a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000558c:	6398                	ld	a4,0(a5)
    8000558e:	cb19                	beqz	a4,800055a4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005590:	2505                	addiw	a0,a0,1
    80005592:	07a1                	addi	a5,a5,8
    80005594:	fed51ce3          	bne	a0,a3,8000558c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005598:	557d                	li	a0,-1
}
    8000559a:	60e2                	ld	ra,24(sp)
    8000559c:	6442                	ld	s0,16(sp)
    8000559e:	64a2                	ld	s1,8(sp)
    800055a0:	6105                	addi	sp,sp,32
    800055a2:	8082                	ret
      p->ofile[fd] = f;
    800055a4:	01a50793          	addi	a5,a0,26
    800055a8:	078e                	slli	a5,a5,0x3
    800055aa:	963e                	add	a2,a2,a5
    800055ac:	e204                	sd	s1,0(a2)
      return fd;
    800055ae:	b7f5                	j	8000559a <fdalloc+0x2c>

00000000800055b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800055b0:	715d                	addi	sp,sp,-80
    800055b2:	e486                	sd	ra,72(sp)
    800055b4:	e0a2                	sd	s0,64(sp)
    800055b6:	fc26                	sd	s1,56(sp)
    800055b8:	f84a                	sd	s2,48(sp)
    800055ba:	f44e                	sd	s3,40(sp)
    800055bc:	f052                	sd	s4,32(sp)
    800055be:	ec56                	sd	s5,24(sp)
    800055c0:	e85a                	sd	s6,16(sp)
    800055c2:	0880                	addi	s0,sp,80
    800055c4:	8b2e                	mv	s6,a1
    800055c6:	89b2                	mv	s3,a2
    800055c8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800055ca:	fb040593          	addi	a1,s0,-80
    800055ce:	fffff097          	auipc	ra,0xfffff
    800055d2:	e3c080e7          	jalr	-452(ra) # 8000440a <nameiparent>
    800055d6:	84aa                	mv	s1,a0
    800055d8:	14050f63          	beqz	a0,80005736 <create+0x186>
    return 0;

  ilock(dp);
    800055dc:	ffffe097          	auipc	ra,0xffffe
    800055e0:	66a080e7          	jalr	1642(ra) # 80003c46 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800055e4:	4601                	li	a2,0
    800055e6:	fb040593          	addi	a1,s0,-80
    800055ea:	8526                	mv	a0,s1
    800055ec:	fffff097          	auipc	ra,0xfffff
    800055f0:	b3e080e7          	jalr	-1218(ra) # 8000412a <dirlookup>
    800055f4:	8aaa                	mv	s5,a0
    800055f6:	c931                	beqz	a0,8000564a <create+0x9a>
    iunlockput(dp);
    800055f8:	8526                	mv	a0,s1
    800055fa:	fffff097          	auipc	ra,0xfffff
    800055fe:	8ae080e7          	jalr	-1874(ra) # 80003ea8 <iunlockput>
    ilock(ip);
    80005602:	8556                	mv	a0,s5
    80005604:	ffffe097          	auipc	ra,0xffffe
    80005608:	642080e7          	jalr	1602(ra) # 80003c46 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000560c:	000b059b          	sext.w	a1,s6
    80005610:	4789                	li	a5,2
    80005612:	02f59563          	bne	a1,a5,8000563c <create+0x8c>
    80005616:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbce1c>
    8000561a:	37f9                	addiw	a5,a5,-2
    8000561c:	17c2                	slli	a5,a5,0x30
    8000561e:	93c1                	srli	a5,a5,0x30
    80005620:	4705                	li	a4,1
    80005622:	00f76d63          	bltu	a4,a5,8000563c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005626:	8556                	mv	a0,s5
    80005628:	60a6                	ld	ra,72(sp)
    8000562a:	6406                	ld	s0,64(sp)
    8000562c:	74e2                	ld	s1,56(sp)
    8000562e:	7942                	ld	s2,48(sp)
    80005630:	79a2                	ld	s3,40(sp)
    80005632:	7a02                	ld	s4,32(sp)
    80005634:	6ae2                	ld	s5,24(sp)
    80005636:	6b42                	ld	s6,16(sp)
    80005638:	6161                	addi	sp,sp,80
    8000563a:	8082                	ret
    iunlockput(ip);
    8000563c:	8556                	mv	a0,s5
    8000563e:	fffff097          	auipc	ra,0xfffff
    80005642:	86a080e7          	jalr	-1942(ra) # 80003ea8 <iunlockput>
    return 0;
    80005646:	4a81                	li	s5,0
    80005648:	bff9                	j	80005626 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000564a:	85da                	mv	a1,s6
    8000564c:	4088                	lw	a0,0(s1)
    8000564e:	ffffe097          	auipc	ra,0xffffe
    80005652:	45c080e7          	jalr	1116(ra) # 80003aaa <ialloc>
    80005656:	8a2a                	mv	s4,a0
    80005658:	c539                	beqz	a0,800056a6 <create+0xf6>
  ilock(ip);
    8000565a:	ffffe097          	auipc	ra,0xffffe
    8000565e:	5ec080e7          	jalr	1516(ra) # 80003c46 <ilock>
  ip->major = major;
    80005662:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005666:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000566a:	4905                	li	s2,1
    8000566c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005670:	8552                	mv	a0,s4
    80005672:	ffffe097          	auipc	ra,0xffffe
    80005676:	50a080e7          	jalr	1290(ra) # 80003b7c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000567a:	000b059b          	sext.w	a1,s6
    8000567e:	03258b63          	beq	a1,s2,800056b4 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005682:	004a2603          	lw	a2,4(s4)
    80005686:	fb040593          	addi	a1,s0,-80
    8000568a:	8526                	mv	a0,s1
    8000568c:	fffff097          	auipc	ra,0xfffff
    80005690:	cae080e7          	jalr	-850(ra) # 8000433a <dirlink>
    80005694:	06054f63          	bltz	a0,80005712 <create+0x162>
  iunlockput(dp);
    80005698:	8526                	mv	a0,s1
    8000569a:	fffff097          	auipc	ra,0xfffff
    8000569e:	80e080e7          	jalr	-2034(ra) # 80003ea8 <iunlockput>
  return ip;
    800056a2:	8ad2                	mv	s5,s4
    800056a4:	b749                	j	80005626 <create+0x76>
    iunlockput(dp);
    800056a6:	8526                	mv	a0,s1
    800056a8:	fffff097          	auipc	ra,0xfffff
    800056ac:	800080e7          	jalr	-2048(ra) # 80003ea8 <iunlockput>
    return 0;
    800056b0:	8ad2                	mv	s5,s4
    800056b2:	bf95                	j	80005626 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056b4:	004a2603          	lw	a2,4(s4)
    800056b8:	00003597          	auipc	a1,0x3
    800056bc:	fe858593          	addi	a1,a1,-24 # 800086a0 <etext+0x6a0>
    800056c0:	8552                	mv	a0,s4
    800056c2:	fffff097          	auipc	ra,0xfffff
    800056c6:	c78080e7          	jalr	-904(ra) # 8000433a <dirlink>
    800056ca:	04054463          	bltz	a0,80005712 <create+0x162>
    800056ce:	40d0                	lw	a2,4(s1)
    800056d0:	00003597          	auipc	a1,0x3
    800056d4:	fd858593          	addi	a1,a1,-40 # 800086a8 <etext+0x6a8>
    800056d8:	8552                	mv	a0,s4
    800056da:	fffff097          	auipc	ra,0xfffff
    800056de:	c60080e7          	jalr	-928(ra) # 8000433a <dirlink>
    800056e2:	02054863          	bltz	a0,80005712 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800056e6:	004a2603          	lw	a2,4(s4)
    800056ea:	fb040593          	addi	a1,s0,-80
    800056ee:	8526                	mv	a0,s1
    800056f0:	fffff097          	auipc	ra,0xfffff
    800056f4:	c4a080e7          	jalr	-950(ra) # 8000433a <dirlink>
    800056f8:	00054d63          	bltz	a0,80005712 <create+0x162>
    dp->nlink++;  // for ".."
    800056fc:	04a4d783          	lhu	a5,74(s1)
    80005700:	2785                	addiw	a5,a5,1
    80005702:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005706:	8526                	mv	a0,s1
    80005708:	ffffe097          	auipc	ra,0xffffe
    8000570c:	474080e7          	jalr	1140(ra) # 80003b7c <iupdate>
    80005710:	b761                	j	80005698 <create+0xe8>
  ip->nlink = 0;
    80005712:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005716:	8552                	mv	a0,s4
    80005718:	ffffe097          	auipc	ra,0xffffe
    8000571c:	464080e7          	jalr	1124(ra) # 80003b7c <iupdate>
  iunlockput(ip);
    80005720:	8552                	mv	a0,s4
    80005722:	ffffe097          	auipc	ra,0xffffe
    80005726:	786080e7          	jalr	1926(ra) # 80003ea8 <iunlockput>
  iunlockput(dp);
    8000572a:	8526                	mv	a0,s1
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	77c080e7          	jalr	1916(ra) # 80003ea8 <iunlockput>
  return 0;
    80005734:	bdcd                	j	80005626 <create+0x76>
    return 0;
    80005736:	8aaa                	mv	s5,a0
    80005738:	b5fd                	j	80005626 <create+0x76>

000000008000573a <sys_dup>:
{
    8000573a:	7179                	addi	sp,sp,-48
    8000573c:	f406                	sd	ra,40(sp)
    8000573e:	f022                	sd	s0,32(sp)
    80005740:	ec26                	sd	s1,24(sp)
    80005742:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005744:	fd840613          	addi	a2,s0,-40
    80005748:	4581                	li	a1,0
    8000574a:	4501                	li	a0,0
    8000574c:	00000097          	auipc	ra,0x0
    80005750:	dc2080e7          	jalr	-574(ra) # 8000550e <argfd>
    return -1;
    80005754:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005756:	02054363          	bltz	a0,8000577c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000575a:	fd843503          	ld	a0,-40(s0)
    8000575e:	00000097          	auipc	ra,0x0
    80005762:	e10080e7          	jalr	-496(ra) # 8000556e <fdalloc>
    80005766:	84aa                	mv	s1,a0
    return -1;
    80005768:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000576a:	00054963          	bltz	a0,8000577c <sys_dup+0x42>
  filedup(f);
    8000576e:	fd843503          	ld	a0,-40(s0)
    80005772:	fffff097          	auipc	ra,0xfffff
    80005776:	310080e7          	jalr	784(ra) # 80004a82 <filedup>
  return fd;
    8000577a:	87a6                	mv	a5,s1
}
    8000577c:	853e                	mv	a0,a5
    8000577e:	70a2                	ld	ra,40(sp)
    80005780:	7402                	ld	s0,32(sp)
    80005782:	64e2                	ld	s1,24(sp)
    80005784:	6145                	addi	sp,sp,48
    80005786:	8082                	ret

0000000080005788 <sys_read>:
{
    80005788:	7179                	addi	sp,sp,-48
    8000578a:	f406                	sd	ra,40(sp)
    8000578c:	f022                	sd	s0,32(sp)
    8000578e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005790:	fd840593          	addi	a1,s0,-40
    80005794:	4505                	li	a0,1
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	8c8080e7          	jalr	-1848(ra) # 8000305e <argaddr>
  argint(2, &n);
    8000579e:	fe440593          	addi	a1,s0,-28
    800057a2:	4509                	li	a0,2
    800057a4:	ffffe097          	auipc	ra,0xffffe
    800057a8:	89a080e7          	jalr	-1894(ra) # 8000303e <argint>
  if(argfd(0, 0, &f) < 0)
    800057ac:	fe840613          	addi	a2,s0,-24
    800057b0:	4581                	li	a1,0
    800057b2:	4501                	li	a0,0
    800057b4:	00000097          	auipc	ra,0x0
    800057b8:	d5a080e7          	jalr	-678(ra) # 8000550e <argfd>
    800057bc:	87aa                	mv	a5,a0
    return -1;
    800057be:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800057c0:	0007cc63          	bltz	a5,800057d8 <sys_read+0x50>
  return fileread(f, p, n);
    800057c4:	fe442603          	lw	a2,-28(s0)
    800057c8:	fd843583          	ld	a1,-40(s0)
    800057cc:	fe843503          	ld	a0,-24(s0)
    800057d0:	fffff097          	auipc	ra,0xfffff
    800057d4:	43e080e7          	jalr	1086(ra) # 80004c0e <fileread>
}
    800057d8:	70a2                	ld	ra,40(sp)
    800057da:	7402                	ld	s0,32(sp)
    800057dc:	6145                	addi	sp,sp,48
    800057de:	8082                	ret

00000000800057e0 <sys_write>:
{
    800057e0:	7179                	addi	sp,sp,-48
    800057e2:	f406                	sd	ra,40(sp)
    800057e4:	f022                	sd	s0,32(sp)
    800057e6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057e8:	fd840593          	addi	a1,s0,-40
    800057ec:	4505                	li	a0,1
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	870080e7          	jalr	-1936(ra) # 8000305e <argaddr>
  argint(2, &n);
    800057f6:	fe440593          	addi	a1,s0,-28
    800057fa:	4509                	li	a0,2
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	842080e7          	jalr	-1982(ra) # 8000303e <argint>
  if(argfd(0, 0, &f) < 0)
    80005804:	fe840613          	addi	a2,s0,-24
    80005808:	4581                	li	a1,0
    8000580a:	4501                	li	a0,0
    8000580c:	00000097          	auipc	ra,0x0
    80005810:	d02080e7          	jalr	-766(ra) # 8000550e <argfd>
    80005814:	87aa                	mv	a5,a0
    return -1;
    80005816:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005818:	0007cc63          	bltz	a5,80005830 <sys_write+0x50>
  return filewrite(f, p, n);
    8000581c:	fe442603          	lw	a2,-28(s0)
    80005820:	fd843583          	ld	a1,-40(s0)
    80005824:	fe843503          	ld	a0,-24(s0)
    80005828:	fffff097          	auipc	ra,0xfffff
    8000582c:	4a8080e7          	jalr	1192(ra) # 80004cd0 <filewrite>
}
    80005830:	70a2                	ld	ra,40(sp)
    80005832:	7402                	ld	s0,32(sp)
    80005834:	6145                	addi	sp,sp,48
    80005836:	8082                	ret

0000000080005838 <sys_close>:
{
    80005838:	1101                	addi	sp,sp,-32
    8000583a:	ec06                	sd	ra,24(sp)
    8000583c:	e822                	sd	s0,16(sp)
    8000583e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005840:	fe040613          	addi	a2,s0,-32
    80005844:	fec40593          	addi	a1,s0,-20
    80005848:	4501                	li	a0,0
    8000584a:	00000097          	auipc	ra,0x0
    8000584e:	cc4080e7          	jalr	-828(ra) # 8000550e <argfd>
    return -1;
    80005852:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005854:	02054463          	bltz	a0,8000587c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005858:	ffffc097          	auipc	ra,0xffffc
    8000585c:	49e080e7          	jalr	1182(ra) # 80001cf6 <myproc>
    80005860:	fec42783          	lw	a5,-20(s0)
    80005864:	07e9                	addi	a5,a5,26
    80005866:	078e                	slli	a5,a5,0x3
    80005868:	97aa                	add	a5,a5,a0
    8000586a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000586e:	fe043503          	ld	a0,-32(s0)
    80005872:	fffff097          	auipc	ra,0xfffff
    80005876:	262080e7          	jalr	610(ra) # 80004ad4 <fileclose>
  return 0;
    8000587a:	4781                	li	a5,0
}
    8000587c:	853e                	mv	a0,a5
    8000587e:	60e2                	ld	ra,24(sp)
    80005880:	6442                	ld	s0,16(sp)
    80005882:	6105                	addi	sp,sp,32
    80005884:	8082                	ret

0000000080005886 <sys_fstat>:
{
    80005886:	1101                	addi	sp,sp,-32
    80005888:	ec06                	sd	ra,24(sp)
    8000588a:	e822                	sd	s0,16(sp)
    8000588c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000588e:	fe040593          	addi	a1,s0,-32
    80005892:	4505                	li	a0,1
    80005894:	ffffd097          	auipc	ra,0xffffd
    80005898:	7ca080e7          	jalr	1994(ra) # 8000305e <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000589c:	fe840613          	addi	a2,s0,-24
    800058a0:	4581                	li	a1,0
    800058a2:	4501                	li	a0,0
    800058a4:	00000097          	auipc	ra,0x0
    800058a8:	c6a080e7          	jalr	-918(ra) # 8000550e <argfd>
    800058ac:	87aa                	mv	a5,a0
    return -1;
    800058ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058b0:	0007ca63          	bltz	a5,800058c4 <sys_fstat+0x3e>
  return filestat(f, st);
    800058b4:	fe043583          	ld	a1,-32(s0)
    800058b8:	fe843503          	ld	a0,-24(s0)
    800058bc:	fffff097          	auipc	ra,0xfffff
    800058c0:	2e0080e7          	jalr	736(ra) # 80004b9c <filestat>
}
    800058c4:	60e2                	ld	ra,24(sp)
    800058c6:	6442                	ld	s0,16(sp)
    800058c8:	6105                	addi	sp,sp,32
    800058ca:	8082                	ret

00000000800058cc <sys_link>:
{
    800058cc:	7169                	addi	sp,sp,-304
    800058ce:	f606                	sd	ra,296(sp)
    800058d0:	f222                	sd	s0,288(sp)
    800058d2:	ee26                	sd	s1,280(sp)
    800058d4:	ea4a                	sd	s2,272(sp)
    800058d6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058d8:	08000613          	li	a2,128
    800058dc:	ed040593          	addi	a1,s0,-304
    800058e0:	4501                	li	a0,0
    800058e2:	ffffd097          	auipc	ra,0xffffd
    800058e6:	79c080e7          	jalr	1948(ra) # 8000307e <argstr>
    return -1;
    800058ea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058ec:	10054e63          	bltz	a0,80005a08 <sys_link+0x13c>
    800058f0:	08000613          	li	a2,128
    800058f4:	f5040593          	addi	a1,s0,-176
    800058f8:	4505                	li	a0,1
    800058fa:	ffffd097          	auipc	ra,0xffffd
    800058fe:	784080e7          	jalr	1924(ra) # 8000307e <argstr>
    return -1;
    80005902:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005904:	10054263          	bltz	a0,80005a08 <sys_link+0x13c>
  begin_op();
    80005908:	fffff097          	auipc	ra,0xfffff
    8000590c:	d00080e7          	jalr	-768(ra) # 80004608 <begin_op>
  if((ip = namei(old)) == 0){
    80005910:	ed040513          	addi	a0,s0,-304
    80005914:	fffff097          	auipc	ra,0xfffff
    80005918:	ad8080e7          	jalr	-1320(ra) # 800043ec <namei>
    8000591c:	84aa                	mv	s1,a0
    8000591e:	c551                	beqz	a0,800059aa <sys_link+0xde>
  ilock(ip);
    80005920:	ffffe097          	auipc	ra,0xffffe
    80005924:	326080e7          	jalr	806(ra) # 80003c46 <ilock>
  if(ip->type == T_DIR){
    80005928:	04449703          	lh	a4,68(s1)
    8000592c:	4785                	li	a5,1
    8000592e:	08f70463          	beq	a4,a5,800059b6 <sys_link+0xea>
  ip->nlink++;
    80005932:	04a4d783          	lhu	a5,74(s1)
    80005936:	2785                	addiw	a5,a5,1
    80005938:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000593c:	8526                	mv	a0,s1
    8000593e:	ffffe097          	auipc	ra,0xffffe
    80005942:	23e080e7          	jalr	574(ra) # 80003b7c <iupdate>
  iunlock(ip);
    80005946:	8526                	mv	a0,s1
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	3c0080e7          	jalr	960(ra) # 80003d08 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005950:	fd040593          	addi	a1,s0,-48
    80005954:	f5040513          	addi	a0,s0,-176
    80005958:	fffff097          	auipc	ra,0xfffff
    8000595c:	ab2080e7          	jalr	-1358(ra) # 8000440a <nameiparent>
    80005960:	892a                	mv	s2,a0
    80005962:	c935                	beqz	a0,800059d6 <sys_link+0x10a>
  ilock(dp);
    80005964:	ffffe097          	auipc	ra,0xffffe
    80005968:	2e2080e7          	jalr	738(ra) # 80003c46 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000596c:	00092703          	lw	a4,0(s2)
    80005970:	409c                	lw	a5,0(s1)
    80005972:	04f71d63          	bne	a4,a5,800059cc <sys_link+0x100>
    80005976:	40d0                	lw	a2,4(s1)
    80005978:	fd040593          	addi	a1,s0,-48
    8000597c:	854a                	mv	a0,s2
    8000597e:	fffff097          	auipc	ra,0xfffff
    80005982:	9bc080e7          	jalr	-1604(ra) # 8000433a <dirlink>
    80005986:	04054363          	bltz	a0,800059cc <sys_link+0x100>
  iunlockput(dp);
    8000598a:	854a                	mv	a0,s2
    8000598c:	ffffe097          	auipc	ra,0xffffe
    80005990:	51c080e7          	jalr	1308(ra) # 80003ea8 <iunlockput>
  iput(ip);
    80005994:	8526                	mv	a0,s1
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	46a080e7          	jalr	1130(ra) # 80003e00 <iput>
  end_op();
    8000599e:	fffff097          	auipc	ra,0xfffff
    800059a2:	cea080e7          	jalr	-790(ra) # 80004688 <end_op>
  return 0;
    800059a6:	4781                	li	a5,0
    800059a8:	a085                	j	80005a08 <sys_link+0x13c>
    end_op();
    800059aa:	fffff097          	auipc	ra,0xfffff
    800059ae:	cde080e7          	jalr	-802(ra) # 80004688 <end_op>
    return -1;
    800059b2:	57fd                	li	a5,-1
    800059b4:	a891                	j	80005a08 <sys_link+0x13c>
    iunlockput(ip);
    800059b6:	8526                	mv	a0,s1
    800059b8:	ffffe097          	auipc	ra,0xffffe
    800059bc:	4f0080e7          	jalr	1264(ra) # 80003ea8 <iunlockput>
    end_op();
    800059c0:	fffff097          	auipc	ra,0xfffff
    800059c4:	cc8080e7          	jalr	-824(ra) # 80004688 <end_op>
    return -1;
    800059c8:	57fd                	li	a5,-1
    800059ca:	a83d                	j	80005a08 <sys_link+0x13c>
    iunlockput(dp);
    800059cc:	854a                	mv	a0,s2
    800059ce:	ffffe097          	auipc	ra,0xffffe
    800059d2:	4da080e7          	jalr	1242(ra) # 80003ea8 <iunlockput>
  ilock(ip);
    800059d6:	8526                	mv	a0,s1
    800059d8:	ffffe097          	auipc	ra,0xffffe
    800059dc:	26e080e7          	jalr	622(ra) # 80003c46 <ilock>
  ip->nlink--;
    800059e0:	04a4d783          	lhu	a5,74(s1)
    800059e4:	37fd                	addiw	a5,a5,-1
    800059e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059ea:	8526                	mv	a0,s1
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	190080e7          	jalr	400(ra) # 80003b7c <iupdate>
  iunlockput(ip);
    800059f4:	8526                	mv	a0,s1
    800059f6:	ffffe097          	auipc	ra,0xffffe
    800059fa:	4b2080e7          	jalr	1202(ra) # 80003ea8 <iunlockput>
  end_op();
    800059fe:	fffff097          	auipc	ra,0xfffff
    80005a02:	c8a080e7          	jalr	-886(ra) # 80004688 <end_op>
  return -1;
    80005a06:	57fd                	li	a5,-1
}
    80005a08:	853e                	mv	a0,a5
    80005a0a:	70b2                	ld	ra,296(sp)
    80005a0c:	7412                	ld	s0,288(sp)
    80005a0e:	64f2                	ld	s1,280(sp)
    80005a10:	6952                	ld	s2,272(sp)
    80005a12:	6155                	addi	sp,sp,304
    80005a14:	8082                	ret

0000000080005a16 <sys_unlink>:
{
    80005a16:	7151                	addi	sp,sp,-240
    80005a18:	f586                	sd	ra,232(sp)
    80005a1a:	f1a2                	sd	s0,224(sp)
    80005a1c:	eda6                	sd	s1,216(sp)
    80005a1e:	e9ca                	sd	s2,208(sp)
    80005a20:	e5ce                	sd	s3,200(sp)
    80005a22:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a24:	08000613          	li	a2,128
    80005a28:	f3040593          	addi	a1,s0,-208
    80005a2c:	4501                	li	a0,0
    80005a2e:	ffffd097          	auipc	ra,0xffffd
    80005a32:	650080e7          	jalr	1616(ra) # 8000307e <argstr>
    80005a36:	18054163          	bltz	a0,80005bb8 <sys_unlink+0x1a2>
  begin_op();
    80005a3a:	fffff097          	auipc	ra,0xfffff
    80005a3e:	bce080e7          	jalr	-1074(ra) # 80004608 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a42:	fb040593          	addi	a1,s0,-80
    80005a46:	f3040513          	addi	a0,s0,-208
    80005a4a:	fffff097          	auipc	ra,0xfffff
    80005a4e:	9c0080e7          	jalr	-1600(ra) # 8000440a <nameiparent>
    80005a52:	84aa                	mv	s1,a0
    80005a54:	c979                	beqz	a0,80005b2a <sys_unlink+0x114>
  ilock(dp);
    80005a56:	ffffe097          	auipc	ra,0xffffe
    80005a5a:	1f0080e7          	jalr	496(ra) # 80003c46 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005a5e:	00003597          	auipc	a1,0x3
    80005a62:	c4258593          	addi	a1,a1,-958 # 800086a0 <etext+0x6a0>
    80005a66:	fb040513          	addi	a0,s0,-80
    80005a6a:	ffffe097          	auipc	ra,0xffffe
    80005a6e:	6a6080e7          	jalr	1702(ra) # 80004110 <namecmp>
    80005a72:	14050a63          	beqz	a0,80005bc6 <sys_unlink+0x1b0>
    80005a76:	00003597          	auipc	a1,0x3
    80005a7a:	c3258593          	addi	a1,a1,-974 # 800086a8 <etext+0x6a8>
    80005a7e:	fb040513          	addi	a0,s0,-80
    80005a82:	ffffe097          	auipc	ra,0xffffe
    80005a86:	68e080e7          	jalr	1678(ra) # 80004110 <namecmp>
    80005a8a:	12050e63          	beqz	a0,80005bc6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005a8e:	f2c40613          	addi	a2,s0,-212
    80005a92:	fb040593          	addi	a1,s0,-80
    80005a96:	8526                	mv	a0,s1
    80005a98:	ffffe097          	auipc	ra,0xffffe
    80005a9c:	692080e7          	jalr	1682(ra) # 8000412a <dirlookup>
    80005aa0:	892a                	mv	s2,a0
    80005aa2:	12050263          	beqz	a0,80005bc6 <sys_unlink+0x1b0>
  ilock(ip);
    80005aa6:	ffffe097          	auipc	ra,0xffffe
    80005aaa:	1a0080e7          	jalr	416(ra) # 80003c46 <ilock>
  if(ip->nlink < 1)
    80005aae:	04a91783          	lh	a5,74(s2)
    80005ab2:	08f05263          	blez	a5,80005b36 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005ab6:	04491703          	lh	a4,68(s2)
    80005aba:	4785                	li	a5,1
    80005abc:	08f70563          	beq	a4,a5,80005b46 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005ac0:	4641                	li	a2,16
    80005ac2:	4581                	li	a1,0
    80005ac4:	fc040513          	addi	a0,s0,-64
    80005ac8:	ffffb097          	auipc	ra,0xffffb
    80005acc:	41a080e7          	jalr	1050(ra) # 80000ee2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ad0:	4741                	li	a4,16
    80005ad2:	f2c42683          	lw	a3,-212(s0)
    80005ad6:	fc040613          	addi	a2,s0,-64
    80005ada:	4581                	li	a1,0
    80005adc:	8526                	mv	a0,s1
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	514080e7          	jalr	1300(ra) # 80003ff2 <writei>
    80005ae6:	47c1                	li	a5,16
    80005ae8:	0af51563          	bne	a0,a5,80005b92 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005aec:	04491703          	lh	a4,68(s2)
    80005af0:	4785                	li	a5,1
    80005af2:	0af70863          	beq	a4,a5,80005ba2 <sys_unlink+0x18c>
  iunlockput(dp);
    80005af6:	8526                	mv	a0,s1
    80005af8:	ffffe097          	auipc	ra,0xffffe
    80005afc:	3b0080e7          	jalr	944(ra) # 80003ea8 <iunlockput>
  ip->nlink--;
    80005b00:	04a95783          	lhu	a5,74(s2)
    80005b04:	37fd                	addiw	a5,a5,-1
    80005b06:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b0a:	854a                	mv	a0,s2
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	070080e7          	jalr	112(ra) # 80003b7c <iupdate>
  iunlockput(ip);
    80005b14:	854a                	mv	a0,s2
    80005b16:	ffffe097          	auipc	ra,0xffffe
    80005b1a:	392080e7          	jalr	914(ra) # 80003ea8 <iunlockput>
  end_op();
    80005b1e:	fffff097          	auipc	ra,0xfffff
    80005b22:	b6a080e7          	jalr	-1174(ra) # 80004688 <end_op>
  return 0;
    80005b26:	4501                	li	a0,0
    80005b28:	a84d                	j	80005bda <sys_unlink+0x1c4>
    end_op();
    80005b2a:	fffff097          	auipc	ra,0xfffff
    80005b2e:	b5e080e7          	jalr	-1186(ra) # 80004688 <end_op>
    return -1;
    80005b32:	557d                	li	a0,-1
    80005b34:	a05d                	j	80005bda <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005b36:	00003517          	auipc	a0,0x3
    80005b3a:	b7a50513          	addi	a0,a0,-1158 # 800086b0 <etext+0x6b0>
    80005b3e:	ffffb097          	auipc	ra,0xffffb
    80005b42:	a00080e7          	jalr	-1536(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b46:	04c92703          	lw	a4,76(s2)
    80005b4a:	02000793          	li	a5,32
    80005b4e:	f6e7f9e3          	bgeu	a5,a4,80005ac0 <sys_unlink+0xaa>
    80005b52:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b56:	4741                	li	a4,16
    80005b58:	86ce                	mv	a3,s3
    80005b5a:	f1840613          	addi	a2,s0,-232
    80005b5e:	4581                	li	a1,0
    80005b60:	854a                	mv	a0,s2
    80005b62:	ffffe097          	auipc	ra,0xffffe
    80005b66:	398080e7          	jalr	920(ra) # 80003efa <readi>
    80005b6a:	47c1                	li	a5,16
    80005b6c:	00f51b63          	bne	a0,a5,80005b82 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005b70:	f1845783          	lhu	a5,-232(s0)
    80005b74:	e7a1                	bnez	a5,80005bbc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b76:	29c1                	addiw	s3,s3,16
    80005b78:	04c92783          	lw	a5,76(s2)
    80005b7c:	fcf9ede3          	bltu	s3,a5,80005b56 <sys_unlink+0x140>
    80005b80:	b781                	j	80005ac0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005b82:	00003517          	auipc	a0,0x3
    80005b86:	b4650513          	addi	a0,a0,-1210 # 800086c8 <etext+0x6c8>
    80005b8a:	ffffb097          	auipc	ra,0xffffb
    80005b8e:	9b4080e7          	jalr	-1612(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005b92:	00003517          	auipc	a0,0x3
    80005b96:	b4e50513          	addi	a0,a0,-1202 # 800086e0 <etext+0x6e0>
    80005b9a:	ffffb097          	auipc	ra,0xffffb
    80005b9e:	9a4080e7          	jalr	-1628(ra) # 8000053e <panic>
    dp->nlink--;
    80005ba2:	04a4d783          	lhu	a5,74(s1)
    80005ba6:	37fd                	addiw	a5,a5,-1
    80005ba8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bac:	8526                	mv	a0,s1
    80005bae:	ffffe097          	auipc	ra,0xffffe
    80005bb2:	fce080e7          	jalr	-50(ra) # 80003b7c <iupdate>
    80005bb6:	b781                	j	80005af6 <sys_unlink+0xe0>
    return -1;
    80005bb8:	557d                	li	a0,-1
    80005bba:	a005                	j	80005bda <sys_unlink+0x1c4>
    iunlockput(ip);
    80005bbc:	854a                	mv	a0,s2
    80005bbe:	ffffe097          	auipc	ra,0xffffe
    80005bc2:	2ea080e7          	jalr	746(ra) # 80003ea8 <iunlockput>
  iunlockput(dp);
    80005bc6:	8526                	mv	a0,s1
    80005bc8:	ffffe097          	auipc	ra,0xffffe
    80005bcc:	2e0080e7          	jalr	736(ra) # 80003ea8 <iunlockput>
  end_op();
    80005bd0:	fffff097          	auipc	ra,0xfffff
    80005bd4:	ab8080e7          	jalr	-1352(ra) # 80004688 <end_op>
  return -1;
    80005bd8:	557d                	li	a0,-1
}
    80005bda:	70ae                	ld	ra,232(sp)
    80005bdc:	740e                	ld	s0,224(sp)
    80005bde:	64ee                	ld	s1,216(sp)
    80005be0:	694e                	ld	s2,208(sp)
    80005be2:	69ae                	ld	s3,200(sp)
    80005be4:	616d                	addi	sp,sp,240
    80005be6:	8082                	ret

0000000080005be8 <sys_open>:

uint64
sys_open(void)
{
    80005be8:	7131                	addi	sp,sp,-192
    80005bea:	fd06                	sd	ra,184(sp)
    80005bec:	f922                	sd	s0,176(sp)
    80005bee:	f526                	sd	s1,168(sp)
    80005bf0:	f14a                	sd	s2,160(sp)
    80005bf2:	ed4e                	sd	s3,152(sp)
    80005bf4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005bf6:	f4c40593          	addi	a1,s0,-180
    80005bfa:	4505                	li	a0,1
    80005bfc:	ffffd097          	auipc	ra,0xffffd
    80005c00:	442080e7          	jalr	1090(ra) # 8000303e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c04:	08000613          	li	a2,128
    80005c08:	f5040593          	addi	a1,s0,-176
    80005c0c:	4501                	li	a0,0
    80005c0e:	ffffd097          	auipc	ra,0xffffd
    80005c12:	470080e7          	jalr	1136(ra) # 8000307e <argstr>
    80005c16:	87aa                	mv	a5,a0
    return -1;
    80005c18:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c1a:	0a07c963          	bltz	a5,80005ccc <sys_open+0xe4>

  begin_op();
    80005c1e:	fffff097          	auipc	ra,0xfffff
    80005c22:	9ea080e7          	jalr	-1558(ra) # 80004608 <begin_op>

  if(omode & O_CREATE){
    80005c26:	f4c42783          	lw	a5,-180(s0)
    80005c2a:	2007f793          	andi	a5,a5,512
    80005c2e:	cfc5                	beqz	a5,80005ce6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c30:	4681                	li	a3,0
    80005c32:	4601                	li	a2,0
    80005c34:	4589                	li	a1,2
    80005c36:	f5040513          	addi	a0,s0,-176
    80005c3a:	00000097          	auipc	ra,0x0
    80005c3e:	976080e7          	jalr	-1674(ra) # 800055b0 <create>
    80005c42:	84aa                	mv	s1,a0
    if(ip == 0){
    80005c44:	c959                	beqz	a0,80005cda <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005c46:	04449703          	lh	a4,68(s1)
    80005c4a:	478d                	li	a5,3
    80005c4c:	00f71763          	bne	a4,a5,80005c5a <sys_open+0x72>
    80005c50:	0464d703          	lhu	a4,70(s1)
    80005c54:	47a5                	li	a5,9
    80005c56:	0ce7ed63          	bltu	a5,a4,80005d30 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005c5a:	fffff097          	auipc	ra,0xfffff
    80005c5e:	dbe080e7          	jalr	-578(ra) # 80004a18 <filealloc>
    80005c62:	89aa                	mv	s3,a0
    80005c64:	10050363          	beqz	a0,80005d6a <sys_open+0x182>
    80005c68:	00000097          	auipc	ra,0x0
    80005c6c:	906080e7          	jalr	-1786(ra) # 8000556e <fdalloc>
    80005c70:	892a                	mv	s2,a0
    80005c72:	0e054763          	bltz	a0,80005d60 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005c76:	04449703          	lh	a4,68(s1)
    80005c7a:	478d                	li	a5,3
    80005c7c:	0cf70563          	beq	a4,a5,80005d46 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005c80:	4789                	li	a5,2
    80005c82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005c86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005c8a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005c8e:	f4c42783          	lw	a5,-180(s0)
    80005c92:	0017c713          	xori	a4,a5,1
    80005c96:	8b05                	andi	a4,a4,1
    80005c98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005c9c:	0037f713          	andi	a4,a5,3
    80005ca0:	00e03733          	snez	a4,a4
    80005ca4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ca8:	4007f793          	andi	a5,a5,1024
    80005cac:	c791                	beqz	a5,80005cb8 <sys_open+0xd0>
    80005cae:	04449703          	lh	a4,68(s1)
    80005cb2:	4789                	li	a5,2
    80005cb4:	0af70063          	beq	a4,a5,80005d54 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005cb8:	8526                	mv	a0,s1
    80005cba:	ffffe097          	auipc	ra,0xffffe
    80005cbe:	04e080e7          	jalr	78(ra) # 80003d08 <iunlock>
  end_op();
    80005cc2:	fffff097          	auipc	ra,0xfffff
    80005cc6:	9c6080e7          	jalr	-1594(ra) # 80004688 <end_op>

  return fd;
    80005cca:	854a                	mv	a0,s2
}
    80005ccc:	70ea                	ld	ra,184(sp)
    80005cce:	744a                	ld	s0,176(sp)
    80005cd0:	74aa                	ld	s1,168(sp)
    80005cd2:	790a                	ld	s2,160(sp)
    80005cd4:	69ea                	ld	s3,152(sp)
    80005cd6:	6129                	addi	sp,sp,192
    80005cd8:	8082                	ret
      end_op();
    80005cda:	fffff097          	auipc	ra,0xfffff
    80005cde:	9ae080e7          	jalr	-1618(ra) # 80004688 <end_op>
      return -1;
    80005ce2:	557d                	li	a0,-1
    80005ce4:	b7e5                	j	80005ccc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005ce6:	f5040513          	addi	a0,s0,-176
    80005cea:	ffffe097          	auipc	ra,0xffffe
    80005cee:	702080e7          	jalr	1794(ra) # 800043ec <namei>
    80005cf2:	84aa                	mv	s1,a0
    80005cf4:	c905                	beqz	a0,80005d24 <sys_open+0x13c>
    ilock(ip);
    80005cf6:	ffffe097          	auipc	ra,0xffffe
    80005cfa:	f50080e7          	jalr	-176(ra) # 80003c46 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005cfe:	04449703          	lh	a4,68(s1)
    80005d02:	4785                	li	a5,1
    80005d04:	f4f711e3          	bne	a4,a5,80005c46 <sys_open+0x5e>
    80005d08:	f4c42783          	lw	a5,-180(s0)
    80005d0c:	d7b9                	beqz	a5,80005c5a <sys_open+0x72>
      iunlockput(ip);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	198080e7          	jalr	408(ra) # 80003ea8 <iunlockput>
      end_op();
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	970080e7          	jalr	-1680(ra) # 80004688 <end_op>
      return -1;
    80005d20:	557d                	li	a0,-1
    80005d22:	b76d                	j	80005ccc <sys_open+0xe4>
      end_op();
    80005d24:	fffff097          	auipc	ra,0xfffff
    80005d28:	964080e7          	jalr	-1692(ra) # 80004688 <end_op>
      return -1;
    80005d2c:	557d                	li	a0,-1
    80005d2e:	bf79                	j	80005ccc <sys_open+0xe4>
    iunlockput(ip);
    80005d30:	8526                	mv	a0,s1
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	176080e7          	jalr	374(ra) # 80003ea8 <iunlockput>
    end_op();
    80005d3a:	fffff097          	auipc	ra,0xfffff
    80005d3e:	94e080e7          	jalr	-1714(ra) # 80004688 <end_op>
    return -1;
    80005d42:	557d                	li	a0,-1
    80005d44:	b761                	j	80005ccc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005d46:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005d4a:	04649783          	lh	a5,70(s1)
    80005d4e:	02f99223          	sh	a5,36(s3)
    80005d52:	bf25                	j	80005c8a <sys_open+0xa2>
    itrunc(ip);
    80005d54:	8526                	mv	a0,s1
    80005d56:	ffffe097          	auipc	ra,0xffffe
    80005d5a:	ffe080e7          	jalr	-2(ra) # 80003d54 <itrunc>
    80005d5e:	bfa9                	j	80005cb8 <sys_open+0xd0>
      fileclose(f);
    80005d60:	854e                	mv	a0,s3
    80005d62:	fffff097          	auipc	ra,0xfffff
    80005d66:	d72080e7          	jalr	-654(ra) # 80004ad4 <fileclose>
    iunlockput(ip);
    80005d6a:	8526                	mv	a0,s1
    80005d6c:	ffffe097          	auipc	ra,0xffffe
    80005d70:	13c080e7          	jalr	316(ra) # 80003ea8 <iunlockput>
    end_op();
    80005d74:	fffff097          	auipc	ra,0xfffff
    80005d78:	914080e7          	jalr	-1772(ra) # 80004688 <end_op>
    return -1;
    80005d7c:	557d                	li	a0,-1
    80005d7e:	b7b9                	j	80005ccc <sys_open+0xe4>

0000000080005d80 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005d80:	7175                	addi	sp,sp,-144
    80005d82:	e506                	sd	ra,136(sp)
    80005d84:	e122                	sd	s0,128(sp)
    80005d86:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005d88:	fffff097          	auipc	ra,0xfffff
    80005d8c:	880080e7          	jalr	-1920(ra) # 80004608 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005d90:	08000613          	li	a2,128
    80005d94:	f7040593          	addi	a1,s0,-144
    80005d98:	4501                	li	a0,0
    80005d9a:	ffffd097          	auipc	ra,0xffffd
    80005d9e:	2e4080e7          	jalr	740(ra) # 8000307e <argstr>
    80005da2:	02054963          	bltz	a0,80005dd4 <sys_mkdir+0x54>
    80005da6:	4681                	li	a3,0
    80005da8:	4601                	li	a2,0
    80005daa:	4585                	li	a1,1
    80005dac:	f7040513          	addi	a0,s0,-144
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	800080e7          	jalr	-2048(ra) # 800055b0 <create>
    80005db8:	cd11                	beqz	a0,80005dd4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005dba:	ffffe097          	auipc	ra,0xffffe
    80005dbe:	0ee080e7          	jalr	238(ra) # 80003ea8 <iunlockput>
  end_op();
    80005dc2:	fffff097          	auipc	ra,0xfffff
    80005dc6:	8c6080e7          	jalr	-1850(ra) # 80004688 <end_op>
  return 0;
    80005dca:	4501                	li	a0,0
}
    80005dcc:	60aa                	ld	ra,136(sp)
    80005dce:	640a                	ld	s0,128(sp)
    80005dd0:	6149                	addi	sp,sp,144
    80005dd2:	8082                	ret
    end_op();
    80005dd4:	fffff097          	auipc	ra,0xfffff
    80005dd8:	8b4080e7          	jalr	-1868(ra) # 80004688 <end_op>
    return -1;
    80005ddc:	557d                	li	a0,-1
    80005dde:	b7fd                	j	80005dcc <sys_mkdir+0x4c>

0000000080005de0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005de0:	7135                	addi	sp,sp,-160
    80005de2:	ed06                	sd	ra,152(sp)
    80005de4:	e922                	sd	s0,144(sp)
    80005de6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	820080e7          	jalr	-2016(ra) # 80004608 <begin_op>
  argint(1, &major);
    80005df0:	f6c40593          	addi	a1,s0,-148
    80005df4:	4505                	li	a0,1
    80005df6:	ffffd097          	auipc	ra,0xffffd
    80005dfa:	248080e7          	jalr	584(ra) # 8000303e <argint>
  argint(2, &minor);
    80005dfe:	f6840593          	addi	a1,s0,-152
    80005e02:	4509                	li	a0,2
    80005e04:	ffffd097          	auipc	ra,0xffffd
    80005e08:	23a080e7          	jalr	570(ra) # 8000303e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e0c:	08000613          	li	a2,128
    80005e10:	f7040593          	addi	a1,s0,-144
    80005e14:	4501                	li	a0,0
    80005e16:	ffffd097          	auipc	ra,0xffffd
    80005e1a:	268080e7          	jalr	616(ra) # 8000307e <argstr>
    80005e1e:	02054b63          	bltz	a0,80005e54 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e22:	f6841683          	lh	a3,-152(s0)
    80005e26:	f6c41603          	lh	a2,-148(s0)
    80005e2a:	458d                	li	a1,3
    80005e2c:	f7040513          	addi	a0,s0,-144
    80005e30:	fffff097          	auipc	ra,0xfffff
    80005e34:	780080e7          	jalr	1920(ra) # 800055b0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e38:	cd11                	beqz	a0,80005e54 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e3a:	ffffe097          	auipc	ra,0xffffe
    80005e3e:	06e080e7          	jalr	110(ra) # 80003ea8 <iunlockput>
  end_op();
    80005e42:	fffff097          	auipc	ra,0xfffff
    80005e46:	846080e7          	jalr	-1978(ra) # 80004688 <end_op>
  return 0;
    80005e4a:	4501                	li	a0,0
}
    80005e4c:	60ea                	ld	ra,152(sp)
    80005e4e:	644a                	ld	s0,144(sp)
    80005e50:	610d                	addi	sp,sp,160
    80005e52:	8082                	ret
    end_op();
    80005e54:	fffff097          	auipc	ra,0xfffff
    80005e58:	834080e7          	jalr	-1996(ra) # 80004688 <end_op>
    return -1;
    80005e5c:	557d                	li	a0,-1
    80005e5e:	b7fd                	j	80005e4c <sys_mknod+0x6c>

0000000080005e60 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005e60:	7135                	addi	sp,sp,-160
    80005e62:	ed06                	sd	ra,152(sp)
    80005e64:	e922                	sd	s0,144(sp)
    80005e66:	e526                	sd	s1,136(sp)
    80005e68:	e14a                	sd	s2,128(sp)
    80005e6a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005e6c:	ffffc097          	auipc	ra,0xffffc
    80005e70:	e8a080e7          	jalr	-374(ra) # 80001cf6 <myproc>
    80005e74:	892a                	mv	s2,a0
  
  begin_op();
    80005e76:	ffffe097          	auipc	ra,0xffffe
    80005e7a:	792080e7          	jalr	1938(ra) # 80004608 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005e7e:	08000613          	li	a2,128
    80005e82:	f6040593          	addi	a1,s0,-160
    80005e86:	4501                	li	a0,0
    80005e88:	ffffd097          	auipc	ra,0xffffd
    80005e8c:	1f6080e7          	jalr	502(ra) # 8000307e <argstr>
    80005e90:	04054b63          	bltz	a0,80005ee6 <sys_chdir+0x86>
    80005e94:	f6040513          	addi	a0,s0,-160
    80005e98:	ffffe097          	auipc	ra,0xffffe
    80005e9c:	554080e7          	jalr	1364(ra) # 800043ec <namei>
    80005ea0:	84aa                	mv	s1,a0
    80005ea2:	c131                	beqz	a0,80005ee6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ea4:	ffffe097          	auipc	ra,0xffffe
    80005ea8:	da2080e7          	jalr	-606(ra) # 80003c46 <ilock>
  if(ip->type != T_DIR){
    80005eac:	04449703          	lh	a4,68(s1)
    80005eb0:	4785                	li	a5,1
    80005eb2:	04f71063          	bne	a4,a5,80005ef2 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005eb6:	8526                	mv	a0,s1
    80005eb8:	ffffe097          	auipc	ra,0xffffe
    80005ebc:	e50080e7          	jalr	-432(ra) # 80003d08 <iunlock>
  iput(p->cwd);
    80005ec0:	15093503          	ld	a0,336(s2)
    80005ec4:	ffffe097          	auipc	ra,0xffffe
    80005ec8:	f3c080e7          	jalr	-196(ra) # 80003e00 <iput>
  end_op();
    80005ecc:	ffffe097          	auipc	ra,0xffffe
    80005ed0:	7bc080e7          	jalr	1980(ra) # 80004688 <end_op>
  p->cwd = ip;
    80005ed4:	14993823          	sd	s1,336(s2)
  return 0;
    80005ed8:	4501                	li	a0,0
}
    80005eda:	60ea                	ld	ra,152(sp)
    80005edc:	644a                	ld	s0,144(sp)
    80005ede:	64aa                	ld	s1,136(sp)
    80005ee0:	690a                	ld	s2,128(sp)
    80005ee2:	610d                	addi	sp,sp,160
    80005ee4:	8082                	ret
    end_op();
    80005ee6:	ffffe097          	auipc	ra,0xffffe
    80005eea:	7a2080e7          	jalr	1954(ra) # 80004688 <end_op>
    return -1;
    80005eee:	557d                	li	a0,-1
    80005ef0:	b7ed                	j	80005eda <sys_chdir+0x7a>
    iunlockput(ip);
    80005ef2:	8526                	mv	a0,s1
    80005ef4:	ffffe097          	auipc	ra,0xffffe
    80005ef8:	fb4080e7          	jalr	-76(ra) # 80003ea8 <iunlockput>
    end_op();
    80005efc:	ffffe097          	auipc	ra,0xffffe
    80005f00:	78c080e7          	jalr	1932(ra) # 80004688 <end_op>
    return -1;
    80005f04:	557d                	li	a0,-1
    80005f06:	bfd1                	j	80005eda <sys_chdir+0x7a>

0000000080005f08 <sys_exec>:

uint64
sys_exec(void)
{
    80005f08:	7145                	addi	sp,sp,-464
    80005f0a:	e786                	sd	ra,456(sp)
    80005f0c:	e3a2                	sd	s0,448(sp)
    80005f0e:	ff26                	sd	s1,440(sp)
    80005f10:	fb4a                	sd	s2,432(sp)
    80005f12:	f74e                	sd	s3,424(sp)
    80005f14:	f352                	sd	s4,416(sp)
    80005f16:	ef56                	sd	s5,408(sp)
    80005f18:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005f1a:	e3840593          	addi	a1,s0,-456
    80005f1e:	4505                	li	a0,1
    80005f20:	ffffd097          	auipc	ra,0xffffd
    80005f24:	13e080e7          	jalr	318(ra) # 8000305e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005f28:	08000613          	li	a2,128
    80005f2c:	f4040593          	addi	a1,s0,-192
    80005f30:	4501                	li	a0,0
    80005f32:	ffffd097          	auipc	ra,0xffffd
    80005f36:	14c080e7          	jalr	332(ra) # 8000307e <argstr>
    80005f3a:	87aa                	mv	a5,a0
    return -1;
    80005f3c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005f3e:	0c07c263          	bltz	a5,80006002 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005f42:	10000613          	li	a2,256
    80005f46:	4581                	li	a1,0
    80005f48:	e4040513          	addi	a0,s0,-448
    80005f4c:	ffffb097          	auipc	ra,0xffffb
    80005f50:	f96080e7          	jalr	-106(ra) # 80000ee2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005f54:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005f58:	89a6                	mv	s3,s1
    80005f5a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005f5c:	02000a13          	li	s4,32
    80005f60:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005f64:	00391793          	slli	a5,s2,0x3
    80005f68:	e3040593          	addi	a1,s0,-464
    80005f6c:	e3843503          	ld	a0,-456(s0)
    80005f70:	953e                	add	a0,a0,a5
    80005f72:	ffffd097          	auipc	ra,0xffffd
    80005f76:	02e080e7          	jalr	46(ra) # 80002fa0 <fetchaddr>
    80005f7a:	02054a63          	bltz	a0,80005fae <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005f7e:	e3043783          	ld	a5,-464(s0)
    80005f82:	c3b9                	beqz	a5,80005fc8 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005f84:	ffffb097          	auipc	ra,0xffffb
    80005f88:	d60080e7          	jalr	-672(ra) # 80000ce4 <kalloc>
    80005f8c:	85aa                	mv	a1,a0
    80005f8e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005f92:	cd11                	beqz	a0,80005fae <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005f94:	6605                	lui	a2,0x1
    80005f96:	e3043503          	ld	a0,-464(s0)
    80005f9a:	ffffd097          	auipc	ra,0xffffd
    80005f9e:	058080e7          	jalr	88(ra) # 80002ff2 <fetchstr>
    80005fa2:	00054663          	bltz	a0,80005fae <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005fa6:	0905                	addi	s2,s2,1
    80005fa8:	09a1                	addi	s3,s3,8
    80005faa:	fb491be3          	bne	s2,s4,80005f60 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005fae:	10048913          	addi	s2,s1,256
    80005fb2:	6088                	ld	a0,0(s1)
    80005fb4:	c531                	beqz	a0,80006000 <sys_exec+0xf8>
    kfree(argv[i]);
    80005fb6:	ffffb097          	auipc	ra,0xffffb
    80005fba:	be8080e7          	jalr	-1048(ra) # 80000b9e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005fbe:	04a1                	addi	s1,s1,8
    80005fc0:	ff2499e3          	bne	s1,s2,80005fb2 <sys_exec+0xaa>
  return -1;
    80005fc4:	557d                	li	a0,-1
    80005fc6:	a835                	j	80006002 <sys_exec+0xfa>
      argv[i] = 0;
    80005fc8:	0a8e                	slli	s5,s5,0x3
    80005fca:	fc040793          	addi	a5,s0,-64
    80005fce:	9abe                	add	s5,s5,a5
    80005fd0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005fd4:	e4040593          	addi	a1,s0,-448
    80005fd8:	f4040513          	addi	a0,s0,-192
    80005fdc:	fffff097          	auipc	ra,0xfffff
    80005fe0:	172080e7          	jalr	370(ra) # 8000514e <exec>
    80005fe4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005fe6:	10048993          	addi	s3,s1,256
    80005fea:	6088                	ld	a0,0(s1)
    80005fec:	c901                	beqz	a0,80005ffc <sys_exec+0xf4>
    kfree(argv[i]);
    80005fee:	ffffb097          	auipc	ra,0xffffb
    80005ff2:	bb0080e7          	jalr	-1104(ra) # 80000b9e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ff6:	04a1                	addi	s1,s1,8
    80005ff8:	ff3499e3          	bne	s1,s3,80005fea <sys_exec+0xe2>
  return ret;
    80005ffc:	854a                	mv	a0,s2
    80005ffe:	a011                	j	80006002 <sys_exec+0xfa>
  return -1;
    80006000:	557d                	li	a0,-1
}
    80006002:	60be                	ld	ra,456(sp)
    80006004:	641e                	ld	s0,448(sp)
    80006006:	74fa                	ld	s1,440(sp)
    80006008:	795a                	ld	s2,432(sp)
    8000600a:	79ba                	ld	s3,424(sp)
    8000600c:	7a1a                	ld	s4,416(sp)
    8000600e:	6afa                	ld	s5,408(sp)
    80006010:	6179                	addi	sp,sp,464
    80006012:	8082                	ret

0000000080006014 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006014:	7139                	addi	sp,sp,-64
    80006016:	fc06                	sd	ra,56(sp)
    80006018:	f822                	sd	s0,48(sp)
    8000601a:	f426                	sd	s1,40(sp)
    8000601c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000601e:	ffffc097          	auipc	ra,0xffffc
    80006022:	cd8080e7          	jalr	-808(ra) # 80001cf6 <myproc>
    80006026:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006028:	fd840593          	addi	a1,s0,-40
    8000602c:	4501                	li	a0,0
    8000602e:	ffffd097          	auipc	ra,0xffffd
    80006032:	030080e7          	jalr	48(ra) # 8000305e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006036:	fc840593          	addi	a1,s0,-56
    8000603a:	fd040513          	addi	a0,s0,-48
    8000603e:	fffff097          	auipc	ra,0xfffff
    80006042:	dc6080e7          	jalr	-570(ra) # 80004e04 <pipealloc>
    return -1;
    80006046:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006048:	0c054463          	bltz	a0,80006110 <sys_pipe+0xfc>
  fd0 = -1;
    8000604c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006050:	fd043503          	ld	a0,-48(s0)
    80006054:	fffff097          	auipc	ra,0xfffff
    80006058:	51a080e7          	jalr	1306(ra) # 8000556e <fdalloc>
    8000605c:	fca42223          	sw	a0,-60(s0)
    80006060:	08054b63          	bltz	a0,800060f6 <sys_pipe+0xe2>
    80006064:	fc843503          	ld	a0,-56(s0)
    80006068:	fffff097          	auipc	ra,0xfffff
    8000606c:	506080e7          	jalr	1286(ra) # 8000556e <fdalloc>
    80006070:	fca42023          	sw	a0,-64(s0)
    80006074:	06054863          	bltz	a0,800060e4 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006078:	4691                	li	a3,4
    8000607a:	fc440613          	addi	a2,s0,-60
    8000607e:	fd843583          	ld	a1,-40(s0)
    80006082:	68a8                	ld	a0,80(s1)
    80006084:	ffffc097          	auipc	ra,0xffffc
    80006088:	91a080e7          	jalr	-1766(ra) # 8000199e <copyout>
    8000608c:	02054063          	bltz	a0,800060ac <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006090:	4691                	li	a3,4
    80006092:	fc040613          	addi	a2,s0,-64
    80006096:	fd843583          	ld	a1,-40(s0)
    8000609a:	0591                	addi	a1,a1,4
    8000609c:	68a8                	ld	a0,80(s1)
    8000609e:	ffffc097          	auipc	ra,0xffffc
    800060a2:	900080e7          	jalr	-1792(ra) # 8000199e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800060a6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060a8:	06055463          	bgez	a0,80006110 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800060ac:	fc442783          	lw	a5,-60(s0)
    800060b0:	07e9                	addi	a5,a5,26
    800060b2:	078e                	slli	a5,a5,0x3
    800060b4:	97a6                	add	a5,a5,s1
    800060b6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800060ba:	fc042503          	lw	a0,-64(s0)
    800060be:	0569                	addi	a0,a0,26
    800060c0:	050e                	slli	a0,a0,0x3
    800060c2:	94aa                	add	s1,s1,a0
    800060c4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800060c8:	fd043503          	ld	a0,-48(s0)
    800060cc:	fffff097          	auipc	ra,0xfffff
    800060d0:	a08080e7          	jalr	-1528(ra) # 80004ad4 <fileclose>
    fileclose(wf);
    800060d4:	fc843503          	ld	a0,-56(s0)
    800060d8:	fffff097          	auipc	ra,0xfffff
    800060dc:	9fc080e7          	jalr	-1540(ra) # 80004ad4 <fileclose>
    return -1;
    800060e0:	57fd                	li	a5,-1
    800060e2:	a03d                	j	80006110 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800060e4:	fc442783          	lw	a5,-60(s0)
    800060e8:	0007c763          	bltz	a5,800060f6 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800060ec:	07e9                	addi	a5,a5,26
    800060ee:	078e                	slli	a5,a5,0x3
    800060f0:	94be                	add	s1,s1,a5
    800060f2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800060f6:	fd043503          	ld	a0,-48(s0)
    800060fa:	fffff097          	auipc	ra,0xfffff
    800060fe:	9da080e7          	jalr	-1574(ra) # 80004ad4 <fileclose>
    fileclose(wf);
    80006102:	fc843503          	ld	a0,-56(s0)
    80006106:	fffff097          	auipc	ra,0xfffff
    8000610a:	9ce080e7          	jalr	-1586(ra) # 80004ad4 <fileclose>
    return -1;
    8000610e:	57fd                	li	a5,-1
}
    80006110:	853e                	mv	a0,a5
    80006112:	70e2                	ld	ra,56(sp)
    80006114:	7442                	ld	s0,48(sp)
    80006116:	74a2                	ld	s1,40(sp)
    80006118:	6121                	addi	sp,sp,64
    8000611a:	8082                	ret
    8000611c:	0000                	unimp
	...

0000000080006120 <kernelvec>:
    80006120:	7111                	addi	sp,sp,-256
    80006122:	e006                	sd	ra,0(sp)
    80006124:	e40a                	sd	sp,8(sp)
    80006126:	e80e                	sd	gp,16(sp)
    80006128:	ec12                	sd	tp,24(sp)
    8000612a:	f016                	sd	t0,32(sp)
    8000612c:	f41a                	sd	t1,40(sp)
    8000612e:	f81e                	sd	t2,48(sp)
    80006130:	fc22                	sd	s0,56(sp)
    80006132:	e0a6                	sd	s1,64(sp)
    80006134:	e4aa                	sd	a0,72(sp)
    80006136:	e8ae                	sd	a1,80(sp)
    80006138:	ecb2                	sd	a2,88(sp)
    8000613a:	f0b6                	sd	a3,96(sp)
    8000613c:	f4ba                	sd	a4,104(sp)
    8000613e:	f8be                	sd	a5,112(sp)
    80006140:	fcc2                	sd	a6,120(sp)
    80006142:	e146                	sd	a7,128(sp)
    80006144:	e54a                	sd	s2,136(sp)
    80006146:	e94e                	sd	s3,144(sp)
    80006148:	ed52                	sd	s4,152(sp)
    8000614a:	f156                	sd	s5,160(sp)
    8000614c:	f55a                	sd	s6,168(sp)
    8000614e:	f95e                	sd	s7,176(sp)
    80006150:	fd62                	sd	s8,184(sp)
    80006152:	e1e6                	sd	s9,192(sp)
    80006154:	e5ea                	sd	s10,200(sp)
    80006156:	e9ee                	sd	s11,208(sp)
    80006158:	edf2                	sd	t3,216(sp)
    8000615a:	f1f6                	sd	t4,224(sp)
    8000615c:	f5fa                	sd	t5,232(sp)
    8000615e:	f9fe                	sd	t6,240(sp)
    80006160:	d0dfc0ef          	jal	80002e6c <kerneltrap>
    80006164:	6082                	ld	ra,0(sp)
    80006166:	6122                	ld	sp,8(sp)
    80006168:	61c2                	ld	gp,16(sp)
    8000616a:	7282                	ld	t0,32(sp)
    8000616c:	7322                	ld	t1,40(sp)
    8000616e:	73c2                	ld	t2,48(sp)
    80006170:	7462                	ld	s0,56(sp)
    80006172:	6486                	ld	s1,64(sp)
    80006174:	6526                	ld	a0,72(sp)
    80006176:	65c6                	ld	a1,80(sp)
    80006178:	6666                	ld	a2,88(sp)
    8000617a:	7686                	ld	a3,96(sp)
    8000617c:	7726                	ld	a4,104(sp)
    8000617e:	77c6                	ld	a5,112(sp)
    80006180:	7866                	ld	a6,120(sp)
    80006182:	688a                	ld	a7,128(sp)
    80006184:	692a                	ld	s2,136(sp)
    80006186:	69ca                	ld	s3,144(sp)
    80006188:	6a6a                	ld	s4,152(sp)
    8000618a:	7a8a                	ld	s5,160(sp)
    8000618c:	7b2a                	ld	s6,168(sp)
    8000618e:	7bca                	ld	s7,176(sp)
    80006190:	7c6a                	ld	s8,184(sp)
    80006192:	6c8e                	ld	s9,192(sp)
    80006194:	6d2e                	ld	s10,200(sp)
    80006196:	6dce                	ld	s11,208(sp)
    80006198:	6e6e                	ld	t3,216(sp)
    8000619a:	7e8e                	ld	t4,224(sp)
    8000619c:	7f2e                	ld	t5,232(sp)
    8000619e:	7fce                	ld	t6,240(sp)
    800061a0:	6111                	addi	sp,sp,256
    800061a2:	10200073          	sret
    800061a6:	00000013          	nop
    800061aa:	00000013          	nop
    800061ae:	0001                	nop

00000000800061b0 <timervec>:
    800061b0:	34051573          	csrrw	a0,mscratch,a0
    800061b4:	e10c                	sd	a1,0(a0)
    800061b6:	e510                	sd	a2,8(a0)
    800061b8:	e914                	sd	a3,16(a0)
    800061ba:	6d0c                	ld	a1,24(a0)
    800061bc:	7110                	ld	a2,32(a0)
    800061be:	6194                	ld	a3,0(a1)
    800061c0:	96b2                	add	a3,a3,a2
    800061c2:	e194                	sd	a3,0(a1)
    800061c4:	4589                	li	a1,2
    800061c6:	14459073          	csrw	sip,a1
    800061ca:	6914                	ld	a3,16(a0)
    800061cc:	6510                	ld	a2,8(a0)
    800061ce:	610c                	ld	a1,0(a0)
    800061d0:	34051573          	csrrw	a0,mscratch,a0
    800061d4:	30200073          	mret
	...

00000000800061da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800061da:	1141                	addi	sp,sp,-16
    800061dc:	e422                	sd	s0,8(sp)
    800061de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800061e0:	0c0007b7          	lui	a5,0xc000
    800061e4:	4705                	li	a4,1
    800061e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800061e8:	c3d8                	sw	a4,4(a5)
}
    800061ea:	6422                	ld	s0,8(sp)
    800061ec:	0141                	addi	sp,sp,16
    800061ee:	8082                	ret

00000000800061f0 <plicinithart>:

void
plicinithart(void)
{
    800061f0:	1141                	addi	sp,sp,-16
    800061f2:	e406                	sd	ra,8(sp)
    800061f4:	e022                	sd	s0,0(sp)
    800061f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061f8:	ffffc097          	auipc	ra,0xffffc
    800061fc:	ad2080e7          	jalr	-1326(ra) # 80001cca <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006200:	0085171b          	slliw	a4,a0,0x8
    80006204:	0c0027b7          	lui	a5,0xc002
    80006208:	97ba                	add	a5,a5,a4
    8000620a:	40200713          	li	a4,1026
    8000620e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006212:	00d5151b          	slliw	a0,a0,0xd
    80006216:	0c2017b7          	lui	a5,0xc201
    8000621a:	953e                	add	a0,a0,a5
    8000621c:	00052023          	sw	zero,0(a0)
}
    80006220:	60a2                	ld	ra,8(sp)
    80006222:	6402                	ld	s0,0(sp)
    80006224:	0141                	addi	sp,sp,16
    80006226:	8082                	ret

0000000080006228 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006228:	1141                	addi	sp,sp,-16
    8000622a:	e406                	sd	ra,8(sp)
    8000622c:	e022                	sd	s0,0(sp)
    8000622e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006230:	ffffc097          	auipc	ra,0xffffc
    80006234:	a9a080e7          	jalr	-1382(ra) # 80001cca <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006238:	00d5179b          	slliw	a5,a0,0xd
    8000623c:	0c201537          	lui	a0,0xc201
    80006240:	953e                	add	a0,a0,a5
  return irq;
}
    80006242:	4148                	lw	a0,4(a0)
    80006244:	60a2                	ld	ra,8(sp)
    80006246:	6402                	ld	s0,0(sp)
    80006248:	0141                	addi	sp,sp,16
    8000624a:	8082                	ret

000000008000624c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000624c:	1101                	addi	sp,sp,-32
    8000624e:	ec06                	sd	ra,24(sp)
    80006250:	e822                	sd	s0,16(sp)
    80006252:	e426                	sd	s1,8(sp)
    80006254:	1000                	addi	s0,sp,32
    80006256:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006258:	ffffc097          	auipc	ra,0xffffc
    8000625c:	a72080e7          	jalr	-1422(ra) # 80001cca <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006260:	00d5151b          	slliw	a0,a0,0xd
    80006264:	0c2017b7          	lui	a5,0xc201
    80006268:	97aa                	add	a5,a5,a0
    8000626a:	c3c4                	sw	s1,4(a5)
}
    8000626c:	60e2                	ld	ra,24(sp)
    8000626e:	6442                	ld	s0,16(sp)
    80006270:	64a2                	ld	s1,8(sp)
    80006272:	6105                	addi	sp,sp,32
    80006274:	8082                	ret

0000000080006276 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006276:	1141                	addi	sp,sp,-16
    80006278:	e406                	sd	ra,8(sp)
    8000627a:	e022                	sd	s0,0(sp)
    8000627c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000627e:	479d                	li	a5,7
    80006280:	04a7cc63          	blt	a5,a0,800062d8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006284:	0023c797          	auipc	a5,0x23c
    80006288:	e6478793          	addi	a5,a5,-412 # 802420e8 <disk>
    8000628c:	97aa                	add	a5,a5,a0
    8000628e:	0187c783          	lbu	a5,24(a5)
    80006292:	ebb9                	bnez	a5,800062e8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006294:	00451613          	slli	a2,a0,0x4
    80006298:	0023c797          	auipc	a5,0x23c
    8000629c:	e5078793          	addi	a5,a5,-432 # 802420e8 <disk>
    800062a0:	6394                	ld	a3,0(a5)
    800062a2:	96b2                	add	a3,a3,a2
    800062a4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800062a8:	6398                	ld	a4,0(a5)
    800062aa:	9732                	add	a4,a4,a2
    800062ac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800062b0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800062b4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800062b8:	953e                	add	a0,a0,a5
    800062ba:	4785                	li	a5,1
    800062bc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800062c0:	0023c517          	auipc	a0,0x23c
    800062c4:	e4050513          	addi	a0,a0,-448 # 80242100 <disk+0x18>
    800062c8:	ffffc097          	auipc	ra,0xffffc
    800062cc:	16e080e7          	jalr	366(ra) # 80002436 <wakeup>
}
    800062d0:	60a2                	ld	ra,8(sp)
    800062d2:	6402                	ld	s0,0(sp)
    800062d4:	0141                	addi	sp,sp,16
    800062d6:	8082                	ret
    panic("free_desc 1");
    800062d8:	00002517          	auipc	a0,0x2
    800062dc:	41850513          	addi	a0,a0,1048 # 800086f0 <etext+0x6f0>
    800062e0:	ffffa097          	auipc	ra,0xffffa
    800062e4:	25e080e7          	jalr	606(ra) # 8000053e <panic>
    panic("free_desc 2");
    800062e8:	00002517          	auipc	a0,0x2
    800062ec:	41850513          	addi	a0,a0,1048 # 80008700 <etext+0x700>
    800062f0:	ffffa097          	auipc	ra,0xffffa
    800062f4:	24e080e7          	jalr	590(ra) # 8000053e <panic>

00000000800062f8 <virtio_disk_init>:
{
    800062f8:	1101                	addi	sp,sp,-32
    800062fa:	ec06                	sd	ra,24(sp)
    800062fc:	e822                	sd	s0,16(sp)
    800062fe:	e426                	sd	s1,8(sp)
    80006300:	e04a                	sd	s2,0(sp)
    80006302:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006304:	00002597          	auipc	a1,0x2
    80006308:	40c58593          	addi	a1,a1,1036 # 80008710 <etext+0x710>
    8000630c:	0023c517          	auipc	a0,0x23c
    80006310:	f0450513          	addi	a0,a0,-252 # 80242210 <disk+0x128>
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	a42080e7          	jalr	-1470(ra) # 80000d56 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000631c:	100017b7          	lui	a5,0x10001
    80006320:	4398                	lw	a4,0(a5)
    80006322:	2701                	sext.w	a4,a4
    80006324:	747277b7          	lui	a5,0x74727
    80006328:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000632c:	14f71c63          	bne	a4,a5,80006484 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006330:	100017b7          	lui	a5,0x10001
    80006334:	43dc                	lw	a5,4(a5)
    80006336:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006338:	4709                	li	a4,2
    8000633a:	14e79563          	bne	a5,a4,80006484 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000633e:	100017b7          	lui	a5,0x10001
    80006342:	479c                	lw	a5,8(a5)
    80006344:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006346:	12e79f63          	bne	a5,a4,80006484 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000634a:	100017b7          	lui	a5,0x10001
    8000634e:	47d8                	lw	a4,12(a5)
    80006350:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006352:	554d47b7          	lui	a5,0x554d4
    80006356:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000635a:	12f71563          	bne	a4,a5,80006484 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000635e:	100017b7          	lui	a5,0x10001
    80006362:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006366:	4705                	li	a4,1
    80006368:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000636a:	470d                	li	a4,3
    8000636c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000636e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006370:	c7ffe737          	lui	a4,0xc7ffe
    80006374:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc537>
    80006378:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000637a:	2701                	sext.w	a4,a4
    8000637c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000637e:	472d                	li	a4,11
    80006380:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006382:	5bbc                	lw	a5,112(a5)
    80006384:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006388:	8ba1                	andi	a5,a5,8
    8000638a:	10078563          	beqz	a5,80006494 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000638e:	100017b7          	lui	a5,0x10001
    80006392:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006396:	43fc                	lw	a5,68(a5)
    80006398:	2781                	sext.w	a5,a5
    8000639a:	10079563          	bnez	a5,800064a4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000639e:	100017b7          	lui	a5,0x10001
    800063a2:	5bdc                	lw	a5,52(a5)
    800063a4:	2781                	sext.w	a5,a5
  if(max == 0)
    800063a6:	10078763          	beqz	a5,800064b4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800063aa:	471d                	li	a4,7
    800063ac:	10f77c63          	bgeu	a4,a5,800064c4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800063b0:	ffffb097          	auipc	ra,0xffffb
    800063b4:	934080e7          	jalr	-1740(ra) # 80000ce4 <kalloc>
    800063b8:	0023c497          	auipc	s1,0x23c
    800063bc:	d3048493          	addi	s1,s1,-720 # 802420e8 <disk>
    800063c0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800063c2:	ffffb097          	auipc	ra,0xffffb
    800063c6:	922080e7          	jalr	-1758(ra) # 80000ce4 <kalloc>
    800063ca:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	918080e7          	jalr	-1768(ra) # 80000ce4 <kalloc>
    800063d4:	87aa                	mv	a5,a0
    800063d6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800063d8:	6088                	ld	a0,0(s1)
    800063da:	cd6d                	beqz	a0,800064d4 <virtio_disk_init+0x1dc>
    800063dc:	0023c717          	auipc	a4,0x23c
    800063e0:	d1473703          	ld	a4,-748(a4) # 802420f0 <disk+0x8>
    800063e4:	cb65                	beqz	a4,800064d4 <virtio_disk_init+0x1dc>
    800063e6:	c7fd                	beqz	a5,800064d4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800063e8:	6605                	lui	a2,0x1
    800063ea:	4581                	li	a1,0
    800063ec:	ffffb097          	auipc	ra,0xffffb
    800063f0:	af6080e7          	jalr	-1290(ra) # 80000ee2 <memset>
  memset(disk.avail, 0, PGSIZE);
    800063f4:	0023c497          	auipc	s1,0x23c
    800063f8:	cf448493          	addi	s1,s1,-780 # 802420e8 <disk>
    800063fc:	6605                	lui	a2,0x1
    800063fe:	4581                	li	a1,0
    80006400:	6488                	ld	a0,8(s1)
    80006402:	ffffb097          	auipc	ra,0xffffb
    80006406:	ae0080e7          	jalr	-1312(ra) # 80000ee2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000640a:	6605                	lui	a2,0x1
    8000640c:	4581                	li	a1,0
    8000640e:	6888                	ld	a0,16(s1)
    80006410:	ffffb097          	auipc	ra,0xffffb
    80006414:	ad2080e7          	jalr	-1326(ra) # 80000ee2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006418:	100017b7          	lui	a5,0x10001
    8000641c:	4721                	li	a4,8
    8000641e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006420:	4098                	lw	a4,0(s1)
    80006422:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006426:	40d8                	lw	a4,4(s1)
    80006428:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000642c:	6498                	ld	a4,8(s1)
    8000642e:	0007069b          	sext.w	a3,a4
    80006432:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006436:	9701                	srai	a4,a4,0x20
    80006438:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000643c:	6898                	ld	a4,16(s1)
    8000643e:	0007069b          	sext.w	a3,a4
    80006442:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006446:	9701                	srai	a4,a4,0x20
    80006448:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000644c:	4705                	li	a4,1
    8000644e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006450:	00e48c23          	sb	a4,24(s1)
    80006454:	00e48ca3          	sb	a4,25(s1)
    80006458:	00e48d23          	sb	a4,26(s1)
    8000645c:	00e48da3          	sb	a4,27(s1)
    80006460:	00e48e23          	sb	a4,28(s1)
    80006464:	00e48ea3          	sb	a4,29(s1)
    80006468:	00e48f23          	sb	a4,30(s1)
    8000646c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006470:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006474:	0727a823          	sw	s2,112(a5)
}
    80006478:	60e2                	ld	ra,24(sp)
    8000647a:	6442                	ld	s0,16(sp)
    8000647c:	64a2                	ld	s1,8(sp)
    8000647e:	6902                	ld	s2,0(sp)
    80006480:	6105                	addi	sp,sp,32
    80006482:	8082                	ret
    panic("could not find virtio disk");
    80006484:	00002517          	auipc	a0,0x2
    80006488:	29c50513          	addi	a0,a0,668 # 80008720 <etext+0x720>
    8000648c:	ffffa097          	auipc	ra,0xffffa
    80006490:	0b2080e7          	jalr	178(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006494:	00002517          	auipc	a0,0x2
    80006498:	2ac50513          	addi	a0,a0,684 # 80008740 <etext+0x740>
    8000649c:	ffffa097          	auipc	ra,0xffffa
    800064a0:	0a2080e7          	jalr	162(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    800064a4:	00002517          	auipc	a0,0x2
    800064a8:	2bc50513          	addi	a0,a0,700 # 80008760 <etext+0x760>
    800064ac:	ffffa097          	auipc	ra,0xffffa
    800064b0:	092080e7          	jalr	146(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    800064b4:	00002517          	auipc	a0,0x2
    800064b8:	2cc50513          	addi	a0,a0,716 # 80008780 <etext+0x780>
    800064bc:	ffffa097          	auipc	ra,0xffffa
    800064c0:	082080e7          	jalr	130(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	2dc50513          	addi	a0,a0,732 # 800087a0 <etext+0x7a0>
    800064cc:	ffffa097          	auipc	ra,0xffffa
    800064d0:	072080e7          	jalr	114(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    800064d4:	00002517          	auipc	a0,0x2
    800064d8:	2ec50513          	addi	a0,a0,748 # 800087c0 <etext+0x7c0>
    800064dc:	ffffa097          	auipc	ra,0xffffa
    800064e0:	062080e7          	jalr	98(ra) # 8000053e <panic>

00000000800064e4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800064e4:	7119                	addi	sp,sp,-128
    800064e6:	fc86                	sd	ra,120(sp)
    800064e8:	f8a2                	sd	s0,112(sp)
    800064ea:	f4a6                	sd	s1,104(sp)
    800064ec:	f0ca                	sd	s2,96(sp)
    800064ee:	ecce                	sd	s3,88(sp)
    800064f0:	e8d2                	sd	s4,80(sp)
    800064f2:	e4d6                	sd	s5,72(sp)
    800064f4:	e0da                	sd	s6,64(sp)
    800064f6:	fc5e                	sd	s7,56(sp)
    800064f8:	f862                	sd	s8,48(sp)
    800064fa:	f466                	sd	s9,40(sp)
    800064fc:	f06a                	sd	s10,32(sp)
    800064fe:	ec6e                	sd	s11,24(sp)
    80006500:	0100                	addi	s0,sp,128
    80006502:	8aaa                	mv	s5,a0
    80006504:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006506:	00c52d03          	lw	s10,12(a0)
    8000650a:	001d1d1b          	slliw	s10,s10,0x1
    8000650e:	1d02                	slli	s10,s10,0x20
    80006510:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006514:	0023c517          	auipc	a0,0x23c
    80006518:	cfc50513          	addi	a0,a0,-772 # 80242210 <disk+0x128>
    8000651c:	ffffb097          	auipc	ra,0xffffb
    80006520:	8ca080e7          	jalr	-1846(ra) # 80000de6 <acquire>
  for(int i = 0; i < 3; i++){
    80006524:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006526:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006528:	0023cb97          	auipc	s7,0x23c
    8000652c:	bc0b8b93          	addi	s7,s7,-1088 # 802420e8 <disk>
  for(int i = 0; i < 3; i++){
    80006530:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006532:	0023cc97          	auipc	s9,0x23c
    80006536:	cdec8c93          	addi	s9,s9,-802 # 80242210 <disk+0x128>
    8000653a:	a08d                	j	8000659c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000653c:	00fb8733          	add	a4,s7,a5
    80006540:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006544:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006546:	0207c563          	bltz	a5,80006570 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000654a:	2905                	addiw	s2,s2,1
    8000654c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000654e:	05690c63          	beq	s2,s6,800065a6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006552:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006554:	0023c717          	auipc	a4,0x23c
    80006558:	b9470713          	addi	a4,a4,-1132 # 802420e8 <disk>
    8000655c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000655e:	01874683          	lbu	a3,24(a4)
    80006562:	fee9                	bnez	a3,8000653c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006564:	2785                	addiw	a5,a5,1
    80006566:	0705                	addi	a4,a4,1
    80006568:	fe979be3          	bne	a5,s1,8000655e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000656c:	57fd                	li	a5,-1
    8000656e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006570:	01205d63          	blez	s2,8000658a <virtio_disk_rw+0xa6>
    80006574:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006576:	000a2503          	lw	a0,0(s4)
    8000657a:	00000097          	auipc	ra,0x0
    8000657e:	cfc080e7          	jalr	-772(ra) # 80006276 <free_desc>
      for(int j = 0; j < i; j++)
    80006582:	2d85                	addiw	s11,s11,1
    80006584:	0a11                	addi	s4,s4,4
    80006586:	ffb918e3          	bne	s2,s11,80006576 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000658a:	85e6                	mv	a1,s9
    8000658c:	0023c517          	auipc	a0,0x23c
    80006590:	b7450513          	addi	a0,a0,-1164 # 80242100 <disk+0x18>
    80006594:	ffffc097          	auipc	ra,0xffffc
    80006598:	e3e080e7          	jalr	-450(ra) # 800023d2 <sleep>
  for(int i = 0; i < 3; i++){
    8000659c:	f8040a13          	addi	s4,s0,-128
{
    800065a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800065a2:	894e                	mv	s2,s3
    800065a4:	b77d                	j	80006552 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065a6:	f8042583          	lw	a1,-128(s0)
    800065aa:	00a58793          	addi	a5,a1,10
    800065ae:	0792                	slli	a5,a5,0x4

  if(write)
    800065b0:	0023c617          	auipc	a2,0x23c
    800065b4:	b3860613          	addi	a2,a2,-1224 # 802420e8 <disk>
    800065b8:	00f60733          	add	a4,a2,a5
    800065bc:	018036b3          	snez	a3,s8
    800065c0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800065c2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800065c6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800065ca:	f6078693          	addi	a3,a5,-160
    800065ce:	6218                	ld	a4,0(a2)
    800065d0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065d2:	00878513          	addi	a0,a5,8
    800065d6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065d8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800065da:	6208                	ld	a0,0(a2)
    800065dc:	96aa                	add	a3,a3,a0
    800065de:	4741                	li	a4,16
    800065e0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065e2:	4705                	li	a4,1
    800065e4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800065e8:	f8442703          	lw	a4,-124(s0)
    800065ec:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800065f0:	0712                	slli	a4,a4,0x4
    800065f2:	953a                	add	a0,a0,a4
    800065f4:	058a8693          	addi	a3,s5,88
    800065f8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800065fa:	6208                	ld	a0,0(a2)
    800065fc:	972a                	add	a4,a4,a0
    800065fe:	40000693          	li	a3,1024
    80006602:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006604:	001c3c13          	seqz	s8,s8
    80006608:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000660a:	001c6c13          	ori	s8,s8,1
    8000660e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006612:	f8842603          	lw	a2,-120(s0)
    80006616:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000661a:	0023c697          	auipc	a3,0x23c
    8000661e:	ace68693          	addi	a3,a3,-1330 # 802420e8 <disk>
    80006622:	00258713          	addi	a4,a1,2
    80006626:	0712                	slli	a4,a4,0x4
    80006628:	9736                	add	a4,a4,a3
    8000662a:	587d                	li	a6,-1
    8000662c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006630:	0612                	slli	a2,a2,0x4
    80006632:	9532                	add	a0,a0,a2
    80006634:	f9078793          	addi	a5,a5,-112
    80006638:	97b6                	add	a5,a5,a3
    8000663a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000663c:	629c                	ld	a5,0(a3)
    8000663e:	97b2                	add	a5,a5,a2
    80006640:	4605                	li	a2,1
    80006642:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006644:	4509                	li	a0,2
    80006646:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000664a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000664e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006652:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006656:	6698                	ld	a4,8(a3)
    80006658:	00275783          	lhu	a5,2(a4)
    8000665c:	8b9d                	andi	a5,a5,7
    8000665e:	0786                	slli	a5,a5,0x1
    80006660:	97ba                	add	a5,a5,a4
    80006662:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006666:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000666a:	6698                	ld	a4,8(a3)
    8000666c:	00275783          	lhu	a5,2(a4)
    80006670:	2785                	addiw	a5,a5,1
    80006672:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006676:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000667a:	100017b7          	lui	a5,0x10001
    8000667e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006682:	004aa783          	lw	a5,4(s5)
    80006686:	02c79163          	bne	a5,a2,800066a8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000668a:	0023c917          	auipc	s2,0x23c
    8000668e:	b8690913          	addi	s2,s2,-1146 # 80242210 <disk+0x128>
  while(b->disk == 1) {
    80006692:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006694:	85ca                	mv	a1,s2
    80006696:	8556                	mv	a0,s5
    80006698:	ffffc097          	auipc	ra,0xffffc
    8000669c:	d3a080e7          	jalr	-710(ra) # 800023d2 <sleep>
  while(b->disk == 1) {
    800066a0:	004aa783          	lw	a5,4(s5)
    800066a4:	fe9788e3          	beq	a5,s1,80006694 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800066a8:	f8042903          	lw	s2,-128(s0)
    800066ac:	00290793          	addi	a5,s2,2
    800066b0:	00479713          	slli	a4,a5,0x4
    800066b4:	0023c797          	auipc	a5,0x23c
    800066b8:	a3478793          	addi	a5,a5,-1484 # 802420e8 <disk>
    800066bc:	97ba                	add	a5,a5,a4
    800066be:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800066c2:	0023c997          	auipc	s3,0x23c
    800066c6:	a2698993          	addi	s3,s3,-1498 # 802420e8 <disk>
    800066ca:	00491713          	slli	a4,s2,0x4
    800066ce:	0009b783          	ld	a5,0(s3)
    800066d2:	97ba                	add	a5,a5,a4
    800066d4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800066d8:	854a                	mv	a0,s2
    800066da:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800066de:	00000097          	auipc	ra,0x0
    800066e2:	b98080e7          	jalr	-1128(ra) # 80006276 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800066e6:	8885                	andi	s1,s1,1
    800066e8:	f0ed                	bnez	s1,800066ca <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800066ea:	0023c517          	auipc	a0,0x23c
    800066ee:	b2650513          	addi	a0,a0,-1242 # 80242210 <disk+0x128>
    800066f2:	ffffa097          	auipc	ra,0xffffa
    800066f6:	7a8080e7          	jalr	1960(ra) # 80000e9a <release>
}
    800066fa:	70e6                	ld	ra,120(sp)
    800066fc:	7446                	ld	s0,112(sp)
    800066fe:	74a6                	ld	s1,104(sp)
    80006700:	7906                	ld	s2,96(sp)
    80006702:	69e6                	ld	s3,88(sp)
    80006704:	6a46                	ld	s4,80(sp)
    80006706:	6aa6                	ld	s5,72(sp)
    80006708:	6b06                	ld	s6,64(sp)
    8000670a:	7be2                	ld	s7,56(sp)
    8000670c:	7c42                	ld	s8,48(sp)
    8000670e:	7ca2                	ld	s9,40(sp)
    80006710:	7d02                	ld	s10,32(sp)
    80006712:	6de2                	ld	s11,24(sp)
    80006714:	6109                	addi	sp,sp,128
    80006716:	8082                	ret

0000000080006718 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006718:	1101                	addi	sp,sp,-32
    8000671a:	ec06                	sd	ra,24(sp)
    8000671c:	e822                	sd	s0,16(sp)
    8000671e:	e426                	sd	s1,8(sp)
    80006720:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006722:	0023c497          	auipc	s1,0x23c
    80006726:	9c648493          	addi	s1,s1,-1594 # 802420e8 <disk>
    8000672a:	0023c517          	auipc	a0,0x23c
    8000672e:	ae650513          	addi	a0,a0,-1306 # 80242210 <disk+0x128>
    80006732:	ffffa097          	auipc	ra,0xffffa
    80006736:	6b4080e7          	jalr	1716(ra) # 80000de6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000673a:	10001737          	lui	a4,0x10001
    8000673e:	533c                	lw	a5,96(a4)
    80006740:	8b8d                	andi	a5,a5,3
    80006742:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006744:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006748:	689c                	ld	a5,16(s1)
    8000674a:	0204d703          	lhu	a4,32(s1)
    8000674e:	0027d783          	lhu	a5,2(a5)
    80006752:	04f70863          	beq	a4,a5,800067a2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006756:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000675a:	6898                	ld	a4,16(s1)
    8000675c:	0204d783          	lhu	a5,32(s1)
    80006760:	8b9d                	andi	a5,a5,7
    80006762:	078e                	slli	a5,a5,0x3
    80006764:	97ba                	add	a5,a5,a4
    80006766:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006768:	00278713          	addi	a4,a5,2
    8000676c:	0712                	slli	a4,a4,0x4
    8000676e:	9726                	add	a4,a4,s1
    80006770:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006774:	e721                	bnez	a4,800067bc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006776:	0789                	addi	a5,a5,2
    80006778:	0792                	slli	a5,a5,0x4
    8000677a:	97a6                	add	a5,a5,s1
    8000677c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000677e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006782:	ffffc097          	auipc	ra,0xffffc
    80006786:	cb4080e7          	jalr	-844(ra) # 80002436 <wakeup>

    disk.used_idx += 1;
    8000678a:	0204d783          	lhu	a5,32(s1)
    8000678e:	2785                	addiw	a5,a5,1
    80006790:	17c2                	slli	a5,a5,0x30
    80006792:	93c1                	srli	a5,a5,0x30
    80006794:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006798:	6898                	ld	a4,16(s1)
    8000679a:	00275703          	lhu	a4,2(a4)
    8000679e:	faf71ce3          	bne	a4,a5,80006756 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800067a2:	0023c517          	auipc	a0,0x23c
    800067a6:	a6e50513          	addi	a0,a0,-1426 # 80242210 <disk+0x128>
    800067aa:	ffffa097          	auipc	ra,0xffffa
    800067ae:	6f0080e7          	jalr	1776(ra) # 80000e9a <release>
}
    800067b2:	60e2                	ld	ra,24(sp)
    800067b4:	6442                	ld	s0,16(sp)
    800067b6:	64a2                	ld	s1,8(sp)
    800067b8:	6105                	addi	sp,sp,32
    800067ba:	8082                	ret
      panic("virtio_disk_intr status");
    800067bc:	00002517          	auipc	a0,0x2
    800067c0:	01c50513          	addi	a0,a0,28 # 800087d8 <etext+0x7d8>
    800067c4:	ffffa097          	auipc	ra,0xffffa
    800067c8:	d7a080e7          	jalr	-646(ra) # 8000053e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
