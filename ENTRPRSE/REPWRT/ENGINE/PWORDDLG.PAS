unit PWordDlg;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, SBSOutl;

type
  PwordType = String[8];

  TPword = Class(TObject)
  Public
    PWord : PwordType;
  End;

  TRWPasswordDialog = class(TForm)
    MsgLbl: Label8;
    edtPWord: Text8Pt;
    OKBtn: TButton;
    CancelBtn: TButton;
    lblGroup: Label8;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    Ok : Boolean;
    Function GetMsg : ShortString;
    Procedure SetMsg(Value : ShortString);
  public
    { Public declarations }
    Password : PwordType;
    Property Msg : ShortString Read GetMsg write SetMsg;
    Function Execute : Boolean;
  end;


{ Check to see if password already supplied }
Function CheckPwordList (Const CheckPw : ShortString) : Boolean;

{ Request password entry and store in password list }
Function RequestPassword (Const ONomRec : OutNomType) : Boolean;

{ Returns encrypted version of daily password }
Function SysPWord : ShortString;


implementation

{$R *.DFM}

Uses Crypto, HelpSupU, {SecureU,} DailyPW;

Var
  PWordList : TList;

{ Displays the password entry dialog and places   }
{ the entered password into the Password property }
Function TRWPasswordDialog.Execute : Boolean;
Begin
  { Re-Initialise }
  Ok := False;
  Password := '';
  edtPWord.Text := '';
  ActiveControl := edtPWord;

  { Display }
  ShowModal;

  { Return result }
  Result := Ok;
End;

Function TRWPasswordDialog.GetMsg : ShortString;
Begin
  Result := MsgLbl.Caption;
End;

Procedure TRWPasswordDialog.SetMsg(Value : ShortString);
Begin
  MsgLbl.Caption := Value;
End;

procedure TRWPasswordDialog.OKBtnClick(Sender: TObject);
Var
  TmpStr : ShortString;
begin
  { Encrypt Password }
  TmpStr := Trim(edtPWord.Text);

  If (TmpStr <> '') Then
    Password := EncodeKey(11837, TmpStr)
  Else
    Password := '';

  Ok := True;
  Close;
end;

procedure TRWPasswordDialog.CancelBtnClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

{--------------------------------------------------------}

Function SysPWord : ShortString;
Begin { SysPWord }
  Result := EncodeKey(11837, Get_TodaySecurity);
End; { SysPword }

{--------------------------------------------------------}

{ Check to see if password already supplied }
Function CheckPwordList (Const CheckPw : ShortString) : Boolean;
Var
  PW : TPword;
  I  : SmallInt;
Begin { CheckPwordList }
  Result := False;

  If (PwordList.Count > 0) Then
    For I := 0 To Pred(PwordList.Count) Do Begin
      PW := PwordList[I];

      If (Pw.PWord = CheckPw) Then Begin
        Result := True;
        Break;
      End; { If (Pw.PWord = CheckPw) }
    End; { For I }
End; { CheckPwordList }

{--------------------------------------------------------}

{ Request password entry and store in password list }
Function RequestPassword (Const ONomRec : OutNomType) : Boolean;
Var
  oPW         : TPword;
  PasswordDlg : TRWPasswordDialog;
  DlgRes      : Boolean;
  TryCount    : Byte;
Begin { RequestPassword }
  Result := False;

  PasswordDlg := TRWPasswordDialog.Create(Application.MainForm);
  Try
    With PasswordDlg Do Begin
      lblGroup.Caption := ONomRec.GrpDesc;

      TryCount := 0;
      Repeat
        Inc (TryCount);

        { Execute password dialog }
        DlgRes := Execute;

        If DlgRes Then Begin
          { User clicked OK - check password }
          Result := Password = ONomRec.GrpPword;

          If Result Then Begin
            { Add into password list }
            oPW := TPword.Create;
            oPW.Pword := Password;
            PwordList.Add (oPW);
          End { If Result }
          Else
            If (Password = SysPWord) Then
              { System password }
              Result := True
            Else
              { Incorrect password }
              MessageDlg ('Incorrect Password', mtWarning, [mbOk], 0);
        End; { If DlgRes }
      Until Result Or (Not DlgRes) Or (TryCount = 3);
    End; { With PasswordDlg }
  Finally
    FreeAndNil(PasswordDlg);
  End;
End; { RequestPassword }

{--------------------------------------------------------}

Procedure KillPwordList;
Var
  PW : TPword;
Begin { KillPwordList }
  While (PwordList.Count > 0) Do Begin
    PW := PwordList[0];
    PW.Destroy;

    PwordList.Delete(0);
  End; { While }

  FreeAndNil(PwordList);
End; { KillPwordList }

{--------------------------------------------------------}

Initialization
  PWordList := TList.Create;
Finalization
  KillPwordList;
end.
