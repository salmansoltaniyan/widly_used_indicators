//+------------------------------------------------------------------+
//|                                            duplicate_remover.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   long id = ChartFirst() ;
   while(id!= -1)
     {
      if(_Symbol== ChartSymbol(id) && ChartID() != id)
        {
         ChartClose(0);
         ChartSetInteger(id,CHART_BRING_TO_TOP,true);

         break;
        }

      id= ChartNext(id);
     }

  
//---
   return(INIT_SUCCEEDED);
  }
  
  void OnDeinit(const int reason)
    {
      ChartIndicatorDelete(0,0,"duplicate_remover");
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
   return(rates_total);
  }
//+------------------------------------------------------------------+
