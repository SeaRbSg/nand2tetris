// R0 points the the current block of video RAM to operate on
// 16384 <= R0 => 24575

    // set R0 to 16384
    @16384
    D=A
    @R0
    M=D

(LOOP)
    // set D to 65535 (all bits of a VRAM block filled)
    @32767
    D=A
    // set A to the value of R0 (the current VRAM block)
    @R0
    A=M
    // set the current VRAM block to all bits filled
    M=D

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