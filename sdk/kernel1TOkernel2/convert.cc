#include <stdio.h>
#include "object.h"
#include "prog.h"

int main(int argc,char *argv[])
{
	if (argc<2)
	{
		printf("Usage: cK1toK2 FileName.9xz\n");
		return 1;
	}
	if (strlen(argv[1])>4) // Could possibly be a program to convert
	{
		int convert=0; // Default to no conversion
		PlusShellProgram *prog=NULL;
		if ((!strcmp(&argv[1][strlen(argv[1])-4],".9xz"))||
			(!strcmp(&argv[1][strlen(argv[1])-4],".89z")))
		{
			// Convert a PlusShell program
			argv[1][strlen(argv[1])-4]=0; // Strip extension
			prog=new PlusShellProgram(argv[1],(argv[1][strlen(argv[1])+1]=='8')?89:92);
			if (prog->Read()) return 1;
			// Create the output file(s)
			if (prog->output89) // Output TI-89 file?
			{
				// Create a new program file object
				PlusShellProgram *conv=new PlusShellProgram(argv[1],89);
				// Copy the information from the old file
				conv->CopyInfo(prog);
				// Write the converted program
				if (conv->Write()) return 1;
				delete conv;
			}
			if (prog->output92Plus) // Output TI-92+ file?
			{
				// Create a new program file object
				PlusShellProgram *conv=new PlusShellProgram(argv[1],92);
				// Copy the information from the old file
				conv->CopyInfo(prog);
				// Write the converted program
				if (conv->Write()) return 1;
				delete conv;
			}
			delete prog; // Free the old program
			printf("Conversion successful\n");
			return 0; // Return so that we don't try to link an object
		}
	}
}
