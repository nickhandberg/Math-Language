# Math-Language
Group 2 implementation of mathematical language for CSC-330 project

EBNF:
digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
letter = "A" | "B" | "C" | "D" | "E" | "F" | "G"
| "H" | "I" | "J" | "K" | "L" | "M" | "N"
| "O" | "P" | "Q" | "R" | "S" | "T" | "U"
| "V" | "W" | "X" | "Y" | "Z" ;
float = digit, { digit }, ".", digit, {digit} ;
integer = digit, {digit} ;
sign = “+” | “-”;
number = [sign], integer | float ;
identifier = letter { letter | digit } ;
operator = "+" | "-" | "*" | "/" ;
operand = identifier | number | expression;
expression = "(", operator, operand, operand, ")";
definition = "(", "let", identifier, number, ")" ;
program = { definition } expression ;
