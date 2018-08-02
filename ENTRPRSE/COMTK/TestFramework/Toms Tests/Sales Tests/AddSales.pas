unit AddSales;

interface
 uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;

type TAddSalesQuote = Class
 protected
  fSalesQuote : ITransaction;
  fToolkit : IToolKit;
  fExpectedResult : Integer;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveSalesQuote : integer;
  function CopyTransaction : integer;
  function ConvertToOrder : integer;
  function ConvertToInvoice : integer;
end;

function GetSalesQuoteObject : TAddSalesQuote;

implementation

function GetSalesQuoteObject : TAddSalesQuote;
begin
 Result := TAddSalesQuote.Create;
end;

function TAddSalesQuote.SaveSalesQuote : integer;
var
  TransO : ITransaction;
  Res    : SmallInt;
begin
  TransO := fToolkit.Transaction.Add(dtSQU);

  With TransO Do Begin
    thAcCode :=  'BICL01';

    ImportDefaults;
    thDueDate := '20881230';
    thTransDate := '20881230';
    With thLines.Add Do
    Begin
      tlLineDate := '20111230';
      tlStockCode := 'COPIER';
      tlLocation := 'AAA';
      tlQty := 12;
      ImportDefaults;
      Save;
    End;

    Res := Save(True);
  End;
  TransO := Nil;
end;
function TAddSalesQuote.CopyTransaction : integer;
var
  squTran : ITransaction;
  funcRes    : SmallInt;
begin
  With fToolKit.Transaction as ITransaction2 Do
  begin
    Index := thIdxOurRef;
    funcRes := GetLessThanOrEqual(BuildOurRefIndex('SQU999999'));

    if(funcRes = 0) then
    begin
      squTran := Copy;
      squTran.thTransDate := '20881130';
    end
    else
      ShowMessage('Sales quote not found');
  end;

  if(squTran <> nil) then
    Result := squTran.Save(true);
end;

function TAddSalesQuote.ConvertToOrder : integer;
var
  funcRes    : SmallInt;
begin
  With fToolKit.Transaction as ITransaction2 Do
  begin
    Index := thIdxOurRef;
    funcRes := GetLessThanOrEqual(BuildOurRefIndex('SQU999999'));

    if(funcRes = 0) then
    begin
      with Convert(dtSOR) do
      begin
        Result := Check;
      end;
    end
    else
    begin
      ShowMessage('Sales quote not found');
      Result := -1;
    end;
  end;
end;
function TAddSalesQuote.ConvertToInvoice : integer;
var
  funcRes    : SmallInt;
begin
  With fToolKit.Transaction as ITransaction2 Do
  begin
    Index := thIdxOurRef;
    funcRes := GetLessThanOrEqual(BuildOurRefIndex('SQU999999'));

    if(funcRes = 0) then
    begin
      with Convert(dtSIN) do
      begin
        Result := Check;
      end;
    end
    else
    begin
      ShowMessage('Sales quote not found');
      Result := -1;
    end;
  end;
end;

end.
