
// push constant 17

   @17                // 0
   D=A                // 1
   @SP                // 2
   AM=M+1             // 3
   A=A-1              // 4
   M=D                // 5

// push constant 17

   @17                // 6
   D=A                // 7
   @SP                // 8
   AM=M+1             // 9
   A=A-1              // 10
   M=D                // 11

// eq

   @SP                // 12
   AM=M-1             // 13
   D=M                // 14
   A=A-1              // 15
   A=M                // 16
   D=A-D              // 17
   @JEQ.1             // 18
   D;JEQ              // 19
   D=0                // 20
   @JEQ.1.done        // 21
   0;JMP              // 22
   (JEQ.1)            // 23
   D=-1               // 24
   (JEQ.1.done)       // 25
   @SP                // 26
   A=M                // 27
   A=A-1              // 28
   M=D                // 29

// push constant 17

   @17                // 30
   D=A                // 31
   @SP                // 32
   AM=M+1             // 33
   A=A-1              // 34
   M=D                // 35

// push constant 16

   @16                // 36
   D=A                // 37
   @SP                // 38
   AM=M+1             // 39
   A=A-1              // 40
   M=D                // 41

// eq

   @SP                // 42
   AM=M-1             // 43
   D=M                // 44
   A=A-1              // 45
   A=M                // 46
   D=A-D              // 47
   @JEQ.2             // 48
   D;JEQ              // 49
   D=0                // 50
   @JEQ.2.done        // 51
   0;JMP              // 52
   (JEQ.2)            // 53
   D=-1               // 54
   (JEQ.2.done)       // 55
   @SP                // 56
   A=M                // 57
   A=A-1              // 58
   M=D                // 59

// push constant 16

   @16                // 60
   D=A                // 61
   @SP                // 62
   AM=M+1             // 63
   A=A-1              // 64
   M=D                // 65

// push constant 17

   @17                // 66
   D=A                // 67
   @SP                // 68
   AM=M+1             // 69
   A=A-1              // 70
   M=D                // 71

// eq

   @SP                // 72
   AM=M-1             // 73
   D=M                // 74
   A=A-1              // 75
   A=M                // 76
   D=A-D              // 77
   @JEQ.3             // 78
   D;JEQ              // 79
   D=0                // 80
   @JEQ.3.done        // 81
   0;JMP              // 82
   (JEQ.3)            // 83
   D=-1               // 84
   (JEQ.3.done)       // 85
   @SP                // 86
   A=M                // 87
   A=A-1              // 88
   M=D                // 89

// push constant 892

   @892               // 90
   D=A                // 91
   @SP                // 92
   AM=M+1             // 93
   A=A-1              // 94
   M=D                // 95

// push constant 891

   @891               // 96
   D=A                // 97
   @SP                // 98
   AM=M+1             // 99
   A=A-1              // 100
   M=D                // 101

// lt

   @SP                // 102
   AM=M-1             // 103
   D=M                // 104
   A=A-1              // 105
   A=M                // 106
   D=A-D              // 107
   @JLT.1             // 108
   D;JLT              // 109
   D=0                // 110
   @JLT.1.done        // 111
   0;JMP              // 112
   (JLT.1)            // 113
   D=-1               // 114
   (JLT.1.done)       // 115
   @SP                // 116
   A=M                // 117
   A=A-1              // 118
   M=D                // 119

// push constant 891

   @891               // 120
   D=A                // 121
   @SP                // 122
   AM=M+1             // 123
   A=A-1              // 124
   M=D                // 125

// push constant 892

   @892               // 126
   D=A                // 127
   @SP                // 128
   AM=M+1             // 129
   A=A-1              // 130
   M=D                // 131

// lt

   @SP                // 132
   AM=M-1             // 133
   D=M                // 134
   A=A-1              // 135
   A=M                // 136
   D=A-D              // 137
   @JLT.2             // 138
   D;JLT              // 139
   D=0                // 140
   @JLT.2.done        // 141
   0;JMP              // 142
   (JLT.2)            // 143
   D=-1               // 144
   (JLT.2.done)       // 145
   @SP                // 146
   A=M                // 147
   A=A-1              // 148
   M=D                // 149

// push constant 891

   @891               // 150
   D=A                // 151
   @SP                // 152
   AM=M+1             // 153
   A=A-1              // 154
   M=D                // 155

// push constant 891

   @891               // 156
   D=A                // 157
   @SP                // 158
   AM=M+1             // 159
   A=A-1              // 160
   M=D                // 161

// lt

   @SP                // 162
   AM=M-1             // 163
   D=M                // 164
   A=A-1              // 165
   A=M                // 166
   D=A-D              // 167
   @JLT.3             // 168
   D;JLT              // 169
   D=0                // 170
   @JLT.3.done        // 171
   0;JMP              // 172
   (JLT.3)            // 173
   D=-1               // 174
   (JLT.3.done)       // 175
   @SP                // 176
   A=M                // 177
   A=A-1              // 178
   M=D                // 179

// push constant 32767

   @32767             // 180
   D=A                // 181
   @SP                // 182
   AM=M+1             // 183
   A=A-1              // 184
   M=D                // 185

// push constant 32766

   @32766             // 186
   D=A                // 187
   @SP                // 188
   AM=M+1             // 189
   A=A-1              // 190
   M=D                // 191

// gt

   @SP                // 192
   AM=M-1             // 193
   D=M                // 194
   A=A-1              // 195
   A=M                // 196
   D=A-D              // 197
   @JGT.1             // 198
   D;JGT              // 199
   D=0                // 200
   @JGT.1.done        // 201
   0;JMP              // 202
   (JGT.1)            // 203
   D=-1               // 204
   (JGT.1.done)       // 205
   @SP                // 206
   A=M                // 207
   A=A-1              // 208
   M=D                // 209

// push constant 32766

   @32766             // 210
   D=A                // 211
   @SP                // 212
   AM=M+1             // 213
   A=A-1              // 214
   M=D                // 215

// push constant 32767

   @32767             // 216
   D=A                // 217
   @SP                // 218
   AM=M+1             // 219
   A=A-1              // 220
   M=D                // 221

// gt

   @SP                // 222
   AM=M-1             // 223
   D=M                // 224
   A=A-1              // 225
   A=M                // 226
   D=A-D              // 227
   @JGT.2             // 228
   D;JGT              // 229
   D=0                // 230
   @JGT.2.done        // 231
   0;JMP              // 232
   (JGT.2)            // 233
   D=-1               // 234
   (JGT.2.done)       // 235
   @SP                // 236
   A=M                // 237
   A=A-1              // 238
   M=D                // 239

// push constant 32766

   @32766             // 240
   D=A                // 241
   @SP                // 242
   AM=M+1             // 243
   A=A-1              // 244
   M=D                // 245

// push constant 32766

   @32766             // 246
   D=A                // 247
   @SP                // 248
   AM=M+1             // 249
   A=A-1              // 250
   M=D                // 251

// gt

   @SP                // 252
   AM=M-1             // 253
   D=M                // 254
   A=A-1              // 255
   A=M                // 256
   D=A-D              // 257
   @JGT.3             // 258
   D;JGT              // 259
   D=0                // 260
   @JGT.3.done        // 261
   0;JMP              // 262
   (JGT.3)            // 263
   D=-1               // 264
   (JGT.3.done)       // 265
   @SP                // 266
   A=M                // 267
   A=A-1              // 268
   M=D                // 269

// push constant 57

   @57                // 270
   D=A                // 271
   @SP                // 272
   AM=M+1             // 273
   A=A-1              // 274
   M=D                // 275

// push constant 31

   @31                // 276
   D=A                // 277
   @SP                // 278
   AM=M+1             // 279
   A=A-1              // 280
   M=D                // 281

// push constant 53

   @53                // 282
   D=A                // 283
   @SP                // 284
   AM=M+1             // 285
   A=A-1              // 286
   M=D                // 287

// add

   @SP                // 288
   AM=M-1             // 289
   D=M                // 290
   A=A-1              // 291
   A=M                // 292
   D=A+D              // 293
   @SP                // 294
   A=M                // 295
   A=A-1              // 296
   M=D                // 297

// push constant 112

   @112               // 298
   D=A                // 299
   @SP                // 300
   AM=M+1             // 301
   A=A-1              // 302
   M=D                // 303

// sub

   @SP                // 304
   AM=M-1             // 305
   D=M                // 306
   A=A-1              // 307
   A=M                // 308
   D=A-D              // 309
   @SP                // 310
   A=M                // 311
   A=A-1              // 312
   M=D                // 313

// neg

   @SP                // 314
   A=M-1              // 315
   M=-M               // 316

// and

   @SP                // 317
   AM=M-1             // 318
   D=M                // 319
   A=A-1              // 320
   A=M                // 321
   D=A&D              // 322
   @SP                // 323
   A=M                // 324
   A=A-1              // 325
   M=D                // 326

// push constant 82

   @82                // 327
   D=A                // 328
   @SP                // 329
   AM=M+1             // 330
   A=A-1              // 331
   M=D                // 332

// or

   @SP                // 333
   AM=M-1             // 334
   D=M                // 335
   A=A-1              // 336
   A=M                // 337
   D=A|D              // 338
   @SP                // 339
   A=M                // 340
   A=A-1              // 341
   M=D                // 342

// not

   @SP                // 343
   A=M-1              // 344
   M=!M               // 345
