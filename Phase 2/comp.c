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

					if((leftType == Integer || leftType == ConstIntger) && (rightType == 0 || rightType == 5 || rightType == 1 || rightType == 2 || rightType == 6 || rightType == 7)) {;}
					else if((leftType == 1 || leftType == 6) && (rightType == 1 || rightType == 6 || rightType == 0 || rightType == 5)) {;}
					else if((leftType == 2 || leftType == 7) && (rightType == 2 || rightType == 7 || rightType == 0 || rightType == 5)) {;}
					else if((leftType == 3 || leftType == 8) && (rightType == 3 || rightType == 8)) {;}
					else if((leftType == 4 || leftType == 9) && (rightType == 4 || rightType == 9)) {;}
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
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)) {
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
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)) {
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
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)) {
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
							
							break;
                            

                            
                        case REM:
                            
							break;

                        case POWER:
                            
							break;
                            
								
						case NOT:
							
							break;
							
						case AND:
							
							break;
							
						case OR:
							
							break;
						
						case GREATER:
							rightType = 4;
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)){
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
							rightType = 4;
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)){
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
							rightType = 4;
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)){
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
							rightType = 4;
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)){
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
							rightType = 4;
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)){}
							else if((type1 == 2 || type1 == 7) && (type2 == 2 || type2 == 7)){}
							else if((type1 == 3 || type1 == 8) && (type2 == 3 || type2 == 8)){}
							else if((type1 == 4 || type1 == 9 ) && (type2 == 4 || type2 == 9)){}
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
							rightType = 4;
							if((type1 == 0 || type1 == 1 || type1 == 5 || type1 == 6) && (type2 == 0 || type2 == 1 || type2 == 5 || type2 == 6)){}
							else if((type1 == 2 || type1 == 7) && (type2 == 2 || type2 == 7)){}
							else if((type1 == 3 || type1 == 8) && (type2 == 3 || type2 == 8)){}
							else if((type1 == 4 || type1 == 9 ) && (type2 == 4 || type2 == 9)){}
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
							
							if(type1 == 0 || type1 == 1) {
								fprintf( f1, "\t inc R%01d \n", last-1);
								fprintf( f1, "\t mov %s, R%01d \n", p->opr.op[0]->id.name, last - 1);
							}
							else {
								fprintf( f1, "Error: incompatible operands for increment \n");
							}
                            oprType = NULL;
							break;
						case DECREMENT:
							if(type1 == 0 || type1 == 1) {
								fprintf( f1, "\t dec R%01d \n", last-1);
								fprintf( f1, "\t mov %s, R%01d \n", p->opr.op[0]->id.name, last - 1);
							}
							else {
								fprintf( f1, "Error: incompatible operands for decrement \n");
							}
                            oprType = NULL;
							break;							
						case PEQUAL:
							
							break;
						case MEQUAL:
							
							break;
						case MULEQUAL:
							
							break;
						case DIVEQUAL:
							
							break;
                    
					}
				}
			}
    return 0;

}
	

	
