# offset
    .offset 0
DEVLNK: .ds.l   1
DEVATR: .ds.w   1
DEVSTR: .ds.l   1
DEVINT: .ds.l   1
DEVNAM: .ds.b   8

    .section .text
# device attributes
#                         FEDCBA9876543210
.equ    CHAR_DEVICE,    0b1000000000000000
.equ    BLOCK_DEVICE,   0b0000000000000000
.equ    ENABLE_IOCTRL,  0b0100000000000000
.equ    DISABLE_IOCTRL, 0b0000000000000000
.equ    RAW_MODE,       0b0000000000100000
.equ    COOKED_MODE,    0b0000000000000000
.equ    CLOCK_DEVICE,   0b0000000000001000
.equ    NUL_DEVICE,     0b0000000000000100
.equ    STDOUT_DEVICE,  0b0000000000000010
.equ    STDIN_DEVICE,   0b0000000000000001

.equ    ISCHRDEV_BIT,   15
.equ    IOCTRL_BIT,     14
.equ    ISRAW_BIT,      5
.equ    ISCLOCK_BIT,    3
.equ    ISNUL_BIT,      2
.equ    ISSTDOUT_BIT,   1
.equ    ISSTDIN_BIT,    0

# error codes
.equ    _ABORT,          0x1000
.equ    _RETRY,          0x2000
.equ    _IGRNORE,        0x4000
.equ    _ILLEGAL_CMD,    0x5003
