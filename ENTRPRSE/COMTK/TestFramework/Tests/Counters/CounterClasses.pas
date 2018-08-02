unit CounterClasses;

interface

uses
  EnterpriseBeta_TLB, Enterprise04_TLB, BaseCounterClasses;

Type

  TCustomerCounter = Class(TRecordCounter)
  public
    function Execute : Boolean; override;
  end;

  TSupplierCounter = Class(TRecordCounter)
  public
    function Execute : Boolean; override;
  end;

  TStockGroupCounter = Class(TRecordCounter)
  protected
    function IncludeRecord : Boolean; override;
  public
    function Execute : Boolean; override;
  end;


implementation

{ TCustomerCounter }

function TCustomerCounter.Execute: Boolean;
begin
  FDatabaseFunctions := FToolkit.Customer as IDatabaseFunctions;
  Result := inherited Execute;
end;


{ TSupplierCounter }

function TSupplierCounter.Execute: Boolean;
begin
  FDatabaseFunctions := FToolkit.Supplier as IDatabaseFunctions;
  Result := inherited Execute;
end;

{ TStockGroupCounter }

function TStockGroupCounter.IncludeRecord: Boolean;
begin
  Result := (FDatabaseFunctions as IStock).stType = stTypeGroup;
end;

function TStockGroupCounter.Execute: Boolean;
begin
  FDatabaseFunctions := FToolkit.Stock as IDatabaseFunctions;
  Result := inherited Execute;
end;

end.
