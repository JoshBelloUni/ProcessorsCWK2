// This file is adapted from www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/mult/Mult.tst

load XOR.asm,
output-file XOR.out,
compare-to XOR.cmp,
output-list RAM[5]%D2.6.2;

set RAM[3] 5,   // Set test arguments
set RAM[4] 10,
set RAM[5] 0,
repeat 100 {
  ticktock;
}
output;
