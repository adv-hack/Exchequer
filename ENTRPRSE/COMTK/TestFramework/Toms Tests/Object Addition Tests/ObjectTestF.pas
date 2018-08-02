unit ObjectTestF;

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
 AddObject;

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin

end;

procedure TfrmTestTemplate1.RunTest;
var
  fAddObject : TAddObject;
  objType : longint;
  iniPath : string;
begin
  SplitExtraParam;
  objType := StrToInt(FExtraParamList[0]);
  iniPath := FExtraParamList[1];

  fAddObject := GetObjectType(objType);

  if(Assigned(fAddObject)) then
  begin
    try
      fAddObject.ObjType := objType;
      fAddObject.INIPath := iniPath;
      fAddObject.toolkit := oToolkit;

      fResult := fAddObject.SaveObject;
    finally
      fAddObject.Free;
    end;
  end
  else
    FResult := -1;
end;

end.
