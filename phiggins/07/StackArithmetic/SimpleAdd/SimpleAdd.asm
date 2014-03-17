// Parser::PushConstant push constant 7
@7
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::PushConstant push constant 8
@8
D=A
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
