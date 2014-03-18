
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
   @1                 // 119
   D=A                // 120
   @R14               // 121
   A=M-D              // 122
   D=M                // 123
   @THAT              // 124
   M=D                // 125
   /// THIS = *(FRAME-2)
   @2                 // 126
   D=A                // 127
   @R14               // 128
   A=M-D              // 129
   D=M                // 130
   @THIS              // 131
   M=D                // 132
   /// ARG = *(FRAME-3)
   @3                 // 133
   D=A                // 134
   @R14               // 135
   A=M-D              // 136
   D=M                // 137
   @ARG               // 138
   M=D                // 139
   /// LCL = *(FRAME-4)
   @4                 // 140
   D=A                // 141
   @R14               // 142
   A=M-D              // 143
   D=M                // 144
   @LCL               // 145
   M=D                // 146
   /// goto RET
   @R13               // 147
   A=M                // 148
   0;JMP              // 149

// function Class1.get 0

(Class1.get)

// push static 0

   @Class1.0          // 150
   D=M                // 151
   @SP                // 152
   AM=M+1             // 153
   A=A-1              // 154
   M=D                // 155

// push static 1

   @Class1.1          // 156
   D=M                // 157
   @SP                // 158
   AM=M+1             // 159
   A=A-1              // 160
   M=D                // 161

// sub

   @SP                // 162
   AM=M-1             // 163
   D=M                // 164
   A=A-1              // 165
   A=M                // 166
   D=A-D              // 167
   @SP                // 168
   A=M                // 169
   A=A-1              // 170
   M=D                // 171

// return

   /// FRAME = LCL
   @LCL               // 172
   D=M                // 173
   @R14               // 174
   M=D                // 175
   /// 13 = *(FRAME-5)
   @5                 // 176
   D=A                // 177
   @R14               // 178
   A=M-D              // 179
   D=M                // 180
   @13                // 181
   M=D                // 182
   /// *ARG = pop()
   @SP                // 183
   AM=M-1             // 184
   D=M                // 185
   @ARG               // 186
   A=M                // 187
   M=D                // 188
   /// SP = ARG+1
   @ARG               // 189
   D=M+1              // 190
   @SP                // 191
   M=D                // 192
   /// THAT = *(FRAME-1)
   @1                 // 193
   D=A                // 194
   @R14               // 195
   A=M-D              // 196
   D=M                // 197
   @THAT              // 198
   M=D                // 199
   /// THIS = *(FRAME-2)
   @2                 // 200
   D=A                // 201
   @R14               // 202
   A=M-D              // 203
   D=M                // 204
   @THIS              // 205
   M=D                // 206
   /// ARG = *(FRAME-3)
   @3                 // 207
   D=A                // 208
   @R14               // 209
   A=M-D              // 210
   D=M                // 211
   @ARG               // 212
   M=D                // 213
   /// LCL = *(FRAME-4)
   @4                 // 214
   D=A                // 215
   @R14               // 216
   A=M-D              // 217
   D=M                // 218
   @LCL               // 219
   M=D                // 220
   /// goto RET
   @R13               // 221
   A=M                // 222
   0;JMP              // 223

// function Class2.set 0

(Class2.set)

// push argument 0

   @ARG               // 224
   A=M                // 225
   D=M                // 226
   @SP                // 227
   AM=M+1             // 228
   A=A-1              // 229
   M=D                // 230

// pop static 0

   @Class2.0          // 231
   D=A                // 232
   @R15               // 233
   M=D                // 234
   @SP                // 235
   AM=M-1             // 236
   D=M                // 237
   @R15               // 238
   A=M                // 239
   M=D                // 240

// push argument 1

   @ARG               // 241
   A=M+1              // 242
   D=M                // 243
   @SP                // 244
   AM=M+1             // 245
   A=A-1              // 246
   M=D                // 247

// pop static 1

   @Class2.1          // 248
   D=A                // 249
   @R15               // 250
   M=D                // 251
   @SP                // 252
   AM=M-1             // 253
   D=M                // 254
   @R15               // 255
   A=M                // 256
   M=D                // 257

// push constant 0

   @0                 // 258
   D=A                // 259
   @SP                // 260
   AM=M+1             // 261
   A=A-1              // 262
   M=D                // 263

// return

   /// FRAME = LCL
   @LCL               // 264
   D=M                // 265
   @R14               // 266
   M=D                // 267
   /// 13 = *(FRAME-5)
   @5                 // 268
   D=A                // 269
   @R14               // 270
   A=M-D              // 271
   D=M                // 272
   @13                // 273
   M=D                // 274
   /// *ARG = pop()
   @SP                // 275
   AM=M-1             // 276
   D=M                // 277
   @ARG               // 278
   A=M                // 279
   M=D                // 280
   /// SP = ARG+1
   @ARG               // 281
   D=M+1              // 282
   @SP                // 283
   M=D                // 284
   /// THAT = *(FRAME-1)
   @1                 // 285
   D=A                // 286
   @R14               // 287
   A=M-D              // 288
   D=M                // 289
   @THAT              // 290
   M=D                // 291
   /// THIS = *(FRAME-2)
   @2                 // 292
   D=A                // 293
   @R14               // 294
   A=M-D              // 295
   D=M                // 296
   @THIS              // 297
   M=D                // 298
   /// ARG = *(FRAME-3)
   @3                 // 299
   D=A                // 300
   @R14               // 301
   A=M-D              // 302
   D=M                // 303
   @ARG               // 304
   M=D                // 305
   /// LCL = *(FRAME-4)
   @4                 // 306
   D=A                // 307
   @R14               // 308
   A=M-D              // 309
   D=M                // 310
   @LCL               // 311
   M=D                // 312
   /// goto RET
   @R13               // 313
   A=M                // 314
   0;JMP              // 315

// function Class2.get 0

(Class2.get)

// push static 0

   @Class2.0          // 316
   D=M                // 317
   @SP                // 318
   AM=M+1             // 319
   A=A-1              // 320
   M=D                // 321

// push static 1

   @Class2.1          // 322
   D=M                // 323
   @SP                // 324
   AM=M+1             // 325
   A=A-1              // 326
   M=D                // 327

// sub

   @SP                // 328
   AM=M-1             // 329
   D=M                // 330
   A=A-1              // 331
   A=M                // 332
   D=A-D              // 333
   @SP                // 334
   A=M                // 335
   A=A-1              // 336
   M=D                // 337

// return

   /// FRAME = LCL
   @LCL               // 338
   D=M                // 339
   @R14               // 340
   M=D                // 341
   /// 13 = *(FRAME-5)
   @5                 // 342
   D=A                // 343
   @R14               // 344
   A=M-D              // 345
   D=M                // 346
   @13                // 347
   M=D                // 348
   /// *ARG = pop()
   @SP                // 349
   AM=M-1             // 350
   D=M                // 351
   @ARG               // 352
   A=M                // 353
   M=D                // 354
   /// SP = ARG+1
   @ARG               // 355
   D=M+1              // 356
   @SP                // 357
   M=D                // 358
   /// THAT = *(FRAME-1)
   @1                 // 359
   D=A                // 360
   @R14               // 361
   A=M-D              // 362
   D=M                // 363
   @THAT              // 364
   M=D                // 365
   /// THIS = *(FRAME-2)
   @2                 // 366
   D=A                // 367
   @R14               // 368
   A=M-D              // 369
   D=M                // 370
   @THIS              // 371
   M=D                // 372
   /// ARG = *(FRAME-3)
   @3                 // 373
   D=A                // 374
   @R14               // 375
   A=M-D              // 376
   D=M                // 377
   @ARG               // 378
   M=D                // 379
   /// LCL = *(FRAME-4)
   @4                 // 380
   D=A                // 381
   @R14               // 382
   A=M-D              // 383
   D=M                // 384
   @LCL               // 385
   M=D                // 386
   /// goto RET
   @R13               // 387
   A=M                // 388
   0;JMP              // 389

// function Sys.init 0

(Sys.init)

// push constant 6

   @6                 // 390
   D=A                // 391
   @SP                // 392
   AM=M+1             // 393
   A=A-1              // 394
   M=D                // 395

// push constant 8

   @8                 // 396
   D=A                // 397
   @SP                // 398
   AM=M+1             // 399
   A=A-1              // 400
   M=D                // 401

// call Class1.set 2

   /// push @return.2
   @return.2          // 402
   D=A                // 403
   @SP                // 404
   AM=M+1             // 405
   A=A-1              // 406
   M=D                // 407
   /// push @LCL
   @LCL               // 408
   D=M                // 409
   @SP                // 410
   AM=M+1             // 411
   A=A-1              // 412
   M=D                // 413
   /// push @ARG
   @ARG               // 414
   D=M                // 415
   @SP                // 416
   AM=M+1             // 417
   A=A-1              // 418
   M=D                // 419
   /// push @THIS
   @THIS              // 420
   D=M                // 421
   @SP                // 422
   AM=M+1             // 423
   A=A-1              // 424
   M=D                // 425
   /// push @THAT
   @THAT              // 426
   D=M                // 427
   @SP                // 428
   AM=M+1             // 429
   A=A-1              // 430
   M=D                // 431
   /// ARG = SP-2-5
   @7                 // 432
   D=A                // 433
   @SP                // 434
   D=M-D              // 435
   @ARG               // 436
   M=D                // 437
   /// LCL = SP
   @SP                // 438
   D=M                // 439
   @LCL               // 440
   M=D                // 441
   /// goto Class1.set
   @Class1.set        // 442
   0;JMP              // 443
(return.2)

// pop temp 0

   @R5                // 444
   D=A                // 445
   @R15               // 446
   M=D                // 447
   @SP                // 448
   AM=M-1             // 449
   D=M                // 450
   @R15               // 451
   A=M                // 452
   M=D                // 453

// push constant 23

   @23                // 454
   D=A                // 455
   @SP                // 456
   AM=M+1             // 457
   A=A-1              // 458
   M=D                // 459

// push constant 15

   @15                // 460
   D=A                // 461
   @SP                // 462
   AM=M+1             // 463
   A=A-1              // 464
   M=D                // 465

// call Class2.set 2

   /// push @return.3
   @return.3          // 466
   D=A                // 467
   @SP                // 468
   AM=M+1             // 469
   A=A-1              // 470
   M=D                // 471
   /// push @LCL
   @LCL               // 472
   D=M                // 473
   @SP                // 474
   AM=M+1             // 475
   A=A-1              // 476
   M=D                // 477
   /// push @ARG
   @ARG               // 478
   D=M                // 479
   @SP                // 480
   AM=M+1             // 481
   A=A-1              // 482
   M=D                // 483
   /// push @THIS
   @THIS              // 484
   D=M                // 485
   @SP                // 486
   AM=M+1             // 487
   A=A-1              // 488
   M=D                // 489
   /// push @THAT
   @THAT              // 490
   D=M                // 491
   @SP                // 492
   AM=M+1             // 493
   A=A-1              // 494
   M=D                // 495
   /// ARG = SP-2-5
   @7                 // 496
   D=A                // 497
   @SP                // 498
   D=M-D              // 499
   @ARG               // 500
   M=D                // 501
   /// LCL = SP
   @SP                // 502
   D=M                // 503
   @LCL               // 504
   M=D                // 505
   /// goto Class2.set
   @Class2.set        // 506
   0;JMP              // 507
(return.3)

// pop temp 0

   @R5                // 508
   D=A                // 509
   @R15               // 510
   M=D                // 511
   @SP                // 512
   AM=M-1             // 513
   D=M                // 514
   @R15               // 515
   A=M                // 516
   M=D                // 517

// call Class1.get 0

   /// push @return.4
   @return.4          // 518
   D=A                // 519
   @SP                // 520
   AM=M+1             // 521
   A=A-1              // 522
   M=D                // 523
   /// push @LCL
   @LCL               // 524
   D=M                // 525
   @SP                // 526
   AM=M+1             // 527
   A=A-1              // 528
   M=D                // 529
   /// push @ARG
   @ARG               // 530
   D=M                // 531
   @SP                // 532
   AM=M+1             // 533
   A=A-1              // 534
   M=D                // 535
   /// push @THIS
   @THIS              // 536
   D=M                // 537
   @SP                // 538
   AM=M+1             // 539
   A=A-1              // 540
   M=D                // 541
   /// push @THAT
   @THAT              // 542
   D=M                // 543
   @SP                // 544
   AM=M+1             // 545
   A=A-1              // 546
   M=D                // 547
   /// ARG = SP-0-5
   @5                 // 548
   D=A                // 549
   @SP                // 550
   D=M-D              // 551
   @ARG               // 552
   M=D                // 553
   /// LCL = SP
   @SP                // 554
   D=M                // 555
   @LCL               // 556
   M=D                // 557
   /// goto Class1.get
   @Class1.get        // 558
   0;JMP              // 559
(return.4)

// call Class2.get 0

   /// push @return.5
   @return.5          // 560
   D=A                // 561
   @SP                // 562
   AM=M+1             // 563
   A=A-1              // 564
   M=D                // 565
   /// push @LCL
   @LCL               // 566
   D=M                // 567
   @SP                // 568
   AM=M+1             // 569
   A=A-1              // 570
   M=D                // 571
   /// push @ARG
   @ARG               // 572
   D=M                // 573
   @SP                // 574
   AM=M+1             // 575
   A=A-1              // 576
   M=D                // 577
   /// push @THIS
   @THIS              // 578
   D=M                // 579
   @SP                // 580
   AM=M+1             // 581
   A=A-1              // 582
   M=D                // 583
   /// push @THAT
   @THAT              // 584
   D=M                // 585
   @SP                // 586
   AM=M+1             // 587
   A=A-1              // 588
   M=D                // 589
   /// ARG = SP-0-5
   @5                 // 590
   D=A                // 591
   @SP                // 592
   D=M-D              // 593
   @ARG               // 594
   M=D                // 595
   /// LCL = SP
   @SP                // 596
   D=M                // 597
   @LCL               // 598
   M=D                // 599
   /// goto Class2.get
   @Class2.get        // 600
   0;JMP              // 601
(return.5)

// label WHILE

(WHILE)

// goto @WHILE

   @WHILE             // 602
   0;JMP              // 603
