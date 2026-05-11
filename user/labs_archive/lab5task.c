#include "kernel/types.h"
#include "user/user.h"



int main() {
    int pid;

    pid = fork(); //betaaml child process

    if (pid < 0) {
        printf("Fork failed!\n");
        exit(1);
    }

    if (pid == 0) {
        // ehna gowa el far3 el gded (child process)
        printf("we're inside the child process\n");

        char *argv[] = {"echo", "Child says Hi",0};

        exec("echo", argv);
    }
    else {
      //we're inside parent
       wait(0);

      printf("Parent:thank u child\n");
    }


    exit(0);
}
