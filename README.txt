Open the terminal in the directory 2022CSB1065 and Enter the following commands to run the program :
        1. flex cucu.l
        2. bison -d cucu.y
        3. g++ cucu.tab.c lex.yy.c -lfl -o cucu
        4. ./cucu

The file lexer.txt contains the output of the program

The file parser.txt contains the output obtained by cucu.y file

Sample1 contains correct code

Sample2 contains incorrect code