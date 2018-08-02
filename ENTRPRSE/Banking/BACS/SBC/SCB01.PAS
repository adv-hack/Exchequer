unit scb01;

{ prutherford440 15:13 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{Declarations for Standard Chartered Bank bacs format}

interface



type
  {each file must be of one type only.  we're only providing one or the other for aberdeen
  but it's worth allowing for future customers who might want the other}
  TSCBPayFileType = (scbCashier, scbDirect);

  TSCBExportRec = Record
    CompName       : String[40]; {user's company name. M (= mandatory)}
    TotalPayNo     : Integer;  {Number of payments in batch.  M}
    TotalPayAmount : Real; {Sum of all payments in batch. M}
    DebitAC        : String[34]; {user's bank a/c               M}
    DebitDate      : String[8];  {                              M}
    CreditDate     : String[8];  {Value date of payments??      M}
    BenName1       : String[40]; {Benificiary name              M}
    BenName2       : String[40]; {O = optional}
    BenFaxNo       : String[20]; {                              O}
    BenAdd1        : String[40]; {M if cashier, O if direct      }
    BenAdd2        : String[40]; {                              O}
    BenAdd3        : String[40]; {                              O}
    BenBankCode    : String[9];  {M if direct                    }
    BenBankName    : String[35]; {M if direct                    }
    BenBranch      : String[3];  {M if direct                    }
    Amount         : Real; {                              M}
    ChargeBen      : Char;       {                              M}
    PayDescript1   : String[35]; {                              O}
    PayDescript2   : String[35]; {                              O}
    DetailsCount   : Word;       {max 9999 - 4 chars            M}
  end;

  TSCBDetailRec = Record
    SeqNo          : Word;       {max 9999 - 4 chars            M}
    RefNo          : String[12]; {e.g invoice no                O}
    RefDate        : String[8];  {Date of invoice/payment       M}
    Descript       : String[50]; {                              O}
    Amount         : Real;       {Amount of individual payment  M}
  end;




implementation

end.
