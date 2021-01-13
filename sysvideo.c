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
    return 0;
}
int sys_videomodetext(void)
{
    consolevgamode(0x03);
    return 0;
}
int sys_setpixel(int pos_x, int pos_y, int VGA_COLOR)
{
    
    //unsigned char* location = (unsigned char*)0xA0000 + 320 * pos_y + pos_x;
    //*location = VGA_COLOR;
    return 0;
}
//int pos_x, int pos_y, unsigned char VGA_COLOR
int sys_setspecificpixel(int x, int y, int VGA_colour)
{
    sys_setpixel(x,y,VGA_colour);
    return 0;
}

// TODO: Implement your system call for switching video modes (and any other video-related syscalls)
// in here.
