//+------------------------------------------------------------------+
//|                                                   my_session.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 10
#property indicator_buffers 5
#property indicator_plots   5
//--- plot Sydney
#property indicator_label1  "Sydney"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrSteelBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot Japan
#property indicator_label2  "Japan"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLimeGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- plot London
#property indicator_label3  "London"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
//--- plot Newyork
#property indicator_label4  "Newyork"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2

//--- plot weekday
#property indicator_label5  "weekday"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrLightGray
#property indicator_style5  STYLE_SOLID
#property indicator_width5  2
//--- indicator buffers
double         SydneyBuffer[];
double         JapanBuffer[];
double         LondonBuffer[];
double         NewyorkBuffer[];
double         DaynameBuffer[];

input double  broker_gmt_offset = 2; //broker-gmt(hour)
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SydneyBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,JapanBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,LondonBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,NewyorkBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,DaynameBuffer,INDICATOR_DATA);



  // broker_gmt_offset =   TimeGMT() - TimeCurrent();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---



   for(int jj=prev_calculated ; jj<rates_total ; jj++)
     {
      if(PeriodSeconds() < 60*60*3)
        {
         datetime time_gmt  = time[jj]- broker_gmt_offset*3600;

         datetime session_time[4];
         bool active_session[4];
         session_finder(time_gmt,session_time,active_session);
         SydneyBuffer[jj]= EMPTY_VALUE;
         JapanBuffer[jj]= EMPTY_VALUE;
         LondonBuffer[jj]=EMPTY_VALUE;
         NewyorkBuffer[jj]=EMPTY_VALUE;
         DaynameBuffer[jj]= 0.5;
         if(active_session[0])
            SydneyBuffer[jj]=2;

         if(active_session[1])
            JapanBuffer[jj]=4;

         if(active_session[2])
            LondonBuffer[jj]=6;

         if(active_session[3])
            NewyorkBuffer[jj]=8;

         MqlDateTime time_struct;
         TimeToStruct(session_time[3],time_struct);
         if(time_struct.hour>=17 && time_struct.hour <18)
            DaynameBuffer[jj]= EMPTY_VALUE;

        }
      else
        {
         SydneyBuffer[jj]= EMPTY_VALUE;
         JapanBuffer[jj]= EMPTY_VALUE;
         LondonBuffer[jj]=EMPTY_VALUE;
         NewyorkBuffer[jj]=EMPTY_VALUE;
         DaynameBuffer[jj]= EMPTY_VALUE;
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total-1);
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void session_finder(datetime current_gmt, datetime &session_localtime[], bool &session_active[])
  {
// get current gmt and determin in which session we are and what is session local times
   MqlDateTime gmt_struct, dst_start_struct[4], dst_end_struct[4], session_localtime_struct[4];

   TimeToStruct(current_gmt,gmt_struct);


//ENUM_CITY
   //int local_start[] = {7,9,8,8}; //{sydney, tokyo, london, newyork}
   int local_start[] = {8,8,8,8};
 //  int local_end[] = {16,18,17,17};
   int local_end[] = {17,17,17,17};
   int gmt_offset[] = {11,9,0,-5};   // gmt+ gmt_offset = local time.
   int dst_offset[] = {-1,0,1,1};
//-- sydney
   dst_start_struct[0] = gmt_struct;
   dst_start_struct[0].mon= 4;
   dst_start_struct[0].day= 2;
   dst_end_struct[0]=  gmt_struct;
   dst_end_struct[0].mon= 10;
   dst_end_struct[0].day= 2;
//--- Tokyo
   dst_start_struct[1] = gmt_struct;
   dst_start_struct[1].mon= 1;
   dst_start_struct[1].day= 1;
   dst_end_struct[1]=  gmt_struct;
   dst_end_struct[1].mon= 12;
   dst_end_struct[1].day= 30;
//--- london
   dst_start_struct[2] = gmt_struct;
   dst_start_struct[2].mon= 3;
   //dst_start_struct[2].day= 27;
   dst_start_struct[2].day= 20;
   dst_end_struct[2]=  gmt_struct;
   dst_end_struct[2].mon= 10;
   dst_end_struct[2].day= 30;
//---NewYork
   dst_start_struct[3] = gmt_struct;
   dst_start_struct[3].mon= 3;
   //dst_start_struct[3].day= 13;
   dst_start_struct[3].day= 20;
   dst_end_struct[3]=  gmt_struct;
   dst_end_struct[3].mon= 11;
   dst_end_struct[3].day= 6;
//---

   for(int i=0; i<4; i++)
     {
      if(StructToTime(dst_start_struct[i]) <current_gmt && current_gmt <StructToTime(dst_end_struct[i]))
         gmt_offset[i] +=  dst_offset[i];

     }


   for(int i=0; i<4; i++)
     {
      session_localtime[i]=  current_gmt +  gmt_offset[i] * 60 *60;
      TimeToStruct(session_localtime[i], session_localtime_struct[i]);
      if(local_start[i] <= (session_localtime_struct[i].hour+session_localtime_struct[i].min/60) && (session_localtime_struct[i].hour+session_localtime_struct[i].min/60) < local_end[i])
         session_active[i]= true;
      else
         session_active[i]=false;
     }


  }
//+------------------------------------------------------------------+
