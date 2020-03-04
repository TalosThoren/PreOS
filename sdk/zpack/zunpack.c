#define	USE_TI89
#define	USE_TI92PLUS

#include <kernel.h>

void	_main(){
  ESI argptr;
  SYM_STR current;
  char	*name;
  SYM_ENTRY *sym;
  HANDLE hd;

	clrscr();
	FontSetSys(F_4x6);
	printf(	"UnPacking from a Pack Archive...\n"
		"Usage: zunpack(\"graphlib\")\n");
	InitArgPtr (argptr);
	if (GetArgType (argptr) != STR_TAG) {
		printf("Argument is not a string.\n");
		ngetchx();
		exit(1);
	}
	current = GetSymstrArg (argptr);
	name = (char *) current; while (*(--name) != 0); name++;
	hd = kernel_ExtractFile(name);
	if (!hd) {
		printf("Error: Cannot find %s in pack archive files.", name);
		ngetchx();
		exit(2);
	}
	sym = SymFindPtr(current, 0);
	if (sym) {
		printf("Error: file already exist.");
		HeapFree(hd);
		ngetchx();
		exit(3);
	}
	sym = DerefSym(SymAdd(current));
	if (!sym) {
		printf("Error: cannot create file.");
		HeapFree(hd);
		ngetchx();
		exit(3);
	}
	sym->handle = hd;
 }
