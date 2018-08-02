program LoginPassword;

uses
  Clipbrd,
  Forms,
  SpecialPassword in '..\FUNCS\SpecialPassword.pas';

{$R *.res}

begin
  Application.Initialize;
  Clipboard.AsText := GetPassword;
  Application.Run;
end.
