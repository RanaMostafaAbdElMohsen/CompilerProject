%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "structs.h"


/* prototypes */
nodeType * opr(int oper, int nops, ...);
nodeType * id(int index, int type, int per,char * name, char * value);
nodeType * getId(char * name);
nodeType * con(char* value, int type);
void freeNode(nodeType *p);
//int ex(nodeType *p);
int yyerror(char *);
int yylex(void);
int yylineno;
FILE * f1;
FILE * yyin;

int SymSize = 50;

/* symbol table */
int  symType[SymSize];
char* symName[SymSize];
char* symValue[SymSize];
bool symInit[SymSize];
bool symUsed[SymSize];
int symBraces[SymSize];

int indexCount=0;
int brace=0;

%}
%union {
    int iValue;                 /* integer value */
	float fValue;               /* float Value */
    char * sValue;              /* string value */
	char  cValue;               /* character value */
	char * id ;                 /* id value */
    nodeType *nPtr;             /* node pointer */
};

%token COMMA RET BREAK DEFAULT SWITCH END DO CASE OBRACE EBRACE ORBRACKET ERBRACKET OSBRACKET ESBRACKET SEMICOLON COLON INCREMENT DECREMENT PEQUAL MEQUAL MULEQUAL DIVEQUAL GREATER LESS GE LE EQ NE PLUS MINUS MUL DIV REM AND OR NOT WHILE FOR IF ELSE PRINT INT FLOAT DOUBLE LONG CHAR STRING CONST  ASSIGN POWER FALSE TRUE BOOL
%token <iValue> INTEGERNUMBER 
%token <fValue> FLOATNUMBER 
%token <sValue> TEXT 
%token <cValue> CHARACTER 
%token <id>     IDENTIFIER



%left ASSIGN
%left PLUS MINUS 
%left DIV MUL REM
%left POWER
%left GREATER LESS GE LE EQ NE
%nonassoc IFX
%nonassoc ELSE


%type <nPtr> stmt expression stmtlist braceScope forExpression booleanExpression caseExpression  no_declaration
%type <iValue> Type

%%
program	: 
		function
		;
	
function :      function stmt  
		|
		;
		
stmt:   Type IDENTIFIER SEMICOLON	%prec IFX                 {$$=id(indexCount,$1,brace,0,$2,NULL);printf("Declaration\n");}

		| IDENTIFIER ASSIGN expression SEMICOLON	          {$$ = opr(ASSIGN,2, $1, $3);printf("Assignment\n");}

		| Type IDENTIFIER ASSIGN expression	SEMICOLON	      {$$ = opr(ASSIGN,2, $1, $4);printf("Declaration and Assignment\n");}

		| CONST Type IDENTIFIER ASSIGN expression SEMICOLON   {printf("Constant assignment\n");}

        | forExpression SEMICOLON                             {printf("Increments\n");}
		
		| WHILE ORBRACKET booleanExpression ERBRACKET stmt	  {printf("While loop\n");}

		| DO braceScope WHILE ORBRACKET booleanExpression ERBRACKET SEMICOLON	{printf("Do while\n");}

		| FOR ORBRACKET INT IDENTIFIER ASSIGN no_declaration SEMICOLON 
		  booleanExpression SEMICOLON 
		  forExpression ERBRACKET
		  braceScope											  {printf("For loop\n");}

		
		| IF ORBRACKET booleanExpression ERBRACKET braceScope %prec IFX {printf("If statement\n");}

		| IF ORBRACKET booleanExpression ERBRACKET braceScope	 ELSE braceScope	{printf("If-Elsestatement\n");}

		| SWITCH ORBRACKET IDENTIFIER ERBRACKET braceScope      {printf("Switch case\n");}

		
		| PRINT expression 	SEMICOLON	                        {printf("Print\n");}
		
		//| func	                                            	

		| braceScope											{printf("New braces scope\n");}
		;

/*func : Type IDENTIFIER ORBRACKET arglist ERBRACKET braceScope RET Type          {printf("function\n");}
	   ;
	   
arglist:  Type IDENTIFIER cont
;

cont:  COMMA Type IDENTIFIER cont 
	| 
;	   
*/	   
		
braceScope:  OBRACE stmtlist EBRACE								{printf("Stmt brace\n");}
			| OBRACE caseExpression EBRACE					    {printf("Case brace\n");}
			;

stmtlist:  stmt 
		   | stmtlist stmt ;

Type:   INT  {$$=0;}
		| FLOAT{$$=1;}
		| CHAR {$$=2;}
		| STRING {$$=3;}
		| BOOL {$$=4;}
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
					

expression: no_declaration
			| CHARACTER 
			| TEXT
			| booleanExpression ;

caseExpression: DEFAULT COLON stmtlist BREAK SEMICOLON                              
			   | CASE INTEGERNUMBER COLON stmtlist BREAK SEMICOLON   caseExpression  		
			   ;

%% 

nodeType *con(char* value, int type) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = strdup(value);
    p->con.type=type;
    return p;
}

nodeType * id(int index, int type, int brace, bool init, char * name, char * value)
{
    // check if the name already exists in the symName table
	for (int j=0; j<indexCount; j++)
	{
		if (strcmp(name,symName[j]) == 0)
		{
			yyerror("Identifier Name already defined before\n");
			// still need to check the braces ! 
		}
	}

    nodeType *p;

    /* allocate node */
    if (p = malloc( (sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    
    p->id.index = index;
    p->id.type 	= type;
    p->id.per 	= 0;
    p->id.used	= false;
    p->id.brace = brace;
    p->id.name 	= strdup(name);
    p->id.value = strdup(value);
    
    // insert into symbol table
    symName[index] 	 = strdup(name);
    symValue[index]	 = strdup(value);
    symType[index]   = type;
    symInit[index]	 = init;
	symUsed[index]	 = false;
	symBraces[index] = brace;
	
    return p;
}

nodeType * getId(char * name)
{
	int index;
	
	for (int j=0; j<indexCount; j++)
	{
		if (strcmp(name,symName[j]) == 0)
		{
			index = j;
			break;
		}
	}
	
	nodeType *p;

    /* allocate node */
    if (p = malloc( (sizeof(nodeType))) == NULL)
        yyerror("out of memory");

	symUsed[index]	 =  true;

    /* copy information */
    p->type = typeId;
    
    p->id.index = index;
    p->id.type 	= symType[index];
    p->id.per 	= 0;							// may need to be changed
    p->id.brace = symBraces[index];
    p->id.name 	= strdup(symName[index]);
    p->id.value = strdup(symValue[index]);
    p->id.used 	= symUsed[index];
    
    return p;
	
}
nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    /* allocate node, extending op array */
    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}


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