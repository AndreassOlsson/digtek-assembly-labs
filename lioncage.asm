start:
    addi x30, x0, 0     # Sätter räknaren för antal lejon i buren till 0
    addi x31, x0, 1     # Bitmask för aktivering av sensorstatus
    addi x4, x0, 2      # G1-sensorn
    addi x8, x0, 3      # G2-sensorn
    addi x12, x0, 12    # Kombination av G1 & G2

q0:
    and x21, x31, x4       # Kontrollera om G1-sensorn är aktiverad
    bne x21, x4, q0        # Om ingen framför G1, stanna i denna loop
    and x23, x31, x12      # Kontrollera om både G1 och G2 är aktiverade
    beq x23, x12, q1       # Om både G1 & G2 är aktiverade, hoppa till q1 utan att räkna
    addi x30, x30, 1       # Räkna upp (ett lejon går in)
    bne x23, x12, q1       # Hoppa till q1 efter att ha räknat

q1:
    and x21, x31, x4       # Kontrollera om G1 fortfarande är aktiverad
    beq x21, x4, q1        # Om G1 fortfarande = 1, stanna i denna loop
    and x22, x31, x8       # Kontrollera om G2 är aktiverad
    bne x22, x8, q0        # Om G2 inte är aktiverad, hoppa tillbaka till q0
    addi x30, x30, -1      # Räkna ner (ett lejon går ut)
    bne x22, x8, q0        # Hoppa tillbaka till q0 efter att ha räknat ner


        # ADDI används för att sätta specifika värden och uppdatera räknaren i register x30
        # AND används för att kontrollera om specifika sensorer är aktiverade
        # BEQ och BNE används för att strya programflödet genom sensordata
        # 	BEQ = branch if equal
        # 	BNE = branch if not equal
	