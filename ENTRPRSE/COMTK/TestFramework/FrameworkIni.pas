unit FrameworkIni;

interface

uses
  IniFiles;

const
  LIST_NAME = 0;
  TEST_DB = 1;
  TEST_CO = 2;
  REF_DB = 3;
  REF_CO = 4;
  RESULTS_FOLDER = 5;

type
  TFrameworkIniFile = Class
  private
    FItems : Array[LIST_NAME..RESULTS_FOLDER] of string;
    function GetItem(Index: Integer): string;
    procedure SetItem(Index: Integer; const Value: string);
  public
    Constructor Create;
    Destructor Destroy; override;
    property Items[Index : Integer] : string read GetItem write SetItem;
  end;

var
  oIniFile : TFrameworkIniFile;

implementation

{ TFrameworkIniFile }
uses
  SysUtils, TestConst;

constructor TFrameworkIniFile.Create;
begin
  inherited;
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + S_INI_FILE) do
  Try
    FItems[LIST_NAME]      := ReadString('Settings', 'LastFileName', '');
    FItems[TEST_DB]        := ReadString('Settings', 'TestDB', '');
    FItems[TEST_CO]        := ReadString('Settings', 'TestCo', '');
    FItems[REF_DB]         := ReadString('Settings', 'RefDB', '');
    FItems[REF_CO]         := ReadString('Settings', 'RefCo', '');
    FItems[RESULTS_FOLDER] := ReadString('Settings', 'ResultsFolder', '');
  Finally
    Free;
  End;

end;

destructor TFrameworkIniFile.Destroy;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + S_INI_FILE) do
  Try
    WriteString('Settings', 'LastFileName', FItems[LIST_NAME]);
    WriteString('Settings', 'TestDB', FItems[TEST_DB]);
    WriteString('Settings', 'TestCo', FItems[TEST_CO]);
    WriteString('Settings', 'RefDB', FItems[REF_DB]);
    WriteString('Settings', 'RefCo', FItems[REF_CO]);
    WriteString('Settings', 'ResultsFolder', FItems[RESULTS_FOLDER]);
  Finally
    Free;
    inherited;
  End;

end;

function TFrameworkIniFile.GetItem(Index: Integer): string;
begin
  Result := FItems[Index];
end;

procedure TFrameworkIniFile.SetItem(Index: Integer; const Value: string);
begin
  FItems[Index] := Value;
end;

Initialization
  oIniFile := TFrameworkIniFile.Create;

Finalization
  oIniFile.Free;
end.
