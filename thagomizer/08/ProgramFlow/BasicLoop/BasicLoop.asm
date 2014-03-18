// push constant 0
@0		 // 0
D=A		 // 1
@SP		 // 2
A=M		 // 3
M=D		 // 4
@SP		 // 5
M=M+1		 // 6
// pop local 0
@0		 // 7
D=A		 // 8
@LCL		 // 9
D=M+D		 // 10
@R13		 // 11
M=D		 // 12
@SP		 // 13
AM=M-1		 // 14
D=M		 // 15
@R13		 // 16
A=M		 // 17
M=D		 // 18
// label
(LOOP_START)
// push argument 0
@0		 // 19
D=A		 // 20
@ARG		 // 21
A=M+D		 // 22
D=M		 // 23
@SP		 // 24
A=M		 // 25
M=D		 // 26
@SP		 // 27
M=M+1		 // 28
// push local 0
@0		 // 29
D=A		 // 30
@LCL		 // 31
A=M+D		 // 32
D=M		 // 33
@SP		 // 34
A=M		 // 35
M=D		 // 36
@SP		 // 37
M=M+1		 // 38
// add
@SP		 // 39
AM=M-1		 // 40
D=M		 // 41
@SP		 // 42
AM=M-1		 // 43
A=M		 // 44
D=A+D		 // 45
@SP		 // 46
A=M		 // 47
M=D		 // 48
@SP		 // 49
M=M+1		 // 50
// pop local 0
@0		 // 51
D=A		 // 52
@LCL		 // 53
D=M+D		 // 54
@R13		 // 55
M=D		 // 56
@SP		 // 57
AM=M-1		 // 58
D=M		 // 59
@R13		 // 60
A=M		 // 61
M=D		 // 62
// push argument 0
@0		 // 63
D=A		 // 64
@ARG		 // 65
A=M+D		 // 66
D=M		 // 67
@SP		 // 68
A=M		 // 69
M=D		 // 70
@SP		 // 71
M=M+1		 // 72
// push constant 1
@1		 // 73
D=A		 // 74
@SP		 // 75
A=M		 // 76
M=D		 // 77
@SP		 // 78
M=M+1		 // 79
// sub
@SP		 // 80
AM=M-1		 // 81
D=M		 // 82
@SP		 // 83
AM=M-1		 // 84
A=M		 // 85
D=A-D		 // 86
@SP		 // 87
A=M		 // 88
M=D		 // 89
@SP		 // 90
M=M+1		 // 91
// pop argument 0
@0		 // 92
D=A		 // 93
@ARG		 // 94
D=M+D		 // 95
@R13		 // 96
M=D		 // 97
@SP		 // 98
AM=M-1		 // 99
D=M		 // 100
@R13		 // 101
A=M		 // 102
M=D		 // 103
// push argument 0
@0		 // 104
D=A		 // 105
@ARG		 // 106
A=M+D		 // 107
D=M		 // 108
@SP		 // 109
A=M		 // 110
M=D		 // 111
@SP		 // 112
M=M+1		 // 113
// if-goto
@SP		 // 114
AM=M-1		 // 115
D=M		 // 116
@LOOP_START		 // 117
D;JNE		 // 118
// push local 0
@0		 // 119
D=A		 // 120
@LCL		 // 121
A=M+D		 // 122
D=M		 // 123
@SP		 // 124
A=M		 // 125
M=D		 // 126
@SP		 // 127
M=M+1		 // 128
