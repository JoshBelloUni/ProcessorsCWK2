// initialising variables
@R1
D=M
@KEY
M=D

@R2
D=M
@TEXT
M=D

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

(LOOP)

    @256
    D=A
    @RIGHT_HALF
    D=M-D
    D;

