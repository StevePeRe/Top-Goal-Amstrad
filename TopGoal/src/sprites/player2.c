#include "player2.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Tile sprite_player2: 20x24 pixels, 10x24 bytes.
const u8 sprite_player2[10 * 24] = {
	0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11, 0x33, 0x33,
	0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x33, 0x33,
	0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x33, 0x33,
	0x22, 0x0f, 0x0f, 0x0f, 0x0f, 0x0a, 0x00, 0x00, 0x33, 0x33,
	0x22, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x00, 0x00, 0x33, 0x33,
	0x22, 0x55, 0xaf, 0x0a, 0xff, 0x0f, 0x00, 0x00, 0x33, 0x33,
	0x22, 0x55, 0xaf, 0x0a, 0xff, 0x0f, 0x0a, 0x00, 0x11, 0x33,
	0x22, 0x0f, 0x0a, 0x0f, 0x0f, 0x0f, 0x0a, 0x05, 0x11, 0x33,
	0x22, 0x0f, 0x0a, 0x0f, 0x0f, 0x0f, 0x0f, 0x05, 0x11, 0x33,
	0x22, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0a, 0x11, 0x33,
	0x22, 0x0f, 0x0a, 0x00, 0x00, 0x0f, 0x0f, 0x0a, 0x33, 0x33,
	0x33, 0x05, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0xf3, 0x11, 0x33,
	0x33, 0x22, 0xa2, 0xf3, 0xf3, 0xf3, 0xf3, 0x51, 0x0a, 0x33,
	0x33, 0x22, 0x0a, 0xf3, 0xf3, 0xf3, 0xf3, 0x05, 0x0a, 0x33,
	0x33, 0x05, 0x0a, 0xf3, 0xf3, 0xf3, 0xa2, 0x0f, 0x0a, 0x33,
	0x22, 0x0f, 0x00, 0xf3, 0xf3, 0xf3, 0x05, 0x0f, 0x11, 0x33,
	0x22, 0x0f, 0x00, 0xc0, 0xc0, 0xc0, 0x05, 0x0f, 0x11, 0x33,
	0x33, 0x00, 0x22, 0xc0, 0xc0, 0xc0, 0x00, 0x00, 0x33, 0x33,
	0x33, 0x33, 0x22, 0xc0, 0xc0, 0xc0, 0x80, 0x33, 0x33, 0x33,
	0x33, 0x33, 0x22, 0x4a, 0x80, 0xc0, 0x0f, 0x11, 0x33, 0x33,
	0x33, 0x33, 0x00, 0xff, 0x11, 0x55, 0xaf, 0x0a, 0x33, 0x33,
	0x33, 0x00, 0xff, 0xff, 0x00, 0xff, 0xff, 0xff, 0x11, 0x33,
	0x22, 0xff, 0xff, 0xaa, 0xff, 0xff, 0xff, 0xff, 0x11, 0x33,
	0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11, 0x33
};

