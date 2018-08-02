unit TranFile;
{$ALIGN 1}
interface
{Temporary btrieve file for storing transaction line details. We need to be able to sort on
 DocType, Account, Amount, Status and Date, so can't simply link into the transaction details
 file}

uses
  BtrvU2, VarConst;

const
  btNumofKeys   = 10;
  btNumSegments = 11;

  RecTempF = 20;

  idxDocType = 0;
  idxAcNo    = 1;
  idxStatus  = 2;
  idxDate    = 3;

  idxPayInRef = 5;


type
  PTempTransDetails = ^TTempTransDetails;
  TTempTransDetails = Record
    btdDocType : String[3];
    btdYear,
    btdPeriod  : Byte;
    btdAcCode  : string[6];
    btdDesc    : string[60]; //PR: 15/09/2010 Changed from 55 to 60 to correspond with IDetail.Desc (ABSEXCH-10244)
    btdAmount  : Double;
    btdStatus  : longInt;
    btdDate    : string[8];
    btdLineKey : string[8];
    btdPayInRef: string[16];
    btdOurRef  : string[10];
    btdFullPayInRef: string[20];     //PR: 03/07/2009 Moved to after OurRef as we need a column for it in SQL
    btdIdDocHed : DocTypes;    //1
    btdPostedRun : longint;    //2
    btdFolioRef   : longint;   //6
    btdNoOfItems : longint;    //10
    btdNumberCleared : longint; //14
    btdNumberMatched : longint; //18
    btdLineNo : longint;       //22
    btdStatLine : longint;     //26
    btdLineAddr : longint;     //30
    //PR: Added ReconDate for v6.01
    btdReconDate : String[8];  //34
    Spare      : Array[1..237] of Char;
  end;


  TempFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..btNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  procedure DefineBankRecTemp;


var
  TempDetailRec : TTempTransDetails;
  TempDetailFile : TempFileDef;

  TmpFile      : FileVar;
  TmpFileName,
  FullTmpFileName  :   String;
  TmpFileSpecOfS,
  TmpRecPtr    :  RecCPtr;
  TmpFileSpecLen,
  TmpFileRecLen : Integer;
  CurrencySymbol : string;

  OpeningBalance : Double;
  OpenUncleared : Double;

  function ProcessValue(Value : Double; UseCurrency : Boolean = True) : string;
  function VarBin(const Buffer : pByte; BufferSize : longint) : string;
  procedure RaiseSQLError(const Where, Error, SQL : string);

implementation

uses
  SysUtils;

procedure RaiseSQLError(const Where, Error, SQL : string);
begin
  raise Exception.CreateFMT('Exception in %s. '#10'Error: %s '#10'SQL: %s', [Where, QuotedStr(Error), QuotedStr(SQL)]);
end;

//Function to return the bytes of a buffer in a hex format suitable for MS-SQL (eg 0x71D4)
function VarBin(const Buffer : pByte; BufferSize : longint) : string;
var
  i : integer;
begin

  if BufferSize <= 1 then
    Result := '0x00'
  else
  begin
    Result := Format('0x%.2x', [BufferSize-1]);
    for i := 1 to BufferSize - 1 do
      Result := Result + Format('%.2x', [pByte(Integer(Buffer) + i)^]);
  end;
end;


function ProcessValue(Value : Double; UseCurrency : Boolean = True) : string;
begin
  Result := Trim(Format('%11.2n', [Value]));
  if Result[1] = '-' then
    Result := Copy(Result, 2, Length(Result)) + '-';
  if UseCurrency then
    Result := CurrencySymbol + Result;
end;




procedure DefineBankRecTemp;
const
  Idx = 1;
begin
  TmpFileSpecLen := SizeOf(TempDetailFile);
  FillChar(TempDetailFile, TmpFileSpecLen,0);

  with TempDetailFile do
  begin
    RecLen := Sizeof(TempDetailRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := btNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - DocType = string[3]
    KeyBuff[1].KeyPos := BtKeyPos(@TempDetailRec.btdDocType[1], @TempDetailRec);
    KeyBuff[1].KeyLen := SizeOf(TempDetailRec.btdDocType) - 1;
    KeyBuff[1].KeyFlags := DupMod;
    //Key 1 - Account = String[6]
    KeyBuff[2].KeyPos := BtKeyPos(@TempDetailRec.btdAcCode[1], @TempDetailRec);
    KeyBuff[2].KeyLen := SizeOf(TempDetailRec.btdAcCode) - 1;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 2 - Status
    KeyBuff[3].KeyPos := BtKeyPos(@TempDetailRec.btdStatus, @TempDetailRec);
    KeyBuff[3].KeyLen := SizeOf(TempDetailRec.btdStatus);
    KeyBuff[3].KeyFlags := DupMod + ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    //Key 3 - Date = String[8]
    KeyBuff[4].KeyPos := BtKeyPos(@TempDetailRec.btdDate[1], @TempDetailRec);;
    KeyBuff[4].KeyLen := SizeOf(TempDetailRec.btdDate) - 1;
    KeyBuff[4].KeyFlags := DupMod;

    //Key 4 - Amount
    KeyBuff[5].KeyPos := BtKeyPos(@TempDetailRec.btdAmount, @TempDetailRec);
    KeyBuff[5].KeyLen := SizeOf(TempDetailRec.btdAmount);
    KeyBuff[5].KeyFlags := DupMod + ExtType;
    KeyBuff[5].ExtTypeVal:=BReal;

    //Key 5 - PayInRef = String[16]
    KeyBuff[6].KeyPos := BtKeyPos(@TempDetailRec.btdPayInRef[1], @TempDetailRec);;
    KeyBuff[6].KeyLen := SizeOf(TempDetailRec.btdPayInRef) - 1;
    KeyBuff[6].KeyFlags := DupMod;

    //Key 6 - LineKey = String[8] (Folio + AbsLineNo)
    KeyBuff[7].KeyPos := BtKeyPos(@TempDetailRec.btdLineKey[1], @TempDetailRec);;
    KeyBuff[7].KeyLen := SizeOf(TempDetailRec.btdLineKey) - 1;
    KeyBuff[7].KeyFlags := DupMod;

    //Key 7 - OurRef = String[10]
    KeyBuff[8].KeyPos := BtKeyPos(@TempDetailRec.btdOurRef[1], @TempDetailRec);;
    KeyBuff[8].KeyLen := SizeOf(TempDetailRec.btdOurRef) - 1;
    KeyBuff[8].KeyFlags := DupMod;

    //Key 8 - LineDesc = String[55]
    KeyBuff[9].KeyPos := BtKeyPos(@TempDetailRec.btdDesc[1], @TempDetailRec);;
    KeyBuff[9].KeyLen := SizeOf(TempDetailRec.btdDesc) - 1;
    KeyBuff[9].KeyFlags := DupMod;

    //Key 9 - Doc Type + PayInRef = String[3] + String[16]
    KeyBuff[10].KeyPos := BtKeyPos(@TempDetailRec.btdDocType[1], @TempDetailRec);;
    KeyBuff[10].KeyLen := SizeOf(TempDetailRec.btdDocType) - 1;
    KeyBuff[10].KeyFlags := DupModSeg;

    KeyBuff[11].KeyPos := BtKeyPos(@TempDetailRec.btdPayInRef[1], @TempDetailRec);;
    KeyBuff[11].KeyLen := SizeOf(TempDetailRec.btdPayInRef) - 1;
    KeyBuff[11].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;
  FileRecLen[RecTempF] := Sizeof(TempDetailRec);
  FillChar(TempDetailRec,FileRecLen[RecTempF],0);
  TmpRecPtr := @TempDetailRec;
  TmpFileSpecOfS := @TempDetailFile;
  TmpFileName := 'SWAP\$RecTmp.dat';
end;


end.
