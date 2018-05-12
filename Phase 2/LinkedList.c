#include "LinkedList.h"
#include<string.h>

struct symTableNode * head = NULL;
struct symTableNode * current = NULL;

struct SymTableData* getSymTableData(int type, int init, int used, int brace, char * name,permission perm )
{
    struct SymTableData *data = (struct SymTableData*) malloc(sizeof(struct SymTableData));
    data->symType = type;
    data->symInit = init;
    data->symUsed = used;
    data->symBraces = brace;
    data->symName = strdup(name);
    data->symPerm = perm;

    return data;
}

void setValue(int index, char * value)
{
    SymTableData * data = find(index);
    data->symValue = strdup(value);
}


int getIndex(char * name, int brace)
{
    struct symTableNode *ptr = head;
    int index = -1;

    //start from the beginning
    while(ptr != NULL)
    {
       if (strcmp(name,ptr->data->symName) == 0 && ptr->data->symBraces != -5 )
        {
            if (ptr->data->symBraces == brace)
            {
                return ptr->index;
            }
            else
            {
                index = ptr->index;
            }
        }

       ptr = ptr->next;
    }

    return index;
}

// loops on all symbol Table and sets the attribute symBrace to -5
// for identifiers having brace = findBrace
void setBrace(int findBrace)
{
    struct symTableNode *ptr = head;

    //start from the beginning
    while(ptr != NULL)
    {
      if (ptr->data->symBraces == findBrace)
      {
         ptr->data->symBraces = -5;
      }
       ptr = ptr->next;
    }
}

// sets the symUsed attribute to 1 for the identifier having index = findIndex
void setUsed(int findIndex)
{
    SymTableData * data = find(findIndex);
    data->symUsed = 1;
}

// sets the symInit attribute to 1 for the identifier having index = findIndex
void setInit(int findIndex)
{
    SymTableData * data = find(findIndex);
    data->symInit = 1;
}

//display the list
 void printList() {
    struct symTableNode *ptr = head;
    printf("\nCurrent List\n[ ");

    //start from the beginning
    while(ptr != NULL)
    {
       printf("(index = %d, name = %s, init = %d, used = %d, brace = %d\n)",
              ptr->index,ptr->data->symName,ptr->data->symInit,
              ptr->data->symUsed,ptr->data->symBraces);
       ptr = ptr->next;
    }

    printf(" ]\n\n");
 }

 void printUsed()
 {
     struct symTableNode *ptr = head;
     printf("Used Identifiers:\n[ ");

     //start from the beginning
     while(ptr != NULL)
     {
       if (ptr->data->symUsed == 1)
       {
           printf("%s\t",ptr->data->symName);
       }
        ptr = ptr->next;
     }

     printf(" ]\n");
 }
 void printNotUsed()
 {
     struct symTableNode *ptr = head;
     printf("Unused Identifiers:\n[ ");

     //start from the beginning
     while(ptr != NULL)
     {
       if (ptr->data->symUsed == 0)
       {
           printf("%s\t",ptr->data->symName);
       }
        ptr = ptr->next;
     }

     printf(" ]\n");
 }
 void printInit()
 {
     struct symTableNode *ptr = head;
     printf("Initialized Identifiers\n[ ");

     //start from the beginning
     while(ptr != NULL)
     {
       if (ptr->data->symInit == 1)
       {
           printf("%s\t",ptr->data->symName);
       }
        ptr = ptr->next;
     }

     printf(" ]\n");
 }
 void printNotInit()
 {
     struct symTableNode *ptr = head;
     printf("Uninitialized Identifiers\n[ ");

     //start from the beginning
     while(ptr != NULL)
     {
       if (ptr->data->symInit == 0)
       {
           printf("%s\t",ptr->data->symName);
       }
        ptr = ptr->next;
     }

     printf(" ]\n");
 }


bool nameUniqueInScope(char * name, int brace)
{
    struct symTableNode *ptr = head;

    //start from the beginning
    while(ptr != NULL)
    {
       if (strcmp(name,ptr->data->symName) == 0)
        {
            if (ptr->data->symBraces == brace)
            {
               return false;
            }
        }

       ptr = ptr->next;
    }

    return true;
}


void insertFirst(int index, struct SymTableData* data) {
   //create a link
   struct symTableNode *link = (struct symTableNode*) malloc(sizeof(struct symTableNode));

   link->index = index;
   link->data = data;

   //point it to old first symTableNode
   link->next = head;

   //point first to new first symTableNode
   head = link;
}

//delete first item
struct symTableNode* deleteFirst() {

   //save reference to first link
   struct symTableNode *tempLink = head;

   //mark next to first link as first
   head = head->next;

   //return the deleted link
   return tempLink;
}

//is list empty
bool isEmpty() {
   return head == NULL;
}

int length() {
   int length = 0;
   struct symTableNode *current;

   for(current = head; current != NULL; current = current->next) {
      length++;
   }

   return length;
}

//find a link with given key
struct SymTableData* find(int index) {

   //start from the first link
   struct symTableNode* current = head;

   //if list is empty
   if(head == NULL) {
      return NULL;
   }

   //navigate through list
   while(current->index != index) {

      //if it is last symTableNode
      if(current->next == NULL) {
         return NULL;
      } else {
         //go to next link
         current = current->next;
      }
   }

   //if data found, return the current Link
   return current->data;
}