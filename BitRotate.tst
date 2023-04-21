// This file is adapted from www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/mult/Mult.tst

load BitRotate.asm,
output-file BitRotate.out,
output-list RAM[5]%D2.6.2;

set RAM[3] 128,   // Set test arguments tests a rotate MSB 0
set RAM[4] 2,
set RAM[5] 0,
repeat 200 {
  ticktock;
}
output;