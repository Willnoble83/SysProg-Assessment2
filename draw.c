#include "types.h"
#include "user.h"

int main()
{
    videomodevga();
    ClearScreen(320,200,50);
    printf(1,"Done\n");
    exit();
}

int ClearScreen(int width, int height, int colour)
{
    for (int x = 0; x < width; x++)
    {
        //printf(1,"%d- Draw\n", x);
        for (int y = 0; y < height; y++)
        {

            setspecificpixel(x,y,colour);
        }
    }
    return 0;
}