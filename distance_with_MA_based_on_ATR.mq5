//+------------------------------------------------------------------+
//|                                distance_with_MA_based_on_ATR.mq5 |
//|                                                Salman Soltaniyan |
//|                                        SalmanSoltaniyan@mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "SalmanSoltaniyan@mql5.com"
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
#property indicator_level1 0
#property indicator_level2 1
#property indicator_level3 -1
//--- indicator buffers
double         Label1Buffer[];
int ma_handle, atr_handle;
double ma_arr[], atr_arr[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int ma_period=20;
input int atr_period=9;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer,INDICATOR_DATA);
   ArraySetAsSeries(Label1Buffer,true);

   ma_handle= iMA(_Symbol,PERIOD_CURRENT,ma_period,0,MODE_SMA,PRICE_CLOSE);
   atr_handle = iATR(_Symbol,PERIOD_CURRENT,atr_period);
ArraySetAsSeries(ma_arr,true);
ArraySetAsSeries(atr_arr,true);
   ChartIndicatorAdd(0,0,ma_handle);
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
   ArraySetAsSeries(close, true);
   int limit = rates_total- prev_calculated;
   if(limit!=0)
     {
      CopyBuffer(ma_handle,0,0,limit,ma_arr);
      CopyBuffer(atr_handle,0,0,limit,atr_arr);
     }
   for(int i=0; i<limit; i++)
     {
      if(ma_arr[i] != EMPTY_VALUE && atr_arr[i]!= EMPTY_VALUE)
         Label1Buffer[i]= (close[i]- ma_arr[i])/atr_arr[i];
        
      else
         Label1Buffer[i]=EMPTY_VALUE;
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
