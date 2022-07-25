TARGET=HELLO.X
SRCS=hello.c
OBJS=$(SRCS:.c=.o)
CC=$(HUMAN68K_TC)/bin/human68k-gcc
OBJCOPY=$(HUMAN68K_TC)/bin/human68k-objcopy
OBJDUMP=$(HUMAN68K_TC)/bin/human68k-objdump
LIB=-L$(HUMAN68K_TC)/human68k/lib
INCLUDE=-I$(HUMAN68K_TC)/human68k/include -I$(HUMAN68K_TC)/../libc32b/include
CCFLAGS=$(INCLUDE) -g -O2
LDFLAGS=$(LIB) -ldos -liocs -lm

.PHONY:
	clean install dump

$(TARGET): $(OBJS)
	$(CC) $^ -o tmp.elf $(LDFALGS)
	$(OBJCOPY) -O xfile tmp.elf $@

$(OBJS): $(SRCS)
	$(CC) -Wa,-adhlns="$@.lst" -c $< -o $@ $(CCFLAGS)

clean:
	rm -rf $(TARGET) *.elf *.o *.lst

install: $(TARGET)
	cp $(TARGET) $(HOME)/tmp

dump: $(TARGET)
	$(OBJDUMP) -D $(TARGET)
