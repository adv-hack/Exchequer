program FBITestHarness;

uses
  Forms,
  frmMainImp in 'frmMainImp.pas' {frmMain},
  InternetFiling_TLB in '..\..\..\..\Program Files\Borland\Delphi6\Imports\InternetFiling_TLB.pas',
  FBITestHarness_TLB in 'FBITestHarness_TLB.pas',
  FBICallback in 'FBICallback.pas' {FBI_Callback: CoClass},
  MSXML2_TLB in '..\..\..\..\Program Files\Borland\Delphi6\Imports\MSXML2_TLB.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
