//+------------------------------------------------------------------+
//|                                                box_simulator.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_plots 0
input datetime t1 = D'2021.01.01 00:00';
input color col = clrGainsboro;
input int fast_button_move = 10;

string t2="var"+ _Symbol;

int shift,shift_day;

int atr_handle,atr_handle_timecurrent;
double atr_array[],atr_array_timecurrent[];

#include <ChartObjects\ChartObjectsTxtControls.mqh>


CChartObjectText Day_Text;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   atr_handle= iATR(_Symbol,PERIOD_D1,10);
   ArraySetAsSeries(atr_array,true);

   atr_handle_timecurrent= iATR(_Symbol,PERIOD_CURRENT,10);
   ArraySetAsSeries(atr_array_timecurrent,true);

   ChartSetInteger(0,CHART_FOREGROUND,false);
   ChartSetInteger(0,CHART_AUTOSCROLL,false);
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,false);
   ChartSetInteger(0,CHART_EVENT_MOUSE_WHEEL,true);

   if(!GlobalVariableCheck(t2))
     {
      GlobalVariableTemp(t2);
      GlobalVariableSet(t2,(int)t1);


     }

   if(GlobalVariableGet(t2)==0)
     {
      GlobalVariableSet(t2,(int)t1);
     }
//
//---
//ChartNavigate(0,CHART_END, -iBarShift(_Symbol,PERIOD_CURRENT,(datetime)GlobalVariableGet(t2),false));

int all_x_pixel =(int) 3*ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)+(int)MathRound(iBarShift(_Symbol,PERIOD_CURRENT,(datetime)GlobalVariableGet(t2),false)*ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/ChartGetInteger(0,CHART_WIDTH_IN_BARS));
   for(int i=0; i<ChartGetInteger(0,CHART_WINDOWS_TOTAL); i++)
     {
      int x, y;
      ChartTimePriceToXY(0,i,(datetime)GlobalVariableGet(t2),ChartGetDouble(0,CHART_PRICE_MAX,i),x,y);
      y=0;
      if(ObjectFind(0,"R"+(string)i)<0)
         ButtonCreate(0,"R"+(string)i,i,x,y,all_x_pixel,1600,CORNER_LEFT_UPPER,col);
      //Rect[i].Create(0,"R"+(string)i,i,(datetime)GlobalVariableGet(t2),low_[i],ttt,high_[i]);
     }
   ChartRedraw(0);

   MqlDateTime t2_struct;
   if(ObjectFind(0,"day_text")<0)
      Day_Text.Create(0,"day_text",0,(datetime)GlobalVariableGet(t2), ChartGetDouble(0,CHART_PRICE_MAX)-10*Point());
   TimeToStruct((datetime)GlobalVariableGet(t2),t2_struct);
   Day_Text.SetString(OBJPROP_TEXT,EnumToString((ENUM_DAY_OF_WEEK)t2_struct.day_of_week));
   Day_Text.Anchor(ANCHOR_RIGHT_UPPER);

   botton("fast_right",1,">>",clrGreen);
   botton("right",2,">",clrMagenta);
   botton("reset",3,"r",clrBlueViolet);
   botton("left",4,"<",clrDarkOrange);
   botton("fast_left",5,"<<",clrRosyBrown);

// int my_session_handle = iCustom(_Symbol,PERIOD_CURRENT,"app\\my_session.ex5");
// ChartIndicatorAdd(0,1,my_session_handle);

   //Print("_________________________",GlobalVariableGet(t2));
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   for(int i=0; i<ChartGetInteger(0,CHART_WINDOWS_TOTAL); i++)
     {
      ObjectDelete(0,"R"+(string)i);
     }
   ObjectDelete(0,"fast_right");
   ObjectDelete(0,"right");
   ObjectDelete(0,"left");
   ObjectDelete(0,"fast_left");
   ObjectDelete(0,"reset");

   if(reason != REASON_CHARTCHANGE)
     {
      GlobalVariableSet(t2,0);
     }
   ChartRedraw(0);
//  ChartIndicatorDelete(0,1,"app\\my_session.ex5");
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
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   for(int i=0; i<ChartGetInteger(0,CHART_WINDOWS_TOTAL); i++)
     {
      int x, y;
      ChartTimePriceToXY(0,i,(datetime)GlobalVariableGet(t2),ChartGetDouble(0,CHART_PRICE_MAX,i),x,y);
      y=0;
      ButtonMove(0,"R"+(string)i,x,y);

     }
   ChartRedraw(0);
   if(id== CHARTEVENT_OBJECT_CLICK && sparam =="right")
     {
      shift_box(+1);
      ObjectSetInteger(0,"right",OBJPROP_STATE,false);

     }
   if(id== CHARTEVENT_OBJECT_CLICK && sparam =="fast_right")
     {
      shift_box(fast_button_move);
      ObjectSetInteger(0,"fast_right",OBJPROP_STATE,false);

     }




   if(id== CHARTEVENT_OBJECT_CLICK && sparam =="left")
     {
      shift_box(-1);
      ObjectSetInteger(0,"left",OBJPROP_STATE,false);
     }

   if(id== CHARTEVENT_OBJECT_CLICK && sparam =="fast_left")
     {
      shift_box(-fast_button_move);
      ObjectSetInteger(0,"fast_left",OBJPROP_STATE,false);
     }
     
   if(id== CHARTEVENT_OBJECT_CLICK && sparam =="reset")
     {
      GlobalVariableSet(t2,(int)t1);

      for(int i=0; i<ChartGetInteger(0,CHART_WINDOWS_TOTAL); i++)
        {
         int x, y;
         ChartTimePriceToXY(0,i,t1,ChartGetDouble(0,CHART_PRICE_MAX,i),x,y);
         y=0;
         ButtonMove(0,"R"+(string)i,x,y);
        }
      adjust_text(t1);
      ChartRedraw();
      //Print("+++++++++++++++++++++++++",GlobalVariableGet(t2));
      ObjectSetInteger(0,"reset",OBJPROP_STATE,false);
     }



  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void botton(string name, int x, string text, color col1)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,25);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,25);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,25);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,25*x);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col1);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,14);
//ObjectSetInteger(0,name,OBJPROP_STATE,false);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void adjust_text(datetime t)
  {

   Day_Text.Time(0,t);

//  Day_Text.Price(1,iHigh(_Symbol,PERIOD_CURRENT,0)+100*Point());
   Day_Text.Price(0,ChartGetDouble(0,CHART_PRICE_MAX)-10*Point());
   MqlDateTime t_struct;
   TimeToStruct(t,t_struct);
   Day_Text.SetString(OBJPROP_TEXT,EnumToString((ENUM_DAY_OF_WEEK)t_struct.day_of_week));


  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const color back_clr=C'236,233,216')

// priority for mouse click
  {
   const string            text="Button";            // text
   const string            font="Arial";             // font
   const int               font_size=10;             // font size
   const color             clr=clrBlack;             // text color
// const color             back_clr=C'236,233,216';  // background color
   const color             border_clr=clrNONE;       // border color
   const bool              state=true;             // pressed/released
   const bool              back=false;             // in the background
   const bool              selection=false;         // highlight to move
   const bool              hidden=false;              // hidden in the object list
   const long              z_order=0;
//--- reset the error value
   ResetLastError();
//--- create the button
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the button                                                  |
//+------------------------------------------------------------------+
bool ButtonMove(const long   chart_ID=0,    // chart's ID
                const string name="Button", // button name
                const int    x=0,           // X coordinate
                const int    y=0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the button
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+----
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shift_box(int increment)
  {
   shift = iBarShift(_Symbol,PERIOD_CURRENT,(datetime)GlobalVariableGet(t2),false);
   datetime t = iTime(_Symbol,PERIOD_CURRENT,shift-increment);

   for(int i=0; i<ChartGetInteger(0,CHART_WINDOWS_TOTAL); i++)
     {
      int x, y;
      ChartTimePriceToXY(0,i,t,ChartGetDouble(0,CHART_PRICE_MAX,i),x,y);
      y=0;
      ButtonMove(0,"R"+(string)i,x,y);
     }
   GlobalVariableSet(t2,(int)t);
//Print("==========================",GlobalVariableGet(t2));
   adjust_text(t);
//---
   shift_day  = iBarShift(_Symbol,PERIOD_D1,t,false);
   CopyBuffer(atr_handle,0,shift_day,3,atr_array);
   CopyBuffer(atr_handle_timecurrent,0,shift,3,atr_array_timecurrent);
   Comment("day_ATR_pip = ",round(atr_array[0]/Point())/10,"\n","timeCurrent_ATR = ",round(atr_array_timecurrent[0]/Point())/10);
   ChartRedraw(0);




  }
//+------------------------------------------------------------------+
