// Initialize variables
@R3 // address of original number
D=M
@INPUT // address of input variable
M=D

@R4 // address of number of rotations
D=M
@ROTATION // address of rotation variable
M=D

// Rotate left
@INPUT // address of input variable
D=M
@ROTATION // address of rotation variable
@TEMP // address of temporary variable
M=0
(LOOP)
@ROTATION
D=D-1 // decrement rotation counter
D;JLT // if counter < 0, exit loop
D=D+D // multiply by 2 (shift left by 1 bit)
@TEMP
D=D|M // bitwise OR with LSB of temporary variable
@LOOP
0;JMP

@R5 // address of output variable
M=D

(END)
// End of program