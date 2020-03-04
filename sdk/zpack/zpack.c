#define	USE_TI89
#define	USE_TI92PLUS

#include <kernel.h>

#define	ZIPLIB_VERSION	1
#define	ZIPLIB_FUNCTION	12

void	_main(){
  ESI argptr;
  int argtype;
  SYM_STR files[255];
  SYM_STR current;
  char	*files_ansi[255];
  char	*name;
  unsigned short	files_size[255];
  int	file_index = 0;
  long	size = 32, sizefile;
  SYM_ENTRY *sym;
  unsigned short *file;
  unsigned short *output;
  unsigned char *outc;
  HANDLE hd;
    int i;
	clrscr();
	FontSetSys(F_4x6);
	printf(	"Creating a Pack Archive...\n"
		"Usage: zpack(\"graphlib\",\"uselib\",\"doorslib\")\n");
	InitArgPtr (argptr);
	while ((argtype = GetArgType (argptr)) != END_TAG) {
		if (argtype != STR_TAG) {
			printf("Argument is not a string.\n");
			ngetchx();
			exit(1);
		}
		files[file_index] = current = GetSymstrArg (argptr);
		name = (char *) current; while (*(--name) != 0); name++;
		files_ansi[file_index++] = name;
		if (file_index > 255) {
			printf("Error: Too many files !");
			ngetchx();
			exit(9);
		}
		printf("Processing %s...\n", name);
		sym = SymFindPtr(current,0);
		if (!sym) {
			printf("::File not found !\n");
			goto found;
		}
		file = HLock(sym->handle);
		if (!file) {
			printf("::Cannot Deref file!\n");
			ngetchx();
			exit(2);
		}
		sizefile = ziplib_eval_cmem(file, *file+2);
		files_size[file_index-1] = (sizefile+1) /2*2;
		if (!sizefile) {
			printf("::Not enought memory !\n");
			ngetchx();
			exit(3);
		}
		printf("::Org: %d Comp: %d\n", *file+2, (short) sizefile);
		HeapUnlock(kernel_Ptr2Hd(file));
		size += ((sizefile+1)/2)*2 + 2 + strlen(name)+1;
	}	
	printf("Error: cannot find an empty file\n");
	exit(5);

found:	if (--file_index <= 0) {
		printf("Error: Too few arguments.\n");
		ngetchx();
		exit(6);
	}
	hd = HeapAlloc(size);
	if (!hd) {
		printf("Error: Too few memory to alloc file\n");
		ngetchx();
		exit(7);
	}
	output = HLock(hd);
	if (!output) {
		printf("AMS internal error\n");
		ngetchx();
		exit(8);
	}
	printf("Creating variable...\n");
	*(output++) = size-2;
	*(output++) = 0x6104;
	*(output++) = '6'*256+'8';
	*(output++) = 'c'*256+'A';
	*(output++) = 0x2F38;
	*(output++) = 0x0050;
	*(output++) = 0x6602;
	*(output++) = 0x508F;
	*(output++) = 0x4E75;
	outc = (unsigned char *) output; 
	*(outc++) = file_index;
	*(outc++) = ZIPLIB_VERSION;	
	*(outc++) = ZIPLIB_FUNCTION;
	*(outc++) = 'z';
	*(outc++) = 'i';
	*(outc++) = 'p';
	*(outc++) = 'l';
	*(outc++) = 'i';
	*(outc++) = 'b';
	*(outc++) = 0;

	for(i = 0 ; i < file_index ; i++) {
		name = files_ansi[i];
		while (*name)
			*(outc++) = *(name++);
		*(outc++) = 0;
	}
	if (((long) outc) & 1)
		outc++;
	for(i = 0 ; i < file_index ; i++) {
		printf("Compressing %s...\n", files_ansi[i]);
		*(outc++) = files_size[i]/256;
		*(outc++) = files_size[i]%256;
		file = HLock(SymFindPtr(files[i],0)->handle);
		ziplib_compress(file, *file+2, outc);
		outc += files_size[i];
	}
	*(outc++) = 0;
	*(outc++) = 0;
	*(outc++) = 0xF3;
	*((unsigned short*) HeapDeref(hd)) = outc - (unsigned char *) HeapDeref(hd)-2;
	HeapUnlock(hd);
	// Add file to VAT
	sym = DerefSym(SymAdd(files[file_index]));
	if (!sym) {
		printf("Error: Cannot create %s !\n", files_ansi[file_index]);
		HeapFree(hd);
		ngetchx();
		exit(15);
	}
	sym->handle = hd;
	printf("Done !\n");
	ngetchx();
}
