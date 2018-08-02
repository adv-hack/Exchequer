//////////////////////////////////////
// Layaway Header Record Definition //
//////////////////////////////////////

const
  LayHeadF = 20;

  lhNofKeys = 3;
  lhNofSegs = 7;

  LayHeadFolioK = 0;
  LayHeadUserK = 1;
  LayHeadDateK = 2;

type
  TLayHeadRec = record
    lhFolioNo : Longint;
    lhUserName : string50;
    lhAccountCode : String10;
    lhAccountName : String45;
    lhCustomerName : string25;
    lhOrderNo : String10;
    lhAddress : AddrTyp;
    lhItemsDesc : String100;
    lhSettDisc : Double;
    lhSettDiscDays : LongInt;
    lhDepositToTake : Double;
    lhDate : String8;
    lhTime : string6;
    lhTillNo : LongInt;         {Number Of the till that the TX was done on}
    lhValue : Double;
    lhCostCentre : string20;
    lhDepartment : string20;
    lhDummyChar : Char;         {for botching the integer indexes}
    lhTKTHRecord : TBatchTHRec;

    lhSpare : array[1..1000] of Byte;
  end;{TLayHeadRec}

  TLayHead_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..lhNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;{TInv_FileDef}


/////////////////////////////////////
// Layaway Lines Record Definition //
/////////////////////////////////////
const
  LayLineF   = 21;   { Unique to this program }

  llNofKeys   = 1;
  llNofSegs   = 3;

  LayLineK = 0;

type
  TLayLineRec = record
    llHeaderNo : LongInt;
    llLineNo : LongInt;         {Order in which line was added}
    llStockCode : String16;
    llDescription : Array[1..6] of String[35];
    llPrice : Double;
    llVATInclusive : Char;
    llVATRate : Char;
    llDiscType : Char;
    llDiscount : double;
    llDiscAmount : Double;
    llDiscDesc : string20;
    llQuantity : Double;
    llSerialItem : Boolean;
    llDummyChar : char;         {for botching the integer indexes}
    llListFolioNo : integer;
    llBOMParentFolioNo : integer;
    llBOMQtyUsed : Double;
    llBOM : boolean;
    llKitLink : integer;
    llTKTLRecord : TBatchTLRec;
    llBOMComponent : boolean; {.281}

    llSpare : array [1..499] of Byte; {.281} // was 500
  end;{TLayLineRec}

  // NOTE: LLines.Dat is currently configured to accept a 1332 byte record and TLayLineRec is
  // 1584 bytes so it is recommended that at least 260 bytes of spare is left as spare to ensure
  // the record will fit.

  TLayLine_FileDef = record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : array [1..4] of Char;
    KeyBuff   : array [1..llNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  end;{TSalesDet_FileDef}


///////////////////////////////////////////////
// Layaway Serial Numbers Record  Definition //
///////////////////////////////////////////////
const
  LaySerialF   = 22;   { Unique to this program }

  lsNofKeys   = 1;
  lsNofSegs   = 3;

  lsFindSerialK = 0;

type
  TLaySerialRec = Record
    lsHeaderNo : LongInt;
    lsLineNo : LongInt;
    lsBatch : boolean;
    lsSerialNo : String20;   {  Actual Serial No. }
    lsBatchNo : String10;   {  Seperate Batch No.}

    // fields removed when adding support for split pack batches, which require floating point values.
    XlsUsedInBatch : LongInt;
    XlsUsedInThisLine : LongInt;
    XlsUsedElsewhere : LongInt;

    lsDummyChar : char;         {for botching the integer indexes}

    // fields added when adding support for split pack batches, which require floating point values.
    lsUsedInBatch : double;
    lsUsedInThisLine : double;
    lsUsedElsewhere : double;

    lsSpare : array [1..376] of Byte;
  end;

  TLaySerial_FileDef = record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : array [1..4] of Char;
    KeyBuff   : array [1..lsNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  end;{TLaySerial_FileDef}

///////////////////////////////////////////////
// Layaway Bin Numbers Record  Definition //
///////////////////////////////////////////////
const
  LayBinF   = 23;   { Unique to this program }

  lbNofKeys   = 1;
  lbNofSegs   = 3;

  lbFindBinK = 0;

type
  TLayBinRec = Record
    lbHeaderNo : LongInt;
    lbLineNo : LongInt;
    lbBinCode : String20;   {  Actual Bin No. }
    lbUsedInBatch : double;
    lbUsedInThisLine : double;
    lbUsedElsewhere : double;
    lbDummyChar : char;         {for botching the integer indexes}

    lbSpare : array [1..400] of Byte;
  end;

  TLayBin_FileDef = record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : array [1..4] of Char;
    KeyBuff   : array [1..lsNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  end;{TLayBin_FileDef}


