unit uWRTransmit;

interface

uses
  Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Blowfish, ShellAPI;

type
  TfrmClient = class(TDataModule)
    ClientConnxn: TIdTCPClient;
    Blowfish: TBlowfish;
    procedure DataModuleCreate(Sender: TObject);
  private
    fSendFile: string;
    fSilent: boolean;
    fDelete: boolean;
    procedure SendFile;
    function isArchiveFile: boolean;
  end;

var
  frmClient: TfrmClient;

implementation

uses Dialogs, SysUtils, IdGlobal;

{$R *.dfm}

//*** Main *********************************************************************

procedure TfrmClient.DataModuleCreate(Sender: TObject);
var
ParamIndex: integer;
begin                   
  {Check the launch parameters; These are case-insensitive and can be supplied in
   any order; /silent will suppress all UI notifications, NOTE: errors may go
   unnoticed; /local will cause the application to try and send the file to
   WRListen on the local machine; It will need to be installed as a service and
   running; /delete will delete the sent file once it is sent; /F: with a
   filename will cause the file given to be sent; If the file is in the same
   directory as WRTransmit, only the filename need be supplied, otherwise the
   full filepath is required; A check is made to ensure the file exists; If /F:
   is not supplied, a file can be selected from an OpenDialog;}

   {
    www.exchequer-secure.com
    10.1.1.2
   }

  fSendFile:= '';
  fSilent:= false;
  fDelete:= false;

  for ParamIndex:= 1 to ParamCount do
  begin
    if Copy(UpperCase(ParamStr(ParamIndex)), 1, 3) = '/F:' then fSendFile:= Copy(ParamStr(ParamIndex), 4, Length(ParamStr(ParamIndex)));
    if UpperCase(ParamStr(ParamIndex)) = '/LOCAL' then ClientConnxn.Host:= '127.0.0.1';
    if UpperCase(ParamStr(ParamIndex)) = '/SILENT' then fSilent:= true;
    if UpperCase(ParamStr(ParamIndex)) = '/DELETE' then fDelete:= true;
  end;

  if fSendFile = '' then
  begin
    if not fSilent then with TOpenDialog.Create(nil) do
    try

      Title:= 'Select a file to transmit';
      InitialDir:= ExtractFilePath(ParamStr(0));
      if Execute then
      begin
        fSendFile:= FileName;
        SendFile;
      end;

    finally
      Free;
    end
  end
  else
  begin
    if FileExists(ExtractFilePath(ParamStr(0)) + fSendFile) then
    begin
      fSendFile:= ExtractFilePath(ParamStr(0)) + fSendFile;
      SendFile;
    end
    else if FileExists(fSendFile) then SendFile
    else if not fSilent then MessageDlg('The file ' + fSendFile + ' does not exist.', mtError, [mbOK], 0);
  end;
end;

procedure TfrmClient.SendFile;
var
TransmitFile: TFileStream;
SendStream: TMemoryStream;
begin
  TransmitFile:= TFileStream.Create(fSendFile, fmOpenRead);
  SendStream:= TMemoryStream.Create;

  with frmClient.Blowfish do
  try

    LoadIVString('kD4a1s' + 'tB47A' + 'f3eJH');
    InitialiseString('d46fTY' + 'NL391' + '5XpPw');
    if isArchiveFile then SendStream.LoadFromStream(TransmitFile)
    else EncStream(TransmitFile, SendStream);

    with frmClient, ClientConnxn do
    try
      Connect;
      try
        try
          WriteStream(SendStream, true, true);
          if not fSilent then MessageDlg(Readln(EOL), mtInformation, [mbOK], 0);
        except
          if not fSilent then MessageDlg('Transmission to Webrel failed', mtError, [mbOK], 0);
        end;
      finally
        Disconnect;
      end;
    except
      if not fSilent then MessageDlg('A Webrel connection to ' + Host + ' was unable to be established.', mtError, [mbOK], 0);
    end;

  finally
    Burn;

    SendStream.Free;
    TransmitFile.Free;

    try
      if fDelete then DeleteFile(fSendFile);
    except
    end;
  end;
end;

//*** Helper Functions *********************************************************

function TfrmClient.isArchiveFile: boolean;
begin
  Result:= (Length(ExtractFileName(fSendFile)) = 16) and (UpperCase(ExtractFileExt(fSendFile)) = '.DAT');
end;

//******************************************************************************

end.
