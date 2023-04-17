// Define the input and output memory addresses
@R3         // Defining the first input to be R3
D=M
@INPUT1
M=D

@R4         // Defining the second input to be R4
D=M
@INPUT2
M=D

// NOTing both inputs for use later
@INPUT1
D=M
@NOT_INPUT1
M=!D

@INPUT2
D=M
@NOT_INPUT2
M=!D

// ANDing INPUT1 and NOT_INPUT2
@INPUT1
D=M
@NOT_INPUT2
D=D&M
@INPUT1_AND_NOT_INPUT2
M=D

// ANDing NOT_INPUT1 and INPUT2
@NOT_INPUT1
D=M
@INPUT2
D=D&M
@NOT_INPUT1_AND_INPUT2
M=D

// ORing to get final product
@INPUT1_AND_NOT_INPUT2
D=M
@NOT_INPUT1_AND_INPUT2
D=D|M

// Output the result
@R5
M=D

(END)
// Jump to the end of the program
@END
0;JMP


