unit UpdTraderF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure UpdateTrader;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
begin
  UpdateTrader;
end;

procedure TfrmTestTemplate1.UpdateTrader;
var
  oTrader : IAccount;
  TraderU : IAccount;
begin
  if FExtraParam[1] in ['C', 'c'] then
    oTrader := oToolkit.Customer
  else
    oTrader := oToolkit.Supplier;

  with oTrader do
  begin
    Index := acIdxCode;
    Fresult := GetLast;

    if FResult = 0 then
    begin
      TraderU := oTrader.Update;
      if Assigned(TraderU) then
      begin
        TraderU.acContact := 'New contact';
        FResult := TraderU.Save;
      end
      else
        FResult := -1;
    end;
  end;
end;

end.
