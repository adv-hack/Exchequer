unit BtrvSQLU;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

type
  { Function type declarations for DLL calls }
  TBTRCall = function(
                      operation: WORD;
                  var posblk;
                  var databuf;
                  var datalen  : WORD;
                  var keybuf;
                      keylen   : BYTE;
                      keynum   : Integer
                     ): SmallInt; StdCall;

  TBTRCallID = function(
                        operation: WORD;
                    var posblk;
                    var databuf;
                    var datalen  : WORD;
                    var keybuf;
                        keylen   : BYTE;
                        keynum   : Integer;
                    var clientid
                       ): SmallInt; StdCall;

  TWBTRVInit = function(var InitializationString): Integer; StdCall;

  TWBTRVStop = function: Integer; StdCall;

  TSQLCall = function
             (
               ClientID: PChar;
               SecuritySignature: PChar;
               Code: PChar
             ): Integer; stdcall;

  TSQLCreateDatabaseCall = function
             (
               ClientID: PChar;
               SecuritySignature: PChar;
               Code: PChar;
               Username: PChar;
               Password: PChar
             ): Integer; stdcall;

  TSQLCreateCompanyCall = function
                          (
                            SecuritySignature: PChar;
                            ClientId: PChar;
                            Username: PChar;
                            Password: PChar;
                            ReadonlyUsername: PChar;
                            ReadonlyPassword: PChar;
                            CompanyCode: PChar;
                            CompanyName: PChar;
                            ImportZipFileName: PChar
                          ): Integer; stdcall;

  TSQLConnectionStringCall = function
                             (
                               SecuritySignature: PChar;
                               ClientId: PChar;
                               CompanyCode: PChar;
                               ConnectionBuffer: Pointer;
                               BufferSize: Pointer
                             ): Integer; stdcall;

  TSQLImportExportCall = function
                         (
                           SecuritySignature: PChar;
                           CompanyCode: PChar;
                           FileName: PChar
                         ): Integer; stdcall;

  TSQLErrorInformationCall = function
                             (
                               ErrorCode: Integer;
                               ClientId: PChar;
                               ErrorBuffer: Pointer;
                               BufferSize: Pointer
                             ): Integer; stdcall;

  TSQLExclusiveAccessCall = function
                            (
                              SecuritySignature: PChar;
                              ClientId: PChar;
                              Users: Pointer
                            ): Integer; stdcall;

  TSQLCopyTableCall = function
                      (
                        SecuritySignature: PChar;
                        ExistingCompanyCode: PChar;
                        NewCompanyCode: PChar;
                        TableName: PChar;
                        WhereClause: PChar
                      ): Integer; stdcall;

  TSQLUpdateTableCall = function
                        (
                          SecuritySignature: PChar;
                          ClientId: PChar;
                          CompanyCode: PChar;
                          TableName: PChar;
                          SetValues: PChar;
                          WhereClause: PChar
                        ): Integer; stdcall;

  TSQLGetDBColumnNameCall = function
                            (
                              BtrieveFileName: PChar;
                              FieldName: PChar;
                              RecordType: PChar;
                              DBFieldNameBuffer: Pointer;
                              BufferSize: Pointer
                            ): Integer; stdcall;

{ Exported functions }
function BTRCALL(
                 ModuleName: PChar;
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                ) : SmallInt; StdCall;

function BTRCALLID(
                   ModuleName: PChar;
                   operation : WORD;
               var posblk;
               var databuf;
               var datalen   : WORD;
               var keybuf;
                   keylen    : BYTE;
                   keynum    : Integer;
               var clientid
                  ) : SmallInt; StdCall;


function WBTRVINIT(var InitializationString): Integer; StdCall;

function WBTRVSTOP: Integer; StdCall;

function CreateDatabase(ServerName, DatabaseName, UserName, Password: PChar): Integer; stdcall;
function CreateCompany(CompanyCode, CompanyName, CompanyPath, ZIPFileName, UserName, Password,
  ReadOnlyName, ReadOnlyPassword: PChar; ClientID: Pointer): Integer; stdcall;
function AttachCompany(CompanyCode: PChar; ClientID: Pointer): Integer; stdcall;
function DetachCompany(CompanyCode: PChar; ClientID: Pointer): Integer; stdcall;
function DeleteCompany(CompanyCode: PChar; ClientID: Pointer): Integer; stdcall;
function GetConnectionString(CompanyCode: PChar; GetReadOnly: Boolean; ClientID: Pointer): ShortString; stdcall;

function CopyTable(FromCompanyCode, ToCompanyCode, TableName, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;
function UpdateTable(CompanyCode, TableName, Values, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;
function GetDBColumnName(BtrieveFileName, FieldName, RecordType: PChar): ShortString; stdcall;

function OpenCompany(Path: PChar; ClientID: Pointer): Integer; stdcall;
function OpenCompanyByCode(Code: PChar): Integer; stdcall;
function GetCompanyCode(ForPath: PChar): ShortString; stdcall;

function TableExists(FileSpec: PChar; ClientID: Pointer): Integer; stdcall;
function DeleteTable(FileSpec: PChar; ClientID: Pointer): Integer; stdcall;
function ValidCompany(FilePath: PChar): Integer; stdcall;
function ValidSystem(ForPath: PChar): Integer; stdcall;
function HasExclusiveAccess(CompanyPath: PChar; ClientID: Pointer): Boolean; stdcall;

function ExportDataset(CompanyCode: PChar; FileName: PChar): Integer; stdcall;
function ImportDataset(CompanyCode: PChar; FileName: PChar): Integer; stdcall;

function GetErrorInformation(var ErrorCode: Integer): ShortString; stdcall;

function UsingSQL: Boolean; StdCall;

function OverrideUsingSQL(Value: Boolean): Integer; stdcall;

function Initialise(Path: PChar): Integer; stdcall;

function Load_DLL(Path: PChar): Boolean;

implementation

uses SysUtils, Classes, Windows, Registry, IniFiles, Dialogs, ActiveX,
  EntLic,
  LicRec,
{$IFDEF DEBUGON}
  DebugLogU,
{$ENDIF}
  SQLCompany;

var
  DLLHandle: Integer;
  DLLPath: AnsiString;

  { Function pointer variables }
  BTRCallFn:     TBTRCall;
  BTRCallIDFn:   TBTRCallID;
  WBTRVInitFn:   TWBTRVInit;
  WBTRVStopFn:   TWBTRVStop;

  CreateDatabaseFn:      TSQLCreateDatabaseCall;
  CreateCompanyFn:       TSQLCreateCompanyCall;
  DeleteCompanyFn:       TSQLCall;
  ConnectionStringFn:    TSQLConnectionStringCall;
  AttachCompanyFn:       TSQLCall;
  DetachCompanyFn:       TSQLCall;
  OpenCompanyFn:         TSQLCall;
  TableExistsFn:         TSQLCall;
  DeleteTableFn:         TSQLCall;
  ExportDatasetFn:       TSQLImportExportCall;
  ImportDatasetFn:       TSQLImportExportCall;
  GetSQLErrorInfoFn:     TSQLErrorInformationCall;
  HasExclusiveAccessFn:  TSQLExclusiveAccessCall;
  CopyTableFn:           TSQLCopyTableCall;
  UpdateTableFn:         TSQLUpdateTableCall;
  GetDBColumnNameFn:     TSQLGetDBColumnNameCall;

  IsSQL: Boolean;
  IsInitialised: Boolean;

  PreviousPath: string;
  CompanyCode: string;

const
  NOT_FOUND_MSG = 'Could not find %s function in database connection DLL.';

// =============================================================================
// Support Routines
// =============================================================================
procedure CheckOpenCompanyID(Path: string; var ClientID);

  function FilePath(FileSpec: string): string;
  const
    Files: array[0..21] of string =
    (
      'COMPANY.DAT',
      'TOOLS.DAT',
      'GROUPCMP.DAT',
      'GROUPS.DAT',
      'GROUPUSR.DAT',
      'CUST\CUSTSUPP.DAT',
      'FORMS\PAPRSIZE.DAT',
      'JOBS\JOBCTRL.DAT',
      'JOBS\JOBDET.DAT',
      'JOBS\JOBHEAD.DAT',
      'JOBS\JOBMISC.DAT',
      'MISC\EXCHQCHK.DAT',
      'MISC\EXSTKCHK.DAT',
      'MISC\SETTINGS.DAT',
      'REPORTS\DICTNARY.DAT',
      'STOCK\MLOCSTK.DAT',
      'STOCK\STOCK.DAT',
      'TRANS\DETAILS.DAT',
      'TRANS\DOCUMENT.DAT',
      'TRANS\HISTORY.DAT',
      'TRANS\NOMINAL.DAT',
      'TRANS\NOMVIEW.DAT'
    );
  var
    i: Integer;
    Found: Boolean;
    CheckPos, FoundPos: Integer;
  begin
    Result := '';
    Found  := False;
    for i := Low(Files) to High(Files) do
    begin
      CheckPos := Length(FileSpec) - (Length(Files[i]) - 1);
      FoundPos := Pos(Files[i], FileSpec);
      if FoundPos = CheckPos then
      begin
        Result := Copy(FileSpec, 1, FoundPos - 1);
        Found  := True;
        break;
      end;
    end;
    if not Found then
      Result := ExtractFilePath(FileSpec);
  end;

var
  NewCode: AnsiString;
  IsCompany: Boolean;
begin
{$IFDEF DEBUGON}
Log('CheckOpenCompanyID: ' + Path);
{$ENDIF}

  Path := Uppercase(Path);

  IsCompany := (Pos('COMPANY.DAT', Path) = (Length(Path) - 10));
  if not IsCompany then
  begin
    Path := FilePath(Path);
    if (Path <> PreviousPath) then
    begin
      PreviousPath := Path;
      NewCode := FindCompanyCodeFromSubFolder(Path, Pointer(ClientID));
      if (NewCode = '') then
      begin
        { Error -- no matching company path could be found. }
{$IFDEF DEBUGON}
Log('CheckOpenCompanyID: Could not find matching company');
{$ENDIF}
      end
      else
      begin
        { Does this differ from the last company path? If so, open the new
          company. }
        if (NewCode <> CompanyCode) then
        begin
{$IFDEF DEBUGON}
Log('CheckOpenCompanyID: Changing from "' + CompanyCode + '" to "' + NewCode + '"');
{$ENDIF}
          CompanyCode := NewCode;
          OpenCompany(PChar(Path), PChar(ClientID));
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure CheckOpenCompany(Path: string);
var
  ClientID: Pointer;
begin
  ClientID := nil;
  CheckOpenCompanyID(Path, ClientID);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Licence functions
// =============================================================================
function GetOLEServerPath(var OLEServerPath: ShortString): Boolean;
var
  TmpStr : ShortString;
begin
  OLEServerPath := '';
  with TRegistry.Create do
  begin
    try
      Access := KEY_READ;
      RootKey := HKEY_CURRENT_USER;
      if OpenKey('Software\Exchequer\Enterprise', False) then
      begin
        OLEServerPath := ReadString('InstallDir');
        CloseKey;
      end
      else
      begin
{$IFDEF DEBUGON}
Log('GetOLEServerPath: Could not open HKEY_CURRENT_USER\Software\Exchequer\Enterprise\InstallDir registry key. Looking for InstallDir instead.');
{$ENDIF}
        RootKey := HKEY_CLASSES_ROOT;
        // Open the OLE Server CLSID key to get the GUID to lookup in the
        // CLSID section - safer than hard-coding the GUID in the code
        if OpenKey('Enterprise.OLEServer\Clsid', False) then
        begin
          // Read CLSID stored in default entry }
          TmpStr := ReadString ('');
          CloseKey;
          // Got CLSID - find entry in CLSID Section and check for registered .EXE }
          if OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) then
          begin
            // Get path of registered OLE Server .Exe
            TmpStr := ReadString ('');
            // Check the OLE Server actually exists and return the path if OK
            if FileExists (TmpStr) then
            begin
              OLEServerPath := ExtractFilePath(TmpStr);
            end;
            CloseKey;
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
{$IFDEF DEBUGON}
Log('GetOLEServerPath: path "' + OLEServerPath + '"');
{$ENDIF}
  // Check the path being returned is set
  Result := (Trim(OLEServerPath) <> '');
end; // GetOLEServerPath

// -----------------------------------------------------------------------------

function GetLocalProgramsPath(AppDir: ShortString; var LPFPath: ShortString): Boolean;
begin // GetLocalProgramsPath
  with TIniFile.Create(AppDir + 'ENTWREPL.INI') Do
  Begin
    Try
      LPFPath := ReadString ('UpdateEngine', 'NetworkDir', '');
    Finally
      Free;
    End; // Try..Finally
  End; // With TIniFile.Create (FAppsDir + 'ENTWREPL.INI')
  // Check the path being returned
  Result := (Trim(LPFPath) <> '');
  LPFPath := IncludeTrailingPathDelimiter(LPFPath);
End; // GetLocalProgramsPath

// -----------------------------------------------------------------------------

function InitLicence(Path: string): Boolean;
var
  LocalDir, Dir: ShortString;
  LicR : EntLicenceRecType;
type
  TelDatabaseType = (dbBtrieve=0, dbMSSQL=1);
begin
  if (Path <> '') then
    Dir := Path
  else
  begin
    Result := GetOLEServerPath(Dir);
    if not Result then
      ShowMessage('The OLE Server on this workstation is incorrectly configured, please contact your Technical Support');
  end;

  // Check for Local Program Files
  if FileExists(IncludeTrailingPathDelimiter(Dir) + 'ENTWREPL.INI') Then
  begin
    // Get the path from EntWRepl.Ini
    if GetLocalProgramsPath(Dir, LocalDir) then
      Dir := LocalDir;
  end;

{$IFDEF DEBUGON}
Log('InitLicence: reading licence from "' + IncludeTrailingPathDelimiter(Dir) + EntLicFName + '"');
{$ENDIF}

  Result := ReadEntLic(IncludeTrailingPathDelimiter(Dir) + EntLicFName, LicR);
  if not Result then
  begin
    ShowMessage('Unable to read Licence Information ' + Dir);
//    raise Exception.Create('Unable to read Licence Information ' + Dir);
  end;

{$IFDEF DEBUGON}
Log('InitLicence: licence details read. Database type: ' + IntToStr(Ord(TelDatabaseType(LicR.licEntDB))));
{$ENDIF}

  IsSQL := (TelDatabaseType(LicR.licEntDB) = dbMSSQL);
//  IsSQL := True;
end;

// =============================================================================
// Exported DLL functions
// =============================================================================
function Initialise(Path: PChar): Integer; stdcall;
begin
{$IFDEF DEBUGON}
Log('Initialising BtrvSQL: ' + Path);
{$ENDIF}
  if not Load_DLL(Path) then
    Result := -1
  else
  begin
    Result := 0;
    IsInitialised := True;
  end;
end;

// -----------------------------------------------------------------------------

function BTRCALL(
                 ModuleName: PChar;
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                 ) : SmallInt;
begin
{$IFDEF DEBUGON}
Log('BTRCALL: module ' + ModuleName + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));
{$ENDIF}
  if IsSQL and (operation = 0) then
    CheckOpenCompany(PChar(@keybuf));
  Result := BTRCallFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum);
{$IFDEF DEBUGON}
if (Result <> 0) then
  Log('BTRCALL failed: ' + IntToStr(Result) + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));
{$ENDIF}
end;

// -----------------------------------------------------------------------------

function BTRCALLID(
                 ModuleName: PChar;
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer;
             var clientid     ) : SmallInt;
begin
{$IFDEF DEBUGON}
Log('BTRCALLID: module ' + ModuleName + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));
{$ENDIF}
  if IsSQL and (operation = 0) then
    CheckOpenCompanyID(PChar(@keybuf), clientid);
  Result := BTRCallIDFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum, clientid);
{$IFDEF DEBUGON}
if (Result <> 0) then
  Log('BTRCALLID failed: ' + IntToStr(Result) + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));
{$ENDIF}
end;

// -----------------------------------------------------------------------------

function WBTRVINIT(var InitializationString): Integer;
begin
  Result := WBTRVInitFn(InitializationString);
end;

// -----------------------------------------------------------------------------

function WBTRVSTOP: Integer;
begin
  Result := WBTRVStopFn;
end;

// -----------------------------------------------------------------------------

function UsingSQL: Boolean;
begin
  Result := IsSQL;
end;

// -----------------------------------------------------------------------------

function CreateDatabase(ServerName, DatabaseName, UserName, Password: PChar): Integer;
var
  FuncRes: Integer;
begin
  FuncRes := CreateDatabaseFn('WMIT_CD', ServerName, DatabaseName,
                              UserName, Password);
  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

function CreateCompany(CompanyCode, CompanyName, CompanyPath, ZIPFileName, UserName, Password,
  ReadOnlyName, ReadOnlyPassword: PChar; ClientID: Pointer): Integer;
var
  ErrMsg: string;
begin
{$IFDEF DEBUGON}
Log('CreateCompany: "' + CompanyCode + '"');
{$ENDIF}
  Result :=
    CreateCompanyFn(
      'WMIT_CC',
      PChar(ClientID),
      UserName,
      Password,
      ReadOnlyName,
      ReadOnlyPassword,
      CompanyCode,
      CompanyName,
      ZIPFileName
    );
  if (Result = 0) then
  begin
    Result := CompanyTable.Add(CompanyCode, CompanyName, CompanyPath, (Pos('DEMO', Uppercase(ZIPFileName)) <> 0));
    if (Result <> 0) then
    begin
{$IFDEF DEBUGON}
Log('CreateCompany failed, error ' + IntToStr(Result));
{$ENDIF}
    end;
  end
  else
  begin
{$IFDEF DEBUGON}
ErrMsg := GetErrorInformation(Result);
Log('CreateCompany failed, error ' + IntToStr(Result) + ': ' + ErrMsg);
{$ENDIF}
  end;
end;

// -----------------------------------------------------------------------------

function DeleteCompany(CompanyCode: PChar; ClientID: Pointer): Integer;
begin
  Result := DeleteCompanyFn('WMIT_DC', PChar(ClientID), CompanyCode);
  if (Result = 0) then
    Result := CompanyTable.Delete(CompanyCode, ClientID);
end;

// -----------------------------------------------------------------------------

function AttachCompany(CompanyCode: PChar; ClientID: Pointer): Integer;
begin
  Result := AttachCompanyFn('WMIT_AC', PChar(ClientID), CompanyCode);
end;

// -----------------------------------------------------------------------------

function DetachCompany(CompanyCode: PChar; ClientID: Pointer): Integer;
begin
  Result := DetachCompanyFn('WMIT_DC', PChar(ClientID), CompanyCode);
end;

// -----------------------------------------------------------------------------

function GetConnectionString(CompanyCode: PChar; GetReadOnly: Boolean; ClientID: Pointer): ShortString;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    FuncRes := ConnectionStringFn('WMIT_GCG', PChar(ClientID), CompanyCode, @Buffer, @BufferSize);
    if (FuncRes <> 0) then
      raise Exception.Create('GetConnectionString call failed: ' + IntToStr(FuncRes))
    else
      Result := Trim(Buffer);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function OpenCompany(Path: PChar; ClientID: Pointer): Integer;
var
  CodeStr: AnsiString;
begin
  if IsSQL then
  begin
    CodeStr := FindCompanyCode(Path);
    Result := OpenCompanyFn('WMIT_OC', PChar(ClientID), PChar(CodeStr));
  end
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

function OpenCompanyByCode(Code: PChar): Integer;
begin
  if IsSQL then
  begin
    Result := OpenCompanyFn('WMIT_OC', nil, PChar(Code));
  end
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

function GetCompanyCode(ForPath: PChar): ShortString;
begin
  Result := FindCompanyCode(ForPath);
end;

// -----------------------------------------------------------------------------

function ValidCompany(FilePath: PChar): Integer;
begin
  Result := 4;
{$IFDEF DEBUGON}
Log('ValidCompany: "' + FilePath + '"');
{$ENDIF}
  if (CompanyTable.FindByPath(FilePath) <> '') and
     (DirectoryExists(FilePath)) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

function ValidSystem(ForPath: PChar): Integer;
begin
  Result := 4;
  if (CompanyTable.FindByPath(ForPath) <> '') and
     (DirectoryExists(DelimitedPath(ForPath) + 'LIB')) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

function TableExists(FileSpec: PChar; ClientID: Pointer): Integer;
var
  FileName: AnsiString;
begin
  if UsingSQL then
  begin
    FileName := ExtractFileName(FileSpec);
    Result := TableExistsFn('WMIT_TE', PChar(ClientID), PChar(FileName));
  end
  else
  begin
    if FileExists(FileSpec) then
      Result := 0
    else
      Result := 3;
  end;
end;

// -----------------------------------------------------------------------------

function DeleteTable(FileSpec: PChar; ClientID: Pointer): Integer;
var
  FileName, FilePath: AnsiString;
  FuncRes: LongInt;
begin
  Result := 0;
  if UsingSQL then
  begin
    FilePath := ExtractFilePath(FileSpec);
    FileName := ExtractFileName(FileSpec);
    if ValidCompany(PChar(FilePath)) = 0 then
    begin
      FuncRes := DeleteTableFn('WMIT_DT', PChar(ClientID), PChar(FileName));
      if (FuncRes <> 0) and (FuncRes <> 3) then
      begin

      end;
      Result := FuncRes;
    end;
  end
  else
  begin
    FileName := FileSpec;
    DeleteFile(PChar(FileName));
  end;
end;

// -----------------------------------------------------------------------------

function HasExclusiveAccess(CompanyPath: PChar; ClientID: Pointer): Boolean;
var
  Users: Integer;
begin
  Users := 0;
  HasExclusiveAccessFn('WMIT_XA', PChar(ClientID), @Users);
  Result := (Users < 2);
end;

// -----------------------------------------------------------------------------

function ExportDataset(CompanyCode: PChar; FileName: PChar): Integer;
begin
  Result := ExportDatasetFn('WMIT_XD', CompanyCode, FileName);
end;

// -----------------------------------------------------------------------------

function ImportDataset(CompanyCode: PChar; FileName: PChar): Integer;
begin
  Result := ImportDatasetFn('WMIT_ID', CompanyCode, FileName);
end;

// -----------------------------------------------------------------------------

function GetErrorInformation(var ErrorCode: Integer): ShortString;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    FuncRes := GetSQLErrorInfoFn(ErrorCode, nil, @Buffer, @BufferSize);
    ErrorCode := FuncRes;
    Result := Trim(Buffer);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function CopyTable(FromCompanyCode, ToCompanyCode, TableName, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;
begin
  Result := CopyTableFn('WMIT_CT', FromCompanyCode, ToCompanyCode, TableName, WhereClause);
//  Result := CopyTableFn('WMIT_CT', 'ZZZZ01', 'ZZZZ02', 'JOBDET.DAT', '(RecpFix = ''J'' and SubType=''M'')');
end;

// -----------------------------------------------------------------------------

function UpdateTable(CompanyCode, TableName, Values, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;
begin
  Result := UpdateTableFn('WMIT_UT', PChar(ClientId), CompanyCode, TableName, Values, WhereClause);
end;

// -----------------------------------------------------------------------------

function GetDBColumnName(BtrieveFileName, FieldName, RecordType: PChar): ShortString; stdcall;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin
  { Prepare a buffer to hold the returned column name }
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    FuncRes := GetDBColumnNameFn(BtrieveFileName, FieldName, RecordType, @Buffer, @BufferSize);
    if (FuncRes = 0) then
      Result := Trim(Buffer)
    else
      Result := 'Not found';
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Internal DLL functions (for accessing the Btrieve or iCore DLLs)
// =============================================================================

function Load_DLL(Path: PChar): Boolean;
var
  ErrMsg: string;
  DLLSpec: AnsiString;
  DBType: string;
begin
  Result := False;
  ErrMsg := '';

  DBType := SysUtils.GetEnvironmentVariable('EXCHEQUERDBTYPE');
{$IFDEF DEBUGON}
Log('LoadDLL: DBType: "' + DBType + '"');
{$ENDIF}
  if (DBType = '0') then
    IsSql := False
  else if (DBType = '1') then
    IsSql := True;

  { Determine whether we are running Btrieve or SQL, and load the appropriate
    DLL. }
  DLLPath := Path;
  if (DLLPath <> '') then
    DLLPath := IncludeTrailingPathDelimiter(DLLPath);

  if IsSQL then
    DLLSpec := DLLPath + 'icorebtrv.dll'
  else
    DLLSpec := DLLPath + 'WBTRV32.DLL';

{$IFDEF DEBUGON}
Log('LoadDLL: "' + DLLSpec + '"');
{$ENDIF}

  DLLHandle := LoadLibrary(PChar(DLLSpec));

  { Try to get the function addresses from the DLL. }
  if DLLHandle <> 0 then
  begin
    @BTRCallFn            := GetProcAddress(DLLHandle, 'BTRCALL');
    @BTRCallIDFn          := GetProcAddress(DLLHandle, 'BTRCALLID');
    @WBTRVInitFn          := GetProcAddress(DLLHandle, 'WBTRVINIT');
    @WBTRVStopFn          := GetProcAddress(DLLHandle, 'WBTRVSTOP');
    if not Assigned(BTRCallFn) then
      ErrMsg := 'BTRCALL'
    else if not Assigned(BTRCallIDFn) then
      ErrMsg := 'BTRCALLID'
    else if not Assigned(WBTRVInitFn) then
      ErrMsg := 'WBTRVINIT'
    else if not Assigned(WBTRVStopFn) then
      ErrMsg := 'WBTRVSTOP';
    if (ErrMsg = '') and IsSQL then
    begin
      @CreateDatabaseFn     := GetProcAddress(DLLHandle, 'CreateDatabase');
      @CreateCompanyFn      := GetProcAddress(DLLHandle, 'CreateCompany');
      @DeleteCompanyFn      := GetProcAddress(DLLHandle, 'DeleteCompany');
      @OpenCompanyFn        := GetProcAddress(DLLHandle, 'OpenCompany');
      @TableExistsFn        := GetProcAddress(DLLHandle, 'TableExists');
      @DeleteTableFn        := GetProcAddress(DLLHandle, 'DeleteTable');
      @AttachCompanyFn      := GetProcAddress(DLLHandle, 'AttachCompany');
      @DetachCompanyFn      := GetProcAddress(DLLHandle, 'DetachCompany');
      @ConnectionStringFn   := GetProcAddress(DLLHandle, 'GetConnectionString');
      @ExportDatasetFn      := GetProcAddress(DLLHandle, 'ExportDataset');
      @ImportDatasetFn      := GetProcAddress(DLLHandle, 'ImportDataset');
      @GetSQLErrorInfoFn    := GetProcAddress(DLLHandle, 'GetErrorInformation');
      @HasExclusiveAccessFn := GetProcAddress(DLLHandle, 'HasExclusiveAccess');
      @CopyTableFn          := GetProcAddress(DLLHandle, 'CopyTable');
      @UpdateTableFn        := GetProcAddress(DLLHandle, 'UpdateTable');
      @GetDBColumnNameFn    := GetProcAddress(DLLHandle, 'GetDbColumnNameFromSchemaName');
      if not Assigned(CreateDatabaseFn) then
        ErrMsg := 'CreateDatabase'
      else if not Assigned(CreateCompanyFn) then
        ErrMsg := 'CreateCompany'
      else if not Assigned(DeleteCompanyFn) then
        ErrMsg := 'DeleteCompany'
      else if not Assigned(OpenCompanyFn) then
        ErrMsg := 'OpenCompany'
      else if not Assigned(TableExistsFn) then
        ErrMsg := 'TableExists'
      else if not Assigned(DeleteTableFn) then
        ErrMsg := 'DeleteTable'
      else if not Assigned(AttachCompanyFn) then
        ErrMsg := 'AttachCompany'
      else if not Assigned(DetachCompanyFn) then
        ErrMsg := 'DetachCompany'
      else if not Assigned(ConnectionStringFn) then
        ErrMsg := 'GetConnectionString'
      else if not Assigned(ExportDatasetFn) then
        ErrMsg := 'ExportDataset'
      else if not Assigned(ImportDatasetFn) then
        ErrMsg := 'ImportDataset'
      else if not Assigned(HasExclusiveAccessFn) then
        ErrMsg := 'HasExclusiveAccess'
      else if not Assigned(GetSQLErrorInfoFn) then
        ErrMsg := 'GetErrorInformation'
      else if not Assigned(CopyTableFn) then
        ErrMsg := 'CopyTable'
      else if not Assigned(UpdateTableFn) then
        ErrMsg := 'UpdateTable'
      else if not Assigned(GetDBColumnNameFn) then
        ErrMsg := 'GetDbColumnNameFromSchemaName'
    end;
    if ErrMsg <> '' then
      ErrMsg := Format(NOT_FOUND_MSG, [ErrMsg])
    else
      { If we reach here, we have successfully loaded the DLL and
        obtained the addresses of all the required functions. }
      Result := True;
  end
  else
    ErrMsg := 'Unable to load database connection DLL: ' + DLLSpec;

  if not Result then
  begin
    ShowMessage(ErrMsg + ' Please contact your Technical Support');
    Result := False;
  end
  else
  begin
{
    if IsSQL then
      ShowMessage('SQL-aware BTRVU2 unit active, using SQL Server')
    else
      ShowMessage('SQL-aware BTRVU2 unit active, using Btrieve');
}
  end;

end;

// -----------------------------------------------------------------------------

procedure Unload_DLL;
begin
  if DLLHandle <> 0 then
    FreeLibrary(DLLHandle);
end;

// -----------------------------------------------------------------------------

function OverrideUsingSQL(Value: Boolean): Integer; stdcall;
begin
  IsSQL := Value;
  Unload_DLL;
{$IFDEF DEBUGON}
Log('OverrideUsingSQL');
{$ENDIF}

  if not Load_DLL(PChar(DLLPath)) then
    Result := -1
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

initialization

  PreviousPath := '';
  CompanyCode  := '';
  DLLPath      := '';
  IsInitialised := False;
  IsSQL := False;
{$IFDEF DEBUGON}
Log('Initialising BtrvSQL.DLL');
{$ENDIF}
  if not (Lowercase(ExtractFileName(ParamStr(0))) = 'delphi32.exe') then
  begin
    if not InitLicence('') then
    begin
      ShowMessage('Failed to initialise licence');
      Halt;
    end;
  end;
//  Coinitialize(nil);

finalization

  Unload_DLL;

end.

