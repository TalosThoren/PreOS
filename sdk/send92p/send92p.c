#include <stdio.h>
#include <termbits.h>
#include <termios.h>
#include <unistd.h>

FILE *hCom=NULL;
int error=0;

void InitCom(int n)
{
    char name[64];
    struct termios ti;

    error=0;
    sprintf(name,"/dev/ttyS%d",n-1);
    hCom=fopen(name,"r+");
    if (!hCom)
    {
        printf("Error opening COM port\n");
        error=1;
        exit(1);
    }
    tcgetattr(fileno(hCom),&ti);
    ti.c_iflag=IGNBRK;
    ti.c_oflag=NL0|CR0|TAB0|BS0|VT0|FF0;
    ti.c_cflag=CS8|CREAD|CLOCAL;
    ti.c_lflag=0;
    cfsetospeed(&ti,B9600);
    cfsetispeed(&ti,B9600);
    tcsetattr(fileno(hCom),TCSANOW,&ti);
}

void CloseCom()
{
    if (hCom) fclose(hCom);
}

void SendCom(int ch)
{
    if (error) return;
    fputc(ch,hCom);
}

int GetCom(int *ch)
{
    if (error) return 0;
    *ch=fgetc(hCom);
    return 1;
}

int ComError()
{
    return error;
}

int WaitForAck()
{
    int i;
    GetCom(&i); GetCom(&i); GetCom(&i); GetCom(&i);
    return i;
}

int main(int argc, char *argv[])
{
    FILE *fp;
    int csum,type,size,id,i,j;
    char calcName[32],buf[16];

    if (argc<3)
    {
    	printf("Usage: SEND92P COMPort FileName\n");
        return 1;
    }
    InitCom(atoi(argv[1]));
    fp=fopen(argv[2],"r");
    if (!fp)
    {
	printf("Error opening input file\n");
	return 1;
    }
    fseek(fp,0x48,SEEK_SET);
    type=fgetc(fp);
    fseek(fp,0xa,SEEK_SET);
    fread(buf,8,1,fp);
    buf[8]=0; strcpy(calcName,buf);
    fseek(fp,0x40,SEEK_SET);
    fread(buf,8,1,fp);
    fseek(fp,0x4c,SEEK_SET);
    size=fgetc(fp);
    size|=fgetc(fp)<<8;
    size-=0x5a;
    buf[8]=0; strcat(calcName,"\\"); strcat(calcName,buf);
    id=0x89;
    SendCom(id); SendCom(6);
    SendCom(6+strlen(calcName));
    SendCom(0); SendCom((size+2)&0xff);
    SendCom(((size+2)>>8)&0xff);
    SendCom(0); SendCom(0);
    csum=(size+2)&0xff; csum+=((size+2)>>8)&0xff;
    SendCom(type);
    csum+=type;
    SendCom(strlen(calcName));
    csum+=strlen(calcName);
    for (i=0;i<strlen(calcName);i++)
    {
	SendCom(calcName[i]);
        csum+=calcName[i];
    }
    SendCom(csum&0xff); SendCom((csum>>8)&0xff);
    WaitForAck(); WaitForAck();
    SendCom(id); SendCom(0x56); SendCom(0); SendCom(0);
    SendCom(id); SendCom(0x15);
    SendCom((size+6)&0xff); SendCom(((size+6)>>8)&0xff);
    SendCom(0); SendCom(0); SendCom(0); SendCom(0);
    if (ComError())
    {
        fclose(fp);
        CloseCom();
        printf("Error in transmission\n");
        return 1;
    }
    fseek(fp,0x56,SEEK_SET);
    csum=0;
    for (j=0;j<(size+2);j++)
    {
        i=fgetc(fp);
        SendCom(i);
        csum+=i;
    }
    csum&=0xffff;
    SendCom(csum&0xff); SendCom((csum>>8)&0xff);
    WaitForAck();
    SendCom(id); SendCom(0x92); SendCom(0); SendCom(0);
    WaitForAck();
    fclose(fp);
    CloseCom();
    if (ComError())
    {
        printf("Error in transmission\n");
        return 1;
    }
    return 0;
}
