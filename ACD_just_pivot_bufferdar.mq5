//+------------------------------------------------------------------+
//|                                     ACD_just_pivot_bufferdar.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot up
#property indicator_label1  "up"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGold
#property indicator_style1  STYLE_DASH
#property indicator_width1  1
//--- plot down
#property indicator_label2  "down"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrGold
#property indicator_style2  STYLE_DASH
#property indicator_width2  1
//--- indicator buffers
double         upBuffer[];
double         downBuffer[];
input int period = 1;
input color pivot_color= clrYellow;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,upBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,downBuffer,INDICATOR_DATA);
      PlotIndexSetInteger(0,PLOT_LINE_COLOR,pivot_color);
   PlotIndexSetInteger(1,PLOT_LINE_COLOR,pivot_color);
   ArraySetAsSeries(upBuffer,true);
   ArraySetAsSeries(downBuffer,true);
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
   ArraySetAsSeries(time, true);
   int limit = rates_total- prev_calculated;
   for(int i=0; i<limit; i++)
     {
      int shift_daily=  iBarShift(_Symbol,PERIOD_D1,time[i]);

      double plow, phigh;
      pivot_calculator(period, phigh, plow, shift_daily+1);

      if(PeriodSeconds()<= 3600 * 24 *period)
        {
         upBuffer[i]= phigh;
         downBuffer[i]= plow;

        }
      else
        {
         upBuffer[i]= EMPTY_VALUE;
         downBuffer[i]= EMPTY_VALUE;
        }

     }




//--- return value of prev_calculated for next call
   return(rates_total-1);
  }
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void pivot_calculator(int duration, double& Pup, double& Pdown, int day_shift=1)
  {
   int Hi = iHighest(NULL,PERIOD_D1,MODE_HIGH,duration,day_shift);
   double H =iHigh(NULL,PERIOD_D1,Hi);
   int Li = iLowest(NULL,PERIOD_D1,MODE_LOW,duration,day_shift);
   double L =iLow(NULL,PERIOD_D1,Li);

   double x= (H+L)/2.0;
   double y = (H+L+iClose(NULL,PERIOD_D1,day_shift))/3.0;

   Pup = y+MathAbs(x-y);
   Pdown = y-MathAbs(x-y);
  }
//+------------------------------------------------------------------+
