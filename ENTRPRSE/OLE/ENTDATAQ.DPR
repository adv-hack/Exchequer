Library EntDataQ;

uses
  ComServ,
  Forms,
  Enterprise_TLB in 'Enterprise_TLB.pas',
  oDataQ in 'oDataQ.pas' {DataQuery: CoClass},
  ImportF3 in 'IMPORTF3.PAS' {frmMiscOptions},
  ImportF2 in 'IMPORTF2.PAS' {frmFilterCritera},
  ImportF1 in 'IMPORTF1.PAS' {frmSelectCompany},
  DQHist in 'DQHist.pas',
  StrUtil in '..\FUNCS\STRUTIL.PAS',
  DQAboutF in 'DQABOUTF.PAS' {frmAbout},
  UA_Const in '\Entrprse\R&D\UA_Const.pas',
  VAOUtil in 'x:\ENTRPRSE\FUNCS\VAOUtil.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

end.
