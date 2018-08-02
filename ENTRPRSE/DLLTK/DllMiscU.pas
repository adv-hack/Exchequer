UNIT DllMiscU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export Module                   }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;


{* --------  Cost Centre / Department information --------- *}

FUNCTION EX_GETCCDEP(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     CCDEPTYPE    :  SMALLINT;
                     LOCK         :  WORDBOOL) : SMALLINT;
                     {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;
{$IFDEF COMTK}
FUNCTION EX_STORECCDEP(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       UPDATEMODE   :  SMALLINT;
                       CCDEPTYPE    :  SMALLINT) : SMALLINT;
                     {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;
{$ENDIF}


{* --------  VAT Rate information --------- *}

FUNCTION EX_GETVATRATE(P       :  POINTER;
                       PSIZE   :  LONGINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{* --------  To Set the Record Lock switch  --------- *}

PROCEDURE EX_SILENTLOCK(SILENT  :  WORDBOOL);
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{* --------  Currency information --------- *}

FUNCTION EX_GETCURRENCY(P     : POINTER;
                        PSIZE : LONGINT;
                        CURR  : SMALLINT) : SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{* --------  System Record information --------- *}

FUNCTION EX_GETSYSDATA(P            :  POINTER;
                       PSIZE        :  LONGINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{* --------  Unlock File  --------- *}

FUNCTION EX_UNLOCKRECORD(FILENUM : SMALLINT; RECORDPOSN : LONGINT) : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{$IFDEF WIN32}

{* --------  Store Automatic Bank Reconciliation information --------- *}

FUNCTION EX_STOREAUTOBANK(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;


{* --------  Check Enterprise Password --------- *}

FUNCTION EX_CHECKPASSWORD(USERNAME      :  PCHAR;
                          USERPASSWORD  :  PCHAR) : SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------  To get Fax/Email Tab of Enterprise System SetUp --------- *}

FUNCTION EX_GETECOMMSDATA(P            :  POINTER;
                          PSIZE        :  LONGINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------  To retrun Enterprise Periods for defined Date --------- *}

FUNCTION EX_DATETOENTPERIOD(TRANSDATE : PCHAR;
                            VAR FINPERIOD,
                                FINYEAR : SMALLINT) : SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------  To Return File Size --------- *}

FUNCTION EX_FILESIZE(FILENUM  :  SMALLINT)  :  LONGINT;
                    {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------  To Get Record Address for Internal Use  --------- *}

Function Ex_GetRecAddress(FileNum  :  SmallInt)  :  LongInt;  {FOR INTERNAL ONLY }


{* --------  Get Record Address --------- *}

FUNCTION EX_GETRECORDADDRESS(    FILENUM     :  SMALLINT;
                             Var RECADDRESS  :  LONGINT)  :  SMALLINT;  STDCALL;  EXPORT;


{* --------  Get Record With Address  --------- *}

FUNCTION EX_GETRECWITHADDRESS(FILENUM,
                              KEYPATH  :  SMALLINT;
                              TRECADDR :  LONGINT )  :  SMALLINT;  STDCALL;  EXPORT;

FUNCTION EX_GETTAXWORD : String; STDCALL; EXPORT;


FUNCTION EX_CHECKMODULERELEASECODE(Const iModuleNo : SmallInt) : SmallInt; STDCALL;  EXPORT;

FUNCTION EX_GETCOMPANYID : LongInt; STDCALL;  EXPORT;

FUNCTION EX_STORECURRENCY(P     : POINTER;
                        PSIZE : LONGINT;
                        CURRENCY  : SMALLINT) : SMALLINT;  STDCALL;  EXPORT;

FUNCTION EX_UPDATEAUDITDATE(NEWDATE : PCHAR) : SMALLINT; STDCALL;  EXPORT;



{$ENDIF}


{$IFDEF COMTK}
  Procedure CopyExCCDepToTKCCDep(Const CCDeptR : CostCtrType; Var ExCCDepRec  :  TBatchCCDepRec);
  function Ex_Usernames : WideString;
  function Ex_UserProfileString(const ALogin : WideString; WhichString : Byte) : WideString;
  Function EX_GETPASSWORD(USERNAME :  string) : string;
{$ENDIF}

  function DataIsOpen : Boolean;
{$IFDEF EN551}
  Procedure CalcInvVATTotals(Var  InvR :  InvRec;
                             ReCalcVAT :  Boolean);
{$ENDIF}
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
{$IFDEF WIN32}
  BtrvU2, BTSupU1, SysU2, ComnU2, CurrncyU, BtKeys1U, BankU1,
{$ELSE}
  BtrvU16, BTSup1, BTSup2,
{$ENDIF}
  BTS1,
  SysU3,   { added in v4.31 }
  Crypto,  { For Password }
  DLLErrU,
  Dialogs,
  SysUtils,
  IntMU,    { needed for Ex_GetTaxWord }
  HelpSupU, { for EX_CHECKMODULERELEASECODE }
  ComnUnit,  { Ex_DateToEntPeriod }
  MiscU,
  DLSQLSup,
  CustomFieldsVar,
  CustomFieldsIntf,

  //PR: 16/02/2012 ABSEXCH-9795
  QtyBreakVar
  {$IFNDEF SOPDLL}
  ,Dll01U
  {$ENDIF}

  //PR: 27/07/2012 ABSEXCH-12956
  ,CurrencyHistoryClass
  { CJS 2013-03-05 - ABSEXCH-14003 - Currency Audit }
  ,AuditIntf
  ,AuditBase
  ,AuditLog

  //PR: 29/08/2013 MRD
  ,EncryptionUtils

  //PR: 22/08/2017 v2017 R2 ABSEXCH-18857
{  ,oUserDetail
  ,oUserIntf              }
  ,PasswordComplexityConst
  ,oSystemSetup
  ,WinAuthUtil
  ,SHA3HashUtil
  ;

Const
  { Moved from GlobVar b/c of 16 bits compilation problem }
  { ======= for Nominal (Dec'96) ======== }

  Htyp           =  'H';                 {Posting Types}
  Ctyp           =  'C';
  Ftyp           =  'F';

  PostSet        =  ['A','B'];         {  Postable Nominal Codes  }

  NomTypeSet     =  [HTyp,CTyp,FTyp] ; {* Valid Nominal Types +PostSet *}


{* ======== Function to Unlock a generic record ============ *}

FUNCTION EX_UNLOCKRECORD(FileNum : smallint; RecordPosn : longint) : smallint;
var
  ValidHed,
  ValidCheck : boolean;
  ExStat : integer;
  KeyS  :  Str255;
begin
  LastErDesc:='';
  if TestMode then
    ShowMessage('Ex_UnLockRecord');
  ValidHed := false;
  ExStat := 0;
  ValidCheck := FileNum in [1..5, 8, 9, 11];
  { Invalid File No. }
  GenSetError(ValidCheck,30001, ExStat, ValidHed);


  if ExStat = 0 then
  begin
    //PR: 16/02/2012 ABSEXCH-9795
    {$IFNDEF SOPDLL}
    if FileNum = MiscF then
      FileNum := CurrentDiscountFileNo;
    {$ENDIF}
    Blank(KeyS,Sizeof(KeyS));
    ExStat := Find_Rec(B_Unlock,F[FileNum], FileNum, RecPtr[FileNum]^, 0, KeyS)
  end;

  If (ExStat<>0) then
    LastErDesc:=Ex_ErrorDescription(132,ExStat);

  Result := ExStat;
end;

{* -------------------------------------------------------------------------- *}

Procedure CopyExCCDepToTKCCDep(Const CCDeptR : CostCtrType; Var ExCCDepRec  :  TBatchCCDepRec);
begin
  With ExCCDepRec do
  begin
    CCDepCode:=CCDeptR.PCostC;
    CCDepDesc:=CCDeptR.CCDesc;
    {$IFDEF COMTK}
    CCDepInactive := CCDeptR.HideAC;
    {$ENDIF}
  end;
end;

Procedure CCDepToExCCDep(Var ExCCDepRec  :  TBatchCCDepRec);
begin
  CopyExCCDepToTKCCDep(PassWord.CostCtrRec, ExCCDepRec);
end;

{* -------------------------------------------------------------------------- *}

FUNCTION EX_GETCCDEP(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     CCDEPTYPE    :  SMALLINT;
                     LOCK         :  WORDBOOL) : SMALLINT;
const
  CCStat : Array[0..1] of Boolean = (true, false);
var
  ExCCDepRec :  ^TBatchCCDepRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  Str255;
begin
  LastErDesc:='';
  Result:=0;

  if TestMode then
  begin
    ExCCDepRec:=P;
    if WordBoolToBool(Lock) then
      LockStr := 'True'
    else
      LockStr := 'False';

    ShowMessage ('Ex_GetCCDep:' + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'CCDepType: '  + IntToStr(CCDepType) + #10#13 +
                 'Lock: '       + LockStr);
  end; { TestMode = true }

  if not assigned(P) then
  begin
    Result := 32767;
    {exit;   Closed on 10.10.2000 }
  end;

  if PSize <> SizeOf(TBatchCCDepRec) then
  begin
    Result := 32766;
    {exit; Closed on 10.10.2000 }
  end;

  { Closed EXIT and added this condition }
  If (Result=0) then
  begin

      { An index MUST be used as cost centres and departments are part of }
      { a variant record structure i.e. step functions won't work }
      case SearchMode of
        B_StepFirst : SearchMode := B_GetFirst;
        B_StepNext  : SearchMode := B_GetNext;
        B_StepLast  : SearchMode := B_GetLast;
        B_StepPrev  : SearchMode := B_GetPrev;
      end;

      Locked := false;

      { Cost Centre / Department - ensure in range 0 to 1}
      if not CCDepType in [0,1] then
        CCDepType := 0;

      { Search using code or description - ensure in range 0 to 1}
      if not SearchPath in [0,1] then
        SearchPath := 0;

      KeyS := StrPas(SearchKey);

      if KeyS <> '' then
        case SearchPath of
          0 : KeyS := LJVar(UpCaseStr(KeyS),CCDpLen); { Code }
          1 : KeyS := UpCaseStr(KeyS); { Desc }
        end; { case }

      case SearchMode of
        B_GetFirst :
          begin
            KeyS := CostCCode + CSubCode[CCStat[CCDepType]];
            SearchMode := B_GetGeq;
          end;
        B_GetLast :
          begin
            KeyS := CostCCode + chr(ord(CSubCode[CCStat[CCDepType]])+1);
            SearchMode := B_GetLess;
          end;
      else
        KeyS := CostCCode + CSubCode[CCStat[CCDepType]] + KeyS;
      end; { case }

      ExCCDepRec := P;
      Blank(ExCCDepRec^,Sizeof(ExCCDepRec^));

      UseVariant(F[PWrdF]);
      Result := Find_Rec(SearchMode,F[PWrdF],PWrdF,RecPtr[PWrdF]^,SearchPath,KeyS);

      StrPCopy(SearchKey, KeyS);

      if Result = 0 then
      begin
        if (PassWord.RecPFix = CostCCode) and (Password.SubType = CSubCode[CCStat[CCDepType]]) then
          CCDepToExCCDep(ExCCDepRec^)
        else
          Result := 9;
      end;

      If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
      {$IFDEF WIN32}
      begin
        UseVariant(F[PWrdF]);
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,PWrdF,SilentLock,Locked)) then
          Result:=0;
        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,PWrdF,SilentLock,Locked));
      {$ENDIF}

  end; { if Result=0...}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(79,Result);

end; { Ex_GetCCDep }

{* -------------------------------------------------------------------------- *}

{* ---------------- Get VAT Rate --------------------- *}

FUNCTION EX_GETVATRATE(P       :  POINTER;
                       PSIZE   :  LONGINT)  :  SMALLINT;

var

  VT        :  VATType;

  SResult   :  Integer;

  ValidHed,
  ValidRec  :  Boolean;

  ExVATRec  :  ^TBatchVATRec;

begin
  LastErDesc:='';

  If TestMode Then
  Begin
    ExVATRec:=P;
    ShowMessage ('Ex_GetVATRate : ' + #10#13 +
                 'P^.VATCode    : '  + ExVATRec^.VATCode);

  End; { If }

  ExVATRec:=P;
  ValidHed:=BOn;
  ValidRec:=BOff;

  SResult:=32767;
  If ((P<>Nil) and (PSize=(SizeOf(TBatchVATRec)))) then
  begin
    SResult:=0;
    With ExVATRec^ do
    begin
      ValidRec:=(VATCode In VATSet);
      GenSetError(ValidRec,30001,SResult,ValidHed);

      If (SResult=0) then
      begin
        VT:=GetVATNo(VATCode,#0);
        VatRate:=Round_Up(SyssVAT^.VATRates.VAT[VT].Rate,4);
        VatDesc:=SyssVAT^.VATRates.VAT[VT].Desc;
      end;

    end;

  end
  else
    If (P<>Nil) then
      SResult:=32766;

  If (SResult<>0) then
    LastErDesc:=Ex_ErrorDescription(81,SResult);

  Ex_GetVATRate:=SResult;

end; {GetVATRate..}

{* -------------------------------------------------------------------------- *}

PROCEDURE EX_SILENTLOCK(SILENT  :  WORDBOOL);
begin

  LastErDesc:='';

  If WordBoolToBool(Silent) then
    SilentLock := WordBoolToBool(Silent);

end; {proc..}

{* -------------------------------------------------------------------------- *}

{ Retrieves a currency record from SyssCurr }
FUNCTION EX_GETCURRENCY(P     : POINTER;
                        PSIZE : LONGINT;
                        CURR  : SMALLINT) : SMALLINT;
Var
  VT        :  VATType;
  SResult   :  Integer;
  ValidHed,
  ValidRec  :  Boolean;
  ExCurrRec :  ^TBatchCurrRec;
begin
  LastErDesc:='';

  ExCurrRec := P;

  If (TestMode) Then
  Begin
    ShowMessage ('Ex_GetCurrency : ' + #10#13 +
                 'Curr : '  + IntToStr(Curr));
  End; { If }

  SResult:=32767;
  If (P<>Nil) and (PSize=SizeOf(TBatchCurrRec)) Then Begin
    SResult:=0;

    ValidHed:=BOn;
    ValidRec:=(Curr >= 0) And (Curr <= CurrencyType);
    GenSetError(ValidRec,30001,SResult,ValidHed);

    //PR 03/01/02 Added to ensure that tk has been opened
    if SResult = 0 then
      if not DataIsOpen then
        SResult := 3;


    If (SResult=0) Then Begin
      FillChar (ExCurrRec^, SizeOf(ExCurrRec^), #0);
      With ExCurrRec^ Do Begin
        Name        := SyssCurr^.Currencies[Curr].Desc;
        ScreenSymb  := SyssCurr^.Currencies[Curr].SSymb;
        PrinterSymb := SyssCurr^.Currencies[Curr].PSymb;
        DailyRate   := SyssCurr^.Currencies[Curr].CRates[BOn];
        CompanyRate := SyssCurr^.Currencies[Curr].CRates[BOff];
        TriEuro     := SyssGCur^.GhostRates.TriEuro[Curr];
        TriRates    := SyssGCur^.GhostRates.TriRates[Curr];
        TriInvert   := BoolToWordBool(SyssGCur^.GhostRates.TriInvert[Curr]);
        TriFloat    := BoolToWordBool(SyssGCur^.GhostRates.TriFloat[Curr]);

      End; { With }
    End; { If }
  End { If }
  Else
    If (P<>Nil) then
      SResult:=32766;

  If (SResult<>0) then
    LastErDesc:=Ex_ErrorDescription(90,SResult);

  Ex_GetCurrency := SResult;
end; { Ex_GetCurrency }

{* -------------------------------------------------------------------------- *}

{ Stores a currency record}
FUNCTION EX_STORECURRENCY(P     : POINTER;
                        PSIZE : LONGINT;
                        CURRENCY  : SMALLINT) : SMALLINT;
Var
  VT        :  VATType;
  SResult   :  Integer;
  ValidHed,
  ValidRec  :  Boolean;
  ExCurrRec :  ^TBatchCurrRec;
  SysMode   : SysRecTypes;
  Locked, BResult : Boolean;
  { CJS 2013-03-05 - ABSEXCH-14003 - Currency Audit }
  CurrencySetupAudit : IBaseAudit;
begin
  LastErDesc:='';

  ExCurrRec := P;


  If (TestMode) Then
  Begin
    ShowMessage ('Ex_StoreCurrency : ' + #10#13 +
                 'Curr : '  + IntToStr(Currency));
  End; { If }

  SResult:=32767;
  If (P<>Nil) and (PSize=SizeOf(TBatchCurrRec)) Then Begin
    SResult:=0;

    ValidHed:=BOn;
    ValidRec:=(Currency >= 0) And (Currency <= CurrencyType);
    GenSetError(ValidRec,30001,SResult,ValidHed);

    //PR 03/01/02 Added to ensure that tk has been opened
    if SResult = 0 then
      if not DataIsOpen then
        SResult := 3;


    If (SResult=0) Then
    Begin
      ValidRec := ExCurrRec^.DailyRate > 0.0;
      GenSetError(ValidRec,30002,SResult,ValidHed);

      if SResult = 0 then
      begin

        SysMode := SysRecTypes(Ord(CurR) + ((Currency - 1) div 30));

        BResult := GetMultiSys(False,Locked, SysMode);

        if BResult and Locked then
        begin
          { CJS 2013-03-05 - ABSEXCH-14003 - Currency Audit }
          CurrencySetupAudit := NewAuditInterface(atCurrencySetup);
          CurrencySetupAudit.BeforeData := SyssCurr;

          ExCurrRec^.DailyRate := Round_Up(ExCurrRec^.DailyRate, 6);
          SyssCurr^.Currencies[Currency].CRates[BOn] := ExCurrRec^.DailyRate;
          { CJS 2013-03-05 - ABSEXCH-14003 - Currency Audit }
          if PutMultiSys(SysMode, True) and Assigned(CurrencySetupAudit) then
          begin
            CurrencySetupAudit.AfterData := SyssCurr;
            CurrencySetupAudit.WriteAuditEntry;
            CurrencySetupAudit := nil;
          end;
        End
        else
        begin
          if not Locked then
            SResult := 84
          else
            SResult := 30003;
        end;

        //PR: 27/07/2012 ABSEXCH-12956 Successful save - add currency history record
        if SResult = 0 then
        begin
          //Get ghost record
          //Adding 4 gets us from CurR to GCuR, etc.
          SysMode := SysRecTypes(Ord(SysMode) + 4);
          Locked := False;
          GetMultiSys(False, Locked, SysMode);

          //Store currency history record
          with TCurrencyHistory.Create do
          Try
            SetDataRec(SyssCurr^.Currencies, SyssGCur^.GhostRates, Currency);
            Save;
          Finally
            Free;
          End;
        end;

      end;

    End; { If }
  End { If }
  Else
    If (P<>Nil) then
      SResult:=32766;

  If (SResult<>0) then
    LastErDesc:=Ex_ErrorDescription(157,SResult);

  Result := SResult;
end; { EX_STORECURRENCY }

{* -------------------------------------------------------------------------- *}


{* To get Syss. data - 13.05.98 *}
FUNCTION EX_GETSYSDATA(P            :  POINTER;
                       PSIZE        :  LONGINT)  :  SMALLINT;
var
  SysDataRec   :  ^TBatchSysRec;
  i,
  SResult      :  Integer;
begin

  LastErDesc:='';
  SysDataRec := P;

  SResult:=32767;
  If (P<>Nil) and (PSize=SizeOf(TBatchSysRec)) then
  begin
    SResult:=0;

    //PR 03/01/02 Added to ensure that tk has been opened
    if not DataIsOpen then
      SResult := 3;

    If (SResult=0) then
    Begin
      FillChar (SysDataRec^, SizeOf(SysDataRec^), #0);
      With SysDataRec^ Do Begin
        UserName:=Syss.UserName;
        For i:=1 to 5 do
          UserAddr[i]:=Syss.DetailAddr[i];

        //PR: 10/09/2013 ABSEXCH-14598 change to use new fields
        UserSort:=DecryptBankSortCode(Syss.ssBankSortCode);
        UserAcc:=DecryptBankAccountCode(Syss.ssBankAccountCode);
        UserRef:=Syss.UserRef;
        UserBank:=Syss.UserBank;

        ExPr:=Syss.CPr;
        ExYr:=Syss.CYr;

        DirectCust := Syss.DirectCust;
        DirectSupp := Syss.DirectSupp;

        PriceDP := Syss.NoNetDec;
        CostDP := Syss.NoCosDec;
        QuantityDP := Syss.NoQtyDec;

        if Syss.UseMLoc then
          MultiLocn := 2
        else
          if Syss.UseLocDel then
            MultiLocn := 1
          else
            MultiLocn := 0;

        UserVatReg := Syss.UserVATReg;
        PeriodsPerYr := Syss.PrinYr;
        CCDepts := BoolToWordBool(Syss.UseCCDep);
        IntraStat := BoolToWordBool(Syss.IntraStat);
        ExchangeRate := Syss.TotalConv;
        FinYearStart := Syss.MonWk1;
        CurrentCountry := Syss.USRCntryCode;
        OrderAllocStock := BoolToWordBool(Syss.UsePick4All);

        //Customer
        TraderUDFLabel[1] := CustomFields[cfCustomer,1].cfCaption;
        TraderUDFLabel[2] := CustomFields[cfCustomer,2].cfCaption;
        TraderUDFLabel[3] := CustomFields[cfCustomer,3].cfCaption;
        TraderUDFLabel[4] := CustomFields[cfCustomer,4].cfCaption;

        //Stock rec
        StockUDFLabel[1] := CustomFields[cfStock,1].cfCaption;
        StockUDFLabel[2] := CustomFields[cfStock,2].cfCaption;
        StockUDFLabel[3] := CustomFields[cfStock,3].cfCaption;
        StockUDFLabel[4] := CustomFields[cfStock,4].cfCaption;

        //SIN
        TransHeadUDFLabel[1] := CustomFields[cfSINHeader,1].cfCaption;
        TransHeadUDFLabel[2] := CustomFields[cfSINHeader,2].cfCaption;
        TransHeadUDFLabel[3] := CustomFields[cfSINHeader,3].cfCaption;
        TransHeadUDFLabel[4] := CustomFields[cfSINHeader,4].cfCaption;

        //SIN Enable State
        TransHeadUDFHide[1] := BoolToWordBool(not CustomFields[cfSINHeader,1].cfEnabled);
        TransHeadUDFHide[2] := BoolToWordBool(not CustomFields[cfSINHeader,2].cfEnabled);
        TransHeadUDFHide[3] := BoolToWordBool(not CustomFields[cfSINHeader,3].cfEnabled);
        TransHeadUDFHide[4] := BoolToWordBool(not CustomFields[cfSINHeader,4].cfEnabled);

        for i := 1 to 4 do
          TransLineUDFLabel[i] := CustomFields[cfSINLine,i].cfCaption;
        for i := 1 to 4 do
          TransLineUDFHide[i] := BoolToWordBool(not CustomFields[cfSINLine,i].cfEnabled);

        for i := 1 to 4 do
          TransLineTypeLabel[i] := CustomFields[cfLinetypes,i].cfCaption;
        for i := 1 to 4 do
          TransLineTypeHide[i] := BoolToWordBool(not CustomFields[cfLinetypes,i].cfEnabled);

        for i := 1 to 2 do
          JobCostUDFLabel[i] := CustomFields[cfJob,i].cfCaption;

        CalPrFromDate:=BoolToWordBool(Syss.AutoPrCalc);

        {NF: 15/03/2001}
        UseCrLimitChk := BoolToWordBool(Syss.UseCrLimitChk);
        UseCreditChk := BoolToWordBool(Syss.UseCreditChk);
        StopBadDr := BoolToWordBool(Syss.StopBadDr);
        UsePick4All := BoolToWordBool(Syss.UsePick4All);
        FreeExAll := BoolToWordBool(Syss.FreeExAll);
        WksODue := Syss.WksODue;

        DeductBOMComponents := BoolToWordBool(Syss.DeadBOM);
        //PR 28/08/03 new fields for v5.52 multi-bin
        FilterSNoByBinLoc := BoolToWordBool(Syss.FiltSNoBinLoc);
        KeepBinHistory   := BoolToWordBool(Syss.KeepBinHist);
        BinMask := Syss.BinMask;
        InputPackQtyOnLine := BoolToWordBool(Syss.InpPack);

        //PR 9/07/04
        {$IFNDEF COMTK}
        PercentageDiscounts := BoolToWordBool(Syss.DefPcDisc);
        {$ENDIF}

        TTDEnabled := BoolToWordBool(Syss.EnableTTDDiscounts);
        VBDEnabled := BoolToWordBool(Syss.EnableVBDDiscounts);

        //PR 10/09/2009
        ECServicesEnabled := BoolToWordBool(SyssVAT^.VATRates.EnableECServices);
        ECSalesThreshold := SyssVAT^.VATRates.ECSalesThreshold;

        //PR: 15/10/2010
        EnableOverrideLocations := BoolToWordBool(Syss.EnableOverrideLocations);

        //PR: 28/11/2013 ABSEXCH-14797
        ConsumersEnabled := BoolToWordBool(Syss.ssConsumersEnabled);

      End; { With }
    End; { If }
  End { If }
  Else
    If (P<>Nil) then
      SResult:=32766;

  If (Sresult<>0) then
    LastErDesc:=Ex_ErrorDescription(91,SResult);

  Ex_GetSysData := SResult;
end; {Ex_GetSysData ..}


{* -------------------------------------------------------------------------- *}

FUNCTION EX_GETECOMMSDATA(P            :  POINTER;
                          PSIZE        :  LONGINT)  :  SMALLINT;
var
  SysECommsRec : ^TSysECommsRec;
begin
  LastErDesc:='';

  Result := 0;
  if not assigned(P) then
    Result := 32767;
  if PSize <> SizeOf(TSysECommsRec) then
    Result := 32766;

  if (Result=0) then
  begin

    SysECommsRec := P;

    FillChar(SysECommsRec^, SizeOf(SysECommsRec^), #0);
    with SysECommsRec^ do
    begin
      YourEmailName  := SyssEDI2.EDI2Value.EmName;
      YourEmailAddr  := SyssEDI2.EDI2Value.EmAddress;
      SMTPServerName := SyssEDI2.EDI2Value.EmSMTP;
      Priority       := SyssEDI2.EDI2Value.EmPriority;
      UseMAPI        := BoolToWordBool(SyssEDI2.EDI2Value.EmUseMAPI);
    end;

  end; { If Result=0..}

  LastErDesc:=Ex_ErrorDescription(135,Result);

end; { Ex_GetECommsData }


{* -------------------------------------------------------------------------- *}


FUNCTION EX_DATETOENTPERIOD(TRANSDATE : PCHAR;
                            VAR FINPERIOD,
                                FINYEAR : SMALLINT) : SMALLINT;
// Pre : TransDate in format yyyymmdd
const
  DAYS_PER_MONTH : array[1..12] of byte = (31,28,31,30,31,30,31,31,30,31,30,31);
var
  Year, Month, Day : integer;
  AcPr, AcYr : Byte;
  strDate : str8;
begin
  Year := 0;
  Month := 0;

  LastErDesc:='';

  Result := 0;
  if not assigned(TransDate) then
    Result := 30000;

  if Result = 0 then
    try
      Year := StrToInt(copy(TransDate, 1, 4));
      Year := Year - 1900;
      if (Year < 0) or (Year > 255) then
        Result := 30001;
    except
      Result := 30001;
    end;

  if Result = 0 then
    try
      Month := StrToInt(copy(TransDate, 5, 2));
      if (Month < 1) or (Month > 12) then
        Result := 30002;
    except
      Result := 30002;
    end;

  if Result = 0 then
    try
      Day := StrToInt(copy(TransDate, 7, 2));
      //PR 15/04/05 - Added + 1900, so that IsLeapYear would work correctly
      if (Month = 2) and IsLeapYear(Year + 1900) then
      //  Changed from incrementing as the const array persisted between calls to the function.
      //  inc(DAYS_PER_MONTH[2]);
        DAYS_PER_MONTH[2] := 29;
      if (Day < 1) or (Day > DAYS_PER_MONTH[Month]) then
        Result := 30003;
    except
      Result := 30003;
    end;

  if Result = 0 then
  begin
    strDate := TransDate;
    (* HM 11/07/01: Updated Period Calculation to do same as Enterprise
    FinPeriod := Fin_Pr(strDate);
    FinYear := TxlateYrVal(Fin_Yr(strDate), true);
    *)
    SimpleDate2Pr(StrDate, AcPr, AcYr);
    FinPeriod := AcPr;
    FinYear := AcYr;
  end;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(138,Result);

end; {EX_DATETOENTPERIOD..}

{$IFDEF WIN32}

{* -------------------------------------------------------------------------- *}

{* --- Convert External Auto Bank Reconciliation Record into Exch. Record --- *}

function ExBankToBank(ExAutoBank  :  TBatchAutoBankRec )  :  Integer;
Const
  DrCrReverse =  -1;  {Bank Dr (-) Value = Exch. Cr (Payment) }

Var
  ValidHed,
  ValidCheck  :  Boolean;
begin
  Result:=0;
  VAlidHed:=BOn;
  ValidCheck:=BOff;

  With MiscRecs^.BankMRec do
  begin
    MiscRecs^.RecMFix:=MBankHed;
    MiscRecs^.SubType:=MBankSub;

    BankRef:=ExAutoBank.BankRef;
    BankValue:=(ExAutoBank.BankValue*DrCrReverse);

    BankNom:=ExAutoBank.BankNom;
    { If conditions are for Tomkins ..}
    If (BankNom=0) then
      BankNom:=ExSyss.DefNom;

    BankCr:=ExAutoBank.BankCr;
    If (ExSyss.MCMode) and (BankCr=0) then
      BankCr:=ExSyss.DefCur;

    BankMatch:=PartBankMKey(BankNom,BankCr);

    EntryOpo:=ExAutoBank.EntryOpo;

    EntryDate:=ExAutoBank.EntryDate;

    {* ----- Start Validation ------ *}

    {* Nominal Code *}
    ValidCheck:=(BankNom<>0) and
                (CheckRecExsists(Strip('R',[#0],FullNomKey(BankNom)),NomF,NomCodeK));

    ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

    GenSetError(ValidCheck,30001,Result,ValidHed);

    {* Check Currency *}

    If (ExSyss.MCMode) then
      ValidCheck:=((BankCr>=1) and (BankCr<=CurrencyType))
    else
    begin
      BankCr:=0;
      ValidCheck:=BOn;
    end;
    GenSetError(ValidCheck,30002,Result,ValidHed);

    {* Check Bank Account Code only if it is assigned *}
    Validcheck:=EmptyKey(ExAutoBank.AccountCode,SizeOf(ExAutoBank.AccountCode));
    If (Not ValidCheck) then
    begin
      //PR: 29/08/2013 MRD
      ValidCheck:=(ExAutoBank.AccountCode=DecryptBankAccountCode(Syss.ssBankAccountCode));
      GenSetError(ValidCheck,30003,Result,ValidHed);
    end; {if..}

    {* Check Bank Sort Code only if it is assigned *}
    Validcheck:=EmptyKey(ExAutoBank.SortCode,SizeOf(ExAutoBank.SortCode));
    If (Not ValidCheck) then
    begin
      ValidCheck:=(ExAutoBank.SortCode=DecryptBankSortCode(Syss.ssBankSortCode));
      GenSetError(ValidCheck,30004,Result,ValidHed);
    end; {if..}

  end; {with..}
end; {func..}

{* -------------------------------------------------------------------------- *}

{*  ------------- To Store Automatic Bank Reconciliation Record ------------- *}

FUNCTION EX_STOREAUTOBANK(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;

Const
  Fnum     =  MiscF;
  KeyPath  =  MIK;
Var
  ExAutoBank :  ^TBatchAutoBankRec;
  KeyS       :  Str255;

  BankMCtrlRec  :  PassWordRec;

  LastCreated   :  Str10;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExAutoBank:=P;
    ShowMessage('Ex_StoreAutoBank:' + #10#13 +
                'P^.BankCode: ' + ExAutoBank^.BankRef + #10#13 +
                'PSize: ' + IntToStr(PSize));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchAutoBankRec)) then
  Begin

    ExAutoBank:=P;

    Result:=ExBankToBank(ExAutoBank^);

    If (SearchMode<>CheckMode) and (Result=0) then
    {With ExAutoBank^ do}
    With MiscRecs^.BankMRec do
    begin
      {* Get BACS Record from PWrdF File *}
      { Closed and changed - 26.08.99
      LastCreated:=EntryDate;
      BankM_CtrlGet(PWrdF,PWK,ExSyss.DefNom,ExSyss.DefCur,LastCreated,BankMCtrlRec);}

      BankM_CtrlGet(PWrdF,PWK,BankNom,BankCr,EntryDate,BankMCtrlRec);

      {* Add record into Misc File *}
      Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      {* Update BACS Record in PWrdF File *}
      If (Result=0) then
      begin
        BankM_CtrlCalc(PWrdF,PWK,BankNom,BankCr,BankValue,BOff,BOff,BOff,BankMCtrlRec);

        BankM_CtrlCalc(PWrdF,PWK,BankNom,BankCr,0,BOff,BOn,BOff,BankMCtrlRec);

      end;

        { Closed and changed - 26.08.99
        BankM_CtrlCalc(PWrdF,PWK,ExSyss.DefNom,ExSyss.DefCur,ExAutoBank^.BankValue,BOff,BOn,BOff,BankMCtrlRec);}

    end; {if..}

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(92,Result);

end; {Ex_StoreAutoBank Func..}

{$ENDIF}


{$IFDEF WIN32}

{* -------------------------------------------------------------------------- *}
{* ------ Check User Name and Password ------ *}
Function EX_CHECKPASSWORD(USERNAME      :  PCHAR;
                          USERPASSWORD  :  PCHAR)  :  SMALLINT;
Var
  KeyS,
  TUser,
  TPass   :  Str255;

  ValidCheck,
  ValidHed,
  UserFound    :  Boolean;

  TResult : Integer;
  UserRec : tPassDefType;

  sDomain, sUserAndDomain,
  sUserId, sPassword : AnsiString;

  //PR: 31/08/2017 ABSEXCH-18857 function to separate domain and user
  procedure SplitDomainAndUser(const DomainPlusUser : AnsiString;
                                 var DomainString   : AnsiString;
                                 var UserString     : AnsiString);
  var
    i : integer;
  begin
    DomainString := '';
    UserString := '';
    i := Pos('\', DomainPlusUser);
    if i = 0 then
      UserString := DomainPlusUser
    else
    begin
      DomainString := Copy(DomainPlusUser, 1, i-1);
      UserString := Copy(DomainPlusUser, i + 1, Length(DomainPlusUser));
    end;
  end;

begin
  LastErDesc:='';
  Result:=0;
  TResult := 0;
  VAlidCheck:=BOn;
  ValidHed:=BOff;

  TUser:= Trim(StrPas(UserName));
  TPass:= Trim(StrPas(UserPassword));

  //PR: 31/08/2017 ABSEXCH-18857 Changed to use tPassDefRec in MLocStk
  With MLocCtrl^.PassDefRec do
  begin

      //Check authentication mode - Exchequer or Windows
      if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
      begin
        //Passed-in UserID should be in format Domain\UserId
        sUserAndDomain := TUser;
        sPassword := TPass;
        SplitDomainAndUser(sUserAndDomain, sDomain, sUserId);

        //If domain hasn't been provided then default to current domain
        if Trim(sDomain) = '' then
          sDomain := GetWindowDomainName;

        //Read through users and find one with this windows domain and Id
        UserFound := False;
        KeyS := FullPWordKey(PassUCode, 'D', '');
        UseVariant(F[MLocF]);
        Status := Find_Rec(B_GetGEq,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,KeyS);

        while (Status = 0) and (MLocCtrl.RecPFix = PassUCode) and
                               (MLocCtrl.SubType = 'D') and
                               not UserFound do
        begin
          //PR: 27/10/2017 ABSEXCH-19312 Need to make comparison case-insensitive
          UserFound := Trim(UpperCase(sDomain + '\' + sUserId)) = Trim(UpperCase(WindowUserId));

          if not UserFound then  //read next user record
            Status := Find_Rec(B_GetNext,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,KeyS);
        end; //while not UserFound

        ValidCheck := UserFound;

        if ValidCheck then //Authenticate user and password
          ValidCheck := WindowAuthenticate(sUserID, sPassword, sDomain);
      end
      else
      begin
        //Exchequer validation - find user from UserID passed in
        KeyS := FullPWordKey(PassUCode, 'D', TUser);
        UseVariant(F[MLocF]);
        Status := Find_Rec(B_GetEq,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,KeyS);

        ValidCheck:=(Status=0) and (CheckKey(TUser,LogIn,Length(TUser),BOn));

        if ValidCheck then //Check password
          ValidCheck := PasswordHash = StrToSHA3Hase(PasswordSalt + Trim(TPass));

        GenSetError(ValidCheck,30001,TResult,ValidHed);
      end; //not Windows Authentication

      GenSetError(ValidCheck,30001,TResult,ValidHed);

      //PR: 31/08/2017 ABSEXCH-18857 New error - user suspended
      if ValidCheck then
      begin
        ValidCheck := UserStatus = usActive;

        GenSetError(ValidCheck,30003,TResult,ValidHed);
      end;


  end; {with..}

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(120,TResult);

  Result := TResult;

end; {func..}

Function EX_GETPASSWORD(USERNAME :  string) : string;
Var
  KeyS,
  TUser,
  TPass   :  Str255;

  ValidCheck,
  ValidHed    :  Boolean;
  TResult     :  Integer;


begin
  LastErDesc:='';
  TResult:=0;
  VAlidCheck:=BOn;
  ValidHed:=BOff;

  TUser:=UserName;
  TUser:=LjVar(TUser,LogInKeyLen); {LoginKeyLen);}

  KeyS:=FullPWordKey(PassUCode,C0,TUser);  {RecPFix, SubType, UserName}
  Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

  With Password.PassEntryRec do
  begin

    ValidCheck:=(Status=0) and (CheckKey(TUser,LogIn,Length(LogIn),BOn));

    If (ValidCheck) then
    begin
      ChangeCryptoKey(23130);
      Result :=Strip('B',[#32],Decode(PWord));

    end
    else
      Result := '';

  end; {with..}

end; {func..}


{* -------------------------------------------------------------------------- *}

{* To get the number of records *}
FUNCTION EX_FILESIZE(FILENUM  :  SMALLINT)  :  LONGINT;
Var
  ChkOK  :  Boolean;
  Fnum :  Integer;

begin
  { Usage : LongInt:=Used_Recs(F[Fn],Fn); }
  LastErDesc:='';
  Result:=0;
  FNum:=FileNum;

  ChkOk:=(FNum In [CustF,InvF,IDetailF,NomF,StockF,JobF]);

  If (Not ChkOk) then
    Result:=-1
  else
    Result:=Used_Recs(F[FNum],FNum);

  If (Result=-1) then
    LastErDesc:='The required File Number is not valid';

end; {func..}

{$ENDIF}  {* WIN32...*}


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

FUNCTION EX_GETRECORDADDRESS(    FILENUM     :  SMALLINT;
                             Var RECADDRESS  :  LONGINT)  :  SMALLINT;

Var
  ExStat      :  Integer;
  ValidHed,
  ValidCheck  :  Boolean;
  TAddr       :  LongInt;

begin
  LastErDesc:='';
  ExStat:=0;
  Result:=0;
  RecAddress:=0;
  TAddr:=0;

  ValidHed:=BOff;
  ValidCheck:=(FileNum In [1..5,8,9,11]);

  { Invalid File No. }
  GenSetError(ValidCheck,30001,ExStat,ValidHed);

  //PR: 16/02/2012 ABSEXCH-9795
  {$IFNDEF SOPDLL}
  if FileNum = MiscF then
    FileNum := CurrentDiscountFileNo;
  {$ENDIF}
  If (ValidCheck) then
  begin
    ExStat:=GetPos(F[FileNum],FileNum,TAddr);
    If (ExStat=0) then
      RecAddress:=TAddr;
    ValidCheck:=(ExStat=0);
    GenSetError(ValidCheck,30002,ExStat,ValidHed);

  end; {if..}

  If (ExStat<>0) then
    LastErDesc:=Ex_ErrorDescription(122,ExStat);

  Ex_GetRecordAddress:=ExStat;

end; {Ex_GetRecordAddress..}


FUNCTION EX_GETRECWITHADDRESS(FILENUM,
                              KEYPATH  :  SMALLINT;
                              TRECADDR :  LONGINT )  :  SMALLINT;

var
  ExStat  :  Integer;
  ValidHed,
  ValidCheck  :  Boolean;

begin
  ExStat:=0;
  LastErDesc:='';

  ValidHed:=BOff;
  ValidCheck:=(FileNum In [1..5,8,9,11]);
  { Invalid File No. }
  GenSetError(ValidCheck,30001,ExStat,ValidHed);

  if ExStat = 0 then
    case FileNum of
      InvF:
        begin
          ValidCheck := KeyPath in [0..11];
          GenSetError(ValidCheck,30003,ExStat,ValidHed);
        end;
       IDetailF:
         begin
           ValidCheck := KeyPath in [0..4];
           GenSetError(ValidCheck,30003,ExStat,ValidHed);
         end;
    end;

    //PR: 16/02/2012 ABSEXCH-9795
    {$IFNDEF SOPDLL}
    if FileNum = MiscF then
      FileNum := CurrentDiscountFileNo;
    {$ENDIF}

  Case FileNum of
    CustF    :  Move(TRecAddr,Cust,SizeOf(TRecAddr));
    InvF     :  Move(TRecAddr,Inv,SizeOf(TRecAddr));
    IDetailF :  Move(TRecAddr,Id,SizeOf(TRecAddr));
    NomF     :  Move(TRecAddr,Nom,SizeOf(TRecAddr));
    StockF   :  Move(TRecAddr,Stock,SizeOf(TRecAddr));
    PWrdF    :  Move(TRecAddr,PassWord,SizeOf(TRecAddr));
    MiscF    :  Move(TRecAddr,MiscRecs^,SizeOf(TRecAddr));
    JobF     :  Move(TRecAddr,JobRec^,SizeOf(TRecAddr));
    QtyBreakF:  Move(TRecAddr,QtyBreakRec,SizeOf(TRecAddr));
  end; {case..}

  If (ExStat=0) then
  begin
    { Need to map indexes for transaction header file }
    case FileNum of
      InvF : KeyPath := KeyInvFXLate[KeyPath];
      IDetailF : KeyPath := KeyIDXLate[KeyPath];
    end;

    ExStat:=GetDirect(F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,0);
    ValidCheck:=(ExStat=0);
    GenSetError(ValidCheck,30002,ExStat,ValidHed);
  end; {if..}

  If (ExStat<>0) then
    LastErDesc:=Ex_ErrorDescription(123,ExStat);

  Ex_GetRecWithAddress:=ExStat;
end;  {func..}

FUNCTION EX_GETTAXWORD : String;
begin
  LastErDesc := '';
  Result := GetIntMsg(1);
end;  {func..}

FUNCTION EX_CHECKMODULERELEASECODE(Const iModuleNo : SmallInt) : SmallInt;
begin
  if ModRelMode(iModuleNo) = 1 then Result := 2
  else begin
    if (not Check_RelDateExp(iModuleNo, TRUE)) then Result := 1
    else Result := 0;
  end;{if}

  If (Result<>0) then LastErDesc:=Ex_ErrorDescription(151,Result);
end;  {func..}

//Added 29/06/2001 PR
function Ex_UserNames : WideString;
var
  KeyS : Str255;
begin
   Result := '';
   KeyS:=FullPWordKey(PassUCode,C0,'');
   Status:=Find_Rec(B_GetGEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

   while (Status = 0) and (Password.RecPfix = PassUCode) and (Password.SubType = C0) do
   begin
     //if (Password.RecPfix = PassUCode) and (Password.SubType = C0) then
     Result := Result + Trim(Password.PassEntryRec.Login) + ',';

     Status:=Find_Rec(B_GetNext,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);
   end;

   if Length(Result) > 0 then
     Delete(Result, Length(Result), 1);
end;

//Added 29/10/2001 PR
function Ex_UserProfileString(const ALogin : WideString; WhichString : Byte) : WideString;
Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

  WantEmail = 0;
  WantFullName = 1;

Var
  KeyS :  Str255;
  Res : SmallInt;

Begin
  FillChar(Result,Sizeof(Result), #0);

  KeyS := FullPWordKey(PassUCode, 'D', ALogin);


  Res := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  If (Res = 0) then
  begin
    Case WhichString of
      WantEmail    : Result := MLocCtrl^.PassDefRec.emailAddr;
      WantFullName : Result := MLocCtrl^.PassDefRec.UserName;
    end;
  end
  else
    Result := '';
end;

//PR 03/01/02 Function to check whether data files have been opened.  Do a getfilespec
//on cust file - any result other than 3 (file not open) tells us the file has been opened.
function DataIsOpen : Boolean;
var
  Status : SmallInt;
  FSpec   : FileSpec;
  KeyS : Str255;
begin
      //PR: 06/11/2009 Removed GetFileSpec call to improve performance under SQL
//  Status := GetFileSpec(F[CustF], CustF, FSpec);
  Status := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, 0, KeyS);
  Result := not (Status = 3);
end;

{$IFDEF COMTK}
function TkCCDepToExCCDep(ExCCDepRec : TBatchCCDepRec; IsCostCentre : Boolean; var StoreMode : SmallInt) : SmallInt;
var
  KeyS :  Str255;
  Res  : Integer;
begin

  if Trim(ExCCDepRec.CCDepCode) <> '' then
  begin

    with Password do
      KeyS := FullCCKey(CostCCode, CSubCode[IsCostCentre], ExCCDepRec.CCDepCode);

    Res := Find_Rec(B_GetEq, F[PwrdF], PwrdF, RecPtr[PWrdF]^, 0, KeyS);

    If (StoreMode=CheckMode) or (StoreMode=ImportMode) then
    begin
      If (Res = 0) then
        StoreMode :=B_Update
      else
        StoreMode :=B_Insert;
    end;


    if (Res = 0) and (StoreMode = B_Insert) then
      Result := 5
    else
    if (Res <> 0) and (StoreMode = B_Update) then
      Result := 4
    else
      Result := 0;

    if Result = 0 then
    begin
      if StoreMode = B_Insert then
        FillChar(Password, SizeOf(Password), 0);
      Password.RecPfix := CostCCode;
      Password.SubType := CSubCode[IsCostCentre];
      Password.CostCtrRec.PCostC := LJVar(ExCCDepRec.CCDepCode, 3);
      Password.CostCtrRec.CCDesc := LJVar(ExCCDepRec.CCDepDesc, 30);
      Password.CostCtrRec.HideAC := ExCCDepRec.CCDepInactive;
    end;

  end
  else
    Result := 30001; //Empty code


end;

FUNCTION EX_STORECCDEP(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       UPDATEMODE   :  SMALLINT;
                       CCDEPTYPE    :  SMALLINT) : SMALLINT;
var
  ExCCDepRec :  ^TBatchCCDepRec;
  TmpMode : SmallInt;
begin
  LastErDesc:='';

{  If TestMode Then Begin
    ExCustRec:=P;
    ShowMessage('Ex_StoreAccount:' + #10#13 +
                'P^.CustCode: ' + ExCustRec^.CustCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchCCDepRec)) then
  Begin

    ExCCDepRec:=P;

    {* SearchMode will be changed as B_Insert or B_Update
       if it is CheckMode or ImportMode *}

    TmpMode:=UpdateMode;

    Result:=TKCCDepToExCCDep(ExCCDepRec^, CCDEPType = 0, UpdateMode);

    {* If not CheckMode, Update accordingly *}

    If ((TmpMode<>CheckMode) and (Result=0)) then
    Case UpdateMode of

      B_Insert  :  Result:=Add_Rec(F[PwrdF], PwrdF, RecPtr[PWrdF]^, 0);

      B_Update  :  Result:=Put_Rec(F[PwrdF], PwrdF, RecPtr[PWrdF]^, 0);

    else           Result:=30000;

    end;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(4,Result);

end;
{$ENDIF COMTK}

{* To get Syss. data - 13.05.98 *}
FUNCTION EX_GETCOMPANYID : LongInt;
var
  SResult      :  Integer;
begin

  if not DataIsOpen then SResult := -3
  else SResult := SyssMod.ModuleRel.CompanyID;

  if (Sresult < 0) then LastErDesc := Ex_ErrorDescription(91,SResult)
  else LastErDesc := '';

  EX_GETCOMPANYID := SResult;
end; {Ex_GetSysData ..}


{$IFDEF EN551}
    Procedure CalcInvVATTotals(Var  InvR :  InvRec;
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


    Begin
        LineTotal:=0;
        ExStatus:=0;

        With InvR do
        Begin
          InvVat:=0;

          If (ReCalcVAT) then
            Blank(InvVatAnal,Sizeof(InvVatAnal));

          Blank(InvNetAnal,Sizeof(InvNetAnal));

          KeyChk:=FullNomKey(FolioNum);

          If (InvDocHed=NMT) then
          Begin
            KeyS:=FullIdKey(FolioNum,RecieptCode);

            InvNetVal:=0.0;
          end
          else
            KeyS:=FullIdKey(FolioNum,1);


        end;


        ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and ((Id.LineNo<>RecieptCode) or (Id.IdDocHed=NMT)) do
        Begin

          With Id do
          Begin
            {For NOM's all values must be in consoIdated currency}
            LineTotal:=Round_Up(Conv_TCurr(InvLTotal(Id,BOff,0),CXRate[UseCoDayRate],Currency,UseORate,BOff),2);

            If (ReCalcVAT) then
              InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]:=InvR.InvVatAnal[GetVAtNo(VATcode,VATIncFlg)]+Round_Up(Conv_TCurr(VAT,CXRate[UseCoDayRate],Currency,UseORate,BOff),2);

            If (IdDocHed=NMT) then
              UpdateRecBal(InvR,NomCode,NetValue,0.0,CXRate,Currency,UseORate,4);

            InvNetAnal[GetVAtNo(VATcode,VATIncFlg)] := InvNetAnal[GetVAtNo(VATcode,VATIncFlg)]+LineTotal;

          end; {With..}


          ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        end; {While..}


        InvR.InvVat:=CalcTotalVAT(InvR);



    end; {Proc..}
{$ENDIF}

FUNCTION EX_UPDATEAUDITDATE(NEWDATE : PCHAR) : SMALLINT; STDCALL; EXPORT;
VAR
  Res : Integer;
  Locked : Boolean;
  sDate : LongDate;
BEGIN
  Result := 0;
  if DataIsOpen then
  begin
    Locked := True;
    GetMultiSys(True, Locked, SysR);
    sDate := StrPas(NEWDATE);

    if ValidDate(sDate) then
    begin
      Syss.AuditDate := sDate;
    end
    else
      Result := 30000;

    PutMultiSys(SysR, True);
  end
  else
    Result := 3;
END;

end.

