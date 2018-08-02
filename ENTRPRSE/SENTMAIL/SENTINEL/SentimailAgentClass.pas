unit SentimailAgentClass;

interface

uses
  SentU, ElVar;

type
  TSentimailAgent = Class
  private
    FSentinel : TSentinel;
    FSentinelCode : String;
    FDataPath : string;
    FPurpose : TSentinelPurpose;
    FUserId  : string;
    FReportName : string;
    FStartId : string;
    function LogFileName(const Ext : string) : string;
    procedure CreateSentinel;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    property SentinelCode : String read FSentinelCode write FSentinelCode;
    property DataPath : string read FDataPath write FDataPath;
    property Purpose : TSentinelPurpose read FPurpose write FPurpose;
    property UserId : string read FUserID write FUserId;
    property ReportName : string read FReportName write FReportName;
    property StartId : string read FStartId write FStartId;
  end;


implementation

{ TSentimailAgent }
uses
  SysUtils, Windows, CommsInt, ApiUtil, VRWSentinel, Dialogs, RWSentinel, HideMadExcept, StrUtils, GlobIni, FileUtil;

constructor TSentimailAgent.Create;
begin
  inherited;
  EntEmail := TEntEmail.Create;
  EntEmail.SuppressMessages := True;

  //PR: 08/09/2011 The global ini filename wasn't being set, so leading to an error if the program tried to write to it when
  //starting a new conveynn.log file.
  GlobalEntPath := GetEnterpriseDirectory;
  GlobalIniFileName := GlobalEntPath + 'SentMail.ini';
end;

procedure TSentimailAgent.CreateSentinel;
begin
  Case FPurpose of
    spQuery,
    spReportQuery           : FSentinel := TSentinelQuery.Create;
    spConveyor              : FSentinel := TSentinelConveyor.Create(1);
    spVisualReport          : FSentinel := TSentinelVisualReporter.Create(1);
    spVisualReportConveyor  : FSentinel := TSentinelVisualReportConveyor.Create;
    spCSVConveyor           : FSentinel := TSentinelCSVConveyor.Create;
    spEmailCheck            : FSentinel := TSentinelEmailChecker.Create;
    spReport                : FSentinel := TSentinelReport.Create(1);
    spReportConveyor        : FSentinel := TSentinelReportConveyor.Create(1);
    else
      FSentinel := nil;
  end;

  if Assigned(FSentinel) then
  begin
    FSentinel.ElertName := FSentinelCode;
    FSentinel.DataPath := FDataPath;
    FSentinel.User := FUserId;
    if FPurpose = spVisualReport then
      (FSentinel as TSentinelVisualReporter).ReportName := FReportName
    else
    if FPurpose = spReport then
      (FSentinel as TSentinelReport).ReportName := FReportName
  end;

end;

destructor TSentimailAgent.Destroy;
begin
  if Assigned(EntEmail) then
    EntEmail.Free;
  inherited;
end;

procedure TSentimailAgent.Execute;
var
  iCount : Integer;
  bDone : Boolean;
begin
  DefineFiles(FDatapath);
  AssignFile(LogFile, LogFileName('.tmp'));
  Rewrite(LogFile);
  CloseFile(LogFile);
  BugReportName := AnsiReplaceStr(LogFileName('.bugreport'), '\Swap\', '\Logs\');
  CreateSentinel;
  if Assigned(FSentinel) then
  Try
    Randomize;
    FSentinel.LogFileName := LogFileName('.tmp');
    FSentinel.LogIt(spQuery, Trim(SentinelCode) + ' Started');
    FSentinel.LogIt(spQuery, ' ');

    FSentinel.Run(False, FPurpose = spReportQuery);

    bDone := False;
    iCount := 0;

    if FSentinel.RanOK then
    begin
      repeat
        bDone := RenameFile(LogFileName('.tmp'), LogFileName('.log'));
        inc(iCount);
        Wait(20 + Random(300));
      until bDone or (iCount >= 10);
    end;

  Finally
    FSentinel.Free;
  End;
end;

function TSentimailAgent.LogFileName(const Ext: string): string;
begin
  Result := FDatapath + 'Swap\' + WinGetComputerName + '_SA' + IntToStr(GetCurrentProcessID) + '_' + FStartId +  Ext;
end;

end.
