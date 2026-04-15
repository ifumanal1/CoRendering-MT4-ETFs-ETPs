//+------------------------------------------------------------------+
//|  EQQQ_Synth.mq4 — Synthetic EQQQ (1x long Nasdaq 100)            |
//|  Attach to USATec chart in MT4                                   |
//|  Author: Ignacio Fumanal-Andrés  —  v3.00                        |
//|  Date:   03/2026                                                 |
//|  License: MIT                                                    |
//+------------------------------------------------------------------+
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_label1  "EQQQ (1x)"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

input double Seed_EQQQ = 500.0; // Current REAL market price of EQQQ
input int    RebalHour = 21;    // 22:00 CET summer = 21:00 UTC

double g_EQQQ[];
bool   g_initialized = false;

int OnInit()
{
   SetIndexBuffer(0, g_EQQQ);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2, clrLime);
   IndicatorShortName("EQQQ 1x [seed="
      + DoubleToString(Seed_EQQQ, 2) + "]");
   ArraySetAsSeries(g_EQQQ, true);
   g_initialized = false;
   return(INIT_SUCCEEDED);
}

bool IsDayBoundary(int idx)
{
   datetime t_new = iTime(Symbol(), PERIOD_M1, idx);
   datetime t_old = iTime(Symbol(), PERIOD_M1, idx + 1);
   MqlDateTime dn, do_;
   TimeToStruct(t_new, dn); TimeToStruct(t_old, do_);
   if(dn.day \!= do_.day) return(true);
   if(do_.hour < RebalHour && dn.hour >= RebalHour) return(true);
   return(false);
}

int OnCalculate(const int rates_total, const int prev_calculated,
   const datetime &time[], const double &open[],
   const double &high[], const double &low[],
   const double &close[], const long &tick_volume[],
   const long &volume[], const int &spread[])
{
   int m1 = iBars(Symbol(), PERIOD_M1);
   if(m1 < 2) return(0);
   int n = MathMin(m1, rates_total);

   if(\!g_initialized)
   {
      g_EQQQ[0] = Seed_EQQQ;
      double be = Seed_EQQQ, bc = iClose(Symbol(), PERIOD_M1, 0);
      for(int i = 1; i < n; i++)
      {
         double ci = iClose(Symbol(), PERIOD_M1, i);
         if(ci <= 0.0) { g_EQQQ[i] = g_EQQQ[i-1]; continue; }
         if(IsDayBoundary(i-1))
            { be = g_EQQQ[i-1]; bc = iClose(Symbol(),PERIOD_M1,i-1); }
         if(bc <= 0.0) { g_EQQQ[i] = g_EQQQ[i-1]; continue; }
         g_EQQQ[i] = be * (ci / bc); // L=1
      }
      g_initialized = true; return(rates_total);
   }
   double cn = iClose(Symbol(), PERIOD_M1, 0);
   for(int k = 1; k < 1500; k++)
      if(IsDayBoundary(k))
      {
         double cb = iClose(Symbol(), PERIOD_M1, k);
         if(cb > 0.0 && cn > 0.0) g_EQQQ[0] = g_EQQQ[k] * (cn/cb);
         break;
      }
   return(rates_total);
}
