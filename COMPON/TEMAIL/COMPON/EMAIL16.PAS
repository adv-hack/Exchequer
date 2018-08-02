{$IFDEF WIN32} unit Email32; {$ELSE} unit Email16; {$ENDIF WIN32}

interface

uses
  Classes,
  Smapi, Email;   { Temail }

procedure Register;

implementation

{ Register our component. }
procedure Register;
begin
  RegisterComponents('Compon', [Temail]);
end;


end.
 