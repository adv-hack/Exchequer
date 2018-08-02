unit psizedlg;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, bkgroup;

type
  TForm_SizeDialog = class(TForm)
    SBSBackGroup1: TSBSBackGroup;
    Label_Descr: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Label84: Label8;
    Label85: Label8;
    SBSBackGroup3: TSBSBackGroup;
    Label811: Label8;
    Label810: Label8;
    Label813: Label8;
    Label812: Label8;
    Button_Ok: TButton;
    Button_Cancel: TButton;
    Text_Description: Text8Pt;
    Ccy_Height: TCurrencyEdit;
    Ccy_Width: TCurrencyEdit;
    Ccy_Top: TCurrencyEdit;
    Ccy_Left: TCurrencyEdit;
    Ccy_Right: TCurrencyEdit;
    Ccy_Bottom: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_OkClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure EditVal_HeightChange(Sender: TObject);
    procedure EditVal_WidthChange(Sender: TObject);
    procedure EditVal_TopChange(Sender: TObject);
    procedure EditVal_BottomChange(Sender: TObject);
    procedure EditVal_LeftChange(Sender: TObject);
    procedure EditVal_RightChange(Sender: TObject);
    procedure Text_DescriptionChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Function  ValidateFields : Boolean;
    Procedure ErrMsg (Const Msg : String);
  public
    { Public declarations }
    Ok  : Boolean;
    procedure SetForAdd;
    procedure SetForEdit;
    procedure DispRec;
  end;

var
  Form_SizeDialog: TForm_SizeDialog;

implementation

{$R *.DFM}

Uses BtrvU2, BTSupU1, BTSupU2, GlobVar, VarConst, FormFile, FormUtil;

procedure TForm_SizeDialog.FormCreate(Sender: TObject);
begin
  {  }
  Ok := False;
end;

procedure TForm_SizeDialog.FormDestroy(Sender: TObject);
begin
  {  }
end;

procedure TForm_SizeDialog.SetForAdd;
begin
  Caption := 'Add Paper Size';
  DispRec;
end;

procedure TForm_SizeDialog.SetForEdit;
begin
  Caption := 'Edit Paper Size';
  DispRec;
end;

procedure TForm_SizeDialog.DispRec;
begin
  With PaperSizeRec^ Do Begin
    Text_Description.Text := Trim(psDescr);
    Ccy_Height.Value := psHeight;
    Ccy_Width.Value := psWidth;
    Ccy_Top.Value := psTopWaste;
    Ccy_Bottom.Value := psBottomWaste;
    Ccy_Left.Value := psLeftWaste;
    Ccy_Right.Value := psRightWaste;
  End; { With }
end;

procedure TForm_SizeDialog.Button_OkClick(Sender: TObject);
begin
  Ok := ValidateFields;
  If Ok Then Close;
end;

procedure TForm_SizeDialog.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_SizeDialog.EditVal_HeightChange(Sender: TObject);
begin
  If (Ccy_Height.Value > 0) Then
    PaperSizeRec^.psHeight := Round(Ccy_Height.Value)
  Else
    Ccy_Height.Value := PaperSizeRec^.psHeight;
end;

procedure TForm_SizeDialog.EditVal_WidthChange(Sender: TObject);
begin
  If (Ccy_Width.Value > 0) Then
    PaperSizeRec^.psWidth := Round(Ccy_Width.Value)
  Else
    Ccy_Width.Value := PaperSizeRec^.psWidth;
end;

procedure TForm_SizeDialog.EditVal_TopChange(Sender: TObject);
begin
  If (Ccy_Top.Value >= 0) And (Ccy_Top.Value < PaperSizeRec^.psHeight) Then
    PaperSizeRec^.psTopWaste := Round(Ccy_Top.Value)
  Else
    Ccy_Top.Value := PaperSizeRec^.psTopWaste;
end;

procedure TForm_SizeDialog.EditVal_BottomChange(Sender: TObject);
begin
  If (Ccy_Bottom.Value >= 0) And (Ccy_Bottom.Value < (PaperSizeRec^.psHeight - PaperSizeRec^.psTopWaste)) Then
    PaperSizeRec^.psBottomWaste := Round (Ccy_Bottom.Value)
  Else
    Ccy_Bottom.Value := PaperSizeRec^.psBottomWaste;
end;

procedure TForm_SizeDialog.EditVal_LeftChange(Sender: TObject);
begin
  If (Ccy_Left.Value >= 0) And (Ccy_Left.Value < PaperSizeRec^.psWidth) Then
    PaperSizeRec^.psLeftWaste := Round(Ccy_Left.Value)
  Else
    Ccy_Left.Value := PaperSizeRec^.psLeftWaste;
end;

procedure TForm_SizeDialog.EditVal_RightChange(Sender: TObject);
begin
  If (Ccy_Right.Value >= 0) And (Ccy_Right.Value < (PaperSizeRec^.psWidth - PaperSizeRec^.psLeftWaste)) Then
    PaperSizeRec^.psRightWaste := Round(Ccy_Right.Value)
  Else
    Ccy_Right.Value := PaperSizeRec^.psRightWaste;
end;

procedure TForm_SizeDialog.Text_DescriptionChange(Sender: TObject);
begin
  PaperSizeRec^.psDescr := Text_Description.Text;
end;

procedure TForm_SizeDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_SizeDialog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TForm_SizeDialog.ErrMsg (Const Msg : String);
begin
  MessageDlg (Msg,
              mtInformation,
              [mbOk],
              0);
end;

Function TForm_SizeDialog.ValidateFields : Boolean;
begin
  Result := True;
  With PaperSizeRec^ Do Begin
    psDescr := Trim(Text_Description.Text);
    If (psDescr <> '') Then Begin
      psHeight := Round (Ccy_Height.Value);
      If Not ((psHeight > 10) And (psHeight <= 420)) Then Begin
        { Height not valid }
        Ccy_Height.SetFocus;
        Result := False;
        ErrMsg ('The Height must be between 10 and 420.');
      End; { If }

      If Result Then Begin
        psWidth := Round (Ccy_Width.Value);
        If Not ((psWidth > 10) And (psWidth <= 420)) Then Begin
          { Width not valid }
          Ccy_Width.SetFocus;
          Result := False;
          ErrMsg ('The Width must be between 10 and 420.');
        End; { If }
      End; { If }

      If Result Then Begin
        psTopWaste := Round (Ccy_Top.Value);
        If Not ((psTopWaste >= 0) And (psTopWaste < psHeight)) Then Begin
          { Rop not valid }
          Ccy_Top.SetFocus;
          Result := False;
          ErrMsg ('The Top Margin must be between 0 and the Height specified.');
        End; { If }
      End; { If }

      If Result Then Begin
        psBottomWaste := Round(Ccy_Bottom.Value);
        If Not ((psBottomWaste >= 0) And (psBottomWaste < (psHeight - psTopWaste))) Then Begin
          { Bottom not valid }
          Ccy_Bottom.SetFocus;
          Result := False;
          ErrMsg ('The Bottom Margin must be between 0 and the Height specified less the Top Margin specified.');
        End; { If }
      End; { If }

      If Result Then Begin
        psLeftWaste := Round(Ccy_Left.Value);
        If Not ((psLeftWaste >= 0) And (psLeftWaste <= psWidth)) Then Begin
          { Left margin not valid }
          Ccy_Left.SetFocus;
          Result := False;
          ErrMsg ('The Left Margin must be between 0 and the Width specified.');
        End; { If }
      End; { If }

      If Result Then Begin
        psRightWaste := Round(Ccy_Right.Value);
        If Not ((psRightWaste >= 0) And (psRightWaste < (psWidth - psLeftWaste))) Then Begin
          { Right Margin not valid }
          Ccy_Right.SetFocus;
          Result := False;
          ErrMsg ('The Right Margin must be between 0 and the Width specified less the Left Margin specified.');
        End; { If }
      End; { If }
    End { If }
    Else Begin
      { Description is blank }
      Text_Description.SetFocus;
      Result := False;
      ErrMsg ('The Description cannot be left blank.');
    End; { Else }
  End; { With }
end;

end.
