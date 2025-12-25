//+------------------------------------------------------------------+
//|                                             spread_indicator.mq5 |
//|                                                     tradelife.ir |
//|                                         https://www.tradelife.ir |
//+------------------------------------------------------------------+
#property copyright "@tradelifeir"
#property link      "https://www.tradelife.ir"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot spread
#property indicator_label1  "spread"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
input bool draw_in_percent= false;
//--- indicator buffers
double         spreadBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,spreadBuffer,INDICATOR_DATA);
   ArraySetAsSeries(spreadBuffer,true);
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
   ArraySetAsSeries(spread,true);
   ArraySetAsSeries(close,true);
   int limit = rates_total- prev_calculated;

   for(int i=0; i<limit; i++)
     {
      if(draw_in_percent)
         spreadBuffer[i]= 100* spread[i]/close[i];
      else
         spreadBuffer[i]= spread[i]*Point();

     }



//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
