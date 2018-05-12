typedef enum { typeCon, typeId, typeOpr } nodeEnum;
typedef enum { Integer, Float, Char, String, Bool, ConstIntger, ConstFloat, ConstChar, ConstString, ConstBool} typeEnum;
typedef enum { Accepted, undeclared, Constant, OutOfScope} permission;

/* constants */
typedef struct {
    typeEnum type;                  	/* type of constant */
	char * value;						/* value of constant as char array */
} conNodeType;

/* identifiers */
typedef struct {
    int         index;          				/* subscript to sym table  and brace table*/
	typeEnum    type; 						/* type */
	permission  per;
	char *      name;
} idNodeType;

/* operators */
typedef struct {
    int oper;                   		/* operator */
    int nops;                   		/* number of operands */
    struct nodeTypeTag *op[1];			/* operands, extended at runtime */
} oprNodeType;

typedef struct nodeTypeTag {
    nodeEnum type;              		/* type of node */

    union {
        conNodeType con;        		/* constants */
        idNodeType id;          		/* identifiers */
        oprNodeType opr;        		/* operators */
    };
} nodeType;

extern FILE* f1;
extern FILE* f2;
extern int yyerror(char *);
extern int yyerrorvar(char *s, char *var);