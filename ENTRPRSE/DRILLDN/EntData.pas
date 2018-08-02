unit EntData;

{$ALIGN 1}

interface

Uses Classes, Controls, Dialogs, Forms, IniFiles, Messages, SysUtils, REgistry, Windows,
     GlobVar,          // Exchequer Global Const/Type/Var's
     VarConst,         // Exchequer Global Const/Type/Var's
     VarRec2U,
     BtrvU2;           // Btrieve Data Access Functions

Type
  // Structure used to pass the Company Details around the Drill-Down routines
  TCompanyDetails = Record
    cmCode   : String[CompCodeLen];    { Company Code  }
    cmName   : String[CompNameLen];    { Company Name  }
    cmPath   : String[CompPathLen];    { Company Path - Short DOS 8.3 Format }
  End; { TCompanyDetails }

  //------------------------------

  // Structure used to record successful logins in the FLoginCache array for re-use
  TLoginCache = Record
    lcCompCode  : String[CompCodeLen]; { Company Code  }
    lcUserId    : String[12];          { User Id }
  End; { TLoginCache }

  //------------------------------

  // Object wrapper for Exchequer database which contains all the data based
  // operations required by the Drill-Down utility
  TEntData = Class(TObject)
  Private
    // Cache of previous successful logins to allow automation
    FLoginCache : Array Of TLoginCache;
    // Reference count on the open data files - to prevent them being closed whilst a window is still open
    FRefCount : LongInt;
  Protected
    Function GetCompanyCode : ShortString;
    Function LoginOK (Const CompDets : TCompanyDetails) : Boolean;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Property edCompanyCode : ShortString Read GetCompanyCode;

    // General Methods
    Function  OpenDataSet (Const CompDets : TCompanyDetails) : Boolean;

    // Reference counting methods to prevent data being closed whilst still in use by another window/process
    Procedure AddReferenceCount;
    Procedure RemoveReferenceCount;

    // Security Methods
    Function CheckUserSecurity (Const SecNo : LongInt) : Boolean;

    // Validate methods
    Function ValidCompanyCode (Var CompDets : TCompanyDetails) : Boolean;
    Function ValidCCDept (Var CCDept : ShortString; Const WantCC : Boolean) : Boolean;
    Function ValidCurrency (Var Currency : Integer) : Boolean;
    function ValidCustCode(var CustCode: ShortString): Boolean;
    Function ValidGLCode (Var GLCode : Integer; Var GLDesc : ShortString; Var GLType : Char) : Boolean;
    function ValidGLView(var GLView: Integer; var CostCentre: ShortString;
      var Department: ShortString): Boolean;
    function ValidGLLineCode(var GLView: Integer; var GLLineCode: ShortString;
      var GLCode: Integer): Boolean;
    Function ValidFinancialPeriod (Var Period : Integer) : Boolean;
    Function ValidFinancialYear (Var Year : Integer) : Boolean;
    function ValidJobCode(var JobCode: ShortString): Boolean;
    function ValidLocation(var Location: ShortString): Boolean;
    function ValidStockCode(var StockCode: ShortString): Boolean;
    function ValidAnalysisCode(var AnalysisCode: ShortString): Boolean;
  End; { TEntData }


Function EnterpriseData : TEntData;

// Closes any open data files in the range CustF (1) to SysF (15)
//Procedure CloseDataFiles;


implementation

Uses ETStrU,           // Exchequer String Utilities
     BTKeys1U,         // Exchequer Search Key utilities
     BTSupU1,          // Misc Exchequer Routines
     BTSupU2,          // Misc Exchequer Routines & Global Curr/VAT Lists
     MemMap,           // Memory Map maintained by OLE Server
     MainF,            // Main Form of Drill-Down COM Object
     SysU2,
     uSettings,
     WebExt,           // Web Extensions Info
     EntLicence,       // Global Exchequer Licence object
     CustomFieldsIntf, // Custom Fields Info Object
     LoginF,
     PasswordComplexityConst,
     AdoConnect;

Var
  // local object published through the EnterpriseData function
  oEnterpriseData : TEntData;

  // Company code of currently open data set
  FCurrentCompany : ShortString;

//=========================================================================

Function EnterpriseData : TEntData;
Begin { EnterpriseData }
  If (Not Assigned(oEnterpriseData)) Then
    oEnterpriseData := TEntData.Create;

  Result := oEnterpriseData;
End; { EnterpriseData }

//=========================================================================

// Closes any open data files in the range CustF (1) to SysF (15)
Procedure CloseDataFiles;
Var
  FSpec   : FileSpec;
  FileNo  : Byte;
  lStatus : SmallInt;
Begin { CloseDataSet }
  // NOTE: Must use a copy of the standard Close_File routine from VarCnst2.Pas
  // as the standard routine does a Btrieve Reset which would screw up any other
  // Btrieve using DLL's in use by Excel at this point (e.g. Data Query, COM TK)

  {$I-}
    For FileNo := CustF to SysF Do Begin
      // Check file is open before attempting to close it
      lStatus := GetFileSpec(F[FileNo], FileNo, FSpec);

      If (lStatus = 0) Then
        Close_File(F[FileNo]);

      Close_File(F[NomViewF]);
    End; { For FileNo }
  {$I+}

  FCurrentCompany := '';
End; { CloseDataSet }

//=========================================================================

Constructor TEntData.Create;
Var
  lStatus : SmallInt;
Begin { Create }
  Inherited Create;

  // Initialise dynamic array used to store the companies that we have logged into
  FLoginCache := NIL;

  FRefCount := 0;  // No open files

  // Open Company.Dat
  lStatus := Open_File (F[CompF], SetDrive + FileNames[CompF], 0);
  If (lStatus <> 0) Then
    Raise Exception.Create ('TEntData.Create - Unable to Open Company.Dat (' + IntToStr(lStatus) + ')');

  // Company code of currently open data set
  FCurrentCompany := '';

  //Intialise GlobalAdoConnection as we will be using SystemSetup (needed for Common Login Screen implementation)
  //EnterpriseLicence.IsSQL - we need to check this for SQL Only
  if EnterpriseLicence.IsSQL and (not Assigned(GlobalAdoConnection)) then
    InitialiseGlobalADOConnection(SetDrive);

End; { Create }

//-------------------------------------------------------------------------

Destructor TEntData.Destroy;
Begin { Destroy }
  // Open Company.Dat
  Close_File(F[CompF]);

  FLoginCache := NIL;

  Inherited;
End; { Destroy }

//-------------------------------------------------------------------------

Function TEntData.GetCompanyCode : ShortString;
Begin { GetCompanyCode }
  Result := FCurrentCompany;
End; { GetCompanyCode }

//-------------------------------------------------------------------------

Function TEntData.OpenDataSet (Const CompDets : TCompanyDetails) : Boolean;
Var
  I : SmallInt;
Begin { OpenDataSet }
  With CompDets Do
    // Check we don't already have this data set open
    If (FCurrentCompany <> UpperCase(Trim(cmCode))) Then
    Begin
      // Close all Drill-Down Windows
      If (Screen.FormCount > 0) Then
        For I := 0 To Pred(Screen.FormCount) Do
          If (Screen.Forms[I] <> frmMainDebug) Then
            PostMessage (Screen.Forms[I].Handle, WM_CLOSE, 0, 0);

      // Close any other Company Data Set we have open
      If (FCurrentCompany <> '') Then
      Begin
        FRefCount := 0;  // Should already be 0, but just in case...
        CloseDataFiles;
      End; // If (FCurrentCompany <> '')

      // Set the Data Path to the new company data set
      SetDrive := cmPath;
      {$IFNDEF ENTER1}
      //PL 12/01/2017 2017-R1 ABSEXCH-17461 : Cannot perform this operation on
      //   a closed dataset error for hosted customers when using OLE drilldown.
      if (GetCustomFieldsPath) <> cmPath then
      begin
        SetCustomFieldsPath(cmPath);
        ClearCustomFields;
      end;
      {$ENDIF}

      // Open all the standard data files
      Open_System(CustF, SysF);
      Open_System(NomViewF, NomViewF);

      // Load the standard System Setup records
      Init_AllSys;

      // Load the global Lists
      Init_STDCurrList;
      Init_STDVATList;
      Init_STDDocTList;

      // Initialise the Global Module Flags
      EuroVers     := (EnterpriseLicence.elCurrencyVersion = cvEuro);
      JBCostOn     := (EnterpriseLicence.elModules[modJobCost] <> mrNone);
      eCommsModule := (EnterpriseLicence.elModules[modPaperless] <> mrNone);
      CommitAct    := (EnterpriseLicence.elModules[modCommit] <> mrNone);
      TeleSModule  := (EnterpriseLicence.elModules[modTeleSale] <> mrNone);
      AnalCuStk    := TeleSModule Or (EnterpriseLicence.elModules[modAccStk] <> mrNone);
      FullWOP      := (EnterpriseLicence.elModules[modProWOP] <> mrNone);
      STDWOP       := (EnterpriseLicence.elModules[modStdWOP] <> mrNone);
      WOPOn        := FullWOP or StdWOP;
      EnSecurity   := (EnterpriseLicence.elModules[modEnhSec] <> mrNone);
      CISOn        := (EnterpriseLicence.elModules[modCISRCT] <> mrNone);

      // MH 22/06/2010: Added check on Web Extensions Licence which is required for PIN's
      WebExtensionsOn := CheckForWebExtensionsLicence;

      // MH 04/11/2011 v6.9: Added support for new Custom Fields object
      SetCustomFieldsPath(SetDrive);

      // Record code of currently open data set
      FCurrentCompany := UpperCase(Trim(cmCode));
      sMiscDirLocation := cmPath;
    End; { If (FCurrentCompany <> UpperCase(Trim(cmCode))) }

  // Check for a successful login
  Result := LoginOK (CompDets);
End; { OpenDataSet }

//-------------------------------------------------------------------------

//Procedure TEntData.CloseDataSet;
//Begin { CloseDataSet }
//    // Only this window using the data files
//    CloseDataFiles;
//    FRefCount := 0;
//  End // If (FRefCount <= 1)
//  Else
//    // Decrement the reference count as other windows still using the files
//    FRefCount := FRefCount - 1;
//End; { CloseDataSet }

//-------------------------------------------------------------------------

function TEntData.LoginOK (Const CompDets: TCompanyDetails): Boolean;
var
  I: SmallInt;
  lLoginFrm: TfrmLogin;
Begin { LoginOK }
  // check Login Cache for any previously successfull login attempts
  Result := (Length(FLoginCache) > 0);
  if Result then
  begin
    // Check cache entries for Company Code
    Result := False;
    for I := Low(FLoginCache) to High(FLoginCache) do
      if (FLoginCache[I].lcCompCode = CompDets.cmCode) then
      begin
        // Found Code - Load user details and break out of loop
        Result := GetLoginRec(FLoginCache[I].lcUserId);
        if Result then
          Break;
      end; { If (FLoginCache[I].lcCompCode = CompDets.cmCode) }
  end; { If Result }

  if Not Result then     // Check the OLE Server for a User Id
    with GlobalOLEMap do
    begin
      if Defined and (LoginCount > 0) then
      begin
        I := IndexOf (CompDets.cmCode);
        if (I >= 1) then
          Result := GetLoginRec(Logins[I].gcdUserId);
      end; { If Defined And (LoginCount > 0) }
    end; { With GlobalOLEMap }

  if not Result then
  begin
    // This company was not previously logged into - Display login
    lLoginFrm := TfrmLogin.Create(Application);
    try
      with lLoginFrm do
      begin
        LoginDialog := ldOLEDrillDown;
        // Check Enhanced Security (Flag also used in Login Dlg)
        EnSecurity := (EnterpriseLicence.elModules[modEnhSec] <> mrNone);
        InitDefaults;
        ShowModal;
        // Check the result of the login attempt
        Result := ModalResult = mrOk;   
        if Result then
        begin
          // Add Company Data Set info into Cache for future logins
          SetLength(FLoginCache, Length(FLoginCache) + 1);
          with FLoginCache[High(FLoginCache)] do
          begin
            lcCompCode := CompDets.cmCode;
            lcUserId   := EntryRec^.Login;
          end; { With FLoginCache[High(FLoginCache)] }
        end; { If Result }
      end;
    finally
      FreeAndNil(lLoginFrm);
    end;
  end; { If (Not Result) }
End; { LoginOK }

//-------------------------------------------------------------------------

// Reference counting methods to prevent data being closed whilst still in use by another window/process
Procedure TEntData.AddReferenceCount;
Begin // AddReferenceCount
  FRefCount := FRefCount + 1;
End; // AddReferenceCount

Procedure TEntData.RemoveReferenceCount;
Begin // RemoveReferenceCount
  FRefCount := FRefCount - 1;
  If (FRefCount < 1) Then
  Begin
    FRefCount := 0;
    CloseDataFiles;
  End; // If (FRefCount < 1)
End; // RemoveReferenceCount

//-------------------------------------------------------------------------

// Returns True if the currently logged in user has the specified security rights
Function TEntData.CheckUserSecurity (Const SecNo : LongInt) : Boolean;
Begin { CheckUserSecurity }
  With EntryRec^ Do
    Result := ((SecNo >= Low(Access)) And (SecNo <= High(Access))) And
              (Access[SecNo] = 1);
End; { CheckUserSecurity }

//-------------------------------------------------------------------------

// Returns True if the specified Company Code is valid
Function TEntData.ValidCompanyCode (Var CompDets : TCompanyDetails) : Boolean;
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { ValidCompanyCode }
  With CompDets Do Begin
    // Modify Code to correct searchkey format
    cmCode := LJVar(UpperCase(Trim(cmCode)), CompCodeLen);

    // Build searchKey to lookup the company record within Company.Dat
    KeyS := cmCompDet + cmCode;

    // Try to load the company details record for the specified Company Code
    lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);

    Result := (lStatus = 0);
    If Result Then
    Begin
      cmName := Trim(Company^.CompDet.CompName);
      cmPath := IncludeTrailingPathDelimiter(Trim(Company^.CompDet.CompPath));
    End; { If Result }
  End; { With CompDets }
End; { ValidCompanyCode }

//-------------------------------------------------------------------------

Function TEntData.ValidCCDept (Var CCDept : ShortString; Const WantCC : Boolean) : Boolean;
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { ValidCCDept }
  CCDept := UpperCase(Trim(CCDept));
  Result := (CCDept <> '');

  If Result Then Begin
    // Lookup the GL Code in the database
    KeyS := FullCCKey (CostCCode, CSubCode[WantCC], CCDept);
    lStatus := Find_Rec(B_GetEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, KeyS);
    Result := (lStatus = 0);

    // If OK return GL Description
    If Result Then
      CCDept := Password.CostCtrRec.PCostC
    Else
      CCDept := '';
  End; { If Result }
End; { ValidCCDept }

//-------------------------------------------------------------------------

Function TEntData.ValidCurrency (Var Currency : Integer) : Boolean;
Begin { ValidCurrency }
  // Check system version - Prof/Euro/Glob
  Case EnterpriseLicence.elCurrencyVersion Of
    cvPro    : Result := (Currency = 0);
    cvEuro   : Result := (Currency >= 0) And (Currency <= 2);
    cvGlobal : Result := (Currency >= 0) And (Currency <= 89);
  Else
    Raise Exception.Create ('TEntData.ValidCurrency - Unknown Currency Version (' + IntToStr(Ord(EnterpriseLicence.elCurrencyVersion)) + ')');
  End; { Case EnterpriseLicence.elCurrencyVersion }
End; { ValidCurrency }

//-------------------------------------------------------------------------

// Returns True if the specified GL Code is valid
Function TEntData.ValidGLCode (Var GLCode : Integer; Var GLDesc : ShortString; Var GLType : Char) : Boolean;
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { ValidGLCode }
  Result := (GLCode > 0);

  If Result Then Begin
    // Lookup the GL Code in the database
    KeyS := FullNomKey(GLCode);
    lStatus := Find_Rec(B_GetEq, F[NomF], NomF, RecPtr[NomF]^, NomCodeK, KeyS);
    Result := (lStatus = 0);

    // If OK return GL Description
    If Result Then Begin
      GLDesc := Trim(Nom.Desc);
      GLType := Nom.NomType;
    End { If Result }
    Else
      GLDesc := '';
  End; { If Result }
End; { ValidGLCode }

//-------------------------------------------------------------------------

// Returns True if the specified GL View number is valid
function TEntData.ValidGLView(var GLView: Integer; var CostCentre: ShortString;
  var Department: ShortString): Boolean;
var
  lStatus : SmallInt;
  KeyS    : Str255;
begin
  Result := (GLView > 0);
  if Result then
  begin
    // Lookup the GL View in the database
    KeyS := Trim(FullNVCode(NVRCode, NVCSCode, 0, IntToHex(GLView, 4), True));
    lStatus := Find_Rec(B_GetGEq, F[NomViewF], NomViewF, RecPtr[NomViewF]^, NVCodeK, KeyS);
    Result := ((lStatus = 0) and (NomView.ViewCtrl.ViewCtrlNo = GLView));
    if (Result) then
    begin
      CostCentre := NomView.ViewCtrl.LinkCCDep[True];
      Department := NomView.ViewCtrl.LinkCCDep[False];
    end;
  end; { if Result }
end;

//-------------------------------------------------------------------------

// Returns True if the specified GL Line Code number is valid
function TEntData.ValidGLLineCode(var GLView: Integer;
  var GLLineCode: ShortString; var GLCode: Integer): Boolean;
var
  lStatus : SmallInt;
  KeyS    : Str255;
begin
  Result := (GLView > 0);
  if Result then
  begin
    // Lookup the GL View in the database
    KeyS := Trim(FullNVCode(NVRCode, NVVSCode, GLView, GLLineCode, True));
    lStatus := Find_Rec(B_GetGEq, F[NomViewF], NomViewF, RecPtr[NomViewF]^, NVCodeK, KeyS);
    Result := ((lStatus = 0) and
               (NomView.NomViewLine.NomViewNo = GLView) and
               (Trim(NomView.NomViewLine.ViewCode) = Trim(GLLineCode)));
    if Result then
      GLCode := NomView.NomViewLine.LinkGL;
  end; { if Result }
end;

//-------------------------------------------------------------------------

// Returns True if the specified Period is valid
Function TEntData.ValidFinancialPeriod (Var Period : Integer) : Boolean;
Begin { ValidFinancialPeriod }
  Result := ((Period >= 1) And (Period <= Syss.PrinYr)) Or             // Straight Period
            ((Period >= 101) And (Period <= (100 + Syss.PrinYr))) Or   // Year-To-Date Period
            (Period = 0) Or                                            // Everything up to the specified year
            (Period = -98) Or                                          // Everything Ever
            (Period = -99);                                            // F6 Period

  If Result And (Period = -99) Then
    // -99 = special value - Return current F6 Period
    Period := Syss.CPr;
End; { ValidFinancialPeriod }

//-------------------------------------------------------------------------

// Returns True if the specified Year is valid - Returns year as offset from 1900
// as used internally within the code
Function TEntData.ValidFinancialYear (Var Year : Integer) : Boolean;
Begin { ValidFinancialYear }
  Result := ((Year >= 1901) And (Year <= 2099)) Or (Year = -99);

  If Result Then Begin
    If (Year = -99) Then
      // -99 = special value - Return current F6 Year
      Year := Syss.CYr
    Else
      Year := Year - 1900;
  End; { If Result }
End; { ValidFinancialYear }

//-------------------------------------------------------------------------

function TEntData.ValidJobCode(var JobCode: ShortString): Boolean;
var
  lStatus: SmallInt;
  KeyS: Str255;
begin
  JobCode := Uppercase(Trim(JobCode));
  Result := JobCode <> '';
  if Result then
  begin
    KeyS := FullJobCode(JobCode);
    lStatus := Find_Rec(B_GetEq, F[JobF], JobF, RecPtr[JobF]^, JobCodeK, KeyS);
    Result := (lStatus = 0);
  end; // if Result...
end;

//-------------------------------------------------------------------------

function TEntData.ValidStockCode(var StockCode: ShortString): Boolean;
var
  lStatus: SmallInt;
  KeyS: Str255;
begin
  StockCode := Uppercase(Trim(StockCode));
  Result := StockCode <> '';
  if Result then
  begin
    KeyS := FullStockCode(StockCode);
    lStatus := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
    Result := (lStatus = 0);
  end; // if Result...
end;

function TEntData.ValidAnalysisCode(
  var AnalysisCode: ShortString): Boolean;
var
  lStatus: SmallInt;
  KeyS: Str255;
begin
  AnalysisCode := Uppercase(Trim(AnalysisCode));
  Result := AnalysisCode <> '';
  if Result then
  begin
    KeyS := FullJAKey(JARCode, JAACode, AnalysisCode);
    lStatus := Find_Rec(B_GetEq, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, KeyS);
    Result := (lStatus = 0);
  end; // if Result...
end;

function TEntData.ValidLocation(var Location: ShortString): Boolean;
var
  lStatus: SmallInt;
  KeyS: Str255;
begin
  Location := Uppercase(Trim(Location));
  Result := Location <> '';
  if Result then
  begin
    KeyS := CostCCode + CSubCode[True] + Full_MLocKey(Location);
    lStatus := Find_Rec(B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, KeyS);
    Result := (lStatus = 0);
  end; // if Result...
end;

function TEntData.ValidCustCode(var CustCode: ShortString): Boolean;
var
  lStatus: SmallInt;
  KeyS: Str255;
begin
  CustCode := Uppercase(Trim(CustCode));
  Result := CustCode <> '';
  if Result then
  begin
    KeyS := FullCustCode(CustCode);
    lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
    Result := (lStatus = 0);
  end; // if Result...
end;

end.


