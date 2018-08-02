unit main;

{
  BJH: copied from Mark's VB demo
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterpriseSecurity_TLB, StdCtrls, ExtCtrls, ComObj;

type
  TfrmMain = class(TForm)
    edtSystemID: TLabeledEdit;
    edtESN: TLabeledEdit;
    lblVer: TLabel;
    edtSecurityID: TLabeledEdit;
    edtDescription: TLabeledEdit;
    cbSecurityType: TComboBox;
    Label1: TLabel;
    edtMessage: TLabeledEdit;
    btnPlugin1: TButton;
    btnPlugin2: TButton;
    btnPlugin3: TButton;
    btnPlugin4: TButton;
    Bevel1: TBevel;
    edtSystemStatus: TLabeledEdit;
    edtLicUserCount: TLabeledEdit;
    edtCurrUserCount: TLabeledEdit;
    btnReadSecurity: TButton;
    btnAddUser: TButton;
    btnRemoveUser: TButton;
    btnResetCount: TButton;
    pnlStatusBar: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtExpiryDate: TLabeledEdit;
    procedure btnAddUserClick(Sender: TObject);
    procedure btnReadSecurityClick(Sender: TObject);
    procedure btnRemoveUserClick(Sender: TObject);
    procedure btnResetCountClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PluginBtnClick(Sender: TObject);
  private
    FThirdParty: IThirdParty;
    procedure BlankUpperBoxes;
    procedure BlankLowerBoxes;
    function  CheckStatus(ReturnCode: integer): integer;
    procedure SB(TextMsg: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.BlankLowerBoxes;
begin
  edtSystemStatus.Text  := '';
  edtLicUserCount.Text  := '';
  edtCurrUserCount.Text := '';
  edtExpiryDate.Text := '';
end;

procedure TfrmMain.BlankUpperBoxes;
begin
  edtSystemID.Text         := '';
  edtSecurityID.Text       := '';
  edtDescription.Text      := '';
  cbSecurityType.ItemIndex := -1;
  edtMessage.Text          := '';
end;

procedure TfrmMain.btnAddUserClick(Sender: TObject);
begin
  SB('Adding another user...');
  CheckStatus(FThirdParty.AddUserCount);
  btnReadSecurityClick(nil);
end;

procedure TfrmMain.btnReadSecurityClick(Sender: TObject);
var
  rc: integer;
begin
  SB('Reading plugin security details...');
  with FThirdParty do begin
    tpSystemIdCode := edtSystemID.Text;
    tpSecurityCode := edtSecurityID.Text;
    tpDescription  := edtDescription.Text;
    tpSecurityType := cbSecurityType.ItemIndex;
    tpMessage      := edtMessage.Text;
    rc := ReadSecurity;
    if rc = 0 then begin

      BlankUpperBoxes;
      edtSystemID.Text         := tpSystemIdCode;
      edtSecurityID.Text       := tpSecurityCode;
      edtDescription.Text      := tpDescription;
      cbSecurityType.ItemIndex := ord(tpSecurityType);
      edtMessage.Text          := tpMessage;

      BlankLowerBoxes;
      case tpSystemStatus of
        SysExpired:  edtSystemStatus.Text := '0 - Disabled';
        Sys30Day:    edtSystemStatus.Text := '1 - 30-Day';
        SysReleased: edtSystemStatus.Text := '2 - Fully Released';
      else
        edtSystemStatus.Text := IntToStr(ord(tpSystemStatus)) + ' - Unknown';
      end;
      edtLicUserCount.Text  := IntToStr(tpUserCount);
      edtCurrUserCount.Text := IntToStr(tpCurrentUsers);

      edtExpiryDate.Text := (FThirdParty As IThirdParty2).tpExpiryDate;

      if Sender = nil then
        SB('OK - details updated and re-read')
      else
        SB('OK');
    end
    else begin
      BlankLowerBoxes;
      SB(format('Error %d: %s', [rc, LastErrorString]));
    end;
  end;
end;

procedure TfrmMain.btnRemoveUserClick(Sender: TObject);
begin
  SB('Removing a user...');
  CheckStatus(FThirdParty.RemoveUserCount);
  btnReadSecurityClick(nil);
end;

procedure TfrmMain.btnResetCountClick(Sender: TObject);
begin
  SB('Resetting user count...');
  CheckStatus(FThirdParty.ResetUserCount);
  btnReadSecurityClick(nil);
end;

function  TfrmMain.CheckStatus(ReturnCode: integer): integer;
begin
  result := ReturnCode;
  if ReturnCode = 0 then
    SB('OK')
  else
    SB(format('Error %d: %s', [ReturnCode, FThirdParty.LastErrorString]));
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  pnlStatusBar.SetFocus;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FThirdParty := CreateOLEObject('EnterpriseSecurity.ThirdParty') as IThirdParty;
  if FThirdParty = nil then
    lblVer.Caption := 'Bollocks !'
  else begin
    lblVer.Caption := FThirdParty.Version;
    edtESN.Text    := FThirdParty.ExchequerSiteNumber;
    PluginBtnClick(btnPlugin1);
  end;
end;

procedure TfrmMain.PluginBtnClick(Sender: TObject);
begin
  case TButton(Sender).Name[10] of
  '1':    begin
            edtSystemID.Text         := 'EXWAFFLEMA001056';
            edtSecurityID.Text       := '@AFn48D9!Dla$9aA';
            edtDescription.Text      := 'Exchequer Waffle Maker v1.00 for Enterprise';
            cbSecurityType.ItemIndex := 2; // System + User Count
            edtMessage.Text          := '';
          end;
  '2':    begin
            edtSystemID.Text         := 'EXCHBACSBC001057';
            edtSecurityID.Text       := 'WibbleWibbleWibb';
            edtDescription.Text      := 'Exchequer Barclays BACS Plug-In v1.32';
            cbSecurityType.ItemIndex := 0; // System Only
            edtMessage.Text          := 'For Sales or Technical help contact your Exchequer Reseller';
          end;
  '3':    begin
            edtSystemID.Text         := 'EXCHUPLIFT002156';
            edtSecurityID.Text       := 'tfilpU_reuqehcxE';
            edtDescription.Text      := 'Exchequer Uplift Plug-In v3.00';
            cbSecurityType.ItemIndex := 1; // User Count Only
            edtMessage.Text          := 'Contact Sales on +44 (0) 1202 298008';
          end;
  '4':    begin
            edtSystemID.Text         := 'EXCARRIAGE002149';
            edtSecurityID.Text       := 'airraC_reuqehcxE';
            edtDescription.Text      := 'Exchequer SOR Carriage Plug-In v2.00';
            cbSecurityType.ItemIndex := 2; // System + User Count
            edtMessage.Text          := '';
          end;
  end;
  BlankLowerBoxes;
  SB('OK');
end;

procedure TfrmMain.SB(TextMsg: string);
begin
  pnlStatusBar.Caption := ' ' + TextMsg;
  application.ProcessMessages;
end;

end.
