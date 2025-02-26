#include "vram.h"
#include <stdio.h>

#pragma warning disable format
#include <x68k/dos.h>
#include <x68k/iocs.h>
#pragma warning restore format

#define B_SUPER 0x81

int main();

int main() {
    char c;

    int ssp = _iocs_b_super(0); // enter supervisor mode

    // init
    _iocs_crtmod(
        10); // 256x256 dots, 256 colors, 2 graphic screens, 2 BG screens
    _iocs_g_clr_on(); // clear graphics, reset palette to the default, access
                      // page 0
    _iocs_b_curoff(); // stop cursor
    init_palette();

    fill_vram(0);
    fill_vram(1);

    while (1) {
        // if it's vsync, wait for display period
        while (!((*mfp) & 0x10))
            ;
        // wait for vsync
        while ((*mfp) & 0x10)
            ;

        c = _iocs_b_keysns();
        if (c) {
            break;
        }
        scroll();
    }

    // uninit
    _iocs_b_curon();  // enable cursor
    _iocs_g_clr_on(); // clear graphics, reset palette to the default, access
                      // page 0
    _iocs_crtmod(16); // 758x512 dots, 16 colors, 1 screen

    _iocs_b_super(ssp);

    printf("Key %c pressed\n", c);
    return 0;
}
