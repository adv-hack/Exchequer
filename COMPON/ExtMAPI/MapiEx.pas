unit MapiEx;

interface

uses
  Classes, sx_Mapi, Forms, Dialogs, Windows
  {$IFDEF WIN32},Exchequer_TLB{$ENDIF WIN32};

type
  TMapiExEmail = Class(TComponent)
  private
    FAttachment, FBCC, FCC, FRecip : TStrings;
    FLeaveUnread, FUseDefProfile, FShowDialog : Boolean;
    FMessageID, FMessageType,
    FPassword, FProfile, FSubject : ShortString;
    FMAPI : TsxMAPI_Session;
    FFolder : TsxMAPI_Folder;
    FMessage : TsxMAPI_Message;
    FpLongText : AnsiString;
    FUnreadIdx : Integer;
    FOrigAddress : ShortString;
    FOriginator : ShortString;
    FHandle : HWND;
    FDeleteAfterRead : Boolean;
    FInService : Boolean;
    FUse64Bit : Boolean;
    {$IFDEF WIN32}
    FMapi64 : IMapi64;
    {$ENDIF WIN32}
    function GetAttachment: TStrings;
    function GetBcc: TStrings;
    function GetCC: TStrings;
    function GetDeleteAfterRead: Boolean;
    function GetHandle: HWND;
    function GetInService: Boolean;
    function GetPassword: ShortString;
    function GetProfile : ShortString;
    function GetRecip: TStrings;
    function GetShowDialog: Boolean;
    function GetSubject: ShortString;
    function GetUseDefProfile : Boolean;
    procedure SetDeleteAfterRead(const Value: Boolean);
    procedure SetHandle(const Value: HWND);
    procedure SetInService(const Value: Boolean);
    procedure SetPassword(const Value: ShortString);
    procedure SetProfile(const Value: ShortString);
    procedure SetShowDialog(const Value: Boolean);
    procedure SetSubject(const Value: ShortString);
    procedure SetUseDefProfile(const Value: Boolean);
    function GetLeaveUnread: Boolean;
    function GetOrigAddress: ShortString;
    function GetOriginator: ShortString;
    procedure SetLeaveUnread(const Value: Boolean);
  protected
    function  GetVersion: ShortString;
    function  GetMapiAvail: boolean;

    procedure SetRecip(const Recip: TStrings);
    procedure SetCC   (const CC   : TStrings);
    procedure SetBcc  (const Bcc  : TStrings);
    procedure SetAttachment(const Attachment : TStrings);
    procedure LoadAttachments;
    procedure AddAttachment(WhichOne : integer);
    procedure SaveAttachments;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function GetLongText                                   : AnsiString;
    function GetNextMessageId                              : ShortString;
    function Logoff                                        : Integer;
    function Logon                                         : Integer;
    function ReadMail                                      : Integer;
    function SendMail                                      : Integer;
    function SetLongText(pLongText : AnsiString)           : Integer;

    function GetFirstUnread : Integer;
    function GetNextUnread : Integer;
    function ErrorString(ErrCode : Integer) : AnsiString;
    procedure SetMessageAsRead;
    procedure DeleteReadMessages;
    procedure DeleteMessage; //Deletes the current message
    property LeaveUnread  : Boolean read GetLeaveUnread   write SetLeaveUnread;
    property MessageId    : ShortString read FMessageId     write FMessageId;
    property MessageType  : ShortString read FMessageType   write FMessageType;
    property WindowHandle : HWND read GetHandle write SetHandle;
    property DeleteAfterRead : Boolean read GetDeleteAfterRead write SetDeleteAfterRead;
    property InService : Boolean read GetInService write SetInService;
  published
    property Attachment   : TStrings    read GetAttachment    write SetAttachment;
    property Bcc          : TStrings    read GetBcc           write SetBcc;
    property CC           : TStrings    read GetCC                write SetCC;
    property MapiAvail    : boolean     read GetMapiAvail;
    property Password     : ShortString     read GetPassword      write SetPassword;
    property Profile      : ShortString     read GetProfile       write SetProfile;
    property Recipient    : TStrings    read GetRecip         write SetRecip;
    property ShowDialog   : Boolean     read GetShowDialog    write SetShowDialog
                                        default False;
    property Subject      : ShortString     read GetSubject       write SetSubject;
    property UseDefProfile: Boolean     read GetUseDefProfile write SetUseDefProfile;
    property Version      : ShortString     read GetVersion;
    property OrigAddress : ShortString read GetOrigAddress;
    property Originator : ShortString read GetOriginator;
  end;

  procedure Register;
  function ExtendedMAPIAvailable : Boolean;
  function SimpleMAPIAvailable : Boolean;

implementation

uses
  SysUtils, IniFiles, APIUtil, Registry, MapiOptionsU, ComObj;

procedure Register;
begin
  RegisterComponents('SBS', [TMapiExEmail]);
end;

function ExtendedMAPIAvailable : Boolean;
begin
  //PR: 10/02/2017 ABSEXCH-17750 Removed registry check as there was a
  //               problem with virtualization on MM's laptop. Simple MAPI
  //               was deprecated by MS from Windows 7, so we should be able
  //               to assume Extended MAPI.
  Result := True;
{  if GetWindowsVersion >= wv2000 then
  begin //Read from registry
    with TRegistry.Create(KEY_READ or KEY_WRITE) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\Microsoft\Windows Messaging Subsystem', False) then
      begin
        Result := ReadString('MAPIX') = '1';
      end
    finally
      Free;
    end;
  end
  else
  begin //read from ini file
    with TIniFile.Create('Win.ini') do
    Try
      Result := ReadBool('MAIL', 'MAPIX', False);
    Finally
      Free;
    End;
  end;}

  if Result then
    with TIniFile.Create(WinGetWindowsDir + 'EntMapi.ini') do
    Try
      Result := Result and not ReadBool('MAPI', 'UseSimpleMAPI', False);
    Finally
      Free;
    End;
end;

function SimpleMAPIAvailable : Boolean;
begin
  if GetWindowsVersion >= wv2000 then
  begin //Read from registry
    with TRegistry.Create(KEY_READ or KEY_WRITE) do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\Microsoft\Windows Messaging Subsystem', False) then
      begin
        Result := ReadString('MAPI') = '1';
      end
    finally
      Free;
    end;
  end
  else
  begin //read from ini file
    with TIniFile.Create('Win.ini') do
    Try
      Result := ReadBool('MAIL', 'MAPI', False);
    Finally
      Free;
    End;
  end;
end;


function WinGetWindowsTempDir : Ansistring;
// Wraps the Windows API call : GetTempPath
// Gets the Current Windows Temp Directory
var
  lpBuffer : Array [0..255] of AnsiChar;
  nSize : uint;
begin
  nSize := SizeOf(lpBuffer) - 1;
  GetTempPathA(nSize, lpBuffer);
  Result := lpBuffer;
  Result := IncludeTrailingPathDelimiter(Result);
end;

{ TMapiExEmail }
const
  emxVersion = '5.60.002';

constructor TMapiExEmail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //Check if we need to use 64bit COM object to access mapi
  {$IFDEF WIN32}
  FMapi64   := nil;
  FUse64Bit := MapiOptions.moUse64BitMapi;
  if FUse64Bit then
    FMapi64 := CreateOLEObject('Exchequer.Mapi64') as IMapi64;
  {$ELSE}
  FUse64Bit := False;
  {$ENDIF WIN32}

  if not FUse64Bit then
  begin
    FMAPI := TsxMAPI_Session.Create(AOwner);
    FMAPI.ProfileName := '';
    FMAPI.ProfilePass := '';
  end;
  FRecip        := TStringList.Create;
  FCC           := TStringList.Create;
  FBcc          := TStringList.Create;
  FAttachment   := TStringList.Create;
  FDeleteAfterRead := True;
  FInService := False;

end;

destructor TMapiExEmail.Destroy;
begin
  FBcc.Free;
  FBcc := nil;

  FCC.Free;
  FCC := nil;

  FRecip.Free;
  FRecip := nil;

  FAttachment.Free;
  Fattachment := nil;

  {$IFDEF WIN32}
  //Free COM Object
  FMapi64 := nil;
  {$ENDIF WIN32}
  inherited;
end;

function TMapiExEmail.GetLongText: AnsiString;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emMessage
  else
{$ENDIF}
    Result := FpLongText;
end;

function TMapiExEmail.GetMapiAvail: boolean;
begin
  Result := Logon = 0;
end;

function TMapiExEmail.GetNextMessageId: ShortString;
begin

end;

function TMapiExEmail.GetVersion: ShortString;
begin
  Result := emxVersion;
end;

function TMapiExEmail.Logoff: Integer;
begin
  Result := 0;
  Try
{$IFDEF WIN32}
    if FUse64Bit then
      FMapi64.LogOff
    else
{$ENDIF}
      FMAPI.Logoff(False);
  Except
    Result := LastErrorCode;
  End;
end;

function TMapiExEmail.Logon: Integer;
begin
  Result := 0;
  if FUse64Bit then
  begin
{$IFDEF WIN32}
    Result := FMapi64.Logon;
{$ENDIF}
  end
  else
  begin
    FMAPI.RefreshFolders;
    FMAPI.InService := FInService;
    FMAPI.WndHandle := FHandle;
    Try
      if not FUseDefProfile then
      begin
        FMAPI.ProfileName := FProfile;
        FMAPI.ProfilePass := FPassword;
      end;
      FMAPI.Logon;
    Except
      Result := LastErrorCode;
    End;
  end;
end;

function TMapiExEmail.ReadMail: Integer;
begin

end;

function TMapiExEmail.SendMail: Integer;
var
  s : AnsiString;
begin
  Result := 0;
  if FUse64Bit then
  begin
{$IFDEF WIN32}
    //Copy contents of lists to 64-bit COM object
    FMapi64.emRecipient := FRecip.Text;
    FMapi64.emBCC := FBCC.Text;
    FMapi64.emCC := FCC.Text;
    FMapi64.emAttachment := FAttachment.Text;
    Result := FMapi64.SendMail;
{$ENDIF}
  end
  else
  Try
   Try
    FFolder := FMAPI.Folder[sxftOutbox];
    FMessage := FFolder.CreateMessage;
    FMessage.SetRecepientsList(sxrtTo, FRecip);
    FMessage.SetRecepientsList(sxrtCC, FCC);
    FMessage.SetRecepientsList(sxrtBCC, FBCC);
    FMessage.Body := fpLongText;
    FMessage.Subject := FSubject;
    LoadAttachments;
    FMessage.Send;
   Finally
    FMessage.Free;
   End;
  Except
    Result := LastErrorCode;
  End;
end;

procedure TMapiExEmail.SetAttachment(const Attachment: TStrings);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emAttachment := Attachment.Text
  else
{$ENDIF}
    FAttachment.Assign(Attachment);
end;

procedure TMapiExEmail.AddAttachment(WhichOne : integer);
var
  Att: TsxMAPI_Attachment;
  sw : string;
  s, s1: AnsiString;
  MemStr: TMemoryStream;
begin
  Att := FMessage.AddAttachment;
  sw := FAttachment[WhichOne];
{  s1 := ExtractFileDrive(s);
  if Length(s1) > 0 then
    s1 := s1 + '\';
  Delete(s, 1, Length(s1));}

  s1 := AnsiString(ExtractFileName(sw));
  s := AnsiString(sw);

  Att.Name := s1;
  Att.FileName := s1;
  Att.LongFileName := s1;

  Att.LongPath := s;
  Att.Path := s;

  MemStr := TMemoryStream.Create;
  try
    MemStr.LoadFromFile(s);
    Att.Write(MemStr);
  finally
    MemStr.Free;
  end;

end;

procedure TMapiExEmail.LoadAttachments;
var
  i : integer;
begin
  if FAttachment.Count > 0 then
    for i := 0 to FAttachment.Count - 1 do
      AddAttachment(i);
end;

procedure TMapiExEmail.SetBcc(const Bcc: TStrings);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emBcc := Bcc.Text
  else
{$ENDIF}
    FBcc.Assign(Bcc);
end;

procedure TMapiExEmail.SetCC(const CC: TStrings);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emCC := CC.Text
  else
{$ENDIF}
    FCC.Assign(CC);
end;

function TMapiExEmail.SetLongText(pLongText: AnsiString): Integer;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emMessage := pLongText
  else
{$ENDIF}
    FpLongText := pLongText;

  Result := Length(pLongText);
end;

procedure TMapiExEmail.SetRecip(const Recip: TStrings);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emRecipient := Recip.Text
  else
{$ENDIF}
    FRecip.Assign(Recip);
end;

function TMapiExEmail.GetFirstUnread : Integer;
//messages seem to be in order of receipt, so unread messages are likely to be most recent -
//so start at end
begin
  if FUse64Bit then
  begin
{$IFDEF WIN32}
    Result := FMapi64.GetFirstUnread;

    //Copy contents of lists back to local string lists
    FRecip.Text := FMapi64.emRecipient;
    FBCC.Text := FMapi64.emBCC;
    FCC.Text := FMapi64.emCC;
    FAttachment.Text := FMapi64.emAttachment;
{$ENDIF}
  end
  else
  begin
    FFolder := FMAPI.Folder[sxftInbox];
    FFolder.RefreshContents;
    FUnreadIdx := FFolder.MsgCount - 1;
    Result := GetNextUnread;
  end;
end;

function TMapiExEmail.GetNextUnread : Integer;
//Get the next unread message and load the appropriate fields into the object. Also calls
//SaveAttachments to save any attachments to the windows temp dir.
var
  s : AnsiString;
begin
  if FUse64Bit then
  begin
{$IFDEF WIN32}
    Result := FMapi64.GetNextUnread;

    //Copy contents of lists back to local string lists
    FRecip.Text := FMapi64.emRecipient;
    FBCC.Text := FMapi64.emBCC;
    FCC.Text := FMapi64.emCC;
    FAttachment.Text := FMapi64.emAttachment;
{$ENDIF}
  end
  else
  begin
    FAttachment.Clear;
    while (FUnreadIdx >= 0) and (not Assigned(FFolder.Msg[FUnreadIdx]) or not (FFolder.Msg[FUnreadIdx].Unread)) do
      dec(FUnreadIdx);
    if FUnreadIdx < 0 then
      Result := 9
    else
    begin
      Result := 0;
      with FFolder do
      begin
        FSubject := Msg[FUnreadIdx].Subject;
        FOrigAddress := Msg[FUnreadIdx].SenderAddress;
        FOriginator := Msg[FUnreadIdx].Sender;
        Msg[FUnreadIdx].GetRecepientsList(sxrtTo, FRecip);
        Msg[FUnreadIdx].GetRecepientsList(sxrtCc, FCC);
        Msg[FUnreadIdx].GetRecepientsList(sxrtBCC, FBCC);
        Try
          {$IFNDEF VER140} //Adjustment for D10
          s := PWideChar(Msg[FUnreadIdx].Body);
          {$ELSE}
          s := Msg[FUnreadIdx].Body;
          {$ENDIF}
        Except
          ClearErrorCode;
        End;
        FpLongText := s;
  //      StrPCopy(FpLongText, s);
        SaveAttachments;
        if not FLeaveUnread then
        begin
          if FDeleteAfterRead then
          begin
            DeleteMessage(Msg[FUnreadIdx]);
            Dec(FUnreadIdx);
          end
          else
          begin
            Msg[FUnreadIdx].SetReadFlag;
            Msg[FUnreadIdx].Unread := False;
          end;
        end
        else
          Dec(FUnreadIdx);
      end; // with FFolder do
    end; // if FUnreadIdx < 0 then
  end; //not FUse64Bit
end;

procedure TMapiExEmail.SaveAttachments;
//Save attachments into windows temp dir & add path + name into FAttachment stringlist
//Called automatically from GetNextUnread - it is the responsibility of the fucntion which
//calls that to delete the temp files when no longer required.
var
  FAttach : TsxMAPI_Attachment;
  i : integer;
  FStream : TFileStream;
  s, Path : AnsiString;
begin
  Path := WinGetWindowsTempDir;
  with FFolder do
  if Msg[FUnreadIdx].AttachCount > 0 then
  for i := 0 to Msg[FUnreadIdx].AttachCount - 1 do
  begin
    FAttach := Msg[FUnreadIdx].Attachment[i];
    if FAttach <> nil then
    begin
      // MH 12/06/06: Modified for ICE as Kevin appears to have emails with blank attachment filenames
      If (Trim(FAttach.FileName) <> '') Then
      Begin
        s := IncludeTrailingBackslash(Path) + FAttach.FileName;

        FStream := TFileStream.Create(s, fmCreate or fmShareDenyWrite);
        Try
          FAttach.Read(FStream);
          FAttachment.Add(s);
          FAttach.Save;
        Finally
          FStream.Free;
        End;
      End; // If (Trim(FAttach.FileName) <> '')
    end;
  end;
end;

function TMapiExEmail.ErrorString(ErrCode : Integer) : AnsiString;
begin
  Result := SysErrorMessage(ErrCode);
end;

procedure TMapiExEmail.DeleteReadMessages;
var
  i : integer;
begin
  if FUse64Bit then
  begin
{$IFDEF WIN32}
    FMapi64.DeleteReadMessages;
{$ENDIF}
  end
  else
  begin
    FFolder := FMAPI.Folder[sxftInbox];
    if Assigned(FFolder) then
    with FFolder do
    begin
      i := 0;
      while i < FFolder.MsgCount do
        if FFolder.Msg[i].Unread then
          inc(i)
        else
          FFolder.DeleteMessage(FFolder.Msg[i]);
    end;// with FFolder do
  end; //if FUseMapi64 then
end;

procedure TMapiExEmail.DeleteMessage;
//Delete message pointed at by FUnreadIDX.
begin
  if FUse64Bit then
  begin
{$IFDEF WIN32}
    FMapi64.DeleteReadMessages;
{$ENDIF}
  end
  else
  begin
    if (FUnreadIdx >= 0) and (FUnreadIdx < FFolder.MsgCount) then
      FFolder.DeleteMessage(FFolder.Msg[FUnreadIdx]);
  end;//if FUseMapi64 then
end;

procedure TMapiExEmail.SetMessageAsRead;
begin
  if (FUnreadIdx >= 0) and (FUnreadIdx < FFolder.MsgCount) then
  with FFolder do
  begin
    Msg[FUnreadIdx].SetReadFlag;
    Msg[FUnreadIdx].Unread := False;
  end;
end;


function TMapiExEmail.GetAttachment: TStrings;
begin
  Result := FAttachment;
end;

function TMapiExEmail.GetBcc: TStrings;
begin
  Result := FBCC;
end;

function TMapiExEmail.GetCC: TStrings;
begin
  Result := FCC;
end;

function TMapiExEmail.GetDeleteAfterRead: Boolean;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emDeleteAfterRead
  else
{$ENDIF}
    Result := FDeleteAfterRead;
end;

function TMapiExEmail.GetHandle: HWND;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emHandle
  else
{$ENDIF}
    Result := FHandle;
end;

function TMapiExEmail.GetInService: Boolean;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emService
  else
{$ENDIF}
    Result := FInService;
end;

function TMapiExEmail.GetPassword: ShortString;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emPassword
  else
{$ENDIF}
    Result := FPassword;
end;

function TMapiExEmail.GetProfile: ShortString;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emProfile
  else
{$ENDIF}
    Result := FProfile;
end;

function TMapiExEmail.GetRecip: TStrings;
var
  s : string;
begin
  Result := FRecip;
end;

function TMapiExEmail.GetShowDialog: Boolean;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emShowDialog
  else
{$ENDIF}
    Result := FShowDialog;
end;

function TMapiExEmail.GetSubject: ShortString;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emSubject
  else
{$ENDIF}
    Result := FSubject;
end;

function TMapiExEmail.GetUseDefProfile: Boolean;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emUseDefaultProfile
  else
{$ENDIF}
    Result := FUseDefProfile;
end;

procedure TMapiExEmail.SetDeleteAfterRead(const Value: Boolean);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emDeleteAfterRead := Value
  else
{$ENDIF}
    FDeleteAfterRead := Value;
end;

procedure TMapiExEmail.SetHandle(const Value: HWND);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emHandle := Value
  else
{$ENDIF}
    FHandle := Value;
end;

procedure TMapiExEmail.SetInService(const Value: Boolean);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emService := Value
  else
{$ENDIF}
    FInService := Value;
end;

procedure TMapiExEmail.SetPassword(const Value: ShortString);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emPassword := Value
  else
{$ENDIF}
    FPassword := Value;
end;

procedure TMapiExEmail.SetProfile(const Value: ShortString);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emProfile := Value
  else
{$ENDIF}
    FProfile := Value;
end;

procedure TMapiExEmail.SetShowDialog(const Value: Boolean);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emShowDialog := Value
  else
{$ENDIF}
    FShowDialog := Value;
end;

procedure TMapiExEmail.SetSubject(const Value: ShortString);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emSubject := Value
  else
{$ENDIF}
    FSubject := Value;
end;

procedure TMapiExEmail.SetUseDefProfile(const Value: Boolean);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emUseDefaultProfile := Value
  else
{$ENDIF}
    FUseDefProfile := Value;
end;

function TMapiExEmail.GetLeaveUnread: Boolean;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emLeaveUnread
  else
{$ENDIF}
    Result := FLeaveUnread;
end;

function TMapiExEmail.GetOrigAddress: ShortString;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emOriginatorAddress
  else
{$ENDIF}
    Result := FOrigAddress;
end;

function TMapiExEmail.GetOriginator: ShortString;
begin
{$IFDEF WIN32}
  if FUse64Bit then
    Result := FMapi64.emOriginator
  else
{$ENDIF}
    Result := FOriginator;
end;

procedure TMapiExEmail.SetLeaveUnread(const Value: Boolean);
begin
{$IFDEF WIN32}
  if FUse64Bit then
    FMapi64.emLeaveUnread := Value
  else
{$ENDIF}
    FLeaveUnread := Value;
end;

end.
