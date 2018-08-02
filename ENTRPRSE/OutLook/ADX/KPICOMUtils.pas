unit KPICOMUtils;

interface

type
  TCOMServerErrorType =
  (
    cseOk,
    cseServerMissing,
    cseCannotOpenServerDetails,
    cseNoServerDetailsFound,
    cseServerClassIdMissing,
    cseCannotOpenServerClassId,
    cseServerClassIdEntryMissing
  );

function CheckCOMServer(const ServerName: ShortString): TCOMServerErrorType;
procedure RegisterAssembly (const DLLPath: ShortString);

const
  COMServerErrors: array[cseOk..cseServerClassIdEntryMissing] of string =
  (
    'Ok',
    'Server missing',
    'Cannot open server details',
    'No server details found',
    'Server class ID missing',
    'Cannot open server class ID',
    'Server class ID entry missing'
  );

implementation

uses SysUtils, Windows, ComObj, Registry, APIUtil, PathUtil;

// Check that a particular server is registered to the current directory
function CheckCOMServer(const ServerName: ShortString): TCOMServerErrorType;
var
  ClsId, SvrPath: ShortString;
begin
  Result := cseOk;
  with TRegistry.Create Do
  try
    Access  := KEY_READ;
    RootKey := HKEY_CLASSES_ROOT;

    if KeyExists(ServerName + '\Clsid') then
    begin
      { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
      if OpenKey(ServerName + '\Clsid', False) then
      begin
        if KeyExists('') then
        begin
          { CLSID stored in default entry }
          ClsId := ReadString ('');
          CloseKey;

          { Got CLSID - find entry in CLSID Section and check registered .EXE/.DLL }
          if KeyExists ('Clsid\'+ClsId+'\InprocServer32') Then
            SvrPath := 'Clsid\'+ClsId+'\InprocServer32'
          else if KeyExists ('Clsid\'+ClsId+'\LocalServer32') Then
            SvrPath := 'Clsid\'+ClsId+'\LocalServer32'
          else
            SvrPath := '';

          if (SvrPath <> '') then
          begin
            { Got Server details - read .EXE/.DLL details and check it exists }
            if OpenKey(SvrPath, False) then
            begin
              ClsId := ReadString ('');

              if not FileExists(ClsId) then
                { Registered OLE Server doesn't actually exist }
                Result := cseServerMissing;
            end { If }
            else
              Result := cseCannotOpenServerDetails;
          end { If (SvrPath <> '') }
          else
            Result := cseNoServerDetailsFound;
        end { If KeyExists('') }
        else
          Result := cseServerClassIdMissing;
      end { If OpenKey(ServerName + '\Clsid', False) }
      else
        Result := cseCannotOpenServerClassId;
    end { If KeyExists(ServerName + '\Clsid') }
    else
      Result := cseServerClassIdEntryMissing;

    CloseKey;
  finally
    Free;
  end;
end; { ChkCOMServer }

// -----------------------------------------------------------------------------

procedure RegisterAssembly (const DLLPath: ShortString);
var
  sExec: string;
begin
  // Build path to .NET utility for installing/uninstalling .NET services
  sExec := WinGetWindowsDir + 'Microsoft.NET\Framework\v2.0.50727\RegAsm.exe /codebase ' + DLLPath;
  RunApp (sExec, True);
end;

// -----------------------------------------------------------------------------

end.
