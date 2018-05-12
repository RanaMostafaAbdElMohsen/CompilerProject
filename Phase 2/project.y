%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "structs.h"
#include <math.h>
char* idtype [10] = {"Integer", "Float", "Char", "String", "Bool", "ConstIntger", "ConstFloat", "ConstChar", "ConstString", "ConstBool"};
/* prototypes */
nodeType * opr(int oper, int nops, ...);
nodeType * id(int index, int type, int brace, permission perm, char * name);
nodeType * getId(char * name, int brace);
nodeType * con(char* value, int type);
void freeNode(nodeType *p);
void ftoa(float n,char res[], int afterpoint);
int ex(nodeType *p) ;//phase 2 semantic analyser;
int yyerror(char *);
int yyerrorvar(char *s, char *var);
int yylex(void);
int yylineno;
FILE * f1;
FILE * f2; 
FILE * yyin;
/* symbol table */
int  symType[50];
char* symName[50];
char* symValue[50];
int symInit[50];
int symUsed[50];
int symBraces[50];
permission   symPerm[50];
int indexCount=0;
int brace=0;
int counter;
%}
%union 
{
    int iValue;                 /* integer value */
	float fValue;               /* float Value */
    char * sValue;              /* string value */
	char * cValue;               /* character value */
	char * id ;                 /* id value */
    nodeType *nPtr;             /* node pointer */
};

%token COMMA RET BREAK DEFAULT SWITCH DO CASE OBRACE EBRACE ORBRACKET ERBRACKET SEMICOLON COLON INCREMENT DECREMENT PEQUAL MEQUAL MULEQUAL DIVEQUAL GREATER LESS GE LE EQ NE PLUS MINUS MUL DIV REM AND OR NOT WHILE FOR IF ELSE PRINT INT FLOAT DOUBLE LONG CHAR STRING CONST  ASSIGN POWER FALSE TRUE BOOL
%token <iValue> INTEGERNUMBER 
%token <fValue> FLOATNUMBER 
%token <sValue> TEXT 
%token <cValue> CHARACTER 
%token <id>     IDENTIFIER

%left ASSIGN 
%left GREATER LESS GE LE EQ NE AND OR NOT
%left PLUS MINUS 
%left DIV MUL REM
%left POWER
%nonassoc IFX
%nonassoc ELSE
%nonassoc UMINUS

%type <nPtr> stmt expression stmtlist braceScope forExpression booleanExpression caseExpression  no_declaration DataTypes  increments switchScope braceIncrementor
%type <iValue> Type
%type <iValue> Constant


%%
program	: 
		function
		;
	
function : function stmt  {ex($2); freeNode($2);}
		|
		;
		
stmt:   Type IDENTIFIER SEMICOLON	%prec IFX                  {$$=id(indexCount,$1,brace,Accepted,$2);printf("Declaration\n");indexCount++;}

		| IDENTIFIER ASSIGN expression SEMICOLON	           {$$ = opr(ASSIGN,2, getId($1,brace), $3); printf("Assignment\n");}	
	

		| Type IDENTIFIER ASSIGN expression	SEMICOLON	       {$$ = opr(ASSIGN,2, id(indexCount,$1,brace,Accepted,$2), $4); indexCount++; printf("Declaration and Assignment\n");}

		| Constant IDENTIFIER ASSIGN expression SEMICOLON      { $$ = opr(ASSIGN,2, id(indexCount,$1,brace,Constant,$2), $4); indexCount++;printf("Constant assignment\n");}

		| increments SEMICOLON                                 {$$=$1; printf("Increments\n");}
		
		| WHILE ORBRACKET expression ERBRACKET stmt	           {$$ = opr(WHILE,2, $3, $5); printf("While loop\n");}

		| DO braceScope WHILE ORBRACKET expression ERBRACKET SEMICOLON	{$$ = opr(DO,2, $2, $5);printf("Do while\n");}

		| FOR ORBRACKET IDENTIFIER ASSIGN INTEGERNUMBER SEMICOLON 
		  expression SEMICOLON 
		  forExpression ERBRACKET
		  braceScope											   {char c[] = {}; itoa($5, c, 10);$$ = opr(FOR, 4, opr(ASSIGN, 2, getId($3,brace), con(c, 0)), $7, $9, $11); printf("For loop\n");}

		
		| IF ORBRACKET expression ERBRACKET braceScope %prec IFX {$$ = opr(IF, 2, $3, $5);printf("If statement\n");}

		| IF ORBRACKET expression ERBRACKET braceScope	 ELSE braceScope	{$$ = opr(IF, 3, $3, $5, $7); printf("If-Elsestatement\n");}

		| SWITCH ORBRACKET IDENTIFIER ERBRACKET switchScope      {$$ = opr(SWITCH, 2, getId($3,brace), $5);printf("Switch case\n");}

		
		| PRINT expression 	SEMICOLON	                         {$$ = opr(PRINT, 1, $2); printf("Print\n");}
			                                            	
      
		| braceScope											{$$=$1; printf("New braces scope\n");}
		
		;

 

		
braceScope:	 OBRACE braceIncrementor stmtlist EBRACE			{ char c[] = {}; itoa(brace, c, 10); $$ = opr(OBRACE, 3, con(c ,0), $3, opr(EBRACE,0)); brace--;printf("Stmt brace\n");}
			| OBRACE  EBRACE	                                { char c[] = {}; itoa(brace, c, 10); $$ = opr(OBRACE, 3, con(c ,0), NULL, opr(EBRACE,0)); brace--;printf("Empty brace\n");}
		;

switchScope:  OBRACE braceIncrementor caseExpression EBRACE	   { char c[] = {}; itoa(brace, c, 10); $$ = opr(OBRACE, 3, con(c ,0), $3, opr(EBRACE,0)); brace--;printf("case brace\n");}		
		;
		
braceIncrementor :{$$=NULL; brace++;}
		
		
stmtlist:  stmt { $$ = $1; }
          | stmtlist stmt { $$ = opr(SEMICOLON, 2, $1, $2); }  ;

Type:   INT  {$$=0;}
		| FLOAT{$$=1;}
		| CHAR {$$=2;}
		| STRING {$$=3;}
		| BOOL {$$=4;}
		;

Constant : CONST INT {$$=5;}
          |	CONST FLOAT {$$=6;}
		  | CONST CHAR {$$=7;}
          | CONST STRING {$$=8;}
		  | CONST BOOL {$$=9;}
		  ;

no_declaration: FLOATNUMBER    { char c[] = {}; ftoa($1, c, 6); $$ = con(c, 1); }              
		| INTEGERNUMBER          { char c[] = {}; itoa($1, c, 10); $$ = con(c, 0); }             
		| IDENTIFIER              { $$ = getId($1,brace); }             
		| no_declaration PLUS	no_declaration { $$ = opr(PLUS, 2, $1, $3); }
		| no_declaration MINUS no_declaration  {$$= opr(MINUS,2,$1,$3);}
		| no_declaration MUL no_declaration    {$$= opr(MUL, 2 ,$1,$3);}
		| no_declaration  DIV	no_declaration {$$= opr(DIV, 2 ,$1,$3);}
		| no_declaration  REM	no_declaration {$$= opr(REM, 2 ,$1,$3);}
		| no_declaration  POWER	no_declaration  {$$= opr(POWER, 2 ,$1,$3);}
		| MINUS no_declaration %prec UMINUS   { $$ = opr(UMINUS, 1, $2); } 
		| IDENTIFIER INCREMENT                 {$$=opr(INCREMENT,1,getId($1,brace));}
		| IDENTIFIER DECREMENT                 {$$=opr(DECREMENT,1,getId($1,brace));}
		| ORBRACKET no_declaration ERBRACKET    {$$=$2;}    
		;

increments: IDENTIFIER  INCREMENT              		{$$=opr(INCREMENT,1,getId($1,brace));}
		 | IDENTIFIER DECREMENT                		{$$=opr(DECREMENT,1,getId($1,brace));}
		 | IDENTIFIER PEQUAL no_declaration    		{$$= opr(PEQUAL, 2 ,getId($1,brace),$3);}
		 | IDENTIFIER MEQUAL no_declaration    		{$$= opr(MEQUAL, 2 ,getId($1,brace),$3);}
		 | IDENTIFIER MULEQUAL no_declaration 		{$$= opr(MULEQUAL, 2 ,getId($1,brace),$3);}
		 | IDENTIFIER DIVEQUAL no_declaration  		{$$= opr(DIVEQUAL, 2 ,getId($1,brace),$3);}
		 ;


forExpression : increments                 {$$=$1;}
			   | IDENTIFIER ASSIGN no_declaration {$$ = opr(ASSIGN, 2, getId($1,brace), $3);};
		 
booleanExpression: expression AND expression   { $$ = opr(AND, 2, $1, $3); }       
			| expression OR expression         { $$ = opr(OR , 2, $1, $3); }     
			| NOT expression 				   { $$ = opr(NOT, 1, $2); }                         
			| DataTypes GREATER DataTypes  	   { $$ = opr(GREATER, 2, $1, $3); }		 
			| DataTypes LESS DataTypes         { $$ = opr(LESS, 2, $1, $3); }      
			| DataTypes GE DataTypes           { $$ = opr(GE, 2, $1, $3); }      
			| DataTypes LE DataTypes           { $$ = opr(LE, 2, $1, $3); }      
			| DataTypes NE DataTypes           { $$ = opr(NE, 2, $1, $3); }       
			| DataTypes EQ DataTypes           { $$ = opr(EQ, 2, $1, $3); }      
			| ORBRACKET booleanExpression ERBRACKET {  $$ = $2; }
			;
		

		
			
DataTypes:no_declaration {  $$ = $1; }
		| CHARACTER { $$ = con($1, 2); }
		| FALSE { $$ = con("false", 4); }
	    | TRUE { $$ = con("true", 4); }
		| TEXT { $$ = con($1, 3); };
			

		      

expression:	DataTypes {  $$ = $1; }
		| booleanExpression {  $$ = $1; } ;

caseExpression:	DEFAULT COLON stmtlist BREAK SEMICOLON           { $$ = opr(DEFAULT, 2, $3, opr(BREAK, 0)); }                                          
	 	| CASE INTEGERNUMBER COLON stmtlist BREAK SEMICOLON  caseExpression  { char c[] = {}; itoa($2, c, 10); $$ = opr(CASE, 4, con(c, 0), $4, opr(BREAK, 0), $7); }		
		   ;


%% 

nodeType *con(char* value, int type) 
{
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

nodeType * id(int index, int type, int brace, permission  perm, char * name)
{

	 nodeType *p;
   
    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)         
		yyerror("out of memory");
	
    // check if the name already exists in the symName table
	int j=0;
	for (j=0; j<indexCount; j++)
	{
		if (strcmp(name,symName[j]) == 0)
		{			
			// is it in the same brace ?
			if (symBraces[j] == brace)
			{
				yyerrorvar("Identifier name already defined before in this scope",name);
			}
		}
	}

    /* copy information */
    p->type = typeId;
    p->id.index = index;
    p->id.type 	= type;
    p->id.per 	= perm;
    p->id.name 	= strdup(name);
  
    // insert into symbol table
    symName[index] 	 = strdup(name);
    symType[index]   = type;
    symInit[index]	 = 0;
	symUsed[index]	 = 0;
	symBraces[index] = brace;
	symPerm[index]	 = perm;
    return p;
}

nodeType * getId(char * name, int brace)
{
	int index;
	int j=0;
	int flagFound = 0;

	// searching for the identifier's name in the Symbol Table
	// Variable found must be in a valid brace scope (!= -5)

	for (j=0; j<indexCount; j++)
	{
		if (strcmp(name,symName[j]) == 0 && symBraces[j] != -5 )
		{
			if (symBraces[j] == brace)
			{
				
				flagFound = 1;
				index = j;
				break;
			}
			else
			{
				// possible declaration was made in a previous valid brace
				flagFound = 1;
				index = j;
			}
		}
	}
	
	if (flagFound == 0)
	{
		yyerrorvar("Undeclared Variable",strdup(name));
	}
	else
	{
		nodeType *p;

	    /* allocate node */
	    if ((p = malloc(sizeof(nodeType))) == NULL)         
			yyerror("out of memory");

	    /* copy information */
	    p->type = typeId;
	    
	    p->id.index = index;
	    p->id.type 	= symType[index];
	    p->id.per 	= symPerm[index];
	    p->id.name 	= strdup(symName[index]);

	    return p;
	}
	
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

void reverse(char *str, int len) {
	int i=0, j=len-1, temp;
	while (i<j)
	{
		temp = str[i];
		str[i] = str[j];
		str[j] = temp;
		i++; j--;
	}
}

int toStr(int x, char str[], int d) {
	int i = 0;
	while (x)
	{
		str[i++] = (x%10) + '0';
		x = x/10;
	}
 
	// If number of digits required is more, then
	// add 0s at the beginning
	while (i < d)
		str[i++] = '0';
 
	reverse(str, i);
	str[i] = '\0';
	return i;
}

void ftoa(float n, char res[], int afterpoint) 
{
	
	// Extract integer part
	int ipart = (int)n;
 
	// Extract floating part
	float fpart = n - (float)ipart;
	
 
	// convert integer part to string
	int i = toStr(ipart, res, 0);
 
	// check for display option after point
	if (afterpoint != 0)
	{
		res[i] = '.';  // add dot
 
		// Get the value of fraction part upto given no.
		// of points after dot. The third parameter is needed
		// to handle cases like 233.007
		fpart = fpart * pow(10, afterpoint);
		toStr((int)fpart, res + i + 1, afterpoint);
	}
}

int yyerror(char *s) 
{ 
	fclose(f1);
	remove("output.txt"); 
	f1=fopen("output.txt","w");
	fprintf(f1, "Syntax Error Could not parse quadruples\n"); 
	fprintf(stderr, "line number : %d %s\n", yylineno,s);    
 
 	fclose(f2);
	remove("symbol.txt");
	f2 = fopen("symbol.txt","w");
	fprintf(f2, "Syntax Error was Found\n");
 	fprintf(stderr, "line number : %d %s\n", yylineno,s);    
 
	exit(0);
}
 
int yyerrorvar(char *s, char *var) 
{
	fclose(f1);
	int x = remove("output.txt");
	f1 = fopen("output.txt","w");
	fprintf(f1, "Syntax Error Could not parse quadruples\n");
 	fprintf(f1, "line number: %d %s : %s\n", yylineno,s,var);
	
	fclose(f2);
	x = remove("symbol.txt");
	f2 = fopen("symbol.txt","w");
	fprintf(f2, "Syntax Error was Found\n");
 	fprintf(f2, "line number: %d %s : %s\n", yylineno,s,var);
	
 	exit(0);
}

int main(void) 
{   
	yyin = fopen("input.txt", "r");
	f1=fopen("output.txt","w");
	f2 = fopen("symbol.txt","w");
	
	if(!yyparse())
	{
		printf("\nParsing complete\n");
		
		int i;
		
		fprintf(f2,"Used Variables :- \n");
		for (i = 0 ; i < indexCount ; i ++)
		{
			if (symUsed[i] != 0)
			{
				fprintf(f2,"%s of type %s \n",symName[i],idtype[symType[i]]);
			}
		}
		
		fprintf(f2,"\nNot Used Variables :- \n");
		for (i = 0 ; i < indexCount ; i ++)
		{
			if (symUsed[i] == 0)
			{
				fprintf(f2,"%s of type %s \n",symName[i],idtype[symType[i]]);
			}
		}
		
		fprintf(f2,"\n-----------------------------------------------\n");
		
		fprintf(f2,"\nInitiallized Variables :- \n");
		for (i = 0 ; i < indexCount ; i ++)
		{
			if (symInit[i] != 0)
			{
				fprintf(f2,"%s of type %s and value = %s \n" ,symName[i],idtype[symType[i]],symValue[i]);
			}
		}
		
		fprintf(f2,"\nNot Initiallized Variables :- \n");
		for (i = 0 ; i < indexCount ; i ++)
		{
			if (symInit[i] == 0)
			{
				fprintf(f2,"%s of type %s \n",symName[i],idtype[symType[i]]);
			}
		}
						
	}
	else
	{
		printf("\nParsing failed\n");
		return 0;
	}
	fclose(f1);
	fclose(f2);
	fclose(yyin);
	return 0;
}