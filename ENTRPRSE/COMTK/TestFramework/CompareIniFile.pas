unit CompareIniFile;

interface

uses
  Classes;

const
  C_INI_FILENAME = 'ExcludeFromCompare.ini';


type
  TCompareIniFile = Class
  private
    FExceptList : TStringList;
    FTableName : string;
  public
    constructor Create;
    destructor Destroy; override;
    function Read : Boolean;
    function Ignore(const AFieldName : string) : Boolean;
    property TableName : string read FTableName write FTableName;
  end;

implementation

uses
  SysUtils, IniFiles;

{ TCompareIniFile }

constructor TCompareIniFile.Create;
begin
  inherited;
  FExceptList := TStringList.Create;
end;

destructor TCompareIniFile.Destroy;
begin
  if Assigned(FExceptList) then
    FExceptList.Free;
  inherited;
end;

function TCompareIniFile.Ignore(const AFieldName: string): Boolean;
begin
  Result := FExceptList.IndexOf(Trim(UpperCase(AFieldName))) >= 0;
  if not Result then
    Result := UpperCase(Trim(AFieldName)) = 'POSITIONID';
end;

function TCompareIniFile.Read: Boolean;
var
  AFile : TIniFile;
  i : integer;
begin
  Result := True;
  AFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + C_INI_FILENAME);
  with AFile do
  Try
    Try
      ReadSection(FTableName, FExceptList);
      for i := 0 to FExceptList.Count - 1 do
        FExceptList[i] := UpperCase(Trim(FExceptList[i]));
    Except
      on E: Exception do
      begin
        Result := False;
        raise;
      end;
    End;
  Finally
    Free;
  End;

end;

end.
