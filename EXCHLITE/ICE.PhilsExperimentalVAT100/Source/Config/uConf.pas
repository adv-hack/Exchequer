{-----------------------------------------------------------------------------
 Unit Name: uConf
 Author:    vmoura
 Purpose:
 History:

 quick application to setup dsr.dll

ClientSync.hlp -> dashboard.chm

-----------------------------------------------------------------------------}
Unit uConf;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  AdvGlowButton, uDSRConfigFrame, AdvEdit, ExtCtrls,

  Mask, AdvOfficePager, AdvOfficePagerStylers, AdvPanel,

  // ice
  uSystemConfig, uADODSR, AdvOfficeButtons, AdvGroupBox
  ;

Const
  cINFOCAPTION = '%s %s Configuration';
  cTABCAPTION = '&%s Settings';

Type
  TfrmConf = Class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnClose: TAdvGlowButton;
    opConfig: TAdvOfficePager;
    AdvOfficePagerOfficeStyler: TAdvOfficePagerOfficeStyler;
    ofpGeneral: TAdvOfficePage;
    ofpEmailSettings: TAdvOfficePage;
    frmDSRConfigFrame: TfrmDSRConfigFrame;
    Label2: TLabel;
    Label3: TLabel;
    edtCompanyName: TAdvEdit;
    edtCompanyMail__: TAdvEdit;
    gbServers: TAdvGroupBox;
    Label15: TLabel;
    AdvMaskEdit1: TAdvMaskEdit;
    AdvMaskEdit2: TAdvMaskEdit;
    edtDatabaseServer: TAdvEdit;
    btnBrowseDbServer: TAdvGlowButton;
    gbAditional: TAdvGroupBox;
    edtOutgoingGuid: TAdvMaskEdit;
    edtIncomingGuid: TAdvMaskEdit;
    cbDripFeed: TAdvOfficeCheckBox;
    pnlDetail: TPanel;
    lblInfo: TLabel;
    edtInstance: TAdvEdit;
    Label1: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnSaveClick(Sender: TObject);
    Procedure btnCloseClick(Sender: TObject);
    Procedure btnBrowseDbServerClick(Sender: TObject);
    Procedure opConfigChange(Sender: TObject);
    Procedure edtDatabaseServerChange(Sender: TObject);
  Private
    fDb: TADODSR;
    fSystemConf: TSystemConf;
    Procedure LoadSettings;
    Function SaveSettings: Boolean;
    Function Init: Boolean;
  Public
  End;

Var
  frmConf: TfrmConf;

Implementation

Uses uCommon, uExFunc, uConsts, {uDashSettings,} udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.FormCreate(Sender: TObject);
Var
  lServer, lInstance: String;
  lOk: Boolean;
Begin
  opConfig.ActivePage := ofpEmailSettings;
  opConfig.ActivePage := ofpGeneral;

  Self.HelpFile := cHELPFILE;

  Self.HelpContext := 4;
  lOk := False;

{$IFDEF ISCIS}
  ofpEmailSettings.TabVisible := FAlse;
  gbAditional.Visible := False;
  lblInfo.Caption := Format(cINFOCAPTION, [_GetProductName(1), '']);
  ofpGeneral.Caption := Format(cTABCAPTION, [_GetProductName(1)]);
{$ENDIF}

  {check if a server name is already in place}
  fSystemConf := TSystemConf.Create;
  lServer := fSystemConf.DBServer;

  If (lServer <> '')  Then
    lOk := Init;

  {check if database connection is fine...}

(*
  If Not lOK Then
  Begin
    ShowDashboardDialog('The Database Server is not registered yet. Please, select a valid Server.', mtinformation, [mbok]);

    _BrowseComputer('Select a Database Server', lServer, false);

    If Trim(lServer) <> '' Then
    Begin
      lInstance := InputBox('Instance Name',
        'Please enter the database instance name:', '');
      If lInstance <> '' Then
      Begin
        fSystemConf.DBServer := lServer + '\' + lInstance;
        edtDatabaseServer.Text := lServer;
        edtInstance.Text := lInstance;
        Init;
      End
      Else
      Begin
        // CJS - 12/11/2007 - Under SQL Express 2005 there must be an instance name.
{
        fSystemConf.DBServer := lServer;
        edtDatabaseServer.Text := lServer;
        edtInstance.Text := '';
        Init;
}
        ShowDashboardDialog('You must restart the config application and specify a valid server instance.', mtInformation, [mbok]);
        Application.Terminate;
      End;
    End
    Else
    Begin
      ShowDashboardDialog('You must restart the config application and select a valid server.', mtInformation, [mbok]);

      Application.Terminate;
    End;
  End; {if not lOK then}
*)
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  fDb.Free;
  FreeAndNil(fSystemConf);
End;

{-----------------------------------------------------------------------------
  Procedure: LoadSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.LoadSettings;
Var
  lPos: Integer;
Begin
  //edtCompanyName.Text := fSystemConf.CompanyName;

  lPos := Pos('\', fSystemConf.DBServer);

  edtCompanyName.Text := fDb.GetSystemValue(cCOMPANYNAMEPARAM);
  If lPos > 0 Then
  Begin
    edtDatabaseServer.Text := Copy(fSystemConf.DBServer, 1, lPos - 1);
    edtInstance.Text := Copy(fSystemConf.DBServer, lPos + 1,
      Length(fSystemConf.DBServer) - lPos);
  End
  Else
  Begin
    edtDatabaseServer.Text := fSystemConf.DBServer;

// CJS - 12/11/2007 - defaulted instance name (under SQL Express 2005, there
//                    must be an instance name).

//    edtInstance.Text := '';
    edtInstance.Text := 'IRISSOFTWARE';

  end;

  {check vao system}
  If _IsVAO Then
  Begin
    cbDripFeed.Checked := False;
    cbDripFeed.Enabled := False;
  End {if _IsVAO then}
  Else
    //cbDripFeed.Checked := fdb.GetSystemValue(cAUTOMATICDRIPFEEDPARAM) = '1';
    cbDripFeed.Checked := fSystemConf.AutomaticDripFeed;

  If lPos > 0 Then
    frmDSRConfigFrame.DBServer := edtDatabaseServer.Text + '\' + edtInstance.Text

// CJS - 12/11/2007 - There will now always be an instance name.

// CJS - 23/01/2008 - the rules have changed. It is now allowable to not have
//                    an instance name. Reinstated the original code.
  Else
    frmDSRConfigFrame.DBServer := edtDatabaseServer.Text;

  frmDSRConfigFrame.LoadDSRSettings;
End;

{-----------------------------------------------------------------------------
  Procedure: SaveSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmConf.SaveSettings: Boolean;
Begin
  Result := False;

  // check company name
  If Trim(edtCompanyName.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid company name!', mtError, [mbok]);

    If edtCompanyName.CanFocus Then
      edtCompanyName.SetFocus;
    Abort;
  End;

  // check database name
  If Trim(edtDatabaseServer.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid database server name!', mtError, [mbok]);

    If edtDatabaseServer.CanFocus Then
      edtDatabaseServer.SetFocus;
    Abort;
  End;

  If Trim(edtInstance.Text) <> '' Then
    fSystemConf.DBServer := edtDatabaseServer.Text + '\' + edtInstance.Text
  Else
// CJS - 12/11/2007 - under SQL Express 2005, there must be an instance name.
{
  begin
    ShowDashboardDialog('You must specify an instance name.', mtError, [mbOk]);
    if edtInstance.CanFocus then
      edtInstance.SetFocus;
    Abort;
  end;
}

// CJS - 23/01/2008 - the rules have changed. It is now allowable to not have
//                    an instance name. Reinstated the original code.
    fSystemConf.DBServer := edtDatabaseServer.Text;

  // disconect database to be ablle to apply new changes
  If fDb.Connected Then
  Try
    fdb.Connected := False;
  Except
  End;

  Try
    fDb.ConnectionString := Format(cADOCONNECTIONSTR1, [fSystemConf.DBServer,
      cICEDBPWD, cICEDBUSER]);
    fDb.Connected := True;
  Except
  End;

  Try
    If fDb.GetDbFileName = '' Then
    Begin
      if fDb.DBExists(cICEDATABASE) then
        ShowDashboardDialog('Invalid database server or instance name!', mtWarning,
          [mbok]);

      fDb.Connected := False;
//      Abort;
    End;
  Except
    fDb.Connected := False;
//    Abort;
  End;

  fSystemConf.AutomaticDripFeed := cbDripFeed.Checked;

  If fDb.Connected Then
  Begin
    frmDSRConfigFrame.SaveDSRSettings;
    fDb.SetSystemParameter(cCOMPANYNAMEPARAM, edtCompanyName.Text);
    fDb.SetSystemParameter(cPOLLINGTIMEPARAM,
      IntToStr(frmDSRConfigFrame.edtPollingTime.Value));
    fDb.SetSystemParameter(cDEFAULTEMAILPARAM, fDb.GetDefaultEmailAccount);

    //Result := True;
  End; {if fDb.Connected then}

  Result := True;
End;

{-----------------------------------------------------------------------------
  Procedure: Init
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmConf.Init: Boolean;
Begin
  Try
    fDb := TADODSR.Create(fSystemConf.DBServer);
  Except
  End;

  If Assigned(fDb) Then
    Result := fDb.Connected;

  If Result Then
    LoadSettings;
End;

{-----------------------------------------------------------------------------
  Procedure: btnSaveClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.btnSaveClick(Sender: TObject);
Begin
  If SaveSettings Then
    Close;

//  pcConf.SetFocus;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: btnBrowseDbServerClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.btnBrowseDbServerClick(Sender: TObject);
Var
  lServer: String;
Begin
  _BrowseComputer('Select a Database server name...', lServer, false);

  If lServer <> '' Then
    edtDatabaseServer.Text := lServer;
End;

{-----------------------------------------------------------------------------
  Procedure: opConfigChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.opConfigChange(Sender: TObject);
Begin
  If opConfig.ActivePage = ofpGeneral Then
    Self.HelpContext := 4
End;

{-----------------------------------------------------------------------------
  Procedure: edtDatabaseServerChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConf.edtDatabaseServerChange(Sender: TObject);
Begin
  frmDSRConfigFrame.DBServer := edtDatabaseServer.Text;
End;

End.

