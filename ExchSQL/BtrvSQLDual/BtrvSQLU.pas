unit BtrvSQLU;
{
  This is a replacement for the standard BtrvSQL database access unit, and is
  for use by plug-ins which need to support Btrieve files on a system which
  might be using SQL for the main Exchequer database.

  It should be compiled using the EXSQL and the EXBTRVPLUGIN directives. It will
  always route database access through Btrieve, regardless of the database
  backend used by the installed Exchequer system.

  It omits all the functions which are only used under SQL.
}

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


{ === Exported functions ===================================================== }

{
  The four Btrieve functions, BTRCALL, BTRCALLID, WBTRVINIT, and WBTRVSTOP, can
  be called under both Btrieve and the SQL Emulator -- the calls will be
  directed to the appropriate database access DLL.

  Most of the other functions in this unit should only be called when running
  under the SQL Emulator (exceptions are noted in the descriptions of the
  individual functions).
}
function BTRCALL(
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                ) : SmallInt; StdCall;

function BTRCALLID(
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

function ValidCompany(FilePath: PChar): Integer; stdcall;
function ValidSystem(ForPath: PChar): Integer; stdcall;

procedure EnteringModule(ModuleName: PChar); stdcall;
procedure LeavingModule(ModuleName: PChar); stdcall;

{
  Initialise loads the appropriate DLL from the specified path. If the path is
  not specified, the DLL will be loaded from the Exchequer installation path.

  There is generally no need to call this function, and it is called
  automatically (with no path) from the first call to BTRCall or BTRCallID, if
  it has not already been called.

  The path is normally only used by the Setup program (which *does* call this
  function), because it will be run from a path other than the installation
  path, and needs to tell this DLL where to find the database-access DLLs.
}
function Initialise(Path: PChar): Integer; stdcall;

function Load_DLL(Path: PChar): Boolean;

implementation

uses SysUtils, Classes, Windows, Registry, IniFiles, Dialogs, ActiveX,
  EntLic,
  LicRec,
  DebugLogU;

var
  DLLHandle: Integer;
  DLLPath: AnsiString;

  { Function pointer variables }
  BTRCallFn:     TBTRCall;
  BTRCallIDFn:   TBTRCallID;
  WBTRVInitFn:   TWBTRVInit;
  WBTRVStopFn:   TWBTRVStop;

  IsInitialised: Boolean;

const
  NOT_FOUND_MSG = 'Could not find %s function in database connection DLL.';

// =============================================================================
// Support functions
// =============================================================================

function DelimitedPath(Path: string): string;
begin
  Result := Trim(Path);
  if (Result <> '') then
    Result := IncludeTrailingPathDelimiter(Result);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Exported DLL functions
// =============================================================================
function Initialise(Path: PChar): Integer; stdcall;
begin

//Log('Initialising BtrvSQL with path "' + Path + '"');

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
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                 ) : SmallInt;
begin

Log('BTRCALL: op ' + IntToStr(operation) + ', key ' + PChar(@keybuf) + ', key num ' + IntToStr(keynum));

  if not Assigned(BTRCallFn) then
    Initialise('');

  Result := BTRCallFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum);

if (Result <> 0) then
  Log('- failed: ' + IntToStr(Result) + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));

end;

// -----------------------------------------------------------------------------

function BTRCALLID(
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer;
             var clientid     ) : SmallInt;
begin

Log('BTRCALLID: op ' + IntToStr(operation) + ', key ' + PChar(@keybuf) + ', key num ' + IntToStr(keynum));

  if not Assigned(BTRCallIDFn) then
    Initialise('');

  Result := BTRCallIDFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum, clientid);

if (Result <> 0) then
  Log('- failed: ' + IntToStr(Result) + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));

end;

// -----------------------------------------------------------------------------

function WBTRVINIT(var InitializationString): Integer;
begin

//Log('WBTRVINIT');

  Result := WBTRVInitFn(InitializationString);
end;

// -----------------------------------------------------------------------------

function WBTRVSTOP: Integer;
begin

//Log('WBTRVSTOP');

  Result := WBTRVStopFn;
end;

// -----------------------------------------------------------------------------

function ValidCompany(FilePath: PChar): Integer;
var
  Path: string;
begin
  Result := 4;

//Log('ValidCompany: ' + FilePath);

  Path := DelimitedPath(FilePath);
  if (DirectoryExists(Path) and
      FileExists(Path + 'COMPANY.SYS')) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

function ValidSystem(ForPath: PChar): Integer;
var
  Path: string;
begin
  Result := 4;

//Log('ValidSystem: ' + ForPath);

  Path := DelimitedPath(ForPath);
  if (DirectoryExists(Path + 'LIB') and
      FileExists(Path + 'ENTER1.EXE') and
      FileExists(Path + 'ENTRPRSE.DAT') and
      FileExists(Path + 'EXCHEQR.SYS')) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

procedure EnteringModule(ModuleName: PChar);
begin
  Log('Entering module : ' + ModuleName);
end;

// -----------------------------------------------------------------------------

procedure LeavingModule(ModuleName: PChar);
begin
  Log('Leaving module : ' + ModuleName);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Internal DLL functions (for accessing the Btrieve DLL)
// =============================================================================

function Load_DLL(Path: PChar): Boolean;
var
  ErrMsg: string;
  DLLSpec: AnsiString;
begin

//Log('Load_DLL: ' + Path);

  Result := False;
  ErrMsg := '';

  DLLPath := Path;
  if (DLLPath <> '') then
    DLLPath := IncludeTrailingPathDelimiter(DLLPath);

  DLLSpec := 'WBTRV32.DLL';

Log('LoadDLL: ' + DLLSpec);

  DLLHandle := LoadLibrary(PChar(DLLSpec));

  { Try to get the function addresses from the DLL. }
  if DLLHandle <> 0 then
  begin
    @BTRCallFn   := GetProcAddress(DLLHandle, 'BTRCALL');
    @BTRCallIDFn := GetProcAddress(DLLHandle, 'BTRCALLID');
    @WBTRVInitFn := GetProcAddress(DLLHandle, 'WBTRVINIT');
    @WBTRVStopFn := GetProcAddress(DLLHandle, 'WBTRVSTOP');
    if not Assigned(BTRCallFn) then
      ErrMsg := 'BTRCALL'
    else if not Assigned(BTRCallIDFn) then
      ErrMsg := 'BTRCALLID'
    else if not Assigned(WBTRVInitFn) then
      ErrMsg := 'WBTRVINIT'
    else if not Assigned(WBTRVStopFn) then
      ErrMsg := 'WBTRVSTOP';
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

Log('Load_DLL: using Btrieve');

  end;

end;

// -----------------------------------------------------------------------------

procedure Unload_DLL;
begin

//Log('Unload_DLL: ' + IntToStr(DLLHandle));

  if DLLHandle <> 0 then
    FreeLibrary(DLLHandle);
end;

// -----------------------------------------------------------------------------

initialization

  DLLPath      := '';
  IsInitialised := False;

finalization

  Unload_DLL;

end.

