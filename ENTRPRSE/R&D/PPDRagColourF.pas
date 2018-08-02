unit PPDRagColourF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSelectors, StdCtrls;

type
  TfrmSelectPPDRagColours = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edtExampleText: TEdit;
    AdvTextColorSelector1: TAdvTextColorSelector;
    AdvColorSelector1: TAdvColorSelector;
    Label1: TLabel;
    Label2: TLabel;
    chkFontBold: TCheckBox;
    chkFontItalic: TCheckBox;
    chkFontUnderline: TCheckBox;
    chkFontStrikeOut: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    ColorDialog1: TColorDialog;
    procedure AdvColorSelector1Click(Sender: TObject);
    procedure AdvTextColorSelector1Click(Sender: TObject);
    procedure chkFontBoldClick(Sender: TObject);
    procedure chkFontItalicClick(Sender: TObject);
    procedure chkFontUnderlineClick(Sender: TObject);
    procedure chkFontStrikeOutClick(Sender: TObject);
    procedure AdvColorSelector1Select(Sender: TObject; Index: Integer;
      Item: TAdvSelectorItem);
    procedure AdvTextColorSelector1Select(Sender: TObject; Index: Integer;
      Item: TAdvSelectorItem);
  private
    { Private declarations }
    Function GetBackgroundColour : TColor;
    Procedure SetBackgroundColour (Value : TColor);
    Function GetExampleText : String;
    Procedure SetExampleText(Value : String);
    Function GetFontColour : TColor;
    Procedure SetFontColour (Value : TColor);
    Function GetFontStyle : TFontStyles;
    Procedure SetFontStyle (Value : TFontStyles);
  public
    { Public declarations }
    Property BackgroundColour : TColor Read GetBackgroundColour Write SetBackgroundColour;
    Property ExampleText : String Read GetExampleText Write SetExampleText;
    Property FontColour : TColor Read GetFontColour Write SetFontColour;
    Property FontStyle : TFontStyles Read GetFontStyle Write SetFontStyle;
  end;

Procedure DisplayPPDColourSelection(Const Owner : TForm; Const Source : TEdit);

implementation

{$R *.dfm}

//=========================================================================

Procedure DisplayPPDColourSelection(Const Owner : TForm; Const Source : TEdit);
Begin // DisplayPPDColourSelection
  With TfrmSelectPPDRagColours.Create(Owner) Do
  Begin
    Try
      ExampleText := Source.Text;
      BackgroundColour := Source.Color;
      FontColour := Source.Font.Color;
      FontStyle := Source.Font.Style;

      If (ShowModal = mrOK) Then
      Begin
        Source.Text := ExampleText;
        Source.Color := BackgroundColour;
        Source.Font.Color := FontColour;
        Source.Font.Style := FontStyle;
      End; // If (ShowModal = mrOK); // If (ShowModal = mrOK)
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmSelectPPDRagColours.Create(Self)
End; // DisplayPPDColourSelection

//=========================================================================

Function TfrmSelectPPDRagColours.GetBackgroundColour : TColor;
Begin // GetBackgroundColour
  Result := edtExampleText.Color;
End; // GetBackgroundColour
Procedure TfrmSelectPPDRagColours.SetBackgroundColour (Value : TColor);
Begin // SetBackgroundColour
  edtExampleText.Color := Value;

  AdvColorSelector1.SelectedColor := Value;
End; // SetBackgroundColour

//------------------------------

Function TfrmSelectPPDRagColours.GetExampleText : String;
Begin // GetExampleText
  Result := edtExampleText.Text;
End; // GetExampleText
Procedure TfrmSelectPPDRagColours.SetExampleText(Value : String);
Begin // SetExampleText
  edtExampleText.Text := Value;
End; // SetExampleText

//------------------------------

Function TfrmSelectPPDRagColours.GetFontColour : TColor;
Begin // GetFontColour
  Result := edtExampleText.Font.Color;
End; // GetFontColour
Procedure TfrmSelectPPDRagColours.SetFontColour (Value : TColor);
Begin // SetFontColour
  edtExampleText.Font.Color := Value;

  AdvTextColorSelector1.SelectedColor := Value;
End; // SetFontColour

//------------------------------

Function TfrmSelectPPDRagColours.GetFontStyle : TFontStyles;
Begin // GetFontStyle
  Result := edtExampleText.Font.Style;
End; // GetFontStyle
Procedure TfrmSelectPPDRagColours.SetFontStyle (Value : TFontStyles);
Begin // SetFontStyle
  edtExampleText.Font.Style := Value;

  chkFontBold.Checked := fsBold In Value;
  chkFontItalic.Checked := fsItalic In Value;
  chkFontUnderline.Checked := fsUnderline In Value;
  chkFontStrikeOut.Checked := fsStrikeout In Value;
End; // SetFontStyle

//-------------------------------------------------------------------------

procedure TfrmSelectPPDRagColours.AdvColorSelector1Click(Sender: TObject);
begin
  // Not sure when/if this fires
  edtExampleText.Color := AdvColorSelector1.SelectedColor;
end;

procedure TfrmSelectPPDRagColours.AdvColorSelector1Select(Sender: TObject; Index: Integer; Item: TAdvSelectorItem);
begin
  If (Item.Caption = 'More Colors...') Then
  Begin
    ColorDialog1.Color := AdvColorSelector1.SelectedColor;
    If ColorDialog1.Execute Then
    Begin
      AdvColorSelector1.SelectedColor := ColorDialog1.Color;
      edtExampleText.Color := AdvColorSelector1.SelectedColor;
    End; // If ColorDialog1.Execute
  End // If (Item.Caption = 'More Colors...')
  Else
    edtExampleText.Color := AdvColorSelector1.SelectedColor;
end;

//------------------------------

procedure TfrmSelectPPDRagColours.AdvTextColorSelector1Click(Sender: TObject);
begin
  // Not sure when/if this fires
  edtExampleText.Font.Color := AdvTextColorSelector1.SelectedColor;
end;

procedure TfrmSelectPPDRagColours.AdvTextColorSelector1Select(Sender: TObject; Index: Integer; Item: TAdvSelectorItem);
begin
  edtExampleText.Font.Color := AdvTextColorSelector1.SelectedColor;
end;

//------------------------------

procedure TfrmSelectPPDRagColours.chkFontBoldClick(Sender: TObject);
begin
  If chkFontBold.Checked Then
    edtExampleText.Font.Style := edtExampleText.Font.Style + [fsBold]
  Else
    edtExampleText.Font.Style := edtExampleText.Font.Style - [fsBold]
end;

//------------------------------

procedure TfrmSelectPPDRagColours.chkFontItalicClick(Sender: TObject);
begin
  If chkFontItalic.Checked Then
    edtExampleText.Font.Style := edtExampleText.Font.Style + [fsItalic]
  Else
    edtExampleText.Font.Style := edtExampleText.Font.Style - [fsItalic]
end;

//------------------------------

procedure TfrmSelectPPDRagColours.chkFontUnderlineClick(Sender: TObject);
begin
  If chkFontUnderline.Checked Then
    edtExampleText.Font.Style := edtExampleText.Font.Style + [fsUnderline]
  Else
    edtExampleText.Font.Style := edtExampleText.Font.Style - [fsUnderline]
end;

//------------------------------

procedure TfrmSelectPPDRagColours.chkFontStrikeOutClick(Sender: TObject);
begin
  If chkFontStrikeOut.Checked Then
    edtExampleText.Font.Style := edtExampleText.Font.Style + [fsStrikeout]
  Else
    edtExampleText.Font.Style := edtExampleText.Font.Style - [fsStrikeout]
end;

//=========================================================================

end.
