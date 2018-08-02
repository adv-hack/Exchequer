unit dbfldopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {ShareMem,} SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, GlobType, DataDict, BorBtns,
  bkgroup;

type
  TForm_DbFldOpt = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    Panel_Font: TSBSPanel;
    Label_Font: Label8;
    FontDialog1: TFontDialog;
    Button_Select: TButton;
    Text_ShortCode: Text8Pt;
    Button_SelectFont: TButton;
    Ccy_Decs: TCurrencyEdit;
    Combo_Align: TSBSComboBox;
    BorChk_BlankZero: TBorCheck;
    SBSPanel3: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label_Description: Label8;
    Label_Type: Label8;
    procedure Button_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_SelectFontClick(Sender: TObject);
    procedure Button_SelectClick(Sender: TObject);
    procedure Text_ShortCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button_IfClick(Sender: TObject);
    procedure Label_DescriptionDblClick(Sender: TObject);
  private
    { Private declarations }
    DataRec    : DataDictRec;
    pShortCode : String10;
    procedure DispDataRec (Const Changed : Boolean);
  public
    { Public declarations }
    Ok: Boolean;
    procedure SetShortCode (Const ShortCode : String10);
    Function  GetShortCode : String10;
    Function  GetFieldLen : Byte;
    Procedure SetAlign (Const fdAlign : TAlignment);
    Function  GetAlign : TAlignment;
  end;

var
  Form_DbFldOpt: TForm_DbFldOpt;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, EtStrU, FormUtil, SelFld2, VarRPosU, Options;

procedure TForm_DbFldOpt.FormCreate(Sender: TObject);
begin
  Ok := False;
  pShortCode := '';

  FillChar (DataRec, SizeOf (DataRec), #0);

  { Default to left justified }
  Combo_Align.ItemIndex := 0;
end;


procedure TForm_DbFldOpt.Button_SaveClick(Sender: TObject);
begin
  If (DataRec.DataVarRec.VarType <> 0) Then Begin
    If (Round(Ccy_Decs.Value) In [0..9]) Then Begin
      Ok := True;
      Close;
    End { If }
    Else Begin
      If Ccy_Decs.CanFocus Then Ccy_Decs.SetFocus;
      MessageDlg ('The Decimals must be in the range 0 to 9', mtError, [mbOk], 0);
    End; { Else }
  End { If }
  Else Begin
    If Text_ShortCode.CanFocus Then Text_ShortCode.SetFocus;
    MessageDlg ('The Code must be set to a valid field code', mtError, [mbOk], 0);
  End; { Else }
end;

procedure TForm_DbFldOpt.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_DbFldOpt.SetShortCode (Const ShortCode : String10);
begin
  Text_ShortCode.Text := ShortCode;
  Text_ShortCodeExit(Self);
end;

Function TForm_DbFldOpt.GetShortCode : String10;
begin
  Result := pShortcode;
End;

Function TForm_DbFldOpt.GetFieldLen : Byte;
begin
  Result := DataRec.DataVarRec.VarLen;
End;

procedure TForm_DbFldOpt.Button_SelectFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign (Label_Font.Font);
  FontDialog1.Execute;
  Label_Font.Font.Assign(FontDialog1.Font);
end;

procedure TForm_DbFldOpt.Button_SelectClick(Sender: TObject);
Var
  PrevCur     : TCursor;
  Want, Found : Str20;
begin
  CursorToHourglass (PrevCur);

  { Check global form has been created - global form used so it can remain in }
  { memory and avoid having to reload the lists eaach time                    }
  If (Not Assigned(Form_SelectField2)) Then Begin
    Form_SelectField2 := TForm_SelectField2.Create (Application.MainForm);
  End; { If }

  Try
    If (DbFileNo = -1) Then DbFileNo := TabNo_Trans;
    Form_SelectField2.SetShortCode (Trim(Text_ShortCode.Text), DbFileNo);

    CursorForDialog;
    Form_SelectField2.ShowModal;
    CursorFromDialog;

    If Form_SelectField2.Ok Then Begin
      { Copy field details }
      DbFileNo := Form_SelectField2.PageControl1.ActivePage.Tag;

      Text_ShortCode.Text := Trim(Form_SelectField2.ShortCode);
      Text_ShortCodeExit(Sender);
    End; { If }
  Finally
    {Form_SelectField2.Free;}
  End;

  RestoreCursor (PrevCur);
end;

procedure TForm_DbFldOpt.Text_ShortCodeExit(Sender: TObject);
Var
  Changed : Boolean;
begin
  { Validate the code }
  If (Text_ShortCode.Text <> '') Then Begin
    { Check to see if its changed }
    Changed := (Trim(UpperCase(pShortCode)) <> Trim(UpperCase(Text_ShortCode.Text)));

    pShortCode := LJVar (Text_ShortCode.Text, 8);

    CheckXRef (pShortCode, DataRec);

    DispDataRec (Changed);
  End; { If }
end;

procedure TForm_DbFldOpt.DispDataRec (Const Changed : Boolean);
begin
  With DataRec.DataVarRec Do Begin
    Label_Description.Caption := VarDesc;
    Label_Description.Tag := VarNo;
    If (VarType <> 0) Then Begin
      Label_Type.Caption := DataTypesL^[VarType];

      If (VarType = 1) Then Begin
        { Its a String - add length }
        Label_Type.Caption := Label_Type.Caption + IntToStr (VarLen);
      End; { If }

      If (VarType In [2, 3]) And Changed Then Begin
        { Its changed and its a floating point number }
        Ccy_Decs.Enabled := True;
        Ccy_Decs.Value := VarNoDec;

        { Set to left justified }
        Combo_Align.ItemIndex := 2;

        { Check if its a special decs job }
        If (VarDec) Then
          Case VarDecType of
            1 : Ccy_Decs.Value := Syss.NoCosDec;
            2 : Ccy_Decs.Value := Syss.NoNetDec;
            3 : Ccy_Decs.Value := Syss.NoQtyDec;
          End; {Case..}
      End { If }
      Else
        Ccy_Decs.Enabled := (VarType In [2, 3]);
    End { If }
    Else Begin
      { Not a valid field }
      Label_Type.Caption := '';
      Ccy_Decs.Enabled := False;
    End; { Else }
  End; { With }
end;

procedure TForm_DbFldOpt.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_DbFldOpt.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TForm_DbFldOpt.SetAlign (Const fdAlign : TAlignment);
begin
  Case fdAlign Of
    taLeftJustify  : Combo_Align.ItemIndex := 0;
    taCenter       : Combo_Align.ItemIndex := 1;
    taRightJustify : Combo_Align.ItemIndex := 2;
  Else
    Combo_Align.ItemIndex := 0;
  End; { Case }
end;

Function TForm_DbFldOpt.GetAlign : TAlignment;
begin
  Case Combo_Align.ItemIndex Of
    0 : Result := taLeftJustify;
    1 : Result := taCenter;
    2 : Result := taRightJustify;
  Else
    Result := taLeftJustify;
  End; { Case }
end;

procedure TForm_DbFldOpt.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  DLLIfOptions(Label_If);
  RestoreCursor (PrevCur);
end;

procedure TForm_DbFldOpt.Label_DescriptionDblClick(Sender: TObject);
begin
  ShowMessage (IntToStr(Label_Description.Tag));
end;

end.
