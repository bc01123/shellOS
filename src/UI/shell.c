#include "../INC/shell.h"
#include "../INC/csh.h"
void launch_shell()
{
	string ch = (string) malloc(200); // util.h
	int counter = 0;
	do
	{
			print(" Run Bar >> ");
		    ch = readStr(); //memory_copy(readStr(), ch,100);
		    if(strEql(ch,"console"))
		    {
		        csh();
		    }
			else if(strEql(ch,"shutdown"))
			{
				shutdown();
			}
		    else
		    {
				gui();
		    } 
	} while (!strEql(ch,"exit"));
}

