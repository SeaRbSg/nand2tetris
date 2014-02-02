// -*- text -*-
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

        @color
        M=0             // color = 0

        @pos
        M=0             // pos = 0

        @RESET
        0;JMP

(TOP)                   // while true do
        @color
        D=M
        @KBD
        D=D-M
        @DRAW
        D;JNE           // goto DRAW if kbd != color

        @TOP
        0;JMP           // goto TOP

(DRAW)
        @KBD
        D=M
        @color
        M=D             // color = kbd

(WORD)                  // begin
        @i
        MD=M-1          // i=i-1

        @SCREEN
        D=D+A           // screen + i
        @pos
        M=D             // pos = screen + i

        @color
        D=M
        @BLACK
        D;JNE

        D=0
        @WHITE
        0;JMP
(BLACK)
        D=-1
(WHITE)

        @pos
        A=M             // *pos
        M=D             //      = color

        @i
        D=M

        @WORD           // end while i > 0
        D;JNE

(RESET)
        @8192           // # of 16 bit words on screen
        D=A
        @i
        M=D             // i = 8192

        @TOP
        0;JMP           // end
