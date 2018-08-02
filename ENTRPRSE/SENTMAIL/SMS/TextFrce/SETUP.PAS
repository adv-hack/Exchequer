unit setup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmSetup = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    Label3: TLabel;
    edtTimeOut: TEdit;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtProxy: TEdit;
    edtProxyPort: TEdit;
    chkUseProxy: TCheckBox;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Label4: TLabel;
    rbLocal: TRadioButton;
    rbDialup: TRadioButton;
    chkDisconnect: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rbLocalClick(Sender: TObject);
  private
    { Private declarations }
    IniFileName : String;
    procedure ReadFile;
    procedure WriteFile;
  public
    { Public declarations }
  end;

var
  frmSetup: TfrmSetup;

implementation

{$R *.dfm}
uses
  IniFiles, RegUtil;

procedure TfrmSetup.ReadFile;
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(IniFileName);
  Try
    edtTimeOut.Text := TheIni.ReadString('Settings','TimeOut', '60');
    edtProxy.Text := TheIni.ReadString('Proxy Settings','Proxy', '');
    edtProxyPort.Text := TheIni.ReadString('Proxy Settings','ProxyPort', '0');
    chkUseProxy.Checked := TheIni.ReadBool('Proxy Settings','UseProxy',False);
    rbDialup.Checked := TheIni.ReadBool('Settings','Dialup',False);
    chkDisconnect.Checked := TheIni.ReadBool('Settings','Hangup',True);
    rbLocal.Checked := not rbDialup.checked;
    rbLocalClick(Self);
  Finally
    TheIni.Free;
  End;
end;

procedure TfrmSetup.WriteFile;
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(IniFileName);
  Try
    TheIni.WriteString('Proxy Settings','Proxy', Trim(edtProxy.Text));
    TheIni.WriteString('Proxy Settings','ProxyPort', Trim(edtProxyPort.Text));
    TheIni.WriteBool('Proxy Settings','UseProxy',chkUseProxy.Checked);
    TheIni.WriteString('Settings','TimeOut', edtTimeOut.Text);
    TheIni.WriteBool('Settings','Dialup',rbDialup.Checked);
    TheIni.WriteBool('Settings','Hangup',chkDisconnect.Checked);
  Finally
    TheIni.Free;
  End;
end;


procedure TfrmSetup.FormCreate(Sender: TObject);
begin
  IniFileName := GetCOMObjectDir('EnterpriseSMS.SMSSender') +
                        'SmsWap.ini';
  ReadFile;
end;

procedure TfrmSetup.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i : integer;
begin
  if ModalResult = mrOk then
  begin
    if chkUseProxy.Checked then
    begin
      if Trim(edtProxy.Text) = '' then
      begin
        ShowMessage('Proxy must be specified');
        ActiveControl := edtProxy;
        CanClose := False;
      end
      else
      Try
        i := StrToInt(edtProxyPort.Text);
      Except
        ShowMessage('Proxy Port must be an integer');
        ActiveControl := edtProxyPort;
        CanClose := False;
      End;
    end;

    Try
      i := StrToInt(edtTimeOut.Text);
    Except
      ShowMessage('Timeout must be an integer');
      ActiveControl := edtTimeOut;
      CanClose := False;
    End;

    if CanClose then
      WriteFile;
  end;

end;

procedure TfrmSetup.rbLocalClick(Sender: TObject);
begin
  chkDisconnect.Visible := rbDialup.Checked;
end;

end.
