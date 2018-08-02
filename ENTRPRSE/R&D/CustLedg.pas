unit CustLedg;

interface

uses SysUtils, GlobVar, VarConst, EtDateU, ComnU2, ComnUnit, ExWrap1U, DocSupU1,
  CurrncyU, Saltxl1U, BtSupU1, InvFSu3U, EtMiscU, BtKeys1U, SysU1;

function LedgerColumnAsFloat(ExLocal: TdExLocalPtr; LNHCtrl: TNHCtrlRec; DisplayMode, Col: Byte): double;
function LedgerColumn(ExLocal: TdExLocalPtr; LNHCtrl: TNHCtrlRec; DisplayMode, Col: Byte; ForSort: Boolean = False): Str255;

implementation

Uses PromptPaymentDiscountFuncs, oTakePPD;

function LedgerColumnAsFloat(ExLocal: TdExLocalPtr; LNHCtrl: TNHCtrlRec; DisplayMode, Col: Byte): double;
var
  UOR: Byte;
  TSales, TCost, TProfit: Real;
begin
  TSales := 0;
  TCost := 0;
  TProfit := 0;
  UOR := 0;
  Result := 0;
  with ExLocal^, LNHCtrl, Inv do
  begin
    case Col of
     2  :  begin
             case DisplayMode of
               0  :  begin
                       If (NHCr=0) then
                         Result:=Settled
                       else
                         Result:=CurrSettled;
                     end;

               6  :  begin
                       TSales:=ITotal(Inv)-InvVAT;
                       If (NHCr=0) then
                       begin
                         UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                         TSales:=Conv_TCurr(TSales,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                       end;
                       Result:=(TSales*DocCnst[InvDocHed]*DocNotCnst);
                     end;
             end; {case..}
           end;
     3  :  begin
             case DisplayMode of
               0  :  begin
                       If (NHCr=0) then 
                         Result:=BasetotalOS(Inv)
                       else
                         Result:=CurrencyOS(Inv,BOn,BOff,BOff);
                     end;
               6  :  begin
                       If (InvDocHed In SalesSplit-RecieptSet) and (Show_CMG(InvDocHed)) then
                         TCost:=TotalCost
                       else
                         TCost:=0;
                       If (NHCr=0) then
                       begin
                         UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                         TCost:=Conv_TCurr(TCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                       end;
                       Result:=(TCost*DocCnst[InvDocHed]*DocNotCnst);
                     end;
             end; {case..}
           end;


     4  :  begin
             case DisplayMode of
               0  :  begin
                       Result:=(ConvCurrItotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst);
                     end;
               6  :  begin
                       If (InvDocHed In SalesSplit-RecieptSet) and (Show_CMG(InvDocHed))  then
                       begin
                         TProfit:=TSales-TCost;
                         Result:=TProfit;
                       end
                       else
                         Result:=0;
                     end;
             end; {case..}
           end;

     5  :  begin
             case DisplayMode of
               0  :  begin
                       Result:=(Itotal(Inv)*DocCnst[InvDocHed]*DocNotCnst);
                     end;
               6  :  begin
                       If (InvDocHed In SalesSplit-RecieptSet) and (Show_CMG(InvDocHed))  then
                         Result:=Calc_Pcnt(TSales,TProfit)
                       else
                         Result:=0;
                     end;
             end; {case..}
           end;

     else
       Result:=0.0;
    end; {case..}
  end; {With..}
end;

function LedgerColumn(ExLocal: TdExLocalPtr; LNHCtrl: TNHCtrlRec; DisplayMode, Col: Byte; ForSort: Boolean): Str255;
Var
  GenStr :  Str255;
  n, TCr :  Byte;
  Rnum   :  Real;
Begin
  with ExLocal^, LNHCtrl, Inv do
  Begin
    case Col of
      0  :  Result:=Pr_OurRef(Inv);

      1  :  if ForSort then
              Result := TransDate
            else if (NomAuto) then
              Result:=POutDate(TransDate)
            else
              Result:=Pr_AutoDue(Inv);

      2  :  begin
              Rnum := LedgerColumnAsFloat(ExLocal, LNHCtrl, DisplayMode, Col);
              Result:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
            end;

      3  :  begin
              Rnum := LedgerColumnAsFloat(ExLocal, LNHCtrl, DisplayMode, Col);
              Result:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
            end;

      4  :  begin
              Rnum := LedgerColumnAsFloat(ExLocal, LNHCtrl, DisplayMode, Col);
              if (DisplayMode = 0) then
                TCr := 0
              else
                TCr := NHCr;
              Result := FormatCurFloat(GenRealMask,Rnum,BOff,TCr);
            end;

      5  :  begin
              Rnum := LedgerColumnAsFloat(ExLocal, LNHCtrl, DisplayMode, Col);
              case DisplayMode of
                0  :  Begin
                        Result:=FormatCurFloat(GenRealMask,Rnum,BOff,Currency);
                      end;
                6  :  Begin
                        Result:=FormatFloat(GenPcntMask,Rnum);
                      end;
              end; {case..}
            end;

      6  :  if (Not SWInfoSOn) then
              Result:=dbFormatSlash(YourRef,TransDesc)
            else
              Result:=TransDesc;

      7  :  if ForSort then
              Result := DueDate
            else
              Result := POutDate(DueDate);

      8  :  begin
              Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,BOff,OnPickRun);

              // MH 24/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
              n := 0 +
                   (1 * Ord((DiscSetAm <> 0) Or (thPPDGoodsValue <> 0.0) Or (thPPDVATValue <> 0.0))) +
                   // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                   (1 * Ord(DiscTaken or PDiscTaken Or (thPPDTaken <> ptPPDNotTaken)));
              //n:=0+(1*Ord((DiscSetAm<>0)))+(1*Ord((DiscTaken=True) or (PDiscTaken=True)));

              GenStr:=DiscStatus[n];

              If (Trim(GenStr)<>'') then
                Result:=GenStr+' ! '+Result;
            end;

      //PR: 06/05/2015 ABSEXCH-16284 v7.0.15 PPD T2-121
      9  :  begin // PPD value
              // MH 20/05/2015 v7.0.14 ABSEXCH-16443: Only show values for SIN/SJI/PIN/PJI
              If (InvDocHed In PPDTakeTransactions) Then
              Begin
                RNum := Round_Up(thPPDGoodsValue + thPPDVATValue, 2);
                if RNum = 0.00 then
                  Result := ''
                else
                  Result := FormatCurFloat(GenRealMask,Rnum,BOff,Currency);
              End // If (InvDocHed In PPDTakeTransactions)
              Else
                Result := ''
            end;
      10 :  begin // PPD Expiry
              // MH 20/05/2015 v7.0.14 ABSEXCH-16443: Only show values for SIN/SJI/PIN/PJI
              If (InvDocHed In PPDTakeTransactions) Then
              Begin
                // MH 20/05/2015 v7.0.14 ABSEXCH-16443: Show 'Given'/'Taken' if Taken
                If (thPPDTaken = ptPPDNotTaken) Then
                Begin
                  // MH 20/05/2015 v7.0.14 ABSEXCH-16443: Suppress entries with no PPD value
                  RNum := Round_Up(thPPDGoodsValue + thPPDVATValue, 2);
                  if (thPPDDays = 0) Or (RNum = 0.0) then
                    Result := ''
                  else
                    Result := POutDate(CalcDueDate(TransDate, thPPDDays));
                End // If (thPPDTaken = ptPPDNotTaken)
                Else
                  Result := PPDGiveTakeWord(LCust.CustSupp) + 'n';
              End // If (InvDocHed In PPDTakeTransactions)
              Else
                Result := ''
            end;
      else
        Result := '';
    end; {case..}
  end; {With..}
end;

end.

