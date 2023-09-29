
#include <DueTimer.h>
#include <stdlib.h>
#include "String.h"
#include <math.h>
#define SINGAL_LENGTH (200)
#define MAX_AMPLITUDE (4095)
#define MIN_AMPLITUDE (0)
#define NoiseMax (62)// 0.05*4096/3.3 [v])
#define Matlab_Coef (31)

int smooth=1; //piece wise or smooth
int printt=1;//(to print the signal in the serial ploter its need to be 1- and wait 7 sec (in order to present help menu at the serial monitor).
int analog = 0;
int first_time=1;

int Fs=200; // the  fs is get by the connection bpm*SINGAL_LENGTH/60 -defult 60 bpm 
float temp_Noise_choose=0;// for shoing changing parmaters and show them at help
float temp_dc_chose=0;// for changing parmaters and show them at help
float amplitude=MAX_AMPLITUDE;
float temp_rising_time=0;
float rising_time=0.2*SINGAL_LENGTH;
float coef [Matlab_Coef]={  0.0037002,0.0043607  , 0.0060481 ,  0.0088057 ,  0.0126097 ,  0.0173666,0.0229166  , 0.0290407  , 0.0354727  , 0.0419144 ,  0.0480533 ,  0.0535816,0.0582154 ,  0.0617126  , 0.0638884 ,  0.0646268 ,  0.0638884  , 0.0617126,0.0582154  , 0.0535816,   0.0480533  , 0.0419144 ,  0.0354727  , 0.0290407,0.0229166  , 0.0173666 ,  0.0126097  , 0.0088057 ,  0.0060481 ,  0.0043607,0.0037002};
// those cooefitent was designed for buufer at size 200 but they also fiited for shoreter or larger buffer/ for larger buffer the signal will be less fillterd (couse the relative nequist frecoinsy will be smaller and vise verse for shoreter array. wc=3hz
float Signal[SINGAL_LENGTH]={0};
float Filterd_signal [SINGAL_LENGTH+Matlab_Coef]={0};

char x;///for input value 
int temp;// for the function get_val(that gets value and pharse them to float);


void setup() 
{
  // put your setup code here, to run once:  
 create_ppg();
  srand(millis());
  Timer3.attachInterrupt(myInterruptHandler);  
  analogWriteResolution(12);  
   // set the analog output resolution to 12 bit (4096 levels) 
  Serial.begin(9600);
  delay (500);  
  Timer3.start(1000000/Fs);
}

void myInterruptHandler()
{
  if(smooth)
  {
  analogWrite(DAC1, Filterd_signal[analog++] );  
  if ( analog > SINGAL_LENGTH )
    analog=0;   
  }
  else
  {
    analogWrite(DAC1, Filterd_signal[analog++] );  
    if ( analog > SINGAL_LENGTH )
    analog=0;  
  }
}
float getval(void)
{
 int junk=0;
  while (Serial.available()>0)
  {
    junk=Serial.read();   
  }
  while (!Serial.available());
  float temp=Serial.parseFloat();
  return temp;
}

void create_ppg()
{
  for(int k=0;k< rising_time;k++)
  {
    Signal[k]=k*amplitude*0.5/(3.3*rising_time);
  }
  for(int k=rising_time;k<0.4*SINGAL_LENGTH;k++)
   Signal[k]=((k-SINGAL_LENGTH)*amplitude*0.5)/(3.3*( rising_time-SINGAL_LENGTH));
  for(int k=0.4*SINGAL_LENGTH;k<0.5*SINGAL_LENGTH;k++)
  Signal[k]=((k-SINGAL_LENGTH)*amplitude*0.5)/(3.3*( rising_time-SINGAL_LENGTH))+   ((k-0.4*SINGAL_LENGTH)*amplitude*0.5*0.2)/(3.3*(0.1*SINGAL_LENGTH));
  for(int k=0.5*SINGAL_LENGTH;k<0.85*SINGAL_LENGTH;k++)
  Signal[k]=((k-SINGAL_LENGTH)*amplitude*0.5)/(3.3*( rising_time-SINGAL_LENGTH))+   ((k-0.85*SINGAL_LENGTH)*amplitude*0.5*0.2)/(3.3*((-0.35)*SINGAL_LENGTH));
  for(int k=0.85*SINGAL_LENGTH;k<SINGAL_LENGTH;k++)
  Signal[k]=((k-SINGAL_LENGTH)*amplitude*0.5)/(3.3*( rising_time-SINGAL_LENGTH)); 
 create_smooth_ppg();
}
void FIRfunc (float CoeffsArr[], int LenOfCoeffs, float p_in[], float p_out[], int OutputIndex)
{
      int i, j, k;
      float tmp;
      for (k = 0; k < OutputIndex; k++)  //  position in output
      {
        tmp = 0;
        for (i = 0; i < LenOfCoeffs; i++)  //  position in coefficients array
        {
          j = k - i;  //  position in input
          if (j >= 0)  //  bounds check for input buffer
          {
            tmp += CoeffsArr [i] * p_in [j];
          }
        }
        p_out [k] = tmp;
      }
}
void create_smooth_ppg()
{
  FIRfunc(coef, Matlab_Coef,Signal,Filterd_signal,SINGAL_LENGTH+Matlab_Coef);  
}

void print_PPG()
{
  for (int k=0; k<SINGAL_LENGTH; k++)// you can chose which one to intrudce
  {
   if(smooth) 
    Serial.println(Filterd_signal[k]); 
    else 
    Serial.println(Signal[k]); 
  }
}

void adding_Noise()
{
  Serial.println("choose a range for noise value from 0-0.05 [v] ");
   temp_Noise_choose= getval();
   float Noise_choose=0; 
   if (temp_Noise_choose>=0&&temp_Noise_choose<=0.05)
  {
    Noise_choose=(int)((4096*temp_Noise_choose)/3.3);
    int rnd =0; 
    for (int k=0; k<SINGAL_LENGTH; k++)
    {
     rnd = random(-Noise_choose, Noise_choose);
     if(smooth)
     {
      do_addition(Filterd_signal,k,rnd);
     }
     else
     do_addition(Signal,k,rnd);
    }
   Serial.print("you added noise to your signal at the range 0 to ");
   Serial.println( temp_Noise_choose);
  }
   else 
  Serial.println("THE noise is not in the range please try again!");  
}
  
void adding_dc()
{
  Serial.println("choose a DC value from 0-1[v] ");
  temp_dc_chose= getval();
   float dc_chose=0;
  if (temp_dc_chose>=0&& temp_dc_chose<=1)
  {
    dc_chose=(4096*temp_dc_chose)/3.3;
    for (int k=0; k<SINGAL_LENGTH; k++)
    {
     if(smooth)
     do_addition(Filterd_signal,k,dc_chose);
     else
     do_addition(Signal,k,dc_chose);
    }
    Serial.print("The signal was updated you added ");
    Serial.print(temp_dc_chose);
    Serial.println("V"); 
  }
  else 
  Serial.println("Impropper value please try again!");  
}

void  do_addition (float* SIGNAL,int index,int add)
{
  SIGNAL[index]+=add;
  if (   SIGNAL[index] >=MAX_AMPLITUDE) SIGNAL[index] = MAX_AMPLITUDE;
  if ( SIGNAL[index  ] <= 0) SIGNAL[index] = 0;
}

void set_amplitude()
{
  Serial.println("choose max Amplitude from 0-0.5[v] ");
    float temp_amplitude= getval();
     if (temp_amplitude>=0&& temp_amplitude<=0.5)
     {
     amplitude=( MAX_AMPLITUDE *temp_amplitude)/0.5;
    create_ppg();
    Serial.print("The signal was updated the max amplitude is  ");
    Serial.print(temp_amplitude);
    Serial.println(" V");
     }
      else 
  Serial.println("Impropper value please try again!");
}
void set_period_time()
{
  Serial.print("choose period_time at msec from ");// we messure reffer to the minimum 
  Serial.print(1000*60/120);//typical valuse of period time detrmiend acoording to the range of bpm of man that coulbe be between 40-120(acoording to wingate web).//https://www.wingate.org.il/Index.asp?ArticleID=5900&CategoryID=105
 Serial.print(" to ");
 Serial.println((1000*60)/40);
  float temp_period_time = getval();
    if ((temp_period_time >=(1000*60)/120)&& (temp_period_time<= (1000*60) /40))
    {
      Fs=SINGAL_LENGTH*1000/temp_period_time;    // at sec 
    Timer3.stop();
   Timer3.start(1000000/ Fs);
    Serial.print("The signal was updated the new period_time is: ");
    Serial.print(temp_period_time);
    Serial.println(" msec");
    }
      else 
  Serial.println("Impropper value please try again!");
    
}
void set_rising_time()
{
    Serial.print("choose rising time in the range:");
     Serial.print((0.1*SINGAL_LENGTH*1000)/Fs);//time of isr(msec)*the raltive part of the signal_length
     Serial.print(" to ");
     Serial.print((0.3*SINGAL_LENGTH*1000)/Fs);
      Serial.print(" msec ");
     temp_rising_time= getval();
     if (( temp_rising_time>=(0.1*SINGAL_LENGTH*1000)/Fs) && ( temp_rising_time<=(0.3*SINGAL_LENGTH*1000)/Fs))
     {
      rising_time= (temp_rising_time*Fs)/1000;
     create_ppg();
    Serial.print("The signal was updated the rising time is  ");
    Serial.print(temp_rising_time);
    Serial.println(" msec");
     }
      else 
  Serial.println("Impropper value please try again!");
}
void return_defualt()
{
analog = 0;
smooth=1; 
Fs=200; 
rising_time=0.2*SINGAL_LENGTH;
amplitude=MAX_AMPLITUDE;
temp_dc_chose=0;
temp_Noise_choose=0;
create_smooth_ppg();
}
void Setvals(void)
{
//do you want to add Noise? [1=yes,0=no]: ");
   Serial.println("~~~~SET VALUES~~~~");
   Serial.println("chose the option you want to do- press to proper number ");
     Serial.println("press 1 for adding DC Drift ");
     Serial.println("press 2 for adding Noise");
     Serial.println("press 3 for change Amplitude");
     Serial.println("press 4 for change Time period");
     Serial.println("press 5 for change Rising time ");
       
     int butten=(int)getval(); 
      switch(butten)
      {
        
        case 1 :
        adding_dc();
        break; 
        case 2 :
        adding_Noise();
        break;
        case 3 :
       set_amplitude();
        break; 
        case 4 :
        set_period_time();
         break; 
        case 5 :
        set_rising_time();
        break;
        default:
        break;
  
      }
 x='0';
}
void PrintHelp()
{
  Serial.println("************************************ HELP **************************************");
   Serial.print("hello! you now see");
   if(smooth)
   Serial.println(" smooth ppg signal with the paramters: ");
    else 
   Serial.println(" Piece-wise ppg signal with the paramters: ");
   Serial.print("amplitude is :");
  Serial.print( amplitude/MAX_AMPLITUDE *0.5);
  Serial.println("[v]");
  Serial.print("Time_period is: " );//messsured relative to two adjacent PPG minimum.
  Serial.print((1000* SINGAL_LENGTH)/Fs);
  Serial.println(" (msec) ");
  Serial.print("Rising time is :");
  Serial.print((1000* rising_time)/Fs);
  Serial.println("(msec) ");
  Serial.print("DC driftt of :");
  Serial.print(temp_dc_chose);
  Serial.println("[v]");
  Serial.print("Noise at the range 0 to :");
  Serial.print( temp_Noise_choose);
  Serial.println("[v]");
  
  Serial.println("Press 's' to set values");
  Serial.println("Press 'p' to stop the signal and 'p' again  to cuntinue.");
  Serial.println("Press 'l' to smooth signal (after adding moise)");
  Serial.println("Press 'k ' to show Piece-wise signal  and 'k' again  to show smooth signal.");
  Serial.println("Press 'r' to return the defualt settings after the change you have done");
  Serial.println("Press '?' to show the help again instruction again");
  Serial.println("********************************************************************************");
  Serial.println();
     delay(7000);//wait 7 sec to intrudec the help manue.
  x='0';
}
void loop ()
{
  if(first_time==1)
  {
   PrintHelp();
   first_time=0; 
  }
  if(printt)
 print_PPG();
  if(Serial.available())
  {
     x = Serial.read();
     if (x=='?') PrintHelp();
     if (x=='s') Setvals();  
     if (x=='k') 
     {smooth=!smooth;}
     if(x=='p')
     printt=!printt; 
     if(x=='l')
     create_smooth_ppg();
     if(x=='r')
     return_defualt();
     Serial.println();
     Serial.println();
  }
}

