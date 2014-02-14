// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)
// R0 and R1 mult values and R2 sum
// Put your code here.

// Init R2 Sum and i Incrementer
@R2
M=0

@R3
M=0

@R0
D=M

// R4 = R0
@R4
M=D

@R1
D=M

// R5 = R1
@R5
M=D

(LOOP)

@R3
D=M

// D = R0 - incremental variable R3
@R4
D=M-D

// Break when interated through R0 times
@END
D;JLE

// D=R1
@R5
D=M

// Sum R2 = R2 + R1
@R2
M=D+M

@R3
M=M+1

@LOOP
0;JMP

(END)

@END
0;JMP // Infinite loop ends program