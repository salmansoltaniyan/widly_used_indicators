//+------------------------------------------------------------------+
//|                                   boors_same_group_dashboard.mq5 |
//|                                                 SalmanSoltaniyan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SalmanSoltaniyan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#include <Controls\Defines.mqh>
#undef  CONTROLS_DIALOG_CAPTION_HEIGHT
#define CONTROLS_DIALOG_CAPTION_HEIGHT      (22)
#include <Controls\Dialog.mqh>
#include <Controls\ComboBox.mqh>
string groupStock[];
input int min_tradeValue =0; //min_tradeValue_yesterday(MT)
input int open_since_ndays = 30;
enum market_type {
boors = 1,
option_ati = 100
};
input market_type contract_size=boors; // market_type
enum tadil {
only_Tadil_shode = 0,
Both = 1
};
input tadil x_tadil= Both; 

CAppDialog mywindow;
CComboBox mycombo;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  
// ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   ChartSetInteger(0,CHART_SHOW_TICKER,true);
  // MqlTick mytick;
   datetime t5 = TimeCurrent();
   datetime tcandle_last=0;
   double value_last;
   t5= t5 - 3600 * 24 *open_since_ndays; // time of 5 days ago

//--- indicator buffers mapping

   mywindow.Create(0,"mywindow",0,0,15,180,85);
   mywindow.Caption("Group members");
   mycombo.Create(0,"mycombo",0,0,0,160,30);
   mycombo.Shift(0,5);



   int jj=0;
   ArrayResize(groupStock,jj+1);
   string path= SymbolInfoString(NULL,SYMBOL_PATH);
   string rawpath0, rawpath;
   rawpath0= exclude_name_from_path(path, x_tadil);
// Print("path = ",rawpath0);
   for(int i=0; i<SymbolsTotal(false); i++)
     {
      //SymbolSelect(SymbolName(i,false),false);
      path= SymbolInfoString(SymbolName(i,false),SYMBOL_PATH);
      rawpath= exclude_name_from_path(path, x_tadil);
      if(rawpath==rawpath0)
        {
        // SymbolSelect(SymbolName(i,false),true);
        // SymbolInfoTick(SymbolName(i,false),mytick);
        tcandle_last=iTime(SymbolName(i,false),PERIOD_D1,0);
        value_last =iRealVolume(SymbolName(i,false),PERIOD_D1,1)* iClose(SymbolName(i,false),PERIOD_D1,1)*contract_size;
         // Print(mytick.time);
         //if(mytick.time<t5)
         //   Print(SymbolName(i,false));
       // if(mytick.time >t5)
         if(tcandle_last >t5 && value_last >( min_tradeValue * 1e7 ) )
           {

            groupStock[jj]= SymbolName(i,false);
            jj++;
            ArrayResize(groupStock,jj+1);

            mycombo.AddItem(SymbolName(i,false));
            //Print("yeki",SymbolName(i,false));
           }
          //  SymbolSelect(SymbolName(i,false),false);
        }
     }
   mycombo.SelectByText(Symbol());
   mywindow.Add(mycombo);
   ObjectDelete(0,"groupname");
   ObjectDelete(0,"groupname0");
   ObjectDelete(0,"groupname1");
   ObjectCreate(0,"groupname1",OBJ_LABEL,0,200,105);
   ObjectSetString(0,"groupname1",OBJPROP_TEXT,rawpath0);
   ObjectSetInteger(0,"groupname1",OBJPROP_XDISTANCE,5);
//  ObjectSetInteger(0,"groupname1",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
// ObjectSetInteger(0,"groupname1",OBJPROP_CORNER,CORNER_LEFT_UPPER);
// ObjectSetInteger(0,"groupname1",OBJPROP_YDISTANCE,95);
//   ObjectSetInteger(0,"groupname1",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"groupname1",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,"groupname1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"groupname1",OBJPROP_COLOR,clrWhiteSmoke);
//   ChartRedraw();
   mywindow.Run();

//---

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   mywindow.Destroy(reason);

  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

   mywindow.OnEvent(id,lparam,dparam,sparam);


   if(id== CHARTEVENT_OBJECT_CLICK)
     {
      //Print(id,"\\ ", lparam,"\\ ", dparam,"\\ ", sparam);

      string property = ObjectGetString(0,sparam,OBJPROP_TEXT);
      // Print(id,"\\ ", lparam,"\\ ", dparam,"\\ ", sparam, "\\", property);

      for(int kk=0; kk< ArraySize(groupStock); kk++)
        {

         if(property == groupStock[kk])
           {
            //bool a= ChartSetSymbolPeriod(0,property,PERIOD_CURRENT);
            SymbolSelect(property,true);
            ChartOpen(property,PERIOD_D1);

            // Print("set chart");
            //Print(a);

           }
        }


     }

  }
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string exclude_name_from_path(string path, int x_tadil0)
  {

   string result[];
   int k=StringSplit(path,'\\',result);

//Print(result[0],"--  ",result[1],"--  ",result[2],"--  ",result[3]);
   string result_add="";
   
   for(int j=x_tadil0; j<(k-1); j++)
     {
      StringAdd(result_add,"\\");
      StringAdd(result_add,result[j]);
     }
// Print(result_add);
   return result_add;

  }
//+------------------------------------------------------------------+
