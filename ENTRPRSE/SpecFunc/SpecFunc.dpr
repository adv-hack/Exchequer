program SpecFunc;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  REMain in 'REMAIN.PAS' {MainForm},
  InHU in 'INHU.PAS' {InHForm},
  LocalVar in 'LocalVar.pas',
  GenEnTU in 'GENENTU.PAS' {TestCust},
  ProgU in 'PROGU.PAS' {GenProg},
  ReBuld1U in 'EntDef\ReBuld1U.pas',
  VarConst in 'EntDef\VARCONST.PAS',
  VarFPOSU in 'EntDef\Varfposu.pas',
  ReBuld2U in 'EntDef\Rebuld2u.pas',
  SpeF3U in 'EntDef\SPEF3U.PAS',
  SpeF4U in 'EntDef\SPEF4U.PAS',
  spef5u in 'EntDef\spef5u.pas',
  PF2MC1U in 'EntDef\PF2MC1U.pas',
  Purge1U in 'EntDef\Purge1U.pas',
  Untils in 'UNTILS.PAS',
  ReBuildU in 'REBUILDU.PAS',
  SFManagerU in 'SFManagerU.pas',
  PurgeOU in 'EntDef\PURGEOU.PAS',
  TriEuroF in 'EntDef\TRIEUROF.PAS' {TriEuroFrm},
  SetLocF in 'EntDef\SETLOCF.PAS' {SetLocFrm},
  SetAcF in 'EntDef\SetAcF.pas' {SetAcFrm},
  SetStkF in 'EntDef\SetStkF.PAS' {SetStkFrm},
  SFHeaderU in 'SFHeaderU.pas',
  SFPasswordU in 'SFPasswordU.pas',
  History in 'History.pas',
  SetDecF in 'EntDef\SetDecF.pas' {SetDecFrm},
  SetDateRangeF in 'SetDateRangeF.pas' {SetDateRangeFrm},
  SetFolioF in 'EntDef\SetFolioF.pas' {SetFolioFrm},
  SetTrans in 'EntDef\SetTrans.pas' {ClearTransFrm},
  SQLPurgeDataU in 'EntDef\SQLPurgeDataU.pas',
  SetTransLineDate in 'EntDef\SetTransLineDate.pas' {SetTransLineDateFrm},
  CountryCodeUtils in '..\FUNCS\CountryCodeUtils.pas',
  CountryCodes in '..\FUNCS\CountryCodes.pas',
  SetCountryCodeF in 'EntDef\SetCountryCodeF.pas' {SetCountryCode},
  PurgeLegacyCreditCardDetailsF in 'EntDef\PurgeLegacyCreditCardDetailsF.pas' {PurgeLegacyCreditCardDetailsForm},
  EntLicence in '..\DRILLDN\EntLicence.pas',
  oBtrieveFile in '..\MULTCOMP\oBtrieveFile.pas',
  oOPVATPayBtrieveFile in '..\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  SF147SelectionFrmU in 'EntDef\SF147SelectionFrmU.pas' {SF147SelectionFrm},
  oAccountContactBtrieveFile in '..\R&D\AccountContacts\oAccountContactBtrieveFile.pas';

{$R *.RES}
{$R W:\ENTRPRSE\FORMDES2\WINXPMAN.RES}

begin
  Application.Title := 'Exchequer Data Maintenance Utility';
  Application.HelpFile := 'ENTRBULD.HLP';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
