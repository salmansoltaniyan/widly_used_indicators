//+------------------------------------------------------------------+
//|                                               near_engulfing.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 2
#property indicator_type1 DRAW_ARROW
#property indicator_type2 DRAW_ARROW
#property indicator_color1 clrAqua
#property indicator_color2 clrRed

double buy[],sell[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,buy,INDICATOR_DATA);
   SetIndexBuffer(1,sell,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_ARROW,241);
   PlotIndexSetInteger(1,PLOT_ARROW,242);
      PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,10);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-10);
//---
//ChartSetSymbolPeriod(0,NULL,0);
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
  Print("Highhhhh");
  Comment(rates_total);
//---
   for(int i=prev_calculated; i<rates_total; i++)
     {
      if(i==0)
         continue;

      if(close[i-1]<open[i-1] && close[i] > open[i-1])
        {
         buy[i] = low[i];
         sell[i]= EMPTY_VALUE;
        }
else
      if(close[i-1]> open[i-1] && close[i] < open[i-1])
        {
         sell[i] = high[i];
         buy[i]= EMPTY_VALUE;
        }
        else
          {
            sell[i] =EMPTY_VALUE;
         buy[i]= EMPTY_VALUE;
          }

     }


//--- return value of prev_calculated for next call
   return(rates_total-1);
  }
//+------------------------------------------------------------------+
