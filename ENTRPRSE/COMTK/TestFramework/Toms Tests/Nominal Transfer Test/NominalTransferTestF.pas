unit NominalTransferTestF;

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
 AddNominalTransfer;

{$R *.dfm}

procedure TfrmTestTemplate1.RunTest;
var
  fAddNominalTransfer : TAddNominalTransfer;
  param : longint;
begin
   SplitExtraParam;
   param := StrToInt(FExtraParamList[0]);
   fAddNominalTransfer := GetNominalTransferObject;
   fResult := -1;
   {Ignored Errors:}

   if(Assigned(fAddNominalTransfer)) then
   begin
     try
       fAddNominalTransfer.toolkit := oToolkit;
       fAddNominalTransfer.ExpectedResult := param;

       fResult := fAddNominalTransfer.SaveNominalTransfer;
     finally
       fAddNominalTransfer.Free;
     end;
   end
   else
     fResult := -1;
end;
end.
