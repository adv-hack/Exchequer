unit Reports;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , RPFiler, RPDefine, RPBase, RPCanvas, RPFPrint, APIUtil, VarConst
  , RPDevice, GlobVar, BtrvU2, FileUtil, ComCtrls, EntRend, SComProc
  , StdCtrls, StrUtil, Prntdlg, MiscUtil, MathUtil, Math, Inifiles, DateUtils
  , Enterprise01_TLB, BTUtil;

type
  ENoUnique = class(Exception);

  TCustomerInfo = class
    Description : string[45];
  end;

  TSalesCodeInfo = class
    Details : TSalesCodeRec;
  end;

  TCommissionInfo = Class
    SalesCode : string[10];
    CustCode : string[6];
    ProdCode : string[16];
    ProductDesc : string[35];
    QtySold : real;
    LineTotal : real;
    CommissionRate : string[8];
    Commission : real;
    CommissionBasis : string[6];
  end;

  TReportCriteria = Class
    slCustomers : TStringList;
    slTXTypes : TStringList;
    slSalesCodes : TStringList;
    slSalesCodeTypes : TStringList;
    slProducts : TStringList;
    slProdGroups : TStringList;
    dDateFrom : TDate;
    dDateTo : TDate;
    bFilterByCustAccType : boolean;
    bPickSalesCodes : boolean;
    sIncludeCustAccType : string;
    bOnlyIncludePaidOffTXs : boolean;
    bFilterByTXCurrency : boolean;
    iTXCurrencyFilter : integer;
    iConvertCurrency : integer;
    bGeneratePJI : boolean;
    bCostAllocLineCost : boolean;
    constructor create;
    destructor destroy;
  public
    procedure FillAllListObjects;
  end;

  TModReports = class(TForm)
    FilePrinter1: TFilePrinter;
    TheReport: TReportFiler;
    procedure SalesCodeDetailsNewPage(Sender: TObject);
    procedure SalesCommissionNewPage(Sender: TObject);
    procedure PortraitBeforePrint(Sender: TObject);
    procedure LandscapeBeforePrint(Sender: TObject);
    procedure SalesCodeDetailsPrint(Sender: TObject);
    procedure SalesCommissionPrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    PrnInfo : TSBSPrintSetupInfo;
    LSalesCodeRec : TSalesCodeRec;
    procedure SetHeader(sReportTitle, sColHeads : string; sSubTitle : string = ''; sDateRange : string = '');
    function RunReport : boolean;
    function PrintHeader : boolean;
    function PagedFormat : boolean;
  public
    bConsolidate, bGotPrnInfo : boolean;
    sLogFilename : string;
    ReportCriteria : TReportCriteria;
    procedure PrintSalesCodeDetails(SalesCodeRec : TSalesCodeRec);
    procedure PrintSalesCommission;
  end;

var
  ModReports: TModReports;

implementation

uses
  Progress, ShellAPI, prntprev, MainF, RepUtil, Admin;

{$R *.DFM}

{TModReports}

procedure TModReports.SetHeader(sReportTitle, sColHeads : string; sSubTitle : string = ''; sDateRange : string = '');
begin
  SetStandardHeader(TheReport, 'Sales Commission Plug-In', sReportTitle, sColHeads, PagedFormat, sSubTitle, sDateRange);
end;
procedure TModReports.PrintSalesCodeDetails(SalesCodeRec : TSalesCodeRec);
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := SalesCodeDetailsNewPage;
    OnPrint := SalesCodeDetailsPrint;
    Title := 'Sales Code Details';
  end;{with}

  LSalesCodeRec := SalesCodeRec;

  RunReport;
end;

procedure TModReports.PrintSalesCommission;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;

    OnNewPage := SalesCommissionNewPage;
    OnPrint := SalesCommissionPrint;
    Title := 'Sales Commission Report';
  end;{with}
  RunReport;
end;

function TModReports.RunReport : boolean;
var
  BaseDir, RepFName : string;
  FVar : integer;
  bContinue : boolean;
  oRender : TEntRender;
begin
  Screen.Cursor := crHourglass;
  bContinue := bConsolidate;
  if (not bConsolidate) or  (bConsolidate and (not bGotPrnInfo)) then begin
    PrnInfo := RpDev.SBSSetupInfo;
    bContinue := SelectPrinter(PrnInfo);
    bGotPrnInfo := bContinue;
  end;{if}

  if bContinue then begin
    { Generate Unique Filename for report file }
    FVar := 0;
    BaseDir := ExtractFilePath(application.ExeName);
    Repeat
      RepFName := BaseDir + '!REP' + IntToStr(FVar) + '.SWP';
      Inc (FVar);
    Until (Not FileExists (RepFName)) Or (FVar > 9999);
    If (FVar > 9999) Then Raise ENoUnique.Create('Cannot Find Unique Filename');

    RpDev.SetPrnSetup(PrnInfo);

    with TheReport do begin
      FileName := RepFName;
      PrinterIndex := RpDev.DeviceIndex;
      Copies := PrnInfo.NoCopies;
      Execute;

      if PrnInfo.fePrintMethod in [5,6] then begin
        oRender := TEntRender.Create;
        with oRender do begin
          case PrnInfo.fePrintMethod of
            5 : RenderTo := rtExcel;
            6 : RenderTo := rtText;
          end;{case}
          sFilename := PrnInfo.feXMLFileDir;
          sRepTempFilename := RepFName;
          EntRender;

          if PrnInfo.feMiscOptions[1] then
          begin
              // open default program
              ShellExecute(Application.MainForm.Handle,       // Parent Window
                           'open',                            // Operation
                           PChar(sFilename),                    // FileName
                           '',                                // Params
                           PChar(ExtractFilePath(sFilename)),   // Default Dir
                           SW_SHOWNORMAL);                    // Show
          end else begin
            // show message
            MsgBox('Your export file has been created as : ' + sFilename
            , mtInformation,[mbOK],mbOK,'File Export');
          end;{if}

          Free;
        end;{with}
      end;{if}

    end;{with}

    if not (PrnInfo.fePrintMethod in [5,6]) then begin
      if PrnInfo.Preview then
        begin
          FrmPrintPreview := TFrmPrintPreview.Create(Self);
          FrmPrintPreview.Caption := TheReport.Title + ' Preview';
          FrmPrintPreview.FilePreview1.FileName := RepFName;
          FrmPrintPreview.FilePrinter1.FileName := RepFName;
          FrmPrintPreview.FilePreview1.PrinterIndex := RpDev.DeviceIndex;
          FrmPrintPreview.FilePrinter1.PrinterIndex := RpDev.DeviceIndex;
          Screen.Cursor := crDefault;
//          FrmPrintPreview.btnProcess.Tag := iCategory;
          FrmPrintPreview.StartPreview;
        end
      else begin
        FilePrinter1.PrinterIndex := RpDev.DeviceIndex;
        FilePrinter1.FileName := RepFName;
        FilePrinter1.Execute;
        Screen.Cursor := crDefault;
      end;{if}
    end;{if}
    if not PrnInfo.Preview then DeletePrintFile(RepFName);
  end;{if}
  Screen.Cursor := crDefault;
  Result := bContinue;
end;

procedure TModReports.SalesCodeDetailsNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 45, pjLeft, 35, 4, 0, 0);
      SetTab(NA, pjLeft, 45, 4, 0, 0);
      SetHeader('Sales Code Details', '');
    end;{with}
    SetRepFont(TheReport,fnMainText, 8);
  end;{if}
end;

procedure TModReports.LandscapeBeforePrint(Sender: TObject);
begin
  SetDefaultMargins(TheReport, poLandscape);
end;

procedure TModReports.PortraitBeforePrint(Sender: TObject);
begin
  SetDefaultMargins(TheReport, poPortrait);
end;

procedure TModReports.SalesCodeDetailsPrint(Sender: TObject);
var
  KeyS : str255;
  CommissionRec : TCommissionRec;
  iStatus : integer;
  sField : string;
Begin{SalesCodeDetailsPrint}
  with LSalesCodeRec, TheReport do begin
    CRLF;
    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Sales Code : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    PrintLn(Trim(scSalesCode));

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Description : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    PrintLn(Trim(scDescription));

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Active : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    PrintLn(BoolToStr(scStatus = 1));

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Sales Code Type : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    PrintLn(Trim(FrmAdmin.cmbSCType.Text));

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Default Commission Basis : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    case scDefCommissionBasis of
      0 : PrintLn('Total Value');
      1 : PrintLn('Margin');
    end;{case}

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Default Commission : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    case scDefCommissionType of
      0 : PrintLn(FloatToStrF(scDefCommission, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals) + ' %');
      1 : PrintLn('£ ' + FloatToStrF(scDefCommission, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals));
    end;{case}

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Supplier Account Code : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    if LSalesCodeRec.scEntSupplierCode <> ''
    then Print(Trim(LSalesCodeRec.scEntSupplierCode) + #9 + Trim(FrmAdmin.lSupplierName.Caption));
    CRLF;

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('GL Code : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    if LSalesCodeRec.scEntGLCode <> 0
    then Print(IntToStr(LSalesCodeRec.scEntGLCode) + #9 + Trim(FrmAdmin.lGLName.Caption));
    CRLF;

    if oToolkit.SystemSetup.ssUseCCDept then begin
      SetRepFont(TheReport,fnSubTotal, 8);
      Print('Cost Centre : '#9);
      SetRepFont(TheReport,fnMainText, 8);
      if LSalesCodeRec.scEntCostCentre <> ''
      then Print(Trim(LSalesCodeRec.scEntCostCentre) + #9 + Trim(FrmAdmin.lCCName.Caption));
      CRLF;

      SetRepFont(TheReport,fnSubTotal, 8);
      Print('Department : '#9);
      SetRepFont(TheReport,fnMainText, 8);
      if LSalesCodeRec.scEntDepartment <> ''
      then Print(Trim(LSalesCodeRec.scEntDepartment) + #9 + Trim(FrmAdmin.lDepartmentName.Caption));
      CRLF;
    end;{if}

    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Currency : '#9);
    SetRepFont(TheReport,fnMainText, 8);
    PrintLn(FrmAdmin.cmbCurrency.Text);

    CRLF;
    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Commission : '#9);

    // Print Commission Header
    ClearTabs;
    SetTab(MarginLeft + 20, pjLeft, 40, 4, 0, 0);
    SetTab(NA, pjRight, 20, 4, 0, 0);
    SetTab(NA, pjRight, 20, 4, 0, 0);
    SetTab(NA, pjLeft, 15, 10, 0, 0);
    SetTab(NA, pjRight, 18, 4, 0, 0);
    SetTab(NA, pjRight, 18, 4, 0, 0);
    SetTab(NA, pjLeft, 20, 10, 0, 0);
    SetTab(NA, pjLeft, 20, 4, 0, 0);

    SetRepFont(TheReport, fnColHeader, 8);
    CRLF;
    CRLF;
    Print('Cust Code'#9'Product/Group'#9'Commission'#9'Currency'#9'Basis'#9'Qty From'#9'Qty To'#9'Start'#9'End');
    DrawLineUnder(TheReport);

    // Print Commission Records
    SetRepFont(TheReport,fnMainText, 8);

    // get first commission record that matches
    FillChar(KeyS,SizeOf(KeyS),#0);
    KeyS := BTFullNomKey(LSalesCodeRec.scFolioNo);
    iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
    while (iStatus = 0) and (LSalesCodeRec.scFolioNo = CommissionRec.cmSalesCodeFolioNo) do begin

      //found a commission record that matches
      with CommissionRec do begin

        // Customer Code
        Print(cmCustCode);

        // Product / Group
        case TcommissionType(cmBy) of
          ctCustomer : sField := '';
          ctCustomerProduct : sField := cmProductCode;
          ctCustomerPGroup : sField := cmPGroupCode;
          ctProduct : sField := cmProductCode;
          ctPGroup : sField := cmPGroupCode;
        end;{case}
        Print(#9 + sField);

        // Commission
        case cmCommissionType of
          0 : sField := FloatToStrF(cmCommission, ffFixed, 15
          , oToolkit.SystemSetup.ssSalesDecimals) + ' %';
          1 : sField := FloatToStrF(cmCommission, ffFixed, 15
          , oToolkit.SystemSetup.ssSalesDecimals);
        end;{case}
        Print(#9 + sField);

        // Currency
        if cmByCurrency then sField := IntToStr(cmCurrency)
        else sField := '';
        Print(#9 + sField);

        // Basis
        case cmCommissionBasis of
          0 : sField := 'Value';
          1 : sField := 'Margin';
        end;{case}
        Print(#9 + sField);

        // Qty From
        if cmByQty then sField := FloatToStrF(cmQtyFrom, ffFixed, 15, oToolkit.SystemSetup.ssQtyDecimals)
        else sField := '';
        Print(#9 + sField);

        // Qty To
        if cmByQty then sField := FloatToStrF(cmQtyTo, ffFixed, 15, oToolkit.SystemSetup.ssQtyDecimals)
        else sField := '';
        Print(#9 + sField);

        // Start Date
        if cmByDate then sField := Str8ToScreenDate(cmStartDate)
        else sField :=  '';
        Print(#9 + sField);

        // End Date
        if cmByDate then sField := Str8ToScreenDate(cmEndDate)
        else sField := '';
        Print(#9 + sField);

      end;{with}

      EndOfPageLine(TheReport, PagedFormat);

      // Get Next Record
      iStatus := Find_Rec(B_GetNext, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
    end;{while}
  end;{with}
end;{SalesCodeDetailsPrint}

function TModReports.PrintHeader : boolean;
begin
  Result := PagedFormat or (TheReport.CurrentPage = 1)
end;

function TModReports.PagedFormat : boolean;
begin
  Result := not (PrnInfo.fePrintMethod in [5,6]);
end;

procedure TModReports.FormCreate(Sender: TObject);
begin
  bConsolidate := FALSE;
end;

{ TReportCriteria }

constructor TReportCriteria.create;
begin
  slCustomers := TStringList.create;
//  slCustomers.Sorted := TRUE;
  slCustomers.Duplicates := dupIgnore;

  slTXTypes := TStringList.create;
  slTXTypes.Sorted := TRUE;
  slTXTypes.Duplicates := dupIgnore;

  slSalesCodes := TStringList.create;
//  slSalesCodes.Sorted := TRUE;
  slSalesCodes.Duplicates := dupIgnore;

  slSalesCodeTypes := TStringList.create;
//  slSalesCodeTypes.Sorted := TRUE;
  slSalesCodeTypes.Duplicates := dupIgnore;

  slProducts := TStringList.create;
//  slProducts.Sorted := TRUE;
  slProducts.Duplicates := dupIgnore;

  slProdGroups := TStringList.create;
//  slProdGroups.Sorted := TRUE;
  slProdGroups.Duplicates := dupIgnore;
end;

destructor TReportCriteria.destroy;
begin
  ClearList(slCustomers);
  slCustomers.Free;

  ClearList(slTXTypes);
  slTXTypes.Free;

  ClearList(slSalesCodes);
  slSalesCodes.Free;

  ClearList(slSalesCodeTypes);
  slSalesCodeTypes.Free;

  ClearList(slProducts);
  slProducts.Free;

  ClearList(slProdGroups);
  slProdGroups.Free;
end;

procedure TModReports.SalesCommissionNewPage(Sender: TObject);
var
  sColHead : string;

  procedure SetCommHeader;

    function GetStringFromList(slStringList : TStringList) : string;
    var
      iPos : integer;
    begin{GetStringFromList}
      Result := '';
      for iPos := 0 to slStringList.count - 1 do begin
        Result := Result + slStringList[iPos];
        if iPos <> slStringList.count - 1 then Result := Result + ', ';
      end;{for}
    end;{GetStringFromList}

    procedure PrintCriteria(sTitle, sValue : string);
    begin{PrintCriteria}
      SetRepFont(TheReport, fnSubTotal, 8);
      TheReport.Print(sTitle);
      SetRepFont(TheReport, fnSubSubTitle, 8);
      TheReport.PrintLn(#9 + sValue);
    end;{PrintCriteria}

  begin{SetCommHeader}
    with TheReport do begin
      Home;

      // Print Main Title
      SetRepFont(TheReport, fnTitle, 8);
      PrintLeft('Sales Commission Report',MarginLeft);

      // Print Date / Time "Printed On"
      SetRepFont(TheReport, fnSubSubTitle, 8);
      if PagedFormat then PrintRight('Printed on : ' + DateToStr(Now) + ' - ' + TimeToStr(Now),PageWidth - MarginRight)
      else PrintLeft('Printed on : ' + DateToStr(Now) + ' - ' + TimeToStr(Now), MarginLeft);

      CRLF;

      if PagedFormat then PrintRight('Page : ' + Macro(MidCurrentPage) + ' of ' + Macro(MidTotalPages), PageWidth - MarginRight);
      CRLF;

      PrintCriteria('Company : ', Trim(CompanyRec.Name));

      PrintCriteria('Range : ', Str8ToScreenDate(DateToStr8(ReportCriteria.dDateFrom)) + ' - '
      + Str8ToScreenDate(DateToStr8(ReportCriteria.dDateTo)));

      PrintCriteria('Customers : ', GetStringFromList(ReportCriteria.slCustomers));
      PrintCriteria('Trans. Types : ', GetStringFromList(ReportCriteria.slTXTypes));

      if ReportCriteria.slProducts.Count > 0
      then PrintCriteria('Products : ', GetStringFromList(ReportCriteria.slProducts))
      else PrintCriteria('Product Groups : ', GetStringFromList(ReportCriteria.slProdGroups));

      if ReportCriteria.bPickSalesCodes
      then PrintCriteria('Sales Codes : ', GetStringFromList(ReportCriteria.slSalesCodes))
      else PrintCriteria('Sales Code Types : ', GetStringFromList(ReportCriteria.slSalesCodeTypes));

      // print headers
      if sColHead <> '' then begin
        SetRepFont(TheReport, fnColHeader, 8);
        CRLF;
        Print(sColHead);
      end;{if}

      DrawLineUnder(TheReport);
    end;{with}
  end;{SetCommHeader}

begin{SalesCommissionNewPage}
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 21, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 45, 4, 0, 0);  // Product Code
      SetTab(NA, pjLeft, 10, 4, 0, 0);  // Basis
      SetTab(NA, pjRight, 15, 4, 0, 0); // Qty
      SetTab(NA, pjRight, 20, 4, 0, 0); // Line Total
      SetTab(NA, pjRight, 20, 4, 0, 0);  // Rate
      SetTab(NA, pjRight, 20, 4, 0, 0); // Commission

      sColHead := 'Sales Code'#9'Customer'#9'Product Code'#9'Basis'#9'Qty Sold'#9'Line Total'#9'Rate'#9'Commission';
      SetCommHeader;
    end;{with}
    SetRepFont(TheReport,fnMainText, 8);
  end;{if}
end;

procedure TModReports.SalesCommissionPrint(Sender: TObject);
type
  TTotals = record
    totCommission : real;
    totSales : real;
    totDescription : string;
  end;

var
  PJI : ITransaction;
  SalesCodeRec : TSalesCodeRec;
  iResult, iPos, iFound, iStatus : integer;
  bAdd : boolean;
  slReport : TStringList;
  SalesCodeTotals : TTotals;
  sPrevSalesCode : string;
  frmProgress : TfrmProgress;

  procedure CheckLines;
  var
    iLine : integer;

    procedure AddCommission;
    var
      iStatus : integer;
      CommissionRec : TCommissionRec;
      MatchKeyS, KeyS : str255;

      procedure FillKeys;
      begin{FillKeys}
        MatchKeyS := PadString(psRight, CommissionRec.cmCustCode, ' ', SizeOf(CommissionRec.cmCustCode) -1)
        + PadString(psRight, CommissionRec.cmProductCode, ' ', SizeOf(CommissionRec.cmProductCode) -1)
        + PadString(psRight, CommissionRec.cmPGroupCode, ' ', SizeOf(CommissionRec.cmPGroupCode) -1);
        KeyS := MatchKeyS;
      end;{FillKeys}

      function RecordMatches : boolean;
      begin{RecordMatches}
        Result := MatchKeyS = PadString(psRight, CommissionRec.cmCustCode, ' ', SizeOf(CommissionRec.cmCustCode) -1)
        + PadString(psRight, CommissionRec.cmProductCode, ' ', SizeOf(CommissionRec.cmProductCode) -1)
        + PadString(psRight, CommissionRec.cmPGroupCode, ' ', SizeOf(CommissionRec.cmPGroupCode) -1);
      end;{RecordMatches}


      procedure GetCommissionRecords;
      var
        SalesCodeRec : TSalesCodeRec;

        procedure ProcessCommission(ACommissionRec : TCommissionRec);
        var
          sKey : string;
          CommissionInfo : TCommissionInfo;
          rCommTotal : real;

          function TXType : integer;
          begin{TXType}
            case oToolkit.transaction.thDocType of
             dtSIN, dtSJI, dtSRI, dtSQU, dtSOR, dtSDN : Result := 1;
             dtSRF, dtSJC, dtSCR : Result := -1;
            end;{case}
          end;{TXType}

        begin{ProcessCommission}

          sKey := PadString(psRight,SalesCodeRec.scSalesCode,' ',10)
          + PadString(psRight,oToolkit.transaction.thAcCode,' ', 6)
          + oToolkit.transaction.thTransDate;

          CommissionInfo := TCommissionInfo.Create;
          with CommissionInfo do begin
            SalesCode := SalesCodeRec.scSalesCode;
            CustCode := oToolkit.transaction.thAcCode;
            ProdCode := oToolkit.transaction.thLines[iLine].tlStockCode;
            ProductDesc := oToolkit.transaction.thLines[iLine].tlStockCodeI.stDesc[1];
            QtySold := oToolkit.transaction.thLines[iLine].tlQty;
            LineTotal := oToolkit.transaction.thLines[iLine].entLineTotal(TRUE
            , oToolkit.transaction.thSettleDiscPerc);

            case ACommissionRec.cmCommissionBasis of
              0 : begin
                CommissionBasis := 'Value';
                rCommTotal := LineTotal * TXType;
              end;

              1 : begin
                with oToolkit.transaction.thLines[iLine] as ITransactionLine2 do begin
                  CommissionBasis := 'Margin';
//                  if ReportCriteria.bCostAllocLineCost then rCommTotal := ((LineTotal - tlCost + tlCostApport) * tlQty) * TXType
//                  else rCommTotal := ((LineTotal - tlCost) * tlQty) * TXType;
                  if ReportCriteria.bCostAllocLineCost
                  then rCommTotal := (LineTotal - ((tlCost + tlCostApport) * tlQty)) * TXType
                  else rCommTotal := (LineTotal - (tlCost * tlQty)) * TXType;
                end;{with}
              end;
            end;{case}


            case ACommissionRec.cmCommissionType of
              0 : begin
                CommissionRate := FloatToStrF(ACommissionRec.cmCommission, ffFixed, 15
                , oToolkit.SystemSetup.ssSalesDecimals) + ' %';
                Commission := rCommTotal * (ACommissionRec.cmCommission / 100);
              end;

              1 : begin
                CommissionRate := '£ ' + FloatToStrF(ACommissionRec.cmCommission, ffFixed, 15
                , oToolkit.SystemSetup.ssSalesDecimals);
                Commission := ACommissionRec.cmCommission * QtySold;
              end;
            end;{case}

            if oToolkit.transaction.thLines[iLine].tlCurrency <> ReportCriteria.iConvertCurrency then
            begin
              Commission := oToolkit.Functions.entConvertAmount(Commission
              , oToolkit.transaction.thLines[iLine].tlCurrency, ReportCriteria.iConvertCurrency, 0);
              LineTotal := oToolkit.Functions.entConvertAmount(LineTotal
              , oToolkit.transaction.thLines[iLine].tlCurrency, ReportCriteria.iConvertCurrency, 0);
            end;{if}

          end;{with}

          slReport.AddObject(sKey, CommissionInfo)
        end;{ProcessCommission}

      var
        bProcess : boolean;
        SalesCodeTypeRec : TSalesCodeTypeRec;
        SalesCodeInfo : TSalesCodeInfo;
//        CustomerInfo : TCustomerInfo;

      begin{GetCommissionRecords}
        // get first commission record that matches
        iStatus := Find_Rec(B_GetEq, F[CommissionF], CommissionF, CommissionRec, cmReportIdx, KeyS);
        while (iStatus = 0) and RecordMatches do begin
          //found a commission record that matches

          bProcess := TRUE;

          // correct currency
          if CommissionRec.cmByCurrency then begin
            if oToolkit.transaction.thLines[iLine].tlCurrency <> CommissionRec.cmCurrency
            then bProcess := FALSE;
          end;{if}

          if bProcess then begin

            // correct date range
            if CommissionRec.cmByDate then begin
              if (oToolkit.transaction.thTransDate > CommissionRec.cmEndDate)
              or (oToolkit.transaction.thTransDate < CommissionRec.cmStartDate)
              then bProcess := FALSE;
            end;{if}

            if bProcess then begin

              // Correct Quantity Range
              if CommissionRec.cmByQty then begin
                if (oToolkit.transaction.thLines[iLine].tlQty > CommissionRec.cmQtyTo)
                or (oToolkit.transaction.thLines[iLine].tlQty < CommissionRec.cmQtyFrom)
                then bProcess := FALSE;
              end;{if}

              if bProcess then begin
                SalesCodeRec := GetSalesCodeFromFolio(CommissionRec.cmSalesCodeFolioNo);

                // sales code active ?
                if SalesCodeRec.scStatus = 0 then bProcess := FALSE
                else begin

                  // correct sale code / type ?
                  with ReportCriteria do begin
                    if bPickSalesCodes then
                    begin
                      iFound := slSalesCodes.IndexOf(Trim(SalesCodeRec.scSalesCode));
                      if iFound = -1 then bProcess := FALSE
                    end else
                    begin
//                      SalesCodeTypeRec := ;
                      iFound := slSalesCodeTypes.IndexOf(GetSalesCodeTypeFromFolio(SalesCodeRec.scSalesCodeType).sctDescription);
                      if iFound = -1 then bProcess := FALSE
                    end;

                    if bProcess then begin
                    // update sales code object attached to sales code string list
                      iFound := slSalesCodes.IndexOf(Trim(SalesCodeRec.scSalesCode));
                      if iFound = -1 then begin
                        slSalesCodes.Add(Trim(SalesCodeRec.scSalesCode));
                        iFound := slSalesCodes.IndexOf(Trim(SalesCodeRec.scSalesCode));
                      end;{if}
                      if slSalesCodes.Objects[iFound] = nil then
                      begin
                        SalesCodeInfo := TSalesCodeInfo.Create;
                        SalesCodeInfo.Details := SalesCodeRec;
                        slSalesCodes.Objects[iFound] := SalesCodeInfo;
                      end;{if}

                      // update customer object attached to customer string list
{                      iFound := slCustomers.IndexOf(Trim(oToolkit.Transaction.thAcCode));
                      if slCustomers.Objects[iFound] = nil then
                      begin
                        CustomerInfo := TCustomerInfo.Create;
                        CustomerInfo.Description := oToolkit.Transaction.thAcCodeI.acCompany;
                        slCustomers.Objects[iFound] := CustomerInfo;
                      end;{if}
                    end;{if}
                  end;{with}

                end;{if}
              end;{if}

            end;{if}
          end;{if}

          if bProcess then ProcessCommission(CommissionRec);
          iStatus := Find_Rec(B_GetNext, F[CommissionF], CommissionF, CommissionRec, cmReportIdx, KeyS);
        end;{while}
      end;{GetCommissionRecords}

      procedure AddCommissionForCustGroup(sCust, sPGroupCode : string);
      var
        iStatus : integer;
      begin{AddCommissionForCustGroup}

        FillChar(CommissionRec, SizeOf(CommissionRec),#0);
        CommissionRec.cmCustCode := sCust;
        CommissionRec.cmPGroupCode := sPGroupCode;
        FillKeys;
        GetCommissionRecords;

        oToolkit.Stock.Index := stIdxCode;
        iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sPGroupCode));
        if iStatus = 0 then begin
          if (Trim(oToolkit.Stock.stParentCode) <> '')
          then AddCommissionForCustGroup(sCust, Trim(oToolkit.Stock.stParentCode));
        end;{if}
      end;{AddCommissionForCustGroup}

    begin{AddCommission}
      with oToolkit, transaction, thLines[iLine], ReportCriteria do begin

        // fill key details for customer + product, and get Commission Records
        FillChar(CommissionRec, SizeOf(CommissionRec),#0);
        CommissionRec.cmCustCode := Trim(thAcCode);
        CommissionRec.cmProductCode := Trim(tlStockCode);
        FillKeys;
        GetCommissionRecords;

        // fill key details for customer + product group, and get Commission Records

        AddCommissionForCustGroup(Trim(thAcCode), tlStockCodeI.stParentCode);
        {FillChar(CommissionRec, SizeOf(CommissionRec),#0);
        CommissionRec.cmCustCode := thAcCode;
        CommissionRec.cmPGroupCode := tlStockCodeI.stParentCode;
        FillKeys;
        GetCommissionRecords;}

        // fill key details for customer and get Commission Records
        FillChar(CommissionRec, SizeOf(CommissionRec),#0);
        CommissionRec.cmCustCode := Trim(thAcCode);
        FillKeys;
        GetCommissionRecords;

        // fill key details for product, and get Commission Records
        FillChar(CommissionRec, SizeOf(CommissionRec),#0);
        CommissionRec.cmProductCode := Trim(tlStockCode);
        FillKeys;
        GetCommissionRecords;

        // fill key details for product group, and get Commission Records
        AddCommissionForCustGroup(StringOfChar(' ',SizeOf(CommissionRec.cmCustCode))
        , tlStockCodeI.stParentCode);
{        FillChar(CommissionRec, SizeOf(CommissionRec),#0);
        CommissionRec.cmPGroupCode := tlStockCodeI.stParentCode;
        FillKeys;
        GetCommissionRecords;}

      end;{with}
    end;{AddCommission}

    function IsProdGroupInGroups(sPGroupCode : string) : boolean;
    var
      iStatus : integer;
    begin{IsProdGroupInGroups}
      Result := ReportCriteria.slProdGroups.IndexOf(sPGroupCode) <> -1;
      if not Result then begin
        oToolkit.Stock.Index := stIdxCode;
        iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sPGroupCode));
        if iStatus = 0 then begin
          if (Trim(oToolkit.Stock.stParentCode) <> '')
          then Result := IsProdGroupInGroups(Trim(oToolkit.Stock.stParentCode));
        end;{if}
      end;{if}
    end;{IsProdGroupInGroups}

  begin{CheckLines}
    with oToolkit, transaction, ReportCriteria do begin
      for iLine := 1 to thLines.thLineCount do begin
        with thLines[iLine] do begin

          frmProgress.UpdateLine(3, 'Line : ' + IntToStr(iLine));
          application.ProcessMessages;

          if (oToolkit.transaction.thLines[iLine].tlStockCodeI <> nil) then
          begin

            bAdd := TRUE;

            // is it in the correct product / group
            if slProducts.Count > 0 then
            begin
              if slProducts.IndexOf(Trim(tlStockCode)) = -1 then bAdd := FALSE;
            end else
            begin
//              if slProdGroups.IndexOf(Trim(tlStockCodeI.stParentCode)) = -1 then bAdd := FALSE;
              bAdd := IsProdGroupInGroups(Trim(tlStockCodeI.stParentCode));
            end;{if}

            if bAdd then AddCommission;

          end;{if}
        end;{with}
      end;{for}
    end;{with}
  end;{CheckLines}

  procedure PrintTotals(var TheTotals : TTotals; sDescription : string);
  begin{PrintTotals}
    SetRepFont(TheReport, fnSubTotal, 8);
    TheReport.Print(#9#9 + sDescription + #9#9#9
    + FloatToStrF(TheTotals.totSales, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals) + #9#9
    + FloatToStrF(TheTotals.totCommission, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals));
    FillChar(TheTotals, SizeOf(TheTotals), #0);
    EndOfPageLine(TheReport, PagedFormat);
//    TheReport.CRLF;
    EndOfPageLine(TheReport, PagedFormat);
  end;{PrintTotals}

  procedure IncTotals(var TheTotals : TTotals);
  begin{PrintTotals}
    with TheTotals do begin
      totCommission := totCommission + (slReport.Objects[iPos] as TCommissionInfo).Commission;
      totSales := totSales + (slReport.Objects[iPos] as TCommissionInfo).LineTotal;
    end;{with}
  end;{PrintTotals}

  procedure PrintSalesCodeTotals;
  begin{PrintSalesCodeTotals}
    PrintTotals(SalesCodeTotals, 'Totals for ' + Trim(sPrevSalesCode));

    if ReportCriteria.bGeneratePJI and (Trim(SalesCodeRec.scEntSupplierCode) <> '') then
    begin
      iResult := PJI.Save(TRUE);

      if iResult <> 0 then MsgBox('ITransaction.Save Error : ' + IntToStr(iResult)
      , mtError, [mbOK], mbOK, 'ITransaction.Save Error');
//
//      if iResult <> 0 then MsgBox('ITransaction.Save Error : ' + IntToStr(iResult) + #13#13
//      + oToolkit.LastErrorString, mtError, [mbOK], mbOK, 'ITransaction.Save Error');
    end;{if}
  end;{PrintSalesCodeTotals}

var
  sPrevDate, sPrevCustCode, sCustCodeDesc, sSalesCodeDesc : string;
  GrandTotals, CustomerTotals : TTotals;
  PJILine : ITransactionLine;
const
  DO_NOT_PRINT_TOTALS = 'DO_NOT_PRINT_TOTALS';

Begin{SalesCommissionPrint}

  slReport := TStringList.create;
  frmProgress := TfrmProgress.Create(self);
  frmProgress.UpdateLine(1, 'Scanning Transactions....');
  frmProgress.Show;

  // go through all transactions in date range
  with oToolkit, ReportCriteria do begin
    Transaction.Index := thIdxTransDate;
    iStatus := Transaction.GetGreaterThanOrEqual(Transaction.BuildTransDateIndex(DateToStr8(dDateFrom)));
    while (iStatus = 0) and (Str8ToDate(Transaction.thTransDate) <= dDateTo) do begin

//    if sPrevDate > otoolkit.Transaction.thTransDate
//    then showmessage('x');


      application.ProcessMessages;
      frmProgress.UpdateLine(2, 'Transaction : ' + Transaction.thOurRef);
      frmProgress.UpdateLine(3, 'Line : ');

      AddLineToFile(DateToStr8(SysUtils.Date) + ' ' + TimetoStr6(Time) + ' ' + otoolkit.Transaction.thourref + ', ' +  otoolkit.Transaction.thTransDate, 'c:\tx.log', TRUE);

      bAdd := TRUE;

      // Correct Customer ?
      iFound := slCustomers.IndexOf(Trim(Transaction.thAcCode));
      if iFound = -1 then bAdd := FALSE
      else begin
        // Correct Account Type ?
        if bFilterByCustAccType then begin
          if sIncludeCustAccType <> Trim(Transaction.thAcCodeI.acAccType)
          then bAdd := FALSE;
        end;{if}

        if bAdd then begin
           // Correct TX Type ?
          iFound := slTXTypes.IndexOf(Copy(Transaction.thOurRef,1,3));
          if iFound = -1 then bAdd := FALSE
          else begin
            // Only Include Fully Paid Off TXs
            if bOnlyIncludePaidOffTXs then bAdd := Transaction.thTotals[transTotOutstandingInCcy] = 0;

            if bAdd then begin
              // Correct Currency ?
              if bFilterByTXCurrency then begin
                if Transaction.thCurrency <> iTXCurrencyFilter then bAdd := FALSE;
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}

      if bAdd then CheckLines;

      sPrevDate := otoolkit.Transaction.thTransDate;

      iStatus := Transaction.GetNext;

//debugToFile(Transaction.thTransDate + Transaction.thourref);

    end;{while}

    slReport.Sort;

    sPrevSalesCode := DO_NOT_PRINT_TOTALS;
    sPrevCustCode := DO_NOT_PRINT_TOTALS;
    FillChar(SalesCodeTotals, SizeOf(SalesCodeTotals), #0);
    FillChar(CustomerTotals, SizeOf(CustomerTotals), #0);
    FillChar(GrandTotals, SizeOf(GrandTotals), #0);

    For iPos := 0 to slReport.count - 1 do begin

      with TheReport, slReport.Objects[iPos] as TCommissionInfo do begin

        sSalesCodeDesc := Trim(TSalesCodeInfo(slSalesCodes.Objects[slSalesCodes.IndexOf(Trim(SalesCode))]).Details.scDescription);
        sCustCodeDesc := Trim(TCustomerInfo(slCustomers.Objects[slCustomers.IndexOf(Trim(CustCode))]).Description);

        SetRepFont(TheReport, fnSubTotal, 8);

        // print customer totals
        if ((sPrevCustCode <> CustCode) or (sPrevSalesCode <> SalesCode))
        and (not (sPrevCustCode = DO_NOT_PRINT_TOTALS))
        then PrintTotals(CustomerTotals, 'Totals for ' + Trim(sPrevCustCode));

        // print sales code totals
        if (sPrevSalesCode <> SalesCode)
        and (not (sPrevSalesCode = DO_NOT_PRINT_TOTALS))
        then PrintSalesCodeTotals;

        // print sales code header
        if sPrevSalesCode <> SalesCode
        then begin
          Print(Trim(SalesCode) + ' - ' + sSalesCodeDesc);
          EndOfPageLine(TheReport, PagedFormat);

          // Initialise PJI
          if bGeneratePJI then begin
            SalesCodeRec := (slSalesCodes.Objects[slSalesCodes.IndexOf(Trim(SalesCode))]
            as TSalesCodeInfo).details;
            if Trim(SalesCodeRec.scEntSupplierCode) <> '' then begin
              PJI := oToolkit.Transaction.Add(dtPJI);
              PJILine := PJI.thLines.Add;
              PJILine.tlDescr := 'Commission: ' + Trim(SalesCode) + ' - ' + sSalesCodeDesc;
              PJILine.tlVATCode := 'Z';
              PJILine.Save;
            end;{if}
          end;{if}
        end;{if}


        // print customer header
        if ((sPrevCustCode <> CustCode) or (sPrevSalesCode <> SalesCode))
        then begin
          Print(#9 + Trim(CustCode) + ' - ' + sCustCodeDesc);
          if bGeneratePJI and (Trim(SalesCodeRec.scEntSupplierCode) <> '') then begin
            PJI.thAcCode := SalesCodeRec.scEntSupplierCode;
            PJI.thCurrency := SalesCodeRec.scEntInvCurrency;
          end;{if}
          EndOfPageLine(TheReport, PagedFormat);
        end;{if}


        SetRepFont(TheReport, fnMainText, 8);

        Print(#9#9 + ProdCode + #9
        + CommissionBasis + #9
        + FloatToStrF(QtySold, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals) + #9
        + FloatToStrF(LineTotal, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals) + #9
        + CommissionRate + #9
        + FloatToStrF(Commission, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals));
        EndOfPageLine(TheReport, PagedFormat);

        if bGeneratePJI and (Trim(SalesCodeRec.scEntSupplierCode) <> '') then begin
          PJILine := PJI.thLines.Add;
          if oToolkit.SystemSetup.ssUseCCDept then begin
            PJILine.tlCostCentre := SalesCodeRec.scEntCostCentre;
            PJILine.tlDepartment := SalesCodeRec.scEntDepartment;
          end;{if}
          PJILine.tlGLCode := SalesCodeRec.scEntGLCode;
          PJILine.tlDescr := ProdCode + ' : ' + ProductDesc;

          PJILine.tlNetValue := Functions.entConvertAmount(Commission
          , iConvertCurrency, SalesCodeRec.scEntInvCurrency, 0);

          PJILine.tlVATCode := 'Z';
          PJILine.Save;
        end;{if}

        IncTotals(CustomerTotals);
        IncTotals(SalesCodeTotals);
        IncTotals(GrandTotals);

        sPrevSalesCode := SalesCode;
        sPrevCustCode := CustCode;
      end;{with}
    end;{for}
    if not (sPrevCustCode = DO_NOT_PRINT_TOTALS) then PrintTotals(CustomerTotals, 'Totals for ' + Trim(sPrevCustCode));
    if not (sPrevSalesCode = DO_NOT_PRINT_TOTALS) then PrintSalesCodeTotals;
    if not (sPrevCustCode = DO_NOT_PRINT_TOTALS) then PrintTotals(GrandTotals, 'Grand Totals');

    slSalesCodeTypes.Sorted := FALSE;
    slSalesCodes.Sorted := FALSE;
    slProdGroups.Sorted := FALSE;
    slCustomers.Sorted := FALSE;
    slProducts.Sorted := FALSE;

  end;{with}

  ClearList(slReport);
  slReport.Free;

  frmProgress.Hide;
  frmProgress.Release;

end;


procedure TReportCriteria.FillAllListObjects;
var
  iStatus, iRecPos, iPos : integer;
  CustomerInfo : TCustomerInfo;
  SalesCodeRec : TSalesCodeRec;
  SalesCodeTypeRec : TSalesCodeTypeRec;
begin
  // Rejig Customer List
  for iPos := 0 to slCustomers.Count -1 do begin
    iRecPos := StrToIntDef(slCustomers[iPos], 0);
    oToolkit.Customer.Position := iRecPos;
    oToolkit.Customer.RestorePosition;
    slCustomers[iPos] := Trim(oToolkit.Customer.acCode);
    CustomerInfo := TCustomerInfo.Create;
    CustomerInfo.Description := oToolkit.Customer.acCompany;
    slCustomers.Objects[iPos] := CustomerInfo;
  end;{for}
  slCustomers.Sorted := TRUE;

  // Rejig Product List
  for iPos := 0 to slProducts.Count -1 do begin
    iRecPos := StrToIntDef(slProducts[iPos], 0);
    oToolkit.Stock.Position := iRecPos;
    oToolkit.Stock.RestorePosition;
    slProducts[iPos] := Trim(oToolkit.Stock.stCode);
  end;{for}
  slProducts.Sorted := TRUE;

  // Rejig ProdGroup List
  for iPos := 0 to slProdGroups.Count -1 do begin
    iRecPos := StrToIntDef(slProdGroups[iPos], 0);
    oToolkit.Stock.Position := iRecPos;
    oToolkit.Stock.RestorePosition;
    slProdGroups[iPos] := Trim(oToolkit.Stock.stCode);
  end;{for}
  slProdGroups.Sorted := TRUE;

  // Rejig SalesCodes List
  for iPos := 0 to slSalesCodes.Count -1 do begin
    iRecPos := StrToIntDef(slSalesCodes[iPos], 0);
    move(iRecPos,SalesCodeRec,sizeof(iRecPos));
    iStatus := GetDirect(F[SalesCodeF], SalesCodeF, SalesCodeRec, 0, 0);
    if iStatus = 0 then slSalesCodes[iPos] := Trim(SalesCodeRec.scSalesCode);
  end;{for}
  slSalesCodes.Sorted := TRUE;

  // Rejig SalesCodeTypes List
  for iPos := 0 to slSalesCodeTypes.Count -1 do begin
    iRecPos := StrToIntDef(slSalesCodeTypes[iPos], 0);
    move(iRecPos,SalesCodeTypeRec,sizeof(iRecPos));
    iStatus := GetDirect(F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, 0, 0);
    if iStatus = 0 then slSalesCodeTypes[iPos] := Trim(SalesCodeTypeRec.sctDescription);
  end;{for}
  slSalesCodeTypes.Sorted := TRUE;
end;

initialization
  ShortDateFormat := 'dd/mm/yy';
  LongTimeFormat := 'hh:nn:ss';

end.





