
// push constant 3030

   @3030              // 0
   D=A                // 1
   @SP                // 2
   AM=M+1             // 3
   A=A-1              // 4
   M=D                // 5

// pop pointer 0

   @THIS              // 6
   D=A                // 7
   @R15               // 8
   M=D                // 9
   @SP                // 10
   AM=M-1             // 11
   D=M                // 12
   @R15               // 13
   A=M                // 14
   M=D                // 15

// push constant 3040

   @3040              // 16
   D=A                // 17
   @SP                // 18
   AM=M+1             // 19
   A=A-1              // 20
   M=D                // 21

// pop pointer 1

   @THIS              // 22
   A=A+1              // 23
   D=A                // 24
   @R15               // 25
   M=D                // 26
   @SP                // 27
   AM=M-1             // 28
   D=M                // 29
   @R15               // 30
   A=M                // 31
   M=D                // 32

// push constant 32

   @32                // 33
   D=A                // 34
   @SP                // 35
   AM=M+1             // 36
   A=A-1              // 37
   M=D                // 38

// pop this 2

   @THIS              // 39
   D=M                // 40
   @2                 // 41
   A=A+D              // 42
   D=A                // 43
   @R15               // 44
   M=D                // 45
   @SP                // 46
   AM=M-1             // 47
   D=M                // 48
   @R15               // 49
   A=M                // 50
   M=D                // 51

// push constant 46

   @46                // 52
   D=A                // 53
   @SP                // 54
   AM=M+1             // 55
   A=A-1              // 56
   M=D                // 57

// pop that 6

   @THAT              // 58
   D=M                // 59
   @6                 // 60
   A=A+D              // 61
   D=A                // 62
   @R15               // 63
   M=D                // 64
   @SP                // 65
   AM=M-1             // 66
   D=M                // 67
   @R15               // 68
   A=M                // 69
   M=D                // 70

// push pointer 0

   @THIS              // 71
   D=M                // 72
   @SP                // 73
   AM=M+1             // 74
   A=A-1              // 75
   M=D                // 76

// push pointer 1

   @THIS              // 77
   A=A+1              // 78
   D=M                // 79
   @SP                // 80
   AM=M+1             // 81
   A=A-1              // 82
   M=D                // 83

// add

   @SP                // 84
   AM=M-1             // 85
   D=M                // 86
   A=A-1              // 87
   A=M                // 88
   D=A+D              // 89
   @SP                // 90
   A=M                // 91
   A=A-1              // 92
   M=D                // 93

// push this 2

   @THIS              // 94
   D=M                // 95
   @2                 // 96
   A=A+D              // 97
   D=M                // 98
   @SP                // 99
   AM=M+1             // 100
   A=A-1              // 101
   M=D                // 102

// sub

   @SP                // 103
   AM=M-1             // 104
   D=M                // 105
   A=A-1              // 106
   A=M                // 107
   D=A-D              // 108
   @SP                // 109
   A=M                // 110
   A=A-1              // 111
   M=D                // 112

// push that 6

   @THAT              // 113
   D=M                // 114
   @6                 // 115
   A=A+D              // 116
   D=M                // 117
   @SP                // 118
   AM=M+1             // 119
   A=A-1              // 120
   M=D                // 121

// add

   @SP                // 122
   AM=M-1             // 123
   D=M                // 124
   A=A-1              // 125
   A=M                // 126
   D=A+D              // 127
   @SP                // 128
   A=M                // 129
   A=A-1              // 130
   M=D                // 131
