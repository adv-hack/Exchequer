unit UserDet;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, APIUtil;

type
  TfrmUserDetails = class(TForm)
    Label1: TLabel;
    edUserName: TEdit;
    edSenderName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edEmailAddress: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetFields(sUser, sSender, sEmail : string);
  end;

{var
  frmUserDetails: TfrmUserDetails;}

implementation

{$R *.DFM}

procedure TfrmUserDetails.SetFields(sUser, sSender, sEmail : string);
begin
  edUserName.Text := sUser;
  edSenderName.Text := sSender;
  edEmailAddress.Text := sEmail;
end;

procedure TfrmUserDetails.btnOKClick(Sender: TObject);
begin
  if (edSenderName.Text = '') or (edSenderName.Text = ' ') or (edUserName.Text = '')
  or (edUserName.Text = ' ') then begin
    MsgBox('You must fill in both the ''Login Name'' and the ''Display Name'' Fields. ',mtError,[mbOK],mbOK,'Input Error');
    ModalResult := mrNone;
  end;{if}
end;

end.
