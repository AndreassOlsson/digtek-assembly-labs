start:
    addi x30, x0, 0
    addi x1, x0, 1 # 000001
    addi x2, x0, 2 # 000010
    addi x4, x0, 4 # 000100
    addi x8, x0, 8 # 001000
    addi x12, x0, 12 # 001100
    addi x16, x0, 16 # 010000
    addi x17, x0, 32 # 100000

night:
    and x25, x31, x1
    bne x25, x1, day # om dag, hoppa till day
    and x26, x31, x2
    beq x26, x2, loop # Bil på sidogata, gör loop
    add x30, x0, x12
    beq x25, x0, night

day:
    and x25, x31, x1
    bne x25, x1, loop
    beq x25, x1, night

loop:
    add x30, x0, x12 # Green main, red side
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x8 # Red side
    add x30, x30, x2 # Yellow main
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x8 # Red side
    add x30, x30, x1 # Red main
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x8 # Red side
    add x30, x30, x16 # Yellow side
    add x30, x30, x1 # Red main
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x17 # Green side
    add x30, x30, x1 # Red main
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x16 # Yellow side
    add x30, x30, x1 # Red main
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x8 # Red side
    add x30, x30, x1 # Red main
    jalr x11, x0, %lo(wait) # Procedure call to wait
    add x30, x0, x8 # Red side
    add x30, x30, x2 # Yellow main
    beq x0, x0, day

wait:
    add x10, x0, 2047 # Short delay so we can simulate
w1:
    add x14, x0, 2047
    jalr x13, x0, %lo(w2)
    addi x10, x10, -1 # Decrement
    bge x10, x0, w1 # Loop if >= 0
    jalr x0, x11, 0 # Return from procedure
w2:
    addi x14, x14, -1 # Decrement
    bge x14, x0, w2 # Loop if >= 0
    jalr x0, x13, 0 # Return from procedure
