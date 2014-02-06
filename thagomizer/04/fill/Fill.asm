// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

    @SCREEN       // pIter = SCREEN
    D = A
    @pIter
    M=D

    @8192         // ScreenEnd = SCREEN + 8192
    D = D + A
    @Screen_End
    M = D

    @Black
    M = -1
    
    @White
    M = 0

(LOOP)
    @Screen_End   // If ScreenEnd - pIter <= 0 GOTO END
    D = M
    @pIter
    D = D - M
    @END
    D;JLE

    @Black
    D = M
    @pIter         // M[pIter] = -1
    A = M
    M = D

    @pIter
    M = M + 1


    @LOOP         // GOTO LOOP
    0;JMP


(END)
    @END
    0;JMP
