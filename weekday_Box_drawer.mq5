//+------------------------------------------------------------------+
//|                                               ACD_Box_drawer.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window


input datetime start_date = D'2021.06.01 01:01:01';

input color OR_color= clrBlueViolet;
input bool OR_fill = false;
input string session_time = "0:00-23:59";
input ENUM_DAY_OF_WEEK weekday  = MONDAY;



#include <ChartObjects\ChartObjectsShapes.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
CChartObjectRectangle my_rect[], my_rect2[], my_rect3[];
CChartObjectText my_text[];
int namebox=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string obj_name_general = "daybox";
//string obj_name_general = "box" + (string) __RANDOM__ ;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
 
  //int hour_offset = (session_auto_minute_offset/MathAbs(session_auto_minute_offset))*MathFloor(MathAbs(session_auto_minute_offset) /60);
  //int minute_offset = session_auto_minute_offset- hour_offset*60;
  
   if(PeriodSeconds() < 3600 * 24 * 7)
     {


      string session_array[],session_start_array[],session_end_array[];
      StringSplit(session_time,'-',session_array);
      StringSplit(session_array[0],':',session_start_array);
       StringSplit(session_array[1],':',session_end_array);
      datetime time_candle, time_start, time_end;
      int shift = iBarShift(_Symbol,PERIOD_D1,start_date,false);
      Print("shift= ",shift);
      for(int i=0; i<shift; i++)
        {
  Print(namebox);
        
         time_candle = iTime(_Symbol,PERIOD_D1,i);
         MqlDateTime  t_struct_start, t_struct_end;
         TimeToStruct(time_candle, t_struct_start);
          TimeToStruct(time_candle, t_struct_end);
         if(t_struct_start.day_of_week !=weekday )           
            continue;
         
        

         t_struct_start.hour =(int) StringToInteger(session_start_array[0]);
         t_struct_start.min = (int)StringToInteger(session_start_array[1]);

         t_struct_end.hour = (int) StringToInteger(session_end_array[0]);
         t_struct_end.min = (int) StringToInteger(session_end_array[1]);
         
         time_start = StructToTime(t_struct_start);
         time_end = StructToTime(t_struct_end);
         int l0 = iBarShift(_Symbol,PERIOD_M15,time_start);
         int l1 = iBarShift(_Symbol,PERIOD_M15,time_end);
         int l2= iLowest(_Symbol,PERIOD_M15,MODE_LOW,l0-l1,l1);
         double or_low = iLow(_Symbol,PERIOD_M15,l2);
         int h2= iHighest(_Symbol,PERIOD_M15,MODE_HIGH,l0-l1,l1);
         double or_high = iHigh(_Symbol,PERIOD_M15,h2);
         double or_len= or_high-or_low;

         ArrayResize(my_rect,namebox+1);
         my_rect[namebox].Create(0,obj_name_general+"_"+IntegerToString(namebox),0,time_start,or_low,time_end,or_high);
         my_rect[namebox].Color(OR_color);
         my_rect[namebox].Fill(OR_fill);
         my_rect[namebox].Background(false);

         ArrayResize(my_rect2,namebox+1);
         my_rect2[namebox].Create(0,obj_name_general+"__"+IntegerToString(namebox),0,time_start,or_low-or_len,time_end,or_high+or_len);
         my_rect2[namebox].Color(OR_color);
         my_rect2[namebox].Fill(false);
         my_rect2[namebox].Style(STYLE_DASH);
         my_rect2[namebox].Background(false);

         ArrayResize(my_rect3,namebox+1);
         my_rect3[namebox].Create(0,obj_name_general+"___"+IntegerToString(namebox),0,time_start,or_low-2*or_len,time_end,or_high+2*or_len);
         my_rect3[namebox].Color(OR_color);
         my_rect3[namebox].Fill(false);
         my_rect3[namebox].Style(STYLE_DASHDOT);
         my_rect3[namebox].Background(false);
         
          ArrayResize(my_text,namebox+1);
         my_text[namebox].Create(0,obj_name_general+"#"+IntegerToString(namebox),0,time_end,or_high);
         my_text[namebox].SetString(OBJPROP_TEXT,DoubleToString(MathRound(or_len/Point())/10));
          my_text[namebox].Color(OR_color);
         namebox++;

        }
     }// end if
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//for(int i=0; i<ObjectsTotal(0,0,OBJ_RECTANGLE); i++)
//  {
//   string name = ObjectName(0,i,0,OBJ_RECTANGLE)
//                 string name_array[];
//   StringSplit(name,"_",name_array);
//   if(name_array[0]== obj_name_general)
//      ObjectDelete(0,name);
//  }
   for(int i=0; i<ArraySize(my_rect); i++)
     {
      my_rect[i].Delete();
      my_rect2[i].Delete();
      my_rect3[i].Delete();

     }


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

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+




