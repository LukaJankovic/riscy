PREFIX := riscv64-unknown-elf
AS := $(PREFIX)-as.exe
OBJCOPY := $(PREFIX)-objcopy.exe

%.o: %.s
	$(AS) $< -o $@ -march=rv32i

%.bin: %.o
	$(OBJCOPY) -O binary $< $@

%.dat: %.bin
	xxd -e -g 4 $< | awk '{$$1=""; print}' | awk 'NF{NF--};1' | sed 's/ /\n/g' | python3 hex2bin.py > $@

all: $(patsubst %.s,%.dat,$(wildcard *.s))

clean:
	rm -f *.o *.bin *.dat
