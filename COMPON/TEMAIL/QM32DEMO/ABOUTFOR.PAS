unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Registry, Email;

const
   crHandCursor = 1;

type
  TfrmAbout = class(TForm)
    cmdOK: TButton;
    lblApp: TLabel;
    lblWindows: TLabel;
    lblCopyright: TLabel;
    lblReg: TLabel;
    lblUserName: TLabel;
    lblCompany: TLabel;
    Bevel1: TBevel;
    Email1: TEmail;
    Bevel2: TBevel;
    Label1: TLabel;
    lblMe: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lblMeClick(Sender: TObject);
  private
    { Private declarations }
    function OperatingSystem: string;
    function UserName: string;
    function CompanyName: string;
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}
{$R HandCur.RES}

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  sTmpStr: string;
begin
  Screen.Cursors[crHandCursor] := LoadCursor(HInstance, PChar('HAND'));
  lblMe.Cursor := crHandCursor;

  lblApp.Caption := Application.Title;
  lblWindows.Caption := OperatingSystem;
  lblUserName.Caption := UserName;

  sTmpStr := CompanyName;
  if sTmpStr <> 'Unknown' then
    lblCompany.Caption := sTmpStr;
end;

procedure TfrmAbout.lblMeClick(Sender: TObject);
begin
  Cursor := crHourglass;
  try
    Email1.Recipient.Add(lblMe.Caption);

    Email1.Text := 'Hi Danny, I know you are a busy person... BUT!!!';
 
    if Email1.SendMail <> EMAIL_OK then
      MessageDlg('MAPI Sendmail failed', mtError, [mbAbort], 0);

  finally
    Cursor := crDefault;
  end;
end;

function TfrmAbout.OperatingSystem: string;
var
  OSInfo: TOSVersionInfo;
  WV: string;
  BD: string;
begin
  OSInfo.dwOSVersionInfoSize := SizeOf(TOSVERSIONINFO);
  GetVersionEx(OSInfo);
  case OSInfo.dwPlatformId of
     VER_PLATFORM_WIN32s        : Result:='Windows 3.1';
     VER_PLATFORM_WIN32_WINDOWS : Result:='Windows 95';
     VER_PLATFORM_WIN32_NT      : Result:='Windows NT';
  else
    Result := 'Unknown';
  end;

  WV := Format ('%d.%d', [OSInfo.dwMajorVersion, OSInfo.dwMinorVersion]);
  BD := Format('%d', [LOWORD(OSInfo.dwBuildNumber)]);
end;

const
  RegKey = '\Software\Microsoft\MS Setup (ACME)\User Info';

function ReadStringValue(const AValue: string): string;
begin
  with TRegistry.Create do
  try
    if OpenKey(RegKey, false) then
    begin
      try
        Result := ReadString(AValue);
      except
        Result := 'Unknown';
      end;
    end
    else
      Result := 'Unknown';
  finally
    Free;
  end;
end;

function TfrmAbout.UserName: string;
begin
  Result := ReadStringValue('DefName');
end;

function TfrmAbout.CompanyName: string;
begin
  Result := ReadStringValue('DefCompany');
end;

end.
