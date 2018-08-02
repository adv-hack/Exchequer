unit ScratchO;

{$ALIGN 1}

interface

Uses Classes, BtrvU2, Sysutils, ScratchF;

Type
  TSavePosArray = 1..4;
  TString30 = String[30];
  TString100 = String[100];

  //------------------------------

  TScratchSavedPosition = Class(TObject)
  Private
    FSavePosNo : TSavePosArray;
  Protected
    Function GetFileNo : Byte;
    Function GetIndexNo : Byte;
    Function GetRecordPosition : LongInt;
  Public
    Constructor Create (Const SavePosNo : TSavePosArray);

    Property spFileNo : Byte Read GetFileNo;
    Property spIndexNo : Byte Read GetIndexNo;
    Property spRecordPosition : LongInt Read GetRecordPosition;

    // Restores the saved record position to the global file  (returns -1 if no saved position)
    Function LinkToRecordPosition (Const GetRecord : Boolean = True) : LongInt;

    // Saves the record position for the specified global file
    Function SaveRecordPosition (Const FileNo, KeyPath : SmallInt) : LongInt;

    // Stores an already saved record position
    Procedure StoreSavedPosition (Const FileNo, KeyPath : SmallInt; Const RecAddress : LongInt);
  End; // TScratchSavedPosition

  //------------------------------

  //
  TScratchFile = Class(TObject)
  Private
    // Flag to track whether the Scratch File has been opened successfully
    FFileOpen : Boolean;

    // Flag to indicate whether we want to keep the file when we finish or delete it
    FKeepFile : Boolean;

    // Current position in the temporary scratch file
    //FPosition : LongInt;

    // This is a unique number which will uniquely identify the data
    // within the file as belonging to the parent process, prevents one
    // process from accidentally using another processes data
    FProcessId : LongInt;

    // Array of sub-objects encapsulating the Saved Record Position array
    FSavePositions : Array [TSavePosArray] Of TScratchSavedPosition;
  Protected
    // Deletes all records with a process Id matching FProcessId
    Procedure DeleteProcess;
    // Return Next Available Swap File Name, For MultiUser reasons
    Function GetSwapName : ShortString;

    // Get/Set methods for sfSortKey1
    Function GetSortKey1 : TString100;
    Procedure SetSortKey1 (Value : TString100);
    // Get/Set methods for sfSortKey2
    Function GetSortKey2 : TString100;
    Procedure SetSortKey2 (Value : TString100);
    // Get method for array of sub-objects wrapping the save positions
    Function GetSavePositions (Index : TSavePosArray) : TScratchSavedPosition;
    // Get/Set methods for sfBytes array
    Function GetBytes (Index : TSavePosArray) : Byte;
    Procedure SetBytes (Index : TSavePosArray; Const Value : Byte);
    // Get/Set methods for sfDoubles array
    Function GetDoubles (Index : TSavePosArray) : Double;
    Procedure SetDoubles (Index : TSavePosArray; Const Value : Double);
    // Get/Set methods for sfIntegers array
    Function GetIntegers (Index : TSavePosArray) : LongInt;
    Procedure SetIntegers (Index : TSavePosArray; Const Value : LongInt);
    // Get/Set methods for sfStrings array
    Function GetStrings (Index : TSavePosArray) : TString30;
    Procedure SetStrings (Index : TSavePosArray; Value : TString30);
    // Get/Set methods for sfLongString property
    Function GetLongString : TString100;
    Procedure SetLongString (Value : TString100);
  Public
    Constructor Create (Const ProcessId : LongInt);
    Destructor Destroy; Override;

    Property sfKeepFile  : Boolean Read FKeepFile Write FKeepFile;
    Property sfOpen      : Boolean Read FFileOpen;
    Property sfProcessId : LongInt Read FProcessId;

    // Sort Key for Idx1 - defined by the process/task
    Property sfSortKey1 : TString100 Read GetSortKey1 Write SetSortKey1;
    // Sort Key for Idx2 - defined by the process/task
    Property sfSortKey2 : TString100 Read GetSortKey2 Write SetSortKey2;
    // Array (1..4) of saved record positions
    Property sfSavePositions [Index : TSavePosArray] : TScratchSavedPosition Read GetSavePositions;
    // Miscellaneous storage properties
    Property sfBytes [Index : TSavePosArray] : Byte Read GetBytes Write SetBytes;
    Property sfDoubles [Index : TSavePosArray] : Double Read GetDoubles Write SetDoubles;
    Property sfIntegers [Index : TSavePosArray] : LongInt Read GetIntegers Write SetIntegers;
    Property sfStrings [Index : TSavePosArray] : TString30 Read GetStrings Write SetStrings;
    Property sfLongString : TString100 Read GetLongString Write SetLongString;


    // Property Position : LongInt Read FPosition;

    // Function RestorePosition : LongInt;
    // Function SavePosition : LongInt;


    Procedure InitForAdd;
    Procedure OverrideRecProcessId (Const ProcId : LongInt);
    Function Save : Integer;
    Function Update : Integer;


//Procedure Add_Scratch(FNo,
//                      KPath  :  Integer;
//                      RAddr  :  LongInt;
//                      KeySCr,
//                      MatchK :  Str255);
//
//
//Procedure Get_Scratch(TRepScr:  RepScrRec);


  End;

  //------------------------------



implementation

Uses GlobVar,
     {VarConst, }
     BTKeys1U,
     BTSupU1,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     Excep3U;

Var
  ScrtCount  :  Integer;

//=========================================================================

Constructor TScratchSavedPosition.Create (Const SavePosNo : TSavePosArray);
Begin // Create
  Inherited Create;

  FSavePosNo := SavePosNo;
End; // Create

//-------------------------------------------------------------------------

// Restores the saved record position to the global file  (returns -1 if no saved position)
Function TScratchSavedPosition.LinkToRecordPosition (Const GetRecord : Boolean = True) : LongInt;
Begin // LinkToRecordPosition
  With ScratchFileRec^.scRecordPositions[FSavePosNo] Do
  Begin
    If (fsRecAddr <> 0) Then
    Begin
      // Restore saved position
      Result := Presrv_BTPos(fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOn, GetRecord);
    End // If (fsRecAddr <> 0)
    Else
      // No saved position - return error
      Result := -1;
  End; // With ScratchFileRec^.scRecordPositions[FSavePosNo]
End; // LinkToRecordPosition

//-------------------------------------------------------------------------

// Saves the record position for the specified global file
Function TScratchSavedPosition.SaveRecordPosition (Const FileNo, KeyPath : SmallInt) : LongInt;
Begin // SaveRecordPosition
  With ScratchFileRec^.scRecordPositions[FSavePosNo] Do
  Begin
    fsFileNo  := FileNo;
    fsKeyPath := KeyPath;
    Result    := Presrv_BTPos (fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOff, BOff);
  End; // With ScratchFileRec^.scRecordPositions[FSavePosNo]
End; // SaveRecordPosition

//-------------------------------------------------------------------------

Procedure TScratchSavedPosition.StoreSavedPosition (Const FileNo, KeyPath : SmallInt; Const RecAddress : LongInt);
Begin // StoreSavedPosition
  With ScratchFileRec^.scRecordPositions[FSavePosNo] Do
  Begin
    fsFileNo  := FileNo;
    fsKeyPath := KeyPath;
    fsRecAddr := RecAddress;
  End; // With ScratchFileRec^.scRecordPositions[FSavePosNo]
End; // StoreSavedPosition

//-------------------------------------------------------------------------

Function TScratchSavedPosition.GetFileNo : Byte;
Begin // GetFileNo
  Result := ScratchFileRec^.scRecordPositions[FSavePosNo].fsFileNo;
End; // GetFileNo

//------------------------------

Function TScratchSavedPosition.GetIndexNo : Byte;
Begin // GetFileNo
  Result := ScratchFileRec^.scRecordPositions[FSavePosNo].fsKeyPath;
End; // GetFileNo

//------------------------------

Function TScratchSavedPosition.GetRecordPosition : LongInt;
Begin // GetRecordPosition
  Result := ScratchFileRec^.scRecordPositions[FSavePosNo].fsRecAddr;
End; // GetRecordPosition

//=========================================================================

// Creates a new instance of the TScratchFile object
//
// Parameters:-
//
//   ProcessId    A unique number which will uniquely identify the data
//                within the file as belonging to the parent process
//
//
Constructor TScratchFile.Create (Const ProcessId : LongInt);
Var
  KeyS        : Str255;
  lStatus     : SmallInt;
  I           : TSavePosArray;
  FSpec       : FileSpec;
Begin // Create
  Inherited Create;

  // Setup properties
  FKeepFile  := BOff;       // Delete file as default
  FProcessId := ProcessId;

  // Create Sub-objects
  For I := Low(FSavePositions) To High(FSavePositions) Do
    FSavePositions[I] := TScratchSavedPosition.Create(I);

  // Increment the Scratch Object Counter - this prevents the file being closed
  // until it reaches zero - a primitive reference count really!
  Inc(ScrtCount);

  // Check to see if a Scratch File is already open - if it is the Find_Rec call
  // will return zero, if it isn't we'll get a btrieve error
  //FFileOpen := (Used_Recs (F[ScratchFileF], ScratchFileF) = 0);
  FFileOpen := (GetFileSpec(F[ScratchFileF], ScratchFileF, FSpec) = 0);

  If (Not FFileOpen) Then
  Begin
    // Scratch file not already open - create a new scratch file and open it
    FileNames[ScratchFileF] := GetSwapName;
    lStatus := Make_File (F[ScratchFileF], SetDrive + FileNames[ScratchFileF], FileSpecOfs[ScratchFileF]^, FileSpecLen[ScratchFileF]);

    If (lStatus = 0) then
      lStatus := Open_File (F[ScratchFileF], SetDrive+FileNames[ScratchFileF], (-1 * Ord(AccelMode)));

    FFileOpen := (lStatus = 0);

    Report_BError(ScratchFileF, lStatus);
  End // If (Used_Recs (F[ScratchFileF], ScratchFileF) = 0)
  Else
    // Already open, in case same instance has been here before, delete all
    // occurrences of Process Id
    DeleteProcess;
End; // Create

//------------------------------

Destructor TScratchFile.Destroy;
Var
  DelF    : File of Byte;
  lStatus : SmallInt;
Begin // Destroy
  // Decrement the Scratch Object Counter - the file will be closed
  // when it reaches zero - a primitive reference count!
  Dec(ScrtCount);

  If (ScrtCount <= 0) Then
  Begin
    lStatus := Close_File(F[ScratchFileF]);

    If (lStatus = 0) And (Not FKeepFile) Then
    Begin
{$IFDEF EXSQL}
      SQLUtils.DeleteTable(SetDrive+FileNames[ScratchFileF]);
{$ELSE}
      {$I-}
      AssignFile(DelF, SetDrive+FileNames[ScratchFileF]);
      Erase(DelF);
      Report_IOError(IOResult, SetDrive+FileNames[ScratchFileF]);
      {$I+}
{$ENDIF}
    End; // If (lStatus = 0) And (Not FKeepFile)
  End; // If (ScrtCount <= 0)

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Return next available unique swap file name within the Swap directory
// off of Exchequer.
Function TScratchFile.GetSwapName : ShortString;
Const
  // MH 23/04/07: Modified for SQL project to allow different temp file types to be discerned
  //SwapPrefix    = '$REP';
{$IFDEF EXSQL}
  SwapPrefix    = 'FD';
  SwapExtension = '.DAT';
{$ELSE}
  SwapPrefix    = '$FD';
  SwapExtension = '.SWF';
{$ENDIF}
Var
  n,IOChk     :  Integer;
  SwapFileName,
  TDirN       :  Str255;
  NumStr      :  Str10;
Begin
  {$I-}
  n:=1;
  TDirN:=GetSwapDir;
  Repeat
    Str(n:0,NumStr);
    SwapFileName:=TDirN+SwapPrefix+NumStr+SwapExtension;
    Inc(n);
  //RB 07/06/2017 2017-R2 ABSEXCH-14156: Temporary Data Files limited to 255 files- Causing Form Printing to Crash (Exch365)
  //$FD99999 max Limit of 8 character according to 8.3 filenames
{$IFDEF EXSQL}
  Until (Not TableExists(SetDrive+SwapFileName)) or (n>99999);
{$ELSE}
  Until (Not FileExists(SetDrive+SwapFileName)) or (n>99999);
{$ENDIF}
  {$I+}

  Result := SwapFileName;
end; {Func..}

//-------------------------------------------------------------------------

// Deletes all records with a process Id matching FProcessId
Procedure TScratchFile.DeleteProcess;
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin // DeleteProcess
  // Get the first record for the current Process Id
  KeyS := FullNomKey(FProcessId);
  lStatus := Find_Rec(B_GetGEq, F[ScratchFileF], ScratchFileF, RecPtr[ScratchFileF]^, 0, KeyS);

  While (lStatus=0) And (ScratchFileRec^.scProcessId = FProcessId) Do
  Begin
    // Delete the record
    lStatus := Delete_Rec(F[ScratchFileF], ScratchFileF, 0);

    // Get the first record for the current Process Id
    KeyS := FullNomKey(FProcessId);
    lStatus := Find_Rec(B_GetGEq, F[ScratchFileF], ScratchFileF, RecPtr[ScratchFileF]^, 0, KeyS);
  End; // While (lStatus=0) And (ScratchFileRec^.scProcessId = FProcessId)
End; // DeleteProcess

//-------------------------------------------------------------------------

// Initialise the global Scratch File record ready for a new record to be added
Procedure TScratchFile.InitForAdd;
Begin // InitForAdd
  FillChar (ScratchFileRec^, SizeOf(ScratchFileRec^), #0);
  With ScratchFileRec^ Do
  Begin
    scProcessId := FProcessId;


  End; // With ScratchFileRec^
End; // InitForAdd

//-------------------------------------------------------------------------

Procedure TScratchFile.OverrideRecProcessId (Const ProcId : LongInt);
Begin // OverrideRecProcessId
  With ScratchFileRec^ Do
  Begin
    scProcessId := ProcId;

  End; // With ScratchFileRec^
End; // OverrideRecProcessId

//-------------------------------------------------------------------------

Function TScratchFile.Save : Integer;
Begin // Save
  Result := Add_Rec (F[ScratchFileF], ScratchFileF, RecPtr[ScratchFileF]^, GetThreadKeypath(ScratchFileF, 0));
End; // Save

//-------------------------------------------------------------------------

Function TScratchFile.Update : Integer;
Begin // Update
  Result := Put_Rec (F[ScratchFileF], ScratchFileF, RecPtr[ScratchFileF]^, GetThreadKeypath(ScratchFileF, 0));
End; // Update

//-------------------------------------------------------------------------

Function TScratchFile.GetSortKey1 : TString100;
Begin // GetSortKey1
  Result := ScratchFileRec^.scSortKey1
End; // GetSortKey1

Procedure TScratchFile.SetSortKey1 (Value : TString100);
Begin // SetSortKey1
  ScratchFileRec^.scSortKey1 := Value;
End; // SetSortKey1

//------------------------------

Function TScratchFile.GetSortKey2 : TString100;
Begin // GetSortKey2
  Result := ScratchFileRec^.scSortKey2;
End; // GetSortKey2

Procedure TScratchFile.SetSortKey2 (Value : TString100);
Begin // SetSortKey2
  ScratchFileRec^.scSortKey2 := Value;
End; // SetSortKey2

//------------------------------

Function TScratchFile.GetSavePositions (Index : TSavePosArray) : TScratchSavedPosition;
Begin // GetSavePositions
  Result := FSavePositions[Index];
End; // GetSavePositions

//------------------------------

Function TScratchFile.GetBytes (Index : TSavePosArray) : Byte;
Begin // GetBytes
  Result := ScratchFileRec^.scBytes[Index];
End; // GetBytes

Procedure TScratchFile.SetBytes (Index : TSavePosArray; Const Value : Byte);
Begin // SetBytes
  ScratchFileRec^.scBytes[Index] := Value;
End; // SetBytes

//------------------------------

Function TScratchFile.GetDoubles (Index : TSavePosArray) : Double;
Begin // GetDoubles
  Result := ScratchFileRec^.scDoubles[Index];
End; // GetDoubles

Procedure TScratchFile.SetDoubles (Index : TSavePosArray; Const Value : Double);
Begin // SetDoubles
  ScratchFileRec^.scDoubles[Index] := Value;
End; // SetDoubles

//------------------------------

Function TScratchFile.GetIntegers (Index : TSavePosArray) : LongInt;
Begin // GetIntegers
  Result := ScratchFileRec^.scIntegers[Index];
End; // GetIntegers

Procedure TScratchFile.SetIntegers (Index : TSavePosArray; Const Value : LongInt);
Begin // SetIntegers
  ScratchFileRec^.scIntegers[Index] := Value;
End; // SetIntegers

//------------------------------

Function TScratchFile.GetStrings (Index : TSavePosArray) : TString30;
Begin // GetStrings
  Result := ScratchFileRec^.scStrings[Index];
End; // GetStrings

Procedure TScratchFile.SetStrings (Index : TSavePosArray; Value : TString30);
Begin // SetStrings
  ScratchFileRec^.scStrings[Index] := Value;
End; // SetStrings

//------------------------------

Function TScratchFile.GetLongString : TString100;
Begin // GetLongString
  Result := ScratchFileRec^.scLongString;
End; // GetLongString

Procedure TScratchFile.SetLongString (Value : TString100);
Begin // SetLongString
  ScratchFileRec^.scLongString := Value;
End; // SetLongString

//------------------------------




//=========================================================================

Initialization
  // Intialise the Scratch Object counter - this controls the closing of
  // the scratch file
  ScrtCount := 0;
end.
