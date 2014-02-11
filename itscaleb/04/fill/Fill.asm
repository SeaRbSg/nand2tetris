// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.

(INIT)
	@SCREEN
	D=A

	@screen_ptr
	M=D

	@8192
	D=D+A

	@SCREEN_END
	M=D

	@KBD
	D=M

	@WHITE
	D;JEQ

	@color
	M=-1

	@DRAW
	0;JMP

(WHITE)
	@color
	M=0

(DRAW)
	@screen_ptr
	D=M
	@SCREEN_END
	D=D-M
	@INIT
	D;JEQ

	@color
	D=M

	@screen_ptr
	A=M
	M=D

	@screen_ptr
	M=M+1

	@DRAW
	0;JMP
