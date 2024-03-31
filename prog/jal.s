    addi a0, a0, 1
    addi a0, a0, 2
    nop
    addi a0, a0, 3
    nop
    nop
    addi a0, a0, 4
test:
    nop
    nop
    nop
    addi a0, a0, 5
    nop
    nop
    nop
    nop
    addi a0, a0, 7
loop:
    jal a1, loop
    addi a0, a0, 8
    addi a0, a0, 9
    addi a0, a0, 10
    addi a0, a0, 11