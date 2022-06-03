//+------------------------------------------------------------------+
//|                                       PositionSizeCalculator.mqh |
//|                             Copyright © 2012-2022, EarnForex.com |
//|                                     Based on panel by qubbit.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include "Defines.mqh"

// Default values for settings:
double EntryLevel = 0;
double StopLossLevel = 0;
double TakeProfitLevel = 0;
string PanelCaption = "";
string PanelCaptionBase = "";

class QCPositionSizeCalculator : public CAppDialog
{
private:
    CButton          m_BtnTabMain, m_BtnTabRisk, m_BtnTabMargin, m_BtnTabSwaps, m_BtnTabScript, m_BtnOrderType, m_BtnAccount, m_BtnLines, m_BtnStopLoss, m_BtnTakeProfit, m_BtnEntry, m_BtnATRTimeframe, m_BtnMaxPS, m_BtnTPsInward, m_BtnTPsOutward, m_BtnQuickRisk1, m_BtnQuickRisk2;
    CCheckBox        m_ChkCountPendings, m_ChkIgnoreOrders, m_ChkIgnoreOtherSymbols, m_ChkDisableTradingWhenLinesAreHidden, m_ChkSubtractPositions, m_ChkSubtractPendingOrders, m_ChkDoNotApplyStopLoss, m_ChkDoNotApplyTakeProfit, m_ChkAskForConfirmation, m_ChkScriptCommentAutoSuffix;
    CEdit            m_EdtEntryLevel, m_EdtSL, m_EdtTP, m_EdtAccount, m_EdtCommissionSize, m_EdtRiskPIn, m_EdtRiskPRes, m_EdtRiskMIn, m_EdtRiskMRes, m_EdtReward1, m_EdtReward2, m_EdtRR1, m_EdtRR2, m_EdtPosSize, m_EdtPointValue, m_EdtATRPeriod, m_EdtATRMultiplierSL, m_EdtATRMultiplierTP, m_EdtCurRiskM, m_EdtCurRiskP, m_EdtPotRiskM, m_EdtPotRiskP, m_EdtCurProfitM, m_EdtCurProfitP, m_EdtPotProfitM, m_EdtPotProfitP, m_EdtCurL, m_EdtPotL, m_EdtPosMargin, m_EdtUsedMargin, m_EdtFreeMargin, m_EdtCustomLeverage, m_EdtMaxPositionSizeByMargin, m_EdtSwapsType, m_EdtSwapsTripleDay, m_EdtSwapsNominalLong, m_EdtSwapsNominalShort, m_EdtSwapsDailyLongLot, m_EdtSwapsDailyShortLot, m_EdtSwapsDailyLongPS, m_EdtSwapsDailyShortPS, m_EdtSwapsYearlyLongLot, m_EdtSwapsYearlyShortLot, m_EdtSwapsYearlyLongPS, m_EdtSwapsYearlyShortPS, m_EdtMagicNumber, m_EdtScriptCommentary, m_EdtMaxSlippage, m_EdtMaxSpread, m_EdtMaxEntrySLDistance, m_EdtMinEntrySLDistance, m_EdtMaxPositionSize;
    CLabel           m_LblEntryLevel, m_LblEntryWarning, m_LblSL, m_LblSLWarning, m_LblTPWarning, m_LblOrderType, m_LblCommissionSize, m_LblAdditionalFundsAsterisk, m_LblInput, m_LblResult, m_LblRisk, m_LblRiskM, m_LblReward, m_LblRR, m_LblPosSize, m_LblPointValue, m_LblATRPeriod, m_LblATRMultiplierSL, m_LblATRMultiplierTP, m_LblATRValue, m_LblATRTimeframe, m_LblCurrentRiskMoney, m_LblCurrentRiskPerc, m_LblCurrentProfitMoney, m_LblCurrentProfitPerc, m_LblPotentialRiskMoney, m_LblPotentialRiskPerc, m_LblPotentialProfitMoney, m_LblPotentialProfitPerc, m_LblCurrentLots, m_LblPotentialLots, m_LblCurrentPortfolio, m_LblPotentialPortfolio, m_LblPosMargin, m_LblUsedMargin, m_LblFreeMargin, m_LblCustomLeverage, m_LblAccLeverage, m_LblSymbolLeverage, m_LblMaxPositionSizeByMargin, m_LblSwapsType, m_LblSwapsTripleDay, m_LblSwapsLong, m_LblSwapsShort, m_LblSwapsNominal, m_LblSwapsDaily, m_LblSwapsYearly, m_LblSwapsPerLotDaily, m_LblSwapsPerPSDaily, m_LblSwapsPerLotYearly, m_LblSwapsPerPSYearly, m_LblMagicNumber, m_LblScriptCommentary, m_LblScriptExplanation, m_LblScriptPoints, m_LblMaxSlippage, m_LblMaxSpread, m_LblMaxEntrySLDistance, m_LblMinEntrySLDistance, m_LblScriptLots, m_LblMaxPositionSize, m_LblURL, m_LblScriptTP, m_LblScriptTPShare;
    string           m_FileName, m_IniFileName;
    double           m_DPIScale;
    bool             NoPanelMaximization; // Crutch variable to prevent panel maximization when Maximize() is called at the indicator's initialization.
    CLabel           ScriptTPLabels[];
    CEdit            ScriptTPEdits[];
    CEdit            ScriptTPShareEdits[];

    // Extra TP fields for the Main tab.
    CLabel           AdditionalTPLabels[], AdditionalTPWarnings[];
    CEdit            AdditionalTPEdits[];

public:
                     QCPositionSizeCalculator(void);
                    ~QCPositionSizeCalculator(void) {};

    virtual bool     Create(const long chart, const string name, const int subwin, const int x1, const int y1);
    virtual bool     OnEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
    // Gets values from lines, recalculates position size, and updates values in the panel.
    virtual void     RefreshValues();
    virtual bool     SaveSettingsOnDisk();
    virtual bool     LoadSettingsFromDisk();
    virtual bool     DeleteSettingsFile();
    virtual bool     Run()
    {
        SeekAndDestroyDuplicatePanels();
        return(CAppDialog::Run());
    }
    virtual void     HideShowMaximize();
    virtual void     IniFileNameSet(string filename)
    {
        m_IniFileName = filename;
    }
    virtual void     IniFileSave();
    virtual void     IniFileLoad();
    string           IniFileName(void) const;
    virtual void     UpdateFixedSL();
    virtual void     UpdateFixedTP();
    virtual void     UpdateAdditionalFixedTP(int i);
    virtual void     FixatePanelPosition()
    {
        if (!m_minimized) m_norm_rect.SetBound(m_rect);    // Used to fixate panel's position after calling Move(). Otherwise, unless the panel gets dragged by mouse, its position isn't remembered properly in the INI file.
        else m_min_rect.SetBound(m_rect);
    }
    virtual void     UpdateScriptTPEdit(int i);
    virtual void     UpdateAdditionalTPEdit(int i);
    virtual void     ProcessLineObjectsAfterUpdatingMultipleTP(int i);
    virtual void     UpdateScriptTPShareEdit(int i);
    virtual void     CheckAndRestoreLines();
    virtual void     Minimize();
    virtual bool     IsMinimized() {return m_minimized;}

    // Remember the panel's location to have the same location for minimized and maximized states.
    int              remember_top, remember_left;
private:

    virtual void     ShowMain();
    virtual void     ShowRisk();
    virtual void     ShowMargin();
    virtual void     ShowSwaps();
    virtual void     ShowScript();
    virtual void     HideMain();
    virtual void     HideRisk();
    virtual void     HideMargin();
    virtual void     HideSwaps();
    virtual void     HideScript();

    virtual bool     CreateObjects();
    virtual bool     InitObjects();
    // Arranges panel objects on the panel.
    virtual void     MoveAndResize();
    virtual bool     DisplayValues();
    virtual void     SeekAndDestroyDuplicatePanels();
    virtual void     ProcessTPChange(const bool tp_button_click);

    virtual bool     ButtonCreate    (CButton&    Btn, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual bool     CheckBoxCreate  (CCheckBox&  Chk, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual bool     EditCreate      (CEdit&      Edt, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual bool     LabelCreate     (CLabel&     Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual void     Maximize();

    // Event handlers
    void             OnEndEditEdtEntryLevel();
    void             OnEndEditEdtSL();
    void             OnEndEditEdtTP();
    void             OnClickBtnOrderType();
    void             OnClickBtnLines();
    void             OnClickBtnAccount();
    void             OnClickBtnMaxPS();
    void             OnEndEditEdtCommissionSize();
    void             OnEndEditEdtAccount();
    void             OnEndEditEdtRiskPIn();
    void             OnEndEditEdtRiskMIn();
    void             OnEndEditEdtPosSize();
    void             OnEndEditATRPeriod();
    void             OnEndEditATRMultiplierSL();
    void             OnEndEditATRMultiplierTP();
    void             OnChangeChkCountPendings();
    void             OnChangeChkIgnoreOrders();
    void             OnChangeChkIgnoreOtherSymbols();
    void             OnEndEditEdtCustomLeverage();
    void             OnEndEditEdtMagicNumber();
    void             OnEndEditEdtScriptCommentary();
    void             OnChangeChkDisableTradingWhenLinesAreHidden();
    void             OnEndEditEdtMaxSlippage();
    void             OnEndEditEdtMaxSpread();
    void             OnEndEditEdtMaxEntrySLDistance();
    void             OnEndEditEdtMinEntrySLDistance();
    void             OnEndEditEdtMaxPositionSize();
    void             OnChangeChkSubtractPositions();
    void             OnChangeChkSubtractPendingOrders();
    void             OnChangeChkDoNotApplyStopLoss();
    void             OnChangeChkDoNotApplyTakeProfit();
    void             OnChangeChkAskForConfirmation();
    void             OnChangeChkScriptCommentAutoSuffix();
    void             OnClickBtnTabMain();
    void             OnClickBtnTabRisk();
    void             OnClickBtnTabMargin();
    void             OnClickBtnTabSwaps();
    void             OnClickBtnTabScript();
    void             OnClickBtnStopLoss();
    void             OnClickBtnTakeProfit();
    void             OnClickBtnEntry();
    void             OnClickBtnATRTimeframe();
    void             OnClickBtnTPsInward();
    void             OnClickBtnTPsOutward();
    void             OnClickBtnQuickRisk1();
    void             OnClickBtnQuickRisk2();
};

// Event Map
EVENT_MAP_BEGIN(QCPositionSizeCalculator)
ON_EVENT(ON_END_EDIT, m_EdtEntryLevel, OnEndEditEdtEntryLevel)
ON_EVENT(ON_END_EDIT, m_EdtSL, OnEndEditEdtSL)
ON_EVENT(ON_END_EDIT, m_EdtTP, OnEndEditEdtTP)
ON_EVENT(ON_CLICK, m_BtnOrderType, OnClickBtnOrderType)
ON_EVENT(ON_CLICK, m_BtnLines, OnClickBtnLines)
ON_EVENT(ON_CLICK, m_BtnAccount, OnClickBtnAccount)
ON_EVENT(ON_CLICK, m_BtnMaxPS, OnClickBtnMaxPS)
ON_EVENT(ON_END_EDIT, m_EdtCommissionSize, OnEndEditEdtCommissionSize)
ON_EVENT(ON_END_EDIT, m_EdtAccount, OnEndEditEdtAccount)
ON_EVENT(ON_END_EDIT, m_EdtRiskPIn, OnEndEditEdtRiskPIn)
ON_EVENT(ON_END_EDIT, m_EdtRiskMIn, OnEndEditEdtRiskMIn)
ON_EVENT(ON_END_EDIT, m_EdtPosSize, OnEndEditEdtPosSize)
ON_EVENT(ON_END_EDIT, m_EdtATRPeriod, OnEndEditATRPeriod)
ON_EVENT(ON_END_EDIT, m_EdtATRMultiplierSL, OnEndEditATRMultiplierSL)
ON_EVENT(ON_END_EDIT, m_EdtATRMultiplierTP, OnEndEditATRMultiplierTP)
ON_EVENT(ON_CHANGE, m_ChkCountPendings, OnChangeChkCountPendings)
ON_EVENT(ON_CHANGE, m_ChkIgnoreOrders, OnChangeChkIgnoreOrders)
ON_EVENT(ON_CHANGE, m_ChkIgnoreOtherSymbols, OnChangeChkIgnoreOtherSymbols)
ON_EVENT(ON_END_EDIT, m_EdtCustomLeverage, OnEndEditEdtCustomLeverage)
ON_EVENT(ON_END_EDIT, m_EdtMagicNumber, OnEndEditEdtMagicNumber)
ON_EVENT(ON_END_EDIT, m_EdtScriptCommentary, OnEndEditEdtScriptCommentary)
ON_EVENT(ON_CHANGE, m_ChkDisableTradingWhenLinesAreHidden, OnChangeChkDisableTradingWhenLinesAreHidden)
ON_EVENT(ON_END_EDIT, m_EdtMaxSlippage, OnEndEditEdtMaxSlippage)
ON_EVENT(ON_END_EDIT, m_EdtMaxSpread, OnEndEditEdtMaxSpread)
ON_EVENT(ON_END_EDIT, m_EdtMaxEntrySLDistance, OnEndEditEdtMaxEntrySLDistance)
ON_EVENT(ON_END_EDIT, m_EdtMinEntrySLDistance, OnEndEditEdtMinEntrySLDistance)
ON_EVENT(ON_END_EDIT, m_EdtMaxPositionSize, OnEndEditEdtMaxPositionSize)
ON_EVENT(ON_CHANGE, m_ChkSubtractPositions, OnChangeChkSubtractPositions)
ON_EVENT(ON_CHANGE, m_ChkSubtractPendingOrders, OnChangeChkSubtractPendingOrders)
ON_EVENT(ON_CHANGE, m_ChkDoNotApplyStopLoss, OnChangeChkDoNotApplyStopLoss)
ON_EVENT(ON_CHANGE, m_ChkDoNotApplyTakeProfit, OnChangeChkDoNotApplyTakeProfit)
ON_EVENT(ON_CHANGE, m_ChkAskForConfirmation, OnChangeChkAskForConfirmation)
ON_EVENT(ON_CHANGE, m_ChkScriptCommentAutoSuffix, OnChangeChkScriptCommentAutoSuffix)
ON_EVENT(ON_CLICK, m_BtnTabMain, OnClickBtnTabMain)
ON_EVENT(ON_CLICK, m_BtnTabRisk, OnClickBtnTabRisk)
ON_EVENT(ON_CLICK, m_BtnTabMargin, OnClickBtnTabMargin)
ON_EVENT(ON_CLICK, m_BtnTabSwaps, OnClickBtnTabSwaps)
ON_EVENT(ON_CLICK, m_BtnTabScript, OnClickBtnTabScript)
ON_EVENT(ON_CLICK, m_BtnTakeProfit, OnClickBtnTakeProfit)
ON_EVENT(ON_CLICK, m_BtnStopLoss, OnClickBtnStopLoss)
ON_EVENT(ON_CLICK, m_BtnEntry, OnClickBtnEntry)
ON_EVENT(ON_CLICK, m_BtnATRTimeframe, OnClickBtnATRTimeframe)
ON_EVENT(ON_CLICK, m_BtnTPsInward, OnClickBtnTPsInward)
ON_EVENT(ON_CLICK, m_BtnTPsOutward, OnClickBtnTPsOutward)
ON_EVENT(ON_CLICK, m_BtnQuickRisk1, OnClickBtnQuickRisk1)
ON_EVENT(ON_CLICK, m_BtnQuickRisk2, OnClickBtnQuickRisk2)
EVENT_MAP_END(CAppDialog)

//+-------------------+
//| Class constructor |
//+-------------------+
QCPositionSizeCalculator::QCPositionSizeCalculator(void)
{
    m_FileName = "PSC_" + Symbol() + IntegerToString(ChartID());
    StringReplace(m_FileName, ".", "_dot_");
    m_FileName += ".txt";
    m_IniFileName = "";
    NoPanelMaximization = false;
    LinesSelectedStatus = 0;
    remember_left = -1;
    remember_top = -1;
}

//+--------+
//| Button |
//+--------+
bool QCPositionSizeCalculator::ButtonCreate(CButton &Btn, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Btn.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Btn))                                                              return false;
    if (!Btn.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name, OBJPROP_TOOLTIP, Tooltip);

    return true;
}

//+----------+
//| Checkbox |
//+----------+
bool QCPositionSizeCalculator::CheckBoxCreate(CCheckBox &Chk, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Chk.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Chk))                                                              return false;
    if (!Chk.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name + "Label", OBJPROP_TOOLTIP, Tooltip);

    return true;
}

//+------+
//| Edit |
//+------+
bool QCPositionSizeCalculator::EditCreate(CEdit &Edt, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Edt.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Edt))                                                              return false;
    if (!Edt.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name, OBJPROP_TOOLTIP, Tooltip);

    return true;
}

//+-------+
//| Label |
//+-------+
bool QCPositionSizeCalculator::LabelCreate(CLabel &Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Lbl.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Lbl))                                                              return false;
    if (!Lbl.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name, OBJPROP_TOOLTIP, Tooltip);

    return true;
}

//+-----------------------+
//| Create a panel object |
//+-----------------------+
bool QCPositionSizeCalculator::Create(const long chart, const string name, const int subwin, const int x1, const int y1)
{
    double screen_dpi = (double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
    m_DPIScale = screen_dpi / 96.0;

    int x2 = x1 + (int)MathRound(350 * m_DPIScale);
    int y2 = y1 + (int)MathRound(570 * m_DPIScale);
    if (!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))               return false;
    if (!CreateObjects())                                                       return false;
    return true;
}

bool QCPositionSizeCalculator::CreateObjects()
{
    int row_start = (int)MathRound(10 * m_DPIScale);
    int element_height = (int)MathRound(20 * m_DPIScale);
    int v_spacing = (int)MathRound(4 * m_DPIScale);

    int tab_button_start = (int)MathRound(15 * m_DPIScale);
    int tab_button_width = (int)MathRound(50 * m_DPIScale);
    int tab_button_spacing = (int)MathRound(15 * m_DPIScale);
    int normal_label_width = (int)MathRound(108 * m_DPIScale);
    int normal_edit_width = (int)MathRound(85 * m_DPIScale);
    int narrow_label_width = (int)MathRound(85 * m_DPIScale);
    int narrow_edit_width = (int)MathRound(75 * m_DPIScale);
    int risk_perc_edit_width = (int)MathRound(65 * m_DPIScale);
    int narrowest_label_width = (int)MathRound(50 * m_DPIScale);
    int risk_lot_edit = narrowest_label_width;
    int commission_edit_width = (int)MathRound(50 * m_DPIScale);
    int max_psc_edit_width = (int)MathRound(90 * m_DPIScale);
    int leverage_edit_width = (int)MathRound(35 * m_DPIScale);
    int wide_edit_width = (int)MathRound(170 * m_DPIScale);
    int wide_label_width = (int)MathRound(193 * m_DPIScale);
    int swap_last_label_width = (int)MathRound(80 * m_DPIScale);
    int swap_type_edit_width = narrow_edit_width * 2 + (int)MathRound(5 * m_DPIScale);
    int swap_size_edit_width = narrow_edit_width;
    int atr_period_label_width = (int)MathRound(72 * m_DPIScale);
    int atr_period_edit_width = (int)MathRound(36 * m_DPIScale);
    int quick_risk_button_width = (int)MathRound(32 * m_DPIScale);

    int first_column_start = (int)MathRound(10 * m_DPIScale);
    int second_column_start = first_column_start + (int)MathRound(123 * m_DPIScale);
    int second_risk_column_start = first_column_start + (int)MathRound(114 * m_DPIScale);
    int second_margin_column_start = first_column_start + (int)MathRound(138 * m_DPIScale);
    int second_swaps_column_start = first_column_start + narrowest_label_width + (int)MathRound(5 * m_DPIScale);
    int second_script_column_start = second_margin_column_start + (int)MathRound(5 * m_DPIScale);
    int third_column_start = second_column_start + (int)MathRound(102 * m_DPIScale);
    int third_risk_column_start = second_risk_column_start + normal_edit_width + (int)MathRound(4 * m_DPIScale);
    int third_swaps_column_start = second_swaps_column_start + narrow_edit_width + (int)MathRound(5 * m_DPIScale);
    int third_script_column_start = second_script_column_start + normal_edit_width + (int)MathRound(5 * m_DPIScale);
    int fourth_risk_column_start = third_risk_column_start + risk_perc_edit_width + (int)MathRound(4 * m_DPIScale);
    int fourth_swaps_column_start = third_swaps_column_start + narrow_edit_width + (int)MathRound(5 * m_DPIScale);
    int max_psc_column_start = second_margin_column_start + normal_edit_width - (int)MathRound(5 * m_DPIScale);

    int multi_tp_column_start = first_column_start + normal_label_width;
    int multi_tp_label_width = (int)MathRound(70 * m_DPIScale);
    int multi_tp_button_start = second_script_column_start + (int)MathRound(11 * m_DPIScale);

    int panel_end = third_column_start + narrow_label_width;

    int y = (int)MathRound(8 * m_DPIScale);

// Tabs

    if (!ButtonCreate(m_BtnTabMain, tab_button_start, y, tab_button_start + tab_button_width, y + element_height, "m_BtnTabMain", "Main"))                                                                                                                    return false;
    if (!ButtonCreate(m_BtnTabRisk, tab_button_start + tab_button_width + tab_button_spacing, y, tab_button_start + tab_button_width * 2 + tab_button_spacing, y + element_height, "m_BtnTabRisk", "Risk"))                                                                                                                   return false;
    if (!ButtonCreate(m_BtnTabMargin, tab_button_start + tab_button_width * 2 + tab_button_spacing * 2, y, tab_button_start + tab_button_width * 3 + tab_button_spacing * 2, y + element_height, "m_BtnTabMargin", "Margin"))                                                                                                             return false;
    if (!ButtonCreate(m_BtnTabSwaps, tab_button_start + tab_button_width * 3 + tab_button_spacing * 3, y, tab_button_start + tab_button_width * 4 + tab_button_spacing * 3, y + element_height, "m_BtnTabSwaps", "Swaps"))                                                                                                                return false;
    if (!ButtonCreate(m_BtnTabScript, tab_button_start + tab_button_width * 4 + tab_button_spacing * 4, y, tab_button_start + tab_button_width * 5 + tab_button_spacing * 4, y + element_height, "m_BtnTabScript", "Script"))                                                                                                             return false;

// Main

    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(m_LblEntryLevel, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblEntryLevel", "Entry:"))                                        return false;
    // Button to quickly switch between Long/Short trade planning.
    if (!ButtonCreate(m_BtnEntry, first_column_start + narrowest_label_width + v_spacing, y, second_column_start - v_spacing, y + element_height, "m_BtnEntry", EnumToString(sets.TradeDirection), "Switch between Long and Short"))                    return false;
    if (!EditCreate(m_EdtEntryLevel, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtEntryLevel", ""))                                                 return false;
    if (!LabelCreate(m_LblEntryWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblEntryWarning", ""))                                         return false;

    y += element_height + v_spacing;

    string stoploss_label_text = "Stop-loss:         ";
    if (SLDistanceInPoints) stoploss_label_text = "SL, points:        ";

    if (DefaultSL > 0) // Use button to quickly set SL.
    {
        if (!ButtonCreate(m_BtnStopLoss, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_BtnStopLoss", stoploss_label_text))                    return false;
    }
    else if (!LabelCreate(m_LblSL, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblSL", stoploss_label_text))                                               return false;

    if (!EditCreate(m_EdtSL, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtSL", ""))                                                                 return false;
    if (!LabelCreate(m_LblSLWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblSLWarning", ""))                                               return false;

    y += element_height + v_spacing;

    string takeprofit_label_text = "Take-profit:       ";
    if (TPDistanceInPoints) takeprofit_label_text = "TP, points:        ";
    if (!ButtonCreate(m_BtnTakeProfit, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_BtnTakeProfit", takeprofit_label_text, "Set TP based on SL or enable locked TP mode"))                    return false;
    if (!EditCreate(m_EdtTP, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtTP", ""))                                                                 return false;
    if (!LabelCreate(m_LblTPWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblTPWarning", ""))                                               return false;

    // Multiple TP levels for the Main tab.
    if (ScriptTakeProfitsNumber > 1)
    {
        // -1 because there is already one main TP level.
        ArrayResize(AdditionalTPLabels, ScriptTakeProfitsNumber - 1);
        ArrayResize(AdditionalTPEdits, ScriptTakeProfitsNumber - 1);
        ArrayResize(AdditionalTPWarnings, ScriptTakeProfitsNumber - 1);
        ArrayResize(AdditionalWarningTP, ScriptTakeProfitsNumber - 1); // String array.
        ArrayResize(AdditionalOutputRR, ScriptTakeProfitsNumber - 1); // String array.
        ArrayResize(AdditionalOutputReward, ScriptTakeProfitsNumber - 1); // Double array.
        string additional_tp_label_beginning = "Take-profit ";
        string additional_tp_label_end = ":";
        if (TPDistanceInPoints)
        {
            additional_tp_label_beginning = "TP ";
            additional_tp_label_end = ", points:";
        }
        for (int i = 0; i < ScriptTakeProfitsNumber - 1; i++)
        {
            y += element_height + v_spacing;
            if (!LabelCreate(AdditionalTPLabels[i], first_column_start, y, first_column_start + normal_label_width, y + element_height, "AdditionalTPLabels" + IntegerToString(i + 2), additional_tp_label_beginning + IntegerToString(i + 2) + additional_tp_label_end))                                       return false;
            if (!EditCreate(AdditionalTPEdits[i], second_column_start, y, second_column_start + normal_edit_width, y + element_height, "AdditionalTPEdits" + IntegerToString(i + 2), ""))                                               return false;
            if (!LabelCreate(AdditionalTPWarnings[i], third_column_start, y, third_column_start + narrow_label_width, y + element_height, "AdditionalTPWarnings" + IntegerToString(i + 2), ""))                                                 return false;
        }
    }

    if (ShowATROptions)
    {
        y += element_height + v_spacing;

        if (!LabelCreate(m_LblATRPeriod, first_column_start, y, first_column_start + atr_period_label_width, y + element_height, "m_LblATRPeriod", "ATR period:"))                                                 return false;
        if (!EditCreate(m_EdtATRPeriod, first_column_start + atr_period_label_width, y, first_column_start + atr_period_label_width + atr_period_edit_width, y + element_height, "m_EdtATRPeriod", ""))                                                                return false;

        if (!LabelCreate(m_LblATRMultiplierSL, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblATRMultiplierSL", "SL multiplier:"))                                                 return false;

        if (!EditCreate(m_EdtATRMultiplierSL, third_column_start, y, third_column_start + normal_edit_width / 2, y + element_height, "m_EdtATRMultiplierSL", ""))                                                              return false;

        y += element_height + v_spacing;

        if (!LabelCreate(m_LblATRValue, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblATRValue", "ATR = "))                                                return false;

        if (!LabelCreate(m_LblATRMultiplierTP, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblATRMultiplierTP", "TP multiplier:"))                                                 return false;

        if (!EditCreate(m_EdtATRMultiplierTP, third_column_start, y, third_column_start + normal_edit_width / 2, y + element_height, "m_EdtATRMultiplierTP", ""))                                                              return false;

        y += element_height + v_spacing;

        if (!LabelCreate(m_LblATRTimeframe, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblATRTimeframe", "ATR timeframe:"))                                                return false;

        if (!ButtonCreate(m_BtnATRTimeframe, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnATRTimeframe", EnumToString((ENUM_TIMEFRAMES)_Period)))                                                                return false;
    }

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblOrderType, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblOrderType", "Order type:"))                                    return false;
    if (!ButtonCreate(m_BtnOrderType, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnOrderType", "Instant", "Switch between Instant and Pending"))                                            return false;

    if (!ButtonCreate(m_BtnLines, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_BtnLines", "Hide lines"))                                     return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblCommissionSize, first_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblCommissionSize", "Commission (one-way) per lot:", "In account currency, per 1 standard lot"))         return false;
    if (!EditCreate(m_EdtCommissionSize, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtCommissionSize", ""))                                       return false;

    y += element_height + v_spacing;

    if (!HideAccSize)
    {
        if (!ButtonCreate(m_BtnAccount, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_BtnAccount", "Account balance", "Switch between balance, equity, and balance minus current portfolio risk"))                                       return false;
        if (!EditCreate(m_EdtAccount, second_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtAccount", ""))                                                    return false;

        string tooltip = "";
        if (CustomBalance > 0) tooltip = "Custom balance set";
        else if (AdditionalFunds > 0) tooltip = "+" + DoubleToString(AdditionalFunds, 2) + " additional funds";
        else if (AdditionalFunds < 0) tooltip = DoubleToString(-AdditionalFunds, 2) + " funds subtracted";
        if (!LabelCreate(m_LblAdditionalFundsAsterisk, third_column_start + normal_edit_width + v_spacing, y, third_column_start + normal_edit_width + v_spacing * 2, y + element_height, "m_LblAdditionalFundsAsterisk", "*", tooltip))       return false;

        y += element_height + v_spacing;
    }

    if (!LabelCreate(m_LblInput, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblInput", "Input", "Fields in this column are calculated based on inputs"))                                                 return false;
    if (!LabelCreate(m_LblResult, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_LblResult", "Result", "Fields in this column take into account broker's limitations"))                                            return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblRisk, first_column_start, y, first_column_start + tab_button_width - v_spacing, y + element_height, "m_LblRisk", "Risk, %:"))                                                   return false;


    if (QuickRisk1 > 0) if (!ButtonCreate(m_BtnQuickRisk1, first_column_start + tab_button_width, y, first_column_start + tab_button_width + quick_risk_button_width, y + element_height, "m_BtnQuickRisk1", "", "%"))                                                    return false;
    if (QuickRisk2 > 0) if (!ButtonCreate(m_BtnQuickRisk2, first_column_start + tab_button_width + quick_risk_button_width + v_spacing, y, first_column_start + tab_button_width + quick_risk_button_width * 2 + v_spacing, y + element_height, "m_BtnQuickRisk2", "", "%"))                                                  return false;

    if (!EditCreate(m_EdtRiskPIn, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRiskPIn", ""))                                                       return false;
    if (!EditCreate(m_EdtRiskPRes, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRiskPRes", ""))                                                   return false;
    m_EdtRiskPRes.ReadOnly(true);
    m_EdtRiskPRes.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblRiskM, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblRiskM", "Risk, money:"))                                           return false;
    if (!EditCreate(m_EdtRiskMIn, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRiskMIn", ""))                                                       return false;
    if (!EditCreate(m_EdtRiskMRes, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRiskMRes", ""))                                                   return false;
    m_EdtRiskMRes.ReadOnly(true);
    m_EdtRiskMRes.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblReward, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblReward", "Reward, money:"))                                           return false;
    if (!EditCreate(m_EdtReward1, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtReward1", ""))                                                       return false;
    m_EdtReward1.ReadOnly(true);
    m_EdtReward1.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtReward2, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtReward2", ""))                                                     return false;
    m_EdtReward2.ReadOnly(true);
    m_EdtReward2.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblRR, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblRR", "Reward/risk:"))                                                 return false;
    if (!EditCreate(m_EdtRR1, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRR1", ""))                                                               return false;
    if (!EditCreate(m_EdtRR2, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRR2", ""))                                                                 return false;
    m_EdtRR1.ReadOnly(true);
    m_EdtRR1.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtRR2.ReadOnly(true);
    m_EdtRR2.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblPosSize, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblPosSize", "Position size:"))                                 return false;
    if (ShowMaxPSButton) if (!ButtonCreate(m_BtnMaxPS, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnMaxPS", "Max PS"))                                                               return false;
    if (!EditCreate(m_EdtPosSize, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtPosSize", "", "In lots"))                                                      return false;

    if (ShowPointValue)
    {
        y += element_height + v_spacing;

        if (!LabelCreate(m_LblPointValue, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblPointValue", "Point value:", ""))                                return false;
        if (!EditCreate(m_EdtPointValue, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtPointValue", ""))                                                    return false;
        m_EdtPointValue.ReadOnly(true);
        m_EdtPointValue.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    }

    y += element_height + v_spacing;

    // EarnForex URL
    if (!LabelCreate(m_LblURL, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblURL", "www.earnforex.com"))                                         return false;
    m_LblURL.FontSize(8);
    m_LblURL.Color(C'0,115,66'); // Green

// Portfolio Risk

    // Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!CheckBoxCreate(m_ChkCountPendings, first_column_start, y, panel_end, y + element_height, "m_ChkCountPendings", "Count pending orders"))          return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkIgnoreOrders, first_column_start, y, panel_end, y + element_height, "m_ChkIgnoreOrders", "Ignore orders without stop-loss/take-profit")) return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkIgnoreOtherSymbols, first_column_start, y, panel_end, y + element_height, "m_ChkIgnoreOtherSymbols", "Ignore orders in other symbols")) return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblCurrentRiskMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblCurrentRiskMoney", "Risk $"))                                               return false;
    if (!LabelCreate(m_LblCurrentRiskPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentRiskPerc", "Risk %"))                                                    return false;
    if (!LabelCreate(m_LblCurrentLots, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentLots", "Lots"))                                                    return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblCurrentPortfolio, first_column_start, y, second_risk_column_start, y + element_height, "m_LblCurrentPortfolio", "Current portfolio:", "Trades that are currently open"))                            return false;
    if (!EditCreate(m_EdtCurRiskM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtCurRiskM", ""))                                                   return false;
    m_EdtCurRiskM.ReadOnly(true);
    m_EdtCurRiskM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtCurRiskP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtCurRiskP", ""))                                                  return false;
    m_EdtCurRiskP.ReadOnly(true);
    m_EdtCurRiskP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtCurL, fourth_risk_column_start, y, fourth_risk_column_start + risk_lot_edit, y + element_height, "m_EdtCurL", ""))                                                   return false;
    m_EdtCurL.ReadOnly(true);
    m_EdtCurL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblCurrentProfitMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblCurrentProfitMoney", "Reward $"))                                                     return false;
    if (!LabelCreate(m_LblCurrentProfitPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentProfitPerc", "Reward %"))                                                  return false;

    y += element_height + v_spacing;

    if (!EditCreate(m_EdtCurProfitM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtCurProfitM", ""))                                                   return false;
    m_EdtCurProfitM.ReadOnly(true);
    m_EdtCurProfitM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtCurProfitP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtCurProfitP", ""))                                                  return false;
    m_EdtCurProfitP.ReadOnly(true);
    m_EdtCurProfitP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblPotentialRiskMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblPotentialRiskMoney", "Risk $"))                                               return false;
    if (!LabelCreate(m_LblPotentialRiskPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialRiskPerc", "Risk %"))                                                    return false;
    if (!LabelCreate(m_LblPotentialLots, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialLots", "Lots"))                                                    return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblPotentialPortfolio, first_column_start, y, second_risk_column_start, y + element_height, "m_LblPotentialPortfolio", "Potential portfolio:", "Including the position being calculated"))                         return false;
    if (!EditCreate(m_EdtPotRiskM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtPotRiskM", ""))                                                   return false;
    m_EdtPotRiskM.ReadOnly(true);
    m_EdtPotRiskM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtPotRiskP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtPotRiskP", ""))                                                  return false;
    m_EdtPotRiskP.ReadOnly(true);
    m_EdtPotRiskP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtPotL, fourth_risk_column_start, y, fourth_risk_column_start + risk_lot_edit, y + element_height, "m_EdtPotL", ""))                                                   return false;
    m_EdtPotL.ReadOnly(true);
    m_EdtPotL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblPotentialProfitMoney, second_risk_column_start, y, second_risk_column_start + narrow_edit_width, y + element_height, "m_LblPotentialProfitMoney", "Reward $"))                                                  return false;
    if (!LabelCreate(m_LblPotentialProfitPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialProfitPerc", "Reward %"))                                                  return false;

    y += element_height + v_spacing;

    if (!EditCreate(m_EdtPotProfitM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtPotProfitM", ""))                                                   return false;
    m_EdtPotProfitM.ReadOnly(true);
    m_EdtPotProfitM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(m_EdtPotProfitP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtPotProfitP", ""))                                                  return false;
    m_EdtPotProfitP.ReadOnly(true);
    m_EdtPotProfitP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Margin

    // Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(m_LblPosMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblPosMargin", "Position margin:"))                               return false;
    if (!EditCreate(m_EdtPosMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtPosMargin", ""))                                                   return false;
    m_EdtPosMargin.ReadOnly(true);
    m_EdtPosMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblUsedMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblUsedMargin", "Future used margin:"))                      return false;
    if (!EditCreate(m_EdtUsedMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtUsedMargin", "            "))                              return false;
    m_EdtUsedMargin.ReadOnly(true);
    m_EdtUsedMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblFreeMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblFreeMargin", "Future free margin:"))                          return false;
    if (!EditCreate(m_EdtFreeMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtFreeMargin", ""))                                                 return false;
    m_EdtFreeMargin.ReadOnly(true);
    m_EdtFreeMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblCustomLeverage, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblCustomLeverage", "Custom leverage = 1:"))                         return false;
    if (!EditCreate(m_EdtCustomLeverage, second_margin_column_start - (int)MathRound(10 * m_DPIScale), y, second_margin_column_start + leverage_edit_width, y + element_height, "m_CustomLeverage", ""))                                              return false;
    if (!LabelCreate(m_LblAccLeverage, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale), y, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale) + wide_edit_width, y + element_height, "m_LblAccLeverage", ""))                        return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblSymbolLeverage, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale), y, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale) + wide_edit_width, y + element_height, "m_LblSymbolLeverage", "(Symbol = 1:?)"))                        return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMaxPositionSizeByMargin, first_column_start, y, first_column_start + wide_label_width, y + element_height, "m_LblMaxPositionSizeByMargin", "Maximum position size by margin:"))                         return false;
    if (!EditCreate(m_EdtMaxPositionSizeByMargin, max_psc_column_start, y, max_psc_column_start + max_psc_edit_width, y + element_height, "m_EdtMaxPositionSizeByMargin", "", "In lots"))                                                 return false;
    m_EdtMaxPositionSizeByMargin.ReadOnly(true);
    m_EdtMaxPositionSizeByMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Swaps

    // Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(m_LblSwapsType, first_column_start, y, first_column_start + narrow_edit_width, y + element_height, "m_LblSwapsType", "Type:"))                                       return false;
    if (!EditCreate(m_EdtSwapsType, first_column_start + narrow_edit_width, y, second_swaps_column_start + swap_type_edit_width, y + element_height, "m_EdtSwapsType", "Unknown"))                                                return false;
    m_EdtSwapsType.ReadOnly(true);
    m_EdtSwapsType.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblSwapsTripleDay, first_column_start, y, first_column_start + narrow_edit_width, y + element_height, "m_LblSwapsTripleDay", "Triple swap:"))                                          return false;
    if (!EditCreate(m_EdtSwapsTripleDay, first_column_start + narrow_edit_width, y, second_swaps_column_start + swap_type_edit_width, y + element_height, "m_EdtSwapsTripleDay", "?"))                                                return false;
    m_EdtSwapsTripleDay.ReadOnly(true);
    m_EdtSwapsTripleDay.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblSwapsLong, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_LblSwapsLong", "Long"))                                          return false;
    if (!LabelCreate(m_LblSwapsShort, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_LblSwapsShort", "Short"))                                         return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblSwapsNominal, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsNominal", "Nominal:"))                                          return false;
    if (!EditCreate(m_EdtSwapsNominalLong, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsNominalLong", "?"))                                                 return false;
    if (!EditCreate(m_EdtSwapsNominalShort, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsNominalShort", "?"))                                                 return false;
    m_EdtSwapsNominalLong.ReadOnly(true);
    m_EdtSwapsNominalLong.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsNominalShort.ReadOnly(true);
    m_EdtSwapsNominalShort.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblSwapsDaily, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsDaily", "Daily:"))                                        return false;
    if (!EditCreate(m_EdtSwapsDailyLongLot, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyLongLot", "?"))                                               return false;
    if (!EditCreate(m_EdtSwapsDailyShortLot, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyShortLot", "?"))                                               return false;
    if (!LabelCreate(m_LblSwapsPerLotDaily, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerLotDaily", "USD per lot"))                                         return false;
    m_EdtSwapsDailyLongLot.ReadOnly(true);
    m_EdtSwapsDailyLongLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsDailyShortLot.ReadOnly(true);
    m_EdtSwapsDailyShortLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!EditCreate(m_EdtSwapsDailyLongPS, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyLongPS", "?"))                                                 return false;
    if (!EditCreate(m_EdtSwapsDailyShortPS, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyShortPS", "?"))                                                 return false;
    if (!LabelCreate(m_LblSwapsPerPSDaily, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerPSDaily", "USD per PS ()"))                                         return false;
    m_EdtSwapsDailyLongPS.ReadOnly(true);
    m_EdtSwapsDailyLongPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsDailyShortPS.ReadOnly(true);
    m_EdtSwapsDailyShortPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblSwapsYearly, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsYearly", "Yearly:"))                                         return false;
    if (!EditCreate(m_EdtSwapsYearlyLongLot, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyLongLot", "?"))                                                 return false;
    if (!EditCreate(m_EdtSwapsYearlyShortLot, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyShortLot", "?"))                                                 return false;
    if (!LabelCreate(m_LblSwapsPerLotYearly, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerLotYearly", "USD per lot"))                                       return false;
    m_EdtSwapsYearlyLongLot.ReadOnly(true);
    m_EdtSwapsYearlyLongLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsYearlyShortLot.ReadOnly(true);
    m_EdtSwapsYearlyShortLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!EditCreate(m_EdtSwapsYearlyLongPS, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyLongPS", "?"))                                               return false;
    if (!EditCreate(m_EdtSwapsYearlyShortPS, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyShortPS", "?"))                                               return false;
    if (!LabelCreate(m_LblSwapsPerPSYearly, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerPSYearly", "USD per PS ()"))                                       return false;
    m_EdtSwapsYearlyLongPS.ReadOnly(true);
    m_EdtSwapsYearlyLongPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsYearlyShortPS.ReadOnly(true);
    m_EdtSwapsYearlyShortPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Script

    // Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(m_LblScriptExplanation, first_column_start, y, panel_end, y + element_height, "m_LblScriptExplanation", "Settings for PSC-Trader script."))                                          return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMagicNumber, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMagicNumber", "Magic number:"))                                          return false;
    if (!EditCreate(m_EdtMagicNumber, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMagicNumber", ""))                                                 return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblScriptCommentary, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblScriptCommentary", "Order commentary:"))                                        return false;
    if (!EditCreate(m_EdtScriptCommentary, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtScriptCommentary", ""))                                               return false;
    if (!CheckBoxCreate(m_ChkScriptCommentAutoSuffix, third_script_column_start, y, third_script_column_start + max_psc_edit_width, y + element_height, "m_ChkScriptCommentAutoSuffix", "Auto-suffix"))                                               return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkDisableTradingWhenLinesAreHidden, first_column_start, y, panel_end, y + element_height, "m_ChkDisableTradingWhenLinesAreHidden", "Disable trading when lines are hidden"))           return false;

    y += element_height + v_spacing;

    // Need multiple TP targets.
    if (ScriptTakeProfitsNumber > 1)
    {
        if (!LabelCreate(m_LblScriptTP, multi_tp_column_start, y, multi_tp_column_start + multi_tp_label_width, y + element_height, "m_LblScriptTP", "TP"))                                        return false;
        if (!ButtonCreate(m_BtnTPsInward, multi_tp_button_start, y, multi_tp_button_start + leverage_edit_width, y + element_height, "m_BtnTPsInward", "<<", "Fill additional TPs equidistantly between Entry and Main TP."))                                          return false;
        if (!ButtonCreate(m_BtnTPsOutward, multi_tp_button_start + leverage_edit_width + v_spacing, y, multi_tp_button_start + 2 * leverage_edit_width + v_spacing, y + element_height, "m_BtnTPsOutward", ">>", "Place additional TPs beyond the Main TP using the same distance."))                                          return false;
        if (!LabelCreate(m_LblScriptTPShare, third_script_column_start, y, third_script_column_start + normal_edit_width, y + element_height, "m_LblScriptTPShare", "Share, %"))                                       return false;

        y += element_height + v_spacing;

        ArrayResize(ScriptTPLabels, ScriptTakeProfitsNumber);
        ArrayResize(ScriptTPEdits, ScriptTakeProfitsNumber);
        ArrayResize(ScriptTPShareEdits, ScriptTakeProfitsNumber);
        for (int i = 0; i < ScriptTakeProfitsNumber; i++)
        {
            if (!LabelCreate(ScriptTPLabels[i], first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblScriptTPLabel" + IntegerToString(i + 1), "Take-profit " + IntegerToString(i + 1)))                                        return false;
            if (!EditCreate(ScriptTPEdits[i], multi_tp_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtScriptTPEdit" + IntegerToString(i + 1), ""))                                              return false;
            if (!EditCreate(ScriptTPShareEdits[i], third_script_column_start, y, third_script_column_start + leverage_edit_width, y + element_height, "m_EdtScriptTPShareEdit" + IntegerToString(i + 1), ""))                                               return false;
            y += element_height + v_spacing;
        }
    }

    if (!LabelCreate(m_LblScriptPoints, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_LblScriptPoints", "Points", ""))                                       return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMaxSlippage, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxSlippage", "Max slippage:"))                                          return false;
    if (!EditCreate(m_EdtMaxSlippage, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxSlippage", ""))                                                 return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMaxSpread, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxSpread", "Max spread:"))                                        return false;
    if (!EditCreate(m_EdtMaxSpread, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxSpread", ""))                                                 return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMaxEntrySLDistance, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxEntrySLDistance", "Max Entry/SL distance:"))                                       return false;
    if (!EditCreate(m_EdtMaxEntrySLDistance, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxEntrySLDistance", ""))                                               return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMinEntrySLDistance, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMinEntrySLDistance", "Min Entry/SL distance:"))                                       return false;
    if (!EditCreate(m_EdtMinEntrySLDistance, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMinEntrySLDistance", ""))                                               return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblScriptLots, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_LblScriptLots", "Lots"))                                          return false;

    y += element_height + v_spacing;

    if (!LabelCreate(m_LblMaxPositionSize, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxPositionSize", "Max position size:"))                                         return false;
    if (!EditCreate(m_EdtMaxPositionSize, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxPositionSize", ""))                                                 return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkSubtractPositions, first_column_start, y, panel_end, y + element_height, "m_ChkSubtractPositions", "Subtract open positions volume", "PSC-Trader will subtract currently open trades' volume from the calculated position size before opening a trade."))            return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkSubtractPendingOrders, first_column_start, y, panel_end, y + element_height, "m_ChkSubtractPendingOrders", "Subtract pending orders volume", "PSC-Trader will subtract pending orders' volume from the calculated position size before opening a trade."))           return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkDoNotApplyStopLoss, first_column_start, y, panel_end, y + element_height, "m_ChkDoNotApplyStopLoss", "Do not apply stop-loss", "PSC-Trader won't apply stop-loss to the trade it opens."))           return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkDoNotApplyTakeProfit, first_column_start, y, panel_end, y + element_height, "m_ChkDoNotApplyTakeProfit", "Do not apply take-profit", "PSC-Trader won't apply take-prfoit to the trade it opens."))           return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(m_ChkAskForConfirmation, first_column_start, y, panel_end, y + element_height, "m_ChkAskForConfirmation", "Ask for confirmation", "PSC-Trader will ask for confirmation before opening a trade."))            return false;

    InitObjects();

    return true;
}

bool QCPositionSizeCalculator::InitObjects()
{
    //+-------------------------------------+
    //| Align text in all objects.          |
    //+-------------------------------------+
    ENUM_ALIGN_MODE align = ALIGN_RIGHT;
    if (!m_EdtEntryLevel.TextAlign(align))                                   return false;
    if (!m_EdtSL.TextAlign(align))                                           return false;
    if (!m_EdtTP.TextAlign(align))                                           return false;
    if (ScriptTakeProfitsNumber > 1)
        for (int i = 0; i < ScriptTakeProfitsNumber - 1; i++)
            if (!AdditionalTPEdits[i].TextAlign(align))                      return false;
    if (!m_EdtCommissionSize.TextAlign(align))                               return false;
    if (!HideAccSize) if (!m_EdtAccount.TextAlign(align))                    return false;
    if (!m_EdtRiskPIn.TextAlign(align))                                      return false;
    if (!m_EdtRiskPRes.TextAlign(align))                                     return false;
    if (!m_EdtRiskMIn.TextAlign(align))                                      return false;
    if (!m_EdtRiskMRes.TextAlign(align))                                     return false;
    if (!m_EdtReward1.TextAlign(align))                                      return false;
    if (!m_EdtReward2.TextAlign(align))                                      return false;
    if (!m_EdtRR1.TextAlign(align))                                          return false;
    if (!m_EdtRR2.TextAlign(align))                                          return false;
    if (!m_EdtPosSize.TextAlign(align))                                      return false;
    if (ShowATROptions)
    {
        if (!m_EdtATRPeriod.TextAlign(align))                                return false;
        if (!m_EdtATRMultiplierSL.TextAlign(align))                          return false;
        if (!m_EdtATRMultiplierTP.TextAlign(align))                          return false;
    }
    if (ShowPointValue) if (!m_EdtPointValue.TextAlign(align))                   return false;
    if (!m_EdtCurRiskM.TextAlign(align))                                     return false;
    if (!m_EdtCurRiskP.TextAlign(align))                                     return false;
    if (!m_EdtCurProfitM.TextAlign(align))                                   return false;
    if (!m_EdtCurProfitP.TextAlign(align))                                   return false;
    if (!m_EdtCurL.TextAlign(align))                                         return false;
    if (!m_EdtPotRiskM.TextAlign(align))                                     return false;
    if (!m_EdtPotRiskP.TextAlign(align))                                     return false;
    if (!m_EdtPotProfitM.TextAlign(align))                                   return false;
    if (!m_EdtPotProfitP.TextAlign(align))                                   return false;
    if (!m_EdtPotL.TextAlign(align))                                         return false;
    if (!m_EdtPosMargin.TextAlign(align))                                    return false;
    if (!m_EdtUsedMargin.TextAlign(align))                                   return false;
    if (!m_EdtFreeMargin.TextAlign(align))                                   return false;
    if (!m_EdtMaxPositionSizeByMargin.TextAlign(align))                      return false;
    if (!m_EdtSwapsNominalLong.TextAlign(align))                             return false;
    if (!m_EdtSwapsNominalShort.TextAlign(align))                            return false;
    if (!m_EdtSwapsDailyLongLot.TextAlign(align))                            return false;
    if (!m_EdtSwapsDailyShortLot.TextAlign(align))                           return false;
    if (!m_EdtSwapsDailyLongPS.TextAlign(align))                             return false;
    if (!m_EdtSwapsDailyShortPS.TextAlign(align))                            return false;
    if (!m_EdtSwapsYearlyLongLot.TextAlign(align))                           return false;
    if (!m_EdtSwapsYearlyShortLot.TextAlign(align))                          return false;
    if (!m_EdtSwapsYearlyLongPS.TextAlign(align))                            return false;
    if (!m_EdtSwapsYearlyShortPS.TextAlign(align))                           return false;
    if (!m_EdtMagicNumber.TextAlign(align))                                  return false;
    // Multiple TP targets.
    if (ScriptTakeProfitsNumber > 1)
    {
        for (int i = 0; i < ScriptTakeProfitsNumber; i++)
        {
            if (!ScriptTPEdits[i].TextAlign(align))                          return false;
            if (!ScriptTPShareEdits[i].TextAlign(align))                     return false;
        }
    }
    if (!m_EdtMaxSlippage.TextAlign(align))                                  return false;
    if (!m_EdtMaxSpread.TextAlign(align))                                    return false;
    if (!m_EdtMaxEntrySLDistance.TextAlign(align))                           return false;
    if (!m_EdtMinEntrySLDistance.TextAlign(align))                           return false;
    if (!m_EdtMaxPositionSize.TextAlign(align))                              return false;

    if (sets.TPLockedOnSL) m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    else m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_BG);

    //+-------------+
    //| Init values.|
    //+-------------+
    HideRisk();
    HideMargin();
    HideMain();
    HideSwaps();
    HideScript();

    if (sets.SelectedTab == MainTab) ShowMain();
    else if (sets.SelectedTab == RiskTab) ShowRisk();
    else if (sets.SelectedTab == MarginTab) ShowMargin();
    else if (sets.SelectedTab == SwapsTab) ShowSwaps();
    else if (sets.SelectedTab == ScriptTab) ShowScript();

    if ((TP_Multiplier < 0.999) || (TP_Multiplier > 1.001))
    {
        if (!TPDistanceInPoints)
        {
            if (!m_BtnTakeProfit.Text("Take-profit x " + DoubleToString(TP_Multiplier, CountDecimalPlaces(TP_Multiplier)) + ":")) return false;
        }
        else if (!m_BtnTakeProfit.Text("TP x " + DoubleToString(TP_Multiplier, CountDecimalPlaces(TP_Multiplier)) + ":")) return false;
    }

    if (sets.EntryType)
    {
        if (!m_BtnOrderType.Text("Pending"))                                  return false;
    }
    else
    {
        if (!m_BtnOrderType.Text("Instant"))                                  return false;
        m_EdtEntryLevel.ReadOnly(true);
        m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    }

    double acc_val;

    if (!HideAccSize)
    {
        switch(sets.AccountButton)
        {
        default:
        case Balance:
            if (!m_BtnAccount.Text("Account balance"))                                 return false;
            // Custom balance.
            if (CustomBalance > 0) acc_val = CustomBalance;
            else acc_val = AccountInfoDouble(ACCOUNT_BALANCE);
            // Account balance editable.
            m_EdtAccount.ReadOnly(false);
            m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
            break;
        case Equity:
            if (!m_BtnAccount.Text("Account equity"))                          return false;
            acc_val = AccountInfoDouble(ACCOUNT_EQUITY);
            // Account balance uneditable.
            m_EdtAccount.ReadOnly(true);
            m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
            break;
        case Balance_minus_Risk:
            if (!m_BtnAccount.Text("Balance - CPR"))                               return false;
            // Custom balance.
            if (CustomBalance > 0) acc_val = CustomBalance;
            else acc_val = AccountInfoDouble(ACCOUNT_BALANCE);
            // Account balance uneditable.
            m_EdtAccount.ReadOnly(true);
            m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
            break;
        }
        // Applying additional funds (e.g. bank balance or total net worth, etc.).
        if (CustomBalance <= 0) acc_val += AdditionalFunds;
        if (!m_EdtAccount.Text(DoubleToString(acc_val, 2)))                           return false;
        // Star to show that it is not original account balance.
        if ((AdditionalFunds >= 0.01) || (AdditionalFunds <= -0.01) || ((CustomBalance > 0) && (sets.AccountButton != Equity))) m_LblAdditionalFundsAsterisk.Show();
        else m_LblAdditionalFundsAsterisk.Hide();
    }

    if (QuickRisk1 > 0)
    {
        int digits = 2;
        if (QuickRisk1 >= 100) digits = 0;
        else if (QuickRisk1 >= 10) digits = 1;
        if (!m_BtnQuickRisk1.Text(DoubleToString(QuickRisk1, digits))) return false;
    }
    if (QuickRisk2 > 0)
    {
        int digits = 2;
        if (QuickRisk2 >= 100) digits = 0;
        else if (QuickRisk2 >= 10) digits = 1;
        if (!m_BtnQuickRisk2.Text(DoubleToString(QuickRisk2, digits))) return false;
    }

    if (!m_EdtRiskPIn.Text(DoubleToString(sets.Risk, 2)))                    return false;
    if (!m_EdtRiskMIn.Text(DoubleToString(sets.MoneyRisk, 2)))               return false;

    if (ShowATROptions)
    {
        if (!m_EdtATRPeriod.Text(IntegerToString(sets.ATRPeriod)))               return false;
        if (!m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2))) return false;
        if (!m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2))) return false;
        if (sets.ATRTimeframe != PERIOD_CURRENT) m_BtnATRTimeframe.Text(EnumToString(sets.ATRTimeframe));
        else m_BtnATRTimeframe.Text("CURRENT");
    }

    if (!m_ChkCountPendings.Checked(sets.CountPendingOrders))                return false;
    if (!m_ChkIgnoreOrders.Checked(sets.IgnoreOrdersWithoutStopLoss))        return false;
    if (!m_ChkIgnoreOtherSymbols.Checked(sets.IgnoreOtherSymbols))           return false;

    // Show/hide RiskReward
    if (sets.TakeProfitLevel == 0)
    {
        if (!m_LblRR.Hide())                                                  return false;
        if (!m_EdtRR1.Hide())                                                 return false;
        if (!m_EdtRR2.Hide())                                                 return false;
        if (!m_LblReward.Hide())                                              return false;
        if (!m_EdtReward1.Hide())                                             return false;
        if (!m_EdtReward2.Hide())                                             return false;
    }

    CustomLeverage = sets.CustomLeverage;

    // Script
    if (!m_EdtMagicNumber.Text(IntegerToString(sets.MagicNumber)))                                return false;
    if (!m_EdtScriptCommentary.Text(sets.ScriptCommentary))                                       return false;
    if (!m_ChkDisableTradingWhenLinesAreHidden.Checked(sets.DisableTradingWhenLinesAreHidden)) return false;
    if (!m_EdtMaxSlippage.Text(IntegerToString(sets.MaxSlippage)))                                return false;
    if (!m_EdtMaxSpread.Text(IntegerToString(sets.MaxSpread)))                                    return false;
    if (!m_EdtMaxEntrySLDistance.Text(IntegerToString(sets.MaxEntrySLDistance)))               return false;
    if (!m_EdtMinEntrySLDistance.Text(IntegerToString(sets.MinEntrySLDistance)))               return false;
    if (!m_ChkSubtractPositions.Checked(sets.SubtractPositions))                               return false;
    if (!m_ChkSubtractPendingOrders.Checked(sets.SubtractPendingOrders))                       return false;
    if (!m_ChkDoNotApplyStopLoss.Checked(sets.DoNotApplyStopLoss))                             return false;
    if (!m_ChkDoNotApplyTakeProfit.Checked(sets.DoNotApplyTakeProfit))                         return false;
    if (!m_ChkAskForConfirmation.Checked(sets.AskForConfirmation))                             return false;

    MoveAndResize();

    DisplayValues();

    if (sets.ShowLines == false)
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
    }
    else
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }
    }

    return true;
}

// Moves elements on the panel depending on the choice of showing TP-related stuff, risk, and margin.
// Adjusts panel's height accordingly.
void QCPositionSizeCalculator::MoveAndResize()
{
    int col_height = (int)MathRound(24 * m_DPIScale);
    int new_height = col_height;
    int ref_point;

    switch(sets.SelectedTab)
    {
    case MainTab:
        ref_point = m_LblRiskM.Top();
        if (sets.TakeProfitLevel == 0)
        {
            m_LblPosSize.Move(m_LblPosSize.Left(), ref_point + 1 * col_height);
            m_BtnMaxPS.Move(m_BtnMaxPS.Left(), ref_point + 1 * col_height);
            m_EdtPosSize.Move(m_EdtPosSize.Left(), ref_point + 1 * col_height);
            ref_point = ref_point + 1 * col_height;
        }
        else
        {
            m_LblReward.Move(m_LblReward.Left(), ref_point + 1 * col_height);
            m_EdtReward1.Move(m_EdtReward1.Left(), ref_point + 1 * col_height);
            m_EdtReward2.Move(m_EdtReward2.Left(), ref_point + 1 * col_height);
            m_LblRR.Move(m_LblRR.Left(), ref_point + 2 * col_height);
            m_EdtRR1.Move(m_EdtRR1.Left(), ref_point + 2 * col_height);
            m_EdtRR2.Move(m_EdtRR2.Left(), ref_point + 2 * col_height);
            m_LblPosSize.Move(m_LblPosSize.Left(), ref_point + 3 * col_height);
            m_BtnMaxPS.Move(m_BtnMaxPS.Left(), ref_point + 3 * col_height);
            m_EdtPosSize.Move(m_EdtPosSize.Left(), ref_point + 3 * col_height);
            ref_point = ref_point + 3 * col_height;
        }
        if (ShowPointValue)
        {
            m_LblPointValue.Move(m_LblPointValue.Left(), ref_point + 1 * col_height);
            m_EdtPointValue.Move(m_EdtPointValue.Left(), ref_point + 1 * col_height);
            ref_point = ref_point + 1 * col_height;
        }
        break;
    case RiskTab:
        ref_point = m_EdtPotProfitM.Top();
        break;
    case MarginTab:
        ref_point = m_LblMaxPositionSizeByMargin.Top();
        break;
    case SwapsTab:
        ref_point = m_LblSwapsPerPSYearly.Top();
        break;
    case ScriptTab:
        ref_point = m_ChkAskForConfirmation.Top();
        break;
    default:
        ref_point = m_LblRiskM.Top();
        break;
    }
    m_LblURL.Move(m_LblURL.Left(), ref_point + col_height);
    new_height = m_LblURL.Top() + col_height - Top();

    if (!m_minimized)
    {
        // Resize window.
        Height(new_height);
        // Needed only in case of initialization when actual panel maximization is avoided.
        if (NoPanelMaximization) Width((int)MathRound(350 * m_DPIScale));
    }
    NoPanelMaximization = false;
}

bool QCPositionSizeCalculator::DisplayValues()
{
    string acc_currency = AccountCurrency();
    //=== Spread
    if (ShowSpread)
    {
        if (!Caption(PanelCaption + " | Spread: " + IntegerToString(SymbolInfoInteger(Symbol(), SYMBOL_SPREAD)))) return false;
    }
    else if (!Caption(PanelCaption)) return false;

    //=== Levels
    /* Entry Level    */ if (!m_EdtEntryLevel.Text(DoubleToString(sets.EntryLevel, _Digits)))                                  return false;
    if (!m_BtnEntry.Text(EnumToString(sets.TradeDirection)))                                          return false;
    /* Entry Warning  */ if (!m_LblEntryWarning.Text(WarningEntry))                                                        return false;

    /* Stop-Loss      */ if (!SLDistanceInPoints)
    {
        if (!m_EdtSL.Text(DoubleToString(sets.StopLossLevel, _Digits)))                                    return false;
    }
    else if (!m_EdtSL.Text(IntegerToString(sets.StopLoss)))                                   return false;

    /* SL Warning     */ if (!m_LblSLWarning.Text(WarningSL))                                                              return false;

    /* Take Profit    */ if (!TPDistanceInPoints)
    {
        if (!m_EdtTP.Text(DoubleToString(sets.TakeProfitLevel, _Digits)))                                  return false;
    }
    else if (!m_EdtTP.Text(IntegerToString(sets.TakeProfit)))                                     return false;
    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        if (!TPDistanceInPoints)
        {
            // Price level.
            if (!AdditionalTPEdits[i - 1].Text(DoubleToString(sets.ScriptTP[i], _Digits)))               return false;
        }
        else
        {
            // Points.
            string tp_text = "0";
            // If line's value was zero, then points distance should be also zero.
            if (sets.ScriptTP[i] != 0) tp_text = IntegerToString((int)MathRound(MathAbs(sets.ScriptTP[i] - sets.EntryLevel) / _Point));
            if (!AdditionalTPEdits[i - 1].Text(tp_text))                                                                         return false;
        }
    }

    /* TP Warning     */ if (!m_LblTPWarning.Text(WarningTP))                                                              return false;
    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        AdditionalTPWarnings[i - 1].Text(AdditionalWarningTP[i - 1]);
    }

    /* Account Value  */ if (!HideAccSize) if (!m_EdtAccount.Text(FormatDouble(DoubleToString(AccSize, 2))))                  return false;

    /* Account Asterisk */
    if (sets.SelectedTab == MainTab)
    {
        switch(sets.AccountButton)
        {
        default:
        case Balance:
        case Balance_minus_Risk:
            if (sets.CustomBalance > 0)
            {
                m_LblAdditionalFundsAsterisk.Show();
                ObjectSetString(ChartID(), m_name + "m_LblAdditionalFundsAsterisk", OBJPROP_TOOLTIP, "Custom balance set");
            }
            else
            {
                m_LblAdditionalFundsAsterisk.Hide();
            }
            break;
        case Equity:
            m_LblAdditionalFundsAsterisk.Hide();
            break;
        }
        if (sets.CustomBalance <= 0)
        {
            if (AdditionalFunds != 0)
            {
                m_LblAdditionalFundsAsterisk.Show();
                string tooltip = "";
                if (AdditionalFunds > 0) tooltip = "+" + DoubleToString(AdditionalFunds, 2) + " additional funds";
                else if (AdditionalFunds < 0) tooltip = DoubleToString(-AdditionalFunds, 2) + " funds subtracted";

                ObjectSetString(ChartID(), m_name + "m_LblAdditionalFundsAsterisk", OBJPROP_TOOLTIP, tooltip);
            }
        }
    }

    /* Lines */          if (sets.ShowLines)
    {
        if (!m_BtnLines.Text("Hide lines"))                                                            return false;
    }
    else
    {
        if (!m_BtnLines.Text("Show lines"))                                                            return false;
    }
    //=== ATR SL and TP
    if (ShowATROptions)
    {
        double atr = iATR(_Symbol, sets.ATRTimeframe, sets.ATRPeriod, ATRCandle);
        m_LblATRValue.Text("ATR = " + DoubleToString(atr, _Digits));
    }
    //=== Commission, risk, position size
    /* Commission size*/ if (!m_EdtCommissionSize.Text(FormatDouble(DoubleToString(sets.CommissionPerLot, 2))))            return false;
    /* Risk currency  */ if (acc_currency != "") if (!m_LblRiskM.Text("Risk, " + acc_currency + ":"))            return false;
    /* Risk In        */ if (!m_EdtRiskPIn.Text(FormatDouble(DoubleToString(DisplayRisk, 2))))                                 return false;
    /* Risk Money In  */ if (!m_EdtRiskMIn.Text(FormatDouble(DoubleToString(RiskMoney, 2))))                                   return false;
    /* Risk Money Out */ if (!m_EdtRiskMRes.Text(FormatDouble(DoubleToString(OutputRiskMoney))))                               return false;
    if ((OutputRiskMoney != 0) && (AccSize != 0))
    {
        /* Risk Out       */ if (!m_EdtRiskPRes.Text(FormatDouble(DoubleToString(Round(OutputRiskMoney / AccSize * 100, 2), 2)))) return false;
    }
    else if (!m_EdtRiskPRes.Text("0")) return false;
    /* Reward currency*/ if (acc_currency != "") if (!m_LblReward.Text("Reward, " + acc_currency + ":"))         return false;
    /* Reward 1       */ if (!m_EdtReward1.Text(FormatDouble(InputReward)))                                                return false;
    /* Reward 2       */ if (!m_EdtReward2.Text(FormatDouble(DoubleToString(OutputReward, 2))))                            return false;
    /* Risk/Reward 1  */ if (!m_EdtRR1.Text(InputRR))                                                                      return false;
    if (InputRR == "Invalid TP") m_EdtRR1.Color(clrRed);
    else m_EdtRR1.Color(m_EdtTP.Color());
    if (StringToDouble(m_EdtTP.Text()) != 0)
    {
        if (InputRR == "") m_EdtRR1.Hide();
        else if (m_EdtRR2.IsVisible()) m_EdtRR1.Show();
    }
    /* Risk/Reward 2  */ if (!m_EdtRR2.Text(OutputRR))                                                                         return false;
    if (OutputRR == "Invalid TP") m_EdtRR2.Color(clrRed);
    else m_EdtRR2.Color(m_EdtTP.Color());
    /* Position size  */ if (!m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits)))                         return false;
    if (OutputPositionSize > OutputMaxPositionSize)
    {
        m_EdtPosSize.Color(clrRed); // Calculated position size is greater than maximum position size by margin.
        ObjectSetString(ChartID(), m_name + "m_EdtPosSize", OBJPROP_TOOLTIP, "Greater than maximum position size by margin!");
    }
    else
    {
        m_EdtPosSize.Color(m_EdtTP.Color());
        ObjectSetString(ChartID(), m_name + "m_EdtPosSize", OBJPROP_TOOLTIP, "In lots");
    }
    /* Point value      */ if (ShowPointValue)
    {
        if (acc_currency != "") if (!m_LblPointValue.Text("Point value, " + acc_currency + ":")) return false;
        if (!m_EdtPointValue.Text(OutputPointValue))                                                        return false;
    }
    //=== Portfolio Risk
    /* Money label    */ if (acc_currency != "")
    {
        if (!m_LblCurrentRiskMoney.Text("Risk " + acc_currency))                            return false;
        if (!m_LblCurrentProfitMoney.Text("Reward " + acc_currency))                        return false;
        if (!m_LblPotentialRiskMoney.Text("Risk " + acc_currency))                          return false;
        if (!m_LblPotentialProfitMoney.Text("Reward " + acc_currency))                      return false;
    }
    /* Current Portfolio Risk $     */ if (!m_EdtCurRiskM.Text(PLM))                                                       return false;
    /* Current Portfolio Risk %     */ if (!m_EdtCurRiskP.Text(CPR))                                                       return false;
    /* Current Portfolio Lots       */ if (!m_EdtCurL.Text(CPL))                                                           return false;
    /* Current Portfolio Profit $   */ if (!m_EdtCurProfitM.Text(PRM))                                                     return false;
    /* Current Portfolio Profit %   */ if (!m_EdtCurProfitP.Text(CPRew))                                                   return false;
    /* Potential Portfolio Risk $   */ if (!m_EdtPotRiskM.Text(PPMR))                                                      return false;
    /* Potential Portfolio Risk %   */ if (!m_EdtPotRiskP.Text(PPR))                                                       return false;
    /* Potential Portfolio Profit $ */ if (!m_EdtPotProfitM.Text(PPMRew))                                                  return false;
    /* Potential Portfolio Profit % */ if (!m_EdtPotProfitP.Text(PPRew))                                                   return false;
    /* Potential Portfolio Lots     */ if (!m_EdtPotL.Text(PPL))                                                           return false;

    //=== Margin
    /* Position Margin         */ if (!m_EdtPosMargin.Text(FormatDouble(DoubleToString(PositionMargin, 2))))           return false;
    /* Future Used Margin      */ if (!m_EdtUsedMargin.Text(FormatDouble(DoubleToString(UsedMargin, 2))))              return false;
    /* Future Free Margin      */ if (!m_EdtFreeMargin.Text(FormatDouble(DoubleToString(FutureMargin, 2))))                return false;
    /* Custom Leverage             */ if (!m_EdtCustomLeverage.Text(IntegerToString(sets.CustomLeverage)))                     return false;
    string acc_lev = IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE));
    /* Account Leverage   */ if (acc_lev != "") if (!m_LblAccLeverage.Text("(Default = 1:" + acc_lev + ")"))                       return false;
    /* Symbol Leverage    */ if (SymbolLeverage) if (!m_LblSymbolLeverage.Text("(Symbol = 1:" + DoubleToString(SymbolLeverage, 0) + ")")) return false;

    /* Max Position size  */ if (!m_EdtMaxPositionSizeByMargin.Text(FormatDouble(DoubleToString(OutputMaxPositionSize, LotStep_digits), LotStep_digits)))          return false;
    if (!StopOut) // Black
    {
        m_LblFreeMargin.Color(C'40,41,59');
        m_EdtFreeMargin.Color(C'40,41,59');

    }
    else // Red
    {
        m_LblFreeMargin.Color(clrRed);
        m_EdtFreeMargin.Color(clrRed);
    }

    //=== Swaps
    /* Swaps Type                  */ if (!m_EdtSwapsType.Text(OutputSwapsType))                                                           return false;
    /* Swaps Triple Day            */ if (!m_EdtSwapsTripleDay.Text(SwapsTripleDay))                                                       return false;
    double swap_long = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_LONG);
    int swap_long_decimal_places = CountDecimalPlaces(swap_long);
    double swap_short = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_SHORT);
    int swap_short_decimal_places = CountDecimalPlaces(swap_short);
    /* Swaps Nominal Long            */ if (!m_EdtSwapsNominalLong.Text(DoubleToString(swap_long, swap_long_decimal_places)))    return false;
    /* Swaps Nominal Short           */ if (!m_EdtSwapsNominalShort.Text(DoubleToString(swap_short, swap_short_decimal_places))) return false;
    /* Swaps Daily Long Lot          */ if (!m_EdtSwapsDailyLongLot.Text(OutputSwapsDailyLongLot))                                         return false;
    /* Swaps Daily Short Lot         */ if (!m_EdtSwapsDailyShortLot.Text(OutputSwapsDailyShortLot))                                       return false;
    /* Swaps Label Daily per Lot     */ if (!m_LblSwapsPerLotDaily.Text(OutputSwapsCurrencyDailyLot))                              return false;
    /* Swaps Daily Long PS           */ if (!m_EdtSwapsDailyLongPS.Text(OutputSwapsDailyLongPS))                                           return false;
    /* Swaps Daily Short PS          */ if (!m_EdtSwapsDailyShortPS.Text(OutputSwapsDailyShortPS))                                         return false;
    /* Swaps Label Daily per PS  */ if (!m_LblSwapsPerPSDaily.Text(OutputSwapsCurrencyDailyPS))                            return false;
    /* Swaps Yearly Long Lot         */ if (!m_EdtSwapsYearlyLongLot.Text(OutputSwapsYearlyLongLot))                                       return false;
    /* Swaps Yearly Short Lot        */ if (!m_EdtSwapsYearlyShortLot.Text(OutputSwapsYearlyShortLot))                                 return false;
    /* Swaps Label Yearly per Lot */ if (!m_LblSwapsPerLotYearly.Text(OutputSwapsCurrencyYearlyLot))                          return false;
    /* Swaps Yearly Long PS          */ if (!m_EdtSwapsYearlyLongPS.Text(OutputSwapsYearlyLongPS))                                         return false;
    /* Swaps Yearly Short PS         */ if (!m_EdtSwapsYearlyShortPS.Text(OutputSwapsYearlyShortPS))                                       return false;
    /* Swaps Label Yearly per PS     */ if (!m_LblSwapsPerPSYearly.Text(OutputSwapsCurrencyYearlyPS))                             return false;

    //=== Script
    /* Multiple TP levels         */
    if (ScriptTakeProfitsNumber > 1)
    {
        sets.ScriptTP[0] = sets.TakeProfitLevel; // Always the main TP.
        for (int i = 0; i < ScriptTakeProfitsNumber; i++)
        {
            if (!ScriptTPEdits[i].Text(DoubleToString(sets.ScriptTP[i], _Digits)))               return false;
            if (!ScriptTPShareEdits[i].Text(IntegerToString(sets.ScriptTPShare[i])))             return false;
        }
    }
    /* Maximum Position Size      */ if (!m_EdtMaxPositionSize.Text(DoubleToString(sets.MaxPositionSize, LotStep_digits)))    return false;

    return true;
}

void QCPositionSizeCalculator::Minimize()
{
    if (sets.TradeDirection == Short) PanelCaption = "Short | " + PanelCaptionBase;
    else PanelCaption = "Long  | " + PanelCaptionBase;
    DisplayValues();
    CAppDialog::Minimize();
    sets.IsPanelMinimized = true;
    if (remember_left != -1)
    {
        Move(remember_left, remember_top);
        m_min_rect.Move(remember_left, remember_top);
    }
    IniFileSave();
}

void QCPositionSizeCalculator::Maximize()
{
    if (!NoPanelMaximization)
    {
        if (sets.TradeDirection == Short) PanelCaption = PanelCaptionBase + " Short";
        else PanelCaption = PanelCaptionBase + " Long";
        DisplayValues();
        sets.IsPanelMinimized = false;
        CAppDialog::Maximize();
    }
    else if (m_minimized) CAppDialog::Minimize();

    HideRisk();
    HideMargin();
    HideMain();
    HideSwaps();
    HideScript();

    if (!m_minimized)
    {
        if (sets.SelectedTab == MainTab) ShowMain();
        else if (sets.SelectedTab == RiskTab) ShowRisk();
        else if (sets.SelectedTab == MarginTab) ShowMargin();
        else if (sets.SelectedTab == SwapsTab) ShowSwaps();
        else if (sets.SelectedTab == ScriptTab) ShowScript();
    }

    MoveAndResize();
    if (remember_left != -1) Move(remember_left, remember_top);
}

void QCPositionSizeCalculator::RefreshValues()
{
    if (Uninitialized)
    {
        Initialization(); // Helps with 'Waiting for data'. MT4 only solution. MT5 handles this differently.
        if (Uninitialized) return; // Still uninitialized? Don't proceed further.
    }

    if ((ShowATROptions) && ((sets.ATRMultiplierSL > 0) || (sets.ATRMultiplierTP > 0)))
    {
        double atr = iATR(_Symbol, sets.ATRTimeframe, sets.ATRPeriod, ATRCandle);
        if (sets.ATRMultiplierSL > 0)
        {
            double sl = atr * sets.ATRMultiplierSL;
            if (sets.TradeDirection == Long) sets.StopLossLevel = sets.EntryLevel - sl;
            else sets.StopLossLevel = sets.EntryLevel + sl;
            sets.StopLoss = (int)MathRound(MathAbs(sets.StopLossLevel - sets.EntryLevel) / _Point);
        }
        if (sets.ATRMultiplierTP > 0)
        {
            double tp = atr * sets.ATRMultiplierTP;
            // If no ATR SL multiplier is given, TradeType should be determined by Entry-SL difference.
            if (sets.StopLossLevel < sets.EntryLevel) sets.TakeProfitLevel = sets.EntryLevel + tp;
            else sets.TakeProfitLevel = sets.EntryLevel - tp;
            sets.TakeProfit = (int)MathRound(MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / _Point);
        }
    }

    if (sets.ShowLines)
    {
        double read_value;
        if ((sets.ATRMultiplierSL == 0) || (!ShowATROptions))
        {
            if (ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_value)) sets.StopLossLevel = read_value; // Rewrite value only if line exists.
        }
        if ((sets.ATRMultiplierTP == 0) || (!ShowATROptions))
        {
            if (ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, read_value)) sets.TakeProfitLevel = read_value; // Rewrite value only if line exists.
        }
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            if (ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0, read_value)) sets.ScriptTP[i] = read_value; // Rewrite value only if line exists.
        }

        // Check and adjust for TickSize granularity.
        if (TickSize > 0)
        {
            sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
            sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            if (ScriptTakeProfitsNumber > 1)
            {
                for (int i = 0; i < ScriptTakeProfitsNumber; i++)
                {
                    sets.ScriptTP[i] = NormalizeDouble(MathRound(sets.ScriptTP[i] / TickSize) * TickSize, _Digits);
                }
            }
        }

        if (sets.EntryType == Instant)
        {
            if (!SLDistanceInPoints)
            {
                if (sets.StopLossLevel < SymbolInfoDouble(Symbol(), SYMBOL_ASK)) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
                else sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);
            }
            else
            {
                if (sets.TradeDirection == Long) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
                else sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);
            }
        }
        else // Pending
        {
            if (ObjectGetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, 0, read_value)) sets.EntryLevel = read_value; // Rewrite value only if line exists.
            // Check and adjust for TickSize granularity.
            if (TickSize > 0)
            {
                sets.EntryLevel = NormalizeDouble(MathRound(sets.EntryLevel / TickSize) * TickSize, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
            }
        }

        // Set line based on the entered SL distance.
        if (SLDistanceInPoints)
        {
            if (sets.TradeDirection == Long) sets.StopLossLevel = sets.EntryLevel - sets.StopLoss * _Point;
            else sets.StopLossLevel = sets.EntryLevel + sets.StopLoss * _Point;
            if (!StopLossLineIsBeingMoved) ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
        }

        // Set line based on the entered TP distance.
        if (TPDistanceInPoints)
        {
            if (sets.TakeProfit > 0)
            {
                if (sets.TradeDirection == Long) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfit * _Point;
                else sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
                if (!TakeProfitLineIsBeingMoved) ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            }
            // Additional take-profits.
            if (ScriptTakeProfitsNumber > 1)
            {
                for (int i = 1; i < ScriptTakeProfitsNumber; i++)
                {
                    if (sets.ScriptTP[i] != 0) // With zero points TP, keep the TP lines at zero level - as with the main TP level.
                    {
                        if (sets.TradeDirection == Long) sets.ScriptTP[i] = sets.EntryLevel + StringToDouble(AdditionalTPEdits[i - 1].Text()) * _Point;
                        else sets.ScriptTP[i] = sets.EntryLevel - StringToDouble(AdditionalTPEdits[i - 1].Text()) * _Point;
                    }
                    if (!TakeProfitLineIsBeingMoved) ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
                }
            }
        }
    }

    sets.CustomLeverage = (int)StringToInteger(m_EdtCustomLeverage.Text());

    if (sets.EntryLevel < sets.StopLossLevel) sets.TradeDirection = Short;
    else if (sets.EntryLevel > sets.StopLossLevel) sets.TradeDirection = Long;

    if (m_minimized)
    {
        if (sets.TradeDirection == Short) PanelCaption = "Short | " + PanelCaptionBase;
        else PanelCaption = "Long  | " + PanelCaptionBase;    
    }
    else
    {
        if (sets.TradeDirection == Short) PanelCaption = PanelCaptionBase + " Short";
        else PanelCaption = PanelCaptionBase + " Long";
    }
    
    if (sets.TPLockedOnSL)
    {
        tEntryLevel = sets.EntryLevel;
        tStopLossLevel = sets.StopLossLevel;
        if (sets.TakeProfitLevel == 0) ProcessTPChange(true); // When TPLockedOnSL has been enabled via an input parameter.
        else ProcessTPChange(false);
    }

    RecalculatePositionSize();
    DisplayValues();

    LastRecalculationTime = GetTickCount();
}

void QCPositionSizeCalculator::HideMain()
{
    m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    m_LblEntryLevel.Hide();
    m_BtnEntry.Hide();
    m_EdtEntryLevel.Hide();
    m_LblEntryWarning.Hide();
    if (DefaultSL > 0) m_BtnStopLoss.Hide();
    else m_LblSL.Hide();
    m_EdtSL.Hide();
    m_LblSLWarning.Hide();
    m_BtnTakeProfit.Hide();
    m_EdtTP.Hide();
    m_LblTPWarning.Hide();
    if (ScriptTakeProfitsNumber > 1)
    {
        for (int i = 0; i < ScriptTakeProfitsNumber - 1; i++)
        {
            AdditionalTPEdits[i].Hide();
            AdditionalTPLabels[i].Hide();
            AdditionalTPWarnings[i].Hide();
        }
    }
    if (ShowATROptions)
    {
        m_LblATRPeriod.Hide();
        m_LblATRMultiplierSL.Hide();
        m_LblATRMultiplierTP.Hide();
        m_EdtATRPeriod.Hide();
        m_EdtATRMultiplierSL.Hide();
        m_EdtATRMultiplierTP.Hide();
        m_LblATRValue.Hide();
        m_LblATRTimeframe.Hide();
        m_BtnATRTimeframe.Hide();
    }
    m_LblOrderType.Hide();
    m_BtnOrderType.Hide();
    m_BtnLines.Hide();
    m_LblCommissionSize.Hide();
    m_EdtCommissionSize.Hide();
    if (!HideAccSize)
    {
        m_BtnAccount.Hide();
        m_EdtAccount.Hide();
        m_LblAdditionalFundsAsterisk.Hide();
    }
    m_LblInput.Hide();
    m_LblResult.Hide();
    m_LblRisk.Hide();
    if (QuickRisk1 > 0) m_BtnQuickRisk1.Hide();
    if (QuickRisk2 > 0) m_BtnQuickRisk2.Hide();
    m_EdtRiskPIn.Hide();
    m_EdtRiskPRes.Hide();
    m_LblRiskM.Hide();
    m_EdtRiskMIn.Hide();
    m_EdtRiskMRes.Hide();
    m_LblReward.Hide();
    m_EdtReward1.Hide();
    m_EdtReward2.Hide();
    m_LblRR.Hide();
    m_EdtRR1.Hide();
    m_EdtRR2.Hide();
    m_LblPosSize.Hide();
    if (ShowMaxPSButton) m_BtnMaxPS.Hide();
    m_EdtPosSize.Hide();
    if (ShowPointValue)
    {
        m_LblPointValue.Hide();
        m_EdtPointValue.Hide();
    }
}

void QCPositionSizeCalculator::ShowMain()
{
    m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    m_LblEntryLevel.Show();
    m_BtnEntry.Show();
    m_EdtEntryLevel.Show();
    m_LblEntryWarning.Show();
    if (DefaultSL > 0) m_BtnStopLoss.Show();
    else m_LblSL.Show();
    m_EdtSL.Show();
    m_LblSLWarning.Show();
    m_BtnTakeProfit.Show();
    m_EdtTP.Show();
    m_LblTPWarning.Show();
    if (ScriptTakeProfitsNumber > 1)
    {
        for (int i = 0; i < ScriptTakeProfitsNumber - 1; i++)
        {
            AdditionalTPEdits[i].Show();
            AdditionalTPLabels[i].Show();
            AdditionalTPWarnings[i].Show();
        }
    }
    if (ShowATROptions)
    {
        m_LblATRPeriod.Show();
        m_LblATRMultiplierSL.Show();
        m_LblATRMultiplierTP.Show();
        m_EdtATRPeriod.Show();
        m_EdtATRMultiplierSL.Show();
        m_EdtATRMultiplierTP.Show();
        m_LblATRValue.Show();
        m_LblATRTimeframe.Show();
        m_BtnATRTimeframe.Show();
    }
    m_LblOrderType.Show();
    m_BtnOrderType.Show();
    m_BtnLines.Show();
    m_LblCommissionSize.Show();
    m_EdtCommissionSize.Show();
    if (!HideAccSize)
    {
        m_BtnAccount.Show();
        m_EdtAccount.Show();
        if ((AdditionalFunds >= 0.01) || (AdditionalFunds <= -0.01) || ((sets.CustomBalance > 0) && (sets.AccountButton != Equity))) m_LblAdditionalFundsAsterisk.Show();
    }
    m_LblInput.Show();
    m_LblResult.Show();
    m_LblRisk.Show();
    if (QuickRisk1 > 0) m_BtnQuickRisk1.Show();
    if (QuickRisk2 > 0) m_BtnQuickRisk2.Show();
    m_EdtRiskPIn.Show();
    m_EdtRiskPRes.Show();
    m_LblRiskM.Show();
    m_EdtRiskMIn.Show();
    m_EdtRiskMRes.Show();
    if (sets.TakeProfitLevel != 0)
    {
        m_LblReward.Show();
        m_EdtReward1.Show();
        m_EdtReward2.Show();
        m_LblRR.Show();
        if (InputRR != "") m_EdtRR1.Show();
        m_EdtRR2.Show();
    }
    m_LblPosSize.Show();
    if (ShowMaxPSButton) m_BtnMaxPS.Show();
    m_EdtPosSize.Show();
    if (ShowPointValue)
    {
        m_LblPointValue.Show();
        m_EdtPointValue.Show();
    }
}

void QCPositionSizeCalculator::HideRisk()
{
    m_BtnTabRisk.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    m_ChkCountPendings.Hide();
    m_ChkIgnoreOrders.Hide();
    m_ChkIgnoreOtherSymbols.Hide();
    m_LblCurrentPortfolio.Hide();
    m_LblPotentialPortfolio.Hide();
    m_LblCurrentRiskMoney.Hide();
    m_LblCurrentRiskPerc.Hide();
    m_LblCurrentProfitMoney.Hide();
    m_LblCurrentProfitPerc.Hide();
    m_LblPotentialRiskMoney.Hide();
    m_LblPotentialRiskPerc.Hide();
    m_LblPotentialProfitMoney.Hide();
    m_LblPotentialProfitPerc.Hide();
    m_LblCurrentLots.Hide();
    m_LblPotentialLots.Hide();
    m_EdtCurRiskM.Hide();
    m_EdtCurRiskP.Hide();
    m_EdtCurProfitM.Hide();
    m_EdtCurProfitP.Hide();
    m_EdtCurL.Hide();
    m_EdtPotRiskM.Hide();
    m_EdtPotRiskP.Hide();
    m_EdtPotProfitM.Hide();
    m_EdtPotProfitP.Hide();
    m_EdtPotL.Hide();
}

void QCPositionSizeCalculator::ShowRisk()
{
    m_BtnTabRisk.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    m_ChkCountPendings.Show();
    m_ChkIgnoreOrders.Show();
    m_ChkIgnoreOtherSymbols.Show();
    m_LblCurrentPortfolio.Show();
    m_LblPotentialPortfolio.Show();
    m_LblCurrentRiskMoney.Show();
    m_LblCurrentRiskPerc.Show();
    m_LblCurrentProfitMoney.Show();
    m_LblCurrentProfitPerc.Show();
    m_LblPotentialRiskMoney.Show();
    m_LblPotentialRiskPerc.Show();
    m_LblPotentialProfitMoney.Show();
    m_LblPotentialProfitPerc.Show();
    m_LblCurrentLots.Show();
    m_LblPotentialLots.Show();
    m_EdtCurRiskM.Show();
    m_EdtCurRiskP.Show();
    m_EdtCurProfitM.Show();
    m_EdtCurProfitP.Show();
    m_EdtCurL.Show();
    m_EdtPotRiskM.Show();
    m_EdtPotRiskP.Show();
    m_EdtPotProfitM.Show();
    m_EdtPotProfitP.Show();
    m_EdtPotL.Show();
}

void QCPositionSizeCalculator::HideMargin()
{
    m_BtnTabMargin.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    m_LblPosMargin.Hide();
    m_EdtPosMargin.Hide();
    m_LblUsedMargin.Hide();
    m_EdtUsedMargin.Hide();
    m_LblFreeMargin.Hide();
    m_EdtFreeMargin.Hide();
    m_LblCustomLeverage.Hide();
    m_EdtCustomLeverage.Hide();
    m_LblAccLeverage.Hide();
    m_LblSymbolLeverage.Hide();
    m_LblMaxPositionSizeByMargin.Hide();
    m_EdtMaxPositionSizeByMargin.Hide();
}

void QCPositionSizeCalculator::ShowMargin()
{
    m_BtnTabMargin.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    m_LblPosMargin.Show();
    m_EdtPosMargin.Show();
    m_LblUsedMargin.Show();
    m_EdtUsedMargin.Show();
    m_LblFreeMargin.Show();
    m_EdtFreeMargin.Show();
    m_LblCustomLeverage.Show();
    m_EdtCustomLeverage.Show();
    m_LblAccLeverage.Show();
    m_LblSymbolLeverage.Show();
    m_LblMaxPositionSizeByMargin.Show();
    m_EdtMaxPositionSizeByMargin.Show();
}

void QCPositionSizeCalculator::HideSwaps()
{
    m_BtnTabSwaps.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    m_LblSwapsType.Hide();
    m_EdtSwapsType.Hide();
    m_LblSwapsTripleDay.Hide();
    m_EdtSwapsTripleDay.Hide();
    m_LblSwapsLong.Hide();
    m_LblSwapsShort.Hide();
    m_LblSwapsNominal.Hide();
    m_EdtSwapsNominalLong.Hide();
    m_EdtSwapsNominalShort.Hide();
    m_LblSwapsDaily.Hide();
    m_EdtSwapsDailyLongLot.Hide();
    m_EdtSwapsDailyShortLot.Hide();
    m_LblSwapsPerLotDaily.Hide();
    m_EdtSwapsDailyLongPS.Hide();
    m_EdtSwapsDailyShortPS.Hide();
    m_LblSwapsPerPSDaily.Hide();
    m_LblSwapsYearly.Hide();
    m_EdtSwapsYearlyLongLot.Hide();
    m_EdtSwapsYearlyShortLot.Hide();
    m_LblSwapsPerLotYearly.Hide();
    m_EdtSwapsYearlyLongPS.Hide();
    m_EdtSwapsYearlyShortPS.Hide();
    m_LblSwapsPerPSYearly.Hide();
}

void QCPositionSizeCalculator::ShowSwaps()
{
    m_BtnTabSwaps.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    m_LblSwapsType.Show();
    m_EdtSwapsType.Show();
    m_LblSwapsTripleDay.Show();
    m_EdtSwapsTripleDay.Show();
    m_LblSwapsLong.Show();
    m_LblSwapsShort.Show();
    m_LblSwapsNominal.Show();
    m_EdtSwapsNominalLong.Show();
    m_EdtSwapsNominalShort.Show();
    m_LblSwapsDaily.Show();
    m_EdtSwapsDailyLongLot.Show();
    m_EdtSwapsDailyShortLot.Show();
    m_LblSwapsPerLotDaily.Show();
    m_EdtSwapsDailyLongPS.Show();
    m_EdtSwapsDailyShortPS.Show();
    m_LblSwapsPerPSDaily.Show();
    m_LblSwapsYearly.Show();
    m_EdtSwapsYearlyLongLot.Show();
    m_EdtSwapsYearlyShortLot.Show();
    m_LblSwapsPerLotYearly.Show();
    m_EdtSwapsYearlyLongPS.Show();
    m_EdtSwapsYearlyShortPS.Show();
    m_LblSwapsPerPSYearly.Show();
}

void QCPositionSizeCalculator::HideScript()
{
    m_BtnTabScript.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    m_LblScriptExplanation.Hide();
    m_LblMagicNumber.Hide();
    m_EdtMagicNumber.Hide();
    m_LblScriptCommentary.Hide();
    m_EdtScriptCommentary.Hide();
    m_ChkScriptCommentAutoSuffix.Hide();
    m_ChkDisableTradingWhenLinesAreHidden.Hide();
    // Multiple TP targets.
    if (ScriptTakeProfitsNumber > 1)
    {
        m_LblScriptTP.Hide();
        m_BtnTPsInward.Hide();
        m_BtnTPsOutward.Hide();
        m_LblScriptTPShare.Hide();
        for (int i = 0; i < ScriptTakeProfitsNumber; i++)
        {
            ScriptTPLabels[i].Hide();
            ScriptTPEdits[i].Hide();
            ScriptTPShareEdits[i].Hide();
        }
    }
    m_LblScriptPoints.Hide();
    m_LblMaxSlippage.Hide();
    m_EdtMaxSlippage.Hide();
    m_LblMaxSpread.Hide();
    m_EdtMaxSpread.Hide();
    m_LblMaxEntrySLDistance.Hide();
    m_EdtMaxEntrySLDistance.Hide();
    m_LblMinEntrySLDistance.Hide();
    m_EdtMinEntrySLDistance.Hide();
    m_LblScriptLots.Hide();
    m_LblMaxPositionSize.Hide();
    m_EdtMaxPositionSize.Hide();
    m_ChkSubtractPositions.Hide();
    m_ChkSubtractPendingOrders.Hide();
    m_ChkDoNotApplyStopLoss.Hide();
    m_ChkDoNotApplyTakeProfit.Hide();
    m_ChkAskForConfirmation.Hide();
}

void QCPositionSizeCalculator::ShowScript()
{
    m_BtnTabScript.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    m_LblScriptExplanation.Show();
    m_LblMagicNumber.Show();
    m_EdtMagicNumber.Show();
    m_LblScriptCommentary.Show();
    m_EdtScriptCommentary.Show();
    m_ChkScriptCommentAutoSuffix.Show();
    m_ChkDisableTradingWhenLinesAreHidden.Show();
    // Multiple TP targets.
    if (ScriptTakeProfitsNumber > 1)
    {
        m_LblScriptTP.Show();
        m_BtnTPsInward.Show();
        m_BtnTPsOutward.Show();
        m_LblScriptTPShare.Show();
        for (int i = 0; i < ScriptTakeProfitsNumber; i++)
        {
            ScriptTPLabels[i].Show();
            ScriptTPEdits[i].Show();
            ScriptTPShareEdits[i].Show();
        }
    }
    m_LblScriptPoints.Show();
    m_LblMaxSlippage.Show();
    m_EdtMaxSlippage.Show();
    m_LblMaxSpread.Show();
    m_EdtMaxSpread.Show();
    m_LblMaxEntrySLDistance.Show();
    m_EdtMaxEntrySLDistance.Show();
    m_LblMinEntrySLDistance.Show();
    m_EdtMinEntrySLDistance.Show();
    m_LblScriptLots.Show();
    m_LblMaxPositionSize.Show();
    m_EdtMaxPositionSize.Show();
    m_ChkSubtractPositions.Show();
    m_ChkSubtractPendingOrders.Show();
    m_ChkDoNotApplyStopLoss.Show();
    m_ChkDoNotApplyTakeProfit.Show();
    m_ChkAskForConfirmation.Show();
}

void QCPositionSizeCalculator::SeekAndDestroyDuplicatePanels()
{
    int ot = ObjectsTotal(ChartID());
    for (int i = ot - 1; i >= 0; i--)
    {
        string object_name = ObjectName(ChartID(), i);
        if (ObjectGetInteger(ChartID(), object_name, OBJPROP_TYPE) != OBJ_LABEL) continue; // Only labels are saved into templates.
        // Found m_LblPosSize object.
        if (StringSubstr(object_name, StringLen(object_name) - 12) == "m_LblPosSize")
        {
            string prefix = StringSubstr(object_name, 0, StringLen(Name()));
            // Found m_LblPosSize object with prefix different than current.
            if (prefix != Name())
            {
                ObjectsDeleteAll(ChartID(), prefix);
                // Reset object counter.
                ot = ObjectsTotal(ChartID());
                i = ot;
                Print("Deleted duplicate panel objects with prefix = ", prefix, ".");
                continue;
            }
        }
    }
}

void QCPositionSizeCalculator::ProcessTPChange(const bool tp_button_click)
{
    double tp_distance = 0;
    if ((UseCommissionToSetTPDistance) && (sets.CommissionPerLot != 0))
    {
        // Calculate potential loss as SL + Commission * 2.
        // Calculate potential profit as TP - Commission * 2.
        // TP Distance = Profit / Point_value.
        // Profit = Risk * N + Commission * 2.
        // TP distance =  (Risk * N + Commission * 2) / Point_value.
        if ((UnitCost_reward != 0) && (OutputPositionSize != 0) && (TickSize != 0))
            tp_distance = (RiskMoney * TP_Multiplier + OutputPositionSize * sets.CommissionPerLot * 2) / (OutputPositionSize * UnitCost_reward / TickSize);
        if (tEntryLevel < tStopLossLevel) tp_distance = -tp_distance;
    }
    else tp_distance = (tEntryLevel - tStopLossLevel) * TP_Multiplier;

    sets.TakeProfitLevel = NormalizeDouble(tEntryLevel + tp_distance, _Digits);

    if (tTakeProfitLevel != sets.TakeProfitLevel)
    {
        if ((ScriptTakeProfitsNumber > 1) && (tTakeProfitLevel == 0) && (sets.TakeProfitLevel != 0)) // Was zero, became non-zero.
        {
            for (int i = 0; i < ScriptTakeProfitsNumber; i++)
            {
                if (i == 0) sets.ScriptTP[i] = sets.TakeProfitLevel;
                else
                {
                    ScriptTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * double(ScriptTakeProfitsNumber - i) / double(ScriptTakeProfitsNumber)));
                    UpdateScriptTPEdit(i);
                }
            }
        }
        tTakeProfitLevel = sets.TakeProfitLevel;
        if (sets.ATRMultiplierSL > 0)
        {
            sets.ATRMultiplierTP = NormalizeDouble(sets.ATRMultiplierSL * TP_Multiplier, 2);
            m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
        }
        if (!TPDistanceInPoints) m_EdtTP.Text(DoubleToString(tTakeProfitLevel, _Digits));
        else
        {
            sets.TakeProfit = (int)MathRound(MathAbs(tTakeProfitLevel - tEntryLevel) / _Point);
            m_EdtTP.Text(IntegerToString(sets.TakeProfit));
        }
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, "Take-Profit");

            // Create multiple TP lines.
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.ScriptTP[i]);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
                ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, "Take-Profit #" + IntegerToString(i + 1));
            }
        }
        else
        {
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            // Move multiple TP lines.
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
            }
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
        }

        if (StringToDouble(m_EdtTP.Text()) == 0) // Hide.
        {
            m_LblRR.Hide();
            m_EdtRR1.Hide();
            m_EdtRR2.Hide();
            m_LblReward.Hide();
            m_EdtReward1.Hide();
            m_EdtReward2.Hide();
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
            MoveAndResize();
        }
        else // Show.
        {
            if (!m_minimized)
            {
                m_LblRR.Show();
                if (InputRR != "") m_EdtRR1.Show();
                m_EdtRR2.Show();
                m_LblReward.Show();
                m_EdtReward1.Show();
                m_EdtReward2.Show();
            }
            if (sets.ShowLines)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_BACK, false);
                if (ShowLineLabels)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                if (ShowAdditionalTPLabel)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                for (int i = 1; i < ScriptTakeProfitsNumber; i++)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_BACK, false);
                    if (ShowLineLabels)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                    if (ShowAdditionalTPLabel)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                }
            }
            HideShowMaximize();
            MoveAndResize();
        }
        // Need to call RefreshValues() only if this function is invoked from TP Button click event handler. In all other cases it is called from within RefreshValues() itself.
        if (tp_button_click)
        {
            RefreshValues();
            ChartRedraw();
        }
    }
}

//+--------------------------------------------+
//|                                            |
//|                   EVENTS                   |
//|                                            |
//+--------------------------------------------+
void QCPositionSizeCalculator::OnClickBtnTabMain()
{
    if (sets.SelectedTab != MainTab)
    {
        sets.SelectedTab = MainTab;
        ShowMain();
        HideRisk();
        HideMargin();
        HideSwaps();
        HideScript();

        MoveAndResize();
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnClickBtnTabRisk()
{
    if (sets.SelectedTab != RiskTab)
    {
        sets.SelectedTab = RiskTab;
        HideMain();
        ShowRisk();
        HideMargin();
        HideSwaps();
        HideScript();

        MoveAndResize();
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnClickBtnTabMargin()
{
    if (sets.SelectedTab != MarginTab)
    {
        sets.SelectedTab = MarginTab;
        HideRisk();
        HideMain();
        ShowMargin();
        HideSwaps();
        HideScript();

        MoveAndResize();
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnClickBtnTabSwaps()
{
    if (sets.SelectedTab != SwapsTab)
    {
        sets.SelectedTab = SwapsTab;
        HideRisk();
        HideMain();
        HideMargin();
        ShowSwaps();
        HideScript();

        MoveAndResize();
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnClickBtnTabScript()
{
    if (sets.SelectedTab != ScriptTab)
    {
        sets.SelectedTab = ScriptTab;
        HideRisk();
        HideMain();
        HideMargin();
        HideSwaps();
        ShowScript();

        MoveAndResize();
    }
}

void QCPositionSizeCalculator::OnClickBtnOrderType()
{
    sets.EntryType = (ENTRY_TYPE)!((bool)sets.EntryType);
    if (sets.EntryType == Instant)
    {
        sets.WasSelectedEntryLine = ObjectGetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, false);
        if (!m_EdtEntryLevel.ReadOnly(true))                                    return;
        if (!m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE))      return;
        m_BtnOrderType.Text("Instant");
    }
    else // Pending
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, true);
        if ((sets.WasSelectedEntryLine) || (DefaultLinesSelected)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
        if (!m_EdtEntryLevel.ReadOnly(false))                                   return;
        if (!m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE))       return;
        m_BtnOrderType.Text("Pending");
    }

    RefreshValues();
}

void QCPositionSizeCalculator::OnClickBtnAccount()
{
    switch(sets.AccountButton)
    {
    case Balance:
        // Switch to Equity.
        sets.AccountButton = Equity;
        m_BtnAccount.Text("Account equity");
        // Account balance uneditable.
        m_EdtAccount.ReadOnly(true);
        m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
        break;
    case Equity:
        // Switch to Balance minus Risk.
        sets.AccountButton = Balance_minus_Risk;
        m_BtnAccount.Text("Balance - CPR");
        // Account balance uneditable.
        m_EdtAccount.ReadOnly(true);
        m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
        break;
    default:
    case Balance_minus_Risk:
        // Switch to Balance.
        sets.AccountButton = Balance;
        m_BtnAccount.Text("Account balance");
        // Account balance editable.
        m_EdtAccount.ReadOnly(false);
        m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
        break;
    }
    RefreshValues();
}

void QCPositionSizeCalculator::OnClickBtnLines()
{
    sets.ShowLines = !sets.ShowLines;
    if (sets.ShowLines)
    {
        m_BtnLines.Text("Hide lines");
    }
    else
    {
        m_BtnLines.Text("Show lines");
    }
    if (sets.ShowLines)
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }

        if (ShowLineLabels)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_BACK, DrawTextAsBackground);
            if (ShowAdditionalSLLabel)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            }
            if (StringToDouble(m_EdtTP.Text()) != 0)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
                if (ShowAdditionalTPLabel)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                for (int i = 1; i < ScriptTakeProfitsNumber; i++)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    if (ShowAdditionalTPLabel)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                }
            }
        }

        if ((sets.WasSelectedEntryLine) && (sets.EntryType != Instant)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
        if (sets.WasSelectedStopLossLine) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
        if (sets.WasSelectedTakeProfitLine) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            if (sets.WasSelectedAdditionalTakeProfitLine[i - 1]) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
        }
        HideShowMaximize();
    }
    else
    {
        sets.WasSelectedEntryLine = ObjectGetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED);
        sets.WasSelectedStopLossLine = ObjectGetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED);
        sets.WasSelectedTakeProfitLine = ObjectGetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            sets.WasSelectedAdditionalTakeProfitLine[i - 1] = ObjectGetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED);
        }

        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
}

void QCPositionSizeCalculator::OnClickBtnStopLoss()
{
    if (sets.ATRMultiplierSL > 0) return;

    double sl_distance = DefaultSL * _Point;
    if (sets.TradeDirection == Long) sl_distance = -sl_distance;
    sets.StopLossLevel = NormalizeDouble(tEntryLevel + sl_distance, _Digits);

    if (tStopLossLevel != sets.StopLossLevel)
    {
        tStopLossLevel = sets.StopLossLevel;
        if (!SLDistanceInPoints) m_EdtSL.Text(DoubleToString(tStopLossLevel, _Digits));
        else
        {
            sets.StopLoss = (int)MathRound(MathAbs(tStopLossLevel - tEntryLevel) / _Point);
            m_EdtSL.Text(IntegerToString(sets.StopLoss));
        }
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }
}

void QCPositionSizeCalculator::OnClickBtnTakeProfit()
{
    // If "TP locked on SL" mode was on, turn it off.
    if (sets.TPLockedOnSL)
    {
        m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_BG);
        sets.TPLockedOnSL = false;
        return;
    }
    // If already have some take-profit, switch to a locked mode - TP always follows SL when Entry-SL difference changes.
    else if (sets.TakeProfitLevel != 0)
    {
        sets.TPLockedOnSL = true;
        m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    }

    ProcessTPChange(true);
}

void QCPositionSizeCalculator::OnClickBtnEntry()
{
    SwitchEntryDirection();
}

void SwitchEntryDirection()
{
    // Switch trade type.
    if (sets.TradeDirection == Long)
    {
        sets.TradeDirection = Short;

        double old_tp_distance = 0;
        if (sets.TakeProfitLevel > 0) old_tp_distance = sets.TakeProfitLevel - sets.EntryLevel;
        double old_sl_distance = sets.EntryLevel - sets.StopLossLevel;

        if (sets.EntryType == Instant) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);

        if ((ShowATROptions) && (sets.ATRMultiplierSL > 0))
        {
            sets.StopLossLevel = sets.EntryLevel + sets.StopLoss * _Point;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.EntryLevel + sets.StopLoss * _Point); // ATR stop-loss in use.
        }
        else
        {
            sets.StopLossLevel = sets.EntryLevel + old_sl_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.EntryLevel + old_sl_distance); // Other cases.
        }

        if (sets.TakeProfitLevel > 0)
        {
            if (TPDistanceInPoints) sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel - old_tp_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                if (sets.ScriptTP[i] == 0) continue;
                old_tp_distance = sets.ScriptTP[i] - sets.EntryLevel;
                sets.ScriptTP[i] = sets.EntryLevel - old_tp_distance;
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
            }
        }
    }
    else
    {
        sets.TradeDirection = Long;

        double old_tp_distance = 0;
        if (sets.TakeProfitLevel > 0) old_tp_distance = sets.EntryLevel - sets.TakeProfitLevel;
        double old_sl_distance = sets.StopLossLevel - sets.EntryLevel;

        if (sets.EntryType == Instant) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

        if ((ShowATROptions) && (sets.ATRMultiplierSL > 0))
        {
            sets.StopLossLevel = tEntryLevel - sets.StopLoss * _Point;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, tEntryLevel - sets.StopLoss * _Point); // ATR stop-loss in use.
        }
        else
        {
            sets.StopLossLevel = sets.EntryLevel - old_sl_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.EntryLevel - old_sl_distance); // Other cases.
        }

        if (sets.TakeProfitLevel > 0)
        {

            if (TPDistanceInPoints) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfitLevel * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel + old_tp_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                if (sets.ScriptTP[i] == 0) continue;
                old_tp_distance = sets.EntryLevel - sets.ScriptTP[i];
                sets.ScriptTP[i] = sets.EntryLevel + old_tp_distance;
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
            }
        }
    }

    ExtDialog.RefreshValues();
    ChartRedraw();
}

void QCPositionSizeCalculator::OnClickBtnATRTimeframe()
{
    switch(sets.ATRTimeframe)
    {
    case PERIOD_CURRENT:
        sets.ATRTimeframe = PERIOD_M1;
        break;
    case PERIOD_M1:
        sets.ATRTimeframe = PERIOD_M5;
        break;
    case PERIOD_M5:
        sets.ATRTimeframe = PERIOD_M15;
        break;
    case PERIOD_M15:
        sets.ATRTimeframe = PERIOD_M30;
        break;
    case PERIOD_M30:
        sets.ATRTimeframe = PERIOD_H1;
        break;
    case PERIOD_H1:
        sets.ATRTimeframe = PERIOD_H4;
        break;
    case PERIOD_H4:
        sets.ATRTimeframe = PERIOD_D1;
        break;
    case PERIOD_D1:
        sets.ATRTimeframe = PERIOD_W1;
        break;
    case PERIOD_W1:
        sets.ATRTimeframe = PERIOD_MN1;
        break;
    case PERIOD_MN1:
        sets.ATRTimeframe = PERIOD_CURRENT;
        break;
    default:
        sets.ATRTimeframe = (ENUM_TIMEFRAMES)_Period;
        break;
    }
    if (sets.ATRTimeframe != PERIOD_CURRENT) m_BtnATRTimeframe.Text(EnumToString(sets.ATRTimeframe));
    else m_BtnATRTimeframe.Text("CURRENT");
    RefreshValues();
}

void QCPositionSizeCalculator::OnClickBtnMaxPS()
{
    OutputPositionSize = OutputMaxPositionSize;
    sets.RiskFromPositionSize = true;
    double d_val = StringToDouble(m_EdtPosSize.Text());
    if (OutputPositionSize != d_val)
    {
        m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits));
        sets.PositionSize = OutputPositionSize;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

// Each TP is calculated to be equally spaced between main TP and Entry.
void QCPositionSizeCalculator::OnClickBtnTPsInward()
{
    if (sets.TakeProfitLevel == 0) ProcessTPChange(true); // True - for RefreshValues() call.
    for (int i = 0; i < ScriptTakeProfitsNumber; i++)
    {
        ScriptTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * double(ScriptTakeProfitsNumber - i) / double(ScriptTakeProfitsNumber)));
        UpdateScriptTPEdit(i);
    }
}

// Each TP is calculated as the previous level + main TP size.
void QCPositionSizeCalculator::OnClickBtnTPsOutward()
{
    if (sets.TakeProfitLevel == 0) ProcessTPChange(true); // True - for RefreshValues() call.
    for (int i = 0; i < ScriptTakeProfitsNumber; i++)
    {
        ScriptTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * (i + 1)));
        UpdateScriptTPEdit(i);
    }
}

void QCPositionSizeCalculator::OnClickBtnQuickRisk1()
{
    sets.UseMoneyInsteadOfPercentage = false;
    sets.RiskFromPositionSize = false;
    if (sets.Risk != QuickRisk1)
    {
        sets.Risk = QuickRisk1;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnClickBtnQuickRisk2()
{
    sets.UseMoneyInsteadOfPercentage = false;
    sets.RiskFromPositionSize = false;
    if (sets.Risk != QuickRisk2)
    {
        sets.Risk = QuickRisk2;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtEntryLevel()
{
    sets.EntryLevel = StringToDouble(m_EdtEntryLevel.Text());
    if (tEntryLevel != sets.EntryLevel)
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.EntryLevel = NormalizeDouble(MathRound(sets.EntryLevel / TickSize) * TickSize, _Digits);
        tEntryLevel = sets.EntryLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtSL()
{
    if (!SLDistanceInPoints)
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
        sets.StopLossLevel = StringToDouble(m_EdtSL.Text());
    }
    else
    {
        if ((int)StringToInteger(m_EdtSL.Text()) <= 0)
        {
            Print("StopLoss should be positive.");
            m_EdtSL.Text(IntegerToString(sets.StopLoss));
        }
        else
        {
            sets.StopLoss = (int)StringToInteger(m_EdtSL.Text());
            // Check and adjust for TickSize granularity.
            if (TickSize > 0) sets.StopLoss = (int)MathRound(MathRound(sets.StopLoss * _Point / TickSize) * TickSize / _Point);
        }

        if (sets.TradeDirection == Long)
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel + sets.StopLoss * _Point, _Digits);
        else
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel - sets.StopLoss * _Point, _Digits);
    }
    if (tStopLossLevel != sets.StopLossLevel)
    {
        tStopLossLevel = sets.StopLossLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
        if (ShowATROptions) // Update ATR multiplier after the value was changed by the user.
        {
            double atr = iATR(_Symbol, sets.ATRTimeframe, sets.ATRPeriod, ATRCandle);
            if (atr != 0) sets.ATRMultiplierSL = MathAbs(sets.StopLossLevel - sets.EntryLevel) / atr;
            m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
        }
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtTP()
{
    if (!TPDistanceInPoints)
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
        sets.TakeProfitLevel = StringToDouble(m_EdtTP.Text());
    }
    else
    {
        sets.TakeProfit = (int)StringToInteger(m_EdtTP.Text());
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TakeProfit = (int)MathRound(MathRound(sets.TakeProfit * _Point / TickSize) * TickSize / _Point);
        if (sets.TakeProfit > 0)
        {
            if (sets.TradeDirection == Long)
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel - sets.TakeProfit * _Point, _Digits);
            else
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel + sets.TakeProfit * _Point, _Digits);
        }
        else sets.TakeProfitLevel = 0;
    }

    if (tTakeProfitLevel != sets.TakeProfitLevel)
    {
        if ((ScriptTakeProfitsNumber > 1) && (tTakeProfitLevel == 0) && (sets.TakeProfitLevel != 0)) // Was zero, became non-zero.
        {
            for (int i = 0; i < ScriptTakeProfitsNumber; i++)
            {
                if (i == 0) sets.ScriptTP[i] = sets.TakeProfitLevel;
                else
                {
                    ScriptTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * double(ScriptTakeProfitsNumber - i) / double(ScriptTakeProfitsNumber)));
                    UpdateScriptTPEdit(i);
                }
            }
        }
        tTakeProfitLevel = sets.TakeProfitLevel;
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, "Take-Profit");
            // Create multiple TP lines.
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.ScriptTP[i]);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
                ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, "Take-Profit #" + IntegerToString(i + 1));
            }
        }
        else
        {
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            // Move multiple TP lines.
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
            }
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
        }

        if (StringToDouble(m_EdtTP.Text()) == 0) // Hide.
        {
            m_LblRR.Hide();
            m_EdtRR1.Hide();
            m_EdtRR2.Hide();
            m_LblReward.Hide();
            m_EdtReward1.Hide();
            m_EdtReward2.Hide();
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            for (int i = 1; i < ScriptTakeProfitsNumber; i++)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
            MoveAndResize();
        }
        else // Show.
        {
            m_LblRR.Show();
            if (InputRR != "") m_EdtRR1.Show();
            m_EdtRR2.Show();
            m_LblReward.Show();
            m_EdtReward1.Show();
            m_EdtReward2.Show();
            if (sets.ShowLines)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_BACK, false);
                if (ShowLineLabels)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                if (ShowAdditionalTPLabel)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                for (int i = 1; i < ScriptTakeProfitsNumber; i++)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_BACK, false);
                    if (ShowLineLabels)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                    if (ShowAdditionalTPLabel)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                }
            }
            HideShowMaximize();
            MoveAndResize();
        }
        if (ShowATROptions) // Update ATR multiplier after the line was moved by the user.
        {
            double atr = iATR(_Symbol, sets.ATRTimeframe, sets.ATRPeriod, ATRCandle);
            if (atr != 0) sets.ATRMultiplierTP = MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / atr;
            m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
        }
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtCommissionSize()
{
    if (sets.CommissionPerLot != StringToDouble(m_EdtCommissionSize.Text()))
    {
        sets.CommissionPerLot = StringToDouble(m_EdtCommissionSize.Text());
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtAccount()
{
    double field_value = StringToDouble(m_EdtAccount.Text());
    if (sets.CustomBalance != field_value)
    {
        if (field_value >= 0) sets.CustomBalance = field_value;
        RecalculatePositionSize();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtRiskPIn()
{
    sets.UseMoneyInsteadOfPercentage = false;
    sets.RiskFromPositionSize = false;
    if (sets.Risk != StringToDouble(m_EdtRiskPIn.Text()))
    {
        sets.Risk = StringToDouble(m_EdtRiskPIn.Text());
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtRiskMIn()
{
    string s_val = m_EdtRiskMIn.Text();
    StringReplace(s_val, ",", "");
    sets.UseMoneyInsteadOfPercentage = true;
    sets.RiskFromPositionSize = false;
    if (sets.MoneyRisk != StringToDouble(s_val))
    {
        sets.MoneyRisk = StringToDouble(s_val);
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtPosSize()
{
    sets.RiskFromPositionSize = true;

    double d_val = StringToDouble(m_EdtPosSize.Text());
    if (d_val >= 0)
    {
        if (OutputPositionSize != d_val)
        {
            OutputPositionSize = d_val;
            sets.PositionSize = OutputPositionSize;
            CalculateRiskAndPositionSize();
            DisplayValues();
        }
    }
    else m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits));
}

void QCPositionSizeCalculator::OnEndEditATRPeriod()
{
    int i_val = (int)StringToInteger(m_EdtATRPeriod.Text());
    if (i_val > 0)
    {
        if (sets.ATRPeriod != i_val)
        {
            sets.ATRPeriod = i_val;
            RefreshValues();
        }
        m_EdtATRPeriod.Text(IntegerToString(i_val));
    }
    else m_EdtATRPeriod.Text(IntegerToString(sets.ATRPeriod));
}

void QCPositionSizeCalculator::OnEndEditATRMultiplierSL()
{
    double d_val = StringToDouble(m_EdtATRMultiplierSL.Text());
    if (d_val >= 0)
    {
        if (sets.ATRMultiplierSL != d_val)
        {
            sets.ATRMultiplierSL = d_val;
            RefreshValues();
        }
        m_EdtATRMultiplierSL.Text(DoubleToString(d_val, 2));
    }
    else m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
}

void QCPositionSizeCalculator::OnEndEditATRMultiplierTP()
{
    double d_val = StringToDouble(m_EdtATRMultiplierTP.Text());
    if (d_val >= 0)
    {
        if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        if (sets.ATRMultiplierTP != d_val)
        {
            sets.ATRMultiplierTP = d_val;
            RefreshValues();
        }
        m_EdtATRMultiplierTP.Text(DoubleToString(d_val, 2));
    }
    else m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
}

void QCPositionSizeCalculator::OnChangeChkCountPendings()
{
    if (sets.CountPendingOrders != m_ChkCountPendings.Checked())
    {
        sets.CountPendingOrders = m_ChkCountPendings.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnChangeChkIgnoreOrders()
{
    if (sets.IgnoreOrdersWithoutStopLoss != m_ChkIgnoreOrders.Checked())
    {
        sets.IgnoreOrdersWithoutStopLoss = m_ChkIgnoreOrders.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnChangeChkIgnoreOtherSymbols()
{
    if (sets.IgnoreOtherSymbols != m_ChkIgnoreOtherSymbols.Checked())
    {
        sets.IgnoreOtherSymbols = m_ChkIgnoreOtherSymbols.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtCustomLeverage()
{
    sets.CustomLeverage = (int)StringToInteger(m_EdtCustomLeverage.Text());
    if (CustomLeverage != sets.CustomLeverage)
    {
        CustomLeverage = sets.CustomLeverage;
        RefreshValues();
    }
}

void QCPositionSizeCalculator::OnEndEditEdtMagicNumber()
{
    sets.MagicNumber = (int)StringToInteger(m_EdtMagicNumber.Text());
    if (sets.MagicNumber < 0)
    {
        sets.MagicNumber = -sets.MagicNumber;
        m_EdtMagicNumber.Text(IntegerToString(sets.MagicNumber));
    }
}

void QCPositionSizeCalculator::OnEndEditEdtScriptCommentary()
{
    sets.ScriptCommentary = m_EdtScriptCommentary.Text();
}

void QCPositionSizeCalculator::OnChangeChkDisableTradingWhenLinesAreHidden()
{
    sets.DisableTradingWhenLinesAreHidden = m_ChkDisableTradingWhenLinesAreHidden.Checked();
}

void QCPositionSizeCalculator::OnEndEditEdtMaxSlippage()
{
    sets.MaxSlippage = (int)StringToInteger(m_EdtMaxSlippage.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMaxSpread()
{
    sets.MaxSpread = (int)StringToInteger(m_EdtMaxSpread.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMaxEntrySLDistance()
{
    sets.MaxEntrySLDistance = (int)StringToInteger(m_EdtMaxEntrySLDistance.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMinEntrySLDistance()
{
    sets.MinEntrySLDistance = (int)StringToInteger(m_EdtMinEntrySLDistance.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMaxPositionSize()
{
    sets.MaxPositionSize = (double)StringToDouble(m_EdtMaxPositionSize.Text());
    m_EdtMaxPositionSize.Text(DoubleToString(sets.MaxPositionSize, LotStep_digits));
}

void QCPositionSizeCalculator::OnChangeChkSubtractPositions()
{
    sets.SubtractPositions = m_ChkSubtractPositions.Checked();
}

void QCPositionSizeCalculator::OnChangeChkSubtractPendingOrders()
{
    sets.SubtractPendingOrders = m_ChkSubtractPendingOrders.Checked();
}

void QCPositionSizeCalculator::OnChangeChkDoNotApplyStopLoss()
{
    sets.DoNotApplyStopLoss = m_ChkDoNotApplyStopLoss.Checked();
}

void QCPositionSizeCalculator::OnChangeChkDoNotApplyTakeProfit()
{
    sets.DoNotApplyTakeProfit = m_ChkDoNotApplyStopLoss.Checked();
}

void QCPositionSizeCalculator::OnChangeChkAskForConfirmation()
{
    sets.AskForConfirmation = m_ChkAskForConfirmation.Checked();
}

void QCPositionSizeCalculator::OnChangeChkScriptCommentAutoSuffix()
{
    sets.ScriptCommentAutoSuffix = m_ChkScriptCommentAutoSuffix.Checked();
}

//+-----------------------+
//| Working with settings |
//|+----------------------+
bool QCPositionSizeCalculator::SaveSettingsOnDisk()
{
    Print("Trying to save settings to file: " + m_FileName + ".");

    int fh;
    fh = FileOpen(m_FileName, FILE_CSV | FILE_WRITE);
    if (fh == INVALID_HANDLE)
    {
        Print("Failed to open file for writing: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
        return false;
    }

// Order does not matter.
    FileWrite(fh, "EntryType");
    FileWrite(fh, IntegerToString(sets.EntryType));
    FileWrite(fh, "EntryLevel");
    FileWrite(fh, DoubleToString(sets.EntryLevel, _Digits));
    FileWrite(fh, "StopLossLevel");
    FileWrite(fh, DoubleToString(sets.StopLossLevel, _Digits));
    FileWrite(fh, "TakeProfitLevel");
    FileWrite(fh, DoubleToString(sets.TakeProfitLevel, _Digits));
    FileWrite(fh, "Risk");
    FileWrite(fh, DoubleToString(sets.Risk, 2));
    FileWrite(fh, "MoneyRisk");
    FileWrite(fh, DoubleToString(sets.MoneyRisk, 2));
    FileWrite(fh, "CommissionPerLot");
    FileWrite(fh, DoubleToString(sets.CommissionPerLot, 2));
    FileWrite(fh, "CustomBalance");
    FileWrite(fh, DoubleToString(sets.CustomBalance, 2));
    FileWrite(fh, "UseMoneyInsteadOfPercentage");
    FileWrite(fh, IntegerToString(sets.UseMoneyInsteadOfPercentage));
    FileWrite(fh, "RiskFromPositionSize");
    FileWrite(fh, IntegerToString(sets.RiskFromPositionSize));
    if (sets.RiskFromPositionSize)
    {
        FileWrite(fh, "PositionSize");
        FileWrite(fh, DoubleToString(sets.PositionSize, LotStep_digits));
    }
    FileWrite(fh, "AccountButton");
    FileWrite(fh, IntegerToString(sets.AccountButton));
    FileWrite(fh, "CountPendingOrders");
    FileWrite(fh, IntegerToString(sets.CountPendingOrders));
    FileWrite(fh, "IgnoreOrdersWithoutStopLoss");
    FileWrite(fh, IntegerToString(sets.IgnoreOrdersWithoutStopLoss));
    FileWrite(fh, "IgnoreOtherSymbols");
    FileWrite(fh, IntegerToString(sets.IgnoreOtherSymbols));
    FileWrite(fh, "ShowLines");
    FileWrite(fh, IntegerToString(sets.ShowLines));
    FileWrite(fh, "SelectedTab");
    FileWrite(fh, IntegerToString(sets.SelectedTab));
    FileWrite(fh, "CustomLeverage");
    FileWrite(fh, IntegerToString(sets.CustomLeverage));
    FileWrite(fh, "MagicNumber");
    FileWrite(fh, IntegerToString(sets.MagicNumber));
    FileWrite(fh, "ScriptCommentary");
    FileWrite(fh, sets.ScriptCommentary);
    FileWrite(fh, "DisableTradingWhenLinesAreHidden");
    FileWrite(fh, IntegerToString(sets.DisableTradingWhenLinesAreHidden));
// Multiple TPs in use.
    if (ScriptTakeProfitsNumber > 1)
    {
        for (int i = 0; i < ScriptTakeProfitsNumber; i++)
        {
            FileWrite(fh, "ScriptTP_" + IntegerToString(i));
            FileWrite(fh, DoubleToString(sets.ScriptTP[i], _Digits));
            FileWrite(fh, "ScriptTPShare_" + IntegerToString(i));
            FileWrite(fh, IntegerToString(sets.ScriptTPShare[i]));
        }
    }
    FileWrite(fh, "MaxSlippage");
    FileWrite(fh, IntegerToString(sets.MaxSlippage));
    FileWrite(fh, "MaxSpread");
    FileWrite(fh, IntegerToString(sets.MaxSpread));
    FileWrite(fh, "MaxEntrySLDistance");
    FileWrite(fh, IntegerToString(sets.MaxEntrySLDistance));
    FileWrite(fh, "MinEntrySLDistance");
    FileWrite(fh, IntegerToString(sets.MinEntrySLDistance));
    FileWrite(fh, "MaxPositionSize");
    FileWrite(fh, DoubleToString(sets.MaxPositionSize, LotStep_digits));
    FileWrite(fh, "StopLoss");
    FileWrite(fh, IntegerToString(sets.StopLoss));
    FileWrite(fh, "TakeProfit");
    FileWrite(fh, IntegerToString(sets.TakeProfit));
    FileWrite(fh, "TradeDirection");
    FileWrite(fh, IntegerToString(sets.TradeDirection));
    FileWrite(fh, "SubtractPositions");
    FileWrite(fh, IntegerToString(sets.SubtractPositions));
    FileWrite(fh, "SubtractPendingOrders");
    FileWrite(fh, IntegerToString(sets.SubtractPendingOrders));
    FileWrite(fh, "ATRPeriod");
    FileWrite(fh, IntegerToString(sets.ATRPeriod));
    FileWrite(fh, "ATRMultiplierSL");
    FileWrite(fh, DoubleToString(sets.ATRMultiplierSL, 2));
    FileWrite(fh, "ATRMultiplierTP");
    FileWrite(fh, DoubleToString(sets.ATRMultiplierTP, 2));
    FileWrite(fh, "ATRTimeframe");
    FileWrite(fh, IntegerToString(sets.ATRTimeframe));
    FileWrite(fh, "WasSelectedEntryLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedEntryLine));
    FileWrite(fh, "WasSelectedStopLossLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedStopLossLine));
    FileWrite(fh, "WasSelectedTakeProfitLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedTakeProfitLine));
// Multiple TPs in use.
    if (ScriptTakeProfitsNumber > 1)
    {
        for (int i = 0; i < ScriptTakeProfitsNumber - 1; i++)
        {
            FileWrite(fh, "WasSelectedAdditionalTakeProfitLine_" + IntegerToString(i));
            FileWrite(fh, IntegerToString(sets.WasSelectedAdditionalTakeProfitLine[i]));
        }
    }
    FileWrite(fh, "DoNotApplyStopLoss");
    FileWrite(fh, IntegerToString(sets.DoNotApplyStopLoss));
    FileWrite(fh, "DoNotApplyTakeProfit");
    FileWrite(fh, IntegerToString(sets.DoNotApplyTakeProfit));
    FileWrite(fh, "AskForConfirmation");
    FileWrite(fh, IntegerToString(sets.AskForConfirmation));
    FileWrite(fh, "ScriptCommentAutoSuffix");
    FileWrite(fh, IntegerToString(sets.ScriptCommentAutoSuffix));
    FileWrite(fh, "IsPanelMinimized");
    FileWrite(fh, IntegerToString(sets.IsPanelMinimized));
    FileWrite(fh, "TPLockedOnSL");
    FileWrite(fh, IntegerToString(sets.TPLockedOnSL));

// These are not part of settings but are panel-related input parameters.
// When indicator is reloaded due to its input parameters change, these should be compared to the new values.
// If the value is changed, it should be updated in the panel too.
// Is indicator reloading due to the input parameters change?
    if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Parameters") > 0)
    {
        FileWrite(fh, "Parameter_DefaultTradeDirection");
        FileWrite(fh, IntegerToString(DefaultTradeDirection));
        FileWrite(fh, "Parameter_DefaultSL");
        FileWrite(fh, IntegerToString(DefaultSL));
        FileWrite(fh, "Parameter_DefaultTP");
        FileWrite(fh, IntegerToString(DefaultTP));
        FileWrite(fh, "Parameter_DefaultShowLines");
        FileWrite(fh, IntegerToString(DefaultShowLines));
        FileWrite(fh, "Parameter_DefaultLinesSelected");
        FileWrite(fh, IntegerToString(DefaultLinesSelected));
        FileWrite(fh, "Parameter_DefaultATRPeriod");
        FileWrite(fh, IntegerToString(DefaultATRPeriod));
        FileWrite(fh, "Parameter_DefaultATRMultiplierSL");
        FileWrite(fh, DoubleToString(DefaultATRMultiplierSL, 2));
        FileWrite(fh, "Parameter_DefaultATRMultiplierTP");
        FileWrite(fh, DoubleToString(DefaultATRMultiplierTP, 2));
        FileWrite(fh, "Parameter_DefaultATRTimeframe");
        FileWrite(fh, IntegerToString(DefaultATRTimeframe));
        FileWrite(fh, "Parameter_DefaultEntryType");
        FileWrite(fh, IntegerToString(DefaultEntryType));
        FileWrite(fh, "Parameter_DefaultCommission");
        FileWrite(fh, DoubleToString(DefaultCommission, 2));
        FileWrite(fh, "Parameter_DefaultAccountButton");
        FileWrite(fh, IntegerToString(DefaultAccountButton));
        FileWrite(fh, "Parameter_CustomBalance");
        FileWrite(fh, DoubleToString(CustomBalance));
        FileWrite(fh, "Parameter_DefaultRisk");
        FileWrite(fh, DoubleToString(DefaultRisk, 2));
        FileWrite(fh, "Parameter_DefaultMoneyRisk");
        FileWrite(fh, DoubleToString(DefaultMoneyRisk, 2));
        FileWrite(fh, "Parameter_DefaultCountPendingOrders");
        FileWrite(fh, IntegerToString(DefaultCountPendingOrders));
        FileWrite(fh, "Parameter_DefaultIgnoreOrdersWithoutStopLoss");
        FileWrite(fh, IntegerToString(DefaultIgnoreOrdersWithoutStopLoss));
        FileWrite(fh, "Parameter_DefaultIgnoreOtherSymbols");
        FileWrite(fh, IntegerToString(DefaultIgnoreOtherSymbols));
        FileWrite(fh, "Parameter_DefaultCustomLeverage");
        FileWrite(fh, IntegerToString(DefaultCustomLeverage));
        FileWrite(fh, "Parameter_DefaultMagicNumber");
        FileWrite(fh, IntegerToString(DefaultMagicNumber));
        FileWrite(fh, "Parameter_DefaultCommentary");
        FileWrite(fh, DefaultCommentary);
        FileWrite(fh, "Parameter_DefaultAskForConfirmation");
        FileWrite(fh, IntegerToString(DefaultScriptCommentAutoSuffix));
        FileWrite(fh, "Parameter_DefaultDisableTradingWhenLinesAreHidden");
        FileWrite(fh, IntegerToString(DefaultDisableTradingWhenLinesAreHidden));
        FileWrite(fh, "Parameter_DefaultMaxSlippage");
        FileWrite(fh, IntegerToString(DefaultMaxSlippage));
        FileWrite(fh, "Parameter_DefaultMaxSpread");
        FileWrite(fh, IntegerToString(DefaultMaxSpread));
        FileWrite(fh, "Parameter_DefaultMaxEntrySLDistance");
        FileWrite(fh, IntegerToString(DefaultMaxEntrySLDistance));
        FileWrite(fh, "Parameter_DefaultMinEntrySLDistance");
        FileWrite(fh, IntegerToString(DefaultMinEntrySLDistance));
        FileWrite(fh, "Parameter_DefaultMaxPositionSize");
        FileWrite(fh, DoubleToString(DefaultMaxPositionSize, 2));
        FileWrite(fh, "Parameter_DefaultSubtractOPV");
        FileWrite(fh, IntegerToString(DefaultSubtractOPV));
        FileWrite(fh, "Parameter_DefaultSubtractPOV");
        FileWrite(fh, IntegerToString(DefaultSubtractPOV));
        FileWrite(fh, "Parameter_DefaultDoNotApplyStopLoss");
        FileWrite(fh, IntegerToString(DefaultDoNotApplyStopLoss));
        FileWrite(fh, "Parameter_DefaultDoNotApplyTakeProfit");
        FileWrite(fh, IntegerToString(DefaultDoNotApplyTakeProfit));
        FileWrite(fh, "Parameter_DefaultAskForConfirmation");
        FileWrite(fh, IntegerToString(DefaultAskForConfirmation));
        FileWrite(fh, "Parameter_DefaultPanelPositionCorner");
        FileWrite(fh, IntegerToString(DefaultPanelPositionCorner));
        FileWrite(fh, "Parameter_DefaultPanelPositionX");
        FileWrite(fh, IntegerToString(DefaultPanelPositionX));
        FileWrite(fh, "Parameter_DefaultPanelPositionY");
        FileWrite(fh, IntegerToString(DefaultPanelPositionY));
        FileWrite(fh, "Parameter_DefaultTPLockedOnSL");
        FileWrite(fh, IntegerToString(DefaultTPLockedOnSL));
        // Not a part of sets, but needed for proper deletion of unnecessary additional TP lines.
        FileWrite(fh, "Parameter_ScriptTakeProfitsNumber");
        FileWrite(fh, IntegerToString(ScriptTakeProfitsNumber));
    }

    FileClose(fh);

    Print("Saved settings successfully.");
    return true;
}

bool QCPositionSizeCalculator::LoadSettingsFromDisk()
{
    Print("Trying to load settings from file.");

    if (!FileIsExist(m_FileName))
    {
        Print("No settings file to load.");
        return false;
    }

    int fh;
    fh = FileOpen(m_FileName, FILE_CSV | FILE_READ);

    if (fh == INVALID_HANDLE)
    {
        Print("Failed to open file for reading: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
        return false;
    }

    while (!FileIsEnding(fh))
    {
        string var_name = FileReadString(fh);
        string var_content = FileReadString(fh);
        if (var_name == "EntryType")
            sets.EntryType = (ENTRY_TYPE)StringToInteger(var_content);
        else if (var_name == "EntryLevel")
            sets.EntryLevel = StringToDouble(var_content);
        else if (var_name == "StopLossLevel")
            sets.StopLossLevel = StringToDouble(var_content);
        else if (var_name == "TakeProfitLevel")
            sets.TakeProfitLevel = StringToDouble(var_content);
        else if (var_name == "Risk")
            sets.Risk = StringToDouble(var_content);
        else if (var_name == "MoneyRisk")
            sets.MoneyRisk = StringToDouble(var_content);
        else if (var_name == "CommissionPerLot")
            sets.CommissionPerLot = StringToDouble(var_content);
        else if (var_name == "CustomBalance")
            sets.CustomBalance = StringToDouble(var_content);
        else if (var_name == "UseMoneyInsteadOfPercentage")
            sets.UseMoneyInsteadOfPercentage = (bool)StringToInteger(var_content);
        else if (var_name == "RiskFromPositionSize")
            sets.RiskFromPositionSize = (bool)StringToInteger(var_content);
        else if ((var_name == "PositionSize") && (sets.RiskFromPositionSize))
        {
            sets.PositionSize = StringToDouble(var_content);
            OutputPositionSize = sets.PositionSize;
        }
        else if (var_name == "AccountButton")
            sets.AccountButton = (ACCOUNT_BUTTON)StringToInteger(var_content);
        else if (var_name == "CountPendingOrders")
            sets.CountPendingOrders = (bool)StringToInteger(var_content);
        else if (var_name == "IgnoreOrdersWithoutStopLoss")
            sets.IgnoreOrdersWithoutStopLoss = (bool)StringToInteger(var_content);
        else if (var_name == "IgnoreOtherSymbols")
            sets.IgnoreOtherSymbols = (bool)StringToInteger(var_content);
        else if (var_name == "ShowLines")
            sets.ShowLines = (bool)StringToInteger(var_content);
        else if (var_name == "SelectedTab")
            sets.SelectedTab = (TABS)StringToInteger(var_content);
        else if (var_name == "CustomLeverage")
            sets.CustomLeverage = (int)StringToInteger(var_content);
        else if (var_name == "MagicNumber")
            sets.MagicNumber = (int)StringToInteger(var_content);
        else if (var_name == "ScriptCommentary")
            sets.ScriptCommentary = var_content;
        else if (var_name == "ScriptCommentAutoSuffix")
            sets.ScriptCommentAutoSuffix = (bool)StringToInteger(var_content);
        else if (var_name == "DisableTradingWhenLinesAreHidden")
            sets.DisableTradingWhenLinesAreHidden = (bool)StringToInteger(var_content);
        // Multiple TPs.
        else if ((ScriptTakeProfitsNumber > 1) && (StringSubstr(var_name, 0, 9) == "ScriptTP_"))
        {
            int i = (int)StringToInteger(StringSubstr(var_name, 9)); // This TP's number.
            if (i > ScriptTakeProfitsNumber - 1) continue; // Cannot accommodate so many.
            sets.ScriptTP[i] = StringToDouble(var_content);
        }
        else if ((ScriptTakeProfitsNumber > 1) && (StringSubstr(var_name, 0, 14) == "ScriptTPShare_"))
        {
            int i = (int)StringToInteger(StringSubstr(var_name, 14)); // This TP Share's number.
            if (i > ScriptTakeProfitsNumber - 1) continue; // Cannot accommodate so many.
            sets.ScriptTPShare[i] = (int)StringToInteger(var_content);
        }
        else if (var_name == "MaxSlippage")
            sets.MaxSlippage = (int)StringToInteger(var_content);
        else if (var_name == "MaxSpread")
            sets.MaxSpread = (int)StringToInteger(var_content);
        else if (var_name == "MaxEntrySLDistance")
            sets.MaxEntrySLDistance = (int)StringToInteger(var_content);
        else if (var_name == "MinEntrySLDistance")
            sets.MinEntrySLDistance = (int)StringToInteger(var_content);
        else if (var_name == "MaxPositionSize")
            sets.MaxPositionSize = StringToDouble(var_content);
        else if (var_name == "TradeDirection")
            sets.TradeDirection = (TRADE_DIRECTION)StringToInteger(var_content);
        else if (var_name == "StopLoss")
            sets.StopLoss = (int)StringToInteger(var_content);
        else if (var_name == "TakeProfit")
            sets.TakeProfit = (int)StringToInteger(var_content);
        else if (var_name == "SubtractPositions")
            sets.SubtractPositions = (bool)StringToInteger(var_content);
        else if (var_name == "SubtractPendingOrders")
            sets.SubtractPendingOrders = (bool)StringToInteger(var_content);
        else if (var_name == "ATRPeriod")
            sets.ATRPeriod = (int)StringToInteger(var_content);
        else if (var_name == "ATRMultiplierSL")
            sets.ATRMultiplierSL = StringToDouble(var_content);
        else if (var_name == "ATRMultiplierTP")
            sets.ATRMultiplierTP = StringToDouble(var_content);
        else if (var_name == "ATRTimeframe")
            sets.ATRTimeframe = (ENUM_TIMEFRAMES)StringToInteger(var_content);
        else if (var_name == "WasSelectedEntryLine")
            sets.WasSelectedEntryLine = (bool)StringToInteger(var_content);
        else if (var_name == "WasSelectedStopLossLine")
            sets.WasSelectedStopLossLine = (bool)StringToInteger(var_content);
        else if (var_name == "WasSelectedTakeProfitLine")
            sets.WasSelectedTakeProfitLine = (bool)StringToInteger(var_content);
        // Multiple TPs.
        else if ((ScriptTakeProfitsNumber > 1) && (StringSubstr(var_name, 0, 36) == "WasSelectedAdditionalTakeProfitLine_"))
        {
            int i = (int)StringToInteger(StringSubstr(var_name, 36)); // This TP's number.
            if (i > ScriptTakeProfitsNumber - 2) continue; // Cannot accommodate so many.
            sets.WasSelectedAdditionalTakeProfitLine[i] = StringToInteger(var_content);
        }
        else if (var_name == "DoNotApplyStopLoss")
            sets.DoNotApplyStopLoss = (bool)StringToInteger(var_content);
        else if (var_name == "DoNotApplyTakeProfit")
            sets.DoNotApplyTakeProfit = (bool)StringToInteger(var_content);
        else if (var_name == "AskForConfirmation")
            sets.AskForConfirmation = (bool)StringToInteger(var_content);
        else if (var_name == "IsPanelMinimized")
            sets.IsPanelMinimized = (bool)StringToInteger(var_content);
        else if (var_name == "TPLockedOnSL")
            sets.TPLockedOnSL = (bool)StringToInteger(var_content);

        // Is indicator reloading due to the input parameters change?
        if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Parameters") > 0)
        {
            // These are not part of settings but are panel-related input parameters.
            // When indicator is reloaded due to its input parameters change, these should be compared to the new values.
            // If the value is changed, it should be updated in the panel too.
            if (var_name == "Parameter_DefaultTradeDirection")
            {
                if ((TRADE_DIRECTION)StringToInteger(var_content) != DefaultTradeDirection) sets.TradeDirection = DefaultTradeDirection;
            }
            else if (var_name == "Parameter_DefaultShowLines")
            {
                if ((bool)StringToInteger(var_content) != DefaultShowLines) sets.ShowLines = DefaultShowLines;
            }
            else if (var_name == "Parameter_DefaultSL")
            {
                if (StringToInteger(var_content) != DefaultSL)
                {
                    // Will be set to actual value via Initialization().
                    sets.StopLossLevel = 0;
                    sets.StopLoss = 0;
                }
            }
            else if (var_name == "Parameter_DefaultTP")
            {
                if (StringToInteger(var_content) != DefaultTP)
                {
                    // Will be set to actual value via Initialization().
                    sets.TakeProfitLevel = 0;
                    sets.TakeProfit = 0;
                }
            }
            else if (var_name == "Parameter_DefaultLinesSelected")
            {
                if ((bool)StringToInteger(var_content) != DefaultLinesSelected)
                {
                    if (DefaultLinesSelected) LinesSelectedStatus = 1; // Flip lines to selected.
                    else LinesSelectedStatus = 2; // Flip lines to unselected.
                    // Actual flipping happens inside Initialization() function.
                }
                else LinesSelectedStatus = 0; // No change.
            }
            else if (var_name == "Parameter_DefaultATRPeriod")
            {
                if (StringToInteger(var_content) != DefaultATRPeriod) sets.ATRPeriod = DefaultATRPeriod;
            }
            else if (var_name == "Parameter_DefaultATRMultiplierSL")
            {
                if (StringToDouble(var_content) != DefaultATRMultiplierSL) sets.ATRMultiplierSL = DefaultATRMultiplierSL;
            }
            else if (var_name == "Parameter_DefaultATRMultiplierTP")
            {
                if (StringToDouble(var_content) != DefaultATRMultiplierTP) sets.ATRMultiplierTP = DefaultATRMultiplierTP;
            }
            else if (var_name == "Parameter_DefaultATRTimeframe")
            {
                if ((ENUM_TIMEFRAMES)StringToInteger(var_content) != DefaultATRTimeframe) sets.ATRTimeframe = DefaultATRTimeframe;
            }
            else if (var_name == "Parameter_DefaultEntryType")
            {
                if ((ENTRY_TYPE)StringToInteger(var_content) != DefaultEntryType) sets.EntryType = DefaultEntryType;
            }
            else if (var_name == "Parameter_DefaultCommission")
            {
                if (StringToDouble(var_content) != DefaultCommission) sets.CommissionPerLot = DefaultCommission;
            }
            else if (var_name == "Parameter_DefaultAccountButton")
            {
                if ((ACCOUNT_BUTTON)StringToInteger(var_content) != DefaultAccountButton) sets.AccountButton = DefaultAccountButton;
            }
            else if (var_name == "Parameter_CustomBalance")
            {
                if (StringToDouble(var_content) != CustomBalance) sets.CustomBalance = CustomBalance;
            }
            else if (var_name == "Parameter_DefaultRisk")
            {
                if (StringToDouble(var_content) != DefaultRisk) sets.Risk = DefaultRisk;
            }
            else if (var_name == "Parameter_DefaultMoneyRisk")
            {
                if ((StringToDouble(var_content) != DefaultMoneyRisk) && (DefaultMoneyRisk > 0))
                {
                    sets.MoneyRisk = DefaultMoneyRisk;
                    sets.UseMoneyInsteadOfPercentage = true;
                }
                else sets.UseMoneyInsteadOfPercentage = false;
            }
            else if (var_name == "Parameter_DefaultCountPendingOrders")
            {
                if ((bool)StringToInteger(var_content) != DefaultCountPendingOrders) sets.CountPendingOrders = DefaultCountPendingOrders;
            }
            else if (var_name == "Parameter_DefaultIgnoreOrdersWithoutStopLoss")
            {
                if ((bool)StringToInteger(var_content) != DefaultIgnoreOrdersWithoutStopLoss) sets.IgnoreOrdersWithoutStopLoss = DefaultIgnoreOrdersWithoutStopLoss;
            }
            else if (var_name == "Parameter_DefaultIgnoreOtherSymbols")
            {
                if ((bool)StringToInteger(var_content) != DefaultIgnoreOtherSymbols) sets.IgnoreOtherSymbols = DefaultIgnoreOtherSymbols;
            }
            else if (var_name == "Parameter_DefaultCustomLeverage")
            {
                if (StringToInteger(var_content) != DefaultCustomLeverage) sets.CustomLeverage = DefaultCustomLeverage;
            }
            else if (var_name == "Parameter_DefaultMagicNumber")
            {
                if (StringToInteger(var_content) != DefaultMagicNumber) sets.MagicNumber = DefaultMagicNumber;
            }
            else if (var_name == "Parameter_DefaultCommentary")
            {
                if (var_content != DefaultCommentary) sets.ScriptCommentary = DefaultCommentary;
            }
            else if (var_name == "Parameter_DefaultScriptCommentAutoSuffix")
            {
                if ((bool)StringToInteger(var_content) != DefaultScriptCommentAutoSuffix) sets.ScriptCommentAutoSuffix = DefaultScriptCommentAutoSuffix;
            }
            else if (var_name == "Parameter_DefaultDisableTradingWhenLinesAreHidden")
            {
                if ((bool)StringToInteger(var_content) != DefaultDisableTradingWhenLinesAreHidden) sets.DisableTradingWhenLinesAreHidden = DefaultDisableTradingWhenLinesAreHidden;
            }
            else if (var_name == "Parameter_DefaultMaxSlippage")
            {
                if (StringToInteger(var_content) != DefaultMaxSlippage) sets.MaxSlippage = DefaultMaxSlippage;
            }
            else if (var_name == "Parameter_DefaultMaxSpread")
            {
                if (StringToInteger(var_content) != DefaultMaxSpread) sets.MaxSpread = DefaultMaxSpread;
            }
            else if (var_name == "Parameter_DefaultMaxEntrySLDistance")
            {
                if (StringToInteger(var_content) != DefaultMaxEntrySLDistance) sets.MaxEntrySLDistance = DefaultMaxEntrySLDistance;
            }
            else if (var_name == "Parameter_DefaultMinEntrySLDistance")
            {
                if (StringToInteger(var_content) != DefaultMinEntrySLDistance) sets.MinEntrySLDistance = DefaultMinEntrySLDistance;
            }
            else if (var_name == "Parameter_DefaultMaxPositionSize")
            {
                if (StringToDouble(var_content) != DefaultMaxPositionSize) sets.MaxPositionSize = DefaultMaxPositionSize;
            }
            else if (var_name == "Parameter_DefaultSubtractOPV")
            {
                if ((bool)StringToInteger(var_content) != DefaultSubtractOPV) sets.SubtractPositions = DefaultSubtractOPV;
            }
            else if (var_name == "Parameter_DefaultSubtractPOV")
            {
                if ((bool)StringToInteger(var_content) != DefaultSubtractPOV) sets.SubtractPendingOrders = DefaultSubtractPOV;
            }
            else if (var_name == "Parameter_DefaultDoNotApplyStopLoss")
            {
                if ((bool)StringToInteger(var_content) != DefaultDoNotApplyStopLoss) sets.DoNotApplyStopLoss = DefaultDoNotApplyStopLoss;
            }
            else if (var_name == "Parameter_DefaultDoNotApplyTakeProfit")
            {
                if ((bool)StringToInteger(var_content) != DefaultDoNotApplyTakeProfit) sets.DoNotApplyTakeProfit = DefaultDoNotApplyTakeProfit;
            }
            else if (var_name == "Parameter_DefaultAskForConfirmation")
            {
                if ((bool)StringToInteger(var_content) != DefaultAskForConfirmation) sets.AskForConfirmation = DefaultAskForConfirmation;
            }
            // These three only trigger panel repositioning (default position changed via the input parameters deliberately).
            else if (var_name == "Parameter_DefaultPanelPositionCorner")
            {
                if ((ENUM_BASE_CORNER)StringToInteger(var_content) != DefaultPanelPositionCorner) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
            }
            else if (var_name == "Parameter_DefaultPanelPositionX")
            {
                if (StringToInteger(var_content) != DefaultPanelPositionX) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
            }
            else if (var_name == "Parameter_DefaultPanelPositionY")
            {
                if (StringToInteger(var_content) != DefaultPanelPositionY) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
            }
            else if (var_name == "Parameter_DefaultTPLockedOnSL")
            {
                if (StringToInteger(var_content) != DefaultTPLockedOnSL) sets.TPLockedOnSL = DefaultTPLockedOnSL;
            }
            // Not a part of sets, but needed for proper deletion of unnecessary additional TP lines.
            else if (var_name == "Parameter_ScriptTakeProfitsNumber")
            {
                if (StringToInteger(var_content) > ScriptTakeProfitsNumber) // Only if new input parameter value is lower, which means fewer TP lines.
                {
                    int old_STPN = (int)StringToInteger(var_content);
                    for (int i = old_STPN - 1; i >= ScriptTakeProfitsNumber; i--)
                        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i)); // Delete remaining additional TP lines.
                }
            }
        }
    }

    FileClose(fh);
    Print("Loaded settings successfully.");

    // Is indicator reloading due to the input parameters change? Delete the flag variable.
    if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Parameters") > 0) GlobalVariableDel("PSC-" + IntegerToString(ChartID()) + "-Parameters");

    return true;
}

bool QCPositionSizeCalculator::DeleteSettingsFile()
{
    if (!FileIsExist(m_FileName))
    {
        Print("No settings file to delete.");
        return false;
    }
    Print("Trying to delete settings file.");
    if (!FileDelete(m_FileName))
    {
        Print("Failed to delete file: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
        return false;
    }
    Print("Deleted settings file successfully.");
    return true;
}

void QCPositionSizeCalculator::HideShowMaximize()
{
    // Remember the panel's location.
    remember_left = Left();
    remember_top = Top();

    Hide();
    Show();
    NoPanelMaximization = true;
    Maximize();
}

//+------------------------------------------------------------------+
//| Bypasses the bug in program name detection in Dialog.mqh.        |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::IniFileSave()
{
    int handle = FileOpen(m_IniFileName, FILE_WRITE | FILE_BIN | FILE_ANSI);

    if (handle != INVALID_HANDLE)
    {
        Save(handle);
        FileClose(handle);
    }
}

//+------------------------------------------------------------------+
//| Bypasses the bug in program name detection in Dialog.mqh.        |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::IniFileLoad(void)
{
    int handle = FileOpen(m_IniFileName, FILE_READ | FILE_BIN | FILE_ANSI);

    if (handle != INVALID_HANDLE)
    {
        Load(handle);
        FileClose(handle);
    }

    InitObjects(); // Sets panel elements that changed based on changes in input parameters, overwriting the INI settings.
}

//+-------------------------------------------------------------------+
//| Extends CAppDialog::IniFileName() to use our custom ini filename. |
//+-------------------------------------------------------------------+
string QCPositionSizeCalculator::IniFileName(void) const
{
    string name = m_IniFileName;
    StringReplace(name, ".dat", ""); // Remove extension from our IniFileName.
    return(name);
}

//+------------------------------------------------------------------+
//| Update Fixed SL distance in points if the line got moved.        |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::UpdateFixedSL()
{
    double read_value;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_value)) return; // Update only if line exists.
    else sets.StopLossLevel = read_value;

// Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }
    sets.StopLoss = (int)MathRound(MathAbs(sets.StopLossLevel - sets.EntryLevel) / _Point);
    m_EdtSL.Text(IntegerToString(sets.StopLoss));

    if (ShowATROptions) // Update ATR multiplier after the line was moved by the user.
    {
        double atr = iATR(_Symbol, sets.ATRTimeframe, sets.ATRPeriod, ATRCandle);
        if (atr != 0) sets.ATRMultiplierSL = MathAbs(sets.StopLossLevel - sets.EntryLevel) / atr;
        m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
    }

    if (sets.StopLossLevel < sets.EntryLevel)
    {
        sets.TradeDirection = Long;
    }
    else
    {
        sets.TradeDirection = Short;
    }
}

//+------------------------------------------------------------------+
//| Update Fixed TP distance in points if the line got moved.        |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::UpdateFixedTP()
{
    double read_value;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, read_value)) return; // Update only if line exists.
    else sets.TakeProfitLevel = read_value;

    // Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
        ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
    }
    sets.TakeProfit = (int)MathRound(MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / _Point);
    m_EdtTP.Text(IntegerToString(sets.TakeProfit));

    if (ShowATROptions) // Update ATR multiplier after the line was moved by the user.
    {
        double atr = iATR(_Symbol, sets.ATRTimeframe, sets.ATRPeriod, ATRCandle);
        if (atr != 0) sets.ATRMultiplierTP = MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / atr;
        m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
    }
}

//+------------------------------------------------------------------+
//| Update Additional Fixed TP distance in points if the line got    |
//| moved. Used when multiple TPs are set.                           |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::UpdateAdditionalFixedTP(int i)
{
    double read_value;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0, read_value)) return; // Update only if line exists.
    else sets.ScriptTP[i] = read_value;

    // Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.ScriptTP[i] = NormalizeDouble(MathRound(sets.ScriptTP[i] / TickSize) * TickSize, _Digits);
        ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
    }
    string tp_text = "0";
    // If line's value was zero, then points distance should be also zero.
    if (sets.ScriptTP[i] != 0) tp_text = IntegerToString((int)MathRound(MathAbs(sets.ScriptTP[i] - sets.EntryLevel) / _Point));
    AdditionalTPEdits[i - 1].Text(tp_text);
}

//+------------------------------------------------------------------+
//| Update respective sets structure value after one of the multiple |
//| TP fields has been changed on the Script tab.                    |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::UpdateScriptTPEdit(int i)
{
    // First, do the formatting.
    double new_value = StringToDouble(ScriptTPEdits[i].Text());
    // Adjust for tick size granularity.
    if (TickSize > 0) new_value = NormalizeDouble(MathRound(new_value / TickSize) * TickSize, _Digits);
    string s = DoubleToString(new_value, _Digits);
    ScriptTPEdits[i].Text(s);
    if (i > 0)
    {
        if (!TPDistanceInPoints) AdditionalTPEdits[i - 1].Text(s); // TP as level.
        else AdditionalTPEdits[i - 1].Text(IntegerToString((int)MathRound(MathAbs(new_value - sets.EntryLevel) / _Point))); // TP as distance.
    }

    // Remember the value.
    new_value = StringToDouble(s);
    sets.ScriptTP[i] = new_value;

    // If it was the first TP field on the Script tab, and the TP field on the Main tab was empty - fill it and show the line.
    if ((i == 0) && (sets.TakeProfitLevel == 0) && (new_value > 0))
    {
        if (TPDistanceInPoints)
        {
            if (sets.TradeDirection == Long)
                m_EdtTP.Text(IntegerToString((int)MathRound(MathAbs(new_value - sets.EntryLevel) / _Point)));
            else
                m_EdtTP.Text(IntegerToString((int)MathRound(MathAbs(sets.EntryLevel - new_value) / _Point)));
        }
        else
        {
            sets.TakeProfitLevel = new_value;
            m_EdtTP.Text(s);
        }
    }

    ProcessLineObjectsAfterUpdatingMultipleTP(i);
}

//+------------------------------------------------------------------+
//| Update respective sets structure value after one of the multiple |
//| TP fields has been changed on the Main tab.                      |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::UpdateAdditionalTPEdit(int i)
{
    // First, do the formatting.
    double new_value = StringToDouble(AdditionalTPEdits[i - 1].Text());

    // TP as level.
    if (!TPDistanceInPoints)
    {
        // Adjust for tick size granularity.
        if (TickSize > 0) new_value = NormalizeDouble(MathRound(new_value / TickSize) * TickSize, _Digits);
        string s = DoubleToString(new_value, _Digits);
        AdditionalTPEdits[i - 1].Text(s);
        ScriptTPEdits[i].Text(s);

        // Remember the value.
        new_value = StringToDouble(s);
        sets.ScriptTP[i] = new_value;
    }
    // TP as distance.
    else
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) new_value = MathRound(MathRound(new_value * _Point / TickSize) * TickSize / _Point);
        double TP = 0;
        if (new_value > 0)
        {
            if (sets.TradeDirection == Long)
            {
                TP = NormalizeDouble(sets.EntryLevel + new_value * _Point, _Digits);
            }
            else
            {
                TP = NormalizeDouble(sets.EntryLevel - new_value * _Point, _Digits);
            }
        }
        AdditionalTPEdits[i - 1].Text(DoubleToString(new_value, 0)); // Fixed granularity.
        ScriptTPEdits[i].Text(DoubleToString(TP, _Digits));
        sets.ScriptTP[i] = TP;
    }

    ProcessLineObjectsAfterUpdatingMultipleTP(i);
}

//+-------------------------------------------------------------------+
//| Move TP line objects after updating one of the multiple TP fields.|
//+-------------------------------------------------------------------+
void QCPositionSizeCalculator::ProcessLineObjectsAfterUpdatingMultipleTP(int i)
{
    string postfix = IntegerToString(i);
    if (i == 0) postfix = "";
// Process objects.
    ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_PRICE, sets.ScriptTP[i]);
    if (sets.ScriptTP[i] == 0) // Hide.
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_SELECTED, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
    else // Show.
    {
        if (sets.ShowLines)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_SELECTED, true);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_BACK, false);
            if (ShowLineLabels)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + postfix, OBJPROP_BACK, DrawTextAsBackground);
            }
            if (ShowAdditionalTPLabel)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + postfix, OBJPROP_BACK, DrawTextAsBackground);
            }
        }
        HideShowMaximize();
    }
}

//+------------------------------------------------------------------+
//| Update respective sets structure value after one of the multiple |
//| TP share fields has been changed.                                |
//+------------------------------------------------------------------+
void QCPositionSizeCalculator::UpdateScriptTPShareEdit(int i)
{
// First, do the formatting.
    int new_value = (int)StringToInteger(ScriptTPShareEdits[i].Text());
    if (new_value > 100) new_value = 100;
    else if (new_value < 0) new_value = 0;
    ScriptTPShareEdits[i].Text(IntegerToString(new_value));
// Remember the value.
    sets.ScriptTPShare[i] = new_value;
}

// Check if all required lines exist and restore them if they have been accidentally deleted.
void QCPositionSizeCalculator::CheckAndRestoreLines()
{
    bool RestoredSomething = false;

    if (ObjectFind(ChartID(), ObjectPrefix + "EntryLine") == -1)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "EntryLine", OBJ_HLINE, 0, TimeCurrent(), sets.EntryLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_STYLE, entry_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_COLOR, entry_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_WIDTH, entry_line_width);
        ObjectSetString(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TOOLTIP, "Entry");
        if (sets.EntryType == Instant) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, false);
        else
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, true);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
        }
        if (!sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        RestoredSomething = true;
    }

    if (ObjectFind(ChartID(), ObjectPrefix + "StopLossLine") == -1)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "StopLossLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopLossLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_STYLE, stoploss_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_COLOR, stoploss_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_WIDTH, stoploss_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTABLE, true);
        ObjectSetString(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TOOLTIP, "Stop-Loss");
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
        if (!sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        RestoredSomething = true;
    }

    if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
        if ((sets.ShowLines) && ((sets.TakeProfitLevel > 0) || ((sets.ATRMultiplierTP > 0) && (ShowATROptions)))) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
        ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, "Take-Profit");
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
        RestoredSomething = true;
    }

// Process multiple TP lines.
    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i)) == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.ScriptTP[i]);
            if ((sets.ShowLines) && (sets.ScriptTP[i] > 0)) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, "Take-Profit #" + IntegerToString(i + 1));
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
            RestoredSomething = true;
        }
    }
// Put panel on top of the lines that were created later.
    if (RestoredSomething) HideShowMaximize();
}

//+------------------------------------------------+
//|                                                |
//|              Calculation Functions             |
//|                                                |
//+------------------------------------------------+

//==================================================================================================================
// Used in more than one function.
double AccSize, OutputRiskMoney;
double OutputPositionSize, OutputMaxPositionSize;
double StopLoss;
double tEntryLevel, tStopLossLevel, tTakeProfitLevel;
// -1 because it is checked in the initialization function.
double TickSize = -1, MarginHedging, LotSize, MinLot, MaxLot, LotStep, UnitCost_reward;
int AccStopoutMode, AccStopoutLevel, LotStep_digits;
int CustomLeverage = 0;
double OriginalPreHedgingPositionMargin = 0; // For calculating symbol leverage when we apply some CustomLeverage.
double SymbolLeverage = 1;
bool StopOut;

//----
string WarningEntry = "", WarningSL = "", WarningTP = "", AdditionalWarningTP[];
double DisplayRisk, RiskMoney, PositionMargin, UsedMargin, FutureMargin, PreHedgingPositionMargin, PortfolioLossMoney = 0;
string InputRR, OutputRR, MainOutputRR, PLM, CPR, PRM, CPRew, PPMR, PPR, PPMRew, PPRew, CPL, PPL, AdditionalOutputRR[];
string InputReward;
double OutputReward, AdditionalOutputReward[], MainOutputReward;
string OutputPointValue = "", OutputSwapsType = "Unknown", SwapsTripleDay = "?",
       OutputSwapsDailyLongLot = "?", OutputSwapsDailyShortLot = "?", OutputSwapsDailyLongPS = "?", OutputSwapsDailyShortPS = "?",
       OutputSwapsYearlyLongLot = "?", OutputSwapsYearlyShortLot = "?", OutputSwapsYearlyLongPS = "?", OutputSwapsYearlyShortPS = "?",
       OutputSwapsCurrencyDailyLot = "", OutputSwapsCurrencyDailyPS = "", OutputSwapsCurrencyYearlyLot = "", OutputSwapsCurrencyYearlyPS = "";
string ProfitCurrency, account_currency, ReferenceSymbol = NULL, BaseCurrency, SwapConversionSymbol = "", AdditionalReferenceSymbol = NULL;
bool ReferenceSymbolMode, AdditionalReferenceSymbolMode;
int ProfitCalcMode;
bool Uninitialized = true;
int LinesSelectedStatus; // 0 - no change, 1 - flip to selected, 2 - flip to unselected.
double ArrayPositionSize[]; // PS for each trade with multiple TPs.

//==================================================================================================================
//+----------------------+
//| Will be called once. |
//+----------------------+
void Initialization()
{
    if (Bars == 0) return; // Data not ready yet.
    if ((sets.EntryLevel <= 0) && (sets.StopLossLevel <= 0))
    {
        if (sets.TradeDirection == Long)
        {
            sets.EntryLevel = High[0];
            if (DefaultSL > 0) sets.StopLossLevel = sets.EntryLevel - DefaultSL * _Point;
            else sets.StopLossLevel = Low[0];
            if (DefaultTP > 0) sets.TakeProfitLevel = sets.EntryLevel + DefaultTP * _Point;
            if (sets.EntryLevel == sets.StopLossLevel) sets.StopLossLevel -= Point;
        }
        else
        {
            sets.EntryLevel = Low[0];
            if (DefaultSL > 0) sets.StopLossLevel = sets.EntryLevel + DefaultSL * _Point;
            else sets.StopLossLevel = High[0];
            if (DefaultTP > 0) sets.TakeProfitLevel = sets.EntryLevel - DefaultTP * _Point;
            if (sets.EntryLevel == sets.StopLossLevel) sets.StopLossLevel += Point;
        }
        if ((SLDistanceInPoints) && (sets.StopLoss <= 0)) sets.StopLoss = (int)MathRound(MathAbs((sets.EntryLevel - sets.StopLossLevel) / _Point));
        if ((TPDistanceInPoints) && (sets.TakeProfit <= 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.EntryLevel - sets.TakeProfitLevel) / _Point));
    }
// Loaded template with TP line - delete the line.
    if ((sets.TakeProfit == 0) && (sets.TakeProfitLevel == 0) && (ObjectFind(0, ObjectPrefix + "TakeProfitLine") == 0))
    {
        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine");
        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLabel");
        ObjectDelete(ChartID(), ObjectPrefix + "TPAdditionalLabel");
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i));
            ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i));
            ObjectDelete(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i));
        }
    }
// Using TP distance in points but just switched from the TP given as a level on an already attached indicator.
    if ((TPDistanceInPoints) && (sets.TakeProfit == 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.TakeProfitLevel - sets.EntryLevel) / _Point));
    if (sets.EntryLevel - sets.StopLossLevel == 0)
    {
        Alert("Entry and Stop-Loss levels should be different and non-zero.");
        return;
    }

    if (sets.EntryType == Instant)
    {
        RefreshRates();
        if ((Ask > 0) && (Bid > 0))
        {
            // SL got inside Ask/Bid range.
            if ((sets.StopLossLevel >= Bid) && (sets.StopLossLevel <= Ask)) sets.StopLossLevel = Bid - Point;
            // Long entry
            if (sets.StopLossLevel < Bid) sets.EntryLevel = Ask;
            // Short entry
            else if (sets.StopLossLevel > Ask) sets.EntryLevel = Bid;
        }
    }
// Has to be done for updates to default input parameters to work correctly.
    if (sets.TradeDirection == Long)
    {
        if ((DefaultSL > 0) && (sets.StopLossLevel == 0))  sets.StopLossLevel = sets.EntryLevel - DefaultSL * _Point;
        if ((DefaultTP > 0) && (sets.TakeProfitLevel == 0)) sets.TakeProfitLevel = sets.EntryLevel + DefaultTP * _Point;
    }
    else
    {
        if ((DefaultSL > 0) && (sets.StopLossLevel == 0)) sets.StopLossLevel = sets.EntryLevel + DefaultSL * _Point;
        if ((DefaultTP > 0) && (sets.TakeProfitLevel == 0)) sets.TakeProfitLevel = sets.EntryLevel - DefaultTP * _Point;
    }
    if ((SLDistanceInPoints) && (sets.StopLoss <= 0)) sets.StopLoss = (int)MathRound(MathAbs((sets.EntryLevel - sets.StopLossLevel) / _Point));
    if ((TPDistanceInPoints) && (sets.TakeProfit <= 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.EntryLevel - sets.TakeProfitLevel) / _Point));

    bool line_existed = false; // Will be used to preserve OBJPROP_SELECTED through timeframe changes and the like.
    if (ObjectFind(ChartID(), ObjectPrefix + "EntryLine") == -1) ObjectCreate(ChartID(), ObjectPrefix + "EntryLine", OBJ_HLINE, 0, TimeCurrent(), sets.EntryLevel);
    else
    {
        line_existed = true;
        ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
    }
    ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_STYLE, entry_line_style);
    ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_COLOR, entry_line_color);
    ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_WIDTH, entry_line_width);
    ObjectSetString(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TOOLTIP, "Entry");
    if (sets.EntryType == Instant) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, false);
    else
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, true);
        if (!line_existed)
        {
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
        }
        else
        {
            if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
            else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, false);
        }
    }

    line_existed = false;
    if (ObjectFind(ChartID(), ObjectPrefix + "StopLossLine") == -1) ObjectCreate(ChartID(), ObjectPrefix + "StopLossLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopLossLevel);
    else
    {
        line_existed = true;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_STYLE, stoploss_line_style);
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_COLOR, stoploss_line_color);
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_WIDTH, stoploss_line_width);
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTABLE, true);
    ObjectSetString(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TOOLTIP, "Stop-Loss");
    if (!line_existed)
    {
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
    }
    else
    {
        if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
        else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, false);
    }
    StopLoss = MathAbs(sets.EntryLevel - sets.StopLossLevel);

    if (ShowLineLabels)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "StopLossLabel", OBJ_LABEL, 0, 0, 0);
        if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_COLOR, clrNONE);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_HIDDEN, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_BACK, DrawTextAsBackground);
        ObjectSetString(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TOOLTIP, "SL Distance, points");
        if ((ShowAdditionalSLLabel) && (ObjectFind(0, ObjectPrefix + "SLAdditionalLabel") == -1))
        {
            ObjectCreate(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJ_LABEL, 0, 0, 0);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TOOLTIP, "Risk, % ($)");
        }
    }

    if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
    {
        line_existed = false;
        ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
        if ((sets.TakeProfitLevel > 0) || ((sets.ATRMultiplierTP > 0) && (ShowATROptions))) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
    else
    {
        line_existed = true;
        ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
    }
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
    ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, "Take-Profit");
    if (!line_existed)
    {
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
    }
    else
    {
        if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, false);
    }
    if (ShowLineLabels)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLabel") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJ_LABEL, 0, 0, 0);
            if ((sets.TakeProfitLevel > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TOOLTIP, "TP Distance, points");
        }
        if ((ShowAdditionalTPLabel) && (ObjectFind(0, ObjectPrefix + "TPAdditionalLabel") == -1))
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJ_LABEL, 0, 0, 0);
            if ((sets.TakeProfitLevel > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TOOLTIP, "Reward, % ($), R/R");
        }
    }

// Process multiple TP lines.
    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i)) == -1)
        {
            line_existed = false;
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.ScriptTP[i]);
            if (sets.ScriptTP[i] > 0) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        else
        {
            line_existed = true;
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.ScriptTP[i]);
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
        ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, "Take-Profit #" + IntegerToString(i + 1));
        if (!line_existed)
        {
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
        }
        else
        {
            if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
            else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, false);
        }
        if (ShowLineLabels)
        {
            if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i)) == -1)
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJ_LABEL, 0, 0, 0);
                if ((sets.ScriptTP[i] > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_COLOR, clrNONE);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_SELECTABLE, false);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_HIDDEN, false);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_CORNER, CORNER_LEFT_UPPER);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TOOLTIP, "TP #" + IntegerToString(i + 1) + " Distance, points");
            }
            if ((ShowAdditionalTPLabel) && (ObjectFind(0, ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i)) == -1))
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJ_LABEL, 0, 0, 0);
                if ((sets.ScriptTP[i] > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_COLOR, clrNONE);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_SELECTABLE, false);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_HIDDEN, false);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_CORNER, CORNER_LEFT_UPPER);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                ObjectSetString(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TOOLTIP, "Reward #" + IntegerToString(i + 1) + ", $ (%), R/R");
            }
        }
    }

    switch(sets.AccountButton)
    {
    default:
    case Balance:
        if (CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountBalance();
        break;
    case Equity:
        AccSize = AccountEquity();
        break;
    case Balance_minus_Risk:
        if (CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountBalance();
        if (PortfolioLossMoney != DBL_MAX) AccSize = AccSize - PortfolioLossMoney;
        break;
    }
    if (sets.CustomBalance <= 0) AccSize += AdditionalFunds;

    ChartSetInteger(0, CHART_FOREGROUND, !PanelOnTopOfChart);

// Used to store volume for each TP level. Without additional levels, there is only main TP level.
    ArrayResize(ArrayPositionSize, ScriptTakeProfitsNumber);

    RecalculatePositionSize();

    Uninitialized = false;
}

//+------------------------------------------------------------------+
//| Main recalculation function used on every tick and on entry/SL   |
//| line drag.                                                       |
//+------------------------------------------------------------------+
void RecalculatePositionSize()
{
// Update Entry to Ask/Bid if needed.
    RefreshRates();
    WarningEntry = "";
    WarningSL    = "";
    WarningTP    = "";
    for (int i = 1; i < ScriptTakeProfitsNumber; i++) AdditionalWarningTP[i - 1] = "";

    if (sets.EntryType == Instant)
    {
        if ((Ask > 0) && (Bid > 0))
        {
            if (sets.ShowLines)
            {
                double read_tStopLossLevel;
                if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_tStopLossLevel)) return; // Line was deleted, waiting for automatic restoration.
                tStopLossLevel = Round(read_tStopLossLevel, _Digits);
            }
            else
                tStopLossLevel = sets.StopLossLevel;

            // Long entry
            if (tStopLossLevel < Bid) tEntryLevel = Ask;
            // Short entry
            else if (tStopLossLevel > Ask) tEntryLevel = Bid;
            // Undefined entry
            else
            {
                // Move tEntryLevel to the nearest line.
                if ((tEntryLevel - Bid) < (tEntryLevel - Ask)) tEntryLevel = Bid;
                else tEntryLevel = Ask;
            }
            ObjectSetDouble(0, ObjectPrefix + "EntryLine", OBJPROP_PRICE, 0, tEntryLevel);
        }
    }

    if (sets.EntryLevel - sets.StopLossLevel == 0) return;

// If could not find account currency, probably not connected.
    if ((AccountCurrency() == "") || (!TerminalInfoInteger(TERMINAL_CONNECTED))) return;

    if (TickSize == -1) // Run only once.
    {
        GetSymbolAndAccountData();
    }

    double read_tEntryLevel, read_tStopLossLevel, read_tTakeProfitLevel;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, 0, read_tEntryLevel)) return; // Line was deleted, waiting for automatic restoration.
    tEntryLevel = Round(read_tEntryLevel, _Digits);
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_tStopLossLevel)) return;
    tStopLossLevel = Round(read_tStopLossLevel, _Digits);
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, read_tTakeProfitLevel)) return;
    tTakeProfitLevel = Round(read_tTakeProfitLevel, _Digits);

    double StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) * _Point;
    double AskBid = 0;
    if (sets.EntryType == Instant)
    {
        if ((tStopLossLevel < Ask) && (tStopLossLevel > Bid)) WarningSL = "(Wrong value!)";
        else if (tStopLossLevel < Ask) AskBid = Ask;
        else if (tStopLossLevel > Bid) AskBid = Bid;
    }
    else if (sets.EntryType == Pending)
    {
        if (tStopLossLevel < tEntryLevel)  AskBid = Ask;
        else if (tStopLossLevel > tEntryLevel) AskBid = Bid;
        if (AskBid)
        {
            if (MathAbs(AskBid - tEntryLevel) < StopLevel) WarningEntry = "(Too close!)";
        }
        else WarningSL = "(Wrong value!)";
    }

    if ((WarningSL == "") && (MathAbs(tStopLossLevel - tEntryLevel) < StopLevel)) WarningSL = "(Too close!)";

    if (tTakeProfitLevel > 0)
    {
        if (MathAbs(tTakeProfitLevel - tEntryLevel) < StopLevel) WarningTP = "(Too close!)";
    }

    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        double add_tTakeProfitLevel;
        if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0, add_tTakeProfitLevel)) return;
        add_tTakeProfitLevel = Round(add_tTakeProfitLevel, _Digits);
        if (add_tTakeProfitLevel > 0)
        {
            if (MathAbs(add_tTakeProfitLevel - tEntryLevel) < StopLevel) AdditionalWarningTP[i - 1] = "(Too close!)";
        }
    }

    StopLoss = MathAbs(tEntryLevel - tStopLossLevel);
    if (StopLoss == 0)
    {
        Print("Stop-loss should be different from Entry.");
        return;
    }

    switch(sets.AccountButton)
    {
    default:
    case Balance:
        if (sets.CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountBalance();
        break;
    case Equity:
        AccSize = AccountEquity();
        break;
    case Balance_minus_Risk:
        if (sets.CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountBalance();
        if (PortfolioLossMoney != DBL_MAX) AccSize = AccSize - PortfolioLossMoney;
        break;
    }
    if (sets.CustomBalance <= 0) AccSize += AdditionalFunds;

    CalculateRiskAndPositionSize();

    if (ShowLineLabels)
    {
        DrawLineLabel(ObjectPrefix + "StopLossLabel", IntegerToString((int)MathRound((MathAbs(tStopLossLevel - tEntryLevel) / _Point))), tStopLossLevel, sl_label_font_color);
        if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if ((ShowAdditionalSLLabel) && (AccSize != 0))
        {
            string label_text;
            if (WarningSL == "") label_text = FormatDouble(DoubleToString(Round(OutputRiskMoney / AccSize * 100, 2, RoundDown), 2)) + "% (" + FormatDouble(DoubleToString(OutputRiskMoney, 2)) + " " + account_currency + ")";
            else label_text = WarningSL;
            DrawLineLabel(ObjectPrefix + "SLAdditionalLabel", label_text, tStopLossLevel, sl_label_font_color, true);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        if (tTakeProfitLevel > 0)
        {
            DrawLineLabel(ObjectPrefix + "TakeProfitLabel", IntegerToString((int)MathRound((MathAbs(tTakeProfitLevel - tEntryLevel) / _Point))), tTakeProfitLevel, tp_label_font_color);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

            if ((ShowAdditionalTPLabel) && (AccSize != 0))
            {
                string label_text;
                if ((WarningTP == "") && (MainOutputRR != "Invalid TP"))
                {
                    label_text = FormatDouble(DoubleToString(Round(MainOutputReward / AccSize * 100, 2, RoundDown), 2)) + "% (" + FormatDouble(DoubleToString(MainOutputReward, 2)) + " " + account_currency + ") " + MainOutputRR + "R";
                    // When multiple TPs are used, append correct lot volume for each TP at the beginning of the additional TP label:
                    if (ScriptTakeProfitsNumber > 1) label_text = FormatDouble(DoubleToString(ArrayPositionSize[0], LotStep_digits), LotStep_digits) + " Lots " + label_text;
                }
                else
                {
                    label_text = WarningTP;
                    if (MainOutputRR == "Invalid TP") label_text += MainOutputRR;
                }
                DrawLineLabel(ObjectPrefix + "TPAdditionalLabel", label_text, tTakeProfitLevel, tp_label_font_color, true);
                if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
        }
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            double add_tTakeProfitLevel = Round(ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE), _Digits);
            DrawLineLabel(ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), IntegerToString((int)MathRound((MathAbs(add_tTakeProfitLevel - tEntryLevel) / _Point))), add_tTakeProfitLevel, tp_label_font_color);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

            if ((ShowAdditionalTPLabel) && (AccSize != 0))
            {
                string label_text;
                if ((AdditionalWarningTP[i - 1] == "") && (AdditionalOutputRR[i - 1] != "Invalid TP"))
                {
                    label_text = FormatDouble(DoubleToString(ArrayPositionSize[i], LotStep_digits), LotStep_digits) + " Lots " + FormatDouble(DoubleToString(Round(AdditionalOutputReward[i - 1] / AccSize * 100, 2, RoundDown), 2)) + "% (" + FormatDouble(DoubleToString(AdditionalOutputReward[i - 1], 2)) + " " + account_currency + ") " + AdditionalOutputRR[i - 1] + "R";
                }
                else
                {
                    label_text = AdditionalWarningTP[i - 1];
                    if (AdditionalOutputRR[i - 1] == "Invalid TP") label_text += AdditionalOutputRR[i - 1];
                }
                DrawLineLabel(ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), label_text, add_tTakeProfitLevel, tp_label_font_color, true);
                if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
        }
    }

    if ((sets.SelectedTab == MarginTab) && (!sets.IsPanelMinimized)) CalculateSymbolLeverage();

    if ((sets.SelectedTab == SwapsTab) && (!sets.IsPanelMinimized)) GetSwapData();
}

//+------------------------------------------------------------------+
//| Gets basic info on Symbol and Account. It remains unchanged.     |
//+------------------------------------------------------------------+
void GetSymbolAndAccountData()
{
    TickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
    MinLot = MarketInfo(Symbol(), MODE_MINLOT);
    MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
    LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
    if (!CalculateUnadjustedPositionSize) LotStep_digits = CountDecimalPlaces(LotStep);
    else LotStep_digits = 2;
    MarginHedging = MarketInfo(Symbol(), MODE_MARGINHEDGED);
    LotSize = MarketInfo(Symbol(), MODE_LOTSIZE);
    AccStopoutMode = AccountStopoutMode();
    AccStopoutLevel = AccountStopoutLevel();
    SwapsTripleDay = EnumToString((ENUM_DAY_OF_WEEK)SymbolInfoInteger(Symbol(), SYMBOL_SWAP_ROLLOVER3DAYS));
    string lowercase_part = StringSubstr(SwapsTripleDay, 1);
    StringToLower(lowercase_part);
    SwapsTripleDay = CharToString((uchar)SwapsTripleDay[0]) + lowercase_part;
    ProfitCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
    if (ProfitCurrency == "RUR") ProfitCurrency = "RUB";
    BaseCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
    if (BaseCurrency == "RUR") BaseCurrency = "RUB";

    account_currency = AccountCurrency();

    // A rough patch for cases when account currency is set as RUR instead of RUB.
    if (account_currency == "RUR") account_currency = "RUB";

    ProfitCalcMode = (int)MarketInfo(Symbol(), MODE_PROFITCALCMODE);
}

//+-----------------------------------------------------------------------------------+
//| Calculates necessary adjustments for cases when ProfitCurrency != AccountCurrency.|
//| Optional parameter profit_currency for when calculating adjustment for positions  |
//| in other symbols (for Risk tab).                                                  |
//+-----------------------------------------------------------------------------------+
#define FOREX_SYMBOLS_ONLY 0
#define NONFOREX_SYMBOLS_ONLY 1
double CalculateAdjustment(const PROFIT_LOSS calc_mode, string profit_currency = "")
{
    string ref_symbol = NULL, add_ref_symbol = NULL;
    bool ref_mode = false, add_ref_mode = false;
    double add_coefficient = 1; // Might be necessary for correction coefficient calculation if two pairs are used for profit currency to account currency conversion. This is handled differently in MT5 version.
    if (profit_currency == "") // Calculating adjustment for current symbol.
    {
        // Use global variables.
        ref_symbol = ReferenceSymbol;
        profit_currency = ProfitCurrency;
        ref_mode = ReferenceSymbolMode;
        add_ref_symbol = AdditionalReferenceSymbol; // Additional symbol variable is combined with normal ReferenceSymbol to store two symbols for 2-pair conversion.
        add_ref_mode = AdditionalReferenceSymbolMode;
    }

    if (ref_symbol == NULL) // Either first run or non-current symbol.
    {
        ref_symbol = GetSymbolByCurrencies(profit_currency, account_currency, FOREX_SYMBOLS_ONLY);
        if (ref_symbol == NULL) ref_symbol = GetSymbolByCurrencies(profit_currency, account_currency, NONFOREX_SYMBOLS_ONLY);
        ref_mode = true;
        // Failed.
        if (ref_symbol == NULL)
        {
            // Reversing currencies.
            ref_symbol = GetSymbolByCurrencies(account_currency, profit_currency, FOREX_SYMBOLS_ONLY);
            if (ref_symbol == NULL) ref_symbol = GetSymbolByCurrencies(account_currency, profit_currency, NONFOREX_SYMBOLS_ONLY);
            ref_mode = false;
        }
        if (ref_symbol == NULL)
        {
            // The condition checks whether we are caclulating conversion coefficient for the chart's symbol or for some other.
            // The error output is OK for the current symbol only because it won't be repeated ad infinitum.
            // It should be avoided for non-chart symbols because it will just flood the log.
            if (profit_currency == ProfitCurrency) Print("Couldn't detect proper currency pair for adjustment calculation. Profit currency: ", profit_currency, ". Account currency: ", account_currency, ". Trying to find a possible two-symbol combination.");
            if ((FindDoubleReferenceSymbol("USD", profit_currency, ref_symbol, ref_mode, add_ref_symbol, add_ref_mode))  // USD should work in 99.9% of cases.
             || (FindDoubleReferenceSymbol("EUR", profit_currency, ref_symbol, ref_mode, add_ref_symbol, add_ref_mode))  // For very rare cases.
             || (FindDoubleReferenceSymbol("GBP", profit_currency, ref_symbol, ref_mode, add_ref_symbol, add_ref_mode))  // For extremely rare cases.
             || (FindDoubleReferenceSymbol("JPY", profit_currency, ref_symbol, ref_mode, add_ref_symbol, add_ref_mode))) // For extremely rare cases.
            {
                if (profit_currency == ProfitCurrency) Print("Converting via ", ref_symbol, " and ", add_ref_symbol, ".");
            }
            else
            {
                Print("Adjustment calculation critical failure. Failed both simple and two-pair conversion methods.");
                return 1;
            }
        }
    }
    if (profit_currency == ProfitCurrency) // It was calculation for the current symbol.
    {
        // Remember for future uses.
        ReferenceSymbol = ref_symbol;
        ReferenceSymbolMode = ref_mode;
        AdditionalReferenceSymbol = add_ref_symbol;
        AdditionalReferenceSymbolMode = add_ref_mode;
    }
    if (add_ref_symbol != NULL) // If two reference pairs are used.
    {
        // Calculate just the additional symbol's coefficient and then use it in final return's multiplication.
        MqlTick tick;
        SymbolInfoTick(add_ref_symbol, tick);
        add_coefficient = GetCurrencyCorrectionCoefficient(calc_mode, add_ref_mode, tick);
    }
    MqlTick tick;
    SymbolInfoTick(ref_symbol, tick);
    return GetCurrencyCorrectionCoefficient(calc_mode, ref_mode, tick) * add_coefficient;
}

//+----------------------------------------------------------------------------+
//| Returns a currency pair with specified base currency and profit currency.  |
//| Can skip symbols based on their type to improve performance in some cases. |
//+----------------------------------------------------------------------------+
string GetSymbolByCurrencies(const string base_currency, const string profit_currency, const uint symbol_type)
{
    // Cycle through all symbols.
    for (int s = 0; s < SymbolsTotal(false); s++)
    {
        // Get symbol name by number.
        string symbolname = SymbolName(s, false);
        string b_cur;

        // Normal case - Forex pairs:
        if (MarketInfo(symbolname, MODE_PROFITCALCMODE) == 0)
        {
            if (symbol_type == NONFOREX_SYMBOLS_ONLY) continue; // Avoid checking symbols of a wrong type.
            // Get its base currency.
            b_cur = SymbolInfoString(symbolname, SYMBOL_CURRENCY_BASE);
        }
        else // Weird case for brokers that set conversion pairs as CFDs.
        {
            if (symbol_type == FOREX_SYMBOLS_ONLY) continue; // Avoid checking symbols of a wrong type.
            // Get its base currency as the initial three letters - prone to huge errors!
            b_cur = StringSubstr(symbolname, 0, 3);
        }
        // Get its profit currency.
        string p_cur = SymbolInfoString(symbolname, SYMBOL_CURRENCY_PROFIT);
        // If the currency pair matches both currencies, select it in Market Watch and return its name.
        if ((b_cur == base_currency) && (p_cur == profit_currency))
        {
            // Select if necessary.
            if (!(bool)SymbolInfoInteger(symbolname, SYMBOL_SELECT)) SymbolSelect(symbolname, true);
            return symbolname;
        }
    }
    return NULL;
}

//+----------------------------------------------------------------------------+
//| Finds reference symbols using 2-pair method.                               |
//| Results are returned via reference parameters.                             |
//| Returns true if found the pairs, false otherwise.                          |
//+----------------------------------------------------------------------------+
bool FindDoubleReferenceSymbol(const string cross_currency, const string profit_currency, string &ref_symbol, bool &ref_mode, string &add_ref_symbol, bool &add_ref_mode)
{
    // A hypothetical example for better understanding:
    // The trader buys CAD/CHF.
    // account_currency is known = SEK.
    // cross_currency = USD.
    // profit_currency = CHF.
    // I.e., we have to buy dollars with francs (using the Ask price) and then sell those for SEKs (using the Bid price).

    ref_symbol = GetSymbolByCurrencies(cross_currency, account_currency, FOREX_SYMBOLS_ONLY); 
    if (ref_symbol == NULL) ref_symbol = GetSymbolByCurrencies(cross_currency, account_currency, NONFOREX_SYMBOLS_ONLY);
    ref_mode = true; // If found, we've got USD/SEK.

    // Failed.
    if (ref_symbol == NULL)
    {
        // Reversing currencies.
        ref_symbol = GetSymbolByCurrencies(account_currency, cross_currency, FOREX_SYMBOLS_ONLY);
        if (ref_symbol == NULL) ref_symbol = GetSymbolByCurrencies(account_currency, cross_currency, NONFOREX_SYMBOLS_ONLY);
        ref_mode = false; // If found, we've got SEK/USD.
    }
    if (ref_symbol == NULL)
    {
        Print("Error. Couldn't detect proper currency pair for 2-pair adjustment calculation. Cross currency: ", cross_currency, ". Account currency: ", account_currency, ".");
        return false;
    }

    add_ref_symbol = GetSymbolByCurrencies(cross_currency, profit_currency, FOREX_SYMBOLS_ONLY); 
    if (add_ref_symbol == NULL) add_ref_symbol = GetSymbolByCurrencies(cross_currency, profit_currency, NONFOREX_SYMBOLS_ONLY);
    add_ref_mode = false; // If found, we've got USD/CHF. Notice that mode is swapped for cross/profit compared to cross/acc, because it is used in the opposite way.

    // Failed.
    if (add_ref_symbol == NULL)
    {
        // Reversing currencies.
        add_ref_symbol = GetSymbolByCurrencies(profit_currency, cross_currency, FOREX_SYMBOLS_ONLY);
        if (add_ref_symbol == NULL) add_ref_symbol = GetSymbolByCurrencies(profit_currency, cross_currency, NONFOREX_SYMBOLS_ONLY);
        add_ref_mode = true; // If found, we've got CHF/USD. Notice that mode is swapped for profit/cross compared to acc/cross, because it is used in the opposite way.
    }
    if (add_ref_symbol == NULL)
    {
        Print("Error. Couldn't detect proper currency pair for 2-pair adjustment calculation. Cross currency: ", cross_currency, ". Chart's pair currency: ", profit_currency, ".");
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//| Get profit correction coefficient based on profit currency,      |
//| calculation mode (profit or loss), reference pair mode (reverse  |
//| or direct), and current prices.                                  |
//+------------------------------------------------------------------+
double GetCurrencyCorrectionCoefficient(PROFIT_LOSS calc_mode, bool ref_mode, MqlTick &tick)
{
    if ((tick.ask == 0) || (tick.bid == 0)) return(-1); // Data is not yet ready.
    if (calc_mode == Loss)
    {
        // Reverse quote.
        if (ref_mode)
        {
            // Using Buy price for reverse quote.
            return(tick.ask);
        }
        // Direct quote.
        else
        {
            // Using Sell price for direct quote.
            return(1 / tick.bid);
        }
    }
    else if (calc_mode == Profit)
    {
        // Reverse quote.
        if (ref_mode)
        {
            // Using Sell price for reverse quote.
            return(tick.bid);
        }
        // Direct quote.
        else
        {
            // Using Buy price for direct quote.
            return(1 / tick.ask);
        }
    }
    return(-1);
}

//+------------------------------------------------------------------+
//| Calculates risk size and position size. Sets object values.      |
//+------------------------------------------------------------------+
void CalculateRiskAndPositionSize()
{
    double UnitCost;
    double PositionSize = 0;
    UnitCost_reward = 0; // Used also in OnClickBtnTakeProfit().
    DisplayRisk = sets.Risk;
    if (!sets.UseMoneyInsteadOfPercentage)
    {
        RiskMoney = Round(AccSize * sets.Risk / 100, 2, RoundDown);
    }
    else
    {
        RiskMoney = sets.MoneyRisk;
        if (AccSize != 0) DisplayRisk = Round(sets.MoneyRisk / AccSize * 100, 2);
        else DisplayRisk = 0;
    }

    // If Symbol is CFD or futures but with different profit currency.
    if ((ProfitCalcMode == 1) || ((ProfitCalcMode == 2) && (ProfitCurrency != account_currency)))
    {
        if (ProfitCalcMode == 2) UnitCost = MarketInfo(Symbol(), MODE_TICKVALUE); // Futures, but will still have to be adjusted by CCC.
        else UnitCost = TickSize * LotSize; // Apparently, it is more accurate than taking TICKVALUE directly in some cases.
        UnitCost_reward = UnitCost;
        // If profit currency is different from account currency.
        if (ProfitCurrency != account_currency)
        {
            double CCC = CalculateAdjustment(Loss);
            // Adjust the unit cost.
            double pre_unitcost = UnitCost;
            UnitCost *= CCC;
            CCC = CalculateAdjustment(Profit);
            // Adjust the unit cost.
            UnitCost_reward = pre_unitcost * CCC;
        }
    }
    else
    {
        UnitCost = MarketInfo(Symbol(), MODE_TICKVALUE); // Futures or Forex.
        UnitCost_reward = UnitCost;
    }

    // If account currency == pair's base currency, adjust UnitCost to future rate (SL). Works only for Forex pairs.
    if ((account_currency == BaseCurrency) && (ProfitCalcMode == 0) && (tStopLossLevel != 0))
    {
        double future_rate = tStopLossLevel;
        double current_rate = 1;
        RefreshRates();
        if (tStopLossLevel < tEntryLevel)
        {
            current_rate = Ask;
        }
        else if (tStopLossLevel > tEntryLevel)
        {
            current_rate = Bid;
        }
        UnitCost *= (current_rate / future_rate);
    }

    if ((StopLoss != 0) && (UnitCost != 0) && (TickSize != 0))
    {
        if (sets.RiskFromPositionSize)
        {
            RiskMoney = Round(OutputPositionSize * (StopLoss * UnitCost / TickSize + 2 * sets.CommissionPerLot), 2);
            sets.MoneyRisk = RiskMoney;
            if (AccSize != 0) DisplayRisk = Round(sets.MoneyRisk / AccSize * 100, 2);
            else DisplayRisk = 0;
            PositionSize = OutputPositionSize;
        }
        else
        {
            PositionSize = Round(RiskMoney / (StopLoss * UnitCost / TickSize + 2 * sets.CommissionPerLot), 2, RoundDown);
            OutputPositionSize = PositionSize;
        }
    }

    if (!CalculateUnadjustedPositionSize) // If need to adjust to broker's restrictions.
    {
        if (PositionSize < MinLot) OutputPositionSize = MinLot;
        else if (PositionSize > MaxLot) OutputPositionSize = MaxLot;
        double steps = 0;
        if (LotStep != 0) steps = OutputPositionSize / LotStep;
        if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
        if (MathFloor(steps) < steps) OutputPositionSize = MathFloor(steps) * LotStep;
    }

    if (TickSize == 0) return;
    OutputRiskMoney = Round((StopLoss * UnitCost / TickSize + 2 * sets.CommissionPerLot) * OutputPositionSize, 2);

    if ((ShowPointValue) || ((UseCommissionToSetTPDistance) && (sets.CommissionPerLot != 0)))
    {
        OutputPointValue = FormatDouble(DoubleToString(OutputPositionSize * UnitCost * (_Point / TickSize), 2));
    }

    if (StopLoss == 0) return;

    // Calculate adjusted position size shares for use here and in RecalculatePositionSize().
    double AccumulatedPositionSize = 0; // Total PS used by additional TPs.
    // Calculate volume for each partial trade.
    // The goal is to use normal rounded down values for additional TPs and then throw the remainder to the main TP.
    if (ScriptTakeProfitsNumber > 1)
    {
        for (int i = ScriptTakeProfitsNumber - 1; i >= 0; i--)
        {
            double position_size = BrokerizePositionSize(OutputPositionSize * (double)sets.ScriptTPShare[i] / 100.0);
            // If this is one of the additional TPs, then count its PS towards total PS that will be open for additional TPs.
            if (i > 0)
            {
                AccumulatedPositionSize += position_size;
            }
            else // For the main TP, use the remaining part of the total PS.
            {
                position_size = OutputPositionSize - AccumulatedPositionSize;
            }
            ArrayPositionSize[i] = position_size;
        }
    }
    else ArrayPositionSize[0] = OutputPositionSize;

    if (tTakeProfitLevel > 0)
    {
        // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
        if ((account_currency == BaseCurrency) && (ProfitCalcMode == 0))
        {
            double future_rate = tTakeProfitLevel;
            double current_rate = 1;
            RefreshRates();
            if (tStopLossLevel < tEntryLevel)
            {
                current_rate = Ask;
            }
            else if (tStopLossLevel > tEntryLevel)
            {
                current_rate = Bid;
            }
            UnitCost_reward = UnitCost_reward * (current_rate / future_rate);
        }

        double PS_Multiplier = 1; // Position size multiplier for multiple TPs. When single TP is used, it is equal 1.
        if (ScriptTakeProfitsNumber > 1) PS_Multiplier = (double)sets.ScriptTPShare[0] / 100.0; // Use respective position size share.

        MainOutputReward = NormalizeDouble((MathAbs((tTakeProfitLevel - tEntryLevel) * UnitCost_reward / TickSize) - 2 * sets.CommissionPerLot) * ArrayPositionSize[0], 2);

        // For zero share, just ignore this level.
        if  ((PS_Multiplier == 0) || (ArrayPositionSize[0] == 0))
        {
            InputRR = "";
            MainOutputRR = "";
        }
        // Have valid take-profit level that is above entry for SL below entry, or below entry for SL above entry.
        else if ((((tTakeProfitLevel > tEntryLevel) && (tEntryLevel > tStopLossLevel)) || ((tTakeProfitLevel < tEntryLevel) && (tEntryLevel < tStopLossLevel))) && (OutputRiskMoney != 0))
        {
            InputRR = DoubleToString(Round(MathAbs((tTakeProfitLevel - tEntryLevel) / StopLoss), 2, RoundDown), 2);
            MainOutputRR = DoubleToString(Round(MainOutputReward / (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[0]), 2, RoundDown), 2);
        }
        else
        {
            InputRR = "Invalid TP";
            MainOutputRR = InputRR;
        }
        if (MainOutputRR == InputRR) InputRR = "";
    }
    else MainOutputReward = 0;

    // Multiple TPs.
    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        double add_tTakeProfitLevel = Round(ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE), _Digits);
        if (add_tTakeProfitLevel > 0)
        {
            // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
            if ((account_currency == BaseCurrency) && (ProfitCalcMode == 0))
            {
                double future_rate = add_tTakeProfitLevel;
                double current_rate = 1;
                RefreshRates();
                if (tStopLossLevel < tEntryLevel)
                {
                    current_rate = Ask;
                }
                else if (tStopLossLevel > tEntryLevel)
                {
                    current_rate = Bid;
                }
                UnitCost_reward = UnitCost_reward * (current_rate / future_rate);
            }
            AdditionalOutputReward[i - 1] = NormalizeDouble((MathAbs((add_tTakeProfitLevel - tEntryLevel) * UnitCost_reward / TickSize) - 2 * sets.CommissionPerLot) * ArrayPositionSize[i], 2);
            // For zero share, just ignore this level.
            if ((sets.ScriptTPShare[i] == 0) || (ArrayPositionSize[i] == 0))
            {
                AdditionalOutputRR[i - 1] = "";
            }
            // Have valid take-profit level that is above entry for SL below entry, or below entry for SL above entry.
            else if ((((add_tTakeProfitLevel > tEntryLevel) && (tEntryLevel > tStopLossLevel)) || ((add_tTakeProfitLevel < tEntryLevel) && (tEntryLevel < tStopLossLevel))) && (OutputRiskMoney != 0))
            {
                AdditionalOutputRR[i - 1] = DoubleToString(Round(AdditionalOutputReward[i - 1] / (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[i]), 2, RoundDown), 2);
            }
            else
            {
                AdditionalOutputRR[i - 1] = "Invalid TP";
            }
        }
        else AdditionalOutputRR[i - 1] = "";
    }

    double PS_Multiplier = 1; // Position size multiplier for multiple TPs. When single TP is used, it is equal 1.
    if (ScriptTakeProfitsNumber > 1) PS_Multiplier = (double)sets.ScriptTPShare[0] / 100.0; // Use respective position size share.
    InputReward = DoubleToString(Round(RiskMoney * PS_Multiplier * MathAbs(tTakeProfitLevel - tEntryLevel) / StopLoss, 2, RoundDown), 2);

    // Panel's fields start the same as for the main TP.
    OutputReward = MainOutputReward;
    OutputRR = MainOutputRR;
    // In case of multiple TPs:
    if (ScriptTakeProfitsNumber > 1)
    {
        double TotalOutputRisk = 0;
        if (OutputPositionSize != 0) TotalOutputRisk = (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[0]); // Main TP output risk money. If main TP share is zero, start with zero.
        double TotalInputRisk = (RiskMoney * (double)sets.ScriptTPShare[0] / 100.0); // Main TP input risk money.
        // Calculate cumulative weighted reward and R/R.
        for (int i = 1; i < ScriptTakeProfitsNumber; i++)
        {
            OutputReward += AdditionalOutputReward[i - 1];
            if ((AdditionalOutputRR[i - 1] == "Invalid TP") || (MainOutputRR == "Invalid TP")) OutputRR = "Invalid TP"; // At least one Invalid TP means that total RR is also invalid.
            if ((OutputPositionSize > 0) && (ArrayPositionSize[i] > 0)) TotalOutputRisk += (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[i]);
            TotalInputRisk += (RiskMoney * (double)sets.ScriptTPShare[i] / 100.0);
            InputReward = DoubleToString(StringToDouble(InputReward) +  Round(RiskMoney * (double)sets.ScriptTPShare[i] / 100.0 * MathAbs(sets.ScriptTP[i] - tEntryLevel) / StopLoss, 2, RoundDown), 2);
        }
        if (OutputRR != "Invalid TP")
        {
            if (TotalOutputRisk != 0) OutputRR = DoubleToString(Round(OutputReward / TotalOutputRisk, 2, RoundDown), 2);
            else OutputRR = "";
            if (TotalInputRisk != 0) InputRR = DoubleToString(Round(StringToDouble(InputReward) / TotalInputRisk, 2, RoundDown), 2);
            else InputRR = "";
        }
        if (OutputRR == InputRR) InputRR = ""; // No need to display Input R/R if it is the same as Output R/R.
        OutputRiskMoney = TotalOutputRisk;
        RiskMoney = TotalInputRisk;
    }

    if ((sets.SelectedTab == RiskTab) && (!sets.IsPanelMinimized)) CalculatePortfolioRisk();
    // Should be done even on Main tab to calculate Maximum Position Size and change Main tab's position size field's color.
    if (((sets.SelectedTab == MarginTab) || (sets.SelectedTab == MainTab)) && (!sets.IsPanelMinimized)) CalculateMargin();
}

//+------------------------------------------------------------------+
//| Make sure position size complies with broker's limits.           |
//+------------------------------------------------------------------+
double BrokerizePositionSize(double position_size)
{
    if (CalculateUnadjustedPositionSize) return(position_size); // Do not adjust if the input parameter says so.

    if (position_size < MinLot)
    {
        return(0); // Not taking this trade, so PS = 0.
    }
    else if (position_size > MaxLot)
    {
        return(MaxLot);
    }
    double steps = 0;
    if (LotStep != 0) steps = position_size / LotStep;
    if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
    if (MathFloor(steps) < steps) return(MathFloor(steps) * LotStep);

    return(position_size);
}

//+------------------------------------------------------------------+
//| Calculates risk size and position size. Sets object values.      |
//+------------------------------------------------------------------+
void CalculatePortfolioRisk()
{
    PortfolioLossMoney = 0;
    double PortfolioRewardMoney = 0;
    double volume = 0;
    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        double PointsLoss = 0;
        double PointsReward = 0;
        // Select an order.
        if (!OrderSelect(i, SELECT_BY_POS)) continue;

        // Skip orders in other symbols if the ignore checkbox is ticked.
        if ((OrderSymbol() != Symbol()) && (sets.IgnoreOtherSymbols)) continue;

        // Buy
        if ((OrderType() == ORDER_TYPE_BUY) || (((OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP)) && (sets.CountPendingOrders)))
        {
            if (OrderStopLoss() == 0)
            {
                // Losing all the current value.
                if (!sets.IgnoreOrdersWithoutStopLoss) PointsLoss = OrderOpenPrice();
            }
            else
            {
                PointsLoss = OrderOpenPrice() - OrderStopLoss();
            }
            if (OrderTakeProfit() == 0)
            {
                // Potential reward is infinite.
                if (!sets.IgnoreOrdersWithoutStopLoss) PointsReward = DBL_MAX;
            }
            else
            {
                PointsReward = OrderTakeProfit() - OrderOpenPrice();
            }
            volume += OrderLots();
        }
        // Sell
        else if ((OrderType() == ORDER_TYPE_SELL) || (((OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP)) && (sets.CountPendingOrders)))
        {
            if (OrderStopLoss() == 0)
            {
                // Potential loss is infinite.
                if (!sets.IgnoreOrdersWithoutStopLoss) PointsLoss = DBL_MAX;
            }
            else
            {
                PointsLoss = OrderStopLoss() - OrderOpenPrice();
            }
            if (OrderTakeProfit() == 0)
            {
                // Gaining all way down.
                if (!sets.IgnoreOrdersWithoutStopLoss) PointsReward = OrderOpenPrice();
            }
            else
            {
                PointsReward = OrderOpenPrice() - OrderTakeProfit();
            }
            volume += OrderLots();
        }

        if ((PointsLoss != DBL_MAX) && (PortfolioLossMoney != DBL_MAX))
        {
            double TickSize_local = MarketInfo(OrderSymbol(), MODE_TICKSIZE);
            double UnitCost;
            // If Symbol is CFD.
            if ((int)MarketInfo(OrderSymbol(), MODE_PROFITCALCMODE) == 1)
                UnitCost = TickSize_local * SymbolInfoDouble(OrderSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
            else UnitCost = MarketInfo(OrderSymbol(), MODE_TICKVALUE); // Non-CFD.

            if ((int)MarketInfo(OrderSymbol(), MODE_PROFITCALCMODE) != 0) // Non-Forex might need to be adjusted.
            {
                // If profit currency is different from account currency.
                string symbol_profit_currency = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_PROFIT);
                if (symbol_profit_currency != account_currency)
                {
                    /*ENUM_ORDER_TYPE dir = (ENUM_ORDER_TYPE)OrderType();
                    if ((dir == ORDER_TYPE_BUY_LIMIT) || (dir == ORDER_TYPE_BUY_STOP)) dir = OP_BUY;
                    else if ((dir == ORDER_TYPE_SELL_LIMIT) || (dir == ORDER_TYPE_SELL_STOP)) dir = OP_SELL;*/
                    if (symbol_profit_currency == ProfitCurrency) symbol_profit_currency = ""; // Same as global symbol - reference pair has already been found probably.
                    double CCC = CalculateAdjustment(Loss, symbol_profit_currency);
                    // Adjust the unit cost.
                    UnitCost *= CCC;
                }
            }

            if (TickSize_local == 0)
            {
                Print("Cannot retrieve tick size for ", OrderSymbol(), ". Looks like the instrument is no longer available. Calculation may not be accurate.");
            }
            else
            {
                // If account currency == pair's base currency, adjust UnitCost to future rate (SL). Works only for Forex pairs.
                if ((account_currency == SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_BASE)) && ((int)MarketInfo(OrderSymbol(), MODE_PROFITCALCMODE) == 0))
                {
                    double current_rate = 1, future_rate = 1;
                    RefreshRates();
                    if ((OrderType() == ORDER_TYPE_BUY) || (OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP))
                    {
                        current_rate = SymbolInfoDouble(OrderSymbol(), SYMBOL_ASK);
                        future_rate = current_rate - PointsLoss;
                    }
                    else if ((OrderType() == ORDER_TYPE_SELL) || (OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP))
                    {
                        current_rate = SymbolInfoDouble(OrderSymbol(), SYMBOL_BID);
                        future_rate = current_rate + PointsLoss;
                    }
                    if (OrderOpenPrice() == PointsLoss) PortfolioLossMoney = DBL_MAX; // Zero divide prevention + more accurate potential loss reporting.
                    else UnitCost *= (current_rate / future_rate);
                }
                if (PortfolioLossMoney != DBL_MAX) PortfolioLossMoney += OrderLots() * PointsLoss * UnitCost / TickSize_local - OrderCommission() - OrderSwap(); // Commission and swap is negative, everything else is positive, hence the minus sign.
            }
        }
        else
        {
            // Infinite loss.
            PortfolioLossMoney = DBL_MAX;
        }

        if ((PointsReward != DBL_MAX) && (PortfolioRewardMoney != DBL_MAX))
        {
            double TickSize_local = MarketInfo(OrderSymbol(), MODE_TICKSIZE);
            double UnitCost;
            // If Symbol is CFD.
            if ((int)MarketInfo(OrderSymbol(), MODE_PROFITCALCMODE) == 1)
                UnitCost = TickSize_local * SymbolInfoDouble(OrderSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
            else UnitCost = MarketInfo(OrderSymbol(), MODE_TICKVALUE); // Non-CFD.

            if ((int)MarketInfo(OrderSymbol(), MODE_PROFITCALCMODE) != 0) // Non-Forex might need to be adjusted.
            {
                // If profit currency is different from account currency.
                string symbol_profit_currency = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_PROFIT);
                if (symbol_profit_currency != account_currency)
                {
                    /*ENUM_ORDER_TYPE dir = (ENUM_ORDER_TYPE)OrderType();
                    if ((dir == ORDER_TYPE_BUY_LIMIT) || (dir == ORDER_TYPE_BUY_STOP)) dir = OP_BUY;
                    else if ((dir == ORDER_TYPE_SELL_LIMIT) || (dir == ORDER_TYPE_SELL_STOP)) dir = OP_SELL;*/
                    if (symbol_profit_currency == ProfitCurrency) symbol_profit_currency = ""; // Same as global symbol - reference pair has already been found probably.
                    double CCC = CalculateAdjustment(Profit, symbol_profit_currency);
                    // Adjust the unit cost.
                    UnitCost *= CCC;
                }
            }

            if (TickSize_local == 0)
            {
                Print("Cannot retrieve tick size for ", OrderSymbol(), ". Looks like the instrument is no longer available. Calculation may not be accurate.");
            }
            else
            {
                // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
                if ((account_currency == SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_BASE)) && ((int)MarketInfo(OrderSymbol(), MODE_PROFITCALCMODE) == 0))
                {
                    double current_rate = 1, future_rate = 1;
                    RefreshRates();
                    if ((OrderType() == ORDER_TYPE_BUY) || (OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP))
                    {
                        current_rate = SymbolInfoDouble(OrderSymbol(), SYMBOL_ASK);
                        future_rate = current_rate + PointsReward;
                    }
                    else if ((OrderType() == ORDER_TYPE_SELL) || (OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP))
                    {
                        current_rate = SymbolInfoDouble(OrderSymbol(), SYMBOL_BID);
                        future_rate = current_rate - PointsReward;
                    }
                    if (OrderOpenPrice() == PointsReward) PortfolioRewardMoney = DBL_MAX; // Zero divide prevention + more accurate potential profit reporting.
                    else UnitCost *= (current_rate / future_rate);
                }
                if (PortfolioRewardMoney != DBL_MAX) PortfolioRewardMoney += OrderLots() * PointsReward * UnitCost / TickSize_local + OrderCommission() + OrderSwap();
            }
        }
        else
        {
            // Infinite profit.
            PortfolioRewardMoney = DBL_MAX;
        }
    }

// If account size did not load yet.
    if (AccSize == 0) return;

    if (PortfolioLossMoney == DBL_MAX) PLM = "      Infinity";
    else PLM = FormatDouble(DoubleToString(PortfolioLossMoney, 2));

    if (PortfolioLossMoney == DBL_MAX) CPR = "      Infinity";
    else CPR = FormatDouble(DoubleToString(PortfolioLossMoney / AccSize * 100, 2));

    if (PortfolioLossMoney == DBL_MAX) PPMR = "      Infinity";
    else PPMR = FormatDouble(DoubleToString(PortfolioLossMoney + OutputRiskMoney, 2));

    if (PortfolioLossMoney == DBL_MAX) PPR = "      Infinity";
    else PPR = FormatDouble(DoubleToString((PortfolioLossMoney + OutputRiskMoney) / AccSize * 100, 2));

    if (PortfolioRewardMoney == DBL_MAX) PRM = "      Infinity";
    else PRM = FormatDouble(DoubleToString(PortfolioRewardMoney, 2));

    if (PortfolioRewardMoney == DBL_MAX) CPRew = "      Infinity";
    else CPRew = FormatDouble(DoubleToString(PortfolioRewardMoney / AccSize * 100, 2));

    if ((PortfolioRewardMoney == DBL_MAX) || (OutputReward == 0)) PPMRew = "      Infinity";
    else PPMRew = FormatDouble(DoubleToString(PortfolioRewardMoney + OutputReward, 2));

    if ((PortfolioRewardMoney == DBL_MAX) || (OutputReward == 0)) PPRew = "      Infinity";
    else PPRew = FormatDouble(DoubleToString((PortfolioRewardMoney + OutputReward) / AccSize * 100, 2));

    CPL = FormatDouble(DoubleToString(volume, LotStep_digits), LotStep_digits);
    PPL = FormatDouble(DoubleToString(volume + OutputPositionSize, LotStep_digits), LotStep_digits);
}

//+------------------------------------------------------------------+
//| Calculates margin before and after position.                     |
//+------------------------------------------------------------------+
void CalculateMargin()
{
    int dir;
    if (tStopLossLevel < tEntryLevel) dir = OP_BUY;
    else if (tStopLossLevel > tEntryLevel) dir = OP_SELL;
    else return;

    double Margin1Lot = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    double PreMargin1Lot = Margin1Lot; // Remember Margin1Lot that was before we applied CustomLeverage.

    double ContractSize = LotSize;

// If custom leverage is given via panel's input.
    if (CustomLeverage > 0)
    {
        double symbol_cost_1_lot;
        if (sets.EntryType == Pending)
            symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * sets.EntryLevel / TickSize;
        else symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize;
        Margin1Lot = symbol_cost_1_lot / CustomLeverage;
    }

    double HedgedRatio = MarginHedging / ContractSize;
    PositionMargin = OutputPositionSize * Margin1Lot;

// Maximum position size allowed by current margin.
    double MaxPositionSizeByMargin = -1;
// Maximum position margin tolerable before stop-out.
    double MaxPositionMargin = AccountFreeMargin();
// Percentage mode.
    if (AccStopoutMode == 0)
    {
        // Slightly above account stop-out level.
        double ML = AccStopoutLevel + 0.01;
        if (ML > 0) MaxPositionMargin = 100 * AccountEquity() / ML - AccountMargin();
    }
// Absolute value mode.
    else
    {
        // Slightly above account stop-out level.
        MaxPositionMargin = AccStopoutLevel + 0.01;
    }
    if (AccountFreeMargin() - MaxPositionMargin < 0) MaxPositionMargin = AccountFreeMargin();

// Needed in another function to calculate symbol leverage.
    PreHedgingPositionMargin = PositionMargin;

// Restore original PreHedgingPositionMargin.
    if (CustomLeverage > 0)
    {
        OriginalPreHedgingPositionMargin = PreHedgingPositionMargin / Margin1Lot * PreMargin1Lot;
    }

// Hedging on partial or no margin.
    if (NormalizeDouble(HedgedRatio, 2) < 1.00)
    {
        // Cycle through all open orders on this Symbol to find directional volume.
        double volume = 0;
        int type = -1;
        int total = OrdersTotal();
        for (int i = 0; i < total; i++)
        {
            if (!OrderSelect(i, SELECT_BY_POS)) continue;

            if (OrderSymbol() != Symbol()) continue;

            if (OrderType() == OP_BUY)
            {
                if (type == OP_BUY) volume += OrderLots();
                else if (type == OP_SELL)
                {
                    volume -= OrderLots();
                    if (volume < 0)
                    {
                        type = OP_BUY;
                        volume = -volume;
                    }
                }
                else if (type == -1)
                {
                    volume = OrderLots();
                    type = OP_BUY;
                }
            }
            else if (OrderType() == OP_SELL)
            {
                if (type == OP_SELL) volume += OrderLots();
                else if (type == OP_BUY)
                {
                    volume -= OrderLots();
                    if (volume < 0)
                    {
                        type = OP_SELL;
                        volume = -volume;
                    }
                }
                else if (type == -1)
                {
                    volume = OrderLots();
                    type = OP_SELL;
                }
            }
        }
        // There is position to hedge and new position is in opposite direction.
        if ((volume > 0) && (type != dir))
        {
            double calculated_volume;
            if (OutputPositionSize <= volume) calculated_volume = OutputPositionSize * (HedgedRatio - 1);
            else calculated_volume = volume * HedgedRatio + OutputPositionSize - 2 * volume;

            PositionMargin = calculated_volume * Margin1Lot;

            // Calculations for maximum position size:
            // 1. Find maximum position size for a given maximum position margin if the size is kept less than or equal to existing opposite volume.
            for (MaxPositionSizeByMargin = 0; MaxPositionSizeByMargin <= volume; MaxPositionSizeByMargin += LotStep)
            {
                if ((HedgedRatio - 1) * MaxPositionSizeByMargin * Margin1Lot > MaxPositionMargin)
                {
                    MaxPositionSizeByMargin -= LotStep;
                    break;
                }
            }
            // 2. Find maximum position size for a given maximum position margin if the size is greater than existing opposite volume.
            double MPS_gv = 0;
            if (Margin1Lot != 0) MPS_gv = MaxPositionMargin / Margin1Lot - volume * (HedgedRatio - 2);
            if (MPS_gv > MaxPositionSizeByMargin) MaxPositionSizeByMargin = MPS_gv;
        }
    }

// Was not found using partial hedge method.
    if ((MaxPositionSizeByMargin == -1) && (Margin1Lot != 0)) MaxPositionSizeByMargin = MaxPositionMargin / Margin1Lot;

    MaxPositionSizeByMargin = Round(MaxPositionSizeByMargin, LotStep_digits, RoundDown);

    OutputMaxPositionSize = MaxPositionSizeByMargin;
    if (!CalculateUnadjustedPositionSize) // If need to adjust to broker's restrictions.
    {
        if (MaxPositionSizeByMargin < MinLot) OutputMaxPositionSize = 0; // Cannot open any position at all.
        else if (MaxPositionSizeByMargin > MaxLot) OutputMaxPositionSize = MaxLot;
        double steps = 0;
        if (LotStep != 0) steps = OutputMaxPositionSize / LotStep;
        if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
        if (MathFloor(steps) < steps) OutputMaxPositionSize = MathFloor(steps) * LotStep;
    }

    UsedMargin = AccountMargin() + PositionMargin;

    StopOut = false;
    FutureMargin = Round(AccountFreeMargin() - PositionMargin, 2, RoundDown);

// Percentage mode.
    if (AccStopoutMode == 0)
    {
        double ML = 0;

        if (UsedMargin != 0) ML = AccountEquity() / UsedMargin * 100;
        if ((ML > 0) && (ML <= AccStopoutLevel)) StopOut = true;
    }
// Absolute value mode.
    else
    {
        if (FutureMargin <= AccStopoutLevel) StopOut = true;
    }

    if (FutureMargin < 0) StopOut = true;
}

//+------------------------------------------------------------------+
//| Gets info on overnight swaps.                                    |
//+------------------------------------------------------------------+
void GetSwapData()
{
    int swap_type = (int)MarketInfo(Symbol(), MODE_SWAPTYPE);
    double swap_long = MarketInfo(Symbol(), MODE_SWAPLONG);
    double swap_short = MarketInfo(Symbol(), MODE_SWAPSHORT);
    double swap_long_1_lot = EMPTY_VALUE, swap_short_1_lot = EMPTY_VALUE;
    switch(swap_type)
    {
// Points
    case 0:
    {
        double tick_value;
        double tick_value_long;
        double tick_value_short;
        if ((ProfitCalcMode == 1) || ((ProfitCalcMode == 2) && (ProfitCurrency != account_currency))) // CFD or Futures with different account currency.
        {
            if (ProfitCalcMode == 2) tick_value = MarketInfo(Symbol(), MODE_TICKVALUE); // Futures, but will still have to be adjusted by CCC.
            else tick_value = TickSize * LotSize; // Apparently, it is more accurate than taking TICKVALUE directly in some cases.
            tick_value_long = tick_value;
            tick_value_short = tick_value;
            // If profit currency is different from account currency.
            if (ProfitCurrency != account_currency)
            {
                // Adjust the unit cost.
                double CCC;
                if (tick_value_long > 0) CCC = CalculateAdjustment(Profit); // Positive swap - point value based profit calcution.
                else if (tick_value_long < 0) CCC = CalculateAdjustment(Loss); // Negative swap - point value based loss calcution.
                else CCC = 0;
                tick_value_long *= CCC;

                if (tick_value_short > 0) CCC = CalculateAdjustment(Profit); // Positive swap - point value based profit calcution.
                else if (tick_value_short < 0) CCC = CalculateAdjustment(Loss); // Negative swap - point value based loss calcution.
                else CCC = 0;
                CCC = CalculateAdjustment(OP_SELL);
                tick_value_short *= CCC;
            }
        }
        else
        {
            tick_value = MarketInfo(Symbol(), MODE_TICKVALUE); // Same currency futures or Forex.
            tick_value_long = tick_value;
            tick_value_short = tick_value;
        }
        OutputSwapsType = "Points";
        swap_long_1_lot = swap_long * tick_value_long;
        swap_short_1_lot = swap_short * tick_value_short;
    }
    break;
// Base currency
    case 1:
    {
        string base_currency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
        OutputSwapsType = "Base currency (" + base_currency + ")";
        // Simple case:
        if (account_currency == base_currency)
        {
            swap_long_1_lot = swap_long;
            swap_short_1_lot = swap_short;
        }
        // Need to find the current BAS/ACC or ACC/BAS rate.
        else
        {
            // Simple case - use Symbol rates for conversion:
            if (account_currency == ProfitCurrency)
            {
                if (sets.EntryType == Instant)
                {
                    swap_long_1_lot = swap_long * Bid;
                    swap_short_1_lot = swap_short * Bid;
                }
                // For pending orders, we may use the pending order's open price for calculation.
                else
                {
                    swap_long_1_lot = swap_long * sets.EntryLevel;
                    swap_short_1_lot = swap_short * sets.EntryLevel;
                }
            }
            // Go through Market Watch trying to find the currency pair with both base_currency and account_currency in it.
            else
            {
                if (SwapConversionSymbol == "") // Hasn't been found yet.
                {
                    // Number of symbols in Market Watch (even if they are not visible there).
                    int symbols_total = SymbolsTotal(false);
                    for (int i = 0; i < symbols_total; i++)
                    {
                        string symbol = SymbolName(i, false);
                        if (MarketInfo(symbol, MODE_PROFITCALCMODE) != 0) continue;
                        string base_currency_s = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
                        string profit_currency_s = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
                        // Found BAS/ACC currency pair.
                        if (((base_currency_s == base_currency) && (profit_currency_s == account_currency))
                                // Found ACC/BAS currency pair.
                                || ((base_currency_s == account_currency) && (profit_currency_s == base_currency)))
                        {
                            SwapConversionSymbol = symbol;
                            break;
                        }
                    }
                }
                if (SwapConversionSymbol != "") // Already found.
                {
                    string base_currency_s = SymbolInfoString(SwapConversionSymbol, SYMBOL_CURRENCY_BASE);
                    string profit_currency_s = SymbolInfoString(SwapConversionSymbol, SYMBOL_CURRENCY_PROFIT);
                    SymbolSelect(SwapConversionSymbol, true);
                    // It is a BAS/ACC currency pair.
                    if ((base_currency_s == base_currency) && (profit_currency_s == account_currency))
                    {
                        double bid = SymbolInfoDouble(SwapConversionSymbol, SYMBOL_BID);
                        // Symbol not yet synced.
                        if (!bid) break;
                        // Symbol is synchronized and can be used for swap calculation.
                        swap_long_1_lot = swap_long * bid;
                        swap_short_1_lot = swap_short * bid;
                        break;
                    }
                    // It is an ACC/BAS currency pair.
                    else if ((base_currency_s == account_currency) && (profit_currency_s == base_currency))
                    {
                        double ask = SymbolInfoDouble(SwapConversionSymbol, SYMBOL_ASK);
                        // Symbol not yet synced.
                        if (!ask) break;
                        // Symbol is synchronized and can be used for swap calculation.
                        swap_long_1_lot = swap_long / ask;
                        swap_short_1_lot = swap_short / ask;
                        break;
                    }
                }
            }
        }
    }
    break;
// Interest - based on price during rollover.
    case 2:
    {
        double symbol_cost_1_lot_profit, symbol_cost_1_lot_loss;
        OutputSwapsType = "Interest";
        // Calculate it by pending order's price.

        // If Forex or futures (same currency), current formula should be OK.
        if ((ProfitCalcMode != 1) && ((ProfitCalcMode != 2) || (ProfitCurrency != account_currency))) // Not CFD and (not futures or account currency same as profit currency).
        {
            if (sets.EntryType == Pending)
                symbol_cost_1_lot_loss = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * sets.EntryLevel / TickSize;
            // Calculate it by current price of contract - it is impossible to determine potential future price.
            else symbol_cost_1_lot_loss = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize;
            symbol_cost_1_lot_profit = symbol_cost_1_lot_loss;
        }
        // If CFD and profit currency = account currency, then contract_size * price.
        // If CFD and profit currency != account currency, then contract_size * price using adjustment.
        else // CFD.
        {
            if (sets.EntryType == Pending)
            {
                if (ProfitCalcMode == 2) symbol_cost_1_lot_loss = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * sets.EntryLevel / TickSize;
                else symbol_cost_1_lot_loss = LotSize * sets.EntryLevel;
            }
            // Calculate it by current price of contract - it is impossible to determine potential future price.
            else
            {
                if (ProfitCalcMode == 2) symbol_cost_1_lot_loss = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize;
                else symbol_cost_1_lot_loss = LotSize * SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            }
            if (ProfitCurrency != account_currency)
            {
                double CCC_loss = CalculateAdjustment(Loss);
                double CCC_profit = CalculateAdjustment(Profit);
                // Adjust the unit cost.
                symbol_cost_1_lot_profit = symbol_cost_1_lot_loss * CCC_profit;
                symbol_cost_1_lot_loss = symbol_cost_1_lot_loss * CCC_loss;
            }
            else symbol_cost_1_lot_profit = symbol_cost_1_lot_loss;
        }

        // Percentage per 360 days.
        if (swap_long > 0) swap_long_1_lot = swap_long * symbol_cost_1_lot_profit / 100 / 360; // Positive swap - point value based profit calcution.
        else if (swap_long < 0) swap_long_1_lot = swap_long * symbol_cost_1_lot_loss / 100 / 360; // Negative swap - point value based loss calcution.
        else swap_long_1_lot = 0;
        if (swap_short > 0) swap_short_1_lot = swap_short * symbol_cost_1_lot_profit / 100 / 360; // Positive swap - point value based profit calcution.
        else if (swap_short < 0) swap_short_1_lot = swap_short * symbol_cost_1_lot_loss / 100 / 360; // Negative swap - point value based loss calcution.
        else swap_short_1_lot = 0;

        // Stupid fix for strange cases when swap is given not in percentage points but in coefficient (?).
        if (MathAbs(swap_long) < 0.1)
        {
            swap_long_1_lot *= 1000;
            swap_short_1_lot *= 1000;
        }
        break;
    }
// Account currency.
    case 3:
        OutputSwapsType = account_currency;
        swap_long_1_lot = swap_long;
        swap_short_1_lot = swap_short;
        break;
    default:
        break;
    }
    if ((swap_long_1_lot != EMPTY_VALUE) && (swap_short_1_lot != EMPTY_VALUE))
    {
        OutputSwapsDailyLongLot = FormatDouble(DoubleToString(swap_long_1_lot, 2));
        OutputSwapsDailyShortLot = FormatDouble(DoubleToString(swap_short_1_lot, 2));
        OutputSwapsCurrencyDailyLot = account_currency + " per lot";
        OutputSwapsDailyLongPS = FormatDouble(DoubleToString(swap_long_1_lot * OutputPositionSize, 2));
        OutputSwapsDailyShortPS = FormatDouble(DoubleToString(swap_short_1_lot * OutputPositionSize, 2));
        OutputSwapsCurrencyDailyPS = account_currency + " per PS (" + DoubleToString(OutputPositionSize, 2) + ")";

        OutputSwapsYearlyLongLot = FormatDouble(DoubleToString(swap_long_1_lot * 360, 2));
        OutputSwapsYearlyShortLot = FormatDouble(DoubleToString(swap_short_1_lot * 360, 2));
        OutputSwapsCurrencyYearlyLot = account_currency + " per lot";
        OutputSwapsYearlyLongPS = FormatDouble(DoubleToString(swap_long_1_lot * 360 * OutputPositionSize, 2));
        OutputSwapsYearlyShortPS = FormatDouble(DoubleToString(swap_short_1_lot * 360 * OutputPositionSize, 2));
        OutputSwapsCurrencyYearlyPS = account_currency + " per PS (" + DoubleToString(OutputPositionSize, 2) + ")";
    }
}

//+------------------------------------------------------------------+
//| Round a double value to a given decimal place - down or normal.  |
//+------------------------------------------------------------------+
double Round(const double value, const double digits, bool round_down = false)
{
    int norm = (int)MathPow(10, digits);
    if (!round_down) return(MathRound(value * norm) / norm);
    else return(MathFloor(value * norm) / norm);
}

//+---------------------------------------------------------------------------+
//| Formats double with thousands separator for so many digits after the dot. |
//+---------------------------------------------------------------------------+
string FormatDouble(const string number, const int digits = 2)
{
// Find "." position.
    int pos = StringFind(number, ".");
    string integer = number;
    string decimal = "";
    if (pos > -1)
    {
        integer = StringSubstr(number, 0, pos);
        decimal = StringSubstr(number, pos, digits + 1);
    }
    string formatted = "";
    string comma = "";

    while (StringLen(integer) > 3)
    {
        int length = StringLen(integer);
        string group = StringSubstr(integer, length - 3);
        formatted = group + comma + formatted;
        comma = ",";
        integer = StringSubstr(integer, 0, length - 3);
    }
    if (integer == "-") comma = "";
    if (integer != "") formatted = integer + comma + formatted;

    return(formatted + decimal);
}

//+------------------------------------------------------------------+
//| Counts decimal places.                                           |
//+------------------------------------------------------------------+
int CountDecimalPlaces(double number)
{
    // 100 as maximum length of number.
    for (int i = 0; i < 100; i++)
    {
        double pwr = MathPow(10, i);
        if (MathRound(number * pwr) / pwr == number) return(i);
    }
    return(-1);
}

//+------------------------------------------------------------------+
//| Draws a label for a line with a geiven text.                     |
//+------------------------------------------------------------------+
void DrawLineLabel(const string label, const string text, const double price, const color col, bool above = false)
{
    // Data not loaded yet.
    if (Bars <= 0) return;

    int x, y;
    long real_x;
    uint w, h;

    ObjectSetText(label, text, font_size, font_face, col);
    real_x = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - 2;
    // Needed only for y, x is derived from the chart width.
    ChartTimePriceToXY(0, 0, Time[0], price, x, y);
    // Get the width of the text based on font and its size. Negative because OS-dependent, *10 because set in 1/10 of pt.
    TextSetFont(font_face, font_size * -10);
    TextGetSize(text, w, h);
    ObjectSetInteger(0, label, OBJPROP_XDISTANCE, real_x - w);
    if (above) y -= int(h + 1);
    ObjectSetInteger(0, label, OBJPROP_YDISTANCE, y);
}

//+------------------------------------------------------------------+
//| Calculates symbol leverage value based on required margin        |
//| and current rates.                                               |
//+------------------------------------------------------------------+
void CalculateSymbolLeverage()
{
    double tickValue;

    if (ProfitCalcMode == 1)
    {
        tickValue = TickSize * LotSize; // Apparently, it is more accurate than taking TICKVALUE directly in some cases.
        // If profit currency is different from account currency.
        if (ProfitCurrency != account_currency)
        {
            double CCC = CalculateAdjustment(Loss);
            // Adjust the unit cost.
            tickValue *= CCC;
        }
    }
    else tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);

    if ((TickSize == 0) || (tickValue == 0)) return;
    double lotValue        = SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize * tickValue;
    if (PreHedgingPositionMargin == 0) return;
    double margin = PreHedgingPositionMargin;
    if ((OriginalPreHedgingPositionMargin > 0) && (CustomLeverage > 0)) margin = OriginalPreHedgingPositionMargin; // Recalculate margin using the original leverage, not the custom leverage.
    SymbolLeverage         = lotValue / margin * OutputPositionSize;
}
//+------------------------------------------------------------------+