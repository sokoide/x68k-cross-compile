#include "vram.h"

#pragma warning disable format
#include <x68k/iocs.h>
#pragma warning restore format

int main();

int main() {
  /* B_SUPER(0); // enter supervisor mode */
  _iocs_b_super(0); // enter supervisor mode

  // init
  _iocs_crtmod(10); // 256x256 dots, 256 colors, 2 graphic screens, 2 BG screens
  _iocs_g_clr_on(); // clear graphics, reset palette to the default, access page 0
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

    scroll();
  }

  // uninit
  _iocs_crtmod(16); // 758x512 dots, 16 colors, 1 screen
  _iocs_g_clr_on(); // clear graphics, reset palette to the default, access page 0
  _iocs_g_clr_on(); // clear graphics, reset palette to the default, access page 0
  _iocs_b_super(1); // leave supervisor mode
  return 0;
}
