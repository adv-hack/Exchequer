unit db_accss;

interface

uses
  SysUtils, Classes, DB, KDaoTable, KDaoDataBase, bbmconst;

type
  Tdm1 = class(TDataModule)
    DetailsDBase: TKADaoDatabase;
    DetailsTable: TKADaoTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ErrorCode : Integer;
    function GetString(const FName : ShortString) : ShortString;
    function SelectRecord(const Code : ShortString) : Boolean;
    function InitialiseTable(Dbase, TabName : ShortString) : Boolean;
  end;

var
  dm1: Tdm1;

implementation

{$R *.dfm}
uses
  Variants;

  function DllInitialiseTable(const DbaseName : ShortString;
                           const TableName : ShortString) : Boolean; External 'bbm_odbc.dll';
  function DllGetString(const FName : ShortString) : ShortString; External 'bbm_odbc.dll';
  function DllSelectRecord(const Code : ShortString) : Boolean; External  'bbm_odbc.dll';


function TDm1.InitialiseTable(Dbase, TabName : ShortString) : Boolean;
begin
{$IFDEF DIRECT}
  Try
    DetailsDbase.Database := DBase;
    DetailsDbase.Connected := True;
    Result := True;
  Except
    ErrorCode := 101;
    Result := False;
  End;

  if Result then
  Try
    DetailsTable.TableName := TabName;
    DetailsTable.IndexFieldNames := AccessKeyField;
    DetailsTable.Active := True;
    Result := True;
  Except
    ErrorCode := 102;
    Result := False;
  End;
{$ELSE}
  Result := DllInitialiseTable(DBase, TabName);
{$ENDIF}
end;

function TDm1.GetString(const FName : ShortString) : ShortString;
begin
{$IFDEF DIRECT}
  Result := '';
  if VarIsNull(DetailsTable.FieldByName(FName).Value) then
    Result := ''
  else
    Result := DetailsTable.FieldByName(FName).Value;

  if FName = detBankAdd3 then
    Result := '';
{$ELSE}
  Result := DllGetString(FName);
{$ENDIF}

end;

function TDm1.SelectRecord(const Code : ShortString) : Boolean;
var
  i : integer;
  s : string;
begin
{$IFDEF DIRECT}
  //Locate doesn't seem to work in ODBC so use BFI
  DetailsTable.First;
  while (Trim(DetailsTable.FieldByName(AccessKeyField).Value) <> Code) and
        not DetailsTable.eof do
           DetailsTable.Next;

  Result := not DetailsTable.eof;

{$ELSE}
  Result := DllSelectRecord(Code);
{$ENDIF}
end;


procedure Tdm1.DataModuleCreate(Sender: TObject);
begin
  ErrorCode := 0;
end;

end.
