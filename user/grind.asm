
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	ra,0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7159                	addi	sp,sp,-112
      76:	f486                	sd	ra,104(sp)
      78:	f0a2                	sd	s0,96(sp)
      7a:	eca6                	sd	s1,88(sp)
      7c:	e8ca                	sd	s2,80(sp)
      7e:	e4ce                	sd	s3,72(sp)
      80:	e0d2                	sd	s4,64(sp)
      82:	fc56                	sd	s5,56(sp)
      84:	f85a                	sd	s6,48(sp)
      86:	1880                	addi	s0,sp,112
      88:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8a:	4501                	li	a0,0
      8c:	311000ef          	jal	ra,b9c <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	10e50513          	addi	a0,a0,270 # 11a0 <malloc+0xe8>
      9a:	39f000ef          	jal	ra,c38 <mkdir>
  if(chdir("grindir") != 0){
      9e:	00001517          	auipc	a0,0x1
      a2:	10250513          	addi	a0,a0,258 # 11a0 <malloc+0xe8>
      a6:	39b000ef          	jal	ra,c40 <chdir>
      aa:	c911                	beqz	a0,be <go+0x4a>
    printf("grind: chdir grindir failed\n");
      ac:	00001517          	auipc	a0,0x1
      b0:	0fc50513          	addi	a0,a0,252 # 11a8 <malloc+0xf0>
      b4:	74b000ef          	jal	ra,ffe <printf>
    exit(1);
      b8:	4505                	li	a0,1
      ba:	317000ef          	jal	ra,bd0 <exit>
  }
  chdir("/");
      be:	00001517          	auipc	a0,0x1
      c2:	10a50513          	addi	a0,a0,266 # 11c8 <malloc+0x110>
      c6:	37b000ef          	jal	ra,c40 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      ca:	00001997          	auipc	s3,0x1
      ce:	10e98993          	addi	s3,s3,270 # 11d8 <malloc+0x120>
      d2:	c489                	beqz	s1,dc <go+0x68>
      d4:	00001997          	auipc	s3,0x1
      d8:	0fc98993          	addi	s3,s3,252 # 11d0 <malloc+0x118>
    iters++;
      dc:	4485                	li	s1,1
  int fd = -1;
      de:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      e0:	00002a17          	auipc	s4,0x2
      e4:	f40a0a13          	addi	s4,s4,-192 # 2020 <buf.1247>
      e8:	a035                	j	114 <go+0xa0>
      close(open("grindir/../a", O_CREATE|O_RDWR));
      ea:	20200593          	li	a1,514
      ee:	00001517          	auipc	a0,0x1
      f2:	0f250513          	addi	a0,a0,242 # 11e0 <malloc+0x128>
      f6:	31b000ef          	jal	ra,c10 <open>
      fa:	2ff000ef          	jal	ra,bf8 <close>
    iters++;
      fe:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     100:	1f400793          	li	a5,500
     104:	02f4f7b3          	remu	a5,s1,a5
     108:	e791                	bnez	a5,114 <go+0xa0>
      write(1, which_child?"B":"A", 1);
     10a:	4605                	li	a2,1
     10c:	85ce                	mv	a1,s3
     10e:	4505                	li	a0,1
     110:	2e1000ef          	jal	ra,bf0 <write>
    int what = rand() % 23;
     114:	f45ff0ef          	jal	ra,58 <rand>
     118:	47dd                	li	a5,23
     11a:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     11e:	4785                	li	a5,1
     120:	fcf505e3          	beq	a0,a5,ea <go+0x76>
    } else if(what == 2){
     124:	4789                	li	a5,2
     126:	14f50563          	beq	a0,a5,270 <go+0x1fc>
    } else if(what == 3){
     12a:	478d                	li	a5,3
     12c:	14f50d63          	beq	a0,a5,286 <go+0x212>
    } else if(what == 4){
     130:	4791                	li	a5,4
     132:	16f50163          	beq	a0,a5,294 <go+0x220>
    } else if(what == 5){
     136:	4795                	li	a5,5
     138:	18f50b63          	beq	a0,a5,2ce <go+0x25a>
    } else if(what == 6){
     13c:	4799                	li	a5,6
     13e:	1af50563          	beq	a0,a5,2e8 <go+0x274>
    } else if(what == 7){
     142:	479d                	li	a5,7
     144:	1af50f63          	beq	a0,a5,302 <go+0x28e>
    } else if(what == 8){
     148:	47a1                	li	a5,8
     14a:	1cf50363          	beq	a0,a5,310 <go+0x29c>
    } else if(what == 9){
     14e:	47a5                	li	a5,9
     150:	1cf50763          	beq	a0,a5,31e <go+0x2aa>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     154:	47a9                	li	a5,10
     156:	1ef50b63          	beq	a0,a5,34c <go+0x2d8>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     15a:	47ad                	li	a5,11
     15c:	20f50f63          	beq	a0,a5,37a <go+0x306>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     160:	47b1                	li	a5,12
     162:	22f50d63          	beq	a0,a5,39c <go+0x328>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     166:	47b5                	li	a5,13
     168:	24f50b63          	beq	a0,a5,3be <go+0x34a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     16c:	47b9                	li	a5,14
     16e:	26f50c63          	beq	a0,a5,3e6 <go+0x372>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     172:	47bd                	li	a5,15
     174:	2af50263          	beq	a0,a5,418 <go+0x3a4>
      sbrk(6011);
    } else if(what == 16){
     178:	47c1                	li	a5,16
     17a:	2af50563          	beq	a0,a5,424 <go+0x3b0>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     17e:	47c5                	li	a5,17
     180:	2af50f63          	beq	a0,a5,43e <go+0x3ca>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     184:	47c9                	li	a5,18
     186:	30f50f63          	beq	a0,a5,4a4 <go+0x430>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     18a:	47cd                	li	a5,19
     18c:	34f50563          	beq	a0,a5,4d6 <go+0x462>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     190:	47d1                	li	a5,20
     192:	3ef50663          	beq	a0,a5,57e <go+0x50a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     196:	47d5                	li	a5,21
     198:	44f50e63          	beq	a0,a5,5f4 <go+0x580>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     19c:	47d9                	li	a5,22
     19e:	f6f510e3          	bne	a0,a5,fe <go+0x8a>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1a2:	f9840513          	addi	a0,s0,-104
     1a6:	23b000ef          	jal	ra,be0 <pipe>
     1aa:	50054963          	bltz	a0,6bc <go+0x648>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1ae:	fa040513          	addi	a0,s0,-96
     1b2:	22f000ef          	jal	ra,be0 <pipe>
     1b6:	50054d63          	bltz	a0,6d0 <go+0x65c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ba:	20f000ef          	jal	ra,bc8 <fork>
      if(pid1 == 0){
     1be:	52050363          	beqz	a0,6e4 <go+0x670>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1c2:	5a054563          	bltz	a0,76c <go+0x6f8>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1c6:	203000ef          	jal	ra,bc8 <fork>
      if(pid2 == 0){
     1ca:	5a050b63          	beqz	a0,780 <go+0x70c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     1ce:	64054963          	bltz	a0,820 <go+0x7ac>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     1d2:	f9842503          	lw	a0,-104(s0)
     1d6:	223000ef          	jal	ra,bf8 <close>
      close(aa[1]);
     1da:	f9c42503          	lw	a0,-100(s0)
     1de:	21b000ef          	jal	ra,bf8 <close>
      close(bb[1]);
     1e2:	fa442503          	lw	a0,-92(s0)
     1e6:	213000ef          	jal	ra,bf8 <close>
      char buf[4] = { 0, 0, 0, 0 };
     1ea:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     1ee:	4605                	li	a2,1
     1f0:	f9040593          	addi	a1,s0,-112
     1f4:	fa042503          	lw	a0,-96(s0)
     1f8:	1f1000ef          	jal	ra,be8 <read>
      read(bb[0], buf+1, 1);
     1fc:	4605                	li	a2,1
     1fe:	f9140593          	addi	a1,s0,-111
     202:	fa042503          	lw	a0,-96(s0)
     206:	1e3000ef          	jal	ra,be8 <read>
      read(bb[0], buf+2, 1);
     20a:	4605                	li	a2,1
     20c:	f9240593          	addi	a1,s0,-110
     210:	fa042503          	lw	a0,-96(s0)
     214:	1d5000ef          	jal	ra,be8 <read>
      close(bb[0]);
     218:	fa042503          	lw	a0,-96(s0)
     21c:	1dd000ef          	jal	ra,bf8 <close>
      int st1, st2;
      wait(&st1);
     220:	f9440513          	addi	a0,s0,-108
     224:	1b5000ef          	jal	ra,bd8 <wait>
      wait(&st2);
     228:	fa840513          	addi	a0,s0,-88
     22c:	1ad000ef          	jal	ra,bd8 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     230:	f9442783          	lw	a5,-108(s0)
     234:	fa842703          	lw	a4,-88(s0)
     238:	8fd9                	or	a5,a5,a4
     23a:	2781                	sext.w	a5,a5
     23c:	eb99                	bnez	a5,252 <go+0x1de>
     23e:	00001597          	auipc	a1,0x1
     242:	21a58593          	addi	a1,a1,538 # 1458 <malloc+0x3a0>
     246:	f9040513          	addi	a0,s0,-112
     24a:	714000ef          	jal	ra,95e <strcmp>
     24e:	ea0508e3          	beqz	a0,fe <go+0x8a>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     252:	f9040693          	addi	a3,s0,-112
     256:	fa842603          	lw	a2,-88(s0)
     25a:	f9442583          	lw	a1,-108(s0)
     25e:	00001517          	auipc	a0,0x1
     262:	20250513          	addi	a0,a0,514 # 1460 <malloc+0x3a8>
     266:	599000ef          	jal	ra,ffe <printf>
        exit(1);
     26a:	4505                	li	a0,1
     26c:	165000ef          	jal	ra,bd0 <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     270:	20200593          	li	a1,514
     274:	00001517          	auipc	a0,0x1
     278:	f7c50513          	addi	a0,a0,-132 # 11f0 <malloc+0x138>
     27c:	195000ef          	jal	ra,c10 <open>
     280:	179000ef          	jal	ra,bf8 <close>
     284:	bdad                	j	fe <go+0x8a>
      unlink("grindir/../a");
     286:	00001517          	auipc	a0,0x1
     28a:	f5a50513          	addi	a0,a0,-166 # 11e0 <malloc+0x128>
     28e:	193000ef          	jal	ra,c20 <unlink>
     292:	b5b5                	j	fe <go+0x8a>
      if(chdir("grindir") != 0){
     294:	00001517          	auipc	a0,0x1
     298:	f0c50513          	addi	a0,a0,-244 # 11a0 <malloc+0xe8>
     29c:	1a5000ef          	jal	ra,c40 <chdir>
     2a0:	ed11                	bnez	a0,2bc <go+0x248>
      unlink("../b");
     2a2:	00001517          	auipc	a0,0x1
     2a6:	f6650513          	addi	a0,a0,-154 # 1208 <malloc+0x150>
     2aa:	177000ef          	jal	ra,c20 <unlink>
      chdir("/");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	f1a50513          	addi	a0,a0,-230 # 11c8 <malloc+0x110>
     2b6:	18b000ef          	jal	ra,c40 <chdir>
     2ba:	b591                	j	fe <go+0x8a>
        printf("grind: chdir grindir failed\n");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	eec50513          	addi	a0,a0,-276 # 11a8 <malloc+0xf0>
     2c4:	53b000ef          	jal	ra,ffe <printf>
        exit(1);
     2c8:	4505                	li	a0,1
     2ca:	107000ef          	jal	ra,bd0 <exit>
      close(fd);
     2ce:	854a                	mv	a0,s2
     2d0:	129000ef          	jal	ra,bf8 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     2d4:	20200593          	li	a1,514
     2d8:	00001517          	auipc	a0,0x1
     2dc:	f3850513          	addi	a0,a0,-200 # 1210 <malloc+0x158>
     2e0:	131000ef          	jal	ra,c10 <open>
     2e4:	892a                	mv	s2,a0
     2e6:	bd21                	j	fe <go+0x8a>
      close(fd);
     2e8:	854a                	mv	a0,s2
     2ea:	10f000ef          	jal	ra,bf8 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2ee:	20200593          	li	a1,514
     2f2:	00001517          	auipc	a0,0x1
     2f6:	f2e50513          	addi	a0,a0,-210 # 1220 <malloc+0x168>
     2fa:	117000ef          	jal	ra,c10 <open>
     2fe:	892a                	mv	s2,a0
     300:	bbfd                	j	fe <go+0x8a>
      write(fd, buf, sizeof(buf));
     302:	3e700613          	li	a2,999
     306:	85d2                	mv	a1,s4
     308:	854a                	mv	a0,s2
     30a:	0e7000ef          	jal	ra,bf0 <write>
     30e:	bbc5                	j	fe <go+0x8a>
      read(fd, buf, sizeof(buf));
     310:	3e700613          	li	a2,999
     314:	85d2                	mv	a1,s4
     316:	854a                	mv	a0,s2
     318:	0d1000ef          	jal	ra,be8 <read>
     31c:	b3cd                	j	fe <go+0x8a>
      mkdir("grindir/../a");
     31e:	00001517          	auipc	a0,0x1
     322:	ec250513          	addi	a0,a0,-318 # 11e0 <malloc+0x128>
     326:	113000ef          	jal	ra,c38 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     32a:	20200593          	li	a1,514
     32e:	00001517          	auipc	a0,0x1
     332:	f0a50513          	addi	a0,a0,-246 # 1238 <malloc+0x180>
     336:	0db000ef          	jal	ra,c10 <open>
     33a:	0bf000ef          	jal	ra,bf8 <close>
      unlink("a/a");
     33e:	00001517          	auipc	a0,0x1
     342:	f0a50513          	addi	a0,a0,-246 # 1248 <malloc+0x190>
     346:	0db000ef          	jal	ra,c20 <unlink>
     34a:	bb55                	j	fe <go+0x8a>
      mkdir("/../b");
     34c:	00001517          	auipc	a0,0x1
     350:	f0450513          	addi	a0,a0,-252 # 1250 <malloc+0x198>
     354:	0e5000ef          	jal	ra,c38 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     358:	20200593          	li	a1,514
     35c:	00001517          	auipc	a0,0x1
     360:	efc50513          	addi	a0,a0,-260 # 1258 <malloc+0x1a0>
     364:	0ad000ef          	jal	ra,c10 <open>
     368:	091000ef          	jal	ra,bf8 <close>
      unlink("b/b");
     36c:	00001517          	auipc	a0,0x1
     370:	efc50513          	addi	a0,a0,-260 # 1268 <malloc+0x1b0>
     374:	0ad000ef          	jal	ra,c20 <unlink>
     378:	b359                	j	fe <go+0x8a>
      unlink("b");
     37a:	00001517          	auipc	a0,0x1
     37e:	eb650513          	addi	a0,a0,-330 # 1230 <malloc+0x178>
     382:	09f000ef          	jal	ra,c20 <unlink>
      link("../grindir/./../a", "../b");
     386:	00001597          	auipc	a1,0x1
     38a:	e8258593          	addi	a1,a1,-382 # 1208 <malloc+0x150>
     38e:	00001517          	auipc	a0,0x1
     392:	ee250513          	addi	a0,a0,-286 # 1270 <malloc+0x1b8>
     396:	09b000ef          	jal	ra,c30 <link>
     39a:	b395                	j	fe <go+0x8a>
      unlink("../grindir/../a");
     39c:	00001517          	auipc	a0,0x1
     3a0:	eec50513          	addi	a0,a0,-276 # 1288 <malloc+0x1d0>
     3a4:	07d000ef          	jal	ra,c20 <unlink>
      link(".././b", "/grindir/../a");
     3a8:	00001597          	auipc	a1,0x1
     3ac:	e6858593          	addi	a1,a1,-408 # 1210 <malloc+0x158>
     3b0:	00001517          	auipc	a0,0x1
     3b4:	ee850513          	addi	a0,a0,-280 # 1298 <malloc+0x1e0>
     3b8:	079000ef          	jal	ra,c30 <link>
     3bc:	b389                	j	fe <go+0x8a>
      int pid = fork();
     3be:	00b000ef          	jal	ra,bc8 <fork>
      if(pid == 0){
     3c2:	c519                	beqz	a0,3d0 <go+0x35c>
      } else if(pid < 0){
     3c4:	00054863          	bltz	a0,3d4 <go+0x360>
      wait(0);
     3c8:	4501                	li	a0,0
     3ca:	00f000ef          	jal	ra,bd8 <wait>
     3ce:	bb05                	j	fe <go+0x8a>
        exit(0);
     3d0:	001000ef          	jal	ra,bd0 <exit>
        printf("grind: fork failed\n");
     3d4:	00001517          	auipc	a0,0x1
     3d8:	ecc50513          	addi	a0,a0,-308 # 12a0 <malloc+0x1e8>
     3dc:	423000ef          	jal	ra,ffe <printf>
        exit(1);
     3e0:	4505                	li	a0,1
     3e2:	7ee000ef          	jal	ra,bd0 <exit>
      int pid = fork();
     3e6:	7e2000ef          	jal	ra,bc8 <fork>
      if(pid == 0){
     3ea:	c519                	beqz	a0,3f8 <go+0x384>
      } else if(pid < 0){
     3ec:	00054d63          	bltz	a0,406 <go+0x392>
      wait(0);
     3f0:	4501                	li	a0,0
     3f2:	7e6000ef          	jal	ra,bd8 <wait>
     3f6:	b321                	j	fe <go+0x8a>
        fork();
     3f8:	7d0000ef          	jal	ra,bc8 <fork>
        fork();
     3fc:	7cc000ef          	jal	ra,bc8 <fork>
        exit(0);
     400:	4501                	li	a0,0
     402:	7ce000ef          	jal	ra,bd0 <exit>
        printf("grind: fork failed\n");
     406:	00001517          	auipc	a0,0x1
     40a:	e9a50513          	addi	a0,a0,-358 # 12a0 <malloc+0x1e8>
     40e:	3f1000ef          	jal	ra,ffe <printf>
        exit(1);
     412:	4505                	li	a0,1
     414:	7bc000ef          	jal	ra,bd0 <exit>
      sbrk(6011);
     418:	6505                	lui	a0,0x1
     41a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x2eb>
     41e:	77e000ef          	jal	ra,b9c <sbrk>
     422:	b9f1                	j	fe <go+0x8a>
      if(sbrk(0) > break0)
     424:	4501                	li	a0,0
     426:	776000ef          	jal	ra,b9c <sbrk>
     42a:	ccaafae3          	bgeu	s5,a0,fe <go+0x8a>
        sbrk(-(sbrk(0) - break0));
     42e:	4501                	li	a0,0
     430:	76c000ef          	jal	ra,b9c <sbrk>
     434:	40aa853b          	subw	a0,s5,a0
     438:	764000ef          	jal	ra,b9c <sbrk>
     43c:	b1c9                	j	fe <go+0x8a>
      int pid = fork();
     43e:	78a000ef          	jal	ra,bc8 <fork>
     442:	8b2a                	mv	s6,a0
      if(pid == 0){
     444:	c10d                	beqz	a0,466 <go+0x3f2>
      } else if(pid < 0){
     446:	02054d63          	bltz	a0,480 <go+0x40c>
      if(chdir("../grindir/..") != 0){
     44a:	00001517          	auipc	a0,0x1
     44e:	e6e50513          	addi	a0,a0,-402 # 12b8 <malloc+0x200>
     452:	7ee000ef          	jal	ra,c40 <chdir>
     456:	ed15                	bnez	a0,492 <go+0x41e>
      kill(pid);
     458:	855a                	mv	a0,s6
     45a:	7a6000ef          	jal	ra,c00 <kill>
      wait(0);
     45e:	4501                	li	a0,0
     460:	778000ef          	jal	ra,bd8 <wait>
     464:	b969                	j	fe <go+0x8a>
        close(open("a", O_CREATE|O_RDWR));
     466:	20200593          	li	a1,514
     46a:	00001517          	auipc	a0,0x1
     46e:	e1650513          	addi	a0,a0,-490 # 1280 <malloc+0x1c8>
     472:	79e000ef          	jal	ra,c10 <open>
     476:	782000ef          	jal	ra,bf8 <close>
        exit(0);
     47a:	4501                	li	a0,0
     47c:	754000ef          	jal	ra,bd0 <exit>
        printf("grind: fork failed\n");
     480:	00001517          	auipc	a0,0x1
     484:	e2050513          	addi	a0,a0,-480 # 12a0 <malloc+0x1e8>
     488:	377000ef          	jal	ra,ffe <printf>
        exit(1);
     48c:	4505                	li	a0,1
     48e:	742000ef          	jal	ra,bd0 <exit>
        printf("grind: chdir failed\n");
     492:	00001517          	auipc	a0,0x1
     496:	e3650513          	addi	a0,a0,-458 # 12c8 <malloc+0x210>
     49a:	365000ef          	jal	ra,ffe <printf>
        exit(1);
     49e:	4505                	li	a0,1
     4a0:	730000ef          	jal	ra,bd0 <exit>
      int pid = fork();
     4a4:	724000ef          	jal	ra,bc8 <fork>
      if(pid == 0){
     4a8:	c519                	beqz	a0,4b6 <go+0x442>
      } else if(pid < 0){
     4aa:	00054d63          	bltz	a0,4c4 <go+0x450>
      wait(0);
     4ae:	4501                	li	a0,0
     4b0:	728000ef          	jal	ra,bd8 <wait>
     4b4:	b1a9                	j	fe <go+0x8a>
        kill(getpid());
     4b6:	79a000ef          	jal	ra,c50 <getpid>
     4ba:	746000ef          	jal	ra,c00 <kill>
        exit(0);
     4be:	4501                	li	a0,0
     4c0:	710000ef          	jal	ra,bd0 <exit>
        printf("grind: fork failed\n");
     4c4:	00001517          	auipc	a0,0x1
     4c8:	ddc50513          	addi	a0,a0,-548 # 12a0 <malloc+0x1e8>
     4cc:	333000ef          	jal	ra,ffe <printf>
        exit(1);
     4d0:	4505                	li	a0,1
     4d2:	6fe000ef          	jal	ra,bd0 <exit>
      if(pipe(fds) < 0){
     4d6:	fa840513          	addi	a0,s0,-88
     4da:	706000ef          	jal	ra,be0 <pipe>
     4de:	02054363          	bltz	a0,504 <go+0x490>
      int pid = fork();
     4e2:	6e6000ef          	jal	ra,bc8 <fork>
      if(pid == 0){
     4e6:	c905                	beqz	a0,516 <go+0x4a2>
      } else if(pid < 0){
     4e8:	08054263          	bltz	a0,56c <go+0x4f8>
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	708000ef          	jal	ra,bf8 <close>
      close(fds[1]);
     4f4:	fac42503          	lw	a0,-84(s0)
     4f8:	700000ef          	jal	ra,bf8 <close>
      wait(0);
     4fc:	4501                	li	a0,0
     4fe:	6da000ef          	jal	ra,bd8 <wait>
     502:	bef5                	j	fe <go+0x8a>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	ddc50513          	addi	a0,a0,-548 # 12e0 <malloc+0x228>
     50c:	2f3000ef          	jal	ra,ffe <printf>
        exit(1);
     510:	4505                	li	a0,1
     512:	6be000ef          	jal	ra,bd0 <exit>
        fork();
     516:	6b2000ef          	jal	ra,bc8 <fork>
        fork();
     51a:	6ae000ef          	jal	ra,bc8 <fork>
        if(write(fds[1], "x", 1) != 1)
     51e:	4605                	li	a2,1
     520:	00001597          	auipc	a1,0x1
     524:	dd858593          	addi	a1,a1,-552 # 12f8 <malloc+0x240>
     528:	fac42503          	lw	a0,-84(s0)
     52c:	6c4000ef          	jal	ra,bf0 <write>
     530:	4785                	li	a5,1
     532:	00f51f63          	bne	a0,a5,550 <go+0x4dc>
        if(read(fds[0], &c, 1) != 1)
     536:	4605                	li	a2,1
     538:	fa040593          	addi	a1,s0,-96
     53c:	fa842503          	lw	a0,-88(s0)
     540:	6a8000ef          	jal	ra,be8 <read>
     544:	4785                	li	a5,1
     546:	00f51c63          	bne	a0,a5,55e <go+0x4ea>
        exit(0);
     54a:	4501                	li	a0,0
     54c:	684000ef          	jal	ra,bd0 <exit>
          printf("grind: pipe write failed\n");
     550:	00001517          	auipc	a0,0x1
     554:	db050513          	addi	a0,a0,-592 # 1300 <malloc+0x248>
     558:	2a7000ef          	jal	ra,ffe <printf>
     55c:	bfe9                	j	536 <go+0x4c2>
          printf("grind: pipe read failed\n");
     55e:	00001517          	auipc	a0,0x1
     562:	dc250513          	addi	a0,a0,-574 # 1320 <malloc+0x268>
     566:	299000ef          	jal	ra,ffe <printf>
     56a:	b7c5                	j	54a <go+0x4d6>
        printf("grind: fork failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	d3450513          	addi	a0,a0,-716 # 12a0 <malloc+0x1e8>
     574:	28b000ef          	jal	ra,ffe <printf>
        exit(1);
     578:	4505                	li	a0,1
     57a:	656000ef          	jal	ra,bd0 <exit>
      int pid = fork();
     57e:	64a000ef          	jal	ra,bc8 <fork>
      if(pid == 0){
     582:	c519                	beqz	a0,590 <go+0x51c>
      } else if(pid < 0){
     584:	04054f63          	bltz	a0,5e2 <go+0x56e>
      wait(0);
     588:	4501                	li	a0,0
     58a:	64e000ef          	jal	ra,bd8 <wait>
     58e:	be85                	j	fe <go+0x8a>
        unlink("a");
     590:	00001517          	auipc	a0,0x1
     594:	cf050513          	addi	a0,a0,-784 # 1280 <malloc+0x1c8>
     598:	688000ef          	jal	ra,c20 <unlink>
        mkdir("a");
     59c:	00001517          	auipc	a0,0x1
     5a0:	ce450513          	addi	a0,a0,-796 # 1280 <malloc+0x1c8>
     5a4:	694000ef          	jal	ra,c38 <mkdir>
        chdir("a");
     5a8:	00001517          	auipc	a0,0x1
     5ac:	cd850513          	addi	a0,a0,-808 # 1280 <malloc+0x1c8>
     5b0:	690000ef          	jal	ra,c40 <chdir>
        unlink("../a");
     5b4:	00001517          	auipc	a0,0x1
     5b8:	c3450513          	addi	a0,a0,-972 # 11e8 <malloc+0x130>
     5bc:	664000ef          	jal	ra,c20 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     5c0:	20200593          	li	a1,514
     5c4:	00001517          	auipc	a0,0x1
     5c8:	d3450513          	addi	a0,a0,-716 # 12f8 <malloc+0x240>
     5cc:	644000ef          	jal	ra,c10 <open>
        unlink("x");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	d2850513          	addi	a0,a0,-728 # 12f8 <malloc+0x240>
     5d8:	648000ef          	jal	ra,c20 <unlink>
        exit(0);
     5dc:	4501                	li	a0,0
     5de:	5f2000ef          	jal	ra,bd0 <exit>
        printf("grind: fork failed\n");
     5e2:	00001517          	auipc	a0,0x1
     5e6:	cbe50513          	addi	a0,a0,-834 # 12a0 <malloc+0x1e8>
     5ea:	215000ef          	jal	ra,ffe <printf>
        exit(1);
     5ee:	4505                	li	a0,1
     5f0:	5e0000ef          	jal	ra,bd0 <exit>
      unlink("c");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	d4c50513          	addi	a0,a0,-692 # 1340 <malloc+0x288>
     5fc:	624000ef          	jal	ra,c20 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     600:	20200593          	li	a1,514
     604:	00001517          	auipc	a0,0x1
     608:	d3c50513          	addi	a0,a0,-708 # 1340 <malloc+0x288>
     60c:	604000ef          	jal	ra,c10 <open>
     610:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     612:	04054763          	bltz	a0,660 <go+0x5ec>
      if(write(fd1, "x", 1) != 1){
     616:	4605                	li	a2,1
     618:	00001597          	auipc	a1,0x1
     61c:	ce058593          	addi	a1,a1,-800 # 12f8 <malloc+0x240>
     620:	5d0000ef          	jal	ra,bf0 <write>
     624:	4785                	li	a5,1
     626:	04f51663          	bne	a0,a5,672 <go+0x5fe>
      if(fstat(fd1, &st) != 0){
     62a:	fa840593          	addi	a1,s0,-88
     62e:	855a                	mv	a0,s6
     630:	5f8000ef          	jal	ra,c28 <fstat>
     634:	e921                	bnez	a0,684 <go+0x610>
      if(st.size != 1){
     636:	fb843583          	ld	a1,-72(s0)
     63a:	4785                	li	a5,1
     63c:	04f59d63          	bne	a1,a5,696 <go+0x622>
      if(st.ino > 200){
     640:	fac42583          	lw	a1,-84(s0)
     644:	0c800793          	li	a5,200
     648:	06b7e163          	bltu	a5,a1,6aa <go+0x636>
      close(fd1);
     64c:	855a                	mv	a0,s6
     64e:	5aa000ef          	jal	ra,bf8 <close>
      unlink("c");
     652:	00001517          	auipc	a0,0x1
     656:	cee50513          	addi	a0,a0,-786 # 1340 <malloc+0x288>
     65a:	5c6000ef          	jal	ra,c20 <unlink>
     65e:	b445                	j	fe <go+0x8a>
        printf("grind: create c failed\n");
     660:	00001517          	auipc	a0,0x1
     664:	ce850513          	addi	a0,a0,-792 # 1348 <malloc+0x290>
     668:	197000ef          	jal	ra,ffe <printf>
        exit(1);
     66c:	4505                	li	a0,1
     66e:	562000ef          	jal	ra,bd0 <exit>
        printf("grind: write c failed\n");
     672:	00001517          	auipc	a0,0x1
     676:	cee50513          	addi	a0,a0,-786 # 1360 <malloc+0x2a8>
     67a:	185000ef          	jal	ra,ffe <printf>
        exit(1);
     67e:	4505                	li	a0,1
     680:	550000ef          	jal	ra,bd0 <exit>
        printf("grind: fstat failed\n");
     684:	00001517          	auipc	a0,0x1
     688:	cf450513          	addi	a0,a0,-780 # 1378 <malloc+0x2c0>
     68c:	173000ef          	jal	ra,ffe <printf>
        exit(1);
     690:	4505                	li	a0,1
     692:	53e000ef          	jal	ra,bd0 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     696:	2581                	sext.w	a1,a1
     698:	00001517          	auipc	a0,0x1
     69c:	cf850513          	addi	a0,a0,-776 # 1390 <malloc+0x2d8>
     6a0:	15f000ef          	jal	ra,ffe <printf>
        exit(1);
     6a4:	4505                	li	a0,1
     6a6:	52a000ef          	jal	ra,bd0 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     6aa:	00001517          	auipc	a0,0x1
     6ae:	d0e50513          	addi	a0,a0,-754 # 13b8 <malloc+0x300>
     6b2:	14d000ef          	jal	ra,ffe <printf>
        exit(1);
     6b6:	4505                	li	a0,1
     6b8:	518000ef          	jal	ra,bd0 <exit>
        fprintf(2, "grind: pipe failed\n");
     6bc:	00001597          	auipc	a1,0x1
     6c0:	c2458593          	addi	a1,a1,-988 # 12e0 <malloc+0x228>
     6c4:	4509                	li	a0,2
     6c6:	10f000ef          	jal	ra,fd4 <fprintf>
        exit(1);
     6ca:	4505                	li	a0,1
     6cc:	504000ef          	jal	ra,bd0 <exit>
        fprintf(2, "grind: pipe failed\n");
     6d0:	00001597          	auipc	a1,0x1
     6d4:	c1058593          	addi	a1,a1,-1008 # 12e0 <malloc+0x228>
     6d8:	4509                	li	a0,2
     6da:	0fb000ef          	jal	ra,fd4 <fprintf>
        exit(1);
     6de:	4505                	li	a0,1
     6e0:	4f0000ef          	jal	ra,bd0 <exit>
        close(bb[0]);
     6e4:	fa042503          	lw	a0,-96(s0)
     6e8:	510000ef          	jal	ra,bf8 <close>
        close(bb[1]);
     6ec:	fa442503          	lw	a0,-92(s0)
     6f0:	508000ef          	jal	ra,bf8 <close>
        close(aa[0]);
     6f4:	f9842503          	lw	a0,-104(s0)
     6f8:	500000ef          	jal	ra,bf8 <close>
        close(1);
     6fc:	4505                	li	a0,1
     6fe:	4fa000ef          	jal	ra,bf8 <close>
        if(dup(aa[1]) != 1){
     702:	f9c42503          	lw	a0,-100(s0)
     706:	542000ef          	jal	ra,c48 <dup>
     70a:	4785                	li	a5,1
     70c:	00f50c63          	beq	a0,a5,724 <go+0x6b0>
          fprintf(2, "grind: dup failed\n");
     710:	00001597          	auipc	a1,0x1
     714:	cd058593          	addi	a1,a1,-816 # 13e0 <malloc+0x328>
     718:	4509                	li	a0,2
     71a:	0bb000ef          	jal	ra,fd4 <fprintf>
          exit(1);
     71e:	4505                	li	a0,1
     720:	4b0000ef          	jal	ra,bd0 <exit>
        close(aa[1]);
     724:	f9c42503          	lw	a0,-100(s0)
     728:	4d0000ef          	jal	ra,bf8 <close>
        char *args[3] = { "echo", "hi", 0 };
     72c:	00001797          	auipc	a5,0x1
     730:	ccc78793          	addi	a5,a5,-820 # 13f8 <malloc+0x340>
     734:	faf43423          	sd	a5,-88(s0)
     738:	00001797          	auipc	a5,0x1
     73c:	cc878793          	addi	a5,a5,-824 # 1400 <malloc+0x348>
     740:	faf43823          	sd	a5,-80(s0)
     744:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     748:	fa840593          	addi	a1,s0,-88
     74c:	00001517          	auipc	a0,0x1
     750:	cbc50513          	addi	a0,a0,-836 # 1408 <malloc+0x350>
     754:	4b4000ef          	jal	ra,c08 <exec>
        fprintf(2, "grind: echo: not found\n");
     758:	00001597          	auipc	a1,0x1
     75c:	cc058593          	addi	a1,a1,-832 # 1418 <malloc+0x360>
     760:	4509                	li	a0,2
     762:	073000ef          	jal	ra,fd4 <fprintf>
        exit(2);
     766:	4509                	li	a0,2
     768:	468000ef          	jal	ra,bd0 <exit>
        fprintf(2, "grind: fork failed\n");
     76c:	00001597          	auipc	a1,0x1
     770:	b3458593          	addi	a1,a1,-1228 # 12a0 <malloc+0x1e8>
     774:	4509                	li	a0,2
     776:	05f000ef          	jal	ra,fd4 <fprintf>
        exit(3);
     77a:	450d                	li	a0,3
     77c:	454000ef          	jal	ra,bd0 <exit>
        close(aa[1]);
     780:	f9c42503          	lw	a0,-100(s0)
     784:	474000ef          	jal	ra,bf8 <close>
        close(bb[0]);
     788:	fa042503          	lw	a0,-96(s0)
     78c:	46c000ef          	jal	ra,bf8 <close>
        close(0);
     790:	4501                	li	a0,0
     792:	466000ef          	jal	ra,bf8 <close>
        if(dup(aa[0]) != 0){
     796:	f9842503          	lw	a0,-104(s0)
     79a:	4ae000ef          	jal	ra,c48 <dup>
     79e:	c919                	beqz	a0,7b4 <go+0x740>
          fprintf(2, "grind: dup failed\n");
     7a0:	00001597          	auipc	a1,0x1
     7a4:	c4058593          	addi	a1,a1,-960 # 13e0 <malloc+0x328>
     7a8:	4509                	li	a0,2
     7aa:	02b000ef          	jal	ra,fd4 <fprintf>
          exit(4);
     7ae:	4511                	li	a0,4
     7b0:	420000ef          	jal	ra,bd0 <exit>
        close(aa[0]);
     7b4:	f9842503          	lw	a0,-104(s0)
     7b8:	440000ef          	jal	ra,bf8 <close>
        close(1);
     7bc:	4505                	li	a0,1
     7be:	43a000ef          	jal	ra,bf8 <close>
        if(dup(bb[1]) != 1){
     7c2:	fa442503          	lw	a0,-92(s0)
     7c6:	482000ef          	jal	ra,c48 <dup>
     7ca:	4785                	li	a5,1
     7cc:	00f50c63          	beq	a0,a5,7e4 <go+0x770>
          fprintf(2, "grind: dup failed\n");
     7d0:	00001597          	auipc	a1,0x1
     7d4:	c1058593          	addi	a1,a1,-1008 # 13e0 <malloc+0x328>
     7d8:	4509                	li	a0,2
     7da:	7fa000ef          	jal	ra,fd4 <fprintf>
          exit(5);
     7de:	4515                	li	a0,5
     7e0:	3f0000ef          	jal	ra,bd0 <exit>
        close(bb[1]);
     7e4:	fa442503          	lw	a0,-92(s0)
     7e8:	410000ef          	jal	ra,bf8 <close>
        char *args[2] = { "cat", 0 };
     7ec:	00001797          	auipc	a5,0x1
     7f0:	c4478793          	addi	a5,a5,-956 # 1430 <malloc+0x378>
     7f4:	faf43423          	sd	a5,-88(s0)
     7f8:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     7fc:	fa840593          	addi	a1,s0,-88
     800:	00001517          	auipc	a0,0x1
     804:	c3850513          	addi	a0,a0,-968 # 1438 <malloc+0x380>
     808:	400000ef          	jal	ra,c08 <exec>
        fprintf(2, "grind: cat: not found\n");
     80c:	00001597          	auipc	a1,0x1
     810:	c3458593          	addi	a1,a1,-972 # 1440 <malloc+0x388>
     814:	4509                	li	a0,2
     816:	7be000ef          	jal	ra,fd4 <fprintf>
        exit(6);
     81a:	4519                	li	a0,6
     81c:	3b4000ef          	jal	ra,bd0 <exit>
        fprintf(2, "grind: fork failed\n");
     820:	00001597          	auipc	a1,0x1
     824:	a8058593          	addi	a1,a1,-1408 # 12a0 <malloc+0x1e8>
     828:	4509                	li	a0,2
     82a:	7aa000ef          	jal	ra,fd4 <fprintf>
        exit(7);
     82e:	451d                	li	a0,7
     830:	3a0000ef          	jal	ra,bd0 <exit>

0000000000000834 <iter>:
  }
}

void
iter()
{
     834:	7179                	addi	sp,sp,-48
     836:	f406                	sd	ra,40(sp)
     838:	f022                	sd	s0,32(sp)
     83a:	ec26                	sd	s1,24(sp)
     83c:	e84a                	sd	s2,16(sp)
     83e:	1800                	addi	s0,sp,48
  unlink("a");
     840:	00001517          	auipc	a0,0x1
     844:	a4050513          	addi	a0,a0,-1472 # 1280 <malloc+0x1c8>
     848:	3d8000ef          	jal	ra,c20 <unlink>
  unlink("b");
     84c:	00001517          	auipc	a0,0x1
     850:	9e450513          	addi	a0,a0,-1564 # 1230 <malloc+0x178>
     854:	3cc000ef          	jal	ra,c20 <unlink>
  
  int pid1 = fork();
     858:	370000ef          	jal	ra,bc8 <fork>
  if(pid1 < 0){
     85c:	00054f63          	bltz	a0,87a <iter+0x46>
     860:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     862:	e50d                	bnez	a0,88c <iter+0x58>
    rand_next ^= 31;
     864:	00001717          	auipc	a4,0x1
     868:	79c70713          	addi	a4,a4,1948 # 2000 <rand_next>
     86c:	631c                	ld	a5,0(a4)
     86e:	01f7c793          	xori	a5,a5,31
     872:	e31c                	sd	a5,0(a4)
    go(0);
     874:	4501                	li	a0,0
     876:	ffeff0ef          	jal	ra,74 <go>
    printf("grind: fork failed\n");
     87a:	00001517          	auipc	a0,0x1
     87e:	a2650513          	addi	a0,a0,-1498 # 12a0 <malloc+0x1e8>
     882:	77c000ef          	jal	ra,ffe <printf>
    exit(1);
     886:	4505                	li	a0,1
     888:	348000ef          	jal	ra,bd0 <exit>
    exit(0);
  }

  int pid2 = fork();
     88c:	33c000ef          	jal	ra,bc8 <fork>
     890:	892a                	mv	s2,a0
  if(pid2 < 0){
     892:	02054063          	bltz	a0,8b2 <iter+0x7e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     896:	e51d                	bnez	a0,8c4 <iter+0x90>
    rand_next ^= 7177;
     898:	00001697          	auipc	a3,0x1
     89c:	76868693          	addi	a3,a3,1896 # 2000 <rand_next>
     8a0:	629c                	ld	a5,0(a3)
     8a2:	6709                	lui	a4,0x2
     8a4:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x779>
     8a8:	8fb9                	xor	a5,a5,a4
     8aa:	e29c                	sd	a5,0(a3)
    go(1);
     8ac:	4505                	li	a0,1
     8ae:	fc6ff0ef          	jal	ra,74 <go>
    printf("grind: fork failed\n");
     8b2:	00001517          	auipc	a0,0x1
     8b6:	9ee50513          	addi	a0,a0,-1554 # 12a0 <malloc+0x1e8>
     8ba:	744000ef          	jal	ra,ffe <printf>
    exit(1);
     8be:	4505                	li	a0,1
     8c0:	310000ef          	jal	ra,bd0 <exit>
    exit(0);
  }

  int st1 = -1;
     8c4:	57fd                	li	a5,-1
     8c6:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     8ca:	fdc40513          	addi	a0,s0,-36
     8ce:	30a000ef          	jal	ra,bd8 <wait>
  if(st1 != 0){
     8d2:	fdc42783          	lw	a5,-36(s0)
     8d6:	eb99                	bnez	a5,8ec <iter+0xb8>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     8d8:	57fd                	li	a5,-1
     8da:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     8de:	fd840513          	addi	a0,s0,-40
     8e2:	2f6000ef          	jal	ra,bd8 <wait>

  exit(0);
     8e6:	4501                	li	a0,0
     8e8:	2e8000ef          	jal	ra,bd0 <exit>
    kill(pid1);
     8ec:	8526                	mv	a0,s1
     8ee:	312000ef          	jal	ra,c00 <kill>
    kill(pid2);
     8f2:	854a                	mv	a0,s2
     8f4:	30c000ef          	jal	ra,c00 <kill>
     8f8:	b7c5                	j	8d8 <iter+0xa4>

00000000000008fa <main>:
}

int
main()
{
     8fa:	1101                	addi	sp,sp,-32
     8fc:	ec06                	sd	ra,24(sp)
     8fe:	e822                	sd	s0,16(sp)
     900:	e426                	sd	s1,8(sp)
     902:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    pause(20);
    rand_next += 1;
     904:	00001497          	auipc	s1,0x1
     908:	6fc48493          	addi	s1,s1,1788 # 2000 <rand_next>
     90c:	a809                	j	91e <main+0x24>
      iter();
     90e:	f27ff0ef          	jal	ra,834 <iter>
    pause(20);
     912:	4551                	li	a0,20
     914:	34c000ef          	jal	ra,c60 <pause>
    rand_next += 1;
     918:	609c                	ld	a5,0(s1)
     91a:	0785                	addi	a5,a5,1
     91c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     91e:	2aa000ef          	jal	ra,bc8 <fork>
    if(pid == 0){
     922:	d575                	beqz	a0,90e <main+0x14>
    if(pid > 0){
     924:	fea057e3          	blez	a0,912 <main+0x18>
      wait(0);
     928:	4501                	li	a0,0
     92a:	2ae000ef          	jal	ra,bd8 <wait>
     92e:	b7d5                	j	912 <main+0x18>

0000000000000930 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     930:	1141                	addi	sp,sp,-16
     932:	e406                	sd	ra,8(sp)
     934:	e022                	sd	s0,0(sp)
     936:	0800                	addi	s0,sp,16
  extern int main();
  main();
     938:	fc3ff0ef          	jal	ra,8fa <main>
  exit(0);
     93c:	4501                	li	a0,0
     93e:	292000ef          	jal	ra,bd0 <exit>

0000000000000942 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     942:	1141                	addi	sp,sp,-16
     944:	e422                	sd	s0,8(sp)
     946:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     948:	87aa                	mv	a5,a0
     94a:	0585                	addi	a1,a1,1
     94c:	0785                	addi	a5,a5,1
     94e:	fff5c703          	lbu	a4,-1(a1)
     952:	fee78fa3          	sb	a4,-1(a5)
     956:	fb75                	bnez	a4,94a <strcpy+0x8>
    ;
  return os;
}
     958:	6422                	ld	s0,8(sp)
     95a:	0141                	addi	sp,sp,16
     95c:	8082                	ret

000000000000095e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     95e:	1141                	addi	sp,sp,-16
     960:	e422                	sd	s0,8(sp)
     962:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     964:	00054783          	lbu	a5,0(a0)
     968:	cb91                	beqz	a5,97c <strcmp+0x1e>
     96a:	0005c703          	lbu	a4,0(a1)
     96e:	00f71763          	bne	a4,a5,97c <strcmp+0x1e>
    p++, q++;
     972:	0505                	addi	a0,a0,1
     974:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     976:	00054783          	lbu	a5,0(a0)
     97a:	fbe5                	bnez	a5,96a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     97c:	0005c503          	lbu	a0,0(a1)
}
     980:	40a7853b          	subw	a0,a5,a0
     984:	6422                	ld	s0,8(sp)
     986:	0141                	addi	sp,sp,16
     988:	8082                	ret

000000000000098a <strlen>:

uint
strlen(const char *s)
{
     98a:	1141                	addi	sp,sp,-16
     98c:	e422                	sd	s0,8(sp)
     98e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     990:	00054783          	lbu	a5,0(a0)
     994:	cf91                	beqz	a5,9b0 <strlen+0x26>
     996:	0505                	addi	a0,a0,1
     998:	87aa                	mv	a5,a0
     99a:	4685                	li	a3,1
     99c:	9e89                	subw	a3,a3,a0
     99e:	00f6853b          	addw	a0,a3,a5
     9a2:	0785                	addi	a5,a5,1
     9a4:	fff7c703          	lbu	a4,-1(a5)
     9a8:	fb7d                	bnez	a4,99e <strlen+0x14>
    ;
  return n;
}
     9aa:	6422                	ld	s0,8(sp)
     9ac:	0141                	addi	sp,sp,16
     9ae:	8082                	ret
  for(n = 0; s[n]; n++)
     9b0:	4501                	li	a0,0
     9b2:	bfe5                	j	9aa <strlen+0x20>

00000000000009b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9b4:	1141                	addi	sp,sp,-16
     9b6:	e422                	sd	s0,8(sp)
     9b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9ba:	ce09                	beqz	a2,9d4 <memset+0x20>
     9bc:	87aa                	mv	a5,a0
     9be:	fff6071b          	addiw	a4,a2,-1
     9c2:	1702                	slli	a4,a4,0x20
     9c4:	9301                	srli	a4,a4,0x20
     9c6:	0705                	addi	a4,a4,1
     9c8:	972a                	add	a4,a4,a0
    cdst[i] = c;
     9ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9ce:	0785                	addi	a5,a5,1
     9d0:	fee79de3          	bne	a5,a4,9ca <memset+0x16>
  }
  return dst;
}
     9d4:	6422                	ld	s0,8(sp)
     9d6:	0141                	addi	sp,sp,16
     9d8:	8082                	ret

00000000000009da <strchr>:

char*
strchr(const char *s, char c)
{
     9da:	1141                	addi	sp,sp,-16
     9dc:	e422                	sd	s0,8(sp)
     9de:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9e0:	00054783          	lbu	a5,0(a0)
     9e4:	cb99                	beqz	a5,9fa <strchr+0x20>
    if(*s == c)
     9e6:	00f58763          	beq	a1,a5,9f4 <strchr+0x1a>
  for(; *s; s++)
     9ea:	0505                	addi	a0,a0,1
     9ec:	00054783          	lbu	a5,0(a0)
     9f0:	fbfd                	bnez	a5,9e6 <strchr+0xc>
      return (char*)s;
  return 0;
     9f2:	4501                	li	a0,0
}
     9f4:	6422                	ld	s0,8(sp)
     9f6:	0141                	addi	sp,sp,16
     9f8:	8082                	ret
  return 0;
     9fa:	4501                	li	a0,0
     9fc:	bfe5                	j	9f4 <strchr+0x1a>

00000000000009fe <gets>:

char*
gets(char *buf, int max)
{
     9fe:	711d                	addi	sp,sp,-96
     a00:	ec86                	sd	ra,88(sp)
     a02:	e8a2                	sd	s0,80(sp)
     a04:	e4a6                	sd	s1,72(sp)
     a06:	e0ca                	sd	s2,64(sp)
     a08:	fc4e                	sd	s3,56(sp)
     a0a:	f852                	sd	s4,48(sp)
     a0c:	f456                	sd	s5,40(sp)
     a0e:	f05a                	sd	s6,32(sp)
     a10:	ec5e                	sd	s7,24(sp)
     a12:	1080                	addi	s0,sp,96
     a14:	8baa                	mv	s7,a0
     a16:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a18:	892a                	mv	s2,a0
     a1a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a1c:	4aa9                	li	s5,10
     a1e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a20:	89a6                	mv	s3,s1
     a22:	2485                	addiw	s1,s1,1
     a24:	0344d663          	bge	s1,s4,a50 <gets+0x52>
    cc = read(0, &c, 1);
     a28:	4605                	li	a2,1
     a2a:	faf40593          	addi	a1,s0,-81
     a2e:	4501                	li	a0,0
     a30:	1b8000ef          	jal	ra,be8 <read>
    if(cc < 1)
     a34:	00a05e63          	blez	a0,a50 <gets+0x52>
    buf[i++] = c;
     a38:	faf44783          	lbu	a5,-81(s0)
     a3c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a40:	01578763          	beq	a5,s5,a4e <gets+0x50>
     a44:	0905                	addi	s2,s2,1
     a46:	fd679de3          	bne	a5,s6,a20 <gets+0x22>
  for(i=0; i+1 < max; ){
     a4a:	89a6                	mv	s3,s1
     a4c:	a011                	j	a50 <gets+0x52>
     a4e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a50:	99de                	add	s3,s3,s7
     a52:	00098023          	sb	zero,0(s3)
  return buf;
}
     a56:	855e                	mv	a0,s7
     a58:	60e6                	ld	ra,88(sp)
     a5a:	6446                	ld	s0,80(sp)
     a5c:	64a6                	ld	s1,72(sp)
     a5e:	6906                	ld	s2,64(sp)
     a60:	79e2                	ld	s3,56(sp)
     a62:	7a42                	ld	s4,48(sp)
     a64:	7aa2                	ld	s5,40(sp)
     a66:	7b02                	ld	s6,32(sp)
     a68:	6be2                	ld	s7,24(sp)
     a6a:	6125                	addi	sp,sp,96
     a6c:	8082                	ret

0000000000000a6e <stat>:

int
stat(const char *n, struct stat *st)
{
     a6e:	1101                	addi	sp,sp,-32
     a70:	ec06                	sd	ra,24(sp)
     a72:	e822                	sd	s0,16(sp)
     a74:	e426                	sd	s1,8(sp)
     a76:	e04a                	sd	s2,0(sp)
     a78:	1000                	addi	s0,sp,32
     a7a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a7c:	4581                	li	a1,0
     a7e:	192000ef          	jal	ra,c10 <open>
  if(fd < 0)
     a82:	02054163          	bltz	a0,aa4 <stat+0x36>
     a86:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a88:	85ca                	mv	a1,s2
     a8a:	19e000ef          	jal	ra,c28 <fstat>
     a8e:	892a                	mv	s2,a0
  close(fd);
     a90:	8526                	mv	a0,s1
     a92:	166000ef          	jal	ra,bf8 <close>
  return r;
}
     a96:	854a                	mv	a0,s2
     a98:	60e2                	ld	ra,24(sp)
     a9a:	6442                	ld	s0,16(sp)
     a9c:	64a2                	ld	s1,8(sp)
     a9e:	6902                	ld	s2,0(sp)
     aa0:	6105                	addi	sp,sp,32
     aa2:	8082                	ret
    return -1;
     aa4:	597d                	li	s2,-1
     aa6:	bfc5                	j	a96 <stat+0x28>

0000000000000aa8 <atoi>:

int
atoi(const char *s)
{
     aa8:	1141                	addi	sp,sp,-16
     aaa:	e422                	sd	s0,8(sp)
     aac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aae:	00054603          	lbu	a2,0(a0)
     ab2:	fd06079b          	addiw	a5,a2,-48
     ab6:	0ff7f793          	andi	a5,a5,255
     aba:	4725                	li	a4,9
     abc:	02f76963          	bltu	a4,a5,aee <atoi+0x46>
     ac0:	86aa                	mv	a3,a0
  n = 0;
     ac2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ac4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ac6:	0685                	addi	a3,a3,1
     ac8:	0025179b          	slliw	a5,a0,0x2
     acc:	9fa9                	addw	a5,a5,a0
     ace:	0017979b          	slliw	a5,a5,0x1
     ad2:	9fb1                	addw	a5,a5,a2
     ad4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ad8:	0006c603          	lbu	a2,0(a3)
     adc:	fd06071b          	addiw	a4,a2,-48
     ae0:	0ff77713          	andi	a4,a4,255
     ae4:	fee5f1e3          	bgeu	a1,a4,ac6 <atoi+0x1e>
  return n;
}
     ae8:	6422                	ld	s0,8(sp)
     aea:	0141                	addi	sp,sp,16
     aec:	8082                	ret
  n = 0;
     aee:	4501                	li	a0,0
     af0:	bfe5                	j	ae8 <atoi+0x40>

0000000000000af2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e422                	sd	s0,8(sp)
     af6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     af8:	02b57663          	bgeu	a0,a1,b24 <memmove+0x32>
    while(n-- > 0)
     afc:	02c05163          	blez	a2,b1e <memmove+0x2c>
     b00:	fff6079b          	addiw	a5,a2,-1
     b04:	1782                	slli	a5,a5,0x20
     b06:	9381                	srli	a5,a5,0x20
     b08:	0785                	addi	a5,a5,1
     b0a:	97aa                	add	a5,a5,a0
  dst = vdst;
     b0c:	872a                	mv	a4,a0
      *dst++ = *src++;
     b0e:	0585                	addi	a1,a1,1
     b10:	0705                	addi	a4,a4,1
     b12:	fff5c683          	lbu	a3,-1(a1)
     b16:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b1a:	fee79ae3          	bne	a5,a4,b0e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b1e:	6422                	ld	s0,8(sp)
     b20:	0141                	addi	sp,sp,16
     b22:	8082                	ret
    dst += n;
     b24:	00c50733          	add	a4,a0,a2
    src += n;
     b28:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b2a:	fec05ae3          	blez	a2,b1e <memmove+0x2c>
     b2e:	fff6079b          	addiw	a5,a2,-1
     b32:	1782                	slli	a5,a5,0x20
     b34:	9381                	srli	a5,a5,0x20
     b36:	fff7c793          	not	a5,a5
     b3a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b3c:	15fd                	addi	a1,a1,-1
     b3e:	177d                	addi	a4,a4,-1
     b40:	0005c683          	lbu	a3,0(a1)
     b44:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b48:	fee79ae3          	bne	a5,a4,b3c <memmove+0x4a>
     b4c:	bfc9                	j	b1e <memmove+0x2c>

0000000000000b4e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b4e:	1141                	addi	sp,sp,-16
     b50:	e422                	sd	s0,8(sp)
     b52:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b54:	ca05                	beqz	a2,b84 <memcmp+0x36>
     b56:	fff6069b          	addiw	a3,a2,-1
     b5a:	1682                	slli	a3,a3,0x20
     b5c:	9281                	srli	a3,a3,0x20
     b5e:	0685                	addi	a3,a3,1
     b60:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b62:	00054783          	lbu	a5,0(a0)
     b66:	0005c703          	lbu	a4,0(a1)
     b6a:	00e79863          	bne	a5,a4,b7a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b6e:	0505                	addi	a0,a0,1
    p2++;
     b70:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b72:	fed518e3          	bne	a0,a3,b62 <memcmp+0x14>
  }
  return 0;
     b76:	4501                	li	a0,0
     b78:	a019                	j	b7e <memcmp+0x30>
      return *p1 - *p2;
     b7a:	40e7853b          	subw	a0,a5,a4
}
     b7e:	6422                	ld	s0,8(sp)
     b80:	0141                	addi	sp,sp,16
     b82:	8082                	ret
  return 0;
     b84:	4501                	li	a0,0
     b86:	bfe5                	j	b7e <memcmp+0x30>

0000000000000b88 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b88:	1141                	addi	sp,sp,-16
     b8a:	e406                	sd	ra,8(sp)
     b8c:	e022                	sd	s0,0(sp)
     b8e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b90:	f63ff0ef          	jal	ra,af2 <memmove>
}
     b94:	60a2                	ld	ra,8(sp)
     b96:	6402                	ld	s0,0(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret

0000000000000b9c <sbrk>:

char *
sbrk(int n) {
     b9c:	1141                	addi	sp,sp,-16
     b9e:	e406                	sd	ra,8(sp)
     ba0:	e022                	sd	s0,0(sp)
     ba2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     ba4:	4585                	li	a1,1
     ba6:	0b2000ef          	jal	ra,c58 <sys_sbrk>
}
     baa:	60a2                	ld	ra,8(sp)
     bac:	6402                	ld	s0,0(sp)
     bae:	0141                	addi	sp,sp,16
     bb0:	8082                	ret

0000000000000bb2 <sbrklazy>:

char *
sbrklazy(int n) {
     bb2:	1141                	addi	sp,sp,-16
     bb4:	e406                	sd	ra,8(sp)
     bb6:	e022                	sd	s0,0(sp)
     bb8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     bba:	4589                	li	a1,2
     bbc:	09c000ef          	jal	ra,c58 <sys_sbrk>
}
     bc0:	60a2                	ld	ra,8(sp)
     bc2:	6402                	ld	s0,0(sp)
     bc4:	0141                	addi	sp,sp,16
     bc6:	8082                	ret

0000000000000bc8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bc8:	4885                	li	a7,1
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bd0:	4889                	li	a7,2
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bd8:	488d                	li	a7,3
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     be0:	4891                	li	a7,4
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <read>:
.global read
read:
 li a7, SYS_read
     be8:	4895                	li	a7,5
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <write>:
.global write
write:
 li a7, SYS_write
     bf0:	48c1                	li	a7,16
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <close>:
.global close
close:
 li a7, SYS_close
     bf8:	48d5                	li	a7,21
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c00:	4899                	li	a7,6
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c08:	489d                	li	a7,7
 ecall
     c0a:	00000073          	ecall
 ret
     c0e:	8082                	ret

0000000000000c10 <open>:
.global open
open:
 li a7, SYS_open
     c10:	48bd                	li	a7,15
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c18:	48c5                	li	a7,17
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c20:	48c9                	li	a7,18
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c28:	48a1                	li	a7,8
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <link>:
.global link
link:
 li a7, SYS_link
     c30:	48cd                	li	a7,19
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c38:	48d1                	li	a7,20
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c40:	48a5                	li	a7,9
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c48:	48a9                	li	a7,10
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c50:	48ad                	li	a7,11
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     c58:	48b1                	li	a7,12
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <pause>:
.global pause
pause:
 li a7, SYS_pause
     c60:	48b5                	li	a7,13
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c68:	48b9                	li	a7,14
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
     c70:	48d9                	li	a7,22
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c78:	1101                	addi	sp,sp,-32
     c7a:	ec06                	sd	ra,24(sp)
     c7c:	e822                	sd	s0,16(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c84:	4605                	li	a2,1
     c86:	fef40593          	addi	a1,s0,-17
     c8a:	f67ff0ef          	jal	ra,bf0 <write>
}
     c8e:	60e2                	ld	ra,24(sp)
     c90:	6442                	ld	s0,16(sp)
     c92:	6105                	addi	sp,sp,32
     c94:	8082                	ret

0000000000000c96 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c96:	715d                	addi	sp,sp,-80
     c98:	e486                	sd	ra,72(sp)
     c9a:	e0a2                	sd	s0,64(sp)
     c9c:	fc26                	sd	s1,56(sp)
     c9e:	f84a                	sd	s2,48(sp)
     ca0:	f44e                	sd	s3,40(sp)
     ca2:	0880                	addi	s0,sp,80
     ca4:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ca6:	c299                	beqz	a3,cac <printint+0x16>
     ca8:	0805c663          	bltz	a1,d34 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cac:	2581                	sext.w	a1,a1
  neg = 0;
     cae:	4881                	li	a7,0
     cb0:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     cb4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cb6:	2601                	sext.w	a2,a2
     cb8:	00000517          	auipc	a0,0x0
     cbc:	7d850513          	addi	a0,a0,2008 # 1490 <digits>
     cc0:	883a                	mv	a6,a4
     cc2:	2705                	addiw	a4,a4,1
     cc4:	02c5f7bb          	remuw	a5,a1,a2
     cc8:	1782                	slli	a5,a5,0x20
     cca:	9381                	srli	a5,a5,0x20
     ccc:	97aa                	add	a5,a5,a0
     cce:	0007c783          	lbu	a5,0(a5)
     cd2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cd6:	0005879b          	sext.w	a5,a1
     cda:	02c5d5bb          	divuw	a1,a1,a2
     cde:	0685                	addi	a3,a3,1
     ce0:	fec7f0e3          	bgeu	a5,a2,cc0 <printint+0x2a>
  if(neg)
     ce4:	00088b63          	beqz	a7,cfa <printint+0x64>
    buf[i++] = '-';
     ce8:	fd040793          	addi	a5,s0,-48
     cec:	973e                	add	a4,a4,a5
     cee:	02d00793          	li	a5,45
     cf2:	fef70423          	sb	a5,-24(a4)
     cf6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cfa:	02e05663          	blez	a4,d26 <printint+0x90>
     cfe:	fb840793          	addi	a5,s0,-72
     d02:	00e78933          	add	s2,a5,a4
     d06:	fff78993          	addi	s3,a5,-1
     d0a:	99ba                	add	s3,s3,a4
     d0c:	377d                	addiw	a4,a4,-1
     d0e:	1702                	slli	a4,a4,0x20
     d10:	9301                	srli	a4,a4,0x20
     d12:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d16:	fff94583          	lbu	a1,-1(s2)
     d1a:	8526                	mv	a0,s1
     d1c:	f5dff0ef          	jal	ra,c78 <putc>
  while(--i >= 0)
     d20:	197d                	addi	s2,s2,-1
     d22:	ff391ae3          	bne	s2,s3,d16 <printint+0x80>
}
     d26:	60a6                	ld	ra,72(sp)
     d28:	6406                	ld	s0,64(sp)
     d2a:	74e2                	ld	s1,56(sp)
     d2c:	7942                	ld	s2,48(sp)
     d2e:	79a2                	ld	s3,40(sp)
     d30:	6161                	addi	sp,sp,80
     d32:	8082                	ret
    x = -xx;
     d34:	40b005bb          	negw	a1,a1
    neg = 1;
     d38:	4885                	li	a7,1
    x = -xx;
     d3a:	bf9d                	j	cb0 <printint+0x1a>

0000000000000d3c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d3c:	7119                	addi	sp,sp,-128
     d3e:	fc86                	sd	ra,120(sp)
     d40:	f8a2                	sd	s0,112(sp)
     d42:	f4a6                	sd	s1,104(sp)
     d44:	f0ca                	sd	s2,96(sp)
     d46:	ecce                	sd	s3,88(sp)
     d48:	e8d2                	sd	s4,80(sp)
     d4a:	e4d6                	sd	s5,72(sp)
     d4c:	e0da                	sd	s6,64(sp)
     d4e:	fc5e                	sd	s7,56(sp)
     d50:	f862                	sd	s8,48(sp)
     d52:	f466                	sd	s9,40(sp)
     d54:	f06a                	sd	s10,32(sp)
     d56:	ec6e                	sd	s11,24(sp)
     d58:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d5a:	0005c903          	lbu	s2,0(a1)
     d5e:	24090c63          	beqz	s2,fb6 <vprintf+0x27a>
     d62:	8b2a                	mv	s6,a0
     d64:	8a2e                	mv	s4,a1
     d66:	8bb2                	mv	s7,a2
  state = 0;
     d68:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d6a:	4481                	li	s1,0
     d6c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d6e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d72:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d76:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d7a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d7e:	00000c97          	auipc	s9,0x0
     d82:	712c8c93          	addi	s9,s9,1810 # 1490 <digits>
     d86:	a005                	j	da6 <vprintf+0x6a>
        putc(fd, c0);
     d88:	85ca                	mv	a1,s2
     d8a:	855a                	mv	a0,s6
     d8c:	eedff0ef          	jal	ra,c78 <putc>
     d90:	a019                	j	d96 <vprintf+0x5a>
    } else if(state == '%'){
     d92:	03598263          	beq	s3,s5,db6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d96:	2485                	addiw	s1,s1,1
     d98:	8726                	mv	a4,s1
     d9a:	009a07b3          	add	a5,s4,s1
     d9e:	0007c903          	lbu	s2,0(a5)
     da2:	20090a63          	beqz	s2,fb6 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
     da6:	0009079b          	sext.w	a5,s2
    if(state == 0){
     daa:	fe0994e3          	bnez	s3,d92 <vprintf+0x56>
      if(c0 == '%'){
     dae:	fd579de3          	bne	a5,s5,d88 <vprintf+0x4c>
        state = '%';
     db2:	89be                	mv	s3,a5
     db4:	b7cd                	j	d96 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     db6:	c3c1                	beqz	a5,e36 <vprintf+0xfa>
     db8:	00ea06b3          	add	a3,s4,a4
     dbc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dc0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     dc2:	c681                	beqz	a3,dca <vprintf+0x8e>
     dc4:	9752                	add	a4,a4,s4
     dc6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     dca:	03878e63          	beq	a5,s8,e06 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
     dce:	05a78863          	beq	a5,s10,e1e <vprintf+0xe2>
      } else if(c0 == 'u'){
     dd2:	0db78b63          	beq	a5,s11,ea8 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     dd6:	07800713          	li	a4,120
     dda:	10e78d63          	beq	a5,a4,ef4 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     dde:	07000713          	li	a4,112
     de2:	14e78263          	beq	a5,a4,f26 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     de6:	06300713          	li	a4,99
     dea:	16e78f63          	beq	a5,a4,f68 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     dee:	07300713          	li	a4,115
     df2:	18e78563          	beq	a5,a4,f7c <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     df6:	05579063          	bne	a5,s5,e36 <vprintf+0xfa>
        putc(fd, '%');
     dfa:	85d6                	mv	a1,s5
     dfc:	855a                	mv	a0,s6
     dfe:	e7bff0ef          	jal	ra,c78 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e02:	4981                	li	s3,0
     e04:	bf49                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     e06:	008b8913          	addi	s2,s7,8
     e0a:	4685                	li	a3,1
     e0c:	4629                	li	a2,10
     e0e:	000ba583          	lw	a1,0(s7)
     e12:	855a                	mv	a0,s6
     e14:	e83ff0ef          	jal	ra,c96 <printint>
     e18:	8bca                	mv	s7,s2
      state = 0;
     e1a:	4981                	li	s3,0
     e1c:	bfad                	j	d96 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e1e:	03868663          	beq	a3,s8,e4a <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e22:	05a68163          	beq	a3,s10,e64 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
     e26:	09b68d63          	beq	a3,s11,ec0 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e2a:	03a68f63          	beq	a3,s10,e68 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
     e2e:	07800793          	li	a5,120
     e32:	0cf68d63          	beq	a3,a5,f0c <vprintf+0x1d0>
        putc(fd, '%');
     e36:	85d6                	mv	a1,s5
     e38:	855a                	mv	a0,s6
     e3a:	e3fff0ef          	jal	ra,c78 <putc>
        putc(fd, c0);
     e3e:	85ca                	mv	a1,s2
     e40:	855a                	mv	a0,s6
     e42:	e37ff0ef          	jal	ra,c78 <putc>
      state = 0;
     e46:	4981                	li	s3,0
     e48:	b7b9                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e4a:	008b8913          	addi	s2,s7,8
     e4e:	4685                	li	a3,1
     e50:	4629                	li	a2,10
     e52:	000bb583          	ld	a1,0(s7)
     e56:	855a                	mv	a0,s6
     e58:	e3fff0ef          	jal	ra,c96 <printint>
        i += 1;
     e5c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e5e:	8bca                	mv	s7,s2
      state = 0;
     e60:	4981                	li	s3,0
        i += 1;
     e62:	bf15                	j	d96 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e64:	03860563          	beq	a2,s8,e8e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e68:	07b60963          	beq	a2,s11,eda <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e6c:	07800793          	li	a5,120
     e70:	fcf613e3          	bne	a2,a5,e36 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e74:	008b8913          	addi	s2,s7,8
     e78:	4681                	li	a3,0
     e7a:	4641                	li	a2,16
     e7c:	000bb583          	ld	a1,0(s7)
     e80:	855a                	mv	a0,s6
     e82:	e15ff0ef          	jal	ra,c96 <printint>
        i += 2;
     e86:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e88:	8bca                	mv	s7,s2
      state = 0;
     e8a:	4981                	li	s3,0
        i += 2;
     e8c:	b729                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e8e:	008b8913          	addi	s2,s7,8
     e92:	4685                	li	a3,1
     e94:	4629                	li	a2,10
     e96:	000bb583          	ld	a1,0(s7)
     e9a:	855a                	mv	a0,s6
     e9c:	dfbff0ef          	jal	ra,c96 <printint>
        i += 2;
     ea0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     ea2:	8bca                	mv	s7,s2
      state = 0;
     ea4:	4981                	li	s3,0
        i += 2;
     ea6:	bdc5                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ea8:	008b8913          	addi	s2,s7,8
     eac:	4681                	li	a3,0
     eae:	4629                	li	a2,10
     eb0:	000be583          	lwu	a1,0(s7)
     eb4:	855a                	mv	a0,s6
     eb6:	de1ff0ef          	jal	ra,c96 <printint>
     eba:	8bca                	mv	s7,s2
      state = 0;
     ebc:	4981                	li	s3,0
     ebe:	bde1                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ec0:	008b8913          	addi	s2,s7,8
     ec4:	4681                	li	a3,0
     ec6:	4629                	li	a2,10
     ec8:	000bb583          	ld	a1,0(s7)
     ecc:	855a                	mv	a0,s6
     ece:	dc9ff0ef          	jal	ra,c96 <printint>
        i += 1;
     ed2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ed4:	8bca                	mv	s7,s2
      state = 0;
     ed6:	4981                	li	s3,0
        i += 1;
     ed8:	bd7d                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eda:	008b8913          	addi	s2,s7,8
     ede:	4681                	li	a3,0
     ee0:	4629                	li	a2,10
     ee2:	000bb583          	ld	a1,0(s7)
     ee6:	855a                	mv	a0,s6
     ee8:	dafff0ef          	jal	ra,c96 <printint>
        i += 2;
     eec:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     eee:	8bca                	mv	s7,s2
      state = 0;
     ef0:	4981                	li	s3,0
        i += 2;
     ef2:	b555                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     ef4:	008b8913          	addi	s2,s7,8
     ef8:	4681                	li	a3,0
     efa:	4641                	li	a2,16
     efc:	000be583          	lwu	a1,0(s7)
     f00:	855a                	mv	a0,s6
     f02:	d95ff0ef          	jal	ra,c96 <printint>
     f06:	8bca                	mv	s7,s2
      state = 0;
     f08:	4981                	li	s3,0
     f0a:	b571                	j	d96 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f0c:	008b8913          	addi	s2,s7,8
     f10:	4681                	li	a3,0
     f12:	4641                	li	a2,16
     f14:	000bb583          	ld	a1,0(s7)
     f18:	855a                	mv	a0,s6
     f1a:	d7dff0ef          	jal	ra,c96 <printint>
        i += 1;
     f1e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f20:	8bca                	mv	s7,s2
      state = 0;
     f22:	4981                	li	s3,0
        i += 1;
     f24:	bd8d                	j	d96 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f26:	008b8793          	addi	a5,s7,8
     f2a:	f8f43423          	sd	a5,-120(s0)
     f2e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f32:	03000593          	li	a1,48
     f36:	855a                	mv	a0,s6
     f38:	d41ff0ef          	jal	ra,c78 <putc>
  putc(fd, 'x');
     f3c:	07800593          	li	a1,120
     f40:	855a                	mv	a0,s6
     f42:	d37ff0ef          	jal	ra,c78 <putc>
     f46:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f48:	03c9d793          	srli	a5,s3,0x3c
     f4c:	97e6                	add	a5,a5,s9
     f4e:	0007c583          	lbu	a1,0(a5)
     f52:	855a                	mv	a0,s6
     f54:	d25ff0ef          	jal	ra,c78 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f58:	0992                	slli	s3,s3,0x4
     f5a:	397d                	addiw	s2,s2,-1
     f5c:	fe0916e3          	bnez	s2,f48 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
     f60:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     f64:	4981                	li	s3,0
     f66:	bd05                	j	d96 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
     f68:	008b8913          	addi	s2,s7,8
     f6c:	000bc583          	lbu	a1,0(s7)
     f70:	855a                	mv	a0,s6
     f72:	d07ff0ef          	jal	ra,c78 <putc>
     f76:	8bca                	mv	s7,s2
      state = 0;
     f78:	4981                	li	s3,0
     f7a:	bd31                	j	d96 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     f7c:	008b8993          	addi	s3,s7,8
     f80:	000bb903          	ld	s2,0(s7)
     f84:	00090f63          	beqz	s2,fa2 <vprintf+0x266>
        for(; *s; s++)
     f88:	00094583          	lbu	a1,0(s2)
     f8c:	c195                	beqz	a1,fb0 <vprintf+0x274>
          putc(fd, *s);
     f8e:	855a                	mv	a0,s6
     f90:	ce9ff0ef          	jal	ra,c78 <putc>
        for(; *s; s++)
     f94:	0905                	addi	s2,s2,1
     f96:	00094583          	lbu	a1,0(s2)
     f9a:	f9f5                	bnez	a1,f8e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
     f9c:	8bce                	mv	s7,s3
      state = 0;
     f9e:	4981                	li	s3,0
     fa0:	bbdd                	j	d96 <vprintf+0x5a>
          s = "(null)";
     fa2:	00000917          	auipc	s2,0x0
     fa6:	4e690913          	addi	s2,s2,1254 # 1488 <malloc+0x3d0>
        for(; *s; s++)
     faa:	02800593          	li	a1,40
     fae:	b7c5                	j	f8e <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
     fb0:	8bce                	mv	s7,s3
      state = 0;
     fb2:	4981                	li	s3,0
     fb4:	b3cd                	j	d96 <vprintf+0x5a>
    }
  }
}
     fb6:	70e6                	ld	ra,120(sp)
     fb8:	7446                	ld	s0,112(sp)
     fba:	74a6                	ld	s1,104(sp)
     fbc:	7906                	ld	s2,96(sp)
     fbe:	69e6                	ld	s3,88(sp)
     fc0:	6a46                	ld	s4,80(sp)
     fc2:	6aa6                	ld	s5,72(sp)
     fc4:	6b06                	ld	s6,64(sp)
     fc6:	7be2                	ld	s7,56(sp)
     fc8:	7c42                	ld	s8,48(sp)
     fca:	7ca2                	ld	s9,40(sp)
     fcc:	7d02                	ld	s10,32(sp)
     fce:	6de2                	ld	s11,24(sp)
     fd0:	6109                	addi	sp,sp,128
     fd2:	8082                	ret

0000000000000fd4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fd4:	715d                	addi	sp,sp,-80
     fd6:	ec06                	sd	ra,24(sp)
     fd8:	e822                	sd	s0,16(sp)
     fda:	1000                	addi	s0,sp,32
     fdc:	e010                	sd	a2,0(s0)
     fde:	e414                	sd	a3,8(s0)
     fe0:	e818                	sd	a4,16(s0)
     fe2:	ec1c                	sd	a5,24(s0)
     fe4:	03043023          	sd	a6,32(s0)
     fe8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ff0:	8622                	mv	a2,s0
     ff2:	d4bff0ef          	jal	ra,d3c <vprintf>
}
     ff6:	60e2                	ld	ra,24(sp)
     ff8:	6442                	ld	s0,16(sp)
     ffa:	6161                	addi	sp,sp,80
     ffc:	8082                	ret

0000000000000ffe <printf>:

void
printf(const char *fmt, ...)
{
     ffe:	711d                	addi	sp,sp,-96
    1000:	ec06                	sd	ra,24(sp)
    1002:	e822                	sd	s0,16(sp)
    1004:	1000                	addi	s0,sp,32
    1006:	e40c                	sd	a1,8(s0)
    1008:	e810                	sd	a2,16(s0)
    100a:	ec14                	sd	a3,24(s0)
    100c:	f018                	sd	a4,32(s0)
    100e:	f41c                	sd	a5,40(s0)
    1010:	03043823          	sd	a6,48(s0)
    1014:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1018:	00840613          	addi	a2,s0,8
    101c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1020:	85aa                	mv	a1,a0
    1022:	4505                	li	a0,1
    1024:	d19ff0ef          	jal	ra,d3c <vprintf>
}
    1028:	60e2                	ld	ra,24(sp)
    102a:	6442                	ld	s0,16(sp)
    102c:	6125                	addi	sp,sp,96
    102e:	8082                	ret

0000000000001030 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1030:	1141                	addi	sp,sp,-16
    1032:	e422                	sd	s0,8(sp)
    1034:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1036:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    103a:	00001797          	auipc	a5,0x1
    103e:	fd67b783          	ld	a5,-42(a5) # 2010 <freep>
    1042:	a805                	j	1072 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1044:	4618                	lw	a4,8(a2)
    1046:	9db9                	addw	a1,a1,a4
    1048:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    104c:	6398                	ld	a4,0(a5)
    104e:	6318                	ld	a4,0(a4)
    1050:	fee53823          	sd	a4,-16(a0)
    1054:	a091                	j	1098 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1056:	ff852703          	lw	a4,-8(a0)
    105a:	9e39                	addw	a2,a2,a4
    105c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    105e:	ff053703          	ld	a4,-16(a0)
    1062:	e398                	sd	a4,0(a5)
    1064:	a099                	j	10aa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1066:	6398                	ld	a4,0(a5)
    1068:	00e7e463          	bltu	a5,a4,1070 <free+0x40>
    106c:	00e6ea63          	bltu	a3,a4,1080 <free+0x50>
{
    1070:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1072:	fed7fae3          	bgeu	a5,a3,1066 <free+0x36>
    1076:	6398                	ld	a4,0(a5)
    1078:	00e6e463          	bltu	a3,a4,1080 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    107c:	fee7eae3          	bltu	a5,a4,1070 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1080:	ff852583          	lw	a1,-8(a0)
    1084:	6390                	ld	a2,0(a5)
    1086:	02059713          	slli	a4,a1,0x20
    108a:	9301                	srli	a4,a4,0x20
    108c:	0712                	slli	a4,a4,0x4
    108e:	9736                	add	a4,a4,a3
    1090:	fae60ae3          	beq	a2,a4,1044 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1094:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1098:	4790                	lw	a2,8(a5)
    109a:	02061713          	slli	a4,a2,0x20
    109e:	9301                	srli	a4,a4,0x20
    10a0:	0712                	slli	a4,a4,0x4
    10a2:	973e                	add	a4,a4,a5
    10a4:	fae689e3          	beq	a3,a4,1056 <free+0x26>
  } else
    p->s.ptr = bp;
    10a8:	e394                	sd	a3,0(a5)
  freep = p;
    10aa:	00001717          	auipc	a4,0x1
    10ae:	f6f73323          	sd	a5,-154(a4) # 2010 <freep>
}
    10b2:	6422                	ld	s0,8(sp)
    10b4:	0141                	addi	sp,sp,16
    10b6:	8082                	ret

00000000000010b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10b8:	7139                	addi	sp,sp,-64
    10ba:	fc06                	sd	ra,56(sp)
    10bc:	f822                	sd	s0,48(sp)
    10be:	f426                	sd	s1,40(sp)
    10c0:	f04a                	sd	s2,32(sp)
    10c2:	ec4e                	sd	s3,24(sp)
    10c4:	e852                	sd	s4,16(sp)
    10c6:	e456                	sd	s5,8(sp)
    10c8:	e05a                	sd	s6,0(sp)
    10ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10cc:	02051493          	slli	s1,a0,0x20
    10d0:	9081                	srli	s1,s1,0x20
    10d2:	04bd                	addi	s1,s1,15
    10d4:	8091                	srli	s1,s1,0x4
    10d6:	0014899b          	addiw	s3,s1,1
    10da:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10dc:	00001517          	auipc	a0,0x1
    10e0:	f3453503          	ld	a0,-204(a0) # 2010 <freep>
    10e4:	c515                	beqz	a0,1110 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10e8:	4798                	lw	a4,8(a5)
    10ea:	02977f63          	bgeu	a4,s1,1128 <malloc+0x70>
    10ee:	8a4e                	mv	s4,s3
    10f0:	0009871b          	sext.w	a4,s3
    10f4:	6685                	lui	a3,0x1
    10f6:	00d77363          	bgeu	a4,a3,10fc <malloc+0x44>
    10fa:	6a05                	lui	s4,0x1
    10fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1100:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1104:	00001917          	auipc	s2,0x1
    1108:	f0c90913          	addi	s2,s2,-244 # 2010 <freep>
  if(p == SBRK_ERROR)
    110c:	5afd                	li	s5,-1
    110e:	a0bd                	j	117c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    1110:	00001797          	auipc	a5,0x1
    1114:	2f878793          	addi	a5,a5,760 # 2408 <base>
    1118:	00001717          	auipc	a4,0x1
    111c:	eef73c23          	sd	a5,-264(a4) # 2010 <freep>
    1120:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1122:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1126:	b7e1                	j	10ee <malloc+0x36>
      if(p->s.size == nunits)
    1128:	02e48b63          	beq	s1,a4,115e <malloc+0xa6>
        p->s.size -= nunits;
    112c:	4137073b          	subw	a4,a4,s3
    1130:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1132:	1702                	slli	a4,a4,0x20
    1134:	9301                	srli	a4,a4,0x20
    1136:	0712                	slli	a4,a4,0x4
    1138:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    113a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    113e:	00001717          	auipc	a4,0x1
    1142:	eca73923          	sd	a0,-302(a4) # 2010 <freep>
      return (void*)(p + 1);
    1146:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    114a:	70e2                	ld	ra,56(sp)
    114c:	7442                	ld	s0,48(sp)
    114e:	74a2                	ld	s1,40(sp)
    1150:	7902                	ld	s2,32(sp)
    1152:	69e2                	ld	s3,24(sp)
    1154:	6a42                	ld	s4,16(sp)
    1156:	6aa2                	ld	s5,8(sp)
    1158:	6b02                	ld	s6,0(sp)
    115a:	6121                	addi	sp,sp,64
    115c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    115e:	6398                	ld	a4,0(a5)
    1160:	e118                	sd	a4,0(a0)
    1162:	bff1                	j	113e <malloc+0x86>
  hp->s.size = nu;
    1164:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1168:	0541                	addi	a0,a0,16
    116a:	ec7ff0ef          	jal	ra,1030 <free>
  return freep;
    116e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1172:	dd61                	beqz	a0,114a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1174:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1176:	4798                	lw	a4,8(a5)
    1178:	fa9778e3          	bgeu	a4,s1,1128 <malloc+0x70>
    if(p == freep)
    117c:	00093703          	ld	a4,0(s2)
    1180:	853e                	mv	a0,a5
    1182:	fef719e3          	bne	a4,a5,1174 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    1186:	8552                	mv	a0,s4
    1188:	a15ff0ef          	jal	ra,b9c <sbrk>
  if(p == SBRK_ERROR)
    118c:	fd551ce3          	bne	a0,s5,1164 <malloc+0xac>
        return 0;
    1190:	4501                	li	a0,0
    1192:	bf65                	j	114a <malloc+0x92>
