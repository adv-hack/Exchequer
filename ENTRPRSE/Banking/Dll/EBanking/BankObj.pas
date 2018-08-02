unit BankObj;

interface

uses
  Classes, VarRec2U, Enterprise01_TLB, ComObj;

Type

  TBankObject = Class
  private
    oToolkit : IToolkit3;
  public
    constructor Create;
    destructor Destroy;
  end;

implementation

{ TBankObject }

constructor TBankObject.Create;
begin

end;

destructor TBankObject.Destroy;
begin

end;

end.
