Unit oExchqNumFile;

interface

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Uses oBtrieveFile;

Type
  // Import the structure of ExchqNum.Dat
  {$I ExchqNumRec.pas}

  //------------------------------

  TExchqNumBtrieveFile = Class(TBaseBtrieveFile)
  Private
    FDocumentNumber : IncrementRec;
  Protected
    Function GetRecordPointer : Pointer;

    Function GetCode : String;
    Function GetNextNumber : Integer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property DocumentNumber : IncrementRec Read FDocumentNumber Write FDocumentNumber;

    Property Code : String Read GetCode;
    Property NextNumber : Integer Read GetNextNumber;

    Constructor Create;
  End; // TExchqNumBtrieveFile

implementation

Uses SysUtils;

//=========================================================================

Constructor TExchqNumBtrieveFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := SizeOf(FDocumentNumber);
  FDataRec := @FDocumentNumber;
End; // Create

//-------------------------------------------------------------------------

Function TExchqNumBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TExchqNumBtrieveFile.GetCode : String;
Begin // GetCode
  Result := Trim(FDocumentNumber.CountTyp);
End; // GetCode

//------------------------------

Function TExchqNumBtrieveFile.GetNextNumber : Integer;
Begin // GetNextNumber
  // Extract the number from the string (WTF!)
  Move(FDocumentNumber.NextCount[1], Result, Sizeof(Result));
End; // GetNextNumber

//=========================================================================

end.