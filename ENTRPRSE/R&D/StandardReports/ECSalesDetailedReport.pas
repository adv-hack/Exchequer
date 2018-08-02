unit ECSalesDetailedReport;


{******************************************************************************}
{                                                                              }
{                   ====----> E X C H E Q U E R <----===                       }
{                                                                              }
{                            Created: 18/07/2017                               }
{                                                                              }
{            Reports\&VAT Reports->EC Sales List Breakdown.                    }
{                                                                              }
{                        Copyright (C) 1990 by EAL & RGS                       }
{                        Credit given to Hitesh Vaghani                        }
{ History :                                                                    }
{ 1. Report to list transactions in folio order and trader vat registration    }
{    number order and present columns in same order as EC Sales List.          }
{******************************************************************************}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses DB, Graphics, SysUtils, Math, StrUtils, GlobVar, VarConst, SQLCallerU, Dialogs,
     SQLRep_BaseReport, ReportU, BTSupU3, EntLoggerClass, Btrvu2;

{$I DEFOVR.Inc}

type

  TECSalesDetailedTotals = record
    Goods: Double;
    TriangulatedGoods: Double;
    TriangulatedServices: Double;
    Services: Double;
  end;

  //Base class consisting common functionality for both pervasive as well as SQL
  TECSalesDetailedReport = object(TGenReport)
	  procedure RepSetTabs; virtual;
    procedure RepPrintPageHeader; virtual;
  private
    FReportForCurrency: Byte;
    IncludeGoods: Boolean;
    IncludeServices: Boolean;
    FGoodsAmountTotal,
    FServicesAmountTotal: Double;
    NewCust: Boolean;
    CustFirstTransVal: Double;

    UpdateECServiceTax: Boolean;
    CustTotals: TECSalesDetailedTotals;
    // PrintingAcCode is blank then the current customer is not being printed
    LastAcCode, PrintingAcCode, PrintingAcVATRegNo : ShortString;
    function GetReportInput: Boolean; virtual;
    function IncludeECInv(AInv: InvRec; SDate, EDate: LongDate):Boolean;
    procedure PrintAccountHeader (Const Continuation : Boolean);
    procedure RepPrintHeader(Sender : TObject); Virtual;
    procedure PrintAccountTotals;


    function CalcGoodsTotals(AInv: InvRec): Boolean;
    function CalcServiceTotals(AInv: InvRec): Boolean;

  public
    ReportParameters: CVATRepPtr;
	  constructor Create(AOwner: TObject);
  end; //TECSalesDetailedReport

  //Pervasive descendant class
  TECSalesDetailedReport_Pervasive = object(TECSalesDetailedReport)
  private
    //function IncludeRecord: Boolean; virtual;
    procedure RepPrint(Sender: TObject); virtual;
    procedure PrintTransactionLine(const AInv: InvRec);
    procedure PrintTransaction(const AInv: InvRec; ANetValue: Double; AServicesInd: string);
  public
    constructor Create(AOwner: TObject);
  end; //TECSalesDetailedReport_Pervasive

  //SQL descendant class
  TECSalesDetailedReport_MSSQL = object(TECSalesDetailedReport)
  private
	  FoReportLogger: TEntSQLReportLogger;
    FCompanyCode: AnsiString;
    FMaxProgress: LongInt;
    procedure WriteSQLErrorMsg(const ASQLErrorMsg: String);
    function SQLLoggingArea: String; virtual;
    function ValidRecord(AOurRef: String): Boolean;
    procedure RepPrint(Sender: TObject); virtual;
    procedure PrintTransactionLine(const ADateSet: TDataSet);
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; virtual;
    procedure Process; virtual;
  end; //TECSalesDetailedReport_MSSQL

  //Main entry point to be called print report
  procedure ECSalesDetailed_Report(const AOwner: TObject;
                                const AReportParameters: CVATRepPtr;
                                AIncludeGoods: Boolean = False; AIncludeServices: Boolean = False);


implementation

uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
     ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, DocSupU1, SQLRep_Config, ComnUnit,
     VarRec2U, SysU1, ExWrap1U, RPFiler, SQLTransactions, TEditVal;

//------------------------------------------------------------------------------

procedure MsSqlRep_ECSalesDetailed(const AOwner: TObject;
                                const AReportParameters: CVATRepPtr;
                                AIncludeGoods: Boolean; AIncludeServices: Boolean);
var
  lSQLRepObj: ^TECSalesDetailedReport_MSSQL;
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
      lSQLRepObj^.IncludeGoods := AIncludeGoods;
      lSQLRepObj^.IncludeServices := AIncludeServices;

      if Assigned(AReportParameters) then
        lSQLRepObj^.ReportParameters := AReportParameters;  

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
    end; // try..except
  end; // if Create_BackThread
end;

//------------------------------------------------------------------------------

procedure PervasiveRep_ECSalesDetailed(const AOwner: TObject;
                                    const AReportParameters: CVATRepPtr;
                                    AIncludeGoods: Boolean; AIncludeServices: Boolean);
var
  lPervasiveRepObj: ^TECSalesDetailedReport_Pervasive;
begin
  if Create_BackThread then
  begin

    New(lPervasiveRepObj, Create(AOwner));
    try
      // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lPervasiveRepObj^.UsingEmulatorFiles := False;
      // Initialise report properties
      lPervasiveRepObj^.IncludeGoods := AIncludeGoods;
      lPervasiveRepObj^.IncludeServices := AIncludeServices;

      if Assigned(AReportParameters) then
        lPervasiveRepObj^.ReportParameters := AReportParameters;

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

procedure ECSalesDetailed_Report(const AOwner: TObject;
                              const AReportParameters: CVATRepPtr;
                              AIncludeGoods: Boolean; AIncludeServices: Boolean);
begin
  if SQLUtils.UsingSQL then
    MsSqlRep_ECSalesDetailed(AOwner, AReportParameters, AIncludeGoods, AIncludeServices)
  else
    PervasiveRep_ECSalesDetailed(AOwner, AReportParameters, AIncludeGoods, AIncludeServices);
end;

//------------------------------------------------------------------------------
{ TECSalesDetailedReport }
//------------------------------------------------------------------------------

constructor TECSalesDetailedReport.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FReportForCurrency := 0;
  FGoodsAmountTotal := 0;
  FServicesAmountTotal := 0;
end;

//------------------------------------------------------------------------------

function TECSalesDetailedReport.GetReportInput: Boolean;
begin
  with ReportParameters^ do
  begin
    thTitle := 'EC Sales List Breakdown'; 
    RepTitle := thTitle;
    PageTitle := RepTitle;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------
function TECSalesDetailedReport.IncludeECInv(AInv: InvRec; SDate, EDate: LongDate):Boolean;
var
  IsLoan: Boolean;
begin

  with AInv do
  begin
    IsLoan := Copy(IntToStr(AInv.TransNat), 1, 1) = '6';

    Result:=((TransDate>=SDate) and (TransDate<=EDate))
      and ((RunNo>=0) or (RunNo=BatchRunNo)) {Debug mode only }
      and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet))
      and (not IsLoan);


    {$IFDEF USEONEDAY}
    Result:= (((TransDate>=SDate) and (TransDate<=EDate))
          or ((PostDate>=SDate) and (PostDate<=EDate) and (TransDate<SDate)))
            and (RunNo>0) and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet))
      and ((Not (InvDocHed In CreditSet)) or (CurrentCountry<>IECCode))
      and (not IsLoan);

    {$ENDIF}
  end; {with..}


end;

//------------------------------------------------------------------------------

procedure TECSalesDetailedReport.RepPrintPageHeader;
var
  lOrderRef: String;
begin
  with RepFiler1 do
  begin
    DefFont(0,[fsBold]);

    SendLine(ConCat(#9, 'VAT Reg/Our Ref',
                    #9, 'Your Ref',
                    #9, 'Date',
                    #9, 'Per/Yr',
                    #9, 'Ac No.',
                    #9, 'Net',
                    #9, 'Indicator'));

    DefFont(0,[]);
  end;
end;

//------------------------------------------------------------------------------

procedure TECSalesDetailedReport.RepSetTabs;
begin
  with RepFiler1 do
  begin
    ClearTabs;
    SetTab (MarginLeft, pjLeft, 40, 4, 0, 0);     // Our Ref
    SetTab (NA, pjLeft, 45, 4, 0, 0);             // Your Ref
    SetTab (NA, pjLeft, 23, 4, 0, 0);             // Date
    SetTab (NA, pjLeft, 20, 4, 0, 0);             // Per/Yr
    SetTab (NA, pjLeft, 20, 4, 0, 0);             // Account Code
    SetTab (NA, pjRight,25, 4, 0, 0);             // Net
    SetTab (NA, pjCenter,20, 4, 0, 0);            // Indicator
  end;
  SetTabCount;
end;

//------------------------------------------------------------------------------
{ TECSalesDetailedReport_MSSQL }
//------------------------------------------------------------------------------

constructor TECSalesDetailedReport_MSSQL.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  bIsSQLReport := True;
  FoReportLogger := TEntSQLReportLogger.Create(SQLLoggingArea);
  FCompanyCode := GetCompanyCode(SetDrive);
end;

//------------------------------------------------------------------------------

destructor TECSalesDetailedReport_MSSQL.Destroy;
begin
  FreeAndNIL(FoReportLogger);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TECSalesDetailedReport_MSSQL.PrintTransactionLine(
  const ADateSet: TDataSet);
var
  lIndicator: String;
  UOR: Byte;
  NewVal: Double;
  CXrate: CurrTypes;
begin
  with ADateSet do
  begin
    ThrowNewPage(5);

    // Overwrite Account details portion of line with drill-down box for Account
    SendRepDrillDown(1, TotTabs, 1,  FieldByName('thOurRef').AsString, InvF, InvOurRefK, 0);

    if (FieldByName('thCurrency').AsInteger <> 1) then
    begin
      CXRate[BOff] := FieldByName('thOriginalCompanyRate').AsFloat;
      CXRate[Bon] := FieldByName('thOriginalDailyRate').AsFloat;
      UOR := fxUseORate(BOff, BOn, CXRate, FieldByName('thUseOriginalRates').AsInteger, FieldByName('thCurrency').AsInteger, 0);
      NewVal := Conv_TCurr(FieldByName('NetVal').AsFloat, XRate(CXRate, BOff, FieldByName('thCurrency').AsInteger), FieldByName('thCurrency').AsInteger, UOR, BOff);
    end
    else
      NewVal := FieldByName('NetVal').AsFloat;

    if (FieldByName('thDocType').AsInteger in [2,4,5]) then
      NewVal := (-1 * NewVal);

    if FieldByName('tlECService').AsBoolean then
    begin
      if (FieldByName('thProcess').AsString = 'T') then
        lIndicator := '2'
      else
        lIndicator := '3';
      FServicesAmountTotal := FServicesAmountTotal + NewVal;
    end
    else
    begin
      if (FieldByName('thProcess').AsString = 'T') then
        lIndicator := '2'
      else
        lIndicator := '';
      FGoodsAmountTotal := FGoodsAmountTotal + NewVal;
    end;

    SendLine( #9 + FieldByName('thOurRef').AsString +
              #9 + FieldByName('thYourRef').AsString +
              #9 + POutDateB(FieldByName('thTransDate').AsString) +
              #9 + PPR_OutPr(FieldByName('thPeriod').Value,FieldByName('thYear').Value) +
              #9 + FieldByName('thAcCode').AsString +
              #9 + FormatFloat(GenRealMask, NewVal) +  // Net
              #9 + lIndicator);

    if (CustFirstTransVal = 0) then
      CustFirstTransVal := NewVal;
  end;

  // Update the line count and progress - ignore total lines
  ICount := ICount + 1;
  if Assigned(ThreadRec) then
    UpDateProgress(2 + ICount);
end;

procedure TECSalesDetailedReport_MSSQL.Process;
begin
  UpdateProgress(1);
  inherited Process;
end;

//------------------------------------------------------------------------------

function TECSalesDetailedReport.CalcGoodsTotals(AInv: InvRec): Boolean;
const
  Fnum     =  InvF;
  Keypath  =  InvCustK;
  Fnum2    =  IdetailF;
  Keypath2 =  IdFolioK;
var
  InvKey,
  BaseInvKey,
  IdKey,
  BaseIdKey, KeyString :  Str255;
  Rnum: Real;
  ExclusionFolioNumber: Integer;
begin
  Result := False;
  if IncludeECInv(AInv, ReportParameters.VATStartD, ReportParameters.VATEndD) then
  begin
    BaseIdKey := FullNomKey(AInv.FolioNum);
    IdKey   := FullIdKey(AInv.FolioNum, 1);
    ExclusionFolioNumber := -1;
    with MTExLocal^ do
    begin
      LStatus := LFind_Rec(B_GetGEq, IdetailF, IdFolioK, IdKey);
      while (LStatusOk) and (Checkkey(BaseIdKey, IdKey, Length(BaseIdKey), BOn)) do
      begin
        with LId do
        begin
          if (LineNo > 0) and (VATCode in [VATECDCode, '4']) and (not ECService) then
          begin

            if NewCust then
            begin
              PrintAccountHeader(False);
              NewCust := False;
            end;

            if (ExclusionFolioNumber <> LId.KitLink) then
            begin
              Rnum := DetLTotal(LId, BOn, BOff, 0.0) * DocNotCnst;
              // Free-of-charge items should be reported at total Cost Price.
              if (Rnum = 0) then
                Rnum := (CostPrice * Qty) * LineCnst(Payment) * DocNotCnst;
              Rnum := Round_Up(Conv_VATCurr(Rnum,
                                            AInv.VATCrate[UseCoDayRate],
                                            XRate(AInv.OrigRates, BOff, Currency),
                                            Currency,
                                            UseORate), 2);
              if (Rnum <> 0) then
              begin
                //now we want to find out if this line is a BoM that exposes its kit lines (Exploded BoM),
                //to find out, get the stock record for this TX line
                KeyString :=  FullStockCode(LID.StockCode);
                LStatus := MTExLocal^.LFind_Rec(B_GetEq, StockF, StkCodeK, KeyString);
                if (LStatus = 0) then
                begin
                  //is this stock item a BoM, that shows its kit lines?
                  if (LStock.ShowAsKit = True) then
                  begin
                    //if so, we need to exclude these kit lines!
                    //to do this, we can match the exploded BOM lines to this BOM by examining their 'KitLink' value,
                    //if it matches the exploded BoM's folio number value, exclude it!
                    ExclusionFolioNumber := LStock.StockFolio;
                  end;
                end;
                Result := True;
                if (AInv.SSDProcess = 'T') then
                  CustTotals.TriangulatedGoods := CustTotals.TriangulatedGoods + Rnum
                else
                  CustTotals.Goods := CustTotals.Goods + Rnum;
              end;
            end;
          end;
          LStatus := LFind_Rec(B_GetNext, IdetailF, IdFolioK, IdKey);
        end;
      end;
    end;
  end; 
end;

//------------------------------------------------------------------------------
function TECSalesDetailedReport.CalcServiceTotals(AInv: InvRec): Boolean;

  function ServiceProRata(LineTotal: Double): Double;
  var
    StartOfYear, EndOfYear: LongDate;
    Include: Boolean;
    ServiceDays, ReportDays: Integer;
    DayRate: Double;
    IsContinuation: Boolean;
  begin
    Result := 0.0;
    Include := False;
    IsContinuation := False;
    with MTExLocal^ do
    begin
      ServiceDays := NoDays(LId.ServiceStartDate, LId.ServiceEndDate) + 1;
      ReportDays  := 0;
      StartOfYear := StrDate(Part_Date('Y', ReportParameters.VATStartD), 1, 1);
      EndOfYear := StrDate(Part_Date('Y', ReportParameters.VATStartD), 12, 31);
      IsContinuation := (LId.ServiceStartDate < StartOfYear);
      { Does the Service start before the end of the date range? }
      if (LId.ServiceStartDate <= ReportParameters.VATEndD) then
      begin
        { Does the Service end date fall within the report range and
          within the current year? If so we report the complete Service amount.
          (Scenario 1) }
        if ((LId.ServiceEndDate >= ReportParameters.VATStartD) and (LId.ServiceEndDate <= ReportParameters.VATEndD)) and
           ((LId.ServiceStartDate >= StartOfYear) and (LId.ServiceEndDate <= EndOfYear)) then
        begin
          Include := True;
        end
        { Otherwise, does it end next year, and does the report cover the last
          period of the year? If so, we report the Service amount from either
          the start of the Service, if it began this year (Scenario 4), or from
          the start of the year, if it began in the previous year (Scenario 3). }
        else if (Part_Date('Y', LId.ServiceEndDate) > Part_Date('Y', EndOfYear)) and
                (ReportParameters.VATStartD <= EndOfYear) and (ReportParameters.VATEndD >= EndOfYear) then
        begin
          Include := True;
          if (Part_Date('Y', LId.ServiceStartDate) < Part_Date('Y', StartOfYear)) then
            ReportDays := NoDays(StartOfYear, EndOfYear) + 1
          else
            ReportDays := NoDays(LId.ServiceStartDate, EndOfYear) + 1;
          IsContinuation := True;
        end
        { Otherwise, does the Service end between the start and end of the
          report range? If so, we report the Service amount from the start of
          the year, as it must have begun in the previous year (Scenario 2). }
        else if ((LId.ServiceEndDate >= ReportParameters.VATStartD) and (LId.ServiceEndDate <= ReportParameters.VATEndD)) then
        begin
          Include := True;
//          IsLast := True;
          ReportDays := NoDays(StartOfYear, LId.ServiceEndDate) + 1;
        end;
      end;
      if Include then
      begin
        if NewCust then
        begin
          PrintAccountHeader(False);
          NewCust := False;
        end;
        Result := Round_Up(Conv_VATCurr(LineTotal, LInv.VATCrate[UseCoDayRate],
                                        XRate(LInv.OrigRates, BOff, LId.Currency),
                                        LId.Currency, LInv.UseORate), 2);
        if (ReportDays > 0) then
        begin
          DayRate := Result / ServiceDays;

          Result := DayRate * ReportDays;
          if IsContinuation and UpdateECServiceTax then
          begin
//            LId.ECSalesTaxReported := Round_Up(Result, 0);
            LId.ECSalesTaxReported := Trunc(Result);
            LPut_Rec(IdetailF, IdServiceK);
          end;
        end;
      end;
    end;
  end;

var
  Key, BaseKey: Str255;
  InvKey: Str255;
  FuncRes: Integer;
  LineTotal: Double;
begin
  Result := False;
  BaseKey := FullNomKey(AInv.FolioNum);
  Key   := FullIdKey(AInv.FolioNum, 1);

//  Key := FullCustCode(AInv.CustCode);
//  BaseKey := Key;
  with MTExLocal^ do
  begin
    LStatus := LFind_Rec(B_GetGEq, IdetailF, IdFolioK, Key);
    while (LStatusOk) and (Checkkey(BaseKey, Key, Length(BaseKey), BOn)) do
    begin
      if (LId.FolioRef <> 0) and (LId.LineNo > 0) and (LId.VATCode in [VATECDCode, '4']) then
      begin
        LineTotal := DetLTotal(LId, BOn, BOff, 0.0) * DocNotCnst;
        // Free-of-charge items should be reported at total Cost Price.
        if (LineTotal = 0) then
          LineTotal := (LId.CostPrice * LId.Qty) * LineCnst(LID.Payment) * DocNotCnst;
        if (LineTotal <> 0) then
        begin
          if (not (LInv.InvDocHed In QuotesSet+RecieptSet+PSOPSet)) and
             (LInv.RunNo>=0) then
          begin
            LineTotal := ServiceProRata(LineTotal);
            if (LineTotal <> 0.0) then
            begin
              Result := True;
              if (LInv.SSDProcess = 'T') then
                CustTotals.TriangulatedServices := CustTotals.TriangulatedServices + LineTotal
              else
                CustTotals.Services := CustTotals.Services + LineTotal;
            end;
          end;
        end;
      end;
      LStatus := LFind_Rec(B_GetNext, IdetailF, IdFolioK, Key);
    end;
  end;
end;


procedure TECSalesDetailedReport_MSSQL.RepPrint(Sender: TObject);
Const
  QryField = 'DOC.thOurRef, DOC.thYourRef, DOC.thTransDate, DOC.thPeriod, DOC.thYear, DOC.thAcCode, '+
             'DOC.thCurrency, DOC.thOriginalCompanyRate, DOC.thOriginalDailyRate, DOC.thUseOriginalRates, ' +
             'DET.tlECService, DOC.thProcess, DET.tlQty, CS.acVATRegNo, DOC.thDocType, ' +
             'DET.tlDiscFlag, DET.tlDiscount';
  QryNetField = 'SUM(CASE WHEN DET.tlNetValue = 0 then ' +
                '(DET.tlCost * DET.tlQty * CASE ' +
                'WHEN DET.tlPaymentCode = ''N'' THEN -1 ' +
                'ELSE 1 ' +
                'END * -1) ' +
                'WHEN (DET.tlDiscount <> 0) THEN ' +
					      '((DET.tlNetValue * DET.tlQty) - CASE ' +
					      'WHEN DET.tlDiscFlag = ''%'' THEN (DET.tlNetValue * DET.tlQty * DET.tlDiscount) ' +
					      'ELSE (DET.tlQty * DET.tlDiscount) ' +
					      'END) ' +
	              'ELSE (DET.tlNetValue * DET.tlQty) ' +
	              'END) as NetVal';

var
  sqlCaller: TSQLCaller;
  sQuery, sQueryResult: String;
  CompanyCode, ConnectionString, lPassword: WideString;
  //-----------------------------------

  function GetJoinClause: String;
  begin
    Result := 'LEFT JOIN [COMPANY].DETAILS DET ON DOC.thFolioNum = DET.tlFolioNum ' +
              'LEFT JOIN [COMPANY].CUSTSUPP CS ON DOC.thAcCode = CS.acCode ';
  end;

  //-----------------------------------

  function GetWhereClause: String;
  var
    lECServiceFilterString: String;
    lECServiceValue: string;
  begin
    lECServiceValue := '';
    if (IncludeGoods) then
      lECServiceValue := '0';
    if (IncludeServices ) then
    begin
      if lECServiceValue <> '' then
        lECServiceValue := lECServiceValue + ',1'
      else
        lECServiceValue := '1'
    end;

    if lECServiceValue <> '' then
      lECServiceFilterString := 'And (DET.tlECService in ('+lECServiceValue +'))';

    Result := 'WHERE (DOC.thProcess In ('' '',''T'')) AND (DET.tlVATCode In (''4'', ''D'')) AND ' +
                    '(CS.acECMember = 1) AND (CS.acCustSupp = ''C'') ' +
                    lECServiceFilterString;
  end;

  //-----------------------------------

  function GetOrderByClause: String;
  begin
    Result := 'ORDER BY CS.acVATRegNo, DOC.thOurRef';
  end;

  //-----------------------------------

begin
  sqlCaller := TSQLCaller.Create;
  try
    sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
    CompanyCode := GetCompanyCode(SetDrive);
    //GetConnectionString(CompanyCode, False, ConnectionString);
    GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);
    sqlCaller.ConnectionString := ConnectionString;
    sqlCaller.Connection.Password := lPassword;
    sQuery := 'SELECT '+ QryField + ', ' + QryNetField  + ' FROM [COMPANY].DOCUMENT DOC ' +
              GetJoinClause + ' ' +
              GetWhereClause + ' ' +
              'GROUP BY ' + QryField  + ' ' +
              GetOrderByClause;

    ShowStatus(2, 'Retrieving Data, Please Wait...');
    ShowStatus(3, 'This can take several minutes');
    sqlCaller.Select(sQuery, CompanyCode);
    FoReportLogger.StartQuery(sQuery);
    FoReportLogger.FinishQuery;
    ShowStatus(2,'Processing Report.');
    ShowStatus(3,'');

    LastAcCode := '';
    PrintingAcCode := '';
    PrintingAcVATRegNo := '';
    if (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
    begin
      // Set MaxProgress Value of Progress Bar range
      FMaxProgress := sqlCaller.Records.RecordCount + 2;
      // Initialise the Progress Bar range
      InitProgress(FMaxProgress);
      if Assigned(ThreadRec) then
        RepAbort := ThreadRec^.THAbort;

      with sqlCaller.Records do
      begin
        DisableControls;
        try
          First;
          while (not Eof) and ChkRepAbort do
          begin
            if ValidRecord(FieldByName('thOurRef').AsString) then
            begin
              if (PrintingAcCode <> FieldByName('thAcCode').AsString) then
              begin
                PrintAccountTotals;
                CustFirstTransVal := 0;
                FServicesAmountTotal := 0;
                FGoodsAmountTotal := 0;
                PrintingAcCode := FieldByName('thAcCode').AsString;
                PrintingAcVATRegNo := FieldByName('acVATRegNo').AsString;
                PrintAccountHeader(False);
              end;
              if Assigned(ThreadRec) then
                RepAbort := ThreadRec^.THAbort;

              // Pass to common ancestor for printing transaction line
              PrintTransactionLine(sqlCaller.Records);
            end;
            Next;
          end;
        finally
          EnableControls;
        end;
      end
    end
    else if (sqlCaller.ErrorMsg <> '') then
      WriteSQLErrorMsg(sqlCaller.ErrorMsg)
  finally
    sqlCaller.Close;
    FreeAndNil(sqlCaller);
  end;
  PrintAccountTotals;
  FoReportLogger.FinishReport;
end;

//------------------------------------------------------------------------------

function TECSalesDetailedReport_MSSQL.SQLLoggingArea: String;
begin
  Result := 'ECSalesDetailedReport';
end;

//------------------------------------------------------------------------------

function TECSalesDetailedReport_MSSQL.ValidRecord(
  AOurRef: String): Boolean;
var
  lOurRef: Str255;
  LStatus: Integer;
  TmpInc: Boolean;
begin
  Result := False;
  with RepFiler1, ReportParameters^ do
  begin
    lOurRef :=  AOurRef;
    LStatus := Find_Rec(B_GetGEq, F[InvF],InvF,RecPtr[InvF]^,InvOurRefK, lOurRef);
    if LStatus = 0 then
      Result := IncludeECInv(Inv, VATStartD, VATEndD);
  end;
end;

procedure TECSalesDetailedReport_MSSQL.WriteSQLErrorMsg(
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
{ TECSalesDetailedReport_Pervasive }
//------------------------------------------------------------------------------

constructor TECSalesDetailedReport_Pervasive.Create(
  AOwner: TObject);
begin
  inherited Create(AOwner);
  RepKey := '';
end;

//------------------------------------------------------------------------------

procedure TECSalesDetailedReport_Pervasive.PrintTransaction(
  const AInv: InvRec; ANetValue: Double; AServicesInd: string);
var
  lIndicator: String;
  UOR: Byte;
  NewVal: Double;
begin
  with AInv do
  begin
    ThrowNewPage(5);

    // Overwrite Account details portion of line with drill-down box for Account
    SendRepDrillDown(1, TotTabs, 1,  OurRef, InvF, InvOurRefK, 0);

    SendLine( #9 + OurRef +
              #9 + YourRef +
              #9 + POutDateB(TransDate) +
              #9 + PPR_OutPr(AcPr,AcYr) +
              #9 + CustCode +
              #9 + FormatFloat(GenRealMask, ANetValue) +  // Net
              #9 + AServicesInd);
  end;
  // Update the line count and progress - ignore total lines
  ICount := ICount + 1;
  if Assigned(ThreadRec) then
    UpDateProgress(2 + ICount);
end;

procedure TECSalesDetailedReport_Pervasive.PrintTransactionLine(
  const AInv: InvRec);
var
  lIndicator: String;
begin
  if IncludeGoods and CalcGoodsTotals(AInv) then
  begin
    if (AInv.SSDProcess = 'T') then
    begin
      lIndicator := '2';
      PrintTransaction(AInv, CustTotals.TriangulatedGoods, lIndicator);
      FGoodsAmountTotal := FGoodsAmountTotal +  CustTotals.TriangulatedGoods;
    end
    else
    begin
      lIndicator := '';
      PrintTransaction(AInv, CustTotals.Goods, lIndicator);
      FGoodsAmountTotal := FGoodsAmountTotal +  CustTotals.Goods;
    end;
    if (CustFirstTransVal = 0) then
      CustFirstTransVal := FGoodsAmountTotal;
  end;
  if IncludeServices and CalcServiceTotals(AInv) then
  begin
    if (AInv.SSDProcess = 'T') then
    begin
      lIndicator := '2';
      PrintTransaction(AInv, CustTotals.TriangulatedServices, lIndicator);
      FServicesAmountTotal := FServicesAmountTotal +  CustTotals.TriangulatedServices;
    end
    else
    begin
      lIndicator := '3';
      PrintTransaction(AInv, CustTotals.Services, lIndicator);
      FServicesAmountTotal := FServicesAmountTotal +  CustTotals.Services;
    end;
    if (CustFirstTransVal = 0) then
      CustFirstTransVal := FServicesAmountTotal;
  end;
end;

procedure TECSalesDetailedReport_Pervasive.RepPrint(Sender: TObject);
var
  TmpInclude:  Boolean;
  RepKey1: Str255;
begin
  // Run through the transactions in the Documents
  ShowStatus(2,'Processing Report.');

  RepKey1 := Tradecode[BOn];

  with MTExLocal^, RepFiler1, ReportParameters^ do
  begin
    LStatus := LFind_Rec(B_GetFirst, CustF, CustCntyK, RepKey1);

    while (LStatusOk) and (ChkRepAbort) do
    begin
      TmpInclude := ((LCust.EECMember) and (IsACust(LCust.CustSupp)));

      if (TmpInclude)  then
      begin
        PrintingAcCode := LCust.CustCode;
        PrintingAcVATRegNo := LCust.VATRegNo;
        PrintAccountTotals;
        CustFirstTransVal := 0;
        FServicesAmountTotal := 0;
        FGoodsAmountTotal := 0;
        NewCust := True;
        LStatus := LFind_Rec(B_GetFirst, InvF, InvFolioK, RepKey);
        while (LStatus = 0) and (ChkRepAbort) do
        begin
          TmpInclude := IncludeECInv(LInv, ReportParameters.VATStartD, ReportParameters.VATEndD);
          if (TmpInclude) then
          begin
            CustTotals.Goods := 0.00;
            CustTotals.Services := 0.00;
            CustTotals.TriangulatedGoods := 0.00;
            CustTotals.TriangulatedServices := 0.00;

            if (LCust.CustCode = LInv.CustCode) then
              PrintTransactionLine(LInv);    
          end; 

          if Assigned(ThreadRec) then
            RepAbort:=ThreadRec^.THAbort;

          LStatus := LFind_Rec(B_GetNext, InvF, InvFolioK, RepKey);
        end;
      end;
      LStatus := LFind_Rec(B_GetNext, CustF, CustCntyK, RepKey1);
    end;
  end;
  PrintAccountTotals;
end;

//------------------------------------------------------------------------------
procedure TECSalesDetailedReport.PrintAccountHeader (Const Continuation : Boolean);
const
  lSpace = '     ';
var
  sSubTitle : ShortString;
begin // PrintAccountHeader
  // Only print sub-title on page change if account code not changed
  if (Not Continuation) Or (Continuation And (LastAcCode = PrintingAcCode)) then
  begin
    LastAcCode := PrintingAcCode;

    with RepFiler1 Do
    begin
      DefFont(0,[fsBold]);

      // Code + Company
      sSubTitle := Trim(PrintingAcVATRegNo) + lSpace + PrintingAcCode;

      if Continuation then
        sSubTitle := sSubTitle + ' (continued...)';

      // Set print preview drill-down information
      SendRepSubHedDrillDown (MarginLeft, PageWidth + MarginLeft, 1, PrintingAcCode, CustF, CustCodeK,0);

      Self.PrintLeft(sSubTitle,MarginLeft);
      Self.CrLF;
      DefLine(-1,1,85,-0.3);
      DefFont(0,[]);
    end; // with RepFiler1
  end; // if (LastAcCode <> CurrentAcCode)
end; // PrintAccountHeader

//------------------------------------------------------------------------------

procedure TECSalesDetailedReport.RepPrintHeader(Sender: TObject);
begin
  Inherited;
  if (RepFiler1.CurrentPage > 1)  then
    PrintAccountHeader (True);
end;
       
//------------------------------------------------------------------------------
procedure TECSalesDetailedReport.PrintAccountTotals;
var
  sSubTotals : ShortString;
  Totals: TECSalesDetailedTotals;
  lTotal: Double;
begin // PrintAccountTotals
  lTotal := FServicesAmountTotal + FGoodsAmountTotal;
  with RepFiler1 do
  if CustFirstTransVal <> 0 then
  begin
    DefFont(0,[fsBold]);
    DefLine(-1.3,1,PageWidth-MarginRight-1,-0.5);

    sSubTotals := #9 + 'Total Bal:' +
                #9 + #9 + #9 + #9  +
                #9 + FormatBFloat(GenRealMask, lTotal, BOff);
    SendLine(sSubTotals);

    Self.CRLF;
  end; // with RepFiler1
end; // PrintAccountTotals


end.
