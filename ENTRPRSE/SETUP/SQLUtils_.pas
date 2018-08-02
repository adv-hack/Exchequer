unit SQLUtils;
{
  Interface into iCoreBtrv.DLL, which provides functions to connect to the
  SQL Emulator.
}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

type
  { Function type declarations for DLL calls }
  TSQLCall = function
             (
               SecuritySignature: PChar;
               ClientID: PChar;
               Code: PChar
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
                            CompanyName: PChar
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
                               ErrorBuffer: Pointer;
                               BufferSize: Pointer
                             ): Integer; stdcall;

  TSQLExclusiveAccessCall = function
                            (
                              SecuritySignature: PChar;
                              ClientId: PChar;
                              Users: Pointer
                            ): Integer; stdcall;
{
  INT ExportDataset(char* SecuritySignature, char* ClientId,
  char* CompanyCode, char* szFilename);

  INT ImportDataset(char* SecuritySignature, char* ClientId,
  char* CompanyCode, char* szFilename);

  INT HasExclusiveAccess(char* SecuritySignature, char* ClientId, int* Users);

  INT GetErrorInformation(int ErrorCode, char** ErrorBuffer, int ErrorBufferSize);
}

function CreateDatabase(ServerName, DatabaseName: string): Integer;
function CreateCompany(CompanyCode, CompanyName, UserName, Password,
  ReadOnlyName, ReadOnlyPassword: string; ClientID: Pointer = nil): Integer;
function AttachCompany(CompanyCode: string; ClientID: Pointer = nil): Integer;
function DetachCompany(CompanyCode: string; ClientID: Pointer = nil): Integer;
function GetConnectionString(CompanyCode: string; GetReadOnly: Boolean; ClientID: Pointer): string;

function OpenCompany(Code: string; ClientID: Pointer = nil): Integer;
function TableExists(FileSpec: string; ClientID: Pointer = nil): Boolean;
function DeleteTable(FileSpec: string; ClientID: Pointer = nil): Integer;
function ValidCompany(FilePath: string): Boolean;
function ValidSystem(const ForPath: string): Boolean;
function ExclusiveAccess(const ForPath: string; ClientID: Pointer = nil): Boolean;

function ExportSQLDataset(CompanyCode: string; FileName: string): Integer;
function ImportSQLDataset(CompanyCode: string; FileName: string): Integer;

function GetSQLErrorInformation(ErrorCode: Integer): string;

//function UsingSQL: Boolean; external 'BtrvSQL.DLL';

implementation

uses SysUtils, Windows, Dialogs;

var
  DLLHandle: Integer;

  { Function pointer variables }
  CreateDatabaseFn:      TSQLCall;
  CreateCompanyFn:       TSQLCreateCompanyCall;
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

const
  NOT_FOUND_MSG = 'Could not find %s function in database connection DLL.';

function CreateDatabase(ServerName, DatabaseName: string): Integer;
var
  FuncRes: Integer;
  ServerStr, DatabaseStr: string;
begin
  ServerStr := ServerName;
  DatabaseStr := DatabaseName;
  FuncRes := CreateDatabaseFn('WMIT_CD', PChar(ServerStr), PChar(DatabaseStr));
  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

function CreateCompany(CompanyCode, CompanyName, UserName, Password,
  ReadOnlyName, ReadOnlyPassword: string; ClientID: Pointer): Integer;
begin
  Result :=
    CreateCompanyFn(
      'WMIT_CC',
      ClientID,
      PChar(UserName),
      PChar(Password),
      PChar(ReadOnlyName),
      PChar(ReadOnlyPassword),
      PChar(CompanyCode),
      PChar(CompanyName)
    );
end;

// -----------------------------------------------------------------------------

function AttachCompany(CompanyCode: string; ClientID: Pointer): Integer;
begin
  Result := AttachCompanyFn('WMIT_AC', ClientID, PChar(CompanyCode));
end;

// -----------------------------------------------------------------------------

function DetachCompany(CompanyCode: string; ClientID: Pointer): Integer;
begin
  Result := DetachCompanyFn('WMIT_DC', ClientID, PChar(CompanyCode));
end;

// -----------------------------------------------------------------------------

function GetConnectionString(CompanyCode: string; GetReadOnly: Boolean; ClientID: Pointer): string;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    FuncRes := ConnectionStringFn('WMIT_GCG', ClientID, PChar(CompanyCode), @Buffer, @BufferSize);
    if (FuncRes <> 0) then
      raise Exception.Create('Connection String call failed: ' + IntToStr(FuncRes))
    else
      Result := Trim(Buffer);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function OpenCompany(Code: string; ClientID: Pointer): Integer;
begin
  Result := OpenCompanyFn('WMIT_OC', ClientID, PChar(Code));
end;

// -----------------------------------------------------------------------------

function ValidCompany(FilePath: string): Boolean;
begin
//  Result := (CompanyTable.FindByPath(FilePath) <> '');
//  if Result then
//    { Make sure the directory actually exists. }
//    Result := DirectoryExists(FilePath);
end;

// -----------------------------------------------------------------------------

function ValidSystem(const ForPath: string): Boolean;
begin
//  { It must be a valid company... }
//  Result := (CompanyTable.FindByPath(ForPath) <> '');
//  { ...but also, it must have a LIB sub-folder (companies which are not the
//    main company will not have this). }
//  if Result then
//    Result := DirectoryExists(DelimitedPath(ForPath) + 'LIB');
end;

// -----------------------------------------------------------------------------

function TableExists(FileSpec: string; ClientID: Pointer): Boolean;
var
  FileName, FilePath: string;
  FuncRes: LongInt;
begin
//  if UsingSQL then
//  begin
//    FilePath := ExtractFilePath(FileSpec);
//    FileName := ExtractFileName(FileSpec);
//    if ValidCompany(FilePath) then
//    begin
//      FuncRes := TableExistsFn('WMIT_FE', ClientID, PChar(FileName));
//      case FuncRes of
//        0:  Result := True;
//        3:  Result := False;
//      else
//        Result := False;
//      end;
//    end
//    else
//      Result := False;
//  end
//  else
//    Result := FileExists(FileSpec);
end;

// -----------------------------------------------------------------------------

function DeleteTable(FileSpec: string; ClientID: Pointer): Integer;
var
  FileName, FilePath: string;
  FuncRes: LongInt;
begin
  Result := 0;
//  if UsingSQL then
//  begin
//    FilePath := ExtractFilePath(FileSpec);
//    FileName := ExtractFileName(FileSpec);
//    if ValidCompany(FilePath) then
//    begin
//      FuncRes := DeleteTableFn('WMIT_DF', ClientID, PChar(FileName));
//      if (FuncRes <> 0) and (FuncRes <> 3) then
//      begin
//
//      end;
//      Result := FuncRes;
//    end;
//  end
//  else
//  begin
//    FileName := FileSpec;
//    DeleteFile(PChar(FileName));
//  end;
end;

// -----------------------------------------------------------------------------

function ExclusiveAccess(const ForPath: string; ClientID: Pointer): Boolean;
var
  CompanyCode: string;
  Users: Integer;
begin
//  CompanyCode := FindCompanyCode(ForPath);
//  if (Trim(CompanyCode) <> '') then
//  begin
//    HasExclusiveAccessFn('WMIT_XA', ClientID, @Users);
//    Result := (Users = 1);
//  end
//  else
//    { Not a valid company path. }
//    Result := False;
end;

// -----------------------------------------------------------------------------

function ExportSQLDataset(CompanyCode: string; FileName: string): Integer;
begin
  Result := ExportDatasetFn('WMIT_XD', PChar(CompanyCode), PChar(FileName));
end;

// -----------------------------------------------------------------------------

function ImportSQLDataset(CompanyCode: string; FileName: string): Integer;
begin
  Result := ImportDatasetFn('WMIT_ID', PChar(CompanyCode), PChar(FileName));
end;

// -----------------------------------------------------------------------------

function GetSQLErrorInformation(ErrorCode: Integer): string;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    FuncRes := GetSQLErrorInfoFn(ErrorCode, @Buffer, @BufferSize);
    if (FuncRes <> 0) then
      raise Exception.Create('Get Information call failed: ' + IntToStr(FuncRes))
    else
      Result := Trim(Buffer);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// DLL functions (for accessing the iCore DLL)
// =============================================================================
function Load_DLL: Boolean;
var
  ErrMsg: string;
begin
  Result := False;
  ErrMsg := '';

  DLLHandle := LoadLibrary('icorebtrv.dll');

  { Try to get the function addresses from the DLL. }
  if DLLHandle <> 0 then
  begin
    @CreateDatabaseFn     := GetProcAddress(DLLHandle, 'CreateDatabase');
    @CreateCompanyFn      := GetProcAddress(DLLHandle, 'CreateCompany');
    @OpenCompanyFn        := GetProcAddress(DLLHandle, 'OpenCompany');
    @TableExistsFn        := GetProcAddress(DLLHandle, 'TableExists');
    @DeleteTableFn        := GetProcAddress(DLLHandle, 'DeleteTable');
    @AttachCompanyFn      := GetProcAddress(DLLHandle, 'AttachCompany');
    @DetachCompanyFn      := GetProcAddress(DLLHandle, 'DetachCompany');
    @ConnectionStringFn   := GetProcAddress(DLLHandle, 'GetConnectionString');
    @ExportDatasetFn      := GetProcAddress(DLLHandle, 'ExportDataset');
    @ImportDatasetFn      := GetProcAddress(DLLHandle, 'ImportDataset');
    @GetSQLErrorInfoFn    := GetProcAddress(DLLHandle, 'GetErrorInformation');
    @HasExclusiveAccessFn := GetProcAddress(DLLHandle, 'HasExlusiveAccess');
    if not Assigned(CreateDatabaseFn) then
      ErrMsg := 'CreateDatabase'
    else if not Assigned(CreateCompanyFn) then
      ErrMsg := 'CreateCompany'
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
{
    else if not Assigned(GetSQLErrorInfoFn) then
      ErrMsg := 'GetErrorInformation'
}
    else
      { If we have reached here, we have successfully loaded the DLL and
        obtained the addresses of all the required functions. }
      Result := True;
    if ErrMsg <> '' then
      ErrMsg := Format(NOT_FOUND_MSG, [ErrMsg]);
  end
  else
    ErrMsg := 'Unable to load database connection DLL.';
  if not Result then
  begin
    ShowMessage(ErrMsg + ' Please contact your Technical Support');
    Result := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure Unload_DLL;
begin
  FreeLibrary(DLLHandle);
end;

// -----------------------------------------------------------------------------

initialization

//  if UsingSQL and not Load_DLL then
   if not Load_DLL then
    Halt;

finalization

//  if UsingSQL then
    Unload_DLL;

end.

