//+------------------------------------------------------------------+
//|                                      symbol_info_in_backtest.mq5 |
//|                                                Salman Soltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot Ask
#property indicator_label1  "Ask"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Bid
#property indicator_label2  "Bid"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrAqua
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Last
#property indicator_label3  "Last"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrLime
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot others
#property indicator_label4  "others"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrViolet
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- indicator buffers
double         AskBuffer[];
double         BidBuffer[];
double         LastBuffer[];
double         othersBuffer[];
input bool real_or_percent = true; // realvalues(true), percent(false)
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,AskBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,BidBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,LastBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,othersBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
  // PlotIndexSetInteger(3,PLOT_ARROW,159);
   ArraySetAsSeries(AskBuffer,true);
   ArraySetAsSeries(BidBuffer,true);
   ArraySetAsSeries(LastBuffer,true);
   ArraySetAsSeries(othersBuffer,true);
   
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
   if(real_or_percent)
     {
        AskBuffer[0]= SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   BidBuffer[0]= SymbolInfoDouble(_Symbol,SYMBOL_BID);
   LastBuffer[0]= SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   othersBuffer[0]=EMPTY_VALUE;
     }
     else
       {
         othersBuffer[0]= 100 * (SymbolInfoDouble(_Symbol,SYMBOL_ASK)-  SymbolInfoDouble(_Symbol,SYMBOL_BID))/SymbolInfoDouble(_Symbol,SYMBOL_BID);
  AskBuffer[0]=EMPTY_VALUE;
  BidBuffer[0]=EMPTY_VALUE;
   LastBuffer[0]=EMPTY_VALUE;
       }

 //othersBuffer[0]= SymbolInfoDouble(_Symbol,SYMBOL_SESSION_PRICE_LIMIT_MAX);

// othersBuffer[0]=EMPTY_VALUE;
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
