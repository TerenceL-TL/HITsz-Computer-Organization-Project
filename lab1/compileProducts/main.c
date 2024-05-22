// #include <stdio.h>
#include "func.h"

#define STR_A   "1qab9a0bcabcds13"  
#define STR_B   "bcds"  

int main()
{
    int pos = find_substr(STR_A, STR_B, 16, 4);     
    /* printf("%d\n", pos); */

    return pos;     
}

