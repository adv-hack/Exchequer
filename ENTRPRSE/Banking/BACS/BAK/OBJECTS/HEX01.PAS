unit Hex01;

interface

const
  tagContras       = '$FN:';
  tagTotal         = '$FT:';
  tagCurrency      = '$FC:';
  tagStartBalance  = '$DS';
  tagEndBalance    = '$DE';
  tagStartPay      = '$LS';
  tagEndPay        = '$LE';

  tagCoAcc         = 'F01:';
  tagValDate       = 'F02:';
  tagDescript      = 'F03:';
  tagPayCount      = 'F04:';
  tagPayTotal      = 'F05:';

  tagDestAcc       = 'S01:';
  tagDestSort      = 'S02:';
  tagDestName      = 'S03:';
  tagAmount        = 'S04:';
  tagPayDescript   = 'S05:';

  CR               = #13;

  DefaultExt = '.dat';

  MaxPayLines = 200; {maximum transactions per file}
  MaxFiles = 99999; {Allow 5 digits for count}


{Even though amounts are output in pounds we'll store them in pence and convert before
writing to avoid possiblity of rounding errors}
type
  THexFileHeaderRec = Record
    Count       : Integer;     {number of payments in file}
    TotalValue  : longint;     {value of all payments}
    Currency    : String[3];   {either 'GBP' or 'EUR'}
  end;

  THexBalanceHeader = Record
     CoAcc      : String[8];   {user's bank a/c}
     ValDate    : String[6];   {date}
     Descript   : String[10];
     PCount   : Word;        {max 200}
     PTotal   : longint;
  end;

  THexPaymentRec  = Record
     DestAcc    : String[8];
     DestSort   : String[6];
     DestName   : String[18];
     Amount     : longint;
     PayDescrip : String[18];
  end;



implementation

end.
