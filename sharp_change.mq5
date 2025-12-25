//+------------------------------------------------------------------+
//|                                                 sharp_change.mq5 |
//|                                                Salman Soltaniyan |
//|                                        SalmanSoltaniyan@mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "SalmanSoltaniyan@mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 2
#property indicator_type1 DRAW_ARROW
#property indicator_type2 DRAW_ARROW
#property indicator_width1 5
#property indicator_width2 5
#property indicator_color1 clrGreen
#property indicator_color2 clrRed
enum ENUM_INPUT_TYPE
  {
   Percent = 0,
   Pips = 1,
  };
enum ENUM_DIRECTION
  {
   Upward = 0,
   Downward = 1,
  };
//+------------------------------------------------------------------+
//| inputs                                                                 |
//+------------------------------------------------------------------+
input double change_value = 1;
input ENUM_INPUT_TYPE input_type= Percent;
input ENUM_DIRECTION direction = Upward;
input int candle_nums = 2; //Number of Candles
input bool alert = true; //Alert
//+------------------------------------------------------------------+
//| Variables                                                               |
//+------------------------------------------------------------------+
double up_array[],down_array[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,up_array,INDICATOR_DATA);
   SetIndexBuffer(1,down_array,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_ARROW,233);
   PlotIndexSetInteger(1,PLOT_ARROW,234);

   ArraySetAsSeries(up_array,true);
   ArraySetAsSeries(down_array,true);
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

   int limit = rates_total - prev_calculated;
   if(limit == rates_total)
      limit = limit - candle_nums-10;
   for(int i=0; i<limit; i++)
     {
      bool is_sharp= sharp_change_finder(candle_nums,change_value,i,input_type,direction);

      if(direction == Upward)
        {

         down_array[i]= EMPTY_VALUE;
         if(is_sharp)
         {
            up_array[i]= iLow(_Symbol,PERIOD_CURRENT,i)- (iHigh(_Symbol,PERIOD_CURRENT,i)-iLow(_Symbol,PERIOD_CURRENT,i))/5;
            
            Print("i == ", i);
            }
         else
            up_array[i]=EMPTY_VALUE;

        }
      if(direction == Downward)
        {
         up_array[i]= EMPTY_VALUE;
         if(is_sharp)
            down_array[i]= iHigh(_Symbol,PERIOD_CURRENT,i) +(iHigh(_Symbol,PERIOD_CURRENT,i)-iLow(_Symbol,PERIOD_CURRENT,i))/5 ;
         else
            down_array[i]=EMPTY_VALUE;


        }

     }

//--- return value of prev_calculated for next call
   return(rates_total-1);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sharp_change_finder(int num, double value, int shift, ENUM_INPUT_TYPE type, ENUM_DIRECTION dir)
  {
   double val=0;
   if(type== Percent)
     {
      //if(iOpen(_Symbol,PERIOD_CURRENT,shift+ num)==0)
      //   return false;
      val = (iClose(_Symbol,PERIOD_CURRENT,shift) - iOpen(_Symbol,PERIOD_CURRENT,shift+ num-1))/iOpen(_Symbol,PERIOD_CURRENT,shift+ num-1);
      val *= 100;
     }

   if(type== Pips)
      val = 10*(iClose(_Symbol,PERIOD_CURRENT,shift) - iOpen(_Symbol,PERIOD_CURRENT,shift+ num-1))/Point();


   if(val > value && dir == Upward)
      return true;


   if(val < -value && dir == Downward)
      return true;

   return false;
  }
//+------------------------------------------------------------------+
