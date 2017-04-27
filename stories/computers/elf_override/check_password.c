#include <string.h>

int check_password(const char* password)
{
    if (strcmp("etmrhdr ", password) == 0) {
        return 1;
    }
    return 0;
}
