program CheckPATH;

uses
  Forms,
  CheckPathF in 'CheckPathF.pas' {Form1};

{$R *.res}
// Bring in the resource file from the Vista Elevation Utility to theme the app and force elevations
{$R W:\ENTRPRSE\Vista\Elevate\Elevate.exe.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Check PATH Utility';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.


