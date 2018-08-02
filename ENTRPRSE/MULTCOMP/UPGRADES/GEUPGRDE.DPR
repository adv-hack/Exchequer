library GEUpgrde;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

  {$REALCOMPATIBILITY ON}
  {$ALIGN 1}
uses
  SysUtils,
  Classes,
  VarConst,
  PWUPG2U in 'PWUPG2U.PAS',
  CommonU in 'CommonU.pas',
  HandlerU in 'HandlerU.pas',
  ProgU in 'ProgU.pas',
  AddIndex in 'AddIndex.pas' {frmIdxProgress},
  oCompany in 'oCompany.pas',
  UserDefinedFieldUpgrade in 'UserDefinedFieldUpgrade.pas',
  QtyBreakConverter in 'QtyBreakConverter.pas',
  QBConvertF in 'QBConvertF.pas' {frmQtyBreakProgress},
  JobAppsCustomFields in 'JobAppsCustomFields.pas',
  CurrencyHist in 'CurrencyHist.pas',
  SepaUpgradeClass in 'SepaUpgradeClass.pas',
  InitFieldsFuncs in 'InitFieldsFuncs.pas',
  oContactRoleBtrieveFile in '..\..\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  oBtrieveFile in '..\oBtrieveFile.pas',
  oExpire in 'oExpire.pas',
  UpdateBankRecKey in 'w:\ENTRPRSE\MULTCOMP\UPGRADES\UpdateBankRecKey.pas',

  //PR: 05/09/2017 Added for password complexity changes v2017 R2
  PasswordComplexityConst in 'w:\Entrprse\R&D\Password Complexity\PasswordComplexityConst.pas',
  SHA3_256 in 'w:\Compon\SHA3_256Hash\SHA3_256.pas',
  Mem_Util in 'w:\Compon\SHA3_256Hash\Mem_Util.pas',
  Hash in 'w:\Compon\SHA3_256Hash\Hash.pas',
  BTypes in 'w:\Compon\SHA3_256Hash\BTypes.pas',
  SHA3 in 'w:\Compon\SHA3_256Hash\SHA3.pas';
  

{$R *.RES}


Exports
  SetCompanyDir,

  NeedToRunUpgrade, {ProgU.pas}
  RunUpgrade,       {HandlerU.pas}
  ControlUpgrade,   {HandlerU.pas}
  AddNewIndex,      {AddIndex.pas}
  ConvertQuantityBreaks, {QBConvertF}
  AddJobAppsCustomFields, {JobAppsCustomFields}
  RunSepaUpgrade,
  ExpirePlugIn,
  UpdateBankReconcile;


begin
end.
