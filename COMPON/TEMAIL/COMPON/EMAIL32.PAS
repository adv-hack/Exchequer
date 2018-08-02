{$IFDEF WIN32} unit Email32; {$ELSE} unit email16; {$ENDIF WIN32}

interface

uses
  Classes,
  Smapi, Email;   { Temail }

procedure Register;

implementation

{ Register our component. }
procedure Register;
begin
  RegisterComponents('TEmail', [Temail]);
end;


end.
 