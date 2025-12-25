//+------------------------------------------------------------------+
//|                                 shadi_fractal_line_indicator.mq5 |
//|                                                Salman Soltaniyan |
//|                                        SalmanSoltaniyan@mql5.com |
//+------------------------------------------------------------------+
#property copyright "Salman Soltaniyan"
#property link      "SalmanSoltaniyan@mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   5
//--- plot line_up
#property indicator_label1  "line_up"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrMediumSeaGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot line_down
#property indicator_label2  "line_down"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot arrow_up
#property indicator_label3  "arrow_up"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrMediumSeaGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot arrow_down
#property indicator_label4  "arrow_down"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

#property indicator_label5  "TP"
#property indicator_type5   DRAW_ARROW
#property indicator_color5  clrYellow
#property indicator_style5  STYLE_SOLID
#property indicator_width5  5
//--- indicator buffers
double         line_upBuffer[];
double         line_downBuffer[];
double         arrow_upBuffer[];
double         arrow_downBuffer[],arrow_TPBuffer[];
double      fractal_up[],fractal_down[], atr[];
int fractal_handle, atr_handle;

input double fractal_offset_atr_ratio = 1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,line_upBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,line_downBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,arrow_upBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,arrow_downBuffer,INDICATOR_DATA);
      SetIndexBuffer(4,arrow_TPBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(2,PLOT_ARROW,241);
   PlotIndexSetInteger(3,PLOT_ARROW,242);
      PlotIndexSetInteger(4,PLOT_ARROW,176);
PlotIndexSetInteger(2,PLOT_LINE_WIDTH,6);
PlotIndexSetInteger(3,PLOT_LINE_WIDTH,6);
PlotIndexSetInteger(4,PLOT_LINE_WIDTH,6);
   ArraySetAsSeries(line_upBuffer,false);
   ArraySetAsSeries(line_downBuffer,false);
   ArraySetAsSeries(arrow_upBuffer,false);
   ArraySetAsSeries(arrow_downBuffer,false);
      ArraySetAsSeries(arrow_TPBuffer,false);

   fractal_handle= iFractals(_Symbol,PERIOD_CURRENT);
   ArraySetAsSeries(fractal_up,false);
   ArraySetAsSeries(fractal_down,false);
   atr_handle = iATR(_Symbol,PERIOD_CURRENT,20);
   ArraySetAsSeries(atr, false);
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
   ArraySetAsSeries(high, false);
   ArraySetAsSeries(low, false);
   if(rates_total-prev_calculated !=0)
     {
      CopyBuffer(fractal_handle,0,prev_calculated,rates_total-prev_calculated,fractal_up);
      CopyBuffer(fractal_handle,1,prev_calculated,rates_total-prev_calculated,fractal_down);
      CopyBuffer(atr_handle,0,prev_calculated,rates_total-prev_calculated,atr);
     }
   double line_up= EMPTY_VALUE;
   double line_down=EMPTY_VALUE;
   bool cross_up = false;
   bool cross_down=false;
   for(int i=prev_calculated ; i<rates_total-2; i++)
     {
      arrow_downBuffer[i+2]=EMPTY_VALUE;
      arrow_upBuffer[i+2]=EMPTY_VALUE;
        arrow_TPBuffer[i+2]= EMPTY_VALUE;
      if(high[i+2]>line_up && low[i+2]< line_up && cross_up==false)
        {
         arrow_upBuffer[i+2]=low[i+2]-2*atr[i+2];
         //arrow_TPBuffer[i+2]= line_up + 7*atr[i+2];
         cross_up=true;

        }
      if(high[i+2]>line_down && low[i+2]< line_down && cross_down==false)
        {
         arrow_downBuffer[i+2]=high[i+2]+2*atr[i+2];
           //arrow_TPBuffer[i+2]= line_down - 7*atr[i+2];
         cross_down=true;

        }
      if(fractal_up[i] != EMPTY_VALUE)
        {
         line_up= fractal_up[i]+ atr[i]*fractal_offset_atr_ratio;
         cross_up=false;
        }
      if(fractal_down[i] != EMPTY_VALUE)
        {
         line_down= fractal_down[i]-atr[i]*fractal_offset_atr_ratio;
         cross_down=false;
        }
      line_upBuffer[i+2]=line_up;
      line_downBuffer[i+2]=line_down;




     }



//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
