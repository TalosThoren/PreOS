#include <stdio.h>
#include <string.h>
#include "object.h"

// Names of variables defined by linker
char *SpecialNames[]={"LCD_MEM","SYM_ENTRY.name","SYM_ENTRY.flags",
	"SYM_ENTRY.hVal","SYM_ENTRY_LENGTH",""};

Object::Object(char *fn)
{
	// Copy file name and add extension
	filename=new char[strlen(fn)+3];
	sprintf(filename,"%s.o",fn);
	// Initialize information variables
	output89=0; output92=0; output92Plus=0;
	mainOfs=OfsNotDefined; commentOfs=OfsNotDefined; exitOfs=OfsNotDefined;
	extraRAMOfs=OfsNotDefined; stubType=StubNormal;
	code=NULL; codeSize=0;
	bssSize=0;
	reloc[RelocCode].count=0; reloc[RelocCode].ofs=NULL;
	reloc[RelocBSS].count=0; reloc[RelocBSS].ofs=NULL;
	exportCount=0;
	ROM.count=0; RAM.count=0; libCount=0; special.count=0;
}

Object::~Object()
{
	// Free filename memory
	delete[] filename;
}

int Object::Read()
{
	FILE *fp=fopen(filename,"rb");
	// Process each hunk in the object file
	while (1)
	{
		if (feof(fp)) break;
		int hunk=ReadDWord(fp);
		if (hunk==HunkCode)
		{
			int size=ReadDWord(fp); // Size is in DWORDs
			// Allocate space for the code
			code=new char[size<<2];
			codeSize=size<<2;
			// Read the code into memory
			fread(code,size,4,fp);
		}
		else if (hunk==HunkBSS)
			bssSize=ReadDWord(fp)<<2;
		else if (hunk==HunkR32)
		{
			// Read each section's relocations
			while (1)
			{
				int count=ReadDWord(fp);
				if (!count) break;
				int section=ReadDWord(fp);
				if ((section==RelocCode)||(section==RelocBSS))
				{
					// Check to see if the section has already been defined
					if (reloc[section].ofs)
					{
						printf("Error: Duplicate or split relocation information\n");
						return 1;
					}
					reloc[section].count=count;
					reloc[section].ofs=new int[count];
					// Read in the relocation info
					for (int i=0;i<count;i++)
						reloc[section].ofs[i]=ReadDWord(fp);
				}
				else
				{
					// Unknown section number, so skip relocations
					for (int i=0;i<count;i++)
						ReadDWord(fp);
				}
			}
		}
		else if (hunk==HunkR16)
		{
			printf("Error: 16-bit relocations are unsupported\n");
			return 1;
		}
		else if (hunk==HunkR8)
		{
			printf("Error: 8-bit relocations are unsupported\n");
			return 1;
		}
		else if (hunk==HunkExt) // Exports or external references
		{
			// Read each entry
			while (1)
			{
				int size=ReadDWord(fp);
				// High byte of size contains type byte
				int type=(size>>24)&0xff;
				size&=0xffffff;
				if (type==TypeEnd)
					break;
				// Read name of symbol
				char sym[(size<<2)+1];
				int i;
				for (i=0;i<(size<<2);i++)
					sym[i]=fgetc(fp);
				sym[i]=0;
				if (type==TypeExport)
				{
					// Get offset of exported function
					int ofs=ReadDWord(fp);
					// Check for special export names
					if (!strcmp(sym,"_ti89"))
						output89=1;
					else if (!strcmp(sym,"_ti92"))
						output92=1;
					else if (!strcmp(sym,"_ti92plus"))
						output92Plus=1;
					else if (!strcmp(sym,"_main"))
						mainOfs=ofs;
					else if (!strcmp(sym,"_comment"))
						commentOfs=ofs;
					else if (!strcmp(sym,"_exit"))
						exitOfs=ofs;
					else if (!strcmp(sym,"_extraram"))
						extraRAMOfs=ofs;
					else if (!strcmp(sym,"_nostub"))
						stubType=StubNone;
					else if (!strcmp(sym,"_nokernel"))
						stubType=StubStandalone;
					else if (!strcmp(sym,"_library"))
						stubType=StubLibrary;
					else if (strlen(sym)>4) // Long enough for exported label?
					{
						// Make sure label is a valid export
						if (sym[strlen(sym)-5]!='@')
						{
							printf("Error: Unknown exported label '%s'\n",sym);
							return 1;
						}
						// Check to make sure number is correct
						int num=-1; // Initialize in case sscanf fails
						sscanf(&sym[strlen(sym)-4],"%x",&num);
						if (num!=exportCount)
						{
							printf("Error: Exported function xdef out of order or invalid\n");
							return 1;
						}
						// Add label to export table
						exportOfs[exportCount++]=ofs;
					}
				}
				else if (type==TypeImport32)
				{
					// Read number of references
					int count=ReadDWord(fp);
					if (!strncmp(sym,"_ROM_CALL_",10))
					{
						// Add references to ROM reference table
						int func=-1; // Initialize in case sscanf fails
						sscanf(&sym[10],"%x",&func);
						if (func==-1)
						{
							printf("Error: Undefined symbol '%s'\n",sym);
							return 1;
						}
						for (i=0;i<count;i++)
						{
							ROM.ref[ROM.count].type=LibRefDWord;
							ROM.ref[ROM.count].func=func;
							ROM.ref[ROM.count++].ofs=ReadDWord(fp);
						}
					}
					else if (!strncmp(sym,"_RAM_CALL_",10))
					{
						// Add references to RAM reference table
						int func=-1; // Initialize in case sscanf fails
						sscanf(&sym[10],"%x",&func);
						for (i=0;i<count;i++)
						{
							RAM.ref[RAM.count].type=LibRefDWord;
							RAM.ref[RAM.count].func=func;
							RAM.ref[RAM.count++].ofs=ReadDWord(fp);
						}
					}
					else if (!strncmp(sym,"_extraramaddr@",14))
					{
						// Add references to RAM reference table, setting
						// the extra flag
						int func=-1; // Initialize in case sscanf fails
						sscanf(&sym[14],"%x",&func);
						for (i=0;i<count;i++)
						{
							RAM.ref[RAM.count].type=LibRefDWord|LibRefExtra;
							RAM.ref[RAM.count].func=func;
							RAM.ref[RAM.count++].ofs=ReadDWord(fp);
						}
					}
					else // Library or linker-defined reference
					{
						for (i=0;SpecialNames[i][0];i++)
						{
							if (!strcmp(sym,SpecialNames[i]))
								break;
						}
						if (SpecialNames[i][0]) // Found one
						{
							// Add linker-defined reference
							for (int j=0;j<count;j++)
							{
								special.ref[special.count].type=LibRefDWord;
								special.ref[special.count].func=i;
								special.ref[special.count++].ofs=ReadDWord(fp);
							}
						}
						else // Library reference
						{
							if (strlen(sym)<5) // Too short to be a lib ref
							{
								printf("Error: Undefined symbol '%s'\n",sym);
								return 1;
							}
							// Check symbol name for validity
							if (sym[strlen(sym)-5]!='@')
							{
								printf("Error: Undefined symbol '%s'\n",sym);
								return 1;
							}
							// Add library reference to table
							int func=-1; // Initialize in case sscanf fails
							sscanf(&sym[strlen(sym)-4],"%x",&func);
							if (func==-1)
							{
								printf("Error: Undefined symbol '%s'\n",sym);
								return 1;
							}						
							sym[strlen(sym)-5]=0; // Strip number from name
							int libNum=AddLib(sym);
							for (i=0;i<count;i++)
							{
								lib[libNum].ref[lib[libNum].count].type=LibRefDWord;
								lib[libNum].ref[lib[libNum].count].func=func;
								lib[libNum].ref[lib[libNum].count++].ofs=ReadDWord(fp);
							}
						}
					}
				}
				else if ((type==TypeImport16)||(type==TypeImport16Alt))
				{
					// Read number of references
					int count=ReadDWord(fp);
					if (!strncmp(sym,"_ROM_CALL_",10))
					{
						printf("Error: Symbol '%s' cannot be used as 16-bit\n",sym);
						return 1;
					}
					else if (!strncmp(sym,"_RAM_CALL_",10))
					{
						// Add references to RAM reference table
						int func=-1; // Initialize in case sscanf fails
						sscanf(&sym[10],"%x",&func);
						for (i=0;i<count;i++)
						{
							RAM.ref[RAM.count].type=LibRefWord;
							RAM.ref[RAM.count].func=func;
							RAM.ref[RAM.count++].ofs=ReadDWord(fp);
						}
					}
					else if (!strncmp(sym,"_extraramaddr@",14))
					{
						// Add references to RAM reference table, setting
						// the extra flag
						int func=-1; // Initialize in case sscanf fails
						sscanf(&sym[14],"%x",&func);
						for (i=0;i<count;i++)
						{
							RAM.ref[RAM.count].type=LibRefWord|LibRefExtra;
							RAM.ref[RAM.count].func=func;
							RAM.ref[RAM.count++].ofs=ReadDWord(fp);
						}
					}
					else // Library or linker-defined reference
					{
						for (i=0;SpecialNames[i][0];i++)
						{
							if (!strcmp(sym,SpecialNames[i]))
								break;
						}
						if (SpecialNames[i][0]) // Found one
						{
							// Add linker-defined reference
							for (int j=0;j<count;j++)
							{
								special.ref[special.count].type=LibRefWord;
								special.ref[special.count].func=i;
								special.ref[special.count++].ofs=ReadDWord(fp);
							}
						}
						else // Library reference
						{
							if (strlen(sym)<5) // Too short to be a lib ref
							{
								printf("Error: Undefined symbol '%s'\n",sym);
								return 1;
							}
							// Check symbol name for validity
							if (sym[strlen(sym)-5]!='@')
							{
								printf("Error: Undefined symbol '%s'\n",sym);
								return 1;
							}
							printf("Error: Symbol '%s' cannot be used as 16-bit\n",sym);
							return 1;
						}
					}
				}
				else if (type==TypeImport8)
				{
					printf("Error: 8-bit imports are unsupported\n");
					return 1;
				}
				else
				{
					printf("Error: Unknown symbol type number $%2.2X\n",type);
					return 1;
				}
			}
		}
		else if (hunk==HunkEnd) // End of code or BSS section
		{
			// Do nothing
		}
		else if (!feof(fp))
		{
			int size=ReadDWord(fp); // Size is in DWORDs
			// Unused hunk, so skip it
			fseek(fp,size<<2,SEEK_CUR);
		}
	}
	return 0;
}

int Object::Write()
{
}

void Object::CopyInfo(Object *obj)
{
	output89=obj->output89; output92=obj->output92;
	output92Plus=obj->output92Plus;
	codeSize=obj->codeSize; bssSize=obj->bssSize;
	code=new char[codeSize]; memcpy(code,obj->code,codeSize);
	memcpy(&reloc[0],&obj->reloc[0],sizeof(RelocInfo));
	memcpy(&reloc[1],&obj->reloc[1],sizeof(RelocInfo));
	mainOfs=obj->mainOfs; commentOfs=obj->commentOfs;
	exitOfs=obj->exitOfs; extraRAMOfs=obj->extraRAMOfs;
	stubType=obj->stubType;
	exportCount=obj->exportCount;
	memcpy(exportOfs,obj->exportOfs,sizeof(int)*MAX_EXPORTS);
	memcpy(&ROM,&obj->ROM,sizeof(LibRefInfo));
	memcpy(&RAM,&obj->RAM,sizeof(LibRefInfo));
	memcpy(lib,obj->lib,sizeof(LibRefInfo)*MAX_LIBS);
	memcpy(&special,&obj->special,sizeof(LibRefInfo));
	libCount=obj->libCount;
}

int Object::AddLib(char *name)
{
	int found=-1;
	// Search library table for name
	for (int i=0;i<libCount;i++)
	{
		if (!strcmp(name,lib[i].name))
		{
			found=i;
			break;
		}
	}
	if (found==-1)
	{
		// Add a new library
		strcpy(lib[libCount].name,name);
		lib[libCount++].count=0;
		return libCount-1;
	}
	else
		return found;
}
