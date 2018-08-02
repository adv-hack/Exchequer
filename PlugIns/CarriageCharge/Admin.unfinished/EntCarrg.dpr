program EntCarrg;

uses
  Forms,
  AdminF in 'AdminF.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Carriage Charges Administrator';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
