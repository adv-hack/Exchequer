Unit OleStatU;

{ markd6 12:58 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 19/09/94                      }
{                                                              }
{            Dictionary to Variable Link up Support 2          }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Dialogs,
     SysUtils,
     StrUtils,
     GlobVar,
     VarConst,
     CacheCustAgeing,
     ExBtTh1U;

Type
  DictLinkType  =  Record
                     DCr,
                     DPr,
                     DYr   :  Byte;
                   end;


Function GetCustStats(CCode    : Str10;
                      Mode     : Byte;
                      ChkCr    : Boolean;
                      DLink    : DictLinkType;
                      BtrObj   : TdPostExLocalPtr;
                      PrYrMode : Byte) : Double;

Function GetNomStats(NCode    : Str20;
                     Mode     : Byte;
                     HistCode : Char;
                     DLink    : DictLinkType;
                     BtrObj   : TdPostExLocalPtr;
                     PrYrMode : Byte) : Double;

function GetGLViewStats(NomViewNo  : Integer;
                        ABSViewIdx : Integer;
                        Mode       : Byte;
                        HistCode   : Char;
                        DLink      : DictLinkType;
                        BtrObj     : TdPostExLocalPtr;
                        PrYrMode   : Byte) : Double;

Function GetStkStats(NCode    : Str20;
                     Mode     : Byte;
                     HistCode : Char;
                     DLink    : DictLinkType;
                     BtrObj   : TdPostExLocalPtr;
                     PrYrMode : Byte) : Double;

Function GetJBudgStats(NCode    : Str20;
                       Mode     : Byte;
                       HistCode : Char;
                       DLink    : DictLinkType;
                       BtrObj   : TdPostExLocalPtr;
                       PrYrMode : Byte) : Double;

Function CalcCustAgeing (BtrObj  : TdPostExLocalPtr;
                         AgeIngCache : TAccountAgeingCache;
                         fAgeAs  : LongDate;
                         fAgeX   : Byte;
                         fAgeInt : Byte;
                         WantCat : Byte) : Double;

Function CKHistKey(CustCode, Location, CostC, Dept : ShortString;
                   StkFolio                        : LongInt) : Str255;

Function GetTeleStkStats(KeyHist  : Str255;
                         Mode     : Byte;
                         DLink    : DictLinkType;
                         BtrObj   : TdPostExLocalPtr;
                         PrYrMode : Byte) : Double;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETMiscU,
   ETDateU,
   BtrvU2,
   BtSupU1,
   BtKeys1U,
   ComnU2,
   DocSupU1,      { Required for CalcCustAgeing }
   Recon3U,       { Required for CalcCustAgeing }
   CurrncyU,      { Required for CalcCustAgeing }
   {$IFDEF EXSQL}
     SQLUtils,
   {$ENDIF}
   SysU2;





  { ============= Function to Return Customer History Details ============

    0 = Balance
    1 = Net Sales
    2 = Costs
    3 = Margin
    4 = Acc Debit
    5 = Acc Credit
    6 = Budget

    ChkCr = Off for Customers Debit details, On for Suppliers Credit Details.

  }


  Function GetCustStats(CCode    : Str10;
                        Mode     : Byte;
                        ChkCr    : Boolean;
                        DLink    : DictLinkType;
                        BtrObj   : TdPostExLocalPtr;
                        PrYrMode : Byte) : Double;
  Var
    Balance,
    LastYTD,
    ThisPr,
    ThisYTD,
    Cleared,
    Budget1,
    Budget2  :  Double;

    Dummy1,
    Dummy2   :  Double;

    CrDr     :  DrCrDType;

    AcPr,AcYr
             :  Byte;

    Range    :  Boolean;

    HistCode :  Char;


  Begin
    Balance:=0;
    LastYTD:=0;
    ThisPr:=0;
    ThisYTD:=0;
    Cleared:=0;

    If (Mode In [1..3]) then
      HistCode:=CustHistGPCde
    else
      HistCode:=CustHistCde;

    With DLink do
    Begin
      Range:=(DPr In [YTD,YTDNCF]) Or (PrYrMode = 1);

      AcYr:=DYr;

      If (HistCode In YTDNCFSet) and (AcYr=YTD) then
        AcYr:=BtrObj.LSyss.CYr; {* Force year back to this year if not C/F *}

      If (Range) And (PrYrMode <> 1) then
      Begin
        If (DPr=YTD) then
          AcPr:=Pred(YTDNCF)
        else
          AcPr:=BtrObj.LSyss.CPr;
      end
      else
        AcPr:=DPr;
    end;

    If (Mode <> 7) Then
      // Everything except committed balance
      Balance:=BtrObj.LTotal_Profit_to_Date(HistCode,
                                            CCode,
                                            Dlink.DCr,
                                            AcYr,
                                            AcPr,
                                            CrDr[BOff],
                                            CrDr[BOn],
                                            Cleared,
                                            Budget1,
                                            Budget2,
                                            Dummy1,
                                            Dummy2,
                                            Range)
    Else
      // Committed Balance
      Balance := BtrObj.LProfit_To_Date(HistCode,
                                        CCode,
                                        Dlink.DCr,
                                        AcYr,
                                        AcPr,
                                        CrDr[BOff],
                                        CrDr[BOn],
                                        Cleared,   // Committed Balance
                                        Range);

    Case Mode of
      0    :  GetCustStats:=Balance;
      1    :  GetCustStats:=CrDr[BOff];
      2    :  GetCustStats:=CrDr[BOn];
      3    :  GetCustStats:=CrDr[BOff]-CrDr[BOn];
      4    :  GetCustStats:=CrDr[{Not }ChkCr];    { ChkCr := (ValueReq <> 4); }
      5    :  GetCustStats:=CrDr[ChkCr];
      6    :  GetCustStats:=Budget1;
      7, 8 :  GetCustStats:=Cleared;
      9    :  GetCustStats:=Budget2;
      else  GetCustStats:=0;
    end; {Case..}

  end; {Func..}


  { ============= Function to Return Nominal History Details ============

    1 = Debit
    2 = Credit
    3 = Balance
    4 = Budget
    5 = Budget2 aka Revised Budget 1
    6 = Cleared
    7   Revised Budget 2
    8   Revised Budget 3
    9   Revised Budget 4
    10  Revised Budget 5
  }


  Function GetNomStats(NCode    : Str20;
                       Mode     : Byte;
                       HistCode : Char;
                       DLink    : DictLinkType;
                       BtrObj   : TdPostExLocalPtr;
                       PrYrMode : Byte) : Double;
 Var
   Balance,
   LastYTD,
   ThisPr,
   ThisYTD,
   Cleared,
   Budget   :  Double;

   Dummy1,
   Dummy2   :  Double;

   CrDr     :  DrCrDType;

   AcPr,AcYr
            :  Byte;

   Range    :  Boolean;

   // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
   RevisedBudget1   :  Double;
   RevisedBudget2   :  Double;
   RevisedBudget3   :  Double;
   RevisedBudget4   :  Double;
   RevisedBudget5   :  Double;
 Begin
   Balance:=0;
   LastYTD:=0;
   ThisPr:=0;
   ThisYTD:=0;
   Cleared:=0;
   Budget:=0;

   // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
   RevisedBudget1 := 0.0;
   RevisedBudget2 := 0.0;
   RevisedBudget3 := 0.0;
   RevisedBudget4 := 0.0;
   RevisedBudget5 := 0.0;

   With DLink do
   Begin
     Range:=(DPr In [YTD,YTDNCF]) Or (PrYrMode = 1);

     AcYr:=DYr;

     If (HistCode In YTDNCFSet) and (AcYr=YTD) then
       AcYr:=BtrObj.LSyss.CYr; {* Force year back to this year if not C/F *}

     If (Range) And (PrYrMode <> 1) then
     Begin
       If (DPr=YTD) then
         AcPr:=Pred(YTDNCF)
       else
         AcPr:=BtrObj.LSyss.CPr;
     end
     else
       AcPr:=DPr;
   end;

{ShowMessage ('Year: ' + IntToStr(AcYr) + #13 +
             'Period: ' + IntToStr(AcPr));}
   Balance:=BtrObj.LTotal_Profit_to_Date_RevBudgets (HistCode, FullNHCode(NCode), Dlink.DCr, AcYr, AcPr,
                                                     CrDr[BOff], CrDr[BOn], Cleared, Budget,
                                                     RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
                                                     Dummy1,Dummy2,Range);

   Case Mode of
     1  :  GetNomStats:=CrDr[BOff];
     2  :  GetNomStats:=CrDr[BOn];
     3  :  GetNomStats:=Balance;
     4  :  GetNomStats:=Budget;
     5  :  GetNomStats:=RevisedBudget1;
     6  :  GetNomStats:=Cleared;
     // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
     // Revised Budget 2
     7  :  Result := RevisedBudget2;
     // Revised Budget 3
     8  :  Result := RevisedBudget3;
     // Revised Budget 4
     9  :  Result := RevisedBudget4;
     // Revised Budget 5
     10 :  Result := RevisedBudget5;
   end; {Case..}

 end; {Func..}

{ ============= Function to Return G/L View History Details ============

  1 = Debit
  2 = Credit
  3 = Balance
  4 = Budget
  5 = Budget2
  6 = Cleared

}
function GetGLViewStats(NomViewNo  : Integer;
                        ABSViewIdx : Integer;
                        Mode       : Byte;
                        HistCode   : Char;
                        DLink      : DictLinkType;
                        BtrObj     : TdPostExLocalPtr;
                        PrYrMode   : Byte) : Double;
var
  Balance : Double;
  LastYTD : Double;
  ThisPr  : Double;
  ThisYTD : Double;
  Cleared : Double;
  Budget  : Double;
  Budget2 : Double;
  Dummy1  : Double;
  Dummy2  : Double;
  CrDr    : DrCrDType;
  AcPr    : Byte;
  AcYr    : Byte;
  Range   : Boolean;
begin
  Balance := 0;
  LastYTD := 0;
  ThisPr  := 0;
  ThisYTD := 0;
  Cleared := 0;
  Budget  := 0;
  Budget2 := 0;

  with DLink do
  begin
   Range := (DPr in [YTD,YTDNCF]) or (PrYrMode = 1);

   AcYr := DYr;

   if ((HistCode in YTDNCFSet) and (AcYr=YTD)) then
     AcYr := BtrObj.LSyss.CYr; {* Force year back to this year if not C/F *}

   if (Range and (PrYrMode <> 1)) then
   begin
     if (DPr = YTD) then
       AcPr := Pred(YTDNCF)
     else
       AcPr := BtrObj.LSyss.CPr;
   end
   else
     AcPr := DPr;
  end; // with DLink...

  Balance := BtrObj.LTotal_Profit_to_Date(
              HistCode,
              PostNVIdx(NomViewNo, ABSViewIdx),
              Dlink.DCr,
              AcYr,
              AcPr,
              CrDr[BOff],
              CrDr[BOn],
              Cleared,
              Budget,
              Budget2,
              Dummy1,
              Dummy2,
              Range
            );

  case Mode of
    1: Result := CrDr[BOff];
    2: Result := CrDr[BOn];
    3: Result := Balance;
    4: Result := Budget;
    5: Result := Budget2;
    6: Result := Cleared;
  end;

end;


   { ============= Function to Return Stock History Details ============

    1 = Qty Sold
    2 = Sales
    3 = Costs
    4 = Margin
    5 = Budget
    6 = Budget2
    10= Posted Stock Level

  }


  Function GetStkStats(NCode    : Str20;
                       Mode     : Byte;
                       HistCode : Char;
                       DLink    : DictLinkType;
                       BtrObj   : TdPostExLocalPtr;
                       PrYrMode : Byte) : Double;
 Var
   Balance,
   LastYTD,
   ThisPr,
   ThisYTD,
   Cleared,
   Budget,
   Budget2  :  Double;

   Dummy1,
   Dummy2   :  Double;

   CrDr     :  DrCrDType;

   AcPr,AcYr
            :  Byte;

   Range    :  Boolean;



 Begin
   Balance:=0;
   LastYTD:=0;
   ThisPr:=0;
   ThisYTD:=0;
   Cleared:=0;
   Budget:=0;
   Budget2:=0;

   With DLink do
   Begin
     Range:=(DPr=YTD) Or (PrYrMode = 1);

     AcYr:=DYr;

     If (Range) And (PrYrMode <> 1) then
       AcPr:=Pred(YTDNCF)
     else
       AcPr:=DPr;
   end;

   // HM 31/01/02: Extended for Stock Qty Used
   If (Mode=10) Or (Mode=11) then
     HistCode:=Calc_AltStkHCode(HistCode);


   {Balance:=BtrObj.LTotal_Profit_to_Date(HistCode,FullNCode(NCode),Dlink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,
                                         Budget,Budget2,Range);}
   Balance:=BtrObj.LTotal_Profit_to_Date(HistCode,FullNHCode(NCode),Dlink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,
                                         Budget,Budget2,Dummy1,Dummy2,Range);

   Case Mode of
     1,10
        :  GetStkStats:=Cleared;
     2  :  GetStkStats:=CrDr[BOn];
     3  :  GetStkStats:=CrDr[BOff];
     4  :  GetStkStats:=CrDr[BOn]-CrDr[BOff];
     5  :  GetStkStats:=Budget;
     6  :  GetStkStats:=Budget2;
     11 :  GetStkStats:=Dummy1;
   end; {Case..}

 end; {Func..}



  { ============= Function to Return Job Analysis History Details ============
    0  = Budget Qty
    1  = Budget Value
    2  = Revised Budget Qty
    3  = Revised Budget Value
    4  = Actual Qty
    5  = Actual Value
  }

 Function GetJBudgStats(NCode    : Str20;
                        Mode     : Byte;
                        HistCode : Char;
                        DLink    : DictLinkType;
                        BtrObj   : TdPostExLocalPtr;
                        PrYrMode : Byte) : Double;
 Var
   Balance,
   LastYTD,
   ThisPr,
   ThisYTD,
   Cleared,
   Budget,
   Budget2  :  Double;

   Qty1,
   Qty2     :  Double;

   CrDr     :  DrCrDType;
   AcPr,AcYr
            :  Byte;
   Range    :  Boolean;
 Begin
   Balance:=0;
   LastYTD:=0;
   ThisPr:=0;
   ThisYTD:=0;
   Cleared:=0;
   Budget:=0;
   Budget2:=0;
   Qty1:=0.0;
   Qty2:=0.0;

   With DLink do
   Begin
     Range:=(DPr In [YTD,YTDNCF]) Or (PrYrMode = 1);

     AcYr:=DYr;

     If (HistCode In YTDNCFSet) and (AcYr=YTD) then
       AcYr:=BtrObj.LSyss.CYr; {* Force year back to this year if not C/F *}

     If (Range) And (PrYrMode <> 1) then
     Begin
       If (DPr=YTD) then
         AcPr:=Pred(YTDNCF)
       else
         AcPr:=BtrObj.LSyss.CPr;
     end
     else
       AcPr:=DPr;
   end;

   // MH 30/05/07: Modified on EL's advice as the Qt version won't correctly handle purges, etc..
   //Balance:=BtrObj.LTotal_QtProfit_to_Date(HistCode,
   Balance:=BtrObj.LTotal_Profit_to_Date(HistCode,
                                          FullNHCode(NCode),
                                          Dlink.DCr,
                                          AcYr,
                                          AcPr,
                                          CrDr[BOff],
                                          CrDr[BOn],
                                          Cleared,
                                          Budget,
                                          Budget2,
                                          Qty1,
                                          Qty2,
                                          Range);

   Case Mode of
     0  : Result := Qty1;     { Budget Qty }
     1  : Result := Budget;   { Budget Value }
     2  : Result := Qty2;     { Revised Budget Qty }
     3  : Result := Budget2;  { Revised Budget Value }
     4  : Result := Cleared;  { Actual Qty }
     5  : Result := Balance;  { Actual Value }
     6  : Result := CrDr[BOff]; // Purchase
     7  : Result := CrDr[BOn];  // Sales
   end; {Case..}
  end; {Func..}



Function CalcCustAgeing (BtrObj  : TdPostExLocalPtr;
                         AgeIngCache : TAccountAgeingCache;
                         fAgeAs  : LongDate;
                         fAgeX   : Byte;
                         fAgeInt : Byte;
                         WantCat : Byte) : Double;
Const
  Fnum     =  InvF;
  Keypath  =  InvCustK;
Var
  CustAlObj   : GetExNObjCid;
  TotAged     :  AgedTyp;
  ExtCustRec  :  ExtCusRecPtr;
  n           :  Byte;
  LOk,
  FoundOk,
  Locked      :  Boolean;
  LineAged    :  AgedTyp;
  KeyChk,
  fKeyChk,
  KeyS        :  Str255;
Begin
  Result := 0.0;

  New(CustAlObj,Init);
  CustAlObj.MTExLocal := BtrObj;

  With CustAlObj^, MTExLocal^ Do Begin
    Blank(TotAged,Sizeof(Totaged));

    fKeyChk := LCust.CustCode;

    New(ExtCustRec);

    Blank(ExtCustRec^,Sizeof(ExtCustRec^));

    With ExtCustRec^ Do Begin
      FCusCode:=fKeyChk;

      FCr:=0;

      FNomAuto:=BOn;

      FMode:=3;

      FAlCode:=TradeCode[IsACust(LCust.CustSupp)];
      FCSCode:=LCust.CustSupp;

      FDirec:=BOn;

      FB_Func[BOff]:=B_GetPrev;
      FB_Func[BOn]:=B_GetNext;
    End; { With }

    KeyChk:=fKeyChk+LCust.CustSupp;

    KeyS:=KeyChk;

    FoundOk:=BOff;

    LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetGEq,1,KeyS);

    While LStatusOk And CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) Do
      With LInv Do Begin
        (* HM 07/01/99: Updated on EL Instruction
        FoundOk := (InvDocHed In SalesSplit+PurchSplit) And
                   ExtCusFiltCid (-1, ExtCustRec, CustAlObj) And
                   ((BaseTotalOs (LInv) * DocCnst[InvDocHed] * DocNotCnst) > 0);
        *)
        FoundOk := ((InvDocHed In SalesSplit+PurchSplit) and (ExtCusFiltCid(-1,ExtCustRec,CustAlObj)) and
                   (BaseTotalOs(LInv)<>0)) ;

        If FoundOk Then Begin
          Blank(LineAged,Sizeof(LineAged));


          { Calculate Totals }
          If LSyss.StaUIDate then
            MasterAged(LineAged,TransDate,fAgeAs,BaseTotalOS(LInv),fAgeX,fAgeInt)
          Else
            MasterAged(LineAged,DueDate,fAgeAs,BaseTotalOS(LInv),fAgeX,fAgeInt);

          For n:=0 To 5 Do Begin
            Case n Of
              0,1  :  Begin
                        TotAged[1]:=TotAged[1]+LineAged[n];
                      End;
              2..5
                   :  Begin
                        TotAged[n]:=TotAged[n]+LineAged[n];
                      End;

            end; {Case..}
          End; { For }
        End;

        {$IFDEF EXSQL}
        If SQLUtils.UsingSQL Then
          // For SQL use standard Btrieve as Extended Btrieve is really slow
          LStatus:=LFind_Rec(B_GetNext,FNum,KeyPath,KeyS)
        Else
        {$ENDIF}
          LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetNext,3,KeyS);
      End; { With }

    Result := TotAged[Succ(WantCat)];

    // Add to cache so we don't have to keep scanning the transactions
    AgeIngCache.AddToCache (LCust.CustSupp, LCust.CustCode, IfThen (fAgeX = 1, 'D', IfThen (fAgeX = 2, 'W', 'M')), fAgeAs, fAgeInt, TotAged[1], TotAged[2], TotAged[3], TotAged[4], TotAged[5]);

    Dispose(ExtCustRec);
  End; { With }

  Dispose(CustAlObj,Done);
End;



Function Full_CuStkHKey1(cc : Str10; sc : LongInt)  :  Str30;
Begin { Full_CuStkHKey1 }
  Result := FullCustCode(cc) + ConstStr(#0,4) + FullNomKey(sc) + HelpKStop;
End;  { Full_CuStkHKey1 }

Function Full_CuStkHKey2(cc     : Str10;
                         sc     : LongInt;
                         RCCDep : Str10) : Str30;
Begin { Full_CuStkHKey2 }
  Result := #1 + Full_CuStkHKey1(cc, sc) + RCCDep;
End;  { Full_CuStkHKey2 }

Function Full_CuStkHKey3(cc     : Str10;
                         sc     : LongInt;
                         RCCDep : Str10) : Str30;
Begin { Full_CuStkHKey3 }
  Result := #2 + Full_CuStkHKey1(cc,sc) + RCCDep;
End;  { Full_CuStkHKey3 }


{ ==== Function to return appropriate key for hist based on filters ==== }
Function CKHistKey(CustCode, Location, CostC, Dept : ShortString;
                   StkFolio                        : LongInt) : Str255;
Begin { CKHistKey }
  Result := '';

  { Check location }
  If (Not EmptyKey(Location,MLocKeyLen)) Then Begin
    { got location - build key }
    Result:=Full_CuStkHKey3(CustCode,StkFolio,Location);
  End { If }
  Else
    { Check Cost Centre }
    If (Not EmptyKey(CostC,CCKeyLen)) Then Begin
      { Got Cost Centre - build key }
      Result := Full_CuStkHKey2(CustCode,StkFolio,PostCCKey(True,CostC));
    End { If }
    Else
      { Check Department }
      If (Not EmptyKey(Dept,CCKeyLen)) Then Begin
        { Got Department - build key }
        Result := Full_CuStkHKey2(CustCode,StkFolio,PostCCKey(False,Dept));
      End { If }
      Else Begin
        { Set Default key }
        Result := Full_CuStkHKey1(CustCode, StkFolio);
      End; { Else }
End; { CKHistKey }


{ Function to return Telesales Stock History }
{  1 = Qty Sold
    2 = Sales
    3 = Costs
    4 = Margin
    5 = Budget
}
Function GetTeleStkStats(KeyHist  : Str255;
                         Mode     : Byte;
                         DLink    : DictLinkType;
                         BtrObj   : TdPostExLocalPtr;
                         PrYrMode : Byte) : Double;
Var
  Balance, LastYTD, ThisPr, ThisYTD,
  Cleared, Budget, Budget2           : Double;
  Dummy1, Dummy2                     : Double;
  CrDr         : DrCrDType;
  AcPr,AcYr    : Byte;
  Range        : Boolean;
Begin
  Balance:=0;
  LastYTD:=0;
  ThisPr:=0;
  ThisYTD:=0;
  Cleared:=0;
  Budget:=0;
  Budget2:=0;

  With DLink Do Begin
    Range:=(DPr=YTD) Or (PrYrMode = 1);

    AcYr:=DYr;

    If (Range) And (PrYrMode <> 1) then
      AcPr:=Pred(YTDNCF)
    else
      AcPr:=DPr;
  End; { With }

  Balance:=BtrObj.LTotal_Profit_to_Date(cuStkHistCode,
                                        KeyHist,
                                        Dlink.DCr,
                                        AcYr,
                                        AcPr,
                                        CrDr[BOff],
                                        CrDr[BOn],
                                        Cleared,
                                        Budget,
                                        Budget2,
                                        Dummy1,
                                        Dummy2,
                                        Range);

  Case Mode of
    1  : Result := Cleared;
    2  : Result := CrDr[BOn];
    3  : Result := CrDr[BOff];
    4  : Result := CrDr[BOn]-CrDr[BOff];
    5  : Result := Budget;
  End; { Case }
End; {Func..}

end. {Unit..}
