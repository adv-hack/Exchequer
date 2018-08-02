unit pagnoopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, bkgroup;

type
  TForm_PageNoOptions = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    SBSPanel2: TSBSPanel;
    Label_Font: Label8;
    FontDialog1: TFontDialog;
    Edit_Leading: Text8Pt;
    Edit_Trailing: Text8Pt;
    Button_SelectFont: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    Combo_Align: TSBSComboBox;
    Label88: Label8;
    procedure FormCreate(Sender: TObject);
    procedure UpdateText(Sender: TObject);
    procedure Button_SelectFontClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Ok : Boolean;

    Procedure SetLeadingText (TextStr : String);
    Procedure SetTrailingText (TextStr : String);
    Procedure GetLeadingText (Var TextStr : String);
    Procedure GetTrailingText (Var TextStr : String);
    Procedure SetFont (Thefont : TFont);
    Procedure GetFont (Var Thefont : TFont);
    Procedure SetAlign (Const fdAlign : TAlignment);
    Function  GetAlign : TAlignment;
  end;

var
  Form_PageNoOptions: TForm_PageNoOptions;

implementation

{$R *.DFM}

Uses FormUtil;

procedure TForm_PageNoOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

procedure TForm_PageNoOptions.UpdateText(Sender: TObject);
begin
  Label_Font.Caption := Edit_Leading.Text + ' %P ' + Edit_Trailing.Text;
end;

procedure TForm_PageNoOptions.Button_SelectFontClick(Sender: TObject);
begin
  FontDialog1.Execute;
  Label_Font.Font.Assign(FontDialog1.Font);
end;

Procedure TForm_PageNoOptions.SetLeadingText (TextStr : String);
begin
  Edit_Leading.Text := TextStr;
end;

Procedure TForm_PageNoOptions.SetTrailingText (TextStr : String);
begin
  Edit_Trailing.Text := TextStr;
end;

Procedure TForm_PageNoOptions.GetLeadingText (Var TextStr : String);
begin
  TextStr := Edit_Leading.Text;
end;

Procedure TForm_PageNoOptions.GetTrailingText (Var TextStr : String);
begin
  TextStr := Edit_Trailing.Text;
end;

Procedure TForm_PageNoOptions.SetFont (Thefont : TFont);
begin
  FontDialog1.Font.Assign (TheFont);
  Label_Font.Font.Assign(FontDialog1.Font);
end;

Procedure TForm_PageNoOptions.GetFont (Var Thefont : TFont);
begin
  TheFont.Assign (FontDialog1.Font);
end;

procedure TForm_PageNoOptions.Button_SaveClick(Sender: TObject);
begin
  Ok := True;
  Close;
end;

procedure TForm_PageNoOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_PageNoOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_PageNoOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TForm_PageNoOptions.SetAlign (Const fdAlign : TAlignment);
begin
  Case fdAlign Of
    taLeftJustify  : Combo_Align.ItemIndex := 0;
    taCenter       : Combo_Align.ItemIndex := 1;
    taRightJustify : Combo_Align.ItemIndex := 2;
  Else
    Combo_Align.ItemIndex := 0;
  End; { Case }
end;

Function TForm_PageNoOptions.GetAlign : TAlignment;
begin
  Case Combo_Align.ItemIndex Of
    0 : Result := taLeftJustify;
    1 : Result := taCenter;
    2 : Result := taRightJustify;
  Else
    Result := taLeftJustify;
  End; { Case }
end;

end.
