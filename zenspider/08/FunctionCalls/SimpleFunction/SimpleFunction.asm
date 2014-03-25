
// function SimpleFunction.test 2

(SimpleFunction.test)
   @SP
   AM=M+1
   A=A-1
   M=0
   @SP
   AM=M+1
   A=A-1
   M=0

// push local 0

   @LCL
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push local 1

   @LCL
   A=M+1
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

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

// not

   @SP
   A=M-1
   M=!M

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

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

// push argument 1

   @ARG
   A=M+1
   D=M
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
