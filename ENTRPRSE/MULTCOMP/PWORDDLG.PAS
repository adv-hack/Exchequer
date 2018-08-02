unit PWordDlg;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls;

type
  TPasswordDialog = class(TForm)
    PWord: Text8Pt;
    OKBtn: TButton;
    CancelBtn: TButton;
    lblTitle: TLabel;
    lblMsg: TLabel;
    IconImage: TImage;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    Ok : Boolean;
    Function GetMsg : ShortString;
    Procedure SetMsg(Value : ShortString);
    function GetTitle: ShortString;
    procedure SetTitle(const Value: ShortString);
  public
    { Public declarations }
    Password : ShortString;
    Property Msg : ShortString Read GetMsg write SetMsg;
    Property Title : ShortString Read GetTitle write SetTitle;
    Function Execute : Boolean;
  end;

implementation

{$R *.DFM}

Uses Crypto;

{ Displays the password entry dialog and places   }
{ the entered password into the Password property }
Function TPasswordDialog.Execute : Boolean;
Begin
  { Re-Initialise }
  Ok := False;
  Password := '';
  PWord.Text := '';
  ActiveControl := PWord;

  { Display }
  ShowModal;

  { Return result }
  Result := Ok;
End;

Function TPasswordDialog.GetMsg : ShortString;
Begin
  Result := lblMsg.Caption;
End;

Procedure TPasswordDialog.SetMsg(Value : ShortString);
Begin
  lblMsg.Caption := Value;
End;

procedure TPasswordDialog.OKBtnClick(Sender: TObject);
begin
  // HM 24/05/00: Modified password encryption as experienced problems trying to log-in
  { Encrypt Password }
  //Password := Encode (PWord.Text);
  Password := EncodeKey (23130, PWord.Text);

  Ok := True;
  Close;
end;

procedure TPasswordDialog.CancelBtnClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

function TPasswordDialog.GetTitle: ShortString;
begin
  Result := lblTitle.Caption;
end;

procedure TPasswordDialog.SetTitle(const Value: ShortString);
begin
  lblTitle.Caption := Value;
end;

end.
