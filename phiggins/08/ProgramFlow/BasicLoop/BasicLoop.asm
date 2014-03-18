// Parser::PushConstant push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop local 0
          @LCL
          D=M
          @0
          D=D+A
          @R15
          M=D

@SP
M=M-1
@SP
A=M
D=M
@R15
A=M
M=D
// Parser::Label label LOOP_START
(LOOP_START)
// Parser::Push push argument 0
          @ARG
          D=M
          @0
          D=D+A
          @R15
          M=D

@R15
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// Parser::Push push local 0
          @LCL
          D=M
          @0
          D=D+A
          @R15
          M=D

@R15
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// Parser::BinaryOp add
@SP
M=M-1
@SP
A=M
D=M
@R15
M=D
@SP
M=M-1
@SP
A=M
D=M
@R15
D=D+M
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop local 0
          @LCL
          D=M
          @0
          D=D+A
          @R15
          M=D

@SP
M=M-1
@SP
A=M
D=M
@R15
A=M
M=D
// Parser::Push push argument 0
          @ARG
          D=M
          @0
          D=D+A
          @R15
          M=D

@R15
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// Parser::PushConstant push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::BinaryOp sub
@SP
M=M-1
@SP
A=M
D=M
@R15
M=D
@SP
M=M-1
@SP
A=M
D=M
@R15
D=D-M
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop argument 0
          @ARG
          D=M
          @0
          D=D+A
          @R15
          M=D

@SP
M=M-1
@SP
A=M
D=M
@R15
A=M
M=D
// Parser::Push push argument 0
          @ARG
          D=M
          @0
          D=D+A
          @R15
          M=D

@R15
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// Parser::IfGoto if-goto LOOP_START
@SP
M=M-1
@SP
A=M
D=M
@LOOP_START
D;JNE
// Parser::Push push local 0
          @LCL
          D=M
          @0
          D=D+A
          @R15
          M=D

@R15
A=M
D=M
@SP
A=M
M=D
@SP
M=M+1
