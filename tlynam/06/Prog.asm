// Adds 1+...+100

//@ is either number or symbol representing a number

//D~D is used solely to store data values

//A~A doubles as data register and an address register
//A~A can be interpreted as a data value, an address, or address in instruction memory

//M~M always refers to the memory word whose address is the current value of the A register

@i //i var refers to a mem location A instruction
M=1 //i=1 C instruction

@sum //sum var refers to mem location
M=0 //sum=0

@i //calling i var
D=M //D=i

@100 //The number 100
D=D-A //D=i-100

@END //
D;JGT // Conditional Jump If (i-100)>0 goto END

@i
D=M

@sum
M=D+M

@i
D=M //D=i

@sum
M=D+M

@i
M=M+1 //i=i+1

@LOOP
0;JMP // Unconditional Jump

@END
0;JMP //Infinite loop