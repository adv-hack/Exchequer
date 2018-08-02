unit oBanking;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, MiscFunc, oBankAcc,
     ExceptIntf;

type
  TBankProducts = class(TAutoIntfObjectEx, IBankProducts)
  protected
    function Get_bpCount: Integer; safecall;
    function Get_bpName(Index: Integer): WideString; safecall;
    function Get_bpStatementFormat(Index: Integer): WideString; safecall;
  end;

  TBanking = class(TAutoIntfObjectEx, IBanking)
  private
    FBankAccO : TBankAccount;
    FBankAccI : IBankAccount;

    FProductsO : TBankProducts;
    FProductsI : IBankProducts;

    FToolkit  : TObject;
    function Get_BankProductCount: Integer;
  protected
   function Get_BankAccount: IBankAccount; safecall;
   function Get_BankProducts: IBankProducts; safecall;
   procedure InitObjects;
  public
   constructor Create(const Toolkit : TObject);
   destructor Destroy; override;
  end;



implementation

uses
  ComServ;

{ TBanking }

constructor TBanking.Create(const Toolkit: TObject);
begin
  Inherited Create (ComServer.TypeLib, IBanking);

  // ensure all sub-objects initialised correctly
  InitObjects;

  // record handle to Toolkit object
  FToolkit := Toolkit;
end;

destructor TBanking.Destroy;
begin
  InitObjects;
  inherited;
end;

function TBanking.Get_BankAccount: IBankAccount;
begin
  if not Assigned(FBankAccO) then
  begin
    FBankAccO := CreateTBankAccount (FToolkit, 49);

    FBankAccI := FBankAccO;
  end;

  Result := FBankAccI;

end;

function TBanking.Get_BankProductCount: Integer;
begin
  Result := GetBankProductCount;
end;

function TBanking.Get_BankProducts: IBankProducts;
begin
  if not Assigned(FProductsO) then
  begin
    FProductsO := TBankProducts.Create(ComServer.TypeLib, IBankProducts);

    FProductsI := FProductsO;
  end;

  Result := FProductsI;
end;

procedure TBanking.InitObjects;
begin
  FBankAccO := nil;
  FBankAccI := nil;
end;


{ TBankProducts }

function TBankProducts.Get_bpCount: Integer;
begin
  Result := GetBankProductCount;
end;

function TBankProducts.Get_bpName(Index: Integer): WideString;
var
  ProdName, PayFile, RecFile : ShortString;
begin
  if Index > 0 then
  begin
    if BankProduct(Index, ProdName, PayFile, RecFile) then
      Result := Trim(ProdName)
    else
      raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
  end
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

function TBankProducts.Get_bpStatementFormat(Index: Integer): WideString;
begin
  Result := BankStatementFormat(Index);
end;

end.
