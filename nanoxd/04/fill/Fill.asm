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
	@screen_pointer
	M=D

	@8192
	D=D+A
	@SCREEN_END
	M=D

	// Set color based on input
	@KBD
	D=M
	@BLANCO
	D;JEQ

	@color
	M=-1

	@DIBUJAR
	0;JMP

(BLANCO)
	@color
	M=0

(DIBUJAR)
	// Go back to init if in last screen memory map
	@screen_pointer
	D=M
	@SCREEN_END
	D=D-M
	@INIT
	D;JEQ

	// Change memory to correct color
	@color
	D=M
	@screen_pointer
	A=M
	M=D

	@screen_pointer
	M=M+1

	@DIBUJAR
	0;JMP
