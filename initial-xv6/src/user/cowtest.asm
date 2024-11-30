
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_read_only>:

#define PGSIZE 4096
#define NUM_PAGES 16

// Test Read-only process
void test_read_only() {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
    int pid = fork();
   e:	00000097          	auipc	ra,0x0
  12:	656080e7          	jalr	1622(ra) # 664 <fork>
    if (pid == 0) {
  16:	cd11                	beqz	a0,32 <test_read_only+0x32>
            printf("%c", p[i]);
        }
        exit(0);
    } else {
        int status;
        wait(&status);
  18:	fcc40513          	addi	a0,s0,-52
  1c:	00000097          	auipc	ra,0x0
  20:	658080e7          	jalr	1624(ra) # 674 <wait>
    }
}
  24:	70e2                	ld	ra,56(sp)
  26:	7442                	ld	s0,48(sp)
  28:	74a2                	ld	s1,40(sp)
  2a:	7902                	ld	s2,32(sp)
  2c:	69e2                	ld	s3,24(sp)
  2e:	6121                	addi	sp,sp,64
  30:	8082                	ret
  32:	6485                	lui	s1,0x1
            printf("%c", p[i]);
  34:	00001997          	auipc	s3,0x1
  38:	b5c98993          	addi	s3,s3,-1188 # b90 <malloc+0xe6>
        for (int i = 0; i < PGSIZE; i++) {
  3c:	6909                	lui	s2,0x2
            printf("%c", p[i]);
  3e:	0004c583          	lbu	a1,0(s1) # 1000 <fds>
  42:	854e                	mv	a0,s3
  44:	00001097          	auipc	ra,0x1
  48:	9a8080e7          	jalr	-1624(ra) # 9ec <printf>
        for (int i = 0; i < PGSIZE; i++) {
  4c:	0485                	addi	s1,s1,1
  4e:	ff2498e3          	bne	s1,s2,3e <test_read_only+0x3e>
        exit(0);
  52:	4501                	li	a0,0
  54:	00000097          	auipc	ra,0x0
  58:	618080e7          	jalr	1560(ra) # 66c <exit>

000000000000005c <test_read_and_modify>:

// Test Read-only and Modifying processes
void test_read_and_modify() {
  5c:	7139                	addi	sp,sp,-64
  5e:	fc06                	sd	ra,56(sp)
  60:	f822                	sd	s0,48(sp)
  62:	f426                	sd	s1,40(sp)
  64:	f04a                	sd	s2,32(sp)
  66:	ec4e                	sd	s3,24(sp)
  68:	0080                	addi	s0,sp,64
    int pid1 = fork();
  6a:	00000097          	auipc	ra,0x0
  6e:	5fa080e7          	jalr	1530(ra) # 664 <fork>
    if (pid1 == 0) {
  72:	c11d                	beqz	a0,98 <test_read_and_modify+0x3c>
        for (int i = 0; i < PGSIZE; i++) {
            printf("%c", p[i]);
        }
        exit(0);
    } else {
        int pid2 = fork();
  74:	00000097          	auipc	ra,0x0
  78:	5f0080e7          	jalr	1520(ra) # 664 <fork>
        if (pid2 == 0) {
  7c:	c139                	beqz	a0,c2 <test_read_and_modify+0x66>
                p[i] = 'a';
            }
            exit(0);
        } else {
            int status;
            wait(&status);
  7e:	fcc40513          	addi	a0,s0,-52
  82:	00000097          	auipc	ra,0x0
  86:	5f2080e7          	jalr	1522(ra) # 674 <wait>
            // wait(&status);
        }
    }
}
  8a:	70e2                	ld	ra,56(sp)
  8c:	7442                	ld	s0,48(sp)
  8e:	74a2                	ld	s1,40(sp)
  90:	7902                	ld	s2,32(sp)
  92:	69e2                	ld	s3,24(sp)
  94:	6121                	addi	sp,sp,64
  96:	8082                	ret
  98:	6485                	lui	s1,0x1
            printf("%c", p[i]);
  9a:	00001997          	auipc	s3,0x1
  9e:	af698993          	addi	s3,s3,-1290 # b90 <malloc+0xe6>
        for (int i = 0; i < PGSIZE; i++) {
  a2:	6909                	lui	s2,0x2
            printf("%c", p[i]);
  a4:	0004c583          	lbu	a1,0(s1) # 1000 <fds>
  a8:	854e                	mv	a0,s3
  aa:	00001097          	auipc	ra,0x1
  ae:	942080e7          	jalr	-1726(ra) # 9ec <printf>
        for (int i = 0; i < PGSIZE; i++) {
  b2:	0485                	addi	s1,s1,1
  b4:	ff2498e3          	bne	s1,s2,a4 <test_read_and_modify+0x48>
        exit(0);
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	5b2080e7          	jalr	1458(ra) # 66c <exit>
  c2:	6785                	lui	a5,0x1
                p[i] = 'a';
  c4:	06100693          	li	a3,97
            for (int i = 0; i < PGSIZE; i++) {
  c8:	6709                	lui	a4,0x2
                p[i] = 'a';
  ca:	00d78023          	sb	a3,0(a5) # 1000 <fds>
            for (int i = 0; i < PGSIZE; i++) {
  ce:	0785                	addi	a5,a5,1
  d0:	fee79de3          	bne	a5,a4,ca <test_read_and_modify+0x6e>
            exit(0);
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	596080e7          	jalr	1430(ra) # 66c <exit>

00000000000000de <test_complex_modify>:

// Test Complex Modify process
void test_complex_modify() {
  de:	1101                	addi	sp,sp,-32
  e0:	ec06                	sd	ra,24(sp)
  e2:	e822                	sd	s0,16(sp)
  e4:	1000                	addi	s0,sp,32
    int pid = fork();
  e6:	00000097          	auipc	ra,0x0
  ea:	57e080e7          	jalr	1406(ra) # 664 <fork>
    if (pid == 0) {
  ee:	ed29                	bnez	a0,148 <test_complex_modify+0x6a>
  f0:	6709                	lui	a4,0x2
  f2:	757d                	lui	a0,0xfffff
        char *p = (char *)0x1000;
        for (int i = 0; i < NUM_PAGES; i += 2) {
            for (int j = 0; j < PGSIZE; j++) {
                p[i * PGSIZE + j] = 'a';
  f4:	06100693          	li	a3,97
        for (int i = 0; i < NUM_PAGES; i += 2) {
  f8:	6589                	lui	a1,0x2
  fa:	6649                	lui	a2,0x12
            for (int j = 0; j < PGSIZE; j++) {
  fc:	00a707b3          	add	a5,a4,a0
                p[i * PGSIZE + j] = 'a';
 100:	00d78023          	sb	a3,0(a5)
            for (int j = 0; j < PGSIZE; j++) {
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <test_complex_modify+0x22>
        for (int i = 0; i < NUM_PAGES; i += 2) {
 10a:	972e                	add	a4,a4,a1
 10c:	fec718e3          	bne	a4,a2,fc <test_complex_modify+0x1e>
 110:	6689                	lui	a3,0x2
 112:	787d                	lui	a6,0xfffff
            }
        }
        for (int i = 0; i < NUM_PAGES; i += 2) {
            for (int j = 0; j < PGSIZE; j++) {
                if (p[i * PGSIZE + j] != 'a') {
 114:	06100613          	li	a2,97
        for (int i = 0; i < NUM_PAGES; i += 2) {
 118:	6509                	lui	a0,0x2
 11a:	65c9                	lui	a1,0x12
            for (int j = 0; j < PGSIZE; j++) {
 11c:	010687b3          	add	a5,a3,a6
                if (p[i * PGSIZE + j] != 'a') {
 120:	0007c703          	lbu	a4,0(a5)
 124:	00c71d63          	bne	a4,a2,13e <test_complex_modify+0x60>
            for (int j = 0; j < PGSIZE; j++) {
 128:	0785                	addi	a5,a5,1
 12a:	fed79be3          	bne	a5,a3,120 <test_complex_modify+0x42>
        for (int i = 0; i < NUM_PAGES; i += 2) {
 12e:	96aa                	add	a3,a3,a0
 130:	feb696e3          	bne	a3,a1,11c <test_complex_modify+0x3e>
                    // printf("Child (pid=%d): Verification failed at address %p\n", getpid(), p + i * PGSIZE + j);
                    exit(1);
                }
            }
        }
        exit(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	536080e7          	jalr	1334(ra) # 66c <exit>
                    exit(1);
 13e:	4505                	li	a0,1
 140:	00000097          	auipc	ra,0x0
 144:	52c080e7          	jalr	1324(ra) # 66c <exit>
    } else {
        int status;
        wait(&status);
 148:	fec40513          	addi	a0,s0,-20
 14c:	00000097          	auipc	ra,0x0
 150:	528080e7          	jalr	1320(ra) # 674 <wait>
    }
}
 154:	60e2                	ld	ra,24(sp)
 156:	6442                	ld	s0,16(sp)
 158:	6105                	addi	sp,sp,32
 15a:	8082                	ret

000000000000015c <filetest>:
int fds[2];
char buf[4096];

void
filetest()
{
 15c:	7179                	addi	sp,sp,-48
 15e:	f406                	sd	ra,40(sp)
 160:	f022                	sd	s0,32(sp)
 162:	ec26                	sd	s1,24(sp)
 164:	e84a                	sd	s2,16(sp)
 166:	1800                	addi	s0,sp,48
  printf("file: ");
 168:	00001517          	auipc	a0,0x1
 16c:	a3050513          	addi	a0,a0,-1488 # b98 <malloc+0xee>
 170:	00001097          	auipc	ra,0x1
 174:	87c080e7          	jalr	-1924(ra) # 9ec <printf>
  buf[0] = 99;
 178:	06300793          	li	a5,99
 17c:	00001717          	auipc	a4,0x1
 180:	e8f70a23          	sb	a5,-364(a4) # 1010 <buf>
  for(int i = 0; i < 4; i++){
 184:	fc042c23          	sw	zero,-40(s0)
    if(pipe(fds) != 0){
 188:	00001497          	auipc	s1,0x1
 18c:	e7848493          	addi	s1,s1,-392 # 1000 <fds>
  for(int i = 0; i < 4; i++){
 190:	490d                	li	s2,3
    if(pipe(fds) != 0){
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	4e8080e7          	jalr	1256(ra) # 67c <pipe>
 19c:	e149                	bnez	a0,21e <filetest+0xc2>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 19e:	00000097          	auipc	ra,0x0
 1a2:	4c6080e7          	jalr	1222(ra) # 664 <fork>
    if(pid < 0){
 1a6:	08054963          	bltz	a0,238 <filetest+0xdc>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 1aa:	c545                	beqz	a0,252 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 1ac:	4611                	li	a2,4
 1ae:	fd840593          	addi	a1,s0,-40
 1b2:	40c8                	lw	a0,4(s1)
 1b4:	00000097          	auipc	ra,0x0
 1b8:	4d8080e7          	jalr	1240(ra) # 68c <write>
 1bc:	4791                	li	a5,4
 1be:	10f51b63          	bne	a0,a5,2d4 <filetest+0x178>
  for(int i = 0; i < 4; i++){
 1c2:	fd842783          	lw	a5,-40(s0)
 1c6:	2785                	addiw	a5,a5,1
 1c8:	0007871b          	sext.w	a4,a5
 1cc:	fcf42c23          	sw	a5,-40(s0)
 1d0:	fce951e3          	bge	s2,a4,192 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }
  int xstatus = 0;
 1d4:	fc042e23          	sw	zero,-36(s0)
 1d8:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 1da:	fdc40513          	addi	a0,s0,-36
 1de:	00000097          	auipc	ra,0x0
 1e2:	496080e7          	jalr	1174(ra) # 674 <wait>
    if(xstatus != 0) {
 1e6:	fdc42783          	lw	a5,-36(s0)
 1ea:	10079263          	bnez	a5,2ee <filetest+0x192>
  for(int i = 0; i < 4; i++) {
 1ee:	34fd                	addiw	s1,s1,-1
 1f0:	f4ed                	bnez	s1,1da <filetest+0x7e>
      exit(1);
    }
  }
  if(buf[0] != 99){
 1f2:	00001717          	auipc	a4,0x1
 1f6:	e1e74703          	lbu	a4,-482(a4) # 1010 <buf>
 1fa:	06300793          	li	a5,99
 1fe:	0ef71d63          	bne	a4,a5,2f8 <filetest+0x19c>
    printf("error: child overwrote parent\n");
    exit(1);
  }
  printf("ok\n");
 202:	00001517          	auipc	a0,0x1
 206:	a2e50513          	addi	a0,a0,-1490 # c30 <malloc+0x186>
 20a:	00000097          	auipc	ra,0x0
 20e:	7e2080e7          	jalr	2018(ra) # 9ec <printf>
}
 212:	70a2                	ld	ra,40(sp)
 214:	7402                	ld	s0,32(sp)
 216:	64e2                	ld	s1,24(sp)
 218:	6942                	ld	s2,16(sp)
 21a:	6145                	addi	sp,sp,48
 21c:	8082                	ret
      printf("pipe() failed\n");
 21e:	00001517          	auipc	a0,0x1
 222:	98250513          	addi	a0,a0,-1662 # ba0 <malloc+0xf6>
 226:	00000097          	auipc	ra,0x0
 22a:	7c6080e7          	jalr	1990(ra) # 9ec <printf>
      exit(-1);
 22e:	557d                	li	a0,-1
 230:	00000097          	auipc	ra,0x0
 234:	43c080e7          	jalr	1084(ra) # 66c <exit>
      printf("fork failed\n");
 238:	00001517          	auipc	a0,0x1
 23c:	97850513          	addi	a0,a0,-1672 # bb0 <malloc+0x106>
 240:	00000097          	auipc	ra,0x0
 244:	7ac080e7          	jalr	1964(ra) # 9ec <printf>
      exit(-1);
 248:	557d                	li	a0,-1
 24a:	00000097          	auipc	ra,0x0
 24e:	422080e7          	jalr	1058(ra) # 66c <exit>
      sleep(1);
 252:	4505                	li	a0,1
 254:	00000097          	auipc	ra,0x0
 258:	4a8080e7          	jalr	1192(ra) # 6fc <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 25c:	4611                	li	a2,4
 25e:	00001597          	auipc	a1,0x1
 262:	db258593          	addi	a1,a1,-590 # 1010 <buf>
 266:	00001517          	auipc	a0,0x1
 26a:	d9a52503          	lw	a0,-614(a0) # 1000 <fds>
 26e:	00000097          	auipc	ra,0x0
 272:	416080e7          	jalr	1046(ra) # 684 <read>
 276:	4791                	li	a5,4
 278:	02f51c63          	bne	a0,a5,2b0 <filetest+0x154>
      sleep(1);
 27c:	4505                	li	a0,1
 27e:	00000097          	auipc	ra,0x0
 282:	47e080e7          	jalr	1150(ra) # 6fc <sleep>
      if(j != i){
 286:	fd842703          	lw	a4,-40(s0)
 28a:	00001797          	auipc	a5,0x1
 28e:	d867a783          	lw	a5,-634(a5) # 1010 <buf>
 292:	02f70c63          	beq	a4,a5,2ca <filetest+0x16e>
        printf("error: read the wrong value\n");
 296:	00001517          	auipc	a0,0x1
 29a:	94250513          	addi	a0,a0,-1726 # bd8 <malloc+0x12e>
 29e:	00000097          	auipc	ra,0x0
 2a2:	74e080e7          	jalr	1870(ra) # 9ec <printf>
        exit(1);
 2a6:	4505                	li	a0,1
 2a8:	00000097          	auipc	ra,0x0
 2ac:	3c4080e7          	jalr	964(ra) # 66c <exit>
        printf("error: read failed\n");
 2b0:	00001517          	auipc	a0,0x1
 2b4:	91050513          	addi	a0,a0,-1776 # bc0 <malloc+0x116>
 2b8:	00000097          	auipc	ra,0x0
 2bc:	734080e7          	jalr	1844(ra) # 9ec <printf>
        exit(1);
 2c0:	4505                	li	a0,1
 2c2:	00000097          	auipc	ra,0x0
 2c6:	3aa080e7          	jalr	938(ra) # 66c <exit>
      exit(0);
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	3a0080e7          	jalr	928(ra) # 66c <exit>
      printf("error: write failed\n");
 2d4:	00001517          	auipc	a0,0x1
 2d8:	92450513          	addi	a0,a0,-1756 # bf8 <malloc+0x14e>
 2dc:	00000097          	auipc	ra,0x0
 2e0:	710080e7          	jalr	1808(ra) # 9ec <printf>
      exit(-1);
 2e4:	557d                	li	a0,-1
 2e6:	00000097          	auipc	ra,0x0
 2ea:	386080e7          	jalr	902(ra) # 66c <exit>
      exit(1);
 2ee:	4505                	li	a0,1
 2f0:	00000097          	auipc	ra,0x0
 2f4:	37c080e7          	jalr	892(ra) # 66c <exit>
    printf("error: child overwrote parent\n");
 2f8:	00001517          	auipc	a0,0x1
 2fc:	91850513          	addi	a0,a0,-1768 # c10 <malloc+0x166>
 300:	00000097          	auipc	ra,0x0
 304:	6ec080e7          	jalr	1772(ra) # 9ec <printf>
    exit(1);
 308:	4505                	li	a0,1
 30a:	00000097          	auipc	ra,0x0
 30e:	362080e7          	jalr	866(ra) # 66c <exit>

0000000000000312 <main>:

int main() {
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
    printf("Running COW tests...\n");
 31a:	00001517          	auipc	a0,0x1
 31e:	91e50513          	addi	a0,a0,-1762 # c38 <malloc+0x18e>
 322:	00000097          	auipc	ra,0x0
 326:	6ca080e7          	jalr	1738(ra) # 9ec <printf>
    printf("Test 1 starting\n");
 32a:	00001517          	auipc	a0,0x1
 32e:	92650513          	addi	a0,a0,-1754 # c50 <malloc+0x1a6>
 332:	00000097          	auipc	ra,0x0
 336:	6ba080e7          	jalr	1722(ra) # 9ec <printf>
    test_read_only();
 33a:	00000097          	auipc	ra,0x0
 33e:	cc6080e7          	jalr	-826(ra) # 0 <test_read_only>
    printf("Test 1 finished\n");
 342:	00001517          	auipc	a0,0x1
 346:	92650513          	addi	a0,a0,-1754 # c68 <malloc+0x1be>
 34a:	00000097          	auipc	ra,0x0
 34e:	6a2080e7          	jalr	1698(ra) # 9ec <printf>
    printf("Test 2 starting\n");
 352:	00001517          	auipc	a0,0x1
 356:	92e50513          	addi	a0,a0,-1746 # c80 <malloc+0x1d6>
 35a:	00000097          	auipc	ra,0x0
 35e:	692080e7          	jalr	1682(ra) # 9ec <printf>
    test_read_and_modify();
 362:	00000097          	auipc	ra,0x0
 366:	cfa080e7          	jalr	-774(ra) # 5c <test_read_and_modify>
    printf("Test 2 finished\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	92e50513          	addi	a0,a0,-1746 # c98 <malloc+0x1ee>
 372:	00000097          	auipc	ra,0x0
 376:	67a080e7          	jalr	1658(ra) # 9ec <printf>
    printf("Test 3 starting\n");
 37a:	00001517          	auipc	a0,0x1
 37e:	93650513          	addi	a0,a0,-1738 # cb0 <malloc+0x206>
 382:	00000097          	auipc	ra,0x0
 386:	66a080e7          	jalr	1642(ra) # 9ec <printf>
    test_complex_modify();
 38a:	00000097          	auipc	ra,0x0
 38e:	d54080e7          	jalr	-684(ra) # de <test_complex_modify>
    printf("Test 3 finished\n");
 392:	00001517          	auipc	a0,0x1
 396:	93650513          	addi	a0,a0,-1738 # cc8 <malloc+0x21e>
 39a:	00000097          	auipc	ra,0x0
 39e:	652080e7          	jalr	1618(ra) # 9ec <printf>
    printf("Test 4 starting\n");
 3a2:	00001517          	auipc	a0,0x1
 3a6:	93e50513          	addi	a0,a0,-1730 # ce0 <malloc+0x236>
 3aa:	00000097          	auipc	ra,0x0
 3ae:	642080e7          	jalr	1602(ra) # 9ec <printf>
    filetest();
 3b2:	00000097          	auipc	ra,0x0
 3b6:	daa080e7          	jalr	-598(ra) # 15c <filetest>
    printf("Test 4 finished\n");
 3ba:	00001517          	auipc	a0,0x1
 3be:	93e50513          	addi	a0,a0,-1730 # cf8 <malloc+0x24e>
 3c2:	00000097          	auipc	ra,0x0
 3c6:	62a080e7          	jalr	1578(ra) # 9ec <printf>
    printf("ALL COW TESTS FINISHED\n");
 3ca:	00001517          	auipc	a0,0x1
 3ce:	94650513          	addi	a0,a0,-1722 # d10 <malloc+0x266>
 3d2:	00000097          	auipc	ra,0x0
 3d6:	61a080e7          	jalr	1562(ra) # 9ec <printf>
    exit(0);
 3da:	4501                	li	a0,0
 3dc:	00000097          	auipc	ra,0x0
 3e0:	290080e7          	jalr	656(ra) # 66c <exit>

00000000000003e4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f26080e7          	jalr	-218(ra) # 312 <main>
  exit(0);
 3f4:	4501                	li	a0,0
 3f6:	00000097          	auipc	ra,0x0
 3fa:	276080e7          	jalr	630(ra) # 66c <exit>

00000000000003fe <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 404:	87aa                	mv	a5,a0
 406:	0585                	addi	a1,a1,1
 408:	0785                	addi	a5,a5,1
 40a:	fff5c703          	lbu	a4,-1(a1)
 40e:	fee78fa3          	sb	a4,-1(a5)
 412:	fb75                	bnez	a4,406 <strcpy+0x8>
    ;
  return os;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret

000000000000041a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 41a:	1141                	addi	sp,sp,-16
 41c:	e422                	sd	s0,8(sp)
 41e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 420:	00054783          	lbu	a5,0(a0)
 424:	cb91                	beqz	a5,438 <strcmp+0x1e>
 426:	0005c703          	lbu	a4,0(a1)
 42a:	00f71763          	bne	a4,a5,438 <strcmp+0x1e>
    p++, q++;
 42e:	0505                	addi	a0,a0,1
 430:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 432:	00054783          	lbu	a5,0(a0)
 436:	fbe5                	bnez	a5,426 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 438:	0005c503          	lbu	a0,0(a1)
}
 43c:	40a7853b          	subw	a0,a5,a0
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

0000000000000446 <strlen>:

uint
strlen(const char *s)
{
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 44c:	00054783          	lbu	a5,0(a0)
 450:	cf91                	beqz	a5,46c <strlen+0x26>
 452:	0505                	addi	a0,a0,1
 454:	87aa                	mv	a5,a0
 456:	4685                	li	a3,1
 458:	9e89                	subw	a3,a3,a0
 45a:	00f6853b          	addw	a0,a3,a5
 45e:	0785                	addi	a5,a5,1
 460:	fff7c703          	lbu	a4,-1(a5)
 464:	fb7d                	bnez	a4,45a <strlen+0x14>
    ;
  return n;
}
 466:	6422                	ld	s0,8(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  for(n = 0; s[n]; n++)
 46c:	4501                	li	a0,0
 46e:	bfe5                	j	466 <strlen+0x20>

0000000000000470 <memset>:

void*
memset(void *dst, int c, uint n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 476:	ca19                	beqz	a2,48c <memset+0x1c>
 478:	87aa                	mv	a5,a0
 47a:	1602                	slli	a2,a2,0x20
 47c:	9201                	srli	a2,a2,0x20
 47e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 482:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 486:	0785                	addi	a5,a5,1
 488:	fee79de3          	bne	a5,a4,482 <memset+0x12>
  }
  return dst;
}
 48c:	6422                	ld	s0,8(sp)
 48e:	0141                	addi	sp,sp,16
 490:	8082                	ret

0000000000000492 <strchr>:

char*
strchr(const char *s, char c)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  for(; *s; s++)
 498:	00054783          	lbu	a5,0(a0)
 49c:	cb99                	beqz	a5,4b2 <strchr+0x20>
    if(*s == c)
 49e:	00f58763          	beq	a1,a5,4ac <strchr+0x1a>
  for(; *s; s++)
 4a2:	0505                	addi	a0,a0,1
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	fbfd                	bnez	a5,49e <strchr+0xc>
      return (char*)s;
  return 0;
 4aa:	4501                	li	a0,0
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <strchr+0x1a>

00000000000004b6 <gets>:

char*
gets(char *buf, int max)
{
 4b6:	711d                	addi	sp,sp,-96
 4b8:	ec86                	sd	ra,88(sp)
 4ba:	e8a2                	sd	s0,80(sp)
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	e0ca                	sd	s2,64(sp)
 4c0:	fc4e                	sd	s3,56(sp)
 4c2:	f852                	sd	s4,48(sp)
 4c4:	f456                	sd	s5,40(sp)
 4c6:	f05a                	sd	s6,32(sp)
 4c8:	ec5e                	sd	s7,24(sp)
 4ca:	1080                	addi	s0,sp,96
 4cc:	8baa                	mv	s7,a0
 4ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d0:	892a                	mv	s2,a0
 4d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4d4:	4aa9                	li	s5,10
 4d6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4d8:	89a6                	mv	s3,s1
 4da:	2485                	addiw	s1,s1,1
 4dc:	0344d863          	bge	s1,s4,50c <gets+0x56>
    cc = read(0, &c, 1);
 4e0:	4605                	li	a2,1
 4e2:	faf40593          	addi	a1,s0,-81
 4e6:	4501                	li	a0,0
 4e8:	00000097          	auipc	ra,0x0
 4ec:	19c080e7          	jalr	412(ra) # 684 <read>
    if(cc < 1)
 4f0:	00a05e63          	blez	a0,50c <gets+0x56>
    buf[i++] = c;
 4f4:	faf44783          	lbu	a5,-81(s0)
 4f8:	00f90023          	sb	a5,0(s2) # 2000 <buf+0xff0>
    if(c == '\n' || c == '\r')
 4fc:	01578763          	beq	a5,s5,50a <gets+0x54>
 500:	0905                	addi	s2,s2,1
 502:	fd679be3          	bne	a5,s6,4d8 <gets+0x22>
  for(i=0; i+1 < max; ){
 506:	89a6                	mv	s3,s1
 508:	a011                	j	50c <gets+0x56>
 50a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 50c:	99de                	add	s3,s3,s7
 50e:	00098023          	sb	zero,0(s3)
  return buf;
}
 512:	855e                	mv	a0,s7
 514:	60e6                	ld	ra,88(sp)
 516:	6446                	ld	s0,80(sp)
 518:	64a6                	ld	s1,72(sp)
 51a:	6906                	ld	s2,64(sp)
 51c:	79e2                	ld	s3,56(sp)
 51e:	7a42                	ld	s4,48(sp)
 520:	7aa2                	ld	s5,40(sp)
 522:	7b02                	ld	s6,32(sp)
 524:	6be2                	ld	s7,24(sp)
 526:	6125                	addi	sp,sp,96
 528:	8082                	ret

000000000000052a <stat>:

int
stat(const char *n, struct stat *st)
{
 52a:	1101                	addi	sp,sp,-32
 52c:	ec06                	sd	ra,24(sp)
 52e:	e822                	sd	s0,16(sp)
 530:	e426                	sd	s1,8(sp)
 532:	e04a                	sd	s2,0(sp)
 534:	1000                	addi	s0,sp,32
 536:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 538:	4581                	li	a1,0
 53a:	00000097          	auipc	ra,0x0
 53e:	172080e7          	jalr	370(ra) # 6ac <open>
  if(fd < 0)
 542:	02054563          	bltz	a0,56c <stat+0x42>
 546:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 548:	85ca                	mv	a1,s2
 54a:	00000097          	auipc	ra,0x0
 54e:	17a080e7          	jalr	378(ra) # 6c4 <fstat>
 552:	892a                	mv	s2,a0
  close(fd);
 554:	8526                	mv	a0,s1
 556:	00000097          	auipc	ra,0x0
 55a:	13e080e7          	jalr	318(ra) # 694 <close>
  return r;
}
 55e:	854a                	mv	a0,s2
 560:	60e2                	ld	ra,24(sp)
 562:	6442                	ld	s0,16(sp)
 564:	64a2                	ld	s1,8(sp)
 566:	6902                	ld	s2,0(sp)
 568:	6105                	addi	sp,sp,32
 56a:	8082                	ret
    return -1;
 56c:	597d                	li	s2,-1
 56e:	bfc5                	j	55e <stat+0x34>

0000000000000570 <atoi>:

int
atoi(const char *s)
{
 570:	1141                	addi	sp,sp,-16
 572:	e422                	sd	s0,8(sp)
 574:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 576:	00054603          	lbu	a2,0(a0)
 57a:	fd06079b          	addiw	a5,a2,-48 # 11fd0 <base+0xffc0>
 57e:	0ff7f793          	zext.b	a5,a5
 582:	4725                	li	a4,9
 584:	02f76963          	bltu	a4,a5,5b6 <atoi+0x46>
 588:	86aa                	mv	a3,a0
  n = 0;
 58a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 58c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 58e:	0685                	addi	a3,a3,1 # 2001 <buf+0xff1>
 590:	0025179b          	slliw	a5,a0,0x2
 594:	9fa9                	addw	a5,a5,a0
 596:	0017979b          	slliw	a5,a5,0x1
 59a:	9fb1                	addw	a5,a5,a2
 59c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5a0:	0006c603          	lbu	a2,0(a3)
 5a4:	fd06071b          	addiw	a4,a2,-48
 5a8:	0ff77713          	zext.b	a4,a4
 5ac:	fee5f1e3          	bgeu	a1,a4,58e <atoi+0x1e>
  return n;
}
 5b0:	6422                	ld	s0,8(sp)
 5b2:	0141                	addi	sp,sp,16
 5b4:	8082                	ret
  n = 0;
 5b6:	4501                	li	a0,0
 5b8:	bfe5                	j	5b0 <atoi+0x40>

00000000000005ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5ba:	1141                	addi	sp,sp,-16
 5bc:	e422                	sd	s0,8(sp)
 5be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5c0:	02b57463          	bgeu	a0,a1,5e8 <memmove+0x2e>
    while(n-- > 0)
 5c4:	00c05f63          	blez	a2,5e2 <memmove+0x28>
 5c8:	1602                	slli	a2,a2,0x20
 5ca:	9201                	srli	a2,a2,0x20
 5cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 5d2:	0585                	addi	a1,a1,1
 5d4:	0705                	addi	a4,a4,1
 5d6:	fff5c683          	lbu	a3,-1(a1)
 5da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5de:	fee79ae3          	bne	a5,a4,5d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5e2:	6422                	ld	s0,8(sp)
 5e4:	0141                	addi	sp,sp,16
 5e6:	8082                	ret
    dst += n;
 5e8:	00c50733          	add	a4,a0,a2
    src += n;
 5ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5ee:	fec05ae3          	blez	a2,5e2 <memmove+0x28>
 5f2:	fff6079b          	addiw	a5,a2,-1
 5f6:	1782                	slli	a5,a5,0x20
 5f8:	9381                	srli	a5,a5,0x20
 5fa:	fff7c793          	not	a5,a5
 5fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 600:	15fd                	addi	a1,a1,-1
 602:	177d                	addi	a4,a4,-1
 604:	0005c683          	lbu	a3,0(a1)
 608:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 60c:	fee79ae3          	bne	a5,a4,600 <memmove+0x46>
 610:	bfc9                	j	5e2 <memmove+0x28>

0000000000000612 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 612:	1141                	addi	sp,sp,-16
 614:	e422                	sd	s0,8(sp)
 616:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 618:	ca05                	beqz	a2,648 <memcmp+0x36>
 61a:	fff6069b          	addiw	a3,a2,-1
 61e:	1682                	slli	a3,a3,0x20
 620:	9281                	srli	a3,a3,0x20
 622:	0685                	addi	a3,a3,1
 624:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 626:	00054783          	lbu	a5,0(a0)
 62a:	0005c703          	lbu	a4,0(a1)
 62e:	00e79863          	bne	a5,a4,63e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 632:	0505                	addi	a0,a0,1
    p2++;
 634:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 636:	fed518e3          	bne	a0,a3,626 <memcmp+0x14>
  }
  return 0;
 63a:	4501                	li	a0,0
 63c:	a019                	j	642 <memcmp+0x30>
      return *p1 - *p2;
 63e:	40e7853b          	subw	a0,a5,a4
}
 642:	6422                	ld	s0,8(sp)
 644:	0141                	addi	sp,sp,16
 646:	8082                	ret
  return 0;
 648:	4501                	li	a0,0
 64a:	bfe5                	j	642 <memcmp+0x30>

000000000000064c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 64c:	1141                	addi	sp,sp,-16
 64e:	e406                	sd	ra,8(sp)
 650:	e022                	sd	s0,0(sp)
 652:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 654:	00000097          	auipc	ra,0x0
 658:	f66080e7          	jalr	-154(ra) # 5ba <memmove>
}
 65c:	60a2                	ld	ra,8(sp)
 65e:	6402                	ld	s0,0(sp)
 660:	0141                	addi	sp,sp,16
 662:	8082                	ret

0000000000000664 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 664:	4885                	li	a7,1
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <exit>:
.global exit
exit:
 li a7, SYS_exit
 66c:	4889                	li	a7,2
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <wait>:
.global wait
wait:
 li a7, SYS_wait
 674:	488d                	li	a7,3
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 67c:	4891                	li	a7,4
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <read>:
.global read
read:
 li a7, SYS_read
 684:	4895                	li	a7,5
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <write>:
.global write
write:
 li a7, SYS_write
 68c:	48c1                	li	a7,16
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <close>:
.global close
close:
 li a7, SYS_close
 694:	48d5                	li	a7,21
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <kill>:
.global kill
kill:
 li a7, SYS_kill
 69c:	4899                	li	a7,6
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6a4:	489d                	li	a7,7
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <open>:
.global open
open:
 li a7, SYS_open
 6ac:	48bd                	li	a7,15
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6b4:	48c5                	li	a7,17
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6bc:	48c9                	li	a7,18
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6c4:	48a1                	li	a7,8
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <link>:
.global link
link:
 li a7, SYS_link
 6cc:	48cd                	li	a7,19
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6d4:	48d1                	li	a7,20
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6dc:	48a5                	li	a7,9
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6e4:	48a9                	li	a7,10
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ec:	48ad                	li	a7,11
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6f4:	48b1                	li	a7,12
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6fc:	48b5                	li	a7,13
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 704:	48b9                	li	a7,14
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 70c:	48d9                	li	a7,22
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 714:	1101                	addi	sp,sp,-32
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 720:	4605                	li	a2,1
 722:	fef40593          	addi	a1,s0,-17
 726:	00000097          	auipc	ra,0x0
 72a:	f66080e7          	jalr	-154(ra) # 68c <write>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6105                	addi	sp,sp,32
 734:	8082                	ret

0000000000000736 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 736:	7139                	addi	sp,sp,-64
 738:	fc06                	sd	ra,56(sp)
 73a:	f822                	sd	s0,48(sp)
 73c:	f426                	sd	s1,40(sp)
 73e:	f04a                	sd	s2,32(sp)
 740:	ec4e                	sd	s3,24(sp)
 742:	0080                	addi	s0,sp,64
 744:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 746:	c299                	beqz	a3,74c <printint+0x16>
 748:	0805c863          	bltz	a1,7d8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 74c:	2581                	sext.w	a1,a1
  neg = 0;
 74e:	4881                	li	a7,0
 750:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 754:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 756:	2601                	sext.w	a2,a2
 758:	00000517          	auipc	a0,0x0
 75c:	5d850513          	addi	a0,a0,1496 # d30 <digits>
 760:	883a                	mv	a6,a4
 762:	2705                	addiw	a4,a4,1
 764:	02c5f7bb          	remuw	a5,a1,a2
 768:	1782                	slli	a5,a5,0x20
 76a:	9381                	srli	a5,a5,0x20
 76c:	97aa                	add	a5,a5,a0
 76e:	0007c783          	lbu	a5,0(a5)
 772:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 776:	0005879b          	sext.w	a5,a1
 77a:	02c5d5bb          	divuw	a1,a1,a2
 77e:	0685                	addi	a3,a3,1
 780:	fec7f0e3          	bgeu	a5,a2,760 <printint+0x2a>
  if(neg)
 784:	00088b63          	beqz	a7,79a <printint+0x64>
    buf[i++] = '-';
 788:	fd040793          	addi	a5,s0,-48
 78c:	973e                	add	a4,a4,a5
 78e:	02d00793          	li	a5,45
 792:	fef70823          	sb	a5,-16(a4)
 796:	0028071b          	addiw	a4,a6,2 # fffffffffffff002 <base+0xffffffffffffcff2>

  while(--i >= 0)
 79a:	02e05863          	blez	a4,7ca <printint+0x94>
 79e:	fc040793          	addi	a5,s0,-64
 7a2:	00e78933          	add	s2,a5,a4
 7a6:	fff78993          	addi	s3,a5,-1
 7aa:	99ba                	add	s3,s3,a4
 7ac:	377d                	addiw	a4,a4,-1
 7ae:	1702                	slli	a4,a4,0x20
 7b0:	9301                	srli	a4,a4,0x20
 7b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7b6:	fff94583          	lbu	a1,-1(s2)
 7ba:	8526                	mv	a0,s1
 7bc:	00000097          	auipc	ra,0x0
 7c0:	f58080e7          	jalr	-168(ra) # 714 <putc>
  while(--i >= 0)
 7c4:	197d                	addi	s2,s2,-1
 7c6:	ff3918e3          	bne	s2,s3,7b6 <printint+0x80>
}
 7ca:	70e2                	ld	ra,56(sp)
 7cc:	7442                	ld	s0,48(sp)
 7ce:	74a2                	ld	s1,40(sp)
 7d0:	7902                	ld	s2,32(sp)
 7d2:	69e2                	ld	s3,24(sp)
 7d4:	6121                	addi	sp,sp,64
 7d6:	8082                	ret
    x = -xx;
 7d8:	40b005bb          	negw	a1,a1
    neg = 1;
 7dc:	4885                	li	a7,1
    x = -xx;
 7de:	bf8d                	j	750 <printint+0x1a>

00000000000007e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e0:	7119                	addi	sp,sp,-128
 7e2:	fc86                	sd	ra,120(sp)
 7e4:	f8a2                	sd	s0,112(sp)
 7e6:	f4a6                	sd	s1,104(sp)
 7e8:	f0ca                	sd	s2,96(sp)
 7ea:	ecce                	sd	s3,88(sp)
 7ec:	e8d2                	sd	s4,80(sp)
 7ee:	e4d6                	sd	s5,72(sp)
 7f0:	e0da                	sd	s6,64(sp)
 7f2:	fc5e                	sd	s7,56(sp)
 7f4:	f862                	sd	s8,48(sp)
 7f6:	f466                	sd	s9,40(sp)
 7f8:	f06a                	sd	s10,32(sp)
 7fa:	ec6e                	sd	s11,24(sp)
 7fc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7fe:	0005c903          	lbu	s2,0(a1)
 802:	18090f63          	beqz	s2,9a0 <vprintf+0x1c0>
 806:	8aaa                	mv	s5,a0
 808:	8b32                	mv	s6,a2
 80a:	00158493          	addi	s1,a1,1
  state = 0;
 80e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 810:	02500a13          	li	s4,37
      if(c == 'd'){
 814:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 818:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 81c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 820:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 824:	00000b97          	auipc	s7,0x0
 828:	50cb8b93          	addi	s7,s7,1292 # d30 <digits>
 82c:	a839                	j	84a <vprintf+0x6a>
        putc(fd, c);
 82e:	85ca                	mv	a1,s2
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	ee2080e7          	jalr	-286(ra) # 714 <putc>
 83a:	a019                	j	840 <vprintf+0x60>
    } else if(state == '%'){
 83c:	01498f63          	beq	s3,s4,85a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 840:	0485                	addi	s1,s1,1
 842:	fff4c903          	lbu	s2,-1(s1)
 846:	14090d63          	beqz	s2,9a0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 84a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 84e:	fe0997e3          	bnez	s3,83c <vprintf+0x5c>
      if(c == '%'){
 852:	fd479ee3          	bne	a5,s4,82e <vprintf+0x4e>
        state = '%';
 856:	89be                	mv	s3,a5
 858:	b7e5                	j	840 <vprintf+0x60>
      if(c == 'd'){
 85a:	05878063          	beq	a5,s8,89a <vprintf+0xba>
      } else if(c == 'l') {
 85e:	05978c63          	beq	a5,s9,8b6 <vprintf+0xd6>
      } else if(c == 'x') {
 862:	07a78863          	beq	a5,s10,8d2 <vprintf+0xf2>
      } else if(c == 'p') {
 866:	09b78463          	beq	a5,s11,8ee <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 86a:	07300713          	li	a4,115
 86e:	0ce78663          	beq	a5,a4,93a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 872:	06300713          	li	a4,99
 876:	0ee78e63          	beq	a5,a4,972 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 87a:	11478863          	beq	a5,s4,98a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 87e:	85d2                	mv	a1,s4
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	e92080e7          	jalr	-366(ra) # 714 <putc>
        putc(fd, c);
 88a:	85ca                	mv	a1,s2
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	e86080e7          	jalr	-378(ra) # 714 <putc>
      }
      state = 0;
 896:	4981                	li	s3,0
 898:	b765                	j	840 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 89a:	008b0913          	addi	s2,s6,8
 89e:	4685                	li	a3,1
 8a0:	4629                	li	a2,10
 8a2:	000b2583          	lw	a1,0(s6)
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	e8e080e7          	jalr	-370(ra) # 736 <printint>
 8b0:	8b4a                	mv	s6,s2
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	b771                	j	840 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b6:	008b0913          	addi	s2,s6,8
 8ba:	4681                	li	a3,0
 8bc:	4629                	li	a2,10
 8be:	000b2583          	lw	a1,0(s6)
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e72080e7          	jalr	-398(ra) # 736 <printint>
 8cc:	8b4a                	mv	s6,s2
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	bf85                	j	840 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8d2:	008b0913          	addi	s2,s6,8
 8d6:	4681                	li	a3,0
 8d8:	4641                	li	a2,16
 8da:	000b2583          	lw	a1,0(s6)
 8de:	8556                	mv	a0,s5
 8e0:	00000097          	auipc	ra,0x0
 8e4:	e56080e7          	jalr	-426(ra) # 736 <printint>
 8e8:	8b4a                	mv	s6,s2
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	bf91                	j	840 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8ee:	008b0793          	addi	a5,s6,8
 8f2:	f8f43423          	sd	a5,-120(s0)
 8f6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8fa:	03000593          	li	a1,48
 8fe:	8556                	mv	a0,s5
 900:	00000097          	auipc	ra,0x0
 904:	e14080e7          	jalr	-492(ra) # 714 <putc>
  putc(fd, 'x');
 908:	85ea                	mv	a1,s10
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	e08080e7          	jalr	-504(ra) # 714 <putc>
 914:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 916:	03c9d793          	srli	a5,s3,0x3c
 91a:	97de                	add	a5,a5,s7
 91c:	0007c583          	lbu	a1,0(a5)
 920:	8556                	mv	a0,s5
 922:	00000097          	auipc	ra,0x0
 926:	df2080e7          	jalr	-526(ra) # 714 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 92a:	0992                	slli	s3,s3,0x4
 92c:	397d                	addiw	s2,s2,-1
 92e:	fe0914e3          	bnez	s2,916 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 932:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 936:	4981                	li	s3,0
 938:	b721                	j	840 <vprintf+0x60>
        s = va_arg(ap, char*);
 93a:	008b0993          	addi	s3,s6,8
 93e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 942:	02090163          	beqz	s2,964 <vprintf+0x184>
        while(*s != 0){
 946:	00094583          	lbu	a1,0(s2)
 94a:	c9a1                	beqz	a1,99a <vprintf+0x1ba>
          putc(fd, *s);
 94c:	8556                	mv	a0,s5
 94e:	00000097          	auipc	ra,0x0
 952:	dc6080e7          	jalr	-570(ra) # 714 <putc>
          s++;
 956:	0905                	addi	s2,s2,1
        while(*s != 0){
 958:	00094583          	lbu	a1,0(s2)
 95c:	f9e5                	bnez	a1,94c <vprintf+0x16c>
        s = va_arg(ap, char*);
 95e:	8b4e                	mv	s6,s3
      state = 0;
 960:	4981                	li	s3,0
 962:	bdf9                	j	840 <vprintf+0x60>
          s = "(null)";
 964:	00000917          	auipc	s2,0x0
 968:	3c490913          	addi	s2,s2,964 # d28 <malloc+0x27e>
        while(*s != 0){
 96c:	02800593          	li	a1,40
 970:	bff1                	j	94c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 972:	008b0913          	addi	s2,s6,8
 976:	000b4583          	lbu	a1,0(s6)
 97a:	8556                	mv	a0,s5
 97c:	00000097          	auipc	ra,0x0
 980:	d98080e7          	jalr	-616(ra) # 714 <putc>
 984:	8b4a                	mv	s6,s2
      state = 0;
 986:	4981                	li	s3,0
 988:	bd65                	j	840 <vprintf+0x60>
        putc(fd, c);
 98a:	85d2                	mv	a1,s4
 98c:	8556                	mv	a0,s5
 98e:	00000097          	auipc	ra,0x0
 992:	d86080e7          	jalr	-634(ra) # 714 <putc>
      state = 0;
 996:	4981                	li	s3,0
 998:	b565                	j	840 <vprintf+0x60>
        s = va_arg(ap, char*);
 99a:	8b4e                	mv	s6,s3
      state = 0;
 99c:	4981                	li	s3,0
 99e:	b54d                	j	840 <vprintf+0x60>
    }
  }
}
 9a0:	70e6                	ld	ra,120(sp)
 9a2:	7446                	ld	s0,112(sp)
 9a4:	74a6                	ld	s1,104(sp)
 9a6:	7906                	ld	s2,96(sp)
 9a8:	69e6                	ld	s3,88(sp)
 9aa:	6a46                	ld	s4,80(sp)
 9ac:	6aa6                	ld	s5,72(sp)
 9ae:	6b06                	ld	s6,64(sp)
 9b0:	7be2                	ld	s7,56(sp)
 9b2:	7c42                	ld	s8,48(sp)
 9b4:	7ca2                	ld	s9,40(sp)
 9b6:	7d02                	ld	s10,32(sp)
 9b8:	6de2                	ld	s11,24(sp)
 9ba:	6109                	addi	sp,sp,128
 9bc:	8082                	ret

00000000000009be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9be:	715d                	addi	sp,sp,-80
 9c0:	ec06                	sd	ra,24(sp)
 9c2:	e822                	sd	s0,16(sp)
 9c4:	1000                	addi	s0,sp,32
 9c6:	e010                	sd	a2,0(s0)
 9c8:	e414                	sd	a3,8(s0)
 9ca:	e818                	sd	a4,16(s0)
 9cc:	ec1c                	sd	a5,24(s0)
 9ce:	03043023          	sd	a6,32(s0)
 9d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9da:	8622                	mv	a2,s0
 9dc:	00000097          	auipc	ra,0x0
 9e0:	e04080e7          	jalr	-508(ra) # 7e0 <vprintf>
}
 9e4:	60e2                	ld	ra,24(sp)
 9e6:	6442                	ld	s0,16(sp)
 9e8:	6161                	addi	sp,sp,80
 9ea:	8082                	ret

00000000000009ec <printf>:

void
printf(const char *fmt, ...)
{
 9ec:	711d                	addi	sp,sp,-96
 9ee:	ec06                	sd	ra,24(sp)
 9f0:	e822                	sd	s0,16(sp)
 9f2:	1000                	addi	s0,sp,32
 9f4:	e40c                	sd	a1,8(s0)
 9f6:	e810                	sd	a2,16(s0)
 9f8:	ec14                	sd	a3,24(s0)
 9fa:	f018                	sd	a4,32(s0)
 9fc:	f41c                	sd	a5,40(s0)
 9fe:	03043823          	sd	a6,48(s0)
 a02:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a06:	00840613          	addi	a2,s0,8
 a0a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a0e:	85aa                	mv	a1,a0
 a10:	4505                	li	a0,1
 a12:	00000097          	auipc	ra,0x0
 a16:	dce080e7          	jalr	-562(ra) # 7e0 <vprintf>
}
 a1a:	60e2                	ld	ra,24(sp)
 a1c:	6442                	ld	s0,16(sp)
 a1e:	6125                	addi	sp,sp,96
 a20:	8082                	ret

0000000000000a22 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a22:	1141                	addi	sp,sp,-16
 a24:	e422                	sd	s0,8(sp)
 a26:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a28:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2c:	00000797          	auipc	a5,0x0
 a30:	5dc7b783          	ld	a5,1500(a5) # 1008 <freep>
 a34:	a805                	j	a64 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a36:	4618                	lw	a4,8(a2)
 a38:	9db9                	addw	a1,a1,a4
 a3a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a3e:	6398                	ld	a4,0(a5)
 a40:	6318                	ld	a4,0(a4)
 a42:	fee53823          	sd	a4,-16(a0)
 a46:	a091                	j	a8a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a48:	ff852703          	lw	a4,-8(a0)
 a4c:	9e39                	addw	a2,a2,a4
 a4e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a50:	ff053703          	ld	a4,-16(a0)
 a54:	e398                	sd	a4,0(a5)
 a56:	a099                	j	a9c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a58:	6398                	ld	a4,0(a5)
 a5a:	00e7e463          	bltu	a5,a4,a62 <free+0x40>
 a5e:	00e6ea63          	bltu	a3,a4,a72 <free+0x50>
{
 a62:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a64:	fed7fae3          	bgeu	a5,a3,a58 <free+0x36>
 a68:	6398                	ld	a4,0(a5)
 a6a:	00e6e463          	bltu	a3,a4,a72 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6e:	fee7eae3          	bltu	a5,a4,a62 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a72:	ff852583          	lw	a1,-8(a0)
 a76:	6390                	ld	a2,0(a5)
 a78:	02059713          	slli	a4,a1,0x20
 a7c:	9301                	srli	a4,a4,0x20
 a7e:	0712                	slli	a4,a4,0x4
 a80:	9736                	add	a4,a4,a3
 a82:	fae60ae3          	beq	a2,a4,a36 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a86:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a8a:	4790                	lw	a2,8(a5)
 a8c:	02061713          	slli	a4,a2,0x20
 a90:	9301                	srli	a4,a4,0x20
 a92:	0712                	slli	a4,a4,0x4
 a94:	973e                	add	a4,a4,a5
 a96:	fae689e3          	beq	a3,a4,a48 <free+0x26>
  } else
    p->s.ptr = bp;
 a9a:	e394                	sd	a3,0(a5)
  freep = p;
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56f73623          	sd	a5,1388(a4) # 1008 <freep>
}
 aa4:	6422                	ld	s0,8(sp)
 aa6:	0141                	addi	sp,sp,16
 aa8:	8082                	ret

0000000000000aaa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aaa:	7139                	addi	sp,sp,-64
 aac:	fc06                	sd	ra,56(sp)
 aae:	f822                	sd	s0,48(sp)
 ab0:	f426                	sd	s1,40(sp)
 ab2:	f04a                	sd	s2,32(sp)
 ab4:	ec4e                	sd	s3,24(sp)
 ab6:	e852                	sd	s4,16(sp)
 ab8:	e456                	sd	s5,8(sp)
 aba:	e05a                	sd	s6,0(sp)
 abc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 abe:	02051493          	slli	s1,a0,0x20
 ac2:	9081                	srli	s1,s1,0x20
 ac4:	04bd                	addi	s1,s1,15
 ac6:	8091                	srli	s1,s1,0x4
 ac8:	0014899b          	addiw	s3,s1,1
 acc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ace:	00000517          	auipc	a0,0x0
 ad2:	53a53503          	ld	a0,1338(a0) # 1008 <freep>
 ad6:	c515                	beqz	a0,b02 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ada:	4798                	lw	a4,8(a5)
 adc:	02977f63          	bgeu	a4,s1,b1a <malloc+0x70>
 ae0:	8a4e                	mv	s4,s3
 ae2:	0009871b          	sext.w	a4,s3
 ae6:	6685                	lui	a3,0x1
 ae8:	00d77363          	bgeu	a4,a3,aee <malloc+0x44>
 aec:	6a05                	lui	s4,0x1
 aee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 af2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 af6:	00000917          	auipc	s2,0x0
 afa:	51290913          	addi	s2,s2,1298 # 1008 <freep>
  if(p == (char*)-1)
 afe:	5afd                	li	s5,-1
 b00:	a88d                	j	b72 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b02:	00001797          	auipc	a5,0x1
 b06:	50e78793          	addi	a5,a5,1294 # 2010 <base>
 b0a:	00000717          	auipc	a4,0x0
 b0e:	4ef73f23          	sd	a5,1278(a4) # 1008 <freep>
 b12:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b14:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b18:	b7e1                	j	ae0 <malloc+0x36>
      if(p->s.size == nunits)
 b1a:	02e48b63          	beq	s1,a4,b50 <malloc+0xa6>
        p->s.size -= nunits;
 b1e:	4137073b          	subw	a4,a4,s3
 b22:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b24:	1702                	slli	a4,a4,0x20
 b26:	9301                	srli	a4,a4,0x20
 b28:	0712                	slli	a4,a4,0x4
 b2a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b2c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b30:	00000717          	auipc	a4,0x0
 b34:	4ca73c23          	sd	a0,1240(a4) # 1008 <freep>
      return (void*)(p + 1);
 b38:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b3c:	70e2                	ld	ra,56(sp)
 b3e:	7442                	ld	s0,48(sp)
 b40:	74a2                	ld	s1,40(sp)
 b42:	7902                	ld	s2,32(sp)
 b44:	69e2                	ld	s3,24(sp)
 b46:	6a42                	ld	s4,16(sp)
 b48:	6aa2                	ld	s5,8(sp)
 b4a:	6b02                	ld	s6,0(sp)
 b4c:	6121                	addi	sp,sp,64
 b4e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b50:	6398                	ld	a4,0(a5)
 b52:	e118                	sd	a4,0(a0)
 b54:	bff1                	j	b30 <malloc+0x86>
  hp->s.size = nu;
 b56:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b5a:	0541                	addi	a0,a0,16
 b5c:	00000097          	auipc	ra,0x0
 b60:	ec6080e7          	jalr	-314(ra) # a22 <free>
  return freep;
 b64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b68:	d971                	beqz	a0,b3c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b6c:	4798                	lw	a4,8(a5)
 b6e:	fa9776e3          	bgeu	a4,s1,b1a <malloc+0x70>
    if(p == freep)
 b72:	00093703          	ld	a4,0(s2)
 b76:	853e                	mv	a0,a5
 b78:	fef719e3          	bne	a4,a5,b6a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b7c:	8552                	mv	a0,s4
 b7e:	00000097          	auipc	ra,0x0
 b82:	b76080e7          	jalr	-1162(ra) # 6f4 <sbrk>
  if(p == (char*)-1)
 b86:	fd5518e3          	bne	a0,s5,b56 <malloc+0xac>
        return 0;
 b8a:	4501                	li	a0,0
 b8c:	bf45                	j	b3c <malloc+0x92>
