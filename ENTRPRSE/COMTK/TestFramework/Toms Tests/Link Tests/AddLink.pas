unit AddLink;

interface
 uses enterprise04_tlb;

type TAddLink = Class
 protected
  fLink, FAddLink : ILinks;
  fToolkit : IToolKit;
  fExpectedResult, fDocType : Integer;
  procedure SetLinkProperties;
  function FindParentInterface : Integer; virtual; abstract;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveLink : integer; virtual;
 end;

type TAddCustomerLink = class(TAddLink)
public
 function FindParentInterface : integer; override;
end;

type TAddTransactionLink = class(TAddLink)
public
 function FindParentInterface : integer; override;
end;

type TAddStockLink = class(TAddLink)
public
 function FindParentInterface : integer; override;
end;

type TAddJobLink = class(TAddLink)
public
 function FindParentInterface : integer; override;
end;

type TAddEmployeeLink = class(TAddLink)
public
 function FindParentInterface : integer; override;
end;

type TAddSupplierLink = class(TAddLink)
public
 function FindParentInterface : integer; override;
end;

function GetLinkObject(docType : Integer) : TAddLink;

implementation

function GetLinkObject(docType : Integer) : TAddLink;
begin
  Case docType of
    0 : Result := TAddCustomerLink.Create;
    1 : Result := TAddTransactionLink.Create;
    2 : Result := TAddStockLink.Create;
    3 : Result := TAddJobLink.Create;
    4 : Result := TAddEmployeeLink.Create;
    5 : Result := TAddSupplierLink.Create;
    else
      Result := nil;
  end;
end;

function TAddLink.SaveLink : integer;
begin
 Result := FindParentInterface;

 if Result = 0 then
 begin
   SetLinkProperties;
   Result := FAddLink.Save;
 end;
 
end;

procedure TAddLink.SetLinkProperties;
var
 lineNo : integer;
begin
 FAddLink := fLink.Add;

 with fAddLink do
 begin
  lkDate := '21/07/2011';
  lkTime := '00:00:00';
  lkUser := 'Manager';
  lkFileName := 'C:\link.docx';
  lkDescription := 'Description';
  lkObjectType := 0;

  case fExpectedResult of
   30000 : lkFileName := '';
   30005 : lkDate := 'hello';
   30006 : lkTime := '33:33:33';
   30007 : lkObjectType := 99;
  end;
 end;

end;

function TAddCustomerLink.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Customer as IAccount2 do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('ABAP01');
    result := GetEqual(searchKey);

    fLink := acLinks;
  end;
end;

function TAddTransactionLink.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Transaction as ITransaction2 do
  begin
   Index := acIdxCode;
   searchKey := 'SIN008255';
   result := GetEqual(searchKey);


   fLink := thLinks;
  end;
end;

function TAddStockLink.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Stock as IStock2 do
  begin
   Index := acIdxCode;
   searchKey := BuildCodeIndex('BAT-1.5AA-ALK');
   result := GetEqual(searchKey);

   fLink := stLinks;
  end;
end;

function TAddJobLink.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.JobCosting.Job as IJob2 do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('BRID - PH1');
    result := GetEqual(searchKey);

    fLink := jrLinks;
  end;
end;

function TAddEmployeeLink.FindParentInterface;
begin
  with fToolkit.JobCosting.Employee as IEmployee2 do
  begin
   result := GetFirst;

   fLink := emLinks;
  end;
end;

function TAddSupplierLink.FindParentInterface;
var
 searchKey : string;
begin
  with fToolkit.Supplier as IAccount2 do
  begin
    Index := acIdxCode;
    searchKey := BuildCodeIndex('ACEE02');
    result := GetEqual(searchKey);

    fLink := acLinks;
  end;
end;

end.
