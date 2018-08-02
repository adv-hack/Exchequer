unit ScratchF;

{$ALIGN 1}

interface

Uses Classes, Dialogs, BtrvU2, Sysutils;

Const
  // Access Constant for File - System Specific
  {$If Defined(EDLL)}
    // Form Designer Dll
    ScratchFileF = 21;
  {$ELSEIF Defined(Example_System)}
    // Example of how to add support for additional systems
    ScratchFileF = 21;
  {$ELSE}
    // ScratchFileF needs to be properly defined for the system, it must be set to
    // a spare element of the global FileRecLen array that isn't in use within your
    // system
    Stop Compiling Here
  {$IFEND}

Type
  // Sub-record used to contain a saved record position
  BtrieveFileSavePosRecType = Record
    fsFileNo   : SmallInt;
    fsKeyPath  : Integer;
    fsRecAddr  : LongInt;
  End; { BtrieveFileSavePosRecType }

  //------------------------------

  // ScratchFile Record definition
  ScratchFileRecType = Record
    // Process Id - links the record to a specific process/task
    scProcessId       : LongInt;
    // Sort Key for Idx1 - defined by the process/task
    scSortKey1        : String[100];
    // Sort Key for Idx2 - defined by the process/task
    scSortKey2        : String[100];

    // Array of saved record positions
    scRecordPositions : Array [1..4] Of BtrieveFileSavePosRecType;

    // Miscellaneous data fields for additional storage
    scBytes           : Array[1..4] Of Byte;
    scDoubles         : Array[1..4] Of Double;
    scIntegers        : Array[1..4] Of LongInt;
    scStrings         : Array[1..4] Of String[30];
    scLongString      : String[100];

    Spare             : Array[1..121] of Byte;
  End; // ScratchFileRecType

  //------------------------------

  // ScratchFile Btrieve Interface definition
  ScratchFileBtrieveRecType = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..4] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // ScratchFileBtrieveRecType

  //------------------------------

Var
  ScratchFileRec : ^ScratchFileRecType;
  ScratchFileBtr : ^ScratchFileBtrieveRecType;

implementation

//Uses GlobVar,
//     {VarConst, }
//     BTKeys1U,
//     BTSupU1,
//     Excep3U;

//=========================================================================

Procedure DefineScratchFile;
Const
  Idx = ScratchFileF;
Begin // DefineScratchFile
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx]  := Sizeof(ScratchFileRec^);
  RecPtr[Idx]      := @ScratchFileRec^;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(ScratchFileBtr^);
  FileSpecOfs[Idx] := @ScratchFileBtr^;

  // Initialise the Record and Btrieve structures
  FillChar (ScratchFileRec^, FileRecLen[Idx],  0);
  Fillchar (ScratchFileBtr^, FileSpecLen[Idx], 0);

  // Define the path and filename of the data file relative to the Exchequer directory
  FileNames[Idx] := '';     // In this case particular case the name is generated at runtime

  // Define the Btrieve file structure
  With ScratchFileBtr^ Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Index 0:- ProcessId + SortKey1
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@ScratchFileRec^.scProcessId, @ScratchFileRec^);
      // length of segment in bytes
      KeyLen   := SizeOf(ScratchFileRec^.scProcessId);
      // Extended Type - only necessary for certain types
      ExtTypeVal := BInteger;
      // Flags for index
      KeyFlags := DupModSeg + ExtType;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@ScratchFileRec^.scSortKey1[1], @ScratchFileRec^);  // Ignore length byte of string
      // length of segment in bytes
      KeyLen   := SizeOf(ScratchFileRec^.scSortKey1) - 1;
      // Flags for index
      KeyFlags := DupMod;
    End; // With KeyBuff[2]

    // Index 1:- ProcessId + SortKey2
    KeyBuff[3] := KeyBuff[1];
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@ScratchFileRec^.scSortKey2[1], @ScratchFileRec^);  // Ignore length byte of string
      // length of segment in bytes
      KeyLen   := SizeOf(ScratchFileRec^.scSortKey2) - 1;
      // Flags for index
      KeyFlags := DupMod;
    End; // With KeyBuff[4]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With ScratchFileBtr^
End; // DefineScratchFile

//=========================================================================

Initialization
//ShowMessage ('ScratchFileRecType: ' + IntToStr(SizeOf(ScratchFileRecType)));

  // Allocate memory for the Scratch File record and Btrieve Definition
  GetMem (ScratchFileRec, SizeOf (ScratchFileRec^));
  GetMem (ScratchFileBtr, SizeOf (ScratchFileBtr^));

  // Define the Btrieve file structure of the scratch file within the global arrays
  DefineScratchFile;
Finalization
  // Deallocate memory for the Scratch File record and Btrieve Definition
  FreeMem (ScratchFileRec, SizeOf (ScratchFileRec^));
  FreeMem (ScratchFileBtr, SizeOf (ScratchFileBtr^));
end.
