unit EntData;

{$ALIGN 1}

interface

Uses Classes, Controls, Dialogs, Forms, IniFiles, Messages, SysUtils, REgistry, Windows,
     GlobVar,          // Exchequer Global Const/Type/Var's
     VarConst,         // Enterprise Global Const/Type/Var's
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

  // Object wrapper for Enterprise database which contains all the data based
  // operations required by the Drill-Down utility
  TEntData = Class(TObject)
  Private
    // Cache of previous successful logins to allow automation
    FLoginCache : Array Of TLoginCache;
  Protected
    Function GetCompanyCode : ShortString;
    Function LoginOK (Const CompDets : TCompanyDetails) : Boolean;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Property edCompanyCode : ShortString Read GetCompanyCode;

    // General Methods
    Procedure CloseDataSet;
    Function  OpenDataSet (Const CompDets : TCompanyDetails) : Boolean;

    // Security Methods
    Function CheckUserSecurity (Const SecNo : LongInt) : Boolean;

    // Validate methods
    Function ValidCompanyCode (Var CompDets : TCompanyDetails) : Boolean;
    Function ValidCCDept (Var CCDept : ShortString; Const WantCC : Boolean) : Boolean;
    Function ValidCurrency (Var Currency : Integer) : Boolean;
    Function ValidGLCode (Var GLCode : Integer; Var GLDesc : ShortString; Var GLType : Char) : Boolean;
    Function ValidFinancialPeriod (Var Period : Integer) : Boolean;
    Function ValidFinancialYear (Var Year : Integer) : Boolean;
  End; { TEntData }


Function EnterpriseData : TEntData;

// Closes any open data files in the range CustF (1) to SysF (15)
Procedure CloseDataFiles;


implementation

Uses ETStrU,           // Exchequer String Utilities
     BTKeys1U,         // Enterprise Search Key utilities
     BTSupU1,          // Misc Enterprise Routines
     BTSupU2,          // Misc Enterprise Routines & Global Curr/VAT Lists
     DDLogin,          // Drill-Down Server Login Screen
     MemMap,           // Memory Map maintained by OLE Server
     MainF,            // Main Form of Drill-Down COM Object
     SysU2,
     EntLicence;       // Global Enterprise Licence object

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

  // Open Company.Dat
  lStatus := Open_File (F[CompF], SetDrive + FileNames[CompF], 0);
  If (lStatus <> 0) Then
    Raise Exception.Create ('TEntData.Create - Unable to Open Company.Dat (' + IntToStr(lStatus) + ')');

  // Company code of currently open data set
  FCurrentCompany := '';
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
    If (FCurrentCompany <> UpperCase(Trim(cmCode))) Then Begin
      // Close all Drill-Down Windows
      If (Screen.FormCount > 0) Then
        For I := 0 To Pred(Screen.FormCount) Do
          If (Screen.Forms[I] <> frmMainDebug) Then
            PostMessage (Screen.Forms[I].Handle, WM_CLOSE, 0, 0);

      // Close any other Company Data Set we have open
      If (FCurrentCompany <> '') Then
        CloseDataFiles;

      // Set the Data Path to the new company data set
      SetDrive := cmPath;

      // Open all the standard data files
      Open_System (CustF, SysF);

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

      // Record code of currently open data set
      FCurrentCompany := UpperCase(Trim(cmCode));
    End; { If (FCurrentCompany <> UpperCase(Trim(cmCode))) }

  // Check for a successful login
  Result := LoginOK (CompDets);
End; { OpenDataSet }

//-------------------------------------------------------------------------

Procedure TEntData.CloseDataSet;
Begin { CloseDataSet }
  CloseDataFiles;
End; { CloseDataSet }

//-------------------------------------------------------------------------

Function TEntData.LoginOK (Const CompDets : TCompanyDetails) : Boolean;
Var
  WINLogIn : ShortString;
  I        : SmallInt;
Begin { LoginOK }
  // check Login Cache for any previously successfull login attempts
  Result := (Length(FLoginCache) > 0);
  If Result Then Begin
    // Check cache entries for Company Code
    Result := False;
    For I := Low(FLoginCache) To High(FLoginCache) Do
      If (FLoginCache[I].lcCompCode = CompDets.cmCode) Then Begin
        // Found Code - Load user details and break out of loop
        Result := GetLoginRec(FLoginCache[I].lcUserId);
        If Result Then Break;
      End; { If (FLoginCache[I].lcCompCode = CompDets.cmCode) }
  End; { If Result }

  If (Not Result) Then
    // Check the OLE Server for a User Id
    With GlobalOLEMap Do Begin
      If Defined And (LoginCount > 0) Then Begin
        I := IndexOf (CompDets.cmCode);
        If (I >= 1) Then
          Result := GetLoginRec(Logins[I].gcdUserId);
      End; { If Defined And (LoginCount > 0) }
    End; { With GlobalOLEMap }

  If Not Result Then Begin
    // This company was not previously logged into - Display login
    With TELogFrm.Create(Application) Do
      Try
        // Set Company Code
        CompLbl.Caption := CompDets.cmName;

        // Check Enhanced Security (Flag also used in Login Dlg)
        EnSecurity := (EnterpriseLicence.elModules[modEnhSec] <> mrNone);
        If EnSecurity Then Begin
          // Enhanced Security - Default Login Id to Windows Username if valid
          WinLogIn := UpperCase(WinGetUserName);

          {$B-}
          If (WinLogIn<>'') and GetLogInRec(WinLogIn) then
          {$B+}
          Begin
            UserF.Text:=WinLogIn;
            UserF.SelectAll;
          End;
        End; { If (EnterpriseLicence.elModules[modEnhSec] <> mrNone) }

        ShowModal;

        // Check the result of the login attempt
        Result := GotUser and GotPWord and (ModalResult = mrOk);

        If Result Then Begin
          // Add Company Data Set info into Cache for future logins
          SetLength(FLoginCache, Length(FLoginCache) + 1);
          With FLoginCache[High(FLoginCache)] Do Begin
            lcCompCode := CompDets.cmCode;
            lcUserId   := EntryRec^.Login;
          End; { With FLoginCache[High(FLoginCache)] }
        End; { If Result }
      Finally
        Free;
      End;
  End; { If (Not Result) }
End; { LoginOK }

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

end.
