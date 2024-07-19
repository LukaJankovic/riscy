PREFIX := riscv64-unknown-elf
GCC := $(PREFIX)-gcc.exe
AS := $(PREFIX)-as.exe
OBJCOPY := $(PREFIX)-objcopy.exe

GCC_FLAGS := -nostartfiles -nostdlib -T rom_link -march=rv32i -mabi=ilp32

ifeq ($(OS),Windows_NT)
	RM := del
else
	RM := rm -f
endif

%.o: %.s
	$(GCC) $(GCC_FLAGS) $< -o $@

%.bin: %.o
	$(OBJCOPY) -O binary $< $@

%.dat: %.bin
	xxd -e -g 4 $< | awk "{$$1=\"\"; print}" | awk "NF{NF--};1" | sed "s/ /\n/g" | python hex2bin.py > $@

all: $(patsubst %.s,%.dat,$(wildcard *.s))

clean:
	$(RM) $(wildcard *.o) $(wildcard *.bin) $(wildcard *.dat)
