unit LocationTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb, StrUtils;

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

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
  case StrToInt(FExtraParam) of
    30006 : oToolkit.Configuration.DefaultNominalCode := 2;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
var
  locationItem : ILocation2;
  searchKey : shortstring;
  funcRes : longint;
  param : longint;
  mode : string;
begin
   mode := LeftStr(FExtraParam,1);
   param := StrToInt(RightStr(FExtraParam,6));


   with oToolkit.Location do
   begin
      Index := acIdxCode;
      searchKey := BuildCodeIndex('AAA');
      funcRes := GetEqual(searchKey);

      {Ignored Errors: }

       if(StrToInt(FExtraParam) = 5) or (StrToInt(FExtraParam) = 30271) or (StrToInt(FExtraParam) = 30003) then
         locationItem := Add as ILocation2
        else
         locationItem := Update as ILocation2;

        if(Assigned(locationItem)) then
        begin
             with locationItem do
             begin
                case StrToInt(FExtraParam) of
                       5 : loCode := 'AAA';
                   30271 : loCode := '';
                   30273 : loCostCentre  := 'NotACostCenter';
                   30274 : loDepartment := 'NotADepartment';
                   30275 : begin
                            loCode := 'lkh';
                           end;
                   30276 : loSalesReturnGL  := 897897;
                   30277 : loPurchaseReturnGL  := 897897;
                end;

               fResult := locationItem.Save;
             end;
        end;
   end;
end;

end.
