load Add4.hdl,
output-file Add4.out,
compare-to Add4.cmp,
output-list a%B1.4.1 b%B1.4.1 out%B1.4.1;

set c0 0;

set a %B0000, set b %B0000, eval, output;
set a %B0000, set b %B0001, eval, output;
set a %B0000, set b %B0010, eval, output;
set a %B0000, set b %B0100, eval, output;
set a %B0000, set b %B1000, eval, output;
set a %B0000, set b %B1111, eval, output;
set a %B1111, set b %B1111, eval, output;
set a %B1010, set b %B0101, eval, output;
set a %B0011, set b %B0000, eval, output;
set a %B0100, set b %B0110, eval, output;
