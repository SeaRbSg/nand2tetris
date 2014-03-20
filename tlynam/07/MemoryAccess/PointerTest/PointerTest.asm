// Push Constant 3030
@3030
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @THIS 0
@SP
AM=M-1

D=M

@R13
M=D

@THIS
D=A

@0
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push Constant 3040
@3040
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @THIS 1
@SP
AM=M-1

D=M

@R13
M=D

@THIS
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

// Push Constant 32
@32
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @THIS 2
@SP
AM=M-1

D=M

@R13
M=D

@THIS
D=M

@2
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push Constant 46
@46
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @THAT 6
@SP
AM=M-1

D=M

@R13
M=D

@THAT
D=M

@6
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push @THIS 0
@THIS
D=A

@0
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Push @THIS 1
@THIS
D=A

@1
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

// Push @THIS 2
@THIS
D=M

@2
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

// Push @THAT 6
@THAT
D=M

@6
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

