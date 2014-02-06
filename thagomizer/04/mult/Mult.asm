// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)


   @R2     // R2 = 0
   M=0

(LOOP)
   @R1     // If R1 <= 0 GOTO END
   D=M
   @END
   D;JLE

   @R0     // R2 = R2 + R0
   D = M
   @R2
   M = M + D

   @R1     // R1 = R1 - 1
   M = M - 1

   @LOOP   // GOTO LOOP
   0;JMP

(END)
   @END
   0;JMP
