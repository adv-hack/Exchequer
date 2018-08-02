unit SelField;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, BtrvU2, BTSupU1, GlobVar, GlobType,
  VarConst, DataDict, bkgroup;

type
  TForm_SelectField = class(TForm)
    Button_Select: TButton;
    Button_Cancel: TButton;
    Combo_File: TSBSComboBox;
    List_Fields: TListBox;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    procedure FormCreate(Sender: TObject);
    procedure Button_SelectClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure List_FieldsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Combo_FileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Ok : Boolean;
    ShortCode : String10;
    ListMode : Byte;
    Procedure SetShortCode (NewCode : String10);
    procedure LoadForFile (Const FileNo : SmallInt);
  end;

var
  Form_SelectField: TForm_SelectField;

implementation

{$R *.DFM}

Uses ETStrU, FormUtil;

procedure TForm_SelectField.FormCreate(Sender: TObject);
begin
  Ok := False;
  ListMode := 1;

  LoadFileCombo (Combo_File.Items);
  Combo_File.ItemIndex := 0;
  {LoadList (Sender);}
end;

procedure TForm_SelectField.Button_SelectClick(Sender: TObject);
begin
  Ok := True;
  Close;
end;

procedure TForm_SelectField.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

{ highlight this field in the list }
Procedure TForm_SelectField.SetShortCode (NewCode : String10);
Var
  LineStr : String;
  I       : Integer;
begin
  If (List_Fields.ItemIndex < 0) Then
    List_Fields.ItemIndex := 0;

  If (Trim(NewCode) <> '') Then Begin
    If (List_Fields.Items.Count > 0) Then Begin
      { Pad code out to 8 chars }
      NewCode := LJVar (NewCode, 8);

      { Find best match }
      For I := 0 To (List_Fields.Items.Count - 1) Do Begin
        LineStr := Copy (List_Fields.Items.Strings[I], 1, 8);
        If (LineStr >= NewCode) Then Begin
          List_Fields.ItemIndex := I;
          Break;
        End; { If }
      End; { For }
    End; { If }
  End; { If }

  If (List_Fields.ItemIndex >= 0) Then
    List_FieldsClick(Self);
end;

procedure TForm_SelectField.List_FieldsClick(Sender: TObject);
Var
  TmpStr : ShortString;
begin
  { Clicky clicky }
  TmpStr := Copy (List_Fields.Items.Strings[List_Fields.ItemIndex], 1, 8);
  If (Pos(#9, TmpStr) > 0) Then
    Delete(TmpStr, Pos(#9, TmpStr), Length(TmpStr));

  ShortCode := TmpStr;
end;

procedure TForm_SelectField.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_SelectField.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_SelectField.LoadForFile (Const FileNo : SmallInt);
begin
  If (Combo_File.ItemIndex <> FileNo) Or (List_Fields.Items.Count = 0) Then Begin
    Combo_File.ItemIndex := FileNo;

    Combo_FileClick(Self);
  End; { If }
end;

procedure TForm_SelectField.Combo_FileClick(Sender: TObject);
Var
  WantF : Byte;
begin
  { Get file number from combo }
  WantF := GetFileComboFileNo (Combo_File.ItemIndex);

  List_Fields.Clear;
  LoadFieldList(List_Fields, WantF, 2);
end;

end.
