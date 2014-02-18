// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

(LOOP)
// reset the loop counter
@8192 // 32 words * 256 rows
D=A
@i
M=D

(DRAW)
// If KBD == 0, start clearing the screen.
@KBD
D=M
@CLEAR
D;JEQ

// Set the current word.
@SCREEN
D=A
@i
D=D+M

A=D
M=-1

@END
0;JMP

(CLEAR)
// Clear the current word.
@SCREEN
D=A
@i
D=D+M

A=D
M=0

(END)
// When we've gone through the whole screen, jump to the top and repeat.
@i
M=M-1
@i
D=M
@LOOP
D;JLT
@DRAW
0;JMP
