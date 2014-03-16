
// push constant 10

   @10                // 0
   D=A                // 1
   @SP                // 2
   AM=M+1             // 3
   A=A-1              // 4
   M=D                // 5

// pop local 0

   @LCL               // 6
   A=M                // 7
   D=A                // 8
   @R15               // 9
   M=D                // 10
   @SP                // 11
   AM=M-1             // 12
   D=M                // 13
   @R15               // 14
   A=M                // 15
   M=D                // 16

// push constant 21

   @21                // 17
   D=A                // 18
   @SP                // 19
   AM=M+1             // 20
   A=A-1              // 21
   M=D                // 22

// push constant 22

   @22                // 23
   D=A                // 24
   @SP                // 25
   AM=M+1             // 26
   A=A-1              // 27
   M=D                // 28

// pop argument 2

   @ARG               // 29
   D=M                // 30
   @2                 // 31
   A=A+D              // 32
   D=A                // 33
   @R15               // 34
   M=D                // 35
   @SP                // 36
   AM=M-1             // 37
   D=M                // 38
   @R15               // 39
   A=M                // 40
   M=D                // 41

// pop argument 1

   @ARG               // 42
   A=M+1              // 43
   D=A                // 44
   @R15               // 45
   M=D                // 46
   @SP                // 47
   AM=M-1             // 48
   D=M                // 49
   @R15               // 50
   A=M                // 51
   M=D                // 52

// push constant 36

   @36                // 53
   D=A                // 54
   @SP                // 55
   AM=M+1             // 56
   A=A-1              // 57
   M=D                // 58

// pop this 6

   @THIS              // 59
   D=M                // 60
   @6                 // 61
   A=A+D              // 62
   D=A                // 63
   @R15               // 64
   M=D                // 65
   @SP                // 66
   AM=M-1             // 67
   D=M                // 68
   @R15               // 69
   A=M                // 70
   M=D                // 71

// push constant 42

   @42                // 72
   D=A                // 73
   @SP                // 74
   AM=M+1             // 75
   A=A-1              // 76
   M=D                // 77

// push constant 45

   @45                // 78
   D=A                // 79
   @SP                // 80
   AM=M+1             // 81
   A=A-1              // 82
   M=D                // 83

// pop that 5

   @THAT              // 84
   D=M                // 85
   @5                 // 86
   A=A+D              // 87
   D=A                // 88
   @R15               // 89
   M=D                // 90
   @SP                // 91
   AM=M-1             // 92
   D=M                // 93
   @R15               // 94
   A=M                // 95
   M=D                // 96

// pop that 2

   @THAT              // 97
   D=M                // 98
   @2                 // 99
   A=A+D              // 100
   D=A                // 101
   @R15               // 102
   M=D                // 103
   @SP                // 104
   AM=M-1             // 105
   D=M                // 106
   @R15               // 107
   A=M                // 108
   M=D                // 109

// push constant 510

   @510               // 110
   D=A                // 111
   @SP                // 112
   AM=M+1             // 113
   A=A-1              // 114
   M=D                // 115

// pop temp 6

   @R11               // 116
   D=A                // 117
   @R15               // 118
   M=D                // 119
   @SP                // 120
   AM=M-1             // 121
   D=M                // 122
   @R15               // 123
   A=M                // 124
   M=D                // 125

// push local 0

   @LCL               // 126
   A=M                // 127
   D=M                // 128
   @SP                // 129
   AM=M+1             // 130
   A=A-1              // 131
   M=D                // 132

// push that 5

   @THAT              // 133
   D=M                // 134
   @5                 // 135
   A=A+D              // 136
   D=M                // 137
   @SP                // 138
   AM=M+1             // 139
   A=A-1              // 140
   M=D                // 141

// add

   @SP                // 142
   AM=M-1             // 143
   D=M                // 144
   A=A-1              // 145
   A=M                // 146
   D=A+D              // 147
   @SP                // 148
   A=M                // 149
   A=A-1              // 150
   M=D                // 151

// push argument 1

   @ARG               // 152
   A=M+1              // 153
   D=M                // 154
   @SP                // 155
   AM=M+1             // 156
   A=A-1              // 157
   M=D                // 158

// sub

   @SP                // 159
   AM=M-1             // 160
   D=M                // 161
   A=A-1              // 162
   A=M                // 163
   D=A-D              // 164
   @SP                // 165
   A=M                // 166
   A=A-1              // 167
   M=D                // 168

// push this 6

   @THIS              // 169
   D=M                // 170
   @6                 // 171
   A=A+D              // 172
   D=M                // 173
   @SP                // 174
   AM=M+1             // 175
   A=A-1              // 176
   M=D                // 177

// push this 6

   @THIS              // 178
   D=M                // 179
   @6                 // 180
   A=A+D              // 181
   D=M                // 182
   @SP                // 183
   AM=M+1             // 184
   A=A-1              // 185
   M=D                // 186

// add

   @SP                // 187
   AM=M-1             // 188
   D=M                // 189
   A=A-1              // 190
   A=M                // 191
   D=A+D              // 192
   @SP                // 193
   A=M                // 194
   A=A-1              // 195
   M=D                // 196

// sub

   @SP                // 197
   AM=M-1             // 198
   D=M                // 199
   A=A-1              // 200
   A=M                // 201
   D=A-D              // 202
   @SP                // 203
   A=M                // 204
   A=A-1              // 205
   M=D                // 206

// push temp 6

   @R11               // 207
   D=M                // 208
   @SP                // 209
   AM=M+1             // 210
   A=A-1              // 211
   M=D                // 212

// add

   @SP                // 213
   AM=M-1             // 214
   D=M                // 215
   A=A-1              // 216
   A=M                // 217
   D=A+D              // 218
   @SP                // 219
   A=M                // 220
   A=A-1              // 221
   M=D                // 222
