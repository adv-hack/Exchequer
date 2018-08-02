unit PaprSize;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GlobType, StdCtrls, ExtCtrls, SBSPanel;

type
  TForm_PaperSizes = class(TForm)
    List_Sizes: TListBox;
    Button_Select: TButton;
    Button_Close: TButton;
    Button_Add: TButton;
    Button_Edit: TButton;
    Button_Delete: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_AddClick(Sender: TObject);
    procedure Button_EditClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_SelectClick(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);
    Procedure LoadList (Sender: TObject);
    procedure List_SizesDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Selecting : Boolean;
    Function EditSize (Editing : Boolean) : Boolean;
  public
    { Public declarations }
    Ok : Boolean;
    procedure SetForSelect;
    procedure SetButtons;
  end;

var
  Form_PaperSizes: TForm_PaperSizes;

Procedure MaintainPaperSizes;
Function  SelectPaperSize (Var SizeRec : PaperSizeType) : Boolean;
Procedure AddDefaultPaperSizes;

implementation

{$R *.DFM}

Uses BtrvU2, BTSupU1, GlobVar, VarConst, FormFile, FormUtil, PSizeDlg;

Procedure MaintainPaperSizes;
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  Form_PaperSizes := TForm_PaperSizes.Create (Application);
  Try
    { Init form here }
    Form_PaperSizes.SetButtons;

    CursorForDialog;
    Form_PaperSizes.ShowModal;
    CursorFromDialog;

    If Form_PaperSizes.Ok Then Begin
      { Ok pressed }
    End; { If }
  Finally
    Form_PaperSizes.Release;
  End;

  RestoreCursor (PrevCur);
end;

Function SelectPaperSize (Var SizeRec : PaperSizeType) : Boolean;
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  Result := False;

  Form_PaperSizes := TForm_PaperSizes.Create (Application);
  Try
    { Init form here }
    Form_PaperSizes.SetForSelect;
    Form_PaperSizes.SetButtons;

    CursorForDialog;
    Form_PaperSizes.ShowModal;
    CursorFromDialog;

    If Form_PaperSizes.Ok Then Begin
      { Ok pressed }
      SizeRec := PaperSizeRec^;
    End; { If }

    Result := Form_PaperSizes.Ok;
  Finally
    Form_PaperSizes.Release;
  End;

  RestoreCursor (PrevCur);
end;


Procedure AddDefaultPaperSizes;

  Procedure AddDef (Const pDescr : fhNameType;
                    Const pH, pW, pTop, pBot, pLeft, pRight : Word);
  begin
    FillChar (PaperSizeRec^, SizeOf (PaperSizeRec^), #0);
    With PaperSizeRec^ Do Begin
      psUser        := False;
      psDescr       := pDescr;
      psHeight      := pH;
      psWidth       := pW;
      psTopWaste    := pTop;
      psBottomWaste := pBot;
      psLeftWaste   := pLeft;
      psRightWaste  := pRight;
    End; { With }
    Status := Add_rec(F[PaperSizeF],PaperSizeF,RecPtr[PaperSizeF]^,0);
    Report_Berror (PaperSizeF, Status);
  end;

begin
  AddDef ('A4 (Epson LQ-850)', 297, 210, 0, 0, 7, 1);
  AddDef ('A4 (LaserJet 4)', 297, 210, 7, 6, 7, 8);
end;

procedure TForm_PaperSizes.FormCreate(Sender: TObject);
begin
  Ok := False;
  Selecting := False;

  { Load sizes into list }
  LoadList (Sender);
end;

procedure TForm_PaperSizes.FormDestroy(Sender: TObject);
begin
  {  }
end;

Procedure TForm_PaperSizes.SetButtons;
Var
  UpBy : Integer;
begin
  Button_Select.Visible := Selecting;
  Button_Close.Visible := True;
  Button_Add.Visible := (Not Selecting);
  Button_Edit.Visible := (Not Selecting);
  Button_Delete.Visible := (Not Selecting);

  If (Not Selecting) Then Begin
    { Need to reposition the buttons now the select button has been removed }
    UpBy := Button_Close.Top - Button_Select.Top;
    Button_Close.Top := Button_Close.Top - UpBy;
    Button_Add.Top := Button_Add.Top - UpBy;
    Button_Edit.Top := Button_Edit.Top - UpBy;
    Button_Delete.Top := Button_Delete.Top - UpBy;
  End; { If }
end;

Procedure TForm_PaperSizes.LoadList (Sender: TObject);
Const
  FNum    = PaperSizeF;
  KeyPath = Key_PS_Descr;
Var
  KeyS    : Str255;
begin
  { Get first record }
  FillChar (KeyS, SizeOf (KeyS), #0);
  Status := Find_Rec (B_GetFirst, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  List_Sizes.Clear;
  While (Status = 0) Do Begin
    { Add into list }
    List_Sizes.Items.Add (PaperSizeRec^.psDescr);

    { Get next }
    Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  End; { While }
end;

procedure TForm_PaperSizes.SetForSelect;
begin
  Caption := 'Select Paper Size';
  Selecting := True;
  Button_Add.Caption := '&Select';
  Button_Edit.Caption := '&Cancel';
end;

{ adds a new size or edits an existing size }
Function TForm_PaperSizes.EditSize (Editing : Boolean) : Boolean;
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  Result := False;

  Form_SizeDialog := TForm_SizeDialog.Create (Self);
  Try
    { Init form here }
    If Editing Then
      Form_SizeDialog.SetForEdit
    Else
      Form_SizeDialog.SetForAdd;

    CursorForDialog;
    Form_SizeDialog.ShowModal;
    CursorFromDialog;

    If Form_SizeDialog.Ok Then Begin
      { Ok pressed - Retrieve record }

      If Editing Then Begin
        { update database }
        Status := Put_Rec(F[PaperSizeF],PaperSizeF,RecPtr[PaperSizeF]^,0);
      End { If }
      Else Begin
        { insert into database }
        Status := Add_Rec(F[PaperSizeF],PaperSizeF,RecPtr[PaperSizeF]^,0);
      End; { Else }
      Report_Berror (PaperSizeF, Status);
    End; { If }

    Result := Form_SizeDialog.Ok;
  Finally
    Form_SizeDialog.Release;
  End;

  RestoreCursor (PrevCur);
end;

{ Add a new size }
procedure TForm_PaperSizes.Button_AddClick(Sender: TObject);
begin
  { Initialise size record }
  FillChar (PaperSizeRec^, SizeOf (PaperSizeRec^), #0);
  With PaperSizeRec^ Do Begin
    psUser        := True;
    psDescr       := '';
    psHeight      := 297;
    psWidth       := 210;
    psTopWaste    := 14;
    psBottomWaste := 14;
    psLeftWaste   := 30;
    psRightWaste  := 30;
  End; { With }

  If Editsize (False) Then
    { Update List }
    LoadList (Sender);
end;

{ Edit an existing size }
procedure TForm_PaperSizes.Button_EditClick(Sender: TObject);
Var
  KeyS   : Str255;
  Locked : Boolean;
begin
  If (List_Sizes.ItemIndex > -1) Then Begin
    { Get and lock record? }
    KeyS := List_Sizes.Items.Strings[List_Sizes.ItemIndex];
    If GetMultiRec(B_GetEq, B_MultLock, KeyS, Key_PS_Descr, PaperSizeF, True, Locked) Then Begin
      If (Not Editsize (True)) Then Begin
        { Unlock record }
        If Locked Then Status := UnlockMultiSing(F[PaperSizeF],PaperSizeF,0);
      End; { If }

      { Update List }
      LoadList (Sender);
    End; { If }
  End; { If }
end;

{ Delete an existing size }
procedure TForm_PaperSizes.Button_DeleteClick(Sender: TObject);
Var
  KeyS   : Str255;
  Locked : Boolean;
begin
  If (List_Sizes.ItemIndex > -1) Then Begin
    If (MessageDlg('Are you sure you want to delete ' + PaperSizeRec^.psDescr + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
      { Get and lock record? }
      KeyS := List_Sizes.Items.Strings[List_Sizes.ItemIndex];
      If GetMultiRec(B_GetEq, B_MultLock, KeyS, Key_PS_Descr, PaperSizeF, True, Locked) Then
        Status := Delete_rec(F[PaperSizeF], PaperSizeF, Key_PS_Descr);
      Report_BError (PaperSizeF, Status);

      { Update List }
      LoadList (Sender);
    End; { If }
  End; { If }
end;

procedure TForm_PaperSizes.Button_SelectClick(Sender: TObject);
Var
  KeyS : Str255;
begin
  If (List_Sizes.ItemIndex > -1) Then Begin
    { Get and lock record? }
    KeyS := List_Sizes.Items.Strings[List_Sizes.ItemIndex];
    Status := Find_Rec (B_GetEq, F[PaperSizeF], PaperSizeF, RecPtr[PaperSizeF]^, Key_PS_Descr, KeyS);

    If (Status = 0) Then Begin
      Ok := True;
      Close;
    End { If }
    Else
      Report_Berror (PaperSizeF, Status);
  End; { If }
end;

procedure TForm_PaperSizes.Button_CloseClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_PaperSizes.List_SizesDblClick(Sender: TObject);
begin
  If Selecting Then
    Button_SelectClick(Sender)
  Else
    Button_EditClick(Sender);
end;

procedure TForm_PaperSizes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_PaperSizes.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
