// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.


(START)
    @SCREEN       // ScreenEnd = SCREEN + 8192
    D = A
    @8192         
    D = D + A
    @Screen_End
    M = D

    @Color
    M = 0

(RESET_ITER)

    @SCREEN       // pIter = SCREEN
    D = A
    @pIter
    M=D

(DECIDE)
    @KBD
    D = M
    @SET_BLACK
    D;JGT

(SET_WHITE)
    @Color
    M = 0
    @DRAW
    0;JMP    

(SET_BLACK)
    @Color
    M = -1
    @DRAW
    0;JMP    

(DRAW)
    @Screen_End    // If ScreenEnd - pIter <= 0 GOTO END
    D = M
    @pIter
    D = D - M
    @RESET_ITER
    D;JLE

    @Color
    D = M
    @pIter         // M[pIter] = -1
    A = M
    M = D

    @pIter
    M = M + 1

    @DECIDE          // GOTO DECIDE
    0;JMP

(END)
   @END
   0;JMP
