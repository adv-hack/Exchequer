unit LinkTestF;

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
 AddLink;

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin

end;

procedure TfrmTestTemplate1.RunTest;
var
  fAddLink : TAddLink;
  searchKey : shortstring;
  funcRes, param : longint;
  DocType : shortint;
begin
   SplitExtraParam;
   DocType := StrToInt(FExtraParamList[0]);
   param := StrToInt(FExtraParamList[1]);

   fAddLink := GetLinkObject(DocType);

   if(Assigned(fAddLink)) then
   begin
     Try
     fAddLink.toolkit := oToolkit;
     fAddLink.ExpectedResult := param;

     fResult := fAddLink.SaveLink;
     Finally
       fAddLink.Free;
     End;
   end
   else
     FResult := -1;
end;

end.
