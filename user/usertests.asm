
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	68278793          	addi	a5,a5,1666 # 7690 <malloc+0x255c>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	44f040ef          	jal	ra,4c94 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	1ca50513          	addi	a0,a0,458 # 5230 <malloc+0xfc>
      6e:	00c050ef          	jal	ra,507a <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	3e1040ef          	jal	ra,4c54 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	52078793          	addi	a5,a5,1312 # 9598 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	c2868693          	addi	a3,a3,-984 # bca8 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	1b050513          	addi	a0,a0,432 # 5250 <malloc+0x11c>
      a8:	7d3040ef          	jal	ra,507a <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	3a7040ef          	jal	ra,4c54 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	1a850513          	addi	a0,a0,424 # 5268 <malloc+0x134>
      c8:	3cd040ef          	jal	ra,4c94 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	3ad040ef          	jal	ra,4c7c <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	1b250513          	addi	a0,a0,434 # 5288 <malloc+0x154>
      de:	3b7040ef          	jal	ra,4c94 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	17e50513          	addi	a0,a0,382 # 5270 <malloc+0x13c>
      fa:	781040ef          	jal	ra,507a <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	355040ef          	jal	ra,4c54 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	19250513          	addi	a0,a0,402 # 5298 <malloc+0x164>
     10e:	76d040ef          	jal	ra,507a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	341040ef          	jal	ra,4c54 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	19850513          	addi	a0,a0,408 # 52c0 <malloc+0x18c>
     130:	375040ef          	jal	ra,4ca4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	18850513          	addi	a0,a0,392 # 52c0 <malloc+0x18c>
     140:	355040ef          	jal	ra,4c94 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	18858593          	addi	a1,a1,392 # 52d0 <malloc+0x19c>
     150:	325040ef          	jal	ra,4c74 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	16850513          	addi	a0,a0,360 # 52c0 <malloc+0x18c>
     160:	335040ef          	jal	ra,4c94 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	17058593          	addi	a1,a1,368 # 52d8 <malloc+0x1a4>
     170:	8526                	mv	a0,s1
     172:	303040ef          	jal	ra,4c74 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	14450513          	addi	a0,a0,324 # 52c0 <malloc+0x18c>
     184:	321040ef          	jal	ra,4ca4 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	2f3040ef          	jal	ra,4c7c <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	2ed040ef          	jal	ra,4c7c <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	13a50513          	addi	a0,a0,314 # 52e0 <malloc+0x1ac>
     1ae:	6cd040ef          	jal	ra,507a <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	2a1040ef          	jal	ra,4c54 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	2b1040ef          	jal	ra,4c94 <open>
    close(fd);
     1e8:	295040ef          	jal	ra,4c7c <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	andi	s1,s1,255
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	293040ef          	jal	ra,4ca4 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	andi	s1,s1,255
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	0c450513          	addi	a0,a0,196 # 5308 <malloc+0x1d4>
     24c:	259040ef          	jal	ra,4ca4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	0b4a8a93          	addi	s5,s5,180 # 5308 <malloc+0x1d4>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a4ca0a13          	addi	s4,s4,-1460 # bca8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x5f>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	225040ef          	jal	ra,4c94 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	1f7040ef          	jal	ra,4c74 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49a63          	bne	s1,a0,2d8 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	1e7040ef          	jal	ra,4c74 <write>
      if(cc != sz){
     292:	04951163          	bne	a0,s1,2d4 <bigwrite+0xa8>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	1e5040ef          	jal	ra,4c7c <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	207040ef          	jal	ra,4ca4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	05650513          	addi	a0,a0,86 # 5318 <malloc+0x1e4>
     2ca:	5b1040ef          	jal	ra,507a <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	185040ef          	jal	ra,4c54 <exit>
     2d4:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     2d6:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d8:	86ce                	mv	a3,s3
     2da:	8626                	mv	a2,s1
     2dc:	85de                	mv	a1,s7
     2de:	00005517          	auipc	a0,0x5
     2e2:	05a50513          	addi	a0,a0,90 # 5338 <malloc+0x204>
     2e6:	595040ef          	jal	ra,507a <printf>
        exit(1);
     2ea:	4505                	li	a0,1
     2ec:	169040ef          	jal	ra,4c54 <exit>

00000000000002f0 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2f0:	7179                	addi	sp,sp,-48
     2f2:	f406                	sd	ra,40(sp)
     2f4:	f022                	sd	s0,32(sp)
     2f6:	ec26                	sd	s1,24(sp)
     2f8:	e84a                	sd	s2,16(sp)
     2fa:	e44e                	sd	s3,8(sp)
     2fc:	e052                	sd	s4,0(sp)
     2fe:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     300:	00005517          	auipc	a0,0x5
     304:	05050513          	addi	a0,a0,80 # 5350 <malloc+0x21c>
     308:	19d040ef          	jal	ra,4ca4 <unlink>
     30c:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     310:	00005997          	auipc	s3,0x5
     314:	04098993          	addi	s3,s3,64 # 5350 <malloc+0x21c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     318:	5a7d                	li	s4,-1
     31a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31e:	20100593          	li	a1,513
     322:	854e                	mv	a0,s3
     324:	171040ef          	jal	ra,4c94 <open>
     328:	84aa                	mv	s1,a0
    if(fd < 0){
     32a:	04054d63          	bltz	a0,384 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32e:	4605                	li	a2,1
     330:	85d2                	mv	a1,s4
     332:	143040ef          	jal	ra,4c74 <write>
    close(fd);
     336:	8526                	mv	a0,s1
     338:	145040ef          	jal	ra,4c7c <close>
    unlink("junk");
     33c:	854e                	mv	a0,s3
     33e:	167040ef          	jal	ra,4ca4 <unlink>
  for(int i = 0; i < assumed_free; i++){
     342:	397d                	addiw	s2,s2,-1
     344:	fc091de3          	bnez	s2,31e <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     348:	20100593          	li	a1,513
     34c:	00005517          	auipc	a0,0x5
     350:	00450513          	addi	a0,a0,4 # 5350 <malloc+0x21c>
     354:	141040ef          	jal	ra,4c94 <open>
     358:	84aa                	mv	s1,a0
  if(fd < 0){
     35a:	02054e63          	bltz	a0,396 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35e:	4605                	li	a2,1
     360:	00005597          	auipc	a1,0x5
     364:	f7858593          	addi	a1,a1,-136 # 52d8 <malloc+0x1a4>
     368:	10d040ef          	jal	ra,4c74 <write>
     36c:	4785                	li	a5,1
     36e:	02f50d63          	beq	a0,a5,3a8 <badwrite+0xb8>
    printf("write failed\n");
     372:	00005517          	auipc	a0,0x5
     376:	ffe50513          	addi	a0,a0,-2 # 5370 <malloc+0x23c>
     37a:	501040ef          	jal	ra,507a <printf>
    exit(1);
     37e:	4505                	li	a0,1
     380:	0d5040ef          	jal	ra,4c54 <exit>
      printf("open junk failed\n");
     384:	00005517          	auipc	a0,0x5
     388:	fd450513          	addi	a0,a0,-44 # 5358 <malloc+0x224>
     38c:	4ef040ef          	jal	ra,507a <printf>
      exit(1);
     390:	4505                	li	a0,1
     392:	0c3040ef          	jal	ra,4c54 <exit>
    printf("open junk failed\n");
     396:	00005517          	auipc	a0,0x5
     39a:	fc250513          	addi	a0,a0,-62 # 5358 <malloc+0x224>
     39e:	4dd040ef          	jal	ra,507a <printf>
    exit(1);
     3a2:	4505                	li	a0,1
     3a4:	0b1040ef          	jal	ra,4c54 <exit>
  }
  close(fd);
     3a8:	8526                	mv	a0,s1
     3aa:	0d3040ef          	jal	ra,4c7c <close>
  unlink("junk");
     3ae:	00005517          	auipc	a0,0x5
     3b2:	fa250513          	addi	a0,a0,-94 # 5350 <malloc+0x21c>
     3b6:	0ef040ef          	jal	ra,4ca4 <unlink>

  exit(0);
     3ba:	4501                	li	a0,0
     3bc:	099040ef          	jal	ra,4c54 <exit>

00000000000003c0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3c0:	715d                	addi	sp,sp,-80
     3c2:	e486                	sd	ra,72(sp)
     3c4:	e0a2                	sd	s0,64(sp)
     3c6:	fc26                	sd	s1,56(sp)
     3c8:	f84a                	sd	s2,48(sp)
     3ca:	f44e                	sd	s3,40(sp)
     3cc:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3ce:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3d0:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d4:	40000993          	li	s3,1024
    name[0] = 'z';
     3d8:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3dc:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3e0:	41f4d79b          	sraiw	a5,s1,0x1f
     3e4:	01b7d71b          	srliw	a4,a5,0x1b
     3e8:	009707bb          	addw	a5,a4,s1
     3ec:	4057d69b          	sraiw	a3,a5,0x5
     3f0:	0306869b          	addiw	a3,a3,48
     3f4:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f8:	8bfd                	andi	a5,a5,31
     3fa:	9f99                	subw	a5,a5,a4
     3fc:	0307879b          	addiw	a5,a5,48
     400:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     404:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     408:	fb040513          	addi	a0,s0,-80
     40c:	099040ef          	jal	ra,4ca4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     410:	60200593          	li	a1,1538
     414:	fb040513          	addi	a0,s0,-80
     418:	07d040ef          	jal	ra,4c94 <open>
    if(fd < 0){
     41c:	00054763          	bltz	a0,42a <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     420:	05d040ef          	jal	ra,4c7c <close>
  for(int i = 0; i < nzz; i++){
     424:	2485                	addiw	s1,s1,1
     426:	fb3499e3          	bne	s1,s3,3d8 <outofinodes+0x18>
     42a:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     430:	40000993          	li	s3,1024
    name[0] = 'z';
     434:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     438:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43c:	41f4d79b          	sraiw	a5,s1,0x1f
     440:	01b7d71b          	srliw	a4,a5,0x1b
     444:	009707bb          	addw	a5,a4,s1
     448:	4057d69b          	sraiw	a3,a5,0x5
     44c:	0306869b          	addiw	a3,a3,48
     450:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     454:	8bfd                	andi	a5,a5,31
     456:	9f99                	subw	a5,a5,a4
     458:	0307879b          	addiw	a5,a5,48
     45c:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     460:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     464:	fb040513          	addi	a0,s0,-80
     468:	03d040ef          	jal	ra,4ca4 <unlink>
  for(int i = 0; i < nzz; i++){
     46c:	2485                	addiw	s1,s1,1
     46e:	fd3493e3          	bne	s1,s3,434 <outofinodes+0x74>
  }
}
     472:	60a6                	ld	ra,72(sp)
     474:	6406                	ld	s0,64(sp)
     476:	74e2                	ld	s1,56(sp)
     478:	7942                	ld	s2,48(sp)
     47a:	79a2                	ld	s3,40(sp)
     47c:	6161                	addi	sp,sp,80
     47e:	8082                	ret

0000000000000480 <copyin>:
{
     480:	7159                	addi	sp,sp,-112
     482:	f486                	sd	ra,104(sp)
     484:	f0a2                	sd	s0,96(sp)
     486:	eca6                	sd	s1,88(sp)
     488:	e8ca                	sd	s2,80(sp)
     48a:	e4ce                	sd	s3,72(sp)
     48c:	e0d2                	sd	s4,64(sp)
     48e:	fc56                	sd	s5,56(sp)
     490:	f85a                	sd	s6,48(sp)
     492:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     494:	00007797          	auipc	a5,0x7
     498:	1fc78793          	addi	a5,a5,508 # 7690 <malloc+0x255c>
     49c:	638c                	ld	a1,0(a5)
     49e:	6790                	ld	a2,8(a5)
     4a0:	6b94                	ld	a3,16(a5)
     4a2:	6f98                	ld	a4,24(a5)
     4a4:	739c                	ld	a5,32(a5)
     4a6:	f8b43c23          	sd	a1,-104(s0)
     4aa:	fac43023          	sd	a2,-96(s0)
     4ae:	fad43423          	sd	a3,-88(s0)
     4b2:	fae43823          	sd	a4,-80(s0)
     4b6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ba:	f9840993          	addi	s3,s0,-104
     4be:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4c2:	00005a17          	auipc	s4,0x5
     4c6:	ebea0a13          	addi	s4,s4,-322 # 5380 <malloc+0x24c>
    uint64 addr = addrs[ai];
     4ca:	0009b903          	ld	s2,0(s3)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ce:	20100593          	li	a1,513
     4d2:	8552                	mv	a0,s4
     4d4:	7c0040ef          	jal	ra,4c94 <open>
     4d8:	84aa                	mv	s1,a0
    if(fd < 0){
     4da:	06054863          	bltz	a0,54a <copyin+0xca>
    int n = write(fd, (void*)addr, 8192);
     4de:	6609                	lui	a2,0x2
     4e0:	85ca                	mv	a1,s2
     4e2:	792040ef          	jal	ra,4c74 <write>
    if(n >= 0){
     4e6:	06055b63          	bgez	a0,55c <copyin+0xdc>
    close(fd);
     4ea:	8526                	mv	a0,s1
     4ec:	790040ef          	jal	ra,4c7c <close>
    unlink("copyin1");
     4f0:	8552                	mv	a0,s4
     4f2:	7b2040ef          	jal	ra,4ca4 <unlink>
    n = write(1, (char*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ca                	mv	a1,s2
     4fa:	4505                	li	a0,1
     4fc:	778040ef          	jal	ra,4c74 <write>
    if(n > 0){
     500:	06a04963          	bgtz	a0,572 <copyin+0xf2>
    if(pipe(fds) < 0){
     504:	f9040513          	addi	a0,s0,-112
     508:	75c040ef          	jal	ra,4c64 <pipe>
     50c:	06054e63          	bltz	a0,588 <copyin+0x108>
    n = write(fds[1], (char*)addr, 8192);
     510:	6609                	lui	a2,0x2
     512:	85ca                	mv	a1,s2
     514:	f9442503          	lw	a0,-108(s0)
     518:	75c040ef          	jal	ra,4c74 <write>
    if(n > 0){
     51c:	06a04f63          	bgtz	a0,59a <copyin+0x11a>
    close(fds[0]);
     520:	f9042503          	lw	a0,-112(s0)
     524:	758040ef          	jal	ra,4c7c <close>
    close(fds[1]);
     528:	f9442503          	lw	a0,-108(s0)
     52c:	750040ef          	jal	ra,4c7c <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     530:	09a1                	addi	s3,s3,8
     532:	f9599ce3          	bne	s3,s5,4ca <copyin+0x4a>
}
     536:	70a6                	ld	ra,104(sp)
     538:	7406                	ld	s0,96(sp)
     53a:	64e6                	ld	s1,88(sp)
     53c:	6946                	ld	s2,80(sp)
     53e:	69a6                	ld	s3,72(sp)
     540:	6a06                	ld	s4,64(sp)
     542:	7ae2                	ld	s5,56(sp)
     544:	7b42                	ld	s6,48(sp)
     546:	6165                	addi	sp,sp,112
     548:	8082                	ret
      printf("open(copyin1) failed\n");
     54a:	00005517          	auipc	a0,0x5
     54e:	e3e50513          	addi	a0,a0,-450 # 5388 <malloc+0x254>
     552:	329040ef          	jal	ra,507a <printf>
      exit(1);
     556:	4505                	li	a0,1
     558:	6fc040ef          	jal	ra,4c54 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     55c:	862a                	mv	a2,a0
     55e:	85ca                	mv	a1,s2
     560:	00005517          	auipc	a0,0x5
     564:	e4050513          	addi	a0,a0,-448 # 53a0 <malloc+0x26c>
     568:	313040ef          	jal	ra,507a <printf>
      exit(1);
     56c:	4505                	li	a0,1
     56e:	6e6040ef          	jal	ra,4c54 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     572:	862a                	mv	a2,a0
     574:	85ca                	mv	a1,s2
     576:	00005517          	auipc	a0,0x5
     57a:	e5a50513          	addi	a0,a0,-422 # 53d0 <malloc+0x29c>
     57e:	2fd040ef          	jal	ra,507a <printf>
      exit(1);
     582:	4505                	li	a0,1
     584:	6d0040ef          	jal	ra,4c54 <exit>
      printf("pipe() failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	e7850513          	addi	a0,a0,-392 # 5400 <malloc+0x2cc>
     590:	2eb040ef          	jal	ra,507a <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	6be040ef          	jal	ra,4c54 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ca                	mv	a1,s2
     59e:	00005517          	auipc	a0,0x5
     5a2:	e7250513          	addi	a0,a0,-398 # 5410 <malloc+0x2dc>
     5a6:	2d5040ef          	jal	ra,507a <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	6a8040ef          	jal	ra,4c54 <exit>

00000000000005b0 <copyout>:
{
     5b0:	7175                	addi	sp,sp,-144
     5b2:	e506                	sd	ra,136(sp)
     5b4:	e122                	sd	s0,128(sp)
     5b6:	fca6                	sd	s1,120(sp)
     5b8:	f8ca                	sd	s2,112(sp)
     5ba:	f4ce                	sd	s3,104(sp)
     5bc:	f0d2                	sd	s4,96(sp)
     5be:	ecd6                	sd	s5,88(sp)
     5c0:	e8da                	sd	s6,80(sp)
     5c2:	e4de                	sd	s7,72(sp)
     5c4:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5c6:	00007797          	auipc	a5,0x7
     5ca:	0ca78793          	addi	a5,a5,202 # 7690 <malloc+0x255c>
     5ce:	7788                	ld	a0,40(a5)
     5d0:	7b8c                	ld	a1,48(a5)
     5d2:	7f90                	ld	a2,56(a5)
     5d4:	63b4                	ld	a3,64(a5)
     5d6:	67b8                	ld	a4,72(a5)
     5d8:	6bbc                	ld	a5,80(a5)
     5da:	f8a43023          	sd	a0,-128(s0)
     5de:	f8b43423          	sd	a1,-120(s0)
     5e2:	f8c43823          	sd	a2,-112(s0)
     5e6:	f8d43c23          	sd	a3,-104(s0)
     5ea:	fae43023          	sd	a4,-96(s0)
     5ee:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5f2:	f8040913          	addi	s2,s0,-128
     5f6:	fb040b13          	addi	s6,s0,-80
    int fd = open("README", 0);
     5fa:	00005a17          	auipc	s4,0x5
     5fe:	e46a0a13          	addi	s4,s4,-442 # 5440 <malloc+0x30c>
    n = write(fds[1], "x", 1);
     602:	00005a97          	auipc	s5,0x5
     606:	cd6a8a93          	addi	s5,s5,-810 # 52d8 <malloc+0x1a4>
    uint64 addr = addrs[ai];
     60a:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     60e:	4581                	li	a1,0
     610:	8552                	mv	a0,s4
     612:	682040ef          	jal	ra,4c94 <open>
     616:	84aa                	mv	s1,a0
    if(fd < 0){
     618:	06054863          	bltz	a0,688 <copyout+0xd8>
    int n = read(fd, (void*)addr, 8192);
     61c:	6609                	lui	a2,0x2
     61e:	85ce                	mv	a1,s3
     620:	64c040ef          	jal	ra,4c6c <read>
    if(n > 0){
     624:	06a04b63          	bgtz	a0,69a <copyout+0xea>
    close(fd);
     628:	8526                	mv	a0,s1
     62a:	652040ef          	jal	ra,4c7c <close>
    if(pipe(fds) < 0){
     62e:	f7840513          	addi	a0,s0,-136
     632:	632040ef          	jal	ra,4c64 <pipe>
     636:	06054d63          	bltz	a0,6b0 <copyout+0x100>
    n = write(fds[1], "x", 1);
     63a:	4605                	li	a2,1
     63c:	85d6                	mv	a1,s5
     63e:	f7c42503          	lw	a0,-132(s0)
     642:	632040ef          	jal	ra,4c74 <write>
    if(n != 1){
     646:	4785                	li	a5,1
     648:	06f51d63          	bne	a0,a5,6c2 <copyout+0x112>
    n = read(fds[0], (void*)addr, 8192);
     64c:	6609                	lui	a2,0x2
     64e:	85ce                	mv	a1,s3
     650:	f7842503          	lw	a0,-136(s0)
     654:	618040ef          	jal	ra,4c6c <read>
    if(n > 0){
     658:	06a04e63          	bgtz	a0,6d4 <copyout+0x124>
    close(fds[0]);
     65c:	f7842503          	lw	a0,-136(s0)
     660:	61c040ef          	jal	ra,4c7c <close>
    close(fds[1]);
     664:	f7c42503          	lw	a0,-132(s0)
     668:	614040ef          	jal	ra,4c7c <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     66c:	0921                	addi	s2,s2,8
     66e:	f9691ee3          	bne	s2,s6,60a <copyout+0x5a>
}
     672:	60aa                	ld	ra,136(sp)
     674:	640a                	ld	s0,128(sp)
     676:	74e6                	ld	s1,120(sp)
     678:	7946                	ld	s2,112(sp)
     67a:	79a6                	ld	s3,104(sp)
     67c:	7a06                	ld	s4,96(sp)
     67e:	6ae6                	ld	s5,88(sp)
     680:	6b46                	ld	s6,80(sp)
     682:	6ba6                	ld	s7,72(sp)
     684:	6149                	addi	sp,sp,144
     686:	8082                	ret
      printf("open(README) failed\n");
     688:	00005517          	auipc	a0,0x5
     68c:	dc050513          	addi	a0,a0,-576 # 5448 <malloc+0x314>
     690:	1eb040ef          	jal	ra,507a <printf>
      exit(1);
     694:	4505                	li	a0,1
     696:	5be040ef          	jal	ra,4c54 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     69a:	862a                	mv	a2,a0
     69c:	85ce                	mv	a1,s3
     69e:	00005517          	auipc	a0,0x5
     6a2:	dc250513          	addi	a0,a0,-574 # 5460 <malloc+0x32c>
     6a6:	1d5040ef          	jal	ra,507a <printf>
      exit(1);
     6aa:	4505                	li	a0,1
     6ac:	5a8040ef          	jal	ra,4c54 <exit>
      printf("pipe() failed\n");
     6b0:	00005517          	auipc	a0,0x5
     6b4:	d5050513          	addi	a0,a0,-688 # 5400 <malloc+0x2cc>
     6b8:	1c3040ef          	jal	ra,507a <printf>
      exit(1);
     6bc:	4505                	li	a0,1
     6be:	596040ef          	jal	ra,4c54 <exit>
      printf("pipe write failed\n");
     6c2:	00005517          	auipc	a0,0x5
     6c6:	dce50513          	addi	a0,a0,-562 # 5490 <malloc+0x35c>
     6ca:	1b1040ef          	jal	ra,507a <printf>
      exit(1);
     6ce:	4505                	li	a0,1
     6d0:	584040ef          	jal	ra,4c54 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6d4:	862a                	mv	a2,a0
     6d6:	85ce                	mv	a1,s3
     6d8:	00005517          	auipc	a0,0x5
     6dc:	dd050513          	addi	a0,a0,-560 # 54a8 <malloc+0x374>
     6e0:	19b040ef          	jal	ra,507a <printf>
      exit(1);
     6e4:	4505                	li	a0,1
     6e6:	56e040ef          	jal	ra,4c54 <exit>

00000000000006ea <truncate1>:
{
     6ea:	711d                	addi	sp,sp,-96
     6ec:	ec86                	sd	ra,88(sp)
     6ee:	e8a2                	sd	s0,80(sp)
     6f0:	e4a6                	sd	s1,72(sp)
     6f2:	e0ca                	sd	s2,64(sp)
     6f4:	fc4e                	sd	s3,56(sp)
     6f6:	f852                	sd	s4,48(sp)
     6f8:	f456                	sd	s5,40(sp)
     6fa:	1080                	addi	s0,sp,96
     6fc:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6fe:	00005517          	auipc	a0,0x5
     702:	bc250513          	addi	a0,a0,-1086 # 52c0 <malloc+0x18c>
     706:	59e040ef          	jal	ra,4ca4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     70a:	60100593          	li	a1,1537
     70e:	00005517          	auipc	a0,0x5
     712:	bb250513          	addi	a0,a0,-1102 # 52c0 <malloc+0x18c>
     716:	57e040ef          	jal	ra,4c94 <open>
     71a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     71c:	4611                	li	a2,4
     71e:	00005597          	auipc	a1,0x5
     722:	bb258593          	addi	a1,a1,-1102 # 52d0 <malloc+0x19c>
     726:	54e040ef          	jal	ra,4c74 <write>
  close(fd1);
     72a:	8526                	mv	a0,s1
     72c:	550040ef          	jal	ra,4c7c <close>
  int fd2 = open("truncfile", O_RDONLY);
     730:	4581                	li	a1,0
     732:	00005517          	auipc	a0,0x5
     736:	b8e50513          	addi	a0,a0,-1138 # 52c0 <malloc+0x18c>
     73a:	55a040ef          	jal	ra,4c94 <open>
     73e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     740:	02000613          	li	a2,32
     744:	fa040593          	addi	a1,s0,-96
     748:	524040ef          	jal	ra,4c6c <read>
  if(n != 4){
     74c:	4791                	li	a5,4
     74e:	0af51863          	bne	a0,a5,7fe <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     752:	40100593          	li	a1,1025
     756:	00005517          	auipc	a0,0x5
     75a:	b6a50513          	addi	a0,a0,-1174 # 52c0 <malloc+0x18c>
     75e:	536040ef          	jal	ra,4c94 <open>
     762:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     764:	4581                	li	a1,0
     766:	00005517          	auipc	a0,0x5
     76a:	b5a50513          	addi	a0,a0,-1190 # 52c0 <malloc+0x18c>
     76e:	526040ef          	jal	ra,4c94 <open>
     772:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     774:	02000613          	li	a2,32
     778:	fa040593          	addi	a1,s0,-96
     77c:	4f0040ef          	jal	ra,4c6c <read>
     780:	8a2a                	mv	s4,a0
  if(n != 0){
     782:	e949                	bnez	a0,814 <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     784:	02000613          	li	a2,32
     788:	fa040593          	addi	a1,s0,-96
     78c:	8526                	mv	a0,s1
     78e:	4de040ef          	jal	ra,4c6c <read>
     792:	8a2a                	mv	s4,a0
  if(n != 0){
     794:	e155                	bnez	a0,838 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     796:	4619                	li	a2,6
     798:	00005597          	auipc	a1,0x5
     79c:	da058593          	addi	a1,a1,-608 # 5538 <malloc+0x404>
     7a0:	854e                	mv	a0,s3
     7a2:	4d2040ef          	jal	ra,4c74 <write>
  n = read(fd3, buf, sizeof(buf));
     7a6:	02000613          	li	a2,32
     7aa:	fa040593          	addi	a1,s0,-96
     7ae:	854a                	mv	a0,s2
     7b0:	4bc040ef          	jal	ra,4c6c <read>
  if(n != 6){
     7b4:	4799                	li	a5,6
     7b6:	0af51363          	bne	a0,a5,85c <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7ba:	02000613          	li	a2,32
     7be:	fa040593          	addi	a1,s0,-96
     7c2:	8526                	mv	a0,s1
     7c4:	4a8040ef          	jal	ra,4c6c <read>
  if(n != 2){
     7c8:	4789                	li	a5,2
     7ca:	0af51463          	bne	a0,a5,872 <truncate1+0x188>
  unlink("truncfile");
     7ce:	00005517          	auipc	a0,0x5
     7d2:	af250513          	addi	a0,a0,-1294 # 52c0 <malloc+0x18c>
     7d6:	4ce040ef          	jal	ra,4ca4 <unlink>
  close(fd1);
     7da:	854e                	mv	a0,s3
     7dc:	4a0040ef          	jal	ra,4c7c <close>
  close(fd2);
     7e0:	8526                	mv	a0,s1
     7e2:	49a040ef          	jal	ra,4c7c <close>
  close(fd3);
     7e6:	854a                	mv	a0,s2
     7e8:	494040ef          	jal	ra,4c7c <close>
}
     7ec:	60e6                	ld	ra,88(sp)
     7ee:	6446                	ld	s0,80(sp)
     7f0:	64a6                	ld	s1,72(sp)
     7f2:	6906                	ld	s2,64(sp)
     7f4:	79e2                	ld	s3,56(sp)
     7f6:	7a42                	ld	s4,48(sp)
     7f8:	7aa2                	ld	s5,40(sp)
     7fa:	6125                	addi	sp,sp,96
     7fc:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7fe:	862a                	mv	a2,a0
     800:	85d6                	mv	a1,s5
     802:	00005517          	auipc	a0,0x5
     806:	cd650513          	addi	a0,a0,-810 # 54d8 <malloc+0x3a4>
     80a:	071040ef          	jal	ra,507a <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	444040ef          	jal	ra,4c54 <exit>
    printf("aaa fd3=%d\n", fd3);
     814:	85ca                	mv	a1,s2
     816:	00005517          	auipc	a0,0x5
     81a:	ce250513          	addi	a0,a0,-798 # 54f8 <malloc+0x3c4>
     81e:	05d040ef          	jal	ra,507a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     822:	8652                	mv	a2,s4
     824:	85d6                	mv	a1,s5
     826:	00005517          	auipc	a0,0x5
     82a:	ce250513          	addi	a0,a0,-798 # 5508 <malloc+0x3d4>
     82e:	04d040ef          	jal	ra,507a <printf>
    exit(1);
     832:	4505                	li	a0,1
     834:	420040ef          	jal	ra,4c54 <exit>
    printf("bbb fd2=%d\n", fd2);
     838:	85a6                	mv	a1,s1
     83a:	00005517          	auipc	a0,0x5
     83e:	cee50513          	addi	a0,a0,-786 # 5528 <malloc+0x3f4>
     842:	039040ef          	jal	ra,507a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     846:	8652                	mv	a2,s4
     848:	85d6                	mv	a1,s5
     84a:	00005517          	auipc	a0,0x5
     84e:	cbe50513          	addi	a0,a0,-834 # 5508 <malloc+0x3d4>
     852:	029040ef          	jal	ra,507a <printf>
    exit(1);
     856:	4505                	li	a0,1
     858:	3fc040ef          	jal	ra,4c54 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     85c:	862a                	mv	a2,a0
     85e:	85d6                	mv	a1,s5
     860:	00005517          	auipc	a0,0x5
     864:	ce050513          	addi	a0,a0,-800 # 5540 <malloc+0x40c>
     868:	013040ef          	jal	ra,507a <printf>
    exit(1);
     86c:	4505                	li	a0,1
     86e:	3e6040ef          	jal	ra,4c54 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     872:	862a                	mv	a2,a0
     874:	85d6                	mv	a1,s5
     876:	00005517          	auipc	a0,0x5
     87a:	cea50513          	addi	a0,a0,-790 # 5560 <malloc+0x42c>
     87e:	7fc040ef          	jal	ra,507a <printf>
    exit(1);
     882:	4505                	li	a0,1
     884:	3d0040ef          	jal	ra,4c54 <exit>

0000000000000888 <writetest>:
{
     888:	7139                	addi	sp,sp,-64
     88a:	fc06                	sd	ra,56(sp)
     88c:	f822                	sd	s0,48(sp)
     88e:	f426                	sd	s1,40(sp)
     890:	f04a                	sd	s2,32(sp)
     892:	ec4e                	sd	s3,24(sp)
     894:	e852                	sd	s4,16(sp)
     896:	e456                	sd	s5,8(sp)
     898:	e05a                	sd	s6,0(sp)
     89a:	0080                	addi	s0,sp,64
     89c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     89e:	20200593          	li	a1,514
     8a2:	00005517          	auipc	a0,0x5
     8a6:	cde50513          	addi	a0,a0,-802 # 5580 <malloc+0x44c>
     8aa:	3ea040ef          	jal	ra,4c94 <open>
  if(fd < 0){
     8ae:	08054f63          	bltz	a0,94c <writetest+0xc4>
     8b2:	892a                	mv	s2,a0
     8b4:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8b6:	00005997          	auipc	s3,0x5
     8ba:	cf298993          	addi	s3,s3,-782 # 55a8 <malloc+0x474>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8be:	00005a97          	auipc	s5,0x5
     8c2:	d22a8a93          	addi	s5,s5,-734 # 55e0 <malloc+0x4ac>
  for(i = 0; i < N; i++){
     8c6:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ca:	4629                	li	a2,10
     8cc:	85ce                	mv	a1,s3
     8ce:	854a                	mv	a0,s2
     8d0:	3a4040ef          	jal	ra,4c74 <write>
     8d4:	47a9                	li	a5,10
     8d6:	08f51563          	bne	a0,a5,960 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8da:	4629                	li	a2,10
     8dc:	85d6                	mv	a1,s5
     8de:	854a                	mv	a0,s2
     8e0:	394040ef          	jal	ra,4c74 <write>
     8e4:	47a9                	li	a5,10
     8e6:	08f51863          	bne	a0,a5,976 <writetest+0xee>
  for(i = 0; i < N; i++){
     8ea:	2485                	addiw	s1,s1,1
     8ec:	fd449fe3          	bne	s1,s4,8ca <writetest+0x42>
  close(fd);
     8f0:	854a                	mv	a0,s2
     8f2:	38a040ef          	jal	ra,4c7c <close>
  fd = open("small", O_RDONLY);
     8f6:	4581                	li	a1,0
     8f8:	00005517          	auipc	a0,0x5
     8fc:	c8850513          	addi	a0,a0,-888 # 5580 <malloc+0x44c>
     900:	394040ef          	jal	ra,4c94 <open>
     904:	84aa                	mv	s1,a0
  if(fd < 0){
     906:	08054363          	bltz	a0,98c <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     90a:	7d000613          	li	a2,2000
     90e:	0000b597          	auipc	a1,0xb
     912:	39a58593          	addi	a1,a1,922 # bca8 <buf>
     916:	356040ef          	jal	ra,4c6c <read>
  if(i != N*SZ*2){
     91a:	7d000793          	li	a5,2000
     91e:	08f51163          	bne	a0,a5,9a0 <writetest+0x118>
  close(fd);
     922:	8526                	mv	a0,s1
     924:	358040ef          	jal	ra,4c7c <close>
  if(unlink("small") < 0){
     928:	00005517          	auipc	a0,0x5
     92c:	c5850513          	addi	a0,a0,-936 # 5580 <malloc+0x44c>
     930:	374040ef          	jal	ra,4ca4 <unlink>
     934:	08054063          	bltz	a0,9b4 <writetest+0x12c>
}
     938:	70e2                	ld	ra,56(sp)
     93a:	7442                	ld	s0,48(sp)
     93c:	74a2                	ld	s1,40(sp)
     93e:	7902                	ld	s2,32(sp)
     940:	69e2                	ld	s3,24(sp)
     942:	6a42                	ld	s4,16(sp)
     944:	6aa2                	ld	s5,8(sp)
     946:	6b02                	ld	s6,0(sp)
     948:	6121                	addi	sp,sp,64
     94a:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     94c:	85da                	mv	a1,s6
     94e:	00005517          	auipc	a0,0x5
     952:	c3a50513          	addi	a0,a0,-966 # 5588 <malloc+0x454>
     956:	724040ef          	jal	ra,507a <printf>
    exit(1);
     95a:	4505                	li	a0,1
     95c:	2f8040ef          	jal	ra,4c54 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     960:	8626                	mv	a2,s1
     962:	85da                	mv	a1,s6
     964:	00005517          	auipc	a0,0x5
     968:	c5450513          	addi	a0,a0,-940 # 55b8 <malloc+0x484>
     96c:	70e040ef          	jal	ra,507a <printf>
      exit(1);
     970:	4505                	li	a0,1
     972:	2e2040ef          	jal	ra,4c54 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     976:	8626                	mv	a2,s1
     978:	85da                	mv	a1,s6
     97a:	00005517          	auipc	a0,0x5
     97e:	c7650513          	addi	a0,a0,-906 # 55f0 <malloc+0x4bc>
     982:	6f8040ef          	jal	ra,507a <printf>
      exit(1);
     986:	4505                	li	a0,1
     988:	2cc040ef          	jal	ra,4c54 <exit>
    printf("%s: error: open small failed!\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	c8a50513          	addi	a0,a0,-886 # 5618 <malloc+0x4e4>
     996:	6e4040ef          	jal	ra,507a <printf>
    exit(1);
     99a:	4505                	li	a0,1
     99c:	2b8040ef          	jal	ra,4c54 <exit>
    printf("%s: read failed\n", s);
     9a0:	85da                	mv	a1,s6
     9a2:	00005517          	auipc	a0,0x5
     9a6:	c9650513          	addi	a0,a0,-874 # 5638 <malloc+0x504>
     9aa:	6d0040ef          	jal	ra,507a <printf>
    exit(1);
     9ae:	4505                	li	a0,1
     9b0:	2a4040ef          	jal	ra,4c54 <exit>
    printf("%s: unlink small failed\n", s);
     9b4:	85da                	mv	a1,s6
     9b6:	00005517          	auipc	a0,0x5
     9ba:	c9a50513          	addi	a0,a0,-870 # 5650 <malloc+0x51c>
     9be:	6bc040ef          	jal	ra,507a <printf>
    exit(1);
     9c2:	4505                	li	a0,1
     9c4:	290040ef          	jal	ra,4c54 <exit>

00000000000009c8 <writebig>:
{
     9c8:	7139                	addi	sp,sp,-64
     9ca:	fc06                	sd	ra,56(sp)
     9cc:	f822                	sd	s0,48(sp)
     9ce:	f426                	sd	s1,40(sp)
     9d0:	f04a                	sd	s2,32(sp)
     9d2:	ec4e                	sd	s3,24(sp)
     9d4:	e852                	sd	s4,16(sp)
     9d6:	e456                	sd	s5,8(sp)
     9d8:	0080                	addi	s0,sp,64
     9da:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9dc:	20200593          	li	a1,514
     9e0:	00005517          	auipc	a0,0x5
     9e4:	c9050513          	addi	a0,a0,-880 # 5670 <malloc+0x53c>
     9e8:	2ac040ef          	jal	ra,4c94 <open>
     9ec:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9ee:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9f0:	0000b917          	auipc	s2,0xb
     9f4:	2b890913          	addi	s2,s2,696 # bca8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f8:	10c00a13          	li	s4,268
  if(fd < 0){
     9fc:	06054463          	bltz	a0,a64 <writebig+0x9c>
    ((int*)buf)[0] = i;
     a00:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     a04:	40000613          	li	a2,1024
     a08:	85ca                	mv	a1,s2
     a0a:	854e                	mv	a0,s3
     a0c:	268040ef          	jal	ra,4c74 <write>
     a10:	40000793          	li	a5,1024
     a14:	06f51263          	bne	a0,a5,a78 <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a18:	2485                	addiw	s1,s1,1
     a1a:	ff4493e3          	bne	s1,s4,a00 <writebig+0x38>
  close(fd);
     a1e:	854e                	mv	a0,s3
     a20:	25c040ef          	jal	ra,4c7c <close>
  fd = open("big", O_RDONLY);
     a24:	4581                	li	a1,0
     a26:	00005517          	auipc	a0,0x5
     a2a:	c4a50513          	addi	a0,a0,-950 # 5670 <malloc+0x53c>
     a2e:	266040ef          	jal	ra,4c94 <open>
     a32:	89aa                	mv	s3,a0
  n = 0;
     a34:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a36:	0000b917          	auipc	s2,0xb
     a3a:	27290913          	addi	s2,s2,626 # bca8 <buf>
  if(fd < 0){
     a3e:	04054863          	bltz	a0,a8e <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a42:	40000613          	li	a2,1024
     a46:	85ca                	mv	a1,s2
     a48:	854e                	mv	a0,s3
     a4a:	222040ef          	jal	ra,4c6c <read>
    if(i == 0){
     a4e:	c931                	beqz	a0,aa2 <writebig+0xda>
    } else if(i != BSIZE){
     a50:	40000793          	li	a5,1024
     a54:	08f51a63          	bne	a0,a5,ae8 <writebig+0x120>
    if(((int*)buf)[0] != n){
     a58:	00092683          	lw	a3,0(s2)
     a5c:	0a969163          	bne	a3,s1,afe <writebig+0x136>
    n++;
     a60:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a62:	b7c5                	j	a42 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a64:	85d6                	mv	a1,s5
     a66:	00005517          	auipc	a0,0x5
     a6a:	c1250513          	addi	a0,a0,-1006 # 5678 <malloc+0x544>
     a6e:	60c040ef          	jal	ra,507a <printf>
    exit(1);
     a72:	4505                	li	a0,1
     a74:	1e0040ef          	jal	ra,4c54 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a78:	8626                	mv	a2,s1
     a7a:	85d6                	mv	a1,s5
     a7c:	00005517          	auipc	a0,0x5
     a80:	c1c50513          	addi	a0,a0,-996 # 5698 <malloc+0x564>
     a84:	5f6040ef          	jal	ra,507a <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	1ca040ef          	jal	ra,4c54 <exit>
    printf("%s: error: open big failed!\n", s);
     a8e:	85d6                	mv	a1,s5
     a90:	00005517          	auipc	a0,0x5
     a94:	c3050513          	addi	a0,a0,-976 # 56c0 <malloc+0x58c>
     a98:	5e2040ef          	jal	ra,507a <printf>
    exit(1);
     a9c:	4505                	li	a0,1
     a9e:	1b6040ef          	jal	ra,4c54 <exit>
      if(n != MAXFILE){
     aa2:	10c00793          	li	a5,268
     aa6:	02f49663          	bne	s1,a5,ad2 <writebig+0x10a>
  close(fd);
     aaa:	854e                	mv	a0,s3
     aac:	1d0040ef          	jal	ra,4c7c <close>
  if(unlink("big") < 0){
     ab0:	00005517          	auipc	a0,0x5
     ab4:	bc050513          	addi	a0,a0,-1088 # 5670 <malloc+0x53c>
     ab8:	1ec040ef          	jal	ra,4ca4 <unlink>
     abc:	04054c63          	bltz	a0,b14 <writebig+0x14c>
}
     ac0:	70e2                	ld	ra,56(sp)
     ac2:	7442                	ld	s0,48(sp)
     ac4:	74a2                	ld	s1,40(sp)
     ac6:	7902                	ld	s2,32(sp)
     ac8:	69e2                	ld	s3,24(sp)
     aca:	6a42                	ld	s4,16(sp)
     acc:	6aa2                	ld	s5,8(sp)
     ace:	6121                	addi	sp,sp,64
     ad0:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ad2:	8626                	mv	a2,s1
     ad4:	85d6                	mv	a1,s5
     ad6:	00005517          	auipc	a0,0x5
     ada:	c0a50513          	addi	a0,a0,-1014 # 56e0 <malloc+0x5ac>
     ade:	59c040ef          	jal	ra,507a <printf>
        exit(1);
     ae2:	4505                	li	a0,1
     ae4:	170040ef          	jal	ra,4c54 <exit>
      printf("%s: read failed %d\n", s, i);
     ae8:	862a                	mv	a2,a0
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	c1c50513          	addi	a0,a0,-996 # 5708 <malloc+0x5d4>
     af4:	586040ef          	jal	ra,507a <printf>
      exit(1);
     af8:	4505                	li	a0,1
     afa:	15a040ef          	jal	ra,4c54 <exit>
      printf("%s: read content of block %d is %d\n", s,
     afe:	8626                	mv	a2,s1
     b00:	85d6                	mv	a1,s5
     b02:	00005517          	auipc	a0,0x5
     b06:	c1e50513          	addi	a0,a0,-994 # 5720 <malloc+0x5ec>
     b0a:	570040ef          	jal	ra,507a <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	144040ef          	jal	ra,4c54 <exit>
    printf("%s: unlink big failed\n", s);
     b14:	85d6                	mv	a1,s5
     b16:	00005517          	auipc	a0,0x5
     b1a:	c3250513          	addi	a0,a0,-974 # 5748 <malloc+0x614>
     b1e:	55c040ef          	jal	ra,507a <printf>
    exit(1);
     b22:	4505                	li	a0,1
     b24:	130040ef          	jal	ra,4c54 <exit>

0000000000000b28 <unlinkread>:
{
     b28:	7179                	addi	sp,sp,-48
     b2a:	f406                	sd	ra,40(sp)
     b2c:	f022                	sd	s0,32(sp)
     b2e:	ec26                	sd	s1,24(sp)
     b30:	e84a                	sd	s2,16(sp)
     b32:	e44e                	sd	s3,8(sp)
     b34:	1800                	addi	s0,sp,48
     b36:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b38:	20200593          	li	a1,514
     b3c:	00005517          	auipc	a0,0x5
     b40:	c2450513          	addi	a0,a0,-988 # 5760 <malloc+0x62c>
     b44:	150040ef          	jal	ra,4c94 <open>
  if(fd < 0){
     b48:	0a054f63          	bltz	a0,c06 <unlinkread+0xde>
     b4c:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b4e:	4615                	li	a2,5
     b50:	00005597          	auipc	a1,0x5
     b54:	c4058593          	addi	a1,a1,-960 # 5790 <malloc+0x65c>
     b58:	11c040ef          	jal	ra,4c74 <write>
  close(fd);
     b5c:	8526                	mv	a0,s1
     b5e:	11e040ef          	jal	ra,4c7c <close>
  fd = open("unlinkread", O_RDWR);
     b62:	4589                	li	a1,2
     b64:	00005517          	auipc	a0,0x5
     b68:	bfc50513          	addi	a0,a0,-1028 # 5760 <malloc+0x62c>
     b6c:	128040ef          	jal	ra,4c94 <open>
     b70:	84aa                	mv	s1,a0
  if(fd < 0){
     b72:	0a054463          	bltz	a0,c1a <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b76:	00005517          	auipc	a0,0x5
     b7a:	bea50513          	addi	a0,a0,-1046 # 5760 <malloc+0x62c>
     b7e:	126040ef          	jal	ra,4ca4 <unlink>
     b82:	e555                	bnez	a0,c2e <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	bd850513          	addi	a0,a0,-1064 # 5760 <malloc+0x62c>
     b90:	104040ef          	jal	ra,4c94 <open>
     b94:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b96:	460d                	li	a2,3
     b98:	00005597          	auipc	a1,0x5
     b9c:	c4058593          	addi	a1,a1,-960 # 57d8 <malloc+0x6a4>
     ba0:	0d4040ef          	jal	ra,4c74 <write>
  close(fd1);
     ba4:	854a                	mv	a0,s2
     ba6:	0d6040ef          	jal	ra,4c7c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     baa:	660d                	lui	a2,0x3
     bac:	0000b597          	auipc	a1,0xb
     bb0:	0fc58593          	addi	a1,a1,252 # bca8 <buf>
     bb4:	8526                	mv	a0,s1
     bb6:	0b6040ef          	jal	ra,4c6c <read>
     bba:	4795                	li	a5,5
     bbc:	08f51363          	bne	a0,a5,c42 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bc0:	0000b717          	auipc	a4,0xb
     bc4:	0e874703          	lbu	a4,232(a4) # bca8 <buf>
     bc8:	06800793          	li	a5,104
     bcc:	08f71563          	bne	a4,a5,c56 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bd0:	4629                	li	a2,10
     bd2:	0000b597          	auipc	a1,0xb
     bd6:	0d658593          	addi	a1,a1,214 # bca8 <buf>
     bda:	8526                	mv	a0,s1
     bdc:	098040ef          	jal	ra,4c74 <write>
     be0:	47a9                	li	a5,10
     be2:	08f51463          	bne	a0,a5,c6a <unlinkread+0x142>
  close(fd);
     be6:	8526                	mv	a0,s1
     be8:	094040ef          	jal	ra,4c7c <close>
  unlink("unlinkread");
     bec:	00005517          	auipc	a0,0x5
     bf0:	b7450513          	addi	a0,a0,-1164 # 5760 <malloc+0x62c>
     bf4:	0b0040ef          	jal	ra,4ca4 <unlink>
}
     bf8:	70a2                	ld	ra,40(sp)
     bfa:	7402                	ld	s0,32(sp)
     bfc:	64e2                	ld	s1,24(sp)
     bfe:	6942                	ld	s2,16(sp)
     c00:	69a2                	ld	s3,8(sp)
     c02:	6145                	addi	sp,sp,48
     c04:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c06:	85ce                	mv	a1,s3
     c08:	00005517          	auipc	a0,0x5
     c0c:	b6850513          	addi	a0,a0,-1176 # 5770 <malloc+0x63c>
     c10:	46a040ef          	jal	ra,507a <printf>
    exit(1);
     c14:	4505                	li	a0,1
     c16:	03e040ef          	jal	ra,4c54 <exit>
    printf("%s: open unlinkread failed\n", s);
     c1a:	85ce                	mv	a1,s3
     c1c:	00005517          	auipc	a0,0x5
     c20:	b7c50513          	addi	a0,a0,-1156 # 5798 <malloc+0x664>
     c24:	456040ef          	jal	ra,507a <printf>
    exit(1);
     c28:	4505                	li	a0,1
     c2a:	02a040ef          	jal	ra,4c54 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c2e:	85ce                	mv	a1,s3
     c30:	00005517          	auipc	a0,0x5
     c34:	b8850513          	addi	a0,a0,-1144 # 57b8 <malloc+0x684>
     c38:	442040ef          	jal	ra,507a <printf>
    exit(1);
     c3c:	4505                	li	a0,1
     c3e:	016040ef          	jal	ra,4c54 <exit>
    printf("%s: unlinkread read failed", s);
     c42:	85ce                	mv	a1,s3
     c44:	00005517          	auipc	a0,0x5
     c48:	b9c50513          	addi	a0,a0,-1124 # 57e0 <malloc+0x6ac>
     c4c:	42e040ef          	jal	ra,507a <printf>
    exit(1);
     c50:	4505                	li	a0,1
     c52:	002040ef          	jal	ra,4c54 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c56:	85ce                	mv	a1,s3
     c58:	00005517          	auipc	a0,0x5
     c5c:	ba850513          	addi	a0,a0,-1112 # 5800 <malloc+0x6cc>
     c60:	41a040ef          	jal	ra,507a <printf>
    exit(1);
     c64:	4505                	li	a0,1
     c66:	7ef030ef          	jal	ra,4c54 <exit>
    printf("%s: unlinkread write failed\n", s);
     c6a:	85ce                	mv	a1,s3
     c6c:	00005517          	auipc	a0,0x5
     c70:	bb450513          	addi	a0,a0,-1100 # 5820 <malloc+0x6ec>
     c74:	406040ef          	jal	ra,507a <printf>
    exit(1);
     c78:	4505                	li	a0,1
     c7a:	7db030ef          	jal	ra,4c54 <exit>

0000000000000c7e <linktest>:
{
     c7e:	1101                	addi	sp,sp,-32
     c80:	ec06                	sd	ra,24(sp)
     c82:	e822                	sd	s0,16(sp)
     c84:	e426                	sd	s1,8(sp)
     c86:	e04a                	sd	s2,0(sp)
     c88:	1000                	addi	s0,sp,32
     c8a:	892a                	mv	s2,a0
  unlink("lf1");
     c8c:	00005517          	auipc	a0,0x5
     c90:	bb450513          	addi	a0,a0,-1100 # 5840 <malloc+0x70c>
     c94:	010040ef          	jal	ra,4ca4 <unlink>
  unlink("lf2");
     c98:	00005517          	auipc	a0,0x5
     c9c:	bb050513          	addi	a0,a0,-1104 # 5848 <malloc+0x714>
     ca0:	004040ef          	jal	ra,4ca4 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     ca4:	20200593          	li	a1,514
     ca8:	00005517          	auipc	a0,0x5
     cac:	b9850513          	addi	a0,a0,-1128 # 5840 <malloc+0x70c>
     cb0:	7e5030ef          	jal	ra,4c94 <open>
  if(fd < 0){
     cb4:	0c054f63          	bltz	a0,d92 <linktest+0x114>
     cb8:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cba:	4615                	li	a2,5
     cbc:	00005597          	auipc	a1,0x5
     cc0:	ad458593          	addi	a1,a1,-1324 # 5790 <malloc+0x65c>
     cc4:	7b1030ef          	jal	ra,4c74 <write>
     cc8:	4795                	li	a5,5
     cca:	0cf51e63          	bne	a0,a5,da6 <linktest+0x128>
  close(fd);
     cce:	8526                	mv	a0,s1
     cd0:	7ad030ef          	jal	ra,4c7c <close>
  if(link("lf1", "lf2") < 0){
     cd4:	00005597          	auipc	a1,0x5
     cd8:	b7458593          	addi	a1,a1,-1164 # 5848 <malloc+0x714>
     cdc:	00005517          	auipc	a0,0x5
     ce0:	b6450513          	addi	a0,a0,-1180 # 5840 <malloc+0x70c>
     ce4:	7d1030ef          	jal	ra,4cb4 <link>
     ce8:	0c054963          	bltz	a0,dba <linktest+0x13c>
  unlink("lf1");
     cec:	00005517          	auipc	a0,0x5
     cf0:	b5450513          	addi	a0,a0,-1196 # 5840 <malloc+0x70c>
     cf4:	7b1030ef          	jal	ra,4ca4 <unlink>
  if(open("lf1", 0) >= 0){
     cf8:	4581                	li	a1,0
     cfa:	00005517          	auipc	a0,0x5
     cfe:	b4650513          	addi	a0,a0,-1210 # 5840 <malloc+0x70c>
     d02:	793030ef          	jal	ra,4c94 <open>
     d06:	0c055463          	bgez	a0,dce <linktest+0x150>
  fd = open("lf2", 0);
     d0a:	4581                	li	a1,0
     d0c:	00005517          	auipc	a0,0x5
     d10:	b3c50513          	addi	a0,a0,-1220 # 5848 <malloc+0x714>
     d14:	781030ef          	jal	ra,4c94 <open>
     d18:	84aa                	mv	s1,a0
  if(fd < 0){
     d1a:	0c054463          	bltz	a0,de2 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d1e:	660d                	lui	a2,0x3
     d20:	0000b597          	auipc	a1,0xb
     d24:	f8858593          	addi	a1,a1,-120 # bca8 <buf>
     d28:	745030ef          	jal	ra,4c6c <read>
     d2c:	4795                	li	a5,5
     d2e:	0cf51463          	bne	a0,a5,df6 <linktest+0x178>
  close(fd);
     d32:	8526                	mv	a0,s1
     d34:	749030ef          	jal	ra,4c7c <close>
  if(link("lf2", "lf2") >= 0){
     d38:	00005597          	auipc	a1,0x5
     d3c:	b1058593          	addi	a1,a1,-1264 # 5848 <malloc+0x714>
     d40:	852e                	mv	a0,a1
     d42:	773030ef          	jal	ra,4cb4 <link>
     d46:	0c055263          	bgez	a0,e0a <linktest+0x18c>
  unlink("lf2");
     d4a:	00005517          	auipc	a0,0x5
     d4e:	afe50513          	addi	a0,a0,-1282 # 5848 <malloc+0x714>
     d52:	753030ef          	jal	ra,4ca4 <unlink>
  if(link("lf2", "lf1") >= 0){
     d56:	00005597          	auipc	a1,0x5
     d5a:	aea58593          	addi	a1,a1,-1302 # 5840 <malloc+0x70c>
     d5e:	00005517          	auipc	a0,0x5
     d62:	aea50513          	addi	a0,a0,-1302 # 5848 <malloc+0x714>
     d66:	74f030ef          	jal	ra,4cb4 <link>
     d6a:	0a055a63          	bgez	a0,e1e <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d6e:	00005597          	auipc	a1,0x5
     d72:	ad258593          	addi	a1,a1,-1326 # 5840 <malloc+0x70c>
     d76:	00005517          	auipc	a0,0x5
     d7a:	bda50513          	addi	a0,a0,-1062 # 5950 <malloc+0x81c>
     d7e:	737030ef          	jal	ra,4cb4 <link>
     d82:	0a055863          	bgez	a0,e32 <linktest+0x1b4>
}
     d86:	60e2                	ld	ra,24(sp)
     d88:	6442                	ld	s0,16(sp)
     d8a:	64a2                	ld	s1,8(sp)
     d8c:	6902                	ld	s2,0(sp)
     d8e:	6105                	addi	sp,sp,32
     d90:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d92:	85ca                	mv	a1,s2
     d94:	00005517          	auipc	a0,0x5
     d98:	abc50513          	addi	a0,a0,-1348 # 5850 <malloc+0x71c>
     d9c:	2de040ef          	jal	ra,507a <printf>
    exit(1);
     da0:	4505                	li	a0,1
     da2:	6b3030ef          	jal	ra,4c54 <exit>
    printf("%s: write lf1 failed\n", s);
     da6:	85ca                	mv	a1,s2
     da8:	00005517          	auipc	a0,0x5
     dac:	ac050513          	addi	a0,a0,-1344 # 5868 <malloc+0x734>
     db0:	2ca040ef          	jal	ra,507a <printf>
    exit(1);
     db4:	4505                	li	a0,1
     db6:	69f030ef          	jal	ra,4c54 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     dba:	85ca                	mv	a1,s2
     dbc:	00005517          	auipc	a0,0x5
     dc0:	ac450513          	addi	a0,a0,-1340 # 5880 <malloc+0x74c>
     dc4:	2b6040ef          	jal	ra,507a <printf>
    exit(1);
     dc8:	4505                	li	a0,1
     dca:	68b030ef          	jal	ra,4c54 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dce:	85ca                	mv	a1,s2
     dd0:	00005517          	auipc	a0,0x5
     dd4:	ad050513          	addi	a0,a0,-1328 # 58a0 <malloc+0x76c>
     dd8:	2a2040ef          	jal	ra,507a <printf>
    exit(1);
     ddc:	4505                	li	a0,1
     dde:	677030ef          	jal	ra,4c54 <exit>
    printf("%s: open lf2 failed\n", s);
     de2:	85ca                	mv	a1,s2
     de4:	00005517          	auipc	a0,0x5
     de8:	aec50513          	addi	a0,a0,-1300 # 58d0 <malloc+0x79c>
     dec:	28e040ef          	jal	ra,507a <printf>
    exit(1);
     df0:	4505                	li	a0,1
     df2:	663030ef          	jal	ra,4c54 <exit>
    printf("%s: read lf2 failed\n", s);
     df6:	85ca                	mv	a1,s2
     df8:	00005517          	auipc	a0,0x5
     dfc:	af050513          	addi	a0,a0,-1296 # 58e8 <malloc+0x7b4>
     e00:	27a040ef          	jal	ra,507a <printf>
    exit(1);
     e04:	4505                	li	a0,1
     e06:	64f030ef          	jal	ra,4c54 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e0a:	85ca                	mv	a1,s2
     e0c:	00005517          	auipc	a0,0x5
     e10:	af450513          	addi	a0,a0,-1292 # 5900 <malloc+0x7cc>
     e14:	266040ef          	jal	ra,507a <printf>
    exit(1);
     e18:	4505                	li	a0,1
     e1a:	63b030ef          	jal	ra,4c54 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e1e:	85ca                	mv	a1,s2
     e20:	00005517          	auipc	a0,0x5
     e24:	b0850513          	addi	a0,a0,-1272 # 5928 <malloc+0x7f4>
     e28:	252040ef          	jal	ra,507a <printf>
    exit(1);
     e2c:	4505                	li	a0,1
     e2e:	627030ef          	jal	ra,4c54 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e32:	85ca                	mv	a1,s2
     e34:	00005517          	auipc	a0,0x5
     e38:	b2450513          	addi	a0,a0,-1244 # 5958 <malloc+0x824>
     e3c:	23e040ef          	jal	ra,507a <printf>
    exit(1);
     e40:	4505                	li	a0,1
     e42:	613030ef          	jal	ra,4c54 <exit>

0000000000000e46 <validatetest>:
{
     e46:	7139                	addi	sp,sp,-64
     e48:	fc06                	sd	ra,56(sp)
     e4a:	f822                	sd	s0,48(sp)
     e4c:	f426                	sd	s1,40(sp)
     e4e:	f04a                	sd	s2,32(sp)
     e50:	ec4e                	sd	s3,24(sp)
     e52:	e852                	sd	s4,16(sp)
     e54:	e456                	sd	s5,8(sp)
     e56:	e05a                	sd	s6,0(sp)
     e58:	0080                	addi	s0,sp,64
     e5a:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5c:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e5e:	00005997          	auipc	s3,0x5
     e62:	b1a98993          	addi	s3,s3,-1254 # 5978 <malloc+0x844>
     e66:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e68:	6a85                	lui	s5,0x1
     e6a:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e6e:	85a6                	mv	a1,s1
     e70:	854e                	mv	a0,s3
     e72:	643030ef          	jal	ra,4cb4 <link>
     e76:	01251f63          	bne	a0,s2,e94 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e7a:	94d6                	add	s1,s1,s5
     e7c:	ff4499e3          	bne	s1,s4,e6e <validatetest+0x28>
}
     e80:	70e2                	ld	ra,56(sp)
     e82:	7442                	ld	s0,48(sp)
     e84:	74a2                	ld	s1,40(sp)
     e86:	7902                	ld	s2,32(sp)
     e88:	69e2                	ld	s3,24(sp)
     e8a:	6a42                	ld	s4,16(sp)
     e8c:	6aa2                	ld	s5,8(sp)
     e8e:	6b02                	ld	s6,0(sp)
     e90:	6121                	addi	sp,sp,64
     e92:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e94:	85da                	mv	a1,s6
     e96:	00005517          	auipc	a0,0x5
     e9a:	af250513          	addi	a0,a0,-1294 # 5988 <malloc+0x854>
     e9e:	1dc040ef          	jal	ra,507a <printf>
      exit(1);
     ea2:	4505                	li	a0,1
     ea4:	5b1030ef          	jal	ra,4c54 <exit>

0000000000000ea8 <bigdir>:
{
     ea8:	715d                	addi	sp,sp,-80
     eaa:	e486                	sd	ra,72(sp)
     eac:	e0a2                	sd	s0,64(sp)
     eae:	fc26                	sd	s1,56(sp)
     eb0:	f84a                	sd	s2,48(sp)
     eb2:	f44e                	sd	s3,40(sp)
     eb4:	f052                	sd	s4,32(sp)
     eb6:	ec56                	sd	s5,24(sp)
     eb8:	e85a                	sd	s6,16(sp)
     eba:	0880                	addi	s0,sp,80
     ebc:	89aa                	mv	s3,a0
  unlink("bd");
     ebe:	00005517          	auipc	a0,0x5
     ec2:	aea50513          	addi	a0,a0,-1302 # 59a8 <malloc+0x874>
     ec6:	5df030ef          	jal	ra,4ca4 <unlink>
  fd = open("bd", O_CREATE);
     eca:	20000593          	li	a1,512
     ece:	00005517          	auipc	a0,0x5
     ed2:	ada50513          	addi	a0,a0,-1318 # 59a8 <malloc+0x874>
     ed6:	5bf030ef          	jal	ra,4c94 <open>
  if(fd < 0){
     eda:	0c054163          	bltz	a0,f9c <bigdir+0xf4>
  close(fd);
     ede:	59f030ef          	jal	ra,4c7c <close>
  for(i = 0; i < N; i++){
     ee2:	4901                	li	s2,0
    name[0] = 'x';
     ee4:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ee8:	00005a17          	auipc	s4,0x5
     eec:	ac0a0a13          	addi	s4,s4,-1344 # 59a8 <malloc+0x874>
  for(i = 0; i < N; i++){
     ef0:	1f400b13          	li	s6,500
    name[0] = 'x';
     ef4:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     ef8:	41f9579b          	sraiw	a5,s2,0x1f
     efc:	01a7d71b          	srliw	a4,a5,0x1a
     f00:	012707bb          	addw	a5,a4,s2
     f04:	4067d69b          	sraiw	a3,a5,0x6
     f08:	0306869b          	addiw	a3,a3,48
     f0c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f10:	03f7f793          	andi	a5,a5,63
     f14:	9f99                	subw	a5,a5,a4
     f16:	0307879b          	addiw	a5,a5,48
     f1a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f1e:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f22:	fb040593          	addi	a1,s0,-80
     f26:	8552                	mv	a0,s4
     f28:	58d030ef          	jal	ra,4cb4 <link>
     f2c:	84aa                	mv	s1,a0
     f2e:	e149                	bnez	a0,fb0 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f30:	2905                	addiw	s2,s2,1
     f32:	fd6911e3          	bne	s2,s6,ef4 <bigdir+0x4c>
  unlink("bd");
     f36:	00005517          	auipc	a0,0x5
     f3a:	a7250513          	addi	a0,a0,-1422 # 59a8 <malloc+0x874>
     f3e:	567030ef          	jal	ra,4ca4 <unlink>
    name[0] = 'x';
     f42:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f46:	1f400a13          	li	s4,500
    name[0] = 'x';
     f4a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f4e:	41f4d79b          	sraiw	a5,s1,0x1f
     f52:	01a7d71b          	srliw	a4,a5,0x1a
     f56:	009707bb          	addw	a5,a4,s1
     f5a:	4067d69b          	sraiw	a3,a5,0x6
     f5e:	0306869b          	addiw	a3,a3,48
     f62:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f66:	03f7f793          	andi	a5,a5,63
     f6a:	9f99                	subw	a5,a5,a4
     f6c:	0307879b          	addiw	a5,a5,48
     f70:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f74:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f78:	fb040513          	addi	a0,s0,-80
     f7c:	529030ef          	jal	ra,4ca4 <unlink>
     f80:	e529                	bnez	a0,fca <bigdir+0x122>
  for(i = 0; i < N; i++){
     f82:	2485                	addiw	s1,s1,1
     f84:	fd4493e3          	bne	s1,s4,f4a <bigdir+0xa2>
}
     f88:	60a6                	ld	ra,72(sp)
     f8a:	6406                	ld	s0,64(sp)
     f8c:	74e2                	ld	s1,56(sp)
     f8e:	7942                	ld	s2,48(sp)
     f90:	79a2                	ld	s3,40(sp)
     f92:	7a02                	ld	s4,32(sp)
     f94:	6ae2                	ld	s5,24(sp)
     f96:	6b42                	ld	s6,16(sp)
     f98:	6161                	addi	sp,sp,80
     f9a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f9c:	85ce                	mv	a1,s3
     f9e:	00005517          	auipc	a0,0x5
     fa2:	a1250513          	addi	a0,a0,-1518 # 59b0 <malloc+0x87c>
     fa6:	0d4040ef          	jal	ra,507a <printf>
    exit(1);
     faa:	4505                	li	a0,1
     fac:	4a9030ef          	jal	ra,4c54 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fb0:	fb040693          	addi	a3,s0,-80
     fb4:	864a                	mv	a2,s2
     fb6:	85ce                	mv	a1,s3
     fb8:	00005517          	auipc	a0,0x5
     fbc:	a1850513          	addi	a0,a0,-1512 # 59d0 <malloc+0x89c>
     fc0:	0ba040ef          	jal	ra,507a <printf>
      exit(1);
     fc4:	4505                	li	a0,1
     fc6:	48f030ef          	jal	ra,4c54 <exit>
      printf("%s: bigdir unlink failed", s);
     fca:	85ce                	mv	a1,s3
     fcc:	00005517          	auipc	a0,0x5
     fd0:	a2c50513          	addi	a0,a0,-1492 # 59f8 <malloc+0x8c4>
     fd4:	0a6040ef          	jal	ra,507a <printf>
      exit(1);
     fd8:	4505                	li	a0,1
     fda:	47b030ef          	jal	ra,4c54 <exit>

0000000000000fde <pgbug>:
{
     fde:	7179                	addi	sp,sp,-48
     fe0:	f406                	sd	ra,40(sp)
     fe2:	f022                	sd	s0,32(sp)
     fe4:	ec26                	sd	s1,24(sp)
     fe6:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fe8:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fec:	00007497          	auipc	s1,0x7
     ff0:	01448493          	addi	s1,s1,20 # 8000 <big>
     ff4:	fd840593          	addi	a1,s0,-40
     ff8:	6088                	ld	a0,0(s1)
     ffa:	493030ef          	jal	ra,4c8c <exec>
  pipe(big);
     ffe:	6088                	ld	a0,0(s1)
    1000:	465030ef          	jal	ra,4c64 <pipe>
  exit(0);
    1004:	4501                	li	a0,0
    1006:	44f030ef          	jal	ra,4c54 <exit>

000000000000100a <badarg>:
{
    100a:	7139                	addi	sp,sp,-64
    100c:	fc06                	sd	ra,56(sp)
    100e:	f822                	sd	s0,48(sp)
    1010:	f426                	sd	s1,40(sp)
    1012:	f04a                	sd	s2,32(sp)
    1014:	ec4e                	sd	s3,24(sp)
    1016:	0080                	addi	s0,sp,64
    1018:	64b1                	lui	s1,0xc
    101a:	35048493          	addi	s1,s1,848 # c350 <buf+0x6a8>
    argv[0] = (char*)0xffffffff;
    101e:	597d                	li	s2,-1
    1020:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1024:	00004997          	auipc	s3,0x4
    1028:	24498993          	addi	s3,s3,580 # 5268 <malloc+0x134>
    argv[0] = (char*)0xffffffff;
    102c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1030:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1034:	fc040593          	addi	a1,s0,-64
    1038:	854e                	mv	a0,s3
    103a:	453030ef          	jal	ra,4c8c <exec>
  for(int i = 0; i < 50000; i++){
    103e:	34fd                	addiw	s1,s1,-1
    1040:	f4f5                	bnez	s1,102c <badarg+0x22>
  exit(0);
    1042:	4501                	li	a0,0
    1044:	411030ef          	jal	ra,4c54 <exit>

0000000000001048 <copyinstr2>:
{
    1048:	7155                	addi	sp,sp,-208
    104a:	e586                	sd	ra,200(sp)
    104c:	e1a2                	sd	s0,192(sp)
    104e:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1050:	f6840793          	addi	a5,s0,-152
    1054:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1058:	07800713          	li	a4,120
    105c:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1060:	0785                	addi	a5,a5,1
    1062:	fed79de3          	bne	a5,a3,105c <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1066:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    106a:	f6840513          	addi	a0,s0,-152
    106e:	437030ef          	jal	ra,4ca4 <unlink>
  if(ret != -1){
    1072:	57fd                	li	a5,-1
    1074:	0cf51263          	bne	a0,a5,1138 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1078:	20100593          	li	a1,513
    107c:	f6840513          	addi	a0,s0,-152
    1080:	415030ef          	jal	ra,4c94 <open>
  if(fd != -1){
    1084:	57fd                	li	a5,-1
    1086:	0cf51563          	bne	a0,a5,1150 <copyinstr2+0x108>
  ret = link(b, b);
    108a:	f6840593          	addi	a1,s0,-152
    108e:	852e                	mv	a0,a1
    1090:	425030ef          	jal	ra,4cb4 <link>
  if(ret != -1){
    1094:	57fd                	li	a5,-1
    1096:	0cf51963          	bne	a0,a5,1168 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    109a:	00006797          	auipc	a5,0x6
    109e:	aae78793          	addi	a5,a5,-1362 # 6b48 <malloc+0x1a14>
    10a2:	f4f43c23          	sd	a5,-168(s0)
    10a6:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10aa:	f5840593          	addi	a1,s0,-168
    10ae:	f6840513          	addi	a0,s0,-152
    10b2:	3db030ef          	jal	ra,4c8c <exec>
  if(ret != -1){
    10b6:	57fd                	li	a5,-1
    10b8:	0cf51563          	bne	a0,a5,1182 <copyinstr2+0x13a>
  int pid = fork();
    10bc:	391030ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    10c0:	0c054d63          	bltz	a0,119a <copyinstr2+0x152>
  if(pid == 0){
    10c4:	0e051863          	bnez	a0,11b4 <copyinstr2+0x16c>
    10c8:	00007797          	auipc	a5,0x7
    10cc:	4c878793          	addi	a5,a5,1224 # 8590 <big.1277>
    10d0:	00008697          	auipc	a3,0x8
    10d4:	4c068693          	addi	a3,a3,1216 # 9590 <big.1277+0x1000>
      big[i] = 'x';
    10d8:	07800713          	li	a4,120
    10dc:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10e0:	0785                	addi	a5,a5,1
    10e2:	fed79de3          	bne	a5,a3,10dc <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10e6:	00008797          	auipc	a5,0x8
    10ea:	4a078523          	sb	zero,1194(a5) # 9590 <big.1277+0x1000>
    char *args2[] = { big, big, big, 0 };
    10ee:	00006797          	auipc	a5,0x6
    10f2:	5a278793          	addi	a5,a5,1442 # 7690 <malloc+0x255c>
    10f6:	6fb0                	ld	a2,88(a5)
    10f8:	73b4                	ld	a3,96(a5)
    10fa:	77b8                	ld	a4,104(a5)
    10fc:	7bbc                	ld	a5,112(a5)
    10fe:	f2c43823          	sd	a2,-208(s0)
    1102:	f2d43c23          	sd	a3,-200(s0)
    1106:	f4e43023          	sd	a4,-192(s0)
    110a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    110e:	f3040593          	addi	a1,s0,-208
    1112:	00004517          	auipc	a0,0x4
    1116:	15650513          	addi	a0,a0,342 # 5268 <malloc+0x134>
    111a:	373030ef          	jal	ra,4c8c <exec>
    if(ret != -1){
    111e:	57fd                	li	a5,-1
    1120:	08f50663          	beq	a0,a5,11ac <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1124:	55fd                	li	a1,-1
    1126:	00005517          	auipc	a0,0x5
    112a:	97a50513          	addi	a0,a0,-1670 # 5aa0 <malloc+0x96c>
    112e:	74d030ef          	jal	ra,507a <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	321030ef          	jal	ra,4c54 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1138:	862a                	mv	a2,a0
    113a:	f6840593          	addi	a1,s0,-152
    113e:	00005517          	auipc	a0,0x5
    1142:	8da50513          	addi	a0,a0,-1830 # 5a18 <malloc+0x8e4>
    1146:	735030ef          	jal	ra,507a <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	309030ef          	jal	ra,4c54 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1150:	862a                	mv	a2,a0
    1152:	f6840593          	addi	a1,s0,-152
    1156:	00005517          	auipc	a0,0x5
    115a:	8e250513          	addi	a0,a0,-1822 # 5a38 <malloc+0x904>
    115e:	71d030ef          	jal	ra,507a <printf>
    exit(1);
    1162:	4505                	li	a0,1
    1164:	2f1030ef          	jal	ra,4c54 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1168:	86aa                	mv	a3,a0
    116a:	f6840613          	addi	a2,s0,-152
    116e:	85b2                	mv	a1,a2
    1170:	00005517          	auipc	a0,0x5
    1174:	8e850513          	addi	a0,a0,-1816 # 5a58 <malloc+0x924>
    1178:	703030ef          	jal	ra,507a <printf>
    exit(1);
    117c:	4505                	li	a0,1
    117e:	2d7030ef          	jal	ra,4c54 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1182:	567d                	li	a2,-1
    1184:	f6840593          	addi	a1,s0,-152
    1188:	00005517          	auipc	a0,0x5
    118c:	8f850513          	addi	a0,a0,-1800 # 5a80 <malloc+0x94c>
    1190:	6eb030ef          	jal	ra,507a <printf>
    exit(1);
    1194:	4505                	li	a0,1
    1196:	2bf030ef          	jal	ra,4c54 <exit>
    printf("fork failed\n");
    119a:	00006517          	auipc	a0,0x6
    119e:	ee650513          	addi	a0,a0,-282 # 7080 <malloc+0x1f4c>
    11a2:	6d9030ef          	jal	ra,507a <printf>
    exit(1);
    11a6:	4505                	li	a0,1
    11a8:	2ad030ef          	jal	ra,4c54 <exit>
    exit(747); // OK
    11ac:	2eb00513          	li	a0,747
    11b0:	2a5030ef          	jal	ra,4c54 <exit>
  int st = 0;
    11b4:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b8:	f5440513          	addi	a0,s0,-172
    11bc:	2a1030ef          	jal	ra,4c5c <wait>
  if(st != 747){
    11c0:	f5442703          	lw	a4,-172(s0)
    11c4:	2eb00793          	li	a5,747
    11c8:	00f71663          	bne	a4,a5,11d4 <copyinstr2+0x18c>
}
    11cc:	60ae                	ld	ra,200(sp)
    11ce:	640e                	ld	s0,192(sp)
    11d0:	6169                	addi	sp,sp,208
    11d2:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11d4:	00005517          	auipc	a0,0x5
    11d8:	8f450513          	addi	a0,a0,-1804 # 5ac8 <malloc+0x994>
    11dc:	69f030ef          	jal	ra,507a <printf>
    exit(1);
    11e0:	4505                	li	a0,1
    11e2:	273030ef          	jal	ra,4c54 <exit>

00000000000011e6 <truncate3>:
{
    11e6:	7159                	addi	sp,sp,-112
    11e8:	f486                	sd	ra,104(sp)
    11ea:	f0a2                	sd	s0,96(sp)
    11ec:	eca6                	sd	s1,88(sp)
    11ee:	e8ca                	sd	s2,80(sp)
    11f0:	e4ce                	sd	s3,72(sp)
    11f2:	e0d2                	sd	s4,64(sp)
    11f4:	fc56                	sd	s5,56(sp)
    11f6:	1880                	addi	s0,sp,112
    11f8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11fa:	60100593          	li	a1,1537
    11fe:	00004517          	auipc	a0,0x4
    1202:	0c250513          	addi	a0,a0,194 # 52c0 <malloc+0x18c>
    1206:	28f030ef          	jal	ra,4c94 <open>
    120a:	273030ef          	jal	ra,4c7c <close>
  pid = fork();
    120e:	23f030ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    1212:	06054263          	bltz	a0,1276 <truncate3+0x90>
  if(pid == 0){
    1216:	ed59                	bnez	a0,12b4 <truncate3+0xce>
    1218:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    121c:	00004a17          	auipc	s4,0x4
    1220:	0a4a0a13          	addi	s4,s4,164 # 52c0 <malloc+0x18c>
      int n = write(fd, "1234567890", 10);
    1224:	00005a97          	auipc	s5,0x5
    1228:	904a8a93          	addi	s5,s5,-1788 # 5b28 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    122c:	4585                	li	a1,1
    122e:	8552                	mv	a0,s4
    1230:	265030ef          	jal	ra,4c94 <open>
    1234:	84aa                	mv	s1,a0
      if(fd < 0){
    1236:	04054a63          	bltz	a0,128a <truncate3+0xa4>
      int n = write(fd, "1234567890", 10);
    123a:	4629                	li	a2,10
    123c:	85d6                	mv	a1,s5
    123e:	237030ef          	jal	ra,4c74 <write>
      if(n != 10){
    1242:	47a9                	li	a5,10
    1244:	04f51d63          	bne	a0,a5,129e <truncate3+0xb8>
      close(fd);
    1248:	8526                	mv	a0,s1
    124a:	233030ef          	jal	ra,4c7c <close>
      fd = open("truncfile", O_RDONLY);
    124e:	4581                	li	a1,0
    1250:	8552                	mv	a0,s4
    1252:	243030ef          	jal	ra,4c94 <open>
    1256:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1258:	02000613          	li	a2,32
    125c:	f9840593          	addi	a1,s0,-104
    1260:	20d030ef          	jal	ra,4c6c <read>
      close(fd);
    1264:	8526                	mv	a0,s1
    1266:	217030ef          	jal	ra,4c7c <close>
    for(int i = 0; i < 100; i++){
    126a:	39fd                	addiw	s3,s3,-1
    126c:	fc0990e3          	bnez	s3,122c <truncate3+0x46>
    exit(0);
    1270:	4501                	li	a0,0
    1272:	1e3030ef          	jal	ra,4c54 <exit>
    printf("%s: fork failed\n", s);
    1276:	85ca                	mv	a1,s2
    1278:	00005517          	auipc	a0,0x5
    127c:	88050513          	addi	a0,a0,-1920 # 5af8 <malloc+0x9c4>
    1280:	5fb030ef          	jal	ra,507a <printf>
    exit(1);
    1284:	4505                	li	a0,1
    1286:	1cf030ef          	jal	ra,4c54 <exit>
        printf("%s: open failed\n", s);
    128a:	85ca                	mv	a1,s2
    128c:	00005517          	auipc	a0,0x5
    1290:	88450513          	addi	a0,a0,-1916 # 5b10 <malloc+0x9dc>
    1294:	5e7030ef          	jal	ra,507a <printf>
        exit(1);
    1298:	4505                	li	a0,1
    129a:	1bb030ef          	jal	ra,4c54 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    129e:	862a                	mv	a2,a0
    12a0:	85ca                	mv	a1,s2
    12a2:	00005517          	auipc	a0,0x5
    12a6:	89650513          	addi	a0,a0,-1898 # 5b38 <malloc+0xa04>
    12aa:	5d1030ef          	jal	ra,507a <printf>
        exit(1);
    12ae:	4505                	li	a0,1
    12b0:	1a5030ef          	jal	ra,4c54 <exit>
    12b4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12b8:	00004a17          	auipc	s4,0x4
    12bc:	008a0a13          	addi	s4,s4,8 # 52c0 <malloc+0x18c>
    int n = write(fd, "xxx", 3);
    12c0:	00005a97          	auipc	s5,0x5
    12c4:	898a8a93          	addi	s5,s5,-1896 # 5b58 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c8:	60100593          	li	a1,1537
    12cc:	8552                	mv	a0,s4
    12ce:	1c7030ef          	jal	ra,4c94 <open>
    12d2:	84aa                	mv	s1,a0
    if(fd < 0){
    12d4:	02054d63          	bltz	a0,130e <truncate3+0x128>
    int n = write(fd, "xxx", 3);
    12d8:	460d                	li	a2,3
    12da:	85d6                	mv	a1,s5
    12dc:	199030ef          	jal	ra,4c74 <write>
    if(n != 3){
    12e0:	478d                	li	a5,3
    12e2:	04f51063          	bne	a0,a5,1322 <truncate3+0x13c>
    close(fd);
    12e6:	8526                	mv	a0,s1
    12e8:	195030ef          	jal	ra,4c7c <close>
  for(int i = 0; i < 150; i++){
    12ec:	39fd                	addiw	s3,s3,-1
    12ee:	fc099de3          	bnez	s3,12c8 <truncate3+0xe2>
  wait(&xstatus);
    12f2:	fbc40513          	addi	a0,s0,-68
    12f6:	167030ef          	jal	ra,4c5c <wait>
  unlink("truncfile");
    12fa:	00004517          	auipc	a0,0x4
    12fe:	fc650513          	addi	a0,a0,-58 # 52c0 <malloc+0x18c>
    1302:	1a3030ef          	jal	ra,4ca4 <unlink>
  exit(xstatus);
    1306:	fbc42503          	lw	a0,-68(s0)
    130a:	14b030ef          	jal	ra,4c54 <exit>
      printf("%s: open failed\n", s);
    130e:	85ca                	mv	a1,s2
    1310:	00005517          	auipc	a0,0x5
    1314:	80050513          	addi	a0,a0,-2048 # 5b10 <malloc+0x9dc>
    1318:	563030ef          	jal	ra,507a <printf>
      exit(1);
    131c:	4505                	li	a0,1
    131e:	137030ef          	jal	ra,4c54 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1322:	862a                	mv	a2,a0
    1324:	85ca                	mv	a1,s2
    1326:	00005517          	auipc	a0,0x5
    132a:	83a50513          	addi	a0,a0,-1990 # 5b60 <malloc+0xa2c>
    132e:	54d030ef          	jal	ra,507a <printf>
      exit(1);
    1332:	4505                	li	a0,1
    1334:	121030ef          	jal	ra,4c54 <exit>

0000000000001338 <exectest>:
{
    1338:	715d                	addi	sp,sp,-80
    133a:	e486                	sd	ra,72(sp)
    133c:	e0a2                	sd	s0,64(sp)
    133e:	fc26                	sd	s1,56(sp)
    1340:	f84a                	sd	s2,48(sp)
    1342:	0880                	addi	s0,sp,80
    1344:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1346:	00004797          	auipc	a5,0x4
    134a:	f2278793          	addi	a5,a5,-222 # 5268 <malloc+0x134>
    134e:	fcf43023          	sd	a5,-64(s0)
    1352:	00005797          	auipc	a5,0x5
    1356:	82e78793          	addi	a5,a5,-2002 # 5b80 <malloc+0xa4c>
    135a:	fcf43423          	sd	a5,-56(s0)
    135e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1362:	00005517          	auipc	a0,0x5
    1366:	82650513          	addi	a0,a0,-2010 # 5b88 <malloc+0xa54>
    136a:	13b030ef          	jal	ra,4ca4 <unlink>
  pid = fork();
    136e:	0df030ef          	jal	ra,4c4c <fork>
  if(pid < 0) {
    1372:	02054e63          	bltz	a0,13ae <exectest+0x76>
    1376:	84aa                	mv	s1,a0
  if(pid == 0) {
    1378:	e92d                	bnez	a0,13ea <exectest+0xb2>
    close(1);
    137a:	4505                	li	a0,1
    137c:	101030ef          	jal	ra,4c7c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1380:	20100593          	li	a1,513
    1384:	00005517          	auipc	a0,0x5
    1388:	80450513          	addi	a0,a0,-2044 # 5b88 <malloc+0xa54>
    138c:	109030ef          	jal	ra,4c94 <open>
    if(fd < 0) {
    1390:	02054963          	bltz	a0,13c2 <exectest+0x8a>
    if(fd != 1) {
    1394:	4785                	li	a5,1
    1396:	04f50063          	beq	a0,a5,13d6 <exectest+0x9e>
      printf("%s: wrong fd\n", s);
    139a:	85ca                	mv	a1,s2
    139c:	00005517          	auipc	a0,0x5
    13a0:	80c50513          	addi	a0,a0,-2036 # 5ba8 <malloc+0xa74>
    13a4:	4d7030ef          	jal	ra,507a <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	0ab030ef          	jal	ra,4c54 <exit>
     printf("%s: fork failed\n", s);
    13ae:	85ca                	mv	a1,s2
    13b0:	00004517          	auipc	a0,0x4
    13b4:	74850513          	addi	a0,a0,1864 # 5af8 <malloc+0x9c4>
    13b8:	4c3030ef          	jal	ra,507a <printf>
     exit(1);
    13bc:	4505                	li	a0,1
    13be:	097030ef          	jal	ra,4c54 <exit>
      printf("%s: create failed\n", s);
    13c2:	85ca                	mv	a1,s2
    13c4:	00004517          	auipc	a0,0x4
    13c8:	7cc50513          	addi	a0,a0,1996 # 5b90 <malloc+0xa5c>
    13cc:	4af030ef          	jal	ra,507a <printf>
      exit(1);
    13d0:	4505                	li	a0,1
    13d2:	083030ef          	jal	ra,4c54 <exit>
    if(exec("echo", echoargv) < 0){
    13d6:	fc040593          	addi	a1,s0,-64
    13da:	00004517          	auipc	a0,0x4
    13de:	e8e50513          	addi	a0,a0,-370 # 5268 <malloc+0x134>
    13e2:	0ab030ef          	jal	ra,4c8c <exec>
    13e6:	00054d63          	bltz	a0,1400 <exectest+0xc8>
  if (wait(&xstatus) != pid) {
    13ea:	fdc40513          	addi	a0,s0,-36
    13ee:	06f030ef          	jal	ra,4c5c <wait>
    13f2:	02951163          	bne	a0,s1,1414 <exectest+0xdc>
  if(xstatus != 0)
    13f6:	fdc42503          	lw	a0,-36(s0)
    13fa:	c50d                	beqz	a0,1424 <exectest+0xec>
    exit(xstatus);
    13fc:	059030ef          	jal	ra,4c54 <exit>
      printf("%s: exec echo failed\n", s);
    1400:	85ca                	mv	a1,s2
    1402:	00004517          	auipc	a0,0x4
    1406:	7b650513          	addi	a0,a0,1974 # 5bb8 <malloc+0xa84>
    140a:	471030ef          	jal	ra,507a <printf>
      exit(1);
    140e:	4505                	li	a0,1
    1410:	045030ef          	jal	ra,4c54 <exit>
    printf("%s: wait failed!\n", s);
    1414:	85ca                	mv	a1,s2
    1416:	00004517          	auipc	a0,0x4
    141a:	7ba50513          	addi	a0,a0,1978 # 5bd0 <malloc+0xa9c>
    141e:	45d030ef          	jal	ra,507a <printf>
    1422:	bfd1                	j	13f6 <exectest+0xbe>
  fd = open("echo-ok", O_RDONLY);
    1424:	4581                	li	a1,0
    1426:	00004517          	auipc	a0,0x4
    142a:	76250513          	addi	a0,a0,1890 # 5b88 <malloc+0xa54>
    142e:	067030ef          	jal	ra,4c94 <open>
  if(fd < 0) {
    1432:	02054463          	bltz	a0,145a <exectest+0x122>
  if (read(fd, buf, 2) != 2) {
    1436:	4609                	li	a2,2
    1438:	fb840593          	addi	a1,s0,-72
    143c:	031030ef          	jal	ra,4c6c <read>
    1440:	4789                	li	a5,2
    1442:	02f50663          	beq	a0,a5,146e <exectest+0x136>
    printf("%s: read failed\n", s);
    1446:	85ca                	mv	a1,s2
    1448:	00004517          	auipc	a0,0x4
    144c:	1f050513          	addi	a0,a0,496 # 5638 <malloc+0x504>
    1450:	42b030ef          	jal	ra,507a <printf>
    exit(1);
    1454:	4505                	li	a0,1
    1456:	7fe030ef          	jal	ra,4c54 <exit>
    printf("%s: open failed\n", s);
    145a:	85ca                	mv	a1,s2
    145c:	00004517          	auipc	a0,0x4
    1460:	6b450513          	addi	a0,a0,1716 # 5b10 <malloc+0x9dc>
    1464:	417030ef          	jal	ra,507a <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	7ea030ef          	jal	ra,4c54 <exit>
  unlink("echo-ok");
    146e:	00004517          	auipc	a0,0x4
    1472:	71a50513          	addi	a0,a0,1818 # 5b88 <malloc+0xa54>
    1476:	02f030ef          	jal	ra,4ca4 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    147a:	fb844703          	lbu	a4,-72(s0)
    147e:	04f00793          	li	a5,79
    1482:	00f71863          	bne	a4,a5,1492 <exectest+0x15a>
    1486:	fb944703          	lbu	a4,-71(s0)
    148a:	04b00793          	li	a5,75
    148e:	00f70c63          	beq	a4,a5,14a6 <exectest+0x16e>
    printf("%s: wrong output\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00004517          	auipc	a0,0x4
    1498:	75450513          	addi	a0,a0,1876 # 5be8 <malloc+0xab4>
    149c:	3df030ef          	jal	ra,507a <printf>
    exit(1);
    14a0:	4505                	li	a0,1
    14a2:	7b2030ef          	jal	ra,4c54 <exit>
    exit(0);
    14a6:	4501                	li	a0,0
    14a8:	7ac030ef          	jal	ra,4c54 <exit>

00000000000014ac <pipe1>:
{
    14ac:	711d                	addi	sp,sp,-96
    14ae:	ec86                	sd	ra,88(sp)
    14b0:	e8a2                	sd	s0,80(sp)
    14b2:	e4a6                	sd	s1,72(sp)
    14b4:	e0ca                	sd	s2,64(sp)
    14b6:	fc4e                	sd	s3,56(sp)
    14b8:	f852                	sd	s4,48(sp)
    14ba:	f456                	sd	s5,40(sp)
    14bc:	f05a                	sd	s6,32(sp)
    14be:	ec5e                	sd	s7,24(sp)
    14c0:	1080                	addi	s0,sp,96
    14c2:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    14c4:	fa840513          	addi	a0,s0,-88
    14c8:	79c030ef          	jal	ra,4c64 <pipe>
    14cc:	e535                	bnez	a0,1538 <pipe1+0x8c>
    14ce:	84aa                	mv	s1,a0
  pid = fork();
    14d0:	77c030ef          	jal	ra,4c4c <fork>
    14d4:	8a2a                	mv	s4,a0
  if(pid == 0){
    14d6:	c93d                	beqz	a0,154c <pipe1+0xa0>
  } else if(pid > 0){
    14d8:	14a05163          	blez	a0,161a <pipe1+0x16e>
    close(fds[1]);
    14dc:	fac42503          	lw	a0,-84(s0)
    14e0:	79c030ef          	jal	ra,4c7c <close>
    total = 0;
    14e4:	8a26                	mv	s4,s1
    cc = 1;
    14e6:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    14e8:	0000aa97          	auipc	s5,0xa
    14ec:	7c0a8a93          	addi	s5,s5,1984 # bca8 <buf>
      if(cc > sizeof(buf))
    14f0:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    14f2:	864e                	mv	a2,s3
    14f4:	85d6                	mv	a1,s5
    14f6:	fa842503          	lw	a0,-88(s0)
    14fa:	772030ef          	jal	ra,4c6c <read>
    14fe:	0ea05263          	blez	a0,15e2 <pipe1+0x136>
      for(i = 0; i < n; i++){
    1502:	0000a717          	auipc	a4,0xa
    1506:	7a670713          	addi	a4,a4,1958 # bca8 <buf>
    150a:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    150e:	00074683          	lbu	a3,0(a4)
    1512:	0ff4f793          	andi	a5,s1,255
    1516:	2485                	addiw	s1,s1,1
    1518:	0af69363          	bne	a3,a5,15be <pipe1+0x112>
      for(i = 0; i < n; i++){
    151c:	0705                	addi	a4,a4,1
    151e:	fec498e3          	bne	s1,a2,150e <pipe1+0x62>
      total += n;
    1522:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1526:	0019979b          	slliw	a5,s3,0x1
    152a:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    152e:	013b7363          	bgeu	s6,s3,1534 <pipe1+0x88>
        cc = sizeof(buf);
    1532:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1534:	84b2                	mv	s1,a2
    1536:	bf75                	j	14f2 <pipe1+0x46>
    printf("%s: pipe() failed\n", s);
    1538:	85ca                	mv	a1,s2
    153a:	00004517          	auipc	a0,0x4
    153e:	6c650513          	addi	a0,a0,1734 # 5c00 <malloc+0xacc>
    1542:	339030ef          	jal	ra,507a <printf>
    exit(1);
    1546:	4505                	li	a0,1
    1548:	70c030ef          	jal	ra,4c54 <exit>
    close(fds[0]);
    154c:	fa842503          	lw	a0,-88(s0)
    1550:	72c030ef          	jal	ra,4c7c <close>
    for(n = 0; n < N; n++){
    1554:	0000ab17          	auipc	s6,0xa
    1558:	754b0b13          	addi	s6,s6,1876 # bca8 <buf>
    155c:	416004bb          	negw	s1,s6
    1560:	0ff4f493          	andi	s1,s1,255
    1564:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1568:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    156a:	6a85                	lui	s5,0x1
    156c:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xf5>
{
    1570:	87da                	mv	a5,s6
        buf[i] = seq++;
    1572:	0097873b          	addw	a4,a5,s1
    1576:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    157a:	0785                	addi	a5,a5,1
    157c:	fef99be3          	bne	s3,a5,1572 <pipe1+0xc6>
    1580:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1584:	40900613          	li	a2,1033
    1588:	85de                	mv	a1,s7
    158a:	fac42503          	lw	a0,-84(s0)
    158e:	6e6030ef          	jal	ra,4c74 <write>
    1592:	40900793          	li	a5,1033
    1596:	00f51a63          	bne	a0,a5,15aa <pipe1+0xfe>
    for(n = 0; n < N; n++){
    159a:	24a5                	addiw	s1,s1,9
    159c:	0ff4f493          	andi	s1,s1,255
    15a0:	fd5a18e3          	bne	s4,s5,1570 <pipe1+0xc4>
    exit(0);
    15a4:	4501                	li	a0,0
    15a6:	6ae030ef          	jal	ra,4c54 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15aa:	85ca                	mv	a1,s2
    15ac:	00004517          	auipc	a0,0x4
    15b0:	66c50513          	addi	a0,a0,1644 # 5c18 <malloc+0xae4>
    15b4:	2c7030ef          	jal	ra,507a <printf>
        exit(1);
    15b8:	4505                	li	a0,1
    15ba:	69a030ef          	jal	ra,4c54 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15be:	85ca                	mv	a1,s2
    15c0:	00004517          	auipc	a0,0x4
    15c4:	67050513          	addi	a0,a0,1648 # 5c30 <malloc+0xafc>
    15c8:	2b3030ef          	jal	ra,507a <printf>
}
    15cc:	60e6                	ld	ra,88(sp)
    15ce:	6446                	ld	s0,80(sp)
    15d0:	64a6                	ld	s1,72(sp)
    15d2:	6906                	ld	s2,64(sp)
    15d4:	79e2                	ld	s3,56(sp)
    15d6:	7a42                	ld	s4,48(sp)
    15d8:	7aa2                	ld	s5,40(sp)
    15da:	7b02                	ld	s6,32(sp)
    15dc:	6be2                	ld	s7,24(sp)
    15de:	6125                	addi	sp,sp,96
    15e0:	8082                	ret
    if(total != N * SZ){
    15e2:	6785                	lui	a5,0x1
    15e4:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xf5>
    15e8:	00fa0d63          	beq	s4,a5,1602 <pipe1+0x156>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    15ec:	8652                	mv	a2,s4
    15ee:	85ca                	mv	a1,s2
    15f0:	00004517          	auipc	a0,0x4
    15f4:	65850513          	addi	a0,a0,1624 # 5c48 <malloc+0xb14>
    15f8:	283030ef          	jal	ra,507a <printf>
      exit(1);
    15fc:	4505                	li	a0,1
    15fe:	656030ef          	jal	ra,4c54 <exit>
    close(fds[0]);
    1602:	fa842503          	lw	a0,-88(s0)
    1606:	676030ef          	jal	ra,4c7c <close>
    wait(&xstatus);
    160a:	fa440513          	addi	a0,s0,-92
    160e:	64e030ef          	jal	ra,4c5c <wait>
    exit(xstatus);
    1612:	fa442503          	lw	a0,-92(s0)
    1616:	63e030ef          	jal	ra,4c54 <exit>
    printf("%s: fork() failed\n", s);
    161a:	85ca                	mv	a1,s2
    161c:	00004517          	auipc	a0,0x4
    1620:	64c50513          	addi	a0,a0,1612 # 5c68 <malloc+0xb34>
    1624:	257030ef          	jal	ra,507a <printf>
    exit(1);
    1628:	4505                	li	a0,1
    162a:	62a030ef          	jal	ra,4c54 <exit>

000000000000162e <exitwait>:
{
    162e:	7139                	addi	sp,sp,-64
    1630:	fc06                	sd	ra,56(sp)
    1632:	f822                	sd	s0,48(sp)
    1634:	f426                	sd	s1,40(sp)
    1636:	f04a                	sd	s2,32(sp)
    1638:	ec4e                	sd	s3,24(sp)
    163a:	e852                	sd	s4,16(sp)
    163c:	0080                	addi	s0,sp,64
    163e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1640:	4901                	li	s2,0
    1642:	06400993          	li	s3,100
    pid = fork();
    1646:	606030ef          	jal	ra,4c4c <fork>
    164a:	84aa                	mv	s1,a0
    if(pid < 0){
    164c:	02054863          	bltz	a0,167c <exitwait+0x4e>
    if(pid){
    1650:	c525                	beqz	a0,16b8 <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1652:	fcc40513          	addi	a0,s0,-52
    1656:	606030ef          	jal	ra,4c5c <wait>
    165a:	02951b63          	bne	a0,s1,1690 <exitwait+0x62>
      if(i != xstate) {
    165e:	fcc42783          	lw	a5,-52(s0)
    1662:	05279163          	bne	a5,s2,16a4 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    1666:	2905                	addiw	s2,s2,1
    1668:	fd391fe3          	bne	s2,s3,1646 <exitwait+0x18>
}
    166c:	70e2                	ld	ra,56(sp)
    166e:	7442                	ld	s0,48(sp)
    1670:	74a2                	ld	s1,40(sp)
    1672:	7902                	ld	s2,32(sp)
    1674:	69e2                	ld	s3,24(sp)
    1676:	6a42                	ld	s4,16(sp)
    1678:	6121                	addi	sp,sp,64
    167a:	8082                	ret
      printf("%s: fork failed\n", s);
    167c:	85d2                	mv	a1,s4
    167e:	00004517          	auipc	a0,0x4
    1682:	47a50513          	addi	a0,a0,1146 # 5af8 <malloc+0x9c4>
    1686:	1f5030ef          	jal	ra,507a <printf>
      exit(1);
    168a:	4505                	li	a0,1
    168c:	5c8030ef          	jal	ra,4c54 <exit>
        printf("%s: wait wrong pid\n", s);
    1690:	85d2                	mv	a1,s4
    1692:	00004517          	auipc	a0,0x4
    1696:	5ee50513          	addi	a0,a0,1518 # 5c80 <malloc+0xb4c>
    169a:	1e1030ef          	jal	ra,507a <printf>
        exit(1);
    169e:	4505                	li	a0,1
    16a0:	5b4030ef          	jal	ra,4c54 <exit>
        printf("%s: wait wrong exit status\n", s);
    16a4:	85d2                	mv	a1,s4
    16a6:	00004517          	auipc	a0,0x4
    16aa:	5f250513          	addi	a0,a0,1522 # 5c98 <malloc+0xb64>
    16ae:	1cd030ef          	jal	ra,507a <printf>
        exit(1);
    16b2:	4505                	li	a0,1
    16b4:	5a0030ef          	jal	ra,4c54 <exit>
      exit(i);
    16b8:	854a                	mv	a0,s2
    16ba:	59a030ef          	jal	ra,4c54 <exit>

00000000000016be <twochildren>:
{
    16be:	1101                	addi	sp,sp,-32
    16c0:	ec06                	sd	ra,24(sp)
    16c2:	e822                	sd	s0,16(sp)
    16c4:	e426                	sd	s1,8(sp)
    16c6:	e04a                	sd	s2,0(sp)
    16c8:	1000                	addi	s0,sp,32
    16ca:	892a                	mv	s2,a0
    16cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    16d0:	57c030ef          	jal	ra,4c4c <fork>
    if(pid1 < 0){
    16d4:	02054663          	bltz	a0,1700 <twochildren+0x42>
    if(pid1 == 0){
    16d8:	cd15                	beqz	a0,1714 <twochildren+0x56>
      int pid2 = fork();
    16da:	572030ef          	jal	ra,4c4c <fork>
      if(pid2 < 0){
    16de:	02054d63          	bltz	a0,1718 <twochildren+0x5a>
      if(pid2 == 0){
    16e2:	c529                	beqz	a0,172c <twochildren+0x6e>
        wait(0);
    16e4:	4501                	li	a0,0
    16e6:	576030ef          	jal	ra,4c5c <wait>
        wait(0);
    16ea:	4501                	li	a0,0
    16ec:	570030ef          	jal	ra,4c5c <wait>
  for(int i = 0; i < 1000; i++){
    16f0:	34fd                	addiw	s1,s1,-1
    16f2:	fcf9                	bnez	s1,16d0 <twochildren+0x12>
}
    16f4:	60e2                	ld	ra,24(sp)
    16f6:	6442                	ld	s0,16(sp)
    16f8:	64a2                	ld	s1,8(sp)
    16fa:	6902                	ld	s2,0(sp)
    16fc:	6105                	addi	sp,sp,32
    16fe:	8082                	ret
      printf("%s: fork failed\n", s);
    1700:	85ca                	mv	a1,s2
    1702:	00004517          	auipc	a0,0x4
    1706:	3f650513          	addi	a0,a0,1014 # 5af8 <malloc+0x9c4>
    170a:	171030ef          	jal	ra,507a <printf>
      exit(1);
    170e:	4505                	li	a0,1
    1710:	544030ef          	jal	ra,4c54 <exit>
      exit(0);
    1714:	540030ef          	jal	ra,4c54 <exit>
        printf("%s: fork failed\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00004517          	auipc	a0,0x4
    171e:	3de50513          	addi	a0,a0,990 # 5af8 <malloc+0x9c4>
    1722:	159030ef          	jal	ra,507a <printf>
        exit(1);
    1726:	4505                	li	a0,1
    1728:	52c030ef          	jal	ra,4c54 <exit>
        exit(0);
    172c:	528030ef          	jal	ra,4c54 <exit>

0000000000001730 <forkfork>:
{
    1730:	7179                	addi	sp,sp,-48
    1732:	f406                	sd	ra,40(sp)
    1734:	f022                	sd	s0,32(sp)
    1736:	ec26                	sd	s1,24(sp)
    1738:	1800                	addi	s0,sp,48
    173a:	84aa                	mv	s1,a0
    int pid = fork();
    173c:	510030ef          	jal	ra,4c4c <fork>
    if(pid < 0){
    1740:	02054b63          	bltz	a0,1776 <forkfork+0x46>
    if(pid == 0){
    1744:	c139                	beqz	a0,178a <forkfork+0x5a>
    int pid = fork();
    1746:	506030ef          	jal	ra,4c4c <fork>
    if(pid < 0){
    174a:	02054663          	bltz	a0,1776 <forkfork+0x46>
    if(pid == 0){
    174e:	cd15                	beqz	a0,178a <forkfork+0x5a>
    wait(&xstatus);
    1750:	fdc40513          	addi	a0,s0,-36
    1754:	508030ef          	jal	ra,4c5c <wait>
    if(xstatus != 0) {
    1758:	fdc42783          	lw	a5,-36(s0)
    175c:	ebb9                	bnez	a5,17b2 <forkfork+0x82>
    wait(&xstatus);
    175e:	fdc40513          	addi	a0,s0,-36
    1762:	4fa030ef          	jal	ra,4c5c <wait>
    if(xstatus != 0) {
    1766:	fdc42783          	lw	a5,-36(s0)
    176a:	e7a1                	bnez	a5,17b2 <forkfork+0x82>
}
    176c:	70a2                	ld	ra,40(sp)
    176e:	7402                	ld	s0,32(sp)
    1770:	64e2                	ld	s1,24(sp)
    1772:	6145                	addi	sp,sp,48
    1774:	8082                	ret
      printf("%s: fork failed", s);
    1776:	85a6                	mv	a1,s1
    1778:	00004517          	auipc	a0,0x4
    177c:	54050513          	addi	a0,a0,1344 # 5cb8 <malloc+0xb84>
    1780:	0fb030ef          	jal	ra,507a <printf>
      exit(1);
    1784:	4505                	li	a0,1
    1786:	4ce030ef          	jal	ra,4c54 <exit>
{
    178a:	0c800493          	li	s1,200
        int pid1 = fork();
    178e:	4be030ef          	jal	ra,4c4c <fork>
        if(pid1 < 0){
    1792:	00054b63          	bltz	a0,17a8 <forkfork+0x78>
        if(pid1 == 0){
    1796:	cd01                	beqz	a0,17ae <forkfork+0x7e>
        wait(0);
    1798:	4501                	li	a0,0
    179a:	4c2030ef          	jal	ra,4c5c <wait>
      for(int j = 0; j < 200; j++){
    179e:	34fd                	addiw	s1,s1,-1
    17a0:	f4fd                	bnez	s1,178e <forkfork+0x5e>
      exit(0);
    17a2:	4501                	li	a0,0
    17a4:	4b0030ef          	jal	ra,4c54 <exit>
          exit(1);
    17a8:	4505                	li	a0,1
    17aa:	4aa030ef          	jal	ra,4c54 <exit>
          exit(0);
    17ae:	4a6030ef          	jal	ra,4c54 <exit>
      printf("%s: fork in child failed", s);
    17b2:	85a6                	mv	a1,s1
    17b4:	00004517          	auipc	a0,0x4
    17b8:	51450513          	addi	a0,a0,1300 # 5cc8 <malloc+0xb94>
    17bc:	0bf030ef          	jal	ra,507a <printf>
      exit(1);
    17c0:	4505                	li	a0,1
    17c2:	492030ef          	jal	ra,4c54 <exit>

00000000000017c6 <reparent2>:
{
    17c6:	1101                	addi	sp,sp,-32
    17c8:	ec06                	sd	ra,24(sp)
    17ca:	e822                	sd	s0,16(sp)
    17cc:	e426                	sd	s1,8(sp)
    17ce:	1000                	addi	s0,sp,32
    17d0:	32000493          	li	s1,800
    int pid1 = fork();
    17d4:	478030ef          	jal	ra,4c4c <fork>
    if(pid1 < 0){
    17d8:	00054b63          	bltz	a0,17ee <reparent2+0x28>
    if(pid1 == 0){
    17dc:	c115                	beqz	a0,1800 <reparent2+0x3a>
    wait(0);
    17de:	4501                	li	a0,0
    17e0:	47c030ef          	jal	ra,4c5c <wait>
  for(int i = 0; i < 800; i++){
    17e4:	34fd                	addiw	s1,s1,-1
    17e6:	f4fd                	bnez	s1,17d4 <reparent2+0xe>
  exit(0);
    17e8:	4501                	li	a0,0
    17ea:	46a030ef          	jal	ra,4c54 <exit>
      printf("fork failed\n");
    17ee:	00006517          	auipc	a0,0x6
    17f2:	89250513          	addi	a0,a0,-1902 # 7080 <malloc+0x1f4c>
    17f6:	085030ef          	jal	ra,507a <printf>
      exit(1);
    17fa:	4505                	li	a0,1
    17fc:	458030ef          	jal	ra,4c54 <exit>
      fork();
    1800:	44c030ef          	jal	ra,4c4c <fork>
      fork();
    1804:	448030ef          	jal	ra,4c4c <fork>
      exit(0);
    1808:	4501                	li	a0,0
    180a:	44a030ef          	jal	ra,4c54 <exit>

000000000000180e <createdelete>:
{
    180e:	7175                	addi	sp,sp,-144
    1810:	e506                	sd	ra,136(sp)
    1812:	e122                	sd	s0,128(sp)
    1814:	fca6                	sd	s1,120(sp)
    1816:	f8ca                	sd	s2,112(sp)
    1818:	f4ce                	sd	s3,104(sp)
    181a:	f0d2                	sd	s4,96(sp)
    181c:	ecd6                	sd	s5,88(sp)
    181e:	e8da                	sd	s6,80(sp)
    1820:	e4de                	sd	s7,72(sp)
    1822:	e0e2                	sd	s8,64(sp)
    1824:	fc66                	sd	s9,56(sp)
    1826:	0900                	addi	s0,sp,144
    1828:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    182a:	4901                	li	s2,0
    182c:	4991                	li	s3,4
    pid = fork();
    182e:	41e030ef          	jal	ra,4c4c <fork>
    1832:	84aa                	mv	s1,a0
    if(pid < 0){
    1834:	02054d63          	bltz	a0,186e <createdelete+0x60>
    if(pid == 0){
    1838:	c529                	beqz	a0,1882 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    183a:	2905                	addiw	s2,s2,1
    183c:	ff3919e3          	bne	s2,s3,182e <createdelete+0x20>
    1840:	4491                	li	s1,4
    wait(&xstatus);
    1842:	f7c40513          	addi	a0,s0,-132
    1846:	416030ef          	jal	ra,4c5c <wait>
    if(xstatus != 0)
    184a:	f7c42903          	lw	s2,-132(s0)
    184e:	0a091e63          	bnez	s2,190a <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1852:	34fd                	addiw	s1,s1,-1
    1854:	f4fd                	bnez	s1,1842 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    1856:	f8040123          	sb	zero,-126(s0)
    185a:	03000993          	li	s3,48
    185e:	5a7d                	li	s4,-1
    1860:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1864:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1866:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1868:	07400a93          	li	s5,116
    186c:	a20d                	j	198e <createdelete+0x180>
      printf("%s: fork failed\n", s);
    186e:	85e6                	mv	a1,s9
    1870:	00004517          	auipc	a0,0x4
    1874:	28850513          	addi	a0,a0,648 # 5af8 <malloc+0x9c4>
    1878:	003030ef          	jal	ra,507a <printf>
      exit(1);
    187c:	4505                	li	a0,1
    187e:	3d6030ef          	jal	ra,4c54 <exit>
      name[0] = 'p' + pi;
    1882:	0709091b          	addiw	s2,s2,112
    1886:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    188a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    188e:	4951                	li	s2,20
    1890:	a831                	j	18ac <createdelete+0x9e>
          printf("%s: create failed\n", s);
    1892:	85e6                	mv	a1,s9
    1894:	00004517          	auipc	a0,0x4
    1898:	2fc50513          	addi	a0,a0,764 # 5b90 <malloc+0xa5c>
    189c:	7de030ef          	jal	ra,507a <printf>
          exit(1);
    18a0:	4505                	li	a0,1
    18a2:	3b2030ef          	jal	ra,4c54 <exit>
      for(i = 0; i < N; i++){
    18a6:	2485                	addiw	s1,s1,1
    18a8:	05248e63          	beq	s1,s2,1904 <createdelete+0xf6>
        name[1] = '0' + i;
    18ac:	0304879b          	addiw	a5,s1,48
    18b0:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18b4:	20200593          	li	a1,514
    18b8:	f8040513          	addi	a0,s0,-128
    18bc:	3d8030ef          	jal	ra,4c94 <open>
        if(fd < 0){
    18c0:	fc0549e3          	bltz	a0,1892 <createdelete+0x84>
        close(fd);
    18c4:	3b8030ef          	jal	ra,4c7c <close>
        if(i > 0 && (i % 2 ) == 0){
    18c8:	fc905fe3          	blez	s1,18a6 <createdelete+0x98>
    18cc:	0014f793          	andi	a5,s1,1
    18d0:	fbf9                	bnez	a5,18a6 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18d2:	01f4d79b          	srliw	a5,s1,0x1f
    18d6:	9fa5                	addw	a5,a5,s1
    18d8:	4017d79b          	sraiw	a5,a5,0x1
    18dc:	0307879b          	addiw	a5,a5,48
    18e0:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    18e4:	f8040513          	addi	a0,s0,-128
    18e8:	3bc030ef          	jal	ra,4ca4 <unlink>
    18ec:	fa055de3          	bgez	a0,18a6 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    18f0:	85e6                	mv	a1,s9
    18f2:	00004517          	auipc	a0,0x4
    18f6:	3f650513          	addi	a0,a0,1014 # 5ce8 <malloc+0xbb4>
    18fa:	780030ef          	jal	ra,507a <printf>
            exit(1);
    18fe:	4505                	li	a0,1
    1900:	354030ef          	jal	ra,4c54 <exit>
      exit(0);
    1904:	4501                	li	a0,0
    1906:	34e030ef          	jal	ra,4c54 <exit>
      exit(1);
    190a:	4505                	li	a0,1
    190c:	348030ef          	jal	ra,4c54 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1910:	f8040613          	addi	a2,s0,-128
    1914:	85e6                	mv	a1,s9
    1916:	00004517          	auipc	a0,0x4
    191a:	3ea50513          	addi	a0,a0,1002 # 5d00 <malloc+0xbcc>
    191e:	75c030ef          	jal	ra,507a <printf>
        exit(1);
    1922:	4505                	li	a0,1
    1924:	330030ef          	jal	ra,4c54 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1928:	034b7d63          	bgeu	s6,s4,1962 <createdelete+0x154>
      if(fd >= 0)
    192c:	02055863          	bgez	a0,195c <createdelete+0x14e>
    for(pi = 0; pi < NCHILD; pi++){
    1930:	2485                	addiw	s1,s1,1
    1932:	0ff4f493          	andi	s1,s1,255
    1936:	05548463          	beq	s1,s5,197e <createdelete+0x170>
      name[0] = 'p' + pi;
    193a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    193e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1942:	4581                	li	a1,0
    1944:	f8040513          	addi	a0,s0,-128
    1948:	34c030ef          	jal	ra,4c94 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    194c:	00090463          	beqz	s2,1954 <createdelete+0x146>
    1950:	fd2bdce3          	bge	s7,s2,1928 <createdelete+0x11a>
    1954:	fa054ee3          	bltz	a0,1910 <createdelete+0x102>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1958:	014b7763          	bgeu	s6,s4,1966 <createdelete+0x158>
        close(fd);
    195c:	320030ef          	jal	ra,4c7c <close>
    1960:	bfc1                	j	1930 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1962:	fc0547e3          	bltz	a0,1930 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1966:	f8040613          	addi	a2,s0,-128
    196a:	85e6                	mv	a1,s9
    196c:	00004517          	auipc	a0,0x4
    1970:	3bc50513          	addi	a0,a0,956 # 5d28 <malloc+0xbf4>
    1974:	706030ef          	jal	ra,507a <printf>
        exit(1);
    1978:	4505                	li	a0,1
    197a:	2da030ef          	jal	ra,4c54 <exit>
  for(i = 0; i < N; i++){
    197e:	2905                	addiw	s2,s2,1
    1980:	2a05                	addiw	s4,s4,1
    1982:	2985                	addiw	s3,s3,1
    1984:	0ff9f993          	andi	s3,s3,255
    1988:	47d1                	li	a5,20
    198a:	02f90863          	beq	s2,a5,19ba <createdelete+0x1ac>
    for(pi = 0; pi < NCHILD; pi++){
    198e:	84e2                	mv	s1,s8
    1990:	b76d                	j	193a <createdelete+0x12c>
  for(i = 0; i < N; i++){
    1992:	2905                	addiw	s2,s2,1
    1994:	0ff97913          	andi	s2,s2,255
    1998:	03490a63          	beq	s2,s4,19cc <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    199c:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    199e:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19a2:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19a6:	f8040513          	addi	a0,s0,-128
    19aa:	2fa030ef          	jal	ra,4ca4 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19ae:	2485                	addiw	s1,s1,1
    19b0:	0ff4f493          	andi	s1,s1,255
    19b4:	ff3495e3          	bne	s1,s3,199e <createdelete+0x190>
    19b8:	bfe9                	j	1992 <createdelete+0x184>
    19ba:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19be:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19c2:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19c6:	04400a13          	li	s4,68
    19ca:	bfc9                	j	199c <createdelete+0x18e>
}
    19cc:	60aa                	ld	ra,136(sp)
    19ce:	640a                	ld	s0,128(sp)
    19d0:	74e6                	ld	s1,120(sp)
    19d2:	7946                	ld	s2,112(sp)
    19d4:	79a6                	ld	s3,104(sp)
    19d6:	7a06                	ld	s4,96(sp)
    19d8:	6ae6                	ld	s5,88(sp)
    19da:	6b46                	ld	s6,80(sp)
    19dc:	6ba6                	ld	s7,72(sp)
    19de:	6c06                	ld	s8,64(sp)
    19e0:	7ce2                	ld	s9,56(sp)
    19e2:	6149                	addi	sp,sp,144
    19e4:	8082                	ret

00000000000019e6 <linkunlink>:
{
    19e6:	711d                	addi	sp,sp,-96
    19e8:	ec86                	sd	ra,88(sp)
    19ea:	e8a2                	sd	s0,80(sp)
    19ec:	e4a6                	sd	s1,72(sp)
    19ee:	e0ca                	sd	s2,64(sp)
    19f0:	fc4e                	sd	s3,56(sp)
    19f2:	f852                	sd	s4,48(sp)
    19f4:	f456                	sd	s5,40(sp)
    19f6:	f05a                	sd	s6,32(sp)
    19f8:	ec5e                	sd	s7,24(sp)
    19fa:	e862                	sd	s8,16(sp)
    19fc:	e466                	sd	s9,8(sp)
    19fe:	1080                	addi	s0,sp,96
    1a00:	84aa                	mv	s1,a0
  unlink("x");
    1a02:	00004517          	auipc	a0,0x4
    1a06:	8d650513          	addi	a0,a0,-1834 # 52d8 <malloc+0x1a4>
    1a0a:	29a030ef          	jal	ra,4ca4 <unlink>
  pid = fork();
    1a0e:	23e030ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    1a12:	02054b63          	bltz	a0,1a48 <linkunlink+0x62>
    1a16:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1a18:	4c85                	li	s9,1
    1a1a:	e119                	bnez	a0,1a20 <linkunlink+0x3a>
    1a1c:	06100c93          	li	s9,97
    1a20:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a24:	41c659b7          	lui	s3,0x41c65
    1a28:	e6d9899b          	addiw	s3,s3,-403
    1a2c:	690d                	lui	s2,0x3
    1a2e:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1a32:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1a34:	4b05                	li	s6,1
      unlink("x");
    1a36:	00004a97          	auipc	s5,0x4
    1a3a:	8a2a8a93          	addi	s5,s5,-1886 # 52d8 <malloc+0x1a4>
      link("cat", "x");
    1a3e:	00004b97          	auipc	s7,0x4
    1a42:	312b8b93          	addi	s7,s7,786 # 5d50 <malloc+0xc1c>
    1a46:	a805                	j	1a76 <linkunlink+0x90>
    printf("%s: fork failed\n", s);
    1a48:	85a6                	mv	a1,s1
    1a4a:	00004517          	auipc	a0,0x4
    1a4e:	0ae50513          	addi	a0,a0,174 # 5af8 <malloc+0x9c4>
    1a52:	628030ef          	jal	ra,507a <printf>
    exit(1);
    1a56:	4505                	li	a0,1
    1a58:	1fc030ef          	jal	ra,4c54 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a5c:	20200593          	li	a1,514
    1a60:	8556                	mv	a0,s5
    1a62:	232030ef          	jal	ra,4c94 <open>
    1a66:	216030ef          	jal	ra,4c7c <close>
    1a6a:	a021                	j	1a72 <linkunlink+0x8c>
      unlink("x");
    1a6c:	8556                	mv	a0,s5
    1a6e:	236030ef          	jal	ra,4ca4 <unlink>
  for(i = 0; i < 100; i++){
    1a72:	34fd                	addiw	s1,s1,-1
    1a74:	c08d                	beqz	s1,1a96 <linkunlink+0xb0>
    x = x * 1103515245 + 12345;
    1a76:	033c87bb          	mulw	a5,s9,s3
    1a7a:	012787bb          	addw	a5,a5,s2
    1a7e:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1a82:	0347f7bb          	remuw	a5,a5,s4
    1a86:	dbf9                	beqz	a5,1a5c <linkunlink+0x76>
    } else if((x % 3) == 1){
    1a88:	ff6792e3          	bne	a5,s6,1a6c <linkunlink+0x86>
      link("cat", "x");
    1a8c:	85d6                	mv	a1,s5
    1a8e:	855e                	mv	a0,s7
    1a90:	224030ef          	jal	ra,4cb4 <link>
    1a94:	bff9                	j	1a72 <linkunlink+0x8c>
  if(pid)
    1a96:	020c0263          	beqz	s8,1aba <linkunlink+0xd4>
    wait(0);
    1a9a:	4501                	li	a0,0
    1a9c:	1c0030ef          	jal	ra,4c5c <wait>
}
    1aa0:	60e6                	ld	ra,88(sp)
    1aa2:	6446                	ld	s0,80(sp)
    1aa4:	64a6                	ld	s1,72(sp)
    1aa6:	6906                	ld	s2,64(sp)
    1aa8:	79e2                	ld	s3,56(sp)
    1aaa:	7a42                	ld	s4,48(sp)
    1aac:	7aa2                	ld	s5,40(sp)
    1aae:	7b02                	ld	s6,32(sp)
    1ab0:	6be2                	ld	s7,24(sp)
    1ab2:	6c42                	ld	s8,16(sp)
    1ab4:	6ca2                	ld	s9,8(sp)
    1ab6:	6125                	addi	sp,sp,96
    1ab8:	8082                	ret
    exit(0);
    1aba:	4501                	li	a0,0
    1abc:	198030ef          	jal	ra,4c54 <exit>

0000000000001ac0 <forktest>:
{
    1ac0:	7179                	addi	sp,sp,-48
    1ac2:	f406                	sd	ra,40(sp)
    1ac4:	f022                	sd	s0,32(sp)
    1ac6:	ec26                	sd	s1,24(sp)
    1ac8:	e84a                	sd	s2,16(sp)
    1aca:	e44e                	sd	s3,8(sp)
    1acc:	1800                	addi	s0,sp,48
    1ace:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ad0:	4481                	li	s1,0
    1ad2:	3e800913          	li	s2,1000
    pid = fork();
    1ad6:	176030ef          	jal	ra,4c4c <fork>
    if(pid < 0)
    1ada:	02054263          	bltz	a0,1afe <forktest+0x3e>
    if(pid == 0)
    1ade:	cd11                	beqz	a0,1afa <forktest+0x3a>
  for(n=0; n<N; n++){
    1ae0:	2485                	addiw	s1,s1,1
    1ae2:	ff249ae3          	bne	s1,s2,1ad6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ae6:	85ce                	mv	a1,s3
    1ae8:	00004517          	auipc	a0,0x4
    1aec:	28850513          	addi	a0,a0,648 # 5d70 <malloc+0xc3c>
    1af0:	58a030ef          	jal	ra,507a <printf>
    exit(1);
    1af4:	4505                	li	a0,1
    1af6:	15e030ef          	jal	ra,4c54 <exit>
      exit(0);
    1afa:	15a030ef          	jal	ra,4c54 <exit>
  if (n == 0) {
    1afe:	c89d                	beqz	s1,1b34 <forktest+0x74>
  if(n == N){
    1b00:	3e800793          	li	a5,1000
    1b04:	fef481e3          	beq	s1,a5,1ae6 <forktest+0x26>
  for(; n > 0; n--){
    1b08:	00905963          	blez	s1,1b1a <forktest+0x5a>
    if(wait(0) < 0){
    1b0c:	4501                	li	a0,0
    1b0e:	14e030ef          	jal	ra,4c5c <wait>
    1b12:	02054b63          	bltz	a0,1b48 <forktest+0x88>
  for(; n > 0; n--){
    1b16:	34fd                	addiw	s1,s1,-1
    1b18:	f8f5                	bnez	s1,1b0c <forktest+0x4c>
  if(wait(0) != -1){
    1b1a:	4501                	li	a0,0
    1b1c:	140030ef          	jal	ra,4c5c <wait>
    1b20:	57fd                	li	a5,-1
    1b22:	02f51d63          	bne	a0,a5,1b5c <forktest+0x9c>
}
    1b26:	70a2                	ld	ra,40(sp)
    1b28:	7402                	ld	s0,32(sp)
    1b2a:	64e2                	ld	s1,24(sp)
    1b2c:	6942                	ld	s2,16(sp)
    1b2e:	69a2                	ld	s3,8(sp)
    1b30:	6145                	addi	sp,sp,48
    1b32:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1b34:	85ce                	mv	a1,s3
    1b36:	00004517          	auipc	a0,0x4
    1b3a:	22250513          	addi	a0,a0,546 # 5d58 <malloc+0xc24>
    1b3e:	53c030ef          	jal	ra,507a <printf>
    exit(1);
    1b42:	4505                	li	a0,1
    1b44:	110030ef          	jal	ra,4c54 <exit>
      printf("%s: wait stopped early\n", s);
    1b48:	85ce                	mv	a1,s3
    1b4a:	00004517          	auipc	a0,0x4
    1b4e:	24e50513          	addi	a0,a0,590 # 5d98 <malloc+0xc64>
    1b52:	528030ef          	jal	ra,507a <printf>
      exit(1);
    1b56:	4505                	li	a0,1
    1b58:	0fc030ef          	jal	ra,4c54 <exit>
    printf("%s: wait got too many\n", s);
    1b5c:	85ce                	mv	a1,s3
    1b5e:	00004517          	auipc	a0,0x4
    1b62:	25250513          	addi	a0,a0,594 # 5db0 <malloc+0xc7c>
    1b66:	514030ef          	jal	ra,507a <printf>
    exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	0e8030ef          	jal	ra,4c54 <exit>

0000000000001b70 <kernmem>:
{
    1b70:	715d                	addi	sp,sp,-80
    1b72:	e486                	sd	ra,72(sp)
    1b74:	e0a2                	sd	s0,64(sp)
    1b76:	fc26                	sd	s1,56(sp)
    1b78:	f84a                	sd	s2,48(sp)
    1b7a:	f44e                	sd	s3,40(sp)
    1b7c:	f052                	sd	s4,32(sp)
    1b7e:	ec56                	sd	s5,24(sp)
    1b80:	0880                	addi	s0,sp,80
    1b82:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b84:	4485                	li	s1,1
    1b86:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1b88:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b8a:	69b1                	lui	s3,0xc
    1b8c:	35098993          	addi	s3,s3,848 # c350 <buf+0x6a8>
    1b90:	1003d937          	lui	s2,0x1003d
    1b94:	090e                	slli	s2,s2,0x3
    1b96:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7d8>
    pid = fork();
    1b9a:	0b2030ef          	jal	ra,4c4c <fork>
    if(pid < 0){
    1b9e:	02054763          	bltz	a0,1bcc <kernmem+0x5c>
    if(pid == 0){
    1ba2:	cd1d                	beqz	a0,1be0 <kernmem+0x70>
    wait(&xstatus);
    1ba4:	fbc40513          	addi	a0,s0,-68
    1ba8:	0b4030ef          	jal	ra,4c5c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bac:	fbc42783          	lw	a5,-68(s0)
    1bb0:	05579563          	bne	a5,s5,1bfa <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bb4:	94ce                	add	s1,s1,s3
    1bb6:	ff2492e3          	bne	s1,s2,1b9a <kernmem+0x2a>
}
    1bba:	60a6                	ld	ra,72(sp)
    1bbc:	6406                	ld	s0,64(sp)
    1bbe:	74e2                	ld	s1,56(sp)
    1bc0:	7942                	ld	s2,48(sp)
    1bc2:	79a2                	ld	s3,40(sp)
    1bc4:	7a02                	ld	s4,32(sp)
    1bc6:	6ae2                	ld	s5,24(sp)
    1bc8:	6161                	addi	sp,sp,80
    1bca:	8082                	ret
      printf("%s: fork failed\n", s);
    1bcc:	85d2                	mv	a1,s4
    1bce:	00004517          	auipc	a0,0x4
    1bd2:	f2a50513          	addi	a0,a0,-214 # 5af8 <malloc+0x9c4>
    1bd6:	4a4030ef          	jal	ra,507a <printf>
      exit(1);
    1bda:	4505                	li	a0,1
    1bdc:	078030ef          	jal	ra,4c54 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1be0:	0004c683          	lbu	a3,0(s1)
    1be4:	8626                	mv	a2,s1
    1be6:	85d2                	mv	a1,s4
    1be8:	00004517          	auipc	a0,0x4
    1bec:	1e050513          	addi	a0,a0,480 # 5dc8 <malloc+0xc94>
    1bf0:	48a030ef          	jal	ra,507a <printf>
      exit(1);
    1bf4:	4505                	li	a0,1
    1bf6:	05e030ef          	jal	ra,4c54 <exit>
      exit(1);
    1bfa:	4505                	li	a0,1
    1bfc:	058030ef          	jal	ra,4c54 <exit>

0000000000001c00 <MAXVAplus>:
{
    1c00:	7179                	addi	sp,sp,-48
    1c02:	f406                	sd	ra,40(sp)
    1c04:	f022                	sd	s0,32(sp)
    1c06:	ec26                	sd	s1,24(sp)
    1c08:	e84a                	sd	s2,16(sp)
    1c0a:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c0c:	4785                	li	a5,1
    1c0e:	179a                	slli	a5,a5,0x26
    1c10:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c14:	fd843783          	ld	a5,-40(s0)
    1c18:	cb85                	beqz	a5,1c48 <MAXVAplus+0x48>
    1c1a:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c1c:	54fd                	li	s1,-1
    pid = fork();
    1c1e:	02e030ef          	jal	ra,4c4c <fork>
    if(pid < 0){
    1c22:	02054963          	bltz	a0,1c54 <MAXVAplus+0x54>
    if(pid == 0){
    1c26:	c129                	beqz	a0,1c68 <MAXVAplus+0x68>
    wait(&xstatus);
    1c28:	fd440513          	addi	a0,s0,-44
    1c2c:	030030ef          	jal	ra,4c5c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c30:	fd442783          	lw	a5,-44(s0)
    1c34:	04979c63          	bne	a5,s1,1c8c <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c38:	fd843783          	ld	a5,-40(s0)
    1c3c:	0786                	slli	a5,a5,0x1
    1c3e:	fcf43c23          	sd	a5,-40(s0)
    1c42:	fd843783          	ld	a5,-40(s0)
    1c46:	ffe1                	bnez	a5,1c1e <MAXVAplus+0x1e>
}
    1c48:	70a2                	ld	ra,40(sp)
    1c4a:	7402                	ld	s0,32(sp)
    1c4c:	64e2                	ld	s1,24(sp)
    1c4e:	6942                	ld	s2,16(sp)
    1c50:	6145                	addi	sp,sp,48
    1c52:	8082                	ret
      printf("%s: fork failed\n", s);
    1c54:	85ca                	mv	a1,s2
    1c56:	00004517          	auipc	a0,0x4
    1c5a:	ea250513          	addi	a0,a0,-350 # 5af8 <malloc+0x9c4>
    1c5e:	41c030ef          	jal	ra,507a <printf>
      exit(1);
    1c62:	4505                	li	a0,1
    1c64:	7f1020ef          	jal	ra,4c54 <exit>
      *(char*)a = 99;
    1c68:	fd843783          	ld	a5,-40(s0)
    1c6c:	06300713          	li	a4,99
    1c70:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c74:	fd843603          	ld	a2,-40(s0)
    1c78:	85ca                	mv	a1,s2
    1c7a:	00004517          	auipc	a0,0x4
    1c7e:	16e50513          	addi	a0,a0,366 # 5de8 <malloc+0xcb4>
    1c82:	3f8030ef          	jal	ra,507a <printf>
      exit(1);
    1c86:	4505                	li	a0,1
    1c88:	7cd020ef          	jal	ra,4c54 <exit>
      exit(1);
    1c8c:	4505                	li	a0,1
    1c8e:	7c7020ef          	jal	ra,4c54 <exit>

0000000000001c92 <stacktest>:
{
    1c92:	7179                	addi	sp,sp,-48
    1c94:	f406                	sd	ra,40(sp)
    1c96:	f022                	sd	s0,32(sp)
    1c98:	ec26                	sd	s1,24(sp)
    1c9a:	1800                	addi	s0,sp,48
    1c9c:	84aa                	mv	s1,a0
  pid = fork();
    1c9e:	7af020ef          	jal	ra,4c4c <fork>
  if(pid == 0) {
    1ca2:	cd11                	beqz	a0,1cbe <stacktest+0x2c>
  } else if(pid < 0){
    1ca4:	02054c63          	bltz	a0,1cdc <stacktest+0x4a>
  wait(&xstatus);
    1ca8:	fdc40513          	addi	a0,s0,-36
    1cac:	7b1020ef          	jal	ra,4c5c <wait>
  if(xstatus == -1)  // kernel killed child?
    1cb0:	fdc42503          	lw	a0,-36(s0)
    1cb4:	57fd                	li	a5,-1
    1cb6:	02f50d63          	beq	a0,a5,1cf0 <stacktest+0x5e>
    exit(xstatus);
    1cba:	79b020ef          	jal	ra,4c54 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cbe:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cc0:	77fd                	lui	a5,0xfffff
    1cc2:	97ba                	add	a5,a5,a4
    1cc4:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0358>
    1cc8:	85a6                	mv	a1,s1
    1cca:	00004517          	auipc	a0,0x4
    1cce:	13650513          	addi	a0,a0,310 # 5e00 <malloc+0xccc>
    1cd2:	3a8030ef          	jal	ra,507a <printf>
    exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	77d020ef          	jal	ra,4c54 <exit>
    printf("%s: fork failed\n", s);
    1cdc:	85a6                	mv	a1,s1
    1cde:	00004517          	auipc	a0,0x4
    1ce2:	e1a50513          	addi	a0,a0,-486 # 5af8 <malloc+0x9c4>
    1ce6:	394030ef          	jal	ra,507a <printf>
    exit(1);
    1cea:	4505                	li	a0,1
    1cec:	769020ef          	jal	ra,4c54 <exit>
    exit(0);
    1cf0:	4501                	li	a0,0
    1cf2:	763020ef          	jal	ra,4c54 <exit>

0000000000001cf6 <nowrite>:
{
    1cf6:	7159                	addi	sp,sp,-112
    1cf8:	f486                	sd	ra,104(sp)
    1cfa:	f0a2                	sd	s0,96(sp)
    1cfc:	eca6                	sd	s1,88(sp)
    1cfe:	e8ca                	sd	s2,80(sp)
    1d00:	e4ce                	sd	s3,72(sp)
    1d02:	1880                	addi	s0,sp,112
    1d04:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d06:	00006797          	auipc	a5,0x6
    1d0a:	98a78793          	addi	a5,a5,-1654 # 7690 <malloc+0x255c>
    1d0e:	7788                	ld	a0,40(a5)
    1d10:	7b8c                	ld	a1,48(a5)
    1d12:	7f90                	ld	a2,56(a5)
    1d14:	63b4                	ld	a3,64(a5)
    1d16:	67b8                	ld	a4,72(a5)
    1d18:	6bbc                	ld	a5,80(a5)
    1d1a:	f8a43c23          	sd	a0,-104(s0)
    1d1e:	fab43023          	sd	a1,-96(s0)
    1d22:	fac43423          	sd	a2,-88(s0)
    1d26:	fad43823          	sd	a3,-80(s0)
    1d2a:	fae43c23          	sd	a4,-72(s0)
    1d2e:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d32:	4481                	li	s1,0
    1d34:	4919                	li	s2,6
    pid = fork();
    1d36:	717020ef          	jal	ra,4c4c <fork>
    if(pid == 0) {
    1d3a:	c105                	beqz	a0,1d5a <nowrite+0x64>
    } else if(pid < 0){
    1d3c:	04054163          	bltz	a0,1d7e <nowrite+0x88>
    wait(&xstatus);
    1d40:	fcc40513          	addi	a0,s0,-52
    1d44:	719020ef          	jal	ra,4c5c <wait>
    if(xstatus == 0){
    1d48:	fcc42783          	lw	a5,-52(s0)
    1d4c:	c3b9                	beqz	a5,1d92 <nowrite+0x9c>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d4e:	2485                	addiw	s1,s1,1
    1d50:	ff2493e3          	bne	s1,s2,1d36 <nowrite+0x40>
  exit(0);
    1d54:	4501                	li	a0,0
    1d56:	6ff020ef          	jal	ra,4c54 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d5a:	048e                	slli	s1,s1,0x3
    1d5c:	fd040793          	addi	a5,s0,-48
    1d60:	94be                	add	s1,s1,a5
    1d62:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d66:	47a9                	li	a5,10
    1d68:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d6a:	85ce                	mv	a1,s3
    1d6c:	00004517          	auipc	a0,0x4
    1d70:	0bc50513          	addi	a0,a0,188 # 5e28 <malloc+0xcf4>
    1d74:	306030ef          	jal	ra,507a <printf>
      exit(0);
    1d78:	4501                	li	a0,0
    1d7a:	6db020ef          	jal	ra,4c54 <exit>
      printf("%s: fork failed\n", s);
    1d7e:	85ce                	mv	a1,s3
    1d80:	00004517          	auipc	a0,0x4
    1d84:	d7850513          	addi	a0,a0,-648 # 5af8 <malloc+0x9c4>
    1d88:	2f2030ef          	jal	ra,507a <printf>
      exit(1);
    1d8c:	4505                	li	a0,1
    1d8e:	6c7020ef          	jal	ra,4c54 <exit>
      exit(1);
    1d92:	4505                	li	a0,1
    1d94:	6c1020ef          	jal	ra,4c54 <exit>

0000000000001d98 <manywrites>:
{
    1d98:	711d                	addi	sp,sp,-96
    1d9a:	ec86                	sd	ra,88(sp)
    1d9c:	e8a2                	sd	s0,80(sp)
    1d9e:	e4a6                	sd	s1,72(sp)
    1da0:	e0ca                	sd	s2,64(sp)
    1da2:	fc4e                	sd	s3,56(sp)
    1da4:	f852                	sd	s4,48(sp)
    1da6:	f456                	sd	s5,40(sp)
    1da8:	f05a                	sd	s6,32(sp)
    1daa:	ec5e                	sd	s7,24(sp)
    1dac:	1080                	addi	s0,sp,96
    1dae:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1db0:	4901                	li	s2,0
    1db2:	4991                	li	s3,4
    int pid = fork();
    1db4:	699020ef          	jal	ra,4c4c <fork>
    1db8:	84aa                	mv	s1,a0
    if(pid < 0){
    1dba:	02054563          	bltz	a0,1de4 <manywrites+0x4c>
    if(pid == 0){
    1dbe:	cd05                	beqz	a0,1df6 <manywrites+0x5e>
  for(int ci = 0; ci < nchildren; ci++){
    1dc0:	2905                	addiw	s2,s2,1
    1dc2:	ff3919e3          	bne	s2,s3,1db4 <manywrites+0x1c>
    1dc6:	4491                	li	s1,4
    int st = 0;
    1dc8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dcc:	fa840513          	addi	a0,s0,-88
    1dd0:	68d020ef          	jal	ra,4c5c <wait>
    if(st != 0)
    1dd4:	fa842503          	lw	a0,-88(s0)
    1dd8:	e169                	bnez	a0,1e9a <manywrites+0x102>
  for(int ci = 0; ci < nchildren; ci++){
    1dda:	34fd                	addiw	s1,s1,-1
    1ddc:	f4f5                	bnez	s1,1dc8 <manywrites+0x30>
  exit(0);
    1dde:	4501                	li	a0,0
    1de0:	675020ef          	jal	ra,4c54 <exit>
      printf("fork failed\n");
    1de4:	00005517          	auipc	a0,0x5
    1de8:	29c50513          	addi	a0,a0,668 # 7080 <malloc+0x1f4c>
    1dec:	28e030ef          	jal	ra,507a <printf>
      exit(1);
    1df0:	4505                	li	a0,1
    1df2:	663020ef          	jal	ra,4c54 <exit>
      name[0] = 'b';
    1df6:	06200793          	li	a5,98
    1dfa:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1dfe:	0619079b          	addiw	a5,s2,97
    1e02:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e06:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e0a:	fa840513          	addi	a0,s0,-88
    1e0e:	697020ef          	jal	ra,4ca4 <unlink>
    1e12:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1e14:	0000ab97          	auipc	s7,0xa
    1e18:	e94b8b93          	addi	s7,s7,-364 # bca8 <buf>
        for(int i = 0; i < ci+1; i++){
    1e1c:	8a26                	mv	s4,s1
    1e1e:	02094863          	bltz	s2,1e4e <manywrites+0xb6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e22:	20200593          	li	a1,514
    1e26:	fa840513          	addi	a0,s0,-88
    1e2a:	66b020ef          	jal	ra,4c94 <open>
    1e2e:	89aa                	mv	s3,a0
          if(fd < 0){
    1e30:	02054d63          	bltz	a0,1e6a <manywrites+0xd2>
          int cc = write(fd, buf, sz);
    1e34:	660d                	lui	a2,0x3
    1e36:	85de                	mv	a1,s7
    1e38:	63d020ef          	jal	ra,4c74 <write>
          if(cc != sz){
    1e3c:	678d                	lui	a5,0x3
    1e3e:	04f51263          	bne	a0,a5,1e82 <manywrites+0xea>
          close(fd);
    1e42:	854e                	mv	a0,s3
    1e44:	639020ef          	jal	ra,4c7c <close>
        for(int i = 0; i < ci+1; i++){
    1e48:	2a05                	addiw	s4,s4,1
    1e4a:	fd495ce3          	bge	s2,s4,1e22 <manywrites+0x8a>
        unlink(name);
    1e4e:	fa840513          	addi	a0,s0,-88
    1e52:	653020ef          	jal	ra,4ca4 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e56:	3b7d                	addiw	s6,s6,-1
    1e58:	fc0b12e3          	bnez	s6,1e1c <manywrites+0x84>
      unlink(name);
    1e5c:	fa840513          	addi	a0,s0,-88
    1e60:	645020ef          	jal	ra,4ca4 <unlink>
      exit(0);
    1e64:	4501                	li	a0,0
    1e66:	5ef020ef          	jal	ra,4c54 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e6a:	fa840613          	addi	a2,s0,-88
    1e6e:	85d6                	mv	a1,s5
    1e70:	00004517          	auipc	a0,0x4
    1e74:	fd850513          	addi	a0,a0,-40 # 5e48 <malloc+0xd14>
    1e78:	202030ef          	jal	ra,507a <printf>
            exit(1);
    1e7c:	4505                	li	a0,1
    1e7e:	5d7020ef          	jal	ra,4c54 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e82:	86aa                	mv	a3,a0
    1e84:	660d                	lui	a2,0x3
    1e86:	85d6                	mv	a1,s5
    1e88:	00003517          	auipc	a0,0x3
    1e8c:	4b050513          	addi	a0,a0,1200 # 5338 <malloc+0x204>
    1e90:	1ea030ef          	jal	ra,507a <printf>
            exit(1);
    1e94:	4505                	li	a0,1
    1e96:	5bf020ef          	jal	ra,4c54 <exit>
      exit(st);
    1e9a:	5bb020ef          	jal	ra,4c54 <exit>

0000000000001e9e <copyinstr3>:
{
    1e9e:	7179                	addi	sp,sp,-48
    1ea0:	f406                	sd	ra,40(sp)
    1ea2:	f022                	sd	s0,32(sp)
    1ea4:	ec26                	sd	s1,24(sp)
    1ea6:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ea8:	6509                	lui	a0,0x2
    1eaa:	577020ef          	jal	ra,4c20 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1eae:	4501                	li	a0,0
    1eb0:	571020ef          	jal	ra,4c20 <sbrk>
  if((top % PGSIZE) != 0){
    1eb4:	03451793          	slli	a5,a0,0x34
    1eb8:	e7bd                	bnez	a5,1f26 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eba:	4501                	li	a0,0
    1ebc:	565020ef          	jal	ra,4c20 <sbrk>
  if(top % PGSIZE){
    1ec0:	03451793          	slli	a5,a0,0x34
    1ec4:	ebad                	bnez	a5,1f36 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ec6:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x5d>
  *b = 'x';
    1eca:	07800793          	li	a5,120
    1ece:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ed2:	8526                	mv	a0,s1
    1ed4:	5d1020ef          	jal	ra,4ca4 <unlink>
  if(ret != -1){
    1ed8:	57fd                	li	a5,-1
    1eda:	06f51763          	bne	a0,a5,1f48 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ede:	20100593          	li	a1,513
    1ee2:	8526                	mv	a0,s1
    1ee4:	5b1020ef          	jal	ra,4c94 <open>
  if(fd != -1){
    1ee8:	57fd                	li	a5,-1
    1eea:	06f51a63          	bne	a0,a5,1f5e <copyinstr3+0xc0>
  ret = link(b, b);
    1eee:	85a6                	mv	a1,s1
    1ef0:	8526                	mv	a0,s1
    1ef2:	5c3020ef          	jal	ra,4cb4 <link>
  if(ret != -1){
    1ef6:	57fd                	li	a5,-1
    1ef8:	06f51e63          	bne	a0,a5,1f74 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1efc:	00005797          	auipc	a5,0x5
    1f00:	c4c78793          	addi	a5,a5,-948 # 6b48 <malloc+0x1a14>
    1f04:	fcf43823          	sd	a5,-48(s0)
    1f08:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f0c:	fd040593          	addi	a1,s0,-48
    1f10:	8526                	mv	a0,s1
    1f12:	57b020ef          	jal	ra,4c8c <exec>
  if(ret != -1){
    1f16:	57fd                	li	a5,-1
    1f18:	06f51a63          	bne	a0,a5,1f8c <copyinstr3+0xee>
}
    1f1c:	70a2                	ld	ra,40(sp)
    1f1e:	7402                	ld	s0,32(sp)
    1f20:	64e2                	ld	s1,24(sp)
    1f22:	6145                	addi	sp,sp,48
    1f24:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f26:	0347d513          	srli	a0,a5,0x34
    1f2a:	6785                	lui	a5,0x1
    1f2c:	40a7853b          	subw	a0,a5,a0
    1f30:	4f1020ef          	jal	ra,4c20 <sbrk>
    1f34:	b759                	j	1eba <copyinstr3+0x1c>
    printf("oops\n");
    1f36:	00004517          	auipc	a0,0x4
    1f3a:	f2a50513          	addi	a0,a0,-214 # 5e60 <malloc+0xd2c>
    1f3e:	13c030ef          	jal	ra,507a <printf>
    exit(1);
    1f42:	4505                	li	a0,1
    1f44:	511020ef          	jal	ra,4c54 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f48:	862a                	mv	a2,a0
    1f4a:	85a6                	mv	a1,s1
    1f4c:	00004517          	auipc	a0,0x4
    1f50:	acc50513          	addi	a0,a0,-1332 # 5a18 <malloc+0x8e4>
    1f54:	126030ef          	jal	ra,507a <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	4fb020ef          	jal	ra,4c54 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f5e:	862a                	mv	a2,a0
    1f60:	85a6                	mv	a1,s1
    1f62:	00004517          	auipc	a0,0x4
    1f66:	ad650513          	addi	a0,a0,-1322 # 5a38 <malloc+0x904>
    1f6a:	110030ef          	jal	ra,507a <printf>
    exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	4e5020ef          	jal	ra,4c54 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f74:	86aa                	mv	a3,a0
    1f76:	8626                	mv	a2,s1
    1f78:	85a6                	mv	a1,s1
    1f7a:	00004517          	auipc	a0,0x4
    1f7e:	ade50513          	addi	a0,a0,-1314 # 5a58 <malloc+0x924>
    1f82:	0f8030ef          	jal	ra,507a <printf>
    exit(1);
    1f86:	4505                	li	a0,1
    1f88:	4cd020ef          	jal	ra,4c54 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f8c:	567d                	li	a2,-1
    1f8e:	85a6                	mv	a1,s1
    1f90:	00004517          	auipc	a0,0x4
    1f94:	af050513          	addi	a0,a0,-1296 # 5a80 <malloc+0x94c>
    1f98:	0e2030ef          	jal	ra,507a <printf>
    exit(1);
    1f9c:	4505                	li	a0,1
    1f9e:	4b7020ef          	jal	ra,4c54 <exit>

0000000000001fa2 <rwsbrk>:
{
    1fa2:	1101                	addi	sp,sp,-32
    1fa4:	ec06                	sd	ra,24(sp)
    1fa6:	e822                	sd	s0,16(sp)
    1fa8:	e426                	sd	s1,8(sp)
    1faa:	e04a                	sd	s2,0(sp)
    1fac:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fae:	6509                	lui	a0,0x2
    1fb0:	471020ef          	jal	ra,4c20 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    1fb4:	57fd                	li	a5,-1
    1fb6:	04f50963          	beq	a0,a5,2008 <rwsbrk+0x66>
    1fba:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1fbc:	7579                	lui	a0,0xffffe
    1fbe:	463020ef          	jal	ra,4c20 <sbrk>
    1fc2:	57fd                	li	a5,-1
    1fc4:	04f50b63          	beq	a0,a5,201a <rwsbrk+0x78>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1fc8:	20100593          	li	a1,513
    1fcc:	00004517          	auipc	a0,0x4
    1fd0:	ed450513          	addi	a0,a0,-300 # 5ea0 <malloc+0xd6c>
    1fd4:	4c1020ef          	jal	ra,4c94 <open>
    1fd8:	892a                	mv	s2,a0
  if(fd < 0){
    1fda:	04054963          	bltz	a0,202c <rwsbrk+0x8a>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    1fde:	6505                	lui	a0,0x1
    1fe0:	94aa                	add	s1,s1,a0
    1fe2:	40000613          	li	a2,1024
    1fe6:	85a6                	mv	a1,s1
    1fe8:	854a                	mv	a0,s2
    1fea:	48b020ef          	jal	ra,4c74 <write>
    1fee:	862a                	mv	a2,a0
  if(n >= 0){
    1ff0:	04054763          	bltz	a0,203e <rwsbrk+0x9c>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    1ff4:	85a6                	mv	a1,s1
    1ff6:	00004517          	auipc	a0,0x4
    1ffa:	eca50513          	addi	a0,a0,-310 # 5ec0 <malloc+0xd8c>
    1ffe:	07c030ef          	jal	ra,507a <printf>
    exit(1);
    2002:	4505                	li	a0,1
    2004:	451020ef          	jal	ra,4c54 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2008:	00004517          	auipc	a0,0x4
    200c:	e6050513          	addi	a0,a0,-416 # 5e68 <malloc+0xd34>
    2010:	06a030ef          	jal	ra,507a <printf>
    exit(1);
    2014:	4505                	li	a0,1
    2016:	43f020ef          	jal	ra,4c54 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    201a:	00004517          	auipc	a0,0x4
    201e:	e6650513          	addi	a0,a0,-410 # 5e80 <malloc+0xd4c>
    2022:	058030ef          	jal	ra,507a <printf>
    exit(1);
    2026:	4505                	li	a0,1
    2028:	42d020ef          	jal	ra,4c54 <exit>
    printf("open(rwsbrk) failed\n");
    202c:	00004517          	auipc	a0,0x4
    2030:	e7c50513          	addi	a0,a0,-388 # 5ea8 <malloc+0xd74>
    2034:	046030ef          	jal	ra,507a <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	41b020ef          	jal	ra,4c54 <exit>
  close(fd);
    203e:	854a                	mv	a0,s2
    2040:	43d020ef          	jal	ra,4c7c <close>
  unlink("rwsbrk");
    2044:	00004517          	auipc	a0,0x4
    2048:	e5c50513          	addi	a0,a0,-420 # 5ea0 <malloc+0xd6c>
    204c:	459020ef          	jal	ra,4ca4 <unlink>
  fd = open("README", O_RDONLY);
    2050:	4581                	li	a1,0
    2052:	00003517          	auipc	a0,0x3
    2056:	3ee50513          	addi	a0,a0,1006 # 5440 <malloc+0x30c>
    205a:	43b020ef          	jal	ra,4c94 <open>
    205e:	892a                	mv	s2,a0
  if(fd < 0){
    2060:	02054363          	bltz	a0,2086 <rwsbrk+0xe4>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2064:	4629                	li	a2,10
    2066:	85a6                	mv	a1,s1
    2068:	405020ef          	jal	ra,4c6c <read>
    206c:	862a                	mv	a2,a0
  if(n >= 0){
    206e:	02054563          	bltz	a0,2098 <rwsbrk+0xf6>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    2072:	85a6                	mv	a1,s1
    2074:	00004517          	auipc	a0,0x4
    2078:	e7c50513          	addi	a0,a0,-388 # 5ef0 <malloc+0xdbc>
    207c:	7ff020ef          	jal	ra,507a <printf>
    exit(1);
    2080:	4505                	li	a0,1
    2082:	3d3020ef          	jal	ra,4c54 <exit>
    printf("open(README) failed\n");
    2086:	00003517          	auipc	a0,0x3
    208a:	3c250513          	addi	a0,a0,962 # 5448 <malloc+0x314>
    208e:	7ed020ef          	jal	ra,507a <printf>
    exit(1);
    2092:	4505                	li	a0,1
    2094:	3c1020ef          	jal	ra,4c54 <exit>
  close(fd);
    2098:	854a                	mv	a0,s2
    209a:	3e3020ef          	jal	ra,4c7c <close>
  exit(0);
    209e:	4501                	li	a0,0
    20a0:	3b5020ef          	jal	ra,4c54 <exit>

00000000000020a4 <sbrkbasic>:
{
    20a4:	715d                	addi	sp,sp,-80
    20a6:	e486                	sd	ra,72(sp)
    20a8:	e0a2                	sd	s0,64(sp)
    20aa:	fc26                	sd	s1,56(sp)
    20ac:	f84a                	sd	s2,48(sp)
    20ae:	f44e                	sd	s3,40(sp)
    20b0:	f052                	sd	s4,32(sp)
    20b2:	ec56                	sd	s5,24(sp)
    20b4:	0880                	addi	s0,sp,80
    20b6:	8a2a                	mv	s4,a0
  pid = fork();
    20b8:	395020ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    20bc:	02054863          	bltz	a0,20ec <sbrkbasic+0x48>
  if(pid == 0){
    20c0:	e131                	bnez	a0,2104 <sbrkbasic+0x60>
    a = sbrk(TOOMUCH);
    20c2:	40000537          	lui	a0,0x40000
    20c6:	35b020ef          	jal	ra,4c20 <sbrk>
    if(a == (char*)SBRK_ERROR){
    20ca:	57fd                	li	a5,-1
    20cc:	02f50963          	beq	a0,a5,20fe <sbrkbasic+0x5a>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20d0:	400007b7          	lui	a5,0x40000
    20d4:	97aa                	add	a5,a5,a0
      *b = 99;
    20d6:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20da:	6705                	lui	a4,0x1
      *b = 99;
    20dc:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1358>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20e0:	953a                	add	a0,a0,a4
    20e2:	fef51de3          	bne	a0,a5,20dc <sbrkbasic+0x38>
    exit(1);
    20e6:	4505                	li	a0,1
    20e8:	36d020ef          	jal	ra,4c54 <exit>
    printf("fork failed in sbrkbasic\n");
    20ec:	00004517          	auipc	a0,0x4
    20f0:	e2c50513          	addi	a0,a0,-468 # 5f18 <malloc+0xde4>
    20f4:	787020ef          	jal	ra,507a <printf>
    exit(1);
    20f8:	4505                	li	a0,1
    20fa:	35b020ef          	jal	ra,4c54 <exit>
      exit(0);
    20fe:	4501                	li	a0,0
    2100:	355020ef          	jal	ra,4c54 <exit>
  wait(&xstatus);
    2104:	fbc40513          	addi	a0,s0,-68
    2108:	355020ef          	jal	ra,4c5c <wait>
  if(xstatus == 1){
    210c:	fbc42703          	lw	a4,-68(s0)
    2110:	4785                	li	a5,1
    2112:	00f70c63          	beq	a4,a5,212a <sbrkbasic+0x86>
  a = sbrk(0);
    2116:	4501                	li	a0,0
    2118:	309020ef          	jal	ra,4c20 <sbrk>
    211c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    211e:	4901                	li	s2,0
    *b = 1;
    2120:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2122:	6985                	lui	s3,0x1
    2124:	38898993          	addi	s3,s3,904 # 1388 <exectest+0x50>
    2128:	a821                	j	2140 <sbrkbasic+0x9c>
    printf("%s: too much memory allocated!\n", s);
    212a:	85d2                	mv	a1,s4
    212c:	00004517          	auipc	a0,0x4
    2130:	e0c50513          	addi	a0,a0,-500 # 5f38 <malloc+0xe04>
    2134:	747020ef          	jal	ra,507a <printf>
    exit(1);
    2138:	4505                	li	a0,1
    213a:	31b020ef          	jal	ra,4c54 <exit>
    a = b + 1;
    213e:	84be                	mv	s1,a5
    b = sbrk(1);
    2140:	4505                	li	a0,1
    2142:	2df020ef          	jal	ra,4c20 <sbrk>
    if(b != a){
    2146:	04951163          	bne	a0,s1,2188 <sbrkbasic+0xe4>
    *b = 1;
    214a:	01548023          	sb	s5,0(s1)
    a = b + 1;
    214e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2152:	2905                	addiw	s2,s2,1
    2154:	ff3915e3          	bne	s2,s3,213e <sbrkbasic+0x9a>
  pid = fork();
    2158:	2f5020ef          	jal	ra,4c4c <fork>
    215c:	892a                	mv	s2,a0
  if(pid < 0){
    215e:	04054263          	bltz	a0,21a2 <sbrkbasic+0xfe>
  c = sbrk(1);
    2162:	4505                	li	a0,1
    2164:	2bd020ef          	jal	ra,4c20 <sbrk>
  c = sbrk(1);
    2168:	4505                	li	a0,1
    216a:	2b7020ef          	jal	ra,4c20 <sbrk>
  if(c != a + 1){
    216e:	0489                	addi	s1,s1,2
    2170:	04a48363          	beq	s1,a0,21b6 <sbrkbasic+0x112>
    printf("%s: sbrk test failed post-fork\n", s);
    2174:	85d2                	mv	a1,s4
    2176:	00004517          	auipc	a0,0x4
    217a:	e2250513          	addi	a0,a0,-478 # 5f98 <malloc+0xe64>
    217e:	6fd020ef          	jal	ra,507a <printf>
    exit(1);
    2182:	4505                	li	a0,1
    2184:	2d1020ef          	jal	ra,4c54 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2188:	872a                	mv	a4,a0
    218a:	86a6                	mv	a3,s1
    218c:	864a                	mv	a2,s2
    218e:	85d2                	mv	a1,s4
    2190:	00004517          	auipc	a0,0x4
    2194:	dc850513          	addi	a0,a0,-568 # 5f58 <malloc+0xe24>
    2198:	6e3020ef          	jal	ra,507a <printf>
      exit(1);
    219c:	4505                	li	a0,1
    219e:	2b7020ef          	jal	ra,4c54 <exit>
    printf("%s: sbrk test fork failed\n", s);
    21a2:	85d2                	mv	a1,s4
    21a4:	00004517          	auipc	a0,0x4
    21a8:	dd450513          	addi	a0,a0,-556 # 5f78 <malloc+0xe44>
    21ac:	6cf020ef          	jal	ra,507a <printf>
    exit(1);
    21b0:	4505                	li	a0,1
    21b2:	2a3020ef          	jal	ra,4c54 <exit>
  if(pid == 0)
    21b6:	00091563          	bnez	s2,21c0 <sbrkbasic+0x11c>
    exit(0);
    21ba:	4501                	li	a0,0
    21bc:	299020ef          	jal	ra,4c54 <exit>
  wait(&xstatus);
    21c0:	fbc40513          	addi	a0,s0,-68
    21c4:	299020ef          	jal	ra,4c5c <wait>
  exit(xstatus);
    21c8:	fbc42503          	lw	a0,-68(s0)
    21cc:	289020ef          	jal	ra,4c54 <exit>

00000000000021d0 <sbrkmuch>:
{
    21d0:	7179                	addi	sp,sp,-48
    21d2:	f406                	sd	ra,40(sp)
    21d4:	f022                	sd	s0,32(sp)
    21d6:	ec26                	sd	s1,24(sp)
    21d8:	e84a                	sd	s2,16(sp)
    21da:	e44e                	sd	s3,8(sp)
    21dc:	e052                	sd	s4,0(sp)
    21de:	1800                	addi	s0,sp,48
    21e0:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21e2:	4501                	li	a0,0
    21e4:	23d020ef          	jal	ra,4c20 <sbrk>
    21e8:	892a                	mv	s2,a0
  a = sbrk(0);
    21ea:	4501                	li	a0,0
    21ec:	235020ef          	jal	ra,4c20 <sbrk>
    21f0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21f2:	06400537          	lui	a0,0x6400
    21f6:	9d05                	subw	a0,a0,s1
    21f8:	229020ef          	jal	ra,4c20 <sbrk>
  if (p != a) {
    21fc:	08a49763          	bne	s1,a0,228a <sbrkmuch+0xba>
  *lastaddr = 99;
    2200:	064007b7          	lui	a5,0x6400
    2204:	06300713          	li	a4,99
    2208:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1357>
  a = sbrk(0);
    220c:	4501                	li	a0,0
    220e:	213020ef          	jal	ra,4c20 <sbrk>
    2212:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2214:	757d                	lui	a0,0xfffff
    2216:	20b020ef          	jal	ra,4c20 <sbrk>
  if(c == (char*)SBRK_ERROR){
    221a:	57fd                	li	a5,-1
    221c:	08f50163          	beq	a0,a5,229e <sbrkmuch+0xce>
  c = sbrk(0);
    2220:	4501                	li	a0,0
    2222:	1ff020ef          	jal	ra,4c20 <sbrk>
  if(c != a - PGSIZE){
    2226:	77fd                	lui	a5,0xfffff
    2228:	97a6                	add	a5,a5,s1
    222a:	08f51463          	bne	a0,a5,22b2 <sbrkmuch+0xe2>
  a = sbrk(0);
    222e:	4501                	li	a0,0
    2230:	1f1020ef          	jal	ra,4c20 <sbrk>
    2234:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2236:	6505                	lui	a0,0x1
    2238:	1e9020ef          	jal	ra,4c20 <sbrk>
    223c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    223e:	08a49663          	bne	s1,a0,22ca <sbrkmuch+0xfa>
    2242:	4501                	li	a0,0
    2244:	1dd020ef          	jal	ra,4c20 <sbrk>
    2248:	6785                	lui	a5,0x1
    224a:	97a6                	add	a5,a5,s1
    224c:	06f51f63          	bne	a0,a5,22ca <sbrkmuch+0xfa>
  if(*lastaddr == 99){
    2250:	064007b7          	lui	a5,0x6400
    2254:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1357>
    2258:	06300793          	li	a5,99
    225c:	08f70363          	beq	a4,a5,22e2 <sbrkmuch+0x112>
  a = sbrk(0);
    2260:	4501                	li	a0,0
    2262:	1bf020ef          	jal	ra,4c20 <sbrk>
    2266:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2268:	4501                	li	a0,0
    226a:	1b7020ef          	jal	ra,4c20 <sbrk>
    226e:	40a9053b          	subw	a0,s2,a0
    2272:	1af020ef          	jal	ra,4c20 <sbrk>
  if(c != a){
    2276:	08a49063          	bne	s1,a0,22f6 <sbrkmuch+0x126>
}
    227a:	70a2                	ld	ra,40(sp)
    227c:	7402                	ld	s0,32(sp)
    227e:	64e2                	ld	s1,24(sp)
    2280:	6942                	ld	s2,16(sp)
    2282:	69a2                	ld	s3,8(sp)
    2284:	6a02                	ld	s4,0(sp)
    2286:	6145                	addi	sp,sp,48
    2288:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    228a:	85ce                	mv	a1,s3
    228c:	00004517          	auipc	a0,0x4
    2290:	d2c50513          	addi	a0,a0,-724 # 5fb8 <malloc+0xe84>
    2294:	5e7020ef          	jal	ra,507a <printf>
    exit(1);
    2298:	4505                	li	a0,1
    229a:	1bb020ef          	jal	ra,4c54 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    229e:	85ce                	mv	a1,s3
    22a0:	00004517          	auipc	a0,0x4
    22a4:	d6050513          	addi	a0,a0,-672 # 6000 <malloc+0xecc>
    22a8:	5d3020ef          	jal	ra,507a <printf>
    exit(1);
    22ac:	4505                	li	a0,1
    22ae:	1a7020ef          	jal	ra,4c54 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22b2:	86aa                	mv	a3,a0
    22b4:	8626                	mv	a2,s1
    22b6:	85ce                	mv	a1,s3
    22b8:	00004517          	auipc	a0,0x4
    22bc:	d6850513          	addi	a0,a0,-664 # 6020 <malloc+0xeec>
    22c0:	5bb020ef          	jal	ra,507a <printf>
    exit(1);
    22c4:	4505                	li	a0,1
    22c6:	18f020ef          	jal	ra,4c54 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22ca:	86d2                	mv	a3,s4
    22cc:	8626                	mv	a2,s1
    22ce:	85ce                	mv	a1,s3
    22d0:	00004517          	auipc	a0,0x4
    22d4:	d9050513          	addi	a0,a0,-624 # 6060 <malloc+0xf2c>
    22d8:	5a3020ef          	jal	ra,507a <printf>
    exit(1);
    22dc:	4505                	li	a0,1
    22de:	177020ef          	jal	ra,4c54 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22e2:	85ce                	mv	a1,s3
    22e4:	00004517          	auipc	a0,0x4
    22e8:	dac50513          	addi	a0,a0,-596 # 6090 <malloc+0xf5c>
    22ec:	58f020ef          	jal	ra,507a <printf>
    exit(1);
    22f0:	4505                	li	a0,1
    22f2:	163020ef          	jal	ra,4c54 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22f6:	86aa                	mv	a3,a0
    22f8:	8626                	mv	a2,s1
    22fa:	85ce                	mv	a1,s3
    22fc:	00004517          	auipc	a0,0x4
    2300:	dcc50513          	addi	a0,a0,-564 # 60c8 <malloc+0xf94>
    2304:	577020ef          	jal	ra,507a <printf>
    exit(1);
    2308:	4505                	li	a0,1
    230a:	14b020ef          	jal	ra,4c54 <exit>

000000000000230e <sbrkarg>:
{
    230e:	7179                	addi	sp,sp,-48
    2310:	f406                	sd	ra,40(sp)
    2312:	f022                	sd	s0,32(sp)
    2314:	ec26                	sd	s1,24(sp)
    2316:	e84a                	sd	s2,16(sp)
    2318:	e44e                	sd	s3,8(sp)
    231a:	1800                	addi	s0,sp,48
    231c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    231e:	6505                	lui	a0,0x1
    2320:	101020ef          	jal	ra,4c20 <sbrk>
    2324:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2326:	20100593          	li	a1,513
    232a:	00004517          	auipc	a0,0x4
    232e:	dc650513          	addi	a0,a0,-570 # 60f0 <malloc+0xfbc>
    2332:	163020ef          	jal	ra,4c94 <open>
    2336:	84aa                	mv	s1,a0
  unlink("sbrk");
    2338:	00004517          	auipc	a0,0x4
    233c:	db850513          	addi	a0,a0,-584 # 60f0 <malloc+0xfbc>
    2340:	165020ef          	jal	ra,4ca4 <unlink>
  if(fd < 0)  {
    2344:	0204c963          	bltz	s1,2376 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2348:	6605                	lui	a2,0x1
    234a:	85ca                	mv	a1,s2
    234c:	8526                	mv	a0,s1
    234e:	127020ef          	jal	ra,4c74 <write>
    2352:	02054c63          	bltz	a0,238a <sbrkarg+0x7c>
  close(fd);
    2356:	8526                	mv	a0,s1
    2358:	125020ef          	jal	ra,4c7c <close>
  a = sbrk(PGSIZE);
    235c:	6505                	lui	a0,0x1
    235e:	0c3020ef          	jal	ra,4c20 <sbrk>
  if(pipe((int *) a) != 0){
    2362:	103020ef          	jal	ra,4c64 <pipe>
    2366:	ed05                	bnez	a0,239e <sbrkarg+0x90>
}
    2368:	70a2                	ld	ra,40(sp)
    236a:	7402                	ld	s0,32(sp)
    236c:	64e2                	ld	s1,24(sp)
    236e:	6942                	ld	s2,16(sp)
    2370:	69a2                	ld	s3,8(sp)
    2372:	6145                	addi	sp,sp,48
    2374:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2376:	85ce                	mv	a1,s3
    2378:	00004517          	auipc	a0,0x4
    237c:	d8050513          	addi	a0,a0,-640 # 60f8 <malloc+0xfc4>
    2380:	4fb020ef          	jal	ra,507a <printf>
    exit(1);
    2384:	4505                	li	a0,1
    2386:	0cf020ef          	jal	ra,4c54 <exit>
    printf("%s: write sbrk failed\n", s);
    238a:	85ce                	mv	a1,s3
    238c:	00004517          	auipc	a0,0x4
    2390:	d8450513          	addi	a0,a0,-636 # 6110 <malloc+0xfdc>
    2394:	4e7020ef          	jal	ra,507a <printf>
    exit(1);
    2398:	4505                	li	a0,1
    239a:	0bb020ef          	jal	ra,4c54 <exit>
    printf("%s: pipe() failed\n", s);
    239e:	85ce                	mv	a1,s3
    23a0:	00004517          	auipc	a0,0x4
    23a4:	86050513          	addi	a0,a0,-1952 # 5c00 <malloc+0xacc>
    23a8:	4d3020ef          	jal	ra,507a <printf>
    exit(1);
    23ac:	4505                	li	a0,1
    23ae:	0a7020ef          	jal	ra,4c54 <exit>

00000000000023b2 <argptest>:
{
    23b2:	1101                	addi	sp,sp,-32
    23b4:	ec06                	sd	ra,24(sp)
    23b6:	e822                	sd	s0,16(sp)
    23b8:	e426                	sd	s1,8(sp)
    23ba:	e04a                	sd	s2,0(sp)
    23bc:	1000                	addi	s0,sp,32
    23be:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    23c0:	4581                	li	a1,0
    23c2:	00004517          	auipc	a0,0x4
    23c6:	d6650513          	addi	a0,a0,-666 # 6128 <malloc+0xff4>
    23ca:	0cb020ef          	jal	ra,4c94 <open>
  if (fd < 0) {
    23ce:	02054563          	bltz	a0,23f8 <argptest+0x46>
    23d2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23d4:	4501                	li	a0,0
    23d6:	04b020ef          	jal	ra,4c20 <sbrk>
    23da:	567d                	li	a2,-1
    23dc:	fff50593          	addi	a1,a0,-1
    23e0:	8526                	mv	a0,s1
    23e2:	08b020ef          	jal	ra,4c6c <read>
  close(fd);
    23e6:	8526                	mv	a0,s1
    23e8:	095020ef          	jal	ra,4c7c <close>
}
    23ec:	60e2                	ld	ra,24(sp)
    23ee:	6442                	ld	s0,16(sp)
    23f0:	64a2                	ld	s1,8(sp)
    23f2:	6902                	ld	s2,0(sp)
    23f4:	6105                	addi	sp,sp,32
    23f6:	8082                	ret
    printf("%s: open failed\n", s);
    23f8:	85ca                	mv	a1,s2
    23fa:	00003517          	auipc	a0,0x3
    23fe:	71650513          	addi	a0,a0,1814 # 5b10 <malloc+0x9dc>
    2402:	479020ef          	jal	ra,507a <printf>
    exit(1);
    2406:	4505                	li	a0,1
    2408:	04d020ef          	jal	ra,4c54 <exit>

000000000000240c <sbrkbugs>:
{
    240c:	1141                	addi	sp,sp,-16
    240e:	e406                	sd	ra,8(sp)
    2410:	e022                	sd	s0,0(sp)
    2412:	0800                	addi	s0,sp,16
  int pid = fork();
    2414:	039020ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    2418:	00054c63          	bltz	a0,2430 <sbrkbugs+0x24>
  if(pid == 0){
    241c:	e11d                	bnez	a0,2442 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    241e:	003020ef          	jal	ra,4c20 <sbrk>
    sbrk(-sz);
    2422:	40a0053b          	negw	a0,a0
    2426:	7fa020ef          	jal	ra,4c20 <sbrk>
    exit(0);
    242a:	4501                	li	a0,0
    242c:	029020ef          	jal	ra,4c54 <exit>
    printf("fork failed\n");
    2430:	00005517          	auipc	a0,0x5
    2434:	c5050513          	addi	a0,a0,-944 # 7080 <malloc+0x1f4c>
    2438:	443020ef          	jal	ra,507a <printf>
    exit(1);
    243c:	4505                	li	a0,1
    243e:	017020ef          	jal	ra,4c54 <exit>
  wait(0);
    2442:	4501                	li	a0,0
    2444:	019020ef          	jal	ra,4c5c <wait>
  pid = fork();
    2448:	005020ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    244c:	00054f63          	bltz	a0,246a <sbrkbugs+0x5e>
  if(pid == 0){
    2450:	e515                	bnez	a0,247c <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2452:	7ce020ef          	jal	ra,4c20 <sbrk>
    sbrk(-(sz - 3500));
    2456:	6785                	lui	a5,0x1
    2458:	dac7879b          	addiw	a5,a5,-596
    245c:	40a7853b          	subw	a0,a5,a0
    2460:	7c0020ef          	jal	ra,4c20 <sbrk>
    exit(0);
    2464:	4501                	li	a0,0
    2466:	7ee020ef          	jal	ra,4c54 <exit>
    printf("fork failed\n");
    246a:	00005517          	auipc	a0,0x5
    246e:	c1650513          	addi	a0,a0,-1002 # 7080 <malloc+0x1f4c>
    2472:	409020ef          	jal	ra,507a <printf>
    exit(1);
    2476:	4505                	li	a0,1
    2478:	7dc020ef          	jal	ra,4c54 <exit>
  wait(0);
    247c:	4501                	li	a0,0
    247e:	7de020ef          	jal	ra,4c5c <wait>
  pid = fork();
    2482:	7ca020ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    2486:	02054263          	bltz	a0,24aa <sbrkbugs+0x9e>
  if(pid == 0){
    248a:	e90d                	bnez	a0,24bc <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    248c:	794020ef          	jal	ra,4c20 <sbrk>
    2490:	67ad                	lui	a5,0xb
    2492:	8007879b          	addiw	a5,a5,-2048
    2496:	40a7853b          	subw	a0,a5,a0
    249a:	786020ef          	jal	ra,4c20 <sbrk>
    sbrk(-10);
    249e:	5559                	li	a0,-10
    24a0:	780020ef          	jal	ra,4c20 <sbrk>
    exit(0);
    24a4:	4501                	li	a0,0
    24a6:	7ae020ef          	jal	ra,4c54 <exit>
    printf("fork failed\n");
    24aa:	00005517          	auipc	a0,0x5
    24ae:	bd650513          	addi	a0,a0,-1066 # 7080 <malloc+0x1f4c>
    24b2:	3c9020ef          	jal	ra,507a <printf>
    exit(1);
    24b6:	4505                	li	a0,1
    24b8:	79c020ef          	jal	ra,4c54 <exit>
  wait(0);
    24bc:	4501                	li	a0,0
    24be:	79e020ef          	jal	ra,4c5c <wait>
  exit(0);
    24c2:	4501                	li	a0,0
    24c4:	790020ef          	jal	ra,4c54 <exit>

00000000000024c8 <sbrklast>:
{
    24c8:	7179                	addi	sp,sp,-48
    24ca:	f406                	sd	ra,40(sp)
    24cc:	f022                	sd	s0,32(sp)
    24ce:	ec26                	sd	s1,24(sp)
    24d0:	e84a                	sd	s2,16(sp)
    24d2:	e44e                	sd	s3,8(sp)
    24d4:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    24d6:	4501                	li	a0,0
    24d8:	748020ef          	jal	ra,4c20 <sbrk>
  if((top % PGSIZE) != 0)
    24dc:	03451793          	slli	a5,a0,0x34
    24e0:	ebb5                	bnez	a5,2554 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24e2:	6505                	lui	a0,0x1
    24e4:	73c020ef          	jal	ra,4c20 <sbrk>
  sbrk(10);
    24e8:	4529                	li	a0,10
    24ea:	736020ef          	jal	ra,4c20 <sbrk>
  sbrk(-20);
    24ee:	5531                	li	a0,-20
    24f0:	730020ef          	jal	ra,4c20 <sbrk>
  top = (uint64) sbrk(0);
    24f4:	4501                	li	a0,0
    24f6:	72a020ef          	jal	ra,4c20 <sbrk>
    24fa:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    24fc:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x118>
  p[0] = 'x';
    2500:	07800793          	li	a5,120
    2504:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2508:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    250c:	20200593          	li	a1,514
    2510:	854a                	mv	a0,s2
    2512:	782020ef          	jal	ra,4c94 <open>
    2516:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2518:	4605                	li	a2,1
    251a:	85ca                	mv	a1,s2
    251c:	758020ef          	jal	ra,4c74 <write>
  close(fd);
    2520:	854e                	mv	a0,s3
    2522:	75a020ef          	jal	ra,4c7c <close>
  fd = open(p, O_RDWR);
    2526:	4589                	li	a1,2
    2528:	854a                	mv	a0,s2
    252a:	76a020ef          	jal	ra,4c94 <open>
  p[0] = '\0';
    252e:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2532:	4605                	li	a2,1
    2534:	85ca                	mv	a1,s2
    2536:	736020ef          	jal	ra,4c6c <read>
  if(p[0] != 'x')
    253a:	fc04c703          	lbu	a4,-64(s1)
    253e:	07800793          	li	a5,120
    2542:	02f71163          	bne	a4,a5,2564 <sbrklast+0x9c>
}
    2546:	70a2                	ld	ra,40(sp)
    2548:	7402                	ld	s0,32(sp)
    254a:	64e2                	ld	s1,24(sp)
    254c:	6942                	ld	s2,16(sp)
    254e:	69a2                	ld	s3,8(sp)
    2550:	6145                	addi	sp,sp,48
    2552:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2554:	0347d513          	srli	a0,a5,0x34
    2558:	6785                	lui	a5,0x1
    255a:	40a7853b          	subw	a0,a5,a0
    255e:	6c2020ef          	jal	ra,4c20 <sbrk>
    2562:	b741                	j	24e2 <sbrklast+0x1a>
    exit(1);
    2564:	4505                	li	a0,1
    2566:	6ee020ef          	jal	ra,4c54 <exit>

000000000000256a <sbrk8000>:
{
    256a:	1141                	addi	sp,sp,-16
    256c:	e406                	sd	ra,8(sp)
    256e:	e022                	sd	s0,0(sp)
    2570:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2572:	80000537          	lui	a0,0x80000
    2576:	0511                	addi	a0,a0,4
    2578:	6a8020ef          	jal	ra,4c20 <sbrk>
  volatile char *top = sbrk(0);
    257c:	4501                	li	a0,0
    257e:	6a2020ef          	jal	ra,4c20 <sbrk>
  *(top-1) = *(top-1) + 1;
    2582:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff1357>
    2586:	0785                	addi	a5,a5,1
    2588:	0ff7f793          	andi	a5,a5,255
    258c:	fef50fa3          	sb	a5,-1(a0)
}
    2590:	60a2                	ld	ra,8(sp)
    2592:	6402                	ld	s0,0(sp)
    2594:	0141                	addi	sp,sp,16
    2596:	8082                	ret

0000000000002598 <execout>:
{
    2598:	715d                	addi	sp,sp,-80
    259a:	e486                	sd	ra,72(sp)
    259c:	e0a2                	sd	s0,64(sp)
    259e:	fc26                	sd	s1,56(sp)
    25a0:	f84a                	sd	s2,48(sp)
    25a2:	f44e                	sd	s3,40(sp)
    25a4:	f052                	sd	s4,32(sp)
    25a6:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25a8:	4901                	li	s2,0
    25aa:	49bd                	li	s3,15
    int pid = fork();
    25ac:	6a0020ef          	jal	ra,4c4c <fork>
    25b0:	84aa                	mv	s1,a0
    if(pid < 0){
    25b2:	00054c63          	bltz	a0,25ca <execout+0x32>
    } else if(pid == 0){
    25b6:	c11d                	beqz	a0,25dc <execout+0x44>
      wait((int*)0);
    25b8:	4501                	li	a0,0
    25ba:	6a2020ef          	jal	ra,4c5c <wait>
  for(int avail = 0; avail < 15; avail++){
    25be:	2905                	addiw	s2,s2,1
    25c0:	ff3916e3          	bne	s2,s3,25ac <execout+0x14>
  exit(0);
    25c4:	4501                	li	a0,0
    25c6:	68e020ef          	jal	ra,4c54 <exit>
      printf("fork failed\n");
    25ca:	00005517          	auipc	a0,0x5
    25ce:	ab650513          	addi	a0,a0,-1354 # 7080 <malloc+0x1f4c>
    25d2:	2a9020ef          	jal	ra,507a <printf>
      exit(1);
    25d6:	4505                	li	a0,1
    25d8:	67c020ef          	jal	ra,4c54 <exit>
        if(a == SBRK_ERROR)
    25dc:	59fd                	li	s3,-1
        *(a + PGSIZE - 1) = 1;
    25de:	4a05                	li	s4,1
        char *a = sbrk(PGSIZE);
    25e0:	6505                	lui	a0,0x1
    25e2:	63e020ef          	jal	ra,4c20 <sbrk>
        if(a == SBRK_ERROR)
    25e6:	01350763          	beq	a0,s3,25f4 <execout+0x5c>
        *(a + PGSIZE - 1) = 1;
    25ea:	6785                	lui	a5,0x1
    25ec:	953e                	add	a0,a0,a5
    25ee:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x21>
      while(1){
    25f2:	b7fd                	j	25e0 <execout+0x48>
      for(int i = 0; i < avail; i++)
    25f4:	01205863          	blez	s2,2604 <execout+0x6c>
        sbrk(-PGSIZE);
    25f8:	757d                	lui	a0,0xfffff
    25fa:	626020ef          	jal	ra,4c20 <sbrk>
      for(int i = 0; i < avail; i++)
    25fe:	2485                	addiw	s1,s1,1
    2600:	ff249ce3          	bne	s1,s2,25f8 <execout+0x60>
      close(1);
    2604:	4505                	li	a0,1
    2606:	676020ef          	jal	ra,4c7c <close>
      char *args[] = { "echo", "x", 0 };
    260a:	00003517          	auipc	a0,0x3
    260e:	c5e50513          	addi	a0,a0,-930 # 5268 <malloc+0x134>
    2612:	faa43c23          	sd	a0,-72(s0)
    2616:	00003797          	auipc	a5,0x3
    261a:	cc278793          	addi	a5,a5,-830 # 52d8 <malloc+0x1a4>
    261e:	fcf43023          	sd	a5,-64(s0)
    2622:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2626:	fb840593          	addi	a1,s0,-72
    262a:	662020ef          	jal	ra,4c8c <exec>
      exit(0);
    262e:	4501                	li	a0,0
    2630:	624020ef          	jal	ra,4c54 <exit>

0000000000002634 <fourteen>:
{
    2634:	1101                	addi	sp,sp,-32
    2636:	ec06                	sd	ra,24(sp)
    2638:	e822                	sd	s0,16(sp)
    263a:	e426                	sd	s1,8(sp)
    263c:	1000                	addi	s0,sp,32
    263e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2640:	00004517          	auipc	a0,0x4
    2644:	cc050513          	addi	a0,a0,-832 # 6300 <malloc+0x11cc>
    2648:	674020ef          	jal	ra,4cbc <mkdir>
    264c:	e555                	bnez	a0,26f8 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    264e:	00004517          	auipc	a0,0x4
    2652:	b0a50513          	addi	a0,a0,-1270 # 6158 <malloc+0x1024>
    2656:	666020ef          	jal	ra,4cbc <mkdir>
    265a:	e94d                	bnez	a0,270c <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    265c:	20000593          	li	a1,512
    2660:	00004517          	auipc	a0,0x4
    2664:	b5050513          	addi	a0,a0,-1200 # 61b0 <malloc+0x107c>
    2668:	62c020ef          	jal	ra,4c94 <open>
  if(fd < 0){
    266c:	0a054a63          	bltz	a0,2720 <fourteen+0xec>
  close(fd);
    2670:	60c020ef          	jal	ra,4c7c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2674:	4581                	li	a1,0
    2676:	00004517          	auipc	a0,0x4
    267a:	bb250513          	addi	a0,a0,-1102 # 6228 <malloc+0x10f4>
    267e:	616020ef          	jal	ra,4c94 <open>
  if(fd < 0){
    2682:	0a054963          	bltz	a0,2734 <fourteen+0x100>
  close(fd);
    2686:	5f6020ef          	jal	ra,4c7c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    268a:	00004517          	auipc	a0,0x4
    268e:	c0e50513          	addi	a0,a0,-1010 # 6298 <malloc+0x1164>
    2692:	62a020ef          	jal	ra,4cbc <mkdir>
    2696:	c94d                	beqz	a0,2748 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    2698:	00004517          	auipc	a0,0x4
    269c:	c5850513          	addi	a0,a0,-936 # 62f0 <malloc+0x11bc>
    26a0:	61c020ef          	jal	ra,4cbc <mkdir>
    26a4:	cd45                	beqz	a0,275c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26a6:	00004517          	auipc	a0,0x4
    26aa:	c4a50513          	addi	a0,a0,-950 # 62f0 <malloc+0x11bc>
    26ae:	5f6020ef          	jal	ra,4ca4 <unlink>
  unlink("12345678901234/12345678901234");
    26b2:	00004517          	auipc	a0,0x4
    26b6:	be650513          	addi	a0,a0,-1050 # 6298 <malloc+0x1164>
    26ba:	5ea020ef          	jal	ra,4ca4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26be:	00004517          	auipc	a0,0x4
    26c2:	b6a50513          	addi	a0,a0,-1174 # 6228 <malloc+0x10f4>
    26c6:	5de020ef          	jal	ra,4ca4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26ca:	00004517          	auipc	a0,0x4
    26ce:	ae650513          	addi	a0,a0,-1306 # 61b0 <malloc+0x107c>
    26d2:	5d2020ef          	jal	ra,4ca4 <unlink>
  unlink("12345678901234/123456789012345");
    26d6:	00004517          	auipc	a0,0x4
    26da:	a8250513          	addi	a0,a0,-1406 # 6158 <malloc+0x1024>
    26de:	5c6020ef          	jal	ra,4ca4 <unlink>
  unlink("12345678901234");
    26e2:	00004517          	auipc	a0,0x4
    26e6:	c1e50513          	addi	a0,a0,-994 # 6300 <malloc+0x11cc>
    26ea:	5ba020ef          	jal	ra,4ca4 <unlink>
}
    26ee:	60e2                	ld	ra,24(sp)
    26f0:	6442                	ld	s0,16(sp)
    26f2:	64a2                	ld	s1,8(sp)
    26f4:	6105                	addi	sp,sp,32
    26f6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26f8:	85a6                	mv	a1,s1
    26fa:	00004517          	auipc	a0,0x4
    26fe:	a3650513          	addi	a0,a0,-1482 # 6130 <malloc+0xffc>
    2702:	179020ef          	jal	ra,507a <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	54c020ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    270c:	85a6                	mv	a1,s1
    270e:	00004517          	auipc	a0,0x4
    2712:	a6a50513          	addi	a0,a0,-1430 # 6178 <malloc+0x1044>
    2716:	165020ef          	jal	ra,507a <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	538020ef          	jal	ra,4c54 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	abe50513          	addi	a0,a0,-1346 # 61e0 <malloc+0x10ac>
    272a:	151020ef          	jal	ra,507a <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	524020ef          	jal	ra,4c54 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	b2250513          	addi	a0,a0,-1246 # 6258 <malloc+0x1124>
    273e:	13d020ef          	jal	ra,507a <printf>
    exit(1);
    2742:	4505                	li	a0,1
    2744:	510020ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2748:	85a6                	mv	a1,s1
    274a:	00004517          	auipc	a0,0x4
    274e:	b6e50513          	addi	a0,a0,-1170 # 62b8 <malloc+0x1184>
    2752:	129020ef          	jal	ra,507a <printf>
    exit(1);
    2756:	4505                	li	a0,1
    2758:	4fc020ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    275c:	85a6                	mv	a1,s1
    275e:	00004517          	auipc	a0,0x4
    2762:	bb250513          	addi	a0,a0,-1102 # 6310 <malloc+0x11dc>
    2766:	115020ef          	jal	ra,507a <printf>
    exit(1);
    276a:	4505                	li	a0,1
    276c:	4e8020ef          	jal	ra,4c54 <exit>

0000000000002770 <diskfull>:
{
    2770:	b8010113          	addi	sp,sp,-1152
    2774:	46113c23          	sd	ra,1144(sp)
    2778:	46813823          	sd	s0,1136(sp)
    277c:	46913423          	sd	s1,1128(sp)
    2780:	47213023          	sd	s2,1120(sp)
    2784:	45313c23          	sd	s3,1112(sp)
    2788:	45413823          	sd	s4,1104(sp)
    278c:	45513423          	sd	s5,1096(sp)
    2790:	45613023          	sd	s6,1088(sp)
    2794:	43713c23          	sd	s7,1080(sp)
    2798:	43813823          	sd	s8,1072(sp)
    279c:	43913423          	sd	s9,1064(sp)
    27a0:	48010413          	addi	s0,sp,1152
    27a4:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27a6:	00004517          	auipc	a0,0x4
    27aa:	ba250513          	addi	a0,a0,-1118 # 6348 <malloc+0x1214>
    27ae:	4f6020ef          	jal	ra,4ca4 <unlink>
    27b2:	03000993          	li	s3,48
    name[0] = 'b';
    27b6:	06200b13          	li	s6,98
    name[1] = 'i';
    27ba:	06900a93          	li	s5,105
    name[2] = 'g';
    27be:	06700a13          	li	s4,103
    27c2:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    27c6:	07f00c13          	li	s8,127
    27ca:	aab9                	j	2928 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    27cc:	b8040613          	addi	a2,s0,-1152
    27d0:	85e6                	mv	a1,s9
    27d2:	00004517          	auipc	a0,0x4
    27d6:	b8650513          	addi	a0,a0,-1146 # 6358 <malloc+0x1224>
    27da:	0a1020ef          	jal	ra,507a <printf>
      break;
    27de:	a039                	j	27ec <diskfull+0x7c>
        close(fd);
    27e0:	854a                	mv	a0,s2
    27e2:	49a020ef          	jal	ra,4c7c <close>
    close(fd);
    27e6:	854a                	mv	a0,s2
    27e8:	494020ef          	jal	ra,4c7c <close>
  for(int i = 0; i < nzz; i++){
    27ec:	4481                	li	s1,0
    name[0] = 'z';
    27ee:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    27f2:	08000993          	li	s3,128
    name[0] = 'z';
    27f6:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    27fa:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    27fe:	41f4d79b          	sraiw	a5,s1,0x1f
    2802:	01b7d71b          	srliw	a4,a5,0x1b
    2806:	009707bb          	addw	a5,a4,s1
    280a:	4057d69b          	sraiw	a3,a5,0x5
    280e:	0306869b          	addiw	a3,a3,48
    2812:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2816:	8bfd                	andi	a5,a5,31
    2818:	9f99                	subw	a5,a5,a4
    281a:	0307879b          	addiw	a5,a5,48
    281e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2822:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2826:	ba040513          	addi	a0,s0,-1120
    282a:	47a020ef          	jal	ra,4ca4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    282e:	60200593          	li	a1,1538
    2832:	ba040513          	addi	a0,s0,-1120
    2836:	45e020ef          	jal	ra,4c94 <open>
    if(fd < 0)
    283a:	00054763          	bltz	a0,2848 <diskfull+0xd8>
    close(fd);
    283e:	43e020ef          	jal	ra,4c7c <close>
  for(int i = 0; i < nzz; i++){
    2842:	2485                	addiw	s1,s1,1
    2844:	fb3499e3          	bne	s1,s3,27f6 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    2848:	00004517          	auipc	a0,0x4
    284c:	b0050513          	addi	a0,a0,-1280 # 6348 <malloc+0x1214>
    2850:	46c020ef          	jal	ra,4cbc <mkdir>
    2854:	12050063          	beqz	a0,2974 <diskfull+0x204>
  unlink("diskfulldir");
    2858:	00004517          	auipc	a0,0x4
    285c:	af050513          	addi	a0,a0,-1296 # 6348 <malloc+0x1214>
    2860:	444020ef          	jal	ra,4ca4 <unlink>
  for(int i = 0; i < nzz; i++){
    2864:	4481                	li	s1,0
    name[0] = 'z';
    2866:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    286a:	08000993          	li	s3,128
    name[0] = 'z';
    286e:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2872:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2876:	41f4d79b          	sraiw	a5,s1,0x1f
    287a:	01b7d71b          	srliw	a4,a5,0x1b
    287e:	009707bb          	addw	a5,a4,s1
    2882:	4057d69b          	sraiw	a3,a5,0x5
    2886:	0306869b          	addiw	a3,a3,48
    288a:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    288e:	8bfd                	andi	a5,a5,31
    2890:	9f99                	subw	a5,a5,a4
    2892:	0307879b          	addiw	a5,a5,48
    2896:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    289a:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    289e:	ba040513          	addi	a0,s0,-1120
    28a2:	402020ef          	jal	ra,4ca4 <unlink>
  for(int i = 0; i < nzz; i++){
    28a6:	2485                	addiw	s1,s1,1
    28a8:	fd3493e3          	bne	s1,s3,286e <diskfull+0xfe>
    28ac:	03000493          	li	s1,48
    name[0] = 'b';
    28b0:	06200a93          	li	s5,98
    name[1] = 'i';
    28b4:	06900a13          	li	s4,105
    name[2] = 'g';
    28b8:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    28bc:	07f00913          	li	s2,127
    name[0] = 'b';
    28c0:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    28c4:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    28c8:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    28cc:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    28d0:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28d4:	ba040513          	addi	a0,s0,-1120
    28d8:	3cc020ef          	jal	ra,4ca4 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    28dc:	2485                	addiw	s1,s1,1
    28de:	0ff4f493          	andi	s1,s1,255
    28e2:	fd249fe3          	bne	s1,s2,28c0 <diskfull+0x150>
}
    28e6:	47813083          	ld	ra,1144(sp)
    28ea:	47013403          	ld	s0,1136(sp)
    28ee:	46813483          	ld	s1,1128(sp)
    28f2:	46013903          	ld	s2,1120(sp)
    28f6:	45813983          	ld	s3,1112(sp)
    28fa:	45013a03          	ld	s4,1104(sp)
    28fe:	44813a83          	ld	s5,1096(sp)
    2902:	44013b03          	ld	s6,1088(sp)
    2906:	43813b83          	ld	s7,1080(sp)
    290a:	43013c03          	ld	s8,1072(sp)
    290e:	42813c83          	ld	s9,1064(sp)
    2912:	48010113          	addi	sp,sp,1152
    2916:	8082                	ret
    close(fd);
    2918:	854a                	mv	a0,s2
    291a:	362020ef          	jal	ra,4c7c <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    291e:	2985                	addiw	s3,s3,1
    2920:	0ff9f993          	andi	s3,s3,255
    2924:	ed8984e3          	beq	s3,s8,27ec <diskfull+0x7c>
    name[0] = 'b';
    2928:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    292c:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2930:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2934:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2938:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    293c:	b8040513          	addi	a0,s0,-1152
    2940:	364020ef          	jal	ra,4ca4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2944:	60200593          	li	a1,1538
    2948:	b8040513          	addi	a0,s0,-1152
    294c:	348020ef          	jal	ra,4c94 <open>
    2950:	892a                	mv	s2,a0
    if(fd < 0){
    2952:	e6054de3          	bltz	a0,27cc <diskfull+0x5c>
    2956:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    2958:	40000613          	li	a2,1024
    295c:	ba040593          	addi	a1,s0,-1120
    2960:	854a                	mv	a0,s2
    2962:	312020ef          	jal	ra,4c74 <write>
    2966:	40000793          	li	a5,1024
    296a:	e6f51be3          	bne	a0,a5,27e0 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    296e:	34fd                	addiw	s1,s1,-1
    2970:	f4e5                	bnez	s1,2958 <diskfull+0x1e8>
    2972:	b75d                	j	2918 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2974:	85e6                	mv	a1,s9
    2976:	00004517          	auipc	a0,0x4
    297a:	a0250513          	addi	a0,a0,-1534 # 6378 <malloc+0x1244>
    297e:	6fc020ef          	jal	ra,507a <printf>
    2982:	bdd9                	j	2858 <diskfull+0xe8>

0000000000002984 <iputtest>:
{
    2984:	1101                	addi	sp,sp,-32
    2986:	ec06                	sd	ra,24(sp)
    2988:	e822                	sd	s0,16(sp)
    298a:	e426                	sd	s1,8(sp)
    298c:	1000                	addi	s0,sp,32
    298e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2990:	00004517          	auipc	a0,0x4
    2994:	a1850513          	addi	a0,a0,-1512 # 63a8 <malloc+0x1274>
    2998:	324020ef          	jal	ra,4cbc <mkdir>
    299c:	02054f63          	bltz	a0,29da <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29a0:	00004517          	auipc	a0,0x4
    29a4:	a0850513          	addi	a0,a0,-1528 # 63a8 <malloc+0x1274>
    29a8:	31c020ef          	jal	ra,4cc4 <chdir>
    29ac:	04054163          	bltz	a0,29ee <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29b0:	00004517          	auipc	a0,0x4
    29b4:	a3850513          	addi	a0,a0,-1480 # 63e8 <malloc+0x12b4>
    29b8:	2ec020ef          	jal	ra,4ca4 <unlink>
    29bc:	04054363          	bltz	a0,2a02 <iputtest+0x7e>
  if(chdir("/") < 0){
    29c0:	00004517          	auipc	a0,0x4
    29c4:	a5850513          	addi	a0,a0,-1448 # 6418 <malloc+0x12e4>
    29c8:	2fc020ef          	jal	ra,4cc4 <chdir>
    29cc:	04054563          	bltz	a0,2a16 <iputtest+0x92>
}
    29d0:	60e2                	ld	ra,24(sp)
    29d2:	6442                	ld	s0,16(sp)
    29d4:	64a2                	ld	s1,8(sp)
    29d6:	6105                	addi	sp,sp,32
    29d8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29da:	85a6                	mv	a1,s1
    29dc:	00004517          	auipc	a0,0x4
    29e0:	9d450513          	addi	a0,a0,-1580 # 63b0 <malloc+0x127c>
    29e4:	696020ef          	jal	ra,507a <printf>
    exit(1);
    29e8:	4505                	li	a0,1
    29ea:	26a020ef          	jal	ra,4c54 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29ee:	85a6                	mv	a1,s1
    29f0:	00004517          	auipc	a0,0x4
    29f4:	9d850513          	addi	a0,a0,-1576 # 63c8 <malloc+0x1294>
    29f8:	682020ef          	jal	ra,507a <printf>
    exit(1);
    29fc:	4505                	li	a0,1
    29fe:	256020ef          	jal	ra,4c54 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a02:	85a6                	mv	a1,s1
    2a04:	00004517          	auipc	a0,0x4
    2a08:	9f450513          	addi	a0,a0,-1548 # 63f8 <malloc+0x12c4>
    2a0c:	66e020ef          	jal	ra,507a <printf>
    exit(1);
    2a10:	4505                	li	a0,1
    2a12:	242020ef          	jal	ra,4c54 <exit>
    printf("%s: chdir / failed\n", s);
    2a16:	85a6                	mv	a1,s1
    2a18:	00004517          	auipc	a0,0x4
    2a1c:	a0850513          	addi	a0,a0,-1528 # 6420 <malloc+0x12ec>
    2a20:	65a020ef          	jal	ra,507a <printf>
    exit(1);
    2a24:	4505                	li	a0,1
    2a26:	22e020ef          	jal	ra,4c54 <exit>

0000000000002a2a <exitiputtest>:
{
    2a2a:	7179                	addi	sp,sp,-48
    2a2c:	f406                	sd	ra,40(sp)
    2a2e:	f022                	sd	s0,32(sp)
    2a30:	ec26                	sd	s1,24(sp)
    2a32:	1800                	addi	s0,sp,48
    2a34:	84aa                	mv	s1,a0
  pid = fork();
    2a36:	216020ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    2a3a:	02054e63          	bltz	a0,2a76 <exitiputtest+0x4c>
  if(pid == 0){
    2a3e:	e541                	bnez	a0,2ac6 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a40:	00004517          	auipc	a0,0x4
    2a44:	96850513          	addi	a0,a0,-1688 # 63a8 <malloc+0x1274>
    2a48:	274020ef          	jal	ra,4cbc <mkdir>
    2a4c:	02054f63          	bltz	a0,2a8a <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a50:	00004517          	auipc	a0,0x4
    2a54:	95850513          	addi	a0,a0,-1704 # 63a8 <malloc+0x1274>
    2a58:	26c020ef          	jal	ra,4cc4 <chdir>
    2a5c:	04054163          	bltz	a0,2a9e <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2a60:	00004517          	auipc	a0,0x4
    2a64:	98850513          	addi	a0,a0,-1656 # 63e8 <malloc+0x12b4>
    2a68:	23c020ef          	jal	ra,4ca4 <unlink>
    2a6c:	04054363          	bltz	a0,2ab2 <exitiputtest+0x88>
    exit(0);
    2a70:	4501                	li	a0,0
    2a72:	1e2020ef          	jal	ra,4c54 <exit>
    printf("%s: fork failed\n", s);
    2a76:	85a6                	mv	a1,s1
    2a78:	00003517          	auipc	a0,0x3
    2a7c:	08050513          	addi	a0,a0,128 # 5af8 <malloc+0x9c4>
    2a80:	5fa020ef          	jal	ra,507a <printf>
    exit(1);
    2a84:	4505                	li	a0,1
    2a86:	1ce020ef          	jal	ra,4c54 <exit>
      printf("%s: mkdir failed\n", s);
    2a8a:	85a6                	mv	a1,s1
    2a8c:	00004517          	auipc	a0,0x4
    2a90:	92450513          	addi	a0,a0,-1756 # 63b0 <malloc+0x127c>
    2a94:	5e6020ef          	jal	ra,507a <printf>
      exit(1);
    2a98:	4505                	li	a0,1
    2a9a:	1ba020ef          	jal	ra,4c54 <exit>
      printf("%s: child chdir failed\n", s);
    2a9e:	85a6                	mv	a1,s1
    2aa0:	00004517          	auipc	a0,0x4
    2aa4:	99850513          	addi	a0,a0,-1640 # 6438 <malloc+0x1304>
    2aa8:	5d2020ef          	jal	ra,507a <printf>
      exit(1);
    2aac:	4505                	li	a0,1
    2aae:	1a6020ef          	jal	ra,4c54 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ab2:	85a6                	mv	a1,s1
    2ab4:	00004517          	auipc	a0,0x4
    2ab8:	94450513          	addi	a0,a0,-1724 # 63f8 <malloc+0x12c4>
    2abc:	5be020ef          	jal	ra,507a <printf>
      exit(1);
    2ac0:	4505                	li	a0,1
    2ac2:	192020ef          	jal	ra,4c54 <exit>
  wait(&xstatus);
    2ac6:	fdc40513          	addi	a0,s0,-36
    2aca:	192020ef          	jal	ra,4c5c <wait>
  exit(xstatus);
    2ace:	fdc42503          	lw	a0,-36(s0)
    2ad2:	182020ef          	jal	ra,4c54 <exit>

0000000000002ad6 <dirtest>:
{
    2ad6:	1101                	addi	sp,sp,-32
    2ad8:	ec06                	sd	ra,24(sp)
    2ada:	e822                	sd	s0,16(sp)
    2adc:	e426                	sd	s1,8(sp)
    2ade:	1000                	addi	s0,sp,32
    2ae0:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2ae2:	00004517          	auipc	a0,0x4
    2ae6:	96e50513          	addi	a0,a0,-1682 # 6450 <malloc+0x131c>
    2aea:	1d2020ef          	jal	ra,4cbc <mkdir>
    2aee:	02054f63          	bltz	a0,2b2c <dirtest+0x56>
  if(chdir("dir0") < 0){
    2af2:	00004517          	auipc	a0,0x4
    2af6:	95e50513          	addi	a0,a0,-1698 # 6450 <malloc+0x131c>
    2afa:	1ca020ef          	jal	ra,4cc4 <chdir>
    2afe:	04054163          	bltz	a0,2b40 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b02:	00004517          	auipc	a0,0x4
    2b06:	96e50513          	addi	a0,a0,-1682 # 6470 <malloc+0x133c>
    2b0a:	1ba020ef          	jal	ra,4cc4 <chdir>
    2b0e:	04054363          	bltz	a0,2b54 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b12:	00004517          	auipc	a0,0x4
    2b16:	93e50513          	addi	a0,a0,-1730 # 6450 <malloc+0x131c>
    2b1a:	18a020ef          	jal	ra,4ca4 <unlink>
    2b1e:	04054563          	bltz	a0,2b68 <dirtest+0x92>
}
    2b22:	60e2                	ld	ra,24(sp)
    2b24:	6442                	ld	s0,16(sp)
    2b26:	64a2                	ld	s1,8(sp)
    2b28:	6105                	addi	sp,sp,32
    2b2a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b2c:	85a6                	mv	a1,s1
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	88250513          	addi	a0,a0,-1918 # 63b0 <malloc+0x127c>
    2b36:	544020ef          	jal	ra,507a <printf>
    exit(1);
    2b3a:	4505                	li	a0,1
    2b3c:	118020ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b40:	85a6                	mv	a1,s1
    2b42:	00004517          	auipc	a0,0x4
    2b46:	91650513          	addi	a0,a0,-1770 # 6458 <malloc+0x1324>
    2b4a:	530020ef          	jal	ra,507a <printf>
    exit(1);
    2b4e:	4505                	li	a0,1
    2b50:	104020ef          	jal	ra,4c54 <exit>
    printf("%s: chdir .. failed\n", s);
    2b54:	85a6                	mv	a1,s1
    2b56:	00004517          	auipc	a0,0x4
    2b5a:	92250513          	addi	a0,a0,-1758 # 6478 <malloc+0x1344>
    2b5e:	51c020ef          	jal	ra,507a <printf>
    exit(1);
    2b62:	4505                	li	a0,1
    2b64:	0f0020ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b68:	85a6                	mv	a1,s1
    2b6a:	00004517          	auipc	a0,0x4
    2b6e:	92650513          	addi	a0,a0,-1754 # 6490 <malloc+0x135c>
    2b72:	508020ef          	jal	ra,507a <printf>
    exit(1);
    2b76:	4505                	li	a0,1
    2b78:	0dc020ef          	jal	ra,4c54 <exit>

0000000000002b7c <subdir>:
{
    2b7c:	1101                	addi	sp,sp,-32
    2b7e:	ec06                	sd	ra,24(sp)
    2b80:	e822                	sd	s0,16(sp)
    2b82:	e426                	sd	s1,8(sp)
    2b84:	e04a                	sd	s2,0(sp)
    2b86:	1000                	addi	s0,sp,32
    2b88:	892a                	mv	s2,a0
  unlink("ff");
    2b8a:	00004517          	auipc	a0,0x4
    2b8e:	a4e50513          	addi	a0,a0,-1458 # 65d8 <malloc+0x14a4>
    2b92:	112020ef          	jal	ra,4ca4 <unlink>
  if(mkdir("dd") != 0){
    2b96:	00004517          	auipc	a0,0x4
    2b9a:	91250513          	addi	a0,a0,-1774 # 64a8 <malloc+0x1374>
    2b9e:	11e020ef          	jal	ra,4cbc <mkdir>
    2ba2:	2e051263          	bnez	a0,2e86 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2ba6:	20200593          	li	a1,514
    2baa:	00004517          	auipc	a0,0x4
    2bae:	91e50513          	addi	a0,a0,-1762 # 64c8 <malloc+0x1394>
    2bb2:	0e2020ef          	jal	ra,4c94 <open>
    2bb6:	84aa                	mv	s1,a0
  if(fd < 0){
    2bb8:	2e054163          	bltz	a0,2e9a <subdir+0x31e>
  write(fd, "ff", 2);
    2bbc:	4609                	li	a2,2
    2bbe:	00004597          	auipc	a1,0x4
    2bc2:	a1a58593          	addi	a1,a1,-1510 # 65d8 <malloc+0x14a4>
    2bc6:	0ae020ef          	jal	ra,4c74 <write>
  close(fd);
    2bca:	8526                	mv	a0,s1
    2bcc:	0b0020ef          	jal	ra,4c7c <close>
  if(unlink("dd") >= 0){
    2bd0:	00004517          	auipc	a0,0x4
    2bd4:	8d850513          	addi	a0,a0,-1832 # 64a8 <malloc+0x1374>
    2bd8:	0cc020ef          	jal	ra,4ca4 <unlink>
    2bdc:	2c055963          	bgez	a0,2eae <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2be0:	00004517          	auipc	a0,0x4
    2be4:	94050513          	addi	a0,a0,-1728 # 6520 <malloc+0x13ec>
    2be8:	0d4020ef          	jal	ra,4cbc <mkdir>
    2bec:	2c051b63          	bnez	a0,2ec2 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bf0:	20200593          	li	a1,514
    2bf4:	00004517          	auipc	a0,0x4
    2bf8:	95450513          	addi	a0,a0,-1708 # 6548 <malloc+0x1414>
    2bfc:	098020ef          	jal	ra,4c94 <open>
    2c00:	84aa                	mv	s1,a0
  if(fd < 0){
    2c02:	2c054a63          	bltz	a0,2ed6 <subdir+0x35a>
  write(fd, "FF", 2);
    2c06:	4609                	li	a2,2
    2c08:	00004597          	auipc	a1,0x4
    2c0c:	97058593          	addi	a1,a1,-1680 # 6578 <malloc+0x1444>
    2c10:	064020ef          	jal	ra,4c74 <write>
  close(fd);
    2c14:	8526                	mv	a0,s1
    2c16:	066020ef          	jal	ra,4c7c <close>
  fd = open("dd/dd/../ff", 0);
    2c1a:	4581                	li	a1,0
    2c1c:	00004517          	auipc	a0,0x4
    2c20:	96450513          	addi	a0,a0,-1692 # 6580 <malloc+0x144c>
    2c24:	070020ef          	jal	ra,4c94 <open>
    2c28:	84aa                	mv	s1,a0
  if(fd < 0){
    2c2a:	2c054063          	bltz	a0,2eea <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c2e:	660d                	lui	a2,0x3
    2c30:	00009597          	auipc	a1,0x9
    2c34:	07858593          	addi	a1,a1,120 # bca8 <buf>
    2c38:	034020ef          	jal	ra,4c6c <read>
  if(cc != 2 || buf[0] != 'f'){
    2c3c:	4789                	li	a5,2
    2c3e:	2cf51063          	bne	a0,a5,2efe <subdir+0x382>
    2c42:	00009717          	auipc	a4,0x9
    2c46:	06674703          	lbu	a4,102(a4) # bca8 <buf>
    2c4a:	06600793          	li	a5,102
    2c4e:	2af71863          	bne	a4,a5,2efe <subdir+0x382>
  close(fd);
    2c52:	8526                	mv	a0,s1
    2c54:	028020ef          	jal	ra,4c7c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c58:	00004597          	auipc	a1,0x4
    2c5c:	97858593          	addi	a1,a1,-1672 # 65d0 <malloc+0x149c>
    2c60:	00004517          	auipc	a0,0x4
    2c64:	8e850513          	addi	a0,a0,-1816 # 6548 <malloc+0x1414>
    2c68:	04c020ef          	jal	ra,4cb4 <link>
    2c6c:	2a051363          	bnez	a0,2f12 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2c70:	00004517          	auipc	a0,0x4
    2c74:	8d850513          	addi	a0,a0,-1832 # 6548 <malloc+0x1414>
    2c78:	02c020ef          	jal	ra,4ca4 <unlink>
    2c7c:	2a051563          	bnez	a0,2f26 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c80:	4581                	li	a1,0
    2c82:	00004517          	auipc	a0,0x4
    2c86:	8c650513          	addi	a0,a0,-1850 # 6548 <malloc+0x1414>
    2c8a:	00a020ef          	jal	ra,4c94 <open>
    2c8e:	2a055663          	bgez	a0,2f3a <subdir+0x3be>
  if(chdir("dd") != 0){
    2c92:	00004517          	auipc	a0,0x4
    2c96:	81650513          	addi	a0,a0,-2026 # 64a8 <malloc+0x1374>
    2c9a:	02a020ef          	jal	ra,4cc4 <chdir>
    2c9e:	2a051863          	bnez	a0,2f4e <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2ca2:	00004517          	auipc	a0,0x4
    2ca6:	9c650513          	addi	a0,a0,-1594 # 6668 <malloc+0x1534>
    2caa:	01a020ef          	jal	ra,4cc4 <chdir>
    2cae:	2a051a63          	bnez	a0,2f62 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	9e650513          	addi	a0,a0,-1562 # 6698 <malloc+0x1564>
    2cba:	00a020ef          	jal	ra,4cc4 <chdir>
    2cbe:	2a051c63          	bnez	a0,2f76 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2cc2:	00004517          	auipc	a0,0x4
    2cc6:	a0e50513          	addi	a0,a0,-1522 # 66d0 <malloc+0x159c>
    2cca:	7fb010ef          	jal	ra,4cc4 <chdir>
    2cce:	2a051e63          	bnez	a0,2f8a <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cd2:	4581                	li	a1,0
    2cd4:	00004517          	auipc	a0,0x4
    2cd8:	8fc50513          	addi	a0,a0,-1796 # 65d0 <malloc+0x149c>
    2cdc:	7b9010ef          	jal	ra,4c94 <open>
    2ce0:	84aa                	mv	s1,a0
  if(fd < 0){
    2ce2:	2a054e63          	bltz	a0,2f9e <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2ce6:	660d                	lui	a2,0x3
    2ce8:	00009597          	auipc	a1,0x9
    2cec:	fc058593          	addi	a1,a1,-64 # bca8 <buf>
    2cf0:	77d010ef          	jal	ra,4c6c <read>
    2cf4:	4789                	li	a5,2
    2cf6:	2af51e63          	bne	a0,a5,2fb2 <subdir+0x436>
  close(fd);
    2cfa:	8526                	mv	a0,s1
    2cfc:	781010ef          	jal	ra,4c7c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d00:	4581                	li	a1,0
    2d02:	00004517          	auipc	a0,0x4
    2d06:	84650513          	addi	a0,a0,-1978 # 6548 <malloc+0x1414>
    2d0a:	78b010ef          	jal	ra,4c94 <open>
    2d0e:	2a055c63          	bgez	a0,2fc6 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d12:	20200593          	li	a1,514
    2d16:	00004517          	auipc	a0,0x4
    2d1a:	a4a50513          	addi	a0,a0,-1462 # 6760 <malloc+0x162c>
    2d1e:	777010ef          	jal	ra,4c94 <open>
    2d22:	2a055c63          	bgez	a0,2fda <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d26:	20200593          	li	a1,514
    2d2a:	00004517          	auipc	a0,0x4
    2d2e:	a6650513          	addi	a0,a0,-1434 # 6790 <malloc+0x165c>
    2d32:	763010ef          	jal	ra,4c94 <open>
    2d36:	2a055c63          	bgez	a0,2fee <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d3a:	20000593          	li	a1,512
    2d3e:	00003517          	auipc	a0,0x3
    2d42:	76a50513          	addi	a0,a0,1898 # 64a8 <malloc+0x1374>
    2d46:	74f010ef          	jal	ra,4c94 <open>
    2d4a:	2a055c63          	bgez	a0,3002 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d4e:	4589                	li	a1,2
    2d50:	00003517          	auipc	a0,0x3
    2d54:	75850513          	addi	a0,a0,1880 # 64a8 <malloc+0x1374>
    2d58:	73d010ef          	jal	ra,4c94 <open>
    2d5c:	2a055d63          	bgez	a0,3016 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2d60:	4585                	li	a1,1
    2d62:	00003517          	auipc	a0,0x3
    2d66:	74650513          	addi	a0,a0,1862 # 64a8 <malloc+0x1374>
    2d6a:	72b010ef          	jal	ra,4c94 <open>
    2d6e:	2a055e63          	bgez	a0,302a <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2d72:	00004597          	auipc	a1,0x4
    2d76:	aae58593          	addi	a1,a1,-1362 # 6820 <malloc+0x16ec>
    2d7a:	00004517          	auipc	a0,0x4
    2d7e:	9e650513          	addi	a0,a0,-1562 # 6760 <malloc+0x162c>
    2d82:	733010ef          	jal	ra,4cb4 <link>
    2d86:	2a050c63          	beqz	a0,303e <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2d8a:	00004597          	auipc	a1,0x4
    2d8e:	a9658593          	addi	a1,a1,-1386 # 6820 <malloc+0x16ec>
    2d92:	00004517          	auipc	a0,0x4
    2d96:	9fe50513          	addi	a0,a0,-1538 # 6790 <malloc+0x165c>
    2d9a:	71b010ef          	jal	ra,4cb4 <link>
    2d9e:	2a050a63          	beqz	a0,3052 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2da2:	00004597          	auipc	a1,0x4
    2da6:	82e58593          	addi	a1,a1,-2002 # 65d0 <malloc+0x149c>
    2daa:	00003517          	auipc	a0,0x3
    2dae:	71e50513          	addi	a0,a0,1822 # 64c8 <malloc+0x1394>
    2db2:	703010ef          	jal	ra,4cb4 <link>
    2db6:	2a050863          	beqz	a0,3066 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2dba:	00004517          	auipc	a0,0x4
    2dbe:	9a650513          	addi	a0,a0,-1626 # 6760 <malloc+0x162c>
    2dc2:	6fb010ef          	jal	ra,4cbc <mkdir>
    2dc6:	2a050a63          	beqz	a0,307a <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2dca:	00004517          	auipc	a0,0x4
    2dce:	9c650513          	addi	a0,a0,-1594 # 6790 <malloc+0x165c>
    2dd2:	6eb010ef          	jal	ra,4cbc <mkdir>
    2dd6:	2a050c63          	beqz	a0,308e <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2dda:	00003517          	auipc	a0,0x3
    2dde:	7f650513          	addi	a0,a0,2038 # 65d0 <malloc+0x149c>
    2de2:	6db010ef          	jal	ra,4cbc <mkdir>
    2de6:	2a050e63          	beqz	a0,30a2 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2dea:	00004517          	auipc	a0,0x4
    2dee:	9a650513          	addi	a0,a0,-1626 # 6790 <malloc+0x165c>
    2df2:	6b3010ef          	jal	ra,4ca4 <unlink>
    2df6:	2c050063          	beqz	a0,30b6 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2dfa:	00004517          	auipc	a0,0x4
    2dfe:	96650513          	addi	a0,a0,-1690 # 6760 <malloc+0x162c>
    2e02:	6a3010ef          	jal	ra,4ca4 <unlink>
    2e06:	2c050263          	beqz	a0,30ca <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e0a:	00003517          	auipc	a0,0x3
    2e0e:	6be50513          	addi	a0,a0,1726 # 64c8 <malloc+0x1394>
    2e12:	6b3010ef          	jal	ra,4cc4 <chdir>
    2e16:	2c050463          	beqz	a0,30de <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e1a:	00004517          	auipc	a0,0x4
    2e1e:	b5650513          	addi	a0,a0,-1194 # 6970 <malloc+0x183c>
    2e22:	6a3010ef          	jal	ra,4cc4 <chdir>
    2e26:	2c050663          	beqz	a0,30f2 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e2a:	00003517          	auipc	a0,0x3
    2e2e:	7a650513          	addi	a0,a0,1958 # 65d0 <malloc+0x149c>
    2e32:	673010ef          	jal	ra,4ca4 <unlink>
    2e36:	2c051863          	bnez	a0,3106 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e3a:	00003517          	auipc	a0,0x3
    2e3e:	68e50513          	addi	a0,a0,1678 # 64c8 <malloc+0x1394>
    2e42:	663010ef          	jal	ra,4ca4 <unlink>
    2e46:	2c051a63          	bnez	a0,311a <subdir+0x59e>
  if(unlink("dd") == 0){
    2e4a:	00003517          	auipc	a0,0x3
    2e4e:	65e50513          	addi	a0,a0,1630 # 64a8 <malloc+0x1374>
    2e52:	653010ef          	jal	ra,4ca4 <unlink>
    2e56:	2c050c63          	beqz	a0,312e <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2e5a:	00004517          	auipc	a0,0x4
    2e5e:	b8650513          	addi	a0,a0,-1146 # 69e0 <malloc+0x18ac>
    2e62:	643010ef          	jal	ra,4ca4 <unlink>
    2e66:	2c054e63          	bltz	a0,3142 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2e6a:	00003517          	auipc	a0,0x3
    2e6e:	63e50513          	addi	a0,a0,1598 # 64a8 <malloc+0x1374>
    2e72:	633010ef          	jal	ra,4ca4 <unlink>
    2e76:	2e054063          	bltz	a0,3156 <subdir+0x5da>
}
    2e7a:	60e2                	ld	ra,24(sp)
    2e7c:	6442                	ld	s0,16(sp)
    2e7e:	64a2                	ld	s1,8(sp)
    2e80:	6902                	ld	s2,0(sp)
    2e82:	6105                	addi	sp,sp,32
    2e84:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e86:	85ca                	mv	a1,s2
    2e88:	00003517          	auipc	a0,0x3
    2e8c:	62850513          	addi	a0,a0,1576 # 64b0 <malloc+0x137c>
    2e90:	1ea020ef          	jal	ra,507a <printf>
    exit(1);
    2e94:	4505                	li	a0,1
    2e96:	5bf010ef          	jal	ra,4c54 <exit>
    printf("%s: create dd/ff failed\n", s);
    2e9a:	85ca                	mv	a1,s2
    2e9c:	00003517          	auipc	a0,0x3
    2ea0:	63450513          	addi	a0,a0,1588 # 64d0 <malloc+0x139c>
    2ea4:	1d6020ef          	jal	ra,507a <printf>
    exit(1);
    2ea8:	4505                	li	a0,1
    2eaa:	5ab010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2eae:	85ca                	mv	a1,s2
    2eb0:	00003517          	auipc	a0,0x3
    2eb4:	64050513          	addi	a0,a0,1600 # 64f0 <malloc+0x13bc>
    2eb8:	1c2020ef          	jal	ra,507a <printf>
    exit(1);
    2ebc:	4505                	li	a0,1
    2ebe:	597010ef          	jal	ra,4c54 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ec2:	85ca                	mv	a1,s2
    2ec4:	00003517          	auipc	a0,0x3
    2ec8:	66450513          	addi	a0,a0,1636 # 6528 <malloc+0x13f4>
    2ecc:	1ae020ef          	jal	ra,507a <printf>
    exit(1);
    2ed0:	4505                	li	a0,1
    2ed2:	583010ef          	jal	ra,4c54 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ed6:	85ca                	mv	a1,s2
    2ed8:	00003517          	auipc	a0,0x3
    2edc:	68050513          	addi	a0,a0,1664 # 6558 <malloc+0x1424>
    2ee0:	19a020ef          	jal	ra,507a <printf>
    exit(1);
    2ee4:	4505                	li	a0,1
    2ee6:	56f010ef          	jal	ra,4c54 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2eea:	85ca                	mv	a1,s2
    2eec:	00003517          	auipc	a0,0x3
    2ef0:	6a450513          	addi	a0,a0,1700 # 6590 <malloc+0x145c>
    2ef4:	186020ef          	jal	ra,507a <printf>
    exit(1);
    2ef8:	4505                	li	a0,1
    2efa:	55b010ef          	jal	ra,4c54 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2efe:	85ca                	mv	a1,s2
    2f00:	00003517          	auipc	a0,0x3
    2f04:	6b050513          	addi	a0,a0,1712 # 65b0 <malloc+0x147c>
    2f08:	172020ef          	jal	ra,507a <printf>
    exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	547010ef          	jal	ra,4c54 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f12:	85ca                	mv	a1,s2
    2f14:	00003517          	auipc	a0,0x3
    2f18:	6cc50513          	addi	a0,a0,1740 # 65e0 <malloc+0x14ac>
    2f1c:	15e020ef          	jal	ra,507a <printf>
    exit(1);
    2f20:	4505                	li	a0,1
    2f22:	533010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f26:	85ca                	mv	a1,s2
    2f28:	00003517          	auipc	a0,0x3
    2f2c:	6e050513          	addi	a0,a0,1760 # 6608 <malloc+0x14d4>
    2f30:	14a020ef          	jal	ra,507a <printf>
    exit(1);
    2f34:	4505                	li	a0,1
    2f36:	51f010ef          	jal	ra,4c54 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f3a:	85ca                	mv	a1,s2
    2f3c:	00003517          	auipc	a0,0x3
    2f40:	6ec50513          	addi	a0,a0,1772 # 6628 <malloc+0x14f4>
    2f44:	136020ef          	jal	ra,507a <printf>
    exit(1);
    2f48:	4505                	li	a0,1
    2f4a:	50b010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dd failed\n", s);
    2f4e:	85ca                	mv	a1,s2
    2f50:	00003517          	auipc	a0,0x3
    2f54:	70050513          	addi	a0,a0,1792 # 6650 <malloc+0x151c>
    2f58:	122020ef          	jal	ra,507a <printf>
    exit(1);
    2f5c:	4505                	li	a0,1
    2f5e:	4f7010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f62:	85ca                	mv	a1,s2
    2f64:	00003517          	auipc	a0,0x3
    2f68:	71450513          	addi	a0,a0,1812 # 6678 <malloc+0x1544>
    2f6c:	10e020ef          	jal	ra,507a <printf>
    exit(1);
    2f70:	4505                	li	a0,1
    2f72:	4e3010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f76:	85ca                	mv	a1,s2
    2f78:	00003517          	auipc	a0,0x3
    2f7c:	73050513          	addi	a0,a0,1840 # 66a8 <malloc+0x1574>
    2f80:	0fa020ef          	jal	ra,507a <printf>
    exit(1);
    2f84:	4505                	li	a0,1
    2f86:	4cf010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f8a:	85ca                	mv	a1,s2
    2f8c:	00003517          	auipc	a0,0x3
    2f90:	74c50513          	addi	a0,a0,1868 # 66d8 <malloc+0x15a4>
    2f94:	0e6020ef          	jal	ra,507a <printf>
    exit(1);
    2f98:	4505                	li	a0,1
    2f9a:	4bb010ef          	jal	ra,4c54 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f9e:	85ca                	mv	a1,s2
    2fa0:	00003517          	auipc	a0,0x3
    2fa4:	75050513          	addi	a0,a0,1872 # 66f0 <malloc+0x15bc>
    2fa8:	0d2020ef          	jal	ra,507a <printf>
    exit(1);
    2fac:	4505                	li	a0,1
    2fae:	4a7010ef          	jal	ra,4c54 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fb2:	85ca                	mv	a1,s2
    2fb4:	00003517          	auipc	a0,0x3
    2fb8:	75c50513          	addi	a0,a0,1884 # 6710 <malloc+0x15dc>
    2fbc:	0be020ef          	jal	ra,507a <printf>
    exit(1);
    2fc0:	4505                	li	a0,1
    2fc2:	493010ef          	jal	ra,4c54 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fc6:	85ca                	mv	a1,s2
    2fc8:	00003517          	auipc	a0,0x3
    2fcc:	76850513          	addi	a0,a0,1896 # 6730 <malloc+0x15fc>
    2fd0:	0aa020ef          	jal	ra,507a <printf>
    exit(1);
    2fd4:	4505                	li	a0,1
    2fd6:	47f010ef          	jal	ra,4c54 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fda:	85ca                	mv	a1,s2
    2fdc:	00003517          	auipc	a0,0x3
    2fe0:	79450513          	addi	a0,a0,1940 # 6770 <malloc+0x163c>
    2fe4:	096020ef          	jal	ra,507a <printf>
    exit(1);
    2fe8:	4505                	li	a0,1
    2fea:	46b010ef          	jal	ra,4c54 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2fee:	85ca                	mv	a1,s2
    2ff0:	00003517          	auipc	a0,0x3
    2ff4:	7b050513          	addi	a0,a0,1968 # 67a0 <malloc+0x166c>
    2ff8:	082020ef          	jal	ra,507a <printf>
    exit(1);
    2ffc:	4505                	li	a0,1
    2ffe:	457010ef          	jal	ra,4c54 <exit>
    printf("%s: create dd succeeded!\n", s);
    3002:	85ca                	mv	a1,s2
    3004:	00003517          	auipc	a0,0x3
    3008:	7bc50513          	addi	a0,a0,1980 # 67c0 <malloc+0x168c>
    300c:	06e020ef          	jal	ra,507a <printf>
    exit(1);
    3010:	4505                	li	a0,1
    3012:	443010ef          	jal	ra,4c54 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3016:	85ca                	mv	a1,s2
    3018:	00003517          	auipc	a0,0x3
    301c:	7c850513          	addi	a0,a0,1992 # 67e0 <malloc+0x16ac>
    3020:	05a020ef          	jal	ra,507a <printf>
    exit(1);
    3024:	4505                	li	a0,1
    3026:	42f010ef          	jal	ra,4c54 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    302a:	85ca                	mv	a1,s2
    302c:	00003517          	auipc	a0,0x3
    3030:	7d450513          	addi	a0,a0,2004 # 6800 <malloc+0x16cc>
    3034:	046020ef          	jal	ra,507a <printf>
    exit(1);
    3038:	4505                	li	a0,1
    303a:	41b010ef          	jal	ra,4c54 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    303e:	85ca                	mv	a1,s2
    3040:	00003517          	auipc	a0,0x3
    3044:	7f050513          	addi	a0,a0,2032 # 6830 <malloc+0x16fc>
    3048:	032020ef          	jal	ra,507a <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	407010ef          	jal	ra,4c54 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3052:	85ca                	mv	a1,s2
    3054:	00004517          	auipc	a0,0x4
    3058:	80450513          	addi	a0,a0,-2044 # 6858 <malloc+0x1724>
    305c:	01e020ef          	jal	ra,507a <printf>
    exit(1);
    3060:	4505                	li	a0,1
    3062:	3f3010ef          	jal	ra,4c54 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3066:	85ca                	mv	a1,s2
    3068:	00004517          	auipc	a0,0x4
    306c:	81850513          	addi	a0,a0,-2024 # 6880 <malloc+0x174c>
    3070:	00a020ef          	jal	ra,507a <printf>
    exit(1);
    3074:	4505                	li	a0,1
    3076:	3df010ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    307a:	85ca                	mv	a1,s2
    307c:	00004517          	auipc	a0,0x4
    3080:	82c50513          	addi	a0,a0,-2004 # 68a8 <malloc+0x1774>
    3084:	7f7010ef          	jal	ra,507a <printf>
    exit(1);
    3088:	4505                	li	a0,1
    308a:	3cb010ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    308e:	85ca                	mv	a1,s2
    3090:	00004517          	auipc	a0,0x4
    3094:	83850513          	addi	a0,a0,-1992 # 68c8 <malloc+0x1794>
    3098:	7e3010ef          	jal	ra,507a <printf>
    exit(1);
    309c:	4505                	li	a0,1
    309e:	3b7010ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30a2:	85ca                	mv	a1,s2
    30a4:	00004517          	auipc	a0,0x4
    30a8:	84450513          	addi	a0,a0,-1980 # 68e8 <malloc+0x17b4>
    30ac:	7cf010ef          	jal	ra,507a <printf>
    exit(1);
    30b0:	4505                	li	a0,1
    30b2:	3a3010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30b6:	85ca                	mv	a1,s2
    30b8:	00004517          	auipc	a0,0x4
    30bc:	85850513          	addi	a0,a0,-1960 # 6910 <malloc+0x17dc>
    30c0:	7bb010ef          	jal	ra,507a <printf>
    exit(1);
    30c4:	4505                	li	a0,1
    30c6:	38f010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30ca:	85ca                	mv	a1,s2
    30cc:	00004517          	auipc	a0,0x4
    30d0:	86450513          	addi	a0,a0,-1948 # 6930 <malloc+0x17fc>
    30d4:	7a7010ef          	jal	ra,507a <printf>
    exit(1);
    30d8:	4505                	li	a0,1
    30da:	37b010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30de:	85ca                	mv	a1,s2
    30e0:	00004517          	auipc	a0,0x4
    30e4:	87050513          	addi	a0,a0,-1936 # 6950 <malloc+0x181c>
    30e8:	793010ef          	jal	ra,507a <printf>
    exit(1);
    30ec:	4505                	li	a0,1
    30ee:	367010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30f2:	85ca                	mv	a1,s2
    30f4:	00004517          	auipc	a0,0x4
    30f8:	88450513          	addi	a0,a0,-1916 # 6978 <malloc+0x1844>
    30fc:	77f010ef          	jal	ra,507a <printf>
    exit(1);
    3100:	4505                	li	a0,1
    3102:	353010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3106:	85ca                	mv	a1,s2
    3108:	00003517          	auipc	a0,0x3
    310c:	50050513          	addi	a0,a0,1280 # 6608 <malloc+0x14d4>
    3110:	76b010ef          	jal	ra,507a <printf>
    exit(1);
    3114:	4505                	li	a0,1
    3116:	33f010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    311a:	85ca                	mv	a1,s2
    311c:	00004517          	auipc	a0,0x4
    3120:	87c50513          	addi	a0,a0,-1924 # 6998 <malloc+0x1864>
    3124:	757010ef          	jal	ra,507a <printf>
    exit(1);
    3128:	4505                	li	a0,1
    312a:	32b010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    312e:	85ca                	mv	a1,s2
    3130:	00004517          	auipc	a0,0x4
    3134:	88850513          	addi	a0,a0,-1912 # 69b8 <malloc+0x1884>
    3138:	743010ef          	jal	ra,507a <printf>
    exit(1);
    313c:	4505                	li	a0,1
    313e:	317010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3142:	85ca                	mv	a1,s2
    3144:	00004517          	auipc	a0,0x4
    3148:	8a450513          	addi	a0,a0,-1884 # 69e8 <malloc+0x18b4>
    314c:	72f010ef          	jal	ra,507a <printf>
    exit(1);
    3150:	4505                	li	a0,1
    3152:	303010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dd failed\n", s);
    3156:	85ca                	mv	a1,s2
    3158:	00004517          	auipc	a0,0x4
    315c:	8b050513          	addi	a0,a0,-1872 # 6a08 <malloc+0x18d4>
    3160:	71b010ef          	jal	ra,507a <printf>
    exit(1);
    3164:	4505                	li	a0,1
    3166:	2ef010ef          	jal	ra,4c54 <exit>

000000000000316a <rmdot>:
{
    316a:	1101                	addi	sp,sp,-32
    316c:	ec06                	sd	ra,24(sp)
    316e:	e822                	sd	s0,16(sp)
    3170:	e426                	sd	s1,8(sp)
    3172:	1000                	addi	s0,sp,32
    3174:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3176:	00004517          	auipc	a0,0x4
    317a:	8aa50513          	addi	a0,a0,-1878 # 6a20 <malloc+0x18ec>
    317e:	33f010ef          	jal	ra,4cbc <mkdir>
    3182:	e53d                	bnez	a0,31f0 <rmdot+0x86>
  if(chdir("dots") != 0){
    3184:	00004517          	auipc	a0,0x4
    3188:	89c50513          	addi	a0,a0,-1892 # 6a20 <malloc+0x18ec>
    318c:	339010ef          	jal	ra,4cc4 <chdir>
    3190:	e935                	bnez	a0,3204 <rmdot+0x9a>
  if(unlink(".") == 0){
    3192:	00002517          	auipc	a0,0x2
    3196:	7be50513          	addi	a0,a0,1982 # 5950 <malloc+0x81c>
    319a:	30b010ef          	jal	ra,4ca4 <unlink>
    319e:	cd2d                	beqz	a0,3218 <rmdot+0xae>
  if(unlink("..") == 0){
    31a0:	00003517          	auipc	a0,0x3
    31a4:	2d050513          	addi	a0,a0,720 # 6470 <malloc+0x133c>
    31a8:	2fd010ef          	jal	ra,4ca4 <unlink>
    31ac:	c141                	beqz	a0,322c <rmdot+0xc2>
  if(chdir("/") != 0){
    31ae:	00003517          	auipc	a0,0x3
    31b2:	26a50513          	addi	a0,a0,618 # 6418 <malloc+0x12e4>
    31b6:	30f010ef          	jal	ra,4cc4 <chdir>
    31ba:	e159                	bnez	a0,3240 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    31bc:	00004517          	auipc	a0,0x4
    31c0:	8cc50513          	addi	a0,a0,-1844 # 6a88 <malloc+0x1954>
    31c4:	2e1010ef          	jal	ra,4ca4 <unlink>
    31c8:	c551                	beqz	a0,3254 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    31ca:	00004517          	auipc	a0,0x4
    31ce:	8e650513          	addi	a0,a0,-1818 # 6ab0 <malloc+0x197c>
    31d2:	2d3010ef          	jal	ra,4ca4 <unlink>
    31d6:	c949                	beqz	a0,3268 <rmdot+0xfe>
  if(unlink("dots") != 0){
    31d8:	00004517          	auipc	a0,0x4
    31dc:	84850513          	addi	a0,a0,-1976 # 6a20 <malloc+0x18ec>
    31e0:	2c5010ef          	jal	ra,4ca4 <unlink>
    31e4:	ed41                	bnez	a0,327c <rmdot+0x112>
}
    31e6:	60e2                	ld	ra,24(sp)
    31e8:	6442                	ld	s0,16(sp)
    31ea:	64a2                	ld	s1,8(sp)
    31ec:	6105                	addi	sp,sp,32
    31ee:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31f0:	85a6                	mv	a1,s1
    31f2:	00004517          	auipc	a0,0x4
    31f6:	83650513          	addi	a0,a0,-1994 # 6a28 <malloc+0x18f4>
    31fa:	681010ef          	jal	ra,507a <printf>
    exit(1);
    31fe:	4505                	li	a0,1
    3200:	255010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dots failed\n", s);
    3204:	85a6                	mv	a1,s1
    3206:	00004517          	auipc	a0,0x4
    320a:	83a50513          	addi	a0,a0,-1990 # 6a40 <malloc+0x190c>
    320e:	66d010ef          	jal	ra,507a <printf>
    exit(1);
    3212:	4505                	li	a0,1
    3214:	241010ef          	jal	ra,4c54 <exit>
    printf("%s: rm . worked!\n", s);
    3218:	85a6                	mv	a1,s1
    321a:	00004517          	auipc	a0,0x4
    321e:	83e50513          	addi	a0,a0,-1986 # 6a58 <malloc+0x1924>
    3222:	659010ef          	jal	ra,507a <printf>
    exit(1);
    3226:	4505                	li	a0,1
    3228:	22d010ef          	jal	ra,4c54 <exit>
    printf("%s: rm .. worked!\n", s);
    322c:	85a6                	mv	a1,s1
    322e:	00004517          	auipc	a0,0x4
    3232:	84250513          	addi	a0,a0,-1982 # 6a70 <malloc+0x193c>
    3236:	645010ef          	jal	ra,507a <printf>
    exit(1);
    323a:	4505                	li	a0,1
    323c:	219010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir / failed\n", s);
    3240:	85a6                	mv	a1,s1
    3242:	00003517          	auipc	a0,0x3
    3246:	1de50513          	addi	a0,a0,478 # 6420 <malloc+0x12ec>
    324a:	631010ef          	jal	ra,507a <printf>
    exit(1);
    324e:	4505                	li	a0,1
    3250:	205010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3254:	85a6                	mv	a1,s1
    3256:	00004517          	auipc	a0,0x4
    325a:	83a50513          	addi	a0,a0,-1990 # 6a90 <malloc+0x195c>
    325e:	61d010ef          	jal	ra,507a <printf>
    exit(1);
    3262:	4505                	li	a0,1
    3264:	1f1010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3268:	85a6                	mv	a1,s1
    326a:	00004517          	auipc	a0,0x4
    326e:	84e50513          	addi	a0,a0,-1970 # 6ab8 <malloc+0x1984>
    3272:	609010ef          	jal	ra,507a <printf>
    exit(1);
    3276:	4505                	li	a0,1
    3278:	1dd010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dots failed!\n", s);
    327c:	85a6                	mv	a1,s1
    327e:	00004517          	auipc	a0,0x4
    3282:	85a50513          	addi	a0,a0,-1958 # 6ad8 <malloc+0x19a4>
    3286:	5f5010ef          	jal	ra,507a <printf>
    exit(1);
    328a:	4505                	li	a0,1
    328c:	1c9010ef          	jal	ra,4c54 <exit>

0000000000003290 <dirfile>:
{
    3290:	1101                	addi	sp,sp,-32
    3292:	ec06                	sd	ra,24(sp)
    3294:	e822                	sd	s0,16(sp)
    3296:	e426                	sd	s1,8(sp)
    3298:	e04a                	sd	s2,0(sp)
    329a:	1000                	addi	s0,sp,32
    329c:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    329e:	20000593          	li	a1,512
    32a2:	00004517          	auipc	a0,0x4
    32a6:	85650513          	addi	a0,a0,-1962 # 6af8 <malloc+0x19c4>
    32aa:	1eb010ef          	jal	ra,4c94 <open>
  if(fd < 0){
    32ae:	0c054563          	bltz	a0,3378 <dirfile+0xe8>
  close(fd);
    32b2:	1cb010ef          	jal	ra,4c7c <close>
  if(chdir("dirfile") == 0){
    32b6:	00004517          	auipc	a0,0x4
    32ba:	84250513          	addi	a0,a0,-1982 # 6af8 <malloc+0x19c4>
    32be:	207010ef          	jal	ra,4cc4 <chdir>
    32c2:	c569                	beqz	a0,338c <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32c4:	4581                	li	a1,0
    32c6:	00004517          	auipc	a0,0x4
    32ca:	87a50513          	addi	a0,a0,-1926 # 6b40 <malloc+0x1a0c>
    32ce:	1c7010ef          	jal	ra,4c94 <open>
  if(fd >= 0){
    32d2:	0c055763          	bgez	a0,33a0 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32d6:	20000593          	li	a1,512
    32da:	00004517          	auipc	a0,0x4
    32de:	86650513          	addi	a0,a0,-1946 # 6b40 <malloc+0x1a0c>
    32e2:	1b3010ef          	jal	ra,4c94 <open>
  if(fd >= 0){
    32e6:	0c055763          	bgez	a0,33b4 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    32ea:	00004517          	auipc	a0,0x4
    32ee:	85650513          	addi	a0,a0,-1962 # 6b40 <malloc+0x1a0c>
    32f2:	1cb010ef          	jal	ra,4cbc <mkdir>
    32f6:	0c050963          	beqz	a0,33c8 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    32fa:	00004517          	auipc	a0,0x4
    32fe:	84650513          	addi	a0,a0,-1978 # 6b40 <malloc+0x1a0c>
    3302:	1a3010ef          	jal	ra,4ca4 <unlink>
    3306:	0c050b63          	beqz	a0,33dc <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    330a:	00004597          	auipc	a1,0x4
    330e:	83658593          	addi	a1,a1,-1994 # 6b40 <malloc+0x1a0c>
    3312:	00002517          	auipc	a0,0x2
    3316:	12e50513          	addi	a0,a0,302 # 5440 <malloc+0x30c>
    331a:	19b010ef          	jal	ra,4cb4 <link>
    331e:	0c050963          	beqz	a0,33f0 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3322:	00003517          	auipc	a0,0x3
    3326:	7d650513          	addi	a0,a0,2006 # 6af8 <malloc+0x19c4>
    332a:	17b010ef          	jal	ra,4ca4 <unlink>
    332e:	0c051b63          	bnez	a0,3404 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3332:	4589                	li	a1,2
    3334:	00002517          	auipc	a0,0x2
    3338:	61c50513          	addi	a0,a0,1564 # 5950 <malloc+0x81c>
    333c:	159010ef          	jal	ra,4c94 <open>
  if(fd >= 0){
    3340:	0c055c63          	bgez	a0,3418 <dirfile+0x188>
  fd = open(".", 0);
    3344:	4581                	li	a1,0
    3346:	00002517          	auipc	a0,0x2
    334a:	60a50513          	addi	a0,a0,1546 # 5950 <malloc+0x81c>
    334e:	147010ef          	jal	ra,4c94 <open>
    3352:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3354:	4605                	li	a2,1
    3356:	00002597          	auipc	a1,0x2
    335a:	f8258593          	addi	a1,a1,-126 # 52d8 <malloc+0x1a4>
    335e:	117010ef          	jal	ra,4c74 <write>
    3362:	0ca04563          	bgtz	a0,342c <dirfile+0x19c>
  close(fd);
    3366:	8526                	mv	a0,s1
    3368:	115010ef          	jal	ra,4c7c <close>
}
    336c:	60e2                	ld	ra,24(sp)
    336e:	6442                	ld	s0,16(sp)
    3370:	64a2                	ld	s1,8(sp)
    3372:	6902                	ld	s2,0(sp)
    3374:	6105                	addi	sp,sp,32
    3376:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3378:	85ca                	mv	a1,s2
    337a:	00003517          	auipc	a0,0x3
    337e:	78650513          	addi	a0,a0,1926 # 6b00 <malloc+0x19cc>
    3382:	4f9010ef          	jal	ra,507a <printf>
    exit(1);
    3386:	4505                	li	a0,1
    3388:	0cd010ef          	jal	ra,4c54 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    338c:	85ca                	mv	a1,s2
    338e:	00003517          	auipc	a0,0x3
    3392:	79250513          	addi	a0,a0,1938 # 6b20 <malloc+0x19ec>
    3396:	4e5010ef          	jal	ra,507a <printf>
    exit(1);
    339a:	4505                	li	a0,1
    339c:	0b9010ef          	jal	ra,4c54 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33a0:	85ca                	mv	a1,s2
    33a2:	00003517          	auipc	a0,0x3
    33a6:	7ae50513          	addi	a0,a0,1966 # 6b50 <malloc+0x1a1c>
    33aa:	4d1010ef          	jal	ra,507a <printf>
    exit(1);
    33ae:	4505                	li	a0,1
    33b0:	0a5010ef          	jal	ra,4c54 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33b4:	85ca                	mv	a1,s2
    33b6:	00003517          	auipc	a0,0x3
    33ba:	79a50513          	addi	a0,a0,1946 # 6b50 <malloc+0x1a1c>
    33be:	4bd010ef          	jal	ra,507a <printf>
    exit(1);
    33c2:	4505                	li	a0,1
    33c4:	091010ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33c8:	85ca                	mv	a1,s2
    33ca:	00003517          	auipc	a0,0x3
    33ce:	7ae50513          	addi	a0,a0,1966 # 6b78 <malloc+0x1a44>
    33d2:	4a9010ef          	jal	ra,507a <printf>
    exit(1);
    33d6:	4505                	li	a0,1
    33d8:	07d010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33dc:	85ca                	mv	a1,s2
    33de:	00003517          	auipc	a0,0x3
    33e2:	7c250513          	addi	a0,a0,1986 # 6ba0 <malloc+0x1a6c>
    33e6:	495010ef          	jal	ra,507a <printf>
    exit(1);
    33ea:	4505                	li	a0,1
    33ec:	069010ef          	jal	ra,4c54 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33f0:	85ca                	mv	a1,s2
    33f2:	00003517          	auipc	a0,0x3
    33f6:	7d650513          	addi	a0,a0,2006 # 6bc8 <malloc+0x1a94>
    33fa:	481010ef          	jal	ra,507a <printf>
    exit(1);
    33fe:	4505                	li	a0,1
    3400:	055010ef          	jal	ra,4c54 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3404:	85ca                	mv	a1,s2
    3406:	00003517          	auipc	a0,0x3
    340a:	7ea50513          	addi	a0,a0,2026 # 6bf0 <malloc+0x1abc>
    340e:	46d010ef          	jal	ra,507a <printf>
    exit(1);
    3412:	4505                	li	a0,1
    3414:	041010ef          	jal	ra,4c54 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3418:	85ca                	mv	a1,s2
    341a:	00003517          	auipc	a0,0x3
    341e:	7f650513          	addi	a0,a0,2038 # 6c10 <malloc+0x1adc>
    3422:	459010ef          	jal	ra,507a <printf>
    exit(1);
    3426:	4505                	li	a0,1
    3428:	02d010ef          	jal	ra,4c54 <exit>
    printf("%s: write . succeeded!\n", s);
    342c:	85ca                	mv	a1,s2
    342e:	00004517          	auipc	a0,0x4
    3432:	80a50513          	addi	a0,a0,-2038 # 6c38 <malloc+0x1b04>
    3436:	445010ef          	jal	ra,507a <printf>
    exit(1);
    343a:	4505                	li	a0,1
    343c:	019010ef          	jal	ra,4c54 <exit>

0000000000003440 <iref>:
{
    3440:	7139                	addi	sp,sp,-64
    3442:	fc06                	sd	ra,56(sp)
    3444:	f822                	sd	s0,48(sp)
    3446:	f426                	sd	s1,40(sp)
    3448:	f04a                	sd	s2,32(sp)
    344a:	ec4e                	sd	s3,24(sp)
    344c:	e852                	sd	s4,16(sp)
    344e:	e456                	sd	s5,8(sp)
    3450:	e05a                	sd	s6,0(sp)
    3452:	0080                	addi	s0,sp,64
    3454:	8b2a                	mv	s6,a0
    3456:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    345a:	00003a17          	auipc	s4,0x3
    345e:	7f6a0a13          	addi	s4,s4,2038 # 6c50 <malloc+0x1b1c>
    mkdir("");
    3462:	00003497          	auipc	s1,0x3
    3466:	2f648493          	addi	s1,s1,758 # 6758 <malloc+0x1624>
    link("README", "");
    346a:	00002a97          	auipc	s5,0x2
    346e:	fd6a8a93          	addi	s5,s5,-42 # 5440 <malloc+0x30c>
    fd = open("xx", O_CREATE);
    3472:	00003997          	auipc	s3,0x3
    3476:	6d698993          	addi	s3,s3,1750 # 6b48 <malloc+0x1a14>
    347a:	a835                	j	34b6 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    347c:	85da                	mv	a1,s6
    347e:	00003517          	auipc	a0,0x3
    3482:	7da50513          	addi	a0,a0,2010 # 6c58 <malloc+0x1b24>
    3486:	3f5010ef          	jal	ra,507a <printf>
      exit(1);
    348a:	4505                	li	a0,1
    348c:	7c8010ef          	jal	ra,4c54 <exit>
      printf("%s: chdir irefd failed\n", s);
    3490:	85da                	mv	a1,s6
    3492:	00003517          	auipc	a0,0x3
    3496:	7de50513          	addi	a0,a0,2014 # 6c70 <malloc+0x1b3c>
    349a:	3e1010ef          	jal	ra,507a <printf>
      exit(1);
    349e:	4505                	li	a0,1
    34a0:	7b4010ef          	jal	ra,4c54 <exit>
      close(fd);
    34a4:	7d8010ef          	jal	ra,4c7c <close>
    34a8:	a82d                	j	34e2 <iref+0xa2>
    unlink("xx");
    34aa:	854e                	mv	a0,s3
    34ac:	7f8010ef          	jal	ra,4ca4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34b0:	397d                	addiw	s2,s2,-1
    34b2:	04090263          	beqz	s2,34f6 <iref+0xb6>
    if(mkdir("irefd") != 0){
    34b6:	8552                	mv	a0,s4
    34b8:	005010ef          	jal	ra,4cbc <mkdir>
    34bc:	f161                	bnez	a0,347c <iref+0x3c>
    if(chdir("irefd") != 0){
    34be:	8552                	mv	a0,s4
    34c0:	005010ef          	jal	ra,4cc4 <chdir>
    34c4:	f571                	bnez	a0,3490 <iref+0x50>
    mkdir("");
    34c6:	8526                	mv	a0,s1
    34c8:	7f4010ef          	jal	ra,4cbc <mkdir>
    link("README", "");
    34cc:	85a6                	mv	a1,s1
    34ce:	8556                	mv	a0,s5
    34d0:	7e4010ef          	jal	ra,4cb4 <link>
    fd = open("", O_CREATE);
    34d4:	20000593          	li	a1,512
    34d8:	8526                	mv	a0,s1
    34da:	7ba010ef          	jal	ra,4c94 <open>
    if(fd >= 0)
    34de:	fc0553e3          	bgez	a0,34a4 <iref+0x64>
    fd = open("xx", O_CREATE);
    34e2:	20000593          	li	a1,512
    34e6:	854e                	mv	a0,s3
    34e8:	7ac010ef          	jal	ra,4c94 <open>
    if(fd >= 0)
    34ec:	fa054fe3          	bltz	a0,34aa <iref+0x6a>
      close(fd);
    34f0:	78c010ef          	jal	ra,4c7c <close>
    34f4:	bf5d                	j	34aa <iref+0x6a>
    34f6:	03300493          	li	s1,51
    chdir("..");
    34fa:	00003997          	auipc	s3,0x3
    34fe:	f7698993          	addi	s3,s3,-138 # 6470 <malloc+0x133c>
    unlink("irefd");
    3502:	00003917          	auipc	s2,0x3
    3506:	74e90913          	addi	s2,s2,1870 # 6c50 <malloc+0x1b1c>
    chdir("..");
    350a:	854e                	mv	a0,s3
    350c:	7b8010ef          	jal	ra,4cc4 <chdir>
    unlink("irefd");
    3510:	854a                	mv	a0,s2
    3512:	792010ef          	jal	ra,4ca4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3516:	34fd                	addiw	s1,s1,-1
    3518:	f8ed                	bnez	s1,350a <iref+0xca>
  chdir("/");
    351a:	00003517          	auipc	a0,0x3
    351e:	efe50513          	addi	a0,a0,-258 # 6418 <malloc+0x12e4>
    3522:	7a2010ef          	jal	ra,4cc4 <chdir>
}
    3526:	70e2                	ld	ra,56(sp)
    3528:	7442                	ld	s0,48(sp)
    352a:	74a2                	ld	s1,40(sp)
    352c:	7902                	ld	s2,32(sp)
    352e:	69e2                	ld	s3,24(sp)
    3530:	6a42                	ld	s4,16(sp)
    3532:	6aa2                	ld	s5,8(sp)
    3534:	6b02                	ld	s6,0(sp)
    3536:	6121                	addi	sp,sp,64
    3538:	8082                	ret

000000000000353a <openiputtest>:
{
    353a:	7179                	addi	sp,sp,-48
    353c:	f406                	sd	ra,40(sp)
    353e:	f022                	sd	s0,32(sp)
    3540:	ec26                	sd	s1,24(sp)
    3542:	1800                	addi	s0,sp,48
    3544:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3546:	00003517          	auipc	a0,0x3
    354a:	74250513          	addi	a0,a0,1858 # 6c88 <malloc+0x1b54>
    354e:	76e010ef          	jal	ra,4cbc <mkdir>
    3552:	02054a63          	bltz	a0,3586 <openiputtest+0x4c>
  pid = fork();
    3556:	6f6010ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    355a:	04054063          	bltz	a0,359a <openiputtest+0x60>
  if(pid == 0){
    355e:	e939                	bnez	a0,35b4 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3560:	4589                	li	a1,2
    3562:	00003517          	auipc	a0,0x3
    3566:	72650513          	addi	a0,a0,1830 # 6c88 <malloc+0x1b54>
    356a:	72a010ef          	jal	ra,4c94 <open>
    if(fd >= 0){
    356e:	04054063          	bltz	a0,35ae <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3572:	85a6                	mv	a1,s1
    3574:	00003517          	auipc	a0,0x3
    3578:	73450513          	addi	a0,a0,1844 # 6ca8 <malloc+0x1b74>
    357c:	2ff010ef          	jal	ra,507a <printf>
      exit(1);
    3580:	4505                	li	a0,1
    3582:	6d2010ef          	jal	ra,4c54 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3586:	85a6                	mv	a1,s1
    3588:	00003517          	auipc	a0,0x3
    358c:	70850513          	addi	a0,a0,1800 # 6c90 <malloc+0x1b5c>
    3590:	2eb010ef          	jal	ra,507a <printf>
    exit(1);
    3594:	4505                	li	a0,1
    3596:	6be010ef          	jal	ra,4c54 <exit>
    printf("%s: fork failed\n", s);
    359a:	85a6                	mv	a1,s1
    359c:	00002517          	auipc	a0,0x2
    35a0:	55c50513          	addi	a0,a0,1372 # 5af8 <malloc+0x9c4>
    35a4:	2d7010ef          	jal	ra,507a <printf>
    exit(1);
    35a8:	4505                	li	a0,1
    35aa:	6aa010ef          	jal	ra,4c54 <exit>
    exit(0);
    35ae:	4501                	li	a0,0
    35b0:	6a4010ef          	jal	ra,4c54 <exit>
  pause(1);
    35b4:	4505                	li	a0,1
    35b6:	72e010ef          	jal	ra,4ce4 <pause>
  if(unlink("oidir") != 0){
    35ba:	00003517          	auipc	a0,0x3
    35be:	6ce50513          	addi	a0,a0,1742 # 6c88 <malloc+0x1b54>
    35c2:	6e2010ef          	jal	ra,4ca4 <unlink>
    35c6:	c919                	beqz	a0,35dc <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35c8:	85a6                	mv	a1,s1
    35ca:	00002517          	auipc	a0,0x2
    35ce:	71e50513          	addi	a0,a0,1822 # 5ce8 <malloc+0xbb4>
    35d2:	2a9010ef          	jal	ra,507a <printf>
    exit(1);
    35d6:	4505                	li	a0,1
    35d8:	67c010ef          	jal	ra,4c54 <exit>
  wait(&xstatus);
    35dc:	fdc40513          	addi	a0,s0,-36
    35e0:	67c010ef          	jal	ra,4c5c <wait>
  exit(xstatus);
    35e4:	fdc42503          	lw	a0,-36(s0)
    35e8:	66c010ef          	jal	ra,4c54 <exit>

00000000000035ec <forkforkfork>:
{
    35ec:	1101                	addi	sp,sp,-32
    35ee:	ec06                	sd	ra,24(sp)
    35f0:	e822                	sd	s0,16(sp)
    35f2:	e426                	sd	s1,8(sp)
    35f4:	1000                	addi	s0,sp,32
    35f6:	84aa                	mv	s1,a0
  unlink("stopforking");
    35f8:	00003517          	auipc	a0,0x3
    35fc:	6d850513          	addi	a0,a0,1752 # 6cd0 <malloc+0x1b9c>
    3600:	6a4010ef          	jal	ra,4ca4 <unlink>
  int pid = fork();
    3604:	648010ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    3608:	02054b63          	bltz	a0,363e <forkforkfork+0x52>
  if(pid == 0){
    360c:	c139                	beqz	a0,3652 <forkforkfork+0x66>
  pause(20); // two seconds
    360e:	4551                	li	a0,20
    3610:	6d4010ef          	jal	ra,4ce4 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    3614:	20200593          	li	a1,514
    3618:	00003517          	auipc	a0,0x3
    361c:	6b850513          	addi	a0,a0,1720 # 6cd0 <malloc+0x1b9c>
    3620:	674010ef          	jal	ra,4c94 <open>
    3624:	658010ef          	jal	ra,4c7c <close>
  wait(0);
    3628:	4501                	li	a0,0
    362a:	632010ef          	jal	ra,4c5c <wait>
  pause(10); // one second
    362e:	4529                	li	a0,10
    3630:	6b4010ef          	jal	ra,4ce4 <pause>
}
    3634:	60e2                	ld	ra,24(sp)
    3636:	6442                	ld	s0,16(sp)
    3638:	64a2                	ld	s1,8(sp)
    363a:	6105                	addi	sp,sp,32
    363c:	8082                	ret
    printf("%s: fork failed", s);
    363e:	85a6                	mv	a1,s1
    3640:	00002517          	auipc	a0,0x2
    3644:	67850513          	addi	a0,a0,1656 # 5cb8 <malloc+0xb84>
    3648:	233010ef          	jal	ra,507a <printf>
    exit(1);
    364c:	4505                	li	a0,1
    364e:	606010ef          	jal	ra,4c54 <exit>
      int fd = open("stopforking", 0);
    3652:	00003497          	auipc	s1,0x3
    3656:	67e48493          	addi	s1,s1,1662 # 6cd0 <malloc+0x1b9c>
    365a:	4581                	li	a1,0
    365c:	8526                	mv	a0,s1
    365e:	636010ef          	jal	ra,4c94 <open>
      if(fd >= 0){
    3662:	00055e63          	bgez	a0,367e <forkforkfork+0x92>
      if(fork() < 0){
    3666:	5e6010ef          	jal	ra,4c4c <fork>
    366a:	fe0558e3          	bgez	a0,365a <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    366e:	20200593          	li	a1,514
    3672:	8526                	mv	a0,s1
    3674:	620010ef          	jal	ra,4c94 <open>
    3678:	604010ef          	jal	ra,4c7c <close>
    367c:	bff9                	j	365a <forkforkfork+0x6e>
        exit(0);
    367e:	4501                	li	a0,0
    3680:	5d4010ef          	jal	ra,4c54 <exit>

0000000000003684 <killstatus>:
{
    3684:	7139                	addi	sp,sp,-64
    3686:	fc06                	sd	ra,56(sp)
    3688:	f822                	sd	s0,48(sp)
    368a:	f426                	sd	s1,40(sp)
    368c:	f04a                	sd	s2,32(sp)
    368e:	ec4e                	sd	s3,24(sp)
    3690:	e852                	sd	s4,16(sp)
    3692:	0080                	addi	s0,sp,64
    3694:	8a2a                	mv	s4,a0
    3696:	06400913          	li	s2,100
    if(xst != -1) {
    369a:	59fd                	li	s3,-1
    int pid1 = fork();
    369c:	5b0010ef          	jal	ra,4c4c <fork>
    36a0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36a2:	02054763          	bltz	a0,36d0 <killstatus+0x4c>
    if(pid1 == 0){
    36a6:	cd1d                	beqz	a0,36e4 <killstatus+0x60>
    pause(1);
    36a8:	4505                	li	a0,1
    36aa:	63a010ef          	jal	ra,4ce4 <pause>
    kill(pid1);
    36ae:	8526                	mv	a0,s1
    36b0:	5d4010ef          	jal	ra,4c84 <kill>
    wait(&xst);
    36b4:	fcc40513          	addi	a0,s0,-52
    36b8:	5a4010ef          	jal	ra,4c5c <wait>
    if(xst != -1) {
    36bc:	fcc42783          	lw	a5,-52(s0)
    36c0:	03379563          	bne	a5,s3,36ea <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    36c4:	397d                	addiw	s2,s2,-1
    36c6:	fc091be3          	bnez	s2,369c <killstatus+0x18>
  exit(0);
    36ca:	4501                	li	a0,0
    36cc:	588010ef          	jal	ra,4c54 <exit>
      printf("%s: fork failed\n", s);
    36d0:	85d2                	mv	a1,s4
    36d2:	00002517          	auipc	a0,0x2
    36d6:	42650513          	addi	a0,a0,1062 # 5af8 <malloc+0x9c4>
    36da:	1a1010ef          	jal	ra,507a <printf>
      exit(1);
    36de:	4505                	li	a0,1
    36e0:	574010ef          	jal	ra,4c54 <exit>
        getpid();
    36e4:	5f0010ef          	jal	ra,4cd4 <getpid>
      while(1) {
    36e8:	bff5                	j	36e4 <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    36ea:	85d2                	mv	a1,s4
    36ec:	00003517          	auipc	a0,0x3
    36f0:	5f450513          	addi	a0,a0,1524 # 6ce0 <malloc+0x1bac>
    36f4:	187010ef          	jal	ra,507a <printf>
       exit(1);
    36f8:	4505                	li	a0,1
    36fa:	55a010ef          	jal	ra,4c54 <exit>

00000000000036fe <preempt>:
{
    36fe:	7139                	addi	sp,sp,-64
    3700:	fc06                	sd	ra,56(sp)
    3702:	f822                	sd	s0,48(sp)
    3704:	f426                	sd	s1,40(sp)
    3706:	f04a                	sd	s2,32(sp)
    3708:	ec4e                	sd	s3,24(sp)
    370a:	e852                	sd	s4,16(sp)
    370c:	0080                	addi	s0,sp,64
    370e:	84aa                	mv	s1,a0
  pid1 = fork();
    3710:	53c010ef          	jal	ra,4c4c <fork>
  if(pid1 < 0) {
    3714:	00054563          	bltz	a0,371e <preempt+0x20>
    3718:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    371a:	ed01                	bnez	a0,3732 <preempt+0x34>
    for(;;)
    371c:	a001                	j	371c <preempt+0x1e>
    printf("%s: fork failed", s);
    371e:	85a6                	mv	a1,s1
    3720:	00002517          	auipc	a0,0x2
    3724:	59850513          	addi	a0,a0,1432 # 5cb8 <malloc+0xb84>
    3728:	153010ef          	jal	ra,507a <printf>
    exit(1);
    372c:	4505                	li	a0,1
    372e:	526010ef          	jal	ra,4c54 <exit>
  pid2 = fork();
    3732:	51a010ef          	jal	ra,4c4c <fork>
    3736:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3738:	00054463          	bltz	a0,3740 <preempt+0x42>
  if(pid2 == 0)
    373c:	ed01                	bnez	a0,3754 <preempt+0x56>
    for(;;)
    373e:	a001                	j	373e <preempt+0x40>
    printf("%s: fork failed\n", s);
    3740:	85a6                	mv	a1,s1
    3742:	00002517          	auipc	a0,0x2
    3746:	3b650513          	addi	a0,a0,950 # 5af8 <malloc+0x9c4>
    374a:	131010ef          	jal	ra,507a <printf>
    exit(1);
    374e:	4505                	li	a0,1
    3750:	504010ef          	jal	ra,4c54 <exit>
  pipe(pfds);
    3754:	fc840513          	addi	a0,s0,-56
    3758:	50c010ef          	jal	ra,4c64 <pipe>
  pid3 = fork();
    375c:	4f0010ef          	jal	ra,4c4c <fork>
    3760:	892a                	mv	s2,a0
  if(pid3 < 0) {
    3762:	02054863          	bltz	a0,3792 <preempt+0x94>
  if(pid3 == 0){
    3766:	e921                	bnez	a0,37b6 <preempt+0xb8>
    close(pfds[0]);
    3768:	fc842503          	lw	a0,-56(s0)
    376c:	510010ef          	jal	ra,4c7c <close>
    if(write(pfds[1], "x", 1) != 1)
    3770:	4605                	li	a2,1
    3772:	00002597          	auipc	a1,0x2
    3776:	b6658593          	addi	a1,a1,-1178 # 52d8 <malloc+0x1a4>
    377a:	fcc42503          	lw	a0,-52(s0)
    377e:	4f6010ef          	jal	ra,4c74 <write>
    3782:	4785                	li	a5,1
    3784:	02f51163          	bne	a0,a5,37a6 <preempt+0xa8>
    close(pfds[1]);
    3788:	fcc42503          	lw	a0,-52(s0)
    378c:	4f0010ef          	jal	ra,4c7c <close>
    for(;;)
    3790:	a001                	j	3790 <preempt+0x92>
     printf("%s: fork failed\n", s);
    3792:	85a6                	mv	a1,s1
    3794:	00002517          	auipc	a0,0x2
    3798:	36450513          	addi	a0,a0,868 # 5af8 <malloc+0x9c4>
    379c:	0df010ef          	jal	ra,507a <printf>
     exit(1);
    37a0:	4505                	li	a0,1
    37a2:	4b2010ef          	jal	ra,4c54 <exit>
      printf("%s: preempt write error", s);
    37a6:	85a6                	mv	a1,s1
    37a8:	00003517          	auipc	a0,0x3
    37ac:	55850513          	addi	a0,a0,1368 # 6d00 <malloc+0x1bcc>
    37b0:	0cb010ef          	jal	ra,507a <printf>
    37b4:	bfd1                	j	3788 <preempt+0x8a>
  close(pfds[1]);
    37b6:	fcc42503          	lw	a0,-52(s0)
    37ba:	4c2010ef          	jal	ra,4c7c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    37be:	660d                	lui	a2,0x3
    37c0:	00008597          	auipc	a1,0x8
    37c4:	4e858593          	addi	a1,a1,1256 # bca8 <buf>
    37c8:	fc842503          	lw	a0,-56(s0)
    37cc:	4a0010ef          	jal	ra,4c6c <read>
    37d0:	4785                	li	a5,1
    37d2:	02f50163          	beq	a0,a5,37f4 <preempt+0xf6>
    printf("%s: preempt read error", s);
    37d6:	85a6                	mv	a1,s1
    37d8:	00003517          	auipc	a0,0x3
    37dc:	54050513          	addi	a0,a0,1344 # 6d18 <malloc+0x1be4>
    37e0:	09b010ef          	jal	ra,507a <printf>
}
    37e4:	70e2                	ld	ra,56(sp)
    37e6:	7442                	ld	s0,48(sp)
    37e8:	74a2                	ld	s1,40(sp)
    37ea:	7902                	ld	s2,32(sp)
    37ec:	69e2                	ld	s3,24(sp)
    37ee:	6a42                	ld	s4,16(sp)
    37f0:	6121                	addi	sp,sp,64
    37f2:	8082                	ret
  close(pfds[0]);
    37f4:	fc842503          	lw	a0,-56(s0)
    37f8:	484010ef          	jal	ra,4c7c <close>
  printf("kill... ");
    37fc:	00003517          	auipc	a0,0x3
    3800:	53450513          	addi	a0,a0,1332 # 6d30 <malloc+0x1bfc>
    3804:	077010ef          	jal	ra,507a <printf>
  kill(pid1);
    3808:	8552                	mv	a0,s4
    380a:	47a010ef          	jal	ra,4c84 <kill>
  kill(pid2);
    380e:	854e                	mv	a0,s3
    3810:	474010ef          	jal	ra,4c84 <kill>
  kill(pid3);
    3814:	854a                	mv	a0,s2
    3816:	46e010ef          	jal	ra,4c84 <kill>
  printf("wait... ");
    381a:	00003517          	auipc	a0,0x3
    381e:	52650513          	addi	a0,a0,1318 # 6d40 <malloc+0x1c0c>
    3822:	059010ef          	jal	ra,507a <printf>
  wait(0);
    3826:	4501                	li	a0,0
    3828:	434010ef          	jal	ra,4c5c <wait>
  wait(0);
    382c:	4501                	li	a0,0
    382e:	42e010ef          	jal	ra,4c5c <wait>
  wait(0);
    3832:	4501                	li	a0,0
    3834:	428010ef          	jal	ra,4c5c <wait>
    3838:	b775                	j	37e4 <preempt+0xe6>

000000000000383a <reparent>:
{
    383a:	7179                	addi	sp,sp,-48
    383c:	f406                	sd	ra,40(sp)
    383e:	f022                	sd	s0,32(sp)
    3840:	ec26                	sd	s1,24(sp)
    3842:	e84a                	sd	s2,16(sp)
    3844:	e44e                	sd	s3,8(sp)
    3846:	e052                	sd	s4,0(sp)
    3848:	1800                	addi	s0,sp,48
    384a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    384c:	488010ef          	jal	ra,4cd4 <getpid>
    3850:	8a2a                	mv	s4,a0
    3852:	0c800913          	li	s2,200
    int pid = fork();
    3856:	3f6010ef          	jal	ra,4c4c <fork>
    385a:	84aa                	mv	s1,a0
    if(pid < 0){
    385c:	00054e63          	bltz	a0,3878 <reparent+0x3e>
    if(pid){
    3860:	c121                	beqz	a0,38a0 <reparent+0x66>
      if(wait(0) != pid){
    3862:	4501                	li	a0,0
    3864:	3f8010ef          	jal	ra,4c5c <wait>
    3868:	02951263          	bne	a0,s1,388c <reparent+0x52>
  for(int i = 0; i < 200; i++){
    386c:	397d                	addiw	s2,s2,-1
    386e:	fe0914e3          	bnez	s2,3856 <reparent+0x1c>
  exit(0);
    3872:	4501                	li	a0,0
    3874:	3e0010ef          	jal	ra,4c54 <exit>
      printf("%s: fork failed\n", s);
    3878:	85ce                	mv	a1,s3
    387a:	00002517          	auipc	a0,0x2
    387e:	27e50513          	addi	a0,a0,638 # 5af8 <malloc+0x9c4>
    3882:	7f8010ef          	jal	ra,507a <printf>
      exit(1);
    3886:	4505                	li	a0,1
    3888:	3cc010ef          	jal	ra,4c54 <exit>
        printf("%s: wait wrong pid\n", s);
    388c:	85ce                	mv	a1,s3
    388e:	00002517          	auipc	a0,0x2
    3892:	3f250513          	addi	a0,a0,1010 # 5c80 <malloc+0xb4c>
    3896:	7e4010ef          	jal	ra,507a <printf>
        exit(1);
    389a:	4505                	li	a0,1
    389c:	3b8010ef          	jal	ra,4c54 <exit>
      int pid2 = fork();
    38a0:	3ac010ef          	jal	ra,4c4c <fork>
      if(pid2 < 0){
    38a4:	00054563          	bltz	a0,38ae <reparent+0x74>
      exit(0);
    38a8:	4501                	li	a0,0
    38aa:	3aa010ef          	jal	ra,4c54 <exit>
        kill(master_pid);
    38ae:	8552                	mv	a0,s4
    38b0:	3d4010ef          	jal	ra,4c84 <kill>
        exit(1);
    38b4:	4505                	li	a0,1
    38b6:	39e010ef          	jal	ra,4c54 <exit>

00000000000038ba <sbrkfail>:
{
    38ba:	7175                	addi	sp,sp,-144
    38bc:	e506                	sd	ra,136(sp)
    38be:	e122                	sd	s0,128(sp)
    38c0:	fca6                	sd	s1,120(sp)
    38c2:	f8ca                	sd	s2,112(sp)
    38c4:	f4ce                	sd	s3,104(sp)
    38c6:	f0d2                	sd	s4,96(sp)
    38c8:	ecd6                	sd	s5,88(sp)
    38ca:	e8da                	sd	s6,80(sp)
    38cc:	e4de                	sd	s7,72(sp)
    38ce:	0900                	addi	s0,sp,144
    38d0:	84aa                	mv	s1,a0
  if(pipe(fds) != 0){
    38d2:	fa040513          	addi	a0,s0,-96
    38d6:	38e010ef          	jal	ra,4c64 <pipe>
    38da:	e919                	bnez	a0,38f0 <sbrkfail+0x36>
    38dc:	89aa                	mv	s3,a0
    38de:	f7040913          	addi	s2,s0,-144
    38e2:	f9840a93          	addi	s5,s0,-104
    38e6:	8a4a                	mv	s4,s2
    if(pids[i] != -1) {
    38e8:	5bfd                	li	s7,-1
      if(scratch == '0')
    38ea:	03000b13          	li	s6,48
    38ee:	a095                	j	3952 <sbrkfail+0x98>
    printf("%s: pipe() failed\n", s);
    38f0:	85a6                	mv	a1,s1
    38f2:	00002517          	auipc	a0,0x2
    38f6:	30e50513          	addi	a0,a0,782 # 5c00 <malloc+0xacc>
    38fa:	780010ef          	jal	ra,507a <printf>
    exit(1);
    38fe:	4505                	li	a0,1
    3900:	354010ef          	jal	ra,4c54 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3904:	4501                	li	a0,0
    3906:	31a010ef          	jal	ra,4c20 <sbrk>
    390a:	064007b7          	lui	a5,0x6400
    390e:	40a7853b          	subw	a0,a5,a0
    3912:	30e010ef          	jal	ra,4c20 <sbrk>
    3916:	57fd                	li	a5,-1
    3918:	02f50063          	beq	a0,a5,3938 <sbrkfail+0x7e>
        write(fds[1], "1", 1);
    391c:	4605                	li	a2,1
    391e:	00004597          	auipc	a1,0x4
    3922:	aa258593          	addi	a1,a1,-1374 # 73c0 <malloc+0x228c>
    3926:	fa442503          	lw	a0,-92(s0)
    392a:	34a010ef          	jal	ra,4c74 <write>
      for(;;) pause(1000);
    392e:	3e800513          	li	a0,1000
    3932:	3b2010ef          	jal	ra,4ce4 <pause>
    3936:	bfe5                	j	392e <sbrkfail+0x74>
        write(fds[1], "0", 1);
    3938:	4605                	li	a2,1
    393a:	00003597          	auipc	a1,0x3
    393e:	41658593          	addi	a1,a1,1046 # 6d50 <malloc+0x1c1c>
    3942:	fa442503          	lw	a0,-92(s0)
    3946:	32e010ef          	jal	ra,4c74 <write>
    394a:	b7d5                	j	392e <sbrkfail+0x74>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    394c:	0a11                	addi	s4,s4,4
    394e:	035a0663          	beq	s4,s5,397a <sbrkfail+0xc0>
    if((pids[i] = fork()) == 0){
    3952:	2fa010ef          	jal	ra,4c4c <fork>
    3956:	00aa2023          	sw	a0,0(s4)
    395a:	d54d                	beqz	a0,3904 <sbrkfail+0x4a>
    if(pids[i] != -1) {
    395c:	ff7508e3          	beq	a0,s7,394c <sbrkfail+0x92>
      read(fds[0], &scratch, 1);
    3960:	4605                	li	a2,1
    3962:	f9f40593          	addi	a1,s0,-97
    3966:	fa042503          	lw	a0,-96(s0)
    396a:	302010ef          	jal	ra,4c6c <read>
      if(scratch == '0')
    396e:	f9f44783          	lbu	a5,-97(s0)
    3972:	fd679de3          	bne	a5,s6,394c <sbrkfail+0x92>
        failed = 1;
    3976:	4985                	li	s3,1
    3978:	bfd1                	j	394c <sbrkfail+0x92>
  if(!failed) {
    397a:	00098863          	beqz	s3,398a <sbrkfail+0xd0>
  c = sbrk(PGSIZE);
    397e:	6505                	lui	a0,0x1
    3980:	2a0010ef          	jal	ra,4c20 <sbrk>
    3984:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    3986:	5a7d                	li	s4,-1
    3988:	a821                	j	39a0 <sbrkfail+0xe6>
    printf("%s: no allocation failed; allocate more?\n", s);
    398a:	85a6                	mv	a1,s1
    398c:	00003517          	auipc	a0,0x3
    3990:	3cc50513          	addi	a0,a0,972 # 6d58 <malloc+0x1c24>
    3994:	6e6010ef          	jal	ra,507a <printf>
    3998:	b7dd                	j	397e <sbrkfail+0xc4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    399a:	0911                	addi	s2,s2,4
    399c:	01590c63          	beq	s2,s5,39b4 <sbrkfail+0xfa>
    if(pids[i] == -1)
    39a0:	00092503          	lw	a0,0(s2)
    39a4:	ff450be3          	beq	a0,s4,399a <sbrkfail+0xe0>
    kill(pids[i]);
    39a8:	2dc010ef          	jal	ra,4c84 <kill>
    wait(0);
    39ac:	4501                	li	a0,0
    39ae:	2ae010ef          	jal	ra,4c5c <wait>
    39b2:	b7e5                	j	399a <sbrkfail+0xe0>
  if(c == (char*)SBRK_ERROR){
    39b4:	57fd                	li	a5,-1
    39b6:	02f98a63          	beq	s3,a5,39ea <sbrkfail+0x130>
  pid = fork();
    39ba:	292010ef          	jal	ra,4c4c <fork>
  if(pid < 0){
    39be:	04054063          	bltz	a0,39fe <sbrkfail+0x144>
  if(pid == 0){
    39c2:	e939                	bnez	a0,3a18 <sbrkfail+0x15e>
    a = sbrk(10*BIG);
    39c4:	3e800537          	lui	a0,0x3e800
    39c8:	258010ef          	jal	ra,4c20 <sbrk>
    if(a == (char*)SBRK_ERROR){
    39cc:	57fd                	li	a5,-1
    39ce:	04f50263          	beq	a0,a5,3a12 <sbrkfail+0x158>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    39d2:	3e800637          	lui	a2,0x3e800
    39d6:	85a6                	mv	a1,s1
    39d8:	00003517          	auipc	a0,0x3
    39dc:	3d050513          	addi	a0,a0,976 # 6da8 <malloc+0x1c74>
    39e0:	69a010ef          	jal	ra,507a <printf>
    exit(1);
    39e4:	4505                	li	a0,1
    39e6:	26e010ef          	jal	ra,4c54 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    39ea:	85a6                	mv	a1,s1
    39ec:	00003517          	auipc	a0,0x3
    39f0:	39c50513          	addi	a0,a0,924 # 6d88 <malloc+0x1c54>
    39f4:	686010ef          	jal	ra,507a <printf>
    exit(1);
    39f8:	4505                	li	a0,1
    39fa:	25a010ef          	jal	ra,4c54 <exit>
    printf("%s: fork failed\n", s);
    39fe:	85a6                	mv	a1,s1
    3a00:	00002517          	auipc	a0,0x2
    3a04:	0f850513          	addi	a0,a0,248 # 5af8 <malloc+0x9c4>
    3a08:	672010ef          	jal	ra,507a <printf>
    exit(1);
    3a0c:	4505                	li	a0,1
    3a0e:	246010ef          	jal	ra,4c54 <exit>
      exit(0);
    3a12:	4501                	li	a0,0
    3a14:	240010ef          	jal	ra,4c54 <exit>
  wait(&xstatus);
    3a18:	fac40513          	addi	a0,s0,-84
    3a1c:	240010ef          	jal	ra,4c5c <wait>
  if(xstatus != 0)
    3a20:	fac42783          	lw	a5,-84(s0)
    3a24:	ef81                	bnez	a5,3a3c <sbrkfail+0x182>
}
    3a26:	60aa                	ld	ra,136(sp)
    3a28:	640a                	ld	s0,128(sp)
    3a2a:	74e6                	ld	s1,120(sp)
    3a2c:	7946                	ld	s2,112(sp)
    3a2e:	79a6                	ld	s3,104(sp)
    3a30:	7a06                	ld	s4,96(sp)
    3a32:	6ae6                	ld	s5,88(sp)
    3a34:	6b46                	ld	s6,80(sp)
    3a36:	6ba6                	ld	s7,72(sp)
    3a38:	6149                	addi	sp,sp,144
    3a3a:	8082                	ret
    exit(1);
    3a3c:	4505                	li	a0,1
    3a3e:	216010ef          	jal	ra,4c54 <exit>

0000000000003a42 <mem>:
{
    3a42:	7139                	addi	sp,sp,-64
    3a44:	fc06                	sd	ra,56(sp)
    3a46:	f822                	sd	s0,48(sp)
    3a48:	f426                	sd	s1,40(sp)
    3a4a:	f04a                	sd	s2,32(sp)
    3a4c:	ec4e                	sd	s3,24(sp)
    3a4e:	0080                	addi	s0,sp,64
    3a50:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a52:	1fa010ef          	jal	ra,4c4c <fork>
    m1 = 0;
    3a56:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a58:	6909                	lui	s2,0x2
    3a5a:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xdd>
  if((pid = fork()) == 0){
    3a5e:	e129                	bnez	a0,3aa0 <mem+0x5e>
    while((m2 = malloc(10001)) != 0){
    3a60:	854a                	mv	a0,s2
    3a62:	6d2010ef          	jal	ra,5134 <malloc>
    3a66:	c501                	beqz	a0,3a6e <mem+0x2c>
      *(char**)m2 = m1;
    3a68:	e104                	sd	s1,0(a0)
      m1 = m2;
    3a6a:	84aa                	mv	s1,a0
    3a6c:	bfd5                	j	3a60 <mem+0x1e>
    while(m1){
    3a6e:	c491                	beqz	s1,3a7a <mem+0x38>
      m2 = *(char**)m1;
    3a70:	8526                	mv	a0,s1
    3a72:	6084                	ld	s1,0(s1)
      free(m1);
    3a74:	638010ef          	jal	ra,50ac <free>
    while(m1){
    3a78:	fce5                	bnez	s1,3a70 <mem+0x2e>
    m1 = malloc(1024*20);
    3a7a:	6515                	lui	a0,0x5
    3a7c:	6b8010ef          	jal	ra,5134 <malloc>
    if(m1 == 0){
    3a80:	c511                	beqz	a0,3a8c <mem+0x4a>
    free(m1);
    3a82:	62a010ef          	jal	ra,50ac <free>
    exit(0);
    3a86:	4501                	li	a0,0
    3a88:	1cc010ef          	jal	ra,4c54 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3a8c:	85ce                	mv	a1,s3
    3a8e:	00003517          	auipc	a0,0x3
    3a92:	34a50513          	addi	a0,a0,842 # 6dd8 <malloc+0x1ca4>
    3a96:	5e4010ef          	jal	ra,507a <printf>
      exit(1);
    3a9a:	4505                	li	a0,1
    3a9c:	1b8010ef          	jal	ra,4c54 <exit>
    wait(&xstatus);
    3aa0:	fcc40513          	addi	a0,s0,-52
    3aa4:	1b8010ef          	jal	ra,4c5c <wait>
    if(xstatus == -1){
    3aa8:	fcc42503          	lw	a0,-52(s0)
    3aac:	57fd                	li	a5,-1
    3aae:	00f50463          	beq	a0,a5,3ab6 <mem+0x74>
    exit(xstatus);
    3ab2:	1a2010ef          	jal	ra,4c54 <exit>
      exit(0);
    3ab6:	4501                	li	a0,0
    3ab8:	19c010ef          	jal	ra,4c54 <exit>

0000000000003abc <sharedfd>:
{
    3abc:	7159                	addi	sp,sp,-112
    3abe:	f486                	sd	ra,104(sp)
    3ac0:	f0a2                	sd	s0,96(sp)
    3ac2:	eca6                	sd	s1,88(sp)
    3ac4:	e8ca                	sd	s2,80(sp)
    3ac6:	e4ce                	sd	s3,72(sp)
    3ac8:	e0d2                	sd	s4,64(sp)
    3aca:	fc56                	sd	s5,56(sp)
    3acc:	f85a                	sd	s6,48(sp)
    3ace:	f45e                	sd	s7,40(sp)
    3ad0:	1880                	addi	s0,sp,112
    3ad2:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3ad4:	00003517          	auipc	a0,0x3
    3ad8:	32450513          	addi	a0,a0,804 # 6df8 <malloc+0x1cc4>
    3adc:	1c8010ef          	jal	ra,4ca4 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3ae0:	20200593          	li	a1,514
    3ae4:	00003517          	auipc	a0,0x3
    3ae8:	31450513          	addi	a0,a0,788 # 6df8 <malloc+0x1cc4>
    3aec:	1a8010ef          	jal	ra,4c94 <open>
  if(fd < 0){
    3af0:	04054263          	bltz	a0,3b34 <sharedfd+0x78>
    3af4:	892a                	mv	s2,a0
  pid = fork();
    3af6:	156010ef          	jal	ra,4c4c <fork>
    3afa:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3afc:	06300593          	li	a1,99
    3b00:	c119                	beqz	a0,3b06 <sharedfd+0x4a>
    3b02:	07000593          	li	a1,112
    3b06:	4629                	li	a2,10
    3b08:	fa040513          	addi	a0,s0,-96
    3b0c:	72d000ef          	jal	ra,4a38 <memset>
    3b10:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b14:	4629                	li	a2,10
    3b16:	fa040593          	addi	a1,s0,-96
    3b1a:	854a                	mv	a0,s2
    3b1c:	158010ef          	jal	ra,4c74 <write>
    3b20:	47a9                	li	a5,10
    3b22:	02f51363          	bne	a0,a5,3b48 <sharedfd+0x8c>
  for(i = 0; i < N; i++){
    3b26:	34fd                	addiw	s1,s1,-1
    3b28:	f4f5                	bnez	s1,3b14 <sharedfd+0x58>
  if(pid == 0) {
    3b2a:	02099963          	bnez	s3,3b5c <sharedfd+0xa0>
    exit(0);
    3b2e:	4501                	li	a0,0
    3b30:	124010ef          	jal	ra,4c54 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3b34:	85d2                	mv	a1,s4
    3b36:	00003517          	auipc	a0,0x3
    3b3a:	2d250513          	addi	a0,a0,722 # 6e08 <malloc+0x1cd4>
    3b3e:	53c010ef          	jal	ra,507a <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	110010ef          	jal	ra,4c54 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b48:	85d2                	mv	a1,s4
    3b4a:	00003517          	auipc	a0,0x3
    3b4e:	2e650513          	addi	a0,a0,742 # 6e30 <malloc+0x1cfc>
    3b52:	528010ef          	jal	ra,507a <printf>
      exit(1);
    3b56:	4505                	li	a0,1
    3b58:	0fc010ef          	jal	ra,4c54 <exit>
    wait(&xstatus);
    3b5c:	f9c40513          	addi	a0,s0,-100
    3b60:	0fc010ef          	jal	ra,4c5c <wait>
    if(xstatus != 0)
    3b64:	f9c42983          	lw	s3,-100(s0)
    3b68:	00098563          	beqz	s3,3b72 <sharedfd+0xb6>
      exit(xstatus);
    3b6c:	854e                	mv	a0,s3
    3b6e:	0e6010ef          	jal	ra,4c54 <exit>
  close(fd);
    3b72:	854a                	mv	a0,s2
    3b74:	108010ef          	jal	ra,4c7c <close>
  fd = open("sharedfd", 0);
    3b78:	4581                	li	a1,0
    3b7a:	00003517          	auipc	a0,0x3
    3b7e:	27e50513          	addi	a0,a0,638 # 6df8 <malloc+0x1cc4>
    3b82:	112010ef          	jal	ra,4c94 <open>
    3b86:	8baa                	mv	s7,a0
  nc = np = 0;
    3b88:	8ace                	mv	s5,s3
  if(fd < 0){
    3b8a:	02054363          	bltz	a0,3bb0 <sharedfd+0xf4>
    3b8e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3b92:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3b96:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3b9a:	4629                	li	a2,10
    3b9c:	fa040593          	addi	a1,s0,-96
    3ba0:	855e                	mv	a0,s7
    3ba2:	0ca010ef          	jal	ra,4c6c <read>
    3ba6:	02a05b63          	blez	a0,3bdc <sharedfd+0x120>
    3baa:	fa040793          	addi	a5,s0,-96
    3bae:	a839                	j	3bcc <sharedfd+0x110>
    printf("%s: cannot open sharedfd for reading\n", s);
    3bb0:	85d2                	mv	a1,s4
    3bb2:	00003517          	auipc	a0,0x3
    3bb6:	29e50513          	addi	a0,a0,670 # 6e50 <malloc+0x1d1c>
    3bba:	4c0010ef          	jal	ra,507a <printf>
    exit(1);
    3bbe:	4505                	li	a0,1
    3bc0:	094010ef          	jal	ra,4c54 <exit>
        nc++;
    3bc4:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3bc6:	0785                	addi	a5,a5,1
    3bc8:	fd2789e3          	beq	a5,s2,3b9a <sharedfd+0xde>
      if(buf[i] == 'c')
    3bcc:	0007c703          	lbu	a4,0(a5) # 6400000 <base+0x63f1358>
    3bd0:	fe970ae3          	beq	a4,s1,3bc4 <sharedfd+0x108>
      if(buf[i] == 'p')
    3bd4:	ff6719e3          	bne	a4,s6,3bc6 <sharedfd+0x10a>
        np++;
    3bd8:	2a85                	addiw	s5,s5,1
    3bda:	b7f5                	j	3bc6 <sharedfd+0x10a>
  close(fd);
    3bdc:	855e                	mv	a0,s7
    3bde:	09e010ef          	jal	ra,4c7c <close>
  unlink("sharedfd");
    3be2:	00003517          	auipc	a0,0x3
    3be6:	21650513          	addi	a0,a0,534 # 6df8 <malloc+0x1cc4>
    3bea:	0ba010ef          	jal	ra,4ca4 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3bee:	6789                	lui	a5,0x2
    3bf0:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xdc>
    3bf4:	00f99763          	bne	s3,a5,3c02 <sharedfd+0x146>
    3bf8:	6789                	lui	a5,0x2
    3bfa:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xdc>
    3bfe:	00fa8c63          	beq	s5,a5,3c16 <sharedfd+0x15a>
    printf("%s: nc/np test fails\n", s);
    3c02:	85d2                	mv	a1,s4
    3c04:	00003517          	auipc	a0,0x3
    3c08:	27450513          	addi	a0,a0,628 # 6e78 <malloc+0x1d44>
    3c0c:	46e010ef          	jal	ra,507a <printf>
    exit(1);
    3c10:	4505                	li	a0,1
    3c12:	042010ef          	jal	ra,4c54 <exit>
    exit(0);
    3c16:	4501                	li	a0,0
    3c18:	03c010ef          	jal	ra,4c54 <exit>

0000000000003c1c <fourfiles>:
{
    3c1c:	7171                	addi	sp,sp,-176
    3c1e:	f506                	sd	ra,168(sp)
    3c20:	f122                	sd	s0,160(sp)
    3c22:	ed26                	sd	s1,152(sp)
    3c24:	e94a                	sd	s2,144(sp)
    3c26:	e54e                	sd	s3,136(sp)
    3c28:	e152                	sd	s4,128(sp)
    3c2a:	fcd6                	sd	s5,120(sp)
    3c2c:	f8da                	sd	s6,112(sp)
    3c2e:	f4de                	sd	s7,104(sp)
    3c30:	f0e2                	sd	s8,96(sp)
    3c32:	ece6                	sd	s9,88(sp)
    3c34:	e8ea                	sd	s10,80(sp)
    3c36:	e4ee                	sd	s11,72(sp)
    3c38:	1900                	addi	s0,sp,176
    3c3a:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c3c:	00001797          	auipc	a5,0x1
    3c40:	5d478793          	addi	a5,a5,1492 # 5210 <malloc+0xdc>
    3c44:	f6f43823          	sd	a5,-144(s0)
    3c48:	00001797          	auipc	a5,0x1
    3c4c:	5d078793          	addi	a5,a5,1488 # 5218 <malloc+0xe4>
    3c50:	f6f43c23          	sd	a5,-136(s0)
    3c54:	00001797          	auipc	a5,0x1
    3c58:	5cc78793          	addi	a5,a5,1484 # 5220 <malloc+0xec>
    3c5c:	f8f43023          	sd	a5,-128(s0)
    3c60:	00001797          	auipc	a5,0x1
    3c64:	5c878793          	addi	a5,a5,1480 # 5228 <malloc+0xf4>
    3c68:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3c6c:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c70:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3c72:	4481                	li	s1,0
    3c74:	4a11                	li	s4,4
    fname = names[pi];
    3c76:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3c7a:	854e                	mv	a0,s3
    3c7c:	028010ef          	jal	ra,4ca4 <unlink>
    pid = fork();
    3c80:	7cd000ef          	jal	ra,4c4c <fork>
    if(pid < 0){
    3c84:	04054363          	bltz	a0,3cca <fourfiles+0xae>
    if(pid == 0){
    3c88:	c939                	beqz	a0,3cde <fourfiles+0xc2>
  for(pi = 0; pi < NCHILD; pi++){
    3c8a:	2485                	addiw	s1,s1,1
    3c8c:	0921                	addi	s2,s2,8
    3c8e:	ff4494e3          	bne	s1,s4,3c76 <fourfiles+0x5a>
    3c92:	4491                	li	s1,4
    wait(&xstatus);
    3c94:	f6c40513          	addi	a0,s0,-148
    3c98:	7c5000ef          	jal	ra,4c5c <wait>
    if(xstatus != 0)
    3c9c:	f6c42503          	lw	a0,-148(s0)
    3ca0:	e94d                	bnez	a0,3d52 <fourfiles+0x136>
  for(pi = 0; pi < NCHILD; pi++){
    3ca2:	34fd                	addiw	s1,s1,-1
    3ca4:	f8e5                	bnez	s1,3c94 <fourfiles+0x78>
    3ca6:	03000b13          	li	s6,48
    total = 0;
    3caa:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3cae:	00008a17          	auipc	s4,0x8
    3cb2:	ffaa0a13          	addi	s4,s4,-6 # bca8 <buf>
    3cb6:	00008a97          	auipc	s5,0x8
    3cba:	ff3a8a93          	addi	s5,s5,-13 # bca9 <buf+0x1>
    if(total != N*SZ){
    3cbe:	6d05                	lui	s10,0x1
    3cc0:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x40>
  for(i = 0; i < NCHILD; i++){
    3cc4:	03400d93          	li	s11,52
    3cc8:	a0fd                	j	3db6 <fourfiles+0x19a>
      printf("%s: fork failed\n", s);
    3cca:	85e6                	mv	a1,s9
    3ccc:	00002517          	auipc	a0,0x2
    3cd0:	e2c50513          	addi	a0,a0,-468 # 5af8 <malloc+0x9c4>
    3cd4:	3a6010ef          	jal	ra,507a <printf>
      exit(1);
    3cd8:	4505                	li	a0,1
    3cda:	77b000ef          	jal	ra,4c54 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3cde:	20200593          	li	a1,514
    3ce2:	854e                	mv	a0,s3
    3ce4:	7b1000ef          	jal	ra,4c94 <open>
    3ce8:	892a                	mv	s2,a0
      if(fd < 0){
    3cea:	04054163          	bltz	a0,3d2c <fourfiles+0x110>
      memset(buf, '0'+pi, SZ);
    3cee:	1f400613          	li	a2,500
    3cf2:	0304859b          	addiw	a1,s1,48
    3cf6:	00008517          	auipc	a0,0x8
    3cfa:	fb250513          	addi	a0,a0,-78 # bca8 <buf>
    3cfe:	53b000ef          	jal	ra,4a38 <memset>
    3d02:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d04:	00008997          	auipc	s3,0x8
    3d08:	fa498993          	addi	s3,s3,-92 # bca8 <buf>
    3d0c:	1f400613          	li	a2,500
    3d10:	85ce                	mv	a1,s3
    3d12:	854a                	mv	a0,s2
    3d14:	761000ef          	jal	ra,4c74 <write>
    3d18:	85aa                	mv	a1,a0
    3d1a:	1f400793          	li	a5,500
    3d1e:	02f51163          	bne	a0,a5,3d40 <fourfiles+0x124>
      for(i = 0; i < N; i++){
    3d22:	34fd                	addiw	s1,s1,-1
    3d24:	f4e5                	bnez	s1,3d0c <fourfiles+0xf0>
      exit(0);
    3d26:	4501                	li	a0,0
    3d28:	72d000ef          	jal	ra,4c54 <exit>
        printf("%s: create failed\n", s);
    3d2c:	85e6                	mv	a1,s9
    3d2e:	00002517          	auipc	a0,0x2
    3d32:	e6250513          	addi	a0,a0,-414 # 5b90 <malloc+0xa5c>
    3d36:	344010ef          	jal	ra,507a <printf>
        exit(1);
    3d3a:	4505                	li	a0,1
    3d3c:	719000ef          	jal	ra,4c54 <exit>
          printf("write failed %d\n", n);
    3d40:	00003517          	auipc	a0,0x3
    3d44:	15050513          	addi	a0,a0,336 # 6e90 <malloc+0x1d5c>
    3d48:	332010ef          	jal	ra,507a <printf>
          exit(1);
    3d4c:	4505                	li	a0,1
    3d4e:	707000ef          	jal	ra,4c54 <exit>
      exit(xstatus);
    3d52:	703000ef          	jal	ra,4c54 <exit>
          printf("%s: wrong char\n", s);
    3d56:	85e6                	mv	a1,s9
    3d58:	00003517          	auipc	a0,0x3
    3d5c:	15050513          	addi	a0,a0,336 # 6ea8 <malloc+0x1d74>
    3d60:	31a010ef          	jal	ra,507a <printf>
          exit(1);
    3d64:	4505                	li	a0,1
    3d66:	6ef000ef          	jal	ra,4c54 <exit>
      total += n;
    3d6a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d6e:	660d                	lui	a2,0x3
    3d70:	85d2                	mv	a1,s4
    3d72:	854e                	mv	a0,s3
    3d74:	6f9000ef          	jal	ra,4c6c <read>
    3d78:	02a05363          	blez	a0,3d9e <fourfiles+0x182>
    3d7c:	00008797          	auipc	a5,0x8
    3d80:	f2c78793          	addi	a5,a5,-212 # bca8 <buf>
    3d84:	fff5069b          	addiw	a3,a0,-1
    3d88:	1682                	slli	a3,a3,0x20
    3d8a:	9281                	srli	a3,a3,0x20
    3d8c:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    3d8e:	0007c703          	lbu	a4,0(a5)
    3d92:	fc9712e3          	bne	a4,s1,3d56 <fourfiles+0x13a>
      for(j = 0; j < n; j++){
    3d96:	0785                	addi	a5,a5,1
    3d98:	fed79be3          	bne	a5,a3,3d8e <fourfiles+0x172>
    3d9c:	b7f9                	j	3d6a <fourfiles+0x14e>
    close(fd);
    3d9e:	854e                	mv	a0,s3
    3da0:	6dd000ef          	jal	ra,4c7c <close>
    if(total != N*SZ){
    3da4:	03a91563          	bne	s2,s10,3dce <fourfiles+0x1b2>
    unlink(fname);
    3da8:	8562                	mv	a0,s8
    3daa:	6fb000ef          	jal	ra,4ca4 <unlink>
  for(i = 0; i < NCHILD; i++){
    3dae:	0ba1                	addi	s7,s7,8
    3db0:	2b05                	addiw	s6,s6,1
    3db2:	03bb0863          	beq	s6,s11,3de2 <fourfiles+0x1c6>
    fname = names[i];
    3db6:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3dba:	4581                	li	a1,0
    3dbc:	8562                	mv	a0,s8
    3dbe:	6d7000ef          	jal	ra,4c94 <open>
    3dc2:	89aa                	mv	s3,a0
    total = 0;
    3dc4:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    3dc8:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dcc:	b74d                	j	3d6e <fourfiles+0x152>
      printf("wrong length %d\n", total);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00003517          	auipc	a0,0x3
    3dd4:	0e850513          	addi	a0,a0,232 # 6eb8 <malloc+0x1d84>
    3dd8:	2a2010ef          	jal	ra,507a <printf>
      exit(1);
    3ddc:	4505                	li	a0,1
    3dde:	677000ef          	jal	ra,4c54 <exit>
}
    3de2:	70aa                	ld	ra,168(sp)
    3de4:	740a                	ld	s0,160(sp)
    3de6:	64ea                	ld	s1,152(sp)
    3de8:	694a                	ld	s2,144(sp)
    3dea:	69aa                	ld	s3,136(sp)
    3dec:	6a0a                	ld	s4,128(sp)
    3dee:	7ae6                	ld	s5,120(sp)
    3df0:	7b46                	ld	s6,112(sp)
    3df2:	7ba6                	ld	s7,104(sp)
    3df4:	7c06                	ld	s8,96(sp)
    3df6:	6ce6                	ld	s9,88(sp)
    3df8:	6d46                	ld	s10,80(sp)
    3dfa:	6da6                	ld	s11,72(sp)
    3dfc:	614d                	addi	sp,sp,176
    3dfe:	8082                	ret

0000000000003e00 <concreate>:
{
    3e00:	7135                	addi	sp,sp,-160
    3e02:	ed06                	sd	ra,152(sp)
    3e04:	e922                	sd	s0,144(sp)
    3e06:	e526                	sd	s1,136(sp)
    3e08:	e14a                	sd	s2,128(sp)
    3e0a:	fcce                	sd	s3,120(sp)
    3e0c:	f8d2                	sd	s4,112(sp)
    3e0e:	f4d6                	sd	s5,104(sp)
    3e10:	f0da                	sd	s6,96(sp)
    3e12:	ecde                	sd	s7,88(sp)
    3e14:	1100                	addi	s0,sp,160
    3e16:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e18:	04300793          	li	a5,67
    3e1c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e20:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e24:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e26:	4b0d                	li	s6,3
    3e28:	4a85                	li	s5,1
      link("C0", file);
    3e2a:	00003b97          	auipc	s7,0x3
    3e2e:	0a6b8b93          	addi	s7,s7,166 # 6ed0 <malloc+0x1d9c>
  for(i = 0; i < N; i++){
    3e32:	02800a13          	li	s4,40
    3e36:	a415                	j	405a <concreate+0x25a>
      link("C0", file);
    3e38:	fa840593          	addi	a1,s0,-88
    3e3c:	855e                	mv	a0,s7
    3e3e:	677000ef          	jal	ra,4cb4 <link>
    if(pid == 0) {
    3e42:	a409                	j	4044 <concreate+0x244>
    } else if(pid == 0 && (i % 5) == 1){
    3e44:	4795                	li	a5,5
    3e46:	02f9693b          	remw	s2,s2,a5
    3e4a:	4785                	li	a5,1
    3e4c:	02f90563          	beq	s2,a5,3e76 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e50:	20200593          	li	a1,514
    3e54:	fa840513          	addi	a0,s0,-88
    3e58:	63d000ef          	jal	ra,4c94 <open>
      if(fd < 0){
    3e5c:	1c055f63          	bgez	a0,403a <concreate+0x23a>
        printf("concreate create %s failed\n", file);
    3e60:	fa840593          	addi	a1,s0,-88
    3e64:	00003517          	auipc	a0,0x3
    3e68:	07450513          	addi	a0,a0,116 # 6ed8 <malloc+0x1da4>
    3e6c:	20e010ef          	jal	ra,507a <printf>
        exit(1);
    3e70:	4505                	li	a0,1
    3e72:	5e3000ef          	jal	ra,4c54 <exit>
      link("C0", file);
    3e76:	fa840593          	addi	a1,s0,-88
    3e7a:	00003517          	auipc	a0,0x3
    3e7e:	05650513          	addi	a0,a0,86 # 6ed0 <malloc+0x1d9c>
    3e82:	633000ef          	jal	ra,4cb4 <link>
      exit(0);
    3e86:	4501                	li	a0,0
    3e88:	5cd000ef          	jal	ra,4c54 <exit>
        exit(1);
    3e8c:	4505                	li	a0,1
    3e8e:	5c7000ef          	jal	ra,4c54 <exit>
  memset(fa, 0, sizeof(fa));
    3e92:	02800613          	li	a2,40
    3e96:	4581                	li	a1,0
    3e98:	f8040513          	addi	a0,s0,-128
    3e9c:	39d000ef          	jal	ra,4a38 <memset>
  fd = open(".", 0);
    3ea0:	4581                	li	a1,0
    3ea2:	00002517          	auipc	a0,0x2
    3ea6:	aae50513          	addi	a0,a0,-1362 # 5950 <malloc+0x81c>
    3eaa:	5eb000ef          	jal	ra,4c94 <open>
    3eae:	892a                	mv	s2,a0
  n = 0;
    3eb0:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3eb2:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3eb6:	02700b13          	li	s6,39
      fa[i] = 1;
    3eba:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3ebc:	a01d                	j	3ee2 <concreate+0xe2>
        printf("%s: concreate weird file %s\n", s, de.name);
    3ebe:	f7240613          	addi	a2,s0,-142
    3ec2:	85ce                	mv	a1,s3
    3ec4:	00003517          	auipc	a0,0x3
    3ec8:	03450513          	addi	a0,a0,52 # 6ef8 <malloc+0x1dc4>
    3ecc:	1ae010ef          	jal	ra,507a <printf>
        exit(1);
    3ed0:	4505                	li	a0,1
    3ed2:	583000ef          	jal	ra,4c54 <exit>
      fa[i] = 1;
    3ed6:	fb040793          	addi	a5,s0,-80
    3eda:	973e                	add	a4,a4,a5
    3edc:	fd770823          	sb	s7,-48(a4)
      n++;
    3ee0:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    3ee2:	4641                	li	a2,16
    3ee4:	f7040593          	addi	a1,s0,-144
    3ee8:	854a                	mv	a0,s2
    3eea:	583000ef          	jal	ra,4c6c <read>
    3eee:	04a05663          	blez	a0,3f3a <concreate+0x13a>
    if(de.inum == 0)
    3ef2:	f7045783          	lhu	a5,-144(s0)
    3ef6:	d7f5                	beqz	a5,3ee2 <concreate+0xe2>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3ef8:	f7244783          	lbu	a5,-142(s0)
    3efc:	ff4793e3          	bne	a5,s4,3ee2 <concreate+0xe2>
    3f00:	f7444783          	lbu	a5,-140(s0)
    3f04:	fff9                	bnez	a5,3ee2 <concreate+0xe2>
      i = de.name[1] - '0';
    3f06:	f7344783          	lbu	a5,-141(s0)
    3f0a:	fd07879b          	addiw	a5,a5,-48
    3f0e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f12:	faeb66e3          	bltu	s6,a4,3ebe <concreate+0xbe>
      if(fa[i]){
    3f16:	fb040793          	addi	a5,s0,-80
    3f1a:	97ba                	add	a5,a5,a4
    3f1c:	fd07c783          	lbu	a5,-48(a5)
    3f20:	dbdd                	beqz	a5,3ed6 <concreate+0xd6>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f22:	f7240613          	addi	a2,s0,-142
    3f26:	85ce                	mv	a1,s3
    3f28:	00003517          	auipc	a0,0x3
    3f2c:	ff050513          	addi	a0,a0,-16 # 6f18 <malloc+0x1de4>
    3f30:	14a010ef          	jal	ra,507a <printf>
        exit(1);
    3f34:	4505                	li	a0,1
    3f36:	51f000ef          	jal	ra,4c54 <exit>
  close(fd);
    3f3a:	854a                	mv	a0,s2
    3f3c:	541000ef          	jal	ra,4c7c <close>
  if(n != N){
    3f40:	02800793          	li	a5,40
    3f44:	00fa9763          	bne	s5,a5,3f52 <concreate+0x152>
    if(((i % 3) == 0 && pid == 0) ||
    3f48:	4a8d                	li	s5,3
    3f4a:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f4c:	02800a13          	li	s4,40
    3f50:	a079                	j	3fde <concreate+0x1de>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f52:	85ce                	mv	a1,s3
    3f54:	00003517          	auipc	a0,0x3
    3f58:	fec50513          	addi	a0,a0,-20 # 6f40 <malloc+0x1e0c>
    3f5c:	11e010ef          	jal	ra,507a <printf>
    exit(1);
    3f60:	4505                	li	a0,1
    3f62:	4f3000ef          	jal	ra,4c54 <exit>
      printf("%s: fork failed\n", s);
    3f66:	85ce                	mv	a1,s3
    3f68:	00002517          	auipc	a0,0x2
    3f6c:	b9050513          	addi	a0,a0,-1136 # 5af8 <malloc+0x9c4>
    3f70:	10a010ef          	jal	ra,507a <printf>
      exit(1);
    3f74:	4505                	li	a0,1
    3f76:	4df000ef          	jal	ra,4c54 <exit>
      close(open(file, 0));
    3f7a:	4581                	li	a1,0
    3f7c:	fa840513          	addi	a0,s0,-88
    3f80:	515000ef          	jal	ra,4c94 <open>
    3f84:	4f9000ef          	jal	ra,4c7c <close>
      close(open(file, 0));
    3f88:	4581                	li	a1,0
    3f8a:	fa840513          	addi	a0,s0,-88
    3f8e:	507000ef          	jal	ra,4c94 <open>
    3f92:	4eb000ef          	jal	ra,4c7c <close>
      close(open(file, 0));
    3f96:	4581                	li	a1,0
    3f98:	fa840513          	addi	a0,s0,-88
    3f9c:	4f9000ef          	jal	ra,4c94 <open>
    3fa0:	4dd000ef          	jal	ra,4c7c <close>
      close(open(file, 0));
    3fa4:	4581                	li	a1,0
    3fa6:	fa840513          	addi	a0,s0,-88
    3faa:	4eb000ef          	jal	ra,4c94 <open>
    3fae:	4cf000ef          	jal	ra,4c7c <close>
      close(open(file, 0));
    3fb2:	4581                	li	a1,0
    3fb4:	fa840513          	addi	a0,s0,-88
    3fb8:	4dd000ef          	jal	ra,4c94 <open>
    3fbc:	4c1000ef          	jal	ra,4c7c <close>
      close(open(file, 0));
    3fc0:	4581                	li	a1,0
    3fc2:	fa840513          	addi	a0,s0,-88
    3fc6:	4cf000ef          	jal	ra,4c94 <open>
    3fca:	4b3000ef          	jal	ra,4c7c <close>
    if(pid == 0)
    3fce:	06090363          	beqz	s2,4034 <concreate+0x234>
      wait(0);
    3fd2:	4501                	li	a0,0
    3fd4:	489000ef          	jal	ra,4c5c <wait>
  for(i = 0; i < N; i++){
    3fd8:	2485                	addiw	s1,s1,1
    3fda:	0b448963          	beq	s1,s4,408c <concreate+0x28c>
    file[1] = '0' + i;
    3fde:	0304879b          	addiw	a5,s1,48
    3fe2:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3fe6:	467000ef          	jal	ra,4c4c <fork>
    3fea:	892a                	mv	s2,a0
    if(pid < 0){
    3fec:	f6054de3          	bltz	a0,3f66 <concreate+0x166>
    if(((i % 3) == 0 && pid == 0) ||
    3ff0:	0354e73b          	remw	a4,s1,s5
    3ff4:	00a767b3          	or	a5,a4,a0
    3ff8:	2781                	sext.w	a5,a5
    3ffa:	d3c1                	beqz	a5,3f7a <concreate+0x17a>
    3ffc:	01671363          	bne	a4,s6,4002 <concreate+0x202>
       ((i % 3) == 1 && pid != 0)){
    4000:	fd2d                	bnez	a0,3f7a <concreate+0x17a>
      unlink(file);
    4002:	fa840513          	addi	a0,s0,-88
    4006:	49f000ef          	jal	ra,4ca4 <unlink>
      unlink(file);
    400a:	fa840513          	addi	a0,s0,-88
    400e:	497000ef          	jal	ra,4ca4 <unlink>
      unlink(file);
    4012:	fa840513          	addi	a0,s0,-88
    4016:	48f000ef          	jal	ra,4ca4 <unlink>
      unlink(file);
    401a:	fa840513          	addi	a0,s0,-88
    401e:	487000ef          	jal	ra,4ca4 <unlink>
      unlink(file);
    4022:	fa840513          	addi	a0,s0,-88
    4026:	47f000ef          	jal	ra,4ca4 <unlink>
      unlink(file);
    402a:	fa840513          	addi	a0,s0,-88
    402e:	477000ef          	jal	ra,4ca4 <unlink>
    4032:	bf71                	j	3fce <concreate+0x1ce>
      exit(0);
    4034:	4501                	li	a0,0
    4036:	41f000ef          	jal	ra,4c54 <exit>
      close(fd);
    403a:	443000ef          	jal	ra,4c7c <close>
    if(pid == 0) {
    403e:	b5a1                	j	3e86 <concreate+0x86>
      close(fd);
    4040:	43d000ef          	jal	ra,4c7c <close>
      wait(&xstatus);
    4044:	f6c40513          	addi	a0,s0,-148
    4048:	415000ef          	jal	ra,4c5c <wait>
      if(xstatus != 0)
    404c:	f6c42483          	lw	s1,-148(s0)
    4050:	e2049ee3          	bnez	s1,3e8c <concreate+0x8c>
  for(i = 0; i < N; i++){
    4054:	2905                	addiw	s2,s2,1
    4056:	e3490ee3          	beq	s2,s4,3e92 <concreate+0x92>
    file[1] = '0' + i;
    405a:	0309079b          	addiw	a5,s2,48
    405e:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4062:	fa840513          	addi	a0,s0,-88
    4066:	43f000ef          	jal	ra,4ca4 <unlink>
    pid = fork();
    406a:	3e3000ef          	jal	ra,4c4c <fork>
    if(pid && (i % 3) == 1){
    406e:	dc050be3          	beqz	a0,3e44 <concreate+0x44>
    4072:	036967bb          	remw	a5,s2,s6
    4076:	dd5781e3          	beq	a5,s5,3e38 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    407a:	20200593          	li	a1,514
    407e:	fa840513          	addi	a0,s0,-88
    4082:	413000ef          	jal	ra,4c94 <open>
      if(fd < 0){
    4086:	fa055de3          	bgez	a0,4040 <concreate+0x240>
    408a:	bbd9                	j	3e60 <concreate+0x60>
}
    408c:	60ea                	ld	ra,152(sp)
    408e:	644a                	ld	s0,144(sp)
    4090:	64aa                	ld	s1,136(sp)
    4092:	690a                	ld	s2,128(sp)
    4094:	79e6                	ld	s3,120(sp)
    4096:	7a46                	ld	s4,112(sp)
    4098:	7aa6                	ld	s5,104(sp)
    409a:	7b06                	ld	s6,96(sp)
    409c:	6be6                	ld	s7,88(sp)
    409e:	610d                	addi	sp,sp,160
    40a0:	8082                	ret

00000000000040a2 <bigfile>:
{
    40a2:	7139                	addi	sp,sp,-64
    40a4:	fc06                	sd	ra,56(sp)
    40a6:	f822                	sd	s0,48(sp)
    40a8:	f426                	sd	s1,40(sp)
    40aa:	f04a                	sd	s2,32(sp)
    40ac:	ec4e                	sd	s3,24(sp)
    40ae:	e852                	sd	s4,16(sp)
    40b0:	e456                	sd	s5,8(sp)
    40b2:	0080                	addi	s0,sp,64
    40b4:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    40b6:	00003517          	auipc	a0,0x3
    40ba:	ec250513          	addi	a0,a0,-318 # 6f78 <malloc+0x1e44>
    40be:	3e7000ef          	jal	ra,4ca4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40c2:	20200593          	li	a1,514
    40c6:	00003517          	auipc	a0,0x3
    40ca:	eb250513          	addi	a0,a0,-334 # 6f78 <malloc+0x1e44>
    40ce:	3c7000ef          	jal	ra,4c94 <open>
    40d2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    40d4:	4481                	li	s1,0
    memset(buf, i, SZ);
    40d6:	00008917          	auipc	s2,0x8
    40da:	bd290913          	addi	s2,s2,-1070 # bca8 <buf>
  for(i = 0; i < N; i++){
    40de:	4a51                	li	s4,20
  if(fd < 0){
    40e0:	08054663          	bltz	a0,416c <bigfile+0xca>
    memset(buf, i, SZ);
    40e4:	25800613          	li	a2,600
    40e8:	85a6                	mv	a1,s1
    40ea:	854a                	mv	a0,s2
    40ec:	14d000ef          	jal	ra,4a38 <memset>
    if(write(fd, buf, SZ) != SZ){
    40f0:	25800613          	li	a2,600
    40f4:	85ca                	mv	a1,s2
    40f6:	854e                	mv	a0,s3
    40f8:	37d000ef          	jal	ra,4c74 <write>
    40fc:	25800793          	li	a5,600
    4100:	08f51063          	bne	a0,a5,4180 <bigfile+0xde>
  for(i = 0; i < N; i++){
    4104:	2485                	addiw	s1,s1,1
    4106:	fd449fe3          	bne	s1,s4,40e4 <bigfile+0x42>
  close(fd);
    410a:	854e                	mv	a0,s3
    410c:	371000ef          	jal	ra,4c7c <close>
  fd = open("bigfile.dat", 0);
    4110:	4581                	li	a1,0
    4112:	00003517          	auipc	a0,0x3
    4116:	e6650513          	addi	a0,a0,-410 # 6f78 <malloc+0x1e44>
    411a:	37b000ef          	jal	ra,4c94 <open>
    411e:	8a2a                	mv	s4,a0
  total = 0;
    4120:	4981                	li	s3,0
  for(i = 0; ; i++){
    4122:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4124:	00008917          	auipc	s2,0x8
    4128:	b8490913          	addi	s2,s2,-1148 # bca8 <buf>
  if(fd < 0){
    412c:	06054463          	bltz	a0,4194 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4130:	12c00613          	li	a2,300
    4134:	85ca                	mv	a1,s2
    4136:	8552                	mv	a0,s4
    4138:	335000ef          	jal	ra,4c6c <read>
    if(cc < 0){
    413c:	06054663          	bltz	a0,41a8 <bigfile+0x106>
    if(cc == 0)
    4140:	c155                	beqz	a0,41e4 <bigfile+0x142>
    if(cc != SZ/2){
    4142:	12c00793          	li	a5,300
    4146:	06f51b63          	bne	a0,a5,41bc <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    414a:	01f4d79b          	srliw	a5,s1,0x1f
    414e:	9fa5                	addw	a5,a5,s1
    4150:	4017d79b          	sraiw	a5,a5,0x1
    4154:	00094703          	lbu	a4,0(s2)
    4158:	06f71c63          	bne	a4,a5,41d0 <bigfile+0x12e>
    415c:	12b94703          	lbu	a4,299(s2)
    4160:	06f71863          	bne	a4,a5,41d0 <bigfile+0x12e>
    total += cc;
    4164:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4168:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    416a:	b7d9                	j	4130 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    416c:	85d6                	mv	a1,s5
    416e:	00003517          	auipc	a0,0x3
    4172:	e1a50513          	addi	a0,a0,-486 # 6f88 <malloc+0x1e54>
    4176:	705000ef          	jal	ra,507a <printf>
    exit(1);
    417a:	4505                	li	a0,1
    417c:	2d9000ef          	jal	ra,4c54 <exit>
      printf("%s: write bigfile failed\n", s);
    4180:	85d6                	mv	a1,s5
    4182:	00003517          	auipc	a0,0x3
    4186:	e2650513          	addi	a0,a0,-474 # 6fa8 <malloc+0x1e74>
    418a:	6f1000ef          	jal	ra,507a <printf>
      exit(1);
    418e:	4505                	li	a0,1
    4190:	2c5000ef          	jal	ra,4c54 <exit>
    printf("%s: cannot open bigfile\n", s);
    4194:	85d6                	mv	a1,s5
    4196:	00003517          	auipc	a0,0x3
    419a:	e3250513          	addi	a0,a0,-462 # 6fc8 <malloc+0x1e94>
    419e:	6dd000ef          	jal	ra,507a <printf>
    exit(1);
    41a2:	4505                	li	a0,1
    41a4:	2b1000ef          	jal	ra,4c54 <exit>
      printf("%s: read bigfile failed\n", s);
    41a8:	85d6                	mv	a1,s5
    41aa:	00003517          	auipc	a0,0x3
    41ae:	e3e50513          	addi	a0,a0,-450 # 6fe8 <malloc+0x1eb4>
    41b2:	6c9000ef          	jal	ra,507a <printf>
      exit(1);
    41b6:	4505                	li	a0,1
    41b8:	29d000ef          	jal	ra,4c54 <exit>
      printf("%s: short read bigfile\n", s);
    41bc:	85d6                	mv	a1,s5
    41be:	00003517          	auipc	a0,0x3
    41c2:	e4a50513          	addi	a0,a0,-438 # 7008 <malloc+0x1ed4>
    41c6:	6b5000ef          	jal	ra,507a <printf>
      exit(1);
    41ca:	4505                	li	a0,1
    41cc:	289000ef          	jal	ra,4c54 <exit>
      printf("%s: read bigfile wrong data\n", s);
    41d0:	85d6                	mv	a1,s5
    41d2:	00003517          	auipc	a0,0x3
    41d6:	e4e50513          	addi	a0,a0,-434 # 7020 <malloc+0x1eec>
    41da:	6a1000ef          	jal	ra,507a <printf>
      exit(1);
    41de:	4505                	li	a0,1
    41e0:	275000ef          	jal	ra,4c54 <exit>
  close(fd);
    41e4:	8552                	mv	a0,s4
    41e6:	297000ef          	jal	ra,4c7c <close>
  if(total != N*SZ){
    41ea:	678d                	lui	a5,0x3
    41ec:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x364>
    41f0:	02f99163          	bne	s3,a5,4212 <bigfile+0x170>
  unlink("bigfile.dat");
    41f4:	00003517          	auipc	a0,0x3
    41f8:	d8450513          	addi	a0,a0,-636 # 6f78 <malloc+0x1e44>
    41fc:	2a9000ef          	jal	ra,4ca4 <unlink>
}
    4200:	70e2                	ld	ra,56(sp)
    4202:	7442                	ld	s0,48(sp)
    4204:	74a2                	ld	s1,40(sp)
    4206:	7902                	ld	s2,32(sp)
    4208:	69e2                	ld	s3,24(sp)
    420a:	6a42                	ld	s4,16(sp)
    420c:	6aa2                	ld	s5,8(sp)
    420e:	6121                	addi	sp,sp,64
    4210:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4212:	85d6                	mv	a1,s5
    4214:	00003517          	auipc	a0,0x3
    4218:	e2c50513          	addi	a0,a0,-468 # 7040 <malloc+0x1f0c>
    421c:	65f000ef          	jal	ra,507a <printf>
    exit(1);
    4220:	4505                	li	a0,1
    4222:	233000ef          	jal	ra,4c54 <exit>

0000000000004226 <bigargtest>:
{
    4226:	7121                	addi	sp,sp,-448
    4228:	ff06                	sd	ra,440(sp)
    422a:	fb22                	sd	s0,432(sp)
    422c:	f726                	sd	s1,424(sp)
    422e:	0380                	addi	s0,sp,448
    4230:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4232:	00003517          	auipc	a0,0x3
    4236:	e2e50513          	addi	a0,a0,-466 # 7060 <malloc+0x1f2c>
    423a:	26b000ef          	jal	ra,4ca4 <unlink>
  pid = fork();
    423e:	20f000ef          	jal	ra,4c4c <fork>
  if(pid == 0){
    4242:	c915                	beqz	a0,4276 <bigargtest+0x50>
  } else if(pid < 0){
    4244:	08054a63          	bltz	a0,42d8 <bigargtest+0xb2>
  wait(&xstatus);
    4248:	fdc40513          	addi	a0,s0,-36
    424c:	211000ef          	jal	ra,4c5c <wait>
  if(xstatus != 0)
    4250:	fdc42503          	lw	a0,-36(s0)
    4254:	ed41                	bnez	a0,42ec <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    4256:	4581                	li	a1,0
    4258:	00003517          	auipc	a0,0x3
    425c:	e0850513          	addi	a0,a0,-504 # 7060 <malloc+0x1f2c>
    4260:	235000ef          	jal	ra,4c94 <open>
  if(fd < 0){
    4264:	08054663          	bltz	a0,42f0 <bigargtest+0xca>
  close(fd);
    4268:	215000ef          	jal	ra,4c7c <close>
}
    426c:	70fa                	ld	ra,440(sp)
    426e:	745a                	ld	s0,432(sp)
    4270:	74ba                	ld	s1,424(sp)
    4272:	6139                	addi	sp,sp,448
    4274:	8082                	ret
    memset(big, ' ', sizeof(big));
    4276:	19000613          	li	a2,400
    427a:	02000593          	li	a1,32
    427e:	e4840513          	addi	a0,s0,-440
    4282:	7b6000ef          	jal	ra,4a38 <memset>
    big[sizeof(big)-1] = '\0';
    4286:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    428a:	00004797          	auipc	a5,0x4
    428e:	20678793          	addi	a5,a5,518 # 8490 <args.1818>
    4292:	00004697          	auipc	a3,0x4
    4296:	2f668693          	addi	a3,a3,758 # 8588 <args.1818+0xf8>
      args[i] = big;
    429a:	e4840713          	addi	a4,s0,-440
    429e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    42a0:	07a1                	addi	a5,a5,8
    42a2:	fed79ee3          	bne	a5,a3,429e <bigargtest+0x78>
    args[MAXARG-1] = 0;
    42a6:	00004597          	auipc	a1,0x4
    42aa:	1ea58593          	addi	a1,a1,490 # 8490 <args.1818>
    42ae:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42b2:	00001517          	auipc	a0,0x1
    42b6:	fb650513          	addi	a0,a0,-74 # 5268 <malloc+0x134>
    42ba:	1d3000ef          	jal	ra,4c8c <exec>
    fd = open("bigarg-ok", O_CREATE);
    42be:	20000593          	li	a1,512
    42c2:	00003517          	auipc	a0,0x3
    42c6:	d9e50513          	addi	a0,a0,-610 # 7060 <malloc+0x1f2c>
    42ca:	1cb000ef          	jal	ra,4c94 <open>
    close(fd);
    42ce:	1af000ef          	jal	ra,4c7c <close>
    exit(0);
    42d2:	4501                	li	a0,0
    42d4:	181000ef          	jal	ra,4c54 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    42d8:	85a6                	mv	a1,s1
    42da:	00003517          	auipc	a0,0x3
    42de:	d9650513          	addi	a0,a0,-618 # 7070 <malloc+0x1f3c>
    42e2:	599000ef          	jal	ra,507a <printf>
    exit(1);
    42e6:	4505                	li	a0,1
    42e8:	16d000ef          	jal	ra,4c54 <exit>
    exit(xstatus);
    42ec:	169000ef          	jal	ra,4c54 <exit>
    printf("%s: bigarg test failed!\n", s);
    42f0:	85a6                	mv	a1,s1
    42f2:	00003517          	auipc	a0,0x3
    42f6:	d9e50513          	addi	a0,a0,-610 # 7090 <malloc+0x1f5c>
    42fa:	581000ef          	jal	ra,507a <printf>
    exit(1);
    42fe:	4505                	li	a0,1
    4300:	155000ef          	jal	ra,4c54 <exit>

0000000000004304 <lazy_alloc>:
{
    4304:	1141                	addi	sp,sp,-16
    4306:	e406                	sd	ra,8(sp)
    4308:	e022                	sd	s0,0(sp)
    430a:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    430c:	40000537          	lui	a0,0x40000
    4310:	127000ef          	jal	ra,4c36 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    4314:	57fd                	li	a5,-1
    4316:	02f50963          	beq	a0,a5,4348 <lazy_alloc+0x44>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    431a:	6605                	lui	a2,0x1
    431c:	962a                	add	a2,a2,a0
    431e:	40001737          	lui	a4,0x40001
    4322:	972a                	add	a4,a4,a0
    4324:	87b2                	mv	a5,a2
    4326:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    432a:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    432c:	97b6                	add	a5,a5,a3
    432e:	fee79ee3          	bne	a5,a4,432a <lazy_alloc+0x26>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4332:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4336:	621c                	ld	a5,0(a2)
    4338:	02c79163          	bne	a5,a2,435a <lazy_alloc+0x56>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    433c:	9636                	add	a2,a2,a3
    433e:	fee61ce3          	bne	a2,a4,4336 <lazy_alloc+0x32>
  exit(0);
    4342:	4501                	li	a0,0
    4344:	111000ef          	jal	ra,4c54 <exit>
    printf("sbrklazy() failed\n");
    4348:	00003517          	auipc	a0,0x3
    434c:	d6850513          	addi	a0,a0,-664 # 70b0 <malloc+0x1f7c>
    4350:	52b000ef          	jal	ra,507a <printf>
    exit(1);
    4354:	4505                	li	a0,1
    4356:	0ff000ef          	jal	ra,4c54 <exit>
      printf("failed to read value from memory\n");
    435a:	00003517          	auipc	a0,0x3
    435e:	d6e50513          	addi	a0,a0,-658 # 70c8 <malloc+0x1f94>
    4362:	519000ef          	jal	ra,507a <printf>
      exit(1);
    4366:	4505                	li	a0,1
    4368:	0ed000ef          	jal	ra,4c54 <exit>

000000000000436c <lazy_unmap>:
{
    436c:	7139                	addi	sp,sp,-64
    436e:	fc06                	sd	ra,56(sp)
    4370:	f822                	sd	s0,48(sp)
    4372:	f426                	sd	s1,40(sp)
    4374:	f04a                	sd	s2,32(sp)
    4376:	ec4e                	sd	s3,24(sp)
    4378:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    437a:	40000537          	lui	a0,0x40000
    437e:	0b9000ef          	jal	ra,4c36 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4382:	57fd                	li	a5,-1
    4384:	04f50263          	beq	a0,a5,43c8 <lazy_unmap+0x5c>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4388:	6905                	lui	s2,0x1
    438a:	992a                	add	s2,s2,a0
    438c:	400014b7          	lui	s1,0x40001
    4390:	94aa                	add	s1,s1,a0
    4392:	87ca                	mv	a5,s2
    4394:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4398:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    439a:	97ba                	add	a5,a5,a4
    439c:	fef49ee3          	bne	s1,a5,4398 <lazy_unmap+0x2c>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    43a0:	010009b7          	lui	s3,0x1000
    pid = fork();
    43a4:	0a9000ef          	jal	ra,4c4c <fork>
    if (pid < 0) {
    43a8:	02054963          	bltz	a0,43da <lazy_unmap+0x6e>
    } else if (pid == 0) {
    43ac:	c121                	beqz	a0,43ec <lazy_unmap+0x80>
      wait(&status);
    43ae:	fcc40513          	addi	a0,s0,-52
    43b2:	0ab000ef          	jal	ra,4c5c <wait>
      if (status == 0) {
    43b6:	fcc42783          	lw	a5,-52(s0)
    43ba:	c3b1                	beqz	a5,43fe <lazy_unmap+0x92>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    43bc:	994e                	add	s2,s2,s3
    43be:	ff2493e3          	bne	s1,s2,43a4 <lazy_unmap+0x38>
  exit(0);
    43c2:	4501                	li	a0,0
    43c4:	091000ef          	jal	ra,4c54 <exit>
    printf("sbrklazy() failed\n");
    43c8:	00003517          	auipc	a0,0x3
    43cc:	ce850513          	addi	a0,a0,-792 # 70b0 <malloc+0x1f7c>
    43d0:	4ab000ef          	jal	ra,507a <printf>
    exit(1);
    43d4:	4505                	li	a0,1
    43d6:	07f000ef          	jal	ra,4c54 <exit>
      printf("error forking\n");
    43da:	00003517          	auipc	a0,0x3
    43de:	d1650513          	addi	a0,a0,-746 # 70f0 <malloc+0x1fbc>
    43e2:	499000ef          	jal	ra,507a <printf>
      exit(1);
    43e6:	4505                	li	a0,1
    43e8:	06d000ef          	jal	ra,4c54 <exit>
      sbrklazy(-1L * REGION_SZ);
    43ec:	c0000537          	lui	a0,0xc0000
    43f0:	047000ef          	jal	ra,4c36 <sbrklazy>
      *(char **)i = i;
    43f4:	01293023          	sd	s2,0(s2) # 1000 <pgbug+0x22>
      exit(0);
    43f8:	4501                	li	a0,0
    43fa:	05b000ef          	jal	ra,4c54 <exit>
        printf("memory not unmapped\n");
    43fe:	00003517          	auipc	a0,0x3
    4402:	d0250513          	addi	a0,a0,-766 # 7100 <malloc+0x1fcc>
    4406:	475000ef          	jal	ra,507a <printf>
        exit(1);
    440a:	4505                	li	a0,1
    440c:	049000ef          	jal	ra,4c54 <exit>

0000000000004410 <lazy_copy>:
{
    4410:	7159                	addi	sp,sp,-112
    4412:	f486                	sd	ra,104(sp)
    4414:	f0a2                	sd	s0,96(sp)
    4416:	eca6                	sd	s1,88(sp)
    4418:	e8ca                	sd	s2,80(sp)
    441a:	e4ce                	sd	s3,72(sp)
    441c:	e0d2                	sd	s4,64(sp)
    441e:	fc56                	sd	s5,56(sp)
    4420:	f85a                	sd	s6,48(sp)
    4422:	1880                	addi	s0,sp,112
    char *p = sbrk(0);
    4424:	4501                	li	a0,0
    4426:	7fa000ef          	jal	ra,4c20 <sbrk>
    442a:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    442c:	6511                	lui	a0,0x4
    442e:	009000ef          	jal	ra,4c36 <sbrklazy>
    open(p + 8192, 0);
    4432:	4581                	li	a1,0
    4434:	6509                	lui	a0,0x2
    4436:	9526                	add	a0,a0,s1
    4438:	05d000ef          	jal	ra,4c94 <open>
    void *xx = sbrk(0);
    443c:	4501                	li	a0,0
    443e:	7e2000ef          	jal	ra,4c20 <sbrk>
    4442:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    4444:	fff54513          	not	a0,a0
    4448:	2501                	sext.w	a0,a0
    444a:	7d6000ef          	jal	ra,4c20 <sbrk>
    if(ret != xx){
    444e:	00a48c63          	beq	s1,a0,4466 <lazy_copy+0x56>
    4452:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4454:	00003517          	auipc	a0,0x3
    4458:	cc450513          	addi	a0,a0,-828 # 7118 <malloc+0x1fe4>
    445c:	41f000ef          	jal	ra,507a <printf>
      exit(1);
    4460:	4505                	li	a0,1
    4462:	7f2000ef          	jal	ra,4c54 <exit>
  unsigned long bad[] = {
    4466:	00003797          	auipc	a5,0x3
    446a:	22a78793          	addi	a5,a5,554 # 7690 <malloc+0x255c>
    446e:	7fa8                	ld	a0,120(a5)
    4470:	63cc                	ld	a1,128(a5)
    4472:	67d0                	ld	a2,136(a5)
    4474:	6bd4                	ld	a3,144(a5)
    4476:	6fd8                	ld	a4,152(a5)
    4478:	73dc                	ld	a5,160(a5)
    447a:	f8a43823          	sd	a0,-112(s0)
    447e:	f8b43c23          	sd	a1,-104(s0)
    4482:	fac43023          	sd	a2,-96(s0)
    4486:	fad43423          	sd	a3,-88(s0)
    448a:	fae43823          	sd	a4,-80(s0)
    448e:	faf43c23          	sd	a5,-72(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4492:	f9040913          	addi	s2,s0,-112
    4496:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
    449a:	00001a17          	auipc	s4,0x1
    449e:	fa6a0a13          	addi	s4,s4,-90 # 5440 <malloc+0x30c>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    44a2:	00001a97          	auipc	s5,0x1
    44a6:	eaea8a93          	addi	s5,s5,-338 # 5350 <malloc+0x21c>
    int fd = open("README", 0);
    44aa:	4581                	li	a1,0
    44ac:	8552                	mv	a0,s4
    44ae:	7e6000ef          	jal	ra,4c94 <open>
    44b2:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    44b4:	04054663          	bltz	a0,4500 <lazy_copy+0xf0>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    44b8:	00093983          	ld	s3,0(s2)
    44bc:	20000613          	li	a2,512
    44c0:	85ce                	mv	a1,s3
    44c2:	7aa000ef          	jal	ra,4c6c <read>
    44c6:	04055663          	bgez	a0,4512 <lazy_copy+0x102>
    close(fd);
    44ca:	8526                	mv	a0,s1
    44cc:	7b0000ef          	jal	ra,4c7c <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    44d0:	60200593          	li	a1,1538
    44d4:	8556                	mv	a0,s5
    44d6:	7be000ef          	jal	ra,4c94 <open>
    44da:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    44dc:	04054463          	bltz	a0,4524 <lazy_copy+0x114>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    44e0:	20000613          	li	a2,512
    44e4:	85ce                	mv	a1,s3
    44e6:	78e000ef          	jal	ra,4c74 <write>
    44ea:	04055663          	bgez	a0,4536 <lazy_copy+0x126>
    close(fd);
    44ee:	8526                	mv	a0,s1
    44f0:	78c000ef          	jal	ra,4c7c <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    44f4:	0921                	addi	s2,s2,8
    44f6:	fb691ae3          	bne	s2,s6,44aa <lazy_copy+0x9a>
  exit(0);
    44fa:	4501                	li	a0,0
    44fc:	758000ef          	jal	ra,4c54 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    4500:	00003517          	auipc	a0,0x3
    4504:	c4850513          	addi	a0,a0,-952 # 7148 <malloc+0x2014>
    4508:	373000ef          	jal	ra,507a <printf>
    450c:	4505                	li	a0,1
    450e:	746000ef          	jal	ra,4c54 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4512:	00003517          	auipc	a0,0x3
    4516:	c4e50513          	addi	a0,a0,-946 # 7160 <malloc+0x202c>
    451a:	361000ef          	jal	ra,507a <printf>
    451e:	4505                	li	a0,1
    4520:	734000ef          	jal	ra,4c54 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4524:	00003517          	auipc	a0,0x3
    4528:	c4c50513          	addi	a0,a0,-948 # 7170 <malloc+0x203c>
    452c:	34f000ef          	jal	ra,507a <printf>
    4530:	4505                	li	a0,1
    4532:	722000ef          	jal	ra,4c54 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4536:	00003517          	auipc	a0,0x3
    453a:	c5250513          	addi	a0,a0,-942 # 7188 <malloc+0x2054>
    453e:	33d000ef          	jal	ra,507a <printf>
    4542:	4505                	li	a0,1
    4544:	710000ef          	jal	ra,4c54 <exit>

0000000000004548 <fsfull>:
{
    4548:	7171                	addi	sp,sp,-176
    454a:	f506                	sd	ra,168(sp)
    454c:	f122                	sd	s0,160(sp)
    454e:	ed26                	sd	s1,152(sp)
    4550:	e94a                	sd	s2,144(sp)
    4552:	e54e                	sd	s3,136(sp)
    4554:	e152                	sd	s4,128(sp)
    4556:	fcd6                	sd	s5,120(sp)
    4558:	f8da                	sd	s6,112(sp)
    455a:	f4de                	sd	s7,104(sp)
    455c:	f0e2                	sd	s8,96(sp)
    455e:	ece6                	sd	s9,88(sp)
    4560:	e8ea                	sd	s10,80(sp)
    4562:	e4ee                	sd	s11,72(sp)
    4564:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4566:	00003517          	auipc	a0,0x3
    456a:	c3a50513          	addi	a0,a0,-966 # 71a0 <malloc+0x206c>
    456e:	30d000ef          	jal	ra,507a <printf>
  for(nfiles = 0; ; nfiles++){
    4572:	4481                	li	s1,0
    name[0] = 'f';
    4574:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4578:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    457c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4580:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4582:	00003c97          	auipc	s9,0x3
    4586:	c2ec8c93          	addi	s9,s9,-978 # 71b0 <malloc+0x207c>
    int total = 0;
    458a:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    458c:	00007a17          	auipc	s4,0x7
    4590:	71ca0a13          	addi	s4,s4,1820 # bca8 <buf>
    name[0] = 'f';
    4594:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4598:	0384c7bb          	divw	a5,s1,s8
    459c:	0307879b          	addiw	a5,a5,48
    45a0:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    45a4:	0384e7bb          	remw	a5,s1,s8
    45a8:	0377c7bb          	divw	a5,a5,s7
    45ac:	0307879b          	addiw	a5,a5,48
    45b0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    45b4:	0374e7bb          	remw	a5,s1,s7
    45b8:	0367c7bb          	divw	a5,a5,s6
    45bc:	0307879b          	addiw	a5,a5,48
    45c0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    45c4:	0364e7bb          	remw	a5,s1,s6
    45c8:	0307879b          	addiw	a5,a5,48
    45cc:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    45d0:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    45d4:	f5040593          	addi	a1,s0,-176
    45d8:	8566                	mv	a0,s9
    45da:	2a1000ef          	jal	ra,507a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    45de:	20200593          	li	a1,514
    45e2:	f5040513          	addi	a0,s0,-176
    45e6:	6ae000ef          	jal	ra,4c94 <open>
    45ea:	892a                	mv	s2,a0
    if(fd < 0){
    45ec:	0a055063          	bgez	a0,468c <fsfull+0x144>
      printf("open %s failed\n", name);
    45f0:	f5040593          	addi	a1,s0,-176
    45f4:	00003517          	auipc	a0,0x3
    45f8:	bcc50513          	addi	a0,a0,-1076 # 71c0 <malloc+0x208c>
    45fc:	27f000ef          	jal	ra,507a <printf>
  while(nfiles >= 0){
    4600:	0604c163          	bltz	s1,4662 <fsfull+0x11a>
    name[0] = 'f';
    4604:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4608:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    460c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4610:	4929                	li	s2,10
  while(nfiles >= 0){
    4612:	5afd                	li	s5,-1
    name[0] = 'f';
    4614:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4618:	0344c7bb          	divw	a5,s1,s4
    461c:	0307879b          	addiw	a5,a5,48
    4620:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4624:	0344e7bb          	remw	a5,s1,s4
    4628:	0337c7bb          	divw	a5,a5,s3
    462c:	0307879b          	addiw	a5,a5,48
    4630:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4634:	0334e7bb          	remw	a5,s1,s3
    4638:	0327c7bb          	divw	a5,a5,s2
    463c:	0307879b          	addiw	a5,a5,48
    4640:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4644:	0324e7bb          	remw	a5,s1,s2
    4648:	0307879b          	addiw	a5,a5,48
    464c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4650:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4654:	f5040513          	addi	a0,s0,-176
    4658:	64c000ef          	jal	ra,4ca4 <unlink>
    nfiles--;
    465c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    465e:	fb549be3          	bne	s1,s5,4614 <fsfull+0xcc>
  printf("fsfull test finished\n");
    4662:	00003517          	auipc	a0,0x3
    4666:	b7e50513          	addi	a0,a0,-1154 # 71e0 <malloc+0x20ac>
    466a:	211000ef          	jal	ra,507a <printf>
}
    466e:	70aa                	ld	ra,168(sp)
    4670:	740a                	ld	s0,160(sp)
    4672:	64ea                	ld	s1,152(sp)
    4674:	694a                	ld	s2,144(sp)
    4676:	69aa                	ld	s3,136(sp)
    4678:	6a0a                	ld	s4,128(sp)
    467a:	7ae6                	ld	s5,120(sp)
    467c:	7b46                	ld	s6,112(sp)
    467e:	7ba6                	ld	s7,104(sp)
    4680:	7c06                	ld	s8,96(sp)
    4682:	6ce6                	ld	s9,88(sp)
    4684:	6d46                	ld	s10,80(sp)
    4686:	6da6                	ld	s11,72(sp)
    4688:	614d                	addi	sp,sp,176
    468a:	8082                	ret
    int total = 0;
    468c:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    468e:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4692:	40000613          	li	a2,1024
    4696:	85d2                	mv	a1,s4
    4698:	854a                	mv	a0,s2
    469a:	5da000ef          	jal	ra,4c74 <write>
      if(cc < BSIZE)
    469e:	00aad563          	bge	s5,a0,46a8 <fsfull+0x160>
      total += cc;
    46a2:	00a989bb          	addw	s3,s3,a0
    while(1){
    46a6:	b7f5                	j	4692 <fsfull+0x14a>
    printf("wrote %d bytes\n", total);
    46a8:	85ce                	mv	a1,s3
    46aa:	00003517          	auipc	a0,0x3
    46ae:	b2650513          	addi	a0,a0,-1242 # 71d0 <malloc+0x209c>
    46b2:	1c9000ef          	jal	ra,507a <printf>
    close(fd);
    46b6:	854a                	mv	a0,s2
    46b8:	5c4000ef          	jal	ra,4c7c <close>
    if(total == 0)
    46bc:	f40982e3          	beqz	s3,4600 <fsfull+0xb8>
  for(nfiles = 0; ; nfiles++){
    46c0:	2485                	addiw	s1,s1,1
    46c2:	bdc9                	j	4594 <fsfull+0x4c>

00000000000046c4 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    46c4:	7179                	addi	sp,sp,-48
    46c6:	f406                	sd	ra,40(sp)
    46c8:	f022                	sd	s0,32(sp)
    46ca:	ec26                	sd	s1,24(sp)
    46cc:	e84a                	sd	s2,16(sp)
    46ce:	1800                	addi	s0,sp,48
    46d0:	84aa                	mv	s1,a0
    46d2:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    46d4:	00003517          	auipc	a0,0x3
    46d8:	b2450513          	addi	a0,a0,-1244 # 71f8 <malloc+0x20c4>
    46dc:	19f000ef          	jal	ra,507a <printf>
  if((pid = fork()) < 0) {
    46e0:	56c000ef          	jal	ra,4c4c <fork>
    46e4:	02054a63          	bltz	a0,4718 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    46e8:	c129                	beqz	a0,472a <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    46ea:	fdc40513          	addi	a0,s0,-36
    46ee:	56e000ef          	jal	ra,4c5c <wait>
    if(xstatus != 0) 
    46f2:	fdc42783          	lw	a5,-36(s0)
    46f6:	cf9d                	beqz	a5,4734 <run+0x70>
      printf("FAILED\n");
    46f8:	00003517          	auipc	a0,0x3
    46fc:	b2850513          	addi	a0,a0,-1240 # 7220 <malloc+0x20ec>
    4700:	17b000ef          	jal	ra,507a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4704:	fdc42503          	lw	a0,-36(s0)
  }
}
    4708:	00153513          	seqz	a0,a0
    470c:	70a2                	ld	ra,40(sp)
    470e:	7402                	ld	s0,32(sp)
    4710:	64e2                	ld	s1,24(sp)
    4712:	6942                	ld	s2,16(sp)
    4714:	6145                	addi	sp,sp,48
    4716:	8082                	ret
    printf("runtest: fork error\n");
    4718:	00003517          	auipc	a0,0x3
    471c:	af050513          	addi	a0,a0,-1296 # 7208 <malloc+0x20d4>
    4720:	15b000ef          	jal	ra,507a <printf>
    exit(1);
    4724:	4505                	li	a0,1
    4726:	52e000ef          	jal	ra,4c54 <exit>
    f(s);
    472a:	854a                	mv	a0,s2
    472c:	9482                	jalr	s1
    exit(0);
    472e:	4501                	li	a0,0
    4730:	524000ef          	jal	ra,4c54 <exit>
      printf("OK\n");
    4734:	00003517          	auipc	a0,0x3
    4738:	af450513          	addi	a0,a0,-1292 # 7228 <malloc+0x20f4>
    473c:	13f000ef          	jal	ra,507a <printf>
    4740:	b7d1                	j	4704 <run+0x40>

0000000000004742 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4742:	7139                	addi	sp,sp,-64
    4744:	fc06                	sd	ra,56(sp)
    4746:	f822                	sd	s0,48(sp)
    4748:	f426                	sd	s1,40(sp)
    474a:	f04a                	sd	s2,32(sp)
    474c:	ec4e                	sd	s3,24(sp)
    474e:	e852                	sd	s4,16(sp)
    4750:	e456                	sd	s5,8(sp)
    4752:	0080                	addi	s0,sp,64
    4754:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4756:	6508                	ld	a0,8(a0)
    4758:	c921                	beqz	a0,47a8 <runtests+0x66>
    475a:	892e                	mv	s2,a1
    475c:	8a32                	mv	s4,a2
  int ntests = 0;
    475e:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4760:	4a89                	li	s5,2
    4762:	a021                	j	476a <runtests+0x28>
  for (struct test *t = tests; t->s != 0; t++) {
    4764:	04c1                	addi	s1,s1,16
    4766:	6488                	ld	a0,8(s1)
    4768:	c515                	beqz	a0,4794 <runtests+0x52>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    476a:	00090663          	beqz	s2,4776 <runtests+0x34>
    476e:	85ca                	mv	a1,s2
    4770:	272000ef          	jal	ra,49e2 <strcmp>
    4774:	f965                	bnez	a0,4764 <runtests+0x22>
      ntests++;
    4776:	2985                	addiw	s3,s3,1
      if(!run(t->f, t->s)){
    4778:	648c                	ld	a1,8(s1)
    477a:	6088                	ld	a0,0(s1)
    477c:	f49ff0ef          	jal	ra,46c4 <run>
    4780:	f175                	bnez	a0,4764 <runtests+0x22>
        if(continuous != 2){
    4782:	ff5a01e3          	beq	s4,s5,4764 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4786:	00003517          	auipc	a0,0x3
    478a:	aaa50513          	addi	a0,a0,-1366 # 7230 <malloc+0x20fc>
    478e:	0ed000ef          	jal	ra,507a <printf>
          return -1;
    4792:	59fd                	li	s3,-1
        }
      }
    }
  }
  return ntests;
}
    4794:	854e                	mv	a0,s3
    4796:	70e2                	ld	ra,56(sp)
    4798:	7442                	ld	s0,48(sp)
    479a:	74a2                	ld	s1,40(sp)
    479c:	7902                	ld	s2,32(sp)
    479e:	69e2                	ld	s3,24(sp)
    47a0:	6a42                	ld	s4,16(sp)
    47a2:	6aa2                	ld	s5,8(sp)
    47a4:	6121                	addi	sp,sp,64
    47a6:	8082                	ret
  int ntests = 0;
    47a8:	4981                	li	s3,0
    47aa:	b7ed                	j	4794 <runtests+0x52>

00000000000047ac <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    47ac:	7179                	addi	sp,sp,-48
    47ae:	f406                	sd	ra,40(sp)
    47b0:	f022                	sd	s0,32(sp)
    47b2:	ec26                	sd	s1,24(sp)
    47b4:	e84a                	sd	s2,16(sp)
    47b6:	e44e                	sd	s3,8(sp)
    47b8:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    47ba:	4501                	li	a0,0
    47bc:	464000ef          	jal	ra,4c20 <sbrk>
    47c0:	89aa                	mv	s3,a0
  int n = 0;
    47c2:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    if(a == SBRK_ERROR){
    47c4:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    47c6:	6505                	lui	a0,0x1
    47c8:	458000ef          	jal	ra,4c20 <sbrk>
    if(a == SBRK_ERROR){
    47cc:	01250463          	beq	a0,s2,47d4 <countfree+0x28>
      break;
    }
    n += 1;
    47d0:	2485                	addiw	s1,s1,1
  while(1){
    47d2:	bfd5                	j	47c6 <countfree+0x1a>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    47d4:	4501                	li	a0,0
    47d6:	44a000ef          	jal	ra,4c20 <sbrk>
    47da:	40a9853b          	subw	a0,s3,a0
    47de:	442000ef          	jal	ra,4c20 <sbrk>
  return n;
}
    47e2:	8526                	mv	a0,s1
    47e4:	70a2                	ld	ra,40(sp)
    47e6:	7402                	ld	s0,32(sp)
    47e8:	64e2                	ld	s1,24(sp)
    47ea:	6942                	ld	s2,16(sp)
    47ec:	69a2                	ld	s3,8(sp)
    47ee:	6145                	addi	sp,sp,48
    47f0:	8082                	ret

00000000000047f2 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    47f2:	7159                	addi	sp,sp,-112
    47f4:	f486                	sd	ra,104(sp)
    47f6:	f0a2                	sd	s0,96(sp)
    47f8:	eca6                	sd	s1,88(sp)
    47fa:	e8ca                	sd	s2,80(sp)
    47fc:	e4ce                	sd	s3,72(sp)
    47fe:	e0d2                	sd	s4,64(sp)
    4800:	fc56                	sd	s5,56(sp)
    4802:	f85a                	sd	s6,48(sp)
    4804:	f45e                	sd	s7,40(sp)
    4806:	f062                	sd	s8,32(sp)
    4808:	ec66                	sd	s9,24(sp)
    480a:	e86a                	sd	s10,16(sp)
    480c:	e46e                	sd	s11,8(sp)
    480e:	1880                	addi	s0,sp,112
    4810:	8aaa                	mv	s5,a0
    4812:	89ae                	mv	s3,a1
    4814:	8a32                	mv	s4,a2
  do {
    printf("usertests starting\n");
    4816:	00003b97          	auipc	s7,0x3
    481a:	a32b8b93          	addi	s7,s7,-1486 # 7248 <malloc+0x2114>
    int free0 = countfree();
    int free1 = 0;
    int ntests = 0;
    int n;
    n = runtests(quicktests, justone, continuous);
    481e:	00003b17          	auipc	s6,0x3
    4822:	7f2b0b13          	addi	s6,s6,2034 # 8010 <quicktests>
    if (n < 0) {
      if(continuous != 2) {
    4826:	4c09                	li	s8,2
      } else {
        ntests += n;
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4828:	00003d17          	auipc	s10,0x3
    482c:	a58d0d13          	addi	s10,s10,-1448 # 7280 <malloc+0x214c>
      n = runtests(slowtests, justone, continuous);
    4830:	00004c97          	auipc	s9,0x4
    4834:	be0c8c93          	addi	s9,s9,-1056 # 8410 <slowtests>
        printf("usertests slow tests starting\n");
    4838:	00003d97          	auipc	s11,0x3
    483c:	a28d8d93          	addi	s11,s11,-1496 # 7260 <malloc+0x212c>
    4840:	a835                	j	487c <drivetests+0x8a>
      if(continuous != 2) {
    4842:	09899a63          	bne	s3,s8,48d6 <drivetests+0xe4>
    int ntests = 0;
    4846:	4481                	li	s1,0
    4848:	a881                	j	4898 <drivetests+0xa6>
        printf("usertests slow tests starting\n");
    484a:	856e                	mv	a0,s11
    484c:	02f000ef          	jal	ra,507a <printf>
    4850:	a881                	j	48a0 <drivetests+0xae>
        if(continuous != 2) {
    4852:	09899463          	bne	s3,s8,48da <drivetests+0xe8>
    if((free1 = countfree()) < free0) {
    4856:	f57ff0ef          	jal	ra,47ac <countfree>
    485a:	01255c63          	bge	a0,s2,4872 <drivetests+0x80>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    485e:	864a                	mv	a2,s2
    4860:	85aa                	mv	a1,a0
    4862:	856a                	mv	a0,s10
    4864:	017000ef          	jal	ra,507a <printf>
      if(continuous != 2) {
    4868:	a8a1                	j	48c0 <drivetests+0xce>
    if((free1 = countfree()) < free0) {
    486a:	f43ff0ef          	jal	ra,47ac <countfree>
    486e:	05254263          	blt	a0,s2,48b2 <drivetests+0xc0>
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4872:	000a0363          	beqz	s4,4878 <drivetests+0x86>
    4876:	c8a1                	beqz	s1,48c6 <drivetests+0xd4>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4878:	06098563          	beqz	s3,48e2 <drivetests+0xf0>
    printf("usertests starting\n");
    487c:	855e                	mv	a0,s7
    487e:	7fc000ef          	jal	ra,507a <printf>
    int free0 = countfree();
    4882:	f2bff0ef          	jal	ra,47ac <countfree>
    4886:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4888:	864e                	mv	a2,s3
    488a:	85d2                	mv	a1,s4
    488c:	855a                	mv	a0,s6
    488e:	eb5ff0ef          	jal	ra,4742 <runtests>
    4892:	84aa                	mv	s1,a0
    if (n < 0) {
    4894:	fa0547e3          	bltz	a0,4842 <drivetests+0x50>
    if(!quick) {
    4898:	fc0a99e3          	bnez	s5,486a <drivetests+0x78>
      if (justone == 0)
    489c:	fa0a07e3          	beqz	s4,484a <drivetests+0x58>
      n = runtests(slowtests, justone, continuous);
    48a0:	864e                	mv	a2,s3
    48a2:	85d2                	mv	a1,s4
    48a4:	8566                	mv	a0,s9
    48a6:	e9dff0ef          	jal	ra,4742 <runtests>
      if (n < 0) {
    48aa:	fa0544e3          	bltz	a0,4852 <drivetests+0x60>
        ntests += n;
    48ae:	9ca9                	addw	s1,s1,a0
    48b0:	bf6d                	j	486a <drivetests+0x78>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    48b2:	864a                	mv	a2,s2
    48b4:	85aa                	mv	a1,a0
    48b6:	856a                	mv	a0,s10
    48b8:	7c2000ef          	jal	ra,507a <printf>
      if(continuous != 2) {
    48bc:	03899163          	bne	s3,s8,48de <drivetests+0xec>
    if (justone != 0 && ntests == 0) {
    48c0:	fa0a0ee3          	beqz	s4,487c <drivetests+0x8a>
    48c4:	fcc5                	bnez	s1,487c <drivetests+0x8a>
      printf("NO TESTS EXECUTED\n");
    48c6:	00003517          	auipc	a0,0x3
    48ca:	9ea50513          	addi	a0,a0,-1558 # 72b0 <malloc+0x217c>
    48ce:	7ac000ef          	jal	ra,507a <printf>
      return 1;
    48d2:	4505                	li	a0,1
    48d4:	a801                	j	48e4 <drivetests+0xf2>
        return 1;
    48d6:	4505                	li	a0,1
    48d8:	a031                	j	48e4 <drivetests+0xf2>
          return 1;
    48da:	4505                	li	a0,1
    48dc:	a021                	j	48e4 <drivetests+0xf2>
        return 1;
    48de:	4505                	li	a0,1
    48e0:	a011                	j	48e4 <drivetests+0xf2>
  return 0;
    48e2:	854e                	mv	a0,s3
}
    48e4:	70a6                	ld	ra,104(sp)
    48e6:	7406                	ld	s0,96(sp)
    48e8:	64e6                	ld	s1,88(sp)
    48ea:	6946                	ld	s2,80(sp)
    48ec:	69a6                	ld	s3,72(sp)
    48ee:	6a06                	ld	s4,64(sp)
    48f0:	7ae2                	ld	s5,56(sp)
    48f2:	7b42                	ld	s6,48(sp)
    48f4:	7ba2                	ld	s7,40(sp)
    48f6:	7c02                	ld	s8,32(sp)
    48f8:	6ce2                	ld	s9,24(sp)
    48fa:	6d42                	ld	s10,16(sp)
    48fc:	6da2                	ld	s11,8(sp)
    48fe:	6165                	addi	sp,sp,112
    4900:	8082                	ret

0000000000004902 <main>:

int
main(int argc, char *argv[])
{
    4902:	1101                	addi	sp,sp,-32
    4904:	ec06                	sd	ra,24(sp)
    4906:	e822                	sd	s0,16(sp)
    4908:	e426                	sd	s1,8(sp)
    490a:	e04a                	sd	s2,0(sp)
    490c:	1000                	addi	s0,sp,32
    490e:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4910:	4789                	li	a5,2
    4912:	00f50f63          	beq	a0,a5,4930 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4916:	4785                	li	a5,1
    4918:	06a7c363          	blt	a5,a0,497e <main+0x7c>
  char *justone = 0;
    491c:	4601                	li	a2,0
  int quick = 0;
    491e:	4501                	li	a0,0
  int continuous = 0;
    4920:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4922:	85a6                	mv	a1,s1
    4924:	ecfff0ef          	jal	ra,47f2 <drivetests>
    4928:	cd2d                	beqz	a0,49a2 <main+0xa0>
    exit(1);
    492a:	4505                	li	a0,1
    492c:	328000ef          	jal	ra,4c54 <exit>
    4930:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4932:	00003597          	auipc	a1,0x3
    4936:	99658593          	addi	a1,a1,-1642 # 72c8 <malloc+0x2194>
    493a:	00893503          	ld	a0,8(s2)
    493e:	0a4000ef          	jal	ra,49e2 <strcmp>
    4942:	c539                	beqz	a0,4990 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4944:	00003597          	auipc	a1,0x3
    4948:	9dc58593          	addi	a1,a1,-1572 # 7320 <malloc+0x21ec>
    494c:	00893503          	ld	a0,8(s2)
    4950:	092000ef          	jal	ra,49e2 <strcmp>
    4954:	c521                	beqz	a0,499c <main+0x9a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4956:	00003597          	auipc	a1,0x3
    495a:	9c258593          	addi	a1,a1,-1598 # 7318 <malloc+0x21e4>
    495e:	00893503          	ld	a0,8(s2)
    4962:	080000ef          	jal	ra,49e2 <strcmp>
    4966:	c90d                	beqz	a0,4998 <main+0x96>
  } else if(argc == 2 && argv[1][0] != '-'){
    4968:	00893603          	ld	a2,8(s2)
    496c:	00064703          	lbu	a4,0(a2) # 1000 <pgbug+0x22>
    4970:	02d00793          	li	a5,45
    4974:	00f70563          	beq	a4,a5,497e <main+0x7c>
  int quick = 0;
    4978:	4501                	li	a0,0
  int continuous = 0;
    497a:	4481                	li	s1,0
    497c:	b75d                	j	4922 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    497e:	00003517          	auipc	a0,0x3
    4982:	95250513          	addi	a0,a0,-1710 # 72d0 <malloc+0x219c>
    4986:	6f4000ef          	jal	ra,507a <printf>
    exit(1);
    498a:	4505                	li	a0,1
    498c:	2c8000ef          	jal	ra,4c54 <exit>
  int continuous = 0;
    4990:	84aa                	mv	s1,a0
  char *justone = 0;
    4992:	4601                	li	a2,0
    quick = 1;
    4994:	4505                	li	a0,1
    4996:	b771                	j	4922 <main+0x20>
  char *justone = 0;
    4998:	4601                	li	a2,0
    499a:	b761                	j	4922 <main+0x20>
    499c:	4601                	li	a2,0
    continuous = 1;
    499e:	4485                	li	s1,1
    49a0:	b749                	j	4922 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    49a2:	00003517          	auipc	a0,0x3
    49a6:	95e50513          	addi	a0,a0,-1698 # 7300 <malloc+0x21cc>
    49aa:	6d0000ef          	jal	ra,507a <printf>
  exit(0);
    49ae:	4501                	li	a0,0
    49b0:	2a4000ef          	jal	ra,4c54 <exit>

00000000000049b4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    49b4:	1141                	addi	sp,sp,-16
    49b6:	e406                	sd	ra,8(sp)
    49b8:	e022                	sd	s0,0(sp)
    49ba:	0800                	addi	s0,sp,16
  extern int main();
  main();
    49bc:	f47ff0ef          	jal	ra,4902 <main>
  exit(0);
    49c0:	4501                	li	a0,0
    49c2:	292000ef          	jal	ra,4c54 <exit>

00000000000049c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    49c6:	1141                	addi	sp,sp,-16
    49c8:	e422                	sd	s0,8(sp)
    49ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    49cc:	87aa                	mv	a5,a0
    49ce:	0585                	addi	a1,a1,1
    49d0:	0785                	addi	a5,a5,1
    49d2:	fff5c703          	lbu	a4,-1(a1)
    49d6:	fee78fa3          	sb	a4,-1(a5)
    49da:	fb75                	bnez	a4,49ce <strcpy+0x8>
    ;
  return os;
}
    49dc:	6422                	ld	s0,8(sp)
    49de:	0141                	addi	sp,sp,16
    49e0:	8082                	ret

00000000000049e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    49e2:	1141                	addi	sp,sp,-16
    49e4:	e422                	sd	s0,8(sp)
    49e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    49e8:	00054783          	lbu	a5,0(a0)
    49ec:	cb91                	beqz	a5,4a00 <strcmp+0x1e>
    49ee:	0005c703          	lbu	a4,0(a1)
    49f2:	00f71763          	bne	a4,a5,4a00 <strcmp+0x1e>
    p++, q++;
    49f6:	0505                	addi	a0,a0,1
    49f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    49fa:	00054783          	lbu	a5,0(a0)
    49fe:	fbe5                	bnez	a5,49ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4a00:	0005c503          	lbu	a0,0(a1)
}
    4a04:	40a7853b          	subw	a0,a5,a0
    4a08:	6422                	ld	s0,8(sp)
    4a0a:	0141                	addi	sp,sp,16
    4a0c:	8082                	ret

0000000000004a0e <strlen>:

uint
strlen(const char *s)
{
    4a0e:	1141                	addi	sp,sp,-16
    4a10:	e422                	sd	s0,8(sp)
    4a12:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4a14:	00054783          	lbu	a5,0(a0)
    4a18:	cf91                	beqz	a5,4a34 <strlen+0x26>
    4a1a:	0505                	addi	a0,a0,1
    4a1c:	87aa                	mv	a5,a0
    4a1e:	4685                	li	a3,1
    4a20:	9e89                	subw	a3,a3,a0
    4a22:	00f6853b          	addw	a0,a3,a5
    4a26:	0785                	addi	a5,a5,1
    4a28:	fff7c703          	lbu	a4,-1(a5)
    4a2c:	fb7d                	bnez	a4,4a22 <strlen+0x14>
    ;
  return n;
}
    4a2e:	6422                	ld	s0,8(sp)
    4a30:	0141                	addi	sp,sp,16
    4a32:	8082                	ret
  for(n = 0; s[n]; n++)
    4a34:	4501                	li	a0,0
    4a36:	bfe5                	j	4a2e <strlen+0x20>

0000000000004a38 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4a38:	1141                	addi	sp,sp,-16
    4a3a:	e422                	sd	s0,8(sp)
    4a3c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4a3e:	ce09                	beqz	a2,4a58 <memset+0x20>
    4a40:	87aa                	mv	a5,a0
    4a42:	fff6071b          	addiw	a4,a2,-1
    4a46:	1702                	slli	a4,a4,0x20
    4a48:	9301                	srli	a4,a4,0x20
    4a4a:	0705                	addi	a4,a4,1
    4a4c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    4a4e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4a52:	0785                	addi	a5,a5,1
    4a54:	fee79de3          	bne	a5,a4,4a4e <memset+0x16>
  }
  return dst;
}
    4a58:	6422                	ld	s0,8(sp)
    4a5a:	0141                	addi	sp,sp,16
    4a5c:	8082                	ret

0000000000004a5e <strchr>:

char*
strchr(const char *s, char c)
{
    4a5e:	1141                	addi	sp,sp,-16
    4a60:	e422                	sd	s0,8(sp)
    4a62:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4a64:	00054783          	lbu	a5,0(a0)
    4a68:	cb99                	beqz	a5,4a7e <strchr+0x20>
    if(*s == c)
    4a6a:	00f58763          	beq	a1,a5,4a78 <strchr+0x1a>
  for(; *s; s++)
    4a6e:	0505                	addi	a0,a0,1
    4a70:	00054783          	lbu	a5,0(a0)
    4a74:	fbfd                	bnez	a5,4a6a <strchr+0xc>
      return (char*)s;
  return 0;
    4a76:	4501                	li	a0,0
}
    4a78:	6422                	ld	s0,8(sp)
    4a7a:	0141                	addi	sp,sp,16
    4a7c:	8082                	ret
  return 0;
    4a7e:	4501                	li	a0,0
    4a80:	bfe5                	j	4a78 <strchr+0x1a>

0000000000004a82 <gets>:

char*
gets(char *buf, int max)
{
    4a82:	711d                	addi	sp,sp,-96
    4a84:	ec86                	sd	ra,88(sp)
    4a86:	e8a2                	sd	s0,80(sp)
    4a88:	e4a6                	sd	s1,72(sp)
    4a8a:	e0ca                	sd	s2,64(sp)
    4a8c:	fc4e                	sd	s3,56(sp)
    4a8e:	f852                	sd	s4,48(sp)
    4a90:	f456                	sd	s5,40(sp)
    4a92:	f05a                	sd	s6,32(sp)
    4a94:	ec5e                	sd	s7,24(sp)
    4a96:	1080                	addi	s0,sp,96
    4a98:	8baa                	mv	s7,a0
    4a9a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4a9c:	892a                	mv	s2,a0
    4a9e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4aa0:	4aa9                	li	s5,10
    4aa2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4aa4:	89a6                	mv	s3,s1
    4aa6:	2485                	addiw	s1,s1,1
    4aa8:	0344d663          	bge	s1,s4,4ad4 <gets+0x52>
    cc = read(0, &c, 1);
    4aac:	4605                	li	a2,1
    4aae:	faf40593          	addi	a1,s0,-81
    4ab2:	4501                	li	a0,0
    4ab4:	1b8000ef          	jal	ra,4c6c <read>
    if(cc < 1)
    4ab8:	00a05e63          	blez	a0,4ad4 <gets+0x52>
    buf[i++] = c;
    4abc:	faf44783          	lbu	a5,-81(s0)
    4ac0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4ac4:	01578763          	beq	a5,s5,4ad2 <gets+0x50>
    4ac8:	0905                	addi	s2,s2,1
    4aca:	fd679de3          	bne	a5,s6,4aa4 <gets+0x22>
  for(i=0; i+1 < max; ){
    4ace:	89a6                	mv	s3,s1
    4ad0:	a011                	j	4ad4 <gets+0x52>
    4ad2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4ad4:	99de                	add	s3,s3,s7
    4ad6:	00098023          	sb	zero,0(s3) # 1000000 <base+0xff1358>
  return buf;
}
    4ada:	855e                	mv	a0,s7
    4adc:	60e6                	ld	ra,88(sp)
    4ade:	6446                	ld	s0,80(sp)
    4ae0:	64a6                	ld	s1,72(sp)
    4ae2:	6906                	ld	s2,64(sp)
    4ae4:	79e2                	ld	s3,56(sp)
    4ae6:	7a42                	ld	s4,48(sp)
    4ae8:	7aa2                	ld	s5,40(sp)
    4aea:	7b02                	ld	s6,32(sp)
    4aec:	6be2                	ld	s7,24(sp)
    4aee:	6125                	addi	sp,sp,96
    4af0:	8082                	ret

0000000000004af2 <stat>:

int
stat(const char *n, struct stat *st)
{
    4af2:	1101                	addi	sp,sp,-32
    4af4:	ec06                	sd	ra,24(sp)
    4af6:	e822                	sd	s0,16(sp)
    4af8:	e426                	sd	s1,8(sp)
    4afa:	e04a                	sd	s2,0(sp)
    4afc:	1000                	addi	s0,sp,32
    4afe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4b00:	4581                	li	a1,0
    4b02:	192000ef          	jal	ra,4c94 <open>
  if(fd < 0)
    4b06:	02054163          	bltz	a0,4b28 <stat+0x36>
    4b0a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4b0c:	85ca                	mv	a1,s2
    4b0e:	19e000ef          	jal	ra,4cac <fstat>
    4b12:	892a                	mv	s2,a0
  close(fd);
    4b14:	8526                	mv	a0,s1
    4b16:	166000ef          	jal	ra,4c7c <close>
  return r;
}
    4b1a:	854a                	mv	a0,s2
    4b1c:	60e2                	ld	ra,24(sp)
    4b1e:	6442                	ld	s0,16(sp)
    4b20:	64a2                	ld	s1,8(sp)
    4b22:	6902                	ld	s2,0(sp)
    4b24:	6105                	addi	sp,sp,32
    4b26:	8082                	ret
    return -1;
    4b28:	597d                	li	s2,-1
    4b2a:	bfc5                	j	4b1a <stat+0x28>

0000000000004b2c <atoi>:

int
atoi(const char *s)
{
    4b2c:	1141                	addi	sp,sp,-16
    4b2e:	e422                	sd	s0,8(sp)
    4b30:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4b32:	00054603          	lbu	a2,0(a0)
    4b36:	fd06079b          	addiw	a5,a2,-48
    4b3a:	0ff7f793          	andi	a5,a5,255
    4b3e:	4725                	li	a4,9
    4b40:	02f76963          	bltu	a4,a5,4b72 <atoi+0x46>
    4b44:	86aa                	mv	a3,a0
  n = 0;
    4b46:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    4b48:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    4b4a:	0685                	addi	a3,a3,1
    4b4c:	0025179b          	slliw	a5,a0,0x2
    4b50:	9fa9                	addw	a5,a5,a0
    4b52:	0017979b          	slliw	a5,a5,0x1
    4b56:	9fb1                	addw	a5,a5,a2
    4b58:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4b5c:	0006c603          	lbu	a2,0(a3) # 40000 <base+0x31358>
    4b60:	fd06071b          	addiw	a4,a2,-48
    4b64:	0ff77713          	andi	a4,a4,255
    4b68:	fee5f1e3          	bgeu	a1,a4,4b4a <atoi+0x1e>
  return n;
}
    4b6c:	6422                	ld	s0,8(sp)
    4b6e:	0141                	addi	sp,sp,16
    4b70:	8082                	ret
  n = 0;
    4b72:	4501                	li	a0,0
    4b74:	bfe5                	j	4b6c <atoi+0x40>

0000000000004b76 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4b76:	1141                	addi	sp,sp,-16
    4b78:	e422                	sd	s0,8(sp)
    4b7a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4b7c:	02b57663          	bgeu	a0,a1,4ba8 <memmove+0x32>
    while(n-- > 0)
    4b80:	02c05163          	blez	a2,4ba2 <memmove+0x2c>
    4b84:	fff6079b          	addiw	a5,a2,-1
    4b88:	1782                	slli	a5,a5,0x20
    4b8a:	9381                	srli	a5,a5,0x20
    4b8c:	0785                	addi	a5,a5,1
    4b8e:	97aa                	add	a5,a5,a0
  dst = vdst;
    4b90:	872a                	mv	a4,a0
      *dst++ = *src++;
    4b92:	0585                	addi	a1,a1,1
    4b94:	0705                	addi	a4,a4,1
    4b96:	fff5c683          	lbu	a3,-1(a1)
    4b9a:	fed70fa3          	sb	a3,-1(a4) # ffffff <base+0xff1357>
    while(n-- > 0)
    4b9e:	fee79ae3          	bne	a5,a4,4b92 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4ba2:	6422                	ld	s0,8(sp)
    4ba4:	0141                	addi	sp,sp,16
    4ba6:	8082                	ret
    dst += n;
    4ba8:	00c50733          	add	a4,a0,a2
    src += n;
    4bac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4bae:	fec05ae3          	blez	a2,4ba2 <memmove+0x2c>
    4bb2:	fff6079b          	addiw	a5,a2,-1
    4bb6:	1782                	slli	a5,a5,0x20
    4bb8:	9381                	srli	a5,a5,0x20
    4bba:	fff7c793          	not	a5,a5
    4bbe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4bc0:	15fd                	addi	a1,a1,-1
    4bc2:	177d                	addi	a4,a4,-1
    4bc4:	0005c683          	lbu	a3,0(a1)
    4bc8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4bcc:	fee79ae3          	bne	a5,a4,4bc0 <memmove+0x4a>
    4bd0:	bfc9                	j	4ba2 <memmove+0x2c>

0000000000004bd2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4bd2:	1141                	addi	sp,sp,-16
    4bd4:	e422                	sd	s0,8(sp)
    4bd6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4bd8:	ca05                	beqz	a2,4c08 <memcmp+0x36>
    4bda:	fff6069b          	addiw	a3,a2,-1
    4bde:	1682                	slli	a3,a3,0x20
    4be0:	9281                	srli	a3,a3,0x20
    4be2:	0685                	addi	a3,a3,1
    4be4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4be6:	00054783          	lbu	a5,0(a0)
    4bea:	0005c703          	lbu	a4,0(a1)
    4bee:	00e79863          	bne	a5,a4,4bfe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4bf2:	0505                	addi	a0,a0,1
    p2++;
    4bf4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4bf6:	fed518e3          	bne	a0,a3,4be6 <memcmp+0x14>
  }
  return 0;
    4bfa:	4501                	li	a0,0
    4bfc:	a019                	j	4c02 <memcmp+0x30>
      return *p1 - *p2;
    4bfe:	40e7853b          	subw	a0,a5,a4
}
    4c02:	6422                	ld	s0,8(sp)
    4c04:	0141                	addi	sp,sp,16
    4c06:	8082                	ret
  return 0;
    4c08:	4501                	li	a0,0
    4c0a:	bfe5                	j	4c02 <memcmp+0x30>

0000000000004c0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4c0c:	1141                	addi	sp,sp,-16
    4c0e:	e406                	sd	ra,8(sp)
    4c10:	e022                	sd	s0,0(sp)
    4c12:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4c14:	f63ff0ef          	jal	ra,4b76 <memmove>
}
    4c18:	60a2                	ld	ra,8(sp)
    4c1a:	6402                	ld	s0,0(sp)
    4c1c:	0141                	addi	sp,sp,16
    4c1e:	8082                	ret

0000000000004c20 <sbrk>:

char *
sbrk(int n) {
    4c20:	1141                	addi	sp,sp,-16
    4c22:	e406                	sd	ra,8(sp)
    4c24:	e022                	sd	s0,0(sp)
    4c26:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4c28:	4585                	li	a1,1
    4c2a:	0b2000ef          	jal	ra,4cdc <sys_sbrk>
}
    4c2e:	60a2                	ld	ra,8(sp)
    4c30:	6402                	ld	s0,0(sp)
    4c32:	0141                	addi	sp,sp,16
    4c34:	8082                	ret

0000000000004c36 <sbrklazy>:

char *
sbrklazy(int n) {
    4c36:	1141                	addi	sp,sp,-16
    4c38:	e406                	sd	ra,8(sp)
    4c3a:	e022                	sd	s0,0(sp)
    4c3c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4c3e:	4589                	li	a1,2
    4c40:	09c000ef          	jal	ra,4cdc <sys_sbrk>
}
    4c44:	60a2                	ld	ra,8(sp)
    4c46:	6402                	ld	s0,0(sp)
    4c48:	0141                	addi	sp,sp,16
    4c4a:	8082                	ret

0000000000004c4c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4c4c:	4885                	li	a7,1
 ecall
    4c4e:	00000073          	ecall
 ret
    4c52:	8082                	ret

0000000000004c54 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4c54:	4889                	li	a7,2
 ecall
    4c56:	00000073          	ecall
 ret
    4c5a:	8082                	ret

0000000000004c5c <wait>:
.global wait
wait:
 li a7, SYS_wait
    4c5c:	488d                	li	a7,3
 ecall
    4c5e:	00000073          	ecall
 ret
    4c62:	8082                	ret

0000000000004c64 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4c64:	4891                	li	a7,4
 ecall
    4c66:	00000073          	ecall
 ret
    4c6a:	8082                	ret

0000000000004c6c <read>:
.global read
read:
 li a7, SYS_read
    4c6c:	4895                	li	a7,5
 ecall
    4c6e:	00000073          	ecall
 ret
    4c72:	8082                	ret

0000000000004c74 <write>:
.global write
write:
 li a7, SYS_write
    4c74:	48c1                	li	a7,16
 ecall
    4c76:	00000073          	ecall
 ret
    4c7a:	8082                	ret

0000000000004c7c <close>:
.global close
close:
 li a7, SYS_close
    4c7c:	48d5                	li	a7,21
 ecall
    4c7e:	00000073          	ecall
 ret
    4c82:	8082                	ret

0000000000004c84 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4c84:	4899                	li	a7,6
 ecall
    4c86:	00000073          	ecall
 ret
    4c8a:	8082                	ret

0000000000004c8c <exec>:
.global exec
exec:
 li a7, SYS_exec
    4c8c:	489d                	li	a7,7
 ecall
    4c8e:	00000073          	ecall
 ret
    4c92:	8082                	ret

0000000000004c94 <open>:
.global open
open:
 li a7, SYS_open
    4c94:	48bd                	li	a7,15
 ecall
    4c96:	00000073          	ecall
 ret
    4c9a:	8082                	ret

0000000000004c9c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4c9c:	48c5                	li	a7,17
 ecall
    4c9e:	00000073          	ecall
 ret
    4ca2:	8082                	ret

0000000000004ca4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4ca4:	48c9                	li	a7,18
 ecall
    4ca6:	00000073          	ecall
 ret
    4caa:	8082                	ret

0000000000004cac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4cac:	48a1                	li	a7,8
 ecall
    4cae:	00000073          	ecall
 ret
    4cb2:	8082                	ret

0000000000004cb4 <link>:
.global link
link:
 li a7, SYS_link
    4cb4:	48cd                	li	a7,19
 ecall
    4cb6:	00000073          	ecall
 ret
    4cba:	8082                	ret

0000000000004cbc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4cbc:	48d1                	li	a7,20
 ecall
    4cbe:	00000073          	ecall
 ret
    4cc2:	8082                	ret

0000000000004cc4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4cc4:	48a5                	li	a7,9
 ecall
    4cc6:	00000073          	ecall
 ret
    4cca:	8082                	ret

0000000000004ccc <dup>:
.global dup
dup:
 li a7, SYS_dup
    4ccc:	48a9                	li	a7,10
 ecall
    4cce:	00000073          	ecall
 ret
    4cd2:	8082                	ret

0000000000004cd4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4cd4:	48ad                	li	a7,11
 ecall
    4cd6:	00000073          	ecall
 ret
    4cda:	8082                	ret

0000000000004cdc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4cdc:	48b1                	li	a7,12
 ecall
    4cde:	00000073          	ecall
 ret
    4ce2:	8082                	ret

0000000000004ce4 <pause>:
.global pause
pause:
 li a7, SYS_pause
    4ce4:	48b5                	li	a7,13
 ecall
    4ce6:	00000073          	ecall
 ret
    4cea:	8082                	ret

0000000000004cec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4cec:	48b9                	li	a7,14
 ecall
    4cee:	00000073          	ecall
 ret
    4cf2:	8082                	ret

0000000000004cf4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4cf4:	1101                	addi	sp,sp,-32
    4cf6:	ec06                	sd	ra,24(sp)
    4cf8:	e822                	sd	s0,16(sp)
    4cfa:	1000                	addi	s0,sp,32
    4cfc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4d00:	4605                	li	a2,1
    4d02:	fef40593          	addi	a1,s0,-17
    4d06:	f6fff0ef          	jal	ra,4c74 <write>
}
    4d0a:	60e2                	ld	ra,24(sp)
    4d0c:	6442                	ld	s0,16(sp)
    4d0e:	6105                	addi	sp,sp,32
    4d10:	8082                	ret

0000000000004d12 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4d12:	715d                	addi	sp,sp,-80
    4d14:	e486                	sd	ra,72(sp)
    4d16:	e0a2                	sd	s0,64(sp)
    4d18:	fc26                	sd	s1,56(sp)
    4d1a:	f84a                	sd	s2,48(sp)
    4d1c:	f44e                	sd	s3,40(sp)
    4d1e:	0880                	addi	s0,sp,80
    4d20:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4d22:	c299                	beqz	a3,4d28 <printint+0x16>
    4d24:	0805c663          	bltz	a1,4db0 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4d28:	2581                	sext.w	a1,a1
  neg = 0;
    4d2a:	4881                	li	a7,0
    4d2c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
    4d30:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4d32:	2601                	sext.w	a2,a2
    4d34:	00003517          	auipc	a0,0x3
    4d38:	a0c50513          	addi	a0,a0,-1524 # 7740 <digits>
    4d3c:	883a                	mv	a6,a4
    4d3e:	2705                	addiw	a4,a4,1
    4d40:	02c5f7bb          	remuw	a5,a1,a2
    4d44:	1782                	slli	a5,a5,0x20
    4d46:	9381                	srli	a5,a5,0x20
    4d48:	97aa                	add	a5,a5,a0
    4d4a:	0007c783          	lbu	a5,0(a5)
    4d4e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4d52:	0005879b          	sext.w	a5,a1
    4d56:	02c5d5bb          	divuw	a1,a1,a2
    4d5a:	0685                	addi	a3,a3,1
    4d5c:	fec7f0e3          	bgeu	a5,a2,4d3c <printint+0x2a>
  if(neg)
    4d60:	00088b63          	beqz	a7,4d76 <printint+0x64>
    buf[i++] = '-';
    4d64:	fd040793          	addi	a5,s0,-48
    4d68:	973e                	add	a4,a4,a5
    4d6a:	02d00793          	li	a5,45
    4d6e:	fef70423          	sb	a5,-24(a4)
    4d72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4d76:	02e05663          	blez	a4,4da2 <printint+0x90>
    4d7a:	fb840793          	addi	a5,s0,-72
    4d7e:	00e78933          	add	s2,a5,a4
    4d82:	fff78993          	addi	s3,a5,-1
    4d86:	99ba                	add	s3,s3,a4
    4d88:	377d                	addiw	a4,a4,-1
    4d8a:	1702                	slli	a4,a4,0x20
    4d8c:	9301                	srli	a4,a4,0x20
    4d8e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4d92:	fff94583          	lbu	a1,-1(s2)
    4d96:	8526                	mv	a0,s1
    4d98:	f5dff0ef          	jal	ra,4cf4 <putc>
  while(--i >= 0)
    4d9c:	197d                	addi	s2,s2,-1
    4d9e:	ff391ae3          	bne	s2,s3,4d92 <printint+0x80>
}
    4da2:	60a6                	ld	ra,72(sp)
    4da4:	6406                	ld	s0,64(sp)
    4da6:	74e2                	ld	s1,56(sp)
    4da8:	7942                	ld	s2,48(sp)
    4daa:	79a2                	ld	s3,40(sp)
    4dac:	6161                	addi	sp,sp,80
    4dae:	8082                	ret
    x = -xx;
    4db0:	40b005bb          	negw	a1,a1
    neg = 1;
    4db4:	4885                	li	a7,1
    x = -xx;
    4db6:	bf9d                	j	4d2c <printint+0x1a>

0000000000004db8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4db8:	7119                	addi	sp,sp,-128
    4dba:	fc86                	sd	ra,120(sp)
    4dbc:	f8a2                	sd	s0,112(sp)
    4dbe:	f4a6                	sd	s1,104(sp)
    4dc0:	f0ca                	sd	s2,96(sp)
    4dc2:	ecce                	sd	s3,88(sp)
    4dc4:	e8d2                	sd	s4,80(sp)
    4dc6:	e4d6                	sd	s5,72(sp)
    4dc8:	e0da                	sd	s6,64(sp)
    4dca:	fc5e                	sd	s7,56(sp)
    4dcc:	f862                	sd	s8,48(sp)
    4dce:	f466                	sd	s9,40(sp)
    4dd0:	f06a                	sd	s10,32(sp)
    4dd2:	ec6e                	sd	s11,24(sp)
    4dd4:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4dd6:	0005c903          	lbu	s2,0(a1)
    4dda:	24090c63          	beqz	s2,5032 <vprintf+0x27a>
    4dde:	8b2a                	mv	s6,a0
    4de0:	8a2e                	mv	s4,a1
    4de2:	8bb2                	mv	s7,a2
  state = 0;
    4de4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4de6:	4481                	li	s1,0
    4de8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4dea:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4dee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4df2:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4df6:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4dfa:	00003c97          	auipc	s9,0x3
    4dfe:	946c8c93          	addi	s9,s9,-1722 # 7740 <digits>
    4e02:	a005                	j	4e22 <vprintf+0x6a>
        putc(fd, c0);
    4e04:	85ca                	mv	a1,s2
    4e06:	855a                	mv	a0,s6
    4e08:	eedff0ef          	jal	ra,4cf4 <putc>
    4e0c:	a019                	j	4e12 <vprintf+0x5a>
    } else if(state == '%'){
    4e0e:	03598263          	beq	s3,s5,4e32 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4e12:	2485                	addiw	s1,s1,1
    4e14:	8726                	mv	a4,s1
    4e16:	009a07b3          	add	a5,s4,s1
    4e1a:	0007c903          	lbu	s2,0(a5)
    4e1e:	20090a63          	beqz	s2,5032 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
    4e22:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4e26:	fe0994e3          	bnez	s3,4e0e <vprintf+0x56>
      if(c0 == '%'){
    4e2a:	fd579de3          	bne	a5,s5,4e04 <vprintf+0x4c>
        state = '%';
    4e2e:	89be                	mv	s3,a5
    4e30:	b7cd                	j	4e12 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4e32:	c3c1                	beqz	a5,4eb2 <vprintf+0xfa>
    4e34:	00ea06b3          	add	a3,s4,a4
    4e38:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4e3c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4e3e:	c681                	beqz	a3,4e46 <vprintf+0x8e>
    4e40:	9752                	add	a4,a4,s4
    4e42:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4e46:	03878e63          	beq	a5,s8,4e82 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
    4e4a:	05a78863          	beq	a5,s10,4e9a <vprintf+0xe2>
      } else if(c0 == 'u'){
    4e4e:	0db78b63          	beq	a5,s11,4f24 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4e52:	07800713          	li	a4,120
    4e56:	10e78d63          	beq	a5,a4,4f70 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4e5a:	07000713          	li	a4,112
    4e5e:	14e78263          	beq	a5,a4,4fa2 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    4e62:	06300713          	li	a4,99
    4e66:	16e78f63          	beq	a5,a4,4fe4 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    4e6a:	07300713          	li	a4,115
    4e6e:	18e78563          	beq	a5,a4,4ff8 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4e72:	05579063          	bne	a5,s5,4eb2 <vprintf+0xfa>
        putc(fd, '%');
    4e76:	85d6                	mv	a1,s5
    4e78:	855a                	mv	a0,s6
    4e7a:	e7bff0ef          	jal	ra,4cf4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    4e7e:	4981                	li	s3,0
    4e80:	bf49                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
    4e82:	008b8913          	addi	s2,s7,8
    4e86:	4685                	li	a3,1
    4e88:	4629                	li	a2,10
    4e8a:	000ba583          	lw	a1,0(s7)
    4e8e:	855a                	mv	a0,s6
    4e90:	e83ff0ef          	jal	ra,4d12 <printint>
    4e94:	8bca                	mv	s7,s2
      state = 0;
    4e96:	4981                	li	s3,0
    4e98:	bfad                	j	4e12 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
    4e9a:	03868663          	beq	a3,s8,4ec6 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4e9e:	05a68163          	beq	a3,s10,4ee0 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
    4ea2:	09b68d63          	beq	a3,s11,4f3c <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4ea6:	03a68f63          	beq	a3,s10,4ee4 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
    4eaa:	07800793          	li	a5,120
    4eae:	0cf68d63          	beq	a3,a5,4f88 <vprintf+0x1d0>
        putc(fd, '%');
    4eb2:	85d6                	mv	a1,s5
    4eb4:	855a                	mv	a0,s6
    4eb6:	e3fff0ef          	jal	ra,4cf4 <putc>
        putc(fd, c0);
    4eba:	85ca                	mv	a1,s2
    4ebc:	855a                	mv	a0,s6
    4ebe:	e37ff0ef          	jal	ra,4cf4 <putc>
      state = 0;
    4ec2:	4981                	li	s3,0
    4ec4:	b7b9                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4ec6:	008b8913          	addi	s2,s7,8
    4eca:	4685                	li	a3,1
    4ecc:	4629                	li	a2,10
    4ece:	000bb583          	ld	a1,0(s7)
    4ed2:	855a                	mv	a0,s6
    4ed4:	e3fff0ef          	jal	ra,4d12 <printint>
        i += 1;
    4ed8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4eda:	8bca                	mv	s7,s2
      state = 0;
    4edc:	4981                	li	s3,0
        i += 1;
    4ede:	bf15                	j	4e12 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4ee0:	03860563          	beq	a2,s8,4f0a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4ee4:	07b60963          	beq	a2,s11,4f56 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4ee8:	07800793          	li	a5,120
    4eec:	fcf613e3          	bne	a2,a5,4eb2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4ef0:	008b8913          	addi	s2,s7,8
    4ef4:	4681                	li	a3,0
    4ef6:	4641                	li	a2,16
    4ef8:	000bb583          	ld	a1,0(s7)
    4efc:	855a                	mv	a0,s6
    4efe:	e15ff0ef          	jal	ra,4d12 <printint>
        i += 2;
    4f02:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f04:	8bca                	mv	s7,s2
      state = 0;
    4f06:	4981                	li	s3,0
        i += 2;
    4f08:	b729                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f0a:	008b8913          	addi	s2,s7,8
    4f0e:	4685                	li	a3,1
    4f10:	4629                	li	a2,10
    4f12:	000bb583          	ld	a1,0(s7)
    4f16:	855a                	mv	a0,s6
    4f18:	dfbff0ef          	jal	ra,4d12 <printint>
        i += 2;
    4f1c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f1e:	8bca                	mv	s7,s2
      state = 0;
    4f20:	4981                	li	s3,0
        i += 2;
    4f22:	bdc5                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    4f24:	008b8913          	addi	s2,s7,8
    4f28:	4681                	li	a3,0
    4f2a:	4629                	li	a2,10
    4f2c:	000be583          	lwu	a1,0(s7)
    4f30:	855a                	mv	a0,s6
    4f32:	de1ff0ef          	jal	ra,4d12 <printint>
    4f36:	8bca                	mv	s7,s2
      state = 0;
    4f38:	4981                	li	s3,0
    4f3a:	bde1                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f3c:	008b8913          	addi	s2,s7,8
    4f40:	4681                	li	a3,0
    4f42:	4629                	li	a2,10
    4f44:	000bb583          	ld	a1,0(s7)
    4f48:	855a                	mv	a0,s6
    4f4a:	dc9ff0ef          	jal	ra,4d12 <printint>
        i += 1;
    4f4e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f50:	8bca                	mv	s7,s2
      state = 0;
    4f52:	4981                	li	s3,0
        i += 1;
    4f54:	bd7d                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f56:	008b8913          	addi	s2,s7,8
    4f5a:	4681                	li	a3,0
    4f5c:	4629                	li	a2,10
    4f5e:	000bb583          	ld	a1,0(s7)
    4f62:	855a                	mv	a0,s6
    4f64:	dafff0ef          	jal	ra,4d12 <printint>
        i += 2;
    4f68:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f6a:	8bca                	mv	s7,s2
      state = 0;
    4f6c:	4981                	li	s3,0
        i += 2;
    4f6e:	b555                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    4f70:	008b8913          	addi	s2,s7,8
    4f74:	4681                	li	a3,0
    4f76:	4641                	li	a2,16
    4f78:	000be583          	lwu	a1,0(s7)
    4f7c:	855a                	mv	a0,s6
    4f7e:	d95ff0ef          	jal	ra,4d12 <printint>
    4f82:	8bca                	mv	s7,s2
      state = 0;
    4f84:	4981                	li	s3,0
    4f86:	b571                	j	4e12 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f88:	008b8913          	addi	s2,s7,8
    4f8c:	4681                	li	a3,0
    4f8e:	4641                	li	a2,16
    4f90:	000bb583          	ld	a1,0(s7)
    4f94:	855a                	mv	a0,s6
    4f96:	d7dff0ef          	jal	ra,4d12 <printint>
        i += 1;
    4f9a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f9c:	8bca                	mv	s7,s2
      state = 0;
    4f9e:	4981                	li	s3,0
        i += 1;
    4fa0:	bd8d                	j	4e12 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
    4fa2:	008b8793          	addi	a5,s7,8
    4fa6:	f8f43423          	sd	a5,-120(s0)
    4faa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4fae:	03000593          	li	a1,48
    4fb2:	855a                	mv	a0,s6
    4fb4:	d41ff0ef          	jal	ra,4cf4 <putc>
  putc(fd, 'x');
    4fb8:	07800593          	li	a1,120
    4fbc:	855a                	mv	a0,s6
    4fbe:	d37ff0ef          	jal	ra,4cf4 <putc>
    4fc2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4fc4:	03c9d793          	srli	a5,s3,0x3c
    4fc8:	97e6                	add	a5,a5,s9
    4fca:	0007c583          	lbu	a1,0(a5)
    4fce:	855a                	mv	a0,s6
    4fd0:	d25ff0ef          	jal	ra,4cf4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4fd4:	0992                	slli	s3,s3,0x4
    4fd6:	397d                	addiw	s2,s2,-1
    4fd8:	fe0916e3          	bnez	s2,4fc4 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
    4fdc:	f8843b83          	ld	s7,-120(s0)
      state = 0;
    4fe0:	4981                	li	s3,0
    4fe2:	bd05                	j	4e12 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
    4fe4:	008b8913          	addi	s2,s7,8
    4fe8:	000bc583          	lbu	a1,0(s7)
    4fec:	855a                	mv	a0,s6
    4fee:	d07ff0ef          	jal	ra,4cf4 <putc>
    4ff2:	8bca                	mv	s7,s2
      state = 0;
    4ff4:	4981                	li	s3,0
    4ff6:	bd31                	j	4e12 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
    4ff8:	008b8993          	addi	s3,s7,8
    4ffc:	000bb903          	ld	s2,0(s7)
    5000:	00090f63          	beqz	s2,501e <vprintf+0x266>
        for(; *s; s++)
    5004:	00094583          	lbu	a1,0(s2)
    5008:	c195                	beqz	a1,502c <vprintf+0x274>
          putc(fd, *s);
    500a:	855a                	mv	a0,s6
    500c:	ce9ff0ef          	jal	ra,4cf4 <putc>
        for(; *s; s++)
    5010:	0905                	addi	s2,s2,1
    5012:	00094583          	lbu	a1,0(s2)
    5016:	f9f5                	bnez	a1,500a <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
    5018:	8bce                	mv	s7,s3
      state = 0;
    501a:	4981                	li	s3,0
    501c:	bbdd                	j	4e12 <vprintf+0x5a>
          s = "(null)";
    501e:	00002917          	auipc	s2,0x2
    5022:	71a90913          	addi	s2,s2,1818 # 7738 <malloc+0x2604>
        for(; *s; s++)
    5026:	02800593          	li	a1,40
    502a:	b7c5                	j	500a <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
    502c:	8bce                	mv	s7,s3
      state = 0;
    502e:	4981                	li	s3,0
    5030:	b3cd                	j	4e12 <vprintf+0x5a>
    }
  }
}
    5032:	70e6                	ld	ra,120(sp)
    5034:	7446                	ld	s0,112(sp)
    5036:	74a6                	ld	s1,104(sp)
    5038:	7906                	ld	s2,96(sp)
    503a:	69e6                	ld	s3,88(sp)
    503c:	6a46                	ld	s4,80(sp)
    503e:	6aa6                	ld	s5,72(sp)
    5040:	6b06                	ld	s6,64(sp)
    5042:	7be2                	ld	s7,56(sp)
    5044:	7c42                	ld	s8,48(sp)
    5046:	7ca2                	ld	s9,40(sp)
    5048:	7d02                	ld	s10,32(sp)
    504a:	6de2                	ld	s11,24(sp)
    504c:	6109                	addi	sp,sp,128
    504e:	8082                	ret

0000000000005050 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5050:	715d                	addi	sp,sp,-80
    5052:	ec06                	sd	ra,24(sp)
    5054:	e822                	sd	s0,16(sp)
    5056:	1000                	addi	s0,sp,32
    5058:	e010                	sd	a2,0(s0)
    505a:	e414                	sd	a3,8(s0)
    505c:	e818                	sd	a4,16(s0)
    505e:	ec1c                	sd	a5,24(s0)
    5060:	03043023          	sd	a6,32(s0)
    5064:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5068:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    506c:	8622                	mv	a2,s0
    506e:	d4bff0ef          	jal	ra,4db8 <vprintf>
}
    5072:	60e2                	ld	ra,24(sp)
    5074:	6442                	ld	s0,16(sp)
    5076:	6161                	addi	sp,sp,80
    5078:	8082                	ret

000000000000507a <printf>:

void
printf(const char *fmt, ...)
{
    507a:	711d                	addi	sp,sp,-96
    507c:	ec06                	sd	ra,24(sp)
    507e:	e822                	sd	s0,16(sp)
    5080:	1000                	addi	s0,sp,32
    5082:	e40c                	sd	a1,8(s0)
    5084:	e810                	sd	a2,16(s0)
    5086:	ec14                	sd	a3,24(s0)
    5088:	f018                	sd	a4,32(s0)
    508a:	f41c                	sd	a5,40(s0)
    508c:	03043823          	sd	a6,48(s0)
    5090:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5094:	00840613          	addi	a2,s0,8
    5098:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    509c:	85aa                	mv	a1,a0
    509e:	4505                	li	a0,1
    50a0:	d19ff0ef          	jal	ra,4db8 <vprintf>
}
    50a4:	60e2                	ld	ra,24(sp)
    50a6:	6442                	ld	s0,16(sp)
    50a8:	6125                	addi	sp,sp,96
    50aa:	8082                	ret

00000000000050ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    50ac:	1141                	addi	sp,sp,-16
    50ae:	e422                	sd	s0,8(sp)
    50b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    50b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    50b6:	00003797          	auipc	a5,0x3
    50ba:	3ca7b783          	ld	a5,970(a5) # 8480 <freep>
    50be:	a805                	j	50ee <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    50c0:	4618                	lw	a4,8(a2)
    50c2:	9db9                	addw	a1,a1,a4
    50c4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    50c8:	6398                	ld	a4,0(a5)
    50ca:	6318                	ld	a4,0(a4)
    50cc:	fee53823          	sd	a4,-16(a0)
    50d0:	a091                	j	5114 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    50d2:	ff852703          	lw	a4,-8(a0)
    50d6:	9e39                	addw	a2,a2,a4
    50d8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    50da:	ff053703          	ld	a4,-16(a0)
    50de:	e398                	sd	a4,0(a5)
    50e0:	a099                	j	5126 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    50e2:	6398                	ld	a4,0(a5)
    50e4:	00e7e463          	bltu	a5,a4,50ec <free+0x40>
    50e8:	00e6ea63          	bltu	a3,a4,50fc <free+0x50>
{
    50ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    50ee:	fed7fae3          	bgeu	a5,a3,50e2 <free+0x36>
    50f2:	6398                	ld	a4,0(a5)
    50f4:	00e6e463          	bltu	a3,a4,50fc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    50f8:	fee7eae3          	bltu	a5,a4,50ec <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    50fc:	ff852583          	lw	a1,-8(a0)
    5100:	6390                	ld	a2,0(a5)
    5102:	02059713          	slli	a4,a1,0x20
    5106:	9301                	srli	a4,a4,0x20
    5108:	0712                	slli	a4,a4,0x4
    510a:	9736                	add	a4,a4,a3
    510c:	fae60ae3          	beq	a2,a4,50c0 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5110:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5114:	4790                	lw	a2,8(a5)
    5116:	02061713          	slli	a4,a2,0x20
    511a:	9301                	srli	a4,a4,0x20
    511c:	0712                	slli	a4,a4,0x4
    511e:	973e                	add	a4,a4,a5
    5120:	fae689e3          	beq	a3,a4,50d2 <free+0x26>
  } else
    p->s.ptr = bp;
    5124:	e394                	sd	a3,0(a5)
  freep = p;
    5126:	00003717          	auipc	a4,0x3
    512a:	34f73d23          	sd	a5,858(a4) # 8480 <freep>
}
    512e:	6422                	ld	s0,8(sp)
    5130:	0141                	addi	sp,sp,16
    5132:	8082                	ret

0000000000005134 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5134:	7139                	addi	sp,sp,-64
    5136:	fc06                	sd	ra,56(sp)
    5138:	f822                	sd	s0,48(sp)
    513a:	f426                	sd	s1,40(sp)
    513c:	f04a                	sd	s2,32(sp)
    513e:	ec4e                	sd	s3,24(sp)
    5140:	e852                	sd	s4,16(sp)
    5142:	e456                	sd	s5,8(sp)
    5144:	e05a                	sd	s6,0(sp)
    5146:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5148:	02051493          	slli	s1,a0,0x20
    514c:	9081                	srli	s1,s1,0x20
    514e:	04bd                	addi	s1,s1,15
    5150:	8091                	srli	s1,s1,0x4
    5152:	0014899b          	addiw	s3,s1,1
    5156:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5158:	00003517          	auipc	a0,0x3
    515c:	32853503          	ld	a0,808(a0) # 8480 <freep>
    5160:	c515                	beqz	a0,518c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5162:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5164:	4798                	lw	a4,8(a5)
    5166:	02977f63          	bgeu	a4,s1,51a4 <malloc+0x70>
    516a:	8a4e                	mv	s4,s3
    516c:	0009871b          	sext.w	a4,s3
    5170:	6685                	lui	a3,0x1
    5172:	00d77363          	bgeu	a4,a3,5178 <malloc+0x44>
    5176:	6a05                	lui	s4,0x1
    5178:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    517c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5180:	00003917          	auipc	s2,0x3
    5184:	30090913          	addi	s2,s2,768 # 8480 <freep>
  if(p == SBRK_ERROR)
    5188:	5afd                	li	s5,-1
    518a:	a0bd                	j	51f8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    518c:	0000a797          	auipc	a5,0xa
    5190:	b1c78793          	addi	a5,a5,-1252 # eca8 <base>
    5194:	00003717          	auipc	a4,0x3
    5198:	2ef73623          	sd	a5,748(a4) # 8480 <freep>
    519c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    519e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    51a2:	b7e1                	j	516a <malloc+0x36>
      if(p->s.size == nunits)
    51a4:	02e48b63          	beq	s1,a4,51da <malloc+0xa6>
        p->s.size -= nunits;
    51a8:	4137073b          	subw	a4,a4,s3
    51ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
    51ae:	1702                	slli	a4,a4,0x20
    51b0:	9301                	srli	a4,a4,0x20
    51b2:	0712                	slli	a4,a4,0x4
    51b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    51b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    51ba:	00003717          	auipc	a4,0x3
    51be:	2ca73323          	sd	a0,710(a4) # 8480 <freep>
      return (void*)(p + 1);
    51c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    51c6:	70e2                	ld	ra,56(sp)
    51c8:	7442                	ld	s0,48(sp)
    51ca:	74a2                	ld	s1,40(sp)
    51cc:	7902                	ld	s2,32(sp)
    51ce:	69e2                	ld	s3,24(sp)
    51d0:	6a42                	ld	s4,16(sp)
    51d2:	6aa2                	ld	s5,8(sp)
    51d4:	6b02                	ld	s6,0(sp)
    51d6:	6121                	addi	sp,sp,64
    51d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    51da:	6398                	ld	a4,0(a5)
    51dc:	e118                	sd	a4,0(a0)
    51de:	bff1                	j	51ba <malloc+0x86>
  hp->s.size = nu;
    51e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    51e4:	0541                	addi	a0,a0,16
    51e6:	ec7ff0ef          	jal	ra,50ac <free>
  return freep;
    51ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    51ee:	dd61                	beqz	a0,51c6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    51f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    51f2:	4798                	lw	a4,8(a5)
    51f4:	fa9778e3          	bgeu	a4,s1,51a4 <malloc+0x70>
    if(p == freep)
    51f8:	00093703          	ld	a4,0(s2)
    51fc:	853e                	mv	a0,a5
    51fe:	fef719e3          	bne	a4,a5,51f0 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    5202:	8552                	mv	a0,s4
    5204:	a1dff0ef          	jal	ra,4c20 <sbrk>
  if(p == SBRK_ERROR)
    5208:	fd551ce3          	bne	a0,s5,51e0 <malloc+0xac>
        return 0;
    520c:	4501                	li	a0,0
    520e:	bf65                	j	51c6 <malloc+0x92>
