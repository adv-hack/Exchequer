Unit oContactRoleBtrieveFile;

Interface

{$Align 1}

Uses GlobVar,         // Global Types / Variables
     VarConst,        // Global Types / Variables
     BtrvU2,          // Btrieve Interface
     oBtrieveFile;    // Btrieve Data Access Object

Type
  // Idx 0: crRoleId
  // Idx 1: crRoleDescription
  TContactRoleIndex = (crIdxRoleId=0, crIdxRoleDescription=1);

  //------------------------------

  // Record Structure for Btrieve File
  ContactRoleRecType = Record
    crRoleId                : Integer;
    crRoleDescription       : String[50];
    crRoleAppliesToCustomer : Boolean;
    crRoleAppliesToSupplier : Boolean;

    Spare                   : Array [1..143] of Byte;  // For future use - 200 bytes total rec size
  End; // ContactRoleRecType

  //------------------------------

  // Btrieve File Definition
  ContactRoleBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..2] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // ContactRoleBtrieveFileDefinitionType

  //------------------------------

  // Class for accessng the Pervasive.SQL Cust\ContactRole.Dat data file
  TContactRoleBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FContactRoleRec     : ContactRoleRecType;
    // Interface file structure definition
    FContactRoleFileDef : ContactRoleBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the Cust\ContactRole.Dat table
    Procedure DefineContactRoleFileStructure;
  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TContactRoleIndex;
    Procedure SetIndex(Value : TContactRoleIndex);
  Public
    Property Index : TContactRoleIndex Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property ContactRole : ContactRoleRecType Read FContactRoleRec Write FContactRoleRec;

    Constructor Create;

    Procedure InitialiseRecord;
  End; // TContactRoleBtrieveFile

Implementation

Uses Dialogs, SysUtils;

//=========================================================================

Constructor TContactRoleBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FContactRoleRec);
  FDataRec := @FContactRoleRec;

  // link in File Definition
  FDataFileLen := SizeOf(FContactRoleFileDef);
  FDataFile := @FContactRoleFileDef;
  DefineContactRoleFileStructure;
End; // Create

//-------------------------------------------------------------------------

// Defines the Btrieve File Structure for the Cust\ContactRole.Dat table
Procedure TContactRoleBtrieveFile.DefineContactRoleFileStructure;
Begin // DefineContactRoleFileStructure
  // Define the Btrieve file structure
  FillChar(FContactRoleFileDef, SizeOf(FContactRoleFileDef), #0);
  With FContactRoleFileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Index 0: crRoleId
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FContactRoleRec.crRoleId, @FContactRoleRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FContactRoleRec.crRoleId);
      // Flags for index
      KeyFlags := ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[1]

    // Idx 1: crRoleDescription
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FContactRoleRec.crRoleDescription[1], @FContactRoleRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FContactRoleRec.crRoleDescription) - 1;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[1]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FContactRoleFileDef
End; // DefineContactRoleFileStructure

//-------------------------------------------------------------------------

Function TContactRoleBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TContactRoleBtrieveFile.GetIndex : TContactRoleIndex;
Begin // GetIndex
  Result := TContactRoleIndex(FIndex);
End; // GetIndex
Procedure TContactRoleBtrieveFile.SetIndex(Value : TContactRoleIndex);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

//-------------------------------------------------------------------------

Procedure TContactRoleBtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  FillChar (FContactRoleRec, SizeOf(FContactRoleRec), #0);
End; // InitialiseRecord

//=========================================================================

Initialization
  // Check for record structure size
  If (SizeOf(ContactRoleRecType) <> 200) Then
    ShowMessage('ContactRoleRecType - Expected Size=200, Actual Size= ' + IntToStr(SizeOf(ContactRoleRecType)));
End.