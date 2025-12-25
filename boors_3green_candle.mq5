//+------------------------------------------------------------------+
//|                                           boors_green_candle.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot up
#property indicator_label1  "up"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrGreenYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot down
#property indicator_label2  "down"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- indicator buffers
double         upBuffer[];
double   downBuffer[];

//--- input parameters
input int min_change= 3; //min_change_percent

double last_buy_signal=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,upBuffer,INDICATOR_DATA);
   ArraySetAsSeries(upBuffer,false);
   SetIndexBuffer(1,downBuffer,INDICATOR_DATA);
   ArraySetAsSeries(downBuffer,false);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,241);
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,10);
   PlotIndexSetInteger(1,PLOT_ARROW,242);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-10);


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
      start=5;

   for(int i=start; i<rates_total; i++)
     {
      double lowest= MathMin(MathMin(open[i], close[i-1]), low[i]);
      //if(100*(close[i]-lowest)/lowest> min_change && 100* (high[i] - close[i])/close[i] < 0.5)
      if( close[i] > high[i-2] && close[i] > high[i-1] )
        {
         upBuffer[i]= low[i];
         //last_buy_signal= upBuffer[i];
        }
      else
         upBuffer[i]= EMPTY_VALUE;

      //double low_nday = MathMin(MathMin(low[i+1],low[i+2]),low[i+3]);
      //if(close[i] < last_buy_signal)
      //   downBuffer[i]= high[i];
      //else
         downBuffer[i]=EMPTY_VALUE;


     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
