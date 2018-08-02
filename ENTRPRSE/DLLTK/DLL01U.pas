UNIT DLL01U;

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
  VarCnst3,

  //PR: 14/02/2012 ABSEXCH-9795
  QtyBreakVar,
  StrUtil,
  SysU1;


{* ---------- Customer/Supplier (Accounts) Information --------------- *}

FUNCTION EX_GETACCOUNT(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       ACCTYPE      :  SMALLINT;
                       LOCK         :  WORDBOOL) : SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STOREACCOUNT(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT) : SMALLINT;
                         {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_UNLOCKACCOUNT : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_GETACCOUNTBALANCE(P          :  POINTER;
                              PSIZE      :  LONGINT;
                              ACCODE     :  PCHAR;
                              SEARCHMODE :  SMALLINT) : SMALLINT;
                              {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_ACCOUNTFILESIZE  :  LONGINT;
                               {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_HASOUTSTANDING(CUSTCODE  :  PCHAR) : WORDBOOL;
                           {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;


{* ---------- General Ledger (Nominal Accounts) Information --------------- *}

FUNCTION EX_GETGLACCOUNT(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHKEY    :  PCHAR;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT;
                         LOCK         :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STOREGLACCOUNT(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHPATH   :  SMALLINT;
                           SEARCHMODE   :  SMALLINT) : SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;


{* ----------  Discount Matrix Information --------------- *}

FUNCTION EX_STOREDISCMATRIX(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_GETDISCMATRIX(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT;
                          LOCK         :  WORDBOOL)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

// Delete a specified discount record using the record
// position to avoid problems with duplicate records
Function EX_DELETEDISCMATRIX (P          : Pointer;
                              PSize      : LongInt;
                              SearchPath : SmallInt;
                              RecPos     : LongInt) : SmallInt;
                              {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION TESTDISCOUNT  :  SMALLINT;
         {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{$IFDEF COMTK}
  Procedure CopyExCustToTKCust(Const CustR : CustRec; Var ExCustRec : TBatchCURec);

  Procedure CopyExNomToTKNom(Const NomR : NominalRec; Var ExNomRec  :  TBatchNomRec);

  Procedure ExCustDiscToTKCustDisc (Const ExCustDisc : CustDiscType;
                                    Var   TkCustDisc : TBatchDiscRec);

  Procedure ExQtyBrkToTKQtyBrk (Const ExQtyBrk : TQtyBreakRec;
                                Var   TkQtyBrk : TBatchDiscRec);
{$ENDIF}

{* ------------------------- *}

var
  //PR: 16/02/2012 This is used to keep track of whether the last call to Get_DiscMatrix used
  //MiscF or QtyBreakF. ABSEXCH-9795
  CurrentDiscountFileNo : Integer;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU, ETDateU, ETMiscU,
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
  DLSQLSup,
  // CJS: 25/03/2011 ABSEXCH-10687
  AuditIntf,
  //PR: 28/10/2011 v6.9
  AuditNotes,
  AuditNoteIntf,

  //PR: 29/08/2013 MRD
  EncryptionUtils,

  //PR: 29/11/2013 ABSEXCH-14797
  ConsumerUtils,

  //PR: 27/11/2014 Order Payments
  CountryCodeUtils, CountryCodes,

  Validate,
  oSystemSetup,

  //19387
  oAnonymisationDiaryObjIntf,
  oAnonymisationDiaryObjDetail,
  oAnonymisationDiaryBtrieveFile;

Const
  { Moved from GlobVar b/c of 16 bits compilation problem }
  { ======= for Nominal (Dec'96) ======== }

  Htyp           =  'H';                 {Posting Types}
  Ctyp           =  'C';
  Ftyp           =  'F';

  PostSet        =  ['A','B'];         {  Postable Nominal Codes  }

  NomTypeSet     =  [HTyp,CTyp,FTyp] ; {* Valid Nominal Types +PostSet *}


{* -------------------------------------------------------------------------- *}
{* Convert External Customer Data into Ex.Customer Record *}

Procedure CopyExCustToTKCust(Const CustR : CustRec; Var ExCustRec  :  TBatchCURec);
Var
  n  :  Byte;
Begin
  With ExCustRec do
  Begin
    CustCode:=CustR.CustCode;
    CustSupp:=CustR.CustSupp;
    Company:=CustR.Company;
    AreaCode:=CustR.AreaCode;
    RepCode:=CustR.RepCode;
    RemitCode:=CustR.RemitCode;
    VatRegNo:=CustR.VatRegNo;
    For n:=Low(Addr) to High(Addr) do
      Addr[n]:=CustR.Addr[n];
    DespAddr:=BoolToWordBool(CustR.DespAddr);
    For n:=Low(Addr) to High(Addr) do
      DAddr[n]:=CustR.DAddr[n];
    Contact:=CustR.Contact;
    Phone:=CustR.Phone;
    Fax:=CustR.Fax;
    RefNo:=CustR.RefNo;
    TradTerm:=BoolToWordBool(CustR.TradTerm);
    For n:=1 to 2 do
      STerms[n]:=CustR.STerms[n];
    Currency:=CustR.Currency;
    VATcode:=CustR.VATCode;
    PayTerms:=CustR.PayTerms;
    CreditLimit:=CustR.CreditLimit;
    Discount:=CustR.Discount;
    CreditStatus:=CustR.CreditStatus;
    CustCC:=CustR.CustCC;
    CDiscCh:=CustR.CDiscCh;
    CustDep:=CustR.CustDep;
    EECMember:=BoolToWordBool(CustR.EECMember);
    IncStat:=BoolToWordBool(CustR.IncStat);
    DefMLocStk:=CustR.DefMLocStk;
    AccStatus:=CustR.AccStatus;
    PayType:=CustR.PayType;

    //PR: 10/09/2013 ABSEXCH-14598
    {$IFDEF COMTK}
    acBankSortCode := DecryptBankSortCode(CustR.acBankSortCode);
    acBankAccountCode := DecryptBankAccountCode(CustR.acBankAccountCode);
    acMandateID := DecryptBankMandateID(CustR.acMandateID);
    acMandateDate := CustR.acMandateDate;
    {$ELSE}
    BankSort:= DecryptBankSortCode(CustR.acBankSortCode);
    BankAcc:= DecryptBankAccountCode(CustR.acBankAccountCode);
    {$ENDIF COMTK}
    BankRef:=CustR.BankRef;
    LastUsed:=CustR.LastUsed;
    Phone2:=CustR.Phone2;
    UserDef1:=CustR.UserDef1;
    UserDef2:=CustR.UserDef2;
    SOPInvCode:=CustR.SOPInvCode;
    SOPAutoWOff:=BoolToWordBool(CustR.SOPAutoWOff);
    BOrdVal:=CustR.BOrdVal;

    {* Default Nom Codes *}

    DefCtrlNom:=CustR.DefCtrlNom;     { Def. Control GL Code }
    DefNomCode:=CustR.DefNomCode;     { Def. Sales GL Code }
    DefCOSNom:=CustR.DefCOSNom;       { Def. COS GL Code }

    DirDeb:=CustR.DirDeb;
    CCDSDate:=CustR.CCDSDate;
    CCDEDate:=CustR.CCDEDate;
    CCDName:=CustR.CCDName;
    CCDCardNo:=CustR.CCDCardNo;
    CCDSARef:=CustR.CCDSARef;

    {* 17.11.98 - Sett.Disc.Days & % *}
    DefSetDDays:=CustR.DefSetDDays;
    DefSetDisc:=CustR.DefSetDisc;
    DefFormNo:=CustR.FDefPageNo;

    {*** Ver 4.31 New Fields ***}
    StatDMode  := CustR.StatDMode;
    EmailAddr  := CustR.EmailAddr;
    EmlSndRdr  := BoolToWordBool(CustR.EmlSndRdr);
    ebusPwrd   := DecodeKey(23130, CustR.ebusPwrd);
    PostCode   := CustR.Postcode;
    CustCode2  := CustR.CustCode2;
    AllowWeb   := Ord(CustR.AllowWeb);
    UserDef3   := CustR.UserDef3;
    UserDef4   := CustR.UserDef4;
    TimeChange := CustR.TimeChange;
    SSDDelTerms:= CustR.SSDDelTerms;
    CVATIncFlg := CustR.CVATIncFlg;
    SSDModeTr  := CustR.SSDModeTr;
    LastOpo    := CustR.LastOpo;
    InvDMode   := CustR.InvDMode;
    EmlSndHTML := BoolToWordBool(CustR.EmlSndHTML);
    WebLiveCat := CustR.WebLiveCat;
    WebPrevCat := CustR.WebPrevCat;

    SOPConsHo  := CustR.SOPConsHO;

    {*** End for V4.31 ***}

    { 03/04/01: Extended for v4.32 }
    EmlZipAtc := BoolToWordBool(CustR.EmlZipAtc > 0);
    EmlUseEDZ := BoolToWordBool(CustR.EmlZipAtc = 2);

    { 25/03/02: Extended for v5.00 }
    DefTagNo  := CustR.DefTagNo;

    {$IFDEF COMTK}
    OrderConsMode := CustR.OrdConsMode;
    VatCountryCode := CustR.VatRetRegC;
    acAllowOrderPayments := CustR.acAllowOrderPayments;
    acOrderPaymentsGLCode := CustR.acOrderPaymentsGLCode;
    {$ENDIF}

    //PR: 21/10/2011 v6.9
    UserDef5   := CustR.UserDef5;
    UserDef6   := CustR.UserDef6;
    UserDef7   := CustR.UserDef7;
    UserDef8   := CustR.UserDef8;
    UserDef9   := CustR.UserDef9;
    UserDef10  := CustR.UserDef10;

    //PR: 14/10/2013 MRD 2.5.17
    acDeliveryPostCode := CustR.acDeliveryPostCode;
    acSubType    := CustR.acSubType;
    acLongACCode := CustR.acLongACCode;

    //PR: 27/10/2015 v7.014
    Case CustR.acpPDMode of
      pmPPDDisabled :  acPPDMode := 0;
      pmPPDEnabledWithAutoJournalCreditNote : acPPDMode := 1;
      pmPPDEnabledWithAutoCreditNote : acPPDMode := 2;
      pmPPDEnabledWithManualCreditNote : acPPDMode := 3;
    end; //Case

    acCountry := CustR.acCountry;
    acDeliveryCountry := CustR.acDeliveryCountry;

    {$IFDEF COMTK}
    //PR: 22/01/2016 ABSEXCH-17112 v2016 R1
    acDefaultToQR := CustR.acDefaultToQR;
    {$ENDIF}

    {$IFDEF COMTK}
    //AP: 15/11/2017 ABSEXCH-19389 v2018 R1
    acAnonymisationStatus := Ord(CustR.acAnonymisationStatus);
    acAnonymisedDate := CustR.acAnonymisedDate;
    acAnonymisedTime := CustR.acAnonymisedTime;
    {$ENDIF}

  end; {with..}
end; {proc..}


Procedure CustToExCust(Var ExCustRec  :  TBatchCURec);
Begin { CustToExCust }
  CopyExCustToTKCust(Cust, ExCustRec);
End; { CustToExCust }

{* -------------------------------------------------------------------------- *}

{* Ex_GetAccount Function *}
FUNCTION EX_GETACCOUNT(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       ACCTYPE      :  SMALLINT;
                       LOCK         :  WORDBOOL) : SMALLINT;
Var
  ExCustRec  :  ^TBatchCURec;
  KeyS       :  Str255;
  Locked,
  Loop       :  Boolean;
  B_Func     :  Integer;

  function BuildConsumerKey(Idx : Integer) : Str255;
  var
    c : Char;
    s : AnsiString;
  begin
    s := AnsiString(SearchKey);
    Result := s;
    if Length(Result) > 0 then
    begin
      c := Result[1];
      Delete(Result, 1, 1);
      Case Idx of
        CustACCodeK     : Result := FullSubTypeAcCodeKey(c, Result);
        CustLongACCodeK : Result := FullSubTypeLongAcCodeKey(c, Result);
        CustNameK       : Result := FullSubTypeNameKey(c, Result);
        CustAltCodeK    : Result := FullSubTypeAltCodeKey(c, Result);
      end;
    end
    else
      Result := s;
  end;

Begin
  LastErDesc:='';

  Result:=32767;
  Locked:=BOff;
  Loop:=(AccType<>0);
  B_Func:=0;

  If (P<>Nil) and (PSize=Sizeof(TBatchCURec)) then
  Begin
  //PR 16/03/06
  //Fix for problem where key on any index is created using FullCustCode. Commented out lines have
  //been added and should be brought in when we have time to test fully. For the moment only index 9
  //(OurCodeforThem) has been modified as it is causing problems in eBusiness module.
    Case SearchPath of
      0..8, 10, 11 : KeyS :=FullCustCode(StrPas(SearchKey));
{      1 : KeyS := FullCompKey(StrPas(SearchKey));
      2 : KeyS := FullCVATKey(StrPas(SearchKey));
      4 : KeyS := FullCustCode2(StrPas(SearchKey));}
      //PR: 14/11/2013 MRD 1.1.42
      CustACCodeK..CustAltCodeK
                   : KeyS := BuildConsumerKey(SearchPath);
      else
        KeyS := StrPas(SearchKey);
    end;
    ExCustRec:=P;

    KeyS := SetKeyString(SearchMode, CustF, KeyS);
    If TestMode Then
      ShowMessage ('Ex_GetAccount: ' + #10#13 +
                   'P: ' + ExCustRec^.CustCode + #10#13 +
                   'PSize: ' + IntToStr(PSize) + #10#13 +
                   'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                   'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                   'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                   'AccType: ' + IntToStr(AccType) + #10#13 +
                   'Lock: ' + IntToStr(Ord(Lock)));

    Blank(ExCustRec^,Sizeof(ExCustRec^));

    Case SearchMode of

      B_GetGEq,
      B_GetGretr,
      B_GetNext,
      B_GetFirst  :  B_Func:=B_GetNext;

      B_GetLess,
      B_GetLessEq,
      B_GetPrev,
      B_GetLast   :  B_Func:=B_GetPrev;

      B_StepFirst,
      B_StepNext  :  B_Func:=B_StepNext;

      B_StepLast,
      B_StepPrev  :  B_Func:=B_StepPrev;

      else           Loop:=BOff;

    end; {Case..}

    Repeat
      Result:=Find_Rec(SearchMode,F[CustF],CustF,RecPtr[CustF]^,SearchPath,KeyS);

      SearchMode:=B_Func;

    Until (Result<>0) or (Not Loop) or (Cust.CustSupp=TradeCode[(AccType=1)]) or (AccType=0);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,CustF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,CustF,SilentLock,Locked));
    {$ENDIF}

    KeyStrings[CustF] := KeyS;
    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
    Begin
      CustToExCust(ExCustRec^);

      If (Cust.CustSupp<>TradeCode[(AccType=1)]) and (AccType<>0) then
        Result:=4;
    end;

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(3,Result);

end; {Func..}

{* -------------------------------------------------------------------------- *}

{* ========== Convert from Ex.Customer to External Customer Record ========== *}

// CJS: 25/03/2011 ABSEXCH-10687 - Added auditing
Function ExCustToCust(ExCustRec  :  TBatchCURec;
                  Var AddMode    :  SmallInt;
                      iTraderAudit: IBaseAudit = nil)  :  Integer;
Var
  n      :  Byte;
  OCust  :  CustRec;

  FindRec,
  ValidRec,
  ValidHed    : Boolean;

  TStr   :  String[10];
  KeyS        : Str255;

  //19387
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
  lAnonEntityType: TAnonymisationDiaryEntity;
  lRes: Integer;

  //ABSEXCH-20851:Validation check for the Employee associated with the Trader account
  lKeyS: Str255;
  lEmpRes: Integer;

  // SSK 29/06/2018 2018-R1.1 ABSEXCH-20899: new variable added to store AddMode value, as it gets changed afterwards
  lModeType: SmallInt;

Begin
  Result:=0;   ValidRec:=BOff;    ValidHed:=BOn;
  lKeyS := EmptyStr;

  With Cust do
  Begin

    KeyS:=FullCustCode(ExCustRec.CustCode);

    Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);

    FindRec:=StatusOk;

    lModeType := AddMode; // SSK 29/06/2018 2018-R1.1 ABSEXCH-20899: assign AddMode to temporary variable

    {import - assign appro. mode }
    If (AddMode=CheckMode) or (AddMode=ImportMode) then
    begin
      If (FindRec) then
        AddMode:=B_Update
      else
        AddMode:=B_Insert;
    end;

    If (AddMode=B_Insert) then
    Begin
      ResetRec(CustF);
      NLineCount:=1;
      GenSetError(Not FindRec,5,Result,ValidHed);  {* Duplicate Record *}

      //PR: 05/12/2013 ABSEXCH-14797 For consumers, ensure that the Long A/C doesn't exist
      if ValidHed and (ExCustRec.acSubType = 'U') then
      with ExCustRec do
      begin
        KeyS := FullSubTypeLongAcCodeKey(acSubType, acLongACCode);
        Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustLongACCodeK,KeyS);
        GenSetError(Status <> 0,5,Result,ValidHed);
      end;
    end
    else
    Begin
      if FindRec and (iTraderAudit <> nil) then
        iTraderAudit.BeforeData := RecPtr[CustF];
      GenSetError(FindRec,4,Result,ValidHed);  {* Record not found *}
      OCust:=Cust;
    end;


    CustCode:=FullCustCode(ExCustRec.CustCode);
    CustSupp:=ExCustRec.CustSupp;
    Company:=LJVar(ExCustRec.Company,AccNamLen);
    AreaCode:=ExCustRec.AreaCode;
    RepCode:=ExCustRec.RepCode;
    RemitCode:=FullCustCode(ExCustRec.RemitCode);

    {$IFDEF IMPV6}
    //PR: 04/11/2010 VatRegNo wasn't being padded ABSEXCH-2714
    VatRegNo:=FullCVATKey(ExCustRec.VatRegNo);
    {$ELSE}
    VatRegNo:=ExCustRec.VatRegNo;
    {$ENDIF}

    For n:=Low(Addr) to High(Addr) do
      Addr[n]:=ExCustRec.Addr[n];
    DespAddr:=WordBoolToBool(ExCustRec.DespAddr);
    For n:=Low(Addr) to High(Addr) do
      DAddr[n]:=ExCustRec.DAddr[n];
    Contact:=ExCustRec.Contact;
    Phone:=FullCustPhone(ExCustRec.Phone);
    Fax:=ExCustRec.Fax;
    RefNo:=FullRefNo(ExCustRec.RefNo);
    TradTerm:=WordBoolToBool(ExCustRec.TradTerm);
    For n:=1 to 2 do
      STerms[n]:=ExCustRec.STerms[n];
    Currency:=ExCustRec.Currency;
    VATcode:=ExCustRec.VATCode;
    PayTerms:=ExCustRec.PayTerms;
    CreditLimit:=ExCustRec.CreditLimit;
    Discount:=ExCustRec.Discount;
    {CreditStatus:=ExCustRec.CreditStatus;}
    CustCC:=FullCCDepKey(UpperCase(ExCustRec.CustCC));
    CDiscCh:=ExCustRec.CDiscCh;
    CustDep:=FullCCDepKey(UpperCase(ExCustRec.CustDep));
    EECMember:=WordBoolToBool(ExCustRec.EECMember);
    IncStat:=WordBoolToBool(ExCustRec.IncStat);
    DefMLocStk:=Full_MLocKey(ExCustRec.DefMLocStk);
    AccStatus:=ExCustRec.AccStatus;
    PayType:=ExCustRec.PayType;

    //PR: 10/09/2013 ABSEXCH-14598
    {$IFDEF COMTK}
    acBankSortCode := EncryptBankSortCode(ExCustRec.acBankSortCode);
    acBankAccountCode := EncryptBankAccountCode(ExCustRec.acBankAccountCode);
    acMandateID := EncryptBankMandateID(ExCustRec.acMandateID);
    acMandateDate := ExCustRec.acMandateDate;
    {$ELSE}
    acBankSortCode := EncryptBankSortCode(ExCustRec.BankSort);
    //PR: 12/08/2015 ABSEXCH-16757 Changed to use correct function (rather than DecryptBankSortCode)
    acBankAccountCode := EncryptBankAccountCode(ExCustRec.BankAcc);
    {$ENDIF COMTK}
    BankRef:=ExCustRec.BankRef;
    LastUsed:=Today; {v4.31 - ExCustRec.LastUsed;}
    Phone2:=ExCustRec.Phone2;
    UserDef1:=ExCustRec.UserDef1;
    UserDef2:=ExCustRec.UserDef2;
    SOPInvCode:=FullCustCode(ExCustRec.SOPInvCode);
    SOPAutoWOff:=WordBoolToBool(ExCustRec.SOPAutoWOff);
    BOrdVal:=ExCustRec.BOrdVal;

    {* Default Nom Code *}

    DefNomCode:=ExCustRec.DefNomCode;  { Def. Sales GL Code }
    DefCOSNom:=ExCustRec.DefCOSNom;    { Def. COS GL Code }
    DefCtrlNom:=ExCustRec.DefCtrlNom;  { Def. Control GL Code }

    DirDeb:=ExCustRec.DirDeb;
    CCDSDate:=ExCustRec.CCDSDate;
    CCDEDate:=ExCustREc.CCDEDate;
    CCDName:=ExCustRec.CCDName;
    CCDCardNo:=ExCustRec.CCDCardNo;
    CCDSARef:=ExCustRec.CCDSARef;

    {* 17.11.98 - Sett.Disc.Days & % *}
    DefSetDDays:=ExCustRec.DefSetDDays;
    DefSetDisc:=ExCustRec.DefSetDisc;

    If (Not (ExCustRec.DefFormNo In [0..99])) then
      ExCustRec.DefFormNo:=0;
    FDefPageNo:=ExCustRec.DefFormNo;      {* Default Form Set No *}

    {*** Ver 4.31 New Fields ***}
    StatDMode  := ExCustRec.StatDMode;
    EmailAddr  := FullEmailAddr(ExCustRec.EmailAddr);
    EmlSndRdr  := WordBoolToBool(ExCustRec.EmlSndRdr);
    ebusPwrd   := EncodeKey(23130, ExCustRec.ebusPwrd);
    PostCode   := FullPostCode(ExCustRec.Postcode);
    CustCode2  := FullCustCode2(ExCustRec.CustCode2);
    AllowWeb   := ExCustRec.AllowWeb;

    { 03/04/01: Extended for v4.32 }
    If WordBoolToBool(ExCustRec.EmlZipAtc) Then Begin
      { Check for EDZ }
      If WordBoolToBool(ExCustRec.EmlUseEDZ) Then
        { Use EDZ format }
        EmlZipAtc := 2
      Else
        { Use PK-ZIP format }
        EmlZipAtc := 1
    End { If }
    Else
      { No ZIP'ing }
      EmlZipAtc  := 0;

    UserDef3   := ExCustRec.UserDef3;
    UserDef4   := ExCustRec.UserDef4;

    //PR: 21/10/2011 v6.9
     UserDef5 := ExCustRec.UserDef5;
     UserDef6 := ExCustRec.UserDef6;
     UserDef7 := ExCustRec.UserDef7;
     UserDef8 := ExCustRec.UserDef8;
     UserDef9 := ExCustRec.UserDef9;
     UserDef10 := ExCustRec.UserDef10;


    //PR: 14/11/2013 MRD 1.1.42
    acSubType := ExCustRec.acSubType;

    //If sub-type not set then default it to custsupp char.
    if acSubType in [#0, #32] then
      acSubType := CustSupp;

    //Don't allow long code to be populated for customers/suppliers
    if acSubType <> 'U' then
      ExCustRec.acLongACCode := '';

    acLongACCode := FullLongAcCodeKey(ExCustRec.acLongACCode);

    TimeChange:=TimeNowStr;

    SSDDelTerms:= ExCustRec.SSDDelTerms;  { has validation }
    CVATIncFlg := ExCustRec.CVATIncFlg;   { has validation }
    SSDModeTr  := ExCustRec.SSDModeTr;
    LastOpo    := ExCustRec.LastOpo;
    InvDMode   := ExCustRec.InvDMode;
    EmlSndHTML := WordBoolToBool(ExCustRec.EmlSndHTML);
  { WebLiveCat := ExCustRec.WebLiveCat; ... Read Only }
  { Needs to be updatable - but only Exchequer should use ! }
    WebPrevCat := ExCustRec.WebPrevCat;

    If (ExcustRec.SOPConsHo In [0..1]) then
      SOPConsHO  := ExCustRec.SOPConsHO  { 27.09.2000 - Consolidate Committed Balance }
    else
      SOPConsHO  := 0;

    DefTagNo := ExCustRec.DefTagNo;

    //PR: 14/10/2013 MRD 2.5.17
    acDeliveryPostCode := ExCustRec.acDeliveryPostCode;

    acCountry := ExCustRec.acCountry;
    acDeliveryCountry := ExCustRec.acDeliveryCountry;


    {$IFDEF COMTK}
    OrdConsMode := ExCustRec.OrderConsMode;
    VatRetRegC := ExCustRec.VatCountryCode;
    acAllowOrderPayments := ExCustRec.acAllowOrderPayments;
    acOrderPaymentsGLCode := ExCustRec.acOrderPaymentsGLCode;
    //PR: 22/01/2016 ABSEXCH-17112 v2016 R1
    acDefaultToQR := ExCustRec.acDefaultToQR;
    {$IFNDEF IMPV6}  // SSK 03/07/2018 2018-R1.1 ABSEXCH-20899: need to bypass for Importer to avoid incorrect anonymisation status assignment
      //AP: 15/11/2017 ABSEXCH-19389 v2018 R1
      acAnonymisationStatus := TEntityAnonymisationStatus(ExCustRec.acAnonymisationStatus);
      acAnonymisedDate := ExCustRec.acAnonymisedDate;
      acAnonymisedTime := ExCustRec.acAnonymisedTime;
    {$ENDIF}
    {$ENDIF}

    {*** End for V4.31 ***}

    {* Begin Validation *}

    If (Result=0) then
    Begin

      //PR: 27/10/2015 v7.014 Set and validate PPD Mode
      ValidRec := True;
      case ExCustRec.acPPDMode of
        0   :  Begin
                 acPPDMode := pmPPDDisabled;

                 // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Trader PPD Fields validation mods
                 // Zero down PPD Percentage and Days if PPD Disabled for the account
                 DefSetDisc := 0.0;
                 DefSetDDays := 0;
               End;
        1   :  acPPDMode := pmPPDEnabledWithAutoJournalCreditNote;
        2   :  if CustSupp = TradeCode[True] then
                 acPPDMode := pmPPDEnabledWithAutoCreditNote
               else
                 ValidRec := False;
        3   :  if CustSupp = TradeCode[False] then
                 acPPDMode := pmPPDEnabledWithManualCreditNote
               else
                 ValidRec := False;
        else
          ValidRec := False;
      end; //case

      GenSetError(ValidRec,30026,Result,ValidHed);

      //PR: 24/07/2015 Validate country codes

      ValidRec := ValidCountryCode (ifCountry2, acCountry);
      GenSetError(ValidRec,30024,Result,ValidHed);

      If (Trim(DAddr[1]) <> '') Or (Trim(DAddr[2]) <> '') Or (Trim(DAddr[3]) <> '') Or
         (Trim(DAddr[4]) <> '') Or (Trim(DAddr[5]) <> '') Or (Trim(acDeliveryPostCode) <> '') Then
        ValidRec := (Trim(acDeliveryCountry) <> '') And ValidCountryCode (ifCountry2, acDeliveryCountry)
      Else
        ValidRec := True;

      //PR: 03/02/2016 v2016 R1 ABSEXCH-17045 Changed from 300025 to 30025 to prevent overflow.  
      GenSetError(ValidRec,30025,Result,ValidHed);



      {* Validate CustSupp *}

      ValidRec:=((CustSupp=TradeCode[BOff]) or (CustSupp=TradeCode[BOn]));

      GenSetError(ValidRec,30001,Result,ValidHed);

      If (AddMode=B_Update) then
      Begin
        {* Check Exisiting Cust Supp is same as old cust Supp *}
        ValidRec:=(CustSupp=OCust.CustSupp);
        GenSetError(ValidRec,30002,Result,ValidHed);
      end;

      {* Check for Blank Account Rec *}

      //PR: 29/11/2013 ABSEXCH-14797 Allow blank CustCode when adding consumers - it will be
      //                             set automatically before insertion
      ValidRec:=(Not EmptyKey(CustCode,AccLen)) or ((acSubType = 'U') and (AddMode = B_Insert));
      GenSetError(ValidRec,30003,Result,ValidHed);

      {* Check for Invalid payment type *}

      ValidRec:=(PayType In ['B','C', '2', '3']);
      GenSetError(ValidRec,30004,Result,ValidHed);

      {* Check for Invalid default VATCode *}

      ValidRec:=(VATCode<>VATMCode) and (VATCode In VATSet);

      //PR: 17/02/2016 ABSEXCH-17292 v2016 R1 Don't allow 'D' for Suppliers or 'A' for Customers
      if VATCode in ['A', 'D'] then
        ValidRec := Syss.Intrastat and EECMember and ((CustSupp = TradeCode[False]) xor (VATCode = 'D'));

      GenSetError(ValidRec,30005,Result,ValidHed);

      {* Check for Invalid default Nominal Code*}

      ValidRec:=(CheckRecExsists(Strip('R',[#0],FullNomKey(DefNomCode)),NomF,NomCodeK) or (DefNomCode=0));
      GenSetError(ValidRec,30006,Result,ValidHed);

      {* Check for Invalid Currency *}

      If (ExSyss.MCMode) then        //PR 01/03/06 - was allowing currency of 90
        ValidRec:=((Currency>=1) and (Currency<=Pred(CurrencyType)))
      else
      Begin
        ValidRec:=BOn;
        Currency:=0;
      end;
      GenSetError(ValidRec,30007,Result,ValidHed);

      {* Check for Invalid default COS Nominal Code - 23/07/97 *}

      ValidRec:=(CheckRecExsists(Strip('R',[#0],FullNomKey(DefCOSNom)),NomF,NomCodeK) or (DefCOSNom=0));
      GenSetError(ValidRec,30008,Result,ValidHed);

      {* Check for Invalid default Nominal Code - 23/07/97 *}

      ValidRec:=(CheckRecExsists(Strip('R',[#0],FullNomKey(DefCtrlNom)),NomF,NomCodeK) or (DefCtrlNom=0));
      GenSetError(ValidRec,30009,Result,ValidHed);

      {* Location Code Check - 23/07/97 *}

      ValidRec:=(EmptyKey(DefMLocStk,LocKeyLen)) or (Not Syss.UseMLoc);

      If (Not ValidRec) then
        ValidRec:=(CheckRecExsists(MLocFixCode[True]+LJVar(DefMLocStk,LocKeyLen),MLocF,MLK));

      GenSetError(ValidRec,30010,Result,ValidHed);


      {* Check Remit code, Invoice To  <> Account Code *}
      ValidRec:=(EmptyKey(SOPInvCode,AccLen));
      If (Not ValidRec) then
      begin
        OCust:=Cust;
        ValidRec:=(SOPInvCode<>CustCode) and (CheckRecExsists(SOPInvCode,CustF,CustCodeK));
        VAlidRec:=(ValidRec) and (Cust.CustSupp=OCust.CustSupp);
        GenSetError(ValidRec,30011,Result,ValidHed);
        Cust:=OCust;
      end; {if..}

      {* Check Statement To <> Account Code *}
      ValidRec:=(EmptyKey(RemitCode,AccLen));
      If (Not ValidRec) then
      begin
        OCust:=Cust;
        ValidRec:=(RemitCode<>CustCode) and (CheckRecExsists(RemitCode,CustF,CustCodeK));
        VAlidRec:=(ValidRec) and (Cust.CustSupp=OCust.CustSupp);
        GenSetError(ValidRec,30012,Result,ValidHed);
        Cust:=OCust;
      end; {if..}

     {* v4.31 Check SSD Delivery Terms *}
      //PR: 09/02/2016 v2016 R1 ABSEXCH-17264 Standardise Intrastat validation with Exchequer
      //PR: 17/02/2016 Change to ensure fields can only be set if Intrastat is on
      //PR: 26/02/2016 v2016 R1 ABSEXCH-17335 Reverse previous change so we only validate if
      //                                      intrastat turned on and account is EC Member.
      if IntrastatEnabled and Cust.EECMember then
      begin
        //Check Valid Del terms
        if SystemSetup.Intrastat.isShowDeliveryTerms then
        begin
          ValidRec:=(SSDDelTerms='') Or ValidDelTerms(SSDDelTerms);
          GenSetError(ValidRec,30013,Result,ValidHed);
        end;

        //Check Valid mode of transport
        if SystemSetup.Intrastat.isShowModeOfTransport then
        begin
          ValidRec:=(SSDModeTr = 0) Or ValidModeTran(SSDModeTr);
          GenSetError(ValidRec,30030,Result,ValidHed);
        end;
      end;

     {* v4.31 Check CVat Inc. Flag *}
      If (VATCode=VATICode) then
      begin
        ValidRec:=(CVATIncFlg In VATSet-VATEqStd);
        GenSetError(ValidRec,30014,Result,ValidHed);
      end; {if..}

      ValidRec:=(InvDMode In [0..8]);
      GenSetError(ValidRec,30015,Result,ValidHed);

      { 25/03/02: Extended for v5.00 }
      ValidRec := (DefTagNo <= 99);
      GenSetError(ValidRec,30016,Result,ValidHed);

      ValidRec := (DefSetDDays >=0) and (DefSetDDays <= 999);
      GenSetError(ValidRec,30017,Result,ValidHed);

      // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Trader PPD Fields validation mods
      ValidRec := (DefSetDisc >= 0.0) and (DefSetDisc <= 99.99);
      GenSetError(ValidRec,30027,Result,ValidHed);

      //PR 17/07/2007 Added CC/Dept checks
      //Check whether we need to check the CC/Dept at all
      If Syss.UseCCDep Then
      Begin
      // Validate CC/Dept Codes fully
        ValidRec := EmptyKey(CustCC, CCKeyLen);
        if not ValidRec then
          ValidRec:=CheckRecExsists(CostCCode+CSubCode[Bon]+CustCC,PWrdF,PWK);

        {SS 15/06/2016 2016-R3
         ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.
        - Added validation to check Cost Centre/Department is active or not.}
        if ValidRec and (not EmptyKey(CustCC, CCKeyLen)) then
        begin
          ValidRec := (PassWord.CostCtrRec.HideAC = 0);
          GenSetError(ValidRec,30031,Result,ValidHed);
        end;
        

        if ValidRec then
        begin
          ValidRec := EmptyKey(CustDep, CCKeyLen);
          if not ValidRec then
            ValidRec:=CheckRecExsists(CostCCode+CSubCode[Boff]+CustDep,PWrdF,PWK);
        end;


        GenSetError(ValidRec,30018,Result,ValidHed);

        {SS 15/06/2016 2016-R3 
         ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.
        - Added validation to check Cost Centre/Department is active or not.}
        if ValidRec and (not EmptyKey(CustDep, CCKeyLen)) then
        begin
          ValidRec := (PassWord.CostCtrRec.HideAC = 0);
          GenSetError(ValidRec,30031,Result,ValidHed);
        end;                                           

      End { If Syss.UseCCDep }
      Else Begin
        // CC/Depts turned off - blank out CC/Dept
        CustCC := '';
        CustDep := '';
      End; { Else }

      {$IFDEF COMTK}
      if (CustSupp = 'C') and (Trim(acMandateDate) <> '') then
      begin
        ValidRec := ValidDate(acMandateDate);

        GenSetError(ValidRec,30019,Result,ValidHed);
      end;

      // CJS 2014-08-06 - v7.x Order Payments - T097 - new fields
      // Validate Order Payments G/L Code
      if acOrderPaymentsGLCode <> 0 then
      begin
        //PR: 11/02/2015 ABSEXCH-16148 If a/c doesn't allow OrderPaymentsGL then set OrderPaymentsGL to 0
        if not acAllowOrderPayments then
          acOrderPaymentsGLCode := 0
        else
        begin
          { Make sure the G/L Code exists }
          ValidRec := CheckRecExsists(Strip('R',[#0], FullNomKey(acOrderPaymentsGLCode)), NomF, NomCodeK);
          GenSetError(ValidRec,30023,Result,ValidHed);

          { The Order Payments Nominal Code must be a Balance Sheet G/L }
          ValidRec := Nom.NomType = BankNHCode;
          GenSetError(ValidRec,30023,Result,ValidHed);

          { If G/L Classes are in use, the Order Payments G/L must be a Bank class }
          ValidRec := (Nom.NomClass = ncBankAc) or (not Syss.UseGLClass);
          GenSetError(ValidRec,30023,Result,ValidHed);

          //PR: 11/02/2015 ABSEXCH-16149 Validate currency - must be same as a/c or else consolidated
          ValidRec := ((Nom.DefCurr = Currency) or (Nom.DefCurr = 0));
          GenSetError(ValidRec,30023,Result,ValidHed);
        end;
      end;
      

      {$ENDIF}
      //PR: 14/11/2013 MRD 1.1.42 Validate consumer fields.
      if AddMode = B_Insert then
      begin
        //Must be valid SubType
        if CustSupp = 'C' then
          ValidRec := (acSubType = 'C') or ((acSubType = 'U') and Syss.ssConsumersEnabled)
        else
          ValidRec := acSubType = 'S';

        GenSetError(ValidRec,30020,Result,ValidHed);
      end
      else
      begin
        //Update - can't change SubType
        ValidRec := acSubType = OCust.acSubType;

        GenSetError(ValidRec,30021,Result,ValidHed);
      end;

      //For consumers, Long code musn't be blank
      ValidRec := (Trim(acLongACCode) <> '') or (acSubType <> 'U');
      GenSetError(ValidRec, 30022, Result, ValidHed);

      //PR: 27/11/2014 Order Payments
      ValidRec := (Trim(acCountry) <> '') And ValidCountryCode (ifCountry2, acCountry);
      GenSetError(ValidRec, 30024, Result, ValidHed);

      // Validate Delivery Postcode if any part of the delivery address is set
      If (Trim(DAddr[1]) <> '') Or (Trim(DAddr[2]) <> '') Or (Trim(DAddr[3]) <> '') Or
         (Trim(DAddr[4]) <> '') Or (Trim(DAddr[5]) <> '') Or (Trim(acDeliveryPostCode) <> '') Then
        ValidRec := (Trim(acDeliveryCountry) <> '') And ValidCountryCode (ifCountry2, acDeliveryCountry)
      Else
        ValidRec := True;
      GenSetError(ValidRec, 30025, Result, ValidHed);

      {$IFDEF COMTK}
      //PR: 26/01/2016 ABSEXCH-17112 v2016 R1
      if (CurrentCountry <> UKCCode) or (not Syss.Intrastat) or (Cust.CustSupp <> TradeCode[True]) or
         (not Cust.EECMember) then //Don't allow Default to QR to be set
           ValidRec := not acDefaultToQR;

      GenSetError(ValidRec, 30028, Result, ValidHed);

      //AP:22/12/2017 2018 R1 : ABSEXCH-19387:Added to restrict Anonymised Account from edit
      if GDPROn and (lModeType <> CheckMode) then       // SSK 29/06/2018 2018-R1.1 ABSEXCH-20899: '(lModeType <> CheckMode)' condition added, so that anonymization stuff should not kick in checkmode
      begin
        if (acAnonymisationStatus = asAnonymised) then
        begin
          ValidRec := False;
          GenSetError(ValidRec, 30032, Result, ValidHed);
        end
        else
        begin
          case CustSupp of
            CONSUMER_CHAR : lAnonEntityType := adeCustomer;
            CUSTOMER_CHAR : lAnonEntityType := adeCustomer;
            SUPPLIER_CHAR : lAnonEntityType := adeSupplier;
          end;
          lAnonDiaryDetail := CreateSingleAnonObj;
          if Assigned(lAnonDiaryDetail) then
          begin
            case AccStatus of
              0,1,2:
              begin
                acAnonymisationStatus := asNotRequested;
                acAnonymisedDate := '';
                acAnonymisedTime := '';
                //Remove Entry from AnonymisationDiary Table
                lRes := lAnonDiaryDetail.RemoveEntity(lAnonEntityType, CustCode);
              end; 
              3:
              begin
                //Add Entry into AnonymisationDiary Table
                lAnonDiaryDetail.adEntityType := lAnonEntityType;
                lAnonDiaryDetail.adEntityCode := CustCode;
                lRes := lAnonDiaryDetail.AddEntity;
                if lRes = 0 then
                begin
                  acAnonymisationStatus := asPending;
                  acAnonymisedDate := lAnonDiaryDetail.adAnonymisationDate;
                  acAnonymisedTime := TimeNowStr;
                end;
              end;
            end;
          end;  
        end;

        //AP 22/06/2018 ABSEXCH-20851:Validation check for the Employee associated with the Trader account
        if (AccStatus = 3) and (CustSupp = SUPPLIER_CHAR) then
        begin
          //Search sub contractor and closed them as well
          lKeyS := PartCCKey(JARCode, JASubAry[3]);
          lEmpRes := Find_Rec(B_GetFirst, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
          with JobMisc.EmplRec do
          begin
            while (lEmpRes = 0) do
            begin
              if (EType = 2) and (emStatus <> emsClosed) and
                 (emAnonymisationStatus <> asAnonymised) and
                 (Trim(Supplier) = Trim(CustCode)) then
              begin
                emStatus := emsClosed;    {1: close the sub-contractor}
                emAnonymisationStatus := asPending;
                emAnonymisedDate := acAnonymisedDate;
                emAnonymisedTime := TimeNowStr;
                lEmpRes := Put_Rec(F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK);
              end;
              lEmpRes := Find_Rec(B_GetNext, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
            end;
          end;
        end;
      end;
      {$ENDIF}
    end;
  end;
end;

{* -------------------------------------------------------------------------- *}

{* ========= Ex_StoreAccount Function ========== *}

// CJS: 25/03/2011 ABSEXCH-10687 - Added auditing
FUNCTION EX_STOREACCOUNT(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT) : SMALLINT;

{* For CheckBatch - if SearchMode = CheckMode then record will not be updated *}

Var
  ExCustRec  :  ^TBatchCURec;
  KeyS       :  Str255;
  TmpMode    :  SmallInt; {* To assign original SearchMode *}
  // CJS: 25/03/2011 ABSEXCH-10687
  iTraderAudit: IBaseAudit;
Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExCustRec:=P;
    ShowMessage('Ex_StoreAccount:' + #10#13 +
                'P^.CustCode: ' + ExCustRec^.CustCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchCURec)) then
  Begin

    ExCustRec:=P;

    {* SearchMode will be changed as B_Insert or B_Update
       if it is CheckMode or ImportMode *}

    TmpMode:=SearchMode;

    // CJS: 25/03/2011 ABSEXCH-10687
    iTraderAudit := NewAuditInterface (atTrader);
    try
      Result:=ExCustToCust(ExCustRec^,SearchMode,iTraderAudit);

      {* If not CheckMode, Update accordingly *}
      If ((TmpMode<>CheckMode) and (Result=0)) then
      Case SearchMode of
        B_Insert  :  begin
                       //PR: 29/11/2013 ABSEXCH-14797 Set short account code
                       if Cust.acSubType = 'U' then
                         Cust.CustCode := NextConsumerCode;
                       Result:=Add_Rec(F[CustF],CustF,RecPtr[CustF]^,SearchPath);
                        //PR: 28/10/2011 v6.9
                        if Result = 0 then
                          AuditNote.AddNote(anAccount, Cust.CustCode, anCreate);
                     end;

        B_Update  :
          begin            
            Result:=Put_Rec(F[CustF],CustF,RecPtr[CustF]^,SearchPath);
            // CJS: 25/03/2011 ABSEXCH-10687
            if (Result = 0) then
            begin
              iTraderAudit.AfterData := RecPtr[CustF];
              iTraderAudit.WriteAuditEntry;
            end;
            //PR: 28/10/2011 v6.9
            if Result = 0 then
              AuditNote.AddNote(anAccount, Cust.CustCode, anEdit);
          end;
      else
        Result:=30000;
      end;
    finally
      iTraderAudit := nil;
    end;
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(4,Result);

end; {Func..}


{* -------------------------------------------------------------------------- *}

{* ======== Function to Unlock a customer record ============ *}

FUNCTION EX_UNLOCKACCOUNT : SMALLINT;

Var
  KeyS  :  Str255;

Begin
  LastErDesc:='';
  If TestMode Then ShowMessage('Ex_UnLockAccount');

  Blank(KeyS,Sizeof(KeyS));

  Result:=Find_Rec(B_Unlock,F[CustF],CustF,RecPtr[CustF]^,0,KeyS);

  If (Result<>0) then
    LastErDesc:='Unable to Unlock the Account Record';

end;


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

{* -------------------------------------------------------------------------- *}

Function GetCustStats(CCode :  Str10;
                      Mode  :  Byte;
                      ChkCr :  Boolean;
                      DLink :  DictLinkType;
                  Var TCommitVal  :  Double)  :  Double;
Type
  DrCrType2  =  Array[BOff..BOn] of Double;
  {DrCrType2  =  Array[BOff..BOn] of Real;}

Var

  TComVal,
  Balance,
  LastYTD,
  ThisPr,
  ThisYTD,
  Cleared     :  Double; {Real;} {Double;}

  CrDr        :  DrCrType2;
  AcPr,AcYr   :  Byte;

  Range       :  Boolean;
  HistCode    :  Char;

  { 26.03.2001 - Added for Budget }
  PBudget,
  PBudget2  :  Double;
  BV1,
  BV2       :  Double;

Begin
  Balance:=0;  LastYTD:=0;  ThisPr:=0;
  ThisYTD:=0;  Cleared:=0;
  TCommitVal:=0;

  If (Mode In [1..3]) then
    HistCode:=CustHistGPCde
  else
    HistCode:=CustHistCde;

  With DLink do
  Begin
    Range:=(DPr=YTD);
    AcYr:=DYr;

    {$IFDEF COMTK}
    // HM 12/01/01: Added to support OLE style 100 periods
    If (Dpr In [101..199]) Then Begin
      AcPr := DPr - 100;
      Range := True;
    End { If }
    Else
    {$ENDIF}
      If (Range) then
        AcPr:=Pred(YTDNCF)
      else
        AcPr:=DPr;
  end;

  If (Mode In [0..6]) then
    Balance:=Profit_to_Date(HistCode,CCode,Dlink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,Range);

  { 12.09.00 - Committed value }
  {TComVal:=Profit_To_Date(CustHistCde,CCode,0,AcYr,AcPr,CrDr[BOff],CrDr[BOn],TCommitVal,BOn);}

  Case Mode of
    0  :  GetCustStats:=Balance;
    1  :  GetCustStats:=CrDr[BOff];
    2  :  GetCustStats:=CrDr[BOn];
    3  :  GetCustStats:=CrDr[BOff]-CrDr[BOn];
    4  :  GetCustStats:=CrDr[Not ChkCr];
    5  :  GetCustStats:=CrDr[ChkCr];
    6  :  GetCustStats:=Cleared;
    7,    //PR: 01/08/2011 Added revised budget (Mode = 9) ABSEXCH-11018
    9  :  begin         { 26.03.2001 - added 7 for Budget OLE }
            PBudget:=0;   PBudget2:=0;
            BV1:=0;       BV2:=0;

            Balance:=Total_Profit_to_Date(HistCode,CCode,DLink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,PBudget,PBudget2,BV1,BV2,Range);
            if Mode = 7 then
              GetcustStats:=PBudget
            else
              GetcustStats := PBudget2;  //revised budget
          end;
    else  GetCustStats:=0;
  end; {Case..}

  { HM 03/01/00: Moved down here as Committed call was changing some of the figures }
  { 12.09.00 - Committed value }
  TComVal:=Profit_To_Date(CustHistCde,CCode,0,AcYr,AcPr,CrDr[BOff],CrDr[BOn],TCommitVal,BOn);
end; {Func..}

{* -------------------------------------------------------------------------- *}

{* Check for valid value of Period and Year on 11.07.97 *}
FUNCTION CHECKPRYR(PERIOD, YEAR  : STR10)  :  SMALLINT;
Const
  CheckStr = 'YTD';
  CurrChk  = -1;
  Last3Chk = -3;
var
  TVal     :  Integer;
  TCheck   :  SmallInt;
  TChk     :  Boolean;
begin
  TCheck:=0;

  TChk:=((EmptyKey(Period,SizeOf(Period))) or (Period=CheckStr));
  If (Not TChk) then
  begin
    StrInt(Period,TChk,TVal);
    If (TChk) then
      TChk:=(TVal=CurrChk) or (TVal=Last3Chk) or (TVal In [0..250]);
  end;

  If (Not TChk) then
    TCheck:=30001    {* Period Error *}
  else
  begin

    TChk:=(EmptyKey(Year,SizeOf(Year)));
    If (Not TChk) then
    begin
      StrInt(Year,TChk,TVal);
      If (TChk) then
        TChk:=(TVal=CurrChk) or (TVal=Last3Chk) or (TVal In [0..250]);
    end;
    If (Not TChk) then
      TCheck:=30002;  {* Year Error *}
  end;
  CHECKPRYR:=Tcheck;
end;

{* -------------------------------------------------------------------------- *}

{ =========== Function to Return Account History =========== }

FUNCTION EX_GETACCOUNTBALANCE(P          :  POINTER;
                              PSIZE      :  LONGINT;
                              ACCODE     :  PCHAR;
                              SEARCHMODE :  SMALLINT) : SMALLINT;


Var
  HistBalRec  :  ^THistoryBalRec;
  KeyS        :  Str255;
  DLink       :  DictLinkType;
  TCommitVal  :  Double;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    HistBalRec:=P;
    ShowMessage ('Ex_GetAccountBalance:' + #10#13 +
                 '  HistBalRec.Period: ' + HistBalRec^.Period + #10#13 +
                 '  HistBalRec.Year: ' + HistBalRec^.Year + #10#13 +
                 '  HistBalRec.Currency: ' + IntToStr(HistBalRec^.Currency) + #10#13 +
                 '  PSize: ' + IntToStr(PSize) + #10#13 +
                 '  AcCode: ' + StrPas(AcCode) + #10#13 +
                 '  SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  KeyS:=FullCustCode(StrPas(AcCode));

  If (P<>Nil) and (PSize=Sizeof(THistoryBalRec)) then
  Begin
    HistBalRec:=P;
    HistBalRec^.Value:=0;
    HistBalRec^.CommitVal:=0;

    Result:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);

    If (Result=0) then
    With HistBalRec^ do
    With DLink do
    Begin
      If (SearchMode In [0..7, 9]) then { 26.03.2001 - added 7 for Budget OLE }
      Begin
        {* Check valid Period & Year 11/07/97 *}
        Result:=CheckPrYr(Period,Year);

        If (Result=0) then
        begin
          Calc_PrYr(Period,Year,DPr,DYr);
          DCr:=Currency;
          Value:=GetCustStats(KeyS,SearchMode,
                             (Cust.CustSupp=TradeCode[BOn]),
                             DLink, CommitVal);
          { CommitVal is returned in the GetCustStats function }
        end;

      end
      else
        Result:=30008;

    end; {With..}
  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(6,Result);

end; {Func..}

{* -------------------------------------------------------------------------- *}

{* ============= External Nominal To Ex.Nominal =================== *}

Procedure CopyExNomToTKNom(Const NomR : NominalRec; Var ExNomRec  :  TBatchNomRec);

Begin
  With ExNomRec do
  Begin
    NomCode:=NomR.NomCode;
    Desc:=NomR.Desc;
    {$IFNDEF COMTK}
    LongDesc := NomR.Desc;
    {$ENDIF}
    Cat:=NomR.Cat;
    NomType:=NomR.NomType;
    CarryF:=NomR.CarryF;
    SubType:=BoolToWordBool(NomR.SubType);
    NomPage:=BoolToWordBool(NomR.NomPage);
    Total:=BoolToWordBool(NomR.Total);
    ReValue:=BoolToWordBool(NomR.ReValue);
    {***  v4.31 ***}
    AltCode:=NomR.AltCode;
    DefCurr:=NomR.DefCurr;
    {$IFDEF COMTK}
    NomClass := NomR.NomClass;
    ForceJC := BoolToWordBool(NomR.ForceJC);
    {$ENDIF}
    Inactive := BoolToWordBool(NomR.HideAC = 1);
    {*** ---------------- ***}
  end;
end; {Proc.. NomToExNom}

Procedure NomToExNom(Var ExNomRec  :  TBatchNomRec);
begin
  CopyExNomToTKNom(Nom, ExNomRec);
end;

{* -------------------------------------------------------------------------- *}

{ ============= Ex_GetGLAccount ============== }

FUNCTION EX_GETGLACCOUNT(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHKEY    :  PCHAR;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT;
                         LOCK         :  WORDBOOL) : SMALLINT;
Var
  ExNomRec   :  ^TBatchNomRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  B_Func     :  Integer;

Begin
  LastErDesc:='';

  Result:=0;
  Locked:=BOff;
  B_Func:=0;

  If not Assigned(P) then
    Result := 32767;

  If (PSize<>Sizeof(TBatchNomRec)) then
    Result:=32766;

  If (Result=0) then
  Begin
    { HM 7/12/98: Modified to support index 1 }
    If (SearchPath = 0) and (SearchMode in [B_GetEq, B_GetGEq, B_GetGretr, B_GetLessEq, B_GetLess] )Then
      { By GL Code }
      try
        KeyS:=FullNomKey(StrToInt(StrPas(SearchKey)))
      except
        on EConvertError do
        begin
          {// GL codes all numeric - so return error 4 if not numeric at all}
          Result := 4;
          {exit;}
        end;
      end
    Else
      { By Description }
      KeyS:= SetKeyString(SearchMode, NomF, StrPas(SearchKey));

    {StrPCopy(PC,FullNomKey(StrToInt(GL_Code.Text)));}

    If (Result=0) then
    begin

      ExNomRec:=P;

      If TestMode Then
              ShowMessage ('Ex_GetGLAccount: ' + #10#13 +
              'P: ' + ExNomRec^.Desc + #10#13 +
              'PSize: ' + IntToStr(PSize) + #10#13 +
              'SearchKey: ' + StrPas(SearchKey) + #10#13 +
              'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
              'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
              'Lock: ' + IntToStr(Ord(Lock)));


      Blank(ExNomRec^,Sizeof(ExNomRec^));

      Result:=Find_Rec(SearchMode,F[NomF],NomF,RecPtr[NomF]^,SearchPath,KeyS);

      If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
      {$IFDEF WIN32}
      begin
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,NomF,SilentLock,Locked)) then
          Result:=0;
        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,NomF,SilentLock,Locked));
      {$ENDIF}

      KeyStrings[NomF] := KeyS;
      StrPCopy(SearchKey,KeyS);

      If (Result=0) then
        NomToExNom(ExNomRec^);

    end; {If Result=0..}

  end; {If Result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(44,Result);

end; {Ex_GetGLAccount}

{* -------------------------------------------------------------------------- *}
//PR 01/03/06
//These 2 functions copied from NomRecU, to check that the nom type is allowed in this section of the GL
  Function In_PandL(GLCat  :  LongInt)  :  Boolean;

  Const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;

  Var
    KeyS,
    KeyChk   :  Str255;


    FoundOk  :  Boolean;

    TmpKPath,
    TmpStat
             : Integer;

    TmpRecAddr,
    PALStart
             :  LongInt;

    TmpNom   :  NominalRec;

  Begin
    FoundOk:=BOff;

    TmpNom:=Nom;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOff,BOff);

    PALStart:=Syss.NomCtrlCodes[PLStart];

    FoundOK:=(GLCat=PALStart);

    If (Not FoundOk) then
    Begin
      KeyChk:=FullNomKey(GLCat);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (Not FoundOk) do
      With Nom do
      Begin
        FoundOk:=(Cat=PALStart);


        If (Not FoundOk) then
        Begin

          KeyChk:=FullNomKey(Cat);

          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end;
      end; {While..}

    end;


    TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOn,BOff);

    Nom:=TmpNom;


    In_PandL:=FoundOk;

  end;

Function NomGood_Type2(OTyp  :  Char;
                               GLCat :  LongInt)  :  Boolean;


Begin

  {$B-}

  Result:=((OTyp In [NomHedCode,CarryFlg]))
                 or ((OTyp<>PLNHCode) and (Not In_PandL(GLCat)))
                 or ((OTyp=PLNHCode) and (In_PandL(GLCat)));

  {$IFDEF LTE}
    If (Result) and (OTyp In [NomHedCode]) then
      Result:=CheckParentRV(GLCat,1);

  {$ENDIF}

  {$B+}

end;


{ ============= End of ExGetGLAccount =========== }

Function ExNomToNom(ExNomRec  :  TBatchNomRec;
                VAR AddMode   :  SmallInt)  :  Integer;
Const
  Fnum    = NomF;
  KeyPath = NomCodeK;

Var
  n         : Byte;
  ONom      : NominalRec;

  FindRec,
  ValidRec,
  ValidHed  : Boolean;

  KeyS      : Str255;





Begin
  Result:=0;
  ValidRec:=BOff;
  ValidHed:=BOn;

  With Nom do
  Begin

    KeyS:=FullNomKey(ExNomRec.NomCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    FindRec:=StatusOk;

    If (AddMode=CheckMode) or (AddMode=ImportMode) then
    begin
      If (FindRec) then
        AddMode:=B_Update
      else
        AddMode:=B_Insert;
    end;


    If (AddMode=B_Insert) then
    Begin
      ResetRec(Fnum);
      GenSetError(Not FindRec,5,Result,ValidHed);
    end
    else
    Begin
      ONom:=Nom; //Store old record here
      GenSetError(FindRec,4,Result,ValidHed);
    end;



    NomCode:=ExNomRec.NomCode;
    {$IFDEF EX600}
      // PR 03/09/07: Set new UNIQUE index
      NomCodeStr := LJVar(IntToStr(NomCode), SizeOf(NomCodeStr) - 1);
    {$ENDIF}

    {$IFNDEF COMTK}
    if Trim(ExNomRec.LongDesc) <> '' then
      Desc:=ExNomRec.LongDesc
    else
    {$ENDIF}
      Desc := ExNomRec.Desc;

    Cat:=ExNomRec.Cat;
    NomType:=ExNomRec.NomType;
{    NomPage:=BOff;
    SubType:=BOff;
    Total:=BOff;}
    CarryF:=ExNomRec.CarryF;
//    ReValue:=BOff;
    ReValue:= WordBoolToBool(ExNomRec.ReValue) and (ExNomRec.NomType in ['B','C']);
    NomPage:= WordBoolToBool(ExNomRec.NomPage);
    SubType:=WordBoolToBool(ExNomRec.SubType);
    Total:=WordBoolToBool(ExNomRec.Total);

    {***  v4.31 ***}
    {$IFDEF IMPV6}
    //PR: 12/11/2010 Changed to pad AltCode
    AltCode:=LJVar(UpperCase(ExNomRec.AltCode), NomAltCLen);
    {$ELSE}
    AltCode:=LJVar(UpperCase(ExNomRec.AltCode), NomAltCLen);
    {$ENDIF}

    {$IFDEF COMTK}
    NomClass := ExNomRec.NomClass;
    ForceJC  := WordBoolToBool(ExNomRec.ForceJC);
    {$ENDIF}

    DefCurr:=ExNomRec.DefCurr;
    if WordBoolToBool(ExNomRec.Inactive) then
      HideAC := 1
    else
      HideAC := 0;
    {*** ---------------- ***}



    {* Begin Validation *}

    If (Result=0) then
    Begin

//---------------------------------------------------------------------------------
      {* Category/Parent Code  Check *} //At BH's request moved to be first test in series

(*      ValidRec:=(Cat=0);  {* Blank Cat = Level 0 *}

      //save record before doing checkrecexists
      ONom := Nom;

      If (Not ValidRec) then
      Begin
        ValidRec:=(CheckRecExsists(Strip('R',[#0],FullNomKey(Cat)),Fnum,KeyPath));

        ValidRec:=((ValidRec) and (NomType=Htyp));
      end;
      GenSetError(ValidRec,30005,Result,ValidHed);

      //Restore record
      Nom:=ONom; *)

//---------------------------------------------------------------------------------
      If (AddMode=B_Update) then
      Begin
        {* Check Exisiting Cat & Type is same as old Data *}

        ValidRec:=(Cat=ONom.Cat);
        GenSetError(ValidRec,30001,Result,ValidHed);

        ValidRec:=(NomType=ONom.NomType);
        GenSetError(ValidRec,30002,Result,ValidHed);
      end
      else
      begin
        ValidRec:=(NomCode>0) and (NomCode<=MaxLInt);
        GenSetError(ValidRec,30003,Result,ValidHed);
      end;  {If AddMode=B_Update ..}

      {* Nom Type Check *}

      ValidRec:=(NomType In NomTypeSet+PostSet);  { in VarConst.Pas }
                           {H,C,F}    {A,B}
      GenSetError(ValidRec,30004,Result,ValidHed);


      {* CarryF Check *}

      ValidRec:=(NomType<>Ftyp);  {Ftyp=F}
      If (Not ValidRec) then
        ValidRec:=(CheckExsists(Strip('R',[#0],FullNomKey(CarryF)),Fnum,Keypath));
      GenSetError(ValidRec,30006,Result,ValidHed);

      //Restore rec
      //Nom:=ONom;


      If (ExSyss.MCMode) then
      begin
        ValidRec:=((DefCurr<=CurrencyType));
        If (Not ValidRec) then
        begin
          DefCurr:=ExSyss.DefCur;
          ValidRec:=((DefCurr<=CurrencyType));
        end;
        //PR 1/3/06
        if NomType = 'C' then
        begin
          DefCurr := 0;  //Control codes can only be consolidated
          ValidRec := BOn;
        end;
      end
      else
        ValidRec:=BOn;

      GenSetError(ValidRec,30007,Result,ValidHed);


//---------------------------------------------------------------------------------
      {* Category/Parent Code  Check *} //At BH's request, moved to be last test in series

      ValidRec:=(Cat=0);  {* Blank Cat = Level 0 *}

      //save record before doing checkrecexists
      ONom := Nom;

      If (Not ValidRec) then
      Begin
        ValidRec:=(CheckRecExsists(Strip('R',[#0],FullNomKey(Cat)),Fnum,KeyPath));

        ValidRec:=((ValidRec) and (NomType=Htyp));
      end;
      GenSetError(ValidRec,30005,Result,ValidHed);

      //Restore record
      Nom:=ONom;

      ValidRec := NomGood_Type2(NomType, Cat);

      GenSetError(ValidRec,30008,Result,ValidHed);

      Nom:=ONom;

//---------------------------------------------------------------------------------


     end;  {If Result=0 ..}


  end; {With Nom do..}

end; {Func ExNomToNom ..}


{* -------------------------------------------------------------------------- *}

{ ============= End of ExNomToNom =============== }

FUNCTION EX_STOREGLACCOUNT(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHPATH   :  SMALLINT;
                           SEARCHMODE   :  SMALLINT) : SMALLINT;

Const
  Fnum  = NomF;
Var
  ExNomRec  :  ^TBatchNomRec;
  KeyS       :  Str255;
  TmpMode    :  SmallInt;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExNomRec:=P;
    ShowMessage('Ex_StoreGLAccount:' + #10#13 +
                'P^.NomCode: ' + IntToStr(ExNomRec^.NomCode) + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;
  TmpMode:=SearchMode;

  If (P<>Nil) and (PSize=Sizeof(TBatchNomRec)) then
  Begin

    ExNomRec:=P;

    Result:=ExNomToNom(ExNomRec^,SearchMode);

    If ((Result=0) and (TmpMode<>CheckMode)) then
    Case SearchMode of

      B_Insert  :  Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

      B_Update  :  Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

      else         Result:=30000;

    end;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(45,Result);

end; {Ex_StoreGLAccount..}

{* -------------------------------------------------------------------------- *}


FUNCTION EX_UNLOCKGLACCOUNT : SMALLINT;

Const
  Fnum = NomF;
Var
  KeyS  :  Str255;

Begin
  If TestMode Then ShowMessage('Ex_UnLockGLAccount');

  Blank(KeyS,Sizeof(KeyS));

  Result:=Find_Rec(B_Unlock,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS)

end;

{* -------------------------------------------------------------------------- *}

{ ============= To get Account File Size ================ }

FUNCTION EX_ACCOUNTFILESIZE  :  LONGINT;
Const
  Fnum   = CustF;
var
  TmpIO  : LongInt;
begin
  LastErDesc:='';
  TmpIO:=0;
  TmpIO:=Used_Recs(F[Fnum],Fnum);
  Ex_AccountFileSize:=TmpIO;
end;

{* -------------------------------------------------------------------------- *}

{ =========== To check Customer Outstanding Status ============== }

FUNCTION EX_HASOUTSTANDING(CUSTCODE  :  PCHAR) : WORDBOOL;
const

  Fnum1      = CustF;
  KeyPath1   = CustCodeK;

  Fnum2      = InvF;
  KeyPath2   = InvCDueK;

var
  KeyS       : Str255;
  TCustCode  : Str10;
  TDueDate   : Str10;
  ChStat     : Boolean;
  ExCheck    : SmallInt;

begin
  LastErDesc:='';

  ChStat:=BOff;

  KeyS:=StrPas(CustCode);
  TCustCode:=FullCustCode(KeyS);

  ChStat:=(CheckRecExsists(TCustCode,Fnum1,KeyPath1));

  {* Check Customer , Account Stat=Not Closed & AutoStatement=False *}
  If (ChStat) then
    With Cust do
     ChStat:=((CustSupp=TradeCode[BOn]) and (AccStatus in [0..2]) and (Not IncStat));


  If (ChStat) then
  begin
    TDueDate:=Today;                    {* Today Date *}
    TDueDate:=CalcDueDate(TDueDate,1);  {* Today+1 *}

    ChStat:=BOff;
    {* search in Inv File with KeyS *}
    KeyS:=TradeCode[BOn]+TCustCode+TDueDate;
    ExCheck:=Find_Rec(B_GetLessEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    While (ExCheck=0) and (Inv.CustCode=TCustCode) and (Not ChStat) do
    begin
      {* SIN, NomAuto=True, OSAmount<>0 *}
      ChStat:=((Inv.InvDocHed=SalesStart) and (Inv.NomAuto=BOn) and (Round_Up(BaseTotalOS(Inv),2)<>0.0) );
      ExCheck:=Find_Rec(B_GetPrev,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

    end; {while..}

  end; {If CustCode OK..}

  Ex_HasOutStanding:=BoolToWordBool(ChStat);

end;

{* -------------------------------------------------------------------------- *}


{$IFDEF WIN32}


{* New 25.11.98 *}

Function ExDiscToDisc2(ExDisc  :  TBatchDiscRec;
                       SMode   :  SmallInt)  :  Integer;

{* To continue - Allow to update the record, if By customer and Type is QtyBreak,
                 need to delete all QtyBreak records *}

Const
  Fnum   = MiscF;
  KPath  = MIK;

Var
  FindRec,
  ValidCheck,
  ValidHed,
  ByCuQty,
  ByCust  :  Boolean;

  TMRec   :  ^MiscRec;

  KeyS,
  KeyChk  :  String[255];

begin
  Result:=0;
  ValidCheck:=BOff;
  VAlidHed:=BOn;

  New(TMRec);
  FillChar(TMRec^,SizeOf(TMRec^),#0);

  With ExDisc do
  begin

    CustCode:=FullCustCode(Custcode);
    StockCode:=LJVar(UpperCase(StockCode),StkLen);
    DiscType:=UpCase(DiscType);
    SalesBand:=UpCase(SalesBand);

    ByCust:=(Not EmptyKey(CustCode,AccLen));
    {* By Customer and DiscType = QtyBreak *}
    ByCuQty:=(ByCust) and WordBoolToBool(QtyBreak);


    {* ---------------------------------- *}
    If (ByCust) then
    begin

      KeyS:=CDDiscCode+CDDiscCode+MakeCDKey(CustCode,StockCode,SPCurrency)+HelpKStop;

    end
    else
    begin

      KeyS:=QBDiscCode+QBDiscSub+MakeQDKey(FullNomKey(Stock.StockFolio),SPCurrency,QtyTo);

    end;

    KeyChk:=KeyS;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath,KeyS);

    FindRec:=StatusOk;

    {import - assign appro. mode }
    If (SMode=CheckMode) or (SMode=ImportMode) then
    begin
      If (FindRec) then
        SMode:=B_Update
      else
        SMode:=B_Insert;
    end;

    If (SMode=B_Insert) then
    Begin
      ResetRec(Fnum);
      GenSetError(Not FindRec,5,Result,ValidHed);
    end
    else
      GenSetError(FindRec,4,Result,ValidHed);

    {* ---------------------------------- *}

    {* Start Validation ....*}

    {* Check Stock Code *}
    ValidCheck:=CheckRecExsists(StockCode,StockF,StkCodeK);
    ValidCheck:=(ValidCheck) and (Stock.Stocktype<>StkGrpCode);

    GenSetError(ValidCheck,30001,Result,ValidHed);

    {* Check Customer Code *}
    If (ByCust) then
    begin
      ValidCheck:=CheckRecExsists(CustCode,CustF,CustCodeK);
      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[BOn]));
      GenSetError(ValidCheck,30002,Result,ValidHed);
    end; {if..}

    {* Check Qty Fr & To *}
    If WordBoolToBool(QtyBreak) then
    begin
      ValidCheck:=(QtyFr>0) and (QtyFr<=QtyTo);
      GenSetError(ValidCheck,30007,Result,ValidHed);
    end
    else
    begin
      QtyFr:=0;
      QtyTo:=0;
    end; {if..}

    {* Discount Type Check, without QtyBreak *}

    ValidCheck:=(DiscType In [QBPriceCode,QBBandCode,QBMarginCode,QBMarkupCode]);

    GenSetError(ValidCheck,30003,Result,ValidHed);


    Case DiscType of
      QBPriceCode  :  begin {* If Special Price ..*}

                        {* Check Unit Price and Currency *}
                        ValidCheck:=(SPrice<>0);
                        GenSetError(ValidCheck,30004,Result,ValidHed);
                        If (ExSyss.MCMode) then
                          ValidCheck:=((SPCurrency>=1) and (SPCurrency<=CurrencyType))
                        else
                        Begin
                          ValidCheck:=BOn;
                          SPCurrency:=0;
                        end; {if..}
                        GenSetError(ValidCheck,30005,Result,ValidHed);
                        {* Leave other fields blank *}
                        SalesBand:=' ';
                        DiscPer:=0;
                        DiscAmt:=0;
                        DiscMar:=0;
                      end;
      QBBandCode   :  begin {* If Band Price ..*}
                        {* Check Sales Band *}
                        ValidCheck:=(SalesBand In StkBandSet);
                        GenSetError(ValidCheck,30006,Result,ValidHed);
                        {* To confirm - need to check Disc % ? *}

                        {* Leave Blank for Special Price *}
                        SPrice:=0;
                        SPCurrency:=0;
                      end;

      QBMarginCode,
      QBMarkUpCode :  begin {* If Margin or MarkUp ..*}
                        {* Check Margin % *}
                        ValidCheck:=(DiscMar<>0);
                        GenSetError(ValidCheck,30007,Result,ValidHed);
                        SalesBand:=' ';
                        SPrice:=0;
                        SPCurrency:=0;
                        DiscPer:=0;
                        DiscAmt:=0;
                      end;
    end; {case..}
  end; {With ExDisc..}

  {* ------ End of Validation ------- *}

  {* Add/Update Record ...*}
  If (Result=0) and (SMode<>CheckMode) then
  begin

    ReSetRec(MiscF);

    {* By Customer Discount *}
    If (ByCust) then
    With MiscRecs^.CustDiscRec do
    begin
      MiscRecs^.RecMFix:=CDDiscCode;
      MiscRecs^.SubType:=CDDiscCode;

      DCCode:=ExDisc.CustCode;
      QStkCode:=ExDisc.StockCode;

      {.$IFDEF COMTK} //PR: 11/05/2009 Added date range for 6.01
      CUseDates := WordBoolToBool(ExDisc.UseDates);
      CStartD := ExDisc.StartDate;
      CEndD := ExDisc.EndDate;
      {.$ENDIF}

      If (Not ByCuQty) then
      begin
        QBType:=ExDisc.DiscType;
        QBCurr:=ExDisc.SPCurrency;
        QSPrice:=ExDisc.SPrice;
        QBand:=ExDisc.SalesBand;
        QDiscP:=ExDisc.DiscPer;
        QDiscA:=ExDisc.DiscAmt;
        QMUMG:=ExDisc.DiscMar;
      end
      else
      begin
        QBType:=QBQtyBCode;
      end;  {if..}

      DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;

      KeyS:=CDDiscCode+CDDiscCode+DiscCode;
      KeyChk:=KeyS;

      TMRec^:=MiscRecs^;

      Result:=Find_Rec(B_GetGEq,F[MiscF],MiscF,RecPtr[MiscF]^,MIK,KeyS);

      MiscRecs^:=TMRec^;

      If (Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
      begin
        Result:=Put_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);
      end
      else
      begin
        Result:=Add_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);
      end;

      //PR: 28/10/2011 v6.9 Add audit note for account
      if Result = 0 then
        AuditNote.AddNote(anAccount, Cust.CustCode, anEdit);
    end; {If ByCust..}

    ReSetRec(MiscF);

    {* By Global Stock Discount or By Customer & Qty Break *}
    If ((Not ByCust) or (ByCuQty)) then
    With MiscRecs^.QtyDiscRec do
    begin

      FQB:=ExDisc.QtyFr;
      TQB:=ExDisc.QtyTo;
      QBType:=ExDisc.DiscType;
      QBCurr:=ExDisc.SPCurrency;
      QSPrice:=ExDisc.SPrice;
      QBand:=ExDisc.SalesBand;
      QDiscP:=ExDisc.DiscPer;
      QDiscA:=ExDisc.DiscAmt;
      QMUMG:=ExDisc.DiscMar;
      {.$IFDEF COMTK} //PR: 11/05/2009 Added date range for 6.01
      QUseDates := WordBoolToBool(ExDisc.UseDates);
      QStartD := ExDisc.StartDate;
      QEndD := ExDisc.EndDate;
      {.$ENDIF}

      QStkFolio:=Stock.StockFolio;



      MiscRecs^.RecMFix:=QBDiscCode;   {D}

      If (ByCuQty) then  {* By Customer and Qty Break *}
      begin
        QCCode:=ExDisc.CustCode;
        MiscRecs^.SubType:=CDDiscCode; {C}
        DiscQtyCode:=MakeQDKey(FullCDKey(QCCode,QStkFolio),QBCurr,TQB);
        KeyS:=QBDiscCode+CDDiscCode+DiscQtyCode;
      end
      else
      begin
        MiscRecs^.SubType:=QBDiscSub;  {Q}
        DiscQtyCode:=MakeQDKey(FullNomKey(QStkFolio),QBCurr,TQB);
        KeyS:=QBDiscCode+QBDiscSub+DiscQtyCode;
      end; {if..}

      KeyChk:=KeyS;

      TMRec^:=MiscRecs^;

      Result:=Find_Rec(B_GetGEq,F[MiscF],MiscF,RecPtr[MiscF]^,MIK,KeyS);

      MiscRecs^:=TMRec^;

      If (Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
        Result:=Put_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK)
      else
        Result:=Add_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);

      //PR: 28/10/2011 v6.9 Add audit note - could be account or stock
      if Result = 0 then
      begin
        if ByCust then
          AuditNote.AddNote(anAccount, Cust.CustCode, anEdit)
        else
          AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);
      end;


    end; {if..}

  end; {if Result=0 ...}

  Dispose(TMRec);

end; {func..}

{* -------------------------------------------------------------------------- *}

{* For Discount Matrix by Customer and Stock - 20.11.98 *}
Function ExDiscToDisc(ExDisc  :  TBatchDiscRec;
                      SMode   :  SmallInt)  :  Integer;

{* To continue - Allow to update the record, if By customer and Type is QtyBreak,
                 need to delete all QtyBreak records *}


Var
  ValidCheck,
  ValidHed,
  ByCuQty,
  ByCust  :  Boolean;

  TMRec   :  ^MiscRec;

  KeyS,
  KeyChk,
  DCode  :  String[255];

  AcSubType : Char;

  TempDisc : TBatchDiscRec;
  TempRes : SmallInt;
  DateConflictFound : Boolean;
  QtyConflictFound : Boolean;
  UsingDates : Boolean;
  RecAddr : longint;

  //PR: 15/02/2012 ABSEXCH-9795 New variables + removed CheckDiscountBelongs function which is no longer used.
  FileNo : Integer;
  TempQtyBreak : TQtyBreakRec;
  CustomerQtyBreakFolio : longint;
  KeyPath : longint;
  Found : Boolean;
  Res : Integer;

  {SS 21/06/2016 2016-R3
   ABSEXCH-15169:Importer-displays misleading error when importing conflicting qty break ranges.}
   
  function FloatRangeClash(Start1, End1, Start2, End2 : Double) : Boolean;
  begin
    Result := (Start1 >= Start2) and (Start1 <= End2) or
              (End1 >= Start2) and (End1 <= End2);
  end;

  function QtyRangeClash : Boolean;
  begin
    with ExDisc do
      Result := FloatRangeClash(QtyFr, QtyTo, QtyBreakRec.qbQtyFrom, QtyBreakRec.qbQtyTo)
                or
                FloatRangeClash(QtyBreakRec.qbQtyFrom, QtyBreakRec.qbQtyTo,QtyFr, QtyTo);
  end;

begin
  Result:=0;
  KeyPath := 0; //only change if we're search qty break file by folio.
  ValidCheck:=BOff;
  VAlidHed:=BOn;
  AcSubType := #0;
  CustomerQtyBreakFolio := 0;
  
  New(TMRec);
  FillChar(TMRec^,SizeOf(TMRec^),#0);

  With ExDisc do
  begin

    CustCode:=FullCustCode(Custcode);
    DiscType:=UpCase(DiscType);
    //PR: 11/05/2009 For value-based discount, blank out stock code
    if DiscType = QBValueCode then
    begin
      StockCode := '';
      SPCurrency := VBCurrency;
      SPrice := VBThreshold;
    end;

    StockCode:=LJVar(UpperCase(StockCode),StkLen);

    SalesBand:=UpCase(SalesBand);

    ByCust:=(Not EmptyKey(CustCode,AccLen));

    if not ByCust then
      CustomerQtyBreakFolio := 0; //Reset for Stock Qty Breaks ABSEXCH-9795

    {* By Customer and DiscType = QtyBreak *}
    ByCuQty:=(ByCust) and WordBoolToBool(QtyBreak);

    UsingDates := WordBoolToBool(UseDates);


    //PR: 14/02/2012 ABSEXCH-9795
    if not ByCust or ByCUQty then
    begin
      FileNo := QtyBreakF;
      QtyBreak := BoolToWordBool(True);
    end
    else
      FileNo := MiscF;


    {* Start Validation ....*}

    {* Check Customer Code *}

    If (ByCust) then
    begin
      ValidCheck:=CheckRecExsists(CustCode,CustF,CustCodeK);
      {$IFNDEF COMTK}
        { HM 21/06/01: Removed limitation to Customers for COM Toolkit }
        ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[BOn]));
      {$ENDIF}
      AcSubType := Cust.CustSupp;
      GenSetError(ValidCheck,30001,Result,ValidHed);
    end; {if..}

    {* Check Stock Code *}
    if DiscType <> QBValueCode then
    begin
      ValidCheck:=CheckRecExsists(StockCode,StockF,StkCodeK);
//PR 15/4/2002 - Allow discounts for stock groups
//    ValidCheck:=(ValidCheck) and (Stock.Stocktype<>StkGrpCode);

      GenSetError(ValidCheck,30002,Result,ValidHed);
    end;

    {* Check Qty Fr & To *}
    If WordBoolToBool(QtyBreak) then
    begin
      ValidCheck:=(QtyFr>0) and (QtyFr<=QtyTo);
      GenSetError(ValidCheck,30003,Result,ValidHed);
    end
    else
    begin
      QtyFr:=0;
      QtyTo:=0;
    end; {if..}

    //PR: 17/02/2012 Importer has COMTK defined, but for this functionality works like the DLL Tk,
    //so change defines to match. ABSEXCH-9795
    {$IF not Defined(COMTK) or Defined(IMPv6)}
      {* Discount Type Check, without QtyBreak *}
      ValidCheck:=(DiscType In [QBPriceCode,QBBandCode,QBMarginCode,QBMarkupCode, QBValueCode]);
      if not ValidCheck and (Result = 0) then
      begin
        //PR: 17/11/2015 ABSEXCH-13571 Check if this is a Qty Break header record - if it is,
        //                             then we don't need to go any further - it will be created
        //                             automatically below
        ValidCheck := ByCust and not ByCuQty and (DiscType = QBQtyBCode);
        if ValidCheck then
          EXIT;
      end;
    {$Else}
      // Due to redesigned interface in COM TK - validation must allow Qty Brk records here
      // otherwise identical to standard section above
      ValidCheck:=(DiscType In [QBPriceCode,QBBandCode,QBMarginCode,QBMarkupCode,QBQtyBCode, QBValueCode]);
    {$IfEnd}

    GenSetError(ValidCheck,30004,Result,ValidHed);


    Case DiscType of
      QBPriceCode  :  begin {* If Special Price ..*}

                        {* Check Unit Price and Currency *}
                        ValidCheck:=(SPrice<>0);
                        GenSetError(ValidCheck,30005,Result,ValidHed);
                        If (ExSyss.MCMode) then
                          // HM 01/11/01: Extended valiation to cover ccy 0 which is a default
                          //              discount if no currency specific discount is found
                          //ValidCheck:=((SPCurrency>=1) and (SPCurrency<=CurrencyType))
                          ValidCheck:=((SPCurrency>=0) and (SPCurrency<=CurrencyType))
                        else
                        Begin
                          ValidCheck:=BOn;
                          SPCurrency:=0;
                        end; {if..}
                        GenSetError(ValidCheck,30006,Result,ValidHed);
                        {* Leave other fields blank *}
                        SalesBand:=' ';
                        DiscPer:=0;
                        DiscAmt:=0;
                        DiscMar:=0;
                      end;
      QBBandCode   :  begin {* If Band Price ..*}
                        {* Check Sales Band *}
                        ValidCheck:=(SalesBand In StkBandSet);
                        GenSetError(ValidCheck,30007,Result,ValidHed);

                        //PR: 12/10/2010 Need to validate currency on all discounts
                        If (ExSyss.MCMode) then
                          // HM 01/11/01: Extended valiation to cover ccy 0 which is a default
                          //              discount if no currency specific discount is found
                          //ValidCheck:=((SPCurrency>=1) and (SPCurrency<=CurrencyType))
                          ValidCheck:=((SPCurrency>=0) and (SPCurrency<=CurrencyType))
                        else
                        Begin
                          ValidCheck:=BOn;
                          SPCurrency:=0;
                        end; {if..}
                        GenSetError(ValidCheck,30006,Result,ValidHed);

                        {* To confirm - need to check Disc % ? *}

                        {* Leave Blank for Special Price *}
                        SPrice:=0;
                        //SPCurrency:=0;
                      end;

      QBMarginCode,
      QBMarkUpCode :  begin {* If Margin or MarkUp ..*}
                        {* Check Margin % *}
                        ValidCheck:=(DiscMar<>0);
                        GenSetError(ValidCheck,30008,Result,ValidHed);

                        //PR: 12/10/2010 Need to validate currency on all discounts
                        If (ExSyss.MCMode) then
                          // HM 01/11/01: Extended valiation to cover ccy 0 which is a default
                          //              discount if no currency specific discount is found
                          //ValidCheck:=((SPCurrency>=1) and (SPCurrency<=CurrencyType))
                          ValidCheck:=((SPCurrency>=0) and (SPCurrency<=CurrencyType))
                        else
                        Begin
                          ValidCheck:=BOn;
                          SPCurrency:=0;
                        end; {if..}
                        GenSetError(ValidCheck,30006,Result,ValidHed);

                        SalesBand:=' ';
                        SPrice:=0;
//                        SPCurrency:=0;
                        DiscPer:=0;
                        DiscAmt:=0;
                      end;
      //PR: 11/05/2009 Added Value-Based discounts
      QBValueCode  :  begin
                        //Any specific validation?
                        If (ExSyss.MCMode) then
                          // HM 01/11/01: Extended valiation to cover ccy 0 which is a default
                          //              discount if no currency specific discount is found
                          //ValidCheck:=((SPCurrency>=1) and (SPCurrency<=CurrencyType))
                          ValidCheck:= (VBCurrency>=0) and (VBCurrency<=CurrencyType)
                        else
                        Begin
                          ValidCheck:=BOn;
                          SPCurrency:=0;
                        end; {if..}
                        SalesBand:=' ';
                      end;
    end; {case..}
  end; {With ExDisc..}

  {.$IFDEF COMTK}  //PR: 11/05/2009 Allow dates for dlltk as well
  if (Result = 0) then
  begin
    if  UsingDates then
    begin
      ValidCheck := ValidDate(ExDisc.StartDate);
      GenSetError(ValidCheck,30009,Result,ValidHed);

      ValidCheck := ValidDate(ExDisc.EndDate);
      GenSetError(ValidCheck,30010,Result,ValidHed);

      ValidCheck := ExDisc.EndDate >= ExDisc.StartDate;
      GenSetError(ValidCheck,30012,Result,ValidHed);
    end;

(*    if ByCust then
    begin
      if not ByCuQty then
      begin
        DCode:=MakeCDKey(ExDisc.CustCode,EXDisc.StockCode,EXDisc.SPCurrency)+HelpKStop;
        KeyS:=CDDiscCode+Cust.CustSupp+DCode;
      end
      else
      begin
        DCode:=MakeQDKey(FullCDKey(ExDisc.CustCode,Stock.StockFolio),ExDisc.SPCurrency,ExDisc.QtyTo);
        KeyS:=QBDiscCode+MiscRecs^.SubType+DCode;
      end;
      KeyChk:=KeyS;
    end
    else
    begin
      DCode:=MakeQDKey(FullNomKey(Stock.StockFolio),ExDisc.SPCurrency,ExDisc.QtyTo);
      KeyS:=QBDiscCode+QBDiscSub+DCode;
      KeyChk := KeyS;
    end;
*)
    //PR: 15/02/2012 Amended to use new Qty Breaks file ABSEXCH-9795
    if ByCust and not ByCuQty then
    begin
      DCode:=MakeCDKey(ExDisc.CustCode,EXDisc.StockCode,EXDisc.SPCurrency)+HelpKStop;
      KeyS:=CDDiscCode+Cust.CustSupp+DCode;
      KeyChk:=KeyS;
    end
    else
    begin
      KeyS := QtyBreakStartKey(ExDisc.CustCode, Stock.StockFolio) + Char(ExDisc.SPCurrency);
      KeyChk := KeyS;
    end;
    {
    Discounts are of the same class if they meet the following criteria:
      Customer Discounts - Same AcCode & StockCode + same currency.
      StockDiscounts - Same StockCode + Currency - if QtyBreak then QtyTo must also be the same.
      Value-Based Discounts - Same AcCode -  Threshold and Currency must also be the same.

    Given this, validation is as follows:
      It is not allowed to have 2 discounts of the same class without a date range.
      It is not allowed to have 2 discounts of the same class whose date ranges overlap.

    As currency is part of the key, it can effectively be ignored in the checks below.
    }

    DateConflictFound := False;
    QtyConflictFound  := False;
    TempRes := Find_Rec(B_GetGEq,F[FileNo],FileNo,RecPtr[FileNo]^,Keypath,KeyS);
    GetPos(F[FileNo], FileNo, RecAddr);
    While (TempRes = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) {CheckDiscountBelongs} and Not DateConflictFound do
    begin
      //PR: 15/07/2010 If we're updating we don't want to check existing copy of record for a clash! Currntly comtk only.
      {$IFDEF COMTK}
      if (SMode = B_Insert) or (RecAddr <> ExDisc.RecordPos) then
      {$ENDIF}
      begin  //PR: 15/02/2012 Any QtyBreak gets checked in the else clause. ABSEXCH-9795
        if ByCust and not ByCuQty then
        begin
          //PR: 07/10/2010 Date check was checking for new record overlapping or entirely within existing record
          //but not for existing record entirely within new reoord
          DateConflictFound := (
                                (SMode = B_Insert) and
                                ((UsingDates = MiscRecs^.CustDiscRec.CUseDates) and not UsingDates)
                               )
                               or
                               (
                                 ((UsingDates = MiscRecs^.CustDiscRec.CUseDates) and UsingDates) and
                                 (
                               ((ExDisc.StartDate >= MiscRecs^.CustDiscRec.CStartD) and (ExDisc.StartDate <= MiscRecs^.CustDiscRec.CEndD)) or
                               ((ExDisc.EndDate >= MiscRecs^.CustDiscRec.CStartD) and (ExDisc.EndDate <= MiscRecs^.CustDiscRec.CEndD)) or
                               ((ExDisc.StartDate <= MiscRecs^.CustDiscRec.CStartD) and (ExDisc.EndDate >= MiscRecs^.CustDiscRec.CEndD))
                                 )
                               );

          //if Value-Based then also check threshold and currency
          if ExDisc.DiscType = QBValueCode then
            DateConflictFound := DateConflictFound and (ExDisc.VBThreshold = MiscRecs^.CustDiscRec.QSPrice)
          else
          if ExDisc.DiscType = QBPriceCode then
//            DateConflictFound := DateConflictFound and (ExDisc.SPrice = MiscRecs^.CustDiscRec.QSPrice);
            //PR: 07/10/2010 Was checking price rather than currency - D'Oh!
            DateConflictFound := DateConflictFound and (ExDisc.SPCurrency = MiscRecs^.CustDiscRec.QBCurr)
          else
          begin
            {SS 21/06/2016 2016-R3 
        	  ABSEXCH-15169:Importer-displays misleading error when importing conflicting qty break ranges.
            - Check for the Quantity conflict }
            QtyConflictFound :=  (not WordBoolToBool(ExDisc.QtyBreak) or (QtyRangeClash));
            DateConflictFound := (DateConflictFound or not UsingDates) and  QtyConflictFound;
          end;

        end
        else
        begin  //PR: 15/02/2012 Use new QtyBreak record. ABSEXCH-9795
          DateConflictFound := (
                                (SMode = B_Insert) and
                                ((UsingDates = QtyBreakRec.qbUseDates) and not UsingDates)
                               )
                               or
                               (
                                 ((UsingDates = QtyBreakRec.qbUseDates) and UsingDates) and
                                 (
                               ((ExDisc.StartDate >= QtyBreakRec.qbStartDate) and (ExDisc.StartDate <= QtyBreakRec.qbEndDate)) or
                               ((ExDisc.EndDate >= QtyBreakRec.qbStartDate) and (ExDisc.EndDate <= QtyBreakRec.qbEndDate)) or
                               ((ExDisc.StartDate <= QtyBreakRec.qbStartDate) and (ExDisc.EndDate >= QtyBreakRec.qbEndDate))
                                 )
                               );


{          DateConflictFound := (UsingDates = MiscRecs^.CustDiscRec.CUseDates) and
                               not UsingDates or
                               ((ExDisc.StartDate >= MiscRecs^.QtyDiscRec.QStartD) and (ExDisc.StartDate <= MiscRecs^.QtyDiscRec.QEndD)) or
                               ((ExDisc.EndDate >= MiscRecs^.QtyDiscRec.QStartD) and (ExDisc.EndDate <= MiscRecs^.QtyDiscRec.QEndD));}

          {SS 21/06/2016 2016-R3 
        	 ABSEXCH-15169:Importer-displays misleading error when importing conflicting qty break ranges.
           - Check for the Quantity conflict }

          QtyConflictFound :=  (not WordBoolToBool(ExDisc.QtyBreak) or (QtyRangeClash));
          DateConflictFound := (DateConflictFound or not UsingDates) and  QtyConflictFound;


        end;
      end;

      if not DateConflictFound then
      begin
        TempRes := Find_Rec(B_GetNext,F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath,KeyS);
        GetPos(F[FileNo],FileNo, RecAddr);
      end;
    end;

    if QtyConflictFound and DateConflictFound then
    begin
      ValidCheck := not QtyConflictFound;
      GenSetError(ValidCheck,30013,Result,ValidHed);
    end
    else
    if DateConflictFound then
    begin
      ValidCheck := not DateConflictFound;
      GenSetError(ValidCheck,30011,Result,ValidHed);
    end;
  end;
  {.$ENDIF}

  {* ------ End of Validation ------- *}

  {* Add/Update Record ...*}
  If (Result=0) and (SMode<>CheckMode) then
  begin

    ReSetRec(MiscF);

    {* By Customer Discount *}
    //PR: 17/02/2012 Importer has COMTK defined, but for this functionality works like the DLL Tk,
    //so change defines to match. ABSEXCH-9795
    {$IF not Defined(COMTK) or Defined(IMPv6)}
    If (ByCust)  then
    {$Else}
    if ByCust and not ByCuQty then
    {$IfEnd}
      With MiscRecs^.CustDiscRec do
      begin
        MiscRecs^.RecMFix:=CDDiscCode;
        { HM 21/06/01: Extended to support suppliers for COM TK }
        {$IFNDEF COMTK}
          MiscRecs^.SubType := CDDiscCode;
        {$ELSE}
          MiscRecs^.SubType := AcSubType;
        {$ENDIF}

        DCCode:=ExDisc.CustCode;
        QStkCode:=ExDisc.StockCode;


        //PR: 15/02/2012 Removed limitation to Com Toolkit
        CUseDates := WordBoolToBool(ExDisc.UseDates);

        //PR: 17/11/2015 ABSEXCH-13571 Only copy dates if they are used
        if CUseDates then
        begin
          CStartD := ExDisc.StartDate;
          CEndD := ExDisc.EndDate;
        end
        else
        begin
          CStartD := '';
          CEndD := '';
        end;

        //PR: 16/02/2016 ABSEXCH-14207 v2016 R1 Need to set qb folio
        QtyBreakFolio := ExDisc.QBFolio;


        If (Not ByCuQty) then
        begin
          QBType:=ExDisc.DiscType;
          if ExDisc.DiscType <> QBValueCode then
          begin
            QBCurr:=ExDisc.SPCurrency;
            QSPrice:=ExDisc.SPrice;
          end
          else
          begin
            QBCurr:=ExDisc.VBCurrency;
            QSPrice:=ExDisc.VBThreshold;
          end;
          QBand:=ExDisc.SalesBand;
          QDiscP:=ExDisc.DiscPer;
          QDiscA:=ExDisc.DiscAmt;
          QMUMG:=ExDisc.DiscMar;
        end
        else
          QBType:=QBQtyBCode;

        DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;

        { HM 21/06/01: Extended to support suppliers for COM TK }
        {KeyS:=CDDiscCode+CDDiscCode+DiscCode;}
        KeyS:=CDDiscCode+MiscRecs^.SubType+DiscCode;
        KeyChk:=KeyS;

        //PR: 17/02/2012 Importer has COMTK defined, but for this functionality works like the DLL Tk,
        //so change defines to match. ABSEXCH-9795
        {$If not Defined(COMTK) or Defined(IMPv6)}

        TMRec^:=MiscRecs^;

        //See if this record already exists
        Result:=Find_Rec(B_GetGEq,F[MiscF],MiscF,RecPtr[MiscF]^,MIK,KeyS);

        //PR: 17/11/2015 ABSEXCH-13571 Need to check that dates are the same for a match
        While (Result = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and
              (TMRec.CustDiscRec.CStartD <> MiscRecs^.CustDiscRec.CStartD) and
              (TMRec.CustDiscRec.CEndD <> MiscRecs^.CustDiscRec.CEndD) do
        begin
          Result:=Find_Rec(B_GetNext,F[MiscF],MiscF,RecPtr[MiscF]^,MIK,KeyS);
        end;

        If (Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
        begin  //Discount already exists, so need to maintain the QtyBreakFolio ABSEXCH-9795
          //Only update if not a QB Header - for QBH there is nothing to update
          if QBType <> QBQtyBCode then
          begin
            TMRec^.CustDiscRec.QtyBreakFolio := MiscRecs^.CustDiscRec.QtyBreakFolio;
            MiscRecs^:=TMRec^;
            Result:=Put_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);
          end;
        end
        else
        begin
          MiscRecs^:=TMRec^;
          if ByCust then
            MiscRecs^.CustDiscRec.QtyBreakFolio := GetNextQtyBreakFolio;
          Result:=Add_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);
        end;

        {$Else}  //ComToolkit and not Importer
         if SMode = B_Insert then
         begin
           if ByCust then
             MiscRecs^.CustDiscRec.QtyBreakFolio := GetNextQtyBreakFolio;

           Result:=Add_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);
         end
         else
         begin
           TMRec^:=MiscRecs^;
           SetDataRecOfsPtr (MiscF, ExDisc.RecordPos, RecPtr[MiscF]^);

           Result := GetDirect(F[MiscF], MiscF, RecPtr[MiscF]^, MIK, 0);
           MiscRecs^:=TMRec^;

           if Result = 0 then
             Result := Put_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,MIK);
         end;

        {$IfEnd}
         CustomerQtyBreakFolio := MiscRecs^.CustDiscRec.QtyBreakFolio;

        //PR: 31/10/2011 v6.9 Add audit note - could be account or stock
        if Result = 0 then
        begin
          if ByCust then
            AuditNote.AddNote(anAccount, Cust.CustCode, anEdit)
          else
            AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);
        end;


      end; {If ByCust..}

    if SMode <> B_Insert then
      ReSetRec(QtyBreakF);

    {* By Global Stock Discount or By Customer & Qty Break *}

    //PR: 15/02/2012 Change to use new Qty Break record ABSEXCH-9795
    If ((Not ByCust) or (ByCuQty)) then
    With QtyBreakRec do
    begin

      //PR: 15/02/2012 remove limitation to Com toolkit
      qbUseDates := WordBoolToBool(ExDisc.UseDates);
      qbStartDate := ExDisc.StartDate;
      qbEndDate := ExDisc.EndDate;

      qbQtyFrom := ExDisc.QtyFr;
      qbQtyTo := ExDisc.QtyTo;
      qbBreakType := BreakTypeFromDiscountChar(ExDisc.DiscType);
      qbCurrency := ExDisc.SPCurrency;
      qbSpecialPrice := ExDisc.SPrice;
      qbPriceBand := ExDisc.SalesBand;
      qbDiscountPercent := ExDisc.DiscPer;
      qbDiscountAmount := ExDisc.DiscAmt;
      qbMarginOrMarkup := ExDisc.DiscMar;

      //PR: 24/04/2012 qbQtyToString wasn't being populated ABSEXCH-12866
      qbQtyToString := FormatBreakQtyTo(qbQtyTo);


      qbStockFolio:=Stock.StockFolio;

      //PR: 19/04/2012 ABSEXCH-12835

      {SS 08/09/2016 2016-R3
     	ABSEXCH-17711:Importing updates to Unit Price is blanking the entries in the Qty Breaks tab because the folio is set to 1 rather than 0
      * qbFolio should be updated if the sMode is B_Update otherwise it will set qbFolio to 1 which causes in weird behaviour.}

      if (SMode = B_Insert) or ( (SMode = B_Update) and (Trim(ExDisc.CustCode)=EmptyStr) )then //Set link to parent record
      begin
        {$If not Defined(COMTK) or Defined(IMPv6)}
        qbFolio := CustomerQtyBreakFolio;
        {$Else}
        qbFolio := ExDisc.QBFolio;
        {$IfEnd}
      end;
      qbAcCode := LJVar(ExDisc.CustCode, AccLen);

      If (ByCuQty) then  {* By Customer and Qty Break *}
      begin

        KeyS := FullNomKey(qbFolio);
        KeyChk := TrimString(psRight, KeyS, #0);
        KeyPath := qbFolioIdx;
      end
      else
      begin
        KeyS := QtyBreakStartKey('', qbStockFolio);
        KeyChk:=KeyS;
      end; {if..}


        //PR: 17/02/2012 Importer has COMTK defined, but for this functionality works like the DLL Tk,
        //so change defines to match. ABSEXCH-9795

        {$IF not Defined(COMTK) or Defined(IMPv6)}

        //PR: 15/02/2012 For DLL Toolkit, search for match by QtyTo (as with customer discounts) and
        //either start or end date. ABSEXCH-9795
        TempQtyBreak := QtyBreakRec;
        Found := False;

        Res :=Find_Rec(B_GetGEq,F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath,KeyS);

        while (Res = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and not Found do
        begin
          Found := (TempQtyBreak.qbUseDates = QtyBreakRec.qbUseDates) and
                   (TempQtyBreak.qbQtyTo = QtyBreakRec.qbQtyTo) and
                   (not TempQtyBreak.qbUseDates or (
                      (TempQtyBreak.qbStartDate = QtyBreakRec.qbStartDate) or
                      (TempQtyBreak.qbEndDate = QtyBreakRec.qbEndDate)
                      )
                    );

          if not Found then
            Res :=Find_Rec(B_GetNext,F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath,KeyS);
        end;

        QtyBreakRec := TempQtyBreak;

        If Found and (Res=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
        begin
          Result:=Put_Rec(F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath);
        end
        else
          Result:=Add_Rec(F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath);

        {$Else}
         if SMode = B_Insert then
           Result:=Add_Rec(F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath)
         else
         begin
           TempQtyBreak := QtyBreakRec;

           SetDataRecOfsPtr (FileNo, ExDisc.RecordPos, RecPtr[FileNo]^);

           Result := GetDirect(F[FileNo], FileNo, RecPtr[FileNo]^, KeyPath, 0);

           QtyBreakRec := TempQtyBreak;

           if Result = 0 then
             Result := Put_Rec(F[FileNo],FileNo,RecPtr[FileNo]^,KeyPath);
         end;
        {$IfEnd}

    end; {if..}

  end; {if Result=0 ...}

  Dispose(TMRec);

end; {func..}

{* -------------------------------------------------------------------------- *}

{* Store Disount Matrix by Customer / Stock *}

FUNCTION EX_STOREDISCMATRIX(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXPORT;

Const
  Fnum     =  MiscF;
  KeyPath  =  MIK;
Var
  ExDiscRec  :  ^TBatchDiscRec;
  KeyS       :  Str255;

Begin
  LastErDesc:='';
  If TestMode Then Begin
    ExDiscRec:=P;
    ShowMessage('Ex_StoreDiscMatrix :' + #10#13 +
                'P^.CustCode: ' + ExDiscRec^.CustCode + #10#13 +
                'PSize: ' + IntToStr(PSize));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchDiscRec)) then
  Begin

    ExDiscRec:=P;

    Result:=ExDiscToDisc(ExDiscRec^, SearchMode);

    //PR: 16/02/2016 v2016 R1 ABSEXCH-14208 Copy back Qty Break folio number to toolkit record
    if Result = 0 then
      ExDiscRec^.QBFolio := MiscRecs^.CustDiscRec.QtyBreakFolio;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(7,Result);

end; {Ex_StoreDiscMatrix Func..}


{* -------------------------------------------------------------------------- *}

Procedure ExCustDiscToTKCustDisc (Const ExCustDisc : CustDiscType;
                                  Var   TkCustDisc : TBatchDiscRec);
Begin { ExCustDiscToTKCustDisc }
  FillChar (TkCustDisc, SizeOf(TkCustDisc), #0);
  With TkCustDisc Do Begin
    CustCode   := ExCustDisc.DCCode;
    StockCode  := ExCustDisc.QStkCode;
    DiscType   := ExCustDisc.QBType;
    SalesBand  := ExCustDisc.QBand;
    SPCurrency := ExCustDisc.QBCurr;
    SPrice     := ExCustDisc.QSPrice;
    DiscPer    := ExCustDisc.QDiscP;
    DiscAmt    := ExCustDisc.QDiscA;
    DiscMar    := ExCustDisc.QMUMG;
    QtyBreak   := BoolToWordBool(DiscType=QBQtyBCode);
    QtyFr      := 0;
    QtyTo      := 0;
    VBCurrency := SPCurrency;
    VBThreshold := SPrice;
    {.$IFDEF COMTK}   //PR: 11/05/2009 Added date range for 6.01
    UseDates := BoolToWordBool(ExCustDisc.CUseDates);
    StartDate := ExCustDisc.CStartD;
    EndDate := ExCustDisc.CEndD;
    QBFolio := ExCustDisc.QtyBreakFolio;
    {.$ENDIF}
  End; { With TkCustDisc }
End; { ExCustDiscToTKCustDisc }

{------------------------------}

Procedure ExQtyBrkToTKQtyBrk (Const ExQtyBrk : TQtyBreakRec;
                              Var   TkQtyBrk : TBatchDiscRec);
Begin { ExQtyBrkToTKQtyBrk }
  FillChar (TkQtyBrk, SizeOf(TkQtyBrk), #0);
  With TkQtyBrk Do Begin
    CustCode   := ExQtyBrk.qbAcCode;
    DiscType   := DiscountCharFromBreakType(ExQtyBrk.qbBreakType);
    SalesBand  := ExQtyBrk.qbPriceBand;
    SPCurrency := ExQtyBrk.qbCurrency;
    SPrice     := ExQtyBrk.qbSpecialPrice;
    DiscPer    := ExQtyBrk.qbDiscountPercent;
    DiscAmt    := ExQtyBrk.qbDiscountAmount;
    DiscMar    := ExQtyBrk.qbMarginOrMarkup;
    QtyBreak   := BoolToWordBool(BOn);
    QtyFr      := ExQtyBrk.qbQtyFrom;
    QtyTo      := ExQtyBrk.qbQtyTo;
    {.$IFDEF COMTK} //PR: 11/05/2009 Added date range for 6.01
    UseDates   := BoolToWordBool(ExQtyBrk.qbUseDates);
    StartDate  := ExQtyBrk.qbStartDate;
    EndDate    := ExQtyBrk.qbEndDate;
    QBFolio    := ExQtyBrk.qbFolio;
    {.$ENDIF}
  End; { With TkQtyBrk }
End; { ExQtyBrkToTKQtyBrk }

{------------------------------}


{* From Exch.Disc record to External Disc Record *}
procedure DiscToExDisc(Var ExDRec    :  TBatchDiscRec;
                           ByCu,
                           ByCuQ     :  Boolean);

Var
  KeyS  :  Str255;
  ExStat:  Integer;

begin

  With ExDRec do
  begin
    If (Not ByCu) or (ByCuQ) then
    begin
    {* CustCode and StockCode are assigned by user..
      CustCode:=DCCode;
      StockCode:=Stock.StockCode;
      }


      ExQtyBrkToTKQtyBrk (QtyBreakRec, ExDRec);
      //PR: 12/10/2010 Importer uses ComTK directive so wasn't getting StockCode returned. Added Undef/Redef of COMTK.
      {$IFDEF IMPv6}
        {$UNDEF COMTK}
      {$ENDIF IMPv6}
      {$IFNDEF COMTK}
        {* Get Stock Record by QStkFolio *}
        KeyS:=FullNomKey(QtyBreakRec.qbStockFolio);
        ExStat:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkFolioK,KeyS);
        If (ExStat=0) then
          StockCode:=Stock.StockCode
        else
          StockCode:='';
      {$ENDIF}
      {$IFDEF IMPv6}
        {$DEFINE COMTK}
      {$ENDIF IMPv6}
    end
    else
    begin
      If (ByCu) then
      begin
        ExCustdiscToTKCustDisc (MiscRecs^.CustDiscRec, ExDRec);
      end; {if..}
    end; {if..}

  end; {with..}
end; {proc..}


function CheckDiscRec(const KeyChk : string) : Boolean;
begin
  Result := (MiscRecs^.RecMfix = KeyChk[1]) and (MiscRecs^.SubType = KeyChk[2]);
end;



{* -------------------------------------------------------------------------- *}
{* ------- To get the discount matrix data ------- *}

FUNCTION EX_GETDISCMATRIX(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT;
                          LOCK         :  WORDBOOL)  :  SMALLINT;
Const
  KPath =  MIK;

Var
  ExDiscRec  :  ^TBatchDiscRec;
  KeyS       :  Str255;

  ByCust,
  ByCuQBreak,
  ValidCheck,
  ValidHed,
  Locked     :  Boolean;

  LockStr    :  String[255];

  TResult    :  Integer;

  KeyChk : string;
  TempDiscRec : TBatchDiscRec;
  WantFirst,
  WantLast : Boolean;
  StockFolio : longint;

  //PR: 14/02/2012 Make FNum a variable as it will be different for qty breaks. ABSEXCH-9795
  Fnum  : Integer;
  IsQtyBreak : Boolean;

Begin
  FNum := -1;
  Result := 0;
  LastErDesc:='';

  If TestMode then
  begin
    ExDiscRec:=P;
    If WordBoolToBool(Lock) then LockStr := 'True' else LockStr := 'False';

    ShowMessage ('Ex_GetDiscMatrix:' + #10#13 +
                 'P^.CustCode: ' + ExDiscRec^.CustCode + #10#13 +
                 'P^.StockCode: ' + ExDiscRec^.StockCode + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: ' + LockStr);
  End; { If }

  ValidCheck:=BOff;
  ValidHed:=BOn;

  TResult:=32767;
  Locked:=BOff;
  ExDiscRec:=P;

  If (P<>Nil) and (PSize=Sizeof(TBatchDiscRec)) then
  With ExDiscRec^ do
  Begin

    TResult:=0;

    ByCust:=(Not EmptyKey(CustCode,AccLen));
    ByCuQBreak:=(ByCust) and WordBoolToBool(QtyBreak);    {by customer and qty break }

    //PR: 14/02/2012 ABSEXCH-9795
    IsQtyBreak := EmptyKey(CustCode, AccLen) or ByCuQBreak;

    {* both customer and stock code should not be blank *}
    ValidCheck:=((Not EmptyKey(CustCode,AccLen)) or (Not EmptyKey(StockCode,StkLen)));
    GenSetError(ValidCheck,30001,TResult,ValidHed);

    {* Check the stock code and get the folio number *}
    If (Not EmptyKey(StockCode,StkLen)) then
    begin
      KeyS:=FullStockCode(StockCode);
      ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));
      GenSetError(ValidCheck,30002,TResult,ValidHed);
    end; {if..}

    If (TResult=0) then
    begin
      StockFolio := Stock.StockFolio;
      WantFirst := (SearchMode = B_GetFirst) or (SearchMode = B_StepFirst);
      WantLast  := (SearchMode = B_GetLast) or (SearchMode = B_StepLast);

      if WantFirst or WantLast then
      begin
        Move(ExDiscRec^, TempDiscRec, SizeOf(TempDiscRec));
        FillChar(ExDiscRec^, SizeOf(ExDiscRec^), #0);
        StockFolio := 0;
      end;

      //PR: 14/02/2012 ABSEXCH-9795
      if IsQtyBreak then
      begin
        FNum := QtyBreakF;
        KeyS := LJVar(CustCode, AccLen) + FullNomKey(StockFolio);
      end
      else
      begin
        FNum := MiscF;
        KeyS := CDDiscCode+CDDiscCode+MakeCDKey(CustCode,StockCode,SPCurrency)+HelpKStop;
      end;



      KeyS:= SetKeyString(SearchMode, FNum, KeyS);

      //PR 11/1/2001 - Added checks to make sure we only use correct discount records
      //PR: 14/02/2012 ABSEXCH-9795
      if not IsQtyBreak then
      begin
        KeyChk := Copy(KeyS, 1, 2); //gives us the Prefix & subtype for checking
        if WantLast then
          KeyS[2] := Succ(KeyS[2]);


        Case SearchMode of
          B_GetFirst,
          B_StepFirst  :  SearchMode := B_GetGEq;
          B_StepNext   :  SearchMode := B_GetNext;

          B_GetLast,
          B_StepLast   :  SearchMode := B_GetLessEq;
          B_StepPrev   :  SearchMode := B_GetPrev;
        end;
      end
      else
      begin
        Case SearchMode of
          B_StepFirst  :  SearchMode := B_GetFirst;
          B_StepNext   :  SearchMode := B_GetNext;

          B_StepLast   :  SearchMode := B_GetLast;
          B_StepPrev   :  SearchMode := B_GetPrev;
        end; //case
      end;


      UseVariant(F[FNum]);
      TResult:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);


      if WantFirst or WantLast then //Replace data
        Move(TempDiscRec, ExDiscRec^, SizeOf(TempDiscRec));


      If WordBoolToBool(Lock) and (TResult=0) then {* Attempt to lock record after we have found it *}
      {$IFDEF WIN32}
      begin
        UseVariant(F[FNum]);
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
          TResult:=0;
        // If not locked and user hits cancel return code 84
        if (TResult = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      TResult:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
      {$ENDIF}

      If (TResult=0) then
      begin
        {$B-}
        if IsQtyBreak or CheckDiscRec(KeyChk) then
             {ok to return record}
             DiscToExDisc(ExDiscRec^,ByCust,ByCuQBreak)
        else
          TResult := 9;
      end;

      KeyStrings[FNum] := KeyS;

      //If we're going forward or backwards through the discounts and we come to the end of the file
      //then we need to try moving to the other file.
      if (TResult = 9) then
      begin
        if not IsQtyBreak and (SearchMode = B_GetNext) then //change to QtyBreak file
        begin
          SearchMode := B_GetFirst;
          CustCode := LJVar('', AccLen);
          QtyBreak := BoolToWordBool(True);
          TResult := EX_GETDISCMATRIX(ExDiscRec, SizeOf(ExDiscRec^), SearchPath, SearchMode, Lock);
        end
        else
        if IsQtyBreak and (SearchMode = B_GetPrev) then //Change to MiscF
        begin
          SearchMode := B_GetLast;
          QtyBreak := BoolToWordBool(False);
          CustCode := 'ZZZZZZ';
          TResult := EX_GETDISCMATRIX(ExDiscRec, SizeOf(ExDiscRec^), SearchPath, SearchMode, Lock);
        end;
      end;
    end; {if Validcheck..}

    //PR: 16/02/2012 Keep a record of which file we used, so GetRecordAddress will use the correct file. ABSEXCH-9795
    if Result = 0 then
      CurrentDiscountFileNo := FNum;

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      TResult:=32766;

  If (TResult<>0) then
    LastErDesc:=Ex_ErrorDescription(8,TResult);

  Ex_GetDiscMatrix:=TResult;

end; {func..}

//PR: 16/02/2012 New function to delete new Qty Breaks records ABSEXCH-9795
function DeleteQtyBreakRec(RecPos : longint; SearchPath : integer) : SmallInt;
var
  KeyS               : Str255;
  LStatus            : SmallInt;
begin
  Result := 0;
  SetDataRecOfs(QtyBreakF, RecPos);
  UseVariant(F[QtyBreakF]);
  LStatus := GetDirect (F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, SearchPath, 0);
  if (LStatus = 0) Then
  begin
    Result := Delete_Rec(F[QtyBreakF], QtyBreakF, 0);
  end;

end;


{SS:15-12-2016:ABSEXCH-16381:Ex_DeleteDiscountMatrix won't delete quantity break header records.
 - DeleteQtyBreakLinks : Delete records from the QTYBREAK table using qbFolio.}
Procedure DeleteQtyBreakLinks(aKey : String; aIndex:Integer);
var  
  lStatus  : SmallInt;
  KeyLen  :  Integer;
  KeyS : Str255;
  
begin
  KeyS := aKey;
  KeyLen := Length(aKey);

  lStatus:=Find_Rec(B_GetGEq,F[QtyBreakF],QtyBreakF,RecPtr[QtyBreakF]^,aIndex,KeyS);

  while (lStatus=0) and CheckKey(aKey,KeyS,KeyLen,Boff)  do
  Begin

    Delete_Rec(F[QtyBreakF],QtyBreakF,aIndex);
    lStatus:=Find_Rec(B_GetNext,F[QtyBreakF],QtyBreakF,RecPtr[QtyBreakF]^,aIndex,KeyS);
    
  end;
end;

{* -------------------------------------------------------------------------- *}

// Delete a specified discount record using the record
// position to avoid problems with duplicate records
Function EX_DELETEDISCMATRIX (P          : Pointer;
                              PSize      : LongInt;
                              SearchPath : SmallInt;
                              RecPos     : LongInt) : SmallInt;
Const
  Fnum  =  MiscF;
  KPath =  MIK;
Var
  TKDiscRec, TestRec : ^TBatchDiscRec;
  KeyS               : Str255;
  LStatus            : SmallInt;
  ByCust, Locked     : Boolean;
Begin { Ex_DeleteDiscMatrix }
  Result := 32767;
  LastErDesc := '';

  TKDiscRec := P;

  If TestMode then
    ShowMessage ('Ex_DeleteDiscMatrix:' + #10#13 +
                 'P^.CustCode: ' + TKDiscRec^.CustCode + #10#13 +
                 'P^.StockCode: ' + TKDiscRec^.StockCode + #10#13 +
                 'PSize: ' + IntToStr(PSize) + #13#13 +
                 'RecPos: ' + IntToStr(RecPos));


  If Assigned(P) and (PSize = SizeOf (TBatchDiscRec)) Then
  Begin

    //PR: 16/02/2012 Check if QtyBreak - if so delete from new file. ABSEXCH-9795

    {SS:15-12-2016:ABSEXCH-16381:Ex_DeleteDiscountMatrix won't delete quantity break header records.
     - If deleting done from the customer or supplier discount then Qty break records should be deleted using DeleteQtyBreakLinks from the else part.}

    if WordBoolToBool(TKDiscRec.QtyBreak) and (Trim(TKDiscRec^.CustCode) = EmptyStr) then
      Result := DeleteQtyBreakRec(RecPos, SearchPath)                                     
    else
    begin

      New (TestRec);

      // Reload specified discount record using RecPos
      SetDataRecOfs(FNum, RecPos);
      UseVariant(F[FNum]);
      LStatus := GetDirect (F[FNum], FNum, RecPtr[FNum]^, KPath, 0);
      If (LStatus = 0) Then Begin
        // Got record - Check it is a valid discount record - don't want to accidentally delete
        // something else from MiscF!
        If ((MiscRecs^.RecMFix = CDDiscCode) And (MiscRecs^.SubType = TradeCode[True])) Or
           ((MiscRecs^.RecMFix = CDDiscCode) And (MiscRecs^.SubType = TradeCode[False])) Or
           ((MiscRecs^.RecMFix = QBDiscCode) And (MiscRecs^.SubType = QBDiscSub)) Or
           ((MiscRecs^.RecMFix = QBDiscCode) And (MiscRecs^.SubType = TradeCode[True])) Or
           ((MiscRecs^.RecMFix = QBDiscCode) And (MiscRecs^.SubType = TradeCode[False])) Then Begin
          // Convert to TK format and compare against record passed in as a precaution
          ByCust := ((MiscRecs^.RecMFix = CDDiscCode) And (MiscRecs^.SubType = TradeCode[True])) Or
                    ((MiscRecs^.RecMFix = CDDiscCode) And (MiscRecs^.SubType = TradeCode[False])) Or
                    ((MiscRecs^.RecMFix = QBDiscCode) And (MiscRecs^.SubType = TradeCode[True])) Or
                    ((MiscRecs^.RecMFix = QBDiscCode) And (MiscRecs^.SubType = TradeCode[False]));
          DiscToExDisc(TestRec^, ByCust, ByCust And (MiscRecs^.RecMFix = QBDiscCode));
          If CompareMem(TestRec, TKDiscRec, SizeOf(TBatchDiscRec)) Then Begin
            // Lock Discount record
            UseVariant(F[FNum]);
            If GetMultiRec(B_GetDirect,B_SingLock,KeyS,KPath,FNum,SilentLock,Locked) And Locked Then Begin
              // Delete it
              LStatus := Delete_Rec (F[FNum], FNum, SearchPath);
              If (LStatus = 0) Then Begin
                Result := 0;

                If ((MiscRecs^.RecMFix = CDDiscCode) And (MiscRecs^.SubType = TradeCode[True])) Or
                   ((MiscRecs^.RecMFix = CDDiscCode) And (MiscRecs^.SubType = TradeCode[False])) Then Begin
                  // Delete Cust/Supp Qty Break Details
                  If (LStatus = 0) Then
                  Begin
                    KeyS := TrimString(psRight, FullNomKey(MiscRecs^.CustDiscRec.QtyBreakFolio), #0);
                    {$IFDEF EXSQL}
                      {SS:15-12-2016:ABSEXCH-16381:Ex_DeleteDiscountMatrix won't delete quantity break header records.
                       - Deleting Qty break links records from QTYBREAK table for SQL Server.}
                      DeleteQtyBreakLinks(KeyS,1);
                    {$ENDIF}


                  End; { If (LStatus = 0) }
                End; { If TestRec^.QtyBreak }


                //PR: 28/20/2011
                if ByCust then
                  AuditNote.AddNote(anAccount, TestRec.CustCode, anEdit)
                else
                 AuditNote.AddNote(anAccount, Stock.StockFolio, anEdit);

              End { If (LStatus = 0) }
              Else
                // Btrieve Error deleting Discount Record
                Result := 22000 + LStatus
            End { If GetMultiRec... }
            Else
              // Error locking discount record
              Result := 20003;
          End { If (TestRec = TKDiscRec) }
          Else
            // Mismatch in record comparison
            Result := 20002;
        End { If }
        Else
          // Not a discount record
          Result := 20001;
      End { If (LStatus = 0) }
      Else
        // Btrieve Error reloading Discount record
        Result := 21000 + LStatus;

      Dispose (TestRec);
    end; //not Qty break
  End { If Assigned(P) and (PSize ... }
  Else
    If Assigned(P) then
      Result := 32766;

  If (Result <> 0) then
    LastErDesc := Ex_ErrorDescription(8, Result);
End; { Ex_DeleteDiscMatrix }

{* -------------------------------------------------------------------------- *}
{* ------ Testing for Customer Discount Matrix ------- *}

FUNCTION TESTDISCOUNT  :  SMALLINT;

Const
  Fnum  =  MiscF;
  KPath =  MIK;

Var
  ExStat  :  Integer;
  KeyS    :  String[255];

  AFile,
  Sfile,
  CFile   :  TextFile;

begin
  Assign(CFile,'d:\develop\entdll32\DiscCust.Txt');
  ReWrite(CFile);
  Result := 0;

  Assign(SFile,'d:\develop\entdll32\DiscStk.Txt');
  ReWrite(SFile);

  Assign(AFile,'d:\develop\entdll32\DiscAll.Txt');
  ReWrite(AFile);

  KeyS:='';
  UseVariant(F[FNum]);
  ExStat:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KPath,KeyS);
  While (ExStat=0) do
  With MiscRecs^ do
  begin

    Writeln(AFile,RecMFix,SubType);

    {* Customer *}
    If (RecMFix='C') and (SubType='C') then
    With CustDiscRec do
    begin
      Writeln(CFile, DiscCode,',',
                     QStkCode,',',
                     DCCode,',',
                     QBType,',',
                     QBCurr:2,',',
                     QSPrice:8:2,',',
                     QBand,',',
                     QDiscP:8:2,',',
                     QDiscA:8:2,',',
                     QMUMG:8:2);

    end; {if..}
    {* Stock *}
    If (RecMFix='D') and ((SubType='C') or (SubType='Q'))then
    With QtyDiscRec do
    begin
      Writeln(SFile, DiscQtyCode,',',
                     FQB:8:2,',',
                     TQB:8:2,',',
                     QBType,',',
                     QBCurr:2,',',
                     QSPrice:8:2,',',
                     QBand,',',
                     QDiscP:8:2,',',
                     QDiscA:8:2,',',
                     QMUMG:8:2,',',
                     QStkFolio:12,',',
                     QCCode);
    end; {if..}

    ExStat:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KPath,KeyS);
  end; {while..}

  CloseFile(CFile);
  CloseFile(SFile);
  CloseFile(AFile);

end; {func...}


{$ENDIF}  { WIN32 ...}

Initialization

  //PR: 16/02/2012 ABSEXCH-9795
  CurrentDiscountFileNo := 0;

end.

