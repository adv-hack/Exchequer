unit MBDiscountTestF;

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
 AddMBDiscount;

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin

end;

procedure TfrmTestTemplate1.RunTest;
var
  fAddMBDiscount : TAddMBDiscount;
  searchKey : shortstring;
  funcRes, param : longint;
  DocType : shortint;
begin
   SplitExtraParam;
   DocType := StrToInt(FExtraParamList[0]);
   param := StrToInt(FExtraParamList[1]);

   fAddMBDiscount := GetMBDiscountObject(DocType);

   {Ignored Errors: 30002 30007 30009}

   if(Assigned(fAddMBDiscount)) then
   begin
     Try
     fAddMBDiscount.toolkit := oToolkit;
     fAddMBDiscount.ExpectedResult := param;

     fResult := fAddMBDiscount.SaveMBDiscount;
     Finally
       fAddMBDiscount.Free;
     End;
   end
   else
     FResult := -1;
end;

end.
