unit ViewLicenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RichView, RVStyle, ExtCtrls, Mask, PtblRV, RVScroll, AdvGlowButton,
  RVReport, RVEdit, CRVFData, Printers;

type
  TfrmViewLicence = class(TForm)
    rvs: TRVStyle;
    pnlButtons: TPanel;
    rvv: TRichView;
    RVPrint: TRVPrint;
    btnPrint: TAdvGlowButton;
    rvhFooter: TRVReportHelper;
    btnClose: TAdvGlowButton;
    pnlAccept: TPanel;
    cbUserAcceptance: TCheckBox;
    btnAccept: TAdvGlowButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    procedure btnAcceptClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure cbUserAcceptanceClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure rvvJump(Sender: TObject; id: Integer);
  private
    FFontSize: integer;
    FUserResponse: integer;
    FEncryptedLicenceFile: pchar;
    procedure SetEncryptedLicenceFile(const Value: pchar);
  public
    property EncryptedLicenceFile: pchar read FEncryptedLicenceFile write SetEncryptedLicenceFile;
    property UserResponse: integer read FUserResponse write FUserResponse;
  end;

function TheLicenceForm: TfrmViewLicence;
procedure FreeTheForm;

implementation

{$R *.dfm}

uses
  Encryption, ShellAPI;

var
  FForm: TfrmViewLicence;

function TheLicenceForm: TfrmViewLicence;
begin
  if FForm = nil then
    FForm := TfrmViewLicence.Create(nil);

  result := FForm;
end;

procedure FreeTheForm;
begin
  if FForm <> nil then begin
    FForm.Free;
    FForm := nil;
  end;
end;

procedure TfrmViewLicence.btnAcceptClick(Sender: TObject);
begin
  FUserResponse := 0;
end;

procedure TfrmViewLicence.btnPrintClick(Sender: TObject);
begin
//  rvhFooter.RichView.AddText('    Licence & Support Agreement - v1 September 2008 (embedded)', 6);
  if not PrinterSetupDialog.Execute{(self.Handle)} then EXIT;

  with rvPrint do begin
    AssignSource(Rvv);
    SetFooter(rvhFooter.RichView.RVData);
    MirrorMargins  := false;
    TopMarginMM    := 0;
    LeftMarginMM   := 0;
    BottomMarginMM := 10;
    RightMarginMM  := 0;
    FooterYMM      := 4;
    HeaderYMM      := 0;

    FormatPages(rvDoAll);
    try
      screen.Cursor := crHourGlass;
      rvPrint.Print('Exchequer Licence', 1, true);
    finally
      screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmViewLicence.btnZoomInClick(Sender: TObject);
begin
 FFontSize := FFontSize + 1;
 rvv.SelectAll;
end;

procedure TfrmViewLicence.cbUserAcceptanceClick(Sender: TObject);
begin
  btnAccept.Enabled := cbUserAcceptance.Checked;
end;

procedure TfrmViewLicence.FormActivate(Sender: TObject);
begin
//  Rvv.SetFocus;
  FUserResponse := -1;
  Rvv.ScrollTo(0);
end;

procedure TfrmViewLicence.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caHide;
end;

procedure TfrmViewLicence.FormCreate(Sender: TObject);
begin
  FUserResponse := -1;
  Rvv.Align := alClient;
  FFontSize := 7;
end;

procedure TfrmViewLicence.FormResize(Sender: TObject);
begin
  pnlAccept.Left := (pnlButtons.Width - pnlAccept.Width) div 2;
end;

procedure TfrmViewLicence.rvvJump(Sender: TObject; id: Integer);
var URL: String;
    RVData: TCustomRVFormattedData;
    ItemNo: Integer;
begin
  Rvv.GetJumpPointLocation(id, RVData, ItemNo);
  URL := PChar(RVData.GetItemTag(ItemNo));
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOW);
end;

procedure TfrmViewLicence.SetEncryptedLicenceFile(const Value: pchar);
var
  MSI: TMemoryStream;
begin
  FEncryptedLicenceFile := Value;
  MSI := DecryptFile(Value, True);
  if MSI <> nil then begin
    Rvv.LoadRVFFromStream(MSI);
    Rvv.Format;
    Rvv.Visible := true;
    MSI.Free;
  end;
end;

initialization
  FForm := nil;

end.
