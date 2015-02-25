#include<stdio.h>
#include <stdlib.h>
#include<math.h>
#include<string.h>
#include<ctype.h>



int main(int argc, char* argv[])
{
	FILE *inptr,*outptr;
	char *buff,*site_p,*site_p_origin;
	
	char statecode[3],countycode[4],sitenum[5];
	char sitecode[10];
    sitecode[0]='\0';
	
	
	long i=0,j,k,count;
	
	
	
	if((buff=(char *)malloc(sizeof(char)*250))==NULL)
	{
		fprintf(stderr, "error: cannot allocate memory for buffer data'\n");
		return -1;
	}
	
	
	if((site_p=(char *)malloc(sizeof(char)*10*400))==NULL)
	{
		fprintf(stderr, "error: cannot allocate memory for site_pointer data'\n");
		return -1;
	}
	
	site_p_origin=site_p;
	
	char Onefile[300];
	
	if ( argc < 2 ) 
	{
		printf ( "Usuage: read_csv inptfilename \n");
		exit(-1);
	}	
	
	strcpy(Onefile, argv[1]);
	if ( (inptr = fopen ( Onefile, "r") ) == NULL )
	{
		printf( "can not open %s \n", Onefile);
		exit(-1);
	}	
	
	fgets(buff,250,inptr); // skip the first line
	
	
	fscanf ( inptr, "%2s,%3s,%4s,", statecode, countycode, sitenum);
	fgets(buff,250,inptr);
	strcat(sitecode,statecode);
	strcat(sitecode,countycode);
	strcat(sitecode,sitenum);
	//	printf("%s\n",sitecode);
	for(j=0;j<10;j++)
	{
		site_p[j]=sitecode[j];
        
	}
	sitecode[0]='\0';
	i++;
	// skip the first line
	while ( !feof(inptr) ) 
	{
		fscanf(inptr, "%2s,%3s,%4s,", statecode, countycode, sitenum);
		fgets(buff,250,inptr);
		strcat(sitecode,statecode);
        strcat(sitecode,countycode);
        strcat(sitecode,sitenum);
		//printf("%s\n",sitecode);
	//	printf("%s\n",site_p);
		if(strcmp(sitecode,site_p)!=0)
        {
			site_p=site_p+10;
			for(j=0;j<10;j++)
			{
				site_p[j]=sitecode[j];
				
			}
			
			i++;}
		sitecode[0]='\0';
	}
	
	if((outptr=fopen("site_code.txt","w"))==NULL)
	{
		fprintf(stderr, "error: cannot open site_code file'\n");
		return -1;
	}
	
	site_p=site_p_origin;
	for(k=0;k<i;k++)
	{
		fprintf(outptr,"%s",site_p);
		site_p=site_p+10;
    	fprintf(outptr,"\n");
	}
	
	fclose(inptr);
	fclose(outptr);
	
	free(buff);
	free(site_p_origin);
	
	
	
	return 0;
}
