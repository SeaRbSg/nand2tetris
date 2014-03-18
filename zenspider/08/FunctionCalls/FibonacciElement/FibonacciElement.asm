
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
   @1                 // 122
   D=A                // 123
   @R14               // 124
   A=M-D              // 125
   D=M                // 126
   @THAT              // 127
   M=D                // 128
   /// THIS = *(FRAME-2)
   @2                 // 129
   D=A                // 130
   @R14               // 131
   A=M-D              // 132
   D=M                // 133
   @THIS              // 134
   M=D                // 135
   /// ARG = *(FRAME-3)
   @3                 // 136
   D=A                // 137
   @R14               // 138
   A=M-D              // 139
   D=M                // 140
   @ARG               // 141
   M=D                // 142
   /// LCL = *(FRAME-4)
   @4                 // 143
   D=A                // 144
   @R14               // 145
   A=M-D              // 146
   D=M                // 147
   @LCL               // 148
   M=D                // 149
   /// goto RET
   @R13               // 150
   A=M                // 151
   0;JMP              // 152

// label IF_FALSE

(IF_FALSE)

// push argument 0

   @ARG               // 153
   A=M                // 154
   D=M                // 155
   @SP                // 156
   AM=M+1             // 157
   A=A-1              // 158
   M=D                // 159

// push constant 2

   @2                 // 160
   D=A                // 161
   @SP                // 162
   AM=M+1             // 163
   A=A-1              // 164
   M=D                // 165

// sub

   @SP                // 166
   AM=M-1             // 167
   D=M                // 168
   A=A-1              // 169
   A=M                // 170
   D=A-D              // 171
   @SP                // 172
   A=M                // 173
   A=A-1              // 174
   M=D                // 175

// call Main.fibonacci 1

   /// push @return.2
   @return.2          // 176
   D=A                // 177
   @SP                // 178
   AM=M+1             // 179
   A=A-1              // 180
   M=D                // 181
   /// push @LCL
   @LCL               // 182
   D=M                // 183
   @SP                // 184
   AM=M+1             // 185
   A=A-1              // 186
   M=D                // 187
   /// push @ARG
   @ARG               // 188
   D=M                // 189
   @SP                // 190
   AM=M+1             // 191
   A=A-1              // 192
   M=D                // 193
   /// push @THIS
   @THIS              // 194
   D=M                // 195
   @SP                // 196
   AM=M+1             // 197
   A=A-1              // 198
   M=D                // 199
   /// push @THAT
   @THAT              // 200
   D=M                // 201
   @SP                // 202
   AM=M+1             // 203
   A=A-1              // 204
   M=D                // 205
   /// ARG = SP-1-5
   @6                 // 206
   D=A                // 207
   @SP                // 208
   D=M-D              // 209
   @ARG               // 210
   M=D                // 211
   /// LCL = SP
   @SP                // 212
   D=M                // 213
   @LCL               // 214
   M=D                // 215
   /// goto Main.fibonacci
   @Main.fibonacci    // 216
   0;JMP              // 217
(return.2)

// push argument 0

   @ARG               // 218
   A=M                // 219
   D=M                // 220
   @SP                // 221
   AM=M+1             // 222
   A=A-1              // 223
   M=D                // 224

// push constant 1

   @1                 // 225
   D=A                // 226
   @SP                // 227
   AM=M+1             // 228
   A=A-1              // 229
   M=D                // 230

// sub

   @SP                // 231
   AM=M-1             // 232
   D=M                // 233
   A=A-1              // 234
   A=M                // 235
   D=A-D              // 236
   @SP                // 237
   A=M                // 238
   A=A-1              // 239
   M=D                // 240

// call Main.fibonacci 1

   /// push @return.3
   @return.3          // 241
   D=A                // 242
   @SP                // 243
   AM=M+1             // 244
   A=A-1              // 245
   M=D                // 246
   /// push @LCL
   @LCL               // 247
   D=M                // 248
   @SP                // 249
   AM=M+1             // 250
   A=A-1              // 251
   M=D                // 252
   /// push @ARG
   @ARG               // 253
   D=M                // 254
   @SP                // 255
   AM=M+1             // 256
   A=A-1              // 257
   M=D                // 258
   /// push @THIS
   @THIS              // 259
   D=M                // 260
   @SP                // 261
   AM=M+1             // 262
   A=A-1              // 263
   M=D                // 264
   /// push @THAT
   @THAT              // 265
   D=M                // 266
   @SP                // 267
   AM=M+1             // 268
   A=A-1              // 269
   M=D                // 270
   /// ARG = SP-1-5
   @6                 // 271
   D=A                // 272
   @SP                // 273
   D=M-D              // 274
   @ARG               // 275
   M=D                // 276
   /// LCL = SP
   @SP                // 277
   D=M                // 278
   @LCL               // 279
   M=D                // 280
   /// goto Main.fibonacci
   @Main.fibonacci    // 281
   0;JMP              // 282
(return.3)

// add

   @SP                // 283
   AM=M-1             // 284
   D=M                // 285
   A=A-1              // 286
   A=M                // 287
   D=A+D              // 288
   @SP                // 289
   A=M                // 290
   A=A-1              // 291
   M=D                // 292

// return

   /// FRAME = LCL
   @LCL               // 293
   D=M                // 294
   @R14               // 295
   M=D                // 296
   /// 13 = *(FRAME-5)
   @5                 // 297
   D=A                // 298
   @R14               // 299
   A=M-D              // 300
   D=M                // 301
   @13                // 302
   M=D                // 303
   /// *ARG = pop()
   @SP                // 304
   AM=M-1             // 305
   D=M                // 306
   @ARG               // 307
   A=M                // 308
   M=D                // 309
   /// SP = ARG+1
   @ARG               // 310
   D=M+1              // 311
   @SP                // 312
   M=D                // 313
   /// THAT = *(FRAME-1)
   @1                 // 314
   D=A                // 315
   @R14               // 316
   A=M-D              // 317
   D=M                // 318
   @THAT              // 319
   M=D                // 320
   /// THIS = *(FRAME-2)
   @2                 // 321
   D=A                // 322
   @R14               // 323
   A=M-D              // 324
   D=M                // 325
   @THIS              // 326
   M=D                // 327
   /// ARG = *(FRAME-3)
   @3                 // 328
   D=A                // 329
   @R14               // 330
   A=M-D              // 331
   D=M                // 332
   @ARG               // 333
   M=D                // 334
   /// LCL = *(FRAME-4)
   @4                 // 335
   D=A                // 336
   @R14               // 337
   A=M-D              // 338
   D=M                // 339
   @LCL               // 340
   M=D                // 341
   /// goto RET
   @R13               // 342
   A=M                // 343
   0;JMP              // 344

// function Sys.init 0

(Sys.init)

// push constant 4

   @4                 // 345
   D=A                // 346
   @SP                // 347
   AM=M+1             // 348
   A=A-1              // 349
   M=D                // 350

// call Main.fibonacci 1

   /// push @return.4
   @return.4          // 351
   D=A                // 352
   @SP                // 353
   AM=M+1             // 354
   A=A-1              // 355
   M=D                // 356
   /// push @LCL
   @LCL               // 357
   D=M                // 358
   @SP                // 359
   AM=M+1             // 360
   A=A-1              // 361
   M=D                // 362
   /// push @ARG
   @ARG               // 363
   D=M                // 364
   @SP                // 365
   AM=M+1             // 366
   A=A-1              // 367
   M=D                // 368
   /// push @THIS
   @THIS              // 369
   D=M                // 370
   @SP                // 371
   AM=M+1             // 372
   A=A-1              // 373
   M=D                // 374
   /// push @THAT
   @THAT              // 375
   D=M                // 376
   @SP                // 377
   AM=M+1             // 378
   A=A-1              // 379
   M=D                // 380
   /// ARG = SP-1-5
   @6                 // 381
   D=A                // 382
   @SP                // 383
   D=M-D              // 384
   @ARG               // 385
   M=D                // 386
   /// LCL = SP
   @SP                // 387
   D=M                // 388
   @LCL               // 389
   M=D                // 390
   /// goto Main.fibonacci
   @Main.fibonacci    // 391
   0;JMP              // 392
(return.4)

// label WHILE

(WHILE)

// goto @WHILE

   @WHILE             // 393
   0;JMP              // 394
