unit RptDisp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IniFiles, ComCtrls, TEditVal, Mask, BorBtns,
  EnterToTab;

type
  TfrmReportDispProps = class(TForm)
    gbBannerColours: TGroupBox;
    gbSectionFonts: TGroupBox;
    shBackgroundColour: TShape;
    shFontColour: TShape;
    btnOK: TButton;
    btnCancel: TButton;
    ColourDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    btnBackgroundColour: TButton;
    btnFontColour: TButton;
    btnDefaults: TButton;
    btnChangeFont: TButton;
    lblFontExample: TLabel;
    GroupBox1: TGroupBox;
    Label81: Label8;
    Label82: Label8;
    chkShowGrid: TBorCheckEx;
    edtYMM: Text8Pt;
    udYMM: TSBSUpDown;
    edtXMM: Text8Pt;
    udXMM: TSBSUpDown;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure btnBackgroundColourClick(Sender: TObject);
    procedure btnFontColourClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnChangeFontClick(Sender: TObject);
  private
    { Private declarations }
    //FCurrentSectionFont : TFont;
    //siFontIdx : SmallInt;

    FConfig : TIniFile;
  public
    { Public declarations }
  end;

{var
  frmReportDispProps: TfrmReportDispProps;}

implementation

uses
  GlobalTypes, GlobVar, VarConst;

{$R *.dfm}

//=========================================================================

procedure TfrmReportDispProps.FormCreate(Sender: TObject);
begin
  // Open up the .INI and load the current users settings
  FConfig := TIniFile.Create(SetDrive + 'REPORTS\' + ChangeFileExt(ExtractFileName(Application.ExeName), '.DAT'));

  // Region Colours
  // MH 17/10/2016 2017-R1 ABSEXCH-17754: New colour scheme for VRW
  shBackgroundColour.Brush.Color := FConfig.ReadInteger(EntryRec^.Login, 'BannerColour', DefaultBackgroundColour);
  shFontColour.Brush.Color := FConfig.ReadInteger(EntryRec^.Login, 'BannerFontColour', DefaultFontColour);

  // Designer Grid settings
  chkShowGrid.Checked := FConfig.ReadBool (EntryRec^.Login, 'ShowGrid', True);
  udXMM.Position := FConfig.ReadInteger (EntryRec^.Login, 'GridXMM', 2);
  udYMM.Position := FConfig.ReadInteger (EntryRec^.Login, 'GridYMM', 2);

  // Default Report Font
  lblFontExample.Font.Name := FConfig.ReadString (EntryRec^.Login, 'FontName', lblFontExample.Font.Name);
  lblFontExample.Font.Size := FConfig.ReadInteger(EntryRec^.Login, 'FontSize', lblFontExample.Font.Size);
  If FConfig.ReadBool (EntryRec^.Login, 'FontStyleBold', (fsBold In lblFontExample.Font.Style)) Then
  Begin
    lblFontExample.Font.Style := lblFontExample.Font.Style + [fsBold];
  End; // If FConfig.ReadBool (...
  If FConfig.ReadBool (EntryRec^.Login, 'FontStyleItalic', (fsItalic In lblFontExample.Font.Style)) Then
  Begin
    lblFontExample.Font.Style := lblFontExample.Font.Style + [fsItalic];
  End; // If FConfig.ReadBool (...
  If FConfig.ReadBool (EntryRec^.Login, 'FontStyleUnderline', (fsUnderline In lblFontExample.Font.Style)) Then
  Begin
    lblFontExample.Font.Style := lblFontExample.Font.Style + [fsUnderline];
  End; // If FConfig.ReadBool (...
  If FConfig.ReadBool (EntryRec^.Login, 'FontStyleStrikeout', (fsStrikeOut In lblFontExample.Font.Style)) Then
  Begin
    lblFontExample.Font.Style := lblFontExample.Font.Style + [fsStrikeOut];
  End; // If FConfig.ReadBool (...
  lblFontExample.Font.Color := FConfig.ReadInteger(EntryRec^.Login, 'FontColor', Ord(lblFontExample.Font.Color));
end;

//------------------------------

procedure TfrmReportDispProps.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(FConfig);
end;

//-------------------------------------------------------------------------

procedure TfrmReportDispProps.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (ModalResult = mrOK) Then
  Begin
    // Write settings back to the ENTRW.DAT ini file under the username section

    // Colours
    FConfig.WriteInteger(EntryRec^.Login, 'BannerColour', Ord(shBackgroundColour.Brush.Color));
    FConfig.WriteInteger(EntryRec^.Login, 'BannerFontColour', Ord(shFontColour.Brush.Color));

    // Designer Grid settings
    FConfig.WriteBool (EntryRec^.Login, 'ShowGrid', chkShowGrid.Checked);
    FConfig.WriteInteger (EntryRec^.Login, 'GridXMM', udXMM.Position);
    FConfig.WriteInteger (EntryRec^.Login, 'GridYMM', udYMM.Position);

    // Default Report Font
    FConfig.WriteString (EntryRec^.Login, 'FontName', lblFontExample.Font.Name);
    FConfig.WriteInteger(EntryRec^.Login, 'FontSize', lblFontExample.Font.Size);
    FConfig.WriteBool   (EntryRec^.Login, 'FontStyleBold', (fsBold In lblFontExample.Font.Style));
    FConfig.WriteBool   (EntryRec^.Login, 'FontStyleItalic', (fsItalic In lblFontExample.Font.Style));
    FConfig.WriteBool   (EntryRec^.Login, 'FontStyleUnderline', (fsUnderline In lblFontExample.Font.Style));
    FConfig.WriteBool   (EntryRec^.Login, 'FontStyleStrikeout', (fsStrikeOut In lblFontExample.Font.Style));
    FConfig.WriteInteger(EntryRec^.Login, 'FontColor', Ord(lblFontExample.Font.Color));
  End; // If (ModalResult = mrOK)
end;

//-------------------------------------------------------------------------

procedure TfrmReportDispProps.btnBackgroundColourClick(Sender: TObject);
begin
  ColourDialog1.Color := shBackgroundColour.Brush.Color;
  if ColourDialog1.Execute then
    shBackgroundColour.Brush.Color := ColourDialog1.Color;
end;

//------------------------------

procedure TfrmReportDispProps.btnFontColourClick(Sender: TObject);
begin
  ColourDialog1.Color := shFontColour.Brush.Color;
  if ColourDialog1.Execute then
    shFontColour.Brush.Color := ColourDialog1.Color;
end;

//------------------------------

procedure TfrmReportDispProps.btnChangeFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(lblFontExample.Font);
  If FontDialog1.Execute Then
  Begin
    lblFontExample.Font.Assign(FontDialog1.Font);
  End; // If FontDialog1.Execute
end;

//------------------------------

procedure TfrmReportDispProps.btnDefaultsClick(Sender: TObject);
begin
  If (MessageDlg('Are you sure you want to return to the default settings?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
  Begin
    FConfig.EraseSection(EntryRec^.Login);
    ModalResult := mrCancel;
  End; // If (MessageDlg('Are you sure...
end;

//------------------------------



end.
