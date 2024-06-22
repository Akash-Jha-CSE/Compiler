%{
#include <stdio.h>
#include <string.h>
#include <math.h>
int yylex();
void yyerror(char const *);
extern FILE *yyin,*yyout,*lexout;
%}

%token INT CHAR WHILE IF ELSE RETURN COMMA ASSIGN PLUS MINUS DIV MUL SEMI LEFT_CURLY RIGHT_CURLY LEFT_BRAC RIGHT_BRAC LEFT_SQBRAC RIGHT_SQBRAC GREATER_THAN LESS_THAN COMPARE_EQUAL LESS_THAN_EQUAL GREATER_THAN_EQUAL COMPARE_NOT_EQUAL
%union
{
    int num;
    char *str;
}
%token <num> NUM
%token <str> ID
%token <str> STRING
%left PLUS MINUS
%left MUL DIV
%left LEFT_BRAC RIGHT_BRAC

%%

programs : program
;

program : var_declaration          {fprintf(yyout,"\n");}
    | func_declaration             {fprintf(yyout,"\n");}
    | func_definition              {fprintf(yyout,"\n");}
    | program var_declaration      {fprintf(yyout,"\n");}
    | program func_declaration     {fprintf(yyout,"\n");}
    | program func_definition      {fprintf(yyout,"\n");}
;

var_declaration : datatype identifier SEMI  
    | datatype identifier ASSIGN expression SEMI        {fprintf(yyout,"Assignment : =\n");}
    | datatype identifier SEMI               
    | datatype identifier ASSIGN string_literal SEMI     {fprintf(yyout,"Assignment : =\n");}
;

func_declaration : datatype identifier LEFT_BRAC func_arguments RIGHT_BRAC SEMI           {fprintf(yyout,"Function declared above\n\n");}
    | datatype identifier LEFT_BRAC RIGHT_BRAC SEMI                           {fprintf(yyout,"Function declared above\n\n");}
;

func_definition : datatype identifier LEFT_BRAC func_arguments RIGHT_BRAC func_body       {fprintf(yyout,"Function Defined above\n\n");}
    | datatype identifier LEFT_BRAC RIGHT_BRAC func_body                      {fprintf(yyout,"Function Defined above\n\n");}
;

func_arguments : datatype identifier                   {fprintf(yyout,"Function Arguments Passed Above\n\n");}
    | datatype identifier COMMA func_arguments
;

datatype : INT       {fprintf(yyout,"Datatype : int\n");}
    | CHAR     {fprintf(yyout,"Datatype : char *\n");}
;

func_body : LEFT_CURLY statement_list RIGHT_CURLY
    | statement
;

statement_list : statement_list statement
    | statement
;

statement : assignment_statement
    | function_call             {fprintf(yyout,"Function call ends \n\n");}
    | return_statement           {fprintf(yyout,"Return statement \n\n");}
    | conditional             {fprintf(yyout,"If Condition Ends \n\n");}
    | loop                  {fprintf(yyout,"While Loop Ends \n\n");}
    | var_declaration
;

assignment_statement : expression ASSIGN expression SEMI
;

return_statement : RETURN SEMI
    | RETURN expression SEMI
;

function_call : identifier LEFT_BRAC RIGHT_BRAC SEMI
    | identifier LEFT_BRAC expression
;

conditional : IF LEFT_BRAC boolean RIGHT_BRAC func_body
    | IF LEFT_BRAC boolean RIGHT_BRAC func_body ELSE func_body
;

loop : WHILE LEFT_BRAC boolean RIGHT_BRAC func_body
;

boolean : boolean LESS_THAN boolean              {fprintf(yyout,"Operator : < \n");}
    | boolean GREATER_THAN boolean            {fprintf(yyout,"Operator : > \n");}
    | boolean COMPARE_EQUAL boolean           {fprintf(yyout,"Operator : == \n");}
    | boolean COMPARE_NOT_EQUAL boolean       {fprintf(yyout,"Operator : != \n");}
    | boolean LESS_THAN_EQUAL boolean         {fprintf(yyout,"Operator : <= \n");}
    | boolean GREATER_THAN_EQUAL boolean      {fprintf(yyout,"Operator : >= \n");}
    | expression
;

identifier : ID      {fprintf(yyout,"Variable : %s \n", $1);}
;

number : NUM    {fprintf(yyout,"Value : %d \n", $1);}
;

string_literal : STRING {fprintf(yyout,"Value : %s \n", $1);}
;

expression : LEFT_BRAC expression RIGHT_BRAC
    | expression PLUS expression            {fprintf(yyout,"Operator : + \n");}
    | expression MINUS expression           {fprintf(yyout,"Operator : - \n");}
    | expression MUL expression             {fprintf(yyout,"Operator : * \n");}
    | expression DIV expression             {fprintf(yyout,"Operator : / \n");}
    | number                    
    | identifier
;

%%

int main()
{
    yyin=fopen("Sample1.cu","r");
    //yyin=fopen("Sample2.cu","r");
    yyout=fopen("parser.txt","w");
    lexout=fopen("lexer.txt","w");
    yyparse();
    return 0;
}

void yyerror(char const *s)
{
    printf("Syntax Error\n");
}
