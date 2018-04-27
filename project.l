%{   
	 #include <stdlib.h>
	 #include <stdio.h>
     int yyerror(char *); 
	 #include "y.tab.h" 
	  int yylineno;
%} 

%%
\{                      return OBRACE;
\}                      return EBRACE;
\(						return ORBRACKET;
\)						return ERBRACKET;
;                       return SEMICOLON;
:                       return COLON; 
,                       return COMMA;
"++"					return INCREMENT;
"--"					return DECREMENT;
"+="					return PEQUAL;
"-="					return MEQUAL;
"*="					return MULEQUAL;
"/="					return DIVEQUAL;
">"         	 		return GREATER;
"<"         	 		return LESS;
">="         	 		return GE;
"<="             		return LE;
"=="             		return EQ;
"!="             		return NE;
"+"						return PLUS;
"-"						return MINUS;
"*"						return MUL;
"/"						return DIV;
"^"						return POWER;
"="						return ASSIGN;
"%"						return REM;
"&&"					return AND;
"||"					return OR;
"!"						return NOT;
"while"          		return WHILE;
"for"          			return FOR;
"if"             		return IF;
"else"           		return ELSE;
"print"        			return PRINT;
"bool"				    return BOOL;
"int"					return INT;
"float"					return FLOAT;
"double"				return DOUBLE;
"long"					return LONG;
"char"					return CHAR;
"string"				return STRING;
"const"                 return CONST;
"do"					return DO;
"break"                 return BREAK;
"switch"                return SWITCH;
"case"                  return CASE;
"false"					return FALSE;
"true"					return TRUE;
"default"               return DEFAULT;
"return"                return RET;


[0-9]+                  {yylval = atoi(yytext); return INTEGERNUMBER;}
[0-9]+\.[0-9]+          {yylval = atof(yytext); return FLOATNUMBER;}
\"[\x23-\x7E =\?!\*]*\" {printf("Text returned\n"); return TEXT;}
\'[\x23-\x7E]?\'        return CHARACTER;
[a-zA-Z][_a-zA-Z0-9]*   {printf("Identifier returned\n"); return IDENTIFIER; }	
[\t  ]+                /* ignore whitespace */;
[\n]					{yylineno=yylineno+1;}



%% 
 int yywrap(void)
{ return 1; } 