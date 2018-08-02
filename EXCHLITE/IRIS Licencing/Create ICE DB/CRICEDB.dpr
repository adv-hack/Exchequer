program CRICEDB;

uses
  Forms,
  MainF in 'MainF.pas' {Form1},
  ELITE_COM_TLB in 'X:\EXCHLITE\IRIS Licencing\ELITE_COM_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
