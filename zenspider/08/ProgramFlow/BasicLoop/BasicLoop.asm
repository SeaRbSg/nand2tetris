
// push constant 0

   @0                 // 0
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

// label LOOP_START

(LOOP_START)

// push argument 0

   @ARG               // 17
   A=M                // 18
   D=M                // 19
   @SP                // 20
   AM=M+1             // 21
   A=A-1              // 22
   M=D                // 23

// push local 0

   @LCL               // 24
   A=M                // 25
   D=M                // 26
   @SP                // 27
   AM=M+1             // 28
   A=A-1              // 29
   M=D                // 30

// add

   @SP                // 31
   AM=M-1             // 32
   D=M                // 33
   A=A-1              // 34
   A=M                // 35
   D=A+D              // 36
   @SP                // 37
   A=M                // 38
   A=A-1              // 39
   M=D                // 40

// pop local 0

   @LCL               // 41
   A=M                // 42
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

// push constant 1

   @1                 // 59
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
   @LOOP_START        // 96
   D;JNE              // 97

// push local 0

   @LCL               // 98
   A=M                // 99
   D=M                // 100
   @SP                // 101
   AM=M+1             // 102
   A=A-1              // 103
   M=D                // 104
