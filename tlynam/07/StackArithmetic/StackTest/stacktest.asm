// Push Constant 17
@17
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 17
@17
D=A

@SP
A=M

M=D

@SP
M=M+1
// eq
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@EQTRUE1
D;JEQ

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END1
0;JMP

(EQTRUE1)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END1)
// Push Constant 17
@17
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 16
@16
D=A

@SP
A=M

M=D

@SP
M=M+1
// eq
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@EQTRUE2
D;JEQ

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END2
0;JMP

(EQTRUE2)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END2)
// Push Constant 16
@16
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 17
@17
D=A

@SP
A=M

M=D

@SP
M=M+1
// eq
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@EQTRUE3
D;JEQ

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END3
0;JMP

(EQTRUE3)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END3)
// Push Constant 892
@892
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 891
@891
D=A

@SP
A=M

M=D

@SP
M=M+1
// lt
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@LTTRUE4
D;JLT

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END4
0;JMP

(LTTRUE4)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END4)
// Push Constant 891
@891
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 892
@892
D=A

@SP
A=M

M=D

@SP
M=M+1
// lt
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@LTTRUE5
D;JLT

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END5
0;JMP

(LTTRUE5)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END5)
// Push Constant 891
@891
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 891
@891
D=A

@SP
A=M

M=D

@SP
M=M+1
// lt
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@LTTRUE6
D;JLT

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END6
0;JMP

(LTTRUE6)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END6)
// Push Constant 32767
@32767
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 32766
@32766
D=A

@SP
A=M

M=D

@SP
M=M+1
// gt
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@GTTRUE7
D;JGT

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END7
0;JMP

(GTTRUE7)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END7)
// Push Constant 32766
@32766
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 32767
@32767
D=A

@SP
A=M

M=D

@SP
M=M+1
// gt
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@GTTRUE8
D;JGT

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END8
0;JMP

(GTTRUE8)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END8)
// Push Constant 32766
@32766
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 32766
@32766
D=A

@SP
A=M

M=D

@SP
M=M+1
// gt
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@GTTRUE9
D;JGT

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END9
0;JMP

(GTTRUE9)

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END9)
// Push Constant 57
@57
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 31
@31
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 53
@53
D=A

@SP
A=M

M=D

@SP
M=M+1
// add
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D+M

@SP
A=M

M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

M=0

// Push Constant 112
@112
D=A

@SP
A=M

M=D

@SP
M=M+1
// sub
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@SP
A=M

M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

M=0

// neg
@SP
M=M-1

@SP
A=M

M=-D

@SP
M=M+1

@SP
A=M

M=0
// and
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D&M

@SP
A=M

M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

M=0

// Push Constant 82
@82
D=A

@SP
A=M

M=D

@SP
M=M+1
// or
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D|M

@SP
A=M

M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

M=0

// not
@SP
M=M-1

@SP
A=M

M=!D

@SP
M=M+1

@SP
A=M

M=0
