//#include "BO4CSCRFC2.h"
//#include "BO4CSCRFC3.h"
//
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
int RunGT4CSCRFC2(int argc, char * argv[]) ;

static void *rm_tmp_tmp (void *)
{
	for (;;) {
		system ("for i in `echo /tmp/0*.tmp`; do fuser $i || echo rm -f $i; done");
		sleep (30);
	}
}

int main(int argc, char * argv[])
{
	pthread_t t;
	
	pthread_create (&t, NULL, rm_tmp_tmp, NULL);

	RunGT4CSCRFC2(argc, argv);
	return 0;
}
