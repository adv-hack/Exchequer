unit Coutts01;

interface

const
  MaxCreditLines = 99;
  MaxFiles   = 99999;
  DefaultExt = '.dat';

type
  TCouttsHeaderRec = Record
    RefNo    : String[18];
    CompAcc  : String[8];
    CompSort : String[6];
    PayDate  : String[8];
  end;

  TCouttsPayLine = Record
    RefNo    : String[18];
    DestName : String[18];
    DestSort : string[6];
    DestAcc  : string[8];
    Amount   : longint;
    DestRef  : String[16]; {min six chars}
  end;

implementation

end.
