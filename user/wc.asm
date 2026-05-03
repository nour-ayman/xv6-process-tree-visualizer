
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
  3c:	988a0a13          	addi	s4,s4,-1656 # 9c0 <malloc+0xde>
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
  b2:	92a50513          	addi	a0,a0,-1750 # 9d8 <malloc+0xf6>
  b6:	772000ef          	jal	ra,828 <printf>
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
  dc:	8f050513          	addi	a0,a0,-1808 # 9c8 <malloc+0xe6>
  e0:	748000ef          	jal	ra,828 <printf>
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
 13e:	8ae58593          	addi	a1,a1,-1874 # 9e8 <malloc+0x106>
 142:	4501                	li	a0,0
 144:	ebdff0ef          	jal	ra,0 <wc>
    exit(0);
 148:	4501                	li	a0,0
 14a:	2b8000ef          	jal	ra,402 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 14e:	608c                	ld	a1,0(s1)
 150:	00001517          	auipc	a0,0x1
 154:	8a050513          	addi	a0,a0,-1888 # 9f0 <malloc+0x10e>
 158:	6d0000ef          	jal	ra,828 <printf>
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

00000000000004a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a2:	1101                	addi	sp,sp,-32
 4a4:	ec06                	sd	ra,24(sp)
 4a6:	e822                	sd	s0,16(sp)
 4a8:	1000                	addi	s0,sp,32
 4aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	fef40593          	addi	a1,s0,-17
 4b4:	f6fff0ef          	jal	ra,422 <write>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	6105                	addi	sp,sp,32
 4be:	8082                	ret

00000000000004c0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4c0:	715d                	addi	sp,sp,-80
 4c2:	e486                	sd	ra,72(sp)
 4c4:	e0a2                	sd	s0,64(sp)
 4c6:	fc26                	sd	s1,56(sp)
 4c8:	f84a                	sd	s2,48(sp)
 4ca:	f44e                	sd	s3,40(sp)
 4cc:	0880                	addi	s0,sp,80
 4ce:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d0:	c299                	beqz	a3,4d6 <printint+0x16>
 4d2:	0805c663          	bltz	a1,55e <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d6:	2581                	sext.w	a1,a1
  neg = 0;
 4d8:	4881                	li	a7,0
 4da:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 4de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e0:	2601                	sext.w	a2,a2
 4e2:	00000517          	auipc	a0,0x0
 4e6:	52e50513          	addi	a0,a0,1326 # a10 <digits>
 4ea:	883a                	mv	a6,a4
 4ec:	2705                	addiw	a4,a4,1
 4ee:	02c5f7bb          	remuw	a5,a1,a2
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	97aa                	add	a5,a5,a0
 4f8:	0007c783          	lbu	a5,0(a5)
 4fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 500:	0005879b          	sext.w	a5,a1
 504:	02c5d5bb          	divuw	a1,a1,a2
 508:	0685                	addi	a3,a3,1
 50a:	fec7f0e3          	bgeu	a5,a2,4ea <printint+0x2a>
  if(neg)
 50e:	00088b63          	beqz	a7,524 <printint+0x64>
    buf[i++] = '-';
 512:	fd040793          	addi	a5,s0,-48
 516:	973e                	add	a4,a4,a5
 518:	02d00793          	li	a5,45
 51c:	fef70423          	sb	a5,-24(a4)
 520:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 524:	02e05663          	blez	a4,550 <printint+0x90>
 528:	fb840793          	addi	a5,s0,-72
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	addi	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addiw	a4,a4,-1
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	f5dff0ef          	jal	ra,4a2 <putc>
  while(--i >= 0)
 54a:	197d                	addi	s2,s2,-1
 54c:	ff391ae3          	bne	s2,s3,540 <printint+0x80>
}
 550:	60a6                	ld	ra,72(sp)
 552:	6406                	ld	s0,64(sp)
 554:	74e2                	ld	s1,56(sp)
 556:	7942                	ld	s2,48(sp)
 558:	79a2                	ld	s3,40(sp)
 55a:	6161                	addi	sp,sp,80
 55c:	8082                	ret
    x = -xx;
 55e:	40b005bb          	negw	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bf9d                	j	4da <printint+0x1a>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	7119                	addi	sp,sp,-128
 568:	fc86                	sd	ra,120(sp)
 56a:	f8a2                	sd	s0,112(sp)
 56c:	f4a6                	sd	s1,104(sp)
 56e:	f0ca                	sd	s2,96(sp)
 570:	ecce                	sd	s3,88(sp)
 572:	e8d2                	sd	s4,80(sp)
 574:	e4d6                	sd	s5,72(sp)
 576:	e0da                	sd	s6,64(sp)
 578:	fc5e                	sd	s7,56(sp)
 57a:	f862                	sd	s8,48(sp)
 57c:	f466                	sd	s9,40(sp)
 57e:	f06a                	sd	s10,32(sp)
 580:	ec6e                	sd	s11,24(sp)
 582:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 584:	0005c903          	lbu	s2,0(a1)
 588:	24090c63          	beqz	s2,7e0 <vprintf+0x27a>
 58c:	8b2a                	mv	s6,a0
 58e:	8a2e                	mv	s4,a1
 590:	8bb2                	mv	s7,a2
  state = 0;
 592:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 594:	4481                	li	s1,0
 596:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 598:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 59c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a0:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a4:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a8:	00000c97          	auipc	s9,0x0
 5ac:	468c8c93          	addi	s9,s9,1128 # a10 <digits>
 5b0:	a005                	j	5d0 <vprintf+0x6a>
        putc(fd, c0);
 5b2:	85ca                	mv	a1,s2
 5b4:	855a                	mv	a0,s6
 5b6:	eedff0ef          	jal	ra,4a2 <putc>
 5ba:	a019                	j	5c0 <vprintf+0x5a>
    } else if(state == '%'){
 5bc:	03598263          	beq	s3,s5,5e0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c0:	2485                	addiw	s1,s1,1
 5c2:	8726                	mv	a4,s1
 5c4:	009a07b3          	add	a5,s4,s1
 5c8:	0007c903          	lbu	s2,0(a5)
 5cc:	20090a63          	beqz	s2,7e0 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 5d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d4:	fe0994e3          	bnez	s3,5bc <vprintf+0x56>
      if(c0 == '%'){
 5d8:	fd579de3          	bne	a5,s5,5b2 <vprintf+0x4c>
        state = '%';
 5dc:	89be                	mv	s3,a5
 5de:	b7cd                	j	5c0 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e0:	c3c1                	beqz	a5,660 <vprintf+0xfa>
 5e2:	00ea06b3          	add	a3,s4,a4
 5e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ec:	c681                	beqz	a3,5f4 <vprintf+0x8e>
 5ee:	9752                	add	a4,a4,s4
 5f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f4:	03878e63          	beq	a5,s8,630 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	05a78863          	beq	a5,s10,648 <vprintf+0xe2>
      } else if(c0 == 'u'){
 5fc:	0db78b63          	beq	a5,s11,6d2 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 600:	07800713          	li	a4,120
 604:	10e78d63          	beq	a5,a4,71e <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 608:	07000713          	li	a4,112
 60c:	14e78263          	beq	a5,a4,750 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 610:	06300713          	li	a4,99
 614:	16e78f63          	beq	a5,a4,792 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 618:	07300713          	li	a4,115
 61c:	18e78563          	beq	a5,a4,7a6 <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 620:	05579063          	bne	a5,s5,660 <vprintf+0xfa>
        putc(fd, '%');
 624:	85d6                	mv	a1,s5
 626:	855a                	mv	a0,s6
 628:	e7bff0ef          	jal	ra,4a2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf49                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 630:	008b8913          	addi	s2,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e83ff0ef          	jal	ra,4c0 <printint>
 642:	8bca                	mv	s7,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	bfad                	j	5c0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 648:	03868663          	beq	a3,s8,674 <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64c:	05a68163          	beq	a3,s10,68e <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 650:	09b68d63          	beq	a3,s11,6ea <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 654:	03a68f63          	beq	a3,s10,692 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 658:	07800793          	li	a5,120
 65c:	0cf68d63          	beq	a3,a5,736 <vprintf+0x1d0>
        putc(fd, '%');
 660:	85d6                	mv	a1,s5
 662:	855a                	mv	a0,s6
 664:	e3fff0ef          	jal	ra,4a2 <putc>
        putc(fd, c0);
 668:	85ca                	mv	a1,s2
 66a:	855a                	mv	a0,s6
 66c:	e37ff0ef          	jal	ra,4a2 <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	b7b9                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8913          	addi	s2,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	e3fff0ef          	jal	ra,4c0 <printint>
        i += 1;
 686:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 1;
 68c:	bf15                	j	5c0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68e:	03860563          	beq	a2,s8,6b8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 692:	07b60963          	beq	a2,s11,704 <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 696:	07800793          	li	a5,120
 69a:	fcf613e3          	bne	a2,a5,660 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4641                	li	a2,16
 6a6:	000bb583          	ld	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	e15ff0ef          	jal	ra,4c0 <printint>
        i += 2;
 6b0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 2;
 6b6:	b729                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	dfbff0ef          	jal	ra,4c0 <printint>
        i += 2;
 6ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 2;
 6d0:	bdc5                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4629                	li	a2,10
 6da:	000be583          	lwu	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	de1ff0ef          	jal	ra,4c0 <printint>
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bde1                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4629                	li	a2,10
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	dc9ff0ef          	jal	ra,4c0 <printint>
        i += 1;
 6fc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 1;
 702:	bd7d                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 704:	008b8913          	addi	s2,s7,8
 708:	4681                	li	a3,0
 70a:	4629                	li	a2,10
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	dafff0ef          	jal	ra,4c0 <printint>
        i += 2;
 716:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	b555                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4641                	li	a2,16
 726:	000be583          	lwu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	d95ff0ef          	jal	ra,4c0 <printint>
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	b571                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4641                	li	a2,16
 73e:	000bb583          	ld	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	d7dff0ef          	jal	ra,4c0 <printint>
        i += 1;
 748:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	bd8d                	j	5c0 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 750:	008b8793          	addi	a5,s7,8
 754:	f8f43423          	sd	a5,-120(s0)
 758:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 75c:	03000593          	li	a1,48
 760:	855a                	mv	a0,s6
 762:	d41ff0ef          	jal	ra,4a2 <putc>
  putc(fd, 'x');
 766:	07800593          	li	a1,120
 76a:	855a                	mv	a0,s6
 76c:	d37ff0ef          	jal	ra,4a2 <putc>
 770:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 772:	03c9d793          	srli	a5,s3,0x3c
 776:	97e6                	add	a5,a5,s9
 778:	0007c583          	lbu	a1,0(a5)
 77c:	855a                	mv	a0,s6
 77e:	d25ff0ef          	jal	ra,4a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 782:	0992                	slli	s3,s3,0x4
 784:	397d                	addiw	s2,s2,-1
 786:	fe0916e3          	bnez	s2,772 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 78a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 78e:	4981                	li	s3,0
 790:	bd05                	j	5c0 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 792:	008b8913          	addi	s2,s7,8
 796:	000bc583          	lbu	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	d07ff0ef          	jal	ra,4a2 <putc>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bd31                	j	5c0 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7a6:	008b8993          	addi	s3,s7,8
 7aa:	000bb903          	ld	s2,0(s7)
 7ae:	00090f63          	beqz	s2,7cc <vprintf+0x266>
        for(; *s; s++)
 7b2:	00094583          	lbu	a1,0(s2)
 7b6:	c195                	beqz	a1,7da <vprintf+0x274>
          putc(fd, *s);
 7b8:	855a                	mv	a0,s6
 7ba:	ce9ff0ef          	jal	ra,4a2 <putc>
        for(; *s; s++)
 7be:	0905                	addi	s2,s2,1
 7c0:	00094583          	lbu	a1,0(s2)
 7c4:	f9f5                	bnez	a1,7b8 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	8bce                	mv	s7,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bbdd                	j	5c0 <vprintf+0x5a>
          s = "(null)";
 7cc:	00000917          	auipc	s2,0x0
 7d0:	23c90913          	addi	s2,s2,572 # a08 <malloc+0x126>
        for(; *s; s++)
 7d4:	02800593          	li	a1,40
 7d8:	b7c5                	j	7b8 <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 7da:	8bce                	mv	s7,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b3cd                	j	5c0 <vprintf+0x5a>
    }
  }
}
 7e0:	70e6                	ld	ra,120(sp)
 7e2:	7446                	ld	s0,112(sp)
 7e4:	74a6                	ld	s1,104(sp)
 7e6:	7906                	ld	s2,96(sp)
 7e8:	69e6                	ld	s3,88(sp)
 7ea:	6a46                	ld	s4,80(sp)
 7ec:	6aa6                	ld	s5,72(sp)
 7ee:	6b06                	ld	s6,64(sp)
 7f0:	7be2                	ld	s7,56(sp)
 7f2:	7c42                	ld	s8,48(sp)
 7f4:	7ca2                	ld	s9,40(sp)
 7f6:	7d02                	ld	s10,32(sp)
 7f8:	6de2                	ld	s11,24(sp)
 7fa:	6109                	addi	sp,sp,128
 7fc:	8082                	ret

00000000000007fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fe:	715d                	addi	sp,sp,-80
 800:	ec06                	sd	ra,24(sp)
 802:	e822                	sd	s0,16(sp)
 804:	1000                	addi	s0,sp,32
 806:	e010                	sd	a2,0(s0)
 808:	e414                	sd	a3,8(s0)
 80a:	e818                	sd	a4,16(s0)
 80c:	ec1c                	sd	a5,24(s0)
 80e:	03043023          	sd	a6,32(s0)
 812:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 816:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81a:	8622                	mv	a2,s0
 81c:	d4bff0ef          	jal	ra,566 <vprintf>
}
 820:	60e2                	ld	ra,24(sp)
 822:	6442                	ld	s0,16(sp)
 824:	6161                	addi	sp,sp,80
 826:	8082                	ret

0000000000000828 <printf>:

void
printf(const char *fmt, ...)
{
 828:	711d                	addi	sp,sp,-96
 82a:	ec06                	sd	ra,24(sp)
 82c:	e822                	sd	s0,16(sp)
 82e:	1000                	addi	s0,sp,32
 830:	e40c                	sd	a1,8(s0)
 832:	e810                	sd	a2,16(s0)
 834:	ec14                	sd	a3,24(s0)
 836:	f018                	sd	a4,32(s0)
 838:	f41c                	sd	a5,40(s0)
 83a:	03043823          	sd	a6,48(s0)
 83e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 842:	00840613          	addi	a2,s0,8
 846:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84a:	85aa                	mv	a1,a0
 84c:	4505                	li	a0,1
 84e:	d19ff0ef          	jal	ra,566 <vprintf>
}
 852:	60e2                	ld	ra,24(sp)
 854:	6442                	ld	s0,16(sp)
 856:	6125                	addi	sp,sp,96
 858:	8082                	ret

000000000000085a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85a:	1141                	addi	sp,sp,-16
 85c:	e422                	sd	s0,8(sp)
 85e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 860:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 864:	00000797          	auipc	a5,0x0
 868:	79c7b783          	ld	a5,1948(a5) # 1000 <freep>
 86c:	a805                	j	89c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86e:	4618                	lw	a4,8(a2)
 870:	9db9                	addw	a1,a1,a4
 872:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	6318                	ld	a4,0(a4)
 87a:	fee53823          	sd	a4,-16(a0)
 87e:	a091                	j	8c2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 880:	ff852703          	lw	a4,-8(a0)
 884:	9e39                	addw	a2,a2,a4
 886:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 888:	ff053703          	ld	a4,-16(a0)
 88c:	e398                	sd	a4,0(a5)
 88e:	a099                	j	8d4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	6398                	ld	a4,0(a5)
 892:	00e7e463          	bltu	a5,a4,89a <free+0x40>
 896:	00e6ea63          	bltu	a3,a4,8aa <free+0x50>
{
 89a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	fed7fae3          	bgeu	a5,a3,890 <free+0x36>
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e6e463          	bltu	a3,a4,8aa <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	fee7eae3          	bltu	a5,a4,89a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8aa:	ff852583          	lw	a1,-8(a0)
 8ae:	6390                	ld	a2,0(a5)
 8b0:	02059713          	slli	a4,a1,0x20
 8b4:	9301                	srli	a4,a4,0x20
 8b6:	0712                	slli	a4,a4,0x4
 8b8:	9736                	add	a4,a4,a3
 8ba:	fae60ae3          	beq	a2,a4,86e <free+0x14>
    bp->s.ptr = p->s.ptr;
 8be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c2:	4790                	lw	a2,8(a5)
 8c4:	02061713          	slli	a4,a2,0x20
 8c8:	9301                	srli	a4,a4,0x20
 8ca:	0712                	slli	a4,a4,0x4
 8cc:	973e                	add	a4,a4,a5
 8ce:	fae689e3          	beq	a3,a4,880 <free+0x26>
  } else
    p->s.ptr = bp;
 8d2:	e394                	sd	a3,0(a5)
  freep = p;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72f73623          	sd	a5,1836(a4) # 1000 <freep>
}
 8dc:	6422                	ld	s0,8(sp)
 8de:	0141                	addi	sp,sp,16
 8e0:	8082                	ret

00000000000008e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e2:	7139                	addi	sp,sp,-64
 8e4:	fc06                	sd	ra,56(sp)
 8e6:	f822                	sd	s0,48(sp)
 8e8:	f426                	sd	s1,40(sp)
 8ea:	f04a                	sd	s2,32(sp)
 8ec:	ec4e                	sd	s3,24(sp)
 8ee:	e852                	sd	s4,16(sp)
 8f0:	e456                	sd	s5,8(sp)
 8f2:	e05a                	sd	s6,0(sp)
 8f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f6:	02051493          	slli	s1,a0,0x20
 8fa:	9081                	srli	s1,s1,0x20
 8fc:	04bd                	addi	s1,s1,15
 8fe:	8091                	srli	s1,s1,0x4
 900:	0014899b          	addiw	s3,s1,1
 904:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 906:	00000517          	auipc	a0,0x0
 90a:	6fa53503          	ld	a0,1786(a0) # 1000 <freep>
 90e:	c515                	beqz	a0,93a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 910:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 912:	4798                	lw	a4,8(a5)
 914:	02977f63          	bgeu	a4,s1,952 <malloc+0x70>
 918:	8a4e                	mv	s4,s3
 91a:	0009871b          	sext.w	a4,s3
 91e:	6685                	lui	a3,0x1
 920:	00d77363          	bgeu	a4,a3,926 <malloc+0x44>
 924:	6a05                	lui	s4,0x1
 926:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92e:	00000917          	auipc	s2,0x0
 932:	6d290913          	addi	s2,s2,1746 # 1000 <freep>
  if(p == SBRK_ERROR)
 936:	5afd                	li	s5,-1
 938:	a0bd                	j	9a6 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 93a:	00001797          	auipc	a5,0x1
 93e:	8d678793          	addi	a5,a5,-1834 # 1210 <base>
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
 94a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 950:	b7e1                	j	918 <malloc+0x36>
      if(p->s.size == nunits)
 952:	02e48b63          	beq	s1,a4,988 <malloc+0xa6>
        p->s.size -= nunits;
 956:	4137073b          	subw	a4,a4,s3
 95a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95c:	1702                	slli	a4,a4,0x20
 95e:	9301                	srli	a4,a4,0x20
 960:	0712                	slli	a4,a4,0x4
 962:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 964:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 968:	00000717          	auipc	a4,0x0
 96c:	68a73c23          	sd	a0,1688(a4) # 1000 <freep>
      return (void*)(p + 1);
 970:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 974:	70e2                	ld	ra,56(sp)
 976:	7442                	ld	s0,48(sp)
 978:	74a2                	ld	s1,40(sp)
 97a:	7902                	ld	s2,32(sp)
 97c:	69e2                	ld	s3,24(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	6121                	addi	sp,sp,64
 986:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 988:	6398                	ld	a4,0(a5)
 98a:	e118                	sd	a4,0(a0)
 98c:	bff1                	j	968 <malloc+0x86>
  hp->s.size = nu;
 98e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 992:	0541                	addi	a0,a0,16
 994:	ec7ff0ef          	jal	ra,85a <free>
  return freep;
 998:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 99c:	dd61                	beqz	a0,974 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a0:	4798                	lw	a4,8(a5)
 9a2:	fa9778e3          	bgeu	a4,s1,952 <malloc+0x70>
    if(p == freep)
 9a6:	00093703          	ld	a4,0(s2)
 9aa:	853e                	mv	a0,a5
 9ac:	fef719e3          	bne	a4,a5,99e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9b0:	8552                	mv	a0,s4
 9b2:	a1dff0ef          	jal	ra,3ce <sbrk>
  if(p == SBRK_ERROR)
 9b6:	fd551ce3          	bne	a0,s5,98e <malloc+0xac>
        return 0;
 9ba:	4501                	li	a0,0
 9bc:	bf65                	j	974 <malloc+0x92>
