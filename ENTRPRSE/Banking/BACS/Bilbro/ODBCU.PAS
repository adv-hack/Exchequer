unit odbcu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, mQuery, mTable, mDataBas;

type
  Tdm1 = class(TDataModule)
    db1: TmDataBase;
    tab1: TmTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function DllInitialiseTable(const DbaseName : ShortString;
                           const TableName : ShortString) : Boolean; Export;
  function DllGetString(const FName : ShortString) : ShortString; Export;
  function DllSelectRecord(const Code : ShortString) : Boolean; Export;
var
  dm1: Tdm1;

implementation

uses
  BbmConst;

{$R *.DFM}

function DllInitialiseTable(const DbaseName : ShortString;
                         const TableName : ShortString) : Boolean;
begin
  Dm1 := TDm1.Create(nil);
  Try
    Dm1.db1.DataBaseName := DBaseName;
    Dm1.tab1.TableName := TableName;
    Dm1.tab1.IndexFieldNames := AccessKeyField;
    Dm1.tab1.Active := True;
    Result := True;
  Except
    Result := False;
  End;
end;

function DllGetString(const FName : ShortString) : ShortString;
begin
  Result := '';
  if VarIsNull(Dm1.Tab1.FieldByName(FName).Value) then
    Result := ''
  else
    Result := Dm1.Tab1.FieldByName(FName).Value;

  if FName = detBankAdd3 then
    Result := '';

  Result := Trim(Result);
end;

function DllSelectRecord(const Code : ShortString) : Boolean;
var
  s : String;
begin
{Need to allow for the fact that KeyRec may be padded out by default}
  Result := Dm1.Tab1.Locate(AccessKeyField, Code, [loPartialKey]);
  s := Trim(Dm1.Tab1.FieldByName(AccessKeyField).Value);
  Result := Result and (s = Trim(Code));

end;

end.
