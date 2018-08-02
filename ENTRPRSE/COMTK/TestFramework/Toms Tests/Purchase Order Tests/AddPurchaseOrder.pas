unit AddPurchaseOrder;

interface
 uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;

type TAddPurchaseQuote = Class
 protected
  fPurchaseQuote : ITransaction;
  fToolkit : IToolKit;
  fExpectedResult : Integer;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SavePurchaseQuote : integer;
  function CopyTransaction : integer;
  function ConvertToOrder : integer;
  function ConvertToInvoice : integer;
end;

function GetPurchaseQuoteObject : TAddPurchaseQuote;

implementation

function GetPurchaseQuoteObject : TAddPurchaseQuote;
begin
 Result := TAddPurchaseQuote.Create;
end;

function TAddPurchaseQuote.SavePurchaseQuote : integer;
var
  TransO : ITransaction;
begin
  TransO := fToolkit.Transaction.Add(dtPQU);

  With TransO Do Begin
    thAcCode :=  'BARK01';

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

    Result := Save(True);
  End;
  TransO := Nil;
end;
function TAddPurchaseQuote.CopyTransaction : integer;
var
  pquTran : ITransaction;
  funcRes    : SmallInt;
begin
  With fToolKit.Transaction as ITransaction2 Do
  begin
    Index := thIdxOurRef;
    funcRes := GetLessThanOrEqual(BuildOurRefIndex('PQU999999'));

    if(funcRes = 0) then
    begin
      pquTran := Copy;
      pquTran.thTransDate := '20881130';
    end
    else
      ShowMessage('Purchase quote not found');
  end;

  if(pquTran <> nil) then
    Result := pquTran.Save(true);
end;

function TAddPurchaseQuote.ConvertToOrder : integer;
var
  funcRes : SmallInt;
begin
  With fToolKit.Transaction as ITransaction2 Do
  begin
    Index := thIdxOurRef;
    funcRes := GetLessThanOrEqual(BuildOurRefIndex('PQU999999'));

    if(funcRes = 0) then
    begin
      with Convert(dtPOR) do
      begin
        Result := Check;
      end;
    end
    else
    begin
      ShowMessage('Purchase quote not found');
      Result := -1;
    end;
  end;
end;
function TAddPurchaseQuote.ConvertToInvoice : integer;
var
  funcRes    : SmallInt;
begin
  With fToolKit.Transaction as ITransaction2 Do
  begin
    Index := thIdxOurRef;
    funcRes := GetLessThanOrEqual(BuildOurRefIndex('PQU999999'));

    if(funcRes = 0) then
    begin
      with Convert(dtPIN) do
      begin
        Result := Check;
      end;
    end
    else
    begin
      ShowMessage('Purchase quote not found');
      Result := -1;
    end;
  end;
end;

end.
