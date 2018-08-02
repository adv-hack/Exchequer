unit PrinterInfoF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmPrinterBinInfo = class(TForm)
    memInfo: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrinterBinInfo: TfrmPrinterBinInfo;

implementation

{$R *.dfm}

Uses RpDevice;

procedure TfrmPrinterBinInfo.FormCreate(Sender: TObject);
Var
  iPrinter, iPaper, iBin : Integer;
  sText : String;
  SupportsPapers, SupportsBins : Boolean;
begin
  memInfo.Clear;

  For iPrinter := 0 To RpDev.Printers.Count - 1 Do
  Begin
    sText := 'Printer ' + IntToStr(iPrinter) + ': ' + RpDev.Printers[iPrinter];
    memInfo.Lines.Add (sText);
    memInfo.Lines.Add (StringOfChar('=', Length(sText)));

    RpDev.DeviceIndex := iPrinter;
    memInfo.Lines.Add ('Device: ' + RpDev.Device);
    memInfo.Lines.Add ('Driver: ' + RpDev.Driver);
    memInfo.Lines.Add ('Output: ' + RpDev.Output);
    memInfo.Lines.Add ('');

    // DevMode can be NIL in certain (unknown) circumstances - see ABSEXCH-17241
    If Assigned(RpDev.DevMode) Then
    Begin
      SupportsPapers := ((RpDev.DevMode.dmFields And DM_PAPERSIZE) = DM_PAPERSIZE);
      If SupportsPapers Then
      Begin
        memInfo.Lines.Add ('SupportsPapers: Yes / Count: ' + IntToStr(RpDev.Papers.Count));
        For iPaper := 0 To RpDev.Papers.Count - 1 Do
        Begin
          If (LongInt(RpDev.Papers.Objects[iPaper]) = RpDev.DevMode^.dmPaperSize) Then
            sText := '       ***** DEFAULT *****'
          Else
            sText := '';

          memInfo.Lines.Add ('  Paper ' + IntToStr(iPaper) + ': ' + RpDev.Papers[iPaper] + sText);
        End; // For iPaper
        memInfo.Lines.Add ('');
      End // If SupportsPapers
      Else
        memInfo.Lines.Add ('SupportsPapers: No');

      SupportsBins := ((RpDev.DevMode.dmFields And DM_DEFAULTSOURCE) = DM_DEFAULTSOURCE);
      If SupportsBins Then
      Begin
        memInfo.Lines.Add ('SupportsBins: Yes / Count: ' + IntToStr(RpDev.Bins.Count));
        For iBin := 0 To RpDev.Bins.Count - 1 Do
        Begin
          If (LongInt(RpDev.Bins.Objects[iBin]) = RpDev.DevMode^.dmDefaultSource) Then
            sText := '       ***** DEFAULT *****'
          Else
            sText := '';

          memInfo.Lines.Add ('  Bin ' + IntToStr(iBin) + ': ' + RpDev.Bins[iBin] + sText);
        End; // For iBin
      End // SupportsBins
      Else
        memInfo.Lines.Add ('SupportsBins: No');
    End // If Assigned(RpDev.DevMode)
    Else
      memInfo.Lines.Add ('*** DevMode = NIL ***');

    memInfo.Lines.Add ('');
  End; // For iPrinter
end;

end.
