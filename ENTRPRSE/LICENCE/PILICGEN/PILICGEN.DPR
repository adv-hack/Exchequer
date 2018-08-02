program PILICGEN;

{$REALCOMPATIBILITY ON}

{$ALIGN 1}

uses
  Forms,
  DlrListF in 'DLRLISTF.PAS' {frmDealerList},
  DlrDetF in 'DlrDetF.pas' {frmDealerDetail},
  DlrDB in 'DlrDB.pas',
  PlugInDB in 'PlugInDB.pas',
  PlugDetF in 'PlugDetF.pas' {frmPlugInDetail},
  oPlugLic in 'oPlugLic.pas',
  SecSup2U in 'X:\ENTRPRSE\R&D\SECSUP2U.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Licence Generator for Plug-In CD Release Code Utility';
  Application.CreateForm(TfrmDealerList, frmDealerList);
  Application.Run;
end.
