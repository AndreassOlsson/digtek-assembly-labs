addi x10, x0, 4
addi x11, x0, 12
addi x12, x0, 8

loop:
    beq x31, x10, add
    beq x31, x12, in
    beq x0, x0, loop

add:
    addi x30, x30, 1
    beq x0, x0, out

out:
    beq x31, x11, mid
    beq x31, x0, sub
    beq x31, x12, sub
    beq x0, x0, out

mid:
    beq x31, x12, in
    beq x31, x10, out
    beq x31, x0, loop
    beq x0, x0, mid

sub:
    addi x30, x30, -1
    beq x0, x0, loop

in:
    beq x31, x11, mid
    beq x31, x0, loop
    beq x0, x0, in