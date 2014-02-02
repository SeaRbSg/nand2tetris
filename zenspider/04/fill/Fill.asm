// -*- text -*-
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

        @last
        M=0             // last = 0

        @RESET
        0;JMP

(TOP)                   // while true do
        @last
        D=M
        @KBD
        D=D-M
        @DRAW
        D;JNE           // goto DRAW if kbd != last

        @TOP
        0;JMP           // goto TOP

(DRAW)
        @KBD
        D=M
        @last
        M=D             // last = kbd

(WORD)                  // begin
        @last           // if last
        D=M
        @BLACK
        D;JNE

        D=0             //   then color =  0
        @WHITE
        0;JMP
(BLACK)
        D=-1            //   else color = -1
(WHITE)

        @pos
        A=M             // *pos
        M=D             //      = color

        @pos
        MD=M+1          // pos=pos+1
        @24575          // 24575 = 0x4000 + 0x2000 - 1 (start of screen + size)
        D=A-D
        @WORD           // repeat if pos < size of screen
        D;JGE

(RESET)
        @SCREEN
        D=A
        @pos
        M=D             // pos = SCREEN (address, not value)

        @TOP
        0;JMP           // end
