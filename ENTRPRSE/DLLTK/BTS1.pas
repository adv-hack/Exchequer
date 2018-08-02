unit BTS1;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{* This Unit is used by both 16 bits and 32 bits -
   although somes functions are in shared units,
   return value is different to return Result Value. *}

interface

Uses
  {$IFDEF WIN32}
    Windows,
    BtrvU2,
  {$ELSE}
    BtrvU16,
    WinTypes,
    WinProcs,
  {$ENDIF}
  Messages,
  GlobVar,
  {$IFDEF WIN32}
    VarRec2U,
    InvCTSuU,
    MiscU,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3,
  VarJCStu;


Function GetNextCount(DocHed     :  DocTypes;
                      Increment,
                      UpLast     :  Boolean;
                      NewValue   :  Real;
                  Var RetCount   :  LongInt;
                      EBisCounter :  string)      :  Integer;

Function DocTypeFCode(DocStr  :  Str5)  :  DocTypes;

Function GetDocType(DocStr  :  Str5;
                 Var DT      :  DocTypes)  :  Integer;

Function FullDocNum(DocHed    :  DocTypes;
                     Increment :  Boolean;
                     PadLen    :  Byte;
                 Var RetCount  :  Str20)      :  Integer;

Function FullEBisDocNum(const DocHed    :  string;
                        Increment :  Boolean;
                        PadLen    :  Byte;
                        Var RetCount  :  Str20)      :  Integer;

Procedure GenSetError(ValidRec  :  Boolean;
                      ErrNo     :  Integer;
                  Var Res       :  Integer;
                  Var VHed      :  Boolean);

Procedure Calc_PrYr(PStr,YStr  :  Str5;
                Var RPr,RYr    :  Byte);

Function Fin_Yr(IDate  :  Str8)  :  SmallInt;

Function Fin_Pr(IDate  :  Str8)  :  Byte;

Function UpdateExBal(UInv   :  InvRec;
                     BalAdj,
                     CosAdj,
                     NetAdj :  Real;
                     Deduct :  Boolean;
                     Mode   :  Byte)  :  Integer;

{$IFNDEF WIN32}
Procedure Stock_Deduct(Var IdR     :  IDetail;
                           LInv    :  InvRec;
                           Deduct,
                           GetSRec :  Boolean;
                           Mode    :  Byte);

{$ENDIF}
Procedure Stock_MLocDeduct(Var IdR       :  IDetail;
                               DeductQty :  Double;  {StockPos  :  StockPosType;}
                               DCnst     :  Integer;
                               GetSRec   :  Boolean;
                               Mode      :  Byte);

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;

Function Full_MLocSKey(lc  :  Str10;
                       sc  :  Str20)  :  Str30;

Function Full_MLocLKey(lc  :  Str10;
                       sc  :  Str20)  :  Str30;


Procedure Gen_JMajorHed(JobR  :  JobRecType);

Procedure SetNextDocNos(Var  InvR     :  InvRec;
                             SetOn    :  Boolean;
                             OWRefNo  :  Boolean);

//PR: 19/03/2009 Added functions to allow Importer to create Auto Transactions
Procedure SetNextAutoDocNos(Var  InvR  :  InvRec;
                                 SetOn :  Boolean);



Function SetNextSFolio(DocHed     :  DocTypes;
                       SetOn      :  Boolean;
                       SMode      :  Byte)  :  LongInt;

Function FullPayInKey(RefNo  :  Str20)  :  Str20;


Procedure UpdateCustOrdBal(OI,IR  :  InvRec; PreviousOS : Double = 0);

Procedure Set_DocAlcStat(Var  InvR  :  InvRec);

    Procedure Check_SOPLink(Fnum,
                            KeyPath  :  Integer;
                            FolRef   :  LongInt;
                            DelDate  :  LongDate);

    Procedure Update_SOPLink(Idr     :  IDetail;
                             Deduct,
                             UpHed,
                             Warn    :  Boolean;
                             Fnum,
                             Keypath,
                             KeyResP :  Integer);

  function CheckDocNo(const DocNo : string) : Boolean;

  Function  CheckKeyExists(KeyR  :  AnyStr;
                           FileNum,KeyPath
                                 :  Integer)  :  Boolean;

  //PR: 19/06/2012 ABSEXCH-11528 Function to return required o/s value including or excluding VAT as required by system setup
  function TransOSValue(InvR : InvRec) : Double;

//PR: 14/04/2014 ABSEXCH-12703 Added to interface so it can be called from ConvDocu
Procedure UpdateOrdBal(UInv   :  InvRec;
                       BalAdj :  Real;
                       CosAdj,
                       NetAdj :  Real;
                       Deduct :  Boolean;
                       Mode   :  Byte);

//AP: 17/08/2017 ABSEXCH-18408:COM Toolkit Not Updating POR B2B Matching Value on Edit - Added to interface
Procedure Update_MatchPay(DocRef,
                            MatchDoc :  Str10;
                            AddT,
                            AddN     :  Real;
                            Deduct   :  Boolean;
                            MTyp     :  Char);

function IntrastatEnabled : Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETMiscU,
  ETStrU,
  Controls,
  Dialogs,
  SysUtils,
  Forms,
{$IFDEF WIN32}
  BTSupU1,
  ComnU2,
  SysU2,
  CurrncyU,
  BTKeys1U,
  ComnUnit,
{$ELSE}
  BTSup1,
  BTSup2,
{$ENDIF}
  ETDateU,
  FIFOLU,
  EBusTKit,
  ExWrap1U,
  Classes,
  Profile,
  TKSQLCallerU,
  SQLUtils,
  MathUtil,
  SavePos;

Const
  StkAdjCnst     :  Array[BOff..BOn] of Integer    = (-1, 1);
  StkOpoSet      =  [SCR,SJC,SRF,PIN,PJI,PPI,PDN];        {* Docs crediting Stock *}
  StkPUpSet      =  [PIN,PPI,PJI,PDN];   {* Docs which update the Last cost price *}
  {* added on 26.11.97 for not updating TL's PIN,PDN Cost Price *}
  LocStkDedSet   = SalesSplit+PurchSplit-QuotesSet-OrderSet+StkAdjSplit;
  PIKeyLen       = 10;

const
  SQL_UPDATE_STKLOC = 'UPDATE [COMPANY].[MLocStk] SET LsQtyInStock = %g, LsQtyOnOrder = %g, LsQtyAlloc = %g, ' +
                      'LsQtyPicked = %g, LsMinFlg = %d, LsLastUsed = ''%s'', LsPCurrency = %d, LsCostPrice = %g, ' +
                      'LsRoCurrency = %d, LsRoPrice = %g ' +
                      'WHERE SUBSTRING(VarCode1, 2, %d) = ''%s''';

  SQL_LS_COLUMNS = 'LsQtyInStock, LsQtyOnOrder, LsQtyAlloc, LsQtyPicked, LsMinFlg, LsLastUsed, LsPCurrency, ' +
                   'LsCostPrice, LsRoCurrency, LsRoPrice';

var
  LogF : TStringList;
  sSQLQuery : AnsiString;

//PR: 01/07/2016 v2016 R2 ABSEXCH-17637 Only return true if both intrastat enabled in sys setup AND full stock licenced
function IntrastatEnabled : Boolean;
begin
  Result := Syss.Intrastat and FullStkSysOn;
end;

procedure LogIt(const s : string);
begin
  LogF.Add(FormatDateTime('hh:nn:ss:zzz', Time) + '> ' + s);
end;

  //PR: 18/11/2011 Added Location Override functions to allow toolkit to update costs on Stock records with Ave valuation method.
  Function LocOverride(lc    :  Str10;
                       Mode  :  Byte)  :  Boolean;

  Const
    Fnum  =  MLocF;

  Var
    TmpLoc  :  MLocPtr;

    LOk     :  Boolean;

    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;



  Begin
    Result:=BOff;

    begin
      New(TmpLoc);

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      TmpLoc^:=MLocCtrl^;

      LOk:=CheckRecExsists(MLocFixCode[True]+LJVar(lc,LocKeyLen),MLocF,MLK);

      With MLocCtrl^.MLocLoc do
      Case Mode of

        0  :  Result:=loUsePrice;
        1  :  Result:=loUseNom;
        2  :  Result:=loUseCCDep;
        3  :  Result:=loUseSupp;
        4  :  Result:={loUseBinLoc;}BOn;
        5  :  Result:=loUseCPrice;
        6  :  Result:=loUseRPrice;


      end; {Case..}

      Result:=(LOk and Result);

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MLocCtrl^:=TmpLoc^;

      Dispose(TmpLoc);

    end;
  end;


  Function LocOPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocOPrice:=LocOverride(lc,0);

  end;

  Function LocONom(lc  :  Str10)  :  Boolean;

  Begin
    LocONom:=LocOverride(lc,1);

  end;


  Function LocOCCDep(lc  :  Str10)  :  Boolean;

  Begin
    LocOCCDep:=LocOverride(lc,2);

  end;

  Function LocOSupp(lc  :  Str10)  :  Boolean;

  Begin
    LocOSupp:=LocOverride(lc,3);

  end;

  Function LocOCPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocOCPrice:=LocOverride(lc,5);

  end;


  Function LocORPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocORPrice:=LocOverride(lc,6);

  end;



{ ============ Function to Set Error, if not already set ============ }

Procedure GenSetError(ValidRec  :  Boolean;
                      ErrNo     :  Integer;
                  Var Res       :  Integer;
                  Var VHed      :  Boolean);

Begin
  If (Not ValidRec) then
  Begin
    If (Res=0) then
      Res:=ErrNo;
    VHed:=(Res=0);
  end;
end;


{ ============= Return Doc TYpe from Doc Code ============= }


Function DocTypeFCode(DocStr  :  Str5)  :  DocTypes;

Var

  m,
  n  :  DocTypes;

begin

  n:=SIN;

  m:=n;

  {$B-}

  (* 05.01.98 - Closed and added FOR loop to avoid Range Check Error ...
  
  {* Change API to JRN on 19.2.97 *}
  While (N<=JRN) and (Not CheckKey(DocStr,DocCodes[n],Length(DocStr),BOff)) do
    n:=Succ(n);
  *)
  For n:=Low(DocCodes) to High(DocCodes) do
  begin
    If (CheckKey(DocStr,DocCodes[n],Length(DocStr),BOff)) then
      m:=n;
  end;

  DocTypeFCode:=m;
end; {Func.}



Function GetDocType(DocStr  :  Str5;
                 Var DT      :  DocTypes)  :  Integer;

Begin

  DT:=DocTypeFCode(DocStr);

  If (DocCodes[DT]=DocStr) then
    Result:=0
  else
    Result:=30201;

end; {Function..}


{ ============= Procedure to Return debit / Credit ============= }

Procedure ShowDrCr(    Amount  :  Real;
                   Var DrCr    :  DrCrType);


Begin
  Blank(DrCr,SizeOf(DrCr));

  DrCr[(Amount<0)]:=ABS(Amount);
end;



{ ========= Procecdure to Inc/Dec Pr  ======== }

Procedure AdjPr(Var PYr,PPr  :  Byte;
                    ID       :  Boolean);

Begin
  If (ID) then
    If (PPr=Syss.PrInYr) then
    Begin
      Pyr:=AdjYr(PYr,BOn);
      PPr:=1;
    end
    else
      Inc(PPr)
  else
    If (PPr=1) then
    Begin
      Pyr:=AdjYr(PYr,BOff);
      PPr:=Syss.PrInYr;
    end
    else
      Dec(PPr);

end;


Procedure Calc_PrYr(PStr,YStr  :  Str5;
                Var RPr,RYr    :  Byte);

Var
  OffSet,
  DCnst  :  Boolean;
  n,m    :  Byte;

Begin
  RPr:=0; RYr:=Syss.CYr;

  DCnst:=BOff;

  OffSet:=((Pos('+',PStr)<>0) or (Pos('-',PStr)<>0) or (Pstr=YTDStr) or (IntStr(PStr)=0));

  If (OffSet) then
  Begin

    If (PStr=YTDStr) then
      RPr:=YTD
    else
    Begin
      DCnst:=(Pos('-',PStr)=0);

      n:=IntStr(Strip('B',[#32,'-','+'],PStr));

      RPr:=Syss.CPr;

      For m:=1 to n do
        AdjPr(RYr,RPr,DCnst);


    end;
  end
  else
    RPr:=IntStr(PStr);

  OffSet:=((Pos('+',YStr)<>0) or (Pos('-',YStr)<>0) or (IntStr(YStr)=0));

  If (OffSet) then
  Begin

    DCnst:=(Pos('-',YStr)=0);

    n:=IntStr(Strip('B',[#32,'-','+'],YStr));

    For m:=1 to n do
      RYr:=AdjYr(RYr,DCnst);

  end
  else
    RYr:=IntStr(YStr);

end; {Proc..}


{ =============== Procedure to GetNext Available Number ============== }

Function GetNextCount(DocHed     :  DocTypes;
                      Increment,
                      UpLast     :  Boolean;
                      NewValue   :  Real;
                  Var RetCount   :  LongInt;
                      EBisCounter :  string)      :  Integer;
{ For normal counter pass in EBisCounter as an empty string }
Var
  Key2F      :  Str255;
  TmpOk      :  Boolean;
  Lock       :  Boolean;
  TmpStatus  :  Integer;
  Cnt,NewCnt :  LongInt;

Begin
  TmpStatus := 4;
  Lock:=BOff;  Cnt:=0;  NewCnt:=0;

  Blank(Key2F,Sizeof(Key2F));

  if EBisCounter <> '' then
    Key2F := EBisCounter
  else
    Key2F:=DocNosXlate[DocHed];

  {$IFDEF WIN32}
  LogIt('GET [in ]');
  If (GetMultiRec(B_GetEq,B_SingLock,Key2F,IncK,IncF,BOn,Lock)) then
    TmpStatus:=0;
  {$ELSE}
  TmpStatus:=(GetMultiRec(B_GetEq,B_SingLock,Key2F,IncK,IncF,BOn,Lock));
  {$ENDIF}

  If (TmpStatus=0) and (Lock) then
  With Count do
  Begin
    Move(NextCount[1],Cnt,Sizeof(Cnt));
    LogIt('GET [out]Type: ' + CountTyp + '. Count: ' + IntToStr(Cnt));
    If (Increment)then
    Begin
      NewCnt:=Cnt+1;
      Move(NewCnt,NextCount[1],Sizeof(NewCnt));
    end;

    If (UpLast) then
      LastValue:=NewValue;

    If (Increment) or (UpLast) then
    begin
      LogIt('PUT [in ]');
      TmpStatus:=Put_Rec(F[IncF],IncF,RecPtr[IncF]^,IncK);
      LogIt('PUT [out] Type: ' + CountTyp + '. Count: ' + IntToStr(NewCnt) + '. Status = ' + IntToStr(Status));
    end
    else
      TmpStatus:=Find_Rec(B_Unlock,F[IncF],IncF,RecPtr[IncF]^,IncK,Key2F);

  end;
  If (TmpStatus<>0) then
    TmpStatus:=TmpStatus+31000;

  RetCount:=Cnt;
  Result:=TmpStatus;

end;
{ ========== Return Full DocNum ============= }


{$IFNDEF PREV561001}

  Const
    ExtendSuffix  :  Array[0..22] of Char = ('A','B','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','T','U','V','W','X','Y','Z');

  function CheckDocNo(const DocNo : string) : Boolean;
  var
    Last5, Code : Integer;
  begin
    Result := (DocNo <> '') and ((DocNo[1] in ['0'..'9']) or (StrPos(ExtendSuffix, PChar(Copy(DocNo, 1, 1))) <> nil));
    if Result then
    begin
      Val(Copy(DocNo, 2, 5),  Last5, Code);
      Result := Code = 0;
    end;
  end;


  Function FullDocNum(DocHed    :  DocTypes;
                      Increment :  Boolean;
                      PadLen    :  Byte;
                  Var RetCount  :  Str20)      :  Integer;



  Var
    SIdx
          :  Byte;

    VR    :  Integer;
    Lcnt,
    SVal  :  LongInt;

    SSufix:  Str5;
    StrLnt:  Str255;


  Begin
    LCnt:=0; StrLnt:=''; SSufix:='';

    Result:=GetNextCount(DocHed,Increment,BOff,0,LCnt,'');

    Str(Lcnt:0,StrLnt);

    If (Length(StrLnt)>6) then
    Begin
      Val(Copy(StrLnt,1,2),SVal,Vr);

      If (Vr=0) and (SVal<33) and (SVal>=10) then
      Begin
        SSufix:=ExtendSuffix[SVal-10];

        StrLnt:=Copy(StrLnt,3,5);

        Val(StrLnt,SVal,Vr);

        If (Vr=0) then
        Begin
          Str(SVal:0,StrLnt);
        end;

      end;

    end;

    RetCount:=DocCodes[DocHed]+SSufix+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])-Length(SSufix)));
  end;


{$ELSE}

Function FullDocNum(DocHed    :  DocTypes;
                     Increment :  Boolean;
                     PadLen    :  Byte;
                 Var RetCount  :  Str20)      :  Integer;

Var
  Lcnt  :  LongInt;
  StrLnt:  Str255;
Begin
  LCnt:=0; StrLnt:='';
  Result:=GetNextCount(DocHed,Increment,BOff,0,LCnt,'');

  Str(Lcnt:0,StrLnt);
  RetCount:=LJVar(DocCodes[DocHed]+SetPadNo(StrLnt,DocLen-Length(DocCodes[DocHed])),
                    PadLen);
end;

{$ENDIF}

Function FullEBisDocNum(const DocHed    :  string;
                        Increment :  Boolean;
                        PadLen    :  Byte;
                        Var RetCount  :  Str20)      :  Integer;
{ DocHed = ESO, ESI, EPO, EPI, ESC, EPC }
Var
  Lcnt  :  LongInt;
  StrLnt:  Str255;

Begin
  LCnt:=0; StrLnt:='';

  { SIN dummy value and won't be used }
  Result:=GetNextCount(SIN,Increment,BOff,0,LCnt, DocHed);

  Str(Lcnt:0,StrLnt);

  RetCount:=LJVar(DocHed+SetPadNo(StrLnt,DocLen-Length(DocHed)),
                    PadLen);
end;


{ =========== Calculate Period from Month ============== }

Function Mnth2Pr(Mnth  :  Byte)  :  Byte;
Var
  Tpr  :  Integer;
  TmpMnth  :  Integer;

Begin

  Tpr:=0; TmpMnth:=0;

  TmpMnth:=Part_Date('M',Syss.MonWk1);

  Tpr:=Succ(Mnth - TmpMnth);

  {Tpr:=Succ((Mnth-Part_Date('M',Syss.MonWk1)));}

  If (Tpr<1) then
    Mnth2Pr:=(Tpr+12)
  else
    Mnth2Pr:=Tpr;
end;


{ =========== Calculate Mnth from Period No. ============ }

Function Pr2Mnth(Pr  :  Byte)  :  Byte;
Var
  TPr  :  Integer;
Begin
  If (Pr>0) then

    Tpr:=Pred(Pr)+Part_Date('M',Syss.MonWk1)

  else
    TPr:=0;

  If (TPr>12) then
    TPr:=(Tpr-12);

  If (TPr>12) then {** Not Monthly Periods! **}
    TPr:=0;

  Pr2Mnth:=TPr;
end;

{ =========== Return Correct Financial Yr ============= }


Function Proper_FinYr(CurrMnth,CYr  :  SmallInt)  :  SmallInt;
Var
  Pyr  :  Integer;
Begin
  If (CurrMnth-Pr2Mnth(1)<0) then
      PYr:=Pred(CYr)
    else
      PYr:=CYr;

  If (PYr<0) then
    PYr:=99;

  Proper_FinYr:=PYr;
end; {Func..}


{ ========= Return Correct Financial Yr based on Full Date ======= }

Function Fin_Yr(IDate  :  Str8)  :  SmallInt;

Var
  Fy,Fm,Fd :  Word;

Begin

  {Old}DateStr(IDate,Fd,Fm,Fy);

  Fin_Yr:=Proper_FinYr(Fm,Fy);
end;

{ ========= Return Correct Financial Pr based on Full Date ======= }

Function Fin_Pr(IDate  :  Str8)  :  Byte;

Var
  Fy,Fm,Fd :  Word;

Begin

  {Old}DateStr(IDate,Fd,Fm,Fy);

  Fin_Pr:=Mnth2Pr(Fm);
end;

 { =============== Function to return last valid YTD ============= }

Function Last_YTD(NType             :  Char;
                  NCode             :  Str10;
                  PCr,PYr,PPr       :  SmallInt;
                  Fnum,NPath        :  Integer;
                  Direc             :  Boolean)  :  Boolean;


Var
  KeyChk,
  KeyS    :   Str255;
  B_Func  :   Integer;

  TmpBo   :   Boolean;

  CEStatus:   Integer;

Begin

  CEStatus:=0;

  TmpBo:=BOff;

  If (Not Direc) then
    B_Func:=B_GetLessEq
  else
    B_Func:=B_GetGEq;

  KeyChk:=PartNHistKey(NType,NCode,PCr);

  KeyS:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

  CEStatus:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,KeyS);

  TmpBo:=((CEStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
             (((NHist.Yr<=PYr) and (Not Direc)) or ((NHist.Yr>=PYr) and (Direc))) and
             ((NHist.Pr=PPr) or (Direc)));

  If (TmpBo) and (Direc) then {* Check for the exact YTD as this returns next History which will be a period *}

    TmpBo:=CheckRecExsists(FullNHistKey(NType,NCode,PCr,NHist.Yr,PPr),NHistF,NHK);

  Last_YTD:=TmpBo;

end; {Func..}

 { =============== Proc to Add a New History Record =============== }

Function Add_NHist(NType           :  Char;
                   NCode           :  Str10;
                   PCr,PYr,PPr     :  SmallInt;
                   Fnum,NPath      :  Integer)  :  Integer;
Var
  LastPurch,
  LastSales  :  Real;

  N          :  LongInt;

Begin
  LastPurch:=0; LastSales:=0;

  N:=0;

  {$B-}


  If (PPr=YTD) and (Last_YTD(NType,NCode,PCr,AdjYr(PYr,BOff),PPr,Fnum,NPath,BOff)) then
  With NHist do
  Begin

    N:=(PYr-Yr);

    If (N>1) then  {* Add YTD In between *}
      For N:=AdjYr(Yr,BOn) to AdjYr(PYr,BOff) do
        Result:=Add_NHist(NType,NCode,PCr,N,PPr,Fnum,NPath);

    LastPurch:=Purchases;
    LastSales:=Sales;
  end;




  {$B+}


  With NHist do
  Begin

    ResetRec(Fnum);

    ExClass:=NType;

    Code:=FullNHCode(NCode);

    Cr:=PCr;  Yr:=PYr; Pr:=PPr;

    Sales:=LastSales;  Purchases:=LastPurch;

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Npath);

    Result:=Status;

  end; {With..}
end; {Proc..}





 { =============== Procedure to Post Actual History Record =============== }

 Function Post_To_Hist(NType         :  Char;
                       NCode         :  Str10;
                       PPurch,PSales,
                       PCleared
                                     :  Real;
                       PCr,PYr,PPr   :  SmallInt;
                   Var PrevBal       :  Real)  :  Integer;
 Const
   Fnum  =  NHistF;
   NPath =  NHK;


 Var
   NKey  :  Str255;
   Buffer : Str20;
   PValue1, PValue2 : Double;
   dPrevBal : Double;
   LStatus : Integer;
 Begin
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      PValue1 := 0;
      PValue2 := 0;
      dPrevBal := PrevBal;
      Buffer := StringOfChar(#32, 20);
      Move(NCode[1], Buffer[1], Length(NCode));
      Result := SQLUtils.PostToHistory(NType, Buffer, PPurch, PSales, PCleared, PValue1, PValue2, PCr, PYr, PPr, Syss.NoQtyDec, dPrevBal, LStatus);
      PrevBal := dPrevBal;
    end
    else
    begin
   Blank(NKey,Sizeof(NKey));  PrevBal:=0;

   NKey:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

   Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NKey);



   If (Not StatusOK) then
     Status:=Add_NHist(NType,NCode,PCr,PYr,PPr,Fnum,NPath);


   Blank(NKey,Sizeof(NKey));

   NKey:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

   If (StatusOk) then
     {$IFDEF WIN32}
     If (GetMultiRec(B_GetDirect,B_SingLock,NKey,NPath,Fnum,BOn,GlobLocked)) then
       Status:=0;
     {$ELSE}
     Status:=(GetMultiRec(B_GetDirect,B_SingLock,NKey,NPath,Fnum,BOn,GlobLocked));
     {$ENDIF}

   If (StatusOk) and (GlobLocked) then
   With NHist do
   Begin
     PrevBal:=Purchases-Sales;

     Purchases:=Purchases+Round_Up(PPurch,2);

     Sales:=Sales+Round_Up(PSales,2);

     Cleared:=Cleared+Round_Up(PCleared,2);

     Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Npath);

   end
   else
     If (Not StatusOk) then
       Status:=4
     else
       Status:=84;

   Result:=Status;
   end;
 end; {Result..}





 { ================ Recursivley Post to YTD & Future Year to dates ============== }

 Function Post_To_CYTDHist(NType          :  Char;
                           NCode          :  Str10;
                           PPurch,PSales,
                           PCleared       :  Real;
                           PCr,PYr,PPr    :  SmallInt)  :  Integer;
 Var
   Rnum   :  Real;
   PValue1, PValue2 : Double;
   dPrevBal : Double;
   LStatus : Integer;
   Buffer : Str20;
 Begin
   Rnum:=0;
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      PValue1 := 0;
      PValue2 := 0;
      Buffer := StringOfChar(#32, 20);
      Move(NCode[1], Buffer[1], Length(NCode));
      Result := SQLUtils.PostToYearDate(NType, Buffer, PPurch, PSales, PCleared, PValue1, PValue2, PCr, PYr, PPr, Syss.NoQtyDec, LStatus);
    end
    else
    begin
   Result:=Post_To_Hist(NType,NCode,PPurch,PSales,PCleared,PCr,PYr,PPr,Rnum);


   If (Result=0) then
   Begin
     If (Last_YTD(NType,NCode,PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
       Result:=Post_To_CYTDHist(NType,NCode,PPurch,PSales,PCleared,PCr,NHist.Yr,PPr);
   end;
   end;
 end;



  { ======= Procedure to update the Account Balances =========== }

  Function UpdateExBal(UInv   :  InvRec;
                       BalAdj,
                       CosAdj,
                       NetAdj :  Real;
                       Deduct :  Boolean;

                       Mode   :  Byte)  :  Integer;

  Var
    FCust  :  Str255;
    Cnst   :  Integer;
    PBal   :  Real;
    CrDr   :  DrCrType;
    StartCode
           :  Char;
    bDeduct : Boolean;

  Begin
    With UInv do
    Begin

      Blank(CrDr,Sizeof(CrDr));  PBal:=0;

      StartCode:=CustHistCde;

      FCust:=FullCustCode(CustCode);

      Result:=30202;

      If (FCust<>LJVar('',AccLen)) then
      Begin
        If (Deduct) then
        Begin
          Cnst:=-1;
          BalAdj:=BalAdj*Cnst;

          // HM 15/05/01: Extended to duplicate UpdateBal in SysU1
          CosAdj:=CosAdj*Cnst;
          NetAdj:=NetAdj*Cnst;
        end
        else
          Cnst:=1;

        BalAdj:=(BalAdj*Cnst);

        ShowDrCr(BalAdj,CrDr);

        If (InvDocHed In DirectSet) then      {* If Direct Put Same Amount on other Side to record turnover *}
          CrDr[(Not (BalAdj<0))]:=ABS(BalAdj);

        If (Deduct) then
          For bDeduct:=BOff to BOn do
            CrDr[bDeduct]:=Round_Up((CrDr[bDeduct]*Cnst),2);


        // HM 15/05/01: Extended to duplicate UpdateBal in SysU1
        Case Mode of
          0  :  Deduct:=BOn;

          1  :  Begin
                  StartCode:=CustHistPCde;
                  Deduct:=BOff;
                end;

          2  :  Deduct:=BOff;
        end; {Case..}

        // HM 15/05/01: Extended to duplicate UpdateBal in SysU1
        If (AfterPurge(AcYr,0)) then {* Only update balances for live period *}
        Repeat

          Result:=Post_To_Hist(StartCode,FCust,CrDr[BOff],CrDr[BOn],0,0,AcYr,AcPr,PBal);

          If (Result=0) then
            Result:=Post_To_CYTDHist(StartCode,FCust,CrDr[BOff],CrDr[BOn],0,0,AcYr,YTD);

          If (Result=0) And (Not Deduct) then {* Post Hist for MD/C and 0, as Dr/Cr Ctrl accounts *}
          Begin
            Result:=Post_To_Hist(StartCode,FCust+FullNomKey(Check_MDCCC(CtrlNom)),CrDr[BOff],CrDr[BOn],0,0,AcYr,AcPr,PBal);

            Result:=Post_To_CYTDHist(StartCode,FCust+FullNomKey(Check_MDCCC(CtrlNom)),CrDr[BOff],CrDr[BOn],0,0,AcYr,YTD);
          end;

          //PR 18/04/06 - Added StkInSet, as purchase transactions weren't being included.
          If (StartCode=CustHistCde) and (InvDocHed In StkOutSet+StkInSet) then
          begin
            Result:=Post_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,AcPr,PBal);
            Result:=Post_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,YTDNCF,PBal);
          end; {if..}

          StartCode:=CustHistPCde;

          Deduct:=Not Deduct;

        Until (Deduct);

        If (Result<>0) then Result:=Result+31300;
      end; {If Blank Cust..}
    end; {With..}
  end; {Func..}



  { ========== Function to return Free Stock ========== }

  Function FreeStock(StockR  :  StockRec) :  Real;


  Begin

    With StockR do
    Begin

      FreeStock:=(QtyInStock-QtyAllocated);

    end; {With..}

  end; {Func..}

  {********* For Multi Location *********************}
    { ========== Function to return Free Location Stock ========== }

  Function FreeMLocStock(StockR  :  MStkLocType) :  Double;


  Begin

    With StockR do
    Begin


      If (Syss.FreeExAll) then
        FreeMLocStock:=lsQtyInStock
      else
        FreeMLocStock:=(lsQtyInStock-lsQtyAlloc);

    end; {With..}

  end; {Func..}


  { ============ Function to determine if line is a paymode line ========== }

  Function IS_PayInLine(PayRef  :  Str20)  :  Boolean;

  Begin

    IS_PayInLine:=((Length(PayRef)>0) and (PayRef[1] In [PayInCode,PayOutCode]));

  end; {Func..}


  
{ ======= Return Full MLoc Key ======== }

  Function Full_MLocKey(lc  :  Str10)  :  Str10;
  Begin
    Full_MLocKey:=LJVar(LC,LocKeyLen);
  end;

  { ======= Return Full Stk MLoc Key ======== }

  Function Full_MLocLKey(lc  :  Str10;
                         sc  :  Str20)  :  Str30;
  Begin
    Full_MLocLKey:=Full_MLocKey(lc)+FullStockCode(sc);
  end;

  Function Full_MLocSKey(lc  :  Str10;
                         sc  :  Str20)  :  Str30;
  Begin
    Full_MLocSKey:=FullStockCode(sc)+Full_MLocKey(lc);
  end;

{ ============= Procdure to maintain location deductions ============= }

Procedure SetROUpdate(StockR   :  StockRec;
                  Var TStkLoc  :  MStkLocType);

Begin
  With StockR, TStkLoc do
  Begin
    lsROPrice:=ROCPrice;
    lsRODate:=RODate;
    lsROQty:=ROQty;
    lsROCurrency:=ROCurrency;
    lsROCCDep:=ROCCDep;

    lsROFlg:=ROFlg;

  end;
end;


Procedure SetTakeUpdate(StockR   :  StockRec;
                    Var TStkLoc  :  MStkLocType);

Begin
  With StockR, TStkLoc do
  Begin
    lsQtyFreeze:=QtyFreeze;
    lsQtyTake:=QtyTake;
    lsStkFlg:=StkFlg;
  end;
end;



Procedure SetROConsts(StockR   :  StockRec;
                  Var TStkLoc  :  MStkLocType;
                      TLocLoc  :  MLocLocType);

Begin
  With StockR, TLocLoc, TStkLoc do
  Begin
    lsROPrice:=ROCPrice;
    lsRODate:=RODate;
    lsROCurrency:=ROCurrency;
    lsROCCDep:=ROCCDep;
    lsCostPrice:=CostPrice;
    lsPCurrency:=PCurrency;

    lsQtyMax:=QtyMax;
    lsQtyMin:=QtyMin;

    lsBinLoc:=BinLoc;

    lsCostPrice:=CostPrice;
    lsPCurrency:=PCurrency;

    lsStkCode:=StockR.StockCode;
    lsStkFolio:=StockR.StockFolio;

    lsDefNom:=TLocLoc.loNominal;
    lsCCDep:=TLocLoc.loCCDep;

    lsSaleBands:=StockR.SaleBands;

    lsCode1:=Full_MLocSKey(lsLocCode,lsStkCode);
    lsCode2:=Full_MLocLKey(lsLocCode,lsStkCode);

    SetROUpDate(StockR,TStkLoc);
  end;
end;


  { ============= Procdure to maintain location deductions ============= }

  Procedure Stock_MLocDeduct(Var IdR       :  IDetail;
                                 DeductQty :  Double;  {StockPos  :  StockPosType;}
                                 DCnst     :  Integer;
                                 GetSRec   :  Boolean;
                                 Mode      :  Byte);

  Const
    Fnum      =  MLocF;
    Keypath   =  MLSecK;
    KeyPath2  =  MLK;

  Var
    KeyChk2,
    KeyChk  :  Str255;

    FoundStr:  Str10;

    //PR: 18/11/2011
    StkCost,
    StkQty,
    Rnum    :  Real;

    StkCCurr,
    FIFOMode,
    n       :  Byte;

    RecAddress   :  LongInt;
    OStat   :  Integer;

    LOk,
    FoundOk,
    NewRec,
    Locked  :  Boolean;
    LAddr   :  LongInt;

    TLocLoc :  MLocLocType;
    TStkLoc :  MStkLocType;

  Begin
    LOK := False;
    Locked:=BOff;
    FoundStr:='';
    OStat:=Status;

Profiler.StartFunc('Stock_MLocDeduct - Get StkLoc Record');
    {* Stock Location record *}
    With IdR do                                      {* JA_X Replace with dedicated job code *}
      KeyChk:=MLocFixCode[BOff]+Full_MLocLKey(MLocStk,StockCode);
              {PartCCKey(CostCCode,CSubCode[BOff])}

    {$IFDEF EXSQL}
      if UsingSQL then
        UseVariantForNextCall(F[MLocF]);
    {$ENDIF}
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyChk);

    NewRec:=(Status=4);

    If (Not EmptyKey(IdR.MLocStk,LocKeyLen)) and (Is_FullStkCode(IdR.StockCode)) then
    Begin
      If ((StatusOk) or (NewRec))  then
      Begin

        If (NewRec) then
        With MLocCtrl^,MStkLoc do
        Begin

          With IdR do
          KeyChk2:=MLocFixCode[BOn]+Full_MLocLKey(MLocStk,StockCode);

    {$IFDEF EXSQL}
      if UsingSQL then
        UseVariantForNextCall(F[MLocF]);
    {$ENDIF}
          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyChk2);

          TLocLoc:=MLocLoc;
          LOk:=BOn;
          Locked:=BOn;
          ResetRec(Fnum);
          RecPFix:=CostCCode;
          SubType:=CSubCode[BOff];
          lsLocCode:=Idr.MLocStk;
          SetROConsts(Stock,MStkLoc,TLocLoc);

          //PR: 02/07/2010 Changed to accord with R&D\InvLst3U.Stock_MLocDeduct
          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

         // Report_BError(Fnum,Status);


          If (StatusOk) then  {* EN 570.045. Add moved to here, so no window for duplicates *}
          Begin

            Status:=GetPos(F[Fnum],Fnum,LAddr);

            NewRec:=Not StatusOk;
          end;
        end;

        if not (NewRec) then
        begin
    {$IFDEF EXSQL}

//PR: 14/09/2010 This will no longer work now that Stock Locations have been moved into their own table
(*      if UsingSQL then
      begin
//        UseVariantForNextCall(F[MLocF]);
        LOk := SQLCaller(MLocF).Lock('MLocStk', RecAddress, SQL_LS_COLUMNS);
        Locked := LOk;
      end
      else *)
    {$ENDIF}

          {$IFDEF WIN32}
            LOK:=(GetMultiRec(B_GetDirect,B_SingLock,KeyChk,KeyPath,Fnum,SilentLock,Locked));
          {$ELSE}
            LOK:=( (GetMultiRec(B_GetDirect,B_SingLock,KeyChk,KeyPath,Fnum,SilentLock,Locked))=0 );
          {$ENDIF}

        end;

        If (LOk) and (Locked) then
        With IdR,MLocCtrl^,MStkLoc do
        Begin
Profiler.StartFunc('Stock_MLocDeduct - Case Mode');
          Case Mode of
            0,2,3,99
               :  Begin
                    {
                    For n:=1 to 2 do
                      lsQtyInStock:=lsQtyInStock+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);
                    If (Mode<>3) then
                      lsQtyAlloc:=lsQtyAlloc+(StockPos[3]*StkAdjCnst[IdDocHed]*DCnst);
                    lsQtyOnOrder:=lsQtyOnOrder+(StockPos[4]*StkAdjCnst[IdDocHed]*DCnst);
                    lsQtyPicked:=lsQtyPicked+(StockPos[5]*StkAdjCnst[IdDocHed]*DCnst);
                    }

                    {* 28.07.99 - Added LocStkDedStk checking for not to update -qty
                       for InStock and FreeStk of POR transaction  }
                    If (IdDocHed In LocStkDedSet) then
                      lsQtyInStock:=lsQtyInStock+(DeductQty*StkAdjCnst[(IdDocHed In StkOpoSet+StkAdjSplit)]*DCnst);

                    {If (Mode<>3) then}
                    If ((IdDocHed=SQU) and (Syss.QUAllocFlg)) or (IdDocHed=SOR) then
                      lsQtyAlloc:=lsQtyAlloc+(DeductQty*DCnst);

                    If ((IdDocHed=PQU) and (Syss.QUAllocFlg)) or (IdDocHed=POR) then
                      lsQtyOnOrder:=lsQtyOnOrder+(DeductQty*DCnst);

                    {*** To confirm !!!!  ***}
                    {lsQtyPicked:=lsQtyPicked+(DeductQty*StkAdjCnst[IdDocHed]*DCnst);}
                    {PR 24/3/05 Changed so that PORs aren't updating lsQtyPick - condition
                    taken from InvCtSuU.Stock_Effect. Bug 2005225103844}
                    //PR 26/5/05 QtyMul was being ignored.
                    if IDDocHed in StkAllSet then
                      lsQtyPicked:=lsQtyPicked+(QtyPick*QtyMul*StkAdjCnst[not (IdDocHed In StkOpoSet+StkAdjSplit)]*DCnst);

                  end;

            {
            1  :  Begin
                    For n:=1 to 2 do
                      lsQtyPosted:=lsQtyPosted+(StockPos[n]*StkAdjCnst[IdDocHed]*DCnst);
                   end;  }

          end; {Case..}
Profiler.EndFunc('Stock_MLocDeduct - Case Mode');

Profiler.StartFunc('Stock_MLocDeduct - Other');
          If (GetSRec) then
          Begin

            lsMinFlg:=((FreeMLocStock(MStkLoc)<lsQtyMin)) and (lsQtyMin<>0);

            {* Update last edited flag *}

            lsLastUsed:=Today;

            //PR: 03/12/2012 ABSEXCH-13695 Moved from below to allow check for avg pricing
            With Stock do
              FIFOMode:=FIFO_Mode(SetStkVal(StkValType,SerNoWAvg,BOn));


            //PR: 03/12/2012 ABSEXCH-13695 Add check for avg pricing
            If ((DCnst=1) or (FIFOMode = 4)) and (Mode=0) and (IdR.IdDocHed In StkPUpSet) then
            Begin
{              If (FIFO_Mode(Stock.StkValType)=1) then
              Begin
                lsPCurrency:=Stock.PCurrency;
                lsCostPrice:=Stock.CostPrice;
              end;

              If (Not Syss.ManROCP) then
              Begin
                lsROCurrency:=Stock.ROCurrency;
                lsROPrice:=Stock.ROCPrice;
              end; {if..}

              //PR: 18/11/2011 Replaced the above with section below (adapted from InvLst3U) to
              //update costs correctly on Stock records with Ave valuation method.
              //======================================================================
              RNum := DeductQty;


{              With Stock do
                FIFOMode:=FIFO_Mode(SetStkVal(StkValType,SerNoWAvg,BOn));}


              If (AfterPurge(IdR.PYr,0)) then
              Begin

                If (FIFOMode=4) and (LocOCPrice(IdR.MLocStk)) then
                Begin  {* Maintain Weighted Average Cost Price for loaction *}

//                      Rnum:=(StockPos[(FIFOMode-3)]*StkAdjCnst[IdDocHed]*DCnst);

                  StkCost:=Stock.CostPrice;
                  StkCCurr:=Stock.PCurrency;
                  StkQty:=Stock.QtyInStock;

                  Stock.PCurrency:=lsPCurrency;
                  Stock.CostPrice:=lsCostPrice;
                  Stock.QtyInStock:=lsQtyInStock;

                  Case FIFOMode of

                    4  :  Begin
                            If (Rnum=0.0) and (IdDocHed In SalesCreditSet) then
                            Begin
                              Rnum:=RNum * StkAdjCnst[(IdDocHed In StkOpoSet+StkAdjSplit)] * DCnst;

                            end;

                            //PR: 03/12/2012 ABSEXCH-13695 Added ' * DCnst' to make RNum negative if required
                            If (Rnum<>0) then
                              FIFO_AvgVal(Stock,IdR,Rnum * DCnst);
                          end;

                  end; {Case..}

                  lsCostPrice:=Stock.CostPrice;

                  Stock.CostPrice:=StkCost;
                  Stock.PCurrency:=StkCCurr;
                  Stock.QtyInStock:=StkQty;


                end
                else {v5.01 If item is std cost with override loc cost, or it is last cost and not a last cost item, then do not update the loc cost}
                     {EN561, also exclude Serial items, as on SOR were overriding cost price when should not}
                If ((FIFOMode<>6) or (Not LocOCPrice(IdR.MLocStk))) and ((IdR.IdDocHed In StkPUpSet) or (Not (FIFOMode In [1,2,5]))) then
                Begin
                  lsPCurrency:=Stock.PCurrency;
                  lsCostPrice:=Stock.CostPrice;
                end;
              end;
              //===========================================================================

            end; {if..}

          end; {if..}

Profiler.EndFunc('Stock_MLocDeduct - Other');

          If (NewRec) then
          begin
Profiler.StartFunc('Stock_MLocDeduct - AddRec');
            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
Profiler.EndFunc('Stock_MLocDeduct - AddRec');
          end
          else
          begin
Profiler.StartFunc('Stock_MLocDeduct - PutRec');
//PR: 14/09/2010 This will no longer work now that Stock Locations have been moved into their own table
(*            if SQLUtils.UsingSQL then
            begin
              sSQLQuery := Format(SQL_UPDATE_STKLOC, [lsQtyInStock,
                                                      lsQtyOnOrder,
                                                      lsQtyAlloc,
                                                      lsQtyPicked,
                                                      Ord(lsMinFlg),
                                                      lsLastUsed,
                                                      lsPCurrency,
                                                      lsCostPrice,
                                                      lsROCurrency,
                                                      lsROPrice,
                                                      Length(lsCode1),
                                                      lsCode1]);
{              Status := UnLockMulTiSing(F[FNum], FNum, 0);
              if Status = 0 then
                Status := SQLUtils.ExecSQL(sSQLQuery, SetDrive); }
              Status := SQLCaller(MLocF).ExecSQLWithCommand(sSQLQuery, SQLCaller(MLocF).CoCode);
              SQLCaller(MLocF).Commit;
            end
            else *)
              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);


Profiler.EndFunc('Stock_MLocDeduct - PutRec');
          end;

          Report_BError(Fnum,Status);

        end;
      end;
    end;

   Status:=OStat;
  end; {Proc..}

  {* ====================================================== *}



  {$IFNDEF WIN32}

  {********* End for Multi Location *****************}

  { ==== Procedure to Control Stock_Deduct ==== }

  Procedure Stock_Deduct(Var IdR     :  IDetail;
                             LInv    :  InvRec;
                             Deduct,
                             GetSRec :  Boolean;
                             Mode    :  Byte);
  {Changes dated 09.07.99 are to be the same as Import Module, mainly not deducting
  BOM components correctly }

  Const
    Fnum     =  StockF;
    Keypath  =  StkCodeK;


  Var
    n,FIFOMode
             :  Byte;

    KeyS     :  Str255;

    DCnst    :  Integer;

    Rnum,
    DiscValue,
    QtyCheck :  Real;

    Locked   :  Boolean;
  Begin

    n:=0;

    If (Deduct) then
      DCnst:=1
    else
      DCnst:=-1;

    Rnum:=0;

    DiscValue:=0;

    QtyCheck:=0;

    FIFOModE:=0;

    With IdR do
    Begin

      If (GetSRec) then
      Begin

        Locked:=BOff;
        KeyS:=StockCode;

        {$IFDEF WIN32}
        If (GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked)) then
          Status:=0;
        {$ELSE}
        Status:=(GetMultiRec(B_GetEQ,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked));
        {$ENDIF}

      end
      else
      Begin

        Status:=0; Locked:=BOn;

      end;

      {* Added (Not Syss.DeadBOM) for not deducting BOM - 15.06.98 *}
      If (StatusOk) and (Locked) and ((Stock.StockType In [StkStkCode,StkDListCode])
         or ( ((ExSyss.DeductBOM) and (Stock.StockType=StkBillCode))) or (Not Syss.DeadBOM)) then
      With Stock do
      Begin

        If (Deduct) and (Mode=0) then
        Begin

          {* 05.03.99 - added for not to override Cost Price if the switch is OFF *}
          If (ExSyss.AutoSetStkCost) then
          begin

            Rnum:=DivWChk(Stock.CostPrice,Stock.BuyUnit);  {* Cost price set by external ledger *}

            IdR.CostPrice:=Round_Up(Rnum,Syss.NoNetDec);
          end;

          If (IdDocHed In StkPUpSet) then
          begin

            With IdR do
              DiscValue:=Calc_PAmount(Round_Up(NetValue,Syss.NoNetDec),Discount,DiscountChr);

            {* Update Last Cost Price *}

            If (FIFO_Mode(StkValType)=1) then  {* This needs to change for FIFO *}
            Begin
              Rnum:=Round_Up(Currency_ConvFT(IdR.NetValue+Idr.CostPrice-DiscValue,IdR.Currency,Stock.PCurrency,UseCoDayRate),
                    Syss.NoNetDec);

              Stock.CostPrice:=Rnum;

            end; {if..}

            {Added for Reorder Cost Price - on 26.11.97 }
            Rnum:=Round_Up(Currency_ConvFT(IdR.NetValue-DiscValue,IdR.Currency,Stock.ROCurrency,UseCoDayRate),
                  Syss.NoNetDec);

            Stock.ROCPrice:=Rnum;

          end; {if..}

          { 09.07.99 - Added }
          If (IdDocHed In StkAllSet+StkOrdSet) then
          begin
            Rnum:=FreeStock(Stock);
            QtyCheck:=((Qty-(QtyWOff+QtyDel))*QtyMul);
          end
          else
          begin
            Rnum:=QtyInStock;
            QtyCheck:=((Qty-(QtyWOff+QtyDel))*QtyMul*StkAdjCnst[(IdDocHed In StkOpoSet+StkAdjSplit)]*DocNotCnst);
          end;

          {* 09.07.99 - Added - Calculate O/S amount *}

          If (StockType = StkBillCode) and ((Rnum<QtyCheck) or (QtyCheck<0))
              and (Not (IdDocHed In PurchSplit)) and ((Syss.DeadBOM) or (ShowasKit))
              and ((Not (IdDocHed In StkAdjSplit)) or (LineNo=StkLineNo)) then
          begin

            If (Rnum>0) and (QtyCheck>=0) then
            begin
              DeductQty:=Rnum;

              If (IdDocHed In StkAdjSplit) then {* Force a reversal *}
                DeductQty:=DeductQty*DocNotCnst;

            end
            else
              DeductQty:=0;

          end
          else
            DeductQty:=((Qty-(QtyWOff+QtyDel))*QtyMul);


          { 09.07.99 - Closed ..
          DeductQty:=((Qty-(QtyWOff+QtyDel))*QtyMul); {* Changed on 07.07.97 *}

        end;  {If (Deduct) and (Mode=0) then..}


        Case Mode of
          0,2
             :  Begin


                  {If (IdDocHed In StkDedSet+[ADJ]) then}
                  {* 01.07.99 - changed for not updating stock for Pur. transactions *}
                  If (IdDocHed In LocStkDedSet) then
                    QtyInStock:=QtyInStock+(DeductQty*StkAdjCnst[(IdDocHed In StkOpoSet+StkAdjSplit)]*DCnst);

                  If ((IdDocHed=SQU) and (Syss.QUAllocFlg)) or (IdDocHed=SOR) then  {* Add SOR when PSOP live... *}
                    QtyAllocated:=QtyAllocated+DeductQty*DCnst;

                  If ((IdDocHed=PQU) and (Syss.QUAllocFlg)) or (IdDocHed=POR) then  {* Add POR when PSOP live... *}
                    QtyOnOrder:=QtyOnOrder+DeductQty*DCnst;

                  If (ExSyss.AutoSetStkCost) and (IdDocHed In LocStkDedSet) then
                  Begin
                    Rnum:=0;

                    FIFOMode:=FIFO_Mode(StkValType);

                    Case FIFOMode of

                      2,3  :  Begin  {* Maintain FIFO/LIFO db *}
                                Rnum:=Rnum+(DeductQty*StkAdjCnst[(IdDocHed In StkOpoSet+StkAdjSplit)]*DCnst);

                                If (Rnum<>0) and (Is_FIFO(StkValType)) then
                                  FIFO_Control(IdR,Stock,LInv,Rnum,Mode,Deduct);
                              end;

                      4,5  :  Begin  {* Maintain Weighted Average Cost Price *}

                                Rnum:=(DeductQty*StkAdjCnst[(IdDocHed In StkOpoSet+StkAdjSplit)]*DCnst);


                                Case FIFOMode of

                                  {* 02.07.99 - Changed from Rnum<>0 *}
                                  4  :  If (Rnum>0) then
                                          FIFO_AvgVal(Stock,IdR,Rnum);

                                  {$IFDEF SOP}   {* Update Next Cost price for Ser No, when either buying or selling
                                                    Simply gets next Sno Cost Price *}

                                    5:  If (Mode=0) and (Deduct) then
                                          FIFO_SERUp(EStock);

                                  {$ENDIF}

                                end; {Case..}

                              end;

                    end; {Case..}

                  end;

                end;

        end; {Case..}
        {* ------------------ *}

        {* Add for Multi-Location Stock 23.2.97 *}


        If (ExSyss.UseMLoc) and (Not EmptyKey(MLocStk,LocKeyLen)) and (Mode In [0..3,99]) then
           Stock_MLocDeduct(IdR,DeductQty,DCnst,GetSRec,Mode);

        {* ------------------ *}

        If (Not Deduct) then
          DeductQty:=0;


        If (GetSRec) then
        Begin

          MinFlg:=((FreeStock(Stock)<QtyMin)) and (QtyMin<>0);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        end;

      end {If Locked Ok..}
      else {Unlock}
      Begin

        Status:=Find_Rec(B_Unlock,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;

    end; {With IdR..}
  end; {Proc..}

{$ENDIF}

{ =========== Function to Return Unit Cost Price ======== }

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;


Begin

  If (Not UP) then
    Calc_StkCP:=DivWChk(Q,QM)
  else
    Calc_StkCP:=Q;

end; {Func..}

{* ================================================ *}

Function HFolio_Txlate(Ano  :  LongInt)  :  LongInt;
Var
  TResult  :  LongInt;

Begin

  Case Ano of

    0  :  TResult:=SysAnlsProfit;

    1..SysAnlsEnd

       :  TResult:=Ano*10;

    SysAnlsBal..NofSysAnals

       :  TResult:=(150+((Ano-SysAnlsEnd)*10));  {* ie 160,170,180 *}

    else {99 for SysAnlsProfit leave as }

          TResult:=Ano;

  end; {Case..}

  HFolio_TxLate:=TResult;

end; {Func..}

{* ================================================ *}

Procedure Set_JMajorHed(JobR     :  JobRecType;
                        n        :  LongInt;
                        Fnum     :  Integer);

Begin
  With JobCtrl^,JobBudg do
  Begin

    ResetRec(Fnum);

    RecPFix:=JBRCode;
    SubType:=JBMCode;

    JobCode:=JobR.JobCode;

    HistFolio:=HFolio_Txlate(n);

    If (n<>0) then
      AnalHed:=n
    else
      AnalHed:=SysAnlsProfit;

    BudgetCode:=FullJBCode(JobCode,CurrBudg,FullNomKey(HistFolio));

  end; {If Ok..}
end; {Proc..}


{ ====== Proc to Generate a jobs major Heading Lines ======= }

Procedure Gen_JMajorHed(JobR     :  JobRecType);


Const
  Fnum      =  JCtrlF;
  Keypath   =  JCK;

Var
  KeyChk,
  KeyS      :  Str255;
  n         :  LongInt;

Begin

  Status:=0;

  For n:=0 to NofSysAnals do
  Begin

    If (StatusOk) then
    With JobCtrl^,JobBudg do
    Begin

      Set_JMajorHed(JobR,n,Fnum);

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

    end; {If Ok..}

  end; {Loop..}

end; {Proc..}


{* 16.11.98 This function has been added to get OurRef & FolioNo to be compatible
   with new Ent.'s function. However, DLL & Import uses "OverWrite_Trans_No" switch,
   therefore if OWRefNo is OFF, just get the FolioNum *}

Procedure SetNextDocNos(Var  InvR    :  InvRec;
                             SetOn   :  Boolean;
                             OWRefNo :  Boolean);

Var
  KeyS      :  str255;
  FolioTyp  :  DocTypes;

  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;

  TResult   :  Integer;

Begin
  NotDupli:=BOn;

  UsedInv:=InvR;
  NORef:='ERROR!';
  NFolio:=0;

  // Overwrite the OurRef
  If (OWRefNo) then
  begin
    Repeat
      if InEbusinessMode then
        TResult:=FullEBisDocNum(EnumToOurRefCode(UsedInv.InvDocHed),SetOn,DocLen,NORef)
      else
        TResult:=FullDocNum(UsedInv.InvDocHed,SetOn,DocLen,NORef);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);
  end; {if..}

  // Process the Folio Number
  if InEBusinessMode then
  begin
    KeyS := '';
    // InvF is EBusDoc.dat in this mode
    if Find_Rec(B_GetLast, F[InvF], InvF, Inv, 3, KeyS) = 0 then
      NFolio := Inv.FolioNum + 1
    else
      NFolio := 1;
  end
  else
  begin
    If (UsedInv.InvDocHed In BatchSet+QuotesSet+StkAdjSplit+PSOPSet+TSTSplit+JAPSplit +StkRetSplit) then
      FolioTyp:=AFL
    else
      FolioTyp:=FOL;

    Repeat
      TResult:=GetNextCount(FolioTyp,SetOn,BOff,0,NFolio,'');

      If (SetOn) then
        NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);
  end;

  With UsedInv do
  Begin
    If (OWRefNo) then
      OurRef:=NORef;
    FolioNum:=NFolio;
  end;

  InvR:=UsedInv;

end; {proc..}


Function SetNextSFolio(DocHed     :  DocTypes;
                       SetOn      :  Boolean;
                       SMode      :  Byte)  :  LongInt;


Var
  NotDupli  :  Boolean;
  NFolio    :  LongInt;
  TResult   :  Integer;

Begin
  NotDupli:=BOn;
  NFolio:=0;

  Repeat
    {Result:=GetNextCount(DocHed,SetOn,BOff,0,Result);}

    TResult:=GetNextCount(DocHed,SetOn,BOff,0,NFolio,'');

    If (SetOn) then
    Case SMode of
      0  :  NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(NFolio)),StockF,StkFolioK));
      1  :  NotDupli:=(Not CheckExsists(Strip('R',[#0],PartCCKey(NoteTCode,NoteCCode)+FullNomKey(NFolio)),MLocF,MLSuppK));
      else  NotDupli:=BOff;
    end;

  Until (Not SetOn) or (NotDupli);

  SetNextSFolio:=Nfolio;

end;


{ =========== Padded PayInKey =========== }

{* 10.02.99 - This function has been copied from BTKeys1U.PAS and added Succ() to be
   compatible with Import Module and not showing PayInRef on the screen  *}

Function FullPayInKey(RefNo  :  Str20)  :  Str20;

Begin

  FullPayInKey:=LJVar(RefNo,Succ(PIKeyLen));

end; {Func..}

//=============================== O/S functions copied from MiscU.pas for ABSEXCH-11528 ========================================//
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

//PR: 19/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from a transaction
//PR: 22/06/2012 ABSEXCH-11528 To deal with manual vat, separated out function to read lines and calculate vat
//and added function to calculated os vat from header. TransOSWithVAT will call the appropriate function,
//depending upon value of InvR.ManVAT.


function TransOSWithManualVAT(InvR : InvRec) : Double;
var
  OSPortion : Double;
begin
  //Calculate portion of order that is still o/s
  if ZeroFloat(InvR.TotOrdOS) or ZeroFloat(InvR.InvNetVal) then
    OSPortion := 0
  else
    OSPortion := InvR.TotOrdOS / InvR.InvNetVal;

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

  //PR: 01/03/2017 ABSEXCH-18430 Need to ensure we get the current key
  KPath := GetPosKey;

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

//========================================= O/S functions copied from MiscU.pas (End) ========================================//


{ ======= Procedure to update the Account Balances with Order details =========== }
{ Replicated inside ExbtTh1U for thread safe operation }

Procedure UpdateOrdBal(UInv   :  InvRec;
                       BalAdj :  Real;
                       CosAdj,
                       NetAdj :  Real;
                       Deduct :  Boolean;
                       Mode   :  Byte);

//PR: 28/02/2012 Copied UpdateOrdBal from R&D\InvCt2SU.pas to duplicate Enter1's method for updating customer committed
//balance, which includes updating the head office account where necessary. ABSEXCH-11952
Const
   Fnum   =   CustF;

{*  Mode definitions  *}

{   1 - Update Only     U }

Var
  FCust  :  Str255;
  Cnst   :  Integer;
  PBal   :  Real48;
  CrDr   :  DrCrType;
  StartCode
         :  Char;

  LOk,
  LoopComplete,
  Locked :  Boolean;

  TmpKPath,
  TmpStat:  Integer;

  TmpRecAddr,
  LoopCounter
         :  LongInt;
  OrigCCode,
  HOCCode:  Str10;

  LocalCust
         :  CustRec;


Begin
  With UInv do
  If (InvDocHed In PSOPSet+JAPOrdSplit) or (Mode=1) then
  Begin
    LoopCounter:=0; OrigCCode:=FullCustCode(UInv.CustCode); HOCCode:=NdxWeight;

    LocalCust:=Cust;  LOk:=BOff;

    Blank(CrDr,Sizeof(CrDr));  PBal:=0;

    StartCode:=CustHistCde;

    FCust:=FullCustCode(CustCode);

    If (Not EmptyKey(FCust,CustKeyLen)) then
    Begin
      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);



      If (Deduct) then
      Begin
        Cnst:=-1;
        BalAdj:=BalAdj*Cnst;

        CosAdj:=CosAdj*Cnst;

        NetAdj:=NetAdj*Cnst;
      end
      else
        Cnst:=1;

      Repeat
        LoopComplete:=BOn;

        If (LoopCounter=1) then
          HOCCode:=FCust;

        Inc(LoopCounter);



        Post_To_Hist(StartCode,FCust,0,0,BalAdj,0,AcYr,AcPr,PBal);

        Post_To_CYTDHist(StartCode,FCust,0,0,BalAdj,0,AcYr,YTD);

        If (Cust.CustCode<>FCust) then
          LOk:=Global_GetMainRec(CustF,FCust)
        else
          LOK:=BOn;

        If (LOK) and (Not EmptyKey(Cust.SOPInvCode,CustKeyLen)) then
        Begin
          FCust:=FullCustCode(Cust.SOPInvCode);

          //PR: 28/02/2012 Changed to CheckRecExsists from Global_GetMainRec in InvCt2SU.pas
          LOk:=CheckRecExsists(FCust, CustF, CustCodeK);

          LoopComplete:=(Not LOK) or (Cust.SOPConsHO<>1);

        end;



      Until (LoopComplete) or (FCust=OrigCCode) or (FCust=HOCCode);

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Cust:=LocalCust;


    end; {If Blank Cust..}
  end; {With..}
end;


{ ============== Procedure to update acc Order balance based on previois invoice ============= }

Procedure UpdateCustOrdBal(OI,IR  :  InvRec; PreviousOS : Double = 0);

Var
  UOR  :  Byte;

Begin
  With OI do
  Begin
    UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

    //PR: 26/06/2012 ABSEXCH-11528 Changed to use correct o/s depending on system setup flag. Value is passed through from Saletx2U if we're editting
    //overwise OI is blank and PreviousOS is 0 anyway (copied from MiscU)
    UpdateOrdBal(OI, PreviousOS *
                 DocCnst[InvDocHed]*DocNotCnst,
                 0,0,
                 BOn,0);
  end;

  With IR do
  Begin
    UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

    //PR: 26/06/2012 Changed to use correct o/s depending on system setup flag ABSEXCH-11528 (copied from MiscU)
    UpdateOrdBal(IR, TransOSValue(Inv) *
                 DocCnst[InvDocHed]*DocNotCnst,
                 0,0,
                 BOff,0);
  end;

end;


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
    If (InvDocHed In DocAllocSet) then
    begin
      {* Changed on 02.09.99 *}
      If (Rnum<>0) and (RunNo>=0) then
      Begin
        TmpBo:=(InvDocHed In SalesSplit);

        AllocStat:=TradeCode[TmpBo];

        UntilDate:=NDXWeight; {* add 13.2.97 *}

        {
        If (Autho_Auto(ESyss.AuthMode)) then
          HoldFlg:=HoldP;}

      end
      else
      begin
        //PR 7/6/02 - if trans is an auto transaction then we need the untildate
        if RunNo <> - 2 then
        begin
          AllocStat:=#0;
          FillChar(UntilDate,SizeOf(UntilDate),#0);
        end;
      end; {if Rnum<>0 ..}
    end; {if..}

  end; {With..}

end;
{* Start from here - for updating SOP Link ... 15.02.*}
{* -------------------------------------------------------------------------- *}
  { ======== Procedure to Update header part of SOP Link with Order Value ======= }

//PR 21/04/06 - this wasn't working because of single/multilock issue - changed to use ExLocal
  Procedure Update_SOPOS(Fnum,
                         KeyPath  :  Integer;
                         FolRef   :  LongInt;
                         AdjVal   :  Real;
                         UpBal    :  Boolean);



  Var
    UOR     :  Byte;
    KeyS    :  Str255;
    Locked  :  Boolean;
    LAddr,
    RecAddr :  LongInt;
    TmpInv  :  ^InvRec;
    ExLocal : TdMTExLocalPtr;

  Begin

    RecAddr:=0; UOR:=0;

    New(TmpInv);

    TmpInv^:=Inv;

    Locked:=BOff;

    KeyS:=FullNomKey(FolRef);

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    New(ExLocal, Create(54));
    Try
      with ExLocal^ do
      begin
        Open_System(InvF, InvF);
        Status:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        If (StatusOk) then
        With LInv do
        Begin

          Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

          If (Ok) and (Locked) then
          Begin
            TotOrdOS:=TotOrdOS-Round_Up(AdjVal,2);

            Status:=LPut_Rec(FNum, KeyPath);

//            Report_BError(Fnum,Status);

            If (StatusOk) and (UpBal) then
            Begin
              UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

              UpdateOrdBal(LInv,(Round_Up(Conv_TCurr(AdjVal,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                           DocCnst[InvDocHed]*DocNotCnst),
                           0,0,
                           BOn,0);
            end;

//            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          end; {If Locked..}

        end; {If Header found..}
        Close_Files;
      end; //with ExLocal^
    Finally
      Dispose(ExLocal, Destroy);
    End;

    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end; {Proc..}


  { ======== Procedure to adjust the match payment value ======= }

  Procedure Update_MatchPay(DocRef,
                            MatchDoc :  Str10;
                            AddT,
                            AddN     :  Real;
                            Deduct   :  Boolean;
                            MTyp     :  Char);

  Var
    ScanKey,
    ChkKey  :  Str255;

    UOk,Locked,
    FoundOk
            :  Boolean;
    Fnum,
    Keypath,
    DedCnst :  Integer;


    TmpStatus,
    B_Func
            :  Integer;

    LAddr   :  LongInt;

  Begin


    Fnum      := PWrdF;
    Keypath   := PWK;


    TmpStatus:=Status;

    ScanKey:=FullMatchKey(MatchTCode,MatchSCode,DocRef);

    ChkKey:=ScanKey;

    UOk:=BOn; Locked:=BOn;

    B_Func:=B_GetNext;

    FoundOk:=BOff;

    If (Deduct) then
      DedCnst:=-1
    else
      DedCnst:=1;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

    While (StatusOk) and (UOk) and (Locked) and (CheckKey(ChkKey,ScanKey,Length(ChkKey),BOn)) and (Not FoundOk) do
    With PassWord.MatchPayRec do
    Begin

      If (MatchType=MTyp) and (MatchDoc=PayRef) then
      Begin

        FoundOk:=BOn;

        UOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,ScanKey,KeyPAth,Fnum,BOn,Locked,LAddr);

        If (UOK) and (Locked) then
        Begin

          OwnCVal:=OwnCVal+(AddN*DedCnst);

          SettledVal:=SettledVal+(AddT*DedCnst);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end;

      end;


      If (StatusOk) and (Not FoundOk) then
        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

    end; {While..}

    Status:=TmpStatus;

  end; {Proc..}


  Procedure Change_Match(IdR      :  IDetail;
                         Fnum,
                         Keypath  :  Integer;
                         Deduct   :  Boolean);

  Const
    DocMatchTyp   :  Array[BOff..BOn] of Char = ('A','O');



  Var
    UOR       :  Byte;
    TmpInv    :  ^InvRec;
    MatchVal  :  Real;



  Begin

    New(TmpInv);

    TmpInv^:=Inv;

    MatchVal:=InvLTotal(IdR,BOn,(Inv.DiscSetl*Ord(Inv.DiscTaken)));


    If (CheckRecExsists(FullNomKey(IdR.SOPLInk),Fnum,KeyPath)) then
    Begin
      UOR:=fxUseORate(UseCODayRate,BOn,IdR.CXRate,IdR.UseORate,IdR.Currency,0);

      Update_MatchPay(TmpInv^.OurRef,Inv.OurRef,
                      Round_Up(Conv_TCurr(MatchVal,XRate(IdR.CXRate,BOff,IdR.Currency),IdR.Currency,UOR,BOff),2),
                      MatchVal,Deduct,DocMatchTyp[BOn]);

    end;

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end;

  Function InvLOOS(IdR        :  IDetail;
                   UseDisc    :  Boolean;
                   SetlDisc   :  Double)  :  Double;
  Var
    Rnum,
    WithDisc  :  Double;

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


      { Disabled v4.20If (ShowCase) and (QtyPack<>0) and (PrxPack) then
        LineQty:=DivWChk(Qty_OS(Idr),QtyPack)
      else
        LineQty:=Calc_IdQty(Qty_OS(Idr),QtyMul,UsePack);}


      // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts  //PR: 26/03/2009 Copied from R&D\MiscU
      //Rnum:=Calc_PAmount(Round_Up(PriceEach,UseDecs),Discount,DiscountChr);
      Rnum:=Calc_PAmountAD(Round_Up(PriceEach,UseDecs),
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


(* Old procedure - superseded 20/04/06 - PR
  Procedure Check_SOPLink(Fnum,
                          KeyPath  :  Integer;
                          FolRef   :  LongInt;
                          DelDate  :  LongDate);



  Var
    KeyS    :  Str255;
    Locked  :  Boolean;

    LAddr,
    RecAddr :  LongInt;

    TmpInv  :  ^InvRec;



  Begin

    RecAddr:=0;

    New(TmpInv);

    TmpInv^:=Inv;

    Locked:=BOff;

    KeyS:=FullNomKey(FolRef);

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    With Inv do
    Begin

      If (RunNo=Set_OrdRunNo(InvDocHed,BOff,BOn)) then {* Its posted *}
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin
          RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

          If (DelDate<DueDate) then
            DueDate:=DelDate;

          BatchLink:=QUO_DelDate(InvDocHed,DueDate);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end; {If Locked..}

      end; {If Order Posted..}

    end; {If Header found..}

    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end; {Proc..}

*)

{PR 20/04/06 - Check_SOPLink was using MultiLock, but as InvF already has a single lock it was getting error 93
 - change to use an ExLocal to avoid clash }
  Procedure Check_SOPLink(Fnum,
                          KeyPath  :  Integer;
                          FolRef   :  LongInt;
                          DelDate  :  LongDate);



  Var
    KeyS    :  Str255;
    Locked  :  Boolean;

    LAddr,
    RecAddr :  LongInt;

    TmpInv  :  ^InvRec;
    ExLocal : TdMTExLocalPtr;


  Begin


    RecAddr:=0;

    New(TmpInv);

    TmpInv^:=Inv;

    Locked:=BOff;

    KeyS:=FullNomKey(FolRef);

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    New(ExLocal, Create(54));
    Try
      with ExLocal^ do
      begin
        Open_System(InvF, InvF);
        Status:= LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        If (StatusOk) then
        With LInv do
        Begin

          If (RunNo=Set_OrdRunNo(InvDocHed,BOff,BOn)) then {* Its posted *}
          Begin

            Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

            If (Ok) and (Locked) then
            Begin
              RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

              If (DelDate<DueDate) then
                DueDate:=DelDate;

              BatchLink:=QUO_DelDate(InvDocHed,DueDate);

              Status:=LPut_Rec(FNum, KeyPath);

  //            Report_BError(Fnum,Status);

  //            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            end; {If Locked..}

          end; {If Order Posted..}

        end; {If Header found..}

        Close_Files;
      end; //with ExLocal^
    Finally
      Dispose(ExLocal, Destroy);
    End;

    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end; {Proc..}


    { ======== Procedure to Update the SOP Link ======= }

    Procedure Update_SOPLink(Idr     :  IDetail;
                             Deduct,
                             UpHed,
                             Warn    :  Boolean;
                             Fnum,
                             Keypath,
                             KeyResP :  Integer);



    Var
      LAddr,
      RecAddr  :  LongInt;

      TmpId    :  ^IDetail;

      KeyS,
      KeyChk   :  Str255;

      Locked,
      FoundOk  :  Boolean;

      DedCnst  :  Integer;

      AdjVal,
      NewVal   :  Real;

      // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
      UseSerial: Boolean;
      UseBins: Boolean;
    Begin

      FoundOk:=BOff;
      Locked:=BOff;

      AdjVal:=0;
      NewVal:=0;

      RecAddr:=0;

      If (Deduct) then
        DedCnst:=-1
      else
        DedCnst:=1;

      If (IdR.SOPLink<>0) then
      Begin

        New(TmpId);

        TmpId^:=Id;

        Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

        KeyChk:=FullIdKey(IdR.SOPLink,IdR.SOPLineNo);

        KeyS:=KeyChk;


        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
        Begin

          FoundOk:=(Id.LineNo>0);

          If (Not FoundOk) then
            Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

        If (FoundOk) then
        Begin

          If (UpHed) then
          Begin

            If (Qty_OS(Id)<>0) then
              Check_SOPLink(InvF,InvFolioK,Id.FolioRef,Id.PDate);


          end
          else
          Begin

            Locked:=BOff;

            Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If (Ok) and (Locked) then
            With Id do
            Begin

              AdjVal:=InvLOOS(Id,BOn,0);

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
              UseSerial := False;
              UseBins   := False;

              QtyDel:=QtyDel+Round_Up((IdR.Qty*DedCnst),Syss.NoQtyDec);

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock

              // Save the current Stock record, and locate the Stock record for
              // this line. Check whether it uses Serial Numbers or Multi-bins.
              With TBtrieveSavePosition.Create Do
              Begin
                Try
                  // Save the current position in the file for the current key
                  SaveFilePosition (StockF, GetPosKey);
                  SaveDataBlock (@Stock, SizeOf(Stock));

                  // Does this Stock item use Serial/Batch?
                  UseSerial := Stock.StkValType = 'R';

                  // Does this Stock item use Multi-bins?
                  UseBins := Stock.MultiBinMode;

                  // Restore position in file
                  RestoreSavedPosition;
                  RestoreDataBlock (@Stock);
                Finally
                  Free;
                End; // Try..Finally
              End; // With TBtrieveSavePosition.Create

              // Restore the Stock record.

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
              // Only adjust the Serial Quantity if the Stock record actually
              // uses Serial Numbers
              if UseSerial then
                SerialQty:=SerialQty+Round_Up(((IdR.Qty*IdR.QtyMul) * DedCnst),Syss.NoQtyDec);

              // CJS 2015-11-09 - ABSEXCH-15790 - Incorrect batch qty if using units/stock
              // Only adjust the Bin Quantity if the Stock record actually
              // uses Multi-bins
              if UseBins then
                BinQty:=BinQty+Round_Up(((IdR.Qty*IdR.QtyMul)*DedCnst),Syss.NoQtyDec);

              QtyWOff:=QtyWOff+Round_Up((IdR.QtyPWOff*DedCnst),Syss.NoQtyDec);

              If (Qty_OS(Id)=0) then
                LineType:=StkLineType[DocTypes(Ord(IdDocHed)+3)]
              else
                LineType:=StkLinetype[IdDocHed];

              if Not EmptyKey(StockCode,StkLen) then
                Stock_Deduct(Id,Inv,Not Deduct,BOn,0);

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              Report_BError(Fnum,Status);

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

              If (StatusOk) then {* Update match info *}
              Begin
                Change_Match(IdR,InvF,InvFolioK,Deduct);

                NewVal:=AdjVal-InvLOOS(Id,BOn,0);

                {* Update O/S information *}

                Update_SOPOS(InvF,InvFolioK,Id.FolioRef,NewVal,(Not (TmpId^.IdDocHed In PSOPSet)));

              end;


              {
              If (Warn) then
                Warn:=Warn_OverDelv(Id,IdR.SOPLink,BOff,BOn);
              }
            end; {If Locked..}

          end; {If Not update header}

        end; {If Line Matched}

        SetDataRecOfs(Fnum,RecAddr);

        If (RecAddr<>0) then
          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyResP,0);

        Id:=TmpId^;

        Dispose(TmpId);

      end; {If Linked Line}

    end; {Proc..}

Function  CheckKeyExists(KeyR  :  AnyStr;
                         FileNum,KeyPath
                              :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  {TmpFn    :  FileVar;}

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;



Begin
  KeyS:=KeyR;

  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}


  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq+B_KeyOnly,F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  If (CEStatus<>0) then
    ResetRec(FileNum);

  Result:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOn,BOff);

end;

//PR: 19/03/2009 Added function to allow Importer to create Auto Transactions
Function FullAutoDocNum(DocHed    :  DocTypes;
                        Increment :  Boolean)  :  Str20;


Var
  Lcnt, Res  :  LongInt;
  StrLnt:  Str255;


Begin
  LCnt:=0; StrLnt:='';

  Res:=GetNextCount(ADC,Increment,BOff,0, LCnt, '');

  Str(Lcnt:0,StrLnt);

  FullAutoDocNum:=DocCodes[DocHed]+SetPadNo(StrLnt,(Pred(DocKeyLen)-Length(DocCodes[DocHed])))+AutoPrefix;
end;


//PR: 19/03/2009 Added function to allow Importer to create Auto Transactions
Procedure SetNextAutoDocNos(Var  InvR  :  InvRec;
                                 SetOn :  Boolean);
Var
  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;
  LCnt : Longint;

Begin
  NotDupli:=BOn;

  UsedInv:=InvR;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NORef:=FullAutoDocNum(UsedInv.InvDocHed,SetOn);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);

    Repeat
      GetNextCount(AFL,SetOn,BOff,0, NFolio, '');

      If (SetOn) then
        NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);

  end;

  With UsedInv do
  Begin
    OurRef:=NORef;
    FolioNum:=NFolio;
  end;

  InvR:=UsedInv;
end;


Initialization
  LogF := TStringList.Create;
Finalization
  with TSaveDialog.Create(nil) do
  Try
{    if Execute then
      LogF.SaveToFile(Filename);}
  Finally
    Free;
    LogF.Free;
  End;



end.
