unit textopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, GlobType, bkgroup, BorBtns;

type
  TForm_TextOptions = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    SBSPanel2: TSBSPanel;
    Label_Font: Label8;
    FontDialog1: TFontDialog;
    Memo_Text: TMemo;
    Combo_Align: TSBSComboBox;
    Button_SelectFont: TButton;
    SBSPanel3: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    Label88: Label8;
    chkSymbolFont: TBorCheck;
    procedure Button_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Edit_TextChange(Sender: TObject);
    procedure Button_SelectFontClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button_IfClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Ok       : Boolean;
    DragCont : TObject;
    FOnIf    : TIfLabelEvent;
    Procedure SetAlign (Const fdAlign : TAlignment);
    Function  GetAlign : TAlignment;
  end;

var
  Form_TextOptions: TForm_TextOptions;
                                  
implementation

{$R *.DFM}

Uses FormUtil, DllInt;

procedure TForm_TextOptions.FormCreate(Sender: TObject);
begin
  Ok := False;

  { Default to left justified }
  Combo_Align.ItemIndex := 0;
end;

procedure TForm_TextOptions.Button_SaveClick(Sender: TObject);
begin
  Ok := True;
  Close;
end;

procedure TForm_TextOptions.Button_CancelClick(Sender: TObject);
begin
  Close;
end;


procedure TForm_TextOptions.Edit_TextChange(Sender: TObject);
begin
  { Set font label to current contents }
  Label_Font.Caption := Memo_Text.Text;
end;

procedure TForm_TextOptions.Button_SelectFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Label_Font.Font);
  FontDialog1.Execute;
  Label_Font.Font.Assign(FontDialog1.Font);
end;

Procedure TForm_TextOptions.SetAlign (Const fdAlign : TAlignment);
begin
  Case fdAlign Of
    taLeftJustify  : Combo_Align.ItemIndex := 0;
    taCenter       : Combo_Align.ItemIndex := 1;
    taRightJustify : Combo_Align.ItemIndex := 2;
  Else
    Combo_Align.ItemIndex := 0;
  End; { Case }
end;

Function TForm_TextOptions.GetAlign : TAlignment;
begin
  Case Combo_Align.ItemIndex Of
    0 : Result := taLeftJustify;
    1 : Result := taCenter;
    2 : Result := taRightJustify;
  Else
    Result := taLeftJustify;
  End; { Case }
end;

procedure TForm_TextOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_TextOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_TextOptions.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  If Assigned (FOnIf) Then FOnIf (DragCont, Label_If);
  RestoreCursor (PrevCur);
end;

end.
