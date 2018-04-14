%token SWITCH END DO CASE OBRACE EBRACE ORBRACKET ERBRACKET OSBRACKET ESBRACKET SEMICOLON COLON INCREMENT DECREMENT PEQUAL MEQUAL MULEQUAL DIVEQUAL GREATER LESS GE LE EQ NE PLUS MINUS MUL DIV REM AND OR NOT WHILE FOR IF ELSE PRINT INT FLOAT DOUBLE LONG CHAR STRING CONST INTEGERNUMBER FLOATNUMBER TEXT CHARACTER IDENTIFIER ASSIGN POWER

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

%}


%%
program	: 
		function
		;
	
function :      function stmt  
		|
		;
		
stmt:		  type IDENTIFIER 								SEMICOLON	{printf("Declaration");}

		| type IDENTIFIER ASSIGN expression						SEMICOLON	{printf("Assignment");}

		| CONST type IDENTIFIER ASSIGN expression					SEMICOLON	{printf("Constant assignment");}


		| WHILE ORBRACKET booleanExpression ERBRACKET stmt						{printf("While loop");}

		| DO braceScope WHILE ORBRACKET booleanExpression ERBRACKET 			SEMICOLON	{printf("Do while");}

		| FOR ORBRACKET type IDENTIFIER ASSIGN expression SEMICOLON 
		  booleanExpression SEMICOLON 
		  forExpression ERBRACKET
		  braceScope											{printf("For loop");}

		
		| IF ORBRACKET booleanExpression ERBRACKET stmt	 %prec IFX					{printf("If statement");}

		| IF ORBRACKET booleanExpression ERBRACKET stmt	 ELSE stmt					{printf("If-Elsestatement");}

		| SWITCH ORBRACKET IDENTIFIER ERBRACKET braceScope						{printf("Switch case");}

		
		| PRINT expression 								SEMICOLON	{printf("Print");}
		
		| function									SEMICOLON	{printf("function");}

		| braceScope											{printf("New braces scope");}
		;

braceScope: 	  OBRACE stmtlist EBRACE									{printf("Stmt brace");}
		| OBRACE caseExpression EBRACE									{printf("Case brace");}
		;

stmtlist: 	  stmt 
		| stmtlist stmt ;

type:		  INT
		| FLOAT
		| DOUBLE
		| LONG
		| CHAR
		| STRING
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

forExpression:    IDENTIFIER  INCREMENT 
		| IDENTIFIER DECREMENT
		| IDENTIFIER ASSIGN no_declaration  PLUS no_declaration 
		| IDENTIFIER ASSIGN no_declaration  MINUS no_declaration  
		| IDENTIFIER ASSIGN no_declaration  MUL no_declaration 
		| IDENTIFIER ASSIGN no_declaration  DIV no_declaration ;
					
					
booleanExpression: 	  FALSE 
			| TRUE 
			| booleanExpression AND booleanExpression 
			| booleanExpression OR booleanExpression 
			| NOT booleanExpression 
			| no_declaration GREATER no_declaration 
			| no_declaration LESS no_declaration 
			| no_declaration GE no_declaration 
			| no_declaration LE no_declaration
			| expr NE expr | expr EQ expr ;
					

expr: 	  no_declaration
	| CHARACTER 
	| TEXT
	| booleanExpression ;


%% 
 int yyerror(char *s) {     fprintf(stderr, "%s\n", s);     return 0; }
 
 int main(void) 
 {     yyparse(); 
 return 0; }
