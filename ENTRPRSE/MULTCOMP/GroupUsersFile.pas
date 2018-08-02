unit GroupUsersFile;

// Definition of GroupUsr.Dat (GroupUsersF) and utility functions

{$ALIGN 1}

interface

Uses Classes, Dialogs, GlobVar, VarConst, BtrvU2, Sysutils, GroupsFile;

Const
  // Access Constant for File - System Specific
  {$If Defined(COMP) Or Defined(SQLConversion)}
    GroupUsersF = 20;
  {$ELSE}
    // GroupCompXRefF needs to be properly defined for the system, it must be set to
    // a spare element of the global FileRecLen array that isn't in use within your
    // system
    Stop Compiling Here
  {$IFEND}

  GroupUsersGroupCodeK = 0;
  GroupUsersGroupNameK = 1;
  GroupUsersCodeK = 2;

  GroupUsersCodeLen = 20;
  GroupUsersNameLen = 60;

Type
  // Enumeration for accessing the guPermissions array
  TUserPermissions = ( upUndefined           = 0,      // Needed for the Edit User Dialog for structural elements

                       // Permissions within the Bureau Company List
                       upOpenEBusiness       = 1,
                       upOpenEnterprise      = 2,
                       upOpenExchequer       = 3,   // Removed 09/05/07 for v6.00 as DOS not supported
                       upRebuildGroup        = 4,
                       upOpenSentimail       = 5,
                       upChangeOwnPassword   = 6,
                       upEditMCMOptions      = 7,
                       upOpenScheduler       = 8,

                       // Permissions within the Maintain Companies List
                       upAccessCompanies     = 40,
                       upAddCompany          = 41,
                       upEditCompany         = 42,
                       upDeleteCompany       = 43,
                       upLoggedInUserReport  = 44,
                       upBackupCompany       = 45,
                       upRestoreCompany      = 46,
                       upRebuildAllComps     = 47,
                       upViewCompany         = 48,

                       // Permissions within the Maintain Groups List
                       upAccessGroups        = 60,
                       upAddGroup            = 61,
                       upEditGroup           = 62,
                       upDeleteGroup         = 63,
                       upPrintGroup          = 64,

                       // Permissions within the Group Detail window
                       upGrpLinkCompanies    = 70,
                       upGrpAddUser          = 71,
                       upGrpEditUser         = 72,
                       upGrpDeleteUser       = 73,
                       upGrpChangeUserPword  = 74
                     );


  // Idx 0: guGroupCode + guUserCode - lists users for a group in User Code order
  // Idx 1: guGroupCode + guUserName - lists users for a group in User Name order
  // Idx 2: guUserCode               - main lookup index from login dialog and when editing

  // Groups/Companies x-ref record definition
  GroupUsersFileRecType = Record
    // Unique Group Code
    guGroupCode   : String[GroupCodeLen];           // Padded to full length with ' '

    // Globally Unique User Code across all groups used for Login
    guUserCode    : String[GroupUsersCodeLen];      // Padded to full length with ' '
    // User Name
    guUserName    : String[GroupUsersNameLen];      // Padded to full length with ' '
    // Users Password - cannot be blank
    guPassword    : String[10];
    // Users permissions within the Bureau Module
    guPermissions : Array [1..100] Of Boolean;

    // For future use
    guSpare      : Array [1..200] Of Byte;
  End; // GroupUsersFileRecType

  //------------------------------

  // GroupFile Btrieve Interface definition
  GroupUsersFileBtrieveRecType = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..5] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // GroupUsersFileBtrieveRecType

  //------------------------------

Var
  GroupUsersFileRec : ^GroupUsersFileRecType;
  GroupUsersFileBtr : ^GroupUsersFileBtrieveRecType;


// Returns a correctly padded UserCode string
Function FullUserCode (Const UserCode : ShortString) : ShortString;

// Returns a correctly padded UserName string
Function FullUserName (Const UserName : ShortString) : ShortString;

// Returns TRUE if the specified User Code already exists
Function UserCodeExists (UserCode : ShortString) : Boolean;

// Returns TRUE if there are any User records for the specified group code.
// The global GroupUsersFileRec and file position are not changed.
Function GroupHasUsers (GroupCode : ShortString) : Boolean;

// Deletes the specified user
Procedure DeleteGroupUser (UserCode : ShortString);


implementation

Uses ETStrU, SavePos;   // TBtrieveSavePosition

//-------------------------------------------------------------------------

Procedure DefineGroupUsersFile;
Const
  Idx = GroupUsersF;
Begin // DefineGroupUsersFile
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx]  := Sizeof(GroupUsersFileRec^);
  RecPtr[Idx]      := @GroupUsersFileRec^;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(GroupUsersFileBtr^);
  FileSpecOfs[Idx] := @GroupUsersFileBtr^;

  // Initialise the Record and Btrieve structures
  FillChar (GroupUsersFileRec^, FileRecLen[Idx],  0);
  Fillchar (GroupUsersFileBtr^, FileSpecLen[Idx], 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := 'GroupUsr.Dat';

  // Define the Btrieve file structure
  With GroupUsersFileBtr^ Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 3;

    // Index 0: guGroupCode + guUserCode - lists users for a group in User Code order
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupUsersFileRec^.guGroupCode[1], @GroupUsersFileRec^);
      // length of segment in bytes
      KeyLen   := GroupCodeLen;
      // Flags for index
      KeyFlags := ModSeg + AltColSeq;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupUsersFileRec^.guUserCode[1], @GroupUsersFileRec^);
      // length of segment in bytes
      KeyLen   := GroupUsersCodeLen;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[2]

    // Index 1: guGroupCode + guUserName - lists users for a group in User Name order
    KeyBuff[3] := KeyBuff[1];
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@GroupUsersFileRec^.guUserName[1], @GroupUsersFileRec^);
      // length of segment in bytes
      KeyLen   := GroupUsersNameLen;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[4]

    // Index 2: guUserCode - main lookup index from login dialog and when editing
    KeyBuff[5] := KeyBuff[2];

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With GroupUsersFileBtr^
End; // DefineGroupUsersFile

//-------------------------------------------------------------------------

// Returns a correctly padded UserCode string
Function FullUserCode (Const UserCode : ShortString) : ShortString;
Begin // FullUserCode
  Result := UpcaseStr(LJVar(UserCode, GroupUsersCodeLen));
End; // FullUserCode

//------------------------------

// Returns a correctly padded UserName string
Function FullUserName (Const UserName : ShortString) : ShortString;
Begin // FullUserName
  Result := LJVar(UserName, GroupUsersNameLen);
End; // FullUserName

//-------------------------------------------------------------------------

// Returns TRUE if the specified User Code already exists
Function UserCodeExists (UserCode : ShortString) : Boolean;
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin // UserCodeExists
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the group file for the current key
      SaveFilePosition (GroupUsersF, GetPosKey);
      SaveDataBlock (GroupUsersFileRec, SizeOf(GroupUsersFileRec^));

      // Build the key to find the group code
      KeyS := FullUserCode(UserCode);
      lStatus := Find_Rec(B_GetEq, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersCodeK, KeyS);

      // Return TRUE if a record was successfully found
      Result := (lStatus = 0);

      // Restore position in group file
      RestoreSavedPosition;
      RestoreDataBlock (GroupUsersFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // UserCodeExists

//-------------------------------------------------------------------------

// Returns TRUE if there are any User records for the specified group code.
// The global GroupUsersFileRec and file position are not changed.
Function GroupHasUsers (GroupCode : ShortString) : Boolean;
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // GroupHasUsers
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (GroupUsersF, GetPosKey);
      SaveDataBlock (GroupUsersFileRec, SizeOf(GroupUsersFileRec^));

      //------------------------------

      GroupCode := FullGroupCodeKey(GroupCode);

      // Try to get a User record for the specified group
      sKey := GroupCode;
      iStatus := Find_Rec(B_GetGEq, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK, sKey);
      Result := (iStatus = 0) And (GroupUsersFileRec^.guGroupCode = GroupCode);

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (GroupUsersFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // GroupHasUsers

//-------------------------------------------------------------------------

// Deletes the specified user
Procedure DeleteGroupUser (UserCode : ShortString);
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // DeleteGroupUser
  UserCode := FullUserCode(UserCode);
  sKey := UserCode;
  iStatus := Find_Rec(B_GetEq, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersCodeK, sKey);
  If (iStatus = 0) And (GroupUsersFileRec^.guUserCode = UserCode) Then
  Begin
    Delete_Rec(F[GroupUsersF], GroupUsersF, GroupUsersCodeK);
  End; // If (iStatus = 0) And (GroupUsersFileRec^.guUserCode = UserCode)
End; // DeleteGroupUser

//-------------------------------------------------------------------------

Initialization
//ShowMessage ('GroupUsersFileRec: ' + IntToStr(SizeOf(GroupUsersFileRecType)));

  // Allocate memory for the File record and Btrieve Definition
  GetMem (GroupUsersFileRec, SizeOf (GroupUsersFileRec^));
  GetMem (GroupUsersFileBtr, SizeOf (GroupUsersFileBtr^));

  // Define the Btrieve file structure of the file within the global arrays
  DefineGroupUsersFile;
Finalization
  // Deallocate memory for the File record and Btrieve Definition
  FreeMem (GroupUsersFileRec, SizeOf (GroupUsersFileRec^));
  FreeMem (GroupUsersFileBtr, SizeOf (GroupUsersFileBtr^));
End.


