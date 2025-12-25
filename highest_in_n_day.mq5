//+------------------------------------------------------------------+
//|                                             highest_in_n_day.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot high
#property indicator_label1  "high"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot low
#property indicator_label2  "low"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDeepSkyBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         highBuffer[];
double         lowBuffer[];

input int period = 10;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,highBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,lowBuffer,INDICATOR_DATA);
   ArraySetAsSeries(highBuffer, true);
   ArraySetAsSeries(lowBuffer, true);

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
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
//---
   int limit= rates_total - prev_calculated;
   if(limit ==rates_total)
      limit -= period+1;


   for(int i=0 ; i<limit; i++)
     {


      highBuffer[i]= iHigh(_Symbol,PERIOD_CURRENT,iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,period,i));
      lowBuffer[i]=iLow(_Symbol,PERIOD_CURRENT, iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,period,i));

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
