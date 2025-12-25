//+------------------------------------------------------------------+
//|                                               ACD_Box_drawer.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
enum ENUM_SESSION_NAME
  {
   SYDNEY = 0,
   TOKYO = 1,
   LONDON = 2,
   NEWYORK = 3,
   AATI_KALA =4,

  };

enum ENUM_SESSION_AUTO
  {
   AUTO=0,
   MANUAL=1,

  };


input datetime start_date = D'2022.01.01 00:00';
input int OR_period = 60;
input color OR_color= clrMediumSeaGreen;
input bool OR_fill = false;
input ENUM_SESSION_NAME session_auto = LONDON;
input int session_auto_minute_offset = -60;
input string session_time = "9:00-";
input ENUM_SESSION_AUTO session_auto_or_time= MANUAL;
input double broker_gmt_offset = 2; //broker-gmt(hour)
input bool draw_background= true;
input bool targets_based_on_ATR = false;
input int atr_percent = 10; //daily_atr_percent_distance_between_4_targets
input int target_atr_percent =50;// target_atr_percent_for_final_target

#include <ChartObjects\ChartObjectsShapes.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>

CChartObjectRectangle my_rect[], my_rect2[], my_rect3[],  my_rect4[], my_rect5[], my_rect6[];
CChartObjectText my_text[];
int namebox=0;
double atr_array[];
int atr_buff, shift;
int repeat= 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string obj_name_general = "box";
//string obj_name_general = "box" + (string) __RANDOM__ ;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

 Print("array myrect size in oninit",ArraySize(my_rect));

//int hour_offset = (session_auto_minute_offset/MathAbs(session_auto_minute_offset))*MathFloor(MathAbs(session_auto_minute_offset) /60);
//int minute_offset = session_auto_minute_offset- hour_offset*60;
   repeat=0;
   namebox=0;
//ArrayFree(atr_array);
   atr_buff=0;
   shift=0;
   atr_buff= iATR(_Symbol,PERIOD_D1,10);
// Sleep(1000);
//ArrayInitialize(atr_array,0);
   ArraySetAsSeries(atr_array,true);
   shift = iBarShift(_Symbol,PERIOD_D1,start_date,false)-2;
//long a= 1;
//for(int i=0;i<1e20;i++)
//  {
//   a=a*2;
//  }
   Print("init performed");
   EventSetMillisecondTimer(100);

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

   Print("deinit performed");
   if(reason == REASON_CLOSE )
     {
      for(int i=0; i<ArraySize(my_rect); i++)
        {

         my_rect[i].Delete();
         my_rect2[i].Delete();
         my_rect3[i].Delete();
         my_rect4[i].Delete();
         my_rect5[i].Delete();
         my_rect6[i].Delete();
         my_text[i].Delete();
        }
      //      for(int i=0; i<ObjectsTotal(0); i++)
      //        {
      //         string objname= ObjectName(0,i);
      //         if(StringSubstr(objname,0,StringLen(obj_name_general))== obj_name_general)
      //            ObjectDelete(0,objname);
      //
      //
      //        }
     }
 if(reason == REASON_CLOSE && ArraySize(my_rect)==0)
  
     {
     ObjectsDeleteAll(0);
//      for(int i=0; i<ArraySize(my_rect); i++)
//        {
//
//         my_rect[i].Detach();
//         my_rect2[i].Detach();
//         my_rect3[i].Detach();
//         my_rect4[i].Detach();
//         my_rect5[i].Detach();
//         my_rect6[i].Detach();
//         my_text[i].Detach();
//        }
     }
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
//---
//CopyBuffer(atr_buff,0,0,shift+1,atr_array);







//--- return value of prev_calculated for next call
   return(1);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer(void)
  {
   if(CopyBuffer(atr_buff,0,0,shift+5,atr_array)< 0)
     {
      Print("CopyBuffer error =",GetLastError());
     }
//Print("repeat value =",repeat);
   repeat++;
   if(repeat==2)
     {
      Print("main part performed");
      if(PeriodSeconds() <= 60 * OR_period)
        {

         string session_array[],session_start_array[];
         StringSplit(session_time,'-',session_array);
         StringSplit(session_array[0],':',session_start_array);
         datetime time_candle, time_start, time_end;

         //Sleep(100000);
         //CopyBuffer(atr_buff,0,0,shift+1,atr_array);
         for(int i=0; i<shift; i++)
           {
            //ArrayFree(atr_array);



            //  Print("shift = ", i, "atr = ",atr_array[i]);
            int hour=0;
            int min=0;
            MqlDateTime  t_struct_start;
            if(session_auto_or_time== AUTO)
              {
               if(session_auto==AATI_KALA)
                 {
                  int sy = iBarShift(_Symbol,PERIOD_M1,iTime(_Symbol,PERIOD_D1,i))-1;
                  time_start= iTime(_Symbol,PERIOD_M1,sy);
                  TimeToStruct(time_start, t_struct_start);
                  time_end = time_start + OR_period *60;
                  // time_end = iTime(_Symbol,PERIOD_M1,sy- OR_period);
                 }
               else
                 {


                  datetime session_start_datetime[], session_end_datetime[];
                  session_start_end_datetime(iTime(_Symbol,PERIOD_D1,i),  session_start_datetime, session_end_datetime);
                  time_start= session_start_datetime[(int)session_auto]+ session_auto_minute_offset *60;
                  TimeToStruct(time_start, t_struct_start);
                  time_end = time_start + OR_period * 60;
                 }
              }
            // Print("HI");
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

            ArrayResize(my_rect,namebox+1);

            my_rect[namebox].Create(0,obj_name_general+"_"+IntegerToString(namebox),0,time_start,or_low,time_end,or_high);
            my_rect[namebox].Color(OR_color);
            my_rect[namebox].Fill(OR_fill);
            my_rect[namebox].Background(draw_background);
            double diff,diff_target,low_target, high_target;
            if(targets_based_on_ATR)
              {
               diff= atr_array[i]*atr_percent/100;


              }
            else
              {
               diff= or_len;
              }



            double low1= or_low- diff;
            double low2= or_low- 2*diff;
            double low3= or_low- 3*diff;
            double low4= or_low- 4*diff;


            double high1= or_high+ diff;
            double high2= or_high+ 2*diff;
            double high3= or_high+ 3*diff;
            double high4= or_high+ 4*diff;

            ArrayResize(my_rect6,namebox+1);
            if(targets_based_on_ATR)
              {
               diff_target= atr_array[i]* target_atr_percent/100;
               low_target= or_high -diff_target;
               high_target= or_low + diff_target;

               my_rect6[namebox].Create(0,obj_name_general+"="+IntegerToString(namebox),0,time_start,low_target,time_end,high_target);
               my_rect6[namebox].Color(clrOrangeRed);
               my_rect6[namebox].Fill(false);
               my_rect6[namebox].Style(STYLE_DASH);
               my_rect6[namebox].Background(draw_background);

              }

            ArrayResize(my_rect2,namebox+1);
            my_rect2[namebox].Create(0,obj_name_general+"__"+IntegerToString(namebox),0,time_start,low1,time_end,high1);
            my_rect2[namebox].Color(OR_color);
            my_rect2[namebox].Fill(false);
            my_rect2[namebox].Style(STYLE_DASH);
            my_rect2[namebox].Background(draw_background);

            ArrayResize(my_rect3,namebox+1);
            my_rect3[namebox].Create(0,obj_name_general+"___"+IntegerToString(namebox),0,time_start,low2,time_end,high2);
            my_rect3[namebox].Color(OR_color);
            my_rect3[namebox].Fill(false);
            my_rect3[namebox].Style(STYLE_DASHDOT);
            my_rect3[namebox].Background(draw_background);

            ArrayResize(my_rect4,namebox+1);
            my_rect4[namebox].Create(0,obj_name_general+"____"+IntegerToString(namebox),0,time_start,low3,time_end,high3);
            my_rect4[namebox].Color(OR_color);
            my_rect4[namebox].Fill(false);
            my_rect4[namebox].Style(STYLE_DOT);
            my_rect4[namebox].Background(draw_background);

            ArrayResize(my_rect5,namebox+1);
            my_rect5[namebox].Create(0,obj_name_general+"_____"+IntegerToString(namebox),0,time_start,low4,time_end,high4);
            my_rect5[namebox].Color(OR_color);
            my_rect5[namebox].Fill(false);
            my_rect5[namebox].Style(STYLE_DASHDOTDOT);
            my_rect5[namebox].Background(draw_background);

            ArrayResize(my_text,namebox+1);
            my_text[namebox].Create(0,obj_name_general+"#"+IntegerToString(namebox),0,time_end,or_high);
            my_text[namebox].SetString(OBJPROP_TEXT,DoubleToString(or_len/Point()/10,1)+"  "+EnumToString((ENUM_DAY_OF_WEEK)t_struct_start.day_of_week)+" or/atr="+DoubleToString(100*or_len/atr_array[i],1));
            my_text[namebox].Color(OR_color);
            my_text[namebox].Background(draw_background);
            namebox++;

           }
         ChartRedraw();
         Print("size my rect= ", ArraySize(my_rect));
        }// end if

      //EventKillTimer();

     }// end repeat

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void session_start_end_datetime(datetime current_day_datetime, datetime & session_start_datetime_[], datetime & session_end_datetime_[])
  {
// get current day datetime and return the datetime of first and end of sessions of current day.
   MqlDateTime current_day_struct, dst_start_struct[4], dst_end_struct[4];
   TimeToStruct(current_day_datetime,current_day_struct);
   current_day_struct.hour = 0;
   current_day_struct.min =0;
   current_day_struct.sec =0;
   current_day_datetime= StructToTime(current_day_struct);
//ENUM_CITY
//int local_start[] = {7,9,8,8}; //{sydney, tokyo, london, newyork}
   int local_start[] = {8,8,8,8};
// int local_end[] = {16,18,17,17};
   int local_end[] = {17,17,17,17};
   int gmt_offset[] = {11,9,0,-5};   // gmt+ gmt_offset = local time.
   int dst_offset[] = {-1,0,1,1};
//-- sydney
   dst_start_struct[0] = current_day_struct;
   dst_start_struct[0].mon= 4;
   dst_start_struct[0].day= 2;
   dst_end_struct[0]=  current_day_struct;
   dst_end_struct[0].mon= 10;
   dst_end_struct[0].day= 2;
//--- Tokyo
   dst_start_struct[1] = current_day_struct;
   dst_start_struct[1].mon= 1;
   dst_start_struct[1].day= 1;
   dst_end_struct[1]=  current_day_struct;
   dst_end_struct[1].mon= 12;
   dst_end_struct[1].day= 30;
//--- london
   dst_start_struct[2] = current_day_struct;
   dst_start_struct[2].mon= 3;
   dst_start_struct[2].day= 20;
   dst_end_struct[2]=  current_day_struct;
   dst_end_struct[2].mon= 10;
   dst_end_struct[2].day= 30;
//---NewYork
   dst_start_struct[3] = current_day_struct;
   dst_start_struct[3].mon= 3;
   dst_start_struct[3].day= 20;
   dst_end_struct[3]=  current_day_struct;
   dst_end_struct[3].mon= 11;
   dst_end_struct[3].day= 6;
//---

   for(int i=0; i<4; i++)
     {
      if(StructToTime(dst_start_struct[i]) <current_day_datetime && current_day_datetime <StructToTime(dst_end_struct[i]))
         gmt_offset[i] +=  dst_offset[i];

     }
   ArrayResize(session_start_datetime_,4);
   ArrayResize(session_end_datetime_,4);

   for(int i=0; i<4; i++)
     {


      session_start_datetime_[i]= current_day_datetime + (local_start[i] - gmt_offset[i]) * 3600 + broker_gmt_offset*3600;
      session_end_datetime_[i]= current_day_datetime + (local_end[i] - gmt_offset[i]) * 3600 + broker_gmt_offset*3600;


     }


  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
