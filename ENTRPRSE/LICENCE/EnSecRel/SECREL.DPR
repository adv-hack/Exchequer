program SecRel;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  MainFrmU in 'MainFrmU.pas' {Form1},
  ESNImpU in '..\Esnimpu.pas',
  SecVarU in 'SecVarU.pas',
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\Licrec.pas',
  SecUtilU in 'x:\ENTRPRSE\LICENCE\EnSecRel\SecUtilU.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Security Release';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
