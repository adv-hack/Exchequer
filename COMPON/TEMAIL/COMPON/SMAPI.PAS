
{ Simple MAPI definitions                                                  }
{ Version 1.00.00 :
    16 bit mapi.h partially converted by Keith Darragh, (c) 1995 SWIFTSOFT
  Version 2.00.00 :
    extended and adapted to 32 bit by Danny Heijl, (c) 1996  CEVI VZW
    also put in a separate "header" file, "smapi.pas"
  Version 2.00.0a :
    added DeletMail for completeness, Danny Heijl Dec 1996
  Version 2.00.0b :
    added "Address" (select addresses), Rudy Claasen, Jan 1997
    added '.DLL' to 'MAPI32' for Windows NT users, Danny Heijl, Jan 1997

  Danny.Heijl@cevi.be

  Version 2.01.00 :
  Changes by Stefan Hoffmeister (Stefan.Hoffmeister@PoBoxes.com):
  - rework the implementation part to allow dynamic linking
  - add a function (MAPIavailable) that indicates whether MAPI services are
    available.
  - add EMAPIdllerror exception (Danny)

  Version 2.02.00 : (Stefan)
  Changes by Stefan Hoffmeister (Stefan.Hoffmeister@PoBoxes.com):
  - changed loading strategy a bit
  - suppressing system error messages that DLL was not found
  - added check in accordance with MS MAPI docs whether MAPI is installed
    on the system (SMAPI.PAS).
    This is YET another safeguard

  Version 2.02.0a : (Danny)
  A minor bugfix in the 2.02.00 code of Stefan.
  Hence the 'MsgIdSize' const.

  Version 2.03.00 : (Stefan)
  Incorporate additions to MapiSaveMail by
     Daniel Easton <daniel.easton@launch.com>

  Version 2.04.00 : (Stefan)
  Rewrite of MAPI detection logic - triggered by code sent in by
     John Hall <jackh@mira.net>
  Logic now mirrors current Delphi 3.02 implementation closely

  Version 2.08.00 : (Stefan)
  Fixed C++ Builder 1.0 support

  Version 2.09.00 : (Stefan)
  Added C++ Builder 3.0 and Delphi 4 support
  Removed redundant SString definition - it was never used
      in SMAPI.PAS and was also defined in EMAIL.PAS

  Version 2.10.00 : (Stefan)
  Added MAPI_LONG_MSGID
  Fixed compilation with typed @ operator compiler option

}

unit SMapi; { SMAPI.PAS, SMAPI.HPP }

{DEFINE DEBUG}
{$IFNDEF DEBUG}
  {$D-} {$Q-} {$R-} {$S-}
{$ENDIF DEBUG}

{$F+}

interface

uses
  SysUtils;


type
  EMapiDllError = class(Exception);
  EMapiAttachmentError = class(Exception);

  
{------------------}
{ MAPI data types. }
{------------------}

  UINT      =  Integer;
  ULONG     =  Longint;
  lpULONG   = ^Longint;
  LHANDLE   =  Longint;
  lpLHANDLE = ^LHANDLE;
  DWORD     =  Longint;
  LPVOID    =  Pointer;

const
  MsgIdSize = 520;     { message id size, large enough for Unicode should
                         MAPI use it }

{-----------------------------------}
{ MAPI File attachment information. }
{-----------------------------------}

type
  lpMapiFileDesc = ^TMapiFileDesc;
  TMapiFileDesc = record
    ulReserved   : ULONG;                { Reserved for future use. Must be 0 }
    flFlags      : ULONG;     		        { Flags }
    nPosition    : ULONG;                { Attachment position in message body }
    lpszPathName : PChar;                { Full path name of attachment file }
    lpszFileName : PChar;                { Original filename (optional) }
    lpFileType : Pointer;                { Attachment file type (reserved) }
  end;

{-----------------------------}
{ MAPI recipient information. }
{-----------------------------}

type
  lpMapiRecipDesc = ^TMapiRecipDesc;
  lppMapiRecipDesc = ^lpMapiRecipDesc;
  TMapiRecipDesc = record
    ulReserved   : ULONG;                { Reserved for future use. Must be 0 }
    ulRecipClass : ULONG;                { Recipient class - }
                                         { MAPI_TO, MAPI_CC, }
                                         { MAPI_BCC, MAPI_ORIG }
    lpszName    : PChar;                 { Recipient name }
    lpszAddress : PChar;                 { Recipient address (optional) }
    ulEIDSize   : ULONG;                 { Size (in bytes) of lpEntryID }
    lpEntryID   : Pointer;               { System-specific recipient reference }
  end;

{---------------------------}
{ MAPI message information. }
{---------------------------}

type
  lpMapiMessage = ^TMapiMessage;
  TlppMapiMessage = ^lpMapiMessage;
  TMapiMessage = record
    ulReserved         : ULONG;           { Reserved for future use. Must be 0 }
    lpszSubject        : PChar;           { Message subject }
    lpszNoteText       : PChar;           { Message text }
    lpszMessageType    : PChar;           { Message class }
    lpszDateReceived   : PChar;           { In YYYY/MM/DD HH:MM format }
    lpszConversationID : PChar;		       { Conversation thread ID }
    flFlags            : ULONG;           { Unread, return receipt }
    lpOriginator       : lpMapiRecipDesc; { Originator descriptor }
    nRecipCount        : ULONG;           { Number of recipients }
    lpRecips           : lpMapiRecipDesc; { Recipient descriptors }
    nFileCount         : ULONG;           { Number of file attachments }
    lpFiles            : lpMapiFileDesc;  { Attachment descriptors }
  end;

{-----------------------------}
{ MAPI constants information. }
{-----------------------------}

const
  MAPI_ORIG                     =  0;    { Recipient is message originator. }
  MAPI_TO                       =  1;    { Recipient is primary recipient. }
  MAPI_CC                       =  2;    { Recipient is copy recipient. }
  MAPI_BCC                      =  3;    { Recipient is blind-copy recipient. }

  MAPI_UNREAD            :ULONG = $0001;
  MAPI_RECEIPT_REQUESTED :ULONG = $0002;
  MAPI_SENT              :ULONG = $0004;

  MAPI_LOGON_UI          :ULONG = $0001; { Display logon UI }
  MAPI_NEW_SESSION       :ULONG = $0002; { Don't get default if available. }
  MAPI_DIALOG            :ULONG = $0008; { Prompt to resolve ambig. names }
  MAPI_UNREAD_ONLY       :ULONG = $0020; { Only unread messages }
  MAPI_ENVELOPE_ONLY     :ULONG = $0040; { Only header information }
  MAPI_PEEK              :ULONG = $0080; { Don't mark message as read }
  MAPI_GUARANTEE_FIFO    :ULONG = $0100; { Guarantee FIFO MAPIFindNext }
  MAPI_BODY_AS_FILE      :ULONG = $0200; { Save body as first attachment }
  MAPI_AB_NOMODIFY       :ULONG = $0400; { Don't modify PAB entries }
  MAPI_SUPPRESS_ATTACH   :ULONG = $0800; { Header and body, no files }
  MAPI_FORCE_DOWNLOAD    :ULONG = $1000; { Force message download from server }
                                { $2000 }
  MAPI_LONG_MSGID        :ULONG = $4000; { Authorize MsgId of 512 char returned}

  MAPI_OLE               :ULONG = $0001; { Set if attachment is an OLE Object }
  MAPI_OLE_STATIC        :ULONG = $0002; { Set if attachment is Static OLE    }

{ MAPI Error codes. }


const
  SUCCESS_SUCCESS                 =  0;
  MAPI_USER_ABORT                 =  1;
  MAPI_E_FAILURE                  =  2;
  MAPI_E_LOGIN_FAILURE            =  3;
  MAPI_E_DISK_FULL                =  4;
  MAPI_E_INSUFFICIENT_MEMORY      =  5;
  MAPI_E_ACCESS_DENIED            =  6;
  MAPI_E_TOO_MANY_SESSIONS        =  8;
  MAPI_E_TOO_MANY_FILES           =  9;
  MAPI_E_TOO_MANY_RECIPIENTS      = 10;
  MAPI_E_ATTACHMENT_NOT_FOUND     = 11;
  MAPI_E_ATTACHMENT_OPEN_FAILURE  = 12;
  MAPI_E_ATTACHMENT_WRITE_FAILURE = 13;
  MAPI_E_UNKNOWN_RECIPIENT        = 14;
  MAPI_E_BAD_RECIPTYPE            = 15;
  MAPI_E_NO_MESSAGES              = 16;
  MAPI_E_INVALID_MESSAGE          = 17;
  MAPI_E_TEXT_TOO_LARGE           = 18;
  MAPI_E_INVALID_SESSION          = 19;
  MAPI_E_TYPE_NOT_SUPPORTED       = 20;
  MAPI_E_AMBIGUOUS_RECIPIENT	     = 21;
  MAPI_E_MESSAGE_IN_USE		       = 22;
  MAPI_E_NETWORK_FAILURE	         = 23;
  MAPI_E_INVALID_EDITFIELDS	     = 24;
  MAPI_E_INVALID_RECIPS		       = 25;
  MAPI_E_NOT_SUPPORTED		         = 26;


{ Declare calls to MAPI.DLL }

function MapiFindNext(lhSession        : LHANDLE;
                      ulUIParam        : ULONG;
                      lpszMessageType  : PChar;
                      lpszSeedMessageID: PChar;
                      flFlags          : ULONG;
                      ulReserved       : ULONG;
                      lpszMessageID    : PChar): ULONG;

function MapiLogoff(lhSession  : LHANDLE;
                    ulUIParam  : ULONG;
                    flFlags    : ULONG;
                    ulReserved : ULONG): ULONG;

function MapiLogon(ulUIParam   : ULONG;
                   lpszName    : PChar;
                   lpszPassword: PChar;
                   flFlags     : ULONG;
                   ulReserved  : ULONG;
                   lplhSession : LPLHANDLE): ULONG;

function MapiSendMail(lhSession  : LHANDLE;
                      ulUIParam  : ULONG;
                      lpMessage  : lpMapiMessage;
                      flFlags    : ULONG;
                      ulReserved : ULONG): ULONG;

function MapiReadMail(lhSession     : LHANDLE;
                      ulUIParam     : ULONG;
                      lpszMessageID : PChar;
                      flFlags       : ULONG;
                      ulReserved    : ULONG;
                      lpMessage     : lpMapiMessage): ULONG;

function MapiDeleteMail(lhSession     : LHANDLE;
                        ulUIParam     : ULONG;
                        lpszMessageID : PChar;
                        flFlags       : ULONG;
                        ulReserved    : ULONG): ULONG;


function MapiResolveName(lhSession : LHANDLE;
                         ulUIParam : ULONG;
                         lpszName  : PChar;
                         flFlags   : ULONG;
                         ulReserved: ULONG;
                         lppRecips : lppMapiRecipDesc): ULONG;

function MapiFreeBuffer(pv : LPVOID): ULONG;

function MapiAddress(lhSession: LHANDLE;
                      ulUIParam: ULONG;
                      lpszCaption: PChar;
                      nEditFields: ULONG;
                      lpszLabels: PChar;
                      nRecips: ULONG;
                      var lpRecips: TMapiRecipDesc;
                      flFlags: ULONG;
                      ulReserved: ULONG;
                      lpnNewRecips: lpULONG;
                      var lppNewRecips: lpMapiRecipDesc): ULONG;


function MAPISaveMail( lhSession     : LHANDLE;
                       ulUIParam     : ULONG;
                       lpMessage     : lpMapiMessage;
                       flFlags       : ULONG;
                       ulReserved    : ULONG;
                       lpszMessageID : PChar): ULONG;

function MapiAvailable: Boolean;
procedure InitializeSMAPI;
procedure FinalizeSMAPI;


implementation

uses
{$IFDEF WIN32}
  Windows,
{$ELSE}
  WinProcs, WinTypes,
{$ENDIF WIN32}
  IniFiles; { BOTH, WIN32 AND Win16 MAPI rely on INI files}



{$IFDEF WIN32}
  { most Borland 32 bit compilers do have a "resourcestring" now }
  {$DEFINE RESSTRING}
{$ELSE}
  { ... but 16 bit compilers (Delphi 1, that is) definitely don't }
  {$UNDEF RESSTRING}
{$ENDIF WIN32}

{$IFDEF VER90}
  { Delphi 2.0 }
  {$UNDEF RESSTRING}
{$ENDIF VER90}

{$IFDEF VER93}
  { C++ Builder 1.0 }
  {$UNDEF RESSTRING}
{$ENDIF VER93}


{$IFDEF RESSTRING}
  { all versions starting from VER100, aka Delphi 3.0,
    support "resourcestring" }
resourcestring
{$ELSE}
  { Delphi 1.0, Delphi 2.0 and BCB 1.0 do not know
    "resourcestring", so we simply don't care about
    localization and define the string as "const" }
const
{$ENDIF RESSTRING}
  SMapiGetProcAdressFailed = 'GetProcAddress for MAPI.DLL function(s) failed';


var
  DllInitialized: boolean { = false } ; { MAPI there? }
  DllHandle : THandle { = 0 } ; { Handle of MAPI.DLL }

{ declare the function types }
type
TFnMapiFindNext = function (lhSession        : LHANDLE;
                      ulUIParam        : ULONG;
                      lpszMessageType  : PChar;
                      lpszSeedMessageID: PChar;
                      flFlags          : ULONG;
                      ulReserved       : ULONG;
                      lpszMessageID    : PChar) :  ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiLogoff = function(lhSession  : LHANDLE;
                    ulUIParam  : ULONG;
                    flFlags    : ULONG;
                    ulReserved : ULONG) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiLogon = function(ulUIParam   : ULONG;
                   lpszName    : PChar;
                   lpszPassword: PChar;
                   flFlags     : ULONG;
                   ulReserved  : ULONG;
                   lplhSession : LPLHANDLE) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiSendMail = function(lhSession  : LHANDLE;
                      ulUIParam  : ULONG;
                      lpMessage  : lpMapiMessage;
                      flFlags    : ULONG;
                      ulReserved : ULONG) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiReadMail = function(lhSession     : LHANDLE;
                      ulUIParam     : ULONG;
                      lpszMessageID : PChar;
                      flFlags       : ULONG;
                      ulReserved    : ULONG;
                      lpMessage     : lpMapiMessage) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiDeleteMail = function(lhSession     : LHANDLE;
                        ulUIParam     : ULONG;
                        lpszMessageID : PChar;
                        flFlags       : ULONG;
                        ulReserved    : ULONG) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}


TFnMapiResolveName = function(lhSession : LHANDLE;
                         ulUIParam : ULONG;
                         lpszName  : PChar;
                         flFlags   : ULONG;
                         ulReserved: ULONG;
                         lppRecips : lppMapiRecipDesc) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiFreeBuffer = function(pv : LPVOID) : ULONG
{$IFNDEF WIN32} ;{$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiAddress = function(lhSession   : LHANDLE;
                      ulUIParam       : ULONG;
                      lpszCaption     : PChar;
                      nEditFields     : ULONG;
                      lpszLabels      : PChar;
                      nRecips         : ULONG;
                      var lpRecips    : TMapiRecipDesc;
                      flFlags         : ULONG;
                      ulReserved      : ULONG;
                      lpnNewRecips    : lpULONG;
                      var lppNewRecips: lpMapiRecipDesc): ULONG
{$IFNDEF WIN32} ;{$ELSE} stdcall; {$ENDIF WIN32}

TFnMapiSaveMail = function(lhSession     : LHANDLE;
                           ulUIParam     : ULONG;
                           lpMessage     : lpMapiMessage;
                           flFlags       : ULONG;
                           ulReserved    : ULONG;
                           lpszMessageID : PChar) : ULONG
{$IFNDEF WIN32} ; {$ELSE} stdcall; {$ENDIF WIN32}

{ declare the functions themselves }
var
  FnMapiFindNext:    TFnMapiFindNext;
  FnMapiLogoff:      TFnMapiLogoff;
  FnMapiLogon:       TFnMapiLogon;
  FnMapiSendMail:    TFnMapiSendMail;
  FnMapiReadMail:    TFnMapiReadMail;
  FnMapiDeleteMail:  TFnMapiDeleteMail;
  FnMapiResolveName: TFnMapiResolveName;
  FnMapiFreeBuffer:  TFnMapiFreeBuffer;
  FnMapiAddress:     TFnMapiAddress;
  FnMapiSaveMail:    TFnMapiSaveMail;


function MapiFindNext(lhSession        : LHANDLE;
                      ulUIParam        : ULONG;
                      lpszMessageType  : PChar;
                      lpszSeedMessageID: PChar;
                      flFlags          : ULONG;
                      ulReserved       : ULONG;
                      lpszMessageID    : PChar) :  ULONG;
begin
  Result := FnMapiFindNext( lhSession, ulUIParam, lpszMessageType, lpszSeedMessageID, 
                            flFlags, ulReserved, lpszMessageID);
end;

function MapiLogoff(lhSession  : LHANDLE;
                    ulUIParam  : ULONG;
                    flFlags    : ULONG;
                    ulReserved : ULONG) : ULONG;
begin
  Result := FnMapiLogoff( lhSession, ulUIParam, flFlags, ulReserved);
end;

function MapiLogon(ulUIParam   : ULONG;
                   lpszName    : PChar;
                   lpszPassword: PChar;
                   flFlags     : ULONG;
                   ulReserved  : ULONG;
                   lplhSession : LPLHANDLE) : ULONG;
begin
  Result := FnMapiLogon( ulUIParam, lpszName, lpszPassword, flFlags, ulReserved,
                         lplhSession);
end;

function MapiSendMail(lhSession  : LHANDLE;
                      ulUIParam  : ULONG;
                      lpMessage  : lpMapiMessage;
                      flFlags    : ULONG;
                      ulReserved : ULONG) : ULONG;
begin
  Result := FnMapiSendMail( lhSession, ulUIParam, lpMessage, flFlags,
                            ulReserved);
end;

function MapiReadMail(lhSession     : LHANDLE;
                      ulUIParam     : ULONG;
                      lpszMessageID : PChar;
                      flFlags       : ULONG;
                      ulReserved    : ULONG;
                      lpMessage     : lpMapiMessage) : ULONG;
begin
  Result := FnMapiReadMail( lhSession, ulUIParam, lpszMessageID, flFlags, 
                            ulReserved, lpMessage);
end;

function MapiDeleteMail(lhSession     : LHANDLE;
                        ulUIParam     : ULONG;
                        lpszMessageID : PChar;
                        flFlags       : ULONG;
                        ulReserved    : ULONG) : ULONG;
begin
  Result := FnMapiDeleteMail( lhSession, ulUIParam, lpszMessageID, flFlags,
                              ulReserved);
end;


function MapiResolveName(lhSession : LHANDLE;
                         ulUIParam : ULONG;
                         lpszName  : Pchar;
                         flFlags   : ULONG;
                         ulReserved: ULONG;
                         lppRecips : lppMapiRecipDesc) : ULONG;
begin
  Result := FnMapiResolveName( lhSession, ulUIParam, lpszName, flFlags, 
                               ulReserved, lppRecips);
end;


function MapiFreeBuffer(pv : LPVOID) : ULONG;
begin
  Result := FnMapiFreeBuffer(pv);
end;


function MapiAddress(lhSession        : LHANDLE;
                     ulUIParam        : ULONG;
                     lpszCaption      : PChar;
                     nEditFields      : ULONG;
                     lpszLabels       : PChar;
                     nRecips          : ULONG;
                     var lpRecips     : TMapiRecipDesc;
                     flFlags          : ULONG;
                     ulReserved       : ULONG;
                     lpnNewRecips     : lpULONG;
                     var lppNewRecips : lpMapiRecipDesc): ULONG;
begin
  Result := FnMapiAddress( lhSession, ulUIParam, lpszCaption, nEditFields,
                           lpszLabels, nRecips, lpRecips, flFlags,
                           ulReserved, lpnNewRecips, lppNewRecips);
end;


function MapiSaveMail(lhSession     : LHANDLE;
                      ulUIParam     : ULONG;
                      lpMessage     : lpMapiMessage;
                      flFlags       : ULONG;
                      ulReserved    : ULONG;
                      lpszMessageID : PChar) : ULONG;
begin
  Result := FnMapiSaveMail( lhSession, ulUIParam, lpMessage, flFlags,
                            ulReserved, lpszMessageID);
end;


function MapiAvailable: boolean;
begin
  MapiAvailable := DllInitialized;
end;


{ define various combinations of MAPI dlls
  if they are not used the linker will not include them }
const
  DLLName32DLL = 'mapi32.dll';
  DLLName32 = 'mapi32';

  DLLName16DLL = 'mapi.dll';
  DLLName16 = 'mapi'; { we will NOT use this }


procedure InitializeSMAPI;
var
  OldErrorMode: Word;

{$IFDEF WIN32}
  OSVersionInfo: TOSVersionInfo;
  RegHandle: HKEY;

  MapiDetectBuf: array[0..8] of Char;
  MapiDetectBufSize: Windows.DWORD;

  RegValueType: Windows.DWORD;
{$ENDIF WIN32}
begin
  { first check wether MAPI is available on the system; this is done
    as described in the MS MAPI docs }

{$IFDEF WIN32}
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  GetVersionEx(OSVersionInfo);
  if (OSVersionInfo.dwMajorVersion > 3) or { NT 4.0 and later }
     { earlier than NT 3.51 }
     ((OSVersionInfo.dwMajorVersion = 3) and (OSVersionInfo.dwMinorVersion > 51)) then
  begin
    if RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                     'SOFTWARE\Microsoft\Windows Messaging Subsystem',
                     0, KEY_READ, RegHandle) <> ERROR_SUCCESS then
    begin
      exit;
    end;

    MAPIDetectBufSize := SizeOf(MAPIDetectBuf);
    if RegQueryValueEx( RegHandle, 'MAPI', nil, @RegValueType,
                        PByte(@MAPIDetectBuf), @MAPIDetectBufSize) <> ERROR_SUCCESS then
    begin
      exit;
    end;

    RegCloseKey(RegHandle);

    { "boolean" integer --> is == "1"? }
    if not ((MAPIDetectBuf[0] = '1') and (MAPIDetectBuf[1] = #0)) then
      exit;
  end
  else
{$ENDIF WIN32}
    if GetProfileInt('Mail', 'MAPI', 0) = 0 then { 16 bit and NT 3.51 detection logic }
      Exit;

{$IFDEF WIN32}
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS + SEM_NOOPENFILEERRORBOX);
    DLLHandle := LoadLibrary(DLLName32); { start without .DLL attached }
  { OldErrorMode := } SetErrorMode(OldErrorMode);

  if DLLHandle = 0 then { got an error }
  begin
    OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS + SEM_NOOPENFILEERRORBOX);
    try
      DLLHandle := LoadLibrary(DLLName32DLL);

      if DLLHandle = 0 then
      begin
        exit; { second attempt did not work out either }
      end;

    finally
      { OldErrorMode := } SetErrorMode(OldErrorMode);
    end;
  end;
{$ELSE}
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS + SEM_NOOPENFILEERRORBOX);
  DLLHandle := LoadLibrary(DLLName16DLL);
  { OldErrorMode := } SetErrorMode(OldErrorMode);

  if DLLHandle <= HINSTANCE_ERROR then
  begin
    FreeLibrary(DLLHandle);
  end
  else
{$ENDIF WIN32}
  begin
    DllInitialized := true;

    @FnMapiFindNext :=    GetProcAddress(DLLHandle, 'MAPIFindNext');
    @FnMapiLogoff :=      GetProcAddress(DLLHandle, 'MAPILogoff');
    @FnMapiLogon :=       GetProcAddress(DLLHandle, 'MAPILogon');
    @FnMapiSendMail :=    GetProcAddress(DLLHandle, 'MAPISendMail');
    @FnMapiReadMail :=    GetProcAddress(DLLHandle, 'MAPIReadMail');
    @FnMapiDeleteMail :=  GetProcAddress(DLLHandle, 'MAPIDeleteMail');
    @FnMapiResolveName := GetProcAddress(DLLHandle, 'MAPIResolveName');
    @FnMapiFreeBuffer :=  GetProcAddress(DLLHandle, 'MAPIFreeBuffer');
    @FnMapiAddress :=     GetProcAddress(DLLHandle, 'MAPIAddress');
    @FnMapiSaveMail :=    GetProcAddress(DLLHandle, 'MAPISaveMail');

    if    (@FnMapiAddress     = nil)
       or (@FnMapiFreeBuffer  = nil)
       or (@FnMapiResolveName = nil)
       or (@FnMapiDeleteMail  = nil)
       or (@FnMapiReadMail    = nil)
       or (@FnMapiSendMail    = nil)
       or (@FnMapiLogon       = nil)
       or (@FnMapiLogoff      = nil)
       or (@FnMapiFindNext    = nil)
       or (@FnMapiSaveMail    = nil) then
    begin
      raise EMAPIdllerror.Create(SMapiGetProcAdressFailed);
    end;
  end;
end;

{ this should not be necessary... }
procedure ClearProcedureAdresses;
begin
  @FnMapiFindNext :=    nil;
  @FnMapiLogoff :=      nil;
  @FnMapiLogon :=       nil;
  @FnMapiSendMail :=    nil;
  @FnMapiReadMail :=    nil;
  @FnMapiDeleteMail :=  nil;
  @FnMapiResolveName := nil;
  @FnMapiFreeBuffer :=  nil;
  @FnMapiAddress :=     nil;
  @FnMapiSaveMail :=    nil;
end;


procedure FinalizeSMAPI; far; { explicitly make it far }
begin
  if DllInitialized then
    FreeLibrary(DLLHandle);

  ClearProcedureAdresses;
end;


initialization
  ClearProcedureAdresses; { just for safety }

  DllInitialized := false;
  DllHandle := 0;

(*{$IFNDEF WIN32}
  AddExitProc(FinalizeSMAPI);
{$ENDIF WIN32}

  InitializeSMAPI;

{$IFDEF WIN32}
finalization
  FinalizeSMAPI;
{$ENDIF WIN32} *)
end.
