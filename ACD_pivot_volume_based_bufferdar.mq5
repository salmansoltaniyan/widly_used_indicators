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
input double daily_atr_band_ratio = 0;
input color pivot_color= clrYellow;
int atr_buff;
double atr_array[];
int limit;
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
  //ArrayFree(upBuffer);
  //(downBuffer);
//limit = Bars(_Symbol,PERIOD_CURRENT);
   atr_buff= iATR(_Symbol,PERIOD_D1,10);
   ArraySetAsSeries(atr_array,true);
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
    limit = rates_total- prev_calculated;



   for(int i=0; i<limit; i++)
     {
      int shift_daily=  iBarShift(_Symbol,PERIOD_D1,time[i]);
      //Print("i = ", i, "shift_daily = ",shift_daily, "time = ", time[i]);
      double plow, phigh;
      pivot_volumebased_calculator(phigh, plow, shift_daily+1, daily_atr_band_ratio, period);
      if(PeriodSeconds()< 3600 * 24 *period)
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
void pivot_volumebased_calculator(double& Pup, double& Pdown, int day_shift, double atr_band_ratio_, int duration)
  {

   int shift1= iBarShift(_Symbol,PERIOD_M1,iTime(_Symbol,PERIOD_D1,day_shift+ duration -1)+30,false)-1; // test shod daghighan doroste
   int shift0 = iBarShift(_Symbol,PERIOD_M1,iTime(_Symbol,PERIOD_D1,day_shift-1)-30,false); //test shod daghighan doroste
//if(day_shift==2)
//Print("dayshift = :", day_shift," M1shift0 close = ",  iClose(_Symbol,PERIOD_M1,shift0),"M1shift1 close = ",  iClose(_Symbol,PERIOD_M1,shift1));
   long vol_sum=0;
   double weighted_price=0;
   for(int j=shift0; j<shift1; j++)
     {
      weighted_price = weighted_price + iClose(_Symbol,PERIOD_M1,j) * iRealVolume(_Symbol,PERIOD_M1,j);
      vol_sum = vol_sum + iRealVolume(_Symbol,PERIOD_M1,j);
     }
   weighted_price = weighted_price/ vol_sum;

   //int shift_5min= iBarShift(_Symbol,PERIOD_M5,iTime(_Symbol,PERIOD_D1,day_shift-1)-60,false);
   CopyBuffer(atr_buff,0,day_shift,3,atr_array);
   Pup = weighted_price+ atr_array[0] * atr_band_ratio_/2;
   Pdown= weighted_price- atr_array[0]* atr_band_ratio_/2;
//   double x= (H+L)/2.0;
//   double y = (H+L+iClose(NULL,PERIOD_D1,day_shift))/3.0;
//
//   Pup = y+MathAbs(x-y);
//   Pdown = y-MathAbs(x-y);
  }
//+------------------------------------------------------------------+
