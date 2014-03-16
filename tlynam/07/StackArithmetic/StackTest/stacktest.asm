@17
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@17
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END1
0;JMP

(EQTRUE1)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END1)

@17
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@16
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END2
0;JMP

(EQTRUE2)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END2)

@16
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@17
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END3
0;JMP

(EQTRUE3)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END3)

@892
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@891
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END4
0;JMP

(LTTRUE4)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END4)

@891
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@892
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END5
0;JMP

(LTTRUE5)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END5)

@891
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@891
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END6
0;JMP

(LTTRUE6)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END6)

@32767
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@32766
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END7
0;JMP

(GTTRUE7)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END7)

@32766
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@32767
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END8
0;JMP

(GTTRUE8)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END8)

@32766
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@32766
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
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

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@END9
0;JMP

(GTTRUE9)

@SP
A=M

A
M=0

@R14
M=0

@R13
M=0

@SP
A=M

A
M=-1

@SP
M=M+1

@SP
A=M

A
M=0

(END9)

@57
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@31
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@53
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
D=M

@R14
M=D

@R14
D=M

@R13
D=D+M

@SP
A=M

A
M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@112
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@SP
A=M

A
M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@SP
M=M-1

@SP
A=M

A
M=-D

@SP
M=M+1

@SP
A=M

A
M=0
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
D=M

@R14
M=D

@R14
D=M

@R13
D=D&M

@SP
A=M

A
M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@82
D=A

@SP
A=M

A
M=D

@SP
M=M+1
@SP
M=M-1

@SP
A=M

A
D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

A
D=M

@R14
M=D

@R14
D=M

@R13
D=D|M

@SP
A=M

A
M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

A
M=0

@SP
M=M-1

@SP
A=M

A
M=!D

@SP
M=M+1

@SP
A=M

A
M=0
