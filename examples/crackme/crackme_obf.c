// Taken from https://github.com/reversinghub/crackme-angr-elf

#include <stdio.h>
#include <string.h>
#include <time.h>

#define OBFUSCATE __attribute__((annotate("POP")))

typedef struct myNode
{
  char idx;
  struct myNode* ptr;
} myNode;

myNode v[10] =
{
    {'a', &v[6]},
    {'0', &v[3]},
    {'d', &v[1]},
    {'f', &v[7]},
    {'b', &v[2]},
    {'c', &v[4]},
    {'8', &v[0]},
    {'3', &v[5]},
    {'7', &v[9]},
    {'e', &v[8]} 
};

char password[] = "a0dfbc837e";

// Flag: ./crackme 6241570398
char input[10] = {0};

char modified_input[10] = {0};

__attribute__((noinline)) OBFUSCATE void obfuscated(void* x)
{
    // printf("%llx\n", x);
    int i;
    int pos;

    printf("[*] Hello! Please enter the password: ");
    scanf("%10s", input);
    
    for(i = 0; i < 10; i++)
    {     
        myNode* n;
        
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

OBFUSCATE int main()
{
    volatile void* x = (void*)time(NULL);
    obfuscated(x);
}