unit Bt1SupU;

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
  SysUtils, WinTypes, WinProcs, Messages,
  Classes, Graphics, Controls, Forms, Dialogs,
  GlobVar,
  VarConst,
  VarCnst3;


Const
  GenRealMask   =  '###,###,##0.00 ;###,###,##0.00-';
  GenQtyMask   =  '0';
  GenPcntMask   =  '0.00%';
  CustKeyLen    =  6;
  StkKeyLen     =  16;
  DocKeyLen     =  9;
  WM_CustGetRec    = WM_User+$1;
  WM_FormCloseMsg  =  WM_User+$2;



Function CheckKey(KeyRef,Key2Chk  :  Str255;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  Str255;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80)  :   Boolean;

Procedure ResetRec(FNum  :  Integer);

Procedure SetDataRecOfs(FNum     :  Integer;
                        Ofset    :  LongInt);

Function  CheckExsists(KeyR  :  Str255;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;

Function  CheckRecExsists(KeyR  :  Str255;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Procedure DeleteLinks (Code  :  Str255;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer;
                       DelInv:  Boolean);

Function Total_Profit_To_Date(NType        :  Char;
                              NCode        :  Str20;
                              PCr,PYr,PPr  :  Byte;
                          Var Purch,PSales,
                              PCleared,
                              PBudget      :  Real;
                              Range        :  Boolean)  :  Real;

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str10;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Real;
                        Range        :  Boolean)  :  Real;

Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);

Procedure Init_AllSys;

Procedure PutMultiSys(SysMode  :  SysRecTypes;
                      UnLock   :  Boolean);

Procedure GetMultiSys(Wait         :  Boolean;
                      Var  Locked  :  Boolean;
                           SysMode :  SysRecTypes);

Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);

Function FIFO_Mode(CMode  :  Char)  :  Byte;

Function Is_FIFO(CMode  :  Char)  :  Boolean;

Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;

// MH 24/03/2009: Created extended version with support for extra Advanced Discounts fields  //PR: 24/03/2009 Copied from ComnU2
Function Calc_PAmountAD (FullAmount, DiscAmnt :  Real;
                         DiscCh               :  Char;
                         Disc2Amnt            :  Real;
                         Disc2Ch              :  Char;
                         Disc3Amnt            :  Real;
                         Disc3Ch              :  Char)  :  Real;


Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

Function TotalOs(InvR  :  InvRec)  :  Real;

Function LineCnst(P  :  Char)  :  Integer;

Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean)  :  Double;

Function  UseCoDayRate  :  Boolean;

Function XRate(CXRate  :  CurrTypes;
               CurDRte :  Boolean;
               Currency:  Byte)  :  Real;

Function  Conv_Curr(Amount  :  Real;
                    Rate    :  Real;
                    Too     :  Boolean)  :  Real;

Function  Currency_ConvFT(Amount  :  Real;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Real;

Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Function BaseTotalOs(InvR  :  InvRec)  :  Real;

Function  CurrencyOS(IRec         :  InvRec;
                     UseRound,
                     SterEquiv,
                     UseCODay     :  Boolean) :  Real;

Function GetMultiRecAddr(Func      :  Integer;
                         LockType  :  Integer;
                     Var Key2S     :  Str255;
                         KeyPth    :  Integer;
                         Fnum      :  Integer;
                         Wait      :  Boolean;
                     Var Locked    :  Boolean;
                     Var LRecAddr  :  LongInt) : Boolean;

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Boolean;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETDateU,
   ETMiscU,
 {$IFDEF WIN32}
   BtrvU2,
 {$ELSE}
   BtrvU16,
 {$ENDIF}
   BTKeys1U,
   ComnUnit,
   BtS1,
   FIFOLU,BTSFr;


Const
  StkAdjCnst     :  Array[BOff..BOn] of Integer    = (-1, 1);
  StkOpoSet      =  [SCR,SJC,SRF,PIN,PJI,PPI,PDN];        {* Docs crediting Stock *}
  StkPUpSet      =  [PIN,PPI,PJI,PDN];   {* Docs which update the Last cost price *}


{ ================ Procedure to Reset Current Record ============== }

Procedure ResetRec(FNum  :  Integer);

Begin
  Case Fnum of
    CustF    :  FillChar(Cust,FileRecLen[FNum],0);
    InvF     :  FillChar(Inv,FileRecLen[FNum],0);
    IdetailF :  FillChar(Id,FileRecLen[FNum],0);
    NomF     :  FillChar(Nom,FileRecLen[FNum],0);
    StockF   :  FillChar(Stock,FileRecLen[FNum],0);
    NHistF   :  FillChar(NHist,FileRecLen[FNum],0);
    IncF     :  FillChar(Count,FileRecLen[FNum],0);
    PWrdF    :  FillChar(PassWord,FileRecLen[FNum],0);
    MiscF    :  FillChar(MiscRecs^,FileRecLen[FNum],0);
    SysF     :  FillChar(Syss,FileRecLen[FNum],0);
    ReportF  :  FillChar(RepScr^,FileRecLen[FNum],0);
  end; {Case..}
end;

{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure SetDataRecOfs(FNum     :  Integer;
                        Ofset    :  LongInt);

Begin
  Case FNum  of
    CustF     :  Move(Ofset,Cust,Sizeof(Ofset));
    InvF      :  Move(Ofset,Inv,Sizeof(Ofset));
    IdetailF  :  Move(Ofset,Id,Sizeof(Ofset));
    NomF      :  Move(Ofset,Nom,Sizeof(Ofset));
    StockF    :  Move(Ofset,Stock,Sizeof(Ofset));
    NHistF    :  Move(Ofset,NHist,Sizeof(Ofset));
    IncF      :  Move(Ofset,Count,Sizeof(Ofset));
    PWrdF     :  Move(Ofset,PassWord,Sizeof(Ofset));
    MiscF     :  Move(Ofset,MiscRecs^,Sizeof(Ofset));
    SysF      :  Move(Ofset,Syss,Sizeof(Ofset));
    ReportF   :  Move(Ofset,RepScr^,Sizeof(OfSet));
  end; {Case..}
end;


Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);
Begin
  Move(Ofset,DataRec,Sizeof(Ofset));
end;


{ ============== Get Profit To Current Period ============== }

Function Total_Profit_To_Date(NType        :  Char;
                              NCode        :  Str20;
                              PCr,PYr,PPr  :  Byte;
                          Var Purch,PSales,
                              PCleared,
                              PBudget      :  Real;
                              Range        :  Boolean)  :  Real;
Const
  Fnum  =  NHistF;
  NPath =  NHK;
Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Bal          :  Double;
Begin
  Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0;
  NHChK:=FullNHistKey(NType,NCode,PCr,PYr,PPr);
  If (Range) then
    NHKey:=FullNHistKey(NType,NCode,PCr,AdjYr(PYr,BOff),YTD)
  else
    NHKey:=NHChk;
  If (NType In YTDSet+[NomHedCode,CustHistCde,CustHistPCde]) then  {** Get Last Valid YTD **}
  Begin
    NHKey2:=NHKey;
    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey2);
    If (StatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (NHist.Pr=YTD) then
      NHKey:=NHKey2;
  end;
  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);
  While (StatusOK) and (NHKey<=NHChk) do
  With NHist do
  Begin
    If ((NType<>CustHistCde) or (Not (Pr In [YTD,YTDNCF]))) then
    Begin
      Purch:=Purch+Purchases;
      PSales:=PSales+Sales;
    end;
    Bal:=Bal+(Purchases-Sales);
    PCleared:=PCleared+Cleared;
    PBudget:=PBudget+Budget;
    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);
  end;
  Total_Profit_To_Date:=Bal;
end; {Func..}

{ ============== Get Profit To Current Period ============== }

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str10;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Real;
                        Range        :  Boolean)  :  Real;
Var
{  PBudget  :  Double;}
  PBudget  :  Real;
Begin
  PBudget:=0;
  Profit_To_Date:=Total_Profit_to_Date(NType,NCode,PCr,PYr,PPr,Purch,PSales,PCleared,PBudget,Range);
end; {Func..}

{ =========== Function to Check Exsistance of Given Code without disturbing record ========= }

Function  CheckExsists(KeyR  :  Str255;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;
Var
  KeyS     :  Str255;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;
Begin
  KeyS:=KeyR;
  TmpFn:=F[FileNum];
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);
  CEStatus:=Find_Rec(B_GetGEq+B_KeyOnly,TmpFn,FileNum,RecPtr[FileNum]^,KeyPath,KeyS);
  CheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));
  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);
end;


{ =========== Function to Check Exsistance of Given Code and return record if found ========= }

Function  CheckRecExsists(KeyR  :  Str255;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;
Var
  KeyS     :  Str255;
  TmpFn    :  FileVar;
  TmpStat,
  TmpKPath,
  CEStatus :  Integer;
  TmpRecAddr
           :  LongInt;
Begin
  KeyS:=KeyR;
  TmpFn:=F[FileNum];
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);
  CEStatus:=Find_Rec(B_GetGEq,TmpFn,FileNum,RecPtr[FileNum]^,KeyPath,KeyS);
  If (CEStatus<>0) then
    ResetRec(FileNum);

  CheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));
  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);
end;


{ ================== Procedure to Delete all Records Matching a give Code ============= }

Procedure DeleteLinks (Code  :  Str255;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer;
                       DelInv:  Boolean);

Var
  KeyS  :  Str255;
  Locked:  Boolean;

Begin
  KeyS:=Code;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) and ((Not DelInv) or ((DelInv) and (Id.LineNo<> RecieptCode))) do
  Begin
    If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPth,Fnum,BOn,Locked)) then
      Status:=0;
    If (StatusOk) and (Locked) then
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);
    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
  end;
end;

{ ================ Procedure to Compare Search Keys ============= }

Function CheckKey(KeyRef,Key2Chk  :  Str255;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;
Begin
  If (Length(Key2Chk)>=KeyLen) then
    CheckKey:=(UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
  else
    CheckKey:=False;
end;

{ =============== Function to Compare Search Keys by Range ================== }

Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  Str255;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;
Begin
  If (KeyRef2='') then
    KeyRef2:=KeyRef;     { Set To Main Compatibility }
  If (Length(Key2Chk)>=KeyLen) then
    CheckKeyRange:=((UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)>=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs)) and
                    (UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)<=UpcaseStrList(Copy(KeyRef2,1,KeyLen),AsIs)))
  else
    CheckKeyRange:=False;
end;

{ ============ Lock via a DirectCall ============ }

Function Lock_Direct(Func  :  Integer;
                     Fnum  :  Integer;
                     KeyPth:  Integer)  :  Integer;


Var
  LockCode  :  Integer;
  RecAddr   :  LongInt;



Begin
  LockCode:=GetPos(F[Fnum],Fnum,RecAddr);

  If (LockCode=0) then
  Begin
    SetDataRecOfs(Fnum,RecAddr);

    LockCode:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Func);
  end;

  Lock_Direct:=LockCode;

end;


{ ================ Procedrue to Check for Duplicate XXX Records,.. ===}

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80)  :   Boolean;

Var
  Sure  :  Boolean;
  TmpCh :  Char;
  Count :  Byte;

  TmpStat,
  TmpKPath
        :  Integer;
  TmpRecAddr
        :  LongInt;

  TmpFn :  FileVar;

  MbRet :  Word;

Begin
  TmpFn:=F[Fnum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  Status:=Find_Rec(B_GetEq+B_KeyOnly,TmpFn,Fnum,RecPtr[Fnum]^,KeyP,KeyS);

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

  If (Status=0) then
  Begin
    mbRet:=MessageDlg('That '+DupliP+' already exists!',
                       mtWarning,[mbOk],0);

  end
  else If (Debug) and (Status<>4) then Status_Means(Status);

  Check4DupliGen:=(Status=0);

end;



{ =========== Report IOError =========== }


Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);


Const
  IOMess1  =  ' WARNING! - I/O Error ';
  IOMess3  =  ' in file';


Var
  mbRet  :  Word;

Begin
  If (IOCode<>0) then
  Begin

    MbRet:=MessageDlg(IOMess1+#13+IOError(IOCode)+IOMEss3+#13+Fname,mtError,[mbOk],0);
  end;

end;

{ =========== Get MultiUser System File =========== }


Procedure GetMultiSys(Wait         :  Boolean;
                      Var  Locked  :  Boolean;
                           SysMode :  SysRecTypes);

Var
  TempSys  :  Sysrec;
  Key2F    :  Str255;


Begin

  TempSys:=Syss;

  Key2F:=SysNames[SysMode];


  If (Not Locked) then
  Begin
    Status:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

    Locked:=BOn;

    If (Debug) then Status_Means(Status);

  end
  else
    If (GetMultiRec(B_GetEq,B_MultLock,Key2F,0,SysF,Wait,Locked)) then
      Status:=0;


  If (StatusOk) and (Locked) then
  Begin
    Status:=GetPos(F[SysF],SysF,SysAddr[SysMode]);

    Case SysMode of
      SysR  :  TempSys:=Syss;
      VATR  :  Move(Syss,SyssVAT^,Sizeof(SyssVAT^));
      CurR  :  Move(Syss,SyssCurr^,Sizeof(SyssCurr^));
      DEFR  :  Move(Syss,SyssDEF,Sizeof(SyssDEF));
    end;
  end; {If Ok..}

  Syss:=TempSys;
end;





{ =========== Put MultiUser System File =========== }

Procedure PutMultiSys(SysMode  :  SysRecTypes;
                      UnLock   :  Boolean);

Var
  TempSys  :  SysRec;

Begin
  TempSys:=Syss;

  ResetRec(SysF);

  SetDataRecOfs(SysF,SysAddr[SysMode]);

  Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

  If (StatusOk) then
  Begin


    Case SysMode of
      DEFR  :  Move(SyssDEF,Syss,Sizeof(SyssDEF));
      VATR  :  Move(SyssVAT^,Syss,Sizeof(SyssVAT^));
      CurR  :  Move(SyssCurr^,Syss,Sizeof(SyssCurr^));
      SysR  :  Syss:=TempSys;
    end;{Case..}


    Status:=Put_Rec(F[SysF],SysF,RecPtr[SysF]^,0);
  end;


{  Report_BError(SysF,Status);}

  If (UnLock) and (StatusOk) then
  Begin
    Status:=UnlockMultiSing(F[SysF],SysF,SysAddr[SysMode]);

    If (Debug) then
      Status_Means(Status);
  end;

  Syss:=TempSys;

end;

{ ================== Read-In all 3 system files ================== }

Procedure Init_AllSys;

Var
  TmpIO     :  Integer;
  SysCount  :  SysrecTypes;

Begin

  For SysCount:=SysR to CurR do
  Begin
    GlobLocked:=BOff;
    GetMultiSys(BOff,GlobLocked,SysCount);
  end;

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
      'A'  :  ModeVal:=4;

      {$IFDEF SOP}
        'R'  :  ModeVal:=5;
      {$ELSE}
        'R'  :  ModeVal:=1;
      {$ENDIF}

      'S'  :  ModeVal:=6;

    end; {Case..}

    FIFO_Mode:=ModeVal;

  end; {Func..}

  { ====== Is FIFO ====== }

  Function Is_FIFO(CMode  :  Char)  :  Boolean;

  Begin

    Is_FIFO:=(FIFO_Mode(CMode) In [2..3]);

  end;

{ ================== Function to Calculate Discount Amount ============== }

Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;


Begin
  If (DiscCh=PcntChr) then
    Calc_PAmount:=(FullAmount*DiscAmnt)
  else
    Calc_PAmount:=DiscAmnt;
end;

// MH 24/03/2009: Created extended version with support for extra Advanced Discounts fields  //PR: 24/03/2009 Copied from ComnU2
Function Calc_PAmountAD (FullAmount, DiscAmnt :  Real;
                         DiscCh               :  Char;
                         Disc2Amnt            :  Real;
                         Disc2Ch              :  Char;
                         Disc3Amnt            :  Real;
                         Disc3Ch              :  Char)  :  Real;
Var
  NewDiscBasis : Real;
Begin
  // MH 25/03/2009: Removed rounding as EL doesn't use rounding when calculating Line Discount + Settle Discount

  Result := {Round_Up(}Calc_PAmount(FullAmount, DiscAmnt, DiscCh){, RoundDecs)};

  // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
  If (Disc2Amnt <> 0.0) Then
  Begin
    NewDiscBasis := {Round_Up(}FullAmount - Result{, RoundDecs)};
    Result := Result + {Round_Up(}Calc_PAmount(NewDiscBasis, Disc2Amnt, Disc2Ch){, RoundDecs)};
  End; // If (Disc2Amnt <> 0.0)
  If (Disc3Amnt <> 0.0) Then
  Begin
    NewDiscBasis := {Round_Up(}FullAmount - Result{, RoundDecs)};
    Result := Result + {Round_Up(}Calc_PAmount(NewDiscBasis, Disc3Amnt, Disc3Ch){, RoundDecs)};
  End; // If (Disc3Amnt <> 0.0)
end;



{ ======== Function to Check for empty Stock Line ======== }

Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

Begin

  Is_FullStkCode:=((Not EmptyKey(SCode,StkKeyLen)) and (Not IS_PayInLine(SCode)));

end;

{ ============ Calculate Amount O/S ============ }

Function TotalOs(InvR  :  InvRec)  :  Real;


Begin
  With InvR do
  Begin
    TotalOs:=Round_Up((Itotal(InvR)-Settled),2);
  end;
end;

{ ============== Function to Return Line Cnst Based on Payment Type =========== }

Function LineCnst(P  :  Char)  :  Integer;

Begin
  If (P=DocPayType[SIN]) then
    LineCnst:=-1
  else
    LineCnst:=1;
end;


 { ==================== Calculate One Line of Invoice ================= }

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
  UseDecs
        :  Byte;


Begin
  With Idr do
  Begin
    Cnst:=LineCnst(Payment);

    RNum:=0; WithDisc:=0;

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
      end
      else
        PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);

    end
    else
      PriceEach:=NetValue;


    // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts //PR: 25/03/2009 Copied from ComnU2
    //Rnum:=Calc_PAmount(Round_Up(DiscBasis,UseDecs),Discount,DiscountChr);
    Rnum:=Calc_PAmountAD(Round_Up(DiscBasis,UseDecs),Discount,DiscountChr, Discount2, Discount2Chr, Discount3, Discount3Chr);

    WithDisc:=Round_Up(LineQty*(Round_Up(PriceEach,UseDecs)-Rnum),FinDecs);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,(Inv.DiscSetl*Ord(UseSetl)),PcntChr),FinDecs);

    If (UseDisc) then
      DetLTotalND:=(WithDisc*Cnst)
    else
      DetLTotalND:=Round_Up((LineQty*Round_Up(PriceEach,UseDecs)*Cnst),FinDecs);
  end;{With..}
end;




Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean)  :  Double;


Begin
  DetLTotal:=DetLTotalND(IdR,UseDisc,UseSetl,BOff);
end;


{ Use Company/Day Rate  - Set to True if Use Xchange rate has been chosen, False if Use Co Rate }

Function  UseCoDayRate  :  Boolean;

Begin
  UseCoDayRate:=(Syss.TotalConv=XDayCode);
end;


{ Convert to Current day rate, Selected Doc.Co/Day Rate or Current Co. }

Function XRate(CXRate  :  CurrTypes;
               CurDRte :  Boolean;
               Currency:  Byte)  :  Real;



Var
  Trate  :  Real;


Begin
  Trate:=0;

  With SyssCurr^.Currencies[Currency] do
  Begin

    If (CurDRte) then
      Trate:=CRates[BOn]
    else
      If (CXRate[UseCoDayRate]<>0) then
        Trate:=CXRate[UseCoDayRate]
      else
        Trate:=CRates[BOff];
  end; {With..}

  XRate:=Trate;
end; {Func..}



{  Convert from one currency to another }

Function  Conv_Curr(Amount  :  Real;
                    Rate    :  Real;
                    Too     :  Boolean)  :  Real;

Var
  NewAmnt  :  Real;



Begin
  NewAmnt:=0;

  If (Too) then
    NewAmnt:=Amount*Rate
  else
    If (Rate<>0) then
      NewAmnt:=Amount/Rate;

  Conv_Curr:=NewAmnt;
end;

{  Convert from one currency via Default currency to another }

Function  Currency_ConvFT(Amount  :  Real;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Real;

Var
  NewAmnt  :  Real;



Begin
  With SyssCurr^.Currencies[Fc] do
    NewAmnt:=Conv_Curr(Amount,CRates[UseRate],BOff);

  With SyssCurr^.Currencies[Ft] do
    Currency_ConvFT:=Conv_Curr(NewAmnt,CRates[UseRate],BOn);

end;



{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;
  TmpVal:  Real;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    TmpVal:=0;

    TmpVal:=Round_Up(Conv_Curr(InvNetVal,Rate,BOff),Dp)+Round_Up(Conv_Curr(InvVat,CXRate[BOn],BOff),Dp)-
            Round_Up(Conv_Curr(DiscAmount,Rate,BOff),Dp)+Round_Up((Variance*Ord(UseVariance)),Dp)+
            Round_Up(ReValueAdj,Dp)-Round_Up((Conv_Curr(DiscSetAm,Rate,BOff)*Ord(DiscTaken)),Dp);
    ConvCurrITotal:=TmpVal;
  end;
end;


{ ============ Calculate Amount O/S ============ }

Function BaseTotalOs(InvR  :  InvRec)  :  Real;


Begin
  With InvR do
  Begin
    If (Not (InvDocHed In QuotesSet)) then  {* SQU,PQU *}
      BaseTotalOs:=Round_Up(((ConvCurrITotal(InvR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst)-Settled),2)
    else
      BaseTotalOS:=0.0;
  end;
end;


{ =============== Return Own Currency O/S Total ============== }

Function  CurrencyOS(IRec         :  InvRec;
                     UseRound,
                     SterEquiv,
                     UseCODay     :  Boolean) :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    If (SterEquiv) then
      Rate:=XRate(CXRate,UseCODay,Currency)
    else
      Rate:=1;

    CurrencyOs:=Round_Up(Conv_Curr(((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled),Rate,BOff),Dp);

  end;
end;

Function GetMultiRecAddr(Func      :  Integer;
                         LockType  :  Integer;
                     Var Key2S     :  Str255;
                         KeyPth    :  Integer;
                         Fnum      :  Integer;
                         Wait      :  Boolean;
                     Var Locked    :  Boolean;
                     Var LRecAddr  :  LongInt) : Boolean;

Var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;

Begin
  Locked:=BOff; Fcode:=0;

  TmpForm:=NIL;

  BCode:=Try_Lock(Func,(B_SingNWLock+LockType),Key2S,Keypth,Fnum,RecPtr[Fnum]);


  If (Bcode<>0) then
  Case Bcode of

         84,85  {$IFDEF Su_On}

              :  Begin
                   mbRet:=MessageDlg('Network Violation! - Closing System',
                                      mtError,[mbOk],0);

                   Halt;
                 end;

              {$ELSE}


              :  If (Not Wait) then
                 Begin
                   {* Establish if record found at all *}

                   Fcode:=Find_Rec(Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Key2s);

                   Repeat

                     mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                     BCode:=Try_Lock(Func,(B_SingNWLock+LockType),Key2S,Keypth,Fnum,RecPtr[Fnum]);

                   Until (MbRet=IdCancel) or (Bcode=0);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   TmpForm:=TBTWaitLock.Create(Application.Mainform);


                   Try

                     TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,RecCPtr(RecPtr[Fnum]));

                     BCode:=(TmpForm.ShowModal - mrOk);

                   Finally

                     TmpForm.Free;

                   end;

                   Locked:=(Bcode=0);

                 end;

               {$ENDIF}



       22      : Begin
                   Locked:=(VariFile[Fnum]);
                   If (Locked) then
                     Bcode:=0;
                 end;


  end {Case..}
  else
    Locked:=BOn;

  Addch:=#0; {* Reset Lock Key *}

  GetMultiRecAddr:=(Bcode=0);

  If (BCode=0) then
    BCode:=GetPos(F[Fnum],Fnum,LRecAddr);

end;


{ ======= General Routine to Atempt a Record Lock ========= }

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Boolean;

Var
  LRecAddr  :  LongInt;

Begin

  LRecAddr:=0;

  GetMultiRec:=GetMultiRecAddr(Func,LockType,Key2S,Keypth,Fnum,Wait,Locked,LRecAddr);

end;



end.

