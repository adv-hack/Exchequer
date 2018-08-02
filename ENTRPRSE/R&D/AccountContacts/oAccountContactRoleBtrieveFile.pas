Unit oAccountContactRoleBtrieveFile;

Interface

{$Align 1}

Uses GlobVar,         // Global Types / Variables
     VarConst,        // Global Types / Variables
     BtrvU2,          // Btrieve Interface
     oBtrieveFile;    // Btrieve Data Access Object

Type
  // Idx 0: acrContactId + acrRoleId
  // Idx 1: acrRoleId + acrContactId
  TAccountContactRoleIndex = (acrIdxContactRole=0, acrIdxRoleContact=1);

  //------------------------------

  // Record Structure for Btrieve File
  AccountContactRoleRecType = Record
    acrContactId   : Integer;      // Relational link to AccountContact.acoContactId
    acrRoleId      : Integer;      // Relational link to ContactRole.crRoleId

    Spare         : Array [1..100] of Byte;  // For future use - 108 bytes total rec size
  End; // AccountContactRoleRecType

  //------------------------------

  // Btrieve File Definition
  AccountContactRoleBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..4] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // AccountContactRoleBtrieveFileDefinitionType

  //------------------------------

  // Class for accessng the Pervasive.SQL Cust\AccountContact.Dat data file
  TAccountContactRoleBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FAccountContactRoleRec : AccountContactRoleRecType;
    // Interface file structure definition
    FAccountContactRoleFileDef : AccountContactRoleBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the Cust\AccountContactRole.Dat table
    Procedure DefineAccountContactRoleFileStructure;
  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TAccountContactRoleIndex;
    Procedure SetIndex(Value : TAccountContactRoleIndex);
  Public
    Property Index : TAccountContactRoleIndex Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property AccountContactRole : AccountContactRoleRecType Read FAccountContactRoleRec Write FAccountContactRoleRec;

    Constructor Create;

    Procedure InitialiseRecord;
  End; // TAccountContactRoleBtrieveFile

Implementation

Uses Dialogs, SysUtils;

//=========================================================================

Constructor TAccountContactRoleBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FAccountContactRoleRec);
  FDataRec := @FAccountContactRoleRec;

  // link in File Definition
  FDataFileLen := SizeOf(FAccountContactRoleFileDef);
  FDataFile := @FAccountContactRoleFileDef;
  DefineAccountContactRoleFileStructure;
End; // Create

//-------------------------------------------------------------------------

// Defines the Btrieve File Structure for the Cust\AccountContactRole.Dat table
Procedure TAccountContactRoleBtrieveFile.DefineAccountContactRoleFileStructure;
Begin // DefineAccountContactFileStructure
  // Define the Btrieve file structure
  FillChar(FAccountContactRoleFileDef, SizeOf(FAccountContactRoleFileDef), #0);
  With FAccountContactRoleFileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Idx 0: acrContactId + acrRoleId
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRoleRec.acrContactId, @FAccountContactRoleRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRoleRec.acrContactId);
      // Flags for index
      KeyFlags := Segmented + ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRoleRec.acrRoleId, @FAccountContactRoleRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRoleRec.acrRoleId);
      // Flags for index
      KeyFlags := ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[2]

    // Idx 1: acrRoleId + acrContactId
    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRoleRec.acrRoleId, @FAccountContactRoleRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRoleRec.acrRoleId);
      // Flags for index
      KeyFlags := Segmented + ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[3]
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAccountContactRoleRec.acrContactId, @FAccountContactRoleRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAccountContactRoleRec.acrContactId);
      // Flags for index
      KeyFlags := ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[4]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FAccountContactRoleFileDef
End; // DefineAccountContactFileStructure

//-------------------------------------------------------------------------

Function TAccountContactRoleBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TAccountContactRoleBtrieveFile.GetIndex : TAccountContactRoleIndex;
Begin // GetIndex
  Result := TAccountContactRoleIndex(FIndex);
End; // GetIndex
Procedure TAccountContactRoleBtrieveFile.SetIndex(Value : TAccountContactRoleIndex);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

//-------------------------------------------------------------------------

Procedure TAccountContactRoleBtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  FillChar (FAccountContactRoleRec, SizeOf(FAccountContactRoleRec), #0);
End; // InitialiseRecord

//=========================================================================

Initialization
  // Check for record structure size
  If (SizeOf(AccountContactRoleRecType) <> 108) Then
    ShowMessage('AccountContactRoleRecType - Expected Size=108, Actual Size= ' + IntToStr(SizeOf(AccountContactRoleRecType)));
End.