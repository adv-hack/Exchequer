unit AddBankStatement;

interface
 uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;

type TAddBankStatement = Class
 protected
  fBankStatement : IBankStatement;
  fToolkit : IToolKit;
  fExpectedResult : Integer;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveBankStatement : integer; virtual;
 end;

function GetBankObject : TAddBankStatement;

implementation

function GetBankObject : TAddBankStatement;
begin
 Result := TAddBankStatement.Create;
end;

function TAddBankStatement.SaveBankStatement : integer;
var
 tempToolKit : IToolKit3;
 funcRes : longint;
 statementLine : IBankStatementLine;
begin
  tempToolKit := fToolKit as IToolKit3;

  with tempToolKit.Banking do
  begin
   funcRes := BankAccount.GetEqual(BankAccount.BuildGLCodeIndex(10010));

   with tempToolKit.Banking.BankAccount.baStatement do
   begin

    fBankStatement := add;

    with fBankStatement do
    begin
      bsReference := 'Reference';
      bsDate := '20110812';
      bsStatus := bssOpen;

      if ExpectedResult = 30000 then
        bsDate := 'l;kl;kl;k';

      statementLine := bsStatementLine.Add;
      with statementLine do
      begin
       bslReference := 'Reference1';
       bslReference2 := 'Reference2';
       bslLineDate := '20110812';
       bslStatus := bslsOpen;
       bslValue := 10;

       if ExpectedResult = 300001 then
         bslLineDate := 'l;kl;kl;k';

       funcRes := statementLine.Save;
      end;
    end;

    if funcRes = 0 then
     Result := fBankStatement.Save
    else
     Result := funcRes;
   end;
  end;
end;
end.
