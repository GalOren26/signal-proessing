#line 1 "C:/Users/גל/Desktop/סדר dsp/הגשה פרויקט 2/pic/MyProject.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic32/include/built_in.h"
#line 14 "C:/Users/גל/Desktop/סדר dsp/הגשה פרויקט 2/pic/MyProject.c"
char TFT_DataPort at LATE;
sbit TFT_RST at LATD7_bit;
sbit TFT_BLED at LATD2_bit;
sbit TFT_RS at LATD9_bit;
sbit TFT_CS at LATD10_bit;
sbit TFT_RD at LATD5_bit;
sbit TFT_WR at LATD4_bit;
char TFT_DataPort_Direction at TRISE;
sbit TFT_RST_Direction at TRISD7_bit;
sbit TFT_BLED_Direction at TRISD2_bit;
sbit TFT_RS_Direction at TRISD9_bit;
sbit TFT_CS_Direction at TRISD10_bit;
sbit TFT_RD_Direction at TRISD5_bit;
sbit TFT_WR_Direction at TRISD4_bit;



float IIRFilterCoefficientsNUM [ 7 +1] = {0.0463 , 0.0968 , 0.1825 , 0.2305 , 0.2305 , 0.1825 , 0.0968 , 0.0463};
float IIRFilterCoefficientsDENUM [ 7  +1] = {1.0000 , -1.1618 , 1.6337 , -0.8148 , 0.5105 , -0.0888 , 0.0330 , 0.0005};
int filtered_signal[ 320 ]={0};
int Q15_coefficients_bufferNUM [ 7 +1];
int Q15_coefficients_bufferDENUM [ 7 +1];
int acquisitionBufferCounter = 0;
int Buffer1[ 320  ];
int Buffer2[ 320  ];
int acquisitionBufferNumber = 1;
int * acquisitionBuffer = Buffer1;
int processingBufferNumber = 2;
int * processingBuffer = Buffer2;
char processingBufferWasProcessed = 'S';


int firstPRD=0;
int max_arr[ 25 ]={0};
int min_arr[ 25 ]={0};
int index_max_arr[ 25 ]={0};
int index_min_arr[ 25 ]={0};

int BPM=0;
int risingTimes[  25 ]={0};

int flag=1;
int present_ind=1;

 char PRINT1[320]="";
 char PRINT2[320]="";
 char TEMP_PRINT[7]="";
 char GAL[100]="";

int ADCvalue;
unsigned i;
void debug(int*,int );
 void set_bpm();

void PrepareTFT()
{
 TFT_BLED = 1;
 TFT_Init_ILI9341_8bit(320, 240);
 TFT_Fill_Screen(CL_YELLOW);
}

void PrepareADCChannel0()
{
 AD1PCFG = 0xFFFE;

 JTAGEN_bit = 0;
 TRISB0_bit = 1;
 ADC1_Init();
 Delay_ms(100);
}


void PrepareQ15coefBuffer(float CoeffsArr[], int LenOfCoeffs, int Q15_coefficients_buffer [])
{
 int tmp, x;
 for(x =0; x<LenOfCoeffs; x++)
 {
 Q15_Ftoi(CoeffsArr[x], &tmp);
 Q15_coefficients_buffer[x] = tmp;
 }
}


void Drawlines()
{

TFT_Set_Font(TFT_defaultFont,CL_BLUE,FO_HORIZONTAL);
 TFT_Write_Text("IN SIG",15,10);
 TFT_Set_Font(TFT_defaultFont, CL_RED ,FO_HORIZONTAL);
 TFT_Write_Text("OUT SIG",19,60);
 TFT_Set_Font(TFT_defaultFont,CL_green,FO_HORIZONTAL);
 TFT_Write_Text("Amp",15,110);
TFT_Set_Font(TFT_defaultFont,CL_BLACK ,FO_HORIZONTAL);
 TFT_Write_Text("Period",15,160);
 TFT_Set_Font(TFT_defaultFont, CL_FUCHSIA, FO_HORIZONTAL);
 TFT_Write_Text("Rise",15,210);


 TFT_Set_Pen(CL_BLACK, 2);


 TFT_Line(0,50, 320,50);
 TFT_Line(0,100, 320,100);
 TFT_Line(0,150, 320,150);
 TFT_Line(0,200, 320,200);
}

 void drawsignal_in (int in_signal[])
 {
 int point,oldpoint;

 TFT_Set_Pen(CL_BLUE, 1);
 for(i=1;i< 320 ;i++)
 {
 point = in_signal[i]*240.0/1024.0+150;
 oldpoint = in_signal[i-1]*240.0/1024.0+150;
 TFT_Line(i-1,240-(int)oldpoint ,i,240-(int)point);
 }
}
 void draw_signal_out (int out_signal[])
 {
 int point,oldpoint;


 TFT_Set_Pen(CL_RED, 1);
 for(i= 10 ;i< 320 ;i++)
 {
 point = out_signal[i]*240.0/1024.0+75;
 oldpoint = out_signal[i-1]*240.0/1024.0+75;
 TFT_Line(i-1,240-(int)oldpoint ,i,240-(int)point);
 }
 }
 void print_period()
 { int point;
 TFT_Set_Pen(CL_BLACK, 2);
 i=0;
 while(index_max_arr [i] !=-3 &&index_max_arr [i+1]!=-3)
 {
 point= (index_max_arr[i+1]- index_max_arr[i])*240.0/1024.0+50;
 TFT_Line( index_max_arr[i+1], 240 - (int)point, index_max_arr[i], 240 - (int) point);
 i++;
 }
 TFT_Line( index_max_arr[i], 240 - (int)point, 320, 240 - (int) point);
 }
 void print_rising_time()
 { int flagg=1;
 int point=0;
 TFT_Set_Pen(CL_FUCHSIA, 2);
 i=0;
 while(risingTimes [i] !=-3)
 {
 point= (risingTimes [i])*240.0/1024.0+20;
 if( index_min_arr[i+1]!=-3)
 TFT_Line( index_min_arr[i], 240 - (int)point, index_min_arr[i+1], 240 - (int) point);
 else
 {
 TFT_Line( index_min_arr[i], 240 - (int)point, 320, 240 - (int) point);
 flagg=0;
 }
 i++;
 }
 if(flagg)
 {
 TFT_Line( index_min_arr[i], 240 - (int)point, 320, 240 - (int) point);
 }
 }


 void drawamp()
 { int point ,oldpoint;

 TFT_Set_Pen(CL_green, 3);

 while(present_ind< 25 &&(max_arr[present_ind]!=-3))
 {
 if(present_ind==0&&max_arr[present_ind]!=-3)
 {
 point = max_arr[0] * 240.0 / 1024.0+23;
 TFT_Line( 10 , 240 - (int) point, index_max_arr[0], 240 - (int)point);
 present_ind++;
 }
 if(present_ind!=0&&max_arr[present_ind]!=-3)
 {
 oldpoint = point;
 point = max_arr[present_ind] * 240.0 / 1024.0+23 ;
 TFT_Line( index_max_arr[present_ind-1], 240 - (int) oldpoint, index_max_arr[present_ind], 240 - (int) point);
 present_ind++;
 }
 if(present_ind==0&&max_arr[present_ind]==-3)
 {
 TFT_Set_Pen(CL_RED, 4);
 TFT_Write_Text("Death or malfunction occurred, emergency! ", 10 +20,110);
 }
 if(present_ind!=0&&max_arr[present_ind]==-3)
 TFT_Line(index_max_arr[present_ind-1], 240 - (int)point, 320, 240 - (int)point);

 }
 present_ind=0;

}
 void set_bpm()
 {
 char tempp [20]="";
 char xx []="bpm:" ;
 TFT_Set_Font(TFT_defaultFont,CL_RED,FO_HORIZONTAL);
 IntToStr(bpm,tempp);
 TFT_Write_Text(tempp,140,10);
 TFT_Write_Text(xx,115,10);


 }

void UpdateScreen(int in_signal[],int out_signal[])
{

 TFT_Fill_Screen(CL_WHITE);
 Drawlines();
 set_bpm();
 drawsignal_in(in_signal);
 draw_signal_out(out_signal) ;
 drawamp ();
 print_period();
 print_rising_time();





}
 void PIC_DSP_Library_Convolution(int CoeffsArrNUM[],int CoeffsArrDENUM[],int LenOfCoeffsDENUM, int signal_in[], int signal_out[], unsigned int Index)
{
 unsigned int j, k;


 for(j=0; j < Index; j++)
 {
 signal_out[j] = IIR_Radix(0, 0, CoeffsArrNUM, CoeffsArrDENUM,LenOfCoeffsDENUM, signal_in, Index, signal_out, j);
 }

}

void AddValueToAcquisitionBuffer()
{
 ADCvalue = ADC1_Get_Sample(0);
 acquisitionBuffer[acquisitionBufferCounter++] = ADCvalue;
 if ( acquisitionBufferCounter >=  320  )
 {
 acquisitionBufferCounter =0;
 if ( acquisitionBufferNumber == 1 )
 {
 acquisitionBuffer = Buffer2;
 acquisitionBufferNumber = 2;
 processingBufferNumber = 1;
 processingBuffer = Buffer1;
 }
 else
 {
 acquisitionBuffer = Buffer1;
 acquisitionBufferNumber = 1;
 processingBufferNumber = 2;
 processingBuffer = Buffer2;
 }

 processingBufferWasProcessed = 'N';
 }
}

void intiatlize_bufers()
{
 int ini=0;
 for(ini=0;ini< 25 ;ini++)
 {
 max_arr[ini]=-3;
 min_arr[ini]=-3;
 index_max_arr[ini]=-3;
 index_min_arr[ini]=-3;
 risingTimes[ini]=-3;
 }
}


void rising_time_bpm()
{
 int index=0, lastMid=0, temp_rising_time=0,midIndx=0,IBI=0,sum_BPM=0,index_IBI=0;

 if(index_max_arr[index]>index_min_arr[index]&&max_arr[index]!=-3 && min_arr[index]!=-3)
 {
 lastMid =index_min_arr[index] + (index_max_arr[index] -index_min_arr[index])/2;
 risingTimes[0]=index_max_arr[index] -index_min_arr[index];
 }
 else if (index_max_arr[index]<=index_min_arr[index]&&max_arr[index]!=-3 && min_arr[index]!=-3)
 {
 lastMid =index_min_arr[index] + (index_max_arr[index+1] -index_min_arr[index])/2;
 risingTimes[0]=index_max_arr[index+1] -index_min_arr[index];
 }
 index=1;

 while(max_arr[index]!=-3 && min_arr[index]!=-3 )
 {

 if(index_max_arr[index] <index_min_arr[index] && index_max_arr[index+1]!=-1){
 temp_rising_time= index_max_arr[index+1] -index_min_arr[index];
 midIndx =index_min_arr[index] + (temp_rising_time)/2;
 }
 if(index_max_arr[index] >=index_min_arr[index])
 {
 temp_rising_time= index_max_arr[index] -index_min_arr[index];
 midIndx =index_min_arr[index] + (temp_rising_time)/2;
 }
 IBI= midIndx -lastMid;

 if(IBI >=0)
 {
 sum_BPM+=IBI ;
 index_IBI++;
 }
 risingTimes[index] = temp_rising_time;
 lastMid = midIndx;
 index++;
 }
 if (sum_BPM==0) BPM=0;
 else {BPM= sum_BPM/index_IBI;
 BPM = (unsigned int)(60*1000/(BPM*25));
 }
}


void find_max_min_val_index()
{
int fmax,index_max=0,index_min=0,first_max=1,first_min=1;
int * Fis=filtered_signal;
intiatlize_bufers();

for (fmax= 10 ;fmax< 320 - 10 ;fmax++)
{
if(Fis[fmax-12]<Fis[fmax]&&Fis[fmax-11]<Fis[fmax]&&Fis[fmax-10]<Fis[fmax]&&Fis[fmax-9]<Fis[fmax]&&Fis[fmax-8]<Fis[fmax]&&Fis[fmax-7]<Fis[fmax]&&Fis[fmax-6]<Fis[fmax]&&Fis[fmax-5]<Fis[fmax]&&Fis[fmax-4]<Fis[fmax]&&Fis[fmax-3]<Fis[fmax]&&Fis[fmax-2]<=Fis[fmax] && Fis[fmax-1]<=Fis[fmax] && Fis[fmax+1]<=Fis[fmax]&& Fis[fmax+2]<=Fis[fmax])
 {
 if (first_max)
 {
 first_max=0;
 max_arr[index_max]=Fis[fmax];

 index_max_arr[index_max++]=fmax;
 }
 if(fmax>index_max_arr[index_max-1]+2)
 {
 max_arr[index_max]=Fis[fmax];

 index_max_arr[index_max++]=fmax;
 }
 }
if(Fis[fmax-2]>=Fis[fmax] && Fis[fmax-1]>=Fis[fmax] && Fis[fmax+1]>=Fis[fmax] && Fis[fmax+2]>=Fis[fmax]&&Fis[fmax+3]>Fis[fmax]&&Fis[fmax+4]>Fis[fmax]&&Fis[fmax+5]>Fis[fmax]&&Fis[fmax+6]>Fis[fmax]&&Fis[fmax+7]>Fis[fmax]&&Fis[fmax+7]>Fis[fmax]&&Fis[fmax+8]>Fis[fmax]&&Fis[fmax+9]>Fis[fmax]&&Fis[fmax+10]>Fis[fmax]&&Fis[fmax+11]>Fis[fmax]&&Fis[fmax+12]>Fis[fmax])
 {
 if(first_min)
 {
 min_arr[index_min]=Fis[fmax];

 index_min_arr[index_min++]=fmax;
 first_min=0;
 }
 if(fmax>index_min_arr[index_min-1]+2)
 {
 min_arr[index_min]=Fis[fmax];

 index_min_arr[index_min++]=fmax;
 }
 }
}


}

void debug(int* STR,int x)
{
if(x==1)
{
for ( i=0;i<7;i++)
 {
 IntToStr(STR [i],TEMP_PRINT);
 strcat(PRINT1,TEMP_PRINT);
 strcat(PRINT1," ");

 }
 TFT_Write_Text(PRINT1,10,90);
 for ( i=7;i<14;i++)
 {
 IntToStr(STR[i],TEMP_PRINT);
 strcat(PRINT2,TEMP_PRINT);
 strcat(PRINT2," ");
 }
 TFT_Write_Text(PRINT2,10,140);
 }
 if(x==0)
 {
 IntToStr(*STR,TEMP_PRINT);
 strcat(GAL,TEMP_PRINT);
 strcat(GAL,"");
 TFT_Write_Text(GAL,10,140);
 }
}



void ProcessAndPresentProcessingBuffer()
{
 if ((processingBufferWasProcessed == 'Y')||(processingBufferWasProcessed == 'S'))
 return;
 PIC_DSP_Library_Convolution(Q15_coefficients_bufferNUM,Q15_coefficients_bufferDENUM, 7 +1,processingBuffer,filtered_signal, 320 );


 find_max_min_val_index();
 rising_time_bpm();
 UpdateScreen(processingBuffer,filtered_signal);


 processingBufferWasProcessed = 'Y';
}

void InitTimer2_3(){
 T2CON = 0x8008;
 T3CON = 0x0;
 TMR2 = 0;
 TMR3 = 0;
 T3IP0_bit = 1;
 T3IP1_bit = 1;
 T3IP2_bit = 1;
 T3IF_bit = 0;
 T3IE_bit = 1;
 PR2 = 33920;
 PR3 = 30;
}

void Timer2_3Interrupt() iv IVT_TIMER_3 ilevel 7 ics ICS_SRS{
 T3IF_bit = 0;
 AddValueToAcquisitionBuffer();
}


void main()
{
 PrepareTFT();
 PrepareADCChannel0();
 TRISA = 0;
 InitTimer2_3();
 PrepareQ15coefBuffer(IIRFilterCoefficientsNUM,  7  ,Q15_coefficients_bufferNUM);
 PrepareQ15coefBuffer(IIRFilterCoefficientsDENUM,  7 ,Q15_coefficients_bufferDENUM);
 EnableInterrupts();
 while(1)
 {
 ProcessAndPresentProcessingBuffer();
 }
}
