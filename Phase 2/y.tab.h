
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
     END = 263,
     DO = 264,
     CASE = 265,
     OBRACE = 266,
     EBRACE = 267,
     ORBRACKET = 268,
     ERBRACKET = 269,
     OSBRACKET = 270,
     ESBRACKET = 271,
     SEMICOLON = 272,
     COLON = 273,
     INCREMENT = 274,
     DECREMENT = 275,
     PEQUAL = 276,
     MEQUAL = 277,
     MULEQUAL = 278,
     DIVEQUAL = 279,
     GREATER = 280,
     LESS = 281,
     GE = 282,
     LE = 283,
     EQ = 284,
     NE = 285,
     PLUS = 286,
     MINUS = 287,
     MUL = 288,
     DIV = 289,
     REM = 290,
     AND = 291,
     OR = 292,
     NOT = 293,
     WHILE = 294,
     FOR = 295,
     IF = 296,
     ELSE = 297,
     PRINT = 298,
     INT = 299,
     FLOAT = 300,
     DOUBLE = 301,
     LONG = 302,
     CHAR = 303,
     STRING = 304,
     CONST = 305,
     INTEGERNUMBER = 306,
     FLOATNUMBER = 307,
     TEXT = 308,
     CHARACTER = 309,
     IDENTIFIER = 310,
     ASSIGN = 311,
     POWER = 312,
     FALSE = 313,
     TRUE = 314,
     BOOL = 315,
     IFX = 316
   };
#endif
/* Tokens.  */
#define COMMA 258
#define RET 259
#define BREAK 260
#define DEFAULT 261
#define SWITCH 262
#define END 263
#define DO 264
#define CASE 265
#define OBRACE 266
#define EBRACE 267
#define ORBRACKET 268
#define ERBRACKET 269
#define OSBRACKET 270
#define ESBRACKET 271
#define SEMICOLON 272
#define COLON 273
#define INCREMENT 274
#define DECREMENT 275
#define PEQUAL 276
#define MEQUAL 277
#define MULEQUAL 278
#define DIVEQUAL 279
#define GREATER 280
#define LESS 281
#define GE 282
#define LE 283
#define EQ 284
#define NE 285
#define PLUS 286
#define MINUS 287
#define MUL 288
#define DIV 289
#define REM 290
#define AND 291
#define OR 292
#define NOT 293
#define WHILE 294
#define FOR 295
#define IF 296
#define ELSE 297
#define PRINT 298
#define INT 299
#define FLOAT 300
#define DOUBLE 301
#define LONG 302
#define CHAR 303
#define STRING 304
#define CONST 305
#define INTEGERNUMBER 306
#define FLOATNUMBER 307
#define TEXT 308
#define CHARACTER 309
#define IDENTIFIER 310
#define ASSIGN 311
#define POWER 312
#define FALSE 313
#define TRUE 314
#define BOOL 315
#define IFX 316




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


