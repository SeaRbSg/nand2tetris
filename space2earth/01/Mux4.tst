// 
// File name: projects/01/Mux4me.tst

load Mux4.hdl,
output-file Mux4.out,
compare-to Mux4.cmp,
output-list a%B1.16.1 b%B1.16.1 sel%D2.1.2 out%B1.16.1;

set a 0,
set b 0,
set sel 0,
eval,
output;

set sel 1,
eval,
output;

set a %B0000000000000000,
set b %B0000000000001001,
set sel 0,
eval,
output;

set sel 1,
eval,
output;

set a %B0000000000000110,
set b %B0000000000000000,
set sel 0,
eval,
output;

set sel 1,
eval,
output;

set a %B0000000000001010,
set b %B0000000000000101,
set sel 0,
eval,
output;

set sel 1,
eval,
output;