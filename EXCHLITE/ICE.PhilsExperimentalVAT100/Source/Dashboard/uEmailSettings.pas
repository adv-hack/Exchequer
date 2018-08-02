{-----------------------------------------------------------------------------
 Unit Name: uEmailSettings
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
unit uEmailSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, StdCtrls, AdvEdit, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, htmlbtns, AdvOfficeButtons, AdvPanel,
  ufrmbase
  ;

type
  //TfrmEmailSettings = class(TForm)
  TfrmEmailSettings = class(TFrmbase)
    AdvOfficePagerOfficeStyler: TAdvOfficePagerOfficeStyler;
    opPOPConf: TAdvOfficePager;
    ofpAdvanced: TAdvOfficePage;
    Label13: TLabel;
    Bevel1: TBevel;
    Label14: TLabel;
    Label15: TLabel;
    edtPOP3Port: TAdvEdit;
    edtSMTPPort: TAdvEdit;
    btmUseDefault: TAdvGlowButton;
    ofpOutgoingServer: TAdvOfficePage;
    ckbOutgoingAuth: TAdvOfficeCheckBox;
    rbSameasIncoming: THTMLRadioButton;
    edtOutgoingUserName: TAdvEdit;
    lblLogonUser: TLabel;
    lblLogonPassw: TLabel;
    edtOutgoingPassword: TAdvEdit;
    rbLogonUsing: THTMLRadioButton;
    pnlButtons: TAdvPanel;
    btnOK: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ckbPOPEncrypted: TAdvOfficeCheckBox;
    ckbSMTPEncrypted: TAdvOfficeCheckBox;
    edtMailBoxName: TAdvEdit;
    edtMailBoxSeparator: TAdvEdit;
    procedure ckbOutgoingAuthClick(Sender: TObject);
    procedure rbSameasIncomingClick(Sender: TObject);
    procedure rbLogonUsingClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btmUseDefaultClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmailSettings: TfrmEmailSettings;

implementation

uses uSystemConfig, uInterfaces, uConsts;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: ckbOutgoingAuthClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.ckbOutgoingAuthClick(Sender: TObject);
begin
  if ckbOutgoingAuth.Checked then
  begin
    rbLogonUsing.Enabled := True;
    rbSameasIncoming.Enabled := True;
  end
  else
  begin
    edtOutgoingUserName.Clear;
    edtOutgoingPassword.Clear;

    edtOutgoingUserName.Enabled := False;
    edtOutgoingPassword.Enabled := False;

    rbLogonUsing.Enabled := False;
    rbSameasIncoming.Enabled := False;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: rbSameasIncomingClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.rbSameasIncomingClick(Sender: TObject);
begin
  if rbSameasIncoming.Checked then
  begin
    edtOutgoingUserName.Clear;
    edtOutgoingPassword.Clear;
    edtOutgoingUserName.Enabled := False;
    edtOutgoingPassword.Enabled := FAlse;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: rbLogonUsingClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.rbLogonUsingClick(Sender: TObject);
begin
  if rbLogonUsing.Checked then
  begin
    edtOutgoingUserName.Clear;
    edtOutgoingUserName.Enabled := True;
    edtOutgoingPassword.Clear;
    edtOutgoingPassword.Enabled := True;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCAncel;
end;

{-----------------------------------------------------------------------------
  Procedure: ntmUseDefaultClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.btmUseDefaultClick(Sender: TObject);
begin
  edtPOP3Port.IntValue := cPOP3DEFAULTPORT;
  edtSMTPPort.IntValue := cSMTPDEFAULTPORT;
  ckbPOPEncrypted.Checked := False;
  ckbSMTPEncrypted.Checked := False;
end;

{-----------------------------------------------------------------------------
  Procedure: btnOKClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmEmailSettings.FormCreate(Sender: TObject);
begin
  Inherited;
  
  btmUseDefaultClick(Sender);
  opPOPConf.ActivePage := ofpOutgoingServer;
end;

end.
