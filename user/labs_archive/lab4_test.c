#include "kernel/types.h"
#include "user/user.h"

int main(void) {
  printf("Lab 4: Starting the detective work...\n");

  int x = 42;
  int y = 2;

  printf("Attempting to divide %d by %d...\n", x, y);

  // BUG: this will cause a hw trap
  int result = x / y;

  printf("the result is: %d\n", result);

  exit(0);
}
