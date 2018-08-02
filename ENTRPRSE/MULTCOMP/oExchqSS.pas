unit oExchqSS;

interface

Uses oBtrieveFile, GlobVar, VarConst;

Type
  TExchqSSFile = Class(TBaseBtrieveFile)
  Private
    FSyss : SysRec;
  Protected
    Function GetRecordPointer : Pointer;

    Function GetSysMod : ModRelRecType;
    Procedure SetSysMod (Value : ModRelRecType);
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property Syss : SysRec Read FSyss Write FSyss;
    Property SysMod : ModRelRecType Read GetSysMod Write SetSysMod;

    Constructor Create;
  End; // TExchqSSFile

implementation

//=========================================================================

Constructor TExchqSSFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := SizeOf(FSyss);
  FDataRec := @FSyss;
End; // Create

//-------------------------------------------------------------------------

Function TExchqSSFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//-------------------------------------------------------------------------

Function TExchqSSFile.GetSysMod : ModRelRecType;
Begin // GetSysMod
  Move (FDataRec^, Result, SizeOf(Result));
End; // GetSysMod

Procedure TExchqSSFile.SetSysMod (Value : ModRelRecType);
Begin // SetSysMod
  Move (Value, FDataRec^, SizeOf(Value));
End; // SetSysMod

//=========================================================================

end.
