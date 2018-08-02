unit RegCom;

interface

Uses Classes, COMObj, Dialogs, Math, Registry, SysUtils, Windows;

Type
  TNotificationType = (notRegistering=0, notTesting=1, notOK=2, notFailed=3);

  TOnCOMNotification = Procedure (Const NotificationType : TNotificationType; Const Desc : ShortString) of Object;
  TRegHandler = Procedure (Const ComponentPath : ShortString) of Object;

  // PKR. 20/04/2015. ABSEXCH-16308. Added Credit Card Add-in.
  //PR: 31/01/2017 ABSEXCH-17750 Added 64-bit MAPI COM Server
  TExchequerComponents = (ecCOMCustomisation, ecToolkits, ecDBFWriter,
                          ecGraphOCX, ecOLEServer, ecSecurity, ecOutlookToday,
                          ecClientSync, ecSentimail, ecFaxing, ecCreditCards,
                          ecMAPI64, ecExcelUtils);
  TExchequerComponentSet = Set Of TExchequerComponents;

  TExchequerCOMRegistration = Class(TObject)
  Private
    FDataDir : ShortString;
    FRegDir : ShortString;
    FOnNotify : TOnCOMNotification;
    FSelectedComponents : TExchequerComponentSet;

    Procedure PostProgress (Const NotificationType : TNotificationType; Const Desc : ShortString);
    Function ProcessCOMFile (Const ErrOffset : LongInt; Const ComponentDesc, COMFilePath : ShortString) : LongInt;

    //PR: 06/02/2017 ABSEXCH-17750 Added default parameter to specify 64 bit com server
    Function ProcessRegistration (Const ErrOffset : LongInt; Const ComponentDesc, ServerName, ComponentPath : ShortString;
                                  Const Handler : TRegHandler; Is64Bit : Boolean = False) : LongInt;
    // Check that a particular server is registered to the current directory
    Function TestCOMComponent(Const ComponentDesc, ServerName, ComponentPath : ShortString) : LongInt;

    //PR: 06/02/2017 ABSEXCH-17750 New function for testing 64 bit COM Server installed
    Function TestCOMComponent64(Const ComponentDesc, ServerName, ComponentPath : ShortString) : LongInt;

    Procedure RegisterAssembly (Const ComponentPath : ShortString);
    // PKR. 20/04/2015. ABSEXCH-16308. Added Credit Card Add-in, which is .NET 4.5.1
    Procedure RegisterNET4Assembly (Const ComponentPath : ShortString);
    Procedure RegisterDLL (Const ComponentPath : ShortString);
    Procedure RegisterExe (Const ComponentPath : ShortString);
    Procedure RegisterOCX (Const ComponentPath : ShortString);
    // Enter1 is a special case as it needs paramters to load successfully
    Procedure RegisterEnter1 (Const ComponentPath : ShortString);
    // COM Toolkit is a special case as it needs to unregister the DLL version
    //Procedure RegisterCOMTK (Const ComponentPath : ShortString);  // MH 16/05/07: Not needed for v6.00 as we supply DLL and EXE versions under different Id's
    Procedure RegisterHTMLHelp (Const ComponentPath : ShortString);

    procedure UnRegisterComDLL(const DLLName: string);
  Protected
  Public
    Property OnNotify : TOnCOMNotification Read FOnNotify Write FOnNotify;
    Property SelectedComponents : TExchequerComponentSet Read FSelectedComponents Write FSelectedComponents;

    Constructor Create (Const RegDir, DataDir : ShortString);
    Function RegisterCOMObjects (Const RegisterAll : Boolean) : LongInt;
  End; // TExchequerCOMRegistration

implementation

Uses Brand, EntLicence, APIUtil, SetupReg, ShellAPI;

//-------------------------------------------------------------------------

// RegDir - Location of .EXE's/.DLL's/etc...
// DataDir - Location of main company data set - must be short filename
Constructor TExchequerCOMRegistration.Create (Const RegDir, DataDir : ShortString);
Var
  Component : TExchequerComponents;
  FName     : ANSIString;
Begin // Create
  Inherited Create;

  For Component := Low(TExchequerComponents) To High(TExchequerComponents) Do
    FSelectedComponents := FSelectedComponents + [Component];

  FRegDir := IncludeTrailingPathDelimiter(RegDir);
  FDataDir := IncludeTrailingPathDelimiter(ExtractShortPathName(DataDir));
End; // Create

//-------------------------------------------------------------------------

// Runs through the COM components in the specified registration directory and
// registers them
//
//   0      AOK
//   1001   Invalid registration directory
Function TExchequerCOMRegistration.RegisterCOMObjects (Const RegisterAll : Boolean) : LongInt;
Begin // RegisterCOMObjects
  Result := 0;

  If DirectoryExists(FRegDir) Then
  Begin
    // MH 29/06/07: Moved to be first as used by SQL system to identify location of files
    If ((Result = 0) Or RegisterAll) And (ecOLEServer In FSelectedComponents) Then
      Result := ProcessRegistration (5000, 'OLE Server', 'Enterprise.OLEServer', FRegDir + 'ENTEROLE.EXE', RegisterExe);

    If ((Result = 0) Or RegisterAll) And (ecCOMCustomisation In FSelectedComponents) Then
      Result := ProcessRegistration (1000, 'COM Customisation', 'Enterprise.COMCustomisation', FRegDir + 'ENTER1.EXE', RegisterEnter1);  // Special case - needs paramters to load successfully
    If ((Result = 0) Or RegisterAll) And (ecGraphOCX In FSelectedComponents) Then
      Result := ProcessRegistration (2000, 'Graph Control', 'VCFI.VCFiCtrl.1', FRegDir + 'VCFI32.OCX', RegisterOCX);
    If ((Result = 0) Or RegisterAll) And (ecSecurity In FSelectedComponents) Then
      Result := ProcessRegistration (3000, 'Security Server', 'EnterpriseSecurity.ThirdParty', FRegDir + 'ENTSECUR.DLL', RegisterDLL);
    If ((Result = 0) Or RegisterAll) And (ecDBFWriter In FSelectedComponents) Then
      Result := ProcessRegistration (4000, 'DBF Writer', 'EnterpriseDBF.DBFWriter', FRegDir + 'DBFWRITE.DLL', RegisterDLL);

    If ((Result = 0) Or RegisterAll) And (ecOLEServer In FSelectedComponents) Then
      Result := ProcessRegistration (17000, 'OLE Server Help', '', FRegDir + 'EnterOLE.CHM', RegisterHTMLHelp);
    If ((Result = 0) Or RegisterAll) And (ecOLEServer In FSelectedComponents) Then
      Result := ProcessRegistration (6000, 'Excel Drill-Down Components', 'Enterprise.DrillDown', FRegDir + 'ENTDRILL.EXE', RegisterExe);
    If ((Result = 0) Or RegisterAll) And (ecOLEServer In FSelectedComponents) Then
    Begin
      // MH 23/04/2010: Modified to unregister .DLL server and register .EXE versions
      UnRegisterComDLL(FRegDir + 'ENTDATAQ.DLL');
      //Result := ProcessRegistration (7000, 'Excel Data Query Components', 'Enterprise.DataQuery', FRegDir + 'ENTDATAQ.DLL', RegisterDLL);
      Result := ProcessRegistration (7000, 'Excel Data Query Components', 'Enterprise.DataQuery', FRegDir + 'ENTDATAQ.EXE', RegisterEXE);
    End; // If ((Result = 0) Or RegisterAll) And (ecOLEServer In FSelectedComponents)

    If ((Result = 0) Or RegisterAll) And (ecToolkits In FSelectedComponents) Then
      Result := ProcessRegistration (8000, 'COM Toolkit (DLL)', 'Enterprise01.Toolkit', FRegDir + 'ENTTOOLK.DLL', RegisterDLL);
    If ((Result = 0) Or RegisterAll) And (ecToolkits In FSelectedComponents) Then
      Result := ProcessRegistration (8500, 'COM Toolkit (EXE)', 'Enterprise04.Toolkit', FRegDir + 'ENTTOOLK.EXE', RegisterEXE);
    If ((Result = 0) Or RegisterAll) And (ecToolkits In FSelectedComponents) Then
      Result := ProcessRegistration (9000, 'Forms Toolkit', 'EnterpriseForms.PrintingToolkit', FRegDir + 'ENTFORMS.EXE', RegisterExe);
    If ((Result = 0) Or RegisterAll) And (ecToolkits In FSelectedComponents) Then
      Result := ProcessRegistration (10000, 'CSNF Extensions', 'EnterpriseBeta.Test', FRegDir + 'ENTLIB.001', RegisterDLL);
    If ((Result = 0) Or RegisterAll) And (ecToolkits In FSelectedComponents) Then
      Result := ProcessRegistration (12000, 'Scheduler Extensions', 'ExScheduler.ScheduledTask', FRegDir + 'ExSched.exe', RegisterExe);
    If ((Result = 0) Or RegisterAll) And (ecToolkits In FSelectedComponents) Then
      Result := ProcessRegistration (11000, 'SDK Preview Components', 'entPrevX.entPreviewX', FRegDir + 'ENTPREVX.OCX', RegisterOCX);

    If ((Result = 0) Or RegisterAll) And (ecSentimail In FSelectedComponents) Then
      Result := ProcessRegistration (13000, 'Sentimail Components', 'Sentimail.SentimailEvent', FRegDir + 'SENTEVNT.DLL', RegisterDLL);

    If ((Result = 0) Or RegisterAll) And (ecClientSync In FSelectedComponents) Then
      Result := ProcessCOMFile (14000, 'Data Sync Components', FRegDir + 'ICE.COM');
    If ((Result = 0) Or RegisterAll) And (ecClientSync In FSelectedComponents) Then
      Result := ProcessRegistration (15000, 'Data Sync Comms Components', '', FRegDir + 'RemotingClientLib.dll', RegisterAssembly);

    If ((Result = 0) Or RegisterAll) And (ecOutlookToday In FSelectedComponents) Then
      Result := ProcessCOMFile (16000, 'Outlook Dynamic Dashboard Controls', FRegDir + 'KPI.COM');

    If ((Result = 0) Or RegisterAll) And (ecFaxing In FSelectedComponents) Then
      Result := ProcessRegistration (18000, 'Faxing Interface (1)', '', FDataDir + 'FAXSRV\CLASSX.DLL', RegisterDLL);
    If ((Result = 0) Or RegisterAll) And (ecFaxing In FSelectedComponents) Then
      Result := ProcessRegistration (19000, 'Faxing Interface (2)', '', FDataDir + 'FAXSRV\CLASSXPS.DLL', RegisterDLL);
    If ((Result = 0) Or RegisterAll) And (ecFaxing In FSelectedComponents) Then
      Result := ProcessRegistration (20000, 'Faxing Interface (3)', '', FDataDir + 'FAXSRV\FMJR10.DLL', RegisterDLL);
    If ((Result = 0) Or RegisterAll) And (ecFaxing In FSelectedComponents) Then
      Result := ProcessRegistration (21000, 'Faxing Interface (4)', '', FDataDir + 'FAXSRV\FmPrint4.OCX', RegisterOCX);
    If ((Result = 0) Or RegisterAll) And (ecFaxing In FSelectedComponents) Then
      Result := ProcessRegistration (22000, 'Faxing Interface (5)', '', FDataDir + 'FAXSRV\ImageViewer2.OCX', RegisterOCX);

    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
    // There are 3 files to register for Credit Cards/Payment Portal
    if ((Result = 0) or RegisterAll) and (ecCreditCards in FSelectedComponents) then
      Result := ProcessRegistration(23000, 'Credit Card Add-in', '', FDataDir + 'ExchequerPaymentGateway.dll', RegisterNET4Assembly);
    if ((Result = 0) or RegisterAll) and (ecCreditCards in FSelectedComponents) then
      Result := ProcessRegistration(24000, 'Payments Portal Client', '', FDataDir + 'Exchequer.Payments.Portal.COM.Client.dll', RegisterNET4Assembly);
    if ((Result = 0) or RegisterAll) and (ecCreditCards in FSelectedComponents) then
      Result := ProcessRegistration(25000, 'Payments Portal Security', '', FDataDir + 'Exchequer.Payments.Services.Security.dll', RegisterNET4Assembly);

    //PR: 31/01/2017 ABSEXCH-17750 Added 64-bit MAPI COM Server. Need to check for 64-bit windows
    //PR: 03/01/2017 Removed change temporarily
    If ((Result = 0) Or RegisterAll) And (ecMAPI64 In FSelectedComponents) and ApiUtil.IsWOW64 Then
      Result := ProcessRegistration (26000, '64-bit MAPI Interface', 'Exchequer.Mapi64', FRegDir + 'ENTMAPI64.EXE', RegisterEXE, True {64-bit});

    // MH 14/03/2018 2018-R2 ABSEXCH-19845: Added support for registering XLUtils.DLL
    If ((Result = 0) Or RegisterAll) And (ecExcelUtils In FSelectedComponents) Then
      Result := ProcessRegistration (26000, 'Microsoft Excel Utilities', '', FRegDir + 'XLUtils.dll', RegisterNET4Assembly);
  End // If DirectoryExists(FRegDir)
  Else
    Result := 1001;  // Invalid registration directory
End; // RegisterCOMObjects

//-------------------------------------------------------------------------

procedure TExchequerCOMRegistration.UnRegisterComDLL(const DLLName: string);
type
  TRegProc = function: HResult; stdcall;
const
  RegProcName = 'DllUnregisterServer'; { Do not localize }
var
  Handle: THandle;
  RegProc: TRegProc;
begin
  Handle := SafeLoadLibrary(DLLName);
  if Handle <= HINSTANCE_ERROR then
    raise Exception.CreateFmt('%s: %s', [SysErrorMessage(GetLastError), DLLName]);
  try
    RegProc := GetProcAddress(Handle, RegProcName);
    if Assigned(RegProc) then OleCheck(RegProc) else RaiseLastOSError;
  finally
    FreeLibrary(Handle);
  end;
end;

//-------------------------------------------------------------------------

// A .COM file contains a list of COM Components to register specified using a relative path from the registration directory
Function TExchequerCOMRegistration.ProcessCOMFile (Const ErrOffset : LongInt; Const ComponentDesc, COMFilePath : ShortString) : LongInt;
Var
  sPath : ShortString;
  I     : Byte;
Begin // ProcessCOMFile
  Result := 0;

  If FileExists(COMFilePath) Then
  Begin
    PostProgress (notRegistering, ComponentDesc);

    With TStringList.Create Do
    Begin
      Try
        LoadFromFile(COMFilePath);

        For I := 0 To (Count - 1) Do
        Begin
          // Just register the components - can't test as we don't have server names for the components
          sPath := FRegDir + Strings[I];
          If FileExists(sPath) Then
          Begin
            If (ExtractFileExt(UpperCase(sPath)) = '.EXE') Then
              RegisterExe (sPath)
            Else If (ExtractFileExt(UpperCase(sPath)) = '.OCX') Then
              RegisterOCX (sPath)
            Else
              RegisterDll (sPath);
          End; // If FileExists(sPath)
        End; // For I
      Finally
        Free;
      End; // Try..Finally
    End; // With TStringList.Create

    // NOTE: notOK means "notification type = OK".  It doesn't mean that it isn't ok.
    // Similarly, notFailed means "notification type = Failed".
    If (Result = 0) Then
      PostProgress (notOK, ComponentDesc)
    Else
      PostProgress (notFailed, ComponentDesc);
  End; // If FileExists(COMFilePath)
End; // ProcessCOMFile

//-------------------------------------------------------------------------

Procedure TExchequerCOMRegistration.PostProgress (Const NotificationType : TNotificationType; Const Desc : ShortString);
Begin // PostProgress
  If Assigned(FOnNotify) Then FOnNotify(NotificationType, Desc);
End; // PostProgress

//-------------------------------------------------------------------------

//   O     AOK
//   101   Server Class Id Entry Missing
//   102   Cannot open Server Class Id
//   103   Server Class Id Missing
//   104   No Server Details Found off GUID
//   105   Cannot open Server Details off GUID
//   106   Registered Server Component Missing
//   107   Registered COM Component not in registration directory
//   404  Component not found
//
Function TExchequerCOMRegistration.ProcessRegistration (Const ErrOffset : LongInt; Const ComponentDesc, ServerName, ComponentPath : ShortString;
                                                          Const Handler : TRegHandler; Is64Bit : Boolean = False) : LongInt;
Begin // ProcessRegistration
  Result := 0;

  If FileExists(ComponentPath) Then
  Begin
    PostProgress (notRegistering, ComponentDesc);

    // Register the component
    Handler (ComponentPath);

    If (ServerName <> '') Then
      // Test whether it installed correctly
      //PR: 06/02/2017 Use appropriate function according to bitness
      if Is64Bit then
        Result := TestCOMComponent64 (ComponentDesc, ServerName, ComponentPath)
      else
        Result := TestCOMComponent (ComponentDesc, ServerName, ComponentPath);

    If (Result = 0) Then
      PostProgress (notOK, ComponentDesc)
    Else
      PostProgress (notFailed, ComponentDesc);
  End; // If FileExists(ComponentPath)

  If (Result <> 0 ) Then Result := Result + ErrOffset;
End; // ProcessRegistration

//-------------------------------------------------------------------------

// Check that a particular server is registered to the current directory
//
//   0     AOK
//   101   Server Class Id Entry Missing
//   102   Cannot open Server Class Id
//   103   Server Class Id Missing
//   104   No Server Details Found off GUID
//   105   Cannot open Server Details off GUID
//   106   Registered Server Component Missing
//   107   Registered COM Component not in registration directory
//
Function TExchequerCOMRegistration.TestCOMComponent(Const ComponentDesc, ServerName, ComponentPath : ShortString) : LongInt;
Var
  ClsId, CurrDir, SvrPath : ShortString;
  OK                      : Boolean;
Begin { TestCOMComponent }
  Result := 0;

  // Wait 1 sec before testing the registration
  Sleep (500);
  PostProgress (notTesting, ComponentDesc);
  Sleep (500);

  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      If KeyExists(ServerName + '\Clsid') Then
      Begin
        { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
        If OpenKey(ServerName + '\Clsid', False) Then
        Begin
          If KeyExists('') Then
          Begin
            { CLSID stored in default entry }
            ClsId := ReadString ('');
            CloseKey;

            { Got CLSID - find entry in CLSID Section and check registered .EXE/.DLL }
            If KeyExists ('Clsid\'+ClsId+'\InprocServer32') Then
              SvrPath := 'Clsid\'+ClsId+'\InprocServer32'
            Else
              If KeyExists ('Clsid\'+ClsId+'\LocalServer32') Then
                SvrPath := 'Clsid\'+ClsId+'\LocalServer32'
              Else
                SvrPath := '';

            If (SvrPath <> '') Then
            Begin
              { Got Server details - read .EXE/.DLL details and check it exists }
              If OpenKey(SvrPath, False) Then
              Begin
                ClsId := ReadString ('');

                If FileExists (ClsId) Then
                Begin
                  { Got File - Check its in current directory }
                  ClsId   := UpperCase(Trim(ExtractShortPathName(ExtractFilePath(ClsId))));
                  CurrDir := UpperCase(Trim(ExtractShortPathName(FRegDir)));

                  If (ClsId <> CurrDir) Then
                    Result := 107; // Registered COM Component not in registration directory
                End { If }
                Else
                  Result := 106; // Registered COM Component missing
              End { If }
              Else
                Result := 105; // Cannot open Server Details off GUID
            End { If (SvrPath <> '') }
            Else
              Result := 104; // No Server Details Found off GUID
          End { If KeyExists('') }
          Else
            Result := 103; // Server Class Id Missing
        End { If OpenKey(ServerName + '\Clsid', False) }
        Else
          Result := 102; // Cannot open Server Class Id
      End { If KeyExists(ServerName + '\Clsid') }
      Else
        Result := 101; // Server Class Id Entry Missing

      CloseKey;
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
End; // TestCOMComponent

//-------------------------------------------------------------------------

// Enter1 is a special case as it needs paramters to load successfully
Procedure TExchequerCOMRegistration.RegisterEnter1 (Const ComponentPath : ShortString);
Begin // RegisterEnter1
  RunApp (ComponentPath + ' /REGSERVER /DIR: ' + FDataDir, True);
End; // RegisterEnter1

//-------------------------------------------------------------------------

//Procedure TExchequerCOMRegistration.RegisterCOMTK (Const ComponentPath : ShortString);
//Var
//  sDLLPath : ShortString;
//
//  procedure UnregisterComServer(const DLLName: string);
//  type
//    TRegProc = function: HResult; stdcall;
//  const
//    RegProcName = 'DllUnregisterServer'; { Do not localize }
//  var
//    Handle: THandle;
//    RegProc: TRegProc;
//  begin
//    Handle := SafeLoadLibrary(DLLName);
//    if Handle <= HINSTANCE_ERROR then
//      raise Exception.CreateFmt('%s: %s', [SysErrorMessage(GetLastError), DLLName]);
//    try
//      RegProc := GetProcAddress(Handle, RegProcName);
//      if Assigned(RegProc) then OleCheck(RegProc) else RaiseLastOSError;
//    finally
//      FreeLibrary(Handle);
//    end;
//  end;
//
//Begin // RegisterCOMTK
//  // Unregister DLL version (if present)
//  sDLLPath := ChangeFileExt(ComponentPath, '.DLL');
//  If FileExists(sDLLPath) Then UnregisterCOMServer(sDLLPath);
//
//  // Register .EXE version
//  RegisterExe (ComponentPath);
//End; // RegisterCOMTK

//-------------------------------------------------------------------------

Procedure TExchequerCOMRegistration.RegisterExe (Const ComponentPath : ShortString);
Begin // RegisterExe
  RunApp (ComponentPath + ' /REGSERVER', True);
End; // RegisterExe

//-------------------------------------------------------------------------

Procedure TExchequerCOMRegistration.RegisterOCX (Const ComponentPath : ShortString);
//var
//  cmdFile, cmdPath, cmdParams : ANSIString;
//  Res, I                      : LongInt;
Begin // RegisterOCX
//ShowMessage(FindRegSvr32(FRegDir) + ' /s ' + ComponentPath);
//  RunApp (FindRegSvr32(FRegDir) + ' /s ' + ComponentPath, True);

// MH 28/06/07: Tried ShellExcute after problems under Vista registering the Graph
//  cmdFile := FindRegSvr32(FRegDir);
//  cmdPath := ExtractFilePath(ComponentPath);
//  cmdParams := '/s ' + ComponentPath;
//ShowMessage('ShellExecute (Path=' + cmdPath + ', File=' + cmdFile + ', Params=' + cmdParams + ')');
//  Res := ShellExecute (0, NIL, PCHAR(cmdFile), PCHAR(cmdParams), PCHAR(cmdPath), SW_SHOWNORMAL);

  // MH 28/06/07: Modified to use
  RegisterComServer(ComponentPath);
End; // RegisterOCX

//-------------------------------------------------------------------------

Procedure TExchequerCOMRegistration.RegisterDLL (Const ComponentPath : ShortString);
Begin // RegisterDLL
  RegisterCOMServer (ComponentPath);
End; // RegisterDLL

//-------------------------------------------------------------------------

Procedure TExchequerCOMRegistration.RegisterAssembly (Const ComponentPath : ShortString);
Begin // RegisterAssembly
  // Build path to .NET utility for installing/uninstalling .NET services
  RunApp (WinGetWindowsDir + 'Microsoft.NET\Framework\v2.0.50727\RegAsm.exe /codebase ' + ComponentPath, True);
End; // RegisterAssembly

//-------------------------------------------------------------------------

// PKR. 20/04/2015. ABSEXCH-16308. Added Credit Card Add-in, which is built with .NET 4.5.1
Procedure TExchequerCOMRegistration.RegisterNET4Assembly (Const ComponentPath : ShortString);
Var
  oRegistry : TRegistry;
  regasmPath : string;
Begin
  // Discover where the .NET Framework v4 is installed.
  regasmPath := '';
  oRegistry := TRegistry.Create;
  // Included try..finally to handle exceptions gracefully.
  Try
    oRegistry.Access := KEY_READ;
    oRegistry.RootKey := HKEY_LOCAL_MACHINE;

    If oRegistry.OpenKey('SOFTWARE\Microsoft\.NETFramework', False) Then
    Begin
      regasmPath := oRegistry.ReadString('InstallRoot') + 'v4.0.30319\';
      oRegistry.CloseKey;

      // Do the registration.
      RunApp (regasmPath + 'RegAsm.exe /codebase ' + ComponentPath, True);
    End;
  Finally
    oRegistry.Free;
  End; // Try..Finally

End; // RegisterNET4Assembly

//-------------------------------------------------------------------------

Procedure TExchequerCOMRegistration.RegisterHTMLHelp (Const ComponentPath : ShortString);
Var
  oRegistry : TRegistry;
Begin // RegisterHTMLHelp
  oRegistry := TRegistry.Create;
  Try
    oRegistry.Access := KEY_WRITE;
    oRegistry.RootKey := HKEY_LOCAL_MACHINE;

    If oRegistry.OpenKey('SOFTWARE\Microsoft\Windows\HTML Help', False) Then
    Begin
      oRegistry.WriteString(ExtractFileName(ComponentPath), ExtractFilePath(ComponentPath));

      oRegistry.CloseKey;
    End; // If oRegistry.OpenKey('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\HTML Help', False)
  Finally
    oRegistry.Free;
  End; // Try..Finally
End; // RegisterHTMLHelp

//-------------------------------------------------------------------------


//PR: 06/02/2017 ABSEXCH-17750 New function for testing 64 bit COM Server installed by
//setting TRegistry.Access to look at 64-bit registry classes. Can't use KeyExists
//as Delphi resets Access in that function, but don't need to as we know
//it must be an out-of-process server
function TExchequerCOMRegistration.TestCOMComponent64(const ComponentDesc,
  ServerName, ComponentPath: ShortString): LongInt;
const
  KEY_WOW64_64KEY = $0100;
Var
  ClsId, CurrDir, SvrPath : ShortString;
  OK                      : Boolean;
Begin { TestCOMComponent }
  Result := 0;

  // Wait 1 sec before testing the registration
  Sleep (500);
  PostProgress (notTesting, ComponentDesc);
  Sleep (500);

  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_READ or KEY_WOW64_64KEY;
      RootKey := HKEY_CLASSES_ROOT;

      If KeyExists(ServerName + '\Clsid') Then
      Begin
        { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
        If OpenKey(ServerName + '\Clsid', False) Then
        Begin
          ClsId := ReadString ('');
          CloseKey;
          SvrPath := 'Clsid\'+ClsId+'\LocalServer32';

          If (SvrPath <> '') Then
          Begin
            { Got Server details - read .EXE/.DLL details and check it exists }
            If OpenKey(SvrPath, False) Then
            Begin
              ClsId := ReadString ('');

              If FileExists (ClsId) Then
              Begin
                { Got File - Check its in current directory }
                ClsId   := UpperCase(Trim(ExtractShortPathName(ExtractFilePath(ClsId))));
                CurrDir := UpperCase(Trim(ExtractShortPathName(FRegDir)));

                If (ClsId <> CurrDir) Then
                  Result := 107; // Registered COM Component not in registration directory
              End { If }
              Else
                Result := 106; // Registered COM Component missing
            End { If }
            Else
              Result := 105; // Cannot open Server Details off GUID
          End { If (SvrPath <> '') }
          Else
            Result := 104; // No Server Details Found off GUID
        End { If OpenKey(ServerName + '\Clsid', False) }
        Else
          Result := 102; // Cannot open Server Class Id
      End { If KeyExists(ServerName + '\Clsid') }
      Else
        Result := 101; // Server Class Id Entry Missing

      CloseKey;
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
end;

end.
