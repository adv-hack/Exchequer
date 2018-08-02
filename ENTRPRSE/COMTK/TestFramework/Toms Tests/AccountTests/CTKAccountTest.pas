unit CTKAccountTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb;

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
 strUtils;
{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
  case StrToInt(FExtraParam) of
    30006 : oToolkit.Configuration.DefaultNominalCode := 2;
    30014 : oToolkit.Configuration.DefaultVATCode := 'I';
  end;
end;

procedure TfrmTestTemplate1.RunTest;
var
  cust : IAccount2;
  searchKey : shortstring;
  funcRes : longint;
begin
   with oToolkit.Customer do
   begin
      Index := acIdxCode;
      searchKey := BuildCodeIndex('ABAP01');
      funcRes := GetEqual(searchKey);

      {Ignored Errors : 30016}

      if(StrToInt(FExtraParam) = 30003) or (StrToInt(FExtraParam) = 5) then
       cust := Add as IAccount2
      else
       cust := Update as IAccount2;

      if(Assigned(cust)) then
      begin
        with cust do
        begin
           case StrToInt(FExtraParam) of
                 5 : acCode := 'ABAP01';
             30003 : acCode := '';
             30004 : acPayType := '?';
             30005 : acVATCode := '?';
             30006 : acSalesGL := 2;
             30008 : acCOSGL := -1;
             30009 : acDrCrGL := -1;
             30010 : acLocation := 'NotALocation';
             30011 : acInvoiceTo := '!';
             30012 : acStatementTo := '!';
             30013 : acSSDDeliveryTerms := 'fixme';
             30014 : acInclusiveVATCode := 'M';
             30015 : acStateDeliveryMode := 99;
             30017 : acDefSettleDays := 1000;
             30018 : acDepartment := 'NotADepartment';
          end;


         fResult := cust.Save;
        end;
      end;
   end;
end;
end.
