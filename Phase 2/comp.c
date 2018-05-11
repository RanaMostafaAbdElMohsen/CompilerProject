#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"
#include "y.tab.h"

static int lbl;
int leftType;
int rightType;
int last = 0;
int counter = -1;
int br = 0;
int permit;
char* oprType;


int ex(nodeType *p) {
	
    int lbl1, lbl2;
    int type1;
	int type2;
	int i,j;
	
    if (!p) return 0;
    switch(p->type) {
    case typeCon: 
        printf("\tpush\t%d\n", p->con.value); 
        break;
    case typeId: 
        printf("\tpush\t%c\n", p->id.index + 'a'); 
        break;
    case typeOpr:
        switch(p->opr.oper) {
        case WHILE:
            fprintf(f1,"L%03d:\n", lbl1 = lbl++);
            ex(p->opr.op[0]);
            fprintf(f1,"\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->opr.op[1]);
            fprintf(f1,"\tjmp\tL%03d\n", lbl1);
            fprintf(f1,"L%03d:\n", lbl2);
            break;
        case IF:
            ex(p->opr.op[0]);
            if (p->opr.nops > 2) {
                /* if else */
                fprintf(f1,"\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->opr.op[1]);
                fprintf(f1,"\tjmp\tL%03d\n", lbl2 = lbl++);
                fprintf(f1,"L%03d:\n", lbl1);
                ex(p->opr.op[2]);
                fprintf(f1,"L%03d:\n", lbl2);
            } else {
                /* if */
                fprintf(f1,"\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->opr.op[1]);
                fprintf(f1,"L%03d:\n", lbl1);
            }
            break;
        case PRINT:     
            ex(p->opr.op[0]);
            printf("\tprint\n");
            break;
       case ASSIGN:
					leftType = p->opr.op[0]->id.type;
					oprType = strdup("a");
					
					permit = p->opr.op[0]->id.per;
					if(permit == undeclared) {
						fprintf( f1, "Error: %s is not declared \n", p->opr.op[0]->id.name);
						oprType = NULL;
						break;
					}
					else if(permit == Constant){
						fprintf( f1, "Error: %s must be a modifiable expression \n", p->opr.op[0]->id.name);
						oprType = NULL;
						break;
					}
					else if(permit == OutOfScope) {
						fprintf( f1, "Error: %s is already defined \n", p->opr.op[0]->id.name);
						oprType = NULL;
						break;
					}
					
					symInit[p->opr.op[0]->id.index] = 1;
					ex(p->opr.op[1]);
					if(p->opr.op[1]->type == typeId) {
						if(p->opr.op[1]->id.per != undeclared){
							symUsed[p->opr.op[1]->id.index] = 1;
						}
                    
					}

					if((leftType == Integer || leftType == ConstIntger) && (rightType == Integer || rightType == ConstIntger || rightType == Float || rightType == Char || rightType == ConstFloat || rightType == ConstChar)) {;}
					else if((leftType == Float || leftType == ConstFloat) && (rightType == Float || rightType == ConstFloat || rightType == Integer || rightType == ConstIntger)) {;}
					else if((leftType == Char || leftType == ConstChar) && (rightType == Char || rightType == ConstChar || rightType == Integer || rightType == ConstIntger)) {;}
					else if((leftType == String || leftType == ConstString) && (rightType == String || rightType == ConstString)) {;}
					else if((leftType == Bool || leftType == ConstBool) && (rightType == Bool || rightType == ConstBool)) {;}
					else if(leftType != rightType) {
						fprintf( f1, "Error: incompatible types for assignment \n");
						oprType = NULL;
						break;
					}
					
					fprintf( f1, "\t mov %s, R%01d \n", p->opr.op[0]->id.name, last - 1);
					last = 0;
					counter = -1;
                    oprType = NULL;
                    leftType = -9;
                    rightType = -9;
					break;
        case UMINUS:    
            ex(p->opr.op[0]);
            printf("\tneg\n");
            break;
        default:
            ex(p->opr.op[0]);
			i=counter;
            ex(p->opr.op[1]);
			j=counter;
            switch(p->opr.oper) {
            case PLUS:
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t add R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for addition \n");
							}
                            oprType = NULL;
							break;
							
						case MINUS:
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t sub R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for subtraction \n");
							}
                            oprType = NULL;
							break;
							
						case MUL:
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 ==  Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t mul R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for multiplication \n");
							}
                            oprType = NULL;
							break;
							
						case DIV:
							
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float  || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t div R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for division \n");
							}
                            oprType = NULL;
							break;
                            

                            
                        case REM:
                            
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float  || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t rem R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for reminader  operation \n");
							}
                            oprType = NULL;
							break;

                        case POWER:
                            if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float  || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t power R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for power operation\n");
							}
                            oprType = NULL;
							break;
                            
								
						case NOT:
							
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) ) {
								fprintf( f1, "\t not R%01d \n", last-1);
								last ++;
								
							}
							else {
								fprintf( f1, "Error: incompatible operands for not \n");
							}
                            oprType = NULL;
							
							break;
							
						case AND:
							
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float  || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t and R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for && \n");
							}
                            oprType = NULL;
							break;
							
						case OR:
							
							
							f((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float  || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t or R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for || \n");
							}
                            oprType = NULL;
							break;
						
						case GREATER:
							rightType = Bool;
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)){
								fprintf( f1, "\t compGREATER R%01d, R%01d, R%01d \n",last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for > \n");
							}
                            oprType = NULL;
							break;
						case LESS:
							rightType = Bool;
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)){
								fprintf( f1, "\t compLESS R%01d, R%01d, R%01d \n",last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for < \n");
							}
                            oprType = NULL;
							break;
						case GE:
							rightType = Bool;
							if((type1 ==Integer  || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)){
								fprintf( f1, "\t compGE R%01d, R%01d, R%01d \n",last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for >= \n");
							}
                            oprType = NULL;
							break;
						case LE:
							rightType = Bool;
							if((type1 ==Integer  || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)){
								fprintf( f1, "\t compLE R%01d, R%01d, R%01d \n",last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for <= \n");
							}
                            oprType = NULL;
							break;
						case NE:
							rightType = Bool;
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat){}
							else if((type1 == Char || type1 == ConstChar) && (type2 == Char || type2 == ConstChar)){}
							else if((type1 == String || type1 == ConstString) && (type2 == String || type2 == ConstString)){}
							else if((type1 == Bool || type1 == ConstBool ) && (type2 == Bool || type2 ==ConstBool)){}
							else {
								fprintf( f1, "Error: incompatible operands for != \n");
                                oprType = NULL;
								break;
							}
							fprintf( f1, "\t compNE R%01d, R%01d, R%01d \n",last, i, j);
							last ++;
							counter++;
                            oprType = NULL;
							break;
						case EQ:
							rightType = Bool;
							if((type1 == Integer || type1 == Float || type1 == ConstIntger || type1 == ConstFloat) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)){}
							else if((type1 == Char || type1 == ConstChar) && (type2 == Char || type2 == ConstChar)){}
							else if((type1 == String || type1 == ConstString) && (type2 == String || type2 == ConstString)){}
							else if((type1 == Bool || type1 == ConstBool ) && (type2 == Bool || type2 ==ConstBool)){}
							else {
								fprintf( f1, "Error: incompatible operands for == \n");
								oprType = NULL;
                                break;
							}
							fprintf( f1, "\t compEQ R%01d, R%01d, R%01d \n",last, i, j);
							last ++;
							counter++;
                            oprType = NULL;
							break;
						case INCREMENT:
							
							if(type1 == Integer || type1 == Float) {
								fprintf( f1, "\t inc R%01d \n", last-1);
								fprintf( f1, "\t mov %s, R%01d \n", p->opr.op[0]->id.name, last - 1);
							}
							else {
								fprintf( f1, "Error: incompatible operands for increment \n");
							}
                            oprType = NULL;
							break;
						case DECREMENT:
							if(type1 == Integer || type1 == Float) {
								fprintf( f1, "\t dec R%01d \n", last-1);
								fprintf( f1, "\t mov %s, R%01d \n", p->opr.op[0]->id.name, last - 1);
							}
							else {
								fprintf( f1, "Error: incompatible operands for decrement \n");
							}
                            oprType = NULL;
							break;							
						case PEQUAL:
							
							if((type1 == Integer || type1 == Float ) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t add R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for += \n");
							}
                            oprType = NULL;
							break;
							
						case MEQUAL:
							
							if((type1 == Integer || type1 == Float ) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t sub R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for -= \n");
							}
							break;
						case MULEQUAL:
							if((type1 == Integer || type1 == Float ) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t mul R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for *= \n");
							}
							break;
						case DIVEQUAL:
							if((type1 == Integer || type1 == Float ) && (type2 == Integer || type2 == Float || type2 == ConstIntger || type2 == ConstFloat)) {
								fprintf( f1, "\t div R%01d, R%01d, R%01d \n", last, i, j);
								last ++;
								counter++;
							}
							else {
								fprintf( f1, "Error: incompatible operands for /= \n");
							}
							break;
                    
					}
				}
			}
    return 0;

}
	

	
