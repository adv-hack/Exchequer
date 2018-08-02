unit CustIni;

interface

uses
  Classes,  ExScheduler_TLB;

type
  TPluginList = Class
  private
    FList : TInterfaceList; //List of instantiated interfaces
    FClassList : TStringList; //Class names of Interfaces in the list
    function GetCount: Integer;
    function GetItem(Index: Integer): IScheduledTask;
    function GetCustomClassName(Index: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReadIniFile;
    function GetItemByClassName(const sClassName : string) : IScheduledTask;
    function PluginExists(const sClassName : string) : Boolean;
    property Item[Index : Integer] : IScheduledTask read GetItem;
    property CustomClassName[Index : Integer] : string read GetCustomClassName;
    property Count : Integer read GetCount;
  end;

  function PluginList : TPluginList;

implementation

uses
  IniFiles, ComObj, SysUtils, ApiUtil, Dialogs, FileUtil;

var
  PlugList : TPluginList;

  function PluginList : TPluginList;
  begin
    if not Assigned(Pluglist) then
      Pluglist := TPluginlist.Create;

    Result := Pluglist;
  end;

{ TPluginList }

constructor TPluginList.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
  FClassList := TStringList.Create;
end;

destructor TPluginList.Destroy;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
    FList[i] := nil;
  FList.Free;
  FClassList.Free;
  inherited;
end;

function TPluginList.GetCustomClassName(Index: Integer): string;
begin
  Result := FClassList[Index];
end;

function TPluginList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPluginList.GetItem(Index: Integer): IScheduledTask;
begin
  Result := FList[Index] as IScheduledTask;
end;

function TPluginList.GetItemByClassName(
  const sClassName: string): IScheduledTask;
var
  i : integer;
begin
  i := FClassList.IndexOf(sClassName);

  if i > -1 then
    Result := FList[i] as IScheduledTask;
end;

procedure TPluginList.ReadIniFile;
//Reads the customisation ini file and loads all class names into the list
const
  IniFileName = 'ExSched.ini';
var
  s : string;
  i : integer;
  FileName : string;
begin
  FileName := GetEnterpriseDirectory + IniFilename;
  if FileExists(Filename) then
  with TIniFile.Create(Filename) do
  Try
    i := 1;
    s := Trim(ReadString('Plugins', IntToStr(i), ''));

    while s <> '' do
    begin
      Try
        FList.Add(CreateOLEObject(s) as IScheduledTask);
        FClassList.Add(s);
      Except
        On EOLESysError Do
           msgBox ('The Scheduler Plug-In ' + QuotedStr(s) + ' cannot be created, ' +
                   'please ensure that it is correctly installed and registered on this workstation.' + #13#13 +
                   'Please notify your Technical Support of this problem',
                    mtWarning, [MbOk], mbOK, 'Task Scheduler Customisation');
        On Exception Do
           raise ;
      End;

      inc(i);
      s := Trim(ReadString('Plugins', IntToStr(i), ''));
    end;
  Finally
    Free;
  End;
end;

function TPluginList.PluginExists(const sClassName: string): Boolean;
begin
  Result := FClassList.IndexOf(sClassName) >= 0;
end;

Initialization
  Pluglist := nil;

Finalization
  if Assigned(Pluglist) then
    Pluglist.Free;
end.
