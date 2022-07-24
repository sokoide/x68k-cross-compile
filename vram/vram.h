#ifndef __VRAM_H__
#define __VRAM_H__

// Macro taken from https://sourceforge.net/projects/x68000-doom/
// Merge 3x 8bit values to 15bit + intensity in GRB format
// Keep only the 5 msb of each value
#define rgb888_2grb(r, g, b, i)                                                \
  (((b & 0xF8) >> 2) | ((g & 0xF8) << 8) | ((r & 0xF8) << 3) | i)

// Merge 3x 8bit values to 15bit + intensity in RGB format
// Keep only the 5 msb of each value
#define rgb888_2rgb(r, g, b, i)                                                \
  (((r & 0xF8) << 8) | ((g & 0xF8) << 3) | ((b & 0xF8) >> 2) | i)

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

void clear_vram(unsigned short page);
void fill_vram(unsigned short page);
void init_palette();
void scroll();

// globals
extern CRTC_REG scroll_data;

// IO ports
extern volatile char *mfp;
extern volatile CRTC_REG *crtc;

// vram address per page in 256x256 mode (2 pages)
extern const unsigned short *vram0;
extern const unsigned short *vram1;

#endif
