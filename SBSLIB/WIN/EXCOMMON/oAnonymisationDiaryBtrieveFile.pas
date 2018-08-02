Unit oAnonymisationDiaryBtrieveFile;

Interface

{$Align 1}

Uses BtrvU2,          // Btrieve Interface
     oBtrieveFile,    // Btrieve Data Access Object
     GlobVar;

Const
  AnonymisationDiaryFileName = 'Misc\AnonymisationDiary.Dat';

Type
  // Unique Index used to directly find an entry for an Entity
  // Idx 0: adEntityType + adEntityCode

  // Unique Index used by the Anonymisation Diary lists
  // Idx 1: adAnonymisationDate + adEntityCode + adEntityType
  TAnonymisationDiaryIndex = (adIdxTypeCode=0, adIdxDateCodeType=1);

  //------------------------------

  // Type of entity awaiting anonymisation
  TAnonymisationDiaryEntity = (adeCustomer = 1,   // Also Consumer
                               adeSupplier = 2,
                               adeEmployee = 3);

  //------------------------------

  // Record Structure for Btrieve File
  AnonymisationDiaryRecType = Record
    // Type of parent entity
    adEntityType : TAnonymisationDiaryEntity;
    // Key Field to uniquely identify the parent entity, e.g. A/C Code
    adEntityCode : String[200];        // Note: Limited to 200 characters as max index length in btrieve is 255 bytes
    // Date Anonymisation should be performed
    adAnonymisationDate : LongDate;    // YYYYMMDD

    // Pad to 600 with spare
    Spare             : Array [1..389] Of Byte;
  End; // AnonymisationDiaryRecType

  //------------------------------

  // Btrieve File Definition
  AnonymisationDiaryBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..5] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // AnonymisationDiaryBtrieveFileDefinitionType

  //------------------------------

  // Class for accessng the Pervasive.SQL Misc\AnonymisationDiary.Dat data file
  TAnonymisationDiaryBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FAnonymisationDiaryRec : AnonymisationDiaryRecType;
    // Interface file structure definition
    FAnonymisationDiaryFileDef : AnonymisationDiaryBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the table
    Procedure DefineAnonymisationDiaryFileStructure;
  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TAnonymisationDiaryIndex;
    Procedure SetIndex(Value : TAnonymisationDiaryIndex);
  Public
    Property Index : TAnonymisationDiaryIndex Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property AnonymisationDiary : AnonymisationDiaryRecType Read FAnonymisationDiaryRec Write FAnonymisationDiaryRec;

    Constructor Create;

    Procedure InitialiseRecord;

    procedure Unlock;

    Function BuildTypeCodeKey (Const EntityType : TAnonymisationDiaryEntity; Const EntityCode : ShortString = '') : ShortString;

    Function BuildDateCodeTypeKey (Const AnonymisationDate : LongDate) : ShortString; Overload;
    Function BuildDateCodeTypeKey (Const AnonymisationDate : LongDate; Const EntityCode : ShortString; Const EntityType : TAnonymisationDiaryEntity) : ShortString; Overload;

    // Routine to pad the entity code when it is being written to the record
    Function PadEntityCode (Const EntityCode : ShortString) : ShortString;
  End; // TAnonymisationDiaryBtrieveFile


// Test routine which allows the AnonymisationDiary btrieve file to be created and populated with default data
//Procedure CreateAnonymisationDiaryFile(Const CompanyPath : ShortString);

Implementation

Uses Dialogs, SysUtils, StrUtil;

//=========================================================================

(****
Procedure CreateAnonymisationDiaryFile(Const CompanyPath : ShortString);
Var
  AnonymisationDiaryBtrFile : TAnonymisationDiaryBtrieveFile;

  //--------------------------------------------

  Procedure AddAnonymisationDiaryEntry (Const EntityType : TAnonymisationDiaryEntity; EntityCode : ShortString; AnonymisationDate : LongDate);
  Var
    Res : Integer;
  Begin // AddAnonymisationDiaryEntry
    Res := AnonymisationDiaryBtrFile.KeyExists(AnonymisationDiaryBtrFile.BuildTypeCodeKey (EntityType, EntityCode));
    If (Res <> 0) Then
    Begin
      AnonymisationDiaryBtrFile.InitialiseRecord;
      With AnonymisationDiaryBtrFile.AnonymisationDiary Do
      Begin
        adEntityType := EntityType;
        adEntityCode := AnonymisationDiaryBtrFile.PadEntityCode(EntityCode);
        adAnonymisationDate := AnonymisationDate;
      End; // With AnonymisationDiaryBtrFile.AnonymisationDiary
      Res := AnonymisationDiaryBtrFile.Insert;

      If (Res <> 0) Then
        ShowMessage ('Insert ' + AnonymisationDiaryBtrFile.AnonymisationDiary.adEntityCode + ': ' + IntToStr(Res));
    End; // If (Res <> 0)
  End; // AddAnonymisationDiaryEntry

  //--------------------------------------------

Begin // CreateAnonymisationDiaryFile
  AnonymisationDiaryBtrFile := TAnonymisationDiaryBtrieveFile.Create;

  // Try to open the Anonymisation Diary btrieve file - create if missing
  If (AnonymisationDiaryBtrFile.OpenFile (IncludeTrailingPathDelimiter(CompanyPath) + AnonymisationDiaryFileName, True) = 0) Then
  Begin
//    AddAnonymisationDiaryEntry (adeCustomer,  'ABAP01',    '20171231');
//    AddAnonymisationDiaryEntry (adeCustomer,  'HORL01',    '20170401');
//    AddAnonymisationDiaryEntry (adeCustomer,  'JIMB01',    '20220401');
//
//    AddAnonymisationDiaryEntry (adeSupplier,  'DEVL01',    '20220401');
//
//    AddAnonymisationDiaryEntry (adeEmployee,  'MARK01',    '20171130');
//    AddAnonymisationDiaryEntry (adeEmployee,  'STEV01',    '20120401');
  End; // If (AnonymisationDiaryBtrFile.OpenFile (IncludeTrailingPathDelimiter(CompanyPath) + AnonymisationDiaryFileName, True) = 0)

  AnonymisationDiaryBtrFile.Free;
End; // CreateAnonymisationDiaryFile
(* ****)

//=========================================================================

Constructor TAnonymisationDiaryBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FAnonymisationDiaryRec);
  FDataRec := @FAnonymisationDiaryRec;

  // link in File Definition
  FDataFileLen := SizeOf(FAnonymisationDiaryFileDef);
  FDataFile := @FAnonymisationDiaryFileDef;
  DefineAnonymisationDiaryFileStructure;
End; // Create

//-------------------------------------------------------------------------

// Defines the Btrieve File Structure for the table
Procedure TAnonymisationDiaryBtrieveFile.DefineAnonymisationDiaryFileStructure;
Begin // DefineAnonymisationDiaryFileStructure
  // Define the Btrieve file structure
  FillChar(FAnonymisationDiaryFileDef, SizeOf(FAnonymisationDiaryFileDef), #0);
  With FAnonymisationDiaryFileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize3;  // 2048 bytes
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Unique Index used to directly find an entry for an Entity
    // Idx 0: adEntityType + adEntityCode
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAnonymisationDiaryRec.adEntityType, @FAnonymisationDiaryRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAnonymisationDiaryRec.adEntityType);
      // Flags for index
      KeyFlags := Segmented + Modfy;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAnonymisationDiaryRec.adEntityCode[1], @FAnonymisationDiaryRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAnonymisationDiaryRec.adEntityCode) - 1;   // Remove length byte
      // Flags for index
      KeyFlags := Modfy;
    End; // With KeyBuff[2]

    // Unique Index used by the Anonymisation Diary lists
    // Idx 1: adAnonymisationDate + adEntityCode + adEntityType
    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAnonymisationDiaryRec.adAnonymisationDate[1], @FAnonymisationDiaryRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAnonymisationDiaryRec.adAnonymisationDate) - 1;   // Remove length byte
      // Flags for index
      KeyFlags := Segmented + Modfy;
    End; // With KeyBuff[3]
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAnonymisationDiaryRec.adEntityCode[1], @FAnonymisationDiaryRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAnonymisationDiaryRec.adEntityCode) - 1;   // Remove length byte
      // Flags for index
      KeyFlags := Segmented + Modfy;
    End; // With KeyBuff[4]
    With KeyBuff[5] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FAnonymisationDiaryRec.adEntityType, @FAnonymisationDiaryRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FAnonymisationDiaryRec.adEntityType);
      // Flags for index
      KeyFlags := Modfy;
    End; // With KeyBuff[5]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FAnonymisationDiaryFileDef
End; // DefineAnonymisationDiaryFileStructure

//-------------------------------------------------------------------------

Function TAnonymisationDiaryBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TAnonymisationDiaryBtrieveFile.GetIndex : TAnonymisationDiaryIndex;
Begin // GetIndex
  Result := TAnonymisationDiaryIndex(FIndex);
End; // GetIndex
Procedure TAnonymisationDiaryBtrieveFile.SetIndex(Value : TAnonymisationDiaryIndex);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

//-------------------------------------------------------------------------

Procedure TAnonymisationDiaryBtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  FillChar (FAnonymisationDiaryRec, SizeOf(FAnonymisationDiaryRec), #0);
End; // InitialiseRecord

//-------------------------------------------------------------------------

procedure TAnonymisationDiaryBtrieveFile.Unlock;
begin
  Cancel;
end;

//-------------------------------------------------------------------------

// Routine to pad the entity code when it is being written to the record
Function TAnonymisationDiaryBtrieveFile.PadEntityCode (Const EntityCode : ShortString) : ShortString;
Begin // PadEntityCode
  Result := PadString(psRight, EntityCode, ' ', SizeOf(FAnonymisationDiaryRec.adEntityCode) - 1);   // Remove length byte
End; // PadEntityCode

//-------------------------------------------------------------------------

Function TAnonymisationDiaryBtrieveFile.BuildTypeCodeKey (Const EntityType : TAnonymisationDiaryEntity; Const EntityCode : ShortString = '') : ShortString;
Begin // BuildTypeCodeKey
  // Unique Index used to directly find an entry for an Entity
  // Idx 0: adEntityType + adEntityCode
  Result := Chr(Ord(EntityType));

  If (EntityCode <> '') Then
    Result := Result + PadEntityCode (EntityCode);
End; // BuildTypeCodeKey

//-----------------------------------

Function TAnonymisationDiaryBtrieveFile.BuildDateCodeTypeKey (Const AnonymisationDate : LongDate) : ShortString;
Begin // BuildDateCodeTypeKey
  // Unique Index used by the Anonymisation Diary lists
  // Idx 1: adAnonymisationDate + adEntityCode + adEntityType
  Result := AnonymisationDate;
End; // BuildDateCodeTypeKey

Function TAnonymisationDiaryBtrieveFile.BuildDateCodeTypeKey (Const AnonymisationDate : LongDate; Const EntityCode : ShortString; Const EntityType : TAnonymisationDiaryEntity) : ShortString;
Begin // BuildDateCodeTypeKey
  // Unique Index used by the Anonymisation Diary lists
  // Idx 1: adAnonymisationDate + adEntityCode + adEntityType
  Result := AnonymisationDate;

  If (EntityCode <> '') Then
    Result := Result + PadEntityCode (EntityCode) + Chr(Ord(EntityType));
End; // BuildDateCodeTypeKey

//=========================================================================

Initialization
  // Check for record structure size
  If (SizeOf(AnonymisationDiaryRecType) <> 600) Then
    ShowMessage('AnonymisationDiaryRecType - Expected Size=600, Actual Size= ' + IntToStr(SizeOf(AnonymisationDiaryRecType)));
End.