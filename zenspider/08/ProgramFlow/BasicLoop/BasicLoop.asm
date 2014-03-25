
// push constant 0

   @0
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// pop local 0

   @LCL
   A=M
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// label LOOP_START

(LOOP_START)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push local 0

   @LCL
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

// pop local 0

   @LCL
   A=M
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

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

// pop argument 0

   @ARG
   A=M
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   @SP
   AM=M-1
   D=M
   @LOOP_START
   D;JNE

// push local 0

   @LCL
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
