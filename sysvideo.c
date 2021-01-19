#include "types.h"
#include "defs.h"

int sys_getch(void) {
    return consoleget();
}

int sys_greeting(void)
{
    cprintf("Hello, user\n");

    return 0;
}

int sys_videomodevga(void)
{
    consolevgamode(0x13);
    cprintf("VGA Mode Set to 0x13\n");
    return 0;
}
int sys_videomodetext(void)
{
    cprintf("VGA Mode Set to 0x03\n");
    consolevgamode(0x03);
    return 0;
}

//int x, int y, unsigned char VGA_colour
int sys_setspecificpixel(void)
{
    int x;
    int y;
    int VGA_colour;
    argint(2, &VGA_colour);
    argint(1, &y);
    argint(0, &x);

    setpixel(x,y,VGA_colour);
    return 0;
}

// TODO: Implement your system call for switching video modes (and any other video-related syscalls)
// in here.
