unit NoteTestF;

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
 AddNote;

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin

end;

procedure TfrmTestTemplate1.RunTest;
var
  fAddNote : TAddNote;
  searchKey : shortstring;
  funcRes, param : longint;
  DocType, NType : shortint;
begin
   SplitExtraParam;
   DocType := StrToInt(FExtraParamList[0]);
   param := StrToInt(FExtraParamList[1]);
   NType := StrToInt(FExtraParamList[2]);

   fAddNote := GetNoteObject(DocType);

   if(Assigned(fAddNote)) then
   begin
     Try
     fAddNote.toolkit := oToolkit;
     fAddNote.NoteType := NType;
     fAddNote.ExpectedResult := param;

     fResult := fAddNote.SaveNote;
     Finally
       fAddNote.Free;
     End;
   end
   else
     FResult := -1;
end;

end.
