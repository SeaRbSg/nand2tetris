// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)
// R0 and R1 mult values and R2 sum
// Put your code here.

// Init R2 sum and R3 incrementer
@R2
M=0

@R3
M=0

(LOOP)

// Condition for break
// D = R0 - R3

@R3
D=M

@R0
D=M-D

// Break when interated R0 times
@END
D;JLE

// D=R1
@R1
D=M

// Sum R2 = R2 + R1
@R2
M=D+M

// Increment R3
@R3
M=M+1

@LOOP
0;JMP

(END)

@END
0;JMP // Infinite loop ends program