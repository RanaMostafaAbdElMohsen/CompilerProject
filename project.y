%token COMMA RET BREAK DEFAULT SWITCH END DO CASE OBRACE EBRACE ORBRACKET ERBRACKET OSBRACKET ESBRACKET SEMICOLON COLON INCREMENT DECREMENT PEQUAL MEQUAL MULEQUAL DIVEQUAL GREATER LESS GE LE EQ NE PLUS MINUS MUL DIV REM AND OR NOT WHILE FOR IF ELSE PRINT INT FLOAT DOUBLE LONG CHAR STRING CONST INTEGERNUMBER FLOATNUMBER TEXT CHARACTER IDENTIFIER ASSIGN POWER FALSE TRUE BOOL

%left ASSIGN
%left PLUS MINUS 
%left DIV MUL REM
%left POWER
%left GREATER LESS GE LE EQ NE
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

		| FOR ORBRACKET type IDENTIFIER ASSIGN expression SEMICOLON 
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
	   
		
braceScope:  OBRACE stmtlist EBRACE								{printf("Stmt brace\n");}
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

no_declaration:   FLOATNUMBER
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

forExpression:   IDENTIFIER  INCREMENT 
				 | IDENTIFIER DECREMENT
				 | IDENTIFIER ASSIGN no_declaration  PLUS no_declaration 
				 | IDENTIFIER ASSIGN no_declaration  MINUS no_declaration  
				 | IDENTIFIER ASSIGN no_declaration  MUL no_declaration 
				 | IDENTIFIER ASSIGN no_declaration  DIV no_declaration	
				 | IDENTIFIER PEQUAL no_declaration 
				 | IDENTIFIER MEQUAL no_declaration 
				 | IDENTIFIER MULEQUAL no_declaration 
				 | IDENTIFIER DIVEQUAL no_declaration 
				 ;

			
booleanExpression: 	  FALSE 
					| TRUE
					| booleanExpression AND booleanExpression 
					| booleanExpression OR booleanExpression 
					| NOT booleanExpression 
					| no_declaration GREATER no_declaration 
					| no_declaration LESS no_declaration 
					| no_declaration GE no_declaration 
					| no_declaration LE no_declaration
					| expression NE expression 
					| expression EQ expression ;
					
booleanExpressionAll : booleanExpression
					 |	IDENTIFIER;

expression: no_declaration
			| CHARACTER 
			| TEXT
			| booleanExpression ;

caseExpression: DEFAULT COLON stmtlist BREAK SEMICOLON                              
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