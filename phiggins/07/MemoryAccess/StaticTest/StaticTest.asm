// Parser::PushConstant push constant 111
@111
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::PushConstant push constant 333
@333
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::PushConstant push constant 888
@888
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop static 8
          @static
          D=M
          @8
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
// Parser::Pop pop static 3
          @static
          D=M
          @3
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
// Parser::Pop pop static 1
          @static
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
// Parser::Push push static 3
          @static
          D=M
          @3
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
// Parser::Push push static 1
          @static
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
// Parser::Push push static 8
          @static
          D=M
          @8
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
