unit AddBank;

interface
 uses enterprise04_tlb;

type TAddBank = Class
 protected
  fBankAcc : IBankAccount;
  fToolkit : IToolKit;
  fExpectedResult : Integer;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveBankAccount : integer; virtual;
 end;

function GetBankObject : TAddBank;

implementation

function GetBankObject : TAddBank;
begin
  Result := TAddBank.Create;
end;

function TAddBank.SaveBankAccount : integer;
var
 tempToolKit : IToolKit3;
begin
 tempToolKit := fToolKit as IToolKit3;

 with tempToolKit.Banking do
 begin
   fBankAcc := BankAccount.Add;
   with fBankAcc do
   begin
     baAccountNo := '133717331';
     baLastDate := '2011/01/01';
     baStatementPath := 'C:\';
     baSortCode := '013370';
     baOutputPath := 'C:\';
     baReference := '4321';
     baOutputCurrency := 1;
     baPayFileName := '';
     baRecFileName := '';
     baUserID := '1234';
     baGLCode := 10010;
     baProduct := 1;

     case ExpectedResult of
       30000 : baGLCode := -1;
       30001 : baProduct := 999;
     end;
     Result := fBankAcc.Save;
   end;
  end;
end;
end.
