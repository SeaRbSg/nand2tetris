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
// Parser::PushConstant push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop that 0
          @THAT
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
// Parser::PushConstant push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// Parser::Pop pop that 1
          @THAT
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
// Parser::PushConstant push constant 2
@2
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
// Parser::Label label MAIN_LOOP_START
(MAIN_LOOP_START)
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
// Parser::IfGoto if-goto COMPUTE_ELEMENT
@SP
M=M-1
@SP
A=M
D=M
@COMPUTE_ELEMENT
D;JNE
// Parser::Goto goto END_PROGRAM
@END_PROGRAM
0;JMP
// Parser::Label label COMPUTE_ELEMENT
(COMPUTE_ELEMENT)
// Parser::Push push that 0
          @THAT
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
// Parser::Push push that 1
          @THAT
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
// Parser::PushConstant push constant 1
@1
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
// Parser::Goto goto MAIN_LOOP_START
@MAIN_LOOP_START
0;JMP
// Parser::Label label END_PROGRAM
(END_PROGRAM)
