unit Reports;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , BTSupU1, RPFiler, RPDefine, RPBase, RPCanvas, RPFPrint, Progress, APIUtil
  , NeilProc, VarConst, CardProc, RPDevice, GlobVar, ExWrap1U, ETStrU, BtrvU2
  , FileUtil, StdCtrls, StrUtil, Prntdlg, BTKeys1U, ETDateU, SaleItem, MiscUtil
  , EntRend, MathUtil;

type

  TReportOrder = (roByCardNumber, roByCardName);

  TTXRec = Record
    sDesc : string;
    aValue : array of real;
    aQty : array of real;
  end;{TTXRec}

  TClerkRepInfo = Class
    ClerkNo : byte;
    ClerkName : string8;
    Description : string;
    Qty : real;
    Value : real;
  end;{TClerkRepInfo}

  THourlyInfo = class
    HourNo : byte;
    Qty : double;
    Value : double;
  end;{THourlyInfo}

  TGroupSalesInfo = Class
    GroupNo : byte;
    DeptQty : double;
    DeptValue : double;
    PLUQty : double;
    PLUValue : double;
    TotalQty : double;
    TotalValue : double;
  end;{TGroupSalesInfo}

  TPLUSalesInfo = Class
    PLUNo : smallint;
    GroupNo : byte;
    PLUDesc : string16;
    NonCardQty : double;
    NonCardVal : double;
    CardQty : double;
    CardVal : double;
    TotalQty : double;
    TotalVal : double;
  end;

  TTurnoverInfo = Class
    CardNo : string10;
    Name : string;
    Spent : real;
    PaidIn : real;
    Balance : real;
  end;

  THeldCards = Record
    OnlyShowHolds : boolean;
    Status : Array [1..10] of Boolean;
  end;

  TCardListRec = Record
    slLines : TStringList;
    rTotSpent : real;
    rTotPaid : real;
    rTotBalance : real;
    HeldCards : THeldCards;
    ReportOrder : TReportOrder;
  end;{CardListRec}

  RepGroupType = Record
    rgName     : String[12];      { Name of group }
    rgTotSales : Real;            { Total sales to items in group }
    rgDiscAmt  : Real;            { discount given to sales }
  End; { RepGroupType }

  GroupSalesInfoType = Record
    HedTit         : Str80;
    FRunNo, LRunNo : LongInt;
    Groups         : Array [MinGroup..MaxGroup] Of RepGroupType;
  End; { GroupSalesInfoPtr }

  GroupSalesInfoPtr = ^GroupSalesInfoType;

  DeptArrayPtr = Array [1..300] Of Byte;
  PLUArrayPtr = Array [1..700] Of Byte;

  TGroupCacheObj = Class
    public
      DeptGroups   : ^DeptArrayPtr;
      PLUGroups    : ^PLUArrayPtr;

      Constructor Create;
      Destructor  Done;  Virtual;
      Function GetGroupNo (Const ItemType   : Char;
                           Const ItemNumber : LongInt) : LongInt;
      Function GetDeptGroup (Const ItemNumber : LongInt) : LongInt;
      Function GetPLUGroup (Const ItemNumber : LongInt) : LongInt;
  End;{TGroupCacheObj}

  ENoUnique = class(Exception);

  TCurrentReport = (rEODError, rTillCard);

  TModReports = class(TForm)
    FilePrinter1: TFilePrinter;
    TheReport: TReportFiler;
    procedure CardListNewPage(Sender: TObject);
    procedure PortraitBeforePrint(Sender: TObject);
    procedure LandscapeBeforePrint(Sender: TObject);
    procedure CardListPrint(Sender: TObject);
    procedure EODLogsBeforePrint(Sender: TObject);
    procedure EODLogsNewPage(Sender: TObject);
    procedure EODLogsPrint(Sender: TObject);
    procedure EODPostingBeforePrint(Sender: TObject);
    procedure EODPostingNewPage(Sender: TObject);
    procedure EODPostingPrint(Sender: TObject);
    procedure GroupSalesNewPage(Sender: TObject);
    procedure GroupSalesPrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FunctionBookPrint(Sender: TObject);
    procedure FunctionBookNewPage(Sender: TObject);
    procedure PLUListNewPage(Sender: TObject);
    procedure PLUListPrint(Sender: TObject);
    procedure StatementNewPage(Sender: TObject);
    procedure StatementPrint(Sender: TObject);
    procedure TechSuppLogNewPage(Sender: TObject);
    procedure TechSuppLogPrint(Sender: TObject);
    procedure CardTurnoverNewPage(Sender: TObject);
    procedure CardTurnoverPrint(Sender: TObject);
    procedure LedgerHistoryNewPage(Sender: TObject);
    procedure LedgerHistoryPrint(Sender: TObject);
    procedure BillSplitNewPage(Sender: TObject);
    procedure BillSplitPrint(Sender: TObject);
    procedure PLUSalesNewPage(Sender: TObject);
    procedure PLUSalesPrint(Sender: TObject);
    procedure TillGroupSalesNewPage(Sender: TObject);
    procedure TillGroupSalesPrint(Sender: TObject);
    procedure HourlySalesNewPage(Sender: TObject);
    procedure HourlySalesPrint(Sender: TObject);
    procedure ClerkSalesNewPage(Sender: TObject);
    procedure ClerkSalesPrint(Sender: TObject);
    procedure TXTotalisersNewPage(Sender: TObject);
    procedure TXTotalisersPrint(Sender: TObject);
    procedure OpenTablesNewPage(Sender: TObject);
    procedure OpenTablesPrint(Sender: TObject);
    procedure NewTillGroupSalesNewPage(Sender: TObject);
    procedure NewTillGroupSalesPrint(Sender: TObject);
    procedure CustFNewPage(Sender: TObject);
    procedure CustFPrint(Sender: TObject);
  private
    CardListRec : TCardListRec;
    sTitle : string;
    bHideZeros, bEndOfDay, bDetailed, bTotals, bExtraVat, bDoEODError, bDoTillCard : boolean;
    CurrentReport : TCurrentReport;
    PrnInfo : TSBSPrintSetupInfo;
    iTillNo, iCategory, iStartNo, iEndNo : integer;
    sStartDate, sEndDate : string8;
    CustR : CustRec;
    slPrepare : TStringList;
    procedure SetHeader(sReportTitle, sColHeads : string);
    function RunReport(LocalProcessMode : TProcessMode = pmNone) : boolean;
    procedure GetEODErrorTitle;
    procedure Check4Space(iLines : byte);
    procedure PrepareCardList;
    procedure SetEODPostingTabs;
    procedure PrepareCardTurnover;
    procedure PrepareLedgerHistory;
    procedure SetLedgerHistTabs;
    function PrintHeader : boolean;
    function PagedFormat : boolean;
  public
    bConsolidate, bGotPrnInfo : boolean;
    procedure SetRunNumbers(StartRunNo, EndRunNo : integer);
    procedure PrintEODError;
    procedure PrintCardList(Order : TReportOrder);
    procedure PrintDuffTillLog(bEOD : boolean);
    procedure PrintEODLogs;
    function PrintEODPosting(bDetail : boolean) : boolean;
    procedure PrintGroupSales;
    procedure PrintCardsOnHold(Hold : THeldCards; bEOD : boolean);
    function PrintFunctionBook(iCat : integer; ProcessMode : TProcessMode) : boolean;
    function PrintBillSplit : boolean;
    function PrintPLUList : boolean;
    function CardStatement(TheCust : CustRec; sStart, sEnd : string8; bDetail : boolean) : boolean;
    function CardTurnover(sStart, sEnd : string8; bHideZs : boolean) : boolean;
    function LedgerHistory(sStart, sEnd : string8; iStart, iEnd : integer) : boolean;
    procedure PrintTechSuppLog;
    function PrintPLUSales(iTill : byte) : boolean;
    function PrintTillGroupSales(iTill : byte) : boolean;
    function PrintHourlySales(iTill : byte) : boolean;
    function PrintClerkSales(iTill : byte) : boolean;
    function PrintTXTotalisers : boolean;
    function PrintOpenTables(bHide : boolean) : boolean;
    function PrintNewTillGroupSales(iTill : byte) : boolean;
    procedure PrintCardFbyCustCodeK;
  end;

var
  ModReports: TModReports;

implementation

uses
  prntprev, MainF, RepUtil, MPComms, Comms;

{$R *.DFM}


{TGroupCacheObj: Gets and caches groups as they are needed}

Constructor TGroupCacheObj.Create;
Begin { TGroupCacheObj.Init }
  { Allocate memory for arrays }
  inherited create;
  New(DeptGroups);
  New(PLUGroups);

  { Initialise to zero }
  FillChar (DeptGroups^, SizeOf (DeptGroups^), #0);
  FillChar (PLUGroups^, SizeOf (PLUGroups^), #0);
End;  { TGroupCacheObj.Init }


Destructor  TGroupCacheObj.Done;
Begin { TGroupCacheObj.Done }
  { Free memory for arrays }
  Dispose(DeptGroups);
  Dispose(PLUGroups);
  inherited destroy;
End;  { TGroupCacheObj.Done }


Function TGroupCacheObj.GetGroupNo (Const ItemType   : Char;
                                    Const ItemNumber : LongInt) : LongInt;
Begin { TGroupCacheObj.GetGroupNo }
  Case ItemType Of
    siType_Dept, siType_DeptVoid : Result := GetDeptGroup (ItemNumber);
    siType_PLUVoid,siType_PLU      : Result := GetPLUGroup (ItemNumber);
    else Result := 1;
  End; { Case }
End;  { TGroupCacheObj.GetGroupNo }


Function TGroupCacheObj.GetDeptGroup (Const ItemNumber : LongInt) : LongInt;
Var
  InRange : Boolean;
Begin { TGroupCacheObj.GetDeptGroup }
  Result := 1;

  InRange := (ItemNumber >= Low(DeptGroups^)) And (ItemNumber <= High(DeptGroups^));

  If InRange Then Begin
    { Check to see if its already in cache }
    If (DeptGroups^[ItemNumber] = 0) Then
      { Not In Cache - get record and add into array }
      If GetDeptRec (ItemNumber) Then
        DeptGroups^[ItemNumber] := ItemRec.siGroup;

    If (DeptGroups^[ItemNumber] In [MinGroup..MaxGroup]) Then
      Result := DeptGroups^[ItemNumber];
  End { If }
  Else Begin
    { Get record from database }
    If GetDeptRec (ItemNumber) Then
      Result := ItemRec.siGroup;
  End; { If }
End;  { TGroupCacheObj.GetDeptGroup }


Function TGroupCacheObj.GetPLUGroup (Const ItemNumber : LongInt) : LongInt;
Var
  InRange : Boolean;
Begin { TGroupCacheObj.GetPLUGroup }
  Result := 1;

  InRange := (ItemNumber >= Low(PLUGroups^)) And (ItemNumber <= High(PLUGroups^));

  If InRange Then Begin
    { Check to see if its already in cache }
    If (PLUGroups^[ItemNumber] = 0) Then
      { Not In Cache - get record and add into array }
      If GetPLURec (ItemNumber) Then
        PLUGroups^[ItemNumber] := ItemRec.siGroup;

    If (PLUGroups^[ItemNumber] In [MinGroup..MaxGroup]) Then
      Result := PLUGroups^[ItemNumber];
  End { If }
  Else Begin
    { Get record from database }
    If GetPLURec (ItemNumber) Then
      Result := ItemRec.siGroup;
  End; { If }
End;  { TGroupCacheObj.GetPLUGroup }


{TModReports}

function TModReports.PrintEODPosting(bDetail : boolean) : boolean;
var
  bLock : boolean;
begin
  with TheReport do begin
    OnBeforePrint := EODPostingBeforePrint;
    OnNewPage := EODPostingNewPage;
    OnPrint := EODPostingPrint;
    Title := 'EOD Posting';
  end;{with}
  bDetailed := bDetail;

  GetMultiSys(FALSE, bLock);
  bExtraVat := not (Syss.VatMode In [vmNorm, vmDisc]);
  Result := RunReport;
end;

procedure TModReports.PrintGroupSales;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := GroupSalesNewPage;
    OnPrint := GroupSalesPrint;
    Title := 'Group Sales';
  end;{with}
  RunReport;
end;

procedure TModReports.PrintTechSuppLog;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := TechSuppLogNewPage;
    OnPrint := TechSuppLogPrint;
    Title := 'Technical Support Log';
  end;{with}
  RunReport;
end;

function TModReports.PrintFunctionBook(iCat : integer; ProcessMode : TProcessMode) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := FunctionBookNewPage;
    OnPrint := FunctionBookPrint;
    Title := 'Function Booking';
  end;{with}
  iCategory := iCat;
  PrintFunctionBook := RunReport(ProcessMode);
end;

function TModReports.PrintBillSplit : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := BillSplitNewPage;
    OnPrint := BillSplitPrint;
    Title := 'Bill Splitting';
  end;{with}
  PrintBillSplit := RunReport(pmBillSplit);
end;

function TModReports.PrintPLUList : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := PLUListNewPage;
    OnPrint := PLUListPrint;
    Title := 'Saleable Items Listing';
  end;{with}
  PrintPLUList := RunReport;
end;

procedure TModReports.PrintCardList(Order : TReportOrder);
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := CardListNewPage;
    OnPrint := CardListPrint;
    Title := 'Card List';
  end;{with}

  with CardListRec do begin
    ReportOrder := Order;
    HeldCards.OnlyShowHolds := FALSE;
    slLines := TStringList.Create;
    PrepareCardList;
    if slLines.Count > 0 then RunReport
    else MsgBox('There are no cards to print on this report',mtInformation,[mbOK],mbOK,'Card List');
    ClearList(slLines);
    slLines.Free;
  end;{with}
end;

procedure TModReports.PrintCardFbyCustCodeK;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := CustFNewPage;
    OnPrint := CustFPrint;
    Title := 'CustF by CustCodeK';
  end;{with}

  RunReport;
end;

function TModReports.PrintPLUSales(iTill : byte) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := PLUSalesNewPage;
    OnPrint := PLUSalesPrint;
    Title := 'PLU Sales';
  end;{with}
  iTillNo := iTill;
  PrintPLUSales := RunReport;
end;

function TModReports.PrintTillGroupSales(iTill : byte) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := TillGroupSalesNewPage;
    OnPrint := TillGroupSalesPrint;
    Title := 'Till Group Sales';
  end;{with}
  iTillNo := iTill;
  PrintTillGroupSales := RunReport;
end;

function TModReports.PrintHourlySales(iTill : byte) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := HourlySalesNewPage;
    OnPrint := HourlySalesPrint;
    Title := 'Hourly Sales';
  end;{with}
  iTillNo := iTill;
  PrintHourlySales := RunReport;
end;

function TModReports.PrintClerkSales(iTill : byte) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := ClerkSalesNewPage;
    OnPrint := ClerkSalesPrint;
    Title := 'Clerk Sales';
  end;{with}
  iTillNo := iTill;
  PrintClerkSales := RunReport;
end;

function TModReports.PrintTXTotalisers : boolean;
begin
  with TheReport do begin
    OnBeforePrint := LandscapeBeforePrint;
    OnNewPage := TXTotalisersNewPage;
    OnPrint := TXTotalisersPrint;
    Title := 'Transaction Totals';
  end;{with}
  PrintTXTotalisers := RunReport;
end;

procedure TModReports.PrintCardsOnHold(Hold : THeldCards; bEOD : boolean);
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := CardListNewPage;
    OnPrint := CardListPrint;
    Title := 'Cards On Hold / Over Limit';
  end;{with}

  bEndOfDay := bEOD;
  with CardListRec do begin
    ReportOrder := roByCardNumber;
    HeldCards := Hold;
    slLines := TStringList.Create;
    PrepareCardList;
    if slLines.Count > 1 then RunReport
    else begin
      if not bEOD then MsgBox('There are no cards to print on this report',mtInformation,[mbOK],mbOK,'Cards on Hold');
    end;{if}
    ClearList(slLines);
    slLines.Free;
  end;{with}
end;

procedure TModReports.PrintEODError;
var
  FileInfo : TSearchRec;
begin
  with TheReport do begin
    OnBeforePrint := EODLogsBeforePrint;
    OnNewPage := EODLogsNewPage;
    OnPrint := EODLogsPrint;
    Title := 'EOD Errors';
  end;{with}

  if FileExists('EODERROR.LOG') then
    begin
      FindFirst('EODERROR.LOG', faAnyFile, FileInfo);
      if FileInfo.Size > 0 then
        begin
          FindClose(FileInfo);
          bDoEODError := TRUE;
          bDoTillCard := FALSE;
          RunReport;
        end
      else begin
        FindClose(FileInfo);
        MsgBox('The File ''EODERROR.LOG'' is empty.',mtInformation,[mbOK],mbOK,'EODERROR.LOG');
      end;
    end
  else MsgBox('The File ''EODERROR.LOG'' does not exist.',mtInformation,[mbOK],mbOK,'EODERROR.LOG');
end;

procedure TModReports.PrintDuffTillLog(bEOD : boolean);
var
  FileInfo : TSearchRec;
begin
  with TheReport do begin
    OnBeforePrint := EODLogsBeforePrint;
    OnNewPage := EODLogsNewPage;
    OnPrint := EODLogsPrint;
    Title := 'Bad Till / Card List';
  end;{with}

  if FileExists(sDuffTillLogFile) then
    begin
      FindFirst(sDuffTillLogFile, faAnyFile, FileInfo);
      if FileInfo.Size > 0 then
        begin
          FindClose(FileInfo);
          bDoEODError := FALSE;
          bDoTillCard := TRUE;
          RunReport;
        end
      else begin
        FindClose(FileInfo);
        if not bEOD then MsgBox('The File ' + sDuffTillLogFile + ' is empty.'
        ,mtInformation,[mbOK],mbOK,'EODERROR.LOG');
      end;
    end
  else begin
    if not bEOD then MsgBox('The File ' + sDuffTillLogFile + ' does not exist.'
    ,mtInformation,[mbOK],mbOK,'EODERROR.LOG');
  end;{if}
end;

procedure TModReports.PrintEODLogs;
var
  FileInfo : TSearchRec;
begin
  with TheReport do begin
    OnBeforePrint := EODLogsBeforePrint;
    OnNewPage := EODLogsNewPage;
    OnPrint := EODLogsPrint;
    Title := 'End of Day Logs';
  end;{with}

  bDoTillCard := FALSE;
  bDoEODError := FALSE;
  if FileExists('EODERROR.LOG') then begin
    FindFirst('EODERROR.LOG', faAnyFile, FileInfo);
    if FileInfo.Size > 0 then bDoEODError := TRUE;
    FindClose(FileInfo);
  end;

  if FileExists(sDuffTillLogFile) then begin
    FindFirst(sDuffTillLogFile, faAnyFile, FileInfo);
    if FileInfo.Size > 0 then bDoTillCard := TRUE;
    FindClose(FileInfo);
  end;

  if bDoTillCard or bDoEODError then RunReport;
end;

function TModReports.CardStatement(TheCust : CustRec; sStart, sEnd : string8; bDetail : boolean) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := StatementNewPage;
    OnPrint := StatementPrint;
    Title := 'Card Statement';
  end;{with}

  CustR := TheCust;
  sStartDate := sStart;
  sEndDate := sEnd;
  bDetailed := bDetail;

  CardStatement := RunReport;
end;

function TModReports.CardTurnover(sStart, sEnd : string8; bHideZs : boolean) : boolean;
begin
  screen.cursor := crHourglass;
  Result := TRUE;
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := CardTurnoverNewPage;
    OnPrint := CardTurnoverPrint;
    Title := 'Card Turnover';
  end;{with}

  sStartDate := sStart;
  sEndDate := sEnd;
  bHideZeros := bHideZs;

  slPrepare := TStringList.Create;
  PrepareCardTurnover;
  screen.cursor := crDefault;
  if slPrepare.Count > 0 then Result := RunReport
  else MsgBox('There are no cards to print on this report',mtInformation,[mbOK],mbOK,'Card Turnover');
  ClearList(slPrepare);
  slPrepare.Free;
end;

function TModReports.RunReport(LocalProcessMode : TProcessMode = pmNone) : boolean;
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
    BaseDir := sEXEDir;
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

      // Not in the new version of Rave - Hopefully they've fixed this one !
//      if bgReportFix then RPDev.SkipAbortProc := true; // Fix for Liphook ?

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
          Free;
        end;{with}
        MsgBox('Your export file has been created.',mtInformation,[mbOK],mbOK,'File Export');
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
          FrmPrintPreview.ProcessMode := LocalProcessMode;
          FrmPrintPreview.btnProcess.Tag := iCategory;
          FrmPrintPreview.StartPreview;
        end
      else begin
        FilePrinter1.PrinterIndex := RpDev.DeviceIndex;
        FilePrinter1.FileName := RepFName;

        // Not in the new version of Rave - Hopefully they've fixed this one !
  //      if bgReportFix then RPDev.SkipAbortProc := true; // Fix for Liphook ?

        FilePrinter1.Execute;
        Screen.Cursor := crDefault;
        case LocalProcessMode of
          pmFunction : begin
            if MsgBox('Are you sure you want to process the printed functions ?',mtconfirmation,[mbYes,mbNo]
            ,mbNo,'Process Functions') = mrYes then begin
              ProcessFunctions(iCategory);
              if FrmMain.FrmFunctionList <> nil then SendMessage(FrmMain.FrmFunctionList.Handle,WM_CustGetRec,201,0);
            end;
          end;

          pmBillSplit : begin
            if MsgBox('Are you sure you want to process the printed bill split ?',mtconfirmation,[mbYes,mbNo]
            ,mbNo,'Process Bill Split') = mrYes then ProcessBillSplit;
          end;
        end;{case}
//        DeletePrintFile(RepFName);
      end;{if}
    end;{if}
    if not PrnInfo.Preview then DeletePrintFile(RepFName);
  end;{if}
  Screen.Cursor := crDefault;
  Result := bContinue;
end;

procedure TModReports.CardListNewPage(Sender: TObject);
var
  sHeader : string;
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      if CardListRec.HeldCards.OnlyShowHolds then sHeader := 'Cards on Hold / Over Limit'
      else sHeader := 'Card List';
      SetHeader(sHeader, 'Card No.' + #9 + 'Member Name' + #9 + 'Credit' + #9 + 'Spent' + #9 + 'Paid-In' + #9 + 'Balance');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.CustFNewPage(Sender: TObject);
var
  sHeader : string;
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 10, 4, 0, 0);
      sHeader := 'CustF by CustCodeK';
      SetHeader(sHeader, 'Card No.'#9'Club Code'#9'ABS No.'#9'Club No.'#9'Card Name'#9'Balance'#9'PrevCBal'#9'Exp'{ChangeFlag});
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.LandscapeBeforePrint(Sender: TObject);
begin
{  TheReport.Orientation := poLandscape;}
  SetDefaultMargins(TheReport, poLandscape);
{  TheReport.Orientation := poLandscape;     }
end;

procedure TModReports.PortraitBeforePrint(Sender: TObject);
begin
{  TheReport.Orientation := poPortrait;}
  SetDefaultMargins(TheReport, poPortrait);
{  TheReport.Orientation := poPortrait;}
end;

procedure TModReports.CardListPrint(Sender: TObject);
Var
  iMinus, iLine : integer;
Begin
  iMinus := 0;
  With TheReport, CardListRec Do Begin
    {Print StringList}
    if (not HeldCards.OnlyShowHolds) then slLines.Sort;
    For iLine := 0 to (slLines.Count - 1) do begin
      if copy(slLines[iLine], 1, 2) = '@@' then
        begin
          if not bEndOfDay then begin
            CRLF;
            SetRepFont(TheReport,fnSectionHeader, 8);
            Print(copy(slLines[iLine],3, 255));
            CRLF;
            EndOfPageLine(TheReport, PagedFormat);
          end;{if}
          inc(iMinus);
        end
      else begin
        SetRepFont(TheReport,fnMainText, 8);
        Print(copy(slLines[iLine],11, 255));
        EndOfPageLine(TheReport, PagedFormat);
      end;{if}

    end;{for}
    UpOneLine(TheReport);
    DrawLineUnder(TheReport);

    Print('Total Members : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    PrintLn(IntToStr(slLines.Count - iMinus) + #9 + #9 + #9 + MoneyToStr(rTotSpent) + #9 + MoneyToStr(rTotPaid) + #9 + MoneyToStr(rTotBalance));
  end;{with}
end;

procedure TModReports.EODLogsBeforePrint(Sender: TObject);
var
  TillCardFile : TextFile;
  sLine : string;
  bTitleFound : boolean;
  iPos : integer;
begin
  SetDefaultMargins(TheReport, poPortrait);

  sTitle := '';
  if bDoTillCard then
    begin
      CurrentReport := rTillCard;
      if FileExists(sDuffTillLogFile) then
        begin
          AssignFile(TillCardFile, sDuffTillLogFile);
          Reset(TillCardFile);
          bTitleFound := FALSE;
          Repeat
            Readln(TillCardFile,sLine);
            if sLine <> '' then begin
              iPos := Pos('Incorrect', sLine);
              if iPos <> 0 then begin
                sTitle := copy(sLine, iPos, 255);
                bTitleFound := TRUE;
              end;{if}
            end;{if}
          Until EOF(TillCardFile) or bTitleFound;
          CloseFile(TillCardFile);
        end
      else GetEODErrorTitle;
    end
  else GetEODErrorTitle;
end;

procedure TModReports.EODLogsNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      case CurrentReport of
        rTillCard : begin
          ClearTabs;
          SetTab(MarginLeft + 20, pjLeft, 20, 4, 0, 0);
          SetTab(NA, pjLeft, 20, 4, 0, 0);
          SetTab(NA, pjRight, 40, 4, 0, 0);
          SetTab(NA, pjRight, 40, 4, 0, 0);
          SetHeader(sTitle, 'Till No.' + #9 + 'ABS No.' + #9 + 'Card No.' + #9 + 'Majority Balance'
          + #9 + 'Till Balance');
          SetRepFont(TheReport,fnMainText, 8);
        end;

        rEODError : begin
          SetHeader(sTitle, '');
          SetRepFont(TheReport,fnCourier, 8);
        end;
      end;{case}
    end;{with}
  end;{if}
end;

procedure TModReports.EODLogsPrint(Sender: TObject);
var
  EODErrorFile, TillCardFile: TextFile;
  sTest, sLine : string;
  bDoNewPage, bMainText : boolean;
  iPos : integer;
begin
  bDoNewPage := FALSE;
  if FileExists(sDuffTillLogFile) and bDoTillCard then begin
    CurrentReport := rTillCard;
    AssignFile(TillCardFile, sDuffTillLogFile);
    Reset(TillCardFile);
    bMainText := FALSE;
    with TheReport do begin
      Repeat
        Readln(TillCardFile,sLine);
        if sLine <> '' then begin
          if bMainText then
            begin
              sTest := copy(sLine,1,4);
              iPos := Pos('-SBS-', sLine);
              if (sTest = '====') or (sTest = 'Till') or (sTest[1] = '') or (iPos <> 0) then
              else begin
                iPos := Pos('Incorrect', sLine);
                if iPos = 0 then
                  begin
                    Print(ExtractWords(1,1,sLine) + #9 + ExtractWords(2,1,sLine) + #9
                    + ExtractWords(3,1,sLine) + #9 + ExtractWords(4,1,sLine) + #9
                    + ExtractWords(5,1,sLine));
                    bDoNewPage := TRUE;
                    EndOfPageLine(TheReport, PagedFormat);
                  end
                else begin
                  sTitle := copy(sLine, iPos, 255);
                  YPos := YPos - LineHeight;
                  DrawLineUnder(TheReport);
                  NewPage;
                end;{if}
              end;{if}
            end
          else begin
            if copy(sLine,1,10) = '==========' then bMainText := TRUE;
          end;{if}
        end;{if}
      Until EOF(TillCardFile);
      CloseFile(TillCardFile);
      UpOneLine(TheReport);
      DrawLineUnder(TheReport);
    end;{with}
  end;{if}

  if FileExists('EODERROR.LOG') and bDoEODError then begin
    CurrentReport := rEODError;
    GetEODErrorTitle;
    AssignFile(EODErrorFile, 'EODERROR.LOG');
    Reset(EODErrorFile);
    with TheReport do begin
      if bDoNewPage then NewPage;
      Repeat
        Readln(EODErrorFile,sLine);
        if sLine <> '' then begin
          sTest := copy(sLine,1,3);
          if (sTest = 'EOD') then sTitle := sLine
          else begin
            if (sTest <> '===') then begin
              Print(sLine);
              EndOfPageLine(TheReport, PagedFormat);
            end;{if}
          end;{if}
        end;{if}
      Until EOF(EODErrorFile);
      CloseFile(EODErrorFile);
      UpOneLine(TheReport);
      DrawLineUnder(TheReport);
    end;{with}
  end;{if}
end;

procedure TModReports.GetEODErrorTitle;
var
  EODErrorFile : TextFile;
  bTitleFound : boolean;
  sLine : string;
  iPos : integer;
begin
  CurrentReport := rEODError;
  if FileExists('EODERROR.LOG') then begin
    AssignFile(EODErrorFile, 'EODERROR.LOG');
    Reset(EODErrorFile);
    bTitleFound := FALSE;
    Repeat
      Readln(EODErrorFile,sLine);
      if sLine <> '' then begin
        iPos := Pos('EOD Error', sLine);
        if iPos <> 0 then begin
          sTitle := copy(sLine, iPos, 255);
          bTitleFound := TRUE;
        end;{if}
      end;{if}
    Until EOF(EODErrorFile) or bTitleFound;
    CloseFile(EODErrorFile);
  end;{if}
end;

procedure TModReports.EODPostingBeforePrint(Sender: TObject);
begin
  if bExtraVat then SetDefaultMargins(TheReport, poLandscape)
  else SetDefaultMargins(TheReport, poPortrait);
  bTotals := FALSE;
end;

procedure TModReports.EODPostingNewPage(Sender: TObject);
var
  sColHead, sTitle : string;
begin
  if PrintHeader then begin
    if iStartNo = iEndNo then sTitle := 'Member Balance Posting Report - Run No : ' + IntToStr(iStartNo)
    else sTitle := 'Member Balance Posting Report - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);

    SetEODPostingTabs;

    if bTotals then sColHead := ''
    else begin
      if bExtraVat then sColHead := 'Card No.' + #9 + 'Member Name' + #9 + 'Date' + #9 + 'Balance B/F' + #9 + 'Reference'
      + #9 + 'Type' + #9 + 'Debit' + #9 + 'Incentive' + #9 + 'Credit' + #9 + 'Bal C/F' + #9 + 'O/D' + #9 + 'Exc. VAT' + #9 + 'VAT Paid' + #9 + 'VAT Spent'
      else sColHead := 'Card No.' + #9 + 'Member Name' + #9 + 'Date' + #9 + 'Balance B/F' + #9 + 'Reference'
      + #9 + 'Type' + #9 + 'Debit' + #9 + 'Incentive' + #9 + 'Credit' + #9 + 'Bal C/F' + #9 + 'O/D';
    end;{if}

    SetHeader(sTitle, sColHead);
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.EODPostingPrint(Sender: TObject);
Const
  FNum = InvF;
  KeyPath = InvRunNoK;
Var
  KeyS : Str255;
  ExLocal : TdExLocal;
  iStatus, iStatus2 : integer;
  rExcVAT, rVATPaid, rVATSpent, rDebitTot, rIncentiveTot, rCreditTot, Debits, Incentive, Credits
  , RNum2, rNum , rExcVATTot, rVATPaidTot, rVATSpentTot, Balance, CSpend : Real;
  GenStr, sReference : string;
  ODChar, TypeChar : Char;
  EodInv : ^EodInvRec;
  TypeTotals : Array [1..5] Of Real;
  VAT : Array [1..3] Of Real;
  iCol : byte;
  bDetailsDone : boolean;

  Function ConsolidateTillTots : Boolean;
  {Consolidates the totals for all run numbers in the range}
  Const
    FNum    = InvF;
    KeyPath = InvOurRefK;
  Var
    TmpEodInv : ^EodInvRec;
    KeyS      : Str255;
    Tots      : EodNumsType;
    I         : LongInt;
  Begin
    Result := True;
    New (TmpEodInv);
    FillChar (EodInv^, SizeOf (EodInv^), #0);
    TmpEodInv^ := EodInv^;
    With ExLocal Do begin
      For I := iStartNo To iEndNo Do Begin {for all run numbers in the range}
        KeyS := EODDocName + SetPadNo (Form_Int(I,0),6);
        iStatus := Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);
        LGetRecAddr(CustF);

        If (iStatus = 0) And (LInv.Source = isEodTot) Then
          Begin
            Move (LInv, TmpEodInv^, SizeOf (TmpEodInv^));
            For Tots := Low (EodInv^.EodNums) To High (EodInv^.EodNums) Do EodInv^.EodNums[Tots]
            := EodInv^.EodNums[Tots] + TmpEodInv^.EodNums[Tots];
          End
        Else Begin
          Result := False;
          Break;
        End;{if}
      End;{for}
    end;{with}
    Dispose (TmpEodInv);
  End;{ConsolidateTillTots}

  Function GetCardBalancesTotal : real;
  var
    TheKey : Str255;
    iStatus : integer;
  begin{GetCardBalancesTotal}
    { Build key }
    FillChar(TheKey,SizeOf(TheKey),#0);
//    TheKey := 'T' + FullNomKey(iStartNo) + CHR(1) + CHR(0);
    TheKey := 'T' + FullNomKey(iEndNo) + CHR(1) + CHR(0);

    { Get record }
    iStatus := Find_Rec(B_GetEq, F[TillSalesF], TillSalesF, ExLocal.LRecPtr[TillSalesF]^, tsMainK, TheKey);
    ExLocal.LGetRecAddr(TillSalesF);

    if iStatus = 0 then Result := ExLocal.LTillSales.tsTrans.ttAmount
    else Result := 0;
  end;{GetCardBalancesTotal}

Begin{EODPostingPrint}
  ExLocal.Create;

  { Get first record }
  KeyS := FullNomKey(iStartNo);
  iStatus := Find_Rec(B_GetGEq, F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
  ExLocal.LGetRecAddr(InvF);

  rDebitTot := 0;
  rIncentiveTot := 0;
  rCreditTot := 0;
  if bExtraVat then begin
    rExcVATTot := 0;
    rVATPaidTot := 0;
    rVATSpentTot := 0;
  end;{if}

  TypeTotals[1] := 0;
  TypeTotals[2] := 0;
  TypeTotals[3] := 0;
  TypeTotals[4] := 0;
  TypeTotals[5] := 0;

  sReference := '';
  With ExLocal, LInv, TheReport Do Begin
    While (iStatus = 0) and (RunNo >= iStartNo) and (RunNo <= iEndNo) do begin
      { Update Key for this TX }
      if GetCustFromInv(EXLocal, FALSE) then begin
        CalcInvoiceCredits(LInv, Debits, Incentive, Credits, Balance);
        sReference := SetAppName(InvDocHed,InvNetVal);

        {Work Out Type}
        Case LInv.Source of
          isUnknown   : begin
            TypeChar := '*';

            {show negative amount for recredited incentive}
            If not ZeroFloat(Credits) Then Incentive := -Incentive; {.073}
          end;

          isEodVoid   : sReference := 'Void';
          isFuncBook  : TypeChar := 'F';

          isBillSplit : begin
            TypeChar := 'B';

            {show negative amount for recredited incentive}
            If not ZeroFloat(Credits) Then Incentive := -Incentive;
          end;

          else begin
            TypeChar := ' ';

            {show negative amount for recredited incentive}
            If not ZeroFloat(Credits) Then Incentive := -Incentive;
          end;
        end; { Case }

        {Overdrawn ?}
        If (PrevBal <= 0.0) And (Balance > 0.0) Then ODChar := '*' { Gone overdrawn }
        else ODChar := ' ';

        SetRepFont(TheReport,fnMainText, 8);
        if bExtraVat then
          begin
            rExcVAT := 0;
            rVATPaid := 0;
            rVATSpent := 0;
            If (InvDocHed In ReceiptSet) then
              Begin
                rExcVAT := (Full_ITotal(LInv) * DocCnst[InvDocHed] * DocNotCnst) - InvVAT;
                rVATPaid := InvVAT;
              end
            else rVATSpent := InvVAT;

            rExcVATTot := rExcVATTot + rExcVAT;
            rVATPaidTot := rVATPaidTot + rVATPaid;
            rVATSpentTot := rVATSpentTot + rVATSpent;

            Print(CustCode + #9 + CardFullName(LCust,TRUE, TRUE) + #9 + POutDate(TransDate) + #9 + MoneyToStr(PrevBal) + #9 + sReference
            + #9 + TypeChar + #9 + MoneyToStr(Debits) + #9 + MoneyToStr(Incentive) + #9 + MoneyToStr(Credits) + #9
            + MoneyToStr(Balance) + #9 + ODChar + #9 + MoneyToStr(rExcVAT) + #9 + MoneyToStr(rVATPaid)
            + #9 + MoneyToStr(rVATSpent));
          end
        else begin
          Print(CustCode + #9 + CardFullName(LCust,TRUE, TRUE) + #9 + POutDate(TransDate) + #9 + MoneyToStr(PrevBal) + #9 + sReference
          + #9 + TypeChar + #9 + MoneyToStr(Debits) + #9 + MoneyToStr(Incentive) + #9 + MoneyToStr(Credits) + #9
          + MoneyToStr(Balance) + #9 + ODChar);
        end;{if}

        rDebitTot := rDebitTot + Debits;
        rIncentiveTot := rIncentiveTot + Incentive;
        rCreditTot := rCreditTot + Credits;

        EndOfPageLine(TheReport, PagedFormat);

        {Calc Wierd Totals}
        Case Source Of
          isEodSpend : begin
            TypeTotals[1] := TypeTotals[1] + Debits;
            TypeTotals[2] := TypeTotals[2] + Incentive;
          End;

          isEodVoid  : TypeTotals[3] := TypeTotals[3] + Credits;

          isEodTopup : Begin
            if Credits > 0 then
              begin
                TypeTotals[4] := TypeTotals[4] + Credits;
              end
            else begin
              TypeTotals[4] := TypeTotals[4] - Debits;
{              TypeTotals[6] := TypeTotals[6] + Debits;}
            end;{if}
            TypeTotals[5] := TypeTotals[5] + Incentive;
          end;
        end;{Case}

        if bDetailed then begin
          {Get Detail Lines}
          KeyS := FullNomKey(LInv.FolioNum);
          iStatus2 := Find_Rec(B_GetGEq, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdFolioK, KeyS);
          LGetRecAddr(SalesDetF);

          with TheReport do begin

            {set columns}
            ClearTabs;
            SetTab(MarginLeft + 50, pjLeft, 50, 4, 0, 0);
            SetTab(NA, pjLeft, 50, 4, 0, 0);
            SetTab(NA, pjLeft, 50, 4, 0, 0);

            iCol := 0;
            bDetailsDone := FALSE;
            while (iStatus2 = 0) and (LInv.FolioNum = LSalesDet.sdFolioNum) do begin
              bDetailsDone := TRUE;
              inc(iCol);
              {Print Line}
              SetRepFont(TheReport,fnSmallText, 8);

              Print(#9 + MoneyToStr(LSalesDet.sdQuantity) + ' x ' + LSalesDet.sdName);
              if iCol = 3 then begin
                EndOfPageLine(TheReport, PagedFormat);
                iCol := 0;
              end;{if}

              {get next record}
              iStatus2 := Find_Rec(B_GetNext, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdFolioK, KeyS);
              LGetRecAddr(SalesDetF);
            end;{while}

            if bDetailsDone then begin
              CRLF;
              EndOfPageLine(TheReport, PagedFormat);
            end;{if}

            {set columns back}
            SetEODPostingTabs;
          end;{with}
        end;{if}
      end;{if}

      { Get next record }
      iStatus := Find_Rec(B_GetNext, F[Fnum], Fnum, LRecPtr[Fnum]^, Keypath, KeyS);
      LGetRecAddr(InvF);
    end;{while}

    if sReference <> '' then begin
      {Add Line Totals}
      UpOneLine(TheReport);
      DrawLineUnder(TheReport);
      Print('Type Key : B = Bill Split,  F = Function Booking,  * = Non Till Entry' + #9 + #9 + #9 + #9
      + 'Totals :');
      SetRepFont(TheReport,fnSubTotal, 8);
      Print(#9 + #9 + MoneyToStr(rDebitTot) + #9 + MoneyToStr(rIncentiveTot) + #9 + MoneyToStr(rCreditTot));
      if bExtraVat then Print(#9 + #9 + #9 + MoneyToStr(rExcVATTot) + #9 + MoneyToStr(rVATPaidTot) + #9 + MoneyToStr(rVATSpentTot));
      CRLF;
      CRLF;
      CRLF;
      CRLF;

      {Consolidated Till Totals}

      ClearTabs;
      SetTab(MarginLeft + 14, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 16, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);

      New(EodInv);
      If ConsolidateTillTots Then
        Begin
          bTotals := TRUE;
          With EodInv^ Do Begin

            Check4Space(8);

            SetRepFont(TheReport,fnSectionHeader, 8);
            PrintLn('Consolidated Till Totals');
            CRLF;

            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Total Sales (NET TL):');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintLn(#9 + MoneyToStr(EODNums[enNetTl]));

            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Total Cash In Drawer (CAID):');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintLn(#9 + MoneyToStr(EODNums[enCaid]));

            rNum := EODNums[enCQid] + EODNums[enCd1] + EODNums[enCd2] + EODNums[enCd3] + EODNums[enCd4];
            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Total Cheque + Card1-4:');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintLn(#9 + MoneyToStr(rNum));

            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Topups (DEPO):');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintLn(#9 + MoneyToStr(EODNums[enTopup]));
            CRLF;

            If Syss.FourMbEproms Then CSpend := Round_Up(EODNums[enNetTl] - EODNums[enCaid] - RNum, 2){ 4Mb EPROMS - Topups work differently }
            Else CSpend := Round_Up(EODNums[enNetTl] - (EODNums[enCaid] + RNum - EODNums[enTopup]), 2);{ Normal EPROM's }
            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Calculated Card Spend:');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintLn(#9 + MoneyToStr(CSpend));

            CRLF;
            CRLF;
            Check4Space(4);

            SetRepFont(TheReport,fnSectionHeader, 8);
            PrintLn('Posting Report Totals');
            CRLF;

            RNum2 := TypeTotals[1] - TypeTotals[3];
            If (Round_Up((CSpend),2) = Round_Up(RNum2,2)) Then GenStr := ''
            Else GenStr := 'WARNING: Unable to reconcile Spends';
            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Card Spend - Voids:');
            SetRepFont(TheReport,fnSubTotal, 8);
            Print(#9 + MoneyToStr(RNum2));
            SetRepFont(TheReport,fnMainText, 8);
            PrintLn(#9 + #9 +GenStr);

            If (Round_Up(TypeTotals[4],2) = Round_Up(EODNums[enTopup],2)) Then GenStr := ''
            Else GenStr := 'WARNING: Unable to reconcile Topups';
            SetRepFont(TheReport,fnMainText, 8);
            Print(#9 + 'Card Topups:');
            SetRepFont(TheReport,fnSubTotal, 8);
            Print(#9 + MoneyToStr(TypeTotals[4]));
            SetRepFont(TheReport,fnMainText, 8);
            PrintLn(#9 + #9 + GenStr);
            CRLF;
            CRLF;

            { HM 21/04/99: Added Discount section for 4Mb Eproms }
            If Syss.FourMbEproms And Syss.FourMbDiscs Then Begin

              Check4Space(9);

              ClearTabs;
              SetTab(MarginLeft + 14, pjLeft, 20, 4, 0, 0);
              SetTab(NA, pjRight, 20, 4, 0, 0);

              SetRepFont(TheReport,fnSectionHeader, 8);
              PrintLn('Card Discount Analysis');
              CRLF;

              SetRepFont(TheReport,fnColHeader, 8);
              Print(#9 + #9 + 'Discount');
              DrawHorzLine(TheReport, dlThin, MarginLeft + 15, MarginLeft + 53);

              VAT[1] := 0.0;
              VAT[2] := 0.0;
              VAT[3] := 0.0;

              SetRepFont(TheReport,fnMainText, 8);

              PrintLn(#9 + 'Rate 1' + #9 + MoneyToStr(EODNums[enTax1]));
              VAT[1] := VAT[1] + EODNums[enTax1];
              PrintLn(#9 + 'Rate 2' + #9 + MoneyToStr(EODNums[enTax2]));
              VAT[1] := VAT[1] + EODNums[enTax2];
              PrintLn(#9 + 'Rate 3' + #9 + MoneyToStr(EODNums[enTax3]));
              VAT[1] := VAT[1] + EODNums[enTax3];
              PrintLn(#9 + 'Rate 4' + #9 + MoneyToStr(EODNums[enTax4]));
              VAT[1] := VAT[1] + EODNums[enTax4];

              PrintLn(#9 + 'Rate 5' + #9 + MoneyToStr(EODNums[enTaxAmt1]));
              VAT[1] := VAT[1] + EODNums[enTaxAmt1];
              PrintLn(#9 + 'Rate 6' + #9 + MoneyToStr(EODNums[enTaxAmt2]));
              VAT[1] := VAT[1] + EODNums[enTaxAmt2];
              PrintLn(#9 + 'Rate 7' + #9 + MoneyToStr(EODNums[enTaxAmt3]));
              VAT[1] := VAT[1] + EODNums[enTaxAmt3];
              Print(#9 + 'Rate 8' + #9 + MoneyToStr(EODNums[enTaxAmt4]));
              VAT[1] := VAT[1] + EODNums[enTaxAmt4];

              DrawHorzLine(TheReport, dlThin, MarginLeft + 15, MarginLeft + 53);
              SetRepFont(TheReport,fnSubTotal, 8);
              PrintLn(#9 + 'Totals :' + #9 + MoneyToStr(VAT[1]));
              CRLF;
              CRLF;
            End; { If }

            // Print Swipe Card Balances Total
            SetRepFont(TheReport,fnSectionHeader, 8);
            PrintLn('Swipe Card Balances');
            CRLF;
            SetRepFont(TheReport,fnMainText, 8);
            Print(#9'Total: ');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintLn(#9 + MoneyToStr(GetCardBalancesTotal));

          End { With }
        End { If }
      Else Begin
        Check4Space(1);
        PrintLn('Till Totals Not Available');
      End; { Else }
      Dispose(EodInv);
    end;{if}
  End; { With }
  ExLocal.Destroy; {destroy local record instance}
end;

procedure TModReports.Check4Space(iLines : byte);
begin
  with TheReport do begin
    if LinesLeft < iLines + 3 then NewPage;
  end;{with}
end;

procedure TModReports.SetRunNumbers(StartRunNo, EndRunNo : integer);
begin
  iStartNo := StartRunNo;
  iEndNo := EndRunNo;

  if iEndNo < iStartNo then iEndNo := iStartNo;

  If (iStartNo = 0) Then Begin
    { Default to last run number }
    iStartNo := GetLastRunNo;
    iEndNo := iStartNo;
  end;{if}
end;

procedure TModReports.GroupSalesNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    if iStartNo = iEndNo then sTitle := 'Consolidated Group Sales Report - Run No : ' + IntToStr(iStartNo)
    else sTitle := 'Consolidated Group Sales Report - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 14, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20 ,4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
    end;{with}
    SetHeader(sTitle, 'Group No.' + #9 + 'Group Name' + #9 + 'Sales' + #9 + 'Discount' + #9 + 'Net Sales');
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.GroupSalesPrint(Sender: TObject);
var
  RepInfo : GroupSalesInfoPtr;
  NetSales, TotSales, TotDisc : Real;
  iStatus, I : Integer;

  Procedure GetSalesData;
  { Runs through the saleable items file getting sales data for RunNo }
  Const
    FNum    = SalesDetF;
    KeyPath = sdRunCardK;
  Var
    GroupCache : TGroupCacheObj;
    KeyS       : Str255;
    I, GroupNo : LongInt;
  Begin { GetSalesData }
    GroupCache := TGroupCacheObj.create;

    { Load Groups }
    With RepInfo^ Do Begin
      FRunNo := iStartNo;
      LRunNo := iEndNo;
      For I := Low (RepInfo^.Groups) To High (RepInfo^.Groups) Do Begin
        { Get group from file or download from till }
        If GetGroupRec (I) Then;

        Groups[I].rgName     := GroupRec.grName;
        Groups[I].rgTotSales := 0.0;
        Groups[I].rgDiscAmt  := 0.0;
      End; { For }

      { Get first record }
      KeyS := ConstStr (' ', SizeOf(FRunNo));
      Move (FRunNo, KeyS[1], SizeOf(FRunNo));
      iStatus := Find_Rec (B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (iStatus = 0) And ((SalesDetRec.sdRunNo >= FRunNo) And
                          (SalesDetRec.sdRunNo <= LRunNo)) Do
        With SalesDetRec Do Begin
          { Get group number from caching object }
          GroupNo := GroupCache.GetGroupNo (sdType, sdNumber);

          { Add Sales Details into relevent group }
          If (GroupNo In [Low(Groups)..High(Groups)]) Then Begin
{            Groups[GroupNo].rgTotSales := Groups[GroupNo].rgTotSales + sdValue;
            Groups[GroupNo].rgDiscAmt  := Groups[GroupNo].rgDiscAmt  + sdDiscount;}

            Groups[GroupNo].rgTotSales := Groups[GroupNo].rgTotSales + sdValue;
            if Syss.UseSplDisc then Groups[GroupNo].rgDiscAmt  := Groups[GroupNo].rgDiscAmt  + sdDiscount;
          End; { If }

          { Get next record }
          iStatus := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
        End; { With }
    End;  { With }

    GroupCache.Done;
  End;{GetSalesData}

begin
  New(RepInfo);
  GetSalesData;

  With TheReport Do Begin
    With RepInfo^ Do Begin
      TotSales := 0.0;
      TotDisc  := 0.0;

      { Rows }
      For I := Low (RepInfo^.Groups) To High (RepInfo^.Groups) Do
        With RepInfo^.Groups[I] Do Begin
(*          If ((Not Syss.UseSplDisc) Or Syss.GrSalCalcDisc) And (Syss.Markup <> 0.00) Then Begin
            { Not using discounts by item - fake it }
            rgDiscAmt := Round_Up((rgTotSales / (100 + Syss.Markup)) * Syss.Markup,2);
          End; { If }*)

          if Syss.GrSalCalcDisc then rgDiscAmt := Round_Up((rgTotSales / (100 + Syss.Markup)) * Syss.Markup,2);

          NetSales := (rgTotSales - rgDiscAmt);
          Println(Form_Int (I, 2) + #9 + Groups[I].rgName + #9 + MoneyToStr(rgTotSales) + #9
          + MoneyToStr(rgDiscAmt) + #9 + MoneyToStr(NetSales));

          TotSales := TotSales + rgTotSales;
          TotDisc  := TotDisc  + rgDiscAmt;
        End; { With }

      { Total }
      UpOneLine(TheReport);

      DrawLineUnder(TheReport);

      NetSales := (TotSales - TotDisc);
      Print(#9 + 'Total:');
      SetRepFont(TheReport,fnSubTotal, 8);
      Println(#9 + MoneyToStr(TotSales) + #9 + MoneyToStr(TotDisc) + #9
      + MoneyToStr(NetSales));
    End; { With }
  End; { With }
  Dispose(RepInfo);
end;

procedure TModReports.PrepareCardList;
Const
  FNum    = CustF;
Var
  KeyS : Str255;
  ExLocal : TdExLocal;
  iCurrentHold, iHoldStatus : integer;
  iStatus : smallint;
  sCredit : string;
  sSort : string10;
Begin
  ExLocal.Create;

{  For iHoldStatus := 1 to 10 do begin}
  with CardListRec do begin
    rTotSpent := 0;
    rTotPaid := 0;
    rTotBalance := 0;
  end;{with}

  For iHoldStatus := 2 to 5 do begin
    if iHoldStatus in [hsOnHold, hsAllowedCredit] then iCurrentHold := hsOverLimit
    else iCurrentHold := iHoldStatus;

    if (not CardListRec.HeldCards.OnlyShowHolds) or (CardListRec.HeldCards.Status[iHoldStatus] = TRUE) then begin

      {Print SubTitle}
      if CardListRec.HeldCards.OnlyShowHolds then begin
        SetRepFont(TheReport,fnSubTotal, 8);
        with TheReport, CardListRec.slLines do begin
          case iHoldStatus of
            hsOnHold : Add('@@Cards Over Limit (on hold)');
            hsAllowedCredit : Add('@@Cards Over Limit (allowed credit)');
            hsExpired : Add('@@Expired Cards');
            hsSuspended : Add('@@Suspended Cards');
          end;{case}
        end;{with}
      end;{if}

      { Get first record }
      Blank(KeyS,SizeOf(KeyS));
      iStatus := Find_Rec (B_GetGEq, F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,CustCodeK,KeyS);
      ExLocal.LGetRecAddr(CustF);

      with CardListRec do begin
{        rTotSpent := 0;
        rTotPaid := 0;
        rTotBalance := 0;}
        With ExLocal, LCust Do Begin
          While iStatus = 0 do begin
            { Update Key for this cust }
            KeyS := CustCode;

            if ((not CardListRec.HeldCards.OnlyShowHolds) and ((Hold <> 2) Or (Not Syss.HideExpired)))

            or (CardListRec.HeldCards.OnlyShowHolds and

            {Add cards of status Expired & Suspended}
            (((Hold = iCurrentHold) and (Hold in [hsExpired, hsSuspended]))

            {Add cards that are not on hold, are overdrawn, but are allowed to go overdrawn}
            or ((Hold = 0) and AllowCredit and (CurrBalance > 0) and CardListRec.HeldCards.Status[hsAllowedCredit]
            and CardListRec.HeldCards.Status[hsOverLimit] and (iCurrentHold = hsOverLimit) and (iHoldStatus = hsAllowedCredit))

            {Add cards that are over limit and on Hold}
            or ((iCurrentHold = hsOverLimit) and (iHoldStatus = hsOnHold)
            and (Hold = hsOverLimit) and (CardListRec.HeldCards.Status[hsOnHold]))))
            then begin


              {Add Record to List}
              if AllowCredit then sCredit := 'Yes'
              else sCredit := 'No';

              case ReportOrder of
                roByCardNumber : sSort := PadString(psLeft,RemoveAllChars(CustCode,' '),'0',10);
                roByCardName : sSort := Copy(Company,1,10);
              end;{case}

              slLines.Add(sSort + CustCode + #9 + CardFullName(LCust,TRUE, TRUE) + #9 + sCredit
              + #9 + MoneyToStr(CSpent) + #9 + MoneyToStr(CPaid) + #9 + MoneyToStr(CurrBalance));
              rTotSpent := rTotSpent + CSpent;
              rTotPaid := rTotPaid + CPaid;
              rTotBalance := rTotBalance + CurrBalance;
            end;{if}

            { Get next record }
            iStatus := Find_Rec (B_GetGretr, F[Fnum], Fnum, LRecPtr[Fnum]^, CustCodeK, KeyS);
            LGetRecAddr(CustF);
          end;{while}
        end;{with}
      end;{with}

      if (not CardListRec.HeldCards.OnlyShowHolds) then begin
        ExLocal.Destroy;
        Break;
      end;
    end;{if}
  end;{for}
  ExLocal.Destroy; {destroy local record instance}
end;

procedure TModReports.FormCreate(Sender: TObject);
begin
  bConsolidate := FALSE;
end;

procedure TModReports.FunctionBookPrint(Sender: TObject);
var
  rTotalAmount : real;
  ExLocal : TdExLocal;
  TheKey : Str255;
  iStatus : smallint;
begin
  With TheReport Do Begin

    ExLocal.Create;
    ExLocal.LResetRec(InvF);

    { Build key }
    FillChar(TheKey,SizeOf(TheKey),#0);
    TheKey := 'FBK/';

    { Get first Function Booking Record record }
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, TheKey);
    ExLocal.LGetRecAddr(InvF);
    rTotalAmount := 0;

    While (iStatus = 0) And (ExLocal.LInv.CustCode = FuncKey) Do begin
      With ExLocal, LInv do Begin
        FillChar(TheKey,SizeOf(TheKey),#0);
        TheKey := OurRef;

        If ((GetCustFromInv(EXLocal, TRUE)) and ((LCust.CurrBalance < 0) Or LCust.AllowCredit))
        and ((iCategory = -1) or (iCategory = ExLocal.LInv.FBookCat)) then begin

          {Print Record}
          Print(LCust.CustCode + #9 + CardFullName(ExLocal.LCust, True, True) + #9 +
          TransDesc + #9 + MoneyToStr(InvNetVal) + #9 + MoneyToStr(Discount));

          EndOfPageLine(TheReport, PagedFormat);
          rTotalAmount := rTotalAmount + InvNetVal;
        End;

        iStatus := Find_Rec (B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK, TheKey);
        LGetRecAddr(InvF);
      end; { With }
    end;{while}
    ExLocal.Destroy;

    UpOneLine(TheReport);
    DrawLineUnder(TheReport);

    Print(#9 + #9 + 'Total : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    PrintLn(#9 + MoneyToStr(rTotalAmount));
  end;{with}
end;

procedure TModReports.FunctionBookNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetHeader('Function Booking Report', 'Card No.' + #9 + 'Member Name' + #9 + 'Description' + #9 + 'Amount' + #9 + 'Discount %');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.PLUListNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetHeader('Saleable Items Listing', 'Group'#9'Type'#9'Number'#9'Description'#9'Override'#9'Discount %'#9'Price');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.PLUListPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  iItemStatus, iGroupStatus : smallint;
  ItemKey, BlankKey : str255;
  sPrice, sOverride, sType : string;
begin
  With TheReport Do Begin

    ExLocal.Create;

    { Get first Group Record record }
    Blank(BlankKey,SizeOf(BlankKey));
    iGroupStatus := Find_Rec(B_GetGEq, F[GroupF], GroupF, ExLocal.LRecPtr[GroupF]^, GrArrayK, BlankKey);
    ExLocal.LGetRecAddr(GroupF);

    While (iGroupStatus = 0) Do begin
      With ExLocal, LGroupRec do Begin
        {Print Group Line}

        if grArrayNo = 1 then CRLF
        else begin
          CRLF;
          CRLF;
        end;{if}

        SetRepFont(TheReport,fnSubTotal, 8);
        Print(IntToStr(grArrayNo) + '. ' + TrimString(psRight,grName,' ') + '  -  ' + 'Discount % :  ' + MoneyToStr(grDiscount));
        if not EndOfPageLine(TheReport) then CRLF;

        {get first item in group}
        ItemKey := FullNomKey(grArrayNo);
        iItemStatus := Find_Rec(B_GetGEq, F[ItemF], ItemF, ExLocal.LRecPtr[ItemF]^, siGroupK, ItemKey);

        with LItemRec do begin
          while (iItemStatus = 0) and (LItemRec.siGroup = grArrayNo) do begin
            {Print Record}
            if siType = 'P' then sType := 'PLU'
            else sType := 'Dept.';

            if siOverride then sOverride := 'Yes'
            else sOverride := '';

            SetRepFont(TheReport,fnMainText, 8);

            sPrice := '';
            try
              sPrice := MoneyToStr(siPrice)
            except
            end;

            Print(#9 + sType + #9 + IntToStr(siNumber) + #9 + siName + #9 + sOverride
            + #9 + MoneyToStr(siDiscount) + #9 + sPrice);
            EndOfPageLine(TheReport, PagedFormat);

            {get next item record}
            iItemStatus := Find_Rec(B_GetNext, F[ItemF], ItemF, LRecPtr[ItemF]^, siGroupK, ItemKey);
            LGetRecAddr(ItemF);
          End;{while}
        end;{with}

        {get next group record}
        iGroupStatus := Find_Rec(B_GetNext, F[GroupF], GroupF, LRecPtr[GroupF]^, GrArrayK, BlankKey);
        LGetRecAddr(GroupF);
      end; { With }
    end;{while}
    ExLocal.Destroy;

    YPos := YPos - LineHeight;
    DrawLineUnder(TheReport);
  end;{with}
end;

procedure TModReports.StatementNewPage(Sender: TObject);
var
  iPos : integer;
  bLock : boolean;
  APicture : TPicture;
  sFileName : string;
begin
  with TheReport do begin

    {Print Name / Address in 'window'}
    if TheReport.CurrentPage = 1 then
      begin
        MarginLeft := 0;
        MarginRight := 0;
        MarginTop := 0;
        MarginBottom := 0;
        ClearTabs;
        SetTab(25, pjLeft, 2, 4, 0, 0);
        Home;
        SetRepFont(TheReport,fnSubTotal, 8);
        For iPos := 1 to 13 do CRLF;
        PrintLn(#9 + CustR.Title + ' ' + CustR.FirstName + ' ' + CustR.Company);
        For iPos := 1 to 5 do PrintLn(#9 + CustR.Addr[iPos]);


        {Print Page Header}
        SetDefaultMargins(TheReport, poPortrait);
        Home;
        CRLF;
        CRLF;
        CRLF;
        SetRepFont(TheReport,fnTitle, 8);
        GetMultiSys(FALSE, bLock);
        PrintLeft(#9 + Syss.UserName,MarginLeft + 10);
        CRLF;
        SetRepFont(TheReport,fnSubTitle, 8);
        PrintLeft(#9 + 'Customer Statement - ' + POutDate(sStartDate) + ' to ' + POutDate(sEndDate), MarginLeft + 10);
        CRLF;
        CRLF;
        SetRepFont(TheReport,fnColHeader, 8);
        PrintLeft(#9 + 'Card No. : ' + CustR.CustCode, MarginLeft + 10);

        {Print Bitmap}
        APicture := TPicture.Create;
        Try
          sFileName := sEXEDir + 'Logo.bmp';
          if FileExists(sFileName) then begin
            APicture.LoadFromFile(sFileName);
            PrintBitmapRect(PageWidth - MarginRight - 80, MarginTop, PageWidth - MarginRight, MarginTop + 50, APicture.BitMap);
          end;{if}
        Finally
          APicture.Free;
        End;
      end
    else begin
      {Print Page Header}
      if Self.PrintHeader then begin
        Home;
        SetRepFont(TheReport,fnTitle, 8);
        GetMultiSys(FALSE, bLock);
        Print(Syss.UserName);
        CRLF;
        SetRepFont(TheReport,fnSubTitle, 8);
        Print('Customer Statement - ' + POutDate(sStartDate) + ' to ' + POutDate(sEndDate));
        CRLF;
        SetRepFont(TheReport,fnColHeader, 8);
        Print('Member Name : ' + CustR.Title + ' ' + CustR.FirstName + ' ' + CustR.Company);
        CRLF;
        Print('Card No. : ' + CustR.CustCode);
      end;{if}
    end;{if}


    {set columns}
    ClearTabs;
    SetTab(MarginLeft + 20, pjRight, 20, 4, 0, 0);
    SetTab(NA, pjLeft, 30, 4, 0, 0);
    SetTab(NA, pjLeft, 45, 4, 0, 0);
    SetTab(NA, pjRight, 20, 4, 0, 0);
    SetTab(NA, pjRight, 20, 4, 0, 0);
    SetTab(NA, pjRight, 20, 4, 0, 0);
    SetTab(NA, pjRight, 20, 4, 0, 0);

    if Self.PrintHeader then begin
      {Print Column Headers}
      if TheReport.CurrentPage = 1 then begin
        For iPos := 1 to 13 do CRLF;
      end;{if}
      PrintRight('Page : ' + Macro(MidCurrentPage) + ' of ' + Macro(MidTotalPages), PageWidth - MarginRight);
      CRLF;
      CRLF;
      Print('Date' + #9 + 'Prev. Bal.' + #9 + 'Reference' + #9 + 'Comments' + #9 + 'Debit' + #9 + 'Incentive' + #9 + 'Credit' + #9 + 'Balance');
      DrawLineUnder(TheReport);
    end;{if}
  end;{with}
end;

procedure TModReports.StatementPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  KeyS : Str255;
  iStatus, iStatus2 : integer;
  rIncentive, rDebits, rCredits, rBalance : real;
  iCol : byte;
  bDetailsDone : boolean;
begin
  ExLocal.Create;

  with ExLocal do begin
    KeyS := Cust.CustCode;
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
    LGetRecAddr(InvF);
    while (iStatus = 0) and (LInv.CustCode = Cust.CustCode) do begin
      if (LInv.TransDate >= sStartDate) and (LInv.TransDate <= sEndDate) then begin
        CalcInvoiceCredits(LInv, rDebits, rIncentive, rCredits, rBalance);

        {Print Line}
        SetRepFont(TheReport,fnMainText, 8);
        TheReport.Print(POutDate(LInv.TransDate) + #9 + MoneyToStr(LInv.PrevBal) + #9 +
        GetTransDesc(LInv, rDebits) + #9 + LInv.TransDesc + #9 + MoneyToStr(rDebits) + #9 + MoneyToStr(rIncentive) + #9 + MoneyToStr(rCredits) + #9 + MoneyToStr(rBalance));
        EndOfPageLine(TheReport, PagedFormat);
        if bDetailed then begin
          {Get Detail Lines}
          KeyS := FullNomKey(LInv.FolioNum);
          iStatus2 := Find_Rec(B_GetGEq, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdFolioK, KeyS);
          LGetRecAddr(SalesDetF);

          with TheReport do begin
            {set columns}
            ClearTabs;
            SetTab(MarginLeft + 50, pjLeft, 50, 4, 0, 0);
            SetTab(NA, pjLeft, 50, 4, 0, 0);
            SetTab(NA, pjLeft, 50, 4, 0, 0);

            iCol := 0;
            bDetailsDone := FALSE;
            while (iStatus2 = 0) and (LInv.FolioNum = LSalesDet.sdFolioNum) do begin

              bDetailsDone := TRUE;
              inc(iCol);
              {Print Line}
              SetRepFont(TheReport,fnSmallText, 8);

              Print(#9 + MoneyToStr(LSalesDet.sdQuantity) + ' x ' + LSalesDet.sdName);
              if iCol = 3 then begin
                EndOfPageLine(TheReport, PagedFormat);
                iCol := 0;

                {set columns}
                ClearTabs;
                SetTab(MarginLeft + 50, pjLeft, 50, 4, 0, 0);
                SetTab(NA, pjLeft, 50, 4, 0, 0);
                SetTab(NA, pjLeft, 50, 4, 0, 0);
              end;{if}

              {get next record}
              iStatus2 := Find_Rec(B_GetNext, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdFolioK, KeyS);
              LGetRecAddr(SalesDetF);
            end;{while}

            if bDetailsDone then begin
              CRLF;
              EndOfPageLine(TheReport, PagedFormat);
            end;{if}

            {set columns back}
            ClearTabs;
            SetTab(MarginLeft + 20, pjRight, 20, 4, 0, 0);
            SetTab(NA, pjLeft, 30, 4, 0, 0);
            SetTab(NA, pjLeft, 45, 4, 0, 0);
            SetTab(NA, pjRight, 20, 4, 0, 0);
            SetTab(NA, pjRight, 20, 4, 0, 0);
            SetTab(NA, pjRight, 20, 4, 0, 0);
            SetTab(NA, pjRight, 20, 4, 0, 0);
          end;{with}
        end;{if}
      end;{if}

      {get next record}
      iStatus := Find_Rec(B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
      LGetRecAddr(InvF);
    end;{while}
    UpOneLine(TheReport);
    DrawLineUnder(TheReport);
  end;{with}
  ExLocal.Destroy;
end;

procedure TModReports.TechSuppLogNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 200, 4, 0, 0);
      SetHeader('Technical Support Log', 'System' + #9 + 'Date' + #9 + 'Time' + #9 + 'Description');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.TechSuppLogPrint(Sender: TObject);
var
  LogFile : TextFile;
  sDate, sTime, sSystem, sLine : string;
  iYear : integer;
begin
  if FileExists(sTechSupportLogFile) then begin
    AssignFile(LogFile, sTechSupportLogFile);
    Reset(LogFile);
    with TheReport do begin
      Repeat
        Readln(LogFile,sLine);
        if sLine <> '' then begin

          {convert to 4 figure year}
          sDate := ExtractWords(1,1,sLine);
          if Length(sDate) = 8 then begin
            iYear := StrToInt(Copy(sDate,7,2));
            if iYear > 80 then iYear := iYear + 1900
            else iYear := iYear + 2000;
            sDate := Copy(sDate,1,6) + IntToStr(iYear);
          end;

          {DOS or Windows}
          sTime := ExtractWords(2,1,sLine);
          if length(sTime) = 6 then
            begin
              sSystem := 'DOS';
              sLine := Copy(sLine,17,255);
            end
          else begin
            sSystem := 'Windows';
            sLine := Copy(sLine,21,255);
          end;{if}
          sTime := copy(sTime,1,5);

          {Print Line}
          Print(sSystem + #9 + sDate + #9 + sTime + #9 + sLine);
          EndOfPageLine(TheReport, PagedFormat);
        end;{if}
      Until EOF(LogFile);
      CloseFile(LogFile);
      UpOneLine(TheReport);
      DrawLineUnder(TheReport);
    end;{with}
  end;{if}
end;

procedure TModReports.SetEODPostingTabs;
begin
  with TheReport do begin
    if bExtraVat then
      begin
        ClearTabs;
        SetTab(MarginLeft + 19, pjLeft, 55, 4, 0, 0);
        SetTab(NA, pjLeft, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjLeft, 5, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 7, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
      end
    else begin
      ClearTabs;
      SetTab(MarginLeft + 14, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjRight, 16, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjRight, 5, 4, 0, 0);
      SetTab(NA, pjRight, 16, 4, 0, 0);
      SetTab(NA, pjRight, 16, 4, 0, 0);
      SetTab(NA, pjRight, 16, 4, 0, 0);
      SetTab(NA, pjRight, 16, 4, 0, 0);
      SetTab(NA, pjRight, 7, 4, 0, 0);
    end;
  end;{with}
end;

procedure TModReports.CardTurnoverNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 70, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetHeader('Card Turnover Report - ' + POutDate(sStartDate) + ' to ' + POutDate(sEndDate)
      , 'Card No.' + #9 + 'Member Name' + #9 + 'Spent' + #9 + 'Paid-In' + #9 + 'Balance');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.PrepareCardTurnover;
var
  ExLocal : TdExLocal;
  KeyS : Str255;
  iCustStatus, iInvStatus : smallint;
  TurnoverInfo : TTurnoverInfo;
  cSpentSign, cPaidSign : char;
begin
  ExLocal.Create;

  with ExLocal do begin
    Blank(KeyS,SizeOf(KeyS));
    iCustStatus := Find_Rec(B_StepFirst, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
    LGetRecAddr(CustF);
    while (iCustStatus = 0) do begin
      with LCust do begin
        { Totals are accumulated in customer record }
        CSpent := 0.00;
        CPaid  := 0.00;
        CurrBalance := 0.00;

        TurnoverInfo := TTurnoverInfo.Create;

        {Process Invoices}
        KeyS := CustCode;
        iInvStatus := Find_Rec(B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
        LGetRecAddr(InvF);
        while (iInvStatus = 0) and (LInv.CustCode = CustCode) do begin
          if (LInv.TransDate >= sStartDate) and (LInv.TransDate <= sEndDate) and
          (LInv.TransDesc <> InvDescEOY) And (LInv.TransDesc <> InvDescEOP) then begin
            CalcCustBals(LCust, LInv);
          end;{if}

          {get next inv}
          iInvStatus := Find_Rec(B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
          LGetRecAddr(InvF);
        end;{while}


        if bHideZeros and (CSpent = 0) and (CPaid = 0) and (CurrBalance = 0) then
        else begin
          {add Line}
          with TurnoverInfo do begin
            CardNo := CustCode;
            Name := CardFullName(LCust, True, True);
            Balance := CurrBalance;
            Spent := CSpent;
            PaidIn := CPaid;
          end;{with}

          {add results to stringlist}
          if LCust.CSpent < 0 then cSpentSign := '*'
          else cSpentSign := '+';

          if LCust.CPaid < 0 then cPaidSign := '*'
          else cPaidSign := '+';

          slPrepare.AddObject(cSpentSign + PadString(psLeft, MoneyToStr(CSpent), '0', 15)
          + cPaidSign + PadString(psLeft, MoneyToStr(CPaid), '0', 15), TurnoverInfo);
        end;{if}
      end;{with}

      {get next cust}
      iCustStatus := Find_Rec(B_StepNext, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
      LGetRecAddr(CustF);
    end;{while}
  end;{with}
  ExLocal.Destroy;
end;

procedure TModReports.CardTurnoverPrint(Sender: TObject);
Var
  iLine : integer;
  rTotSpent, rTotPaid, rTotBalance : real;
Begin
  rTotSpent := 0;
  rTotPaid := 0;
  rTotBalance := 0;

  With TheReport Do Begin
    {Print StringList}
    slPrepare.Sort;
    For iLine := 0 to (slPrepare.Count - 1) do begin
      SetRepFont(TheReport,fnMainText, 8);
      with TTurnoverInfo(slPrepare.Objects[iLine]) do begin
        rTotSpent := rTotSpent + Spent;
        rTotPaid := rTotPaid + PaidIn;
        rTotBalance := rTotBalance + Balance;

        Print(CardNo + #9 + Name + #9 + MoneyToStr(Spent) + #9 + MoneyToStr(PaidIn) + #9 + MoneyToStr(Balance));
        if iLine = (slPrepare.Count - 1) then CRLF
        else EndOfPageLine(TheReport, PagedFormat);
      end;{with}
    end;{for}
    UpOneLine(TheReport);
    DrawLineUnder(TheReport);

    Print('Total Members : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    PrintLn(IntToStr(slPrepare.Count) + #9 + #9 + MoneyToStr(rTotSpent) + #9 + MoneyToStr(rTotPaid) + #9 + MoneyToStr(rTotBalance));
  end;{with}
end;

function TModReports.LedgerHistory(sStart, sEnd : string8; iStart, iEnd : integer) : boolean;
var
  bLock : boolean;
begin
  screen.cursor := crHourglass;
  Result := TRUE;
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := LedgerHistoryNewPage;
    OnPrint := LedgerHistoryPrint;
    Title := 'Ledger History';
  end;{with}

  GetMultiSys(FALSE, bLock);
  bExtraVat := not (Syss.VatMode In [vmNorm, vmDisc]);

  sStartDate := sStart;
  sEndDate := sEnd;
  iStartNo := iStart;
  iEndNo := iEnd;

  slPrepare := TStringList.Create;
  PrepareLedgerHistory;
  screen.cursor := crDefault;
  if slPrepare.Count > 0 then Result := RunReport
  else MsgBox('There are no cards to print on this report',mtInformation,[mbOK],mbOK,'Ledger History');
  ClearList(slPrepare);
  slPrepare.Free;
end;


procedure TModReports.LedgerHistoryNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetLedgerHistTabs;
      if bExtraVat then SetHeader('Ledger History Report - ' + POutDate(sStartDate) + ' to ' + POutDate(sEndDate)
      , 'Date' + #9 + 'Bal. B/F' + #9 + 'Reference' + #9 + 'Debit' + #9 + 'Incentive' + #9 + 'Credit' + #9 + 'Bal. C/F' + #9 + 'Exc. VAT' + #9 + 'VAT Paid' + #9 + 'VAT Spent')
      else SetHeader('Ledger History Report - ' + POutDate(sStartDate) + ' to ' + POutDate(sEndDate)
      , 'Date' + #9 + 'Bal. B/F' + #9 + 'Reference' + #9 + 'Debit' + #9 + 'Incentive' + #9 + 'Credit' + #9 + 'Bal. C/F');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.PrepareLedgerHistory;
var
  ExLocal : TdExLocal;
  KeyS : Str255;
  iCurrCardNo : integer;
  iCustStatus : smallint;
  bAllCards : boolean;
begin
  bAllCards := (iStartNo = -1);
  ExLocal.Create;
  with ExLocal do begin
    {Get First Record}
    Blank(KeyS,SizeOf(KeyS));
    iCustStatus := Find_Rec(B_StepFirst, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
    LGetRecAddr(CustF);

    while (iCustStatus = 0) do begin
      iCurrCardNo := StrToInt(TrimString(psRight,LCust.CustCode,' '));
      if bAllCards or ((iCurrCardNo >= iStartNo) and (iCurrCardNo <= iEndNo)) then begin
        {add card}
        slPrepare.Add(PadString(psLeft, TrimString(psRight, LCust.CustCode, ' '), '0', 10)
        + CardFullName(LCust, True, True));
      end;{if}
      {Get Next}
      iCustStatus := Find_Rec(B_StepNext, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
      LGetRecAddr(CustF);
    end;{while}
  end;{with}
  ExLocal.Destroy;
end;

procedure TModReports.LedgerHistoryPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  KeyS : Str255;
  iCust, iStatus, iStatus2 : integer;
  rGrandTotExcVAT, rGrandTotVATPaid, rGrandTotVATSpent, rGrandTotDebits, rGrandTotIncentive
  , rGrandTotCredits, rTotDebits, rTotIncentive, rTotCredits, rTotExcVAT, rTotVATPaid, rTotVATSpent
  , rIncentive, rDebits, rCredits, rBalance, rExcVAT, rVATPaid, rVATSpent, rXRight : real;
  iCol : byte;
  bFoundLines, bDetailsDone : boolean;
  sCustCode : string;
begin
  rGrandTotDebits := 0;
  rGrandTotIncentive := 0;
  rGrandTotCredits := 0;
  ExLocal.Create;
  with ExLocal, TheReport do begin

    if bExtraVat then rXRight := PageWidth - MarginRight
    else rXRight := MarginLeft + 139;

    slPrepare.Sort;
    For iCust := 0 to slPrepare.Count - 1 do begin

      bFoundLines := FALSE;

      rTotDebits := 0;
      rTotIncentive := 0;
      rTotCredits := 0;
      if bExtraVAT then begin
        rTotExcVAT := 0;
        rTotVATPaid := 0;
        rTotVATSpent := 0;
      end;{if}

      sCustCode := PadString(psRight, TrimString(psLeft,copy(slPrepare[iCust],1,10),'0'), ' ', CardKeyLen);

      SetRepFont(TheReport,fnSectionHeader, 8);
      TheReport.PrintLn(sCustCode + copy(slPrepare[iCust],11,255));

      KeyS := sCustCode;
      iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
      LGetRecAddr(InvF);
      while (iStatus = 0) and (LInv.CustCode = sCustCode) do begin
        if (LInv.TransDate >= sStartDate) and (LInv.TransDate <= sEndDate) then begin
          bFoundLines := TRUE;
          CalcInvoiceCredits(LInv, rDebits, rIncentive, rCredits, rBalance);

          rTotDebits := rTotDebits + rDebits;
          rTotIncentive := rTotIncentive + rIncentive;
          rTotCredits := rTotCredits + rCredits;

          {Print Line}
          SetRepFont(TheReport,fnMainText, 8);
          if bExtraVat then
            begin
              rExcVAT := 0;
              rVATPaid := 0;
              rVATSpent := 0;
              If (LInv.InvDocHed In ReceiptSet) then
                Begin
                  rExcVAT := (Full_ITotal(LInv) * DocCnst[Linv.InvDocHed] * DocNotCnst) - LInv.InvVAT;
                  rVATPaid := LInv.InvVAT;
                end
              else rVATSpent := LInv.InvVAT;

              rTotExcVAT := rTotExcVAT + rExcVAT;
              rTotVATPaid := rTotVATPaid + rVATPaid;
              rTotVATSpent := rTotVATSpent + rVATSpent;

              TheReport.Print(POutDate(LInv.TransDate) + #9 + MoneyToStr(LInv.PrevBal) + #9 +
              GetTransDesc(LInv, rDebits) + #9 + MoneyToStr(rDebits) + #9 + MoneyToStr(rIncentive)
              + #9 + MoneyToStr(rCredits) + #9 + MoneyToStr(rBalance) + #9 + MoneyToStr(rExcVAT) + #9 + MoneyToStr(rVATPaid) + #9 + MoneyToStr(rVATSpent));
            end
          else begin
            TheReport.Print(POutDate(LInv.TransDate) + #9 + MoneyToStr(LInv.PrevBal) + #9 +
            GetTransDesc(LInv, rDebits) + #9 + MoneyToStr(rDebits) + #9 + MoneyToStr(rIncentive)
            + #9 + MoneyToStr(rCredits) + #9 + MoneyToStr(rBalance));
          end;{if}
          EndOfPageLine(TheReport, PagedFormat);

          {Get Detail Lines}
          KeyS := FullNomKey(LInv.FolioNum);
          iStatus2 := Find_Rec(B_GetGEq, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdFolioK, KeyS);
          LGetRecAddr(SalesDetF);

          {set columns}
          ClearTabs;
          SetTab(MarginLeft + 50, pjLeft, 50, 4, 0, 0);
          SetTab(NA, pjLeft, 50, 4, 0, 0);
          SetTab(NA, pjLeft, 50, 4, 0, 0);

          iCol := 0;
          bDetailsDone := FALSE;
          while (iStatus2 = 0) and (LInv.FolioNum = LSalesDet.sdFolioNum) do begin
            bDetailsDone := TRUE;
            inc(iCol);
            {Print Line}
            SetRepFont(TheReport,fnSmallText, 8);

            Print(#9 + MoneyToStr(LSalesDet.sdQuantity) + ' x ' + LSalesDet.sdName);
            if iCol = 3 then begin
              EndOfPageLine(TheReport, PagedFormat);
              iCol := 0;
            end;{if}

            {get next record}
            iStatus2 := Find_Rec(B_GetNext, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdFolioK, KeyS);
            LGetRecAddr(SalesDetF);
          end;{while}

          if bDetailsDone then begin
            EndOfPageLine(TheReport, PagedFormat);
          end;{if}

          {set columns back}
          SetLedgerHistTabs;
        end;{if}

        {get next record}
        iStatus := Find_Rec(B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
        LGetRecAddr(InvF);
      end;{while}
      UpOneLine(TheReport);

      if bFoundLines then
        begin
          {Print Cust Totals}

          {draw line}
          DrawHorzLine(TheReport, dlThin, MarginLeft + 41, rXRight);

          SetRepFont(TheReport,fnMainText, 8);
          Print(#9 + #9 + 'Totals : ');
          SetRepFont(TheReport,fnSubTotal, 8);
          if bExtraVAT then
            begin
              PrintLn(#9 + MoneyToStr(rTotDebits) + #9 + MoneyToStr(rTotIncentive) + #9
              + MoneyToStr(rTotCredits) + #9 + #9 + MoneyToStr(rTotExcVAT) + #9 + MoneyToStr(rTotVATPaid)
              + #9 + MoneyToStr(rTotVATSpent));
              rGrandTotExcVAT := rGrandTotExcVAT + rTotExcVAT;
              rGrandTotVATPaid := rGrandTotVATPaid + rTotVATPaid;
              rGrandTotVATSpent := rGrandTotVATSpent + rTotVATSpent;
            end
          else begin
            PrintLn(#9 + MoneyToStr(rTotDebits) + #9 + MoneyToStr(rTotIncentive) + #9
            + MoneyToStr(rTotCredits));
          end;{if}
          CRLF;
          rGrandTotDebits := rGrandTotDebits + rTotDebits;
          rGrandTotIncentive := rGrandTotIncentive + rTotIncentive;
          rGrandTotCredits := rGrandTotCredits + rTotCredits;
        end
      else begin
        CRLF;
        CRLF;
      end;{if}
    end;{for}
    UpOneLine(TheReport);
    DrawHorzLine(TheReport, dlThick, MarginLeft + 41, rXRight);

    SetRepFont(TheReport,fnMainText, 8);
    Print(#9 + #9 + 'Grand Totals : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    if bExtraVAT then
      begin
        PrintLn(#9 + MoneyToStr(rGrandTotDebits) + #9 + MoneyToStr(rGrandTotIncentive) + #9
        + MoneyToStr(rGrandTotCredits) + #9 + #9 + MoneyToStr(rGrandTotExcVAT) + #9 + MoneyToStr(rGrandTotVATPaid)
        + #9 + MoneyToStr(rGrandTotVATSpent));
      end
    else begin
      PrintLn(#9 + MoneyToStr(rGrandTotDebits) + #9 + MoneyToStr(rGrandTotIncentive) + #9
      + MoneyToStr(rGrandTotCredits));
    end;{if}
    CRLF;
  end;{with}
  ExLocal.Destroy;
end;

procedure TModReports.SetLedgerHistTabs;
begin
  with TheReport do begin
    ClearTabs;
    if bExtraVat then
      begin
        SetTab(MarginLeft + 20, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjLeft, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
        SetTab(NA, pjRight, 18, 4, 0, 0);
        SetTab(NA, pjRight, 18, 4, 0, 0);
        SetTab(NA, pjRight, 20, 4, 0, 0);
      end
    else begin
      SetTab(MarginLeft + 20, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 40, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
    end;{if}
  end;{with}
end;{if}

procedure TModReports.BillSplitNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjLeft, 100, 4, 0, 0);
      SetHeader('Bill Splitting Report', 'Card No.' + #9 + 'Card Name' + #9 + 'Debit' + #9 + 'Discount'
      + #9 + 'Credit' + #9 + 'Description');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.BillSplitPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  KeyS : Str255;
  iStatus : integer;
  rIncentive, rDebits, rCredits, rBalance, rTotDebits, rTotDiscount, rTotCredits : real;
begin
  ExLocal.Create;

  with ExLocal do begin
    rTotDebits := 0;
    rTotDiscount := 0;
    rTotCredits := 0;

    KeyS := MainBillSplitK;
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
    LGetRecAddr(InvF);
    While (iStatus = 0) And ((LInv.CustCode = MainBillSplitK) Or (LInv.CustCode = BillSplitCreditKey)) Do begin
      GetCustFromInv(ExLocal, TRUE);
      CalcInvoiceCredits(LInv, rDebits, rIncentive, rCredits, rBalance);
      If (rCredits <> 0.0) Then rIncentive := -rIncentive;

      {Print Line}
      SetRepFont(TheReport,fnMainText, 8);
      TheReport.Print(LInv.FBookCust + #9 + CardFullName(LCust, True, True) + #9 + MoneyToStr(rDebits)
      + #9 + MoneyToStr(rIncentive) + #9 + MoneyToStr(rCredits) + #9 + LInv.TransDesc);

      rTotDebits := rTotDebits + rDebits;
      rTotDiscount := rTotDiscount + rIncentive;
      rTotCredits := rTotCredits + rCredits;

      EndOfPageLine(TheReport, PagedFormat);

      {get next record}
      iStatus := Find_Rec(B_GetNext, F[InvF], InvF, LRecPtr[InvF]^, InvCustK, KeyS);
      LGetRecAddr(InvF);
    end;{while}
    UpOneLine(TheReport);
    DrawLineUnder(TheReport);
    SetRepFont(TheReport,fnSubTotal, 8);
    TheReport.Print(#9 + 'Totals : ' + #9 + MoneyToStr(rTotDebits) + #9 + MoneyToStr(rTotDiscount)
    + #9 + MoneyToStr(rTotCredits));
  end;{with}
  ExLocal.Destroy;
end;

procedure TModReports.PLUSalesNewPage(Sender: TObject);
var
  sColumnHeader, sTitle : string;
begin
  if PrintHeader then begin
    if iTillNo = 0 then
      begin
        if iStartNo = iEndNo then sTitle := 'PLU Sales Report (All Tills) - Run No : ' + IntToStr(iStartNo)
        else sTitle := 'PLU Sales Report (All Tills) - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
        sColumnHeader := 'Group' + #9 + 'PLU' + #9 + 'Description' + #9 + 'Non-Card Qty' + #9 + 'Non-Card Val.'
        + #9 + 'Card Qty' + #9 + 'Card Val.' + #9 + 'Total Qty' + #9 + 'Total Val.';
      end
    else begin
      if iStartNo = iEndNo then sTitle := 'PLU Sales Report (' + Syss.Till[iTillNo].Name + ') - Run No : ' + IntToStr(iStartNo)
      else sTitle := 'PLU Sales Report (' + Syss.Till[iTillNo].Name + ') - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
      sColumnHeader := 'Group' + #9 + 'PLU' + #9 + 'Description' + #9 + 'Quantity' + #9 + 'Value';
    end;{if}

    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 10, 4, 0, 0);
      SetTab(NA, pjLeft, 40, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetHeader(sTitle, sColumnHeader);
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.PLUSalesPrint(Sender: TObject);
var
  aGrandTotals, aGroupTotals : array [1..6] of Real;
  ExLocal : TdExLocal;
  TheKey : Str255;
  iPos, iStatus, iPrevGroupNo : smallint;
  slPLUSales : TStringList;
  sFindKey : string4;
  PLUSalesInfo : TPLUSalesInfo;
  rExtraWidth : real;
  iRunNo : integer;

  procedure ZeroGroupTotals;
  var
    iPos : byte;
  begin
    for iPos := 1 to 6 do aGroupTotals[iPos] := 0;
  end;{ZeroGroupTotals}

  procedure PrintGroupTotals;
  begin
    if iTillNo = 0 then TheReport.PrintLn(#9 + MoneyToStr(aGroupTotals[1]) + #9 + MoneyToStr(aGroupTotals[2])
    + #9 + MoneyToStr(aGroupTotals[3]) + #9 + MoneyToStr(aGroupTotals[4]) + #9
    + MoneyToStr(aGroupTotals[5]) + #9 + MoneyToStr(aGroupTotals[6]))
    else TheReport.PrintLn(#9 + MoneyToStr(aGroupTotals[5]) + #9 + MoneyToStr(aGroupTotals[6]));
  end;{PrintGroupTotals}

begin
  ExLocal.Create;

  slPLUSales := TStringList.Create;
  With ExLocal Do Begin

    {Creates StringList Containing All PLU Sales}

    For iRunNo := iStartNo to iEndNo do begin

      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := 'P' + FullNomKey(iRunNo) + CHR(iTillNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
      LGetRecAddr(TillSalesF);

      while (iStatus = 0) and (LTillSales.tsType = 'P')
      and (LTillSales.tsPLU.tpRunNo = iRunNo) do begin

        if (LTillSales.tsPLU.tpTillNo = iTillNo) or (iTillNo = 0) then begin

          with LTillSales do begin

            {find existing item in the list}
            sFindKey := {PadString(psLeft,IntToStr(tsPLU.tpGroupNo),'0',2)
            + }PadString(psLeft,IntToStr(tsPLU.tpPLUNo),'0',4);
            iPos := slPLUSales.IndexOf(sFindKey);

            if iPos = -1 then
              begin
                {Add new item into StringList}
                PLUSalesInfo := TPLUSalesInfo.Create;
                With PLUSalesInfo do Begin
                  GroupNo := tsPLU.tpGroupNo;
                  PLUNo := tsPLU.tpPLUNo;
                  PLUDesc := tsPLU.tpDescription;
                  CardQty := 0;
                  CardVal := 0;
                  NonCardQty := 0;
                  NonCardVal := 0;
                  TotalQty := tsPLU.tpQty;
                  TotalVal := tsPLU.tpAmount;
                  slPLUSales.AddObject(sFindKey, PLUSalesInfo);
                end;{with}
              end
            else begin
              {Update existing item in StringList}
              PLUSalesInfo := TPLUSalesInfo(slPLUSales.Objects[iPos]);
              with PLUSalesInfo do begin
                TotalQty := TotalQty + tsPLU.tpQty;
                TotalVal := TotalVal + tsPLU.tpAmount;
              end;{with}
            end;{if}
          end;{with}
        end;{if}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
        LGetRecAddr(TillSalesF);
      end;{while}
    end;{for}

    {If All Tills}
    if iTillNo = 0 then begin
      {Add Card Sales to the StringList}

      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := FullNomKey(iStartNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdRunCardK, TheKey);
      LGetRecAddr(SalesDetF);

      While (iStatus = 0) and (LSalesDet.sdRunNo <= iEndNo)
      And (LSalesDet.sdRunNo >= iStartNo) do begin

        with LSalesDet do begin

          {find existing item in the list}
          sFindKey := PadString(psLeft,IntToStr(LSalesDet.sdNumber),'0',4);
          iPos := slPLUSales.IndexOf(sFindKey);

          if iPos = -1 then
            begin
              {this should never happen}
            end
          else begin
            {Update existing item in StringList}
            PLUSalesInfo := TPLUSalesInfo(slPLUSales.Objects[iPos]);
            with PLUSalesInfo do begin
              CardQty := CardQty + sdQuantity;
              CardVal := CardVal + sdValue;
            end;{with}
          end;{if}
        end;{with}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdRunCardK, TheKey);
        LGetRecAddr(SalesDetF);
      end;{while}
    end;{if}

    {Sort List into Group / PLU order}
    For iPos := 0 to slPLUSales.Count -1 do slPLUSales[iPos] := PadString(psLeft
    ,IntToStr(TPLUSalesInfo(slPLUSales.Objects[iPos]).GroupNo),'0',2) + PadString(psLeft
    ,IntToStr(TPLUSalesInfo(slPLUSales.Objects[iPos]).PLUNo),'0',4);
    slPLUSales.Sort;

  end;{with}

  ExLocal.Destroy;

  {initialise values}
  iPrevGroupNo := -1;
  ZeroGroupTotals;

  {zero Grand Totals}
  for iPos := 1 to 6 do aGrandTotals[iPos] := 0;

  with TheReport do begin

    if (iTillNo = 0) then rExtraWidth := PageWidth - MarginRight - Marginleft - 109
    else rExtraWidth := 0;

    For iPos := 0 to slPLUSales.Count - 1 do begin

      PLUSalesInfo := TPLUSalesInfo(slPLUSales.Objects[iPos]);

      with PLUSalesInfo do begin
        {on group change}
        if GroupNo <> iPrevGroupNo then begin
          if iPrevGroupNo <> -1 then begin
            {print previous group's totals}
            UpOneLine(TheReport);
            DrawHorzLine(TheReport, dlThin, MarginLeft + 21, Marginleft + 109 + rExtraWidth);
            Print(#9 + #9 + 'Group Total : ');
            SetRepFont(TheReport,fnSubTotal, 8);
            PrintGroupTotals;
            PrintLn('');
          end;{if}

          {Print Group Title}
          GetGroupRec(GroupNo);
          SetRepFont(TheReport,fnSubTotal, 8);
          Print(GroupRec.grName);
          EndOfPageLine(TheReport, PagedFormat);

          ZeroGroupTotals;
        end;

        {Calculate Non-Card Figures}
        NonCardQty := TotalQty - CardQty;
        NonCardVal := TotalVal - CardVal;

        {Print Record}
        SetRepFont(TheReport,fnMainText, 8);
        if iTillNo = 0 then Print(#9 + IntToStr(PLUNo) + #9 + PLUDesc + #9 + MoneyToStr(NonCardQty) + #9 + MoneyToStr(NonCardVal)
        + #9 + MoneyToStr(CardQty) + #9 + MoneyToStr(CardVal) + #9 + MoneyToStr(TotalQty) + #9 + MoneyToStr(TotalVal))
        else Print(#9 + IntToStr(PLUNo) + #9 + PLUDesc + #9 + MoneyToStr(TotalQty) + #9 + MoneyToStr(TotalVal));
        EndOfPageLine(TheReport, PagedFormat);

        {save prev group}
        iPrevGroupNo := GroupNo;

        {Increment Group Totals}
        aGroupTotals[1] := aGroupTotals[1] + NonCardQty;
        aGroupTotals[2] := aGroupTotals[2] + NonCardVal;
        aGroupTotals[3] := aGroupTotals[3] + CardQty;
        aGroupTotals[4] := aGroupTotals[4] + CardVal;
        aGroupTotals[5] := aGroupTotals[5] + TotalQty;
        aGroupTotals[6] := aGroupTotals[6] + TotalVal;

        {Increment Grand Totals}
        aGrandTotals[1] := aGrandTotals[1] + NonCardQty;
        aGrandTotals[2] := aGrandTotals[2] + NonCardVal;
        aGrandTotals[3] := aGrandTotals[3] + CardQty;
        aGrandTotals[4] := aGrandTotals[4] + CardVal;
        aGrandTotals[5] := aGrandTotals[5] + TotalQty;
        aGrandTotals[6] := aGrandTotals[6] + TotalVal;
      end;{with}
    end;{for}

    {Print Last Group Total}
    UpOneLine(TheReport);
    DrawHorzLine(TheReport, dlThin, MarginLeft + 21, Marginleft + 109 + rExtraWidth);
    Print(#9 + #9 + 'Group Total : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    PrintGroupTotals;

    {Print Grand Total}
    UpOneLine(TheReport);
    DrawHorzLine(TheReport, dlThick, MarginLeft + 21, Marginleft + 109 + rExtraWidth);
    Print(#9 + #9 + 'Grand Total : ');
    SetRepFont(TheReport,fnSubTotal, 8);

    if iTillNo = 0 then PrintLn(#9 + MoneyToStr(aGrandTotals[1]) + #9 + MoneyToStr(aGrandTotals[2])
    + #9 + MoneyToStr(aGrandTotals[3]) + #9 + MoneyToStr(aGrandTotals[4]) + #9
    + MoneyToStr(aGrandTotals[5]) + #9 + MoneyToStr(aGrandTotals[6]))
    else TheReport.PrintLn(#9 + MoneyToStr(aGrandTotals[5]) + #9 + MoneyToStr(aGrandTotals[6]));
  end;{with}
  ClearList(slPLUSales);
  slPLUSales.Free;
end;

procedure TModReports.TillGroupSalesNewPage(Sender: TObject);
var
  sTitle : string;
begin
  if PrintHeader then begin
    if iTillNo = 0 then
      begin
        if iStartNo = iEndNo then sTitle := 'Till Group Sales Report (All Tills) - Run No : ' + IntToStr(iStartNo)
        else sTitle := 'Till Group Sales Report (All Tills) - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
      end
    else begin
      if iStartNo = iEndNo then sTitle := 'Till Group Sales Report (' + Syss.Till[iTillNo].Name + ') - Run No : ' + IntToStr(iStartNo)
      else sTitle := 'Till Group Sales Report (' + Syss.Till[iTillNo].Name + ') - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
    end;{if}

    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 15, pjLeft, 40, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetHeader(sTitle, 'Group No' + #9 + 'Description' + #9 + 'PLU Qty' + #9 + 'PLU Value');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.TillGroupSalesPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  TheKey : Str255;
  iPos, iStatus : smallint;
  slGroupSales : TStringList;
  sFindKey : string2;
  GroupSalesInfo : TGroupSalesInfo;
  rTotDeptVal, rTotDeptQty, rTotPLUVal, rTotPLUQty, rTotTotVal, rTotTotQty : real;
  iRunNo : integer;
begin
  ExLocal.Create;
  slGroupSales := TStringList.Create;
  With ExLocal Do Begin

    For iRunNo := iStartNo to iEndNo do begin

      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := 'P' + FullNomKey(iRunNo) + CHR(iTillNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
      LGetRecAddr(TillSalesF);

      While (iStatus = 0) and (LTillSales.tsType = 'P')
      and (LTillSales.tsPLU.tpRunNo = iRunNo) do begin

        if (LTillSales.tsPLU.tpTillNo = iTillNo) or (iTillNo = 0) then begin

          with LTillSales do begin

            {find existing item in the list}
            sFindKey := PadString(psLeft,IntToStr(tsPLU.tpGroupNo),'0',2);
            iPos := slGroupSales.IndexOf(sFindKey);

            if iPos = -1 then
              begin
                {Add new item into StringList}
                GroupSalesInfo := TGroupSalesInfo.Create;
                With GroupSalesInfo do begin
                  GroupNo := tsPLU.tpGroupNo;
                  DeptQty := 0;
                  DeptValue := 0;
                  PLUQty := tsPLU.tpQty;
                  PLUValue := tsPLU.tpAmount;
                  TotalQty := tsPLU.tpQty;
                  TotalValue := tsPLU.tpAmount;

                  slGroupSales.AddObject(sFindKey, GroupSalesInfo);
                end;{with}
              end
            else begin
              {Update existing item in StringList}
              GroupSalesInfo := TGroupSalesInfo(slGroupSales.Objects[iPos]);
              with GroupSalesInfo do begin
                PLUQty := PLUQty + tsPLU.tpQty;
                PLUValue := PLUValue + tsPLU.tpAmount;
                TotalQty := TotalQty + tsPLU.tpQty;
                TotalValue := TotalValue + tsPLU.tpAmount;
              end;{with}
            end;{if}
          end;{with}
        end;{if}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
        LGetRecAddr(TillSalesF);
      end;{while}
    end;{for}
    slGroupSales.Sort;
    ExLocal.Destroy;
  end;{with}

  {initialise values}
  rTotDeptQty := 0;
  rTotDeptVal := 0;
  rTotPLUQty := 0;
  rTotPLUVal := 0;
  rTotTotQty := 0;
  rTotTotVal := 0;

  with TheReport do begin

    For iPos := 0 to slGroupSales.Count - 1 do begin

      GroupSalesInfo := TGroupSalesInfo(slGroupSales.Objects[iPos]);

      with GroupSalesInfo do begin

        {Print Record}
        GetGroupRec(GroupNo);
        SetRepFont(TheReport,fnMainText, 8);

        Print(IntToStr(GroupNo) + #9 + GroupRec.grName + #9 + MoneyToStr(PLUQty) + #9 + MoneyToStr(PLUValue));

        EndOfPageLine(TheReport, PagedFormat);

        {Increment Totals}
        rTotDeptQty := rTotDeptQty + DeptQty;
        rTotDeptVal := rTotDeptVal + DeptValue;
        rTotPLUQty := rTotPLUQty + PLUQty;
        rTotPLUVal := rTotPLUVal + PLUValue;
        rTotTotQty := rTotTotQty + TotalQty;
        rTotTotVal := rTotTotVal + TotalValue;
      end;{with}
    end;{for}

    {Print Grand Total}
    UpOneLine(TheReport);
    DrawHorzLine(TheReport, dlThick, MarginLeft + 16, MarginLeft + 93.75);
    Print(#9 + 'Totals : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    PrintLn(#9 + MoneyToStr(rTotPLUQty) + #9 + MoneyToStr(rTotPLUVal));
  end;{with}
  ClearList(slGroupSales);
  slGroupSales.Free;
end;

procedure TModReports.HourlySalesNewPage(Sender: TObject);
var
  sTitle : string;
begin
  if PrintHeader then begin
    if iTillNo = 0 then
      begin
        if iStartNo = iEndNo then sTitle := 'Hourly Sales Report (All Tills) - Run No : ' + IntToStr(iStartNo)
        else sTitle := 'Hourly Sales Report (All Tills) - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
      end
    else begin
      if iStartNo = iEndNo then sTitle := 'Hourly Sales Report (' + Syss.Till[iTillNo].Name + ') - Run No : ' + IntToStr(iStartNo)
      else sTitle := 'Hourly Sales Report (' + Syss.Till[iTillNo].Name + ') - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
    end;{if}

    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 8, pjLeft, 2, 4, 0, 0);
      SetTab(NA, pjLeft, 20, 4, 0, 0);
      SetTab(NA, pjRight, 30, 4, 0, 0);
      SetTab(NA, pjRight, 30, 4, 0, 0);
      SetTab(NA, pjRight, 40, 4, 0, 0);
      SetHeader(sTitle, 'From' + #9 + #9 + 'To' + #9 + 'No. Of Sales' + #9 + 'Total Net Spend' + #9 + 'Average Spend');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.HourlySalesPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  TheKey : Str255;
  iPos, iStatus : smallint;
  slHourlySales : TStringList;
  sFindKey : string2;
  HourlyInfo : THourlyInfo;
  rTotalQty, rTotalValue : real;
  sDescription : string;
  iRunNo : integer;
begin
  ExLocal.Create;
  slHourlySales := TStringList.Create;
  With ExLocal Do Begin

    For iRunNo := iStartNo to iEndNo do begin
      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := 'H' + FullNomKey(iRunNo) + CHR(iTillNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
      LGetRecAddr(TillSalesF);

      While (iStatus = 0) and (LTillSales.tsType = 'H')
      and (LTillSales.tsHourly.thRunNo = iRunNo) do begin

        if (LTillSales.tsHourly.thTillNo = iTillNo) or (iTillNo = 0) then begin

          with LTillSales do begin

            {find existing item in the list}
            sFindKey := PadString(psLeft,IntToStr(tsHourly.thHourNo),'0',2);
            iPos := slHourlySales.IndexOf(sFindKey);

            if iPos = -1 then
              begin
                {Add new item into StringList}
                HourlyInfo := THourlyInfo.Create;
                With HourlyInfo do begin

                  HourNo := tsHourly.thHourNo;
                  Qty := tsHourly.thQty;
                  Value := tsHourly.thAmount;

                  slHourlySales.AddObject(sFindKey, HourlyInfo);
                end;{with}
              end
            else begin
              {Update existing item in StringList}
              HourlyInfo := THourlyInfo(slHourlySales.Objects[iPos]);
              with HourlyInfo do begin
                Qty := Qty + tsHourly.thQty;
                Value := Value + tsHourly.thAmount;
              end;{with}
            end;{if}
          end;{with}
        end;{if}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
        LGetRecAddr(TillSalesF);
      end;{while}
    end;{for}
    slHourlySales.Sort;
    ExLocal.Destroy;
  end;{with}

  {initialise values}
  rTotalQty := 0;
  rTotalValue := 0;

  with TheReport do begin

    For iPos := 0 to slHourlySales.Count - 1 do begin

      HourlyInfo := THourlyInfo(slHourlySales.Objects[iPos]);

      with HourlyInfo do begin

        sDescription := PadString(psLeft,IntToStr(HourNo - 1),'0',2) + ':00' + #9 + '-' + #9
        + slHourlySales[iPos] + ':00';

        {Print Record}
        SetRepFont(TheReport,fnMainText, 8);
        Print(sDescription + #9 + MoneyToStr(Qty) + #9 + MoneyToStr(Value) + #9 + MoneyToStr(SafeDiv(Value,Qty)));
        EndOfPageLine(TheReport, PagedFormat);

        {Increment Totals}
        rTotalQty := rTotalQty + Qty;
        rTotalValue := rTotalValue + Value;
      end;{with}
    end;{for}

    {Print Grand Total}
    UpOneLine(TheReport);
    DrawHorzLine(TheReport, dlThick, MarginLeft, MarginLeft + 129);
    Print('Totals : ');
    SetRepFont(TheReport,fnSubTotal, 8);
    PrintLn(#9 + #9 + #9 + MoneyToStr(rTotalQty) + #9 + MoneyToStr(rTotalValue) + #9
    + MoneyToStr(SafeDiv(rTotalValue, rTotalQty)));
  end;{with}
  ClearList(slHourlySales);
  slHourlySales.Free;
end;

procedure TModReports.ClerkSalesNewPage(Sender: TObject);
var
  sTitle : string;
begin
  if PrintHeader then begin
    if iTillNo = 0 then
      begin
        if iStartNo = iEndNo then sTitle := 'Clerk Sales Report (All Tills) - Run No : ' + IntToStr(iStartNo)
        else sTitle := 'Clerk Sales Report (All Tills) - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
      end
    else begin
      if iStartNo = iEndNo then sTitle := 'Clerk Sales Report (' + Syss.Till[iTillNo].Name + ') - Run No : ' + IntToStr(iStartNo)
      else sTitle := 'Clerk Sales Report (' + Syss.Till[iTillNo].Name + ') - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
    end;{if}

    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 30, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetTab(NA, pjRight, 20, 4, 0, 0);
      SetHeader(sTitle, 'Clerk' + #9 + 'Transaction Type' + #9 + 'Quantity' + #9 + 'Value');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.ClerkSalesPrint(Sender: TObject);
var
  ExLocal : TdExLocal;
  TheKey : Str255;
  iLastClerkNo, iPos, iStatus : smallint;
  slClerkSales : TStringList;
  sFindKey : string4;
  ClerkRepInfo : TClerkRepInfo;
  iRunNo : integer;
const
  aClerkTXTypes : Array[1..24] of string = (
  {01}'Sales',
  {02}'02',
  {03}'03',
  {04}'Cash in Drawer',
  {05}'05',
  {06}'06',
  {07}'07',
  {08}'08',
  {09}'No Sales',
  {10}'Voids',
  {11}'Returns',
  {12}'12',
  {13}'13',
  {14}'14',
  {15}'15',
  {16}'16',
//  {17}'17',
  {17}'Tips',
  {18}'18',
  {19}'19',
  {20}'20',
  {21}'21',
  {22}'22',
  {23}'23',
  {24}'24');
begin
  ExLocal.Create;
  slClerkSales := TStringList.Create;
  With ExLocal Do Begin

    For iRunNo := iStartNo to iEndNo do begin
      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := 'C' + FullNomKey(iRunNo) + CHR(iTillNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
      LGetRecAddr(TillSalesF);

      While (iStatus = 0) and (LTillSales.tsType = 'C')
      and (LTillSales.tsClerk.tcRunNo = iRunNo) do begin

        with LTillSales do begin
          if (tsClerk.tcTillNo = iTillNo) or (iTillNo = 0) then begin

            {find existing item in the list}
            sFindKey := PadString(psLeft,IntToStr(tsClerk.tcClerkNo),'0',2)
            + PadString(psLeft,IntToStr(tsClerk.tcDataType),'0',2);
            iPos := slClerkSales.IndexOf(sFindKey);

            if iPos = -1 then
              begin
                {Add new item into StringList}
                ClerkRepInfo := TClerkRepInfo.Create;
                With ClerkRepInfo do begin
                  ClerkNo := tsClerk.tcClerkNo;
                  ClerkName := tsClerk.tcDescription;
                  Description := aClerkTXTypes[tsClerk.tcDataType];
                  Qty := tsClerk.tcQty;
                  Value := tsClerk.tcAmount;
                  slClerkSales.AddObject(sFindKey, ClerkRepInfo);
                end;{with}
              end
            else begin
              {Update existing item in StringList}
              ClerkRepInfo := TClerkRepInfo(slClerkSales.Objects[iPos]);
              with ClerkRepInfo do begin
                Qty := Qty + tsClerk.tcQty;
                Value := Value + tsClerk.tcAmount;
              end;{with}
            end;{if}
          end;{if}
        end;{with}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
        LGetRecAddr(TillSalesF);
      end;{while}
    end;{for}
    slClerkSales.Sort;
    ExLocal.Destroy;
  end;{with}

  with TheReport do begin
    iLastClerkNo := -1;
    For iPos := 0 to slClerkSales.Count - 1 do begin
      ClerkRepInfo := TClerkRepInfo(slClerkSales.Objects[iPos]);
      with ClerkRepInfo do begin

        if iLastClerkNo <> ClerkNo then begin
          {Print Clerk}
          SetRepFont(TheReport,fnSubTotal, 8);
          if iLastClerkNo <> -1 then PrintLn('');
          Print(ClerkName);
          EndOfPageLine(TheReport, PagedFormat);
        end;{if}

        {Print Record}
        SetRepFont(TheReport,fnMainText, 8);
        Print(#9 + Description + #9 + MoneyToStr(Qty) + #9 + MoneyToStr(Value));
        EndOfPageLine(TheReport, PagedFormat);

        {store last clerk no}
        iLastClerkNo := ClerkNo;
      end;{with}
    end;{for}
  end;{with}
  ClearList(slClerkSales);
  slClerkSales.Free;
end;

procedure TModReports.TXTotalisersNewPage(Sender: TObject);
var
  sHeader, sTitle : string;
  iTillNo : byte;
begin
  if PrintHeader then begin
    if iStartNo = iEndNo then sTitle := 'Transaction Totals Report - Run No : ' + IntToStr(iStartNo)
    else sTitle := 'Transaction Totals Report - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);

    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 25, pjRight, 14, 4, 0, 0);
      SetTab(NA, pjRight, 14, 4, 0, 0);

      sHeader := 'Transaction Type';
      For iTillNo := 1 to Syss.NoTills do begin
        if iTillNo = Syss.NoTills then
          begin
            SetTab(NA, pjRight, 18.5, 4, 0, 0);
            SetTab(NA, pjRight, 18.5, 4, 0, 0);
          end
        else begin
          SetTab(NA, pjRight, 14, 4, 0, 0);
          SetTab(NA, pjRight, 14, 4, 0, 0);
        end;{if}
        sHeader := sHeader + #9 + 'Till ' + IntToStr(iTillNo) + ' Qty' + #9 + 'Till ' + IntToStr(iTillNo) + ' Val.';
      end;{for}
      sHeader := sHeader + #9 + 'Total Qty' + #9 + 'Total Value';

      SetHeader(sTitle, sHeader);
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.TXTotalisersPrint(Sender: TObject);
const
  MAXTRANSNO = 100;
  NO_ORDERED = 22;
  aLineOrder : array [1..NO_ORDERED] of Integer = (12,13,14,96,19,20,21,22,23,24,25,26,30,27,48,49,50,51,52,53,55,77);
var
  ExLocal : TdExLocal;
  TheKey : Str255;
  iLine, iTransNo, iStatus : smallint;
  aTXRec : array [1..MAXTRANSNO] of TTXRec;
  iTillNo : byte;
  bThermal : boolean;
  iRunNo : integer;

  Procedure PrintLine(iTransNo : smallint);
  var
    iTillNo : byte;
    sLine : string;
  begin
    {zero totals}
    aTXRec[iTransNo].aQty[Syss.NoTills + 1] := 0;
    aTXRec[iTransNo].aValue[Syss.NoTills + 1] := 0;

    {calculate totals}
    For iTillNo := 1 to Syss.NoTills do begin
      aTXRec[iTransNo].aQty[Syss.NoTills + 1] := aTXRec[iTransNo].aQty[Syss.NoTills + 1]
      + aTXRec[iTransNo].aQty[iTillNo];
      aTXRec[iTransNo].aValue[Syss.NoTills + 1] := aTXRec[iTransNo].aValue[Syss.NoTills + 1]
      + aTXRec[iTransNo].aValue[iTillNo];
    end;{for}

    if not ((aTXRec[iTransNo].aQty[Syss.NoTills + 1] = 0) and (aTXRec[iTransNo].aValue[Syss.NoTills + 1] = 0))
    then begin
      {create output line}
      sLine := aTXRec[iTransNo].sDesc + #9;
      for iTillNo := 1 to Syss.NoTills + 1 do sLine := sLine + MoneyToStr(aTXRec[iTransNo].aQty[iTillNo])
      + #9 + MoneyToStr(aTXRec[iTransNo].aValue[iTillNo]) + #9;

      {print line}
      SetRepFont(TheReport,fnMainText, 8);
      TheReport.Print(sLine);
      EndOfPageLine(TheReport, PagedFormat);
    end;{if}
  end;{PrintLine}

  Function GetTransDesc(iTransNo : integer; bJustNumbers : boolean): string;
  begin
    if bThermal then
      begin
        {THERMAL}

        if bJustNumbers then iTransNo := iTransNo + 1000;

        case iTransNo of
          12 : Result := 'Total';
          13 : Result := 'Gross Total';
          14 : Result := 'Void - R';
          15 : Result := 'Return';
          18 : Result := 'Manual Disc.';
          19..26 : Result := 'Disc ' + IntToStr(iTransNo - 18);
          27 : Result := 'Net Total';
          30 : Result := 'Sales Total';
{          39 : Result := 'Refund';}
          48 : Result := 'Cash in Drawer';
          49 : Result := 'Cheque';
          50..53 : Result := 'Credit Card ' + IntToStr(iTransNo - 49);
          55 : Result := 'Deposits';
          77 : Result := 'Swiped';
          96 : Result := 'Void - V';
          else begin
            if bJustNumbers then Result := IntToStr(iTransNo - 1000)
            else Result := '**DONOTPRINTTHISLINE**';
          end;
        end;{case}
      end
    else begin
      {DOT MATRIX}
      case iTransNo of
        12 : Result := 'Total';
        13 : Result := 'Gross Total';
        14 : Result := 'Void';
        15 : Result := 'Return';
        18 : Result := 'Discount';
        23 : Result := 'Net Total';
        35 : Result := 'Negative Total';
        43 : Result := 'Cash In Drawer';
        44 : Result := 'Cheque';
        45..48 : Result := 'Credit Card ' + IntToStr(iTransNo - 44);
        50 : Result := 'Deposits';
        else begin
          if LoginMode = lmDebug then Result := IntToStr(iTransNo)
          else Result := '**DONOTPRINTTHISLINE**';
        end;
      end;{case}
    end;
  end;{GetTransDesc}

begin{TXTotalisersPrint}
  ExLocal.Create;
  bThermal := Syss.FourMbEproms;
  With ExLocal Do Begin

    {Initialise All Trans}
    for iTransNo := 1 to MAXTRANSNO do begin
      {set array lengths}
      aTXRec[iTransNo].sDesc := '**DONOTPRINTTHISLINE**';
      setlength(aTXRec[iTransNo].aValue, Syss.NoTills + 2);
      setlength(aTXRec[iTransNo].aQty, Syss.NoTills + 2);

      {initialise arrays}
      for iTillNo := 1 to Syss.NoTills + 1 do begin
        aTXRec[iTransNo].aQty[iTillNo] := 0;
        aTXRec[iTransNo].aValue[iTillNo] := 0;
      end;{for}
    end;{for}

    For iRunNo := iStartNo to iEndNo do begin
      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := 'T' + FullNomKey(iRunNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
      LGetRecAddr(TillSalesF);

      While (iStatus = 0) and (LTillSales.tsType = 'T') and (LTillSales.tsTrans.ttRunNo = iRunNo) do begin

        iTransNo := LTillSales.tsTrans.ttTransNo;

        if iTransNo <= MAXTRANSNO then begin
          {increment Qty and Value totals in arrays}
          aTXRec[iTransNo].aValue[LTillSales.tsTrans.ttTillNo] := aTXRec[iTransNo].aValue[LTillSales.tsTrans.ttTillNo]
          + LTillSales.tsTrans.ttAmount;
          aTXRec[iTransNo].aQty[LTillSales.tsTrans.ttTillNo] := aTXRec[iTransNo].aQty[LTillSales.tsTrans.ttTillNo]
          + LTillSales.tsTrans.ttQty;
        end;{if}

        {Next Record}
        iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
        LGetRecAddr(TillSalesF);
      end;{while}
    end;{for}

    if bThermal then begin
      {Print Lines}
      For iLine := 1 to NO_ORDERED do begin

        iTransNo := aLineOrder[iLine];

        {set Totaliser Description}
        aTXRec[iTransNo].sDesc := GetTransDesc(iTransNo, FALSE);
        if (aTXRec[iTransNo].sDesc <> '**DONOTPRINTTHISLINE**') then PrintLine(iTransNo);
      end;{for}
    end;

    {Print Lines}
    if (not bThermal) or (LoginMode = lmDebug) then begin

      if (LoginMode = lmDebug) and bThermal then begin
        TheReport.Print('');
        EndOfPageLine(TheReport, PagedFormat);
      end;{if}

      For iTransNo := 1 to MAXTRANSNO do begin
        {set Totaliser Description}

        aTXRec[iTransNo].sDesc := GetTransDesc(iTransNo, TRUE);

        if (aTXRec[iTransNo].sDesc <> '**DONOTPRINTTHISLINE**') then PrintLine(iTransNo);
        setlength(aTXRec[iTransNo].aValue, 0);
        setlength(aTXRec[iTransNo].aQty, 0);
      end;{for}
    end;{if}

    ExLocal.Destroy;
  end;{with}
end;

procedure TModReports.SetHeader(sReportTitle, sColHeads : string);
var
  bLock : boolean;
begin
  GetMultiSys(FALSE, bLock);
  SetStandardHeader(TheReport, Syss.UserName, sReportTitle, sColHeads, PagedFormat);
end;

function TModReports.PrintOpenTables(bHide : boolean) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := OpenTablesNewPage;
    OnPrint := OpenTablesPrint;
    Title := 'Open Tables';
  end;{with}
  bHideZeros := bHide;
  Result := RunReport;
end;

procedure TModReports.OpenTablesNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 20, pjLeft, 50, 4, 0, 0);
      SetTab(NA, pjRight, 30, 4, 0, 0);
      SetHeader('Open Tables', 'Track No.' + #9 + 'Name' + #9 + 'Balance');
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.OpenTablesPrint(Sender: TObject);
Var
  iTotBalance, iBalance, iTrackNo : integer;
  CardRec : TCardRec;
  FrmProgress : TFrmProgress;
Begin
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  try
    {show Progress}
    FrmProgress := TFrmProgress.Create(application);
    with FrmProgress do begin
      Caption := 'Checking Open Tables...';
      Show;
      BringToFront;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := iEndNo;
      FrmProgress.lStatus.Caption := 'Processing Tables';
      Refresh;
    end;{with}

    {run report}
    iTotBalance := 0;
    with TheReport do begin
      for iTrackNo := iStartNo to iEndNo do begin
        FrmProgress.lName.Caption := 'Track ' + IntToStr(iTrackNo);
        FrmProgress.lName.Refresh;
        if FrmComms.WaitForBalance(1, iTrackNo, iBalance) then begin
          if FrmComms.GetCardInfo(1, iTrackNo, CardRec) then begin
            if (not bHideZeros) or (bHideZeros and (iBalance <> 0)) then begin
              Print(IntToStr(iTrackNo) + #9 + CardRec.Name + #9 + PenceToStr(iBalance));
              EndOfPageLine(TheReport, PagedFormat);
              iTotBalance := iTotBalance + iBalance;
            end;{if}
          end;{if}
        end;{if}
        FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
      end;{for}

      {totals}
      UpOneLine(TheReport);
      SetRepFont(TheReport,fnSubTotal, 8);
      DrawHorzLine(TheReport, -2, MarginLeft, MarginLeft + 99);
      Print(#9 + 'Total :' + #9 + PenceToStr(iTotBalance));
    end;{with}
  finally
    FrmProgress.Release;
  end;{try}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
end;

function TModReports.PrintNewTillGroupSales(iTill : byte) : boolean;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := NewTillGroupSalesNewPage;
    OnPrint := NewTillGroupSalesPrint;
    Title := 'Till Group Sales';
  end;{with}
  iTillNo := iTill;
  Result := RunReport;
end;

procedure TModReports.NewTillGroupSalesNewPage(Sender: TObject);
var
  sColumnHeader, sTitle : string;
begin
  if PrintHeader then begin
    if iTillNo = 0 then
      begin
        if iStartNo = iEndNo then sTitle := 'Till Group Sales Report (All Tills) - Run No : ' + IntToStr(iStartNo)
        else sTitle := 'Till Group Sales Report (All Tills) - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
        sColumnHeader := 'Group' + #9 + 'Non-Card Qty' + #9 + 'Non-Card Val.' + #9 + 'Card Qty' + #9 + 'Card Val.' + #9
        + 'Total Qty' + #9 + 'Total Val.';
      end
    else begin
      if iStartNo = iEndNo then sTitle := 'Till Group Sales Report (' + Syss.Till[iTillNo].Name + ') - Run No : ' + IntToStr(iStartNo)
      else sTitle := 'Till Group Sales Report (' + Syss.Till[iTillNo].Name + ') - Run Nos : ' + IntToStr(iStartNo) + ' - ' + IntToStr(iEndNo);
      sColumnHeader := 'Group' + #9 + 'Quantity' + #9 + 'Value';
    end;{if}

    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 35, pjRight, 25, 4, 0, 0);
      SetTab(NA, pjRight, 25, 4, 0, 0);
      SetTab(NA, pjRight, 25, 4, 0, 0);
      SetTab(NA, pjRight, 25, 4, 0, 0);
      SetTab(NA, pjRight, 35, 4, 0, 0);
      SetTab(NA, pjRight, 25, 4, 0, 0);
      SetHeader(sTitle, sColumnHeader);
    end;{with}
  end;{if}
  SetRepFont(TheReport,fnMainText, 8);
end;

procedure TModReports.NewTillGroupSalesPrint(Sender: TObject);
var
  aGrandTotals, aGroupTotals : array [1..6] of Real;
  ExLocal : TdExLocal;
  TheKey : Str255;
  iPos, iStatus, iPrevGroupNo : smallint;
  slPLUSales : TStringList;
  sFindKey : string4;
  PLUSalesInfo : TPLUSalesInfo;
//  rExtraWidth : real;
  iRunNo : integer;

  procedure ZeroGroupTotals;
  var
    iPos : byte;
  begin
    for iPos := 1 to 6 do aGroupTotals[iPos] := 0;
  end;{ZeroGroupTotals}

  procedure PrintGroupTotals;
  begin
    if iTillNo = 0 then TheReport.PrintLn(#9 + MoneyToStr(aGroupTotals[1]) + #9 + MoneyToStr(aGroupTotals[2])
    + #9 + MoneyToStr(aGroupTotals[3]) + #9 + MoneyToStr(aGroupTotals[4]) + #9
    + MoneyToStr(aGroupTotals[5]) + #9 + MoneyToStr(aGroupTotals[6]))
    else TheReport.PrintLn(#9 + MoneyToStr(aGroupTotals[5]) + #9 + MoneyToStr(aGroupTotals[6]));
  end;{PrintGroupTotals}

begin
  ExLocal.Create;

  slPLUSales := TStringList.Create;
  With ExLocal Do Begin

    {Creates StringList Containing All PLU Sales}

    For iRunNo := iStartNo to iEndNo do begin

      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := 'P' + FullNomKey(iRunNo) + CHR(iTillNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
      LGetRecAddr(TillSalesF);

      while (iStatus = 0) and (LTillSales.tsType = 'P')
      and (LTillSales.tsPLU.tpRunNo = iRunNo) do begin

        if (LTillSales.tsPLU.tpTillNo = iTillNo) or (iTillNo = 0) then begin

          with LTillSales do begin

            {find existing item in the list}
            sFindKey := {PadString(psLeft,IntToStr(tsPLU.tpGroupNo),'0',2)
            + }PadString(psLeft,IntToStr(tsPLU.tpPLUNo),'0',4);
            iPos := slPLUSales.IndexOf(sFindKey);

            if iPos = -1 then
              begin
                {Add new item into StringList}
                PLUSalesInfo := TPLUSalesInfo.Create;
                With PLUSalesInfo do Begin
                  GroupNo := tsPLU.tpGroupNo;
                  PLUNo := tsPLU.tpPLUNo;
                  PLUDesc := tsPLU.tpDescription;
                  CardQty := 0;
                  CardVal := 0;
                  NonCardQty := 0;
                  NonCardVal := 0;
                  TotalQty := tsPLU.tpQty;
                  TotalVal := tsPLU.tpAmount;
                  slPLUSales.AddObject(sFindKey, PLUSalesInfo);
                end;{with}
              end
            else begin
              {Update existing item in StringList}
              PLUSalesInfo := TPLUSalesInfo(slPLUSales.Objects[iPos]);
              with PLUSalesInfo do begin
                TotalQty := TotalQty + tsPLU.tpQty;
                TotalVal := TotalVal + tsPLU.tpAmount;
              end;{with}
            end;{if}
          end;{with}
        end;{if}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, tsMainK, TheKey);
        LGetRecAddr(TillSalesF);
      end;{while}
    end;{for}

    {If All Tills}
    if iTillNo = 0 then begin
      {Add Card Sales to the StringList}

      { Build key }
      FillChar(TheKey,SizeOf(TheKey),#0);
      TheKey := FullNomKey(iStartNo);

      { Get first record }
      iStatus := Find_Rec(B_GetGEq, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdRunCardK, TheKey);
      LGetRecAddr(SalesDetF);

      While (iStatus = 0) and (LSalesDet.sdRunNo <= iEndNo)
      And (LSalesDet.sdRunNo >= iStartNo) do begin

        with LSalesDet do begin

          {find existing item in the list}
          sFindKey := PadString(psLeft,IntToStr(LSalesDet.sdNumber),'0',4);
          iPos := slPLUSales.IndexOf(sFindKey);

          if iPos = -1 then
            begin
              {this should never happen}
            end
          else begin
            {Update existing item in StringList}
            PLUSalesInfo := TPLUSalesInfo(slPLUSales.Objects[iPos]);
            with PLUSalesInfo do begin
              CardQty := CardQty + sdQuantity;
              CardVal := CardVal + sdValue;
            end;{with}
          end;{if}
        end;{with}

        {next record}
        iStatus := Find_Rec (B_GetNext, F[SalesDetF], SalesDetF, LRecPtr[SalesDetF]^, sdRunCardK, TheKey);
        LGetRecAddr(SalesDetF);
      end;{while}
    end;{if}

    {Sort List into Group / PLU order}
    For iPos := 0 to slPLUSales.Count -1 do slPLUSales[iPos] := PadString(psLeft
    ,IntToStr(TPLUSalesInfo(slPLUSales.Objects[iPos]).GroupNo),'0',2) + PadString(psLeft
    ,IntToStr(TPLUSalesInfo(slPLUSales.Objects[iPos]).PLUNo),'0',4);
    slPLUSales.Sort;

  end;{with}

  ExLocal.Destroy;

  {initialise values}
  iPrevGroupNo := -1;
  ZeroGroupTotals;

  {zero Grand Totals}
  for iPos := 1 to 6 do aGrandTotals[iPos] := 0;

  with TheReport do begin

//    if (iTillNo = 0) then rExtraWidth := PageWidth - MarginRight - Marginleft - 109
//    else rExtraWidth := 0;

    For iPos := 0 to slPLUSales.Count - 1 do begin

      PLUSalesInfo := TPLUSalesInfo(slPLUSales.Objects[iPos]);

      with PLUSalesInfo do begin
        {on group change}
        if GroupNo <> iPrevGroupNo then begin
          if iPrevGroupNo <> -1 then begin
            {print previous group's totals}
            SetRepFont(TheReport,fnMainText, 8);
            PrintGroupTotals;
          end;{if}

          {Print Group Title}
          GetGroupRec(GroupNo);
          SetRepFont(TheReport,fnMainText, 8);
          Print(GroupRec.grName);

          ZeroGroupTotals;
        end;

        {Calculate Non-Card Figures}
        NonCardQty := TotalQty - CardQty;
        NonCardVal := TotalVal - CardVal;

        {save prev group}
        iPrevGroupNo := GroupNo;

        {Increment Group Totals}
        aGroupTotals[1] := aGroupTotals[1] + NonCardQty;
        aGroupTotals[2] := aGroupTotals[2] + NonCardVal;
        aGroupTotals[3] := aGroupTotals[3] + CardQty;
        aGroupTotals[4] := aGroupTotals[4] + CardVal;
        aGroupTotals[5] := aGroupTotals[5] + TotalQty;
        aGroupTotals[6] := aGroupTotals[6] + TotalVal;

        {Increment Grand Totals}
        aGrandTotals[1] := aGrandTotals[1] + NonCardQty;
        aGrandTotals[2] := aGrandTotals[2] + NonCardVal;
        aGrandTotals[3] := aGrandTotals[3] + CardQty;
        aGrandTotals[4] := aGrandTotals[4] + CardVal;
        aGrandTotals[5] := aGrandTotals[5] + TotalQty;
        aGrandTotals[6] := aGrandTotals[6] + TotalVal;
      end;{with}
    end;{for}

    {Print Last Group Total}
    SetRepFont(TheReport,fnMainText, 8);
    PrintGroupTotals;

    {Print Grand Total}
    UpOneLine(TheReport);
    DrawLineUnder(TheReport);
    SetRepFont(TheReport,fnSubTotal, 8);
    Print('Grand Totals : ');

    if iTillNo = 0 then PrintLn(#9 + MoneyToStr(aGrandTotals[1]) + #9 + MoneyToStr(aGrandTotals[2])
    + #9 + MoneyToStr(aGrandTotals[3]) + #9 + MoneyToStr(aGrandTotals[4]) + #9
    + MoneyToStr(aGrandTotals[5]) + #9 + MoneyToStr(aGrandTotals[6]))
    else TheReport.PrintLn(#9 + MoneyToStr(aGrandTotals[5]) + #9 + MoneyToStr(aGrandTotals[6]));
  end;{with}
  ClearList(slPLUSales);
  slPLUSales.Free;
end;

function TModReports.PagedFormat : boolean;
begin
  Result := not (PrnInfo.fePrintMethod in [5,6]);
end;

function TModReports.PrintHeader : boolean;
begin
  Result := PagedFormat or (TheReport.CurrentPage = 1)
end;

procedure TModReports.CustFPrint(Sender: TObject);
var
  KeyS : Str255;
  iStatus : smallint;
  ExLocal : TdExLocal;
Begin

  ExLocal.Create;

  { Get first record }
  Blank(KeyS,SizeOf(KeyS));
  iStatus := Find_Rec (B_GetGEq, F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK,KeyS);
  ExLocal.LGetRecAddr(CustF);

  While iStatus = 0 do begin

    SetRepFont(TheReport,fnMainText, 8);

    TheReport.Print(ExLocal.LCust.CustCode + #9 + ExLocal.LCust.ClubNo + #9
    + IntToStr(ExLocal.LCust.TillNo) + #9 + IntToStr(ExLocal.LCust.CSRecNo) + #9
    + Trim(ExLocal.LCust.Company) + ' ' + ExLocal.LCust.FirstName + #9 + MoneyToStr(ExLocal.LCust.CurrBalance) + #9
    + MoneyToStr(ExLocal.LCust.PrevCBal) + #9 + IntToStr(ExLocal.LCust.ChangeFlag));
    EndOfPageLine(TheReport, PagedFormat);

    { Get next record }
    iStatus := Find_Rec (B_GetNext, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);
    ExLocal.LGetRecAddr(CustF);
  end;{while}

  UpOneLine(TheReport);
  DrawLineUnder(TheReport);

  ExLocal.Destroy;

end;

end.
