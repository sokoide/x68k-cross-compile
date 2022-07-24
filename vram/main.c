#include "vram.h"

#pragma warning disable format
#include <iocslib.h>
#pragma warning restore format

int main();

int main() {
  B_SUPER(0); // enter supervisor mode

  // init
  CRTMOD(10); // 256x256 dots, 256 colors, 2 graphic screens, 2 BG screens
  G_CLR_ON(); // clear graphics, reset palette to the default, access page 0
  B_CUROFF(); // stop cursor
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
  CRTMOD(16); // 758x512 dots, 16 colors, 1 screen
  G_CLR_ON(); // clear graphics, reset palette to the default, access page 0
  B_CURON();  // start cursor
  B_SUPER(1); // leave supervisor mode
  return 0;
}
