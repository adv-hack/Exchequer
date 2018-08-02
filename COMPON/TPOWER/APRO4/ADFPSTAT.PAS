{*********************************************************}
{*                   ADFPSTAT.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdFPStat;
  { Apro Fax printer status component}

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Classes,
  Forms,
  Controls,
  StdCtrls,
  Dialogs,
  Buttons,
  AdFaxPrn;

type
  TStandardFaxPrinterStatusDisplay = class(TForm)
    fpsFaxInfoGroup    : TGroupBox;
    fpsLabel1          : TLabel;
    fpsLabel2          : TLabel;
    fpsLabel3          : TLabel;
    fpsLabel4          : TLabel;
    fpsFileName        : TLabel;
    fpsTotalPages      : TLabel;
    fpsResolution      : TLabel;
    fpsWidth           : TLabel;
    fpsStatusGroup     : TGroupBox;
    fpsAbortButton     : TBitBtn;
    fpsStatusLine      : TLabel;
    fpsLabel5: TLabel;
    fpsLabel6: TLabel;
    fpsFirstPage: TLabel;
    fpsLastPage: TLabel;
    procedure fpsAbortButtonClick(Sender: TObject);
    procedure UpdateValues(FaxStatus: TApdCustomFaxPrinter);
  public
    { Public declarations }
    FaxPrinter : TApdCustomFaxPrinter;
  end;

  TApdFaxPrinterStatus = class(TApdAbstractFaxPrinterStatus)
    procedure CreateDisplay; override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(First, Last: Boolean); override;
  end;

implementation

{$R *.DFM}
{$IFDEF TRIALRUN}
{$I TRIAL07.INC}
{$I TRIAL03.INC}
{$I TRIAL01.INC}
{$ENDIF}

procedure TStandardFaxPrinterStatusDisplay.UpdateValues(FaxStatus: TApdCustomFaxPrinter);
const
  ResStrings   : array[0..1] of String[8]  = ('standard', 'high');
  WidthStrings : array[0..1] of String[4]  = ('1728', '2048');
  ProgressSt   : array[TFaxPrintProgress] of String[10] = ('Idle', 'Composing',
                                       'Rendering', 'Submitting', 'Converting');
{$IFDEF TRIALRUN}
{$I TRIAL04.INC}
{$ENDIF}                                       
var
  PageStats : AnsiString;
begin
  {$IFDEF TRIALRUN}
  TC;
  {$ENDIF}
  with FaxStatus do begin
    fpsFileName.Caption   := AnsiUpperCase(ExtractFileName(FileName));
    fpsTotalPages.Caption := IntToStr(TotalFaxPages);
    fpsResolution.Caption := ResStrings[Ord(FaxResolution)];
    fpsWidth.Caption      := WidthStrings[Ord(FaxWidth)];
    fpsFirstPage.Caption  := IntToStr(FirstPageToPrint);
    fpsLastPage.Caption   := IntToStr(LastPageToPrint);

    FmtStr(PageStats, '%s %d of %d', [ProgressSt[PrintProgress],
                      CurrentPrintingPage, LastPageToPrint]);
    fpsStatusLine.Caption := PageStats;
  end;
end;

procedure TApdFaxPrinterStatus.CreateDisplay;
begin
  Display := TStandardFaxPrinterStatusDisplay.Create(Self);
  (Display as TStandardFaxPrinterStatusDisplay).FaxPrinter := FaxPrinter;

  (Display as TStandardFaxPrinterStatusDisplay).Caption := FCaption;
end;

procedure TApdFaxPrinterStatus.DestroyDisplay;
begin
  if Assigned(FDisplay) then
    Display.Free;
end;

procedure TApdFaxPrinterStatus.UpdateDisplay(First, Last: Boolean);
begin
  if First then begin
    (Display as TStandardFaxPrinterStatusDisplay).FaxPrinter := FaxPrinter;
    Display.Show;
  end;
  if Last then
    Display.Visible := False
  else
    (Display as TStandardFaxPrinterStatusDisplay).UpdateValues(FaxPrinter);
end;


procedure TStandardFaxPrinterStatusDisplay.fpsAbortButtonClick(Sender: TObject);
begin
  FaxPrinter.PrintAbort;
end;

end.
