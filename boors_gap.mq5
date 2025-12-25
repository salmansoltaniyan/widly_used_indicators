//+------------------------------------------------------------------+
//|                                                    boors_gap.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum -10
#property indicator_maximum 10
#property indicator_buffers 1
#property indicator_plots   1
//--- plot Label1
#property indicator_label1  "Label1"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrDeepSkyBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
#property indicator_level1 3
#property indicator_level2 -3
//--- indicator buffers
double         Label1Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer,INDICATOR_DATA);
     ArraySetAsSeries(Label1Buffer,false);
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
   ArraySetAsSeries(high, false);
   ArraySetAsSeries(low, false);
   ArraySetAsSeries(open, false);
   ArraySetAsSeries(close, false);
   int start = prev_calculated;
   if(start == 0)
      start=2;
      
      
      for(int i=start; i<rates_total; i++)
     {
      double gap= 100*(open[i]- close[i-1])/close[i-1];
      Label1Buffer[i]= gap;


     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
