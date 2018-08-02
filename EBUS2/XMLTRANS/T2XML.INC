{Record declarations for Transaction to Xml COM Object}
type

  TAddArray = Array[1..5] of String[30];

  t2xAuxHeadRec = Record
    CustSuppName    : String[45]; //name of customer of supplier
    OurName         : string[45];
    CustSuppAdd     : TAddArray;
    OurAdd          : TAddArray;
    OurVatReg       : String[30];
    SaveDir         : String[255];
    SaveFileName    : String[8];
    XslLocation     : String[255];
    CurrCode        : String[3];
    CurrName        : String[25];
    UseCCDept       : WordBool;
    ContactName     : string[25];
    ContactPhone    : string[30];
    ContactPhone2   : string[30];
    ContactFax      : string[30];
    PriceDP,
    CostDP,
    QuantityDP      : integer;
    TheirCodeForUs  : String[10];
    TransferMode    : TTransferMode;
    Spare           : Array[1..487] of Char;
  end;

  p2xAuxLineRec = ^t2xAuxLineRec;
  t2xAuxLineRec = Record
    axLineTotal    : Double;
    axVatRate      : Double;
    axUOMQuantDesc : String[10];
    axUOMPriceDesc : String[10];
//    Spare          : Array[1..500] of Char;
  end;

  p2xAuxLines = ^t2xAuxLines;
  t2xAuxLines = Array[1..10000] of p2xAuxLineRec;

  TXmlNarrativeRec = Record
    Text : String[65];
    spare : Array[1..50] of Char;
  end;

  TxmlNarrativeArray = Array of TXmlNarrativeRec;

  TXmlSerialBatchDetailRec = Record
    FLineNo     : longint; //abslineno of transaction line
    FType       : integer;
    FSerialNo   : string[20];
    FBatchNo    : string[10];
    FQtyUsed    : Double;
    Spare       : Array[1..50] of Char;
  end;

  TXmlSerialArray = Array of TXmlSerialBatchDetailRec;



