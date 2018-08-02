library CalcPrce;
{$REALCOMPATIBILITY ON}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  CalcWrap in 'CalcWrap.pas',
  INITDLLU in 'Initdllu.pas',
  Crypto in 'x:\Entrprse\MULTCOMP\Crypto.pas',
  SerialU in 'x:\Entrprse\MULTCOMP\Serialu.pas',
  EntLic in 'x:\Entrprse\MULTCOMP\Entlic.pas';

exports
  CurrencyInfo,
  CalculatePrice,
  ProcessPriceUpdate,
  CalculatePriceByLocation,
  ProcessPriceUpdateWithLocation,
  SetLocation,
  SetUseMultiBuys,
  ExGetValueBasedDiscount;

begin
end.
