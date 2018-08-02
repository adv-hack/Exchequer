program JobCard;

uses
  Forms,
  jcardmain in 'jcardmain.pas' {frmCoPayLink},
  ExportO in 'ExportO.pas',
  LogO in 'LogO.pas',
  jcvar in 'jcvar.pas',
  jcobj in 'jcobj.pas',
  jcfuncs in 'jcfuncs.pas',
  CoDet in 'CoDet.pas' {frmCoDetails},
  Dirs in 'Dirs.pas' {frmSelectDir},
  jcini in 'jcini.pas',
  empgroup in 'empgroup.pas' {frmEmpGroup},
  AccGroup in 'AccGroup.pas' {frmAccGroup},
  expform in 'expform.pas' {frmExport},
  emplst in 'emplst.pas' {frmEmpList},
  emplkup in 'emplkup.pas' {frmEmpLookup},
  selectlg in 'selectlg.pas' {frmSelectLog},
  LogView in 'LogView.pas' {frmLogView},
  groups in 'groups.pas' {frmGroupList};

{$R *.res}
{$R JobCardXP.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCoPayLink, frmCoPayLink);
  Application.Run;
end.
