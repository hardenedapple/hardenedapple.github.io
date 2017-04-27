#include <assert.h>
#include <stdio.h>
#include <string.h>

int altstrcmp(const char *s1, const char *s2)
{
    while (*s1 && *s2) {
        if (*s1 < *s2 - 1) {
            return -1;
        }
        if (*s1 > *s2 - 1) {
            return 1;
        }
        s1++;
        s2++;
    }
    if (*s1) {
        return 1;
    }
    if (*s2) {
        return -1;
    }
    return 0;
}

// Need to initialise this so that it's defined in .data instead of .bss, which
// means we can modify it in the file.
int (**strcmpgot) (const char *, const char *) = (int (**) (const char *, const char *))100;

int check_password(const char* password)
{
    if (strcmp("etmrhdr ", password) == 0) {
        return 1;
    }
    return 0;
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        puts("Usage: ./<binary> password");
        return 1;
    }
    if (check_password(argv[1])) {
        puts("Congratulations!!!");
    } else {
        int (*origstrcmp) (const char *, const char *) = *strcmpgot;
        *strcmpgot = altstrcmp;
        if (check_password(argv[1])) {
            puts("So close ... !!");
        } else {
            puts("Sorry, that's the wrong password");
        }
        *strcmpgot = origstrcmp;
        // Double check we've managed to reset it.
        assert(strcmp("hello", "hello") == 0);
    }
    return 0;
}
