#include "vram.h"
#include <stdio.h>
#include <stdlib.h>

#pragma warning disable format
#include <iocslib.h>
#pragma warning restore format

// vram address per page in 256x256 mode (2 pages)
const unsigned short *vram0 = (unsigned short *)0xc00000;
const unsigned short *vram1 = (unsigned short *)0xc80000;

void clear_vram(unsigned short page) {
  unsigned short *p = (unsigned short *)vram0;
  p = p + (0x80000 / 2 * page);
  unsigned short *limit = p + 0x80000 / 2;

  while (p < limit) {
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
    *p++ = 0;
  }
}

void fill_vram(unsigned short page) {
  unsigned short *p = (unsigned short *)vram0;
  p = p + (0x80000 / 2 * page);
  unsigned short *limit = p + 0x80000 / 2;

  unsigned char color = 127 * page + 1;
  while (p < limit) {
    // draw first 256 dots of the line
    for (int i = 0; i < 256; i++) {
      *p++ = color;
    }
    // skip the right half
    p += 0x100;
    color += 1;
    if (color > (127 * (page + 1)))
      color = 127 * page + 1;
  }
}

void init_palette() {
  GPALET(0, 0);

  int i = 1;
  for (int j = 1; j < 64; j++) {
    GPALET(i, rgb888_2grb(j * 4, j * 4, j * 4, 0));
    /* GPALET(i, 0); */
    i++;
  }
  for (int j = 0; j < 64; j++) {
    GPALET(i, rgb888_2grb(j * 4, 0, 0, 0));
    i++;
  }
  for (int j = 0; j < 64; j++) {
    GPALET(i, rgb888_2grb(0, j * 4, 0, 0));
    i++;
  }
  for (int j = 0; j < 64; j++) {
    GPALET(i, rgb888_2grb(0, 0, j * 4, 0));
    i++;
  }
}

typedef struct {
  short sc0_x_reg;
  short sc0_y_reg;
  short sc1_x_reg;
  short sc1_y_reg;
  short sc2_x_reg;
  short sc2_y_reg;
  short sc3_x_reg;
  short sc3_y_reg;
} CRTC_REG;

static CRTC_REG scroll_data;

static void scroll() {
  CRTC_REG *crtc = (CRTC_REG *)0xe80018;

  // screen 0
  scroll_data.sc0_y_reg -= 1;
  scroll_data.sc1_y_reg -= 1;
  scroll_data.sc0_x_reg -= 1;
  scroll_data.sc1_x_reg -= 1;

  // screen 1
  scroll_data.sc2_y_reg += 1;
  scroll_data.sc3_y_reg += 1;

  *crtc = scroll_data;
}

int main() {
  char volatile *mfp = (char *)0xe88001;

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
