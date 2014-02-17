// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.

// Init counter R0
@R0
M=0

@R1
M=0

(KEYBOARDLOOP)

// Setting R1 to 8192 that is the number of the pixels
// Set R1 to 0 for white, 8192 for black screen

@24576
D=M

@SETWHITE
D;JEQ

@SETBLACK
D;JGT

(SETWHITE)
@R0
M=0
@8192
D=A
@R1
M=D
@SETSCREENWHITE
0;JMP

(SETBLACK)
@R0
M=0
@8192
D=A
@R1
M=D
@SETSCREENBLACK
0;JMP

(SETSCREENWHITE)

@R1
D=M

@R0
D=D-M

// Break when @R1(8192) - R0(Counter) = 0
@KEYBOARDLOOP
D;JLE

@R0
D=M

@SCREEN
D=A+D

D
A=D

D
M=0

// Increment R0
@R0
M=M+1

@SETSCREENWHITE
0;JMP

(SETSCREENBLACK)

@R1
D=M

@R0
D=D-M

// Break when @R1(8192) - R0(Counter) = 0
@KEYBOARDLOOP
D;JLE

@R0
D=M

@SCREEN
D=A+D

D
A=D

D
M=-1

// Increment R0
@R0
M=M+1

@SETSCREENBLACK
0;JMP

@KEYBOARDLOOP
0;JMP