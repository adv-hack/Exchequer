unit eBusCnst;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

const
  ALLOWED_DNET_CAT_CODES = ['A'..'Z', '1'..'9'];
  MAX_NO_COMPANIES = 400;

  MAX_VAT_INDEX = 20;
  VAT_CODES : array[0..MAX_VAT_INDEX] of char =
  ('S','E','Z','1','2','A','D','5','6','7','8','9','T'
  ,'X','B','C','F','G','R','W','Y');

  MAX_CURRENCY_INDEX = 89;

  StockF = 5;

type
  // Definitions for working with the multi-company manager EntComp.dll
  TCompanyType = Record
    CompCode : string[6];
    CompName : string[45];
    CompPath : string[100];
    CompSpare : array [1..100] of char;
  end;
  TCompanies = Array[1..MAX_NO_COMPANIES] of TCompanyType;
  PCompanies = ^TCompanies;

  TFormActivate = (actShow, actEdit, actAdd, actInsert);
  TThirdParty = (tptNone, tptDragNet, tptActinic, tptFreeCom);

  TExportType = (etError, etStockHeader, etAccount, etStockGroup, etTXHeader,
                 etStockLocation, etTXLines, etCOMPricing);

  TRecExportMode = (expNone, expUpdate, expAll); {this was in eBusUtil}

{function EX_GETCOMPANY(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : SMALLINT; stdCall; external 'EntComp.dll';}

implementation

end.
