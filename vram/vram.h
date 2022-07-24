#pragma once

// Macro taken from https://sourceforge.net/projects/x68000-doom/
// Merge 3x 8bit values to 15bit + intensity in GRB format
// Keep only the 5 msb of each value
#define rgb888_2grb(r, g, b, i)                                                \
  (((b & 0xF8) >> 2) | ((g & 0xF8) << 8) | ((r & 0xF8) << 3) | i)

// Merge 3x 8bit values to 15bit + intensity in RGB format
// Keep only the 5 msb of each value
#define rgb888_2rgb(r, g, b, i)                                                \
  (((r & 0xF8) << 8) | ((g & 0xF8) << 3) | ((b & 0xF8) >> 2) | i)

void clear_vram(unsigned short page);
void fill_vram(unsigned short page);
void init_palette();
