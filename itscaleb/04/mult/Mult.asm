// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)

// Put your code here.

// Pseudo Code:
// r2 = 0;
// 
// while(r1 > 0)
// {
//   r1 = r1 - 1;
//   r2 = r2 + r0;
// }

// r2 = 0;
	@R2
	M=0

// make sure r0 and r1 are not zero
	@R0
	D=M
	@END
	D;JEQ

	@R1
	D=M
	@END
	D;JEQ

(MULT)
//while(r1 > 0) {
	@R1
	D=M

	@END
	D;JEQ

// r1 = r1 - 1
	@R1
	M=M-1

// r2 = r2 + r0
	@R0
	D=M

	@R2
	M=M+D

	@MULT
	0;JMP
// }

(END)
	@END
	0;JMP
