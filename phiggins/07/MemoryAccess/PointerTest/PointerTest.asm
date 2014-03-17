// Parser::PushConstant push constant 3030
@3030
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop pointer 0
          @THIS
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
// Parser::PushConstant push constant 3040
@3040
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop pointer 1
          @THAT
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
// Parser::PushConstant push constant 32
@32
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop this 2
          @THIS
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
// Parser::PushConstant push constant 46
@46
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop that 6
          @THAT
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
// Parser::Push push pointer 0
          @THIS
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
// Parser::Push push pointer 1
          @THAT
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
// Parser::Push push this 2
          @THIS
          D=M
          @2
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
// Parser::Push push that 6
          @THAT
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
