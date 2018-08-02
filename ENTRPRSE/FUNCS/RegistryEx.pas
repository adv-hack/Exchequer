unit RegistryEx;

interface

uses
  Registry, Classes;

type
  TRegistryEx = class(TRegistry)
  public
    function ReadMultiString(const name: string; s: TStringList): boolean;
  end;

implementation

uses
  SysUtils;

function TRegistryEx.ReadMultiString(const name: string; s: TStringList): boolean;
var
  RegData: TRegDataType;
  Info: TRegDataInfo;
  buffer: pchar;
  ptr: pchar;
begin
  s.Clear;
  if GetDataInfo(Name, Info) then
  begin
    GetMem(buffer, info.DataSize);
    Try
      ReadBinaryData(name, buffer^, info.DataSize);
      ptr := buffer;
      while ( ptr^ <> #0 ) do
      begin
        s.Add( ptr );
        inc ( ptr, StrLen(ptr) + 1 );
      end;

      Result := True;
    Finally
      FreeMem ( buffer );
    End;
  end
  else
    Result := False;

end;

end.
