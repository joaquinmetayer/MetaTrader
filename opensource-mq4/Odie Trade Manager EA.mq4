
#property copyright "Copyright 2021, Joaquin Metayer."
#property link      "https://www.mql5.com/en/users/joaquinmetayer/seller"
#property version   "1.00"
#property strict

enum TradeModeEnum
{
  Martingale = 0,
  Hedging = 1
};

input TradeModeEnum TradeMode = 0; //Trade Mode
input double Multiplier1 = 2;       //Martingale multiplier
input double Distance1 = 100;       //Martingale distance in points
input double AverageProfit1 = 100;  //Martingale average profit in points
input double Multiplier2 = 3;    //Hedging multiplier
input double Distance2 = 100;    //Hedging distance in points
input double TakeProfit2 = 100;  //Hedging take Profitin points
input double BreakEven = 50;     //Breakeven in points (0 will not use function)
input double BreakDistance = 10; //Breakeven distancein points
input double TraillingStop = 0;  //Trailling stop in points (0 will not use function)
input double TraillingStep = 0;  //Trailling step in points  

int Slippage = 5;
input int MagicNumber = 136518; //Magic number
string EAComment = "2388HC";

string prefix = "";


input bool ButtonShow_Enble = true; //Show trade button
input double    ButtonLot = "1"; //Button lot size
input int X1 = 100; //X
input int Y1 = 30; // Y


//按钮大小
 int        ButtonWight = 50; //Button Wight
int              ButtonHight = 20;       //Button Hight

//字体设置
ENUM_BASE_CORNER ButtonCorner=CORNER_RIGHT_UPPER;  // Chart corner for anchoring
string           ButtonFont="Arial";              // 字体
int              ButtonFontSize= 8;               // 字体大小
color            ButtonColor= clrBlack;           // 文本颜色
color            ButtonBackColor = clrGold;

//相关按钮属性设置
color            ButtonBorderColor=clrNONE;       // 边界颜色
bool             ButtonState=false;               // Pressed/Released是按下状态还是弹起状态
bool             ButtonBack= true;                // 背景对象是否透明
bool             ButtonSelection=false;           // 是否可以移动
bool             ButtonHidden= false;             // Hidden in the object list
long             ButtonZOrder=0;                  // 鼠标单击的优先级
long             chart_ID = 0;                    //0表示当前窗口ID

string ButtonName1 = "ButtonName1";
string ButtonName2 = "ButtonName2";


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   prefix = Symbol() + TimeCurrent();
   
   if(ButtonShow_Enble)
   {
    string ButtonText = "Buy";
   ButtonCreate(chart_ID,prefix + ButtonName1,0,X1,Y1,ButtonWight,ButtonHight,ButtonCorner,ButtonText,ButtonFont,
                   ButtonFontSize,ButtonColor,clrGreen,ButtonBorderColor,ButtonState,ButtonBack,ButtonSelection,ButtonHidden,ButtonZOrder);
  
    ButtonText = "Sell";
//---
   ButtonCreate(chart_ID,prefix + ButtonName2,0,X1 + ButtonWight + 20,Y1,ButtonWight,ButtonHight,ButtonCorner,ButtonText,ButtonFont,
                   ButtonFontSize,ButtonColor,clrRed,ButtonBorderColor,ButtonState,ButtonBack,ButtonSelection,ButtonHidden,ButtonZOrder);

   }

//---
   return(INIT_SUCCEEDED);
  }
  
void OnChartEvent(const int id,            //事件标识符
                  const long &lparam,      //事件长整型参量
                  const double &dparam,    //事件双精度型参量
                  const string &sparam)    //事件字符串型参量
{ 
   string  trailingstopcomment = "2388HC";
//--- 鼠标点击图形物件
   if(id==CHARTEVENT_OBJECT_CLICK)
   {
     
     //Print("The mouse has been clicked on the object with name '"+sparam+"'"); 
     if(sparam == prefix+ButtonName1)
     {
       Sleep(10);
       ObjectSetInteger(chart_ID,sparam,OBJPROP_STATE, false); //恢复按钮弹起状态
       MarketOrder(Symbol(),OP_BUY,ButtonLot,0,0,Slippage,0,"");
     }
     else if(sparam == prefix+ButtonName2)
     {
       Sleep(10);
       ObjectSetInteger(chart_ID,sparam,OBJPROP_STATE, false); //恢复按钮弹起状态
       MarketOrder(Symbol(),OP_SELL,ButtonLot,0,0,Slippage,0,"");
     }
   }
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
     DeleteGlobalVariables();
     DeleteAllObject();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  if(ObjectGetInteger(0,prefix + ButtonName1,OBJPROP_STATE))
  {
    Sleep(10);
    ObjectSetInteger(chart_ID,prefix + ButtonName1,OBJPROP_STATE, false); //恢复按钮弹起状态
    MarketOrder(Symbol(),OP_BUY,ButtonLot,0,0,Slippage,0,"");
  }
  else if(ObjectGetInteger(0,prefix + ButtonName2,OBJPROP_STATE))
  {
    Sleep(10);
    ObjectSetInteger(chart_ID,prefix + ButtonName2,OBJPROP_STATE, false); //恢复按钮弹起状态
    MarketOrder(Symbol(),OP_SELL,ButtonLot,0,0,Slippage,0,"");
  }
  
  CloseByProfitByMode1();
  CloseByProfitByMode2();
  TrailingStopFuntion();
//---
  if(!HandleTradingEnvironment())
  {
    return;
  }
  double lot = 0;
  double openprice = 0;
  
  double pendinglot = 0;
  double pendingopenprice = 0;
  double stoploss = 0;
  double takeprofit = 0;
  int ticket = 0;
  
  if(TradeMode == 0) // 
  {
    for(int i=0;i < OrdersTotal();i++)
    {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true
       && OrderSymbol() ==  Symbol()
       && OrderMagicNumber() != MagicNumber 
       && OrderType() <= OP_SELL)
      {
        stoploss = 0;
        takeprofit = 0;
        
        lot = OrderLots();
        ticket = OrderTicket();
        EAComment = "2388HC";
        openprice = OrderOpenPrice();
        if(OrderType() == OP_BUY)
        {
          if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) <= 0
           && CountNumber(Symbol(),OP_BUYLIMIT,MagicNumber,EAComment) <= 0
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            pendinglot = GetFirstLot(lot, Multiplier1);
            pendingopenprice = openprice - Distance1 * _Point;
            PendingOrder(Symbol(),OP_BUYLIMIT,pendinglot,pendingopenprice,stoploss,takeprofit,MagicNumber,EAComment);
          }
          else if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) > 0
           && CountNumber(Symbol(),OP_BUYLIMIT,MagicNumber,EAComment) <= 0
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            pendinglot = GetLot(Symbol(),OP_BUY,MagicNumber,EAComment,Multiplier1);
            pendingopenprice = GetLastPositionOpenPrice(Symbol(),OP_BUY,MagicNumber,EAComment) - Distance1 * _Point;
            PendingOrder(Symbol(),OP_BUYLIMIT,pendinglot,pendingopenprice,stoploss,takeprofit,MagicNumber,EAComment);
          } 
        }
        else if(OrderType() == OP_SELL)
        {
          if(CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) <= 0
           && CountNumber(Symbol(),OP_SELLLIMIT,MagicNumber,EAComment) <= 0
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            pendinglot = GetFirstLot(lot, Multiplier1);
            pendingopenprice = openprice + Distance1 * _Point;
            PendingOrder(Symbol(),OP_SELLLIMIT,pendinglot,pendingopenprice,stoploss,takeprofit,MagicNumber,EAComment);
          }
          else if(CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) > 0
           && CountNumber(Symbol(),OP_SELLLIMIT,MagicNumber,EAComment) <= 0
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            pendinglot = GetLot(Symbol(),OP_SELL,MagicNumber,EAComment,Multiplier1);
            pendingopenprice = GetLastPositionOpenPrice(Symbol(),OP_SELL,MagicNumber,EAComment) + Distance1 * _Point;
            PendingOrder(Symbol(),OP_SELLLIMIT,pendinglot,pendingopenprice,stoploss,takeprofit,MagicNumber,EAComment);
          } 
        } 
      }
    }
  }
  else  //if(TradeMode == 1) Hedging
  {
     for(int i = 0;i < OrdersTotal();i++)
     {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true
        && OrderSymbol() ==  Symbol()
        && OrderMagicNumber() != MagicNumber 
        && OrderType() <= OP_SELL)
       {
         stoploss = 0;
         takeprofit = 0;
         lot = OrderLots();
         ticket = OrderTicket();
         EAComment = "2388HC";
         openprice = OrderOpenPrice();
         stoploss = OrderStopLoss();
         takeprofit = OrderTakeProfit();
                  
         double takeprofit_fix = "";

         bool flag = false;
         
         if(OrderType() == OP_BUY)
         {
           takeprofit = 0;
           takeprofit_fix = 0;
           
           if(OrderTakeProfit() - takeprofit != 0)
           {
             OrderModify(ticket,openprice,stoploss,takeprofit,0,clrNONE);
           }
           
           if(CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) <= 0
            && openprice - Bid >= Distance2 * _Point)  //对冲订单
           {
             pendinglot = GetFirstLot(lot,Multiplier2);
             stoploss = 0;  
             takeprofit = 0;
             flag = MarketOrder(Symbol(),OP_SELL,pendinglot,stoploss,takeprofit,Slippage,MagicNumber,EAComment);
             if(flag == true)
             {
               if(!OrderModify(ticket,openprice,GetLastPositionTakeProfit(Symbol(),OP_SELL,MagicNumber,EAComment),
                 takeprofit_fix,0,clrNONE))
               {
                 Print("Modify failed!");
               }
             } 
           }
           else if(CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) > 0)  //对冲订单
           {
             if(GetLastPositionType(Symbol(),MagicNumber,EAComment) == OP_BUY)
             {
               openprice = GetLastPositionOpenPrice(Symbol(),OP_BUY,MagicNumber,EAComment);
               lot = GetLastPositionLot(Symbol(),OP_BUY,MagicNumber,EAComment);
               pendinglot = GetFirstLot(lot,Multiplier2);
               
               if(openprice - Bid >=  Distance2 * _Point)
               {
                 takeprofit = 0;
                 stoploss = 0;
                 MarketOrder(Symbol(),OP_SELL,pendinglot,stoploss,takeprofit,Slippage,MagicNumber,EAComment);
               }
             }
             else if(GetLastPositionType(Symbol(),MagicNumber,EAComment) == OP_SELL)
             {
               openprice = GetLastPositionOpenPrice(Symbol(),OP_SELL,MagicNumber,EAComment);
               lot = GetLastPositionLot(Symbol(),OP_SELL,MagicNumber,EAComment);
               pendinglot = GetFirstLot(lot,Multiplier2);
               if(Ask - openprice >=  Distance2 * _Point)
               {
                 takeprofit = 0;
                 stoploss = 0;
                 MarketOrder(Symbol(),OP_BUY,pendinglot,stoploss,takeprofit,Slippage,MagicNumber,EAComment);
               }
             }
           }
         } // op_buy
         if(OrderType() == OP_SELL)
         {
           takeprofit = 0;
           takeprofit_fix = 0;
           
           if(OrderTakeProfit() - takeprofit != 0)
           {
             OrderModify(ticket,openprice,stoploss,takeprofit,0,clrNONE);
           }
           
           if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) <= 0
            && Ask - openprice >= Distance2 * _Point)  //对冲订单
           {
             pendinglot = GetFirstLot(lot,Multiplier2);
             stoploss = 0;  
             takeprofit = 0;
             
             flag = MarketOrder(Symbol(),OP_BUY,pendinglot,stoploss,takeprofit,Slippage,MagicNumber,EAComment);
             if(flag == true)
             {
               if(!OrderModify(ticket,openprice,GetLastPositionTakeProfit(Symbol(),OP_BUY,MagicNumber,EAComment),
                 takeprofit_fix,0,clrNONE))
               {
                 Print("Modify failed!");
               }
             } 
           }
           else if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) > 0)  //对冲订单
           {
             if(GetLastPositionType(Symbol(),MagicNumber,EAComment) == OP_SELL)
             {
               openprice = GetLastPositionOpenPrice(Symbol(),OP_SELL,MagicNumber,EAComment);
               lot = GetLastPositionLot(Symbol(),OP_SELL,MagicNumber,EAComment);
               pendinglot = GetFirstLot(lot,Multiplier2);
               if(Ask - openprice >=  Distance2 * _Point)
               {
                 takeprofit = 0;
                 stoploss = 0;
                 MarketOrder(Symbol(),OP_BUY,pendinglot,stoploss,takeprofit,Slippage,MagicNumber,EAComment);
               }
               
             }
             else if(GetLastPositionType(Symbol(),MagicNumber,EAComment) == OP_BUY)
             {
               openprice = GetLastPositionOpenPrice(Symbol(),OP_BUY,MagicNumber,EAComment);
               lot = GetLastPositionLot(Symbol(),OP_BUY,MagicNumber,EAComment);
               pendinglot = GetFirstLot(lot,Multiplier2);
               if(openprice - Bid >=  Distance2 * _Point)
               {
                 takeprofit = 0;
                 stoploss = 0;
                 MarketOrder(Symbol(),OP_SELL,pendinglot,stoploss,takeprofit,Slippage,MagicNumber,EAComment);
               }
             }
           }
         }
       } // op_sell
     }
  }
}



void CloseByProfitByMode1()
{
  double lot = 0;
  double openprice = 0;
  double stoploss = 0;
  double takeprofit = 0;
  int ticket = 0;
  int type = -1;
  
  if(TradeMode == 0)
  {
    for(int i = 0;i < OrdersTotal();i++)
    {
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true
       && OrderSymbol() ==  Symbol()
       && OrderMagicNumber() != MagicNumber 
       && OrderType() <= OP_SELL)
    {
      lot = OrderLots();
      ticket = OrderTicket();
      EAComment = "2388HC";
      openprice = OrderOpenPrice();
      takeprofit = OrderTakeProfit();
      if(OrderType() == OP_BUY)
      {
        if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) > 0)
        {
          if(GetLastPositionProfit(Symbol(),OP_BUY,MagicNumber,EAComment) >= AverageProfit1 * _Point)
          {
            MarketOrderClose(Symbol(),OP_BUY,MagicNumber,EAComment);
            MarketOrderClose(Symbol(),OP_BUYLIMIT,MagicNumber,EAComment);
            MarketCloseTicket(ticket);
          }
        }
        else if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) <= 0)
        {
          if(BreakEven > 0 
           && Bid - openprice >= BreakEven * _Point
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            stoploss = openprice + BreakDistance * _Point;
            if(OrderModify(ticket,openprice,stoploss,takeprofit,0,clrNONE))
            {
              GVSet("Do break" + IntegerToString(ticket),Bid);
              MarketOrderClose(Symbol(),OP_BUYLIMIT,MagicNumber,EAComment);
            }
          }
        }
      }  // op_buy
      else if(OrderType() == OP_SELL)
      {
        if(CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) > 0)
        {
          if(GetLastPositionProfit(Symbol(),OP_SELL,MagicNumber,EAComment) >= AverageProfit1 * _Point)
          {
            MarketOrderClose(Symbol(),OP_SELL,MagicNumber,EAComment);
            MarketOrderClose(Symbol(),OP_SELLLIMIT,MagicNumber,EAComment);
            MarketCloseTicket(ticket);
          }
        }
        else if(CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) <= 0)
        {
          if(BreakEven > 0 
           && openprice - Ask >= BreakEven * _Point
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            stoploss = openprice - BreakDistance * _Point;
            if(OrderModify(ticket,openprice,stoploss,takeprofit,0,clrNONE))
            {
              GVSet("Do break" + IntegerToString(ticket),Bid);
              MarketOrderClose(Symbol(),OP_SELLLIMIT,MagicNumber,EAComment);
            }
          }
        }
      }
    }
   }
 }
}

void CloseByProfitByMode2()
{
  double lot = 0;
  double openprice = 0;
  double stoploss = 0;
  double takeprofit = 0;
  int ticket = 0;
  int type = -1;
  
  if(TradeMode == 1)
  {
    for(int i = 0;i < OrdersTotal();i++)
    {
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true
       && OrderSymbol() ==  Symbol()
       && OrderMagicNumber() != MagicNumber 
       && OrderType() <= OP_SELL)
    {
      lot = OrderLots();
      ticket = OrderTicket();
      EAComment = "2388HC";
      openprice = OrderOpenPrice();
      takeprofit = OrderTakeProfit();
      
      if(OrderType() == OP_BUY)
      {
        if(GetLastPositionProfit_Hedging(Symbol(),MagicNumber,EAComment) >= TakeProfit2 * _Point
          || Bid - openprice >= TakeProfit2 * _Point)
        {
            MarketOrderClose(Symbol(),OP_BUY,MagicNumber,EAComment);
            MarketOrderClose(Symbol(),OP_SELL,MagicNumber,EAComment);
            MarketCloseTicket(ticket);
        }
        
        if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) <= 0
         && CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) <= 0)
        {
          if(BreakEven > 0 
           && (Bid - openprice) >= BreakEven * _Point
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            stoploss = openprice + BreakDistance * _Point;
            if(OrderModify(ticket,openprice,stoploss,takeprofit,0,clrNONE))
            {
              GVSet("Do break" + IntegerToString(ticket),Bid);
              MarketOrderClose(Symbol(),OP_BUYLIMIT,MagicNumber,EAComment);
            }
          }
        }
      }  // op_buy
      else if(OrderType() == OP_SELL)
      {
        if(GetLastPositionProfit_Hedging(Symbol(),MagicNumber,EAComment) >= TakeProfit2 * _Point
          ||  (openprice  - Ask) >= TakeProfit2 * _Point)
        {
            MarketOrderClose(Symbol(),OP_BUY,MagicNumber,EAComment);
            MarketOrderClose(Symbol(),OP_SELL,MagicNumber,EAComment);
            MarketCloseTicket(ticket);
        }
        
        else if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) <= 0
         && CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) <= 0)
        {
          if(BreakEven > 0 
           && (openprice - Ask) >= BreakEven * _Point
           && GVGet("Do break" + IntegerToString(ticket)) <= 0)
          {
            stoploss = openprice - BreakDistance * _Point;
            if(OrderModify(ticket,openprice,stoploss,takeprofit,0,clrNONE))
            {
              GVSet("Do break" + IntegerToString(ticket),Bid);
              MarketOrderClose(Symbol(),OP_SELLLIMIT,MagicNumber,EAComment);
            }
          }
        }
      }
    }
   }
 }
}


int GetLastPositionType(string inSymbol,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double profit =0;
   int type = -1;
   for(int i = 0;i < OrdersTotal();i++)
   {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     type = OrderType();
   }
   return(type);
}

double GetLastPositionProfit_Hedging(string inSymbol,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double profit =0;
   for(int i = 0;i < OrdersTotal();i++)
   {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment
         && OrderType() <= OP_SELL)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     if(OrderType() == OP_BUY)
     {
       profit = Bid - OrderOpenPrice();
     }
     else if(OrderType() == OP_SELL)
     {
       profit = OrderOpenPrice() - Ask;
     }
   }
   return(profit);
}


double GetLastPositionProfit(string inSymbol,int inType,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double profit =0;
   for(int i = 0;i < OrdersTotal();i++)
   {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment
         && OrderType() == inType)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     if(OrderType() == OP_BUY)
     {
       profit = Bid - OrderOpenPrice();
     }
     else if(OrderType() == OP_SELL)
     {
       profit = OrderOpenPrice() - Ask;
     }
   }
   return(profit);
}

//+------------------------------------------------------------------+
double GetFirstLot(double inLot,double inMultiple)
{
  double lot = 0;
  lot = inLot * inMultiple;
  
  double   min_lot     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
  double   max_lot     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
  int lotdigits = 0;
  if(StringFind(min_lot,".",0) < 0)
  { 
    lotdigits = 0; 
  }
  else 
  { 
    lotdigits = (StringLen(min_lot) - (StringFind(min_lot,".",0) + 1)); 
  }
  double   lots        = 0;
  lots = NormalizeDouble(lot, lotdigits);
  if (lots < min_lot) lots = min_lot;
  if (lots > max_lot) lots = max_lot;
  return lots;
}


double GetLot(string inSymbol,int inType,int inMagicNumber,string inComment,double inMultiple)
{
  double lot = 0;
  lot = GetLastPositionLot(inSymbol,inType,inMagicNumber,inComment) * inMultiple;
  
  double   min_lot     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
  double   max_lot     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
  int lotdigits = 0;
  if(StringFind(min_lot,".",0) < 0)
  { 
    lotdigits = 0; 
  }
  else 
  { 
    lotdigits = (StringLen(min_lot) - (StringFind(min_lot,".",0) + 1)); 
  }
  double   lots        = 0;
  lots = NormalizeDouble(lot, lotdigits);
  if (lots < min_lot) lots = min_lot;
  if (lots > max_lot) lots = max_lot;
  return lots;
}



double GetLastPositionLot(string inSymbol,int inType,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double lot =0;
   for(int i = 0;i < OrdersTotal();i++)
   {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment
         && OrderType() == inType)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     lot = OrderLots();
   }
   return(lot);
}

double GetLastPositionOpenPrice(string inSymbol,int inType,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double openprice =0;
   for(int i = 0;i < OrdersTotal();i++)
   {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment
         && OrderType() == inType)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     openprice = OrderOpenPrice();
   }
   return(openprice);
}

double GetLastPositionTakeProfit(string inSymbol,int inType,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double takeprofit =0;
   for(int i = 0;i < OrdersTotal();i++)
   {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment
         && OrderType() == inType)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     takeprofit = OrderTakeProfit();
   }
   return(takeprofit);
}

double GetLastPositionStopLoss(string inSymbol,int inType,int inMagicNumber,string inComment)
{
   int Ticket = -1;
   datetime opentime = 0;
   double stoploss =0;
   for(int i = 0;i < OrdersTotal();i++)
   {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true 
         && OrderSymbol() == inSymbol
         && OrderMagicNumber() == inMagicNumber 
         && OrderComment() == inComment
         && OrderType() == inType)
         {
            if(OrderOpenTime() > opentime)
            {
               Ticket = OrderTicket();
               opentime = OrderOpenTime();
            }
         }
    }

   if(OrderSelect(Ticket,SELECT_BY_TICKET))
   {
     stoploss = OrderStopLoss();
   }
   return(stoploss);
}

double GetStopLoss(string inSymbol,int inType, int inSL)
{
  double mystoploss = 0;
  if(inType == OP_BUY)
  {
    if(inSL > 0)
    {
       mystoploss = SymbolInfoDouble(inSymbol,SYMBOL_ASK) - inSL  * GetPoint(inSymbol);
    }
    else
    {
      mystoploss = 0;
    }
  }
  else if(inType == OP_SELL)
  {
    if(inSL > 0)
    {
       mystoploss = SymbolInfoDouble(inSymbol,SYMBOL_BID) + inSL * GetPoint(inSymbol);
    }
    else
    {
      mystoploss = 0;
    }
  }
  return mystoploss;
}

double GetTakeProfit(string inSymbol,int inType, int inTP)
{
  double mytakeprofit = 0;
  if(inType == OP_BUY)
  {
    if(inTP > 0)
    {
       mytakeprofit = SymbolInfoDouble(inSymbol,SYMBOL_ASK) + inTP *  GetPoint(inSymbol);
    }
    else
    {
      mytakeprofit = 0;
    }
  }
  else if(inType == OP_SELL)
  {
    if(inTP > 0)
    {
      mytakeprofit = SymbolInfoDouble(inSymbol,SYMBOL_BID) - inTP  *  GetPoint(inSymbol);
    }
    else
    {
      mytakeprofit = 0;
    }
  }
  return mytakeprofit;
}

bool PendingOrder(string inSymbol,int inType, double inLot, double inOpenPrice,double inSL,double inTP,int inMagicNumber, string inComment)
{
  double mystoploss = 0;
  double mytakeprofit = 0;
  double myopenprice = 0;
  color opencolor = NULL;
 
  myopenprice = inOpenPrice;
  mystoploss = inSL;
  mytakeprofit = inTP;

  if(inType == OP_BUYLIMIT || inType == OP_BUYSTOP)
  {
    opencolor = clrBlue; 
  }
  else if(inType == OP_SELLLIMIT  || inType == OP_SELLSTOP)
  {
    opencolor = clrRed; 
  }
  
  int ticket = OrderSend(inSymbol,inType,inLot,myopenprice,Slippage,mystoploss,mytakeprofit,inComment,inMagicNumber,0,opencolor);
  if(ticket <= 0)
  {
    Print("Pending order open failed, Error reason:", GetLastError());
    return false;
  }
  else
  {
    return true;
  }
}


//+------------------------------------------------------------------+
bool MarketOrder(string inSymbol,int inType,double inLot,double inStopLoss, double inTakeProfit,int inSlippage, int inMagicNumber,string inComment)
{
  double mystoploss = 0;
  double mytakeprofit = 0;
  double myopenprice = 0;
  color opencolor = NULL;
  if(inType == OP_BUY)
  {
    myopenprice = SymbolInfoDouble(inSymbol,SYMBOL_ASK);
    opencolor = clrBlue;
  }
  else if(inType == OP_SELL)
  {
    myopenprice = SymbolInfoDouble(inSymbol,SYMBOL_BID);
    opencolor = clrRed;
  }
  mystoploss = inStopLoss;
  mytakeprofit = inTakeProfit;
  
  int ticket = OrderSend(inSymbol,inType,inLot,myopenprice,inSlippage,0,0,inComment,inMagicNumber,0,opencolor);
  if(ticket <= 0)
  {
    Print("Order open failed, Error reason:", GetLastError());
    return false;
  }
  else 
  {
    if(mystoploss > 0 || mytakeprofit > 0)
    {
      if(OrderSelect(ticket,SELECT_BY_TICKET))
      {
        OrderModify(ticket,OrderOpenPrice(),mystoploss,mytakeprofit,0,clrNONE);
      }
    }
    return true;
  }
}

//对指定订单平仓
void MarketCloseTicket(int inTicket)
{
  int number = 0;
  string symbol = "";
  while(true)
  {
    if(OrderSelect(inTicket,SELECT_BY_TICKET,MODE_TRADES))
    {
      symbol = OrderSymbol();
      if(OrderType() == OP_BUY)
      {
        if(!OrderClose(inTicket,OrderLots(),SymbolInfoDouble(symbol,SYMBOL_BID),Slippage,clrNONE))
        {
          Print("Close order failed, error:",GetLastError());
        }
        else
        {
          break;
        }
      }
      else if(OrderType() == OP_SELL)
      {
        if(!OrderClose(inTicket,OrderLots(),SymbolInfoDouble(symbol,SYMBOL_ASK),Slippage,clrNONE))
        {
          Print("Close order failed, error:",GetLastError());
        }
        else
        {
          break;
        }
      }
      else if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP
              || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP)
      {
        if(!OrderDelete(inTicket,clrNONE))
        {
          Print("Close order failed, error:",GetLastError());
        }
        else
        {
          break;
        }
      }
    }
    number++;
    if(number > 50)
    {
      break;
    }
  }
}

double GetPoint(string inSymbol)
{
  double value = SymbolInfoDouble(inSymbol,SYMBOL_POINT);
  return value;
}


int GetSignal()
{
  int signal = 9;

   return signal;
}


void DeleteGlobalVariables()
{
   for(int tries = 0; tries < 10; tries++)
     {
      int obj = GlobalVariablesTotal();
      for(int o = 0; o < obj;o++)
        {
         string name = GlobalVariableName(o);
         int index = StringFind(name,prefix,0);
         if(index > -1)
         {
            GlobalVariableDel(name);
         }
        }
     }
}


double GVGet(string name)
{
   return(GlobalVariableGet(prefix+name));
}

datetime GVSet(string name, double value)
{
   return(GlobalVariableSet(prefix+name, value));
}

bool IsNewBar(string inSymbol,ENUM_TIMEFRAMES inTimeFrame)
{
   if((iTime(inSymbol,inTimeFrame,0) - GVGet(inSymbol + "IsNewBar" + GetPeriod(inTimeFrame)) != 0))
   {
      GVSet(inSymbol + "IsNewBar" + GetPeriod(inTimeFrame),iTime(inSymbol,inTimeFrame,0));
      return(true);
   }
   else return(false);
}

void MarketOrderClose(string inSymbol,int inType,int inMagic,string inComment)
{
  int number = 0;
  while(true)
  {
    for(int i=0;i < OrdersTotal();i++)
    {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true
       && OrderSymbol() == inSymbol 
       && OrderMagicNumber() == inMagic 
       && OrderType() == inType
       && OrderComment() == EAComment)
      {
        if(inType == OP_BUY)
        {
          if(!OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(inSymbol,SYMBOL_BID),Slippage,clrNONE))
          {
            Print("Close order failed, error:",GetLastError());
          }
        }
        else if(inType == OP_SELL)
        {
          if(!OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(inSymbol,SYMBOL_ASK),Slippage,clrNONE))
          {
            Print("Close order failed, error:",GetLastError());
          }
        }
        else if(inType == OP_BUYLIMIT || inType == OP_BUYSTOP
              || inType == OP_SELLLIMIT || inType == OP_SELLSTOP)
        {
          if(!OrderDelete(OrderTicket(),clrNONE))
          {
            Print("Close order failed, error:",GetLastError());
          }
        }
      }
    }
    number++;
    if(number > 50)
    {
      break;
    }
  }
}

int CountNumber(string inSymbol,int inType,int inMagicNumber,string inComment)
{
  int number = 0;
  for(int i = 0;i < OrdersTotal();i++)
  {
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) 
      && OrderSymbol() == inSymbol 
      && OrderMagicNumber() == inMagicNumber 
      && OrderComment() == inComment
      && OrderType() == inType)
    {
      number++;
    }
  }

  return number;
}

/*
*检查市场运行环境，是否可以下单
*/
bool HandleTradingEnvironment()
{
   
   if(!IsConnected())
   {
      Print("Terminal is not connected to server...");
      return(false);
   }
   
   if(!IsTradeAllowed() && !IsTradeContextBusy())
   {
     Print("Trade is not alowed for some reason...");
   }
   if(IsConnected() && !IsTradeAllowed())
   {
      while(IsTradeContextBusy())
      {
         Print("Trading context is busy... Will wait a bit...");
         Sleep(100); //睡眠300毫秒
      }
   }
   if(IsTradeAllowed())
   {
      RefreshRates();
      return(true);
   }
   else
   {
     Print("Trading is not allow... Please click auto trading...");
     return(false);
   }  
}

	
string GetPeriod(int inTimeFrame)
{
  string timeframe = "";
  if(inTimeFrame == PERIOD_CURRENT)
  {
    inTimeFrame = Period();
  }

  if(inTimeFrame == PERIOD_M1)
  {
    timeframe = "M1";
  }
  else if(inTimeFrame == PERIOD_M5)
  {
    timeframe = "M5";
  }
  else if(inTimeFrame == PERIOD_M15)
  {
    timeframe = "M15";
  }
  else if(inTimeFrame == PERIOD_M30)
  {
    timeframe = "M30";
  }
  else if(inTimeFrame == PERIOD_H1)
  {
    timeframe = "H1";
  }
  else if(inTimeFrame == PERIOD_H4)
  {
    timeframe = "H4";
  }
  else if(inTimeFrame == PERIOD_D1)
  {
    timeframe = "D1";
  }
  else if(inTimeFrame == PERIOD_W1)
  {
    timeframe = "W1";
  }
  else if(inTimeFrame == PERIOD_MN1)
  {
    timeframe = "MN1";
  }
  return timeframe;
}

void TrailingStopFuntion()
{
  if(TraillingStop <= 0)
  {
    return;
  }
  for(int i=0; i < OrdersTotal(); i++)
  {
     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true
        && OrderSymbol() == Symbol() 
        && OrderMagicNumber() != MagicNumber
        && OrderType() <= OP_SELL)
     {
       int ticket = OrderTicket();
       EAComment = IntegerToString(ticket);
       if(CountNumber(Symbol(),OP_BUY,MagicNumber,EAComment) > 0
        || CountNumber(Symbol(),OP_SELL,MagicNumber,EAComment) > 0)
       {
         continue;
       }
       TrailingStopOne(ticket,Symbol(),TraillingStop,TraillingStep);
     }
  }
}

void TrailingStopOne(int Ticket,string inSymbol,double inTrailingStop,double inTrailingStep)
{
   if(OrderSelect(Ticket,SELECT_BY_TICKET) == true && OrderCloseTime() == 0)
   {
      bool Modify = false;
      RefreshRates();
      if(OrderType() == OP_BUY && GVGet(IntegerToString(Ticket) + "trailling stop") <= 0
         && (SymbolInfoDouble(inSymbol,SYMBOL_BID) - OrderOpenPrice()) >= (inTrailingStop   * GetPoint(inSymbol)))
      {
        if(OrderTakeProfit() > 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),OrderOpenPrice() + inTrailingStep * GetPoint(inSymbol),OrderTakeProfit(),0,CLR_NONE);
        }
        else if(OrderTakeProfit() == 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),OrderOpenPrice() + inTrailingStep * GetPoint(inSymbol),0,0,CLR_NONE);
        }
        
         if(!Modify)
         {
            Print("EUnexpected Error has happened. Error Description: ", GetLastError());
         }
         else if(Modify)
         { 
           GVSet(IntegerToString(Ticket) + "trailling stop", SymbolInfoDouble(inSymbol,SYMBOL_BID));
           Print("Order successfully modified.");
         }
      }
      else if(OrderType() == OP_BUY && GVGet(IntegerToString(Ticket) + "trailling stop") > 0
         && (SymbolInfoDouble(inSymbol,SYMBOL_BID) - GVGet(IntegerToString(Ticket) + "trailling stop")) >= inTrailingStep * GetPoint(inSymbol))
      {  
         if(OrderStopLoss() == 0)
         {
           GVSet(IntegerToString(Ticket) + "trailling stop",0);
           return;
         }
         if(OrderTakeProfit() > 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),NormalizeDouble(OrderStopLoss() + inTrailingStep  * GetPoint(inSymbol),SymbolInfoInteger(inSymbol,SYMBOL_DIGITS)),OrderTakeProfit(),0,CLR_NONE);
        }
        else if(OrderTakeProfit() == 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),NormalizeDouble(OrderStopLoss() +  inTrailingStep  * GetPoint(inSymbol),SymbolInfoInteger(inSymbol,SYMBOL_DIGITS)),0,0,CLR_NONE);
        }
         
         if(!Modify)
         {
            Print("Unexpected Error has happened. Error Description: ",GetLastError());
         }
         else if(Modify)
         {
           GVSet(IntegerToString(Ticket) + "trailling stop",SymbolInfoDouble(inSymbol,SYMBOL_BID));
           Print("Order successfully modified.");
         }
      }
      
      if(OrderType() == OP_SELL && GVGet(IntegerToString(Ticket) + "trailling stop") <= 0
         && (OrderOpenPrice() - SymbolInfoDouble(inSymbol,SYMBOL_ASK)) >= (inTrailingStop   * GetPoint(inSymbol)))
      {
        if(OrderTakeProfit() > 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),OrderOpenPrice() - inTrailingStep  * GetPoint(inSymbol),OrderTakeProfit(),0,CLR_NONE);
        }
        if(OrderTakeProfit() == 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(), OrderOpenPrice() - inTrailingStep * GetPoint(inSymbol),0,0,CLR_NONE);
        }
        
         if(!Modify)
         {
            Print("EUnexpected Error has happened. Error Description: ", GetLastError());
         }
         if(Modify)
         { 
           GVSet(IntegerToString(Ticket) + "trailling stop", SymbolInfoDouble(inSymbol,SYMBOL_ASK));
           Print("Order successfully modified.");
         }
      }
      else if(OrderType() == OP_SELL && GVGet(IntegerToString(Ticket) + "trailling stop") > 0
         && (GVGet(IntegerToString(Ticket) + "trailling stop") - SymbolInfoDouble(inSymbol,SYMBOL_ASK)) >= inTrailingStep  * GetPoint(inSymbol))
      {  
         if(OrderStopLoss() == 0)
         {
           GVSet(IntegerToString(Ticket) + "trailling stop",0);
           return;
         }
         if(OrderTakeProfit() > 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),OrderStopLoss() - inTrailingStep  * GetPoint(inSymbol),OrderTakeProfit(),0,CLR_NONE);
        }
        if(OrderTakeProfit() == 0)
        {
          Modify = OrderModify(Ticket,OrderOpenPrice(),OrderStopLoss() -  inTrailingStep  * GetPoint(inSymbol),0,0,CLR_NONE);
        }
         if(!Modify)
         {
            Print("Unexpected Error has happened. Error Description: ",GetLastError());
         }
         if(Modify)
         {
           GVSet(IntegerToString(Ticket) + "trailling stop",SymbolInfoDouble(inSymbol,SYMBOL_ASK));
           Print("Order successfully modified.");
         }
      }
   }
}




bool ButtonCreate(const long              inchart_ID = 0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=30,                 // button width
                  const int               height=8,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr= clrRed,         // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden = true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
   //--- reset the error value
   ResetLastError();
   //--- create the button
    //先判断当前是否存在该对象按钮，如果存在，删除、再创建
  
    if(!ObjectCreate(name,OBJ_BUTTON,sub_window,0,0))
     {
     // Print(__FUNCTION__,
       //     ": failed to create the button! 错误编码 = ",GetLastError());
      return(false);
    }

   
   //以下是按钮额相关设置：包括位置，大小，背景颜色，字体大小等等
   //---设置按钮的位置
   ObjectSetInteger(inchart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(inchart_ID,name,OBJPROP_YDISTANCE,y);
  //--- set button size
   ObjectSetInteger(inchart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(inchart_ID,name,OBJPROP_YSIZE,height);
  
   //设置图表的角，相对于哪个点坐标的定义
   ObjectSetInteger(inchart_ID,name,OBJPROP_CORNER,corner);
   //--- set the text
   ObjectSetString(inchart_ID,name,OBJPROP_TEXT,text);
  //--- set text font
   ObjectSetString(inchart_ID,name,OBJPROP_FONT,font);
  //--- set font size
   ObjectSetInteger(inchart_ID,name,OBJPROP_FONTSIZE,font_size);
   //--- set text color
   ObjectSetInteger(inchart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(inchart_ID,name,OBJPROP_BGCOLOR,back_clr);
   //--- set border color
   ObjectSetInteger(inchart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(inchart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(inchart_ID,name,OBJPROP_STATE,state);
//--- 启用（true）或禁用（false）鼠标移动按钮的模式
   ObjectSetInteger(inchart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(inchart_ID,name,OBJPROP_SELECTED,selection);
//--- 隐藏（true）或显示（false）对象列表中的图形对象名
   ObjectSetInteger(inchart_ID,name,OBJPROP_HIDDEN,hidden);
//--- 设置在图表中接收鼠标单击事件的优先级 
   ObjectSetInteger(inchart_ID,name,OBJPROP_ZORDER,z_order);
   return(true);
}




void DeleteAllObject()
{
  for(int tries = 0; tries < 10; tries++)
  {
    int obj = ObjectsTotal();
    for(int o = 0; o < obj;o++)
    {
      string name = ObjectName(o);
      int index = StringFind(name,prefix,0);
      if(index > -1)
      {
        ObjectDelete(name);
      }
    }
  }
}


