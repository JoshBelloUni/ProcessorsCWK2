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
@255
D=A
D=!D
@TEXT   
D=D&M
@LEFT_HALF
M=D

// shifting to the right half to the left
@RIGHT_HALF    
D=M
@NEW_LEFT    
M=D

@8
D=A
@MNL_COUNTER 
M=D

(MAKE_NEW_LEFT) 
    // shifting the right bits to the left to make the new left hand side
    @NEW_LEFT  
    D=M
    D=D+M
    M=D

    @MNL_COUNTER    
    M=M-1
    D=M
    @MAKE_NEW_LEFT 
    D;JGT

// negating key
@KEY   
D=M
D=!D
@255 // its only an 8 bit key so mask with 255
D=D&A
@NEGATED_KEY
M=D

(XOR_WITH_KEY)
    // this is the loop that gets the negated key for that current loop
    // and XORs it with RIGHT HALF
    // this will eventually be XORed with the left side to
    // get the new right side

    // negating the variables
    @RIGHT_HALF 
    D=M
    @NOT_RIGHT_HALF    
    M=!D

    @NEGATED_KEY    
    D=M
    @NOT_NEGATED_KEY   
    M=!D

    // ANDing RIGHT_HALF and NEGATED_KEY
    @RIGHT_HALF   
    D=M
    @NOT_NEGATED_KEY   
    D=D&M
    @RIGHT_AND_NOT_NEGATED_KEY 
    M=D

    // ANDing NOT_RIGHT_HALF and NEGATED_KEY
    @NOT_RIGHT_HALF
    D=M
    @NEGATED_KEY  
    D=D&M
    @NOT_RIGHT_AND_NEGATED_KEY 
    M=D

    //ORing to get final XOR product:
    @RIGHT_AND_NOT_NEGATED_KEY 
    D=M
    @NOT_RIGHT_AND_NEGATED_KEY  
    D=D|M
    @KEYD_RIGHT 
    M=D

// storing counter
@8
D=A
@LEFT_ROTATION
M=D

(LEFT_ROTATION_SHIFT)  
    // shifts what is on the left hand side to the right for XORing
    @LEFT_HALF 
    D=M
    @LEFT_NEG 
    D;JLT

    // shifts up if MSB is 0
    @LEFT_HALF
    D=M
    D=D+M
    M=D
    @END_LRF
    0;JMP

    (LEFT_NEG)
        // shifts up if MSB is 1
        // so that I add 1
        @LEFT_HALF
        D=M
        D=D+M
        D=D+1
        M=D
        @END_LRF
        0;JMP
    
(END_LRF)
    @LEFT_ROTATION
    M=M-1
    D=M
    @LEFT_ROTATION_SHIFT
    D;JGT

// this section XORs the new rotated right half with the old left half
// the old left half has just been rotated previously so now exists in the right half. 
// this XOR will replace RIGHT_HALF
(XOR)

    // negating the variables
    @KEYD_RIGHT
    D=M
    @NOT_RIGHT_HALF2
    M=!D

    @LEFT_HALF
    D=M
    @NOT_LEFT_HALF
    M=!D

    // ANDing KEYD_RIGHT and NOT_LEFT_HALF
    @KEYD_RIGHT
    D=M
    @NOT_LEFT_HALF
    D=D&M
    @RIGHT_AND_NOT_LEFT
    M=D

    // ANDing NOT_RIGHT_HALF and LEFT_HALF
    @NOT_RIGHT_HALF2
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
    @NEW_RIGHT
    M=D

// ORing new left and new right to get the next stage of the cipher
@NEW_LEFT
D=M
@NEW_RIGHT
D=D|M
@TEXT
M=D

// shifting the key each interation
(KEY_SHIFT)
     
    // check if input variable is greater than 128
    @128
    D=A
    @KEY
    D=D-M
    @GREATER
    D;JLE
    
    // this is the standard right shift if there is no MSB
    @KEY
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
        @KEY
        D=M
        D=D+M
        @255
        D=D&A
        D=D+1
        M=D
        @END_LOOP
        0;JMP
(END_LOOP)

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
@R0
M=D

(END)
@END
0;JMP