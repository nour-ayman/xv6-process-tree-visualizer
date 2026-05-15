# Xv6 Process Tree Visualizer (pstree)

## 1. Project Overview
The **Xv6 Process Tree Visualizer** is a system utility designed to provide a hierarchical view of all active processes within the Xv6 operating system. While Xv6 natively provides a basic list of processes, it lacks a way to visualize the parent-child relationships established via the `fork()` system call.

This project implements a new system call to extract process metadata from the kernel and a user-level application to render this data as an intuitive, tree-like structure (similar to the Linux `pstree` command).

## 2. Problem Statement
In Operating Systems, processes are organized in a tree structure where each process (except the initial one) has a parent. Understanding this hierarchy is crucial for managing process lifecycles, identifying orphaned processes, and debugging system behavior. Our goal is to bridge the gap between low-level kernel data and high-level visualization.

## 3. Technical Approach
The implementation is divided into three main layers:
* **Kernel Layer:** Accessing the `proc` table in `kernel/proc.c` to traverse the process list and identify parent-child links.
* **System Call Layer:** Implementing a custom system call `getproctree` to securely copy process information from kernel space to user space.
* **User Layer:** Developing a C application that uses a recursive algorithm (Depth-First Search) to format and display the tree on the terminal using ASCII characters.

## 4. Team Roles & Responsibilities
To ensure high design quality and functionality, the team is organized into the following roles:

| Role | Responsibility | Key Files | Assigned To |
| :--- | :--- | :--- | :--- |
| **Kernel Architect** | Modifying `proc.h` and managing kernel-side process table structures. | `kernel/proc.h`, `kernel/defs.h` | *Ahmed Medhat* |
| **System Call Engineer (A)** | **The Syscall Registrar:** Defining syscall interfaces, ID mapping, and Assembly traps. | `kernel/syscall.h`, `kernel/syscall.c`, `user/usys.pl` | *Omar Walid* |
| **System Call Engineer (B)** | **The Syscall Boundary Guard:** Managing memory argument retrieval, pointer safety, and kernel boundaries. | `kernel/sysproc.c` | *Seif Hashem* |
| **Algorithm Specialist** | Implementing the core data-traversal logic inside the kernel to collect process info. | `kernel/proc.c`, `user/ulib.c` | **Farag** |
| **UI/CLI Developer** | Crafting the terminal output format, depth tracking, and recursive indentation logic. | `user/pstree.c`, `user/user.h` | **Wezza** |

## 5. Workflow & Branching Strategy
To ensure smooth collaboration, each team member must work on a dedicated Git branch named after their role.

### Steps for each member:
1. **Clone the Repo:** Ensure you have the latest version of the `xv6-labs-2025` source code.
2. **Create your Branch:** Run `git checkout -b [role-name]` (e.g., `git checkout -b kernel-architect`).
3. **Work & Commit:** Use `git status` to monitor changes and `git commit -a -m "description"` to record updates.
4. **Push:** Use `git push origin [role-name]` to share progress without affecting the main code.

**Branch Names:** `kernel-architect`, `syscall-engineer`, `algorithm-specialist`, `ui-cli-developer`, `devops-qa`.

## 6. Project Management & Backlog
To maintain an organized workflow, we use a **Product Backlog**. Each team member is responsible for tracking their tasks and updating their progress in the shared repository (e.g., using a `BACKLOG.md` file or GitHub Projects).

### Backlog by Role:

#### 🟢 Kernel Architect
- [ ] Explore `kernel/proc.h` and the `proc` structure.
- [ ] Implement a function to traverse the `proc` table and collect active process data.
- [ ] Define the data structure to hold process info (PID, PPID, Name) to be sent to User space.

#### 🔵 System Call Engineer
- [ ] Assign a syscall number in `kernel/syscall.h`.
- [ ] Implement `sys_getproctree` in `kernel/sysproc.c`.
- [ ] Use `copyout` to safely transfer data to the User space.
- [ ] Add the syscall interface to `user/user.h`.

#### 🟡 Algorithm Specialist
- [ ] Design the logic to reconstruct the tree hierarchy from a flat list of processes.
- [ ] Implement a Depth-First Search (DFS) or recursive function to handle parent-child nesting.
- [ ] Handle edge cases like "Orphan" processes or empty tables.

#### 🟠 UI/CLI Developer (Wezza)
- [ ] Create `user/pstree.c` and integrate it into the `Makefile`.
- [ ] Develop the terminal rendering logic (using `|--` and `\t` for indentation).
- [ ] Ensure the output is clean and visually intuitive as per the project goals.

> [!WARNING]  
> **Team Note:** This backlog covers all functional requirements as outlined in the project guidelines. Completion of these tasks is mandatory for a functional project. Any additional features implemented beyond this scope are considered elective enhancements for project excellence

## 7. Development Guidelines
* **Version Control:** Mandatory use of Git for collaboration.
* **Coding Standards:** Clean, documented C code following Xv6 conventions.
* **Testing:** Verification of the tree structure under various process loads.
