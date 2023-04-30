#include <stdlib.h>
#include <stdio.h>

void null_cipher_sf() {
    // given
    char a0[] = "garbagetrash";
    char a1[] = "Where is the best school in New York?";
    int a2[] = { 0, 2, 1, 0, 5, 2, 0, 1 };
    int a3 = sizeof(a2)/sizeof(int);

    char *s0 = a0; // address of next byte to write
    char *s1 = a1; // address of current byte in input

    int v0 = 0;

    int *s2 = a2; // address of current char index
    while (a3 != 0) {
        int s3 = *s2; // the index we need

        if (s3 == 0) { // basically jump to MOVE TO NEXT WORD
            while (1) {
                s1++;
                if (*s1 == ' ')
                    break;
                
                if (*s1 == '\0') // JUMP TO END
                    break;
            }

            if (*s1 == '\0') // JUMP TO END
                break;
            
            s1++;
            
            s2++;    
            a3--;
            continue;
        }

        // find the right letter
        s1+= s3 - 1;

        // store this in plantext
        *s0 = *s1;
        s0++;
        v0++;
        
        // MOVE TO NEXT WORD
        // move character pointer of input to next word
        while (1) {
            s1++;
            if (*s1 == ' ')
                break;
            
            if (*s1 == '\0') // JUMP TO END
                break;
        }

        if (*s1 == '\0') // JUMP TO END
            break;
        
        s1++;

        s2++;    
        a3--;
    }

    // END LABEL
    if (*s0 != '\0')
        *s0 = '\0';
    
    printf("ciphered=\"%s\"\n", a0);
    printf("v0=%d\n", v0);
}

void transposition_cipher_sf() {
    char a0[] = "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg";
    char a1[] = "Wspoethad,mhtrv etie aeuoev ,nsmnndglea  !a!eeryrtme n*vna y yxs *etmc n pio*rs oliblgh*  ldagroh *";
    int a2 = 11;
    int a3 = 9;

    int v0 = 0;

    

    printf("output=\"%s\"\n", a0);
    printf("v0=%d\n", v0);
}

int main() {
    // null_cipher_sf();
    transposition_cipher_sf();
    return EXIT_SUCCESS;
}
