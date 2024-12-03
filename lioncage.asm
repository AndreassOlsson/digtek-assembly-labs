    # Assuming JA is stored in x31 (8-bit data)
    andi x11, x31, 0x04   # Extract D2 (Lion in front of G1) into x11 (0x04 = 00000100)
    andi x12, x31, 0x08   # Extract D3 (Lion in front of G2) into x12 (0x08 = 00001000)

    # Check if both G1 and G2 have lions in front of them
    bnez x11, check_g2    # If D2 is 1, jump to check_g2 (G1 has lion)
    j idle_state          # If D2 is 0, jump to idle state (no lion in front of G1)

check_g2:
    bnez x12, decision_state  # If D3 is 1, jump to decision state (G2 has lion)

    # If D3 is 0 (no lion in front of G2), jump to idle state (exit decision state)
    j idle_state

decision_state:
    # Loop and monitor G1 and G2 until either sensor stops being true
    loop:
        # Check if both G1 and G2 have lions (both D2 and D3 are 1)
        andi x11, x31, 0x04   # Extract D2 (Lion in front of G1) into x11
        andi x12, x31, 0x08   # Extract D3 (Lion in front of G2) into x12
        
        bnez x11, check_g2_in_decision  # If D2 is 1, check D3 (G1 has lion)
        j decrement_counter          # If D2 is 0, decrement counter (G1 no longer has lion)

check_g2_in_decision:
        bnez x12, loop_continue     # If D3 is 1, continue the loop (G2 has lion)
        j increment_counter         # If D3 is 0, increment counter (G2 no longer has lion)

loop_continue:
        j loop  # Continue the loop as both lions are in front of G1 and G2

decrement_counter:
        # Decrement the counter (assuming x30 is the counter)
        addi x30, x30, -1
        j idle_state  # Exit decision state and go to idle state

increment_counter:
        # Increment the counter (assuming x30 is the counter)
        addi x30, x30, 1
        j idle_state  # Exit decision state and go to idle state

idle_state:
        # Code for idle state, where nothing happens
        j idle_state  # Infinite loop, stays in idle state
