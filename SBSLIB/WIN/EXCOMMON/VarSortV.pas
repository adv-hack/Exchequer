unit VarSortV;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses BtrvU2, GlobVar;

const
  SortViewF   = 22;
  SVNoOfKeys  = 2;
  SVViewK     = 0;
  SVListTypeK = 1;
  SVNoOfSegs  = 4;

  SVUDefaultF = 23;
  SVUNoOfKeys = 1;
  SVUserK     = 0;
  SVUNoOfSegs = 2;

  SortTempF   = 24;
  STNoOfKeys  = 4;
  STFolioK    = 0;
  STFieldK    = 1;
  STLinkStrK  = 2;
  STLinkFolioK= 3;
  STNoOfSegs  = 11;

type
  // Enumeration for defining location that Sort View applies to
  TSortViewListType = (svltCustomer, svltSupplier, svltCustLedger, svltSuppLedger,
                       svltStockList, svltStockReOrder, svltStockTake,
                       svltStockLedger, svltJobLedger, svltSalesDaybookMain,
                       svltSalesDaybookQuotes, svltSalesDaybookOrders,
                       svltPurchaseDaybookMain, svltPurchaseDaybookQuotes,
                       svltPurchaseDaybookOrders, svltConsumer,
                       svltConsumerLedger);


  // Enumeration for controlling how filters are compared against values
  TSortViewFilterComparisonType = (svfcNotDefined = -1, svfcEqual, svfcNotEqual,
                                   svfcLessThan, svfcLessThanOrEqual,
                                   svfcGreaterThan, svfcGreaterThanOrEqual,
                                   svfcStartsWith, svfcContains);

  // Enumeration for possible validation errors.
  TSortViewValidationErrorType = (svveOk, svveNoPrimarySort, svveNoDescription, svveDuplicate, svveInvalidNumber, svveNoCompareType);

  TSortViewFilterDataType = (fdtString, fdtFloat);

  // Function type matching PassFilter in TMULCtrl -- this is used by the
  // OnFilter event-handler.
  TSortViewOnFilter = function (Key: Str255): Boolean of object;

  // Function type matching SetFilter in TMULCtrl.
  TSortViewOnSetFilter = function: Str255 of object;

  // Sub record used for storing the sort details  (56 Bytes)
  TSortViewSortInfoRecType = record
    svsEnabled    : Boolean;
    svsFieldId    : LongInt;    // Unique Id No within each list for sorted field
    svsAscending  : Boolean;
    svsSpare      : Array [1..50] Of Byte;  // For future use
  end; // TSortViewSortInfoRecType
  PSortViewSortInfoRecType = ^TSortViewSortInfoRecType;

  // Sub record used for storing the filter details  (207 Bytes)
  TSortViewFilterInfoRecType = record
    svfEnabled     : Boolean;
    svfFieldId     : LongInt;   // Unique Id No within each list for filtered field
    svfComparison  : TSortViewFilterComparisonType;
    svfValue       : String[100];
    svfSpare       : Array [1..100] Of Byte;  // For future use
  end; // TSortViewFilterInfoRecType
  PSortViewFilterInfoRecType = ^TSortViewFilterInfoRecType;

  // Main Sort View record  (2917 bytes)
  SortViewRecType = record
    svrViewId     : LongInt;           // Unique Id automatically allocated on creation
    svrUserId     : String[30];        // Blank for Global, else Exchequer User Id
    svrListType   : TSortViewListType; // Exchequer list this Sort View applies to
    svrDescr      : String[100];       // On-screen description of view
    svrSorts      : Array [1..4] Of TSortViewSortInfoRecType;  // 2 spare for future use
    svrFilters    : Array [1..8] Of TSortViewFilterInfoRecType;  // 4 spare for future use
    svrSpare       : Array [1..900] Of Byte;  // For future use
  end; // SortViewRecType

  // Default SortViews per User (936 bytes)
  TSortViewUserInfoRecType = Record
    svuUserId      : String[30];              // Exchequer User Id
    svuListType    : TSortViewListType;       // List type (Customer, Supplier, etc)
    svuDefaultView : LongInt;                 // svrViewId of user’s default view for this type
    svuSpare       : Array [1..900] Of Byte;  // For future user specific options
  End; // TSortViewUserInfoRecType

  // Temporary File record (319 bytes)
  SortViewTempRecType = record
    svtListId          : LongInt;      // Instance of list
    svtFolio           : LongInt;      // Unique, sequential folio number
    svtField1          : String[100];  // Primary sorted field
    svtField2          : String[100];  // Secondary sorted field (optional)

    // Index fields to actual data – usage will depend on which list is being used
    svtSourceDataStr   : String[100];
    svtSourceDataFolio : LongInt;
    svtSourceLineNo    : LongInt;
  end; // SortViewTempRecType

  SortView_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of AnsiChar;
    KeyBuff   :  array[1..SVNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  End;

  SVUserDef_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of AnsiChar;
    KeyBuff   :  array[1..SVUNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  SortTemp_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of AnsiChar;
    KeyBuff   :  array[1..STNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  End;

var
  SortViewRec: SortViewRecType;
  SortViewDefRec: SortView_FileDef;

  SortViewDefaultRec: TSortViewUserInfoRecType;
  SortViewDefaultDefRec: SVUserDef_FileDef;

  SortTempRec: SortViewTempRecType;
  SortTempDefRec: SortTemp_FileDef;

const
  //HV 08/04/2016 2016-R2 ABSEXCH-15408: Added code related to ComboBox for Compare value	
  CompareValueComboForFilterField : array[0..2] of string =
  ('Transaction Currency',
   'Stock Type',            //HV 12/04/2016 2016-R2 ABSEXCH-9505: Stock List Sort Views - add the ability to sort by stock type with dropdown
   'Status'                 //Cust Account Status //HV 19/04/2016 2016-R2 ABSEXCH-9497: Drop down list be added when Status is selected to avoid mis-typing the three valid options
  );

  SortViewValidationErrorMsg: array[svveOk..svveNoCompareType] of string =
  (
    '',
    'No Primary Sort was selected',
    'No description was included',
    'A Sort View already exists against this description',
    'Numeric comparison values must not contain any non-numeric characters',
    'No comparison type was selected'
  );

procedure DefineSortView;
procedure DefineSortViewDefault;
procedure DefineSortTemp;

implementation

// -----------------------------------------------------------------------------

procedure DefineSortView;
const
  Idx = SortViewF;
begin
  with SortViewDefRec do
  begin
    FileSpecLen[Idx] := Sizeof(SortViewDefRec);
    Fillchar(SortViewDefRec, FileSpecLen[Idx],0);
    RecLen := Sizeof(SortViewRec);

    PageSize := DefPageSize7;

    NumIndex := SVNoOfKeys;

    Variable := B_Variable + B_Compress + B_BTrunc;

    { 00 - svrViewID  (SVViewK) }
    KeyBuff[1].KeyPos := BtKeyPos(@SortViewRec.svrViewID, @SortViewRec);
    KeyBuff[1].KeyLen := SizeOf(SortViewRec.svrViewID);
    KeyBuff[1].KeyFlags := Modfy + ExtType;
    KeyBuff[1].ExtTypeVal:=BInteger;

    { 01 - svrListType + svrUserId + svrDescr (SVListTypeK) }
    KeyBuff[2].KeyPos := BtKeyPos(@SortViewRec.svrListType, @SortViewRec);
    KeyBuff[2].KeyLen := SizeOf(SortViewRec.svrListType);
    KeyBuff[2].KeyFlags := ModSeg;

    KeyBuff[3].KeyPos := BtKeyPos(@SortViewRec.svrUserId[1], @SortViewRec);
    KeyBuff[3].KeyLen := SizeOf(SortViewRec.svrUserId) - 1;
    KeyBuff[3].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[4].KeyPos := BtKeyPos(@SortViewRec.svrDescr[1], @SortViewRec);
    KeyBuff[4].KeyLen := SizeOf(SortViewRec.svrDescr) - 1;
    KeyBuff[4].KeyFlags := Modfy + AltColSeq;

    AltColt := UpperALT;
  end;

  FillChar(SortViewRec, FileRecLen[Idx], 0);

  FileRecLen[Idx]  := Sizeof(SortViewRec);
  RecPtr[Idx]      := @SortViewRec;
  FileSpecOfs[Idx] := @SortViewDefRec;
  FileNames[Idx]   := 'Misc\SortView.Dat';
end;

// -----------------------------------------------------------------------------

procedure DefineSortViewDefault;
const
  Idx = SVUDefaultF;
begin
  with SortViewDefaultDefRec do
  begin
    FileSpecLen[Idx] := Sizeof(SortViewDefaultDefRec);
    Fillchar(SortViewDefaultDefRec, FileSpecLen[Idx],0);
    RecLen := Sizeof(SortViewDefaultRec);

    PageSize := DefPageSize;

    NumIndex := SVUNoOfKeys;

    Variable := B_Variable + B_Compress + B_BTrunc;

    { 00 - svuUserId + svuListType (SVUserK) }
    KeyBuff[1].KeyPos := BtKeyPos(@SortViewDefaultRec.svuUserId[1], @SortViewDefaultRec);
    KeyBuff[1].KeyLen := SizeOf(SortViewDefaultRec.svuUserId) - 1;
    KeyBuff[1].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[2].KeyPos := BtKeyPos(@SortViewDefaultRec.svuListType, @SortViewDefaultRec);
    KeyBuff[2].KeyLen := SizeOf(SortViewDefaultRec.svuListType);
    KeyBuff[2].KeyFlags := Modfy;

    AltColt := UpperALT;
  end;

  FillChar(SortViewDefaultRec, FileRecLen[Idx], 0);

  FileRecLen[Idx]  := Sizeof(SortViewDefaultRec);
  RecPtr[Idx]      := @SortViewDefaultRec;
  FileSpecOfs[Idx] := @SortViewDefaultDefRec;
  FileNames[Idx]   := 'Misc\SVUsrDef.Dat';
end;

// -----------------------------------------------------------------------------

procedure DefineSortTemp;
const
  Idx = SortTempF;
begin
  with SortTempDefRec do
  begin
    FileSpecLen[Idx] := Sizeof(SortTempDefRec);
    Fillchar(SortTempDefRec, FileSpecLen[Idx],0);
    RecLen := Sizeof(SortTempRec);

    PageSize := DefPageSize4;

    NumIndex := STNoOfKeys;

    Variable := B_Variable + B_Compress + B_BTrunc;

    { 00 - svtListId + svtFolio (STFolioK) }
    KeyBuff[1].KeyPos := BtKeyPos(@SortTempRec.svtListId, @SortTempRec);
    KeyBuff[1].KeyLen := SizeOf(SortTempRec.svtListId);
    KeyBuff[1].KeyFlags := ModSeg + ExtType;
    KeyBuff[1].ExtTypeVal:=BInteger;

    KeyBuff[2].KeyPos := BtKeyPos(@SortTempRec.svtFolio, @SortTempRec);
    KeyBuff[2].KeyLen := SizeOf(SortTempRec.svtFolio);
    KeyBuff[2].KeyFlags := Modfy + ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;

    { 01 - svtListId + svtField1 + svtField2 + svtFolio (STFieldK) }
    KeyBuff[3].KeyPos := BtKeyPos(@SortTempRec.svtListId, @SortTempRec);
    KeyBuff[3].KeyLen := SizeOf(SortTempRec.svtListId);
    KeyBuff[3].KeyFlags := ModSeg + ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    KeyBuff[4].KeyPos := BtKeyPos(@SortTempRec.svtField1[1], @SortTempRec);
    KeyBuff[4].KeyLen := SizeOf(SortTempRec.svtField1) - 1;
    KeyBuff[4].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[5].KeyPos := BtKeyPos(@SortTempRec.svtField2[1], @SortTempRec);
    KeyBuff[5].KeyLen := SizeOf(SortTempRec.svtField2) - 1;
    KeyBuff[5].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[6].KeyPos := BtKeyPos(@SortTempRec.svtFolio, @SortTempRec);
    KeyBuff[6].KeyLen := SizeOf(SortTempRec.svtFolio);
    KeyBuff[6].KeyFlags := Modfy + ExtType;
    KeyBuff[6].ExtTypeVal:=BInteger;

    { 02 - svtListID + svtSourceDataStr (STLinkStrK) }
    KeyBuff[7].KeyPos := BtKeyPos(@SortTempRec.svtListId, @SortTempRec);
    KeyBuff[7].KeyLen := SizeOf(SortTempRec.svtListId);
    KeyBuff[7].KeyFlags := ModSeg + Dup + ExtType;
    KeyBuff[7].ExtTypeVal:=BInteger;

    KeyBuff[8].KeyPos := BtKeyPos(@SortTempRec.svtSourceDataStr[1], @SortTempRec);
    KeyBuff[8].KeyLen := SizeOf(SortTempRec.svtSourceDataStr) - 1;
    KeyBuff[8].KeyFlags := Modfy + Dup + AltColSeq;

    { 03 - svtListID + svtSourceDataFolio + svtSourceLineNo (STLinkFolioK) }
    KeyBuff[9].KeyPos := BtKeyPos(@SortTempRec.svtListId, @SortTempRec);
    KeyBuff[9].KeyLen := SizeOf(SortTempRec.svtListId);
    KeyBuff[9].KeyFlags := ModSeg + Dup + ExtType;
    KeyBuff[9].ExtTypeVal:=BInteger;

    KeyBuff[10].KeyPos := BtKeyPos(@SortTempRec.svtSourceDataFolio, @SortTempRec);
    KeyBuff[10].KeyLen := SizeOf(SortTempRec.svtSourceDataFolio);
    KeyBuff[10].KeyFlags := ModSeg + Dup + ExtType;
    KeyBuff[10].ExtTypeVal:=BInteger;

    KeyBuff[11].KeyPos := BtKeyPos(@SortTempRec.svtSourceLineNo, @SortTempRec);
    KeyBuff[11].KeyLen := SizeOf(SortTempRec.svtSourceLineNo);
    KeyBuff[11].KeyFlags := Modfy + Dup + ExtType;
    KeyBuff[11].ExtTypeVal:=BInteger;

    AltColt := UpperALT;
  end;

  FillChar(SortTempRec, FileRecLen[Idx], 0);

  FileRecLen[Idx]  := Sizeof(SortTempRec);
  RecPtr[Idx]      := @SortTempRec;
  FileSpecOfs[Idx] := @SortTempDefRec;
  FileNames[Idx]   := 'Misc\SortTemp.Dat';
end;

// -----------------------------------------------------------------------------

end.
