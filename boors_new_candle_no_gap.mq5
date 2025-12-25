//+------------------------------------------------------------------+
//|                                      boors_new_candle_no_gap.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1
//--- plot Label1
#property indicator_label1  "Label1"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrLimeGreen,clrOrangeRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         Label1Buffer1[];
double         Label1Buffer2[];
double         Label1Buffer3[];
double         Label1Buffer4[];
double         Label1Colors[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer1,INDICATOR_DATA);
   SetIndexBuffer(1,Label1Buffer2,INDICATOR_DATA);
   SetIndexBuffer(2,Label1Buffer3,INDICATOR_DATA);
   SetIndexBuffer(3,Label1Buffer4,INDICATOR_DATA);
   SetIndexBuffer(4,Label1Colors,INDICATOR_COLOR_INDEX);
   ArraySetAsSeries(Label1Buffer1,true);
   ArraySetAsSeries(Label1Buffer2,true);
   ArraySetAsSeries(Label1Buffer3,true);
   ArraySetAsSeries(Label1Buffer4,true);
   ArraySetAsSeries(Label1Colors,true);

ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrNONE);
ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrNONE);
ChartSetInteger(0,CHART_COLOR_CHART_UP,clrNONE);
ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrNONE);
ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrNONE);
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
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);

   int limit = rates_total- prev_calculated;
   if(limit == rates_total)
      limit--;
   for(int i=0; i<limit; i++)
     {
      Label1Buffer1[i]= close[i+1];
      Label1Buffer2[i]= high[i];
      Label1Buffer3[i]= low[i];
      Label1Buffer4[i]= close[i];
      if(close[i] >= close[i+1])
         Label1Colors[i]=0;
      else
         Label1Colors[i]=1;

     }
//---

//--- return value of prev_calculated for next call
   return(rates_total-1);
  }
//+------------------------------------------------------------------+
