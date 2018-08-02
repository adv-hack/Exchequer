unit BankTestF;

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
    procedure ChangeToolkitSettings; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation
uses
 AddBank, AddBankStatement;

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin

end;
procedure TfrmTestTemplate1.RunTest;
var
  fAddBank : TAddBank;
  param : longint;
begin
   SplitExtraParam;
   param := StrToInt(FExtraParamList[0]);

   fAddBank := GetBankObject;

   {Ignored Errors:}

   if(Assigned(fAddBank)) then
   begin
     try
       fAddBank.toolkit := oToolkit;
       fAddBank.ExpectedResult := param;

       fResult := fAddBank.SaveBankAccount;
     finally
       fAddBank.Free;
     end;
   end
   else
     fResult := -1;
end;
end.
