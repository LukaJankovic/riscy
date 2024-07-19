.global _start
_start:
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
    call funcs
    addi a0, a0, 7
    call func
loop:
    j loop
    addi a0, a0, 8
    addi a0, a0, 9
    addi a0, a0, 10
    addi a0, a0, 11
func:
    addi a0, a0, 10
    addi a0, a0, 10
    addi a0, a0, 10
    addi a0, a0, 10
    ret
    addi a0, a0, 20
    addi a0, a0, 20
    addi a0, a0, 20
    addi a0, a0, 20
funcs:
    ret