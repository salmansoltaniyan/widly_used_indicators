//+------------------------------------------------------------------+
//|                                                SimpleFractal.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_plots   6

//--- Plot Up Fractal (HH - Higher High)
#property indicator_label1  "HH"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//--- Plot Up Fractal (LH - Lower High)
#property indicator_label2  "LH"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrYellow
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

//--- Plot Down Fractal (HL - Higher Low)
#property indicator_label3  "HL"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2

//--- Plot Down Fractal (LL - Lower Low)
#property indicator_label4  "LL"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2

//--- Plot All Up Fractals (optional, gray)
#property indicator_label5  "Up Fractal"
#property indicator_type5   DRAW_ARROW
#property indicator_color5  clrDarkGray
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1

//--- Plot All Down Fractals (optional, gray)
#property indicator_label6  "Down Fractal"
#property indicator_type6   DRAW_ARROW
#property indicator_color6  clrDarkGray
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1

//--- Input parameters
input int InpAdjacentCandles = 2;  // Number of adjacent candles (left and right)
input bool InpShowSimpleFractals = false;  // Show simple fractals (gray)
input bool InpShowHHHL = true;  // Show HH and HL fractals
input bool InpShowLHLL = true;  // Show LH and LL fractals

//--- Indicator buffers
double BufferHH[];      // Higher High
double BufferLH[];      // Lower High
double BufferHL[];      // Higher Low
double BufferLL[];      // Lower Low
double BufferUpFractal[];   // All Up Fractals
double BufferDownFractal[]; // All Down Fractals

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- Validate input
    if(InpAdjacentCandles < 1)
    {
        Print("Error: Adjacent candles must be at least 1");
        return(INIT_PARAMETERS_INCORRECT);
    }
    
    //--- Set indicator buffers
    SetIndexBuffer(0, BufferHH, INDICATOR_DATA);
    SetIndexBuffer(1, BufferLH, INDICATOR_DATA);
    SetIndexBuffer(2, BufferHL, INDICATOR_DATA);
    SetIndexBuffer(3, BufferLL, INDICATOR_DATA);
    SetIndexBuffer(4, BufferUpFractal, INDICATOR_DATA);
    SetIndexBuffer(5, BufferDownFractal, INDICATOR_DATA);
    
    //--- Set arrow codes
    PlotIndexSetInteger(0, PLOT_ARROW, 217);  // HH - up arrow
    PlotIndexSetInteger(1, PLOT_ARROW, 217);  // LH - up arrow
    PlotIndexSetInteger(2, PLOT_ARROW, 218);  // HL - down arrow
    PlotIndexSetInteger(3, PLOT_ARROW, 218);  // LL - down arrow
    PlotIndexSetInteger(4, PLOT_ARROW, 217);  // Up Fractal - up arrow
    PlotIndexSetInteger(5, PLOT_ARROW, 218);  // Down Fractal - down arrow
    
    //--- Set empty values
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0.0);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, 0.0);
    PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, 0.0);
    PlotIndexSetDouble(4, PLOT_EMPTY_VALUE, 0.0);
    PlotIndexSetDouble(5, PLOT_EMPTY_VALUE, 0.0);
    
    //--- Set arrays as series
    ArraySetAsSeries(BufferHH, true);
    ArraySetAsSeries(BufferLH, true);
    ArraySetAsSeries(BufferHL, true);
    ArraySetAsSeries(BufferLL, true);
    ArraySetAsSeries(BufferUpFractal, true);
    ArraySetAsSeries(BufferDownFractal, true);
    
    //--- Set indicator name
    IndicatorSetString(INDICATOR_SHORTNAME, "SimpleFractal(" + IntegerToString(InpAdjacentCandles) + ")");
    
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
    //--- Set arrays as series
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    
    //--- Calculate limit (starting point for calculation)
    int limit;
    if(prev_calculated == 0)
        limit = rates_total - InpAdjacentCandles - 1;  // First calculation
    else
        limit = rates_total - prev_calculated;          // Subsequent calculations
    
    //--- Main loop (iterate from older bars to newer bars)
    for(int i = limit; i >= InpAdjacentCandles; i--)
    {
        //--- Initialize buffers
        BufferHH[i] = 0.0;
        BufferLH[i] = 0.0;
        BufferHL[i] = 0.0;
        BufferLL[i] = 0.0;
        BufferUpFractal[i] = 0.0;
        BufferDownFractal[i] = 0.0;
        
        //--- Check for Up Fractal (High)
        bool isUpFractal = true;
        for(int j = 1; j <= InpAdjacentCandles; j++)
        {
            if(high[i] <= high[i - j] || high[i] <= high[i + j])
            {
                isUpFractal = false;
                break;
            }
        }
        
        //--- Check for Down Fractal (Low)
        bool isDownFractal = true;
        for(int j = 1; j <= InpAdjacentCandles; j++)
        {
            if(low[i] >= low[i - j] || low[i] >= low[i + j])
            {
                isDownFractal = false;
                break;
            }
        }
        
        //--- Process Up Fractal
        if(isUpFractal)
        {
            //--- Find previous up fractal
            double prevUpFractal = 0.0;
            for(int j = i + 1; j < rates_total; j++)
            {
                if(BufferUpFractal[j] > 0.0 || BufferHH[j] > 0.0 || BufferLH[j] > 0.0)
                {
                    prevUpFractal = MathMax(BufferUpFractal[j], MathMax(BufferHH[j], BufferLH[j]));
                    break;
                }
            }
            
            //--- Classify as HH or LH
            if(prevUpFractal > 0.0)
            {
                if(high[i] > prevUpFractal)
                {
                    if(InpShowHHHL)
                        BufferHH[i] = high[i];  // Higher High
                }
                else
                {
                    if(InpShowLHLL)
                        BufferLH[i] = high[i];  // Lower High
                }
            }
            
            //--- Show simple fractal
            if(InpShowSimpleFractals)
                BufferUpFractal[i] = high[i];
        }
        
        //--- Process Down Fractal
        if(isDownFractal)
        {
            //--- Find previous down fractal
            double prevDownFractal = 0.0;
            for(int j = i + 1; j < rates_total; j++)
            {
                if(BufferDownFractal[j] > 0.0 || BufferHL[j] > 0.0 || BufferLL[j] > 0.0)
                {
                    prevDownFractal = (BufferDownFractal[j] > 0.0) ? BufferDownFractal[j] : 
                                     ((BufferHL[j] > 0.0) ? BufferHL[j] : BufferLL[j]);
                    break;
                }
            }
            
            //--- Classify as HL or LL
            if(prevDownFractal > 0.0)
            {
                if(low[i] > prevDownFractal)
                {
                    if(InpShowHHHL)
                        BufferHL[i] = low[i];  // Higher Low
                }
                else
                {
                    if(InpShowLHLL)
                        BufferLL[i] = low[i];  // Lower Low
                }
            }
            
            //--- Show simple fractal
            if(InpShowSimpleFractals)
                BufferDownFractal[i] = low[i];
        }
    }
    
    //--- Return value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
