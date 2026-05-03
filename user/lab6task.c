#include "kernel/types.h"
#include "user/user.h"

int main(){
    int p[2];
    char buf[100];
    char *msg = "child says hi";


    if(pipe(p) < 0){
        printf("Pipe Failed\n");
        exit(1);
    }

   printf("We're in Parent process\n");

   int pid = fork();

    if(pid < 0){
        printf("Fork Failed");
        exit(1);
    }

    if(pid == 0){
        printf("child send msg to parent\n");
        close(p[0]);
        write(p[1], msg, strlen(msg));
        close(p[1]);
        exit(0);
    }
    else {
        close(p[1]);
        int n = read(p[0], buf, sizeof(buf));

        write(1, "Parent Recieved: ",17);
        write(1, buf, n);
        write(1,"\n", 1);

        close(p[0]);
        wait(0);
    }

    exit(0);
}
