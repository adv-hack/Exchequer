program TestBureau;

uses
  ShareMem,
  Forms,
  CompLstF in '..\R&D\CompLstF.pas' {frmCompanyList},
  enBureauIntF in 'enBureauIntF.pas',
  Enterprise01_TLB in 'X:\ENTRPRSE\COMTK\Enterprise01_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCompanyList, frmCompanyList);
  Application.Run;
end.
