
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	91050513          	addi	a0,a0,-1776 # 920 <malloc+0xdc>
  18:	38c000ef          	jal	ra,3a4 <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	addi	a1,s0,-56
  24:	398000ef          	jal	ra,3bc <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	8f450513          	addi	a0,a0,-1804 # 920 <malloc+0xdc>
  34:	380000ef          	jal	ra,3b4 <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	8e250513          	addi	a0,a0,-1822 # 920 <malloc+0xdc>
  46:	35e000ef          	jal	ra,3a4 <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	92650513          	addi	a0,a0,-1754 # 978 <malloc+0x134>
  5a:	730000ef          	jal	ra,78a <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	304000ef          	jal	ra,364 <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	8c250513          	addi	a0,a0,-1854 # 928 <malloc+0xe4>
  6e:	71c000ef          	jal	ra,78a <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	2f0000ef          	jal	ra,364 <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	8c868693          	addi	a3,a3,-1848 # 940 <malloc+0xfc>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	8c658593          	addi	a1,a1,-1850 # 948 <malloc+0x104>
  8a:	4509                	li	a0,2
  8c:	6d4000ef          	jal	ra,760 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2d2000ef          	jal	ra,364 <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8c850513          	addi	a0,a0,-1848 # 960 <malloc+0x11c>
  a0:	6ea000ef          	jal	ra,78a <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2be000ef          	jal	ra,364 <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	8e250513          	addi	a0,a0,-1822 # 990 <malloc+0x14c>
  b6:	6d4000ef          	jal	ra,78a <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800513          	li	a0,1000
  be:	336000ef          	jal	ra,3f4 <pause>
  c2:	bfe5                	j	ba <main+0xba>

00000000000000c4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  extern int main();
  main();
  cc:	f35ff0ef          	jal	ra,0 <main>
  exit(0);
  d0:	4501                	li	a0,0
  d2:	292000ef          	jal	ra,364 <exit>

00000000000000d6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  dc:	87aa                	mv	a5,a0
  de:	0585                	addi	a1,a1,1
  e0:	0785                	addi	a5,a5,1
  e2:	fff5c703          	lbu	a4,-1(a1)
  e6:	fee78fa3          	sb	a4,-1(a5)
  ea:	fb75                	bnez	a4,de <strcpy+0x8>
    ;
  return os;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb91                	beqz	a5,110 <strcmp+0x1e>
  fe:	0005c703          	lbu	a4,0(a1)
 102:	00f71763          	bne	a4,a5,110 <strcmp+0x1e>
    p++, q++;
 106:	0505                	addi	a0,a0,1
 108:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbe5                	bnez	a5,fe <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 110:	0005c503          	lbu	a0,0(a1)
}
 114:	40a7853b          	subw	a0,a5,a0
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x26>
 12a:	0505                	addi	a0,a0,1
 12c:	87aa                	mv	a5,a0
 12e:	4685                	li	a3,1
 130:	9e89                	subw	a3,a3,a0
 132:	00f6853b          	addw	a0,a3,a5
 136:	0785                	addi	a5,a5,1
 138:	fff7c703          	lbu	a4,-1(a5)
 13c:	fb7d                	bnez	a4,132 <strlen+0x14>
    ;
  return n;
}
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for(n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strlen+0x20>

0000000000000148 <memset>:

void*
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14e:	ce09                	beqz	a2,168 <memset+0x20>
 150:	87aa                	mv	a5,a0
 152:	fff6071b          	addiw	a4,a2,-1
 156:	1702                	slli	a4,a4,0x20
 158:	9301                	srli	a4,a4,0x20
 15a:	0705                	addi	a4,a4,1
 15c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 162:	0785                	addi	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x16>
  }
  return dst;
}
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  for(; *s; s++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cb99                	beqz	a5,18e <strchr+0x20>
    if(*s == c)
 17a:	00f58763          	beq	a1,a5,188 <strchr+0x1a>
  for(; *s; s++)
 17e:	0505                	addi	a0,a0,1
 180:	00054783          	lbu	a5,0(a0)
 184:	fbfd                	bnez	a5,17a <strchr+0xc>
      return (char*)s;
  return 0;
 186:	4501                	li	a0,0
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret
  return 0;
 18e:	4501                	li	a0,0
 190:	bfe5                	j	188 <strchr+0x1a>

0000000000000192 <gets>:

char*
gets(char *buf, int max)
{
 192:	711d                	addi	sp,sp,-96
 194:	ec86                	sd	ra,88(sp)
 196:	e8a2                	sd	s0,80(sp)
 198:	e4a6                	sd	s1,72(sp)
 19a:	e0ca                	sd	s2,64(sp)
 19c:	fc4e                	sd	s3,56(sp)
 19e:	f852                	sd	s4,48(sp)
 1a0:	f456                	sd	s5,40(sp)
 1a2:	f05a                	sd	s6,32(sp)
 1a4:	ec5e                	sd	s7,24(sp)
 1a6:	1080                	addi	s0,sp,96
 1a8:	8baa                	mv	s7,a0
 1aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	892a                	mv	s2,a0
 1ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b0:	4aa9                	li	s5,10
 1b2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b4:	89a6                	mv	s3,s1
 1b6:	2485                	addiw	s1,s1,1
 1b8:	0344d663          	bge	s1,s4,1e4 <gets+0x52>
    cc = read(0, &c, 1);
 1bc:	4605                	li	a2,1
 1be:	faf40593          	addi	a1,s0,-81
 1c2:	4501                	li	a0,0
 1c4:	1b8000ef          	jal	ra,37c <read>
    if(cc < 1)
 1c8:	00a05e63          	blez	a0,1e4 <gets+0x52>
    buf[i++] = c;
 1cc:	faf44783          	lbu	a5,-81(s0)
 1d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d4:	01578763          	beq	a5,s5,1e2 <gets+0x50>
 1d8:	0905                	addi	s2,s2,1
 1da:	fd679de3          	bne	a5,s6,1b4 <gets+0x22>
  for(i=0; i+1 < max; ){
 1de:	89a6                	mv	s3,s1
 1e0:	a011                	j	1e4 <gets+0x52>
 1e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e4:	99de                	add	s3,s3,s7
 1e6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ea:	855e                	mv	a0,s7
 1ec:	60e6                	ld	ra,88(sp)
 1ee:	6446                	ld	s0,80(sp)
 1f0:	64a6                	ld	s1,72(sp)
 1f2:	6906                	ld	s2,64(sp)
 1f4:	79e2                	ld	s3,56(sp)
 1f6:	7a42                	ld	s4,48(sp)
 1f8:	7aa2                	ld	s5,40(sp)
 1fa:	7b02                	ld	s6,32(sp)
 1fc:	6be2                	ld	s7,24(sp)
 1fe:	6125                	addi	sp,sp,96
 200:	8082                	ret

0000000000000202 <stat>:

int
stat(const char *n, struct stat *st)
{
 202:	1101                	addi	sp,sp,-32
 204:	ec06                	sd	ra,24(sp)
 206:	e822                	sd	s0,16(sp)
 208:	e426                	sd	s1,8(sp)
 20a:	e04a                	sd	s2,0(sp)
 20c:	1000                	addi	s0,sp,32
 20e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	4581                	li	a1,0
 212:	192000ef          	jal	ra,3a4 <open>
  if(fd < 0)
 216:	02054163          	bltz	a0,238 <stat+0x36>
 21a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21c:	85ca                	mv	a1,s2
 21e:	19e000ef          	jal	ra,3bc <fstat>
 222:	892a                	mv	s2,a0
  close(fd);
 224:	8526                	mv	a0,s1
 226:	166000ef          	jal	ra,38c <close>
  return r;
}
 22a:	854a                	mv	a0,s2
 22c:	60e2                	ld	ra,24(sp)
 22e:	6442                	ld	s0,16(sp)
 230:	64a2                	ld	s1,8(sp)
 232:	6902                	ld	s2,0(sp)
 234:	6105                	addi	sp,sp,32
 236:	8082                	ret
    return -1;
 238:	597d                	li	s2,-1
 23a:	bfc5                	j	22a <stat+0x28>

000000000000023c <atoi>:

int
atoi(const char *s)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 242:	00054603          	lbu	a2,0(a0)
 246:	fd06079b          	addiw	a5,a2,-48
 24a:	0ff7f793          	andi	a5,a5,255
 24e:	4725                	li	a4,9
 250:	02f76963          	bltu	a4,a5,282 <atoi+0x46>
 254:	86aa                	mv	a3,a0
  n = 0;
 256:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 258:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 25a:	0685                	addi	a3,a3,1
 25c:	0025179b          	slliw	a5,a0,0x2
 260:	9fa9                	addw	a5,a5,a0
 262:	0017979b          	slliw	a5,a5,0x1
 266:	9fb1                	addw	a5,a5,a2
 268:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 26c:	0006c603          	lbu	a2,0(a3)
 270:	fd06071b          	addiw	a4,a2,-48
 274:	0ff77713          	andi	a4,a4,255
 278:	fee5f1e3          	bgeu	a1,a4,25a <atoi+0x1e>
  return n;
}
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
  n = 0;
 282:	4501                	li	a0,0
 284:	bfe5                	j	27c <atoi+0x40>

0000000000000286 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28c:	02b57663          	bgeu	a0,a1,2b8 <memmove+0x32>
    while(n-- > 0)
 290:	02c05163          	blez	a2,2b2 <memmove+0x2c>
 294:	fff6079b          	addiw	a5,a2,-1
 298:	1782                	slli	a5,a5,0x20
 29a:	9381                	srli	a5,a5,0x20
 29c:	0785                	addi	a5,a5,1
 29e:	97aa                	add	a5,a5,a0
  dst = vdst;
 2a0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a2:	0585                	addi	a1,a1,1
 2a4:	0705                	addi	a4,a4,1
 2a6:	fff5c683          	lbu	a3,-1(a1)
 2aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ae:	fee79ae3          	bne	a5,a4,2a2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
    dst += n;
 2b8:	00c50733          	add	a4,a0,a2
    src += n;
 2bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2be:	fec05ae3          	blez	a2,2b2 <memmove+0x2c>
 2c2:	fff6079b          	addiw	a5,a2,-1
 2c6:	1782                	slli	a5,a5,0x20
 2c8:	9381                	srli	a5,a5,0x20
 2ca:	fff7c793          	not	a5,a5
 2ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d0:	15fd                	addi	a1,a1,-1
 2d2:	177d                	addi	a4,a4,-1
 2d4:	0005c683          	lbu	a3,0(a1)
 2d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2dc:	fee79ae3          	bne	a5,a4,2d0 <memmove+0x4a>
 2e0:	bfc9                	j	2b2 <memmove+0x2c>

00000000000002e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e8:	ca05                	beqz	a2,318 <memcmp+0x36>
 2ea:	fff6069b          	addiw	a3,a2,-1
 2ee:	1682                	slli	a3,a3,0x20
 2f0:	9281                	srli	a3,a3,0x20
 2f2:	0685                	addi	a3,a3,1
 2f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	0005c703          	lbu	a4,0(a1)
 2fe:	00e79863          	bne	a5,a4,30e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 302:	0505                	addi	a0,a0,1
    p2++;
 304:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 306:	fed518e3          	bne	a0,a3,2f6 <memcmp+0x14>
  }
  return 0;
 30a:	4501                	li	a0,0
 30c:	a019                	j	312 <memcmp+0x30>
      return *p1 - *p2;
 30e:	40e7853b          	subw	a0,a5,a4
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  return 0;
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <memcmp+0x30>

000000000000031c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 324:	f63ff0ef          	jal	ra,286 <memmove>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <sbrk>:

char *
sbrk(int n) {
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 338:	4585                	li	a1,1
 33a:	0b2000ef          	jal	ra,3ec <sys_sbrk>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <sbrklazy>:

char *
sbrklazy(int n) {
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 34e:	4589                	li	a1,2
 350:	09c000ef          	jal	ra,3ec <sys_sbrk>
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35c:	4885                	li	a7,1
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exit>:
.global exit
exit:
 li a7, SYS_exit
 364:	4889                	li	a7,2
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <wait>:
.global wait
wait:
 li a7, SYS_wait
 36c:	488d                	li	a7,3
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 374:	4891                	li	a7,4
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <read>:
.global read
read:
 li a7, SYS_read
 37c:	4895                	li	a7,5
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <write>:
.global write
write:
 li a7, SYS_write
 384:	48c1                	li	a7,16
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <close>:
.global close
close:
 li a7, SYS_close
 38c:	48d5                	li	a7,21
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <kill>:
.global kill
kill:
 li a7, SYS_kill
 394:	4899                	li	a7,6
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <exec>:
.global exec
exec:
 li a7, SYS_exec
 39c:	489d                	li	a7,7
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <open>:
.global open
open:
 li a7, SYS_open
 3a4:	48bd                	li	a7,15
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ac:	48c5                	li	a7,17
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b4:	48c9                	li	a7,18
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3bc:	48a1                	li	a7,8
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <link>:
.global link
link:
 li a7, SYS_link
 3c4:	48cd                	li	a7,19
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3cc:	48d1                	li	a7,20
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d4:	48a5                	li	a7,9
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3dc:	48a9                	li	a7,10
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e4:	48ad                	li	a7,11
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ec:	48b1                	li	a7,12
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3f4:	48b5                	li	a7,13
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fc:	48b9                	li	a7,14
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 410:	4605                	li	a2,1
 412:	fef40593          	addi	a1,s0,-17
 416:	f6fff0ef          	jal	ra,384 <write>
}
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret

0000000000000422 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 422:	715d                	addi	sp,sp,-80
 424:	e486                	sd	ra,72(sp)
 426:	e0a2                	sd	s0,64(sp)
 428:	fc26                	sd	s1,56(sp)
 42a:	f84a                	sd	s2,48(sp)
 42c:	f44e                	sd	s3,40(sp)
 42e:	0880                	addi	s0,sp,80
 430:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 432:	c299                	beqz	a3,438 <printint+0x16>
 434:	0805c663          	bltz	a1,4c0 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 438:	2581                	sext.w	a1,a1
  neg = 0;
 43a:	4881                	li	a7,0
 43c:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 440:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 442:	2601                	sext.w	a2,a2
 444:	00000517          	auipc	a0,0x0
 448:	57450513          	addi	a0,a0,1396 # 9b8 <digits>
 44c:	883a                	mv	a6,a4
 44e:	2705                	addiw	a4,a4,1
 450:	02c5f7bb          	remuw	a5,a1,a2
 454:	1782                	slli	a5,a5,0x20
 456:	9381                	srli	a5,a5,0x20
 458:	97aa                	add	a5,a5,a0
 45a:	0007c783          	lbu	a5,0(a5)
 45e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 462:	0005879b          	sext.w	a5,a1
 466:	02c5d5bb          	divuw	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fec7f0e3          	bgeu	a5,a2,44c <printint+0x2a>
  if(neg)
 470:	00088b63          	beqz	a7,486 <printint+0x64>
    buf[i++] = '-';
 474:	fd040793          	addi	a5,s0,-48
 478:	973e                	add	a4,a4,a5
 47a:	02d00793          	li	a5,45
 47e:	fef70423          	sb	a5,-24(a4)
 482:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 486:	02e05663          	blez	a4,4b2 <printint+0x90>
 48a:	fb840793          	addi	a5,s0,-72
 48e:	00e78933          	add	s2,a5,a4
 492:	fff78993          	addi	s3,a5,-1
 496:	99ba                	add	s3,s3,a4
 498:	377d                	addiw	a4,a4,-1
 49a:	1702                	slli	a4,a4,0x20
 49c:	9301                	srli	a4,a4,0x20
 49e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a2:	fff94583          	lbu	a1,-1(s2)
 4a6:	8526                	mv	a0,s1
 4a8:	f5dff0ef          	jal	ra,404 <putc>
  while(--i >= 0)
 4ac:	197d                	addi	s2,s2,-1
 4ae:	ff391ae3          	bne	s2,s3,4a2 <printint+0x80>
}
 4b2:	60a6                	ld	ra,72(sp)
 4b4:	6406                	ld	s0,64(sp)
 4b6:	74e2                	ld	s1,56(sp)
 4b8:	7942                	ld	s2,48(sp)
 4ba:	79a2                	ld	s3,40(sp)
 4bc:	6161                	addi	sp,sp,80
 4be:	8082                	ret
    x = -xx;
 4c0:	40b005bb          	negw	a1,a1
    neg = 1;
 4c4:	4885                	li	a7,1
    x = -xx;
 4c6:	bf9d                	j	43c <printint+0x1a>

00000000000004c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c8:	7119                	addi	sp,sp,-128
 4ca:	fc86                	sd	ra,120(sp)
 4cc:	f8a2                	sd	s0,112(sp)
 4ce:	f4a6                	sd	s1,104(sp)
 4d0:	f0ca                	sd	s2,96(sp)
 4d2:	ecce                	sd	s3,88(sp)
 4d4:	e8d2                	sd	s4,80(sp)
 4d6:	e4d6                	sd	s5,72(sp)
 4d8:	e0da                	sd	s6,64(sp)
 4da:	fc5e                	sd	s7,56(sp)
 4dc:	f862                	sd	s8,48(sp)
 4de:	f466                	sd	s9,40(sp)
 4e0:	f06a                	sd	s10,32(sp)
 4e2:	ec6e                	sd	s11,24(sp)
 4e4:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e6:	0005c903          	lbu	s2,0(a1)
 4ea:	24090c63          	beqz	s2,742 <vprintf+0x27a>
 4ee:	8b2a                	mv	s6,a0
 4f0:	8a2e                	mv	s4,a1
 4f2:	8bb2                	mv	s7,a2
  state = 0;
 4f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4f6:	4481                	li	s1,0
 4f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 502:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 506:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 50a:	00000c97          	auipc	s9,0x0
 50e:	4aec8c93          	addi	s9,s9,1198 # 9b8 <digits>
 512:	a005                	j	532 <vprintf+0x6a>
        putc(fd, c0);
 514:	85ca                	mv	a1,s2
 516:	855a                	mv	a0,s6
 518:	eedff0ef          	jal	ra,404 <putc>
 51c:	a019                	j	522 <vprintf+0x5a>
    } else if(state == '%'){
 51e:	03598263          	beq	s3,s5,542 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 522:	2485                	addiw	s1,s1,1
 524:	8726                	mv	a4,s1
 526:	009a07b3          	add	a5,s4,s1
 52a:	0007c903          	lbu	s2,0(a5)
 52e:	20090a63          	beqz	s2,742 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 532:	0009079b          	sext.w	a5,s2
    if(state == 0){
 536:	fe0994e3          	bnez	s3,51e <vprintf+0x56>
      if(c0 == '%'){
 53a:	fd579de3          	bne	a5,s5,514 <vprintf+0x4c>
        state = '%';
 53e:	89be                	mv	s3,a5
 540:	b7cd                	j	522 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 542:	c3c1                	beqz	a5,5c2 <vprintf+0xfa>
 544:	00ea06b3          	add	a3,s4,a4
 548:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	c681                	beqz	a3,556 <vprintf+0x8e>
 550:	9752                	add	a4,a4,s4
 552:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 556:	03878e63          	beq	a5,s8,592 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 55a:	05a78863          	beq	a5,s10,5aa <vprintf+0xe2>
      } else if(c0 == 'u'){
 55e:	0db78b63          	beq	a5,s11,634 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 562:	07800713          	li	a4,120
 566:	10e78d63          	beq	a5,a4,680 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 56a:	07000713          	li	a4,112
 56e:	14e78263          	beq	a5,a4,6b2 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 572:	06300713          	li	a4,99
 576:	16e78f63          	beq	a5,a4,6f4 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 57a:	07300713          	li	a4,115
 57e:	18e78563          	beq	a5,a4,708 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 582:	05579063          	bne	a5,s5,5c2 <vprintf+0xfa>
        putc(fd, '%');
 586:	85d6                	mv	a1,s5
 588:	855a                	mv	a0,s6
 58a:	e7bff0ef          	jal	ra,404 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 58e:	4981                	li	s3,0
 590:	bf49                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e83ff0ef          	jal	ra,422 <printint>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bfad                	j	522 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	03868663          	beq	a3,s8,5d6 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ae:	05a68163          	beq	a3,s10,5f0 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 5b2:	09b68d63          	beq	a3,s11,64c <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b6:	03a68f63          	beq	a3,s10,5f4 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 5ba:	07800793          	li	a5,120
 5be:	0cf68d63          	beq	a3,a5,698 <vprintf+0x1d0>
        putc(fd, '%');
 5c2:	85d6                	mv	a1,s5
 5c4:	855a                	mv	a0,s6
 5c6:	e3fff0ef          	jal	ra,404 <putc>
        putc(fd, c0);
 5ca:	85ca                	mv	a1,s2
 5cc:	855a                	mv	a0,s6
 5ce:	e37ff0ef          	jal	ra,404 <putc>
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b7b9                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e3fff0ef          	jal	ra,422 <printint>
        i += 1;
 5e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 1;
 5ee:	bf15                	j	522 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f0:	03860563          	beq	a2,s8,61a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f4:	07b60963          	beq	a2,s11,666 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5f8:	07800793          	li	a5,120
 5fc:	fcf613e3          	bne	a2,a5,5c2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 600:	008b8913          	addi	s2,s7,8
 604:	4681                	li	a3,0
 606:	4641                	li	a2,16
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e15ff0ef          	jal	ra,422 <printint>
        i += 2;
 612:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
        i += 2;
 618:	b729                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000bb583          	ld	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	dfbff0ef          	jal	ra,422 <printint>
        i += 2;
 62c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
        i += 2;
 632:	bdc5                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000be583          	lwu	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	de1ff0ef          	jal	ra,422 <printint>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bde1                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	008b8913          	addi	s2,s7,8
 650:	4681                	li	a3,0
 652:	4629                	li	a2,10
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	dc9ff0ef          	jal	ra,422 <printint>
        i += 1;
 65e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 1;
 664:	bd7d                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	008b8913          	addi	s2,s7,8
 66a:	4681                	li	a3,0
 66c:	4629                	li	a2,10
 66e:	000bb583          	ld	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	dafff0ef          	jal	ra,422 <printint>
        i += 2;
 678:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
        i += 2;
 67e:	b555                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 680:	008b8913          	addi	s2,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000be583          	lwu	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d95ff0ef          	jal	ra,422 <printint>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	b571                	j	522 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4641                	li	a2,16
 6a0:	000bb583          	ld	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	d7dff0ef          	jal	ra,422 <printint>
        i += 1;
 6aa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
        i += 1;
 6b0:	bd8d                	j	522 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6b2:	008b8793          	addi	a5,s7,8
 6b6:	f8f43423          	sd	a5,-120(s0)
 6ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6be:	03000593          	li	a1,48
 6c2:	855a                	mv	a0,s6
 6c4:	d41ff0ef          	jal	ra,404 <putc>
  putc(fd, 'x');
 6c8:	07800593          	li	a1,120
 6cc:	855a                	mv	a0,s6
 6ce:	d37ff0ef          	jal	ra,404 <putc>
 6d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d4:	03c9d793          	srli	a5,s3,0x3c
 6d8:	97e6                	add	a5,a5,s9
 6da:	0007c583          	lbu	a1,0(a5)
 6de:	855a                	mv	a0,s6
 6e0:	d25ff0ef          	jal	ra,404 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e4:	0992                	slli	s3,s3,0x4
 6e6:	397d                	addiw	s2,s2,-1
 6e8:	fe0916e3          	bnez	s2,6d4 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 6ec:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bd05                	j	522 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	000bc583          	lbu	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	d07ff0ef          	jal	ra,404 <putc>
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
 706:	bd31                	j	522 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 708:	008b8993          	addi	s3,s7,8
 70c:	000bb903          	ld	s2,0(s7)
 710:	00090f63          	beqz	s2,72e <vprintf+0x266>
        for(; *s; s++)
 714:	00094583          	lbu	a1,0(s2)
 718:	c195                	beqz	a1,73c <vprintf+0x274>
          putc(fd, *s);
 71a:	855a                	mv	a0,s6
 71c:	ce9ff0ef          	jal	ra,404 <putc>
        for(; *s; s++)
 720:	0905                	addi	s2,s2,1
 722:	00094583          	lbu	a1,0(s2)
 726:	f9f5                	bnez	a1,71a <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bbdd                	j	522 <vprintf+0x5a>
          s = "(null)";
 72e:	00000917          	auipc	s2,0x0
 732:	28290913          	addi	s2,s2,642 # 9b0 <malloc+0x16c>
        for(; *s; s++)
 736:	02800593          	li	a1,40
 73a:	b7c5                	j	71a <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b3cd                	j	522 <vprintf+0x5a>
    }
  }
}
 742:	70e6                	ld	ra,120(sp)
 744:	7446                	ld	s0,112(sp)
 746:	74a6                	ld	s1,104(sp)
 748:	7906                	ld	s2,96(sp)
 74a:	69e6                	ld	s3,88(sp)
 74c:	6a46                	ld	s4,80(sp)
 74e:	6aa6                	ld	s5,72(sp)
 750:	6b06                	ld	s6,64(sp)
 752:	7be2                	ld	s7,56(sp)
 754:	7c42                	ld	s8,48(sp)
 756:	7ca2                	ld	s9,40(sp)
 758:	7d02                	ld	s10,32(sp)
 75a:	6de2                	ld	s11,24(sp)
 75c:	6109                	addi	sp,sp,128
 75e:	8082                	ret

0000000000000760 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 760:	715d                	addi	sp,sp,-80
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	addi	s0,sp,32
 768:	e010                	sd	a2,0(s0)
 76a:	e414                	sd	a3,8(s0)
 76c:	e818                	sd	a4,16(s0)
 76e:	ec1c                	sd	a5,24(s0)
 770:	03043023          	sd	a6,32(s0)
 774:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77c:	8622                	mv	a2,s0
 77e:	d4bff0ef          	jal	ra,4c8 <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6161                	addi	sp,sp,80
 788:	8082                	ret

000000000000078a <printf>:

void
printf(const char *fmt, ...)
{
 78a:	711d                	addi	sp,sp,-96
 78c:	ec06                	sd	ra,24(sp)
 78e:	e822                	sd	s0,16(sp)
 790:	1000                	addi	s0,sp,32
 792:	e40c                	sd	a1,8(s0)
 794:	e810                	sd	a2,16(s0)
 796:	ec14                	sd	a3,24(s0)
 798:	f018                	sd	a4,32(s0)
 79a:	f41c                	sd	a5,40(s0)
 79c:	03043823          	sd	a6,48(s0)
 7a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	00840613          	addi	a2,s0,8
 7a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ac:	85aa                	mv	a1,a0
 7ae:	4505                	li	a0,1
 7b0:	d19ff0ef          	jal	ra,4c8 <vprintf>
}
 7b4:	60e2                	ld	ra,24(sp)
 7b6:	6442                	ld	s0,16(sp)
 7b8:	6125                	addi	sp,sp,96
 7ba:	8082                	ret

00000000000007bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bc:	1141                	addi	sp,sp,-16
 7be:	e422                	sd	s0,8(sp)
 7c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	00001797          	auipc	a5,0x1
 7ca:	83a7b783          	ld	a5,-1990(a5) # 1000 <freep>
 7ce:	a805                	j	7fe <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d0:	4618                	lw	a4,8(a2)
 7d2:	9db9                	addw	a1,a1,a4
 7d4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d8:	6398                	ld	a4,0(a5)
 7da:	6318                	ld	a4,0(a4)
 7dc:	fee53823          	sd	a4,-16(a0)
 7e0:	a091                	j	824 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e2:	ff852703          	lw	a4,-8(a0)
 7e6:	9e39                	addw	a2,a2,a4
 7e8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7ea:	ff053703          	ld	a4,-16(a0)
 7ee:	e398                	sd	a4,0(a5)
 7f0:	a099                	j	836 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e7e463          	bltu	a5,a4,7fc <free+0x40>
 7f8:	00e6ea63          	bltu	a3,a4,80c <free+0x50>
{
 7fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	fed7fae3          	bgeu	a5,a3,7f2 <free+0x36>
 802:	6398                	ld	a4,0(a5)
 804:	00e6e463          	bltu	a3,a4,80c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	fee7eae3          	bltu	a5,a4,7fc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 80c:	ff852583          	lw	a1,-8(a0)
 810:	6390                	ld	a2,0(a5)
 812:	02059713          	slli	a4,a1,0x20
 816:	9301                	srli	a4,a4,0x20
 818:	0712                	slli	a4,a4,0x4
 81a:	9736                	add	a4,a4,a3
 81c:	fae60ae3          	beq	a2,a4,7d0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 820:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 824:	4790                	lw	a2,8(a5)
 826:	02061713          	slli	a4,a2,0x20
 82a:	9301                	srli	a4,a4,0x20
 82c:	0712                	slli	a4,a4,0x4
 82e:	973e                	add	a4,a4,a5
 830:	fae689e3          	beq	a3,a4,7e2 <free+0x26>
  } else
    p->s.ptr = bp;
 834:	e394                	sd	a3,0(a5)
  freep = p;
 836:	00000717          	auipc	a4,0x0
 83a:	7cf73523          	sd	a5,1994(a4) # 1000 <freep>
}
 83e:	6422                	ld	s0,8(sp)
 840:	0141                	addi	sp,sp,16
 842:	8082                	ret

0000000000000844 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f426                	sd	s1,40(sp)
 84c:	f04a                	sd	s2,32(sp)
 84e:	ec4e                	sd	s3,24(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
 856:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 858:	02051493          	slli	s1,a0,0x20
 85c:	9081                	srli	s1,s1,0x20
 85e:	04bd                	addi	s1,s1,15
 860:	8091                	srli	s1,s1,0x4
 862:	0014899b          	addiw	s3,s1,1
 866:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 868:	00000517          	auipc	a0,0x0
 86c:	79853503          	ld	a0,1944(a0) # 1000 <freep>
 870:	c515                	beqz	a0,89c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	02977f63          	bgeu	a4,s1,8b4 <malloc+0x70>
 87a:	8a4e                	mv	s4,s3
 87c:	0009871b          	sext.w	a4,s3
 880:	6685                	lui	a3,0x1
 882:	00d77363          	bgeu	a4,a3,888 <malloc+0x44>
 886:	6a05                	lui	s4,0x1
 888:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 890:	00000917          	auipc	s2,0x0
 894:	77090913          	addi	s2,s2,1904 # 1000 <freep>
  if(p == SBRK_ERROR)
 898:	5afd                	li	s5,-1
 89a:	a0bd                	j	908 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 89c:	00001797          	auipc	a5,0x1
 8a0:	96c78793          	addi	a5,a5,-1684 # 1208 <base>
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
 8ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b2:	b7e1                	j	87a <malloc+0x36>
      if(p->s.size == nunits)
 8b4:	02e48b63          	beq	s1,a4,8ea <malloc+0xa6>
        p->s.size -= nunits;
 8b8:	4137073b          	subw	a4,a4,s3
 8bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8be:	1702                	slli	a4,a4,0x20
 8c0:	9301                	srli	a4,a4,0x20
 8c2:	0712                	slli	a4,a4,0x4
 8c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72a73b23          	sd	a0,1846(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8d6:	70e2                	ld	ra,56(sp)
 8d8:	7442                	ld	s0,48(sp)
 8da:	74a2                	ld	s1,40(sp)
 8dc:	7902                	ld	s2,32(sp)
 8de:	69e2                	ld	s3,24(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	6121                	addi	sp,sp,64
 8e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	e118                	sd	a4,0(a0)
 8ee:	bff1                	j	8ca <malloc+0x86>
  hp->s.size = nu;
 8f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f4:	0541                	addi	a0,a0,16
 8f6:	ec7ff0ef          	jal	ra,7bc <free>
  return freep;
 8fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8fe:	dd61                	beqz	a0,8d6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 902:	4798                	lw	a4,8(a5)
 904:	fa9778e3          	bgeu	a4,s1,8b4 <malloc+0x70>
    if(p == freep)
 908:	00093703          	ld	a4,0(s2)
 90c:	853e                	mv	a0,a5
 90e:	fef719e3          	bne	a4,a5,900 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 912:	8552                	mv	a0,s4
 914:	a1dff0ef          	jal	ra,330 <sbrk>
  if(p == SBRK_ERROR)
 918:	fd551ce3          	bne	a0,s5,8f0 <malloc+0xac>
        return 0;
 91c:	4501                	li	a0,0
 91e:	bf65                	j	8d6 <malloc+0x92>
