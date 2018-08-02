unit Coutts01;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

const
  MaxCreditLines = 99;
  MaxFiles   = 99999;
  DefaultExt = '.dat';
  CouttsIniFileName = 'EntCoutt.ini';

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
