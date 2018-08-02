{-----------------------------------------------------------------------------
 Unit Name: uDashMiniSetup
 Author:    vmoura
 Purpose: it is like a mini setup when the ini files does exist or
 there is a missing ini entry

-----------------------------------------------------------------------------}
unit uDashMiniSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, AdvSpin, StdCtrls, AdvEdit, AdvGroupBox, ExtCtrls,
  AdvGlowButton, AdvPanel;

type
  TfrmMiniSetup = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    gbServers: TAdvGroupBox;
    lblDbServer: TLabel;
    lbServiceServer: TLabel;
    lblPort: TLabel;
    Label1: TLabel;
    edtDatabaseServer: TAdvEdit;
    edtDSRServer: TAdvEdit;
    seDSRPort: TAdvSpinEdit;
    btnBrowseDbServer: TAdvGlowButton;
    btnBrowseClientSync: TAdvGlowButton;
    edtInstance: TAdvEdit;
    procedure btnBrowseDbServerClick(Sender: TObject);
    procedure btnBrowseClientSyncClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Procedure LoadDashSettings;
    Function SaveDashSettings: Boolean;
  public
    { Public declarations }
  end;

var
  frmMiniSetup: TfrmMiniSetup;

implementation

uses uConsts, udashSettings, uCommon, uDashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: btnBrowseDbServerClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmMiniSetup.btnBrowseDbServerClick(Sender: TObject);
Var
  lServer: String;
Begin
  _BrowseComputer('Select a Database Server name...', lServer, false);

  If lServer <> '' Then
    edtDatabaseServer.Text := lServer;
end;

{-----------------------------------------------------------------------------
  Procedure: btnBrowseClientSyncClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmMiniSetup.btnBrowseClientSyncClick(Sender: TObject);
Var
  lServer: String;
Begin
  _BrowseComputer('Select the ' + _GetProductName(glProductNameIndex) +
    ' Server name...', lServer, false);

  If lServer <> '' Then
    edtDSRServer.Text := lServer;
end;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmMiniSetup.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{-----------------------------------------------------------------------------
  Procedure: LoadDashSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMiniSetup.LoadDashSettings;
var
  lPos: Integer;
Begin
  lPos := Pos('\', _DashboardGetDBServer);

  edtDatabaseServer.Text := Copy(_DashboardGetDBServer, 1, lPos -1);
  if (Trim(edtDatabaseServer.Text) = '') and (_DashboardGetDBServer <> '') and (lPos = 0) then
    edtDatabaseServer.Text := _DashboardGetDBServer;

  if lPos > 0 then
    edtInstance.Text := Copy(_DashboardGetDBServer, lPos+ 1, Length(_DashboardGetDBServer))
  else
    // CJS - 13/11/2007 - defaulted instance name (under SQL Express 2005, there
    //                    must be an instance name).
    edtInstance.Text := 'EXCHEQUER';

  edtDSRServer.Text := _DashboardGetDSRServer;
  seDSRPort.Value := _DashboardGetDSRPort;

  if seDSRPort.Value = 0 then
    seDSRPort.Value := cDEFAULTDSRPORT;
End;

{-----------------------------------------------------------------------------
  Procedure: SaveDashSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMiniSetup.SaveDashSettings: Boolean;
Begin
  Result := FAlse;

  If Trim(edtDatabaseServer.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid database server name!', mtInformation, [mbok]);

    If edtDatabaseServer.CanFocus Then
      edtDatabaseServer.SetFocus;
    Abort;
  End; {If Trim(edtDatabaseServer.Text) = '' Then}

//  If edtInstance.Enabled And (Trim(edtInstance.Text) = '') Then
//  Begin
//    ShowDashboardDialog('Invalid Database Instance name!', mtInformation, [mbok]);

//    If edtInstance.CanFocus Then
//      edtInstance.SetFocus;
//    Abort;
//  End; {If Trim(edtInstance.Text) = '' Then}

  If Trim(edtDSRServer.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid Service Server name!', mtInformation, [mbok]);

    If edtDSRServer.CanFocus Then
      edtDSRServer.SetFocus;
    Abort;
  End; {If Trim(edtDSRServer.Text) = '' Then}

  // CJS - 13/11/2007 - under SQL Express 2005, there must be an instance name.
  if Trim(edtInstance.Text) = '' then
  begin
    ShowDashboardDialog('You must specify an instance name.', mtError, [mbOk]);
    if edtInstance.CanFocus then
      edtInstance.SetFocus;
    Abort;
  end;

  If seDSRPort.Value <= 0 Then
  Begin
    ShowDashboardDialog('Invalid ' + _GetProductName(glProductNameIndex) +
      ' port number!', mtInformation, [mbok]);

    If seDSRPort.CanFocus Then
      seDSRPort.SetFocus;
    Abort;
  End; {If seDSRPort.Value <= 0 Then}

  // db
  if Trim(edtInstance.Text) = '' then
    _DashboardSetDBServer(edtDatabaseServer.Text)
  else
    _DashboardSetDBServer(edtDatabaseServer.Text + '\' + edtInstance.Text);

  // dsr
  _DashboardSetDSRServer(edtDSRServer.Text);

  // dsr port number
  _DashboardSetDSRPort(seDSRPort.Value);

  Result := True;
End;

{-----------------------------------------------------------------------------
  Procedure: btnSaveClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmMiniSetup.btnSaveClick(Sender: TObject);
begin
  if SaveDashSettings then
    ModalResult := mrOK
  else
    ModalResult := mrNone;
end;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmMiniSetup.FormCreate(Sender: TObject);
begin
  HelpFile := cHELPFILE;
  HelpContext := 3;

  LoadDashSettings;
end;

end.
