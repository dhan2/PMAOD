#include<stdio.h>
#include <stdlib.h>
#include<math.h>
#include<string.h>




int main(int argc, char* argv[])
{
	FILE *inptr,*outptr;
	char *buff,*site_p,*site_p_origin;
	float *lat_p,*lon_p,*lat_p_origin,*lon_p_origin;
	
	char statecode[3],countycode[4],sitenum[5];
	
	char parametercode[6],poc[2];
	
	float lat,lon;
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
	
	if((lat_p=(float *)malloc(sizeof(float)*400))==NULL)
	{
		fprintf(stderr, "error: cannot allocate memory for lat_pointer data'\n");
		return -1;
	}
	
	if((lon_p=(float *)malloc(sizeof(float)*400))==NULL)
	{
		fprintf(stderr, "error: cannot allocate memory for lon_pointer data'\n");
		return -1;
	}
	
	lat_p_origin=lat_p;
	lon_p_origin=lon_p;
	
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
	
	
	fscanf ( inptr, "%2s,%3s,%4s,%5s,%1s,%f,%f,", statecode, countycode, sitenum,parametercode,poc,&lat,&lon);
	fgets(buff,250,inptr);
	strcat(sitecode,statecode);
	strcat(sitecode,countycode);
	strcat(sitecode,sitenum);
	printf("%s %f %f\n",sitecode,lat,lon);
	for(j=0;j<10;j++)
	{
		site_p[j]=sitecode[j];
        
	}
	
	*lat_p=lat;
	*lon_p=lon;
	lat_p++;
	lon_p++;
	sitecode[0]='\0';
	i++;
	// skip the first line
	while ( !feof(inptr) ) 
	{
		fscanf ( inptr, "%2s,%3s,%4s,%5s,%1s,%f,%f,", statecode, countycode, sitenum,parametercode,poc,&lat,&lon);
		fgets(buff,250,inptr);
		strcat(sitecode,statecode);
        strcat(sitecode,countycode);
        strcat(sitecode,sitenum);
		//	printf("%s %f %f\n",site_p,lat,lon);
		if(strcmp(sitecode,site_p)!=0)
        {
			site_p=site_p+10;
			for(j=0;j<10;j++)
			{
				site_p[j]=sitecode[j];
				
			}
			
			*lat_p=lat;
			*lon_p=lon;
			lat_p++;
			lon_p++;
			i++;
		}
		sitecode[0]='\0';
	}
	
	if((outptr=fopen("site_code_lat_lon.txt","w"))==NULL)
	{
		fprintf(stderr, "error: cannot open site_code_lat_lon file\n");
		return -1;
	}
	
	site_p=site_p_origin;
	lat_p=lat_p_origin;
	lon_p=lon_p_origin;
	for(k=0;k<i;k++)
	{
		fprintf(outptr,"%s",site_p);
		site_p=site_p+10;
        fprintf(outptr," %f",*lat_p);
        fprintf(outptr," %f",*lon_p);
		
		lat_p++;
		lon_p++;
		fprintf(outptr,"\n");
	}
	
	fclose(inptr);
	fclose(outptr);
	
	free(buff);
	free(site_p_origin);
	
	
	free(lat_p_origin);
	free(lon_p_origin);
	
	
	
	return 0;
}
