// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)

    @R2         // clear out R2 to be safe
    M=0
(LOOP)
    @R1
    D=M         // set D to the value of R1
    @END
    D;JEQ       // jump to @END if D(R1) is 0

    @R0
    D=M         // set D to the value of R0

    @R2
    M=D+M       // set D to the value of R0 + the value of R2

    @R1
    M=M-1       // decrement the value of R1 by 1

    @LOOP
    0;JMP       // jump to @LOOP unconditionally
(END)
    @END
    0;JMP       // jump to @END unconditionally
