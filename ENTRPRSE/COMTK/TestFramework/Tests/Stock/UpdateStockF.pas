unit UpdateStockF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure UpdateStockItem;
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
  UpdateStockItem;
end;

procedure TfrmTestTemplate1.UpdateStockItem;
var
  oStock : IStock;
begin
  with oToolkit.Stock do
  begin
    Index := stIdxCode;
    Fresult := GetLast;
    while (FResult = 0) and (stType <> stTypeProduct) do
      GetNext;

    if FResult = 0 then
    begin
      oStock := oToolkit.Stock.Update;

      if Assigned(oStock) then
      begin
        oStock.stDesc[2] := 'Line 2...';
        oStock.stDesc[3] := '...and a half';

        FResult := oStock.Save;
      end
      else
        FREsult := -1;
    end
    else
      FREsult := -1;
  end;
end;

end.
