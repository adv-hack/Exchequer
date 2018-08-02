program CurrList;

uses
  Forms,
  CcyListF in 'CcyListF.pas' {frmCurrencyList};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCurrencyList, frmCurrencyList);
  Application.Run;
end.
