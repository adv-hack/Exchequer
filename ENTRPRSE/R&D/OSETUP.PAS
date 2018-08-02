unit oSetup;
{$WARN SYMBOL_PLATFORM OFF}
interface

Uses Forms, SysUtils, GlobVar, VarConst, CustAbsU, CustTypU, oSystemSetup,Windows;

Type

//SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  ISecureString = interface
    function Data: WideString;
    function Length: Integer;
  end;

  TSecureString = class(TInterfacedObject, ISecureString)
  private
    FData: string;
  public
    constructor Create(const Value: WideString);
    destructor Destroy; override;
    function Data: WideString;
    function Length: Integer;
  end;


  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TVATInfo = Class(TAbsVATInfo)
  Private
    ThisVAT : VatType;
  Protected
    Function GetVatCode : Char; Override;
    Function GetVatDesc : cuStr10; Override;
    Function GetVatRate : Real; Override;
    Function GetVatInclude : Boolean; Override;
  Public
    Constructor Create (Const VATIdx : VATType);
  End; { TVATInfo }

  { Abstract System Setup VAT Interface - used by TAbsSetup }
  TCcyInfo = Class(TAbsCcyInfo)
  Private
    ThisCcy : cuCurrencyType;
  Protected
    Function GetSymbol : cuStr3; Override;
    Function GetDesc : cuStr11; Override;
    Function GetCompanyRate : Real; Override;
    Function GetDailyRate : Real; Override;
    Function GetPrintSymbol : cuStr3; Override;

    Function GetTriRate : Double; Override;
    Function GetTriEuroCcy : Byte; Override;
    Function GetTriInvert : Boolean; Override;
    Function GetTriFloating : Boolean; Override;
  Public
    Constructor Create (Const CcyIdx : cuCurrencyType);
  End; { TCcyInfo }

  { Abstract System Setup - Used TAbsSetup }
  TUserFields = Class(TAbsUserFields2)
  Protected
    // TAbsUserFields
    Function GetUserFieldName(Index : Integer) : cuStr15; Override;
    Function GetUserFieldEnabled(Index : Integer) : Boolean; Override;
    function GetFieldDesc (FieldNo: cuCustFieldIndex; Index: Integer): cuStr15; Override;
    function GetFieldEnabled (FieldNo: cuCustFieldIndex; Index: Integer): Boolean; Override;

    // TAbsUserFields2
    function GetFieldDesc10 (FieldNo: Integer; Index: Integer): ShortString; Override;
    function GetFieldEnabled10 (FieldNo: Integer; Index: Integer): Boolean; Override;
  End; { TAbsUserFields }

  TPaperlessSetup = Class(TAbsPaperlessSetup2)
  Protected
    Function GetYourEmailName : cuStr255; Override;
    Function GetYourEmailAddress : cuStr255; Override;
    Function GetSMTPServer : cuStr255; Override;
    Function GetDefaultEmailPriority : Byte; Override;
    Function GetEmailUseMAPI : Boolean; Override;
    Function GetAttachMethod : Byte; Override;
    Function GetAttachPrinter : cuStr20; Override;
    Function GetFaxFromName : cuStr40; Override;
    Function GetFaxFromTelNo : cuStr25; Override;
    Function GetFaxPrinter : cuStr20; Override;
    Function GetFaxInterfacePath : cuStr60; Override;
    Function GetFaxUsing : Byte; Override;

    // TAbsPaperlessSetup2
    Function GetAttachPrinter50 : cuStr50; Override;
    Function GetFaxPrinter50 : cuStr50; Override;
  End; { TPaperlessSetup }

  TGDPR = Class(TAbsSetupGDPR)
  Protected
    Function  GetAnonymised: Boolean; Override;
    Function  GetAnonymisedDate: cuStr8; Override;
    Function  GetAnonymisedTime: cuStr6; Override;
    Function  GetGDPRTraderRetentionPeriod: Integer; Override;
    Function  GetGDPRTraderDisplayPIITree: Boolean; Override;
    Function  GetGDPRTraderAnonNotesOption: Integer; Override;
    Function  GetGDPRTraderAnonLettersOption: Integer; Override;
    Function  GetGDPRTraderAnonLinksOption: Integer; Override;
    Function  GetGDPREmployeeRetentionPeriod: Integer; Override;
    Function  GetGDPREmployeeDisplayPIITree: Boolean; Override;
    Function  GetGDPREmployeeAnonNotesOption: Integer; Override;
    Function  GetGDPREmployeeAnonLettersOption: Integer; Override;
    Function  GetGDPREmployeeAnonLinksOption: Integer; Override;
    Function  GetNotificationWarningColour: Integer; Override;
    Function  GetNotificationWarningFontColour: Integer; Override;
    Function  GetGDPRCompanyAnonLocations: Boolean; Override;
    Function  GetGDPRCompanyAnonCostCentres: Boolean; Override;
    Function  GetGDPRCompanyAnonDepartment: Boolean; Override;
    Function  GetGDPRCompanyNotesOption: Integer; Override;
    Function  GetGDPRCompanyLettersOption: Integer; Override;
    Function  GetGDPRCompanyLinksOption: Integer; Override;
  End;
        
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  TSetup = Class(TAbsSetup15)
  Private
    RecAccess  : TRecAccessStatus;

    {EntSys    : TEnterpriseSystem;}

    CurrArray : Array[cuCurrencyType] Of TCcyInfo;
    VatArray  : Array[cuVATIndex] Of TVATInfo;

    FUserFields : TUserFields;
    FPaperless : TPaperlessSetup;
    FCISSetup : TAbsCISSetup;
    FJobCosting : TAbsJobCostingSetup;
    FGDPR : TAbsSetupGDPR;
  Protected
    Function  GetPrinYr : Byte; Override;
    Function  GetUserName : cuStr45; Override;
    Function  GetAuditYr : Byte; Override;
    Function  GetManROCP : Boolean; Override;
    Function  GetVATCurr : Byte; Override;
    Function  GetNoCosDec : Byte; Override;
    Function  GetCurrBase : Byte; Override;
    Function  GetShowStkGP : Boolean; Override;
    Function  GetAutoValStk : Boolean; Override;
    Function  GetDelPickOnly : Boolean; Override;
    Function  GetUseMLoc : Boolean; Override;
    Function  GetEditSinSer : Boolean; Override;
    Function  GetWarnYRef : Boolean; Override;
    Function  GetUseLocDel : Boolean; Override;
    Function  GetPostCCGL : Boolean; Override;
    Function  GetAlTolVal : Double; Override;
    Function  GetAlTolMode : Byte; Override;
    Function  GetDebtLMode : Byte; Override;
    Function  GetAutoGenVar : Boolean; Override;
    Function  GetAutoGenDisc : Boolean; Override;
    Function  GetUSRCntryCode : cuStr3; Override;
    Function  GetNoNetDec : Byte; Override;
    Function  GetDebTrig (Index : cuDebtChaseIndex) : Byte; Override;
    Function  GetNoInvLines : Byte; Override;
    Function  GetWksODue : Byte; Override;
    Function  GetCPr : Byte; Override;
    Function  GetCYr : Byte; Override;
    Function  GetTradeTerm : Boolean; Override;
    Function  GetStaSepCr : Boolean; Override;
    Function  GetStaAgeMthd : Byte; Override;
    Function  GetStaUIDate : Boolean; Override;
    Function  GetQUAllocFlg : Boolean; Override;
    Function  GetDeadBOM : Boolean; Override;
    Function  GetAuthMode : Char; Override;
    Function  GetIntraStat : Boolean; Override;
    Function  GetAnalStkDesc : Boolean; Override;
    Function  GetAutoStkVal : Char; Override;
    Function  GetAutoBillUp : Boolean; Override;
    Function  GetAutoCQNo : Boolean; Override;
    Function  GetIncNotDue : Boolean; Override;
    Function  GetUseBatchTot : Boolean; Override;
    Function  GetUseStock : Boolean; Override;
    Function  GetAutoNotes : Boolean; Override;
    Function  GetHideMenuOpt : Boolean; Override;
    Function  GetUseCCDep : Boolean; Override;
    Function  GetNoHoldDisc : Boolean; Override;
    Function  GetAutoPrCalc : Boolean; Override;
    Function  GetStopBadDr : Boolean; Override;
    Function  GetUsePayIn : Boolean; Override;
    Function  GetUsePasswords : Boolean; Override;
    Function  GetPrintReciept : Boolean; Override;
    Function  GetExternCust : Boolean; Override;
    Function  GetNoQtyDec : Byte; Override;
    Function  GetExternSIN : Boolean; Override;
    Function  GetPrevPrOff : Boolean; Override;
    Function  GetDefPcDisc : Boolean; Override;
    Function  GetTradCodeNum : Boolean; Override;
    Function  GetUpBalOnPost : Boolean; Override;
    Function  GetShowInvDisc : Boolean; Override;
    Function  GetSepDiscounts : Boolean; Override;
    Function  GetUseCreditChk : Boolean; Override;
    Function  GetUseCRLimitChk : Boolean; Override;
    Function  GetAutoClearPay : Boolean; Override;
    Function  GetTotalConv : Char; Override;
    Function  GetDispPrAsMonths : Boolean; Override;
    Function  GetNomCtrlCodes (Index : cuNomCtrlType) : LongInt; Override;
    Function  GetDetailAddr (Index : cuAddrIndex) : cuStr30; Override;
    Function  GetDirectCust : cuStr10; Override;
    Function  GetDirectSupp : cuStr10; Override;
    Function  GetTermsofTrade (Index : cuTermsIndex) : cuStr80; Override;
    Function  GetNomPayFrom : LongInt; Override;
    Function  GetNomPayToo : LongInt; Override;
    Function  GetSettleDisc : Real; Override;
    Function  GetSettleDays : SmallInt; Override;
    Function  GetNeedBMUp : Boolean; Override;
    Function  GetInpPack : Boolean; Override;
    Function  GetVATCode : Char; Override;
    Function  GetPayTerms : SmallInt; Override;
    Function  GetStaAgeInt : SmallInt; Override;
    Function  GetQuoOwnDate : Boolean; Override;
    Function  GetFreeExAll : Boolean; Override;
    Function  GetDirOwnCount : Boolean; Override;
    Function  GetStaShowOS : Boolean; Override;
    Function  GetLiveCredS : Boolean; Override;
    Function  GetBatchPPY : Boolean; Override;
    Function  GetWarnJC : Boolean; Override;
    Function  GetDefBanknom : LongInt; Override;
    Function  GetUseDefBank : Boolean; Override;
    Function  GetMonWk1 : cuLongDate; Override;
    Function  GetAuditDate : cuLongDate; Override;
    Function  GetUserSort : cuStr6; Override;
    Function  GetUserAcc : cuStr8; Override;
    Function  GetUserRef : cuStr18; Override;
    Function  GetUserBank : cuStr25; Override;
    Function  GetLastExpFolio : LongInt; Override;
    Function  GetDetailTel : cuStr15; Override;
    Function  GetDetailFax : cuStr15; Override;
    Function  GetUserVATReg : cuStr30; Override;
    Function  GetDataPath : ShortString; Override;
    Function  GetWORAllocStockOnPick : Boolean; Override;
    Function  GetWOPDisableWIP : Boolean; Override;
    Function  GetWORCopyStkNotes : Byte; Override;

    Function  GetCurrencyObj(Index : cuCurrencyType) : TAbsCcyInfo; Override;
    Function  GetVatRateObj(Index : cuVATIndex) : TAbsVATInfo; Override;
    Function  GetUserFields : TAbsUserFields; OverRide;
    Function  GetPaperless : TAbsPaperlessSetup; OverRide;

    // TAbsSetup2
    Function GetCISSetup : TAbsCISSetup; OverRide;
    Function GetJobCosting : TAbsJobCostingSetup; OverRide;

    // TAbsSetup3
    Function GetFilterSNoByBinLoc : Boolean; OverRide;
    Function GetKeepBinHistory : Boolean; OverRide;
    Function GetBinMask : cuStr10; OverRide;

    // TAbsSetup4  
    //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    Function GetConnectInfo : WideString; OverRide;

    // TAbsSetup5
    Function GetUseTTD : Boolean; OverRide;
    Function GetUseVBD : Boolean; OverRide;

    // v6.2 - 20/08/09 - Added new fields for EC Services support
    Function GetEnableECServices : Boolean; OverRide;
    Function GetECSalesThreshold : Double; OverRide;

    // v6.3 18/01/10: TAbsSetup7
    Function GetCompanyCode : ShortString; OverRide;

    // TAbsSetup8 - v6.5 - 12/10/10 - Added Enable Override Location on Purchases flag
    Function GetEnableOverrideLocation : Boolean; OverRide;

    // TAbsSetup9 - v6.9 - 28/10/2011 - Added support for extended Custom Fields object
    Function GetUserFields2 : TAbsUserFields2; OverRide;

    //PR: 26/07/2013 Added SEPA bank fields   TAbsSetup10
    Function GetBankAccountCode : cuStr35; Override;
    Function GetBankSortCode : cuStr11; Override;

    // MH 30/09/2013 MRD Branch for v7.0.8: Added new fields for Consumer Ledger and Auto-Receipt
    Function GetConsumersEnabled : Boolean; Override;

    // MH 22/09/2014 Order Payments
    Function GetOrderPaymentsEnabled : Boolean; Override;

    //AP 04/12/2017 2018R1 ABSEXCH-19401: GDPR (POST 19344) - 8.3.1.1.3 - DLL + COM Customisation Support
    Function GetGDPR : TAbsSetupGDPR; OverRide;
	
    //AP 01/02/2018 ABSEXCH-19455: Currency Import Tolerance support
    Function GetCurrencyImportTolerance : Real; OverRide;
	
	//SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    function GetConnectionPassword: WideString; override;
    function GetConnectionString: WideString; override;
  Public
    Constructor Create; {(hEntSys : TEnterpriseSystem);}
    Destructor  Destroy; Override;

  Published

  End; { TAbsSetup }
  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  function NewSecureString(const S: WideString): ISecureString;


implementation

Uses
    Math,
    SysU1,
    oSetupJC,
    {$IFDEF EXSQL}
    SQLUtils,
    {$ENDIF}
    EntLicence,
    CustIntU,
    CustomFieldsVar,
    CustomFieldsIntf,

  //PR: 26/07/2013 Changed to use new SEPA code field
    EncryptionUtils;



Const
  SetupErrStr = 'System Setup ';

Constructor TVatInfo.Create (Const VATIdx : VATType);
Begin
  Inherited Create;

  ThisVAT := VATIdx;
End;

Function TVatInfo.GetVatCode : Char;
Begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Code;
End;

Function TVatInfo.GetVatDesc : cuStr10;
Begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Desc;
End;

Function TVatInfo.GetVatRate : Real;
Begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Rate;
End;

Function TVatInfo.GetVatInclude : Boolean;
Begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Include;
End;

{-----------------------------------------------------------------------------}

Constructor TCcyInfo.Create (Const CcyIdx : cuCurrencyType);
Begin
  Inherited Create;

  ThisCcy := CcyIdx;
End;

Function TCcyInfo.GetSymbol : cuStr3;
Begin
  Result := SyssCurr.Currencies[ThisCcy].SSymb;
End;

Function TCcyInfo.GetDesc : cuStr11;
Begin
  Result := SyssCurr.Currencies[ThisCcy].Desc;
End;

Function TCcyInfo.GetCompanyRate : Real;
Begin
  Result := SyssCurr.Currencies[ThisCcy].CRates[False];
End;

Function TCcyInfo.GetDailyRate : Real;
Begin
  Result := SyssCurr.Currencies[ThisCcy].CRates[True];
End;

Function TCcyInfo.GetPrintSymbol : cuStr3;
Begin
  Result := SyssCurr.Currencies[ThisCcy].PSymb;
End;

Function TCcyInfo.GetTriRate : Double;
Begin
  Result := SyssGCur^.GhostRates.TriRates[ThisCcy];
End;

Function TCcyInfo.GetTriEuroCcy : Byte;
Begin
  Result := SyssGCur^.GhostRates.TriEuro[ThisCcy];
End;

Function TCcyInfo.GetTriInvert : Boolean;
Begin
  Result := SyssGCur^.GhostRates.TriInvert[ThisCcy];
End;

Function TCcyInfo.GetTriFloating : Boolean;
Begin
  Result := SyssGCur^.GhostRates.TriFloat[ThisCcy];
End;

{-----------------------------------------------------------------------------}

Function TUserFields.GetUserFieldName(Index : Integer) : cuStr15;
var
  newIndex, category : longint;
Begin
 // Result := SyssVAT.VATRates.UDFCaption[Index];
 newIndex := CustomFields.GetNewFieldIndex('VAT', index);
 //category := Trunc(newIndex / 1000);
 //result := CustomFields[category,index].cfDescription;
 result := CustomFields[newIndex Div 1000, newIndex Mod 1000].cfCaption;
End;

Function TUserFields.GetUserFieldEnabled(Index : Integer) : Boolean;
Begin
  //SIN header/lines
  Case Index Of
      1 : Result := CustomFields[cfSINHeader, 1].cfEnabled;
      2 : Result := CustomFields[cfSINHeader, 2].cfEnabled;
      3 : Result := CustomFields[cfSINHeader, 3].cfEnabled;
      4 : Result := CustomFields[cfSINHeader, 4].cfEnabled;
      5 : Result := CustomFields[cfSINLine, 1].cfEnabled;
      6 : Result := CustomFields[cfSINLine, 2].cfEnabled;
      7 : Result := CustomFields[cfSINLine, 3].cfEnabled;
      8 : Result := CustomFields[cfSINLine, 4].cfEnabled;
  Else
      Result := False;
  End;
End;

function TUserFields.GetFieldDesc (fieldNo: cuCustFieldIndex; index: Integer): cuStr15;
begin
  Case index Of
    // Line Type Desc
    3  : result := CustomFields[cfLinetypes,fieldNo].cfCaption;
    // Employee Desc
    28 : result := CustomFields[cfEmployee,fieldNo].cfCaption;
  Else
    result := GetFieldDesc10 (FieldNo, Index);
  End; { Case }
end;

function TUserFields.GetFieldEnabled (FieldNo: cuCustFieldIndex; Index: Integer): Boolean;
begin
  Result := GetFieldEnabled10 (FieldNo, Index);
end;

//------------------------------

function TUserFields.GetFieldDesc10 (FieldNo: Integer; Index: Integer): ShortString;
Begin // GetFieldDesc10
  Result := '';
  //If (FieldNo >= 1) And (FieldNo <= 10) Then
  If (FieldNo >= 1)
     And
     (
       ((Not (Index In [1, 2, 45])) And (FieldNo <= 10))
       Or
       // MH 02/01/2015 v7.1 ABSEXCH-15949: Extended to support Customer/Supplier Credit Card Fields (11-15)
       ((Index In [1, 2]) And (FieldNo <= 15))
       Or
       // MH 02/01/2015 v7.1 ABSEXCH-15855: Added Address Description Fields (1-5)
       ((Index = 45) And (FieldNo <= 5))
       // MH 03/06/2016 2016-R2 ABSEXCH-17579: Added two new UDef Fields to TH for eRCT
       Or
       ((Index In [4, 6, 8, 10, 12, 14, 16, 18, 20, 23, 25, 29, 31, 33, 35, 37, 39, 41, 43]) And (FieldNo <= 12))
     ) Then
  Begin
    Case Index Of
      1  : Result := CustomFields[cfCustomer, FieldNo].cfCaption;
      2  : Result := CustomFields[cfSupplier, FieldNo].cfCaption;
      // 3: Line Types limited to 4
      4  : Result := CustomFields[cfSINHeader, FieldNo].cfCaption;
      5  : Result := CustomFields[cfSINLine, FieldNo].cfCaption;
      6  : Result := CustomFields[cfSRCHeader, FieldNo].cfCaption;
      7  : Result := CustomFields[cfSRCLine, FieldNo].cfCaption;
      8  : Result := CustomFields[cfSQUHeader, FieldNo].cfCaption;
      9  : Result := CustomFields[cfSQULine, FieldNo].cfCaption;
      10 : Result := CustomFields[cfSORHeader, FieldNo].cfCaption;
      11 : Result := CustomFields[cfSORLine, FieldNo].cfCaption;
      12 : Result := CustomFields[cfPINHeader, FieldNo].cfCaption;
      13 : Result := CustomFields[cfPINLine, FieldNo].cfCaption;
      14 : Result := CustomFields[cfPPYHeader, FieldNo].cfCaption;
      15 : Result := CustomFields[cfPPYLine, FieldNo].cfCaption;
      16 : Result := CustomFields[cfPQUHeader, FieldNo].cfCaption;
      17 : Result := CustomFields[cfPQULine, FieldNo].cfCaption;
      18 : Result := CustomFields[cfPORHeader, FieldNo].cfCaption;
      19 : Result := CustomFields[cfPORLine, FieldNo].cfCaption;
      20 : Result := CustomFields[cfNOMHeader, FieldNo].cfCaption;
      21 : Result := CustomFields[cfNOMLine, FieldNo].cfCaption;
      22 : Result := CustomFields[cfStock, FieldNo].cfCaption;
      23 : Result := CustomFields[cfADJHeader, FieldNo].cfCaption;
      24 : Result := CustomFields[cfADJLine, FieldNo].cfCaption;
      25 : Result := CustomFields[cfWORHeader, FieldNo].cfCaption;
      26 : Result := CustomFields[cfWORLine, FieldNo].cfCaption;
      27 : Result := CustomFields[cfJob, FieldNo].cfCaption;
      // 28 : Employees not extended
      29 : Result := CustomFields[cfTSHHeader, FieldNo].cfCaption;
      30 : Result := CustomFields[cfTSHLine, FieldNo].cfCaption;
      // MH 23/11/2011 v6.9 ABSEXCH-12195: Added SRN/PRN Custom Fields Settings
      31 : Result := CustomFields[cfSRNHeader, FieldNo].cfCaption;
      32 : Result := CustomFields[cfSRNLine, FieldNo].cfCaption;
      33 : Result := CustomFields[cfPRNHeader, FieldNo].cfCaption;
      34 : Result := CustomFields[cfPRNLine, FieldNo].cfCaption;
      // MH 09/03/2012 v6.10 ABSEXCH-12128: Added Apps and Vals Custom Fields Settings
      35 : Result := CustomFields[cfJCTHeader, FieldNo].cfCaption;
      36 : Result := CustomFields[cfJCTLine, FieldNo].cfCaption;
      37 : Result := CustomFields[cfJPTHeader, FieldNo].cfCaption;
      38 : Result := CustomFields[cfJPTLine, FieldNo].cfCaption;
      39 : Result := CustomFields[cfJSTHeader, FieldNo].cfCaption;
      40 : Result := CustomFields[cfJSTLine, FieldNo].cfCaption;
      41 : Result := CustomFields[cfJPAHeader, FieldNo].cfCaption;
      42 : Result := CustomFields[cfJPALine, FieldNo].cfCaption;
      43 : Result := CustomFields[cfJSAHeader, FieldNo].cfCaption;
      44 : Result := CustomFields[cfJSALine, FieldNo].cfCaption;
      // MH 02/01/2015 v7.1 ABSEXCH-15855: Added Address Description Fields
      45 : Result := CustomFields[cfAddressLabels, FieldNo].cfCaption;
    End; // Case Index
  End; // If (FieldNo >= 1) And (...
End; // GetFieldDesc10

//------------------------------

function TUserFields.GetFieldEnabled10 (FieldNo: Integer; Index: Integer): Boolean;
Begin // GetFieldEnabled10
  Result := False;
  // MH 02/01/2015 v7.1 ABSEXCH-15949: Extended to support Customer/Supplier Credit Card Fields (11-15)
  //If (FieldNo >= 1) And (FieldNo <= IfThen(Index = 25, 4, 10)) Then

     // Line Types - 1-4
  If ((Index = 25) And (FieldNo >= 1) And (FieldNo <= 4))
     Or
     // Customer/Supplier UDefs - 11-15
     ((Index In [40, 41]) And (FieldNo >= 11) And (FieldNo <= 15))
     Or
     // Everything Else - 1-10
     ((Not (Index In [25, 40, 41])) And (FieldNo >= 1) And (FieldNo <= 10))
     // MH 03/06/2016 2016-R2 ABSEXCH-17579: Added two new UDef Fields to TH for eRCT
     Or
     ((Index In [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 26, 28, 30, 32, 34, 36, 38]) And (FieldNo <= 12)) Then
  Begin
    Case Index Of                      
      1  : Result := CustomFields[cfSINHeader, FieldNo].cfEnabled;
      2  : Result := CustomFields[cfSINLine, FieldNo].cfEnabled;
      3  : Result := CustomFields[cfSRCHeader, FieldNo].cfEnabled;
      4  : Result := CustomFields[cfSRCLine, FieldNo].cfEnabled;
      5  : Result := CustomFields[cfSQUHeader, FieldNo].cfEnabled;
      6  : Result := CustomFields[cfSQULine, FieldNo].cfEnabled;
      7  : Result := CustomFields[cfSORHeader, FieldNo].cfEnabled;
      8  : Result := CustomFields[cfSORLine, FieldNo].cfEnabled;
      9  : Result := CustomFields[cfPINHeader, FieldNo].cfEnabled;
      10 : Result := CustomFields[cfPINLine, FieldNo].cfEnabled;
      11 : Result := CustomFields[cfPRCHeader, FieldNo].cfEnabled;
      12 : Result := CustomFields[cfPRCLine, FieldNo].cfEnabled;
      13 : Result := CustomFields[cfPQUHeader, FieldNo].cfEnabled;
      14 : Result := CustomFields[cfPQULine, FieldNo].cfEnabled;
      15 : Result := CustomFields[cfPORHeader, FieldNo].cfEnabled;
      16 : Result := CustomFields[cfPORLine, FieldNo].cfEnabled;
      17 : Result := CustomFields[cfNOMHeader, FieldNo].cfEnabled;
      18 : Result := CustomFields[cfNOMLine, FieldNo].cfEnabled;
      19 : Result := CustomFields[cfADJHeader, FieldNo].cfEnabled;
      20 : Result := CustomFields[cfADJLine, FieldNo].cfEnabled;
      21 : Result := CustomFields[cfWORHeader, FieldNo].cfEnabled;
      22 : Result := CustomFields[cfWORLine, FieldNo].cfEnabled;
      23 : Result := CustomFields[cfTSHHeader, FieldNo].cfEnabled;
      24 : Result := CustomFields[cfTSHLine, FieldNo].cfEnabled;
      25 : Result := CustomFields[cfLinetypes, FieldNo].cfEnabled;  // Only 4 line types
      // MH 23/11/2011 v6.9 ABSEXCH-12195: Added SRN/PRN Custom Fields Settings
      26 : Result := CustomFields[cfSRNHeader, FieldNo].cfEnabled;
      27 : Result := CustomFields[cfSRNLine, FieldNo].cfEnabled;
      28 : Result := CustomFields[cfPRNHeader, FieldNo].cfEnabled;
      29 : Result := CustomFields[cfPRNLine, FieldNo].cfEnabled;
      // MH 09/03/2012 v6.10 ABSEXCH-12128: Added Apps and Vals Custom Fields Settings
      30 : Result := CustomFields[cfJCTHeader, FieldNo].cfEnabled;
      31 : Result := CustomFields[cfJCTLine, FieldNo].cfEnabled;
      32 : Result := CustomFields[cfJPTHeader, FieldNo].cfEnabled;
      33 : Result := CustomFields[cfJPTLine, FieldNo].cfEnabled;
      34 : Result := CustomFields[cfJSTHeader, FieldNo].cfEnabled;
      35 : Result := CustomFields[cfJSTLine, FieldNo].cfEnabled;
      36 : Result := CustomFields[cfJPAHeader, FieldNo].cfEnabled;
      37 : Result := CustomFields[cfJPALine, FieldNo].cfEnabled;
      38 : Result := CustomFields[cfJSAHeader, FieldNo].cfEnabled;
      39 : Result := CustomFields[cfJSALine, FieldNo].cfEnabled;
      // MH 02/01/2015 v7.1 ABSEXCH-15949: Extended to support Customer/Supplier Credit Card Fields (11-15)
      40 : Result := CustomFields[cfCustomer, FieldNo].cfEnabled;
      41 : Result := CustomFields[cfSupplier, FieldNo].cfEnabled;
    End; // Case Index
  End; // If (FieldNo >= 1) And (FieldNo <= 10)
End; // GetFieldEnabled10

//=========================================================================

Constructor TSetup.Create;
Var
  I     : cuVATIndex;
  Ccy_I : cuCurrencyType;
Begin
  Inherited Create;

  { Create Currency Objects }
  For Ccy_I := Low(cuCurrencyType) To High(cuCurrencyType) Do
    CurrArray[Ccy_I] := TCcyInfo.Create (cuCurrencyType(Ccy_I));

  { Create VAT Objects }
  For I := Low(cuVATIndex) To High(cuVATIndex) Do
    VatArray[I] := TVATInfo.Create (VATType(I));

  { Create User fields sub-object when and if necessary }
  FUserFields := Nil;
  FPaperless := NIL;
  FCISSetup := NIL;
  FJobCosting := NIL;
  FGDPR := NIL;

  RecAccess := ReadOnly;
End;

Destructor TSetup.Destroy;
Var
  I : cuVATIndex;
  Ccy_I : cuCurrencyType;
Begin
  For I := Low(cuVATIndex) To High(cuVATIndex) Do
    VatArray[I].Destroy;

  { Free Currency Objects }
  For Ccy_I := Low(cuCurrencyType) To High(cuCurrencyType) Do
    CurrArray[Ccy_I].Destroy;

  If Assigned(FUserFields) Then
    FUserFields.Destroy;

  If Assigned(FPaperless) Then
    FPaperless.Destroy;

  If Assigned(FCISSetup) Then
    FCISSetup.Destroy;

  If Assigned(FJobCosting) Then
    FJobCosting.Destroy;

  If Assigned(FGDPR) Then
    FGDPR.Destroy;

  Inherited Destroy;
End;

Function TSetup.GetVatRateObj(Index : cuVATIndex) : TAbsVATInfo;
Begin
  Result := VatArray[Index];
End;

Function TSetup.GetCurrencyObj(Index : cuCurrencyType) : TAbsCcyInfo;
Begin
  {$IFDEF MC_On}
    Result := CurrArray[Index];
  {$ELSE}
    Result := Nil;
    Raise EVersionError.Create ('Version Error - An error occured attempting to access the currency table');
  {$ENDIF}
End;

Function TSetup.GetPrinYr : Byte;
Begin
  Result := Syss.PrinYr
End;

Function TSetup.GetUserName : cuStr45;
Begin
  Result := Syss.UserName
End;

Function TSetup.GetAuditYr : Byte;
Begin
  Result := Syss.AuditYr
End;

Function TSetup.GetManROCP : Boolean;
Begin
  Result := Syss.ManROCP
End;

Function TSetup.GetVATCurr : Byte;
Begin
  Result := Syss.VATCurr
End;

Function TSetup.GetNoCosDec : Byte;
Begin
  Result := Syss.NoCosDec
End;

Function TSetup.GetCurrBase : Byte;
Begin
  Result := Syss.CurrBase
End;

Function TSetup.GetShowStkGP : Boolean;
Begin
  Result := Syss.ShowStkGP
End;

Function TSetup.GetAutoValStk : Boolean;
Begin
  Result := Syss.AutoValStk
End;

Function TSetup.GetDelPickOnly : Boolean;
Begin
  Result := Syss.DelPickOnly
End;

Function TSetup.GetUseMLoc : Boolean;
Begin
  Result := Syss.UseMLoc
End;

Function TSetup.GetEditSinSer : Boolean;
Begin
  Result := Syss.EditSinSer
End;

Function TSetup.GetWarnYRef : Boolean;
Begin
  Result := Syss.WarnYRef
End;

Function TSetup.GetUseLocDel : Boolean;
Begin
  Result := Syss.UseLocDel
End;

Function TSetup.GetPostCCGL : Boolean;
Begin
  Result := Syss.PostCCNom
End;

Function TSetup.GetAlTolVal : Double;
Begin
  Result := Syss.AlTolVal
End;

Function TSetup.GetAlTolMode : Byte;
Begin
  Result := Syss.AlTolMode
End;

Function TSetup.GetDebtLMode : Byte;
Begin
  Result := Syss.DebtLMode
End;

Function TSetup.GetAutoGenVar : Boolean;
Begin
  Result := Syss.AutoGenVar
End;

Function TSetup.GetAutoGenDisc : Boolean;
Begin
  Result := Syss.AutoGenDisc
End;

Function TSetup.GetUSRCntryCode : cuStr3;
Begin
  Result := Syss.USRCntryCode
End;

Function TSetup.GetNoNetDec : Byte;
Begin
  Result := Syss.NoNetDec
End;

Function TSetup.GetDebTrig (Index : cuDebtChaseIndex) : Byte;
Begin
  Result := Syss.DebTrig[Index]
End;

Function TSetup.GetNoInvLines : Byte;
Begin
  Result := Syss.NoInvLines
End;

Function TSetup.GetWksODue : Byte;
Begin
  Result := Syss.WksODue
End;

Function TSetup.GetCPr : Byte;
Begin
  Result := GetLocalPr(0).CPr
End;

Function TSetup.GetCYr : Byte;
Begin
  Result := GetLocalPr(0).CYr
End;

Function TSetup.GetTradeTerm : Boolean;
Begin
  Result := Syss.TradeTerm
End;

Function TSetup.GetStaSepCr : Boolean;
Begin
  Result := Syss.StaSepCr
End;

Function TSetup.GetStaAgeMthd : Byte;
Begin
  Result := Syss.StaAgeMthd
End;

Function TSetup.GetStaUIDate : Boolean;
Begin
  Result := Syss.StaUIDate
End;

Function TSetup.GetQUAllocFlg : Boolean;
Begin
  Result := Syss.QUAllocFlg
End;

Function TSetup.GetDeadBOM : Boolean;
Begin
  Result := Syss.DeadBOM
End;

Function TSetup.GetAuthMode : Char;
Begin
  Result := Syss.AuthMode
End;

Function TSetup.GetIntraStat : Boolean;
Begin
  Result := Syss.IntraStat
End;

Function TSetup.GetAnalStkDesc : Boolean;
Begin
  Result := Syss.AnalStkDesc
End;

Function TSetup.GetAutoStkVal : Char;
Begin
  Result := Syss.AutoStkVal
End;

Function TSetup.GetAutoBillUp : Boolean;
Begin
  Result := Syss.AutoBillUp
End;

Function TSetup.GetAutoCQNo : Boolean;
Begin
  Result := Syss.AutoCQNo
End;

Function TSetup.GetIncNotDue : Boolean;
Begin
  Result := Syss.IncNotDue
End;

Function TSetup.GetUseBatchTot : Boolean;
Begin
  Result := Syss.UseBatchTot
End;

Function TSetup.GetUseStock : Boolean;
Begin
  Result := Syss.UseStock
End;

Function TSetup.GetAutoNotes : Boolean;
Begin
  Result := Syss.AutoNotes
End;

Function TSetup.GetHideMenuOpt : Boolean;
Begin
  Result := Syss.HideMenuOpt
End;

Function TSetup.GetUseCCDep : Boolean;
Begin
  Result := Syss.UseCCDep
End;

Function TSetup.GetNoHoldDisc : Boolean;
Begin
  Result := Syss.NoHoldDisc
End;

Function TSetup.GetAutoPrCalc : Boolean;
Begin
  Result := Syss.AutoPrCalc
End;

Function TSetup.GetStopBadDr : Boolean;
Begin
  Result := Syss.StopBadDr
End;

Function TSetup.GetUsePayIn : Boolean;
Begin
  Result := Syss.UsePayIn
End;

Function TSetup.GetUsePasswords : Boolean;
Begin
  Result := Syss.UsePasswords
End;

Function TSetup.GetPrintReciept : Boolean;
Begin
  Result := Syss.PrintReciept
End;

Function TSetup.GetExternCust : Boolean;
Begin
  Result := Syss.ExternCust
End;

Function TSetup.GetNoQtyDec : Byte;
Begin
  Result := Syss.NoQtyDec
End;

Function TSetup.GetExternSIN : Boolean;
Begin
  Result := Syss.ExternSIN
End;

Function TSetup.GetPrevPrOff : Boolean;
Begin
  Result := Syss.PrevPrOff
End;

Function TSetup.GetDefPcDisc : Boolean;
Begin
  Result := Syss.DefPcDisc
End;

Function TSetup.GetTradCodeNum : Boolean;
Begin
  Result := Syss.TradCodeNum
End;

Function TSetup.GetUpBalOnPost : Boolean;
Begin
  Result := Syss.UpBalOnPost
End;

Function TSetup.GetShowInvDisc : Boolean;
Begin
  Result := Syss.ShowInvDisc
End;

Function TSetup.GetSepDiscounts : Boolean;
Begin
  Result := Syss.SepDiscounts
End;

Function TSetup.GetUseCreditChk : Boolean;
Begin
  Result := Syss.UseCreditChk
End;

Function TSetup.GetUseCRLimitChk : Boolean;
Begin
  Result := Syss.UseCRLimitChk
End;

Function TSetup.GetAutoClearPay : Boolean;
Begin
  Result := Syss.AutoClearPay
End;

Function TSetup.GetTotalConv : Char;
Begin
  Result := Syss.TotalConv
End;

Function TSetup.GetDispPrAsMonths : Boolean;
Begin
  Result := Syss.DispPrAsMonths
End;

Function TSetup.GetNomCtrlCodes (Index : cuNomCtrlType) : LongInt;
Begin
  Result := Syss.NomCtrlCodes[NomCtrlType(Index)]
End;

Function TSetup.GetDetailAddr (Index : cuAddrIndex) : cuStr30;
Begin
  Result := Syss.DetailAddr[Index]
End;

Function TSetup.GetDirectCust : cuStr10;
Begin
  Result := Syss.DirectCust
End;

Function TSetup.GetDirectSupp : cuStr10;
Begin
  Result := Syss.DirectSupp
End;

Function TSetup.GetTermsofTrade (Index : cuTermsIndex) : cuStr80;
Begin
  Result := Syss.TermsofTrade[Index]
End;

Function TSetup.GetNomPayFrom : LongInt;
Begin
  Result := Syss.NomPayFrom
End;

Function TSetup.GetNomPayToo : LongInt;
Begin
  Result := Syss.NomPayToo
End;

Function TSetup.GetSettleDisc : Real;
Begin
  // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
  Result := 0.0; //Syss.SettleDisc
End;

Function TSetup.GetSettleDays : SmallInt;
Begin
  // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
  Result := 0; //Syss.SettleDays
End;

Function TSetup.GetNeedBMUp : Boolean;
Begin
  Result := Syss.NeedBMUp
End;

Function TSetup.GetInpPack : Boolean;
Begin
  Result := Syss.InpPack
End;

Function TSetup.GetVATCode : Char;
Begin
  Result := Syss.VATCode
End;

Function TSetup.GetPayTerms : SmallInt;
Begin
  Result := Syss.PayTerms
End;

Function TSetup.GetStaAgeInt : SmallInt;
Begin
  Result := Syss.StaAgeInt
End;

Function TSetup.GetQuoOwnDate : Boolean;
Begin
  Result := Syss.QuoOwnDate
End;

Function TSetup.GetFreeExAll : Boolean;
Begin
  Result := Syss.FreeExAll
End;

Function TSetup.GetDirOwnCount : Boolean;
Begin
  Result := Syss.DirOwnCount
End;

Function TSetup.GetStaShowOS : Boolean;
Begin
  Result := Syss.StaShowOS
End;

Function TSetup.GetLiveCredS : Boolean;
Begin
  Result := Syss.LiveCredS
End;

Function TSetup.GetBatchPPY : Boolean;
Begin
  Result := Syss.BatchPPY
End;

Function TSetup.GetWarnJC : Boolean;
Begin
  Result := Syss.WarnJC
End;

Function TSetup.GetDefBanknom : LongInt;
Begin
  Result := Syss.DefBanknom
End;

Function TSetup.GetUseDefBank : Boolean;
Begin
  Result := Syss.UseDefBank
End;

Function TSetup.GetMonWk1 : cuLongDate;
Begin
  Result := Syss.MonWk1
End;

Function TSetup.GetAuditDate : cuLongDate;
Begin
  Result := Syss.AuditDate
End;

Function TSetup.GetUserSort : cuStr6;
Begin
  //PR: 09/09/2013 ABSEXCH-14598 Changed to use new SEPA code field
  Result := DecryptBankSortCode(Syss.ssBankSortCode);
End;

Function TSetup.GetUserAcc : cuStr8;
Begin
  //PR: 09/09/2013 ABSEXCH-14598 Changed to use new SEPA code field
  Result := DecryptBankAccountCode(Syss.ssBankAccountCode);
End;

Function TSetup.GetUserRef : cuStr18;
Begin
  Result := Syss.UserRef
End;

Function TSetup.GetUserBank : cuStr25;
Begin
  Result := Syss.UserBank
End;

Function TSetup.GetLastExpFolio : LongInt;
Begin
  Result := Syss.LastExpFolio
End;

Function TSetup.GetDetailTel : cuStr15;
Begin
  Result := Syss.DetailTel
End;

Function TSetup.GetDetailFax : cuStr15;
Begin
  Result := Syss.DetailFax
End;

Function TSetup.GetUserVATReg : cuStr30;
Begin
  Result := Syss.UserVATReg
End;

Function TSetup.GetDataPath : ShortString;
Var
  TmpDrive : ShortString;
Begin
  // HM 21/03/00: Rewrote after complaints from Jim French!
  //Result := SetDrive

  If (Trim(SetDrive) = '') Then
    Result := IncludeTrailingBackSlash(ExtractFilePath(Application.ExeName))
  Else
    Result := IncludeTrailingBackSlash(SetDrive);
End;

//------------------------------

Function TSetup.GetUserFields : TAbsUserFields;
Begin { GetUserFields }
  Result := GetUserFields2;
End; { GetUserFields }

Function TSetup.GetUserFields2 : TAbsUserFields2;
Begin // GetUserFields2
  { Create User fields sub-object when and if necessary }
  If (Not Assigned(FUserFields)) Then
    FUserFields := TUserFields.Create;

  Result := FUserFields;
End; // GetUserFields2

//------------------------------

Function TSetup.GetPaperless : TAbsPaperlessSetup;
Begin { GetPaperless }
  { Create Paperless sub-object when and if necessary }
  If (Not Assigned(FPaperless)) Then
    FPaperless := TPaperlessSetup.Create;

  Result := FPaperless;
End; { GetPaperless }

//----------------------------------------------------------------------------

{ TPaperlessSetup }
function TPaperlessSetup.GetAttachMethod: Byte;
begin
  Result := SyssEDI2^.EDI2Value.emAttchMode;
end;

function TPaperlessSetup.GetAttachPrinter: cuStr20;
begin
  Result := SyssEDI2^.EDI2Value.EmailPrnN;
end;
Function TPaperlessSetup.GetAttachPrinter50 : cuStr50;
begin
  Result := SyssEDI2^.EDI2Value.EmailPrnN;
end;

function TPaperlessSetup.GetDefaultEmailPriority: Byte;
begin
  Result := SyssEDI2^.EDI2Value.EmPriority;
end;

function TPaperlessSetup.GetEmailUseMAPI: Boolean;
begin
  Result := SyssEDI2^.EDI2Value.EmUseMAPI;
end;

function TPaperlessSetup.GetFaxFromName: cuStr40;
begin
  Result := SyssEDI2^.EDI2Value.FxName;
end;

function TPaperlessSetup.GetFaxFromTelNo: cuStr25;
begin
  Result := SyssEDI2^.EDI2Value.FxPhone;
end;

function TPaperlessSetup.GetFaxInterfacePath: cuStr60;
begin
  Result := SyssEDI2^.EDI2Value.FaxDLLPath;
end;

function TPaperlessSetup.GetFaxPrinter: cuStr20;
begin
  Result := SyssEDI2^.EDI2Value.FaxPrnN;
end;
Function TPaperlessSetup.GetFaxPrinter50 : cuStr50;
begin
  Result := SyssEDI2^.EDI2Value.FaxPrnN;
end;

function TPaperlessSetup.GetFaxUsing: Byte;
begin
  Result := SyssEDI2^.EDI2Value.FxUseMAPI;
end;

function TPaperlessSetup.GetSMTPServer: cuStr255;
begin
  Result := SyssEDI2^.EDI2Value.EmSMTP;
end;

function TPaperlessSetup.GetYourEmailAddress: cuStr255;
begin
  Result := SyssEDI2^.EDI2Value.EmAddress;
end;

function TPaperlessSetup.GetYourEmailName: cuStr255;
begin
  Result := SyssEDI2^.EDI2Value.EmName;
end;

//----------------------------------------------------------------------------

function TSetup.GetWORAllocStockOnPick: Boolean;
begin
  Result := Syss.UseWIss4All;
end;

function TSetup.GetWOPDisableWIP: Boolean;
begin
  Result := Syss.UseSTDWOP;
end;

function TSetup.GetWORCopyStkNotes: Byte;
begin
  Result := Syss.WOPStkCopMode;
end;

//-------------------------------------------------------------------------

Function TSetup.GetCISSetup : TAbsCISSetup;
begin
  { Create CIS Setup sub-object when and if necessary }
  If (Not Assigned(FCISSetup)) Then
    FCISSetup := TCISSetup.Create;

  Result := FCISSetup;
end;

//------------------------------

Function TSetup.GetJobCosting : TAbsJobCostingSetup;
begin
  { Create Job Costing sub-object when and if necessary }
  If (Not Assigned(FJobCosting)) Then
    FJobCosting := TJobCostingSetup.Create;

  Result := FJobCosting;
end;

//------------------------------

Function TSetup.GetFilterSNoByBinLoc : Boolean;
begin
  Result := Syss.FiltSNoBinLoc;
end;

Function TSetup.GetKeepBinHistory : Boolean;
begin
  Result := Syss.KeepBinHist;
end;

Function TSetup.GetBinMask : cuStr10;
begin
  Result := Syss.BinMask;
end;


// v6.00 11/05/07: Added Connection String for Exchequer SQL

Function TSetup.GetConnectInfo : WideString;

{$IFDEF EXSQL}

var

  CompanyCode: WideString;
  ConnStr : WideString;   
{$ENDIF}

Begin // GetConnectInfo

  {$IFDEF EXSQL}

  If EnterpriseLicence.IsSQL Then
  Begin       

    CompanyCode := SQLUtils.GetCompanyCode(GetDataPath);

    //Result := SQLUtils.GetConnectionString(CompanyCode, True);

    ConnStr := '';
    if (SQLUtils.GetConnectionString(CompanyCode, True, ConnStr) = 0) then
    begin
      Result := ConnStr;
    end;

  End // If EnterpriseLicence.IsSQL

  Else

  {$ENDIF}

    Result := '';

End; // GetConnectInfo

//-------------------------------------------------------------------------

// TAbsSetup5
Function TSetup.GetUseTTD : Boolean;
Begin // GetUseTTD
  Result := Syss.EnableTTDDiscounts;
End; // GetUseTTD

//------------------------------

Function TSetup.GetUseVBD : Boolean;
Begin // GetUseVBD
  Result := Syss.EnableVBDDiscounts;
End; // GetUseVBD

//-------------------------------------------------------------------------

// TAbsSetup6
Function TSetup.GetEnableECServices : Boolean;
Begin // GetEnableECServices
  Result := SyssVAT.VATRAtes.EnableECServices;
End; // GetEnableECServices

//------------------------------

Function TSetup.GetECSalesThreshold : Double;
Begin // GetECSalesThreshold
  Result := SyssVAT.VATRAtes.ECSalesThreshold;
End; // GetECSalesThreshold

//-------------------------------------------------------------------------

// v6.3 18/01/10: TAbsSetup7
Function TSetup.GetCompanyCode : ShortString;
Begin // GetCompanyCode
  Result := CustomisationCompanyCode;
End; // GetCompanyCode

//-------------------------------------------------------------------------

// TAbsSetup8 - v6.5 - 12/10/10 - Added Enable Override Location on Purchases flag
Function TSetup.GetEnableOverrideLocation : Boolean;
Begin // GetEnableOverrideLocation
  Result := Syss.EnableOverrideLocations;
End; // GetEnableOverrideLocation

//-------------------------------------------------------------------------

function TSetup.GetBankAccountCode: cuStr35;
begin
  //PR: 29/07/2013 Change to use new SEPA field
  Result := DecryptBankAccountCode(Syss.ssBankAccountCode);
end;

function TSetup.GetBankSortCode: cuStr11;
begin
  //PR: 29/07/2013 Change to use new SEPA field
  Result := DecryptBankSortCode(Syss.ssBankSortCode);
end;

//-------------------------------------------------------------------------

// MH 30/09/2013 MRD Branch for v7.0.8: Added new fields for Consumer Ledger and Auto-Receipt
Function TSetup.GetConsumersEnabled : Boolean;
Begin // GetConsumersEnabled
  Result := Syss.ssConsumersEnabled
End; // GetConsumersEnabled

//-------------------------------------------------------------------------

// MH 22/09/2014 Order Payments
Function TSetup.GetOrderPaymentsEnabled : Boolean;
Begin // GetOrderPaymentsEnabled
  Result := Syss.ssEnableOrderPayments;
End; // GetOrderPaymentsEnabled

//-------------------------------------------------------------------------

//AP 05/12/2017 ABSEXCH-19401 GDPR 
Function TSetup.GetGDPR : TAbsSetupGDPR;
Begin // GetGDPR
  { Create GDPR Setup sub-object when and if necessary }
  If (Not Assigned(FGDPR)) Then
    FGDPR := TGDPR.Create;
  Result := FGDPR;
end;

//AP 04/12/2017 2018R1 ABSEXCH-19401: GDPR (POST 19344) - 8.3.1.1.3 - DLL + COM Customisation Support
Function  TGDPR.GetAnonymised: Boolean;
begin
  Result := SystemSetup.GDPR.Anonymised;
end;

Function  TGDPR.GetAnonymisedDate: cuStr8;
begin
  Result := SystemSetup.GDPR.AnonymisedDate;
end;

Function  TGDPR.GetAnonymisedTime: cuStr6;
begin
  Result := SystemSetup.GDPR.AnonymisedTime;
end;

Function  TGDPR.GetGDPRTraderRetentionPeriod: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderRetentionPeriod;
end;

Function  TGDPR.GetGDPRTraderDisplayPIITree: Boolean;
begin
  Result := SystemSetup.GDPR.GDPRTraderDisplayPIITree;
end;

Function  TGDPR.GetGDPRTraderAnonNotesOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderAnonNotesOption;
end;

Function  TGDPR.GetGDPRTraderAnonLettersOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderAnonLettersOption;
end;

Function  TGDPR.GetGDPRTraderAnonLinksOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderAnonLinksOption;
end;

Function  TGDPR.GetGDPREmployeeRetentionPeriod: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeRetentionPeriod;
end;

Function  TGDPR.GetGDPREmployeeDisplayPIITree: Boolean;
begin
  Result := SystemSetup.GDPR.GDPREmployeeDisplayPIITree;
end;

Function  TGDPR.GetGDPREmployeeAnonNotesOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeAnonNotesOption;
end;

Function  TGDPR.GetGDPREmployeeAnonLettersOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeAnonLettersOption;
end;

Function  TGDPR.GetGDPREmployeeAnonLinksOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeAnonLinksOption;
end;

Function  TGDPR.GetNotificationWarningColour: Integer;
begin
  Result := SystemSetup.GDPR.NotificationWarningColour;
end;

Function  TGDPR.GetNotificationWarningFontColour: Integer;
begin
  Result := SystemSetup.GDPR.NotificationWarningFontColour;
end;

Function  TGDPR.GetGDPRCompanyAnonLocations: Boolean;
begin
  Result := SystemSetup.GDPR.GDPRCompanyAnonLocations;
end;

Function  TGDPR.GetGDPRCompanyAnonCostCentres: Boolean;
begin
  Result := SystemSetup.GDPR.GDPRCompanyAnonCostCentres;
end;

Function  TGDPR.GetGDPRCompanyAnonDepartment: Boolean;
begin
  Result := SystemSetup.GDPR.GDPRCompanyAnonDepartment;
end;

Function  TGDPR.GetGDPRCompanyNotesOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRCompanyNotesOption;
end;

Function  TGDPR.GetGDPRCompanyLettersOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRCompanyLettersOption;
end;

Function  TGDPR.GetGDPRCompanyLinksOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRCompanyLinksOption;
end;

//AP 01/02/2018 ABSEXCH-19455: Currency Import Tolerance support
Function TSetup.GetCurrencyImportTolerance : Real;
begin
  Result := SystemSetup.CurrencySetup.ssCurrImportTol;
end;
{ TSecureString }
//SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
constructor TSecureString.Create(const Value: WideString);
begin
  inherited Create;
  SetString(FData, PChar(Value), System.Length(Value));
end;

destructor TSecureString.Destroy;
var
  I: Integer;
begin
  if System.Length(FData) > 0 then
  begin
    ZeroMemory(Pointer(FData), System.Length(FData) * SizeOf(Char));
  end;
  inherited Destroy;
end;

function TSecureString.Data: WideString;
begin
  Result := FData;
end;

function TSecureString.Length: Integer;
begin
  Result := System.Length(FData);
end;

function NewSecureString(const S: WideString): ISecureString;
var
  I: Integer;
begin
  Result := TSecureString.Create(S);
  if System.Length(S) > 0 then
  begin
    ZeroMemory(Pointer(S),System.Length(S) * SizeOf(Char))


  end;
end;


function TSetup.GetConnectionPassword: WideString;
{$IFDEF EXSQL}
var
  CompanyCode: WideString;
  ConnStr, lPassword: WideString;
{$ENDIF}
Begin // GetConnectInfo

  {$IFDEF EXSQL}
  If EnterpriseLicence.IsSQL Then
  Begin
    CompanyCode := SQLUtils.GetCompanyCode(GetDataPath);
    ConnStr := '';
    lPassword := '';
    if (SQLUtils.GetConnectionStringWOPass(CompanyCode, True, ConnStr, lPassword) = 0) then
    begin
      Result := lPassword;
    end;
  End // If EnterpriseLicence.IsSQL
  Else                             
  {$ENDIF}                         
    Result := '';
End; // GetConnectInfo

function TSetup.GetConnectionString: WideString;
{$IFDEF EXSQL}
var
  CompanyCode: WideString;
  ConnStr, lPassword: WideString;
{$ENDIF}
Begin // GetConnectInfo

  {$IFDEF EXSQL}
  If EnterpriseLicence.IsSQL Then
  Begin
    CompanyCode := SQLUtils.GetCompanyCode(GetDataPath);
    ConnStr := '';
    lPassword := '';
    if (SQLUtils.GetConnectionStringWOPass(CompanyCode, True, ConnStr, lPassword) = 0) then
    begin
      Result := ConnStr;
    end;
  End // If EnterpriseLicence.IsSQL
  Else                             
  {$ENDIF}                         
    Result := '';
End; // GetConnectInfo
End.
