Unit MiscU;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 07/08/90                      }
{                                                              }
{                 Misc Common Non-Overlaid Unit                }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses
  GlobVar,
  ETMiscU,

  { IFDEF CU}  { MH 19/11/97: Doesn't compile with this #def}
    CustIntU,
  { ENDIF}

  VarRec2U,
  VarConst,
  RevChrgU,
  EXWrap1U;




Var
  InvNetAnal   :    INetAnalType;
  InvNetTrig   :    IVATAnalType;




  Function InvLTotalND(IdR        :  IDetail;
                       UseDisc    :  Boolean;
                       SetlDisc   :  Double;
                       FullDec    :  SmallInt)  :  Double;

  Function InvLTotal(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double)  :  Double;

  {$IFDEF STK}
    Function InvLOOS(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double)  :  Double;
  {$ENDIF}

  Function InvLCost(IdR        :  IDetail)  :  Double;

  Function InvLCost2(IdR        :  IDetail)  :  Double;

  Procedure CalcVAT(Var  IdR        :  IDetail;
                         SetlDisc   :  Double);


  Procedure CalcVATExLocal(Var ExLocal      :  TdExLocal;
                               FromCV       :  Boolean;
                               ExCustEvent  :  TCustomEvent);

  Procedure CalcInvTotals(Var InvR      :  InvRec;
                          Var ExLocal   :  TDExLocal;
                              ReCalcVAT,
                              DiscLNet  :  Boolean);

  Procedure CalcInvVATTotals(Var  InvR :  InvRec;
                             Var ExLocal   :  TdExLocal;
                                 ReCalcVAT :  Boolean);

  Procedure LCalcInvTotals(Var  InvR :  InvRec;
                           ExLocal   :  TdMTExLocalPtr;
                           ReCalcVAT,
                           DiscLNet  :  Boolean);

  Procedure Re_CalcManualVAT(Var InvR    :  InvRec;
                             Var ExLocal :  TdExLocal;
                                 NewSetl :  Double);

// CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
// -- added BuildingReturn parameter
// -- changed from procedure to function: returns False if the transaction
//    should be removed from the report (only used for VAT Return)
function LDef_InvCalc(ExLocal : TdMTExLocalPtr;
                       Const oServices : TRCServicesHelper = NIL;
                       IncludeNotionalVAT: Boolean = False;
                       BuildingReturn: Boolean = False): Boolean;

Procedure Def_InvCalc;

Function SDiscNom(DT  :  DocTypes)  :  NomCtrlType;

Procedure UpdateRecBal(Var   TInv     :  InvRec;
                       Const NomCode  :  Longint;
                       Const Amount,
                             VAmount  :  Double;
                       Const CRates   :  CurrTypes;
                       Const UpCr     :  Byte;
                             UOR      :  Byte;
                       Const Mode     :  Byte);

{$IFDEF SOP}
//PR: 19/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from a transaction
function TransOSWithVAT(InvR : InvRec) : Double;

//PR: 19/06/2012 ABSEXCH-11528 Exposed in interface so it can be used by ExBtth1U.pas
function TransOSWithManualVAT(InvR : InvRec) : Double;

//PR: 19/06/2012 ABSEXCH-11528 Function to return required o/s value including or excluding VAT as required by system setup
function TransOSValue(InvR : InvRec) : Double;


{$ENDIF}

{$IF DEFINED(STK) OR DEFINED(COMTK)}
//PR: 19/06/2012 ABSEXCH-11528 Function to return o/s value from line including VAT
Function LineOSWithVAT(IdR        :  IDetail;
                       SetlDisc   :  Double)  :  Double;
{$IFEND}

{$IF DEFINED(SOP) OR DEFINED(COMTK) OR DEFINED(SOPDLL)}
//PR: 19/06/2012 ABSEXCH-11528 Function to return required o/s line value including or excluding VAT as required by system setup
function LineOSValue(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double) : Double;
{$IFEND}

//PR: 19/06/2012 ABSEXCH-11528 Similar transactions for Apps & Vals.
Function JAPLineOSWithVAT(IdR        :  IDetail;
                         SetlDisc   :  Double)  :  Double;

function JAPTransOSWithVAT(InvR : InvRec) : Double;

function JAPTransOSValue(InvR : InvRec) : Double;

// CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
function IsExcludedNoTC(InvR: InvRec; IdR: IDetail): Boolean;

//PR: 23/11/2017 ABSEXCH-19451 Returns True if we can only edit GDPR fields
function RestrictedEditOnly(InvR : InvRec) : Boolean;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     ETStrU,
     BtrvU2,
     BTKeys1U,
     ComnUnit,
     ComnU2,
     CurrncyU,
     {$IFNDEF EDLL}
       {$IFNDEF RW}
         {$IFNDEF WCA}
         {$IFNDEF ENDV}
         {$IFNDEF XO}
         {$IFNDEF EBAD}
         {$IFNDEF ENSECR}
         {$IFNDEF OLE}      { HM 03/06/03 }
           InvLst2U,

           {$IFDEF STK}
             InvCTSUU,

           {$ENDIF}
         {$ENDIF}
         {$ENDIF}
         {$ENDIF}
         {$ENDIF}
         {$ENDIF}
         {$ENDIF}
       {$ENDIF}
     {$ENDIF}

     {$IFDEF CU}
       CustAbsU,
       CustWinU,
       Event1U,
     {$ENDIF}

     BTSupU1,
     SysUtils,

     SysU2,

     //PR: 22/06/2012 ABSEXCH-11528 (needed for ZeroFloat function.)
     MathUtil,

     // CJS 2014-09-09 - ABSEXCH-15516 - include EC Services in notional VAT
     SavePos,

     // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Calculate Prompt Payment Discount Goods and VAT Values
     PromptPaymentDiscountFuncs,

     BtSupU3;

Var
  ProtectDate  :  Byte;



  // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
  function IsExcludedNoTC(InvR: InvRec; IdR: IDetail): Boolean;
  const
    ExcludedCodes: array[0..3] of string = ('17', '20', '40', '50');
  var
    i: Integer;
    NoTC: string;
  begin
    Result := False;
    // Get the Nature of Transaction code from the line
    NoTC := IdR.tlIntrastatNoTC;
    // If the NoTC on the line is empty, use the NoTC from the header instead
    if Trim(NoTC) = '' then
      NoTC := Format('%02d', [InvR.TransNat]);
    // Check the NoTC against the list of excluded codes, and return True if
    // it matches any of them
    for i := Low(ExcludedCodes) to High(ExcludedCodes) do
    begin
      if ExcludedCodes[i] = NoTC then
      begin
        Result := True;
        break;
      end;
    end;
  end;

  { *==================== Calculate One Line of Invoice ================= }

  {Idr Contains the line to be processed.
  UseDisc determines if any line or settlement discount needs to be taken into account
  SetlDisc is the percentage amount of header level settlement discount to be applied if UseDisc is True.
  FullDec stiplulates to how many decimal places the result is returned.
  }

  Function InvLTotalND(IdR        :  IDetail;
                       UseDisc    :  Boolean;
                       SetlDisc   :  Double;
                       FullDec    :  SmallInt)  :  Double;
  Var
    Rnum,
    WithDisc  :  Double;

    LineQty,
    CalcNetValue,
    DiscBasis,
    NewDiscBasis,
    LDiscValue,
    PriceEach :  Double;

    DVal1,DVal2,
    DVal3     :  Extended;

    UseDecs,
    LTDecs,
    UseQDecs  :  Byte;


  Begin
    LTDecs:=2;

    With IdR do
    Begin
      If (FullDec=-1) then
      Begin
        UseDecs:=12;
        LTDecs:=12;
      end
      else
      Begin
        If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
          UseDecs:=Syss.NoNetDec
        else
          UseDecs:=Syss.NoCosDec;
      end;



      UseQDecs:=Syss.NoQtyDec;

      CalcNetValue:=0.0;  DiscBasis:=0.0;  LDiscValue:=0.0;

      If (IdDocHed In JAPSPlit) then
      Begin
        LineQty:=1.0;
        CalcNetValue:=NetValue;
        PriceEach:=NetValue;
      end
      else
        Begin
          LDiscValue:=Discount;

          LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);

          {* Ability to affect unit price factor *}

          If (Round_Up(PriceMulX,UseDecs)<>0.0) then
            CalcNetValue:=(NetValue*PriceMulX)
          else
            CalcNetValue:=NetValue;



          If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
          Begin
            If (ShowCase) then
            Begin
              PriceEach:=CalcNetValue;
              LineQty:=DivWChk(Qty,QtyPack);
              UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
            end
            else
              PriceEach:=(DivWChk(QtyMul,QtyPack)*CalcNetValue);
            {PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);}
          end
          else
            PriceEach:=CalcNetValue;
        end;

      If (IncNetValue<>0.0) and ((VATCode=VATMCode) or (DLLUpdate=99)) then  {* v5.00.003 Discount is based on original inclusive VAT value *}
        DiscBasis:=IncNetValue
      else
        DiscBasis:=PriceEach;

      // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
      //Rnum:=Calc_PAmount(Round_Up(DiscBasis,UseDecs),LDiscValue,DiscountChr);
      Rnum:=Calc_PAmountAD(Round_Up(DiscBasis,UseDecs),
                           LDiscValue, DiscountChr,
                           Discount2, Discount2Chr,
                           Discount3, Discount3Chr);

      {$IFDEF DBD}
         DVal1:=Round_Up(LineQty,UseQDecs);
         DVal2:=Round_Up(PriceEach,UseDecs);

         DVal3:=DVal2-Rnum;

         WithDisc:=Round_Up(DVal1*DVal3,LTDecs);

      {$ELSE}
        WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),LTDecs);
      {$ENDIF}

      WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,SetlDisc,PcntChr),LTDecs);

      If (UseDisc) then
        InvLTotalND:=WithDisc
      else
        InvLTotalND:=Round_Up(Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs),LTDecs);
    end;{With..}
  end;


  { *Evalu ==================== Calculate One Line of Invoice ================= }

  Function InvLTotal(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double)  :  Double;

  Begin
    Result:=InvLTotalND(IdR,UseDisc,SetlDisc,0);

  end;


  { *Evalu ==================== Calculate One cost Line of Invoice ================= }

  Function InvLCost(IdR        :  IDetail)  :  Double;

  Var
    Rnum,
    WithDisc  :  Double;

    LineQty   :  Double;



  Begin
    With IdR do
    Begin
      {*EN420}

      {If (ShowCase) and (QtyPack<>0) and (PrxPack) then
        LineQty:=DivWChk(Qty,QtyPack)
      else}
        LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);


      InvLCost:=Round_Up(Round_Up(LineQty,Syss.NoQtyDec)*Round_Up(CostPrice,Syss.NoCosDec),2);
    end;{With..}
  end;

  { ==================== Calculate One cost apport Line of Invoice ================= }

  Function InvLCost2(IdR        :  IDetail)  :  Double;

  Var
    Rnum,
    WithDisc  :  Double;

    LineQty   :  Double;



  Begin
    With IdR do
    Begin
      {*EN420}

      {If (ShowCase) and (QtyPack<>0) and (PrxPack) then
        LineQty:=DivWChk(Qty,QtyPack)
      else}
        LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);


      InvLCost2:=Round_Up(Round_Up(LineQty,Syss.NoQtyDec)*Round_Up(CostApport,Syss.NoCosDec),2);
    end;{With..}
  end;


  {* Calculate O/S Order Total *}

{$IFDEF STK}

  Function InvLOOS(IdR        :  IDetail;
                   UseDisc    :  Boolean;
                   SetlDisc   :  Double)  :  Double;
  Var
    Rnum,
    WithDisc  :  Double;

    DiscBasis,
    LineQty,
    CalcNetValue,
    PriceEach :  Double;


    UseDecs,
    UseQDecs  :  Byte;


  Begin
    With IdR do
    Begin
      {* This method of working out added v4.30}
      LineQty:=Calc_IdQty(Qty_OS(IdR),QtyMul,UsePack);

      CalcNetValue:=0.0;


      UseQDecs:=Syss.NoQtyDec;

      If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
        UseDecs:=Syss.NoNetDec
      else
        UseDecs:=Syss.NoCosDec;

      {* Ability to affect unit price factor *}

      If (Round_Up(PriceMulX,UseDecs)<>0.0) then
        CalcNetValue:=(NetValue*PriceMulX)
      else
        CalcNetValue:=NetValue;


      If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
      Begin
        If (ShowCase) then
        Begin
          PriceEach:=CalcNetValue;
          LineQty:=DivWChk(Qty_OS(IdR),QtyPack);
          UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
        end
        else
          PriceEach:=(DivWChk(QtyMul,QtyPack)*CalcNetValue);
        {PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);}
      end
      else
        PriceEach:=CalcNetValue;

      // MH 16/06/2010 v6.4 ABSEXCH-9969: Corrected calculation for inclusive VAT lines
      If (IncNetValue<>0.0) and ((VATCode=VATMCode) or (DLLUpdate=99)) then  {* v5.00.003 Discount is based on original inclusive VAT value *}
        DiscBasis:=IncNetValue
      else
        DiscBasis:=PriceEach;

      { Disabled v4.20If (ShowCase) and (QtyPack<>0) and (PrxPack) then
        LineQty:=DivWChk(Qty_OS(Idr),QtyPack)
      else
        LineQty:=Calc_IdQty(Qty_OS(Idr),QtyMul,UsePack);}

      // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
      //Rnum:=Calc_PAmount(Round_Up(PriceEach,UseDecs),Discount,DiscountChr);
      Rnum:=Calc_PAmountAD(Round_Up(DiscBasis,UseDecs),
                           Discount, DiscountChr,
                           Discount2, Discount2Chr,
                           Discount3, Discount3Chr);

      WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),2);

      WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,SetlDisc,PcntChr),2);

      If (UseDisc) then
        InvLOOS:=WithDisc
      else
        InvLOOS:=Round_Up(Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs),2);
    end;{With..}
  end;

{$ENDIF}

{$IF DEFINED(STK) OR DEFINED(COMTK)}
//PR: 19/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from line
Function LineOSWithVAT(IdR        :  IDetail;
                       SetlDisc   :  Double)  :  Double;
var
  NetOS : Double;
  VATRateForLine : Double;
Begin
  //Get standard o/s value
  NetOS := InvLOOS(Idr, True, SetlDisc);

  //Find VAT Rate
  VATRateForLine := TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(Idr.VatCode,Idr.VATIncFlg)].Rate, 10);

  //Calculate o/s amount including VAT
  Result := NetOS + Round_Up((NetOS * VATRateForLine), 2);
end;
{$IFEND}

{$IFDEF SOP}
//PR: 19/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from a transaction
//PR: 22/06/2012 ABSEXCH-11528 To deal with manual vat, separated out function to read lines and calculate vat
//and added function to calculated os vat from header. TransOSWithVAT will call the appropriate function,
//depending upon value of InvR.ManVAT.


function TransOSWithManualVAT(InvR : InvRec) : Double;
var
  OSPortion : Double;
  dNet : Double;
begin
  //PR: 02/11/2012 ABSEXCH-13647 Was using InvR.NetValue which doesn't take discount into account. Change to used ITotal less InvVat
  dNet := ITotal(InvR)-InvR.InvVAT;
  //Calculate portion of order that is still o/s
  if ZeroFloat(InvR.TotOrdOS) or ZeroFloat(dNet) then
    OSPortion := 0
  else
    OSPortion := Round_Up(InvR.TotOrdOS / dNet, 2);

  //Return o/s total plus correct portion of VAT
  Result := InvR.TotOrdOS + (InvR.InvVAT * OSPortion);
end;

function TransOSWithVATFromLines(InvR : InvRec) : Double;
var
  Res  : Integer;
  sKey : Str255;

  KPath : Integer;
  RecAddr : Longint;

begin
  Result := 0;

  //RB 30/04/2018: ABSEXCH-18994 Albion Fine Foods - Core SQL errors relating to missing Schema records
  KPath := 0;
  RecAddr := 0;

  //Store position in detail file
  Res := Presrv_BTPos(IDetailF, KPath, F[IDetailF], RecAddr, False, False);

  //Iterate through all lines for the transaction, totalling the o/s value including VAT.
  sKey := FullNomKey(InvR.FolioNum);

  Try
    Res := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
    while (Res = 0) and (Id.FolioRef = InvR.FolioNum) do
    begin
      Result := Result + LineOSWithVAT(Id, InvR.DiscSetl);

      Res := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
    end;
  Finally
    //Restore position in Detail File
    Presrv_BTPos(IDetailF, KPath, F[IDetailF], RecAddr, True, False);
  End;
end;

function TransOSWithVAT(InvR : InvRec) : Double;
var
  UOR : Byte;
begin
  //Direct to appropriate function depending upon manual vat flag
  if InvR.ManVAT then
    Result := TransOSWithManualVAT(InvR)
  else
    Result := TransOSWithVATFromLines(InvR);

    //Convert result to base
    with InvR do
    begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      Result := Round_Up(Conv_TCurr(Result,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
    end;
end;



//PR: 19/06/2012 ABSEXCH-11528 Function to return required o/s value including or excluding VAT as required by system setup
function TransOSValue(InvR : InvRec) : Double;
var
  UOR : Byte;
begin
  with InvR do
  begin
    //Find correct o/s value
    if Syss.IncludeVATInCommittedBalance then
      Result := TransOSWithVAT(InvR)
    else
    begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      Result := Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
    end;
  end;
end;

{$ENDIF SOP}


{$IF DEFINED(SOP) OR DEFINED(COMTK) OR DEFINED(SOPDLL)}
//PR: 19/06/2012 ABSEXCH-11528 Function to return required o/s line value including or excluding VAT as required by system setup
function LineOSValue(IdR        :  IDetail;
                     UseDisc    :  Boolean;
                     SetlDisc   :  Double) : Double;
begin
  if Syss.IncludeVATInCommittedBalance then
    Result := LineOSWithVAT(IdR, SetlDisc)
  else
    Result := InvLOOS(IdR, UseDisc, SetlDisc);
end;
{$IFEND}

//PR: 21/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from JAP line
Function JAPLineOSWithVAT(IdR        :  IDetail;
                       SetlDisc   :  Double)  :  Double;
var
  VATRateForLine : Double;
Begin
  //Find VAT Rate
  VATRateForLine := TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(Idr.VatCode,Idr.VATIncFlg)].Rate, 10);

  //Calculate o/s amount including VAT - applied for is held in QtyDel
  Result := Idr.QtyDel + Round_Up((Idr.QtyDel * VATRateForLine), 2);
end;

//PR: 21/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from a JAP transaction
function JAPTransOSWithVAT(InvR : InvRec) : Double;
var
  Res  : Integer;
  sKey : Str255;

  KPath : Integer;
  RecAddr : Longint;
begin
  Result := 0;

  //RB 30/04/2018: ABSEXCH-18994 Albion Fine Foods - Core SQL errors relating to missing Schema records
  KPath := 0;
  RecAddr := 0;

  //Store position in detail file
  Res := Presrv_BTPos(IDetailF, KPath, F[IDetailF], RecAddr, False, False);

  //Iterate through all lines for the transaction, totalling the o/s value including VAT.
  sKey := FullNomKey(InvR.FolioNum);

  Try
    Res := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
    while (Res = 0) and (Id.FolioRef = InvR.FolioNum) do
    begin
      Result := Result + JAPLineOSWithVAT(Id, InvR.DiscSetl);

      Res := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
    end;
  Finally
    //Restore position in Detail File
    Presrv_BTPos(IDetailF, KPath, F[IDetailF], RecAddr, True, False);
  End;
end;

//PR: 21/06/2012 ABSEXCH-11528 Function to return required o/s value of JAP trans including or excluding VAT as required by system setup
function JAPTransOSValue(InvR : InvRec) : Double;
var
  UOR : Byte;
begin
  with InvR do
  begin
    if Syss.IncludeVATInCommittedBalance then
      Result := JAPTransOSWithVAT(InvR)
    else
    begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      Result := Round_Up(Conv_TCurr(TotalCost - TotalOrdered, XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
    end;

  end;
end;



  { *Evalu =================== Calculate Line VAT ============== See BatchLnU also using CalcVAT and ExBtth1u LCalcThVAT for thread safe ops}

  Procedure CalcVAT(Var  IdR        :  IDetail;
                         SetlDisc   :  Double);

  Var
    IdLineDecs   :    Byte;

    VATRateLine,
    VATRateStd,
    VATUAMnt,
    VATUDiff,
    LineDiscount,
    NewNetValue,
    NewTotal,
    OrigValue    :  Double;
    ExLocal      :  TdExlocal;
    CustomEvent  :  TCustomEvent;
    UseLocalCalc :  Boolean;

    TmpId        :  IDetail;

    //PR: 19/05/2014 ABSEXCH-12772 Need to replace use of Qty in inclusive vat calcs with call to ComnUnit.Calc_IdQty. To
    //                             save numerous call store value in ThisQty variable.
    ThisQty : Double;


  Begin
    UseLocalCalc:=BOn;  NewTotal:=0.0;  IdLineDecs:=2;


    {$IFDEF CU}
      CustomEvent:=TCustomEvent.Create(EnterpriseBase+MiscBase+1,1);

      Try
        With CustomEvent do
        Begin
          If (GotEvent) then
          With ExLocal do
          Begin
            Try
              ExLocal.Create;

              UseLocalCalc:=BOff;

              LId:=IdR;

              CalcVATExLocal(ExLocal,BOn,CustomEvent);

              IdR:=LId;

            Finally
              ExLocal.Destroy;
            end;
          end;
        end;
      finally
        CustomEvent.Free;
      end;
    {$ENDIF}


    If (UseLocalCalc) then
    With IdR do
    Begin
      VATUAmnt:=0.0;  VATUDiff:=0.0;


      VATRateLine:=TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(VatCode,VATIncFlg)].Rate,10);
      VATRateStd:=TrueReal(SyssVAT^.VATRates.VAT[GetIVATNo(VATIncFlg)].Rate,10);

      Case VatCode of
        'S','Z','E','1'..'9','A','D','T','X','B','C','F','G','R','W','Y'
            :  Begin
                 VAT:=Round_Up((InvLTotal(IdR,BOn,SetlDisc)*VATRateLine),2);

                 IncNetValue:=0.0;
               end;
        'I','M'
            :  Begin
                 //PR: 19/05/2014 ABSEXCH-12772
                 ThisQty := Calc_IdQty(Qty,QtyMul,UsePack);
                 If (IncNetValue=0.0) or (VATCode=VATICode) then  {* First time round if a % discount is present, we cannot include
                                                               settlement discount. We would reply on a second call to this
                                                               with Vat code set to M *}

                   // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
                   //LineDiscount:=Calc_PcntPcnt(NetValue,Discount,SetlDisc*Ord(DiscountChr<>PcntChr),DiscountChr,PcntChr)
                   LineDiscount := Calc_PcntPcntAD (NetValue,
                                                    Discount, DiscountChr,
                                                    Discount2, Discount2Chr,
                                                    Discount3, Discount3Chr,
                                                    SetlDisc*Ord(DiscountChr<>PcntChr), PcntChr)
                 else
                   // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
                   //LineDiscount:=Calc_PcntPcnt(IncNetValue,Discount,SetlDisc,DiscountChr,PcntChr);
                   LineDiscount := Calc_PcntPcntAD (IncNetValue,
                                                    Discount, DiscountChr,
                                                    Discount2, Discount2Chr,
                                                    Discount3, Discount3Chr,
                                                    SetlDisc, PcntChr);

                 If (IdDocHed In PurchSplit) then
                   IdLineDecs:=Syss.NoCosDec
                 else
                   IdLineDecs:=Syss.NoNetDec;

                 If (VATCode='M') then
                 Begin
                   If (IncNetValue=0.0) then
                   Begin
                     //PR: 19/05/2014 ABSEXCH-12772
                     If ThisQty<>1.0 then
                       NetValue:=((NetValue-LineDiscount)*(VATRateStd+1))+LineDiscount
                     else
                       NetValue:=(Round_Up(NetValue,IdLineDecs)+VAT);
                   end
                   else
                     NetValue:=IncNetValue;
                 end
                 else
                 Begin
                   IncNetValue:=NetValue;

                   If (DiscountChr=PcntChr) then
                   Begin
                     {Discount:=LineDiscount; DiscountChr:=#0;}

                   end;
                 end;


	         OrigValue:=Round_Up(NetValue,IdLineDecs)-
			    Round_Up(LineDiscount,2);


                 {VAT:=Round_Up(Round_Up(((OrigValue*VATRateStd)/
                                 (VATRateStd+1)),2)*Qty,2);}

                 {Altered in v4.31 so that inclusive VAT is worked out by comparing the total inclusive
                  against the calculated VAT and adjusted accordingly *}

                  VATUAMnt:=Round_Up(((OrigValue*VATRateStd)/
                                 (VATRateStd+1)),2);

                  NewTotal:=(NetValue-LineDiscount);

                  {If (Round_Up(Calc_PcntPcnt(NetValue,Discount,SetlDisc,DiscountChr,PcntChr),2)=0.0) then}
                    NetValue:=NetValue-((NewTotal*VATRateStd)/(VATRateStd+1));



                 //PR: 19/05/2014 ABSEXCH-12772
                 VAT:=Round_Up(VATUAmnt*ThisQty,2);

                 //PR: 19/05/2014 ABSEXCH-12772
                 VATUAmnt:=Round_Up(OrigValue*ThisQty,2);

                 //PR: 19/05/2014 ABSEXCH-12772
                 NewTotal:=(Round_Up((Round_Up(NetValue,IdLineDecs)-
			    Round_Up(LineDiscount,2))*ThisQty,2)+VAT);

                 VATUDiff:=Round_Up(VATUAmnt-NewTotal,2);


                 VAT:=VAT+VATUDiff;


                 If (IncNetValue<>0.0) and (SetlDisc<>0.0)  then
                 Begin
                   // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
                   //LineDiscount:=Calc_PcntPcnt(IncNetValue,Discount,0,DiscountChr,PcntChr);
                   LineDiscount := Calc_PcntPcntAD (IncNetValue,
                                                    Discount, DiscountChr,
                                                    Discount2, Discount2Chr,
                                                    Discount3, Discount3Chr,
                                                    0, PcntChr);

                   //PR: 19/05/2014 ABSEXCH-12772
                   NewTotal:=(IncNetValue-LineDiscount)*ThisQty;

                   //PR: 19/05/2014 ABSEXCH-12772
                   NetValue:=Round_Up(IncNetValue-DivWChk(((NewTotal*VATRateStd)/(VATRateStd+1)),ThisQty),idLineDecs);

                   {VatUAmnt:=Round_Up(NewTotal,2);

                   VATUDiff:=Round_Up(VATUAmnt-Calc_PcntPcnt(VATUAmnt,0,SetlDisc,#0,PcntChr),2);

                   VATUAmnt:=(NetValue-LineDiscount);


                   NewTotal:=Round_Up((VATUAmnt*Qty)-Calc_PcntPcnt(VatUAmnt*Qty,0,SetlDisc,#0,PcntChr),2);

                   Vat:=Round_Up(VATUDiff-NewTotal,2);}

                   TmpId:=IdR;

                   With TmpId do
                   Begin
                     If (VATIncFlg In VATSet) then
                       VATCode:=VATIncFlg
                     else
                       VATCode:=VATSTDCode;

                     DLLUpdate:=99;

                     CalcVAT(TmpId,SetlDisc);
                   end;

                   VAT:=TmpId.VAT;

                 end;

                 If (VAT<>0.0) then
                   VATCode:=VATMCode;
               end;

      end; {case..}
    end; {With..}

  end; {Proc..}




  Procedure CalcVATExLocal(Var ExLocal      :  TdExLocal;
                               FromCV       :  Boolean;
                               ExCustEvent  :  TCustomEvent);
  Var
    CustomEvent  :  TCustomEvent;

    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    OldInv       :  InvRec;
    OldCust      :  CustRec;
    OldStock     :  StockRec;

    KeyS         :  Str255;

    VS,DC        :  Boolean;


  Begin
    {$IFDEF CU}

      If (Assigned(ExCustEvent)) then
        CustomEvent:=ExCustEvent
      else
        CustomEvent:=TCustomEvent.Create(EnterpriseBase+MiscBase+1,1);


      Try
        With CustomEvent do
        Begin

          If (GotEvent) then
          Begin


            If (FromCV) then
            With ExLocal do
            Begin

              LResetRec(InvF);

              If (Inv.FolioNum=LId.FolioRef) then
                LInv:=Inv
              else
              Begin
                OldInv:=Inv;
                TmpKPath:=GetPosKey;

                TmpStat:=LPresrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOff,BOff);


                Blank(KeyS,Sizeof(KeyS));

                KeyS:=FullNomKey(LId.FolioRef);

                TmpStat:=Find_Rec(B_GetEq,F[InvF],InvF,ExLocal.LRecPtr[InvF]^,InvFolioK,KeyS);

                TmpStat:=LPresrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOn,BOff);

                Inv:=OldInv;

              end;

              LResetRec(CustF);

              If (Cust.CustCode=LId.CustCode) then
                LCust:=Cust
              else
                If (Not EmptyKey(LId.CustCode,CustKeyLen)) then
                Begin
                  OldCust:=Cust;

                  TmpKPath:=GetPosKey;

                  TmpStat:=LPresrv_BTPos(CustF,TmpKPath,F[CustF],TmpRecAddr,BOff,BOff);

                  KeyS:=LId.CustCode;

                  TmpStat:=Find_Rec(B_GetEq,F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK,KeyS);

                  TmpStat:=LPresrv_BTPos(CustF,TmpKPath,F[CustF],TmpRecAddr,BOn,BOff);

                  Cust:=OldCust;
                end;


              LResetRec(StockF);

              If (Stock.StockCode=LId.StockCode) then
                LStock:=Stock
              else
                If (Is_FullStkCode(LId.StockCode)) then
                Begin
                  OldStock:=Stock;

                  TmpKPath:=GetPosKey;

                  TmpStat:=LPresrv_BTPos(StockF,TmpKPath,F[StockF],TmpRecAddr,BOff,BOff);

                  KeyS:=LId.StockCode;

                  TmpStat:=Find_Rec(B_GetEq,F[StockF],StockF,ExLocal.LRecPtr[StockF]^,StkCodeK,KeyS);

                  TmpStat:=LPresrv_BTPos(StockF,TmpKPath,F[StockF],TmpRecAddr,BOn,BOff);

                  Stock:=OldStock;
                end;

            end; {If from non Exlocal source}

            BuildEvent(ExLocal);

            Execute;


            VS:=ValidStatus;
            DC:=DataChanged;

            If (VS and DC) then
            With ExLocal, EntSysObj.Transaction.thLines, TABSInvLine2(thCurrentLine) do
            Begin
              // HM 06/10/00: If any additional fields are returned then
              // Ex_CalcLineTax in the Toolkit DLL/COM Toolkit should
              // also be updated.

              If (tlVATCode In VATSet) then
                LId.VATCode:=tlVATCode;

              LId.VAT:=tlVATAmount;
              LId.NetValue:=tlNetValue;
              LId.IncNetValue:=tlVATInclValue;

              // HM 06/10/00: See comment above
            end;

          end
          else
            If (Not FromCV) then
            Begin
              With ExLocal do
                CalcVAT(LId,LInv.DiscSetl);

            end;
        end;
      finally
        If (Not Assigned(ExCustEvent)) then
          CustomEvent.Free;

      end; {Try..}
    {$ELSE}
      With ExLocal do
        CalcVAT(LId,LInv.DiscSetl);
    {$ENDIF}

  end; {Proc..}


  {*Evalu - original in InvLtot.Blk }


  Function ShowManualRates(InvR  :  InvRec;
                           ReCalcVAT
                                 :  Boolean;
                           LFlgs :  IVATAnalType)  :  IVATAnalType;

  Var
    n  : VATType;

  Begin
    Result:=LFlgs;

    If (Not ReCalcVAT) then {* Check for any manual entries *}
    Begin
      For n:=VStart to VEnd do
      Begin
        Result[n]:=(Result[n] or (InvR.InvVatAnal[n]<>0.00));
      end;
    end;

  end;


  { ================= Calculate Invoice Totals ================ }

  Procedure CalcInvTotals(Var InvR      :  InvRec;
                          Var ExLocal   :  TdExLocal;
                              ReCalcVAT,
                              DiscLNet  :  Boolean);


  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var
    NewXRate  :  Boolean;

    UOR       :  Byte;

    KeyS,
    KeyChk    :  Str255;


    LineTotal,
    DiscLineTotal,

    TempQty,
    WithDiscVal
              :  Double;

    ExStatus  :  Integer;

    LargeLine :  LongInt;

    NextDelD  :  LongDate;

    OrigId    :  IDetail;

    CostRates :  CurrTypes;

    NewCostPrice
              :  Double;

  Procedure Update_Line;

  Begin
{$IFNDEF EDLL}  { HM 17/04/01: Added to get FDes to compile, code previously in IFDEF section in main procedure}
{$IFNDEF RW}
{$IFNDEF EBAD}
{$IFNDEF WCA}
{$IFNDEF OLE}   { HM 03/06/03 }
    Id.PPr:=InvR.AcPr;
    Id.PYr:=InvR.AcYr;

    {$IFDEF CU}
      If (ProtectDate=0) then {Its never been run, so run once}
      Begin
        If (EnableCustBtns(4000,57)) then {Check for hook to stop Line date overwrite}
          ProtectDate:=2
        else
          ProtectDate:=1;
      end;

    {$ENDIF}

    If (Not (InvR.InvDocHed In OrderSet+QuotesSet))
    and ((Id.SOPLink=0) or (Not (InvR.InvDocHed In SalesSplit+PurchSplit-DeliverSet))) and (ProtectDate<>2) then
      Id.PDate:=InvR.TransDate;


    {$IFDEF PF_On}

      If (JbCostOn) and (LineTotal<>0) and (Id.KitLink=0) then
        Update_JobAct(Id,InvR);

    {$ENDIF}

    ExStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_Berror(Fnum,ExStatus);
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
  end; {Proc..}


  Begin
    If (Not (InvR.InvDocHed In JAPSplit)) then
    Begin
      LineTotal:=0;

      DiscLineTotal:=0;

      WithDiscVal:=0;

      ExStatus:=0;

      LargeLine:=0;   NewCostPrice:=0.0;  TempQty:=0.0; 

      NewXRate:=BOff; Blank(CostRates,Sizeof(CostRates));  UOR:=0;


      With InvR do
      Begin
        InvNetVal:=0; InvVat:=0; DiscAmount:=0; DiscSetAm:=0; TotalCost:=0; TotalCost2:=0.0;

        TotalWeight:=0; TotOrdOS:=0;

        NextDelD:=MaxUntilDate;

        Blank(DocLSplit,Sizeof(DocLSplit));

        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        If (ReCalcVAT) then
          Blank(InvVatAnal,Sizeof(InvVatAnal));

        With ExLocal do
        Begin
          Blank(LInvNetAnal,Sizeof(LInvNetAnal));

          {* Initialise VAT Flags  added here so that an edit will reset any rates
             which do not exist anymore on the Document *}

          Blank(LInvNetTrig,Sizeof(LInvNetTrig));
        end;


        KeyChk:=FullNomKey(FolioNum);

        KeyS:=FullIdKey(FolioNum,1);


      end;


      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  do
      Begin

        With Id do
        Begin
          If (Id.LineNo<>RecieptCode) then
          Begin
            If (LineNo>LargeLine) then  {* Reset ILineCount}
              LargeLine:=LineNo;

            If (ABSLineNo>LargeLine) then  {* Reset ILineCount}
              LargeLine:=ABSLineNo;


            {* Reset Earliest Delivery Date on O/S lines only *}

            {$IFDEF STK}

              If (InvR.InvDocHed In OrderSet) and (PDate<NextDelD)
                 and (LineType=StkLineType[IdDocHed]) and (Is_FullStkCode(StockCode)) then
                NextDelD:=PDate;

            {$ENDIF}


            LineTotal:=Round_Up(InvLTotal(Id,BOff,0),2);

            InvR.InvNetVal:=InvR.InvNetVal+LineTotal;

            InvR.TotalCost:=InvR.TotalCost+InvLCost(Id);
            InvR.TotalCost2:=InvR.TotalCost2+InvLCost2(Id);

            DiscLineTotal:=Round_Up(InvLTotal(Id,BOn,0),2);

            WithDiscVal:=WithDiscVal+DiscLineTotal;


              If (IdDocHed In StkRetSplit) then
              Begin
               InvR.DocLSplit[1]:=InvR.DocLSplit[1]+Qty;
               InvR.DocLSplit[2]:=InvR.DocLSplit[2]+QtyPick;
               InvR.DocLSplit[3]:=InvR.DocLSplit[3]+QtyDel;
               InvR.DocLSplit[4]:=InvR.DocLSplit[4]+QtyWOff;

               TempQty:=Qty;

               Qty:=QtyDel;

               InvR.DocLSplit[6]:=InvR.DocLSplit[6]+Round_Up(InvLTotal(Id,BOn,0),2);

               Qty:=TempQty;
              end
              else
                If (DocLTLink>0) then
                  InvR.DocLSplit[DocLTLink]:=InvR.DocLSplit[DocLTLink]+LineTotal;

            
            InvR.TotalWeight:=InvR.TotalWeight+(Calc_IdQty(Qty,QtyMul,UsePack)*LWeight);

            If (ReCalcVAT) then
              InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]:=InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]+Vat;

            {$IFDEF SOPDLL}
              {$DEFINE SOP}
            {$ENDIF}


            {.$IFDEF SOP} //PR: 20/05/2009 Needed to allow COM Toolkit to redo totals after adding TTD/VBD
            {$If Defined(SOP) or Defined(COMTK)}
              If (InvR.InvDocHed In PSOPSet) then {* Calculate how much of the order remains O/S *}
                InvR.TotOrdOS:=InvR.TotOrdOS+InvLOOS(Id,BOn,0);
            {$IfEnd}
            {.$ENDIF}

            {$IFDEF SOPDLL}
              {$UNDEF SOP}
            {$ENDIF}
            

            {* v1.35 Invoice discount total was being worked out by line removed *}


            If (DiscLNet) then
              LineTotal:=Round_Up(InvLTotal(Id,BOn,(InvR.DiscSetl*Ord(InvR.DiscTaken))),2);

            With ExLocal do
            Begin
              LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]:=LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]+LineTotal;

              LInvNetTrig[GetVAtNo(VATcode,VATIncFlg)]:=BOn; {* Show Rate is being used, Value independant *}
            end;

            {* Force currency value to be the same *}
            {$IFNDEF EDLL}
              {$IFNDEF RW}
                {$IFNDEF WCA}
                {$IFNDEF ENDV}
                {$IFNDEF XO}
                                                      {v5.50. Added check for LViewonly as lines should not be updated in a view only mode, can cause
                                                              corruption of corate exchange rate on unallocated posted transactions when just viewing it, if this routine called *}
                  NewXRate:=DiffHedXRate(InvR,Id) and (Not ExLocal.LViewOnly);

                  If ((Id.Currency<>InvR.Currency) or (Id.CustCode<>InvR.CustCode) or (NewXRate)) and (InvR.InvDocHed In PurchSplit+SalesSplit)
                    or (Id.PPr<>InvR.ACPr) or (Id.PYr<>InvR.ACYr)
                    or ((Id.PDate<>InvR.TransDate) and (Not (InvR.InvDocHed In OrderSet+QuotesSet)))
                    and (Not ExLocal.LViewOnly) then {v5.50 check for LViewonly added}
                  Begin
                    OrigId:=Id;

                    If (InvR.InvDocHed In PurchSplit+SalesSplit) then
                    Begin
                      Id.Currency:=InvR.Currency;
                      Id.CXRate:=InvR.CXRate;
                      Id.CurrTriR:=InvR.CurrTriR;

                      Id.UseORate:=InvR.UseORate;
                      Id.CustCode:=InvR.CustCode;

                                           {*v5.70 also check for account code changes as these may well have brought about new pricing*}
                      If (NewXRate) or (OrigId.CustCode<>InvR.CustCode) then {We need to adjust stock effect...}
                      Begin
                        {$IFNDEF EBAD}
                        {$IFNDEF OLE}  { HM 03/06/03 }
                        {$IFDEF STK}
                          If (Is_FullStkCode(Id.StockCode)) and (Id.IdDocHed In StkInSet-[PCR,PRF,PJC]) then
                          Begin
                            Stock_Deduct(OrigId,InvR,BOff,BOn,99);

                            Stock_Deduct(Id,InvR,BOn,BOn,99);

                            {$IFDEF SOP}
                              UpdateSNos(InvR,Id,BOff);
                            {$ENDIF}
                          end
                          else {If a sales item convert cost price from ole curreny to new}
                           If (IdDocHed In SalesSplit) then
                           Begin
                             CostRates:=OrigId.CXRate;

                             If (OrigID.COSConvRate<>0.0) then {* We have original rate *}
                               CostRates[UseCoDayRate]:=OrigId.COSConvRate;

                             NewCostPrice:=Conv_TCurr(CostPrice,XRate(CostRates,BOff,OrigId.Currency),OrigId.Currency,UOR,BOff);

                             CostPrice:=Round_Up(Currency_ConvFT(NewCostPrice,0,Currency,UseCoDayRate),Syss.NoCOSDec);

                             {* Keep rate at posting used for COS *}

                             COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];

                           end;
                        {$ENDIF}
                        {$ENDIF}
                        {$ENDIF}
                      end;
                    end;

                    Update_Line;

                  end;
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}

          end{If Receipt Line}
          else
            If (Id.PPr<>InvR.ACPr) or (Id.PYr<>InvR.ACYr) or (Id.PDate<>InvR.TransDate) and (Not ExLocal.LViewOnly) then
            Begin
              Update_Line;
            end;

        end; {With..}


        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      InvR.DiscAmount:=Round_Up(InvR.InvNetVal-WithDiscVal,2);   {* v1.35 *}

      InvR.InvVat:=CalcTotalVAT(InvR);

      InvR.DiscSetAm:=Round_Up(Calc_PAmount((InvR.InvNetVal-InvR.DiscAmount),InvR.DiscSetl,PcntChr),2);

      // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Calculate Prompt Payment Discount Goods and VAT Values
      UpdatePPDTotals (InvR);

      InvR.ILineCount:=LargeLine+2+Ord((InvR.InvDocHed In DirectSet) and (InvR.TotalInvoiced<>0.0)); {*EL Duplicate line error on directs b601.003*}

      If (InvR.InvDocHed In OrderSet) and (NextDelD<>MaxUntilDate) then
        InvR.DueDate:=NextDelD;

      With ExLocal do
        LInvNetTrig:=ShowManualRates(InvR,ReCalcVAT,LInvNetTrig);


    end; {With..}
  end; {Proc..}

  { ================= Calculate Invoice Totals ================ }

  Procedure CalcInvVATTotals(Var  InvR :  InvRec;
                         Var ExLocal   :  TdExLocal;
                             ReCalcVAT :  Boolean);


  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;


    LineTotal
              :  Double;

    ExStatus  :  Integer;

    NomVATRate : Double;
  Begin
    If (Not (InvR.InvDocHed In JAPSplit)) then
    With ExLocal do
    Begin
      LineTotal:=0;


      ExStatus:=0;

      With InvR do
      Begin
        InvVat:=0;

        If (ReCalcVAT) then
          Blank(InvVatAnal,Sizeof(InvVatAnal));

        With ExLocal do
        Begin
          Blank(LInvNetAnal,Sizeof(LInvNetAnal));

          {* Initialise VAT Flags  added here so that an edit will reset any rates
             which do not exist anymore on the Document *}

          Blank(LInvNetTrig,Sizeof(LInvNetTrig));
        end;

        KeyChk:=FullNomKey(FolioNum);

        If (InvDocHed=NMT) then
        Begin
          KeyS:=FullIdKey(FolioNum,RecieptCode);

          InvNetVal:=0.0;
        end
        else
          KeyS:=FullIdKey(FolioNum,1);


      end;


      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and ((LId.LineNo<>RecieptCode) or (LId.IdDocHed=NMT)) do
      Begin

        With LId do
        Begin
          {For NOM's all values must be in consolidated currency}
          LineTotal:=Round_Up(Conv_TCurr(InvLTotal(LId,BOff,0),CXRate[UseCoDayRate],Currency,UseORate,BOff),2);


          If (ReCalcVAT) then //PR: 22/06/2011 Changed to use exchange rate from Line for VAT
            InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]:=InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]+Round_Up(Conv_TCurr(VAT,CXRate[True],Currency,UseORate,BOff),2);

          If (IdDocHed=NMT) then
            UpdateRecBal(InvR,NomCode,NetValue,0.0,CXRate,Currency,UseORate,4);

          With ExLocal do
          Begin
            LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]:=LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]+LineTotal;

            If (IdDocHed<>NMT) or (NOMIOFlg<>0) then
              LInvNetTrig[GetVAtNo(VATcode,VATIncFlg)]:=BOn; {* Show Rate is being used, Value independant *}
          end;


        end; {With..}


        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


      end; {While..}


      InvR.InvVat:=CalcTotalVAT(InvR);


      LInvNetTrig:=ShowManualRates(InvR,ReCalcVAT,LInvNetTrig);


    end; {With..}
  end; {Proc..}


  Procedure LCalcInvTotals(Var  InvR :  InvRec;
                           ExLocal   :  TdMTExLocalPtr;
                           ReCalcVAT,
                           DiscLNet  :  Boolean);



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;


    LineTotal,
    DiscLineTotal,
    WithDiscVal
              :  Double;

    ExStatus  :  Integer;

    LargeLine :  LongInt;

    NextDelD  :  LongDate;


  Begin
    If (Not (InvR.InvDocHed In JAPSplit)) then
    With ExLocal^ do
    Begin
      LineTotal:=0;

      DiscLineTotal:=0;

      WithDiscVal:=0;

      LineTotal:=0;

      DiscLineTotal:=0;

      WithDiscVal:=0;

      ExStatus:=0;

      LargeLine:=0;

      With InvR do
      Begin
        InvNetVal:=0; InvVat:=0; DiscAmount:=0; DiscSetAm:=0; TotalCost:=0;

        TotalWeight:=0; TotOrdOS:=0;

        NextDelD:=MaxUntilDate;

        Blank(DocLSplit,Sizeof(DocLSplit));

        If (ReCalcVAT) then
          Blank(InvVatAnal,Sizeof(InvVatAnal));


        KeyChk:=FullNomKey(FolioNum);

        KeyS:=FullIdKey(FolioNum,1);


      end;


      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);


      While (LStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (LId.LineNo<>RecieptCode) do
      Begin

        With LId do
        Begin
          If (LineNo>LargeLine) then  {* Reset ILineCount}
            LargeLine:=LineNo;

          If (ABSLineNo>LargeLine) then  {* Reset ILineCount}
            LargeLine:=ABSLineNo;


          {* Reset Earliest Delivery Date on O/S lines only *}

          {$IFDEF STK}

            If (InvR.InvDocHed In OrderSet) and (PDate<NextDelD) and (LineType=StkLineType[IdDocHed]) then
              NextDelD:=PDate;

          {$ENDIF}


          LineTotal:=Round_Up(InvLTotal(LId,BOff,0),2);

          InvR.InvNetVal:=InvR.InvNetVal+LineTotal;

          InvR.TotalCost:=InvR.TotalCost+InvLCost(LId);

          DiscLineTotal:=Round_Up(InvLTotal(LId,BOn,0),2);

          WithDiscVal:=WithDiscVal+DiscLineTotal;


          If (DocLTLink>0) then
            InvR.DocLSplit[DocLTLink]:=InvR.DocLSplit[DocLTLink]+LineTotal;

          InvR.TotalWeight:=InvR.TotalWeight+(Calc_IdQty(Qty,QtyMul,UsePack)*LWeight);

          If (ReCalcVAT) then
            InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]:=InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]+Vat;

          {$IFDEF SOP}

            If (InvR.InvDocHed In PSOPSet) then {* Calculate how much of the order remains O/S *}
              InvR.TotOrdOS:=InvR.TotOrdOS+InvLOOS(LId,BOn,0);

          {$ENDIF}

          {* v1.35 Invoice discount total was being worked out by line removed *}


          If (DiscLNet) then
            LineTotal:=Round_Up(InvLTotal(LId,BOn,(InvR.DiscSetl*Ord(InvR.DiscTaken))),2);

          With ExLocal^ do
          Begin
            LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]:=LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]+LineTotal;

            LInvNetTrig[GetVAtNo(VATcode,VATIncFlg)]:=BOn; {* Show Rate is being used, Value independant *}
          end;


        end; {With..}


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

      InvR.DiscAmount:=Round_Up(InvR.InvNetVal-WithDiscVal,2);   {* v1.35 *}

      InvR.InvVat:=CalcTotalVAT(InvR);

      InvR.DiscSetAm:=Round_Up(Calc_PAmount((InvR.InvNetVal-InvR.DiscAmount),InvR.DiscSetl,PcntChr),2);

      // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Calculate Prompt Payment Discount Goods and VAT Values
      UpdatePPDTotals (InvR);

      InvR.ILineCount:=LargeLine+2+Ord((InvR.InvDocHed In DirectSet) and (InvR.TotalInvoiced<>0.0)); {*EL Duplicate line error on directs b601.003*}

      If (InvR.InvDocHed In OrderSet) and (NextDelD<>MaxUntilDate) then
        InvR.DueDate:=NextDelD;

      LInvNetTrig:=ShowManualRates(InvR,ReCalcVAT,LInvNetTrig);


    end; {With..}
  end; {Proc..}





  { ================= Calculate Invoice Totals ================ }

  function LDef_InvCalc(ExLocal : TdMTExLocalPtr;
                        Const oServices : TRCServicesHelper = NIL;
                        IncludeNotionalVAT: Boolean = False;
                        BuildingReturn: Boolean = False): Boolean;
  Const
    Fnum    = IDetailF;
    Keypath = IDFolioK;
  Var
    KeyS          : Str255;
    KeyChk        : Str255;
    LineTotal     : Double;
    DiscLineTotal : Double;
    WithDiscVal   : Double;
    ExStatus      : Integer;
    LargeLine     : LongInt;
    NextDelD      : LongDate;
    VATRateLine   : Double;
    LineVAT       : Double;
    OriginalVATNo : VATType;
    Value : Double;
    GoodsRate  :  CurrTypes;

    // CJS 2014-03-12 - ABSEXCH-15152 - Reverse Charge on Irish VAT
    //                  returns - added new IrishLineTotal local variable
    //                  instead of re-using LineTotal
    IrishLineTotal: Double;

    // CJS - 2014-10-27 - ABSEXCH-15708 - Include both Goods and Services in
    // notional VAT for Ireland
    OriginalVATCode: Char;
    NotionalVATCode: Char;

    // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
    ExcludedNoTC: Boolean;
    HasIncludedLines: Boolean;
    LineTotalInBaseCurrency: Double;

    // CJS 2014-09-09 - ABSEXCH-15516 - include EC Services in notional VAT
    // Internal procedure to find the correct VAT Code to use on EC Services
    // lines for Ireland.
    function VATCodeForIreland: Char;
    var
      Key: Str255;
      FuncRes: LongInt;
    begin
      Result := ExLocal.LId.VATCode;
      // Description-only lines default to Standard VAT
      if (Trim(ExLocal.LId.StockCode) = '') then
        Result := 'S'
      else
      begin
        with TBtrieveSavePosition.Create do
        begin
          try
            // Save the current position in the file for the current key
            SaveFilePosition (StockF, GetPosKey);
            SaveDataBlock (@Stock, SizeOf(Stock));

            // Locate the global Stock record
            Key := FullStockCode(ExLocal.LId.StockCode);
            FuncRes := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);

            // If we found it, copy the VAT Code, otherwise leave the code unchanged
            if (FuncRes = 0) then
              Result := Stock.VATCode;

            // Restore position in file
            RestoreSavedPosition;
            RestoreDataBlock (@Stock);
          finally
            Free;
          end; // try...finally
        end; // with TBtrieveSavePosition.Create...
      end; // if (Trim(ExLocal.LId.StockCode) = '')...
    end;

  Begin
    Result := True;
    With ExLocal^ do
    Begin
      LineTotal     := 0;
      DiscLineTotal := 0;
      WithDiscVal   := 0;

      With LInv do
      Begin
        // Clear the transaction totals
        Blank(LInvNetAnal, Sizeof(LInvNetAnal));
        Blank(LInvNetAnalLessServices, Sizeof(LInvNetAnalLessServices));
        Blank(LFreeOfChargeAnalysis, SizeOf(LFreeOfChargeAnalysis));
        Blank(LInvNetTrig, Sizeof(LInvNetTrig));
        Blank(InvECServiceTotals, SizeOf(InvECServiceTotals));

        // CJS - 2014-10-27 - ABSEXCH-15708 - Include both Goods and Services in notional VAT for Ireland
        Blank(LInvVATAnal, SizeOf(LInvVATAnal));

        KeyChk := FullNomKey(FolioNum);

        LManVATOR := ManVAT;

        If (InvDocHed = NMT) then
          KeyS := FullIdKey(FolioNum, RecieptCode)
        else
          KeyS := FullIdKey(FolioNum, 1);

      end;

      HasIncludedLines := False;

      // Work through all the lines against the transaction
      LStatus := LFind_Rec(B_GetGEq, Fnum, KeyPath, KeyS);
      While (LStatus = 0) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) and
            ((LId.LineNo <> RecieptCode) or (LId.IdDocHed = NMT)) do
      Begin
        // Keep a record of the original VAT Code on this line
        OriginalVATCode := LId.VATCode;

        // CJS - 2014-10-27 - ABSEXCH-15708 - Include both Goods and Services
        // in notional VAT (Postponed Accounting) for Ireland
        if (CurrentCountry = IECCode) then
        begin
          // We need to calculate 'A' and 'D' VAT codes at the rate on the
          // actual Stock item, although we will store the results against 'A'
          // or 'D' (the OriginalVATCode)
          NotionalVATCode := VATCodeForIreland;
          // For EC Services the modified VAT Code must be used for all the
          // calculations (for non services we only need to use it for the
          // notional VAT calculations -- see below)
          if LId.ECService then
            ExLocal.LId.VATCode := NotionalVATCode;
        end
        else
          NotionalVATCode := ExLocal.LId.VATCode;

        With LId do
        Begin
          LineTotal := Round_Up(InvLTotal(LId, BOn, (LInv.DiscSetl * Ord(LInv.DiscTaken))), 2);

          // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
          // For posting via Scheduler this code should never be used (it is
          // only relevant to the generation of the VAT Return).
          {$IF NOT (Defined(SENT) OR Defined(SCHEDULER))}
          ExcludedNoTC := (CurrentCountry = UKCCode) and
                          Syss.Intrastat and
                          ExLocal.ForVATReturn and
                          (VATCode in [VATEECCode, VATECDCode]) and
                          IsExcludedNoTC(LInv, LId);

          if ExcludedNoTC then
          begin
            // Only accumulate the excluded values on the 'build' pass,
            // otherwise they will be doubled-up
            if BuildingReturn then
            begin
              LineTotalInBaseCurrency := Round_Up(Conv_TCurr(LineTotal, CXRate[UseCoDayRate], Currency, UseORate, BOff), 2);
              if VATCode = VATECDCode then
                ExcludedNoTCValues[vatOutput] := ExcludedNoTCValues[vatOutput] + LineTotalInBaseCurrency
              else
                ExcludedNoTCValues[vatInput] := ExcludedNoTCValues[vatInput] + LineTotalInBaseCurrency;
            end;
            // Clear the line total on both passes
            LineTotal := 0;
          end
          else
            // There is at least one line which has not been excluded
            HasIncludedLines := True;
          {$ELSE}
          ExcludedNoTC := False;
          HasIncludedLines := True;
          {$IFEND}

          // For Nominal transactions all totals must be in consolidated
          If (IdDocHed = NMT) then
            LineTotal := Round_Up(Conv_TCurr(LineTotal, CXRate[UseCoDayRate], Currency, UseORate, BOff), 2);

          // Determine the correct VAT code entry
          OriginalVATNo := GetVATNo(OriginalVATCode, VATIncFlg);

          // Accumulate the net value from the line
          LInvNetAnal[OriginalVATNo] := LInvNetAnal[OriginalVATNo] + LineTotal;

          if IncludeNotionalVAT then
          begin
            // CJS - 2014-10-27 - ABSEXCH-15708 - Include both Goods and
            // Services in notional VAT for Ireland Notional VAT (Postponed
            // Accounting) calculation:

            // Calculate the VAT amount using the rate from the modified VAT code
            VATRateLine := TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(NotionalVatCode, VATIncFlg)].Rate, 10);
            LineVAT     := LineTotal * VATRateLine;
            LineVAT     := Round_Up(Conv_VATCurr(LineVAT, LInv.VATCRate[BOn], Calc_BConvCXRate(LInv, CXRate[BOn], BOn), Currency, UseORate) * DocCnst[LInv.InvDocHed] * DocNotCnst, 2);

            // Store the result against the original VAT Code
            LInvVATAnal[OriginalVATNo] := LInvVATAnal[OriginalVATNo] + LineVAT;

            if not LId.ECService then
            begin
              if (LineTotal = 0.0) and (CurrentCountry = UKCCode) and not ExcludedNoTC then
              begin
                // CJS 2015-05-28 - ABSEXCH-16260 - VAT100 report Box 8
                // Free of charge items should use Qty * Cost instead
                LInvNetAnalLessServices[OriginalVATNo] := LInvNetAnalLessServices[OriginalVATNo] + (LId.CostPrice * LId.Qty);
                if (LInv.InvDocHed in SalesSplit) then
                begin
                  Value := Round_Up(Conv_TCurr((LId.CostPrice * LId.Qty) * DocCnst[LInv.InvDocHed] * DocNotCnst, CXRate[UseCoDayRate], Currency, UseORate, BOff), 2);
                  LFreeOfChargeAnalysis[OriginalVATNo] := LFreeOfChargeAnalysis[OriginalVATNo] + Value;
                end;
              end
              else
                LInvNetAnalLessServices[OriginalVATNo] := LInvNetAnalLessServices[OriginalVATNo] + LineTotal;
            end;
          end
          else if not ((LInv.InvDocHed In SalesSplit) And LId.ECService) Then
            LInvNetAnalLessServices[OriginalVATNo] := LInvNetAnalLessServices[OriginalVATNo] + LineTotal;

          // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services
          // We need to maintain separate totals of the EC Service Net and VAT
          // values for Sales and Purchases
          if (LId.ECService) and (CurrentCountry = IECCode) then
          begin
            // EC Service values must be in consolidated
            // CJS 2014-03-12 - ABSEXCH-15152 - Reverse Charge on Irish VAT
            //                  returns - added new IrishLineTotal local variable
            //                  instead of re-using LineTotal
            IrishLineTotal := Round_Up(Conv_TCurr(LineTotal * DocCnst[LInv.InvDocHed] * DocNotCnst, CXRate[UseCoDayRate], Currency, UseORate, BOff), 2);

            // Accumulate the EC Service values for the transaction
            if (LInv.InvDocHed in SalesSplit) then
            begin
              // Sales
              InvECServiceTotals[ectSales][ecvNet] := InvECServiceTotals[ectSales][ecvNet] + IrishLineTotal;
            end
            else
            begin
              // Purchases
              InvECServiceTotals[ectPurchases][ecvNet] := InvECServiceTotals[ectPurchases][ecvNet] + IrishLineTotal;
              // VAT required on EC Service purchases (only, not on Sales)
              VATRateLine := TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(VatCode, VATIncFlg)].Rate, 10);
              LineVAT := Round_Up(IrishLineTotal * VATRateLine, 2);
              InvECServiceTotals[ectPurchases][ecvVAT] := InvECServiceTotals[ectPurchases][ecvVAT] + LineVAT;
            end;
          end;

          If (IdDocHed <> NMT) or (NOMIOFlg <> 0) then
            // Flag the fact that this VAT code has been used, so that it is
            // included on the report
            LInvNetTrig[GetVAtNo(OriginalVATcode, VATIncFlg)] := BOn;

          If (IdDocHed = NMT) then {We override NMT man flag from any line set like that}
            LManVATOR := (LManVATOR or (NOMIOFlg = 2));

          If Assigned(oServices) And DoReverseCharge(LInv, LId) Then
          Begin
            // Store any reverse charge values
            oServices.ProcessServiceLine(LId, LineTotal);
          End; // If Assigned(oServices) And DoReverseCharge (LInv, LId)
        end; // With LId do...

        LStatus := LFind_Rec(B_GetNext, Fnum, KeyPath, KeyS);

      end; // While (LStatus = 0)...

      LInvNetTrig := ShowManualRates(LInv, Not LInv.ManVAT, LInvNetTrig);

    end; // With ExLocal^ do...
    Result := HasIncludedLines;
  end; {Proc..}

  { =========== Re-Convert Manual Type Lines to new Discount Types ========== }

  Procedure Re_CalcManualVAT(Var InvR    :  InvRec;
                             Var ExLocal :  TdExLocal;
                                 NewSetl :  Double);


  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var
    IdLineDecs   :    Byte;

    KeyS,
    KeyChk    :  Str255;

    LineDiscount,
    OrigVal   :  Double;

    Locked    :  Boolean;

    ExStatus  :  Integer;

    LAddr     :  LongInt;


  Begin

    ExStatus:=0;

    With InvR do
    Begin

      KeyChk:=FullNomKey(FolioNum);

      KeyS:=FullIdKey(FolioNum,1);


      ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Id.LineNo<>Recieptcode) do
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        With Id do
        Begin
          If (IdDocHed In PurchSplit) then
            IdLineDecs:=Syss.NoCosDec
          else
            IdLineDecs:=Syss.NoNetDec;

          If (VATCode='M') then
          Begin
            If (IncNetValue=0.0) then
            Begin
              // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
              //LineDiscount:=Calc_PcntPcnt(NetValue,Discount,DiscSetl,DiscountChr,PcntChr);
              LineDiscount := Calc_PcntPcntAD (NetValue,
                                               Discount, DiscountChr,
                                               Discount2, Discount2Chr,
                                               Discount3, Discount3Chr,
                                               DiscSetl, PcntChr);

              If (Qty<>1.0) then
                NetValue:=((NetValue-LineDiscount)*(SyssVAT.VATRates.VAT[GetIVATNo(VatIncFlg)].Rate+1))+LineDiscount
              else
                NetValue:=(Round_Up(NetValue,IdLineDecs)+VAT);
            end
            else
              NetValue:=IncNetValue;
              
            {NetValue:=NetValue*(SyssVAT.VATRates.VAT[GetIVATNo(VatIncFlg)].Rate+1);}


            VATCode:='I';

            CalcVAT(Id,NewSetl); {We need to calculate this twice to get the original dicsount stored in LineDisc}

          end;

        end; {With..}

        CalcVAT(Id,NewSetl);

        {* Store new VAT Rate *}

        ExStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_Berror(Fnum,ExStatus);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      end; {While..}


      CalcInvTotals(InvR,ExLocal,(Not ManVAT),BOn);

    end; {With..}

  end; {Proc..}







  { ================ Procedure to Calculate the InvNetAnal Split ================ }

  Procedure Def_InvCalc;

  Var
    ExLocal  :  TdExLocal;

    TmpStat,
    TmpKPath,
    Fnum     :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpId    :  IDetail;


  Begin
    Fnum:=IdetailF;

    TmpId:=Id;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    ExLocal.Create;

    CalcInvTotals(Inv,ExLocal,BOff,BOn);

    InvNetAnal:=ExLocal.LInvNetAnal;

    ExLocal.Destroy;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    Id:=TmpId;
  end;



{ ====== Proc to return correct Discount control account based on Doc type ====== }

Function SDiscNom(DT  :  DocTypes)  :  NomCtrlType;

Begin
  If (DT In SalesSplit) then
    Result:=DiscountGiven
  else
    Result:=DiscountTaken;
end;

{ ============ Procedure to update the Invoice balances ============= }


Procedure UpdateRecBal(Var   TInv     :  InvRec;
                       Const NomCode  :  Longint;
                       Const Amount,
                             VAmount  :  Double;
                       Const CRates   :  CurrTypes;
                       Const UpCr     :  Byte;
                             UOR      :  Byte;
                       Const Mode     :  Byte);

Var
  BaseEQuiv  :  Double;

Begin

  BaseEquiv:=0;

  If (Amount+VAmount<>0) then
    With TInv do
    With Syss do
    Case Mode of
      1..3,6
            :  If (NomCode=NomCtrlCodes[CurrVar]) then
               Begin
                 If (Not (InvDocHed In DirectSet)) then
                 Begin
                   Variance:=Variance+Amount;

                   If (Mode<>6) then
                     UpdateAllBal(Amount*DocCnst[InvDocHed]*DocNotCnst,0,0,BOff,InvDocHed);

                 end
                 else {If Direct treat variance entries as coming directly off amount required }
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CRates,UOR,UpCr,0);

                   BaseEquiv:=Conv_TCurr(Amount,XRate(CRates,BOff,UpCr),UpCr,UOR,BOff);

                   TotalInvoiced:=TotalInvoiced+Round_Up(BaseEQuiv,2);

                   TotalOrdered:=TotalOrdered+BaseEQuiv;
                 end;

               end
               else
                 If (NomCode=NomCtrlCodes[SDiscNom(InvDocHed)]) then
                 Begin
                   If (Not (InvDocHed In DirectSet)) then
                   Begin
                     PostDiscAm:=PostDiscAm+Amount;

                   end
                   else {If Direct treat variance entries as coming directly off amount required }
                   Begin
                     UOR:=fxUseORate(BOff,BOn,CRates,UOR,Currency,0);

                     BaseEquiv:=Conv_TCurr(Amount,XRate(CRates,BOff,Currency),Currency,UOR,BOff);

                     TotalInvoiced:=TotalInvoiced+Round_Up(BaseEQuiv,2);

                     TotalOrdered:=TotalOrdered+BaseEQuiv;
                   end;
                 end
                 else
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                   If (NomCode=NomCtrlCodes[UnRCurrVar]) then
                     BaseEQuiv:=Amount
                   else
                     BaseEQuiv:=Conv_TCurr(Amount,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                   TotalInvoiced:=TotalInvoiced+Round_Up(BaseEquiv,2);

                   TotalOrdered:=TotalOrdered+BaseEQuiv;
                 end;

      4     :  Begin
                 InvNetVal:=Round_up(InvNetVal,2)+Round_Up(Conv_TCurr(Amount,CRates[UseCoDayRate],UpCr,UOR,BOff),2);

                 InvVAT:=Round_up(InvVAT,2)+Round_Up(Conv_TCurr(VAmount,CRates[UseCoDayRate],UpCr,UOR,BOff),2);
               end;

    end; {Case..}

end;

//PR: 23/11/2017 ABSEXCH-19451 Returns True if we can only edit GDPR fields
function RestrictedEditOnly(InvR : InvRec) : Boolean;
var
  DocStatus : Byte;
begin
  View_Status(InvR, False, DocStatus);
  //Check for posted, allocated, revalued, and cash a/c
  Result := DocStatus in [1, 2, 5, 6];

  //PR: 06/02/2018 Check also for OrderPayment SRC/PPY,etc.
  if not Result then
    Result := Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet
end;




Initialization

  ProtectDate:=0;

end.
