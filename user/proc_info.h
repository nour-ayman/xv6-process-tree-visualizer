// Structure to hold process data sent from the kernel
// This matches the data needed to build the tree
struct proc_info {
    int pid;        // Process ID
    int ppid;       // Parent Process ID
    char name[16];  // Process Name
};
