#include "types.h"
#include "user.h"

int main()
{
    videomodevga();
    ClearScreen(320,200, 0);
    for(int i = 1; i < 31; i++)
    {
        DrawLine(i*10, 10, i*10, 190, 1);
    }
    printf(1, "Done!\n");
    getch();
    videomodetext();
    exit();
}

long abs(long value)
{
    if(value < 0)
    {
        return 0-value;
    }
    else {
        return value;
    }
}

int ClearScreen(int width, int height, int colour)
{
    //printf(1,"%d,%d,%d",width,height,colour);
    for (int x = 0; x < width; x++)
    {
        for (int y = 0; y < height; y++)
        {
            
            setspecificpixel(x,y,colour);
        }
    }
    return 0;
}

void DrawLine(int x0, int y0, int x1, int y1, int c) 
{
//find absolute values and use them to find the delta
  int dx = abs(x1-x0), sx = x0<x1 ? 1 : -1;
  int dy = abs(y1-y0), sy = y0<y1 ? 1 : -1; 
  int err = (dx>dy ? dx : -dy)/2, e2;
 
  for(;;) //while true
  {
    setspecificpixel(x0,y0, c);

    if (x0==x1 && y0==y1) break;
    e2 = err;

    if (e2 < dy) 
    { 
        err += dx; 
        y0 += sy; 
    }
    if (e2 >-dx) 
    { 
        err -= dy; 
        x0 += sx; 
    }

  }
}