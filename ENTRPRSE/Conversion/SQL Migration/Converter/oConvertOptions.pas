unit oConvertOptions;

interface

{$IFDEF SQLConversion}
Uses Classes, Dialogs, Forms, Messages, StrUtils, SysUtils, Windows, VAOUtil, LicRec;

const
  // The message is posted back to the progress window when the Read Thread detects the completion
  // (successful or otherwise) of the data copying process
  WM_DataConversionFinished   = WM_User + $1;

  // This message is posted back to the Progress Tree window when the Write Thread Pool detects a
  // low memory situation and pauses the conversion
  WM_LowMemoryWarning = WM_User + $2;
{$ENDIF}

Type
  // MH 25/06/2012 v7.0: Added Data Conversion Tasks against the companies
  TDataConversionTasks = (
                          // Root company only tables
                          dmtCompany,         // Company.Dat
                          dmtGroupCmp,
                          dmtGroups,          // Groups.Dat
                          dmtGroupUsr,        // GroupUsr.Dat
                          dmtContact,         // Contact.Dat
                          dmtEbus,            // Ebus.Dat
                          dmtEmpPay,          // JC\EmpPay.Dat
                          dmtFaxes,           // FaxSrv\Faxes.Dat
                          dmtImportJob,       // Misc\ImportJob.Dat
                          dmtMCPay,           // JC\MCPay.Dat
                          dmtPAAuth,          // Workflow\PAAuth.Dat
                          dmtPAComp,          // Workflow\PAComp.Dat
                          dmtPAEAR,           // Workflow\PAEAR.Dat
                          dmtPAGlobal,        // Workflow\PAGlobal.Dat
                          dmtPAUser,          // Workflow\PAUser.Dat
                          dmtSchedCfg,        // SchedCfg.Dat
//                          dmtSentSys,         // SentSys.Dat
                          dmtTillName,        // Trade\TillName.Dat
                          dmtTools,           // Tools.Dat
                          // All Companies tables
                          dmtCCDeptV,         // CCDeptV.Dat
                          dmtColSet,          // Misc\ColSet.Dat
                          dmtCommssn,         // SalesCom\Commssn.Dat
                          dmtCustomFields,    // Misc\CustomFields.Dat
                          dmtCurrencyHistory, // CurrencyHistory.Dat
                          dmtCustSupp,        // Cust\CustSupp.Dat
                          dmtDetails,         // Trans\Details.Dat
                          dmtDocument,        // Trans\Document.Dat
                          dmtEbusDetl,        // Ebus\EbusDetl.Dat
                          dmtEbusDoc,         // Ebus\EbusDoc.Dat
                          dmtEbusLkup,        // Ebus\EbusLkup.Dat
                          dmtEbusNote,        // Ebus\EbusNote.Dat
                          dmtExchqChk,        // Misc\ExchqChk.Dat
                          dmtExchqNum,        // ExchqNum.Dat
                          dmtExchqSS,         // ExchqSS.Dat
                          dmtExStkChk,        // Misc\ExStkChk.Dat
                          dmtGLBudgetHistory, // Trans\GLBudgetHistory.Dat
                          dmtHistory,         // Trans\History.Dat
                          dmtHistPurge,       // Trans\HistPrge.Dat
                          dmtJobCtrl,         // Jobs\JobCtrl.Dat
                          dmtJobDet,          // Jobs\JobDet.Dat
                          dmtJobHead,         // Jobs\JobHead.Dat
                          dmtJobMisc,         // Jobs\JobMisc.Dat
                          dmtLBin,            // Trade\LBin.Dat
                          dmtLHeader,         // Trade\LHeader.Dat
                          dmtLLines,          // Trade\LLines.Dat
                          dmtLSerial,         // Trade\LSerial.Dat
                          dmtMLocStk,         // Stock\MLocStk.Dat
                          dmtMultiBuy,        // Misc\MultiBuy.Dat
                          dmtNominal,         // Trans\Nominal.Dat
                          dmtNomView,         // Trans\NomView.Dat
                          dmtPaprSize,        // Forms\PaprSize.Dat
                          dmtParSet,          // Misc\ParSet.Dat
                          dmtPPCust,          // PromPay\PPCust.Dat
                          dmtPPDebt,          // PromPay\PPDebt.Dat
                          dmtPPSetup,         // PromPay\PPSetup.Dat
                          dmtQtyBreak,        // Misc\QtyBreak.Dat
                          dmtSaleCode,        // SalesCom\SaleCode.Dat
                          dmtSchedule,        // Schedule\Schedule.Dat
                          dmtSCType,          // SalesCom\SCType.Dat
                          dmtSent,            // Smail\Sent.Dat
                          dmtSentLine,        // Smail\SentLine.Dat
                          dmtSettings,        // Misc\Settings.Dat
                          dmtSortView,        // Misc\SortView.Dat
                          dmtStock,           // Stock\Stock.Dat
                          dmtSVUsrDef,        // Misc\SVUsrDef.Dat
                          dmtUDEntity,        // UDEntity.Dat
                          dmtUDField,         // UDField.Dat
                          dmtUDItem,          // UDItem.Dat
                          dmtVAT100,          // VAT100.Dat
                          dmtVatOpt,          // VatPer\VatOpt.Dat
                          dmtVatPrd,          // VatPer\VatPrd.Dat
                          dmtVRWSec,          // Reports\VRWSec.Dat
                          dmtVRWTree,         // Reports\VRWTree.Dat
                          dmtWinSet,          // Misc\WinSet.Dat
                          dmtAccountContact,     // AccountContact.dat
                          dmtAccountContactRole, // AccountContactRole.dat
                          // MH 24/10/2014: Added support for new Order Payments fields
                          dmtOrdPayVATPayments,  // Trans\OPVATPay.Dat
                          // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new SystemSetup table
                          dmtSystemSetup,          // SystemSetup.dat
                          // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                          dmtAnonymisationDiary  // Misc\AnonymisationDiary.dat
                         );

  //------------------------------

  TDataConversionTaskStatus = (ctsNotStarted=0, ctsInProgress=1, ctsComplete=2);

  // Generic interface for objects which implement a specific import type
  IDataConversionTask = Interface
    ['{E6A08114-C365-44F6-953C-C14D6230A83F}']
    // --- Internal Methods to implement Public Properties ---
    Function GetTaskId : TDataConversionTasks;
    Function GetTaskDescription : ShortString;
    Function GetPervasiveFilename : ShortString;
    Function GetRootCompanyOnly : Boolean;
    Function GetSingleThreadOnly : Boolean;
    Function GetOptionalFile : Boolean;
    Function GetImportZIPFile : ShortString;
    Function GetRecordLength : Integer;

    Function GetStatus : TDataConversionTaskStatus;
    Function GetTotalRecords : Integer;
    Function GetTotalRead : Integer;
    Function GetTotalWritten : Integer;

    // ------------------ Public Properties ------------------
    Property dctTaskId : TDataConversionTasks Read GetTaskId;
    Property dctTaskDescription : ShortString Read GetTaskDescription;
    Property dctPervasiveFilename : ShortString Read GetPervasiveFilename;
    Property dctRootCompanyOnly : Boolean Read GetRootCompanyOnly;
    // Indicates if the task must be run sequentially within a single thread or
    // whether different rows can be split across multiple threads
    Property dctSingleThreadOnly : Boolean Read GetSingleThreadOnly;
    Property dctOptionalFile : Boolean Read GetOptionalFile;
    Property dctImportZIPFile : ShortString Read GetImportZIPFile;
    // The length of the record in the PErvasive.SQL source file, this is set
    // when the Btrieve Read Thread opens the table for processing [Thread Safe]
    Property dctRecordLength : Integer Read GetRecordLength;

    // Progress Properties
    // The status of this task in the conversion - not started/in progress/complete [Thread Safe]
    Property dctStatus : TDataConversionTaskStatus Read GetStatus;
    // The total number of records in the source Pervasive.SQL table, set when the
    // Btrieve Read Thread opens the table for processing [Thread Safe]
    Property dctTotalRecords : Integer Read GetTotalRecords;
    // The total number of Pervasive source records read and queued by the Btrieve
    // Read Thread [Thread Safe]
    Property dctTotalRead : Integer Read GetTotalRead;
    // The total number of queued records written by the SQL Write Threads [Thread Safe]
    Property dctTotalWritten : Integer Read GetTotalWritten;

    // ------------------- Public Methods --------------------
    // Marks the task as 'In Progress' and initialises the total number of records to be converted [Thread Safe]
    Procedure StartTask (Const TotalRecords, RecordLength : Integer);
    // Updates dctTotalRead in a thread-safe manner [Thread Safe]
    Procedure UpdateReadProgress (Const TotalRecordsRead : Integer);
    // Increments the dctTotalWritten property in a thread-safe manner [Thread Safe]
    Procedure UpdateTotalWritten;
  End; // IDataConversionTask

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IConversionCompany = Interface
    ['{1EE9ABE2-E7D2-4473-8A3B-86A41FE381E8}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCompanyCode : ShortString;
    Function GetCompanyName : ShortString;
    Function GetCompanyPath : ShortString;
    Function GetSQLCompanyPath : ShortString;
    Function GetConversionTaskCount : LongInt;
    Function GetConversionTask (Index : LongInt) : IDataConversionTask;

    // ------------------ Public Properties ------------------
    Property ccCompanyCode : ShortString Read GetCompanyCode;
    Property ccCompanyName : ShortString Read GetCompanyName;
    Property ccCompanyPath : ShortString Read GetCompanyPath;

    Property ccSQLCompanyPath : ShortString Read GetSQLCompanyPath;

    Property ccConversionTaskCount : LongInt Read GetConversionTaskCount;
    Property ccConversionTasks [Index : LongInt] : IDataConversionTask Read GetConversionTask;

    // ------------------- Public Methods --------------------
  End; // IConversionCompany

  // Public interface used by the DLL when building the list of companies
  IConversionOptions = Interface
    ['{95B72F89-F308-420A-8346-63B4D37803EE}']
    // --- Internal Methods to implement Public Properties ---
    Function GetSQLDirectory : ShortString;
    Function GetCompanyCount : LongInt;
    Function GetCompaniesI (Index : LongInt) : IConversionCompany;

    // ------------------ Public Properties ------------------
    Property coCompanyCount : LongInt Read GetCompanyCount;
    Property coCompanies [Index : LongInt] : IConversionCompany Read GetCompaniesI;
    Property coSQLDirectory : ShortString Read GetSQLDirectory;

    // ------------------- Public Methods --------------------
    Procedure AddCompany (Const CompanyCode, CompanyName, CompanyPath : ShortString);
    Function IndexOf (Const CompanyCode : ShortString) : LongInt;
  End; // IConversionOptions

  //------------------------------

{$IFDEF SQLConversion}
  pEntLicenceRecType = ^EntLicenceRecType;

  coWarningsType = (cowExchDll);

  TDataConversionCompanyStatus = (ccsNotStarted=0, ccsInProgress=1, ccsComplete=2);

  TConversionCompany = Class(TInterfacedObject, IConversionCompany)
  Private
    FCompanyCode : ShortString;
    FCompanyName : ShortString;
    FCompanyPath : ShortString;
    FAdminUserId : ShortString;
    FAdminUserPwd : ShortString;
    FReportingUserId : ShortString;
    FReportingUserPwd : ShortString;
    FRootCompany : Boolean;
    FSQLCompanyPath : ShortString;
    FAdminConnectionString : ANSIString;

    FConversionStatus : TDataConversionCompanyStatus;
    FConversionTasks : TInterfaceList;

    FStartTime : TDateTime;
    FFinishTime : TDateTime;

    // IConversionCompany
    Function GetCompanyCode : ShortString;
    Function GetCompanyName : ShortString;
    Function GetCompanyPath : ShortString;
    Function GetSQLCompanyPath : ShortString;
    Function GetValidCompanyCode : Boolean;
    Function GetConversionStatus : TDataConversionCompanyStatus;
    Function GetConversionTaskCount : LongInt;
    Function GetConversionTask (Index : LongInt) : IDataConversionTask;
  Public
    Property ccCompanyCode : ShortString Read GetCompanyCode;
    Property ccCompanyName : ShortString Read GetCompanyName;
    Property ccCompanyPath : ShortString Read GetCompanyPath;
    Property ccAdminUserId : ShortString Read FAdminUserId;
    Property ccAdminUserPwd : ShortString Read FAdminUserPwd;
    Property ccValidCompanyCode : Boolean Read GetValidCompanyCode;
    Property ccReportingUserId : ShortString Read FReportingUserId Write FReportingUserId;
    Property ccReportingUserPwd : ShortString Read FReportingUserPwd Write FReportingUserPwd;
    Property ccRootCompany : Boolean Read FRootCompany;
    Property ccSQLCompanyPath : ShortString Read FSQLCompanyPath;
    Property ccAdminConnectionString : ANSIString Read FAdminConnectionString;

    // Indicates the status of the conversion for the Company [Thread Safe]
    Property ccConversionStatus : TDataConversionCompanyStatus Read GetConversionStatus;
    // The number of conversion tasks in the ccConversionTasks array
    Property ccConversionTaskCount : LongInt Read GetConversionTaskCount;
    // The array of conversion tasks for this company
    Property ccConversionTasks [Index : LongInt] : IDataConversionTask Read GetConversionTask;
    Property ccConversionStartTime : TDateTime Read FStartTime;
    Property ccConversionFinishTime : TDateTime Read FFinishTime;

    Constructor Create (Const CompanyCode, CompanyName, CompanyPath : ShortString);
    Destructor Destroy; Override;

    // MH 25/06/2012 v7.0: Added Data Conversion Tasks against the companies
    Function ScanForTasks (Var ErrorStr : ShortString) : Boolean;
    // Called when a task for the company is started so the Company can be marked as in progress [Thread Safe]
    Procedure StartTask;
    // Check to see if the Company Status should be changed [Thread Safe]
    Procedure CheckForCompletion;
    // Loads the SQL Emulator Admin Connection String for the Company tables for use by the SQL Write Threads
    Function LoadCompanyAdminConnectionString : Boolean;
  End; // TConversionCompany

  //------------------------------

  //
  TConversionCompanyReference = Class(TObject)
  Private
    FInterfaceRef : IConversionCompany;
    FObjectRef : TConversionCompany;
  Public
    Property crObject : TConversionCompany Read FObjectRef;
    Property crInterface : IConversionCompany Read FInterfaceRef;

    Constructor Create (Const CompanyCode, CompanyName, CompanyPath : ShortString);
    Destructor Destroy; Override;
  End; // TConversionCompanyReference

  //------------------------------

  TLicenceInformation = Class(TObject)
  Private
    FLicenceRec : pEntLicenceRecType;
    Function GetESN : ESNByteArrayType;
    Function GetCountry : Byte;
    Function GetCurrencyVer : Byte;
    Function GetModuleVer : Byte;
    Function GetProductType : Byte;
  Public
    Property liESN : ESNByteArrayType Read GetESN;
    Property liCountry : Byte Read GetCountry;
    Property liCurrencyVer : Byte Read GetCurrencyVer;
    Property liModuleVer : Byte Read GetModuleVer;
    Property liProductType : Byte Read GetProductType;

    Constructor Create (Const LicAddr : pEntLicenceRecType);
  End; // TLicenceInformation

  //------------------------------

  TConversionOptions = Class(TInterfacedObject, IConversionOptions)
  Private
    FCommonConnectionString : ANSIString;
    FDatabaseName : ShortString;
    FDataSource : ShortString;

    FCompanies : TStringList;
    FPervasiveDirectory : ShortString;
    FSQLDirectory : ShortString;

    FSQLLogins : TStringList;

    FPervasiveLicenceInfo : TLicenceInformation;
    FPervasiveLicence : EntLicenceRecType;

    FSQLLicenceInfo : TLicenceInformation;
    FSQLLicence : EntLicenceRecType;

    FWarnings : Array[coWarningsType] Of Boolean;

    FGlobalAbort : Boolean;
    FGlobalAbortReason : ANSIString;

    FElapsedDataConversionTime : TDateTime;

    // Handle of Progress Tree window for posting messages 
    FhProgressTree : THandle;

    Function GetCompanyCount : LongInt;
    Function GetCompanies (Index : LongInt) : TConversionCompany;
    Function GetCompaniesI (Index : LongInt) : IConversionCompany;

    Function GetPervasiveDirectory : ShortString;
    Procedure SetPervasiveDirectory (Value : ShortString);

    Function GetSQLDirectory : ShortString;
    Procedure SetSQLDirectory (Value : ShortString);

    Function GetSQLLoginCount : LongInt;
    Function GetSQLLogins (Index : LongInt) : ShortString;

    Function GetWarnings (Index : coWarningsType) : Boolean;
    Procedure SetWarnings (Index : coWarningsType; Value : Boolean);

    // IConversionOptions
    Procedure AddCompany (Const CompanyCode, CompanyName, CompanyPath : ShortString);
    Function IndexOf (Const CompanyCode : ShortString) : LongInt;
  Public
    Property coCommonConnectionString : ANSIString Read FCommonConnectionString;
    Property coDatabaseName : ShortString Read FDatabaseName;
    Property coDataSource : ShortString Read FDataSource;

    Property coCompanyCount : LongInt Read GetCompanyCount;
    Property coCompanies [Index : LongInt] : TConversionCompany Read GetCompanies;
    Property coPervasiveDirectory : ShortString Read GetPervasiveDirectory Write SetPervasiveDirectory;
    Property coPervasiveLicence : TLicenceInformation Read FPervasiveLicenceInfo;
    Property coSQLDirectory : ShortString Read GetSQLDirectory Write SetSQLDirectory;

    Property coSQLLicence : TLicenceInformation Read FSQLLicenceInfo;
    Property coSQLLoginCount : LongInt Read GetSQLLoginCount;
    Property coSQLLogins [Index : LongInt] : ShortString Read GetSQLLogins;

    // Flags to indicate misc items failed during the conversion
    Property coWarnings [Index : coWarningsType] : Boolean Read GetWarnings Write SetWarnings;

    Property GlobalAbort : Boolean Read FGlobalAbort;
    Property GlobalAbortReason : ANSIString Read FGlobalAbortReason;

    Property ElapsedDataConversionTime : TDateTime Read FElapsedDataConversionTime Write FElapsedDataConversionTime;

    // Window handle for Progress Tree window for posting messages from the threads
    Property hProgressTree : THandle Read FhProgressTree Write FhProgressTree;

    Constructor Create;
    Destructor Destroy; Override;

    // Moves the root company to the first position in the list so it gets processed first
    Procedure MoveRootToFirst;
    // Sets the GlobalAbort flag to stop the conversion process [Thread Safe]
    Procedure Abort (Const AbortReason : ANSIString);
    // Reloads the SQL Emulator Connection String for the Common tables for use by the SQL Write Threads
    Function ReloadCommonConnectionString : Integer;
  End; // TConversionOptions


Function ConversionOptions : TConversionOptions;
{$ENDIF}

implementation

{$IFDEF SQLConversion}

Uses SQLH_MemMap, APIUtil, DllIntf, ProgressF, oDataConversionTask, SyncObjs, SQLUtils;

Var
  oConversionOptions : TConversionOptions;
  OptionsCriticalSection : TCriticalSection;

//=========================================================================

Function ConversionOptions : TConversionOptions;
Begin { ConversionOptions }
  If (Not Assigned(oConversionOptions)) Then
    oConversionOptions := TConversionOptions.Create;

  Result := oConversionOptions;
End; // ConversionOptions

//=========================================================================

Constructor TConversionCompany.Create (Const CompanyCode, CompanyName, CompanyPath : ShortString);
Var
  sShortPerv, sShortComp : ShortString;

  // Returns a default Reporting User Id based on the Company Code
  Function ReportingUser (CompCode : ShortString) : ShortString;
  Begin // ReportingUser
    Result := 'REP' + Trim(CompCode) + Format ('%.3d', [Random(1000)]);
  End; // ReportingUser

  //------------------------------

  // Returns a default Reporting User Password based on Random upper and lower-case characters and numbers
  Function ReportingPassword : ShortString;
  Const
    Alpha   : Array[1..26] Of String = ('a','b','c','d','e','f','g','h','j','i','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
    Numeric : Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
  Begin // ReportingPassword
    Result := RandomFrom(Alpha) +
              RandomFrom(Numeric) +
              UpperCase(RandomFrom(Alpha)) +
              RandomFrom(Numeric) +
              UpperCase(RandomFrom(Alpha)) +
              RandomFrom(Alpha) +
              UpperCase(RandomFrom(Alpha)) +
              RandomFrom(Alpha);
  End; // ReportingPassword

  // -----------------------------------------------------------------------------

  function AdminUser(CompanyCode: string): string;
  begin
    Result := 'ADM' + FormatDateTime('hhnn', Now) + Trim(CompanyCode) +
              Format('%.3d', [Random(1000)]);
  end;

  // -----------------------------------------------------------------------------

  //
  // MH 17/04/08: Replaces as it was failing the SQL Server password complexity checks
  //
  //function AdminPassword: string;
  //var
  //  GUID: TGUID;
  //begin
  //  CreateGUID(GUID);
  //  Result := StringReplace(GUIDToString(GUID), '-', '', [rfReplaceAll]);
  //  Result := Copy(Result, 2, Length(Result) - 2);
  //end;

  Function AdminPassword : ShortString;
  Const
    Symbols : Array[1..10] of String = ('$', '*', '-', '!', '#', '@', '%', '&', '~', '.');
    Alpha   : Array[1..26] Of String = ('a','b','c','d','e','f','g','h','j','i','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
    Numeric : Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
  Var
    GUID: TGUID;
    sGUID : ShortString;
  Begin
    CreateGUID(GUID);
    sGUID := StringReplace(GUIDToString(GUID), '-', '', [rfReplaceAll]);

    // Due to possible password complexity requirements within SQL Server always have 1 symbol + 1 lowercase + 1 uppercase + 1 number
    Result := RandomFrom(Symbols) + RandomFrom(Alpha) + UpperCase(RandomFrom(Alpha)) + RandomFrom(Numeric) + Copy(sGUID, 2, 26);
  End;

  //------------------------------

Begin // Create
  Inherited Create;

  FCompanyCode := CompanyCode;
  FCompanyName := CompanyName;
  FCompanyPath := CompanyPath;

  // Automatically generate Company Admin and Reporting User Id's and passwords
  FAdminUserId := AdminUser(FCompanyCode);
  FAdminUserPwd := AdminPassword;

  FReportingUserId := ReportingUser (FCompanyCode);
  FReportingUserPwd := ReportingPassword;

  // The Connection String is populated with the Admin Connection String once the database
  // and companies have been recreated for use by the SQL Data Write objects 
  FAdminConnectionString := '';

  // Work out whether it is a root directory
  sShortPerv := UpperCase(ExtractShortPathName(ConversionOptions.coPervasiveDirectory));
  sShortComp := UpperCase(ExtractShortPathName(FCompanyPath));
  FRootCompany := (sShortPerv = sShortComp);

  // Determine where the company is going to be put off the SQL installation
  If FRootCompany Then
    FSQLCompanyPath := ConversionOptions.coSQLDirectory
  Else
    FSQLCompanyPath := ConversionOptions.coSQLDirectory + 'Companies\' + Trim(FCompanyCode) + '\';

  FConversionStatus := ccsNotStarted;
  FStartTime := 0;
  FFinishTime := 0;

  FConversionTasks := TInterfaceList.Create;
End; // Create

//------------------------------

Destructor TConversionCompany.Destroy;
Begin // Destroy
  FConversionTasks.Clear;
  FConversionTasks.Destroy;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Loads the SQL Emulator Admin Connection String for the Company tables for use by the SQL Write Threads
Function TConversionCompany.LoadCompanyAdminConnectionString : Boolean;
Var
  Res : Integer;
Begin // LoadCompanyAdminConnectionString
  // Get Company Admin Connection String - Read-Only won't be able to insert data
  Res := GetConnectionString(FCompanyCode, False, FAdminConnectionString);
  If (Res <> 0) Then
    FAdminConnectionString := IntToStr(Res) + ': ' + GetSQLErrorInformation(Res);
  Result := (Res = 0);
End; // LoadCompanyAdminConnectionString

//-------------------------------------------------------------------------

// Called when a task for the company is started so the Company can be marked as in progress
Procedure TConversionCompany.StartTask;
Begin // StartTask
  OptionsCriticalSection.Acquire;
  Try
    If (FConversionStatus = ccsNotStarted) Then
    Begin
      FConversionStatus := ccsInProgress;
      FStartTime := Now;
    End // If (FConversionStatus = ccsNotStarted)
  Finally
    OptionsCriticalSection.Release;
  End; // Try..Finally
End; // StartTask

//-------------------------------------------------------------------------

// Check to see if the Company Status should be changed
Procedure TConversionCompany.CheckForCompletion;
Var
  bAllComplete : Boolean;
  iTask : Integer;
Begin // CheckForCompletion
  OptionsCriticalSection.Acquire;
  Try
    // Run through the tasks and check their status - if all are complete then change the
    // Company Status to complete.  Run through the tasks backwards as the odds are that
    // incomplete tasks will be at the end of the list of tasks
    bAllComplete := True;
    For iTask := (FConversionTasks.Count - 1) DownTo 0 Do
    Begin
      If ((FConversionTasks.Items[iTask] As IDataConversionTask).dctStatus <> ctsComplete) Then
      Begin
        bAllComplete := False;
        Break;
      End; // If ((FConversionTasks.Items[iTask] As IDataConversionTask).dctStatus <> ctsComplete)
    End; // For iTask

    If bAllComplete Then
    Begin
      FConversionStatus := ccsComplete;
      FFinishTime := Now;
    End; // If bAllComplete
  Finally
    OptionsCriticalSection.Release;
  End; // Try..Finally
End; // CheckForCompletion

//-------------------------------------------------------------------------

// MH 25/06/2012 v7.0: Added Data Conversion Tasks against the companies
// Runs through the list of data conversion tasks identifying which tasks need to be
// performed against the company represented by the current object
Function TConversionCompany.ScanForTasks (Var ErrorStr : ShortString) : Boolean;
Var
  iTask : TDataConversionTasks;
  iDataConvTask : IDataConversionTask;
Begin // ScanForTasks
  Result := True;
  ErrorStr := '';

  For iTask := Low(iTask) To High(iTask) Do
  Begin
    // Create the appropriate DataConversionTask object which contains information about the task
    iDataConvTask := CreateDataConversionTask (iTask);
    Try
      // Check to see if the Pervasive.SQL data file exists for this task, if so add it into the
      // internal tasks list for this company

      // If the file is only present for Root Companies then check that this is the Root Company
      If (FRootCompany And iDataConvTask.dctRootCompanyOnly) Or (Not iDataConvTask.dctRootCompanyOnly) Then
      Begin
        // Check whether the file is present
        If FileExists(IncludeTrailingPathDelimiter(Trim(FCompanyPath)) + iDataConvTask.dctPervasiveFilename) Then
        Begin
          // File present - Add it into the list of conversion tasks
          FConversionTasks.Add(iDataConvTask);
        End // If FileExists(IncludeTrailingPathDelimiter(Trim(FCompanyPath)) + dctPervasiveFilename)
        Else
        Begin
          // File not found - check whether it is mandatory
          If (Not iDataConvTask.dctOptionalFile) Then
          Begin
            // Error
            Result := False;
            ErrorStr := 'The Pervasive.SQL data file ' + QuotedStr(iDataConvTask.dctPervasiveFilename) + ' was not found in Company ' + Trim(FCompanyCode);
          End; // If (Not iDataConvTask.dctOptionalFile)
        End; // Else
      End; // If (FRootCompany And iDataConvTask.dctRootCompanyOnly) Or (Not iDataConvTask.dctRootCompanyOnly)
    Finally
      iDataConvTask := NIL;
    End; // Try..Finally
  End; // For iTask
End; // ScanForTasks

//-------------------------------------------------------------------------

Function TConversionCompany.GetCompanyCode : ShortString;
Begin // GetCompanyCode
  Result := FCompanyCode;
End; // GetCompanyCode

//------------------------------

Function TConversionCompany.GetCompanyName : ShortString;
Begin // GetCompanyName
  Result := FCompanyName;
End; // GetCompanyName

//------------------------------

Function TConversionCompany.GetCompanyPath : ShortString;
Begin // GetCompanyPath
  Result := FCompanyPath;
End; // GetCompanyPath

//------------------------------

Function TConversionCompany.GetSQLCompanyPath : ShortString;
Begin // GetSQLCompanyPath
  Result := FSQLCompanyPath;
End; // GetSQLCompanyPath

//------------------------------

// Duplicated in X:\Entrprse\Setup\uGetCompanyDetail.Pas
Function TConversionCompany.GetValidCompanyCode : Boolean;
Const
  ValidChars = ['A'..'Z', '0'..'9'];
Var
  sCode : ShortString;
  I: SmallInt;
Begin
  sCode := UpperCase(Trim(FCompanyCode));
  Result := (sCode <> '') And (Not (sCode[1] In ['0'..'9']));
  If Result Then
  Begin
    For I := 1 To Length(sCode) Do
    Begin
      If Not (sCode[I] In ValidChars) Then
      Begin
        Result := False;
        Break;
      End; { If }
    End; { For }
  End; { If }
End;

//------------------------------

Function TConversionCompany.GetConversionStatus : TDataConversionCompanyStatus;
Begin // GetConversionStatus
  OptionsCriticalSection.Acquire;
  Try
    Result := FConversionStatus;
  Finally
    OptionsCriticalSection.Release;
  End; // Try..Finally
End; // GetConversionStatus

//------------------------------

Function TConversionCompany.GetConversionTaskCount : LongInt;
Begin // GetConversionTaskCount
  Result := FConversionTasks.Count;
End; // GetConversionTaskCount

//------------------------------

Function TConversionCompany.GetConversionTask (Index : LongInt) : IDataConversionTask;
Begin // GetConversionTask
  If (Index >= 0) And (Index < FConversionTasks.Count) Then
    Result := FConversionTasks.Items[Index] As IDataConversionTask
  Else
    Raise Exception.Create ('TConversionCompany.GetConversionTask: Invalid Index (' + IntToStr(Index) + ')');
End; // GetConversionTask

//=========================================================================

Constructor TLicenceInformation.Create (Const LicAddr : pEntLicenceRecType);
Begin // Create
  Inherited Create;
  FLicenceRec := LicAddr;
End; // Create

//-------------------------------------------------------------------------

Function TLicenceInformation.GetESN : ESNByteArrayType;
Begin // GetESN
  Result := FLicenceRec.licISN;
End; // GetESN

//------------------------------

Function TLicenceInformation.GetCountry : Byte;
Begin // GetCountry
  Result := FLicenceRec.licCountry;
End; // GetCountry

//------------------------------

Function TLicenceInformation.GetCurrencyVer : Byte;
Begin // GetCurrencyVer
  Result := FLicenceRec.licEntCVer;
End; // GetCurrencyVer

//------------------------------

Function TLicenceInformation.GetModuleVer : Byte;
Begin // GetModuleVer
  Result := FLicenceRec.licEntModVer;
End; // GetModuleVer

//------------------------------

Function TLicenceInformation.GetProductType : Byte;
Begin // GetProductType
  Result := FLicenceRec.licProductType;
End; // GetProductType

//=========================================================================

Constructor TConversionCompanyReference.Create (Const CompanyCode, CompanyName, CompanyPath : ShortString);
Begin // Create
  Inherited Create;

  FObjectRef := TConversionCompany.Create(CompanyCode, CompanyName, CompanyPath);
  FInterfaceRef := FObjectRef;
End; // Create

Destructor TConversionCompanyReference.Destroy;
Begin // Destroy
  FObjectRef := NIL;
  FInterfaceRef := NIL;  // This will cause the reference counting mechanism to destroy the object
  Inherited Destroy;
End; // Destroy

//=========================================================================

Constructor TConversionOptions.Create;
Var
  Res, iPos : LongInt;
  sLogin : ShortString;
Begin // Create
  Inherited Create;

  FGlobalAbort := False;
  FGlobalAbortReason := '';

  FCompanies := TStringList.Create;
  FSQLLogins := TStringList.Create;

  FPervasiveLicenceInfo := TLicenceInformation.Create(@FPervasiveLicence);
  FSQLLicenceInfo := TLicenceInformation.Create(@FSQLLicence);

  // App is designed to be installed in SQL Directory so this will work
  SetSQLDirectory (ExtractFilePath(Application.ExeName));

  // Get common connection string using SQLHelpr.Exe in SQL Directory
  Res := ReloadCommonConnectionString;
  If (Res = 0) Then
  Begin
    // Parse connection string into individual elements
    //
    //   e.g.  Provider=SQLOLEDB.1;Data Source=IRIS-6CB13B02D4\IRISSOFTWARE;Initial Catalog=ExchConv;User Id=ExchConv_Admin;Password=Password123
    //

    // Data Source - needed to connect to DB to validate Reporting User Id's etc...
    iPos := Pos('Data Source=', FCommonConnectionString);
    If (iPos > 0) Then
    Begin
      FDataSource := Copy(FCommonConnectionString, iPos+12, 255);
      iPos := Pos(';', FDataSource);
      If (iPos > 0) Then Delete(FDataSource, iPos, 255);
    End // If (iPos > 0)
    Else
      Raise Exception.Create ('TConversionOptions.Create - Unable to get Data Source');

    // Initial Catalog - appears to be the Database Name - may come in handy when dropping and recreating it!
    iPos := Pos('Initial Catalog=', FCommonConnectionString);
    If (iPos > 0) Then
    Begin
      FDatabaseName := Copy(FCommonConnectionString, iPos+16, 255);
      iPos := Pos(';', FDatabaseName);
      If (iPos > 0) Then Delete(FDatabaseName, iPos, 255);
    End // If (iPos > 0)
    Else
      Raise Exception.Create ('TConversionOptions.Create - Unable to get Database Name');

    // Common Admin User - Need to add into SQL Logins list so it get dropped later
    iPos := Pos('User Id=', FCommonConnectionString);
    If (iPos > 0) Then
    Begin
      sLogin := Copy(FCommonConnectionString, iPos+8, 255);
      iPos := Pos(';', sLogin);
      If (iPos > 0) Then Delete(sLogin, iPos, 255);
      FSQLLogins.Add(Trim(sLogin));
    End // If (iPos > 0)
    Else
      Raise Exception.Create ('TConversionOptions.Create - Unable to get Common User ID');
  End // If (Res = 0)
  Else
    Raise Exception.Create ('TConversionOptions.Create - Error ' + IntToStr(Res) + ' attempting to get Connection String');
End; // Create

//------------------------------

Destructor TConversionOptions.Destroy;
Begin // Destroy
  FSQLLogins.Free;

  While (FCompanies.Count > 0) Do
  Begin
    (FCompanies.Objects[0] As TConversionCompanyReference).Free;
    FCompanies.Delete(0);
  End; // While (FCompany.Count > 0)
  FreeAndNIL(FCompanies);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Loads the SQL Emulator Connection String for the Common tables for use by the SQL Write Threads
Function TConversionOptions.ReloadCommonConnectionString : Integer;
Var
  CompCount, I : SmallInt;
  sLogin : ShortString;
Begin // ReloadCommonConnectionString
  // Due to the SQL Emulator not releasing the ADO Connections to the DB correctly
  // we cannot use it until after the database has been dropped
  GlobalSetupMap.Clear;
  GlobalSetupMap.FunctionId := fnGetConnectionInfo;
  GlobalSetupMap.AddVariable ('V_MAINDIR', FSQLDirectory);
  GlobalSetupMap.AddVariable ('V_CONNECTIONSTRING', '');
  GlobalSetupMap.AddVariable ('V_DLLERROR', '0');

  // Call the SQL Helper Function - .EXE will be in main exchequer directory
  RunApp(FSQLDirectory + 'SQLHELPR.EXE /SQLBODGE', True);

  Result := Ord(GlobalSetupMap.Result);
  If (Result = 0) Then
  Begin
    // Common Connection String
    FCommonConnectionString := GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_CONNECTIONSTRING')].vdValue;

    // List of SQL Users for each company
    FSQLLogins.Clear;
    CompCount := StrToIntDef(GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_SQLCOMPCOUNT')].vdValue, 0);
    For I := 0 To (CompCount - 1) Do
    Begin
      sLogin := GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_COMP' + IntToStr(I+1) + 'REP')].vdValue;
      FSQLLogins.Add(sLogin);

      sLogin := GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_COMP' + IntToStr(I+1) + 'ADM')].vdValue;
      FSQLLogins.Add(sLogin);
    End; // For I
  End // If (Result = 0)
  Else
    FCommonConnectionString := 'Error ' + GlobalSetupMap.Variables[GlobalSetupMap.IndexOf('V_DLLERROR')].vdValue;
End; // ReLoadCommonConnectionString

//-------------------------------------------------------------------------

// Sets the GlobalAbort flag to stop the conversion process
Procedure TConversionOptions.Abort (Const AbortReason : ANSIString);
Begin // Abort
  OptionsCriticalSection.Acquire;
  Try
    FGlobalAbort := True;
    FGlobalAbortReason := AbortReason;
  Finally
    OptionsCriticalSection.Release;
  End; // Try..Finally
End; // Abort

//-------------------------------------------------------------------------

// Moves the root company to the first position in the list so it gets processed first
Procedure TConversionOptions.MoveRootToFirst;
Var
  I : Integer;
Begin // MoveRootToFirst
  For I := 0 To (FCompanies.Count - 1) Do
  Begin
    If GetCompanies (I).ccRootCompany Then
    Begin
      FCompanies.Move(I, 0);
      Break;
    End; // If GetCompanies (I).ccRootCompany
  End; // For I
End; // MoveRootToFirst

//-------------------------------------------------------------------------

Procedure TConversionOptions.AddCompany (Const CompanyCode, CompanyName, CompanyPath : ShortString);
Begin // AddCompany
  FCompanies.AddObject (Trim(CompanyCode), TConversionCompanyReference.Create(CompanyCode, CompanyName, CompanyPath));
  ProgressDialog.UpdateStageProgress(Trim(CompanyCode) + ' - ' + Trim(CompanyName));
End; // AddCompany

//-------------------------------------------------------------------------

Function TConversionOptions.IndexOf (Const CompanyCode : ShortString) : LongInt;
Begin // IndexOf
  Result := FCompanies.IndexOf(Trim(CompanyCode));
End; // IndexOf

//-------------------------------------------------------------------------

Function TConversionOptions.GetCompanyCount : LongInt;
Begin // GetCompanyCount
  Result := FCompanies.Count;
End; // GetCompanyCount

//------------------------------

Function TConversionOptions.GetCompanies (Index : LongInt) : TConversionCompany;
Begin // GetCompanies
  If (Index >= 0) And (Index < FCompanies.Count) Then
    Result := TConversionCompanyReference(FCompanies.Objects[Index]).crObject
  Else
    Raise Exception.Create ('TConversionOptions.GetCompanies: Invalid Index (' + IntToStr(Index) + ')');
End; // GetCompanies

Function TConversionOptions.GetCompaniesI (Index : LongInt) : IConversionCompany;
Begin // GetCompaniesI
  If (Index >= 0) And (Index < FCompanies.Count) Then
    Result := TConversionCompanyReference(FCompanies.Objects[Index]).crInterface
  Else
    Raise Exception.Create ('TConversionOptions.GetCompaniesI: Invalid Index (' + IntToStr(Index) + ')');
End; // GetCompaniesI

//------------------------------

Function TConversionOptions.GetPervasiveDirectory : ShortString;
Begin // GetPervasiveDirectory
  Result := FPervasiveDirectory;
End; // GetPervasiveDirectory
Procedure TConversionOptions.SetPervasiveDirectory (Value : ShortString);
Begin // SetPervasiveDirectory
  If DirectoryExists(Value) Then
  Begin
    FPervasiveDirectory := IncludeTrailingPathDelimiter(Value);

    If (Not ReadExchequerLicence (FPervasiveDirectory + 'Entrprse.Dat', FPervasiveLicence)) Then
      Raise Exception.Create ('TConversionOptions.SetPervasiveDirectory: Unable to read licence from Exchequer Pervasive Edition directory');
  End; // If DirectoryExists(Value)
End; // SetPervasiveDirectory

//------------------------------

Function TConversionOptions.GetSQLDirectory : ShortString;
Begin // GetSQLDirectory
  Result := FSQLDirectory;
End; // GetSQLDirectory
Procedure TConversionOptions.SetSQLDirectory (Value : ShortString);
Begin // SetSQLDirectory
  If DirectoryExists(Value) Then
  Begin
    FSQLDirectory := IncludeTrailingPathDelimiter(Value);

    If (Not ReadExchequerLicence (FSQLDirectory + 'Entrprse.Dat', FSQLLicence)) Then
      Raise Exception.Create ('TConversionOptions.SetSQLDirectory: Unable to read licence from Exchequer SQL Edition directory');
  End; // If DirectoryExists(Value)
End; // SetSQLDirectory

//------------------------------

Function TConversionOptions.GetSQLLoginCount : LongInt;
Begin // GetSQLLoginCount
  Result := FSQLLogins.Count;
End; // GetSQLLoginCount

Function TConversionOptions.GetSQLLogins (Index : LongInt) : ShortString;
Begin // GetSQLLogins
  If (Index >= 0) And (Index < FSQLLogins.Count) Then
    Result := FSQLLogins[Index]
  Else
    Raise Exception.Create ('TConversionOptions.GetSQLLogins: Invalid Index (' + IntToStr(Index) + ')');
End; // GetSQLLogins

//-------------------------------------------------------------------------

Function TConversionOptions.GetWarnings (Index : coWarningsType) : Boolean;
Begin // GetWarnings
  Result := FWarnings[Index];
End; // GetWarnings
Procedure TConversionOptions.SetWarnings (Index : coWarningsType; Value : Boolean);
Begin // SetWarnings
  FWarnings[Index] := Value;
End; // SetWarnings

//=========================================================================

Initialization
  Randomize;
  oConversionOptions := NIL;
  OptionsCriticalSection := TCriticalSection.Create;
Finalization
  FreeAndNIL(oConversionOptions);
  OptionsCriticalSection.Free;
{$ENDIF}
End.
