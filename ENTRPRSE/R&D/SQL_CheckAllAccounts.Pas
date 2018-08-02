unit SQL_CheckAllAccounts;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses Windows, Classes, SysUtils, Dialogs, DB, ADODB, VarConst, SQLCallerU, PostingU,
  EntLoggerClass, IndeterminateProgressF, oProcessLock;

type
  // Main handler for rebuilding Customer/Supplier histories. This completely
  // replaces the TCheckAllAccounts object

  // Intended for Check All Accounts, Version 2, once the Real48 to Double
  // conversion project has been done. At the moment the TCheckAllAccounts
  // class (see below) is used instead.
  TCheckAllAccountsThread = object(TEntPost)
  private
    // Trader Code, when processing a single Trader. If this is empty, it is
    // assumed that all Traders are to be checked.
    FTraderCode: string;

    // Company Code -- required for calling stored procedures
    FCompanyCode: string;

    // Error report logging
    FSQLLogger : TEntSQLReportLogger;

    // SQL access component, to run the stored procedure
    FSQLCaller: TSQLCaller;

    // Progress bar form
    FProgressFrm: TIndeterminateProgressFrm;
    FUpdateOldestDebtOnly: Boolean;

  public
    destructor Destroy; virtual;
    // -------------------------------------------------------------------------
    // Main processing routines
    // -------------------------------------------------------------------------
    // Initialises the system
    function Start: Boolean;
    // Main processing routine, called by the Thread Controller
    procedure Process; virtual;
    // Finish up
    procedure Finish; virtual;

    // -------------------------------------------------------------------------
    // Error handling & logging
    // -------------------------------------------------------------------------
    // Error message display. Displays and logs the supplied error, and sets the
    // abort flag.
    procedure ErrorMessage(const Routine: string; const Msg: string); overload;

    // Updates the error log. This is automatically called by the ErrorMessage
    // routine above
    procedure WriteErrorMsg(const Routine: string; const Msg: string);

    // -------------------------------------------------------------------------
    // Properties
    // -------------------------------------------------------------------------

    // Trader Code, when processing a single Trader. If this is empty, it is
    // assumed that all Traders are to be checked.
    property TraderCode: string read FTraderCode write FTraderCode;
    property UpdateOldestDebtOnly: Boolean read FUpdateOldestDebtOnly write FUpdateOldestDebtOnly;
  end;

(*
  // 'ForEach' callback procedure, used for TGLCodeList.ForEach()
  TForEachGLProc = procedure(Code: Integer) of object;

  // List of Nominal Codes
  TGLCodeList = class(TObject)
  private
    FCodes: array of Integer;
    FCount: Integer;
    function GetCode(Index: Integer): Integer;
    function GetCount: Integer;
  public
    // Adds the supplied Nominal Code to the list if it is not already there.
    // Expands the size of the FCodes list to accommodate the code if the
    // current capacity is exceeded (the FCodes list is expanded in blocks of
    // 10 entries)
    procedure AddCode(Code: Integer);
    // Returns True if the supplied Nominal Code is in the list
    function Exists(Code: Integer): Boolean;
    // Clears the existing codes
    procedure Clear;
    // Calls ForEachProc() for each entry in the list, passing the Nominal Code
    // as the parameter
    procedure ForEach(ForEachProc: TForEachGLProc);
    // Returns the Nominal Code stored in the specified entry. Raises a
    // range-check exception if the supplied index is invalid
    property Code[Index: Integer]: Integer read GetCode;
    // Returns the current number of Nominal Codes stored. Note that this is
    // not necessarily the same as Length(FCodes)
    property Count: Integer read GetCount;
  end;

  // Main handler for rebuilding Customer/Supplier histories
  TCheckAllAccounts = object(TEntPost)
  private
    { TODO: Remove temporary variables }
    // Temporary variables for performance checking
    FStart: TDateTime;
    FFinish: TDateTime;

    // Trader Code, when processing a single Trader. If this is empty, it is
    // assumed that all Traders are to be checked.
    FTraderCode: string;
    // Company Code -- required for calling stored procedures
    FCompanyCode: string;
    // Error report logging
    FSQLLogger : TEntSQLReportLogger;
    // The current Customer/Supplier code
    FAccountCode: string;
    // SQL access components, to run the stored procedure and return the
    // record set
    FSQLCaller: TSQLCaller;
    FSQLCallerForStock: TSQLCaller;
    FSQLCallerForTraders: TSQLCaller;

    // List of Nominal Codes found on Transactions for the current
    // Customer/Supplier
    FGLCodeList: TGLCodeList;

    // Pointer to field objects returned from stored procedures.
    fldCustSupp: TStringField;
    fldAcCode: TStringField;
    fldNomAuto: TBooleanField;
    fldFolioNum: TIntegerField;
    fldRunNo: TIntegerField;
    fldDocType: TIntegerField;
    fldControlGL: TIntegerField;
    fldYear: TIntegerField;
    fldPeriod: TIntegerField;
    fldCurrency: TIntegerField;
    fldRemitNo: TStringField;
    fldSettledVAT: TFloatField;
    fldVATPostDate: TStringField;
    fldUntilDate: TStringField;
    fldDueDate: TStringField;
    fldCurrSettled: TFloatField;
    fldOurRef: TStringField;
    fldCompanyRate: TFloatField;
    fldDailyRate: TFloatField;
    fldOutstanding: TStringField;
    fldTotalOrderOS: TFloatField;
    fldTotalCost: TFloatField;
    fldTotalOrdered: TFloatField;
    fldDeliveryNoteRef: TStringField;
    fldNetValue: TFloatField;
    fldTotalVAT: TFloatField;
    fldTotalLineDiscount: TFloatField;
    fldVariance: TFloatField;
    fldRevalueAdj: TFloatField;
    fldSettleDiscAmount: TFloatField;
    fldSettleDiscTaken: TBooleanField;
    fldAmountSettled: TFloatField;
    fldPostDiscAm: TFloatField;
    fldPositionId: TIntegerField;

    // CJS 2015-04-28 - ABSEXCH-16163 - Check All Accounts, SQL improvements
    // Pointer to field object returned from stored procedure
    fldTraderCode: TStringField;

    // -------------------------------------------------------------------------
    // Main update routines
    // -------------------------------------------------------------------------
    // Rebuilds the history for the specified Customer/Supplier
    procedure CheckAccount(AccountCode: string);
    // Updates the history for the specified Nominal Code
    procedure UpdateGLHistory(GLCode: Integer);
    // Sets up the links to the columns returned by the SQL Recordset
    procedure PrepareFields;
    // CJS 2015-04-28 - ABSEXCH-16163 - Check All Accounts, SQL improvements
    procedure PrepareTraderFields;
    // Copies the values returned from the SQL Recordset to the supplied record
    procedure ReadRecord(var InvR: InvRec);
    // Returns the character at the specified position in the string, or the
    // default character if the position is out of range
    function SafeCharFromString(Str: string; Position: Integer; DefaultChr: Char = ' '): Char;

    // -------------------------------------------------------------------------
    // Error handling & logging
    // -------------------------------------------------------------------------
    // Error message display. Displays and logs the supplied error, and sets the
    // abort flag.
    procedure ErrorMessage(const Routine: string; const Msg: string); overload;
    // Alternative error message, replacing the LReport_BError() function with
    // consistent error reporting. This builds an error message and passes it to
    // the overloaded ErrorMessage() function above
    procedure ErrorMessage(const Routine: string; const Msg: string; FileNo: Integer;
                           ErrorCode: Integer); overload;
    // Updates the error log. This is automatically called by the ErrorMessage
    // routines above
    procedure WriteErrorMsg(const Routine: string; const Msg: string);

  public
    destructor Destroy; virtual;
    // -------------------------------------------------------------------------
    // Main processing routines
    // -------------------------------------------------------------------------
    // Initialises the system
    function Start: Boolean;
    // Main processing routine, called by the Thread Controller
    procedure Process; virtual;
    // Tidies up the system
    procedure Finish; virtual;

    // -------------------------------------------------------------------------
    // Properties
    // -------------------------------------------------------------------------

    // Trader Code, when processing a single Trader. If this is empty, it is
    // assumed that all Traders are to be checked.
    property TraderCode: string read FTraderCode write FTraderCode;
  end;
*)

  // CJS 2015-03-31 - ABSEXCH-16163 - Check All Accounts, SQL improvements
  // Removed original CheckAllAccounts function, and replaced it with separate
  // functions for single and all accounts

  // Entry points
  procedure CheckSingleAccount(AOwner: TObject; TraderCode: string; Ask: Boolean = True);
  procedure CheckAllAccounts(AOwner: TObject; Ask: Boolean = True; LockType : TProcessLockType = plCheckAccounts);
  procedure CheckOldestDebt(AOwner: TObject; TraderCode: string; Ask: Boolean = True);

  // User-confirmation routines. If the 'Ask' parameter of the entry points
  // above is True, ConfirmCheckAccount will be called automatically.

  // Alternatively, either of these routines can be called before calling one
  // or other of the entry points (in which case the 'Ask' parameter for them
  // should be False)
  function ConfirmCheckAccount(TraderCode: string = ''): Boolean;

  // This confirmation routine is used by the Trader List, and is never called
  // from the entry points, as the Unallocate process is not available in the
  // SQL version (if this option is selected by the user then the original
  // version of Check Accounts should be used instead).
  // MH 14/08/2015 2015-R1 ABSEXCH-16761: Removed Unallocate question from Check on Trader List
  //function ConfirmCheckAccountAndUnallocate(CustSupp: Char; TraderCode: string; var Unallocate: Boolean): Boolean;

implementation

uses Forms, Controls, SQLUtils, SQLRep_Config, BtrvU2, GlobVar, ExThrd2U, ADOConnect,
  CurrncyU, ComnUnit, ETDateU, JChkUseU, ETMiscU, SysU2,
  CuStkA4U, BtKeys1U, BtSupU1, ETStrU, VarRec2U, ComnU2,
  DateUtils, SQLThreadU, PWarnU, UA_Const, GenWarnU;

const SQL_QUERY = 'EXEC isp_GetAccountTransactions_ResetHistory %s %s';

// =============================================================================
// Check All Accounts support functions
// =============================================================================
function ConfirmCheckAccount(TraderCode: string = ''): Boolean;
const
  SingleMsg = 'Please confirm that you wish to check account ';
  AllMsg = 'Please confirm that you wish to check all accounts';
var
  Msg: string;
begin
  if TraderCode = '' then
    Msg := AllMsg
  else
    Msg := SingleMsg + TraderCode;
  Result := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

// -----------------------------------------------------------------------------

(*** MH 14/08/2015 2015-R1 ABSEXCH-16761: Removed Unallocate question from Check on Trader List
function ConfirmCheckAccountAndUnallocate(CustSupp: Char; TraderCode: string; var Unallocate: Boolean): Boolean;
var
  DlgResult: Word;
begin
  Result := ConfirmCheckAccount(TraderCode);
  if Result then
  begin
    // Only ask for confirmation if the user actually has rights to run the
    // unallocate routine
    if ((CustSupp = 'C') and PChkAllowed_In(uaUnallocateAllCustomerTransactions)) or
       ((CustSupp = 'U') and PChkAllowed_In(uaUnallocateAllConsumerTransactions)) or
       ((CustSupp = 'S') and PChkAllowed_In(uaUnallocateAllSupplierTransactions)) then
    begin
      DlgResult := CustomDlg(Application.MainForm,
                             'Check Account',
                             'Recalculate the Account Balance',
                             'During the re-calculation of the Account balance, ' +
                             'do you wish to unallocate all the transactions?' +
                             #13+#13 +
                             '(Any previously revalued transactions would not be unallocated)',
                             mtConfirmation,
                             [mbYes,mbNo],
                             True);

      // CJS 2015-04-13 - ABSEXCH-16345 - Unallocate All not working
      // Although the buttons have been specified as mbYes and mbNo, the
      // values returned will actually be mrOk and mrCancel.
      Unallocate := (DlgResult = mrOk);
    end
    else
      Unallocate := False;
  end;
end;
***)

// -----------------------------------------------------------------------------

// Internal procedure to actually run the Check All Accounts stored procedure
procedure CheckAccounts(AOwner: TObject; TraderCode: string = ''; LockType : TProcessLockType = plCheckAccounts);
var
  CheckAccounts: ^TCheckAllAccountsThread;
  // CheckAccounts: ^TCheckAllAccounts;
begin
  // Create the thread
  if Create_BackThread then
  begin
    // Create the controlling object
    New(CheckAccounts, Create(AOwner));
    try
      CheckAccounts.TraderCode := TraderCode;
      CheckAccounts.UpdateOldestDebtOnly := False;
      CheckAccounts.ProcessLockType := LockType;
      // Initialise the CheckAccounts instance and add the CheckAccounts object
      // to the queue of threads
      if CheckAccounts.Start and Create_BackThread then
        BackThread.AddTask(CheckAccounts, 'Recalculating account balances')
      else
      begin
        // If we failed to initialise CheckAccounts successfully, close things
        // down tidily
        Set_BackThreadFlip(False);
        Dispose(CheckAccounts, Destroy);
      end;
    except
      Dispose(CheckAccounts, Destroy);
    end;
  end;
end;

//HV 20/05/2016 2016-R2 ABSEXCH-17430:Calculate Oldest Debt when leaving Ledger
// Internal procedure to actually run the All Accounts esp_ReCalculateOldestDebt stored procedure
procedure CheckAccountsOldestDebt(AOwner: TObject; TraderCode: string = '');
var
  CheckAccounts: ^TCheckAllAccountsThread;
begin
  // Create the thread
  if Create_BackThread then
  begin
    // Create the controlling object
    New(CheckAccounts, Create(AOwner));
    try             
      CheckAccounts.TraderCode := TraderCode;
      CheckAccounts.UpdateOldestDebtOnly := True;

      // Initialise the CheckAccounts instance and add the CheckAccounts object
      // to the queue of threads
      if CheckAccounts.Start and Create_BackThread then
          BackThread.AddTask(CheckAccounts, 'Recalculating Oldest Debt')
      else
      begin
        // If we failed to initialise CheckAccounts successfully, close things
        // down tidily       
        Set_BackThreadFlip(False);
        Dispose(CheckAccounts, Destroy);
      end;
    except
      Dispose(CheckAccounts, Destroy);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure CheckSingleAccount(AOwner: TObject; TraderCode: string; Ask: Boolean = True);
var
  Confirmed: Boolean;
begin
  if Ask then
    Confirmed := ConfirmCheckAccount(TraderCode)
  else
    Confirmed := True;

  if Confirmed then
    CheckAccounts(AOwner, TraderCode);
end;

//HV 20/05/2016 2016-R2 ABSEXCH-17430: Recalculate Trader Oldest Debt Correctly
procedure CheckOldestDebt(AOwner: TObject; TraderCode: string; Ask: Boolean = True);
var
  Confirmed: Boolean;
begin
  if Ask then
    Confirmed := ConfirmCheckAccount(TraderCode)
  else
    Confirmed := True;

  if Confirmed then
    CheckAccountsOldestDebt(AOwner, TraderCode);
end;

// -----------------------------------------------------------------------------

procedure CheckAllAccounts(AOwner: TObject; Ask: Boolean = True; LockType : TProcessLockType = plCheckAccounts);
var
  Confirmed: Boolean;
begin
  if Ask then
    Confirmed := ConfirmCheckAccount
  else
    Confirmed := True;

  if Confirmed then
    CheckAccounts(AOwner, '', LockType);

end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCheckAllAccountsThread
// =============================================================================
// Intended for Check All Accounts, Version 2, once the Real48 to Double
// conversion project has been done
destructor TCheckAllAccountsThread.Destroy;
begin
  FreeAndNil(FSQLLogger);
  FreeAndNil(FSQLCaller);
  FProgressFrm := nil;
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccountsThread.ErrorMessage(const Routine, Msg: string);
begin
  // Write the message to the error log
  WriteErrorMsg(Routine, Msg);

  // Display the message to the user, using the thread-safe error dialog
  //VA:23/11/2017:2017-R2:ABSEXCH-19501:Currency Import: Revalue GL: Getting access violation once revaluation process is completed.
  if Assigned(MTExLocal) then
    MTExLocal.LThShowMsg(nil, 0, Msg);

  // If an error occurs, we have to abort. In theory, CheckAllAccounts could
  // skip to the next account and try to carry on, but in practice we have no
  // way of offering this option to the user without rewriting LThShowMsg().
  ThreadRec.ThAbort := True;
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccountsThread.Process;
var
  Query: string;
  ErrStr: String;
begin
  // Prepare the query
  ErrStr := '';
  if FUpdateOldestDebtOnly then
  begin
    Query  := 'EXEC [COMPANY].esp_ReCalculateOldestDebt ';
    ErrStr := ' Oldest Debt';
    if (FTraderCode <> '') then
      Query := Query + QuotedStr(FTraderCode);
  end
  else
  begin
    Query := 'EXEC [COMPANY].esp_RecalculateTraderHistory 0';
    if (FTraderCode <> '') then
      Query := Query + ', ' + QuotedStr(FTraderCode);
  end;

  // Execute the stored procedure
  FSQLCaller.ExecSQL(Query, FCompanyCode);

  if (FSQLCaller.ErrorMsg <> '') then
    ErrorMessage('Checking Accounts' + ErrStr, 'Error checking accounts: ' + FSQLCaller.ErrorMsg);
end;

// -----------------------------------------------------------------------------

function TCheckAllAccountsThread.Start: Boolean;
var
  ConnectionString,
  lPassword: WideString;
begin
  Result := True;
  FSQLLogger := TEntSQLReportLogger.Create('Check All Accounts');
  try
    // Create the SQL Caller instance
    FSQLCaller := TSQLCaller.Create(nil);

    // Determine the company code
    FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    // Set up the ADO Connection for the SQL Caller
    //SQLUtils.GetConnectionString(FCompanyCode, False, ConnectionString);
    SQLUtils.GetConnectionStringWOPass(FCompanyCode, False, ConnectionString, lPassword);
    FSQLCaller.ConnectionString := ConnectionString;
    FSQLCaller.Connection.Password := lPassword;
    // Set the time-outs to 60 minutes
    FSQLCaller.Connection.CommandTimeout := 3600;
    FSQLCaller.Query.CommandTimeout := 3600;
    FSQLCaller.Records.CommandTimeout := 3600;

    // Create the progress bar form
    if (FTraderCode = '') then
    begin
      FProgressFrm := TIndeterminateProgressFrm.Create(Application.MainForm);
      FProgressFrm.Start('Check All Accounts', 'Updating account balances');
    end;

  except
    on E:Exception do
    begin
      // Report the error and return False to indicate the failure
      ErrorMessage('Starting Check Account', 'Initialisation failed: ' + E.Message);
      Result := False;
    end;
  end;

end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccountsThread.WriteErrorMsg(const Routine,
  Msg: string);
begin
  FSQLLogger.LogError('Error in ' + Routine, Msg);
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccountsThread.Finish;
begin
  if (FProgressFrm <> nil) then
    FProgressFrm.Stop;
  inherited;
end;

// -----------------------------------------------------------------------------

(*
// =============================================================================
// TCheckAllAccounts
// =============================================================================

// -----------------------------------------------------------------------------

destructor TCheckAllAccounts.Destroy;
begin
  FreeAndNil(FSQLLogger);
  FreeAndNil(FGLCodeList);
  FreeAndNil(FSQLCaller);
  FreeAndNil(FSQLCallerForStock);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------
// Main processing routines
// -----------------------------------------------------------------------------
function TCheckAllAccounts.Start: Boolean;
var
  ConnectionString: string;
begin
  Result := True;
  FStart := Now;
  FGLCodeList := TGLCodeList.Create;
  FSQLLogger := TEntSQLReportLogger.Create('Check All Accounts');
  try
    // Create the SQL Caller instances
    FSQLCaller := TSQLCaller.Create(nil);
    FSQLCallerForStock := TSQLCaller.Create(nil);
    FSQLCallerForTraders := TSQLCaller.Create(nil);
    // Set the time-outs
    FSQLCaller.Connection.CommandTimeout := 60;
    FSQLCaller.Records.CommandTimeout := 60;
    FSQLCallerForTraders.Connection.CommandTimeout := 1200;
    FSQLCallerForTraders.Records.CommandTimeout := 1200;
    // Set the cursor locations (server-side for better performance)
    FSQLCaller.Connection.CursorLocation := clUseServer;
    FSQLCaller.Connection.CursorLocation := clUseServer;
    // Determine the company code
    FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
    // Set up the ADO Connection for the SQL Callers
    SQLUtils.GetConnectionString(FCompanyCode, False, ConnectionString);
    FSQLCaller.ConnectionString := ConnectionString;
    FSQLCallerForStock.ConnectionString := ConnectionString;
    FSQLCallerForTraders.ConnectionString := ConnectionString;
    // Open the local files (we will need these in addition to the SQL query
    // results)
    if (not Assigned(LPostLocal)) then
      Result := Create_LocalThreadFiles;
    if (Result) then
      MTExLocal := LPostLocal;
  except
    on E:Exception do
    begin
      // Report the error and return False to indicate the failure
      MessageDlg('An error occurred while preparing to check the accounts: ' +
                 #13#10#13#10 + E.Message, mtError,[mbOk], 0);
      Result := False;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// CJS 2015-04-28 - ABSEXCH-16163 - Check All Accounts, SQL improvements
// Rewritten to use SQL stored procedure
procedure TCheckAllAccounts.Process;
const
  Query = 'EXEC [COMPANY].esp_RecalculateTraderHistory 5';
var
  Count : LongInt;
begin
  Count := 0;

  // Initialise the progress labels and progress bar on the Object Thread
  // Controller window
  InitStatusMemo(4);
  ShowStatus(0, 'Recalculating account balances');
  ShowStatus(3, 'Checking balances');

  if FTraderCode <> '' then
  begin
    // Update the sub-process progress label
    ShowStatus(3, 'Updating History Balances');
    // Call the main routine for updating this Account
    CheckAccount(FTraderCode);
  end
  else
  begin
    try
      FSQLCallerForTraders.Select(Query, FCompanyCode);
      FSQLCallerForTraders.Records.DisableControls;
      // Initialise the SQL Caller fields
      PrepareTraderFields;
    except
      on E:Exception do
      begin
        ErrorMessage('Retrieving account balances', E.Message);
        exit;
      end;
    end;

    if (FSQLCallerForTraders.ErrorMsg = '') then
    begin
      FSQLCallerForTraders.Records.First;

      InitProgress(FSQLCallerForTraders.Records.RecordCount);

      while not FSQLCallerForTraders.Records.EOF and not Has_Aborted do
      begin
        // Update the sub-process progress label
        ShowStatus(3, 'Updating History Balances');

        // Call the main routine for updating this Account
        CheckAccount(fldTraderCode.Value);

        FSQLCallerForTraders.Records.Next;

        Inc(Count);
        UpdateProgress(Count);
      end;

    end
    else
      ErrorMessage('Check All Accounts failed', FSQLCallerForTraders.ErrorMsg);
  end;

end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.Finish;
begin
  inherited;
  FFinish := Now;
  // ShowMessage('Time: ' + FormatFloat('#.00', MillisecondsBetween(FStart, FFinish) / 1000.0));
end;

// -----------------------------------------------------------------------------
// Main update routines
// -----------------------------------------------------------------------------
procedure TCheckAllAccounts.CheckAccount(AccountCode: string);
// Copied from PostingU.pas, TCheckCust.Check_Cust(), and amended
const
  UPDATE_QUERY =
    'UPDATE [COMPANY].[DOCUMENT] ' +
    'SET thUntilDate = ''%s'' ' +
    'WHERE PositionId = %d';
var
  Query: AnsiString;
  FuncRes: LongInt;
  Balance: Double;
  Cost: Double;
  Net: Double;
  Mode: Integer;
  RecAddr: LongInt;
  OldestDueDate: LongDate;
  UOR: Byte;
  KeyPath: Integer;
  Key: Str255;
  Locked: Boolean;
begin
  // Initialise class members
  FAccountCode := AccountCode;
  FGLCodeList.Clear;

  { CJS 2013-01-23 - ABSEXCH-13877 - Check All Accounts oldest due date incorrect }
  OldestDueDate := ETDateU.Today;

  // Call the stored procedure to clear down the History and retrieve all the
  // transactions for this account.
  Query := '[COMPANY].isp_GetAccountTransactions_ResetHistory ' +
           '@iv_strAccountCode = ' + QuotedStr(AccountCode) + ', ' +
	         '@iv_intExchStartYear = ' + IntToStr(Syss.AuditYr);
  FSQLLogger.StartQuery(Query);
  FSQLCaller.Select(Query, FCompanyCode);
  FSQLLogger.FinishQuery;
  FSQLCaller.Records.DisableControls;
  with MTExLocal^ do
  try
    if (FSQLCaller.ErrorMsg = '') then
    begin
      FSQLLogger.QueryRowCount(FSQLCaller.Records.RecordCount);
      FSQLCaller.Records.First;
      // Initialise the SQL Caller fields
      try
        PrepareFields;
      except
        on E:Exception do
          ErrorMessage('Preparing SQL columns for Transactions', E.Message);
      end;

      // Locate the Customer/Supplier record
      Key := FullCustCode(AccountCode);
      KeyPath := 0;
      { CJS 2013-01-23 - ABSEXCH-13935 - CheckAllAccounts consumes memory.
        Replaced B_MultLock with B_SingLock. The Emulator appears not to release
        memory if a Multi-lock is used (possibly only with B_GetEq).
        (Duplicated from ABSEXCH-12695 in v6.10.1) }
      if not LGetMultiRec(B_GetEq, B_SingLock, Key, KeyPath, CustF, True, Locked) then
      begin
        // Unable to lock Customer/Supplier record. LGetMultiRec will already
        // have displayed a dialog allowing the user to retry, so if we get
        // here, the user is aborting.
        ThreadRec.ThAbort := True;
        exit;
      end;

      // Update the progress display on the thread-controller window
      ShowStatus(2, dbFormatName(LCust.CustCode, LCust.Company));

      // Work through all the Transactions against the current Customer/Supplier
      while not FSQLCaller.Records.EOF and not Has_Aborted do
      begin
        // Read the values from the SQL recordset into the Transaction Header
        ReadRecord(LInv);

        if not (LInv.InvDocHed in PSOPSET) then
        begin

          // Calculate the values for the History balances
          Balance := ConvCurrITotal(LInv, False, True, True)
                     * DocCnst[LInv.InvDocHed]
                     * DocNotCnst;

          Cost := ConvCurrICost(LInv, False, True)
                  * DocCnst[LInv.InvDocHed]
                  * DocNotCnst;

          Net := ConvCurrINet(LInv, False, True)
                 * DocCnst[LInv.InvDocHed]
                 * DocNotCnst;

          // Mode := (0+(2*Ord((RunNo=0))))
          if (LInv.RunNo = 0) then
            Mode := 2
          else
            Mode := 0;

          // CJS 2015-05-11 - ABSEXCH-16398 - Single check on Trader should respect
          //                  the 'Update Trader Balance on Posting' flag
          // Update the trader balance if this is a posted transaction, or if
          // the 'update trader balance on posting' flag is False (i.e. Trader
          // Balances should be updated immediately rather than waiting until
          // the transactions are posted).
          if ((LInv.RunNo > 0) or (not Syss.UpBalOnPost)) then
          begin
              // Update the History balances
              LUpdateBal(LInv, Balance, Cost, Net, False, Mode);

              // Record the G/L Code so that we can update the affected G/L records at
              // the end of the routine
              FGLCodeList.AddCode(LInv.CtrlNom);
          end;

          { CJS 2013-01-23 - ABSEXCH-13564 - Ledger filter after Check All Accounts }
          // If an Allocation Status is set, but the UntilDate is empty, replace
          // the UntilDate with CHR(255) -- this is a data-fix for a error in
          // the first SQL version of this routine.
          if ((LInv.InvDocHed in DirectSet) and (BaseTotalOS(LInv)<>0)) or
             ((Linv.AllocStat = #0) and (LInv.UntilDate = NDXWeight)) then
          begin
            if LInv.UntilDate = NDXWeight then
            begin
              LInv.UntilDate := '';
              LStatus := FSQLCaller.ExecSQL(
                                    Format(
                                      UPDATE_QUERY,
                                      [
                                          LInv.UntilDate,
                                          fldPositionId.Value
                                      ]
                                    ),
                                    FCompanyCode);
              if (LStatus <> 0) then
              begin
                // Report the error and abort, exiting this procedure immediately
                ErrorMessage('Check Account for ' + FAccountCode,
                             'Failed to save Transaction Header' +
                             ' - ' + SQLUtils.LastSQLError,
                             InvF, LStatus);
                exit;
              end;
            end;
          end
          else if (LInv.AllocStat <> #0) and (LInv.UntilDate = '') then
          begin
            LInv.UntilDate := NDXWeight; // #255
            LStatus := FSQLCaller.ExecSQL(
                                  Format(
                                    UPDATE_QUERY,
                                    [
                                        LInv.UntilDate,
                                        fldPositionId.Value
                                    ]
                                  ),
                                  FCompanyCode);
            if (LStatus <> 0) then
            begin
              // Report the error and abort, exiting this procedure immediately
              ErrorMessage('Check Account for ' + FAccountCode,
                           'Failed to save Transaction Header' +
                           ' - ' + SQLUtils.LastSQLError,
                           InvF, LStatus);
              exit;
            end;
          end;
          // Keep track of the date of the oldest due Transaction
          if ((LInv.DueDate <> '') and
              (LInv.DueDate < OldestDueDate) and
              (BaseTotalOs(LInv) * DocCnst[LInv.InvDocHed] * DocNotCnst > 0))
             and
             (LInv.InvDocHed In SalesSplit+PurchSplit-RecieptSet-CreditSet) then
            OldestDueDate := LInv.DueDate;

        end;

        // For Orders, Delivery Notes, and unposted Transactions, post the
        // outstanding balance to History
        {$IFDEF SOP}
        if (LInv.InvDocHed In PSOPSet) and
           ((LInv.RunNo = OrdUSRunNo) or (LInv.RunNo = OrdUPRunNo)) then
        begin
          UOR := fxUseORate(UseCODayRate, True, LInv.CXRate,
                            LInv.UseORate, LInv.Currency,
                            0);

          //PR: 20/06/2012 Changed to use correct o/s depending on system setup flag ABSEXCH-11528
          LUpdateOrdBal(LInv, LTransOSValue(LInv) *
                       DocCnst[LInv.InvDocHed]*DocNotCnst,
                       0,0,
                       BOff,0);

        end;
        {$ENDIF}

        // For Job Costing Transactions or unposted Transactions, post the
        // outstanding balance to History
        {$IFDEF JAP}
        If (LInv.InvDocHed In JAPOrdSplit) and ((LInv.RunNo=JSTUPRunNo) or (LInv.RunNo=JCTUPRunNo))  and ((LInv.InvDocHed<>JST) or EmptyKey(LInv.DeliverRef,DocKeyLen))  then  {*EN560 some way to indicate no longer o/s needed *}
        Begin
          UOR := fxUseORate(UseCODayRate, True, LInv.CXRate, LInv.UseORate, LInv.Currency, 0);
          LUpdateOrdBal(LInv,(Round_Up(Conv_TCurr(LInv.TotalCost-LInv.TotalOrdered,XRate(LInv.CXRate,UseCoDayRate,LInv.Currency),LInv.Currency,UOR,BOff),2)*
                       DocCnst[LInv.InvDocHed]*DocNotCnst),
                       0, 0, False, 0);
        end;
        {$ENDIF}
        FSQLCaller.Records.Next;
      end;
    end
    else
    begin
      // Report the error and abort, exiting this procedure immediately
      ErrorMessage('Check Account for ' + FAccountCode,
                   FSQLCaller.ErrorMsg);
      exit;
    end;

    // Calculate and store the maximum weeks overdue for this Customer/Supplier,
    // based on the oldest due date
    LCust.CreditStatus := CalcWksODue(OldestDueDate);
    LStatus := LPut_Rec(CustF, CustCodeK);
    // Check for errors
    if (LStatus <> 0) then
    begin
      // Report the error and abort, exiting this procedure immediately
      ErrorMessage('Check Account for ' + FAccountCode,
                   'Failed to save Customer/Supplier', CustF, LStatus);
      exit;
    end;
    // CJS 2014-07-21 - ABSEXCH-15168 - Check All Accounts hangs under SQL
    // Unlock is no longer required now that a single-lock is used, and it appears
    // to cause problems under non-SPOP compiles
    // LStatus := LUnLockMLock(CustF);

    // Recalculate and post the History balances for all the G/L Codes that were
    // found
    FGLCodeList.ForEach(UpdateGLHistory);

  finally
    if (FSQLCaller.ErrorMsg = '') then
    begin
      // Close the record set
      FSQLCaller.Records.Close;
    end;
    FSQLCaller.Records.EnableControls;
  end;
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.UpdateGLHistory(GLCode: Integer);
// Copied from PostingU.pas, PrimeMDCHist(), and amended
var
  Code: Str20;
begin
  Code := FullNCode(FAccountCode) + FullNomKey(GLCode);
  MTExLocal.Prime_To_CYTDHist('U', Code, 0, Syss.AuditYr, YTD);
  MTExLocal.Prime_To_CYTDHist('V', Code, 0, Syss.AuditYr, YTD);
  MTExLocal.Prime_To_CYTDHist('W', Code, 0, Syss.AuditYr, YTD);
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.PrepareFields;
begin
  fldCustSupp          := FSQLCaller.Records.FieldByName('thCustSupp') as TStringField;
  fldAcCode            := FSQLCaller.Records.FieldByName('thAcCode') as TStringField;
  fldNomAuto           := FSQLCaller.Records.FieldByName('thNomAuto') as TBooleanField;
  fldFolioNum          := FSQLCaller.Records.FieldByName('thFolioNum') as TIntegerField;
  fldRunNo             := FSQLCaller.Records.FieldByName('thRunNo') as TIntegerField;
  fldDocType           := FSQLCaller.Records.FieldByName('thDocType') as TIntegerField;
  fldControlGL         := FSQLCaller.Records.FieldByName('thControlGL') as TIntegerField;
  fldYear              := FSQLCaller.Records.FieldByName('thYear') as TIntegerField;
  fldPeriod            := FSQLCaller.Records.FieldByName('thPeriod') as TIntegerField;
  fldCurrency          := FSQLCaller.Records.FieldByName('thCurrency') as TIntegerField;
  fldRemitNo           := FSQLCaller.Records.FieldByName('thRemitNo') as TStringField;
  fldSettledVAT        := FSQLCaller.Records.FieldByName('thSettledVAT') as TFloatField;
  fldVATPostDate       := FSQLCaller.Records.FieldByName('thVATPostDate') as TStringField;
  fldUntilDate         := FSQLCaller.Records.FieldByName('thUntilDate') as TStringField;
  fldDueDate           := FSQLCaller.Records.FieldByName('thDueDate') as TStringField;
  fldCurrSettled       := FSQLCaller.Records.FieldByName('thCurrSettled') as TFloatField;
  fldOurRef            := FSQLCaller.Records.FieldByName('thOurRef') as TStringField;
  fldCompanyRate       := FSQLCaller.Records.FieldByName('thCompanyRate') as TFloatField;
  fldDailyRate         := FSQLCaller.Records.FieldByName('thDailyRate') as TFloatField;
  fldOutstanding       := FSQLCaller.Records.FieldByName('thOutstanding') as TStringField;
  fldTotalOrderOS      := FSQLCaller.Records.FieldByName('thTotalOrderOS') as TFloatField;
  fldTotalCost         := FSQLCaller.Records.FieldByName('thTotalCost') as TFloatField;
  fldTotalOrdered      := FSQLCaller.Records.FieldByName('thTotalOrdered') as TFloatField;
  fldDeliveryNoteRef   := FSQLCaller.Records.FieldByName('thDeliveryNoteRef') as TStringField;
  fldNetValue          := FSQLCaller.Records.FieldByName('thNetValue') as TFloatField;
  fldTotalVAT          := FSQLCaller.Records.FieldByName('thTotalVAT') as TFloatField;
  fldTotalLineDiscount := FSQLCaller.Records.FieldByName('thTotalLineDiscount') as TFloatField;
  fldVariance          := FSQLCaller.Records.FieldByName('thVariance') as TFloatField;
  fldRevalueAdj        := FSQLCaller.Records.FieldByName('thRevalueAdj') as TFloatField;
  fldSettleDiscAmount  := FSQLCaller.Records.FieldByName('thSettleDiscAmount') as TFloatField;
  fldSettleDiscTaken   := FSQLCaller.Records.FieldByName('thSettleDiscTaken') as TBooleanField;
  fldAmountSettled     := FSQLCaller.Records.FieldByName('thAmountSettled') as TFloatField;
  fldPostDiscAm        := FSQLCaller.Records.FieldByName('PostDiscAm') as TFloatField;
  fldPositionId        := FSQLCaller.Records.FieldByName('PositionId') as TIntegerField;
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.PrepareTraderFields;
begin
  if FSQLCallerForTraders.Records.FieldList.Count = 0 then
    raise Exception.Create('No columns retrieved from SQL query');
  fldTraderCode := FSQLCallerForTraders.Records.FieldByName('TraderCode') as TStringField;
end;

// -----------------------------------------------------------------------------

function TCheckAllAccounts.SafeCharFromString(Str: string; Position: Integer; DefaultChr: Char = ' '): Char;
begin
  if (Position > Length(Str)) then
    Result := DefaultChr
  else
    Result := Str[Position];
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.ReadRecord(var InvR: InvRec);
begin
  Blank(InvR, SizeOf(InvR));
  InvR.CustSupp      := SafeCharFromString(fldCustSupp.Value, 1);
  InvR.CustCode      := fldAcCode.Value;
  InvR.NomAuto       := fldNomAuto.Value;
  InvR.FolioNum      := fldFolioNum.Value;
  InvR.RunNo         := fldRunNo.Value;
  InvR.InvDocHed     := DocTypes(fldDocType.Value);
  InvR.CtrlNom       := fldControlGL.Value;
  InvR.AcYr          := fldYear.Value;
  InvR.AcPr          := fldPeriod.Value;
  InvR.Currency      := fldCurrency.Value;
  InvR.RemitNo       := fldRemitNo.Value;
  InvR.SettledVAT    := fldSettledVAT.Value;
  InvR.VATPostDate   := fldVATPostDate.Value;
  InvR.UntilDate     := fldUntilDate.Value;
  InvR.CurrSettled   := fldCurrSettled.Value;
  InvR.OurRef        := fldOurRef.Value;
  InvR.CXrate[False] := fldCompanyRate.Value;
  InvR.CXrate[True]  := fldDailyRate.Value;
  { CJS 2013-01-23 - ASBEXCH-13564 - Ledger filter after Check All Accounts }
  InvR.AllocStat     := SafeCharFromString(fldOutstanding.Value, 1, #0);
  InvR.UntilDate     := fldUntilDate.Value;
  InvR.DueDate       := fldDueDate.Value;
  InvR.TotOrdOS      := fldTotalOrderOS.Value;
  InvR.TotalCost     := fldTotalCost.Value;
  InvR.TotalOrdered  := fldTotalOrdered.Value;
  InvR.DeliverRef    := fldDeliveryNoteRef.Value;
  InvR.InvNetVal     := fldNetValue.Value;
  InvR.InvVat        := fldTotalVAT.Value;
  InvR.DiscAmount    := fldTotalLineDiscount.Value;
  InvR.Variance      := fldVariance.Value;
  InvR.ReValueAdj    := fldRevalueAdj.Value;
  InvR.DiscSetAm     := fldSettleDiscAmount.Value;
  InvR.DiscTaken     := fldSettleDiscTaken.Value;
  InvR.Settled       := fldAmountSettled.Value;
  InvR.PostDiscAm    := fldPostDiscAm.Value;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Error handling & logging
// -----------------------------------------------------------------------------
procedure TCheckAllAccounts.ErrorMessage(const Routine: string; const Msg: string);
begin
  // Write the message to the error log
  WriteErrorMsg(Routine, Msg);
  // Display the message to the user, using the thread-safe error dialog
  MTExLocal.LThShowMsg(nil, 0, Msg);
  // If an error occurs, we have to abort. In theory, CheckAllAccounts could
  // skip to the next account and try to carry on, but in practice we have no
  // way of offering this option to the user without rewriting LThShowMsg().
  ThreadRec.ThAbort := True;
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.ErrorMessage(const Routine: string; const Msg: string;
                                         FileNo, ErrorCode: Integer);
var
  FileName: string;
begin
  // Append the filename and error code to the supplied error message
  FileName := Filenames[FileNo];
  ErrorMessage(Routine, Msg + ' - File: ' + Filename + ', error: ' + IntToStr(ErrorCode));
end;

// -----------------------------------------------------------------------------

procedure TCheckAllAccounts.WriteErrorMsg(const Routine: string; const Msg: string);
begin
  FSQLLogger.LogError('Error in ' + Routine, Msg);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TGLCodeList
// =============================================================================

procedure TGLCodeList.AddCode(Code: Integer);
begin
  if not Exists(Code) then
  begin
    inc(FCount);
    if (FCount >= Length(FCodes)) then
    begin
      SetLength(FCodes, Length(FCodes) + 10);
    end;
    FCodes[FCount - 1] := Code;
  end;
end;

// -----------------------------------------------------------------------------

procedure TGLCodeList.Clear;
begin
  SetLength(FCodes, 0);
  FCount := 0;
end;

// -----------------------------------------------------------------------------

function TGLCodeList.Exists(Code: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    if FCodes[i] = Code then
    begin
      Result := True;
      break;
    end;
end;

// -----------------------------------------------------------------------------

procedure TGLCodeList.ForEach(ForEachProc: TForEachGLProc);
var
  i: Integer;
begin
  for i := 0 to FCount - 1 do
    ForEachProc(FCodes[i]);
end;

// -----------------------------------------------------------------------------

function TGLCodeList.GetCode(Index: Integer): Integer;
begin
  if (Index >= 0) and (Index < FCount) then
    Result := FCodes[Index]
  else
    raise ERangeError.Create('Index out of range for G/L Code List');
end;

// -----------------------------------------------------------------------------

function TGLCodeList.GetCount: Integer;
begin
  Result := FCount;
end;

// -----------------------------------------------------------------------------
*)

end.

