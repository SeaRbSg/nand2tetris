    // point R0 the the first VRAM block
    @16384
    D=A
    @R0
    M=D

(SETUP)
    // clear out the VRAM before we start
    // I believe the simulator always starts with a blank screen, but
    // in the real world you'd want to ensure you have a known initial
    // state, especially given the way I assume that no VRAM block that
    // I didn't touch during this run is filled

    // does D point to the last VRAM block?  If so, set the block
    // pointer to the first block and jump to the main loop
    @R0
    D=M
    @24575
    D=D-A
    @INIT
    D;JEQ

    // otherwise clear the VRAM block
    @R0
    A=M
    M=0

    // and increment the block pointer
    @R0
    M=M+1

    // and keep blanking
    @SETUP
    0;JEQ        // iterate

(INIT)
    // set R0 to 16384 (the first block of VRAM to operate on)
    @16384
    D=A
    @R0
    M=D

(LOOP)
    // branch to FILL or CLEAR based on whether a key is pressed
    @24576
    D=M
    @FILL
    D;JNE
    @CLEAR
    0;JMP

(FILL)
    // set A to the value of R0 (the current VRAM block)
    @R0
    A=M
    // setting a VRAM block to -1 will fill all the pixels of that block
    M=-1

    // are we pointing at the last VRAM block?
    // i.e. is R0 == 24575?
    // if so, just restart the loop
    @R0
    D=M
    @24575
    D=D-A
    @LOOP
    D;JEQ

    // otherwise increment R0
    @R0
    M=M+1

    // and go for another loop iteration
    @LOOP
    0;JEQ        // iterate

(CLEAR)
    // set A to the value of R0 (the current VRAM block)
    @R0
    A=M
    // setting a VRAM block to 0 will clear all the pixels of that block
    M=0

    // are we pointing at the first VRAM block?
    // i.e. is R0 == 16384?
    // if so, just restart the loop
    @R0
    D=M
    @16384
    D=D-A
    @LOOP
    D;JEQ

    // otherwise decrement R0
    @R0
    M=M-1

    // and go for another loop iteration
    @LOOP
    0;JEQ        // iterate
