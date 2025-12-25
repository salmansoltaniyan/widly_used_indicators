//+------------------------------------------------------------------+
//|                                        news_events_displayer.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
input bool low_priority = false;
input bool medium_priority = false;
input bool high_priority = true;
input datetime time_orgin_=0; //orginTime(if 0 = timecurrent)
datetime time_orgin;
input int prev_days = 60;
input int next_days = 30;
MqlCalendarValue value_change_base[];
MqlCalendarValue value_change_target[];
ulong change_id_base=0, change_id_target=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   if(time_orgin_==0)
     
      time_orgin= TimeCurrent();
     
     else
       time_orgin = time_orgin_;
        
       
   ObjectsDeleteAll(0,0,OBJ_EVENT);
   datetime start_time =time_orgin- 3600*24* prev_days;
   datetime end_time = time_orgin+ 3600*24* next_days;
   string base_currency= SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE);
   string target_currency= SymbolInfoString(_Symbol,SYMBOL_CURRENCY_PROFIT);

   currency_event_value_plotter(start_time,end_time,base_currency,high_priority,medium_priority,low_priority);
   currency_event_value_plotter(start_time,end_time,target_currency,high_priority,medium_priority,low_priority);

   CalendarValueLast(change_id_base,value_change_base,NULL,base_currency);
   CalendarValueLast(change_id_target,value_change_target,NULL,target_currency);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
//---
   string base_currency= SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE);
   string target_currency= SymbolInfoString(_Symbol,SYMBOL_CURRENCY_PROFIT);

   if(CalendarValueLast(change_id_base,value_change_base,NULL,base_currency) >0)
     {
      Print("changed happened in base_currency events in ",TimeCurrent());
      ArrayPrint(value_change_base);
     }
   if(CalendarValueLast(change_id_target,value_change_target,NULL,target_currency)>0)
     {
      Print("changed happened in target_currency events in ",TimeCurrent());
      ArrayPrint(value_change_target);

     }



//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void obj_event_creator(string name,datetime time,string text_,color colr)
  {
   ObjectCreate(0,name,OBJ_EVENT,0,time,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,colr);
   ObjectSetString(0,name,OBJPROP_TEXT,text_);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void currency_event_value_plotter(datetime start_time,datetime end_time,string currency, bool ishigh, bool ismedium, bool islow)
  {
   MqlCalendarValue eventvalues[];
   CalendarValueHistory(eventvalues,start_time,end_time,NULL,currency);


   int j=0;
   for(int i=0; i<ArraySize(eventvalues); i++)
     {
      MqlCalendarEvent myevent;
      CalendarEventById(eventvalues[i].event_id,myevent);
      string obj_name= TimeToString(eventvalues[i].time) + IntegerToString(eventvalues[i].event_id);
      string text=currency +"_"+" ActV= " +DoubleToString(eventvalues[i].actual_value/1000000,1) +
                  " ForcV= "+DoubleToString(eventvalues[i].forecast_value/1000000,1) +"\n"+ myevent.name +"_"+
                  "\n"+EnumToString((ENUM_CALENDAR_EVENT_IMPACT) eventvalues[i].impact_type);
      if(islow==true && myevent.importance == CALENDAR_IMPORTANCE_LOW)
        {
         obj_event_creator(obj_name,eventvalues[i].time,text,clrGray);
        }
      if(ismedium==true && myevent.importance == CALENDAR_IMPORTANCE_MODERATE)
        {
         obj_event_creator(obj_name,eventvalues[i].time,text,clrOrange);
        }
      if(ishigh==true && myevent.importance == CALENDAR_IMPORTANCE_HIGH)
        {
         obj_event_creator(obj_name,eventvalues[i].time,text,clrRed);

        }




     }
  }
//+------------------------------------------------------------------+
