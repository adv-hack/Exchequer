unit Reports;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , RPFiler, RPDefine, RPBase, RPCanvas, RPFPrint, APIUtil, RPDevice, FileUtil
  , ComCtrls, EntRend, StdCtrls, StrUtil, Prntdlg, MiscUtil, PrntPrev
  , BTConst, MathUtil, Math, Inifiles, DateUtils, Enterprise01_TLB, BTUtil
  , BTFiles;

type
  ENoUnique = class(Exception);

  TLineInfo = class
    iReportCat : integer;
    iReportSubCat : integer;
    sStockCode : string[16];
    sCustomer : string[54];
    sSuppCode : string[6];
    rQuantity : real;
    rWEEECharge : real;
    rUnitWeight : real;
    rEMC : real;
    rICT : real;
  end;

  TSupplierInfo = Class
    bWEEE : boolean;
    sDescription : string[45];
  end;

  TTotalsRec = record
    rQuantity : real;
    rWEEECharge : real;
    rWeight : real;
    rEMC : real;
    rICT : real;
  end;

  TModReports = class(TForm)
    FilePrinter1: TFilePrinter;
    TheReport: TReportFiler;
    procedure WEEEReportNewPage(Sender: TObject);
    procedure PortraitBeforePrint(Sender: TObject);
    procedure LandscapeBeforePrint(Sender: TObject);
    procedure WEEEReportPrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    PrnInfo : TSBSPrintSetupInfo;
    procedure SetHeader(sReportTitle, sColHeads : string; sSubTitle : string = ''; sDateRange : string = '');
    function RunReport : boolean;
    function PrintHeader : boolean;
    function PagedFormat : boolean;
    procedure SetTabs;
  public
    bConsolidate, bGotPrnInfo : boolean;
    iStartPeriod, iStartYear, iEndPeriod, iEndYear : integer;
    sAccountTypeFilter : string;
//    slStatuses, slCustomers : TStringList;
//    bByTonnes : boolean;
    procedure PrintWEEEReport;
  end;

var
  ModReports: TModReports;

implementation

uses
  WEEEProc, ShellAPI, RepUtil{, Admin};

{$R *.DFM}

{TModReports}

procedure TModReports.SetHeader(sReportTitle, sColHeads : string; sSubTitle : string = ''; sDateRange : string = '');
begin
  SetStandardHeader(TheReport, 'WEEE Report', sReportTitle, sColHeads, PagedFormat, sSubTitle, sDateRange);
end;

procedure TModReports.PrintWEEEReport;
begin
  with TheReport do begin
    OnBeforePrint := LandscapeBeforePrint;
    OnNewPage := WEEEReportNewPage;
    OnPrint := WEEEReportPrint;
    Title := 'Print Records';
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
//  Screen.Cursor := crHourglass;
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
//  Screen.Cursor := crDefault;
  Result := bContinue;
end;

procedure TModReports.SetTabs;
begin
  with TheReport do begin
    ClearTabs;
    SetTab(MarginLeft + 3             // Category
    , pjLeft, 30, 2, 0, 0);           // Stock Code
//    SetTab(NA, pjLeft, 30, 4, 0, 0);  // Stock Code
    SetTab(NA, pjLeft, 55, 4, 0, 0);  // Customer
    SetTab(NA, pjLeft, 55, 4, 0, 0);  // Supplier
    SetTab(NA, pjRight, 16, 4, 0, 0); // Quantity
    SetTab(NA, pjRight, 16, 4, 0, 0); // WEEE Charge
    SetTab(NA, pjRight, 16, 4, 0, 0); // TOT WEEE
    SetTab(NA, pjRight, 16, 4, 0, 0); // Unit Weight
    SetTab(NA, pjRight, 16, 4, 0, 0); // TOT Weight
    SetTab(NA, pjRight, 16, 4, 0, 0); // EMC
    SetTab(NA, pjRight, 16, 4, 0, 0); // TOT EMC
    SetTab(NA, pjRight, 16, 4, 0, 0); // ICT
    SetTab(NA, pjRight, 16, 4, 0, 0); // TOT ICT
  end;{with}
end;

procedure TModReports.WEEEReportNewPage(Sender: TObject);
var
  sRange : string;
begin
  if PrintHeader then begin
    with TheReport do begin
      SetTabs;
      sRange := PadString(psLeft, IntToStr(iStartPeriod), '0', 2) + '/' + IntToStr(iStartYear)
      + ' to ' + PadString(psLeft, IntToStr(iEndPeriod), '0', 2) + '/' +  IntToStr(iEndYear);

      if sAccountTypeFilter <> '' then sRange := sRange + ' (Account Type : '
      + sAccountTypeFilter + ')';

      SetHeader(sRange , #9'Stock Code'#9'Customer'#9'Supplier'#9
      + 'Quantity'#9'WEEE'#9'Tot WEEE'#9'Unit Wgt'#9'Tot Wgt'#9'EMC'#9'Tot EMC'#9'ICT'#9'Tot Ict');
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

procedure TModReports.WEEEReportPrint(Sender: TObject);
type
  TGetMode = (cmDescription, cmCode, cmCodeDesc);
const
  TOT_CATEGORY = 1;
  TOT_SUBCATEGORY = 2;
  TOT_GRAND = 3;
var
  WEEEProdInfo : TWEEEProdInfo;
  ReportCatInfo : TReportCatInfo;
  ReportSubCatInfo : TReportSubCatInfo;
  SupplierInfo : TSupplierInfo;
  slSuppliers, slRepCatInfo, slRepSubCatInfo, slWEEEProdInfo : TStringList;
  aTotals : array [TOT_CATEGORY..TOT_GRAND] of TTotalsRec ;

  function InPeriodRange(iPeriod, iYear : integer) : boolean;
  var
    iCurrentPeriod : integer;
  begin{InPeriodRange}
    // is iPeriod/iYear in the report period/year range
    iCurrentPeriod := StrToIntDef(IntToStr(iYear) + PadString(psLeft, IntToStr(iPeriod), '0', 2), 0);
    Result := (iCurrentPeriod >= StrToIntDef(IntToStr(iStartYear) + PadString(psLeft, IntToStr(iStartPeriod), '0', 2), 0))
    and (iCurrentPeriod <= StrToIntDef(IntToStr(iEndYear) + PadString(psLeft, IntToStr(iEndPeriod), '0', 2), 0))
  end;{InPeriodRange}

  function BuildRCIndex(iFolio : integer) : string;
  begin
    Result := PadString(psLeft,IntToStr(iFolio), '0', 6);
  end;

  function GetReportCategory(iReportCat : integer; GetMode : TGetMode) : string;
  var
   iIndex : integer;
  begin{GetReportCategory}
    // find in string list
    iIndex := slRepCatInfo.IndexOf(BuildRCIndex(iReportCat));
    if iIndex < 0 then
    begin
      // not found
      Result := '(not found)'
    end else
    begin
      // found
      case GetMode of

        cmCodeDesc : begin
          // Return code + Description
          Result := Trim(TReportCatInfo(slRepCatInfo.Objects[iIndex]).Details.wrcCode) + ' : '
          + Trim(TReportCatInfo(slRepCatInfo.Objects[iIndex]).Details.wrcDescription);
        end;

        cmDescription : begin
          // Return Description
          Result := TReportCatInfo(slRepCatInfo.Objects[iIndex]).Details.wrcDescription;
        end;

        cmCode : begin
          // Return code
          Result := Trim(TReportCatInfo(slRepCatInfo.Objects[iIndex]).Details.wrcCode);
        end;

      end;{if}
    end;{if}
  end;{GetReportCategory}

  function GetReportSubCategory(iReportSubCat : integer; GetMode : TGetMode) : string;
  var
   iIndex : integer;
  begin{GetReportSubCategoryName}
    // find in string list
    iIndex := slRepSubCatInfo.IndexOf(BuildRCIndex(iReportSubCat));
    if iIndex < 0 then
    begin
      // not found
      Result := '(not found)'
    end else
    begin
      // found
      case GetMode of

        cmCodeDesc : begin
          // Return code + Description
          Result := Trim(TReportSubCatInfo(slRepSubCatInfo.Objects[iIndex]).Details.wscCode) + ' : '
          + Trim(TReportSubCatInfo(slRepSubCatInfo.Objects[iIndex]).Details.wscDescription);
        end;

        cmDescription : begin
          // Return Description
          Result := TReportSubCatInfo(slRepSubCatInfo.Objects[iIndex]).Details.wscDescription;
        end;

        cmCode : begin
          // Return code
          Result := Trim(TReportSubCatInfo(slRepSubCatInfo.Objects[iIndex]).Details.wscCode);
        end;

      end;{if}
    end;{if}
  end;{GetReportSubCategoryName}

  function BuildLinesIndex(TXLine : ITransactionLine; WEEEProdRec : TWEEEProdRec) : string;
  begin
    Result := PadString(psRight, GetReportCategory(WEEEProdRec.wpReportCatFolio, cmCode), ' ', 10)
    + PadString(psRight, GetReportSubCategory(WEEEProdRec.wpReportSubCatFolio, cmCode), ' ', 10)
    + PadString(psRight, TXLine.tlStockCode, ' ', 16)
    + PadString(psRight, TXLine.tlAcCode, ' ', 6);
  end;

  procedure BuildWEEEProdInfoList;
  var
    BTRec : TBTRec;
    WEEEProductDetails : TWEEEProdRec;
  begin{BuildWEEEInfoList}
    slWEEEProdInfo := TStringList.Create;

    // first WEEE Product record
    BTRec.Status := BTFindRecord(BT_GetFirst, btFileVar[WEEEProdF], WEEEProductDetails
    , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);

    while BTRec.Status = 0 do
    begin
      // Add new item into string list
      WEEEProdInfo := TWEEEProdInfo.Create;
      WEEEProdInfo.Details := WEEEProductDetails;
      slWEEEProdInfo.AddObject(WEEEProductDetails.wpStockCode, WEEEProdInfo);

      // next WEEE Product record
      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[WEEEProdF], WEEEProductDetails
      , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);
    end;{while}
  end;{BuildWEEEInfoList}

  procedure BuildRepCatList;
  var
    BTRec : TBTRec;
    ReportCat : TWEEEReportCatRec;
  begin{BuildRepCatList}
    slRepCatInfo := TStringList.Create;

    // first Report Category
    BTRec.Status := BTFindRecord(BT_GetFirst, btFileVar[WEEEReportCatF], ReportCat
    , btBufferSize[WEEEReportCatF], wrcIdxFolio, BTRec.KeyS);

    while BTRec.Status = 0 do
    begin
      // Add new item into string list
      ReportCatInfo := TReportCatInfo.Create;
      ReportCatInfo.Details := ReportCat;
      slRepCatInfo.AddObject(BuildRCIndex(ReportCat.wrcFolioNo), ReportCatInfo);

      // next Report Category
      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[WEEEReportCatF], ReportCat
      , btBufferSize[WEEEReportCatF], wrcIdxFolio, BTRec.KeyS);
    end;{while}
  end;{BuildRepCatList}

  procedure BuildRepSubCatList;
  var
    BTRec : TBTRec;
    ReportSubCat : TWEEEReportSubCatRec;
  begin{BuildRepSubCatList}
    slRepSubCatInfo := TStringList.Create;

    // first Report Sub Category
    BTRec.Status := BTFindRecord(BT_GetFirst, btFileVar[WEEEReportSubCatF], ReportSubCat
    , btBufferSize[WEEEReportSubCatF], wscIdxFolio, BTRec.KeyS);

    while BTRec.Status = 0 do
    begin
      // Add new item into string list
      ReportSubCatInfo := TReportSubCatInfo.Create;
      ReportSubCatInfo.Details := ReportSubCat;
      slRepSubCatInfo.AddObject(BuildRCIndex(ReportSubCat.wscFolioNo), ReportSubCatInfo);

      // Next Report Sub Category
      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[WEEEReportSubCatF], ReportSubCat
      , btBufferSize[WEEEReportSubCatF], wscIdxFolio, BTRec.KeyS);
    end;{while}
  end;{BuildRepSubCatList}

  procedure IncrementTotals(TheLineInfo : TLineInfo);
  var
    iTot : integer;
  begin{IncrementTotals}
    For iTot := TOT_CATEGORY to TOT_GRAND do
    begin
      with aTotals[iTot] do
      begin
        rQuantity := rQuantity + StrToFloat(MoneyToStr(TheLineInfo.rQuantity, oToolkit.SystemSetup.ssQtyDecimals));
        rWEEECharge := rWEEECharge + StrToFloat(MoneyToStr(TheLineInfo.rWEEECharge * TheLineInfo.rQuantity));
        rWeight := rWeight + StrToFloat(MoneyToStr(TheLineInfo.rUnitWeight * TheLineInfo.rQuantity));
        rEMC := rEMC + StrToFloat(MoneyToStr(TheLineInfo.rEMC * TheLineInfo.rQuantity));
        rICT := rICT + StrToFloat(MoneyToStr(TheLineInfo.rICT * TheLineInfo.rQuantity));
      end;{with}
    end;{for}
  end;{IncrementTotals}

  procedure PrintTotals(iTot : integer; sDesc : string);
  begin{PrintTotals}
    with aTotals[iTot] do
    begin
      // Draw Line for total
      UpOneLine(TheReport);
      DrawHorzLine(TheReport, dlThin, TheReport.MarginLeft + 34, TheReport.MarginLeft + 286);

      // Print Total Line
      SetRepFont(TheReport,fnSubTotal, 8);
      TheReport.Print(#9#9 + sDesc + #9#9 + MoneyToStr(rQuantity, oToolkit.SystemSetup.ssQtyDecimals)
      + #9#9 + MoneyToStr(rWEEECharge)
      + #9#9 + MoneyToStr(rWeight)
      + #9#9 + MoneyToStr(rEMC)
      + #9#9 + MoneyToStr(rICT)
      );

      EndOfPageLine(TheReport, PagedFormat);
    end;{with}
    FillChar(aTotals[iTot], SizeOf(aTotals[iTot]), #0);
  end;{PrintTotals}

  function GetSupplierInfo(sSuppCode : string) : TSupplierInfo;
  var
    iStatus, iIndex : integer;
  begin{GetSupplierInfo}
    Result := nil;

    // Find Supplier in stringlist
    iIndex := slSuppliers.IndexOf(sSuppCode);
    if iIndex < 0 then
    begin
      // not found - add new record

      // Find Supplier using toolkit
      oToolkit.Supplier.Index := acIdxCode;
      iStatus := oToolkit.Supplier.GetEqual(oToolkit.Supplier.BuildCodeIndex(sSuppCode));
      if iStatus = 0 then
      begin
        SupplierInfo := TSupplierInfo.create;

        // Get WEEE Supplier Flag from appropriate UDF on the Stock Record
        case SystemSetupRec.SupplierUDF of
          1 : SupplierInfo.bWEEE := UpperCase(oToolkit.Supplier.acUserDef1) = 'YES';
          2 : SupplierInfo.bWEEE := UpperCase(oToolkit.Supplier.acUserDef2) = 'YES';
          3 : SupplierInfo.bWEEE := UpperCase(oToolkit.Supplier.acUserDef3) = 'YES';
          4 : SupplierInfo.bWEEE := UpperCase(oToolkit.Supplier.acUserDef4) = 'YES';
        end;{case}

        SupplierInfo.sDescription := oToolkit.Supplier.acCompany;

        slSuppliers.AddObject(sSuppCode, SupplierInfo);

        Result := SupplierInfo;
      end;{if}

    end else
    begin
      // found - read existing record
      Result := TSupplierInfo(slSuppliers.Objects[iIndex]);
    end;{if}

    oToolkit.Transaction.thDocType
  end;{GetSupplierInfo}

  function TXTypeMultiplier(TXType : TDocTypes) : integer;
  begin{TXTypeMultiplier}
    Result := 1;
    if TXType in [dtSCR, dtSJC{, dtSRF}] // Note : SRFs are excluded from the report, as the WEEE Plug-In itself does not support them. This is because the Toolkit does not support the updating of this transaction type
    then Result := -1;
  end;{TXTypeMultiplier}

var
  slLines : TStringList;
  iPrevReportCat, iPrevReportSubCat, iWEEEIndex, iIndex, iLine, iStatus : integer;
  bWEEEProd : boolean;
  LineInfo : TLineInfo;
  sIndex : string;

Begin{WEEEReportPrint}

  // initialise
  Screen.Cursor := crHourglass;
  GetSysSetupRec;
  slLines := TStringList.Create;
  slSuppliers := TStringList.Create;
  BuildWEEEProdInfoList;
  BuildRepCatList;
  BuildRepSubCatList;

  with TheReport, oToolkit, Transaction do begin

    //////////////////////////////
    // Build slLines StringList //
    //////////////////////////////

    // Get First Transaction for the Period/Year given
    Index := thIdxYearPeriod;
    iStatus := GetGreaterThanOrEqual(BuildYearPeriodIndex(iStartYear - 1900, iStartPeriod));

    // Go through all transactions in the period range
    while (iStatus = 0) and InPeriodRange(thPeriod, thYear + 1900) do
    begin
      // Filter Transactions
      // Note : SRIs and SRFs are excluded from the report, as the WEEE Plug-In itself does not support them. This is because the Toolkit does not support the updating of these transaction types
      if (thDocType in [dtSIN, dtSJI, dtSJC, {dtSRI,} dtSCR{, dtSRF}]) // Only look at specific transaction types
      and (not (oToolkit.Transaction as ITransaction4).thAutoTransaction) // ignore auto transactions
      and (IsWEEECustomerCTK(oToolkit.Transaction.thAcCodeI)) // ignore non WEEE Customers
      and ((sAccountTypeFilter = '') or (Trim(UpperCase(oToolkit.Transaction.thAcCodeI.acAccType)) = Trim(UpperCase(sAccountTypeFilter)))) then // filter by account type
      begin
        // Go through all the lines on the transaction
        For iLine := 1 to thLines.thLineCount do
        begin
          if thLines.thLine[iLine].tlStockCodeI <> nil then
          begin
            // Is it a WEEE Product on this line
            bWEEEProd := FALSE;
            case SystemSetupRec.StockFlagUDF of
              1 : bWEEEProd := UpperCase(thLines.thLine[iLine].tlStockCodeI.stUserField1) = 'YES';
              2 : bWEEEProd := UpperCase(thLines.thLine[iLine].tlStockCodeI.stUserField2) = 'YES';
              3 : bWEEEProd := UpperCase(thLines.thLine[iLine].tlStockCodeI.stUserField3) = 'YES';
              4 : bWEEEProd := UpperCase(thLines.thLine[iLine].tlStockCodeI.stUserField4) = 'YES';
            end;{case}

            if bWEEEProd then
            begin
              // Get WEEE Product Information from List
              iWEEEIndex := slWEEEProdInfo.IndexOf(thLines.thLine[iLine].tlStockCode);
              if iWEEEIndex >=0 then
              begin
                WEEEProdInfo:= TWEEEProdInfo(slWEEEProdInfo.Objects[iWEEEIndex]);

                // is this a WEEE Supplier
                if GetSupplierInfo(thLines.thLine[iLine].tlStockCodeI.stSupplier).bWEEE then
                begin

                  // Find Existing Report Line in the list
                  sIndex := BuildLinesIndex(thLines.thLine[iLine], WEEEProdInfo.Details);
                  iIndex := slLines.IndexOf(sIndex);
                  if iIndex < 0 then
                  begin
                    // Not already in the list so create a new entry
                    LineInfo := TLineInfo.Create;
                    slLines.AddObject(sIndex, LineInfo);

                    // Fill Line information properties
                    with LineInfo do
                    begin
                      iReportCat := WEEEProdInfo.Details.wpReportCatFolio;
                      iReportSubCat := WEEEProdInfo.Details.wpReportSubCatFolio;
                      sStockCode := thLines.thLine[iLine].tlStockCode;
                      sCustomer := thAcCodeI.acCode + ' : ' + thAcCodeI.acCompany;
                      sSuppCode := thLines.thLine[iLine].tlStockCodeI.stSupplier;
                      rQuantity := 0;
                      rWEEECharge := StrToFloat(MoneyToStr(WEEEProdInfo.Details.wpValue));
                      rUnitWeight := StrToFloat(MoneyToStr(thLines.thLine[iLine].tlStockCodeI.stIntrastat.stSSDSalesUnitWeight));

                      // Get EMC from appropriate UDF on the Stock Record
                      case SystemSetupRec.StockEMCUDF of
                        1 : rEMC := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField1, 0)));
                        2 : rEMC := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField2, 0)));
                        3 : rEMC := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField3, 0)));
                        4 : rEMC := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField4, 0)));
                      end;{case}

                      // Get ICT from appropriate UDF on the Stock Record
                      case SystemSetupRec.StockITCUDF of
                        1 : rICT := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField1, 0)));
                        2 : rICT := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField2, 0)));
                        3 : rICT := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField3, 0)));
                        4 : rICT := StrToFloat(MoneyToStr(StrToFloatDef(thLines.thLine[iLine].tlStockCodeI.stUserField4, 0)));
                      end;{case}
                    end;{with}
                  end else
                  begin
                    // The line already exists, so update it
                    LineInfo := TLineInfo(slLines.Objects[iIndex]);
                  end;{if}

                  // Update Quantity on Line
                  LineInfo.rQuantity := LineInfo.rQuantity
                  + StrToFloat(MoneyToStr(thLines.thLine[iLine].tlQty * TXTypeMultiplier(oToolkit.Transaction.thDocType)
                  , oToolkit.SystemSetup.ssQtyDecimals));
                end;{if}
              end;{if}
            end;{if}
          end;{if}
        end;{for}

      end;{if}

      // Next Transaction
      iStatus := GetNext;
    end;{while}


    /////////////////////////////////
    // Print Lines from StringList //
    /////////////////////////////////

    // initialise
    slLines.Sort;
    iPrevReportCat := -1;
    iPrevReportSubCat := -1;
    FillChar(aTotals, SizeOf(aTotals), #0);

    // Go Through all lines in the list
    For iLine := 0 to slLines.Count-1 do
    begin
      with TLineInfo(slLines.Objects[iLine]) do
      begin
        // print Category
        if iPrevReportCat <> iReportCat then
        begin
          SetRepFont(TheReport, fnSectionHeader, 8);
          Print(GetReportCategory(iReportCat, cmCodeDesc));
          EndOfPageLine(TheReport, PagedFormat);
        end;{if}

        // print Sub Category
        if iPrevReportSubCat <> iReportSubCat then
        begin
          SetRepFont(TheReport, fnSubTotal, 8);
          Print(#9 + GetReportSubCategory(iReportSubCat, cmCodeDesc));
          EndOfPageLine(TheReport, PagedFormat);
        end;{if}

        // print Line
        SetRepFont(TheReport,fnMainText, 8);
        Print({#9}#9 + sStockCode + #9
        + sCustomer + #9
        + sSuppCode + ' : ' + GetSupplierInfo(sSuppCode).sDescription + #9
        + MoneyToStr(rQuantity, oToolkit.SystemSetup.ssQtyDecimals) + #9
        + MoneyToStr(rWEEECharge) + #9
        + MoneyToStr(rWEEECharge * rQuantity) + #9
        + MoneyToStr(rUnitWeight) + #9
        + MoneyToStr(rUnitWeight * rQuantity) + #9
        + MoneyToStr(rEMC) + #9
        + MoneyToStr(rEMC * rQuantity) + #9
        + MoneyToStr(rICT) + #9
        + MoneyToStr(rICT * rQuantity)
        );
        EndOfPageLine(TheReport, PagedFormat);

        // Add To Totals
        IncrementTotals(TLineInfo(slLines.Objects[iLine]));

        // Print Sub Category SubTotal
        if (iLine = slLines.Count -1)
        or (TLineInfo(slLines.Objects[iLine+1]).iReportSubCat <> iReportSubCat) then
        begin
          PrintTotals(TOT_SUBCATEGORY, Trim(GetReportSubCategory(iReportSubCat, cmDescription)) + ' Totals');
        end;{if}

        // Print Category SubTotal
        if (iLine = slLines.Count -1)
        or (TLineInfo(slLines.Objects[iLine+1]).iReportCat <> iReportCat) then
        begin
          PrintTotals(TOT_CATEGORY, Trim(GetReportCategory(iReportCat, cmDescription)) + ' Totals');
        end;{if}

        // Store previous line values
        iPrevReportCat := iReportCat;
        iPrevReportSubCat := iReportSubCat;
      end;{with}
    end;{for}

    // Print Grand Totals
    PrintTotals(TOT_GRAND, 'Grand Totals');

    // Clear Up
    ClearList(slLines);
    slLines.Free;
    ClearList(slWEEEProdInfo);
    slWEEEProdInfo.Free;
    ClearList(slRepCatInfo);
    slRepCatInfo.Free;
    ClearList(slRepSubCatInfo);
    slRepSubCatInfo.Free;
    ClearList(slSuppliers);
    slSuppliers.Free;
  end;{with}
  Screen.Cursor := crDefault;
end;{WEEEReportPrint}

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


initialization
  ShortDateFormat := 'dd/mm/yy';
  LongTimeFormat := 'hh:nn:ss';

end.





