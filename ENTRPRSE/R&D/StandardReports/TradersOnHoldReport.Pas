unit TradersOnHoldReport;

{******************************************************************************}
{                                                                              }
{                   ====----> E X C H E Q U E R <----===                       }
{                                                                              }
{                            Created: 23/03/2017                               }
{                                                                              }
{       Reports -> Misc Reports\Customer Based Reports\Traders on Hold         }
{                                                                              }
{                        Copyright (C) 1990 by EAL & RGS                       }
{                        Credit given to Hitesh Vaghani                        }
{ History :                                                                    }
{ 1.Lists all Customer/Consumer trader records that have a status of 'On Hold' }
{******************************************************************************}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses DB, Graphics, SysUtils, Math, StrUtils, GlobVar, VarConst, SQLCallerU,
     SQLRep_BaseReport, ReportU, BTSupU3, EntLoggerClass;

type

  //Base class consisting common functionality for both pervasive as well as SQL
  TTradersOnHoldReport = object(TGenReport)
    procedure RepSetTabs; virtual;
    procedure RepPrintPageHeader; virtual;
  private
	  function GetReportInput: Boolean; virtual;
    procedure PrintTraderDetails(const ATraderRec: CustRec);
  public
    ReportParameters: DocRepParam;
    constructor Create(AOwner: TObject);
  end; //TTradersOnHoldReport

  //Pervasive descendant class
  TTradersOnHoldReport_Pervasive = object(TTradersOnHoldReport)
  private
    function IncludeRecord: Boolean; virtual;
    procedure RepPrint(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TObject);
  end; //TTradersOnHoldReport_Pervasive

  //SQL descendant class
  TTradersOnHoldReport_MSSQL = object(TTradersOnHoldReport)
  private
    FCompanyCode: AnsiString;
    FMaxProgress: LongInt;
    FoReportLogger : TEntSQLReportLogger;
    function SQLLoggingArea: String; virtual;
    procedure WriteSQLErrorMsg(const ASQLErrorMsg: String);
    procedure RepPrint(Sender: TObject); virtual;
  public
    // Cached SQL Emulator info to reduce overhead
    constructor Create(AOwner:  TObject);
    destructor Destroy; virtual;
    procedure Process; virtual;
  end; // TTradersOnHoldReport_MSSQL

  //Main entry point to be called print report
  procedure TradersOnHold_Report(const AOwner: TObject;
                                 const AReportParameters: DocRepPtr);

implementation

uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
     ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, DocSupU1, SQLRep_Config, ComnUnit,
     Sysu2, Btrvu2, VarRec2U, SysU1, SQLTraders, ExBtTh1u;

//------------------------------------------------------------------------------

procedure MsSqlRep_TraderOnHold(const AOwner: TObject;
                                const AReportParameters: DocRepPtr);
var
  lSQLRepObj: ^TTradersOnHoldReport_MSSQL;
begin
  // Ensure Thread Controller is up and running
  if Create_BackThread then
  begin
    // Create report object

    New(lSQLRepObj, Create(AOwner));
    try
      // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lSQLRepObj^.UsingEmulatorFiles := False;

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

procedure PervasiveRep_TraderOnHold(const AOwner: TObject;
                                    const AReportParameters: DocRepPtr);
var
  lPervasiveRepObj: ^TTradersOnHoldReport_Pervasive;
begin
  if Create_BackThread then
  begin
    New(lPervasiveRepObj, Create(AOwner));
    try
      // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lPervasiveRepObj^.UsingEmulatorFiles := False;
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

procedure TradersOnHold_Report(const AOwner: TObject;
                               const AReportParameters: DocRepPtr);
begin
  if SQLUtils.UsingSQL then
    MsSqlRep_TraderOnHold(AOwner, AReportParameters)
  else
    PervasiveRep_TraderOnHold(AOwner, AReportParameters);
end;

//------------------------------------------------------------------------------
{ TTradersOnHoldReport }
//------------------------------------------------------------------------------

constructor TTradersOnHoldReport.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
end;

//------------------------------------------------------------------------------

function TTradersOnHoldReport.GetReportInput: Boolean;
begin
  with ReportParameters do
  begin
    ThTitle := 'Traders on Hold';
    RepTitle := ThTitle;
    PageTitle := RepTitle;
    ROrient := RPDefine.poLandScape;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport.PrintTraderDetails(const ATraderRec: CustRec);
var
  lTraderStatus: String;
begin
  with ATraderRec do
  begin
    ThrowNewPage(5);
    // Put drill-down box across entire line for Transaction Header
    SendRepDrillDown(1, TotTabs, 1, CustCode, CustF, CustCodeK, 0);
    lTraderStatus := Show_AccStatus(AccStatus);
    SendLine(#9 + CustCode +
             #9 + Company +
             #9 + Contact +
             #9 + EmailAddr +
             #9 + LeftStr(Trim(Phone), 18) +
             #9 + LeftStr(Trim(Phone2), 18) +
             #9 + lTraderStatus);
  end;
  //Update the line count and progress - ignore total lines
  ICount := ICount + 1;
  if Assigned(ThreadRec) then
    UpdateProgress(2 + ICount);
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport.RepPrintPageHeader;
begin
  with RepFiler1 do
  begin
    DefFont(0, [fsBold]);
    SendLine(Concat(#9, 'Acc No.',
                    #9, 'Company',
                    #9, 'Contact',
                    #9, 'e-Mail',
                    #9, 'Telephone',
                    #9, 'Mobile',
                    #9, 'Status'));
    DefFont(0, []);
  end; 
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport.RepSetTabs;
begin
  with RepFiler1 do
  begin
    ClearTabs;
    SetTab(MarginLeft, pjLeft, 15, 3, 0, 0); // Acc No
    SetTab(NA, pjLeft, 75, 3, 0, 0);         // Company
    SetTab(NA, pjLeft, 55, 3, 0, 0);         // Contact
    SetTab(NA, pjLeft, 60, 3, 0, 0);         // Email
    SetTab(NA, pjLeft, 32, 4, 0, 0);         // Tel No
    SetTab(NA, pjLeft, 32, 4, 0, 0);         // Mobile
    SetTab(NA, pjLeft, 25, 3, 0, 0);         // Status
  end; // with RepFiler1
  SetTabCount;
end;

//------------------------------------------------------------------------------
{ TTradersOnHoldReport_MSSQL }
//------------------------------------------------------------------------------

constructor TTradersOnHoldReport_MSSQL.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  bIsSQLReport := True;
  FoReportLogger := TEntSQLReportLogger.Create(SQLLoggingArea);
  FCompanyCode := GetCompanyCode(SetDrive);
end;

//------------------------------------------------------------------------------

destructor TTradersOnHoldReport_MSSQL.Destroy;
begin
  FreeAndNIL(FoReportLogger);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport_MSSQL.Process;
begin
  UpdateProgress(1);
  inherited Process;
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport_MSSQL.RepPrint(Sender: TObject);
var
  lTradersHeaders: TSQLSelectTraders;
begin
  lTradersHeaders := TSQLSelectTraders.Create;
  try
    lTradersHeaders.CompanyCode := FCompanyCode;
    lTradersHeaders.FromClause  := 'FROM [COMPANY].CUSTSUPP';
    lTradersHeaders.WhereClause := 'WHERE acCustSupp = '+ QuotedStr('C') + ' AND acAccStatus = 2'; //Trader On Hold status = 2
    lTradersHeaders.OrderByClause := 'ORDER BY acCode';

    ShowStatus(2, 'Retrieving Data, Please Wait...');
    ShowStatus(3, 'This can take several minutes');
    lTradersHeaders.OpenFile;
    FoReportLogger.StartQuery(lTradersHeaders.SQLCaller.Records.CommandText);
    FoReportLogger.FinishQuery;
    ShowStatus(2,'Processing Report.');
    ShowStatus(3,'');

    if (lTradersHeaders.SQLCaller.ErrorMsg = '') and (lTradersHeaders.Count > 0) then
    begin
      // Set MaxProgress Value of Progress Bar range
      FMaxProgress := lTradersHeaders.Count + 2;
      // Initialise the Progress Bar range
      InitProgress(FMaxProgress);
      if Assigned(ThreadRec) then
        RepAbort := ThreadRec^.THAbort;

      lTradersHeaders.SQLCaller.Records.DisableControls;
      try
        lTradersHeaders.First;
        while (not lTradersHeaders.Eof) and (ChkRepAbort) do
        begin
          // Pass to common ancestor for printing transaction line
          PrintTraderDetails(lTradersHeaders.ReadRecord);
          if Assigned(ThreadRec) then
            RepAbort := ThreadRec^.THAbort;
          lTradersHeaders.Next;
        end;
      finally
        lTradersHeaders.SQLCaller.Records.EnableControls;
      end;
    end
    else if (lTradersHeaders.SQLCaller.ErrorMsg <> '') then
      WriteSQLErrorMsg(lTradersHeaders.SQLCaller.ErrorMsg);
  finally
    lTradersHeaders.CloseFile;
    FreeAndNil(lTradersHeaders);
  end;

  // Print footer
  PrintEndPage;
  FoReportLogger.FinishReport;
end;

//------------------------------------------------------------------------------

function TTradersOnHoldReport_MSSQL.SQLLoggingArea: String;
begin
  Result := 'TradersOnHoldReport';
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport_MSSQL.WriteSQLErrorMsg(const ASQLErrorMsg: String);
begin
  DefFont (0,[fsBold]);
  Self.CRLF;
  Self.PrintLeft('Error: ' + ASQLErrorMsg, RepFiler1.MarginLeft);
  Self.CRLF;
  Self.CRLF;
  FoReportLogger.LogError('Query Error', ASQLErrorMsg);
end;

//------------------------------------------------------------------------------
{ TTradersOnHoldReport_Pervasive }
//------------------------------------------------------------------------------

constructor TTradersOnHoldReport_Pervasive.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  RepKey := '';
end;

//------------------------------------------------------------------------------

function TTradersOnHoldReport_Pervasive.IncludeRecord: Boolean;
begin
  with MTExLocal^.LCust do
  begin
    Result := (CustSupp = 'C') And (AccStatus = 2); //Trader On Hold status = 2
  end;
end;

//------------------------------------------------------------------------------

procedure TTradersOnHoldReport_Pervasive.RepPrint(Sender: TObject);
begin
  // Run through the records in CustSupp
  ShowStatus(2,'Processing Report.');

  with MTExLocal^, RepFiler1 do
  begin
    LStatus := LFind_Rec(B_GetFirst, CustF, CustCodeK, RepKey);

    if Assigned(ThreadRec) then
      RepAbort := ThreadRec^.THAbort;

    while (LStatus = 0) and (ChkRepAbort) do
    begin
      if IncludeRecord then
        PrintTraderDetails(LCust);

      LStatus := LFind_Rec(B_GetNext, CustF, CustCodeK, RepKey);

      if Assigned(ThreadRec) then
        RepAbort:=ThreadRec^.THAbort;
    end; // While (LStatus = 0) do
  end;
  // Print footer
  PrintEndPage;
end;

end.
