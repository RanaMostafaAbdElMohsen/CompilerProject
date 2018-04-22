%token COMMA RET BREAK DEFAULT SWITCH DO CASE OBRACE EBRACE ORBRACKET ERBRACKET SEMICOLON COLON INCREMENT DECREMENT PEQUAL MEQUAL MULEQUAL DIVEQUAL GREATER LESS GE LE EQ NE PLUS MINUS MUL DIV REM AND OR NOT WHILE FOR IF ELSE PRINT INT FLOAT DOUBLE LONG CHAR STRING CONST INTEGERNUMBER FLOATNUMBER TEXT CHARACTER IDENTIFIER ASSIGN POWER FALSE TRUE BOOL

%left ASSIGN
%left PLUS MINUS 
%left DIV MUL REM
%left POWER
%left GREATER LESS GE LE EQ NE AND OR NOT
%nonassoc IFX
%nonassoc ELSE

%{  
	#include <stdio.h>   
	int yyerror(char *);
	int yylex(void);
	int yylineno;
	FILE * f1;
	FILE * yyin;

%}


%%
program	: 
		function
		;
	
function :      function stmt  
		|
		;
		
stmt:   type IDENTIFIER SEMICOLON	%prec IFX                 {printf("Declaration\n");}

		| IDENTIFIER ASSIGN expression SEMICOLON	          {printf("Assignment\n");}

		| type IDENTIFIER ASSIGN expression	SEMICOLON	      {printf("Declaration and Assignment\n");}

		| CONST type IDENTIFIER ASSIGN expression SEMICOLON   {printf("Constant assignment\n");}

		| forExpression SEMICOLON                             {printf("Increments\n");}
		
		| WHILE ORBRACKET booleanExpressionAll ERBRACKET stmt	  {printf("While loop\n");}

		| DO braceScope WHILE ORBRACKET booleanExpressionAll ERBRACKET SEMICOLON	{printf("Do while\n");}

		| FOR ORBRACKET INT IDENTIFIER ASSIGN INTEGERNUMBER SEMICOLON 
		  booleanExpression SEMICOLON 
		  forExpression ERBRACKET
		  braceScope											  {printf("For loop\n");}

		
		| IF ORBRACKET booleanExpressionAll ERBRACKET braceScope %prec IFX {printf("If statement\n");}

		| IF ORBRACKET booleanExpressionAll ERBRACKET braceScope	 ELSE braceScope	{printf("If-Elsestatement\n");}

		| SWITCH ORBRACKET IDENTIFIER ERBRACKET braceScope      {printf("Switch case\n");}

		
		| PRINT expression 	SEMICOLON	                        {printf("Print\n");}
		
		| func	                                            	

		| braceScope											{printf("New braces scope\n");}
		;

func : type IDENTIFIER ORBRACKET arglist ERBRACKET OBRACE stmtlist RET  IDENTIFIER  SEMICOLON   EBRACE      {printf("function\n");}
	   ;
	   
arglist:  type IDENTIFIER cont
	;

cont:  COMMA type IDENTIFIER cont 
	| 
	;	   
	   
		
braceScope:	 OBRACE stmtlist EBRACE								{printf("Stmt brace\n");}
		| OBRACE caseExpression EBRACE					    {printf("Case brace\n");}
		;

stmtlist:  stmt 
          | stmtlist stmt ;

type:   INT
	| FLOAT
	| DOUBLE
	| LONG
	| CHAR
	| STRING
	| BOOL
	;

no_declaration:   FLOATNUMBER                  { $$ = $1; }
		| INTEGERNUMBER                        { $$ = $1; }
		| IDENTIFIER                           { $$ = $1; }
		| no_declaration PLUS	no_declaration { $$ = $1 + $3;}
		| no_declaration MINUS no_declaration  { $$ = $1 - $3; }
		| no_declaration MUL no_declaration    { $$ = $1 * $3; }
		| no_declaration  DIV	no_declaration { $$ = $1 / $3; }
		| no_declaration  REM	no_declaration { $$ = $1 % $3; }
		| no_declaration  POWER	no_declaration { $$ = $1 % $3; }
		| IDENTIFIER INCREMENT                 { $$ = $1+1; }
		| IDENTIFIER DECREMENT                 { $$ = $1+1; }
		| ORBRACKET no_declaration ERBRACKET   { $$ = $2; } ;

forExpression:   IDENTIFIER  INCREMENT         { $$ = $1+1; }
		 | IDENTIFIER DECREMENT                { $$ = $1+1; }
		 | IDENTIFIER PEQUAL no_declaration    { $1 = $1+$3; }
		 | IDENTIFIER MEQUAL no_declaration    { $1 = $1-$3; }
		 | IDENTIFIER MULEQUAL no_declaration  { $1 = $1*$3; }
		 | IDENTIFIER DIVEQUAL no_declaration  { $1 = $1/$3; }
		 ;

			
booleanExpression: 	  FALSE 
			| TRUE
			| booleanExpression AND booleanExpression { $$ = $1 && $3; }
			| booleanExpression OR booleanExpression  { $$ = $1 || $3; }
			| NOT booleanExpression                   { $$ = ! $2; }
			| no_declaration GREATER no_declaration   { $$ = $1 > $3; }
			| no_declaration LESS no_declaration      { $$ = $1 < $3; }
			| no_declaration GE no_declaration        { $$ = $1 >= $3; }
			| no_declaration LE no_declaration        { $$ = $1 <= $3; }
			| no_declaration NE no_declaration        { $$ = $1 != $3; }
			| no_declaration EQ no_declaration        { $$ = $1 == $3; };
					
booleanExpressionAll : booleanExpression
		      |	IDENTIFIER;

expression:	no_declaration
		| CHARACTER 
		| TEXT
		| booleanExpression ;

caseExpression:	DEFAULT COLON stmtlist BREAK SEMICOLON                              
		| CASE INTEGERNUMBER COLON stmtlist BREAK SEMICOLON   caseExpression  		
		   ;

%% 
 int yyerror(char *s) {     fprintf(stderr, "line number : %d %s\n", yylineno,s);     return 0; }
 
 int main(void) 
 {    yyin = fopen("input.txt", "r");
	f1=fopen("output.txt","w");
	
   if(!yyparse())
	{
		printf("\nParsing complete\n");
		fprintf(f1,"hello there");
	}
	else
	{
		printf("\nParsing failed\n");
		return 0;
	}
	
	fclose(yyin);
	fclose(f1);
    return 0;
}