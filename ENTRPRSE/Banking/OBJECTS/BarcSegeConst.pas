unit BarcSegeConst;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

const
  MaxCreditLines = 2500;
  MaxFiles   = 99999;
  DefaultExt = '.txt';
  SEGE_BACS_CODE = '99';
  CRLF = #13;
  COMMA = ',';
  PAY_REF_CONTRA = 'CONTRA';
  
type

  TBarcSegePayLine = Record
    DestBankSort : String[8];
    DestAccName  : String[18];
    DestBankAcc  : String[8];
    PayAmount    : Double;
    DestBankRef  : String[18];
    BacsCode     : String[2];
  end;

implementation

end.
