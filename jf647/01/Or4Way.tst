// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/01/Or8Way.tst

load Or4Way.hdl,
output-file Or4Way.out,
compare-to Or4Way.cmp,
output-list in%B2.4.2 out%B2.1.2;

set in %B0000,
eval,
output;

set in %B0001,
eval,
output;

set in %B0010,
eval,
output;

set in %B0100,
eval,
output;

set in %B1000,
eval,
output;

set in %B1001,
eval,
output;

set in %B1011,
eval,
output;

set in %B1111,
eval,
output;

set in %B1100,
eval,
output;

set in %B1101,
eval,
output;

set in %B1011,
eval,
output;

set in %B0011,
eval,
output;

set in %B0111,
eval,
output;