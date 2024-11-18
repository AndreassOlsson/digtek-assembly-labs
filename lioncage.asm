# Initialize registers
addi x1, x0, 0    # x1 will store our lion count
addi x2, x0, 9    # x2 holds max lion count (9)
addi x3, x0, 0    # x3 will store our previous state
addi x4, x0, 12   # x4 holds mask for lion sensors (1100 in binary)

# Main loop
main_loop:
    add x30, x0, x1   # Display current lion count on 7-segment (assuming x30 is output)

    # Read input from JA (assuming it's mapped to x31)
    andi x5, x31, 12  # x5 holds current state of sensors (bits D2 and D3)
    
    # State machine logic
    slli x6, x3, 2    # Shift previous state left by 2
    or x6, x6, x5     # Combine with current state
    
    # Check for lion going out
    addi x7, x0, 52   # 52 = 00110100 (sequence for lion going out)
    beq x6, x7, lion_out
    
    # Check for lion going in
    addi x7, x0, 38   # 38 = 00100110 (sequence for lion going in)
    beq x6, x7, lion_in
    
    beq x0, x0, update_state  # If no match, just update state

lion_out:
    bge x1, x2, update_state  # If at max, don't increment
    addi x1, x1, 1            # Increment lion count
    beq x0, x0, update_state

lion_in:
    beq x1, x0, update_state  # If at 0, don't decrement
    addi x1, x1, -1           # Decrement lion count

update_state:
    add x3, x0, x5    # Update previous state

    # Set "Fara" signal (danger light)
    addi x30, x0, 0   # Clear x30
    beq x1, x0, main_loop  # If lion count is 0, no danger
    ori x30, x30, 128  # Set MSB of x30 to indicate danger

    beq x0, x0, main_loop  # Loop back to start
