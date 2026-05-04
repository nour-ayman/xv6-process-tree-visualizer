#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* 
 * NOTE FOR THE TEAM: 
 * The following 'proc_info' struct and 'mock_procs' array are DUMMY DATA.
 * They are used to test the Tree Rendering Logic (Task 2) independently.
 * Once the Kernel System Call is ready, we will replace this with real data.
 */

struct proc_info {
    int pid;
    int ppid;
    char name[16];
};

// Mock data to simulate the Xv6 process table
struct proc_info mock_procs[] = {
    {1, 0, "init"},
    {2, 1, "sh"},
    {3, 2, "pstree"},
    {4, 1, "sh"},
    {5, 4, "test_proc"}
};

int num_procs = 5;

// Function to render the tree (Recursive Algorithm)
void print_tree(int parent_id, int level) {
    for (int i = 0; i < num_procs; i++) {
        if (mock_procs[i].ppid == parent_id) {
            
            // Indentation based on depth level
            for (int j = 0; j < level; j++) {
                printf("    "); 
            }

            // Visual branch formatting
            if (level > 0) {
                printf("|-- "); 
            }

            printf("%s (%d)\n", mock_procs[i].name, mock_procs[i].pid);

            // Recursion to find child processes
            print_tree(mock_procs[i].pid, level + 1);
        }
    }
}

int main(int argc, char *argv[]) {
    printf("--- Xv6 Process Tree (UI Rendering Test) ---\n");
    
    // Start recursion with parent PID 0 (root)
    print_tree(0, 0);

    exit(0);
}
