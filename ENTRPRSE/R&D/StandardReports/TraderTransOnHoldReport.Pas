unit TraderTransOnHoldReport;

{******************************************************************************}
{                                                                              }
{                   ====----> E X C H E Q U E R <----===                       }
{                                                                              }
{                            Created: 16/03/2017                               }
{                                                                              }
{            Reports\Credit Control\Customer Transactions on Hold.             }
{                                                                              }
{                        Copyright (C) 1990 by EAL & RGS                       }
{                        Credit given to Hitesh Vaghani                        }
{ History :                                                                    }
{ 1.Lists all Sales/Purchase Type transactions that appear on the Sales 'Main' }
{   and 'History' daybooks that have a status of 'On Hold', 'Credit Hold' and  }
{   'Until Allocated'                                                          }
{******************************************************************************}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses DB, Graphics, SysUtils, Math, StrUtils, GlobVar, VarConst, SQLCallerU,
     SQLRep_BaseReport, ReportU, BTSupU3, EntLoggerClass, Btrvu2;

type
  TTraderTransOnHoldReportType = (thrCustomer=0, thrSupplier=1);

  //Base class consisting common functionality for both pervasive as well as SQL
  TTraderTransactionsOnHoldReport = object(TGenReport)
	  procedure RepSetTabs; virtual;
    procedure RepPrintPageHeader; virtual;
    procedure PrintEndPage; virtual;
  private
    FOSAmount,
    FNetAmount: Double;
    FPostedStatus,
    FHoldStatus: ShortString;
    FCustSupp: Char;
	  function GetReportInput: Boolean; virtual;
    procedure CalcAmountFieldValue(const AInv: InvRec);
    procedure PrintTransactionDetails(const AInv: InvRec);
  public
  	ReportType: TTraderTransOnHoldReportType;
    ReportParameters: DocRepParam;
	  constructor Create(AOwner: TObject);
  end; //TTraderTransactionsOnHoldReport

  //Pervasive descendant class
  TTraderTransactionsOnHoldReport_Pervasive = object(TTraderTransactionsOnHoldReport)
  private
    function IncludeRecord: Boolean; virtual;
    procedure RepPrint(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TObject);
  end; //TTraderTransactionsOnHoldReport_Pervasive

  //SQL descendant class
  TTraderTransactionsOnHoldReport_MSSQL = object(TTraderTransactionsOnHoldReport)
  private
	  FoReportLogger: TEntSQLReportLogger;
    FCompanyCode: AnsiString;
    FMaxProgress: LongInt;
    procedure WriteSQLErrorMsg(const ASQLErrorMsg: String);
    function SQLLoggingArea: String; virtual;
    procedure RepPrint(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; virtual;
    procedure Process; virtual;
  end; //TTraderTransactionsOnHoldReport_MSSQL

  //Main entry point to be called print report
  procedure TraderTransactionOnHold_Report(const AOwner: TObject;
                                           const AReportType: TTraderTransOnHoldReportType;
                                           const AReportParameters: DocRepPtr);


implementation

uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
     ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, DocSupU1, SQLRep_Config, ComnUnit,
     VarRec2U, SysU1, ExWrap1U, RPFiler, SQLTransactions;

//------------------------------------------------------------------------------

procedure MsSqlRep_TraderTransactionOnHold(const AOwner: TObject;
                                           const AReportType: TTraderTransOnHoldReportType;
                                           const AReportParameters: DocRepPtr);
var
  lSQLRepObj: ^TTraderTransactionsOnHoldReport_MSSQL;
begin
  // Ensure Thread Controller is up and running
  if Create_BackThread then
  begin
    // Create report object

    New(lSQLRepObj, Create(AOwner));
    try
      // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lSQLRepObj^.UsingEmulatorFiles := False;

      // Initialise report properties
      lSQLRepObj^.ReportType := AReportType;
      if Assigned(AReportParameters) then
        lSQLRepObj^.ReportParameters := AReportParameters^;

      // Call Start to display the Print To dialog and then cache the details for subsequent reports
      if lSQLRepObj^.Start then
        // Initialise the report and add it into the Thread Controller
        BackThread.AddTask(lSQLRepObj, lSQLRepObj^.ThTitle)
      else
      begin
        Set_BackThreadFlip(BOff);
        Dispose(lSQLRepObj, Destroy);
      end;
    except
      Dispose(lSQLRepObj, Destroy); // Stop printing if there was an exception
    end; // Try..Except
  end; // If Create_BackThread
end;

//------------------------------------------------------------------------------

procedure PervasiveRep_TraderTransactionOnHold(const AOwner: TObject;
                                               const AReportType: TTraderTransOnHoldReportType;
                                               const AReportParameters: DocRepPtr);
var
  lPervasiveRepObj: ^TTraderTransactionsOnHoldReport_Pervasive;
begin
  if Create_BackThread then
  begin

    New(lPervasiveRepObj, Create(AOwner));
    try
      // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lPervasiveRepObj^.UsingEmulatorFiles := False;
      // Initialise report properties
      lPervasiveRepObj^.ReportType := AReportType;
      if Assigned(AReportParameters) then
        lPervasiveRepObj^.ReportParameters := AReportParameters^;

      // Call Start to display the Print To dialog and then cache the details for subsequent reports
      if lPervasiveRepObj^.Start then
        // Initialise the report and add it into the Thread Controller
        BackThread.AddTask(lPervasiveRepObj, lPervasiveRepObj^.ThTitle)
      else
      begin
        Set_BackThreadFlip(BOff);
        Dispose(lPervasiveRepObj, Destroy);
      end;
    except
      Dispose(lPervasiveRepObj, Destroy);
    end; {try..}
  end;
end;

//------------------------------------------------------------------------------

procedure TraderTransactionOnHold_Report(const AOwner: TObject;
                                         const AReportType: TTraderTransOnHoldReportType;
                                         const AReportParameters: DocRepPtr);
begin
  if SQLUtils.UsingSQL then
    MsSqlRep_TraderTransactionOnHold(AOwner, AReportType, AReportParameters)
  else
    PervasiveRep_TraderTransactionOnHold(AOwner, AReportType, AReportParameters);
end;

//------------------------------------------------------------------------------
{ TTraderTransactionsOnHoldReport }
//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport.CalcAmountFieldValue(const AInv: InvRec);
begin
  // Set Posted Status based on RunNo
  if AInv.RunNo > 0 then
    FPostedStatus := 'Y'
  else
    FPostedStatus := 'N';

  //Set Hold Status
  FHoldStatus := DisplayHold(AInv.HoldFlg);
  //Set Net Amount
  FNetAmount := ConvCurrItotal(AInv,BOff,BOn,BOn)*DocCnst[AInv.InvDocHed]*DocNotCnst;
  //Set OS Amount
  FOSAmount := BaseTotalOs(AInv);
end;

//------------------------------------------------------------------------------

constructor TTraderTransactionsOnHoldReport.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FOSAmount := 0.00;
  FNetAmount := 0.00;
end;

//------------------------------------------------------------------------------

function TTraderTransactionsOnHoldReport.GetReportInput: Boolean;
begin
  with ReportParameters do
  begin
    case ReportType of
      thrCustomer : begin
                      thTitle := 'Customer Transactions on Hold';
                      FCustSupp := 'C'
                    end;
      thrSupplier : begin
                      thTitle := 'Supplier Transactions on Hold';
                      FCustSupp := 'S';
                    end;
    else
      thTitle := 'Unknown Report';
    end;
    RepTitle := thTitle;
    {$IFDEF MC_On}
      RepTitle := CurrDesc(0) + RepTitle; // GBP-Consolidated Default
    {$ENDIF}
    PageTitle := RepTitle;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport.PrintEndPage;
begin
  inherited PrintEndPage;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport.PrintTransactionDetails(const AInv: InvRec);
begin
  with AInv do
  begin
    ThrowNewPage(5);
    CalcAmountFieldValue(AInv);
    // Put drill-down box across entire line for Transaction Header
    SendRepDrillDown(1, TotTabs, 1, OurRef, InvF, InvOurRefK, 0);

    SendLine(#9 + OurRef +
             #9 + POutDateB(TransDate) +
             #9 + YourRef +
             #9 + FormatFloat(GenRealMask, FNetAmount) +
             #9 + FormatFloat(GenRealMask, Settled) +
             #9 + FormatFloat(GenRealMask, FOSAmount) +
             #9 + FPostedStatus +
             #9 + FHoldStatus);
    // Update the line count and progress - ignore total lines
    ICount := ICount + 1;
    if Assigned(ThreadRec) then
      UpDateProgress(2 + ICount);
  end;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport.RepPrintPageHeader;
begin
  with RepFiler1 do
  begin
    DefFont(0,[fsBold]);
    SendLine(ConCat(#9, 'Our Ref',
                    #9, 'Date',
                    #9, 'Your Ref',
                    #9, 'Amount',
                    #9, 'Settled Value',
                    #9, 'Outstanding Value',
                    #9, 'Posted',
                    #9, 'Hold Status'));
    DefFont(0,[]);
  end;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport.RepSetTabs;
begin
 with RepFiler1 do
  begin
    ClearTabs;
    SetTab(MarginLeft, pjLeft, 19, 3, 0, 0); // Our Ref
    SetTab(NA, pjCenter, 18, 3, 0, 0);       // Trans Date
    SetTab(NA, pjLeft, 45, 4, 0, 0);         // Your Ref
    SetTab(NA, pjRight, 30, 4, 0, 0);        // Amount
    SetTab(NA, pjRight, 30, 4, 0, 0);        // Settled Value
    SetTab(NA, pjRight, 30, 4, 0, 0);        // Outstanding Value
    SetTab(NA, pjCenter, 12, 4, 0, 0);       // Posted Status
    SetTab(NA, pjLeft, 25, 4, 0, 0);         // Hold Staus
  end;
  SetTabCount;
end;

//------------------------------------------------------------------------------
{ TTraderTransactionsOnHoldReport_MSSQL }
//------------------------------------------------------------------------------

constructor TTraderTransactionsOnHoldReport_MSSQL.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  bIsSQLReport := True;
  FoReportLogger := TEntSQLReportLogger.Create(SQLLoggingArea);
  FCompanyCode := GetCompanyCode(SetDrive);
end;

//------------------------------------------------------------------------------

destructor TTraderTransactionsOnHoldReport_MSSQL.Destroy;
begin
  FreeAndNIL(FoReportLogger);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport_MSSQL.Process;
begin
  UpdateProgress(1);
  inherited Process;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport_MSSQL.RepPrint(Sender: TObject);
var
  lInvHeaders: TSQLSelectTransactions;
begin
  lInvHeaders := TSQLSelectTransactions.Create;
  try
    lInvHeaders.CompanyCode := FCompanyCode;
    lInvHeaders.FromClause  := 'FROM [COMPANY].DOCUMENT';
    lInvHeaders.WhereClause := 'WHERE thCustSupp = '+ QuotedStr(FCustSupp) + ' ' +
                               'AND thHoldFlag IN (1, 2, 33, 34)';    //Query Hold = 1 and Until Allocated = 2
                                                                      //Query with Notes=33 and Until Allocated with Notes =34

    lInvHeaders.OrderByClause := 'ORDER BY thOurRef';

    ShowStatus(2, 'Retrieving Data, Please Wait...');
    ShowStatus(3, 'This can take several minutes');
    lInvHeaders.OpenFile;
    FoReportLogger.StartQuery(lInvHeaders.SQLCaller.Records.CommandText);
    FoReportLogger.FinishQuery;
    ShowStatus(2,'Processing Report.');
    ShowStatus(3,'');

    if (lInvHeaders.SQLCaller.ErrorMsg = '') and (lInvHeaders.Count > 0) then
    begin
      // Set MaxProgress Value of Progress Bar range
      FMaxProgress := lInvHeaders.Count + 2;
      // Initialise the Progress Bar range
      InitProgress(FMaxProgress);
      if Assigned(ThreadRec) then
        RepAbort := ThreadRec^.THAbort;

      lInvHeaders.SQLCaller.Records.DisableControls;
      try
        lInvHeaders.First;
        while (not lInvHeaders.Eof) and ChkRepAbort do
        begin
          // Pass to common ancestor for printing transaction line
          PrintTransactionDetails(lInvHeaders.ReadRecord);
          if Assigned(ThreadRec) then
            RepAbort := ThreadRec^.THAbort;
          lInvHeaders.Next;
        end;
      finally
        lInvHeaders.SQLCaller.Records.EnableControls;
      end;
    end
    else if (lInvHeaders.SQLCaller.ErrorMsg <> '') then
      WriteSQLErrorMsg(lInvHeaders.SQLCaller.ErrorMsg);
  finally
    lInvHeaders.CloseFile;
    FreeAndNil(lInvHeaders);
  end;

  // Print footer
  PrintEndPage;
  FoReportLogger.FinishReport;
end;

//------------------------------------------------------------------------------

function TTraderTransactionsOnHoldReport_MSSQL.SQLLoggingArea: String;
begin
  Result := 'TraderTransactionOnHoldReport';
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport_MSSQL.WriteSQLErrorMsg(
  const ASQLErrorMsg: String);
begin
  DefFont (0,[fsBold]);
  Self.CRLF;
  Self.PrintLeft('Error: ' + ASQLErrorMsg, RepFiler1.MarginLeft);
  Self.CRLF;
  Self.CRLF;
  FoReportLogger.LogError('Query Error', ASQLErrorMsg);
end;

//------------------------------------------------------------------------------
{ TTraderTransactionsOnHoldReport_Pervasive }
//------------------------------------------------------------------------------

constructor TTraderTransactionsOnHoldReport_Pervasive.Create(
  AOwner: TObject);
begin
  inherited Create(AOwner);
  RepKey := '';
end;

//------------------------------------------------------------------------------

function TTraderTransactionsOnHoldReport_Pervasive.IncludeRecord: Boolean;
begin
  with MTExLocal^ do
  begin
    case ReportType of
        thrCustomer,
        thrSupplier : Result := (LInv.CustSupp = FCustSupp) and (LInv.HoldFlg In [1, 2, 33, 34]); 
                                                                //Query Hold = 1 and Until Allocated = 2
                                                                //Query with Notes=33 and Until Allocated with Notes =34
      else
        Result := BOn;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TTraderTransactionsOnHoldReport_Pervasive.RepPrint(Sender: TObject);
begin
  // Run through the transactions in the Documents
  ShowStatus(2,'Processing Report.');

  with MTExLocal^, RepFiler1 do
  begin
    LStatus := LFind_Rec(B_GetFirst, InvF, InvOurRefK, RepKey);

    if Assigned(ThreadRec) then
      RepAbort := ThreadRec^.THAbort;

    while (LStatus = 0) and (ChkRepAbort) do
    begin
      if IncludeRecord then
        PrintTransactionDetails(LInv);

      LStatus := LFind_Rec(B_GetNext, InvF, InvOurRefK, RepKey);
      if Assigned(ThreadRec) then
        RepAbort:=ThreadRec^.THAbort;
    end; // While (LStatus = 0) do
  end;
  // Print footer
  PrintEndPage;
end;

//------------------------------------------------------------------------------

end.
