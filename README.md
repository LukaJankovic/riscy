# Riscy

Simple implementation of rv32i in VHDL.

## Supported ops

- [X] LUI
- [X] AUIPC
- [X] JAL
- [X] JALR
- [ ] BEQ
- [X] LB
- [X] SB
- [X] ADDI
- [X] ADD

## Supported CPU features

- [X] Data forwarding
    * Works fine in simulator, but not on FPGA with current forward program. Possibly due to looping instructions, will test after jump implemented.
- [ ] Pipeline flushing

## Supported Platform features

- [X] Pmod SSD
- [ ] Pmod UART
- [ ] Pmod VGA

## Other notes

* Control signals go when reset = '1', allowing undefined behavior.