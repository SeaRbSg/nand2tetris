// R0 points the the current block of video RAM to operate on
// 16384 <= R0 => 24575

    // set R0 to 16384
    @16384
    D=A
    @R0
    M=D

(LOOP)
    // set A to the value of R0 (the current VRAM block)
    @R0
    A=M
    // setting a VRAM block to -1 will fill all the pixels of that block
    M=-1

    // are we pointing at the last VRAM block?
    // i.e. is R0 == 24575?
    // if so, jump to @END
    @R0
    D=M
    @24575
    D=D-A
    @END
    D;JEQ

    // otherwise increment R0
    @R0
    M=M+1

    // and go for another loop iteration
    @LOOP
    0;JEQ        // iterate

(END)
    // infinite loop back to @END to finish the program
    @END
    0;JEQ