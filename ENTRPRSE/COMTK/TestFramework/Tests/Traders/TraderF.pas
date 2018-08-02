unit TraderF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure AddTrader;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddTrader;
var
  oTrader : IAccount;
begin
  if FExtraParam <> '' then
  begin
    if FExtraParam[1] = 'C' then
      oTrader := oToolkit.Customer.Add
    else
      oTrader := oToolkit.Supplier.Add;

    with oTrader do
    begin
      acCode := 'ZZZ' + FExtraParam[1] + '01';
      acAltCode := acCode;
      acCompany := 'ZZZ Test ' + FExtraParam;
      acContact := FExtraParam[1] + ' Richards';
    end;

    FResult := oTrader.Save;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddTrader;
end;

end.
