//+------------------------------------------------------------------+
//|                                              move_per_candle.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot Label1
#property indicator_label1  "Label1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         Label1Buffer[];
input bool absolute_move= false;
input int average_period = 5;
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
   ArraySetAsSeries(open, false);
//ArraySetAsSeries(close, false);

   for(int i=prev_calculated; i<rates_total; i++)
     {
      if(i> average_period)
        {
         double move =0;
         for(int j=average_period; j>0; j--)
           {
            if(absolute_move== true)
               move = move + MathAbs(open[i-j]- open[i-j-1]);
            else
               move = move + open[i-j]- open[i-j-1];

           }
         move= move/ average_period;
         Label1Buffer[i]= move;
        }
      else
         Label1Buffer[i]=EMPTY_VALUE;

     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
