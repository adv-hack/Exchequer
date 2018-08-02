program Test;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  uTest in 'uTest.pas' {frmTest},
  uBTRecords in 'uBTRecords.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
