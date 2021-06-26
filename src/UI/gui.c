#include "../INC/gui.h"

void gui()
{
    isr_install();
    wall1();
    set_screen_color(0,7);
    launch_shell(0);
}

