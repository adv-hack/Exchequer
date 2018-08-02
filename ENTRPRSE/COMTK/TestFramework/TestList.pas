unit TestList;

interface

uses
  Classes, Contnrs, TestConst;


type
  TTest = Class
  private
    FData : TStringList;
    function GetAppName: string;
    function GetCompareResult: Boolean;
    function GetData: string;
    function GetExpectedResult: longint;
    function GetTestName: string;
    function GetWantToRun: Boolean;
    procedure SetAppName(const Value: string);
    procedure SetCompareResult(const Value: Boolean);
    procedure SetData(const Value: string);
    procedure SetExpectedResult(const Value: longint);
    procedure SetTestName(const Value: string);
    procedure SetWantToRun(const Value: Boolean);

    function GetField(WhichField : Integer) : string;
    procedure SetField(WhichField : Integer; const Value : string);
    function GetCompareDB: Boolean;
    procedure SetCompareDB(const Value: Boolean);
    function GetExtraParam: string;
    procedure SetExtraParam(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property WantToRun : Boolean read GetWantToRun write SetWantToRun;
    property TestName : string read GetTestName write SetTestName;
    property AppName : string read GetAppName write SetAppName;
    property CompareResult : Boolean read GetCompareResult write SetCompareResult;
    property ExpectedResult : longint read GetExpectedResult write SetExpectedResult;
    property CompareDB : Boolean read GetCompareDB write SetCompareDB;
    property ExtraParam : string read GetExtraParam write SetExtraParam;
    property Data : string read GetData write SetData;
  end;

  TTestList = Class
  private
    FList : TObjectList;
    FDataPath : string;
    FMessageHandle : THandle;
    FListName : string;
    FInvalidList : TStringList;
    function GetCount: Integer;
    function GetTest(Index: Integer): TTest;
    function GetListName: string;
    function GetLastListName : string;
    procedure SaveLastListName;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure Save;

    function RunTest(TestNo: Integer): Integer;
    function CheckTest(TestNo : Integer) : Boolean;
    function CheckList : Boolean;

    function Add : TTest;
    function Edit(Index : Integer) : TTest;
    procedure Delete(Index : Integer);
    procedure Clear;


    property Test[Index : Integer] : TTest read GetTest;
    property DataPath : string read FDataPath write FDataPath;
    property MessageHandle : THandle read FMessageHandle write FMessageHandle;
    property Count : Integer read GetCount;
    property ListName : string read GetListName write FListName;
    property InvalidList : TStringList read FInvalidList;
  end;

  function BoolToYN(Value : Boolean) : string;

implementation

uses
  ApiUtil, Windows, SysUtils, FrameworkIni;

function BoolToYN(Value : Boolean) : string;
begin
  if Value then
    Result := 'Y'
  else
    Result := 'N';
end;

function TTestList.Add: TTest;
begin
  Result := TTest.Create;
  FList.Add(Result);
end;

function TTestList.CheckList: Boolean;
var
  i : integer;
begin
  {$B+}
  FInvalidList.Clear;
  Result := True;
  for i := 0 to FList.Count - 1 do
    Result := Result and CheckTest(i);
  {B-}
end;

function TTestList.CheckTest(TestNo: Integer): Boolean;
begin
  Result := not (Test[TestNo].WantToRun) or FileExists(Test[TestNo].AppName);
  if not Result then
    FInvalidList.Add(Test[TestNo].AppName);
end;

procedure TTestList.Clear;
var
  i : integer;
begin
  for i := FList.Count - 1 downto 0 do
    FList.Delete(i);
  FListName := '';
end;

constructor TTestList.Create;
begin
  inherited;
  FList := TObjectList.Create;
  FInvalidList := TStringList.Create;
end;

procedure TTestList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TTestList.Destroy;
begin
  if Assigned(FList) then
    FList.Free;
  if Assigned(FInvalidList) then
    FInvalidList.Free;
  inherited;
end;

function TTestList.Edit(Index: Integer): TTest;
begin
  Result := FList[Index] as TTest;
end;

function TTestList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTestList.GetLastListName: string;
begin
  Result := oIniFile.Items[LIST_NAME];
end;

function TTestList.GetListName: string;
begin
  if Trim(FListName) <> '' then
    Result := FListName
  else
    Result := S_UNTITLED;
end;

function TTestList.GetTest(Index: Integer): TTest;
begin
  Result := FList[Index] as TTest;
end;

procedure TTestList.Load;
var
  i : integer;
  AList : TStringList;
  ATest : TTest;
begin
  FList.Clear;
  AList := TSTringList.Create;
  if Trim(FListname) = '' then
    FListName := GetLastListName;

  if FileExists(FListName) then
  Try
    AList.LoadFromFile(FListName);
    for i := 0 to AList.Count - 1 do
    begin
      ATest := TTest.Create;
      ATest.Data := AList[i];
      FList.Add(ATest);
    end;
  Finally
    AList.Free;
    SaveLastListName;
  End;
end;

function TTestList.RunTest(TestNo: Integer): Integer;
var
  sAppName : string;
  sTestName : string;
  ProcInf : PROCESS_INFORMATION;

  procedure GetAppAndTestName;
  begin
    sAppName := WinGetShortPathName(Test[TestNo].AppName);
    sTestName := Test[TestNo].TestName;
  end;

  function BuildCommandString : string;
  begin
    //Test app should expect parameters as MessageHandle TestName DataPath TestPositionInList
    Result := Format('%s %d "%s" %s %s', [sAppName, FMessageHandle, sTestName, FDataPath, Test[TestNo].ExtraParam]);
  end;

begin
  Result := 0;

  GetAppAndTestName;

  ProcInf := RunAppEx(BuildCommandString, False);
end;

procedure TTestList.Save;
var
  i : integer;
  AList : TStringList;
begin
  AList := TStringList.Create;
  Try
    for i := 0 to FList.Count - 1 do
      AList.Add(TTest(FList[i]).Data);
    if Trim(FListName) = '' then
      FListName := ExtractFilePath(ParamStr(0)) + S_LIST_NAME;
    AList.SaveToFile(FListName);
  Finally
    AList.Free;
    SaveLastListName;
  End;
end;

{ TTest }

constructor TTest.Create;
var
  i : integer;
begin
  inherited;
  FData := TStringList.Create;
  for i := 0 to LAST_FIELD do
    FData.Add(' ');
end;

destructor TTest.Destroy;
begin
  if Assigned(FData) then
    FData.Free;
  inherited;
end;

function TTest.GetAppName: string;
begin
  Result := GetField(F_APP_NAME);
end;

function TTest.GetCompareDB: Boolean;
begin
  Result := UpperCase(GetField(F_COMPARE_DB)) = 'Y';
end;

function TTest.GetCompareResult: Boolean;
begin
  Result := UpperCase(GetField(F_COMPARE_RESULT)) = 'Y';
end;

function TTest.GetData: string;
begin
  Result := FData.CommaText;
end;

function TTest.GetExpectedResult: longint;
begin
  Try
    Result := StrToInt(GetField(F_EXPECTED_RESULT));
  Except
    Result := 0;
  End;
end;

function TTest.GetExtraParam: string;
begin
  Result := GetField(F_EXTRA_PARAM);
end;

function TTest.GetField(WhichField: Integer): string;
begin
  if WhichField < FData.Count then
    Result := FData[WhichField]
  else
    Result := '';
end;

function TTest.GetTestName: string;
begin
  Result := GetField(F_TEST_NAME);
end;

function TTest.GetWantToRun: Boolean;
begin
  Result := UpperCase(GetField(F_RUN)) = 'Y';
end;

procedure TTest.SetAppName(const Value: string);
begin
  SetField(F_APP_NAME, Value);
end;

procedure TTest.SetCompareDB(const Value: Boolean);
begin
  SetField(F_COMPARE_DB, BoolToYN(Value));
end;

procedure TTest.SetCompareResult(const Value: Boolean);
begin
  SetField(F_COMPARE_RESULT, BoolToYN(Value));
end;

procedure TTest.SetData(const Value: string);
begin
  FData.CommaText := Value;
end;

procedure TTest.SetExpectedResult(const Value: longint);
begin
  SetField(F_EXPECTED_RESULT, IntToStr(Value));
end;

procedure TTest.SetExtraParam(const Value: string);
begin
  SetField(F_EXTRA_PARAM, Value);
end;

procedure TTest.SetField(WhichField: Integer; const Value: string);
begin
  if WhichField < FData.Count then
    FData[WhichField] := Value
  else
  if WhichField = F_EXTRA_PARAM then //setting extra param on test which didn't have one - add line
    FData.Add(Value);
end;

procedure TTest.SetTestName(const Value: string);
begin
  SetField(F_TEST_NAME, Value);
end;

procedure TTest.SetWantToRun(const Value: Boolean);
begin
  SetField(F_RUN, BoolToYN(Value));
end;

procedure TTestList.SaveLastListName;
begin
  oIniFile.Items[LIST_NAME] := FListName;
end;

end.
