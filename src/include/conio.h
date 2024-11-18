#include <termios.h>
#include <unistd.h>
#include <stdio.h>


/* reads from keypress, doesn't echo */
int getch(void);
/* reads from keypress, echoes */
int getche(void);