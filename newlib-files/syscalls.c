/* note these headers are all provided by newlib - you don't need to provide them */
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/times.h>
#include <sys/errno.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdbool.h>
#include <fcntl.h>
#include <stdarg.h>

#define SYSCALL_EXIT    0
#define SYSCALL_CLOSE   1
#define SYSCALL_ENVC    2
#define SYSCALL_ENVLEN  3
#define SYSCALL_ENVCP   4
#define SYSCALL_ARGC    5
#define SYSCALL_ARGLEN  6
#define SYSCALL_ARGCP   7
#define SYSCALL_START   8
#define SYSCALL_PID     9
#define SYSCALL_SEEK    10
#define SYSCALL_READ    11
#define SYSCALL_WRITE   12
#define SYSCALL_MAP     13
#define SYSCALL_CLS     14
#define SYSCALL_YIELD   15
#define SYSCALL_OPEN    16
#define SYSCALL_TTY     17
#define SYSCALL_FORK    18
#define SYSCALL_FSTAT   19
#define SYSCALL_STAT    20
#define SYSCALL_LINK    21
#define SYSCALL_SBRK    22
#define SYSCALL_TIMES   23
#define SYSCALL_UNLINK  24
#define SYSCALL_WAIT    25
#define SYSCALL_TOFDAY  26
#define SYSCALL_KILL    27
#define SYSCALL_SIGNAL  28

struct MYOS_STAT
{
    unsigned st_mode;
    // TODO
};

#undef errno
extern int errno;

__attribute__((noreturn))
void _exit(int exit_code)
{
    asm volatile("int $0x80"::"a"(SYSCALL_EXIT),"b"(exit_code));
    do
    {
        asm volatile ("hlt");
    }
    while (true);
}

// Close a file.
int close(int file)
{
    int retval;
    asm volatile("int $0x80":"=a"(retval):"a"(SYSCALL_CLOSE),"d"(file));
    return retval;
}
char **environ; /* pointer to array of char * strings that define the current environment variables */

// Transfer control to a new process.
int execve(char *name, char **argv, char **env)
{
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_START),"b"(name),"S"(argv),"D"(env));
    return retval;
}

// Create a new process.
int fork()
{
    int retval;
    int e;
    asm volatile("int $0x80"
        : "=a"(retval),"=b"(e)
        : "a"(SYSCALL_FORK));
    if (retval == -1)
    {
        errno = e;
    }
    return retval;
}

// Status of an open file.
// For consistency with other minimal implementations in these examples,
// all files are regarded as character special devices.
// The `sys/stat.h' header file is distributed in the `include'
// subdirectory for this C library.
int fstat(int file, struct stat *st)
{
    struct MYOS_STAT _stat;
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_STAT),"d"(file),"D"(st));
    st->st_mode = (mode_t)_stat.st_mode;
    // TODO: The rest
    return retval;
}

// Process-ID; This is sometimes used to generate strings unlikely to
// conflict with other processes.
int getpid()
{
    int pid;
    asm volatile("int $0x80":"=a"(pid):"a"(SYSCALL_PID));
    return pid;
}

// Query whether output stream is a terminal.
int isatty(int file)
{
    int result;
    asm volatile("int $0x80":"=a"(result):"a"(SYSCALL_TTY));
    return result;
}

// Send a signal.
int kill(int pid, int sig)
{
    if (pid == 1)
    {
        _exit(sig);
        return 0;
    }
    else
    {
        int retval;
        int e;
        asm volatile("int $0x80"
            : "=a"(retval),"=b"(e)
            : "a"(SYSCALL_KILL),"c"(pid),"d"(sig));
        if (retval == -1)
        {
            errno = e;
        }
        return retval;
    }
    
}

// Establish a new name for an existing file.
int link(char *old, char *new)
{
    int retval;
    int e;
    asm volatile("int $0x80"
        : "=a"(retval),"=b"(e)
        : "a"(SYSCALL_LINK),"S"(old),"D"(new));
    if (retval == -1)
    {
        errno = e;
    }
    return retval;
}

// Set position in a file.
int lseek(int file, int ptr, int dir)
{
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_SEEK),"d"(file),"S"(ptr),"c"(dir));
    return retval;
}

// Open a file.
int open(const char *name, int flags, ...)
{
    mode_t mode = 0;
    if (flags & O_CREAT)
    {
        va_list vl;
        va_start(vl, flags);
        mode = (mode_t)va_arg(vl, unsigned);
        va_end(vl);
    }
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_OPEN),"S"(name),"c"(flags),"d"((unsigned)mode));
    return retval;
}

// Read from a file.
int read(int file, char *ptr, int len)
{
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_READ),"d"(file),"D"(ptr),"c"(len));
    return retval;
}

// Increase program data space.
caddr_t sbrk(int incr)
{
    extern char end;		/* Defined by the linker */
    static char *heap_end;
    char *prev_heap_end;
    if (heap_end == 0) {
        heap_end = &end;
    }
    asm volatile("int $0x80"
        :: "a"(SYSCALL_SBRK),"b"(heap_end),"c"(incr));
    prev_heap_end = heap_end;
    heap_end += incr;
    return (caddr_t) prev_heap_end;
}

// Status of a file (by name).
int stat(const char *file, struct stat *st)
{
    struct MYOS_STAT _stat;
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_STAT),"S"(file),"D"(st));
    st->st_mode = (mode_t)_stat.st_mode;
    // TODO: The rest
    return retval;
}

// Timing information for current process.
clock_t times(struct tms *buf)
{
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_TIMES),"D"(buf));
    return retval;
}

// Remove a file's directory entry.
int unlink(char *name)
{
    int retval;
    int e;
    asm volatile("int $0x80"
        : "=a"(retval),"=b"(e)
        : "a"(SYSCALL_UNLINK),"D"(name));
    if (retval == -1)
    {
        errno = e;
    }
    return retval;
}

// Wait for a child process.
int wait(int *status)
{
    int retval;
    int e;
    asm volatile("int $0x80"
        : "=a"(retval),"=b"(e)
        : "a"(SYSCALL_WAIT),"D"(status));
    if (retval == -1)
    {
        errno = e;
    }
    return retval;
}

// Write a character to a file.
int write(int file, char *ptr, int len)
{
    int retval;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_WRITE),"D"(file),"S"(ptr),"c"(len));
    return retval;
}

/*int gettimeofday(struct timeval *p, struct timezone *z)
{
    int retval;
    int e;
    asm volatile("int $0x80"
        : "=a"(retval),"=b"(e)
        : "a"(SYSCALL_TOFDAY),"S"(p),"D"(z));
    if (retval == -1)
    {
        errno = e;
    }
    return retval;
}*/

void (*signal(int sig, void (*func)(int)))(int)
{
    void (*retval)(int);
    int e;
    asm volatile("int $0x80"
        : "=a"(retval)
        : "a"(SYSCALL_SIGNAL),"d"(sig),"D"(func));
    return retval;
}
