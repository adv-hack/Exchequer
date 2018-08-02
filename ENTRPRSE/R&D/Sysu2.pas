Unit SysU2;

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 15/09/92                      }
{                                                              }
{                   System Controller Unit II                  }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,VarRec2U,VarConst ;

{$I DEFOVR.INC}

Function PPR_PamountStr(Discount  :  Real;
                        DiscCh    :  Char)  :  String;


Procedure  ProcessInputPAmount(Var  Discount  :  Real;
                               Var  DiscCh    :  Char;
                              Const InpStr    :  Str255);

Procedure  ProcessInputDPAmount(Var  Discount  :  Double;
                                Var  DiscCh    :  Char;
                               Const InpStr    :  Str255);

Procedure Put_NextChequeNo(NewVal     :  Str80;
                           Increment  :  Boolean);

Function Get_NextChequeNo(Increment  :  Boolean)  :  Str80;


Procedure Add_2PrintQ(QCode   :  Str10;
                      QMode,
                      PrNo    :  Byte);



Procedure SetCurrInclude(Var  CurrInclude  :  CurrChangeSet;
                              OldSyssCurr  :  CurrRec);


Procedure Re_SetDocTots(Var InvR     :  InvRec;
                            RSetVat  :  Boolean);

Procedure Re_SetDoc(Var InvR  :  InvRec);

Function TrigEquiv(CrStat  :  Integer)  :  Byte;


Procedure Set_PrintedStatus(ToPrinter,
                            AlsoPicked:  Boolean;
                            InvR     :  InvRec);

Function Autho_Need(AuthCode  :  Char)  : Boolean;

Function Autho_Doc(InvR  :  InvRec)  :  Boolean;


Function Show_AccStatus(AccMode  :  Byte)  :  Str20;

Function Show_EmpStatus(aStatus: TEmployeeStatus): Str20;

Function UseDebtWeeks(I  :  Integer)  :  Boolean;

Function CalcWksODue(OdDate  :  LongDate)  :  Integer;

Function Calc_AltStkHCode(NType  :  Char)  :  Char;

Function Rev_AltStkHCode(NType  :  Char)  :  Char;

Function Access_HotCust(CMode  :  Boolean)  :  Boolean;


Procedure Add_DocEditNow(DocFolio  :  LongInt);

Function Found_DocEditNow(DocFolio  :  LongInt)  :  Integer;

Procedure Delete_DocEditNow(DocFolio  :  LongInt);

Procedure Add_StkEditNow(DocFolio  :  LongInt);

Function Found_StkEditNow(DocFolio  :  LongInt)  :  Integer;

Procedure Delete_StkEditNow(DocFolio  :  LongInt);


Function Check_AccountEdit(AcCode  :  Str10)  :  Boolean;


Procedure GetPostMode(Mode  :  Byte;
                  Var PSet  :  DocSetType);

Function Check4PostLine(InvR  :  InvRec)  :  Byte;

{$IFDEF PF_On}

  Function Has_CCWildChar(WStr  :  Str255)  :  Boolean;

{$ENDIF}

Function Correct_PVAT(PVAT,CVAT  :  Char)  :  Char;

{$IFDEF STK}

  Function FreeStock(StockR  :  StockRec) :  Real;

  Function AllocStock(StockR  :  StockRec) :  Double;

  Function WOPAllocStock(StockR  :  StockRec) :  Double;

  

  Function Stock_GP(Cost,Sales,BQty,SQty  :  Real;
                    Mode                  :  Byte;
                    UP                    :  Boolean)  :  Real;

  Function MakeStock_GP(Cost,MU,SQty  :  Real;
                        Mode          :  Byte;
                        UP            :  Boolean)  :  Real;

  Procedure Update_UpChange(NewNeed  :  Boolean);

  Function Qty_OS(IdR  :  IDetail)  :  Real;

  Function BuildQty_OS(IdR  :  IDetail) :  Double;

  Function WORReqQty(IdR  :  IDetail) :  Double;

  Function CaseQty(StockR  :  StockRec;
                   SQ      :  Double) :  Double;

  Procedure SetE2CId(Var IdR     :  IDetail;
                         StockR  :  StockRec);

  Function  StkApplyMul(SL,QM  :  Double;
                        Switch :  Boolean)  :  Double;

  Function Set_OrdRunNo(DocHed   :  DocTypes;
                        AutoOn,
                        Posted   :  Boolean)  :  LongInt;

  Function SOP_GetSORNo(SOPLink  :  LongInt)  :  Str10;

  

  {$IFDEF WOP}
    Function Set_WOrdRunNo(DocHed   :  DocTypes;
                           AutoOn,
                           Posted   :  Boolean)  :  LongInt;
  {$ENDIF}


  Function RET_GetSORNo(SOPLink  :  LongInt)  :  Str10;


  {$IFDEF RET}

    Function Set_RetRunNo(DocHed   :  DocTypes;
                         AutoOn,
                         Posted   :  Boolean)  :  LongInt;

  {$ENDIF}


  Function SOP_QtyLink(SOPLink,
                       SOPLNo   :  LongInt;
                       Mode     :  Byte)  :  Real;


  Function CheckNegStk  :  Boolean;


  Function FIFO_Mode(CMode  :  Char)  :  Byte;

  Function SetStkVal(SV    :  Char; {*EN431ASN*}
                 Var SNAV  :  Byte;
                     Mode  :  Boolean)  :  Char;

  Function Is_FIFO(CMode  :  Char)  :  Boolean;

  Function Is_SERNO(CMode  :  Char)  :  Boolean;

  Function StkVM2I(VM  :  Char)  :  Integer;

  Function StkI2VM(I  :  Integer)  :  Char;

  Function StkI2PT(I  :  Integer)  :  Char;

  Function StkPT2I(VM  :  Char)  :  Integer;

  Function RevalueStk(NCode  :  LongInt)  :  Boolean;

  Procedure MakeObFIFOId(Var  IdR  :  IDetail;
                              CP   :  Real;
                              CrC  :  Byte;
                              Loc  :  Str10);


  {Function Set_WOrdRunNo(DocHed   :  DocTypes;
                         AutoOn,
                         Posted   :  Boolean)  :  LongInt;}



  
{$ENDIF}

{$IFDEF JC}
  {$IFDEF JAP}

    Function Set_JAPRunNo(DocHed   :  DocTypes;
                           AutoOn,
                           Posted   :  Boolean)  :  LongInt;
  {$ENDIF}
{$ENDIF}

Function Ea2Case(Idr     :  IDetail;
             Var StockR  :  StockRec;
                 CQ      :  Double)  :  Double;

Function Case2Ea(Idr     :  IDetail;
                 StockR  :  StockRec;
                 CQ      :  Double)  :  Double;



Function CCode2I(CC  :  Str5)  :  Integer;

Function I2CCode(CC  :  Integer)  :  Str5;

Function AMethod2I(CC  :  Char)  :  Integer;

Function I2AMethod(CC  :  Integer)  :  Char;

Function Is_STDWOP  :  Boolean;

Procedure SetEntryRec(PgNo    :  Byte;
                      PLogin  :  Str10;
                      LoadRec,
                      OverWER :  Boolean);

Procedure SetEntryRecVar(PgNo    :  Byte;
                         PLogin  :  Str10;
                         LoadRec,
                         OverWER :  Boolean;
                     Var ERec    :  EntryRecType);

Function GetLogInRec(LoginCode  :  Str20)  :  Boolean;

Procedure SetLoginParams;

Function  CheckParam(ChkStr,PStr  :  Str255;
                 Var DefStr       :  Str255)  :  Boolean;

Function Which_ExVerNo : LongInt;
Function Which_ExVers  :  Str10;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   BtrvU2,
   ETMiscU,
   ETStrU,
   ETDateU,
   {$IFDEF JC}
     VarJCstU,
   {$ENDIF}
   VarFPosU,
   ComnUnit,
   ComnU2,
   CurrncyU,
   PWarnU,
   SysU1,
   BTKeys1U,
   BTSupU1,
   Event1U;




 {$IFDEF CU}
   Var
      GenDiscMask  :  String;

      LDDBeenChecked
                   :  Boolean;

 {$ENDIF}


Function PPR_PamountStr(Discount  :  Real;
                        DiscCh    :  Char)  :  String;

{Const
  GenDiscMask='###,###,##0.0000 ;###,###,##0.0000-';}


Var
  GenStr       :  String;

  PDecs        :  LongInt;




Begin
  GenStr:=''; PDecs:=2;




  If (Discount=0) and (Not (DiscCh In StkBandSet)) then
    GenStr:=''
  else
  Begin
    If (DiscCh=PcntChr) then
      GenStr:=FormatFloat(GenPcnt2dMask,Discount*100)
    else
      If (DiscCh In StkBandSet) then
        GenStr:=DiscCh
      else
      Begin
        {$IFDEF CU}

           If (Not LDDBeenChecked ) then
           Begin
             PDecs:=Get_LineDiscDecs(2);
             LDDBeenChecked:=BOn;
             GenDiscMask:=FormatDecStr(PDecs,GenRealMask);
           end;

          GenStr:=FormatFloat(GenDiscMask,Discount);

        {$ELSE}

          GenStr:=FormatFloat(GenRealMask,Discount);

        {$ENDIF}

      end;
  end;

  PPR_PamountStr:=GenStr;
end; {Func..}





{ ====================== Input Special Discount Type ======================= }

Procedure  ProcessInputPAmount(Var  Discount  :  Real;
                               Var  DiscCh    :  Char;
                              Const InpStr    :  Str255);


Var
  SL        :  Byte;
  GenStr    :  Str255;
  WasStr    :  Str20;
  Rnum      :  Real48;
  Flg       :  Boolean;


Begin
  FillChar(GenStr,Sizeof(GenStr),0);

  GenStr:=UpCaseStr(Strip('B',['_',#32],InpStr));

  If (GenStr[1] In StkBandSet) and (GenStr<>'') then
  Begin
    DiscCh:=GenStr[1];

    GenStr:='';
  end
  else
    If (GenStr[Length(GenStr)]=PcntChr) or (Syss.DefPcDisc) and (GenStr<>'') then
    Begin
      GenStr:=Strip('B',[PCntChr],GenStr);
      DiscCh:=PcntChr;
    end
    else
      DiscCh:=C0;

  SL:=Length(GenStr);
  If (GenStr[SL]='-') then
  Begin
    Delete(GenStr,SL,1);
    GenStr:='-'+GenStr;
  end;

  If (DecimalSeparator<>'.') then {Allow for other decimal seperators in calculation}
  Begin
    Sl:=Pos(DecimalSeparator,GenStr);

    If (SL<>0) then
      GenStr[SL]:='.';

  end;

  StrReal(Strip('A',[',',#32],GenStr),Flg,Rnum);

  Discount:=Rnum;

  If (DiscCh=PcntChr) then
    Discount:=Pcnt(Discount);

end; {Proc..}


Procedure  ProcessInputDPAmount(Var  Discount  :  Double;
                                Var  DiscCh    :  Char;
                               Const InpStr    :  Str255);

Var
  R  :  Real;
  FD :  Boolean;

Begin

  R:=Discount;  FD:=Syss.DefPcDisc;

  Syss.DefPcDisc:=BOff;

  ProcessInputPAmount(R,DiscCh,InpStr);

  Discount:=R;

  Syss.DefPcDisc:=FD;
end;


{ ===== Procedure to increase next Cheque No. based on last number ===== }

Procedure Put_NextChequeNo(NewVal     :  Str80;
                           Increment  :  Boolean);


Var
  Key2F  :  Str255;
  TmpOk  :  Boolean;
  Lock   :  Boolean;
  TmpStatus
         :  Integer;
  LAddr,
  NewCnt
         :  LongInt;



Begin
  Lock:=BOff;  NewCnt:=0;

  NewCnt:=LIntStr(Strip('B',[#32],NewVal));

  If (NewCnt<>0) then
  Begin
    Blank(Key2F,Sizeof(Key2F));

    Key2F:=DocNosXlate[ACQ];

    TmpOk:=GetMultiRecAddr(B_GetEq,B_MultLock,Key2F,IncK,IncF,BOn,Lock,LAddr);

    If (TmpOk) and (Lock) then
    With Count do
    Begin
      If (Increment) then
        NewCnt:=NewCnt+IncxDocHed[ACQ];

      Move(NewCnt,NextCount[1],Sizeof(NewCnt));

      TmpStatus:=Put_Rec(F[IncF],IncF,RecPtr[IncF]^,IncK);

      Report_BError(IncF,TmpStatus);

      Status:=UnLockMultiSing(F[IncF],IncF,LAddr);

    end;
  end; {NewCnt not a avalue..}
end;


{ ===== Function to Return Next Cheque No. ====== }


Function Get_NextChequeNo(Increment  :  Boolean)  :  Str80;

Var
  TmpStr  :  Str80;

Begin

  TmpStr:=Form_BInt(GetNextCount(ACQ,Increment,BOff,0),0);

  If (Increment) then
    Put_NextChequeNo(TmpStr,BOn);

  Get_NextChequeNo:=TmpStr;

end; {Func..}




{ ================= Procedure to Add Item to Priont Queue =============== }

Procedure Add_2PrintQ(QCode   :  Str10;
                      QMode,
                      PrNo    :  Byte);


Const
  Fnum    =  NHistF;
  Keypath =  NHK;

Begin
  ResetRec(Fnum);

  If (Qcode<>'') and (PrNo<>0) then
  With NHist do
  Begin
    ExClass:=PQCode;
    Code:=QCode;
    Pr:=PrNo;

    Yr:=QMode;

    Cleared:=1;

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

  end; {With..}
end; {Proc..}



{ ======================== Routines to Facilitate the Re-Valuation of The Nominal =================== }


{ ======================== Procedure to Create a Set of Currencies to be changed ================== }

Procedure SetCurrInclude(Var  CurrInclude  :  CurrChangeSet;
                              OldSyssCurr  :  CurrRec);

Var
  n  :  Byte;

Begin
  Blank(CurrInclude,Sizeof(CurrInclude));

  For n:=CurStart to CurrencyType do
    If (OldSyssCurr.Currencies[n].CRates[BOff]<>SyssCurr.Currencies[n].CRates[BOff]) then
      CurrInclude:=CurrInclude+[n];

end;


Procedure Re_SetDocTots(Var InvR     :  InvRec;
                            RSetVat  :  Boolean);

Begin
  With InvR do
  Begin
    InvNetVal:=0;
    DiscAmount:=0;
    DiscSetAm:=0;

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    thPPDGoodsValue := 0.0;   // Goods Value of Discount (if taken) in Transaction Currency
    thPPDVATValue   := 0.0;   // VAT Value of Discount (if taken) in Transaction Currency

    { Disabled v4.20c, so orders and deliveries not reset
    DiscTaken:=BOff;
    DiscSetl:=0;}

    PostDiscAm:=0;
    PDiscTaken:=BOff;
    Settled:=0;
    Variance:=0;
    TotalReserved:=0;
    TotalInvoiced:=0;
    TotalOrdered:=0;
    TotalCost:=0;
    CurrSettled:=0;
    ReValueAdj:=0;

    If (RSetVat) then
    Begin

      InvVat:=0;
      Blank(InvVATAnal,Sizeof(InvVATAnal));

      ManVat:=BOff;

    end;

  end; {With..}
end; {Proc..}


{ ===================== Procedure to Re-Set Receipts ================== }

Procedure Re_SetDoc(Var InvR  :  InvRec);

Var
  KeyChk  :  Str255;

Begin
  With InvR do
  Begin

    Re_SetDocTots(InvR,BOn);

    {$IFDEF JAP}
      If (InvDocHed In JAPSplit) then
        KeyChk:=FullIdkey(InvR.FolioNum,JALRetLineNo)
      else
        KeyChk:=FullNomKey(FolioNum);

    {$ELSE}
      KeyChk:=FullNomKey(FolioNum);

    {$ENDIF}

    ChangeLinks(KeyChk,'Reset',IDetailF,Length(FullNomKey(FolioNum)),IDFolioK);   {** Reset Id Details **}

  end; {With..}
end; {Proc..}



{ ================== Convert No Wks Odue into Equivalent Chase Letter =============== }

Function TrigEquiv(CrStat  :  Integer)  :  Byte;

Var
  n,TS,TE :  Byte;
  Found   :  Boolean;

Begin
  n:=0; TS:=n; TE:=n;

  Found:=BOff;

  If (CrStat>=Syss.WksODue) then
  Begin
    While (n<NofChaseLtrs) and (Not Found) do
    With Syss do
    Begin
      Inc(n);

      If (n=1) then
      Begin
        TS:=Syss.WksODue; TE:=DebTrig[1];
      end
      else
      Begin
        TS:=DebTrig[Pred(n)]; TE:=DebTrig[n];
      end;

      {$B-}

      Found:=((n=NofChaseLtrs) or ((CrStat>=TS) and (CrStat<=TE)));

      {$B+}
    end; {While..}
  end;
  
  If (Found) then
    Result:=n
  else
    Result:=0;

end; {Func..}



{ ========= Set PrintedDoc Flag ========= }

Procedure Set_PrintedStatus(ToPrinter,
                            AlsoPicked:  Boolean;
                            InvR     :  InvRec);


Const
  PrintDocSet  :  Set of DocTypes  = [SOR,SDN,SIN,SCR,SRI,SRF];

  Fnum         =  InvF;

  Keypath      =  InvOurRefK;


Var
  KeyS  :  Str255;
  LAddr :  LongInt;

  LOk,
  Locked:  Boolean;


Begin

  Begin {*** This routine reproduced in ExBTTh1U for threads ***}

    If ((Not InvR.PrintedDoc) or ((Not InvR.OnPickRun) and (AlsoPicked))) and (ToPrinter) and (InvR.InvDocHed In PrintDocSet) then
    Begin

      With InvR do
        KeyS:=OurRef;

      LOk:=GetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      With Inv do
      Begin
        PrintedDoc:=BOn;

        If (InvDocHed In OrderSet) then
          OnPickRun:=AlsoPicked;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
      end;

    end; {If..}

  end; {With..}

end; {Proc..}




{ ========== Doc Authorisation Options ========== }


Function Autho_Need(AuthCode  :  Char)  : Boolean;

Begin

  Autho_Need:=(AuthCode In ['A','M']);

end; {Func..}



Function Autho_Doc(InvR  :  InvRec)  :  Boolean;


Begin

  With InvR do
  Begin

    Autho_Doc:=((InvDocHed In SalesSplit) or (Not Autho_Need(Syss.AuthMode))
                or (GetHoldType(HoldFlg)=HoldP));

  end; {With..}

end; {Func..}



{ ======== Function to Return Account status ======== }

Function Show_AccStatus(AccMode  :  Byte)  :  Str20;


Const
  TotAccStat  =  3;

Var
  AccStatMsg  :  Array[0..TotAccStat] of Str15;




Begin

  AccStatMsg[0]:='';
  AccStatMsg[1]:='* see notes';
  AccStatMsg[2]:='* On Hold!';
  AccStatMsg[3]:='* Closed! *';


  If (AccMode<=TotAccStat) then
    Show_AccStatus:=AccStatMsg[AccMode]
  else
    Show_AccStatus:='';

end; {Func..}

//RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
Function Show_EmpStatus(aStatus: TEmployeeStatus):  Str20;
begin
  case aStatus of
    emsOpen   : Show_EmpStatus := '';
    emsClosed : Show_EmpStatus := '* Closed! *';
  end;
end;






  { =============== Procedure to Return PSet Based On Mode
                    0  =  All Modes
                    1  =  Sales
                    2  =  Purchasing
                    3  =  Nominal Transfers
                    4  =  Stock Adjustments
                                                             =================== }


  Procedure GetPostMode(Mode  :  Byte;
                    Var PSet  :  DocSetType);


  Begin
    FillChar(Pset,Sizeof(Pset),0);

    Case Mode of
      0  :  PSet:=SalesSplit+PurchSplit+NomSplit+StkAdjSplit-QuotesSet;
      1  :  PSet:=SalesSplit-QuotesSet;
      2  :  PSet:=PurchSplit-QuotesSet;
      3  :  PSet:=NomSplit;
      4  :  PSet:=StkAdjSplit;
    end; {Case..}
  end; {PRoc..}




Function UseDebtWeeks(I  :  Integer)  :  Boolean;

Begin
  Result:=(Not (I In [1,3,5]));
end;

{ =============== Return No of Wks of oldest O/Due Item ============== }

Function CalcWksODue(OdDate  :  LongDate)  :  Integer;

Var
  TB  :  Integer;

Begin
  If (OdDate<>'') and (OdDate<=MaxUntilDate) then
  Begin
    If UseDebtWeeks(Syss.DebtLMode) then
      TB:=Round((NoDays(ODDate,Today)/7))
    else
      TB:=NoDays(ODDate,Today);
  end
  else
    TB:=0;

  {v5.60 Result is stored in a small int, so very long due dates were crashing the system with silent range check errors}
  If (TB<32768) then
    Result:=TB
  else
    Result:=32767;
end;



{ ======== Function to Return Alternate History Code ======= }

Function Calc_AltStkHCode(NType  :  Char)  :  Char;

Begin

  Calc_AltStkHCode:=Char(Ord(Ntype)+StkHTypWeight);

end;


{ ======== Function to Return Alternate History Code ======= }

Function Rev_AltStkHCode(NType  :  Char)  :  Char;

Begin

  Rev_AltStkHCode:=Char(Ord(Ntype)-StkHTypWeight);

end;



{ ======== Function to Determine if access available to Cust /Supplier ====== }


Function Access_HotCust(CMode  :  Boolean)  :  Boolean;


Begin

  With Inv do
    Access_HotCust:=((Not InSRC[CMode])
                     or ((Cmode) and (Not (InvDocHed In SalesSplit)))
                     or ((Not Cmode) and (InvDocHed In SalesSplit)));

end;



{ ======== Various routines to prevent a document being allocated whilst it is
         being edited from another hot key. ====== }

Procedure Add_DocEditNow(DocFolio  :  LongInt);


Begin

  If (DocEditedNow<100) then
  Begin
    Inc(DocEditedNow);

    DocEditNowList^[DocEditedNow]:=DocFolio;
  end;

end; {Proc..}


{==== Function to return index number if doc folio matched ====}

Function Found_DocEditNow(DocFolio  :  LongInt)  :  Integer;

Var
  FoundOk  :  Boolean;
  n        :  Integer;

Begin

  n:=DocEditedNow;

  FoundOk:=(n=0);

  While (n>0) and (Not FoundOk) do
  Begin

    FoundOk:=(DocEditNowList^[n]=DocFolio);

    If (Not FoundOk) then
      Dec(n);

  end; {While..}

  Found_DocEditNow:=n;

end;


{ === Proc to Remove Doc folio from list === }

Procedure Delete_DocEditNow(DocFolio  :  LongInt);

Var
  n  :  Integer;

Begin


  n:=Found_DocEditNow(DocFolio);

  If (n>0) then
  Begin
    DocEditNowList^[n]:=0;
    Dec(DocEditedNow);
  end;

end; {Proc..}


{ ======== Various routines to prevent a stock record having stock levels adjusted whilst it is edited == }

Procedure Add_StkEditNow(DocFolio  :  LongInt);


Begin

  If (StkEditedNow<100) then
  Begin
    Inc(StkEditedNow);

    StkEditNowList^[StkEditedNow]:=DocFolio;
  end;

end; {Proc..}


{==== Function to return index number if doc folio matched ====}

Function Found_StkEditNow(DocFolio  :  LongInt)  :  Integer;

Var
  FoundOk  :  Boolean;
  n        :  Integer;

Begin

  n:=StkEditedNow;

  FoundOk:=(n=0);

  While (n>0) and (Not FoundOk) do
  Begin

    FoundOk:=(StkEditNowList^[n]=DocFolio);

    If (Not FoundOk) then
      Dec(n);

  end; {While..}

  Found_StkEditNow:=n;

end;


{ === Proc to Remove Doc folio from list === }

Procedure Delete_StkEditNow(DocFolio  :  LongInt);

Var
  n  :  Integer;

Begin


  n:=Found_StkEditNow(DocFolio);

  If (n>0) then
  Begin
    StkEditNowList^[n]:=0;
    Dec(StkEditedNow);
  end;

end; {Proc..}



{==== Function to return true of currently edit docs match account number  ====}

Function Check_AccountEdit(AcCode  :  Str10)  :  Boolean;

Var
  FoundOk  :  Boolean;
  n        :  Byte;
  TmpStat,
  TmpKPath,
  Fnum,
  Keypath  :  Integer;

  TmpRecAddr
           :  LongInt;

  TmpInv   :  InvRec;


  KeyS     :  Str255;

Begin

  n:=DocEditedNow;

  FoundOk:=BOff;

  Fnum:=InvF;

  TmpInv:=Inv;

  Keypath:=InvFolioK;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  While (n>0) and (Not FoundOk) do
  Begin

    KeyS:=FullNomKey(DocEditNowList^[n]);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    FoundOk:=((StatusOk) and (CheckKey(AcCode,Inv.CustCode,Length(AcCode),BOff)));

    If (Not FoundOk) then
      Dec(n);

  end; {While..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  Inv:=TmpInv;

  Check_AccountEdit:=FoundOk;

end;


Function Check4PostLine(InvR  :  InvRec)  :  Byte;

Const
   Fnum     =  IDetailF;
   KeyPath  =  IDFolioK;



 Var
   Keys,KeyChk  :  Str255;
   FoundOk      :  Boolean;

   TmpStat,
   TmpKPath
                 : Integer;

   TmpRecAddr    :  LongInt;

   TmpId         :  Idetail;


 Begin
   Result:=0;

   TmpId:=Id;

   FoundOk:=BOff;

   With InvR do
   Begin
     KeyChk:=FullNomKey(FolioNum);
     KeyS:=FullIdKey(FolioNum,1);

     TmpKPath:=GetPosKey;

     TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

     Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

     While (StatusOk) and (Not FoundOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
     With Id do
     Begin
       FoundOk:=(Qty<>0) and (NetValue<>0);

       If (FoundOk) then
         Result:=Ord(PostedRun<>0)
       else
         Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

     end;

     TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

     Id:=TmpId;
     
   end;
 end;



{$IFDEF PF_On}

  { ======= Function to determine if Str has wild chars ======== }

  Function Has_CCWildChar(WStr  :  Str255)  :  Boolean;

  Var
    TmpBo  :  Boolean;

  Begin

    TmpBo:=((Pos(WildChA,WStr)<>0) or (Pos(WildChQ,WStr)<>0));

    If (TmpBo) then {* Only check for full length if wild cards,as
                       otherwise genuine full 2 digit codes would be rejected. *}

      TmpBo:=(Length(Strip('B',[#32],WStr))=CCKeyLen);

    Has_CCWildChar:=TmpBo;

  end; {Func..}

{$ENDIF}


  { ========= Function to return Correct VAT Code ========= }

  Function Correct_PVAT(PVAT,CVAT  :  Char)  :  Char;

  Var
    CompCode,
    Comp2Code  :  Char;

  Begin

    CompCode:=SyssVAT.VATRates.VAT[Zero].Code;

    Comp2Code:=SyssVAT.VATRates.VAT[Exempt].Code;

    If (CVAT In VATEECSet)  {$IFDEF CU} or (EnableCustBtns(4000,27)) {$ENDIF} then
      Correct_PVAT:=CVAT
    else
      If (PVAT=CompCode) or (CVAT=CompCode) then
        Correct_PVAT:=CompCode
      else
        If (PVAT=Comp2Code) or (CVAT=Comp2Code) then
          Correct_PVAT:=Comp2Code
        else
          Correct_PVAT:=PVAT;
  end;



{$IFDEF STK}


  { ========== Function to return Free Stock ========== }

  Function FreeStock(StockR  :  StockRec) :  Real;


  Begin

    With StockR do
    Begin

      If (Syss.FreeExAll) then
        FreeStock:=QtyInStock
      else
      Begin
        Result:=(QtyInStock-AllocStock(StockR));

        {If (StockType<>StkBillCode) then}
          Result:=Result-WOPAllocStock(StockR);
      end;

    end; {With..}

  end; {Func..}

  { ========== Function to return Picked or Allocated  ========== }
  Function AllocStock(StockR  :  StockRec) :  Double;


  Begin

    With StockR do
    Begin

      {$IFDEF SOP}
        If (Syss.UsePick4All) then
          Result:=QtyPicked
        else
      {$ENDIF}
        Result:=QtyAllocated;

    end; {With..}

  end; {Func..}


    { ========== Function to return Picked or Allocated  ========== }
  Function WOPAllocStock(StockR  :  StockRec) :  Double;


  Begin

    With StockR do
    Begin

      {$IFDEF WOP} {*EN440WOP*} {The equvalent routine in Exch needs connecting up so we get a free stock which includes WOR in Exch}
        If (Syss.UseWIss4All) then
          Result:=QtyPickWOR
        else
      {$ENDIF}
        Result:=QtyAllocWOR;

    end; {With..}

  end; {Func..}


  



  Function Stock_GP(Cost,Sales,BQty,SQty  :  Real;
                    Mode                  :  Byte;
                    UP                    :  Boolean)  :  Real;

  Var
    Base  :  Real;


  Begin
    Base:=0;  Result:=0.0;


    If ((Mode=0) and (Round_Up(Cost,Syss.NoCosDec)<>0)) or ((Mode=1) and (Round_Up(Sales,Syss.NoNetDec)<>0)) then
    Begin
      Cost:=Calc_StkCP(Cost,BQty,UP);

      Sales:=Calc_StkCP(Sales,SQty,UP);

      If (Mode=1) then
        Base:=Sales
      else
        Base:=Cost;

      If ((Base<>0) or (Mode<>1)) then
        Stock_GP:=Calc_Pcnt(Base,(Sales-Cost))
      else
        Stock_GP:=0;

    end;

  end;


  { ====== Function to Make GP from Cost ====== }

  Function MakeStock_GP(Cost,MU,SQty  :  Real;
                        Mode          :  Byte;
                        UP            :  Boolean)  :  Real;



  Var
    MgFac  :  Real;


  Begin

    If (Mode=1) then
      MgFac:=Round_Up(Calc_IdQty(DivWChk(Cost,(1-Pcnt(MU))),SQty,Not UP),Syss.NoNetDec)
    else
      MgFac:=Round_Up(Calc_IdQty(Cost*(1+Pcnt(MU)),SQty,Not UP),Syss.NoNetDec);

    MakeStock_GP:=MgFac;

  end; {Func..}


  { ======== Procedure to Warn_Costings changed ======== }

  Procedure Update_UpChange(NewNeed  :  Boolean);

  Var
    Locked  :  Boolean;

  Begin

    If (Syss.AutoBillUp) and (NewNeed<>Syss.NeedBMUp) then
    Begin
      Locked:=BOn;

      GetMultiSys(BOn,Locked,SYSR);

      Syss.NeedBMUp:=NewNeed;

      PutMultiSys(SysR,BOn);
    end;

 end;



 { =========== Function to Return Qty OS on Document =========== }

 Function Qty_OS(IdR  :  IDetail)  :  Real;


 Begin

   With IdR do
   Begin

     If (IdDocHed=WOR) then
       Qty_OS:=Round_Up((WORReqQty(IdR)-QtyDel),Syss.NoQtyDec)
     else
       Qty_OS:=Round_Up((Qty-(QtyDel+QtyWOff)),Syss.NoQtyDec);

   end;

 end; {Func..}


    { ========== Function to return Picked or Allocated  ========== }
  Function WORReqQty(IdR  :  IDetail) :  Double;


  Begin

    With IdR do
    Begin

      Result:=Round_Up(Qty+QtyPWOff,Syss.NoQtyDec);
   
    end; {With..}

  end; {Func..}


  { ========== Function to return WOR Built o/s========== }
  Function BuildQty_OS(IdR  :  IDetail) :  Double;


  Begin

    With IdR do
    Begin

      Result:=Round_Up(WORReqQty(IdR)-QtyWOff,Syss.NoQtyDec);

    end; {With..}

  end; {Func..}



 Procedure SetE2CId(Var IdR     :  IDetail;
                        StockR  :  StockRec);

 Begin
   FillChar(IdR,Sizeof(IdR),0);


   IdR.StockCode:=StockR.StockCode;
   IdR.QtyMul:=1;
   IdR.QtyPack:=1;

   IdR.ShowCase:=StockR.DPackQty;

    If (IdR.ShowCase) then
      IdR.QtyPack:=StockR.BuyUnit;

 end;

   { ========== Function to return Pack equivalent levels ========== }

  Function CaseQty(StockR  :  StockRec;
                   SQ      :  Double) :  Double;

  Var
    DecStr,
    TmpStr :   Str20;

    CQty,EQty,
    RatQty :  Double;

    MDec   :  Byte;

  Begin
    Result:=SQ; MDec:=0;

    With StockR do
    Begin
      If (DPackQty) then
      Begin
        RatQty:=DivWChk(SQ,SellUnit);

        {* The round added so that any small rounding errors did not distort the trunc *}

        { PRev v5.70 this line was used: CQty:=Trunc(Round_Up(RatQty,8));
        But for a stock record with a sales unit of 0.01, and show stock as split pack enabled, just typing in
        8000 on a sales order got it showing as qty 7998 due to the rounding to 8 decs introducing an error.
        Switched to 1+syss.qty dec instead}

        MDec:=Syss.NoQtyDec;

        If (Syss.NoQtyDec<4) then
          MDec:=MDec+4;

        CQty:=Trunc(Round_Up(RatQty,MDec));

        EQty:=Round_Up((SQ-(Cqty*SellUnit)),0);

        If (Syss.NoQtyDec>1) or (SellUnit>10) then
          DecStr:=SetPadNo(Form_Int(Round(ABS(EQty)),0),Syss.NoQtyDec)
        else
          DecStr:=Form_Real(ABS(EQty),0,0);

        TmpStr:=Form_Real(CQty,0,0)+'.'+DecStr;

        If (CQty=0.0) and (EQty<0) then
          TmpStr:='-'+TmpStr;

        Result:=Round_Up(RealStr(TmpStr),Syss.NoQtyDec);
      end;
    end; {With..}

  end; {Func..}



  Function Ea2Case(Idr     :  IDetail;
               Var StockR  :  StockRec;
                   CQ      :  Double)  :  Double;
  Const
    Fnum    =  StockF;
    KPath2  =  StkCodeK;

  Var
    LastStat,
    TmpStat,
    Keypath :  Integer;
    TmpRecAddr
            :  Longint;

    GotStk  :  Boolean;

    TmpStk  :  StockRec;

    KeyS    :  Str255;



  Begin
    GotStk:=BOff;
    LastStat := Status;
    With Idr do
    Begin
      If (Is_FullStkCode(StockCode)) and (QtyMul=1) then
      Begin
        If (StockR.StockCode<>IdR.StockCode) then
        Begin
          LastStat:=Status;
          TmpStk:=Stock;
          Keypath:=GetPosKey;

          TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

          KeyS:=FullStockCode(IdR.StockCode);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Kpath2,KeyS);

          If (StatusOk) then
            StockR:=Stock;

          GotStk:=BOn;
        end;


        Result:=CaseQty(StockR,CQ);

        If (GotStk) then
        Begin
          TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

          Stock:=TmpStk;
          Status:=LastStat;
        end;

      end
      else
        Result:=CQ;
    end;

  end;


  Function Case2Ea(Idr     :  IDetail;
                   StockR  :  StockRec;
                   CQ      :  Double)  :  Double;

  Var
    TStr  :  Str255;
    Cp    :  Byte;

    NV    :  SmallInt;

    Cases,
    UnitX :  Double;

    WasNV :  Boolean;

  Begin
    TStr:='';

    NV:=1;

    WasNV:=(CQ<0.0);

    With Idr do
    Begin
      If (Is_FullStkCode(StockCode)) and (QtyMul=1) and (ShowCase) then
      With StockR do
      Begin
        TStr:=Form_Real(CQ,0,Syss.NoQtyDec);
        Cp:=LastPos('.',TStr);

        If (Syss.NoQtyDec>0) then
        Begin

          Cases:=RealStr(Copy(TStr,1,Pred(CP)));


          UnitX:=ABS(RealStr(Copy(TStr,Succ(CP),Length(TStr)-Cp)));

          If (UnitX>SellUnit) and (TStr[Length(TStr)]='0') and (Cases>0.0) and (Syss.NoQtyDec>=2) then
            UnitX:=DivWChk(UnitX,Power(10,Pred(Syss.NoQtyDec)));
        end
        else
        Begin
          Cases:=RealStr(TStr);

          UnitX:=0;
        end;

        If (WasNV) then
        Begin
          NV:=-1;
          Cases:=ABS(Cases);
        end;

        Result:=((Cases*SellUnit)+UnitX)*NV;
      end
      else
        Result:=CQ;
    end;
  end;



  Function  StkApplyMul(SL,QM  :  Double;
                        Switch :  Boolean)  :  Double;

  Begin
    Result:=0.0;
    
    If (QM<>1.0) and (QM<>0.0) then
    Begin
      If (Switch) then
        Result:=DivWChk(SL,QM)
      else
        Result:=SL*QM;
    end
    else
      Result:=SL;
      
    StkApplyMul:=Result;
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


  { ======= Function to Return Special Order based Run No. ========= }

  {$IFDEF WOP}

    Function Set_WOrdRunNo(DocHed   :  DocTypes;
                           AutoOn,
                           Posted   :  Boolean)  :  LongInt;


    Var
      Lnum  :  LongInt;


    Begin
      Lnum:=0;


      If (DocHed In WOPSPlit) then
      Begin

        If (DocHed =WOR) then
          LNum:=WORUPRunNo-Ord(AutoOn)-(2*Ord(Posted))
        else
          LNum:=WINUPRunNo-Ord(AutoOn)-(2*Ord(Posted));

      end;

      Result:=Lnum;

    end; {Func..}

  {$ENDIF}


  { ======= Function to Return Special Returns based Run No. ========= }


  {$IFDEF RET}

    Function Set_RetRunNo(DocHed   :  DocTypes;
                         AutoOn,
                         Posted   :  Boolean)  :  LongInt;


    Var
      Lnum  :  LongInt;


    Begin
      Lnum:=0;


      If (DocHed In StkRetSplit) then
      Begin

        If (DocHed In StkRetSalesSplit) then
          LNum:=SRNUPRunNo-Ord(Posted)
        else
          LNum:=PRNUPRunNo-Ord(Posted);

      end;

      Result:=Lnum;

    end; {Func..}

  {$ENDIF}


  { ========= Function to Establish SOR DocNo ======== }

  Function SOP_GetSORNo(SOPLink  :  LongInt)  :  Str10;


  Var
    TmpRef  :  Str10;
    TmpInv  :  ^InvRec;


  Begin

    TmpRef:='';

    New(TmpInv);

    TmpInv^:=Inv;

    {$B-}

    If (SOPLink<>0) and (CheckRecExsists(FullNomKey(SOPLink),InvF,InvFolioK)) then
      TmpRef:=Inv.OurRef;

    {$B+}

    Inv:=TmpInv^;

    Dispose(TmpInv);

    SOP_GetSORNo:=TmpRef;

  end;


  { ========= Function to Establish SOR DocNo ======== }

  Function RET_GetSORNo(SOPLink  :  LongInt)  :  Str10;


  Var
    TmpRef  :  Str10;
    TmpInv  :  ^InvRec;


  Begin

    TmpRef:='';

    New(TmpInv);

    TmpInv^:=Inv;

    {$B-}

    If (SOPLink<>0) and (CheckRecExsists(Strip('R',[#0],FullNomKey(SOPLink)),InvF,InvFolioK)) then
      TmpRef:=Inv.OurRef;

    {$B+}

    Inv:=TmpInv^;

    Dispose(TmpInv);

    RET_GetSORNo:=TmpRef;

  end;


  Function SOP_QtyLink(SOPLink,
                       SOPLNo   :  LongInt;
                       Mode     :  Byte)  :  Real;



  Var
    Rnum  :  Real;
    TmpId :  ^Idetail;


  Begin
{$IFDEF DBGLST}
  DbgList.Add ('  SOP_QTYLink: ' + Format ('%4d/%4d/%4d', [SOPLink, SOPLNo, Mode]));
{$ENDIF}
    New(TmpId);

    TmpId^:=Id;

    Rnum:=0;

    If (SOPLink<>0) then
    Begin

      If (CheckRecExsists(FullIdKey(SOPLink,SOPLNo),IdetailF,IdLinkK)) then
      With Id do
      Begin

        Case Mode of                                          

          1  :  Rnum:=Qty;
          2  :  Rnum:=Qty_Os(Id);
          3  :  Rnum:=QtyWOff;
          4  :  Rnum:=QtyDel;
         end; {Case..}

      end; {If..}


      Id:=TmpId^;

    end;

    Dispose(TmpId);

    SOP_QtyLink:=Rnum;

{$IFDEF DBGLST}
  DbgList.Add ('  SOP_QTYLink Done: ' + Format ('%12.4f', [RNum]));
{$ENDIF}
  end; {Func..}



    { ====== Check if Neg Stk Allowed ====== }

  Function CheckNegStk  :  Boolean;

  Begin

    CheckNegStk:=((Not PChkAllowed_In(182)) and (Syss.UsePassWords) and (Not SBSIn));  {* Checking for -ve stk enabled *}

  end;


  { ======= Function to Return Stock Valuation Mode ====== }

  Function FIFO_Mode(CMode  :  Char)  :  Byte;

  Var
    ModeVal  :  Byte;


  Begin
    ModeVal:=0;

    Case CMode of

      'C'  :  ModeVal:=1;
      'F'  :  ModeVal:=2;             
      'L'  :  ModeVal:=3;
      'A','E'
           :  ModeVal:=4;

      {$IFDEF SOP}
        'R'  :  ModeVal:=5;
      {$ELSE}
         //PR: 18/11/2011 In toolkit, this was returning 1 for Average, so didn't update stock costs correctly.
         //Added ExDll ifdef + check for Spop licenced.
        {$IFDEF EXDLL}

        'R'  :  if SPOPOn then
                  ModeVal:=5
                else
                  ModeVal := 1;
        {$ELSE}
        'R'  :  ModeVal:=1;
        {$ENDIF}
      {$ENDIF}

      'S'  :  ModeVal:=6;

    end; {Case..}

    FIFO_Mode:=ModeVal;

  end; {Func..}


  {== Function to set / translate the Serial and average combination ==}


    Function SetStkVal(SV    :  Char; {*EN431ASN*}
                   Var SNAV  :  Byte;
                       Mode  :  Boolean)  :  Char;


    Const
      AVSN  =  'E';



    Begin
      Result:=SV;

      If (Mode) then {* we want to translate from record fields *}
      Begin
        If (SV='R') and (SNAV=1) then
          Result:=AVSN;
      end
      else
      Begin
        If (SV=AVSN) then
        Begin
          Result:='R'; SNAV:=1;
        end
        else
          SNAV:=0;
      end;

    end;


  { ====== Is FIFO ====== }

  Function Is_FIFO(CMode  :  Char)  :  Boolean;

  Begin

    Is_FIFO:=(FIFO_Mode(CMode) In [2..3]);

  end;

  { ====== Is SERNo ====== }

  Function Is_SERNO(CMode  :  Char)  :  Boolean;

  Begin

    Is_SERNO:=(FIFO_Mode(CMode) In [5]);

  end;

  {* various functions for translation between valuation methods & Procduct types *}

  {$IFNDEF LTE}

    Function StkVM2I(VM   :  Char)  :  Integer;

    Const
      IdTxlate  :  Array[0..6] of Byte = (0,0,2,3,4,5,1);

    Begin
      Result:=IdTxlate[FIFO_Mode(VM)];

      If (Result=4) and (VM='E') then
        Result:=6;
    end;


    Function StkI2VM(I  :  Integer)  :  Char;

    Const
      IdTxlate  :  Array[0..6] of Char = ('C','S','F','L','A','R','E');

    Begin
      If (I In [0..6]) then
        Result:=IdTxlate[I]
      else
        Result:=IdTxLate[0];
    end;

  {$ELSE}

    Function StkVM2I(VM   :  Char)  :  Integer;

    Const
      IdTxlate  :  Array[0..6] of Byte = (0,0,1,0,2,0,0);

    Begin
      Result:=IdTxlate[FIFO_Mode(VM)];

    end;


    Function StkI2VM(I  :  Integer)  :  Char;

    Const
      IdTxlate  :  Array[0..2] of Char = ('S','F','A');

    Begin
      If (I In [0..2]) then
        Result:=IdTxlate[I]
      else
        Result:=IdTxLate[0];
    end;

  {$ENDIF}

  Function StkPT2I(VM  :  Char)  :  Integer;

  Begin
    If (VM=StkDescCode) then
      Result:=1
    else
      If (VM=StkGrpCode) then
        Result:=2
      else
        If (VM=StkDListCode) then
          Result:=3
        else
          If (VM=StkBillCode) then
            Result:=4
          else
            Result:=0;

        If (Not FullStkSysOn) and (Result>0) then
          Result:=Pred(Result);


  end;


  Function StkI2PT(I  :  Integer)  :  Char;

  Const
    IdTxlate  :  Array[0..4] of Char = (StkStkCode,StkDescCode,StkGrpCode,StkDListCode,StkBillCode);

  Begin
      If (Not FullStkSysOn) then
      Begin
        I:=Succ(I);
      end;

    If (I In [0..4]) then
      Result:=IdTxlate[I]
    else
      Result:=IdTxlate[0];

  end;


  Function RevalueStk(NCode  :  LongInt)  :  Boolean;

  Const
    Fnum    =  NomF;
    KPath2  =  NomCodeK;


  Var
    TmpNom  :  NominalRec;

    LastStat,
    TmpStat,
    Keypath :  Integer;
    TmpRecAddr,
    NC      :  LongInt;

    KeyS    :  Str255;

  Begin
    LastStat:=Status;
    TmpNom:=Nom;
    Keypath:=GetPosKey;

    ResetRec(Fnum);

    TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyS:=FullNomKey(NCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Kpath2,KeyS);

    RevalueStk:=(StatusOk and Nom.Revalue);

    TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

    Nom:=TmpNom;
    Status:=LastStat;


  end;

  {*EN420}
  Procedure MakeObFIFOId(Var  IdR  :  IDetail;
                              CP   :  Real;
                              CrC  :  Byte;
                              Loc  :  Str10);
  Begin
    With IdR do
    Begin
      FillChar(Idr,Sizeof(Idr),0);

      PDate:=Pr2Date(Syss.PrInYr,Syss.AuditYr,Nil);

      Currency:=CrC;
      CXRate:=SyssCurr^.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);

      CostPrice:=CP;
      MLocStk:=Loc;
      IdDocHed:=ADJ;
      QtyMul:=1;
      QtyPack:=1;
      PriceMulX:=1.0;
    end;
  end;


  { ======= Function to Return Special Order based Run No. ========= }


  {Function Set_WOrdRunNo(DocHed   :  DocTypes;
                         AutoOn,
                         Posted   :  Boolean)  :  LongInt;


  Var
    Lnum  :  LongInt;


  Begin

    Lnum:=0;


    If (DocHed In WOPSPlit) then
    Begin

      If (DocHed =WOR) then
        LNum:=WORUPRunNo-Ord(AutoOn)-(2*Ord(Posted))
      else
        LNum:=WINUPRunNo-Ord(AutoOn)-(2*Ord(Posted));

    end;

    Result:=Lnum;

  end; {Func..}




{$ELSE} {*EL v6.01 Custom CC/Dep Overide Hook : ELSE Non Stk Versions *}
    Function Ea2Case(Idr     :  IDetail;
                 Var StockR  :  StockRec;
                     CQ      :  Double)  :  Double;


    Begin
      Result:=CQ;
    end;


    Function Case2Ea(Idr     :  IDetail;
                     StockR  :  StockRec;
                     CQ      :  Double)  :  Double;

    Begin
      Result:=CQ;
    end;



{$ENDIF}


{$IFDEF JC}
  {$IFDEF JAP}

    Function Set_JAPRunNo(DocHed   :  DocTypes;
                           AutoOn,
                           Posted   :  Boolean)  :  LongInt;


    Var
      Lnum  :  LongInt;


    Begin
      Lnum:=0;

      If (DocHed In JAPSPlit) then
      Begin

        Case DocHed of
          JCT  :  LNum:=JCTUPRunNo;

          JST  :  LNum:=JSTUPRunNo;

          JPT  :  LNum:=JPTUPRunNo;

          JSA  :  LNum:=JSAUPRunNo-Ord(Posted);

          JPA  :  LNum:=JPAUPRunNo-Ord(Posted);
        end; {Case..}
      end;

      Result:=Lnum;

    end; {Func..}

  {$ENDIF}
{$ENDIF}



Function CCode2I(CC  :  Str5)  :  Integer;

Begin
  If (CC=SingCCode) then
    Result:=2
  else
    If (CC=NZCCode) then
      Result:=1
    else
      If (CC=AusCCode) then
        Result:=0
      else
        If (CC=IECCode) then
          Result:=5
        else
          Result:=4;
end;


Function I2CCode(CC  :  Integer)  :  Str5;

Const
  CCAry  :  Array[0..5] of Str5 = (AUSCCode,NZCCode,SingCCode,DefaultCountry,DefaultCountry,IECCode);


Begin
  Result:=CCAry[CC];
end;


Function AMethod2I(CC  :  Char)  :  Integer;

Begin
  If (CC In ['N',#0]) then
    Result:=0
  else
    If (CC In ['A']) then
      Result:=1
    else
      Result:=2;

end;


Function I2AMethod(CC  :  Integer)  :  Char;

Const
  CCAry  :  Array[0..2] of Char = ('N','A','M');


Begin
  Result:=CCAry[CC];
end;


  { == Func to determine if we are using standard mode WOP == }

  Function Is_STDWOP  :  Boolean;

  Begin
    Result:=((StdWOP) and (Not FullWOP)) or (FullWOP and Syss.UseStdWOP);

  end;



{== Routines to control the getting and storage of additional password records ==}

Procedure SetEntryRecVar(PgNo    :  Byte;
                         PLogin  :  Str10;
                         LoadRec,
                         OverWER :  Boolean;
                     Var ERec    :  EntryRecType);


Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;


Var
  KeyS  :  Str255;
  SetER :  Boolean;
  n     :  Byte;
  Idx   :  Longint;
  TmpPassWord
        : PassWordRec;


Begin
  TmpPassWord:=PassWord;

  SetER:=BOn;

  If (LoadRec) then
  Begin
    KeyS:=FullPWordKey(PassUCode,Chr(PgNo),PLogin);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Not StatusOk) then
    Begin
      ResetRec(Fnum);

      SetER:=OverWER; {In the case of a copy or system copy, do not overwrite EntryRec if not found *}

      If (SetER) and (PgNo>1) and (ERec.Access[255]=1) then
      With Password do
      Begin
        FillChar(PassEntryRec,Sizeof(PassEntryRec),1);
      end;
    end;

  end;

  Idx:=256*PgNo;

  With PassWord,PassEntryRec do
  Begin

    If (SetER) then
      For n:=Low(Access) to High(Access) do
      Begin
        ERec.Access[n+Idx]:=Access[n];

      end;

    If (PgNo=0) then
    Begin
      ERec.Login:=Login;
      ERec.LastPNo:=LastPNo;
      ERec.PWord:=PWord;

    end;
  end;

  {$IFDEF LTE} {Override non Lite passwords with hard wired options}

    With ERec do
    Begin

    end;

  {$ENDIF}

  PassWord:=TmpPassWord;
end;


Procedure SetEntryRec(PgNo    :  Byte;
                      PLogin  :  Str10;
                      LoadRec,
                      OverWER :  Boolean);



Begin
  SetEntryRecVar(PgNo,PLogin,LoadRec,OverWER,EntryRec^);

end;


{ ================== Function to Return User Record ============== }

Function GetLogInRec(LoginCode  :  Str20)  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;


Var
  KeyS     :  Str255;
  n        :  Byte;

Begin
  Result:=BOff;

  KeyS:=FullPWordKey(PassUCode,C0,LoginCode);

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  Result:=StatusOk;

  If (Result) then
  With Password do
  Begin
    For n:=0 to 3 do {* Get any password settings + additional page settings *}
      SetEntryRec(n,LoginCode,(n>0),BOn);
  end;

  GetLogInRec:=Result;
end; {Func..}





{ ================ Procedure to set Login Params based on Command line switches ================= }

Procedure SetLoginParams;

Begin

  SBSParam:='';

  LoginParam:='';

  If (SBSIn) then
    SBSParam:=' '+PSwitch+SBSPass
  else
    If (GotPassWord) then
      LoginParam:=' '+AutoPWSwitch+EntryRec^.Login;

  If (NoXLogo) then
    LoginParam:=LoginParam+' '+NoXLogoSwitch;

end; {Proc..}






{ =========== Check Command Line Parameters =========== }

Function  CheckParam(ChkStr,PStr  :  Str255;
                 Var DefStr       :  Str255)  :  Boolean;


Var
  n      :  Byte;
  TmpBo  :  Boolean;

Begin
  n:=Length(ChkStr);

  TmpBo:=(UpCaseStr(ChkStr)=UpcaseStr(Copy(PStr,1,n)));

  If (TmpBo) then
    DefStr:=Copy(PStr,Succ(n),(Length(PStr)-n));

  CheckParam:=TmpBo;

end;

{ == Procedure to Check all the Files and return the lowest version number == }

Function Group_BtVersion  :  Byte;

Var
  n          :  SmallInt;
  TotalVer,
  ThisVer    :  Integer;
Begin
  TotalVer:=255;

  Result:=0;

  For n:=1 To TotFiles do
  Begin
    ThisVer:=File_VerCId(F[n],n,Nil);

    If (ThisVer<TotalVer) then
      TotalVer:=ThisVer;
  end;

  Case TotalVer of
    $50..$59  :  Result:=5;
    $60..$69  :  Result:=6;
    $70..$79  :  Result:=7;
    $80..$89  :  Result:=8;
    $90..$99  :  Result:=9;
    else         Result:=0;
  end; {Case..}

end;


{ ================== Procedure to Return Any Parameters ================= }

Procedure GetParam;

Var
  n      :  Word;
  TmpBo  :  Boolean;
  TmpStr :  Str255;


Begin

  TmpBo:=BOff;


  SBSIn:=BOff;

  DumpFileOff:=BOff;

  ResetBtOnExit:=BOff;

  NoXLogo:=BOff;


  If (ParamCount>0) then
    For n:=1 to ParamCount do
    Begin

      TmpStr:='';

      If (Not SBSIn) then
        SBSIn:=CheckParam(PSwitch+SBSPass,ParamStr(n),TmpStr);

      If (Not DumpFileOff) then
        DumpFileOff:=CheckParam(DumpSwitch,ParamStr(n),TmpStr);

      If (Not ResetBtOnExit) then
        ResetBtOnExit:=CheckParam(ResetBTSwitch,ParamStr(n),TmpStr);

      If (Not NoXLogo) then
        NoXLogo:=CheckParam(NoXLogoSwitch,ParamStr(n),TmpStr);

      If (Not AccelMode) then
        AccelMode:=CheckParam(AccelSwitch,ParamStr(n),TmpStr);

      {$IFNDEF EDLL}
      // MH 06/07/07: Removed for SbsForm.Dll as the files aren't open at this point and the
      // lookup of the user details causes the SQL Emulator to lock up instead of return error 3
      If (Not GotPassWord) then
      Begin

        GotPassWord:=CheckParam(AutoPWSwitch,ParamStr(n),TmpStr);

        If (GotPassWord) then
          GotPassWord:=GetLoginRec(TmpStr);
      end;
      {$ENDIF}
    end; {Loop..}


  SetLoginParams;

  If (AccelMode) then
    AccelParam^:=AccelSwitch;




end; {Proc..}



  { ==== Function to Evaluate current vers ==== }
  Function Which_ExVerNo : LongInt;
  Var
    n,jn  :  Byte;
  Begin
    n:=1;

    {$IFDEF MC_On}
      n:=7;
      jn:=11;
    {$ELSE}

      jn:=6;

      {$IFDEF PF_On}
        n:=3;
      {$ELSE}
        n:=1;
      {$ENDIF}

    {$ENDIF}

    {$IFDEF STK}
      n:=n+1;
    {$ENDIF}

    {$IFDEF SOP}
      n:=n+1;
    {$ENDIF}

    If (Not JBCostOn) then
      Result:=n
    else
      Result:=jn;

  end; {Func..}


  Function Which_ExVers  :  Str10;
  Begin
    Which_ExVers:='/EXV:'+Form_Int(Which_ExVerNo, 0);
  end; {Func..}


  { ========== Proc to Restore Global Heap Memory used by Pointers ========= }

  Procedure HeapVarTidy;

  Var
    n  :  Byte;

  Begin
    Dispose(ExMainCoPath);

    Dispose(GlobalAllocRec);

    {$IFNDEF SENT} {29/08/2001. EL: Caused a GPF upon exiting the Sentimail engine, no obvious cause when investiaged.  Was simpler to
                                    knock this dispose out.  check Address, size and contents, all OK}
      Dispose(SyssVAT);
    {$ENDIF}

    Dispose(SyssCIS);

    Dispose(SyssCIS340);

    Dispose(CCCISName);

    Dispose(SyssCurr);
    Dispose(SyssGCuR);
    Dispose(SyssCurr1P);
    Dispose(SyssGCuR1P);

    Dispose(SyssDEF);
    Dispose(SyssForms);
    Dispose(SyssJob);

    Dispose(SyssMod);
    Dispose(SyssEDI1);
    Dispose(SyssEDI2);
    Dispose(SyssEDI3);
    Dispose(SyssCstm);
    Dispose(SyssCstm2);

    Dispose(DocStatus);

    Dispose(CCVATName);

    Dispose(MiscRecs);
    Dispose(MiscFile);
    Dispose(RepScr);
    Dispose(RepFile);
    Dispose(CInv);
    Dispose(CId);
    Dispose(CStock);
    Dispose(EntryRec);
    Dispose(UserProfile);
    Dispose(ViewPr);
    Dispose(ViewYr);
    Dispose(AccelParam);
    Dispose(ExVersParam);
    Dispose(RepWrtName);
    Dispose(JBCostName);

    Dispose(DocEditNowList);
    Dispose(StkEditNowList);

    Dispose(JobMisc);
    Dispose(JobMiscFile);

    Dispose(JobRec);
    Dispose(JobRecFile);

    Dispose(JobCtrl);
    Dispose(JobCtrlFile);

    Dispose(JobDetl);
    Dispose(JobDetlFile);

    Dispose(CJobMisc);

    Dispose(CJobRec);
    Dispose(CJobDetl);

    Dispose(NomView);
    Dispose(NomViewFile);

    {$IFDEF JC}
       Dispose(JobStatusL);
       Dispose(JobXDesc);
       Dispose(JobCHTDescL);
       Dispose(EmplTDescL);
    {$ENDIF}

    Dispose(MLocCtrl);
    Dispose(MLocFile);


  end;

{$IFNDEF EXDLL}   {* for ToolKit DLL 29.08.97 *}

{$IFNDEF TRADE}

Initialization


  GetParam;


  {* Check if Job Costing Exe file present. Disable menu option if not *}
  {* v4.24b, JBCostOn relies on relies on *}

  {$IFDEF PF_On}

// MH 22/03/2010: Commented out obsolete check for DOS Job Costing .EXE - was causing EntComp2.Dll
//                to crash on loading as JBCostName^ not allocated
//    {$IFNDEF JC}
//      JBCostOn:=FileExists(JBCostName^);
//    {$ENDIF}

    // MH 05/07/07: Modified as this was causing the emulator to lock-up when running
    // under Windows Vista against MS SQL. 
    {$IFNDEF EXSQL}
      BTFileVer:=Group_BtVersion;
    {$ELSE}
      BTFileVer:=9;
    {$ENDIF}

  {$ELSE}

    JBCostOn:=BOff;

  {$ENDIF}






  { ====================== Alter Definition Constants Here ===================== }

  If (Debug) then
  Begin

    Syss.TotalConv:='V'; {* Force Co rate *}

    {Syss.StaUIDate:=BOff;}

    Syss.UseCCDep:=BOn;
    Syss.PostCCNom:=BOn;

    {Syss.DeadBOM:=BOn;}

    {Syss.AlTolMode:=1;
    Syss.AlTolVal:=10;}

    {Syss.AutoPrCalc:=BOn;}

    Syss.UsePassWords:=BOn;

    {Syss.ManROCP:=BOff;

    Syss.ShowStkGp:=BOff;

    Syss.UseStock:=BOn;}

    Syss.InpPack:=BOn;

    Syss.LiveCredS:=BOn;

    Syss.AutoValStk:=BOff;
    Syss.ProtectPost:=BOn;

    {Syss.IncNotDue:=BOn;}

    JBCostOn:=BOff; {* Force Job Costing On *}
    {JBFieldOn:=BOff; {* Force JC fields on *}

    {EuroVers:= Set inside BTSupU2}

    Syss.BatchPPY:=BOff;

    Syss.WarnJC:=BOn;
    Syss.WarnYRef:=BOn;

    {Syss.UseMLoc:=BOn;}
    {Syss.UseLocDel:=BOn;}

    Syss.TxLateCr:=BOn;
    {Syss.ConsvMem:=BOff;}

    {SBSIn:=BOn;}
    Syss.IntraStat:=BOn;

    {Syss.DispPrAsMonths:=BOn;}

    {CurrentCountry:=DefaultCountry;}
    CurrentCountry:='044';

    {CurrentCountry:=NZCCode;}

    {Syss.NoQtyDec:=3;
    Syss.NoCOSDec:=3;}

    {Syss.AuditYr:=0;}

    Syss.UseStock:=BOn;
    Syss.UsePick4All:=BOff;
    Syss.SepRunPost:=BOff;

    {Syss.AnalStkDesc:=BOn;}

    Syss.BigStkTree:=BOn;
    Syss.BigJobTree:=BOn;

    AnalCuStk:=BOn;
    TeleSModule:=BOn;

    Syss.UseUpLiftNC:=BOn;

    Syss.NomCtrlCodes[FreightNC]:=73020;

    EntryRec^.Access[182]:=0;

    Syss.UseStdWOP:=BOn;

    {Syss.VATCurr:=2;}

    {SyssVAT.VATRates.UDFCaption[1]:='User Def 1';
    SyssVAT.VATRates.UDFCaption[2]:='User Def 2';
    SyssVAT.VATRates.UDFCaption[3]:='User Def 1';
    SyssVAT.VATRates.UDFCaption[4]:='User Def 2';
    SyssVAT.VATRates.UDFCaption[5]:='User Def 1';
    SyssVAT.VATRates.UDFCaption[6]:='User Def 2';
    SyssVAT.VATRates.UDFCaption[7]:='Freight';
    SyssVAT.VATRates.UDFCaption[8]:='Labour';
    SyssVAT.VATRates.UDFCaption[9]:='Materials';
    SyssVAT.VATRates.UDFCaption[10]:='Discount';}

  end;


  {$IFDEF DBD} {* Ex431 *}
    Begin
      eBusModule:=BOn;
      eCommsModule:=BOn;
      {CommitAct:=BOff;}

      CISOn:=Debug;

      JAPOn:=Debug;

      FullStkSysOn:=BOn;

      RetMOn:=Debug;

      WOPOn:=Debug;

      //ICEDFM:=2;

    end;
  {$ELSE}      {* Ex431 *}
     Begin
      {eBusModule:=BOn;
      eCommsModule:=BOn;
      CommitAct:=BOn;}

      {RetMOn:=BOn;}  


    end;

  {$ENDIF}




  { ============================================================================ }


  { ====================== Alter Constants Here ===================== }



  { ================================================================= }




Finalization


  HeapVarTidy;

  {$IFDEF CU}
    GenDiscMask:='';
    LDDBeenChecked:=BOff;
  {$ENDIF}

{$ENDIF}
{$ENDIF}

end.
