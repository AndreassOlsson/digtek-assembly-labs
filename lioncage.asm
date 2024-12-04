addi x1, x0, 1 # D0 = 00000001, D0 to 7 segment
addi x1, x0, 2 # D1 = 00000010, D1 to 7 segment
addi x3, x0, 4 # D2 = 00000100, D2 to 7 segment AND Lion in front of G1
addi x4, x0, 8 # D3 = 00001000, D3 to 7 segment AND Lion in front of G2

waiting_state:
    beq x31, x0, decision_state # No sensor triggered, aka "clean sheet" -> enter decision state
    bne x31, x0, waiting_state # remain in waiting state until "clean sheet" 

decision_state:
    # Lions are not allowed to turn
    beq x31, x3, increament # lion in front of G1, increase
    beq x31, x4, decrease # lion in front of G2, decrease
    bne x31, x4, decision_state # keep looking for sensor

increament:
    addi x30, x30, 1 # increase one to output counter
    beq x31, x3, waiting_state # head back to waiting state

decrease:
    sub x30, x30, x1 # decrease one from output counter
    beq x31, x4, waiting_state # head back to waiting state