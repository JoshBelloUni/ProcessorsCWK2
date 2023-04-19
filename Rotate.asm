// Initialize variables
@R3         // address of original number
D=M
@INPUT      // address of input variable
M=D

@R4         // address of number of rotations
D=M
@ROTATION   // address of rotation variable
M=D

(LOOP)
    
    // check if input variable is negative
    // because MSB is 1 if negative
    @INPUT
    D=M
    @NEG
    D;JLE
    
    // shifts the bit left by 1 each iteration by adding itself once
    // jumps to the decrementation of the ROTATION counter
    // in order to skip adding 1 if no bit is needed to be rotated
    @INPUT
    D=M
    D=D+M
    M=D
    @END_LOOP
    0;JMP

    // this is the code that is run when MSB is 1
    // runs the same code as before, but also adds 1 to rotate the MSB to LSB
    // also jumps down to the decrementing of ROTATION
    (NEG)
        @INPUT
        D=M
        D=D+M
        D=D+1
        M=D
        @END_LOOP
        0;JMP

    // decrements rotation
    // checks if its still > 0, then continues the loop
    (END_LOOP)
        @ROTATION
        D=M
        D=D-1
        M=D
        @LOOP
        D;JGT

@INPUT
D=M

@R5         // address of output variable
M=D

(END)
@END
0;JMP