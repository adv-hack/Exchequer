Unit oAccountContactBtrieveFile;

Interface

{$Align 1}

Uses GlobVar,         // Global Types / Variables
     VarConst,        // Global Types / Variables
     BtrvU2,          // Btrieve Interface
     oBtrieveFile;    // Btrieve Data Access Object

Type
  // Idx 0: acoContactId
  // Idx 1: acoAccountCode + acoContactName
  TAccountContactIndex = (acoIdxContactId=0, acoIdxAccountContactName=1);

  //------------------------------

  // Record Structure for Btrieve File
  AccountContactRecType = Record
    acoContactId             : Integer;
    acoAccountCode           : String[10];     // Relational link to CustSupp.CustCode
    acoContactName           : String[45];    // maps onto CustSupp.Company
    acoContactJobTitle       : String[30];
    acoContactPhoneNumber    : String[30];    // maps onto CustSupp.Phone
    acoContactFaxNumber      : String[30];    // maps onto CustSupp.Fax
    acoContactEmailAddress   : String[100];   // maps onto CustSupp.EmailAddr
    acoContactHasOwnAddress  : Boolean;
    acoContactAddress        : AddrTyp;       // maps onto CustSupp.Addr
    acoContactPostCode       : String[20];    // maps onto CustSupp.PostCode
    // MH 19/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
    acoContactCountry        : String[2];            // Normal address Country Code (ISO 3166-1 alpha-2)
    Spare                    : Array [1..465] of Byte;  // For future use - 900 bytes total rec size
  End; // AccountContactRecType

  //------------------------------

  // Btrieve File Definition
  AccountContactBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..3] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // AccountContactBtrieveFileDefinitionType

  //------------------------------

  // Class for accessng the Pervasive.SQL Cust\AccountContact.Dat data file
  TAccountContactBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FAccountContactRec : AccountContactRecType;
    // Interface file structure definition
    FAccountContactFileDef : AccountContactBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the Cust\ContactRole.Dat table
    Procedure DefineAccountContactFileStructure;
  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TAccountContactIndex;
    Procedure SetIndex(Value : TAccountContactIndex);
  Public
    Property Index : TAccountContactIndex Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property AccountContact : AccountContactRecType Read FAccountContactRec Write FAccountContactRec;

    Constructor Create;

    Procedure InitialiseRecord;

    procedure Unlock;
  End; // TAccountContactBtrieveFile

Implementation

Uses Dialogs, SysUtils;

//=========================================================================

Constructor TAccountContactBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FAccountContactRec);
  FDataRec := @FAccountContactRec;

  // link in File Definition
  FDataFileLen := SizeOf(FAccountContactFileDef);
  FDataFile := @FAccountContactFileDef;
  DefineAccountContactFileStructure;
End; // Create

//-------------------------------------------------------------------------

// Defines the Btrieve File Structure for the Cust\AccountContact.Dat table
Procedure TAccountContactBtrieveFile.DefineAccountContactFileStructure;
Begin // DefineAccountContactFileStructure
  // Define the Btrieve file structure
  FillChar(FAccountContactFileDef, SizeOf(FAccountContactFileDef), #0);
  With FAccountContactFileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Idx 0: acoContactId
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRec.acoContactId, @FAccountContactRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRec.acoContactId);
      // Flags for index
      KeyFlags := ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[1]

    // Idx 1: acoAccountCode + acoContactName
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRec.acoAccountCode[1], @FAccountContactRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRec.acoAccountCode) - 1;
      // Flags for index
      KeyFlags := ModSeg + AltColSeq;
    End; // With KeyBuff[2]
    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRec.acoContactName[1], @FAccountContactRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRec.acoContactName) - 1;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[3]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FAccountContactFileDef
End; // DefineAccountContactFileStructure

//-------------------------------------------------------------------------

Function TAccountContactBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TAccountContactBtrieveFile.GetIndex : TAccountContactIndex;
Begin // GetIndex
  Result := TAccountContactIndex(FIndex);
End; // GetIndex
Procedure TAccountContactBtrieveFile.SetIndex(Value : TAccountContactIndex);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

//-------------------------------------------------------------------------

Procedure TAccountContactBtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  FillChar (FAccountContactRec, SizeOf(FAccountContactRec), #0);
End; // InitialiseRecord

//-------------------------------------------------------------------------
procedure TAccountContactBtrieveFile.Unlock;
begin
  Cancel;
end;

//=========================================================================

Initialization
  // Check for record structure size
  If (SizeOf(AccountContactRecType) <> 900) Then
    ShowMessage('AccountContactRecType - Expected Size=900, Actual Size= ' + IntToStr(SizeOf(AccountContactRecType)));
End.
