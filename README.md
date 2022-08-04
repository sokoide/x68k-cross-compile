# X68000 cross compile examples

## Prereq

* Set up and build a cross compile toolset written in <https://virtuallyfun.com/wordpress/2014/11/18/cross-compiling-to-the-sharp-x68000/>
* It doesn't build gcc/binutils or etc on Apple Silicon in aarch64 mode. Please run `arch -x86_64 /bin/zsh` before building it.

```sh
# if aarch64
arch -x86_64 /bin/zsh

# common
brew intall llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

export HUMAN68K_TC=$HOME/repo/x68000/cross/human68k
export HUMAN68K_TC_SRC=$HUMAN68K_TC/src
export PATH=$PATH:$HUMAN68K_TC/bin

if [ -d $HUMAN68K_TC_SRC ]; then
mkdir -p $HUMAN68K_TC_SRC
fi

# downgrade texinfo if 5.x or newer is installed
wget http://ftp.gnu.org/gnu/texinfo/texinfo-4.13.tar.gz
tar -zxf texinfo-4.13.tar.gz
cd texinfo-4.13
./configure
make
sudo make install

# binutils
cd $HUMAN68K_TC_SRC
git clone git@github.com:Lydux/binutils-2.22-human68k.git
mkdir binutils-build
cd binutils-build
../binutils-2.22-human68k/configure --prefix=$HUMAN68K_TC --target=human68k --disable-nls --disable-werror
make all install -j16


cd $HUMAN68K_TC_SRC
git clone git@github.com:Lydux/gcc-4.6.2-human68k.git
mkdir gcc-build
cd gcc-build
../gcc-4.6.2-human68k/configure \
        --prefix=$HUMAN68K_TC \
        --target=human68k \
        --disable-nls \
        --disable-libssp \
        --with-newlib \
        --without-headers \
        --enable-languages=c \
        --disable-werror \
        --with-gmp=/usr/local/Cellar/gmp/6.2.1_1 --with-mpfr=/usr/local/Cellar/mpfr/4.1.0 --with-mpc=/usr/local/Cellar/libmpc/1.2.1
make all install -j16


cd $HUMAN68K_TC_SRC
git clone git@github.com:Lydux/newlib-1.19.0-human68k.git
mkdir newlib-build
cd newlib-build
../newlib-1.19.0-human68k/configure --prefix=$HUMAN68K_TC --target=human68k  --disable-werror
make all install -j16


cd $HUMAN68K_TC_SRC
git clone git@github.com:Lydux/gdb-7.4-human68k.git
mkdir gdb-build
cd gdb-build
../gdb-7.4-human68k/configure --prefix=$HUMAN68K_TC --target=human68k --disable-nls --disable-werror
make all install -j16
```

* When you `configure` each of them, you may need to add `--disable-werror`
* You'll get the fllowings for human68k/x68000
  * gcc
  * binutils
  * newlib
  * gdb
* Copy libc headers
    * Copy [libc32b](http://retropc.net/x68000/software/develop/lib/libc1132a/) into $(HOME)/Emu/x68000/cross/libc32b

## Build and run samples

### common

* set `HUMAN68K_TC=$(HOME)/repo/x68000/cross/human68k` or etc

### hello

* cd hello
* make install
* ~/tmp/hello.x is built
* run [XM6 TypeG](http://retropc.net/pi/xm6/index.html) via wine on Mac, configure WinDRV to share Mac's drive with the emulator
* mount ~/tmp in X68000 emulator as D: drive with WinDRV and run d:\hello.x
![hello.x](./docs/hello.png)


### vram

* vram access example
![vram.x](./docs/vram.png)

### asm-hello

* assmebler + DOS call example

### asm-memory

* print memory blocks
![asmmem.x](./docs/asmmem.png)

### asm-debug

* usage of DB.x debugger

```
# when we debug the following code (asmdbg.x) with DB.x
main:
	move.b	#10, %d0
	move.b	#20, %d1
	add.b	%d1, %d0
	DOS	_EXIT


# it shows registers and the current instruction
> db asmdbg.x
D 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A 00AA290 ...
main:
move.b #$0A, D0

# 'help' shows hep
- help
A[address]      : Assmeble
AN[address]     : Assemble w/o mnemoinic
B               : display breakpoints
...
L               : assembly list
P               : system status
PS              : symbols
...
S               : step
T               : trace
X               : registeres
...

# 'l' shows the current assmebly list
-l
...
main:
move.b #$0A, D0
move.b #$14, D1
...

# 'p' shows the program info
- p
Micro Processor Unit: 16bit MC68000
Floating Point Co Processor:Software emulation.
debug program from $00073800
user  program from $000AA390
              end  $000AA39C
              exec $000AA390
symbol table  from $000AA180


# 'ps' shows the symbols
- ps
$000AA390: main
$000AA39C: ___EH__FRAME_END__
$000AA39C: edata
$000AA39C: __dtors_end
$000AA39C: end
$000AA39C: etext
$000AA39C: __ctors_start
$000AA39C: _etext
$000AA39C: ___EH_FRAME_BEGIN__
$000AA39C: __dtors_start
$000AA39C: __dtors_end
$000AA39C: _edata
$000AA39C: _end


# 't' traces.
# D0 register changed to 0x0A by 'move.b #$0A, D0
- t
PC: 000AA394 USP:...
HI: 1 LS:0 CC:1 ...
D: 0000000A 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A 000AA290 ...
move.b #$14 ,D1

-t
PC: 000AA398 USP:...
D: 0000000A 00000014 00000000 00000000 00000000 00000000 00000000 00000000
A 000AA290 ...
add.b D1, D0

-t
PC: 000AA39A USP:...
D: 0000001E 00000014 00000000 00000000 00000000 00000000 00000000 00000000
A 000AA290 ...
_EXIT

-t
program terminated normally

```
![asmdbg.x](./docs/asmdbg.png)

### asm-device

* Print installed device drivers

## Differences in GNU Assembler

* _title_: _as_ -> _gas_
* register: `d1` -> `%d1`
* indirect: `(a0)` ->  `%a0@`
* indirect pre-decrement: `-(sp)` ->  `%sp@-`
* indirect post-increment: `(a0)+` ->  `%a0@+`
* indirect plus offsete: `12(a0)` ->  `%a0@(12)`
* Link: <https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_node/as_214.html>
