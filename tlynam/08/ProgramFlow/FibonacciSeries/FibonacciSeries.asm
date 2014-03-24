
// Push @ARG 1

@ARG                          // 0
D=M                           // 1
@1                            // 2
A=D+A                         // 3
D=M                           // 4
@SP                           // 5
A=M                           // 6
M=D                           // 7
@SP                           // 8
M=M+1                         // 9

// Pop @THIS 1

@SP                           // 10
AM=M-1                        // 11
D=M                           // 12
@R13                          // 13
M=D                           // 14
@THIS                         // 15
D=A                           // 16
@1                            // 17
D=D+A                         // 18
@R14                          // 19
M=D                           // 20
@R13                          // 21
D=M                           // 22
@R14                          // 23
A=M                           // 24
M=D                           // 25

// Push Constant 0

@0                            // 26
D=A                           // 27
@SP                           // 28
A=M                           // 29
M=D                           // 30
@SP                           // 31
M=M+1                         // 32

// Pop @THAT 0

@SP                           // 33
AM=M-1                        // 34
D=M                           // 35
@R13                          // 36
M=D                           // 37
@THAT                         // 38
D=M                           // 39
@0                            // 40
D=D+A                         // 41
@R14                          // 42
M=D                           // 43
@R13                          // 44
D=M                           // 45
@R14                          // 46
A=M                           // 47
M=D                           // 48

// Push Constant 1

@1                            // 49
D=A                           // 50
@SP                           // 51
A=M                           // 52
M=D                           // 53
@SP                           // 54
M=M+1                         // 55

// Pop @THAT 1

@SP                           // 56
AM=M-1                        // 57
D=M                           // 58
@R13                          // 59
M=D                           // 60
@THAT                         // 61
D=M                           // 62
@1                            // 63
D=D+A                         // 64
@R14                          // 65
M=D                           // 66
@R13                          // 67
D=M                           // 68
@R14                          // 69
A=M                           // 70
M=D                           // 71

// Push @ARG 0

@ARG                          // 72
D=M                           // 73
@0                            // 74
A=D+A                         // 75
D=M                           // 76
@SP                           // 77
A=M                           // 78
M=D                           // 79
@SP                           // 80
M=M+1                         // 81

// Push Constant 2

@2                            // 82
D=A                           // 83
@SP                           // 84
A=M                           // 85
M=D                           // 86
@SP                           // 87
M=M+1                         // 88

// sub 0 with 2

@SP                           // 89
M=M-1                         // 90
@SP                           // 91
A=M                           // 92
D=M                           // 93
@R13                          // 94
M=D                           // 95
@SP                           // 96
M=M-1                         // 97
@SP                           // 98
A=M                           // 99
D=M                           // 100
@R14                          // 101
M=D                           // 102
@R14                          // 103
D=M                           // 104
@R13                          // 105
D=D-M                         // 106
@SP                           // 107
A=M                           // 108
M=D                           // 109
@R14                          // 110
M=0                           // 111
@R13                          // 112
M=0                           // 113
@SP                           // 114
M=M+1                         // 115

// Pop @ARG 0

@SP                           // 116
AM=M-1                        // 117
D=M                           // 118
@R13                          // 119
M=D                           // 120
@ARG                          // 121
D=M                           // 122
@0                            // 123
D=D+A                         // 124
@R14                          // 125
M=D                           // 126
@R13                          // 127
D=M                           // 128
@R14                          // 129
A=M                           // 130
M=D                           // 131

// Write Label MAIN_LOOP_START


(MAIN_LOOP_START)


// Push @ARG 0

@ARG                          // 132
D=M                           // 133
@0                            // 134
A=D+A                         // 135
D=M                           // 136
@SP                           // 137
A=M                           // 138
M=D                           // 139
@SP                           // 140
M=M+1                         // 141

// Write Label COMPUTE_ELEMENT

@SP                           // 142
M=M-1                         // 143
A=M                           // 144
D=M                           // 145
@COMPUTE_ELEMENT              // 146
D;JGT                         // 147

// Write Label END_PROGRAM

@SP                           // 148
M=M-1                         // 149
A=M                           // 150
D=M                           // 151
@END_PROGRAM                  // 152
D;JMP                         // 153

// Write Label COMPUTE_ELEMENT


(COMPUTE_ELEMENT)


// Push @THAT 0

@THAT                         // 154
D=M                           // 155
@0                            // 156
A=D+A                         // 157
D=M                           // 158
@SP                           // 159
A=M                           // 160
M=D                           // 161
@SP                           // 162
M=M+1                         // 163

// Push @THAT 1

@THAT                         // 164
D=M                           // 165
@1                            // 166
A=D+A                         // 167
D=M                           // 168
@SP                           // 169
A=M                           // 170
M=D                           // 171
@SP                           // 172
M=M+1                         // 173

// add 0 with 1

@SP                           // 174
M=M-1                         // 175
@SP                           // 176
A=M                           // 177
D=M                           // 178
@R13                          // 179
M=D                           // 180
@SP                           // 181
M=M-1                         // 182
@SP                           // 183
A=M                           // 184
D=M                           // 185
@R14                          // 186
M=D                           // 187
@R14                          // 188
D=M                           // 189
@R13                          // 190
D=D+M                         // 191
@SP                           // 192
A=M                           // 193
M=D                           // 194
@R14                          // 195
M=0                           // 196
@R13                          // 197
M=0                           // 198
@SP                           // 199
M=M+1                         // 200

// Pop @THAT 2

@SP                           // 201
AM=M-1                        // 202
D=M                           // 203
@R13                          // 204
M=D                           // 205
@THAT                         // 206
D=M                           // 207
@2                            // 208
D=D+A                         // 209
@R14                          // 210
M=D                           // 211
@R13                          // 212
D=M                           // 213
@R14                          // 214
A=M                           // 215
M=D                           // 216

// Push @THIS 1

@THIS                         // 217
D=A                           // 218
@1                            // 219
A=D+A                         // 220
D=M                           // 221
@SP                           // 222
A=M                           // 223
M=D                           // 224
@SP                           // 225
M=M+1                         // 226

// Push Constant 1

@1                            // 227
D=A                           // 228
@SP                           // 229
A=M                           // 230
M=D                           // 231
@SP                           // 232
M=M+1                         // 233

// add 1 with 1

@SP                           // 234
M=M-1                         // 235
@SP                           // 236
A=M                           // 237
D=M                           // 238
@R13                          // 239
M=D                           // 240
@SP                           // 241
M=M-1                         // 242
@SP                           // 243
A=M                           // 244
D=M                           // 245
@R14                          // 246
M=D                           // 247
@R14                          // 248
D=M                           // 249
@R13                          // 250
D=D+M                         // 251
@SP                           // 252
A=M                           // 253
M=D                           // 254
@R14                          // 255
M=0                           // 256
@R13                          // 257
M=0                           // 258
@SP                           // 259
M=M+1                         // 260

// Pop @THIS 1

@SP                           // 261
AM=M-1                        // 262
D=M                           // 263
@R13                          // 264
M=D                           // 265
@THIS                         // 266
D=A                           // 267
@1                            // 268
D=D+A                         // 269
@R14                          // 270
M=D                           // 271
@R13                          // 272
D=M                           // 273
@R14                          // 274
A=M                           // 275
M=D                           // 276

// Push @ARG 0

@ARG                          // 277
D=M                           // 278
@0                            // 279
A=D+A                         // 280
D=M                           // 281
@SP                           // 282
A=M                           // 283
M=D                           // 284
@SP                           // 285
M=M+1                         // 286

// Push Constant 1

@1                            // 287
D=A                           // 288
@SP                           // 289
A=M                           // 290
M=D                           // 291
@SP                           // 292
M=M+1                         // 293

// sub 0 with 1

@SP                           // 294
M=M-1                         // 295
@SP                           // 296
A=M                           // 297
D=M                           // 298
@R13                          // 299
M=D                           // 300
@SP                           // 301
M=M-1                         // 302
@SP                           // 303
A=M                           // 304
D=M                           // 305
@R14                          // 306
M=D                           // 307
@R14                          // 308
D=M                           // 309
@R13                          // 310
D=D-M                         // 311
@SP                           // 312
A=M                           // 313
M=D                           // 314
@R14                          // 315
M=0                           // 316
@R13                          // 317
M=0                           // 318
@SP                           // 319
M=M+1                         // 320

// Pop @ARG 0

@SP                           // 321
AM=M-1                        // 322
D=M                           // 323
@R13                          // 324
M=D                           // 325
@ARG                          // 326
D=M                           // 327
@0                            // 328
D=D+A                         // 329
@R14                          // 330
M=D                           // 331
@R13                          // 332
D=M                           // 333
@R14                          // 334
A=M                           // 335
M=D                           // 336

// Write Label MAIN_LOOP_START

@SP                           // 337
M=M-1                         // 338
A=M                           // 339
D=M                           // 340
@MAIN_LOOP_START              // 341
D;JMP                         // 342

// Write Label END_PROGRAM


(END_PROGRAM)

