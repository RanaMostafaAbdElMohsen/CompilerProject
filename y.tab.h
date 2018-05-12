
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     COMMA = 258,
     RET = 259,
     BREAK = 260,
     DEFAULT = 261,
     SWITCH = 262,
     DO = 263,
     CASE = 264,
     OBRACE = 265,
     EBRACE = 266,
     ORBRACKET = 267,
     ERBRACKET = 268,
     SEMICOLON = 269,
     COLON = 270,
     INCREMENT = 271,
     DECREMENT = 272,
     PEQUAL = 273,
     MEQUAL = 274,
     MULEQUAL = 275,
     DIVEQUAL = 276,
     GREATER = 277,
     LESS = 278,
     GE = 279,
     LE = 280,
     EQ = 281,
     NE = 282,
     PLUS = 283,
     MINUS = 284,
     MUL = 285,
     DIV = 286,
     REM = 287,
     AND = 288,
     OR = 289,
     NOT = 290,
     WHILE = 291,
     FOR = 292,
     IF = 293,
     ELSE = 294,
     PRINT = 295,
     INT = 296,
     FLOAT = 297,
     DOUBLE = 298,
     LONG = 299,
     CHAR = 300,
     STRING = 301,
     CONST = 302,
     ASSIGN = 303,
     POWER = 304,
     FALSE = 305,
     TRUE = 306,
     BOOL = 307,
     INTEGERNUMBER = 308,
     FLOATNUMBER = 309,
     TEXT = 310,
     CHARACTER = 311,
     IDENTIFIER = 312,
     IFX = 313,
     UMINUS = 314
   };
#endif
/* Tokens.  */
#define COMMA 258
#define RET 259
#define BREAK 260
#define DEFAULT 261
#define SWITCH 262
#define DO 263
#define CASE 264
#define OBRACE 265
#define EBRACE 266
#define ORBRACKET 267
#define ERBRACKET 268
#define SEMICOLON 269
#define COLON 270
#define INCREMENT 271
#define DECREMENT 272
#define PEQUAL 273
#define MEQUAL 274
#define MULEQUAL 275
#define DIVEQUAL 276
#define GREATER 277
#define LESS 278
#define GE 279
#define LE 280
#define EQ 281
#define NE 282
#define PLUS 283
#define MINUS 284
#define MUL 285
#define DIV 286
#define REM 287
#define AND 288
#define OR 289
#define NOT 290
#define WHILE 291
#define FOR 292
#define IF 293
#define ELSE 294
#define PRINT 295
#define INT 296
#define FLOAT 297
#define DOUBLE 298
#define LONG 299
#define CHAR 300
#define STRING 301
#define CONST 302
#define ASSIGN 303
#define POWER 304
#define FALSE 305
#define TRUE 306
#define BOOL 307
#define INTEGERNUMBER 308
#define FLOATNUMBER 309
#define TEXT 310
#define CHARACTER 311
#define IDENTIFIER 312
#define IFX 313
#define UMINUS 314




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 47 "project.y"

    int iValue;                 /* integer value */
	float fValue;               /* float Value */
    char * sValue;              /* string value */
	char * cValue;               /* character value */
	char * id ;                 /* id value */
    nodeType *nPtr;             /* node pointer */



/* Line 1676 of yacc.c  */
#line 181 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


