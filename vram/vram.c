#include "vram.h"
#include <stdio.h>
#include <stdlib.h>

#pragma warning disable format
#include <x68k/iocs.h>
#pragma warning restore format

// globals
CRTC_REG scroll_data;

// IO ports
volatile char* mfp = (char*)0xe88001;
volatile CRTC_REG* crtc = (CRTC_REG*)0xe80018;

// vram address per page in 256x256 mode (2 pages)
const unsigned short* vram0 = (unsigned short*)0xc00000;
const unsigned short* vram1 = (unsigned short*)0xc80000;

__attribute__((optimize("no-unroll-loops")))
void
clear_vram(unsigned short page) {
    unsigned short* p = (unsigned short*)vram0;
    p = p + (0x80000 / 2 * page);
    unsigned short* limit = p + 0x80000 / 2;

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
    unsigned short* p = (unsigned short*)vram0;
    p = p + (0x80000 / 2 * page);
    unsigned short* limit = p + 0x80000 / 2;

    unsigned char color = 127 * page + 1;
    while (p < limit) {
        // draw first 256 dots of the line
        int i;
        for (i = 0; i < 256; i++) {
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
    _iocs_gpalet(0, 0);

    for (int i = 1; i < 256; i++) {
        int j = i % 64;
        switch (i / 64) {
        case 0:
            _iocs_gpalet(i, rgb888_2grb(j * 4, j * 4, j * 4, 0));
            break;
        case 1:
            _iocs_gpalet(i, rgb888_2grb(j * 4, 0, 0, 0));
            break;
        case 2:
            _iocs_gpalet(i, rgb888_2grb(0, j * 4, 0, 0));
            break;
        case 3:
            _iocs_gpalet(i, rgb888_2grb(0, 0, j * 4, 0));
            break;
        }
    }
}

void scroll() {

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
