#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include"structs.h"

typedef struct SymTableData
{
    int symType;
    int symInit;
    int symUsed;
    int symBraces;
    char * symValue;
    char * symName;
    permission symPerm;

}SymTableData;


/* A linked list symTableNode */
typedef struct symTableNode 
{
    struct SymTableData * data;
    int index;
    struct symTableNode *next;
} symTableNode;
 

struct SymTableData* getSymTableData(int type, int init, int used, int brace,char * name,permission perm );
void insertFirst(int index, struct SymTableData* data);
struct symTableNode* deleteFirst();
int length();
bool isEmpty() ;
struct SymTableData* find(int index);
void printList();
void setValue(int index, char * value);
void setBrace(int findBrace);
void setUsed(int findIndex);
void setInit(int findIndex);
void printUsed(FILE *f);
void printNotUsed(FILE *f);
void printInit(FILE *f);
void printNotInit(FILE *f);
bool nameUniqueInScope(char * name, int brace);
int getIndex(char * name, int brace);