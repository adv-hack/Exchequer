Unit oCacheDataRecord;

Interface

Uses SysUtils, DateUtils;

Type
  TCachedDataRecord = Class(TObject)
  Private
    FData : Pointer;
    FDataSize : LongInt;
    FExpiryTime : TDateTime;
    Function GetExpired : Boolean;
  Public
    Property Expired : Boolean Read GetExpired;

    Constructor Create (Const RecPtr : Pointer; Const RecSize : LongInt);
    Destructor Destroy; Override;

    Procedure DownloadRecord (Const RecPtr : Pointer);
  End; // TCachedDataRecord

Implementation

//=========================================================================

Constructor TCachedDataRecord.Create (Const RecPtr : Pointer; Const RecSize : LongInt);
Begin // Create
  Inherited Create;

  FDataSize := RecSize;
  GetMem (FData, FDataSize);
  Move (RecPtr^, FData^, FDataSize);

  FExpiryTime := IncSecond(Now, 3600); // 1 hour
End; // Create

//------------------------------

Destructor TCachedDataRecord.Destroy;
Begin // Destroy
  FreeMem (FData, FDataSize);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TCachedDataRecord.GetExpired : Boolean;
Begin // GetExpired
  Result := (Now > FExpiryTime);
End; // GetExpired

//-------------------------------------------------------------------------

Procedure TCachedDataRecord.DownloadRecord (Const RecPtr : Pointer);
Begin // DownloadRecord
   Move (FData^, RecPtr^, FDataSize);
End; // DownloadRecord

//=========================================================================

End.
