UNIT Dllth01B;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export Modeule                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  Classes,
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3,
  Dialogs;



FUNCTION EX_GETTRANS(P              :  POINTER;
                     PLINES         :  POINTER;
                     PSIZE          :  LONGINT;
                     PLSIZE         :  LONGINT;
                     SEARCHKEY      :  PCHAR;
                     SEARCHPATH     :  SMALLINT;
                     SEARCHMODE     :  SMALLINT;
                     LOCK           :  WORDBOOL) : SMALLINT;
                     {$IFDEF WIN32} STDCALL {$ENDIF}
                     EXPORT;

FUNCTION EX_GETTRANSHED(P              :  POINTER;
                        PSIZE          :  LONGINT;
                        SEARCHKEY      :  PCHAR;
                        SEARCHPATH     :  SMALLINT;
                        SEARCHMODE     :  SMALLINT;
                        LOCK           :  WORDBOOL) : SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF}
                        EXPORT;

FUNCTION EX_GETTRANSLINE(PLINE          :  POINTER;
                         PLSIZE         :  LONGINT;
                         SEARCHKEY      :  PCHAR;
                         SEARCHPATH     :  SMALLINT;
                         SEARCHMODE     :  SMALLINT;
                         LOCK           :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXPORT;

FUNCTION EX_STORETRANS(P,
                       PL         :  POINTER;
                       PSIZE,
                       PLSIZE     :  LONGINT;
                       SEARCHPATH :  SMALLINT;
                       SEARCHMODE :  SMALLINT) : SMALLINT;
                       {$IFDEF WIN32} STDCALL {$ENDIF}
                       EXPORT;

FUNCTION EX_GETNEXTTRANSNO(DOCSTR :  PCHAR;
                           NEXTNO :  PCHAR;
                           UPDATE :  WORDBOOL) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}
                           EXPORT;

FUNCTION EX_GETTOTALTRANSLINES(DOCREF : PCHAR) : LONGINT;
                               {$IFDEF WIN32} STDCALL; {$ENDIF}
                               EXPORT;

FUNCTION EX_TESTSTK(SEARCHKEY      :  PCHAR;
                    SEARCHPATH     :  SMALLINT;
                    SEARCHMODE     :  SMALLINT;
                    LOCK           :  WORDBOOL) : SMALLINT;
                    {$IFDEF WIN32} STDCALL {$ENDIF}
                    EXPORT;

FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                    DECIMALPLACES  :  SMALLINT)  :  DOUBLE;
                    {$IFDEF WIN32} STDCALL {$ENDIF}
                    EXPORT;

FUNCTION EX_GETTLLINE(FOLIONUMBER,
                      LINENUMBER  :  LONGINT;
                      PLINE       :  POINTER;
                      PLSIZE      :  LONGINT)  :  SMALLINT;
                      {$IFDEF WIN32} STDCALL {$ENDIF}
                      EXPORT;

FUNCTION EX_GETTHBYFOLIO(FOLIONUMBER :  LONGINT;
                         P           :  POINTER;
                         PSIZE       :  LONGINT)  :  SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXPORT;

FUNCTION EX_GETTHBYRUNNO(P          :  POINTER;
                         PSIZE      :  LONGINT;
                         RUNNO      :  LONGINT;
                         SEARCHMODE :  SMALLINT;
                         LOCK       :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXPORT;

FUNCTION STORETH(P          :  POINTER;
                 PSIZE      :  SMALLINT;             {* Size of TH *}
                 SEARCHPATH :  SMALLINT;
                 UPDATEMODE :  SMALLINT;
                 AUTHCODE   :  LONGINT)  :  SMALLINT;
                 {$IFDEF WIN32} STDCALL {$ENDIF}
                 EXPORT;

FUNCTION EX_GETLINETOTAL(P      : POINTER;
                         PSize  : SMALLINT;
                         UseDiscount : WORDBOOL;
                         SettleDisc : double;
                         var LineTotal : double): smallint;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXPORT;

{$IFDEF WIN32}

  Function Ex_GetRecAddress(FileNum  :  SmallInt)  :  LongInt;  {FOR INTERNAL ONLY }

  Function Ex_GetRecWithAddress(FileNum,
                                KeyPath  :  SmallInt;
                                TRecAddr :  LongInt )  :  SmallInt;  STDCALL;  EXPORT;

  Function Ex_GetRecordAddress(    FileNum     :  SmallInt;
                               Var RecAddress  :  LongInt)  :  SmallInt;  STDCALL;  EXPORT;

{$ENDIF}


Type
  {$IFNDEF WIN32}
    SHORTSTRING = STRING;
  {$ENDIF}

  STR4        = STRING[4];


FUNCTION EX_CONVERTFOLIO(FOLIONUMBER  :  LONGINT)  :  SHORTSTRING;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXPORT;

FUNCTION EX_CONVERTAMOUNT(FROMCURR   :  SMALLINT;
                          TOCURR     :  SMALLINT;
                      VAR AMOUNT     :  DOUBLE;
                          RATETYPE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXPORT;

FUNCTION EX_STORETRANSHED(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXPORT;

Function GetActualLineCount(InvFolioNum  :  LongInt)  :  LongInt;

Procedure EX_SETCALCLINECOUNT(WantCount : WordBool);
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXPORT;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SysUtils,
  WinProcs,
  ETStrU,
  ETDateU,
  ETMiscU,
  MiscU,
{$IFDEF WIN32}
  BtrvU2,
  BTSupU1,
  SysU2,
  SysU3,  {* added in v4.31 *}
  ComnU2,
  ComnUnit,
  CurrncyU,
  BtKeys1U,
{$ELSE}
  BtrvU16,
  BtSup1,
  BtSup2,
{$ENDIF}
  FIFOLU,
  BTS1;


Var
  WantCalcLineCount : Boolean;

{ ------------ Functions for Job Actual Record (19.02.97) ---------------- }


{ ============== Function to Return Line Cnst Based on Payment Type =========== }

Function LineCnst(P  :  Char)  :  Integer;
Begin
  If (P=DocPayType[SIN]) then
    LineCnst:=-1
  else
    LineCnst:=1;
end;

{ =========== Function to Return Qty, or Qty Mul ======== }

Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;
Begin
  If (UP) then
    Calc_IdQty:=Q*QM
  else
    Calc_IdQty:=Q;

end; {Func..}


{ ==================== Calculate One Line of Invoice ================= }

(*

Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean)  :  Real;
Var
  Rnum,
  WithDisc   :  Real;
  Cnst       :  Integer;
  UseDecs    :  Byte;

Begin
  With Idr do
  Begin
    Cnst:=LineCnst(Payment);
    RNum:=0; WithDisc:=0;

    If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    Rnum:=Calc_PAmount(Round_Up(NetValue,UseDecs),Discount,DiscountChr);

    WithDisc:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*(Round_Up(NetValue,UseDecs)-Rnum),2);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,(Inv.DiscSetl*Ord(UseSetl)),PcntChr),2);

    If (UseDisc) then
      DetLTotal:=(WithDisc*Cnst)
    else
      DetLTotal:=Round_Up((Calc_IdQty(Qty,QtyMul,UsePack)*Round_Up(NetValue,UseDecs)*Cnst),2);
  end;{With..}
end;
*)

Function DetLTotalND(IDr        :  IDetail;
                     UseDisc,
                     UseSetl,
                     ShowDec    :  Boolean)  :  Double;

Var
  Rnum,
  WithDisc
        :  Double;

  Cnst  :  Integer;

  LineQty,
  PriceEach
        :  Double;

  FinDecs,
  UseDecs,
  UseQDecs
        :  Byte;


Begin
  With Idr do
  Begin
    Cnst:=LineCnst(Payment);

    RNum:=0; WithDisc:=0;

    UseQDecs:=Syss.NoQtyDec;

    If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    If (ShowDec) then
      FinDecs:=UseDecs
    else
      FinDecs:=2;

    LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);

    If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
    Begin
      If (ShowCase) then
      Begin
        PriceEach:=NetValue;
        LineQty:=DivWChk(Qty,QtyPack);

        UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
      end
      else
        PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);

    end
    else
      PriceEach:=NetValue;


    Rnum:=Calc_PAmount(Round_Up(PriceEach,UseDecs),Discount,DiscountChr);

    WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),FinDecs);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,(Inv.DiscSetl*Ord(UseSetl)),PcntChr),FinDecs);

    If (UseDisc) then
      DetLTotalND:=(WithDisc*Cnst)
    else
      DetLTotalND:=Round_Up((Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs)*Cnst),FinDecs);
  end;{With..}
end;


Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean)  :  Double;


Begin
  DetLTotal:=DetLTotalND(IdR,UseDisc,UseSetl,BOff);
end;


 { =========== Function to Return Qty OS on Document =========== }

Function Qty_OS(IdR  :  IDetail)  :  Real;

Begin
  With IdR do Begin
    Qty_OS:=Round_Up((Qty-(QtyDel+QtyWOff)),Syss.NoQtyDec);
  end;
end; {Func..}

  { ====== Function to Return Full JobCode ====== }

Function FullJobCode(JCode  :  Str20)  :  Str20;

Begin
  FullJobCode:=LJVar(JCode,JobCodeLen); {Changed JobCodeLen as ExLenJob}
end;


Function FullJDLedgerKey(JC   :   Str10;
                         P,I  :   Boolean;
                         Cu   :   Byte;
                         JD   :   Str8)  :  Str30;
Begin
  FullJDLedgerKey:=FullJobCode(JC)+Chr(Ord(P))+Chr(Cu)+Chr(Ord(I))+JD;
end;


Function FullJDRunKey(JC      :   Str10;
                      RN      :   Longint;
                      JD      :   Str8)  :  Str30;
Begin
  FullJDRunKey:=FullNomKey(RN)+FullJobCode(JC)+JD;
end;


Function FullJDLookKey(RN,FN   :   Longint)  :  Str20;

Begin
  FullJDLookKey:=FullNomKey(RN)+FullNomKey(FN)+HelpKStop;
end;


Function FullJDEmplKey(JC,EC   :   Str10;
                       Matched :   Boolean)  :  Str30;
Begin
  FullJDEmplKey:=FullJobCode(EC)+Chr(Ord(Matched))+FullJobCode(JC);
end;


{ ====== Func to Get on cost markup information ====== }

Function Get_BudgMUp(JCode,
                       ACode    :  Str10;
                       SCode    :  Str20;
                       Curr     :  Byte;
                   Var Charge   :  Double;
                       Mode     :  Byte)  :  Boolean;
Const
    Fnum     =  JCtrlF;
    Keypath  =  JCK;

Var
    KeyS,
    KeyChk   :  Str255;

    FoundOk,
    AllowChrge,
    Loop     :  Boolean;

    HistPFix :  Char;

    NomBal,
    Purch,
    Sales,
    Cleared,
    Bud1,
    Bud2,
    Rnum     :  Real;

    Dnum,
    Dnum2    :  Double;

Begin

    If (Mode=1) then Charge:=0;
    AllowChrge:=BOn;    Loop:=BOff;

    KeyChk:=JBRCode+JBSCode+FullJBCode(JCode,0,SCode);

    Repeat

      KeyS:=KeyChk;
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      FoundOk:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk)-1,BOn)));

      If (FoundOk) then
      Begin
        Case Mode of
          1  :  Begin
                  AllowChrge:=JobCtrl^.JobBudg.ReCharge;
                  With JobCtrl^.JobBudg do
                    If ((FoundOk) and (AllowChrge)) then Charge:=OverCost;
                end;

          {Mode is passed as 1}
          {2,3
             :  With JobCtrl^.JobBudg do
                Begin
                  If (Mode=3) then
                    HistPFix:=CommitHCode
                  else
                    HistPFix:=JobRec^.JobType;
                  NomBal:=Profit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                         Syss.CYr,Syss.CPr,Purch,Sales,Cleared,On);
                 AllowChrge:=(((NomBal+Charge)<BrValue) or (BrValue=0) or (Not Syss.WarnJC));
                end;}
        end; {Case..}
      end; {If match found..}

      KeyChk:=JBRCode+JBBCode+FullJBCode(JCode,0,ACode);
      Loop:=Not Loop;

    Until (Not Loop) or ((FoundOk) and (AllowChrge)) or ((FoundOk) and (Mode<>1));

    Get_BudgMUp:=AllowChrge;

end; {Func..}

{* --------------- Up to here (12.11.96) ------------- *}

function Extract_PayRef2(PayRef : Str20) : Str10;
{ Function to extract the PayRef from a completed Key }
var
  SepCh     :  Char;
  NomCode   :  LongInt;
  Currency  :  Byte;
  RefNo     :  Str10;
  Count     :  Byte;
begin
  Count:=1;

  if (Length(PayRef)=Length(Full_PostPayInKey(#0,0,0,''))) then
  begin
    SepCh:=PayRef[Count];
    Count:=Count+Sizeof(SepCh);
    Move(PayRef[Count],NomCode,Sizeof(NomCode));
    Count:=Count+Sizeof(NomCode);
    Currency:=Ord(Payref[Count]);
    Count:=Count+Sizeof(Currency);
    RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));
  end
  else
    RefNo:='';

  Result := RefNo;
end; { Extract_PayRef2 }

function Extract_PayRef1(PayRef  :  Str20)  :  Str10;
{ Function to Extract the PayRef from a completed Key }
var
  SepCh     :  Char;
  RefNo     :  Str10;
  Count     :  Byte;
begin
  Count:=1;

  if (Length(PayRef)=Length(Pre_PostPayInKey(#0,''))) then
  begin
    SepCh:=PayRef[Count];
    Count:=Count+Sizeof(SepCh);
    RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));
  end
  else
    RefNo:='';

  Result := RefNo;
end; { Extract_PayRef1 }

Procedure IdToExId(Var ExIdRec  :  TBatchTLRec);

Var
  n  :  Byte;

Begin
  With ExIdRec do
  Begin
    TransRefNo:=Inv.OurRef;
    FolioNum:=Id.FolioRef;    {* Added on 27.11.97 *}
    LineNo:=Id.LineNo;
    NomCode:=Id.NomCode;
    Currency:=Id.Currency;

    {* From Ent. record to External record, hence SetTriRec will not be used *}
    If (ExSyss.MCMode) then
      CoRate:=XRate(Id.CXRate,UseCoDayRate,Id.Currency)
    else
      CoRate:=Id.CXRate[BOff];
    VATRate:=Id.CXRate[BOn];


    CC:=Id.CCDep[BOn];
    Dep:=Id.CCDep[BOff];

    PayMent:=(Id.LineNo=RecieptCode);

    { 14.07.99 - Above Payment line has been moved to check the following condition
     and changed the Payment as advised by EL }

    { JRF 09/06/1999 Commented out code below didn't work with posted transactions }
    {if Id.Payment = 'Y' then { SRC / SRI and others ? }
    If (Payment) then
      if Id.PostedRun > 0 then
        StockCode := Extract_PayRef2(Id.StockCode)
      else
        StockCode := Extract_PayRef1(Id.StockCode)
    else
      StockCode:=Id.Stockcode;

    {* 22.09.99 - not returning Stock code for ADJ record *}
    If (Payment) and (Id.IdDocHed In StkAdjSplit) then
      StockCode:=Id.StockCode;

  (*  If (Id.StockCode[1]=PayInCode) then
      StockCode:=Strip('L',[#1, #2],Id.StockCode)
    else
      StockCode:=Id.StockCode; *)

    Qty:=Id.Qty;
    QtyMul:=Id.QtyMul;
    NetValue:=Id.NetValue;
    Discount:=Id.Discount;
    VATCode:=Id.VATCode;
    VAT:=Id.VAT;

    DiscountChr:=Id.DiscountChr;
    QtyWOff:=Id.QtyWOff;
    QtyDel:=Id.QtyDel;
    CostPrice:=Id.CostPrice;
    CustCode:=Id.CustCode;
    LineDate:=Id.PDate;
    Item:=Id.Item;
    Desc:=Id.Desc;
    LWeight:=Id.LWeight;
    MLocStk:=Id.MLocStk;
    JobCode:=Id.JobCode;
    AnalCode:=Id.AnalCode;
    If (Id.IdDocHed In TSTSplit) then
      TSHCCurr:=Id.Reconcile
    else
      {* Added on 27.01.97 *}
      Reconcile:=Id.Reconcile;


    {* Added on 19.11.97 *}
    DocLTLink:=Id.DocLTLink;
    KitLink:=Id.KitLink;

    {* Added on 3.12.97 *}
    LineType:=Id.LineType;

    SOPLink:=Id.SOPLink;
    SOPLineNo:=Id.SOPLineNo;

    ABSLineNo:=Id.ABSLineNo;

    {*** Ver 4.31 ***}
    LineUser1:=Id.LineUser1;
    LineUser2:=Id.LineUser2;
    LineUser3:=Id.LineUser3;
    LineUser4:=Id.LineUser4;

    SSDUplift:=Id.SSDUplift;
    SSDCommod:=Id.SSDCommod;
    SSDSPUnit:=Id.SSDSPUnit;
    SSDUseLine:=Id.SSDUseLine;
    PriceMulx:=Id.PriceMulx;
    VATIncFlg:=Id.VATIncFlg;
    QtyPick:=Id.QtyPick;

    {*** -------------- ***}

  end;
end; {Proc..}

{ =======  Routine to collect all invoice lines ===== }

Procedure Get_TransLines(FolioN  :  Longint;
                         Fnum,
                         Keypath :  Integer;
                     Var P       :  Pointer;  {* Pointer of TLs *}
                     Var ILC     :  LongInt;  {* ILC = Exinv^.LineCount *}
                     Var PSize   :  LongInt); {* Total Size of TLs *}
                     {* Add PSize para. *}
Var
  KeyS,
  KeyChk  :  Str255;
  {ExIdRec :  ^TBatchLinesRec;}
  {* Add for Changes *}
  TmpExIdRec          :  TBatchTLRec;

  MaxIdLines,
  RecSeg,RecOfs,
  RecPos              :  LongInt;

Begin

  If (P<>Nil) then
  Begin
    KeyS:=FullNomKey(FolioN);
    {ExIdRec:=P;
    FillChar(ExIdRec^,Sizeof(ExIdRec^),0);}

    MaxIdLines:=ILC;            {* ILC = ExInv^.LineCount *}
    FillChar(P^,PSize,#0);      {* P=TLsPointer PSize=TotalPassingTLsSize *}
    KeyChk:=KeyS;
    ILC:=0;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    {While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ILC<=MaxInvLines) do}
    {* Change MaxInvLines as MaxIdLine *}
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ILC<=MaxIdLines) do
    Begin
      Inc(ILC);
      {IdToExId(ExIdRec^[ILC]);}

      IdToExId(TmpExIdRec);      {* convert into Tmp. Record *}

      {$IFDEF WIN32}
        RecPos:=LongInt(P)+( Pred(ILC)*SizeOf(TmpExIdRec));    {* get Ptr position *}
        Move(TmpExIdRec,Pointer(RecPos)^,SizeOf(TmpExIdRec));  {* move Tmp.Rec into Ptr *}
      {$ELSE}
        RecSeg:=Seg(P^);
        RecOfs:=Ofs(P^);
        RecOfs:=RecOfs + ( Pred(ILC)*SizeOf(TmpExIdRec) );
        Move(TmpExIdRec,Ptr(RecSeg,RecOfs)^,SizeOf(TmpExIdRec) );
      {$ENDIF}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {while..}
  end; {if..}

end; {proc..}


Procedure InvToExInv(Var ExInvRec  :  TBatchTHRec);

Var
  n  :  Byte;

Begin
  With ExInvRec do
  Begin
    RunNo:=Inv.RunNo;
    CustCode:=Inv.CustCode;
    OurRef:=Inv.OurRef;
    FolioNum:=Inv.FolioNum;
    Currency:=Inv.Currency;
    AcYr:=Inv.AcYr;
    AcPr:=Inv.AcPr;
    DueDate:=Inv.DueDate;
    TransDate:=Inv.TransDate;

    {* From Ent. record to External record, hence SetTriRec will not be used *}

    If (ExSyss.MCMode) then
      CoRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency)
    else
      CoRate:=Inv.CXRate[BOff];
    VATRate:=Inv.CXRate[BOn];

    {------------------------}

    YourRef:=Inv.YourRef;
    LongYrRef:=Inv.TransDesc;

    {LineCount:=Inv.ILineCount;}
    {* 21.09.99 - Inv.LineCount is not actual total line count, hence calculate manually *}
    LineCount:=GetActualLineCount(Inv.FolioNum);

    TransDocHed:=DocCodes[Inv.InvDocHed];

    {For n:=0 to 9 do}                    {* changed from 9 to 16 on 10.06.97 *}
    For n:=0 to 23 do {16 to 23 in v4.31 }
      InvVATAnal[n]:=Inv.InvVATAnal[VATType(n)];

    InvNetVal:=Inv.InvNetVal;
    InvVAT:=Inv.InvVAT;

    DiscSetl:=Inv.DiscSetl;
    DiscSetAm:=Inv.DiscSetAm;
    DiscAmount:=Inv.DiscAmount;
    DiscDays:=Inv.DiscDays;
    DiscTaken:=Inv.DiscTaken;

    If (ExSyss.MCMode) then
      Settled:=Inv.CurrSettled
    else
      Settled:=Inv.Settled;

    TransNat:=Inv.TransNat;
    TransMode:=Inv.TransMode;
    HoldFlg:=Inv.HoldFlg;
    TotalWeight:=Inv.TotalWeight;

    For n:=1 to 5 do
      DAddr[n]:=Inv.DAddr[n];

    TotalCost:=Inv.TotalCost;
    PrintedDoc:=Inv.PrintedDoc;
    ManVAT:=Inv.ManVAT;
    DelTerms:=Inv.DelTerms;
    OpName:=Inv.OpName;
    DJobCode:=Inv.DJobCode;
    DJobAnal:=Inv.DJobAnal;
    TotOrdOS:=Inv.TotOrdOs;
    DocUser1:=Inv.DocUser1;
    DocUser2:=Inv.DocUser2;
    If (Inv.InvDocHed In TSTSplit) then
      EmpCode:=Inv.BatchLink;
    Tagged:=Inv.Tagged;
    thNoLabels:=Inv.NoLabels;
    CtrlNom:=Inv.CtrlNom;

    {***  ver 4.31 New Fields ***}

    DocUser3:=Inv.DocUser3;
    DocUser4:=Inv.DocUser4;
    SSDProcess:=Inv.SSDProcess;
    ExtSource:=Inv.ExtSource;
    PostDate:=Inv.PostDate;
    PORPickSOR:=Inv.PORPickSOR;
    BDiscount:=Inv.BDiscount;
    PrePostFlg:=Inv.PrePostFlg;

  end;
end; {proc..}

{* Get Actual Line Count *}
Function GetActualLineCount(InvFolioNum  :  LongInt)  :  LongInt;
Var
  TotCount     :  LongInt;
  KeyChk, KeyS :  Str255;
  KeyNum       : Integer;
  SavedPosOK   : Boolean;
  RecPos       : LongInt;
begin
  { HM 11/10/99: Added cutout facility as performance hit too bad in certain circumstances }
  If WantCalcLineCount Then Begin
    { HM 07/10/99: Save the current position in the transaction line file }
    KeyNum := GetPosKey;
    SavedPosOK := Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, false, false) = 0;

    KeyS:=FullNomKey(InvFolioNum);
    KeyChk:=KeyS;

    TotCount:=0;

    Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    Begin
      Inc(TotCount);
      Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
    end;

    GetActualLineCount:=TotCount;

    { HM 07/10/99: Return to the original position in the transaction header file }
    if SavedPosOK then
      Presrv_BTPos(IDetailF, KeyNum, F[IDetailF], RecPos, true, false);
  End { If WantCalcLineCount }
  Else
    GetActualLineCount:=Inv.ILineCount;
end; {func..}

FUNCTION EX_GETTRANS(P              :  POINTER;
                     PLINES         :  POINTER;
                     PSIZE          :  LONGINT;
                     PLSIZE         :  LONGINT;
                     SEARCHKEY      :  PCHAR;
                     SEARCHPATH     :  SMALLINT;
                     SEARCHMODE     :  SMALLINT;
                     LOCK           :  WORDBOOL)  :  SMALLINT;

Const
  KeyXlate  :  Array[0..10] of Integer =
               (InvOurRefK,InvFolioK,InvCustK,InvYrRefK,InvLYRefK,
                InvRNoK,InvCDueK,InvVATK,InvBatchK,InvDateK,InvYrPrK );

{   InvRNoK    =  0;*
    InvCustK   =  1;   *
    InvOurRefK =  2;   *
    InvFolioK  =  3;   *
    InvCDueK   =  4;*
    InvVATK    =  5;*
    InvYrRefK  =  6;   *
    InvBatchK  =  7;*
    InvLYRefK  =  8;   *
    InvDateK   =  9;*
    InvYrPrK   = 10;*
}

Var
  ExInvRec  :  ^TBatchTHRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;

Begin
  If TestMode Then Begin
    ExInvRec:=P;
    If Lock Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetTrans:' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (P<>Nil) and (PLines<>Nil) and (PSize=Sizeof(TBatchTHRec)) then
  Begin
    If (Not (SearchPath In [0..10])) then
      SearchPath:=0;

    KeyS:=StrPas(SearchKey);
    ExInvRec:=P;
    Blank(ExInvRec^,Sizeof(ExInvRec^));

    Result:=Find_Rec(SearchMode,F[InvF],InvF,RecPtr[InvF]^,KeyXLate[SearchPath],KeyS);

    If (Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyXLate[SearchPath],InvF,SilentLock,Locked)) then
        Result:=0;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyXLate[SearchPath],InvF,SilentLock,Locked));
    {$ENDIF}

    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
    Begin
      InvToExInv(ExInvRec^);
      {* LineCount has been calculated to get actual total lines *}
      {* check PLSize >= Size of Total TLs *}
      ValidCheck:=( ExInvRec^.LineCount <= (PLSize div SizeOf(TBatchTLRec)) );

      {If (PLines<>Nil) then {* Get Invoice Lines *}

      If (ValidCheck) then
        {* add PLSize para. *}
        Get_TransLines(Inv.FolioNum,IdetailF,IdFolioK,PLines,ExInvRec^.LineCount,PLSize)
      else
        Result:=32765;

    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If ((P<>Nil) or (PLines<>Nil)) then
      Result:=32766;

end; {Func..}


{ ================ Procedures to Import/Edit a Transaction ================ }

Function ExInvToInv(ExInvRec   :  TBatchTHRec;
                    AddMode    :  SmallInt)  :  Integer;

Var
  n      :  Byte;
  OInv   :  InvRec;
  FindRec,
  ValidCheck,
  ValidHed
         : Boolean;
  KeyS1,
  KeyS   : Str255;

Begin

  Result:=0;
  ValidCheck:=BOff;
  ValidHed:=BOn;

  With Inv do
  Begin
    If (Abs(AddMode)=B_Insert) then
    Begin
      ResetRec(InvF);
      NLineCount:=1;

      If (Not ExSyss.OverWORef) then
      begin
        KeyS:=LJVar(ExInvRec.OurRef,DocLen);
        Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);
        FindRec:=StatusOk;

        If (FindRec) then
          GenSetError(Not FindRec,5,Result,ValidHed)
        else
        begin
          KeyS:=Copy(ExInvRec.OurRef,1,3);
          FindRec:=( DocCodes[DocTypeFCode(EXInvRec.TransDocHed)] = KeyS );

          If (Not FindRec) then
            GenSetError(FindRec,3,Result,ValidHed);

        end; {if (FindREc) ..}

      end;  {if Not Exsyss.OverWORef then }

    end
    else  {if Abs(AddMode)=Edit..}
    Begin
      { Don't display msg if -ve as its allowed }
      If (AddMode > 0) Then
        GenSetError(FindRec,4,Result,ValidHed);
      OInv:=Inv;
    end;

    CustCode:=FullCustCode(EXInvRec.CustCode);
    OurRef:=EXInvRec.OurRef;
    Currency:=EXInvRec.Currency;

    If (ExInvRec.AcYr>1900) then
      AcYr:=(ExInvRec.AcYr - 1900)
    else
      If (EXInvRec.AcYr In [0..255]) then
        AcYr:=EXInvRec.AcYr;

    If (EXInvRec.AcPr In [0..255]) then
      AcPr:=EXInvRec.AcPr;

    {* 13.10.98 - added to get the current periods if -1 is assigned  *}
    If (Not ExSyss.AutoSetPr) and ((ExInvRec.AcPr=-1) or (ExInvRec.AcYr=-1)) then
    begin
      AcYr:=Syss.CYr;
      AcPr:=Syss.CPr;
    end; {if..}

    DueDate:=EXInvRec.DueDate;
    TransDate:=EXInvRec.TransDate;
    YourRef:=EXInvRec.YourRef;
    TransDesc:=EXInvRec.LongYrRef;
    ILineCount:=EXInvRec.LineCount;

    {* From External to Ent. record *}
    CXRate[BOff]:=EXInvRec.CoRate;
    CXRate[BOn]:=EXInvRec.VATRate;
    SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }


    InvDocHed:=DocTypeFCode(EXInvRec.TransDocHed);

    {* 05.01.99 - Added for not to return Range Check Error
                  DocTypeFCode function in BTS1 has been modified as well. *}
    If (DocCodes[InvDocHed]<>ExInvRec.TransDocHed) then
      Result:=30215;


    For n:=0 to 23 do  {* changed from 9 to 16 on 10.06.97 *}
      InvVATAnal[VATType(n)]:=ExInvRec.InvVATAnal[n];

    InvNetVal:=ExInvRec.InvNetVal;
    InvVAT:=ExInvRec.InvVAT;
    DiscSetl:=ExInvRec.DiscSetl;
    DiscSetAm:=ExInvRec.DiscSetAm;
    DiscAmount:=ExInvRec.DiscAmount;
    DiscDays:=ExInvRec.DiscDays;
    DiscTaken:=ExInvRec.DiscTaken;
    TransNat:=ExInvRec.TransNat;
    TransMode:=ExInvRec.TransMode;
    HoldFlg:=ExInvRec.HoldFlg;
    TotalWeight:=ExInvRec.TotalWeight;

    For n:=1 to 5 do
      DAddr[n]:=ExInvRec.DAddr[n];

    TotalCost:=ExInvRec.TotalCost;
    PrintedDoc:=ExInvRec.PrintedDoc;
    ManVAT:=ExInvRec.ManVAT;
    DelTerms:=ExInvRec.DelTerms;
    OpName:=ExInvRec.OpName;
    DJobCode:=ExInvRec.DJobCode;
    DJobAnal:=ExInvRec.DJobAnal;

    {* 02.09.99 - If SOR/POR this needs to display on Ledger Screen *}
    If (InvDocHed In PSOPSet) then
      TotOrdOS:=(ExInvRec.InvNetVal - ExInvRec.DiscAmount);

    If (InvDocHed In TSTSplit) then
      BatchLink:=FullCustCode(ExInvRec.EmpCode);
    DocUser1:=ExInvRec.DocUser1;
    DocUser2:=ExInvRec.DocUser2;
    NoLabels:=ExInvRec.thNoLabels;
    CtrlNom:=ExInvRec.CtrlNom;
    Tagged:=ExInvRec.Tagged;

    {*** ver 4.31 ***}
    SOPKeepRate:=(InvDocHed In OrderSet);  {only for SOR and POR}
    DocUser3:=ExInvRec.DocUser3;
    DocUser4:=ExInvRec.DocUser4;
    SSDProcess:=UpCase(ExInvRec.SSDProcess);    { has validation }
    ExtSource:=ExInvRec.ExtSource;
    PostDate:=ExInvRec.PostDate;
    PORPickSOR:=ExInvRec.PORPickSOR;
    BDiscount:=ExInvRec.BDiscount;
    PrePostFlg:=ExInvRec.PrePostFlg;

  end; {With..}

end; {Func..}


{ ========= Convert Transaction Line ======== }

Function ExInvLineToId(ExIdRec   :  TBatchTLRec)  :  Integer;


Begin
  ResetRec(IDetailF);

  With Id do
  Begin
    {DocPRef:=ExIdRec.TransRefNo;  {* Add on 21.10.97 and Closed b/c Exch. DocPRef is Blank *}
    DocPRef:=Inv.OurRef;  { v4.31 }
    LineNo:=ExIdRec.LineNo;
    ABSLineNo:=LineNo;
    NomCode:=ExIdRec.NomCode;
    Currency:=ExIdRec.Currency;
    { external to Ent. record }
    CXRate[BOff]:=ExIdRec.CoRate;
    CXRate[BOn]:=ExIdRec.VATRate;

    SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }

    CCDep[BOn]:=LjVar(ExIdRec.CC,CCDpLen);
    CCDep[BOff]:=LjVar(ExIdRec.Dep,CCDpLen);
    {StockCode:=LjVar(ExIdRec.StockCode,StkLen);  {* Not deducting stock is bc of this ... 18.09.97 *}
    StockCode:=FullStockCode(Strip('B',[#1,#32],ExIdRec.StockCode));

    Qty:=ExIdRec.Qty;
    QtyMul:=ExIdRec.QtyMul;
    NetValue:=ExIdRec.NetValue;
    Discount:=ExIdRec.Discount;
    VATCode:=ExIdRec.VATCode;
    VAT:=ExIdRec.VAT;

    If (ExIdRec.Payment) then
      Payment:=DocPayType[SRC]
    else
      Payment:=DocPayType[SIN];

    DiscountChr:=ExIdRec.DiscountChr;
    QtyWOff:=ExIdRec.QtyWOff;
    QtyDel:=ExIdRec.QtyDel;
    CostPrice:=ExIdRec.CostPrice;
    CustCode:=FullCustCode(ExIdRec.CustCode);

    {* Changed on 21.11.97 for TL Delivery Date *}
    If (Not EmptyKey(ExIdRec.LineDate,SizeOf(PDate))) and
       (Not (Inv.InvDocHed In [NMT,ADJ,SBT,PBT])) then
        PDate:=ExIdRec.LineDate
    else
      PDate:=Inv.TransDate;

    Item:=ExIdRec.Item;
    Desc:=ExIdRec.Desc;
    LWeight:=ExIdRec.LWeight;
    MLocStk:=ExIdRec.MLocStk;
    JobCode:=ExIdRec.JobCode;
    AnalCode:=ExIdRec.AnalCode;
    If (Inv.InvDocHed In TSTSplit) then
      Reconcile:=ExIdRec.TSHCCurr
    else
      Reconcile:=ExIdRec.Reconcile;

    If (ExIdRec.DocLTLink In [1..4]) then
      DocLTLink:=ExIdRec.DocLTLink;

    LineType:=StkLinetype[Inv.InvDocHed];

    KitLink:=ExIdRec.KitLink;

    SOPLink:=ExIdRec.SOPLink;
    SOPLineNo:=ExIdRec.SOPLineNo;

    { HM 22/12/98: This is needed otherwise the ADJ has no effect on stock levels }
    { will need to be intelligently set as in adjlineu based on the stock item    }
    {QtyPack := 1;} { Temporarily commented out }

    {*** Ver 4.31 ***}
    LineUser1:=ExIdRec.LineUser1;
    LineUser2:=ExIdRec.LineUser2;
    LineUser3:=ExIdRec.LineUser3;
    LineUser4:=ExIdRec.LineUser4;

    SSDUplift:=ExIdRec.SSDUplift;
    SSDCommod:=ExIdRec.SSDCommod;
    SSDSPUnit:=ExIdRec.SSDSPUnit;
    SSDUseLine:=ExIdRec.SSDUseLine;
    If (PriceMulx=0) then
      PriceMulx:=1; { according to spec. }

    VATIncFlg:=ExIdRec.VATIncFlg;
    {*** -------------- ***}

  end; {With..}
  Result:=0;
end;

{ ================= Procedure to Set Reciept Payment Types ================ }

Function SetRPayment(DocHed  :  DocTypes)  :  Char;

Var
  TCh  :  Char;

Begin
  TCh:=DocPayType[DocHed];

  If (DocHed In DirectSet) then
    If (TCh=DocPayType[SIN]) then
      TCh:=DocPayType[SRC]
    else
      TCh:=DocPayType[SIN];

  SetRPayment:=TCh;
end; {func..}

(*
{ ==== Procedure to deduct stock and generate any hidden batch lines invoice ==== }

{ == Any changes here must be reflected in the main module == }

Procedure Gen_StockDeduct(Var Idr     :  IDetail;
                              Level   :  LongInt;
                              Mode    :  Byte);
Const
  Fnum     =  PWrdF;
  Keypath  =  PwK;

  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;

  Fnum3    =  IDetailF;
  Keypath3 =  IdFolioK;

  StkAdjCnst : Array[BOff..BOn] of Integer    = (-1, 1);

  BillMatTCode     =  'B';
  BillMatSCode     =  'M';

Var
  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  RecAddr  :  LongInt;

  QtyShort,
  QtyGCost :  Real;

  TmpStock :  ^StockRec;
  TmpId    :  ^Idetail;

  Function FullMatchKey (RC,ST        :  Char;
                         Login        :  Str20)  :  Str20;
  Begin
    FullMatchKey:=Rc+St+LJVar(Login,9);
  end;

Begin

  KeyS:='';
  KeyChk:='';
  KeyStk:='';
  RecAddr:=0;
  QtyShort:=0;
  QtyGCost:=0;

  New(TmpStock);
  New(TmpId);

  If (Idr.IdDocHed In StkAdjSplit) and (Idr.KitLink=1) and (Level=0) then
  Begin

    QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[(Idr.IdDocHed In StkOpoSet+StkAdjSplit)]*DocNotCnst));

    Ok:=CheckRecExsists(Idr.StockCode,Fnum2,StkCodeK);

  end
  else
  Begin

    If (Level=0) then {* Assume stock already deducted from line entry *}
      Ok:=CheckRecExsists(Idr.StockCode,Fnum2,StkCodeK)
    else
      Stock_Deduct(Idr,BOn,BOn,0);

    With IdR do
      QtyShort:=(((Qty-(QtyWOff+QtyDel))*QtyMul)-DeductQty);
  end;

  TmpStock^:=Stock;
  TmpId^:=Idr;

  If (Stock.StockType=StkBillCode) and ((Not Stock.ShowasKit) or (Level>0))
    and (Inv.InvDocHed In SalesSplit+StkAdjSplit-StkExcSet) and (QtyShort<>0)
    and (Ok) then
  With TmpStock^ do
  Begin

    If ((Inv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) then
      TmpId^.CostPrice:=0;

    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Password.BillMatRec do
    Begin
      Status:=GetPos(F[Fnum],Fnum,RecAddr);
      KeySTk:=BillLink;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

      If (StatusOk) then
      Begin
        With Idr do
        Begin
          StockCode:=LJVar(Stock.StockCode,StkLen);
          LineNo:=StkLineNo;
          Desc:=Stock.Desc[1];
          NetValue:=0;
          CostPrice:=0;
          VAT:=0;
          Discount:=0;
          DiscountChr:=C0;
          NomCode:=0;
          Blank(CCDep,Sizeof(CCDep));
          Qty:=(QtyShort*QtyUsed);
          QtyMul:=1;
          QtyDel:=0;
          QtyWOff:=0;
          QtyPick:=0;
          QtyPWOff:=0;

          If (Mode=0) then  {* Switch off ABS LineNo Control *}
          Begin
            ABSLineNo:=0;
            KitLink:=0;
            SOPLink:=0;   {* Reset any link *}
            SOPLineNo:=0;
          end
          else
            If (Level=0) then  {* Set Kit folio so it is treated as part of a batch *}
              KitLink:=TmpStock^.StockFolio;
        end;

        If (Stock.StockType=StkBillCode) then
        Begin
          Gen_StockDeduct(Idr,Succ(Level),Mode);
          SetDataRecOfs(Fnum,RecAddr);
          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
          QtyGCost:=1;  {* Set Cost to 1 here, as BOM will return total cost for Qty *}
        end
        else
        Begin
          Stock_Deduct(Idr,BOn,BOn,0);
          QtyGCost:=ABS(Idr.Qty);
        end;

        {* Calculate and adjustment BOM cost price by recalculating the BOM
           contents *}

        If ((Inv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) then
          TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyGCost)
        else
          CostPrice:=0;  {* Reset Cost price again, incase it has been set by
                          an adjustment valuation *}

        Status:=Add_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3);

      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Stock:=TmpStock^;
    Idr:=TmpId^;

  end; {If Kit or Normal Product ..}

  Dispose(TmpStock);
  Dispose(TmpId);
end; {Proc..}

*)

Procedure Gen_StockDeduct(Var Idr     :  IDetail;
                              LInv    :  InvRec;
                              Level   :  LongInt;
                              Mode    :  Byte;
                          Var BOMOCost:  Double;
                              StkFolio:  LongInt);

Const

  Fnum     =  PWrdF;

  Keypath  =  PwK;


  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;

  Fnum3    =  IDetailF;
  Keypath3 =  IdFolioK;

Var

  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  RecAddr  :  LongInt;

  QtyShort,
  QtyGCost :  Real;

  OwnCost,
  KitOCost :  Double;

  TmpStock :  ^StockRec;
  TmpId    :  ^Idetail;

  Locked   :  Boolean;

Begin

  KeyS:='';

  KeyChk:='';

  KeyStk:='';

  RecAddr:=0;

  New(TmpStock);
  New(TmpId);

  QtyShort:=0;

  QtyGCost:=0;

  If (Level=0) then
    BOMOCost:=0;

  KitOCost:=0;
  OwnCost:=0;



  If (Idr.IdDocHed In StkAdjSplit) and (Idr.KitLink=1) and (Level=0) then
  Begin

    QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[Idr.IdDocHed]*DocNotCnst));
{ Old .. QtyShort:=((Idr.Qty*Idr.QtyMul*StkAdjCnst[(Idr.IdDocHed In StkOpoSet+StkAdjSplit)]*DocNotCnst));}
    {GetStock(Application.MainForm,Idr.StockCode,Idr.StockCode,-1);}

    Locked:=BOff;
    KeyS:=Idr.StockCode;

    {$IFDEF WIN32}
    If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
      Status:=0;
    {$ELSE}
    Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
    {$ENDIF}

  end
  else
  Begin
    {* This will be different from Ex, as Ex non SPOP deletes the lines first hence why
       a deduct needs to take place here as well *}

    If (Level=0) then {* Assume stock already deducted from line entry *}
    begin
      {GetStock(Application.MainForm,Idr.StockCode,Idr.StockCode,-1)}
      Locked:=BOff;
      KeyS:=Idr.StockCode;

      {$IFDEF WIN32}
      If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
        Status:=0;
      {$ELSE}
      Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
      {$ENDIF}

    end
    else
      Stock_Deduct(Idr,LInv,BOn,BOn,0);


    QtyShort:=((Qty_OS(Idr)*Idr.QtyMul)-Idr.DeductQty);

    {* If own stock exsits, the record cost contribution of that *}
    If (Idr.IdDocHed In StkAdjSplit) and (Stock.StockType=StkBillCode) and (Round_Up(Idr.DeductQty,Syss.NoQtyDec)<>0.0) then
    Begin
      OwnCost:=(Idr.CostPrice*(ABS(Idr.DeductQty)-1)); {* One less as idr.costprice will account for one of them *}
    end;

    {* EN422. At this point if none are from stock we need to zero the cost of this line,
       as it is already being taken into account by
       Own cost, and hence will be taken in to account twice? *}

    {* EX423. An additional check made so that description only items do not have cost reset at this point. *}

    If (IdR.DeductQty=0) and (Stock.StockType<>StkDescCode) then
      IdR.CostPrice:=0.0;


  end;

  TmpStock^:=Stock;

  TmpId^:=Idr;

  {Need to confirm 13.07.99.......}

  { This is o.k for Kit Disabled -  No BOM stock, and deduct from Components ...}
  If (Stock.StockType=StkBillCode) and ((Not Stock.ShowasKit) or (Level>0))
    and (LInv.InvDocHed In SalesSplit+StkAdjSplit-StkExcSet) and (QtyShort<>0) then
  With TmpStock^ do
  Begin


    If ((LInv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) and (Level=0) then
      TmpId^.CostPrice:=0;

    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Password.BillMatRec do
    Begin

      {Application.ProcessMessages;}

      Status:=GetPos(F[Fnum],Fnum,RecAddr);

      KeySTk:=BillLink;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);

      If (StatusOk) then
      Begin
        With Idr do
        Begin

          StockCode:=Stock.StockCode;

          LineNo:=StkLineNo;

          If (EmptyKey(Desc,SizeOf(Desc))) then
            Desc:=Stock.Desc[1];

          NetValue:=0;

          CostPrice:=0;

          VAT:=0;

          Discount:=0;

          DiscountChr:=C0;

          NomCode:=0;

          Blank(CCDep,Sizeof(CCDep));

          Qty:=(QtyShort*QtyUsed);

          QtyMul:=1;
          QtyPack:=QtyMul;

          QtyDel:=0;
          QtyWOff:=0;
          QtyPick:=0;
          QtyPWOff:=0;
          SerialQty:=0;

          If (Mode=0) then  {* Switch off ABS LineNo Control *}
          Begin

            ABSLineNo:=0;

            {$IFDEF SOP}
              KitLink:=StkFolio;
            {$ELSE}
              KitLink:=0;
            {$ENDIF}


            SOPLink:=0;   {* Reset any link *}
            SOPLineNo:=0;
          end
          else
            If (Level=0) then  {* Set Kit folio so it is treated as part of a batch *}
              KitLink:=TmpStock^.StockFolio;


        end;


        If (Stock.StockType=StkBillCode) then
        Begin

          Gen_StockDeduct(Idr,LInv,Succ(Level),Mode,KitOCost,StkFolio);

          SetDataRecOfs(Fnum,RecAddr);

          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

          QtyGCost:=1;  {* Set Cost to 1 here, as BOM will return total cost for Qty *}

        end
        else
        Begin
          Stock_Deduct(Idr,LInv,BOn,BOn,0);

          QtyGCost:=ABS(Idr.Qty);

        end;

        {* Calculate and adjustment BOM cost price by recalculating the BOM
           contents *}

        If ((LInv.InvDocHed In StkAdjSplit) and (Syss.AutoValStk)) then
        Begin
          If (Level=0) then
            TmpId^.CostPrice:=TmpId^.CostPrice+(Idr.CostPrice*QtyGCost)+KitOCost+OwnCost
          else
            OwnCost:=OwnCost+(Idr.CostPrice*QtyGCost)+KitOCost;
        end
        else
          Idr.CostPrice:=0;  {* Reset Cost price again, incase it has been set by
                          an adjustment valuation *}

        KitOCost:=0;

        Status:=Add_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3);


      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Stock:=TmpStock^;

    Idr:=TmpId^;

  end; {If Kit or Normal Product ..}

  BOMOCost:=BOMOCost+OwnCost;

  Dispose(TmpStock);

  Dispose(TmpId);


end; {Proc..}


{ ====== Function to Store Detail Lines ======= }

Function Store_EId  :  Integer;
{* Changes made on 09.07.99 - To be the same as Import Module, mainly
   BOM deduction was not correct. *}

Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;

Var
  Rnum      :  Double;
  StkFolio  :  LongInt;

Begin
  With Id do
  Begin
    FolioRef:=Inv.FolioNum;
    IDDocHed:=Inv.InvDocHed;

    {09.07.99 - Added StkAdjSplit }
    If (Payment=DocPayType[SRC]) or (IDDoched In NomSplit+StkAdjSplit) then
      LineNo:=RecieptCode;

    {09.07.99}
    If (Inv.InvDocHed In TSTSplit) then
       NomMode := TSTNomMode;     { TSTNomMode = 3 }

    {Payment:=SetRPayment(IDdocHed);}
    {* Added on 17/02/98 for SRI value is Debit instead of Credit for New Zealand *}
    If (Payment=DocPayType[SRC]) then
      Payment:=SetRPayment(IDDocHed)
    else
      Payment:=DocPayType[IDDocHed];

    If (QtyMul=0) then
      QtyMul:=1;

    {09.07.99 - Added StkAdjSplit+TSTSplit }
    If (Not ExSyss.MCMode) or (Not (Inv.InvDocHed In RecieptSet+NomSplit+StkAdjSplit+TSTSplit)) then
    Begin
      CXRate:=Inv.CXRate;
      CurrTriR:=Inv.CurrTriR; { for v4.31 }

      Currency:=Inv.Currency;
    end;

    PYr:=Inv.ACYr;
    PPr:=Inv.AcPr;

    If (Syss.AutoClearPay) then
      Reconcile:=ReconC;

    If (IDDocHed In SalesSplit+PurchSplit) then
      CustCode:=Inv.CustCode;

    { 09.07.99 - need to check with EL. should or not?
    If (Not (IdDocHed In OrderSet+QuotesSet)) then
      PDate:=EInv.TransDate;}

    {PDate:=Inv.TransDate;  Closed 21.11.97 }

    {* Moved after Stock_Deduct b/c of DeductQty updating - 07.07.97 *}
    {Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);}

    {* Stock Deduct Here *}
    (* 09.07.99 - It is different from Import Module ..

    If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode) and (ExSyss.UpStkBal) then
    begin
      { 07.07.99 - Added Inv parameter }
      Stock_Deduct(Id,Inv,BOn,BOn,0);

      Rnum:=0;
      StkFolio:=Stock.StockFolio;

      If ExSyss.DeductBOM Then
        Gen_StockDeduct(Id, Inv, 0, 0, Rnum, StkFolio);

      { To confirm - Does not Update Parent Stock !!!!.......
      If ExSyss.DeductBOM Then
        Gen_StockDeduct(Id, 0, 0)
      Else
        Stock_Deduct(Id,BOn,BOn,0);
      }

    end
    else      {* Add on 09.02.99 *}
    begin
      If (StockCode[1]=PayInCode) then
        StockCode:=FullPayInKey(StockCode);

    end; {if..}
    *)

    {* Stock Deduct Here *}
    If Not (Inv.InvDocHed In TSTSplit) then
    Begin

      If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode)
         and (ExSyss.UpStkBal) then
      begin

        Stock_Deduct(Id,Inv,BOn,BOn,0);

        If (ExSyss.DeductBOM) and (Inv.InvDocHed In SalesSplit+StkadjSplit) Then
        begin
          Rnum:=0;
          StkFolio:=Stock.StockFolio;
          Gen_StockDeduct(Id, Inv, 0, 0, Rnum, StkFolio);
        end; {if..}

      end
      else
        If (StockCode[1]=PayInCode) then
          StockCode:=FullPayInKey(StockCode);

    end; {not TSH}
    {=====================}

    {* Closed becuase in Import Module, StockVers is checked if Stock file has more than
       one record.. *}
    {If (StockVers) then
    Begin}
      LineType:=StkLinetype[IdDocHed];

      If (IdDocHed In StkAdjSplit) then
      Begin
        PostedRun:=StkAdjRunNo;
        NomMode:=StkAdjNomMode;
      end;
    {end;}

    ABSLineNo:=LineNo;

    If (Inv.InvDocHed In TSTSplit) then Begin
       ABSLineNo:=Inv.ILineCount;
       PYr:=Inv.AcYr;
       PPr:=Inv.AcPr;
    end;

    Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

  end; {With..}

end;

{ ============================= }
Function Store_JobActual(TJAType,
                         TCurrCharge : Byte;
                         TChargeType : SmallInt) : SMALLINT;

{* Store Job Actual Record if Job Code is not empty. *}

Const
  Fnum     =  JDetlF;
  Keypath  =  JDAnalK;

Var
  TmpQ,
  TmpQM,
  UpLift         : Double;

  FoundOK        : Boolean;
Begin

  With JobDetl^.JobActual do
  Begin
    ResetRec(Fnum);

    JobDetl^.RecPFix  := JBRCode;  {J}
    JobDetl^.SubType  := JBECode;  {E}

    JobCode        := Id.JobCode;
    ActCurr        := Id.Currency;
    ActYr          := Id.PYr;
    ActPr          := Id.PPr;
    LineFolio      := Id.FolioRef;
    LineNo         := Id.ABSLineNo;
    LineORef       := Inv.OurRef;
    StockCode      := Id.StockCode;
    JDate          := Inv.TransDate;
    OrigNCode      := Id.NomCode;
    JDDT           := Inv.InvDocHed;
    ActCCode       := Id.CustCode;
    AnalCode       := Id.AnalCode;
    JAType         := TJAType; {assigned in Valid_Lines}

    If (JDDT=TSH) then Begin
      EmplCode     := FullCustCode(Inv.BatchLink);
      EmplKey      := FullJDEmplKey(JobCode,EmplCode,ReconTS);
    end;

    {* --------------- for Qty & Cost ---------------- *}

    {$IFDEF JC}              {* If Job Costing Module only *}
      Qty          := Id.Qty;
      Cost         := Id.NetValue;
    {$ELSE}
      {$IFDEF SOP}
        Qty:= Qty_OS(Id);
      {$ELSE}
        Qty:= Id.Qty;
      {$ENDIF}

      If (JDDT In StkAdjSplit) then
        Qty:= Qty*DocNotCnst;  {* DocNotCnst = -1 *}

      With Id do
      Begin
        TmpQ:=Qty;
        TmpQM:=QtyMul;
        Qty:=1;
        QtyMul:=1;
        If (IdDocHed<>ADJ) then
          Cost:=DetLTotal(Id,BOn,BOff)*LineCnst(Payment)
        else
          Cost:=CostPrice;
        Qty:=TmpQ;
        QtyMul:=TmpQM;
      End; { with EId do }

    {$ENDIF}

    {* ------------- For Charge ---------------------------------- *}
    {$B-}

    UpLift:=0;

    If (Not (JDDT In SalesSplit+QuotesSet+PSOPSet)) and
       (Get_BudgMUp(JobCode,AnalCode,StockCode,ActCurr,UpLift,1)) then {* Recharge set *}
    Begin
    {$B+}
         Case TChargeType of
           CPChargeType  :  Charge:=Round_Up(Round_Up(Cost+(Cost*Pcnt(UpLift)),2)*Qty,2);
                                                                 {in ETMiscU.Pas}
           TMChargeType  :  Begin
                            If (JDDT=TSH) then
                              Charge:=Id.CostPrice*Qty
                              {$IFNDEF JC}
                            else
                            Begin

                                {$IFDEF STK}
                                   {$IFDEF PF_On}

                                     If (Is_FullStkCode(StockCode)) then
                                     Begin
                                       {* œœœœœ 1,2,3&4 are for future enhancement *}
                                       {1). If (StockCode<>Stock.StockCode) then
                                             GetStock(StockCode,KeyF,-1);

                                       2). If (JobRec^.CustCode<>Cust.CustCode) then
                                             GetCust(JobRec^.CustCode,Off,Off,''); }

                                       FoundOk:=BOn;

                                       {3). Calc_StockPrice(Stock,Cust,ActCurr,Qty,QPrice,QDisc,CHDisc,FoundOk);

                                       4). Charge:=Round_Up((QPrice-Calc_PAmount(QPrice,QDisc,CHDisc))*Qty,2);}

                                       Charge:=0;

                                     end;

                                   {$ENDIF}
                                {$ENDIF}


                            end;       {* JDDT=TSH *}

                              {$ELSE}
                                  ;
                              {$ENDIF}

                            end;       {* TMChargeType *}

         end; {Case.}

         If (JDDT=TSH) then
           CurrCharge:=Id.Reconcile
         else
           CurrCharge:=TCurrCharge; {JobRec^.CurrPrice}

    end; {If Not JDDT and Get_BudgMUp ..}


    {* ------ End for Charge & Start for Index Keys ------------- *}

    LedgerCode:=FullJDLedgerKey(JobCode,Posted,Invoiced,ActCurr,JDate);

    RunKey:=FullJDRunKey(JobCode,PostedRun,JDate);

    LookKey:=FullJDLookKey(LineFolio,LineNo);

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

  End; {with EJobDetl.JobActual }

  Store_JobActual:=Status;

End;

{* ----------------------------------------------------------------- *}

{ ====== Process SetUp File ====== }

Function  Validate_Lines(    Mode       :  Byte;
                             LineChk    :  LongInt;
                         Var ImpVariance:  Double;
                             P          :  Pointer)  :  Integer;

Const
  YN : Array[BOff..BOn] of String[3] = ('No','Yes');

Var
  TBo,
  Abort,
  Belongs,
  ValidHed,
  ValidCheck,
  ConvOk,
  RepBo,
  VJActual       :  Boolean;

  LineCost,
  LineWeight,
  LineVAT,
  LineNET,
  LineTot,
  LineDir,
  ImpBase,
  TmpQty,
  TmpNetValue    :  Double;

  TmpSSD,
  ErrSSDCode,
  LineNominal,
  FileRecNo      :  LongInt;

{  ExInvLines     :  ^TBatchLinesRec; }

  {* Add for changes 6.2.97 *}
  ExIdRec        :  TBatchTLRec;
  RecSeg,RecOfs,
  RecPos         : LongInt;

  TmpBudg       :  String[27]; { to check for Emp.Pay Rate }
  UOR,
  TmpJAType,
  TmpCurrCharge :  Byte;       { both for Job Actual Rec. JAType }
  TmpChargeType :  SmallInt;   { for Job Rec's ChargeType }

  TmpXRate,
  Test1,Test2   :  Double;

  KeyF          :  Str255;


Begin

  Belongs:=BOn;   ValidHed:=BOn;  ValidCheck:=BOff;
  ConvOk:=BOff;   TBo:=BOff;      RepBo:=BOff;

  LineNET:=0;  LineVAT:=0;     LineTot:=0;
  LineDir:=0;  ImpBase:=0;     ImpVariance:=0;
  LineCost:=0; LineWeight:=0;  Result:=0;
  UOR:=0;

  FileRecNo:=1;     {* Inc() is before end of loop *}

  If (P<>Nil) then
  Begin
   { ExInvLines:=P; }

    While (Result=0) and (FileRecNo<=LineChk) do
    Begin
    {* ========= using Ptr Position ============*}
      FillChar(ExIdRec,SizeOf(ExIdRec),#0);
    {$IFDEF WIN32}
      RecPos:=LongInt(P)+( Pred(FileRecNo)*SizeOf(ExIdRec));
      Move(Pointer(RecPos)^,ExIdRec,SizeOf(ExIdRec));
    {$ELSE}
      RecSeg:=Seg(P^);
      RecOfs:=Ofs(P^);
      RecOfs:=RecOfs + ( Pred(FileRecNo)*SizeOf(ExIdRec) );
      Move(Ptr(RecSeg,RecOfs)^,ExIdRec,SizeOf(ExIdRec) );
    {$ENDIF}

      {Result:=ExInvLineToId(ExInvLines^[FileRecNo]);}
      Result:=ExInvLineToId(ExIdRec);

      ConvOk:=(Result=0);

      If (ConvOk) then {* Include this Line *}
      With Id do
      Begin
        {* Check Currency *}

        If (ExSyss.MCMode) and (Inv.InvDocHed In NomSplit+RecieptSet) then
        begin
          ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
          {* 18.08.99 - Added to use Default Currency *}
          If (Not ValidCheck) then
          begin
            Currency:=ExSyss.DefCur;
            ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
          end;
        end
        else
          ValidCheck:=BOn;

        GenSetError(ValidCheck,30100,Result,ValidHed);

        If (ExSyss.MCMode) then {* Check Currency Rates *}
        Begin

          {* 06.01.99 - Added this condition when Euro conversion was tested
                        with EL's advice *}
          If (ExSyss.UseExCrRate) then {* OverWrite Currency Rates *}
          begin
            CXrate:=SyssCurr^.Currencies[Currency].CRates;
            SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
          end; {if..}

          (*
          {* 01.04.99 - Ent. v4.30a validates these fields *}
          VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;
          OrigRates:=SyssCurr^.Currencies[Currency].CRates;
          *)

          ValidCheck:=((CXRate[BOn]<>0) or (Inv.InvDocHed In StkAdjSplit));

          GenSetError(ValidCheck,30101,Result,ValidHed);

          If (Not UseCoDayRate) or (Inv.InvDocHed In NomSplit) then
          Begin
            ValidCheck:=((CXRate[BOff]<>0) or (Inv.InvDocHed In StkAdjSplit));
            GenSetError(ValidCheck,30102,Result,ValidHed);
          end;

          {* 06.01.99 - Added with EL's Advice *}
          If (Not (Inv.InvDocHed In NomSplit)) then {* Set to floating *}
          begin
            CXRate[BOff]:=0;
            SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
          end;

        end
        else
        Begin
          Currency:=0;
          CXrate:=SyssCurr^.Currencies[Currency].CRates;
          SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
        end;

        TmpQty:=TrueReal(Qty,Syss.NoQtyDec);
        TmpNetValue:=TrueReal(NetValue,Syss.NoNetDec);
        LineTot:=Round_Up((TmpQty*TmpNetValue),2);

        {* For TSH, total Qty = TotalInvoiced *}
        If (Inv.InvDocHed In TSTSplit) and (Mode=1) then
          Inv.TotalInvoiced:=Inv.TotalInvoiced + TmpQty;

        If ((ExSyss.MCMode) and (Inv.InvDocHed In RecieptSet+NomSplit)) then {* Convert to Base equiv *}
        begin
          {LineTot:=Round_Up(Conv_Curr(LineTot,CXRate[UseCoDayRate],BOff),2);}
          TmpXRate:=XRate(CXRate,UseCoDayRate,Currency);
          {* 02.02.99 Added new parameter 0 for new Conv_TCurr function *}
          LineTot:=Round_Up(Conv_TCurr(LineTot,TmpXRate,Currency,0,BOff),2);

        end;

        {* Add Doc Line Type Total Here ... 19.11.97 *}
        If (DocLTLink>0) then
          Inv.DocLSplit[DocLTLink]:=Inv.DocLSplit[DocLTLink]+LineTot;

        {* do not include in total check, as its a variance line *}
        If ((Inv.InvDocHed In RecieptSet) and (NomCode=Syss.NomCtrlCodes[CurrVar]) and (ExSyss.MCMode)) then
        Begin
          ImpVariance:=ImpVariance+LineTot; {* Calculate variance contribution *}
        end
        else
          {* Do Not Include Direct Payment Parts *}
          If ((Payment<>DocPayType[SRC]) or (Not (Inv.InvDocHed In DirectSet))) then
          Begin
            LineVAT:=LineVAT+VAT;
            LineNet:=LineNet+LineTot;
            {* Add LineCost and Line Weight *}
            LineCost:=Round_Up(LineCost+Round_Up((CostPrice*Qty),Syss.NoCosDec),2);
            LineWeight:=LineWeight+(LWeight*Qty);
          end;

        {ssm
        If ((Copy(Inv.YourRef,1,5)='28202') or (Copy(Inv.YourRef,1,5)='28100')) then
          ShowMessage('Qty : '+FloatToStr(TmpQty)+#10#13+
                      'NetValue : '+FloatTostr(TmpNetValue)+#10#13+
                      'LineTot : '+FloatToStr(LineTot)+#10#13+
                      'Line Net : '+FloatToStr(LineNet));
        }

        If (Inv.InvDocHed In DirectSet) and (Payment=DocPayType[SRC]) then
          LineDir:=LineDir+LineTot;

        {* Validate key details *}
        {* LineNo *}

        ValidCheck:=(LineNo>0);

        GenSetError(ValidCheck,30103,Result,ValidHed);

        {* Nominal Check *}
        {* Add TSTSplit and change repeat loop to check for Default Nom Code *}

        If (Not (Inv.InvDocHed In TSTSplit)) then
        begin
          RepBo:=BOff;
          Repeat
            { Changed for T.Pink & Tomkins ..NOMs
            ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(NomCode)),NomF,NomCodeK)
                         or (LineTot=0) );
            ValidCheck:=((ValidCheck) and ((Nom.NomType In [BankNHCode,PLNHCode])
                                            or (LineTot=0)));
            }

            ValidCheck:=(Not (Inv.InvDocHed In NomSplit)) and (LineTot=0);
            If (Not ValidCheck) then
            begin
              ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(NomCode)),NomF,NomCodeK));

              ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

            end;
            GenSetError(ValidCheck,30104,Result,ValidHed);

            RepBo:=Not RepBo;

            If (Not ValidCheck) then
              NomCode:=ExSyss.DefNom;  {* Default Nom Code *}

          Until (Not RepBo) or (ValidCheck);

        end;

        {* Cost Centre/Dep Check *}
        {* Add validation 19.2.97 *}

        For Tbo:=BOff to BOn do
        Begin
          {* Changed on 12/03/97 requested by NewZeland to allow CC & Dept if Line Total = 0 *}
          (*
          ValidCheck:=((Not Syss.UseCCDep) or
                       ((Not (Inv.InvDocHed In StkAdjSplit)) and (LineTot=0)));
          *)

          ValidCheck:=((Not Syss.UseCCDep) or
                       ((Not (Inv.InvDocHed In StkAdjSplit+NomSplit)) and (LineTot=0) and (LineCost=0)));


          If (ValidCheck) then CCDep[Tbo]:='';

          If (Not ValidCheck) then
          Begin
            RepBo:=BOff;
            Repeat

              KeyF:=(CostCCode+CSubCode[TBo]+CCDep[TBo]);
              Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyF);

              ValidCheck:=(Status=0);
              {ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+CCDep[TBo],PWrdF,PWK)));}

              If (Not ValidCheck) then
                  CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

              RepBo:=Not RepBo;

            Until (Not RepBo) or (ValidCheck);
            GenSetError(ValidCheck,30105,Result,ValidHed);
          end;

        end;

        {* Stock Code Check *}


        {If ((Payment=DocPayType[SRC]) and (Not (IDDoched In NomSplit)) and
            (StockCode[1]<>PayInCode)) then
             StockCode:=PayInCode+StockCode;
        }

        {* Changed on 16/03/99 for PayInRef and ADJ not showing in the ledger
           because IDDocHed has not been assigned at this stage *}
        If ((Payment=DocPayType[SRC]) and (Not (Inv.InvDocHed In NomSplit+StkAdjSplit)) and
            (StockCode[1]<>PayInCode)) then
             StockCode:=PayInCode+StockCode;

        ValidCheck:=((EmptyKey(StockCode,StkLen)) or (StockCode[1]=PayInCode) or (Inv.InvDocHed In TSTSplit));

        If (Not ValidCheck) then
        Begin
          ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));

          ValidCheck:=((ValidCheck) and (Stock.StockType In StkProdSet+[StkDescCode]));

          GenSetError(ValidCheck,30106,Result,ValidHed);

          {* 05.01.99 - Reported by Hayden Lab, ADJ Trans Stock Deduction *}
          If (ValidCheck) then
          begin
            If (Stock.DPackQty) then
              QtyPack:=Stock.BuyUnit
            else
              QtyPack:=1;

            {* 07.07.99 - added otherwise, line description is blank *}
            If EmptyKey(Desc,SizeOf(Desc)) then
              Desc:=Stock.Desc[1];
          end; {if..}

        end;
        { --------------------------------- }
        {* Multi Location Code Check *}

        {* Added (Not Syss.UseMLoc) for NewZeland and (Empty(StockCode) for S.C.C  *}
        ValidCheck:=(EmptyKey(StockCode,StkLen)) or
                    (Not Syss.UseMLoc);
        { Closed on 26.01.99 for EL advised that if Syss.UseMLoc is OFF
          allow Location Code to be entered whatever it is...
        ValidCheck:=(((EmptyKey(MLocStk,LocKeyLen)) and (Not Syss.UseMLoc))
                      or (EmptyKey(StockCode,StkLen)));}

        If (Not ValidCheck) then
          ValidCheck:=(CheckRecExsists(MLocFixCode[True]+LJVar(MLocStk,LocKeyLen),MLocF,MLK));

        GenSetError(ValidCheck,30115,Result,ValidHed);

        { --------------------------------- }

        VJActual:=BOff; {* for Job Actual *}
        {* JobCode checking *}
        {* Stock Code checking for TSH *}
        {* Check AnalCode in AnalRec of JobMiscFile. If valid, *}
        {* check StockCode(EmpPayRate) in EmplPayRec of JobCtrlFile *}

        If (Not ExSyss.JBIgnore) then
        begin

          If (Inv.InvDocHed In TSTSplit) then
          Begin
            ValidCheck:=(CheckRecExsists(JobCode,JobF,JobCodeK));

            If (ValidCheck) then TmpChargeType:=JobRec^.ChargeType; {for Job Actual Rec.}

            GenSetError(ValidCheck,30111,Result,ValidHed);

            ValidCheck:=(CheckRecExsists(JARCode+JAACode+AnalCode,JMiscF,JMK));

            GenSetError(ValidCheck,30112,Result,ValidHed);

            If (ValidCheck) then
            Begin
               VJActual:=BOn;

               TmpJAType:=JobMisc^.JobAnalRec.AnalHed; {for Job Actual Record}

               TmpBudg := FullJBCode(FullNomKey(-1),Currency,StockCode);

               ValidCheck:=((CheckRecExsists(JBRCode+JBECode+TmpBudg,JCtrlF,JCK)));

               {* 02.09.99 - Added EmptyKey validation *}
               If (ValidCheck) and (EmptyKey(Desc,SizeOf(Desc))) then
                  Desc:=JobCtrl^.EmplPay.PayRDesc;

               GenSetError(ValidCheck,30113,Result,ValidHed);

            end; {If ValidCheck for AnalCode}

            {* For TSH Charge Currecny *}
            If (ExSyss.MCMode) then
            begin
              ValidCheck:=((Reconcile>=1) and (Reconcile<=CurrencyType));
              {
              If (Not ValidCheck) then
              begin
                 Reconcile:=Currency;
                 ValidCheck:=BOn;
              end;
              }
              GenSetError(ValidCheck,30114,Result,ValidHed);

            end
            else
              Reconcile:=0; {not MC}

          end {If TSH}
          else { for other Transaction Code - SIN, PIN etc..}
          begin

            ValidCheck:=(EmptyKey(JobCode,JobCodeLen));

            If (Not ValidCheck) then
            Begin
              ValidCheck:=(CheckRecExsists(JobCode,JobF,JobCodeK));

              If (ValidCheck) then
              begin
                TmpCurrCharge:=JobRec^.CurrPrice;  {for Job Actual Rec.}
                TmpChargeType:=JobRec^.ChargeType; {for Job Actual Rec.}
                VJActual:=BOn;
              end;

              GenSetError(ValidCheck,30111,Result,ValidHed);
            end;

            ValidCheck:=(EmptyKey(AnalCode,JobCodeLen));

            If (Not ValidCheck) then
            Begin
              ValidCheck:=(CheckRecExsists(JARCode+JAACode+AnalCode,JMiscF,JMK));

              TmpJAType:=JobMisc^.JobAnalRec.AnalHed; {for Job Actual Rec.}

              GenSetError(ValidCheck,30112,Result,ValidHed);
            end;

          end;
        end; {if (Not JBIgnore) ..}
        {* --------------------------- *}

        {* VAT Code Check *}

        ValidCheck:=(((VATCode<>VATICode) and (VATCode In VATSet))
                     or (LineTot=0) or (Payment=DocPayType[SRC]));

        {* 18.08.99 - No Default VAT Code line in the INI file !!! *}
        If (Not ValidCheck) then
        begin
          VATcode:=ExSyss.DefVAT;
          ValidCheck:=(((VATCode<>VATICode) and (VATCode In VATSet))
                     or (LineTot=0) or (Payment=DocPayType[SRC]));

        end; {if..}

        GenSetError(ValidCheck,30107,Result,ValidHed);

        {* Discount Code Check *}

        ValidCheck:=(DiscountChr In StkBandSet+[#0,#32,PcntChr]);

        GenSetError(ValidCheck,30108,Result,ValidHed);

        {* Version 4.31 *}
        {* SSDUplift Check *}
        ValidCheck:=(SSDUplift>=0) and (SSDUplift<=100);
        GenSetError(ValidCheck,30116,Result,ValidHed);

        {* SSD Commodity Code Check *}

        If (SSDUseLine) then
        begin
          Val(SSDCommod, TmpSSD, ErrSSDCode);
          ValidCheck:=(ErrSSDCode=0);
          GenSetError(ValidCheck,30117,Result,ValidHed);
        end; {if..}

        {* Check GL default currency *}
        If (Not (Inv.InvDocHed In StkADJSplit)) then
        begin
          ValidCheck:=Check_GLCurr(Inv,Id,0);
          GenSetError(ValidCheck,30118,Result,ValidHed);
        end; {if..}

        {* v4.31 Check CVat Inc. Flag *}
        If (VATCode=VATICode) then
        begin
          ValidCheck:=(VATIncFlg In VATSet-VATEqStd);
          GenSetError(ValidCheck,30119,Result,ValidHed);
        end; {if..}

        {* End of Validation *}

        If (ValidHed) and (Mode=1) then
        begin
          Result:=Store_EId;
          If ((Result=0) and (VJActual)) then
            Result:=Store_JobActual(TmpJAType,TmpCurrCharge,TmpChargeType);
        end; {if..}

      end;

      Inc(FileRecNo);

    end; {While..}


    If (ExSyss.MCMode) and (Inv.InvDocHed In RecieptSet+NomSplit) then {* Convert to base equiv *}
    begin
      {ImpBase:=Round_Up(Conv_Curr(Inv.InvNetVal,Inv.CXRate[UseCoDayRate],BOff),2)}
      TmpXRate:=XRate(Inv.CXRate,UseCoDayRate,Inv.Currency);
      {* 02.02.99 Added new parameter 0 for new Conv_TCurr function *}
      ImpBase:=Round_Up(Conv_TCurr(Inv.InvNetVal,TmpXRate,Inv.Currency,0,BOff),2);

    end
    else
      ImpBase:=Round_Up(Inv.InvNetVal,2);

    ValidCheck:=(Round_Up(LineNet,2)=Round_Up(ImpBase,2));

    GenSetError(ValidCheck,30109,Result,ValidHed);

    ValidCheck:=((Not (Inv.InvDocHed In DirectSet)) or (Round_Up(LineDir,2)=Round_Up(ITotal(Inv),2)));

{ShowMessage ('LineDir: ' + FloatToStr(LineDir) + ' (' + IntToStr(Round(LineDir)) + ')' + #13 +
             'ITotal(Inv): ' + FloatToStr(ITotal(Inv)) + ' (' + IntToStr(Round(ITotal(Inv))) + ')');}

    GenSetError(ValidCheck,30110,Result,ValidHed);
   end
   else
     Result:=32766;

end; {Proc..}

(*
{ ====== Set Doc Alloc Status ====== }

Procedure Set_DocAlcStat(Var  InvR  :  InvRec);

Var
  Mode  :  Byte;
  TmpBo :  Boolean;
  Rnum  :  Real;

Begin
  { open this 01.09.99 and added condition }
  Rnum:=Round_Up(BaseTotalOS(InvR),2);

  With InvR do
  Begin
    If (InvDocHed In DocAllocSet) and (Rnum<>0) and (RunNo>=0) then
    Begin
      TmpBo:=(InvDocHed In SalesSplit);

      AllocStat:=TradeCode[TmpBo];

      UntilDate:=NDXWeight; {* add 13.2.97 *}

      {
      If (Autho_Auto(ESyss.AuthMode)) then
        HoldFlg:=HoldP;}

    end
    else
    Begin
      AllocStat:=#0;
    end;

  end; {With..}

end;
*)

{ ====== Function to Store Doc Headers ======= }

Function Store_ExDoc  :  Integer;

Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;

Begin

  With Inv do
  Begin
    Set_DocAlcStat(Inv);
    ILineCount:=ILineCount+2; {30.09.99 - not to get duplicate ABSLineNo }
    Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);
  end; {With..}

end;

{ ======= Function to Return Special Order based Run No. ========= }

Function Set_OrdRunNo(DocHed   :  DocTypes;
                      AutoOn,
                      Posted   :  Boolean)  :  LongInt;

Var
  Lnum  :  LongInt;

Begin

  Lnum:=0;

  If (DocHed In PSOPSet) then
  Begin
    If (DocHed In SalesSplit) then
      LNum:=OrdUSRunNo-Ord(AutoOn)-(2*Ord(Posted))
    else
      LNum:=OrdUPRunNo-Ord(AutoOn)-(2*Ord(Posted));
  end;

  Set_OrdRunNo:=Lnum;

end; {Func..}

{ ====== Procedure to Setup New Doc with Folio Etc ======= }

Function Set_ExDoc(ImpVariance  :  Real)  :  Integer;
Var
  TmpS  :  Str20;

Begin
  TmpS:='';
  Result:=0;

  With Inv do
  Begin
    {* Closed on 16.11.98 to use the new SetNextDocNos fumction ...*}
    (*
    If (ExSyss.OverWORef) then
    Begin
      Result:=FullDocNum(InvDocHed,BOn,DocLen,TmpS);
      If (Result=0) then
        OurRef:=TmpS;
    end; {if..}

    If (Result=0) then
    Begin
      If (Not (InvDocHed In QuotesSet+PSOPSet+StkAdjSplit)) then
        Result:=GetNextCount(FOL,BOn,BOff,0,FolioNum)
      else
        Result:=GetNextCount(AFL,BOn,BOff,0,FolioNum);
    end; {if..}
    *)

    {* Get next OurRef and FolioNum, If ExSyss.OverWORef is OFF, just get the Folio No only *}
    SetNextDocNos(Inv,BOn,ExSyss.OverWORef);

    If (InvDocHed In SalesSplit+PurchSplit) then
      CustSupp:=TradeCode[(InvdocHed In SalesSplit)];

    If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
      CustSupp:=Chr(Succ(Ord(CustSupp)));

    RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);
    NLineCount:=1;
    ExternalDoc:=Not ExSyss.AllowEdit;
    NomAuto:=BOn; {* Non Autodaybook item *}

    If (InvDocHed In DirectSet) then
    Begin
      TotalInvoiced:=ConvCurrITotal(Inv,BOff,BOn,BOn);

      Settled:=TotalInvoiced*DocCnst[InvDocHed]*DocNotCnst;

      CurrSettled:=ITotal(Inv)*DocCnst[InvDocHed]*DocNotCnst;  {**** Full Currency Value Settled ****}

      CXRate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      
    end
    else
      If (InvDocHed In RecieptSet) then
      Begin
        TotalInvoiced:=ConvCurrITotal(Inv,BOff,BOn,BOn);

        TotalOrdered:=ConvCurrITotal(Inv,BOff,BOn,BOff);

        If (ExSyss.MCMode) then
        Begin
          TotalReserved:=ImpVariance;
          Variance:=ImpVariance;
        end;
      end;
  end; {With..}

end; {Proc..}


(*
{ =======  Routine to collect all invoice lines ===== }

Function Update_Stock(FolioN  :  Longint;
                      Fnum,
                      Keypath :  Integer)  :  Integer;
Var
  KeyS,
  KeyChk  :  Str255;
Begin
  KeyS:=FullNomKey(FolioN);
  KeyChk:=KeyS;
  Result:=0;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Result=0) do
  With Id do
  Begin
    If (Not EmptyKey(StockCode,StkLen)) and (StockCode[1]<>PayInCode) then
    Begin

      {07.07.99 - Stock_Deduct(Id,BOn,BOn,0);}
      Stock_Deduct(Id,Inv,BOn,BOn,0);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Result:=Status;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}
end;
*)

{ ======= Function to Return Psuedo Delivery Date on Orders ====== }

Function QUO_DelDate(DocHed :  DocTypes;
                     DDate  :  LongDate)  :  Str15;


Begin

  QUO_DelDate:=DocCodes[DocHed]+DDate;

end; {Func..}

{ =============== Function Validate Trans Header ============ }

Function ValidTrans(ExInvRec :  TBatchThRec;
                    PL       :  POINTER;
                    SMode    :  SmallInt;
		    Mode     :  Byte)  :  Integer;
Var
  ECRec,
  ValidHed,
  ValidLines,
  ValidCheck,
  RepBo        :  Boolean;

  HedNet,
  HedVAT,
  HedVariance  :  Double;

  td,tm,ty     :  Word{Integer};
  VT	       :  VATType;
  TmpMode      :  SmallInt;

  OldInv       :  InvRec;  { 01.09.99 - to use for POR/SOR update }

Begin
  ValidHed:=BOn;
  ValidLines:=BOff;
  ValidCheck:=BOff;
  ECRec:=BOff;      { EC Account }

  {* Wins Import *}
  TmpMode:=SMode;  {* To Check for CheckMode *}
  SMode:=B_Insert;

  HedNet:=0;
  HedVAT:=0;
  HedVariance:=0;

  Result:=ExInvToInv(ExInvRec,SMode); {* Convert Inv Data *}

  {* ----- Start Validation ----- *}

  If (Result=0) then
  With Inv do
  Begin

    ValidCheck:=((Not ExSyss.CheckDupli)
               or (Not (CheckExsists(LJVar(YourRef,LogInLen),InvF,InvYrRefK))));

    GenSetError(ValidCheck,30200,Result,ValidHed);

    {* Add StkAdjSplit+TSTSplit *}
    ValidCheck:=(InvDocHed In SalesSplit+PurchSplit+NomSplit+StkAdjSplit+TSTSplit);

    GenSetError(ValidCheck,30201,Result,ValidHed);

    If ((ValidCheck) and (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit))) then
    Begin
      {* Account Code Check *}

      ValidCheck:=(CheckRecExsists(CustCode,CustF,CustCodeK));

      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[(InvDocHed In SalesSplit)]));

      GenSetError(ValidCheck,30202,Result,ValidHed);

      ECRec:=(ValidCheck) and (Cust.EECMember); { For SSDProcess Flag }

    end
    else
      CustCode:=LJVar('',AccLen);

    { ----------------------------------- }

    {* Check Employeee Code - for TSH trans. *}
    If  (InvDocHed In TSTSplit) then
    Begin
      ValidCheck:=CheckRecExsists(JARCode+JAECode+LJVar(BatchLink,AccLen),JMiscF,JMK);
      GenSetError(ValidCheck,30210,Result,ValidHed);
    end;
    { ---------------------------------- }
    { JobCode and AnalCode check for other Transaction Code - SIN, PIN etc..}

    If  ((Not (InvDocHed In TSTSplit)) and (Not ExSyss.JBIgnore)) then
    Begin
       ValidCheck:=(EmptyKey(DJobCode,JobCodeLen));

       If Not (ValidCheck) then
       Begin
         ValidCheck:=(CheckRecExsists(DJobCode,JobF,JobCodeK));
         GenSetError(ValidCheck,30211,Result,ValidHed);
       end;

       ValidCheck:=(EmptyKey(DJobAnal,JobCodeLen));

       If Not (ValidCheck) then
       Begin
         ValidCheck:=(CheckRecExsists(JARCode+JAACode+DJobAnal,JMiscF,JMK));
         GenSetError(ValidCheck,30212,Result,ValidHed);
       end;
    end;

    { ---------------------------------- }

    {* Check Date *}

    {Old}DateStr(TransDate,Td,Tm,Ty);

    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

    GenSetError(ValidCheck,30203,Result,ValidHed);

    {* Check Period/Yr *}

    If (ValidCheck) and (ExSyss.AutoSetPr) then
    Begin
      AcPr:=Fin_Pr(TransDate);
      AcYr:=TxlateYrVal(Fin_Yr(TransDate), BOn);
    end;

    ValidCheck:=((AcPr>=1) and (AcPr<=Syss.PrInYr));
    GenSetError(ValidCheck,30204,Result,ValidHed);

    ValidCheck:=((AcYr<>0));
    GenSetError(ValidCheck,30205,Result,ValidHed);


    {* Add Stk&TSTSplit *}
    If (ValidCheck) and (Not (InvDocHed In NomSplit+[SRC,PPY]+StkAdjSplit+TSTSplit)) then
    Begin
      {* Check Due Date *}

      { 01.07.99 - To calculate DueDate with Payment Terms }
      If (UpperCase(DueDate)=DueDateSwitch) then
        DueDate:=CalcDueDate(TransDate,Cust.PayTerms)
      else
      begin
        {Old }DateStr(DueDate,Td,Tm,Ty);

        ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

        If (Not ValidCheck) then
        begin
          DueDate:=TransDate;
          ValidCheck:=BOn;
        end;

      end; {if..}
    end; {if..}


    {* changed from 4 to 11 on 10.06.97 *}
    {* Rate11 to Rate 18 in v4.31 *}
    For VT:=Standard to Rate18 do
      HedVAT:=HedVAT+InvVATAnal[VT];

    {* Check VAT Split *}

    ValidCheck:=(Round(HedVAT)=Round(InvVAT));
    GenSetError(ValidCheck,30206,Result,ValidHed);

    {* Check Currency *}

    If (ExSyss.MCMode) then
    begin
      ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      {* 18.08.99 - Added to use Default Currency *}
      If (Not ValidCheck) then
      begin
        Currency:=ExSyss.DefCur;
        ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
      end;
    end
    else
      ValidCheck:=BOn;

    GenSetError(ValidCheck,30207,Result,ValidHed);

    If (ExSyss.MCMode) then {* Check Currency Rates *}
    Begin

     {* 06.01.99 - Added this condition when Euro conversion was tested
                    with EL's advice *}
      If (ExSyss.UseExCrRate) then {* OverWrite Currency Rates *}
      begin
        CXrate:=SyssCurr^.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

      {* 01.04.99 - Ent. v4.30a validates these fields *}
      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;
      OrigRates:=SyssCurr^.Currencies[Currency].CRates;

      ValidCheck:=(CXRate[BOn]<>0);
      GenSetError(ValidCheck,30208,Result,ValidHed);

      If (Not UseCoDayRate) then
      Begin
	ValidCheck:=(CXRate[BOff]<>0);
        GenSetError(ValidCheck,30209,Result,ValidHed);
      end;

      If (Not (Inv.InvDocHed In NomSplit)) then
      begin
        CXRate[BOff]:=0;  {* Set to 0 eventualy regardless of stored value, as always left floating *}
        SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
      end;

    end
    else
    Begin
      Currency:=0;
      CXrate:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }
    end;

    {* Debtor/Creditor Control Nominal Code  *}
    If (CtrlNom<>0) then
    begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(CtrlNom)),NomF,NomCodeK));

      ValidCheck:=((ValidCheck) and (Nom.NomType In [CtrlNHCode])
                    and (CtrlNom<>Syss.NomCtrlCodes[Debtors])
                    and (CtrlNom<>Syss.NomCtrlCodes[Creditors]));

      GenSetError(ValidCheck,30213,Result,ValidHed);
    end
    else
    begin
      ValidCheck:=(CheckRecExsists(CustCode,CustF,CustCodeK));
      If (ValidCheck) and (Cust.DefCtrlNom<>0) then
      begin
        CtrlNom:=Cust.DefCtrlNom;
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(CtrlNom)),NomF,NomCodeK));

        ValidCheck:=((ValidCheck) and (Nom.NomType In [CtrlNHCode])
                      and (CtrlNom<>Syss.NomCtrlCodes[Debtors])
                      and (CtrlNom<>Syss.NomCtrlCodes[Creditors]));
        GenSetError(ValidCheck,30214,Result,ValidHed);

        {* 05.01.99 - 30215 is for TransDocHed Validation *}
      end;

    end; {if ..}

    {* Ver 4.31 validation *}
    {* Check SSDProcess *}
    ValidCheck:=BOn;
    If (ECRec) then
      ValidCheck:=(SSDProcess In [#0,#32,'T','P'])
    else
      SSDProcess:=#32;
    GenSetError(ValidCheck,30216,Result,ValidHed);



    {* ----- End of Validation ----- *}

    If (Result=0) then
    Begin
      {* Added on 06/05/98 *}

      If (Inv.InvDocHed In OrderSet) then
          Inv.BatchLink:=QUO_DelDate(Inv.InvDocHed,Inv.DueDate);

      {* Mode=0 Trans Lines Validation only *}
      Result:=Validate_Lines(0,ILineCount,HedVariance,PL);

      {* Add new record *}
      If ((Result=0) and (Mode=1) and (TmpMode<>CheckMode)) then
      Begin

	Result:=Set_ExDoc(HedVariance);

        If (Result=0) then
          Result:=(Validate_Lines(1,ILineCount,HedVariance,PL));

        If (Result=0) then
	  Result:=Store_ExDoc;

	If (Result<>0) then {* Scrap Lines *}
	  DeleteLinks(FullNomKey(FolioNum),IdetailF,Length(FullNomKey(FolioNum)),IdFolioK,BOff)
        else
          {* Add TSTSplit, OrderSet & QuotesSet on 01.09.99 *}
          If (ExSyss.UpAccBal) and
             (Not (InvDocHed In NomSplit+StkAdjSplit+TSTSplit+OrderSet+QuotesSet)) then
          begin
            Result:=UpdateExBal(Inv,(ConvCurrITotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                    (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                    (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                    BOff,2);


          end; {if..}

          FillChar(OldInv,sizeOf(OldInv),#0); {This won't be used, Just to pass the parameter  }
          {* To update Total Order Outstanding for [SOR,POR,SDN,PDN] *}
          If (InvDocHed In PSOPSet) then
            UpdateCustOrdBal(OldInv,Inv);

      end; {if result=0 and mode=1..}
    end; {if result=0 ..}
  end; {If Record Converted Ok..}

end; {Proc..}

{* ========== Store Transaction ============ *}

FUNCTION EX_STORETRANS(P,
                       PL         :  POINTER;
                       PSIZE,                     {* Size of TH *}
                       PLSIZE     :  LONGINT;     {* Size of TLs *}
                       SEARCHPATH :  SMALLINT;
                       SEARCHMODE :  SMALLINT)  :  SMALLINT;

Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  ValidCheck :  WordBool;
  TestResult :  SmallInt;

Begin

  If TestMode Then Begin
    ExInvRec:=P;
    ShowMessage ('Ex_StoreTrans: ' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  TestResult:=0;
  TestResult:=32767;

  If (P<>Nil) and (PL<>Nil) and (PSize=Sizeof(TBatchTHRec)) then
  Begin
    ExInvRec:=P;

    ValidCheck:=True;  {* check No. of TLs *}

    ValidCheck:=(ExInvRec^.LineCount<=(PLSize div SizeOf(TBatchTLRec)));

    If (ValidCheck) then
    begin
      {TestResult:=ValidTrans(ExInvRec^,PL,B_Insert,1)}
      TestResult:=ValidTrans(ExInvRec^,PL,SearchMode,1);

      {* 07.07.99 - added this to return OurRef, Folio number etc.. *}
      If (TestResult=0) then
        InvToExInv(ExInvRec^);
    end
    else
      TestResult:=32765; {* TLs record size incorrect *}

  end
  else
    If ((P<>Nil) or (PL<>Nil)) then
      TestResult:=32766;

  Ex_StoreTrans:=TestResult;

end; {Func..}


{ ============ Function to Return Next Transaction Number =========== }

FUNCTION EX_GETNEXTTRANSNO(DOCSTR   :  PCHAR;
                           NEXTNO   :  PCHAR;
                           UPDATE   :  WORDBOOL)  :  SMALLINT;
Var
  KeyS     :  Str20;
  DT       :  DocTypes;
  LockStr  :  Str255;
  i : integer;
  Found : boolean;
Begin
  If TestMode Then
  begin
    If Update Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetNextTransNo:' + #10#13 +
                 'DocStr: ' + StrPas(DocStr) + #10#13 +
                 'NextNo: ' + StrPas(NextNo) + #10#13 +
                 'Update: ' + LockStr);

  end;

  KeyS:=StrPas(DocStr);
  Found := false;
  for i := 1 to EBUSINESS_COUNTERS do
    Found := Found or (DocStr = EBUSINESS_DOCS[i]);

  if not Found then
    Result:=GetDocType(KeyS,DT)
  else
    Result := 0;

  If (Result=0) then
  Begin
    if Found then
      Result := FullEBisDocNum(string(DOCSTR),Update,DocLen,KeyS)
    else
      Result := FullDocNum(DT,Update,DocLen,KeyS);
    StrPCopy(NextNo,KeyS);
  end;
end;


FUNCTION EX_TESTSTK(SEARCHKEY      :  PCHAR;
                    SEARCHPATH     :  SMALLINT;
                    SEARCHMODE     :  SMALLINT;
                    LOCK           :  WORDBOOL)  :  SMALLINT;

Const
  Fnum     =  StockF;
  Keypath  =  StkCodeK;

Var
  KeyS       :  Str255;
  Locked     :  Boolean;
Begin
  Locked:=BOff;
  Begin
    KeyS:=StrPas(SearchKey);
    Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

    If (Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
        Result:=0;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
    {$ENDIF}
    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
    Begin
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
      Result:=Status;
    end;

  end; {If .. Not assigned}

end; {Func..}


{* ========== Get Total Trans. Lines ========== *}

FUNCTION EX_GETTOTALTRANSLINES(DOCREF : PCHAR) : LONGINT;
const
  Fnum    = InvF;
  KeyPath = InvOurRefK;
var
  KeyS      : Str255;
  CheckOK   : WordBool;
  TmpRecAddr,
  NoRecs    : LongInt;

  TmpStat,
  TmpKPath
            :  Integer;
  TmpFn     :  FileVar;



begin
  If TestMode Then
    ShowMessage ('Ex_GetTotalTransLines:' + #10#13 +
                 'DocStr: ' + StrPas(DocRef));

  TmpFn:=F[Fnum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);

  NoRecs:=0;

  KeyS:=StrPas(DocRef);
  KeyS:=LJVar(KeyS,DocLen);

  Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  If (Result=0) then
  begin
    {NoRecs:=Inv.ILineCount;}
    NoRecs:=GetActualLineCount(Inv.FolioNum);
  end; {if..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

  Ex_GetTotalTransLines:=NoRecs;

end; {func..}


{* ========= Round Up ========== *}

FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                    DECIMALPLACES  :  SMALLINT)  :  DOUBLE;
Var
  TmpValue  :  Double;

begin
  TmpValue:=0;
  TmpValue:=Round_Up(InputValue,DecimalPlaces);
  EX_ROUNDUP:=TmpValue;
end;

{* ========= Get Transaction Header Only =========== *}

FUNCTION EX_GETTRANSHED(P              :  POINTER;
                        PSIZE          :  LONGINT;
                        SEARCHKEY      :  PCHAR;
                        SEARCHPATH     :  SMALLINT;
                        SEARCHMODE     :  SMALLINT;
                        LOCK           :  WORDBOOL) : SMALLINT;

Const
  KeyXlate  :  Array[0..10] of Integer =
               (InvOurRefK,InvFolioK,InvCustK,InvYrRefK,InvLYRefK,
                InvRNoK,InvCDueK,InvVATK,InvBatchK,InvDateK,InvYrPrK );

Var
  ExInvRec  :  ^TBatchTHRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;

Begin
  If TestMode Then
  Begin
    ExInvRec:=P;
    If Lock Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetTransHed:' + #10#13 +
                 'P^.OurRef: ' + ExInvRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (P<>Nil) and (PSize=Sizeof(TBatchTHRec)) then
  Begin
    If (Not (SearchPath In [0..10])) then
      SearchPath:=0;

    KeyS:=StrPas(SearchKey);
    ExInvRec:=P;
    Blank(ExInvRec^,Sizeof(ExInvRec^));

    Result:=Find_Rec(SearchMode,F[InvF],InvF,RecPtr[InvF]^,KeyXLate[SearchPath],KeyS);

    If (Lock) and (Result=0) then Begin {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyXLate[SearchPath],InvF,SilentLock,Locked)) then
        Result:=0
      Else
        { HM 05/02/98: Added Else clause as it would still return 0 if lock failed }
        Result := 84;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyXLate[SearchPath],InvF,SilentLock,Locked));
    {$ENDIF}
    End;
    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
    Begin

      InvToExInv(ExInvRec^);

    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

end; {Func..}

{* ========= Get A Transaction Line =========== *}

FUNCTION EX_GETTRANSLINE(PLINE          :  POINTER;
                         PLSIZE         :  LONGINT;
                         SEARCHKEY      :  PCHAR;
                         SEARCHPATH     :  SMALLINT;
                         SEARCHMODE     :  SMALLINT;
                         LOCK           :  WORDBOOL) : SMALLINT;


Const
  KeyXlate  :  Array[0..4] of Integer =
               (IdFolioK, IdRunK, IdNomK, IdStkK, IdAnalK);


Var
  ExIdRec    :  ^TBatchTLRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;

Begin
  If TestMode Then Begin
    ExIdRec:=PLine;
    If Lock Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetTransLine:' + #10#13 +
                 'PLSize: ' + IntToStr(PLSize) + #10#13 +
                 'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (PLine<>Nil) and (PLSize=Sizeof(TBatchTLRec)) then
  Begin
    If (Not (SearchPath In [0..4])) then
      SearchPath:=0;

    KeyS:=StrPas(SearchKey);

    ExIdRec:=PLine;
    Blank(ExIdRec^,Sizeof(ExIdRec^));

    Result:=Find_Rec(SearchMode,F[IdetailF],IdetailF,RecPtr[IdetailF]^,KeyXLate[SearchPath],KeyS);

    If (Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyXLate[SearchPath],IdetailF,SilentLock,Locked)) then
        Result:=0;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyXLate[SearchPath],IdetailF,SilentLock,Locked));
    {$ENDIF}
    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
    Begin
      IdToExId(ExIdRec^);
      ExIdRec^.TransRefNo:='';  {* 02.09.99 - not to return OurRef *}
    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If (PLine<>Nil) then
      Result:=32766;

end; {Func..}


{* ============ Convert Folio No from LongInt to String =========== *}

FUNCTION EX_CONVERTFOLIO(FOLIONUMBER  :  LONGINT)  :  SHORTSTRING;
var
  GenStr  :  Str255;
begin

  GenStr:=FullNomKey(FolioNumber);

  EX_CONVERTFOLIO:=GenStr;

end; {Func..}


FUNCTION EX_GETTLLINE(FOLIONUMBER,
                      LINENUMBER  :  LONGINT;
                      PLINE       :  POINTER;
                      PLSIZE      :  LONGINT)  :  SMALLINT;
Const
  Fnum     =  IDetailF;
  KeyPath  =  IdFolioK;

Var
  TmpTL   :  ^TBatchTLRec;
  KeyF    :  Str255;

begin
  Result:=32767;
  TmpTL:=PLine;

  If (PLine<>Nil) and (PLSize=Sizeof(TBatchTLRec)) then
  Begin

    KeyF:=FullidKey(FolioNumber,LineNumber);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyF);

    Result:=Status;

    If (Status=0) then
    begin
      IdToExId(TmpTL^);
      TmpTL^.TransRefNo:='';  {* 20.10.99 - not to return OurRef *}
    end;

  end {if..}
  else
    If (PLine<>Nil) then
      Result:=32766;

end; {func..}


FUNCTION EX_GETTHBYFOLIO(FOLIONUMBER :  LONGINT;
                         P           :  POINTER;
                         PSIZE       :  LONGINT)  :  SMALLINT;
Const
  Fnum   =  InvF;
  KPath  =  InvFolioK;

Var
  ExInvRec  :  ^TBatchTHRec;
  KeyS       :  Str255;

  ValidCheck,
  Locked     :  Boolean;
  LockStr    :  String[255];

Begin
  If TestMode Then
  Begin
    ExInvRec:=P;
    ShowMessage ('Ex_GetTHByFolio : ' + #10#13 +
                 'Folio No. : '+ IntToStr(FolioNumber)+ #10#13+
                 'PSize : ' + IntToStr(PSize));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchTHRec)) then
  Begin

    KeyS:=FullNomKey(FolioNumber);
    ExInvRec:=P;
    Blank(ExInvRec^,Sizeof(ExInvRec^));

    Result:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,KPath,KeyS);

    If (Result=0) then
    Begin
      InvToExInv(ExInvRec^);
    end; {if Result=0 ..}

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

end; {Func..}


{* This function was for internal usage *}
Function Ex_GetRecAddress(FileNum  :  SmallInt)  :  LongInt;
var
  TmpAddr  :  LongInt;
begin
  TmpAddr:=0;

  GetPos(F[FileNum],FileNum,TmpAddr);
  Ex_GetRecAddress:=TmpAddr;
end;  {func..}

{* Need to validate file number, otherwise, get Range Check Error *}

Function Ex_GetRecordAddress(    FileNum     :  SmallInt;
                             Var RecAddress  :  LongInt)  :  SmallInt;
Var
  ExStat      :  Integer;
  ValidHed,
  ValidCheck  :  Boolean;
  TAddr       :  LongInt;

begin
  ExStat:=0;
  Result:=0;
  RecAddress:=0;
  TAddr:=0;

  ValidHed:=BOff;
  ValidCheck:=(FileNum In [1..5,8,9,11]);

  { Invalid File No. }
  GenSetError(ValidCheck,30001,ExStat,ValidHed);

  If (ValidCheck) then
  begin
    ExStat:=GetPos(F[FileNum],FileNum,TAddr);
    If (ExStat=0) then
      RecAddress:=TAddr;
    ValidCheck:=(ExStat=0);
    GenSetError(ValidCheck,30002,ExStat,ValidHed);

  end; {if..}

  Ex_GetRecordAddress:=ExStat;

end; {func..}

Function Ex_GetRecWithAddress(FileNum,
                              KeyPath  :  SmallInt;
                              TRecAddr :  LongInt )  :  SmallInt;
var
  ExStat  :  Integer;
  ValidHed,
  ValidCheck  :  Boolean;

begin
  ExStat:=0;

  ValidHed:=BOff;
  ValidCheck:=(FileNum In [1..5,8,9,11]);

  { Invalid File No. }
  GenSetError(ValidCheck,30001,ExStat,ValidHed);

  Case FileNum of
    CustF    :  Move(TRecAddr,Cust,SizeOf(TRecAddr));
    InvF     :  Move(TRecAddr,Inv,SizeOf(TRecAddr));
    IDetailF :  Move(TRecAddr,Id,SizeOf(TRecAddr));
    NomF     :  Move(TRecAddr,Nom,SizeOf(TRecAddr));
    StockF   :  Move(TRecAddr,Stock,SizeOf(TRecAddr));
    PWrdF    :  Move(TRecAddr,PassWord,SizeOf(TRecAddr));
    MiscF    :  Move(TRecAddr,MiscRecs^,SizeOf(TRecAddr));
    JobF     :  Move(TRecAddr,JobRec^,SizeOf(TRecAddr));
  end; {case..}

  If (ExStat=0) then
  begin
    ExStat:=GetDirect(F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,0);
    ValidCheck:=(ExStat=0);
    GenSetError(ValidCheck,30002,ExStat,ValidHed);
  end; {if..}

  Ex_GetRecWithAddress:=ExStat;
end;  {func..}



{ HM 23/12/97: Function added for EL }
FUNCTION EX_GETTHBYRUNNO(P          :  POINTER;
                         PSIZE      :  LONGINT;
                         RUNNO      :  LONGINT;
                         SEARCHMODE :  SMALLINT;
                         LOCK       :  WORDBOOL) : SMALLINT;
Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  String[255];

  TmpVal     :  LongInt;
  SearchPath : Integer;

Begin
  If TestMode Then
  Begin
    ExInvRec:=P;
    If Lock Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('EX_GETTHBYRUNNO:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'RunNo: ' + IntToStr(RunNo) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  { Check record size is correct }
  If (P<>Nil) and (PSize=Sizeof(TBatchTHRec)) Then Begin
    { Always use Run Number key }
    SearchPath:=InvRNoK;

    ExInvRec:=P;

    If (SearchMode = B_GetEq) Then
      { Build full key for passed in record }
      KeyS:=FullNomKey(ExInvRec^.RunNo) + ExInvRec^.OurRef[1] + FullnomKey(ExInvRec^.FolioNum)
    Else
      { build key from specified run number }
      KeyS:=FullnomKey(RunNo);

    Blank(ExInvRec^,Sizeof(ExInvRec^));

    Result:=Find_Rec(SearchMode,F[InvF],InvF,RecPtr[InvF]^,SearchPath,KeyS);

    If (Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,InvF,SilentLock,Locked)) then
        Result:=0;
    {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,InvF,SilentLock,Locked));
    {$ENDIF}

    If (Result=0) then Begin
      InvToExInv(ExInvRec^)
    end; {if Result=0 ..}
  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

end; {Func..}


{ HM 24/12/97: Added for EL }
{ Stores a Transaction Header - use with caution as no validation or update of totals, stock, balances, etc }
{}
{ HM 12/11/99: Removed EX_ from function name and changed password from }
{              61298341 because developers were using the function      }
FUNCTION STORETH(P          :  POINTER;
                 PSIZE      :  SMALLINT;             {* Size of TH *}
                 SEARCHPATH :  SMALLINT;
                 UPDATEMODE :  SMALLINT;
                 AUTHCODE   :  LONGINT)  :  SMALLINT;
Const
  FNum = InvF;
Var
  ExInvRec   :  ^TBatchTHRec;
  KeyS       :  Str255;
  ValidCheck :  WordBool;
  TestResult :  SmallInt;
  KeyPath    :  Integer;
Begin
  If TestMode Then Begin
    ExInvRec:=P;
    ShowMessage ('Ex_StoreTH: ' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'UpdateMode: ' + IntToStr(UpdateMode));
  End; { If }

  TestResult:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchTHRec)) And (AuthCode = 90812966) Then Begin
    { Convert pointer to TH handle }
    ExInvRec:=P;

    If (UpdateMode = B_Insert) Or (UpdateMode = B_Update) Then Begin
      { Copy invoice into Inv }
      TestResult := ExInvToInv(ExInvRec^,-UpdateMode); {* Convert Inv Data *}

      If (TestResult = 0) Then Begin
        KeyPath := SearchPath;
        If (UpdateMode = B_Insert) Then
          { Insert new transaction }
          TestResult := Add_Rec (F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath)
        Else
          { Update current transaction }
          TestResult := Put_Rec (F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);
      End; { If }
    End { If }
    Else
      TestResult := 32765;
  End
  Else
    If (P<>Nil) then
      TestResult:=32766;

  Result := TestResult;
end; {Func..}


{* ----- Convert Amount from one Currency to another ----- *}

FUNCTION EX_CONVERTAMOUNT(FROMCURR   :  SMALLINT;
                          TOCURR     :  SMALLINT;
                      VAR AMOUNT     :  DOUBLE;
                          RATETYPE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}

var
  ValidHed,
  ValidCheck,
  CoDayRate  :  Boolean;

  TResult    :  Integer;

begin
  ValidHed:=BOn;
  ValidCheck:=BOff;
  TResult:=0;

  { Check for different currency and Amount <>0 }
  ValidCheck:=((FromCurr<>ToCurr) and (Amount<>0));
  GenSetError(ValidCheck,30100,TResult,ValidHed);

  { Check From Currency }
  ValidCheck:=(FromCurr>=0) and (FromCurr<=30);
  GenSetError(ValidCheck,30101,TResult,ValidHed);

  { Check To Currency }
  ValidCheck:=(ToCurr>=0) and (ToCurr<=30);
  GenSetError(ValidCheck,30102,TResult,ValidHed);

  ValidCheck:=(RateType In [0..2]);
  GenSetError(ValidCheck,30103,TResult,ValidHed);

  If (ValidCheck) then
  begin
    Case RateType of
      0 :  CoDayRate:=(Syss.TotalConv=XDayCode);  {System Rate}
      1 :  CoDayRate:=BOn;   {Daily Rate}
      2 :  CoDayRate:=BOff;  {Company Rate}
    end; {Case..}
  end; {if..}

  If (TResult=0) then
    Amount:=Round_Up(Currency_ConvFT(Amount,FromCurr,ToCurr,CoDayRate),2);

  Ex_ConvertAmount:=TResult;

end; {func..}

{//------------------------------------------------------------------------------}

FUNCTION EX_STORETRANSHED(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
{ Pre    : P = Pointer to record of type TBatchTHRec
          PSize = Size of passed record structure
 Action : Searches for the transaction record that matches P
          If found updates the user defined fields only
}
const
  FNum = InvF;
var
  KeyNum : integer;
  RecPos : longint;
  SavedPosOK,
  Locked : boolean;
  HeaderRec : ^TBatchTHRec;
  KeyS : str255;
  THoldFlag  :  SmallInt;

begin
  HeaderRec := P;

  if TestMode then
    ShowMessage ('Ex_StoreTransHed:' + #10#13 +
                 'P^.OurRef: ' + HeaderRec^.OurRef + #10#13 +
                 'PSize: ' + IntToStr(PSize));

  if not Assigned(P) then
  begin
    Result := 32767;
    exit;
  end;

  if PSize <> SizeOf(TBatchTHRec) then
  begin
    Result := 32766;
    exit;
  end;

  { Save the current position in the transaction header file }
  KeyNum := GetPosKey;
  SavedPosOK := Presrv_BTPos(FNum, KeyNum, F[FNum], RecPos, false, false) = 0;

  { Find and update the transaction header record }
  KeyS := FullNomKey(HeaderRec^.RunNo) + HeaderRec^.OurRef[1] + FullNomKey(HeaderRec^.FolioNum);
  Result := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  if Result = 0 then { Attempt to lock record }
  {$IFDEF WIN32}
  if (GetMultiRec(B_GetDirect, B_SingLock, KeyS, 0, FNum, SilentLock, Locked)) then
    Result := 0
  else
    Result := 84;
  {$ELSE}
  Result := (GetMultiRec(B_GetDirect, B_SingLock, KeyS, 0, FNum, SilentLock, Locked));
  {$ENDIF}

  if Result = 0 then
    with Inv do
    begin
      DocUser1 := HeaderRec^.DocUser1;
      DocUser2 := HeaderRec^.DocUser2;
      {
      1	hold for query
      2	hold until allocated
      3	Hold Authorised
      4	Hold order lines until all line stock available
      5	Hold order until all stock available for all lines
      6	Hold until credit cleared
      +32	Doc has notes
      +128	Suspend posting.
      }

      THoldFlag:=HeaderRec^.HoldFlg;
      { Copy from customerisation help }
      { New Hold Mode +(HoldFlg AND 128) + (HoldFlg AND 32) }
      If (THoldFlag<>HoldFlg) and (THoldFlag In [0..6]) then
        HoldFlg  := THoldFlag + (HoldFlg and 128) + (HoldFlg and 32);
        {HoldFlg  := (HeaderRec^.HoldFlg) and (128) and (32);}

      Tagged:=HeaderRec^.Tagged;  {20.10.99 - request by NZ }

      Result := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
    end;

  { Return to the original position in the transaction header file }
  if SavedPosOK then
    Presrv_BTPos(InvF, KeyNum, F[FNum], RecPos, true, false);
end; { Ex_StoreTransHed }

{------------------------------------------------------------------------------}

function EX_GETLINETOTAL(P      : POINTER;
                         PSIZE  : SMALLINT;
                         USEDISCOUNT : WORDBOOL;
                         SETTLEDISC : DOUBLE;
                         VAR LINETOTAL : DOUBLE): SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
var
  LineRec : ^TBatchTLRec;
  UseDiscStr : string;
begin
  LineRec := P;
  if UseDiscount then UseDiscStr := 'true' else UseDiscStr := 'false';

  if TestMode then
    ShowMessage ('Ex_GetLineTotal:' + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'UseDiscount: ' + UseDiscStr + #10#13 +
                 'SettleDisc: ' + FloatToStr(SettleDisc));

  if not Assigned(P) then
  begin
    Result := 32767;
    exit;
  end;

  if PSize <> SizeOf(TBatchTLRec) then
  begin
    Result := 32766;
    exit;
  end;

  Result := ExInvLineToId(LineRec^);
  if Result = 0 then
    try
      LineTotal := InvLTotal(ID, UseDiscount, SettleDisc);
    except
      on EOverFlow do
      begin
        LineTotal := 0.0;
        Result := 32000; // Error code for overflow which has been trapped
      end;
    end;
end; { EX_GETLINETOTAL }

{------------------------------------------------------------------------------}

Procedure EX_SETCALCLINECOUNT(WantCount : WordBool);
Begin { EX_SETCALCLINECOUNT }
  WantCalcLineCount := WantCount;
End; { EX_SETCALCLINECOUNT }

{------------------------------------------------------------------------------}

begin
  WantCalcLineCount := True;
end. {DLLTH01U..}


(*
'SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT','SDG','NDG','OVT','DEB',
'I'  ,'X'  ,'I'  ,'I'  ,'I'  ,'I'  ,'I'  ,'Q'  ,'O'  ,'I'  ,'I'  ,'S'  ,'X'  ,'X'  ,'X'  ,

'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT','SDT','NDT','IVT','CRE',
'N'  ,'X'  ,'N'  ,'N'  ,'N'  ,'N'  ,'N'  ,'U'  ,'R'  ,'N'  ,'N'  ,'P'  ,'X'  ,'X'  ,'X'  ,

'NOM','RUN','FOL','AFL','ADC','ADJ','ACQ','API','SKF','JBF','WOR','TSH','JRN'
'X'  ,'X'  ,'X'  ,'X'  ,'X'  ,'A'  ,'X'  ,'X'  ,'X'  ,'X'  ,'W'  ,'T'  ,'X'

'I','X','I','I','I','I','I','Q','O','I','I','S','X','X','X',
'N','X','N','N','N','N','N','U','R','N','N','P','X','X','X',
'X','X','X','X','X','A','X','X','X','X','W','T','X'

Type	Document Type
------	---------------------
"I"	SIN,SCR,SJI,SJC,SRF,SRI,SDN
"N"	PIN,PCR,PJI,PJC,PRF,PPI,PDN
"X" 	SRC,PPY,NOM
"Q"	SQU
"O"	SOR
"U"	PQU
"R"	POR
"A"	ADJ

*)

