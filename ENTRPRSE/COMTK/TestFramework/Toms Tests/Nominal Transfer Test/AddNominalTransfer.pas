unit AddNominalTransfer;

interface
 uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, strutils;

type TAddNominalTransfer = Class
 protected
  fNominalTransfer : ITransaction;
  fToolkit : IToolKit;
  fExpectedResult : Integer;
 public
  property toolkit : IToolKit read fToolkit write fToolkit;
  property ExpectedResult : Integer read fExpectedResult write fExpectedResult;
  function SaveNominalTransfer : integer; virtual;
 end;

function GetNominalTransferObject : TAddNominalTransfer;

implementation

function GetNominalTransferObject : TAddNominalTransfer;
begin
 Result := TAddNominalTransfer.Create;
end;

function TAddNominalTransfer.SaveNominalTransfer : integer;
var
 tempToolKit : IToolKit3;
begin
  tempToolKit := fToolKit as IToolKit3;
  fNominalTransfer := fToolkit.Transaction.Add(dtNMT);

    With fNominalTransfer Do Begin

    ImportDefaults;
    thAcCode := 'ABAP01';
    
    With thLines.Add Do Begin
      tlDescr := 'Debit';
      tlGLCode := 10010;
      tlCurrency := 0;
      tlDailyRate := 1;
      tlNetValue := 1337;
      tlCompanyRate := 1;

      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';

      Save;
    End;
    With thLines.Add Do Begin
      tlDescr := 'Credit';
      tlGLCode := 34010;
      tlCurrency := 0;
      tlDailyRate := 1;
      tlNetValue := -1337;
      
      tlCompanyRate := 1;
      tlCostCentre := 'AAA';
      tlDepartment := 'AAA';

      if fExpectedResult = 30121 then
        tlNetValue := -1278;

      Save;
    End;

    Result := Save(True);
  End;
  fNominalTransfer := Nil;
end;

end.
