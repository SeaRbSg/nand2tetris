
// push constant 111

   @111               // 0
   D=A                // 1
   @SP                // 2
   AM=M+1             // 3
   A=A-1              // 4
   M=D                // 5

// push constant 333

   @333               // 6
   D=A                // 7
   @SP                // 8
   AM=M+1             // 9
   A=A-1              // 10
   M=D                // 11

// push constant 888

   @888               // 12
   D=A                // 13
   @SP                // 14
   AM=M+1             // 15
   A=A-1              // 16
   M=D                // 17

// pop static 8

   @16                // 18
   D=A                // 19
   @8                 // 20
   A=A+D              // 21
   D=A                // 22
   @R15               // 23
   M=D                // 24
   @SP                // 25
   AM=M-1             // 26
   D=M                // 27
   @R15               // 28
   A=M                // 29
   M=D                // 30

// pop static 3

   @16                // 31
   D=A                // 32
   @3                 // 33
   A=A+D              // 34
   D=A                // 35
   @R15               // 36
   M=D                // 37
   @SP                // 38
   AM=M-1             // 39
   D=M                // 40
   @R15               // 41
   A=M                // 42
   M=D                // 43

// pop static 1

   @16                // 44
   D=A                // 45
   @1                 // 46
   A=A+D              // 47
   D=A                // 48
   @R15               // 49
   M=D                // 50
   @SP                // 51
   AM=M-1             // 52
   D=M                // 53
   @R15               // 54
   A=M                // 55
   M=D                // 56

// push static 3

   @16                // 57
   D=A                // 58
   @3                 // 59
   A=A+D              // 60
   D=M                // 61
   @SP                // 62
   AM=M+1             // 63
   A=A-1              // 64
   M=D                // 65

// push static 1

   @16                // 66
   D=A                // 67
   @1                 // 68
   A=A+D              // 69
   D=M                // 70
   @SP                // 71
   AM=M+1             // 72
   A=A-1              // 73
   M=D                // 74

// sub

   @SP                // 75
   AM=M-1             // 76
   D=M                // 77
   A=A-1              // 78
   A=M                // 79
   D=A-D              // 80
   @SP                // 81
   A=M                // 82
   A=A-1              // 83
   M=D                // 84

// push static 8

   @16                // 85
   D=A                // 86
   @8                 // 87
   A=A+D              // 88
   D=M                // 89
   @SP                // 90
   AM=M+1             // 91
   A=A-1              // 92
   M=D                // 93

// add

   @SP                // 94
   AM=M-1             // 95
   D=M                // 96
   A=A-1              // 97
   A=M                // 98
   D=A+D              // 99
   @SP                // 100
   A=M                // 101
   A=A-1              // 102
   M=D                // 103
