unit oExchqChk;

interface

Uses oBtrieveFile, GlobVar, VarConst;

Type
  TExchqChkFile = Class(TBaseBtrieveFile) // PwrdF
  Private
    FPassword : PassWordRec;
  Protected
    Function GetRecordPointer : Pointer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property Password : PassWordRec Read FPassword Write FPassword;

    Constructor Create;
  End; // TExchqChkFile

implementation

//=========================================================================

Constructor TExchqChkFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := SizeOf(FPassword);
  FDataRec := @FPassword;
End; // Create

//-------------------------------------------------------------------------

Function TExchqChkFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//=========================================================================

end.
