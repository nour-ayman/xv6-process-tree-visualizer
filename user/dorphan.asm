
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	8e450513          	addi	a0,a0,-1820 # 8f0 <malloc+0xe6>
  14:	37e000ef          	jal	ra,392 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	8dc50513          	addi	a0,a0,-1828 # 8f8 <malloc+0xee>
  24:	72c000ef          	jal	ra,750 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	300000ef          	jal	ra,32a <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	8c250513          	addi	a0,a0,-1854 # 8f0 <malloc+0xe6>
  36:	364000ef          	jal	ra,39a <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	8d250513          	addi	a0,a0,-1838 # 910 <malloc+0x106>
  46:	70a000ef          	jal	ra,750 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2de000ef          	jal	ra,32a <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	8d850513          	addi	a0,a0,-1832 # 928 <malloc+0x11e>
  58:	322000ef          	jal	ra,37a <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	8e850513          	addi	a0,a0,-1816 # 948 <malloc+0x13e>
  68:	6e8000ef          	jal	ra,750 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	34a000ef          	jal	ra,3ba <pause>
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8b850513          	addi	a0,a0,-1864 # 930 <malloc+0x126>
  80:	6d0000ef          	jal	ra,750 <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	2a4000ef          	jal	ra,32a <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  extern int main();
  main();
  92:	f6fff0ef          	jal	ra,0 <main>
  exit(0);
  96:	4501                	li	a0,0
  98:	292000ef          	jal	ra,32a <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a2:	87aa                	mv	a5,a0
  a4:	0585                	addi	a1,a1,1
  a6:	0785                	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fb75                	bnez	a4,a4 <strcpy+0x8>
    ;
  return os;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x1e>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x1e>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	4685                	li	a3,1
  f6:	9e89                	subw	a3,a3,a0
  f8:	00f6853b          	addw	a0,a3,a5
  fc:	0785                	addi	a5,a5,1
  fe:	fff7c703          	lbu	a4,-1(a5)
 102:	fb7d                	bnez	a4,f8 <strlen+0x14>
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ce09                	beqz	a2,12e <memset+0x20>
 116:	87aa                	mv	a5,a0
 118:	fff6071b          	addiw	a4,a2,-1
 11c:	1702                	slli	a4,a4,0x20
 11e:	9301                	srli	a4,a4,0x20
 120:	0705                	addi	a4,a4,1
 122:	972a                	add	a4,a4,a0
    cdst[i] = c;
 124:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 128:	0785                	addi	a5,a5,1
 12a:	fee79de3          	bne	a5,a4,124 <memset+0x16>
  }
  return dst;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strchr>:

char*
strchr(const char *s, char c)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb99                	beqz	a5,154 <strchr+0x20>
    if(*s == c)
 140:	00f58763          	beq	a1,a5,14e <strchr+0x1a>
  for(; *s; s++)
 144:	0505                	addi	a0,a0,1
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbfd                	bnez	a5,140 <strchr+0xc>
      return (char*)s;
  return 0;
 14c:	4501                	li	a0,0
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfe5                	j	14e <strchr+0x1a>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	711d                	addi	sp,sp,-96
 15a:	ec86                	sd	ra,88(sp)
 15c:	e8a2                	sd	s0,80(sp)
 15e:	e4a6                	sd	s1,72(sp)
 160:	e0ca                	sd	s2,64(sp)
 162:	fc4e                	sd	s3,56(sp)
 164:	f852                	sd	s4,48(sp)
 166:	f456                	sd	s5,40(sp)
 168:	f05a                	sd	s6,32(sp)
 16a:	ec5e                	sd	s7,24(sp)
 16c:	1080                	addi	s0,sp,96
 16e:	8baa                	mv	s7,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	892a                	mv	s2,a0
 174:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 176:	4aa9                	li	s5,10
 178:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 17a:	89a6                	mv	s3,s1
 17c:	2485                	addiw	s1,s1,1
 17e:	0344d663          	bge	s1,s4,1aa <gets+0x52>
    cc = read(0, &c, 1);
 182:	4605                	li	a2,1
 184:	faf40593          	addi	a1,s0,-81
 188:	4501                	li	a0,0
 18a:	1b8000ef          	jal	ra,342 <read>
    if(cc < 1)
 18e:	00a05e63          	blez	a0,1aa <gets+0x52>
    buf[i++] = c;
 192:	faf44783          	lbu	a5,-81(s0)
 196:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19a:	01578763          	beq	a5,s5,1a8 <gets+0x50>
 19e:	0905                	addi	s2,s2,1
 1a0:	fd679de3          	bne	a5,s6,17a <gets+0x22>
  for(i=0; i+1 < max; ){
 1a4:	89a6                	mv	s3,s1
 1a6:	a011                	j	1aa <gets+0x52>
 1a8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1aa:	99de                	add	s3,s3,s7
 1ac:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b0:	855e                	mv	a0,s7
 1b2:	60e6                	ld	ra,88(sp)
 1b4:	6446                	ld	s0,80(sp)
 1b6:	64a6                	ld	s1,72(sp)
 1b8:	6906                	ld	s2,64(sp)
 1ba:	79e2                	ld	s3,56(sp)
 1bc:	7a42                	ld	s4,48(sp)
 1be:	7aa2                	ld	s5,40(sp)
 1c0:	7b02                	ld	s6,32(sp)
 1c2:	6be2                	ld	s7,24(sp)
 1c4:	6125                	addi	sp,sp,96
 1c6:	8082                	ret

00000000000001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	e426                	sd	s1,8(sp)
 1d0:	e04a                	sd	s2,0(sp)
 1d2:	1000                	addi	s0,sp,32
 1d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	4581                	li	a1,0
 1d8:	192000ef          	jal	ra,36a <open>
  if(fd < 0)
 1dc:	02054163          	bltz	a0,1fe <stat+0x36>
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	19e000ef          	jal	ra,382 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	166000ef          	jal	ra,352 <close>
  return r;
}
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	64a2                	ld	s1,8(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfc5                	j	1f0 <stat+0x28>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054603          	lbu	a2,0(a0)
 20c:	fd06079b          	addiw	a5,a2,-48
 210:	0ff7f793          	andi	a5,a5,255
 214:	4725                	li	a4,9
 216:	02f76963          	bltu	a4,a5,248 <atoi+0x46>
 21a:	86aa                	mv	a3,a0
  n = 0;
 21c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 21e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 220:	0685                	addi	a3,a3,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb1                	addw	a5,a5,a2
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	0006c603          	lbu	a2,0(a3)
 236:	fd06071b          	addiw	a4,a2,-48
 23a:	0ff77713          	andi	a4,a4,255
 23e:	fee5f1e3          	bgeu	a1,a4,220 <atoi+0x1e>
  return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x40>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 252:	02b57663          	bgeu	a0,a1,27e <memmove+0x32>
    while(n-- > 0)
 256:	02c05163          	blez	a2,278 <memmove+0x2c>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	0785                	addi	a5,a5,1
 264:	97aa                	add	a5,a5,a0
  dst = vdst;
 266:	872a                	mv	a4,a0
      *dst++ = *src++;
 268:	0585                	addi	a1,a1,1
 26a:	0705                	addi	a4,a4,1
 26c:	fff5c683          	lbu	a3,-1(a1)
 270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
    dst += n;
 27e:	00c50733          	add	a4,a0,a2
    src += n;
 282:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 284:	fec05ae3          	blez	a2,278 <memmove+0x2c>
 288:	fff6079b          	addiw	a5,a2,-1
 28c:	1782                	slli	a5,a5,0x20
 28e:	9381                	srli	a5,a5,0x20
 290:	fff7c793          	not	a5,a5
 294:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 296:	15fd                	addi	a1,a1,-1
 298:	177d                	addi	a4,a4,-1
 29a:	0005c683          	lbu	a3,0(a1)
 29e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a2:	fee79ae3          	bne	a5,a4,296 <memmove+0x4a>
 2a6:	bfc9                	j	278 <memmove+0x2c>

00000000000002a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ae:	ca05                	beqz	a2,2de <memcmp+0x36>
 2b0:	fff6069b          	addiw	a3,a2,-1
 2b4:	1682                	slli	a3,a3,0x20
 2b6:	9281                	srli	a3,a3,0x20
 2b8:	0685                	addi	a3,a3,1
 2ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	0005c703          	lbu	a4,0(a1)
 2c4:	00e79863          	bne	a5,a4,2d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c8:	0505                	addi	a0,a0,1
    p2++;
 2ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2cc:	fed518e3          	bne	a0,a3,2bc <memcmp+0x14>
  }
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	a019                	j	2d8 <memcmp+0x30>
      return *p1 - *p2;
 2d4:	40e7853b          	subw	a0,a5,a4
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
  return 0;
 2de:	4501                	li	a0,0
 2e0:	bfe5                	j	2d8 <memcmp+0x30>

00000000000002e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ea:	f63ff0ef          	jal	ra,24c <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <sbrk>:

char *
sbrk(int n) {
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2fe:	4585                	li	a1,1
 300:	0b2000ef          	jal	ra,3b2 <sys_sbrk>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <sbrklazy>:

char *
sbrklazy(int n) {
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 314:	4589                	li	a1,2
 316:	09c000ef          	jal	ra,3b2 <sys_sbrk>
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 322:	4885                	li	a7,1
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	1000                	addi	s0,sp,32
 3d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d6:	4605                	li	a2,1
 3d8:	fef40593          	addi	a1,s0,-17
 3dc:	f6fff0ef          	jal	ra,34a <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3e8:	715d                	addi	sp,sp,-80
 3ea:	e486                	sd	ra,72(sp)
 3ec:	e0a2                	sd	s0,64(sp)
 3ee:	fc26                	sd	s1,56(sp)
 3f0:	f84a                	sd	s2,48(sp)
 3f2:	f44e                	sd	s3,40(sp)
 3f4:	0880                	addi	s0,sp,80
 3f6:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c299                	beqz	a3,3fe <printint+0x16>
 3fa:	0805c663          	bltz	a1,486 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fe:	2581                	sext.w	a1,a1
  neg = 0;
 400:	4881                	li	a7,0
 402:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 406:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 408:	2601                	sext.w	a2,a2
 40a:	00000517          	auipc	a0,0x0
 40e:	56650513          	addi	a0,a0,1382 # 970 <digits>
 412:	883a                	mv	a6,a4
 414:	2705                	addiw	a4,a4,1
 416:	02c5f7bb          	remuw	a5,a1,a2
 41a:	1782                	slli	a5,a5,0x20
 41c:	9381                	srli	a5,a5,0x20
 41e:	97aa                	add	a5,a5,a0
 420:	0007c783          	lbu	a5,0(a5)
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	0005879b          	sext.w	a5,a1
 42c:	02c5d5bb          	divuw	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f0e3          	bgeu	a5,a2,412 <printint+0x2a>
  if(neg)
 436:	00088b63          	beqz	a7,44c <printint+0x64>
    buf[i++] = '-';
 43a:	fd040793          	addi	a5,s0,-48
 43e:	973e                	add	a4,a4,a5
 440:	02d00793          	li	a5,45
 444:	fef70423          	sb	a5,-24(a4)
 448:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44c:	02e05663          	blez	a4,478 <printint+0x90>
 450:	fb840793          	addi	a5,s0,-72
 454:	00e78933          	add	s2,a5,a4
 458:	fff78993          	addi	s3,a5,-1
 45c:	99ba                	add	s3,s3,a4
 45e:	377d                	addiw	a4,a4,-1
 460:	1702                	slli	a4,a4,0x20
 462:	9301                	srli	a4,a4,0x20
 464:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 468:	fff94583          	lbu	a1,-1(s2)
 46c:	8526                	mv	a0,s1
 46e:	f5dff0ef          	jal	ra,3ca <putc>
  while(--i >= 0)
 472:	197d                	addi	s2,s2,-1
 474:	ff391ae3          	bne	s2,s3,468 <printint+0x80>
}
 478:	60a6                	ld	ra,72(sp)
 47a:	6406                	ld	s0,64(sp)
 47c:	74e2                	ld	s1,56(sp)
 47e:	7942                	ld	s2,48(sp)
 480:	79a2                	ld	s3,40(sp)
 482:	6161                	addi	sp,sp,80
 484:	8082                	ret
    x = -xx;
 486:	40b005bb          	negw	a1,a1
    neg = 1;
 48a:	4885                	li	a7,1
    x = -xx;
 48c:	bf9d                	j	402 <printint+0x1a>

000000000000048e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48e:	7119                	addi	sp,sp,-128
 490:	fc86                	sd	ra,120(sp)
 492:	f8a2                	sd	s0,112(sp)
 494:	f4a6                	sd	s1,104(sp)
 496:	f0ca                	sd	s2,96(sp)
 498:	ecce                	sd	s3,88(sp)
 49a:	e8d2                	sd	s4,80(sp)
 49c:	e4d6                	sd	s5,72(sp)
 49e:	e0da                	sd	s6,64(sp)
 4a0:	fc5e                	sd	s7,56(sp)
 4a2:	f862                	sd	s8,48(sp)
 4a4:	f466                	sd	s9,40(sp)
 4a6:	f06a                	sd	s10,32(sp)
 4a8:	ec6e                	sd	s11,24(sp)
 4aa:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ac:	0005c903          	lbu	s2,0(a1)
 4b0:	24090c63          	beqz	s2,708 <vprintf+0x27a>
 4b4:	8b2a                	mv	s6,a0
 4b6:	8a2e                	mv	s4,a1
 4b8:	8bb2                	mv	s7,a2
  state = 0;
 4ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4bc:	4481                	li	s1,0
 4be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4cc:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d0:	00000c97          	auipc	s9,0x0
 4d4:	4a0c8c93          	addi	s9,s9,1184 # 970 <digits>
 4d8:	a005                	j	4f8 <vprintf+0x6a>
        putc(fd, c0);
 4da:	85ca                	mv	a1,s2
 4dc:	855a                	mv	a0,s6
 4de:	eedff0ef          	jal	ra,3ca <putc>
 4e2:	a019                	j	4e8 <vprintf+0x5a>
    } else if(state == '%'){
 4e4:	03598263          	beq	s3,s5,508 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4e8:	2485                	addiw	s1,s1,1
 4ea:	8726                	mv	a4,s1
 4ec:	009a07b3          	add	a5,s4,s1
 4f0:	0007c903          	lbu	s2,0(a5)
 4f4:	20090a63          	beqz	s2,708 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 4f8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4fc:	fe0994e3          	bnez	s3,4e4 <vprintf+0x56>
      if(c0 == '%'){
 500:	fd579de3          	bne	a5,s5,4da <vprintf+0x4c>
        state = '%';
 504:	89be                	mv	s3,a5
 506:	b7cd                	j	4e8 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 508:	c3c1                	beqz	a5,588 <vprintf+0xfa>
 50a:	00ea06b3          	add	a3,s4,a4
 50e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 512:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 514:	c681                	beqz	a3,51c <vprintf+0x8e>
 516:	9752                	add	a4,a4,s4
 518:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 51c:	03878e63          	beq	a5,s8,558 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 520:	05a78863          	beq	a5,s10,570 <vprintf+0xe2>
      } else if(c0 == 'u'){
 524:	0db78b63          	beq	a5,s11,5fa <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 528:	07800713          	li	a4,120
 52c:	10e78d63          	beq	a5,a4,646 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 530:	07000713          	li	a4,112
 534:	14e78263          	beq	a5,a4,678 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 538:	06300713          	li	a4,99
 53c:	16e78f63          	beq	a5,a4,6ba <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 540:	07300713          	li	a4,115
 544:	18e78563          	beq	a5,a4,6ce <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 548:	05579063          	bne	a5,s5,588 <vprintf+0xfa>
        putc(fd, '%');
 54c:	85d6                	mv	a1,s5
 54e:	855a                	mv	a0,s6
 550:	e7bff0ef          	jal	ra,3ca <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 554:	4981                	li	s3,0
 556:	bf49                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 558:	008b8913          	addi	s2,s7,8
 55c:	4685                	li	a3,1
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e83ff0ef          	jal	ra,3e8 <printint>
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bfad                	j	4e8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 570:	03868663          	beq	a3,s8,59c <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 574:	05a68163          	beq	a3,s10,5b6 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 578:	09b68d63          	beq	a3,s11,612 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 57c:	03a68f63          	beq	a3,s10,5ba <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 580:	07800793          	li	a5,120
 584:	0cf68d63          	beq	a3,a5,65e <vprintf+0x1d0>
        putc(fd, '%');
 588:	85d6                	mv	a1,s5
 58a:	855a                	mv	a0,s6
 58c:	e3fff0ef          	jal	ra,3ca <putc>
        putc(fd, c0);
 590:	85ca                	mv	a1,s2
 592:	855a                	mv	a0,s6
 594:	e37ff0ef          	jal	ra,3ca <putc>
      state = 0;
 598:	4981                	li	s3,0
 59a:	b7b9                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e3fff0ef          	jal	ra,3e8 <printint>
        i += 1;
 5ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
        i += 1;
 5b4:	bf15                	j	4e8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b6:	03860563          	beq	a2,s8,5e0 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5ba:	07b60963          	beq	a2,s11,62c <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5be:	07800793          	li	a5,120
 5c2:	fcf613e3          	bne	a2,a5,588 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e15ff0ef          	jal	ra,3e8 <printint>
        i += 2;
 5d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	b729                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	dfbff0ef          	jal	ra,3e8 <printint>
        i += 2;
 5f2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	bdc5                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000be583          	lwu	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	de1ff0ef          	jal	ra,3e8 <printint>
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	bde1                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	dc9ff0ef          	jal	ra,3e8 <printint>
        i += 1;
 624:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
        i += 1;
 62a:	bd7d                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b8913          	addi	s2,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	dafff0ef          	jal	ra,3e8 <printint>
        i += 2;
 63e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	b555                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 646:	008b8913          	addi	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000be583          	lwu	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	d95ff0ef          	jal	ra,3e8 <printint>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b571                	j	4e8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	008b8913          	addi	s2,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	d7dff0ef          	jal	ra,3e8 <printint>
        i += 1;
 670:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	bd8d                	j	4e8 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 678:	008b8793          	addi	a5,s7,8
 67c:	f8f43423          	sd	a5,-120(s0)
 680:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 684:	03000593          	li	a1,48
 688:	855a                	mv	a0,s6
 68a:	d41ff0ef          	jal	ra,3ca <putc>
  putc(fd, 'x');
 68e:	07800593          	li	a1,120
 692:	855a                	mv	a0,s6
 694:	d37ff0ef          	jal	ra,3ca <putc>
 698:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69a:	03c9d793          	srli	a5,s3,0x3c
 69e:	97e6                	add	a5,a5,s9
 6a0:	0007c583          	lbu	a1,0(a5)
 6a4:	855a                	mv	a0,s6
 6a6:	d25ff0ef          	jal	ra,3ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6aa:	0992                	slli	s3,s3,0x4
 6ac:	397d                	addiw	s2,s2,-1
 6ae:	fe0916e3          	bnez	s2,69a <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 6b2:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bd05                	j	4e8 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 6ba:	008b8913          	addi	s2,s7,8
 6be:	000bc583          	lbu	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	d07ff0ef          	jal	ra,3ca <putc>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd31                	j	4e8 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6ce:	008b8993          	addi	s3,s7,8
 6d2:	000bb903          	ld	s2,0(s7)
 6d6:	00090f63          	beqz	s2,6f4 <vprintf+0x266>
        for(; *s; s++)
 6da:	00094583          	lbu	a1,0(s2)
 6de:	c195                	beqz	a1,702 <vprintf+0x274>
          putc(fd, *s);
 6e0:	855a                	mv	a0,s6
 6e2:	ce9ff0ef          	jal	ra,3ca <putc>
        for(; *s; s++)
 6e6:	0905                	addi	s2,s2,1
 6e8:	00094583          	lbu	a1,0(s2)
 6ec:	f9f5                	bnez	a1,6e0 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 6ee:	8bce                	mv	s7,s3
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bbdd                	j	4e8 <vprintf+0x5a>
          s = "(null)";
 6f4:	00000917          	auipc	s2,0x0
 6f8:	27490913          	addi	s2,s2,628 # 968 <malloc+0x15e>
        for(; *s; s++)
 6fc:	02800593          	li	a1,40
 700:	b7c5                	j	6e0 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 702:	8bce                	mv	s7,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	b3cd                	j	4e8 <vprintf+0x5a>
    }
  }
}
 708:	70e6                	ld	ra,120(sp)
 70a:	7446                	ld	s0,112(sp)
 70c:	74a6                	ld	s1,104(sp)
 70e:	7906                	ld	s2,96(sp)
 710:	69e6                	ld	s3,88(sp)
 712:	6a46                	ld	s4,80(sp)
 714:	6aa6                	ld	s5,72(sp)
 716:	6b06                	ld	s6,64(sp)
 718:	7be2                	ld	s7,56(sp)
 71a:	7c42                	ld	s8,48(sp)
 71c:	7ca2                	ld	s9,40(sp)
 71e:	7d02                	ld	s10,32(sp)
 720:	6de2                	ld	s11,24(sp)
 722:	6109                	addi	sp,sp,128
 724:	8082                	ret

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 742:	8622                	mv	a2,s0
 744:	d4bff0ef          	jal	ra,48e <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	addi	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	addi	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	d19ff0ef          	jal	ra,48e <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret

0000000000000782 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 788:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	00001797          	auipc	a5,0x1
 790:	8747b783          	ld	a5,-1932(a5) # 1000 <freep>
 794:	a805                	j	7c4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 796:	4618                	lw	a4,8(a2)
 798:	9db9                	addw	a1,a1,a4
 79a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	6318                	ld	a4,0(a4)
 7a2:	fee53823          	sd	a4,-16(a0)
 7a6:	a091                	j	7ea <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a8:	ff852703          	lw	a4,-8(a0)
 7ac:	9e39                	addw	a2,a2,a4
 7ae:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b0:	ff053703          	ld	a4,-16(a0)
 7b4:	e398                	sd	a4,0(a5)
 7b6:	a099                	j	7fc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e7e463          	bltu	a5,a4,7c2 <free+0x40>
 7be:	00e6ea63          	bltu	a3,a4,7d2 <free+0x50>
{
 7c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	fed7fae3          	bgeu	a5,a3,7b8 <free+0x36>
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e6e463          	bltu	a3,a4,7d2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	fee7eae3          	bltu	a5,a4,7c2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d2:	ff852583          	lw	a1,-8(a0)
 7d6:	6390                	ld	a2,0(a5)
 7d8:	02059713          	slli	a4,a1,0x20
 7dc:	9301                	srli	a4,a4,0x20
 7de:	0712                	slli	a4,a4,0x4
 7e0:	9736                	add	a4,a4,a3
 7e2:	fae60ae3          	beq	a2,a4,796 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ea:	4790                	lw	a2,8(a5)
 7ec:	02061713          	slli	a4,a2,0x20
 7f0:	9301                	srli	a4,a4,0x20
 7f2:	0712                	slli	a4,a4,0x4
 7f4:	973e                	add	a4,a4,a5
 7f6:	fae689e3          	beq	a3,a4,7a8 <free+0x26>
  } else
    p->s.ptr = bp;
 7fa:	e394                	sd	a3,0(a5)
  freep = p;
 7fc:	00001717          	auipc	a4,0x1
 800:	80f73223          	sd	a5,-2044(a4) # 1000 <freep>
}
 804:	6422                	ld	s0,8(sp)
 806:	0141                	addi	sp,sp,16
 808:	8082                	ret

000000000000080a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80a:	7139                	addi	sp,sp,-64
 80c:	fc06                	sd	ra,56(sp)
 80e:	f822                	sd	s0,48(sp)
 810:	f426                	sd	s1,40(sp)
 812:	f04a                	sd	s2,32(sp)
 814:	ec4e                	sd	s3,24(sp)
 816:	e852                	sd	s4,16(sp)
 818:	e456                	sd	s5,8(sp)
 81a:	e05a                	sd	s6,0(sp)
 81c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81e:	02051493          	slli	s1,a0,0x20
 822:	9081                	srli	s1,s1,0x20
 824:	04bd                	addi	s1,s1,15
 826:	8091                	srli	s1,s1,0x4
 828:	0014899b          	addiw	s3,s1,1
 82c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 82e:	00000517          	auipc	a0,0x0
 832:	7d253503          	ld	a0,2002(a0) # 1000 <freep>
 836:	c515                	beqz	a0,862 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	02977f63          	bgeu	a4,s1,87a <malloc+0x70>
 840:	8a4e                	mv	s4,s3
 842:	0009871b          	sext.w	a4,s3
 846:	6685                	lui	a3,0x1
 848:	00d77363          	bgeu	a4,a3,84e <malloc+0x44>
 84c:	6a05                	lui	s4,0x1
 84e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 852:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 856:	00000917          	auipc	s2,0x0
 85a:	7aa90913          	addi	s2,s2,1962 # 1000 <freep>
  if(p == SBRK_ERROR)
 85e:	5afd                	li	s5,-1
 860:	a0bd                	j	8ce <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 862:	00001797          	auipc	a5,0x1
 866:	9a678793          	addi	a5,a5,-1626 # 1208 <base>
 86a:	00000717          	auipc	a4,0x0
 86e:	78f73b23          	sd	a5,1942(a4) # 1000 <freep>
 872:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 874:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 878:	b7e1                	j	840 <malloc+0x36>
      if(p->s.size == nunits)
 87a:	02e48b63          	beq	s1,a4,8b0 <malloc+0xa6>
        p->s.size -= nunits;
 87e:	4137073b          	subw	a4,a4,s3
 882:	c798                	sw	a4,8(a5)
        p += p->s.size;
 884:	1702                	slli	a4,a4,0x20
 886:	9301                	srli	a4,a4,0x20
 888:	0712                	slli	a4,a4,0x4
 88a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 890:	00000717          	auipc	a4,0x0
 894:	76a73823          	sd	a0,1904(a4) # 1000 <freep>
      return (void*)(p + 1);
 898:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 89c:	70e2                	ld	ra,56(sp)
 89e:	7442                	ld	s0,48(sp)
 8a0:	74a2                	ld	s1,40(sp)
 8a2:	7902                	ld	s2,32(sp)
 8a4:	69e2                	ld	s3,24(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	6121                	addi	sp,sp,64
 8ae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b0:	6398                	ld	a4,0(a5)
 8b2:	e118                	sd	a4,0(a0)
 8b4:	bff1                	j	890 <malloc+0x86>
  hp->s.size = nu;
 8b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ba:	0541                	addi	a0,a0,16
 8bc:	ec7ff0ef          	jal	ra,782 <free>
  return freep;
 8c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c4:	dd61                	beqz	a0,89c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	fa9778e3          	bgeu	a4,s1,87a <malloc+0x70>
    if(p == freep)
 8ce:	00093703          	ld	a4,0(s2)
 8d2:	853e                	mv	a0,a5
 8d4:	fef719e3          	bne	a4,a5,8c6 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	a1dff0ef          	jal	ra,2f6 <sbrk>
  if(p == SBRK_ERROR)
 8de:	fd551ce3          	bne	a0,s5,8b6 <malloc+0xac>
        return 0;
 8e2:	4501                	li	a0,0
 8e4:	bf65                	j	89c <malloc+0x92>
