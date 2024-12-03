# Lion Counter FSM
# Registers:
# x30 - Counter (number of lions outside)
# x31 - Sensor bitmask (used to check sensor states)
# x4  - G1 sensor value
# x8  - G2 sensor value

start:
    addi x30, x0, 0      # Initialize lion counter to 0
    addi x31, x0, 1      # Bitmask for sensor status
    addi x4, x0, 2       # G1 sensor identifier
    addi x8, x0, 3       # G2 sensor identifier

# Waiting state (waiting_state)
waiting_state:
    and x21, x31, x4     # Check if G1 is active
    and x22, x31, x8     # Check if G2 is active
    and x23, x21, x22    # Check if both G1 and G2 are high
    bne x23, x0, decision_state      # If both are high, transition to decision state
    beq x0, x0, waiting_state       # Unconditional branch to waiting_state (always true)

# Decision state (decision_state)
decision_state:
    and x21, x31, x4     # Check current state of G1
    and x22, x31, x8     # Check current state of G2

    # Check for lion entering cage (G1 high -> low, G2 high)
    bne x21, x0, check_exit # If G1 is not low, check for exiting lion
    bne x22, x0, lion_enter # If G2 is still high, lion entered the cage

check_exit:
    # Check for lion exiting cage (G1 low, G2 high -> low)
    beq x21, x0, lion_exit # If G1 is low and G2 transitions, lion exits
    beq x0, x0, waiting_state         # Unconditional branch to waiting_state (always true)

lion_enter:
    addi x30, x30, -1      # Decrease lion counter (lion enters cage)
    beq x0, x0, waiting_state         # Unconditional branch to waiting_state (always true)

lion_exit:
    addi x30, x30, 1       # Increase lion counter (lion exits cage)
    beq x0, x0, waiting_state         # Unconditional branch to waiting_state (always true)
