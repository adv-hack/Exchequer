{-----------------------------------------------------------------------------
 Unit Name: uDashSettings
 Author:    vmoura
 Purpose:
 History:

   load and set the dashboard settings
-----------------------------------------------------------------------------}
Unit uDashSettings;

Interface

Function _DashboardGetDBServer: String;
Procedure _DashboardSetDBServer(Const pServer: String);
Function _DashboardGetDSRServer: String;
Function _DashboardGetDSRPort: Integer;
//function _DashboardGetShowReminder: Boolean;

//Function _DashboardGetDefaultMail: String;

//Function _DashboardGetCompanyName: String;
//Function _DashboardGetShowAlert: Boolean;
Function _DashboardGetExportAddon: Boolean;
function _DashboardGetImportAddon: Boolean;
function _DashboardGetReadPane: Boolean;
//function _DashboardGetPollingTime: Integer;

Procedure _DashboardSetDSRServer(Const pServer: String);
Procedure _DashboardSetDSRPort(pPort: Longword);

//Procedure _DashboardSetDefaultMail(Const pMail: String);

//Procedure _DashboardSetCompanyName(Const pCompanyName: String);

Procedure _DashboardSetShowAlert(Const pShowAlert: Boolean);
Procedure _DashboardSetExportAddon(Const pActive: Boolean);
Procedure _DashboardSetImportAddon(Const pActive: Boolean);
procedure _DashboardSetReadPane(pPane: Boolean);
//procedure _DashboardSetShowReminder(const pValue: Boolean);
//procedure _DashboardSetPollingTime(pValue: Integer);


Implementation

Uses Sysutils, IniFiles, uConsts, uCommon;

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetDBServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DashboardGetDBServer: String;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadString('database', 'dbserver', '');
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetDSRServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DashboardSetDBServer(Const pServer: String);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteString('database', 'dbserver', pServer);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetDSRServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DashboardGetDSRServer: String;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadString('dsr', 'dsrserver', '');
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetDSRPort
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DashboardSetDSRServer(Const pServer: String);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteString('dsr', 'dsrserver', pServer);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetDSRPort
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DashboardGetDSRPort: Integer;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadInteger('dsr', 'dsrport', 0);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetCompanyMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DashboardSetDSRPort(pPort: Longword);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteInteger('dsr', 'dsrport', pPort);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetDefaultMail
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Function _DashboardGetDefaultMail: String;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := trim(lIni.ReadString('mail', 'default', ''));
  FreeAndNil(lINi);
End;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetDefaultMail
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Procedure _DashboardSetDefaultMail(Const pMail: String);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteString('mail', 'default', trim(pMail));
  FreeAndNil(lINi);
End;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetCompanyName
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Function _DashboardGetCompanyName: String;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := Trim(lIni.ReadString('Company', 'name', ''));
  FreeAndNil(lINi);
End;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetShowAlert
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Procedure _DashboardSetCompanyName(Const pCompanyName: String);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteString('Company', 'name', Trim(pCompanyName));
  FreeAndNil(lINi);
End;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetShowAlert
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Function _DashboardGetShowAlert: Boolean;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadBool('alert', 'show', False);
  FreeAndNil(lINi);
End;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetShowReminder
  Author:    vmoura
-----------------------------------------------------------------------------}
(*function _DashboardGetShowReminder: Boolean;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadBool('reminder', 'show', False);
  FreeAndNil(lINi);
end;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetShowReminder
  Author:    vmoura
-----------------------------------------------------------------------------}
(*procedure _DashboardSetShowReminder(const pValue: Boolean);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteBool('reminder', 'show', pValue);
  FreeAndNil(lINi);
end;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetExportAddon
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _DashboardGetExportAddon: Boolean;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadBool('addon', 'export', False);
  FreeAndNil(lINi);
end;

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetImportAddon
  Author:    vmoura
-----------------------------------------------------------------------------}
function _DashboardGetImportAddon: Boolean;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadBool('addon', 'import', False);
  FreeAndNil(lINi);
end;

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetReadPane
  Author:    vmoura
-----------------------------------------------------------------------------}
function _DashboardGetReadPane: Boolean;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadBool('view', 'pane', False);
  FreeAndNil(lINi);
end;

(*function _DashboardGetPollingTime: Integer;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  Result := lIni.ReadInteger('mail', 'polling', cDSRCHEKMAILINTERVAL);
  FreeAndNil(lINi);
end;*)

{-----------------------------------------------------------------------------
  Procedure: _DashboardGetDBServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DashboardSetShowAlert(Const pShowAlert: Boolean);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.writeBool('alert', 'show', pShowAlert);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetExportAddon
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DashboardSetExportAddon(Const pActive: Boolean);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.writeBool('addon', 'export', pActive);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetImportAddon
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _DashboardSetImportAddon(Const pActive: Boolean);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.writeBool('addon', 'import', pActive);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: _DashboradSetReadPane
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure _DashboardSetReadPane(pPane: Boolean);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteBool('view', 'pane', pPane);
  FreeAndNil(lINi);
end;

{-----------------------------------------------------------------------------
  Procedure: _DashboardSetPollingTime
  Author:    vmoura
-----------------------------------------------------------------------------}
(*procedure _DashboardSetPollingTime(pValue: Integer);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + cDASHBOARDINI);
  lIni.WriteInteger('mail', 'polling', pValue);
  FreeAndNil(lINi);
end;*)


End.
