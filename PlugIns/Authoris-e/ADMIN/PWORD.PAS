unit pword;

{ prutherford440 09:36 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfrmAdminPassword = class(TForm)
    Panel1: TPanel;
    edtPassword: TEdit;
    Label1: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FPassword : ShortString;
  public
    { Public declarations }
    function OverridePassword : ShortString;
    property Password : ShortString read FPassword write FPassword;
  end;

  function CheckPassword(const RealPassword : ShortString) : Boolean;

implementation

{$R *.DFM}
uses
  DailyPW;

function CheckPassword(const RealPassword : ShortString) : Boolean;
begin
  Result := Length(Trim(RealPassWord)) = 0;

  if not Result then
  with TfrmAdminPassword.Create(nil) do
  try
    Password := RealPassword;
    ShowModal;
    if ModalResult = mrOK then
      Result := True;
  Finally
    Free;
  End;
end;

procedure TfrmAdminPassword.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
    CanClose := (edtPassword.Text = FPassword) or
                 (edtPassword.Text = OverridePassword);
  if not CanClose then
    ShowMessage('Incorrect password');
end;

function TfrmAdminPassword.OverridePassword : ShortString;
begin
  Result := Trim(Get_TodaySecurity)
end;

end.
