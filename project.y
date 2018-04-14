%token SWITCH END DO CASE OBRACE EBRACE ORBRACKET ERBRACKET OSBRACKET ESBRACKET SEMICOLON COLON INCREMENT DECREMENT PEQUAL MEQUAL MULEQUAL DIVEQUAL GREATER LESS GE LE EQ NE PLUS MINUS MUL DIV REM AND OR NOT WHILE FOR IF ELSE PRINT INT FLOAT DOUBLE LONG CHAR STRING CONST INTEGERNUMBER FLOATNUMBER TEXT CHARACTER IDENTIFIER ASSIGN POWER
%left ASSIGN
%left PLUS MINUS 
%left DIV MUL REM
%left POWER
%left GREATER LESS GE LE EQ NE
%{  
	#include <stdio.h>   
	int yyerror(char *);
     	int yylex(void);
     
%}


%%
program: 
		program start
		|
		;
	
start :         SEMICOLON  //Instead of semicolon will be written declarations and expressions
		;



no_declaration 		: FLOATNUMBER
					| INTEGERNUMBER 
					| IDENTIFIER 
					| no_declaration PLUS	no_declaration 
					| no_declaration MINUS no_declaration 
					| no_declaration MUL no_declaration 
					| no_declaration  DIV	no_declaration 
					| no_declaration  REM	no_declaration 
					| no_declaration  POWER	no_declaration 
					| IDENTIFIER INCREMENT 
					| IDENTIFIER DECREMENT 
					| ORBRACKET no_declaration ERBRACKET ;

forExpression 		: IDENTIFIER  INCREMENT 
					| IDENTIFIER DECREMENT
					| IDENTIFIER ASSIGN no_declaration  PLUS no_declaration 
					| IDENTIFIER ASSIGN no_declaration  MINUS no_declaration  
					| IDENTIFIER ASSIGN no_declaration  MUL no_declaration 
					| IDENTIFIER ASSIGN no_declaration  DIV no_declaration ;


stmtlist			: stmt 
					| stmtlist stmt ;
					
					
booleanExpression 	: FALSE 
					| TRUE 
					| booleanExpression AND booleanExpression 
					| booleanExpression OR booleanExpression 
					| NOT booleanExpression 
					| no_declaration GREATER no_declaration 
					| no_declaration LESS no_declaration 
					| no_declaration GE no_declaration 
					| no_declaration LE no_declaration
					| expr NE expr | expr EQ expr ;
					

expr				: no_declaration
					| CHARACTER 
					| TEXT
					|booleanExpression ;
					
					
%% 
 int yyerror(char *s) {     fprintf(stderr, "%s\n", s);     return 0; }
 
 int main(void) 
 {     yyparse(); 
 return 0; }
 
 