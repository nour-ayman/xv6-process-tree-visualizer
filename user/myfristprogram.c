#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if(argc < 2){
      fprintf(2, "Usage: myfristprogram <ticks>\n");
      exit(1);
    }

    int ticks = atoi(argv[1]);

    printf("myfristprogram: sleeping for %d ticks...\n", ticks);

    sleep(ticks);

    printf("myfristprogram: i am awake now!\n");

    exit(0);
}
