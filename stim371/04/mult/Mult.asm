// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)

// Put your code here.

  @R2
  M=0
(LOOP)
  // add R0 into Data
  @R0
  A=M

  @R2
  MD=D+A
  
  // decrement R1
  @R1
  M=M-1
  
  // if r1 == 0 JMP to END
  @END
  M;JEQ

  // else start the loop over
  @LOOP
  0;JMP
(END)
  @END
  0;JMP