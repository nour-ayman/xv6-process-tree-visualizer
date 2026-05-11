#include "kernel/types.h"
#include "user/user.h"
#include "proc_info.h"

#define MAX_PROC 64

// Function to print the tree using recursion
void print_tree(struct proc_info *procs, int num_procs, int parent_pid, int depth) {
    for (int i = 0; i < num_procs; i++) {
        // Check if this process belongs to the current parent
        if (procs[i].ppid == parent_pid) {
            
            // Print 4 spaces for each level of depth
            for (int j = 0; j < depth; j++) {
                printf("    ");
            }

            // Print the branch and process info
            if (depth > 0) {
                printf("|-- %s (%d)\n", procs[i].name, procs[i].pid);
            } else {
                printf("%s (%d)\n", procs[i].name, procs[i].pid);
            }

            // Look for children of this process
            print_tree(procs, num_procs, procs[i].pid, depth + 1);
        }
    }
}

int main(int argc, char *argv[]) {
    struct proc_info procs[MAX_PROC];
    int n;

    // TODO: Replace this block with the real syscall later
    // n = getproctree(procs); 

    // Fake data to test the logic
    n = 5;
    procs[0] = (struct proc_info){1, 0, "init"};
    procs[1] = (struct proc_info){2, 1, "sh"};
    procs[2] = (struct proc_info){3, 1, "other"};
    procs[3] = (struct proc_info){4, 2, "pstree"};
    procs[4] = (struct proc_info){5, 2, "grep"};

    if (n < 0) {
        printf("Error getting process data\n");
        exit(1);
    }

    // Start printing from the top of the tree
    print_tree(procs, n, 0, 0);

    exit(0);
}
