
// bootstrap

   /// SP = 256
   @256               // 0
   D=A                // 1
   @SP                // 2
   M=D                // 3
   /// set THIS=THAT=LCL=ARG=-1 to force error if used as pointer
   @0                 // 4
   D=-A               // 5
   @THIS              // 6
   M=D                // 7
   @THAT              // 8
   M=D                // 9
   @LCL               // 10
   M=D                // 11
   @ARG               // 12
   M=D                // 13

// call Sys.init 0

   /// push @return.1
   @return.1          // 14
   D=A                // 15
   @SP                // 16
   AM=M+1             // 17
   A=A-1              // 18
   M=D                // 19
   /// push @LCL
   @LCL               // 20
   D=M                // 21
   @SP                // 22
   AM=M+1             // 23
   A=A-1              // 24
   M=D                // 25
   /// push @ARG
   @ARG               // 26
   D=M                // 27
   @SP                // 28
   AM=M+1             // 29
   A=A-1              // 30
   M=D                // 31
   /// push @THIS
   @THIS              // 32
   D=M                // 33
   @SP                // 34
   AM=M+1             // 35
   A=A-1              // 36
   M=D                // 37
   /// push @THAT
   @THAT              // 38
   D=M                // 39
   @SP                // 40
   AM=M+1             // 41
   A=A-1              // 42
   M=D                // 43
   /// ARG = SP-0-5
   @5                 // 44
   D=A                // 45
   @SP                // 46
   D=M-D              // 47
   @ARG               // 48
   M=D                // 49
   /// LCL = SP
   @SP                // 50
   D=M                // 51
   @LCL               // 52
   M=D                // 53
   /// goto Sys.init
   @Sys.init          // 54
   0;JMP              // 55
(return.1)

// label FUCK_IT_BROKE

(FUCK_IT_BROKE)

// goto @FUCK_IT_BROKE

   @FUCK_IT_BROKE     // 56
   0;JMP              // 57

// function Main.fibonacci 0

(Main.fibonacci)

// push argument 0

   @ARG               // 58
   A=M                // 59
   D=M                // 60
   @SP                // 61
   AM=M+1             // 62
   A=A-1              // 63
   M=D                // 64

// push constant 2

   @2                 // 65
   D=A                // 66
   @SP                // 67
   AM=M+1             // 68
   A=A-1              // 69
   M=D                // 70

// lt

   @SP                // 71
   AM=M-1             // 72
   D=M                // 73
   A=A-1              // 74
   A=M                // 75
   D=A-D              // 76
   @JLT.1             // 77
   D;JLT              // 78
   D=0                // 79
   @JLT.1.done        // 80
   0;JMP              // 81
(JLT.1)
   D=-1               // 82
(JLT.1.done)
   @SP                // 83
   A=M                // 84
   A=A-1              // 85
   M=D                // 86
   @SP                // 87
   AM=M-1             // 88
   D=M                // 89
   @IF_TRUE           // 90
   D;JNE              // 91

// goto @IF_FALSE

   @IF_FALSE          // 92
   0;JMP              // 93

// label IF_TRUE

(IF_TRUE)

// push argument 0

   @ARG               // 94
   A=M                // 95
   D=M                // 96
   @SP                // 97
   AM=M+1             // 98
   A=A-1              // 99
   M=D                // 100

// return

   /// FRAME = LCL
   @LCL               // 101
   D=M                // 102
   @R14               // 103
   M=D                // 104
   /// 13 = *(FRAME-5)
   @5                 // 105
   D=A                // 106
   @R14               // 107
   A=M-D              // 108
   D=M                // 109
   @13                // 110
   M=D                // 111
   /// *ARG = pop()
   @SP                // 112
   AM=M-1             // 113
   D=M                // 114
   @ARG               // 115
   A=M                // 116
   M=D                // 117
   /// SP = ARG+1
   @ARG               // 118
   D=M+1              // 119
   @SP                // 120
   M=D                // 121
   /// THAT = *(FRAME-1)
   @R14               // 122
   AM=M-1             // 123
   D=M                // 124
   @THAT              // 125
   M=D                // 126
   /// THIS = *(FRAME-2)
   @R14               // 127
   AM=M-1             // 128
   D=M                // 129
   @THIS              // 130
   M=D                // 131
   /// ARG = *(FRAME-3)
   @R14               // 132
   AM=M-1             // 133
   D=M                // 134
   @ARG               // 135
   M=D                // 136
   /// LCL = *(FRAME-4)
   @R14               // 137
   AM=M-1             // 138
   D=M                // 139
   @LCL               // 140
   M=D                // 141
   /// goto RET
   @R13               // 142
   A=M                // 143
   0;JMP              // 144

// label IF_FALSE

(IF_FALSE)

// push argument 0

   @ARG               // 145
   A=M                // 146
   D=M                // 147
   @SP                // 148
   AM=M+1             // 149
   A=A-1              // 150
   M=D                // 151

// push constant 2

   @2                 // 152
   D=A                // 153
   @SP                // 154
   AM=M+1             // 155
   A=A-1              // 156
   M=D                // 157

// sub

   @SP                // 158
   AM=M-1             // 159
   D=M                // 160
   A=A-1              // 161
   A=M                // 162
   D=A-D              // 163
   @SP                // 164
   A=M                // 165
   A=A-1              // 166
   M=D                // 167

// call Main.fibonacci 1

   /// push @return.2
   @return.2          // 168
   D=A                // 169
   @SP                // 170
   AM=M+1             // 171
   A=A-1              // 172
   M=D                // 173
   /// push @LCL
   @LCL               // 174
   D=M                // 175
   @SP                // 176
   AM=M+1             // 177
   A=A-1              // 178
   M=D                // 179
   /// push @ARG
   @ARG               // 180
   D=M                // 181
   @SP                // 182
   AM=M+1             // 183
   A=A-1              // 184
   M=D                // 185
   /// push @THIS
   @THIS              // 186
   D=M                // 187
   @SP                // 188
   AM=M+1             // 189
   A=A-1              // 190
   M=D                // 191
   /// push @THAT
   @THAT              // 192
   D=M                // 193
   @SP                // 194
   AM=M+1             // 195
   A=A-1              // 196
   M=D                // 197
   /// ARG = SP-1-5
   @6                 // 198
   D=A                // 199
   @SP                // 200
   D=M-D              // 201
   @ARG               // 202
   M=D                // 203
   /// LCL = SP
   @SP                // 204
   D=M                // 205
   @LCL               // 206
   M=D                // 207
   /// goto Main.fibonacci
   @Main.fibonacci    // 208
   0;JMP              // 209
(return.2)

// push argument 0

   @ARG               // 210
   A=M                // 211
   D=M                // 212
   @SP                // 213
   AM=M+1             // 214
   A=A-1              // 215
   M=D                // 216

// push constant 1

   @1                 // 217
   D=A                // 218
   @SP                // 219
   AM=M+1             // 220
   A=A-1              // 221
   M=D                // 222

// sub

   @SP                // 223
   AM=M-1             // 224
   D=M                // 225
   A=A-1              // 226
   A=M                // 227
   D=A-D              // 228
   @SP                // 229
   A=M                // 230
   A=A-1              // 231
   M=D                // 232

// call Main.fibonacci 1

   /// push @return.3
   @return.3          // 233
   D=A                // 234
   @SP                // 235
   AM=M+1             // 236
   A=A-1              // 237
   M=D                // 238
   /// push @LCL
   @LCL               // 239
   D=M                // 240
   @SP                // 241
   AM=M+1             // 242
   A=A-1              // 243
   M=D                // 244
   /// push @ARG
   @ARG               // 245
   D=M                // 246
   @SP                // 247
   AM=M+1             // 248
   A=A-1              // 249
   M=D                // 250
   /// push @THIS
   @THIS              // 251
   D=M                // 252
   @SP                // 253
   AM=M+1             // 254
   A=A-1              // 255
   M=D                // 256
   /// push @THAT
   @THAT              // 257
   D=M                // 258
   @SP                // 259
   AM=M+1             // 260
   A=A-1              // 261
   M=D                // 262
   /// ARG = SP-1-5
   @6                 // 263
   D=A                // 264
   @SP                // 265
   D=M-D              // 266
   @ARG               // 267
   M=D                // 268
   /// LCL = SP
   @SP                // 269
   D=M                // 270
   @LCL               // 271
   M=D                // 272
   /// goto Main.fibonacci
   @Main.fibonacci    // 273
   0;JMP              // 274
(return.3)

// add

   @SP                // 275
   AM=M-1             // 276
   D=M                // 277
   A=A-1              // 278
   A=M                // 279
   D=A+D              // 280
   @SP                // 281
   A=M                // 282
   A=A-1              // 283
   M=D                // 284

// return

   /// FRAME = LCL
   @LCL               // 285
   D=M                // 286
   @R14               // 287
   M=D                // 288
   /// 13 = *(FRAME-5)
   @5                 // 289
   D=A                // 290
   @R14               // 291
   A=M-D              // 292
   D=M                // 293
   @13                // 294
   M=D                // 295
   /// *ARG = pop()
   @SP                // 296
   AM=M-1             // 297
   D=M                // 298
   @ARG               // 299
   A=M                // 300
   M=D                // 301
   /// SP = ARG+1
   @ARG               // 302
   D=M+1              // 303
   @SP                // 304
   M=D                // 305
   /// THAT = *(FRAME-1)
   @R14               // 306
   AM=M-1             // 307
   D=M                // 308
   @THAT              // 309
   M=D                // 310
   /// THIS = *(FRAME-2)
   @R14               // 311
   AM=M-1             // 312
   D=M                // 313
   @THIS              // 314
   M=D                // 315
   /// ARG = *(FRAME-3)
   @R14               // 316
   AM=M-1             // 317
   D=M                // 318
   @ARG               // 319
   M=D                // 320
   /// LCL = *(FRAME-4)
   @R14               // 321
   AM=M-1             // 322
   D=M                // 323
   @LCL               // 324
   M=D                // 325
   /// goto RET
   @R13               // 326
   A=M                // 327
   0;JMP              // 328

// function Sys.init 0

(Sys.init)

// push constant 4

   @4                 // 329
   D=A                // 330
   @SP                // 331
   AM=M+1             // 332
   A=A-1              // 333
   M=D                // 334

// call Main.fibonacci 1

   /// push @return.4
   @return.4          // 335
   D=A                // 336
   @SP                // 337
   AM=M+1             // 338
   A=A-1              // 339
   M=D                // 340
   /// push @LCL
   @LCL               // 341
   D=M                // 342
   @SP                // 343
   AM=M+1             // 344
   A=A-1              // 345
   M=D                // 346
   /// push @ARG
   @ARG               // 347
   D=M                // 348
   @SP                // 349
   AM=M+1             // 350
   A=A-1              // 351
   M=D                // 352
   /// push @THIS
   @THIS              // 353
   D=M                // 354
   @SP                // 355
   AM=M+1             // 356
   A=A-1              // 357
   M=D                // 358
   /// push @THAT
   @THAT              // 359
   D=M                // 360
   @SP                // 361
   AM=M+1             // 362
   A=A-1              // 363
   M=D                // 364
   /// ARG = SP-1-5
   @6                 // 365
   D=A                // 366
   @SP                // 367
   D=M-D              // 368
   @ARG               // 369
   M=D                // 370
   /// LCL = SP
   @SP                // 371
   D=M                // 372
   @LCL               // 373
   M=D                // 374
   /// goto Main.fibonacci
   @Main.fibonacci    // 375
   0;JMP              // 376
(return.4)

// label WHILE

(WHILE)

// goto @WHILE

   @WHILE             // 377
   0;JMP              // 378
