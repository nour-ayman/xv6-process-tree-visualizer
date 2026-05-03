#include <kernel/types.h>
#include <user/user.h>

// el function elly el threads hat-run feha
void *worker(void *arg) {
    int id = *(int *)arg;
    printf("Hello! I am thread number: %d\n", id);
    exit(0);
}

int main() {
    int thread_ids[5];
    void *stack;

    for (int i = 0; i < 5; i++) {
        thread_ids[i] = i;

	stack = malloc(4096);
	if (stack ==0) {
	    printf("Malloc failed\n");
	    exit(1);
	}

	int pid = thread_create(worker, &thread_ids[i], stack);

	if (pid < 0) {
	    printf("Error: unable to create thread, %d\n", i);
	}
    }


    for (int i = 0; i < 5; i++) {
	wait(0);
    }

    printf("Main thread finished.\n");
    exit(0);
}

