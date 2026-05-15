
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	998a0a13          	addi	s4,s4,-1640 # 9d0 <malloc+0xe6>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1c6000ef          	jal	ra,20c <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01248d63          	beq	s1,s2,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2b85                	addiw	s7,s7,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0997e3          	bnez	s3,4e <wc+0x4e>
        w++;
  64:	2c05                	addiw	s8,s8,1
        inword = 1;
  66:	4985                	li	s3,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	00001597          	auipc	a1,0x1
  76:	f9e58593          	addi	a1,a1,-98 # 1010 <buf>
  7a:	f8843503          	ld	a0,-120(s0)
  7e:	39c000ef          	jal	ra,41a <read>
  82:	00a05f63          	blez	a0,a0 <wc+0xa0>
    for(i=0; i<n; i++){
  86:	00001497          	auipc	s1,0x1
  8a:	f8a48493          	addi	s1,s1,-118 # 1010 <buf>
  8e:	00050d1b          	sext.w	s10,a0
  92:	fff5091b          	addiw	s2,a0,-1
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	996e                	add	s2,s2,s11
  9e:	bf5d                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  a0:	02054c63          	bltz	a0,d8 <wc+0xd8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  a4:	f8043703          	ld	a4,-128(s0)
  a8:	86e6                	mv	a3,s9
  aa:	8662                	mv	a2,s8
  ac:	85de                	mv	a1,s7
  ae:	00001517          	auipc	a0,0x1
  b2:	93a50513          	addi	a0,a0,-1734 # 9e8 <malloc+0xfe>
  b6:	77a000ef          	jal	ra,830 <printf>
}
  ba:	70e6                	ld	ra,120(sp)
  bc:	7446                	ld	s0,112(sp)
  be:	74a6                	ld	s1,104(sp)
  c0:	7906                	ld	s2,96(sp)
  c2:	69e6                	ld	s3,88(sp)
  c4:	6a46                	ld	s4,80(sp)
  c6:	6aa6                	ld	s5,72(sp)
  c8:	6b06                	ld	s6,64(sp)
  ca:	7be2                	ld	s7,56(sp)
  cc:	7c42                	ld	s8,48(sp)
  ce:	7ca2                	ld	s9,40(sp)
  d0:	7d02                	ld	s10,32(sp)
  d2:	6de2                	ld	s11,24(sp)
  d4:	6109                	addi	sp,sp,128
  d6:	8082                	ret
    printf("wc: read error\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	90050513          	addi	a0,a0,-1792 # 9d8 <malloc+0xee>
  e0:	750000ef          	jal	ra,830 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	31c000ef          	jal	ra,402 <exit>

00000000000000ea <main>:

int
main(int argc, char *argv[])
{
  ea:	7179                	addi	sp,sp,-48
  ec:	f406                	sd	ra,40(sp)
  ee:	f022                	sd	s0,32(sp)
  f0:	ec26                	sd	s1,24(sp)
  f2:	e84a                	sd	s2,16(sp)
  f4:	e44e                	sd	s3,8(sp)
  f6:	e052                	sd	s4,0(sp)
  f8:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fa:	4785                	li	a5,1
  fc:	02a7df63          	bge	a5,a0,13a <main+0x50>
 100:	00858493          	addi	s1,a1,8
 104:	ffe5099b          	addiw	s3,a0,-2
 108:	1982                	slli	s3,s3,0x20
 10a:	0209d993          	srli	s3,s3,0x20
 10e:	098e                	slli	s3,s3,0x3
 110:	05c1                	addi	a1,a1,16
 112:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 114:	4581                	li	a1,0
 116:	6088                	ld	a0,0(s1)
 118:	32a000ef          	jal	ra,442 <open>
 11c:	892a                	mv	s2,a0
 11e:	02054863          	bltz	a0,14e <main+0x64>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 122:	608c                	ld	a1,0(s1)
 124:	eddff0ef          	jal	ra,0 <wc>
    close(fd);
 128:	854a                	mv	a0,s2
 12a:	300000ef          	jal	ra,42a <close>
  for(i = 1; i < argc; i++){
 12e:	04a1                	addi	s1,s1,8
 130:	ff3492e3          	bne	s1,s3,114 <main+0x2a>
  }
  exit(0);
 134:	4501                	li	a0,0
 136:	2cc000ef          	jal	ra,402 <exit>
    wc(0, "");
 13a:	00001597          	auipc	a1,0x1
 13e:	8be58593          	addi	a1,a1,-1858 # 9f8 <malloc+0x10e>
 142:	4501                	li	a0,0
 144:	ebdff0ef          	jal	ra,0 <wc>
    exit(0);
 148:	4501                	li	a0,0
 14a:	2b8000ef          	jal	ra,402 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 14e:	608c                	ld	a1,0(s1)
 150:	00001517          	auipc	a0,0x1
 154:	8b050513          	addi	a0,a0,-1872 # a00 <malloc+0x116>
 158:	6d8000ef          	jal	ra,830 <printf>
      exit(1);
 15c:	4505                	li	a0,1
 15e:	2a4000ef          	jal	ra,402 <exit>

0000000000000162 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  extern int main();
  main();
 16a:	f81ff0ef          	jal	ra,ea <main>
  exit(0);
 16e:	4501                	li	a0,0
 170:	292000ef          	jal	ra,402 <exit>

0000000000000174 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17a:	87aa                	mv	a5,a0
 17c:	0585                	addi	a1,a1,1
 17e:	0785                	addi	a5,a5,1
 180:	fff5c703          	lbu	a4,-1(a1)
 184:	fee78fa3          	sb	a4,-1(a5)
 188:	fb75                	bnez	a4,17c <strcpy+0x8>
    ;
  return os;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x1e>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x1e>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cf91                	beqz	a5,1e2 <strlen+0x26>
 1c8:	0505                	addi	a0,a0,1
 1ca:	87aa                	mv	a5,a0
 1cc:	4685                	li	a3,1
 1ce:	9e89                	subw	a3,a3,a0
 1d0:	00f6853b          	addw	a0,a3,a5
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff7c703          	lbu	a4,-1(a5)
 1da:	fb7d                	bnez	a4,1d0 <strlen+0x14>
    ;
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  for(n = 0; s[n]; n++)
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <strlen+0x20>

00000000000001e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ec:	ce09                	beqz	a2,206 <memset+0x20>
 1ee:	87aa                	mv	a5,a0
 1f0:	fff6071b          	addiw	a4,a2,-1
 1f4:	1702                	slli	a4,a4,0x20
 1f6:	9301                	srli	a4,a4,0x20
 1f8:	0705                	addi	a4,a4,1
 1fa:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 200:	0785                	addi	a5,a5,1
 202:	fee79de3          	bne	a5,a4,1fc <memset+0x16>
  }
  return dst;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strchr>:

char*
strchr(const char *s, char c)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  for(; *s; s++)
 212:	00054783          	lbu	a5,0(a0)
 216:	cb99                	beqz	a5,22c <strchr+0x20>
    if(*s == c)
 218:	00f58763          	beq	a1,a5,226 <strchr+0x1a>
  for(; *s; s++)
 21c:	0505                	addi	a0,a0,1
 21e:	00054783          	lbu	a5,0(a0)
 222:	fbfd                	bnez	a5,218 <strchr+0xc>
      return (char*)s;
  return 0;
 224:	4501                	li	a0,0
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  return 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <strchr+0x1a>

0000000000000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	711d                	addi	sp,sp,-96
 232:	ec86                	sd	ra,88(sp)
 234:	e8a2                	sd	s0,80(sp)
 236:	e4a6                	sd	s1,72(sp)
 238:	e0ca                	sd	s2,64(sp)
 23a:	fc4e                	sd	s3,56(sp)
 23c:	f852                	sd	s4,48(sp)
 23e:	f456                	sd	s5,40(sp)
 240:	f05a                	sd	s6,32(sp)
 242:	ec5e                	sd	s7,24(sp)
 244:	1080                	addi	s0,sp,96
 246:	8baa                	mv	s7,a0
 248:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	892a                	mv	s2,a0
 24c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24e:	4aa9                	li	s5,10
 250:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 252:	89a6                	mv	s3,s1
 254:	2485                	addiw	s1,s1,1
 256:	0344d663          	bge	s1,s4,282 <gets+0x52>
    cc = read(0, &c, 1);
 25a:	4605                	li	a2,1
 25c:	faf40593          	addi	a1,s0,-81
 260:	4501                	li	a0,0
 262:	1b8000ef          	jal	ra,41a <read>
    if(cc < 1)
 266:	00a05e63          	blez	a0,282 <gets+0x52>
    buf[i++] = c;
 26a:	faf44783          	lbu	a5,-81(s0)
 26e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 272:	01578763          	beq	a5,s5,280 <gets+0x50>
 276:	0905                	addi	s2,s2,1
 278:	fd679de3          	bne	a5,s6,252 <gets+0x22>
  for(i=0; i+1 < max; ){
 27c:	89a6                	mv	s3,s1
 27e:	a011                	j	282 <gets+0x52>
 280:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 282:	99de                	add	s3,s3,s7
 284:	00098023          	sb	zero,0(s3)
  return buf;
}
 288:	855e                	mv	a0,s7
 28a:	60e6                	ld	ra,88(sp)
 28c:	6446                	ld	s0,80(sp)
 28e:	64a6                	ld	s1,72(sp)
 290:	6906                	ld	s2,64(sp)
 292:	79e2                	ld	s3,56(sp)
 294:	7a42                	ld	s4,48(sp)
 296:	7aa2                	ld	s5,40(sp)
 298:	7b02                	ld	s6,32(sp)
 29a:	6be2                	ld	s7,24(sp)
 29c:	6125                	addi	sp,sp,96
 29e:	8082                	ret

00000000000002a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a0:	1101                	addi	sp,sp,-32
 2a2:	ec06                	sd	ra,24(sp)
 2a4:	e822                	sd	s0,16(sp)
 2a6:	e426                	sd	s1,8(sp)
 2a8:	e04a                	sd	s2,0(sp)
 2aa:	1000                	addi	s0,sp,32
 2ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	4581                	li	a1,0
 2b0:	192000ef          	jal	ra,442 <open>
  if(fd < 0)
 2b4:	02054163          	bltz	a0,2d6 <stat+0x36>
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	19e000ef          	jal	ra,45a <fstat>
 2c0:	892a                	mv	s2,a0
  close(fd);
 2c2:	8526                	mv	a0,s1
 2c4:	166000ef          	jal	ra,42a <close>
  return r;
}
 2c8:	854a                	mv	a0,s2
 2ca:	60e2                	ld	ra,24(sp)
 2cc:	6442                	ld	s0,16(sp)
 2ce:	64a2                	ld	s1,8(sp)
 2d0:	6902                	ld	s2,0(sp)
 2d2:	6105                	addi	sp,sp,32
 2d4:	8082                	ret
    return -1;
 2d6:	597d                	li	s2,-1
 2d8:	bfc5                	j	2c8 <stat+0x28>

00000000000002da <atoi>:

int
atoi(const char *s)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e0:	00054603          	lbu	a2,0(a0)
 2e4:	fd06079b          	addiw	a5,a2,-48
 2e8:	0ff7f793          	andi	a5,a5,255
 2ec:	4725                	li	a4,9
 2ee:	02f76963          	bltu	a4,a5,320 <atoi+0x46>
 2f2:	86aa                	mv	a3,a0
  n = 0;
 2f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f8:	0685                	addi	a3,a3,1
 2fa:	0025179b          	slliw	a5,a0,0x2
 2fe:	9fa9                	addw	a5,a5,a0
 300:	0017979b          	slliw	a5,a5,0x1
 304:	9fb1                	addw	a5,a5,a2
 306:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30a:	0006c603          	lbu	a2,0(a3)
 30e:	fd06071b          	addiw	a4,a2,-48
 312:	0ff77713          	andi	a4,a4,255
 316:	fee5f1e3          	bgeu	a1,a4,2f8 <atoi+0x1e>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  n = 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <atoi+0x40>

0000000000000324 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57663          	bgeu	a0,a1,356 <memmove+0x32>
    while(n-- > 0)
 32e:	02c05163          	blez	a2,350 <memmove+0x2c>
 332:	fff6079b          	addiw	a5,a2,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	0785                	addi	a5,a5,1
 33c:	97aa                	add	a5,a5,a0
  dst = vdst;
 33e:	872a                	mv	a4,a0
      *dst++ = *src++;
 340:	0585                	addi	a1,a1,1
 342:	0705                	addi	a4,a4,1
 344:	fff5c683          	lbu	a3,-1(a1)
 348:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34c:	fee79ae3          	bne	a5,a4,340 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35c:	fec05ae3          	blez	a2,350 <memmove+0x2c>
 360:	fff6079b          	addiw	a5,a2,-1
 364:	1782                	slli	a5,a5,0x20
 366:	9381                	srli	a5,a5,0x20
 368:	fff7c793          	not	a5,a5
 36c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36e:	15fd                	addi	a1,a1,-1
 370:	177d                	addi	a4,a4,-1
 372:	0005c683          	lbu	a3,0(a1)
 376:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37a:	fee79ae3          	bne	a5,a4,36e <memmove+0x4a>
 37e:	bfc9                	j	350 <memmove+0x2c>

0000000000000380 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 386:	ca05                	beqz	a2,3b6 <memcmp+0x36>
 388:	fff6069b          	addiw	a3,a2,-1
 38c:	1682                	slli	a3,a3,0x20
 38e:	9281                	srli	a3,a3,0x20
 390:	0685                	addi	a3,a3,1
 392:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 394:	00054783          	lbu	a5,0(a0)
 398:	0005c703          	lbu	a4,0(a1)
 39c:	00e79863          	bne	a5,a4,3ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a0:	0505                	addi	a0,a0,1
    p2++;
 3a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a4:	fed518e3          	bne	a0,a3,394 <memcmp+0x14>
  }
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	a019                	j	3b0 <memcmp+0x30>
      return *p1 - *p2;
 3ac:	40e7853b          	subw	a0,a5,a4
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <memcmp+0x30>

00000000000003ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c2:	f63ff0ef          	jal	ra,324 <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <sbrk>:

char *
sbrk(int n) {
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e406                	sd	ra,8(sp)
 3d2:	e022                	sd	s0,0(sp)
 3d4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3d6:	4585                	li	a1,1
 3d8:	0b2000ef          	jal	ra,48a <sys_sbrk>
}
 3dc:	60a2                	ld	ra,8(sp)
 3de:	6402                	ld	s0,0(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret

00000000000003e4 <sbrklazy>:

char *
sbrklazy(int n) {
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3ec:	4589                	li	a1,2
 3ee:	09c000ef          	jal	ra,48a <sys_sbrk>
}
 3f2:	60a2                	ld	ra,8(sp)
 3f4:	6402                	ld	s0,0(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret

00000000000003fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3fa:	4885                	li	a7,1
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exit>:
.global exit
exit:
 li a7, SYS_exit
 402:	4889                	li	a7,2
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <wait>:
.global wait
wait:
 li a7, SYS_wait
 40a:	488d                	li	a7,3
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 412:	4891                	li	a7,4
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <read>:
.global read
read:
 li a7, SYS_read
 41a:	4895                	li	a7,5
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <write>:
.global write
write:
 li a7, SYS_write
 422:	48c1                	li	a7,16
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <close>:
.global close
close:
 li a7, SYS_close
 42a:	48d5                	li	a7,21
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <kill>:
.global kill
kill:
 li a7, SYS_kill
 432:	4899                	li	a7,6
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <exec>:
.global exec
exec:
 li a7, SYS_exec
 43a:	489d                	li	a7,7
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <open>:
.global open
open:
 li a7, SYS_open
 442:	48bd                	li	a7,15
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 44a:	48c5                	li	a7,17
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 452:	48c9                	li	a7,18
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 45a:	48a1                	li	a7,8
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <link>:
.global link
link:
 li a7, SYS_link
 462:	48cd                	li	a7,19
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 46a:	48d1                	li	a7,20
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 472:	48a5                	li	a7,9
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <dup>:
.global dup
dup:
 li a7, SYS_dup
 47a:	48a9                	li	a7,10
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 482:	48ad                	li	a7,11
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 48a:	48b1                	li	a7,12
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <pause>:
.global pause
pause:
 li a7, SYS_pause
 492:	48b5                	li	a7,13
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 49a:	48b9                	li	a7,14
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getproctree>:
.global getproctree
getproctree:
 li a7, SYS_getproctree
 4a2:	48d9                	li	a7,22
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4aa:	1101                	addi	sp,sp,-32
 4ac:	ec06                	sd	ra,24(sp)
 4ae:	e822                	sd	s0,16(sp)
 4b0:	1000                	addi	s0,sp,32
 4b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b6:	4605                	li	a2,1
 4b8:	fef40593          	addi	a1,s0,-17
 4bc:	f67ff0ef          	jal	ra,422 <write>
}
 4c0:	60e2                	ld	ra,24(sp)
 4c2:	6442                	ld	s0,16(sp)
 4c4:	6105                	addi	sp,sp,32
 4c6:	8082                	ret

00000000000004c8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4c8:	715d                	addi	sp,sp,-80
 4ca:	e486                	sd	ra,72(sp)
 4cc:	e0a2                	sd	s0,64(sp)
 4ce:	fc26                	sd	s1,56(sp)
 4d0:	f84a                	sd	s2,48(sp)
 4d2:	f44e                	sd	s3,40(sp)
 4d4:	0880                	addi	s0,sp,80
 4d6:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d8:	c299                	beqz	a3,4de <printint+0x16>
 4da:	0805c663          	bltz	a1,566 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4de:	2581                	sext.w	a1,a1
  neg = 0;
 4e0:	4881                	li	a7,0
 4e2:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 4e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e8:	2601                	sext.w	a2,a2
 4ea:	00000517          	auipc	a0,0x0
 4ee:	53650513          	addi	a0,a0,1334 # a20 <digits>
 4f2:	883a                	mv	a6,a4
 4f4:	2705                	addiw	a4,a4,1
 4f6:	02c5f7bb          	remuw	a5,a1,a2
 4fa:	1782                	slli	a5,a5,0x20
 4fc:	9381                	srli	a5,a5,0x20
 4fe:	97aa                	add	a5,a5,a0
 500:	0007c783          	lbu	a5,0(a5)
 504:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 508:	0005879b          	sext.w	a5,a1
 50c:	02c5d5bb          	divuw	a1,a1,a2
 510:	0685                	addi	a3,a3,1
 512:	fec7f0e3          	bgeu	a5,a2,4f2 <printint+0x2a>
  if(neg)
 516:	00088b63          	beqz	a7,52c <printint+0x64>
    buf[i++] = '-';
 51a:	fd040793          	addi	a5,s0,-48
 51e:	973e                	add	a4,a4,a5
 520:	02d00793          	li	a5,45
 524:	fef70423          	sb	a5,-24(a4)
 528:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52c:	02e05663          	blez	a4,558 <printint+0x90>
 530:	fb840793          	addi	a5,s0,-72
 534:	00e78933          	add	s2,a5,a4
 538:	fff78993          	addi	s3,a5,-1
 53c:	99ba                	add	s3,s3,a4
 53e:	377d                	addiw	a4,a4,-1
 540:	1702                	slli	a4,a4,0x20
 542:	9301                	srli	a4,a4,0x20
 544:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 548:	fff94583          	lbu	a1,-1(s2)
 54c:	8526                	mv	a0,s1
 54e:	f5dff0ef          	jal	ra,4aa <putc>
  while(--i >= 0)
 552:	197d                	addi	s2,s2,-1
 554:	ff391ae3          	bne	s2,s3,548 <printint+0x80>
}
 558:	60a6                	ld	ra,72(sp)
 55a:	6406                	ld	s0,64(sp)
 55c:	74e2                	ld	s1,56(sp)
 55e:	7942                	ld	s2,48(sp)
 560:	79a2                	ld	s3,40(sp)
 562:	6161                	addi	sp,sp,80
 564:	8082                	ret
    x = -xx;
 566:	40b005bb          	negw	a1,a1
    neg = 1;
 56a:	4885                	li	a7,1
    x = -xx;
 56c:	bf9d                	j	4e2 <printint+0x1a>

000000000000056e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 56e:	7119                	addi	sp,sp,-128
 570:	fc86                	sd	ra,120(sp)
 572:	f8a2                	sd	s0,112(sp)
 574:	f4a6                	sd	s1,104(sp)
 576:	f0ca                	sd	s2,96(sp)
 578:	ecce                	sd	s3,88(sp)
 57a:	e8d2                	sd	s4,80(sp)
 57c:	e4d6                	sd	s5,72(sp)
 57e:	e0da                	sd	s6,64(sp)
 580:	fc5e                	sd	s7,56(sp)
 582:	f862                	sd	s8,48(sp)
 584:	f466                	sd	s9,40(sp)
 586:	f06a                	sd	s10,32(sp)
 588:	ec6e                	sd	s11,24(sp)
 58a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58c:	0005c903          	lbu	s2,0(a1)
 590:	24090c63          	beqz	s2,7e8 <vprintf+0x27a>
 594:	8b2a                	mv	s6,a0
 596:	8a2e                	mv	s4,a1
 598:	8bb2                	mv	s7,a2
  state = 0;
 59a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 59c:	4481                	li	s1,0
 59e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a8:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ac:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b0:	00000c97          	auipc	s9,0x0
 5b4:	470c8c93          	addi	s9,s9,1136 # a20 <digits>
 5b8:	a005                	j	5d8 <vprintf+0x6a>
        putc(fd, c0);
 5ba:	85ca                	mv	a1,s2
 5bc:	855a                	mv	a0,s6
 5be:	eedff0ef          	jal	ra,4aa <putc>
 5c2:	a019                	j	5c8 <vprintf+0x5a>
    } else if(state == '%'){
 5c4:	03598263          	beq	s3,s5,5e8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c8:	2485                	addiw	s1,s1,1
 5ca:	8726                	mv	a4,s1
 5cc:	009a07b3          	add	a5,s4,s1
 5d0:	0007c903          	lbu	s2,0(a5)
 5d4:	20090a63          	beqz	s2,7e8 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 5d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5dc:	fe0994e3          	bnez	s3,5c4 <vprintf+0x56>
      if(c0 == '%'){
 5e0:	fd579de3          	bne	a5,s5,5ba <vprintf+0x4c>
        state = '%';
 5e4:	89be                	mv	s3,a5
 5e6:	b7cd                	j	5c8 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e8:	c3c1                	beqz	a5,668 <vprintf+0xfa>
 5ea:	00ea06b3          	add	a3,s4,a4
 5ee:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5f2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5f4:	c681                	beqz	a3,5fc <vprintf+0x8e>
 5f6:	9752                	add	a4,a4,s4
 5f8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5fc:	03878e63          	beq	a5,s8,638 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 600:	05a78863          	beq	a5,s10,650 <vprintf+0xe2>
      } else if(c0 == 'u'){
 604:	0db78b63          	beq	a5,s11,6da <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 608:	07800713          	li	a4,120
 60c:	10e78d63          	beq	a5,a4,726 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 610:	07000713          	li	a4,112
 614:	14e78263          	beq	a5,a4,758 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 618:	06300713          	li	a4,99
 61c:	16e78f63          	beq	a5,a4,79a <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 620:	07300713          	li	a4,115
 624:	18e78563          	beq	a5,a4,7ae <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 628:	05579063          	bne	a5,s5,668 <vprintf+0xfa>
        putc(fd, '%');
 62c:	85d6                	mv	a1,s5
 62e:	855a                	mv	a0,s6
 630:	e7bff0ef          	jal	ra,4aa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 634:	4981                	li	s3,0
 636:	bf49                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 638:	008b8913          	addi	s2,s7,8
 63c:	4685                	li	a3,1
 63e:	4629                	li	a2,10
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e83ff0ef          	jal	ra,4c8 <printint>
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bfad                	j	5c8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 650:	03868663          	beq	a3,s8,67c <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 654:	05a68163          	beq	a3,s10,696 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 658:	09b68d63          	beq	a3,s11,6f2 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65c:	03a68f63          	beq	a3,s10,69a <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 660:	07800793          	li	a5,120
 664:	0cf68d63          	beq	a3,a5,73e <vprintf+0x1d0>
        putc(fd, '%');
 668:	85d6                	mv	a1,s5
 66a:	855a                	mv	a0,s6
 66c:	e3fff0ef          	jal	ra,4aa <putc>
        putc(fd, c0);
 670:	85ca                	mv	a1,s2
 672:	855a                	mv	a0,s6
 674:	e37ff0ef          	jal	ra,4aa <putc>
      state = 0;
 678:	4981                	li	s3,0
 67a:	b7b9                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	008b8913          	addi	s2,s7,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e3fff0ef          	jal	ra,4c8 <printint>
        i += 1;
 68e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 1;
 694:	bf15                	j	5c8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 696:	03860563          	beq	a2,s8,6c0 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69a:	07b60963          	beq	a2,s11,70c <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 69e:	07800793          	li	a5,120
 6a2:	fcf613e3          	bne	a2,a5,668 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e15ff0ef          	jal	ra,4c8 <printint>
        i += 2;
 6b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 2;
 6be:	b729                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	dfbff0ef          	jal	ra,4c8 <printint>
        i += 2;
 6d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	bdc5                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6da:	008b8913          	addi	s2,s7,8
 6de:	4681                	li	a3,0
 6e0:	4629                	li	a2,10
 6e2:	000be583          	lwu	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	de1ff0ef          	jal	ra,4c8 <printint>
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bde1                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4629                	li	a2,10
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	dc9ff0ef          	jal	ra,4c8 <printint>
        i += 1;
 704:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 1;
 70a:	bd7d                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	008b8913          	addi	s2,s7,8
 710:	4681                	li	a3,0
 712:	4629                	li	a2,10
 714:	000bb583          	ld	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	dafff0ef          	jal	ra,4c8 <printint>
        i += 2;
 71e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
        i += 2;
 724:	b555                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4641                	li	a2,16
 72e:	000be583          	lwu	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	d95ff0ef          	jal	ra,4c8 <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b571                	j	5c8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4641                	li	a2,16
 746:	000bb583          	ld	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	d7dff0ef          	jal	ra,4c8 <printint>
        i += 1;
 750:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 1;
 756:	bd8d                	j	5c8 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 758:	008b8793          	addi	a5,s7,8
 75c:	f8f43423          	sd	a5,-120(s0)
 760:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	855a                	mv	a0,s6
 76a:	d41ff0ef          	jal	ra,4aa <putc>
  putc(fd, 'x');
 76e:	07800593          	li	a1,120
 772:	855a                	mv	a0,s6
 774:	d37ff0ef          	jal	ra,4aa <putc>
 778:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77a:	03c9d793          	srli	a5,s3,0x3c
 77e:	97e6                	add	a5,a5,s9
 780:	0007c583          	lbu	a1,0(a5)
 784:	855a                	mv	a0,s6
 786:	d25ff0ef          	jal	ra,4aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78a:	0992                	slli	s3,s3,0x4
 78c:	397d                	addiw	s2,s2,-1
 78e:	fe0916e3          	bnez	s2,77a <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 792:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 796:	4981                	li	s3,0
 798:	bd05                	j	5c8 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 79a:	008b8913          	addi	s2,s7,8
 79e:	000bc583          	lbu	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	d07ff0ef          	jal	ra,4aa <putc>
 7a8:	8bca                	mv	s7,s2
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	bd31                	j	5c8 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7ae:	008b8993          	addi	s3,s7,8
 7b2:	000bb903          	ld	s2,0(s7)
 7b6:	00090f63          	beqz	s2,7d4 <vprintf+0x266>
        for(; *s; s++)
 7ba:	00094583          	lbu	a1,0(s2)
 7be:	c195                	beqz	a1,7e2 <vprintf+0x274>
          putc(fd, *s);
 7c0:	855a                	mv	a0,s6
 7c2:	ce9ff0ef          	jal	ra,4aa <putc>
        for(; *s; s++)
 7c6:	0905                	addi	s2,s2,1
 7c8:	00094583          	lbu	a1,0(s2)
 7cc:	f9f5                	bnez	a1,7c0 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bbdd                	j	5c8 <vprintf+0x5a>
          s = "(null)";
 7d4:	00000917          	auipc	s2,0x0
 7d8:	24490913          	addi	s2,s2,580 # a18 <malloc+0x12e>
        for(; *s; s++)
 7dc:	02800593          	li	a1,40
 7e0:	b7c5                	j	7c0 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7e2:	8bce                	mv	s7,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b3cd                	j	5c8 <vprintf+0x5a>
    }
  }
}
 7e8:	70e6                	ld	ra,120(sp)
 7ea:	7446                	ld	s0,112(sp)
 7ec:	74a6                	ld	s1,104(sp)
 7ee:	7906                	ld	s2,96(sp)
 7f0:	69e6                	ld	s3,88(sp)
 7f2:	6a46                	ld	s4,80(sp)
 7f4:	6aa6                	ld	s5,72(sp)
 7f6:	6b06                	ld	s6,64(sp)
 7f8:	7be2                	ld	s7,56(sp)
 7fa:	7c42                	ld	s8,48(sp)
 7fc:	7ca2                	ld	s9,40(sp)
 7fe:	7d02                	ld	s10,32(sp)
 800:	6de2                	ld	s11,24(sp)
 802:	6109                	addi	sp,sp,128
 804:	8082                	ret

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	8622                	mv	a2,s0
 824:	d4bff0ef          	jal	ra,56e <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6161                	addi	sp,sp,80
 82e:	8082                	ret

0000000000000830 <printf>:

void
printf(const char *fmt, ...)
{
 830:	711d                	addi	sp,sp,-96
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e40c                	sd	a1,8(s0)
 83a:	e810                	sd	a2,16(s0)
 83c:	ec14                	sd	a3,24(s0)
 83e:	f018                	sd	a4,32(s0)
 840:	f41c                	sd	a5,40(s0)
 842:	03043823          	sd	a6,48(s0)
 846:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	00840613          	addi	a2,s0,8
 84e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 852:	85aa                	mv	a1,a0
 854:	4505                	li	a0,1
 856:	d19ff0ef          	jal	ra,56e <vprintf>
}
 85a:	60e2                	ld	ra,24(sp)
 85c:	6442                	ld	s0,16(sp)
 85e:	6125                	addi	sp,sp,96
 860:	8082                	ret

0000000000000862 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 862:	1141                	addi	sp,sp,-16
 864:	e422                	sd	s0,8(sp)
 866:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 868:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	00000797          	auipc	a5,0x0
 870:	7947b783          	ld	a5,1940(a5) # 1000 <freep>
 874:	a805                	j	8a4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 876:	4618                	lw	a4,8(a2)
 878:	9db9                	addw	a1,a1,a4
 87a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87e:	6398                	ld	a4,0(a5)
 880:	6318                	ld	a4,0(a4)
 882:	fee53823          	sd	a4,-16(a0)
 886:	a091                	j	8ca <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 888:	ff852703          	lw	a4,-8(a0)
 88c:	9e39                	addw	a2,a2,a4
 88e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 890:	ff053703          	ld	a4,-16(a0)
 894:	e398                	sd	a4,0(a5)
 896:	a099                	j	8dc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	6398                	ld	a4,0(a5)
 89a:	00e7e463          	bltu	a5,a4,8a2 <free+0x40>
 89e:	00e6ea63          	bltu	a3,a4,8b2 <free+0x50>
{
 8a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	fed7fae3          	bgeu	a5,a3,898 <free+0x36>
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e6e463          	bltu	a3,a4,8b2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ae:	fee7eae3          	bltu	a5,a4,8a2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8b2:	ff852583          	lw	a1,-8(a0)
 8b6:	6390                	ld	a2,0(a5)
 8b8:	02059713          	slli	a4,a1,0x20
 8bc:	9301                	srli	a4,a4,0x20
 8be:	0712                	slli	a4,a4,0x4
 8c0:	9736                	add	a4,a4,a3
 8c2:	fae60ae3          	beq	a2,a4,876 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8c6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ca:	4790                	lw	a2,8(a5)
 8cc:	02061713          	slli	a4,a2,0x20
 8d0:	9301                	srli	a4,a4,0x20
 8d2:	0712                	slli	a4,a4,0x4
 8d4:	973e                	add	a4,a4,a5
 8d6:	fae689e3          	beq	a3,a4,888 <free+0x26>
  } else
    p->s.ptr = bp;
 8da:	e394                	sd	a3,0(a5)
  freep = p;
 8dc:	00000717          	auipc	a4,0x0
 8e0:	72f73223          	sd	a5,1828(a4) # 1000 <freep>
}
 8e4:	6422                	ld	s0,8(sp)
 8e6:	0141                	addi	sp,sp,16
 8e8:	8082                	ret

00000000000008ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ea:	7139                	addi	sp,sp,-64
 8ec:	fc06                	sd	ra,56(sp)
 8ee:	f822                	sd	s0,48(sp)
 8f0:	f426                	sd	s1,40(sp)
 8f2:	f04a                	sd	s2,32(sp)
 8f4:	ec4e                	sd	s3,24(sp)
 8f6:	e852                	sd	s4,16(sp)
 8f8:	e456                	sd	s5,8(sp)
 8fa:	e05a                	sd	s6,0(sp)
 8fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fe:	02051493          	slli	s1,a0,0x20
 902:	9081                	srli	s1,s1,0x20
 904:	04bd                	addi	s1,s1,15
 906:	8091                	srli	s1,s1,0x4
 908:	0014899b          	addiw	s3,s1,1
 90c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 90e:	00000517          	auipc	a0,0x0
 912:	6f253503          	ld	a0,1778(a0) # 1000 <freep>
 916:	c515                	beqz	a0,942 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 918:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91a:	4798                	lw	a4,8(a5)
 91c:	02977f63          	bgeu	a4,s1,95a <malloc+0x70>
 920:	8a4e                	mv	s4,s3
 922:	0009871b          	sext.w	a4,s3
 926:	6685                	lui	a3,0x1
 928:	00d77363          	bgeu	a4,a3,92e <malloc+0x44>
 92c:	6a05                	lui	s4,0x1
 92e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 932:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 936:	00000917          	auipc	s2,0x0
 93a:	6ca90913          	addi	s2,s2,1738 # 1000 <freep>
  if(p == SBRK_ERROR)
 93e:	5afd                	li	s5,-1
 940:	a0bd                	j	9ae <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 942:	00001797          	auipc	a5,0x1
 946:	8ce78793          	addi	a5,a5,-1842 # 1210 <base>
 94a:	00000717          	auipc	a4,0x0
 94e:	6af73b23          	sd	a5,1718(a4) # 1000 <freep>
 952:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 954:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 958:	b7e1                	j	920 <malloc+0x36>
      if(p->s.size == nunits)
 95a:	02e48b63          	beq	s1,a4,990 <malloc+0xa6>
        p->s.size -= nunits;
 95e:	4137073b          	subw	a4,a4,s3
 962:	c798                	sw	a4,8(a5)
        p += p->s.size;
 964:	1702                	slli	a4,a4,0x20
 966:	9301                	srli	a4,a4,0x20
 968:	0712                	slli	a4,a4,0x4
 96a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 970:	00000717          	auipc	a4,0x0
 974:	68a73823          	sd	a0,1680(a4) # 1000 <freep>
      return (void*)(p + 1);
 978:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 97c:	70e2                	ld	ra,56(sp)
 97e:	7442                	ld	s0,48(sp)
 980:	74a2                	ld	s1,40(sp)
 982:	7902                	ld	s2,32(sp)
 984:	69e2                	ld	s3,24(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	6121                	addi	sp,sp,64
 98e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 990:	6398                	ld	a4,0(a5)
 992:	e118                	sd	a4,0(a0)
 994:	bff1                	j	970 <malloc+0x86>
  hp->s.size = nu;
 996:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99a:	0541                	addi	a0,a0,16
 99c:	ec7ff0ef          	jal	ra,862 <free>
  return freep;
 9a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a4:	dd61                	beqz	a0,97c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a8:	4798                	lw	a4,8(a5)
 9aa:	fa9778e3          	bgeu	a4,s1,95a <malloc+0x70>
    if(p == freep)
 9ae:	00093703          	ld	a4,0(s2)
 9b2:	853e                	mv	a0,a5
 9b4:	fef719e3          	bne	a4,a5,9a6 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9b8:	8552                	mv	a0,s4
 9ba:	a15ff0ef          	jal	ra,3ce <sbrk>
  if(p == SBRK_ERROR)
 9be:	fd551ce3          	bne	a0,s5,996 <malloc+0xac>
        return 0;
 9c2:	4501                	li	a0,0
 9c4:	bf65                	j	97c <malloc+0x92>
