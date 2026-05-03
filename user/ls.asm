
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2b2000ef          	jal	ra,2c2 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	28a000ef          	jal	ra,2c2 <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[sizeof(buf)-1] = '\0';
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	26c000ef          	jal	ra,2c2 <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.1111>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3c0000ef          	jal	ra,42a <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	252000ef          	jal	ra,2c2 <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	248000ef          	jal	ra,2c2 <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	25c000ef          	jal	ra,2ec <memset>
  buf[sizeof(buf)-1] = '\0';
  94:	00098723          	sb	zero,14(s3)
  return buf;
  98:	84ce                	mv	s1,s3
  9a:	b76d                	j	44 <fmtname+0x44>

000000000000009c <ls>:

void
ls(char *path)
{
  9c:	d9010113          	addi	sp,sp,-624
  a0:	26113423          	sd	ra,616(sp)
  a4:	26813023          	sd	s0,608(sp)
  a8:	24913c23          	sd	s1,600(sp)
  ac:	25213823          	sd	s2,592(sp)
  b0:	25313423          	sd	s3,584(sp)
  b4:	25413023          	sd	s4,576(sp)
  b8:	23513c23          	sd	s5,568(sp)
  bc:	1c80                	addi	s0,sp,624
  be:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  c0:	4581                	li	a1,0
  c2:	486000ef          	jal	ra,548 <open>
  c6:	06054963          	bltz	a0,138 <ls+0x9c>
  ca:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  cc:	d9840593          	addi	a1,s0,-616
  d0:	490000ef          	jal	ra,560 <fstat>
  d4:	06054b63          	bltz	a0,14a <ls+0xae>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d8:	da041783          	lh	a5,-608(s0)
  dc:	0007869b          	sext.w	a3,a5
  e0:	4705                	li	a4,1
  e2:	08e68063          	beq	a3,a4,162 <ls+0xc6>
  e6:	37f9                	addiw	a5,a5,-2
  e8:	17c2                	slli	a5,a5,0x30
  ea:	93c1                	srli	a5,a5,0x30
  ec:	02f76263          	bltu	a4,a5,110 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  f0:	854a                	mv	a0,s2
  f2:	f0fff0ef          	jal	ra,0 <fmtname>
  f6:	85aa                	mv	a1,a0
  f8:	da842703          	lw	a4,-600(s0)
  fc:	d9c42683          	lw	a3,-612(s0)
 100:	da041603          	lh	a2,-608(s0)
 104:	00001517          	auipc	a0,0x1
 108:	9fc50513          	addi	a0,a0,-1540 # b00 <malloc+0x118>
 10c:	023000ef          	jal	ra,92e <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 110:	8526                	mv	a0,s1
 112:	41e000ef          	jal	ra,530 <close>
}
 116:	26813083          	ld	ra,616(sp)
 11a:	26013403          	ld	s0,608(sp)
 11e:	25813483          	ld	s1,600(sp)
 122:	25013903          	ld	s2,592(sp)
 126:	24813983          	ld	s3,584(sp)
 12a:	24013a03          	ld	s4,576(sp)
 12e:	23813a83          	ld	s5,568(sp)
 132:	27010113          	addi	sp,sp,624
 136:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 138:	864a                	mv	a2,s2
 13a:	00001597          	auipc	a1,0x1
 13e:	99658593          	addi	a1,a1,-1642 # ad0 <malloc+0xe8>
 142:	4509                	li	a0,2
 144:	7c0000ef          	jal	ra,904 <fprintf>
    return;
 148:	b7f9                	j	116 <ls+0x7a>
    fprintf(2, "ls: cannot stat %s\n", path);
 14a:	864a                	mv	a2,s2
 14c:	00001597          	auipc	a1,0x1
 150:	99c58593          	addi	a1,a1,-1636 # ae8 <malloc+0x100>
 154:	4509                	li	a0,2
 156:	7ae000ef          	jal	ra,904 <fprintf>
    close(fd);
 15a:	8526                	mv	a0,s1
 15c:	3d4000ef          	jal	ra,530 <close>
    return;
 160:	bf5d                	j	116 <ls+0x7a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 162:	854a                	mv	a0,s2
 164:	15e000ef          	jal	ra,2c2 <strlen>
 168:	2541                	addiw	a0,a0,16
 16a:	20000793          	li	a5,512
 16e:	00a7f963          	bgeu	a5,a0,180 <ls+0xe4>
      printf("ls: path too long\n");
 172:	00001517          	auipc	a0,0x1
 176:	99e50513          	addi	a0,a0,-1634 # b10 <malloc+0x128>
 17a:	7b4000ef          	jal	ra,92e <printf>
      break;
 17e:	bf49                	j	110 <ls+0x74>
    strcpy(buf, path);
 180:	85ca                	mv	a1,s2
 182:	dc040513          	addi	a0,s0,-576
 186:	0f4000ef          	jal	ra,27a <strcpy>
    p = buf+strlen(buf);
 18a:	dc040513          	addi	a0,s0,-576
 18e:	134000ef          	jal	ra,2c2 <strlen>
 192:	02051913          	slli	s2,a0,0x20
 196:	02095913          	srli	s2,s2,0x20
 19a:	dc040793          	addi	a5,s0,-576
 19e:	993e                	add	s2,s2,a5
    *p++ = '/';
 1a0:	00190993          	addi	s3,s2,1
 1a4:	02f00793          	li	a5,47
 1a8:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ac:	00001a17          	auipc	s4,0x1
 1b0:	954a0a13          	addi	s4,s4,-1708 # b00 <malloc+0x118>
        printf("ls: cannot stat %s\n", buf);
 1b4:	00001a97          	auipc	s5,0x1
 1b8:	934a8a93          	addi	s5,s5,-1740 # ae8 <malloc+0x100>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1bc:	a031                	j	1c8 <ls+0x12c>
        printf("ls: cannot stat %s\n", buf);
 1be:	dc040593          	addi	a1,s0,-576
 1c2:	8556                	mv	a0,s5
 1c4:	76a000ef          	jal	ra,92e <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c8:	4641                	li	a2,16
 1ca:	db040593          	addi	a1,s0,-592
 1ce:	8526                	mv	a0,s1
 1d0:	350000ef          	jal	ra,520 <read>
 1d4:	47c1                	li	a5,16
 1d6:	f2f51de3          	bne	a0,a5,110 <ls+0x74>
      if(de.inum == 0)
 1da:	db045783          	lhu	a5,-592(s0)
 1de:	d7ed                	beqz	a5,1c8 <ls+0x12c>
      memmove(p, de.name, DIRSIZ);
 1e0:	4639                	li	a2,14
 1e2:	db240593          	addi	a1,s0,-590
 1e6:	854e                	mv	a0,s3
 1e8:	242000ef          	jal	ra,42a <memmove>
      p[DIRSIZ] = 0;
 1ec:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1f0:	d9840593          	addi	a1,s0,-616
 1f4:	dc040513          	addi	a0,s0,-576
 1f8:	1ae000ef          	jal	ra,3a6 <stat>
 1fc:	fc0541e3          	bltz	a0,1be <ls+0x122>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 200:	dc040513          	addi	a0,s0,-576
 204:	dfdff0ef          	jal	ra,0 <fmtname>
 208:	85aa                	mv	a1,a0
 20a:	da842703          	lw	a4,-600(s0)
 20e:	d9c42683          	lw	a3,-612(s0)
 212:	da041603          	lh	a2,-608(s0)
 216:	8552                	mv	a0,s4
 218:	716000ef          	jal	ra,92e <printf>
 21c:	b775                	j	1c8 <ls+0x12c>

000000000000021e <main>:

int
main(int argc, char *argv[])
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 22a:	4785                	li	a5,1
 22c:	02a7d563          	bge	a5,a0,256 <main+0x38>
 230:	00858493          	addi	s1,a1,8
 234:	ffe5091b          	addiw	s2,a0,-2
 238:	1902                	slli	s2,s2,0x20
 23a:	02095913          	srli	s2,s2,0x20
 23e:	090e                	slli	s2,s2,0x3
 240:	05c1                	addi	a1,a1,16
 242:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 244:	6088                	ld	a0,0(s1)
 246:	e57ff0ef          	jal	ra,9c <ls>
  for(i=1; i<argc; i++)
 24a:	04a1                	addi	s1,s1,8
 24c:	ff249ce3          	bne	s1,s2,244 <main+0x26>
  exit(0);
 250:	4501                	li	a0,0
 252:	2b6000ef          	jal	ra,508 <exit>
    ls(".");
 256:	00001517          	auipc	a0,0x1
 25a:	8d250513          	addi	a0,a0,-1838 # b28 <malloc+0x140>
 25e:	e3fff0ef          	jal	ra,9c <ls>
    exit(0);
 262:	4501                	li	a0,0
 264:	2a4000ef          	jal	ra,508 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 270:	fafff0ef          	jal	ra,21e <main>
  exit(0);
 274:	4501                	li	a0,0
 276:	292000ef          	jal	ra,508 <exit>

000000000000027a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0x8>
    ;
  return os;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x1e>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x1e>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strlen>:

uint
strlen(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cf91                	beqz	a5,2e8 <strlen+0x26>
 2ce:	0505                	addi	a0,a0,1
 2d0:	87aa                	mv	a5,a0
 2d2:	4685                	li	a3,1
 2d4:	9e89                	subw	a3,a3,a0
 2d6:	00f6853b          	addw	a0,a3,a5
 2da:	0785                	addi	a5,a5,1
 2dc:	fff7c703          	lbu	a4,-1(a5)
 2e0:	fb7d                	bnez	a4,2d6 <strlen+0x14>
    ;
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  for(n = 0; s[n]; n++)
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strlen+0x20>

00000000000002ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f2:	ce09                	beqz	a2,30c <memset+0x20>
 2f4:	87aa                	mv	a5,a0
 2f6:	fff6071b          	addiw	a4,a2,-1
 2fa:	1702                	slli	a4,a4,0x20
 2fc:	9301                	srli	a4,a4,0x20
 2fe:	0705                	addi	a4,a4,1
 300:	972a                	add	a4,a4,a0
    cdst[i] = c;
 302:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 306:	0785                	addi	a5,a5,1
 308:	fee79de3          	bne	a5,a4,302 <memset+0x16>
  }
  return dst;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <strchr>:

char*
strchr(const char *s, char c)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  for(; *s; s++)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cb99                	beqz	a5,332 <strchr+0x20>
    if(*s == c)
 31e:	00f58763          	beq	a1,a5,32c <strchr+0x1a>
  for(; *s; s++)
 322:	0505                	addi	a0,a0,1
 324:	00054783          	lbu	a5,0(a0)
 328:	fbfd                	bnez	a5,31e <strchr+0xc>
      return (char*)s;
  return 0;
 32a:	4501                	li	a0,0
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strchr+0x1a>

0000000000000336 <gets>:

char*
gets(char *buf, int max)
{
 336:	711d                	addi	sp,sp,-96
 338:	ec86                	sd	ra,88(sp)
 33a:	e8a2                	sd	s0,80(sp)
 33c:	e4a6                	sd	s1,72(sp)
 33e:	e0ca                	sd	s2,64(sp)
 340:	fc4e                	sd	s3,56(sp)
 342:	f852                	sd	s4,48(sp)
 344:	f456                	sd	s5,40(sp)
 346:	f05a                	sd	s6,32(sp)
 348:	ec5e                	sd	s7,24(sp)
 34a:	1080                	addi	s0,sp,96
 34c:	8baa                	mv	s7,a0
 34e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	892a                	mv	s2,a0
 352:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 354:	4aa9                	li	s5,10
 356:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 358:	89a6                	mv	s3,s1
 35a:	2485                	addiw	s1,s1,1
 35c:	0344d663          	bge	s1,s4,388 <gets+0x52>
    cc = read(0, &c, 1);
 360:	4605                	li	a2,1
 362:	faf40593          	addi	a1,s0,-81
 366:	4501                	li	a0,0
 368:	1b8000ef          	jal	ra,520 <read>
    if(cc < 1)
 36c:	00a05e63          	blez	a0,388 <gets+0x52>
    buf[i++] = c;
 370:	faf44783          	lbu	a5,-81(s0)
 374:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 378:	01578763          	beq	a5,s5,386 <gets+0x50>
 37c:	0905                	addi	s2,s2,1
 37e:	fd679de3          	bne	a5,s6,358 <gets+0x22>
  for(i=0; i+1 < max; ){
 382:	89a6                	mv	s3,s1
 384:	a011                	j	388 <gets+0x52>
 386:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 388:	99de                	add	s3,s3,s7
 38a:	00098023          	sb	zero,0(s3)
  return buf;
}
 38e:	855e                	mv	a0,s7
 390:	60e6                	ld	ra,88(sp)
 392:	6446                	ld	s0,80(sp)
 394:	64a6                	ld	s1,72(sp)
 396:	6906                	ld	s2,64(sp)
 398:	79e2                	ld	s3,56(sp)
 39a:	7a42                	ld	s4,48(sp)
 39c:	7aa2                	ld	s5,40(sp)
 39e:	7b02                	ld	s6,32(sp)
 3a0:	6be2                	ld	s7,24(sp)
 3a2:	6125                	addi	sp,sp,96
 3a4:	8082                	ret

00000000000003a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a6:	1101                	addi	sp,sp,-32
 3a8:	ec06                	sd	ra,24(sp)
 3aa:	e822                	sd	s0,16(sp)
 3ac:	e426                	sd	s1,8(sp)
 3ae:	e04a                	sd	s2,0(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b4:	4581                	li	a1,0
 3b6:	192000ef          	jal	ra,548 <open>
  if(fd < 0)
 3ba:	02054163          	bltz	a0,3dc <stat+0x36>
 3be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c0:	85ca                	mv	a1,s2
 3c2:	19e000ef          	jal	ra,560 <fstat>
 3c6:	892a                	mv	s2,a0
  close(fd);
 3c8:	8526                	mv	a0,s1
 3ca:	166000ef          	jal	ra,530 <close>
  return r;
}
 3ce:	854a                	mv	a0,s2
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	64a2                	ld	s1,8(sp)
 3d6:	6902                	ld	s2,0(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret
    return -1;
 3dc:	597d                	li	s2,-1
 3de:	bfc5                	j	3ce <stat+0x28>

00000000000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e422                	sd	s0,8(sp)
 3e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e6:	00054603          	lbu	a2,0(a0)
 3ea:	fd06079b          	addiw	a5,a2,-48
 3ee:	0ff7f793          	andi	a5,a5,255
 3f2:	4725                	li	a4,9
 3f4:	02f76963          	bltu	a4,a5,426 <atoi+0x46>
 3f8:	86aa                	mv	a3,a0
  n = 0;
 3fa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3fc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3fe:	0685                	addi	a3,a3,1
 400:	0025179b          	slliw	a5,a0,0x2
 404:	9fa9                	addw	a5,a5,a0
 406:	0017979b          	slliw	a5,a5,0x1
 40a:	9fb1                	addw	a5,a5,a2
 40c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 410:	0006c603          	lbu	a2,0(a3)
 414:	fd06071b          	addiw	a4,a2,-48
 418:	0ff77713          	andi	a4,a4,255
 41c:	fee5f1e3          	bgeu	a1,a4,3fe <atoi+0x1e>
  return n;
}
 420:	6422                	ld	s0,8(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
  n = 0;
 426:	4501                	li	a0,0
 428:	bfe5                	j	420 <atoi+0x40>

000000000000042a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 430:	02b57663          	bgeu	a0,a1,45c <memmove+0x32>
    while(n-- > 0)
 434:	02c05163          	blez	a2,456 <memmove+0x2c>
 438:	fff6079b          	addiw	a5,a2,-1
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	0785                	addi	a5,a5,1
 442:	97aa                	add	a5,a5,a0
  dst = vdst;
 444:	872a                	mv	a4,a0
      *dst++ = *src++;
 446:	0585                	addi	a1,a1,1
 448:	0705                	addi	a4,a4,1
 44a:	fff5c683          	lbu	a3,-1(a1)
 44e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 452:	fee79ae3          	bne	a5,a4,446 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 456:	6422                	ld	s0,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret
    dst += n;
 45c:	00c50733          	add	a4,a0,a2
    src += n;
 460:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 462:	fec05ae3          	blez	a2,456 <memmove+0x2c>
 466:	fff6079b          	addiw	a5,a2,-1
 46a:	1782                	slli	a5,a5,0x20
 46c:	9381                	srli	a5,a5,0x20
 46e:	fff7c793          	not	a5,a5
 472:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 474:	15fd                	addi	a1,a1,-1
 476:	177d                	addi	a4,a4,-1
 478:	0005c683          	lbu	a3,0(a1)
 47c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 480:	fee79ae3          	bne	a5,a4,474 <memmove+0x4a>
 484:	bfc9                	j	456 <memmove+0x2c>

0000000000000486 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 486:	1141                	addi	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48c:	ca05                	beqz	a2,4bc <memcmp+0x36>
 48e:	fff6069b          	addiw	a3,a2,-1
 492:	1682                	slli	a3,a3,0x20
 494:	9281                	srli	a3,a3,0x20
 496:	0685                	addi	a3,a3,1
 498:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49a:	00054783          	lbu	a5,0(a0)
 49e:	0005c703          	lbu	a4,0(a1)
 4a2:	00e79863          	bne	a5,a4,4b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a6:	0505                	addi	a0,a0,1
    p2++;
 4a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4aa:	fed518e3          	bne	a0,a3,49a <memcmp+0x14>
  }
  return 0;
 4ae:	4501                	li	a0,0
 4b0:	a019                	j	4b6 <memcmp+0x30>
      return *p1 - *p2;
 4b2:	40e7853b          	subw	a0,a5,a4
}
 4b6:	6422                	ld	s0,8(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret
  return 0;
 4bc:	4501                	li	a0,0
 4be:	bfe5                	j	4b6 <memcmp+0x30>

00000000000004c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e406                	sd	ra,8(sp)
 4c4:	e022                	sd	s0,0(sp)
 4c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c8:	f63ff0ef          	jal	ra,42a <memmove>
}
 4cc:	60a2                	ld	ra,8(sp)
 4ce:	6402                	ld	s0,0(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret

00000000000004d4 <sbrk>:

char *
sbrk(int n) {
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e406                	sd	ra,8(sp)
 4d8:	e022                	sd	s0,0(sp)
 4da:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4dc:	4585                	li	a1,1
 4de:	0b2000ef          	jal	ra,590 <sys_sbrk>
}
 4e2:	60a2                	ld	ra,8(sp)
 4e4:	6402                	ld	s0,0(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret

00000000000004ea <sbrklazy>:

char *
sbrklazy(int n) {
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4f2:	4589                	li	a1,2
 4f4:	09c000ef          	jal	ra,590 <sys_sbrk>
}
 4f8:	60a2                	ld	ra,8(sp)
 4fa:	6402                	ld	s0,0(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret

0000000000000500 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 500:	4885                	li	a7,1
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <exit>:
.global exit
exit:
 li a7, SYS_exit
 508:	4889                	li	a7,2
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <wait>:
.global wait
wait:
 li a7, SYS_wait
 510:	488d                	li	a7,3
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 518:	4891                	li	a7,4
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <read>:
.global read
read:
 li a7, SYS_read
 520:	4895                	li	a7,5
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <write>:
.global write
write:
 li a7, SYS_write
 528:	48c1                	li	a7,16
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <close>:
.global close
close:
 li a7, SYS_close
 530:	48d5                	li	a7,21
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <kill>:
.global kill
kill:
 li a7, SYS_kill
 538:	4899                	li	a7,6
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <exec>:
.global exec
exec:
 li a7, SYS_exec
 540:	489d                	li	a7,7
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <open>:
.global open
open:
 li a7, SYS_open
 548:	48bd                	li	a7,15
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 550:	48c5                	li	a7,17
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 558:	48c9                	li	a7,18
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 560:	48a1                	li	a7,8
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <link>:
.global link
link:
 li a7, SYS_link
 568:	48cd                	li	a7,19
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 570:	48d1                	li	a7,20
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 578:	48a5                	li	a7,9
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <dup>:
.global dup
dup:
 li a7, SYS_dup
 580:	48a9                	li	a7,10
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 588:	48ad                	li	a7,11
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 590:	48b1                	li	a7,12
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <pause>:
.global pause
pause:
 li a7, SYS_pause
 598:	48b5                	li	a7,13
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a0:	48b9                	li	a7,14
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a8:	1101                	addi	sp,sp,-32
 5aa:	ec06                	sd	ra,24(sp)
 5ac:	e822                	sd	s0,16(sp)
 5ae:	1000                	addi	s0,sp,32
 5b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b4:	4605                	li	a2,1
 5b6:	fef40593          	addi	a1,s0,-17
 5ba:	f6fff0ef          	jal	ra,528 <write>
}
 5be:	60e2                	ld	ra,24(sp)
 5c0:	6442                	ld	s0,16(sp)
 5c2:	6105                	addi	sp,sp,32
 5c4:	8082                	ret

00000000000005c6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5c6:	715d                	addi	sp,sp,-80
 5c8:	e486                	sd	ra,72(sp)
 5ca:	e0a2                	sd	s0,64(sp)
 5cc:	fc26                	sd	s1,56(sp)
 5ce:	f84a                	sd	s2,48(sp)
 5d0:	f44e                	sd	s3,40(sp)
 5d2:	0880                	addi	s0,sp,80
 5d4:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d6:	c299                	beqz	a3,5dc <printint+0x16>
 5d8:	0805c663          	bltz	a1,664 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5dc:	2581                	sext.w	a1,a1
  neg = 0;
 5de:	4881                	li	a7,0
 5e0:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 5e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e6:	2601                	sext.w	a2,a2
 5e8:	00000517          	auipc	a0,0x0
 5ec:	55050513          	addi	a0,a0,1360 # b38 <digits>
 5f0:	883a                	mv	a6,a4
 5f2:	2705                	addiw	a4,a4,1
 5f4:	02c5f7bb          	remuw	a5,a1,a2
 5f8:	1782                	slli	a5,a5,0x20
 5fa:	9381                	srli	a5,a5,0x20
 5fc:	97aa                	add	a5,a5,a0
 5fe:	0007c783          	lbu	a5,0(a5)
 602:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 606:	0005879b          	sext.w	a5,a1
 60a:	02c5d5bb          	divuw	a1,a1,a2
 60e:	0685                	addi	a3,a3,1
 610:	fec7f0e3          	bgeu	a5,a2,5f0 <printint+0x2a>
  if(neg)
 614:	00088b63          	beqz	a7,62a <printint+0x64>
    buf[i++] = '-';
 618:	fd040793          	addi	a5,s0,-48
 61c:	973e                	add	a4,a4,a5
 61e:	02d00793          	li	a5,45
 622:	fef70423          	sb	a5,-24(a4)
 626:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 62a:	02e05663          	blez	a4,656 <printint+0x90>
 62e:	fb840793          	addi	a5,s0,-72
 632:	00e78933          	add	s2,a5,a4
 636:	fff78993          	addi	s3,a5,-1
 63a:	99ba                	add	s3,s3,a4
 63c:	377d                	addiw	a4,a4,-1
 63e:	1702                	slli	a4,a4,0x20
 640:	9301                	srli	a4,a4,0x20
 642:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 646:	fff94583          	lbu	a1,-1(s2)
 64a:	8526                	mv	a0,s1
 64c:	f5dff0ef          	jal	ra,5a8 <putc>
  while(--i >= 0)
 650:	197d                	addi	s2,s2,-1
 652:	ff391ae3          	bne	s2,s3,646 <printint+0x80>
}
 656:	60a6                	ld	ra,72(sp)
 658:	6406                	ld	s0,64(sp)
 65a:	74e2                	ld	s1,56(sp)
 65c:	7942                	ld	s2,48(sp)
 65e:	79a2                	ld	s3,40(sp)
 660:	6161                	addi	sp,sp,80
 662:	8082                	ret
    x = -xx;
 664:	40b005bb          	negw	a1,a1
    neg = 1;
 668:	4885                	li	a7,1
    x = -xx;
 66a:	bf9d                	j	5e0 <printint+0x1a>

000000000000066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66c:	7119                	addi	sp,sp,-128
 66e:	fc86                	sd	ra,120(sp)
 670:	f8a2                	sd	s0,112(sp)
 672:	f4a6                	sd	s1,104(sp)
 674:	f0ca                	sd	s2,96(sp)
 676:	ecce                	sd	s3,88(sp)
 678:	e8d2                	sd	s4,80(sp)
 67a:	e4d6                	sd	s5,72(sp)
 67c:	e0da                	sd	s6,64(sp)
 67e:	fc5e                	sd	s7,56(sp)
 680:	f862                	sd	s8,48(sp)
 682:	f466                	sd	s9,40(sp)
 684:	f06a                	sd	s10,32(sp)
 686:	ec6e                	sd	s11,24(sp)
 688:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68a:	0005c903          	lbu	s2,0(a1)
 68e:	24090c63          	beqz	s2,8e6 <vprintf+0x27a>
 692:	8b2a                	mv	s6,a0
 694:	8a2e                	mv	s4,a1
 696:	8bb2                	mv	s7,a2
  state = 0;
 698:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 69a:	4481                	li	s1,0
 69c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a6:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6aa:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ae:	00000c97          	auipc	s9,0x0
 6b2:	48ac8c93          	addi	s9,s9,1162 # b38 <digits>
 6b6:	a005                	j	6d6 <vprintf+0x6a>
        putc(fd, c0);
 6b8:	85ca                	mv	a1,s2
 6ba:	855a                	mv	a0,s6
 6bc:	eedff0ef          	jal	ra,5a8 <putc>
 6c0:	a019                	j	6c6 <vprintf+0x5a>
    } else if(state == '%'){
 6c2:	03598263          	beq	s3,s5,6e6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6c6:	2485                	addiw	s1,s1,1
 6c8:	8726                	mv	a4,s1
 6ca:	009a07b3          	add	a5,s4,s1
 6ce:	0007c903          	lbu	s2,0(a5)
 6d2:	20090a63          	beqz	s2,8e6 <vprintf+0x27a>
    c0 = fmt[i] & 0xff;
 6d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6da:	fe0994e3          	bnez	s3,6c2 <vprintf+0x56>
      if(c0 == '%'){
 6de:	fd579de3          	bne	a5,s5,6b8 <vprintf+0x4c>
        state = '%';
 6e2:	89be                	mv	s3,a5
 6e4:	b7cd                	j	6c6 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e6:	c3c1                	beqz	a5,766 <vprintf+0xfa>
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f2:	c681                	beqz	a3,6fa <vprintf+0x8e>
 6f4:	9752                	add	a4,a4,s4
 6f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fa:	03878e63          	beq	a5,s8,736 <vprintf+0xca>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	05a78863          	beq	a5,s10,74e <vprintf+0xe2>
      } else if(c0 == 'u'){
 702:	0db78b63          	beq	a5,s11,7d8 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 706:	07800713          	li	a4,120
 70a:	10e78d63          	beq	a5,a4,824 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 70e:	07000713          	li	a4,112
 712:	14e78263          	beq	a5,a4,856 <vprintf+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 716:	06300713          	li	a4,99
 71a:	16e78f63          	beq	a5,a4,898 <vprintf+0x22c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 71e:	07300713          	li	a4,115
 722:	18e78563          	beq	a5,a4,8ac <vprintf+0x240>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 726:	05579063          	bne	a5,s5,766 <vprintf+0xfa>
        putc(fd, '%');
 72a:	85d6                	mv	a1,s5
 72c:	855a                	mv	a0,s6
 72e:	e7bff0ef          	jal	ra,5a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 732:	4981                	li	s3,0
 734:	bf49                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 736:	008b8913          	addi	s2,s7,8
 73a:	4685                	li	a3,1
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	e83ff0ef          	jal	ra,5c6 <printint>
 748:	8bca                	mv	s7,s2
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bfad                	j	6c6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 74e:	03868663          	beq	a3,s8,77a <vprintf+0x10e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 752:	05a68163          	beq	a3,s10,794 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'u'){
 756:	09b68d63          	beq	a3,s11,7f0 <vprintf+0x184>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 75a:	03a68f63          	beq	a3,s10,798 <vprintf+0x12c>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	07800793          	li	a5,120
 762:	0cf68d63          	beq	a3,a5,83c <vprintf+0x1d0>
        putc(fd, '%');
 766:	85d6                	mv	a1,s5
 768:	855a                	mv	a0,s6
 76a:	e3fff0ef          	jal	ra,5a8 <putc>
        putc(fd, c0);
 76e:	85ca                	mv	a1,s2
 770:	855a                	mv	a0,s6
 772:	e37ff0ef          	jal	ra,5a8 <putc>
      state = 0;
 776:	4981                	li	s3,0
 778:	b7b9                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77a:	008b8913          	addi	s2,s7,8
 77e:	4685                	li	a3,1
 780:	4629                	li	a2,10
 782:	000bb583          	ld	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	e3fff0ef          	jal	ra,5c6 <printint>
        i += 1;
 78c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 78e:	8bca                	mv	s7,s2
      state = 0;
 790:	4981                	li	s3,0
        i += 1;
 792:	bf15                	j	6c6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 794:	03860563          	beq	a2,s8,7be <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 798:	07b60963          	beq	a2,s11,80a <vprintf+0x19e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79c:	07800793          	li	a5,120
 7a0:	fcf613e3          	bne	a2,a5,766 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000bb583          	ld	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	e15ff0ef          	jal	ra,5c6 <printint>
        i += 2;
 7b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	b729                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000bb583          	ld	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dfbff0ef          	jal	ra,5c6 <printint>
        i += 2;
 7d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bdc5                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000be583          	lwu	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	de1ff0ef          	jal	ra,5c6 <printint>
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bde1                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000bb583          	ld	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	dc9ff0ef          	jal	ra,5c6 <printint>
        i += 1;
 802:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	bd7d                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000bb583          	ld	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	dafff0ef          	jal	ra,5c6 <printint>
        i += 2;
 81c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
        i += 2;
 822:	b555                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 824:	008b8913          	addi	s2,s7,8
 828:	4681                	li	a3,0
 82a:	4641                	li	a2,16
 82c:	000be583          	lwu	a1,0(s7)
 830:	855a                	mv	a0,s6
 832:	d95ff0ef          	jal	ra,5c6 <printint>
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	b571                	j	6c6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83c:	008b8913          	addi	s2,s7,8
 840:	4681                	li	a3,0
 842:	4641                	li	a2,16
 844:	000bb583          	ld	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d7dff0ef          	jal	ra,5c6 <printint>
        i += 1;
 84e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
        i += 1;
 854:	bd8d                	j	6c6 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 856:	008b8793          	addi	a5,s7,8
 85a:	f8f43423          	sd	a5,-120(s0)
 85e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 862:	03000593          	li	a1,48
 866:	855a                	mv	a0,s6
 868:	d41ff0ef          	jal	ra,5a8 <putc>
  putc(fd, 'x');
 86c:	07800593          	li	a1,120
 870:	855a                	mv	a0,s6
 872:	d37ff0ef          	jal	ra,5a8 <putc>
 876:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 878:	03c9d793          	srli	a5,s3,0x3c
 87c:	97e6                	add	a5,a5,s9
 87e:	0007c583          	lbu	a1,0(a5)
 882:	855a                	mv	a0,s6
 884:	d25ff0ef          	jal	ra,5a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 888:	0992                	slli	s3,s3,0x4
 88a:	397d                	addiw	s2,s2,-1
 88c:	fe0916e3          	bnez	s2,878 <vprintf+0x20c>
        printptr(fd, va_arg(ap, uint64));
 890:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 894:	4981                	li	s3,0
 896:	bd05                	j	6c6 <vprintf+0x5a>
        putc(fd, va_arg(ap, uint32));
 898:	008b8913          	addi	s2,s7,8
 89c:	000bc583          	lbu	a1,0(s7)
 8a0:	855a                	mv	a0,s6
 8a2:	d07ff0ef          	jal	ra,5a8 <putc>
 8a6:	8bca                	mv	s7,s2
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bd31                	j	6c6 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 8ac:	008b8993          	addi	s3,s7,8
 8b0:	000bb903          	ld	s2,0(s7)
 8b4:	00090f63          	beqz	s2,8d2 <vprintf+0x266>
        for(; *s; s++)
 8b8:	00094583          	lbu	a1,0(s2)
 8bc:	c195                	beqz	a1,8e0 <vprintf+0x274>
          putc(fd, *s);
 8be:	855a                	mv	a0,s6
 8c0:	ce9ff0ef          	jal	ra,5a8 <putc>
        for(; *s; s++)
 8c4:	0905                	addi	s2,s2,1
 8c6:	00094583          	lbu	a1,0(s2)
 8ca:	f9f5                	bnez	a1,8be <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8cc:	8bce                	mv	s7,s3
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	bbdd                	j	6c6 <vprintf+0x5a>
          s = "(null)";
 8d2:	00000917          	auipc	s2,0x0
 8d6:	25e90913          	addi	s2,s2,606 # b30 <malloc+0x148>
        for(; *s; s++)
 8da:	02800593          	li	a1,40
 8de:	b7c5                	j	8be <vprintf+0x252>
        if((s = va_arg(ap, char*)) == 0)
 8e0:	8bce                	mv	s7,s3
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b3cd                	j	6c6 <vprintf+0x5a>
    }
  }
}
 8e6:	70e6                	ld	ra,120(sp)
 8e8:	7446                	ld	s0,112(sp)
 8ea:	74a6                	ld	s1,104(sp)
 8ec:	7906                	ld	s2,96(sp)
 8ee:	69e6                	ld	s3,88(sp)
 8f0:	6a46                	ld	s4,80(sp)
 8f2:	6aa6                	ld	s5,72(sp)
 8f4:	6b06                	ld	s6,64(sp)
 8f6:	7be2                	ld	s7,56(sp)
 8f8:	7c42                	ld	s8,48(sp)
 8fa:	7ca2                	ld	s9,40(sp)
 8fc:	7d02                	ld	s10,32(sp)
 8fe:	6de2                	ld	s11,24(sp)
 900:	6109                	addi	sp,sp,128
 902:	8082                	ret

0000000000000904 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 904:	715d                	addi	sp,sp,-80
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	e010                	sd	a2,0(s0)
 90e:	e414                	sd	a3,8(s0)
 910:	e818                	sd	a4,16(s0)
 912:	ec1c                	sd	a5,24(s0)
 914:	03043023          	sd	a6,32(s0)
 918:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 920:	8622                	mv	a2,s0
 922:	d4bff0ef          	jal	ra,66c <vprintf>
}
 926:	60e2                	ld	ra,24(sp)
 928:	6442                	ld	s0,16(sp)
 92a:	6161                	addi	sp,sp,80
 92c:	8082                	ret

000000000000092e <printf>:

void
printf(const char *fmt, ...)
{
 92e:	711d                	addi	sp,sp,-96
 930:	ec06                	sd	ra,24(sp)
 932:	e822                	sd	s0,16(sp)
 934:	1000                	addi	s0,sp,32
 936:	e40c                	sd	a1,8(s0)
 938:	e810                	sd	a2,16(s0)
 93a:	ec14                	sd	a3,24(s0)
 93c:	f018                	sd	a4,32(s0)
 93e:	f41c                	sd	a5,40(s0)
 940:	03043823          	sd	a6,48(s0)
 944:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 948:	00840613          	addi	a2,s0,8
 94c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 950:	85aa                	mv	a1,a0
 952:	4505                	li	a0,1
 954:	d19ff0ef          	jal	ra,66c <vprintf>
}
 958:	60e2                	ld	ra,24(sp)
 95a:	6442                	ld	s0,16(sp)
 95c:	6125                	addi	sp,sp,96
 95e:	8082                	ret

0000000000000960 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 960:	1141                	addi	sp,sp,-16
 962:	e422                	sd	s0,8(sp)
 964:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 966:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96a:	00000797          	auipc	a5,0x0
 96e:	6967b783          	ld	a5,1686(a5) # 1000 <freep>
 972:	a805                	j	9a2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 974:	4618                	lw	a4,8(a2)
 976:	9db9                	addw	a1,a1,a4
 978:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97c:	6398                	ld	a4,0(a5)
 97e:	6318                	ld	a4,0(a4)
 980:	fee53823          	sd	a4,-16(a0)
 984:	a091                	j	9c8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 986:	ff852703          	lw	a4,-8(a0)
 98a:	9e39                	addw	a2,a2,a4
 98c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 98e:	ff053703          	ld	a4,-16(a0)
 992:	e398                	sd	a4,0(a5)
 994:	a099                	j	9da <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	6398                	ld	a4,0(a5)
 998:	00e7e463          	bltu	a5,a4,9a0 <free+0x40>
 99c:	00e6ea63          	bltu	a3,a4,9b0 <free+0x50>
{
 9a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	fed7fae3          	bgeu	a5,a3,996 <free+0x36>
 9a6:	6398                	ld	a4,0(a5)
 9a8:	00e6e463          	bltu	a3,a4,9b0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ac:	fee7eae3          	bltu	a5,a4,9a0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9b0:	ff852583          	lw	a1,-8(a0)
 9b4:	6390                	ld	a2,0(a5)
 9b6:	02059713          	slli	a4,a1,0x20
 9ba:	9301                	srli	a4,a4,0x20
 9bc:	0712                	slli	a4,a4,0x4
 9be:	9736                	add	a4,a4,a3
 9c0:	fae60ae3          	beq	a2,a4,974 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c8:	4790                	lw	a2,8(a5)
 9ca:	02061713          	slli	a4,a2,0x20
 9ce:	9301                	srli	a4,a4,0x20
 9d0:	0712                	slli	a4,a4,0x4
 9d2:	973e                	add	a4,a4,a5
 9d4:	fae689e3          	beq	a3,a4,986 <free+0x26>
  } else
    p->s.ptr = bp;
 9d8:	e394                	sd	a3,0(a5)
  freep = p;
 9da:	00000717          	auipc	a4,0x0
 9de:	62f73323          	sd	a5,1574(a4) # 1000 <freep>
}
 9e2:	6422                	ld	s0,8(sp)
 9e4:	0141                	addi	sp,sp,16
 9e6:	8082                	ret

00000000000009e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e8:	7139                	addi	sp,sp,-64
 9ea:	fc06                	sd	ra,56(sp)
 9ec:	f822                	sd	s0,48(sp)
 9ee:	f426                	sd	s1,40(sp)
 9f0:	f04a                	sd	s2,32(sp)
 9f2:	ec4e                	sd	s3,24(sp)
 9f4:	e852                	sd	s4,16(sp)
 9f6:	e456                	sd	s5,8(sp)
 9f8:	e05a                	sd	s6,0(sp)
 9fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fc:	02051493          	slli	s1,a0,0x20
 a00:	9081                	srli	s1,s1,0x20
 a02:	04bd                	addi	s1,s1,15
 a04:	8091                	srli	s1,s1,0x4
 a06:	0014899b          	addiw	s3,s1,1
 a0a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a0c:	00000517          	auipc	a0,0x0
 a10:	5f453503          	ld	a0,1524(a0) # 1000 <freep>
 a14:	c515                	beqz	a0,a40 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a18:	4798                	lw	a4,8(a5)
 a1a:	02977f63          	bgeu	a4,s1,a58 <malloc+0x70>
 a1e:	8a4e                	mv	s4,s3
 a20:	0009871b          	sext.w	a4,s3
 a24:	6685                	lui	a3,0x1
 a26:	00d77363          	bgeu	a4,a3,a2c <malloc+0x44>
 a2a:	6a05                	lui	s4,0x1
 a2c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a30:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a34:	00000917          	auipc	s2,0x0
 a38:	5cc90913          	addi	s2,s2,1484 # 1000 <freep>
  if(p == SBRK_ERROR)
 a3c:	5afd                	li	s5,-1
 a3e:	a0bd                	j	aac <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a40:	00000797          	auipc	a5,0x0
 a44:	5e078793          	addi	a5,a5,1504 # 1020 <base>
 a48:	00000717          	auipc	a4,0x0
 a4c:	5af73c23          	sd	a5,1464(a4) # 1000 <freep>
 a50:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a52:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a56:	b7e1                	j	a1e <malloc+0x36>
      if(p->s.size == nunits)
 a58:	02e48b63          	beq	s1,a4,a8e <malloc+0xa6>
        p->s.size -= nunits;
 a5c:	4137073b          	subw	a4,a4,s3
 a60:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a62:	1702                	slli	a4,a4,0x20
 a64:	9301                	srli	a4,a4,0x20
 a66:	0712                	slli	a4,a4,0x4
 a68:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a6a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6e:	00000717          	auipc	a4,0x0
 a72:	58a73923          	sd	a0,1426(a4) # 1000 <freep>
      return (void*)(p + 1);
 a76:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a7a:	70e2                	ld	ra,56(sp)
 a7c:	7442                	ld	s0,48(sp)
 a7e:	74a2                	ld	s1,40(sp)
 a80:	7902                	ld	s2,32(sp)
 a82:	69e2                	ld	s3,24(sp)
 a84:	6a42                	ld	s4,16(sp)
 a86:	6aa2                	ld	s5,8(sp)
 a88:	6b02                	ld	s6,0(sp)
 a8a:	6121                	addi	sp,sp,64
 a8c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a8e:	6398                	ld	a4,0(a5)
 a90:	e118                	sd	a4,0(a0)
 a92:	bff1                	j	a6e <malloc+0x86>
  hp->s.size = nu;
 a94:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a98:	0541                	addi	a0,a0,16
 a9a:	ec7ff0ef          	jal	ra,960 <free>
  return freep;
 a9e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa2:	dd61                	beqz	a0,a7a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa6:	4798                	lw	a4,8(a5)
 aa8:	fa9778e3          	bgeu	a4,s1,a58 <malloc+0x70>
    if(p == freep)
 aac:	00093703          	ld	a4,0(s2)
 ab0:	853e                	mv	a0,a5
 ab2:	fef719e3          	bne	a4,a5,aa4 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 ab6:	8552                	mv	a0,s4
 ab8:	a1dff0ef          	jal	ra,4d4 <sbrk>
  if(p == SBRK_ERROR)
 abc:	fd551ce3          	bne	a0,s5,a94 <malloc+0xac>
        return 0;
 ac0:	4501                	li	a0,0
 ac2:	bf65                	j	a7a <malloc+0x92>
