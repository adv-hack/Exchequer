unit oCompanyDat;

{$ALIGN 1}

interface


Uses {$IFDEF EXSQL}oBtrieveFile{$ELSE}oBtrieveOnlyFile{$ENDIF};

Type
  ISNArrayType = Array[1..8] of Byte;

{$I x:\entrprse\multcomp\compvar.pas}


Type
  pCompRec = ^CompRec;

  TCompanyFile = Class(TBaseBtrieveFile)
  Private
    FCompany : CompRec;
  Protected
    Function GetRecordPointer : pCompRec;
  Public
    Property Company : pCompRec Read GetRecordPointer;

    Constructor Create;
    Function GetPosition(Var RecAddr : LongInt) : SmallInt;
  End; // TCompanyFile

implementation

//=========================================================================

Constructor TCompanyFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := SizeOf(FCompany);
  FDataRec := @FCompany;
End; // Create

//-------------------------------------------------------------------------

Function TCompanyFile.GetRecordPointer : pCompRec;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//-------------------------------------------------------------------------

Function TCompanyFile.GetPosition(Var RecAddr : LongInt) : SmallInt;
Begin // GetPosition
  Result := Inherited GetPosition(RecAddr);
End; // GetPosition



end.
