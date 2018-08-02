unit AddBankStatement;

interface
 uses enterprise04_tlb;

type TAddBankStatement = Class
 protected
  fBank, FAddBankStatement : IBanking;
  fBankAcc : IBankAccount;
  fToolkit : IToolKit;
  fExpectedResult, fDocType : Integer;
  procedure SetBankProperties;
  function FindParentInterface : Integer; virtual; abstract;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveBank : integer; virtual;
 end;

type TAddBankStatementAccount = class(TAddBankStatement)
public
 function FindParentInterface : integer; override;
end;

function GetBankObject(docType : Integer) : TAddBankStatement;

implementation

function GetBankObject(docType : Integer) : TAddBankStatement;
begin
  Case docType of
    0 : Result := TAddBankStatementAccount.Create;
    else
        Result := nil;
  end;
end;

function TAddBankStatement.SaveBank : integer;
var
 tempToolKit : IToolKit3;
begin
  tempToolKit := fToolKit as IToolKit3;

  fAddBank := GetBankObject(DocType);

  with tempToolKit.Banking do
  begin
    fBankAcc := BankAccount.Add;
  end;
  
  if (Assigned(fBankAcc)) then
  begin
   SetBankProperties;
   Result := fBankAcc.Save;
  end;
end;

procedure TAddBankStatement.SetBankProperties;
begin

 with fBankAcc do
 begin
  baGLCode := 10010;
  baProduct := 1;
  baOutputPath := 'C:\';
  baPayFileName := '';
  baRecFileName := '';
  baStatementPath := 'C:\';
  baSortCode := '00-13-37';
  baAccountNo := '133707331';
  baUserID := '1234';
  baReference := '4321';
  baLastDate := '01/01/1901';
  baOutputCurrency := 1;

  case ExpectedResult of
    30000 : baGLCode := -1;
    30001 : baProduct := 99;
  end;
 end;
end;

function TAddBankStatementAccount.FindParentInterface;
begin

end;

end.
