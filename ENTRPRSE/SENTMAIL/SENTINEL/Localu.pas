unit Localu;

interface

Type
  TLocaliseProc = function (const APath : string) : string of Object;

  procedure InitialiseLocaliser(LocaliseProc : TLocaliseProc);
  function GetToolkitPath(const APath: string): string;

implementation

uses
  SQLUtils;

var
  Localise : TLocaliseProc;

procedure InitialiseLocaliser(LocaliseProc : TLocaliseProc);
begin
  Localise := LocaliseProc;
end;

function GetToolkitPath(const APath: string): string;
begin
{$IFDEF SERVICE}
  if Assigned(Localise) and UsingSQL then
    Result := Localise(APath)
  else
{$ENDIF}
    Result := APath;
end;

end.
