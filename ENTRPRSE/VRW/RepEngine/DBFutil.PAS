unit dbfutil;

interface

uses
  EnterpriseDBF_TLB, Classes;

//  procedure CreateDBFComObject;
  procedure StartDBF(const FName : String);
  procedure CreateDBFLists;
  procedure FreeDBFLists(const DBFObj : IDBFWriter);

var
  WantNewDBF : Boolean;
  DbfList : TStringList;
  DbfFieldList : TSTringList;
  NameList : TStringList;
  HasIndex : Boolean;

implementation

uses
  ComObj, Windows;

//procedure CreateDBFComObject;
//begin
//  oDBF := CreateOLEObject('EnterpriseDBF.DBFWriter') as IDBFWriter;
//end;

procedure StartDBF(const FName : String);
begin
//  oDBF.Filename := FName;
end;

procedure CreateDBFLists;
begin
  DbfList := TStringList.Create;
  DbfFieldList := TStringList.Create;
  NameList := TStringList.Create;
end;

procedure FreeDBFLists(const DBFObj : IDBFWriter);
var
  DefStr : String;
  i, j : integer;
begin

  for i := 0 to DbfFieldList.Count - 1 do
  begin
    j := Integer(DbfFieldList.Objects[i]);
    if j > 0 then
    begin
      DefStr := DbfFieldList[i];
      DBFObj.AddIndex(Copy(DefStr, 1, Pos(';', DefStr) - 1), j = 2);
    end;
  end;

  DBFObj.CloseFile;
  DbfList.Free;
  DbfFieldList.Free;
end;

initialization

  HasIndex := False;

end.
