unit oEbusTrans;

interface

uses
  oBtrieveFile, VarConst;

const
  EBUS_TRANS_FILE = 'Ebus\EbusDoc.dat';

type
  TEbusTransFile = Class(TBaseBtrieveFile)
  Private
    FTransRec : InvRec;
  Protected
    Function GetRecordPointer : Pointer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property TransRec : InvRec Read FTransRec;

    Constructor Create(const DataPath : string);
  End; // TDocumentFile


implementation

{ TEbusTransFile }

constructor TEbusTransFile.Create(const DataPath : string);
begin
  Inherited Create;

  FDataRecLen := SizeOf(FTransRec);
  FDataRec := @FTransRec;

  FilePath := DataPath + EBUS_TRANS_FILE;
  FBypassOpenCompany := True;

end;

function TEbusTransFile.GetRecordPointer: Pointer;
begin
  Result := @FDataRec;
end;

end.
