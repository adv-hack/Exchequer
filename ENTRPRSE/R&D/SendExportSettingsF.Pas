unit SendExportSettingsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ClipBrd, IniFiles,
  EnterToTab, Menus;

type
  TfrmExportResults = class(TForm)
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    memExportSettingsOutput: TMemo;
    btnSaveAs: TButton;
    EnterToTab1: TEnterToTab;
    Label2: TLabel;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    menuOptCopy: TMenuItem;
    Image1: TImage;
    TitleLbl: TLabel;
    NextBtn: TButton;
    imgSide: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure menuOptCopyClick(Sender: TObject);
    procedure FormBMPCreate;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses oExportSettings,
     Brand;

//--------------------------------------------------------------------------

procedure TfrmExportResults.FormBMPCreate;
Var
  BMap1       :  TBitMap;

  RectD       :  TRect;
Begin
  BMap1:=TBitMap.Create;

  try

    BMap1.Handle:=LoadBitMap(HInstance,'Logo');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
    end;
  finally
    BMap1.Free;

  end; {try..}

end;


//--------------------------------------------------------------------------

procedure TfrmExportResults.FormCreate(Sender: TObject);
Var
  EmPos     : SmallInt;

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
  inherited;

  If Branding.BrandingFileExists(ebfSetup) Then
  Begin
    Branding.BrandingFile(ebfSetup).ExtractImage (imgSide, 'TallWizd');
    DoBitmapStuff;
  End; // If Branding.BrandingFileExists(ebfSetup)

  RichEdit1.Text := RichEdit1.Text + 'l  Click the Save As button to save the results to your preferred location' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  In your Email application create a new email and set the recipient address to that provided by your support technician' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  Set the subject on the email to System Settings followed by your Company Name' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  Attach the saved settings to the email and then send it';
  ToBullet  (0);
  ToBullet  (76);
  ToBullet  (199);
  ToBullet  (281);

  // Generate report and display in memo control
  oExportSet.BuildReport;
  memExportSettingsOutput.Lines.Assign (oExportSet.ExportSettingsResults);
end;

//--------------------------------------------------------------------------

procedure TfrmExportResults.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
end;

//--------------------------------------------------------------------------

procedure TfrmExportResults.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;
end;

//--------------------------------------------------------------------------

procedure TfrmExportResults.NextBtnClick(Sender: TObject);
begin
  // Close form and move to Send dialog
  inherited;
  Close;
end;

//--------------------------------------------------------------------------

procedure TfrmExportResults.btnSaveAsClick(Sender: TObject);
begin
  //inherited;
  If SaveDialog1.Execute Then
    memExportSettingsOutput.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmExportResults.menuOptCopyClick(Sender: TObject);
begin
  ClipBoard.AsText := RichEdit1.SelText;
end;

end.
