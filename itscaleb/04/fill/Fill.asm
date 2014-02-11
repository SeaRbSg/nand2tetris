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

	@curr_pixel
	M=D

	@8192
	D=D+A

	@SCREEN_END
	M=D

	@KBD
	D=M

	@KEY_NOT_PRESSED
	D;JEQ

(KEY_PRESSED)
	@curr_pixel
	D=M
	@SCREEN_END
	D=D-M
	@INIT
	D;JEQ

	@curr_pixel
	A=M
	M=-1

	@curr_pixel
	M=M+1

	@KEY_PRESSED
	0;JMP

(KEY_NOT_PRESSED)
	@curr_pixel
	D=M
	@SCREEN_END
	D=D-M
	@INIT
	D;JEQ

	@curr_pixel
	A=M
	M=0

	@curr_pixel
	M=M+1

	@KEY_NOT_PRESSED
	0;JMP
