/**

gcc run.c && a
gcc run.c && ./a.out
 */
#include <stdio.h>
#include <stdlib.h>

int main()
{
#ifdef WIN32
	system("start adl -runtime . -nodebug application.xml");
#endif
#ifdef linux
	system("/home/libiao/flex_sdk_4.5/adl -runtime /home/libiao/flex_sdk_4.5/runtime/lnx/ -nodebug application.xml");
#endif
	return 0;
}
//d:/flex_sdk_4.5/bin/adl -runtime .-profile desktop -nodebug ./META-INF/AIR/application.xml . 

