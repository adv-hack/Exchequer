program EntWRepl;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  MainF in 'MainF.pas' {frmUpdateEng},
  DiskUtil in '..\FUNCS\Diskutil.pas',
  ParamO in 'ParamO.pas',
  HISTORY in 'HISTORY.Pas',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas'; 

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Update Engine';
  Application.CreateForm(TfrmUpdateEng, frmUpdateEng);
  Application.Run;
end.
