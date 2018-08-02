unit GroupsFile;

{$ALIGN 1}

interface

Uses Classes, Dialogs, GlobVar, BtrvU2, Sysutils;

Const
  // Access Constant for File - System Specific
  {$If Defined(COMP) Or Defined(SQLConversion)}
  GroupF = 18;
  {$ELSE}
    // GroupF needs to be properly defined for the system, it must be set to
    // a spare element of the global FileRecLen array that isn't in use within your
    // system
    Stop Compiling Here
  {$IFEND}

  GroupCodeK = 0;
  GroupNameK = 1;

  GroupCodeLen = 20;
  GroupNameLen = 60;

Type
  // Idx 0: grGroupCode
  // Idx 1: grGroupDesc

  // Bureau Groups record definition
  GroupFileRecType = Record
    // Unique Id Code - used for relational links
    grGroupCode  : String[GroupCodeLen];            // Padded to full length with ' '
    // Unique Group Name
    grGroupName  : String[GroupNameLen];            // Padded to full length with ' '


    // For future use
    grSpare      : Array [1..600] Of Byte;
  End; // GroupFileRecType

  //------------------------------

  // GroupFile Btrieve Interface definition
  GroupFileBtrieveRecType = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..2] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // GroupFileBtrieveRecType

  //------------------------------

Var
  GroupFileRec : GroupFileRecType;
  GroupFileBtr : ^GroupFileBtrieveRecType;

//------------------------------

// Returns a correctly padded GroupCode string
Function FullGroupCodeKey(Const GroupCode : ShortString) : ShortString;

// Returns a correctly padded GroupName string
Function FullGroupNameKey(Const GroupName : ShortString) : ShortString;

// Returns TRUE if a group with the specified code already exists
Function GroupCodeExists(GroupCode : ShortString) : Boolean;

// Returns TRUE if a group with the specified name already exists
Function GroupNameExists(GroupCode, GroupName : ShortString) : Boolean;

// Deletes the specified group record
Procedure DeleteGroup (GroupCode : ShortString);

//-------------------------------------------------------------------------

implementation

Uses ETStrU, SavePos;   // TBtrieveSavePosition

//-------------------------------------------------------------------------

Procedure DefineGroupFile;
Const
  Idx = GroupF;
Begin // DefineGroupFile
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx]  := Sizeof(GroupFileRec);
  RecPtr[Idx]      := @GroupFileRec;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(GroupFileBtr^);
  FileSpecOfs[Idx] := @GroupFileBtr^;

  // Initialise the Record and Btrieve structures
  FillChar (GroupFileRec, FileRecLen[Idx],  0);
  Fillchar (GroupFileBtr^, FileSpecLen[Idx], 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := 'Groups.Dat';

  // Define the Btrieve file structure
  With GroupFileBtr^ Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Index 0:- grGroupCode
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupFileRec.grGroupCode[1], @GroupFileRec);
      // length of segment in bytes
      KeyLen   := GroupCodeLen;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[1]

    // Index 1:- grGroupDesc
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupFileRec.grGroupName[1], @GroupFileRec);  // Ignore length byte of string
      // length of segment in bytes
      KeyLen   := GroupNameLen;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[2]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With GroupFileBtr^
End; // DefineGroupFile

//-------------------------------------------------------------------------

// Returns a correctly padded GroupCode string
Function FullGroupCodeKey(Const GroupCode : ShortString) : ShortString;
Begin // FullGroupCodeKey
  Result := UpcaseStr(LJVar(GroupCode, GroupCodeLen));
End; // FullGroupCodeKey

//-------------------------------------------------------------------------

// Returns a correctly padded GroupName string
Function FullGroupNameKey(Const GroupName : ShortString) : ShortString;
Begin // FullGroupNameKey
  Result := LJVar(GroupName, GroupNameLen);
End; // FullGroupNameKey

//-------------------------------------------------------------------------

Function GroupExists(Const SearchKey : ShortString; GroupCode : ShortString; Const Index : Byte) : Boolean;
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin // GroupExists
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the group file for the current key
      SaveFilePosition (GroupF, GetPosKey);
      SaveDataBlock (@GroupFileRec, SizeOf(GroupFileRec));

      // Build the key to find the group code
      KeyS := SearchKey;
      lStatus := Find_Rec(B_GetEq, F[GroupF], GroupF, RecPtr[GroupF]^, Index, KeyS);

      // Return TRUE if a record was successfully found
      Result := (lStatus = 0);
      If Result And (Trim(GroupCode) <> '') Then
      Begin
        // If the GroupCode matches that specified then it is OK as it has detected
        // the Group we are editing
        Result := (Trim(GroupFileRec.grGroupCode) <> Trim(GroupCode));
      End; // If Result And (Trim(GroupCode) <> '')

      // Restore position in group file
      RestoreSavedPosition;
      RestoreDataBlock (@GroupFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // GroupExists

//------------------------------

// Returns TRUE if a group with the specified code already exists
Function GroupCodeExists(GroupCode : ShortString) : Boolean;
Begin // GroupCodeExists
  Result := GroupExists (FullGroupCodeKey(GroupCode), '', GroupCodeK);
End; // GroupCodeExists

//------------------------------

// Returns TRUE if a group with the specified name already exists,
// but to stop it throwing errors when editing groups we also need
// to check that the group code differs
Function GroupNameExists(GroupCode, GroupName : ShortString) : Boolean;
Begin // GroupNameExists
  Result := GroupExists (FullGroupNameKey(GroupName), GroupCode, GroupNameK);
End; // GroupNameExists

//-------------------------------------------------------------------------

// Deletes the specified group record
Procedure DeleteGroup (GroupCode : ShortString);
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // DeleteGroup
  GroupCode := FullGroupCodeKey(GroupCode);
  sKey := GroupCode;
  iStatus := Find_Rec(B_GetEq, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, sKey);
  If (iStatus = 0) And (GroupFileRec.grGroupCode = GroupCode) Then
  Begin
    Delete_Rec(F[GroupF], GroupF, GroupCodeK);
  End; // If (iStatus = 0) And (GroupFileRec.grGroupCode = GroupCode)

End; // DeleteGroup

//-------------------------------------------------------------------------

Initialization
//ShowMessage ('GroupFileRecType: ' + IntToStr(SizeOf(GroupFileRecType)));

  // Allocate memory for the Group File record and Btrieve Definition
  //GetMem (GroupFileRec, SizeOf (GroupFileRec^));
  GetMem (GroupFileBtr, SizeOf (GroupFileBtr^));

  // Define the Btrieve file structure of the Group file within the global arrays
  DefineGroupFile;
Finalization
  // Deallocate memory for the Group File record and Btrieve Definition
  //FreeMem (GroupFileRec, SizeOf (GroupFileRec^));
  FreeMem (GroupFileBtr, SizeOf (GroupFileBtr^));
end.
