# Allmänna beteenden
# Day: switcha mellan grönt på main och side kontinuerligt
# Night: grönt på main fram tills en bil kommer på side street, då det loopas x1 sen återgår


start:
    # Inled med 0 på alla outputs, dvs alla lampor släckta
    addi x30, x0, 0

    # Input och Outputs
    addi x1, x0, 1 # D0 = 000001. Kollar både day(0)/night(1) och red main     
    addi x2, x0, 2 # D1 = 000010. Kollar både bil på side (1) och yellow main

    # Bara outputs
    addi x8, x0, 4 # D3 = 001000, red side
    addi x12, x0, 12 # D2 & D3 = 001100, green main AND red side
    addi x16, x0, 16 # D4 = 010000, yellow side
    addi x17, x0, 32 # D5 = 100000, green side

night_logic:
    and x25, x31, x1 # är det natt?
    bne x25, x1, day_logic # om nej, dvs det är dag, hoppa till day

    and x26, x31, x2 # Är det en bil på sidogatan (och natt)?
    beq x26, x2, traffic_cycle # om ja, loopa igenom trafikljussekvensen

    add x30, x0, x12 # Sätt grönt ljus på huvudgatan och rött ljus på sidogatan, oavsett om det var en bil på sidogatan eller inte
    
    # Bug: borde brancha om equal to x1, nu fungerar det bara pga "day" är efter
    beq x25, x0, night_logic # Om det inte är natt, loopa igenom samma night_logic traffic_cycle igen 

day_logic:
    and x25, x31, x1 # är det natt?
    bne x25, x1, traffic_cycle # om dag, loopa igenom sekvensen
    beq x25, x1, night_logic # om natt, kör natt loopen

traffic_cycle:
    add x30, x0, x12 # green main, red side
    jalr x11, x0, %lo(delay) # delay

    add x30, x0, x8 # red side
    add x30, x30, x2 # yellow main
    jalr x11, x0, %lo(delay) # delay

    add x30, x0, x8 # red side
    add x30, x30, x1 # red main
    jalr x11, x0, %lo(delay) # delay

    add x30, x0, x8 # red side
    add x30, x30, x16 # yellow side
    add x30, x30, x1 # red main
    jalr x11, x0, %lo(delay) # delay

    add x30, x0, x17 # green side
    add x30, x30, x1 # red main
    jalr x11, x0, %lo(delay) # delay
    
    add x30, x0, x16 # yellow side
    add x30, x30, x1 # red main
    jalr x11, x0, %lo(delay) # delay

    add x30, x0, x8 # red side
    add x30, x30, x1 # red main
    jalr x11, x0, %lo(delay) # delay

    add x30, x0, x8 # red side
    add x30, x30, x2 # yellow main
    beq x0, x0, day_logic # return to day_logic

# delay logic
delay:
    add x10, x0, 2047
outer_delay:
    add x14, x0, 2047
    jalr x13, x0, %lo(inner_delay)
    addi x10, x10, -1 
    bge x10, x0, outer_delay 
    jalr x0, x11, 0 # return from procedure
inner_delay:
    addi x14, x14, -1 
    bge x14, x0, inner_delay 
    jalr x0, x13, 0 # return from procedure
