unit ServiceDrive;

interface

function ConnectNetworkDrive(DriveLetter : string = '';
                             NetworkPath : string = '') : Integer;

implementation

uses
  IniFiles, SysUtils, Forms, Windows;

const
  SERVICE_INIFILE = 'EntDrive.ini';

//PR: 13/12/2013 ABSEXCH-14844; 14680; 14845. Moved this function to a central location (here) for use by other programs
function ConnectDrive(_drvLetter: string; _netPath: string; _showError: Boolean;
  _reconnect: Boolean): DWORD;
var
  nRes: TNetResource;
  errCode: DWORD;
  dwFlags: DWORD;
Begin // ConnectDrive
  { Fill NetRessource with #0 to provide uninitialized values }
  { NetRessource mit #0 füllen => Keine unitialisierte Werte }
  FillChar(NRes, SizeOf(NRes), #0);
  nRes.dwType := RESOURCETYPE_DISK;
  { Set Driveletter and Networkpath }
  { Laufwerkbuchstabe und Netzwerkpfad setzen }
  nRes.lpLocalName  := PChar(_drvLetter);
  nRes.lpRemoteName := PChar(_netPath); { Example: \\Test\C }
  { Check if it should be saved for use after restart and set flags }
  { Überprüfung, ob gespeichert werden soll }
  if _reconnect then
    dwFlags := CONNECT_UPDATE_PROFILE or CONNECT_INTERACTIVE
  else
    dwFlags := CONNECT_INTERACTIVE;

  //errCode := WNetAddConnection3(Form1.Handle, nRes, nil, nil, dwFlags);
  errCode := WNetAddConnection2(nRes, nil, nil, dwFlags);

  { Show Errormessage, if flag is set }
  { Fehlernachricht aneigen }
  if (errCode <> NO_ERROR) and (_showError) then
  begin
    Application.MessageBox(PChar('An error occurred while connecting:' + #13#10 +
      SysErrorMessage(GetLastError)),
      'Error while connecting!',
      MB_OK);
  end;
  Result := errCode; { NO_ERROR }
End; // ConnectDrive

//PR: 13/12/2013 ABSEXCH-14844; 14680; 14845. Function to read Drive Letter and Network Path from ini file.
function GetDriveMappingFromIniFile(var DriveLetter : string;
                                    var NetworkPath : string;
                                        IniFileName : string = '') : Boolean;
begin
  if IniFileName = '' then
    IniFileName := SERVICE_INIFILE;

  IniFileName := ExtractFilePath(Application.ExeName) + IniFileName;

  with TIniFile.Create(IniFileName) do
  Try
    DriveLetter := ReadString('Settings', 'DriveLetter', '');
    NetworkPath := ReadString('Settings', 'NetworkPath', '');
    Result := (Trim(DriveLetter) <> '') and (Trim(NetworkPath) <> '');
  Finally
    Free;
  End;
end;


//PR: 13/12/2013 ABSEXCH-14844; 14680; 14845. Connects network drive. If both parameters are populated, then
//                                            it uses them; otherwise it reads them from the ini file.
function ConnectNetworkDrive(DriveLetter : string = '';
                             NetworkPath : string = '') : Integer;
var
  LocalDriveLetter : string;
  LocalNetworkPath : string;
  Res : Integer;
  OkToConnect : Boolean;
begin

  if (Trim(DriveLetter) = '') or (Trim(NetworkPath) = '') then
    OKToConnect := GetDriveMappingFromIniFile(LocalDriveLetter, LocalNetworkPath)
  else
  begin
    LocalDriveLetter := DriveLetter;
    LocalNetworkPath := NetworkPath;
    OKToConnect := True;
  end;

  if OKToConnect then
    Result := ConnectDrive(Copy(LocalDriveLetter, 1, 2), LocalNetworkPath, False, False)
  else
    Result := -1;
end;




end.
