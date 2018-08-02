unit BankStatementTestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation
uses
 AddBankStatement;

{$R *.dfm}

procedure TfrmTestTemplate1.RunTest;
var
  fAddBankStatement : TAddBankStatement;
  param : longint;
begin
   SplitExtraParam;
   param := StrToInt(FExtraParamList[0]);
   fAddBankStatement := GetBankObject;
   fResult := -1;
   {Ignored Errors:}

   if(Assigned(fAddBankStatement)) then
   begin
     try
       fAddBankStatement.toolkit := oToolkit;
       fAddBankStatement.ExpectedResult := param;

       fResult := fAddBankStatement.SaveBankStatement;
     finally
       fAddBankStatement.Free;
     end;
   end
   else
     fResult := -1;
end;
end.
