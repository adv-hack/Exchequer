unit oProcessLockSQL;

interface

uses
  oProcessLock;

type
  //Interface for database access
  IProcessLockSQL = Interface
    ['{F4A88B3B-BD7F-4888-B103-D0B75B657C42}']
    function GetExistingProcessLockType : TProcessLockType;
    function GetExistingUserID : string;
    function GetExistingTimeStamp : string;

    function CreateLock : Boolean;
    procedure ReleaseLock;
    function ReadExisting : Boolean;

    property ExistingProcessLockType : TProcessLockType
                                          read GetExistingProcessLockType;
    property ExistingUserID : string read GetExistingUserID;
    property ExistingTimeStamp : string read GetExistingTimeStamp;
  end;

  function GetProcessLockSQL(ProcessType : TProcessLockType) : IProcessLockSQL;

implementation

uses
  SQLCallerU, SQLUtils, ADODB, SysUtils, VarConst, GlobVar;

const
  //Table and field names
  S_PROCESS_TYPE = 'ProcessType';
  S_USER_ID = 'UserId';
  S_TIMESTAMP = 'TimeStamp';
  S_TABLE_NAME = 'SystemLocks';

type
  TProcessLockSQL = Class(TInterfacedObject, IProcessLockSQL)
  private
    FLocked : Boolean;
    FProcessLockType : TProcessLockType;
    FUserID : string;

    FSQLCaller : TSQLCaller;
    FCompanyCode : string;

    //Existing values
    FExistingProcessLockType : TProcessLockType;
    FExistingUserId : string;
    FExistingTimeStamp : string;
  protected
    function GetExistingProcessLockType : TProcessLockType;
    function GetExistingUserID : string;
    function GetExistingTimeStamp : string;
    procedure CheckTable;
    function AddRecord : Integer;

    function CreateLock : Boolean;
    procedure ReleaseLock;

    function ReadExisting : Boolean;

  public
    constructor Create(ProcessType : TProcessLockType);
    destructor Destroy; override;
  end;


function GetProcessLockSQL(ProcessType : TProcessLockType) : IProcessLockSQL;
begin
  Result := TProcessLockSQL.Create(ProcessType) as IProcessLockSQL;
end;

{ TProcessLockSQL }

//Add lock record into table
function TProcessLockSQL.AddRecord : Integer;
const
  sSQL = 'INSERT INTO [%s].[%s] ' +
           '(%s, %s, %s) Values(%d, %s, %s)';
begin
  Result := FSQLCaller.ExecSQL(Format(sSQL,
                                   [FCompanyCode, S_TABLE_NAME,
                                   S_PROCESS_TYPE,
                                   S_USER_ID,
                                   S_TIMESTAMP,
                                   Ord(FProcessLockType),
                                   QuotedStr(FUserId),
                                   QuotedStr(FormatDateTime('yyyymmddhhnnss', Now))]));

end;

//If the lock table doesn't exist, create it
procedure TProcessLockSQL.CheckTable;
const
  sSQL = 'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = ' +
         'OBJECT_ID(N''[%s].[%s]'') AND type in (N''U'')) ' +
         'create table [%s].[%s] ' +
         '([Id]  int  Primary Key Identity(1,1), ' +
         ' [%s]  int,                      ' +
         ' [%s]  varchar(10),              ' +
         ' [%s]  varchar(14))';

begin
  FSQLCaller.ExecSQL(Format(sSQL, [FCompanyCode, S_TABLE_NAME,
                                   FCompanyCode, S_TABLE_NAME,
                                   S_PROCESS_TYPE,
                                   S_USER_ID,
                                   S_TIMESTAMP]));
end;

constructor TProcessLockSQL.Create(ProcessType: TProcessLockType);
var
  sConnect, lPassword : WideString;
begin
  inherited Create;
  FProcessLockType := ProcessType;
  FCompanyCode := GetCompanyCode(SetDrive);
  //SQLUtils.GetConnectionString(FCompanyCode, False, sConnect);
  SQLUtils.GetConnectionStringWOPass(FCompanyCode, False, sConnect, lPassword);  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

  //Create sql caller and set read uncommitted isolation level
  FSQLCaller := TSQLCaller.Create;
  FSQLCaller.Connection.ConnectionString := sConnect;
  FSQLCaller.Connection.Password := lPassword;
  FSQLCaller.Connection.IsolationLevel := ilReadUncommitted;
  FSQLCaller.Connection.Open;

  //Create table if needed
  CheckTable;

  FUserID := EntryRec^.Login;

  //No logged-in user?
  if Trim(FUserID) = '' then
    FUserID := 'SYSTEM';

end;

//Create a lock by updating the record in the lock table without committing
//the transaction
function TProcessLockSQL.CreateLock: Boolean;
var
  Res : Integer;
  sQuery : AnsiString;
begin
  Result := False;
  with FSQLCaller do
  begin
    Connection.BeginTrans;

    Query.CommandTimeOut := 1;
    Res := AddRecord;

    Result := Res = 0;
    if not Result then
    begin
      Connection.RollbackTrans;
      ReadExisting;
    end;
  end;
end;

destructor TProcessLockSQL.Destroy;
begin
  ReleaseLock;
  FreeAndNil(FSQLCaller);
  inherited;
end;


function TProcessLockSQL.GetExistingProcessLockType: TProcessLockType;
begin
  Result := FExistingProcessLockType;
end;

function TProcessLockSQL.GetExistingTimeStamp: string;
begin
  Result := FExistingTimestamp;
end;

function TProcessLockSQL.GetExistingUserID: string;
begin
  Result := FExistingUserID;
end;

//Read the lock record
function TProcessLockSQL.ReadExisting : Boolean;
var
  sQuery : AnsiString;
begin
  sQuery := Format('Select %s, %s, %s ' +
                   'From [COMPANY].[%s] ', [S_PROCESS_TYPE, S_USER_ID,
                                    S_TIMESTAMP, S_TABLE_NAME]);

  //even though we're only reading here we need to explicitly start a transaction
  //so we can read the uncommitted data from other transactions
  FSQLCaller.Connection.BeginTrans;
  Try
    FSQLCaller.Select(sQuery, FCompanyCode);

    if (FSQLCaller.ErrorMsg = '') then
    begin
      if (FSQLCaller.Records.RecordCount > 0) then
      with FSQLCaller.Records do
      begin
        First;
        FExistingProcessLockType := TProcessLockType(FieldByName(S_PROCESS_TYPE).AsInteger);
        FExistingUserID := FieldByName(S_USER_ID).AsString;
        FExistingTimestamp := FieldByName(S_TIMESTAMP).AsString;
      end
      else
      begin
        FExistingProcessLockType := plNone;
        FExistingUserID := '';
        FExistingTimestamp := '';
      end;
    end;

  Finally
    FSQLCaller.Connection.CommitTrans;
  End;


  Result := FSQLCaller.ErrorMsg = '';
end;

procedure TProcessLockSQL.ReleaseLock;
begin
  if FSQLCaller.Connection.InTransaction then
    FSQLCaller.Connection.RollbackTrans;
end;

end.
