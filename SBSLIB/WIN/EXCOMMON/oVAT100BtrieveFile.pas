Unit oVAT100BtrieveFile;

Interface

{$Align 1}

Uses BtrvU2,          // Btrieve Interface
     oBtrieveFile;    // Btrieve Data Access Object

Const
  VAT100FileName = 'Misc\VAT100.Dat';

Type
  // VAT100 Index enumeration
  // Idx 0: vatCorrelationId
  TVAT100Index = (vatIdxCorrelationId=0);

  // -------------------------------------------------------------------------

  // Record Structure for Btrieve File
  VAT100RecType = Record
    vatCorrelationID         : String[40];
    vatIRMark                : String[40];
    vatDateSubmitted         : String[16];
    vatDocumentType          : String[10];
    vatPeriod                : String[10];
    vatUserName              : String[255];
    vatStatus                : SmallInt;
    vatPollingInterval       : Integer;
    vatDueOnOutputs          : Double;
    vatDueOnECAcquisitions   : Double;
    vatTotal                 : Double;
    vatReclaimedOnInputs     : Double;
    vatNet                   : Double;
    vatNetSalesAndOutputs    : Double;
    vatNetPurchasesAndInputs : Double;
    vatNetECSupplies         : Double;
    vatNetECAcquisition      : Double;
    vatHMRCNarrative         : Array[0..2047] of Char;
    vatNotifyEmail           : String[255];
    vatPollingURL            : String[255];

    // Pad to 4000 with spare
    Spare             : Array [1..985] Of Byte;
  End; // VAT100RecType
  PVAT100RecType = ^VAT100RecType;

  // -------------------------------------------------------------------------

  // Btrieve File Definition
  VAT100RecTypeBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..1] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // VAT100RecTypeBtrieveFileDefinitionType

  // -------------------------------------------------------------------------

  // Class for accessing the Pervasive.SQL Misc\VAT100.Dat data file
  TVAT100BtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FVAT100Rec : VAT100RecType;
    // Interface file structure definition
    FVAT100FileDef : VAT100RecTypeBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the table
    Procedure DefineVAT100FileStructure;

  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TVAT100Index;
    Procedure SetIndex(Value : TVAT100Index);
  Public
    Function GetPosition(Var RecAddr : LongInt) : SmallInt;
    Function RestorePosition (Const RecAddr : LongInt; Const LockCode : SmallInt = 0) : SmallInt;

    Property Index : TVAT100Index Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;

    // Always reference the fields of this property using 'with VAT100BtrieveFile.Rec...'
    Property Rec : VAT100RecType Read FVAT100Rec Write FVAT100Rec;

    Constructor Create(ClientID: Byte = 0);

    Procedure InitialiseRecord;

    procedure Unlock;

    Function BuildIDKey (Const ID : ShortString) : ShortString;
  End; // TVAT100BtrieveFile

Implementation

Uses Dialogs, SysUtils;

// ===========================================================================

Constructor TVAT100BtrieveFile.Create(ClientID: Byte);
Begin // Create
  Inherited Create(ClientID);

  // Link in data record
  FDataRecLen := SizeOf(FVAT100Rec);
  FDataRec := @FVAT100Rec;

  // link in File Definition
  FDataFileLen := SizeOf(FVAT100FileDef);
  FDataFile := @FVAT100FileDef;
  DefineVAT100FileStructure;
End; // Create

// ---------------------------------------------------------------------------

// Defines the Btrieve File Structure for the Misc\VAT100.Dat table
Procedure TVAT100BtrieveFile.DefineVAT100FileStructure;
Begin // DefineVAT100FileStructure
  // Define the Btrieve file structure
  FillChar(FVAT100FileDef, SizeOf(FVAT100FileDef), #0);
  With FVAT100FileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;  // 1024 bytes
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 1;

    // Idx 0: vatCorrelationId
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FVAT100Rec.vatCorrelationId, @FVAT100Rec) + 1;
      // length of segment in bytes
      KeyLen   := SizeOf(FVAT100Rec.vatCorrelationId) - 1;
      // Flags for index
      KeyFlags := AltColSeq;
    End; // With KeyBuff[1]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FVAT100FileDef
End; // DefineVAT100FileStructure

// ---------------------------------------------------------------------------

Function TVAT100BtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

// ---------------------------------------------------------------------------

Function TVAT100BtrieveFile.GetIndex : TVAT100Index;
Begin // GetIndex
  Result := TVAT100Index(FIndex);
End; // GetIndex
Procedure TVAT100BtrieveFile.SetIndex(Value : TVAT100Index);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

// ---------------------------------------------------------------------------

Procedure TVAT100BtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  FillChar (FVAT100Rec, SizeOf(FVAT100Rec), #0);
End; // InitialiseRecord

// ---------------------------------------------------------------------------

procedure TVAT100BtrieveFile.Unlock;
begin
  Cancel;
end;

// ---------------------------------------------------------------------------

Function TVAT100BtrieveFile.BuildIDKey (Const ID : ShortString) : ShortString;
Begin // BuildIDKey
  Result := ID + StringOfChar(' ', Length(FVAT100Rec.vatCorrelationId));
  Result := Copy(Result, 1, Length(FVAT100Rec.vatCorrelationId));
End; // BuildIDKey

// ===========================================================================

function TVAT100BtrieveFile.GetPosition(var RecAddr: Integer): SmallInt;
begin
  Result := inherited GetPosition(RecAddr);
end;

function TVAT100BtrieveFile.RestorePosition(const RecAddr: Integer;
  const LockCode: SmallInt): SmallInt;
begin
  Result := inherited RestorePosition(RecAddr, LockCode);
end;

Initialization
  // Check for record structure size
  If (SizeOf(VAT100RecType) <> 4000) Then
    ShowMessage('VAT100RecType - Expected Size=4000, Actual Size= ' + IntToStr(SizeOf(VAT100RecType)));
End.