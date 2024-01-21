# riscv64-unknown-elf-as.exe strlen.s -o strlen.o -march=rv32i
# riscv64-unknown-elf-objcopy.exe -O binary strlen.o strlen.bin
# xxd -e -g 4 .\strlen.bin | awk '{$1=\"\"}1' | awk 'NF{NF--};1' | sed 's/ /\n/g' | ???
# Missing convert hex->bin that works cross platform