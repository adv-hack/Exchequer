Unit oSystemSetupBtrieveFile;

Interface

{$Align 1}

Uses BtrvU2,          // Btrieve Interface
     oBtrieveFile;    // Btrieve Data Access Object

Const
  SystemSetupFileName = 'Misc\SystemSetup.Dat';

Type
  // Idx 0: sysId
  TSystemSetupIndex = (ssIdxId=0);

  //------------------------------

  // Record Structure for Btrieve File
  SystemSetupRecType = Record
    sysId             : Integer;       // Unique ID to identify the field
    sysName           : String[30];    // The Exchequer Field Name - can be used by MS SQL to create a View
    sysDescription    : String[255];   // Human readable description of field for informational purposes only
    sysValue          : String[255];   // The value of the System Setup Field as a string
    sysType           : String[30];    // The SQL Server data type of the System Setup Field - 'int', 'float', 'bit', 'varchar(x)', etc...

    // Pad to 900 with spare
    Spare             : Array [1..322] Of Byte;
  End; // SystemSetupRecType

  //------------------------------

  // Btrieve File Definition
  SystemSetupRecTypeBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..1] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // SystemSetupRecTypeBtrieveFileDefinitionType

  //------------------------------

  // Class for accessng the Pervasive.SQL Misc\SystemSetup.Dat data file
  TSystemSetupBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FSystemSetupRec : SystemSetupRecType;
    // Interface file structure definition
    FSystemSetupFileDef : SystemSetupRecTypeBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the table
    Procedure DefineSystemSetupFileStructure;
  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TSystemSetupIndex;
    Procedure SetIndex(Value : TSystemSetupIndex);
  Public
    Property Index : TSystemSetupIndex Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property SystemSetup : SystemSetupRecType Read FSystemSetupRec Write FSystemSetupRec;

    Constructor Create;

    Procedure InitialiseRecord;

    procedure Unlock;

    Function BuildIDKey (Const ID : Integer) : ShortString;
  End; // TSystemSetupBtrieveFile

Implementation

Uses Dialogs, SysUtils;

//=========================================================================

Constructor TSystemSetupBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FSystemSetupRec);
  FDataRec := @FSystemSetupRec;

  // link in File Definition
  FDataFileLen := SizeOf(FSystemSetupFileDef);
  FDataFile := @FSystemSetupFileDef;
  DefineSystemSetupFileStructure;
End; // Create

//-------------------------------------------------------------------------

// Defines the Btrieve File Structure for the Cust\AccountContact.Dat table
Procedure TSystemSetupBtrieveFile.DefineSystemSetupFileStructure;
Begin // DefineSystemSetupFileStructure
  // Define the Btrieve file structure
  FillChar(FSystemSetupFileDef, SizeOf(FSystemSetupFileDef), #0);
  With FSystemSetupFileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;  // 1024 bytes
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 1;

    // Idx 0: sysId
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FSystemSetupRec.sysId, @FSystemSetupRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FSystemSetupRec.sysId);
      // Flags for index
      KeyFlags := ExtType;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[1]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FSystemSetupFileDef
End; // DefineSystemSetupFileStructure

//-------------------------------------------------------------------------

Function TSystemSetupBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TSystemSetupBtrieveFile.GetIndex : TSystemSetupIndex;
Begin // GetIndex
  Result := TSystemSetupIndex(FIndex);
End; // GetIndex
Procedure TSystemSetupBtrieveFile.SetIndex(Value : TSystemSetupIndex);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

//-------------------------------------------------------------------------

Procedure TSystemSetupBtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  FillChar (FSystemSetupRec, SizeOf(FSystemSetupRec), #0);
End; // InitialiseRecord

//-------------------------------------------------------------------------

procedure TSystemSetupBtrieveFile.Unlock;
begin
  Cancel;
end;

//-------------------------------------------------------------------------

Function TSystemSetupBtrieveFile.BuildIDKey (Const ID : Integer) : ShortString;
Begin // BuildIDKey
  Result := StringOfChar(' ', SizeOf(ID));
  Move(ID, Result[1], SizeOf(Id));
End; // BuildIDKey

//=========================================================================

Initialization
  // Check for record structure size
  If (SizeOf(SystemSetupRecType) <> 900) Then
    ShowMessage('SystemSetupRecType - Expected Size=900, Actual Size= ' + IntToStr(SizeOf(SystemSetupRecType)));
End.