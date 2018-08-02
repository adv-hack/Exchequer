program CCDept;

uses
  Forms,
  CCListF in 'CCListF.pas' {frmCCDept};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCCDept, frmCCDept);
  Application.Run;
end.
