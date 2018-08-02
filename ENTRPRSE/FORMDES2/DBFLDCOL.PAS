unit Dbfldcol;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, SBSPanel, Mask, ExtCtrls, GlobType, DataDict,
  ComCtrls, bkgroup;

type
  TForm_AddFieldCol = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    FontDialog1: TFontDialog;
    PageControl1: TPageControl;
    TabSh_Field: TTabSheet;
    Panel_Font: TSBSPanel;
    Label_Font: Label8;
    Button_SelectFont: TButton;
    Button_Select: TButton;
    Text_ShortCode: Text8Pt;
    TabSh_Column: TTabSheet;
    Check_ColSep: TBorCheck;
    CcyVal_Width: TCurrencyEdit;
    Combo_Align: TSBSComboBox;
    Ccy_Decs: TCurrencyEdit;
    Text_Title: Text8Pt;
    Check_HideCol: TBorCheck;
    BorChk_BlankZero: TBorCheck;
    SBSPanel3: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label89: Label8;
    Label88: Label8;
    Label84: Label8;
    Label82: Label8;
    Label81: Label8;
    Label_Description: Label8;
    Label_Type: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    procedure Button_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_SelectFontClick(Sender: TObject);
    procedure Button_SelectClick(Sender: TObject);
    procedure Text_ShortCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RecalcColWidth(Sender: TObject);
    procedure Button_IfClick(Sender: TObject);
  private
    { Private declarations }
    DataRec     : DataDictRec;
    pShortCode  : String10;
    WantRecalc  : Boolean;
    WarnedBlank : Boolean;
    procedure DispDataRec (Const Changed : Boolean);
  public
    { Public declarations }
    Ok     : Boolean;
    procedure SetShortCode (Const ShortCode : String10);
    Function  GetShortCode : String10;
    Function  GetFieldLen : Byte;
    Procedure SetForm (Const Edit : Boolean);
    Procedure SetAlign (Const fdAlign : TAlignment);
    Function  GetAlign : TAlignment;
  end;

var
  Form_AddFieldCol: TForm_AddFieldCol;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, PageComp, EtStrU, FormUtil, SelFld2, VarRPosU,
     Options;

procedure TForm_AddFieldCol.FormCreate(Sender: TObject);
begin
  Ok := False;
  WantRecalc := True;
  WarnedBlank := False;

  FillChar (DataRec, SizeOf (DataRec), #0);

  { show field page }
  PageControl1.ActivePage := TabSh_Field;

  { Default to left justified }
  Combo_Align.ItemIndex := 0;
end;

procedure TForm_AddFieldCol.Button_SaveClick(Sender: TObject);
begin
  If (DataRec.DataVarRec.VarType <> 0) Then Begin
    If (Not WarnedBlank) And (Trim(Text_Title.Text) = '') Then Begin
      { Give warning that the column title is blank }
      WarnedBlank := True;
      PageControl1.ActivePage := TabSh_Column;
      If Text_Title.CanFocus Then Text_Title.SetFocus;
      MessageDlg ('Warning: The column title is blank', mtInformation, [mbOk], 0);
    End { If }
    Else Begin
      If (Round(Ccy_Decs.Value) In [0..9]) Then Begin
        Ok := True;
        Close;
      End { If }
      Else Begin
        If Ccy_Decs.CanFocus Then Ccy_Decs.SetFocus;
        MessageDlg ('The Decimals must be in the range 0 to 9', mtError, [mbOk], 0);
      End; { Else }
    End; { Else }
  End { If }
  Else Begin
    If Text_ShortCode.CanFocus Then Text_ShortCode.SetFocus;
    MessageDlg ('The Code must be set to a valid field code', mtError, [mbOk], 0);
  End; { Else }
end;

procedure TForm_AddFieldCol.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_AddFieldCol.SetShortCode (Const ShortCode : String10);
begin
  Text_ShortCode.Text := ShortCode;
  Text_ShortCodeExit(Self);
end;

Function TForm_AddFieldCol.GetShortCode : String10;
begin
  Result := pShortcode;
End;

Function TForm_AddFieldCol.GetFieldLen : Byte;
begin
  Result := DataRec.DataVarRec.VarLen;
End;

procedure TForm_AddFieldCol.Button_SelectFontClick(Sender: TObject);
Var
  Changed : Boolean;
begin
  FontDialog1.Font.Assign (Label_Font.Font);
  FontDialog1.Execute;

  { Check the font has changed }
  Changed := (FontDialog1.Font.Size <> Label_Font.Font.Size) Or
             (FontDialog1.Font.Name <> Label_Font.Font.Name) Or
             (FontDialog1.Font.Style <> Label_Font.Font.Style);

  Label_Font.Font.Assign(FontDialog1.Font);

  If Changed Then RecalcColWidth(Sender);
end;

procedure TForm_AddFieldCol.Button_SelectClick(Sender: TObject);
Var
  PrevCur  : TCursor;
begin
  CursorToHourglass (PrevCur);

  If (Not Assigned(Form_SelectField2)) Then
    Form_SelectField2 := TForm_SelectField2.Create (Application.MainForm);

  Try
    If (DbFileNo = -1) Then DbFileNo := TabNo_Lines;
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

procedure TForm_AddFieldCol.Text_ShortCodeExit(Sender: TObject);
Var
  Changed : Boolean;
begin
  { Validate the code }
  If (Text_ShortCode.Text <> '') Then Begin
    Changed := (pShortCode <> LJVar (Text_ShortCode.Text, 8));

    pShortCode := LJVar (Text_ShortCode.Text, 8);

    CheckXRef (pShortCode, DataRec);

    If Changed Then RecalcColWidth(Sender);

    DispDataRec (Changed);
  End; { If }
end;

procedure TForm_AddFieldCol.DispDataRec (Const Changed : Boolean);
begin
  With DataRec.DataVarRec Do Begin
    Label_Description.Caption := VarDesc;
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
        If (VarDec) Then Begin
          Case VarDecType of
            1 : Ccy_Decs.Value := Syss.NoCosDec;
            2 : Ccy_Decs.Value := Syss.NoNetDec;
            3 : Ccy_Decs.Value := Syss.NoQtyDec;
          End; {Case..}
        End; { If }
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

procedure TForm_AddFieldCol.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_AddFieldCol.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TForm_AddFieldCol.SetForm (Const Edit : Boolean);
begin
  If Edit Then Begin
    { Editing }
    Caption := 'Edit Field Column';
  End { If }
  Else Begin
    { Adding }
    Caption := 'Add Field Column';
  End; { Else }
end;

Procedure TForm_AddFieldCol.SetAlign (Const fdAlign : TAlignment);
begin
  Case fdAlign Of
    taLeftJustify  : Combo_Align.ItemIndex := 0;
    taCenter       : Combo_Align.ItemIndex := 1;
    taRightJustify : Combo_Align.ItemIndex := 2;
  Else
    Combo_Align.ItemIndex := 0;
  End; { Case }
end;

Function TForm_AddFieldCol.GetAlign : TAlignment;
begin
  Case Combo_Align.ItemIndex Of
    0 : Result := taLeftJustify;
    1 : Result := taCenter;
    2 : Result := taRightJustify;
  Else
    Result := taLeftJustify;
  End; { Case }
end;

procedure TForm_AddFieldCol.RecalcColWidth(Sender: TObject);
Var
  TheRect : TRect;
  SizeStr : PChar;
  Width   : Integer;
begin
  Label_Font.Refresh;
  If WantRecalc And (DataRec.DataVarRec.VarLen > 0) Then Begin
    { Get size of font }
    SizeStr := StrAlloc (DataRec.DataVarRec.VarLen + 1);
    TheRect := Rect (1, 1, 2, 2);
    StrPCopy(SizeStr, ConstStr ('S', DataRec.DataVarRec.VarLen));
    DrawText (Label_Font.Canvas.Handle, SizeStr, Length(SizeStr), TheRect, (DT_CALCRECT Or DT_SINGLELINE));
    StrDispose (SizeStr);

    { Set control size }
    Width := (TheRect.Right - TheRect.Left);

    If Assigned(SystemInfo.ControllerHandle) Then Begin
      With TSBSController(SystemInfo.ControllerHandle) Do
        Width := Round(Width / Paper.psScaling);
    End { If }
    Else
      Width := Width Div DefaultPixPerMM;
    Width := Width + 3;  { Add wobble factor to increase chance of field fitting }

    If (Width > 0) Then Begin
      CcyVal_Width.Value := Width;
    End; { If }
  End; { If }
end;

procedure TForm_AddFieldCol.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  DLLIfOptions(Label_If);
  RestoreCursor (PrevCur);
end;

end.
