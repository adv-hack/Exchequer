unit HookSec;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

// HM 25/08/04: Replaced function with stub as this is long since obselete

Interface

//Uses Classes, Dialogs, FileCtrl, SysUtils, Windows, GlobVar, VarRec2U;
Uses Dialogs, Forms;

//
// OLD Pre-v5.00 Hook Security Routines
//

//------------------------------------

//Type
//  ModuleSecurityRecType = Record
//    msSecurityCode      : String[10];
//    msReleaseCode       : String[10];
//    msReleaseDate       : Real48;
//
//    msSpare             : Array [1..800] Of Char;
//  End; { ModuleSecurityRecType }
//
//  //------------------------------------
//
//  ValidCodesRecType = Record
//    vcESN           : ISNArrayType;
//    vc30DayCode     : LongInt;
//    vcFullCode      : LongInt;
//  End; { ValidCodesRecType }

  //------------------------------------

// Function called from hooks to check security code status, a list of
// numbers already used can be found in CheckSec.Pas
Function CheckHookSecurity (Const ModuleName : ShortString;
                            Const HookNo     : LongInt;
                            Const ModuleDesc : ShortString) : Boolean; StdCall;

//----------------------------------------------------------------

implementation

// Function called from hooks to check security code status, a list of
// numbers already used can be found in CheckSec.Pas
Function CheckHookSecurity (Const ModuleName : ShortString;
                            Const HookNo     : LongInt;
                            Const ModuleDesc : ShortString) : Boolean; StdCall;
Var
  Buffer : array[0..255] of Char;
  Len    : SmallInt;
Begin
  MessageDlg ('Error: The CheckHookSecurity function in EntComp.Dll has been called by ' + Application.ExeName + ', please notify your Technical Support', mtError, [mbOK], 0);
  Result := False;
End;


//Uses ETStrU, ETMiscU, ETDateU, Crypto, LicRec, EntLic, HelpSupU, SecureU,
//     HookRel, VarFPosU, SecSup2U;

//----------------------------------------------------------------

//Var
//  // Path of Enterprise Programs directory (including trailing '\')
//  CSVar_EnterpriseDir : ShortString;



(*****
//----------------------------------------------------------------

// Extract Enterprise Programs directory from Module Path + Name
Function FindEntDir : Boolean;
Var
  Buffer : array[0..255] of Char;
  Len    : SmallInt;
Begin { FindEntDir }
  // Find directory of hook - should contain Entrprse.Dat
  Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  If (Len > 0) Then Begin
    // Extract Enterprise directory from Hook DLL Path
    CSVar_EnterpriseDir := IncludeTrailingBackslash(ExtractFilePath(Buffer));

    // Directory is valid if Entrprse.Dat exists
    Result := FileExists(CSVar_EnterpriseDir + 'Entrprse.Dat');
  End { If (Len > 0) }
  Else
    // Shouldn't ever happen, but just in case
    Raise Exception.Create ('CheckSec 2001: Unable to get Module Name from Windows API');
End; { FindEntDir }

//----------------------------------------------------------------

// Loads and returns the system ESN from Entrprse.Dat in the enterprise direcctory
Function LoadESN : ISNArrayType;
Var
  TmpPath : ShortString;
  LicR    : EntLicenceRecType;
  I       : Byte;
Begin { LoadESN }
  // Read Licence Details
  TmpPath := ExMainCoPath^;
  ExMainCoPath^ := '';
  If ReadEntLic (CSVar_EnterpriseDir + 'Entrprse.Dat', LicR) Then
    // Copy out and return ESN
    For I := Low(Result) To High(Result) Do
      Result[I] := LicR.licISN[I]
  Else
    // Unable to open Enterprise.Dat and read licence
    Raise Exception.Create ('CheckSec 3001: Unable to read system ESN');
  ExMainCoPath^ := TmpPath;
End; { LoadESN }

//----------------------------------------------------------------

// Initialises a new module Security Record
Procedure InitModuleSecurity (Const SystemESN : ISNArrayType; Var ModSecRec : ModuleSecurityRecType);
Begin { InitModuleSecurity }
  FillChar (ModSecRec, SizeOf(ModSecRec), #0);
  With ModSecRec Do Begin
    // Set Security Code
    msSecurityCode := Get_ISNSecurity(SystemESN);

    // Leave Release Code and Expiry Date empty
    //msReleaseCode
    //msReleaseDate
  End; { With }
End; { InitModuleSecurity }

//----------------------------------------------------------------

// Updates the Module Licence file with changes
Procedure StoreModuleSecurity (Const ModSecR : ModuleSecurityRecType; Const LicFName : ShortString);
Var
  LocModSecR : ModuleSecurityRecType;
Begin { StoreModuleSecurity }
  // Open and Write new details
  With TFileStream.Create (LicFName, fmCreate Or fmShareExclusive) Do
    Try
      // Use local copy to avoid encrypting the working information
      LocModSecR := ModSecR;

      // encrypt data
      ChangeCryptoKey (17937);
      EncodeData (@LocModSecR, SizeOf(LocModSecR));

      // Write details to licence file
      Write (LocModSecR, SizeOf(LocModSecR));
    Finally
      Free;
    End;
End; { StoreModuleSecurity }

//----------------------------------------------------------------

Procedure CreateModuleSecurity (Const SystemESN : ISNArrayType; Const LicFName : ShortString);
Var
  ModSecRec : ModuleSecurityRecType;
Begin { CreateModuleSecurity }
  // Create basic record
  InitModuleSecurity (SystemESN, ModSecRec);

  // Create Licence file
  StoreModuleSecurity (ModSecRec, LicFName);
End; { CreateModuleSecurity }

//----------------------------------------------------------------

// Loads the Module Security information from the Module Security File, if
// the file doesn't exist it will call CreateModuleSecurity to create it
Function LoadModuleSecurity (Const SystemESN : ISNArrayType; Const ModuleName : ShortString) : ModuleSecurityRecType;
Var
  ModSecRec : ModuleSecurityRecType;
Begin { LoadModuleSecurity }
  // Check File Exists
  If (Not FileExists (CSVar_EnterpriseDir + Trim (ModuleName) + '.Dat')) Then
    // File Doesn't Exist - Create It
    CreateModuleSecurity (SystemESN, CSVar_EnterpriseDir + Trim (ModuleName) + '.Dat');

  // Open and Read
  With TFileStream.Create (CSVar_EnterpriseDir + Trim (ModuleName) + '.Dat', fmOpenReadWrite Or fmShareExclusive) Do
    Try
      // Load Module Security info
      Read (ModSecRec, SizeOf(ModSecRec));

      // Decrypt info
      ChangeCryptoKey (17937);
      DecodeData (@ModSecRec, SizeOf(ModSecRec));

      // Return Security record
      Result := ModSecRec;
    Finally
      Free;
    End;
End; { LoadModuleSecurity }

//----------------------------------------------------------------

// Checks to see if the ESN and Security Code match
Function CheckESN (Const SystemESN : ISNArrayType; Const ModSecR : ModuleSecurityRecType) : Boolean;
Var
  SecyStr   : Str20;
  CS, Secy  : LongInt;
Begin { CheckESN }
  // Calculate checksum from ESN
  CS := ISN_CheckSum (SystemESN);

  // Calculate value for Security Code
  Secy := Calc_Security (ModSecR.msSecurityCode, BOff);

  // Turn into string
  SecyStr := Form_Int (Secy, 0);

  // Compare
  Result := (CS = IntStr(SecyStr[Length(SecyStr)]));
End; { CheckESN }

//----------------------------------------------------------------

// Checks the Security/Release Code status and returns True if a new Release
// Code is required to access the hook
Function NeedReleaseCode (Const ModSecR : ModuleSecurityRecType; Var ValidCodes : ValidCodesRecType) : Boolean;
Var
  CurRel, CurSecy      : LongInt;
  Rd, Rm, Ry           : Word;
  Hour, Min, Sec, MSec : Word;
  WantCheck            : Boolean;
Begin { NeedReleaseCode }
  With ModSecR, ValidCodes Do Begin
    // Step1: Determine if we should check for a valid Release Code
    // Always check if no Expiry Date - either No Code or Full Code
    WantCheck := (msReleaseDate = 0);

    If (Not WantCheck) Then Begin
      // Release Date Set - force check if it has expired and max period has passed
      JulCal (msReleaseDate, Rd, Rm, Ry);
      WantCheck := (Abs(NoDays (Today, StrDate(Ry,Rm,Rd))) >= AbsMaxDays);
    End; { If (Not WantCheck) }

    If (Not WantCheck) Then Begin
      // Check Day and Time - only ask for codes Tue-Thur between 9:00am and 4:00pm
      DecodeTime(Now, Hour, Min, Sec, MSec);
      WantCheck := (SysUtils.DayOfWeek (Now) In [3..5]) And (Hour >= 9) And (Hour < 16);
    End; { If (Not WantCheck) }

    If WantCheck Then Begin
      // Step2: Check Release Code and Expiry Date
      // Calculate valid release code values (codes used later in RelCode dialog)
      CurSecy := Calc_Security(msSecurityCode, BOff);
      vcFullCode := CurSecy + SecRelCode;
      vc30DayCode := CurSecy + SecXtra30Code;

      // Check 30-Day Release Date to see if 30-Day
      If (msReleaseDate = 0) Then Begin
        // Not 30-Day - Either not set or Full - check Release Code

        // Convert current Release Code into value
        CurRel := Calc_Security (msReleaseCode, BOn);

        // Return True if not the Full Release Code
        Result := (CurRel <> vcFullCode);
      End { If (msReleaseDate = 0) }
      Else Begin
        // 30-Day - Check Expiry Date
        JulCal (msReleaseDate, Rd, Rm, Ry);
        Result := (NoDays (Today, StrDate(Ry,Rm,Rd)) <= 0)
      End; { Else }
    End { If Wantcheck }
    Else
      // No checking to perform - pass automatically
      Result := False;
  End; { With ModSecR, ValidCodes }
End; { NeedReleaseCode }

//----------------------------------------------------------------

Function CheckHookSecurity (Const ModuleName : ShortString;
                            Const HookNo     : LongInt;
                            Const ModuleDesc : ShortString) : Boolean; StdCall;
Var
  ModSecurity  : ModuleSecurityRecType;
  ValidCodes   : ValidCodesRecType;
Begin { CheckHookSecurity }
  Result := False;

  // Step 1: Identify programs directory
  If FindEntDir Then Begin
    // Step 2: Get ESN from Licence file
    ValidCodes.vcESN := LoadESN;

    // Step 3: Check for Module Security File (Create if missing)
    ModSecurity := LoadModuleSecurity(ValidCodes.vcESN, ModuleName);

    // Step 4: Check Security Code is valid for ESN
    If Not CheckESN (ValidCodes.vcESN, ModSecurity) Then
      // ESN and Security Code do not match - re-initialise security
      InitModuleSecurity (ValidCodes.vcESN, ModSecurity);

    // Step 5: Check for valid Release Code
    If NeedReleaseCode (ModSecurity, ValidCodes) Then Begin
      // Release Code required
      Result := InputReleaseCode (ModSecurity, ValidCodes, CSVar_EnterpriseDir, ModuleDesc);

      // Store any changes
      StoreModuleSecurity (ModSecurity, CSVar_EnterpriseDir + Trim (ModuleName) + '.Dat');
    End { If NeedReleaseCode }
    Else
      // Release Code not needed
      Result := True;
  End { If FindEntDir }
  Else
    Raise Exception.Create ('EntHooks 1000: Unable to identify Enterprise Programs Directory');
End; { CheckHookSecurity }

//----------------------------------------------------------------

Initialization
  CSVar_EnterpriseDir := '';
*****)
end.
