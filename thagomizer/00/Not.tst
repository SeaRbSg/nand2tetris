// Testing my implementation of Not from Nand

load Not.hdl,
output-file Not.out,
compare-to Not.cmp,
output-list a%B3.1.3 out%B3.1.3;

set a 0,
eval,
output;

set a 1,
eval,
output;