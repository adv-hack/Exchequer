unit LicDets;

interface

Uses LicRec, oIRISLicence;

Const
  // IAO Version currently being installed
  sCurrentIAOVersion = '1.0';

  // Country Codes/Names mapping onto 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA from the Exchequer Licence }
  sCountries : Array[0..6, 1..2] Of ShortString = (('Any', 'Any'),
                                                   ('UK', 'United Kingdom'),
                                                   ('NZ', 'New Zealand'),
                                                   ('SG', 'Singapore'),
                                                   ('AU', 'Australia'),
                                                   ('IE', 'Ireland'),
                                                   ('ZA', 'South Africa'));

Type
  TLicenceMode = (lmInstall, lmUpgrade, lmDemo);

  //------------------------------

  // Stores the licence details for the CD Autorun
  TLicenceDetails = Class(TObject)
  Private
    FCDLicence : CDLicenceRecType;
    FUpgradePath : ShortString;
    FMode : TLicenceMode;

    FIRISLicencing : TIRISLicence;

    // Limit values
    FIAOVersion  : ShortString;
    FCompanyName : ShortString;
    FCountryCode : ShortString;  // ISO Country Code
    FTheme       : SmallInt;     // Theme - 1=Standard
    FLITEType    : ShortString;  // Customer / Accountant
    FUsers       : SmallInt;
    FCompanies   : SmallInt;
    FPervKey     : ShortString;

    Function GetCDSerialNo : ShortString;

    Function GetCDKey : ShortString;
    Procedure SetCDKey (Value : ShortString);
    Procedure SetMode (Value : TLicenceMode);
    Procedure SetUpgradePath (Value : ShortString);

    // Imports the IRIS Licencing settings stashed in a temporary file by WriteIRISTempLicence
    // which is then copied to IAO.DAT by the Install/Upgrade before the temp file is deleted
    Procedure ImportLastLicence (Const LicPath : ShortString);

    Procedure InitDemoLicence;
    Procedure InitInstallLicence;
    Procedure InitUpgradeLicence;

    // Creates a temporary file in the Windows\Temp directory which contains the IRIS Licencing
    // details for future upgrades to use. This file is read by ImportLastLicence.
    Function WriteIRISTempLicence (TempFileName : ANSIString = '') : ShortString;
  Public
    // Formatted CD-Key (xxxxx-xxxxx-xxxxx-xxxxx-xxxxx)
    Property ldCDKey : ShortString Read GetCDKey Write SetCDKey;
    Property ldCDLicence : CDLicenceRecType Read FCDLicence Write FCDLicence;
    Property ldCompanies : SmallInt Read FCompanies Write FCompanies;
    Property ldCompanyName : ShortString Read FCompanyName Write FCompanyName;
    Property ldCountryCode : ShortString Read FCountryCode Write FCountryCode;
    Property ldIRISLicence : TIRISLicence Read FIRISLicencing;
    Property ldLITEType : ShortString Read FLITEType Write FLITEType;
    Property ldPervasiveKey : ShortString Read FPervKey Write FPervKey;
    Property ldTheme : SmallInt Read FTheme Write FTheme;
    Property ldMode : TLicenceMode Read FMode Write SetMode;
    Property ldUpgradePath : ShortString Read FUpgradePath Write SetUpgradePath;
    Property ldUsers : SmallInt Read FUsers Write FUsers;
    Property ldVersion : ShortString Read FIAOVersion;

    Constructor Create;
    Destructor Destroy; Override;

    // Builds an Exchequer LITE install licence from the licencing info in memory
    Function BuildLicence : SmallInt;

    Function DownloadLicence (Var ErrString : ANSIString) : Boolean;

    // Called when upgrading to copy the Exchequer Licence into the CD Licence
    // used by the CD Auto-Run and the Setup Program
    Procedure ImportExchequerLicence(ExchLicence : EntLicenceRecType);

    // Called from the wizard to create the IRIS Licencing object, this cannot be done in the
    // constructor as the IRIS Licencing pre-requisit may not be available
    Function InitIRISLicencing : Boolean;

    Procedure InstallPervasiveKey;

    Procedure StartInstaller;

    {$IFDEF COMP}
    // Called from the MCM Update Licence wizard to update the licencing
    Procedure UpdateLicencing;
    {$ENDIF}
  End; // TLicenceDetails


// Converts a two character ISO 3166 Country Code into an Licence Country Number
Function ISO3166CountryCodeToIndex (CountryCode : ShortString) : SmallInt;

// Converts a two character ISO 3166 Country Code into a description
Function ISO3166CountryCodeToString (CountryCode : ShortString) : ShortString;

// Converts a two character ISO 3166 Country Code into a description
Function CountryStringToISO3166Code (CountryString : ShortString) : ShortString;


implementation

Uses Forms, IniFiles, ShellAPI, SysUtils, Windows, SerialU, EntLicence, WLicFile, LicFuncU,
     APIUtil, Math, GmXML, Dialogs, Classes, {$IFDEF COMP}VAOUtil, EntLic,{$ENDIF} Crypto,
     Registry;

//=========================================================================

Function FindCountryIdx (CountryStr : ShortString; Const SearchCol : Byte) : SmallInt;
Var
  I : SmallInt;
Begin // FindCountryIdx
  Result := -1;

  CountryStr := UpperCase(Trim(CountryStr));

  For I := Low(sCountries) To High(sCountries) Do
  Begin
    If (UpperCase(sCountries[I, SearchCol]) = CountryStr) Then
    Begin
      Result := I;
      Break;
    End; // If (sCountries[I, 1] = CountryStr)
  End; // For I
End; // ISO3166CountryCodeToIndex

//------------------------------

// Converts a two character ISO 3166 Country Code into an Index Number
Function ISO3166CountryCodeToIndex (CountryCode : ShortString) : SmallInt;
Begin // ISO3166CountryCodeToIndex
  Result := FindCountryIdx(CountryCode, 1);
End; // ISO3166CountryCodeToIndex

//------------------------------

// Converts a two character ISO 3166 Country Code into a description
Function ISO3166CountryCodeToString (CountryCode : ShortString) : ShortString;
Var
  Idx : SmallInt;
Begin // ISO3166CountryCodeToString
  Idx := FindCountryIdx(CountryCode, 1);
  If (Idx > -1) Then
    Result := sCountries[Idx, 2]
  Else
    Result := CountryCode + '?';
End; // ISO3166CountryCodeToString

//------------------------------

// Converts a two character ISO 3166 Country Code into a description
Function CountryStringToISO3166Code (CountryString : ShortString) : ShortString;
Var
  Idx : SmallInt;
Begin // CountryStringToISO3166Code
  Idx := FindCountryIdx(CountryString, 2);
  If (Idx > -1) Then
    Result := sCountries[Idx, 1]
  Else
    Result := CountryString + '?';
End; // CountryStringToISO3166Code

//=========================================================================

Constructor TLicenceDetails.Create;
Begin // Create
  Inherited Create;

  FillChar(FCDLicence, SizeOf(FCDLicence), #0);
  FUpgradePath := '';

  FIAOVersion  := sCurrentIAOVersion;
  FCompanyName := '';
  FCountryCode := 'UK';
  FTheme       := 1;    // Standard
  FLITEType    := 'Customer';
  FUsers       := 1;
  FCompanies   := 3;
  FPervKey     := '';
End; // Create

//------------------------------

Destructor TLicenceDetails.Destroy;
Begin // Destroy
  FreeAndNIL(FIRISLicencing);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TLicenceDetails.GetCDSerialNo : ShortString;
Var
  Params : ANSIString;
Begin // GetCDSerialNo
  Result := '0000-0000';
  { Check security parameter }
  Params := Application.ExeName;
  If (Trim(Params) <> '') Then
  Begin
    Result := GetDriveSerial (Params[1]);
  End; { If }
End; // GetCDSerialNo

//------------------------------

Function TLicenceDetails.GetCDKey : ShortString;
Begin // GetCDKey
  If Assigned(FIRISLicencing) Then
    Result := FormatCDKey (FIRISLicencing.CDKey)
  Else
    Result := '     -     -     -     -    ';
End; // GetCDKey
Procedure TLicenceDetails.SetCDKey (Value : ShortString);
Begin // SetCDKey
  If Assigned(FIRISLicencing) Then
  Begin
    FIRISLicencing.CDKey := ExtractCDKeyForLicence (Copy(Value + StringOfChar(' ', 29), 1, 29));
  End; // If Assigned(FIRISLicencing)
End; // SetCDKey

//------------------------------

Procedure TLicenceDetails.SetMode (Value : TLicenceMode);
Begin // SetMode
  FMode := Value;

  Case FMode Of
    lmInstall  : Begin
                   InitInstallLicence;
                 End; // lmInstall
    lmUpgrade  : Begin
                   InitUpgradeLicence;
                 End; // lmUpgrade
    lmDemo     : Begin
                   InitDemoLicence;
                 End; // lmDemo
  Else
    Raise Exception.Create('TLicenceDetails.SetMode: Unhandled Mode (' + IntToStr(Ord(Value)) + ')');
  End; // Case FMode
End; // SetMode

//------------------------------

Procedure TLicenceDetails.SetUpgradePath (Value : ShortString);
Begin // SetUpgradePath
  FUpgradePath := Value;

  // Check for and import the CD-Key/Licence Codes etc from the last Install/Upgrade
  If FileExists(FUpgradePath + 'IAO.DAT') Then
    ImportLastLicence(FUpgradePath + 'IAO.DAT');
End; // SetUpgradePath

//-------------------------------------------------------------------------

// Imports the IRIS Licencing settings stashed in a temporary file by WriteIRISTempLicence
// which is then copied to IAO.DAT by the Install/Upgrade before the temp file is deleted
Procedure TLicenceDetails.ImportLastLicence(Const LicPath : ShortString);
Var
  sXML : ANSIString;
  oXML : TGmXML;
  oXMLNode : TGmXMLNode;
  I : SmallInt;
Begin // ImportLastLicence
  With TFileStream.Create(LicPath, fmOpenRead Or fmShareDenyNone) Do
  Begin
    Try
      Position := 1;
      sXML := StringOfChar(#0, Size);
      Read (sXML[1], Length(sXML));

      ChangeCryptoKey (1870);
      DecodeData (@sXML[1], Length(sXML));

      // Crack the XML and update the licencing object
      oXML := TGmXML.Create(NIL);
      Try
        oXML.Text := sXML;

        // IAO Version
        oXMLNode := oXML.Nodes.NodeByName['IAOVersion'];
        If Assigned(oXMLNode) Then FIAOVersion := oXMLNode.AsString;

        // CD-Key
        oXMLNode := oXML.Nodes.NodeByName['CDKey'];
        If Assigned(oXMLNode) Then ldCDKey := FormatCDKey (oXMLNode.AsString);

        // Licence Codes
        oXMLNode := oXML.Nodes.NodeByName['LicenceCodeArray'];
        If Assigned(oXMLNode) Then
        Begin
          For I := 0 To (oXMLNode.Children.Count - 1) Do
          Begin
            FIRISLicencing.LicenceCodes.Add(oXMLNode.Children[I].AsString)
          End; // For I
        End; // If Assigned(oXMLNode)

        // Company Name
        oXMLNode := oXML.Nodes.NodeByName['CompanyName'];
        If Assigned(oXMLNode) Then ldCompanyName := oXMLNode.AsString;

        // Country Code
        oXMLNode := oXML.Nodes.NodeByName['CountryCode'];
        If Assigned(oXMLNode) Then ldCountryCode := oXMLNode.AsString;

        // Theme
        oXMLNode := oXML.Nodes.NodeByName['Theme'];
        If Assigned(oXMLNode) Then ldTheme := oXMLNode.AsInteger;

        // IAO Type
        oXMLNode := oXML.Nodes.NodeByName['IAOType'];
        If Assigned(oXMLNode) Then ldLITEType := oXMLNode.AsString;

        // User Count
        oXMLNode := oXML.Nodes.NodeByName['UserCount'];
        If Assigned(oXMLNode) Then ldUsers := oXMLNode.AsInteger;

        // Company Count
        oXMLNode := oXML.Nodes.NodeByName['CompanyCount'];
        If Assigned(oXMLNode) Then ldCompanies := oXMLNode.AsInteger;

        // Pervasive Key
        oXMLNode := oXML.Nodes.NodeByName['PervasiveKey'];
        If Assigned(oXMLNode) Then ldPervasiveKey := oXMLNode.AsString;
      Finally
        oXML.Free;
      End; // Try..Finally
    Finally
      Free;
    End;
  End; // With TFileStream.Create(LicPath, fmOpenRead Or fmShareDenyNone)
End; // ImportLastLicence

//-------------------------------------------------------------------------

// Called when upgrading to copy the Exchequer Licence into the CD Licence
// used by the CD Auto-Run and the Setup Program
Procedure TLicenceDetails.ImportExchequerLicence(ExchLicence : EntLicenceRecType);
Var
  TmpLicence : CDLicenceRecType;
Begin // ImportExchequerLicence
  // Need to preserve the original licence details so various items can be preserved
  TmpLicence := FCDLicence;

  FCDLicence := licCopyEntLicToCDLic (ExchLicence);

  FCDLicence.licLicType  := TmpLicence.licLicType;    // 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
  FCDLicence.licType     := TmpLicence.licType;       // 0=Install, 1=Upgrade, 2=Auto-Upgrade
  FCDLicence.licSerialNo := TmpLicence.licSerialNo;   // Installation drive Serial No


End; // ImportExchequerLicence

//-------------------------------------------------------------------------

Procedure TLicenceDetails.InitDemoLicence;
Var
  LicPath   : ShortString;
  IniF      : TIniFile;
Begin // InitDemoLicence
  FillChar(FCDLicence, SizeOf(FCDLicence), #0);
  With FCDLicence Do
  Begin
    licCDKey        := '000000000000000000000000';
    licSerialNo     := GetCDSerialNo;  // CD Serial Number

    // Read Default Country for Demo's
    LicPath := ExtractFilePath(Application.ExeName) + 'x86\SETUP.BIN';
    If FileExists (LicPath) Then
    Begin
      IniF := TIniFile.Create(LicPath);
      Try
        licCountry := IniF.ReadInteger ('DemoConfig', 'Country', licCountry);
        If (licCountry < 1) Or (licCountry > 6) Then Begin
          licCountry := 1;
        End; { If }
      Finally
        IniF.Free;
      End;
    End; { If FileExists }

    licEntEdition   := 1;         // IAO Default Theme

    licLicType      := 2;         // 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
    licType         := 0;         // 0=Install, 1=Upgrade, 2=Auto-Upgrade
    licProductType  := 1;         // 0=Exchequer, 1=LITE Customer, 2=LITE Accountant

    licCompany      := 'Evaluation Demo'; // Company Name

    // 1-User Single Currency SPOP
{ TODO : Currency Version depends on how EL decides to do single currency }
    licEntCVer      := 0;            // 0-Prof, 1-Euro, 2-MC
    licEntModVer    := 2;            // 0-Basic, 1-Stock, 2-SPOP
    licUserCnt      := 1;            // Enterprise User Count
    licUserCounts[ucCompanies] := 1;

    // Pervasive.SQL WGE 8.7 - 2-User 30-Day timebomb licenc
    //licPSQLLicKey   := '7TNVYJR2HH5YVSF4397JGMR9';
    licPSQLLicKey   := 'LAERAT5A6ZET6BWER2KPNQNR';  // MH 10/07/06: Upgraded to 60-day key supplied by KH
    licPSQLWGEVer   := 1;
  End; // With FCDLicence
End; // InitDemoLicence

//-------------------------------------------------------------------------

Procedure TLicenceDetails.InitInstallLicence;
Begin // InitInstallLicence
  FillChar(FCDLicence, SizeOf(FCDLicence), #0);
  With FCDLicence Do
  Begin
    licSerialNo     := GetCDSerialNo;  // CD Serial Number

    licEntEdition   := 1;         // IAO Default Theme

    licLicType      := 0;         // 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
    licType         := 0;         // 0=Install, 1=Upgrade, 2=Auto-Upgrade
    licProductType  := 1;         // 0=Exchequer, 1=LITE Customer, 2=LITE Accountant

    licModules[LicRec.modPaperless] := 2;
    licModules[LicRec.modFullStock] := 2;
    licModules[LicRec.modODBC] := 2;
    licModules[LicRec.modVisualRW] := 2;
  End; // With FCDLicence
End; // InitInstallLicence

//-------------------------------------------------------------------------

Procedure TLicenceDetails.InitUpgradeLicence;
Begin // InitUpgradeLicence
  FillChar(FCDLicence, SizeOf(FCDLicence), #0);
  With FCDLicence Do
  Begin
    licSerialNo     := GetCDSerialNo;  // CD Serial Number

    licEntEdition   := 1;         // IAO Default Theme

    licLicType      := 0;         // 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
    licType         := 1;         // 0=Install, 1=Upgrade, 2=Auto-Upgrade
    licProductType  := 1;         // 0=Exchequer, 1=LITE Customer, 2=LITE Accountant

  End; // With FCDLicence
End; // InitUpgradeLicence

//-------------------------------------------------------------------------

// Creates a temporary file in the Windows\Temp directory which contains the IRIS Licencing
// details for future upgrades to use. This file is read by ImportLastLicence.
Function TLicenceDetails.WriteIRISTempLicence (TempFileName : ANSIString = '') : ShortString;
Var
  sXML, TempFilePath, Prefix : ANSIString;
  FileLen  : LongInt;
  uUnique  : UInt;
  I        : SmallInt;
Begin // WriteIRISTempLicence
  // If file path not specified then create a temporary file in the Windows\Temp folder
  If (Length (TempFileName) = 0) Then
  Begin
    // Get path of Temporary file directory
    TempFilePath := StringOfChar(#0, 255);
    FileLen := GetTempPath(Length(TempFilePath), @TempFilePath[1]);
    SetLength (TempFilePath, FileLen);
    If (Length (TempFilePath) > 0) Then
    Begin
      TempFilePath := IncludeTrailingPathDelimiter(TempFilePath);

      // Generate temporary file name
      uUnique := 0;
      Prefix := '~vc';
      TempFileName := StringOfChar (#0, 255);
      GetTempFileName(PCHAR(TempFilePath), PCHAR(Prefix), uUnique, PCHAR(TempFileName));
    End; // If (Length (TempFilePath) > 0)
  End; // If (Length (TempFileName) = 0)

  If (Length (TempFileName) > 0) Then
  Begin
    Result := Trim(TempFileName);

    // Create XML
    sXML := '<CDKey>' + FIRISLicencing.CDKey + '</CDKey>' +
            '<LicenceCodeArray>';
    For I := 0 To (FIRISLicencing.LicenceCodes.Count - 1) Do
    Begin
      sXML := sXML + '<LicenceCode>' + FIRISLicencing.LicenceCodes[I].LicenceCode + '</LicenceCode>';
    End; // For I
    sXML := sXML + '</LicenceCodeArray>' +
                   '<IAOVersion>' + FIAOVersion + '</IAOVersion>' +
                   '<CompanyName>' + FCompanyName + '</CompanyName>' +
                   '<CountryCode>' + FCountryCode + '</CountryCode>' +
                   '<Theme>' + IntToStr(FTheme) + '</Theme>' +
                   '<IAOType>' + FLITEType + '</IAOType>' +
                   '<UserCount>' + IntToStr(FUsers) + '</UserCount>' +
                   '<CompanyCount>' + IntToStr(FCompanies) + '</CompanyCount>' +
                   '<PervasiveKey>' + FPervKey + '</PervasiveKey>';

    { Open temporary file as stream }
    With TFileStream.Create(TempFileName, fmCreate) Do
    Begin
      Try
        ChangeCryptoKey (1870);
        EncodeData (@sXML[1], Length(sXML));

        { Write licence info to temporary file }
        Position := 1;
        Write (sXML[1], Length(sXML));
      Finally
        Free;
      End;
    End; // With TFileStream.Create(Result)
  End; // If (Length (TempFile) > 0)
End; // WriteIRISTempLicence

//-------------------------------------------------------------------------

{$IFDEF COMP}
// Called from the MCM Update Licence wizard to update the licencing
Procedure TLicenceDetails.UpdateLicencing;
Var
  ExchLic : EntLicenceRecType;
Begin // UpdateLicencing
  // Read Exchequer Licence and update for changes
  If ReadEntLic (VAOInfo.vaoCompanyDir + EntLicFName, ExchLic) Then
  Begin
    // Copy across the fields used by LITE - any additional fields in ExchLic will be left intact
    licCopyLicence (FCDLicence, ExchLic, True);  // From CD to Exch
    If WriteEntLic (VAOInfo.vaoCompanyDir + EntLicFName, ExchLic) Then
    Begin
      // Update IRIS Licence (IAO.DAT)
      WriteIRISTempLicence(FUpgradePath + 'IAO.DAT');
    End; // If WriteEntLic (
  End; // If ReadEntLic (
End; // UpdateLicencing
{$ENDIF} // COMP

//-------------------------------------------------------------------------

Procedure TLicenceDetails.InstallPervasiveKey;
Var
  oReg : TRegistry;
  sPVSW : ShortString;
Begin // InstallPervasiveKey
  // Find the PVSW install and register the users key
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False) Then
    Begin
      If oReg.ValueExists('InstallDir') Then
      Begin
        sPVSW := IncludeTrailingPathDelimiter(oReg.ReadString('InstallDir'));

        If FileExists(sPVSW + 'BIN\CLILCADM.EXE') Then
        Begin
          RunApp (sPVSW + 'BIN\CLILCADM.EXE -a ' + FCDLicence.licPSQLLicKey, True);
        End; // If FileExists(sPVSW + 'BIN\CLILCADM.EXE')
      End; // If oReg.ValueExists('InstallDir')
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False)
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally
End; // InstallPervasiveKey

//-------------------------------------------------------------------------

Procedure TLicenceDetails.StartInstaller;
Var
  cmdFile, cmdPath, cmdParams : ANSIString;
  IRISLicFName                : ANSIString;
  LicFName                    : ShortString;
  Flags                       : SmallInt;

  zAppName:array[0..512] of char;
//  zCurDir:array[0..255] of char;
//  WorkDir: String;
  Proc: PROCESS_INFORMATION;
  start: STARTUPINFO;
Begin // StartInstaller
  If FileExists (ExtractFilePath(Application.ExeName) + 'x86\SETUP.EXE') Then
  Begin
    // Write licencing info file in Temp Dir
    LicFName := WriteLicFile(FCDLicence);

    // Write the additional IRIS Licencing details into a temp file in the Temp Dir
    IRISLicFName := WriteIRISTempLicence;

    // Execute LITE main installer
    If FileExists (LicFName) Then
    Begin
      cmdFile := ExtractFilePath(Application.ExeName) + 'x86\SETUP.EXE';
      cmdParams := '/lf:' + LicFName;
      cmdPath := ExtractFilePath(Application.ExeName) + 'x86';

      If (FCDLicence.licType In [1, 2]) Then
      Begin
        // Upgrade/Auto-Upgrade - append upgrade directory to parameters
        cmdParams := cmdParams + ' /ud:' + WinGetShortPathName(FUpgradePath);
      End; // If (FCDLicence.licType In [1, 2])

      cmdParams := cmdParams + ' /il:' + WinGetShortPathName(IRISLicFName);

      Flags := SW_SHOWNORMAL;

      ShellExecute (Application.MainForm.Handle, NIL, PCHAR(cmdFile), PCHAR(cmdParams), PCHAR(cmdPath), Flags);

(**** MH 13/09/06: 
      StrPCopy(zAppName,cmdFile + ' ' + cmdParams);

      FillChar(Start,Sizeof(StartupInfo),#0);
      Start.cb := Sizeof(StartupInfo);
      Start.dwFlags := STARTF_USESHOWWINDOW;
      Start.wShowWindow := 1;

      CreateProcess(nil,
                    zAppName,                      { pointer to command line string }
                    nil,                           { pointer to process security attributes }
                    nil,                           { pointer to thread security attributes }
                    false,                         { handle inheritance flag }
                    CREATE_NEW_CONSOLE or          { creation flags }
                    NORMAL_PRIORITY_CLASS,
                    nil,                           { pointer to new environment block }
                    nil,                           { pointer to current directory name }
                    Start,                         { pointer to STARTUPINFO }
                    Proc);
****)
    End; { If }
  End; // If FileExists (ExtractFilePath(Application.ExeName) + 'x86\SETUP.EXE')
End; // StartInstaller

//-------------------------------------------------------------------------

// Called from the wizard to create the IRIS Licencing object, this cannot be done in the
// constructor as the IRIS Licencing pre-requisit may not be available
Function TLicenceDetails.InitIRISLicencing : Boolean;
Begin // InitIRISLicencing
  Result := False;
  Try
    FIRISLicencing := TIRISLicence.Create;
    Result := True;
  Except
    ;
  End; // Try..Except
End; // InitIRISLicencing

//-------------------------------------------------------------------------

Function TLicenceDetails.DownloadLicence (Var ErrString : ANSIString) : Boolean;
Var
  Idx : SmallInt;
Begin // DownloadLicence
  Result := FIRISLicencing.GetLicenceCodes(ErrString);
  If Result Then
  Begin
    // IAO Version
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRLITEVersion);
    If (Idx >= 0) Then FIAOVersion := FIRISLicencing.LicenceRestrictions[Idx].Value;

    // Company Name
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRCompanyName);
    If (Idx >= 0) Then ldCompanyName := FIRISLicencing.LicenceRestrictions[Idx].Value;

    // Theme/Edition
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRTheme);
    If (Idx >= 0) Then ldTheme := FIRISLicencing.LicenceRestrictions[Idx].ValueAsInt;

    // Country Code
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRCountryCode);
    If (Idx >= 0) Then ldCountryCode := FIRISLicencing.LicenceRestrictions[Idx].Value;

    // IAO Type
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRLITEType);
    If (Idx >= 0) Then ldLITEType := FIRISLicencing.LicenceRestrictions[Idx].Value;

    // User Count
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRUserCount);
    If (Idx >= 0) Then ldUsers := FIRISLicencing.LicenceRestrictions[Idx].ValueAsInt;

    // Company Count
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRCompanyCount);
    If (Idx >= 0) Then ldCompanies := FIRISLicencing.LicenceRestrictions[Idx].ValueAsInt;

    // Pervasive Key
    Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRPervasiveKey);
    If (Idx >= 0) Then ldPervasiveKey := FIRISLicencing.LicenceRestrictions[Idx].Value;
  End; // If Result
End; // DownloadLicence

//-------------------------------------------------------------------------

// Builds an Exchequer LITE install licence from the licencing info in memory
//
//     0  AOK
//
//  1001  No Country Code specified
//  1002  Country Code not recognized
//
//  1101  No Installation Type specified
//  1102  Installation Type not recognized
//
//  1201  No Modules Version specified
//
//  1301  Pervasive Key specified without Pervasive Version
//  1302  Pervasive Version not recognized
//
//  1401  No Company Name specified
//
//  1501  No Theme specified
//
//  1601  No IAO Version specified
//
Function TLicenceDetails.BuildLicence : SmallInt;
Var
  Idx, Count, TmpIdx : SmallInt;
  sValue     : ShortString;
Begin // BuildLicence
  Result := 0;

  // IAO Version Number
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRLITEVersion);
  If (Idx >= 0) Then
    FIAOVersion := FIRISLicencing.LicenceRestrictions[Idx].Value
  Else
    Result := 1601;  // No IAO Version specified

  // Licence Type - 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
  FCDLicence.licLicType := IfThen(FIRISLicencing.InitialRestrictions.IndexOf(IRDemo) >= 0, 1, 0);

  // CD-Key
  FCDLicence.licCDKey := FIRISLicencing.CDKey;

  // Company Name
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRCompanyName);
  If (Idx >= 0) Then
    FCDLicence.licCompany := FIRISLicencing.LicenceRestrictions[Idx].Value
  Else
    Result := 1401;  // No Company Name specified

  // Country - 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRCountryCode);
  If (Idx >= 0) Then
  Begin
    // Convert ISO3166 strings to correct licence value
    TmpIdx := ISO3166CountryCodeToIndex (FIRISLicencing.LicenceRestrictions[Idx].Value);
    If (TmpIdx > -1) Then
      FCDLicence.licCountry := TmpIdx
    Else
      Result := 1002;  // Country Code not recognized
  End // If (Idx >= 0)
  Else
    Result := 1001;  // No Country Code specified

  // Product Type - 0=Exchequer, 1=LITE Customer, 2=LITE Accountant
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRLITEType);
  If (Idx >= 0) Then
  Begin
    sValue := UpperCase(Trim(FIRISLicencing.LicenceRestrictions[Idx].Value));
    If (sValue = 'CUSTOMER') Then
      FCDLicence.licProductType := 1
    Else If (sValue = 'ACCOUNTANT') Then
      FCDLicence.licProductType := 2
    Else
      Result := 1102;  // Installation Type not recognized
  End // If (Idx >= 0)
  Else
    Result := 1101;  // No Installation Type specified

  // Theme
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRTheme);
  If (Idx >= 0) Then
    FCDLicence.licEntEdition := FIRISLicencing.LicenceRestrictions[Idx].ValueAsInt
  Else
    Result := 1501;  // No Theme specified

  // Modules Version - 0-Basic, 1-Stock, 2-SPOP
  If (FIRISLicencing.Components.IndexOf(coSPOP) >= 0) Then
    FCDLicence.licEntModVer := 2
  Else If (FIRISLicencing.Components.IndexOf(coStock) >= 0) Then
    FCDLicence.licEntModVer := 1
  Else If (FIRISLicencing.Components.IndexOf(coCore) >= 0) Then
    FCDLicence.licEntModVer := 0
  Else
    // Error - no Module Version specified
    Result := 1201; // No Modules Version specified

  // Currency Version - 0-Prof, 1-Euro, 2-MC
  FCDLicence.licEntCVer := IfThen (FIRISLicencing.Components.IndexOf(coMultiCurrency) >= 0, 2, 0);

  // User Count
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRUserCount);
  If (Idx >= 0) Then
    Count := FIRISLicencing.LicenceRestrictions[Idx].ValueAsInt
  Else
    Count := 1;
  FCDLicence.licUserCnt := Count;

  // Company Count
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRCompanyCount);
  If (Idx >= 0) Then
    Count := FIRISLicencing.LicenceRestrictions[Idx].ValueAsInt
  Else
    Count := 1;
  FCDLicence.licUserCounts[ucCompanies] := Count;

  // Perverted Squirrel - Optional Component
  Idx := FIRISLicencing.LicenceRestrictions.IndexOf(LRPervasiveKey);
  If (Idx >= 0) Then
  Begin
    // Licence Key
    FCDLicence.licPSQLLicKey := FIRISLicencing.LicenceRestrictions[Idx].Value;

    // WGE Version - 0=Not Licenced, 1=P.SQL WGE v8,
    FCDLicence.licPSQLWGEVer := 1;  // NOTE: Ships with v8.7
  End; // If (Idx >= 0)
End; // BuildLicence

//-------------------------------------------------------------------------

end.
