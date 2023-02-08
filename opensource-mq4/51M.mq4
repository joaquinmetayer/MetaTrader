#property strict #property version "1.0"
input int SH = 16; input int SM = 30; input int LS = 1; input int TP = 600;
input int S1 = 200; input int S2 = 400; bool OpenOrders = true;
void OnTick(){if (Hour() == SH && Minute() == SM && OpenOrders == true){
OrderSend(Symbol(), OP_BUY, LS, Ask, 3, Bid - S1 * Point, Bid + TP * Point);
OrderSend(Symbol(),OP_BUY, LS, Ask, 3, Bid - S2 * Point, Bid + TP * Point);
OrderSend(Symbol(), OP_BUY, LS, Ask, 3, Bid - TP * Point, Bid + TP * Point);
OrderSend(Symbol(), OP_SELL, LS, Bid, 3, Ask + S1 * Point, Ask - TP * Point);
OrderSend(Symbol(), OP_SELL, LS, Bid, 3, Ask + S2 * Point, Ask - TP * Point);
OrderSend(Symbol(), OP_SELL, LS, Bid, 3, Ask + TP * Point, Ask - TP * Point);
OpenOrders = false;}}