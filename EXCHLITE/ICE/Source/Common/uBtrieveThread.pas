unit uBtrieveThread;
{
  Object to allow multi-threaded access to Btrieve routines.
}
interface

uses
  GlobVar,
  BtrvU2,
  ExWrap1U;

type
  PBtrieveThread = ^TBtrieveThread;
  TBtrieveThread = object(TdMTExLocal)
    function LClose_File(FileNo: Byte): SmallInt;
    function LOpen_File(FileNo: Byte): SmallInt;
  end;

implementation

{ TBtrieveThread }

function TBtrieveThread.LClose_File(FileNo: Byte): SmallInt;
begin
  Result := Close_FileCId(LocalF^[FileNo], ExClientId)
end;

function TBtrieveThread.LOpen_File(FileNo: Byte): SmallInt;
begin
  Result := Open_FileCId(LocalF^[FileNo], SetDrive + FileNames[FileNo], 0, ExClientId);
end;

end.
