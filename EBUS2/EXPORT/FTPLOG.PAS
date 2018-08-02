unit FTPLog;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmFTPLog = class(TForm)
    memLog: TMemo;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFTPLog: TFrmFTPLog;

implementation
uses
  RunExp;

{$R *.DFM}

procedure TFrmFTPLog.FormCreate(Sender: TObject);
var
  sLogFile : string;
begin
  sLogFile := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + FTP_LOG_FILENAME;
  if FileExists(sLogFile) then memLog.Lines.LoadFromFile(sLogFile);
end;

end.
