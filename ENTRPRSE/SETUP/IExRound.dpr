library IExRound;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  //Classes,
  GlobVar in 'X:\SBSLIB\WIN\WIN32\GlobVar.pas',
  ETMiscU in 'X:\SBSLIB\WIN\WIN32\ETMiscU.pas';

{$R *.res}

//-------------------------------------------------------------------------

Function Exch_Round(InputValue    : Double;
                    DecimalPlaces : SmallInt) : Double; StdCall; Export;
Begin // Exch_Round
  Result := Round_Up(InputValue, DecimalPlaces);
End; // Exch_Round

//-------------------------------------------------------------------------

Exports
  Exch_Round;
end.
