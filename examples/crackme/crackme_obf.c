// Taken from https://github.com/reversinghub/crackme-angr-elf

#include <stdio.h>
#include <string.h>
#include <time.h>

#define OBFUSCATE __attribute__((annotate("POP")))

typedef struct myNode{
  char idx;
  struct myNode *ptr;
} myNode;

myNode v[10] = {
    {'a', &v[6]}, /* v[0] */
    {'0', &v[3]}, /* v[1] */
    {'d', &v[1]}, /* v[2] */
    {'f', &v[7]}, /* v[3] */
    {'b', &v[2]}, /* v[4] */
    {'c', &v[4]}, /* v[5] */
    {'8', &v[0]}, /* v[6] */
    {'3', &v[5]}, /* v[7] */
    {'7', &v[9]}, /* v[8] */
    {'e', &v[8]}  /* v[9] */
};

char password[] = "a0dfbc837e";

// Input data (correct flag is 6241570398)
char input[10] = {0};

char modified_input[10] = {0};

__attribute__((noinline)) OBFUSCATE void obfuscated(void* x)
{
    printf("%llx\n", x);
    int i;
    int pos;

    printf("[*] Hello! Please enter the password: ");
    scanf("%10s", input);
    
    for(i = 0; i < 10; i++)
    {     
        myNode *n;
        
        pos = input[i] - '0';
        // printf("Idx:%d char:%c pos:%d\n", i, p[i], pos);
        
        if (pos < 0 || pos > 9)
            continue;
            
        n = v[pos].ptr;
        modified_input[i] = (*n).idx;
        // printf("%c \n", (*n).idx);
    }
    
    if(!strcmp(modified_input, password))
    {
        printf("[*] Congratulations! You have found the flag.\n");
    } 
    else 
    {
        printf("[-] Invalid flag! Try again...\n");
    }   
}

OBFUSCATE int main( void )
{
    volatile void* x = (void*)time(NULL);
    obfuscated(x);
}