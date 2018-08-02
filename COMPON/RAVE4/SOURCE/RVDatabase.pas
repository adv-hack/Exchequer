{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVDatabase;

interface

uses
  {$IFDEF Linux}
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes,
  LinkIL,
  RVClass, RVDefine;

type
  TLinkInfo = class(TObject)
  public
    Link: TILLink;
    ThreadID: THandle;
    UseCount: Integer;
  end;

  TRaveDBAuth = class(TPersistent)
  protected
    FDatasource: string;
    FOptions: string;
    FPassword: string;
    FUsername: string;
  public
    procedure AssignTo(ADest: TPersistent); override;
    procedure Setup(ADatasource, AOptions, APassword, AUsername: string);
  published
    property Datasource: string read FDatasource write FDatasource;
    property Options: string read FOptions write FOptions;
    property Password: string read FPassword write FPassword;
    property Username: string read FUsername write FUsername;
  end;

  TRaveDatabase = class(TRaveDataObject)
  protected
    FAuth: TRaveDBAuth;
    FAuthDesign: TRaveDBAuth;
    FAuthRun: TRaveDBAuth;
    //TODO: Change TThreadList to use a TReadWriteSynchronizer
    FLinkList: TThreadList; // List of active Links
    FLinkPool: TThreadList; // List of available Links
    FLinkPoolSize: integer;
    FLinkType: string;
    //
    // ConstructLink is used to create new instances of TILLink
    function ConstructLink: TILLink;
    procedure SetAuthDesign(AValue: TRaveDBAuth);
    procedure SetAuthRun(AValue: TRaveDBAuth);
    class function UseMaster: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindLinkForThread: TLinkInfo;
    function FindLink(ALink: TILLink): TLinkInfo;
    procedure InitPool;
    // GetLink is called by TRVSQLDataview to obtain a reference for a thread
    function GetLink: TILLink;
    procedure ReleaseLink(ALink: TILLink);
  published
    property AuthDesign: TRaveDBAuth read FAuthDesign write SetAuthDesign;
    property AuthRun: TRaveDBAuth read FAuthRun write SetAuthRun;
    property LinkPoolSize: integer read FLinkPoolSize write FLinkPoolSize;
    property LinkType: string read FLinkType write FLinkType;
  end;

// Procs
  procedure RaveRegister;

var
  GAuthRunOverride: boolean = false;

implementation

uses
  {$IFDEF Linux}
  Libc,
  {$ENDIF}
  ILConfig,
  RPDefine,
  SysUtils;

procedure RaveRegister;
begin { RaveRegister }
{TransOff}
  RegisterRaveComponents('',[TRaveDatabase]);
  RegisterRaveDataObject('Database Connection',TRaveDatabase);

{!!! RegisterRaveModuleClasses('RVData',[TRaveDataView]); }

{$IFDEF DESIGNER}
  RegisterRaveProperties(TRaveDatabase,
   {Beginner}     'Datasource;DesignDatasource;LinkType;Options;Password;Username',
   {Intermediate} '',
   {Developer}    '',
   {Hidden}       '');

  SetPropDesc(TRaveDatabase,'AuthDesign',Trans('Defines the parameters ' +
   'used to establish a database connection when designing reports.'));
  SetPropDesc(TRaveDatabase,'AuthRun',Trans('Defines the parameters ' +
   'used to establish a database connection when the reports are deployed to an ' +
   'application or reporting server.'));
  SetPropDesc(TRaveDatabase,'LinkPoolSize',Trans('The initial size of the connection ' +
   'pool to create when running on the reporting server.'));
  SetPropDesc(TRaveDatabase,'LinkType',Trans('The type of database connection ' +
   'to create.'));
{$ENDIF}
{TransOn}
end;  { RaveRegister }

{ TRaveDatabase }

function TRaveDatabase.ConstructLink: TILLink;
begin
  result := TILLink.ConstructLink(LinkType);
  with FAuth do begin
    result.Datasource := DataSource;
    result.Username := Username;
    result.Password := Password;
    result.Options := Options;
  end;
  result.Open;
end;

constructor TRaveDatabase.Create(AOwner: TComponent);
begin
  inherited;
  FAuthDesign := TRaveDBAuth.Create;
  FAuthRun := TRaveDBAuth.Create;
  if InDesigner or GAuthRunOverride then begin
    FAuth := AuthDesign;
  end else begin
    FAuth := AuthRun;
  end;
end;

destructor TRaveDatabase.Destroy;
var
  I1: integer;
begin
  If Assigned(FLinkList) then begin
    With FLinkList.LockList do try
      While Count > 0 do begin
        ReleaseLink(TILLink(Items[0]));
      end; { while }
    finally
      FLinkList.UnlockList;
    end; { with }
    FreeAndNil(FLinkList);
  end; { if }

  If Assigned(FLinkPool) then begin
    With FLinkPool.LockList do try
      For I1 := 0 to Count - 1 do begin
        TILLink(Items[I1]).Free;
      end; { for }
    finally
      FLinkPool.UnlockList;
    end; { with }
    FreeAndNil(FLinkPool);
  end;
  FreeAndNil(FAuthDesign);
  FreeAndNil(FAuthRun);
  inherited;
end;

function TRaveDatabase.FindLink(ALink: TILLink): TLinkInfo;
var
  i: integer;
begin
  Result := nil;
  If not Assigned(FLinkList) then Exit;
  with FLinkList.LockList do try
    for i := 0 to Count - 1 do begin
      if TLinkInfo(Items[i]).Link = ALink then begin
        result := TLinkInfo(Items[i]);
      end;
    end;
  finally FLinkList.UnlockList; end;
end;

function TRaveDatabase.FindLinkForThread: TLinkInfo;
var
  i: integer;
begin
  If not Assigned(FLinkList) then begin
    Result := nil;
  end else begin
    with FLinkList.LockList do try
      Result := nil;
      for i := 0 to Count - 1 do begin
        if TLinkInfo(Items[i]).ThreadID = GetCurrentThreadID then begin
          Result := TLinkInfo(Items[i]);
        end;
      end;
    finally FLinkList.UnlockList; end;
  end; { if }
end;

function TRaveDatabase.GetLink: TILLink;
var
  LLinkInfo: TLinkInfo;
  FPool: TList;
begin
  LLinkInfo := FindLinkForThread;
  if LLinkInfo = nil then begin
    LLinkInfo := TLinkInfo.Create;
    if FLinkPool <> nil then begin
      FPool := FLinkPool.LockList; try
        if FPool.Count > 0 then begin
          LLinkInfo.Link := TILLink(FPool[0]);
          FPool.Delete(0);
        end;
      finally FLinkPool.UnlockList; end;
    end;
    if LLinkInfo.Link = nil then begin
      LLinkInfo.Link := ConstructLink;
    end;
    If not Assigned(FLinkList) then begin
      FLinkList := TThreadList.Create;
    end; { if }
    FLinkList.Add(LLinkInfo);
  end;
  LLinkInfo.UseCount := LLinkInfo.UseCount + 1;
  result := LLinkInfo.Link;
end;

procedure TRaveDatabase.InitPool;
var
  i: integer;
  FPool: TList;
begin
  FLinkPool := TThreadList.Create;
  FPool := FLinkPool.LockList; try
    for i := 1 to LinkPoolSize do begin
      FPool.Add(ConstructLink);
    end;
  finally FLinkPool.UnlockList; end;
end;

procedure TRaveDatabase.ReleaseLink(ALink: TILLink);
var
  LLinkInfo: TLinkInfo;
  FPool: TList;
begin
  LLinkInfo := FindLink(ALink);
  if Assigned(LLinkInfo) then begin
    LLinkInfo.UseCount := LLinkInfo.UseCount - 1;
    if LLinkInfo.UseCount = 0 then begin
      if FLinkPool <> nil then begin
        FPool := FLinkPool.LockList; try
          if FPool.Count < LinkPoolSize then begin
            FPool.Add(LLinkInfo.Link);
          end else begin
            FreeAndNil(LLinkInfo.Link);
          end;
        finally FLinkPool.UnlockList; end;
      end else begin
        FreeAndNil(LLinkInfo.Link);
      end;
      FLinkList.Remove(LLinkInfo);
      FreeAndNil(LLinkInfo);
    end;
  end;
end;

procedure TRaveDatabase.SetAuthDesign(AValue: TRaveDBAuth);
begin
  FAuthDesign.Assign(AValue);
end;

procedure TRaveDatabase.SetAuthRun(AValue: TRaveDBAuth);
begin
  FAuthRun.Assign(AValue);
end;

class function TRaveDatabase.UseMaster: boolean;
begin
  Result := true;
end;

{ TRaveDBAuth }

procedure TRaveDBAuth.AssignTo(ADest: TPersistent);
var
  LDest: TRaveDBAuth;
begin
  if ADest is TRaveDBAuth then begin
    LDest := TRaveDBAuth(ADest);
    LDest.Datasource := Datasource;
    LDest.Options := Options;
    LDest.Password := Password;
    LDest.Username := Username;
  end else begin
    inherited;
  end;
end;

procedure TRaveDBAuth.Setup(ADatasource, AOptions, APassword, AUsername: string);
begin
  Datasource := ADatasource;
  Options := AOptions;
  Password := APassword;
  Username := AUsername;
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
