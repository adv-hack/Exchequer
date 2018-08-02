unit oEntSec;

{ markd6 11:56 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSecurity_TLB, Registry, StdVcl, SysUtils, Windows,
  FileCtrl, IniFiles, GlobVar, BtrvU2;

Const
  MultCompNam = 'COMPANY.DAT';

Type
  ISNArrayType = Array [1..8] Of Byte;

{$I CompVar.Pas}

type
  TThirdParty = class(TObject) // TAutoObject, IThirdParty)
  private
    // Identifying ID Code of the Third-Party Application or Plug-In
    FSystemIdCode    : String[16];
    // Numerical Part of Identifying ID
    FSecurityNo      : LongInt;
    // Security Code to prevent unauthorised access to the security details for the Third-Party Application or Plug-In
    FSecurityCode    : String[16];
    // Textual Description of the Third-Party Application or Plug-In for on-screen display
    FDescription     : String[100];
    // Type of security being used by the Third-Party Application or Plug-In
    FSecurityType    : TSecurityType;
    // System Release Code Status for the Third-Party Application or Plug-In
    FSystemStatus    : TSystemSecurityStatus;
    // The number of users licenced to use the Third-Party Application or Plug-In
    FUserCount       : Integer;
    // The number of users currently using the Third-Party Application or Plug-In
    FCurrentUsers    : Integer;
    // Textual description of the last error status returned by a method
    FLastErrorString : AnsiString;
    // String version of system ESN
    FESN             : AnsiString;
    // Message for display on RelCode screen
    FMessage         : String[100];
    procedure ClearRecord;
  protected
    { Protected declarations }
    function Get_Version: WideString; safecall;
    function Get_tpDescription: WideString; safecall;
    function Get_ExchequerSiteNumber: WideString; safecall;
    function Get_tpMessage: WideString; safecall;
    procedure Set_tpMessage(const Value: WideString); safecall;

    function  ChangeUserCount (Const ChangeBy : SmallInt) : Integer;
    function  CheckForChanges (Var Expire : Boolean) : Boolean;
    function  GenRelCodes (Const NewFlg  : Byte; Var PlugInRec : HookSecurityRecType) : LongInt;
    Procedure GetErrorString (Var ErrNo : LongInt);
    function  GetSecurityRec : Boolean;
    function  Lock (Var RecAddr : LongInt) : LongInt;
    function  ValidateProps : LongInt;
  public
    procedure Initialize;//  override;
    Destructor Destroy; override;
    function  ReadSecurity: Integer; safecall;
    function  Get_tpSystemIdCode: WideString; safecall;
    procedure Set_tpSystemIdCode(const Value: WideString); safecall;
    function  Get_tpSecurityCode: WideString; safecall;
    procedure Set_tpSecurityCode(const Value: WideString); safecall;
    procedure Set_tpDescription(const Value: WideString); safecall;
    function  Get_tpSecurityType: TSecurityType; safecall;
    procedure Set_tpSecurityType(Value: TSecurityType); safecall;
    function  Get_tpCurrentUsers: Integer; safecall;
    function  Get_tpUserCount: Integer; safecall;
    function  Get_tpSystemStatus: TSystemSecurityStatus; safecall;
    function  Get_LastErrorString: WideString; safecall;
    function  AddUserCount: Integer; safecall;
    function  RemoveUserCount: Integer; safecall;
    function  ResetUserCount: Integer; safecall;
  end;

Var
  { Company Record and File }
  Company       : ^CompRec;
  SyssCompany   : ^CompRec;
  CompFile      : Comp_FileDef;

  CompLocked    : Boolean;

Var
  EntPath : ShortString;

implementation

uses Classes, ComServ, Dialogs, Forms, ETDateU, ETMiscU, LicRec, EntLic,
     SecSup2U, VarRec2U, LicFuncU, {$IFDEF EXSQL}SQLUtils, {$ENDIF}VAOUtil;


//----------------------------------------------------------------------------

// Import the Company.Dat File Structure
{$I MCmpFile.Pas}

//----------------------------------------------------------------------------

Procedure FindEnterpriseDir;
//Var
//  TmpPath : ShortString;
Begin { FindEnterpriseDir }

  EntPath := VAOInfo.vaoCompanyDir;

(*** HM 10/08/04: Changed to be VAO Aware
  // Lookup the security object (this object!) in Registry to determine the Exchequer Directory
  EntPath := '';
  With TRegistry.Create Do
    Try
      { Require minimal permissions }
      Access := Key_Read;

      { Lookup server in Class Registration section }
      RootKey := HKEY_CLASSES_ROOT;

      { Open CLSID up and get registered DLL name }
      If OpenKey('Clsid\' + GUIDToString(CLASS_ThirdParty) + '\InprocServer32', False) Then Begin
        EntPath := ReadString ('');

        // Check FileExists
        If FileExists (EntPath) Then
          { Got File - Remove Path }
          EntPath := IncludeTrailingBackSlash(ExtractFilePath(EntPath));
      End; { If KeyExists('') }
    Finally
      Free;
    End;

  // Check for Local Program Files
  If FileExists (EntPath + 'EntWRepl.Ini') Then
    // Got .INI - open and check for path
    With TIniFile.Create (EntPath + 'EntWRepl.Ini') Do
      Try
        // Get path to network dir
        TmpPath := ReadString ('UpdateEngine', 'NetworkDir', '');

        // Check its set
        If (Trim(TmpPath) <> '') Then Begin
          TmpPath := IncludeTrailingBackSlash(TmpPath);

          // Check for Exchequer System
          If DirectoryExists (TmpPath) And
             FileExists(TmpPath + 'ENTRPRSE.EXE') And
             FileExists(TmpPath + 'ENTER1.EXE') And
             FileExists(TmpPath + 'COMPANY.DAT') And
             FileExists(TmpPath + 'ENTRPRSE.DAT') And
             FileExists(TmpPath + 'EXCHQSS.DAT') Then
            // Got Exchequer System
            EntPath := TmpPath;
        End; { If (Trim(TmpPath) <> '') }
      Finally
        Free;
      End;
***)
End; { FindEnterpriseDir }

//-----------------------------------------

function OpenCompDB : LongInt;
Var
  Tries : Byte;
Begin { OpenCompDB }
{$IFDEF EXSQL}
  if TableExists(EntPath + 'Company.Dat') then
{$ELSE}
  If FileExists (EntPath + 'Company.Dat') Then
{$ENDIF}
  Begin
    Tries := 0;
    Repeat
      // Try to open company.Dat
      Result := Open_File (F[CompF], EntPath + 'Company.Dat', 0);

      If (Result <> 0) Then Begin
        // Error - pause 1/5 second before retrying
        Sleep (200);
        Inc(Tries);
      End; { If (Result <> 0) }
    Until (Result = 0) Or (Tries > 5);

    If (Result = 0) Then
      LoadCompanyOpt
    Else
      // Return Btrieve Error with 100,000 offset
      Result := 100000 + Result;
  End { If FileExists ... }
  Else
    // Company.Dat missing
    Result := 3001;
End; { OpenCompDB }

//-----------------------------------------

Procedure CloseCompDB;
Begin { CloseCompDB }
  Close_File (F[CompF]);
End; { CloseCompDB }

//-----------------------------------------

Function WaitForCompDB : Boolean;
Begin { WaitForCompDB }
  Result := True;

  While CompLocked Do
    Application.ProcessMessages;

  If (Not CompLocked) Then
    CompLocked := True;
End; { WaitForCompDB }

//----------------------------------------------------------------------------

// FullNomKey equivalent for 2 byte integers
Function FullNomKey2 (Const TheNum : SmallInt) : ShortString;
Var
  TmpS : ShortString;
Begin { FullNomKey2 }
  TmpS := '  ';
  Move (TheNum, TmpS[1], 2);
  Result := TmpS;
End; { FullNomKey2 }

//--------------------------------

// Checks the specified index in Company.Dat to determine a unique key
Function UniqueKey2 (Const IdxNo   : SmallInt;
                     Const RecPFix : ShortString;
                     Const CurrKey : ShortString) : ShortString;
Var
  lCompany           : CompRec;
  KeyS               : Str255;
  KeyNo, lStatus     : SmallInt;
Begin { UniqueKey2 }
  Result := CurrKey;

  // Save current position and record
  lCompany := Company^;

  // Loop around checking for uniqueness
  KeyNo := 1;
  Repeat
    Inc (KeyNo);
    KeyS := RecPFix + CurrKey + FullNomKey2 (KeyNo);

    lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, IdxNo, KeyS);
  Until (lStatus In [4, 9]);

  Result := CurrKey + FullNomKey2 (KeyNo);

  // restore original position and record
  Company^ := lCompany;
End; { UniqueKey2 }

//----------------------------------------------------------------------------

procedure TThirdParty.Initialize;
Var
  EntLic : EntLicenceRecType;
Begin { Initialize }
//  inherited Initialize;

  // Initialise the local properties to their default values
  FSystemIdCode  := '';
  FSecurityNo    := 0;
  FSecurityCode  := '';
  FDescription   := '';
  FSecurityType  := 0;
  FSystemStatus  := 0;
  FUserCount     := 0;
  FCurrentUsers  := 0;
  FMessage       := '';

  // HM 03/04/02: Check for licence file as need Demo flag from licence for
  //              7-segment ESN's.
  FESN := '';
  If FileExists (EntPath + EntLicFName) Then Begin
    // Ensure ExMainCoPath isn't set as it usually ballses up the reading of a licence
    If Assigned (ExMainCoPath) then ExMainCoPath^ := '';

    // Read Licence so we can determine the 7-segment ESN
    If ReadEntLic (EntPath + EntLicFName, EntLic) Then
      FESN := licESN7Str (EntLic.licISN, EntLic.licLicType);
  End; { If FileExists (TmpPath + 'ENTRPRSE.DAT') }

  (***
  If WaitForCompDB Then Begin
    // Load ESN from Company.Dat
    If (OpenCompDB = 0) Then Begin
      // Load Company Setup record containing system ESN
      LoadCompanyOpt;

      With SyssCompany^.CompOpt Do
        FESN := Format ('%3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d', [optSystemESN[1], optSystemESN[2],
                                                                optSystemESN[3], optSystemESN[4],
                                                                optSystemESN[5], optSystemESN[6]]);

      CloseCompDb;
    End { If (OpenCompDB = 0) }
    Else
      // Error opening Company.Dat
      FESN := '';

    CompLocked := False;
  End { If WaitForCompDB }
  Else
    FESN := '';
  ***)
End; { Initialize }

//-----------------------------------------

Destructor TThirdParty.Destroy;
Begin { Destroy }


  inherited Destroy;
End; { Destroy }

//----------------------------------------------------------------------------

function TThirdParty.Get_Version: WideString;
begin
  Result := 'ENTSEC-600.009';

  (********************************************************************************
  //
  // ENTSEC-600.009
  // ------------------------
  //  HM   Rebuilt for v6.00 with EX600;LIC600;EXSQL
  //
  //
  // ENTSEC-570.008
  // ------------------------
  //  HM   Rebranded for IRIS Enterprise / Exchequer
  //
  //
  // ENTSEC-561.007  10/08/04
  // ------------------------
  //  HM   Changed to be VAO aware
  //
  //
  // ENTSEC-500.006  03/04/02
  // ------------------------
  //  HM   Changed version number layout from ENTSEC-v5.00.006 to allow direct
  //       comparisons independant of Beta/Release version
  //
  //  HM   Modified Initialize to retrieve ESN from Licence File as this allows
  //       the proper 7-segment ESN's to be displayed - previously the 6-segment
  //       ESN was being returned from CompOpt in Company.Dat
  //
  *********************************************************************************)
end;

//-----------------------------------------

function TThirdParty.Get_tpDescription: WideString;
begin
  Result := FDescription;
end;

procedure TThirdParty.Set_tpDescription(const Value: WideString);
begin
  FDescription := Value;
end;

//-----------------------------------------

function TThirdParty.Get_tpSystemIdCode: WideString;
begin
  Result := FSystemIdCode;
end;

procedure TThirdParty.Set_tpSystemIdCode(const Value: WideString);
begin
  FSystemIdCode := UpperCase(Copy(Value + StringOfChar(' ', 16), 1, 16));

  // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
  FSecurityNo := StrToInt (Copy (FSystemIdCode, 11, 6));
end;

//-----------------------------------------

function TThirdParty.Get_tpSecurityType: TSecurityType;
begin
  Result := FSecurityType;
end;

procedure TThirdParty.Set_tpSecurityType(Value: TSecurityType);
begin
  FSecurityType := Ord(Value);
end;

//-----------------------------------------

function TThirdParty.Get_tpSecurityCode: WideString;
begin
  Result := FSecurityCode;
end;

procedure TThirdParty.Set_tpSecurityCode(const Value: WideString);
begin
  FSecurityCode := Copy(Value + StringOfChar(' ', 16), 1, 16);
end;

//-----------------------------------------

function TThirdParty.Get_tpCurrentUsers: Integer;
begin
  Result := FCurrentUsers;
end;

//-----------------------------------------

function TThirdParty.Get_tpSystemStatus: TSystemSecurityStatus;
begin
  Result := FSystemStatus;
end;

//-----------------------------------------

function TThirdParty.Get_tpUserCount: Integer;
begin
  Result := FUserCount;
end;

//-----------------------------------------

function TThirdParty.Get_LastErrorString: WideString;
begin
  Result := FLastErrorString;
end;

//-----------------------------------------

function TThirdParty.Get_tpMessage: WideString;
begin
  Result := FMessage;
end;

procedure TThirdParty.Set_tpMessage(const Value: WideString);
begin
  FMessage := Value;
end;

//----------------------------------------------------------------------------

// Validate the required properties
function TThirdParty.ValidateProps : LongInt;
begin
  Result := 0;

  // Identifying ID Code of the Third-Party Application or Plug-In
  If (Trim(FSystemIdCode) = '') Then Begin
    Result := 1001;
    FLastErrorString := 'The System Id Code property must be set before any methods can be called';
  End; { If }

  // Security Code to prevent unauthorised access to the security details for the Third-Party Application or Plug-In
  If (Result = 0) Then
    If (Trim(FSecurityCode) = '') Then Begin
      Result := 1002;
      FLastErrorString := 'The Security Code property must be set before any methods can be called';
    End; { If }

  EXIT;

  // Textual Description of the Third-Party Application or Plug-In for on-screen display
  If (Result = 0) Then
    If (Trim(FDescription) = '') Then Begin
      Result := 1003;
      FLastErrorString := 'The Description property must be set before any methods can be called';
    End; { If }
end;

//----------------------------------------------------------------------------

function TThirdParty.GetSecurityRec : Boolean;
Var
  LStatus : SmallInt;
  KeyS    : Str255;
Begin { GetSecurityRec }
  // Build key string to find security record
  KeyS := cmPlugInSecurity + FSystemIdCode;
  LStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
  Result := (LStatus = 0);
End; { GetSecurityRec }

//----------------------------------------------------------------------------

function TThirdParty.CheckForChanges (Var Expire : Boolean) : Boolean;
Var
  Rd, Rm, Ry  : Word;
  RelDateStr  : LongDate;
  SecDays     : LongInt;
  CurrTime    : TimeTyp;
  RelDOW      : Byte;
Begin { CheckForChanges }
  result := false;
  EXIT;

  Expire := False;

  With Company^.PlugInSec Do Begin
    Result := (FDescription <> hkDesc) Or (FMessage <> hkMessage) Or (FSecurityType <> hkSecType);

    // Check that System Security is enabled and its set to a 30-Day code
    If (hkSecType In [SecSystemOnly, SecSystemAndUser]) And (hkSysRelStatus = Sys30Day) Then Begin
      // Check 30-Day Expiry Date
      JulCal (hkSysExpiry, Rd, Rm, Ry);
      RelDateStr := StrDate (Ry, Rm, Rd);
      SecDays := Abs(NoDays (Today, RelDateStr));

      RelDOW:=DayofWeek(Today);
      GetCurrTime(CurrTime);

      // Check to see if expired and OK time to expire it
      Expire := (RelDateStr < Today) And                      // Already Expired
                (RelDOW In [2..4]) And                        // Only expire on Tue-Thu
               ((CurrTime.HH >= 9) And (CurrTime.HH < 16)) Or // After 9am and before 4pm
                (SecDays > 45);                               // Unless 45 days have passed

      // Force changed if expired
      If Expire Then Result := True;
    End; { If (hkSysRelStatus = Sys30Day) }
  End; { With Company^.PlugInSec }
End; { CheckForChanges }

//----------------------------------------------------------------------------

function TThirdParty.Lock (Var RecAddr : LongInt) : LongInt;
Begin { Lock }
  // Get position of current security record
  Result := GetPos(F[CompF], CompF, RecAddr);
  If (Result = 0) then Begin
    // Set record pointer for GetDirect call
    Move (RecAddr, Company^, SizeOf(RecAddr));

    // Lock Record
    Result := GetDirect(F[CompF], CompF, RecPtr[CompF]^, CompPathK, B_MultLock);
  end;
End; { Lock }

function TThirdParty.GenRelCodes (Const NewFlg  : Byte; Var PlugInRec : HookSecurityRecType) : LongInt;
Var
  EntLic : EntLicenceRecType;
Begin { GenRelCodes }
  // Check Exchequer Licence exists in Exchequer directory
  If FileExists (EntPath + EntLicFName) Then Begin
    // Ensure ExMainCoPath isn't set as it usually ballses up the reading of a licence
    If Assigned (ExMainCoPath) then ExMainCoPath^ := '';

    // Read Liceence so we can determine the ESN
    If ReadEntLic (EntPath + EntLicFName, EntLic) Then Begin
      With PlugInRec Do Begin
        // Security Type - 0-System Rel Code, 1=User Count, 2=System + User Count
        Result := 0;

        { System Release Code - None/30-Day/Full }
        If (NewFlg = 255) Or ((hkSecType = 1) And (NewFlg In [0, 2])) Then Begin
          // New Security Record or Flag changed to include system security
          Sleep (100);
          // V5SECREL HM 10/01/02: Modified for new v5.00 Security/Release Code system
          //CurSecy        := Set_Security;
          //hkSysSecurity  := Get_ISNSecurity(ISNArrayType(LicR.licISN));
          hkSysSecurity  := Generate_ESN_BaseSecurity (VarRec2U.ISNArrayType(EntLic.licISN),
                                                       252,
                                                       PI_CheckSum(FSecurityNo),
                                                       0);
          hkSysRelStatus := 1;      // 30-Day
          hkSysExpiry    := CalcNewRelDate (30);
        End; { If ... }

        { User Count Security }
        If (NewFlg = 255) Or ((hkSecType = 0) And (NewFlg In [1, 2])) Then Begin
          // New Security Record or Flag changed to include user count
          Sleep (100);
          // V5SECREL HM 10/01/02: Modified for new v5.00 Security/Release Code system
          //CurSecy      := Set_Security;
          //hkUCSecurity := Calc_SecStr(CurSecy, False);
          hkUCSecurity := Generate_ESN_BaseSecurity (VarRec2U.ISNArrayType(EntLic.licISN),
                                                     250,
                                                     PI_CheckSum(FSecurityNo),
                                                     0);
          hkLicUCount  := 1;
          hkCurrUCount := 0;
        End; { If ... }
      End; { With PlugInRec  }
    End { If }
    Else
      // Error reading licence
      Result := 500002;
  End { If }
  Else
    // Licence not found
    Result := 500001;
End; { GenRelCodes }

//----------------------------------------------------------------------------

procedure TThirdParty.ClearRecord;
begin
  FUserCount     := 0;
  FCurrentUsers  := 0;
  FillChar (Company^, SizeOf(Company^), #0);
end;

function TThirdParty.ReadSecurity: Integer;
Var
  RecAddr : LongInt;
  Expire  : Boolean;
begin
  FLastErrorString := '';

  // Check that the basic properties are already set
  Result := ValidateProps;
  ClearRecord;

  If (Result = 0) Then Begin
    // Lock the system for exclusive use
    If WaitForCompDB Then Begin
      // Open Company.Dat for use
      Result := OpenCompDB;

      If (Result = 0) Then Begin
        // Check to see if the Hook Security Record exists
        If GetSecurityRec Then Begin
          // Got Record - check Security Id
          If (FSecurityCode = Company^.PlugInSec.hkSecCode) Then Begin
          End { If (FSecurityCode = Company^.PlugInSec.hkSecCode) }
          Else
            // Invalid Security Code - Access Denied
            Result := 4002;
        End{ If GetSecurityRec }
        else begin
          // Record Not Found - Create new security record
          FillChar (Company^, SizeOf(Company^), #0);
          With Company^ Do Begin
            RecPFix := cmPlugInSecurity;
            With PlugInSec Do Begin
              hkId           := FSystemIdCode;            // Hook Id
              hkSecCode      := FSecurityCode;            // Hook Security Id
              hkDesc         := FDescription;             // Textual Description
              hkMessage      := FMessage;                 // Sales Message

              hkSecType      := FSecurityType;            // Security Type

              // Generate new release codes
              Result := GenRelCodes (255, PlugInSec);

              // Setup index strings
              hkCode         := UniqueKey2 (CompCodeK, cmPlugInSecurity, '');  // Code (Unique Index)
              hkPath         := hkId;                     // Path (Unique Index)
            End; { With PlugInSec }
          End; { With Company }

          If (Result = 0) Then Begin
            // Add into security database
            Result := Add_Rec (F[CompF], CompF, RecPtr[CompF]^, CompPathK);
            If (Result <> 0) Then Result := Result + 200000;
          End; { If (Result = 0) }
        end;

        If (Result = 0) Then
          With Company^.PlugInSec Do Begin
            // Populate properties with Security Details
            FDescription  := Trim(hkDesc);
            // Type of security being used by the Third-Party Application or Plug-In
            FSecurityType := hkSecType;
            // System Release Code Status for the Third-Party Application or Plug-In
            FSystemStatus := hkSysRelStatus;
            // The number of users licenced to use the Third-Party Application or Plug-In
            FUserCount    := hkLicUCount;
            // The number of users currently using the Third-Party Application or Plug-In
            FCurrentUsers := hkCurrUCount;
          End; { With Company^.PlugInSec  }

        { Close Company.Dat and Free the record lock }
        CloseCompDB;
      End; { If (Result = 0) }

      CompLocked := False;
    End { If WaitForComp }
    Else
      // Timed out waiting for the lock flag
      Result := 2001;
  End; { If (Result = 0) }

  If (Result <> 0) And (Trim(FLastErrorString) = '') Then
    GetErrorString (Result);
End;

//----------------------------------------------------------------------------

Procedure TThirdParty.GetErrorString (Var ErrNo : LongInt);
Begin
    Case ErrNo Of
    -999             : FLastErrorString := 'ODD Timesheet Control is not licensed';

      0              : ;

      // Errors in ValidateProps - FLastErrorString already set
      //1001         : FLastErrorString := 'The System Id Code property must be set before any methods can be called';
      //1002         : FLastErrorString := 'The Security Code property must be set before any methods can be called';
      //1003         : FLastErrorString := 'The Description property must be set before any methods can be called';

      // Errors in WaitForCompDB
      2001           : FLastErrorString := 'The system timed out waiting to check the Security';

      // Errors in OpenCompDB
      3001           : FLastErrorString := 'The Security Database cannot be found';
      //3002         : See 100000..199999

      // Errors in ReadSecurity
      // 4001        : See 200000..299999
      4002           : FLastErrorString := 'Invalid Security Code - Access Denied';
      //4003         : See 300000..399999
      //4004         : See 400000..499999
      4005           : FLastErrorString := 'Invalid System Id - Security Record not found';

      // Errors in GenRelCodes/hsGetSRC
      //10000        : See 500000..599999
      10001          : FLastErrorString := 'Error reading Exchequer Licence';

      // Btrieve Error opening Company.Dat
      100000..199999 : Begin
                         FLastErrorString := 'Btrieve Error ' +
                                             IntToStr(ErrNo - 100000) +
                                             ' opening the Security Database';
                         ErrNo := 3002;
                       End;

      // Btrieve Error adding new security record
      200000..299999 : Begin
                         FLastErrorString := 'Btrieve Error ' +
                                             IntToStr(ErrNo - 200000) +
                                             ' adding a Security Record into the Security Database';
                         ErrNo := 4001;
                       End;

      // Btrieve Error locking existing security record
      300000..399999 : Begin
                         FLastErrorString := 'Btrieve Error ' +
                                             IntToStr(ErrNo - 300000) +
                                             ' locking the Security Record';
                         ErrNo := 4003;
                       End;

      // Btrieve Error updating existing security record
      400000..499999 : Begin
                         FLastErrorString := 'Btrieve Error ' +
                                             IntToStr(ErrNo - 400000) +
                                             ' locking the Security Record';
                         ErrNo := 4004;
                       End;

      // Error loading EntComp.DLL
      500000..599999 : Begin
                         FLastErrorString := 'Error ' +
                                             IntToStr(ErrNo - 500000) +
                                             ' loading EntComp.Dll from ' + QuotedStr(EntPath);
                         ErrNo := 10000;
                       End;
    Else
      FLastErrorString := 'Unknown Error (' + IntToStr(ErrNo) + ') in ReadSecurity';
    End; { Case Result }
end;

//----------------------------------------------------------------------------

function TThirdParty.ChangeUserCount (Const ChangeBy : SmallInt) : Integer;
Var
  RecAddr : LongInt;
begin
  FLastErrorString := '';

  // Check that the basic properties are already set
  Result := ValidateProps;
  ClearRecord;

  If (Result = 0) Then Begin
    // Lock the system for exclusive use
    If WaitForCompDB Then Begin
      // Open Company.Dat for use
      Result := OpenCompDB;

      If (Result = 0) Then Begin
        // Check to see if the Hook Security Record exists
        If GetSecurityRec Then Begin
          // Got Record - check Security Id
          If (FSecurityCode = Company^.PlugInSec.hkSecCode) Then Begin
            // AOK - Lock it and update the User Count
            Result := Lock(RecAddr);
            If (Result = 0) Then Begin
              // Apply Changes
              With Company^.PlugInSec Do
                If (ChangeBy = 0) Then
                  hkCurrUCount := 0
                Else Begin
                  hkCurrUCount := hkCurrUCount + ChangeBy;
                  If (hkCurrUCount < 0) Then hkCurrUCount := 0;
                End; { Else }

              // Update
              Result := Put_Rec (F[CompF], CompF, RecPtr[CompF]^, CompPathK);
              If (Result <> 0) Then Result := Result + 400000;

              // Unlock record
              UnlockMultiSing(F[CompF], CompF, RecAddr);
            End { If (Result = 0) }
            Else
              // Error Lockign Security Record
              Result := 300000 + Result;
          End { If (FSecurityCode = Company^.PlugInSec.hkSecCode) }
          Else
            // Invalid Security Code - Access Denied
            Result := 4002;
        End { If GetSecurityRec }
        Else
          // Invalid System Id - Access Denied
          Result := 4005;

        { Close Company.Dat and Free the record lock }
        CloseCompDB;
      End; { If (Result = 0) }

      CompLocked := False;
    End { If WaitForComp }
    Else
      // Timed out waiting for the lock flag
      Result := 2001;
  End; { If (Result = 0) }

  If (Result <> 0) And (Trim(FLastErrorString) = '') Then
    GetErrorString (Result);
end;

//----------------------------------------------------------------------------

function TThirdParty.AddUserCount: Integer;
begin
  Result := ChangeUserCount (1);
end;

//----------------------------------------------------------------------------

function TThirdParty.RemoveUserCount: Integer;
begin
  Result := ChangeUserCount (-1);
end;

//----------------------------------------------------------------------------

function TThirdParty.ResetUserCount: Integer;
begin
  Result := ChangeUserCount (0);
end;

//----------------------------------------------------------------------------

function TThirdParty.Get_ExchequerSiteNumber: WideString;
begin
  Result := FESN;
end;

//----------------------------------------------------------------------------


initialization
//  TAutoObjectFactory.Create(ComServer, TThirdParty, Class_ThirdParty,
//    ciSingleInstance, tmApartment);

  // NOTE: This section gets called ONCE per process

  // Define the structure of Company.Dat and initialise the global Btrieve stuff
  New(Company);
  New(SyssCompany);
  DefineCompany;

  CompLocked := False;

  FindEnterpriseDir;
Finalization
  // HM 25/04/02: Removed as was causing RegSvr32 to crash on SOME WIN98/ME workstations
  //CloseCompDB;

  Dispose(Company);
  Dispose(SyssCompany);
end.
