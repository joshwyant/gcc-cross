#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

extern int main(int argc, char **argv);
char **environ;

__attribute__((noreturn))
void _start()
{
    int argc, envc, i, len;
    char *str, **argv;

    // Get args
    asm volatile("int $0x80":"=a"(argc):"a"(5)); // Get argc
    argv = calloc(argc + 1, sizeof(char*));  // plus an empty entry
    for (i = 0; i < argc; i++)
    {
        asm volatile("int $0x80":"=a"(len):"a"(6),"d"(i)); // Get argv[i] len
        str = calloc(len + 1, sizeof(char));
        argv[i] = str;
        asm volatile("int $0x80"::"a"(7),"d"(i),"b"(str)); // Copy argv[i]
    }

    // Get environment variables
    asm volatile("int $0x80":"=a"(envc):"a"(2)); // Get env count
    environ = calloc(envc + 1, sizeof(char*));  // plus an empty entry
    for (i = 0; i < envc; i++)
    {
        asm volatile("int $0x80":"=a"(len):"a"(3),"d"(i)); // Get environ[i] len
        str = calloc(len + 1, sizeof(char));
        environ[i] = str;
        asm volatile("int $0x80"::"a"(4),"d"(i),"b"(str)); // Copy environ[i]
    }

    // Call main()
    int ret_val = main(argc, argv);

    // Clean up
    for (i = 0; i < envc; i++)
    {
        free(environ[i]);
    }
    free(environ);
    for (i = 0; i < argc; i++)
    {
        free(argv[i]);
    }
    free(argv);

    // Exit and wait
    exit(ret_val);
    do
    {
        asm volatile ("hlt");
    }
    while (true);
}
