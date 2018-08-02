unit AddMBDiscount;

interface
 uses enterprise04_tlb;

type TAddMBDiscount = Class
 protected
  fMBDiscount, FAddMBDiscount : IMultiBuy;
  fToolkit : IToolKit;
  fExpectedResult, fDocType : Integer;
  procedure SetMBDiscountProperties;
  function FindParentInterface : Integer; virtual; abstract;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveMBDiscount : integer; virtual;
 end;
type TAddCustomerMBDiscount = class(TAddMBDiscount)
public
 function FindParentInterface : integer; override;
end;

type TAddStockMBDiscount = class(TAddMBDiscount)
public
 function FindParentInterface : integer; override;
end;

type TAddSupplierMBDiscount = class(TAddMBDiscount)
public
 function FindParentInterface : integer; override;
end;

function GetMBDiscountObject(docType : Integer) : TAddMBDiscount;

implementation
var
 isRangeClashCheck : boolean;

function GetMBDiscountObject(docType : Integer) : TAddMBDiscount;
begin
  Case docType of
    1 : Result := TAddCustomerMBDiscount.Create;
    2 : Result := TAddStockMBDiscount.Create;
    5 : Result := TAddSupplierMBDiscount.Create;
    else
      Result := nil;
  end;
end;

function TAddMBDiscount.SaveMBDiscount : integer;
begin

 Result := FindParentInterface;

 if Result = 0 then
 begin
   SetMBDiscountProperties;
   Result := FAddMBDiscount.Save;

   if(fExpectedResult = 30011) and (isRangeClashCheck = false) then
   begin
    isRangeClashCheck := true;
    SaveMBDiscount;
   end;
 end;

end;

procedure TAddMBDiscount.SetMBDiscountProperties;
begin
 FAddMBDiscount := fMBDiscount.Add;

 with fAddMBDiscount do
 begin
  mbdType := 0;
  mbdStockCode := 'BAT-1.5AA-ALK';
  mbdCurrency := 1;
  mbdBuyQty := 2;
  mbdRewardValue := 1;
  mbdUseEffectiveDates := false;
  mbdDateEffectiveFrom := '20110301';
  mbdDateEffectiveTo := '20110401';
  mbdApplyQty := 2;

  if (fExpectedResult = 30003) or (fExpectedResult = 30004) or (fExpectedResult = 30011)
  then
     mbdUseEffectiveDates := true;

  case fExpectedResult of
   30001 : mbdType := 99;
   30003 : mbdDateEffectiveFrom := 'baddate';
   30004 : mbdDateEffectiveTo := 'THISISWRONGHOWCANTHISBERIGHT';
   30005 : mbdBuyQty := -9001;
   30006 : mbdRewardValue := -9001;
   30008 : mbdStockCode := '';
   30011 : begin
            if(isRangeClashCheck = true) then
            begin
              mbdDateEffectiveFrom := '20110102';
              mbdDateEffectiveTo := '20110105';
            end;
           end;
  end;
 end;

end;

function TAddCustomerMBDiscount.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Customer as IAccount3 do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('ABAP01');
    result := GetEqual(searchKey);

    fMBDiscount := acMultiBuy;
  end;
end;
{

}
function TAddStockMBDiscount.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Stock as IStock5 do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('BAT-1.5AA-ALK');
   result := GetEqual(searchKey);

   fMBDiscount := stMultiBuy;
  end;
end;

function TAddSupplierMBDiscount.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Supplier as IAccount2 do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('ACEE02');
    result := GetEqual(searchKey);

    //fMBDiscount := acMBDiscounts;
  end;
end;

end.
