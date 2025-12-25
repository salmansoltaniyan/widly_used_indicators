//+------------------------------------------------------------------+
//|                                       Up_Down_Trend_breakout.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//---
//  name a trend line or horizental line by "u" or "d", if price cross up "u" line or cr
// cross down "d" line there will be an alert.

// name support and resistand by "s" and "r" , if price become close to support or resistance (1 Atr higher or lower) you will
// here an alarm.

//---

#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property description "name a trend line or horizental line by <u> or <d>, if price cross up <u> line or cross down <d> line there will be an alert, name support and resistand by <s> and <r> , if price become close to support or resistance (1 Atr higher or lower) you will have an alarm. "
#property version   "1.00"
#property indicator_chart_window
input double n_atr = 1;
//datetime t =0;
//datetime td= 0;
double atr_array[];
int handle;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   handle = iATR(Symbol(),PERIOD_D1,10);
//--- indicator buffers mapping
   ChartSetInteger(0,CHART_SHOW_TICKER,true);
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
   static bool alarmsentup, alarmsentdown,alarmsent_support,alarmsent_resistance;
   static datetime td, t;

   if(iTime(NULL,PERIOD_D1,0) != td)
     {

     

      CopyBuffer(handle,0,0,10,atr_array);
      ArraySetAsSeries(atr_array,true);


      alarmsentdown = false;
      alarmsentup= false;
      td= iTime(NULL,PERIOD_D1,0);

     }

   if(iTime(NULL,PERIOD_M1,0) != t)
     {
      ArraySetAsSeries(close,true);
      ArraySetAsSeries(time,true);
      //---
      if(ObjectFind(0,"u")>=0 || ObjectFind(0,"U")>=0)
        {

         if(((ObjectGetInteger(0,"u",OBJPROP_TYPE)== OBJ_TREND && close[0] > ObjectGetValueByTime(0,"u",time[0])) ||
             (ObjectGetInteger(0,"u",OBJPROP_TYPE)== OBJ_HLINE && close[0] > ObjectGetDouble(0,"u",OBJPROP_PRICE))) &&
            alarmsentup == false)
            Alert("price crossed up trendline in ",_Symbol);
         alarmsentup = true;
        }

      if(ObjectFind(0,"d")>=0 || ObjectFind(0,"D")>=0)
        {

         if(((ObjectGetInteger(0,"d",OBJPROP_TYPE)== OBJ_TREND && close[0] < ObjectGetValueByTime(0,"d",time[0])) ||
             (ObjectGetInteger(0,"d",OBJPROP_TYPE)== OBJ_HLINE && close[0] < ObjectGetDouble(0,"d",OBJPROP_PRICE))) &&
            alarmsentdown==false)
            Alert("price crossed down trendline in ",_Symbol);
         alarmsentdown = true;

        }

      if(ObjectFind(0,"r")>=0 || ObjectFind(0,"R")>=0)
        {

         if(((ObjectGetInteger(0,"r",OBJPROP_TYPE)== OBJ_TREND && MathAbs(close[0] - ObjectGetValueByTime(0,"r",time[0]))< (atr_array[1] * n_atr)) ||
             (ObjectGetInteger(0,"r",OBJPROP_TYPE)== OBJ_HLINE && MathAbs(close[0] - ObjectGetDouble(0,"r",OBJPROP_PRICE)) < (atr_array[1] * n_atr))) &&
            alarmsent_resistance == false)
            Alert("price near resistance trendline in ",_Symbol);
         alarmsent_resistance = true;
        }

      if(ObjectFind(0,"s")>=0 || ObjectFind(0,"S")>=0)
        {

         if(((ObjectGetInteger(0,"s",OBJPROP_TYPE)== OBJ_TREND && MathAbs(close[0] - ObjectGetValueByTime(0,"s",time[0]))< (atr_array[1] * n_atr)) ||
             (ObjectGetInteger(0,"s",OBJPROP_TYPE)== OBJ_HLINE && MathAbs(close[0] - ObjectGetDouble(0,"s",OBJPROP_PRICE)) < (atr_array[1] * n_atr))) &&
            alarmsent_support == false)
            Alert("price near supoport trendline in ",_Symbol);
         alarmsent_support = true;
        }

    //  Print(Symbol()," atr = ", atr_array[1],"--", handle);
      t= iTime(NULL,PERIOD_M1,0);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {

   if(id==CHARTEVENT_OBJECT_CREATE || id==CHARTEVENT_OBJECT_CHANGE || id==CHARTEVENT_OBJECT_DRAG)
     {
      if(sparam== "u" ||sparam == "U")
        {
         ObjectSetString(0,"U",OBJPROP_NAME,"u");
         ObjectSetInteger(0,"u",OBJPROP_WIDTH,3);
         ObjectSetInteger(0,"u",OBJPROP_COLOR,clrGreen);
         //ObjectCreate(0,"buytext",OBJ_TEXT,0,(datetime) ObjectGetInteger(0,"u",OBJPROP_TIME,0), ObjectGetValueByTime(0,"u",ObjectGetInteger(0,"u",OBJPROP_TIME,0)));
         //ObjectSetString(0,"buytext",OBJPROP_TEXT,"buy line");

        }
      if(sparam== "d" || sparam=="D")
        {
         ObjectSetString(0,"D",OBJPROP_NAME,"d");
         ObjectSetInteger(0,"d",OBJPROP_WIDTH,3);
         ObjectSetInteger(0,"d",OBJPROP_COLOR,clrRed);
         //ObjectCreate(0,"selltext",OBJ_TEXT,0,(datetime) ObjectGetInteger(0,"d",OBJPROP_TIME,0), ObjectGetValueByTime(0,"d",ObjectGetInteger(0,"d",OBJPROP_TIME,0)));
         //ObjectSetString(0,"selltext",OBJPROP_TEXT,"sell line");

        }
      // Print("sparam = ",sparam);
      if(sparam== "r" ||sparam == "R")
        {
         ObjectSetString(0,"R",OBJPROP_NAME,"r");
         ObjectSetInteger(0,"r",OBJPROP_WIDTH,3);
         ObjectSetInteger(0,"r",OBJPROP_COLOR,clrGreenYellow);
         //ObjectCreate(0,"buytext",OBJ_TEXT,0,(datetime) ObjectGetInteger(0,"u",OBJPROP_TIME,0), ObjectGetValueByTime(0,"u",ObjectGetInteger(0,"u",OBJPROP_TIME,0)));
         //ObjectSetString(0,"buytext",OBJPROP_TEXT,"buy line");

        }

      if(sparam== "s" || sparam=="S")
        {
         ObjectSetString(0,"S",OBJPROP_NAME,"s");
         ObjectSetInteger(0,"s",OBJPROP_WIDTH,3);
         ObjectSetInteger(0,"s",OBJPROP_COLOR,clrOrange);
         //ObjectCreate(0,"selltext",OBJ_TEXT,0,(datetime) ObjectGetInteger(0,"d",OBJPROP_TIME,0), ObjectGetValueByTime(0,"d",ObjectGetInteger(0,"d",OBJPROP_TIME,0)));
         //ObjectSetString(0,"selltext",OBJPROP_TEXT,"sell line");

        }

     }
  }
//
//+------------------------------------------------------------------+
