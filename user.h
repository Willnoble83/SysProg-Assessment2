struct stat;
struct rtcdate;

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int getch(void);
int greeting(void);
int add(int a, int b);
int test(void);
int videomodevga12(void);
int videomodevga13(void);
int videomodetext(void);
int setspecificpixel(int,int , int);
int clearscreen13h(void);
int clearscreen12h(void);
//draw.c
//int ClearScreen(int, int, int);
long abs (long);
//x1, y1, x2,y2,colour
void DrawLine(int,int,int,int,int);

// TODO: Declare your user APIs for your system calls.

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);

