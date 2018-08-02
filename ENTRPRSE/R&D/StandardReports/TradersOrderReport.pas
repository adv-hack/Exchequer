unit TradersOrderReport;

{******************************************************************************}
{                                                                              }
{                   ====----> E X C H E Q U E R <----===                       }
{                                                                              }
{                            Created: 24/03/2017                               }
{                                                                              }
{            Reports\&Daybook Reports->Sales Orders With Status.               }
{            Reports\&Daybook Reports->Purchase Orders With Status             }
{            Reports\&Daybook Reports->Sales Delivery Notes                    }
{            Reports\&Daybook Reports->Purchase Delivery Notes                 }
{                                                                              }
{                        Copyright (C) 1990 by EAL & RGS                       }
{                        Credit given to Hitesh Vaghani                        }
{ History :                                                                    }
{ 1. Report to list transactions in folio order and present columns in same    }
{    order as Purchase/Sales daybook                                           }
{ 2. Sales/Purchase DeliveryNote Daybook Report added - to list Sales Orders   }
{    that have been dispatched but not yet invoiced basically all SDNs/PDNs    }
{    torSalesDeliveryNote, torPurchaseDeliveryNote added on 28/03/2017         }
{******************************************************************************}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses DB, Graphics, SysUtils, Math, StrUtils, GlobVar, VarConst, SQLCallerU,
     SQLRep_BaseReport, ReportU, BTSupU3, EntLoggerClass, Btrvu2;

{$I DEFOVR.Inc}

type
  TTradersOrderReportType = (torSalesOrders=0, torPurchaseOrders=1,
                             torSalesDeliveryNote=2, torPurchaseDeliveryNote=3,
                             torSalesOrdersPartialDelivered=4, torPurchaseOrdersPartialDelivered=5,
                             torSalesOrdersPicked=6);

  //Base class consisting common functionality for both pervasive as well as SQL
  TTradersOrderReport = object(TGenReport)
	  procedure RepSetTabs; virtual;
    procedure RepPrintPageHeader; virtual;
  private
    FOrderStatus: ShortString;
    FNetAmount: Double;
    //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
    FStockCode: Str20;
    FQtyPick: Real;
    FReportForCurrency: Byte;
    function GetReportInput: Boolean; virtual;
    procedure CalcAmountFieldValue(const AInv: InvRec);
    procedure PrintTransactionDetails(const AInv: InvRec);
  public
  	ReportType: TTradersOrderReportType;
    ReportParameters: DocRepParam;
	  constructor Create(AOwner: TObject);

  end; //TTradersOrderReport

  //Pervasive descendant class
  TTradersOrderReport_Pervasive = object(TTradersOrderReport)
  private
    function IncludeRecord: Boolean; virtual;
    //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
    function IncludeRecordDetail: Boolean;
    procedure RepPrint(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TObject);
  end; //TTradersOrderReport_Pervasive

  //SQL descendant class
  TTradersOrderReport_MSSQL = object(TTradersOrderReport)
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
  end; //TTradersOrderReport_MSSQL

  //Main entry point to be called print report
  procedure TradersOrder_Report(const AOwner: TObject;
                                const AReportType: TTradersOrderReportType;
                                const AReportParameters: DocRepPtr);


implementation

uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
     ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, DocSupU1, SQLRep_Config, ComnUnit,
     VarRec2U, SysU1, ExWrap1U, RPFiler, SQLTransactions, ExBtTh1u, RPBase;

//------------------------------------------------------------------------------

procedure MsSqlRep_TradersOrder(const AOwner: TObject;
                                const AReportType: TTradersOrderReportType;
                                const AReportParameters: DocRepPtr);
var
  lSQLRepObj: ^TTradersOrderReport_MSSQL;
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

      //PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line
      if not lSQLRepObj.ReportParameters.Summary then
        lSQLRepObj.ROrient := RPDefine.poLandScape;

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

procedure PervasiveRep_TradersOrder(const AOwner: TObject;
                                    const AReportType: TTradersOrderReportType;
                                    const AReportParameters: DocRepPtr);
var
  lPervasiveRepObj: ^TTradersOrderReport_Pervasive;
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

      //PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line
      if not lPervasiveRepObj.ReportParameters.Summary then
        lPervasiveRepObj.ROrient := RPDefine.poLandScape;

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

procedure TradersOrder_Report(const AOwner: TObject;
                              const AReportType: TTradersOrderReportType;
                              const AReportParameters: DocRepPtr);
begin
  if SQLUtils.UsingSQL then
    MsSqlRep_TradersOrder(AOwner, AReportType, AReportParameters)
  else
    PervasiveRep_TradersOrder(AOwner, AReportType, AReportParameters);
end;

//------------------------------------------------------------------------------
{ TTradersOrderReport }
//------------------------------------------------------------------------------

procedure TTradersOrderReport.CalcAmountFieldValue(const AInv: InvRec);
var
  lCrDr: DrCrDType;
  lUOR: Byte;
begin
  //Set Status
  FOrderStatus := DisplayHold(AInv.HoldFlg);

  // Calculate transaction values for report as per DayBook Screen
  // Calculate Order Total in GBP
  if ReportType in [torSalesOrders, torPurchaseOrders] then
  begin
    if FReportForCurrency = 0 then
    begin
      lUOR := fxUseORate(BOff , BOn, AInv.CXrate, AInv.UseORate, AInv.Currency, 0);
      lCrDr[BOff] := Round_Up(Conv_TCurr(AInv.TotOrdOS, XRate(AInv.CXRate, BOff, AInv.Currency),
                                       AInv.Currency, lUOR, BOff), 2);
      lCrDr[BOn] := 0;
    end
    else
    begin
      lCrDr[BOff] := AInv.TotOrdOS;
      lCrDr[BOn] := 0;
    end;
    FNetAmount := lCrDr[BOff] - lCrDr[BOn];
  end;

	//PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
  if ReportType in [torSalesOrdersPicked] then
  begin
    if not UsingSQL then
    begin
      FStockCode := MTExLocal.LId.StockCode;
      FQtyPick := MTExLocal.LId.QtyPick;
    end;
  end;

end;

//------------------------------------------------------------------------------

constructor TTradersOrderReport.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FNetAmount := 0.00;
  FReportForCurrency := 0;
  //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
  FStockCode := '';
  FQtyPick := 0;
end;

//------------------------------------------------------------------------------

function TTradersOrderReport.GetReportInput: Boolean;
begin
  with ReportParameters do
  begin
    case ReportType of
      torSalesOrders
        : begin
            thTitle := 'Sales Orders Status';
            RepKey := 'S';
          end;
      torPurchaseOrders
        : begin
            thTitle := 'Purchase Orders Status';
            RepKey := 'P';
          end;
      torSalesDeliveryNote
        : begin
            thTitle := 'Sales Orders Delivered not Invoiced';
            RepKey := 'S';
          end;
      torPurchaseDeliveryNote
        : begin
            thTitle := 'Purchase Orders Received not Invoiced';
            RepKey := 'P';
          end;
      torSalesOrdersPartialDelivered
        : begin
            thTitle := 'Sales Orders not Fully Allocated';
            RepKey := 'S';
          end;
      torPurchaseOrdersPartialDelivered
        : begin
            thTitle := 'Purchase Orders Part Received';
            RepKey := 'P';
          end;
      torSalesOrdersPicked
        : begin
            //PL 27/10/2017 2017-R2	ABSEXCH-19369 Enhancements to Picked Sales Order Report
            if  ReportParameters.Summary then
              thTitle := 'Picked Sales Orders – Summary'
            else
              thTitle := 'Picked Sales Orders – Detailed';

            RepKey := 'S';
          end;


      else
        thTitle := 'Unknown Report';
    end;

    RepTitle := thTitle;
    {$IFDEF MC_On}
      if ReportType in [torSalesOrders, torPurchaseOrders] then
        RepTitle := CurrDesc(FReportForCurrency) + RepTitle; // GBP-Consolidated Default
    {$ENDIF}
    PageTitle := RepTitle;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------



procedure TTradersOrderReport.PrintTransactionDetails(const AInv: InvRec);
begin
  with AInv do
  begin
    ThrowNewPage(5);
    CalcAmountFieldValue(AInv);


    // Put drill-down box across entire line for Transaction Header
    SendRepDrillDown(1, TotTabs, 1, OurRef, InvF, InvOurRefK, 0);

    if ReportType in [torSalesOrders, torPurchaseOrders] then
    begin
      // Overwrite Account details portion of line with drill-down box for Account
      SendRepDrillDown(1, 1, 2, CustCode, CustF, CustCodeK, 0);
      SendLine(#9 + CustCode +
               #9 + OurRef +
               #9 + YourRef +
               #9 + POutDateB(TransDate) +
               #9 + PPR_OutPr(AcPr,AcYr) +
               #9 + FormatFloat(GenRealMask, FNetAmount) +
               #9 + FOrderStatus +
               #9 + OpName)
    end
    else if ReportType in [torSalesDeliveryNote, torPurchaseDeliveryNote] then
    begin
      SendRepDrillDown(1, 1, 2, RemitNo, InvF, InvOurRefK, 0);
      SendRepDrillDown(3, 3, 2, CustCode, CustF, CustCodeK, 0);
      SendLine(#9 + RemitNo  +
               #9 + OurRef +
               #9 + CustCode +
               #9 + YourRef +
               #9 + POutDateB(TransDate) +
               #9 + PPR_OutPr(AcPr,AcYr) +
               #9 + FOrderStatus +
               #9 + OpName)
    end
    //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
    else if (ReportType in [torSalesOrdersPicked]) and (not ReportParameters.Summary) then
    begin
      SendRepDrillDown(1, 1, 2, CustCode, CustF, CustCodeK, 0);
      SendRepDrillDown(7, 7, 2, FStockCode, StockF, StkCodeK, 0);
      SendLine(#9 + CustCode +
               #9 + OurRef +
               #9 + YourRef +
               #9 + POutDateB(TransDate) +
               #9 + PPR_OutPr(AcPr,AcYr) +
               #9 + FOrderStatus +
               #9 + FStockCode +
               #9 + FloatToStr(FQtyPick) +
               #9 + OpName);
    end
    else
    begin
      SendRepDrillDown(1, 1, 2, CustCode, CustF, CustCodeK, 0);
      SendLine(#9 + CustCode +
               #9 + OurRef +
               #9 + YourRef +
               #9 + POutDateB(TransDate) +
               #9 + PPR_OutPr(AcPr,AcYr) +
               #9 + FOrderStatus +
               #9 + OpName);
    end;

    end;
  // Update the line count and progress - ignore total lines
  ICount := ICount + 1;
  if Assigned(ThreadRec) then
    UpDateProgress(2 + ICount);
end;

//------------------------------------------------------------------------------

procedure TTradersOrderReport.RepPrintPageHeader;
var
  lOrderRef: String;
begin
  with RepFiler1 do
  begin
    DefFont(0,[fsBold]);
    if ReportType = torSalesDeliveryNote then
      lOrderRef := ConCat('SOR Ref', #9, 'SDN Ref')
    else if ReportType = torPurchaseDeliveryNote then
      lOrderRef := ConCat('POR Ref', #9, 'PDN Ref');

    if ReportType in [torSalesOrders, torPurchaseOrders] then
      SendLine(ConCat(#9, 'A/C',
                      #9, 'Our Ref',
                      #9, 'Your Ref',
                      #9, 'Date',
                      #9, 'Period',
                      #9, 'O/S Amount',
                      #9, 'Status',
                      #9, 'User Name'))
    else if ReportType in [torSalesDeliveryNote, torPurchaseDeliveryNote] then
      SendLine(ConCat(#9, lOrderRef,
                      #9, 'A/C',
                      #9, 'Your Ref',
                      #9, 'Date',
                      #9, 'Period',
                      #9, 'Status',
                      #9, 'User Name'))
    //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
    else if  (ReportType in [torSalesOrdersPicked] ) and (not ReportParameters.Summary) then
      SendLine(ConCat(#9, 'A/C',
                      #9, 'Our Ref',
                      #9, 'Your Ref',
                      #9, 'Date',
                      #9, 'Period',
                      #9, 'Status',
                      #9, 'Stock Code',
                      #9, 'Picked Qty',
                      #9, 'User Name'))
    else
      SendLine(ConCat(#9, 'A/C',
                      #9, 'Our Ref',
                      #9, 'Your Ref',
                      #9, 'Date',
                      #9, 'Period',
                      #9, 'Status',
                      #9, 'User Name'));

    DefFont(0,[]);
  end;
end;

//------------------------------------------------------------------------------

procedure TTradersOrderReport.RepSetTabs;
begin
  with RepFiler1 do
  begin
    ClearTabs;
    if ReportType in [torSalesOrders, torPurchaseOrders] then
    begin
      SetTab(MarginLeft, pjLeft, 18, 4, 0, 0); // A/C
      SetTab(NA, pjLeft, 24, 10, 0, 0);        // Our Ref
      SetTab(NA, pjLeft, 50, 4, 0, 0);         // Your Ref
      SetTab(NA, pjLeft, 18, 4, 0, 0);         // Date
      SetTab(NA, pjLeft, 16, 4, 0, 0);         // Period
      SetTab(NA, pjRight,32, 14, 0, 0);        // Amount
      SetTab(NA, pjLeft, 23, 4, 0, 0);         // Status
      SetTab(NA, pjLeft, 24, 4, 0, 0);         // Username
    end
    else if ReportType in [torSalesDeliveryNote, torPurchaseDeliveryNote] then
    begin
      SetTab(MarginLeft, pjLeft, 22, 10, 0, 0); // SOR Ref
      SetTab(NA, pjLeft, 24, 10, 0, 0);         // SDN Ref
      SetTab(NA, pjLeft, 22, 4, 0, 0);          // A/C
      SetTab(NA, pjLeft, 50, 4, 0, 0);          // Your Ref
      SetTab(NA, pjLeft, 18, 4, 0, 0);          // Date
      SetTab(NA, pjLeft, 16, 4, 0, 0);          // Period
      SetTab(NA, pjLeft, 30, 4, 0, 0);          // Status
      SetTab(NA, pjLeft, 24, 4, 0, 0);          // Username
    end
    //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
    else if (ReportType in [torSalesOrdersPicked]) and (not ReportParameters.Summary) then
    begin
      SetTab(MarginLeft, pjLeft, 22, 4, 0, 0);  // A/C                                                         19
      SetTab(NA, pjLeft, 24, 10, 0, 0);         // Our Ref
      SetTab(NA, pjLeft, 55, 4, 0, 0);          // Your Ref
      SetTab(NA, pjLeft, 22, 4, 0, 0);          // Date
      SetTab(NA, pjLeft, 18, 4, 0, 0);          // Period
      SetTab(NA, pjLeft, 34, 4, 0, 0);          // Status
      SetTab(NA, pjLeft, 35, 4, 0, 0);          // Stock Code
      //PL 27/10/2017 2017-R2	ABSEXCH-19369 Enhancements to Picked Sales Order Report
      SetTab(NA, pjRight, 20, 4, 0, 0);         // QtyPicked
      SetTab(NA, pjLeft, 30, 4, 0, 0);          // Username
    end
    else
    begin
      SetTab(MarginLeft, pjLeft, 22, 4, 0, 0);  // A/C
      SetTab(NA, pjLeft, 24, 10, 0, 0);         // Our Ref
      SetTab(NA, pjLeft, 55, 4, 0, 0);          // Your Ref
      SetTab(NA, pjLeft, 22, 4, 0, 0);          // Date
      SetTab(NA, pjLeft, 18, 4, 0, 0);          // Period
      SetTab(NA, pjLeft, 34, 4, 0, 0);          // Status
      SetTab(NA, pjLeft, 30, 4, 0, 0);          // Username
    end;
  end;
  SetTabCount;
end;

//------------------------------------------------------------------------------
{ TTradersOrderReport_MSSQL }
//------------------------------------------------------------------------------

constructor TTradersOrderReport_MSSQL.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  bIsSQLReport := True;
  FoReportLogger := TEntSQLReportLogger.Create(SQLLoggingArea);
  FCompanyCode := GetCompanyCode(SetDrive);
end;

//------------------------------------------------------------------------------

destructor TTradersOrderReport_MSSQL.Destroy;
begin
  FreeAndNIL(FoReportLogger);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TTradersOrderReport_MSSQL.Process;
begin
  UpdateProgress(1);
  inherited Process;
end;

//------------------------------------------------------------------------------

procedure TTradersOrderReport_MSSQL.RepPrint(Sender: TObject);
var
  lInvHeaders: TSQLSelectTransactions;

  //-----------------------------------

  function GetJoinClause: String;                   
  begin
    case ReportType of
      torSalesOrdersPartialDelivered,
      torPurchaseOrdersPartialDelivered
      {PL 27/10/2017 2017-R2	ABSEXCH-19372 MSSQL Only: Error TSQLTransactions.OpenFile : Invalid Column name 'tlQtyPicked' is thrown when running
							'Orders Status' and 'Orders delivered not Invoiced' Report [MSSQL]}

      //VA 13/02/2018 2018-R1 ABSEXCH-19761 Sales & Purchase Orders’ report: Error is getting display and user cannot generate any report after this.
        : Result := 'Left Join [COMPANY].details ON [COMPANY].Document.thFolioNum = [COMPANY].DETAILS.tlFolioNum';

      torSalesOrdersPicked
        : begin
          //PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line
            if ReportParameters.Summary then
              Result := ''
            else
              Result := 'JOIN [COMPANY].DETAILS ON [COMPANY].DOCUMENT.thFolioNum = [COMPANY].DETAILS.tlFolioNum and ([COMPANY].DETAILS.tlQtyPicked <> 0)'+
                        ' JOIN [COMPANY].STOCK ON [COMPANY].DETAILS.tlStockCodeTrans1 = [COMPANY].STOCK.stCode and ([COMPANY].STOCK.stType <> ''D'')';
          end;
      else
        Result := ''
    end;
  end;

  //-----------------------------------

  function GetWhereClause: String;
  begin
    case ReportType of
      torSalesOrders
        : Result := 'WHERE (thDocType=8) AND (thRunNo=-40)';  // SOR=8
      torPurchaseOrders
        : Result := 'WHERE (thDocType=23) AND (thRunNo=-50)'; // POR=23
      torSalesDeliveryNote
        : Result := 'WHERE (thDocType=9) AND (thRunNo=-40) AND (thRemitNo <> '''')';  // SDN=9
      torPurchaseDeliveryNote
        : Result := 'WHERE (thDocType=24) AND (thRunNo=-50) AND (thRemitNo <> '''')'; // PDN=24
      torSalesOrdersPartialDelivered
        : Result := 'WHERE (thDocType=8) AND (thRunNo=-40) AND (ROUND(tlQty - (tlQtyDel + tlQtyWOFF), 2) <> tlQty)';
      torPurchaseOrdersPartialDelivered
        : Result := 'WHERE (thDocType=23) AND (thRunNo=-50) AND (ROUND(tlQty - (tlQtyDel + tlQtyWOFF), 2) <> tlQty)';
      torSalesOrdersPicked
        : begin
        //PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line
            if ReportParameters.Summary then
              Result := 'WHERE (thDocType=8) AND (thRunNo=-40)'+
                        ' AND thFolioNum in (Select tlFolioNum from [COMPANY].DETAILS where (tlQtyPicked <> 0) AND '+
                        ' tlStockCodeTrans1 in(select stCode from [COMPANY].STOCK where (stType <> ''D'' )))'
            else
              Result := ' WHERE (thDocType=8) AND (thRunNo=-40)';

          end;

          end;
  end;

  //-----------------------------------

  function GetOrderByClause: String;
  begin
    case ReportType of
      torSalesDeliveryNote, torPurchaseDeliveryNote
        : Result := 'ORDER BY thRemitNo';
      else
        Result := ' ORDER BY thFolioNum';
    end;
  end;

  //-----------------------------------

begin
  lInvHeaders := TSQLSelectTransactions.Create;
  try
    lInvHeaders.CompanyCode := FCompanyCode;
    //PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line
    if ( not ReportParameters.Summary) and (ReportType in[torSalesOrdersPicked]) then
      lInvHeaders.FromClause  := ' ,stCode ,tlQtyPicked FROM [COMPANY].DOCUMENT'
    else
      lInvHeaders.FromClause  := 'FROM [COMPANY].DOCUMENT';
    lInvHeaders.JoinClause  := GetJoinClause;
    lInvHeaders.WhereClause := GetWhereClause;
    lInvHeaders.OrderByClause := GetOrderByClause;

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
          //PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line
           if (not ReportParameters.Summary) and (ReportType in[torSalesOrdersPicked]) then
          begin
            FStockCode:= lInvHeaders.SQLCaller.Records.FieldByName('stCode').Value;
            FQtyPick:= lInvHeaders.SQLCaller.Records.FieldByName('tlQtyPicked').Value;
          end;

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

function TTradersOrderReport_MSSQL.SQLLoggingArea: String;
begin
  Result := 'TradersOrderReport';
end;

//------------------------------------------------------------------------------

procedure TTradersOrderReport_MSSQL.WriteSQLErrorMsg(
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
{ TTradersOrderReport_Pervasive }
//------------------------------------------------------------------------------

constructor TTradersOrderReport_Pervasive.Create(
  AOwner: TObject);
begin
  inherited Create(AOwner);
  RepKey := '';
end;

function TTradersOrderReport_Pervasive.IncludeRecord: Boolean;

  //-----------------------------------

  function IsValidOrder: Boolean;
  var
    lDetailsKey,
    lKey: Str255;
    lQtyOS: Double;
  begin
    Result := False;
    with MTExLocal^ do
    begin
      lDetailsKey := FullIdKey(LInv.FolioNum, 1);
      LStatus := LFind_Rec(B_GetEq, IDetailF, IdFolioK, lDetailsKey);

      while (LStatus = 0) and (not Result) and (LInv.FolioNum = LId.FolioRef) do
      begin
        if (ReportType in [torSalesOrdersPartialDelivered, torPurchaseOrdersPartialDelivered]) then
        begin
          lQtyOS := 0.0;
          lQtyOS := Round_Up((LId.Qty - (LId.QtyDel + LId.QtyWOFF)), Syss.NoQtyDec);
          Result := lQtyOS <> LId.Qty;
        end
        else if (ReportType=torSalesOrdersPicked) then
        begin
          //PL 26/10/2017 2017-R2 ABSEXCH-18729 Picked Sales Orders Report - Add Stock Code column for detailed version of report
          lKey := FullStockCode(LId.StockCode);
          LStatus := LFind_Rec(B_GetEq, StockF, StkCodeK, lKey);
          if LStatus = 0 then
          begin
            Result := (LId.QtyPick <> 0) and (LStock.StockType <> 'D');
            LStatus := LFind_Rec(B_GetNext, IDetailF, IdFolioK, lDetailsKey);
          end;
        end;
      end;
    end;
  end;

  //-----------------------------------

begin
  with MTExLocal^ do
  begin
    case ReportType of
      torSalesOrders
        : Result := (LInv.InvDocHed = SOR) and (LInv.RunNo = -40);
      torPurchaseOrders
        : Result := (LInv.InvDocHed = POR) and (LInv.RunNo = -50);
      torSalesDeliveryNote
        : Result := (LInv.InvDocHed = SDN) and (LInv.RunNo = -40) and (LInv.RemitNo <> EmptyStr);
      torPurchaseDeliveryNote
        : Result := (LInv.InvDocHed = PDN) and (LInv.RunNo = -50) and (LInv.RemitNo <> EmptyStr);
      torSalesOrdersPartialDelivered
        : Result := (LInv.InvDocHed = SOR) and (LInv.RunNo = -40) and IsValidOrder;
      torPurchaseOrdersPartialDelivered
        : Result := (LInv.InvDocHed = POR) and (LInv.RunNo = -50) and IsValidOrder;
      torSalesOrdersPicked
        : Result :=  (LInv.InvDocHed = SOR) and (LInv.RunNo = -40) and IsValidOrder
    end;
  end;
end;

//------------------------------------------------------------------------------
//PL 26/10/2017 2017-R2 ABSEXCH-18728 Picked Sales Orders Report - Add Summary Option to only list each order once rather than once per picked line

function TTradersOrderReport_Pervasive.IncludeRecordDetail: Boolean;
var
  lDetailsKey,
  lKey: str255;
begin
  Result := False;
  with MTExLocal^ do
  begin
    lDetailsKey := FullIdKey(LInv.FolioNum, 1);
    LStatus := LFind_Rec(B_GetEq, IDetailF, IdFolioK, lDetailsKey);

    while (LStatus = 0) and (LInv.FolioNum = LId.FolioRef) do
    begin
      lKey := FullStockCode(LId.StockCode);
      LStatus := LFind_Rec(B_GetEq, StockF, StkCodeK, lKey);
      if LStatus = 0 then
      begin
        Result := (LId.QtyPick <> 0) and (LStock.StockType <>'D') and (LInv.InvDocHed = SOR) and (LInv.RunNo = -40);
        if Result then
          PrintTransactionDetails(LInv);
      end;
      LStatus := LFind_Rec(B_GetNext, IDetailF, IdFolioK, lDetailsKey);
    end;

  end;

end;

procedure TTradersOrderReport_Pervasive.RepPrint(Sender: TObject);
var
  lHasLine: Boolean;
begin
  // Run through the transactions in the Documents
  ShowStatus(2,'Processing Report.');

  with MTExLocal^, RepFiler1 do
  begin

    LStatus := LFind_Rec(B_GetFirst, InvF, InvFolioK, RepKey);

    if Assigned(ThreadRec) then
      RepAbort := ThreadRec^.THAbort;

    while (LStatus = 0) and (ChkRepAbort) do
    begin

      if (ReportType = torSalesOrdersPicked) and (not ReportParameters.Summary) then
      begin
         IncludeRecordDetail;
      end
      else if IncludeRecord then
        PrintTransactionDetails(LInv);


      LStatus := LFind_Rec(B_GetNext, InvF, InvFolioK, RepKey);
      if Assigned(ThreadRec) then
        RepAbort:=ThreadRec^.THAbort;
    end; // While (LStatus = 0) do
  end;
  // Print footer
  PrintEndPage;
end;

{thDocType List
SIN(0), SCR(2), SJI(3), SJC(4), SRF(5), SRI(6)
PIN(15),PCR(17),PJI(18),PJC(19),PRF(20),PPI(21)
SRC(1), SRF(5), SRI(6)
PPY(16),PRF(20),PPI(21)
SOR(8), SDN(9)
POR(23),PDN(24)
NOM(30)
}

//------------------------------------------------------------------------------

end.
