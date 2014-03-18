// push argument 1
@1		 // 0
D=A		 // 1
@ARG		 // 2
A=M+D		 // 3
D=M		 // 4
@SP		 // 5
A=M		 // 6
M=D		 // 7
@SP		 // 8
M=M+1		 // 9
// pop pointer 1
@SP		 // 10
AM=M-1		 // 11
D=M		 // 12
@4		 // 13
M=D		 // 14
// push constant 0
@0		 // 15
D=A		 // 16
@SP		 // 17
A=M		 // 18
M=D		 // 19
@SP		 // 20
M=M+1		 // 21
// pop that 0
@0		 // 22
D=A		 // 23
@THAT		 // 24
D=M+D		 // 25
@R13		 // 26
M=D		 // 27
@SP		 // 28
AM=M-1		 // 29
D=M		 // 30
@R13		 // 31
A=M		 // 32
M=D		 // 33
// push constant 1
@1		 // 34
D=A		 // 35
@SP		 // 36
A=M		 // 37
M=D		 // 38
@SP		 // 39
M=M+1		 // 40
// pop that 1
@1		 // 41
D=A		 // 42
@THAT		 // 43
D=M+D		 // 44
@R13		 // 45
M=D		 // 46
@SP		 // 47
AM=M-1		 // 48
D=M		 // 49
@R13		 // 50
A=M		 // 51
M=D		 // 52
// push argument 0
@0		 // 53
D=A		 // 54
@ARG		 // 55
A=M+D		 // 56
D=M		 // 57
@SP		 // 58
A=M		 // 59
M=D		 // 60
@SP		 // 61
M=M+1		 // 62
// push constant 2
@2		 // 63
D=A		 // 64
@SP		 // 65
A=M		 // 66
M=D		 // 67
@SP		 // 68
M=M+1		 // 69
// sub
@SP		 // 70
AM=M-1		 // 71
D=M		 // 72
@SP		 // 73
AM=M-1		 // 74
A=M		 // 75
D=A-D		 // 76
@SP		 // 77
A=M		 // 78
M=D		 // 79
@SP		 // 80
M=M+1		 // 81
// pop argument 0
@0		 // 82
D=A		 // 83
@ARG		 // 84
D=M+D		 // 85
@R13		 // 86
M=D		 // 87
@SP		 // 88
AM=M-1		 // 89
D=M		 // 90
@R13		 // 91
A=M		 // 92
M=D		 // 93
// label
(MAIN_LOOP_START)
// push argument 0
@0		 // 94
D=A		 // 95
@ARG		 // 96
A=M+D		 // 97
D=M		 // 98
@SP		 // 99
A=M		 // 100
M=D		 // 101
@SP		 // 102
M=M+1		 // 103
// if-goto
@SP		 // 104
AM=M-1		 // 105
D=M		 // 106
@COMPUTE_ELEMENT		 // 107
D;JNE		 // 108
// goto
@END_PROGRAM		 // 109
0;JMP		 // 110
// label
(COMPUTE_ELEMENT)
// push that 0
@0		 // 111
D=A		 // 112
@THAT		 // 113
A=M+D		 // 114
D=M		 // 115
@SP		 // 116
A=M		 // 117
M=D		 // 118
@SP		 // 119
M=M+1		 // 120
// push that 1
@1		 // 121
D=A		 // 122
@THAT		 // 123
A=M+D		 // 124
D=M		 // 125
@SP		 // 126
A=M		 // 127
M=D		 // 128
@SP		 // 129
M=M+1		 // 130
// add
@SP		 // 131
AM=M-1		 // 132
D=M		 // 133
@SP		 // 134
AM=M-1		 // 135
A=M		 // 136
D=A+D		 // 137
@SP		 // 138
A=M		 // 139
M=D		 // 140
@SP		 // 141
M=M+1		 // 142
// pop that 2
@2		 // 143
D=A		 // 144
@THAT		 // 145
D=M+D		 // 146
@R13		 // 147
M=D		 // 148
@SP		 // 149
AM=M-1		 // 150
D=M		 // 151
@R13		 // 152
A=M		 // 153
M=D		 // 154
// push pointer 1
@4		 // 155
D=M		 // 156
@SP		 // 157
A=M		 // 158
M=D		 // 159
@SP		 // 160
M=M+1		 // 161
// push constant 1
@1		 // 162
D=A		 // 163
@SP		 // 164
A=M		 // 165
M=D		 // 166
@SP		 // 167
M=M+1		 // 168
// add
@SP		 // 169
AM=M-1		 // 170
D=M		 // 171
@SP		 // 172
AM=M-1		 // 173
A=M		 // 174
D=A+D		 // 175
@SP		 // 176
A=M		 // 177
M=D		 // 178
@SP		 // 179
M=M+1		 // 180
// pop pointer 1
@SP		 // 181
AM=M-1		 // 182
D=M		 // 183
@4		 // 184
M=D		 // 185
// push argument 0
@0		 // 186
D=A		 // 187
@ARG		 // 188
A=M+D		 // 189
D=M		 // 190
@SP		 // 191
A=M		 // 192
M=D		 // 193
@SP		 // 194
M=M+1		 // 195
// push constant 1
@1		 // 196
D=A		 // 197
@SP		 // 198
A=M		 // 199
M=D		 // 200
@SP		 // 201
M=M+1		 // 202
// sub
@SP		 // 203
AM=M-1		 // 204
D=M		 // 205
@SP		 // 206
AM=M-1		 // 207
A=M		 // 208
D=A-D		 // 209
@SP		 // 210
A=M		 // 211
M=D		 // 212
@SP		 // 213
M=M+1		 // 214
// pop argument 0
@0		 // 215
D=A		 // 216
@ARG		 // 217
D=M+D		 // 218
@R13		 // 219
M=D		 // 220
@SP		 // 221
AM=M-1		 // 222
D=M		 // 223
@R13		 // 224
A=M		 // 225
M=D		 // 226
// goto
@MAIN_LOOP_START		 // 227
0;JMP		 // 228
// label
(END_PROGRAM)
