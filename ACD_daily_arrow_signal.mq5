//+------------------------------------------------------------------+
//|                                               ACD_Box_drawer.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property description "in mofidtrader maximum 3 month of intra_day candle data(lower than D1) is available so the OR for before that date can not be calculated"
#property version   "1.00"
#property indicator_chart_window



enum ENUM_SESSION_AUTO
  {
   AUTO=0,
   MANUAL=1,

  };


input datetime start_date = D'2021.01.01 00:00';
input int OR_period = 30;
input color OR_color= clrMediumSeaGreen;
input bool OR_fill = true;
input double or_zone_ratio= 1;
input bool close_upper_than_or = false;

input ENUM_SESSION_AUTO session_auto_or_time= AUTO;
input int session_auto_minute_offset = 0;
input string session_time = "9:00-";
input string obj_name_general = "box";

#include <ChartObjects\ChartObjectsShapes.mqh>
#include <ChartObjects\ChartObjectsArrows.mqh>

CChartObjectRectangle my_rect[];
CChartObjectArrowUp my_buy[];

int namebox=0;
int arrow_num=0;
int shift =0;

//double up_arrow[];
//string obj_name_general = "box" + (string) __RANDOM__ ;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {


   namebox=0;
arrow_num=0;


   shift = iBarShift(_Symbol,PERIOD_D1,start_date,false)-2;


   string session_array[],session_start_array[];
   StringSplit(session_time,'-',session_array);
   StringSplit(session_array[0],':',session_start_array);
   datetime time_candle, time_start, time_end;

   for(int i=0; i<shift; i++)
     {

      int hour=0;
      int min=0;
      MqlDateTime  t_struct_start;
      if(session_auto_or_time== AUTO)
        {

         int sy = iBarShift(_Symbol,PERIOD_M1,iTime(_Symbol,PERIOD_D1,i))-1;
         time_start= iTime(_Symbol,PERIOD_M1,sy);
         TimeToStruct(time_start, t_struct_start);
         time_end = time_start + OR_period *60;
        }
      else
        {
         hour = (int)session_start_array[0];
         min = (int)session_start_array[1];
         time_candle = iTime(_Symbol,PERIOD_D1,i);
         TimeToStruct(time_candle, t_struct_start);
         t_struct_start.hour = hour;
         t_struct_start.min = min;
         time_start = StructToTime(t_struct_start);
         time_end = time_start + OR_period * 60;
        }

      // time_end = time_start + OR_period * 60;
      int l0 = iBarShift(_Symbol,PERIOD_M1,time_start);
      int l1 = iBarShift(_Symbol,PERIOD_M1,time_end);
      int l2= iLowest(_Symbol,PERIOD_M1,MODE_LOW,l0-l1+1,l1);
      double or_low = iLow(_Symbol,PERIOD_M1,l2);
      int h2= iHighest(_Symbol,PERIOD_M1,MODE_HIGH,l0-l1+1,l1);
      double or_high = iHigh(_Symbol,PERIOD_M1,h2);
      double or_len= or_high-or_low;
      double or_middle = (or_high+or_low)/2;
      or_high= or_middle + (or_len * or_zone_ratio)/2;
      or_low= or_middle - (or_len * or_zone_ratio)/2;


     

      if(iHigh(_Symbol,PERIOD_D1,i) > or_high && (!close_upper_than_or || iClose(_Symbol,PERIOD_D1,i) >= or_high))
        {
         ArrayResize(my_buy,arrow_num+1);
         my_buy[arrow_num].Create(0,obj_name_general+"b"+IntegerToString(arrow_num),0,time_start,iLow(_Symbol,PERIOD_D1,i));
         my_buy[arrow_num].Fill(true);
         my_buy[arrow_num].Width(3);
         arrow_num++;
        }
        
      ArrayResize(my_rect,namebox+1);
      my_rect[namebox].Create(0,obj_name_general+"_"+IntegerToString(namebox),0,time_start,or_low,time_end,or_high);
      my_rect[namebox].Color(OR_color);
      my_rect[namebox].Fill(OR_fill);
      my_rect[namebox].Background(true);

      namebox++;

     }
   ChartRedraw();
   Print("size my rect= ", ArraySize(my_rect));


   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

//if(reason == REASON_CLOSE)
   for(int i=0; i<ArraySize(my_rect); i++)
      my_rect[i].Delete();


   for(int i=0; i<ArraySize(my_buy); i++)
      my_buy[i].Delete();



   if(reason == REASON_CLOSE && ArraySize(my_rect)==0)
      ObjectsDeleteAll(0);

   ChartRedraw();

   EventKillTimer();

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





   return(rates_total);
  }
//+------------------------------------------------------------------+
