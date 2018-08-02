{$A-,B-,C-,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q-,R+,S+,T-,U+,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$A-,B-,C-,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q-,R+,S+,T-,U+,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}

unit BTS2;

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
  GlobVar,
  VarConst;

(*
Const
  GenRealMask   =  '###,###,##0.00 ;###,###,##0.00-';
  GenQtyMask   =  '0';
  GenPcntMask   =  '0.00%';
  CustKeyLen    =  6;
  StkKeyLen     =  16;
  DocKeyLen     =  9;
  WM_CustGetRec    = WM_User+$1;
  WM_FormCloseMsg  =  WM_User+$2;

Function FullNHCode(CCode  :  Str20) :  AnyStr;

Function FullNCode(CCode  :  Str10) :  AnyStr;

Function FullNomKey(ncode  :  Longint)  :  Str20;

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Function FullCustCode(CCode  :  Str10)  :  Str10;

Function FullOurRefKey(DCode  :  Str10)  :  Str10;

Function FullStockCode(CCode  :  Str20)  :  Str20;

Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;

Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;

Function FullQDKey (RC,ST        :  Char;
                    Login        :  Str30)  :  Str30;


Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;

Function MakeFIKey (SFOL         :  LongInt;
                    SDate        :  Str8)  :  Str30;

Function MakeFIDocKey (DNo          :  Str10;
                       SFOL,
                       DLNo         :  LongInt)  :  Str30;



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


Procedure Close_Files(ByFile  :  Boolean);



Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

Function Full_StkBOMKey(SFol,
                        SLNo  :  LongInt)  :  Str20;

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


Function FIFO_Mode(CMode  :  Char)  :  Byte;

Function Is_FIFO(CMode  :  Char)  :  Boolean;


Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;

Procedure ShowDrCr(    Amount  :  Real;
                   Var DrCr    :  DrCrType);


*)


(*
Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

Function ITotal(IRec  :  InvRec)  :  Real;

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

*)

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   ETStrU,
   ETDateU,
   ETMiscU,
   BtrvU2,
{   BTSupU1,}
   BTKeys1U,
   SysU2,
   ComnUnit,
   ComnU2,
   CurrncyU,
   BtS1,
   FIFOLU;


Const
  StkAdjCnst     :  Array[BOff..BOn] of Integer    = (-1, 1);
  StkOpoSet      =  [SCR,SJC,SRF,PIN,PJI,PPI,PDN];        {* Docs crediting Stock *}
  StkPUpSet      =  [PIN,PPI,PJI,PDN];   {* Docs which update the Last cost price *}



(*

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
      'R'  :  ModeVal:=5;
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


{ ========= Function to Return Match Doc Code ========== }


Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

Begin
  FullMatchKey:=Rc+St+LJVar(Login,DocLen);
end;


{ ======= Return Full BOM Ndx ======== }

Function Full_StkBOMKey(SFol,
                        SLNo  :  LongInt)  :  Str20;
Begin

  Full_StkBOMKey:=FullNomKey(SFOL)+Dec2Hex(SLNo);

end;

{ ============ Function to set AllowHot key =========== }

Procedure SetAllowHotKey(State      :  Boolean;
                     Var PrevState  :  Boolean);

Begin
  Case State of

    BOff  :  Begin
               PrevState:=AllowHotKey;
               AllowHotKey:=State;
             end;
    BOn   :  AllowHotKey:=PrevState;

  end; {Case..}

end;

(*
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
*)

(*
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

*)
(*
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

*)






(*
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

{ ======== Function to Check for empty Stock Line ======== }

  Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

  Begin

    Is_FullStkCode:=((Not EmptyKey(SCode,StkLen)) and (Not IS_PayInLine(SCode)));

  end;

  { =============== Return Invoice Total ============== }

Function ITotal(IRec  :  InvRec)  :  Real;

  Begin

    With IRec do
      ITotal:=(InvNetVal+InvVat)-DiscAmount-(DiscSetAm*Ord(DiscTaken));
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

  With SyssCurr.Currencies[Currency] do
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
  With SyssCurr.Currencies[Fc] do
    NewAmnt:=Conv_Curr(Amount,CRates[UseRate],BOff);

  With SyssCurr.Currencies[Ft] do
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


*)

(*  UpcaseStr converts a string to upper case *)
(*
function UpcaseStr(S : Str80) : Str80;
var
  P : Integer;
begin
  for P := 1 to Length(S) do
    S[P] := Upcase(S[P]);
  UpcaseStr := S;
end;

function UpcaseStrList(S     : Str80;
                       AsIs  : Boolean) : Str80;

Begin
  If (AsIs) then
    UpCaseStrList:=S
  else
    UpCaseStrList:=UpCaseStr(S);
end; {Func..}



{ ================ Various Key builders ============= }

Function FullCustCode(CCode  :  Str10)  :  Str10;
Begin
  Result:=LJVar(CCode,AccLen);
end;

{ ========= Function to Return Full Nominal Key ========== }

Function FullNomKey(ncode  :  Longint)  :  Str20;
Var
  TmpStr  :  Str20;
Begin
  Blank(TmpStr,Sizeof(TmpStr));
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0]:=Chr(Sizeof(ncode));
  FullNomKey:=TmpStr;
end;

{ ======== Function to Return Full OurRef Key =========== }

Function FullOurRefKey(DCode  :  Str10)  :  Str10;
Begin
  FullOurRefKey:=LJVar(DCode,DocLen);
end; {Func..}

{ ========= Function to Return Detail Key Link ========== }

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;
Begin
  FullIdKey:=Strip('R',[#0],FullNomKey(Ino)+FullNomKey(Lno));
end;

{ ================ Function to return Stock Code ============= }

Function FullStockCode(CCode  :  Str20)  :  Str20;
Begin
  Result:=LJVar(CCode,StkLen);
end;

Function FullNHCode(CCode  :  Str20) :  AnyStr;
Begin
  FullNHCode:=LJVar(Ccode,NHCodeLen);
end;

{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullNCode(CCode  :  Str10) :  AnyStr;
Begin
  FullNCode:=LJVar(Ccode,AccLen);
end;

{ ========= Function to Return Part Nominal History Key ========== }

Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;
Begin
  PartNHistKey:=Typ+FullNHCode(Code)+Chr(Cr);
end;

Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;
Begin
  FullNHistKey:=PartNHistKey(Typ,Code,Cr)+Chr(Yr)+Chr(Pr);
end;

{ ========= Function to Return Part Cost Code ========== }

Function  PartCCKey (RC,ST        :  Char)  :  Str20;
Begin
  PartCCKey:=Rc+St;
end;

{ ========= Function to Return Qty Disc Code ========== }

Function FullQDKey (RC,ST        :  Char;
                    Login        :  Str30)  :  Str30;
Begin
  FullQDKey:=PartCCKey(Rc,St)+Login;
end;

  { ========= Function to MAke FIFI Code ========== }

Function MakeFIKey (SFOL         :  LongInt;
                    SDate        :  Str8)  :  Str30;
Begin
  MakeFIKey:=FullNomKey(SFOL)+SDate;
end;
    { ========= Function to MAke FIFI Doc Code ========== }

Function MakeFIDocKey (DNo          :  Str10;
                       SFOL,
                       DLNo         :  LongInt)  :  Str30;
Begin
  MakeFIDocKey:=FullOurRefKey(DNo)+FullNomKey(SFOL)+FullNomKey(DLNo)+HelpKStop;
end;

{ ==============  Function to Return an intelligent guess on finding a document =========== }

Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;
Var
  TmpK,TmpNo  :  Str255;
  TmpPrefix   :  Str5;
  LenPrefix   :  Byte;
Begin
  TmpPrefix:='';
  TmpNo:='';
  TmpK:=UpcaseStr(Strip('B',[#32],InpKey));
  LenPrefix:=Length(DocCodes[SIN]);
  TmpPrefix:=Copy(TmpK,1,LenPreFix);
  TmpNo:=Strip('L',['0'],Copy(TmpK,Succ(LenPrefix),(Length(TmpK)-LenPrefix)));
  TmpK:=TmpPrefix+SetPadNo(TmpNo,(IKNo-LenPreFix));
  AutoSetInvKey:=LJVar(TmpK,IKNo);
end; {Function..}

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

*)
(*
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




{ ======= Lower Level Routine to Atempt a Record Lock ========= }

Function Try_Lock(Func      :  Integer;
                  LockType  :  Integer;
              Var Key2S     :  Str255;
                  KeyPth    :  Integer;
                  Fnum      :  Integer)  :  Integer;


Begin

   If (Func<>B_GetDirect) then
    Try_Lock:=Find_Rec(Func+LockType,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Key2s)
  else
    Try_Lock:=Lock_Direct(LockType,Fnum,KeyPth);

end; {Func..}




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


{ ============= Close All Open Files ============= }

Procedure Close_Files(ByFile  :  Boolean);


Var
  Choice  :  Byte;

Begin

  For Choice:=1 to TotFiles do
    Status:=Close_File(F[Choice]);

{$I-}
  If (Debug) or (ByFile) or (ResetBtOnExit) then
    Status:=Reset_B
  else
    Status:=Stop_B;

  If (Debug) then
    Status_Means(Status);

  {$I+}
end;




{ ========== Function to calculate line total ========= }

Function InvLTotal(Idr       :  IDetail;
                   UseDisc   :  Boolean)  :  Double;

Var
  DiscValue  :  Double;

Begin

  With Idr do
  Begin
    If (UseDisc) then
      DiscValue:=Round_Up(Pcnt(Discount)*NetValue,2)
    else
      DiscValue:=0;

    Result:=Round_Up(Qty*(Netvalue-DiscValue),2);

  end; {With..}

end; {Func..}


{ ========== Function to calculate line Cost ========= }

Function InvLCost(Idr       :  IDetail)  :  Double;


Begin

  With Idr do
  Begin

    Result:=Round_Up(Qty*CostPrice,2);

  end; {With..}

end; {Func..}




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



*)
(*

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


  Report_BError(SysF,Status);

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
  TmpIO  :  Integer;

Begin

  For SysCount:=SysR to CurR do
  Begin
    GlobLocked:=BOff;
    GetMultiSys(BOff,GlobLocked,SysCount);
  end;

end;


  { ========= Function to return full Stock code ======== }

  Function FullStockCode(CCode  :  Str20) :  AnyStr;

  Begin
    FullStockCode:=UpcaseStr(LJVar(Ccode,StkLen));
  end;

  
*)



end.

