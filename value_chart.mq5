//+------------------------------------------------------------------+
//|                                                  volume_emas.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot value
#property indicator_label1  "value"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDeepSkyBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         valueBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,valueBuffer,INDICATOR_DATA);
   ArraySetAsSeries(valueBuffer, true);
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
ArraySetAsSeries(high, true);
ArraySetAsSeries(low, true);
ArraySetAsSeries(close, true);
ArraySetAsSeries(volume, true);

   int limit = rates_total- prev_calculated;
   
   if(limit== rates_total)
  limit= limit-3;
   
   for(int i=0;i<limit;i++)
     {
     
     valueBuffer[i] = (volume[i]+ volume[i+1]+volume[i+2])* (high[i]+ low[i]+ close[i])/9;
      
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
