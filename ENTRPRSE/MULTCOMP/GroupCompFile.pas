unit GroupCompFile;

{$ALIGN 1}

interface

Uses Classes, Dialogs, GlobVar, VarConst, BtrvU2, Sysutils, GroupsFile;

Const
  // Access Constant for File - System Specific
  {$If Defined(COMP)}
  GroupCompXRefF = 19;
  {$ELSEIF Defined(SQLConversion)}
    GroupCompXRefF = 19;
    // CompCodeLen duplicated from \Entrprse\MultComp\CompVar.Pas
    CompCodeLen = 6;
  {$ELSE}
    // GroupCompXRefF needs to be properly defined for the system, it must be set to
    // a spare element of the global FileRecLen array that isn't in use within your
    // system
    Stop Compiling Here
  {$IFEND}

  GroupCompXRefGroupK = 0;
  GroupCompXRefCompanyK = 1;

Type
  // Idx 0: gcGroupCode + gcCompanyCode - lists companies for a group
  // Idx 1: gcCompanyCode + gcGroupCode - lists groups containing the company

  // Groups/Companies x-ref record definition
  GroupCompaniesFileRecType = Record
    // Unique Group Code
    gcGroupCode   : String[GroupCodeLen];           // Padded to full length with ' '
    // Unique Company Code
    gcCompanyCode : String[CompCodeLen];            // Padded to full length with ' '

    // For future use
    gcSpare      : Array [1..100] Of Byte;
  End; // GroupCompaniesFileRecType

  //------------------------------

  // GroupFile Btrieve Interface definition
  GroupCompaniesFileBtrieveRecType = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..4] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // GroupCompaniesFileBtrieveRecType

  //------------------------------

{$IF Not Defined(SQLConversion)}
Var
  GroupCompFileRec : ^GroupCompaniesFileRecType;
  GroupCompFileBtr : ^GroupCompaniesFileBtrieveRecType;

  // Returns TRUE if there are any Group-Company XRef links for the specified
  // group code.
  Function GroupHasCompanies (GroupCode : ShortString) : Boolean;

  // Deletes the Group-Company XRef records for a specified Company Code, called
  // when a Company is deleted from the Company list
  Procedure DeleteCompanyGroups (CompanyCode : ShortString);
{$IFEND}

implementation

{$IF Not Defined(SQLConversion)}

Uses ETStrU,
     SavePos,       // Object encapsulating the btrieve saveposition/restoreposition functions
     BTKeys1U;

//-------------------------------------------------------------------------

Procedure DefineGroupCompXrefFile;
Const
  Idx = GroupCompXRefF;
Begin // DefineGroupCompXrefFile
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx]  := Sizeof(GroupCompFileRec^);
  RecPtr[Idx]      := @GroupCompFileRec^;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(GroupCompFileBtr^);
  FileSpecOfs[Idx] := @GroupCompFileBtr^;

  // Initialise the Record and Btrieve structures
  FillChar (GroupCompFileRec^, FileRecLen[Idx],  0);
  Fillchar (GroupCompFileBtr^, FileSpecLen[Idx], 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := 'GroupCmp.Dat';

  // Define the Btrieve file structure
  With GroupCompFileBtr^ Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Index 0: gcGroupCode + gcCompanyCode - lists companies for a group
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupCompFileRec^.gcGroupCode[1], @GroupCompFileRec^);
      // length of segment in bytes
      KeyLen   := GroupCodeLen;
      // Flags for index
      KeyFlags := ModSeg + AltColSeq;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupCompFileRec^.gcCompanyCode[1], @GroupCompFileRec^);
      // length of segment in bytes
      KeyLen   := CompCodeLen;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[2]

    // Index 1: gcCompanyCode + gcGroupCode - lists groups containing the company
    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupCompFileRec^.gcCompanyCode[1], @GroupCompFileRec^);
      // length of segment in bytes
      KeyLen   := CompCodeLen;
      // Flags for index
      KeyFlags := ModSeg + AltColSeq;
    End; // With KeyBuff[3]
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupCompFileRec^.gcGroupCode[1], @GroupCompFileRec^);
      // length of segment in bytes
      KeyLen   := GroupCodeLen;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[4]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With GroupCompFileBtr^
End; // DefineGroupCompXrefFile

//-------------------------------------------------------------------------

// Returns TRUE if there are any Group-Company XRef links for the specified
// group code.  The global GroupCompFileRec and file position are not changed.
Function GroupHasCompanies (GroupCode : ShortString) : Boolean;
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // GroupHasCompanies
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (GroupCompXRefF, GetPosKey);
      SaveDataBlock (GroupCompFileRec, SizeOf(GroupCompFileRec^));

      //------------------------------

      GroupCode := FullGroupCodeKey(GroupCode);

      // Try to get a Group-Company XRef record for the specified group
      sKey := GroupCode;
      iStatus := Find_Rec(B_GetGEq, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
      Result := (iStatus = 0) And (GroupCompFileRec^.gcGroupCode = GroupCode);

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (GroupCompFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // GroupHasCompanies

//-------------------------------------------------------------------------

// Deletes the Group-Company XRef records for a specified Company Code, called
// when a Company is deleted from the Company list
Procedure DeleteCompanyGroups (CompanyCode : ShortString);
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // DeleteCompanyGroups
  // Format the company code correctly
  CompanyCode := FullCompCode(CompanyCode);

  // Run through the Group-Company XRef table in Company Code order deleting matching records
  sKey := CompanyCode;
  iStatus := Find_Rec(B_GetGEq, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefCompanyK, sKey);
  While (iStatus = 0) And (GroupCompFileRec^.gcCompanyCode = CompanyCode) Do
  Begin
    // Delete record
    iStatus := Delete_Rec(F[GroupCompXRefF], GroupCompXRefF, GroupCompXRefCompanyK);

    // Move to next - previous/next position still works OK after delete
    iStatus := Find_Rec(B_GetNext, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefCompanyK, sKey);
  End; // While (iStatus = 0) And (GroupCompFileRec^.gcCompanyCode = CompanyCode)
End; // DeleteCompanyGroups

//-------------------------------------------------------------------------

Initialization
//ShowMessage ('GroupCompaniesFileRecType: ' + IntToStr(SizeOf(GroupCompaniesFileRecType)));

  // Allocate memory for the File record and Btrieve Definition
  GetMem (GroupCompFileRec, SizeOf (GroupCompFileRec^));
  GetMem (GroupCompFileBtr, SizeOf (GroupCompFileBtr^));

  // Define the Btrieve file structure of the file within the global arrays
  DefineGroupCompXrefFile;
Finalization
  // Deallocate memory for the File record and Btrieve Definition
  FreeMem (GroupCompFileRec, SizeOf (GroupCompFileRec^));
  FreeMem (GroupCompFileBtr, SizeOf (GroupCompFileBtr^));
{$IFEND}
End.


