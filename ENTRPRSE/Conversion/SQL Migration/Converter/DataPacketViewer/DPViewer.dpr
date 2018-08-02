program DPViewer;

uses
  Forms,
  VarConst in '..\..\..\..\R&D\Varconst.Pas',
  DataPacketViewerF in 'DataPacketViewerF.pas' {frmDataPacketViewer},
  DPView_Document in 'DPView_Document.pas',
  DpViewFuncs in 'DpViewFuncs.pas',
  DPView_History in 'DPView_History.pas',
  DPView_CustSupp in 'DPView_CustSupp.pas',
  DPView_Details in 'DPView_Details.pas',
  DPView_MLocStk in 'DPView_MLocStk.pas',
  DPView_AccountContactRole in 'DPView_AccountContactRole.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SQL Data Migration Data Packet Viewer v0.03';
  Application.CreateForm(TfrmDataPacketViewer, frmDataPacketViewer);
  Application.Run;
end.
