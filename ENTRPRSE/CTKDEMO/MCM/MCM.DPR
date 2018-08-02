program MCM;

uses
  Forms,
  CompList in 'CompList.pas' {frmMCM};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Enterprise COM Toolkit - Company List';
  Application.CreateForm(TfrmMCM, frmMCM);
  Application.Run;
end.
