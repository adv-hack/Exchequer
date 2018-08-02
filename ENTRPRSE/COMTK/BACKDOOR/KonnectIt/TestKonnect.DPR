program TestKonnect;

uses
  Forms,
  TestF in 'TestF.PAS' {frmCustList};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCustList, frmCustList);
  Application.Run;
end.
