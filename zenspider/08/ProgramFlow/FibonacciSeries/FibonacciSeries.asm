
// push argument 1

   @ARG               // 0
   A=M+1              // 1
   D=M                // 2
   @SP                // 3
   AM=M+1             // 4
   A=A-1              // 5
   M=D                // 6

// pop pointer 1

   @THIS              // 7
   A=A+1              // 8
   D=A                // 9
   @R15               // 10
   M=D                // 11
   @SP                // 12
   AM=M-1             // 13
   D=M                // 14
   @R15               // 15
   A=M                // 16
   M=D                // 17

// push constant 0

   @0                 // 18
   D=A                // 19
   @SP                // 20
   AM=M+1             // 21
   A=A-1              // 22
   M=D                // 23

// pop that 0

   @THAT              // 24
   A=M                // 25
   D=A                // 26
   @R15               // 27
   M=D                // 28
   @SP                // 29
   AM=M-1             // 30
   D=M                // 31
   @R15               // 32
   A=M                // 33
   M=D                // 34

// push constant 1

   @1                 // 35
   D=A                // 36
   @SP                // 37
   AM=M+1             // 38
   A=A-1              // 39
   M=D                // 40

// pop that 1

   @THAT              // 41
   A=M+1              // 42
   D=A                // 43
   @R15               // 44
   M=D                // 45
   @SP                // 46
   AM=M-1             // 47
   D=M                // 48
   @R15               // 49
   A=M                // 50
   M=D                // 51

// push argument 0

   @ARG               // 52
   A=M                // 53
   D=M                // 54
   @SP                // 55
   AM=M+1             // 56
   A=A-1              // 57
   M=D                // 58

// push constant 2

   @2                 // 59
   D=A                // 60
   @SP                // 61
   AM=M+1             // 62
   A=A-1              // 63
   M=D                // 64

// sub

   @SP                // 65
   AM=M-1             // 66
   D=M                // 67
   A=A-1              // 68
   A=M                // 69
   D=A-D              // 70
   @SP                // 71
   A=M                // 72
   A=A-1              // 73
   M=D                // 74

// pop argument 0

   @ARG               // 75
   A=M                // 76
   D=A                // 77
   @R15               // 78
   M=D                // 79
   @SP                // 80
   AM=M-1             // 81
   D=M                // 82
   @R15               // 83
   A=M                // 84
   M=D                // 85

// label MAIN_LOOP_START

(MAIN_LOOP_START)

// push argument 0

   @ARG               // 86
   A=M                // 87
   D=M                // 88
   @SP                // 89
   AM=M+1             // 90
   A=A-1              // 91
   M=D                // 92
   @SP                // 93
   AM=M-1             // 94
   D=M                // 95
   @COMPUTE_ELEMENT   // 96
   D;JNE              // 97

// goto @END_PROGRAM

   @END_PROGRAM       // 98
   0;JMP              // 99

// label COMPUTE_ELEMENT

(COMPUTE_ELEMENT)

// push that 0

   @THAT              // 100
   A=M                // 101
   D=M                // 102
   @SP                // 103
   AM=M+1             // 104
   A=A-1              // 105
   M=D                // 106

// push that 1

   @THAT              // 107
   A=M+1              // 108
   D=M                // 109
   @SP                // 110
   AM=M+1             // 111
   A=A-1              // 112
   M=D                // 113

// add

   @SP                // 114
   AM=M-1             // 115
   D=M                // 116
   A=A-1              // 117
   A=M                // 118
   D=A+D              // 119
   @SP                // 120
   A=M                // 121
   A=A-1              // 122
   M=D                // 123

// pop that 2

   @THAT              // 124
   D=M                // 125
   @2                 // 126
   A=A+D              // 127
   D=A                // 128
   @R15               // 129
   M=D                // 130
   @SP                // 131
   AM=M-1             // 132
   D=M                // 133
   @R15               // 134
   A=M                // 135
   M=D                // 136

// push pointer 1

   @THIS              // 137
   A=A+1              // 138
   D=M                // 139
   @SP                // 140
   AM=M+1             // 141
   A=A-1              // 142
   M=D                // 143

// push constant 1

   @1                 // 144
   D=A                // 145
   @SP                // 146
   AM=M+1             // 147
   A=A-1              // 148
   M=D                // 149

// add

   @SP                // 150
   AM=M-1             // 151
   D=M                // 152
   A=A-1              // 153
   A=M                // 154
   D=A+D              // 155
   @SP                // 156
   A=M                // 157
   A=A-1              // 158
   M=D                // 159

// pop pointer 1

   @THIS              // 160
   A=A+1              // 161
   D=A                // 162
   @R15               // 163
   M=D                // 164
   @SP                // 165
   AM=M-1             // 166
   D=M                // 167
   @R15               // 168
   A=M                // 169
   M=D                // 170

// push argument 0

   @ARG               // 171
   A=M                // 172
   D=M                // 173
   @SP                // 174
   AM=M+1             // 175
   A=A-1              // 176
   M=D                // 177

// push constant 1

   @1                 // 178
   D=A                // 179
   @SP                // 180
   AM=M+1             // 181
   A=A-1              // 182
   M=D                // 183

// sub

   @SP                // 184
   AM=M-1             // 185
   D=M                // 186
   A=A-1              // 187
   A=M                // 188
   D=A-D              // 189
   @SP                // 190
   A=M                // 191
   A=A-1              // 192
   M=D                // 193

// pop argument 0

   @ARG               // 194
   A=M                // 195
   D=A                // 196
   @R15               // 197
   M=D                // 198
   @SP                // 199
   AM=M-1             // 200
   D=M                // 201
   @R15               // 202
   A=M                // 203
   M=D                // 204

// goto @MAIN_LOOP_START

   @MAIN_LOOP_START   // 205
   0;JMP              // 206

// label END_PROGRAM

(END_PROGRAM)
