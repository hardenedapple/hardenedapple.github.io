#include <assert.h>
#include <stdint.h>
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

typedef int (**strcmpptr) (const char *, const char *);

strcmpptr getgot(void)
{
    uint8_t *pltaddr = (uint8_t *)&strcmp;
    // Note on the encoding I see on my machine (could easily be different on
    // other machines).
    // Uses the ff /4 opcode, which uses the ModR/M byte, so the bytes of the
    // instruction are
    // \xff \x25 <64 bit address>
    // Which is binary 0b00100101, so the Mod field is 00, the REG field is
    // 100, and the R/M field is 101. Here the REG field is used to extend the
    // opcode with the number 4, and the Mod and R/M fields combine to tell the
    // processor to load an address from an offset to the instruction pointer
    // specified in the instruction stream (which is at strcmp@plt + 2 in
    // memory).
    // I haven't handled any other encoding, so we just assert this is the
    // case. If it isn't whoever trips over this will easily see what has
    // happened (via this comment).
    assert(pltaddr[0] == 0xff);
    assert(pltaddr[1] == 0x25);
    uintptr_t offset = *(uint32_t *)(pltaddr + 2);
    // 4 bytes for address + 1 bytes for opcode + 1 ModR/M byte
    // Despite the compiler warning, we know this is only a 32 bit number
    // because of the instruction
    offset += (uintptr_t)(pltaddr + 6);
    return (strcmpptr)offset;
}

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
        strcmpptr strcmpgot = getgot();
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
