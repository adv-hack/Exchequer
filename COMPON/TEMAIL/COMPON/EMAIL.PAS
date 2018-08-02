{*******************************************************}
{                                                       }
{  TEmail component for Borland Delphi 2.10.0           }
{                                                       }
{     Please see the online documentation for           }
{     contributors, copyright, and release history      }
{                                                       }
{*******************************************************}

unit Email; { Email.PAS, Email.HPP }

{$F+} { force far calls }

{$DEFINE UseGenericThunks}

{$DEFINE DEBUG}
{$IFNDEF DEBUG}
  {$D-} {$Q-} {$R-} {$S-}
{$ENDIF DEBUG}

{$I+} { I/O exceptions needed for CopyAttachment }


{$IFDEF WIN32}
  { most Borland 32 bit compilers do have a "resourcestring" now... }
  {$DEFINE RESSTRING}
{$ELSE}
  { ...but 16 bit compilers (Delphi 1, that is) definitely don't }
  {$UNDEF RESSTRING}
{$ENDIF WIN32}

{$IFDEF VER90}
  { Delphi 2.0 - no resourcestring }
  {$UNDEF RESSTRING}
{$ENDIF VER90}

{$IFDEF VER93}
  { C++ Builder 1.0 - no resourcestring }
  {$UNDEF RESSTRING}
{$ENDIF VER93}


interface

uses
{$IFDEF WIN32}
  Windows,
{$ELSE}
  WinTypes, WinProcs,
{$ENDIF WIN32}
  Classes,
  SysUtils,

  SMapi { SMAPI.HPP, SMAPI.PAS }; { this is our generic Simple MAPI wrapper }


const
{$IFNDEF WIN32}
  { 16 bit implementation limits }
  RECIP_MAX       = 65000 div SizeOf(TMapiRecipDesc);
  ATTACH_MAX      = 65000 div SizeOf(TMapiFileDesc);
{$ELSE}
  { arbitrary limits for 32 bit }
  RECIP_MAX       = MaxInt div SizeOf(TMapiRecipDesc);
  ATTACH_MAX      = MaxInt div SizeOf(TMapiFileDesc);
{$ENDIF WIN32}

{$IFDEF BCB}
  { Let's have some fun now:

      C++ Builder 3.0 has a bug in the Pascal header generator
      that will make it translate
           type SString = ShortString
      to
           typedef typedef ShortString SString;
           ;

      Really.

    We can work around this problem by emitting the typedef
    ourselves and disallow it to be auto-processed.

    It would all be less of a mess if BCB 1.0 would also
    know these (undocumented) directives... }

  {$IFDEF VER110} { apply this fix only to BCB 3.0 }
    {$HPPEMIT 'typedef ShortString SString;'}
    {$NODEFINE SString}
  {$ENDIF VER110}

  type
    SString = ShortString;
{$ELSE}
  type
  {$IFDEF WIN32}
    SString   = ShortString;
  {$ELSE}
    SString   = string;
  {$ENDIF WIN32}
{$ENDIF BCB}


type
  TRecipAccessArray     = array [0 .. (RECIP_MAX - 1)] of TMapiRecipDesc;
  TlpRecipArray         = ^TRecipAccessArray;

  TAttachAccessArray    = array [0 .. (ATTACH_MAX - 1)] of TMapiFileDesc;
  TlpAttachArray        = ^TAttachAccessArray;

  TszRecipName    = array [0 .. 256] of Char;
  TlpszRecipName  = ^TszRecipName;

  TszPathName     = array[0 .. 256] of Char;
  TlpszPathname   = ^TszPathname;

  TszFileName     = array[0 .. 256] of Char;
  TlpszFileName   = ^TszFileName;


const
  EMAIL_OK = SUCCESS_SUCCESS;

{--------------------------}
{ Define TEmail component. }
{--------------------------}

type
  EMapiUnavailable = class(Exception);

  TMapiErrorEvent = procedure(Sender   : TObject;
                              ErrorCode: LongInt) of object;

  TEmail = class(TComponent)
  private
    FShowDialog     : Boolean;                { launch dialog after SendMail ?  }
    FAcknowledge    : Boolean;                { acknowledge receipt ?           }
    FAttachment     : TStrings;               { list of attachments             }
    FAttPathNames   : TStrings;               { Attachments temp file names     }
    FCC             : TStrings;               { list of CC's                    }
    FBcc            : Tstrings;               { list of Blind CC's              }
    FDateRecvd      : SString;                { Message date                    }
    FDownLoadFirst  : Boolean;                { Download messages at logon      }
    FHeaderOnly     : Boolean;                { ReadMail with MAPI_ENVELOPE_ONLY}
    FLeaveUnread    : Boolean;                { ReadMail with MAPI_PEEK         }
    FMessageId      : SString;                { next message Id from GetNext... }
    FMessageType    : SString;                { message type if non-IPM message }
    FNewSession     : Boolean;                { log in with new session         }
    FNoAttachments  : Boolean;                { ReadMail w. MAPI_SUPPRESS_ATTACH}
    FOnBeforeLogon  : TNotifyEvent;
    FOnAfterLogon   : TNotifyEvent;
    FOnBeforeLogoff : TNotifyEvent;
    FOnAfterLogoff  : TNotifyEvent;
    FOnBeforeSaveMail: TNotifyEvent;
    FOnAfterSaveMail: TNotifyEvent;
    FOnBeforeSendMail: TNotifyEvent;
    FOnAfterSendMail: TNotifyEvent;
    FOnMapiError    : TMapiErrorEvent;
    FOriginator     : SString;                { Message originator              }
    FOrigAddress    : SString;                { Message Originator's address    }
    FPassword       : SString;                { password for MAPI logon         }
    FpLongText      : PChar;                  { (long)  message body pointer    }
    FProfile        : SString;                { profile string for MAPI logon   }
    FRecip          : TStrings;               { list of recipients              }
    FSubject        : SString;                { message subject text            }
    FText           : SString;                { (short) message body            }
    FTruncAttFN     : Boolean;                { truncate attachment filename    }
    FUnread         : Boolean;                { Message read/unread status      }
    FUnreadOnly     : Boolean;                { GetNextMessageID returns unread }
    FUseDefProfile  : Boolean;                { use default profile fr. registry}
    FUseLongMessageID: Boolean;               { allow long message ID - GroupWise}

    function  GetVersion: SString;
    function  GetMapiAvail: boolean;          { MAPI dll has been loaded ? }

    procedure SetRecip(const Recip: TStrings);
    procedure SetCC   (const CC   : TStrings);
    procedure SetBcc  (const Bcc  : TStrings);
    procedure SetAttachment(const Attachment : TStrings);
    function  ListToRecipArray(FArray          : TStrings;
                               AulRecipClass   : ULONG;
                               lpRecipArray    : TlpRecipArray;
                               var nRecipients : Integer) : Integer;

    procedure SetDownLoadFirst(bDownLoadFirst: boolean);
    procedure SetNewSession(bNewSession: boolean);
  protected
    hSession        : ULONG;                  { MAPI Session number.  }
    flLogonFlags    : ULONG;                  { flag for logon parameters }

    procedure CheckMapi; virtual;
    function TruncAttachmentFN(const LongFN: SString): SString; virtual;

    function SendMailEx(DoSave: boolean): Integer;

    procedure DoBeforeLogon; virtual;
    procedure DoAfterLogon; virtual;
    procedure DoBeforeLogoff; virtual;
    procedure DoAfterLogoff; virtual;
    procedure DoBeforeSaveMail; virtual;
    procedure DoAfterSaveMail; virtual;
    procedure DoBeforeSendMail; virtual;
    procedure DoAfterSendMail; virtual;
    procedure DoMapiError(ErrorCode: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function Address                                       : Integer;
    function CheckAttachment(const AnAttachment : SString) : SString;
    function CheckRecipient (const ARecipient   : SString) : SString;
    procedure Clear;
    function CopyAttachment (Index              : Integer;
                             const DestPathName : SString;
                             DeleteAfterCopy    : Boolean) : Integer;
    function CountUnread                                   : ULONG;
    function DeleteMail                                    : Integer;
    procedure DownLoad;
    function GetLongText                                   : PChar;
    function GetNextMessageId                              : SString;
    function Logoff                                        : Integer;
    function Logon                                         : Integer;
    function ReadMail                                      : Integer;
    function SendMail                                      : Integer;
    function SaveMail                                      : Integer;
    function SetLongText(pLongText : PChar)                : Integer;

    property AttPathNames : TStrings read FAttPathNames;
    property DateRecvd    : SString read FDateRecvd;
    property HeaderOnly   : Boolean read FHeaderOnly    write FHeaderOnly
                                    Default False;
    property LeaveUnread  : Boolean read FLeaveUnread   write FleaveUnread
                                    Default True;
    property MessageId    : SString read FMessageId     write FMessageId;
    property MessageType  : SString read FMessageType   write FMessageType;
    property Originator   : SString read FOriginator;
    property OrigAddress  : SString read FOrigAddress;
    property NoAttachments: Boolean read FNoAttachments write FNoAttachments
                                    Default False;
    property Unread       : Boolean read Funread;

  published
    property Acknowledge  : Boolean     read FAcknowledge   write FAcknowledge
                                        default false;
    property Attachment   : TStrings    read FAttachment    write SetAttachment;
    property Bcc          : TStrings    read FBcc           write SetBcc;
    property CC           : TStrings    read FCC            write SetCC;
    property DownLoadFirst: Boolean     read FDownLoadFirst write SetDownLoadFirst;
    property MapiAvail    : boolean     read GetMapiAvail;
    property NewSession   : boolean     read FNewSession    write SetNewSession;
    property OnBeforeLogon   : TNotifyEvent    read FOnBeforeLogon    write FOnBeforeLogon;
    property OnAfterLogon    : TNotifyEvent    read FOnAfterLogon     write FOnAfterLogon;
    property OnBeforeLogoff  : TNotifyEvent    read FOnBeforeLogoff   write FOnBeforeLogoff;
    property OnAfterLogoff   : TNotifyEvent    read FOnAfterLogoff    write FOnAfterLogoff;
    property OnBeforeSaveMail: TNotifyEvent    read FOnBeforeSaveMail write FOnBeforeSaveMail;
    property OnAfterSaveMail : TNotifyEvent    read FOnAfterSaveMail  write FOnAfterSaveMail;
    property OnBeforeSendMail: TNotifyEvent    read FOnBeforeSendMail write FOnBeforeSendMail;
    property OnAfterSendMail : TNotifyEvent    read FOnAfterSendMail  write FOnAfterSendMail;
    property OnMapiError     : TMapiErrorEvent read FOnMapiError      write FOnMapiError;
    property Password     : SString     read FPassword      write FPassword;
    property Profile      : SString     read FProfile       write FProfile;
    property Recipient    : TStrings    read FRecip         write SetRecip;
    property ShowDialog   : Boolean     read FShowDialog    write FShowDialog
                                        default False;
    property Subject      : SString     read FSubject       write FSubject;
    property Text         : SString     read FText          write FText;
    property TruncAttFN   : Boolean     read FTruncAttFN    write FTruncAttFN
                                        default true;
    property UnreadOnly   : boolean     read FUnreadOnly    write FUnreadOnly;
    property UseDefProfile: Boolean     read FUseDefProfile write FUseDefProfile
                                        default False;
    property UseLongMessageID: Boolean  read FUseLongMessageID write FUseLongMessageID
                                        default True;

    property Version      : SString     read GetVersion {stored false};

{   property UserName     : SString     read FUserName     write FUserName;     }
{   property UserPassword : SString     read FUserPassword write FUserPassword; }

  end;

{ procedure Register; has been moved to email16.pas and email32.pas respectively }

const
  TEMAIL_VERSION = '2.09.02';


implementation

uses
 {$IFDEF WIN32}
   Registry
 {$ELSE}
   Call32NT { for thunking 16bit -> 32bit }
 {$ENDIF WIN32};


{ Create object. }
{----------------}

constructor TEmail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeSMAPI;
  { create private stringlist objects }
  { we need to create string lists for the TStrings }
  FRecip        := TStringList.Create;
  FCC           := TStringList.Create;
  FBcc          := TStringList.Create;
  FAttachment   := TStringList.Create;
  FAttPathNames := TStringList.Create;

  { initialize private data defaults}
  FLeaveUnread   := True;
  FUseLongMessageID := True;

{ Delphi will initialize the following members automatically to zero
  hSession       := 0;
  FAcknowledge   := False;
  FMessageId     := '';
  FMessageType   := '';
  FHeaderOnly    := False;
  FNoAttachments := False;
  FDateRecvd     := '';
  FDownLoadFirst := False;
  FOnBeforeLogon    := nil;
  FOnAfterLogon     := nil;
  FOnBeforeLogoff   := nil;
  FOnAfterLogoff    := nil;
  FOnBeforeSaveMail := nil;
  FOnAfterSaveMail  := nil;
  FOnBeforeSendMail := nil;
  FOnAfterSendMail  := nil;
  FOnMapiError      := nil;
  FOriginator    := '';
  FOrigAddress   := '';
  FpLongText     := nil;
  FProfile       := '';
  FPassword      := '';
  FUseDefProfile := False;
  FShowDialog    := False;
  FText          := '';
  flLogonFlags   := 0;
}
  FTruncAttFN := true; { for compatibility with MJK's changes }
end;


{ Destroy object. }
{-----------------}

destructor TEmail.Destroy;
begin
  FBcc.Free;
  FBcc := nil;

  FCC.Free;
  FCC := nil;

  FRecip.Free;
  FRecip := nil;

  FAttachment.Free;
  Fattachment := nil;

  FAttPathNames.Free;
  FAttPathNames := nil;

  StrDispose(FpLongText); { free text }
  FpLongText := nil;

  try
    if hSession <> 0 then
      Logoff;
  except
  end;
  FinalizeSMAPI;
  inherited Destroy;
end;


function TEmail.GetVersion: SString;
begin
  Result := TEMAIL_VERSION;
end;


function TEmail.GetMapiAvail: boolean;
begin
  Result := MapiAvailable; { call function in SMAPI.PAS }
end;

procedure TEmail.DoBeforeLogon;
begin
  if Assigned(FOnBeforeLogon) then
    FOnBeforeLogon(Self);
end;

procedure TEmail.DoAfterLogon;
begin
  if Assigned(FOnAfterLogon) then
    FOnAfterLogon(Self);
end;

procedure TEmail.DoBeforeLogoff;
begin
  if Assigned(FOnBeforeLogoff) then
    FOnBeforeLogoff(Self);
end;

procedure TEmail.DoAfterLogoff;
begin
  if Assigned(FOnAfterLogoff) then
    FOnAfterLogoff(Self);
end;

procedure TEmail.DoBeforeSaveMail;
begin
  if Assigned(FOnBeforeSaveMail) then
    FOnBeforeSaveMail(Self);
end;

procedure TEmail.DoAfterSaveMail;
begin
  if Assigned(FOnAfterSaveMail) then
    FOnAfterSaveMail(Self);
end;

procedure TEmail.DoBeforeSendMail;
begin
  if Assigned(FOnBeforeSendMail) then
    FOnBeforeSendMail(Self);
end;

procedure TEmail.DoAfterSendMail;
begin
  if Assigned(FOnAfterSendMail) then
    FOnAfterSendMail(Self);
end;

procedure TEmail.DoMapiError(ErrorCode: Integer);
begin
  if Assigned(FOnMapiError) then
    FOnMapiError(Self, ErrorCode);
end;


{ Test whether MAPI is available - if not, raise an exception }

procedure TEmail.CheckMapi;
{$IFDEF RESSTRING}
resourcestring
{$ELSE}
const
{$ENDIF RESSTRING}
  SNoMapi = 'MAPI services are not available on this system';
begin
  if not MapiAvailable then { call function in SMAPI.PAS }
    raise EMapiUnavailable.Create(SNoMapi);
end;

{ This is code to allow the component to thunk to the WIN32 API }

{$IFNDEF WIN32} {$IFDEF UseGenericThunks}
type
  HKEY = longint;
  PHKEY = ^HKEY;

  PDWORD = ^DWORD;

const
  HKEY_CURRENT_USER = $80000001;
  KEY_QUERY_VALUE = $0001;
  REG_SZ = 1;

  ERROR_SUCCESS = 0;
var
  id_W32RegCloseKey,
  id_W32RegOpenKeyEx,
  id_W32RegQueryValueEx: longint;

  W32RegCloseKey: function(hKey: HKEY; id: longint): longint;

  W32RegOpenKeyEx: function( hKey: HKEY; lpSubKey: PChar;
                             ulOptions: DWORD; samDesired: longint;
                             phkResult: PHKEY; id: longint): Longint;

  W32RegQueryValueEx: function( hKey: HKEY; lpValueName: PChar;
                                lpReserved: Pointer; lpType: PDWORD;
                                lpData: PByte; lpcbData: PDWORD;
                                id: longint): longint;

procedure InitWin32; far;
begin
  @W32RegQueryValueEx := @Call32;
  id_W32RegQueryValueEx := Declare32('RegQueryValueEx', 'advapi32', 'ippppp');
{
function RegQueryValueEx(hKey: HKEY; lpValueName: PChar;
  lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall;
}

  @W32RegOpenKeyEx := @Call32;
  id_W32RegOpenKeyEx := Declare32('RegOpenKeyEx', 'advapi32', 'ipiip');
{
function RegOpenKeyEx(hKey: HKEY; lpSubKey: PChar;
  ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint; stdcall;
}

  @W32RegCloseKey := @Call32;
  id_W32RegCloseKey := Declare32('RegCloseKey', 'advapi32', 'i');
{
function RegCloseKey(hKey: HKEY): Longint; stdcall;
}
end;

function RegOpenKeyEx32( ahKey: HKEY; lpSubKey: PChar;
                         ulOptions: DWORD; samDesired: longint;
                         var phkResult: HKEY): Longint;
var
  aKey : HKEY;
begin
  RegOpenKeyEx32 := W32RegOpenKeyEx(ahKey, lpSubKey, ulOptions, samDesired, @aKey, id_W32RegOpenKeyEx);
  phkResult := aKey;
end;

function RegCloseKey32(ahKey: HKEY): Longint;
begin
  RegCloseKey32 := W32RegCloseKey(ahKey, id_W32RegCloseKey);
end;


function RegQueryValueEx32( hKey: HKEY; lpValueName: PChar; lpReserved: Pointer;
                            lpType: DWORD; lpData: PByte; var lpcbData: DWORD): longint;
var
  theData: DWORD;
begin
  theData := lpcbData;
  RegQueryValueEx32 := W32RegQueryValueEx( hKey, lpValueName, nil, @lpType,
                                           lpData, @lpcbData, id_W32RegQueryValueEx);

end;
{$ENDIF UseGenericThunks} {$ENDIF WIN32}


{ Logon to E-Mail system. }
{-------------------------}

function TEmail.Logon: Integer;
const
  ProfileKey95 = 'Software\Microsoft\Windows Messaging Subsystem\Profiles';
  ProfileKeyNT = 'Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles';
var
  LogonProfile : PChar;
  LogonPassword: PChar;

  ProfileKey   : PChar;

{$IFDEF WIN32}
  Reg : TRegistry;
{$ELSE}
  {$IFDEF UseGenericThunks}
    RegHandle: HKEY;
    RegDataSize: longint;
    RegResult : longint;
  {$ENDIF UseGenericThunks}
{$ENDIF WIN32}

begin
  CheckMapi;

  Result := SUCCESS_SUCCESS;

  { Check if already logged in. }

  if hSession = 0 then
  begin

    if FUseDefProfile then
    begin
    {$IFDEF WIN32}
      Reg := TRegistry.Create;
      try
        { get platform (Win95/NT) dependent profile key                }
        {  code added by Ulrik Schoth schoth@krohne.mhs.compuserve.com }
        if Reg.KeyExists(ProfileKeyNT) then
        begin
          ProfileKey := ProfileKeyNT;
        end
        else
        begin
          ProfileKey := ProfileKey95;
        end;

        Reg.Rootkey := HKEY_CURRENT_USER;
        if Reg.OpenKey(ProfileKey, False) then
        begin
          try
            FProfile := Reg.Readstring('DefaultProfile');
          except
            FProfile := '';
          end;
        end;
      finally
        Reg.Free;
      end;
    {$ELSE}
      {$IFDEF UseGenericThunks}
        if Call32NTError = false then
        begin
          RegResult := RegOpenKeyEx32( HKEY_CURRENT_USER,
                                       ProfileKeyNT,
                                       0,
                                       KEY_QUERY_VALUE,
                                       RegHandle);

          { what, no NT registry entry ?? - then try Win95 entry }
          if RegResult <> ERROR_SUCCESS then
            RegResult := RegOpenKeyEx32( HKEY_CURRENT_USER,
                                         ProfileKey95,
                                         0,
                                         KEY_QUERY_VALUE,
                                         RegHandle);

          RegDataSize := SizeOf(FProfile)-1;
          RegResult := RegQueryValueEx32( RegHandle,
                                          'DefaultProfile',
                                          nil,
                                          REG_SZ,
                                          pointer(PChar(@FProfile)+1),
                                          RegDataSize);
          FProfile[0] := char(StrLen(PChar(@FProfile)+1));

          RegResult := RegCloseKey32(RegHandle);
        end;
      {$ENDIF UseGenericThunks}
    {$ENDIF WIN32}
    end;

    LogonProfile := nil;
    LogonPassword := nil;

    try
      if Length(FProfile) > 0 then
      begin
        LogonProfile := StrPCopy(StrAlloc(Length(FProfile)+1), FProfile);
      end;

      if Length(FPassword) > 0 then
      begin
        LogonPassword := StrPCopy(StrAlloc(Length(FPassword)+1), FPassword);
      end;

      DoBeforeLogon;

      Result := MapiLogon(0, LogonProfile, LogonPassword, flLogonFlags, 0, @hSession);
      if Result <> SUCCESS_SUCCESS then
        Result := MapiLogon(0, nil, nil, flLogonFlags or MAPI_Logon_UI, 0, @hSession);

      if Result = SUCCESS_SUCCESS then
        DoAfterLogon
      else
        DoMapiError(Result);

    finally
      StrDispose(LogonProfile);
      StrDispose(LogonPassword);
    end;
  end;
end;


{ Logoff E-Mail system. }
{-----------------------}

function TEmail.Logoff: Integer;
begin
  CheckMapi;

  Result := SUCCESS_SUCCESS;

  if hSession <> 0 then
  begin
    DoBeforeLogoff;

    Result   := MapiLogoff(hSession, 0, 0, 0);
    hSession := 0;

    DoAfterLogoff;
  end;
end;

{ Download e-mail messages now }
{------------------------------}

procedure TEmail.DownLoad;
begin
  DownLoadFirst := True;
  Logoff;
  Logon;
end;

{ truncate Attachment filename to 8.3 - specs and code by MJK }
{ slightly modified by Stefan Hoffmeister                     }
{-------------------------------------------------------------}
function TEmail.TruncAttachmentFN(const LongFN: SString): SString;
var
  Att83         : SString;
  Att83p        : Integer;
begin
  { Include the following if.....END section, ONLY if the
  { Attachment name should be truncated to about 12 chars,
    (usually in 8.3 format), and with the LEADING chars being
    discarded, if needed.                                      }

  if Length(LongFN) > 12 then
  begin
    Att83 := LongFN;
    Att83p := Pos('.', Att83);

    if Att83p > 9 then
    begin
      { }
      Att83 := Copy(Att83, Att83p-8, Length(Att83) - Att83p + 9);
    end;

    if Length(Att83) > 12 then
      Att83 := Copy(Att83, Length(Att83)-11, 12);

    while Att83[1] = '.' do
      Att83 := Copy(Att83, 2, Length(Att83)-1);

    TruncAttachmentFN := Att83;
  end
  else
  begin
    Result := LongFN; { no changes required }
  end;
end;

{ Send Mail message. }
{--------------------}

function TEmail.SendMailEx(DoSave: boolean): Integer;
var
  MapiMessage   : TMapiMessage;
  MapiRecipDesc : TMapiRecipDesc;
  MapiFileDesc  : TMapiFileDesc;
  lpRecipArray  : TlpRecipArray;
  lpAttachArray : TlpAttachArray;
  lpszPathname  : TlpszPathname;
  lpszFileName  : TlpszFileName;

  szSubject     : PChar;
  szText        : PChar;
  szMessageId   : PChar;
  szMessageType : PChar;

  Attachment    : SString;
  flFlags       : ULONG;
  flLogoff      : Boolean;

  i             : Integer;
  nRecipients   : Integer;
  nAttachments  : Integer;

begin
  CheckMapi;

  {make sure the cleanup does not free garbage }
  lpRecipArray  := nil;
  lpAttachArray := nil;

  flLogoff      := False;

  {check our built-in limits - which have effectively been removed }
  nRecipients := Frecip.Count + FCC.Count + FBCC.Count;
  if nRecipients > RECIP_MAX then
  begin
    Result := MAPI_E_TOO_MANY_RECIPIENTS;

    DoMapiError(Result);

    exit;
  end;

  nAttachments := FAttachment.Count;
  if nAttachments > ATTACH_MAX then
  begin
    Result := MAPI_E_TOO_MANY_FILES;

    DoMapiError(Result);

    exit;
  end;

  { begin the work }
  try

    flLogoff := (hSession = 0);

    { Logon to mail server if not already logged on. }

    if Logon <> SUCCESS_SUCCESS then
    begin
      Result := MAPI_E_LOGIN_FAILURE;

      DoMapiError(Result);
      
      exit;
    end;


    { Initialise MAPI structures and local arrays. }

    FillChar(MapiMessage,   SizeOf(TMapiMessage),   0);
    FillChar(MapiRecipDesc, SizeOf(TMapiRecipDesc), 0);
    FillChar(MapiFileDesc,  SizeOf(TMapiFileDesc),  0);

    lpRecipArray  := TlpRecipArray(StrAlloc(nRecipients*SizeOf(TMapiRecipDesc)));
    FillChar(lpRecipArray^, StrBufSize(PChar(lpRecipArray)), 0);

    lpAttachArray := TlpAttachArray(StrAlloc(nAttachments*SizeOf(TMapiFileDesc)));
    FillChar(lpAttachArray^, StrBufSize(PChar(lpAttachArray)), 0);

    { Fill in subject & message text. }

    szSubject      := nil;
    szText         := nil;
    szMessageId    := nil;
    szMessageType  := nil;

    try
      if Length(FSubject) > 0 then
      begin
        szSubject := StrAlloc(length(FSubject) + 1);
        StrPCopy(szSubject, FSubject);
      end;
      MapiMessage.lpszSubject  := szSubject;

      if Length(FText) > 0 then
      begin
        szText := StrAlloc(length(FText) + 1);
        StrPCopy(szText, FText);
      end;
      MapiMessage.lpszNoteText := szText;

      { for non-IPM messages }
      if Length(FMessageType) > 0 then
      begin
        szMessageType := StrAlloc(Length(FMessageType) + 1);
        StrPCopy(szMessageType, FMessageType);
      end;
      MapiMessage.lpszMessageType := szMessageType;

      if FpLongText <> nil then
        MapiMessage.lpszNoteText := FpLongText;

      { check and fill in recipients if any}
      nRecipients := 0;
      ListToRecipArray(FRecip, MAPI_TO,  lpRecipArray, nRecipients);
      ListToRecipArray(FCC,    MAPI_CC,  lpRecipArray, nRecipients);
      ListToRecipArray(FBcc,   MAPI_BCC, lpRecipArray, nRecipients);


      MapiMessage.nRecipCount := nRecipients;

      if nRecipients > 0 then
      begin
        if FShowDialog then
          flFlags := MAPI_DIALOG
        else
          flFlags := 0; { Don't display MAPI Dialog if recipient specified. }

        MapiMessage.lpRecips := @lpRecipArray^;
      end
      else
      begin
        flFlags := MAPI_DIALOG; { we need to show the dialog }
        MapiMessage.lpRecips  := nil ;
      end;

      { Process file attachments. }

      nAttachments := 0;

      for i := 0 to (Fattachment.Count - 1) do
      begin
        Attachment := CheckAttachment(Fattachment.Strings[i]);
        if Length(Attachment) = 0 then
        begin
          Result := MAPI_E_ATTACHMENT_NOT_FOUND;

          DoMapiError(Result);

          exit;
        end;
        lpAttachArray^[i].nPosition    := Integer($FFFFFFFF);  {Top of message. }
        lpszPathname                   := new(TlpszPathname);
        lpAttachArray^[i].lpszPathName := StrPcopy(lpszPathname^, Attachment);


      { begin code added by MJK }
        lpszFileName                   := new(TlpszFileName);

        { truncate attachment filename if desired }
        if FTruncAttFN then
        begin
          { truncate }
          lpAttachArray^[i].lpszFileName :=
            StrPCopy(lpszFileName^, TruncAttachmentFN(ExtractFileName(Attachment)))
        end
        else
        begin
          { leave alone }
          lpAttachArray^[i].lpszFileName :=
            StrPCopy(lpszFileName^, ExtractFileName(Attachment));
        end;
      {end code added by MJK}

        Inc(nAttachments);
      end;

      MapiMessage.nFileCount := nAttachments;
      if nAttachments > 0 then
      begin
        MapiMessage.lpFiles := @lpAttachArray^;
      end
      else
      begin
        MapiMessage.lpFiles := nil;
      end;

      { receipt requested ? }
      if FAcknowledge then
        MapiMessage.flFlags := MapiMessage.flFlags or MAPI_RECEIPT_REQUESTED;

      if DoSave then
      begin
        { set the message ID; leave nil if MessageID is empty }
        if FMessageID <> '' then
        begin
          szMessageId := StrAlloc(MsgIdSize);
          StrPcopy(SzMessageId, FMessageId);
        end;

        { finally save the email message }
        DoBeforeSaveMail;

        Result := MapiSaveMail(hSession, 0, @MapiMessage, 0, 0, szMessageId);
        if Result <> SUCCESS_SUCCESS then
          DoMapiError(Result)
        else
          DoAfterSaveMail;
      end
      else
      begin
        { finally send the email message }

        DoBeforeSendMail;

        Result := MapiSendMail(hSession, 0, @MapiMessage, flFlags, 0);
        if Result = SUCCESS_SUCCESS then
          DoAfterSendMail
        else
          DoMapiError(Result);
      end;


    finally
      StrDispose(szSubject);
      StrDispose(szText);
      StrDispose(szMessageID);
      StrDispose(szMessageType);
    end;

  finally
    { dispose of the recipient & CC name strings }
    if Assigned(lpRecipArray) then
      for i := 0 to (nRecipients - 1) do
      begin
        if Assigned(lpRecipArray^[i].lpszName) then
          Dispose(lpRecipArray^[i].lpszName);

        if Assigned(lpRecipArray^[i].lpszAddress) then
          Dispose(lpRecipArray^[i].lpszAddress);
      end;

    { dispose of the recipient/CC/BCC array }
    StrDispose(PChar(lpRecipArray));

    { dispose of the attachment file name strings }
    if Assigned(lpAttachArray) then
      for i := 0 to (nAttachments - 1) do
      begin
        Dispose(lpAttachArray^[i].lpszPathname);
        Dispose(lpAttachArray^[i].lpszFileName);
      end;

    { dispose of the attachment array }
    StrDispose(PChar(lpAttachArray));

    { Auto logoff, if no session was active. }
    if flLogoff = True then
      Logoff;
  end;

end;

function TEmail.SendMail: Integer;
begin
  Result := SendMailEx(false);
end;

function TEmail.SaveMail: Integer;
begin
  Result := SendMailEx(true);
end;

{ Check a recipient }
{-------------------}

function TEmail.CheckRecipient(const ARecipient: SString) : SString;
const
  RecipSize = 256;
var
  szRecipName   : PChar;
  lpRecip       : lpMapiRecipDesc;
  flLogoff      : Boolean;
  MapiResult    : ULONG;

begin
  CheckMapi;

  flLogoff := (hSession = 0);

  { Logon to mail server if not already logged on . }
  if Logon <> SUCCESS_SUCCESS then exit;

  szRecipName := nil;
  try
    szRecipName := StrAlloc(RecipSize);
    szRecipName := StrPCopy(szRecipName, ARecipient);

    MapiResult := MapiResolveName(hSession, 0, szRecipName, 0, 0, @lpRecip);
    if (MapiResult = MAPI_E_AMBIGUOUS_RECIPIENT) or
       (MapiResult = MAPI_E_UNKNOWN_RECIPIENT) then
    begin
      MapiResult := MapiResolveName( hSession, 0, szRecipName, MAPI_DIALOG,
                                     0, @lpRecip);
    end;

    { same changes as below...}

    if MapiResult <> SUCCESS_SUCCESS then
    begin
      DoMapiError(MapiResult);

      Result := '';
      exit;
    end
    else
    begin

      { the original address looked like a direct address }
      if ((Pos('[', ARecipient) > 0) and (Pos(']', ARecipient) > 0)) and

      { did Windows recognize this?}
         ((StrScan (lpRecip^.lpszName, '[') = nil) and
          (StrRScan(lpRecip^.lpszName, ']') = nil)) then
      begin
        { use original address, and DO NOT remove the brackets...
          we will need them later when the array is filled to determine
          whether this is a direct address or not }
        Result := ARecipient;
      end
      else
      begin
        { use resolved address }
        Result := StrPas(lpRecip^.lpszName);
      end;

      MapiFreeBuffer(lpRecip);
    end;

  finally
    StrDispose(szRecipName);
    if flLogoff = True then Logoff;
  end;

end;


{ Check if an attachment is a valid file }
{----------------------------------------}

function TEmail.CheckAttachment(const AnAttachment: SString): SString;
begin
  if not FileExists(AnAttachment) then
    Result := ''
  else
    Result := AnAttachment;
end;

{ Clear important fields of TEmail       }
{----------------------------------------}

procedure TEmail.Clear;
begin
  FAcknowledge := false;

  FAttachment.Clear;
  FBcc.Clear;
  FCC.Clear;
  FRecip.Clear;

  FSubject := '';

  SetLongText(nil); { implicitly sets FText = '' }
end;


{ Read e-mail message with FMessageId }
{-------------------------------------}

function TEmail.ReadMail: Integer;
var
  lppMapiMessage : lpMapiMessage;
  lpRecipArray   : TlpRecipArray;
  lpAttachArray  : TlpAttachArray;

  szMessageID : PChar;
  flLogoff    : Boolean;
  MapiResult  : ULONG;
  flFLags     : ULONG;
  i           : Integer;

begin
  CheckMapi;

  { Auto Logoff, if no session active. }
  flLogoff := (hSession = 0);

  { Logon to mail server. }
  if Logon <> SUCCESS_SUCCESS then
  begin
    Result := MAPI_E_LOGIN_FAILURE;
    exit;
  end;

  szMessageID := nil;
  try
    if FMessageId = '' then
    begin
      Result := MAPI_E_INVALID_MESSAGE;

      DoMapiError(Result);

      exit;
    end;

    szMessageId := StrAlloc(MsgIdSize);
    FillChar(szMessageID^, MsgIdSize, 0);

    StrPCopy(szMessageId, FMessageId);

    flFlags := 0;
    if FLeaveUnread   then flFlags := MAPI_PEEK;
    if FNOAttachments then flFlags := flFlags or MAPI_SUPPRESS_ATTACH;
    if FHeaderOnly    then flFlags := flFlags or MAPI_ENVELOPE_ONLY;

    MapiResult := MapiReadMail(hSession, 0, szMessageId, flFlags, 0, lpMapiMessage(@lppMapiMessage));
    if MapiResult <> SUCCESS_SUCCESS then
    begin
      Result := MapiResult;

      DoMapiError(Result);

      exit;
    end;

    { copy the message type }
    FMessageType := '';
    if lppMapiMessage^.lpszMessageType <> nil then
      FMessageType := StrPas(lppMapiMessage^.lpszMessageType);


    { copy recipients to CC and Recipient stringlists }

    Frecip.Clear;
    FCC.Clear;
    FBcc.Clear;
    if lppMapiMessage = nil then
    begin
      Result := 1;
      exit;
    end;
    lpRecipArray := @lppMapiMessage^.lpRecips^;

    if lpRecipArray <> nil then
    begin
      for i := 0 to (lppMapiMessage^.nRecipCount - 1) do
      begin
        case lpRecipArray^[i].ulRecipClass of

          MAPI_TO:  FRecip.Add(StrPas(lpRecipArray^[i].lpszName));

          MAPI_CC:  FCC.Add(StrPas(lpRecipArray^[i].lpszName));

          MAPI_BCC: FBcc.Add(StrPas(lpRecipArray^[i].lpszName));

        end;
      end;
    end;

    { copy attachments to attchment stringlist                          }
    { Roman Popov suggests using lpszPathName instead of lpszFileName.  }
    { It seems that lpszFilename is not used by all MAPI implementations}
    { This is undocumented, but if attachments are requested, both the  }
    { temp pathname of the attachment and the filename part of the      }
    { original attachment pathname are returned. I give you the temp    }
    { pathname if the filename part is empty now.                       }
    { As a bonus you always get the pathname in a new read-only runtime }
    { stringlist property if NoAttachments := False.                    }
    { -- dh 03-05-97 -- }

    FAttachment.Clear;
    FAttPathNames.Clear;              { new read-only property }

    lpAttachArray := @lppMapiMessage^.lpFiles^;

    if lpAttachArray <> nil then { 2.10.0: added test for nil }
    begin
      for i := 0 to (lppMapiMessage^.nFileCount - 1) do
      begin
        if (lpAttachArray^[i].lpszFileName <> nil) then
          FAttachment.Add(StrPas(lpAttachArray^[i].lpszFileName))
        else
          FAttachment.Add(StrPas(lpAttachArray^[i].lpszPathName));

        if FNoAttachments = False then
          if lpAttachArray^[i].lpszPathName <> nil then
            FAttPathNames.Add(StrPas(lpAttachArray^[i].lpszPathName))
          else
            FAttPathNames.Add('');
      end;
    end;

    { copy subject Text }

    FSubject := '';
    if lppMapiMessage^.lpszSubject <> nil then
      FSubject := StrPas(lppMapiMessage^.lpszSubject);

    { copy message body }

    StrDispose(FpLongText); { test for nil implicit in StrDispose }
    FpLongText := nil;
    FText := '';
    if lppMapiMessage^.lpszNoteText <> nil then
    begin
      if StrLen(lppMapiMessage^.lpszNoteText) < 256 then
      begin
        FText := StrPas(lppMapiMessage^.lpszNoteText);
      end
      else
      begin
        FpLongText := StrNew(lppMapiMessage^.lpszNoteText);
      end;
    end;

    { set message status }
    (*
    if (Boolean(lppMapiMessage^.flFlags and MAPI_UNREAD) = True) then
      Funread := True
    else
      FunRead := False;
    *)
    FUnRead := (lppMapiMessage^.flFlags and MAPI_UNREAD <> 0);

    { copy message originator }
    FOriginator := StrPas(lppMapiMessage^.lpOriginator^.lpszName);

    { copy originators mail address }
    if lppMapiMessage^.lpOriginator^.lpszAddress <> nil then
      FOrigAddress := StrPas(lppMapiMessage^.lpOriginator^.lpszAddress);

    { copy message date }

    if lppMapiMessage^.lpszDateReceived <> nil then
      FDateRecvd := StrPas(lppMapiMessage^.lpszDateReceived);

    Result := SUCCESS_SUCCESS;
    MapiFreeBuffer(lppMapiMessage);
  finally
    StrDispose(szMessageId);
    { Auto logoff, if no session was active. }
    if flLogoff = True then Logoff;
  end;
end;

{ CopyAttachment :  }
{-------------------}

function TEmail.CopyAttachment(Index              : Integer;
                               const DestPathname : SString;
                               DeleteAfterCopy    : Boolean) : Integer;
const
  BUFSIZE = 32768;

type
  TBuffer = array[0..(BUFSIZE - 1)] of char;
  TBufp   = ^TBuffer;

var
  FromF, ToF : File;
  NumRead, NumWritten : Integer;
  bufp : TBufp;

{$IFDEF RESSTRING}
resourcestring
{$ELSE}
const
{$ENDIF RESSTRING}
  SIllegalAttachmentOperation = 'CopyAttachment called when NoAttachments = True !!';
  SAttachmentIndexRangeError = 'CopyAttachment : index for pathnames stringlist is out of bounds';
  SAttachmentNotFound = 'CopyAttachment : attachment not found !!';
  SAttachmentOutOfMemory = 'CopyAttachment : no memory for copy buffer';
  SAttachmentIOError = 'CopyAttachment : Input-Output error on copy operation';
begin
  { check if attachments present }
  if FNoAttachments = True then
    raise EMapiAttachmentError.Create(SIllegalAttachmentOperation);

  { is the index legal ? }
  if Index > (FAttPathNames.Count - 1) then
    raise EMapiAttachmentError.Create(SAttachmentIndexRangeError);

  { is the file there ? }
  if not FileExists(FAttPathNames.Strings[Index]) then
    raise EMapiAttachmentError.Create(SAttachmentNotFound);

  { allocate file copy buffer }
  try
    Bufp := New(TBufp);
  except
    raise EMapiAttachmentError.Create(SAttachmentOutOfMemory);
  end;

  try                          { protect buffer allocation }
    try                        { catch all I-O errors }
      AssignFile(FromF, FAttPathNames.Strings[Index]);
      AssignFile(ToF, DestPathName);

      Reset(FromF, 1);
      try                      { make sure we close inputfile }
        Rewrite(ToF, 1);
        try                    { and outputfile too }
          repeat
            BlockRead(FromF, Bufp^, BUFSIZE, NumRead);
            BlockWrite(ToF, Bufp^, NumRead, NumWritten);
          until (NumRead = 0) or (NumWritten <> NumRead);
        finally
          CloseFile(ToF);
        end;
      finally
        CloseFile(FromF);
      end;

      if DeleteAfterCopy then
        SysUtils.DeleteFile(FattPathNames.Strings[Index]);

    except
      raise EMapiAttachmentError.Create(SAttachmentIOError);
    end;

  finally
    Dispose(Bufp);
  end;

  Result := 0;
end;


{ Delete e-mail message with FMessageId }
{---------------------------------------}

function TEmail.DeleteMail: Integer;
var
  szMessageID : PChar;
  flLogoff    : Boolean;
  MapiResult  : ULONG;
  flFLags     : ULONG;

begin
  CheckMapi;

  { Auto Logoff, if no session active. }
  flLogoff := (hSession = 0);

  { Logon to mail server. }
  if Logon <> SUCCESS_SUCCESS then
  begin
    Result := MAPI_E_LOGIN_FAILURE;
    exit;
  end;

  szMessageID := nil;
  try
    if FMessageId = '' then
    begin
      Result := MAPI_E_INVALID_MESSAGE;

      DoMapiError(Result);

      exit;
    end;
    szMessageId := Stralloc(MsgIdSize);
    StrPcopy(SzMessageId, FMessageId);

    flFlags := 0;
    MapiResult := MapiDeleteMail(hSession, 0, szMessageId, flFlags, 0);
    if MapiResult <> SUCCESS_SUCCESS then
    begin
      Result := MapiResult;

      DoMapiError(Result);

      exit;
    end;

    FMessageId := '';      { has become invalid }

    Result := SUCCESS_SUCCESS;

  finally
    StrDispose(szMessageID);
    { Auto logoff, if no session was active. }
    if flLogoff = True then Logoff;
  end;
end;


{ make a copy of the message body and store pointer to it in TEmail }
{-------------------------------------------------------------------}

function TEmail.SetLongText(pLongText: PChar): Integer;
begin
  { free existing text, check for nil is implicit in StrDispose }
  StrDispose(FpLongText);
  FText := '';

  { the Delphi 3.01 online documentation is wrong in
    claming that StrNew will never return NIL; the VCL
    source code says the opposite }
  if pLongText <> nil then
  begin
    FpLongText := StrNew(pLongText);
    Result := StrLen(FpLongText);
  end
  else
  begin
    FpLongText := nil;
    Result := 0;
  end;
end;


{ get a pointer to the message body }
function TEmail.GetLongText: PChar;
begin
  Result := FpLongText;
end;


{ get net message ID }
{--------------------}

function TEmail.GetNextMessageId: SString;
var
  szMessageID     : PChar;
  szSeedMessageID : PChar;
  flLogoff        : Boolean;
  flFlags         : ULONG;
  MapiResult      : ULONG;

begin
  CheckMapi;

  szMessageID     := nil;
  szSeedMessageID := nil;

  { Auto Logoff, if no session active. }
  flLogoff := (hSession = 0);

  { Logon to mail server. }
  if Logon <> SUCCESS_SUCCESS then
  begin
    Result := '';
    exit;
  end;

  try
    szMessageID := StrAlloc(MsgIdSize); { MAPI 32bit !! }
    szSeedMessageID := StrAlloc(MsgIdSize); { MAPI 32bit !! }
    FillChar(szSeedMessageID^, MsgIdSize, 0);

    if Length(FMessageId) = 0 then
    begin
      FillChar(szMessageID^, MsgIdSize, 0);
    end
    else
    begin
      StrPCopy(szMessageId, FMessageId);
    end;

    StrCopy(szSeedMessageId, szMessageId);
    flFlags := 0;

    if FUnreadOnly then
      inc(flFlags, MAPI_UNREAD_ONLY);

    if FUseLongMessageID then
      inc(flFlags, MAPI_LONG_MSGID);

    MapiResult := MapiFindNext(hSession, 0, nil, szSeedMessageID, flflags, 0, @szMessageID^);
    if  MapiResult = SUCCESS_SUCCESS then
    begin
      FMessageId := StrPas(szMessageId);
    end
    else
    begin
      DoMapiError(MapiResult);

      FMessageId := '';
    end;

  finally
    StrDispose(szMessageID);
    StrDispose(szSeedMessageID);

    { Auto logoff, if no session was active. }
    if flLogoff = True then Logoff;
  end;

  Result := FMessageID;

end;

{ set recipient }
{---------------}

procedure TEmail.SetRecip(const Recip: TStrings);
begin
  FRecip.Assign(Recip);
end;

{ set CC }
{--------}

procedure TEmail.SetCC(const CC: TStrings);
begin
  FCC.Assign(CC);
end;


{ set  BCC }
{----------}

procedure TEmail.SetBcc(const Bcc: TStrings);
begin
  FBcc.Assign(Bcc);
end;


{ set attachment }
{----------------}

procedure TEmail.SetAttachment(const Attachment: TStrings);
begin
  FAttachment.Assign(Attachment);
end;


{ set DownloadFirst property settings }
{-------------------------------------}

procedure TEmail.SetDownLoadFirst(bDownLoadFirst: boolean);
begin
  if bDownLoadFirst then
    flLogonFlags := flLogonFlags or MAPI_FORCE_DOWNLOAD
  else
    flLogonFlags := flLogonFlags and (not MAPI_FORCE_DOWNLOAD);

  FDownLoadFirst := bDownLoadFirst;
end;

{ set NewSession property settings }
{-------------------------------------}

procedure TEmail.SetNewSession(bNewSession: boolean);
begin
  if bNewSession then
    flLogonFlags := flLogonFlags or MAPI_NEW_SESSION
  else
    flLogonFlags := flLogonFlags and (not MAPI_NEW_SESSION);

  FNewSession := bNewSession;
end;

{ Count number of unread messages. }
{----------------------------------}

function TEmail.CountUnread: ULONG;
var
  szMessageID     : PChar;
  szSeedMessageID : PChar;
  flFlags         : ULONG;
  Count           : ULONG;
  flLogoff        : Boolean;
begin
  CheckMapi;

  Count := 0;

  { Auto Logoff, if no session active. }
  flLogoff := (hSession = 0);

  { Logon to mail server. }
  if Logon <> SUCCESS_SUCCESS then
  begin
    Result := MAPI_E_LOGIN_FAILURE;
    exit;
  end;

  szMessageId := nil;
  szSeedMessageId := nil;
  { Start at first message. }
  try
    szMessageID := StrAlloc(MsgIdSize); { MAPI 32bit !! }
    szSeedMessageID := StrAlloc(MsgIdSize); { MAPI 32bit !! }
    FillChar(szMessageID^, MsgIdSize, 0);
    FillChar(szSeedMessageID^, MsgIdSize, 0);

    flFlags := MAPI_UNREAD_ONLY;

    if FUseLongMessageID then
      inc(flFlags, MAPI_LONG_MSGID);

    while MapiFindNext( hSession, 0, nil, szSeedMessageID,
                        flFlags, 0, @szMessageID^) = SUCCESS_SUCCESS do
    begin
      if StrComp(szSeedMessageId, szMessageId) = 0 then
        break
      else
        StrCopy(szSeedMessageId,szMessageId);

      inc(Count);
    end;

  finally
    StrDispose(szMessageID);
    StrDispose(szSeedMessageID);

    { Auto logoff, if no session was active. }
    if flLogoff = True then Logoff;
  end;

  Result := Count;
end;

 { Following code added by Rudi Claasen }

{ get address dialog }
{--------------------}

function TEmail.Address: Integer;
var
  MapiRecipDesc : TMapiRecipDesc;
  lpRecipArray  : TlpRecipArray;
  lpNwRecipArray: TlpRecipArray;
  lppRecipArray : lpMapiRecipDesc;

  flLogoff      : Boolean;
  MapiResult    : ULONG;

  i             : Integer;

  nRecipients   : Integer;    { number of initial recipients after address check }
  nNwRecipients : Integer;    { number of recipients returned by MapiAddress }

begin
  CheckMapi;

  { make sure the cleanup does not free garbage }
  lpRecipArray  := nil;

  flLogoff       := False;

  { check our built-in limits }
  nRecipients := FCC.Count + FBCC.Count + Frecip.Count;
  if nRecipients > RECIP_MAX then
  begin
    Result := MAPI_E_TOO_MANY_RECIPIENTS;

    DoMapiError(Result);

    exit;
  end;

  { begin the work}
  try
    lpRecipArray  := TlpRecipArray(StrAlloc(nRecipients*SizeOf(TMapiRecipDesc)));
    FillChar(lpRecipArray^, StrBufSize(PChar(lpRecipArray)), 0);

    flLogoff := (hSession = 0);

    { Logon to mail server if not already logged on. }

    if Logon <> SUCCESS_SUCCESS then
    begin
      Result := MAPI_E_LOGIN_FAILURE;
      exit;
    end;
    { Initialise MAPI structures and local arrays. }

    FillChar(MapiRecipDesc, SizeOf(TMapiRecipDesc), 0);

    nRecipients := 0;
    { check and fill in recipients if any }
    ListToRecipArray(FRecip, MAPI_TO,  lpRecipArray, nRecipients);
    ListToRecipArray(FCC,    MAPI_CC,  lpRecipArray, nRecipients);
    ListToRecipArray(FBcc,   MAPI_BCC, lpRecipArray, nRecipients);

    Result := -1;
    MapiResult := MapiAddress (hSession,
                               0,
                               '',
                               4,
                               '',
                               nRecipients,
                               lpRecipArray^[0],
                               0,
                               0,
                               @nNwRecipients,
                               lppRecipArray);
    if MapiResult <> SUCCESS_SUCCESS then
    begin
      Result := MapiResult;

      DoMapiError(Result);

      exit;
    end;

    try
      lpNwRecipArray := @lppRecipArray^;

      { Convert names to TStringList }
      FRecip.Clear;
      FCC.Clear;
      FBcc.Clear;
      for i := 0 to (nNwRecipients - 1) do
      begin
        if lpNwRecipArray^[i].ulRecipClass = MAPI_TO then
          FRecip.Add(StrPas(lpNwRecipArray^[i].lpszName));

        if lpNwRecipArray^[i].ulRecipClass = MAPI_CC then
          FCC.Add(StrPas(lpNwRecipArray^[i].lpszName));

        if lpNwRecipArray^[i].ulRecipClass = MAPI_BCC then
          FBcc.Add(StrPas(lpNwRecipArray^[i].lpszName));
      end;
    finally
      MapiFreeBuffer(lppRecipArray);      { added 17/02/97 -- dh --}
    end;

    Result := SUCCESS_SUCCESS;

  finally
    { dispose of the recipient & CC & BCC name strings }
    { free only those that passed initial address check }
    if Assigned(lpRecipArray) then
    begin
      for i := 0 to (nRecipients - 1) do
      begin
        Dispose(lpRecipArray^[i].lpszName);
      end;
    end;

    { dispose of the recipient/CC/BCC array }
    StrDispose(PChar(lpRecipArray));

    { Auto logoff, if no session was active. }
    if flLogoff = True then Logoff;
  end;
end;


{ list to recipient arrary }
{--------------------------}

Function TEmail.ListToRecipArray( FArray          : TStrings;
                                  AulRecipClass   : ULONG;
                                  lpRecipArray    : TlpRecipArray;
                                  var nRecipients : Integer): Integer;
const
  RecipSize = 256;
var
  lpRecip    : lpMapiRecipDesc;

  szRecipName: PChar;
  MapiResult : ULONG;
  i          : Integer;

  s: SString;
begin
  { CheckMapi;   ListToRecipArray is an internal function that can/should
                 only get called by code that has already called CheckMapi }

  szRecipName := nil;
  try
    szRecipName := StrAlloc(RecipSize);
    Result := SUCCESS_SUCCESS;

    for i := 0 to (FArray.Count - 1) do
    begin
      if Length(FArray.Strings[i]) > 0 then           { recipient specified }
      begin
        StrPCopy(szRecipName, FArray.Strings[i]);     { check recipients name }

        MapiResult := MapiResolveName(hSession, 0, szRecipName, 0, 0, @lpRecip);
        if (MapiResult = MAPI_E_AMBIGUOUS_RECIPIENT) or
           (MapiResult = MAPI_E_UNKNOWN_RECIPIENT) then
        begin
          MapiResult := MapiResolveName( hSession, 0, szRecipName,
                                         MAPI_DIALOG, 0, @lpRecip);
        end;

        { Windows will either be happy about something like [FAX:123456] or not;
          if it is happy it will strip  '[FAX:' and ']', leaving just 123456

          Strategy:
          - Find out whether szRecipName originally contained '[', ']'
          - Check whether they are still there
             -> error, NO direct address
          - [] are gone, so simply add the ORIGINAL string, NOT the modified
              MAPI resolved name to .lpszAddress }

        if MapiResult <> SUCCESS_SUCCESS then
        begin
          Result := MapiResult;

          DoMapiError(Result);
        end
        else
        begin

          { the original address looked like a direct address }
          if ((Pos('[', FArray.Strings[i]) > 0) and (Pos(']', FArray.Strings[i]) > 0)) and

          { did Windows recognize this?}
             ((StrScan (lpRecip^.lpszName, '[') = nil) and
              (StrRScan(lpRecip^.lpszName, ']') = nil)) then
          begin
            { use original address }
            { do NOT re-assign FArray.Strings }
            MapiFreeBuffer(lpRecip); { free the buffer }

            with lpRecipArray^[nRecipients] do
            begin
              s := FArray.Strings[i];

              { remove [ ] }
              { this assumes that there is only ONE of '[' and ']' each in the string }
              { testing indicates that for a valid direct address - which we DO have
                here - this is always the case; no documentation could be found though
                that assures us of this }
              Delete(s, Pos(']', s), 1);
              Delete(s, Pos('[', s), 1);

              ulRecipClass   := AulRecipClass;
              lpszAddress    := StrPCopy( new(TlpszRecipName)^, s);
              lpszName       := StrPCopy( new(TlpszRecipName)^, s);
            end;
          end
          else
          begin
            { use resolved address }
            FArray.Strings[i] := StrPas(lpRecip^.lpszName);

            with lpRecipArray^[nRecipients] do
            begin
              ulRecipClass  := AulRecipClass;

              lpszName      := StrCopy( new(TlpszRecipName)^, lpRecip^.lpszName);

              { Eudora MAPI DLL does not fill in lpszAddress                 }
              { "Ken Clark" <chronological@dial.pipex.com> 16/07/1998        }
              if lpRecip^.lpszAddress = nil then
                lpszAddress := StrCopy(new(TlpszRecipName)^, lpRecip^.lpszName)
              else
                lpszAddress := StrCopy(new(TlpszRecipName)^, lpRecip^.lpszAddress);

              { Old code:
                  lpszAddress    := StrCopy(new(TlpszRecipName)^, lpRecip^.lpszAddress); }
              ulEIDSize     := lpRecip^.ulEIDSize;
              lpEntryID     := lpRecip^.lpEntryID;
            end;

            MapiFreeBuffer(lpRecip); { free the buffer }
          end;

          Inc(nRecipients);
        end;

      end;
    end;

  finally
    StrDispose(szRecipName);
  end;

end;

{------------------------------------------------------------------------------}

initialization
  {$IFNDEF WIN32} {$IFDEF UseGenericThunks}{ need some code for generic thunking }
     InitWin32;
  {$ENDIF UseGenericThunks} {$ENDIF WIN32}
end.
