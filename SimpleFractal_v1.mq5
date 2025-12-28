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
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//--- Plot Up Fractal (LH - Lower High)
#property indicator_label2  "LH"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrOrange
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

//--- Plot Down Fractal (HL - Higher Low)
#property indicator_label3  "HL"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrSkyBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2

//--- Plot Down Fractal (LL - Lower Low)
#property indicator_label4  "LL"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrBlue
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
//--- Input parameters
enum ENUM_FRACTAL_TYPE
{
    FRACTAL_BILL_WILLIAMS, // Bill Williams
    FRACTAL_REGULAR        // Regular
};

input int InpAdjacentCandles = 2;  // Number of adjacent candles (left and right)
input ENUM_FRACTAL_TYPE InpFractalType = FRACTAL_BILL_WILLIAMS; // Fractal Type
input bool InpUseTwoPrevFractals = false; // Compare strict against 2 previous fractals
input bool InpShowSimpleFractals = false;  // Show simple fractals (gray)
input bool InpShowHHHL = true;  // Show HH and HL fractals
input bool InpShowLHLL = true;  // Show LH and LL fractals

//--- Indicator buffers (NOT as series)
double BufferHH[];      // Higher High
double BufferLH[];      // Lower High
double BufferHL[];      // Higher Low
double BufferLL[];      // Lower Low
double BufferUpFractal[];   // All Up Fractals
double BufferDownFractal[]; // All Down Fractals

//--- Global variables for tracking previous fractals
double g_prevUpFractal = 0.0;    // Previous up fractal value
double g_prevDownFractal = 0.0;  // Previous down fractal value
double g_prevPrevUpFractal = 0.0; // 2nd Previous up fractal
double g_prevPrevDownFractal = 0.0; // 2nd Previous down fractal

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
    
    //--- Set indicator buffers (NOT as series)
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
    
    //--- Set plot drawing type for simple fractals based on input
    if(!InpShowSimpleFractals)
    {
        PlotIndexSetInteger(4, PLOT_DRAW_TYPE, DRAW_NONE);  // Hide up fractals
        PlotIndexSetInteger(5, PLOT_DRAW_TYPE, DRAW_NONE);  // Hide down fractals
    }
    
 
    
    //--- Explicitly set arrays as NOT series
    ArraySetAsSeries(BufferHH, false);
    ArraySetAsSeries(BufferLH, false);
    ArraySetAsSeries(BufferHL, false);
    ArraySetAsSeries(BufferLL, false);
    ArraySetAsSeries(BufferUpFractal, false);
    ArraySetAsSeries(BufferDownFractal, false);
    
    //--- Initialize global variables
    g_prevUpFractal = EMPTY_VALUE;
    g_prevDownFractal = EMPTY_VALUE;
    g_prevPrevUpFractal = EMPTY_VALUE;
    g_prevPrevDownFractal = EMPTY_VALUE;
    
    //--- Set indicator name
    string typeStr = (InpFractalType == FRACTAL_BILL_WILLIAMS) ? "BW" : "Reg";
    IndicatorSetString(INDICATOR_SHORTNAME, "SimpleFractal(" + typeStr + "," + IntegerToString(InpAdjacentCandles) + ")");
    
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
    //--- Explicitly set price arrays as NOT series
    ArraySetAsSeries(high, false);
    ArraySetAsSeries(low, false);
    
    //--- Calculate limit (starting point for calculation)
    int limit;
    if(prev_calculated == 0)
    {
        limit = InpAdjacentCandles;  // Start from first valid bar
        g_prevUpFractal = EMPTY_VALUE;       // Reset global variables on first run
        g_prevDownFractal = EMPTY_VALUE;
        g_prevPrevUpFractal = EMPTY_VALUE;
        g_prevPrevDownFractal = EMPTY_VALUE;
    }
    else
    {
        limit = prev_calculated -InpAdjacentCandles- 1;  // Recalculate last bar
    }
    
    //--- Main loop (iterate from older to newer bars, forward direction)
    for(int i = limit; i < rates_total - InpAdjacentCandles; i++)
    {
        //--- Initialize buffers
        BufferHH[i] = EMPTY_VALUE;
        BufferLH[i] = EMPTY_VALUE;
        BufferHL[i] = EMPTY_VALUE;
        BufferLL[i] = EMPTY_VALUE;
        BufferUpFractal[i] = EMPTY_VALUE;
        BufferDownFractal[i] = EMPTY_VALUE;
        
        //--- Check for Up Fractal (High)
        bool isUpFractal = true;
        if (InpFractalType == FRACTAL_BILL_WILLIAMS)
        {
           for(int j = 1; j <= InpAdjacentCandles; j++)
           {
               if(high[i] <= high[i - j] || high[i] <= high[i + j])
               {
                   isUpFractal = false;
                   break;
               }
           }
        }
        else // FRACTAL_REGULAR
        {
           for(int j = 1; j <= InpAdjacentCandles; j++)
           {
               // Check left side (rising) AND right side (falling) in one loop
               // Left: high[i-j+1] must be > high[i-j]
               // Right: high[i+j-1] must be > high[i+j]
               if(high[i - j + 1] <= high[i - j] || high[i + j - 1] <= high[i + j])
               {
                   isUpFractal = false;
                   break;
               }
           }
        }
        
        //--- Check for Down Fractal (Low)
        bool isDownFractal = true;
        if (InpFractalType == FRACTAL_BILL_WILLIAMS)
        {
           for(int j = 1; j <= InpAdjacentCandles; j++)
           {
               if(low[i] >= low[i - j] || low[i] >= low[i + j])
               {
                   isDownFractal = false;
                   break;
               }
           }
        }
        else // FRACTAL_REGULAR
        {
           for(int j = 1; j <= InpAdjacentCandles; j++)
           {
               // Check left side (falling) AND right side (rising) in one loop
               // Left: low[i-j+1] must be < low[i-j]
               // Right: low[i+j-1] must be < low[i+j]
               if(low[i - j + 1] >= low[i - j] || low[i + j - 1] >= low[i + j])
               {
                   isDownFractal = false;
                   break;
               }
           }
        }
        
        //--- Process Up Fractal (always calculate)
        if(isUpFractal)
        {
            //--- Always store in up fractal buffer for tracking
            BufferUpFractal[i] = high[i];
            
            //--- Classify as HH or LH based on previous fractal
            if(g_prevUpFractal != EMPTY_VALUE)
            {
               bool isHH = (high[i] > g_prevUpFractal);
               bool isLH = (high[i] < g_prevUpFractal);
               
               if (InpUseTwoPrevFractals && g_prevPrevUpFractal != EMPTY_VALUE)
               {
                  if (high[i] <= g_prevPrevUpFractal) isHH = false;
                  if (high[i] >= g_prevPrevUpFractal) isLH = false;
               }

                if(isHH)
                {
                    // Higher High
                    if(InpShowHHHL)
                        BufferHH[i] = high[i];
                }
                else if (isLH)
                {
                    // Lower High
                    if(InpShowLHLL)
                        BufferLH[i] = high[i];
                }
            }
            
            //--- Update global variables
            g_prevPrevUpFractal = g_prevUpFractal;
            g_prevUpFractal = high[i];
        }
        
        //--- Process Down Fractal (always calculate)
        if(isDownFractal)
        {
            //--- Always store in down fractal buffer for tracking
            BufferDownFractal[i] = low[i];
            
            //--- Classify as HL or LL based on previous fractal
            if(g_prevDownFractal != EMPTY_VALUE)
            {
               bool isHL = (low[i] > g_prevDownFractal);
               bool isLL = (low[i] < g_prevDownFractal);
               
               if (InpUseTwoPrevFractals && g_prevPrevDownFractal != EMPTY_VALUE)
               {
                  if (low[i] <= g_prevPrevDownFractal) isHL = false;
                  if (low[i] >= g_prevPrevDownFractal) isLL = false;
               }

                if(isHL)
                {
                    // Higher Low
                    if(InpShowHHHL)
                        BufferHL[i] = low[i];
                }
                else if(isLL)
                {
                    // Lower Low
                    if(InpShowLHLL)
                        BufferLL[i] = low[i];
                }
            }
            
            //--- Update global variables
            g_prevPrevDownFractal = g_prevDownFractal;
            g_prevDownFractal = low[i];
        }
    }
    
    //--- Return value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
