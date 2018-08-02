unit LicFuncs;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, FileCtrl, Forms, SysUtils, Windows, LicRec, SetupU,
     CompUtil, IniFiles;


{ Reads the Licence File and setups the variables within the WISE Script }
function SCD_ProcessLicF (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

{ Reads the Licence and setups the Module Rights variable within the WISE Script }
Function SCD_SetInstModRights (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

Function SCD_SetAutoModRights (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

Function SCD_SetUpgModRights (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

// Reads the existing Licence File in the Enterprise directory and setups the
// licence variables within the WISE Script for a Workstation Setup
Function SCD_SetWSInstDets (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

// Extracts the path of the IRIS Licence file from the cdm line params for the LITE Installer
function SCD_GetIRISLicFilename (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

{$IFDEF SETD}
  Procedure WriteLicToWise (var   DLLParams : ParamRec;
                            Const LicFile   : String;
                            Const CDLicR    : CDLicenceRecType;
                            Const OpType    : Byte;
                            Const ExtFields : Boolean = False);
{$ENDIF}

implementation


Uses LicFuncU, WLicFile, EntLic;


Procedure WriteLicToWise (var   DLLParams : ParamRec;
                          Const LicFile   : String;
                          Const CDLicR    : CDLicenceRecType;
                          Const OpType    : Byte;
                          Const ExtFields : Boolean = False);
// OpType: 0=Standard Install/Upgrade, 1=Auto-Upgrade Details
// ExtFields: Write LITE Extended licencing fields
Var
  S : String;
Begin { WriteLicToWise }
  If (OpType = 0) Then Begin
    { Licence File Name }
    SetVariable (DLLParams, 'I_LICFILE', LicFile);
  End; { If (OpType = 0) }

  With CDLicR Do Begin
    { CD Country - 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
    SetVariable (DLLParams, 'I_COUNTRY', IntToStr(licCountry));

    If (OpType = 0) Then Begin
      { CD Type - 0=Install, 1=Upgrade, 2=Auto-Upgrade }
      SetVariable (DLLParams, 'I_TYPE', IntToStr(licType));
    End; { If (OpType = 0) }

    { Licence Type - 0=Customer/End-User, 1=Demo/Reseller }
    SetVariable (DLLParams, 'I_LICTYPE', IntToStr(licLicType));

    { CD Serial Number }
    SetVariable (DLLParams, 'I_SERIAL', licSerialNo);

    { Currency Version - 0-Prof, 2-Euro, 3-MC }
    SetVariable (DLLParams, 'L_CURRVER', IntToStr(licEntCVer));

    { Base Modules - 0-Basic, 1-Stock, 2-SPOP }
    SetVariable (DLLParams, 'L_BASE', IntToStr(licEntModVer));

    { Client-Server - Y/N }
    SetVariable (DLLParams, 'L_CLSVR', IntToStr(licEntClSvr));

    { User Count }
    SetVariable (DLLParams, 'L_UCOUNT', IntToStr(licUserCnt));

    // MH 25/04/07: Added Database Type for v6.00 to allow support for Pervasive.SQL and MS SQL Server editions of Exchequer
    SetVariable (DLLParams, 'L_DBTYPE', IntToStr(licEntDB));

    { Licenced Pervasive.SQL Version - 0-None, 1=NT, 2=Netware }
    SetVariable (DLLParams, 'P_VERSION', IntToStr(licClServer));

    { Licenced Pervasive.SQL User Count }
    SetVariable (DLLParams, 'P_UCOUNT', IntToStr(licCSUserCnt));

    { HM 03/10/03: Pervasive.SQL Licence Key }
    SetVariable (DLLParams, 'P_LICKEY', licPSQLLicKey);

    { HM 07/10/03: Workgroup Engine version from CD Licence }
    SetVariable (DLLParams, 'WG_VERSION', IntToStr(licPSQLWGEVer));

    { Account Stock Analysis - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_ASA', IntToStr(licModules[modAccStk]));

    { Toolkit DLL - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_DLL', IntToStr(licModules[modToolDLL]));

    { Toolkit DLL Runtime - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_DLLRUN', IntToStr(licModules[modToolDLLR]));

    { Import Module - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_IMPORT', IntToStr(licModules[modImpMod]));

    { Job Costing - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_JC', IntToStr(licModules[modJobCost]));

    { ODBC - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_ODBC', IntToStr(licModules[modODBC]));

    { Report Writer - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_RW', IntToStr(licModules[modRepWrt]));

    { Telesales - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_TELES', IntToStr(licModules[modTeleSale]));

    { eBusiness - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_EBUS', IntToStr(licModules[modEBus]));

    { Paperless - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_PAPER', IntToStr(licModules[modPaperless]));

    { OLE Save Funcs - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_OLESAVE', IntToStr(licModules[modOLESave]));

    { Commitment Accounting - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_COMMIT', IntToStr(licModules[modCommit]));

    { HM 19/02/01: Trade Counter - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_TRADE', IntToStr(licModules[modTrade]));

    { HM 03/07/01: Works Order Processing - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_STDWOP', IntToStr(licModules[modStdWOP]));
    SetVariable (DLLParams, 'ML_PROWOP', IntToStr(licModules[modProWOP]));

    { HM 19/02/01: Elerts - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_ELERTS', IntToStr(licModules[modElerts]));

    { HM 19/08/01: Elerts - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_ENHSEC', IntToStr(licModules[modEnhSec]));

    { HM 28/02/05: VisualRW - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_FULLSTK', IntToStr(licModules[modFullStock]));
    SetVariable (DLLParams, 'ML_VISRW', IntToStr(licModules[modVisualRW]));

    { HM 26/10/06: E-Banking - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_EBANKING', IntToStr(licModules[modEBanking]));

    { HM 01/11/06: CIS - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_CIS', IntToStr(licModules[modCISRCT]));

    { HM 09/01/07: Outlook Dynamic Dashboard - 0-No, 1-30-Day, 2-Full }
    SetVariable (DLLParams, 'ML_OUTLOOK', IntToStr(licModules[modOutlookDD]));

    // MH 28/03/06: Extended to handle differing descriptions for IAO - 0=Exchequer, 1=LITE Customer, 2=LITE Accountant
    If (CDLicR.licProductType = 0) Then
    Begin
      // Exchequer Version Description - blank for Auto-Upgrades!
      If (licType <> 2) Then Begin
        S := licCurrVerToStr (licEntCVer) + '/' + licEntModsToStr (licEntModVer);
        If (S[Length(S)] <> '/') Then S := S + '/';
        If (licEntClSvr = 1) Then S := S + 'CS';
        If (S[Length(S)] <> '/') Then S := S + '/';
        S := S + IntToStr(licUserCnt);
        SetVariable (DLLParams, 'D_ENTVER', S);
      End; { If }
    End // If (CDLicR.licProductType = 0)
    Else If (CDLicR.licProductType In [1, 2]) Then
    Begin
      S := licCDEntVersion (CDLicR, False);  // Get long description
      SetVariable (DLLParams, 'D_ENTVER', S);
    End; // If (CDLicR.licProductType In [1, 2])

    { Licence Name }
    SetVariable (DLLParams, 'D_COMPNAME', licCompany);

    { Pervasive.SQL Engine Operating System }
    SetVariable (DLLParams, 'PD_ENGOS', licCSEngStr (licClServer, True));

    { Pervasive.SQL Engine Operating System }
    SetVariable (DLLParams, 'PD_ENGDESC', 'Pervasive.SQL for ' + licCSEngStr (licClServer, False));

    // HM 07/10/03 v7.0: Added Exchequer Edition support for the Small Business Edition
    SetVariable (DLLParams, 'L_EXCHEQUEREDITION', IntToStr(Ord(licExchequerEdition)));

    If ExtFields Then
    Begin
      // Product Type
      SetVariable (DLLParams, 'EL_PRODUCTTYPE', IntToStr(licProductType));

      // CD-Key
      SetVariable (DLLParams, 'EL_CDKEY', FormatCDKey(licCDKey));
    End; // If ExtFields
  End; { With LicRec }
End; { WriteLicToWise }

//-------------------------------------------------------------------------

// Extracts the path of the IRIS Licence file from the cdm line params for the LITE Installer
function SCD_GetIRISLicFilename (var DLLParams: ParamRec): LongBool;
Var
  DLLStatus  : LongInt;
  I          : SmallInt;
  S          : ShortString;
Begin // SCD_GetIRISLicFilename
  DLLStatus := 0;

  // Check for path to licence file in parameters
  If (ParamCount > 0) Then
  Begin
    For I := 1 To ParamCount Do
    Begin
      S := UpperCase (ParamStr(I));

      If (Pos('/IL:', S) = 1) Then
      Begin
        // IRIS Licence file path
        SetVariable (DLLParams, 'I_IRISLICFILE', Copy (S, 5, Length(S) - 3));
        Break;
      End; // If (Pos('/UD:', S) = 1)
    End; // For I
  End; // If (ParamCount > 0)

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_GetIRISLicFilename

//-------------------------------------------------------------------------

{ Reads the Licence File and setups the variables within the WISE Script }
function SCD_ProcessLicF (var DLLParams: ParamRec): LongBool;
Var
  LicRec     : CDLicenceRecType;
  DLLStatus  : LongInt;
  S, LicFile : String;
  GotLic     : Boolean;
  I          : Byte;
  W_Install  : String;

  Function BoolToStr(Const Value : Boolean) : ShortString;
  Begin { BoolToStr }
    If Value Then Result := 'Y' Else Result := 'N';
  End; { BoolToStr }

Begin { SCD_ProcessLicF }
  DLLStatus := 1000;

  GotLic := False;
  LicFile := '';

  { Check for pointer to licence file in parameters }
  If (ParamCount > 0) Then Begin
    For I := 1 To ParamCount Do Begin
      S := UpperCase (ParamStr(I));

      If (Pos('/LF:', S) = 1) Then
      Begin
        { Found licence file name }
        LicFile := Copy (S, 5, Length(S) - 3);
      End // If (Pos('/LF:', S) = 1)
      Else If (Pos('/UD:', S) = 1) Then
      Begin
        // LITE Upgrade Directory
        SetVariable (DLLParams, 'EL_UPGRADEDIR', Copy (S, 5, Length(S) - 3));
      End; // If (Pos('/UD:', S) = 1)
    End;  { For }
  End; { If }

  // HM 24/05/99: Hack added for development which enables licences to be
  //              loaded whilst running under Wise in the S: development dir
  If (Trim(LicFile) = '') And (UpperCase(ExtractFilePath(Application.ExeName)) = 'S:\MASTER\SINGLE\SETUP\') Then Begin
    { Design Time - no licence selected }
    With TOpenDialog.Create(Application) Do Begin
      Filter := 'Exchequer Hidden Licence (*.TMP)|*.TMP;All Files (*.*)|*.*';
      InitialDir := ExtractFilePath(Application.ExeName);
      Options := [ofHideReadOnly,ofPathMustExist,ofFileMustExist];
      Title := 'Load Licence File';

      If Execute Then
        LicFile := FileName;
    End; { With }
  End; { If }

  If FileExists(LicFile) Then Begin
    { Read in licence file }
    GotLic := ReadLicFile (LicFile, LicRec);
  End; { If FileExists }

  If GotLic Then
  Begin
    // Got a valid licence - check what system we are running under
    GetVariable (DLLParams, 'V_INSTALL', W_Install);

    WriteLicToWise (DLLParams, LicFile, LicRec, 0, W_Install='L');

    DLLStatus := 0;
  End; { If }

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_ProcessLicF }


{-----------------------------------------------------------------------------}


// Reads the Licence and setups the Module Rights variable within the WISE
// Script for a New Installation
// 1000  Unknown Error
// 1001  Unknown Exception
// 1002  Cannot read Licence File
Function SCD_SetInstModRights (var DLLParams: ParamRec): LongBool;
Var
  LicR                                  : CDLicenceRecType;
  DLLStatus                             : LongInt;
  WiseStr, W_LicF, AvMod, DefMod        : String;
Begin { SCD_SetInstModRights }
  DLLStatus := 1000;

  Try
    { Find out if we have a licence }
    GetVariable (DLLParams, 'I_LICTYPE', WiseStr);

    If (WiseStr <> '2') Then Begin
      { Get Licence File Name }
      GetVariable (DLLParams, 'I_LICFILE', W_LicF);

      If ReadLicFile (W_LicF, LicR) Then Begin
        { A - Core Program Files }
        AvMod := 'a';
        DefMod := 'A';

        { B - eBusiness }
        If (LicR.licModules[modEBus] > 0) Then Begin
          AvMod := AvMod + 'B';
          DefMod := DefMod + 'B';
        End; { If (LicR.licModules[modEBus] > 0) }

        { C - Toolkit DLL (Developer Files) }
        If (LicR.licModules[modToolDLL] > 0) Then Begin
          AvMod := AvMod + 'C';
          DefMod := DefMod + 'C';
        End; { If (LicR.licModules[modToolDLL] > 0) }

        { D - Import }
        If (LicR.licModules[modImpMod] > 0) Then Begin
          AvMod := AvMod + 'D';
          DefMod := DefMod + 'D';
        End; { If (LicR.licModules[modImpMod] > 0) }

        { E - ODBC }
        If (LicR.licModules[modODBC] > 0) Then Begin
          AvMod := AvMod + 'E';
          DefMod := DefMod + 'E';
        End; { If (LicR.licModules[modODBC] > 0) }

        { F - Report Writer }
        If (LicR.licModules[modRepWrt] > 0) Then Begin
          AvMod := AvMod + 'F';
          DefMod := DefMod + 'F';
        End; { If (LicR.licModules[modRepWrt] > 0) }

        { G - Client-Server }
        // HM 02/10/03: Changed to '= 1' from '> 0' as 2 is being used for Workgroup Engine (Non C/S)
        If (LicR.licEntClSvr = 1) Then Begin
          AvMod := AvMod + 'G';
          DefMod := DefMod + 'G';
        End; { If (LicR.licEntClSvr = 1) }

        { H - ODBC - Crystall Add-In }
        If (LicR.licModules[modODBC] > 0) Then Begin
          AvMod := AvMod + 'H';
          DefMod := DefMod + 'H';
        End; { If (LicR.licModules[modODBC] > 0) }

        { I - Barcode Fonts }
        AvMod := AvMod + 'I';

        { J - Paperless Module }
        If (LicR.licModules[modPaperless] > 0) Then Begin
          AvMod := AvMod + 'J';
          DefMod := DefMod + 'J';
        End; { If (LicR.licModules[modPaperless] > 0) }

        // HM 11/12/01: Removed as no longer used in v5.00
        { K - Multi-Company Manager }
        {AvMod := AvMod + 'K';
        DefMod := DefMod + 'K';}

        { L - OLE Save Funcs }
        If (LicR.licModules[modOLESave] > 0) Then Begin
          AvMod := AvMod + 'L';
          DefMod := DefMod + 'L';
        End; { If (LicR.licModules[modOLESave] > 0) }

        { M - Trade Counter }
        If (LicR.licModules[modTrade] > 0) Then Begin
          AvMod := AvMod + 'M';
          DefMod := DefMod + 'M';
        End; { If (LicR.licModules[modTrade] > 0) }

        { N - Works Order Processing }
        If (LicR.licModules[modStdWOP] > 0) Or (LicR.licModules[modProWOP] > 0) Then Begin
          AvMod := AvMod + 'N';
          DefMod := DefMod + 'N';
        End; { If (LicR.licModules[modStdWOP] > 0) ... }

        { O - Elerts / Sentimail }
        If (LicR.licModules[modElerts] > 0) Then Begin
          AvMod := AvMod + 'O';
          DefMod := DefMod + 'O';
        End; { If (LicR.licModules[modElerts] > 0) }

        { P - Visual Report Writer }
        If (LicR.licModules[modVisualRW] > 0) Then Begin
          AvMod := AvMod + 'P';
          DefMod := DefMod + 'P';
        End; { If (LicR.licModules[modVisualRW] > 0) }

        { Q - E-Banking }
        If (LicR.licModules[modEBanking] > 0) Then Begin
          AvMod := AvMod + 'Q';
          DefMod := DefMod + 'Q';
        End; // If (LicR.licModules[modEBanking] > 0)

        // R - Outlook Dynamic Dashboard
        If (LicR.licModules[modOutlookDD] > 0) Then
        Begin
          AvMod := AvMod + 'R';
          DefMod := DefMod + 'R';
        End; // If (LicR.licModules[modOutlookDD] > 0)

        { Update Wise variables }
        SetVariable(DLLParams, 'V_AVMOD',  AvMod);
        SetVariable(DLLParams, 'V_DEFMOD', DefMod);

        // HM 07/10/03: Added Workgroup Engine support
        SetVariable (DLLParams, 'WG_VERSION', IntToStr(LicR.licPSQLWGEVer));

        { AOK }
        DLLStatus := 0;
      End { If ReadLicFile }
      Else Begin
        { Cannot read Licence File }
        DLLStatus := 1002;
      End; { Else }
    End; { If }
  Except
    { Unknown Exception }
    On Ex:Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetInstModRights }


{-----------------------------------------------------------------------------}


// Reads the existing Licence File in the Enterprise directory and setups the
// Module Rights variable within the WISE Script for an Auto-Upgrade
// 1000  Unknown Error
// 1001  Unknown Exception
// 1002  Cannot read Enterprise Licence File
Function SCD_SetAutoModRights (var DLLParams: ParamRec): LongBool;
Var
  IniF                                  : TIniFile;
  LicR                                  : EntLicenceRecType;
  DLLStatus                             : LongInt;
  W_TempEml, W_TempFax,
  WiseStr, W_MainDir, AvMod, DefMod     : String;
Begin { SCD_SetAutoModRights }
  DLLStatus := 1000;

  Try
    { Find out if we have a licence }
    GetVariable (DLLParams, 'I_LICTYPE', WiseStr);

    If (WiseStr <> '2') Then Begin
      { Get Enterprise Directory Path }
      GetVariable (DLLParams, 'V_MAINDIR', W_MainDir);
      FixPath (W_MainDir);

      If ReadEntLic (W_MainDir + EntLicFName, LicR) Then Begin
        { Open SETUP.USR ini file to read in details of last install/upgrade }
        IniF := TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR');
        Try
          { A - Core Program Files }
          AvMod := 'A';
          DefMod := 'A';

          { B - eBusiness }
          If (LicR.licModules[modEBus] > 0) Then Begin
            AvMod := AvMod + 'B';

            { Check its installed }
            If FileExists(W_MainDir + 'EnEBus.Exe') Or FileExists(W_MainDir + 'EBusAdmn.Exe') Then
              DefMod := DefMod + 'B';
          End; { If (LicR.licModules[modEBus] > 0) }

          { C - Toolkit DLL (Developer Files) }
          If (LicR.licModules[modToolDLL] > 0) Then Begin
            AvMod := AvMod + 'C';

            { Check its installed }
            If DirectoryExists(W_MainDir + 'SDK') Or DirectoryExists(W_MainDir + 'TOOLKIT') Then
              DefMod := DefMod + 'C';
          End; { If (LicR.licModules[modToolDLL] > 0) }

          { D - Import }
          If (LicR.licModules[modImpMod] > 0) Then Begin
            AvMod := AvMod + 'D';

            { Check its installed }
            // MH 10/09/2009: Modified to look for new importer application (FRv6.2.002)
            //If FileExists(W_MainDir + 'Import\ExImport.Exe') Then
            If FileExists(W_MainDir + 'Import\Importer.Exe') Then
              DefMod := DefMod + 'D';
          End; { If (LicR.licModules[modImpMod] > 0) }

          { E - ODBC }
          If (LicR.licModules[modODBC] > 0) Then Begin
            AvMod := AvMod + 'E';

            { Check its installed }
            If FileExists(W_MainDir + 'File.Ddf') Then
              DefMod := DefMod + 'E';
          End; { If (LicR.licModules[modODBC] > 0) }

          { F - Report Writer }
          If (LicR.licModules[modRepWrt] > 0) Then Begin
            AvMod := AvMod + 'F';

            { Check its installed }
            If FileExists(W_MainDir + 'ExRepWrt.Exe') Or FileExists(W_MainDir + 'EnRepWrt.Exe') Then
              DefMod := DefMod + 'F';
          End; { If (LicR.licModules[modRepWrt] > 0) }

          { G - Client-Server }
          // HM 02/10/03: Changed to '= 1' from '> 0' as 2 is being used for Workgroup Engine (Non C/S)
          If (LicR.licEntClSvr = 1) Then Begin
            AvMod := AvMod + 'G';

            { Check its installed }
            If FileExists(W_MainDir + 'W32SSet.Exe') Then
              DefMod := DefMod + 'G';
          End; { If (LicR.licEntClSvr = 1) }

          { H - ODBC - Crystall Add-In }
          If (LicR.licModules[modODBC] > 0) Then Begin
            AvMod := AvMod + 'H';

            { Check its installed }
            If DirectoryExists(W_MainDir + 'Crystal') Then
              DefMod := DefMod + 'H';
          End; { If (LicR.licModules[modODBC] > 0) }

          { I - Barcode Fonts }
          AvMod := AvMod + 'I';
          If DirectoryExists(W_MainDir + 'Fonts') Then
            DefMod := DefMod + 'I';

          { J - Paperless Module }
          If (LicR.licModules[modPaperless] > 0) Then Begin
            AvMod := AvMod + 'J';

            { Read default paperless config in from .INI file }
            W_TempEml := IniF.ReadString ('Entrprse', 'PEmail', '');
            SetVariable(DLLParams, 'V_PAPEMAIL', W_TempEml);

            W_TempFax := IniF.ReadString ('Entrprse', 'PFax', '');
            SetVariable(DLLParams, 'V_PAPFAX', W_TempFax);

            { Check its installed }
            If (W_TempEml <> '') Or (W_TempFax <> '') Then
              DefMod := DefMod + 'J';
          End;

          // HM 11/12/01: Removed as no longer used in v5.00
          { K - 'Multi-Company Manager }
          {AvMod := AvMod + 'K';
          If FileExists(W_MainDir + 'MCompMan.Sys') Then DefMod := DefMod + 'K';}

          { L - OLE Save Funcs }
          If (LicR.licModules[modOLESave] > 0) Then Begin
            AvMod := AvMod + 'L';

            If FileExists(W_MainDir + 'EntFunc2.Xla') Then
              DefMod := DefMod + 'L';
          End; { If (LicR.licModules[modOLESave] > 0) }

          { M - Trade Counter }
          If (LicR.licModules[modTrade] > 0) Then Begin
            AvMod := AvMod + 'M';

            If FileExists(W_MainDir + 'Trade\TCMSetup.Exe') Then
              DefMod := DefMod + 'M';
          End; { If (LicR.licModules[modTrade] > 0) }

          { N - Works Order Processing }
          If (LicR.licModules[modStdWOP] > 0) Or (LicR.licModules[modProWOP] > 0) Then Begin
            AvMod := AvMod + 'N';
            DefMod := DefMod + 'N';
          End; { If (LicR.licModules[modStdWOP] > 0) ... }

          { O - Elerts / Sentimail }
          If (LicR.licModules[modElerts] > 0) Then Begin
            AvMod := AvMod + 'O';

            If FileExists(W_MainDir + 'ELManage.Exe') Then
              DefMod := DefMod + 'O';
          End; { If (LicR.licModules[modElerts] > 0) }

          { P - Visual Report Writer }
          If (LicR.licModules[modVisualRW] > 0) Then Begin
            AvMod := AvMod + 'P';

            If FileExists(W_MainDir + 'EntRW.Exe') Then
              DefMod := DefMod + 'P';
          End; { If (LicR.licModules[modVisualRW] > 0) }

          { Q - E-Banking }
          If (LicR.licModules[modEBanking] > 0) Then
          Begin
            AvMod := AvMod + 'Q';
            DefMod := DefMod + 'Q';
          End; // If (LicR.licModules[modEBanking] > 0)

          // R - Outlook Dynamic Dashboard
          If (LicR.licModules[modOutlookDD] > 0) Then
          Begin
            AvMod := AvMod + 'R';

            If FileExists(W_MainDir + 'KPI\IKPIHost.Dll') Then
              DefMod := DefMod + 'R';
          End; // If (LicR.licModules[modOutlookDD] > 0)

          { Update Wise variables }
          SetVariable(DLLParams, 'V_AVMOD',  AvMod);
          SetVariable(DLLParams, 'V_DEFMOD', DefMod);

          // MH 19/11/2012: Added Workgroup Engine support
          SetVariable (DLLParams, 'WG_VERSION', IntToStr(LicR.licPSQLWGEVer));

          // HM 07/10/03 v7.0: Added Exchequer Edition support for the Small Business Edition
          SetVariable (DLLParams, 'L_EXCHEQUEREDITION', IntToStr(Ord(LicR.licExchequerEdition)));

          { AOK }
          DLLStatus := 0;
        Finally
          IniF.Destroy;
        End;
      End { If ReadEntLic }
      Else Begin
        { Cannot read Enterprise Licence File }
        DLLStatus := 1002;
      End; { Else }
    End; { If }
  Except
    { Unknown Exception }
    On Ex:Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetAutoModRights }


{-----------------------------------------------------------------------------}


// Reads the existing Licence File in the Enterprise directory and setups the
// licence variables within the WISE Script for a Workstation Setup
// 1000  Unknown Error
// 1001  Unknown Exception
// 1002  Cannot read Enterprise Licence File
// 1003  Missing Enterprise Licence File
Function SCD_SetWSInstDets (var DLLParams: ParamRec): LongBool;
Var
  LicR                                  : EntLicenceRecType;
  DLLStatus                             : LongInt;
  LicFile, WiseStr, W_MainDir, AvMod, DefMod     : String;
Begin { SCD_SetWSInstDets }
  DLLStatus := 1000;

  Try
    { Get Enterprise Directory Path }
    GetVariable (DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    // HM 16/06/99: Hack added for development which enables licences to be
    //              loaded whilst running under Wise in the S: development dir
    LicFile := W_MainDir + EntLicFName;
    If Not FileExists (LicFile) Then Begin
      { No licence - check to see if in development dir }
      If (UpperCase(ExtractFilePath(Application.ExeName)) = 'S:\MASTER\SINGLE\SETUP\') Then Begin
        { Design Time - no licence selected }
        With TOpenDialog.Create(Application) Do Begin
          Filter := 'Exchequer Licence File (*.DAT)|*.DAT;All Files (*.*)|*.*';
          InitialDir := ExtractFilePath(Application.ExeName);
          Options := [ofHideReadOnly,ofPathMustExist,ofFileMustExist];
          Title := 'Load Licence File';

          If Execute Then
            LicFile := FileName;
        End; { With }
      End; { If }
    End; { If Not FileExists (W_MainDir + EntLicFName) }

    { Check for licence }
    If FileExists (LicFile) Then Begin
      { Open and read licence }
      If ReadEntLic (LicFile, LicR) Then Begin

        WriteLicToWise (DLLParams, LicFile, licCopyEntLicToCDLic(LicR), 0);

        (*
        { Client-Server - 0=Non C/S, 1=C/S }
        SetVariable (DLLParams, 'L_CLSVR', IntToStr(LicR.licEntClSvr));

        { User Count - have to take from LicR as SysR brings in too much crap when  }
        {              trying to decode the release codes. This may cause problems  }
        {              when more users are added - will have to rely on EL to reset }
        {              LicR.licUserCnt as and when required                         }
        SetVariable (DLLParams, 'L_UCOUNT', IntToStr(LicR.licUserCnt));
        *)

        { AOK }
        DLLStatus := 0;
      End { If ReadEntLic }
      Else Begin
        { Cannot read Enterprise Licence File }
        DLLStatus := 1002;
      End; { Else }
    End { If FileExists }
    Else Begin
      { Missing Enterprise Licence File }
      DLLStatus := 1003;
    End; { Else }
  Except
    { Unknown Exception }
    On Ex:Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetWSInstDets }


{-----------------------------------------------------------------------------}


// Reads the temporary licence file, ~VBxxx.TMP, and either the SCuD
// Conversion File or ENTRPRSE.DAT to generate the Module Rights
// variables within the WISE Script for a Manual-SCuD-Upgrade
//
// 1000  No Licence
// 1001  Unknown Exception
// 1002  Cannot read Enterprise Licence File
// 1003  Unable to read ENTRPRSE.DAT
Function SCD_SetUpgModRights (var DLLParams: ParamRec): LongBool;
Var
  IniF                                  : TIniFile;
  TempLicR                              : CDLicenceRecType;
  EntLicR                               : EntLicenceRecType;
  DLLStatus                             : LongInt;
  W_MainDir, W_TempStr,
  WiseStr, W_LicF, AvMod, DefMod        : String;
Begin { SCD_SetUpgModRights }
  DLLStatus := 0;

  Try
    { Find out if we have a licence }
    GetVariable (DLLParams, 'I_LICTYPE', WiseStr);

    If (WiseStr <> '2') Then Begin
      { Get Licence File Name }
      GetVariable (DLLParams, 'I_LICFILE', W_LicF);

      { Read temporary licence file }
      If ReadLicFile (W_LicF, TempLicR) Then Begin
        { Get Enterprise Directory Path }
        GetVariable (DLLParams, 'V_MAINDIR', W_MainDir);
        FixPath (W_MainDir);

        FillChar (EntLicR, SizeOf(EntLicR), #0);

        { Open SETUP.USR ini file to read in details of last install/upgrade }
        IniF := TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR');
        Try
          { Check for SCud Conversion file }
          { Load Entrprse.Dat }
          If Not ReadEntLic (W_MainDir + EntLicFName, EntLicR) Then Begin
            { Unable to read ENTRPRSE.DAT }
            DLLStatus := 1003;
          End; { If }

          If (DLLStatus = 0) Then Begin
            { A - Core Program Files }
            AvMod := 'a';
            DefMod := 'A';

            { B - eBusiness }
            If (TempLicR.licModules[modEBus] > 0) Or (EntLicR.licModules[modEBus] > 0) Then Begin
              AvMod := AvMod + 'B';

              { Check its installed }
              (* HM 26/01/99: Removed as was likely to cause support calls
              If FileExists(W_MainDir + 'EnEBus.Exe') Then
              *)
                DefMod := DefMod + 'B';
            End; { If (LicR.licModules[modEBus] > 0) }

            { C - Toolkit DLL (Developer Files) }
            If (TempLicR.licModules[modToolDLL] > 0) Or (EntLicR.licModules[modToolDLL] > 0) Then Begin
              AvMod := AvMod + 'C';

              { Check its installed }
              (* HM 26/01/99: Removed as was likely to cause support calls
              If FileExists(W_MainDir + 'Toolkit\Toolkit.Exe') Then
              *)
                DefMod := DefMod + 'C';
            End; { If (LicR.licModules[modEBus] > 0) }

            { D - Import }
            If (TempLicR.licModules[modImpMod] > 0) Or (EntLicR.licModules[modImpMod] > 0) Then Begin
              AvMod := AvMod + 'D';

              { Check its installed }
              (* HM 06/10/99: Removed as was causing problems on upgrades
              If FileExists(W_MainDir + 'Import\ExImport.Exe') Then
              *)
                DefMod := DefMod + 'D';
            End; { If (LicR.licModules[modImpMod] > 0) }

            { E - ODBC }                          { HM 18/10/99: Removed as incorrect }
            If (TempLicR.licModules[modODBC] > 0) {Or (EntLicR.licModules[modODBC] > 0)} Then Begin
              AvMod := AvMod + 'E';

              { Check its installed }
              (* HM 06/10/99: Removed as was causing problems on upgrades
              If FileExists(W_MainDir + 'File.Ddf') Then
              *)
                DefMod := DefMod + 'E';
            End; { If (LicR.licModules[modODBC] > 0) }

            { F - Report Writer }
            If (TempLicR.licModules[modRepWrt] > 0) Or (EntLicR.licModules[modRepWrt] > 0) Then Begin
              AvMod := AvMod + 'F';

              { Check its installed }
              (* HM 06/10/99: Removed as was causing problems on upgrades
              If FileExists(W_MainDir + 'ExRepWrt.Exe') Or FileExists(W_MainDir + 'EnRepWrt.Exe') Then
              *)
                DefMod := DefMod + 'F';
            End; { If (LicR.licModules[modRepWrt] > 0) }

            { G - Client-Server }
            // HM 02/10/03: Changed to '= 1' from '> 0' as 2 is being used for Workgroup Engine (Non C/S)
            If (TempLicR.licEntClSvr = 1) Or (EntLicR.licEntClSvr = 1) Then Begin
              AvMod := AvMod + 'G';

              { Check its installed }
              (* HM 26/01/99: Removed as was likely to cause support calls
              If FileExists(W_MainDir + 'W32SSet.Exe') Then
              *)
                DefMod := DefMod + 'G';
            End; { If (TempLicR.licEntClSvr = 1) Or (EntLicR.licEntClSvr = 1) }

            { H - ODBC - Crystall Add-In }
            If (TempLicR.licModules[modODBC] > 0) Or (EntLicR.licModules[modODBC] > 0) Then Begin
              AvMod := AvMod + 'H';

              { Check its installed }
              (* HM 26/01/99: Removed as was likely to cause support calls
              If DirectoryExists(W_MainDir + 'Crystal') Then
              *)
                DefMod := DefMod + 'H';
            End; { If (LicR.licModules[modODBC] > 0) }

            { I - Barcode Fonts }
            Begin
              AvMod := AvMod + 'I';

              { Check its installed }
              If DirectoryExists(W_MainDir + 'Fonts') Then
                DefMod := DefMod + 'I';
            End;

            { J - Paperless Module }
            If (TempLicR.licModules[modPaperless] > 0) Or (EntLicR.licModules[modPaperless] > 0) Then Begin
              AvMod := AvMod + 'J';
              DefMod := DefMod + 'J';  { Always install as default }

              { Read default paperless config in from .INI file }
              W_TempStr := IniF.ReadString ('Entrprse', 'PEmail', '');
              SetVariable(DLLParams, 'V_PAPEMAIL', W_TempStr);

              W_TempStr := IniF.ReadString ('Entrprse', 'PFax', '');
              SetVariable(DLLParams, 'V_PAPFAX', W_TempStr);
            End;

            // HM 11/12/01: Removed as no longer used in v5.00
            { K - 'Multi-Company Manager }
            {AvMod := AvMod + 'K';
            If FileExists(W_MainDir + 'MCompMan.Sys') Then DefMod := DefMod + 'K';}

            { L - OLE Save functions }
            If (TempLicR.licModules[modOLESave] > 0) Or (EntLicR.licModules[modOLESave] > 0) Then Begin
              AvMod := AvMod + 'L';

              { Check its installed }
              (* HM 26/01/99: Removed as was likely to cause support calls
              If DirectoryExists(W_MainDir + 'EntFunc2.Xla') Then
              *)
                DefMod := DefMod + 'L';
            End;

            { M - Trade Counter }
            If (TempLicR.licModules[modTrade] > 0) Or (EntLicR.licModules[modTrade] > 0) Then Begin
              AvMod := AvMod + 'M';
              DefMod := DefMod + 'M';
            End;

            { N - Works Order Processing }
            If (TempLicR.licModules[modStdWOP] > 0) Or (EntLicR.licModules[modStdWOP] > 0) Or
               (TempLicR.licModules[modProWOP] > 0) Or (EntLicR.licModules[modProWOP] > 0) Then Begin
              AvMod := AvMod + 'N';
              DefMod := DefMod + 'N';
            End;

            { O - Elerts / Sentimail }
            If (TempLicR.licModules[modElerts] > 0) Or (EntLicR.licModules[modElerts] > 0) Then Begin
              AvMod := AvMod + 'O';
              DefMod := DefMod + 'O';
            End;

            { P - Visual Report Writer }
            If (TempLicR.licModules[modVisualRW] > 0) Or (EntLicR.licModules[modVisualRW] > 0) Then Begin
              AvMod := AvMod + 'P';
              DefMod := DefMod + 'P';
            End;

            { Q - E-Banking }
            If (TempLicR.licModules[modEBanking] > 0) Or (EntLicR.licModules[modEBanking] > 0) Then
            Begin
              AvMod := AvMod + 'Q';
              DefMod := DefMod + 'Q';
            End;

            // R - Outlook Dynamic Dashboard
            If (TempLicR.licModules[modOutlookDD] > 0) Or (EntLicR.licModules[modOutlookDD] > 0) Then
            Begin
              AvMod := AvMod + 'R';
              DefMod := DefMod + 'R';
            End; // If (TempLicR.licModules[modOutlookDD] > 0) Or (EntLicR.licModules[modOutlookDD] > 0)

            { Update Wise variables }
            SetVariable(DLLParams, 'V_AVMOD',  AvMod);
            SetVariable(DLLParams, 'V_DEFMOD', DefMod);

            // HM 07/10/03: Added Workgroup Engine support
            If (TempLicR.licPSQLWGEVer > EntLicR.licPSQLWGEVer) Then
              SetVariable (DLLParams, 'WG_VERSION', IntToStr(TempLicR.licPSQLWGEVer))
            Else
              SetVariable (DLLParams, 'WG_VERSION', IntToStr(EntLicR.licPSQLWGEVer))
          End; { If DLLStatus = 0 }
        Finally
          IniF.Destroy;
        End;
      End { If ReadEntLic }
      Else Begin
        { Cannot read Enterprise Licence File }
        DLLStatus := 1002;
      End; { Else }
    End { If }
    Else Begin
      DLLStatus := 1000;
    End; { Else }
  Except
    { Unknown Exception }
    On Ex:Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_SetUpgModRights }

end.


