unit Setup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Registry;

type
  TfrmSetup = class(TForm)
    btnOK: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnCancel: TButton;
    edURL: TEdit;
    edUserName: TEdit;
    edCompany: TEdit;
    edPassword: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetup: TfrmSetup;
  
implementation
uses
  Inifiles, RegUtil;

{$R *.dfm}

procedure TfrmSetup.FormCreate(Sender: TObject);
var
  SMSMMCINI : TIniFile;
  sParity : string;
begin
  SMSMMCINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'SMSMMC.INI');
  with SMSMMCINI do begin
    edURL.Text := ReadString('Settings','URL','http://gateway.mobilemessagecentre.com/soap/mmc.dll');
    edUserName.Text := ReadString('Settings','UserName','');
    edPassword.Text := ReadString('Settings','Password','');
    edCompany.Text := ReadString('Settings','Company','');
    Free;
  end;{with}
end;

procedure TfrmSetup.btnOKClick(Sender: TObject);
var
  SMSMMCINI : TIniFile;
begin
  SMSMMCINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'SMSMMC.INI');
  with SMSMMCINI do begin
    WriteString('Settings','URL',edURL.Text);
    WriteString('Settings','UserName',edUserName.Text);
    WriteString('Settings','Password',edPassword.Text);
    WriteString('Settings','Company',edCompany.Text);
    Free;
  end;{with}
end;

end.
