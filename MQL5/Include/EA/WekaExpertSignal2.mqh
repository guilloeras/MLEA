//+------------------------------------------------------------------+
//|                                             WekaExpertSignal.mqh |
//|                                                         Zephyrrr |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Zephyrrr"
#property link      "http://www.mql5.com"

#include <ExpertModel\ExpertModel.mqh>
#include <ExpertModel\ExpertModelSignal.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>

#include <Indicators\Oscilators.mqh>
#include <Indicators\TimeSeries.mqh>

#include <Files\FileTxt.mqh>

//#import "MT5EA.dll"
//   void HelloDllTest(string say);
//   void HelloServiceTest(long hHandle, string say);
//   long CreateEAService(string symbol);
//   void DestroyEAService(long hHandle);
//   //int GetBestAction(long hHandle, long time, double& p[]);
//   void BuildModel(long hService, long trainTimeStart, long trainTimeEnd, int numInst, int numAttr, double& p[], int& r[]);
//   int PredictByModel(long hService, long time, int numAttr, double& p[]);
//#import

#define PERIOD_CNT 2

// GBPUSD, M15
class CWekaExpertSignal : public CExpertModelSignal
{
private:
    long m_ea;
    int inds[PERIOD_CNT][50];
    string symbol;
    ENUM_TIMEFRAMES period[PERIOD_CNT];
    
    int AMA_9_2_30, ADX_14, ADXWilder_14, Bands_20_2, DEMA_14, FrAMA_14, MA_10, SAR_002_02, StdDev_20, TEMA_14, VIDyA_9_12;
    int ATR_14, BearsPower_13, BullsPower_13, CCI_14, DeMarker_14, MACD_12_26_9, Momentum_14, OsMA_12_26_9, RSI_14, RVI_10, Stochastic_5_3_3, TriX_14, WPR_14;

	int GetSignal();
    bool CheckTime();
    int m_wekaResult;
    datetime m_lastWekaTime;
public:
	CWekaExpertSignal();
	~CWekaExpertSignal();
	virtual bool      ValidationSettings();
	virtual bool      InitIndicators(CIndicators* indicators);

	virtual bool      CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration);
	virtual bool      CheckCloseLong(CTableOrder* t, double& price);
	virtual bool      CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration);
	virtual bool      CheckCloseShort(CTableOrder* t, double& price);

	void InitParameters();
};

void CWekaExpertSignal::InitParameters()
{
	
}

void CWekaExpertSignal::CWekaExpertSignal()
{
    m_wekaResult = D'2000.01.01';
    //HelloDllTest("HelloDllTest is OK.");
    
    m_ea = CreateEAService(Symbol());
    if (m_ea == NULL)
    {
        Alert("WekaExpert Init failed!");
        return;
    }
    else
    {
        //HelloServiceTest(m_ea, "HelloServiceTest is OK.");
    }
    
    symbol = Symbol();
    period[0] = PERIOD_M15;
    if (PERIOD_CNT > 1) period[1] = PERIOD_H1;
    if (PERIOD_CNT > 2) period[2] = PERIOD_H4;
    if (PERIOD_CNT > 3) period[3] = PERIOD_H12;
    
    for(int i=0; i<ArraySize(period); ++i)
    {   
        inds[i][0] = iAMA(symbol, period[i], 9, 2, 30, 0, PRICE_CLOSE);     AMA_9_2_30 = 0;
        inds[i][1] = iADX(symbol, period[i], 14);                           ADX_14 = 1;
        inds[i][2] = iADXWilder(symbol, period[i], 14);                     ADXWilder_14 = 2;
        inds[i][3] = iBands(symbol, period[i], 20, 0, 2, PRICE_CLOSE);      Bands_20_2 = 3;
        inds[i][4] = iDEMA(symbol, period[i], 14, 0, PRICE_CLOSE);          DEMA_14 = 4;
        //inds[i][5] = iEnvelopes();
        inds[i][6] = iFrAMA(symbol, period[i], 14, 0, PRICE_CLOSE);         FrAMA_14 = 6;
        //inds[i][7] = iIchimoku();                                     
        inds[i][8] = iMA(symbol, period[i], 10, 0, MODE_SMA, PRICE_CLOSE);  MA_10 = 8;   
        inds[i][9] = iSAR(symbol, period[i], 0.02, 0.2);                    SAR_002_02 = 9;
        inds[i][10] = iStdDev(symbol, period[i], 20, 0, MODE_SMA, PRICE_CLOSE);     StdDev_20 = 10;
        inds[i][11] = iTEMA(symbol, period[i], 14, 0, PRICE_CLOSE);         TEMA_14 = 11;
        inds[i][12] = iVIDyA(symbol, period[i], 9, 12, 0, PRICE_CLOSE);     VIDyA_9_12 = 12;
        
        inds[i][20] = iATR(symbol, period[i], 14);                          ATR_14 = 20;
        inds[i][21] = iBearsPower(symbol, period[i], 13);                   BearsPower_13 = 21;
        inds[i][22] = iBullsPower(symbol, period[i], 13);                   BullsPower_13 = 22;
        //inds[i][23] = iChaikin();             
        inds[i][24] = iCCI(symbol, period[i], 14, PRICE_TYPICAL);           CCI_14 = 24;
        inds[i][25] = iDeMarker(symbol, period[i], 14);                     DeMarker_14 = 25;
        //inds[i][26] = iForce();       
        inds[i][27] = iMACD(symbol, period[i], 12, 26, 9, PRICE_CLOSE);     MACD_12_26_9= 27;
        inds[i][28] = iMomentum(symbol, period[i], 14, PRICE_CLOSE);        Momentum_14 = 28;
        inds[i][29] = iOsMA(symbol, period[i], 12, 26, 9, PRICE_CLOSE);     OsMA_12_26_9 = 29;
        inds[i][30] = iRSI(symbol, period[i], 14, PRICE_CLOSE);             RSI_14 = 30;
        inds[i][31] = iRVI(symbol, period[i], 10);                          RVI_10 = 31;
        inds[i][32] = iStochastic(symbol, period[i], 5, 3, 3, MODE_SMA, STO_LOWHIGH);       Stochastic_5_3_3 = 32; 
        inds[i][33] = iTriX(symbol, period[i], 14, PRICE_CLOSE);            TriX_14 = 33;
        inds[i][34] = iWPR(symbol, period[i], 14);                          WPR_14 = 34;
        
        //inds[i][40] = iAC(symbol, period[i]);
        //inds[i][41] = iAlligator(symbol, period[i], 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
        //inds[i][42] = iAO(symbol, period[i]);
        //inds[i][43] = iFractals();
        //inds[i][44] = iGator();
        //inds[i][45] = iBWMFI();
    }
}

void CWekaExpertSignal::~CWekaExpertSignal()
{
    if (m_ea != NULL)
    {
        DestroyEAService(m_ea);
    }
}
bool CWekaExpertSignal::ValidationSettings()
{
	if(!CExpertSignal::ValidationSettings()) 
		return(false);

	if(false)
	{
		printf(__FUNCTION__+": Indicators should not be Null!");
		return(false);
	}
	return(true);
}

bool CWekaExpertSignal::InitIndicators(CIndicators* indicators)
{
	if(indicators==NULL) 
		return(false);
	bool ret = true;

	return ret;
}

int CWekaExpertSignal::GetSignal() 
{
    if (TimeCurrent()  == m_lastWekaTime)
        return m_wekaResult;
    m_lastWekaTime = TimeCurrent();
        
    MqlDateTime now;
    TimeCurrent(now);
    MqlRates rate[];
    ArraySetAsSeries(rate, true);
    CopyRates(symbol, period[0], 0, 5, rate);
    
    double open = rate[1].open;
    double p[30 * PERIOD_CNT + 1];
    p[0] = now.hour;
    p[1] = now.day_of_week;
    
    p[2] = rate[1].close - open;
    p[3] = rate[1].high - open;
    p[4] = rate[1].low - open;
    
    for(int k=1; k<PERIOD_CNT; ++k)
    {
        CopyRates(symbol, period[k], 0, 5, rate);
        p[k * 30 + 1] = rate[1].open - open;
        p[k * 30 + 2] = rate[1].close - open;
        p[k * 30 + 3] = rate[1].high - open;
        p[k * 30 + 4] = rate[1].low - open;
    }
    
    double indBuf[];
    ArraySetAsSeries(indBuf, true);
    for(int k=0; k<PERIOD_CNT; ++k)
    {
        CopyBuffer(inds[k][ADXWilder_14], 0, 0, 5, indBuf);
        p[k * 30 + 5] = indBuf[1];
        CopyBuffer(inds[k][ADX_14], 0, 0, 5, indBuf);
        p[k * 30 + 6] = indBuf[1];
        CopyBuffer(inds[k][AMA_9_2_30], 0, 0, 5, indBuf);
        p[k * 30 + 7] = indBuf[1] - open;
        CopyBuffer(inds[k][ATR_14], 0, 0, 5, indBuf);
        p[k * 30 + 8] = indBuf[1];
        CopyBuffer(inds[k][Bands_20_2], 0, 0, 5, indBuf);
        p[k * 30 + 9] = indBuf[1] - open;
        CopyBuffer(inds[k][BearsPower_13], 0, 0, 5, indBuf);
        p[k * 30 + 10] = indBuf[1];
        CopyBuffer(inds[k][BullsPower_13], 0, 0, 5, indBuf);
        p[k * 30 + 11] = indBuf[1];
        CopyBuffer(inds[k][CCI_14], 0, 0, 5, indBuf);
        p[k * 30 + 12] = indBuf[1];
        CopyBuffer(inds[k][DeMarker_14], 0, 0, 5, indBuf);
        p[k * 30 + 13] = indBuf[1];
        CopyBuffer(inds[k][DEMA_14], 0, 0, 5, indBuf);
        p[k * 30 + 14] = indBuf[1] - open;
        CopyBuffer(inds[k][FrAMA_14], 0, 0, 5, indBuf);
        p[k * 30 + 15] = indBuf[1] - open;
        CopyBuffer(inds[k][MACD_12_26_9], 0, 0, 5, indBuf);
        p[k * 30 + 16] = indBuf[1];
        CopyBuffer(inds[k][MACD_12_26_9], 1, 0, 5, indBuf);
        p[k * 30 + 17] = indBuf[1];
        CopyBuffer(inds[k][MA_10], 0, 0, 5, indBuf);
        p[k * 30 + 18] = indBuf[1] - open;
        CopyBuffer(inds[k][Momentum_14], 0, 0, 5, indBuf);
        p[k * 30 + 19] = indBuf[1];
        CopyBuffer(inds[k][OsMA_12_26_9], 0, 0, 5, indBuf);
        p[k * 30 + 20] = indBuf[1];
        CopyBuffer(inds[k][RSI_14], 0, 0, 5, indBuf);
        p[k * 30 + 21] = indBuf[1];
        CopyBuffer(inds[k][RVI_10], 0, 0, 5, indBuf);
        p[k * 30 + 22] = indBuf[1];
        CopyBuffer(inds[k][SAR_002_02], 0, 0, 5, indBuf);
        p[k * 30 + 23] = indBuf[1] - open;
        CopyBuffer(inds[k][StdDev_20], 0, 0, 5, indBuf);
        p[k * 30 + 24] = indBuf[1];
        CopyBuffer(inds[k][Stochastic_5_3_3], 0, 0, 5, indBuf);
        p[k * 30 + 25] = indBuf[1];
        CopyBuffer(inds[k][Stochastic_5_3_3], 1, 0, 5, indBuf);
        p[k * 30 + 26] = indBuf[1];
        CopyBuffer(inds[k][TEMA_14], 0, 0, 5, indBuf);
        p[k * 30 + 27] = indBuf[1] - open;
        CopyBuffer(inds[k][TriX_14], 0, 0, 5, indBuf);
        p[k * 30 + 28] = indBuf[1];
        CopyBuffer(inds[k][VIDyA_9_12], 0, 0, 5, indBuf);
        p[k * 30 + 29] = indBuf[1] - open;
        CopyBuffer(inds[k][WPR_14], 0, 0, 5, indBuf);
        p[k * 30 + 30] = indBuf[1];
    }
    
    m_wekaResult = 0;
    
    /*string ps;
    for(int i=0; i<ArraySize(p); ++i)
    {
        if (i == 0 || i == 1)
            ps += DoubleToString(p[i], 0) + ",";
        else
            ps += DoubleToString(p[i], 5) + ",";
    }
    
    //if (m_wekaResult != 0)
    //{
        //Print(TimeToString(TimeCurrent()) + ":" + "" + "R:" + IntegerToString(m_wekaResult));
    //}

    CFileTxt file;
    file.Open("p.txt", FILE_WRITE | FILE_READ);
    file.Seek(0, SEEK_END);
    file.WriteString(TimeToString(TimeCurrent()));
    file.WriteString(": ");
    file.WriteString(ps);
    file.WriteString(IntegerToString(m_wekaResult));
    file.WriteString("\r\n");
    file.Close();*/
    
	return m_wekaResult;
}

bool CWekaExpertSignal::CheckTime(void)
{
    datetime now = TimeCurrent();

    if (now % (15 * 60) == 0)
    {
        return true;
    }
    return false;
}
bool CWekaExpertSignal::CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration)
{
    Debug("CWekaExpertSignal::CheckOpenLong");

	CExpertModel* em = (CExpertModel *)m_expert;
	if (em.GetOrderCount(ORDER_TYPE_BUY) >= 1)
		return false;
    
    if (!CheckTime())
        return false;
    
	if (GetSignal() > 0)
	{
		m_symbol.RefreshRates();

		price = m_symbol.Ask();
		tp = price + 700 * m_symbol.Point();
		sl = price - 350 * m_symbol.Point();
		
		return true;
	}

	return false;
}

bool CWekaExpertSignal::CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration)
{
    Debug("CWekaExpertSignal::CheckOpenShort");

	CExpertModel* em = (CExpertModel *)m_expert;
	if (em.GetOrderCount(ORDER_TYPE_SELL) >= 1)
		return false;
    if (!CheckTime())
        return false;
        
	if (m_wekaResult < 0)
	{
		m_symbol.RefreshRates();

		price = m_symbol.Bid();
		tp = price - 700 * m_symbol.Point();
		sl = price + 350 * m_symbol.Point();

		return true;
	}

	return false;
}

bool CWekaExpertSignal::CheckCloseLong(CTableOrder* t, double& price)
{
	CExpertModel* em = (CExpertModel *)m_expert;
    if (!CheckTime())
        return false;
        
	if (GetSignal() < 0)
    {
        price = m_symbol.Bid();

        Debug("CWekaExpertSignal get close long signal1");
        return true;
	}

	return false;
}

bool CWekaExpertSignal::CheckCloseShort(CTableOrder* t, double& price)
{
	CExpertModel* em = (CExpertModel *)m_expert;
    if (!CheckTime())
        return false;
        
	if (m_wekaResult > 0)
	{
		price = m_symbol.Ask();

        Debug("CWekaExpertSignal get close short signal1");
        return true;
	}

    return false;
}
