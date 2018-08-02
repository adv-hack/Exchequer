unit AltStockCodeTestF;

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
  AddAltStockCode;

{$R *.dfm}

procedure TfrmTestTemplate1.RunTest;
var
  fAddAltStockCode : TAddAltStockCode;
  searchKey : shortstring;
  funcRes, param : longint;
  docType : shortint;
begin
   SplitExtraParam;
   docType := StrToInt(FExtraParamList[0]);
   param := StrToInt(FExtraParamList[1]);

   fAddAltStockCode := GetAltStockCodeObject(DocType);

   {Ignored Errors: }

   if(Assigned(fAddAltStockCode)) then
   begin
     Try
       fAddAltStockCode.toolkit := oToolkit;
       fAddAltStockCode.ExpectedResult := param;

       fResult := fAddAltStockCode.SaveAltStockCode;
     Finally
       fAddAltStockCode.Free;
     End;
   end
   else
     FResult := -1;
end;

end.
