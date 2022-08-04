# control codes
.equ BELL, 0x07
.equ BS, 0x08
.equ TAB, 0x09
.equ LF, 0x0a
.equ CR, 0x0d
.equ EOR, 0x1a
.equ ESC, 0x1b
.equ SPACE, 0x20

# file handles
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2
.equ STDAUX, 3
.equ STDPRN, 4

# file access odes
.equ ROPEN, 0
.equ WOPEN, 1
.equ RWOPEN, 2

# file attributes
.equ ARCHIVE, 0x20
.equ SUBDIR, 0x10
.equ VOLUME, 0x08
.equ SYSTEM, 0x04
.equ HIDDEN, 0x02
.equ READONLY, 0x01
