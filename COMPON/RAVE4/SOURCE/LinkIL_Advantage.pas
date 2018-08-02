unit LinkIL_Advantage;

interface

uses
  AdsCnnct, Ace, AdsTable, AdsData,
  Classes,
  DB,
  LinkIL;

type
  TILLink_Advantage = class(TILLink)
  protected
    FAdsConnection: TAdsConnection;
    FAdsTableType: TAdsTableTypes;
  public
    procedure DoClose; override;
    procedure DoOpen; override;
    function ExecSQL(const ASQL: string; const ARows: integer): integer; override;
    function Generator(const AName: string; const ACount: integer = 1): integer; override;
    procedure GetTableList(ATableList: TStrings); override;
    procedure FillTableList(ATableList: TStrings); override;
    function Query(const ASQL: string; const AOpen: Boolean = True;
      const AParams: TStrings = nil): TDataset; override;
    procedure TransBegin; override;
    procedure TransEnd; override;
    procedure TransRollback; override;
  end;

implementation

uses
  AdsSet,
  Forms,
  ILConfig_Advantage, ILRegister,
  SysUtils, SyncObjs,
  Windows;

var
  ConnectNum: integer = 0;
  CS: TCriticalSection;

{ TILLink_Advantage }

procedure TILLink_Advantage.DoClose;
begin
  FreeAndNil(FAdsConnection);
end;

procedure TILLink_Advantage.DoOpen;
var
  OptionList: TStringList;
begin
  FAdsConnection := TAdsConnection.Create(Application);
  with FAdsConnection do begin
    CS.Enter;
    try
      Inc(ConnectNum);
      Name := 'AdsConnection' + IntToStr(ConnectNum);
    finally
      CS.Leave;
    end; { tryf }
//  LoginPrompt := False;      //Will need for 6.0 release
//  UserName := Self.UserName; //Will need for 6.0 release
//  Password :=                //Will need for 6.0 release
    OptionList := TStringList.Create;
    try
      OptionList.CommaText := Options;

    // Server type
      AdsServerTypes := [];
      If Pos('L',OptionList.Values['ServerTypes']) > 0 then begin
        AdsServerTypes := AdsServerTypes + [stADS_LOCAL];
      end; { if }
      If Pos('R',OptionList.Values['ServerTypes']) > 0  then begin
        AdsServerTypes := AdsServerTypes + [stADS_REMOTE];
      end; { if }
      If Pos('A',OptionList.Values['ServerTypes']) > 0  then begin
        AdsServerTypes := AdsServerTypes + [stADS_AIS];
      end; { if }

    // Database type
      If SameText(OptionList.Values['DatabaseType'],'DBF') then begin
        FAdsTableType := ttAdsCDX;
      end else begin
        FAdsTableType := ttAdsADT;
      end; { else }
    finally
      OptionList.Free;
    end; { tryf }
    ConnectPath := DataSource;
    IsConnected := True;
  end;
end;

function TILLink_Advantage.ExecSQL(const ASQL: string; const ARows: integer): integer;
begin
  with TAdsQuery(Query(ASQL, False)) do try
    ExecSQL;
    result := RowsAffected;
    if (ARows <> -1) and (result <> ARows) then begin
    	raise Exception.Create('Row count mismatch.');
    end;
  finally free; end;
end;

procedure TILLink_Advantage.FillTableList(ATableList: TStrings);
var
  SearchRec: TSearchRec;
  I1: integer;
  S1: string;
  FileExt: string;
  OptionList: TStringList;
begin
// Get database type
  OptionList := TStringList.Create;
  try
    OptionList.CommaText := Options;
    FileExt := OptionList.Values['DatabaseType'];
  finally
    OptionList.Free;
  end; { tryf }

// Get list of files
  I1 := SysUtils.FindFirst(IncludeTrailingBackslash(DataSource) + '*.' + FileExt,faAnyFile,SearchRec);
  While I1 = 0 do begin
    S1 := SearchRec.Name;
    SetLength(S1,Length(S1) - Length(ExtractFileExt(S1)));
    ATableList.Add(S1);
    I1 := SysUtils.FindNext(SearchRec);
  end; { while }
  SysUtils.FindClose(SearchRec);
end;

function TILLink_Advantage.Generator(const AName: string; const ACount: integer): integer;
begin
  with TAdsQuery('Select Gen_ID(' + AName + ', ' + IntToStr(ACount) + ') from Dual') do try
    Result := Fields[0].AsInteger;
  finally free; end;
end;

procedure TILLink_Advantage.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

function TILLink_Advantage.Query(const ASQL: string; const AOpen: Boolean = true;
 const AParams: TStrings = nil): TDataset;
begin
  result := TAdsQuery.Create(Application);
  with TAdsQuery(result) do begin
    DatabaseName := FAdsConnection.Name;
    SourceTableType := FAdsTableType;
    SQL.Text := ParamSQL(ASQL, AParams);
    if AOpen then begin
      Open;
    end;
  end;
end;

procedure TILLink_Advantage.TransBegin;
begin
  FAdsConnection.BeginTransaction;
  inherited;
end;

procedure TILLink_Advantage.TransEnd;
begin
  FAdsConnection.Commit;
  inherited;
end;

procedure TILLink_Advantage.TransRollback;
begin
  FAdsConnection.Rollback;
  inherited;
end;

initialization
  TILLinkRegistration.RegisterLink('Advantage', TILLink_Advantage, TformILConfigAdvantage);
  CS := TCriticalSection.Create;
finalization
  CS.Free;
  CS := nil;
end.