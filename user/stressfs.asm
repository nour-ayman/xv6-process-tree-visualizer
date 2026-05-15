
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	95a78793          	addi	a5,a5,-1702 # 970 <malloc+0x110>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	91450513          	addi	a0,a0,-1772 # 940 <malloc+0xe0>
  34:	772000ef          	jal	ra,7a6 <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	118000ef          	jal	ra,15c <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork() > 0)
  4c:	324000ef          	jal	ra,370 <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for(i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	8fc50513          	addi	a0,a0,-1796 # 958 <malloc+0xf8>
  64:	742000ef          	jal	ra,7a6 <printf>

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9cbd                	addw	s1,s1,a5
  6e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	33e000ef          	jal	ra,3b8 <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	30c000ef          	jal	ra,398 <write>
  for(i = 0; i < 20; i++)
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  close(fd);
  94:	854a                	mv	a0,s2
  96:	30a000ef          	jal	ra,3a0 <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	8ce50513          	addi	a0,a0,-1842 # 968 <malloc+0x108>
  a2:	704000ef          	jal	ra,7a6 <printf>

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	30c000ef          	jal	ra,3b8 <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	2d2000ef          	jal	ra,390 <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	2d8000ef          	jal	ra,3a0 <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	2b2000ef          	jal	ra,380 <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	2a4000ef          	jal	ra,378 <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e0:	f21ff0ef          	jal	ra,0 <main>
  exit(0);
  e4:	4501                	li	a0,0
  e6:	292000ef          	jal	ra,378 <exit>

00000000000000ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x26>
 13e:	0505                	addi	a0,a0,1
 140:	87aa                	mv	a5,a0
 142:	4685                	li	a3,1
 144:	9e89                	subw	a3,a3,a0
 146:	00f6853b          	addw	a0,a3,a5
 14a:	0785                	addi	a5,a5,1
 14c:	fff7c703          	lbu	a4,-1(a5)
 150:	fb7d                	bnez	a4,146 <strlen+0x14>
    ;
  return n;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ce09                	beqz	a2,17c <memset+0x20>
 164:	87aa                	mv	a5,a0
 166:	fff6071b          	addiw	a4,a2,-1
 16a:	1702                	slli	a4,a4,0x20
 16c:	9301                	srli	a4,a4,0x20
 16e:	0705                	addi	a4,a4,1
 170:	972a                	add	a4,a4,a0
    cdst[i] = c;
 172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 176:	0785                	addi	a5,a5,1
 178:	fee79de3          	bne	a5,a4,172 <memset+0x16>
  }
  return dst;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strchr>:

char*
strchr(const char *s, char c)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  for(; *s; s++)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cb99                	beqz	a5,1a2 <strchr+0x20>
    if(*s == c)
 18e:	00f58763          	beq	a1,a5,19c <strchr+0x1a>
  for(; *s; s++)
 192:	0505                	addi	a0,a0,1
 194:	00054783          	lbu	a5,0(a0)
 198:	fbfd                	bnez	a5,18e <strchr+0xc>
      return (char*)s;
  return 0;
 19a:	4501                	li	a0,0
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  return 0;
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strchr+0x1a>

00000000000001a6 <gets>:

char*
gets(char *buf, int max)
{
 1a6:	711d                	addi	sp,sp,-96
 1a8:	ec86                	sd	ra,88(sp)
 1aa:	e8a2                	sd	s0,80(sp)
 1ac:	e4a6                	sd	s1,72(sp)
 1ae:	e0ca                	sd	s2,64(sp)
 1b0:	fc4e                	sd	s3,56(sp)
 1b2:	f852                	sd	s4,48(sp)
 1b4:	f456                	sd	s5,40(sp)
 1b6:	f05a                	sd	s6,32(sp)
 1b8:	ec5e                	sd	s7,24(sp)
 1ba:	1080                	addi	s0,sp,96
 1bc:	8baa                	mv	s7,a0
 1be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	892a                	mv	s2,a0
 1c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c4:	4aa9                	li	s5,10
 1c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c8:	89a6                	mv	s3,s1
 1ca:	2485                	addiw	s1,s1,1
 1cc:	0344d663          	bge	s1,s4,1f8 <gets+0x52>
    cc = read(0, &c, 1);
 1d0:	4605                	li	a2,1
 1d2:	faf40593          	addi	a1,s0,-81
 1d6:	4501                	li	a0,0
 1d8:	1b8000ef          	jal	ra,390 <read>
    if(cc < 1)
 1dc:	00a05e63          	blez	a0,1f8 <gets+0x52>
    buf[i++] = c;
 1e0:	faf44783          	lbu	a5,-81(s0)
 1e4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e8:	01578763          	beq	a5,s5,1f6 <gets+0x50>
 1ec:	0905                	addi	s2,s2,1
 1ee:	fd679de3          	bne	a5,s6,1c8 <gets+0x22>
  for(i=0; i+1 < max; ){
 1f2:	89a6                	mv	s3,s1
 1f4:	a011                	j	1f8 <gets+0x52>
 1f6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f8:	99de                	add	s3,s3,s7
 1fa:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fe:	855e                	mv	a0,s7
 200:	60e6                	ld	ra,88(sp)
 202:	6446                	ld	s0,80(sp)
 204:	64a6                	ld	s1,72(sp)
 206:	6906                	ld	s2,64(sp)
 208:	79e2                	ld	s3,56(sp)
 20a:	7a42                	ld	s4,48(sp)
 20c:	7aa2                	ld	s5,40(sp)
 20e:	7b02                	ld	s6,32(sp)
 210:	6be2                	ld	s7,24(sp)
 212:	6125                	addi	sp,sp,96
 214:	8082                	ret

0000000000000216 <stat>:

int
stat(const char *n, struct stat *st)
{
 216:	1101                	addi	sp,sp,-32
 218:	ec06                	sd	ra,24(sp)
 21a:	e822                	sd	s0,16(sp)
 21c:	e426                	sd	s1,8(sp)
 21e:	e04a                	sd	s2,0(sp)
 220:	1000                	addi	s0,sp,32
 222:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 224:	4581                	li	a1,0
 226:	192000ef          	jal	ra,3b8 <open>
  if(fd < 0)
 22a:	02054163          	bltz	a0,24c <stat+0x36>
 22e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 230:	85ca                	mv	a1,s2
 232:	19e000ef          	jal	ra,3d0 <fstat>
 236:	892a                	mv	s2,a0
  close(fd);
 238:	8526                	mv	a0,s1
 23a:	166000ef          	jal	ra,3a0 <close>
  return r;
}
 23e:	854a                	mv	a0,s2
 240:	60e2                	ld	ra,24(sp)
 242:	6442                	ld	s0,16(sp)
 244:	64a2                	ld	s1,8(sp)
 246:	6902                	ld	s2,0(sp)
 248:	6105                	addi	sp,sp,32
 24a:	8082                	ret
    return -1;
 24c:	597d                	li	s2,-1
 24e:	bfc5                	j	23e <stat+0x28>

0000000000000250 <atoi>:

int
atoi(const char *s)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 256:	00054603          	lbu	a2,0(a0)
 25a:	fd06079b          	addiw	a5,a2,-48
 25e:	0ff7f793          	andi	a5,a5,255
 262:	4725                	li	a4,9
 264:	02f76963          	bltu	a4,a5,296 <atoi+0x46>
 268:	86aa                	mv	a3,a0
  n = 0;
 26a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 26c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 26e:	0685                	addi	a3,a3,1
 270:	0025179b          	slliw	a5,a0,0x2
 274:	9fa9                	addw	a5,a5,a0
 276:	0017979b          	slliw	a5,a5,0x1
 27a:	9fb1                	addw	a5,a5,a2
 27c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 280:	0006c603          	lbu	a2,0(a3)
 284:	fd06071b          	addiw	a4,a2,-48
 288:	0ff77713          	andi	a4,a4,255
 28c:	fee5f1e3          	bgeu	a1,a4,26e <atoi+0x1e>
  return n;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  n = 0;
 296:	4501                	li	a0,0
 298:	bfe5                	j	290 <atoi+0x40>

000000000000029a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57663          	bgeu	a0,a1,2cc <memmove+0x32>
    while(n-- > 0)
 2a4:	02c05163          	blez	a2,2c6 <memmove+0x2c>
 2a8:	fff6079b          	addiw	a5,a2,-1
 2ac:	1782                	slli	a5,a5,0x20
 2ae:	9381                	srli	a5,a5,0x20
 2b0:	0785                	addi	a5,a5,1
 2b2:	97aa                	add	a5,a5,a0
  dst = vdst;
 2b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b6:	0585                	addi	a1,a1,1
 2b8:	0705                	addi	a4,a4,1
 2ba:	fff5c683          	lbu	a3,-1(a1)
 2be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c2:	fee79ae3          	bne	a5,a4,2b6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
    dst += n;
 2cc:	00c50733          	add	a4,a0,a2
    src += n;
 2d0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d2:	fec05ae3          	blez	a2,2c6 <memmove+0x2c>
 2d6:	fff6079b          	addiw	a5,a2,-1
 2da:	1782                	slli	a5,a5,0x20
 2dc:	9381                	srli	a5,a5,0x20
 2de:	fff7c793          	not	a5,a5
 2e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e4:	15fd                	addi	a1,a1,-1
 2e6:	177d                	addi	a4,a4,-1
 2e8:	0005c683          	lbu	a3,0(a1)
 2ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x4a>
 2f4:	bfc9                	j	2c6 <memmove+0x2c>

00000000000002f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ca05                	beqz	a2,32c <memcmp+0x36>
 2fe:	fff6069b          	addiw	a3,a2,-1
 302:	1682                	slli	a3,a3,0x20
 304:	9281                	srli	a3,a3,0x20
 306:	0685                	addi	a3,a3,1
 308:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30a:	00054783          	lbu	a5,0(a0)
 30e:	0005c703          	lbu	a4,0(a1)
 312:	00e79863          	bne	a5,a4,322 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 316:	0505                	addi	a0,a0,1
    p2++;
 318:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31a:	fed518e3          	bne	a0,a3,30a <memcmp+0x14>
  }
  return 0;
 31e:	4501                	li	a0,0
 320:	a019                	j	326 <memcmp+0x30>
      return *p1 - *p2;
 322:	40e7853b          	subw	a0,a5,a4
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfe5                	j	326 <memcmp+0x30>

0000000000000330 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 338:	f63ff0ef          	jal	ra,29a <memmove>
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <sbrk>:

char *
sbrk(int n) {
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 34c:	4585                	li	a1,1
 34e:	0b2000ef          	jal	ra,400 <sys_sbrk>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <sbrklazy>:

char *
sbrklazy(int n) {
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 362:	4589                	li	a1,2
 364:	09c000ef          	jal	ra,400 <sys_sbrk>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 370:	4885                	li	a7,1
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <exit>:
.global exit
exit:
 li a7, SYS_exit
 378:	4889                	li	a7,2
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <wait>:
.global wait
wait:
 li a7, SYS_wait
 380:	488d                	li	a7,3
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 388:	4891                	li	a7,4
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <read>:
.global read
read:
 li a7, SYS_read
 390:	4895                	li	a7,5
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <write>:
.global write
write:
 li a7, SYS_write
 398:	48c1                	li	a7,16
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <close>:
.global close
close:
 li a7, SYS_close
 3a0:	48d5                	li	a7,21
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a8:	4899                	li	a7,6
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b0:	489d                	li	a7,7
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <open>:
.global open
open:
 li a7, SYS_open
 3b8:	48bd                	li	a7,15
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c0:	48c5                	li	a7,17
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c8:	48c9                	li	a7,18
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d0:	48a1                	li	a7,8
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <link>:
.global link
link:
 li a7, SYS_link
 3d8:	48cd                	li	a7,19
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e0:	48d1                	li	a7,20
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e8:	48a5                	li	a7,9
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f0:	48a9                	li	a7,10
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f8:	48ad                	li	a7,11
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 400:	48b1                	li	a7,12
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <pause>:
.global pause
pause:
 li a7, SYS_pause
 408:	48b5                	li	a7,13
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 410:	48b9                	li	a7,14
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
 418:	48d9                	li	a7,22
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	1000                	addi	s0,sp,32
 428:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42c:	4605                	li	a2,1
 42e:	fef40593          	addi	a1,s0,-17
 432:	f67ff0ef          	jal	ra,398 <write>
}
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret

000000000000043e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 43e:	715d                	addi	sp,sp,-80
 440:	e486                	sd	ra,72(sp)
 442:	e0a2                	sd	s0,64(sp)
 444:	fc26                	sd	s1,56(sp)
 446:	f84a                	sd	s2,48(sp)
 448:	f44e                	sd	s3,40(sp)
 44a:	0880                	addi	s0,sp,80
 44c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44e:	c299                	beqz	a3,454 <printint+0x16>
 450:	0805c663          	bltz	a1,4dc <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 454:	2581                	sext.w	a1,a1
  neg = 0;
 456:	4881                	li	a7,0
 458:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 45c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45e:	2601                	sext.w	a2,a2
 460:	00000517          	auipc	a0,0x0
 464:	52850513          	addi	a0,a0,1320 # 988 <digits>
 468:	883a                	mv	a6,a4
 46a:	2705                	addiw	a4,a4,1
 46c:	02c5f7bb          	remuw	a5,a1,a2
 470:	1782                	slli	a5,a5,0x20
 472:	9381                	srli	a5,a5,0x20
 474:	97aa                	add	a5,a5,a0
 476:	0007c783          	lbu	a5,0(a5)
 47a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47e:	0005879b          	sext.w	a5,a1
 482:	02c5d5bb          	divuw	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fec7f0e3          	bgeu	a5,a2,468 <printint+0x2a>
  if(neg)
 48c:	00088b63          	beqz	a7,4a2 <printint+0x64>
    buf[i++] = '-';
 490:	fd040793          	addi	a5,s0,-48
 494:	973e                	add	a4,a4,a5
 496:	02d00793          	li	a5,45
 49a:	fef70423          	sb	a5,-24(a4)
 49e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a2:	02e05663          	blez	a4,4ce <printint+0x90>
 4a6:	fb840793          	addi	a5,s0,-72
 4aa:	00e78933          	add	s2,a5,a4
 4ae:	fff78993          	addi	s3,a5,-1
 4b2:	99ba                	add	s3,s3,a4
 4b4:	377d                	addiw	a4,a4,-1
 4b6:	1702                	slli	a4,a4,0x20
 4b8:	9301                	srli	a4,a4,0x20
 4ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4be:	fff94583          	lbu	a1,-1(s2)
 4c2:	8526                	mv	a0,s1
 4c4:	f5dff0ef          	jal	ra,420 <putc>
  while(--i >= 0)
 4c8:	197d                	addi	s2,s2,-1
 4ca:	ff391ae3          	bne	s2,s3,4be <printint+0x80>
}
 4ce:	60a6                	ld	ra,72(sp)
 4d0:	6406                	ld	s0,64(sp)
 4d2:	74e2                	ld	s1,56(sp)
 4d4:	7942                	ld	s2,48(sp)
 4d6:	79a2                	ld	s3,40(sp)
 4d8:	6161                	addi	sp,sp,80
 4da:	8082                	ret
    x = -xx;
 4dc:	40b005bb          	negw	a1,a1
    neg = 1;
 4e0:	4885                	li	a7,1
    x = -xx;
 4e2:	bf9d                	j	458 <printint+0x1a>

00000000000004e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e4:	7119                	addi	sp,sp,-128
 4e6:	fc86                	sd	ra,120(sp)
 4e8:	f8a2                	sd	s0,112(sp)
 4ea:	f4a6                	sd	s1,104(sp)
 4ec:	f0ca                	sd	s2,96(sp)
 4ee:	ecce                	sd	s3,88(sp)
 4f0:	e8d2                	sd	s4,80(sp)
 4f2:	e4d6                	sd	s5,72(sp)
 4f4:	e0da                	sd	s6,64(sp)
 4f6:	fc5e                	sd	s7,56(sp)
 4f8:	f862                	sd	s8,48(sp)
 4fa:	f466                	sd	s9,40(sp)
 4fc:	f06a                	sd	s10,32(sp)
 4fe:	ec6e                	sd	s11,24(sp)
 500:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 502:	0005c903          	lbu	s2,0(a1)
 506:	24090c63          	beqz	s2,75e <vprintf+0x27a>
 50a:	8b2a                	mv	s6,a0
 50c:	8a2e                	mv	s4,a1
 50e:	8bb2                	mv	s7,a2
  state = 0;
 510:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 512:	4481                	li	s1,0
 514:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 516:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 51a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 51e:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 522:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 526:	00000c97          	auipc	s9,0x0
 52a:	462c8c93          	addi	s9,s9,1122 # 988 <digits>
 52e:	a005                	j	54e <vprintf+0x6a>
        putc(fd, c0);
 530:	85ca                	mv	a1,s2
 532:	855a                	mv	a0,s6
 534:	eedff0ef          	jal	ra,420 <putc>
 538:	a019                	j	53e <vprintf+0x5a>
    } else if(state == '%'){
 53a:	03598263          	beq	s3,s5,55e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 53e:	2485                	addiw	s1,s1,1
 540:	8726                	mv	a4,s1
 542:	009a07b3          	add	a5,s4,s1
 546:	0007c903          	lbu	s2,0(a5)
 54a:	20090a63          	beqz	s2,75e <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 54e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 552:	fe0994e3          	bnez	s3,53a <vprintf+0x56>
      if(c0 == '%'){
 556:	fd579de3          	bne	a5,s5,530 <vprintf+0x4c>
        state = '%';
 55a:	89be                	mv	s3,a5
 55c:	b7cd                	j	53e <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 55e:	c3c1                	beqz	a5,5de <vprintf+0xfa>
 560:	00ea06b3          	add	a3,s4,a4
 564:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 568:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 56a:	c681                	beqz	a3,572 <vprintf+0x8e>
 56c:	9752                	add	a4,a4,s4
 56e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 572:	03878e63          	beq	a5,s8,5ae <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 576:	05a78863          	beq	a5,s10,5c6 <vprintf+0xe2>
      } else if(c0 == 'u'){
 57a:	0db78b63          	beq	a5,s11,650 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57e:	07800713          	li	a4,120
 582:	10e78d63          	beq	a5,a4,69c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 586:	07000713          	li	a4,112
 58a:	14e78263          	beq	a5,a4,6ce <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 58e:	06300713          	li	a4,99
 592:	16e78f63          	beq	a5,a4,710 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 596:	07300713          	li	a4,115
 59a:	18e78563          	beq	a5,a4,724 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 59e:	05579063          	bne	a5,s5,5de <vprintf+0xfa>
        putc(fd, '%');
 5a2:	85d6                	mv	a1,s5
 5a4:	855a                	mv	a0,s6
 5a6:	e7bff0ef          	jal	ra,420 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf49                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e83ff0ef          	jal	ra,43e <printint>
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bfad                	j	53e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c6:	03868663          	beq	a3,s8,5f2 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ca:	05a68163          	beq	a3,s10,60c <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5ce:	09b68d63          	beq	a3,s11,668 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d2:	03a68f63          	beq	a3,s10,610 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5d6:	07800793          	li	a5,120
 5da:	0cf68d63          	beq	a3,a5,6b4 <vprintf+0x1d0>
        putc(fd, '%');
 5de:	85d6                	mv	a1,s5
 5e0:	855a                	mv	a0,s6
 5e2:	e3fff0ef          	jal	ra,420 <putc>
        putc(fd, c0);
 5e6:	85ca                	mv	a1,s2
 5e8:	855a                	mv	a0,s6
 5ea:	e37ff0ef          	jal	ra,420 <putc>
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b7b9                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e3fff0ef          	jal	ra,43e <printint>
        i += 1;
 604:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
        i += 1;
 60a:	bf15                	j	53e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60c:	03860563          	beq	a2,s8,636 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 610:	07b60963          	beq	a2,s11,682 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 614:	07800793          	li	a5,120
 618:	fcf613e3          	bne	a2,a5,5de <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e15ff0ef          	jal	ra,43e <printint>
        i += 2;
 62e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 2;
 634:	b729                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	008b8913          	addi	s2,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	dfbff0ef          	jal	ra,43e <printint>
        i += 2;
 648:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bdc5                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4629                	li	a2,10
 658:	000be583          	lwu	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	de1ff0ef          	jal	ra,43e <printint>
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	bde1                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4629                	li	a2,10
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	dc9ff0ef          	jal	ra,43e <printint>
        i += 1;
 67a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 1;
 680:	bd7d                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dafff0ef          	jal	ra,43e <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	b555                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4641                	li	a2,16
 6a4:	000be583          	lwu	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	d95ff0ef          	jal	ra,43e <printint>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b571                	j	53e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4641                	li	a2,16
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	d7dff0ef          	jal	ra,43e <printint>
        i += 1;
 6c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 1;
 6cc:	bd8d                	j	53e <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6ce:	008b8793          	addi	a5,s7,8
 6d2:	f8f43423          	sd	a5,-120(s0)
 6d6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6da:	03000593          	li	a1,48
 6de:	855a                	mv	a0,s6
 6e0:	d41ff0ef          	jal	ra,420 <putc>
  putc(fd, 'x');
 6e4:	07800593          	li	a1,120
 6e8:	855a                	mv	a0,s6
 6ea:	d37ff0ef          	jal	ra,420 <putc>
 6ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f0:	03c9d793          	srli	a5,s3,0x3c
 6f4:	97e6                	add	a5,a5,s9
 6f6:	0007c583          	lbu	a1,0(a5)
 6fa:	855a                	mv	a0,s6
 6fc:	d25ff0ef          	jal	ra,420 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 700:	0992                	slli	s3,s3,0x4
 702:	397d                	addiw	s2,s2,-1
 704:	fe0916e3          	bnez	s2,6f0 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 708:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bd05                	j	53e <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 710:	008b8913          	addi	s2,s7,8
 714:	000bc583          	lbu	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	d07ff0ef          	jal	ra,420 <putc>
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
 722:	bd31                	j	53e <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 724:	008b8993          	addi	s3,s7,8
 728:	000bb903          	ld	s2,0(s7)
 72c:	00090f63          	beqz	s2,74a <vprintf+0x266>
        for(; *s; s++)
 730:	00094583          	lbu	a1,0(s2)
 734:	c195                	beqz	a1,758 <vprintf+0x274>
          putc(fd, *s);
 736:	855a                	mv	a0,s6
 738:	ce9ff0ef          	jal	ra,420 <putc>
        for(; *s; s++)
 73c:	0905                	addi	s2,s2,1
 73e:	00094583          	lbu	a1,0(s2)
 742:	f9f5                	bnez	a1,736 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	bbdd                	j	53e <vprintf+0x5a>
          s = "(null)";
 74a:	00000917          	auipc	s2,0x0
 74e:	23690913          	addi	s2,s2,566 # 980 <malloc+0x120>
        for(; *s; s++)
 752:	02800593          	li	a1,40
 756:	b7c5                	j	736 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b3cd                	j	53e <vprintf+0x5a>
    }
  }
}
 75e:	70e6                	ld	ra,120(sp)
 760:	7446                	ld	s0,112(sp)
 762:	74a6                	ld	s1,104(sp)
 764:	7906                	ld	s2,96(sp)
 766:	69e6                	ld	s3,88(sp)
 768:	6a46                	ld	s4,80(sp)
 76a:	6aa6                	ld	s5,72(sp)
 76c:	6b06                	ld	s6,64(sp)
 76e:	7be2                	ld	s7,56(sp)
 770:	7c42                	ld	s8,48(sp)
 772:	7ca2                	ld	s9,40(sp)
 774:	7d02                	ld	s10,32(sp)
 776:	6de2                	ld	s11,24(sp)
 778:	6109                	addi	sp,sp,128
 77a:	8082                	ret

000000000000077c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e010                	sd	a2,0(s0)
 786:	e414                	sd	a3,8(s0)
 788:	e818                	sd	a4,16(s0)
 78a:	ec1c                	sd	a5,24(s0)
 78c:	03043023          	sd	a6,32(s0)
 790:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 794:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 798:	8622                	mv	a2,s0
 79a:	d4bff0ef          	jal	ra,4e4 <vprintf>
}
 79e:	60e2                	ld	ra,24(sp)
 7a0:	6442                	ld	s0,16(sp)
 7a2:	6161                	addi	sp,sp,80
 7a4:	8082                	ret

00000000000007a6 <printf>:

void
printf(const char *fmt, ...)
{
 7a6:	711d                	addi	sp,sp,-96
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	1000                	addi	s0,sp,32
 7ae:	e40c                	sd	a1,8(s0)
 7b0:	e810                	sd	a2,16(s0)
 7b2:	ec14                	sd	a3,24(s0)
 7b4:	f018                	sd	a4,32(s0)
 7b6:	f41c                	sd	a5,40(s0)
 7b8:	03043823          	sd	a6,48(s0)
 7bc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	00840613          	addi	a2,s0,8
 7c4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c8:	85aa                	mv	a1,a0
 7ca:	4505                	li	a0,1
 7cc:	d19ff0ef          	jal	ra,4e4 <vprintf>
}
 7d0:	60e2                	ld	ra,24(sp)
 7d2:	6442                	ld	s0,16(sp)
 7d4:	6125                	addi	sp,sp,96
 7d6:	8082                	ret

00000000000007d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d8:	1141                	addi	sp,sp,-16
 7da:	e422                	sd	s0,8(sp)
 7dc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7de:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e2:	00001797          	auipc	a5,0x1
 7e6:	81e7b783          	ld	a5,-2018(a5) # 1000 <freep>
 7ea:	a805                	j	81a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ec:	4618                	lw	a4,8(a2)
 7ee:	9db9                	addw	a1,a1,a4
 7f0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	6318                	ld	a4,0(a4)
 7f8:	fee53823          	sd	a4,-16(a0)
 7fc:	a091                	j	840 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7fe:	ff852703          	lw	a4,-8(a0)
 802:	9e39                	addw	a2,a2,a4
 804:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 806:	ff053703          	ld	a4,-16(a0)
 80a:	e398                	sd	a4,0(a5)
 80c:	a099                	j	852 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	6398                	ld	a4,0(a5)
 810:	00e7e463          	bltu	a5,a4,818 <free+0x40>
 814:	00e6ea63          	bltu	a3,a4,828 <free+0x50>
{
 818:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	fed7fae3          	bgeu	a5,a3,80e <free+0x36>
 81e:	6398                	ld	a4,0(a5)
 820:	00e6e463          	bltu	a3,a4,828 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	fee7eae3          	bltu	a5,a4,818 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 828:	ff852583          	lw	a1,-8(a0)
 82c:	6390                	ld	a2,0(a5)
 82e:	02059713          	slli	a4,a1,0x20
 832:	9301                	srli	a4,a4,0x20
 834:	0712                	slli	a4,a4,0x4
 836:	9736                	add	a4,a4,a3
 838:	fae60ae3          	beq	a2,a4,7ec <free+0x14>
    bp->s.ptr = p->s.ptr;
 83c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 840:	4790                	lw	a2,8(a5)
 842:	02061713          	slli	a4,a2,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	0712                	slli	a4,a4,0x4
 84a:	973e                	add	a4,a4,a5
 84c:	fae689e3          	beq	a3,a4,7fe <free+0x26>
  } else
    p->s.ptr = bp;
 850:	e394                	sd	a3,0(a5)
  freep = p;
 852:	00000717          	auipc	a4,0x0
 856:	7af73723          	sd	a5,1966(a4) # 1000 <freep>
}
 85a:	6422                	ld	s0,8(sp)
 85c:	0141                	addi	sp,sp,16
 85e:	8082                	ret

0000000000000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	7139                	addi	sp,sp,-64
 862:	fc06                	sd	ra,56(sp)
 864:	f822                	sd	s0,48(sp)
 866:	f426                	sd	s1,40(sp)
 868:	f04a                	sd	s2,32(sp)
 86a:	ec4e                	sd	s3,24(sp)
 86c:	e852                	sd	s4,16(sp)
 86e:	e456                	sd	s5,8(sp)
 870:	e05a                	sd	s6,0(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051493          	slli	s1,a0,0x20
 878:	9081                	srli	s1,s1,0x20
 87a:	04bd                	addi	s1,s1,15
 87c:	8091                	srli	s1,s1,0x4
 87e:	0014899b          	addiw	s3,s1,1
 882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	77c53503          	ld	a0,1916(a0) # 1000 <freep>
 88c:	c515                	beqz	a0,8b8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	02977f63          	bgeu	a4,s1,8d0 <malloc+0x70>
 896:	8a4e                	mv	s4,s3
 898:	0009871b          	sext.w	a4,s3
 89c:	6685                	lui	a3,0x1
 89e:	00d77363          	bgeu	a4,a3,8a4 <malloc+0x44>
 8a2:	6a05                	lui	s4,0x1
 8a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ac:	00000917          	auipc	s2,0x0
 8b0:	75490913          	addi	s2,s2,1876 # 1000 <freep>
  if(p == SBRK_ERROR)
 8b4:	5afd                	li	s5,-1
 8b6:	a0bd                	j	924 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8b8:	00000797          	auipc	a5,0x0
 8bc:	75878793          	addi	a5,a5,1880 # 1010 <base>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73023          	sd	a5,1856(a4) # 1000 <freep>
 8c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ce:	b7e1                	j	896 <malloc+0x36>
      if(p->s.size == nunits)
 8d0:	02e48b63          	beq	s1,a4,906 <malloc+0xa6>
        p->s.size -= nunits;
 8d4:	4137073b          	subw	a4,a4,s3
 8d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8da:	1702                	slli	a4,a4,0x20
 8dc:	9301                	srli	a4,a4,0x20
 8de:	0712                	slli	a4,a4,0x4
 8e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70a73d23          	sd	a0,1818(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ee:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f2:	70e2                	ld	ra,56(sp)
 8f4:	7442                	ld	s0,48(sp)
 8f6:	74a2                	ld	s1,40(sp)
 8f8:	7902                	ld	s2,32(sp)
 8fa:	69e2                	ld	s3,24(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 906:	6398                	ld	a4,0(a5)
 908:	e118                	sd	a4,0(a0)
 90a:	bff1                	j	8e6 <malloc+0x86>
  hp->s.size = nu;
 90c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 910:	0541                	addi	a0,a0,16
 912:	ec7ff0ef          	jal	ra,7d8 <free>
  return freep;
 916:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91a:	dd61                	beqz	a0,8f2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	fa9778e3          	bgeu	a4,s1,8d0 <malloc+0x70>
    if(p == freep)
 924:	00093703          	ld	a4,0(s2)
 928:	853e                	mv	a0,a5
 92a:	fef719e3          	bne	a4,a5,91c <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 92e:	8552                	mv	a0,s4
 930:	a15ff0ef          	jal	ra,344 <sbrk>
  if(p == SBRK_ERROR)
 934:	fd551ce3          	bne	a0,s5,90c <malloc+0xac>
        return 0;
 938:	4501                	li	a0,0
 93a:	bf65                	j	8f2 <malloc+0x92>
