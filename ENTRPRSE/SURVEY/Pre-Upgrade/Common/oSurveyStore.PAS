unit oSurveyStore;

interface

Uses Classes, Dialogs, Forms, StdCtrls, SysUtils, Windows, IniFiles,
     LicRec, oSurveyDriveSpace, oSurveyPlugIn, oBaseDataClasses, CompanySysAnalysis;

Type
  EntOSVersions = (osWin95, osWin98, osWinMe, osWinNT, osWin2000, osWinXP, osWin2003, osWinVista, osWin7, osWin8);

  EntOfficeVersions = (msOffice95, msOffice97, msOffice2000, msOfficeXP, msOffice2003, msOffice2007, msOffice2010, msOffice2013);

Const
  OSDesc : Array [EntOSVersions, 1..2] Of String =
             (('Win95',    'Windows 95'),
              ('Win98',    'Windows 98'),
              ('WinME',    'Windows Me'),
              ('WinNT',    'Windows NT'),
              ('Win2000',  'Windows 2000'),
              ('WinXP',    'Windows XP'),
              ('Win2003',  'Windows 2003'),
              ('WinVista', 'Windows Vista'),
              ('Win7',     'Windows 7'),
              ('Win8',     'Windows 8'));

  OfficeDesc : Array [EntOfficeVersions, 1..2] Of String =
                 (('Office95',   'Office 95'),
                  ('Office97',   'Office 97'),
                  ('Office2000', 'Office 2000'),
                  ('OfficeXP',   'Office XP'),
                  ('Office2003', 'Office 2003'),
                  ('Office2007', 'Office 2007'),
                  ('Office2010', 'Office 2010'),
                  ('Office2013', 'Office 2013'));

Type
  TEntSurveyInfo = Class(TObject)
  Private
    FDrives : TStringList;
    FPlugIns : TList;
    FTCMPlugIns : TStringList;
    FEntPath : ShortString;
    FESN : ESNByteArrayType;
    FSurveyResults : TStringList;
    FWarningCount : Longint;
    FWarningText : TStringList;
    FDealer: ShortString;
    FDealerTown: ShortString;
    FLicencee: ShortString;
    FVersion : TExchequerVersion;
    FContact: ShortString;
    FContactMethod : ShortString;
    FAddress: Array [1..5] Of ShortString;
    FFaxNumber: ShortString;
    FEmailAddress: ShortString;
    FPhoneNumber: ShortString;
    FPostCode: ShortString;
    FCurrencyVersion : Byte;
    FLicenceType : Byte;
    FEnter1Date : ShortString;
    FEnter1FileVer : ShortString;

    FPackage, FOtherPackage   : ShortString;
    FPosition, FOtherPosition : ShortString;
    FIndustry, FOtherIndustry : ShortString;
    FTurnover, FTurnoverCcy   : ShortString;
    FEmployees                : ShortString;

    FOSVersions           : Array [EntOSVersions] Of SmallInt;
    FNetOS, FOtherNetOS   : ShortString;
    FNetOSSP              : ShortString; //NF: 16/01/2008
    FCitrixUse : ShortString;

    FOfficeVersions       : Array [EntOfficeVersions] Of SmallInt;

    FInstallationData : TInstallationData;

    function GetAddress(Index: Byte): ShortString;
    procedure SetAddress(Index: Byte; const Value: ShortString);
    function GetOSVersions(Index: EntOSVersions): SmallInt;
    procedure SetOSVersions(Index: EntOSVersions; const Value: SmallInt);
    function GetOfficeVersions(Index: EntOfficeVersions): SmallInt;
    procedure SetOfficeVersions(Index: EntOfficeVersions; const Value: SmallInt);

    Function GetDriveCount : SmallInt;
    Function GetDrives(Index : SmallInt) : TSiteDriveInfo;

    Function GetPlugInCount : SmallInt;
    Function GetPlugIns(Index : SmallInt) : TSitePlugInInfo;
  Protected
  Public
    Property Address [Index : Byte] : ShortString Read GetAddress Write SetAddress;
    Property Contact : ShortString Read FContact Write FContact;
    Property ContactMethod : ShortString Read FContactMethod Write FContactMethod;
    Property CurrencyVersion : Byte Read FCurrencyVersion Write FCurrencyVersion;
    Property Dealer : ShortString Read FDealer Write FDealer;
    Property DealerTown : ShortString Read FDealerTown Write FDealerTown;
    Property EmailAddress : ShortString Read FEmailAddress Write FEmailAddress;
    Property EntPath : ShortString Read FEntPath Write FEntPath;
    Property ESN : ESNByteArrayType Read FESN Write FESN;
    Property FaxNumber : ShortString Read FFaxNumber Write FFaxNumber;
    Property Licencee : ShortString Read FLicencee Write FLicencee;
    Property LicenceType : Byte Read FLicenceType Write FLicenceType;
    Property PhoneNumber : ShortString Read FPhoneNumber Write FPhoneNumber;
    Property PostCode : ShortString Read FPostCode Write FPostCode;
    Property SurveyResults : TStringList Read FSurveyResults Write FSurveyResults;
    Property Version : TExchequerVersion Read FVersion Write FVersion;
    Property WarningCount : LongInt Read FWarningCount;

    Property Package : ShortString Read FPackage Write FPackage;
    Property OtherPackage : ShortString Read FOtherPackage Write FOtherPackage;
    Property Position : ShortString Read FPosition Write FPosition;
    Property OtherPosition : ShortString Read FOtherPosition Write FOtherPosition;
    Property Industry : ShortString Read FIndustry Write FIndustry;
    Property OtherIndustry : ShortString Read FOtherIndustry Write FOtherIndustry;
    Property Turnover : ShortString Read FTurnover Write FTurnover;
    Property TurnoverCcy : ShortString Read FTurnoverCcy Write FTurnoverCcy;
    Property Employees : ShortString Read FEmployees Write FEmployees;

    Property OfficeVersions [Index: EntOfficeVersions] : SmallInt Read GetOfficeVersions Write SetOfficeVersions;
    Property OSVersions [Index: EntOSVersions] : SmallInt Read GetOSVersions Write SetOSVersions;
    Property NetOS : ShortString Read FNetOS Write FNetOS;
    Property NetOSSP : ShortString Read FNetOSSP Write FNetOSSP; //NF: 16/01/2008
    Property OtherNetOS : ShortString Read FOtherNetOS Write FOtherNetOS;
    Property CitrixUse : ShortString Read FCitrixUse Write FCitrixUse;

    Property DriveCount : SmallInt Read GetDriveCount;
    Property Drives [Index : SmallInt] : TSiteDriveInfo Read GetDrives;

    Property InstallationData : TInstallationData Read FInstallationData;

    Property PlugInCount : SmallInt Read GetPlugInCount;
    Property PlugIns [Index : SmallInt] : TSitePlugInInfo Read GetPlugIns;

    Constructor Create;
    Destructor Destroy; Override;

    procedure AddWarningText(Const WarnText : ANSIString);
    procedure AddWarningStrings(Const WarnText : ANSIString; Const WarnStrs : TStringList);
    Procedure BuildReport;
    Procedure CheckEntLicence;
    Procedure CheckPlugIns;
    Procedure CheckVersion;
    Procedure RegisterDrive(Const Drive : ShortString; Const TotalFileSize : Int64);
    Procedure UpdateSetupUSR;
  End; { TEntSurveyInfo }


Var
  oSurveyInfo : TEntSurveyInfo = NIL;


implementation

Uses StrUtils, EntLic, LicFuncU, History,
     {$IFDEF SQLSurvey}
       oSQLInstallationData,
     {$ELSE}
       oPervInstallationData,
     {$ENDIF}
     APIUtil, ConvUtil;


Constructor TEntSurveyInfo.Create;
Var
  WSNetDir : ANSIString;
  iOS : EntOSVersions;
  iOffice : EntOfficeVersions;
Begin { Create }
  Inherited Create;

  // Set path to Exchequer directory
  FEntPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  // Check for Local Program Files
  If FileExists (FEntPath + 'ENTWREPL.INI') Then
    With TIniFile.Create (FEntPath + 'ENTWREPL.INI') Do
      Try
        // Get Path from .INI file
        WSNetDir := IncludeTrailingPathDelimiter(ReadString ('UpdateEngine', 'NetworkDir', ''));

        // Check the path is valid
//        If DirectoryExists (WSNetDir) And
//           FileExists (WSNetDir + 'COMPANY.DAT') And
//           FileExists (WSNetDir + 'Cust\CustSupp.Dat') And
//           FileExists (WSNetDir + 'Trans\Document.Dat') Then

        // MH 15/11/2012: Rewrote checks so they work in Pervasive + SQL Editions
        If DirectoryExists (WSNetDir) And
           DirectoryExists (WSNetDir + 'LIB\') And
           FileExists(WSNetDir + 'ENTER1.EXE') and
           FileExists(WSNetDir + 'ENTRPRSE.DAT') and
           FileExists(WSNetDir + 'EXCHEQR.SYS') then
          FEntPath := WSNetDir;
      Finally
        Free;
      End;

  // Create an internal TList to store the data set info in TEntDataSet objects
  FDrives := TStringList.Create;
  FPlugIns := TList.Create;
  FTCMPlugIns := TStringList.Create;

  // Create an appropriate object to analyse the data and store the results
  {$IFDEF SQLSurvey}
    FInstallationData := TMSSQLInstallationData.Create;
  {$ELSE}
    FInstallationData := TPervasiveInstallationData.Create;
  {$ENDIF}

  // Create internal StringLists to store the Warnings and Survey Output
  FSurveyResults := TStringList.Create;
  FWarningText := TStringList.Create;

  // Initialise the Survey Details
  FVersion := verUnknown;
  FLicencee := '';
  FDealer := '';
  FDealerTown := '';
  FContact := '';
  FillChar (FAddress, SizeOf(FAddress), #0);
  FFaxNumber := '';
  FEmailAddress := '';
  FPhoneNumber := '';
  FPostCode := '';
  FWarningCount := 0;
  FEnter1Date := '?';
  FEnter1FileVer := '';

  FillChar (FOSVersions, SizeOf (FOSVersions), #0);
  FNetOS := '';
  FNetOSSP := ''; //NF: 16/01/2008
  FOtherNetOS := '';
  FCitrixUse := '';

  If FileExists (FEntPath + 'WSTATION\SETUP.USR') Then
    With TInifile.Create (FEntPath + 'WSTATION\SETUP.USR') Do
      Try
        If SectionExists ('CustDets') Then Begin
          FLicencee := ReadString ('CustDets', 'Name', FLicencee);
          FDealer := ReadString ('CustDets', 'Dealer', FDealer);
          FDealerTown := ReadString ('CustDets', 'DealerTown', FDealerTown);
          FContact := ReadString ('CustDets', 'Contact', FContact);
          FContactMethod := ReadString ('CustDets', 'ContactMethod', FContactMethod);
          FAddress[1] := ReadString ('CustDets', 'Addr1', FAddress[1]);
          FAddress[2] := ReadString ('CustDets', 'Addr2', FAddress[2]);
          FAddress[3] := ReadString ('CustDets', 'Addr3', FAddress[3]);
          FAddress[4] := ReadString ('CustDets', 'Addr4', FAddress[4]);
          FAddress[5] := ReadString ('CustDets', 'Addr5', FAddress[5]);
          FPostCode   :=  ReadString ('CustDets', 'PostCode', FPostCode);
          FFaxNumber := ReadString ('CustDets', 'Fax', FFaxNumber);
          FEmailAddress := ReadString ('CustDets', 'Email', FEmailAddress);
          FPhoneNumber := ReadString ('CustDets', 'Phone', FPhoneNumber);

          FPackage := ReadString ('Marketing', 'Package', FPackage);
          FOtherPackage := ReadString ('Marketing', 'OtherPackage', FOtherPackage);
          FPosition := ReadString ('Marketing', 'Position', FPosition);
          FOtherPosition := ReadString ('Marketing', 'OtherPosition', FOtherPosition);
          FIndustry := ReadString ('Marketing', 'Industry', FIndustry);
          FOtherIndustry := ReadString ('Marketing', 'OtherIndustry', FOtherIndustry);
          FTurnover := ReadString ('Marketing', 'Turnover', FTurnover);
          FTurnoverCcy := ReadString ('Marketing', 'TurnoverCcy', FTurnoverCcy);
          FEmployees := ReadString ('Marketing', 'Employees', FEmployees);

          For iOS := Low(EntOSVersions) To High(EntOSVersions) Do
            FOSVersions[IOS] := ReadInteger('TechSupport', OSDesc[IOS, 1], 0);

          FNetOS := ReadString ('TechSupport', 'NetOS', FNetOS);
          FNetOSSP := ReadString ('TechSupport', 'NetOSSP', FNetOS); //NF: 16/01/2008
          FOtherNetOS := ReadString ('TechSupport', 'OtherNetOS', FOtherNetOS);
          FCitrixUse := ReadString ('TechSupport', 'CitrixUse', FCitrixUse);

          For iOffice := Low(EntOfficeVersions) To High(EntOfficeVersions) Do
            FOfficeVersions[iOffice] := ReadInteger('TechSupport', OfficeDesc[iOffice, 1], 0);
        End; { If SectionExists (CustDets) }
      Finally
        Free;
      End;
End; { Create }

//---------------------------------------

Destructor TEntSurveyInfo.Destroy;
Begin { Destroy }
  If Assigned(FDrives) Then
    While (FDrives.Count > 0) Do
    Begin
      TSiteDriveInfo(FDrives.Objects[0]).Free;
      FDrives.Delete(0);
    End; { While (FDrives.Count > 0) }

  If Assigned(FPlugIns) Then
    While (FPlugIns.Count > 0) Do
    Begin
      TSitePlugInInfo(FPlugIns.Items[0]).Free;
      FPlugIns.Delete(0);
    End; { While (FPlugIns.Count > 0) }

  // destroy the data set list and the reports
  FreeAndNIL(FTCMPlugIns);
  FreeAndNIL(FPlugIns);
  FreeAndNIL (FDrives);
  FreeAndNIL (FWarningText);
  FreeAndNIL (FSurveyResults);

  FreeAndNIL(FInstallationData);

  inherited;
End; { Destroy }

//--------------------------------------------------------------------------

// Write info to Setup.USR for future reference
Procedure TEntSurveyInfo.UpdateSetupUSR;
Var
  iOS : EntOSVersions;
  iOffice : EntOfficeVersions;
Begin { UpdateSetupUSR }
  If FileExists (FEntPath + 'WSTATION\SETUP.USR') Then
    With TInifile.Create (FEntPath + 'WSTATION\SETUP.USR') Do
      Try
        WriteString ('CustDets', 'Name', FLicencee);
        WriteString ('CustDets', 'Dealer', FDealer);
        WriteString ('CustDets', 'DealerTown', FDealerTown);
        WriteString ('CustDets', 'Contact', FContact);
        WriteString ('CustDets', 'ContactMethod', FContactMethod);
        WriteString ('CustDets', 'Addr1', FAddress[1]);
        WriteString ('CustDets', 'Addr2', FAddress[2]);
        WriteString ('CustDets', 'Addr3', FAddress[3]);
        WriteString ('CustDets', 'Addr4', FAddress[4]);
        WriteString ('CustDets', 'Addr5', FAddress[5]);
        WriteString ('CustDets', 'PostCode', FPostCode);
        WriteString ('CustDets', 'Fax', FFaxNumber);
        WriteString ('CustDets', 'Email', FEmailAddress);
        WriteString ('CustDets', 'Phone', FPhoneNumber);

        WriteString ('Marketing', 'Package', FPackage);
        WriteString ('Marketing', 'OtherPackage', FOtherPackage);
        WriteString ('Marketing', 'Position', FPosition);
        WriteString ('Marketing', 'OtherPosition', FOtherPosition);
        WriteString ('Marketing', 'Industry', FIndustry);
        WriteString ('Marketing', 'OtherIndustry', FOtherIndustry);
        WriteString ('Marketing', 'Turnover', FTurnover);
        WriteString ('Marketing', 'TurnoverCcy', FTurnoverCcy);
        WriteString ('Marketing', 'Employees', FEmployees);

        For iOS := Low(EntOSVersions) To High(EntOSVersions) Do
          WriteInteger('TechSupport', OSDesc[iOS, 1], FOSVersions[iOS]);

        WriteString ('TechSupport', 'NetOS',   FNetOS);
        WriteString ('TechSupport', 'NetOSSP',   FNetOSSP); //NF: 16/01/2008
        WriteString ('TechSupport', 'OtherNetOS', FOtherNetOS);
        WriteString ('TechSupport', 'CitrixUse', FCitrixUse);

        For iOffice := Low(EntOfficeVersions) To High(EntOfficeVersions) Do
          WriteInteger('TechSupport', OfficeDesc[iOffice, 1], FOfficeVersions[iOffice]);
      Finally
        Free;
      End;
End; { UpdateSetupUSR }

//--------------------------------------------------------------------------

Procedure TEntSurveyInfo.RegisterDrive(Const Drive : ShortString; Const TotalFileSize : Int64);
Var
  oSiteDrive : TSiteDriveInfo;
  sDrive : ShortString;
  Idx : SmallInt;
Begin // RegisterDrive
  Idx := FDrives.IndexOf(Drive);
  If (Idx > -1) Then
  Begin
    oSiteDrive := TSiteDriveInfo(FDrives.Objects[Idx]);
    oSiteDrive.drDataFileSize := oSiteDrive.drDataFileSize + TotalFileSize;
  End // (Idx > -1)
  Else
    // Not already registered - create new object and add
    FDrives.AddObject (Drive, TSiteDriveInfo.Create(Drive, TotalFileSize));
End; // RegisterDrive

//--------------------------------------------------------------------------

// Checks the Exchequer directory to guestimate the Exchequer Version
Procedure TEntSurveyInfo.CheckVersion;
Begin { CheckVersion }
  // BtrvSQL.Dll was added for v6.00
  If FileExists(FEntPath + 'BtrvSQL.dll') Then
    FVersion := AnalyseCompanySys(FEntPath)
  Else
    FVersion := verPreV600;

  // MH 06/11/07: Added date of Enter1.Exe for corroboration of version
  If FileExists(FEntPath + 'Enter1.Exe') Then
  Begin
    FEnter1Date := DateToStr(FileDateToDateTime(FileAge(FEntPath + 'Enter1.Exe')));

    // File Version is set by the build routines for v6.01 onwards - this should
    // tell us exactly which release is being run
    If (FVersion >= ver601) Then
      FEnter1FileVer := GetFileVersion(FEntPath + 'Enter1.Exe');
  End; // If FileExists(FEntPath + 'Enter1.Exe')
End; { CheckVersion }

//--------------------------------------------------------------------------

// Checks the Exchequer directory for the Exchequer Licence File
Procedure TEntSurveyInfo.CheckEntLicence;
Var
  EntLicence : EntLicenceRecType;
Begin { CheckEntLicence }
  CheckVersion;

  If FileExists(FEntPath + EntLicFName) Then
  Begin
    // Got Licence File - v4.30c -> v5.00

    // Read Licence
    If ReadEntLic (EntPath + EntLicFName, EntLicence) Then
    Begin
      // Copy Details out of licence into Survey Info
      FLicencee := Trim(EntLicence.licCompany);
      FDealer := Trim(EntLicence.licDealer);
      FESN := ESNByteArrayType(EntLicence.licISN);
      FCurrencyVersion := EntLicence.licEntCVer;
      FLicenceType := EntLicence.licLicType;
    End; { If ReadEntLic }
  End; { If FileExists }
End; { CheckEntLicence }

//--------------------------------------------------------------------------

// MH 11/10/07: Added reporting on installed plug-ins
Procedure TEntSurveyInfo.CheckPlugIns;
Var
  oIni : TIniFile;
  sPlugIn : ShortString;
  ComCounter : SmallInt;
Begin // CheckPlugIns
  If FileExists(FEntPath + 'EntCustm.Ini') Then
  Begin
    oIni := TIniFile.Create(FEntPath + 'EntCustm.Ini');
    Try
      // Check for DLL Plug-Ins
      sPlugIn := oIni.ReadString('HookChain', 'EntCustm', '');
      While (sPlugIn <> '') Do
      Begin
        FPlugIns.Add(TSitePlugInInfo.Create(FEntPath + sPlugIn + '.Dll', oIni.ReadString('PlugInDesc', sPlugIn, '')));
        sPlugIn := oIni.ReadString('HookChain', sPlugIn, '');
      End; // While (sDLLPlugIn <> '')

      // Check for COM Plug-Ins
      ComCounter := 1;
      Repeat
        sPlugIn := oIni.ReadString ('COMClients', IntToStr(ComCounter), '');
        If (sPlugIn <> '') Then
        Begin
          FPlugIns.Add(TSitePlugInInfo.Create(sPlugIn, oIni.ReadString('PlugInDesc', ChangeFileExt(ExtractfileName(sPlugIn), ''), '')));
        End; // If (sPlugIn <> '')
        Inc(ComCounter);
      Until (sPlugIn = '');
    Finally
      oIni.Free;
    End; // Try..Finally
  End; // If FileExists(FEntPath + 'EntCustm.Ini')

  If FileExists(FEntPath + 'Trade\TCCustom.Ini') Then
  Begin
    oIni := TIniFile.Create(FEntPath + 'Trade\TCCustom.Ini');
    Try
      // Check for COM Plug-Ins
      ComCounter := 1;
      Repeat
        sPlugIn := oIni.ReadString ('PlugIns', IntToStr(ComCounter), '');
        If (sPlugIn <> '') Then
        Begin
          FTCMPlugIns.Add(sPlugIn);
        End; // If (sPlugIn <> '')
        Inc(ComCounter);
      Until (sPlugIn = '');
    Finally
      oIni.Free;
    End; // Try..Finally
  End; // If FileExists(FEntPath + 'Trade\TCCustom.Ini')
End; // CheckPlugIns

//--------------------------------------------------------------------------

Procedure TEntSurveyInfo.BuildReport;
Var
  I, J, iCount, iTotal : LongInt;
  iOS : EntOSVersions;
  iOffice : EntOfficeVersions;
Begin { BuildReport }
  With FSurveyResults Do
  Begin
    Clear;

    Add ('<?xml version="1.0" encoding="ISO-8859-1" ?>');
    Add ('<SurveyResults SurveyVersion="' + SurveyVersion + ' ' + SurveyType +
                      '" ExchequerVersion="' + ExchequerVersionDesc(FVersion) +
                      '" ExchequerDir="' + FixDodgyChars(ExtractFilePath(Application.ExeName)) + '" >');
    Add ('  <Enter1 FileDate="' + FEnter1Date + '" FileVer="' + FEnter1FileVer + '" />');

    //------------------------------

    Add ('  <CustomerDetails>');
    Add ('    <ESN>' + licESN7Str (ESNByteArrayType(FESN), LicenceType) + '</ESN>');
    Add ('    <CompanyName>' + FixDodgyChars(FLicencee) + '</CompanyName>');
    Add ('    <Address>');
    Add ('      <AddressLine>' + FixDodgyChars(FAddress[1]) + '</AddressLine>');
    Add ('      <AddressLine>' + FixDodgyChars(FAddress[2]) + '</AddressLine>');
    Add ('      <AddressLine>' + FixDodgyChars(FAddress[3]) + '</AddressLine>');
    Add ('      <AddressLine>' + FixDodgyChars(FAddress[4]) + '</AddressLine>');
    Add ('      <AddressLine>' + FixDodgyChars(FAddress[5]) + '</AddressLine>');
    Add ('      <PostCode>' + FPostCode + '</PostCode>');
    Add ('    </Address>');
    Add ('    <Contact>' + FixDodgyChars(FContact) + '</Contact>');
    Add ('    <Phone>' + FPhoneNumber + '</Phone>');
    Add ('    <Fax>' + FFaxNumber + '</Fax>');
    Add ('    <Email>' + FixDodgyChars(FEmailAddress) + '</Email>');
    Add ('  </CustomerDetails>');

    //------------------------------

    Add ('  <MarketingSurvey>');
      Add ('    <PreviousPackage>' + FixDodgyChars(IfThen(Trim(FOtherPackage) <> '', FOtherPackage, FPackage)) + '</PreviousPackage>');
      Add ('    <Position>' + FixDodgyChars(IfThen(Trim(FOtherPosition) <> '', FOtherPosition, FPosition)) + '</Position>');
      Add ('    <Industry>' + FixDodgyChars(IfThen(Trim(FOtherIndustry) <> '', FOtherIndustry, FIndustry)) + '</Industry>');
      Add ('    <Turnover>' + FTurnover + ' ' + FTurnoverCcy + '</Turnover>');
      Add ('    <Employees>' + FEmployees + '</Employees>');
    Add ('  </MarketingSurvey>');

    //------------------------------

    Add ('  <TechnicalSurvey>');

    iCount := 0; iTotal := 0;
    For iOS := Low(EntOSVersions) To High(EntOSVersions) Do
      If (FOSVersions[iOS] > 0) Then
      Begin
        Inc(iCount);
        iTotal := iTotal + FOSVersions[iOS];
      End; // If (FOSVersions[iOS] > 0)

    Add ('    <WindowsVersions VersionCount = "' + IntToStr(iCount) + '" Total="' + IntToStr(iTotal) + '">');
    For iOS := Low(EntOSVersions) To High(EntOSVersions) Do
      If (FOSVersions[iOS] > 0) Then
        Add ('      <Windows Version="' + OSDesc[iOS, 2] + '" Count="' + IntToStr(FOSVersions[iOS]) + '" />');
    Add ('    </WindowsVersions>');

    Add ('    <Network>' + IfThen(Trim(FOtherNetOS) <> '', FOtherNetOS, NetOS) + '</Network>');
    Add ('    <NetworkServicePack>' + FNetOSSP + '</NetworkServicePack>'); //NF: 16/01/2008
    Add ('    <TerminalServices>' + FCitrixUse + '</TerminalServices>');

    iCount := 0; iTotal := 0;
    For iOffice := Low(EntOfficeVersions) To High(EntOfficeVersions) Do
      If (FOfficeVersions[iOffice] > 0) Then
      Begin
        Inc(iCount);
        iTotal := iTotal + FOfficeVersions[iOffice];
      End; // If (FOfficeVersions[iOffice] > 0)

    Add ('    <OfficeVersions VersionCount = "' + IntToStr(iCount) + '" Total="' + IntToStr(iTotal) + '">');
    For iOffice := Low(EntOfficeVersions) To High(EntOfficeVersions) Do
      If (FOfficeVersions[iOffice] > 0) Then
        Add ('      <Office Version="' + OfficeDesc[iOffice, 2] + '" Count="' + IntToStr(FOfficeVersions[iOffice]) + '" />');
    Add ('    </OfficeVersions>');

    Add ('  </TechnicalSurvey>');

    //------------------------------

    Add ('  <PlugIns>');

    Add ('    <ExchequerPlugIns PlugInCount="' + IntToStr(PlugInCount) + '">');
    For I := 0 To (PlugInCount - 1) Do
      With PlugIns[I] Do
        Add ('      <ExchequerPlugIn FileName="' + piFilename + '" Description="' + FixDodgyChars(piDescription) + '" FullPath="' + piPath + '" />');
    Add ('    </ExchequerPlugIns>');

    Add ('    <TradeCounterPlugIns PlugInCount="' + IntToStr(FTCMPlugIns.Count) + '">');
    For I := 0 To (FTCMPlugIns.Count - 1) Do
      Add ('      <TradeCounterPlugIn COMName="' + FTCMPlugIns[I] + '" />');
    Add ('    </TradeCounterPlugIns>');

    Add ('  </PlugIns>');

    //------------------------------

    Add ('  <DriveInfo DriveCount="' + IntToStr(DriveCount) + '">');
    For I := 0 To (DriveCount - 1) Do
      With Drives[I] Do
        Add ('    <Drive Name="' + drDrive + '" FreeSpaceMb="' + IntToStr(ToMb(drFreeSpace)) + '" TotalFilesMB="' + IntToStr(ToMb(drDataFileSize)) + '" />');
    Add ('  </DriveInfo>');

    //------------------------------

    // Write the data file/table details
    FInstallationData.WriteXML(FSurveyResults, '  ');

    //------------------------------

    If (FWarningText.Count > 0) Then
    Begin
      Add ('  <Warnings WarningCount="' + IntToStr(FWarningText.Count) + '">');
      For I := 0 To Pred(FWarningText.Count) Do
        Add ('    <Warning>' + FWarningText[I] + '</Warning>');
      Add ('  </Warnings>');
    End; // If (FWarningText.Count > 0)

    //------------------------------

    Add ('</SurveyResults>');
  End; { With ReportMemo }
End; { BuildReport }

//--------------------------------------------------------------------------

function TEntSurveyInfo.GetAddress(Index: Byte): ShortString;
begin
  Result := FAddress[Index];
end;

procedure TEntSurveyInfo.SetAddress(Index: Byte; const Value: ShortString);
begin
  FAddress[Index] := Value;
end;

//--------------------------------------------------------------------------

procedure TEntSurveyInfo.AddWarningText(Const WarnText : ANSIString);
Begin { AddWarningText }
  FWarningText.Add (WarnText);
  Inc(FWarningCount);
End; { AddWarningText }

procedure TEntSurveyInfo.AddWarningStrings(Const WarnText : ANSIString; Const WarnStrs : TStringList);
Var
  I : SmallInt;
Begin { AddWarningStrings }
  AddWarningText(WarnText);

  If (WarnStrs.Count > 0) Then
    For I := 0 To Pred(WarnStrs.Count) Do
      FWarningText.Add (WarnStrs[I]);
End; { AddWarningStrings }

//--------------------------------------------------------------------------

function TEntSurveyInfo.GetOSVersions(Index: EntOSVersions): SmallInt;
begin
  Result := FOSVersions[Index];
end;

procedure TEntSurveyInfo.SetOSVersions(Index: EntOSVersions;
  const Value: SmallInt);
begin
  FOSVersions[Index] := Value;
end;

//--------------------------------------------------------------------------

function TEntSurveyInfo.GetOfficeVersions(Index: EntOfficeVersions): SmallInt;
begin
  Result := FOfficeVersions[Index];
end;

procedure TEntSurveyInfo.SetOfficeVersions(Index: EntOfficeVersions; const Value: SmallInt);
begin
  FOfficeVersions[Index] := Value;
end;

//--------------------------------------------------------------------------

Function TEntSurveyInfo.GetDriveCount : SmallInt;
Begin // GetDriveCount
  Result := FDrives.Count;
End; // GetDriveCount

//------------------------------

Function TEntSurveyInfo.GetDrives(Index : SmallInt) : TSiteDriveInfo;
Begin // GetDrives
  If (Index >= 0) And (Index < FDrives.Count) Then
    Result := TSiteDriveInfo(FDrives.Objects[Index])
  Else
    Raise Exception.Create('TEntSurveyInfo.GetDrives: Invalid Index (' + IntToStr(Index) + ')');
End; // GetDrives

//--------------------------------------------------------------------------

Function TEntSurveyInfo.GetPlugInCount : SmallInt;
Begin // GetPlugInCount
  Result := FPlugIns.Count;
End; // GetPlugInCount

//------------------------------

Function TEntSurveyInfo.GetPlugIns(Index : SmallInt) : TSitePlugInInfo;
Begin // GetPlugIns
  If (Index >= 0) And (Index < FPlugIns.Count) Then
    Result := TSitePlugInInfo(FPlugIns[Index])
  Else
    Raise Exception.Create('TEntSurveyInfo.GetPlugIns: Invalid Index (' + IntToStr(Index) + ')');
End; // GetPlugIns

//--------------------------------------------------------------------------

Initialization
  // Create global object to store survey information
  oSurveyInfo := TEntSurveyInfo.Create;
Finalization
  FreeAndNIL(oSurveyInfo);
end.

