unit PwordF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterToTab, StdCtrls, Mask, ThemeMgr, ExtCtrls, BaseF, antLabel,
  Buttons, Clipbrd, CopyFilesClass, StrUtils, gmXML;

type
  TfrmPasswordEntry = class(TfrmCommonBase)
    btnContinue: TButton;
    btnClose: TButton;
    mePassword: TMaskEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    lblVersionWarning: TLabel;
    procedure btnContinueClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
  private
    { Private declarations }
    FPword : ShortString;
    FailCount : Byte;
    Checked : Boolean;

    Procedure Main;
    Function SelectExchequerPervasiveDirectory : Boolean;
    Function GetExchequerPervasiveCompanies : Boolean;
    Function LicencesCompatible : Boolean;
    Function GetReportingUsers : Boolean;
    Function GetUserConfirmation : Boolean;
    Function RecreateDatabase (Const Server, DatabaseName : ShortString) : Boolean;
    Function CreateCompanyTables : Boolean;
    Function GetConnectionStrings : Boolean;
    // MH 26/01/2017 2017-R1 ABSEXCH-18202: Tidy up the new Company tables ready for the conversion
    Function PrepareCompanies : Boolean;
    // MH 13/02/2013 v7.0.2 ABSEXCH-13360: Disable indexes to improve write performance
    Function DisableIndexes : Boolean;
    // CJS 2014-04-02 - ABSEXCH-15244 - Disable Foreign Key constraints to prevent import errors
    // CJS 2014-07-16 - ABSEXCH-15525 - Copied forward from v7.0.9
    Function DisableForeignKeys : Boolean;
    Function ConvertData : Boolean;
    Function CheckDataWarnings : Boolean;
    Function FixupSQLLicensing : Boolean;
    Function ImportDictionary : Boolean;
    Function ReorderBatchReceiptRecords : Boolean;
    Procedure RemoveSQLDataFiles;
    Procedure CopyCompanyFilesToSQL;
    Procedure Complete;
  public
    { Public declarations }
  end;

Var
  frmPasswordEntry : TfrmPasswordEntry;

implementation

{$R *.dfm}

Uses //VAOUtil,
     APIUtil,
     DllIntf,
     SQLH_MemMap,
     oConvertOptions,
     PervDirF,
     //LDirF,
     CompanyDetailsF,
     ReadyToConvertF,
     //ConversionLogsF,
     ConvSQLFuncs,
     CompleteF,
     ProgressF,
     ProgressTreeF,
     FixExchDll,
     EntLoggerClass,
     DataConversionWarnings,
     DataConversionWarningsF,
     LoggingUtils,
     History,
     ADODB,
     VarRec2U,
     SecSup2U,
     Crypto,
     // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
     SQLReorder;

Const
  CryptoKey = 27346;

Var
  FakeESN : ISNArrayType;

//=========================================================================

procedure TfrmPasswordEntry.FormCreate(Sender: TObject);
begin
  Inherited;

  Caption := 'Pervasive To SQL Conversion';
  FailCount := 0;
  Checked := False;

  lblVersionWarning.Caption := ExchequerVersionMessage;

  //FPword := EncodeKey (CryptoKey, Generate_ESN_BaseSecurity(FakeESN, 248, 0, 0)); // Plug-In Password
  FPword := EncodeKey (CryptoKey, Generate_ESN_BaseSecurity(FakeESN, 245, 0, 0)); // MCM Password
end;

//-------------------------------------------------------------------------

procedure TfrmPasswordEntry.FormActivate(Sender: TObject);
begin
  If (Not Checked) Then
  Begin
    Checked := True;

    If (Not FileExists(ExtractFilePath(Application.ExeName) + '\Schemas\Conversion\Dictionary.zip')) Then
    Begin
      MessageDlg ('The Data Dictionary Zip file is missing', mtError, [mbOK], 0);
      PostMessage (Self.Handle, WM_Close, 0, 0);
    End; // If (Not FileExists(ExtractFilePath(Application.ExeName) + '\Schemas\Conversion\Dictionary.zip'))
  End; // If (Not Checked)
end;

//-------------------------------------------------------------------------

procedure TfrmPasswordEntry.Label1DblClick(Sender: TObject);
begin
  If FileExists('C:\{B4A50F6A-82FA-4DAB-BA2B-0F82EA113DD0}') Then
  Begin
    ModalResult := mrOK;
    Self.Visible := False;
    Main;
  End; // If FileExists('C:\{B4A50F6A-82FA-4DAB-BA2B-0F82EA113DD0}')
end;

//------------------------------

procedure TfrmPasswordEntry.btnContinueClick(Sender: TObject);
Var
  sPW : ShortString;
  OK : Boolean;
begin
  sPW := EncodeKey (CryptoKey, UpperCase(Trim(mePassword.Text)));

  // Validate password
  OK := (sPw = FPword);

  If OK Then
  Begin
    ModalResult := mrOK;
    Self.Visible := False;
    Main;
  End // If OK
  Else
    Inc(FailCount);

  If (FailCount = 3) Then
    Close;
end;

//------------------------------

procedure TfrmPasswordEntry.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.SelectExchequerPervasiveDirectory : Boolean;
Var
  frmSelectExchPervasiveDir : TfrmSelectExchPervasiveDir;
Begin // SelectExchequerPervasiveDirectory
  frmSelectExchPervasiveDir := TfrmSelectExchPervasiveDir.Create(NIL);
  Try
    frmSelectExchPervasiveDir.InstallPath := ConversionOptions.coPervasiveDirectory;

    Result := (frmSelectExchPervasiveDir.ShowModal = mrOK);
    If Result Then
      ConversionOptions.coPervasiveDirectory := IncludeTrailingPathDelimiter(frmSelectExchPervasiveDir.InstallPath);
  Finally
    FreeAndNIL(frmSelectExchPervasiveDir);
  End; // Try..Finally
End; // SelectExchequerPervasiveDirectory

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.GetExchequerPervasiveCompanies : Boolean;
Var
  iCompany, iDefaults : LongInt;
  bInvalidCode, bInvalidTask : Boolean;
  sError : ShortString;
Begin // GetExchequerPervasiveCompanies
  ProgressDialog.StartStage ('Reading Exchequer Pervasive Companies List');
  Try
    // Get company details into oConvertOptions
    LoadPervasiveCompanyList;

    // Check we have 1 and only 1 default company - 0 is bad, 2+ will be seriously bad
    If (ConversionOptions.coCompanyCount > 0) Then
    Begin
      iDefaults := 0;
      bInvalidCode := False;
      bInvalidTask := False;
      For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
      Begin
        If ConversionOptions.coCompanies[iCompany].ccRootCompany Then
          iDefaults := iDefaults + 1;

        If (Not ConversionOptions.coCompanies[iCompany].ccValidCompanyCode) Then
        Begin
          bInvalidCode := True;
          MessageDlg ('One or more companies have a Company Code that is incompatible with the SQL Edition, ' +
                      'you must use the Exchequer Change Company Code Utility to correct them before the ' +
                      'Pervasive to SQL Conversion can be performed', mtError, [mbOK], 0);
          Break;
        End; // If (Not ConversionOptions.coCompanies[iCompany].ccValidCompanyCode)

        // MH 25/06/2012 v7.0: Added Data Conversion Tasks against the companies
        If (Not ConversionOptions.coCompanies[iCompany].ScanForTasks (sError)) Then
        Begin
          bInvalidTask := True;
          MessageDlg (sError, mtError, [mbOK], 0);
          Break;
        End; // If (Not ConversionOptions.coCompanies[iCompany].ScanForTasks (sError))
      End; // For iCompany

      Result := (iDefaults = 1) And (Not bInvalidCode) And (Not bInvalidTask);

      If (Not Result) And (iDefaults <> 1) And (Not bInvalidCode) And (Not bInvalidTask) Then
      Begin
        MessageDlg ('No valid root company was found in the specified Exchequer Pervasive Edition installation', mtError, [mbOK], 0);
      End; // If (Not Result)

      If Result Then
      Begin
        // Move the Root company to be first in the list so it gets processed first
        ConversionOptions.MoveRootToFirst;
      End; // If Result
    End // If (ConversionOptions.coCompanyCount > 0)
    Else
    Begin
      MessageDlg ('No valid companies were found in the specified Exchequer Pervasive Edition installation', mtError, [mbOK], 0);
      Result := False;
    End; // Else
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // GetExchequerPervasiveCompanies

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.LicencesCompatible : Boolean;
Begin // LicencesCompatible
  With ConversionOptions Do
  Begin
    // Country
    Result := (coPervasiveLicence.liCountry = coSQLLicence.liCountry);
    If (Not Result) Then
      Result := (MessageDlg ('The Pervasive Edition licence and SQL Edition licence are for different Countries'#13#13'Do you want to continue?',
                             mtConfirmation, [mbYes, mbNo], 0) = mrYes);

    // Currency Type - 0-Prof, 1-Euro, 2-MC
    If Result Then
    Begin
      Result := (coPervasiveLicence.liCurrencyVer = coSQLLicence.liCurrencyVer)
                Or
                // Also OK if moving from Euro to MC
                ((coPervasiveLicence.liCurrencyVer = 1) And (coSQLLicence.liCurrencyVer = 2));

      If (Not Result) Then
        MessageDlg ('The Pervasive Edition licence and SQL Edition licence have incompatible Currency Types', mtError, [mbOK], 0);
    End; // If Result

    // Modules - 0-Basic, 1-Stock, 2-SPOP
    If Result Then
    Begin
      // Moving from Basic to Stk or SPOP is OK, as is moving from Stk to SPOP, but downgrading is not allowed - lowers maintenance revenues for a start!
      Result := (coPervasiveLicence.liModuleVer <= coSQLLicence.liModuleVer);

      If (Not Result) Then
        MessageDlg ('The Pervasive Edition licence and SQL Edition licence have incompatible module level', mtError, [mbOK], 0);
    End; // If Result

    // Product Type - 0=Exchequer, 1=LITE Customer, 2=LITE Accountant
    If Result And (coPervasiveLicence.liProductType <> coSQLLicence.liProductType) Then
    Begin
      MessageDlg ('The Pervasive Edition licence and SQL Edition licence have an incompatible Product Type', mtError, [mbOK], 0);
      Result := False;
    End; // If (coPervasiveLicence.liProductType <> coSQLLicence.liProductType)
  End; // With ConversionOptions
End; // LicencesCompatible

//------------------------------

Function TfrmPasswordEntry.GetReportingUsers : Boolean;
Var
  frmReportingUsers : TfrmReportingUsers;
Begin // GetReportingUsers
  // Allow user to edit the Reporting UId/Pwd's
  frmReportingUsers := TfrmReportingUsers.Create(NIL);
  Try
    Result := (frmReportingUsers.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmReportingUsers);
  End; // Try..Finally
End; // GetReportingUsers

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.GetUserConfirmation : Boolean;
Var
  frmReadyToConvert: TfrmReadyToConvert;
Begin // GetUserConfirmation
  // Display details and get users to sign off before starting the conversion
  frmReadyToConvert := TfrmReadyToConvert.Create(NIL);
  Try
    Result := (frmReadyToConvert.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmReadyToConvert);
  End; // Try..Finally
End; // GetUserConfirmation

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.RecreateDatabase (Const Server, DatabaseName : ShortString) : Boolean;

  function GetSQLProtocol: string;
  { Reads the SQL Protocol value from the settings file }
  var
    XML: TGMXML;
    RootNode, Node: TgmXMLNode;
    iNode: Integer;
  begin
    Result := '';
    XML := TGMXML.Create(nil);
    try
      if FileExists('ExchSQLSettings.xml') then
      begin
        XML.LoadFromFile('ExchSQLSettings.xml');
        RootNode := XML.Nodes.Root;
        if (Uppercase(RootNode.Name) = 'EXCHEQUERSQLSETTINGS') then
        begin
          for iNode := 0 to RootNode.Children.Count - 1 do
          begin
            Node := RootNode.Children.Node[iNode];
            if (Uppercase(Node.Name) = 'PROTOCOL') then
            begin
              Result := Node.AsString;
              break;
            end;
          end;
        end;
      end;
    finally
      XML.Free;
    end;
  end;

Begin // RecreateDatabase
  ProgressDialog.StartStage ('Creating New Exchequer SQL Database');
  ProgressDialog.UpdateStageProgress (ConversionOptions.coDatabaseName + ' on ' + ConversionOptions.coDataSource);
  Try
    GlobalSetupMap.Clear;
    GlobalSetupMap.FunctionId := fnCreateSQLDatabase;

    GlobalSetupMap.AddVariable ('SQLSERVER', ConversionOptions.coDataSource);         // Server Name/Instance
    GlobalSetupMap.AddVariable ('V_MAINDIR', ConversionOptions.coSQLDirectory);       // Exchequer SQL Directory
    GlobalSetupMap.AddVariable ('V_DEMODATA', '*');                                   // Screwy Parameter - don't understand, brain hurting
    GlobalSetupMap.AddVariable ('V_SQLDBNAME', ConversionOptions.coDatabaseName);     // New Database Name
    GlobalSetupMap.AddVariable ('L_DBTYPE', '1');                                     // SQL Edition

    GlobalSetupMap.AddVariable ('V_DLLERROR', '0');   // Error Number
    GlobalSetupMap.AddVariable ('V_SQLCREATEDB', ''); // Error Text
    GlobalSetupMap.AddVariable ('V_SQLPROTOCOL', GetSQLProtocol);

    // Call the SQL Helper Function - .EXE will be in main exchequer directory
    RunApp(ConversionOptions.coSQLDirectory + 'SQLHELPR.EXE /SQLBODGE', True);

    Result := GlobalSetupMap.Result;
    If (Not Result) Then
      Raise Exception.Create ('The following error occurred whilst recreating the database:-'#13#13 +
                              'Error ' + GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue + ' - ' +
                              GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLCREATEDB')].vdValue);
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // RecreateDatabase

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.CreateCompanyTables : Boolean;
Var
  oDataConvTask : IDataConversionTask;
  slImportedZIPs : TStringList;
  iCompany, iTask : LongInt;
  sCompanyPath : ShortString;
Begin // CreateCompanyTables
  ProgressDialog.StartStage ('Creating Exchequer SQL Companies');
  Try
    For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
    Begin
      With ConversionOptions.coCompanies[iCompany] Do
      Begin
        ProgressDialog.UpdateStageProgress (Trim(ccCompanyCode) + ' - ' + Trim(ccCompanyName));

        // MH 11/09/12 v7.0 ABSEXCH-13411: Fixed issue with sub-companies having long filenames in the MCM
        // Step 1: Create the company directory and calculate the short-pathname for the company to
        // be used with the MCM
        ForceDirectories(ccSQLCompanyPath);
        sCompanyPath := WinGetShortPathName(ccSQLCompanyPath);

        // Step 2: Create the company by importing the empty version of BaseMC.ZIP - this creates the
        // core tables and also the Users

        GlobalSetupMap.Clear;
        GlobalSetupMap.FunctionId := fnCreateSQLCompany;

        // SQL Edition
        GlobalSetupMap.AddVariable ('L_DBTYPE', '1');

        // Exchequer SQL Directory
        GlobalSetupMap.AddVariable ('V_MAINDIR', ConversionOptions.coSQLDirectory);

        // New Company details
        GlobalSetupMap.AddVariable ('V_GETCOMPCODE', ccCompanyCode);       // Code
        GlobalSetupMap.AddVariable ('V_GETCOMPNAME', ccCompanyName);       // Name
        GlobalSetupMap.AddVariable ('V_COMPDIR',     sCompanyPath);//ccSQLCompanyPath);    // Path
        GlobalSetupMap.AddVariable ('SQL_USERLOGIN', ccReportingUserId);   // Reporting User - User Id
        GlobalSetupMap.AddVariable ('SQL_USERPASS',  ccReportingUserPwd);  // Reporting User - Password

        // Path to master data .ZIP file
        GlobalSetupMap.AddVariable ('SQL_DATA', ConversionOptions.coSQLDirectory + 'Schemas\Conversion\BaseMC.Zip');

        // Return values
        GlobalSetupMap.AddVariable ('V_DLLERROR', '0');   // Error Number
        GlobalSetupMap.AddVariable ('V_SQLCREATECOMP', ''); // Error Text

        // Call the SQL Helper Function - .EXE will be in main exchequer directory
        RunApp(ConversionOptions.coSQLDirectory + 'SQLHELPR.EXE /SQLBODGE', True);

        Result := GlobalSetupMap.Result;
        If (Not Result) Then
          Raise Exception.Create ('The following error occurred whilst creating the company tables:-'#13#13 +
                                  'Error ' + GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue + ' - ' +
                                  GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLCREATECOMP')].vdValue)
        Else
        Begin
          // Step 3: Run through the conversion tasks and import any additional .ZIP files
          // required by optional modules - use a StringList to keep track of which ZIP's
          // have been imported to avoid doing them multiple times
          slImportedZIPs := TStringList.Create;
          slImportedZIPs.Sorted := True;
          Try
            For iTask := 0 To (ccConversionTaskCount - 1) Do
            Begin
              oDataConvTask := ccConversionTasks[iTask];
              Try
                If (oDataConvTask.dctImportZIPFile <> '') And (slImportedZIPs.IndexOf(UpperCase(oDataConvTask.dctImportZIPFile)) = -1) Then
                Begin
                  // Add into StringList so we don't run it multiple times
                  slImportedZIPs.Add(UpperCase(oDataConvTask.dctImportZIPFile));

                  GlobalSetupMap.Clear;
                  GlobalSetupMap.FunctionId := fnSQLImportCompData;

                  // SQL Edition
                  GlobalSetupMap.AddVariable ('L_DBTYPE', '1');

                  // Exchequer SQL Directory
                  GlobalSetupMap.AddVariable ('V_MAINDIR', ConversionOptions.coSQLDirectory);

                  // Company Code of company to import to
                  GlobalSetupMap.AddVariable ('V_GETCOMPCODE', ccCompanyCode);

                  // Path to .ZIP file to import
                  GlobalSetupMap.AddVariable ('SQL_DATA', ConversionOptions.coSQLDirectory + 'Schemas\Conversion\' + oDataConvTask.dctImportZIPFile);

                  // Return values
                  GlobalSetupMap.AddVariable ('V_DLLERROR', '0');   // Error Number
                  GlobalSetupMap.AddVariable ('V_SQLIMPORTDATA', ''); // Error Text

                  // Call the SQL Helper Function - .EXE will be in main exchequer directory
                  RunApp(ConversionOptions.coSQLDirectory + 'SQLHELPR.EXE /SQLBODGE', True);

                  Result := GlobalSetupMap.Result;
                  If (Not Result) Then
                    Raise Exception.Create ('The following error occurred whilst creating additional tables:-'#13#13 +
                                            'Error ' + GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue + ' - ' +
                                            GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLIMPORTDATA')].vdValue);
                End; // If (oDataConvTask.dctImportZIPFile <> '')
              Finally
                oDataConvTask := NIL;
              End; // Try..Finally
            End; // For iTask
          Finally
            slImportedZIPs.Free;
          End; // Try..Finally
        End; // If Result
      End; // With ConversionOptions.coCompanies[iCompany]
    End; // For iCompany
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // CreateCompanyTables

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.GetConnectionStrings : Boolean;
Var
  iCompany, Res : Integer;
Begin // GetConnectionStrings
  ProgressDialog.StartStage ('Loading Connection Strings');
  Try
    // Reload the Common Connection String as it will have changed when the
    // IRIS Exchequer database was recreated in the previous stage
    Res := ConversionOptions.ReloadCommonConnectionString;
    If (Res = 0) Then
    Begin
      Result := True;

      // Connection Strings are required for code generation utility
//      If FindCmdLineSwitch('ConnStrings', ['/', '\', '-'], True) Then
//      Begin
//        Clipboard.AsText := ConversionOptions.coCommonConnectionString;
//        ShowMessage('Common Connection String in Clipboard');
//      End; // If FindCmdLineSwitch('DisplayConnS', ['/', '\', '-'], True)
    End // If (Res = 0)
    Else
    Begin
      Result := False;
      ConversionOptions.Abort ('ReloadCommonConnectionString failed with error ' + IntToStr(Res) + ' - ' + QuotedStr(ConversionOptions.coCommonConnectionString));
      Logging.FatalError ('ReloadCommonConnectionString failed with error ' + IntToStr(Res) + ' - ' + QuotedStr(ConversionOptions.coCommonConnectionString));
    End; // Else

    If Result Then
    Begin
      // Get Company Admin Connection Strings
      For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
      Begin
        If ConversionOptions.coCompanies[iCompany].LoadCompanyAdminConnectionString Then
        Begin
          // Connection Strings are required for code generation utility
//          If FindCmdLineSwitch('ConnStrings', ['/', '\', '-'], True) Then
//          Begin
//            Clipboard.AsText := ConversionOptions.coCompanies[iCompany].ccAdminConnectionString;
//            ShowMessage('Admin Connection String for ' + ConversionOptions.coCompanies[iCompany].ccCompanyCode + ' in Clipboard');
//          End; // If FindCmdLineSwitch('DisplayConnS', ['/', '\', '-'], True)
        End // If ConversionOptions.coCompanies[iCompany].LoadCompanyAdminConnectionString
        Else
        Begin
          Result := False;
          ConversionOptions.Abort ('LoadCompanyAdminConnectionString failed for company ' + ConversionOptions.coCompanies[iCompany].ccCompanyCode);
          Logging.FatalError ('LoadCompanyAdminConnectionString failed for company ' + ConversionOptions.coCompanies[iCompany].ccCompanyCode);
          Break;
        End; // If (Not ConversionOptions.coCompanies[iCompany].LoadCompanyAdminConnectionString)
      End; // For iCompany
    End; // If Result
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // GetConnectionStrings

//-------------------------------------------------------------------------

// MH 26/01/2017 2017-R1 ABSEXCH-18202: Tidy up the new Company tables ready for the conversion
Function TfrmPasswordEntry.PrepareCompanies : Boolean;
Var
  ADOConnection : TADOConnection;
  ADOQuery : TADOQuery;
  iCompany : Integer;
Begin // PrepareCompanies
  Result := True;

  Try
    ProgressDialog.StartStage ('Preparing SQL Company Data');
    Try
      ADOConnection := TADOConnection.Create(nil);
      ADOQuery := TADOQuery.Create(Nil);
      Try
        // Use the _ADMIN user to update all companies
        ADOConnection.ConnectionString := ConversionOptions.coCommonConnectionString;
        ADOConnection.CommandTimeout := 300;  // 5 minutes - should only take seconds
        ADOConnection.Open;

        ADOQuery.Connection := ADOConnection;

        // Run through the companies getting rid of any unwanted data
        For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
        Begin
          // Get rid of any rows automatically inserted into SystemSetup by the creation script
          ADOQuery.SQL.Text := 'DELETE FROM [' + ConversionOptions.coCompanies[iCompany].ccCompanyCode + '].SYSTEMSETUP';
          ADOQuery.ExecSQL;

          // Can add any future items here...
        End; // For iCompany
      Finally
        ADOQuery.Free;
        ADOConnection.Free;
      End; // Try..Finally
    Finally
      ProgressDialog.FinishStage;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      Result := False;
      Logging.Exception ('TfrmPasswordEntry.PrepareCompanies', 'Preparing Companies', E.Message);
      MessageDlg ('The following error occured whilst preparing the MSSQL company data for migration:-'#13#13 +
                  E.Message + #13#13'The Migration has been aborted', mtError, [mbOK], 0);
    End; // On E:Exception
  End; // Try..Except
End; // PrepareCompanies

//-------------------------------------------------------------------------

// MH 13/02/2013 v7.0.2 ABSEXCH-13360: Disable indexes to improve write performance
Function TfrmPasswordEntry.DisableIndexes : Boolean;
Var
  ADOConnection : TADOConnection;
  ADOStoredProc : TADOStoredProc;
Begin // DisableIndexes
  Result := True;

  Try
    ProgressDialog.StartStage ('Disabling Indexes');
    Try
      // Create SQL Query object to use for executing the stored procedure which disables the indexes
      ADOConnection := TADOConnection.Create(nil);
      ADOStoredProc := TADOStoredProc.Create(Nil);
      Try
        ADOConnection.ConnectionString := ConversionOptions.coCommonConnectionString;
        ADOConnection.CommandTimeout := 300;  // 5 minutes - should only take seconds

        ADOStoredProc.Connection := ADOConnection;
        ADOStoredProc.ProcedureName := 'common.isp_RI_NonClustered';
        ADOStoredProc.Parameters.Refresh;
        ADOStoredProc.Parameters.ParamByName('@Rebuild').Value := 0;
        ADOStoredProc.Prepared := True;

        ADOStoredProc.ExecProc;
      Finally
        ADOStoredProc.Free;
        ADOConnection.Free;
      End; // Try..Finally
    Finally
      ProgressDialog.FinishStage;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      Result := False;
      Logging.Exception ('TfrmPasswordEntry.DisableIndexes', 'Disabling Indexes', E.Message);
      MessageDlg ('The following error occured whilst disabling the indexes:-'#13#13 +
                  E.Message + #13#13'The Migration has been aborted', mtError, [mbOK], 0);
    End; // On E:Exception
  End; // Try..Except
End; // DisableIndexes

//-------------------------------------------------------------------------

// CJS 2014-04-02 - ABSEXCH-15244 - Disable Foreign Key constraints to prevent import errors
// CJS 2014-07-16 - ABSEXCH-15525 - Copied forward from v7.0.9
Function TfrmPasswordEntry.DisableForeignKeys: Boolean;
Var
  ADOConnection : TADOConnection;
  ADOStoredProc : TADOStoredProc;
Begin // DisableForeignKeys
  Result := True;

  Try
    ProgressDialog.StartStage ('Disabling Foreign Keys');
    Try
      // Create SQL Query object to use for executing the stored procedure
      ADOConnection := TADOConnection.Create(nil);
      ADOStoredProc := TADOStoredProc.Create(Nil);
      Try
        ADOConnection.ConnectionString := ConversionOptions.coCommonConnectionString;
        ADOConnection.CommandTimeout := 300;  // 5 minutes - should only take seconds

        ADOStoredProc.Connection := ADOConnection;
        ADOStoredProc.CommandTimeout := ADOConnection.CommandTimeout;
        ADOStoredProc.ProcedureName := 'common.isp_Enable_Foreign_Keys';
        ADOStoredProc.Parameters.Refresh;
        ADOStoredProc.Parameters.ParamByName('@enable').Value := 0; // 0 = disable
        ADOStoredProc.Prepared := True;

        ADOStoredProc.ExecProc;
      Finally
        ADOStoredProc.Free;
        ADOConnection.Free;
      End; // Try..Finally
    Finally
      ProgressDialog.FinishStage;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      Result := False;
      Logging.Exception ('TfrmPasswordEntry.DisableForeignKeys', 'Disabling Foreign Keys', E.Message);
      MessageDlg ('The following error occured whilst disabling the foreign key constraints:-'#13#13 +
                  E.Message + #13#13'The Migration has been aborted', mtError, [mbOK], 0);
    End; // On E:Exception
  End; // Try..Except
End;

// -----------------------------------------------------------------------------

Function TfrmPasswordEntry.ConvertData : Boolean;
Var
  frmConversionProgress : TfrmConversionProgress;
Begin // ConvertData
  frmConversionProgress := TfrmConversionProgress.Create(NIL);
  Try
    Result := (frmConversionProgress.ShowModal = mrOK);
  Finally
    frmConversionProgress.Free;
  End; // Try..Finally
End; // ConvertData

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.CheckDataWarnings : Boolean;
Var
  frmDataConversionWarnings: TfrmDataConversionWarnings;
Begin // CheckDataWarnings
  // Check whether any data conversion warnings have been logged
  If (ConversionWarnings.Count > 0) Then
  Begin
    // Display warnings dialog
    frmDataConversionWarnings := TfrmDataConversionWarnings.Create(NIL);
    Try
      Result := (frmDataConversionWarnings.ShowModal = mrOK);
    Finally
      frmDataConversionWarnings.Free;
    End; // Try..Finally

    // Clear out the DAta Conversion Warnings to minimise memory usage
    ConversionWarnings.ClearList;
  End // If (ConversionWarnings.Count > 0)
  Else
    // No Warnings
    Result := True;
End; // CheckDataWarnings

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.FixupSQLLicensing : Boolean;
Begin // FixupSQLLicensing
  ProgressDialog.StartStage ('Updating Exchequer SQL Licensing');
  Try
    // Use SQLHelpr to do module user counts
    GlobalSetupMap.Clear;
    GlobalSetupMap.FunctionId := fnSetupCompanyCount;
    GlobalSetupMap.Params := 'FCK98';
    GlobalSetupMap.AddVariable ('V_MAINDIR', ConversionOptions.coSQLDirectory);       // Exchequer SQL Directory
    GlobalSetupMap.AddVariable ('V_DLLERROR', '0');   // Error Number

    // Call the SQL Helper Function - .EXE will be in main exchequer directory
    RunApp(ConversionOptions.coSQLDirectory + 'SQLHELPR.EXE /SQLBODGE', True);

    Result := Not GlobalSetupMap.Result;  // TRUE = Error
    If (Not Result) Then
      Raise Exception.Create ('An error ' + GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue +
                              ' occurred whilst updating the module user counts');

    If Result Then
      // Copy the Pervasive Edition ESN into the SQL Edition
      Result := ResetESN (ConversionOptions.coSQLDirectory + 'Entrprse.Dat', ConversionOptions.coPervasiveLicence.liESN);

    If Result Then
      Result := ReApplySQLLicensing (ConversionOptions.coSQLDirectory);
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // FixupSQLLicensing

//-------------------------------------------------------------------------

Function TfrmPasswordEntry.ImportDictionary : Boolean;
Var
  DLLStatus : LongInt;
Begin // ImportDictionary
  GlobalSetupMap.Clear;
  GlobalSetupMap.FunctionId := fnImportCommonData;

  GlobalSetupMap.AddVariable ('V_MAINDIR', ConversionOptions.coSQLDirectory);       // Exchequer SQL Directory
  GlobalSetupMap.AddVariable ('SQL_DATA', ExtractFilePath(Application.ExeName) + '\Schemas\Conversion\Dictionary.Zip');
  GlobalSetupMap.AddVariable ('L_DBTYPE', '1');
  GlobalSetupMap.AddVariable ('V_GETCOMPCODE', '');

  GlobalSetupMap.AddVariable ('V_DLLERROR', '0');   // Error Number
  GlobalSetupMap.AddVariable ('V_SQLIMPORTDATA', '');

  // Call the SQL Helper Function - .EXE will be in main exchequer directory
  RunApp(ConversionOptions.coSQLDirectory + 'SQLHELPR.EXE /SQLBODGE', True);

  DLLStatus := StrToIntDef (GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue, 0);
  Result := (DllStatus = 0);
  If (Not Result) Then
    Raise Exception.Create ('The following error occurred whilst updating the data dictionary:-'#13#13 +
                            'Error ' + IntToStr(DLLStatus) + ' - ' +
                            GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLIMPORTDATA')].vdValue);
End; // ImportDictionary

//-------------------------------------------------------------------------

Procedure TfrmPasswordEntry.RemoveSQLDataFiles;
Var
  oCopyFiles : TCopyFiles;
Begin // RemoveSQLDataFiles
  ProgressDialog.StartStage ('Removing Company Files from SQL Edition');
  Try
    oCopyFiles := TCopyFiles.Create;
    Try
      // MH 04/09/2012 v7.0 ABSEXCH-13374: Extended to support Audit subsystem
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'Audit\', '*.*', True);
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'DocMastr\', '*.*', True);
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'Docs\', '*.*', True);
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'Forms\', '*.*', True);
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'Links\', '*.*', True);
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'OLESheet\', '*.*', True);
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory + 'Reports\', '*.*', True);

      // MH 17/01/2018 2017-R1-Patch ABSEXCH-19316: Remove any SQLConfig.Ini inherited from original MSSQL Installation to ensure Pending Status for migrated companies
      oCopyFiles.LogFiles (ConversionOptions.coSQLDirectory , 'SQLConfig.Ini');

      oCopyFiles.RemoveLoggedFiles;
    Finally
      oCopyFiles.Free;
    End; // Try..Finally
  Finally
    ProgressDialog.FinishStage;
  End; // Try..Finally
End; // RemoveSQLDataFiles

//-------------------------------------------------------------------------

// Copy Forms/Reports/Links/Signatures/Docs/etc... from P.SQL to MS SQL
Procedure TfrmPasswordEntry.CopyCompanyFilesToSQL;
Const
  FileSpecs : Array [1..20] Of ShortString = (
                                               'Company.Sys',
                                               'DEF*.Sys',
                                               'Me*.Sys',
                                               'Dashboard.ini',
                                               'mail.ini',
                                               'PrintSBS.Sys',
                                               'Sentmail.Ini',
                                               'smswap.ini',
                                               // MH 04/09/2012 v7.0 ABSEXCH-13374: Extended to support Audit subsystem
                                               'Audit\*.*',
                                               'DocMastr\*.*',
                                               'Docs\*.*',
                                               'Forms\*.*',
                                               'Import\Importer.Dat',
                                               'Import\ImportJob.Dat',
                                               'Import\FieldMaps\*.*',
                                               'Import\ImportJobs\*.*',
                                               'KPI\*.Dat',
                                               'Links\*.*',
                                               'OLESheet\*.*',
                                               'Reports\*.*'
                                             );
Var
  oCopyFiles : TCopyFiles;
  iCompany, iFile : LongInt;
  Warn : Boolean;
Begin // CopyCompanyFilesToSQL
  For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
  Begin
    With ConversionOptions.coCompanies[iCompany] Do
    Begin
      ProgressDialog.StartStage ('Copying Company Files To SQL Edition for ' + Trim(ccCompanyCode));
      Try
        // MH 04/09/2012 v7.0 ABSEXCH-13370: Extended to create MISC and SWAP folders
        ForceDirectories (IncludeTrailingPathDelimiter(ccSQLCompanyPath) + 'MISC');
        ForceDirectories (IncludeTrailingPathDelimiter(ccSQLCompanyPath) + 'SWAP');

        //------------------------------

        oCopyFiles := TCopyFiles.Create;
        Try
          Warn := False;
          For iFile := Low(FileSpecs) To High(FileSpecs) Do
          Begin
            If (Not oCopyFiles.CopyFiles (Trim(ccCompanyPath), ccSQLCompanyPath, FileSpecs[iFile], True)) Then
              Warn := True;
          End; // For iFile

          If ccRootCompany Then
          Begin
            // Copy ExchDll.Ini and try to fixup path
            If oCopyFiles.CopyFiles (Trim(ccCompanyPath), ccSQLCompanyPath, 'ExchDll.Ini', False) Then
              FixupExchDllPath
            Else
              Warn := True;
          End; // If ccRootCompany

          If Warn Then
            MessageDlg ('One or more files failed to copy across for company ' + Trim(ccCompanyCode) + ', please check the files manually once the conversion is complete',
                        mtError, [mbOK], 0);
        Finally
          oCopyFiles.Free;
        End; // Try..Finally
      Finally
        ProgressDialog.FinishStage;
      End; // Try..Finally
    End; // With ConversionOptions.coCompanies[iCompany]
  End; // For iCompany := 0 To (ConversionOptions.coCompanyCount - 1)
End; // CopyCompanyFilesToSQL

//-------------------------------------------------------------------------

// CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
function TfrmPasswordEntry.ReorderBatchReceiptRecords: Boolean;
var
  ErrorMsg: string;
  iCompany: Integer;
begin
  Result := True;
  // Re-order the transactions in each company
  For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
  Begin
    ErrorMsg := ReorderTransactions(ConversionOptions.coCompanies[iCompany].ccCompanyCode);
    if (ErrorMsg <> '') then
    begin
      // If an error occurs, report it and cancel any further processing
      MessageDlg('Failed to re-order Batch Receipt records for company ' +
                 ConversionOptions.coCompanies[iCompany].ccCompanyCode + ': ' +
                 ErrorMsg,
                 mtError, [mbOK], 0);
      Result := False;
      break;
    end;
  end;
end;

//-------------------------------------------------------------------------

Procedure TfrmPasswordEntry.Complete;
var
  frmConversionComplete: TfrmConversionComplete;
Begin // Complete
  frmConversionComplete := TfrmConversionComplete.Create(NIL);
  Try
    frmConversionComplete.ShowModal;
  Finally
    frmConversionComplete.Free;
  End; // Try..Finally
End; // Complete

//-------------------------------------------------------------------------

Procedure TfrmPasswordEntry.Main;
Type
  TConversionSteps = (stExchPervDir,
                      stGetPSQLCompanies,
                      stCheckLicences,
                      stReportingUsers,
                      stConfirm,
                      stDropSQLDB,
                      stCreateSQLDB,
                      stCreateTables,
                      stGetConnStrings,
                      // MH 26/01/2017 2017-R1 ABSEXCH-18202: Tidy up the new Company tables ready for the conversion
                      stPrepareCompanies,
                      stDisableIndexes,
                      // MH 26/01/2017 2017-R1 ABSEXCH-18220: Completed merge of ABSEXCH-15244 into live code
                      // ABSEXCH-15244 - SQL Migration error on AccountContactRole
                      stDisableForeignKeys,
                      stConvertDatabase,
                      stCheckDataWarnings,
                      stFixupLicence,
                      stUpdateDictnary,
                      stClearOutSQLFiles,
                      stCopyCompanyFiles,
                      stReorderRecords,
                      stFinito);
Var
  NextStep : TConversionSteps;
  CloseConvert : Boolean;
Begin // Main
  Try
    // Start up the PR's logging subsystem
    StartLogging(ExtractFilePath(Application.ExeName));
    Try
      // Main UI/Processing wizard
      CloseConvert := False;
      NextStep := stExchPervDir;
      Repeat
        Case NextStep Of
          // Select Exchequer Pervasive Directory
          stExchPervDir      : Begin
                                 CloseConvert := Not SelectExchequerPervasiveDirectory;
                                 NextStep := stGetPSQLCompanies;
                               End; // stExchPervDir

          // Get the list of valid companies from the Pervasive installation
          stGetPSQLCompanies : Begin
                                 CloseConvert := Not GetExchequerPervasiveCompanies;
                                 NextStep := stCheckLicences;
                               End; // stGetPSQLCompanies

          // Check Pervasive and SQL licences for compatibility, e.g. both MCSOP etc...
          stCheckLicences    : Begin
                                 CloseConvert := Not LicencesCompatible;
                                 NextStep := stReportingUsers;
                               End; // stCheckLicences

          // Allow users to specify own reporting user User Id and Passwords
          stReportingUsers   : Begin
                                 CloseConvert := Not GetReportingUsers;
                                 NextStep := stConfirm;
                               End; // stReportingUsers

          // Confirmation dialog - users must confirm warnings and acknowledge backup, etc...
          stConfirm          : Begin
                                 CloseConvert := Not GetUserConfirmation;
                                 NextStep := stDropSQLDB;

// Jump to conversion tree window - skip recreation of the database/tables/users
//NextStep := stGetConnStrings;
                               End; // stConfirm

          // Delete the existing SQL Database from the host Exchequer SQL installation
          stDropSQLDB        : Begin
                                 CloseConvert := Not DropDatabase;
                                 NextStep := stCreateSQLDB;
                               End; // stDropSQLDB

          // Create a new SQL Database
          stCreateSQLDB      : Begin
                                 CloseConvert := Not RecreateDatabase (ConversionOptions.coDataSource, ConversionOptions.coDatabaseName);
                                 NextStep := stCreateTables;
                               End; // stCreateSQLDB

          // MH 26/06/2012 v7.0: Create the tables for each company
          stCreateTables     : Begin
                                 CloseConvert := Not CreateCompanyTables;
                                 NextStep := stGetConnStrings;
                               End; // stCreateTables

          // MH 04/07/2012 v7.0: Load Connection strings
          stGetConnStrings   : Begin
                                 CloseConvert := Not GetConnectionStrings;
                                 NextStep := stPrepareCompanies;
// Complete before the data conversion process
//NextStep := stFinito;
                               End; // stCreateTables

          // MH 26/01/2017 2017-R1 ABSEXCH-18202: Tidy up the new Company tables ready for the conversion
          stPrepareCompanies : Begin
                                 CloseConvert := Not PrepareCompanies;
                                 NextStep := stDisableIndexes;
                               End; // stPrepareCompanies

          // MH 13/02/2013 v7.0.2 ABSEXCH-13360: Disable indexes to improve write performance
          stDisableIndexes   : Begin
                                 CloseConvert := Not DisableIndexes;
                                 // MH 26/01/2017 2017-R1 ABSEXCH-18220: Completed merge of ABSEXCH-15244 into live code
                                 NextStep := stDisableForeignKeys;
                               End; // stDisableIndexes

          // MH 26/01/2017 2017-R1 ABSEXCH-18220: Completed merge of ABSEXCH-15244 into live code
          // CJS 2014-04-02 - ABSEXCH-15244 - Disable Foreign Key constraints to prevent import errors
          stDisableForeignKeys: Begin
                                  CloseConvert := Not DisableForeignKeys;
                                  NextStep := stConvertDatabase;
                                End;

          // Run iCoreDBConverter to convert the data
          stConvertDatabase  : Begin
                                 CloseConvert := Not ConvertData;
                                 NextStep := stCheckDataWarnings;
                               End; // stConvertDatabase

          // Display any data conversion warnings generated in ConvertData and get user authorisation to continue
          stCheckDataWarnings: Begin
                                 CloseConvert := Not CheckDataWarnings;
                                 NextStep := stFixupLicence;
// Skip licence fixes,etc...
//NextStep := stFinito;
                               End; // stCheckDataWarnings

          // Fixup Licensing in MS SQL
          stFixupLicence     : Begin
                                 CloseConvert := Not FixupSQLLicensing;
                                 NextStep := stReorderRecords;
//NextStep := stFinito;
                               End; // stFixupLicence

          // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
          stReorderRecords   : Begin
                                 CloseConvert := Not ReorderBatchReceiptRecords;
                                 NextStep := stUpdateDictnary;
                               End;

          // Import the up-to-date Dictnary.Zip to MS SQL installation
          stUpdateDictnary   : Begin
                                 CloseConvert := Not ImportDictionary;
                                 NextStep := stClearOutSQLFiles;
                               End; // stUpdateDictnary

          // Remove any default forms/reports/signatures/etc... installed with the host SQL Installation
          stClearOutSQLFiles : Begin
                                 RemoveSQLDataFiles;
                                 NextStep := stCopyCompanyFiles;
                               End; // stClearOutSQLFiles

          // Copy Forms/Reports/Links/Signatures/Docs/etc... from P.SQL to MS SQL
          stCopyCompanyFiles : Begin
                                 CopyCompanyFilesToSQL;
                                 NextStep := stFinito;
                               End; // stCopyCompanyFiles

          stFinito           : Begin
                                 Complete;
                                 CloseConvert := True;
                               End; // stFinito
        Else
          CloseConvert := True;
        End; // Case NextStep
      Until CloseConvert;
    Finally
      StopLogging;
    End; // Try..Finally

    Close;
  Except
    On E:Exception Do
    Begin
      MessageDlg (E.Message, mtError, [mbOK], 0);
      Close;
    End; // On E:Exception
  End; // Try..Except
End; // Main

//=========================================================================

Initialization
  FillChar (FakeESN, SizeOf(FakeESN), #0);
end.

