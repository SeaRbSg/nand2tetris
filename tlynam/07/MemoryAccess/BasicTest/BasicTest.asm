// Push Constant 10
@10
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @LCL 0
@SP
AM=M-1

D=M

@R13
M=D

@LCL
D=M

@0
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push Constant 21
@21
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 22
@22
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @ARG 2
@SP
AM=M-1

D=M

@R13
M=D

@ARG
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

// Pop @ARG 1
@SP
AM=M-1

D=M

@R13
M=D

@ARG
D=M

@1
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push Constant 36
@36
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @THIS 6
@SP
AM=M-1

D=M

@R13
M=D

@THIS
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

// Push Constant 42
@42
D=A

@SP
A=M

M=D

@SP
M=M+1
// Push Constant 45
@45
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @THAT 5
@SP
AM=M-1

D=M

@R13
M=D

@THAT
D=M

@5
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Pop @THAT 2
@SP
AM=M-1

D=M

@R13
M=D

@THAT
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

// Push Constant 510
@510
D=A

@SP
A=M

M=D

@SP
M=M+1
// Pop @R5 6
@SP
AM=M-1

D=M

@R13
M=D

@R5
D=A

@6
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

// Push @LCL 0
@LCL
D=M

@0
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Push @THAT 5
@THAT
D=M

@5
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Add
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

// Push @ARG 1
@ARG
D=M

@1
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Sub
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

// Push @THIS 6
@THIS
D=M

@6
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Push @THIS 6
@THIS
D=M

@6
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Add
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

// Sub
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

// Push @R5 6
@R5
D=A

@6
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

// Add
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

