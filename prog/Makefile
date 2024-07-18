PREFIX := riscv64-unknown-elf
AS := $(PREFIX)-as.exe
OBJCOPY := $(PREFIX)-objcopy.exe

ifeq ($(OS),Windows_NT)
	RM := del
else
	RM := rm -f
endif

%.o: %.s
	$(AS) $< -o $@ -march=rv32i

%.bin: %.o
	$(OBJCOPY) -O binary $< $@

%.dat: %.bin
	xxd -e -g 4 $< | awk "{$$1=\"\"; print}" | awk "NF{NF--};1" | sed "s/ /\n/g" | python hex2bin.py > $@

all: $(patsubst %.s,%.dat,$(wildcard *.s))

clean:
	$(RM) $(wildcard *.o) $(wildcard *.bin) $(wildcard *.dat)
