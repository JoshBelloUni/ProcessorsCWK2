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
    
    // check if input variable is greater than 128
    @128
    D=A
    @INPUT
    D=D-M
    @GREATER
    D;JLE
    
    @INPUT
    D=M
    D=D+M
    M=D
    @END_LOOP
    0;JMP

    (GREATER)
        @INPUT
        D=M
        D=D+M
        @TEMP_ADDED
        M=D
        @255
        D=A
        @TEMP_ADDED
        D=D&M
        D=D+1
        @INPUT
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