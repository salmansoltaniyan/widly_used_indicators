//+------------------------------------------------------------------+
//|                              percent_calculator_on_subwindow.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#include  <ChartObjects\ChartObjectsTxtControls.mqh>
CChartObjectText mytext;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
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
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
  {
   if(id== CHARTEVENT_OBJECT_CHANGE || id== CHARTEVENT_OBJECT_CLICK || id == CHARTEVENT_OBJECT_DRAG || id == CHARTEVENT_OBJECT_ENDEDIT)
     {
      // Print("sparam ",sparam);
      if(ObjectGetInteger(0,sparam,OBJPROP_TYPE)== OBJ_ARROWED_LINE)
        {
         int window= ObjectFind(0,sparam);
         //   Print("window = ", window);
         mytext.Create(0,sparam+(string)1,window,(datetime)ObjectGetInteger(0,sparam,OBJPROP_TIME,1),ObjectGetDouble(0,sparam,OBJPROP_PRICE,1));
         string percent =DoubleToString(100* (ObjectGetDouble(0,sparam,OBJPROP_PRICE,1)- ObjectGetDouble(0,sparam,OBJPROP_PRICE,0))/ ObjectGetDouble(0,sparam,OBJPROP_PRICE,0),2);
         mytext.SetString(OBJPROP_TEXT,percent);
         mytext.Selectable(true);
         mytext.Selected(true);
         ChartRedraw(0);

        }

     }




  }
//+------------------------------------------------------------------+
