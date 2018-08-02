unit DocNoReportF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, oScanCompanies, Menus, EnterToTab, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmDocumentNumbersReport = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    imgSide: TImage;
    memExportSettingsOutput: TMemo;
    btnSaveAs: TButton;
    RichEdit1: TRichEdit;
    btnClose: TButton;
    SaveDialog1: TSaveDialog;
    EnterToTab1: TEnterToTab;
    PopupMenu1: TPopupMenu;
    menuOptCopy: TMenuItem;
    TitleLbl: TLabel;
    Timer1: TTimer;
    panProgress: TPanel;
    Label3: TLabel;
    lblCompany: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    oDocNoReport : TDocumentNumberReport;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
  public
    { Public declarations }
  end;

Var
  frmDocumentNumbersReport : TfrmDocumentNumbersReport;

implementation

{$R *.dfm}

Uses Brand, StrUtil, History, ExchequerRelease;

Const
  CM_DispAbout = $F1;

//=========================================================================

Procedure TfrmDocumentNumbersReport.WMSysCommand(Var Message  :  TMessage);
Var
  sAbout : ANSIString;
Begin // WMSysCommand
  With Message do
    Case WParam of
      CM_DispAbout : Begin
                       sAbout := Caption + #10#13 +
                                 'Version: ' + ExchequerModuleVersion (emDocNos, ExchDocNosBuildNo) + #10#13 +
                                 GetCopyrightMessage;
                       Application.MessageBox(PCHAR(sAbout), 'About', MB_OK Or MB_ICONINFORMATION);
                     End;
    End; { CAse }

  Inherited;

End; // WMSysCommand

//-------------------------------------------------------------------------

procedure TfrmDocumentNumbersReport.FormCreate(Sender: TObject);
Var
  SysMenuH : HWnd;

  //------------------------------

  Procedure ToBullet (Const StartPos : Integer);
  Begin // ToBullet
    RichEdit1.SelStart := StartPos;
    RichEdit1.SelLength := 1;
    RichEdit1.SelAttributes.Name := 'Wingdings';
    RichEdit1.SelAttributes.Size := 6;
  End; // ToBullet

  //------------------------------

  Procedure DoBitmapStuff;
  Var
    FromRect, ToRect : TRect;
  begin
    Image1.Picture.Bitmap.Height := Image1.Height;
    Image1.Picture.Bitmap.Width := Image1.Width;

    FromRect := Rect (0, imgSide.Picture.Height - Image1.Height, imgSide.Picture.Width, imgSide.Picture.Height);
    ToRect   := Rect (0, 0, Image1.Width, Image1.Height);

    DeleteObject(Image1.Picture.Bitmap.Palette);
    Image1.Picture.Bitmap.Palette:=CopyPalette(imgSide.Picture.Bitmap.Palette);
    Image1.Picture.Bitmap.Canvas.CopyRect(ToRect, imgSide.Picture.Bitmap.Canvas, FromRect);
  end;

  //------------------------------

begin
  // Add 'About' to System Menu
  SysMenuH:=GetSystemMenu(Handle,False);
  AppendMenu(SysMenuH, MF_SEPARATOR, 0, '');
  AppendMenu(SysMenuH, MF_String, CM_DispAbout,'&About');

  // Import bitmap
  If Branding.BrandingFileExists(ebfSetup) Then
  Begin
    Branding.BrandingFile(ebfSetup).ExtractImage (imgSide, 'TallWizd');
    DoBitmapStuff;
  End; // If Branding.BrandingFileExists(ebfSetup)

  // Setup instructions
  RichEdit1.Text := RichEdit1.Text + 'l  Click the Save As button to save the results to your preferred location' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  In your Email application create a new email and set the recipient address to that provided by your support technician' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  Set the subject on the email to System Settings followed by your Company Name' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  Attach the saved settings to the email and then send it';
  ToBullet  (0);
  ToBullet  (76);
  ToBullet  (199);
  ToBullet  (281);
end;

//------------------------------

procedure TfrmDocumentNumbersReport.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oDocNoReport);
end;

//-------------------------------------------------------------------------

procedure TfrmDocumentNumbersReport.FormActivate(Sender: TObject);
begin
  // Enable the timer to start the scanning process now that the form has painted
  Timer1.Enabled := True;
end;

//-------------------------------------------------------------------------

procedure TfrmDocumentNumbersReport.Timer1Timer(Sender: TObject);
begin
  // Turn off the timer to prevent it executing again
  Timer1.Enabled := False;

  // Generate report and display in memo control
  oDocNoReport := TDocumentNumberReport.Create;
  oDocNoReport.ScanCompanies (lblCompany);

  // Hide the progress panel
  panProgress.Visible := False;               

  // Put the XML into the memo
  memExportSettingsOutput.Lines.Assign (oDocNoReport);
end;

//-------------------------------------------------------------------------

procedure TfrmDocumentNumbersReport.btnSaveAsClick(Sender: TObject);
begin
  If SaveDialog1.Execute Then
    memExportSettingsOutput.Lines.SaveToFile(SaveDialog1.FileName);
end;

//-------------------------------------------------------------------------

procedure TfrmDocumentNumbersReport.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//=========================================================================

end.
