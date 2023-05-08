// initialising variables
@R1
D=M
@KEY
M=D

@R2
D=M
@TEXT
M=D

@4
D=A
@COUNTER
M=D

(ROUND)

// splitting text
// ANDing 000000001111111 with the plaintext
// this only gives me what is on the right hand side
@255
D=A
@TEXT
D=D&M
@RIGHT_HALF
M=D

// ANDing 111111100000000 with the plaintext
// to only give me the left hand side
@-128
D=A
@TEXT
D=D&M
@LEFT_HALF
M=D

// rotating the left hand side to the right
// will be used when i later put them back together and
// it will also help when i XOR them together
(LEFT_ROTATION_SHIFT)

    // storing counter
    @8
    D=A
    @LEFT_ROTATION
    M=D

    // check if input variable is negative
    // because MSB is 1 if negative
    @LEFT_HALF
    D=M
    @LEFT_NEG
    D;JLE
    
    // shifts the bit left by 1 each iteration by adding itself once
    // jumps to the decrementation of the ROTATION counter
    // in order to skip adding 1 if no bit is needed to be rotated
    @LEFT_HALF
    D=M
    D=D+M
    M=D
    @END_LEFT_LOOP
    0;JMP

    // this is the code that is run when MSB is 1
    // runs the same code as before, but also adds 1 to rotate the MSB to LSB
    // also jumps down to the decrementing of ROTATION
    (LEFT_NEG)
        @LEFT_HALF
        D=M
        D=D+M
        D=D+1
        M=D
        @END_LEFT_LOOP
        0;JMP

    // decrements rotation
    // checks if its still > 0, then continues the loop
    (END_LEFT_LOOP)
        @ROTATION
        D=M
        D=D-1
        M=D
        @LEFT_ROTATION_SHIFT
        D;JGT

// this will rotate only the 8 bits on the right
// by the amount specified in the key
(EIGHT_BIT_ROTATE_LOOP)

    // temporary variable for the key
    @KEY
    D=M
    @TEMP_KEY
    M=D
       
    // check if input variable is greater than 128
    @128
    D=A
    @RIGHT_HALF
    D=D-M
    @GREATER
    D;JLE
    
    // this is the standard right shift if there is no MSB
    @RIGHT_HALF
    D=M
    D=D+M
    M=D
    @END_LOOP
    0;JMP

    // if there is an MSB, ie is greater than 128,
    // perform the right shift
    // AND with 255 (0000000011111111)
    // to get rid of and bits beyond the 8 bits of the scope
    // add 1 to rotate the significant bit around
    (GREATER)
        @RIGHT_HALF
        D=M
        D=D+M
        @TEMP_ADDED
        M=D
        @255
        D=A
        @TEMP_ADDED
        D=D&M
        D=D+1
        @RIGHT_HALF
        M=D
        @END_LOOP
        0;JMP

    // decrements rotation
    // checks if its still > 0, then continues the loop
    (END_LOOP)
        @TEMP_KEY
        D=M
        D=D-1
        M=D
        @EIGHT_BIT_ROTATE_LOOP
        D;JGT

// NOTing the RIGHT_HALF for the function
@RIGHT_HALF
D=M
D=!D
@255
D=A&D
M=D

// this section XORs the new rotated right half with the old left half
// the old left half has just been rotated previously so now exists in the right half. 
// this XOR will replace RIGHT_HALF
(XOR)

    // negating the variables
    @RIGHT_HALF
    D=M
    @NOT_RIGHT_HALF
    M=!D

    @LEFT_HALF
    D=M
    @NOT_LEFT_HALF
    M=!D

    // ANDing RIGHT_HALF and NOT_LEFT_HALF
    @RIGHT_HALF
    D=M
    @NOT_LEFT_HALF
    D=D&M
    @RIGHT_AND_NOT_LEFT
    M=D

    // ANDing NOT_RIGHT_HALF and LEFT_HALF
    @NOT_RIGHT_HALF
    D=M
    @LEFT_HALF
    D=D&M
    @NOT_RIGHT_AND_LEFT
    M=D

    //ORing to get final XOR product:
    @RIGHT_AND_NOT_LEFT
    D=M
    @NOT_RIGHT_AND_LEFT
    D=D|M
    @RIGHT_HALF
    M=D

@RIGHT_HALF
D=M

// this function rotates the wholes 16 bits by 8 bits
// using this will shift the RIGHT_HALF to the left side

// storing counter
@8
D=A
@RIGHT_ROTATION
M=D

(RIGHT_ROTATION_SHIFT)

    // check if input variable is negative
    // because MSB is 1 if negative
    @RIGHT_HALF
    D=M
    @RIGHT_NEG
    D;JLT
    
    // shifts the bit left by 1 each iteration by adding itself once
    // jumps to the decrementation of the ROTATION counter
    // in order to skip adding 1 if no bit is needed to be rotated
    @RIGHT_HALF
    D=M
    D=D+M
    M=D
    @END_RIGHT_LOOP
    0;JMP

    // this is the code that is run when MSB is 1
    // runs the same code as before, but also adds 1 to rotate the MSB to LSB
    // also jumps down to the decrementing of ROTATION
    (RIGHT_NEG)
        @RIGHT_HALF
        D=M
        D=D+M
        D=D+1
        M=D
        @END_RIGHT_LOOP
        0;JMP

    // decrements rotation
    // checks if its still > 0, then continues the loop
    (END_RIGHT_LOOP)
        @RIGHT_ROTATION
        D=M
        D=D-1
        M=D
        @RIGHT_ROTATION_SHIFT
        D;JGT 

@RIGHT_HALF
D=M
@LEFT_HALF
D=M|D
@TEXT
D=M

// check if counter is greater than 0
// if it is, continue the loop until 4 rounds are completed
@COUNTER
D=M
D=D-1
M=D
@ROUND
D;JGT

// output final result
@TEXT
D=M
@R5
M=D

(END)
@END
0;JMP