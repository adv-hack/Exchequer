unit Setup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Registry;

type
  TfrmSetup = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    pcSettings: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edKUserName: TEdit;
    edKPassword: TEdit;
    edKCompany: TEdit;
    Label1: TLabel;
    Label6: TLabel;
    edTMAccountNo: TEdit;
    edTMCompany: TEdit;
    Label7: TLabel;
    Label9: TLabel;
    edSenderEmail: TEdit;
    edSMTPServer: TEdit;
    Label10: TLabel;
    cmbGateway: TComboBox;
    cbMAPI: TCheckBox;
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
  SMSEMAILINI : TIniFile;
begin
  pcSettings.ActivePageIndex := 0;
  SMSEMAILINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'SMSEMAIL.INI');
  with SMSEMAILINI do begin

    cmbGateway.ItemIndex := cmbGateway.Items.IndexOf(ReadString('Settings','Type','Kapow'));
    edSMTPServer.Text := ReadString('Settings','SMTPServer','');
    edSenderEmail.Text := ReadString('Settings','SenderEmailAddress','');
    cbMAPI.Checked := Uppercase(ReadString('Settings','UseMAPI','FALSE'))= 'TRUE';

    edKCompany.Text := ReadString('Kapow','Company','kapow.co.uk');
    edKUserName.Text := ReadString('Kapow','UserName','');
    edKPassword.Text := ReadString('Kapow','Password','');

    edTMCompany.Text := ReadString('Text Marketer','Company','textmarketer.co.uk');
    edTMAccountNo.Text := ReadString('Text Marketer','AccountNo','');

    Free;
  end;{with}
end;

procedure TfrmSetup.btnOKClick(Sender: TObject);
var
  SMSEMAILINI : TIniFile;
begin
  SMSEMAILINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'SMSEMAIL.INI');
  with SMSEMAILINI do begin

    WriteString('Settings','Type',cmbGateway.Items[cmbGateway.ItemIndex]);
    WriteString('Settings','SMTPServer',edSMTPServer.Text);
    WriteString('Settings','SenderEmailAddress',edSenderEmail.Text);
    if cbMAPI.Checked then WriteString('Settings','UseMAPI','TRUE')
    else WriteString('Settings','UseMAPI','FALSE');

    WriteString('Kapow','Company',edKCompany.Text);
    WriteString('Kapow','UserName',edKUserName.Text);
    WriteString('Kapow','Password',edKPassword.Text);

    WriteString('Text Marketer','Company',edTMCompany.Text);
    WriteString('Text Marketer','AccountNo',edTMAccountNo.Text);

    Free;
  end;{with}
end;

end.
