unit AddBankStatement;

interface
 uses enterprise04_tlb;

type TAddBankStatement = Class
 protected
  fBankStatement : IBankStatement;
  fToolkit : IToolKit;
  fExpectedResult, fDocType : Integer;
  procedure SetBankStatementProperties;
  function FindParentInterface : Integer; virtual; abstract;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveBankStatement : integer; virtual;
 end;

type TAddBankStatementAccount = class(TAddBankStatement)
public
 function FindParentInterface : integer; override;
end;

function GetBankStatementObject(docType : Integer) : TAddBankStatement;

implementation

function GetBankStatementObject(docType : Integer) : TAddBankStatement;
begin
  Case docType of
    0 : Result := TAddBankStatementAccount.Create;
    else
        Result := nil;
  end;
end;

function TAddBankStatement.SaveBankStatement : integer;
var
 tempToolKit : IToolKit3;
begin
  tempToolKit := fToolKit as IToolKit3;

  with tempToolKit.Banking.BankAccount.baStatement do
  begin
    fBankStatement := Add;
  end;

  if (Assigned(fBankStatement)) then
  begin
     SetBankStatementProperties;
     Result := fBankStatement.Save;
  end;
end;

procedure TAddBankStatement.SetBankStatementProperties;
begin

 with fBankStatement do
 begin
  bsDate := '22/07/2011';
  bsReference := 'REF1337';
  bsStatus := 0;

  case ExpectedResult of
    30000 : bsDate := 'BadDate';
  end;
  
 end;
end;

function TAddBankStatementAccount.FindParentInterface;
begin

end;

end.
