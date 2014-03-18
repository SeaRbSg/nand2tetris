
// function SimpleFunction.test 2

(SimpleFunction.test)
   @SP                // 0
   AM=M+1             // 1
   A=A-1              // 2
   M=0                // 3
   @SP                // 4
   AM=M+1             // 5
   A=A-1              // 6
   M=0                // 7

// push local 0

   @LCL               // 8
   A=M                // 9
   D=M                // 10
   @SP                // 11
   AM=M+1             // 12
   A=A-1              // 13
   M=D                // 14

// push local 1

   @LCL               // 15
   A=M+1              // 16
   D=M                // 17
   @SP                // 18
   AM=M+1             // 19
   A=A-1              // 20
   M=D                // 21

// add

   @SP                // 22
   AM=M-1             // 23
   D=M                // 24
   A=A-1              // 25
   A=M                // 26
   D=A+D              // 27
   @SP                // 28
   A=M                // 29
   A=A-1              // 30
   M=D                // 31

// not

   @SP                // 32
   A=M-1              // 33
   M=!M               // 34

// push argument 0

   @ARG               // 35
   A=M                // 36
   D=M                // 37
   @SP                // 38
   AM=M+1             // 39
   A=A-1              // 40
   M=D                // 41

// add

   @SP                // 42
   AM=M-1             // 43
   D=M                // 44
   A=A-1              // 45
   A=M                // 46
   D=A+D              // 47
   @SP                // 48
   A=M                // 49
   A=A-1              // 50
   M=D                // 51

// push argument 1

   @ARG               // 52
   A=M+1              // 53
   D=M                // 54
   @SP                // 55
   AM=M+1             // 56
   A=A-1              // 57
   M=D                // 58

// sub

   @SP                // 59
   AM=M-1             // 60
   D=M                // 61
   A=A-1              // 62
   A=M                // 63
   D=A-D              // 64
   @SP                // 65
   A=M                // 66
   A=A-1              // 67
   M=D                // 68

// return

   /// FRAME = LCL
   @LCL               // 69
   D=M                // 70
   @R14               // 71
   M=D                // 72
   /// 13 = *(FRAME-5)
   @5                 // 73
   D=A                // 74
   @R14               // 75
   A=M-D              // 76
   D=M                // 77
   @13                // 78
   M=D                // 79
   /// *ARG = pop()
   @SP                // 80
   AM=M-1             // 81
   D=M                // 82
   @ARG               // 83
   A=M                // 84
   M=D                // 85
   /// SP = ARG+1
   @ARG               // 86
   D=M+1              // 87
   @SP                // 88
   M=D                // 89
   /// THAT = *(FRAME-1)
   @1                 // 90
   D=A                // 91
   @R14               // 92
   A=M-D              // 93
   D=M                // 94
   @THAT              // 95
   M=D                // 96
   /// THIS = *(FRAME-2)
   @2                 // 97
   D=A                // 98
   @R14               // 99
   A=M-D              // 100
   D=M                // 101
   @THIS              // 102
   M=D                // 103
   /// ARG = *(FRAME-3)
   @3                 // 104
   D=A                // 105
   @R14               // 106
   A=M-D              // 107
   D=M                // 108
   @ARG               // 109
   M=D                // 110
   /// LCL = *(FRAME-4)
   @4                 // 111
   D=A                // 112
   @R14               // 113
   A=M-D              // 114
   D=M                // 115
   @LCL               // 116
   M=D                // 117
   /// goto RET
   @R13               // 118
   A=M                // 119
   0;JMP              // 120
