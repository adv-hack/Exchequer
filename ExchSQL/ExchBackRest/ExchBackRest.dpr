program ExchBackRest;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  Login in 'Login.pas' {frmLogin},
  SQLUtils in 'x:\ENTRPRSE\FUNCS\SQLUtils.pas',
  Btrvu2 in 'x:\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  EntLicence in 'x:\ENTRPRSE\DRILLDN\EntLicence.pas',
  TMainFormClass in 'TMainFormClass.pas' {MainForm},
  Common in 'Common.pas',
  TBrowseForFolderClass in 'TBrowseForFolderClass.pas',
  TLoggerClass in 'TLoggerClass.pas',
  TDBFuncsClass in 'TDBFuncsClass.pas',
  SecSup2U in 'x:\ENTRPRSE\R&D\SECSUP2U.PAS',
  VarRec2U in 'x:\SBSLIB\WIN\EXCOMMON\VARREC2U.PAS',
  TExclusiveAccessClass in 'TExclusiveAccessClass.pas';

{$R *.res}

{$R WINXPMAN.RES}

begin
  Application.Initialize;
  if (ParamCount = 0) or (ParamStr(1) = 'gui') then begin
//    if not ExclusiveAccess.HaveI then
//      ExclusiveAccess.ReportErrors(etShowIt)
//    else begin
      TfrmLogin.Show;
      if LoginOK then begin
        Application.CreateForm(TMainForm, MainForm);
        Application.Run;
      end;
//    end;
  end else begin
//    if not ExclusiveAccess.HaveI then
//      ExclusiveAccess.ReportErrors(etLogIt)
//    else begin
      Application.ShowMainForm := false;
      Application.CreateForm(TMainForm, MainForm);
      MainForm.ProcessCmdLine;
//    end;
  end;
end.
