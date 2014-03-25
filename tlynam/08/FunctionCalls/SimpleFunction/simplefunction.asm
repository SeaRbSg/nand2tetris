
// Function SimpleFunction.test + number of locals 2


(SimpleFunction.test)

@2                            // 0
D=A                           // 1
@SP                           // 2
M=D+M                         // 3

// Push @LCL 0

@LCL                          // 4
D=M                           // 5
@0                            // 6
A=D+A                         // 7
D=M                           // 8
@SP                           // 9
A=M                           // 10
M=D                           // 11
@SP                           // 12
M=M+1                         // 13

// Push @LCL 1

@LCL                          // 14
D=M                           // 15
@1                            // 16
A=D+A                         // 17
D=M                           // 18
@SP                           // 19
A=M                           // 20
M=D                           // 21
@SP                           // 22
M=M+1                         // 23

// add 0 with 1

@SP                           // 24
M=M-1                         // 25
@SP                           // 26
A=M                           // 27
D=M                           // 28
@R13                          // 29
M=D                           // 30
@SP                           // 31
M=M-1                         // 32
@SP                           // 33
A=M                           // 34
D=M                           // 35
@R14                          // 36
M=D                           // 37
@R14                          // 38
D=M                           // 39
@R13                          // 40
D=D+M                         // 41
@SP                           // 42
A=M                           // 43
M=D                           // 44
@R14                          // 45
M=0                           // 46
@R13                          // 47
M=0                           // 48
@SP                           // 49
M=M+1                         // 50

// not

@SP                           // 51
M=M-1                         // 52
@SP                           // 53
A=M                           // 54
M=!D                          // 55
@SP                           // 56
M=M+1                         // 57
@SP                           // 58
A=M                           // 59
M=0                           // 60

// Push @ARG 0

@ARG                          // 61
D=M                           // 62
@0                            // 63
A=D+A                         // 64
D=M                           // 65
@SP                           // 66
A=M                           // 67
M=D                           // 68
@SP                           // 69
M=M+1                         // 70

// add 65534 with 0

@SP                           // 71
M=M-1                         // 72
@SP                           // 73
A=M                           // 74
D=M                           // 75
@R13                          // 76
M=D                           // 77
@SP                           // 78
M=M-1                         // 79
@SP                           // 80
A=M                           // 81
D=M                           // 82
@R14                          // 83
M=D                           // 84
@R14                          // 85
D=M                           // 86
@R13                          // 87
D=D+M                         // 88
@SP                           // 89
A=M                           // 90
M=D                           // 91
@R14                          // 92
M=0                           // 93
@R13                          // 94
M=0                           // 95
@SP                           // 96
M=M+1                         // 97

// Push @ARG 1

@ARG                          // 98
D=M                           // 99
@1                            // 100
A=D+A                         // 101
D=M                           // 102
@SP                           // 103
A=M                           // 104
M=D                           // 105
@SP                           // 106
M=M+1                         // 107

// sub 65534 with 1

@SP                           // 108
M=M-1                         // 109
@SP                           // 110
A=M                           // 111
D=M                           // 112
@R13                          // 113
M=D                           // 114
@SP                           // 115
M=M-1                         // 116
@SP                           // 117
A=M                           // 118
D=M                           // 119
@R14                          // 120
M=D                           // 121
@R14                          // 122
D=M                           // 123
@R13                          // 124
D=D-M                         // 125
@SP                           // 126
A=M                           // 127
M=D                           // 128
@R14                          // 129
M=0                           // 130
@R13                          // 131
M=0                           // 132
@SP                           // 133
M=M+1                         // 134

// Write Return


//FRAME = LCL

@LCL                          // 135
D=M                           // 136
@FRAME                        // 137
M=D                           // 138

//ARG = pop()

@ARG                          // 139
D=M                           // 140
@R14                          // 141
M=D                           // 142
@ARG                          // 143
A=M                           // 144
@SP                           // 145
AM=M-1                        // 146
D=M                           // 147
@ARG                          // 148
A=M                           // 149
M=D                           // 150

//SP = ARG+1

@R14                          // 151
D=M                           // 152
@SP                           // 153
M=D+1                         // 154

//THAT = *(FRAME-1)

@FRAME                        // 155
AM=M-1                        // 156
D=M                           // 157
@THAT                         // 158
M=D                           // 159

//THIS = *(FRAME-2)

@FRAME                        // 160
AM=M-1                        // 161
D=M                           // 162
@THIS                         // 163
M=D                           // 164

//ARG = *(FRAME-3)

@FRAME                        // 165
AM=M-1                        // 166
D=M                           // 167
@ARG                          // 168
M=D                           // 169

//LCL = *(FRAME-4)

@FRAME                        // 170
AM=M-1                        // 171
D=M                           // 172
@LCL                          // 173
M=D                           // 174

//RET = *(FRAME-5)

@FRAME                        // 175
AM=M-1                        // 176
D=M                           // 177
@RET                          // 178
M=D                           // 179
