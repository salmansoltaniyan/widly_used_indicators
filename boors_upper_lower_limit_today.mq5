//+------------------------------------------------------------------+
//|                                boors_upper_lower_limit_today.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "@tradelifeir"
#property link      "https://www.tradelife.ir"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot up
#property indicator_label1  "up"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrAqua
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot down
#property indicator_label2  "down"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDeepSkyBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "y_payani"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDeepSkyBlue
#property indicator_style3  STYLE_DASHDOT
#property indicator_width3  1
//--- indicator buffers
double         upBuffer[];
double         downBuffer[];
double         middleBuffer[];
double middle;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,upBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,downBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,middleBuffer,INDICATOR_DATA);
   ArraySetAsSeries(upBuffer,true);
   ArraySetAsSeries(downBuffer,true);
   ArraySetAsSeries(middleBuffer,true);

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
   ArraySetAsSeries(close,true);
   int limit = iBarShift(_Symbol,PERIOD_CURRENT,iTime(_Symbol,PERIOD_D1,0));
   middle= SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MAX) - (SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MAX)- SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MIN))/2;
   Comment("price_percent= ", NormalizeDouble(100* (close[0]- middle)/middle,1));
   if(prev_calculated != rates_total)
     {


      for(int i=0; i<limit; i++)
        {
         upBuffer[i]= SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MAX);
         downBuffer[i]= SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MIN);
         middleBuffer[i]= upBuffer[i]- (upBuffer[i]-downBuffer[i])/2;
        }
      for(int i=limit; i<rates_total; i++)
        {
         upBuffer[i]= EMPTY_VALUE;
         middleBuffer[i]= EMPTY_VALUE;
         downBuffer[i]= EMPTY_VALUE;
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
