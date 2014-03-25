
// bootstrap

   /// SP = 256
   @256
   D=A
   @SP
   M=D
   /// set THIS=THAT=LCL=ARG=-1 to force error if used as pointer
   @0
   D=-A
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
   /// goto Sys.init
   @Sys.init
   0;JMP
(return.1)

// label FUCK_IT_BROKE

(FUCK_IT_BROKE)

// goto @FUCK_IT_BROKE

   @FUCK_IT_BROKE
   0;JMP

// function Class1.set 0

(Class1.set)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// pop static 0

   @Class1.0
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// push argument 1

   @ARG
   A=M+1
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// pop static 1

   @Class1.1
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// push constant 0

   @0
   D=A
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
   /// 13 = *(FRAME-5)
   @5
   D=A
   @R14
   A=M-D
   D=M
   @13
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
   /// THAT = *(FRAME-1)
   @R14
   AM=M-1
   D=M
   @THAT
   M=D
   /// THIS = *(FRAME-2)
   @R14
   AM=M-1
   D=M
   @THIS
   M=D
   /// ARG = *(FRAME-3)
   @R14
   AM=M-1
   D=M
   @ARG
   M=D
   /// LCL = *(FRAME-4)
   @R14
   AM=M-1
   D=M
   @LCL
   M=D
   /// goto RET
   @R13
   A=M
   0;JMP

// function Class1.get 0

(Class1.get)

// push static 0

   @Class1.0
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push static 1

   @Class1.1
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
   /// 13 = *(FRAME-5)
   @5
   D=A
   @R14
   A=M-D
   D=M
   @13
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
   /// THAT = *(FRAME-1)
   @R14
   AM=M-1
   D=M
   @THAT
   M=D
   /// THIS = *(FRAME-2)
   @R14
   AM=M-1
   D=M
   @THIS
   M=D
   /// ARG = *(FRAME-3)
   @R14
   AM=M-1
   D=M
   @ARG
   M=D
   /// LCL = *(FRAME-4)
   @R14
   AM=M-1
   D=M
   @LCL
   M=D
   /// goto RET
   @R13
   A=M
   0;JMP

// function Class2.set 0

(Class2.set)

// push argument 0

   @ARG
   A=M
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// pop static 0

   @Class2.0
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// push argument 1

   @ARG
   A=M+1
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// pop static 1

   @Class2.1
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// push constant 0

   @0
   D=A
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
   /// 13 = *(FRAME-5)
   @5
   D=A
   @R14
   A=M-D
   D=M
   @13
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
   /// THAT = *(FRAME-1)
   @R14
   AM=M-1
   D=M
   @THAT
   M=D
   /// THIS = *(FRAME-2)
   @R14
   AM=M-1
   D=M
   @THIS
   M=D
   /// ARG = *(FRAME-3)
   @R14
   AM=M-1
   D=M
   @ARG
   M=D
   /// LCL = *(FRAME-4)
   @R14
   AM=M-1
   D=M
   @LCL
   M=D
   /// goto RET
   @R13
   A=M
   0;JMP

// function Class2.get 0

(Class2.get)

// push static 0

   @Class2.0
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D

// push static 1

   @Class2.1
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
   /// 13 = *(FRAME-5)
   @5
   D=A
   @R14
   A=M-D
   D=M
   @13
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
   /// THAT = *(FRAME-1)
   @R14
   AM=M-1
   D=M
   @THAT
   M=D
   /// THIS = *(FRAME-2)
   @R14
   AM=M-1
   D=M
   @THIS
   M=D
   /// ARG = *(FRAME-3)
   @R14
   AM=M-1
   D=M
   @ARG
   M=D
   /// LCL = *(FRAME-4)
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

// push constant 6

   @6
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// push constant 8

   @8
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// call Class1.set 2

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
   /// ARG = SP-2-5
   @7
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
   /// goto Class1.set
   @Class1.set
   0;JMP
(return.2)

// pop temp 0

   @R5
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// push constant 23

   @23
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// push constant 15

   @15
   D=A
   @SP
   AM=M+1
   A=A-1
   M=D

// call Class2.set 2

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
   /// ARG = SP-2-5
   @7
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
   /// goto Class2.set
   @Class2.set
   0;JMP
(return.3)

// pop temp 0

   @R5
   D=A
   @R15
   M=D
   @SP
   AM=M-1
   D=M
   @R15
   A=M
   M=D

// call Class1.get 0

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
   /// goto Class1.get
   @Class1.get
   0;JMP
(return.4)

// call Class2.get 0

   /// push @return.5
   @return.5
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
   /// goto Class2.get
   @Class2.get
   0;JMP
(return.5)

// label WHILE

(WHILE)

// goto @WHILE

   @WHILE
   0;JMP
