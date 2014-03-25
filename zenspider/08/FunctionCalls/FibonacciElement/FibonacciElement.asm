
// bootstrap

   /// SP = 256
   @256
   D=A
   @SP
   M=D
   /// set THIS=THAT=LCL=ARG=-1 to force error if used as pointer
   D=-1
   @THIS
   M=D
   @THAT
   M=D
   @LCL
   M=D
   @ARG
   M=D

// call Sys.init 0

   /// push @return.1
   @return.1
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @LCL
   @LCL
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @ARG
   @ARG
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THIS
   @THIS
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THAT
   @THAT
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// ARG = SP-0-5
   @5
   D=A
   @SP
   D=M-D
   @ARG
   M=D
   /// LCL = SP
   @SP
   D=M
   @LCL
   M=D
   /// goto @Sys.init
   @Sys.init
   0;JMP
(return.1)

// label FUCK_IT_BROKE.1

(FUCK_IT_BROKE.1)

// goto @FUCK_IT_BROKE.1

   @FUCK_IT_BROKE.1
   0;JMP

// function Main.fibonacci 0

(Main.fibonacci)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push constant 2

   @2
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// lt

   @SP
   AM=M-1
   D=M
   A=A-1
   A=M
   D=A-D
   @JLT.1
   D;JLT
   D=0
   @JLT.1.done
   0;JMP
(JLT.1)
   D=-1
(JLT.1.done)
   @SP
   A=M
   A=A-1
   M=D
   @SP
   AM=M-1
   D=M
   @IF_TRUE
   D;JNE

// goto @IF_FALSE

   @IF_FALSE
   0;JMP

// label IF_TRUE

(IF_TRUE)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// return

   /// FRAME = LCL
   @LCL
   D=M
   @R14
   M=D
   /// @R13 = *(FRAME-5)
   @5
   D=A
   @R14
   A=M-D
   D=M
   @R13
   M=D
   /// *ARG = pop()
   @SP
   AM=M-1
   D=M
   @ARG
   A=M
   M=D
   /// SP = ARG+1
   @ARG
   D=M+1
   @SP
   M=D
   /// @THAT = *(FRAME-1)
   @R14
   AM=M-1
   D=M
   @THAT
   M=D
   /// @THIS = *(FRAME-2)
   @R14
   AM=M-1
   D=M
   @THIS
   M=D
   /// @ARG = *(FRAME-3)
   @R14
   AM=M-1
   D=M
   @ARG
   M=D
   /// @LCL = *(FRAME-4)
   @R14
   AM=M-1
   D=M
   @LCL
   M=D
   /// goto RET
   @R13
   A=M
   0;JMP

// label IF_FALSE

(IF_FALSE)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push constant 2

   @2
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// sub

   @SP
   AM=M-1
   D=M
   A=A-1
   A=M
   D=A-D
   @SP
   A=M
   A=A-1
   M=D

// call Main.fibonacci 1

   /// push @return.2
   @return.2
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @LCL
   @LCL
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @ARG
   @ARG
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THIS
   @THIS
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THAT
   @THAT
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// ARG = SP-1-5
   @6
   D=A
   @SP
   D=M-D
   @ARG
   M=D
   /// LCL = SP
   @SP
   D=M
   @LCL
   M=D
   /// goto @Main.fibonacci
   @Main.fibonacci
   0;JMP
(return.2)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push constant 1

   @1
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// sub

   @SP
   AM=M-1
   D=M
   A=A-1
   A=M
   D=A-D
   @SP
   A=M
   A=A-1
   M=D

// call Main.fibonacci 1

   /// push @return.3
   @return.3
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @LCL
   @LCL
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @ARG
   @ARG
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THIS
   @THIS
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THAT
   @THAT
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// ARG = SP-1-5
   @6
   D=A
   @SP
   D=M-D
   @ARG
   M=D
   /// LCL = SP
   @SP
   D=M
   @LCL
   M=D
   /// goto @Main.fibonacci
   @Main.fibonacci
   0;JMP
(return.3)

// add

   @SP
   AM=M-1
   D=M
   A=A-1
   A=M
   D=A+D
   @SP
   A=M
   A=A-1
   M=D

// return

   /// FRAME = LCL
   @LCL
   D=M
   @R14
   M=D
   /// @R13 = *(FRAME-5)
   @5
   D=A
   @R14
   A=M-D
   D=M
   @R13
   M=D
   /// *ARG = pop()
   @SP
   AM=M-1
   D=M
   @ARG
   A=M
   M=D
   /// SP = ARG+1
   @ARG
   D=M+1
   @SP
   M=D
   /// @THAT = *(FRAME-1)
   @R14
   AM=M-1
   D=M
   @THAT
   M=D
   /// @THIS = *(FRAME-2)
   @R14
   AM=M-1
   D=M
   @THIS
   M=D
   /// @ARG = *(FRAME-3)
   @R14
   AM=M-1
   D=M
   @ARG
   M=D
   /// @LCL = *(FRAME-4)
   @R14
   AM=M-1
   D=M
   @LCL
   M=D
   /// goto RET
   @R13
   A=M
   0;JMP

// function Sys.init 0

(Sys.init)

// push constant 4

   @4
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// call Main.fibonacci 1

   /// push @return.4
   @return.4
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @LCL
   @LCL
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @ARG
   @ARG
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THIS
   @THIS
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// push @THAT
   @THAT
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   /// ARG = SP-1-5
   @6
   D=A
   @SP
   D=M-D
   @ARG
   M=D
   /// LCL = SP
   @SP
   D=M
   @LCL
   M=D
   /// goto @Main.fibonacci
   @Main.fibonacci
   0;JMP
(return.4)

// label WHILE

(WHILE)

// goto @WHILE

   @WHILE
   0;JMP
