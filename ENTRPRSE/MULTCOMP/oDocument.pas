unit oDocument;

interface

Uses oBtrieveFile, GlobVar, VarConst;

Type
  TDocumentFile = Class(TBaseBtrieveFile)
  Private
    FInv : InvRec;
  Protected
    Function GetRecordPointer : Pointer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property Inv : InvRec Read FInv Write FInv;

    Constructor Create;
  End; // TDocumentFile

implementation

//=========================================================================

Constructor TDocumentFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := SizeOf(FInv);
  FDataRec := @FInv;
End; // Create

//-------------------------------------------------------------------------

Function TDocumentFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//=========================================================================

end.
