library EntFuncs;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}

uses
  SysUtils,
  Classes,
  Funcs1U in 'Funcs1U.pas',
  Cripple in 'Cripple.pas';

Exports
  { Cripple.Pas }
  DoubleToInt2,
  DoubleToInt4,

  { Funcs1U.Pas }
  EntVersion,
  EntConvertInts,
  EntDocSign,
  EntCustValue,
  EntGLValue,
  EntStockValue,
  EntJCSummCat,
  EntJobBudgetValue,
  EntStockQty,
  EntDefaultLogin,
  EntSaveGLValue,
  EntSaveJCValue,

  EntStockStr,
  EntStockInt,
  EntStockVal,

  EntTeleValue,
  EntSuppTeleValue, // PL 08/09/2016 R3 ABSEXCH-16676 added EntSuppTeleValue for supplier

  EntAccountStr,
  EntAccountInt,
  EntAccountVal,

  EntCCDepName,
  EntJobStr,
  EntLocationName,
  EntCurrencyName,

  EntJobInt,
  EntJobVal,
  EntJCBudgetValue,
  EntJobBudgetValue2,

  EntAnalDesc,

  EntCustStkQty,
  EntCustStkSales,

  EntFuncsShutDown,

  EntCurrencyValue,
  EntDefaultLogin;


end.
