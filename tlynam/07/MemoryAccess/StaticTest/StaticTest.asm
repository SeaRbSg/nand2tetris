// Push Constant 111
@111
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 333
@333
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 888
@888
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @16 8
@SP
AM=M-1

D=M

@R13
M=D

@16
D=A

@8
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Pop @16 3
@SP
AM=M-1

D=M

@R13
M=D

@16
D=A

@3
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Pop @16 1
@SP
AM=M-1

D=M

@R13
M=D

@16
D=A

@1
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push @16 3
@16
D=A

@3
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Push @16 1
@16
D=A

@1
A=D+A

D=M

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

// Push @16 8
@16
D=A

@8
A=D+A

D=M

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

