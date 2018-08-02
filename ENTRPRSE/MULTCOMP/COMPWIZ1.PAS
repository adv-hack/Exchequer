unit CompWiz1;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, StdCtrls, Mask, TEditVal, ExtCtrls;

type
  TCompDetail1 = class(TSetupTemplate)
    cpName: Text8Pt;
    cpCode: Text8Pt;
    Label1: TLabel;
    procedure cpNameExit(Sender: TObject);
    procedure cpNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    NameChanged : Boolean;
    Function CheckCodeOk : Boolean;
    Function InvalidCode : Boolean;
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public

    { Public declarations }
    Editing  : Boolean;
    OrigCode : String[6];
  end;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, BtrvU2, BtKeys1U, EntInitU;

{ Look for a company with matching code and path }
Function TCompDetail1.CheckCodeOk : Boolean;
Const
  FNum    = CompF;
  KeyPath = CompCodeK;
Var
  CurrComp : CompRec;
  KeyS     : Str255;
Begin
  { Check code is unique if adding, or if they've changed it }
  If (Not Editing) Or (UpperCase(Trim(OrigCode)) <> UpperCase(Trim(cpCode.Text))) Then Begin
    { Save existing company record }
    CurrComp := Company^;

    { Lock record the hard way as I don't want to use BTSUPU1 }
    KeyS := FullCompCodeKey(cmCompDet, Trim(cpCode.Text));
    Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    Result := (Status <> 0) Or (Trim(Company^.CompDet.CompCode) <> Trim(cpCode.Text));

    { Restore company details }
    Company^ := CurrComp;
    Status   := 0;
  End { If }
  Else
    Result := True;
End;

{ Returns True if all entry fields are ok }
Function TCompDetail1.ValidOk(VCode : Char) : Boolean;
Begin
  If (VCode = 'N') Then Begin
    Result := False;

    If (Trim(cpCode.Text) <> '') Then Begin
      { Code is set - check it is unique }
      If CheckCodeOk Then Begin
        Result := (Trim (cpName.Text) <> '');

        If (Not Result) Then
          MessageDlg ('The Company Name cannot be left blank', mtWarning, [mbOk], 0);
      End { If }
      Else
        MessageDlg ('A Company already exists with this Code', mtWarning, [mbOk], 0);
    End { If }
    Else
      MessageDlg ('The Company Code cannot be left blank', mtWarning, [mbOk], 0);
  End { If }
  Else
    Result := True;
End;


{ Check the company code to see if it is a) set and b) excel friendly }
Function TCompDetail1.InvalidCode : Boolean;
Var
  I : SmallInt;
Begin
  Result := (Trim(cpCode.Text) = '');

  If (Not Result) Then Begin
    { Have some characters - make sure there not all numeric }
    For I := 1 To Length(cpCode.Text) Do Begin
      If (cpCode.Text[I] In ['a'..'z', 'A'..'Z']) Then Begin
        Result := False;
        Break;
      End; { If }
    End; { For }
  End; { If }
End;


procedure TCompDetail1.cpNameExit(Sender: TObject);
begin
  inherited;

  If {(Not Editing) And} (Trim (cpName.Text) <> '') And (NameChanged Or InvalidCode) Then
    cpCode.Text := Auto_GetCompCode(cpName.Text);
end;

procedure TCompDetail1.cpNameChange(Sender: TObject);
begin
  inherited;

  If Visible Then
    NameChanged := True;
end;

procedure TCompDetail1.FormCreate(Sender: TObject);
begin
  inherited;

  NameChanged := False;
end;

end.
