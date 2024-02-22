# Riscy

Simple implementation of rv32i in VHDL.

## Supported ops

- [X] LUI
- [ ] AUIPC
- [ ] JAL
- [ ] JALR
- [ ] BEQ
- [X] LB
- [X] SB
- [X] ADDI
- [X] ADD

## Supported CPU features

- [ ] Data forwarding
- [ ] Pipeline flushing

## Supported Platform features

- [X] Pmod SSD
- [ ] Pmod UART
- [ ] Pmod VGA

## Other notes

* Control signals go when reset = '1', allowing undefined behavior.