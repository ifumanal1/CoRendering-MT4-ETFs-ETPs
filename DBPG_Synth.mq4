//+------------------------------------------------------------------+
//|  DBPG_Synth.mq4 — Synthetic DBPG (2x long S&P 500)               |
//|  Attach to USA500 chart in MT4                                   |
//|  Author: Ignacio Fumanal-Andrés  —  v2.00                        |
//|  Date:   03/2026                                                 |
//|  License: MIT                                                    |
//+------------------------------------------------------------------+
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_label1  "DBPG (2x)"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

input double Seed_DBPG = 100.0; // Current REAL market price of DBPG
input int    RebalHour = 21;    // 22:00 CET summer = 21:00 UTC

double g_DBPG[];
bool   g_initialized = false;

int OnInit()
{
   SetIndexBuffer(0, g_DBPG);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2, clrDodgerBlue);
   IndicatorShortName("DBPG 2x [seed="
      + DoubleToString(Seed_DBPG, 2) + "]");
   ArraySetAsSeries(g_DBPG, true);
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
      g_DBPG[0] = Seed_DBPG;
      double be = Seed_DBPG, bc = iClose(Symbol(), PERIOD_M1, 0);
      for(int i = 1; i < n; i++)
      {
         double ci = iClose(Symbol(), PERIOD_M1, i);
         if(ci <= 0.0) { g_DBPG[i] = g_DBPG[i-1]; continue; }
         if(IsDayBoundary(i-1))
            { be = g_DBPG[i-1]; bc = iClose(Symbol(),PERIOD_M1,i-1); }
         if(bc <= 0.0) { g_DBPG[i] = g_DBPG[i-1]; continue; }
         g_DBPG[i] = be * MathPow(ci / bc, 2.0); // L=2
      }
      g_initialized = true; return(rates_total);
   }
   double cn = iClose(Symbol(), PERIOD_M1, 0);
   for(int k = 1; k < 1500; k++)
      if(IsDayBoundary(k))
      {
         double cb = iClose(Symbol(), PERIOD_M1, k);
         if(cb > 0.0 && cn > 0.0)
            g_DBPG[0] = g_DBPG[k] * MathPow(cn/cb, 2.0);
         break;
      }
   return(rates_total);
}
