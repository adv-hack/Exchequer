unit AgentList;

interface

uses
  Classes, Windows, Contnrs, ElVar, ComCtrls, Dialogs;

const
  AGENT_APP_NAME = 'SentimailAgent.exe';
  MAX_STALLED_MINUTES = 60;

type
  TResetSentinelProc = procedure (const ADataPath : string;
                                  const AUser : string;
                                  const AName : string) of Object;

  TAddToLogProc = procedure (const s : string) of object;

  TAgent = Class
  private
    FProcessId : DWORD;
    FDataPath : string;
    FStartTime, FLatestTime : TDateTime;
    FCount : longint;
    FStartTimeString : string;
    ProgressList : TStringList;
    FLog : string;
    CommLog : string; //PR: 30/11/2012 Add one line log for communication to try to resolve Newbridge problem
    FCode : string;
    FStartId : string;
    OldProgressString : string;
    FUser : string;
    FCompanyCode : string;
    FAddToLog : TAddToLogProc;
    function GetCompanyCode: string;
    procedure DoLog(const s : string);
  public
    constructor Create(const APath : string; const ASentinel : string; const AUser : string;
                                      APurpose : TSentinelPurpose; const AReport : string; const CoCode : string);
    destructor Destroy; override;
    function Finished : Boolean;
    function Stalled : Boolean;
    function ProgressString : string;
    procedure GetLogFile(const AList : TStringList);
    procedure KillProcess;
    function ProcessStillRunning : Boolean;

    property Code : string read FCode write FCode;
    property ProcessID : DWORD read FProcessId write FProcessId;
    property StartTimeString : string read FStartTimeString write FStartTimeString;
    property CompanyCode : string read GetCompanyCode;
    property UserId : string read FUser write FUser;
    property DataPath : string read FDatapath write FDatapath;

    property AddToLog : TAddToLogProc read FAddToLog write FAddToLog;
  end;

  TAgentList = Class
  private
    FList : TObjectList;
    FMaxAgents : SmallInt;
    FResetSentinel : TResetSentinelProc;
    FAddToPollLog : TAddToLogProc;
    function GetCount: Integer;
    function GetMaxAgents : SmallInt;
    procedure DoLog(const s : string);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(const APath: string; const ASentinel : string; const AUser : string;
                      APurpose : TSentinelPurpose; const AReport : string; const CoCode : string) : Boolean;
    function CanAddAgent : Boolean;
    procedure ShowProgress(const AListView : TListView);
    procedure CheckForFinishedAgents;
    procedure CheckForStalledAgents;
    procedure Refresh;

    property Count : Integer read GetCount;
    property ResetSentinel : TResetSentinelProc read FResetSentinel write FResetSentinel;
    property AddToPollLog : TAddToLogProc read FAddToPollLog write FAddToPollLog;
  end;

implementation

uses
  ApiUtil, FileUtil, SysUtils, WorkSta2, DateUtils, StrUtils;

{ TAgent }

constructor TAgent.Create(const APath: string; const ASentinel : string; const AUser : string;
                           APurpose : TSentinelPurpose; const AReport : string; const CoCode : string);
var
  ProcInf : PROCESS_INFORMATION;
  ParamString : string;

  //Sentinels can have spaces in their codes, so ensure that any such are wrapped in quotes to ensure
  //they are treated as one parameter
  function MakeParam(const s : string) : string;
  begin
    Result := s;
    if Pos(' ', s) > 0 then
      Result := '"' + s + '"';
  end;

begin
  inherited Create;
  ProgressList := TStringList.Create;
  OldProgressString := '';
  FDataPath := APath;
  FStartTime := Now;
  FStartTimeString := FormatDateTime('hh:nn:ss', FStartTime);
  FStartId := FormatDateTime('yymmddhhnnss', FStartTime);
  FCode := Trim(ASentinel);
  FCompanyCode := CoCode;
  FUser := AUser;
  FCount := 0;
{$IFDEF GETPARAMS}
  ParamString :=  ExtractFilePath(ParamStr(0)) +
                  AGENT_APP_NAME + ' ' + MakeParam(FDataPath) + ' ' +
                   FStartId + ' ' + MakeParam(ASentinel) +
                                         ' ' + MakeParam(AUser) +
                                         ' ' + IntToStr(Ord(APurpose)) +
                                         ' ' + MakeParam(AReport);
  with TStringList.Create do
  Try
    Add(ParamString);
    SaveToFile(FDataPath + 'LOGS\Params_' + FStartId + '.txt');
  Finally
    Free;
  End;
  ProcInf := RunAppEx(ParamString, False);
{$ELSE}
  ProcInf := RunAppEx(ExtractFilePath(ParamStr(0)) + AGENT_APP_NAME + ' ' + MakeParam(FDataPath) +
                                                                      ' ' + FStartId +
                                                                      ' ' + MakeParam(ASentinel) +
                                                                      ' ' + MakeParam(AUser) +
                                                                      ' ' + IntToStr(Ord(APurpose)) +
                                                                      ' ' + MakeParam(AReport), False);
{$ENDIF}
  FProcessId := ProcInf.dwProcessId;
  FLog := FDatapath + 'Swap\' + WorkstationName + '_SA' + IntToStr(FProcessID) + '_' + FStartId + '.tmp';
  //PR: 30/11/2012 Set communication log file name
  CommLog := ChangeFileExt(FLog, S_COMMON_LOG);
end;

destructor TAgent.Destroy;
var
  bRes : Boolean;
begin
  FLog := ChangeFileExt(FLog, '.log');
  if Assigned(ProgressList) then
    ProgressList.Free;

  if FileExists(FLog) then
  begin
    if DebugModeOn then
      MoveFile(PChar(FLog), PChar(AnsiReplaceStr(FLog, '\Swap\', '\Logs\')))
    else
    begin
      bRes := DeleteFile(FLog);
      if not bRes then
        raise Exception.Create('Unable to delete ' + FLog);
    end;
  end;

  //PR: 30/11/2012 Delete communication log file
  if FileExists(CommLog) then
    DeleteFile(CommLog);

  inherited;
end;

function TAgent.Finished: Boolean;
begin
  Result := FileExists(ChangeFileExt(FLog, '.log'));
//  Result := not FileExists(FLog);
end;

function TAgent.GetCompanyCode: string;
begin
  Result := FCompanyCode;
end;

procedure TAgent.GetLogFile(const AList: TStringList);
begin
  if FileExists(FLog) then
    AList.LoadFromFile(FLog);
end;

function TAgent.ProgressString: string;
begin
  Result := OldProgressString;

  //PR: 30/11/2012 Change to use communication log
  if FileExists(CommLog) then
  Try
    ProgressList.LoadFromFile(CommLog);
  Except
    Sleep(2); //Have another try
    Try
      ProgressList.LoadFromFile(CommLog);
    Except
      on E:Exception do
      begin
        ProgressList.Clear;
        //Remove logging of reading file exceptions as JW's request since they may happen quite often without
        //affecting functionality and cause support queries.
//        DoLog('Exception reading ' + CommLog + ': ' + QuotedStr(E.Message));
      end;
    End;
  End;
  if ProgressList.Count > 0 then
  Try
    Result := ProgressList[ProgressList.Count - 1];
    OldProgressString := Result;
    Try
      //PR: 05/11/2012 Change to take first 23 chars and trim them, to avoid locale differences.
      FLatestTime := StrToDateTime(Trim(Copy(Result, 1, 23)));

      if Pos('@', Result) > 0 then
        Result := 'Sending messages';
    Except
      FLatestTime := 0;
    End;
  Finally
    ProgressList.Clear;
  End;
end;

function TAgent.Stalled: Boolean;
var
  bGone : Boolean;
  s : string;
begin
  bGone := False; //bGone indicates that the process has crashed and is no longer running
  //Check that we have a latest time before checking for stalled
  Result := (FLatestTime > 0) and (MinutesBetween(FLatestTime, Now) > MAX_STALLED_MINUTES);
  if Result then DoLog('LatestTime: ' + FormatDateTime('hh:nn:ss', FLatestTime) +
                       '; CurrentTime: ' + FormatDateTime('hh:nn:ss', Now));
  if not Result then
    bGone := not ProcessStillRunning;

  if Result or bGone then
  begin
    if FileExists(FLog) then
    begin
      if bGone then
      begin  //Check if we've finished the run successfully, but weren't able to rename the file.
        s := ProgressString;
        if Pos(S_FINISHED, s) > 0 then
        begin
          RenameFile(FLog, ChangeFileExt(FLog, '.log'));
          Result := False;
        end
        else
          Result := True;
      end;

      if Result then
      begin
        RenameFile(FLog, ChangeFileExt(FLog, '.log'));
        FLog := ChangeFileExt(FLog, '.log');
        MoveFile(PChar(FLog), PChar(AnsiReplaceStr(FLog, '\Swap\', '\Logs\')));
      end;
    end;

    if not bGone then
      KillProcess;
  end;
end;

function TAgent.ProcessStillRunning: Boolean;
var
  hProc : THandle;
begin
  Result := False;
  hProc := OpenProcess(PROCESS_TERMINATE,
                   BOOL(0),
                   FProcessID);
  if hProc <> 0 then
  begin
    Result := True;
    CloseHandle(hProc);
  end;
end;

procedure TAgent.DoLog(const s: string);
begin
  if Assigned(FAddToLog) then
    FAddToLog(s);
end;

{ TAgentList }

function TAgentList.Add(const APath, ASentinel: string; const AUser : string;
                    APurpose : TSentinelPurpose; const AReport : string; const CoCode : string) : Boolean;
var
  AnAgent : TAgent;
begin
  Result := CanAddAgent;
  if Result then
  begin
    AnAgent := TAgent.Create(APath, ASentinel, AUser, APurpose, AReport, CoCode);
    AnAgent.AddToLog := FAddToPollLog;
    FList.Add(AnAgent);
  end;
end;

function TAgentList.CanAddAgent: Boolean;
begin
  CheckForFinishedAgents;
  Result := FList.Count < FMaxAgents;
end;

procedure TAgentList.CheckForFinishedAgents;
var
  i : integer;
begin
  for i := FList.Count - 1 downto 0 do
    if TAgent(FList[i]).Finished then
    begin
      DoLog(TAgent(FList[i]).Code + ' finished');
      FList.Delete(i);
    end;
end;

constructor TAgentList.Create;
begin
  inherited;
  FList := TObjectList.Create;
  FList.OwnsObjects := True;
  GetMaxAgents;
end;

destructor TAgentList.Destroy;
begin
  if Assigned(FList) then
    FList.Free;
  inherited;
end;

procedure TAgentList.ShowProgress(const AListView: TListView);
var
  i, j : integer;
  Agent : TAgent;
  s : string;
begin
  AListView.Items.BeginUpdate;
  Try
    AListView.Items.Clear;
    for i := 0 to FList.Count - 1 do
    begin
      Agent := TAgent(FList[i]);
      if not Agent.Finished then
      begin
        with AListView.Items.Add do
        begin
          Caption := Agent.CompanyCode;
          SubItems.Add(Agent.Code);
          SubItems.Add(IntToStr(Agent.ProcessID));
          SubItems.Add(Agent.StartTimeString);
          s := Agent.ProgressString;
          //Latest time
          j := Pos(' ', s);
          if (j > 0) and (Pos('>', s) > 0) then
            SubItems.Add(Copy(s, j + 1, 8))
          else
            SubItems.Add(' ');
          j := Pos('>', s);
          if j > 0 then
            SubItems.Add(Copy(s, j + 1, Length(s)))
          else
            SubItems.Add(' ');
        end;
      end;
    end;
  Finally
    AListView.Items.EndUpdate;
  End;
end;

function TAgentList.GetMaxAgents: SmallInt;
begin
  Result := 0;
   with TElertWorkStationSetup.Create do
   Try
     FMaxAgents := MaxAgents;
   Finally
     Free;
   End;
end;



function TAgentList.GetCount: Integer;
begin
  Result := FList.Count;
end;

//Called after editing settings to reload max agents.
procedure TAgentList.Refresh;
begin
  GetMaxAgents;
end;

procedure TAgentList.CheckForStalledAgents;
var
  i : integer;
begin
  for i := FList.Count - 1 downto 0 do
    if TAgent(FList[i]).Stalled then
    begin
      DoLog(TAgent(FList[i]).Code + ' did not finish successfully');
      if Assigned(FResetSentinel) then
        with TAgent(FList[i]) do
          ResetSentinel(DataPath, UserID, Code);
      FList.Delete(i);
    end;

end;

procedure TAgent.KillProcess;
var
  bOK : Boolean;
begin
  bOK := TerminateProcess(OpenProcess(PROCESS_TERMINATE,
                          BOOL(0),
                          FProcessID),
                          0);
  if bOK then
    DoLog('Terminated Process ' + IntToStr(FProcessID))
  else
    DoLog('Unable to terminate Process ' + IntToStr(FProcessID));
end;

procedure TAgentList.DoLog(const s: string);
begin
  if Assigned(FAddToPollLog) then
    FAddToPollLog(s);
end;

end.
