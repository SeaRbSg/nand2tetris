// Parser::PushConstant push constant 10
@10
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
// Parser::PushConstant push constant 21
@21
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::PushConstant push constant 22
@22
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop argument 2
          @ARG
          D=M
          @2
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
// Parser::Pop pop argument 1
          @ARG
          D=M
          @1
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
// Parser::PushConstant push constant 36
@36
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop this 6
          @THIS
          D=M
          @6
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
// Parser::PushConstant push constant 42
@42
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::PushConstant push constant 45
@45
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop that 5
          @THAT
          D=M
          @5
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
// Parser::Pop pop that 2
          @THAT
          D=M
          @2
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
// Parser::PushConstant push constant 510
@510
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop temp 6
          @11
          D=A
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
// Parser::Push push that 5
          @THAT
          D=M
          @5
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
// Parser::Push push argument 1
          @ARG
          D=M
          @1
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
// Parser::Push push this 6
          @THIS
          D=M
          @6
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
// Parser::Push push this 6
          @THIS
          D=M
          @6
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
// Parser::Push push temp 6
          @11
          D=A
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
