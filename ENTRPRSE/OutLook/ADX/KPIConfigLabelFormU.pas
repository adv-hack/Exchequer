unit KPIConfigLabelFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, AdvSpin, AdvSelectors, AdvFontCombo,
  AdvGlowButton, AdvPanel, ExtCtrls, KPIUtils;

type
  TKPIConfigLabelForm = class(TForm)
    TitleBar: TPanel;
    AdvPanel1: TAdvPanel;
    FontBar: TPanel;
    OkBtn: TAdvGlowButton;
    CancelBtn: TAdvGlowButton;
    DefaultBtn: TAdvGlowButton;
    FontList: TAdvFontSelector;
    FontColorSelector: TAdvTextColorSelector;
    BackColorSelector: TAdvColorSelector;
    Label1: TLabel;
    FontSizeSpin: TAdvSpinEdit;
    Label2: TLabel;
    BoldChk: TCheckBox;
    ItalicChk: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    CaptionTxt: TEdit;
    procedure StyleChanged(Sender: TObject);
    procedure FontColorSelectorSelect(Sender: TObject; Index: Integer;
      Item: TAdvSelectorItem);
    procedure BackColorSelectorSelect(Sender: TObject; Index: Integer;
      Item: TAdvSelectorItem);
    procedure DefaultBtnClick(Sender: TObject);
  public
    procedure SetLabelStyle(LabelStyle: TKPILabelStyle);
    procedure GetLabelStyle(var LabelStyle: TKPILabelStyle);
  end;

var
  KPIConfigLabelForm: TKPIConfigLabelForm;

implementation

{$R *.dfm}

{ TKPIConfigLabelForm }

// -----------------------------------------------------------------------------

procedure TKPIConfigLabelForm.GetLabelStyle(
  var LabelStyle: TKPILabelStyle);
begin
  LabelStyle.FontName := FontList. Text;
  LabelStyle.FontSize := FontSizeSpin.Value;
  LabelStyle.FontStyle := [];
  if (BoldChk.Checked) then
    LabelStyle.FontStyle := LabelStyle.FontStyle + [fsBold];
  if (ItalicChk.Checked) then
    LabelStyle.FontStyle := LabelStyle.FontStyle + [fsItalic];
  LabelStyle.FontColor := FontColorSelector.SelectedColor;
  LabelStyle.BackColor := BackColorSelector.SelectedColor;
  LabelStyle.Caption := CaptionTxt.Text + '[]';
end;

// -----------------------------------------------------------------------------

procedure TKPIConfigLabelForm.SetLabelStyle(LabelStyle: TKPILabelStyle);
begin
  FontList.Text := LabelStyle.FontName;
  FontSizeSpin.Value := LabelStyle.FontSize;
  BoldChk.Checked := (fsBold in LabelStyle.FontStyle);
  ItalicChk.Checked := (fsItalic in LabelStyle.FontStyle);
  FontColorSelector.SelectedColor := LabelStyle.FontColor;
  BackColorSelector.SelectedColor := LabelStyle.BackColor;
  CaptionTxt.Text := StringReplace(LabelStyle.Caption, '[]', '', [rfReplaceall]);
  TitleBar.Caption := ' Configure Label for ' + StringReplace(LabelStyle.DefaultCaption, '[]', '', [rfReplaceall]);;
  StyleChanged(nil);
end;

// -----------------------------------------------------------------------------

procedure TKPIConfigLabelForm.StyleChanged(Sender: TObject);
begin
  CaptionTxt.Color := BackColorSelector.SelectedColor;
  CaptionTxt.Font.Color := FontColorSelector.SelectedColor;
  CaptionTxt.Font.Name := FontList.Text;
  CaptionTxt.Font.Size := FontSizeSpin.Value;
  CaptionTxt.Font.Style := [];
  if (BoldChk.Checked) then
    CaptionTxt.Font.Style := CaptionTxt.Font.Style + [fsBold];
  if (ItalicChk.Checked) then
    CaptionTxt.Font.Style := CaptionTxt.Font.Style + [fsItalic];
end;

// -----------------------------------------------------------------------------

procedure TKPIConfigLabelForm.FontColorSelectorSelect(Sender: TObject;
  Index: Integer; Item: TAdvSelectorItem);
begin
  StyleChanged(FontColorSelector);
end;

// -----------------------------------------------------------------------------

procedure TKPIConfigLabelForm.BackColorSelectorSelect(Sender: TObject;
  Index: Integer; Item: TAdvSelectorItem);
begin
  StyleChanged(BackColorSelector);
end;

// -----------------------------------------------------------------------------

procedure TKPIConfigLabelForm.DefaultBtnClick(Sender: TObject);
begin
  FontList.Text := 'Tahoma';
  FontSizeSpin.Value := 8;
  BoldChk.Checked := True;
  ItalicChk.Checked := False;
  FontColorSelector.SelectedColor := 0;
  BackColorSelector.SelectedColor := -2147483633;
  StyleChanged(nil);
end;

end.
