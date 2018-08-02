Unit CreateAuditTrail;

Interface

Uses Classes, SysUtils, Windows, WiseUtil;

// Called to create the Audit folder and the initial audit log if required
function SCD_CreateAuditTrail(var DLLParams: ParamRec): LongBool;

// MH 03/03/2011 v6.7 ABSEXCH-10687: Create new company specific Audit directory if missing
Procedure CheckForAuditDir (Const CompanyName, CompanyDir : ShortString);

Implementation

Uses AuditIntf, CompUtil;

//=========================================================================

// MH 03/03/2011 v6.7 ABSEXCH-10687: Create new company specific Audit directory if missing
Procedure CheckForAuditDir (Const CompanyName, CompanyDir : ShortString);
Var
  DirPath : ShortString;
Begin // CheckForAuditDir
  DirPath := IncludeTrailingPathDelimiter(Trim(CompanyDir)) + 'Audit';
  If Not DirectoryExists(DirPath) Then
  Begin
    ForceDirectories (DirPath);
  End; // If Not DirectoryExists(DirPath)

  If Not FileExists (DirPath + '\' + LiveAuditFilename) Then
  Begin
    // Create audit file
    AuditSystemInformation.asApplicationDescription := 'Exchequer Installer';
    AuditSystemInformation.asApplicationVersion := '';
    AuditSystemInformation.asExchequerUser := 'Installer';
    AuditSystemInformation.asCompanyDirectory := Trim(CompanyDir);
    AuditSystemInformation.asCompanyName := Trim(CompanyName);
    NewAuditInterface (atMissingLog).WriteAuditEntry;
  End; // If Not FileExists (DirPath + '\' + LiveAuditFilename)
End; // CheckForAuditDir

//-------------------------------------------------------------------------

// Called to create the Audit folder and the initial audit log if required
function SCD_CreateAuditTrail(var DLLParams: ParamRec): LongBool;
Var
  W_InstType, W_CompanyName, W_AuditDir : String;
  Params  : ANSIString;
Begin // SCD_CreateAuditTrail
  Params := DLLParams.szParam;

  { Check security parameter to ensure not called by anyone }
  If (Copy (Params, 1, 8) = 'SJDF29AS') And (Length(Params) = 8) Then
  Begin
    // Get Installation Type from WISE - A=Install, B=Upgrade, C=Add Company
    GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

    // NOTE: Upgrades handled separately in the Replication routines (ReplSysF.Pas)

    If (UpperCase(Trim(W_InstType)) = 'C') Then
    Begin
      // Add Company - Get company directory and create audit log
      GetVariable(DLLParams, 'V_COMPDIR', W_AuditDir);
      FixPath (W_AuditDir);
      GetVariable(DLLParams, 'V_GETCOMPNAME', W_CompanyName);
      CheckForAuditDir (W_CompanyName, W_AuditDir);
    End // If (UpperCase(Trim(W_InstType)) = 'C')
    Else If (UpperCase(Trim(W_InstType)) = 'A') Then
    Begin
      // Install - Get main installation directory and create audit log
      GetVariable(DLLParams, 'V_MAINDIR', W_AuditDir);
      FixPath (W_AuditDir);
      GetVariable(DLLParams, 'V_GETCOMPNAME', W_CompanyName);
      CheckForAuditDir (W_CompanyName, W_AuditDir);
    End; // Else
  End; // If (Copy (Params, 1, 7) = 'SJDF29AS') And (Length(Params) = 8)

  Result := False;
End; // SCD_CreateAuditTrail

//=========================================================================


End.
