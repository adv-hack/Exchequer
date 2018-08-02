unit ImportF3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls,
  Enterprise_TLB,      // Data Query Server Type Library
  oDataQ;              // Base Data Query Server Object

type
  TfrmMiscOptions = class(TForm)
    Bevel1: TBevel;
    TitleLbl: TLabel;
    imgSide: TImage;
    btnHelp: TButton;
    Panel1: TPanel;
    Image1: TImage;
    btnClose: TButton;
    btnBack: TButton;
    btnNext: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    radHorizontal: TRadioButton;
    radVertical: TRadioButton;
    procedure btnNextClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FDataQuery : TDataQuery;

    Procedure DoBitmapStuff;

    Procedure CMDialogKey(Var Msg:TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
    ExitCode : Char;

    Constructor Create(AOwner: TComponent; Const DataQuery : TDataQuery); ReIntroduce;
  end;

var
  frmMiscOptions: TfrmMiscOptions;

implementation

{$R *.dfm}

Uses Brand;

//-----------------------------------------------------------------------------------------

Procedure TfrmMiscOptions.CMDialogKey(Var Msg:TWMKey);
Begin
  If NOT (ActiveControl Is TButton) Then
    If Msg.Charcode = 13 Then
      Msg.Charcode := 9;

  inherited;
End;

//-----------------------------------------------------------------------------------------

Constructor TfrmMiscOptions.Create(AOwner: TComponent; Const DataQuery : TDataQuery);
begin
  Inherited Create (AOwner);

  FDataQuery := DataQuery;

  ExitCode := 'X';

  // Need to set the size of the bmp otherwise we can't paint into it
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Picture.Bitmap.Width := Image1.Width;

  Caption := Branding.pbProductName + ' Data Query Wizard - ' + FDataQuery.TypeDesc[tsdDataPlural];
  Icon := Branding.pbProductIcon;
  Branding.BrandingFile(ebfSetup).ExtractImage (imgSide, 'TallWizd');

  // Paint bitmap
  DoBitmapStuff;

  // Link into the correct page in the help
  HelpContext := FDataQuery.TypeContext;

  // Display Orientation
  If (FDataQuery.ImportDirection = dqoHorizontalRight) Then
    radHorizontal.Checked := True
  Else
    radVertical.Checked := True;
end;

//-----------------------------------------------------------------------------------------

Procedure TfrmMiscOptions.DoBitmapStuff;
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

//-----------------------------------------------------------------------------------------

procedure TfrmMiscOptions.btnNextClick(Sender: TObject);
begin
  // Display Orientation
  If radHorizontal.Checked Then
    FDataQuery.ImportDirection := dqoHorizontalRight
  Else
    FDataQuery.ImportDirection := dqoVerticalDown;

  ExitCode := 'N';
  Close;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmMiscOptions.btnCloseClick(Sender: TObject);
begin
  ExitCode := 'X';
  Close;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmMiscOptions.btnBackClick(Sender: TObject);
begin
  ExitCode := 'B';
  Close;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmMiscOptions.btnHelpClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then Begin
    If IsLibrary Then
      Application.HelpFile := 'EnterOle.Chm';
    Application.HelpContext (HelpContext);
  End; { If (HelpContext <> 0) }
end;

//-----------------------------------------------------------------------------------------

end.
