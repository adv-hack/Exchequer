unit NatW01;

interface

{$H-}

const
  actCurrent = '00';
  actDeposit = '01';

  Sep        = ',';


  IniFileName = 'Natwest.ini';

  NatWestFileHeader =
  'DebitDate,BankRef,DBAcNo,DBAcType,DBSC,BenName,BenAcNo,BenActype,BenSC,BenRef,Amount,RemAdvReq';


  //have to split header as we can't have a string constant of > 255 chars
  NatWestPayManFileHeader1 =
  'TmpltRef,PRN,PayType,PayCat,Reference,DbAcNo,DbAcType,DbAcSC,DbAcCurr,Amount,' +
  'AmountCurr,PayCurr,UrgAdv,DbNarr,DueDate,ValueDate,Yourselves,BenName,BenAcNo,' +
  'BenSC,BenBIC,BenNCC,BenAcType,BenAddr1,BenAddr2,BenAddr3,BenTown,BenCountry,' +
  'DestCtry,BenBkBIC,BenBkSC,PayRoute,PayBankDt1,PayBankDt2,PayBankDt3,PayBankDt4,';

  NatWestPayManFileHeader2 =
  'PayBankDt5,PayDetail1,PayDetail2,PayDetail3,PayDetail4,ByOrderOf1,ByOrderOf2,' +
  'PayBankIn1,PayBankIn2,NWBChrg,PayPurpose,PayMethod,PayRelRef,ChrgAcNo,ChrgAcType,' +
  'ChrgAcSC,ChrgAcCurr,FBankChrg,OtherBkChg,BankToBank,BankDetail,CorresNo,TCCode,' +
  'MailAddr1,MailAddr2,MailAddr3,MailAddr4,MailAddr5,FXDeal1,FXDeal2,FXDeal3,';

  NatWestPayManFileHeader3 =
  'FXDeal4,FXDeal5,FXDeal6,FXDeal7,FXDeal8,FXDeal9,FXDeal10,FXDeal11,FXDeal12,' +
  'FXDeal13,FXDeal14,FXDeal15,FXDeal16,FXDeal17,FXDeal18,FXDeal19,FXDeal20,FXDeal21,' +
  'FXDeal22,FXDeal23,FXDeal24,FXDeal25,FXDeal26,FXDeal27,FXDeal28,FXDeal29,' +
  'FXDeal30,NUKPayType,IntBkBIC,IntBkCC,IntBkName,IntBkAddr1,IntBkAddr2,IntBkAddr3,';

  NatWestPayManFileHeader4 =
  'BenBkCC,BenBkName,BenBkAddr1,BenBkAddr2,BenBkAddr3,BenAcCurr,BenAcSC,' +
  'RegReport1,RegReport2,RegReport3,NUKFXDRef,NUKFXDRate,PayThroBIC';

type

  TNatWestOptionsRec = Record
    BankRef   : Word;
    BenName  : Word;
    Advice  : String[1];
  end;

  TNatWestPayRec = Record
    Date          : String[8];
    CompRef       : {Word;}String[4];
    PMCompRef     : String[35]; //For Payment Manager
    PMRef         : String[35];
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
