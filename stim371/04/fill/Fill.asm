// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.

(LOOP)
  // save key value in register
  @KBD
  D=M
  @R0
  M=D

  @SCREEN
  D=A
  @CURRENT_PIXEL
  M=D

  @24575
  D=A
  @END_SCREEN
  M=D

  @KBD
  D=M
  @R0
  M=D
  @WRITESCREEN
  D;JEQ

(BLACK)
  @R0
  M=-1

(WRITESCREEN)
  // grab screen value from register
  @R0
  D=M

  // write value to current screen bit
  @CURRENT_PIXEL
  A=M
  M=D

  // decrement pointer for next iteration
  @CURRENT_PIXEL
  MD=M+1

  // go to the beginning and find the difference between the pointer and the beginning
  @END_SCREEN
  D=M-D

  // keep writing to screen if the pointer is above @SCREEN
  @WRITESCREEN
  D;JGT

  // else go back to the main loop
  @LOOP
  D;JEQ


