#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
  int p[2];
  char buf[50];

  if(pipe(p) < 0){
    printf("pipe failed\n");
    exit(1);
  }

  if(fork() == 0) {
    close(p[0]);
    printf("Child: sending message to parent...\n");
    write(p[1]," Hello from your child!", 23);
    close(p[1]);
    exit(0);
  } else {
    close(p[1]);
    read(p[0], buf,sizeof(buf));
    printf("Parent: Received message: %s\n", buf);
    close(p[0]);
    wait(0);
    exit(0);
  }
}
