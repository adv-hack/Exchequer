unit EBusLook;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  BtrvU2;

// Turn word alignment off
{$A-}
const
  EBsL = 19;
  LOOKUPS_FILENAME = 'EBusLkUp.DAT';

  LOOKUP_TYPE_VAT = 'V';
  LOOKUP_TYPE_CURRENCY = 'C';
  LOOKUP_TYPE_TRADER = 'T';
  LOOKUP_SUBTYPE_NONE = ' ';

type
  // TLookupCategory used to determine which index to use on the lookups file
  TLookupCategory = (lkuFromOurCode, lkuToOurCode);
  // TLookupFor used to determine who a group of look-ups is for
  TLookupFor = (lkfCustomer, lkfSupplier, lkfGlobal);

  TLookupGeneric = record
    OurTraderCode   : string[10];   // Enterprise customer / supplier code
    OurItemCode     : string[50];   // Code user has assigned within Enterprise
    TheirItemCode   : string[50];   // Code from an external system
    Description     : string[100];  // Meaning of the code (optional)
    Tag             : smallint;     // Tag marker within list
  end;
  PLookupGeneric = ^TLookupGeneric;

  TEBusLookups = record
    RecPfix   : char;        // Record prefix
    SubType   : char;        // Subtype record type
    case byte of
      1: (LookupGeneric : TLookupGeneric);
      2: (LookupTrader  : string[10]);
      3: (LookupSize    : array[1..320] of char); // Allows for spare
  end;

  EBusLookup_FileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..7] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  EBusLookupRec : TEBusLookups;
  EBusLookupFile : EBusLookup_FileDef;

procedure DefineEBusLookup;

implementation

procedure DefineEBusLookup;
const
  Idx = EBsL;
begin
  FileSpecLen[Idx] := SizeOf(EBusLookupFile);
  FillChar(EBusLookupFile,FileSpecLen[Idx], 0);

  with EBusLookupFile do
  begin
    RecLen := Sizeof(EBusLookupRec);
    PageSize := DefPageSize;
    NumIndex := 3;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    // Key 0
    KeyBuff[1].KeyPos := 1;
    KeyBuff[1].KeyLen := 2;
    KeyBuff[1].KeyFlags := DupModSeg;

    KeyBuff[2].KeyPos := 4;
    KeyBuff[2].KeyLen := 10;
    KeyBuff[2].KeyFlags := DupModSeg;

    KeyBuff[3].KeyPos := 15;
    KeyBuff[3].KeyLen := 50;
    KeyBuff[3].KeyFlags := DupMod;

    // Key 1
    KeyBuff[4].KeyPos := 1;
    KeyBuff[4].KeyLen := 2;
    KeyBuff[4].KeyFlags := DupModSeg;

    KeyBuff[5].KeyPos := 4;
    KeyBuff[5].KeyLen := 10;
    KeyBuff[5].KeyFlags := DupModSeg;

    KeyBuff[6].KeyPos := 66;
    KeyBuff[6].KeyLen := 50;
    KeyBuff[6].KeyFlags := DupMod;

    // Key 2
    KeyBuff[7].KeyPos := 4;
    KeyBuff[7].KeyLen := 10;
    KeyBuff[7].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(EBusLookupRec);
  FillChar(EBusLookupRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @EBusLookupRec;
  FileSpecOfS[Idx] := @EBusLookupFile;
  FileNames[Idx] := LOOKUPS_FILENAME;
end;

initialization
  DefineEBusLookup;

end.


