unit NatW01;

interface

const
  actCurrent = '00';
  actDeposit = '01';

  Sep        = ',';

  
  IniFileName = 'Natwest.dat';

  NatWestFileHeader =
  'DebitDate,BankRef,DBAcNo,DBAcType,DBSC,BenName,BenAcNo,BenActype,BenSC,BenRef,Amount,RemAdvReq';

type

  TNatWestOptionsRec = Record
    BankRef   : Word;
    Advice  : String[1];
  end;

  TNatWestPayRec = Record
    Date          : String[8];
    CompRef       : Word;
    CompAcc       : String[8];
    CompACType    : String[2];
    CompSort      : String[6];
    DestName      : String[20];
    DestAcc       : String[8];
    DestACType    : String[2];
    DestSort      : String[6];
    DestRef       : String[18];
    Amount        : longint;
    RemAdvReq     : Char;
  end;

implementation

end.
