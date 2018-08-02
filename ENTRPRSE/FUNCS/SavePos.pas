unit SavePos;

interface

Uses Classes;

Type
  // Generic object to wrap the Save Position / Restore Position process
  //
  // Example:-
  //
  //    With TBtrieveSavePosition.Create Do
  //    Begin
  //      Try
  //        // Save the current position in the file for the current key
  //        SaveFilePosition (CustF, GetPosKey);
  //
  //        ** DO STUFF **
  //
  //        // Restore position in file
  //        RestoreSavedPosition;
  //      Finally
  //        Free;
  //      End; // Try..Finally
  //    End; // With TBtrieveSavePosition.Create
  //
  TBtrieveSavePosition = Class(TObject)
  Private
    // The DataBlock fields store the data saved by the SaveDataBlock method, FDataBlock is a
    // pointer to a block of dynamically allocated memory and FDataBlockSize is the size of the
    // memory that was allocated.
    FDataBlock     : Pointer;
    FDataBlockSize : LongInt;
    // File Number of the global file within which the position is being saved, e.g. CustF
    FFileNo  : SmallInt;
    // Index Number for the global file within which the saved position was done, e.g. CustCodeK
    FKeyPath : Integer;
    // The saved position itself set by the SaveFilePosition method
    FRecAddr : LongInt;
    // Status returned from the last Save/Restore operation (0=AOK, else Btrieve Error)
    FStatus  : SmallInt;

    // Checks the DataBlock fields and deallocates any used memory
    Procedure FreeDataBlock;
  Public
    Property spFileNo : SmallInt Read FFileNo;
    Property spKeyPath : Integer Read FKeyPath;
    Property spRecAddr : LongInt Read FRecAddr;
    Property spStatus : SmallInt Read FStatus;

    // Creates an instance of the object and initialises the internal properties
    Constructor Create;
    Destructor Destroy; Override;

    // Copies the contents of the cached DataBlock into the passed pointer.
    //
    // Parameters:-
    //
    //   DataBlock      A pointer to the memory block in which the data is to be
    //                  restored.  If this refers to a smaller structure than that
    //                  in the cache then you should get an Access Violation.
    //
    Procedure RestoreDataBlock (Const DataBlock : Pointer);

    // Makes of copy of the contents of the passed pointer in memory.
    //
    // Parameters:-
    //
    //   DataBlock      A pointer to the block of data that is to be copied
    //
    //   DataBlockSize  The size of the structure within the pointer
    //
    Procedure SaveDataBlock (Const DataBlock : Pointer; Const DataBlockSize : LongInt);

    // Restores a previously saved position and returns TRUE if successful.
    //
    // Parameters:-
    //
    //   ReadRecord   This optional parameter controls whether the record
    //                at the saved position is re-read or whether the file
    //                is just positioned on that record.
    //
    //                True=Re-Read Record, False=Position Only (DEFAULT)
    //
    // Return Value:-
    //
    //   True if the position is successfully saved, False if there was a
    //   problem, see the spStatus property for the exact error number.
    //
    Function RestoreSavedPosition (Const ReadRecord : Boolean = False) : Boolean;

    // Saves the current position in the specified file for the specified index
    // and returns TRUE if successful.
    //
    // Parameters:-
    //
    //   FileNo       File Number of the global file within which the
    //                position is being saved, e.g. CustF.
    //
    //   IndexNo      Index Number for the global file within which the
    //                saved position was done, e.g. CustCodeK.  If not known
    //                then pass in GetPosKey which will cause the last used
    //                index to be looked up from a global array.
    //
    // Return Value:-
    //
    //   True if the position is successfully saved, False if there was a
    //   problem, see the spStatus property for the exact error number.
    //
    Function SaveFilePosition (Const FileNo, IndexNo : SmallInt) : Boolean;
  End; // TBtrieveSavePosition


implementation

Uses BtrvU2;

//-------------------------------------------------------------------------

Constructor TBtrieveSavePosition.Create;
Begin // Create
  Inherited Create;

  // Initialise the status to -1 to prevent the RestoreSavedPosition
  // method from doing anything until a successful call to SaveFilePosition
  // has been done
  FStatus := -1;

  // Initialise the data block fields to the unused values
  FDataBlock := NIL;
  FDataBlockSize := 0
End; // Create

//------------------------------

Destructor TBtrieveSavePosition.Destroy;
Begin // Destroy
  // Free the data block if it has been used
  FreeDataBlock;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Checks the DataBlock fields and deallocates any used memory
Procedure TBtrieveSavePosition.FreeDataBlock;
Begin // FreeDataBlock
  If Assigned(FDataBlock) And (FDataBlockSize > 0) Then
  Begin
    FreeMem (FDataBlock, FDataBlockSize);
    FDataBlock := NIL;
    FDataBlockSize := 0;
  End; // If Assigned(FDataBlock) And (FDataBlockSize > 0)
End; // FreeDataBlock

//-------------------------------------------------------------------------

// Makes of copy of the contents of the passed pointer in memory.
//
// Parameters:-
//
//   DataBlock      A pointer to the block of data that is to be copied
//
//   DataBlockSize  The size of the structure within the pointer
//
Procedure TBtrieveSavePosition.SaveDataBlock (Const DataBlock : Pointer; Const DataBlockSize : LongInt);
Begin // SaveDataBlock
  // Get rid of any previous DataBlock
  FreeDataBlock;

  // Record the size and allocate the memory
  FDataBlockSize := DataBlockSize;
  GetMem (FDataBlock, FDataBlockSize);

  // Copy the specified block of memory into the local cache
  Move (DataBlock^, FDataBlock^, FDataBlockSize);
End; // SaveDataBlock

//-------------------------------------------------------------------------

// Copies the contents of the cached DataBlock into the passed pointer.
//
// Parameters:-
//
//   DataBlock      A pointer to the memory block in which the data is to be
//                  restored.  If this refers to a smaller structure than that
//                  in the cache then you should get an Access Violation.
//
Procedure TBtrieveSavePosition.RestoreDataBlock (Const DataBlock : Pointer);
Begin // RestoreDataBlock
  // Check the DataBlock is allocated
  If Assigned(FDataBlock) And (FDataBlockSize > 0) Then
  Begin
    // Copy the specified block of memory into the local cache
    Move (FDataBlock^, DataBlock^, FDataBlockSize);
  End; // If Assigned(FDataBlock) And (FDataBlockSize > 0)
End; // RestoreDataBlock

//-------------------------------------------------------------------------

// Saves the current position in the specified file for the specified index
// and returns TRUE if successful.
//
// Parameters:-
//
//   FileNo       File Number of the global file within which the
//                position is being saved, e.g. CustF.
//
//   IndexNo      Index Number for the global file within which the
//                saved position was done, e.g. CustCodeK.  If not known
//                then pass in GetPosKey which will cause the last used
//                index to be looked up from a global array.
//
// Return Value:-
//
//   True if the position is successfully saved, False if there was a
//   problem, see the spStatus property for the exact error number.
//
Function TBtrieveSavePosition.SaveFilePosition (Const FileNo, IndexNo : SmallInt) : Boolean;
Begin // SaveFilePosition
  FFileNo  := FileNo;
  FKeyPath := IndexNo;
  FStatus  := Presrv_BTPos (FFileNo, FKeyPath, F[FFileNo], FRecAddr, False, False);

  Result := (FStatus = 0);
End; // SaveFilePosition

//-------------------------------------------------------------------------

// Restores a previously saved position and returns TRUE if successful.
//
// Parameters:-
//
//   ReadRecord   This optional parameter controls whether the record
//                at the saved position is re-read or whether the file
//                is just positioned on that record.
//
//                True=Re-Read Record, False=Position Only (DEFAULT)
//
// Return Value:-
//
//   True if the position is successfully saved, False if there was a
//   problem, see the spStatus property for the exact error number.
//
Function TBtrieveSavePosition.RestoreSavedPosition (Const ReadRecord : Boolean = False) : Boolean;
Begin // RestoreSavedPosition
  // Check the SaveFilePosition worked
  If (FStatus = 0) Then
    FStatus := Presrv_BTPos(FFileNo, FKeyPath, F[FFileNo], FRecAddr, True, ReadRecord);

  Result := (FStatus = 0);
End; // RestoreSavedPosition

//-------------------------------------------------------------------------

end.
