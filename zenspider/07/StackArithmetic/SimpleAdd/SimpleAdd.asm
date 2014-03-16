
// push constant 7

   @7                 // 0
   D=A                // 1
   @SP                // 2
   AM=M+1             // 3
   A=A-1              // 4
   M=D                // 5

// push constant 8

   @8                 // 6
   D=A                // 7
   @SP                // 8
   AM=M+1             // 9
   A=A-1              // 10
   M=D                // 11

// add

   @SP                // 12
   AM=M-1             // 13
   D=M                // 14
   A=A-1              // 15
   A=M                // 16
   D=A+D              // 17
   @SP                // 18
   A=M                // 19
   A=A-1              // 20
   M=D                // 21
