unit SQLLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSQLLoginDetails = Record
    bWindowsAuth : WordBool;
    asUsername : ANSIString;
    asPassword : ANSIString;
    bRemember : boolean;
  end;

  TfrmSQLLogin = class(TForm)
    Bevel1: TBevel;
    lPassword: TLabel;
    edPassword: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    rbWindows: TRadioButton;
    rbSQL: TRadioButton;
    edUserName: TEdit;
    lUsername: TLabel;
    cbRemember: TCheckBox;
    procedure RadioChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetSQLLoginDetails(var SQLLoginDetails : TSQLLoginDetails) : boolean;

var
  SavedSQLLoginDetails : TSQLLoginDetails;

implementation

function GetSQLLoginDetails(var SQLLoginDetails : TSQLLoginDetails) : boolean;
var
  frmSQLLogin: TfrmSQLLogin;
begin
  frmSQLLogin := TfrmSQLLogin.Create(nil);
  try
    frmSQLLogin.rbWindows.checked := SavedSQLLoginDetails.bWindowsAuth;
    frmSQLLogin.rbSQL.checked := not SavedSQLLoginDetails.bWindowsAuth;
    frmSQLLogin.edUsername.Text := SavedSQLLoginDetails.asUsername;
    frmSQLLogin.edPassword.Text := SavedSQLLoginDetails.asPassword;
    frmSQLLogin.cbRemember.checked := SavedSQLLoginDetails.bRemember;

    Result := frmSQLLogin.Showmodal = mrOK;
    if Result then
    begin
      SQLLoginDetails.bWindowsAuth := frmSQLLogin.rbWindows.checked;
      SQLLoginDetails.asUsername := frmSQLLogin.edUsername.Text;
      SQLLoginDetails.asPassword := frmSQLLogin.edPassword.Text;
      SQLLoginDetails.bRemember := frmSQLLogin.cbRemember.checked;
      if SQLLoginDetails.bRemember then SavedSQLLoginDetails := SQLLoginDetails;
    end;{if}

  finally
    frmSQLLogin.Release;
  end;{try}
end;

procedure TfrmSQLLogin.RadioChange(Sender: TObject);
begin
  edPassword.Enabled := rbSQL.Checked;
  lPassword.Enabled := rbSQL.Checked;
  edUserName.Enabled := rbSQL.Checked;
  lUserName.Enabled := rbSQL.Checked;
end;

initialization
  SavedSQLLoginDetails.bWindowsAuth := TRUE;
  SavedSQLLoginDetails.bRemember := FALSE;

{$R *.dfm}

end.
