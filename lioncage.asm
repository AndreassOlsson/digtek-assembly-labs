addi x1, x0, 1
addi x3, x0, 4
addi x4, x0, 8

SO:
    beq x31, x0, s1
    bne x31, x0, s0

S1:
    beq x31, x3, OUTPUT1
    beq x31, x4, OUTPUT2
    bne x31, x4, S1

OUTPUT1:
    addi x30, x30, 1
    beq x31, x3, S0

OUTPUT2:
    sub x30, x30, x1
    beq x31, x4, S0