
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

// function Class1.set 0

(Class1.set)

// push argument 0

   @ARG               // 58
   A=M                // 59
   D=M                // 60
   @SP                // 61
   AM=M+1             // 62
   A=A-1              // 63
   M=D                // 64

// pop static 0

   @Class1.0          // 65
   D=A                // 66
   @R15               // 67
   M=D                // 68
   @SP                // 69
   AM=M-1             // 70
   D=M                // 71
   @R15               // 72
   A=M                // 73
   M=D                // 74

// push argument 1

   @ARG               // 75
   A=M+1              // 76
   D=M                // 77
   @SP                // 78
   AM=M+1             // 79
   A=A-1              // 80
   M=D                // 81

// pop static 1

   @Class1.1          // 82
   D=A                // 83
   @R15               // 84
   M=D                // 85
   @SP                // 86
   AM=M-1             // 87
   D=M                // 88
   @R15               // 89
   A=M                // 90
   M=D                // 91

// push constant 0

   @0                 // 92
   D=A                // 93
   @SP                // 94
   AM=M+1             // 95
   A=A-1              // 96
   M=D                // 97

// return

   /// FRAME = LCL
   @LCL               // 98
   D=M                // 99
   @R14               // 100
   M=D                // 101
   /// 13 = *(FRAME-5)
   @5                 // 102
   D=A                // 103
   @R14               // 104
   A=M-D              // 105
   D=M                // 106
   @13                // 107
   M=D                // 108
   /// *ARG = pop()
   @SP                // 109
   AM=M-1             // 110
   D=M                // 111
   @ARG               // 112
   A=M                // 113
   M=D                // 114
   /// SP = ARG+1
   @ARG               // 115
   D=M+1              // 116
   @SP                // 117
   M=D                // 118
   /// THAT = *(FRAME-1)
   @R14               // 119
   AM=M-1             // 120
   D=M                // 121
   @THAT              // 122
   M=D                // 123
   /// THIS = *(FRAME-2)
   @R14               // 124
   AM=M-1             // 125
   D=M                // 126
   @THIS              // 127
   M=D                // 128
   /// ARG = *(FRAME-3)
   @R14               // 129
   AM=M-1             // 130
   D=M                // 131
   @ARG               // 132
   M=D                // 133
   /// LCL = *(FRAME-4)
   @R14               // 134
   AM=M-1             // 135
   D=M                // 136
   @LCL               // 137
   M=D                // 138
   /// goto RET
   @R13               // 139
   A=M                // 140
   0;JMP              // 141

// function Class1.get 0

(Class1.get)

// push static 0

   @Class1.0          // 142
   D=M                // 143
   @SP                // 144
   AM=M+1             // 145
   A=A-1              // 146
   M=D                // 147

// push static 1

   @Class1.1          // 148
   D=M                // 149
   @SP                // 150
   AM=M+1             // 151
   A=A-1              // 152
   M=D                // 153

// sub

   @SP                // 154
   AM=M-1             // 155
   D=M                // 156
   A=A-1              // 157
   A=M                // 158
   D=A-D              // 159
   @SP                // 160
   A=M                // 161
   A=A-1              // 162
   M=D                // 163

// return

   /// FRAME = LCL
   @LCL               // 164
   D=M                // 165
   @R14               // 166
   M=D                // 167
   /// 13 = *(FRAME-5)
   @5                 // 168
   D=A                // 169
   @R14               // 170
   A=M-D              // 171
   D=M                // 172
   @13                // 173
   M=D                // 174
   /// *ARG = pop()
   @SP                // 175
   AM=M-1             // 176
   D=M                // 177
   @ARG               // 178
   A=M                // 179
   M=D                // 180
   /// SP = ARG+1
   @ARG               // 181
   D=M+1              // 182
   @SP                // 183
   M=D                // 184
   /// THAT = *(FRAME-1)
   @R14               // 185
   AM=M-1             // 186
   D=M                // 187
   @THAT              // 188
   M=D                // 189
   /// THIS = *(FRAME-2)
   @R14               // 190
   AM=M-1             // 191
   D=M                // 192
   @THIS              // 193
   M=D                // 194
   /// ARG = *(FRAME-3)
   @R14               // 195
   AM=M-1             // 196
   D=M                // 197
   @ARG               // 198
   M=D                // 199
   /// LCL = *(FRAME-4)
   @R14               // 200
   AM=M-1             // 201
   D=M                // 202
   @LCL               // 203
   M=D                // 204
   /// goto RET
   @R13               // 205
   A=M                // 206
   0;JMP              // 207

// function Class2.set 0

(Class2.set)

// push argument 0

   @ARG               // 208
   A=M                // 209
   D=M                // 210
   @SP                // 211
   AM=M+1             // 212
   A=A-1              // 213
   M=D                // 214

// pop static 0

   @Class2.0          // 215
   D=A                // 216
   @R15               // 217
   M=D                // 218
   @SP                // 219
   AM=M-1             // 220
   D=M                // 221
   @R15               // 222
   A=M                // 223
   M=D                // 224

// push argument 1

   @ARG               // 225
   A=M+1              // 226
   D=M                // 227
   @SP                // 228
   AM=M+1             // 229
   A=A-1              // 230
   M=D                // 231

// pop static 1

   @Class2.1          // 232
   D=A                // 233
   @R15               // 234
   M=D                // 235
   @SP                // 236
   AM=M-1             // 237
   D=M                // 238
   @R15               // 239
   A=M                // 240
   M=D                // 241

// push constant 0

   @0                 // 242
   D=A                // 243
   @SP                // 244
   AM=M+1             // 245
   A=A-1              // 246
   M=D                // 247

// return

   /// FRAME = LCL
   @LCL               // 248
   D=M                // 249
   @R14               // 250
   M=D                // 251
   /// 13 = *(FRAME-5)
   @5                 // 252
   D=A                // 253
   @R14               // 254
   A=M-D              // 255
   D=M                // 256
   @13                // 257
   M=D                // 258
   /// *ARG = pop()
   @SP                // 259
   AM=M-1             // 260
   D=M                // 261
   @ARG               // 262
   A=M                // 263
   M=D                // 264
   /// SP = ARG+1
   @ARG               // 265
   D=M+1              // 266
   @SP                // 267
   M=D                // 268
   /// THAT = *(FRAME-1)
   @R14               // 269
   AM=M-1             // 270
   D=M                // 271
   @THAT              // 272
   M=D                // 273
   /// THIS = *(FRAME-2)
   @R14               // 274
   AM=M-1             // 275
   D=M                // 276
   @THIS              // 277
   M=D                // 278
   /// ARG = *(FRAME-3)
   @R14               // 279
   AM=M-1             // 280
   D=M                // 281
   @ARG               // 282
   M=D                // 283
   /// LCL = *(FRAME-4)
   @R14               // 284
   AM=M-1             // 285
   D=M                // 286
   @LCL               // 287
   M=D                // 288
   /// goto RET
   @R13               // 289
   A=M                // 290
   0;JMP              // 291

// function Class2.get 0

(Class2.get)

// push static 0

   @Class2.0          // 292
   D=M                // 293
   @SP                // 294
   AM=M+1             // 295
   A=A-1              // 296
   M=D                // 297

// push static 1

   @Class2.1          // 298
   D=M                // 299
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

// return

   /// FRAME = LCL
   @LCL               // 314
   D=M                // 315
   @R14               // 316
   M=D                // 317
   /// 13 = *(FRAME-5)
   @5                 // 318
   D=A                // 319
   @R14               // 320
   A=M-D              // 321
   D=M                // 322
   @13                // 323
   M=D                // 324
   /// *ARG = pop()
   @SP                // 325
   AM=M-1             // 326
   D=M                // 327
   @ARG               // 328
   A=M                // 329
   M=D                // 330
   /// SP = ARG+1
   @ARG               // 331
   D=M+1              // 332
   @SP                // 333
   M=D                // 334
   /// THAT = *(FRAME-1)
   @R14               // 335
   AM=M-1             // 336
   D=M                // 337
   @THAT              // 338
   M=D                // 339
   /// THIS = *(FRAME-2)
   @R14               // 340
   AM=M-1             // 341
   D=M                // 342
   @THIS              // 343
   M=D                // 344
   /// ARG = *(FRAME-3)
   @R14               // 345
   AM=M-1             // 346
   D=M                // 347
   @ARG               // 348
   M=D                // 349
   /// LCL = *(FRAME-4)
   @R14               // 350
   AM=M-1             // 351
   D=M                // 352
   @LCL               // 353
   M=D                // 354
   /// goto RET
   @R13               // 355
   A=M                // 356
   0;JMP              // 357

// function Sys.init 0

(Sys.init)

// push constant 6

   @6                 // 358
   D=A                // 359
   @SP                // 360
   AM=M+1             // 361
   A=A-1              // 362
   M=D                // 363

// push constant 8

   @8                 // 364
   D=A                // 365
   @SP                // 366
   AM=M+1             // 367
   A=A-1              // 368
   M=D                // 369

// call Class1.set 2

   /// push @return.2
   @return.2          // 370
   D=A                // 371
   @SP                // 372
   AM=M+1             // 373
   A=A-1              // 374
   M=D                // 375
   /// push @LCL
   @LCL               // 376
   D=M                // 377
   @SP                // 378
   AM=M+1             // 379
   A=A-1              // 380
   M=D                // 381
   /// push @ARG
   @ARG               // 382
   D=M                // 383
   @SP                // 384
   AM=M+1             // 385
   A=A-1              // 386
   M=D                // 387
   /// push @THIS
   @THIS              // 388
   D=M                // 389
   @SP                // 390
   AM=M+1             // 391
   A=A-1              // 392
   M=D                // 393
   /// push @THAT
   @THAT              // 394
   D=M                // 395
   @SP                // 396
   AM=M+1             // 397
   A=A-1              // 398
   M=D                // 399
   /// ARG = SP-2-5
   @7                 // 400
   D=A                // 401
   @SP                // 402
   D=M-D              // 403
   @ARG               // 404
   M=D                // 405
   /// LCL = SP
   @SP                // 406
   D=M                // 407
   @LCL               // 408
   M=D                // 409
   /// goto Class1.set
   @Class1.set        // 410
   0;JMP              // 411
(return.2)

// pop temp 0

   @R5                // 412
   D=A                // 413
   @R15               // 414
   M=D                // 415
   @SP                // 416
   AM=M-1             // 417
   D=M                // 418
   @R15               // 419
   A=M                // 420
   M=D                // 421

// push constant 23

   @23                // 422
   D=A                // 423
   @SP                // 424
   AM=M+1             // 425
   A=A-1              // 426
   M=D                // 427

// push constant 15

   @15                // 428
   D=A                // 429
   @SP                // 430
   AM=M+1             // 431
   A=A-1              // 432
   M=D                // 433

// call Class2.set 2

   /// push @return.3
   @return.3          // 434
   D=A                // 435
   @SP                // 436
   AM=M+1             // 437
   A=A-1              // 438
   M=D                // 439
   /// push @LCL
   @LCL               // 440
   D=M                // 441
   @SP                // 442
   AM=M+1             // 443
   A=A-1              // 444
   M=D                // 445
   /// push @ARG
   @ARG               // 446
   D=M                // 447
   @SP                // 448
   AM=M+1             // 449
   A=A-1              // 450
   M=D                // 451
   /// push @THIS
   @THIS              // 452
   D=M                // 453
   @SP                // 454
   AM=M+1             // 455
   A=A-1              // 456
   M=D                // 457
   /// push @THAT
   @THAT              // 458
   D=M                // 459
   @SP                // 460
   AM=M+1             // 461
   A=A-1              // 462
   M=D                // 463
   /// ARG = SP-2-5
   @7                 // 464
   D=A                // 465
   @SP                // 466
   D=M-D              // 467
   @ARG               // 468
   M=D                // 469
   /// LCL = SP
   @SP                // 470
   D=M                // 471
   @LCL               // 472
   M=D                // 473
   /// goto Class2.set
   @Class2.set        // 474
   0;JMP              // 475
(return.3)

// pop temp 0

   @R5                // 476
   D=A                // 477
   @R15               // 478
   M=D                // 479
   @SP                // 480
   AM=M-1             // 481
   D=M                // 482
   @R15               // 483
   A=M                // 484
   M=D                // 485

// call Class1.get 0

   /// push @return.4
   @return.4          // 486
   D=A                // 487
   @SP                // 488
   AM=M+1             // 489
   A=A-1              // 490
   M=D                // 491
   /// push @LCL
   @LCL               // 492
   D=M                // 493
   @SP                // 494
   AM=M+1             // 495
   A=A-1              // 496
   M=D                // 497
   /// push @ARG
   @ARG               // 498
   D=M                // 499
   @SP                // 500
   AM=M+1             // 501
   A=A-1              // 502
   M=D                // 503
   /// push @THIS
   @THIS              // 504
   D=M                // 505
   @SP                // 506
   AM=M+1             // 507
   A=A-1              // 508
   M=D                // 509
   /// push @THAT
   @THAT              // 510
   D=M                // 511
   @SP                // 512
   AM=M+1             // 513
   A=A-1              // 514
   M=D                // 515
   /// ARG = SP-0-5
   @5                 // 516
   D=A                // 517
   @SP                // 518
   D=M-D              // 519
   @ARG               // 520
   M=D                // 521
   /// LCL = SP
   @SP                // 522
   D=M                // 523
   @LCL               // 524
   M=D                // 525
   /// goto Class1.get
   @Class1.get        // 526
   0;JMP              // 527
(return.4)

// call Class2.get 0

   /// push @return.5
   @return.5          // 528
   D=A                // 529
   @SP                // 530
   AM=M+1             // 531
   A=A-1              // 532
   M=D                // 533
   /// push @LCL
   @LCL               // 534
   D=M                // 535
   @SP                // 536
   AM=M+1             // 537
   A=A-1              // 538
   M=D                // 539
   /// push @ARG
   @ARG               // 540
   D=M                // 541
   @SP                // 542
   AM=M+1             // 543
   A=A-1              // 544
   M=D                // 545
   /// push @THIS
   @THIS              // 546
   D=M                // 547
   @SP                // 548
   AM=M+1             // 549
   A=A-1              // 550
   M=D                // 551
   /// push @THAT
   @THAT              // 552
   D=M                // 553
   @SP                // 554
   AM=M+1             // 555
   A=A-1              // 556
   M=D                // 557
   /// ARG = SP-0-5
   @5                 // 558
   D=A                // 559
   @SP                // 560
   D=M-D              // 561
   @ARG               // 562
   M=D                // 563
   /// LCL = SP
   @SP                // 564
   D=M                // 565
   @LCL               // 566
   M=D                // 567
   /// goto Class2.get
   @Class2.get        // 568
   0;JMP              // 569
(return.5)

// label WHILE

(WHILE)

// goto @WHILE

   @WHILE             // 570
   0;JMP              // 571
