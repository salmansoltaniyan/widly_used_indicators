//+------------------------------------------------------------------+
//|                                                  forex_trade.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "https://tradelife.ir"
#property version   "1.00"
#property indicator_chart_window
int atr_handle,atr_handle_timecurrent;
double atr_array[],atr_array_timecurrent[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
    atr_handle= iATR(_Symbol,PERIOD_D1,10);
   ArraySetAsSeries(atr_array,true);
    atr_handle_timecurrent= iATR(_Symbol,PERIOD_CURRENT,10);
   ArraySetAsSeries(atr_array_timecurrent,true);
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
   
//--- return value of prev_calculated for next call
CopyBuffer(atr_handle,0,0,3,atr_array);
MqlDateTime t_now, t_candle_open,t_diff;
TimeCurrent(t_now);
TimeToStruct(PeriodSeconds() - (TimeCurrent()- iTime(_Symbol,PERIOD_CURRENT,0)),t_diff);
       CopyBuffer(atr_handle_timecurrent,0,0,3,atr_array_timecurrent);
      Comment("day_ATR_pip = ",round(atr_array[0]/Point())/10,"\n","timeCurrent_ATR = ",round(atr_array_timecurrent[0]/Point())/10,
      "\n","spread_point= ",SymbolInfoInteger(_Symbol,SYMBOL_SPREAD),
      "\n","remain_time= ",t_diff.hour," : ",t_diff.min," : ",t_diff.sec ,
      "\n","freeze level =", SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL),
      "\n","stop level =", SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL  ) );
      
   return(rates_total);
  }
//+------------------------------------------------------------------+
