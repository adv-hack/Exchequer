unit FTP;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Mssocket, msFTP
  , StrUtil, eBusCnst, ExtCtrls;

type

  ToFTP = Class
  private
    SiteAddress : string40;
    SitePort : Word;
    SiteUser : string20;
    SitePassword : string20;
    ProxyAddress : string40;
    ProxyPortNo : Word;
    ProxyPassive : Boolean;
    UploadDir : string50;
    FLoadedOK : boolean;
    FLogFilename : string;
    function AppendFTPDir(sAppend, sAppendTo : string) : string;
  public
    property LogFilename : string read FLogFilename write FLogFilename;
    property LoadedOK : Boolean Read FLoadedOK;
    function SendFile(sFilename : string) : smallint;
    constructor Create(sCompanyCode : string; ExportType : TExportType);
  end;

  TfrmFTP = class(TForm)
    msFTPClient: TmsFTPClient;
    FTPTimeoutCheck: TTimer;
    procedure msFTPClientConnected(Sender: TObject);
    procedure msFTPClientConnecting(Sender: TObject);
    procedure msFTPClientDataTransferProgress(Sender: TObject;
      ByteCount: Integer);
    procedure msFTPClientDataTransferStart(Sender: TObject);
    procedure msFTPClientDataTransferTerminate(Sender: TObject);
    procedure msFTPClientDisconnected(Sender: TObject);
    procedure msFTPClientLineReceived(Sender: TObject;
      const TheLine: String);
    procedure msFTPClientLineSent(Sender: TObject; const TheLine: String);
    procedure msFTPClientTransferProgress(Sender: TObject; Perc, ByteCount,
      LineCount: Integer);
    procedure FTPTimeoutCheckTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    bError : boolean;
    sLogFilename : string;
    procedure LogLine(sLine : string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFTP: TfrmFTP;

implementation
uses
  eBusBtrv, FileUtil;

{$R *.DFM}

constructor ToFTP.Create(sCompanyCode : string; ExportType : TExportType);
begin
  inherited Create;

  with TEBusBtrieveFTP.Create(TRUE) do begin
    try
      Openfile;
      CompanyCode := sCompanyCode;
      FLoadedOK := FindRecordWithDefaults = 0;

      if LoadedOK then begin
        with FTPSettings do begin
          SiteAddress := FTPSiteAddress;
          SitePort := FTPSitePort;
          SiteUser := FTPUserName;
          SitePassword := FTPPassword;
          ProxyAddress := FTPProxyAddress;
          ProxyPortNo := FTPProxyPort;
          ProxyPassive := FTPPassiveMode > 0;

          case ExportType of
            etAccount : UploadDir := AppendFTPDir(FTPCustomerDir, FTPRootDir);
            etStockGroup, etStockHeader,etStockLocation : UploadDir := AppendFTPDir(FTPStockDir, FTPRootDir);
            etTXHeader,etTXLines : UploadDir := AppendFTPDir(FTPTransactionDir, FTPRootDir);
            etCOMPricing : UploadDir := AppendFTPDir(FTPCOMPriceDir, FTPRootDir);
          end;{case}
        end;{with}
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

function ToFTP.SendFile(sFilename : string) : smallint;
begin
  Result := 0;
  if FileExists(sFileName) then begin
    frmFTP := TfrmFTP.Create(application);
    try
      frmFTP.sLogFilename := FLogFilename;
      try
        frmFTP.LogLine(DateToStr(Date) + '   ' + TimeToStr(Time));
        frmFTP.LogLine('SendFile - ' + sFilename);
        frmFTP.LogLine(' ');
        with frmFTP, msFTPClient do begin
          Host := SiteAddress;
          Port := SitePort;
          Password := SitePassword;
          UserName := SiteUser;

          Proxy := ProxyAddress;
          ProxyPort := ProxyPortNo;
          PassiveMode := ProxyPassive;

          Login;
          if length(UploadDir) > 0 then CurrentDirectory := UploadDir;
          StoreFile(sFileName, ExtractFileName(sFileName));
          LogOut;
        end;{with}
      except
        on E:Exception do begin
          Result := 1;
          frmFTP.LogLine('-+*> EXCEPTION <*+- ' + E.ClassName + ' - ' + E.Message);
        end;{on}
      end;{Try}
    finally
      if frmFTP.bError then Result := 2;
      frmFTP.LogLine(' ');
      frmFTP.LogLine(' ');
      frmFTP.Release;
    end;{try}
  end;{if}
end;

function ToFTP.AppendFTPDir(sAppend, sAppendTo : string) : string;
const
  cSeparator = '/';
begin
  if length(sAppendTo) < 1 then sAppendTo := cSeparator
  else begin
    if sAppendTo[1] <> cSeparator then sAppendTo := cSeparator + sAppendTo;
    if sAppendTo[length(sAppendTo)] <> cSeparator then sAppendTo := sAppendTo + cSeparator;
  end;{if}

  if length(sAppend) > 1 then begin
    if sAppend[1] = cSeparator then sAppend := copy(sAppend,2,256);
  end;{if}

  Result := sAppendTo + sAppend;
  if Result[length(Result)] = cSeparator then Result := copy(Result,1,length(Result) - 1);
end;

procedure TfrmFTP.LogLine(sLine : string);
begin
  AddLineToFile(sLine, sLogFilename);
end;

procedure TfrmFTP.msFTPClientConnected(Sender: TObject);
begin
  LogLine('Connected');
end;

procedure TfrmFTP.msFTPClientConnecting(Sender: TObject);
begin
  LogLine('Connecting');
end;

procedure TfrmFTP.msFTPClientDataTransferProgress(Sender: TObject;
  ByteCount: Integer);
begin
  FTPTimeoutCheck.Enabled := FALSE;
  LogLine('Data Transfer Progress : ' + IntToStr(ByteCount));
  FTPTimeoutCheck.Enabled := TRUE;
end;

procedure TfrmFTP.msFTPClientDataTransferStart(Sender: TObject);
begin
  LogLine('Data Transfer Start');
end;

procedure TfrmFTP.msFTPClientDataTransferTerminate(Sender: TObject);
begin
  FTPTimeoutCheck.Enabled := FALSE;
  LogLine('Data Transfer Terminate');
end;

procedure TfrmFTP.msFTPClientDisconnected(Sender: TObject);
begin
  LogLine('Disconnected');
end;

procedure TfrmFTP.msFTPClientLineReceived(Sender: TObject;
  const TheLine: String);
begin
  LogLine('Line Received : ' + TheLine);

  if copy(TheLine,1,3) = '150' then FTPTimeoutCheck.Enabled := TRUE;
end;

procedure TfrmFTP.msFTPClientLineSent(Sender: TObject;
  const TheLine: String);
begin
  LogLine('Line Sent : ' + TheLine);
end;

procedure TfrmFTP.msFTPClientTransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Integer);
begin
  LogLine('Transfer Progress - Byte Count : ' + IntToStr(ByteCount) + '   Line Count : ' + IntToStr(LineCount));
end;

procedure TfrmFTP.FTPTimeoutCheckTimer(Sender: TObject);
begin
  FTPTimeoutCheck.Enabled := FALSE;
  bError := TRUE;
  LogLine('-+*> FTP TIMEOUT <*+-');
  msFTPClient.ConnRequested := TRUE;
{  msFTPClient.CancelDataTransfer;
  msFTPClient.Disconnect;
  msFTPClient.Cancel}
end;

procedure TfrmFTP.FormCreate(Sender: TObject);
begin
  bError := FALSE;
end;

end.
