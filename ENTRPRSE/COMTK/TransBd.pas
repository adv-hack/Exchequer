unit TransBd;

interface
(*
type
  ITransactionBackDoor = Interface(IDispatch)
    ['{D99AB839-8DD0-49CE-9E15-202743978041}']
    function GetLineCount : LongInt; safecall;
    property LineCount : LongInt read GetLineCount;
  end;

  ITransactionBackDoor2 = Interface(ITransactionBackDoor)
    ['{62109DAE-F280-4B7F-ADC0-76B5631B385B}']
    procedure Set_thOutstanding(const Value : WideString);
    procedure Set_thDeliveryRunNo(const Value : WideString);
    procedure Set_thSource(Value : Integer);
    procedure Set_thTotalInvoiced(Value : Double);

    property thOutStanding : WideString write Set_thOutStanding;
    property thDeliveryRunNo : WideString write Set_thDeliveryRunNo;
    property thSource : Integer write Set_thSource;
    property thTotalInvoiced : Double write Set_thTotalInvoiced;
  end;

  ITransactionLineBackDoor = Interface
    ['{FCE3C424-0A48-422E-BEA9-3CFAC387C822}']
    procedure Set_tlAbsLineNo(Value : Integer);
    procedure Set_tlB2BLineNo(Value : Integer);
    procedure Set_tlB2BLinkFolio(Value : Integer);
    procedure Set_tlBinQty(Value : Double);
    procedure Set_tlCOSDailyRate(Value : Double);
    procedure Set_tlNominalMode(Value : Integer);
    procedure Set_tlQtyPack(Value : Double);
    procedure Set_tlReconciliationDate(const Value : WideString);
    procedure Set_tlStockDeductQty(Value : Double);
    procedure Set_tlUseQtyMul(Value : WordBool);


    property tlAbsLineNo : Integer write Set_tlAbsLineNo;
    property tlB2BLineNo : Integer write Set_tlB2BLineNo;
    property tlB2BLinkFolio : Integer write Set_tlB2BLinkFolio;
    property tlBinQty : Double write Set_tlBinQty;
    property tlCOSDailyRate : Double write Set_tlBinQty;
    property tlNominalMode : Integer write Set_tlNominalMode;
    property tlQtyPack : Double write Set_tlQtyPack;
    property tlReconciliationDate : WideString write Set_tlReconciliationDate;
    property tlStockDeductQty : Double write Set_tlStockDeductQty;
    property tlUseQtyMul : WordBool write Set_tlUseQtyMul;

  end;
*)

implementation

end.
 