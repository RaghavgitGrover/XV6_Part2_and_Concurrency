
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bf8080e7          	jalr	-1032(ra) # 5c08 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	be6080e7          	jalr	-1050(ra) # 5c08 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0d250513          	addi	a0,a0,210 # 6110 <malloc+0x10a>
      46:	00006097          	auipc	ra,0x6
      4a:	f02080e7          	jalr	-254(ra) # 5f48 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b78080e7          	jalr	-1160(ra) # 5bc8 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0b050513          	addi	a0,a0,176 # 6130 <malloc+0x12a>
      88:	00006097          	auipc	ra,0x6
      8c:	ec0080e7          	jalr	-320(ra) # 5f48 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b36080e7          	jalr	-1226(ra) # 5bc8 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0a050513          	addi	a0,a0,160 # 6148 <malloc+0x142>
      b0:	00006097          	auipc	ra,0x6
      b4:	b58080e7          	jalr	-1192(ra) # 5c08 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b34080e7          	jalr	-1228(ra) # 5bf0 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0a250513          	addi	a0,a0,162 # 6168 <malloc+0x162>
      ce:	00006097          	auipc	ra,0x6
      d2:	b3a080e7          	jalr	-1222(ra) # 5c08 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	06a50513          	addi	a0,a0,106 # 6150 <malloc+0x14a>
      ee:	00006097          	auipc	ra,0x6
      f2:	e5a080e7          	jalr	-422(ra) # 5f48 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	ad0080e7          	jalr	-1328(ra) # 5bc8 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	07650513          	addi	a0,a0,118 # 6178 <malloc+0x172>
     10a:	00006097          	auipc	ra,0x6
     10e:	e3e080e7          	jalr	-450(ra) # 5f48 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ab4080e7          	jalr	-1356(ra) # 5bc8 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	07450513          	addi	a0,a0,116 # 61a0 <malloc+0x19a>
     134:	00006097          	auipc	ra,0x6
     138:	ae4080e7          	jalr	-1308(ra) # 5c18 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	06050513          	addi	a0,a0,96 # 61a0 <malloc+0x19a>
     148:	00006097          	auipc	ra,0x6
     14c:	ac0080e7          	jalr	-1344(ra) # 5c08 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	05c58593          	addi	a1,a1,92 # 61b0 <malloc+0x1aa>
     15c:	00006097          	auipc	ra,0x6
     160:	a8c080e7          	jalr	-1396(ra) # 5be8 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	03850513          	addi	a0,a0,56 # 61a0 <malloc+0x19a>
     170:	00006097          	auipc	ra,0x6
     174:	a98080e7          	jalr	-1384(ra) # 5c08 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	03c58593          	addi	a1,a1,60 # 61b8 <malloc+0x1b2>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a62080e7          	jalr	-1438(ra) # 5be8 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	00c50513          	addi	a0,a0,12 # 61a0 <malloc+0x19a>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a7c080e7          	jalr	-1412(ra) # 5c18 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a4a080e7          	jalr	-1462(ra) # 5bf0 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a40080e7          	jalr	-1472(ra) # 5bf0 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	ff650513          	addi	a0,a0,-10 # 61c0 <malloc+0x1ba>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d76080e7          	jalr	-650(ra) # 5f48 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9ec080e7          	jalr	-1556(ra) # 5bc8 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9f8080e7          	jalr	-1544(ra) # 5c08 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9d8080e7          	jalr	-1576(ra) # 5bf0 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9d2080e7          	jalr	-1582(ra) # 5c18 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f6c50513          	addi	a0,a0,-148 # 61e8 <malloc+0x1e2>
     284:	00006097          	auipc	ra,0x6
     288:	994080e7          	jalr	-1644(ra) # 5c18 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f58a8a93          	addi	s5,s5,-168 # 61e8 <malloc+0x1e2>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x1a3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	95c080e7          	jalr	-1700(ra) # 5c08 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	92a080e7          	jalr	-1750(ra) # 5be8 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	916080e7          	jalr	-1770(ra) # 5be8 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	910080e7          	jalr	-1776(ra) # 5bf0 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	92e080e7          	jalr	-1746(ra) # 5c18 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ee650513          	addi	a0,a0,-282 # 61f8 <malloc+0x1f2>
     31a:	00006097          	auipc	ra,0x6
     31e:	c2e080e7          	jalr	-978(ra) # 5f48 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8a4080e7          	jalr	-1884(ra) # 5bc8 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	ee250513          	addi	a0,a0,-286 # 6218 <malloc+0x212>
     33e:	00006097          	auipc	ra,0x6
     342:	c0a080e7          	jalr	-1014(ra) # 5f48 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	880080e7          	jalr	-1920(ra) # 5bc8 <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	ed050513          	addi	a0,a0,-304 # 6230 <malloc+0x22a>
     368:	00006097          	auipc	ra,0x6
     36c:	8b0080e7          	jalr	-1872(ra) # 5c18 <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	ebc98993          	addi	s3,s3,-324 # 6230 <malloc+0x22a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	880080e7          	jalr	-1920(ra) # 5c08 <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	84e080e7          	jalr	-1970(ra) # 5be8 <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	84c080e7          	jalr	-1972(ra) # 5bf0 <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	86a080e7          	jalr	-1942(ra) # 5c18 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	e7050513          	addi	a0,a0,-400 # 6230 <malloc+0x22a>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	840080e7          	jalr	-1984(ra) # 5c08 <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	de058593          	addi	a1,a1,-544 # 61b8 <malloc+0x1b2>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	808080e7          	jalr	-2040(ra) # 5be8 <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e6250513          	addi	a0,a0,-414 # 6250 <malloc+0x24a>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b52080e7          	jalr	-1198(ra) # 5f48 <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7c8080e7          	jalr	1992(ra) # 5bc8 <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e3050513          	addi	a0,a0,-464 # 6238 <malloc+0x232>
     410:	00006097          	auipc	ra,0x6
     414:	b38080e7          	jalr	-1224(ra) # 5f48 <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7ae080e7          	jalr	1966(ra) # 5bc8 <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e1650513          	addi	a0,a0,-490 # 6238 <malloc+0x232>
     42a:	00006097          	auipc	ra,0x6
     42e:	b1e080e7          	jalr	-1250(ra) # 5f48 <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	794080e7          	jalr	1940(ra) # 5bc8 <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7b2080e7          	jalr	1970(ra) # 5bf0 <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	dea50513          	addi	a0,a0,-534 # 6230 <malloc+0x22a>
     44e:	00005097          	auipc	ra,0x5
     452:	7ca080e7          	jalr	1994(ra) # 5c18 <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	770080e7          	jalr	1904(ra) # 5bc8 <exit>

0000000000000460 <outofinodes>:
//   }
// }

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	76c080e7          	jalr	1900(ra) # 5c18 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	74c080e7          	jalr	1868(ra) # 5c08 <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	728080e7          	jalr	1832(ra) # 5bf0 <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	704080e7          	jalr	1796(ra) # 5c18 <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d0ea0a13          	addi	s4,s4,-754 # 6260 <malloc+0x25a>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6a4080e7          	jalr	1700(ra) # 5c08 <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	672080e7          	jalr	1650(ra) # 5be8 <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	66c080e7          	jalr	1644(ra) # 5bf0 <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	68a080e7          	jalr	1674(ra) # 5c18 <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	64c080e7          	jalr	1612(ra) # 5be8 <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	62c080e7          	jalr	1580(ra) # 5bd8 <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	628080e7          	jalr	1576(ra) # 5be8 <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	620080e7          	jalr	1568(ra) # 5bf0 <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	614080e7          	jalr	1556(ra) # 5bf0 <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c6a50513          	addi	a0,a0,-918 # 6268 <malloc+0x262>
     606:	00006097          	auipc	ra,0x6
     60a:	942080e7          	jalr	-1726(ra) # 5f48 <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5b8080e7          	jalr	1464(ra) # 5bc8 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c6450513          	addi	a0,a0,-924 # 6280 <malloc+0x27a>
     624:	00006097          	auipc	ra,0x6
     628:	924080e7          	jalr	-1756(ra) # 5f48 <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	59a080e7          	jalr	1434(ra) # 5bc8 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	c7650513          	addi	a0,a0,-906 # 62b0 <malloc+0x2aa>
     642:	00006097          	auipc	ra,0x6
     646:	906080e7          	jalr	-1786(ra) # 5f48 <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	57c080e7          	jalr	1404(ra) # 5bc8 <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	c8c50513          	addi	a0,a0,-884 # 62e0 <malloc+0x2da>
     65c:	00006097          	auipc	ra,0x6
     660:	8ec080e7          	jalr	-1812(ra) # 5f48 <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	562080e7          	jalr	1378(ra) # 5bc8 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	c7e50513          	addi	a0,a0,-898 # 62f0 <malloc+0x2ea>
     67a:	00006097          	auipc	ra,0x6
     67e:	8ce080e7          	jalr	-1842(ra) # 5f48 <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	544080e7          	jalr	1348(ra) # 5bc8 <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69e:	4785                	li	a5,1
     6a0:	07fe                	slli	a5,a5,0x1f
     6a2:	faf43823          	sd	a5,-80(s0)
     6a6:	57fd                	li	a5,-1
     6a8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6ac:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6b0:	00006a17          	auipc	s4,0x6
     6b4:	c70a0a13          	addi	s4,s4,-912 # 6320 <malloc+0x31a>
    n = write(fds[1], "x", 1);
     6b8:	00006a97          	auipc	s5,0x6
     6bc:	b00a8a93          	addi	s5,s5,-1280 # 61b8 <malloc+0x1b2>
    uint64 addr = addrs[ai];
     6c0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c4:	4581                	li	a1,0
     6c6:	8552                	mv	a0,s4
     6c8:	00005097          	auipc	ra,0x5
     6cc:	540080e7          	jalr	1344(ra) # 5c08 <open>
     6d0:	84aa                	mv	s1,a0
    if(fd < 0){
     6d2:	08054663          	bltz	a0,75e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d6:	6609                	lui	a2,0x2
     6d8:	85ce                	mv	a1,s3
     6da:	00005097          	auipc	ra,0x5
     6de:	506080e7          	jalr	1286(ra) # 5be0 <read>
    if(n > 0){
     6e2:	08a04b63          	bgtz	a0,778 <copyout+0xec>
    close(fd);
     6e6:	8526                	mv	a0,s1
     6e8:	00005097          	auipc	ra,0x5
     6ec:	508080e7          	jalr	1288(ra) # 5bf0 <close>
    if(pipe(fds) < 0){
     6f0:	fa840513          	addi	a0,s0,-88
     6f4:	00005097          	auipc	ra,0x5
     6f8:	4e4080e7          	jalr	1252(ra) # 5bd8 <pipe>
     6fc:	08054d63          	bltz	a0,796 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     700:	4605                	li	a2,1
     702:	85d6                	mv	a1,s5
     704:	fac42503          	lw	a0,-84(s0)
     708:	00005097          	auipc	ra,0x5
     70c:	4e0080e7          	jalr	1248(ra) # 5be8 <write>
    if(n != 1){
     710:	4785                	li	a5,1
     712:	08f51f63          	bne	a0,a5,7b0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     716:	6609                	lui	a2,0x2
     718:	85ce                	mv	a1,s3
     71a:	fa842503          	lw	a0,-88(s0)
     71e:	00005097          	auipc	ra,0x5
     722:	4c2080e7          	jalr	1218(ra) # 5be0 <read>
    if(n > 0){
     726:	0aa04263          	bgtz	a0,7ca <copyout+0x13e>
    close(fds[0]);
     72a:	fa842503          	lw	a0,-88(s0)
     72e:	00005097          	auipc	ra,0x5
     732:	4c2080e7          	jalr	1218(ra) # 5bf0 <close>
    close(fds[1]);
     736:	fac42503          	lw	a0,-84(s0)
     73a:	00005097          	auipc	ra,0x5
     73e:	4b6080e7          	jalr	1206(ra) # 5bf0 <close>
  for(int ai = 0; ai < 2; ai++){
     742:	0921                	addi	s2,s2,8
     744:	fc040793          	addi	a5,s0,-64
     748:	f6f91ce3          	bne	s2,a5,6c0 <copyout+0x34>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	bca50513          	addi	a0,a0,-1078 # 6328 <malloc+0x322>
     766:	00005097          	auipc	ra,0x5
     76a:	7e2080e7          	jalr	2018(ra) # 5f48 <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	458080e7          	jalr	1112(ra) # 5bc8 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	bc450513          	addi	a0,a0,-1084 # 6340 <malloc+0x33a>
     784:	00005097          	auipc	ra,0x5
     788:	7c4080e7          	jalr	1988(ra) # 5f48 <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	43a080e7          	jalr	1082(ra) # 5bc8 <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	b4a50513          	addi	a0,a0,-1206 # 62e0 <malloc+0x2da>
     79e:	00005097          	auipc	ra,0x5
     7a2:	7aa080e7          	jalr	1962(ra) # 5f48 <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	420080e7          	jalr	1056(ra) # 5bc8 <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	bc050513          	addi	a0,a0,-1088 # 6370 <malloc+0x36a>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	790080e7          	jalr	1936(ra) # 5f48 <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	406080e7          	jalr	1030(ra) # 5bc8 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	bba50513          	addi	a0,a0,-1094 # 6388 <malloc+0x382>
     7d6:	00005097          	auipc	ra,0x5
     7da:	772080e7          	jalr	1906(ra) # 5f48 <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	3e8080e7          	jalr	1000(ra) # 5bc8 <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	addi	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	addi	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	9a450513          	addi	a0,a0,-1628 # 61a0 <malloc+0x19a>
     804:	00005097          	auipc	ra,0x5
     808:	414080e7          	jalr	1044(ra) # 5c18 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	99050513          	addi	a0,a0,-1648 # 61a0 <malloc+0x19a>
     818:	00005097          	auipc	ra,0x5
     81c:	3f0080e7          	jalr	1008(ra) # 5c08 <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	98c58593          	addi	a1,a1,-1652 # 61b0 <malloc+0x1aa>
     82c:	00005097          	auipc	ra,0x5
     830:	3bc080e7          	jalr	956(ra) # 5be8 <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	3ba080e7          	jalr	954(ra) # 5bf0 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	96050513          	addi	a0,a0,-1696 # 61a0 <malloc+0x19a>
     848:	00005097          	auipc	ra,0x5
     84c:	3c0080e7          	jalr	960(ra) # 5c08 <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	addi	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	386080e7          	jalr	902(ra) # 5be0 <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	93450513          	addi	a0,a0,-1740 # 61a0 <malloc+0x19a>
     874:	00005097          	auipc	ra,0x5
     878:	394080e7          	jalr	916(ra) # 5c08 <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	92050513          	addi	a0,a0,-1760 # 61a0 <malloc+0x19a>
     888:	00005097          	auipc	ra,0x5
     88c:	380080e7          	jalr	896(ra) # 5c08 <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	addi	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	346080e7          	jalr	838(ra) # 5be0 <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	addi	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	330080e7          	jalr	816(ra) # 5be0 <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	b5a58593          	addi	a1,a1,-1190 # 6418 <malloc+0x412>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	320080e7          	jalr	800(ra) # 5be8 <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	addi	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	306080e7          	jalr	774(ra) # 5be0 <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	addi	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	2ee080e7          	jalr	750(ra) # 5be0 <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	8a050513          	addi	a0,a0,-1888 # 61a0 <malloc+0x19a>
     908:	00005097          	auipc	ra,0x5
     90c:	310080e7          	jalr	784(ra) # 5c18 <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	2de080e7          	jalr	734(ra) # 5bf0 <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	2d4080e7          	jalr	724(ra) # 5bf0 <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	2ca080e7          	jalr	714(ra) # 5bf0 <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	addi	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	a7450513          	addi	a0,a0,-1420 # 63b8 <malloc+0x3b2>
     94c:	00005097          	auipc	ra,0x5
     950:	5fc080e7          	jalr	1532(ra) # 5f48 <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	272080e7          	jalr	626(ra) # 5bc8 <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	a7850513          	addi	a0,a0,-1416 # 63d8 <malloc+0x3d2>
     968:	00005097          	auipc	ra,0x5
     96c:	5e0080e7          	jalr	1504(ra) # 5f48 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	a7450513          	addi	a0,a0,-1420 # 63e8 <malloc+0x3e2>
     97c:	00005097          	auipc	ra,0x5
     980:	5cc080e7          	jalr	1484(ra) # 5f48 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	242080e7          	jalr	578(ra) # 5bc8 <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	a7850513          	addi	a0,a0,-1416 # 6408 <malloc+0x402>
     998:	00005097          	auipc	ra,0x5
     99c:	5b0080e7          	jalr	1456(ra) # 5f48 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	a4450513          	addi	a0,a0,-1468 # 63e8 <malloc+0x3e2>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	59c080e7          	jalr	1436(ra) # 5f48 <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	212080e7          	jalr	530(ra) # 5bc8 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	a5e50513          	addi	a0,a0,-1442 # 6420 <malloc+0x41a>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	57e080e7          	jalr	1406(ra) # 5f48 <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	1f4080e7          	jalr	500(ra) # 5bc8 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	a6050513          	addi	a0,a0,-1440 # 6440 <malloc+0x43a>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	560080e7          	jalr	1376(ra) # 5f48 <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	1d6080e7          	jalr	470(ra) # 5bc8 <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	addi	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	a4c50513          	addi	a0,a0,-1460 # 6460 <malloc+0x45a>
     a1c:	00005097          	auipc	ra,0x5
     a20:	1ec080e7          	jalr	492(ra) # 5c08 <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	a5c98993          	addi	s3,s3,-1444 # 6488 <malloc+0x482>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	a8ca8a93          	addi	s5,s5,-1396 # 64c0 <malloc+0x4ba>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	1a2080e7          	jalr	418(ra) # 5be8 <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	18e080e7          	jalr	398(ra) # 5be8 <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	180080e7          	jalr	384(ra) # 5bf0 <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	9e650513          	addi	a0,a0,-1562 # 6460 <malloc+0x45a>
     a82:	00005097          	auipc	ra,0x5
     a86:	186080e7          	jalr	390(ra) # 5c08 <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000c597          	auipc	a1,0xc
     a98:	1e458593          	addi	a1,a1,484 # cc78 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	144080e7          	jalr	324(ra) # 5be0 <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	142080e7          	jalr	322(ra) # 5bf0 <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	9aa50513          	addi	a0,a0,-1622 # 6460 <malloc+0x45a>
     abe:	00005097          	auipc	ra,0x5
     ac2:	15a080e7          	jalr	346(ra) # 5c18 <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	addi	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	98850513          	addi	a0,a0,-1656 # 6468 <malloc+0x462>
     ae8:	00005097          	auipc	ra,0x5
     aec:	460080e7          	jalr	1120(ra) # 5f48 <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	0d6080e7          	jalr	214(ra) # 5bc8 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	99a50513          	addi	a0,a0,-1638 # 6498 <malloc+0x492>
     b06:	00005097          	auipc	ra,0x5
     b0a:	442080e7          	jalr	1090(ra) # 5f48 <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	0b8080e7          	jalr	184(ra) # 5bc8 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	9b450513          	addi	a0,a0,-1612 # 64d0 <malloc+0x4ca>
     b24:	00005097          	auipc	ra,0x5
     b28:	424080e7          	jalr	1060(ra) # 5f48 <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	09a080e7          	jalr	154(ra) # 5bc8 <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	9c050513          	addi	a0,a0,-1600 # 64f8 <malloc+0x4f2>
     b40:	00005097          	auipc	ra,0x5
     b44:	408080e7          	jalr	1032(ra) # 5f48 <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	07e080e7          	jalr	126(ra) # 5bc8 <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	9c450513          	addi	a0,a0,-1596 # 6518 <malloc+0x512>
     b5c:	00005097          	auipc	ra,0x5
     b60:	3ec080e7          	jalr	1004(ra) # 5f48 <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	062080e7          	jalr	98(ra) # 5bc8 <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	9c050513          	addi	a0,a0,-1600 # 6530 <malloc+0x52a>
     b78:	00005097          	auipc	ra,0x5
     b7c:	3d0080e7          	jalr	976(ra) # 5f48 <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	046080e7          	jalr	70(ra) # 5bc8 <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	addi	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	addi	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	9ae50513          	addi	a0,a0,-1618 # 6550 <malloc+0x54a>
     baa:	00005097          	auipc	ra,0x5
     bae:	05e080e7          	jalr	94(ra) # 5c08 <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000c917          	auipc	s2,0xc
     bba:	0c290913          	addi	s2,s2,194 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	016080e7          	jalr	22(ra) # 5be8 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	006080e7          	jalr	6(ra) # 5bf0 <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	95c50513          	addi	a0,a0,-1700 # 6550 <malloc+0x54a>
     bfc:	00005097          	auipc	ra,0x5
     c00:	00c080e7          	jalr	12(ra) # 5c08 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	07090913          	addi	s2,s2,112 # cc78 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	fc4080e7          	jalr	-60(ra) # 5be0 <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	91c50513          	addi	a0,a0,-1764 # 6558 <malloc+0x552>
     c44:	00005097          	auipc	ra,0x5
     c48:	304080e7          	jalr	772(ra) # 5f48 <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f7a080e7          	jalr	-134(ra) # 5bc8 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	91e50513          	addi	a0,a0,-1762 # 6578 <malloc+0x572>
     c62:	00005097          	auipc	ra,0x5
     c66:	2e6080e7          	jalr	742(ra) # 5f48 <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f5c080e7          	jalr	-164(ra) # 5bc8 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	92a50513          	addi	a0,a0,-1750 # 65a0 <malloc+0x59a>
     c7e:	00005097          	auipc	ra,0x5
     c82:	2ca080e7          	jalr	714(ra) # 5f48 <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f40080e7          	jalr	-192(ra) # 5bc8 <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	f56080e7          	jalr	-170(ra) # 5bf0 <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	8ae50513          	addi	a0,a0,-1874 # 6550 <malloc+0x54a>
     caa:	00005097          	auipc	ra,0x5
     cae:	f6e080e7          	jalr	-146(ra) # 5c18 <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	addi	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	8f250513          	addi	a0,a0,-1806 # 65c0 <malloc+0x5ba>
     cd6:	00005097          	auipc	ra,0x5
     cda:	272080e7          	jalr	626(ra) # 5f48 <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	ee8080e7          	jalr	-280(ra) # 5bc8 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	8fc50513          	addi	a0,a0,-1796 # 65e8 <malloc+0x5e2>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	254080e7          	jalr	596(ra) # 5f48 <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	eca080e7          	jalr	-310(ra) # 5bc8 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	8f650513          	addi	a0,a0,-1802 # 6600 <malloc+0x5fa>
     d12:	00005097          	auipc	ra,0x5
     d16:	236080e7          	jalr	566(ra) # 5f48 <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	eac080e7          	jalr	-340(ra) # 5bc8 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	90250513          	addi	a0,a0,-1790 # 6628 <malloc+0x622>
     d2e:	00005097          	auipc	ra,0x5
     d32:	21a080e7          	jalr	538(ra) # 5f48 <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	e90080e7          	jalr	-368(ra) # 5bc8 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	8ec50513          	addi	a0,a0,-1812 # 6640 <malloc+0x63a>
     d5c:	00005097          	auipc	ra,0x5
     d60:	eac080e7          	jalr	-340(ra) # 5c08 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	90458593          	addi	a1,a1,-1788 # 6670 <malloc+0x66a>
     d74:	00005097          	auipc	ra,0x5
     d78:	e74080e7          	jalr	-396(ra) # 5be8 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e72080e7          	jalr	-398(ra) # 5bf0 <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	8b850513          	addi	a0,a0,-1864 # 6640 <malloc+0x63a>
     d90:	00005097          	auipc	ra,0x5
     d94:	e78080e7          	jalr	-392(ra) # 5c08 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	8a250513          	addi	a0,a0,-1886 # 6640 <malloc+0x63a>
     da6:	00005097          	auipc	ra,0x5
     daa:	e72080e7          	jalr	-398(ra) # 5c18 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	88c50513          	addi	a0,a0,-1908 # 6640 <malloc+0x63a>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e4c080e7          	jalr	-436(ra) # 5c08 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	8f058593          	addi	a1,a1,-1808 # 66b8 <malloc+0x6b2>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e18080e7          	jalr	-488(ra) # 5be8 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e16080e7          	jalr	-490(ra) # 5bf0 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e9458593          	addi	a1,a1,-364 # cc78 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	df2080e7          	jalr	-526(ra) # 5be0 <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e7c74703          	lbu	a4,-388(a4) # cc78 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e6a58593          	addi	a1,a1,-406 # cc78 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	dd0080e7          	jalr	-560(ra) # 5be8 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	dc8080e7          	jalr	-568(ra) # 5bf0 <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	81050513          	addi	a0,a0,-2032 # 6640 <malloc+0x63a>
     e38:	00005097          	auipc	ra,0x5
     e3c:	de0080e7          	jalr	-544(ra) # 5c18 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	80050513          	addi	a0,a0,-2048 # 6650 <malloc+0x64a>
     e58:	00005097          	auipc	ra,0x5
     e5c:	0f0080e7          	jalr	240(ra) # 5f48 <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d66080e7          	jalr	-666(ra) # 5bc8 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	80c50513          	addi	a0,a0,-2036 # 6678 <malloc+0x672>
     e74:	00005097          	auipc	ra,0x5
     e78:	0d4080e7          	jalr	212(ra) # 5f48 <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d4a080e7          	jalr	-694(ra) # 5bc8 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	81050513          	addi	a0,a0,-2032 # 6698 <malloc+0x692>
     e90:	00005097          	auipc	ra,0x5
     e94:	0b8080e7          	jalr	184(ra) # 5f48 <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d2e080e7          	jalr	-722(ra) # 5bc8 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	81c50513          	addi	a0,a0,-2020 # 66c0 <malloc+0x6ba>
     eac:	00005097          	auipc	ra,0x5
     eb0:	09c080e7          	jalr	156(ra) # 5f48 <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d12080e7          	jalr	-750(ra) # 5bc8 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	82050513          	addi	a0,a0,-2016 # 66e0 <malloc+0x6da>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	080080e7          	jalr	128(ra) # 5f48 <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	cf6080e7          	jalr	-778(ra) # 5bc8 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	82450513          	addi	a0,a0,-2012 # 6700 <malloc+0x6fa>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	064080e7          	jalr	100(ra) # 5f48 <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	cda080e7          	jalr	-806(ra) # 5bc8 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	81c50513          	addi	a0,a0,-2020 # 6720 <malloc+0x71a>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d0c080e7          	jalr	-756(ra) # 5c18 <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	81450513          	addi	a0,a0,-2028 # 6728 <malloc+0x722>
     f1c:	00005097          	auipc	ra,0x5
     f20:	cfc080e7          	jalr	-772(ra) # 5c18 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00005517          	auipc	a0,0x5
     f2c:	7f850513          	addi	a0,a0,2040 # 6720 <malloc+0x71a>
     f30:	00005097          	auipc	ra,0x5
     f34:	cd8080e7          	jalr	-808(ra) # 5c08 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	73058593          	addi	a1,a1,1840 # 6670 <malloc+0x66a>
     f48:	00005097          	auipc	ra,0x5
     f4c:	ca0080e7          	jalr	-864(ra) # 5be8 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	c98080e7          	jalr	-872(ra) # 5bf0 <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	7c858593          	addi	a1,a1,1992 # 6728 <malloc+0x722>
     f68:	00005517          	auipc	a0,0x5
     f6c:	7b850513          	addi	a0,a0,1976 # 6720 <malloc+0x71a>
     f70:	00005097          	auipc	ra,0x5
     f74:	cb8080e7          	jalr	-840(ra) # 5c28 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	7a450513          	addi	a0,a0,1956 # 6720 <malloc+0x71a>
     f84:	00005097          	auipc	ra,0x5
     f88:	c94080e7          	jalr	-876(ra) # 5c18 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	79250513          	addi	a0,a0,1938 # 6720 <malloc+0x71a>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c72080e7          	jalr	-910(ra) # 5c08 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	78450513          	addi	a0,a0,1924 # 6728 <malloc+0x722>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c5c080e7          	jalr	-932(ra) # 5c08 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	cbc58593          	addi	a1,a1,-836 # cc78 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c1c080e7          	jalr	-996(ra) # 5be0 <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c1c080e7          	jalr	-996(ra) # 5bf0 <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	74c58593          	addi	a1,a1,1868 # 6728 <malloc+0x722>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c42080e7          	jalr	-958(ra) # 5c28 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	73650513          	addi	a0,a0,1846 # 6728 <malloc+0x722>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c1e080e7          	jalr	-994(ra) # 5c18 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	71e58593          	addi	a1,a1,1822 # 6720 <malloc+0x71a>
    100a:	00005517          	auipc	a0,0x5
    100e:	71e50513          	addi	a0,a0,1822 # 6728 <malloc+0x722>
    1012:	00005097          	auipc	ra,0x5
    1016:	c16080e7          	jalr	-1002(ra) # 5c28 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	70258593          	addi	a1,a1,1794 # 6720 <malloc+0x71a>
    1026:	00006517          	auipc	a0,0x6
    102a:	80a50513          	addi	a0,a0,-2038 # 6830 <malloc+0x82a>
    102e:	00005097          	auipc	ra,0x5
    1032:	bfa080e7          	jalr	-1030(ra) # 5c28 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	6e850513          	addi	a0,a0,1768 # 6730 <malloc+0x72a>
    1050:	00005097          	auipc	ra,0x5
    1054:	ef8080e7          	jalr	-264(ra) # 5f48 <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b6e080e7          	jalr	-1170(ra) # 5bc8 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	6e450513          	addi	a0,a0,1764 # 6748 <malloc+0x742>
    106c:	00005097          	auipc	ra,0x5
    1070:	edc080e7          	jalr	-292(ra) # 5f48 <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b52080e7          	jalr	-1198(ra) # 5bc8 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	6e050513          	addi	a0,a0,1760 # 6760 <malloc+0x75a>
    1088:	00005097          	auipc	ra,0x5
    108c:	ec0080e7          	jalr	-320(ra) # 5f48 <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b36080e7          	jalr	-1226(ra) # 5bc8 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	6e450513          	addi	a0,a0,1764 # 6780 <malloc+0x77a>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	ea4080e7          	jalr	-348(ra) # 5f48 <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b1a080e7          	jalr	-1254(ra) # 5bc8 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	6f850513          	addi	a0,a0,1784 # 67b0 <malloc+0x7aa>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	e88080e7          	jalr	-376(ra) # 5f48 <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	afe080e7          	jalr	-1282(ra) # 5bc8 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	6f450513          	addi	a0,a0,1780 # 67c8 <malloc+0x7c2>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e6c080e7          	jalr	-404(ra) # 5f48 <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	ae2080e7          	jalr	-1310(ra) # 5bc8 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	6f050513          	addi	a0,a0,1776 # 67e0 <malloc+0x7da>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e50080e7          	jalr	-432(ra) # 5f48 <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	ac6080e7          	jalr	-1338(ra) # 5bc8 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	6fc50513          	addi	a0,a0,1788 # 6808 <malloc+0x802>
    1114:	00005097          	auipc	ra,0x5
    1118:	e34080e7          	jalr	-460(ra) # 5f48 <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	aaa080e7          	jalr	-1366(ra) # 5bc8 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	71050513          	addi	a0,a0,1808 # 6838 <malloc+0x832>
    1130:	00005097          	auipc	ra,0x5
    1134:	e18080e7          	jalr	-488(ra) # 5f48 <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	a8e080e7          	jalr	-1394(ra) # 5bc8 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	6fe98993          	addi	s3,s3,1790 # 6858 <malloc+0x852>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	aba080e7          	jalr	-1350(ra) # 5c28 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	6d250513          	addi	a0,a0,1746 # 6868 <malloc+0x862>
    119e:	00005097          	auipc	ra,0x5
    11a2:	daa080e7          	jalr	-598(ra) # 5f48 <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a20080e7          	jalr	-1504(ra) # 5bc8 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6c250513          	addi	a0,a0,1730 # 6888 <malloc+0x882>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a4a080e7          	jalr	-1462(ra) # 5c18 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	6ae50513          	addi	a0,a0,1710 # 6888 <malloc+0x882>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a26080e7          	jalr	-1498(ra) # 5c08 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a02080e7          	jalr	-1534(ra) # 5bf0 <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	68ca0a13          	addi	s4,s4,1676 # 6888 <malloc+0x882>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9579b          	sraiw	a5,s2,0x1f
    1210:	01a7d71b          	srliw	a4,a5,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	9ec080e7          	jalr	-1556(ra) # 5c28 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	63a50513          	addi	a0,a0,1594 # 6888 <malloc+0x882>
    1256:	00005097          	auipc	ra,0x5
    125a:	9c2080e7          	jalr	-1598(ra) # 5c18 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d79b          	sraiw	a5,s1,0x1f
    126e:	01a7d71b          	srliw	a4,a5,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	980080e7          	jalr	-1664(ra) # 5c18 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	5d250513          	addi	a0,a0,1490 # 6890 <malloc+0x88a>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	c82080e7          	jalr	-894(ra) # 5f48 <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	8f8080e7          	jalr	-1800(ra) # 5bc8 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	5d250513          	addi	a0,a0,1490 # 68b0 <malloc+0x8aa>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c62080e7          	jalr	-926(ra) # 5f48 <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8d8080e7          	jalr	-1832(ra) # 5bc8 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	5d650513          	addi	a0,a0,1494 # 68d0 <malloc+0x8ca>
    1302:	00005097          	auipc	ra,0x5
    1306:	c46080e7          	jalr	-954(ra) # 5f48 <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	8bc080e7          	jalr	-1860(ra) # 5bc8 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	8d0080e7          	jalr	-1840(ra) # 5c00 <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	89e080e7          	jalr	-1890(ra) # 5bd8 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	884080e7          	jalr	-1916(ra) # 5bc8 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	de298993          	addi	s3,s3,-542 # 6148 <malloc+0x142>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	884080e7          	jalr	-1916(ra) # 5c00 <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	83e080e7          	jalr	-1986(ra) # 5bc8 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	860080e7          	jalr	-1952(ra) # 5c18 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	83a080e7          	jalr	-1990(ra) # 5c08 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	846080e7          	jalr	-1978(ra) # 5c28 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	74878793          	addi	a5,a5,1864 # 7b38 <malloc+0x1b32>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00004097          	auipc	ra,0x4
    140c:	7f8080e7          	jalr	2040(ra) # 5c00 <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	7aa080e7          	jalr	1962(ra) # 5bc0 <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	13a78793          	addi	a5,a5,314 # 9560 <big.0>
    142e:	00009697          	auipc	a3,0x9
    1432:	13268693          	addi	a3,a3,306 # a560 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	10078e23          	sb	zero,284(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	11478793          	addi	a5,a5,276 # 8560 <malloc+0x255a>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	cd850513          	addi	a0,a0,-808 # 6148 <malloc+0x142>
    1478:	00004097          	auipc	ra,0x4
    147c:	788080e7          	jalr	1928(ra) # 5c00 <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	4f050513          	addi	a0,a0,1264 # 6978 <malloc+0x972>
    1490:	00005097          	auipc	ra,0x5
    1494:	ab8080e7          	jalr	-1352(ra) # 5f48 <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	72e080e7          	jalr	1838(ra) # 5bc8 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	44850513          	addi	a0,a0,1096 # 68f0 <malloc+0x8ea>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	a98080e7          	jalr	-1384(ra) # 5f48 <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	70e080e7          	jalr	1806(ra) # 5bc8 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	44850513          	addi	a0,a0,1096 # 6910 <malloc+0x90a>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	a78080e7          	jalr	-1416(ra) # 5f48 <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	6ee080e7          	jalr	1774(ra) # 5bc8 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	44650513          	addi	a0,a0,1094 # 6930 <malloc+0x92a>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a56080e7          	jalr	-1450(ra) # 5f48 <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	6cc080e7          	jalr	1740(ra) # 5bc8 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	44e50513          	addi	a0,a0,1102 # 6958 <malloc+0x952>
    1512:	00005097          	auipc	ra,0x5
    1516:	a36080e7          	jalr	-1482(ra) # 5f48 <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	6ac080e7          	jalr	1708(ra) # 5bc8 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	8b450513          	addi	a0,a0,-1868 # 6dd8 <malloc+0xdd2>
    152c:	00005097          	auipc	ra,0x5
    1530:	a1c080e7          	jalr	-1508(ra) # 5f48 <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	692080e7          	jalr	1682(ra) # 5bc8 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	686080e7          	jalr	1670(ra) # 5bc8 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	67e080e7          	jalr	1662(ra) # 5bd0 <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	43250513          	addi	a0,a0,1074 # 69a0 <malloc+0x99a>
    1576:	00005097          	auipc	ra,0x5
    157a:	9d2080e7          	jalr	-1582(ra) # 5f48 <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	648080e7          	jalr	1608(ra) # 5bc8 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	c0050513          	addi	a0,a0,-1024 # 61a0 <malloc+0x19a>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	660080e7          	jalr	1632(ra) # 5c08 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	640080e7          	jalr	1600(ra) # 5bf0 <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	608080e7          	jalr	1544(ra) # 5bc0 <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	bd6a0a13          	addi	s4,s4,-1066 # 61a0 <malloc+0x19a>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	42ea8a93          	addi	s5,s5,1070 # 6a00 <malloc+0x9fa>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	62a080e7          	jalr	1578(ra) # 5c08 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5f8080e7          	jalr	1528(ra) # 5be8 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5f0080e7          	jalr	1520(ra) # 5bf0 <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	5fc080e7          	jalr	1532(ra) # 5c08 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	5c2080e7          	jalr	1474(ra) # 5be0 <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	5c8080e7          	jalr	1480(ra) # 5bf0 <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	590080e7          	jalr	1424(ra) # 5bc8 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	38e50513          	addi	a0,a0,910 # 69d0 <malloc+0x9ca>
    164a:	00005097          	auipc	ra,0x5
    164e:	8fe080e7          	jalr	-1794(ra) # 5f48 <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	574080e7          	jalr	1396(ra) # 5bc8 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	38a50513          	addi	a0,a0,906 # 69e8 <malloc+0x9e2>
    1666:	00005097          	auipc	ra,0x5
    166a:	8e2080e7          	jalr	-1822(ra) # 5f48 <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	558080e7          	jalr	1368(ra) # 5bc8 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	39450513          	addi	a0,a0,916 # 6a10 <malloc+0xa0a>
    1684:	00005097          	auipc	ra,0x5
    1688:	8c4080e7          	jalr	-1852(ra) # 5f48 <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	53a080e7          	jalr	1338(ra) # 5bc8 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	b06a0a13          	addi	s4,s4,-1274 # 61a0 <malloc+0x19a>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	38ea8a93          	addi	s5,s5,910 # 6a30 <malloc+0xa2a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	558080e7          	jalr	1368(ra) # 5c08 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	526080e7          	jalr	1318(ra) # 5be8 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	51e080e7          	jalr	1310(ra) # 5bf0 <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4ec080e7          	jalr	1260(ra) # 5bd0 <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	ab450513          	addi	a0,a0,-1356 # 61a0 <malloc+0x19a>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	524080e7          	jalr	1316(ra) # 5c18 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	4c8080e7          	jalr	1224(ra) # 5bc8 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	2de50513          	addi	a0,a0,734 # 69e8 <malloc+0x9e2>
    1712:	00005097          	auipc	ra,0x5
    1716:	836080e7          	jalr	-1994(ra) # 5f48 <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	4ac080e7          	jalr	1196(ra) # 5bc8 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	31050513          	addi	a0,a0,784 # 6a38 <malloc+0xa32>
    1730:	00005097          	auipc	ra,0x5
    1734:	818080e7          	jalr	-2024(ra) # 5f48 <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	48e080e7          	jalr	1166(ra) # 5bc8 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	9f878793          	addi	a5,a5,-1544 # 6148 <malloc+0x142>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	2fc78793          	addi	a5,a5,764 # 6a58 <malloc+0xa52>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	2f450513          	addi	a0,a0,756 # 6a60 <malloc+0xa5a>
    1774:	00004097          	auipc	ra,0x4
    1778:	4a4080e7          	jalr	1188(ra) # 5c18 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	444080e7          	jalr	1092(ra) # 5bc0 <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	462080e7          	jalr	1122(ra) # 5bf0 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	2c650513          	addi	a0,a0,710 # 6a60 <malloc+0xa5a>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	466080e7          	jalr	1126(ra) # 5c08 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	2ca50513          	addi	a0,a0,714 # 6a80 <malloc+0xa7a>
    17be:	00004097          	auipc	ra,0x4
    17c2:	78a080e7          	jalr	1930(ra) # 5f48 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	400080e7          	jalr	1024(ra) # 5bc8 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	1fe50513          	addi	a0,a0,510 # 69d0 <malloc+0x9ca>
    17da:	00004097          	auipc	ra,0x4
    17de:	76e080e7          	jalr	1902(ra) # 5f48 <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	3e4080e7          	jalr	996(ra) # 5bc8 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	27a50513          	addi	a0,a0,634 # 6a68 <malloc+0xa62>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	752080e7          	jalr	1874(ra) # 5f48 <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	3c8080e7          	jalr	968(ra) # 5bc8 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	93c50513          	addi	a0,a0,-1732 # 6148 <malloc+0x142>
    1814:	00004097          	auipc	ra,0x4
    1818:	3ec080e7          	jalr	1004(ra) # 5c00 <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	3ac080e7          	jalr	940(ra) # 5bd0 <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	392080e7          	jalr	914(ra) # 5bc8 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	25050513          	addi	a0,a0,592 # 6a90 <malloc+0xa8a>
    1848:	00004097          	auipc	ra,0x4
    184c:	700080e7          	jalr	1792(ra) # 5f48 <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	376080e7          	jalr	886(ra) # 5bc8 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	24c50513          	addi	a0,a0,588 # 6aa8 <malloc+0xaa2>
    1864:	00004097          	auipc	ra,0x4
    1868:	6e4080e7          	jalr	1764(ra) # 5f48 <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	1f050513          	addi	a0,a0,496 # 6a60 <malloc+0xa5a>
    1878:	00004097          	auipc	ra,0x4
    187c:	390080e7          	jalr	912(ra) # 5c08 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	356080e7          	jalr	854(ra) # 5be0 <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	c7e50513          	addi	a0,a0,-898 # 6518 <malloc+0x512>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	6a6080e7          	jalr	1702(ra) # 5f48 <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	31c080e7          	jalr	796(ra) # 5bc8 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	13250513          	addi	a0,a0,306 # 69e8 <malloc+0x9e2>
    18be:	00004097          	auipc	ra,0x4
    18c2:	68a080e7          	jalr	1674(ra) # 5f48 <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	300080e7          	jalr	768(ra) # 5bc8 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	19050513          	addi	a0,a0,400 # 6a60 <malloc+0xa5a>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	340080e7          	jalr	832(ra) # 5c18 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	1c650513          	addi	a0,a0,454 # 6ac0 <malloc+0xaba>
    1902:	00004097          	auipc	ra,0x4
    1906:	646080e7          	jalr	1606(ra) # 5f48 <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	2bc080e7          	jalr	700(ra) # 5bc8 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	2b2080e7          	jalr	690(ra) # 5bc8 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	29e080e7          	jalr	670(ra) # 5bd8 <pipe>
    1942:	ed25                	bnez	a0,19ba <pipe1+0x9c>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	27a080e7          	jalr	634(ra) # 5bc0 <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c159                	beqz	a0,19d6 <pipe1+0xb8>
  } else if(pid > 0){
    1952:	16a05e63          	blez	a0,1ace <pipe1+0x1b0>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	296080e7          	jalr	662(ra) # 5bf0 <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	312a8a93          	addi	s5,s5,786 # cc78 <buf>
      if(cc > sizeof(buf))
    196e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1970:	864e                	mv	a2,s3
    1972:	85d6                	mv	a1,s5
    1974:	fa842503          	lw	a0,-88(s0)
    1978:	00004097          	auipc	ra,0x4
    197c:	268080e7          	jalr	616(ra) # 5be0 <read>
    1980:	10a05263          	blez	a0,1a84 <pipe1+0x166>
      for(i = 0; i < n; i++){
    1984:	0000b717          	auipc	a4,0xb
    1988:	2f470713          	addi	a4,a4,756 # cc78 <buf>
    198c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1990:	00074683          	lbu	a3,0(a4)
    1994:	0ff4f793          	zext.b	a5,s1
    1998:	2485                	addiw	s1,s1,1
    199a:	0cf69163          	bne	a3,a5,1a5c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    199e:	0705                	addi	a4,a4,1
    19a0:	fec498e3          	bne	s1,a2,1990 <pipe1+0x72>
      total += n;
    19a4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a8:	0019979b          	slliw	a5,s3,0x1
    19ac:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b0:	013b7363          	bgeu	s6,s3,19b6 <pipe1+0x98>
        cc = sizeof(buf);
    19b4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19b6:	84b2                	mv	s1,a2
    19b8:	bf65                	j	1970 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19ba:	85ca                	mv	a1,s2
    19bc:	00005517          	auipc	a0,0x5
    19c0:	11c50513          	addi	a0,a0,284 # 6ad8 <malloc+0xad2>
    19c4:	00004097          	auipc	ra,0x4
    19c8:	584080e7          	jalr	1412(ra) # 5f48 <printf>
    exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	1fa080e7          	jalr	506(ra) # 5bc8 <exit>
    close(fds[0]);
    19d6:	fa842503          	lw	a0,-88(s0)
    19da:	00004097          	auipc	ra,0x4
    19de:	216080e7          	jalr	534(ra) # 5bf0 <close>
    for(n = 0; n < N; n++){
    19e2:	0000bb17          	auipc	s6,0xb
    19e6:	296b0b13          	addi	s6,s6,662 # cc78 <buf>
    19ea:	416004bb          	negw	s1,s6
    19ee:	0ff4f493          	zext.b	s1,s1
    19f2:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f6:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f8:	6a85                	lui	s5,0x1
    19fa:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fe:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a00:	0097873b          	addw	a4,a5,s1
    1a04:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a08:	0785                	addi	a5,a5,1
    1a0a:	fef99be3          	bne	s3,a5,1a00 <pipe1+0xe2>
        buf[i] = seq++;
    1a0e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a12:	40900613          	li	a2,1033
    1a16:	85de                	mv	a1,s7
    1a18:	fac42503          	lw	a0,-84(s0)
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	1cc080e7          	jalr	460(ra) # 5be8 <write>
    1a24:	40900793          	li	a5,1033
    1a28:	00f51c63          	bne	a0,a5,1a40 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a2c:	24a5                	addiw	s1,s1,9
    1a2e:	0ff4f493          	zext.b	s1,s1
    1a32:	fd5a16e3          	bne	s4,s5,19fe <pipe1+0xe0>
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	190080e7          	jalr	400(ra) # 5bc8 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a40:	85ca                	mv	a1,s2
    1a42:	00005517          	auipc	a0,0x5
    1a46:	0ae50513          	addi	a0,a0,174 # 6af0 <malloc+0xaea>
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	4fe080e7          	jalr	1278(ra) # 5f48 <printf>
        exit(1);
    1a52:	4505                	li	a0,1
    1a54:	00004097          	auipc	ra,0x4
    1a58:	174080e7          	jalr	372(ra) # 5bc8 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5c:	85ca                	mv	a1,s2
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	0aa50513          	addi	a0,a0,170 # 6b08 <malloc+0xb02>
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	4e2080e7          	jalr	1250(ra) # 5f48 <printf>
}
    1a6e:	60e6                	ld	ra,88(sp)
    1a70:	6446                	ld	s0,80(sp)
    1a72:	64a6                	ld	s1,72(sp)
    1a74:	6906                	ld	s2,64(sp)
    1a76:	79e2                	ld	s3,56(sp)
    1a78:	7a42                	ld	s4,48(sp)
    1a7a:	7aa2                	ld	s5,40(sp)
    1a7c:	7b02                	ld	s6,32(sp)
    1a7e:	6be2                	ld	s7,24(sp)
    1a80:	6125                	addi	sp,sp,96
    1a82:	8082                	ret
    if(total != N * SZ){
    1a84:	6785                	lui	a5,0x1
    1a86:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a8a:	02fa0063          	beq	s4,a5,1aaa <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8e:	85d2                	mv	a1,s4
    1a90:	00005517          	auipc	a0,0x5
    1a94:	09050513          	addi	a0,a0,144 # 6b20 <malloc+0xb1a>
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	4b0080e7          	jalr	1200(ra) # 5f48 <printf>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	00004097          	auipc	ra,0x4
    1aa6:	126080e7          	jalr	294(ra) # 5bc8 <exit>
    close(fds[0]);
    1aaa:	fa842503          	lw	a0,-88(s0)
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	142080e7          	jalr	322(ra) # 5bf0 <close>
    wait(&xstatus);
    1ab6:	fa440513          	addi	a0,s0,-92
    1aba:	00004097          	auipc	ra,0x4
    1abe:	116080e7          	jalr	278(ra) # 5bd0 <wait>
    exit(xstatus);
    1ac2:	fa442503          	lw	a0,-92(s0)
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	102080e7          	jalr	258(ra) # 5bc8 <exit>
    printf("%s: fork() failed\n", s);
    1ace:	85ca                	mv	a1,s2
    1ad0:	00005517          	auipc	a0,0x5
    1ad4:	07050513          	addi	a0,a0,112 # 6b40 <malloc+0xb3a>
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	470080e7          	jalr	1136(ra) # 5f48 <printf>
    exit(1);
    1ae0:	4505                	li	a0,1
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	0e6080e7          	jalr	230(ra) # 5bc8 <exit>

0000000000001aea <exitwait>:
{
    1aea:	7139                	addi	sp,sp,-64
    1aec:	fc06                	sd	ra,56(sp)
    1aee:	f822                	sd	s0,48(sp)
    1af0:	f426                	sd	s1,40(sp)
    1af2:	f04a                	sd	s2,32(sp)
    1af4:	ec4e                	sd	s3,24(sp)
    1af6:	e852                	sd	s4,16(sp)
    1af8:	0080                	addi	s0,sp,64
    1afa:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afc:	4901                	li	s2,0
    1afe:	06400993          	li	s3,100
    pid = fork();
    1b02:	00004097          	auipc	ra,0x4
    1b06:	0be080e7          	jalr	190(ra) # 5bc0 <fork>
    1b0a:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0c:	02054a63          	bltz	a0,1b40 <exitwait+0x56>
    if(pid){
    1b10:	c151                	beqz	a0,1b94 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b12:	fcc40513          	addi	a0,s0,-52
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	0ba080e7          	jalr	186(ra) # 5bd0 <wait>
    1b1e:	02951f63          	bne	a0,s1,1b5c <exitwait+0x72>
      if(i != xstate) {
    1b22:	fcc42783          	lw	a5,-52(s0)
    1b26:	05279963          	bne	a5,s2,1b78 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b2a:	2905                	addiw	s2,s2,1
    1b2c:	fd391be3          	bne	s2,s3,1b02 <exitwait+0x18>
}
    1b30:	70e2                	ld	ra,56(sp)
    1b32:	7442                	ld	s0,48(sp)
    1b34:	74a2                	ld	s1,40(sp)
    1b36:	7902                	ld	s2,32(sp)
    1b38:	69e2                	ld	s3,24(sp)
    1b3a:	6a42                	ld	s4,16(sp)
    1b3c:	6121                	addi	sp,sp,64
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85d2                	mv	a1,s4
    1b42:	00005517          	auipc	a0,0x5
    1b46:	e8e50513          	addi	a0,a0,-370 # 69d0 <malloc+0x9ca>
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	3fe080e7          	jalr	1022(ra) # 5f48 <printf>
      exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	074080e7          	jalr	116(ra) # 5bc8 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5c:	85d2                	mv	a1,s4
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	ffa50513          	addi	a0,a0,-6 # 6b58 <malloc+0xb52>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	3e2080e7          	jalr	994(ra) # 5f48 <printf>
        exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	058080e7          	jalr	88(ra) # 5bc8 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b78:	85d2                	mv	a1,s4
    1b7a:	00005517          	auipc	a0,0x5
    1b7e:	ff650513          	addi	a0,a0,-10 # 6b70 <malloc+0xb6a>
    1b82:	00004097          	auipc	ra,0x4
    1b86:	3c6080e7          	jalr	966(ra) # 5f48 <printf>
        exit(1);
    1b8a:	4505                	li	a0,1
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	03c080e7          	jalr	60(ra) # 5bc8 <exit>
      exit(i);
    1b94:	854a                	mv	a0,s2
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	032080e7          	jalr	50(ra) # 5bc8 <exit>

0000000000001b9e <twochildren>:
{
    1b9e:	1101                	addi	sp,sp,-32
    1ba0:	ec06                	sd	ra,24(sp)
    1ba2:	e822                	sd	s0,16(sp)
    1ba4:	e426                	sd	s1,8(sp)
    1ba6:	e04a                	sd	s2,0(sp)
    1ba8:	1000                	addi	s0,sp,32
    1baa:	892a                	mv	s2,a0
    1bac:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	010080e7          	jalr	16(ra) # 5bc0 <fork>
    if(pid1 < 0){
    1bb8:	02054c63          	bltz	a0,1bf0 <twochildren+0x52>
    if(pid1 == 0){
    1bbc:	c921                	beqz	a0,1c0c <twochildren+0x6e>
      int pid2 = fork();
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	002080e7          	jalr	2(ra) # 5bc0 <fork>
      if(pid2 < 0){
    1bc6:	04054763          	bltz	a0,1c14 <twochildren+0x76>
      if(pid2 == 0){
    1bca:	c13d                	beqz	a0,1c30 <twochildren+0x92>
        wait(0);
    1bcc:	4501                	li	a0,0
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	002080e7          	jalr	2(ra) # 5bd0 <wait>
        wait(0);
    1bd6:	4501                	li	a0,0
    1bd8:	00004097          	auipc	ra,0x4
    1bdc:	ff8080e7          	jalr	-8(ra) # 5bd0 <wait>
  for(int i = 0; i < 1000; i++){
    1be0:	34fd                	addiw	s1,s1,-1
    1be2:	f4f9                	bnez	s1,1bb0 <twochildren+0x12>
}
    1be4:	60e2                	ld	ra,24(sp)
    1be6:	6442                	ld	s0,16(sp)
    1be8:	64a2                	ld	s1,8(sp)
    1bea:	6902                	ld	s2,0(sp)
    1bec:	6105                	addi	sp,sp,32
    1bee:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf0:	85ca                	mv	a1,s2
    1bf2:	00005517          	auipc	a0,0x5
    1bf6:	dde50513          	addi	a0,a0,-546 # 69d0 <malloc+0x9ca>
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	34e080e7          	jalr	846(ra) # 5f48 <printf>
      exit(1);
    1c02:	4505                	li	a0,1
    1c04:	00004097          	auipc	ra,0x4
    1c08:	fc4080e7          	jalr	-60(ra) # 5bc8 <exit>
      exit(0);
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	fbc080e7          	jalr	-68(ra) # 5bc8 <exit>
        printf("%s: fork failed\n", s);
    1c14:	85ca                	mv	a1,s2
    1c16:	00005517          	auipc	a0,0x5
    1c1a:	dba50513          	addi	a0,a0,-582 # 69d0 <malloc+0x9ca>
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	32a080e7          	jalr	810(ra) # 5f48 <printf>
        exit(1);
    1c26:	4505                	li	a0,1
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	fa0080e7          	jalr	-96(ra) # 5bc8 <exit>
        exit(0);
    1c30:	00004097          	auipc	ra,0x4
    1c34:	f98080e7          	jalr	-104(ra) # 5bc8 <exit>

0000000000001c38 <forkfork>:
{
    1c38:	7179                	addi	sp,sp,-48
    1c3a:	f406                	sd	ra,40(sp)
    1c3c:	f022                	sd	s0,32(sp)
    1c3e:	ec26                	sd	s1,24(sp)
    1c40:	1800                	addi	s0,sp,48
    1c42:	84aa                	mv	s1,a0
    int pid = fork();
    1c44:	00004097          	auipc	ra,0x4
    1c48:	f7c080e7          	jalr	-132(ra) # 5bc0 <fork>
    if(pid < 0){
    1c4c:	04054163          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c50:	cd29                	beqz	a0,1caa <forkfork+0x72>
    int pid = fork();
    1c52:	00004097          	auipc	ra,0x4
    1c56:	f6e080e7          	jalr	-146(ra) # 5bc0 <fork>
    if(pid < 0){
    1c5a:	02054a63          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c5e:	c531                	beqz	a0,1caa <forkfork+0x72>
    wait(&xstatus);
    1c60:	fdc40513          	addi	a0,s0,-36
    1c64:	00004097          	auipc	ra,0x4
    1c68:	f6c080e7          	jalr	-148(ra) # 5bd0 <wait>
    if(xstatus != 0) {
    1c6c:	fdc42783          	lw	a5,-36(s0)
    1c70:	ebbd                	bnez	a5,1ce6 <forkfork+0xae>
    wait(&xstatus);
    1c72:	fdc40513          	addi	a0,s0,-36
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	f5a080e7          	jalr	-166(ra) # 5bd0 <wait>
    if(xstatus != 0) {
    1c7e:	fdc42783          	lw	a5,-36(s0)
    1c82:	e3b5                	bnez	a5,1ce6 <forkfork+0xae>
}
    1c84:	70a2                	ld	ra,40(sp)
    1c86:	7402                	ld	s0,32(sp)
    1c88:	64e2                	ld	s1,24(sp)
    1c8a:	6145                	addi	sp,sp,48
    1c8c:	8082                	ret
      printf("%s: fork failed", s);
    1c8e:	85a6                	mv	a1,s1
    1c90:	00005517          	auipc	a0,0x5
    1c94:	f0050513          	addi	a0,a0,-256 # 6b90 <malloc+0xb8a>
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	2b0080e7          	jalr	688(ra) # 5f48 <printf>
      exit(1);
    1ca0:	4505                	li	a0,1
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	f26080e7          	jalr	-218(ra) # 5bc8 <exit>
{
    1caa:	0c800493          	li	s1,200
        int pid1 = fork();
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	f12080e7          	jalr	-238(ra) # 5bc0 <fork>
        if(pid1 < 0){
    1cb6:	00054f63          	bltz	a0,1cd4 <forkfork+0x9c>
        if(pid1 == 0){
    1cba:	c115                	beqz	a0,1cde <forkfork+0xa6>
        wait(0);
    1cbc:	4501                	li	a0,0
    1cbe:	00004097          	auipc	ra,0x4
    1cc2:	f12080e7          	jalr	-238(ra) # 5bd0 <wait>
      for(int j = 0; j < 200; j++){
    1cc6:	34fd                	addiw	s1,s1,-1
    1cc8:	f0fd                	bnez	s1,1cae <forkfork+0x76>
      exit(0);
    1cca:	4501                	li	a0,0
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	efc080e7          	jalr	-260(ra) # 5bc8 <exit>
          exit(1);
    1cd4:	4505                	li	a0,1
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	ef2080e7          	jalr	-270(ra) # 5bc8 <exit>
          exit(0);
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	eea080e7          	jalr	-278(ra) # 5bc8 <exit>
      printf("%s: fork in child failed", s);
    1ce6:	85a6                	mv	a1,s1
    1ce8:	00005517          	auipc	a0,0x5
    1cec:	eb850513          	addi	a0,a0,-328 # 6ba0 <malloc+0xb9a>
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	258080e7          	jalr	600(ra) # 5f48 <printf>
      exit(1);
    1cf8:	4505                	li	a0,1
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	ece080e7          	jalr	-306(ra) # 5bc8 <exit>

0000000000001d02 <reparent2>:
{
    1d02:	1101                	addi	sp,sp,-32
    1d04:	ec06                	sd	ra,24(sp)
    1d06:	e822                	sd	s0,16(sp)
    1d08:	e426                	sd	s1,8(sp)
    1d0a:	1000                	addi	s0,sp,32
    1d0c:	32000493          	li	s1,800
    int pid1 = fork();
    1d10:	00004097          	auipc	ra,0x4
    1d14:	eb0080e7          	jalr	-336(ra) # 5bc0 <fork>
    if(pid1 < 0){
    1d18:	00054f63          	bltz	a0,1d36 <reparent2+0x34>
    if(pid1 == 0){
    1d1c:	c915                	beqz	a0,1d50 <reparent2+0x4e>
    wait(0);
    1d1e:	4501                	li	a0,0
    1d20:	00004097          	auipc	ra,0x4
    1d24:	eb0080e7          	jalr	-336(ra) # 5bd0 <wait>
  for(int i = 0; i < 800; i++){
    1d28:	34fd                	addiw	s1,s1,-1
    1d2a:	f0fd                	bnez	s1,1d10 <reparent2+0xe>
  exit(0);
    1d2c:	4501                	li	a0,0
    1d2e:	00004097          	auipc	ra,0x4
    1d32:	e9a080e7          	jalr	-358(ra) # 5bc8 <exit>
      printf("fork failed\n");
    1d36:	00005517          	auipc	a0,0x5
    1d3a:	0a250513          	addi	a0,a0,162 # 6dd8 <malloc+0xdd2>
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	20a080e7          	jalr	522(ra) # 5f48 <printf>
      exit(1);
    1d46:	4505                	li	a0,1
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	e80080e7          	jalr	-384(ra) # 5bc8 <exit>
      fork();
    1d50:	00004097          	auipc	ra,0x4
    1d54:	e70080e7          	jalr	-400(ra) # 5bc0 <fork>
      fork();
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e68080e7          	jalr	-408(ra) # 5bc0 <fork>
      exit(0);
    1d60:	4501                	li	a0,0
    1d62:	00004097          	auipc	ra,0x4
    1d66:	e66080e7          	jalr	-410(ra) # 5bc8 <exit>

0000000000001d6a <createdelete>:
{
    1d6a:	7175                	addi	sp,sp,-144
    1d6c:	e506                	sd	ra,136(sp)
    1d6e:	e122                	sd	s0,128(sp)
    1d70:	fca6                	sd	s1,120(sp)
    1d72:	f8ca                	sd	s2,112(sp)
    1d74:	f4ce                	sd	s3,104(sp)
    1d76:	f0d2                	sd	s4,96(sp)
    1d78:	ecd6                	sd	s5,88(sp)
    1d7a:	e8da                	sd	s6,80(sp)
    1d7c:	e4de                	sd	s7,72(sp)
    1d7e:	e0e2                	sd	s8,64(sp)
    1d80:	fc66                	sd	s9,56(sp)
    1d82:	0900                	addi	s0,sp,144
    1d84:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d86:	4901                	li	s2,0
    1d88:	4991                	li	s3,4
    pid = fork();
    1d8a:	00004097          	auipc	ra,0x4
    1d8e:	e36080e7          	jalr	-458(ra) # 5bc0 <fork>
    1d92:	84aa                	mv	s1,a0
    if(pid < 0){
    1d94:	02054f63          	bltz	a0,1dd2 <createdelete+0x68>
    if(pid == 0){
    1d98:	c939                	beqz	a0,1dee <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d9a:	2905                	addiw	s2,s2,1
    1d9c:	ff3917e3          	bne	s2,s3,1d8a <createdelete+0x20>
    1da0:	4491                	li	s1,4
    wait(&xstatus);
    1da2:	f7c40513          	addi	a0,s0,-132
    1da6:	00004097          	auipc	ra,0x4
    1daa:	e2a080e7          	jalr	-470(ra) # 5bd0 <wait>
    if(xstatus != 0)
    1dae:	f7c42903          	lw	s2,-132(s0)
    1db2:	0e091263          	bnez	s2,1e96 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db6:	34fd                	addiw	s1,s1,-1
    1db8:	f4ed                	bnez	s1,1da2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dba:	f8040123          	sb	zero,-126(s0)
    1dbe:	03000993          	li	s3,48
    1dc2:	5a7d                	li	s4,-1
    1dc4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dca:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dcc:	07400a93          	li	s5,116
    1dd0:	a29d                	j	1f36 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd2:	85e6                	mv	a1,s9
    1dd4:	00005517          	auipc	a0,0x5
    1dd8:	00450513          	addi	a0,a0,4 # 6dd8 <malloc+0xdd2>
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	16c080e7          	jalr	364(ra) # 5f48 <printf>
      exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00004097          	auipc	ra,0x4
    1dea:	de2080e7          	jalr	-542(ra) # 5bc8 <exit>
      name[0] = 'p' + pi;
    1dee:	0709091b          	addiw	s2,s2,112
    1df2:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df6:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1dfa:	4951                	li	s2,20
    1dfc:	a015                	j	1e20 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfe:	85e6                	mv	a1,s9
    1e00:	00005517          	auipc	a0,0x5
    1e04:	c6850513          	addi	a0,a0,-920 # 6a68 <malloc+0xa62>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	140080e7          	jalr	320(ra) # 5f48 <printf>
          exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	db6080e7          	jalr	-586(ra) # 5bc8 <exit>
      for(i = 0; i < N; i++){
    1e1a:	2485                	addiw	s1,s1,1
    1e1c:	07248863          	beq	s1,s2,1e8c <createdelete+0x122>
        name[1] = '0' + i;
    1e20:	0304879b          	addiw	a5,s1,48
    1e24:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e28:	20200593          	li	a1,514
    1e2c:	f8040513          	addi	a0,s0,-128
    1e30:	00004097          	auipc	ra,0x4
    1e34:	dd8080e7          	jalr	-552(ra) # 5c08 <open>
        if(fd < 0){
    1e38:	fc0543e3          	bltz	a0,1dfe <createdelete+0x94>
        close(fd);
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	db4080e7          	jalr	-588(ra) # 5bf0 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e44:	fc905be3          	blez	s1,1e1a <createdelete+0xb0>
    1e48:	0014f793          	andi	a5,s1,1
    1e4c:	f7f9                	bnez	a5,1e1a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4e:	01f4d79b          	srliw	a5,s1,0x1f
    1e52:	9fa5                	addw	a5,a5,s1
    1e54:	4017d79b          	sraiw	a5,a5,0x1
    1e58:	0307879b          	addiw	a5,a5,48
    1e5c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e60:	f8040513          	addi	a0,s0,-128
    1e64:	00004097          	auipc	ra,0x4
    1e68:	db4080e7          	jalr	-588(ra) # 5c18 <unlink>
    1e6c:	fa0557e3          	bgez	a0,1e1a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e70:	85e6                	mv	a1,s9
    1e72:	00005517          	auipc	a0,0x5
    1e76:	d4e50513          	addi	a0,a0,-690 # 6bc0 <malloc+0xbba>
    1e7a:	00004097          	auipc	ra,0x4
    1e7e:	0ce080e7          	jalr	206(ra) # 5f48 <printf>
            exit(1);
    1e82:	4505                	li	a0,1
    1e84:	00004097          	auipc	ra,0x4
    1e88:	d44080e7          	jalr	-700(ra) # 5bc8 <exit>
      exit(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	d3a080e7          	jalr	-710(ra) # 5bc8 <exit>
      exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	d30080e7          	jalr	-720(ra) # 5bc8 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea0:	f8040613          	addi	a2,s0,-128
    1ea4:	85e6                	mv	a1,s9
    1ea6:	00005517          	auipc	a0,0x5
    1eaa:	d3250513          	addi	a0,a0,-718 # 6bd8 <malloc+0xbd2>
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	09a080e7          	jalr	154(ra) # 5f48 <printf>
        exit(1);
    1eb6:	4505                	li	a0,1
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	d10080e7          	jalr	-752(ra) # 5bc8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec0:	054b7163          	bgeu	s6,s4,1f02 <createdelete+0x198>
      if(fd >= 0)
    1ec4:	02055a63          	bgez	a0,1ef8 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec8:	2485                	addiw	s1,s1,1
    1eca:	0ff4f493          	zext.b	s1,s1
    1ece:	05548c63          	beq	s1,s5,1f26 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eda:	4581                	li	a1,0
    1edc:	f8040513          	addi	a0,s0,-128
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	d28080e7          	jalr	-728(ra) # 5c08 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee8:	00090463          	beqz	s2,1ef0 <createdelete+0x186>
    1eec:	fd2bdae3          	bge	s7,s2,1ec0 <createdelete+0x156>
    1ef0:	fa0548e3          	bltz	a0,1ea0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef4:	014b7963          	bgeu	s6,s4,1f06 <createdelete+0x19c>
        close(fd);
    1ef8:	00004097          	auipc	ra,0x4
    1efc:	cf8080e7          	jalr	-776(ra) # 5bf0 <close>
    1f00:	b7e1                	j	1ec8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f02:	fc0543e3          	bltz	a0,1ec8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f06:	f8040613          	addi	a2,s0,-128
    1f0a:	85e6                	mv	a1,s9
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	cf450513          	addi	a0,a0,-780 # 6c00 <malloc+0xbfa>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	034080e7          	jalr	52(ra) # 5f48 <printf>
        exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	caa080e7          	jalr	-854(ra) # 5bc8 <exit>
  for(i = 0; i < N; i++){
    1f26:	2905                	addiw	s2,s2,1
    1f28:	2a05                	addiw	s4,s4,1
    1f2a:	2985                	addiw	s3,s3,1
    1f2c:	0ff9f993          	zext.b	s3,s3
    1f30:	47d1                	li	a5,20
    1f32:	02f90a63          	beq	s2,a5,1f66 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f36:	84e2                	mv	s1,s8
    1f38:	bf69                	j	1ed2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f3a:	2905                	addiw	s2,s2,1
    1f3c:	0ff97913          	zext.b	s2,s2
    1f40:	2985                	addiw	s3,s3,1
    1f42:	0ff9f993          	zext.b	s3,s3
    1f46:	03490863          	beq	s2,s4,1f76 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f4a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f4c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f50:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f54:	f8040513          	addi	a0,s0,-128
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	cc0080e7          	jalr	-832(ra) # 5c18 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f60:	34fd                	addiw	s1,s1,-1
    1f62:	f4ed                	bnez	s1,1f4c <createdelete+0x1e2>
    1f64:	bfd9                	j	1f3a <createdelete+0x1d0>
    1f66:	03000993          	li	s3,48
    1f6a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f70:	08400a13          	li	s4,132
    1f74:	bfd9                	j	1f4a <createdelete+0x1e0>
}
    1f76:	60aa                	ld	ra,136(sp)
    1f78:	640a                	ld	s0,128(sp)
    1f7a:	74e6                	ld	s1,120(sp)
    1f7c:	7946                	ld	s2,112(sp)
    1f7e:	79a6                	ld	s3,104(sp)
    1f80:	7a06                	ld	s4,96(sp)
    1f82:	6ae6                	ld	s5,88(sp)
    1f84:	6b46                	ld	s6,80(sp)
    1f86:	6ba6                	ld	s7,72(sp)
    1f88:	6c06                	ld	s8,64(sp)
    1f8a:	7ce2                	ld	s9,56(sp)
    1f8c:	6149                	addi	sp,sp,144
    1f8e:	8082                	ret

0000000000001f90 <linkunlink>:
{
    1f90:	711d                	addi	sp,sp,-96
    1f92:	ec86                	sd	ra,88(sp)
    1f94:	e8a2                	sd	s0,80(sp)
    1f96:	e4a6                	sd	s1,72(sp)
    1f98:	e0ca                	sd	s2,64(sp)
    1f9a:	fc4e                	sd	s3,56(sp)
    1f9c:	f852                	sd	s4,48(sp)
    1f9e:	f456                	sd	s5,40(sp)
    1fa0:	f05a                	sd	s6,32(sp)
    1fa2:	ec5e                	sd	s7,24(sp)
    1fa4:	e862                	sd	s8,16(sp)
    1fa6:	e466                	sd	s9,8(sp)
    1fa8:	1080                	addi	s0,sp,96
    1faa:	84aa                	mv	s1,a0
  unlink("x");
    1fac:	00004517          	auipc	a0,0x4
    1fb0:	20c50513          	addi	a0,a0,524 # 61b8 <malloc+0x1b2>
    1fb4:	00004097          	auipc	ra,0x4
    1fb8:	c64080e7          	jalr	-924(ra) # 5c18 <unlink>
  pid = fork();
    1fbc:	00004097          	auipc	ra,0x4
    1fc0:	c04080e7          	jalr	-1020(ra) # 5bc0 <fork>
  if(pid < 0){
    1fc4:	02054b63          	bltz	a0,1ffa <linkunlink+0x6a>
    1fc8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fca:	4c85                	li	s9,1
    1fcc:	e119                	bnez	a0,1fd2 <linkunlink+0x42>
    1fce:	06100c93          	li	s9,97
    1fd2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd6:	41c659b7          	lui	s3,0x41c65
    1fda:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1fde:	690d                	lui	s2,0x3
    1fe0:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x13>
    if((x % 3) == 0){
    1fe4:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe6:	4b05                	li	s6,1
      unlink("x");
    1fe8:	00004a97          	auipc	s5,0x4
    1fec:	1d0a8a93          	addi	s5,s5,464 # 61b8 <malloc+0x1b2>
      link("cat", "x");
    1ff0:	00005b97          	auipc	s7,0x5
    1ff4:	c38b8b93          	addi	s7,s7,-968 # 6c28 <malloc+0xc22>
    1ff8:	a825                	j	2030 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ffa:	85a6                	mv	a1,s1
    1ffc:	00005517          	auipc	a0,0x5
    2000:	9d450513          	addi	a0,a0,-1580 # 69d0 <malloc+0x9ca>
    2004:	00004097          	auipc	ra,0x4
    2008:	f44080e7          	jalr	-188(ra) # 5f48 <printf>
    exit(1);
    200c:	4505                	li	a0,1
    200e:	00004097          	auipc	ra,0x4
    2012:	bba080e7          	jalr	-1094(ra) # 5bc8 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2016:	20200593          	li	a1,514
    201a:	8556                	mv	a0,s5
    201c:	00004097          	auipc	ra,0x4
    2020:	bec080e7          	jalr	-1044(ra) # 5c08 <open>
    2024:	00004097          	auipc	ra,0x4
    2028:	bcc080e7          	jalr	-1076(ra) # 5bf0 <close>
  for(i = 0; i < 100; i++){
    202c:	34fd                	addiw	s1,s1,-1
    202e:	c88d                	beqz	s1,2060 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2030:	033c87bb          	mulw	a5,s9,s3
    2034:	012787bb          	addw	a5,a5,s2
    2038:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    203c:	0347f7bb          	remuw	a5,a5,s4
    2040:	dbf9                	beqz	a5,2016 <linkunlink+0x86>
    } else if((x % 3) == 1){
    2042:	01678863          	beq	a5,s6,2052 <linkunlink+0xc2>
      unlink("x");
    2046:	8556                	mv	a0,s5
    2048:	00004097          	auipc	ra,0x4
    204c:	bd0080e7          	jalr	-1072(ra) # 5c18 <unlink>
    2050:	bff1                	j	202c <linkunlink+0x9c>
      link("cat", "x");
    2052:	85d6                	mv	a1,s5
    2054:	855e                	mv	a0,s7
    2056:	00004097          	auipc	ra,0x4
    205a:	bd2080e7          	jalr	-1070(ra) # 5c28 <link>
    205e:	b7f9                	j	202c <linkunlink+0x9c>
  if(pid)
    2060:	020c0463          	beqz	s8,2088 <linkunlink+0xf8>
    wait(0);
    2064:	4501                	li	a0,0
    2066:	00004097          	auipc	ra,0x4
    206a:	b6a080e7          	jalr	-1174(ra) # 5bd0 <wait>
}
    206e:	60e6                	ld	ra,88(sp)
    2070:	6446                	ld	s0,80(sp)
    2072:	64a6                	ld	s1,72(sp)
    2074:	6906                	ld	s2,64(sp)
    2076:	79e2                	ld	s3,56(sp)
    2078:	7a42                	ld	s4,48(sp)
    207a:	7aa2                	ld	s5,40(sp)
    207c:	7b02                	ld	s6,32(sp)
    207e:	6be2                	ld	s7,24(sp)
    2080:	6c42                	ld	s8,16(sp)
    2082:	6ca2                	ld	s9,8(sp)
    2084:	6125                	addi	sp,sp,96
    2086:	8082                	ret
    exit(0);
    2088:	4501                	li	a0,0
    208a:	00004097          	auipc	ra,0x4
    208e:	b3e080e7          	jalr	-1218(ra) # 5bc8 <exit>

0000000000002092 <forktest>:
{
    2092:	7179                	addi	sp,sp,-48
    2094:	f406                	sd	ra,40(sp)
    2096:	f022                	sd	s0,32(sp)
    2098:	ec26                	sd	s1,24(sp)
    209a:	e84a                	sd	s2,16(sp)
    209c:	e44e                	sd	s3,8(sp)
    209e:	1800                	addi	s0,sp,48
    20a0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a2:	4481                	li	s1,0
    20a4:	3e800913          	li	s2,1000
    pid = fork();
    20a8:	00004097          	auipc	ra,0x4
    20ac:	b18080e7          	jalr	-1256(ra) # 5bc0 <fork>
    if(pid < 0)
    20b0:	02054863          	bltz	a0,20e0 <forktest+0x4e>
    if(pid == 0)
    20b4:	c115                	beqz	a0,20d8 <forktest+0x46>
  for(n=0; n<N; n++){
    20b6:	2485                	addiw	s1,s1,1
    20b8:	ff2498e3          	bne	s1,s2,20a8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00005517          	auipc	a0,0x5
    20c2:	b8a50513          	addi	a0,a0,-1142 # 6c48 <malloc+0xc42>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	e82080e7          	jalr	-382(ra) # 5f48 <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00004097          	auipc	ra,0x4
    20d4:	af8080e7          	jalr	-1288(ra) # 5bc8 <exit>
      exit(0);
    20d8:	00004097          	auipc	ra,0x4
    20dc:	af0080e7          	jalr	-1296(ra) # 5bc8 <exit>
  if (n == 0) {
    20e0:	cc9d                	beqz	s1,211e <forktest+0x8c>
  if(n == N){
    20e2:	3e800793          	li	a5,1000
    20e6:	fcf48be3          	beq	s1,a5,20bc <forktest+0x2a>
  for(; n > 0; n--){
    20ea:	00905b63          	blez	s1,2100 <forktest+0x6e>
    if(wait(0) < 0){
    20ee:	4501                	li	a0,0
    20f0:	00004097          	auipc	ra,0x4
    20f4:	ae0080e7          	jalr	-1312(ra) # 5bd0 <wait>
    20f8:	04054163          	bltz	a0,213a <forktest+0xa8>
  for(; n > 0; n--){
    20fc:	34fd                	addiw	s1,s1,-1
    20fe:	f8e5                	bnez	s1,20ee <forktest+0x5c>
  if(wait(0) != -1){
    2100:	4501                	li	a0,0
    2102:	00004097          	auipc	ra,0x4
    2106:	ace080e7          	jalr	-1330(ra) # 5bd0 <wait>
    210a:	57fd                	li	a5,-1
    210c:	04f51563          	bne	a0,a5,2156 <forktest+0xc4>
}
    2110:	70a2                	ld	ra,40(sp)
    2112:	7402                	ld	s0,32(sp)
    2114:	64e2                	ld	s1,24(sp)
    2116:	6942                	ld	s2,16(sp)
    2118:	69a2                	ld	s3,8(sp)
    211a:	6145                	addi	sp,sp,48
    211c:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211e:	85ce                	mv	a1,s3
    2120:	00005517          	auipc	a0,0x5
    2124:	b1050513          	addi	a0,a0,-1264 # 6c30 <malloc+0xc2a>
    2128:	00004097          	auipc	ra,0x4
    212c:	e20080e7          	jalr	-480(ra) # 5f48 <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	00004097          	auipc	ra,0x4
    2136:	a96080e7          	jalr	-1386(ra) # 5bc8 <exit>
      printf("%s: wait stopped early\n", s);
    213a:	85ce                	mv	a1,s3
    213c:	00005517          	auipc	a0,0x5
    2140:	b3450513          	addi	a0,a0,-1228 # 6c70 <malloc+0xc6a>
    2144:	00004097          	auipc	ra,0x4
    2148:	e04080e7          	jalr	-508(ra) # 5f48 <printf>
      exit(1);
    214c:	4505                	li	a0,1
    214e:	00004097          	auipc	ra,0x4
    2152:	a7a080e7          	jalr	-1414(ra) # 5bc8 <exit>
    printf("%s: wait got too many\n", s);
    2156:	85ce                	mv	a1,s3
    2158:	00005517          	auipc	a0,0x5
    215c:	b3050513          	addi	a0,a0,-1232 # 6c88 <malloc+0xc82>
    2160:	00004097          	auipc	ra,0x4
    2164:	de8080e7          	jalr	-536(ra) # 5f48 <printf>
    exit(1);
    2168:	4505                	li	a0,1
    216a:	00004097          	auipc	ra,0x4
    216e:	a5e080e7          	jalr	-1442(ra) # 5bc8 <exit>

0000000000002172 <kernmem>:
{
    2172:	715d                	addi	sp,sp,-80
    2174:	e486                	sd	ra,72(sp)
    2176:	e0a2                	sd	s0,64(sp)
    2178:	fc26                	sd	s1,56(sp)
    217a:	f84a                	sd	s2,48(sp)
    217c:	f44e                	sd	s3,40(sp)
    217e:	f052                	sd	s4,32(sp)
    2180:	ec56                	sd	s5,24(sp)
    2182:	0880                	addi	s0,sp,80
    2184:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2186:	4485                	li	s1,1
    2188:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    218a:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218c:	69b1                	lui	s3,0xc
    218e:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    2192:	1003d937          	lui	s2,0x1003d
    2196:	090e                	slli	s2,s2,0x3
    2198:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    219c:	00004097          	auipc	ra,0x4
    21a0:	a24080e7          	jalr	-1500(ra) # 5bc0 <fork>
    if(pid < 0){
    21a4:	02054963          	bltz	a0,21d6 <kernmem+0x64>
    if(pid == 0){
    21a8:	c529                	beqz	a0,21f2 <kernmem+0x80>
    wait(&xstatus);
    21aa:	fbc40513          	addi	a0,s0,-68
    21ae:	00004097          	auipc	ra,0x4
    21b2:	a22080e7          	jalr	-1502(ra) # 5bd0 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b6:	fbc42783          	lw	a5,-68(s0)
    21ba:	05579d63          	bne	a5,s5,2214 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21be:	94ce                	add	s1,s1,s3
    21c0:	fd249ee3          	bne	s1,s2,219c <kernmem+0x2a>
}
    21c4:	60a6                	ld	ra,72(sp)
    21c6:	6406                	ld	s0,64(sp)
    21c8:	74e2                	ld	s1,56(sp)
    21ca:	7942                	ld	s2,48(sp)
    21cc:	79a2                	ld	s3,40(sp)
    21ce:	7a02                	ld	s4,32(sp)
    21d0:	6ae2                	ld	s5,24(sp)
    21d2:	6161                	addi	sp,sp,80
    21d4:	8082                	ret
      printf("%s: fork failed\n", s);
    21d6:	85d2                	mv	a1,s4
    21d8:	00004517          	auipc	a0,0x4
    21dc:	7f850513          	addi	a0,a0,2040 # 69d0 <malloc+0x9ca>
    21e0:	00004097          	auipc	ra,0x4
    21e4:	d68080e7          	jalr	-664(ra) # 5f48 <printf>
      exit(1);
    21e8:	4505                	li	a0,1
    21ea:	00004097          	auipc	ra,0x4
    21ee:	9de080e7          	jalr	-1570(ra) # 5bc8 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f2:	0004c683          	lbu	a3,0(s1)
    21f6:	8626                	mv	a2,s1
    21f8:	85d2                	mv	a1,s4
    21fa:	00005517          	auipc	a0,0x5
    21fe:	aa650513          	addi	a0,a0,-1370 # 6ca0 <malloc+0xc9a>
    2202:	00004097          	auipc	ra,0x4
    2206:	d46080e7          	jalr	-698(ra) # 5f48 <printf>
      exit(1);
    220a:	4505                	li	a0,1
    220c:	00004097          	auipc	ra,0x4
    2210:	9bc080e7          	jalr	-1604(ra) # 5bc8 <exit>
      exit(1);
    2214:	4505                	li	a0,1
    2216:	00004097          	auipc	ra,0x4
    221a:	9b2080e7          	jalr	-1614(ra) # 5bc8 <exit>

000000000000221e <MAXVAplus>:
{
    221e:	7179                	addi	sp,sp,-48
    2220:	f406                	sd	ra,40(sp)
    2222:	f022                	sd	s0,32(sp)
    2224:	ec26                	sd	s1,24(sp)
    2226:	e84a                	sd	s2,16(sp)
    2228:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    222a:	4785                	li	a5,1
    222c:	179a                	slli	a5,a5,0x26
    222e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2232:	fd843783          	ld	a5,-40(s0)
    2236:	cf85                	beqz	a5,226e <MAXVAplus+0x50>
    2238:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    223a:	54fd                	li	s1,-1
    pid = fork();
    223c:	00004097          	auipc	ra,0x4
    2240:	984080e7          	jalr	-1660(ra) # 5bc0 <fork>
    if(pid < 0){
    2244:	02054b63          	bltz	a0,227a <MAXVAplus+0x5c>
    if(pid == 0){
    2248:	c539                	beqz	a0,2296 <MAXVAplus+0x78>
    wait(&xstatus);
    224a:	fd440513          	addi	a0,s0,-44
    224e:	00004097          	auipc	ra,0x4
    2252:	982080e7          	jalr	-1662(ra) # 5bd0 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2256:	fd442783          	lw	a5,-44(s0)
    225a:	06979463          	bne	a5,s1,22c2 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    225e:	fd843783          	ld	a5,-40(s0)
    2262:	0786                	slli	a5,a5,0x1
    2264:	fcf43c23          	sd	a5,-40(s0)
    2268:	fd843783          	ld	a5,-40(s0)
    226c:	fbe1                	bnez	a5,223c <MAXVAplus+0x1e>
}
    226e:	70a2                	ld	ra,40(sp)
    2270:	7402                	ld	s0,32(sp)
    2272:	64e2                	ld	s1,24(sp)
    2274:	6942                	ld	s2,16(sp)
    2276:	6145                	addi	sp,sp,48
    2278:	8082                	ret
      printf("%s: fork failed\n", s);
    227a:	85ca                	mv	a1,s2
    227c:	00004517          	auipc	a0,0x4
    2280:	75450513          	addi	a0,a0,1876 # 69d0 <malloc+0x9ca>
    2284:	00004097          	auipc	ra,0x4
    2288:	cc4080e7          	jalr	-828(ra) # 5f48 <printf>
      exit(1);
    228c:	4505                	li	a0,1
    228e:	00004097          	auipc	ra,0x4
    2292:	93a080e7          	jalr	-1734(ra) # 5bc8 <exit>
      *(char*)a = 99;
    2296:	fd843783          	ld	a5,-40(s0)
    229a:	06300713          	li	a4,99
    229e:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a2:	fd843603          	ld	a2,-40(s0)
    22a6:	85ca                	mv	a1,s2
    22a8:	00005517          	auipc	a0,0x5
    22ac:	a1850513          	addi	a0,a0,-1512 # 6cc0 <malloc+0xcba>
    22b0:	00004097          	auipc	ra,0x4
    22b4:	c98080e7          	jalr	-872(ra) # 5f48 <printf>
      exit(1);
    22b8:	4505                	li	a0,1
    22ba:	00004097          	auipc	ra,0x4
    22be:	90e080e7          	jalr	-1778(ra) # 5bc8 <exit>
      exit(1);
    22c2:	4505                	li	a0,1
    22c4:	00004097          	auipc	ra,0x4
    22c8:	904080e7          	jalr	-1788(ra) # 5bc8 <exit>

00000000000022cc <bigargtest>:
{
    22cc:	7179                	addi	sp,sp,-48
    22ce:	f406                	sd	ra,40(sp)
    22d0:	f022                	sd	s0,32(sp)
    22d2:	ec26                	sd	s1,24(sp)
    22d4:	1800                	addi	s0,sp,48
    22d6:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22d8:	00005517          	auipc	a0,0x5
    22dc:	a0050513          	addi	a0,a0,-1536 # 6cd8 <malloc+0xcd2>
    22e0:	00004097          	auipc	ra,0x4
    22e4:	938080e7          	jalr	-1736(ra) # 5c18 <unlink>
  pid = fork();
    22e8:	00004097          	auipc	ra,0x4
    22ec:	8d8080e7          	jalr	-1832(ra) # 5bc0 <fork>
  if(pid == 0){
    22f0:	c121                	beqz	a0,2330 <bigargtest+0x64>
  } else if(pid < 0){
    22f2:	0a054063          	bltz	a0,2392 <bigargtest+0xc6>
  wait(&xstatus);
    22f6:	fdc40513          	addi	a0,s0,-36
    22fa:	00004097          	auipc	ra,0x4
    22fe:	8d6080e7          	jalr	-1834(ra) # 5bd0 <wait>
  if(xstatus != 0)
    2302:	fdc42503          	lw	a0,-36(s0)
    2306:	e545                	bnez	a0,23ae <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2308:	4581                	li	a1,0
    230a:	00005517          	auipc	a0,0x5
    230e:	9ce50513          	addi	a0,a0,-1586 # 6cd8 <malloc+0xcd2>
    2312:	00004097          	auipc	ra,0x4
    2316:	8f6080e7          	jalr	-1802(ra) # 5c08 <open>
  if(fd < 0){
    231a:	08054e63          	bltz	a0,23b6 <bigargtest+0xea>
  close(fd);
    231e:	00004097          	auipc	ra,0x4
    2322:	8d2080e7          	jalr	-1838(ra) # 5bf0 <close>
}
    2326:	70a2                	ld	ra,40(sp)
    2328:	7402                	ld	s0,32(sp)
    232a:	64e2                	ld	s1,24(sp)
    232c:	6145                	addi	sp,sp,48
    232e:	8082                	ret
    2330:	00007797          	auipc	a5,0x7
    2334:	13078793          	addi	a5,a5,304 # 9460 <args.1>
    2338:	00007697          	auipc	a3,0x7
    233c:	22068693          	addi	a3,a3,544 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2340:	00005717          	auipc	a4,0x5
    2344:	9a870713          	addi	a4,a4,-1624 # 6ce8 <malloc+0xce2>
    2348:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    234a:	07a1                	addi	a5,a5,8
    234c:	fed79ee3          	bne	a5,a3,2348 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2350:	00007597          	auipc	a1,0x7
    2354:	11058593          	addi	a1,a1,272 # 9460 <args.1>
    2358:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    235c:	00004517          	auipc	a0,0x4
    2360:	dec50513          	addi	a0,a0,-532 # 6148 <malloc+0x142>
    2364:	00004097          	auipc	ra,0x4
    2368:	89c080e7          	jalr	-1892(ra) # 5c00 <exec>
    fd = open("bigarg-ok", O_CREATE);
    236c:	20000593          	li	a1,512
    2370:	00005517          	auipc	a0,0x5
    2374:	96850513          	addi	a0,a0,-1688 # 6cd8 <malloc+0xcd2>
    2378:	00004097          	auipc	ra,0x4
    237c:	890080e7          	jalr	-1904(ra) # 5c08 <open>
    close(fd);
    2380:	00004097          	auipc	ra,0x4
    2384:	870080e7          	jalr	-1936(ra) # 5bf0 <close>
    exit(0);
    2388:	4501                	li	a0,0
    238a:	00004097          	auipc	ra,0x4
    238e:	83e080e7          	jalr	-1986(ra) # 5bc8 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2392:	85a6                	mv	a1,s1
    2394:	00005517          	auipc	a0,0x5
    2398:	a3450513          	addi	a0,a0,-1484 # 6dc8 <malloc+0xdc2>
    239c:	00004097          	auipc	ra,0x4
    23a0:	bac080e7          	jalr	-1108(ra) # 5f48 <printf>
    exit(1);
    23a4:	4505                	li	a0,1
    23a6:	00004097          	auipc	ra,0x4
    23aa:	822080e7          	jalr	-2014(ra) # 5bc8 <exit>
    exit(xstatus);
    23ae:	00004097          	auipc	ra,0x4
    23b2:	81a080e7          	jalr	-2022(ra) # 5bc8 <exit>
    printf("%s: bigarg test failed!\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a3050513          	addi	a0,a0,-1488 # 6de8 <malloc+0xde2>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	b88080e7          	jalr	-1144(ra) # 5f48 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00003097          	auipc	ra,0x3
    23ce:	7fe080e7          	jalr	2046(ra) # 5bc8 <exit>

00000000000023d2 <stacktest>:
{
    23d2:	7179                	addi	sp,sp,-48
    23d4:	f406                	sd	ra,40(sp)
    23d6:	f022                	sd	s0,32(sp)
    23d8:	ec26                	sd	s1,24(sp)
    23da:	1800                	addi	s0,sp,48
    23dc:	84aa                	mv	s1,a0
  pid = fork();
    23de:	00003097          	auipc	ra,0x3
    23e2:	7e2080e7          	jalr	2018(ra) # 5bc0 <fork>
  if(pid == 0) {
    23e6:	c115                	beqz	a0,240a <stacktest+0x38>
  } else if(pid < 0){
    23e8:	04054463          	bltz	a0,2430 <stacktest+0x5e>
  wait(&xstatus);
    23ec:	fdc40513          	addi	a0,s0,-36
    23f0:	00003097          	auipc	ra,0x3
    23f4:	7e0080e7          	jalr	2016(ra) # 5bd0 <wait>
  if(xstatus == -1)  // kernel killed child?
    23f8:	fdc42503          	lw	a0,-36(s0)
    23fc:	57fd                	li	a5,-1
    23fe:	04f50763          	beq	a0,a5,244c <stacktest+0x7a>
    exit(xstatus);
    2402:	00003097          	auipc	ra,0x3
    2406:	7c6080e7          	jalr	1990(ra) # 5bc8 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    240a:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    240c:	77fd                	lui	a5,0xfffff
    240e:	97ba                	add	a5,a5,a4
    2410:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2414:	85a6                	mv	a1,s1
    2416:	00005517          	auipc	a0,0x5
    241a:	9f250513          	addi	a0,a0,-1550 # 6e08 <malloc+0xe02>
    241e:	00004097          	auipc	ra,0x4
    2422:	b2a080e7          	jalr	-1238(ra) # 5f48 <printf>
    exit(1);
    2426:	4505                	li	a0,1
    2428:	00003097          	auipc	ra,0x3
    242c:	7a0080e7          	jalr	1952(ra) # 5bc8 <exit>
    printf("%s: fork failed\n", s);
    2430:	85a6                	mv	a1,s1
    2432:	00004517          	auipc	a0,0x4
    2436:	59e50513          	addi	a0,a0,1438 # 69d0 <malloc+0x9ca>
    243a:	00004097          	auipc	ra,0x4
    243e:	b0e080e7          	jalr	-1266(ra) # 5f48 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	00003097          	auipc	ra,0x3
    2448:	784080e7          	jalr	1924(ra) # 5bc8 <exit>
    exit(0);
    244c:	4501                	li	a0,0
    244e:	00003097          	auipc	ra,0x3
    2452:	77a080e7          	jalr	1914(ra) # 5bc8 <exit>

0000000000002456 <textwrite>:
{
    2456:	7179                	addi	sp,sp,-48
    2458:	f406                	sd	ra,40(sp)
    245a:	f022                	sd	s0,32(sp)
    245c:	ec26                	sd	s1,24(sp)
    245e:	1800                	addi	s0,sp,48
    2460:	84aa                	mv	s1,a0
  pid = fork();
    2462:	00003097          	auipc	ra,0x3
    2466:	75e080e7          	jalr	1886(ra) # 5bc0 <fork>
  if(pid == 0) {
    246a:	c115                	beqz	a0,248e <textwrite+0x38>
  } else if(pid < 0){
    246c:	02054963          	bltz	a0,249e <textwrite+0x48>
  wait(&xstatus);
    2470:	fdc40513          	addi	a0,s0,-36
    2474:	00003097          	auipc	ra,0x3
    2478:	75c080e7          	jalr	1884(ra) # 5bd0 <wait>
  if(xstatus == -1)  // kernel killed child?
    247c:	fdc42503          	lw	a0,-36(s0)
    2480:	57fd                	li	a5,-1
    2482:	02f50c63          	beq	a0,a5,24ba <textwrite+0x64>
    exit(xstatus);
    2486:	00003097          	auipc	ra,0x3
    248a:	742080e7          	jalr	1858(ra) # 5bc8 <exit>
    *addr = 10;
    248e:	47a9                	li	a5,10
    2490:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2494:	4505                	li	a0,1
    2496:	00003097          	auipc	ra,0x3
    249a:	732080e7          	jalr	1842(ra) # 5bc8 <exit>
    printf("%s: fork failed\n", s);
    249e:	85a6                	mv	a1,s1
    24a0:	00004517          	auipc	a0,0x4
    24a4:	53050513          	addi	a0,a0,1328 # 69d0 <malloc+0x9ca>
    24a8:	00004097          	auipc	ra,0x4
    24ac:	aa0080e7          	jalr	-1376(ra) # 5f48 <printf>
    exit(1);
    24b0:	4505                	li	a0,1
    24b2:	00003097          	auipc	ra,0x3
    24b6:	716080e7          	jalr	1814(ra) # 5bc8 <exit>
    exit(0);
    24ba:	4501                	li	a0,0
    24bc:	00003097          	auipc	ra,0x3
    24c0:	70c080e7          	jalr	1804(ra) # 5bc8 <exit>

00000000000024c4 <manywrites>:
{
    24c4:	711d                	addi	sp,sp,-96
    24c6:	ec86                	sd	ra,88(sp)
    24c8:	e8a2                	sd	s0,80(sp)
    24ca:	e4a6                	sd	s1,72(sp)
    24cc:	e0ca                	sd	s2,64(sp)
    24ce:	fc4e                	sd	s3,56(sp)
    24d0:	f852                	sd	s4,48(sp)
    24d2:	f456                	sd	s5,40(sp)
    24d4:	f05a                	sd	s6,32(sp)
    24d6:	ec5e                	sd	s7,24(sp)
    24d8:	1080                	addi	s0,sp,96
    24da:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24dc:	4981                	li	s3,0
    24de:	4911                	li	s2,4
    int pid = fork();
    24e0:	00003097          	auipc	ra,0x3
    24e4:	6e0080e7          	jalr	1760(ra) # 5bc0 <fork>
    24e8:	84aa                	mv	s1,a0
    if(pid < 0){
    24ea:	02054963          	bltz	a0,251c <manywrites+0x58>
    if(pid == 0){
    24ee:	c521                	beqz	a0,2536 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24f0:	2985                	addiw	s3,s3,1
    24f2:	ff2997e3          	bne	s3,s2,24e0 <manywrites+0x1c>
    24f6:	4491                	li	s1,4
    int st = 0;
    24f8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24fc:	fa840513          	addi	a0,s0,-88
    2500:	00003097          	auipc	ra,0x3
    2504:	6d0080e7          	jalr	1744(ra) # 5bd0 <wait>
    if(st != 0)
    2508:	fa842503          	lw	a0,-88(s0)
    250c:	ed6d                	bnez	a0,2606 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    250e:	34fd                	addiw	s1,s1,-1
    2510:	f4e5                	bnez	s1,24f8 <manywrites+0x34>
  exit(0);
    2512:	4501                	li	a0,0
    2514:	00003097          	auipc	ra,0x3
    2518:	6b4080e7          	jalr	1716(ra) # 5bc8 <exit>
      printf("fork failed\n");
    251c:	00005517          	auipc	a0,0x5
    2520:	8bc50513          	addi	a0,a0,-1860 # 6dd8 <malloc+0xdd2>
    2524:	00004097          	auipc	ra,0x4
    2528:	a24080e7          	jalr	-1500(ra) # 5f48 <printf>
      exit(1);
    252c:	4505                	li	a0,1
    252e:	00003097          	auipc	ra,0x3
    2532:	69a080e7          	jalr	1690(ra) # 5bc8 <exit>
      name[0] = 'b';
    2536:	06200793          	li	a5,98
    253a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    253e:	0619879b          	addiw	a5,s3,97
    2542:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2546:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    254a:	fa840513          	addi	a0,s0,-88
    254e:	00003097          	auipc	ra,0x3
    2552:	6ca080e7          	jalr	1738(ra) # 5c18 <unlink>
    2556:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2558:	0000ab17          	auipc	s6,0xa
    255c:	720b0b13          	addi	s6,s6,1824 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2560:	8a26                	mv	s4,s1
    2562:	0209ce63          	bltz	s3,259e <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2566:	20200593          	li	a1,514
    256a:	fa840513          	addi	a0,s0,-88
    256e:	00003097          	auipc	ra,0x3
    2572:	69a080e7          	jalr	1690(ra) # 5c08 <open>
    2576:	892a                	mv	s2,a0
          if(fd < 0){
    2578:	04054763          	bltz	a0,25c6 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    257c:	660d                	lui	a2,0x3
    257e:	85da                	mv	a1,s6
    2580:	00003097          	auipc	ra,0x3
    2584:	668080e7          	jalr	1640(ra) # 5be8 <write>
          if(cc != sz){
    2588:	678d                	lui	a5,0x3
    258a:	04f51e63          	bne	a0,a5,25e6 <manywrites+0x122>
          close(fd);
    258e:	854a                	mv	a0,s2
    2590:	00003097          	auipc	ra,0x3
    2594:	660080e7          	jalr	1632(ra) # 5bf0 <close>
        for(int i = 0; i < ci+1; i++){
    2598:	2a05                	addiw	s4,s4,1
    259a:	fd49d6e3          	bge	s3,s4,2566 <manywrites+0xa2>
        unlink(name);
    259e:	fa840513          	addi	a0,s0,-88
    25a2:	00003097          	auipc	ra,0x3
    25a6:	676080e7          	jalr	1654(ra) # 5c18 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25aa:	3bfd                	addiw	s7,s7,-1
    25ac:	fa0b9ae3          	bnez	s7,2560 <manywrites+0x9c>
      unlink(name);
    25b0:	fa840513          	addi	a0,s0,-88
    25b4:	00003097          	auipc	ra,0x3
    25b8:	664080e7          	jalr	1636(ra) # 5c18 <unlink>
      exit(0);
    25bc:	4501                	li	a0,0
    25be:	00003097          	auipc	ra,0x3
    25c2:	60a080e7          	jalr	1546(ra) # 5bc8 <exit>
            printf("%s: cannot create %s\n", s, name);
    25c6:	fa840613          	addi	a2,s0,-88
    25ca:	85d6                	mv	a1,s5
    25cc:	00005517          	auipc	a0,0x5
    25d0:	86450513          	addi	a0,a0,-1948 # 6e30 <malloc+0xe2a>
    25d4:	00004097          	auipc	ra,0x4
    25d8:	974080e7          	jalr	-1676(ra) # 5f48 <printf>
            exit(1);
    25dc:	4505                	li	a0,1
    25de:	00003097          	auipc	ra,0x3
    25e2:	5ea080e7          	jalr	1514(ra) # 5bc8 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25e6:	86aa                	mv	a3,a0
    25e8:	660d                	lui	a2,0x3
    25ea:	85d6                	mv	a1,s5
    25ec:	00004517          	auipc	a0,0x4
    25f0:	c2c50513          	addi	a0,a0,-980 # 6218 <malloc+0x212>
    25f4:	00004097          	auipc	ra,0x4
    25f8:	954080e7          	jalr	-1708(ra) # 5f48 <printf>
            exit(1);
    25fc:	4505                	li	a0,1
    25fe:	00003097          	auipc	ra,0x3
    2602:	5ca080e7          	jalr	1482(ra) # 5bc8 <exit>
      exit(st);
    2606:	00003097          	auipc	ra,0x3
    260a:	5c2080e7          	jalr	1474(ra) # 5bc8 <exit>

000000000000260e <copyinstr3>:
{
    260e:	7179                	addi	sp,sp,-48
    2610:	f406                	sd	ra,40(sp)
    2612:	f022                	sd	s0,32(sp)
    2614:	ec26                	sd	s1,24(sp)
    2616:	1800                	addi	s0,sp,48
  sbrk(8192);
    2618:	6509                	lui	a0,0x2
    261a:	00003097          	auipc	ra,0x3
    261e:	636080e7          	jalr	1590(ra) # 5c50 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2622:	4501                	li	a0,0
    2624:	00003097          	auipc	ra,0x3
    2628:	62c080e7          	jalr	1580(ra) # 5c50 <sbrk>
  if((top % PGSIZE) != 0){
    262c:	03451793          	slli	a5,a0,0x34
    2630:	e3c9                	bnez	a5,26b2 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2632:	4501                	li	a0,0
    2634:	00003097          	auipc	ra,0x3
    2638:	61c080e7          	jalr	1564(ra) # 5c50 <sbrk>
  if(top % PGSIZE){
    263c:	03451793          	slli	a5,a0,0x34
    2640:	e3d9                	bnez	a5,26c6 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2642:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x6f>
  *b = 'x';
    2646:	07800793          	li	a5,120
    264a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    264e:	8526                	mv	a0,s1
    2650:	00003097          	auipc	ra,0x3
    2654:	5c8080e7          	jalr	1480(ra) # 5c18 <unlink>
  if(ret != -1){
    2658:	57fd                	li	a5,-1
    265a:	08f51363          	bne	a0,a5,26e0 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    265e:	20100593          	li	a1,513
    2662:	8526                	mv	a0,s1
    2664:	00003097          	auipc	ra,0x3
    2668:	5a4080e7          	jalr	1444(ra) # 5c08 <open>
  if(fd != -1){
    266c:	57fd                	li	a5,-1
    266e:	08f51863          	bne	a0,a5,26fe <copyinstr3+0xf0>
  ret = link(b, b);
    2672:	85a6                	mv	a1,s1
    2674:	8526                	mv	a0,s1
    2676:	00003097          	auipc	ra,0x3
    267a:	5b2080e7          	jalr	1458(ra) # 5c28 <link>
  if(ret != -1){
    267e:	57fd                	li	a5,-1
    2680:	08f51e63          	bne	a0,a5,271c <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2684:	00005797          	auipc	a5,0x5
    2688:	4b478793          	addi	a5,a5,1204 # 7b38 <malloc+0x1b32>
    268c:	fcf43823          	sd	a5,-48(s0)
    2690:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2694:	fd040593          	addi	a1,s0,-48
    2698:	8526                	mv	a0,s1
    269a:	00003097          	auipc	ra,0x3
    269e:	566080e7          	jalr	1382(ra) # 5c00 <exec>
  if(ret != -1){
    26a2:	57fd                	li	a5,-1
    26a4:	08f51c63          	bne	a0,a5,273c <copyinstr3+0x12e>
}
    26a8:	70a2                	ld	ra,40(sp)
    26aa:	7402                	ld	s0,32(sp)
    26ac:	64e2                	ld	s1,24(sp)
    26ae:	6145                	addi	sp,sp,48
    26b0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b2:	0347d513          	srli	a0,a5,0x34
    26b6:	6785                	lui	a5,0x1
    26b8:	40a7853b          	subw	a0,a5,a0
    26bc:	00003097          	auipc	ra,0x3
    26c0:	594080e7          	jalr	1428(ra) # 5c50 <sbrk>
    26c4:	b7bd                	j	2632 <copyinstr3+0x24>
    printf("oops\n");
    26c6:	00004517          	auipc	a0,0x4
    26ca:	78250513          	addi	a0,a0,1922 # 6e48 <malloc+0xe42>
    26ce:	00004097          	auipc	ra,0x4
    26d2:	87a080e7          	jalr	-1926(ra) # 5f48 <printf>
    exit(1);
    26d6:	4505                	li	a0,1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	4f0080e7          	jalr	1264(ra) # 5bc8 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e0:	862a                	mv	a2,a0
    26e2:	85a6                	mv	a1,s1
    26e4:	00004517          	auipc	a0,0x4
    26e8:	20c50513          	addi	a0,a0,524 # 68f0 <malloc+0x8ea>
    26ec:	00004097          	auipc	ra,0x4
    26f0:	85c080e7          	jalr	-1956(ra) # 5f48 <printf>
    exit(1);
    26f4:	4505                	li	a0,1
    26f6:	00003097          	auipc	ra,0x3
    26fa:	4d2080e7          	jalr	1234(ra) # 5bc8 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26fe:	862a                	mv	a2,a0
    2700:	85a6                	mv	a1,s1
    2702:	00004517          	auipc	a0,0x4
    2706:	20e50513          	addi	a0,a0,526 # 6910 <malloc+0x90a>
    270a:	00004097          	auipc	ra,0x4
    270e:	83e080e7          	jalr	-1986(ra) # 5f48 <printf>
    exit(1);
    2712:	4505                	li	a0,1
    2714:	00003097          	auipc	ra,0x3
    2718:	4b4080e7          	jalr	1204(ra) # 5bc8 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    271c:	86aa                	mv	a3,a0
    271e:	8626                	mv	a2,s1
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	20e50513          	addi	a0,a0,526 # 6930 <malloc+0x92a>
    272a:	00004097          	auipc	ra,0x4
    272e:	81e080e7          	jalr	-2018(ra) # 5f48 <printf>
    exit(1);
    2732:	4505                	li	a0,1
    2734:	00003097          	auipc	ra,0x3
    2738:	494080e7          	jalr	1172(ra) # 5bc8 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    273c:	567d                	li	a2,-1
    273e:	85a6                	mv	a1,s1
    2740:	00004517          	auipc	a0,0x4
    2744:	21850513          	addi	a0,a0,536 # 6958 <malloc+0x952>
    2748:	00004097          	auipc	ra,0x4
    274c:	800080e7          	jalr	-2048(ra) # 5f48 <printf>
    exit(1);
    2750:	4505                	li	a0,1
    2752:	00003097          	auipc	ra,0x3
    2756:	476080e7          	jalr	1142(ra) # 5bc8 <exit>

000000000000275a <rwsbrk>:
{
    275a:	1101                	addi	sp,sp,-32
    275c:	ec06                	sd	ra,24(sp)
    275e:	e822                	sd	s0,16(sp)
    2760:	e426                	sd	s1,8(sp)
    2762:	e04a                	sd	s2,0(sp)
    2764:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2766:	6509                	lui	a0,0x2
    2768:	00003097          	auipc	ra,0x3
    276c:	4e8080e7          	jalr	1256(ra) # 5c50 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2770:	57fd                	li	a5,-1
    2772:	06f50363          	beq	a0,a5,27d8 <rwsbrk+0x7e>
    2776:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2778:	7579                	lui	a0,0xffffe
    277a:	00003097          	auipc	ra,0x3
    277e:	4d6080e7          	jalr	1238(ra) # 5c50 <sbrk>
    2782:	57fd                	li	a5,-1
    2784:	06f50763          	beq	a0,a5,27f2 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2788:	20100593          	li	a1,513
    278c:	00004517          	auipc	a0,0x4
    2790:	6fc50513          	addi	a0,a0,1788 # 6e88 <malloc+0xe82>
    2794:	00003097          	auipc	ra,0x3
    2798:	474080e7          	jalr	1140(ra) # 5c08 <open>
    279c:	892a                	mv	s2,a0
  if(fd < 0){
    279e:	06054763          	bltz	a0,280c <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    27a2:	6505                	lui	a0,0x1
    27a4:	94aa                	add	s1,s1,a0
    27a6:	40000613          	li	a2,1024
    27aa:	85a6                	mv	a1,s1
    27ac:	854a                	mv	a0,s2
    27ae:	00003097          	auipc	ra,0x3
    27b2:	43a080e7          	jalr	1082(ra) # 5be8 <write>
    27b6:	862a                	mv	a2,a0
  if(n >= 0){
    27b8:	06054763          	bltz	a0,2826 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27bc:	85a6                	mv	a1,s1
    27be:	00004517          	auipc	a0,0x4
    27c2:	6ea50513          	addi	a0,a0,1770 # 6ea8 <malloc+0xea2>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	782080e7          	jalr	1922(ra) # 5f48 <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	3f8080e7          	jalr	1016(ra) # 5bc8 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27d8:	00004517          	auipc	a0,0x4
    27dc:	67850513          	addi	a0,a0,1656 # 6e50 <malloc+0xe4a>
    27e0:	00003097          	auipc	ra,0x3
    27e4:	768080e7          	jalr	1896(ra) # 5f48 <printf>
    exit(1);
    27e8:	4505                	li	a0,1
    27ea:	00003097          	auipc	ra,0x3
    27ee:	3de080e7          	jalr	990(ra) # 5bc8 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27f2:	00004517          	auipc	a0,0x4
    27f6:	67650513          	addi	a0,a0,1654 # 6e68 <malloc+0xe62>
    27fa:	00003097          	auipc	ra,0x3
    27fe:	74e080e7          	jalr	1870(ra) # 5f48 <printf>
    exit(1);
    2802:	4505                	li	a0,1
    2804:	00003097          	auipc	ra,0x3
    2808:	3c4080e7          	jalr	964(ra) # 5bc8 <exit>
    printf("open(rwsbrk) failed\n");
    280c:	00004517          	auipc	a0,0x4
    2810:	68450513          	addi	a0,a0,1668 # 6e90 <malloc+0xe8a>
    2814:	00003097          	auipc	ra,0x3
    2818:	734080e7          	jalr	1844(ra) # 5f48 <printf>
    exit(1);
    281c:	4505                	li	a0,1
    281e:	00003097          	auipc	ra,0x3
    2822:	3aa080e7          	jalr	938(ra) # 5bc8 <exit>
  close(fd);
    2826:	854a                	mv	a0,s2
    2828:	00003097          	auipc	ra,0x3
    282c:	3c8080e7          	jalr	968(ra) # 5bf0 <close>
  unlink("rwsbrk");
    2830:	00004517          	auipc	a0,0x4
    2834:	65850513          	addi	a0,a0,1624 # 6e88 <malloc+0xe82>
    2838:	00003097          	auipc	ra,0x3
    283c:	3e0080e7          	jalr	992(ra) # 5c18 <unlink>
  fd = open("README", O_RDONLY);
    2840:	4581                	li	a1,0
    2842:	00004517          	auipc	a0,0x4
    2846:	ade50513          	addi	a0,a0,-1314 # 6320 <malloc+0x31a>
    284a:	00003097          	auipc	ra,0x3
    284e:	3be080e7          	jalr	958(ra) # 5c08 <open>
    2852:	892a                	mv	s2,a0
  if(fd < 0){
    2854:	02054963          	bltz	a0,2886 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    2858:	4629                	li	a2,10
    285a:	85a6                	mv	a1,s1
    285c:	00003097          	auipc	ra,0x3
    2860:	384080e7          	jalr	900(ra) # 5be0 <read>
    2864:	862a                	mv	a2,a0
  if(n >= 0){
    2866:	02054d63          	bltz	a0,28a0 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    286a:	85a6                	mv	a1,s1
    286c:	00004517          	auipc	a0,0x4
    2870:	66c50513          	addi	a0,a0,1644 # 6ed8 <malloc+0xed2>
    2874:	00003097          	auipc	ra,0x3
    2878:	6d4080e7          	jalr	1748(ra) # 5f48 <printf>
    exit(1);
    287c:	4505                	li	a0,1
    287e:	00003097          	auipc	ra,0x3
    2882:	34a080e7          	jalr	842(ra) # 5bc8 <exit>
    printf("open(rwsbrk) failed\n");
    2886:	00004517          	auipc	a0,0x4
    288a:	60a50513          	addi	a0,a0,1546 # 6e90 <malloc+0xe8a>
    288e:	00003097          	auipc	ra,0x3
    2892:	6ba080e7          	jalr	1722(ra) # 5f48 <printf>
    exit(1);
    2896:	4505                	li	a0,1
    2898:	00003097          	auipc	ra,0x3
    289c:	330080e7          	jalr	816(ra) # 5bc8 <exit>
  close(fd);
    28a0:	854a                	mv	a0,s2
    28a2:	00003097          	auipc	ra,0x3
    28a6:	34e080e7          	jalr	846(ra) # 5bf0 <close>
  exit(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	31c080e7          	jalr	796(ra) # 5bc8 <exit>

00000000000028b4 <sbrkbasic>:
{
    28b4:	7139                	addi	sp,sp,-64
    28b6:	fc06                	sd	ra,56(sp)
    28b8:	f822                	sd	s0,48(sp)
    28ba:	f426                	sd	s1,40(sp)
    28bc:	f04a                	sd	s2,32(sp)
    28be:	ec4e                	sd	s3,24(sp)
    28c0:	e852                	sd	s4,16(sp)
    28c2:	0080                	addi	s0,sp,64
    28c4:	8a2a                	mv	s4,a0
  pid = fork();
    28c6:	00003097          	auipc	ra,0x3
    28ca:	2fa080e7          	jalr	762(ra) # 5bc0 <fork>
  if(pid < 0){
    28ce:	02054c63          	bltz	a0,2906 <sbrkbasic+0x52>
  if(pid == 0){
    28d2:	ed21                	bnez	a0,292a <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28d4:	40000537          	lui	a0,0x40000
    28d8:	00003097          	auipc	ra,0x3
    28dc:	378080e7          	jalr	888(ra) # 5c50 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28e0:	57fd                	li	a5,-1
    28e2:	02f50f63          	beq	a0,a5,2920 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28e6:	400007b7          	lui	a5,0x40000
    28ea:	97aa                	add	a5,a5,a0
      *b = 99;
    28ec:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f0:	6705                	lui	a4,0x1
      *b = 99;
    28f2:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f6:	953a                	add	a0,a0,a4
    28f8:	fef51de3          	bne	a0,a5,28f2 <sbrkbasic+0x3e>
    exit(1);
    28fc:	4505                	li	a0,1
    28fe:	00003097          	auipc	ra,0x3
    2902:	2ca080e7          	jalr	714(ra) # 5bc8 <exit>
    printf("fork failed in sbrkbasic\n");
    2906:	00004517          	auipc	a0,0x4
    290a:	5fa50513          	addi	a0,a0,1530 # 6f00 <malloc+0xefa>
    290e:	00003097          	auipc	ra,0x3
    2912:	63a080e7          	jalr	1594(ra) # 5f48 <printf>
    exit(1);
    2916:	4505                	li	a0,1
    2918:	00003097          	auipc	ra,0x3
    291c:	2b0080e7          	jalr	688(ra) # 5bc8 <exit>
      exit(0);
    2920:	4501                	li	a0,0
    2922:	00003097          	auipc	ra,0x3
    2926:	2a6080e7          	jalr	678(ra) # 5bc8 <exit>
  wait(&xstatus);
    292a:	fcc40513          	addi	a0,s0,-52
    292e:	00003097          	auipc	ra,0x3
    2932:	2a2080e7          	jalr	674(ra) # 5bd0 <wait>
  if(xstatus == 1){
    2936:	fcc42703          	lw	a4,-52(s0)
    293a:	4785                	li	a5,1
    293c:	00f70d63          	beq	a4,a5,2956 <sbrkbasic+0xa2>
  a = sbrk(0);
    2940:	4501                	li	a0,0
    2942:	00003097          	auipc	ra,0x3
    2946:	30e080e7          	jalr	782(ra) # 5c50 <sbrk>
    294a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    294c:	4901                	li	s2,0
    294e:	6985                	lui	s3,0x1
    2950:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    2954:	a005                	j	2974 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2956:	85d2                	mv	a1,s4
    2958:	00004517          	auipc	a0,0x4
    295c:	5c850513          	addi	a0,a0,1480 # 6f20 <malloc+0xf1a>
    2960:	00003097          	auipc	ra,0x3
    2964:	5e8080e7          	jalr	1512(ra) # 5f48 <printf>
    exit(1);
    2968:	4505                	li	a0,1
    296a:	00003097          	auipc	ra,0x3
    296e:	25e080e7          	jalr	606(ra) # 5bc8 <exit>
    a = b + 1;
    2972:	84be                	mv	s1,a5
    b = sbrk(1);
    2974:	4505                	li	a0,1
    2976:	00003097          	auipc	ra,0x3
    297a:	2da080e7          	jalr	730(ra) # 5c50 <sbrk>
    if(b != a){
    297e:	04951c63          	bne	a0,s1,29d6 <sbrkbasic+0x122>
    *b = 1;
    2982:	4785                	li	a5,1
    2984:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2988:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    298c:	2905                	addiw	s2,s2,1
    298e:	ff3912e3          	bne	s2,s3,2972 <sbrkbasic+0xbe>
  pid = fork();
    2992:	00003097          	auipc	ra,0x3
    2996:	22e080e7          	jalr	558(ra) # 5bc0 <fork>
    299a:	892a                	mv	s2,a0
  if(pid < 0){
    299c:	04054e63          	bltz	a0,29f8 <sbrkbasic+0x144>
  c = sbrk(1);
    29a0:	4505                	li	a0,1
    29a2:	00003097          	auipc	ra,0x3
    29a6:	2ae080e7          	jalr	686(ra) # 5c50 <sbrk>
  c = sbrk(1);
    29aa:	4505                	li	a0,1
    29ac:	00003097          	auipc	ra,0x3
    29b0:	2a4080e7          	jalr	676(ra) # 5c50 <sbrk>
  if(c != a + 1){
    29b4:	0489                	addi	s1,s1,2
    29b6:	04a48f63          	beq	s1,a0,2a14 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29ba:	85d2                	mv	a1,s4
    29bc:	00004517          	auipc	a0,0x4
    29c0:	5c450513          	addi	a0,a0,1476 # 6f80 <malloc+0xf7a>
    29c4:	00003097          	auipc	ra,0x3
    29c8:	584080e7          	jalr	1412(ra) # 5f48 <printf>
    exit(1);
    29cc:	4505                	li	a0,1
    29ce:	00003097          	auipc	ra,0x3
    29d2:	1fa080e7          	jalr	506(ra) # 5bc8 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29d6:	872a                	mv	a4,a0
    29d8:	86a6                	mv	a3,s1
    29da:	864a                	mv	a2,s2
    29dc:	85d2                	mv	a1,s4
    29de:	00004517          	auipc	a0,0x4
    29e2:	56250513          	addi	a0,a0,1378 # 6f40 <malloc+0xf3a>
    29e6:	00003097          	auipc	ra,0x3
    29ea:	562080e7          	jalr	1378(ra) # 5f48 <printf>
      exit(1);
    29ee:	4505                	li	a0,1
    29f0:	00003097          	auipc	ra,0x3
    29f4:	1d8080e7          	jalr	472(ra) # 5bc8 <exit>
    printf("%s: sbrk test fork failed\n", s);
    29f8:	85d2                	mv	a1,s4
    29fa:	00004517          	auipc	a0,0x4
    29fe:	56650513          	addi	a0,a0,1382 # 6f60 <malloc+0xf5a>
    2a02:	00003097          	auipc	ra,0x3
    2a06:	546080e7          	jalr	1350(ra) # 5f48 <printf>
    exit(1);
    2a0a:	4505                	li	a0,1
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	1bc080e7          	jalr	444(ra) # 5bc8 <exit>
  if(pid == 0)
    2a14:	00091763          	bnez	s2,2a22 <sbrkbasic+0x16e>
    exit(0);
    2a18:	4501                	li	a0,0
    2a1a:	00003097          	auipc	ra,0x3
    2a1e:	1ae080e7          	jalr	430(ra) # 5bc8 <exit>
  wait(&xstatus);
    2a22:	fcc40513          	addi	a0,s0,-52
    2a26:	00003097          	auipc	ra,0x3
    2a2a:	1aa080e7          	jalr	426(ra) # 5bd0 <wait>
  exit(xstatus);
    2a2e:	fcc42503          	lw	a0,-52(s0)
    2a32:	00003097          	auipc	ra,0x3
    2a36:	196080e7          	jalr	406(ra) # 5bc8 <exit>

0000000000002a3a <sbrkmuch>:
{
    2a3a:	7179                	addi	sp,sp,-48
    2a3c:	f406                	sd	ra,40(sp)
    2a3e:	f022                	sd	s0,32(sp)
    2a40:	ec26                	sd	s1,24(sp)
    2a42:	e84a                	sd	s2,16(sp)
    2a44:	e44e                	sd	s3,8(sp)
    2a46:	e052                	sd	s4,0(sp)
    2a48:	1800                	addi	s0,sp,48
    2a4a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a4c:	4501                	li	a0,0
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	202080e7          	jalr	514(ra) # 5c50 <sbrk>
    2a56:	892a                	mv	s2,a0
  a = sbrk(0);
    2a58:	4501                	li	a0,0
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	1f6080e7          	jalr	502(ra) # 5c50 <sbrk>
    2a62:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a64:	06400537          	lui	a0,0x6400
    2a68:	9d05                	subw	a0,a0,s1
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	1e6080e7          	jalr	486(ra) # 5c50 <sbrk>
  if (p != a) {
    2a72:	0ca49863          	bne	s1,a0,2b42 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a76:	4501                	li	a0,0
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	1d8080e7          	jalr	472(ra) # 5c50 <sbrk>
    2a80:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a82:	00a4f963          	bgeu	s1,a0,2a94 <sbrkmuch+0x5a>
    *pp = 1;
    2a86:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a88:	6705                	lui	a4,0x1
    *pp = 1;
    2a8a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a8e:	94ba                	add	s1,s1,a4
    2a90:	fef4ede3          	bltu	s1,a5,2a8a <sbrkmuch+0x50>
  *lastaddr = 99;
    2a94:	064007b7          	lui	a5,0x6400
    2a98:	06300713          	li	a4,99
    2a9c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aa0:	4501                	li	a0,0
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	1ae080e7          	jalr	430(ra) # 5c50 <sbrk>
    2aaa:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2aac:	757d                	lui	a0,0xfffff
    2aae:	00003097          	auipc	ra,0x3
    2ab2:	1a2080e7          	jalr	418(ra) # 5c50 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ab6:	57fd                	li	a5,-1
    2ab8:	0af50363          	beq	a0,a5,2b5e <sbrkmuch+0x124>
  c = sbrk(0);
    2abc:	4501                	li	a0,0
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	192080e7          	jalr	402(ra) # 5c50 <sbrk>
  if(c != a - PGSIZE){
    2ac6:	77fd                	lui	a5,0xfffff
    2ac8:	97a6                	add	a5,a5,s1
    2aca:	0af51863          	bne	a0,a5,2b7a <sbrkmuch+0x140>
  a = sbrk(0);
    2ace:	4501                	li	a0,0
    2ad0:	00003097          	auipc	ra,0x3
    2ad4:	180080e7          	jalr	384(ra) # 5c50 <sbrk>
    2ad8:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2ada:	6505                	lui	a0,0x1
    2adc:	00003097          	auipc	ra,0x3
    2ae0:	174080e7          	jalr	372(ra) # 5c50 <sbrk>
    2ae4:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ae6:	0aa49a63          	bne	s1,a0,2b9a <sbrkmuch+0x160>
    2aea:	4501                	li	a0,0
    2aec:	00003097          	auipc	ra,0x3
    2af0:	164080e7          	jalr	356(ra) # 5c50 <sbrk>
    2af4:	6785                	lui	a5,0x1
    2af6:	97a6                	add	a5,a5,s1
    2af8:	0af51163          	bne	a0,a5,2b9a <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2afc:	064007b7          	lui	a5,0x6400
    2b00:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b04:	06300793          	li	a5,99
    2b08:	0af70963          	beq	a4,a5,2bba <sbrkmuch+0x180>
  a = sbrk(0);
    2b0c:	4501                	li	a0,0
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	142080e7          	jalr	322(ra) # 5c50 <sbrk>
    2b16:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b18:	4501                	li	a0,0
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	136080e7          	jalr	310(ra) # 5c50 <sbrk>
    2b22:	40a9053b          	subw	a0,s2,a0
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	12a080e7          	jalr	298(ra) # 5c50 <sbrk>
  if(c != a){
    2b2e:	0aa49463          	bne	s1,a0,2bd6 <sbrkmuch+0x19c>
}
    2b32:	70a2                	ld	ra,40(sp)
    2b34:	7402                	ld	s0,32(sp)
    2b36:	64e2                	ld	s1,24(sp)
    2b38:	6942                	ld	s2,16(sp)
    2b3a:	69a2                	ld	s3,8(sp)
    2b3c:	6a02                	ld	s4,0(sp)
    2b3e:	6145                	addi	sp,sp,48
    2b40:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b42:	85ce                	mv	a1,s3
    2b44:	00004517          	auipc	a0,0x4
    2b48:	45c50513          	addi	a0,a0,1116 # 6fa0 <malloc+0xf9a>
    2b4c:	00003097          	auipc	ra,0x3
    2b50:	3fc080e7          	jalr	1020(ra) # 5f48 <printf>
    exit(1);
    2b54:	4505                	li	a0,1
    2b56:	00003097          	auipc	ra,0x3
    2b5a:	072080e7          	jalr	114(ra) # 5bc8 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b5e:	85ce                	mv	a1,s3
    2b60:	00004517          	auipc	a0,0x4
    2b64:	48850513          	addi	a0,a0,1160 # 6fe8 <malloc+0xfe2>
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	3e0080e7          	jalr	992(ra) # 5f48 <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	00003097          	auipc	ra,0x3
    2b76:	056080e7          	jalr	86(ra) # 5bc8 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b7a:	86aa                	mv	a3,a0
    2b7c:	8626                	mv	a2,s1
    2b7e:	85ce                	mv	a1,s3
    2b80:	00004517          	auipc	a0,0x4
    2b84:	48850513          	addi	a0,a0,1160 # 7008 <malloc+0x1002>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	3c0080e7          	jalr	960(ra) # 5f48 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00003097          	auipc	ra,0x3
    2b96:	036080e7          	jalr	54(ra) # 5bc8 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b9a:	86d2                	mv	a3,s4
    2b9c:	8626                	mv	a2,s1
    2b9e:	85ce                	mv	a1,s3
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	4a850513          	addi	a0,a0,1192 # 7048 <malloc+0x1042>
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	3a0080e7          	jalr	928(ra) # 5f48 <printf>
    exit(1);
    2bb0:	4505                	li	a0,1
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	016080e7          	jalr	22(ra) # 5bc8 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bba:	85ce                	mv	a1,s3
    2bbc:	00004517          	auipc	a0,0x4
    2bc0:	4bc50513          	addi	a0,a0,1212 # 7078 <malloc+0x1072>
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	384080e7          	jalr	900(ra) # 5f48 <printf>
    exit(1);
    2bcc:	4505                	li	a0,1
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	ffa080e7          	jalr	-6(ra) # 5bc8 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bd6:	86aa                	mv	a3,a0
    2bd8:	8626                	mv	a2,s1
    2bda:	85ce                	mv	a1,s3
    2bdc:	00004517          	auipc	a0,0x4
    2be0:	4d450513          	addi	a0,a0,1236 # 70b0 <malloc+0x10aa>
    2be4:	00003097          	auipc	ra,0x3
    2be8:	364080e7          	jalr	868(ra) # 5f48 <printf>
    exit(1);
    2bec:	4505                	li	a0,1
    2bee:	00003097          	auipc	ra,0x3
    2bf2:	fda080e7          	jalr	-38(ra) # 5bc8 <exit>

0000000000002bf6 <sbrkarg>:
{
    2bf6:	7179                	addi	sp,sp,-48
    2bf8:	f406                	sd	ra,40(sp)
    2bfa:	f022                	sd	s0,32(sp)
    2bfc:	ec26                	sd	s1,24(sp)
    2bfe:	e84a                	sd	s2,16(sp)
    2c00:	e44e                	sd	s3,8(sp)
    2c02:	1800                	addi	s0,sp,48
    2c04:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c06:	6505                	lui	a0,0x1
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	048080e7          	jalr	72(ra) # 5c50 <sbrk>
    2c10:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c12:	20100593          	li	a1,513
    2c16:	00004517          	auipc	a0,0x4
    2c1a:	4c250513          	addi	a0,a0,1218 # 70d8 <malloc+0x10d2>
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	fea080e7          	jalr	-22(ra) # 5c08 <open>
    2c26:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c28:	00004517          	auipc	a0,0x4
    2c2c:	4b050513          	addi	a0,a0,1200 # 70d8 <malloc+0x10d2>
    2c30:	00003097          	auipc	ra,0x3
    2c34:	fe8080e7          	jalr	-24(ra) # 5c18 <unlink>
  if(fd < 0)  {
    2c38:	0404c163          	bltz	s1,2c7a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c3c:	6605                	lui	a2,0x1
    2c3e:	85ca                	mv	a1,s2
    2c40:	8526                	mv	a0,s1
    2c42:	00003097          	auipc	ra,0x3
    2c46:	fa6080e7          	jalr	-90(ra) # 5be8 <write>
    2c4a:	04054663          	bltz	a0,2c96 <sbrkarg+0xa0>
  close(fd);
    2c4e:	8526                	mv	a0,s1
    2c50:	00003097          	auipc	ra,0x3
    2c54:	fa0080e7          	jalr	-96(ra) # 5bf0 <close>
  a = sbrk(PGSIZE);
    2c58:	6505                	lui	a0,0x1
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	ff6080e7          	jalr	-10(ra) # 5c50 <sbrk>
  if(pipe((int *) a) != 0){
    2c62:	00003097          	auipc	ra,0x3
    2c66:	f76080e7          	jalr	-138(ra) # 5bd8 <pipe>
    2c6a:	e521                	bnez	a0,2cb2 <sbrkarg+0xbc>
}
    2c6c:	70a2                	ld	ra,40(sp)
    2c6e:	7402                	ld	s0,32(sp)
    2c70:	64e2                	ld	s1,24(sp)
    2c72:	6942                	ld	s2,16(sp)
    2c74:	69a2                	ld	s3,8(sp)
    2c76:	6145                	addi	sp,sp,48
    2c78:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c7a:	85ce                	mv	a1,s3
    2c7c:	00004517          	auipc	a0,0x4
    2c80:	46450513          	addi	a0,a0,1124 # 70e0 <malloc+0x10da>
    2c84:	00003097          	auipc	ra,0x3
    2c88:	2c4080e7          	jalr	708(ra) # 5f48 <printf>
    exit(1);
    2c8c:	4505                	li	a0,1
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	f3a080e7          	jalr	-198(ra) # 5bc8 <exit>
    printf("%s: write sbrk failed\n", s);
    2c96:	85ce                	mv	a1,s3
    2c98:	00004517          	auipc	a0,0x4
    2c9c:	46050513          	addi	a0,a0,1120 # 70f8 <malloc+0x10f2>
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	2a8080e7          	jalr	680(ra) # 5f48 <printf>
    exit(1);
    2ca8:	4505                	li	a0,1
    2caa:	00003097          	auipc	ra,0x3
    2cae:	f1e080e7          	jalr	-226(ra) # 5bc8 <exit>
    printf("%s: pipe() failed\n", s);
    2cb2:	85ce                	mv	a1,s3
    2cb4:	00004517          	auipc	a0,0x4
    2cb8:	e2450513          	addi	a0,a0,-476 # 6ad8 <malloc+0xad2>
    2cbc:	00003097          	auipc	ra,0x3
    2cc0:	28c080e7          	jalr	652(ra) # 5f48 <printf>
    exit(1);
    2cc4:	4505                	li	a0,1
    2cc6:	00003097          	auipc	ra,0x3
    2cca:	f02080e7          	jalr	-254(ra) # 5bc8 <exit>

0000000000002cce <argptest>:
{
    2cce:	1101                	addi	sp,sp,-32
    2cd0:	ec06                	sd	ra,24(sp)
    2cd2:	e822                	sd	s0,16(sp)
    2cd4:	e426                	sd	s1,8(sp)
    2cd6:	e04a                	sd	s2,0(sp)
    2cd8:	1000                	addi	s0,sp,32
    2cda:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cdc:	4581                	li	a1,0
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	43250513          	addi	a0,a0,1074 # 7110 <malloc+0x110a>
    2ce6:	00003097          	auipc	ra,0x3
    2cea:	f22080e7          	jalr	-222(ra) # 5c08 <open>
  if (fd < 0) {
    2cee:	02054b63          	bltz	a0,2d24 <argptest+0x56>
    2cf2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf4:	4501                	li	a0,0
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	f5a080e7          	jalr	-166(ra) # 5c50 <sbrk>
    2cfe:	567d                	li	a2,-1
    2d00:	fff50593          	addi	a1,a0,-1
    2d04:	8526                	mv	a0,s1
    2d06:	00003097          	auipc	ra,0x3
    2d0a:	eda080e7          	jalr	-294(ra) # 5be0 <read>
  close(fd);
    2d0e:	8526                	mv	a0,s1
    2d10:	00003097          	auipc	ra,0x3
    2d14:	ee0080e7          	jalr	-288(ra) # 5bf0 <close>
}
    2d18:	60e2                	ld	ra,24(sp)
    2d1a:	6442                	ld	s0,16(sp)
    2d1c:	64a2                	ld	s1,8(sp)
    2d1e:	6902                	ld	s2,0(sp)
    2d20:	6105                	addi	sp,sp,32
    2d22:	8082                	ret
    printf("%s: open failed\n", s);
    2d24:	85ca                	mv	a1,s2
    2d26:	00004517          	auipc	a0,0x4
    2d2a:	cc250513          	addi	a0,a0,-830 # 69e8 <malloc+0x9e2>
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	21a080e7          	jalr	538(ra) # 5f48 <printf>
    exit(1);
    2d36:	4505                	li	a0,1
    2d38:	00003097          	auipc	ra,0x3
    2d3c:	e90080e7          	jalr	-368(ra) # 5bc8 <exit>

0000000000002d40 <sbrkbugs>:
{
    2d40:	1141                	addi	sp,sp,-16
    2d42:	e406                	sd	ra,8(sp)
    2d44:	e022                	sd	s0,0(sp)
    2d46:	0800                	addi	s0,sp,16
  int pid = fork();
    2d48:	00003097          	auipc	ra,0x3
    2d4c:	e78080e7          	jalr	-392(ra) # 5bc0 <fork>
  if(pid < 0){
    2d50:	02054263          	bltz	a0,2d74 <sbrkbugs+0x34>
  if(pid == 0){
    2d54:	ed0d                	bnez	a0,2d8e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	efa080e7          	jalr	-262(ra) # 5c50 <sbrk>
    sbrk(-sz);
    2d5e:	40a0053b          	negw	a0,a0
    2d62:	00003097          	auipc	ra,0x3
    2d66:	eee080e7          	jalr	-274(ra) # 5c50 <sbrk>
    exit(0);
    2d6a:	4501                	li	a0,0
    2d6c:	00003097          	auipc	ra,0x3
    2d70:	e5c080e7          	jalr	-420(ra) # 5bc8 <exit>
    printf("fork failed\n");
    2d74:	00004517          	auipc	a0,0x4
    2d78:	06450513          	addi	a0,a0,100 # 6dd8 <malloc+0xdd2>
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	1cc080e7          	jalr	460(ra) # 5f48 <printf>
    exit(1);
    2d84:	4505                	li	a0,1
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	e42080e7          	jalr	-446(ra) # 5bc8 <exit>
  wait(0);
    2d8e:	4501                	li	a0,0
    2d90:	00003097          	auipc	ra,0x3
    2d94:	e40080e7          	jalr	-448(ra) # 5bd0 <wait>
  pid = fork();
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e28080e7          	jalr	-472(ra) # 5bc0 <fork>
  if(pid < 0){
    2da0:	02054563          	bltz	a0,2dca <sbrkbugs+0x8a>
  if(pid == 0){
    2da4:	e121                	bnez	a0,2de4 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2da6:	00003097          	auipc	ra,0x3
    2daa:	eaa080e7          	jalr	-342(ra) # 5c50 <sbrk>
    sbrk(-(sz - 3500));
    2dae:	6785                	lui	a5,0x1
    2db0:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6c>
    2db4:	40a7853b          	subw	a0,a5,a0
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	e98080e7          	jalr	-360(ra) # 5c50 <sbrk>
    exit(0);
    2dc0:	4501                	li	a0,0
    2dc2:	00003097          	auipc	ra,0x3
    2dc6:	e06080e7          	jalr	-506(ra) # 5bc8 <exit>
    printf("fork failed\n");
    2dca:	00004517          	auipc	a0,0x4
    2dce:	00e50513          	addi	a0,a0,14 # 6dd8 <malloc+0xdd2>
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	176080e7          	jalr	374(ra) # 5f48 <printf>
    exit(1);
    2dda:	4505                	li	a0,1
    2ddc:	00003097          	auipc	ra,0x3
    2de0:	dec080e7          	jalr	-532(ra) # 5bc8 <exit>
  wait(0);
    2de4:	4501                	li	a0,0
    2de6:	00003097          	auipc	ra,0x3
    2dea:	dea080e7          	jalr	-534(ra) # 5bd0 <wait>
  pid = fork();
    2dee:	00003097          	auipc	ra,0x3
    2df2:	dd2080e7          	jalr	-558(ra) # 5bc0 <fork>
  if(pid < 0){
    2df6:	02054a63          	bltz	a0,2e2a <sbrkbugs+0xea>
  if(pid == 0){
    2dfa:	e529                	bnez	a0,2e44 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2dfc:	00003097          	auipc	ra,0x3
    2e00:	e54080e7          	jalr	-428(ra) # 5c50 <sbrk>
    2e04:	67ad                	lui	a5,0xb
    2e06:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2e0a:	40a7853b          	subw	a0,a5,a0
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	e42080e7          	jalr	-446(ra) # 5c50 <sbrk>
    sbrk(-10);
    2e16:	5559                	li	a0,-10
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	e38080e7          	jalr	-456(ra) # 5c50 <sbrk>
    exit(0);
    2e20:	4501                	li	a0,0
    2e22:	00003097          	auipc	ra,0x3
    2e26:	da6080e7          	jalr	-602(ra) # 5bc8 <exit>
    printf("fork failed\n");
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	fae50513          	addi	a0,a0,-82 # 6dd8 <malloc+0xdd2>
    2e32:	00003097          	auipc	ra,0x3
    2e36:	116080e7          	jalr	278(ra) # 5f48 <printf>
    exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	d8c080e7          	jalr	-628(ra) # 5bc8 <exit>
  wait(0);
    2e44:	4501                	li	a0,0
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	d8a080e7          	jalr	-630(ra) # 5bd0 <wait>
  exit(0);
    2e4e:	4501                	li	a0,0
    2e50:	00003097          	auipc	ra,0x3
    2e54:	d78080e7          	jalr	-648(ra) # 5bc8 <exit>

0000000000002e58 <sbrklast>:
{
    2e58:	7179                	addi	sp,sp,-48
    2e5a:	f406                	sd	ra,40(sp)
    2e5c:	f022                	sd	s0,32(sp)
    2e5e:	ec26                	sd	s1,24(sp)
    2e60:	e84a                	sd	s2,16(sp)
    2e62:	e44e                	sd	s3,8(sp)
    2e64:	e052                	sd	s4,0(sp)
    2e66:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e68:	4501                	li	a0,0
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	de6080e7          	jalr	-538(ra) # 5c50 <sbrk>
  if((top % 4096) != 0)
    2e72:	03451793          	slli	a5,a0,0x34
    2e76:	ebd9                	bnez	a5,2f0c <sbrklast+0xb4>
  sbrk(4096);
    2e78:	6505                	lui	a0,0x1
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	dd6080e7          	jalr	-554(ra) # 5c50 <sbrk>
  sbrk(10);
    2e82:	4529                	li	a0,10
    2e84:	00003097          	auipc	ra,0x3
    2e88:	dcc080e7          	jalr	-564(ra) # 5c50 <sbrk>
  sbrk(-20);
    2e8c:	5531                	li	a0,-20
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	dc2080e7          	jalr	-574(ra) # 5c50 <sbrk>
  top = (uint64) sbrk(0);
    2e96:	4501                	li	a0,0
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	db8080e7          	jalr	-584(ra) # 5c50 <sbrk>
    2ea0:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ea2:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ea6:	07800a13          	li	s4,120
    2eaa:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2eae:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eb2:	20200593          	li	a1,514
    2eb6:	854a                	mv	a0,s2
    2eb8:	00003097          	auipc	ra,0x3
    2ebc:	d50080e7          	jalr	-688(ra) # 5c08 <open>
    2ec0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ec2:	4605                	li	a2,1
    2ec4:	85ca                	mv	a1,s2
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	d22080e7          	jalr	-734(ra) # 5be8 <write>
  close(fd);
    2ece:	854e                	mv	a0,s3
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	d20080e7          	jalr	-736(ra) # 5bf0 <close>
  fd = open(p, O_RDWR);
    2ed8:	4589                	li	a1,2
    2eda:	854a                	mv	a0,s2
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	d2c080e7          	jalr	-724(ra) # 5c08 <open>
  p[0] = '\0';
    2ee4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ee8:	4605                	li	a2,1
    2eea:	85ca                	mv	a1,s2
    2eec:	00003097          	auipc	ra,0x3
    2ef0:	cf4080e7          	jalr	-780(ra) # 5be0 <read>
  if(p[0] != 'x')
    2ef4:	fc04c783          	lbu	a5,-64(s1)
    2ef8:	03479463          	bne	a5,s4,2f20 <sbrklast+0xc8>
}
    2efc:	70a2                	ld	ra,40(sp)
    2efe:	7402                	ld	s0,32(sp)
    2f00:	64e2                	ld	s1,24(sp)
    2f02:	6942                	ld	s2,16(sp)
    2f04:	69a2                	ld	s3,8(sp)
    2f06:	6a02                	ld	s4,0(sp)
    2f08:	6145                	addi	sp,sp,48
    2f0a:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f0c:	0347d513          	srli	a0,a5,0x34
    2f10:	6785                	lui	a5,0x1
    2f12:	40a7853b          	subw	a0,a5,a0
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	d3a080e7          	jalr	-710(ra) # 5c50 <sbrk>
    2f1e:	bfa9                	j	2e78 <sbrklast+0x20>
    exit(1);
    2f20:	4505                	li	a0,1
    2f22:	00003097          	auipc	ra,0x3
    2f26:	ca6080e7          	jalr	-858(ra) # 5bc8 <exit>

0000000000002f2a <sbrk8000>:
{
    2f2a:	1141                	addi	sp,sp,-16
    2f2c:	e406                	sd	ra,8(sp)
    2f2e:	e022                	sd	s0,0(sp)
    2f30:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f32:	80000537          	lui	a0,0x80000
    2f36:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f38:	00003097          	auipc	ra,0x3
    2f3c:	d18080e7          	jalr	-744(ra) # 5c50 <sbrk>
  volatile char *top = sbrk(0);
    2f40:	4501                	li	a0,0
    2f42:	00003097          	auipc	ra,0x3
    2f46:	d0e080e7          	jalr	-754(ra) # 5c50 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f4a:	fff54783          	lbu	a5,-1(a0)
    2f4e:	0785                	addi	a5,a5,1 # 1001 <linktest+0x10b>
    2f50:	0ff7f793          	zext.b	a5,a5
    2f54:	fef50fa3          	sb	a5,-1(a0)
}
    2f58:	60a2                	ld	ra,8(sp)
    2f5a:	6402                	ld	s0,0(sp)
    2f5c:	0141                	addi	sp,sp,16
    2f5e:	8082                	ret

0000000000002f60 <execout>:
void execout(char *s) {
    2f60:	7139                	addi	sp,sp,-64
    2f62:	fc06                	sd	ra,56(sp)
    2f64:	f822                	sd	s0,48(sp)
    2f66:	f426                	sd	s1,40(sp)
    2f68:	0080                	addi	s0,sp,64
    2f6a:	44bd                	li	s1,15
        int pid = fork();
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	c54080e7          	jalr	-940(ra) # 5bc0 <fork>
        if (pid < 0) {
    2f74:	00054f63          	bltz	a0,2f92 <execout+0x32>
        } else if (pid == 0) {
    2f78:	c915                	beqz	a0,2fac <execout+0x4c>
            wait((int *)0);
    2f7a:	4501                	li	a0,0
    2f7c:	00003097          	auipc	ra,0x3
    2f80:	c54080e7          	jalr	-940(ra) # 5bd0 <wait>
    for (int avail = 0; avail < 15; avail++) {
    2f84:	34fd                	addiw	s1,s1,-1
    2f86:	f0fd                	bnez	s1,2f6c <execout+0xc>
    exit(0);
    2f88:	4501                	li	a0,0
    2f8a:	00003097          	auipc	ra,0x3
    2f8e:	c3e080e7          	jalr	-962(ra) # 5bc8 <exit>
            printf("fork failed\n");
    2f92:	00004517          	auipc	a0,0x4
    2f96:	e4650513          	addi	a0,a0,-442 # 6dd8 <malloc+0xdd2>
    2f9a:	00003097          	auipc	ra,0x3
    2f9e:	fae080e7          	jalr	-82(ra) # 5f48 <printf>
            exit(1);
    2fa2:	4505                	li	a0,1
    2fa4:	00003097          	auipc	ra,0x3
    2fa8:	c24080e7          	jalr	-988(ra) # 5bc8 <exit>
            uint64 a = (uint64)sbrk(4096);
    2fac:	6505                	lui	a0,0x1
    2fae:	00003097          	auipc	ra,0x3
    2fb2:	ca2080e7          	jalr	-862(ra) # 5c50 <sbrk>
            if (a == 0xffffffffffffffffLL) {
    2fb6:	57fd                	li	a5,-1
    2fb8:	04f50a63          	beq	a0,a5,300c <execout+0xac>
            *(char *)(a + 4096 - 1) = 1;
    2fbc:	6785                	lui	a5,0x1
    2fbe:	953e                	add	a0,a0,a5
    2fc0:	4785                	li	a5,1
    2fc2:	fef50fa3          	sb	a5,-1(a0) # fff <linktest+0x109>
            sbrk(-4096);
    2fc6:	757d                	lui	a0,0xfffff
    2fc8:	00003097          	auipc	ra,0x3
    2fcc:	c88080e7          	jalr	-888(ra) # 5c50 <sbrk>
            close(1);
    2fd0:	4505                	li	a0,1
    2fd2:	00003097          	auipc	ra,0x3
    2fd6:	c1e080e7          	jalr	-994(ra) # 5bf0 <close>
            char *args[] = { "echo", "x", 0 };
    2fda:	00003517          	auipc	a0,0x3
    2fde:	16e50513          	addi	a0,a0,366 # 6148 <malloc+0x142>
    2fe2:	fca43423          	sd	a0,-56(s0)
    2fe6:	00003797          	auipc	a5,0x3
    2fea:	1d278793          	addi	a5,a5,466 # 61b8 <malloc+0x1b2>
    2fee:	fcf43823          	sd	a5,-48(s0)
    2ff2:	fc043c23          	sd	zero,-40(s0)
            exec("echo", args);
    2ff6:	fc840593          	addi	a1,s0,-56
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	c06080e7          	jalr	-1018(ra) # 5c00 <exec>
            exit(0);
    3002:	4501                	li	a0,0
    3004:	00003097          	auipc	ra,0x3
    3008:	bc4080e7          	jalr	-1084(ra) # 5bc8 <exit>
                printf("sbrk failed\n");
    300c:	00004517          	auipc	a0,0x4
    3010:	10c50513          	addi	a0,a0,268 # 7118 <malloc+0x1112>
    3014:	00003097          	auipc	ra,0x3
    3018:	f34080e7          	jalr	-204(ra) # 5f48 <printf>
                exit(1);
    301c:	4505                	li	a0,1
    301e:	00003097          	auipc	ra,0x3
    3022:	baa080e7          	jalr	-1110(ra) # 5bc8 <exit>

0000000000003026 <fourteen>:
{
    3026:	1101                	addi	sp,sp,-32
    3028:	ec06                	sd	ra,24(sp)
    302a:	e822                	sd	s0,16(sp)
    302c:	e426                	sd	s1,8(sp)
    302e:	1000                	addi	s0,sp,32
    3030:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3032:	00004517          	auipc	a0,0x4
    3036:	2c650513          	addi	a0,a0,710 # 72f8 <malloc+0x12f2>
    303a:	00003097          	auipc	ra,0x3
    303e:	bf6080e7          	jalr	-1034(ra) # 5c30 <mkdir>
    3042:	e165                	bnez	a0,3122 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3044:	00004517          	auipc	a0,0x4
    3048:	10c50513          	addi	a0,a0,268 # 7150 <malloc+0x114a>
    304c:	00003097          	auipc	ra,0x3
    3050:	be4080e7          	jalr	-1052(ra) # 5c30 <mkdir>
    3054:	e56d                	bnez	a0,313e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3056:	20000593          	li	a1,512
    305a:	00004517          	auipc	a0,0x4
    305e:	14e50513          	addi	a0,a0,334 # 71a8 <malloc+0x11a2>
    3062:	00003097          	auipc	ra,0x3
    3066:	ba6080e7          	jalr	-1114(ra) # 5c08 <open>
  if(fd < 0){
    306a:	0e054863          	bltz	a0,315a <fourteen+0x134>
  close(fd);
    306e:	00003097          	auipc	ra,0x3
    3072:	b82080e7          	jalr	-1150(ra) # 5bf0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3076:	4581                	li	a1,0
    3078:	00004517          	auipc	a0,0x4
    307c:	1a850513          	addi	a0,a0,424 # 7220 <malloc+0x121a>
    3080:	00003097          	auipc	ra,0x3
    3084:	b88080e7          	jalr	-1144(ra) # 5c08 <open>
  if(fd < 0){
    3088:	0e054763          	bltz	a0,3176 <fourteen+0x150>
  close(fd);
    308c:	00003097          	auipc	ra,0x3
    3090:	b64080e7          	jalr	-1180(ra) # 5bf0 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3094:	00004517          	auipc	a0,0x4
    3098:	1fc50513          	addi	a0,a0,508 # 7290 <malloc+0x128a>
    309c:	00003097          	auipc	ra,0x3
    30a0:	b94080e7          	jalr	-1132(ra) # 5c30 <mkdir>
    30a4:	c57d                	beqz	a0,3192 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30a6:	00004517          	auipc	a0,0x4
    30aa:	24250513          	addi	a0,a0,578 # 72e8 <malloc+0x12e2>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	b82080e7          	jalr	-1150(ra) # 5c30 <mkdir>
    30b6:	cd65                	beqz	a0,31ae <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30b8:	00004517          	auipc	a0,0x4
    30bc:	23050513          	addi	a0,a0,560 # 72e8 <malloc+0x12e2>
    30c0:	00003097          	auipc	ra,0x3
    30c4:	b58080e7          	jalr	-1192(ra) # 5c18 <unlink>
  unlink("12345678901234/12345678901234");
    30c8:	00004517          	auipc	a0,0x4
    30cc:	1c850513          	addi	a0,a0,456 # 7290 <malloc+0x128a>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b48080e7          	jalr	-1208(ra) # 5c18 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30d8:	00004517          	auipc	a0,0x4
    30dc:	14850513          	addi	a0,a0,328 # 7220 <malloc+0x121a>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	b38080e7          	jalr	-1224(ra) # 5c18 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30e8:	00004517          	auipc	a0,0x4
    30ec:	0c050513          	addi	a0,a0,192 # 71a8 <malloc+0x11a2>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	b28080e7          	jalr	-1240(ra) # 5c18 <unlink>
  unlink("12345678901234/123456789012345");
    30f8:	00004517          	auipc	a0,0x4
    30fc:	05850513          	addi	a0,a0,88 # 7150 <malloc+0x114a>
    3100:	00003097          	auipc	ra,0x3
    3104:	b18080e7          	jalr	-1256(ra) # 5c18 <unlink>
  unlink("12345678901234");
    3108:	00004517          	auipc	a0,0x4
    310c:	1f050513          	addi	a0,a0,496 # 72f8 <malloc+0x12f2>
    3110:	00003097          	auipc	ra,0x3
    3114:	b08080e7          	jalr	-1272(ra) # 5c18 <unlink>
}
    3118:	60e2                	ld	ra,24(sp)
    311a:	6442                	ld	s0,16(sp)
    311c:	64a2                	ld	s1,8(sp)
    311e:	6105                	addi	sp,sp,32
    3120:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3122:	85a6                	mv	a1,s1
    3124:	00004517          	auipc	a0,0x4
    3128:	00450513          	addi	a0,a0,4 # 7128 <malloc+0x1122>
    312c:	00003097          	auipc	ra,0x3
    3130:	e1c080e7          	jalr	-484(ra) # 5f48 <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	00003097          	auipc	ra,0x3
    313a:	a92080e7          	jalr	-1390(ra) # 5bc8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    313e:	85a6                	mv	a1,s1
    3140:	00004517          	auipc	a0,0x4
    3144:	03050513          	addi	a0,a0,48 # 7170 <malloc+0x116a>
    3148:	00003097          	auipc	ra,0x3
    314c:	e00080e7          	jalr	-512(ra) # 5f48 <printf>
    exit(1);
    3150:	4505                	li	a0,1
    3152:	00003097          	auipc	ra,0x3
    3156:	a76080e7          	jalr	-1418(ra) # 5bc8 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    315a:	85a6                	mv	a1,s1
    315c:	00004517          	auipc	a0,0x4
    3160:	07c50513          	addi	a0,a0,124 # 71d8 <malloc+0x11d2>
    3164:	00003097          	auipc	ra,0x3
    3168:	de4080e7          	jalr	-540(ra) # 5f48 <printf>
    exit(1);
    316c:	4505                	li	a0,1
    316e:	00003097          	auipc	ra,0x3
    3172:	a5a080e7          	jalr	-1446(ra) # 5bc8 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3176:	85a6                	mv	a1,s1
    3178:	00004517          	auipc	a0,0x4
    317c:	0d850513          	addi	a0,a0,216 # 7250 <malloc+0x124a>
    3180:	00003097          	auipc	ra,0x3
    3184:	dc8080e7          	jalr	-568(ra) # 5f48 <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	00003097          	auipc	ra,0x3
    318e:	a3e080e7          	jalr	-1474(ra) # 5bc8 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3192:	85a6                	mv	a1,s1
    3194:	00004517          	auipc	a0,0x4
    3198:	11c50513          	addi	a0,a0,284 # 72b0 <malloc+0x12aa>
    319c:	00003097          	auipc	ra,0x3
    31a0:	dac080e7          	jalr	-596(ra) # 5f48 <printf>
    exit(1);
    31a4:	4505                	li	a0,1
    31a6:	00003097          	auipc	ra,0x3
    31aa:	a22080e7          	jalr	-1502(ra) # 5bc8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31ae:	85a6                	mv	a1,s1
    31b0:	00004517          	auipc	a0,0x4
    31b4:	15850513          	addi	a0,a0,344 # 7308 <malloc+0x1302>
    31b8:	00003097          	auipc	ra,0x3
    31bc:	d90080e7          	jalr	-624(ra) # 5f48 <printf>
    exit(1);
    31c0:	4505                	li	a0,1
    31c2:	00003097          	auipc	ra,0x3
    31c6:	a06080e7          	jalr	-1530(ra) # 5bc8 <exit>

00000000000031ca <diskfull>:
{
    31ca:	b9010113          	addi	sp,sp,-1136
    31ce:	46113423          	sd	ra,1128(sp)
    31d2:	46813023          	sd	s0,1120(sp)
    31d6:	44913c23          	sd	s1,1112(sp)
    31da:	45213823          	sd	s2,1104(sp)
    31de:	45313423          	sd	s3,1096(sp)
    31e2:	45413023          	sd	s4,1088(sp)
    31e6:	43513c23          	sd	s5,1080(sp)
    31ea:	43613823          	sd	s6,1072(sp)
    31ee:	43713423          	sd	s7,1064(sp)
    31f2:	43813023          	sd	s8,1056(sp)
    31f6:	47010413          	addi	s0,sp,1136
    31fa:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31fc:	00004517          	auipc	a0,0x4
    3200:	14450513          	addi	a0,a0,324 # 7340 <malloc+0x133a>
    3204:	00003097          	auipc	ra,0x3
    3208:	a14080e7          	jalr	-1516(ra) # 5c18 <unlink>
  for(fi = 0; done == 0; fi++){
    320c:	4a01                	li	s4,0
    name[0] = 'b';
    320e:	06200b13          	li	s6,98
    name[1] = 'i';
    3212:	06900a93          	li	s5,105
    name[2] = 'g';
    3216:	06700993          	li	s3,103
    321a:	10c00b93          	li	s7,268
    321e:	aabd                	j	339c <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3220:	b9040613          	addi	a2,s0,-1136
    3224:	85e2                	mv	a1,s8
    3226:	00004517          	auipc	a0,0x4
    322a:	12a50513          	addi	a0,a0,298 # 7350 <malloc+0x134a>
    322e:	00003097          	auipc	ra,0x3
    3232:	d1a080e7          	jalr	-742(ra) # 5f48 <printf>
      break;
    3236:	a821                	j	324e <diskfull+0x84>
        close(fd);
    3238:	854a                	mv	a0,s2
    323a:	00003097          	auipc	ra,0x3
    323e:	9b6080e7          	jalr	-1610(ra) # 5bf0 <close>
    close(fd);
    3242:	854a                	mv	a0,s2
    3244:	00003097          	auipc	ra,0x3
    3248:	9ac080e7          	jalr	-1620(ra) # 5bf0 <close>
  for(fi = 0; done == 0; fi++){
    324c:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    324e:	4481                	li	s1,0
    name[0] = 'z';
    3250:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3254:	08000993          	li	s3,128
    name[0] = 'z';
    3258:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    325c:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3260:	41f4d79b          	sraiw	a5,s1,0x1f
    3264:	01b7d71b          	srliw	a4,a5,0x1b
    3268:	009707bb          	addw	a5,a4,s1
    326c:	4057d69b          	sraiw	a3,a5,0x5
    3270:	0306869b          	addiw	a3,a3,48
    3274:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3278:	8bfd                	andi	a5,a5,31
    327a:	9f99                	subw	a5,a5,a4
    327c:	0307879b          	addiw	a5,a5,48
    3280:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3284:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3288:	bb040513          	addi	a0,s0,-1104
    328c:	00003097          	auipc	ra,0x3
    3290:	98c080e7          	jalr	-1652(ra) # 5c18 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3294:	60200593          	li	a1,1538
    3298:	bb040513          	addi	a0,s0,-1104
    329c:	00003097          	auipc	ra,0x3
    32a0:	96c080e7          	jalr	-1684(ra) # 5c08 <open>
    if(fd < 0)
    32a4:	00054963          	bltz	a0,32b6 <diskfull+0xec>
    close(fd);
    32a8:	00003097          	auipc	ra,0x3
    32ac:	948080e7          	jalr	-1720(ra) # 5bf0 <close>
  for(int i = 0; i < nzz; i++){
    32b0:	2485                	addiw	s1,s1,1
    32b2:	fb3493e3          	bne	s1,s3,3258 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    32b6:	00004517          	auipc	a0,0x4
    32ba:	08a50513          	addi	a0,a0,138 # 7340 <malloc+0x133a>
    32be:	00003097          	auipc	ra,0x3
    32c2:	972080e7          	jalr	-1678(ra) # 5c30 <mkdir>
    32c6:	12050963          	beqz	a0,33f8 <diskfull+0x22e>
  unlink("diskfulldir");
    32ca:	00004517          	auipc	a0,0x4
    32ce:	07650513          	addi	a0,a0,118 # 7340 <malloc+0x133a>
    32d2:	00003097          	auipc	ra,0x3
    32d6:	946080e7          	jalr	-1722(ra) # 5c18 <unlink>
  for(int i = 0; i < nzz; i++){
    32da:	4481                	li	s1,0
    name[0] = 'z';
    32dc:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32e0:	08000993          	li	s3,128
    name[0] = 'z';
    32e4:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32e8:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32ec:	41f4d79b          	sraiw	a5,s1,0x1f
    32f0:	01b7d71b          	srliw	a4,a5,0x1b
    32f4:	009707bb          	addw	a5,a4,s1
    32f8:	4057d69b          	sraiw	a3,a5,0x5
    32fc:	0306869b          	addiw	a3,a3,48
    3300:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3304:	8bfd                	andi	a5,a5,31
    3306:	9f99                	subw	a5,a5,a4
    3308:	0307879b          	addiw	a5,a5,48
    330c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3310:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3314:	bb040513          	addi	a0,s0,-1104
    3318:	00003097          	auipc	ra,0x3
    331c:	900080e7          	jalr	-1792(ra) # 5c18 <unlink>
  for(int i = 0; i < nzz; i++){
    3320:	2485                	addiw	s1,s1,1
    3322:	fd3491e3          	bne	s1,s3,32e4 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3326:	03405e63          	blez	s4,3362 <diskfull+0x198>
    332a:	4481                	li	s1,0
    name[0] = 'b';
    332c:	06200a93          	li	s5,98
    name[1] = 'i';
    3330:	06900993          	li	s3,105
    name[2] = 'g';
    3334:	06700913          	li	s2,103
    name[0] = 'b';
    3338:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    333c:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3340:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3344:	0304879b          	addiw	a5,s1,48
    3348:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    334c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3350:	bb040513          	addi	a0,s0,-1104
    3354:	00003097          	auipc	ra,0x3
    3358:	8c4080e7          	jalr	-1852(ra) # 5c18 <unlink>
  for(int i = 0; i < fi; i++){
    335c:	2485                	addiw	s1,s1,1
    335e:	fd449de3          	bne	s1,s4,3338 <diskfull+0x16e>
}
    3362:	46813083          	ld	ra,1128(sp)
    3366:	46013403          	ld	s0,1120(sp)
    336a:	45813483          	ld	s1,1112(sp)
    336e:	45013903          	ld	s2,1104(sp)
    3372:	44813983          	ld	s3,1096(sp)
    3376:	44013a03          	ld	s4,1088(sp)
    337a:	43813a83          	ld	s5,1080(sp)
    337e:	43013b03          	ld	s6,1072(sp)
    3382:	42813b83          	ld	s7,1064(sp)
    3386:	42013c03          	ld	s8,1056(sp)
    338a:	47010113          	addi	sp,sp,1136
    338e:	8082                	ret
    close(fd);
    3390:	854a                	mv	a0,s2
    3392:	00003097          	auipc	ra,0x3
    3396:	85e080e7          	jalr	-1954(ra) # 5bf0 <close>
  for(fi = 0; done == 0; fi++){
    339a:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    339c:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    33a0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    33a4:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    33a8:	030a079b          	addiw	a5,s4,48
    33ac:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33b0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33b4:	b9040513          	addi	a0,s0,-1136
    33b8:	00003097          	auipc	ra,0x3
    33bc:	860080e7          	jalr	-1952(ra) # 5c18 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33c0:	60200593          	li	a1,1538
    33c4:	b9040513          	addi	a0,s0,-1136
    33c8:	00003097          	auipc	ra,0x3
    33cc:	840080e7          	jalr	-1984(ra) # 5c08 <open>
    33d0:	892a                	mv	s2,a0
    if(fd < 0){
    33d2:	e40547e3          	bltz	a0,3220 <diskfull+0x56>
    33d6:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33d8:	40000613          	li	a2,1024
    33dc:	bb040593          	addi	a1,s0,-1104
    33e0:	854a                	mv	a0,s2
    33e2:	00003097          	auipc	ra,0x3
    33e6:	806080e7          	jalr	-2042(ra) # 5be8 <write>
    33ea:	40000793          	li	a5,1024
    33ee:	e4f515e3          	bne	a0,a5,3238 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    33f2:	34fd                	addiw	s1,s1,-1
    33f4:	f0f5                	bnez	s1,33d8 <diskfull+0x20e>
    33f6:	bf69                	j	3390 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33f8:	00004517          	auipc	a0,0x4
    33fc:	f7850513          	addi	a0,a0,-136 # 7370 <malloc+0x136a>
    3400:	00003097          	auipc	ra,0x3
    3404:	b48080e7          	jalr	-1208(ra) # 5f48 <printf>
    3408:	b5c9                	j	32ca <diskfull+0x100>

000000000000340a <iputtest>:
{
    340a:	1101                	addi	sp,sp,-32
    340c:	ec06                	sd	ra,24(sp)
    340e:	e822                	sd	s0,16(sp)
    3410:	e426                	sd	s1,8(sp)
    3412:	1000                	addi	s0,sp,32
    3414:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3416:	00004517          	auipc	a0,0x4
    341a:	f8a50513          	addi	a0,a0,-118 # 73a0 <malloc+0x139a>
    341e:	00003097          	auipc	ra,0x3
    3422:	812080e7          	jalr	-2030(ra) # 5c30 <mkdir>
    3426:	04054563          	bltz	a0,3470 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    342a:	00004517          	auipc	a0,0x4
    342e:	f7650513          	addi	a0,a0,-138 # 73a0 <malloc+0x139a>
    3432:	00003097          	auipc	ra,0x3
    3436:	806080e7          	jalr	-2042(ra) # 5c38 <chdir>
    343a:	04054963          	bltz	a0,348c <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    343e:	00004517          	auipc	a0,0x4
    3442:	fa250513          	addi	a0,a0,-94 # 73e0 <malloc+0x13da>
    3446:	00002097          	auipc	ra,0x2
    344a:	7d2080e7          	jalr	2002(ra) # 5c18 <unlink>
    344e:	04054d63          	bltz	a0,34a8 <iputtest+0x9e>
  if(chdir("/") < 0){
    3452:	00004517          	auipc	a0,0x4
    3456:	fbe50513          	addi	a0,a0,-66 # 7410 <malloc+0x140a>
    345a:	00002097          	auipc	ra,0x2
    345e:	7de080e7          	jalr	2014(ra) # 5c38 <chdir>
    3462:	06054163          	bltz	a0,34c4 <iputtest+0xba>
}
    3466:	60e2                	ld	ra,24(sp)
    3468:	6442                	ld	s0,16(sp)
    346a:	64a2                	ld	s1,8(sp)
    346c:	6105                	addi	sp,sp,32
    346e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3470:	85a6                	mv	a1,s1
    3472:	00004517          	auipc	a0,0x4
    3476:	f3650513          	addi	a0,a0,-202 # 73a8 <malloc+0x13a2>
    347a:	00003097          	auipc	ra,0x3
    347e:	ace080e7          	jalr	-1330(ra) # 5f48 <printf>
    exit(1);
    3482:	4505                	li	a0,1
    3484:	00002097          	auipc	ra,0x2
    3488:	744080e7          	jalr	1860(ra) # 5bc8 <exit>
    printf("%s: chdir iputdir failed\n", s);
    348c:	85a6                	mv	a1,s1
    348e:	00004517          	auipc	a0,0x4
    3492:	f3250513          	addi	a0,a0,-206 # 73c0 <malloc+0x13ba>
    3496:	00003097          	auipc	ra,0x3
    349a:	ab2080e7          	jalr	-1358(ra) # 5f48 <printf>
    exit(1);
    349e:	4505                	li	a0,1
    34a0:	00002097          	auipc	ra,0x2
    34a4:	728080e7          	jalr	1832(ra) # 5bc8 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34a8:	85a6                	mv	a1,s1
    34aa:	00004517          	auipc	a0,0x4
    34ae:	f4650513          	addi	a0,a0,-186 # 73f0 <malloc+0x13ea>
    34b2:	00003097          	auipc	ra,0x3
    34b6:	a96080e7          	jalr	-1386(ra) # 5f48 <printf>
    exit(1);
    34ba:	4505                	li	a0,1
    34bc:	00002097          	auipc	ra,0x2
    34c0:	70c080e7          	jalr	1804(ra) # 5bc8 <exit>
    printf("%s: chdir / failed\n", s);
    34c4:	85a6                	mv	a1,s1
    34c6:	00004517          	auipc	a0,0x4
    34ca:	f5250513          	addi	a0,a0,-174 # 7418 <malloc+0x1412>
    34ce:	00003097          	auipc	ra,0x3
    34d2:	a7a080e7          	jalr	-1414(ra) # 5f48 <printf>
    exit(1);
    34d6:	4505                	li	a0,1
    34d8:	00002097          	auipc	ra,0x2
    34dc:	6f0080e7          	jalr	1776(ra) # 5bc8 <exit>

00000000000034e0 <exitiputtest>:
{
    34e0:	7179                	addi	sp,sp,-48
    34e2:	f406                	sd	ra,40(sp)
    34e4:	f022                	sd	s0,32(sp)
    34e6:	ec26                	sd	s1,24(sp)
    34e8:	1800                	addi	s0,sp,48
    34ea:	84aa                	mv	s1,a0
  pid = fork();
    34ec:	00002097          	auipc	ra,0x2
    34f0:	6d4080e7          	jalr	1748(ra) # 5bc0 <fork>
  if(pid < 0){
    34f4:	04054663          	bltz	a0,3540 <exitiputtest+0x60>
  if(pid == 0){
    34f8:	ed45                	bnez	a0,35b0 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34fa:	00004517          	auipc	a0,0x4
    34fe:	ea650513          	addi	a0,a0,-346 # 73a0 <malloc+0x139a>
    3502:	00002097          	auipc	ra,0x2
    3506:	72e080e7          	jalr	1838(ra) # 5c30 <mkdir>
    350a:	04054963          	bltz	a0,355c <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    350e:	00004517          	auipc	a0,0x4
    3512:	e9250513          	addi	a0,a0,-366 # 73a0 <malloc+0x139a>
    3516:	00002097          	auipc	ra,0x2
    351a:	722080e7          	jalr	1826(ra) # 5c38 <chdir>
    351e:	04054d63          	bltz	a0,3578 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3522:	00004517          	auipc	a0,0x4
    3526:	ebe50513          	addi	a0,a0,-322 # 73e0 <malloc+0x13da>
    352a:	00002097          	auipc	ra,0x2
    352e:	6ee080e7          	jalr	1774(ra) # 5c18 <unlink>
    3532:	06054163          	bltz	a0,3594 <exitiputtest+0xb4>
    exit(0);
    3536:	4501                	li	a0,0
    3538:	00002097          	auipc	ra,0x2
    353c:	690080e7          	jalr	1680(ra) # 5bc8 <exit>
    printf("%s: fork failed\n", s);
    3540:	85a6                	mv	a1,s1
    3542:	00003517          	auipc	a0,0x3
    3546:	48e50513          	addi	a0,a0,1166 # 69d0 <malloc+0x9ca>
    354a:	00003097          	auipc	ra,0x3
    354e:	9fe080e7          	jalr	-1538(ra) # 5f48 <printf>
    exit(1);
    3552:	4505                	li	a0,1
    3554:	00002097          	auipc	ra,0x2
    3558:	674080e7          	jalr	1652(ra) # 5bc8 <exit>
      printf("%s: mkdir failed\n", s);
    355c:	85a6                	mv	a1,s1
    355e:	00004517          	auipc	a0,0x4
    3562:	e4a50513          	addi	a0,a0,-438 # 73a8 <malloc+0x13a2>
    3566:	00003097          	auipc	ra,0x3
    356a:	9e2080e7          	jalr	-1566(ra) # 5f48 <printf>
      exit(1);
    356e:	4505                	li	a0,1
    3570:	00002097          	auipc	ra,0x2
    3574:	658080e7          	jalr	1624(ra) # 5bc8 <exit>
      printf("%s: child chdir failed\n", s);
    3578:	85a6                	mv	a1,s1
    357a:	00004517          	auipc	a0,0x4
    357e:	eb650513          	addi	a0,a0,-330 # 7430 <malloc+0x142a>
    3582:	00003097          	auipc	ra,0x3
    3586:	9c6080e7          	jalr	-1594(ra) # 5f48 <printf>
      exit(1);
    358a:	4505                	li	a0,1
    358c:	00002097          	auipc	ra,0x2
    3590:	63c080e7          	jalr	1596(ra) # 5bc8 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3594:	85a6                	mv	a1,s1
    3596:	00004517          	auipc	a0,0x4
    359a:	e5a50513          	addi	a0,a0,-422 # 73f0 <malloc+0x13ea>
    359e:	00003097          	auipc	ra,0x3
    35a2:	9aa080e7          	jalr	-1622(ra) # 5f48 <printf>
      exit(1);
    35a6:	4505                	li	a0,1
    35a8:	00002097          	auipc	ra,0x2
    35ac:	620080e7          	jalr	1568(ra) # 5bc8 <exit>
  wait(&xstatus);
    35b0:	fdc40513          	addi	a0,s0,-36
    35b4:	00002097          	auipc	ra,0x2
    35b8:	61c080e7          	jalr	1564(ra) # 5bd0 <wait>
  exit(xstatus);
    35bc:	fdc42503          	lw	a0,-36(s0)
    35c0:	00002097          	auipc	ra,0x2
    35c4:	608080e7          	jalr	1544(ra) # 5bc8 <exit>

00000000000035c8 <dirtest>:
{
    35c8:	1101                	addi	sp,sp,-32
    35ca:	ec06                	sd	ra,24(sp)
    35cc:	e822                	sd	s0,16(sp)
    35ce:	e426                	sd	s1,8(sp)
    35d0:	1000                	addi	s0,sp,32
    35d2:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35d4:	00004517          	auipc	a0,0x4
    35d8:	e7450513          	addi	a0,a0,-396 # 7448 <malloc+0x1442>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	654080e7          	jalr	1620(ra) # 5c30 <mkdir>
    35e4:	04054563          	bltz	a0,362e <dirtest+0x66>
  if(chdir("dir0") < 0){
    35e8:	00004517          	auipc	a0,0x4
    35ec:	e6050513          	addi	a0,a0,-416 # 7448 <malloc+0x1442>
    35f0:	00002097          	auipc	ra,0x2
    35f4:	648080e7          	jalr	1608(ra) # 5c38 <chdir>
    35f8:	04054963          	bltz	a0,364a <dirtest+0x82>
  if(chdir("..") < 0){
    35fc:	00004517          	auipc	a0,0x4
    3600:	e6c50513          	addi	a0,a0,-404 # 7468 <malloc+0x1462>
    3604:	00002097          	auipc	ra,0x2
    3608:	634080e7          	jalr	1588(ra) # 5c38 <chdir>
    360c:	04054d63          	bltz	a0,3666 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3610:	00004517          	auipc	a0,0x4
    3614:	e3850513          	addi	a0,a0,-456 # 7448 <malloc+0x1442>
    3618:	00002097          	auipc	ra,0x2
    361c:	600080e7          	jalr	1536(ra) # 5c18 <unlink>
    3620:	06054163          	bltz	a0,3682 <dirtest+0xba>
}
    3624:	60e2                	ld	ra,24(sp)
    3626:	6442                	ld	s0,16(sp)
    3628:	64a2                	ld	s1,8(sp)
    362a:	6105                	addi	sp,sp,32
    362c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    362e:	85a6                	mv	a1,s1
    3630:	00004517          	auipc	a0,0x4
    3634:	d7850513          	addi	a0,a0,-648 # 73a8 <malloc+0x13a2>
    3638:	00003097          	auipc	ra,0x3
    363c:	910080e7          	jalr	-1776(ra) # 5f48 <printf>
    exit(1);
    3640:	4505                	li	a0,1
    3642:	00002097          	auipc	ra,0x2
    3646:	586080e7          	jalr	1414(ra) # 5bc8 <exit>
    printf("%s: chdir dir0 failed\n", s);
    364a:	85a6                	mv	a1,s1
    364c:	00004517          	auipc	a0,0x4
    3650:	e0450513          	addi	a0,a0,-508 # 7450 <malloc+0x144a>
    3654:	00003097          	auipc	ra,0x3
    3658:	8f4080e7          	jalr	-1804(ra) # 5f48 <printf>
    exit(1);
    365c:	4505                	li	a0,1
    365e:	00002097          	auipc	ra,0x2
    3662:	56a080e7          	jalr	1386(ra) # 5bc8 <exit>
    printf("%s: chdir .. failed\n", s);
    3666:	85a6                	mv	a1,s1
    3668:	00004517          	auipc	a0,0x4
    366c:	e0850513          	addi	a0,a0,-504 # 7470 <malloc+0x146a>
    3670:	00003097          	auipc	ra,0x3
    3674:	8d8080e7          	jalr	-1832(ra) # 5f48 <printf>
    exit(1);
    3678:	4505                	li	a0,1
    367a:	00002097          	auipc	ra,0x2
    367e:	54e080e7          	jalr	1358(ra) # 5bc8 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3682:	85a6                	mv	a1,s1
    3684:	00004517          	auipc	a0,0x4
    3688:	e0450513          	addi	a0,a0,-508 # 7488 <malloc+0x1482>
    368c:	00003097          	auipc	ra,0x3
    3690:	8bc080e7          	jalr	-1860(ra) # 5f48 <printf>
    exit(1);
    3694:	4505                	li	a0,1
    3696:	00002097          	auipc	ra,0x2
    369a:	532080e7          	jalr	1330(ra) # 5bc8 <exit>

000000000000369e <subdir>:
{
    369e:	1101                	addi	sp,sp,-32
    36a0:	ec06                	sd	ra,24(sp)
    36a2:	e822                	sd	s0,16(sp)
    36a4:	e426                	sd	s1,8(sp)
    36a6:	e04a                	sd	s2,0(sp)
    36a8:	1000                	addi	s0,sp,32
    36aa:	892a                	mv	s2,a0
  unlink("ff");
    36ac:	00004517          	auipc	a0,0x4
    36b0:	f2450513          	addi	a0,a0,-220 # 75d0 <malloc+0x15ca>
    36b4:	00002097          	auipc	ra,0x2
    36b8:	564080e7          	jalr	1380(ra) # 5c18 <unlink>
  if(mkdir("dd") != 0){
    36bc:	00004517          	auipc	a0,0x4
    36c0:	de450513          	addi	a0,a0,-540 # 74a0 <malloc+0x149a>
    36c4:	00002097          	auipc	ra,0x2
    36c8:	56c080e7          	jalr	1388(ra) # 5c30 <mkdir>
    36cc:	38051663          	bnez	a0,3a58 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36d0:	20200593          	li	a1,514
    36d4:	00004517          	auipc	a0,0x4
    36d8:	dec50513          	addi	a0,a0,-532 # 74c0 <malloc+0x14ba>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	52c080e7          	jalr	1324(ra) # 5c08 <open>
    36e4:	84aa                	mv	s1,a0
  if(fd < 0){
    36e6:	38054763          	bltz	a0,3a74 <subdir+0x3d6>
  write(fd, "ff", 2);
    36ea:	4609                	li	a2,2
    36ec:	00004597          	auipc	a1,0x4
    36f0:	ee458593          	addi	a1,a1,-284 # 75d0 <malloc+0x15ca>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	4f4080e7          	jalr	1268(ra) # 5be8 <write>
  close(fd);
    36fc:	8526                	mv	a0,s1
    36fe:	00002097          	auipc	ra,0x2
    3702:	4f2080e7          	jalr	1266(ra) # 5bf0 <close>
  if(unlink("dd") >= 0){
    3706:	00004517          	auipc	a0,0x4
    370a:	d9a50513          	addi	a0,a0,-614 # 74a0 <malloc+0x149a>
    370e:	00002097          	auipc	ra,0x2
    3712:	50a080e7          	jalr	1290(ra) # 5c18 <unlink>
    3716:	36055d63          	bgez	a0,3a90 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    371a:	00004517          	auipc	a0,0x4
    371e:	dfe50513          	addi	a0,a0,-514 # 7518 <malloc+0x1512>
    3722:	00002097          	auipc	ra,0x2
    3726:	50e080e7          	jalr	1294(ra) # 5c30 <mkdir>
    372a:	38051163          	bnez	a0,3aac <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    372e:	20200593          	li	a1,514
    3732:	00004517          	auipc	a0,0x4
    3736:	e0e50513          	addi	a0,a0,-498 # 7540 <malloc+0x153a>
    373a:	00002097          	auipc	ra,0x2
    373e:	4ce080e7          	jalr	1230(ra) # 5c08 <open>
    3742:	84aa                	mv	s1,a0
  if(fd < 0){
    3744:	38054263          	bltz	a0,3ac8 <subdir+0x42a>
  write(fd, "FF", 2);
    3748:	4609                	li	a2,2
    374a:	00004597          	auipc	a1,0x4
    374e:	e2658593          	addi	a1,a1,-474 # 7570 <malloc+0x156a>
    3752:	00002097          	auipc	ra,0x2
    3756:	496080e7          	jalr	1174(ra) # 5be8 <write>
  close(fd);
    375a:	8526                	mv	a0,s1
    375c:	00002097          	auipc	ra,0x2
    3760:	494080e7          	jalr	1172(ra) # 5bf0 <close>
  fd = open("dd/dd/../ff", 0);
    3764:	4581                	li	a1,0
    3766:	00004517          	auipc	a0,0x4
    376a:	e1250513          	addi	a0,a0,-494 # 7578 <malloc+0x1572>
    376e:	00002097          	auipc	ra,0x2
    3772:	49a080e7          	jalr	1178(ra) # 5c08 <open>
    3776:	84aa                	mv	s1,a0
  if(fd < 0){
    3778:	36054663          	bltz	a0,3ae4 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    377c:	660d                	lui	a2,0x3
    377e:	00009597          	auipc	a1,0x9
    3782:	4fa58593          	addi	a1,a1,1274 # cc78 <buf>
    3786:	00002097          	auipc	ra,0x2
    378a:	45a080e7          	jalr	1114(ra) # 5be0 <read>
  if(cc != 2 || buf[0] != 'f'){
    378e:	4789                	li	a5,2
    3790:	36f51863          	bne	a0,a5,3b00 <subdir+0x462>
    3794:	00009717          	auipc	a4,0x9
    3798:	4e474703          	lbu	a4,1252(a4) # cc78 <buf>
    379c:	06600793          	li	a5,102
    37a0:	36f71063          	bne	a4,a5,3b00 <subdir+0x462>
  close(fd);
    37a4:	8526                	mv	a0,s1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	44a080e7          	jalr	1098(ra) # 5bf0 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37ae:	00004597          	auipc	a1,0x4
    37b2:	e1a58593          	addi	a1,a1,-486 # 75c8 <malloc+0x15c2>
    37b6:	00004517          	auipc	a0,0x4
    37ba:	d8a50513          	addi	a0,a0,-630 # 7540 <malloc+0x153a>
    37be:	00002097          	auipc	ra,0x2
    37c2:	46a080e7          	jalr	1130(ra) # 5c28 <link>
    37c6:	34051b63          	bnez	a0,3b1c <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37ca:	00004517          	auipc	a0,0x4
    37ce:	d7650513          	addi	a0,a0,-650 # 7540 <malloc+0x153a>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	446080e7          	jalr	1094(ra) # 5c18 <unlink>
    37da:	34051f63          	bnez	a0,3b38 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37de:	4581                	li	a1,0
    37e0:	00004517          	auipc	a0,0x4
    37e4:	d6050513          	addi	a0,a0,-672 # 7540 <malloc+0x153a>
    37e8:	00002097          	auipc	ra,0x2
    37ec:	420080e7          	jalr	1056(ra) # 5c08 <open>
    37f0:	36055263          	bgez	a0,3b54 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37f4:	00004517          	auipc	a0,0x4
    37f8:	cac50513          	addi	a0,a0,-852 # 74a0 <malloc+0x149a>
    37fc:	00002097          	auipc	ra,0x2
    3800:	43c080e7          	jalr	1084(ra) # 5c38 <chdir>
    3804:	36051663          	bnez	a0,3b70 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3808:	00004517          	auipc	a0,0x4
    380c:	e5850513          	addi	a0,a0,-424 # 7660 <malloc+0x165a>
    3810:	00002097          	auipc	ra,0x2
    3814:	428080e7          	jalr	1064(ra) # 5c38 <chdir>
    3818:	36051a63          	bnez	a0,3b8c <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    381c:	00004517          	auipc	a0,0x4
    3820:	e7450513          	addi	a0,a0,-396 # 7690 <malloc+0x168a>
    3824:	00002097          	auipc	ra,0x2
    3828:	414080e7          	jalr	1044(ra) # 5c38 <chdir>
    382c:	36051e63          	bnez	a0,3ba8 <subdir+0x50a>
  if(chdir("./..") != 0){
    3830:	00004517          	auipc	a0,0x4
    3834:	e9050513          	addi	a0,a0,-368 # 76c0 <malloc+0x16ba>
    3838:	00002097          	auipc	ra,0x2
    383c:	400080e7          	jalr	1024(ra) # 5c38 <chdir>
    3840:	38051263          	bnez	a0,3bc4 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3844:	4581                	li	a1,0
    3846:	00004517          	auipc	a0,0x4
    384a:	d8250513          	addi	a0,a0,-638 # 75c8 <malloc+0x15c2>
    384e:	00002097          	auipc	ra,0x2
    3852:	3ba080e7          	jalr	954(ra) # 5c08 <open>
    3856:	84aa                	mv	s1,a0
  if(fd < 0){
    3858:	38054463          	bltz	a0,3be0 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    385c:	660d                	lui	a2,0x3
    385e:	00009597          	auipc	a1,0x9
    3862:	41a58593          	addi	a1,a1,1050 # cc78 <buf>
    3866:	00002097          	auipc	ra,0x2
    386a:	37a080e7          	jalr	890(ra) # 5be0 <read>
    386e:	4789                	li	a5,2
    3870:	38f51663          	bne	a0,a5,3bfc <subdir+0x55e>
  close(fd);
    3874:	8526                	mv	a0,s1
    3876:	00002097          	auipc	ra,0x2
    387a:	37a080e7          	jalr	890(ra) # 5bf0 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    387e:	4581                	li	a1,0
    3880:	00004517          	auipc	a0,0x4
    3884:	cc050513          	addi	a0,a0,-832 # 7540 <malloc+0x153a>
    3888:	00002097          	auipc	ra,0x2
    388c:	380080e7          	jalr	896(ra) # 5c08 <open>
    3890:	38055463          	bgez	a0,3c18 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3894:	20200593          	li	a1,514
    3898:	00004517          	auipc	a0,0x4
    389c:	eb850513          	addi	a0,a0,-328 # 7750 <malloc+0x174a>
    38a0:	00002097          	auipc	ra,0x2
    38a4:	368080e7          	jalr	872(ra) # 5c08 <open>
    38a8:	38055663          	bgez	a0,3c34 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38ac:	20200593          	li	a1,514
    38b0:	00004517          	auipc	a0,0x4
    38b4:	ed050513          	addi	a0,a0,-304 # 7780 <malloc+0x177a>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	350080e7          	jalr	848(ra) # 5c08 <open>
    38c0:	38055863          	bgez	a0,3c50 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38c4:	20000593          	li	a1,512
    38c8:	00004517          	auipc	a0,0x4
    38cc:	bd850513          	addi	a0,a0,-1064 # 74a0 <malloc+0x149a>
    38d0:	00002097          	auipc	ra,0x2
    38d4:	338080e7          	jalr	824(ra) # 5c08 <open>
    38d8:	38055a63          	bgez	a0,3c6c <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38dc:	4589                	li	a1,2
    38de:	00004517          	auipc	a0,0x4
    38e2:	bc250513          	addi	a0,a0,-1086 # 74a0 <malloc+0x149a>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	322080e7          	jalr	802(ra) # 5c08 <open>
    38ee:	38055d63          	bgez	a0,3c88 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38f2:	4585                	li	a1,1
    38f4:	00004517          	auipc	a0,0x4
    38f8:	bac50513          	addi	a0,a0,-1108 # 74a0 <malloc+0x149a>
    38fc:	00002097          	auipc	ra,0x2
    3900:	30c080e7          	jalr	780(ra) # 5c08 <open>
    3904:	3a055063          	bgez	a0,3ca4 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3908:	00004597          	auipc	a1,0x4
    390c:	f0858593          	addi	a1,a1,-248 # 7810 <malloc+0x180a>
    3910:	00004517          	auipc	a0,0x4
    3914:	e4050513          	addi	a0,a0,-448 # 7750 <malloc+0x174a>
    3918:	00002097          	auipc	ra,0x2
    391c:	310080e7          	jalr	784(ra) # 5c28 <link>
    3920:	3a050063          	beqz	a0,3cc0 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3924:	00004597          	auipc	a1,0x4
    3928:	eec58593          	addi	a1,a1,-276 # 7810 <malloc+0x180a>
    392c:	00004517          	auipc	a0,0x4
    3930:	e5450513          	addi	a0,a0,-428 # 7780 <malloc+0x177a>
    3934:	00002097          	auipc	ra,0x2
    3938:	2f4080e7          	jalr	756(ra) # 5c28 <link>
    393c:	3a050063          	beqz	a0,3cdc <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3940:	00004597          	auipc	a1,0x4
    3944:	c8858593          	addi	a1,a1,-888 # 75c8 <malloc+0x15c2>
    3948:	00004517          	auipc	a0,0x4
    394c:	b7850513          	addi	a0,a0,-1160 # 74c0 <malloc+0x14ba>
    3950:	00002097          	auipc	ra,0x2
    3954:	2d8080e7          	jalr	728(ra) # 5c28 <link>
    3958:	3a050063          	beqz	a0,3cf8 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    395c:	00004517          	auipc	a0,0x4
    3960:	df450513          	addi	a0,a0,-524 # 7750 <malloc+0x174a>
    3964:	00002097          	auipc	ra,0x2
    3968:	2cc080e7          	jalr	716(ra) # 5c30 <mkdir>
    396c:	3a050463          	beqz	a0,3d14 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3970:	00004517          	auipc	a0,0x4
    3974:	e1050513          	addi	a0,a0,-496 # 7780 <malloc+0x177a>
    3978:	00002097          	auipc	ra,0x2
    397c:	2b8080e7          	jalr	696(ra) # 5c30 <mkdir>
    3980:	3a050863          	beqz	a0,3d30 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3984:	00004517          	auipc	a0,0x4
    3988:	c4450513          	addi	a0,a0,-956 # 75c8 <malloc+0x15c2>
    398c:	00002097          	auipc	ra,0x2
    3990:	2a4080e7          	jalr	676(ra) # 5c30 <mkdir>
    3994:	3a050c63          	beqz	a0,3d4c <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3998:	00004517          	auipc	a0,0x4
    399c:	de850513          	addi	a0,a0,-536 # 7780 <malloc+0x177a>
    39a0:	00002097          	auipc	ra,0x2
    39a4:	278080e7          	jalr	632(ra) # 5c18 <unlink>
    39a8:	3c050063          	beqz	a0,3d68 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39ac:	00004517          	auipc	a0,0x4
    39b0:	da450513          	addi	a0,a0,-604 # 7750 <malloc+0x174a>
    39b4:	00002097          	auipc	ra,0x2
    39b8:	264080e7          	jalr	612(ra) # 5c18 <unlink>
    39bc:	3c050463          	beqz	a0,3d84 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39c0:	00004517          	auipc	a0,0x4
    39c4:	b0050513          	addi	a0,a0,-1280 # 74c0 <malloc+0x14ba>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	270080e7          	jalr	624(ra) # 5c38 <chdir>
    39d0:	3c050863          	beqz	a0,3da0 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39d4:	00004517          	auipc	a0,0x4
    39d8:	f8c50513          	addi	a0,a0,-116 # 7960 <malloc+0x195a>
    39dc:	00002097          	auipc	ra,0x2
    39e0:	25c080e7          	jalr	604(ra) # 5c38 <chdir>
    39e4:	3c050c63          	beqz	a0,3dbc <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39e8:	00004517          	auipc	a0,0x4
    39ec:	be050513          	addi	a0,a0,-1056 # 75c8 <malloc+0x15c2>
    39f0:	00002097          	auipc	ra,0x2
    39f4:	228080e7          	jalr	552(ra) # 5c18 <unlink>
    39f8:	3e051063          	bnez	a0,3dd8 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39fc:	00004517          	auipc	a0,0x4
    3a00:	ac450513          	addi	a0,a0,-1340 # 74c0 <malloc+0x14ba>
    3a04:	00002097          	auipc	ra,0x2
    3a08:	214080e7          	jalr	532(ra) # 5c18 <unlink>
    3a0c:	3e051463          	bnez	a0,3df4 <subdir+0x756>
  if(unlink("dd") == 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	a9050513          	addi	a0,a0,-1392 # 74a0 <malloc+0x149a>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	200080e7          	jalr	512(ra) # 5c18 <unlink>
    3a20:	3e050863          	beqz	a0,3e10 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a24:	00004517          	auipc	a0,0x4
    3a28:	fac50513          	addi	a0,a0,-84 # 79d0 <malloc+0x19ca>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	1ec080e7          	jalr	492(ra) # 5c18 <unlink>
    3a34:	3e054c63          	bltz	a0,3e2c <subdir+0x78e>
  if(unlink("dd") < 0){
    3a38:	00004517          	auipc	a0,0x4
    3a3c:	a6850513          	addi	a0,a0,-1432 # 74a0 <malloc+0x149a>
    3a40:	00002097          	auipc	ra,0x2
    3a44:	1d8080e7          	jalr	472(ra) # 5c18 <unlink>
    3a48:	40054063          	bltz	a0,3e48 <subdir+0x7aa>
}
    3a4c:	60e2                	ld	ra,24(sp)
    3a4e:	6442                	ld	s0,16(sp)
    3a50:	64a2                	ld	s1,8(sp)
    3a52:	6902                	ld	s2,0(sp)
    3a54:	6105                	addi	sp,sp,32
    3a56:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a58:	85ca                	mv	a1,s2
    3a5a:	00004517          	auipc	a0,0x4
    3a5e:	a4e50513          	addi	a0,a0,-1458 # 74a8 <malloc+0x14a2>
    3a62:	00002097          	auipc	ra,0x2
    3a66:	4e6080e7          	jalr	1254(ra) # 5f48 <printf>
    exit(1);
    3a6a:	4505                	li	a0,1
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	15c080e7          	jalr	348(ra) # 5bc8 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a74:	85ca                	mv	a1,s2
    3a76:	00004517          	auipc	a0,0x4
    3a7a:	a5250513          	addi	a0,a0,-1454 # 74c8 <malloc+0x14c2>
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	4ca080e7          	jalr	1226(ra) # 5f48 <printf>
    exit(1);
    3a86:	4505                	li	a0,1
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	140080e7          	jalr	320(ra) # 5bc8 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a90:	85ca                	mv	a1,s2
    3a92:	00004517          	auipc	a0,0x4
    3a96:	a5650513          	addi	a0,a0,-1450 # 74e8 <malloc+0x14e2>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	4ae080e7          	jalr	1198(ra) # 5f48 <printf>
    exit(1);
    3aa2:	4505                	li	a0,1
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	124080e7          	jalr	292(ra) # 5bc8 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3aac:	85ca                	mv	a1,s2
    3aae:	00004517          	auipc	a0,0x4
    3ab2:	a7250513          	addi	a0,a0,-1422 # 7520 <malloc+0x151a>
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	492080e7          	jalr	1170(ra) # 5f48 <printf>
    exit(1);
    3abe:	4505                	li	a0,1
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	108080e7          	jalr	264(ra) # 5bc8 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ac8:	85ca                	mv	a1,s2
    3aca:	00004517          	auipc	a0,0x4
    3ace:	a8650513          	addi	a0,a0,-1402 # 7550 <malloc+0x154a>
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	476080e7          	jalr	1142(ra) # 5f48 <printf>
    exit(1);
    3ada:	4505                	li	a0,1
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	0ec080e7          	jalr	236(ra) # 5bc8 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ae4:	85ca                	mv	a1,s2
    3ae6:	00004517          	auipc	a0,0x4
    3aea:	aa250513          	addi	a0,a0,-1374 # 7588 <malloc+0x1582>
    3aee:	00002097          	auipc	ra,0x2
    3af2:	45a080e7          	jalr	1114(ra) # 5f48 <printf>
    exit(1);
    3af6:	4505                	li	a0,1
    3af8:	00002097          	auipc	ra,0x2
    3afc:	0d0080e7          	jalr	208(ra) # 5bc8 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b00:	85ca                	mv	a1,s2
    3b02:	00004517          	auipc	a0,0x4
    3b06:	aa650513          	addi	a0,a0,-1370 # 75a8 <malloc+0x15a2>
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	43e080e7          	jalr	1086(ra) # 5f48 <printf>
    exit(1);
    3b12:	4505                	li	a0,1
    3b14:	00002097          	auipc	ra,0x2
    3b18:	0b4080e7          	jalr	180(ra) # 5bc8 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b1c:	85ca                	mv	a1,s2
    3b1e:	00004517          	auipc	a0,0x4
    3b22:	aba50513          	addi	a0,a0,-1350 # 75d8 <malloc+0x15d2>
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	422080e7          	jalr	1058(ra) # 5f48 <printf>
    exit(1);
    3b2e:	4505                	li	a0,1
    3b30:	00002097          	auipc	ra,0x2
    3b34:	098080e7          	jalr	152(ra) # 5bc8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b38:	85ca                	mv	a1,s2
    3b3a:	00004517          	auipc	a0,0x4
    3b3e:	ac650513          	addi	a0,a0,-1338 # 7600 <malloc+0x15fa>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	406080e7          	jalr	1030(ra) # 5f48 <printf>
    exit(1);
    3b4a:	4505                	li	a0,1
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	07c080e7          	jalr	124(ra) # 5bc8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b54:	85ca                	mv	a1,s2
    3b56:	00004517          	auipc	a0,0x4
    3b5a:	aca50513          	addi	a0,a0,-1334 # 7620 <malloc+0x161a>
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	3ea080e7          	jalr	1002(ra) # 5f48 <printf>
    exit(1);
    3b66:	4505                	li	a0,1
    3b68:	00002097          	auipc	ra,0x2
    3b6c:	060080e7          	jalr	96(ra) # 5bc8 <exit>
    printf("%s: chdir dd failed\n", s);
    3b70:	85ca                	mv	a1,s2
    3b72:	00004517          	auipc	a0,0x4
    3b76:	ad650513          	addi	a0,a0,-1322 # 7648 <malloc+0x1642>
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	3ce080e7          	jalr	974(ra) # 5f48 <printf>
    exit(1);
    3b82:	4505                	li	a0,1
    3b84:	00002097          	auipc	ra,0x2
    3b88:	044080e7          	jalr	68(ra) # 5bc8 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b8c:	85ca                	mv	a1,s2
    3b8e:	00004517          	auipc	a0,0x4
    3b92:	ae250513          	addi	a0,a0,-1310 # 7670 <malloc+0x166a>
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	3b2080e7          	jalr	946(ra) # 5f48 <printf>
    exit(1);
    3b9e:	4505                	li	a0,1
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	028080e7          	jalr	40(ra) # 5bc8 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3ba8:	85ca                	mv	a1,s2
    3baa:	00004517          	auipc	a0,0x4
    3bae:	af650513          	addi	a0,a0,-1290 # 76a0 <malloc+0x169a>
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	396080e7          	jalr	918(ra) # 5f48 <printf>
    exit(1);
    3bba:	4505                	li	a0,1
    3bbc:	00002097          	auipc	ra,0x2
    3bc0:	00c080e7          	jalr	12(ra) # 5bc8 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bc4:	85ca                	mv	a1,s2
    3bc6:	00004517          	auipc	a0,0x4
    3bca:	b0250513          	addi	a0,a0,-1278 # 76c8 <malloc+0x16c2>
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	37a080e7          	jalr	890(ra) # 5f48 <printf>
    exit(1);
    3bd6:	4505                	li	a0,1
    3bd8:	00002097          	auipc	ra,0x2
    3bdc:	ff0080e7          	jalr	-16(ra) # 5bc8 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3be0:	85ca                	mv	a1,s2
    3be2:	00004517          	auipc	a0,0x4
    3be6:	afe50513          	addi	a0,a0,-1282 # 76e0 <malloc+0x16da>
    3bea:	00002097          	auipc	ra,0x2
    3bee:	35e080e7          	jalr	862(ra) # 5f48 <printf>
    exit(1);
    3bf2:	4505                	li	a0,1
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	fd4080e7          	jalr	-44(ra) # 5bc8 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bfc:	85ca                	mv	a1,s2
    3bfe:	00004517          	auipc	a0,0x4
    3c02:	b0250513          	addi	a0,a0,-1278 # 7700 <malloc+0x16fa>
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	342080e7          	jalr	834(ra) # 5f48 <printf>
    exit(1);
    3c0e:	4505                	li	a0,1
    3c10:	00002097          	auipc	ra,0x2
    3c14:	fb8080e7          	jalr	-72(ra) # 5bc8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c18:	85ca                	mv	a1,s2
    3c1a:	00004517          	auipc	a0,0x4
    3c1e:	b0650513          	addi	a0,a0,-1274 # 7720 <malloc+0x171a>
    3c22:	00002097          	auipc	ra,0x2
    3c26:	326080e7          	jalr	806(ra) # 5f48 <printf>
    exit(1);
    3c2a:	4505                	li	a0,1
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	f9c080e7          	jalr	-100(ra) # 5bc8 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c34:	85ca                	mv	a1,s2
    3c36:	00004517          	auipc	a0,0x4
    3c3a:	b2a50513          	addi	a0,a0,-1238 # 7760 <malloc+0x175a>
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	30a080e7          	jalr	778(ra) # 5f48 <printf>
    exit(1);
    3c46:	4505                	li	a0,1
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	f80080e7          	jalr	-128(ra) # 5bc8 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c50:	85ca                	mv	a1,s2
    3c52:	00004517          	auipc	a0,0x4
    3c56:	b3e50513          	addi	a0,a0,-1218 # 7790 <malloc+0x178a>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	2ee080e7          	jalr	750(ra) # 5f48 <printf>
    exit(1);
    3c62:	4505                	li	a0,1
    3c64:	00002097          	auipc	ra,0x2
    3c68:	f64080e7          	jalr	-156(ra) # 5bc8 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c6c:	85ca                	mv	a1,s2
    3c6e:	00004517          	auipc	a0,0x4
    3c72:	b4250513          	addi	a0,a0,-1214 # 77b0 <malloc+0x17aa>
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	2d2080e7          	jalr	722(ra) # 5f48 <printf>
    exit(1);
    3c7e:	4505                	li	a0,1
    3c80:	00002097          	auipc	ra,0x2
    3c84:	f48080e7          	jalr	-184(ra) # 5bc8 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c88:	85ca                	mv	a1,s2
    3c8a:	00004517          	auipc	a0,0x4
    3c8e:	b4650513          	addi	a0,a0,-1210 # 77d0 <malloc+0x17ca>
    3c92:	00002097          	auipc	ra,0x2
    3c96:	2b6080e7          	jalr	694(ra) # 5f48 <printf>
    exit(1);
    3c9a:	4505                	li	a0,1
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	f2c080e7          	jalr	-212(ra) # 5bc8 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3ca4:	85ca                	mv	a1,s2
    3ca6:	00004517          	auipc	a0,0x4
    3caa:	b4a50513          	addi	a0,a0,-1206 # 77f0 <malloc+0x17ea>
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	29a080e7          	jalr	666(ra) # 5f48 <printf>
    exit(1);
    3cb6:	4505                	li	a0,1
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	f10080e7          	jalr	-240(ra) # 5bc8 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cc0:	85ca                	mv	a1,s2
    3cc2:	00004517          	auipc	a0,0x4
    3cc6:	b5e50513          	addi	a0,a0,-1186 # 7820 <malloc+0x181a>
    3cca:	00002097          	auipc	ra,0x2
    3cce:	27e080e7          	jalr	638(ra) # 5f48 <printf>
    exit(1);
    3cd2:	4505                	li	a0,1
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	ef4080e7          	jalr	-268(ra) # 5bc8 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cdc:	85ca                	mv	a1,s2
    3cde:	00004517          	auipc	a0,0x4
    3ce2:	b6a50513          	addi	a0,a0,-1174 # 7848 <malloc+0x1842>
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	262080e7          	jalr	610(ra) # 5f48 <printf>
    exit(1);
    3cee:	4505                	li	a0,1
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	ed8080e7          	jalr	-296(ra) # 5bc8 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cf8:	85ca                	mv	a1,s2
    3cfa:	00004517          	auipc	a0,0x4
    3cfe:	b7650513          	addi	a0,a0,-1162 # 7870 <malloc+0x186a>
    3d02:	00002097          	auipc	ra,0x2
    3d06:	246080e7          	jalr	582(ra) # 5f48 <printf>
    exit(1);
    3d0a:	4505                	li	a0,1
    3d0c:	00002097          	auipc	ra,0x2
    3d10:	ebc080e7          	jalr	-324(ra) # 5bc8 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d14:	85ca                	mv	a1,s2
    3d16:	00004517          	auipc	a0,0x4
    3d1a:	b8250513          	addi	a0,a0,-1150 # 7898 <malloc+0x1892>
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	22a080e7          	jalr	554(ra) # 5f48 <printf>
    exit(1);
    3d26:	4505                	li	a0,1
    3d28:	00002097          	auipc	ra,0x2
    3d2c:	ea0080e7          	jalr	-352(ra) # 5bc8 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d30:	85ca                	mv	a1,s2
    3d32:	00004517          	auipc	a0,0x4
    3d36:	b8650513          	addi	a0,a0,-1146 # 78b8 <malloc+0x18b2>
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	20e080e7          	jalr	526(ra) # 5f48 <printf>
    exit(1);
    3d42:	4505                	li	a0,1
    3d44:	00002097          	auipc	ra,0x2
    3d48:	e84080e7          	jalr	-380(ra) # 5bc8 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d4c:	85ca                	mv	a1,s2
    3d4e:	00004517          	auipc	a0,0x4
    3d52:	b8a50513          	addi	a0,a0,-1142 # 78d8 <malloc+0x18d2>
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	1f2080e7          	jalr	498(ra) # 5f48 <printf>
    exit(1);
    3d5e:	4505                	li	a0,1
    3d60:	00002097          	auipc	ra,0x2
    3d64:	e68080e7          	jalr	-408(ra) # 5bc8 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d68:	85ca                	mv	a1,s2
    3d6a:	00004517          	auipc	a0,0x4
    3d6e:	b9650513          	addi	a0,a0,-1130 # 7900 <malloc+0x18fa>
    3d72:	00002097          	auipc	ra,0x2
    3d76:	1d6080e7          	jalr	470(ra) # 5f48 <printf>
    exit(1);
    3d7a:	4505                	li	a0,1
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	e4c080e7          	jalr	-436(ra) # 5bc8 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d84:	85ca                	mv	a1,s2
    3d86:	00004517          	auipc	a0,0x4
    3d8a:	b9a50513          	addi	a0,a0,-1126 # 7920 <malloc+0x191a>
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	1ba080e7          	jalr	442(ra) # 5f48 <printf>
    exit(1);
    3d96:	4505                	li	a0,1
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	e30080e7          	jalr	-464(ra) # 5bc8 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3da0:	85ca                	mv	a1,s2
    3da2:	00004517          	auipc	a0,0x4
    3da6:	b9e50513          	addi	a0,a0,-1122 # 7940 <malloc+0x193a>
    3daa:	00002097          	auipc	ra,0x2
    3dae:	19e080e7          	jalr	414(ra) # 5f48 <printf>
    exit(1);
    3db2:	4505                	li	a0,1
    3db4:	00002097          	auipc	ra,0x2
    3db8:	e14080e7          	jalr	-492(ra) # 5bc8 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dbc:	85ca                	mv	a1,s2
    3dbe:	00004517          	auipc	a0,0x4
    3dc2:	baa50513          	addi	a0,a0,-1110 # 7968 <malloc+0x1962>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	182080e7          	jalr	386(ra) # 5f48 <printf>
    exit(1);
    3dce:	4505                	li	a0,1
    3dd0:	00002097          	auipc	ra,0x2
    3dd4:	df8080e7          	jalr	-520(ra) # 5bc8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dd8:	85ca                	mv	a1,s2
    3dda:	00004517          	auipc	a0,0x4
    3dde:	82650513          	addi	a0,a0,-2010 # 7600 <malloc+0x15fa>
    3de2:	00002097          	auipc	ra,0x2
    3de6:	166080e7          	jalr	358(ra) # 5f48 <printf>
    exit(1);
    3dea:	4505                	li	a0,1
    3dec:	00002097          	auipc	ra,0x2
    3df0:	ddc080e7          	jalr	-548(ra) # 5bc8 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3df4:	85ca                	mv	a1,s2
    3df6:	00004517          	auipc	a0,0x4
    3dfa:	b9250513          	addi	a0,a0,-1134 # 7988 <malloc+0x1982>
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	14a080e7          	jalr	330(ra) # 5f48 <printf>
    exit(1);
    3e06:	4505                	li	a0,1
    3e08:	00002097          	auipc	ra,0x2
    3e0c:	dc0080e7          	jalr	-576(ra) # 5bc8 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e10:	85ca                	mv	a1,s2
    3e12:	00004517          	auipc	a0,0x4
    3e16:	b9650513          	addi	a0,a0,-1130 # 79a8 <malloc+0x19a2>
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	12e080e7          	jalr	302(ra) # 5f48 <printf>
    exit(1);
    3e22:	4505                	li	a0,1
    3e24:	00002097          	auipc	ra,0x2
    3e28:	da4080e7          	jalr	-604(ra) # 5bc8 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e2c:	85ca                	mv	a1,s2
    3e2e:	00004517          	auipc	a0,0x4
    3e32:	baa50513          	addi	a0,a0,-1110 # 79d8 <malloc+0x19d2>
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	112080e7          	jalr	274(ra) # 5f48 <printf>
    exit(1);
    3e3e:	4505                	li	a0,1
    3e40:	00002097          	auipc	ra,0x2
    3e44:	d88080e7          	jalr	-632(ra) # 5bc8 <exit>
    printf("%s: unlink dd failed\n", s);
    3e48:	85ca                	mv	a1,s2
    3e4a:	00004517          	auipc	a0,0x4
    3e4e:	bae50513          	addi	a0,a0,-1106 # 79f8 <malloc+0x19f2>
    3e52:	00002097          	auipc	ra,0x2
    3e56:	0f6080e7          	jalr	246(ra) # 5f48 <printf>
    exit(1);
    3e5a:	4505                	li	a0,1
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	d6c080e7          	jalr	-660(ra) # 5bc8 <exit>

0000000000003e64 <rmdot>:
{
    3e64:	1101                	addi	sp,sp,-32
    3e66:	ec06                	sd	ra,24(sp)
    3e68:	e822                	sd	s0,16(sp)
    3e6a:	e426                	sd	s1,8(sp)
    3e6c:	1000                	addi	s0,sp,32
    3e6e:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e70:	00004517          	auipc	a0,0x4
    3e74:	ba050513          	addi	a0,a0,-1120 # 7a10 <malloc+0x1a0a>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	db8080e7          	jalr	-584(ra) # 5c30 <mkdir>
    3e80:	e549                	bnez	a0,3f0a <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e82:	00004517          	auipc	a0,0x4
    3e86:	b8e50513          	addi	a0,a0,-1138 # 7a10 <malloc+0x1a0a>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	dae080e7          	jalr	-594(ra) # 5c38 <chdir>
    3e92:	e951                	bnez	a0,3f26 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e94:	00003517          	auipc	a0,0x3
    3e98:	99c50513          	addi	a0,a0,-1636 # 6830 <malloc+0x82a>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	d7c080e7          	jalr	-644(ra) # 5c18 <unlink>
    3ea4:	cd59                	beqz	a0,3f42 <rmdot+0xde>
  if(unlink("..") == 0){
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	5c250513          	addi	a0,a0,1474 # 7468 <malloc+0x1462>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	d6a080e7          	jalr	-662(ra) # 5c18 <unlink>
    3eb6:	c545                	beqz	a0,3f5e <rmdot+0xfa>
  if(chdir("/") != 0){
    3eb8:	00003517          	auipc	a0,0x3
    3ebc:	55850513          	addi	a0,a0,1368 # 7410 <malloc+0x140a>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	d78080e7          	jalr	-648(ra) # 5c38 <chdir>
    3ec8:	e94d                	bnez	a0,3f7a <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3eca:	00004517          	auipc	a0,0x4
    3ece:	bae50513          	addi	a0,a0,-1106 # 7a78 <malloc+0x1a72>
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	d46080e7          	jalr	-698(ra) # 5c18 <unlink>
    3eda:	cd55                	beqz	a0,3f96 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3edc:	00004517          	auipc	a0,0x4
    3ee0:	bc450513          	addi	a0,a0,-1084 # 7aa0 <malloc+0x1a9a>
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	d34080e7          	jalr	-716(ra) # 5c18 <unlink>
    3eec:	c179                	beqz	a0,3fb2 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	b2250513          	addi	a0,a0,-1246 # 7a10 <malloc+0x1a0a>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	d22080e7          	jalr	-734(ra) # 5c18 <unlink>
    3efe:	e961                	bnez	a0,3fce <rmdot+0x16a>
}
    3f00:	60e2                	ld	ra,24(sp)
    3f02:	6442                	ld	s0,16(sp)
    3f04:	64a2                	ld	s1,8(sp)
    3f06:	6105                	addi	sp,sp,32
    3f08:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f0a:	85a6                	mv	a1,s1
    3f0c:	00004517          	auipc	a0,0x4
    3f10:	b0c50513          	addi	a0,a0,-1268 # 7a18 <malloc+0x1a12>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	034080e7          	jalr	52(ra) # 5f48 <printf>
    exit(1);
    3f1c:	4505                	li	a0,1
    3f1e:	00002097          	auipc	ra,0x2
    3f22:	caa080e7          	jalr	-854(ra) # 5bc8 <exit>
    printf("%s: chdir dots failed\n", s);
    3f26:	85a6                	mv	a1,s1
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	b0850513          	addi	a0,a0,-1272 # 7a30 <malloc+0x1a2a>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	018080e7          	jalr	24(ra) # 5f48 <printf>
    exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00002097          	auipc	ra,0x2
    3f3e:	c8e080e7          	jalr	-882(ra) # 5bc8 <exit>
    printf("%s: rm . worked!\n", s);
    3f42:	85a6                	mv	a1,s1
    3f44:	00004517          	auipc	a0,0x4
    3f48:	b0450513          	addi	a0,a0,-1276 # 7a48 <malloc+0x1a42>
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	ffc080e7          	jalr	-4(ra) # 5f48 <printf>
    exit(1);
    3f54:	4505                	li	a0,1
    3f56:	00002097          	auipc	ra,0x2
    3f5a:	c72080e7          	jalr	-910(ra) # 5bc8 <exit>
    printf("%s: rm .. worked!\n", s);
    3f5e:	85a6                	mv	a1,s1
    3f60:	00004517          	auipc	a0,0x4
    3f64:	b0050513          	addi	a0,a0,-1280 # 7a60 <malloc+0x1a5a>
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	fe0080e7          	jalr	-32(ra) # 5f48 <printf>
    exit(1);
    3f70:	4505                	li	a0,1
    3f72:	00002097          	auipc	ra,0x2
    3f76:	c56080e7          	jalr	-938(ra) # 5bc8 <exit>
    printf("%s: chdir / failed\n", s);
    3f7a:	85a6                	mv	a1,s1
    3f7c:	00003517          	auipc	a0,0x3
    3f80:	49c50513          	addi	a0,a0,1180 # 7418 <malloc+0x1412>
    3f84:	00002097          	auipc	ra,0x2
    3f88:	fc4080e7          	jalr	-60(ra) # 5f48 <printf>
    exit(1);
    3f8c:	4505                	li	a0,1
    3f8e:	00002097          	auipc	ra,0x2
    3f92:	c3a080e7          	jalr	-966(ra) # 5bc8 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f96:	85a6                	mv	a1,s1
    3f98:	00004517          	auipc	a0,0x4
    3f9c:	ae850513          	addi	a0,a0,-1304 # 7a80 <malloc+0x1a7a>
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	fa8080e7          	jalr	-88(ra) # 5f48 <printf>
    exit(1);
    3fa8:	4505                	li	a0,1
    3faa:	00002097          	auipc	ra,0x2
    3fae:	c1e080e7          	jalr	-994(ra) # 5bc8 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fb2:	85a6                	mv	a1,s1
    3fb4:	00004517          	auipc	a0,0x4
    3fb8:	af450513          	addi	a0,a0,-1292 # 7aa8 <malloc+0x1aa2>
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	f8c080e7          	jalr	-116(ra) # 5f48 <printf>
    exit(1);
    3fc4:	4505                	li	a0,1
    3fc6:	00002097          	auipc	ra,0x2
    3fca:	c02080e7          	jalr	-1022(ra) # 5bc8 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fce:	85a6                	mv	a1,s1
    3fd0:	00004517          	auipc	a0,0x4
    3fd4:	af850513          	addi	a0,a0,-1288 # 7ac8 <malloc+0x1ac2>
    3fd8:	00002097          	auipc	ra,0x2
    3fdc:	f70080e7          	jalr	-144(ra) # 5f48 <printf>
    exit(1);
    3fe0:	4505                	li	a0,1
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	be6080e7          	jalr	-1050(ra) # 5bc8 <exit>

0000000000003fea <dirfile>:
{
    3fea:	1101                	addi	sp,sp,-32
    3fec:	ec06                	sd	ra,24(sp)
    3fee:	e822                	sd	s0,16(sp)
    3ff0:	e426                	sd	s1,8(sp)
    3ff2:	e04a                	sd	s2,0(sp)
    3ff4:	1000                	addi	s0,sp,32
    3ff6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3ff8:	20000593          	li	a1,512
    3ffc:	00004517          	auipc	a0,0x4
    4000:	aec50513          	addi	a0,a0,-1300 # 7ae8 <malloc+0x1ae2>
    4004:	00002097          	auipc	ra,0x2
    4008:	c04080e7          	jalr	-1020(ra) # 5c08 <open>
  if(fd < 0){
    400c:	0e054d63          	bltz	a0,4106 <dirfile+0x11c>
  close(fd);
    4010:	00002097          	auipc	ra,0x2
    4014:	be0080e7          	jalr	-1056(ra) # 5bf0 <close>
  if(chdir("dirfile") == 0){
    4018:	00004517          	auipc	a0,0x4
    401c:	ad050513          	addi	a0,a0,-1328 # 7ae8 <malloc+0x1ae2>
    4020:	00002097          	auipc	ra,0x2
    4024:	c18080e7          	jalr	-1000(ra) # 5c38 <chdir>
    4028:	cd6d                	beqz	a0,4122 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    402a:	4581                	li	a1,0
    402c:	00004517          	auipc	a0,0x4
    4030:	b0450513          	addi	a0,a0,-1276 # 7b30 <malloc+0x1b2a>
    4034:	00002097          	auipc	ra,0x2
    4038:	bd4080e7          	jalr	-1068(ra) # 5c08 <open>
  if(fd >= 0){
    403c:	10055163          	bgez	a0,413e <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4040:	20000593          	li	a1,512
    4044:	00004517          	auipc	a0,0x4
    4048:	aec50513          	addi	a0,a0,-1300 # 7b30 <malloc+0x1b2a>
    404c:	00002097          	auipc	ra,0x2
    4050:	bbc080e7          	jalr	-1092(ra) # 5c08 <open>
  if(fd >= 0){
    4054:	10055363          	bgez	a0,415a <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4058:	00004517          	auipc	a0,0x4
    405c:	ad850513          	addi	a0,a0,-1320 # 7b30 <malloc+0x1b2a>
    4060:	00002097          	auipc	ra,0x2
    4064:	bd0080e7          	jalr	-1072(ra) # 5c30 <mkdir>
    4068:	10050763          	beqz	a0,4176 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    406c:	00004517          	auipc	a0,0x4
    4070:	ac450513          	addi	a0,a0,-1340 # 7b30 <malloc+0x1b2a>
    4074:	00002097          	auipc	ra,0x2
    4078:	ba4080e7          	jalr	-1116(ra) # 5c18 <unlink>
    407c:	10050b63          	beqz	a0,4192 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4080:	00004597          	auipc	a1,0x4
    4084:	ab058593          	addi	a1,a1,-1360 # 7b30 <malloc+0x1b2a>
    4088:	00002517          	auipc	a0,0x2
    408c:	29850513          	addi	a0,a0,664 # 6320 <malloc+0x31a>
    4090:	00002097          	auipc	ra,0x2
    4094:	b98080e7          	jalr	-1128(ra) # 5c28 <link>
    4098:	10050b63          	beqz	a0,41ae <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    409c:	00004517          	auipc	a0,0x4
    40a0:	a4c50513          	addi	a0,a0,-1460 # 7ae8 <malloc+0x1ae2>
    40a4:	00002097          	auipc	ra,0x2
    40a8:	b74080e7          	jalr	-1164(ra) # 5c18 <unlink>
    40ac:	10051f63          	bnez	a0,41ca <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40b0:	4589                	li	a1,2
    40b2:	00002517          	auipc	a0,0x2
    40b6:	77e50513          	addi	a0,a0,1918 # 6830 <malloc+0x82a>
    40ba:	00002097          	auipc	ra,0x2
    40be:	b4e080e7          	jalr	-1202(ra) # 5c08 <open>
  if(fd >= 0){
    40c2:	12055263          	bgez	a0,41e6 <dirfile+0x1fc>
  fd = open(".", 0);
    40c6:	4581                	li	a1,0
    40c8:	00002517          	auipc	a0,0x2
    40cc:	76850513          	addi	a0,a0,1896 # 6830 <malloc+0x82a>
    40d0:	00002097          	auipc	ra,0x2
    40d4:	b38080e7          	jalr	-1224(ra) # 5c08 <open>
    40d8:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40da:	4605                	li	a2,1
    40dc:	00002597          	auipc	a1,0x2
    40e0:	0dc58593          	addi	a1,a1,220 # 61b8 <malloc+0x1b2>
    40e4:	00002097          	auipc	ra,0x2
    40e8:	b04080e7          	jalr	-1276(ra) # 5be8 <write>
    40ec:	10a04b63          	bgtz	a0,4202 <dirfile+0x218>
  close(fd);
    40f0:	8526                	mv	a0,s1
    40f2:	00002097          	auipc	ra,0x2
    40f6:	afe080e7          	jalr	-1282(ra) # 5bf0 <close>
}
    40fa:	60e2                	ld	ra,24(sp)
    40fc:	6442                	ld	s0,16(sp)
    40fe:	64a2                	ld	s1,8(sp)
    4100:	6902                	ld	s2,0(sp)
    4102:	6105                	addi	sp,sp,32
    4104:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4106:	85ca                	mv	a1,s2
    4108:	00004517          	auipc	a0,0x4
    410c:	9e850513          	addi	a0,a0,-1560 # 7af0 <malloc+0x1aea>
    4110:	00002097          	auipc	ra,0x2
    4114:	e38080e7          	jalr	-456(ra) # 5f48 <printf>
    exit(1);
    4118:	4505                	li	a0,1
    411a:	00002097          	auipc	ra,0x2
    411e:	aae080e7          	jalr	-1362(ra) # 5bc8 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4122:	85ca                	mv	a1,s2
    4124:	00004517          	auipc	a0,0x4
    4128:	9ec50513          	addi	a0,a0,-1556 # 7b10 <malloc+0x1b0a>
    412c:	00002097          	auipc	ra,0x2
    4130:	e1c080e7          	jalr	-484(ra) # 5f48 <printf>
    exit(1);
    4134:	4505                	li	a0,1
    4136:	00002097          	auipc	ra,0x2
    413a:	a92080e7          	jalr	-1390(ra) # 5bc8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    413e:	85ca                	mv	a1,s2
    4140:	00004517          	auipc	a0,0x4
    4144:	a0050513          	addi	a0,a0,-1536 # 7b40 <malloc+0x1b3a>
    4148:	00002097          	auipc	ra,0x2
    414c:	e00080e7          	jalr	-512(ra) # 5f48 <printf>
    exit(1);
    4150:	4505                	li	a0,1
    4152:	00002097          	auipc	ra,0x2
    4156:	a76080e7          	jalr	-1418(ra) # 5bc8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    415a:	85ca                	mv	a1,s2
    415c:	00004517          	auipc	a0,0x4
    4160:	9e450513          	addi	a0,a0,-1564 # 7b40 <malloc+0x1b3a>
    4164:	00002097          	auipc	ra,0x2
    4168:	de4080e7          	jalr	-540(ra) # 5f48 <printf>
    exit(1);
    416c:	4505                	li	a0,1
    416e:	00002097          	auipc	ra,0x2
    4172:	a5a080e7          	jalr	-1446(ra) # 5bc8 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4176:	85ca                	mv	a1,s2
    4178:	00004517          	auipc	a0,0x4
    417c:	9f050513          	addi	a0,a0,-1552 # 7b68 <malloc+0x1b62>
    4180:	00002097          	auipc	ra,0x2
    4184:	dc8080e7          	jalr	-568(ra) # 5f48 <printf>
    exit(1);
    4188:	4505                	li	a0,1
    418a:	00002097          	auipc	ra,0x2
    418e:	a3e080e7          	jalr	-1474(ra) # 5bc8 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4192:	85ca                	mv	a1,s2
    4194:	00004517          	auipc	a0,0x4
    4198:	9fc50513          	addi	a0,a0,-1540 # 7b90 <malloc+0x1b8a>
    419c:	00002097          	auipc	ra,0x2
    41a0:	dac080e7          	jalr	-596(ra) # 5f48 <printf>
    exit(1);
    41a4:	4505                	li	a0,1
    41a6:	00002097          	auipc	ra,0x2
    41aa:	a22080e7          	jalr	-1502(ra) # 5bc8 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41ae:	85ca                	mv	a1,s2
    41b0:	00004517          	auipc	a0,0x4
    41b4:	a0850513          	addi	a0,a0,-1528 # 7bb8 <malloc+0x1bb2>
    41b8:	00002097          	auipc	ra,0x2
    41bc:	d90080e7          	jalr	-624(ra) # 5f48 <printf>
    exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00002097          	auipc	ra,0x2
    41c6:	a06080e7          	jalr	-1530(ra) # 5bc8 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41ca:	85ca                	mv	a1,s2
    41cc:	00004517          	auipc	a0,0x4
    41d0:	a1450513          	addi	a0,a0,-1516 # 7be0 <malloc+0x1bda>
    41d4:	00002097          	auipc	ra,0x2
    41d8:	d74080e7          	jalr	-652(ra) # 5f48 <printf>
    exit(1);
    41dc:	4505                	li	a0,1
    41de:	00002097          	auipc	ra,0x2
    41e2:	9ea080e7          	jalr	-1558(ra) # 5bc8 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41e6:	85ca                	mv	a1,s2
    41e8:	00004517          	auipc	a0,0x4
    41ec:	a1850513          	addi	a0,a0,-1512 # 7c00 <malloc+0x1bfa>
    41f0:	00002097          	auipc	ra,0x2
    41f4:	d58080e7          	jalr	-680(ra) # 5f48 <printf>
    exit(1);
    41f8:	4505                	li	a0,1
    41fa:	00002097          	auipc	ra,0x2
    41fe:	9ce080e7          	jalr	-1586(ra) # 5bc8 <exit>
    printf("%s: write . succeeded!\n", s);
    4202:	85ca                	mv	a1,s2
    4204:	00004517          	auipc	a0,0x4
    4208:	a2450513          	addi	a0,a0,-1500 # 7c28 <malloc+0x1c22>
    420c:	00002097          	auipc	ra,0x2
    4210:	d3c080e7          	jalr	-708(ra) # 5f48 <printf>
    exit(1);
    4214:	4505                	li	a0,1
    4216:	00002097          	auipc	ra,0x2
    421a:	9b2080e7          	jalr	-1614(ra) # 5bc8 <exit>

000000000000421e <iref>:
{
    421e:	7139                	addi	sp,sp,-64
    4220:	fc06                	sd	ra,56(sp)
    4222:	f822                	sd	s0,48(sp)
    4224:	f426                	sd	s1,40(sp)
    4226:	f04a                	sd	s2,32(sp)
    4228:	ec4e                	sd	s3,24(sp)
    422a:	e852                	sd	s4,16(sp)
    422c:	e456                	sd	s5,8(sp)
    422e:	e05a                	sd	s6,0(sp)
    4230:	0080                	addi	s0,sp,64
    4232:	8b2a                	mv	s6,a0
    4234:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4238:	00004a17          	auipc	s4,0x4
    423c:	a08a0a13          	addi	s4,s4,-1528 # 7c40 <malloc+0x1c3a>
    mkdir("");
    4240:	00003497          	auipc	s1,0x3
    4244:	50848493          	addi	s1,s1,1288 # 7748 <malloc+0x1742>
    link("README", "");
    4248:	00002a97          	auipc	s5,0x2
    424c:	0d8a8a93          	addi	s5,s5,216 # 6320 <malloc+0x31a>
    fd = open("xx", O_CREATE);
    4250:	00004997          	auipc	s3,0x4
    4254:	8e898993          	addi	s3,s3,-1816 # 7b38 <malloc+0x1b32>
    4258:	a891                	j	42ac <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    425a:	85da                	mv	a1,s6
    425c:	00004517          	auipc	a0,0x4
    4260:	9ec50513          	addi	a0,a0,-1556 # 7c48 <malloc+0x1c42>
    4264:	00002097          	auipc	ra,0x2
    4268:	ce4080e7          	jalr	-796(ra) # 5f48 <printf>
      exit(1);
    426c:	4505                	li	a0,1
    426e:	00002097          	auipc	ra,0x2
    4272:	95a080e7          	jalr	-1702(ra) # 5bc8 <exit>
      printf("%s: chdir irefd failed\n", s);
    4276:	85da                	mv	a1,s6
    4278:	00004517          	auipc	a0,0x4
    427c:	9e850513          	addi	a0,a0,-1560 # 7c60 <malloc+0x1c5a>
    4280:	00002097          	auipc	ra,0x2
    4284:	cc8080e7          	jalr	-824(ra) # 5f48 <printf>
      exit(1);
    4288:	4505                	li	a0,1
    428a:	00002097          	auipc	ra,0x2
    428e:	93e080e7          	jalr	-1730(ra) # 5bc8 <exit>
      close(fd);
    4292:	00002097          	auipc	ra,0x2
    4296:	95e080e7          	jalr	-1698(ra) # 5bf0 <close>
    429a:	a889                	j	42ec <iref+0xce>
    unlink("xx");
    429c:	854e                	mv	a0,s3
    429e:	00002097          	auipc	ra,0x2
    42a2:	97a080e7          	jalr	-1670(ra) # 5c18 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42a6:	397d                	addiw	s2,s2,-1
    42a8:	06090063          	beqz	s2,4308 <iref+0xea>
    if(mkdir("irefd") != 0){
    42ac:	8552                	mv	a0,s4
    42ae:	00002097          	auipc	ra,0x2
    42b2:	982080e7          	jalr	-1662(ra) # 5c30 <mkdir>
    42b6:	f155                	bnez	a0,425a <iref+0x3c>
    if(chdir("irefd") != 0){
    42b8:	8552                	mv	a0,s4
    42ba:	00002097          	auipc	ra,0x2
    42be:	97e080e7          	jalr	-1666(ra) # 5c38 <chdir>
    42c2:	f955                	bnez	a0,4276 <iref+0x58>
    mkdir("");
    42c4:	8526                	mv	a0,s1
    42c6:	00002097          	auipc	ra,0x2
    42ca:	96a080e7          	jalr	-1686(ra) # 5c30 <mkdir>
    link("README", "");
    42ce:	85a6                	mv	a1,s1
    42d0:	8556                	mv	a0,s5
    42d2:	00002097          	auipc	ra,0x2
    42d6:	956080e7          	jalr	-1706(ra) # 5c28 <link>
    fd = open("", O_CREATE);
    42da:	20000593          	li	a1,512
    42de:	8526                	mv	a0,s1
    42e0:	00002097          	auipc	ra,0x2
    42e4:	928080e7          	jalr	-1752(ra) # 5c08 <open>
    if(fd >= 0)
    42e8:	fa0555e3          	bgez	a0,4292 <iref+0x74>
    fd = open("xx", O_CREATE);
    42ec:	20000593          	li	a1,512
    42f0:	854e                	mv	a0,s3
    42f2:	00002097          	auipc	ra,0x2
    42f6:	916080e7          	jalr	-1770(ra) # 5c08 <open>
    if(fd >= 0)
    42fa:	fa0541e3          	bltz	a0,429c <iref+0x7e>
      close(fd);
    42fe:	00002097          	auipc	ra,0x2
    4302:	8f2080e7          	jalr	-1806(ra) # 5bf0 <close>
    4306:	bf59                	j	429c <iref+0x7e>
    4308:	03300493          	li	s1,51
    chdir("..");
    430c:	00003997          	auipc	s3,0x3
    4310:	15c98993          	addi	s3,s3,348 # 7468 <malloc+0x1462>
    unlink("irefd");
    4314:	00004917          	auipc	s2,0x4
    4318:	92c90913          	addi	s2,s2,-1748 # 7c40 <malloc+0x1c3a>
    chdir("..");
    431c:	854e                	mv	a0,s3
    431e:	00002097          	auipc	ra,0x2
    4322:	91a080e7          	jalr	-1766(ra) # 5c38 <chdir>
    unlink("irefd");
    4326:	854a                	mv	a0,s2
    4328:	00002097          	auipc	ra,0x2
    432c:	8f0080e7          	jalr	-1808(ra) # 5c18 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4330:	34fd                	addiw	s1,s1,-1
    4332:	f4ed                	bnez	s1,431c <iref+0xfe>
  chdir("/");
    4334:	00003517          	auipc	a0,0x3
    4338:	0dc50513          	addi	a0,a0,220 # 7410 <malloc+0x140a>
    433c:	00002097          	auipc	ra,0x2
    4340:	8fc080e7          	jalr	-1796(ra) # 5c38 <chdir>
}
    4344:	70e2                	ld	ra,56(sp)
    4346:	7442                	ld	s0,48(sp)
    4348:	74a2                	ld	s1,40(sp)
    434a:	7902                	ld	s2,32(sp)
    434c:	69e2                	ld	s3,24(sp)
    434e:	6a42                	ld	s4,16(sp)
    4350:	6aa2                	ld	s5,8(sp)
    4352:	6b02                	ld	s6,0(sp)
    4354:	6121                	addi	sp,sp,64
    4356:	8082                	ret

0000000000004358 <openiputtest>:
{
    4358:	7179                	addi	sp,sp,-48
    435a:	f406                	sd	ra,40(sp)
    435c:	f022                	sd	s0,32(sp)
    435e:	ec26                	sd	s1,24(sp)
    4360:	1800                	addi	s0,sp,48
    4362:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4364:	00004517          	auipc	a0,0x4
    4368:	91450513          	addi	a0,a0,-1772 # 7c78 <malloc+0x1c72>
    436c:	00002097          	auipc	ra,0x2
    4370:	8c4080e7          	jalr	-1852(ra) # 5c30 <mkdir>
    4374:	04054263          	bltz	a0,43b8 <openiputtest+0x60>
  pid = fork();
    4378:	00002097          	auipc	ra,0x2
    437c:	848080e7          	jalr	-1976(ra) # 5bc0 <fork>
  if(pid < 0){
    4380:	04054a63          	bltz	a0,43d4 <openiputtest+0x7c>
  if(pid == 0){
    4384:	e93d                	bnez	a0,43fa <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4386:	4589                	li	a1,2
    4388:	00004517          	auipc	a0,0x4
    438c:	8f050513          	addi	a0,a0,-1808 # 7c78 <malloc+0x1c72>
    4390:	00002097          	auipc	ra,0x2
    4394:	878080e7          	jalr	-1928(ra) # 5c08 <open>
    if(fd >= 0){
    4398:	04054c63          	bltz	a0,43f0 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    439c:	85a6                	mv	a1,s1
    439e:	00004517          	auipc	a0,0x4
    43a2:	8fa50513          	addi	a0,a0,-1798 # 7c98 <malloc+0x1c92>
    43a6:	00002097          	auipc	ra,0x2
    43aa:	ba2080e7          	jalr	-1118(ra) # 5f48 <printf>
      exit(1);
    43ae:	4505                	li	a0,1
    43b0:	00002097          	auipc	ra,0x2
    43b4:	818080e7          	jalr	-2024(ra) # 5bc8 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43b8:	85a6                	mv	a1,s1
    43ba:	00004517          	auipc	a0,0x4
    43be:	8c650513          	addi	a0,a0,-1850 # 7c80 <malloc+0x1c7a>
    43c2:	00002097          	auipc	ra,0x2
    43c6:	b86080e7          	jalr	-1146(ra) # 5f48 <printf>
    exit(1);
    43ca:	4505                	li	a0,1
    43cc:	00001097          	auipc	ra,0x1
    43d0:	7fc080e7          	jalr	2044(ra) # 5bc8 <exit>
    printf("%s: fork failed\n", s);
    43d4:	85a6                	mv	a1,s1
    43d6:	00002517          	auipc	a0,0x2
    43da:	5fa50513          	addi	a0,a0,1530 # 69d0 <malloc+0x9ca>
    43de:	00002097          	auipc	ra,0x2
    43e2:	b6a080e7          	jalr	-1174(ra) # 5f48 <printf>
    exit(1);
    43e6:	4505                	li	a0,1
    43e8:	00001097          	auipc	ra,0x1
    43ec:	7e0080e7          	jalr	2016(ra) # 5bc8 <exit>
    exit(0);
    43f0:	4501                	li	a0,0
    43f2:	00001097          	auipc	ra,0x1
    43f6:	7d6080e7          	jalr	2006(ra) # 5bc8 <exit>
  sleep(1);
    43fa:	4505                	li	a0,1
    43fc:	00002097          	auipc	ra,0x2
    4400:	85c080e7          	jalr	-1956(ra) # 5c58 <sleep>
  if(unlink("oidir") != 0){
    4404:	00004517          	auipc	a0,0x4
    4408:	87450513          	addi	a0,a0,-1932 # 7c78 <malloc+0x1c72>
    440c:	00002097          	auipc	ra,0x2
    4410:	80c080e7          	jalr	-2036(ra) # 5c18 <unlink>
    4414:	cd19                	beqz	a0,4432 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4416:	85a6                	mv	a1,s1
    4418:	00002517          	auipc	a0,0x2
    441c:	7a850513          	addi	a0,a0,1960 # 6bc0 <malloc+0xbba>
    4420:	00002097          	auipc	ra,0x2
    4424:	b28080e7          	jalr	-1240(ra) # 5f48 <printf>
    exit(1);
    4428:	4505                	li	a0,1
    442a:	00001097          	auipc	ra,0x1
    442e:	79e080e7          	jalr	1950(ra) # 5bc8 <exit>
  wait(&xstatus);
    4432:	fdc40513          	addi	a0,s0,-36
    4436:	00001097          	auipc	ra,0x1
    443a:	79a080e7          	jalr	1946(ra) # 5bd0 <wait>
  exit(xstatus);
    443e:	fdc42503          	lw	a0,-36(s0)
    4442:	00001097          	auipc	ra,0x1
    4446:	786080e7          	jalr	1926(ra) # 5bc8 <exit>

000000000000444a <forkforkfork>:
{
    444a:	1101                	addi	sp,sp,-32
    444c:	ec06                	sd	ra,24(sp)
    444e:	e822                	sd	s0,16(sp)
    4450:	e426                	sd	s1,8(sp)
    4452:	1000                	addi	s0,sp,32
    4454:	84aa                	mv	s1,a0
  unlink("stopforking");
    4456:	00004517          	auipc	a0,0x4
    445a:	86a50513          	addi	a0,a0,-1942 # 7cc0 <malloc+0x1cba>
    445e:	00001097          	auipc	ra,0x1
    4462:	7ba080e7          	jalr	1978(ra) # 5c18 <unlink>
  int pid = fork();
    4466:	00001097          	auipc	ra,0x1
    446a:	75a080e7          	jalr	1882(ra) # 5bc0 <fork>
  if(pid < 0){
    446e:	04054563          	bltz	a0,44b8 <forkforkfork+0x6e>
  if(pid == 0){
    4472:	c12d                	beqz	a0,44d4 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4474:	4551                	li	a0,20
    4476:	00001097          	auipc	ra,0x1
    447a:	7e2080e7          	jalr	2018(ra) # 5c58 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    447e:	20200593          	li	a1,514
    4482:	00004517          	auipc	a0,0x4
    4486:	83e50513          	addi	a0,a0,-1986 # 7cc0 <malloc+0x1cba>
    448a:	00001097          	auipc	ra,0x1
    448e:	77e080e7          	jalr	1918(ra) # 5c08 <open>
    4492:	00001097          	auipc	ra,0x1
    4496:	75e080e7          	jalr	1886(ra) # 5bf0 <close>
  wait(0);
    449a:	4501                	li	a0,0
    449c:	00001097          	auipc	ra,0x1
    44a0:	734080e7          	jalr	1844(ra) # 5bd0 <wait>
  sleep(10); // one second
    44a4:	4529                	li	a0,10
    44a6:	00001097          	auipc	ra,0x1
    44aa:	7b2080e7          	jalr	1970(ra) # 5c58 <sleep>
}
    44ae:	60e2                	ld	ra,24(sp)
    44b0:	6442                	ld	s0,16(sp)
    44b2:	64a2                	ld	s1,8(sp)
    44b4:	6105                	addi	sp,sp,32
    44b6:	8082                	ret
    printf("%s: fork failed", s);
    44b8:	85a6                	mv	a1,s1
    44ba:	00002517          	auipc	a0,0x2
    44be:	6d650513          	addi	a0,a0,1750 # 6b90 <malloc+0xb8a>
    44c2:	00002097          	auipc	ra,0x2
    44c6:	a86080e7          	jalr	-1402(ra) # 5f48 <printf>
    exit(1);
    44ca:	4505                	li	a0,1
    44cc:	00001097          	auipc	ra,0x1
    44d0:	6fc080e7          	jalr	1788(ra) # 5bc8 <exit>
      int fd = open("stopforking", 0);
    44d4:	00003497          	auipc	s1,0x3
    44d8:	7ec48493          	addi	s1,s1,2028 # 7cc0 <malloc+0x1cba>
    44dc:	4581                	li	a1,0
    44de:	8526                	mv	a0,s1
    44e0:	00001097          	auipc	ra,0x1
    44e4:	728080e7          	jalr	1832(ra) # 5c08 <open>
      if(fd >= 0){
    44e8:	02055463          	bgez	a0,4510 <forkforkfork+0xc6>
      if(fork() < 0){
    44ec:	00001097          	auipc	ra,0x1
    44f0:	6d4080e7          	jalr	1748(ra) # 5bc0 <fork>
    44f4:	fe0554e3          	bgez	a0,44dc <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44f8:	20200593          	li	a1,514
    44fc:	8526                	mv	a0,s1
    44fe:	00001097          	auipc	ra,0x1
    4502:	70a080e7          	jalr	1802(ra) # 5c08 <open>
    4506:	00001097          	auipc	ra,0x1
    450a:	6ea080e7          	jalr	1770(ra) # 5bf0 <close>
    450e:	b7f9                	j	44dc <forkforkfork+0x92>
        exit(0);
    4510:	4501                	li	a0,0
    4512:	00001097          	auipc	ra,0x1
    4516:	6b6080e7          	jalr	1718(ra) # 5bc8 <exit>

000000000000451a <killstatus>:
{
    451a:	7139                	addi	sp,sp,-64
    451c:	fc06                	sd	ra,56(sp)
    451e:	f822                	sd	s0,48(sp)
    4520:	f426                	sd	s1,40(sp)
    4522:	f04a                	sd	s2,32(sp)
    4524:	ec4e                	sd	s3,24(sp)
    4526:	e852                	sd	s4,16(sp)
    4528:	0080                	addi	s0,sp,64
    452a:	8a2a                	mv	s4,a0
    452c:	06400913          	li	s2,100
    if(xst != -1) {
    4530:	59fd                	li	s3,-1
    int pid1 = fork();
    4532:	00001097          	auipc	ra,0x1
    4536:	68e080e7          	jalr	1678(ra) # 5bc0 <fork>
    453a:	84aa                	mv	s1,a0
    if(pid1 < 0){
    453c:	02054f63          	bltz	a0,457a <killstatus+0x60>
    if(pid1 == 0){
    4540:	c939                	beqz	a0,4596 <killstatus+0x7c>
    sleep(1);
    4542:	4505                	li	a0,1
    4544:	00001097          	auipc	ra,0x1
    4548:	714080e7          	jalr	1812(ra) # 5c58 <sleep>
    kill(pid1);
    454c:	8526                	mv	a0,s1
    454e:	00001097          	auipc	ra,0x1
    4552:	6aa080e7          	jalr	1706(ra) # 5bf8 <kill>
    wait(&xst);
    4556:	fcc40513          	addi	a0,s0,-52
    455a:	00001097          	auipc	ra,0x1
    455e:	676080e7          	jalr	1654(ra) # 5bd0 <wait>
    if(xst != -1) {
    4562:	fcc42783          	lw	a5,-52(s0)
    4566:	03379d63          	bne	a5,s3,45a0 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    456a:	397d                	addiw	s2,s2,-1
    456c:	fc0913e3          	bnez	s2,4532 <killstatus+0x18>
  exit(0);
    4570:	4501                	li	a0,0
    4572:	00001097          	auipc	ra,0x1
    4576:	656080e7          	jalr	1622(ra) # 5bc8 <exit>
      printf("%s: fork failed\n", s);
    457a:	85d2                	mv	a1,s4
    457c:	00002517          	auipc	a0,0x2
    4580:	45450513          	addi	a0,a0,1108 # 69d0 <malloc+0x9ca>
    4584:	00002097          	auipc	ra,0x2
    4588:	9c4080e7          	jalr	-1596(ra) # 5f48 <printf>
      exit(1);
    458c:	4505                	li	a0,1
    458e:	00001097          	auipc	ra,0x1
    4592:	63a080e7          	jalr	1594(ra) # 5bc8 <exit>
        getpid();
    4596:	00001097          	auipc	ra,0x1
    459a:	6b2080e7          	jalr	1714(ra) # 5c48 <getpid>
      while(1) {
    459e:	bfe5                	j	4596 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45a0:	85d2                	mv	a1,s4
    45a2:	00003517          	auipc	a0,0x3
    45a6:	72e50513          	addi	a0,a0,1838 # 7cd0 <malloc+0x1cca>
    45aa:	00002097          	auipc	ra,0x2
    45ae:	99e080e7          	jalr	-1634(ra) # 5f48 <printf>
       exit(1);
    45b2:	4505                	li	a0,1
    45b4:	00001097          	auipc	ra,0x1
    45b8:	614080e7          	jalr	1556(ra) # 5bc8 <exit>

00000000000045bc <preempt>:
{
    45bc:	7139                	addi	sp,sp,-64
    45be:	fc06                	sd	ra,56(sp)
    45c0:	f822                	sd	s0,48(sp)
    45c2:	f426                	sd	s1,40(sp)
    45c4:	f04a                	sd	s2,32(sp)
    45c6:	ec4e                	sd	s3,24(sp)
    45c8:	e852                	sd	s4,16(sp)
    45ca:	0080                	addi	s0,sp,64
    45cc:	892a                	mv	s2,a0
  pid1 = fork();
    45ce:	00001097          	auipc	ra,0x1
    45d2:	5f2080e7          	jalr	1522(ra) # 5bc0 <fork>
  if(pid1 < 0) {
    45d6:	00054563          	bltz	a0,45e0 <preempt+0x24>
    45da:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45dc:	e105                	bnez	a0,45fc <preempt+0x40>
    for(;;)
    45de:	a001                	j	45de <preempt+0x22>
    printf("%s: fork failed", s);
    45e0:	85ca                	mv	a1,s2
    45e2:	00002517          	auipc	a0,0x2
    45e6:	5ae50513          	addi	a0,a0,1454 # 6b90 <malloc+0xb8a>
    45ea:	00002097          	auipc	ra,0x2
    45ee:	95e080e7          	jalr	-1698(ra) # 5f48 <printf>
    exit(1);
    45f2:	4505                	li	a0,1
    45f4:	00001097          	auipc	ra,0x1
    45f8:	5d4080e7          	jalr	1492(ra) # 5bc8 <exit>
  pid2 = fork();
    45fc:	00001097          	auipc	ra,0x1
    4600:	5c4080e7          	jalr	1476(ra) # 5bc0 <fork>
    4604:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4606:	00054463          	bltz	a0,460e <preempt+0x52>
  if(pid2 == 0)
    460a:	e105                	bnez	a0,462a <preempt+0x6e>
    for(;;)
    460c:	a001                	j	460c <preempt+0x50>
    printf("%s: fork failed\n", s);
    460e:	85ca                	mv	a1,s2
    4610:	00002517          	auipc	a0,0x2
    4614:	3c050513          	addi	a0,a0,960 # 69d0 <malloc+0x9ca>
    4618:	00002097          	auipc	ra,0x2
    461c:	930080e7          	jalr	-1744(ra) # 5f48 <printf>
    exit(1);
    4620:	4505                	li	a0,1
    4622:	00001097          	auipc	ra,0x1
    4626:	5a6080e7          	jalr	1446(ra) # 5bc8 <exit>
  pipe(pfds);
    462a:	fc840513          	addi	a0,s0,-56
    462e:	00001097          	auipc	ra,0x1
    4632:	5aa080e7          	jalr	1450(ra) # 5bd8 <pipe>
  pid3 = fork();
    4636:	00001097          	auipc	ra,0x1
    463a:	58a080e7          	jalr	1418(ra) # 5bc0 <fork>
    463e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4640:	02054e63          	bltz	a0,467c <preempt+0xc0>
  if(pid3 == 0){
    4644:	e525                	bnez	a0,46ac <preempt+0xf0>
    close(pfds[0]);
    4646:	fc842503          	lw	a0,-56(s0)
    464a:	00001097          	auipc	ra,0x1
    464e:	5a6080e7          	jalr	1446(ra) # 5bf0 <close>
    if(write(pfds[1], "x", 1) != 1)
    4652:	4605                	li	a2,1
    4654:	00002597          	auipc	a1,0x2
    4658:	b6458593          	addi	a1,a1,-1180 # 61b8 <malloc+0x1b2>
    465c:	fcc42503          	lw	a0,-52(s0)
    4660:	00001097          	auipc	ra,0x1
    4664:	588080e7          	jalr	1416(ra) # 5be8 <write>
    4668:	4785                	li	a5,1
    466a:	02f51763          	bne	a0,a5,4698 <preempt+0xdc>
    close(pfds[1]);
    466e:	fcc42503          	lw	a0,-52(s0)
    4672:	00001097          	auipc	ra,0x1
    4676:	57e080e7          	jalr	1406(ra) # 5bf0 <close>
    for(;;)
    467a:	a001                	j	467a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    467c:	85ca                	mv	a1,s2
    467e:	00002517          	auipc	a0,0x2
    4682:	35250513          	addi	a0,a0,850 # 69d0 <malloc+0x9ca>
    4686:	00002097          	auipc	ra,0x2
    468a:	8c2080e7          	jalr	-1854(ra) # 5f48 <printf>
     exit(1);
    468e:	4505                	li	a0,1
    4690:	00001097          	auipc	ra,0x1
    4694:	538080e7          	jalr	1336(ra) # 5bc8 <exit>
      printf("%s: preempt write error", s);
    4698:	85ca                	mv	a1,s2
    469a:	00003517          	auipc	a0,0x3
    469e:	65650513          	addi	a0,a0,1622 # 7cf0 <malloc+0x1cea>
    46a2:	00002097          	auipc	ra,0x2
    46a6:	8a6080e7          	jalr	-1882(ra) # 5f48 <printf>
    46aa:	b7d1                	j	466e <preempt+0xb2>
  close(pfds[1]);
    46ac:	fcc42503          	lw	a0,-52(s0)
    46b0:	00001097          	auipc	ra,0x1
    46b4:	540080e7          	jalr	1344(ra) # 5bf0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46b8:	660d                	lui	a2,0x3
    46ba:	00008597          	auipc	a1,0x8
    46be:	5be58593          	addi	a1,a1,1470 # cc78 <buf>
    46c2:	fc842503          	lw	a0,-56(s0)
    46c6:	00001097          	auipc	ra,0x1
    46ca:	51a080e7          	jalr	1306(ra) # 5be0 <read>
    46ce:	4785                	li	a5,1
    46d0:	02f50363          	beq	a0,a5,46f6 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46d4:	85ca                	mv	a1,s2
    46d6:	00003517          	auipc	a0,0x3
    46da:	63250513          	addi	a0,a0,1586 # 7d08 <malloc+0x1d02>
    46de:	00002097          	auipc	ra,0x2
    46e2:	86a080e7          	jalr	-1942(ra) # 5f48 <printf>
}
    46e6:	70e2                	ld	ra,56(sp)
    46e8:	7442                	ld	s0,48(sp)
    46ea:	74a2                	ld	s1,40(sp)
    46ec:	7902                	ld	s2,32(sp)
    46ee:	69e2                	ld	s3,24(sp)
    46f0:	6a42                	ld	s4,16(sp)
    46f2:	6121                	addi	sp,sp,64
    46f4:	8082                	ret
  close(pfds[0]);
    46f6:	fc842503          	lw	a0,-56(s0)
    46fa:	00001097          	auipc	ra,0x1
    46fe:	4f6080e7          	jalr	1270(ra) # 5bf0 <close>
  printf("kill... ");
    4702:	00003517          	auipc	a0,0x3
    4706:	61e50513          	addi	a0,a0,1566 # 7d20 <malloc+0x1d1a>
    470a:	00002097          	auipc	ra,0x2
    470e:	83e080e7          	jalr	-1986(ra) # 5f48 <printf>
  kill(pid1);
    4712:	8526                	mv	a0,s1
    4714:	00001097          	auipc	ra,0x1
    4718:	4e4080e7          	jalr	1252(ra) # 5bf8 <kill>
  kill(pid2);
    471c:	854e                	mv	a0,s3
    471e:	00001097          	auipc	ra,0x1
    4722:	4da080e7          	jalr	1242(ra) # 5bf8 <kill>
  kill(pid3);
    4726:	8552                	mv	a0,s4
    4728:	00001097          	auipc	ra,0x1
    472c:	4d0080e7          	jalr	1232(ra) # 5bf8 <kill>
  printf("wait... ");
    4730:	00003517          	auipc	a0,0x3
    4734:	60050513          	addi	a0,a0,1536 # 7d30 <malloc+0x1d2a>
    4738:	00002097          	auipc	ra,0x2
    473c:	810080e7          	jalr	-2032(ra) # 5f48 <printf>
  wait(0);
    4740:	4501                	li	a0,0
    4742:	00001097          	auipc	ra,0x1
    4746:	48e080e7          	jalr	1166(ra) # 5bd0 <wait>
  wait(0);
    474a:	4501                	li	a0,0
    474c:	00001097          	auipc	ra,0x1
    4750:	484080e7          	jalr	1156(ra) # 5bd0 <wait>
  wait(0);
    4754:	4501                	li	a0,0
    4756:	00001097          	auipc	ra,0x1
    475a:	47a080e7          	jalr	1146(ra) # 5bd0 <wait>
    475e:	b761                	j	46e6 <preempt+0x12a>

0000000000004760 <reparent>:
{
    4760:	7179                	addi	sp,sp,-48
    4762:	f406                	sd	ra,40(sp)
    4764:	f022                	sd	s0,32(sp)
    4766:	ec26                	sd	s1,24(sp)
    4768:	e84a                	sd	s2,16(sp)
    476a:	e44e                	sd	s3,8(sp)
    476c:	e052                	sd	s4,0(sp)
    476e:	1800                	addi	s0,sp,48
    4770:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4772:	00001097          	auipc	ra,0x1
    4776:	4d6080e7          	jalr	1238(ra) # 5c48 <getpid>
    477a:	8a2a                	mv	s4,a0
    477c:	0c800913          	li	s2,200
    int pid = fork();
    4780:	00001097          	auipc	ra,0x1
    4784:	440080e7          	jalr	1088(ra) # 5bc0 <fork>
    4788:	84aa                	mv	s1,a0
    if(pid < 0){
    478a:	02054263          	bltz	a0,47ae <reparent+0x4e>
    if(pid){
    478e:	cd21                	beqz	a0,47e6 <reparent+0x86>
      if(wait(0) != pid){
    4790:	4501                	li	a0,0
    4792:	00001097          	auipc	ra,0x1
    4796:	43e080e7          	jalr	1086(ra) # 5bd0 <wait>
    479a:	02951863          	bne	a0,s1,47ca <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    479e:	397d                	addiw	s2,s2,-1
    47a0:	fe0910e3          	bnez	s2,4780 <reparent+0x20>
  exit(0);
    47a4:	4501                	li	a0,0
    47a6:	00001097          	auipc	ra,0x1
    47aa:	422080e7          	jalr	1058(ra) # 5bc8 <exit>
      printf("%s: fork failed\n", s);
    47ae:	85ce                	mv	a1,s3
    47b0:	00002517          	auipc	a0,0x2
    47b4:	22050513          	addi	a0,a0,544 # 69d0 <malloc+0x9ca>
    47b8:	00001097          	auipc	ra,0x1
    47bc:	790080e7          	jalr	1936(ra) # 5f48 <printf>
      exit(1);
    47c0:	4505                	li	a0,1
    47c2:	00001097          	auipc	ra,0x1
    47c6:	406080e7          	jalr	1030(ra) # 5bc8 <exit>
        printf("%s: wait wrong pid\n", s);
    47ca:	85ce                	mv	a1,s3
    47cc:	00002517          	auipc	a0,0x2
    47d0:	38c50513          	addi	a0,a0,908 # 6b58 <malloc+0xb52>
    47d4:	00001097          	auipc	ra,0x1
    47d8:	774080e7          	jalr	1908(ra) # 5f48 <printf>
        exit(1);
    47dc:	4505                	li	a0,1
    47de:	00001097          	auipc	ra,0x1
    47e2:	3ea080e7          	jalr	1002(ra) # 5bc8 <exit>
      int pid2 = fork();
    47e6:	00001097          	auipc	ra,0x1
    47ea:	3da080e7          	jalr	986(ra) # 5bc0 <fork>
      if(pid2 < 0){
    47ee:	00054763          	bltz	a0,47fc <reparent+0x9c>
      exit(0);
    47f2:	4501                	li	a0,0
    47f4:	00001097          	auipc	ra,0x1
    47f8:	3d4080e7          	jalr	980(ra) # 5bc8 <exit>
        kill(master_pid);
    47fc:	8552                	mv	a0,s4
    47fe:	00001097          	auipc	ra,0x1
    4802:	3fa080e7          	jalr	1018(ra) # 5bf8 <kill>
        exit(1);
    4806:	4505                	li	a0,1
    4808:	00001097          	auipc	ra,0x1
    480c:	3c0080e7          	jalr	960(ra) # 5bc8 <exit>

0000000000004810 <sbrkfail>:
{
    4810:	7119                	addi	sp,sp,-128
    4812:	fc86                	sd	ra,120(sp)
    4814:	f8a2                	sd	s0,112(sp)
    4816:	f4a6                	sd	s1,104(sp)
    4818:	f0ca                	sd	s2,96(sp)
    481a:	ecce                	sd	s3,88(sp)
    481c:	e8d2                	sd	s4,80(sp)
    481e:	e4d6                	sd	s5,72(sp)
    4820:	0100                	addi	s0,sp,128
    4822:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4824:	fb040513          	addi	a0,s0,-80
    4828:	00001097          	auipc	ra,0x1
    482c:	3b0080e7          	jalr	944(ra) # 5bd8 <pipe>
    4830:	e901                	bnez	a0,4840 <sbrkfail+0x30>
    4832:	f8040493          	addi	s1,s0,-128
    4836:	fa840993          	addi	s3,s0,-88
    483a:	8926                	mv	s2,s1
    if(pids[i] != -1)
    483c:	5a7d                	li	s4,-1
    483e:	a085                	j	489e <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4840:	85d6                	mv	a1,s5
    4842:	00002517          	auipc	a0,0x2
    4846:	29650513          	addi	a0,a0,662 # 6ad8 <malloc+0xad2>
    484a:	00001097          	auipc	ra,0x1
    484e:	6fe080e7          	jalr	1790(ra) # 5f48 <printf>
    exit(1);
    4852:	4505                	li	a0,1
    4854:	00001097          	auipc	ra,0x1
    4858:	374080e7          	jalr	884(ra) # 5bc8 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    485c:	00001097          	auipc	ra,0x1
    4860:	3f4080e7          	jalr	1012(ra) # 5c50 <sbrk>
    4864:	064007b7          	lui	a5,0x6400
    4868:	40a7853b          	subw	a0,a5,a0
    486c:	00001097          	auipc	ra,0x1
    4870:	3e4080e7          	jalr	996(ra) # 5c50 <sbrk>
      write(fds[1], "x", 1);
    4874:	4605                	li	a2,1
    4876:	00002597          	auipc	a1,0x2
    487a:	94258593          	addi	a1,a1,-1726 # 61b8 <malloc+0x1b2>
    487e:	fb442503          	lw	a0,-76(s0)
    4882:	00001097          	auipc	ra,0x1
    4886:	366080e7          	jalr	870(ra) # 5be8 <write>
      for(;;) sleep(1000);
    488a:	3e800513          	li	a0,1000
    488e:	00001097          	auipc	ra,0x1
    4892:	3ca080e7          	jalr	970(ra) # 5c58 <sleep>
    4896:	bfd5                	j	488a <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4898:	0911                	addi	s2,s2,4
    489a:	03390563          	beq	s2,s3,48c4 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    489e:	00001097          	auipc	ra,0x1
    48a2:	322080e7          	jalr	802(ra) # 5bc0 <fork>
    48a6:	00a92023          	sw	a0,0(s2)
    48aa:	d94d                	beqz	a0,485c <sbrkfail+0x4c>
    if(pids[i] != -1)
    48ac:	ff4506e3          	beq	a0,s4,4898 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48b0:	4605                	li	a2,1
    48b2:	faf40593          	addi	a1,s0,-81
    48b6:	fb042503          	lw	a0,-80(s0)
    48ba:	00001097          	auipc	ra,0x1
    48be:	326080e7          	jalr	806(ra) # 5be0 <read>
    48c2:	bfd9                	j	4898 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48c4:	6505                	lui	a0,0x1
    48c6:	00001097          	auipc	ra,0x1
    48ca:	38a080e7          	jalr	906(ra) # 5c50 <sbrk>
    48ce:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48d0:	597d                	li	s2,-1
    48d2:	a021                	j	48da <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48d4:	0491                	addi	s1,s1,4
    48d6:	01348f63          	beq	s1,s3,48f4 <sbrkfail+0xe4>
    if(pids[i] == -1)
    48da:	4088                	lw	a0,0(s1)
    48dc:	ff250ce3          	beq	a0,s2,48d4 <sbrkfail+0xc4>
    kill(pids[i]);
    48e0:	00001097          	auipc	ra,0x1
    48e4:	318080e7          	jalr	792(ra) # 5bf8 <kill>
    wait(0);
    48e8:	4501                	li	a0,0
    48ea:	00001097          	auipc	ra,0x1
    48ee:	2e6080e7          	jalr	742(ra) # 5bd0 <wait>
    48f2:	b7cd                	j	48d4 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    48f4:	57fd                	li	a5,-1
    48f6:	04fa0163          	beq	s4,a5,4938 <sbrkfail+0x128>
  pid = fork();
    48fa:	00001097          	auipc	ra,0x1
    48fe:	2c6080e7          	jalr	710(ra) # 5bc0 <fork>
    4902:	84aa                	mv	s1,a0
  if(pid < 0){
    4904:	04054863          	bltz	a0,4954 <sbrkfail+0x144>
  if(pid == 0){
    4908:	c525                	beqz	a0,4970 <sbrkfail+0x160>
  wait(&xstatus);
    490a:	fbc40513          	addi	a0,s0,-68
    490e:	00001097          	auipc	ra,0x1
    4912:	2c2080e7          	jalr	706(ra) # 5bd0 <wait>
  if(xstatus != -1 && xstatus != 2)
    4916:	fbc42783          	lw	a5,-68(s0)
    491a:	577d                	li	a4,-1
    491c:	00e78563          	beq	a5,a4,4926 <sbrkfail+0x116>
    4920:	4709                	li	a4,2
    4922:	08e79d63          	bne	a5,a4,49bc <sbrkfail+0x1ac>
}
    4926:	70e6                	ld	ra,120(sp)
    4928:	7446                	ld	s0,112(sp)
    492a:	74a6                	ld	s1,104(sp)
    492c:	7906                	ld	s2,96(sp)
    492e:	69e6                	ld	s3,88(sp)
    4930:	6a46                	ld	s4,80(sp)
    4932:	6aa6                	ld	s5,72(sp)
    4934:	6109                	addi	sp,sp,128
    4936:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4938:	85d6                	mv	a1,s5
    493a:	00003517          	auipc	a0,0x3
    493e:	40650513          	addi	a0,a0,1030 # 7d40 <malloc+0x1d3a>
    4942:	00001097          	auipc	ra,0x1
    4946:	606080e7          	jalr	1542(ra) # 5f48 <printf>
    exit(1);
    494a:	4505                	li	a0,1
    494c:	00001097          	auipc	ra,0x1
    4950:	27c080e7          	jalr	636(ra) # 5bc8 <exit>
    printf("%s: fork failed\n", s);
    4954:	85d6                	mv	a1,s5
    4956:	00002517          	auipc	a0,0x2
    495a:	07a50513          	addi	a0,a0,122 # 69d0 <malloc+0x9ca>
    495e:	00001097          	auipc	ra,0x1
    4962:	5ea080e7          	jalr	1514(ra) # 5f48 <printf>
    exit(1);
    4966:	4505                	li	a0,1
    4968:	00001097          	auipc	ra,0x1
    496c:	260080e7          	jalr	608(ra) # 5bc8 <exit>
    a = sbrk(0);
    4970:	4501                	li	a0,0
    4972:	00001097          	auipc	ra,0x1
    4976:	2de080e7          	jalr	734(ra) # 5c50 <sbrk>
    497a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    497c:	3e800537          	lui	a0,0x3e800
    4980:	00001097          	auipc	ra,0x1
    4984:	2d0080e7          	jalr	720(ra) # 5c50 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4988:	87ca                	mv	a5,s2
    498a:	3e800737          	lui	a4,0x3e800
    498e:	993a                	add	s2,s2,a4
    4990:	6705                	lui	a4,0x1
      n += *(a+i);
    4992:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4996:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4998:	97ba                	add	a5,a5,a4
    499a:	ff279ce3          	bne	a5,s2,4992 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    499e:	8626                	mv	a2,s1
    49a0:	85d6                	mv	a1,s5
    49a2:	00003517          	auipc	a0,0x3
    49a6:	3be50513          	addi	a0,a0,958 # 7d60 <malloc+0x1d5a>
    49aa:	00001097          	auipc	ra,0x1
    49ae:	59e080e7          	jalr	1438(ra) # 5f48 <printf>
    exit(1);
    49b2:	4505                	li	a0,1
    49b4:	00001097          	auipc	ra,0x1
    49b8:	214080e7          	jalr	532(ra) # 5bc8 <exit>
    exit(1);
    49bc:	4505                	li	a0,1
    49be:	00001097          	auipc	ra,0x1
    49c2:	20a080e7          	jalr	522(ra) # 5bc8 <exit>

00000000000049c6 <mem>:
{
    49c6:	7139                	addi	sp,sp,-64
    49c8:	fc06                	sd	ra,56(sp)
    49ca:	f822                	sd	s0,48(sp)
    49cc:	f426                	sd	s1,40(sp)
    49ce:	f04a                	sd	s2,32(sp)
    49d0:	ec4e                	sd	s3,24(sp)
    49d2:	0080                	addi	s0,sp,64
    49d4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49d6:	00001097          	auipc	ra,0x1
    49da:	1ea080e7          	jalr	490(ra) # 5bc0 <fork>
    m1 = 0;
    49de:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49e0:	6909                	lui	s2,0x2
    49e2:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x103>
  if((pid = fork()) == 0){
    49e6:	c115                	beqz	a0,4a0a <mem+0x44>
    wait(&xstatus);
    49e8:	fcc40513          	addi	a0,s0,-52
    49ec:	00001097          	auipc	ra,0x1
    49f0:	1e4080e7          	jalr	484(ra) # 5bd0 <wait>
    if(xstatus == -1){
    49f4:	fcc42503          	lw	a0,-52(s0)
    49f8:	57fd                	li	a5,-1
    49fa:	06f50363          	beq	a0,a5,4a60 <mem+0x9a>
    exit(xstatus);
    49fe:	00001097          	auipc	ra,0x1
    4a02:	1ca080e7          	jalr	458(ra) # 5bc8 <exit>
      *(char**)m2 = m1;
    4a06:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a08:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a0a:	854a                	mv	a0,s2
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	5fa080e7          	jalr	1530(ra) # 6006 <malloc>
    4a14:	f96d                	bnez	a0,4a06 <mem+0x40>
    while(m1){
    4a16:	c881                	beqz	s1,4a26 <mem+0x60>
      m2 = *(char**)m1;
    4a18:	8526                	mv	a0,s1
    4a1a:	6084                	ld	s1,0(s1)
      free(m1);
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	562080e7          	jalr	1378(ra) # 5f7e <free>
    while(m1){
    4a24:	f8f5                	bnez	s1,4a18 <mem+0x52>
    m1 = malloc(1024*20);
    4a26:	6515                	lui	a0,0x5
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	5de080e7          	jalr	1502(ra) # 6006 <malloc>
    if(m1 == 0){
    4a30:	c911                	beqz	a0,4a44 <mem+0x7e>
    free(m1);
    4a32:	00001097          	auipc	ra,0x1
    4a36:	54c080e7          	jalr	1356(ra) # 5f7e <free>
    exit(0);
    4a3a:	4501                	li	a0,0
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	18c080e7          	jalr	396(ra) # 5bc8 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a44:	85ce                	mv	a1,s3
    4a46:	00003517          	auipc	a0,0x3
    4a4a:	34a50513          	addi	a0,a0,842 # 7d90 <malloc+0x1d8a>
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	4fa080e7          	jalr	1274(ra) # 5f48 <printf>
      exit(1);
    4a56:	4505                	li	a0,1
    4a58:	00001097          	auipc	ra,0x1
    4a5c:	170080e7          	jalr	368(ra) # 5bc8 <exit>
      exit(0);
    4a60:	4501                	li	a0,0
    4a62:	00001097          	auipc	ra,0x1
    4a66:	166080e7          	jalr	358(ra) # 5bc8 <exit>

0000000000004a6a <sharedfd>:
{
    4a6a:	7159                	addi	sp,sp,-112
    4a6c:	f486                	sd	ra,104(sp)
    4a6e:	f0a2                	sd	s0,96(sp)
    4a70:	eca6                	sd	s1,88(sp)
    4a72:	e8ca                	sd	s2,80(sp)
    4a74:	e4ce                	sd	s3,72(sp)
    4a76:	e0d2                	sd	s4,64(sp)
    4a78:	fc56                	sd	s5,56(sp)
    4a7a:	f85a                	sd	s6,48(sp)
    4a7c:	f45e                	sd	s7,40(sp)
    4a7e:	1880                	addi	s0,sp,112
    4a80:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a82:	00003517          	auipc	a0,0x3
    4a86:	32e50513          	addi	a0,a0,814 # 7db0 <malloc+0x1daa>
    4a8a:	00001097          	auipc	ra,0x1
    4a8e:	18e080e7          	jalr	398(ra) # 5c18 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a92:	20200593          	li	a1,514
    4a96:	00003517          	auipc	a0,0x3
    4a9a:	31a50513          	addi	a0,a0,794 # 7db0 <malloc+0x1daa>
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	16a080e7          	jalr	362(ra) # 5c08 <open>
  if(fd < 0){
    4aa6:	04054a63          	bltz	a0,4afa <sharedfd+0x90>
    4aaa:	892a                	mv	s2,a0
  pid = fork();
    4aac:	00001097          	auipc	ra,0x1
    4ab0:	114080e7          	jalr	276(ra) # 5bc0 <fork>
    4ab4:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ab6:	06300593          	li	a1,99
    4aba:	c119                	beqz	a0,4ac0 <sharedfd+0x56>
    4abc:	07000593          	li	a1,112
    4ac0:	4629                	li	a2,10
    4ac2:	fa040513          	addi	a0,s0,-96
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	f06080e7          	jalr	-250(ra) # 59cc <memset>
    4ace:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ad2:	4629                	li	a2,10
    4ad4:	fa040593          	addi	a1,s0,-96
    4ad8:	854a                	mv	a0,s2
    4ada:	00001097          	auipc	ra,0x1
    4ade:	10e080e7          	jalr	270(ra) # 5be8 <write>
    4ae2:	47a9                	li	a5,10
    4ae4:	02f51963          	bne	a0,a5,4b16 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4ae8:	34fd                	addiw	s1,s1,-1
    4aea:	f4e5                	bnez	s1,4ad2 <sharedfd+0x68>
  if(pid == 0) {
    4aec:	04099363          	bnez	s3,4b32 <sharedfd+0xc8>
    exit(0);
    4af0:	4501                	li	a0,0
    4af2:	00001097          	auipc	ra,0x1
    4af6:	0d6080e7          	jalr	214(ra) # 5bc8 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4afa:	85d2                	mv	a1,s4
    4afc:	00003517          	auipc	a0,0x3
    4b00:	2c450513          	addi	a0,a0,708 # 7dc0 <malloc+0x1dba>
    4b04:	00001097          	auipc	ra,0x1
    4b08:	444080e7          	jalr	1092(ra) # 5f48 <printf>
    exit(1);
    4b0c:	4505                	li	a0,1
    4b0e:	00001097          	auipc	ra,0x1
    4b12:	0ba080e7          	jalr	186(ra) # 5bc8 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b16:	85d2                	mv	a1,s4
    4b18:	00003517          	auipc	a0,0x3
    4b1c:	2d050513          	addi	a0,a0,720 # 7de8 <malloc+0x1de2>
    4b20:	00001097          	auipc	ra,0x1
    4b24:	428080e7          	jalr	1064(ra) # 5f48 <printf>
      exit(1);
    4b28:	4505                	li	a0,1
    4b2a:	00001097          	auipc	ra,0x1
    4b2e:	09e080e7          	jalr	158(ra) # 5bc8 <exit>
    wait(&xstatus);
    4b32:	f9c40513          	addi	a0,s0,-100
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	09a080e7          	jalr	154(ra) # 5bd0 <wait>
    if(xstatus != 0)
    4b3e:	f9c42983          	lw	s3,-100(s0)
    4b42:	00098763          	beqz	s3,4b50 <sharedfd+0xe6>
      exit(xstatus);
    4b46:	854e                	mv	a0,s3
    4b48:	00001097          	auipc	ra,0x1
    4b4c:	080080e7          	jalr	128(ra) # 5bc8 <exit>
  close(fd);
    4b50:	854a                	mv	a0,s2
    4b52:	00001097          	auipc	ra,0x1
    4b56:	09e080e7          	jalr	158(ra) # 5bf0 <close>
  fd = open("sharedfd", 0);
    4b5a:	4581                	li	a1,0
    4b5c:	00003517          	auipc	a0,0x3
    4b60:	25450513          	addi	a0,a0,596 # 7db0 <malloc+0x1daa>
    4b64:	00001097          	auipc	ra,0x1
    4b68:	0a4080e7          	jalr	164(ra) # 5c08 <open>
    4b6c:	8baa                	mv	s7,a0
  nc = np = 0;
    4b6e:	8ace                	mv	s5,s3
  if(fd < 0){
    4b70:	02054563          	bltz	a0,4b9a <sharedfd+0x130>
    4b74:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b78:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b7c:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b80:	4629                	li	a2,10
    4b82:	fa040593          	addi	a1,s0,-96
    4b86:	855e                	mv	a0,s7
    4b88:	00001097          	auipc	ra,0x1
    4b8c:	058080e7          	jalr	88(ra) # 5be0 <read>
    4b90:	02a05f63          	blez	a0,4bce <sharedfd+0x164>
    4b94:	fa040793          	addi	a5,s0,-96
    4b98:	a01d                	j	4bbe <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b9a:	85d2                	mv	a1,s4
    4b9c:	00003517          	auipc	a0,0x3
    4ba0:	26c50513          	addi	a0,a0,620 # 7e08 <malloc+0x1e02>
    4ba4:	00001097          	auipc	ra,0x1
    4ba8:	3a4080e7          	jalr	932(ra) # 5f48 <printf>
    exit(1);
    4bac:	4505                	li	a0,1
    4bae:	00001097          	auipc	ra,0x1
    4bb2:	01a080e7          	jalr	26(ra) # 5bc8 <exit>
        nc++;
    4bb6:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bb8:	0785                	addi	a5,a5,1
    4bba:	fd2783e3          	beq	a5,s2,4b80 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bbe:	0007c703          	lbu	a4,0(a5)
    4bc2:	fe970ae3          	beq	a4,s1,4bb6 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bc6:	ff6719e3          	bne	a4,s6,4bb8 <sharedfd+0x14e>
        np++;
    4bca:	2a85                	addiw	s5,s5,1
    4bcc:	b7f5                	j	4bb8 <sharedfd+0x14e>
  close(fd);
    4bce:	855e                	mv	a0,s7
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	020080e7          	jalr	32(ra) # 5bf0 <close>
  unlink("sharedfd");
    4bd8:	00003517          	auipc	a0,0x3
    4bdc:	1d850513          	addi	a0,a0,472 # 7db0 <malloc+0x1daa>
    4be0:	00001097          	auipc	ra,0x1
    4be4:	038080e7          	jalr	56(ra) # 5c18 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4be8:	6789                	lui	a5,0x2
    4bea:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x102>
    4bee:	00f99763          	bne	s3,a5,4bfc <sharedfd+0x192>
    4bf2:	6789                	lui	a5,0x2
    4bf4:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x102>
    4bf8:	02fa8063          	beq	s5,a5,4c18 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4bfc:	85d2                	mv	a1,s4
    4bfe:	00003517          	auipc	a0,0x3
    4c02:	23250513          	addi	a0,a0,562 # 7e30 <malloc+0x1e2a>
    4c06:	00001097          	auipc	ra,0x1
    4c0a:	342080e7          	jalr	834(ra) # 5f48 <printf>
    exit(1);
    4c0e:	4505                	li	a0,1
    4c10:	00001097          	auipc	ra,0x1
    4c14:	fb8080e7          	jalr	-72(ra) # 5bc8 <exit>
    exit(0);
    4c18:	4501                	li	a0,0
    4c1a:	00001097          	auipc	ra,0x1
    4c1e:	fae080e7          	jalr	-82(ra) # 5bc8 <exit>

0000000000004c22 <fourfiles>:
{
    4c22:	7171                	addi	sp,sp,-176
    4c24:	f506                	sd	ra,168(sp)
    4c26:	f122                	sd	s0,160(sp)
    4c28:	ed26                	sd	s1,152(sp)
    4c2a:	e94a                	sd	s2,144(sp)
    4c2c:	e54e                	sd	s3,136(sp)
    4c2e:	e152                	sd	s4,128(sp)
    4c30:	fcd6                	sd	s5,120(sp)
    4c32:	f8da                	sd	s6,112(sp)
    4c34:	f4de                	sd	s7,104(sp)
    4c36:	f0e2                	sd	s8,96(sp)
    4c38:	ece6                	sd	s9,88(sp)
    4c3a:	e8ea                	sd	s10,80(sp)
    4c3c:	e4ee                	sd	s11,72(sp)
    4c3e:	1900                	addi	s0,sp,176
    4c40:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c44:	00001797          	auipc	a5,0x1
    4c48:	4ac78793          	addi	a5,a5,1196 # 60f0 <malloc+0xea>
    4c4c:	f6f43823          	sd	a5,-144(s0)
    4c50:	00001797          	auipc	a5,0x1
    4c54:	4a878793          	addi	a5,a5,1192 # 60f8 <malloc+0xf2>
    4c58:	f6f43c23          	sd	a5,-136(s0)
    4c5c:	00001797          	auipc	a5,0x1
    4c60:	4a478793          	addi	a5,a5,1188 # 6100 <malloc+0xfa>
    4c64:	f8f43023          	sd	a5,-128(s0)
    4c68:	00001797          	auipc	a5,0x1
    4c6c:	4a078793          	addi	a5,a5,1184 # 6108 <malloc+0x102>
    4c70:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c74:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c78:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4c7a:	4481                	li	s1,0
    4c7c:	4a11                	li	s4,4
    fname = names[pi];
    4c7e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c82:	854e                	mv	a0,s3
    4c84:	00001097          	auipc	ra,0x1
    4c88:	f94080e7          	jalr	-108(ra) # 5c18 <unlink>
    pid = fork();
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	f34080e7          	jalr	-204(ra) # 5bc0 <fork>
    if(pid < 0){
    4c94:	04054463          	bltz	a0,4cdc <fourfiles+0xba>
    if(pid == 0){
    4c98:	c12d                	beqz	a0,4cfa <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4c9a:	2485                	addiw	s1,s1,1
    4c9c:	0921                	addi	s2,s2,8
    4c9e:	ff4490e3          	bne	s1,s4,4c7e <fourfiles+0x5c>
    4ca2:	4491                	li	s1,4
    wait(&xstatus);
    4ca4:	f6c40513          	addi	a0,s0,-148
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	f28080e7          	jalr	-216(ra) # 5bd0 <wait>
    if(xstatus != 0)
    4cb0:	f6c42b03          	lw	s6,-148(s0)
    4cb4:	0c0b1e63          	bnez	s6,4d90 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4cb8:	34fd                	addiw	s1,s1,-1
    4cba:	f4ed                	bnez	s1,4ca4 <fourfiles+0x82>
    4cbc:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cc0:	00008a17          	auipc	s4,0x8
    4cc4:	fb8a0a13          	addi	s4,s4,-72 # cc78 <buf>
    4cc8:	00008a97          	auipc	s5,0x8
    4ccc:	fb1a8a93          	addi	s5,s5,-79 # cc79 <buf+0x1>
    if(total != N*SZ){
    4cd0:	6d85                	lui	s11,0x1
    4cd2:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4cd6:	03400d13          	li	s10,52
    4cda:	aa1d                	j	4e10 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4cdc:	f5843583          	ld	a1,-168(s0)
    4ce0:	00002517          	auipc	a0,0x2
    4ce4:	0f850513          	addi	a0,a0,248 # 6dd8 <malloc+0xdd2>
    4ce8:	00001097          	auipc	ra,0x1
    4cec:	260080e7          	jalr	608(ra) # 5f48 <printf>
      exit(1);
    4cf0:	4505                	li	a0,1
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	ed6080e7          	jalr	-298(ra) # 5bc8 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cfa:	20200593          	li	a1,514
    4cfe:	854e                	mv	a0,s3
    4d00:	00001097          	auipc	ra,0x1
    4d04:	f08080e7          	jalr	-248(ra) # 5c08 <open>
    4d08:	892a                	mv	s2,a0
      if(fd < 0){
    4d0a:	04054763          	bltz	a0,4d58 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4d0e:	1f400613          	li	a2,500
    4d12:	0304859b          	addiw	a1,s1,48
    4d16:	00008517          	auipc	a0,0x8
    4d1a:	f6250513          	addi	a0,a0,-158 # cc78 <buf>
    4d1e:	00001097          	auipc	ra,0x1
    4d22:	cae080e7          	jalr	-850(ra) # 59cc <memset>
    4d26:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d28:	00008997          	auipc	s3,0x8
    4d2c:	f5098993          	addi	s3,s3,-176 # cc78 <buf>
    4d30:	1f400613          	li	a2,500
    4d34:	85ce                	mv	a1,s3
    4d36:	854a                	mv	a0,s2
    4d38:	00001097          	auipc	ra,0x1
    4d3c:	eb0080e7          	jalr	-336(ra) # 5be8 <write>
    4d40:	85aa                	mv	a1,a0
    4d42:	1f400793          	li	a5,500
    4d46:	02f51863          	bne	a0,a5,4d76 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4d4a:	34fd                	addiw	s1,s1,-1
    4d4c:	f0f5                	bnez	s1,4d30 <fourfiles+0x10e>
      exit(0);
    4d4e:	4501                	li	a0,0
    4d50:	00001097          	auipc	ra,0x1
    4d54:	e78080e7          	jalr	-392(ra) # 5bc8 <exit>
        printf("create failed\n", s);
    4d58:	f5843583          	ld	a1,-168(s0)
    4d5c:	00003517          	auipc	a0,0x3
    4d60:	0ec50513          	addi	a0,a0,236 # 7e48 <malloc+0x1e42>
    4d64:	00001097          	auipc	ra,0x1
    4d68:	1e4080e7          	jalr	484(ra) # 5f48 <printf>
        exit(1);
    4d6c:	4505                	li	a0,1
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	e5a080e7          	jalr	-422(ra) # 5bc8 <exit>
          printf("write failed %d\n", n);
    4d76:	00003517          	auipc	a0,0x3
    4d7a:	0e250513          	addi	a0,a0,226 # 7e58 <malloc+0x1e52>
    4d7e:	00001097          	auipc	ra,0x1
    4d82:	1ca080e7          	jalr	458(ra) # 5f48 <printf>
          exit(1);
    4d86:	4505                	li	a0,1
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	e40080e7          	jalr	-448(ra) # 5bc8 <exit>
      exit(xstatus);
    4d90:	855a                	mv	a0,s6
    4d92:	00001097          	auipc	ra,0x1
    4d96:	e36080e7          	jalr	-458(ra) # 5bc8 <exit>
          printf("wrong char\n", s);
    4d9a:	f5843583          	ld	a1,-168(s0)
    4d9e:	00003517          	auipc	a0,0x3
    4da2:	0d250513          	addi	a0,a0,210 # 7e70 <malloc+0x1e6a>
    4da6:	00001097          	auipc	ra,0x1
    4daa:	1a2080e7          	jalr	418(ra) # 5f48 <printf>
          exit(1);
    4dae:	4505                	li	a0,1
    4db0:	00001097          	auipc	ra,0x1
    4db4:	e18080e7          	jalr	-488(ra) # 5bc8 <exit>
      total += n;
    4db8:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dbc:	660d                	lui	a2,0x3
    4dbe:	85d2                	mv	a1,s4
    4dc0:	854e                	mv	a0,s3
    4dc2:	00001097          	auipc	ra,0x1
    4dc6:	e1e080e7          	jalr	-482(ra) # 5be0 <read>
    4dca:	02a05363          	blez	a0,4df0 <fourfiles+0x1ce>
    4dce:	00008797          	auipc	a5,0x8
    4dd2:	eaa78793          	addi	a5,a5,-342 # cc78 <buf>
    4dd6:	fff5069b          	addiw	a3,a0,-1
    4dda:	1682                	slli	a3,a3,0x20
    4ddc:	9281                	srli	a3,a3,0x20
    4dde:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4de0:	0007c703          	lbu	a4,0(a5)
    4de4:	fa971be3          	bne	a4,s1,4d9a <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4de8:	0785                	addi	a5,a5,1
    4dea:	fed79be3          	bne	a5,a3,4de0 <fourfiles+0x1be>
    4dee:	b7e9                	j	4db8 <fourfiles+0x196>
    close(fd);
    4df0:	854e                	mv	a0,s3
    4df2:	00001097          	auipc	ra,0x1
    4df6:	dfe080e7          	jalr	-514(ra) # 5bf0 <close>
    if(total != N*SZ){
    4dfa:	03b91863          	bne	s2,s11,4e2a <fourfiles+0x208>
    unlink(fname);
    4dfe:	8566                	mv	a0,s9
    4e00:	00001097          	auipc	ra,0x1
    4e04:	e18080e7          	jalr	-488(ra) # 5c18 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e08:	0c21                	addi	s8,s8,8
    4e0a:	2b85                	addiw	s7,s7,1
    4e0c:	03ab8d63          	beq	s7,s10,4e46 <fourfiles+0x224>
    fname = names[i];
    4e10:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4e14:	4581                	li	a1,0
    4e16:	8566                	mv	a0,s9
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	df0080e7          	jalr	-528(ra) # 5c08 <open>
    4e20:	89aa                	mv	s3,a0
    total = 0;
    4e22:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4e24:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e28:	bf51                	j	4dbc <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4e2a:	85ca                	mv	a1,s2
    4e2c:	00003517          	auipc	a0,0x3
    4e30:	05450513          	addi	a0,a0,84 # 7e80 <malloc+0x1e7a>
    4e34:	00001097          	auipc	ra,0x1
    4e38:	114080e7          	jalr	276(ra) # 5f48 <printf>
      exit(1);
    4e3c:	4505                	li	a0,1
    4e3e:	00001097          	auipc	ra,0x1
    4e42:	d8a080e7          	jalr	-630(ra) # 5bc8 <exit>
}
    4e46:	70aa                	ld	ra,168(sp)
    4e48:	740a                	ld	s0,160(sp)
    4e4a:	64ea                	ld	s1,152(sp)
    4e4c:	694a                	ld	s2,144(sp)
    4e4e:	69aa                	ld	s3,136(sp)
    4e50:	6a0a                	ld	s4,128(sp)
    4e52:	7ae6                	ld	s5,120(sp)
    4e54:	7b46                	ld	s6,112(sp)
    4e56:	7ba6                	ld	s7,104(sp)
    4e58:	7c06                	ld	s8,96(sp)
    4e5a:	6ce6                	ld	s9,88(sp)
    4e5c:	6d46                	ld	s10,80(sp)
    4e5e:	6da6                	ld	s11,72(sp)
    4e60:	614d                	addi	sp,sp,176
    4e62:	8082                	ret

0000000000004e64 <concreate>:
{
    4e64:	7135                	addi	sp,sp,-160
    4e66:	ed06                	sd	ra,152(sp)
    4e68:	e922                	sd	s0,144(sp)
    4e6a:	e526                	sd	s1,136(sp)
    4e6c:	e14a                	sd	s2,128(sp)
    4e6e:	fcce                	sd	s3,120(sp)
    4e70:	f8d2                	sd	s4,112(sp)
    4e72:	f4d6                	sd	s5,104(sp)
    4e74:	f0da                	sd	s6,96(sp)
    4e76:	ecde                	sd	s7,88(sp)
    4e78:	1100                	addi	s0,sp,160
    4e7a:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e7c:	04300793          	li	a5,67
    4e80:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e84:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e88:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e8a:	4b0d                	li	s6,3
    4e8c:	4a85                	li	s5,1
      link("C0", file);
    4e8e:	00003b97          	auipc	s7,0x3
    4e92:	00ab8b93          	addi	s7,s7,10 # 7e98 <malloc+0x1e92>
  for(i = 0; i < N; i++){
    4e96:	02800a13          	li	s4,40
    4e9a:	acc1                	j	516a <concreate+0x306>
      link("C0", file);
    4e9c:	fa840593          	addi	a1,s0,-88
    4ea0:	855e                	mv	a0,s7
    4ea2:	00001097          	auipc	ra,0x1
    4ea6:	d86080e7          	jalr	-634(ra) # 5c28 <link>
    if(pid == 0) {
    4eaa:	a45d                	j	5150 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4eac:	4795                	li	a5,5
    4eae:	02f9693b          	remw	s2,s2,a5
    4eb2:	4785                	li	a5,1
    4eb4:	02f90b63          	beq	s2,a5,4eea <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eb8:	20200593          	li	a1,514
    4ebc:	fa840513          	addi	a0,s0,-88
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	d48080e7          	jalr	-696(ra) # 5c08 <open>
      if(fd < 0){
    4ec8:	26055b63          	bgez	a0,513e <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4ecc:	fa840593          	addi	a1,s0,-88
    4ed0:	00003517          	auipc	a0,0x3
    4ed4:	fd050513          	addi	a0,a0,-48 # 7ea0 <malloc+0x1e9a>
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	070080e7          	jalr	112(ra) # 5f48 <printf>
        exit(1);
    4ee0:	4505                	li	a0,1
    4ee2:	00001097          	auipc	ra,0x1
    4ee6:	ce6080e7          	jalr	-794(ra) # 5bc8 <exit>
      link("C0", file);
    4eea:	fa840593          	addi	a1,s0,-88
    4eee:	00003517          	auipc	a0,0x3
    4ef2:	faa50513          	addi	a0,a0,-86 # 7e98 <malloc+0x1e92>
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	d32080e7          	jalr	-718(ra) # 5c28 <link>
      exit(0);
    4efe:	4501                	li	a0,0
    4f00:	00001097          	auipc	ra,0x1
    4f04:	cc8080e7          	jalr	-824(ra) # 5bc8 <exit>
        exit(1);
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	cbe080e7          	jalr	-834(ra) # 5bc8 <exit>
  memset(fa, 0, sizeof(fa));
    4f12:	02800613          	li	a2,40
    4f16:	4581                	li	a1,0
    4f18:	f8040513          	addi	a0,s0,-128
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	ab0080e7          	jalr	-1360(ra) # 59cc <memset>
  fd = open(".", 0);
    4f24:	4581                	li	a1,0
    4f26:	00002517          	auipc	a0,0x2
    4f2a:	90a50513          	addi	a0,a0,-1782 # 6830 <malloc+0x82a>
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	cda080e7          	jalr	-806(ra) # 5c08 <open>
    4f36:	892a                	mv	s2,a0
  n = 0;
    4f38:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f3a:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f3e:	02700b13          	li	s6,39
      fa[i] = 1;
    4f42:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f44:	4641                	li	a2,16
    4f46:	f7040593          	addi	a1,s0,-144
    4f4a:	854a                	mv	a0,s2
    4f4c:	00001097          	auipc	ra,0x1
    4f50:	c94080e7          	jalr	-876(ra) # 5be0 <read>
    4f54:	08a05163          	blez	a0,4fd6 <concreate+0x172>
    if(de.inum == 0)
    4f58:	f7045783          	lhu	a5,-144(s0)
    4f5c:	d7e5                	beqz	a5,4f44 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f5e:	f7244783          	lbu	a5,-142(s0)
    4f62:	ff4791e3          	bne	a5,s4,4f44 <concreate+0xe0>
    4f66:	f7444783          	lbu	a5,-140(s0)
    4f6a:	ffe9                	bnez	a5,4f44 <concreate+0xe0>
      i = de.name[1] - '0';
    4f6c:	f7344783          	lbu	a5,-141(s0)
    4f70:	fd07879b          	addiw	a5,a5,-48
    4f74:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f78:	00eb6f63          	bltu	s6,a4,4f96 <concreate+0x132>
      if(fa[i]){
    4f7c:	fb040793          	addi	a5,s0,-80
    4f80:	97ba                	add	a5,a5,a4
    4f82:	fd07c783          	lbu	a5,-48(a5)
    4f86:	eb85                	bnez	a5,4fb6 <concreate+0x152>
      fa[i] = 1;
    4f88:	fb040793          	addi	a5,s0,-80
    4f8c:	973e                	add	a4,a4,a5
    4f8e:	fd770823          	sb	s7,-48(a4) # fd0 <linktest+0xda>
      n++;
    4f92:	2a85                	addiw	s5,s5,1
    4f94:	bf45                	j	4f44 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f96:	f7240613          	addi	a2,s0,-142
    4f9a:	85ce                	mv	a1,s3
    4f9c:	00003517          	auipc	a0,0x3
    4fa0:	f2450513          	addi	a0,a0,-220 # 7ec0 <malloc+0x1eba>
    4fa4:	00001097          	auipc	ra,0x1
    4fa8:	fa4080e7          	jalr	-92(ra) # 5f48 <printf>
        exit(1);
    4fac:	4505                	li	a0,1
    4fae:	00001097          	auipc	ra,0x1
    4fb2:	c1a080e7          	jalr	-998(ra) # 5bc8 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fb6:	f7240613          	addi	a2,s0,-142
    4fba:	85ce                	mv	a1,s3
    4fbc:	00003517          	auipc	a0,0x3
    4fc0:	f2450513          	addi	a0,a0,-220 # 7ee0 <malloc+0x1eda>
    4fc4:	00001097          	auipc	ra,0x1
    4fc8:	f84080e7          	jalr	-124(ra) # 5f48 <printf>
        exit(1);
    4fcc:	4505                	li	a0,1
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	bfa080e7          	jalr	-1030(ra) # 5bc8 <exit>
  close(fd);
    4fd6:	854a                	mv	a0,s2
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	c18080e7          	jalr	-1000(ra) # 5bf0 <close>
  if(n != N){
    4fe0:	02800793          	li	a5,40
    4fe4:	00fa9763          	bne	s5,a5,4ff2 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4fe8:	4a8d                	li	s5,3
    4fea:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fec:	02800a13          	li	s4,40
    4ff0:	a8c9                	j	50c2 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff2:	85ce                	mv	a1,s3
    4ff4:	00003517          	auipc	a0,0x3
    4ff8:	f1450513          	addi	a0,a0,-236 # 7f08 <malloc+0x1f02>
    4ffc:	00001097          	auipc	ra,0x1
    5000:	f4c080e7          	jalr	-180(ra) # 5f48 <printf>
    exit(1);
    5004:	4505                	li	a0,1
    5006:	00001097          	auipc	ra,0x1
    500a:	bc2080e7          	jalr	-1086(ra) # 5bc8 <exit>
      printf("%s: fork failed\n", s);
    500e:	85ce                	mv	a1,s3
    5010:	00002517          	auipc	a0,0x2
    5014:	9c050513          	addi	a0,a0,-1600 # 69d0 <malloc+0x9ca>
    5018:	00001097          	auipc	ra,0x1
    501c:	f30080e7          	jalr	-208(ra) # 5f48 <printf>
      exit(1);
    5020:	4505                	li	a0,1
    5022:	00001097          	auipc	ra,0x1
    5026:	ba6080e7          	jalr	-1114(ra) # 5bc8 <exit>
      close(open(file, 0));
    502a:	4581                	li	a1,0
    502c:	fa840513          	addi	a0,s0,-88
    5030:	00001097          	auipc	ra,0x1
    5034:	bd8080e7          	jalr	-1064(ra) # 5c08 <open>
    5038:	00001097          	auipc	ra,0x1
    503c:	bb8080e7          	jalr	-1096(ra) # 5bf0 <close>
      close(open(file, 0));
    5040:	4581                	li	a1,0
    5042:	fa840513          	addi	a0,s0,-88
    5046:	00001097          	auipc	ra,0x1
    504a:	bc2080e7          	jalr	-1086(ra) # 5c08 <open>
    504e:	00001097          	auipc	ra,0x1
    5052:	ba2080e7          	jalr	-1118(ra) # 5bf0 <close>
      close(open(file, 0));
    5056:	4581                	li	a1,0
    5058:	fa840513          	addi	a0,s0,-88
    505c:	00001097          	auipc	ra,0x1
    5060:	bac080e7          	jalr	-1108(ra) # 5c08 <open>
    5064:	00001097          	auipc	ra,0x1
    5068:	b8c080e7          	jalr	-1140(ra) # 5bf0 <close>
      close(open(file, 0));
    506c:	4581                	li	a1,0
    506e:	fa840513          	addi	a0,s0,-88
    5072:	00001097          	auipc	ra,0x1
    5076:	b96080e7          	jalr	-1130(ra) # 5c08 <open>
    507a:	00001097          	auipc	ra,0x1
    507e:	b76080e7          	jalr	-1162(ra) # 5bf0 <close>
      close(open(file, 0));
    5082:	4581                	li	a1,0
    5084:	fa840513          	addi	a0,s0,-88
    5088:	00001097          	auipc	ra,0x1
    508c:	b80080e7          	jalr	-1152(ra) # 5c08 <open>
    5090:	00001097          	auipc	ra,0x1
    5094:	b60080e7          	jalr	-1184(ra) # 5bf0 <close>
      close(open(file, 0));
    5098:	4581                	li	a1,0
    509a:	fa840513          	addi	a0,s0,-88
    509e:	00001097          	auipc	ra,0x1
    50a2:	b6a080e7          	jalr	-1174(ra) # 5c08 <open>
    50a6:	00001097          	auipc	ra,0x1
    50aa:	b4a080e7          	jalr	-1206(ra) # 5bf0 <close>
    if(pid == 0)
    50ae:	08090363          	beqz	s2,5134 <concreate+0x2d0>
      wait(0);
    50b2:	4501                	li	a0,0
    50b4:	00001097          	auipc	ra,0x1
    50b8:	b1c080e7          	jalr	-1252(ra) # 5bd0 <wait>
  for(i = 0; i < N; i++){
    50bc:	2485                	addiw	s1,s1,1
    50be:	0f448563          	beq	s1,s4,51a8 <concreate+0x344>
    file[1] = '0' + i;
    50c2:	0304879b          	addiw	a5,s1,48
    50c6:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50ca:	00001097          	auipc	ra,0x1
    50ce:	af6080e7          	jalr	-1290(ra) # 5bc0 <fork>
    50d2:	892a                	mv	s2,a0
    if(pid < 0){
    50d4:	f2054de3          	bltz	a0,500e <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    50d8:	0354e73b          	remw	a4,s1,s5
    50dc:	00a767b3          	or	a5,a4,a0
    50e0:	2781                	sext.w	a5,a5
    50e2:	d7a1                	beqz	a5,502a <concreate+0x1c6>
    50e4:	01671363          	bne	a4,s6,50ea <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    50e8:	f129                	bnez	a0,502a <concreate+0x1c6>
      unlink(file);
    50ea:	fa840513          	addi	a0,s0,-88
    50ee:	00001097          	auipc	ra,0x1
    50f2:	b2a080e7          	jalr	-1238(ra) # 5c18 <unlink>
      unlink(file);
    50f6:	fa840513          	addi	a0,s0,-88
    50fa:	00001097          	auipc	ra,0x1
    50fe:	b1e080e7          	jalr	-1250(ra) # 5c18 <unlink>
      unlink(file);
    5102:	fa840513          	addi	a0,s0,-88
    5106:	00001097          	auipc	ra,0x1
    510a:	b12080e7          	jalr	-1262(ra) # 5c18 <unlink>
      unlink(file);
    510e:	fa840513          	addi	a0,s0,-88
    5112:	00001097          	auipc	ra,0x1
    5116:	b06080e7          	jalr	-1274(ra) # 5c18 <unlink>
      unlink(file);
    511a:	fa840513          	addi	a0,s0,-88
    511e:	00001097          	auipc	ra,0x1
    5122:	afa080e7          	jalr	-1286(ra) # 5c18 <unlink>
      unlink(file);
    5126:	fa840513          	addi	a0,s0,-88
    512a:	00001097          	auipc	ra,0x1
    512e:	aee080e7          	jalr	-1298(ra) # 5c18 <unlink>
    5132:	bfb5                	j	50ae <concreate+0x24a>
      exit(0);
    5134:	4501                	li	a0,0
    5136:	00001097          	auipc	ra,0x1
    513a:	a92080e7          	jalr	-1390(ra) # 5bc8 <exit>
      close(fd);
    513e:	00001097          	auipc	ra,0x1
    5142:	ab2080e7          	jalr	-1358(ra) # 5bf0 <close>
    if(pid == 0) {
    5146:	bb65                	j	4efe <concreate+0x9a>
      close(fd);
    5148:	00001097          	auipc	ra,0x1
    514c:	aa8080e7          	jalr	-1368(ra) # 5bf0 <close>
      wait(&xstatus);
    5150:	f6c40513          	addi	a0,s0,-148
    5154:	00001097          	auipc	ra,0x1
    5158:	a7c080e7          	jalr	-1412(ra) # 5bd0 <wait>
      if(xstatus != 0)
    515c:	f6c42483          	lw	s1,-148(s0)
    5160:	da0494e3          	bnez	s1,4f08 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5164:	2905                	addiw	s2,s2,1
    5166:	db4906e3          	beq	s2,s4,4f12 <concreate+0xae>
    file[1] = '0' + i;
    516a:	0309079b          	addiw	a5,s2,48
    516e:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5172:	fa840513          	addi	a0,s0,-88
    5176:	00001097          	auipc	ra,0x1
    517a:	aa2080e7          	jalr	-1374(ra) # 5c18 <unlink>
    pid = fork();
    517e:	00001097          	auipc	ra,0x1
    5182:	a42080e7          	jalr	-1470(ra) # 5bc0 <fork>
    if(pid && (i % 3) == 1){
    5186:	d20503e3          	beqz	a0,4eac <concreate+0x48>
    518a:	036967bb          	remw	a5,s2,s6
    518e:	d15787e3          	beq	a5,s5,4e9c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5192:	20200593          	li	a1,514
    5196:	fa840513          	addi	a0,s0,-88
    519a:	00001097          	auipc	ra,0x1
    519e:	a6e080e7          	jalr	-1426(ra) # 5c08 <open>
      if(fd < 0){
    51a2:	fa0553e3          	bgez	a0,5148 <concreate+0x2e4>
    51a6:	b31d                	j	4ecc <concreate+0x68>
}
    51a8:	60ea                	ld	ra,152(sp)
    51aa:	644a                	ld	s0,144(sp)
    51ac:	64aa                	ld	s1,136(sp)
    51ae:	690a                	ld	s2,128(sp)
    51b0:	79e6                	ld	s3,120(sp)
    51b2:	7a46                	ld	s4,112(sp)
    51b4:	7aa6                	ld	s5,104(sp)
    51b6:	7b06                	ld	s6,96(sp)
    51b8:	6be6                	ld	s7,88(sp)
    51ba:	610d                	addi	sp,sp,160
    51bc:	8082                	ret

00000000000051be <bigfile>:
{
    51be:	7139                	addi	sp,sp,-64
    51c0:	fc06                	sd	ra,56(sp)
    51c2:	f822                	sd	s0,48(sp)
    51c4:	f426                	sd	s1,40(sp)
    51c6:	f04a                	sd	s2,32(sp)
    51c8:	ec4e                	sd	s3,24(sp)
    51ca:	e852                	sd	s4,16(sp)
    51cc:	e456                	sd	s5,8(sp)
    51ce:	0080                	addi	s0,sp,64
    51d0:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d2:	00003517          	auipc	a0,0x3
    51d6:	d6e50513          	addi	a0,a0,-658 # 7f40 <malloc+0x1f3a>
    51da:	00001097          	auipc	ra,0x1
    51de:	a3e080e7          	jalr	-1474(ra) # 5c18 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e2:	20200593          	li	a1,514
    51e6:	00003517          	auipc	a0,0x3
    51ea:	d5a50513          	addi	a0,a0,-678 # 7f40 <malloc+0x1f3a>
    51ee:	00001097          	auipc	ra,0x1
    51f2:	a1a080e7          	jalr	-1510(ra) # 5c08 <open>
    51f6:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51f8:	4481                	li	s1,0
    memset(buf, i, SZ);
    51fa:	00008917          	auipc	s2,0x8
    51fe:	a7e90913          	addi	s2,s2,-1410 # cc78 <buf>
  for(i = 0; i < N; i++){
    5202:	4a51                	li	s4,20
  if(fd < 0){
    5204:	0a054063          	bltz	a0,52a4 <bigfile+0xe6>
    memset(buf, i, SZ);
    5208:	25800613          	li	a2,600
    520c:	85a6                	mv	a1,s1
    520e:	854a                	mv	a0,s2
    5210:	00000097          	auipc	ra,0x0
    5214:	7bc080e7          	jalr	1980(ra) # 59cc <memset>
    if(write(fd, buf, SZ) != SZ){
    5218:	25800613          	li	a2,600
    521c:	85ca                	mv	a1,s2
    521e:	854e                	mv	a0,s3
    5220:	00001097          	auipc	ra,0x1
    5224:	9c8080e7          	jalr	-1592(ra) # 5be8 <write>
    5228:	25800793          	li	a5,600
    522c:	08f51a63          	bne	a0,a5,52c0 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5230:	2485                	addiw	s1,s1,1
    5232:	fd449be3          	bne	s1,s4,5208 <bigfile+0x4a>
  close(fd);
    5236:	854e                	mv	a0,s3
    5238:	00001097          	auipc	ra,0x1
    523c:	9b8080e7          	jalr	-1608(ra) # 5bf0 <close>
  fd = open("bigfile.dat", 0);
    5240:	4581                	li	a1,0
    5242:	00003517          	auipc	a0,0x3
    5246:	cfe50513          	addi	a0,a0,-770 # 7f40 <malloc+0x1f3a>
    524a:	00001097          	auipc	ra,0x1
    524e:	9be080e7          	jalr	-1602(ra) # 5c08 <open>
    5252:	8a2a                	mv	s4,a0
  total = 0;
    5254:	4981                	li	s3,0
  for(i = 0; ; i++){
    5256:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5258:	00008917          	auipc	s2,0x8
    525c:	a2090913          	addi	s2,s2,-1504 # cc78 <buf>
  if(fd < 0){
    5260:	06054e63          	bltz	a0,52dc <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5264:	12c00613          	li	a2,300
    5268:	85ca                	mv	a1,s2
    526a:	8552                	mv	a0,s4
    526c:	00001097          	auipc	ra,0x1
    5270:	974080e7          	jalr	-1676(ra) # 5be0 <read>
    if(cc < 0){
    5274:	08054263          	bltz	a0,52f8 <bigfile+0x13a>
    if(cc == 0)
    5278:	c971                	beqz	a0,534c <bigfile+0x18e>
    if(cc != SZ/2){
    527a:	12c00793          	li	a5,300
    527e:	08f51b63          	bne	a0,a5,5314 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5282:	01f4d79b          	srliw	a5,s1,0x1f
    5286:	9fa5                	addw	a5,a5,s1
    5288:	4017d79b          	sraiw	a5,a5,0x1
    528c:	00094703          	lbu	a4,0(s2)
    5290:	0af71063          	bne	a4,a5,5330 <bigfile+0x172>
    5294:	12b94703          	lbu	a4,299(s2)
    5298:	08f71c63          	bne	a4,a5,5330 <bigfile+0x172>
    total += cc;
    529c:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    52a0:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52a2:	b7c9                	j	5264 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a4:	85d6                	mv	a1,s5
    52a6:	00003517          	auipc	a0,0x3
    52aa:	caa50513          	addi	a0,a0,-854 # 7f50 <malloc+0x1f4a>
    52ae:	00001097          	auipc	ra,0x1
    52b2:	c9a080e7          	jalr	-870(ra) # 5f48 <printf>
    exit(1);
    52b6:	4505                	li	a0,1
    52b8:	00001097          	auipc	ra,0x1
    52bc:	910080e7          	jalr	-1776(ra) # 5bc8 <exit>
      printf("%s: write bigfile failed\n", s);
    52c0:	85d6                	mv	a1,s5
    52c2:	00003517          	auipc	a0,0x3
    52c6:	cae50513          	addi	a0,a0,-850 # 7f70 <malloc+0x1f6a>
    52ca:	00001097          	auipc	ra,0x1
    52ce:	c7e080e7          	jalr	-898(ra) # 5f48 <printf>
      exit(1);
    52d2:	4505                	li	a0,1
    52d4:	00001097          	auipc	ra,0x1
    52d8:	8f4080e7          	jalr	-1804(ra) # 5bc8 <exit>
    printf("%s: cannot open bigfile\n", s);
    52dc:	85d6                	mv	a1,s5
    52de:	00003517          	auipc	a0,0x3
    52e2:	cb250513          	addi	a0,a0,-846 # 7f90 <malloc+0x1f8a>
    52e6:	00001097          	auipc	ra,0x1
    52ea:	c62080e7          	jalr	-926(ra) # 5f48 <printf>
    exit(1);
    52ee:	4505                	li	a0,1
    52f0:	00001097          	auipc	ra,0x1
    52f4:	8d8080e7          	jalr	-1832(ra) # 5bc8 <exit>
      printf("%s: read bigfile failed\n", s);
    52f8:	85d6                	mv	a1,s5
    52fa:	00003517          	auipc	a0,0x3
    52fe:	cb650513          	addi	a0,a0,-842 # 7fb0 <malloc+0x1faa>
    5302:	00001097          	auipc	ra,0x1
    5306:	c46080e7          	jalr	-954(ra) # 5f48 <printf>
      exit(1);
    530a:	4505                	li	a0,1
    530c:	00001097          	auipc	ra,0x1
    5310:	8bc080e7          	jalr	-1860(ra) # 5bc8 <exit>
      printf("%s: short read bigfile\n", s);
    5314:	85d6                	mv	a1,s5
    5316:	00003517          	auipc	a0,0x3
    531a:	cba50513          	addi	a0,a0,-838 # 7fd0 <malloc+0x1fca>
    531e:	00001097          	auipc	ra,0x1
    5322:	c2a080e7          	jalr	-982(ra) # 5f48 <printf>
      exit(1);
    5326:	4505                	li	a0,1
    5328:	00001097          	auipc	ra,0x1
    532c:	8a0080e7          	jalr	-1888(ra) # 5bc8 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5330:	85d6                	mv	a1,s5
    5332:	00003517          	auipc	a0,0x3
    5336:	cb650513          	addi	a0,a0,-842 # 7fe8 <malloc+0x1fe2>
    533a:	00001097          	auipc	ra,0x1
    533e:	c0e080e7          	jalr	-1010(ra) # 5f48 <printf>
      exit(1);
    5342:	4505                	li	a0,1
    5344:	00001097          	auipc	ra,0x1
    5348:	884080e7          	jalr	-1916(ra) # 5bc8 <exit>
  close(fd);
    534c:	8552                	mv	a0,s4
    534e:	00001097          	auipc	ra,0x1
    5352:	8a2080e7          	jalr	-1886(ra) # 5bf0 <close>
  if(total != N*SZ){
    5356:	678d                	lui	a5,0x3
    5358:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x88>
    535c:	02f99363          	bne	s3,a5,5382 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5360:	00003517          	auipc	a0,0x3
    5364:	be050513          	addi	a0,a0,-1056 # 7f40 <malloc+0x1f3a>
    5368:	00001097          	auipc	ra,0x1
    536c:	8b0080e7          	jalr	-1872(ra) # 5c18 <unlink>
}
    5370:	70e2                	ld	ra,56(sp)
    5372:	7442                	ld	s0,48(sp)
    5374:	74a2                	ld	s1,40(sp)
    5376:	7902                	ld	s2,32(sp)
    5378:	69e2                	ld	s3,24(sp)
    537a:	6a42                	ld	s4,16(sp)
    537c:	6aa2                	ld	s5,8(sp)
    537e:	6121                	addi	sp,sp,64
    5380:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5382:	85d6                	mv	a1,s5
    5384:	00003517          	auipc	a0,0x3
    5388:	c8450513          	addi	a0,a0,-892 # 8008 <malloc+0x2002>
    538c:	00001097          	auipc	ra,0x1
    5390:	bbc080e7          	jalr	-1092(ra) # 5f48 <printf>
    exit(1);
    5394:	4505                	li	a0,1
    5396:	00001097          	auipc	ra,0x1
    539a:	832080e7          	jalr	-1998(ra) # 5bc8 <exit>

000000000000539e <fsfull>:
{
    539e:	7171                	addi	sp,sp,-176
    53a0:	f506                	sd	ra,168(sp)
    53a2:	f122                	sd	s0,160(sp)
    53a4:	ed26                	sd	s1,152(sp)
    53a6:	e94a                	sd	s2,144(sp)
    53a8:	e54e                	sd	s3,136(sp)
    53aa:	e152                	sd	s4,128(sp)
    53ac:	fcd6                	sd	s5,120(sp)
    53ae:	f8da                	sd	s6,112(sp)
    53b0:	f4de                	sd	s7,104(sp)
    53b2:	f0e2                	sd	s8,96(sp)
    53b4:	ece6                	sd	s9,88(sp)
    53b6:	e8ea                	sd	s10,80(sp)
    53b8:	e4ee                	sd	s11,72(sp)
    53ba:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	c6c50513          	addi	a0,a0,-916 # 8028 <malloc+0x2022>
    53c4:	00001097          	auipc	ra,0x1
    53c8:	b84080e7          	jalr	-1148(ra) # 5f48 <printf>
  for(nfiles = 0; ; nfiles++){
    53cc:	4481                	li	s1,0
    name[0] = 'f';
    53ce:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d2:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d6:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53da:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53dc:	00003c97          	auipc	s9,0x3
    53e0:	c5cc8c93          	addi	s9,s9,-932 # 8038 <malloc+0x2032>
    int total = 0;
    53e4:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53e6:	00008a17          	auipc	s4,0x8
    53ea:	892a0a13          	addi	s4,s4,-1902 # cc78 <buf>
    name[0] = 'f';
    53ee:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    53f2:	0384c7bb          	divw	a5,s1,s8
    53f6:	0307879b          	addiw	a5,a5,48
    53fa:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53fe:	0384e7bb          	remw	a5,s1,s8
    5402:	0377c7bb          	divw	a5,a5,s7
    5406:	0307879b          	addiw	a5,a5,48
    540a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    540e:	0374e7bb          	remw	a5,s1,s7
    5412:	0367c7bb          	divw	a5,a5,s6
    5416:	0307879b          	addiw	a5,a5,48
    541a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    541e:	0364e7bb          	remw	a5,s1,s6
    5422:	0307879b          	addiw	a5,a5,48
    5426:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    542a:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    542e:	f5040593          	addi	a1,s0,-176
    5432:	8566                	mv	a0,s9
    5434:	00001097          	auipc	ra,0x1
    5438:	b14080e7          	jalr	-1260(ra) # 5f48 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    543c:	20200593          	li	a1,514
    5440:	f5040513          	addi	a0,s0,-176
    5444:	00000097          	auipc	ra,0x0
    5448:	7c4080e7          	jalr	1988(ra) # 5c08 <open>
    544c:	892a                	mv	s2,a0
    if(fd < 0){
    544e:	0a055663          	bgez	a0,54fa <fsfull+0x15c>
      printf("open %s failed\n", name);
    5452:	f5040593          	addi	a1,s0,-176
    5456:	00003517          	auipc	a0,0x3
    545a:	bf250513          	addi	a0,a0,-1038 # 8048 <malloc+0x2042>
    545e:	00001097          	auipc	ra,0x1
    5462:	aea080e7          	jalr	-1302(ra) # 5f48 <printf>
  while(nfiles >= 0){
    5466:	0604c363          	bltz	s1,54cc <fsfull+0x12e>
    name[0] = 'f';
    546a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    546e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5472:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5476:	4929                	li	s2,10
  while(nfiles >= 0){
    5478:	5afd                	li	s5,-1
    name[0] = 'f';
    547a:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    547e:	0344c7bb          	divw	a5,s1,s4
    5482:	0307879b          	addiw	a5,a5,48
    5486:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    548a:	0344e7bb          	remw	a5,s1,s4
    548e:	0337c7bb          	divw	a5,a5,s3
    5492:	0307879b          	addiw	a5,a5,48
    5496:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    549a:	0334e7bb          	remw	a5,s1,s3
    549e:	0327c7bb          	divw	a5,a5,s2
    54a2:	0307879b          	addiw	a5,a5,48
    54a6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54aa:	0324e7bb          	remw	a5,s1,s2
    54ae:	0307879b          	addiw	a5,a5,48
    54b2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54b6:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54ba:	f5040513          	addi	a0,s0,-176
    54be:	00000097          	auipc	ra,0x0
    54c2:	75a080e7          	jalr	1882(ra) # 5c18 <unlink>
    nfiles--;
    54c6:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54c8:	fb5499e3          	bne	s1,s5,547a <fsfull+0xdc>
  printf("fsfull test finished\n");
    54cc:	00003517          	auipc	a0,0x3
    54d0:	b9c50513          	addi	a0,a0,-1124 # 8068 <malloc+0x2062>
    54d4:	00001097          	auipc	ra,0x1
    54d8:	a74080e7          	jalr	-1420(ra) # 5f48 <printf>
}
    54dc:	70aa                	ld	ra,168(sp)
    54de:	740a                	ld	s0,160(sp)
    54e0:	64ea                	ld	s1,152(sp)
    54e2:	694a                	ld	s2,144(sp)
    54e4:	69aa                	ld	s3,136(sp)
    54e6:	6a0a                	ld	s4,128(sp)
    54e8:	7ae6                	ld	s5,120(sp)
    54ea:	7b46                	ld	s6,112(sp)
    54ec:	7ba6                	ld	s7,104(sp)
    54ee:	7c06                	ld	s8,96(sp)
    54f0:	6ce6                	ld	s9,88(sp)
    54f2:	6d46                	ld	s10,80(sp)
    54f4:	6da6                	ld	s11,72(sp)
    54f6:	614d                	addi	sp,sp,176
    54f8:	8082                	ret
    int total = 0;
    54fa:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    54fc:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5500:	40000613          	li	a2,1024
    5504:	85d2                	mv	a1,s4
    5506:	854a                	mv	a0,s2
    5508:	00000097          	auipc	ra,0x0
    550c:	6e0080e7          	jalr	1760(ra) # 5be8 <write>
      if(cc < BSIZE)
    5510:	00aad563          	bge	s5,a0,551a <fsfull+0x17c>
      total += cc;
    5514:	00a989bb          	addw	s3,s3,a0
    while(1){
    5518:	b7e5                	j	5500 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    551a:	85ce                	mv	a1,s3
    551c:	00003517          	auipc	a0,0x3
    5520:	b3c50513          	addi	a0,a0,-1220 # 8058 <malloc+0x2052>
    5524:	00001097          	auipc	ra,0x1
    5528:	a24080e7          	jalr	-1500(ra) # 5f48 <printf>
    close(fd);
    552c:	854a                	mv	a0,s2
    552e:	00000097          	auipc	ra,0x0
    5532:	6c2080e7          	jalr	1730(ra) # 5bf0 <close>
    if(total == 0)
    5536:	f20988e3          	beqz	s3,5466 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    553a:	2485                	addiw	s1,s1,1
    553c:	bd4d                	j	53ee <fsfull+0x50>

000000000000553e <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553e:	7179                	addi	sp,sp,-48
    5540:	f406                	sd	ra,40(sp)
    5542:	f022                	sd	s0,32(sp)
    5544:	ec26                	sd	s1,24(sp)
    5546:	e84a                	sd	s2,16(sp)
    5548:	1800                	addi	s0,sp,48
    554a:	84aa                	mv	s1,a0
    554c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554e:	00003517          	auipc	a0,0x3
    5552:	b3250513          	addi	a0,a0,-1230 # 8080 <malloc+0x207a>
    5556:	00001097          	auipc	ra,0x1
    555a:	9f2080e7          	jalr	-1550(ra) # 5f48 <printf>
  if((pid = fork()) < 0) {
    555e:	00000097          	auipc	ra,0x0
    5562:	662080e7          	jalr	1634(ra) # 5bc0 <fork>
    5566:	02054e63          	bltz	a0,55a2 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    556a:	c929                	beqz	a0,55bc <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556c:	fdc40513          	addi	a0,s0,-36
    5570:	00000097          	auipc	ra,0x0
    5574:	660080e7          	jalr	1632(ra) # 5bd0 <wait>
    if(xstatus != 0) 
    5578:	fdc42783          	lw	a5,-36(s0)
    557c:	c7b9                	beqz	a5,55ca <run+0x8c>
      printf("FAILED\n");
    557e:	00003517          	auipc	a0,0x3
    5582:	b2a50513          	addi	a0,a0,-1238 # 80a8 <malloc+0x20a2>
    5586:	00001097          	auipc	ra,0x1
    558a:	9c2080e7          	jalr	-1598(ra) # 5f48 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558e:	fdc42503          	lw	a0,-36(s0)
  }
}
    5592:	00153513          	seqz	a0,a0
    5596:	70a2                	ld	ra,40(sp)
    5598:	7402                	ld	s0,32(sp)
    559a:	64e2                	ld	s1,24(sp)
    559c:	6942                	ld	s2,16(sp)
    559e:	6145                	addi	sp,sp,48
    55a0:	8082                	ret
    printf("runtest: fork error\n");
    55a2:	00003517          	auipc	a0,0x3
    55a6:	aee50513          	addi	a0,a0,-1298 # 8090 <malloc+0x208a>
    55aa:	00001097          	auipc	ra,0x1
    55ae:	99e080e7          	jalr	-1634(ra) # 5f48 <printf>
    exit(1);
    55b2:	4505                	li	a0,1
    55b4:	00000097          	auipc	ra,0x0
    55b8:	614080e7          	jalr	1556(ra) # 5bc8 <exit>
    f(s);
    55bc:	854a                	mv	a0,s2
    55be:	9482                	jalr	s1
    exit(0);
    55c0:	4501                	li	a0,0
    55c2:	00000097          	auipc	ra,0x0
    55c6:	606080e7          	jalr	1542(ra) # 5bc8 <exit>
      printf("OK\n");
    55ca:	00003517          	auipc	a0,0x3
    55ce:	ae650513          	addi	a0,a0,-1306 # 80b0 <malloc+0x20aa>
    55d2:	00001097          	auipc	ra,0x1
    55d6:	976080e7          	jalr	-1674(ra) # 5f48 <printf>
    55da:	bf55                	j	558e <run+0x50>

00000000000055dc <runtests>:

int
runtests(struct test *tests, char *justone) {
    55dc:	1101                	addi	sp,sp,-32
    55de:	ec06                	sd	ra,24(sp)
    55e0:	e822                	sd	s0,16(sp)
    55e2:	e426                	sd	s1,8(sp)
    55e4:	e04a                	sd	s2,0(sp)
    55e6:	1000                	addi	s0,sp,32
    55e8:	84aa                	mv	s1,a0
    55ea:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55ec:	6508                	ld	a0,8(a0)
    55ee:	ed09                	bnez	a0,5608 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55f0:	4501                	li	a0,0
    55f2:	a82d                	j	562c <runtests+0x50>
      if(!run(t->f, t->s)){
    55f4:	648c                	ld	a1,8(s1)
    55f6:	6088                	ld	a0,0(s1)
    55f8:	00000097          	auipc	ra,0x0
    55fc:	f46080e7          	jalr	-186(ra) # 553e <run>
    5600:	cd09                	beqz	a0,561a <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5602:	04c1                	addi	s1,s1,16
    5604:	6488                	ld	a0,8(s1)
    5606:	c11d                	beqz	a0,562c <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5608:	fe0906e3          	beqz	s2,55f4 <runtests+0x18>
    560c:	85ca                	mv	a1,s2
    560e:	00000097          	auipc	ra,0x0
    5612:	368080e7          	jalr	872(ra) # 5976 <strcmp>
    5616:	f575                	bnez	a0,5602 <runtests+0x26>
    5618:	bff1                	j	55f4 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    561a:	00003517          	auipc	a0,0x3
    561e:	a9e50513          	addi	a0,a0,-1378 # 80b8 <malloc+0x20b2>
    5622:	00001097          	auipc	ra,0x1
    5626:	926080e7          	jalr	-1754(ra) # 5f48 <printf>
        return 1;
    562a:	4505                	li	a0,1
}
    562c:	60e2                	ld	ra,24(sp)
    562e:	6442                	ld	s0,16(sp)
    5630:	64a2                	ld	s1,8(sp)
    5632:	6902                	ld	s2,0(sp)
    5634:	6105                	addi	sp,sp,32
    5636:	8082                	ret

0000000000005638 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5638:	7139                	addi	sp,sp,-64
    563a:	fc06                	sd	ra,56(sp)
    563c:	f822                	sd	s0,48(sp)
    563e:	f426                	sd	s1,40(sp)
    5640:	f04a                	sd	s2,32(sp)
    5642:	ec4e                	sd	s3,24(sp)
    5644:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5646:	fc840513          	addi	a0,s0,-56
    564a:	00000097          	auipc	ra,0x0
    564e:	58e080e7          	jalr	1422(ra) # 5bd8 <pipe>
    5652:	06054763          	bltz	a0,56c0 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5656:	00000097          	auipc	ra,0x0
    565a:	56a080e7          	jalr	1386(ra) # 5bc0 <fork>

  if(pid < 0){
    565e:	06054e63          	bltz	a0,56da <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5662:	ed51                	bnez	a0,56fe <countfree+0xc6>
    close(fds[0]);
    5664:	fc842503          	lw	a0,-56(s0)
    5668:	00000097          	auipc	ra,0x0
    566c:	588080e7          	jalr	1416(ra) # 5bf0 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5670:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5672:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5674:	00001997          	auipc	s3,0x1
    5678:	b4498993          	addi	s3,s3,-1212 # 61b8 <malloc+0x1b2>
      uint64 a = (uint64) sbrk(4096);
    567c:	6505                	lui	a0,0x1
    567e:	00000097          	auipc	ra,0x0
    5682:	5d2080e7          	jalr	1490(ra) # 5c50 <sbrk>
      if(a == 0xffffffffffffffff){
    5686:	07250763          	beq	a0,s2,56f4 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    568a:	6785                	lui	a5,0x1
    568c:	953e                	add	a0,a0,a5
    568e:	fe950fa3          	sb	s1,-1(a0) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5692:	8626                	mv	a2,s1
    5694:	85ce                	mv	a1,s3
    5696:	fcc42503          	lw	a0,-52(s0)
    569a:	00000097          	auipc	ra,0x0
    569e:	54e080e7          	jalr	1358(ra) # 5be8 <write>
    56a2:	fc950de3          	beq	a0,s1,567c <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a6:	00003517          	auipc	a0,0x3
    56aa:	a6a50513          	addi	a0,a0,-1430 # 8110 <malloc+0x210a>
    56ae:	00001097          	auipc	ra,0x1
    56b2:	89a080e7          	jalr	-1894(ra) # 5f48 <printf>
        exit(1);
    56b6:	4505                	li	a0,1
    56b8:	00000097          	auipc	ra,0x0
    56bc:	510080e7          	jalr	1296(ra) # 5bc8 <exit>
    printf("pipe() failed in countfree()\n");
    56c0:	00003517          	auipc	a0,0x3
    56c4:	a1050513          	addi	a0,a0,-1520 # 80d0 <malloc+0x20ca>
    56c8:	00001097          	auipc	ra,0x1
    56cc:	880080e7          	jalr	-1920(ra) # 5f48 <printf>
    exit(1);
    56d0:	4505                	li	a0,1
    56d2:	00000097          	auipc	ra,0x0
    56d6:	4f6080e7          	jalr	1270(ra) # 5bc8 <exit>
    printf("fork failed in countfree()\n");
    56da:	00003517          	auipc	a0,0x3
    56de:	a1650513          	addi	a0,a0,-1514 # 80f0 <malloc+0x20ea>
    56e2:	00001097          	auipc	ra,0x1
    56e6:	866080e7          	jalr	-1946(ra) # 5f48 <printf>
    exit(1);
    56ea:	4505                	li	a0,1
    56ec:	00000097          	auipc	ra,0x0
    56f0:	4dc080e7          	jalr	1244(ra) # 5bc8 <exit>
      }
    }

    exit(0);
    56f4:	4501                	li	a0,0
    56f6:	00000097          	auipc	ra,0x0
    56fa:	4d2080e7          	jalr	1234(ra) # 5bc8 <exit>
  }

  close(fds[1]);
    56fe:	fcc42503          	lw	a0,-52(s0)
    5702:	00000097          	auipc	ra,0x0
    5706:	4ee080e7          	jalr	1262(ra) # 5bf0 <close>

  int n = 0;
    570a:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    570c:	4605                	li	a2,1
    570e:	fc740593          	addi	a1,s0,-57
    5712:	fc842503          	lw	a0,-56(s0)
    5716:	00000097          	auipc	ra,0x0
    571a:	4ca080e7          	jalr	1226(ra) # 5be0 <read>
    if(cc < 0){
    571e:	00054563          	bltz	a0,5728 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5722:	c105                	beqz	a0,5742 <countfree+0x10a>
      break;
    n += 1;
    5724:	2485                	addiw	s1,s1,1
  while(1){
    5726:	b7dd                	j	570c <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5728:	00003517          	auipc	a0,0x3
    572c:	a0850513          	addi	a0,a0,-1528 # 8130 <malloc+0x212a>
    5730:	00001097          	auipc	ra,0x1
    5734:	818080e7          	jalr	-2024(ra) # 5f48 <printf>
      exit(1);
    5738:	4505                	li	a0,1
    573a:	00000097          	auipc	ra,0x0
    573e:	48e080e7          	jalr	1166(ra) # 5bc8 <exit>
  }

  close(fds[0]);
    5742:	fc842503          	lw	a0,-56(s0)
    5746:	00000097          	auipc	ra,0x0
    574a:	4aa080e7          	jalr	1194(ra) # 5bf0 <close>
  wait((int*)0);
    574e:	4501                	li	a0,0
    5750:	00000097          	auipc	ra,0x0
    5754:	480080e7          	jalr	1152(ra) # 5bd0 <wait>
  
  return n;
}
    5758:	8526                	mv	a0,s1
    575a:	70e2                	ld	ra,56(sp)
    575c:	7442                	ld	s0,48(sp)
    575e:	74a2                	ld	s1,40(sp)
    5760:	7902                	ld	s2,32(sp)
    5762:	69e2                	ld	s3,24(sp)
    5764:	6121                	addi	sp,sp,64
    5766:	8082                	ret

0000000000005768 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5768:	711d                	addi	sp,sp,-96
    576a:	ec86                	sd	ra,88(sp)
    576c:	e8a2                	sd	s0,80(sp)
    576e:	e4a6                	sd	s1,72(sp)
    5770:	e0ca                	sd	s2,64(sp)
    5772:	fc4e                	sd	s3,56(sp)
    5774:	f852                	sd	s4,48(sp)
    5776:	f456                	sd	s5,40(sp)
    5778:	f05a                	sd	s6,32(sp)
    577a:	ec5e                	sd	s7,24(sp)
    577c:	e862                	sd	s8,16(sp)
    577e:	e466                	sd	s9,8(sp)
    5780:	e06a                	sd	s10,0(sp)
    5782:	1080                	addi	s0,sp,96
    5784:	8a2a                	mv	s4,a0
    5786:	89ae                	mv	s3,a1
    5788:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    578a:	00003b97          	auipc	s7,0x3
    578e:	9c6b8b93          	addi	s7,s7,-1594 # 8150 <malloc+0x214a>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5792:	00004b17          	auipc	s6,0x4
    5796:	87eb0b13          	addi	s6,s6,-1922 # 9010 <quicktests>
      if(continuous != 2) {
    579a:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    579c:	00003c97          	auipc	s9,0x3
    57a0:	9ecc8c93          	addi	s9,s9,-1556 # 8188 <malloc+0x2182>
      if (runtests(slowtests, justone)) {
    57a4:	00004c17          	auipc	s8,0x4
    57a8:	c3cc0c13          	addi	s8,s8,-964 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57ac:	00003d17          	auipc	s10,0x3
    57b0:	9bcd0d13          	addi	s10,s10,-1604 # 8168 <malloc+0x2162>
    57b4:	a839                	j	57d2 <drivetests+0x6a>
    57b6:	856a                	mv	a0,s10
    57b8:	00000097          	auipc	ra,0x0
    57bc:	790080e7          	jalr	1936(ra) # 5f48 <printf>
    57c0:	a081                	j	5800 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57c2:	00000097          	auipc	ra,0x0
    57c6:	e76080e7          	jalr	-394(ra) # 5638 <countfree>
    57ca:	06954263          	blt	a0,s1,582e <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57ce:	06098f63          	beqz	s3,584c <drivetests+0xe4>
    printf("usertests starting\n");
    57d2:	855e                	mv	a0,s7
    57d4:	00000097          	auipc	ra,0x0
    57d8:	774080e7          	jalr	1908(ra) # 5f48 <printf>
    int free0 = countfree();
    57dc:	00000097          	auipc	ra,0x0
    57e0:	e5c080e7          	jalr	-420(ra) # 5638 <countfree>
    57e4:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e6:	85ca                	mv	a1,s2
    57e8:	855a                	mv	a0,s6
    57ea:	00000097          	auipc	ra,0x0
    57ee:	df2080e7          	jalr	-526(ra) # 55dc <runtests>
    57f2:	c119                	beqz	a0,57f8 <drivetests+0x90>
      if(continuous != 2) {
    57f4:	05599863          	bne	s3,s5,5844 <drivetests+0xdc>
    if(!quick) {
    57f8:	fc0a15e3          	bnez	s4,57c2 <drivetests+0x5a>
      if (justone == 0)
    57fc:	fa090de3          	beqz	s2,57b6 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5800:	85ca                	mv	a1,s2
    5802:	8562                	mv	a0,s8
    5804:	00000097          	auipc	ra,0x0
    5808:	dd8080e7          	jalr	-552(ra) # 55dc <runtests>
    580c:	d95d                	beqz	a0,57c2 <drivetests+0x5a>
        if(continuous != 2) {
    580e:	03599d63          	bne	s3,s5,5848 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5812:	00000097          	auipc	ra,0x0
    5816:	e26080e7          	jalr	-474(ra) # 5638 <countfree>
    581a:	fa955ae3          	bge	a0,s1,57ce <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    581e:	8626                	mv	a2,s1
    5820:	85aa                	mv	a1,a0
    5822:	8566                	mv	a0,s9
    5824:	00000097          	auipc	ra,0x0
    5828:	724080e7          	jalr	1828(ra) # 5f48 <printf>
      if(continuous != 2) {
    582c:	b75d                	j	57d2 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582e:	8626                	mv	a2,s1
    5830:	85aa                	mv	a1,a0
    5832:	8566                	mv	a0,s9
    5834:	00000097          	auipc	ra,0x0
    5838:	714080e7          	jalr	1812(ra) # 5f48 <printf>
      if(continuous != 2) {
    583c:	f9598be3          	beq	s3,s5,57d2 <drivetests+0x6a>
        return 1;
    5840:	4505                	li	a0,1
    5842:	a031                	j	584e <drivetests+0xe6>
        return 1;
    5844:	4505                	li	a0,1
    5846:	a021                	j	584e <drivetests+0xe6>
          return 1;
    5848:	4505                	li	a0,1
    584a:	a011                	j	584e <drivetests+0xe6>
  return 0;
    584c:	854e                	mv	a0,s3
}
    584e:	60e6                	ld	ra,88(sp)
    5850:	6446                	ld	s0,80(sp)
    5852:	64a6                	ld	s1,72(sp)
    5854:	6906                	ld	s2,64(sp)
    5856:	79e2                	ld	s3,56(sp)
    5858:	7a42                	ld	s4,48(sp)
    585a:	7aa2                	ld	s5,40(sp)
    585c:	7b02                	ld	s6,32(sp)
    585e:	6be2                	ld	s7,24(sp)
    5860:	6c42                	ld	s8,16(sp)
    5862:	6ca2                	ld	s9,8(sp)
    5864:	6d02                	ld	s10,0(sp)
    5866:	6125                	addi	sp,sp,96
    5868:	8082                	ret

000000000000586a <main>:

int
main(int argc, char *argv[])
{
    586a:	1101                	addi	sp,sp,-32
    586c:	ec06                	sd	ra,24(sp)
    586e:	e822                	sd	s0,16(sp)
    5870:	e426                	sd	s1,8(sp)
    5872:	e04a                	sd	s2,0(sp)
    5874:	1000                	addi	s0,sp,32
    5876:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5878:	4789                	li	a5,2
    587a:	02f50363          	beq	a0,a5,58a0 <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    587e:	4785                	li	a5,1
    5880:	06a7cd63          	blt	a5,a0,58fa <main+0x90>
  char *justone = 0;
    5884:	4601                	li	a2,0
  int quick = 0;
    5886:	4501                	li	a0,0
  int continuous = 0;
    5888:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    588a:	85a6                	mv	a1,s1
    588c:	00000097          	auipc	ra,0x0
    5890:	edc080e7          	jalr	-292(ra) # 5768 <drivetests>
    5894:	c949                	beqz	a0,5926 <main+0xbc>
    exit(1);
    5896:	4505                	li	a0,1
    5898:	00000097          	auipc	ra,0x0
    589c:	330080e7          	jalr	816(ra) # 5bc8 <exit>
    58a0:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a2:	00003597          	auipc	a1,0x3
    58a6:	91658593          	addi	a1,a1,-1770 # 81b8 <malloc+0x21b2>
    58aa:	00893503          	ld	a0,8(s2)
    58ae:	00000097          	auipc	ra,0x0
    58b2:	0c8080e7          	jalr	200(ra) # 5976 <strcmp>
    58b6:	cd39                	beqz	a0,5914 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b8:	00003597          	auipc	a1,0x3
    58bc:	95858593          	addi	a1,a1,-1704 # 8210 <malloc+0x220a>
    58c0:	00893503          	ld	a0,8(s2)
    58c4:	00000097          	auipc	ra,0x0
    58c8:	0b2080e7          	jalr	178(ra) # 5976 <strcmp>
    58cc:	c931                	beqz	a0,5920 <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58ce:	00003597          	auipc	a1,0x3
    58d2:	93a58593          	addi	a1,a1,-1734 # 8208 <malloc+0x2202>
    58d6:	00893503          	ld	a0,8(s2)
    58da:	00000097          	auipc	ra,0x0
    58de:	09c080e7          	jalr	156(ra) # 5976 <strcmp>
    58e2:	cd0d                	beqz	a0,591c <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e4:	00893603          	ld	a2,8(s2)
    58e8:	00064703          	lbu	a4,0(a2) # 3000 <execout+0xa0>
    58ec:	02d00793          	li	a5,45
    58f0:	00f70563          	beq	a4,a5,58fa <main+0x90>
  int quick = 0;
    58f4:	4501                	li	a0,0
  int continuous = 0;
    58f6:	4481                	li	s1,0
    58f8:	bf49                	j	588a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58fa:	00003517          	auipc	a0,0x3
    58fe:	8c650513          	addi	a0,a0,-1850 # 81c0 <malloc+0x21ba>
    5902:	00000097          	auipc	ra,0x0
    5906:	646080e7          	jalr	1606(ra) # 5f48 <printf>
    exit(1);
    590a:	4505                	li	a0,1
    590c:	00000097          	auipc	ra,0x0
    5910:	2bc080e7          	jalr	700(ra) # 5bc8 <exit>
  int continuous = 0;
    5914:	84aa                	mv	s1,a0
  char *justone = 0;
    5916:	4601                	li	a2,0
    quick = 1;
    5918:	4505                	li	a0,1
    591a:	bf85                	j	588a <main+0x20>
  char *justone = 0;
    591c:	4601                	li	a2,0
    591e:	b7b5                	j	588a <main+0x20>
    5920:	4601                	li	a2,0
    continuous = 1;
    5922:	4485                	li	s1,1
    5924:	b79d                	j	588a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5926:	00003517          	auipc	a0,0x3
    592a:	8ca50513          	addi	a0,a0,-1846 # 81f0 <malloc+0x21ea>
    592e:	00000097          	auipc	ra,0x0
    5932:	61a080e7          	jalr	1562(ra) # 5f48 <printf>
  exit(0);
    5936:	4501                	li	a0,0
    5938:	00000097          	auipc	ra,0x0
    593c:	290080e7          	jalr	656(ra) # 5bc8 <exit>

0000000000005940 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5940:	1141                	addi	sp,sp,-16
    5942:	e406                	sd	ra,8(sp)
    5944:	e022                	sd	s0,0(sp)
    5946:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5948:	00000097          	auipc	ra,0x0
    594c:	f22080e7          	jalr	-222(ra) # 586a <main>
  exit(0);
    5950:	4501                	li	a0,0
    5952:	00000097          	auipc	ra,0x0
    5956:	276080e7          	jalr	630(ra) # 5bc8 <exit>

000000000000595a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    595a:	1141                	addi	sp,sp,-16
    595c:	e422                	sd	s0,8(sp)
    595e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5960:	87aa                	mv	a5,a0
    5962:	0585                	addi	a1,a1,1
    5964:	0785                	addi	a5,a5,1 # 1001 <linktest+0x10b>
    5966:	fff5c703          	lbu	a4,-1(a1)
    596a:	fee78fa3          	sb	a4,-1(a5)
    596e:	fb75                	bnez	a4,5962 <strcpy+0x8>
    ;
  return os;
}
    5970:	6422                	ld	s0,8(sp)
    5972:	0141                	addi	sp,sp,16
    5974:	8082                	ret

0000000000005976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5976:	1141                	addi	sp,sp,-16
    5978:	e422                	sd	s0,8(sp)
    597a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    597c:	00054783          	lbu	a5,0(a0)
    5980:	cb91                	beqz	a5,5994 <strcmp+0x1e>
    5982:	0005c703          	lbu	a4,0(a1)
    5986:	00f71763          	bne	a4,a5,5994 <strcmp+0x1e>
    p++, q++;
    598a:	0505                	addi	a0,a0,1
    598c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    598e:	00054783          	lbu	a5,0(a0)
    5992:	fbe5                	bnez	a5,5982 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5994:	0005c503          	lbu	a0,0(a1)
}
    5998:	40a7853b          	subw	a0,a5,a0
    599c:	6422                	ld	s0,8(sp)
    599e:	0141                	addi	sp,sp,16
    59a0:	8082                	ret

00000000000059a2 <strlen>:

uint
strlen(const char *s)
{
    59a2:	1141                	addi	sp,sp,-16
    59a4:	e422                	sd	s0,8(sp)
    59a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59a8:	00054783          	lbu	a5,0(a0)
    59ac:	cf91                	beqz	a5,59c8 <strlen+0x26>
    59ae:	0505                	addi	a0,a0,1
    59b0:	87aa                	mv	a5,a0
    59b2:	4685                	li	a3,1
    59b4:	9e89                	subw	a3,a3,a0
    59b6:	00f6853b          	addw	a0,a3,a5
    59ba:	0785                	addi	a5,a5,1
    59bc:	fff7c703          	lbu	a4,-1(a5)
    59c0:	fb7d                	bnez	a4,59b6 <strlen+0x14>
    ;
  return n;
}
    59c2:	6422                	ld	s0,8(sp)
    59c4:	0141                	addi	sp,sp,16
    59c6:	8082                	ret
  for(n = 0; s[n]; n++)
    59c8:	4501                	li	a0,0
    59ca:	bfe5                	j	59c2 <strlen+0x20>

00000000000059cc <memset>:

void*
memset(void *dst, int c, uint n)
{
    59cc:	1141                	addi	sp,sp,-16
    59ce:	e422                	sd	s0,8(sp)
    59d0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59d2:	ca19                	beqz	a2,59e8 <memset+0x1c>
    59d4:	87aa                	mv	a5,a0
    59d6:	1602                	slli	a2,a2,0x20
    59d8:	9201                	srli	a2,a2,0x20
    59da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59e2:	0785                	addi	a5,a5,1
    59e4:	fee79de3          	bne	a5,a4,59de <memset+0x12>
  }
  return dst;
}
    59e8:	6422                	ld	s0,8(sp)
    59ea:	0141                	addi	sp,sp,16
    59ec:	8082                	ret

00000000000059ee <strchr>:

char*
strchr(const char *s, char c)
{
    59ee:	1141                	addi	sp,sp,-16
    59f0:	e422                	sd	s0,8(sp)
    59f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59f4:	00054783          	lbu	a5,0(a0)
    59f8:	cb99                	beqz	a5,5a0e <strchr+0x20>
    if(*s == c)
    59fa:	00f58763          	beq	a1,a5,5a08 <strchr+0x1a>
  for(; *s; s++)
    59fe:	0505                	addi	a0,a0,1
    5a00:	00054783          	lbu	a5,0(a0)
    5a04:	fbfd                	bnez	a5,59fa <strchr+0xc>
      return (char*)s;
  return 0;
    5a06:	4501                	li	a0,0
}
    5a08:	6422                	ld	s0,8(sp)
    5a0a:	0141                	addi	sp,sp,16
    5a0c:	8082                	ret
  return 0;
    5a0e:	4501                	li	a0,0
    5a10:	bfe5                	j	5a08 <strchr+0x1a>

0000000000005a12 <gets>:

char*
gets(char *buf, int max)
{
    5a12:	711d                	addi	sp,sp,-96
    5a14:	ec86                	sd	ra,88(sp)
    5a16:	e8a2                	sd	s0,80(sp)
    5a18:	e4a6                	sd	s1,72(sp)
    5a1a:	e0ca                	sd	s2,64(sp)
    5a1c:	fc4e                	sd	s3,56(sp)
    5a1e:	f852                	sd	s4,48(sp)
    5a20:	f456                	sd	s5,40(sp)
    5a22:	f05a                	sd	s6,32(sp)
    5a24:	ec5e                	sd	s7,24(sp)
    5a26:	1080                	addi	s0,sp,96
    5a28:	8baa                	mv	s7,a0
    5a2a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a2c:	892a                	mv	s2,a0
    5a2e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a30:	4aa9                	li	s5,10
    5a32:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a34:	89a6                	mv	s3,s1
    5a36:	2485                	addiw	s1,s1,1
    5a38:	0344d863          	bge	s1,s4,5a68 <gets+0x56>
    cc = read(0, &c, 1);
    5a3c:	4605                	li	a2,1
    5a3e:	faf40593          	addi	a1,s0,-81
    5a42:	4501                	li	a0,0
    5a44:	00000097          	auipc	ra,0x0
    5a48:	19c080e7          	jalr	412(ra) # 5be0 <read>
    if(cc < 1)
    5a4c:	00a05e63          	blez	a0,5a68 <gets+0x56>
    buf[i++] = c;
    5a50:	faf44783          	lbu	a5,-81(s0)
    5a54:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a58:	01578763          	beq	a5,s5,5a66 <gets+0x54>
    5a5c:	0905                	addi	s2,s2,1
    5a5e:	fd679be3          	bne	a5,s6,5a34 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a62:	89a6                	mv	s3,s1
    5a64:	a011                	j	5a68 <gets+0x56>
    5a66:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a68:	99de                	add	s3,s3,s7
    5a6a:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a6e:	855e                	mv	a0,s7
    5a70:	60e6                	ld	ra,88(sp)
    5a72:	6446                	ld	s0,80(sp)
    5a74:	64a6                	ld	s1,72(sp)
    5a76:	6906                	ld	s2,64(sp)
    5a78:	79e2                	ld	s3,56(sp)
    5a7a:	7a42                	ld	s4,48(sp)
    5a7c:	7aa2                	ld	s5,40(sp)
    5a7e:	7b02                	ld	s6,32(sp)
    5a80:	6be2                	ld	s7,24(sp)
    5a82:	6125                	addi	sp,sp,96
    5a84:	8082                	ret

0000000000005a86 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a86:	1101                	addi	sp,sp,-32
    5a88:	ec06                	sd	ra,24(sp)
    5a8a:	e822                	sd	s0,16(sp)
    5a8c:	e426                	sd	s1,8(sp)
    5a8e:	e04a                	sd	s2,0(sp)
    5a90:	1000                	addi	s0,sp,32
    5a92:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a94:	4581                	li	a1,0
    5a96:	00000097          	auipc	ra,0x0
    5a9a:	172080e7          	jalr	370(ra) # 5c08 <open>
  if(fd < 0)
    5a9e:	02054563          	bltz	a0,5ac8 <stat+0x42>
    5aa2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5aa4:	85ca                	mv	a1,s2
    5aa6:	00000097          	auipc	ra,0x0
    5aaa:	17a080e7          	jalr	378(ra) # 5c20 <fstat>
    5aae:	892a                	mv	s2,a0
  close(fd);
    5ab0:	8526                	mv	a0,s1
    5ab2:	00000097          	auipc	ra,0x0
    5ab6:	13e080e7          	jalr	318(ra) # 5bf0 <close>
  return r;
}
    5aba:	854a                	mv	a0,s2
    5abc:	60e2                	ld	ra,24(sp)
    5abe:	6442                	ld	s0,16(sp)
    5ac0:	64a2                	ld	s1,8(sp)
    5ac2:	6902                	ld	s2,0(sp)
    5ac4:	6105                	addi	sp,sp,32
    5ac6:	8082                	ret
    return -1;
    5ac8:	597d                	li	s2,-1
    5aca:	bfc5                	j	5aba <stat+0x34>

0000000000005acc <atoi>:

int
atoi(const char *s)
{
    5acc:	1141                	addi	sp,sp,-16
    5ace:	e422                	sd	s0,8(sp)
    5ad0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ad2:	00054603          	lbu	a2,0(a0)
    5ad6:	fd06079b          	addiw	a5,a2,-48
    5ada:	0ff7f793          	zext.b	a5,a5
    5ade:	4725                	li	a4,9
    5ae0:	02f76963          	bltu	a4,a5,5b12 <atoi+0x46>
    5ae4:	86aa                	mv	a3,a0
  n = 0;
    5ae6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5ae8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5aea:	0685                	addi	a3,a3,1
    5aec:	0025179b          	slliw	a5,a0,0x2
    5af0:	9fa9                	addw	a5,a5,a0
    5af2:	0017979b          	slliw	a5,a5,0x1
    5af6:	9fb1                	addw	a5,a5,a2
    5af8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5afc:	0006c603          	lbu	a2,0(a3)
    5b00:	fd06071b          	addiw	a4,a2,-48
    5b04:	0ff77713          	zext.b	a4,a4
    5b08:	fee5f1e3          	bgeu	a1,a4,5aea <atoi+0x1e>
  return n;
}
    5b0c:	6422                	ld	s0,8(sp)
    5b0e:	0141                	addi	sp,sp,16
    5b10:	8082                	ret
  n = 0;
    5b12:	4501                	li	a0,0
    5b14:	bfe5                	j	5b0c <atoi+0x40>

0000000000005b16 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b16:	1141                	addi	sp,sp,-16
    5b18:	e422                	sd	s0,8(sp)
    5b1a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b1c:	02b57463          	bgeu	a0,a1,5b44 <memmove+0x2e>
    while(n-- > 0)
    5b20:	00c05f63          	blez	a2,5b3e <memmove+0x28>
    5b24:	1602                	slli	a2,a2,0x20
    5b26:	9201                	srli	a2,a2,0x20
    5b28:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b2c:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b2e:	0585                	addi	a1,a1,1
    5b30:	0705                	addi	a4,a4,1
    5b32:	fff5c683          	lbu	a3,-1(a1)
    5b36:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b3a:	fee79ae3          	bne	a5,a4,5b2e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b3e:	6422                	ld	s0,8(sp)
    5b40:	0141                	addi	sp,sp,16
    5b42:	8082                	ret
    dst += n;
    5b44:	00c50733          	add	a4,a0,a2
    src += n;
    5b48:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b4a:	fec05ae3          	blez	a2,5b3e <memmove+0x28>
    5b4e:	fff6079b          	addiw	a5,a2,-1
    5b52:	1782                	slli	a5,a5,0x20
    5b54:	9381                	srli	a5,a5,0x20
    5b56:	fff7c793          	not	a5,a5
    5b5a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b5c:	15fd                	addi	a1,a1,-1
    5b5e:	177d                	addi	a4,a4,-1
    5b60:	0005c683          	lbu	a3,0(a1)
    5b64:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b68:	fee79ae3          	bne	a5,a4,5b5c <memmove+0x46>
    5b6c:	bfc9                	j	5b3e <memmove+0x28>

0000000000005b6e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b6e:	1141                	addi	sp,sp,-16
    5b70:	e422                	sd	s0,8(sp)
    5b72:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b74:	ca05                	beqz	a2,5ba4 <memcmp+0x36>
    5b76:	fff6069b          	addiw	a3,a2,-1
    5b7a:	1682                	slli	a3,a3,0x20
    5b7c:	9281                	srli	a3,a3,0x20
    5b7e:	0685                	addi	a3,a3,1
    5b80:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b82:	00054783          	lbu	a5,0(a0)
    5b86:	0005c703          	lbu	a4,0(a1)
    5b8a:	00e79863          	bne	a5,a4,5b9a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b8e:	0505                	addi	a0,a0,1
    p2++;
    5b90:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b92:	fed518e3          	bne	a0,a3,5b82 <memcmp+0x14>
  }
  return 0;
    5b96:	4501                	li	a0,0
    5b98:	a019                	j	5b9e <memcmp+0x30>
      return *p1 - *p2;
    5b9a:	40e7853b          	subw	a0,a5,a4
}
    5b9e:	6422                	ld	s0,8(sp)
    5ba0:	0141                	addi	sp,sp,16
    5ba2:	8082                	ret
  return 0;
    5ba4:	4501                	li	a0,0
    5ba6:	bfe5                	j	5b9e <memcmp+0x30>

0000000000005ba8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5ba8:	1141                	addi	sp,sp,-16
    5baa:	e406                	sd	ra,8(sp)
    5bac:	e022                	sd	s0,0(sp)
    5bae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bb0:	00000097          	auipc	ra,0x0
    5bb4:	f66080e7          	jalr	-154(ra) # 5b16 <memmove>
}
    5bb8:	60a2                	ld	ra,8(sp)
    5bba:	6402                	ld	s0,0(sp)
    5bbc:	0141                	addi	sp,sp,16
    5bbe:	8082                	ret

0000000000005bc0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bc0:	4885                	li	a7,1
 ecall
    5bc2:	00000073          	ecall
 ret
    5bc6:	8082                	ret

0000000000005bc8 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bc8:	4889                	li	a7,2
 ecall
    5bca:	00000073          	ecall
 ret
    5bce:	8082                	ret

0000000000005bd0 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bd0:	488d                	li	a7,3
 ecall
    5bd2:	00000073          	ecall
 ret
    5bd6:	8082                	ret

0000000000005bd8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bd8:	4891                	li	a7,4
 ecall
    5bda:	00000073          	ecall
 ret
    5bde:	8082                	ret

0000000000005be0 <read>:
.global read
read:
 li a7, SYS_read
    5be0:	4895                	li	a7,5
 ecall
    5be2:	00000073          	ecall
 ret
    5be6:	8082                	ret

0000000000005be8 <write>:
.global write
write:
 li a7, SYS_write
    5be8:	48c1                	li	a7,16
 ecall
    5bea:	00000073          	ecall
 ret
    5bee:	8082                	ret

0000000000005bf0 <close>:
.global close
close:
 li a7, SYS_close
    5bf0:	48d5                	li	a7,21
 ecall
    5bf2:	00000073          	ecall
 ret
    5bf6:	8082                	ret

0000000000005bf8 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bf8:	4899                	li	a7,6
 ecall
    5bfa:	00000073          	ecall
 ret
    5bfe:	8082                	ret

0000000000005c00 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c00:	489d                	li	a7,7
 ecall
    5c02:	00000073          	ecall
 ret
    5c06:	8082                	ret

0000000000005c08 <open>:
.global open
open:
 li a7, SYS_open
    5c08:	48bd                	li	a7,15
 ecall
    5c0a:	00000073          	ecall
 ret
    5c0e:	8082                	ret

0000000000005c10 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c10:	48c5                	li	a7,17
 ecall
    5c12:	00000073          	ecall
 ret
    5c16:	8082                	ret

0000000000005c18 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c18:	48c9                	li	a7,18
 ecall
    5c1a:	00000073          	ecall
 ret
    5c1e:	8082                	ret

0000000000005c20 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c20:	48a1                	li	a7,8
 ecall
    5c22:	00000073          	ecall
 ret
    5c26:	8082                	ret

0000000000005c28 <link>:
.global link
link:
 li a7, SYS_link
    5c28:	48cd                	li	a7,19
 ecall
    5c2a:	00000073          	ecall
 ret
    5c2e:	8082                	ret

0000000000005c30 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c30:	48d1                	li	a7,20
 ecall
    5c32:	00000073          	ecall
 ret
    5c36:	8082                	ret

0000000000005c38 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c38:	48a5                	li	a7,9
 ecall
    5c3a:	00000073          	ecall
 ret
    5c3e:	8082                	ret

0000000000005c40 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c40:	48a9                	li	a7,10
 ecall
    5c42:	00000073          	ecall
 ret
    5c46:	8082                	ret

0000000000005c48 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c48:	48ad                	li	a7,11
 ecall
    5c4a:	00000073          	ecall
 ret
    5c4e:	8082                	ret

0000000000005c50 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c50:	48b1                	li	a7,12
 ecall
    5c52:	00000073          	ecall
 ret
    5c56:	8082                	ret

0000000000005c58 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c58:	48b5                	li	a7,13
 ecall
    5c5a:	00000073          	ecall
 ret
    5c5e:	8082                	ret

0000000000005c60 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c60:	48b9                	li	a7,14
 ecall
    5c62:	00000073          	ecall
 ret
    5c66:	8082                	ret

0000000000005c68 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c68:	48d9                	li	a7,22
 ecall
    5c6a:	00000073          	ecall
 ret
    5c6e:	8082                	ret

0000000000005c70 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c70:	1101                	addi	sp,sp,-32
    5c72:	ec06                	sd	ra,24(sp)
    5c74:	e822                	sd	s0,16(sp)
    5c76:	1000                	addi	s0,sp,32
    5c78:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c7c:	4605                	li	a2,1
    5c7e:	fef40593          	addi	a1,s0,-17
    5c82:	00000097          	auipc	ra,0x0
    5c86:	f66080e7          	jalr	-154(ra) # 5be8 <write>
}
    5c8a:	60e2                	ld	ra,24(sp)
    5c8c:	6442                	ld	s0,16(sp)
    5c8e:	6105                	addi	sp,sp,32
    5c90:	8082                	ret

0000000000005c92 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c92:	7139                	addi	sp,sp,-64
    5c94:	fc06                	sd	ra,56(sp)
    5c96:	f822                	sd	s0,48(sp)
    5c98:	f426                	sd	s1,40(sp)
    5c9a:	f04a                	sd	s2,32(sp)
    5c9c:	ec4e                	sd	s3,24(sp)
    5c9e:	0080                	addi	s0,sp,64
    5ca0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5ca2:	c299                	beqz	a3,5ca8 <printint+0x16>
    5ca4:	0805c863          	bltz	a1,5d34 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5ca8:	2581                	sext.w	a1,a1
  neg = 0;
    5caa:	4881                	li	a7,0
    5cac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cb0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cb2:	2601                	sext.w	a2,a2
    5cb4:	00003517          	auipc	a0,0x3
    5cb8:	8cc50513          	addi	a0,a0,-1844 # 8580 <digits>
    5cbc:	883a                	mv	a6,a4
    5cbe:	2705                	addiw	a4,a4,1
    5cc0:	02c5f7bb          	remuw	a5,a1,a2
    5cc4:	1782                	slli	a5,a5,0x20
    5cc6:	9381                	srli	a5,a5,0x20
    5cc8:	97aa                	add	a5,a5,a0
    5cca:	0007c783          	lbu	a5,0(a5)
    5cce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cd2:	0005879b          	sext.w	a5,a1
    5cd6:	02c5d5bb          	divuw	a1,a1,a2
    5cda:	0685                	addi	a3,a3,1
    5cdc:	fec7f0e3          	bgeu	a5,a2,5cbc <printint+0x2a>
  if(neg)
    5ce0:	00088b63          	beqz	a7,5cf6 <printint+0x64>
    buf[i++] = '-';
    5ce4:	fd040793          	addi	a5,s0,-48
    5ce8:	973e                	add	a4,a4,a5
    5cea:	02d00793          	li	a5,45
    5cee:	fef70823          	sb	a5,-16(a4)
    5cf2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cf6:	02e05863          	blez	a4,5d26 <printint+0x94>
    5cfa:	fc040793          	addi	a5,s0,-64
    5cfe:	00e78933          	add	s2,a5,a4
    5d02:	fff78993          	addi	s3,a5,-1
    5d06:	99ba                	add	s3,s3,a4
    5d08:	377d                	addiw	a4,a4,-1
    5d0a:	1702                	slli	a4,a4,0x20
    5d0c:	9301                	srli	a4,a4,0x20
    5d0e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d12:	fff94583          	lbu	a1,-1(s2)
    5d16:	8526                	mv	a0,s1
    5d18:	00000097          	auipc	ra,0x0
    5d1c:	f58080e7          	jalr	-168(ra) # 5c70 <putc>
  while(--i >= 0)
    5d20:	197d                	addi	s2,s2,-1
    5d22:	ff3918e3          	bne	s2,s3,5d12 <printint+0x80>
}
    5d26:	70e2                	ld	ra,56(sp)
    5d28:	7442                	ld	s0,48(sp)
    5d2a:	74a2                	ld	s1,40(sp)
    5d2c:	7902                	ld	s2,32(sp)
    5d2e:	69e2                	ld	s3,24(sp)
    5d30:	6121                	addi	sp,sp,64
    5d32:	8082                	ret
    x = -xx;
    5d34:	40b005bb          	negw	a1,a1
    neg = 1;
    5d38:	4885                	li	a7,1
    x = -xx;
    5d3a:	bf8d                	j	5cac <printint+0x1a>

0000000000005d3c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d3c:	7119                	addi	sp,sp,-128
    5d3e:	fc86                	sd	ra,120(sp)
    5d40:	f8a2                	sd	s0,112(sp)
    5d42:	f4a6                	sd	s1,104(sp)
    5d44:	f0ca                	sd	s2,96(sp)
    5d46:	ecce                	sd	s3,88(sp)
    5d48:	e8d2                	sd	s4,80(sp)
    5d4a:	e4d6                	sd	s5,72(sp)
    5d4c:	e0da                	sd	s6,64(sp)
    5d4e:	fc5e                	sd	s7,56(sp)
    5d50:	f862                	sd	s8,48(sp)
    5d52:	f466                	sd	s9,40(sp)
    5d54:	f06a                	sd	s10,32(sp)
    5d56:	ec6e                	sd	s11,24(sp)
    5d58:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d5a:	0005c903          	lbu	s2,0(a1)
    5d5e:	18090f63          	beqz	s2,5efc <vprintf+0x1c0>
    5d62:	8aaa                	mv	s5,a0
    5d64:	8b32                	mv	s6,a2
    5d66:	00158493          	addi	s1,a1,1
  state = 0;
    5d6a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d6c:	02500a13          	li	s4,37
      if(c == 'd'){
    5d70:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5d74:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5d78:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5d7c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d80:	00003b97          	auipc	s7,0x3
    5d84:	800b8b93          	addi	s7,s7,-2048 # 8580 <digits>
    5d88:	a839                	j	5da6 <vprintf+0x6a>
        putc(fd, c);
    5d8a:	85ca                	mv	a1,s2
    5d8c:	8556                	mv	a0,s5
    5d8e:	00000097          	auipc	ra,0x0
    5d92:	ee2080e7          	jalr	-286(ra) # 5c70 <putc>
    5d96:	a019                	j	5d9c <vprintf+0x60>
    } else if(state == '%'){
    5d98:	01498f63          	beq	s3,s4,5db6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5d9c:	0485                	addi	s1,s1,1
    5d9e:	fff4c903          	lbu	s2,-1(s1)
    5da2:	14090d63          	beqz	s2,5efc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5da6:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5daa:	fe0997e3          	bnez	s3,5d98 <vprintf+0x5c>
      if(c == '%'){
    5dae:	fd479ee3          	bne	a5,s4,5d8a <vprintf+0x4e>
        state = '%';
    5db2:	89be                	mv	s3,a5
    5db4:	b7e5                	j	5d9c <vprintf+0x60>
      if(c == 'd'){
    5db6:	05878063          	beq	a5,s8,5df6 <vprintf+0xba>
      } else if(c == 'l') {
    5dba:	05978c63          	beq	a5,s9,5e12 <vprintf+0xd6>
      } else if(c == 'x') {
    5dbe:	07a78863          	beq	a5,s10,5e2e <vprintf+0xf2>
      } else if(c == 'p') {
    5dc2:	09b78463          	beq	a5,s11,5e4a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5dc6:	07300713          	li	a4,115
    5dca:	0ce78663          	beq	a5,a4,5e96 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5dce:	06300713          	li	a4,99
    5dd2:	0ee78e63          	beq	a5,a4,5ece <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5dd6:	11478863          	beq	a5,s4,5ee6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5dda:	85d2                	mv	a1,s4
    5ddc:	8556                	mv	a0,s5
    5dde:	00000097          	auipc	ra,0x0
    5de2:	e92080e7          	jalr	-366(ra) # 5c70 <putc>
        putc(fd, c);
    5de6:	85ca                	mv	a1,s2
    5de8:	8556                	mv	a0,s5
    5dea:	00000097          	auipc	ra,0x0
    5dee:	e86080e7          	jalr	-378(ra) # 5c70 <putc>
      }
      state = 0;
    5df2:	4981                	li	s3,0
    5df4:	b765                	j	5d9c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5df6:	008b0913          	addi	s2,s6,8
    5dfa:	4685                	li	a3,1
    5dfc:	4629                	li	a2,10
    5dfe:	000b2583          	lw	a1,0(s6)
    5e02:	8556                	mv	a0,s5
    5e04:	00000097          	auipc	ra,0x0
    5e08:	e8e080e7          	jalr	-370(ra) # 5c92 <printint>
    5e0c:	8b4a                	mv	s6,s2
      state = 0;
    5e0e:	4981                	li	s3,0
    5e10:	b771                	j	5d9c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e12:	008b0913          	addi	s2,s6,8
    5e16:	4681                	li	a3,0
    5e18:	4629                	li	a2,10
    5e1a:	000b2583          	lw	a1,0(s6)
    5e1e:	8556                	mv	a0,s5
    5e20:	00000097          	auipc	ra,0x0
    5e24:	e72080e7          	jalr	-398(ra) # 5c92 <printint>
    5e28:	8b4a                	mv	s6,s2
      state = 0;
    5e2a:	4981                	li	s3,0
    5e2c:	bf85                	j	5d9c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e2e:	008b0913          	addi	s2,s6,8
    5e32:	4681                	li	a3,0
    5e34:	4641                	li	a2,16
    5e36:	000b2583          	lw	a1,0(s6)
    5e3a:	8556                	mv	a0,s5
    5e3c:	00000097          	auipc	ra,0x0
    5e40:	e56080e7          	jalr	-426(ra) # 5c92 <printint>
    5e44:	8b4a                	mv	s6,s2
      state = 0;
    5e46:	4981                	li	s3,0
    5e48:	bf91                	j	5d9c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e4a:	008b0793          	addi	a5,s6,8
    5e4e:	f8f43423          	sd	a5,-120(s0)
    5e52:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e56:	03000593          	li	a1,48
    5e5a:	8556                	mv	a0,s5
    5e5c:	00000097          	auipc	ra,0x0
    5e60:	e14080e7          	jalr	-492(ra) # 5c70 <putc>
  putc(fd, 'x');
    5e64:	85ea                	mv	a1,s10
    5e66:	8556                	mv	a0,s5
    5e68:	00000097          	auipc	ra,0x0
    5e6c:	e08080e7          	jalr	-504(ra) # 5c70 <putc>
    5e70:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e72:	03c9d793          	srli	a5,s3,0x3c
    5e76:	97de                	add	a5,a5,s7
    5e78:	0007c583          	lbu	a1,0(a5)
    5e7c:	8556                	mv	a0,s5
    5e7e:	00000097          	auipc	ra,0x0
    5e82:	df2080e7          	jalr	-526(ra) # 5c70 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e86:	0992                	slli	s3,s3,0x4
    5e88:	397d                	addiw	s2,s2,-1
    5e8a:	fe0914e3          	bnez	s2,5e72 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5e8e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5e92:	4981                	li	s3,0
    5e94:	b721                	j	5d9c <vprintf+0x60>
        s = va_arg(ap, char*);
    5e96:	008b0993          	addi	s3,s6,8
    5e9a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5e9e:	02090163          	beqz	s2,5ec0 <vprintf+0x184>
        while(*s != 0){
    5ea2:	00094583          	lbu	a1,0(s2)
    5ea6:	c9a1                	beqz	a1,5ef6 <vprintf+0x1ba>
          putc(fd, *s);
    5ea8:	8556                	mv	a0,s5
    5eaa:	00000097          	auipc	ra,0x0
    5eae:	dc6080e7          	jalr	-570(ra) # 5c70 <putc>
          s++;
    5eb2:	0905                	addi	s2,s2,1
        while(*s != 0){
    5eb4:	00094583          	lbu	a1,0(s2)
    5eb8:	f9e5                	bnez	a1,5ea8 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5eba:	8b4e                	mv	s6,s3
      state = 0;
    5ebc:	4981                	li	s3,0
    5ebe:	bdf9                	j	5d9c <vprintf+0x60>
          s = "(null)";
    5ec0:	00002917          	auipc	s2,0x2
    5ec4:	69890913          	addi	s2,s2,1688 # 8558 <malloc+0x2552>
        while(*s != 0){
    5ec8:	02800593          	li	a1,40
    5ecc:	bff1                	j	5ea8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ece:	008b0913          	addi	s2,s6,8
    5ed2:	000b4583          	lbu	a1,0(s6)
    5ed6:	8556                	mv	a0,s5
    5ed8:	00000097          	auipc	ra,0x0
    5edc:	d98080e7          	jalr	-616(ra) # 5c70 <putc>
    5ee0:	8b4a                	mv	s6,s2
      state = 0;
    5ee2:	4981                	li	s3,0
    5ee4:	bd65                	j	5d9c <vprintf+0x60>
        putc(fd, c);
    5ee6:	85d2                	mv	a1,s4
    5ee8:	8556                	mv	a0,s5
    5eea:	00000097          	auipc	ra,0x0
    5eee:	d86080e7          	jalr	-634(ra) # 5c70 <putc>
      state = 0;
    5ef2:	4981                	li	s3,0
    5ef4:	b565                	j	5d9c <vprintf+0x60>
        s = va_arg(ap, char*);
    5ef6:	8b4e                	mv	s6,s3
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	b54d                	j	5d9c <vprintf+0x60>
    }
  }
}
    5efc:	70e6                	ld	ra,120(sp)
    5efe:	7446                	ld	s0,112(sp)
    5f00:	74a6                	ld	s1,104(sp)
    5f02:	7906                	ld	s2,96(sp)
    5f04:	69e6                	ld	s3,88(sp)
    5f06:	6a46                	ld	s4,80(sp)
    5f08:	6aa6                	ld	s5,72(sp)
    5f0a:	6b06                	ld	s6,64(sp)
    5f0c:	7be2                	ld	s7,56(sp)
    5f0e:	7c42                	ld	s8,48(sp)
    5f10:	7ca2                	ld	s9,40(sp)
    5f12:	7d02                	ld	s10,32(sp)
    5f14:	6de2                	ld	s11,24(sp)
    5f16:	6109                	addi	sp,sp,128
    5f18:	8082                	ret

0000000000005f1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f1a:	715d                	addi	sp,sp,-80
    5f1c:	ec06                	sd	ra,24(sp)
    5f1e:	e822                	sd	s0,16(sp)
    5f20:	1000                	addi	s0,sp,32
    5f22:	e010                	sd	a2,0(s0)
    5f24:	e414                	sd	a3,8(s0)
    5f26:	e818                	sd	a4,16(s0)
    5f28:	ec1c                	sd	a5,24(s0)
    5f2a:	03043023          	sd	a6,32(s0)
    5f2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f32:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f36:	8622                	mv	a2,s0
    5f38:	00000097          	auipc	ra,0x0
    5f3c:	e04080e7          	jalr	-508(ra) # 5d3c <vprintf>
}
    5f40:	60e2                	ld	ra,24(sp)
    5f42:	6442                	ld	s0,16(sp)
    5f44:	6161                	addi	sp,sp,80
    5f46:	8082                	ret

0000000000005f48 <printf>:

void
printf(const char *fmt, ...)
{
    5f48:	711d                	addi	sp,sp,-96
    5f4a:	ec06                	sd	ra,24(sp)
    5f4c:	e822                	sd	s0,16(sp)
    5f4e:	1000                	addi	s0,sp,32
    5f50:	e40c                	sd	a1,8(s0)
    5f52:	e810                	sd	a2,16(s0)
    5f54:	ec14                	sd	a3,24(s0)
    5f56:	f018                	sd	a4,32(s0)
    5f58:	f41c                	sd	a5,40(s0)
    5f5a:	03043823          	sd	a6,48(s0)
    5f5e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f62:	00840613          	addi	a2,s0,8
    5f66:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f6a:	85aa                	mv	a1,a0
    5f6c:	4505                	li	a0,1
    5f6e:	00000097          	auipc	ra,0x0
    5f72:	dce080e7          	jalr	-562(ra) # 5d3c <vprintf>
}
    5f76:	60e2                	ld	ra,24(sp)
    5f78:	6442                	ld	s0,16(sp)
    5f7a:	6125                	addi	sp,sp,96
    5f7c:	8082                	ret

0000000000005f7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f7e:	1141                	addi	sp,sp,-16
    5f80:	e422                	sd	s0,8(sp)
    5f82:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f84:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f88:	00003797          	auipc	a5,0x3
    5f8c:	4c87b783          	ld	a5,1224(a5) # 9450 <freep>
    5f90:	a805                	j	5fc0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f92:	4618                	lw	a4,8(a2)
    5f94:	9db9                	addw	a1,a1,a4
    5f96:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f9a:	6398                	ld	a4,0(a5)
    5f9c:	6318                	ld	a4,0(a4)
    5f9e:	fee53823          	sd	a4,-16(a0)
    5fa2:	a091                	j	5fe6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fa4:	ff852703          	lw	a4,-8(a0)
    5fa8:	9e39                	addw	a2,a2,a4
    5faa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fac:	ff053703          	ld	a4,-16(a0)
    5fb0:	e398                	sd	a4,0(a5)
    5fb2:	a099                	j	5ff8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fb4:	6398                	ld	a4,0(a5)
    5fb6:	00e7e463          	bltu	a5,a4,5fbe <free+0x40>
    5fba:	00e6ea63          	bltu	a3,a4,5fce <free+0x50>
{
    5fbe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fc0:	fed7fae3          	bgeu	a5,a3,5fb4 <free+0x36>
    5fc4:	6398                	ld	a4,0(a5)
    5fc6:	00e6e463          	bltu	a3,a4,5fce <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fca:	fee7eae3          	bltu	a5,a4,5fbe <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5fce:	ff852583          	lw	a1,-8(a0)
    5fd2:	6390                	ld	a2,0(a5)
    5fd4:	02059713          	slli	a4,a1,0x20
    5fd8:	9301                	srli	a4,a4,0x20
    5fda:	0712                	slli	a4,a4,0x4
    5fdc:	9736                	add	a4,a4,a3
    5fde:	fae60ae3          	beq	a2,a4,5f92 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5fe2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fe6:	4790                	lw	a2,8(a5)
    5fe8:	02061713          	slli	a4,a2,0x20
    5fec:	9301                	srli	a4,a4,0x20
    5fee:	0712                	slli	a4,a4,0x4
    5ff0:	973e                	add	a4,a4,a5
    5ff2:	fae689e3          	beq	a3,a4,5fa4 <free+0x26>
  } else
    p->s.ptr = bp;
    5ff6:	e394                	sd	a3,0(a5)
  freep = p;
    5ff8:	00003717          	auipc	a4,0x3
    5ffc:	44f73c23          	sd	a5,1112(a4) # 9450 <freep>
}
    6000:	6422                	ld	s0,8(sp)
    6002:	0141                	addi	sp,sp,16
    6004:	8082                	ret

0000000000006006 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6006:	7139                	addi	sp,sp,-64
    6008:	fc06                	sd	ra,56(sp)
    600a:	f822                	sd	s0,48(sp)
    600c:	f426                	sd	s1,40(sp)
    600e:	f04a                	sd	s2,32(sp)
    6010:	ec4e                	sd	s3,24(sp)
    6012:	e852                	sd	s4,16(sp)
    6014:	e456                	sd	s5,8(sp)
    6016:	e05a                	sd	s6,0(sp)
    6018:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    601a:	02051493          	slli	s1,a0,0x20
    601e:	9081                	srli	s1,s1,0x20
    6020:	04bd                	addi	s1,s1,15
    6022:	8091                	srli	s1,s1,0x4
    6024:	0014899b          	addiw	s3,s1,1
    6028:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    602a:	00003517          	auipc	a0,0x3
    602e:	42653503          	ld	a0,1062(a0) # 9450 <freep>
    6032:	c515                	beqz	a0,605e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6034:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6036:	4798                	lw	a4,8(a5)
    6038:	02977f63          	bgeu	a4,s1,6076 <malloc+0x70>
    603c:	8a4e                	mv	s4,s3
    603e:	0009871b          	sext.w	a4,s3
    6042:	6685                	lui	a3,0x1
    6044:	00d77363          	bgeu	a4,a3,604a <malloc+0x44>
    6048:	6a05                	lui	s4,0x1
    604a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    604e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6052:	00003917          	auipc	s2,0x3
    6056:	3fe90913          	addi	s2,s2,1022 # 9450 <freep>
  if(p == (char*)-1)
    605a:	5afd                	li	s5,-1
    605c:	a88d                	j	60ce <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    605e:	0000a797          	auipc	a5,0xa
    6062:	c1a78793          	addi	a5,a5,-998 # fc78 <base>
    6066:	00003717          	auipc	a4,0x3
    606a:	3ef73523          	sd	a5,1002(a4) # 9450 <freep>
    606e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6070:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6074:	b7e1                	j	603c <malloc+0x36>
      if(p->s.size == nunits)
    6076:	02e48b63          	beq	s1,a4,60ac <malloc+0xa6>
        p->s.size -= nunits;
    607a:	4137073b          	subw	a4,a4,s3
    607e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6080:	1702                	slli	a4,a4,0x20
    6082:	9301                	srli	a4,a4,0x20
    6084:	0712                	slli	a4,a4,0x4
    6086:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6088:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    608c:	00003717          	auipc	a4,0x3
    6090:	3ca73223          	sd	a0,964(a4) # 9450 <freep>
      return (void*)(p + 1);
    6094:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6098:	70e2                	ld	ra,56(sp)
    609a:	7442                	ld	s0,48(sp)
    609c:	74a2                	ld	s1,40(sp)
    609e:	7902                	ld	s2,32(sp)
    60a0:	69e2                	ld	s3,24(sp)
    60a2:	6a42                	ld	s4,16(sp)
    60a4:	6aa2                	ld	s5,8(sp)
    60a6:	6b02                	ld	s6,0(sp)
    60a8:	6121                	addi	sp,sp,64
    60aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60ac:	6398                	ld	a4,0(a5)
    60ae:	e118                	sd	a4,0(a0)
    60b0:	bff1                	j	608c <malloc+0x86>
  hp->s.size = nu;
    60b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60b6:	0541                	addi	a0,a0,16
    60b8:	00000097          	auipc	ra,0x0
    60bc:	ec6080e7          	jalr	-314(ra) # 5f7e <free>
  return freep;
    60c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60c4:	d971                	beqz	a0,6098 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60c8:	4798                	lw	a4,8(a5)
    60ca:	fa9776e3          	bgeu	a4,s1,6076 <malloc+0x70>
    if(p == freep)
    60ce:	00093703          	ld	a4,0(s2)
    60d2:	853e                	mv	a0,a5
    60d4:	fef719e3          	bne	a4,a5,60c6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    60d8:	8552                	mv	a0,s4
    60da:	00000097          	auipc	ra,0x0
    60de:	b76080e7          	jalr	-1162(ra) # 5c50 <sbrk>
  if(p == (char*)-1)
    60e2:	fd5518e3          	bne	a0,s5,60b2 <malloc+0xac>
        return 0;
    60e6:	4501                	li	a0,0
    60e8:	bf45                	j	6098 <malloc+0x92>
