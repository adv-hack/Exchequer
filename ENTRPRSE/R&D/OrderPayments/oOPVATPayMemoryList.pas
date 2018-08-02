Unit oOPVATPayMemoryList;

Interface

Uses Classes, SysUtils, oOPVATPayBtrieveFile;

Type
  // Container for a list of TOrderPaymentsVATPayDetailsBtrieveFile
  TOrderPaymentsVATPayDetailsList = Class(TObject)
  Private
    FVATPayRecords : TList;
    Function GetCount : Integer;
    Function GetRecords(Index : Integer) : OrderPaymentsVATPayDetailsRecType;
  Public
    Property Count : Integer Read GetCount;
    Property Records [Index : Integer] : OrderPaymentsVATPayDetailsRecType Read GetRecords;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure Add (Const VATPayRec : OrderPaymentsVATPayDetailsRecType);
  End; // TOrderPaymentsVATPayDetailsList

Implementation

//=========================================================================

Constructor TOrderPaymentsVATPayDetailsList.Create;
Begin // Create
  Inherited Create;

  FVATPayRecords := TList.Create;
End; // Create

Destructor TOrderPaymentsVATPayDetailsList.Destroy;
Var
  VATPayPtr : ^OrderPaymentsVATPayDetailsRecType;
Begin // Destroy
  While (FVATPayRecords.Count > 0) Do
  Begin
    VATPayPtr := FVATPayRecords.Items[0];
    FreeMem(VATPayPtr);
    FVATPayRecords.Delete(0);
  End; // While (FVATPayRecords.Count > 0)
  FreeAndNIL(FVATPayRecords);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TOrderPaymentsVATPayDetailsList.GetCount : Integer;
Begin // GetCount
  Result := FVATPayRecords.Count;
End; // GetCount

Function TOrderPaymentsVATPayDetailsList.GetRecords(Index : Integer) : OrderPaymentsVATPayDetailsRecType;
Var
  VATPayPtr : ^OrderPaymentsVATPayDetailsRecType;
Begin // GetRecords
  If (Index >= 0) And (Index < FVATPayRecords.Count) Then
  Begin
    VATPayPtr := FVATPayRecords.Items[Index];
    Result := VATPayPtr^;
  End // If (Index >= 0) And (Index < FVATPayRecords.Count)
  Else
    Raise Exception.Create ('TOrderPaymentsVATPayDetailsList.GetRecords: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FVATPayRecords.Count) + ')');
End; // GetRecords

//-------------------------------------------------------------------------

Procedure TOrderPaymentsVATPayDetailsList.Add (Const VATPayRec : OrderPaymentsVATPayDetailsRecType);
Var
  VATPayPtr : ^OrderPaymentsVATPayDetailsRecType;
Begin // Add
  GetMem(VATPayPtr, SizeOf(VATPayPtr^));
  VATPayPtr^ := VATPayRec;
  FVATPayRecords.Add (VATPayPtr);
End; // Add

//=========================================================================


End.
