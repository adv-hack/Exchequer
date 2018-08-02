unit Reports;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , RPFiler, RPDefine, RPBase, RPCanvas, RPFPrint, APIUtil, RPDevice, FileUtil
  , ComCtrls, EntRend, StdCtrls, StrUtil, Prntdlg, MiscUtil, PrntPrev
  , BTConst, MathUtil, Math, Inifiles, DateUtils, Enterprise01_TLB, BTUtil
  , Progress;

type
  ENoUnique = class(Exception);

  TLineInfo = Class
    sVATNo : string;
    aValues : array of real;
  public
    constructor CreateWith(iNoOfColumns : integer);
  end;

  TModReports = class(TForm)
    FilePrinter1: TFilePrinter;
    TheReport: TReportFiler;
    procedure VATReportNewPage(Sender: TObject);
    procedure PortraitBeforePrint(Sender: TObject);
    procedure LandscapeBeforePrint(Sender: TObject);
    procedure VATReportPrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    iNoOfColumns : integer;
    PrnInfo : TSBSPrintSetupInfo;
    function RunReport : boolean;
    function PrintHeader : boolean;
    function PagedFormat : boolean;
    procedure SetPrinterTabs;
    procedure SetExcelTabs;
  public
    bConsolidate, bGotPrnInfo : boolean;
    sTitle : string;
    frmProgress : TfrmProgress;
    slLines : TStringList;
    iEndMonth : integer;
    iEndYear : integer;
    procedure PrintVATReport;
  end;

  function GetCLParams : boolean;

var
  ModReports: TModReports;
  sDataDirectory : string;
  sUserName : string;

implementation

uses
  SecCodes, ComObj, uToolkit, ShellAPI, RepUtil;

{$R *.DFM}

{TModReports}

procedure TModReports.PrintVATReport;

  procedure GetNoOfColumns;
  var
    LineInfo : TLineInfo;
  begin{GetNoOfColumns}
    if slLines.Count > 0 then
    begin
      LineInfo := TLineInfo(slLines.Objects[0]);
      if LineInfo <> nil then
      begin
        iNoOfColumns := length(LineInfo.aValues)-1;
      end;{if}
    end;{if}
  end;{GetNoOfColumns}

begin
  GetNoOfColumns;
  with TheReport do begin
    if iNoOfColumns = 12 then OnBeforePrint := LandscapeBeforePrint
    else OnBeforePrint := PortraitBeforePrint;
    OnNewPage := VATReportNewPage;
    OnPrint := VATReportPrint;
    Title := sTitle;
  end;{with}
  RunReport;

  While (FrmPrintPreview <> nil) and FrmPrintPreview.showing do
  begin
    application.ProcessMessages;
  end;{while}
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

procedure TModReports.SetPrinterTabs;
begin
  with TheReport do begin
    ClearTabs;
    SetTab(MarginLeft + 30                  // 'VAT Reg No'
    , pjRight, 25, 12, 0, 0);          // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
    SetTab(NA, pjRight, 20, 12, 0, 0);  // Month
  end;{with}
end;

procedure TModReports.SetExcelTabs;
begin
  with TheReport do begin
    ClearTabs;
    SetTab(MarginLeft + 30                  // 'VAT Reg No'
    , pjLeft, 25, 12, 0, 0);          // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
    SetTab(NA, pjLeft, 20, 12, 0, 0);  // Month
  end;{with}
end;

procedure TModReports.VATReportNewPage(Sender: TObject);
var
  sMonths : string;
  LineInfo : TLineInfo;
  iYearDec, iMonth, iPos : integer;
begin
  if PrintHeader then begin
    with TheReport do begin
      if PrnInfo.fePrintMethod = 5{excel} then SetExcelTabs
      else SetPrinterTabs;

      sMonths := '';
      if slLines.Count > 0 then
      begin
        LineInfo := TLineInfo(slLines.Objects[0]);
        if LineInfo <> nil then
        begin
          for iPos := 1 to length(LineInfo.aValues)-1 do
          begin
            iYearDec := 0;
            iMonth := iPos + iEndMonth - iNoOfColumns; // work out month of column
            if iMonth <= 0 then
            begin
              // month is in previous year
              iMonth := iMonth + 12;
              iYearDec := 1;
            end;{if}
            sMonths := sMonths + ShortMonthNames[iMonth] + ' ''' + Copy(IntToStr(iEndYear - iYearDec),3,2) + #9;
          end;{for}
        end;{if}
      end;{if}


      SetStandardHeader(TheReport, sTitle, '', 'Vat Reg No.'#9 + sMonths, PagedFormat
      , 'User : ' + sUserName, '');
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

procedure TModReports.VATReportPrint(Sender: TObject);
var
  iPos, iLine : integer;
  LineInfo : TLineInfo;
Begin{VATReportPrint}
  // initialise
  frmProgress.UpdateLine1('Printing Report');

  slLines.Sort;

  // Print List onto report
  For iLine := 0 to slLines.Count-1 do
  begin
    LineInfo := TLineInfo(slLines.Objects[iLine]);
    frmProgress.UpdateLine2('Printing Details for ' + LineInfo.sVATNo);

    SetRepFont(TheReport,fnMainText, 8);
    TheReport.Print(LineInfo.sVATNo);

    for iPos := 1 to length(LineInfo.aValues)-1 do
    begin
      TheReport.Print(#9 + MoneyToStr(LineInfo.aValues[iPos]));
    end;{for}

    EndOfPageLine(TheReport, PagedFormat);
    Application.ProcessMessages;
  end;{for}

end;{VATReportPrint}

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


function GetCLParams: boolean;
begin
  sDataDirectory := Trim(ParamStr(1));
  sUserName := Trim(ParamStr(2));
  Result := DirectoryExists(sDataDirectory) and (sUserName <> '');
end;

{ TLineInfo }

constructor TLineInfo.CreateWith(iNoOfColumns : integer);
var
  iPos : integer;
begin
  inherited create;
  SetLength(aValues, iNoOfColumns + 1);
  For iPos := 0 to iNoOfColumns do aValues[iPos] := 0;
end;

initialization
  ShortDateFormat := 'dd/mm/yy';
  LongTimeFormat := 'hh:nn:ss';

end.





