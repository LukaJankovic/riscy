    li a0, 1
    li a1, 5
    nop
    nop
    nop
    sw a0, 0(a1)
    nop
    nop
    nop
    lw a2, 0(a1)
#doubler:
#    add a0, a0, a0
#    j doubler