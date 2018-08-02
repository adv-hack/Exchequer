unit Reports;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , RPFiler, RPDefine, RPBase, RPCanvas, RPFPrint, APIUtil, RPDevice, FileUtil
  , ComCtrls, EntRend, StdCtrls, StrUtil, Prntdlg, MiscUtil, PrntPrev
  , BTConst, MathUtil, Math, Inifiles, DateUtils, Enterprise01_TLB, BTUtil
  , BTFile, PPayProc;

type
  ENoUnique = class(Exception);

  TCustomerInfo = class
    Description : string[45];
  end;

  TModReports = class(TForm)
    FilePrinter1: TFilePrinter;
    TheReport: TReportFiler;
    procedure RecordsNewPage(Sender: TObject);
    procedure PortraitBeforePrint(Sender: TObject);
    procedure LandscapeBeforePrint(Sender: TObject);
    procedure RecordsPrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    PrnInfo : TSBSPrintSetupInfo;
    procedure SetHeader(sReportTitle, sColHeads : string; sSubTitle : string = ''; sDateRange : string = '');
    function RunReport : boolean;
    function PrintHeader : boolean;
    function PagedFormat : boolean;
  public
    bConsolidate, bGotPrnInfo : boolean;
    sLogFilename : string;
    procedure PrintRecords;
  end;

var
  ModReports: TModReports;

implementation

uses
  ShellAPI, RepUtil, Admin;

{$R *.DFM}

{TModReports}

procedure TModReports.SetHeader(sReportTitle, sColHeads : string; sSubTitle : string = ''; sDateRange : string = '');
begin
  SetStandardHeader(TheReport, 'Late Payment Penalty Plug-In', sReportTitle, sColHeads, PagedFormat, sSubTitle, sDateRange);
end;

procedure TModReports.PrintRecords;
begin
  with TheReport do begin
    OnBeforePrint := PortraitBeforePrint;
    OnNewPage := RecordsNewPage;
    OnPrint := RecordsPrint;
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

procedure TModReports.RecordsNewPage(Sender: TObject);
begin
  if PrintHeader then begin
    with TheReport do begin
      ClearTabs;
      SetTab(MarginLeft + 18            // Cust Code
      , pjLeft, 10, 4, 0, 0);           // Included
      SetTab(NA, pjRight, 20, 4, 0, 0); // Min Value
      SetTab(NA, pjRight, 20, 4, 0, 0); // Days Offset
      SetTab(NA, pjRight, 20, 4, 0, 0); // Interest Rate
      SetTab(NA, pjRight, 20, 4, 0, 0); // Effective Rate
      SetTab(NA, pjLeft, 20, 4, 0, 0);  // Interest GL
      SetTab(NA, pjLeft, 15, 4, 0, 0);  // CC
      SetTab(NA, pjLeft, 15, 4, 0, 0);  // Dept
      SetTab(NA, pjLeft, 20, 4, 0, 0);  // Debt Basis
      SetTab(NA, pjLeft, 20, 4, 0, 0);  // Debt GL
      SetHeader('Configuration', 'Cust Code'#9'Included'#9'Min Value'#9
      + 'Days Offset'#9'Interest Rate'#9'Effective Rate'#9'Interest GL'#9
      + 'CC'#9'Dept'#9'Debt. Basis'#9'Debt GL');
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

procedure TModReports.RecordsPrint(Sender: TObject);
var
  KeyS : TStr255;
  iStatus : integer;
  sCustCode, sIncluded, sEffRate, sDefRate, sRate : string;
  PPCustRec : TPPCustRec;

  function GetChargeBasis(iBasis : integer) : string;
  begin{GetChargeBasis}
    case iBasis of
      0 : Result := 'not applicable';
      1 : Result := 'per Transaction';
      2 : Result := 'per process';
    end;{case}
  end;{GetChargeBasis}

Begin{RecordsPrint}
  with TheReport do begin

    FillChar(KeyS, SizeOf(KeyS), #0);
    iStatus := BTFindRecord(B_GetFirst, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF]
    , ppcCustIdx, KeyS);
    while iStatus = 0 do begin

      with PPCustRec do begin
        if ppcCustCode = PPC_DEFAULT_RECORD then
        begin
          SetRepFont(TheReport,fnSubTotal, 8);
          PPCustRec.ppcCustCode := '';
          sDefRate := MoneyToStr(ppcDefaultRate);
          sEffRate := '-';
          sRate := sDefRate;
          sIncluded := '-';
          sCustCode := 'Default';
        end else
        begin
          sCustCode := Trim(ppcCustCode);
          SetRepFont(TheReport,fnMainText, 8);
          sEffRate := MoneyToStr(StrToFloatDef(sDefRate, 0) + ppcInterestVariance);
          sRate := MoneyToStr(ppcInterestVariance);
          sIncluded := GetYNFromBool(ppcActive);
        end;{if}

        Print(sCustCode + #9
        + sIncluded + #9
        + MoneyToStr(ppcMinInvoiceValue, oToolkit.SystemSetup.ssSalesDecimals) + #9
        + IntToStr(ppcCreditDaysOffset) + #9
        + sRate + #9
        + sEffRate + #9
        + IntToStr(ppcInterestGLCode) + #9
        + Trim(ppcCostCentre) + #9
        + Trim(ppcDepartment) + #9
        + GetChargeBasis(ppcDebitChargeBasis) + #9
        + IntToStr(ppcDebtChargeGLCode));
      end;{with}

      EndOfPageLine(TheReport, PagedFormat);

      iStatus := BTFindRecord(B_GetNext, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF]
      , ppcCustIdx, KeyS);
    end;{while}


  end;{with}
end;{RecordsPrint}

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





