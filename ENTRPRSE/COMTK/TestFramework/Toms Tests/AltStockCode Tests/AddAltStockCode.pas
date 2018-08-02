unit AddAltStockCode;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;
type

  TAddAltStockCode = Class
  protected
    fAltStockCode, FAddAltStockCode : IAltStockCode;
    fToolkit : IToolKit;
    fExpectedResult : Integer;
    procedure SetDefaultProperties;
    procedure SetProperties; virtual;
    function FindParentInterface : Integer; virtual;
  public
    property toolkit : IToolKit read fToolkit write fToolkit;
    property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
    function SaveAltStockCode : integer; virtual;
  end;

  TAddStockAltStockCode = class(TAddAltStockCode)
  protected
    procedure SetProperties; override;
    function FindParentInterface : integer; override;
  end;

  TAddEquivalentCode = class(TAddAltStockCode)
  protected
    function FindParentInterface : integer; override;
  end;

  TAddOpportunityCode = class(TAddAltStockCode)
  protected
    function FindParentInterface : integer; override;
  end;

  TAddSuperSededByCode = class(TAddAltStockCode)
  protected
    function FindParentInterface : integer; override;
  end;


  function GetAltStockCodeObject(docType : Integer) : TAddAltStockCode;

implementation

function GetAltStockCodeObject(docType : Integer) : TAddAltStockCode;
begin
  Case docType of
    0 : Result := TAddStockAltStockCode.Create;
    1 : Result := TAddEquivalentCode.Create;
    2 : Result := TAddOpportunityCode.Create;
    3 : Result := TAddSuperSededByCode.Create;
  else
    Result := nil;
  end;
end;

function TAddAltStockCode.FindParentInterface: Integer;
begin
  with fToolkit.Stock as IStock3 do
  begin
    Index := acIdxCode;

    result := GetEqual(BuildCodeIndex('BAT-1.5AA-ALK'));
  end;
end;

function TAddAltStockCode.SaveAltStockCode : integer;
begin
  Result := FindParentInterface;

  if Result = 0 then
  begin
    SetDefaultProperties;
    SetProperties;
    Result := FAddAltStockCode.Save;
  end;
end;

procedure TAddAltStockCode.SetDefaultProperties;
begin
  FAddAltStockCode := fAltStockCode.Add;

  with fAddAltStockCode do
  begin
    ascAcCode := 'FARN01';
    ascAltCode := '';
    ascAltDesc := 'AA Standard Battery Pack';
    ascReorderPrice := 1337;
    ascReorderCurrency := 1;
    ascUseReorderPrice := false;
  end;
end;

function TAddStockAltStockCode.FindParentInterface;
begin
  Result := inherited FindParentInterface;

  if Result = 0 then
    fAltStockCode := (fToolkit.Stock as IStock3).stAltStockCode;
end;


function TAddEquivalentCode.FindParentInterface;
begin
  Result := inherited FindParentInterface;

  if Result = 0 then
    fAltStockCode := (fToolkit.Stock as IStock3).stEquivalent;
end;


function TAddOpportunityCode.FindParentInterface;
begin
  Result := inherited FindParentInterface;

  if Result = 0 then
    fAltStockCode := (fToolkit.Stock as IStock3).stOpportunity;
end;


function TAddSuperSededByCode.FindParentInterface;
begin
  Result := inherited FindParentInterface;

  if Result = 0 then
    fAltStockCode := (fToolkit.Stock as IStock3).stSupersededBy;
end;

procedure TAddAltStockCode.SetProperties;
begin
 with fAddAltStockCode do
 begin
   case fExpectedResult of
     0     : ascAltCode := '889-909-99999';
     5     : ascAltCode := '889-909-999';
     30002 : ascAcCode := 'NotARealCode';
     30007 : ascAltCode := '??';
   end;
 end;
end;

procedure TAddStockAltStockCode.SetProperties;
begin
 with fAddAltStockCode do
 begin
   case fExpectedResult of
     0     : ascAltCode := 'AltStCode_' + ClassName[5]; //diffentiate using 5th char of class name - 'E', 'O', 'S'.
     5     : ascAltCode := '889-909-999';
     30002 : ascAcCode := 'NotARealCode';
   end;
 end;
end;

end.
