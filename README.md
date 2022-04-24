# Math-Language
Group 2 implementation of mathematical language for CSC-330 project

### How to run
Place test programs in the test directory of the project files. These can just be text files with the instructions. The examples shown in the Testing portion will be included already.


On Windows run the calc.bat file found in the bin directory using the console.


On MacOS/Linux give permissions to the calc.sh file found in the bin directory and run it using the terminal.

It will prompt the user to enter what file they want to run found in the test directory. 

Do NOT add the path to the test directory when entering the filename, it is already looking in that folder.

### EBNF

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

