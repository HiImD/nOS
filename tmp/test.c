#include <stddef.h>

size_t strlen(const char* str){
    size_t l = 0;
    while(str[l]) l++;
    return l;
}

int main(int argc, char const *argv[])
{
    const char* str = "abd";
    strlen(str);
    return 0;
}
