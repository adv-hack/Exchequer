unit oGenericBtrieveFile;

interface

Uses oBtrieveFile;

Type
  TGenericBtrieveFile = Class(TBaseBtrieveFile)
  Private
  Protected
    Function GetRecordPointer : Pointer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;

    Constructor Create;
    Destructor Destroy; Override;
  End; // TGenericBtrieveFile

implementation

//=========================================================================

Constructor TGenericBtrieveFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := 10000;
  GetMem(FDataRec, FDataRecLen);

// Only needed if creating the file
//  FDataFile    : Pointer;
//  FDataFileLen : LongInt;
End; // Create

//------------------------------

Destructor TGenericBtrieveFile.Destroy;
Begin // Destroy
  FreeMem(FDataRec);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TGenericBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//-------------------------------------------------------------------------

end.
