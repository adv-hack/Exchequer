unit enginef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type

  TEnginesRunningRec = Record
    Email, SMS, Fax, FTP,
    Alerts, Reports, HighPriority, LowPriority : Boolean;
  end;

  TfrmEngines = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    chkEmail: TCheckBox;
    chkSMS: TCheckBox;
    chkFax: TCheckBox;
    chkFTP: TCheckBox;
    GroupBox2: TGroupBox;
    chkAlerts: TCheckBox;
    chkReports: TCheckBox;
    GroupBox3: TGroupBox;
    chkHigh: TCheckBox;
    chkLow: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowEnginesRunning(ERec : TEnginesRunningRec);

var
  frmEngines: TfrmEngines;



implementation

{$R *.dfm}

procedure ShowEnginesRunning(ERec : TEnginesRunningRec);
begin
  with TfrmEngines.Create(nil) do
  Try
    chkEmail.Checked := EREc.Email;
    chkSMS.Checked := ERec.SMS;
    chkFax.Checked := ERec.Fax;
    chkFTP.Checked := ERec.FTP;
    chkAlerts.Checked := ERec.Alerts;
    chkReports.Checked := ERec.Reports;
    chkHigh.Checked := ERec.HighPriority;
    chkLow.Checked := ERec.LowPriority;
    ShowModal;
  Finally
    Free;
  End;
end;

end.
