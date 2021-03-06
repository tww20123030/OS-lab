// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "time", "Display the running time of program", mon_time },
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

unsigned read_eip();

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-entry+1023)/1024);
	return 0;
}
inline uint64_t GetCycleCount()
{
	uint64_t time;
 	__asm __volatile("rdtsc": "=r" (time));
	return time;
}
int mon_time(int argc, char **argv, struct Trapframe *tf){
	int time = 0;
	int i;

	for (i = 0; i < NCOMMANDS; i++){
		if(*commands[i].name == *argv[1]){
			time = (int)GetCycleCount();
			commands[i].func(argc, argv, tf);
			time = (int)GetCycleCount()- time;
			cprintf("%s cycles: %d\n", commands[i].name, time);
		}
	}
		//cprintf("%s %s\n",commands[0].name,commands[1].name);
	return time;
}

// Lab1 only
// read the pointer to the retaddr on the stack
static uint32_t
read_pretaddr() {
    uint32_t pretaddr;
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
    return pretaddr;
}

void
do_overflow(void)
{
    cprintf("Overflow success\n");
}

void getbuff(char* str){
	int *pret;
	int *p = (int*)str;
	pret = (int*)read_pretaddr();
	*p = *pret;//the normal return address of getbuff
	*pret = (int)(p+1);//set the return  address to the address of attack code
	return;
}
void
start_overflow(void)
{
	// You should use a techique similar to buffer overflow
	// to invoke the do_overflow function and
	// the procedure must return normally.

    // And you must use the "cprintf" function with %n specifier
    // you augmented in the "Exercise 9" to do this job.

    // hint: You can use the read_pretaddr function to retrieve 
    //       the pointer to the function call return address;
    
    char str[256] = {};
    int nstr = 0;
    char *pret_addr;
	// Your code here.
    char num;
    int *ptr = (int*)str;
    
    ptr[1] = 0xff24148b;
    ptr[2] = 0x831a8b32;
    ptr[3] = 0x555337c3;
    ptr[4] = 0xc3c9e589;
    getbuff(str);
    cprintf("%s%n\n",str,&num);
}

void
overflow_me(void)
{
        start_overflow();
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
    struct Eipdebuginfo debuginfo;
    struct Eipdebuginfo *info = &debuginfo;

    uint32_t *pebp;
    int i;
    pebp = (uint32_t*)read_ebp();
    //cprintf("pebp:%p %p\n",pebp, pebp+1);
    for(i = 0; i < 7; i++){
    	cprintf("eip %08x  ebp %p  args %08x %08x %08x %08x %08x\n",*(pebp+1), pebp, *(pebp+2), *(pebp+3), *(pebp+4), *(pebp+5), *(pebp+6));
    	debuginfo_eip(*(pebp+1),info);
	cprintf("	%s:%d: %s+%d\n",info->eip_file, info->eip_line, info->eip_fn_name, *(pebp+1)-info->eip_fn_addr);
	pebp = (uint32_t*)*(pebp);
    }
    overflow_me();
    cprintf("Backtrace success\n");
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
	return callerpc;
}
