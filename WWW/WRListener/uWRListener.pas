unit uWRListener;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  DB, pvtables, sqldataset, pvsqltables, Blowfish, IdBaseComponent,
  IdComponent, IdTCPServer, uSMSPoller;

type
  TCrunchType = (ctCustomer, ctDealer);

  TfrmListener = class(TService)
    ServerConnxn: TIdTCPServer;
    Blowfish: TBlowfish;
    WRDB: TPvSqlDatabase;
    WRSession: TPvSqlSession;
    qyPrimary: TPvQuery;
    qySMS: TPvQuery;
    qyUpdateSMS: TPvQuery;
    procedure OnStart(Sender: TService; var Started: Boolean); // AB - 1
    procedure ServiceExecute(Sender: TService);
    procedure ServerConnxnExecute(AThread: TIdPeerThread);
  private
    fSMSPoller: TSMSPoller;
    fCrunchType: TCrunchType;
    procedure InsertESN(CustID: integer; ESN: string; Version: integer);
    function CheckLine(BaseStr: string): boolean;
    function CrunchRecord(FileStr: string): integer;
    function GetStamp: string;
    function GetTypeString(PluralIndex: integer; AddWasWere: boolean = false): string;
    function Parse(BaseStr: string; Index: integer): string;
    function SetCrunchType(FirstString: string): integer;
  public
    function GetServiceController: TServiceController; override;
  end;

const
  LogPath = 'C:\Development\WRListener\WRListener.log';

var
  frmListener: TfrmListener;

implementation

uses
  WinSvc,
  IdGlobal;

{$R *.DFM}

//*** Main *********************************************************************

// AB - 1 New event handler. Checks that the two PDAC services are running 
//        before allowing this service to start up.
procedure TfrmListener.OnStart(Sender: TService; var Started: Boolean);
const
  MAX_CHECK_COUNT = 20;
  NUM_DEPENDANT_SERVICES = 2;
//  aServiceNames : array[1..NUM_DEPENDANT_SERVICES] of string[40] =
//                       ('Pervasive.SQL 2000 (relational)',
//                        'Pervasive.SQL 2000 (transactional)');

  aServiceNames : array[1..NUM_DEPENDANT_SERVICES] of string[40] =
                       ('Pervasive.SQL (relational)',
                        'Pervasive.SQL (transactional)');

var
  hndSCManager, hndService : SC_Handle;
  SS : TServiceStatus;
  dwStat : DWORD;
  szServiceName : PChar;
  byCheckCounter,
  byServiceIdx : byte;
  aServiceStarted : array[1..NUM_DEPENDANT_SERVICES] of boolean;
begin
  // This code will find these are the two services and check their status.
  // These are the 'names' of the two services that constitute the PDAC DB engine.
  // Pervasive.SQL 2000 (relational)
  // Pervasive.SQL 2000 (transactional)
  szServiceName := StrAlloc(50);
  for byServiceIdx := 1 to NUM_DEPENDANT_SERVICES do
  begin
    szServiceName := StrPCopy(szServiceName, aServiceNames[byServiceIdx]);
    byCheckCounter := 0; dwStat := 0;
    while (byCheckCounter <= MAX_CHECK_COUNT) and (dwStat <> SERVICE_RUNNING) do
    begin
      hndSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
      if (hndSCManager > 0) then
      begin
        hndService := OpenService(hndSCManager, szServiceName, SERVICE_QUERY_STATUS);
        if (hndService > 0) then
        begin
          if (QueryServiceStatus(hndService, SS)) then
          begin
            dwStat := SS.dwCurrentState;
          end;
          CloseServiceHandle(hndService);
        end;
        CloseServiceHandle(hndSCManager);
      end;
      inc(byCheckCounter);
      // wait for a bit in case the service is still starting, but if it's already running then don't bother.
      if (dwStat <> SERVICE_RUNNING) then sleep(1000); // Raised this from 200 to 1000 as part of WebRel deployment.
    end; // while (byCheckCounter <= MAX_CHECK_COUNT) and (dwStat <> SERVICE_RUNNING) do...
    aServiceStarted[byServiceIdx] := (dwStat = SERVICE_RUNNING);
  end; // for (byServiceIdx := 1 to NUM_DEPENDANT_SERVICES) do...
  StrDispose(szServiceName);

  if (not aServiceStarted[1]) then
    LogMessage('WRListener is dependant on the service ['+trim(aServiceNames[1])+'] which is not running',
                                                                                              EVENTLOG_ERROR_TYPE,0,0);

  if (not aServiceStarted[2]) then
    LogMessage('WRListener is dependant on the service ['+trim(aServiceNames[2])+'] which is not running',
                                                                                              EVENTLOG_ERROR_TYPE,0,0);

  Started := aServiceStarted[1] and aServiceStarted[2];
end;

procedure TfrmListener.ServiceExecute(Sender: TService);
begin
  ServerConnxn.Active:= true;

  fSMSPoller:= TSMSPoller.Create(true);
  with fSMSPoller do
  begin
    FreeOnTerminate:= true;
    SMSDB:= WRDB;
    SMSQuery:= qySMS;
    SMSUpdate:= qyUpdateSMS;
    Resume;
  end;

  while not Terminated do ServiceThread.ProcessRequests(true);

  fSMSPoller.Terminate;
  ServerConnxn.Active:= false;
end;

procedure TfrmListener.ServerConnxnExecute(AThread: TIdPeerThread);
var
ListenFile: TFileStream;
ReceiveStream: TMemoryStream;
ResultLog: TextFile;
StreamSize, RecordIndex, RecCount, CrunchResult: integer;
Proceed: boolean;
begin
  Proceed:= true;

  ListenFile:= TFileStream.Create('C:\Development\WRListener\Archive\' + FormatDateTime('yymmddhhnnss', Now) + '.dat', fmCreate);
  ReceiveStream:= TMemoryStream.Create;

  with AThread.Connection do
  try
    WRDB.Open;
    AssignFile(ResultLog, LogPath);
    if FileExists(LogPath) then Append(ResultLog) else Rewrite(ResultLog);
    System.WriteLn(ResultLog, GetStamp + 'Receiving stream~');

    try
      StreamSize:= ReadInteger;
      ReadStream(ListenFile, StreamSize);
      System.WriteLn(ResultLog, GetStamp + 'Stream received~');
    except
      Proceed:= false;
      System.WriteLn(ResultLog, GetStamp + 'STREAMING FAILED~');
      System.WriteLn(ResultLog);
    end;

    if Proceed then
    try
      WRSession.Open;
      WRDB.Open;
    except
      Proceed:= false;
      System.WriteLn(ResultLog, GetStamp + 'DB CONNXN FAILED~');
    end;

    if Proceed then with Blowfish do
    try
      try
        System.WriteLn(ResultLog, GetStamp + 'Decrypting Stream~');

        LoadIVString('kD4a1s' + 'tB47A' + 'f3eJH');
        InitialiseString('d46fTY' + 'NL391' + '5XpPw');
        DecStream(ListenFile, ReceiveStream);

        System.WriteLn(ResultLog, GetStamp + 'Stream decrypted~');
      except
        System.WriteLn(ResultLog, GetStamp + 'DECRYPTION FAILED~');
        System.WriteLn(ResultLog);
      end;
    finally
      Burn;
    end;

    if Proceed then with TStringlist.Create do
    try
      try
        System.WriteLn(ResultLog, GetStamp + 'Crunching stream~');

        ReceiveStream.Seek(0, soFromBeginning);
        LoadFromStream(ReceiveStream);
        for RecordIndex:= Pred(Count) downto 0 do if Trim(Strings[RecordIndex]) = '' then Delete(RecordIndex);
        if SetCrunchType(Strings[0]) <> 0 then raise EConvertError.Create('');

        RecCount:= 0;
        for RecordIndex:= 1 to Pred(Count) do
        begin
          CrunchResult:= CrunchRecord(Strings[RecordIndex]);

          if CrunchResult < 0 then
          begin
            System.WriteLn(ResultLog, GetStamp + 'CrunchRecord returned an error. Record being parsed...');
            System.WriteLn(ResultLog, GetStamp + '('+Strings[RecordIndex]+')~');
//            raise EConvertError.Create('');
          end
          else
          begin
            if CrunchResult = 0 then inc(RecCount);
          end;

        end;

        if (RecCount = 0) and (Count <= 2) then Writeln('This' + GetTypeString(Pred(Count)) + 'already exists in Webrel' + EOL)
        else if RecCount = 0 then Writeln('These' + GetTypeString(Pred(Count)) + 'already exist in Webrel' + EOL)
        else if RecCount < Pred(Count) then Writeln(IntToStr(RecCount) + GetTypeString(RecCount, true) + 'exported to Webrel, ' + IntToStr(Pred(Count) - RecCount) + GetTypeString(Pred(Count) - RecCount) + 'already existed' + EOL)
        else if RecCount = Pred(Count) then Writeln(IntToStr(RecCount) + GetTypeString(RecCount, true) + 'exported to Webrel' + EOL);
        System.WriteLn(ResultLog, GetStamp + IntToStr(RecCount) + '/' + IntToStr(Pred(Count)) + ' RECORDS CRUNCHED~');
        System.WriteLn(ResultLog);
      except
        Writeln('Invalid File Format' + EOL);
        System.WriteLn(ResultLog, GetStamp + 'INVALID FILE FORMAT~');
        System.WriteLn(ResultLog);
      end;
    finally
      Free;
    end;

  finally
    Disconnect;

    qyPrimary.Close;
    WRDB.Close;
    WRSession.Close;

    ReceiveStream.Free;
    ListenFile.Free;
    Flush(ResultLog);
    CloseFile(ResultLog);
  end;
end;

function TfrmListener.CrunchRecord(FileStr: string): integer;
var
CodeTable: string;
MaxID, GroupID: integer;
begin
  Result:= 0;

  if CheckLine(FileStr) then with qyPrimary do
  try

    case fCrunchType of
      ctCustomer: CodeTable:= 'customers';
      ctDealer: CodeTable:= 'usergroups';
    end;

    Close;
    Sql.Clear;
    Sql.Add('select count(*) from ' + CodeTable + ' ');
    Sql.Add('where linkcode = :plinkcode ');
    ParamByName('plinkcode').AsString:= Copy(UpperCase(Parse(FileStr, 1)), 1, 6);
    Open;

    if Fields[0].AsInteger = 0 then
    begin
      Close;
      Sql.Clear;
      Sql.Add('select max');
      case fCrunchType of
        ctCustomer: Sql.Add('(custid)');
        ctDealer: Sql.Add('(groupid)');
      end;
      Sql.Add(' from ' + CodeTable + ' ');
      Open;

      MaxID:= Fields[0].AsInteger;
      GroupID:= 1;

      if fCrunchType = ctCustomer then
      begin
        Close;
        Sql.Clear;
        Sql.Add('select groupid from usergroups ');
        Sql.Add('where linkcode = :plinkcode ');
        ParamByName('plinkcode').AsString:= Copy(UpperCase(Parse(FileStr, 3)), 1, 6);
        Open;

        if not eof then GroupID:= FieldByName('GroupID').AsInteger;
      end;

      Close;
      Sql.Clear;
      Sql.Add('insert into ' + CodeTable + ' (');

      case fCrunchType of
        ctCustomer:
        begin
          Sql.Add('custid, groupid, custname, restricted, active, linkcode) ');
          Sql.Add('values (:pid, :pgroupid, :pname, 0, 1, :plinkcode) ');
          ParamByName('pgroupid').AsInteger:= GroupID;
        end;
        ctDealer:
        begin
          Sql.Add('groupid, parentid, groupdesc, grouptype, groupactive, userdef1, active, linkcode) ');
          Sql.Add('values (:pid, 1, :pname, 1, 1, :pemail, 1, :plinkcode) ');
          ParamByName('pemail').AsString:= Parse(FileStr, 3);
        end;
      end;

      ParamByName('pid').AsInteger:= Succ(MaxID);
      ParamByName('pname').AsString:= Parse(FileStr, 2);
      ParamByName('plinkcode').AsString:= Copy(UpperCase(Parse(FileStr, 1)), 1, 6);
      ExecSql;

      if fCrunchType = ctCustomer then InsertESN(Succ(MaxID), Parse(FileStr, 4), StrToIntDef(Parse(FileStr, 5), -1));

    end
    else Result:= 1;

  except
    Result := -1;
  end
  else
  begin
    Result:= -1;
  end;
end;

procedure TfrmListener.InsertESN(CustID: integer; ESN: string; Version: integer);

  function NewESN(const ESN : string) : boolean;
  var
    HyphenPos : SmallInt;
  begin
    HyphenPos := Pos('-',ESN);
    if (HyphenPos > 0) then
      Result := (Copy(ESN, (HyphenPos + 1), 3) = '000')
    else
      Result := (Copy(ESN, 4, 3) = '000');
  end;

var
  MaxID: integer;
begin
  with qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select max(esnid) from esns ');
    Open;

    MaxID:= Fields[0].AsInteger;

    Close;
    Sql.Clear;
    Sql.Add('insert into esns (esnid, custid, esn, version, unspecified, active) ');
    Sql.Add('values (:pesnid, :pcustid, :pesn, :pversion, :punspecified, 1) ');
    ParamByName('pesnid').AsInteger:= Succ(MaxID);
    ParamByName('pcustid').AsInteger:= CustID;

    if (ESN = '') or
       (NewESN(ESN)) then
    begin
      ParamByName('punspecified').AsBoolean := TRUE
    end
    else
      ParamByName('punspecified').AsBoolean := FALSE;

    case Version of
      -1: ParamByName('pversion').AsString:= 'v5.0x/v5.5x';
      0: ParamByName('pversion').AsString:= 'v4.31/v4.32';
      1: ParamByName('pversion').AsString:= 'v5.0x/v5.5x';
    end;

    if ESN = '' then ESN:= '000-000-000-000-000-000-000';
    if Length(ESN) = 23 then ESN:= ESN + '-000';
    ParamByName('pesn').AsString:= Copy(ESN, 1, 27);

    ExecSql;
  end;
end;

//*** Helper Functions *********************************************************

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  frmListener.Controller(CtrlCode);
end;

function TfrmListener.GetServiceController: TServiceController;
begin
  Result:= ServiceController;
end;

function TfrmListener.CheckLine(BaseStr: string): boolean;
var
CharIndex, TildeCount: integer;
begin
  Result:= false;
  TildeCount:= 0;

  for CharIndex:= 1 to Length(BaseStr) do
  begin
    if BaseStr[CharIndex] = '~' then inc(TildeCount);
  end;

  case fCrunchType of
    ctCustomer: if (BaseStr[7] = '~') and (TildeCount in [3,5]) then Result:= true;
    ctDealer: if (BaseStr[7] = '~') and (TildeCount = 3) then Result:= true;
  end;
end;

function TfrmListener.GetStamp: string;
begin
  Result:= FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + '~';
end;

function TfrmListener.GetTypeString(PluralIndex: integer; AddWasWere: boolean): string;
var
WasWere: string;
begin
  WasWere:= '';

  if PluralIndex <= 1 then
  begin
    if AddWasWere then WasWere:= 'was ';
    if fCrunchType = ctDealer then Result:= ' dealer ' + WasWere
    else if fCrunchType = ctCustomer then Result:= ' customer ' + WasWere;
  end
  else
  begin
    if AddWasWere then WasWere:= 'were ';
    if fCrunchType = ctDealer then Result:= ' dealers ' + WasWere
    else if fCrunchType = ctCustomer then Result:= ' customers ' + WasWere;
  end;
end;

function TfrmListener.Parse(BaseStr: string; Index: integer): string;
var
CharIndex, Delimit: integer;
HoldStr: string;
begin
  Result:= '';
  HoldStr:= '';
  Delimit:= 1;

  for CharIndex:= 1 to Length(BaseStr) do
  begin
    if BaseStr[CharIndex] = '~' then
    begin
      if Delimit = Index then
      begin
        Result:= HoldStr;
        Break;
      end;
      HoldStr:= '';
      inc(Delimit);
    end
    else HoldStr:= HoldStr + BaseStr[CharIndex];
  end;
end;

function TfrmListener.SetCrunchType(FirstString: string): integer;
begin
  Result:= 0;

  if Pos('CUSTOMER', UpperCase(FirstString)) <> 0 then fCrunchType:= ctCustomer
  else if Pos('DEALER', UpperCase(FirstString)) <> 0 then fCrunchType:= ctDealer
  else Result:= -1;
end;

//******************************************************************************

end.
