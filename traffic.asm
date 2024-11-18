# Constants
addi x1, x0, 25000000  # 1 second delay (25 MHz clock)
addi x2, x0, 8         # Number of states in the sequence

# State definitions (bits: main_green, main_yellow, main_red, side_green, side_yellow, side_red)
addi x10, x0, 0b100001 # State 0: Main green, Side red
addi x11, x0, 0b010001 # State 1: Main yellow, Side red
addi x12, x0, 0b001001 # State 2: Main red, Side red
addi x13, x0, 0b001011 # State 3: Main red, Side red+yellow
addi x14, x0, 0b001100 # State 4: Main red, Side green
addi x15, x0, 0b001010 # State 5: Main red, Side yellow
addi x16, x0, 0b001001 # State 6: Main red, Side red
addi x17, x0, 0b011001 # State 7: Main red+yellow, Side red

# Initialize
addi x20, x0, 0  # Current state
add x30, x0, x10 # Set initial state output

main_loop:
    # Read inputs (assuming they're mapped to x31)
    andi x21, x31, 1   # x21 = Day/Night (0 = Day, 1 = Night)
    andi x22, x31, 2   # x22 = Car on side street

    # Check if it's night
    beq x21, x0, day_mode
    
night_mode:
    # If no car on side street, stay in state 0
    beq x22, x0, output_state
    
    # If car present, go through the sequence once
    addi x23, x0, 0  # Initialize loop counter
    
night_sequence:
    # Output current state
    add x5, x20, x10  # Calculate address of current state
    lw x30, 0(x5)     # Load state to output register
    
    # Delay
    addi x24, x0, 0   # Initialize delay counter
delay_loop_night:
    addi x24, x24, 1
    bne x24, x1, delay_loop_night
    
    # Move to next state
    addi x20, x20, 1
    addi x23, x23, 1
    bne x23, x2, night_sequence
    
    # Reset to state 0 after sequence
    addi x20, x0, 0
    beq x0, x0, output_state

day_mode:
    # Move to next state
    addi x20, x20, 1
    bne x20, x2, output_state
    addi x20, x0, 0  # Reset to state 0 if we've gone through all states

output_state:
    # Output current state
    add x5, x20, x10  # Calculate address of current state
    lw x30, 0(x5)     # Load state to output register
    
    # Delay
    addi x24, x0, 0   # Initialize delay counter
delay_loop:
    addi x24, x24, 1
    bne x24, x1, delay_loop
    
    beq x0, x0, main_loop  # Loop back to start

