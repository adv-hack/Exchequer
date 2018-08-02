(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit Mswsock;

{$I msdef.inc}

interface

uses
  Windows,
  SysUtils,
  Classes,
{$IFDEF VCL}
  Forms,
{$IFDEF UNREGISTERED}
  msNag,
{$ENDIF}
{$ENDIF}
  Messages,
  msConst,
  msCls,
  msDef;

{The following is copied from winsock.pas supplied with Delphi 2.0
 var Buf's changed to Buf : PChar} {AG}

type
  u_char = Char;
  u_short = Word;
  u_int = Integer;
  u_long = LongInt;

{ The new type to be used in all
  instances which refer to sockets. }
  TSocket = u_int;

const
  FD_SETSIZE     =   64;

type
  PFDSet = ^TFDSet;
  TFDSet = packed record
    fd_count: u_int;
    fd_array: array[0..FD_SETSIZE-1] of TSocket;
  end;

  PTimeVal = ^TTimeVal;
  TTimeVal = packed record
    tv_sec: Longint;
    tv_usec: Longint;
  end;

const
  IOCPARM_MASK = $7f;
  IOC_VOID     = $20000000;
  IOC_OUT      = $40000000;
  IOC_IN       = $80000000;
  IOC_INOUT    = (IOC_IN or IOC_OUT);

  FIONREAD     = IOC_OUT or { get # bytes to read }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 127;
  FIONBIO      = IOC_IN or { set/clear non-blocking i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 126;
  FIOASYNC     = IOC_IN or { set/clear async i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 125;

type
  PHostEnt = ^THostEnt;
  THostEnt = packed record
    h_name: PChar;
    h_aliases: ^PChar;
    h_addrtype: Smallint;
    h_length: Smallint;
    h_addr_list: ^PChar;
  end;

  PNetEnt = ^TNetEnt;
  TNetEnt = packed record
    n_name: PChar;
    n_aliases: ^PChar;
    n_addrtype: Smallint;
    n_net: u_long;
  end;

  PServEnt = ^TServEnt;
  TServEnt = packed record
    s_name: PChar;
    s_aliases: ^PChar;
    s_port: Smallint;
    s_proto: PChar;
  end;

  PProtoEnt = ^TProtoEnt;
  TProtoEnt = packed record
    p_name: PChar;
    p_aliases: ^Pchar;
    p_proto: Smallint;
  end;

const

{ Protocols }

  IPPROTO_IP     =   0;
  IPPROTO_ICMP   =   1;
  IPPROTO_GGP    =   2;
  IPPROTO_TCP    =   6;
  IPPROTO_PUP    =   12;
  IPPROTO_UDP    =   17;
  IPPROTO_IDP    =   22;
  IPPROTO_ND     =   77;

  IPPROTO_RAW    =   255;
  IPPROTO_MAX    =   256;

{ Port/socket numbers: network standard functions}

  IPPORT_ECHO    =   7;
  IPPORT_DISCARD =   9;
  IPPORT_SYSTAT  =   11;
  IPPORT_DAYTIME =   13;
  IPPORT_NETSTAT =   15;
  IPPORT_FTP     =   21;
  IPPORT_TELNET  =   23;
  IPPORT_SMTP    =   25;
  IPPORT_TIMESERVER  =  37;
  IPPORT_NAMESERVER  =  42;
  IPPORT_WHOIS       =  43;
  IPPORT_MTP         =  57;

{ Port/socket numbers: host specific functions }

  IPPORT_TFTP        =  69;
  IPPORT_RJE         =  77;
  IPPORT_FINGER      =  79;
  IPPORT_TTYLINK     =  87;
  IPPORT_SUPDUP      =  95;

{ UNIX TCP sockets }

  IPPORT_EXECSERVER  =  512;
  IPPORT_LOGINSERVER =  513;
  IPPORT_CMDSERVER   =  514;
  IPPORT_EFSSERVER   =  520;
  
{ UNIX UDP sockets }

  IPPORT_BIFFUDP     =  512;
  IPPORT_WHOSERVER   =  513;
  IPPORT_ROUTESERVER =  520;

{ Ports < IPPORT_RESERVED are reserved for
  privileged processes (e.g. root). }

  IPPORT_RESERVED    =  1024;

{ Link numbers }

  IMPLINK_IP         =  155;
  IMPLINK_LOWEXPER   =  156;
  IMPLINK_HIGHEXPER  =  158;

{  Shutdown constants }

  SD_RECEIVE         =  0;
  SD_SEND            =  1;
  SD_BOTH            =  2;

type
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;

  SunW = packed record
    s_w1, s_w2: u_short;
  end;

  PInAddr = ^TInAddr;
  TInAddr = packed record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;

  PSockAddrIn = ^TSockAddrIn;
  TSockAddrIn = packed record
    case Integer of
      0: (sin_family: u_short;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: array[0..7] of Char);
      1: (sa_family: u_short;
          sa_data: array[0..13] of Char)
  end;

const
  INADDR_ANY       = $00000000;
  INADDR_LOOPBACK  = $7F000001;
  INADDR_BROADCAST = $FFFFFFFF;
  INADDR_NONE      = $FFFFFFFF;

const
  WSADESCRIPTION_LEN     =   256;
  WSASYS_STATUS_LEN      =   128;

type
  PWSAData = ^TWSAData;
  TWSAData = packed record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array[0..WSADESCRIPTION_LEN] of Char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
  end;

const

{ Options for use with [gs]etsockopt at the IP level. }

  IP_OPTIONS          = 1;
  IP_MULTICAST_IF     = 2;           { set/get IP multicast interface   }
  IP_MULTICAST_TTL    = 3;           { set/get IP multicast timetolive  }
  IP_MULTICAST_LOOP   = 4;           { set/get IP multicast loopback    }
  IP_ADD_MEMBERSHIP   = 5;           { add  an IP group membership      }
  IP_DROP_MEMBERSHIP  = 6;           { drop an IP group membership      }

  IP_DEFAULT_MULTICAST_TTL   = 1;    { normally limit m'casts to 1 hop  }
  IP_DEFAULT_MULTICAST_LOOP  = 1;    { normally hear sends if a member  }
  IP_MAX_MEMBERSHIPS         = 20;   { per socket; must fit in one mbuf }

{ This is used instead of -1, since the
  TSocket type is unsigned.}

  INVALID_SOCKET		= TSocket(NOT(0));
  SOCKET_ERROR			= -1;

{ Types }

  SOCK_STREAM     = 1;               { stream socket }
  SOCK_DGRAM      = 2;               { datagram socket }
  SOCK_RAW        = 3;               { raw-protocol interface }
  SOCK_RDM        = 4;               { reliably-delivered message }
  SOCK_SEQPACKET  = 5;               { sequenced packet stream }

{ Option flags per-socket. }

  SO_DEBUG        = $0001;          { turn on debugging info recording }
  SO_ACCEPTCONN   = $0002;          { socket has had listen() }
  SO_REUSEADDR    = $0004;          { allow local address reuse }
  SO_KEEPALIVE    = $0008;          { keep connections alive }
  SO_DONTROUTE    = $0010;          { just use interface addresses }
  SO_BROADCAST    = $0020;          { permit sending of broadcast msgs }
  SO_USELOOPBACK  = $0040;          { bypass hardware when possible }
  SO_LINGER       = $0080;          { linger on close if data present }
  SO_OOBINLINE    = $0100;          { leave received OOB data in line }

  SO_DONTLINGER  =   $ff7f;

{ Additional options. }

  SO_SNDBUF       = $1001;          { send buffer size }
  SO_RCVBUF       = $1002;          { receive buffer size }
  SO_SNDLOWAT     = $1003;          { send low-water mark }
  SO_RCVLOWAT     = $1004;          { receive low-water mark }
  SO_SNDTIMEO     = $1005;          { send timeout }
  SO_RCVTIMEO     = $1006;          { receive timeout }
  SO_ERROR        = $1007;          { get error status and clear }
  SO_TYPE         = $1008;          { get socket type }

{ Options for connect and disconnect data and options.  Used only by
  non-TCP/IP transports such as DECNet, OSI TP4, etc. }

  SO_CONNDATA     = $7000;
  SO_CONNOPT      = $7001;
  SO_DISCDATA     = $7002;
  SO_DISCOPT      = $7003;
  SO_CONNDATALEN  = $7004;
  SO_CONNOPTLEN   = $7005;
  SO_DISCDATALEN  = $7006;
  SO_DISCOPTLEN   = $7007;

{ Option for opening sockets for synchronous access. }

  SO_OPENTYPE     = $7008;

  SO_SYNCHRONOUS_ALERT    = $10;
  SO_SYNCHRONOUS_NONALERT = $20;

{ Other NT-specific options. }

  SO_MAXDG        = $7009;
  SO_MAXPATHDG    = $700A;

{ TCP options. }

  TCP_NODELAY     = $0001;
  TCP_BSDURGENT   = $7000;

{ Address families. }

  AF_UNSPEC       = 0;               { unspecified }
  AF_UNIX         = 1;               { local to host (pipes, portals) }
  AF_INET         = 2;               { internetwork: UDP, TCP, etc. }
  AF_IMPLINK      = 3;               { arpanet imp addresses }
  AF_PUP          = 4;               { pup protocols: e.g. BSP }
  AF_CHAOS        = 5;               { mit CHAOS protocols }
  AF_IPX          = 6;               { IPX and SPX }
  AF_NS           = 6;               { XEROX NS protocols }
  AF_ISO          = 7;               { ISO protocols }
  AF_OSI          = AF_ISO;          { OSI is ISO }
  AF_ECMA         = 8;               { european computer manufacturers }
  AF_DATAKIT      = 9;               { datakit protocols }
  AF_CCITT        = 10;              { CCITT protocols, X.25 etc }
  AF_SNA          = 11;              { IBM SNA }
  AF_DECnet       = 12;              { DECnet }
  AF_DLI          = 13;              { Direct data link interface }
  AF_LAT          = 14;              { LAT }
  AF_HYLINK       = 15;              { NSC Hyperchannel }
  AF_APPLETALK    = 16;              { AppleTalk }
  AF_NETBIOS      = 17;              { NetBios-style addresses }
  AF_VOICEVIEW    = 18;              { VoiceView }

  AF_MAX          = 19;

type
  { Structure used by kernel to store most addresses. }

  PSockAddr = ^TSockAddr;
  TSockAddr = TSockAddrIn;

  { Structure used by kernel to pass protocol information in raw sockets. }
  PSockProto = ^TSockProto;
  TSockProto = packed record
    sp_family: u_short;
    sp_protocol: u_short;
  end;

const
{ Protocol families, same as address families for now. }

  PF_UNSPEC       = AF_UNSPEC;
  PF_UNIX         = AF_UNIX;
  PF_INET         = AF_INET;
  PF_IMPLINK      = AF_IMPLINK;
  PF_PUP          = AF_PUP;
  PF_CHAOS        = AF_CHAOS;
  PF_NS           = AF_NS;
  PF_IPX          = AF_IPX;
  PF_ISO          = AF_ISO;
  PF_OSI          = AF_OSI;
  PF_ECMA         = AF_ECMA;
  PF_DATAKIT      = AF_DATAKIT;
  PF_CCITT        = AF_CCITT;
  PF_SNA          = AF_SNA;
  PF_DECnet       = AF_DECnet;
  PF_DLI          = AF_DLI;
  PF_LAT          = AF_LAT;
  PF_HYLINK       = AF_HYLINK;
  PF_APPLETALK    = AF_APPLETALK;
  PF_VOICEVIEW    = AF_VOICEVIEW;

  PF_MAX          = AF_MAX;

type
{ Structure used for manipulating linger option. }
  PLinger = ^TLinger;
  TLinger = packed record
    l_onoff: u_short;
    l_linger: u_short;
  end;

const
{ Level number for (get/set)sockopt() to apply to socket itself. }

  SOL_SOCKET      = $ffff;          {options for socket level }

{ Maximum queue length specifiable by listen. }

  SOMAXCONN       = 5;

  MSG_OOB         = $1;             {process out-of-band data }
  MSG_PEEK        = $2;             {peek at incoming message }
  MSG_DONTROUTE   = $4;             {send without using routing tables }

  MSG_MAXIOVLEN   = 16;

  MSG_PARTIAL     = $8000;          {partial send or recv for message xport }

{ Define constant based on rfc883, used by gethostbyxxxx() calls. }

  MAXGETHOSTSTRUCT        = 1024;

{ Define flags to be used with the WSAAsyncSelect() call. }

  FD_READ         = $01;
  FD_WRITE        = $02;
  FD_OOB          = $04;
  FD_ACCEPT       = $08;
  FD_CONNECT      = $10;
  FD_CLOSE        = $20;

{ All Windows Sockets error constants are biased by WSABASEERR from the "normal" }

  WSABASEERR              = 10000;

{ Windows Sockets definitions of regular Microsoft C error constants }

  WSAEINTR                = (WSABASEERR+4);
  WSAEBADF                = (WSABASEERR+9);
  WSAEACCES               = (WSABASEERR+13);
  WSAEFAULT               = (WSABASEERR+14);
  WSAEINVAL               = (WSABASEERR+22);
  WSAEMFILE               = (WSABASEERR+24);

{ Windows Sockets definitions of regular Berkeley error constants }

  WSAEWOULDBLOCK          = (WSABASEERR+35);
  WSAEINPROGRESS          = (WSABASEERR+36);
  WSAEALREADY             = (WSABASEERR+37);
  WSAENOTSOCK             = (WSABASEERR+38);
  WSAEDESTADDRREQ         = (WSABASEERR+39);
  WSAEMSGSIZE             = (WSABASEERR+40);
  WSAEPROTOTYPE           = (WSABASEERR+41);
  WSAENOPROTOOPT          = (WSABASEERR+42);
  WSAEPROTONOSUPPORT      = (WSABASEERR+43);
  WSAESOCKTNOSUPPORT      = (WSABASEERR+44);
  WSAEOPNOTSUPP           = (WSABASEERR+45);
  WSAEPFNOSUPPORT         = (WSABASEERR+46);
  WSAEAFNOSUPPORT         = (WSABASEERR+47);
  WSAEADDRINUSE           = (WSABASEERR+48);
  WSAEADDRNOTAVAIL        = (WSABASEERR+49);
  WSAENETDOWN             = (WSABASEERR+50);
  WSAENETUNREACH          = (WSABASEERR+51);
  WSAENETRESET            = (WSABASEERR+52);
  WSAECONNABORTED         = (WSABASEERR+53);
  WSAECONNRESET           = (WSABASEERR+54);
  WSAENOBUFS              = (WSABASEERR+55);
  WSAEISCONN              = (WSABASEERR+56);
  WSAENOTCONN             = (WSABASEERR+57);
  WSAESHUTDOWN            = (WSABASEERR+58);
  WSAETOOMANYREFS         = (WSABASEERR+59);
  WSAETIMEDOUT            = (WSABASEERR+60);
  WSAECONNREFUSED         = (WSABASEERR+61);
  WSAELOOP                = (WSABASEERR+62);
  WSAENAMETOOLONG         = (WSABASEERR+63);
  WSAEHOSTDOWN            = (WSABASEERR+64);
  WSAEHOSTUNREACH         = (WSABASEERR+65);
  WSAENOTEMPTY            = (WSABASEERR+66);
  WSAEPROCLIM             = (WSABASEERR+67);
  WSAEUSERS               = (WSABASEERR+68);
  WSAEDQUOT               = (WSABASEERR+69);
  WSAESTALE               = (WSABASEERR+70);
  WSAEREMOTE              = (WSABASEERR+71);

  WSAEDISCON              = (WSABASEERR+101);

{ Extended Windows Sockets error constant definitions }

  WSASYSNOTREADY          = (WSABASEERR+91);
  WSAVERNOTSUPPORTED      = (WSABASEERR+92);
  WSANOTINITIALISED       = (WSABASEERR+93);

{ Error return codes from gethostbyname() and gethostbyaddr()
  (when using the resolver). Note that these errors are
  retrieved via WSAGetLastError() and must therefore follow
  the rules for avoiding clashes with error numbers from
  specific implementations or language run-time systems.
  For this reason the codes are based at WSABASEERR+1001.
  Note also that [WSA]NO_ADDRESS is defined only for
  compatibility purposes. }

{ Authoritative Answer: Host not found }

  WSAHOST_NOT_FOUND       = (WSABASEERR+1001);
  HOST_NOT_FOUND          = WSAHOST_NOT_FOUND;

{ Non-Authoritative: Host not found, or SERVERFAIL }

  WSATRY_AGAIN            = (WSABASEERR+1002);
  TRY_AGAIN               = WSATRY_AGAIN;

{ Non recoverable errors, FORMERR, REFUSED, NOTIMP }

  WSANO_RECOVERY          = (WSABASEERR+1003);
  NO_RECOVERY             = WSANO_RECOVERY;

{ Valid name, no data record of requested type }

  WSANO_DATA              = (WSABASEERR+1004);
  NO_DATA                 = WSANO_DATA;

{ no address, look for MX record }

  WSANO_ADDRESS           = WSANO_DATA;
  NO_ADDRESS              = WSANO_ADDRESS;

{ Windows Sockets errors redefined as regular Berkeley error constants.
  These are commented out in Windows NT to avoid conflicts with errno.h.
  Use the WSA constants instead. }

  EWOULDBLOCK        =  WSAEWOULDBLOCK;
  EINPROGRESS        =  WSAEINPROGRESS;
  EALREADY           =  WSAEALREADY;
  ENOTSOCK           =  WSAENOTSOCK;
  EDESTADDRREQ       =  WSAEDESTADDRREQ;
  EMSGSIZE           =  WSAEMSGSIZE;
  EPROTOTYPE         =  WSAEPROTOTYPE;
  ENOPROTOOPT        =  WSAENOPROTOOPT;
  EPROTONOSUPPORT    =  WSAEPROTONOSUPPORT;
  ESOCKTNOSUPPORT    =  WSAESOCKTNOSUPPORT;
  EOPNOTSUPP         =  WSAEOPNOTSUPP;
  EPFNOSUPPORT       =  WSAEPFNOSUPPORT;
  EAFNOSUPPORT       =  WSAEAFNOSUPPORT;
  EADDRINUSE         =  WSAEADDRINUSE;
  EADDRNOTAVAIL      =  WSAEADDRNOTAVAIL;
  ENETDOWN           =  WSAENETDOWN;
  ENETUNREACH        =  WSAENETUNREACH;
  ENETRESET          =  WSAENETRESET;
  ECONNABORTED       =  WSAECONNABORTED;
  ECONNRESET         =  WSAECONNRESET;
  ENOBUFS            =  WSAENOBUFS;
  EISCONN            =  WSAEISCONN;
  ENOTCONN           =  WSAENOTCONN;
  ESHUTDOWN          =  WSAESHUTDOWN;
  ETOOMANYREFS       =  WSAETOOMANYREFS;
  ETIMEDOUT          =  WSAETIMEDOUT;
  ECONNREFUSED       =  WSAECONNREFUSED;
  ELOOP              =  WSAELOOP;
  ENAMETOOLONG       =  WSAENAMETOOLONG;
  EHOSTDOWN          =  WSAEHOSTDOWN;
  EHOSTUNREACH       =  WSAEHOSTUNREACH;
  ENOTEMPTY          =  WSAENOTEMPTY;
  EPROCLIM           =  WSAEPROCLIM;
  EUSERS             =  WSAEUSERS;
  EDQUOT             =  WSAEDQUOT;
  ESTALE             =  WSAESTALE;
  EREMOTE            =  WSAEREMOTE;

type

  EWinsockError = class(Exception);

  TmsWinsockInfo = record
    Version : Word;
    HighVersion : Word;
    Description : ShortString;
    SystemStatus : ShortString;
    MaxSockets : Word;
    MaxUdpDg : Word;
  end;

  TmsWinsock = class
  private
{$IFNDEF STATICWINSOCK}
    LibHandle : THandle;
{$ENDIF}
    FWinsockInfo : TmsWinsockInfo;
{$IFDEF VCL}
//    FDWindow : THandle;
//    FAsyncDone : boolean;
//    FAsyncError : word;
//    FAsyncHandle : THandle;
{$ENDIF}
{$IFNDEF STATICWINSOCK}
    function GetAvailable : boolean;
{$ENDIF}
{$IFDEF VCL}
//    function GetTimeOut : Integer;
//    procedure SetTimeOut(Value : Integer);
{$ENDIF}
    function GetLocalAddress: string;
    function GetLocalName: string;
  protected
{$IFDEF VCL}
//    procedure WndProc(var Msg : TMessage);
{$ENDIF}
{$IFNDEF STATICWINSOCK}
    function GetFuncPtr(s : PChar) : pointer;
    procedure LoadWinsock;
    procedure FreeWinsock;
{$ENDIF}
  public
{$IFDEF VCL}
//    TC : TmsTimeCounter;
{$ENDIF}
    constructor Create(RequiredVersion : word);
    destructor Destroy; override;
    function msGetHostByName(const AName : string) : string;
    function msGetHostByAddr(const AnAddr : string) : string;
    function msGetInAddr(const AnAddr : string) : TInAddr;
    function msGetLocalAddresses: TStrings;
    procedure Error(Ident : word);
    procedure Cancel;
    function accept(s: TSocket; var addr: TSockAddr; var addrlen: Integer): TSocket; stdcall;
    function bind(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer; stdcall;
    function closesocket(s: TSocket): Integer;  stdcall;
    function connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer; stdcall;
    function ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long): Integer; stdcall;
    function getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer; stdcall;
    function getsockname(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer; stdcall;
    function getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer;
        stdcall;
    function htonl(hostlong: u_long): u_long; stdcall;
    function htons(hostshort: u_short): u_short; stdcall;
    function inet_addr(cp: PChar): u_long; stdcall; {PInAddr;}  { TInAddr }
    function inet_ntoa(inaddr: TInAddr): PChar; stdcall;
    function listen(s: TSocket; backlog: Integer): Integer; stdcall;
    function ntohl(netlong: u_long): u_long; stdcall;
    function ntohs(netshort: u_short): u_short; stdcall;
    function recv(s: TSocket; Buf : PChar; len, flags: Integer): Integer; stdcall;
    function recvfrom(s: TSocket; Buf : PChar; len, flags: Integer;
      var from: TSockAddr; var fromlen: Integer): Integer; stdcall;
    function select(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
      timeout: PTimeVal): Longint; stdcall;
    function send(s: TSocket; Buf : PChar; len, flags: Integer): Integer; stdcall;
    function sendto(s: TSocket; Buf : PChar; len, flags: Integer; var addrto: TSockAddr;
      tolen: Integer): Integer; stdcall;
    function setsockopt(s: TSocket; level, optname: Integer; optval: PChar;
      optlen: Integer): Integer; stdcall;
    function shutdown(s: TSocket; how: Integer): Integer; stdcall;
    function socket(af, astruct, protocol: Integer): TSocket; stdcall;
    function gethostbyaddr(addr: Pointer; len, astruct: Integer): PHostEnt;  stdcall;
    function gethostbyname(name: PChar): PHostEnt; stdcall;
    function gethostname(name: PChar; len: Integer): Integer; stdcall;
    function getservbyport(port: Integer; proto: PChar): PServEnt; stdcall;
    function getservbyname(name, proto: PChar): PServEnt; stdcall;
    function getprotobynumber(proto: Integer): PProtoEnt; stdcall;
    function getprotobyname(name: PChar): PProtoEnt; stdcall;
    function WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer; stdcall;
    function WSACleanup: Integer; stdcall;
    procedure WSASetLastError(iError: Integer); stdcall;
    function WSAGetLastError: Integer; stdcall;
    function WSAIsBlocking: BOOL; stdcall;
    function WSAUnhookBlockingHook: Integer; stdcall;
    function WSASetBlockingHook(lpBlockFunc: TFarProc): TFarProc; stdcall;
    function WSACancelBlockingCall: Integer; stdcall;
    function WSAAsyncGetServByName(HWindow: HWND; wMsg: u_int;
      name, proto, buf: PChar; buflen: Integer): THandle; stdcall;
    function WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int;
      proto, buf: PChar; buflen: Integer): THandle; stdcall;
    function WSAAsyncGetProtoByName(HWindow: HWND; wMsg: u_int;
      name, buf: PChar; buflen: Integer): THandle; stdcall;
    function WSAAsyncGetProtoByNumber(HWindow: HWND; wMsg: u_int; number: Integer;
      buf: PChar; buflen: Integer): THandle; stdcall;
    function WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int;
      name, buf: PChar; buflen: Integer): THandle; stdcall;
    function WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PChar;
      len, astruct: Integer; buf: PChar; buflen: Integer): THandle; stdcall;
    function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer; stdcall;
    function WSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;
    function WSARecvEx(s: TSocket; buf : PChar; len: Integer; var flags: Integer): Integer; stdcall;

    function WSAMakeSyncReply(Buflen, Error: Word): Longint;
    function WSAMakeSelectReply(Event, Error: Word): Longint;
    function WSAGetAsyncBuflen(Param: Longint): Word;
    function WSAGetAsyncError(Param: Longint): Word;
    function WSAGetSelectEvent(Param: Longint): Word;
    function WSAGetSelectError(Param: Longint): Word;
{$IFNDEF STATICWINSOCK}
    property Available : boolean read GetAvailable;
{$ENDIF}
    property WinsockInfo : TmsWinsockInfo read FWinsockInfo;
{$IFDEF VCL}
//    property TimeOut : Integer read GetTimeOut write SetTimeOut;
{$ENDIF}
    property LocalName: string read GetLocalName;
    property LocalAddress: string read GetLocalAddress;
  end;

var
  msWinsock: TmsWinsock;

implementation


{$R WSERR.RES}

const
  winsocket = 'wsock32.dll';

constructor TmsWinsock.Create(RequiredVersion : word);
var
  WSAData : TWSAData;
  rc : Integer;
begin
{$IFNDEF STATICWINSOCK}
  LoadWinsock;
  if Available then
  begin
{$ENDIF}
  FillChar(WSAData,SizeOf(WSAData),0);
  rc:=WSAStartup(RequiredVersion,WSAData);
  if rc=0 then
  begin
    FWinsockInfo.Version:=WSAData.wVersion;
    FWinsockInfo.HighVersion:=WSAData.wHighVersion;
    FWinsockInfo.Description:=StrPas(@WSAData.szDescription);
    FWinsockInfo.SystemStatus:=StrPas(@WSAData.szSystemStatus);
    FWinsockInfo.MaxSockets:=WSAData.iMaxSockets;
    FWinsockInfo.MaxUdpDg:=WSAData.iMaxUdpDg;
  end
  else
    raise EWinsockError.Create('Invalid winsock version');
{$IFNDEF STATICWINSOCK}
  end;
{$ENDIF}
end;

destructor TmsWinsock.Destroy;
begin
  WSACleanup;
{$IFNDEF STATICWINSOCK}
  FreeWinsock;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF VCL}
(*
procedure TmsWinsock.WndProc(var Msg : TMessage);
begin
  with Msg do
  if Msg=WM_ASYNCNOTIFICATION then
  begin
    FAsyncDone:=true;
    FAsyncError:=WSAGetAsyncError(lParam);
    Result:=0;
  end
  else
    Result:=DefWindowProc(FDWindow,Msg,wParam,lParam);
end;
*)
{$ENDIF}

{$IFNDEF STATICWINSOCK}
procedure TmsWinsock.LoadWinsock;
var
  SaveErrorMode : word;
begin
  SaveErrorMode:=SetErrorMode(SEM_NOOPENFILEERRORBOX);
  LibHandle:=LoadLibrary(winsocket);
  SetErrorMode(SaveErrorMode);
end;

procedure TmsWinsock.FreeWinsock;
begin
  if LibHandle>0 then
  begin
    FreeLibrary(LibHandle);
    LibHandle:=0;
  end;
end;

function TmsWinsock.GetAvailable : boolean;
begin
  Result:=LibHandle>0;
end;
{$ENDIF}

function TmsWinsock.GetLocalName : string;
var
  Buf : array[0..127] of Char;
  rc : Integer;
begin
  Result:='';
  rc:=gethostname(@Buf,128);
  if rc=0 then
    Result:=StrPas(@Buf)
  else
    Error(WSAGetLastError);
end;

procedure TmsWinsock.Cancel;
begin
  if WSAIsBlocking then
    WSACancelBlockingCall;
end;

function TmsWinsock.msGetHostByName(const AName : string) : string;
var
  p: pointer;
  Host : THostEnt;
  InAddr: TInAddr;
  Name : array[0..127] of Char;
  IAddr : u_long;
begin
  Result:='';
  StrPCopy(@Name,AName);
  IAddr:=inet_Addr(@Name);
  if IAddr=u_long(INADDR_NONE) then {is not in 999.999.999.999 format}
  begin
    p:=gethostbyname(@Name);
    if p=nil then
      Error(WSAGetLastError);
    Move(p^,Host,SizeOf(THostEnt));
    Move(Host.h_addr_list^^,InAddr.S_Addr,Host.h_length);
    Result:=inet_ntoa(InAddr);
  end
  else
    Result:=AName;
end;

function TmsWinsock.msGetLocalAddresses: TStrings;
var
  p: pointer;
  pCur,pEnd: PChar;
  Host : THostEnt;
  InAddr: TInAddr;
  LocalName : array[0..127] of Char;
  rc: Integer;
begin
  rc:=gethostname(@LocalName,128);
  if rc=SOCKET_ERROR then
    Error(WSAGetLastError);
  p:=gethostbyname(@LocalName);
  if p=nil then
    Error(WSAGetLastError);
  Result:=TStringList.Create;
  Move(p^,Host,SizeOf(THostEnt));
  pCur:=Host.h_addr_list^;
  pEnd:=pCur;
  while (StrLComp(pEnd,@LocalName,StrLen(@LocalName))<>0) and (pEnd-pCur<2048) do
    Inc(pEnd);
  if pEnd-pCur<2048 then
  begin
    repeat
      Move(pCur^,InAddr.S_Addr,Host.h_length);
      Result.Add(inet_ntoa(InAddr));
      Inc(pCur,Host.h_Length);
    until pCur>=pEnd;
  end;
end;

function TmsWinsock.msGetHostByAddr(const AnAddr : string) : string;
var
  Host : PHostEnt;
  Addr : array[0..127] of Char;
  IAddr : u_long;
begin
  Result:='';
  StrPCopy(@Addr,AnAddr);
  IAddr:=inet_addr(@Addr);
  if IAddr=u_long(INADDR_NONE) then
    Error(WSAGetLastError);
  Host:=gethostbyaddr(@IAddr,4,PF_INET);
  if Host=nil then
    Error(WSAGetLastError);
  Result:=StrPas(Host^.h_name);
end;

function TmsWinsock.GetLocalAddress : string;
begin
  Result:=msGetHostByName(LocalName);
end;

function TmsWinsock.msGetInAddr(const AnAddr : string) : TInAddr;
var
  Buf : array[0..127] of Char;
  IAddr : u_long;
begin
  StrPCopy(@Buf,AnAddr);
  IAddr:=inet_addr(@Buf);
  if IAddr=u_long(INADDR_NONE) then
    Error(WSAGetLastError);
  Result:=TInAddr(IAddr);
end;

procedure TmsWinsock.Error(Ident : word);
var
  s : string;
begin
  s:=LoadStr(Ident+MSWSSHIFT);
  if s='' then
    s:='Winsock error no '+IntToStr(Ident);
  raise EWinsockError.Create(s);
end;

{$IFNDEF STATICWINSOCK}
function TmsWinsock.GetFuncPtr(s : PChar) : pointer;
begin
  if not Available then
    raise EWinsockError.Create('Winsock not loaded');
  Result:=GetProcAddress(LibHandle,s);
  if Result=nil then
    raise EWinsockError.Create('Function '+StrPas(s)+' not found');
end;
{$ENDIF}

{$IFDEF STATICWINSOCK}
function TmsWinsock.accept;            external    winsocket name 'accept';
function TmsWinsock.bind;              external    winsocket name 'bind';
function TmsWinsock.closesocket;       external    winsocket name 'closesocket';
function TmsWinsock.connect;           external    winsocket name 'connect';
function TmsWinsock.getpeername;       external    winsocket name 'getpeername';
function TmsWinsock.getsockname;       external    winsocket name 'getsockname';
function TmsWinsock.getsockopt;        external    winsocket name 'getsockopt';
function TmsWinsock.htonl;             external    winsocket name 'htonl';
function TmsWinsock.htons;             external    winsocket name 'htons';
function TmsWinsock.inet_addr;         external    winsocket name 'inet_addr';
function TmsWinsock.inet_ntoa;         external    winsocket name 'inet_ntoa';
function TmsWinsock.ioctlsocket;       external    winsocket name 'ioctlsocket';
function TmsWinsock.listen;            external    winsocket name 'listen';
function TmsWinsock.ntohl;             external    winsocket name 'ntohl';
function TmsWinsock.ntohs;             external    winsocket name 'ntohs';
function TmsWinsock.recv;              external    winsocket name 'recv';
function TmsWinsock.recvfrom;          external    winsocket name 'recvfrom';
function TmsWinsock.select;            external    winsocket name 'select';
function TmsWinsock.send;              external    winsocket name 'send';
function TmsWinsock.sendto;            external    winsocket name 'sendto';
function TmsWinsock.setsockopt;        external    winsocket name 'setsockopt';
function TmsWinsock.shutdown;          external    winsocket name 'shutdown';
function TmsWinsock.socket;            external    winsocket name 'socket';

function TmsWinsock.gethostbyaddr;     external    winsocket name 'gethostbyaddr';
function TmsWinsock.gethostbyname;     external    winsocket name 'gethostbyname';
function TmsWinsock.getprotobyname;    external    winsocket name 'getprotobyname';
function TmsWinsock.getprotobynumber;  external    winsocket name 'getprotobynumber';
function TmsWinsock.getservbyname;     external    winsocket name 'getservbyname';
function TmsWinsock.getservbyport;     external    winsocket name 'getservbyport';
function TmsWinsock.gethostname;       external    winsocket name 'gethostname';

function TmsWinsock.WSAAsyncSelect;    external    winsocket name 'WSAAsyncSelect';
function TmsWinsock.WSARecvEx;         external    winsocket name 'WSARecvEx';
function TmsWinsock.WSAAsyncGetHostByAddr; external winsocket name 'WSAAsyncGetHostByAddr';
function TmsWinsock.WSAAsyncGetHostByName; external winsocket name 'WSAAsyncGetHostByName';
function TmsWinsock.WSAAsyncGetProtoByNumber; external winsocket name 'WSAAsyncGetProtoByNumber';
function TmsWinsock.WSAAsyncGetProtoByName; external winsocket name 'WSAAsyncGetProtoByName';
function TmsWinsock.WSAAsyncGetServByPort; external winsocket name 'WSAAsyncGetServByPort';
function TmsWinsock.WSAAsyncGetServByName; external winsocket name 'WSAAsyncGetServByName';
function TmsWinsock.WSACancelAsyncRequest; external winsocket name 'WSACancelAsyncRequest';
function TmsWinsock.WSASetBlockingHook; external    winsocket name 'WSASetBlockingHook';
function TmsWinsock.WSAUnhookBlockingHook; external winsocket name 'WSAUnhookBlockingHook';
function TmsWinsock.WSAGetLastError;    external    winsocket name 'WSAGetLastError';
procedure TmsWinsock.WSASetLastError;   external    winsocket name 'WSASetLastError';
function TmsWinsock.WSACancelBlockingCall; external winsocket name 'WSACancelBlockingCall';
function TmsWinsock.WSAIsBlocking;     external     winsocket name 'WSAIsBlocking';
function TmsWinsock.WSAStartup;        external     winsocket name 'WSAStartup';
function TmsWinsock.WSACleanup;        external     winsocket name 'WSACleanup';

{$ELSE}

function TmsWinsock.accept(s: TSocket; var addr: TSockAddr;
                      var addrlen: Integer): TSocket;
var
  FAccept : function(s: TSocket; var addr: TSockAddr; var addrlen: Integer): TSocket;  stdcall;
begin
  @FAccept:=GetFuncPtr('accept');
  Result:=FAccept(s, addr, addrlen);
end;

function TmsWinsock.bind(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer;
var
  FBind : function(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer;  stdcall;
begin
  @FBind:=GetFuncPtr('bind');
  Result:=FBind(s, addr, namelen);
end;

function TmsWinsock.closesocket(s: TSocket): Integer;
var
  FCloseSocket : function(s : TSocket) : Integer;  stdcall;
begin
  @FCloseSocket:=GetFuncPtr('closesocket');
  Result:=FCloseSocket(s);
end;

function TmsWinsock.connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;
var
  FConnect : function(s: TSocket; var name: TSockAddr; namelen: Integer): Integer; stdcall;
begin
  @FConnect:=GetFuncPtr('connect');
  Result:=FConnect(s,name,namelen);
end;

function TmsWinsock.ioctlsocket(s: TSocket; cmd: Longint; var arg: u_long): Integer;
var
  FIOCtlSocket : function(s: TSocket; cmd: Longint; var arg: u_long): Integer;  stdcall;
begin
  @FIOCtlSocket:=GetFuncPtr('ioctlsocket');
  Result:=FIOCtlSocket(s,cmd,arg);
end;

function TmsWinsock.getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;
var
  FGetPeerName : function(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;  stdcall;
begin
  @FGetPeerName:=GetFuncPtr('getpeername');
  Result:=FGetPeerName(s,name,namelen);
end;

function TmsWinsock.getsockname(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;
var
  FGetSockName : function(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;  stdcall;
begin
  @FGetSockName:=GetFuncPtr('getsockname');
  Result:=FGetSockName(s,name,namelen);
end;

function TmsWinsock.getsockopt(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer;
var
  FGetSockOpt : function(s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer;
     stdcall;
begin
  @FGetSockOpt:=GetFuncPtr('getsockopt');
  Result:=FGetSockOpt(s,level,optname,optval,optlen);
end;

function TmsWinsock.htonl(hostlong: u_long): u_long;
var
  Fhtonl : function(hostlong: u_long): u_long;  stdcall;
begin
  @Fhtonl:=GetFuncPtr('htonl');
  Result:=Fhtonl(hostlong);
end;

function TmsWinsock.htons(hostshort: u_short): u_short;
var
  Fhtons : function(hostshort: u_short): u_short;  stdcall;
begin
  @Fhtons:=GetFuncPtr('htons');
  Result:=Fhtons(hostshort);
end;

function TmsWinsock.inet_addr(cp: PChar): u_long;  {PInAddr;}  { TInAddr }
type
  TInet_Addr=function(cp : PChar): u_long;  stdcall;
var
  FInet_Addr : TInet_Addr;
begin
  @FInet_Addr:=GetProcAddress(LibHandle,'inet_addr');
  Result:=FInet_Addr(cp);
end;

function TmsWinsock.inet_ntoa(inaddr: TInAddr): PChar;
var
  FInet_ntoa : function(inaddr : TInAddr): PChar;  stdcall;
begin
  @FInet_ntoa:=GetFuncPtr('inet_ntoa');
  Result:=FInet_ntoa(inaddr);
end;

function TmsWinsock.listen(s: TSocket; backlog: Integer): Integer;
var
  FListen : function(s: TSocket; backlog: Integer): Integer;  stdcall;
begin
  @FListen:=GetFuncPtr('listen');
  Result:=FListen(s,backlog);
end;

function TmsWinsock.ntohl(netlong: u_long): u_long;
var
  Fntohl : function(netlong : u_long) : u_long;  stdcall;
begin
  @Fntohl:=GetFuncPtr('ntohl');
  Result:=Fntohl(netlong);
end;

function TmsWinsock.ntohs(netshort: u_short): u_short;
var
  Fnoths : function(netshort : u_short) : u_short;  stdcall;
begin
  @Fnoths:=GetFuncPtr('ntohs');
  Result:=Fnoths(netshort);
end;

function TmsWinsock.recv(s: TSocket; Buf : PChar; len, flags: Integer): Integer;
var
  FRecv : function(s: TSocket; Buf : PChar; len, flags: Integer): Integer;  stdcall;
begin
  @FRecv:=GetFuncPtr('recv');
  Result:=FRecv(s, Buf, len, flags);
end;

function TmsWinsock.recvfrom(s: TSocket; Buf : PChar; len, flags: Integer;
  var from: TSockAddr; var fromlen: Integer): Integer;
var
  FRecvFrom : function(s: TSocket; Buf : PChar; len, flags: Integer;
    var from: TSockAddr; var fromlen: Integer): Integer;  stdcall;
begin
  @FRecvFrom:=GetFuncPtr('recvfrom');
  Result:=FRecvFrom(s, Buf, len, flags, from, fromlen);
end;

function TmsWinsock.select(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
  timeout: PTimeVal): Longint;
var
  FSelect : function(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
  timeout: PTimeVal): Longint;  stdcall;
begin
  @FSelect:=GetFuncPtr('select');
  Result:=FSelect(nfds, readfds, writefds, exceptfds, timeout);
end;

function TmsWinsock.send(s: TSocket; Buf : PChar; len, flags: Integer): Integer;
var
  FSend : function(s: TSocket; Buf : PChar; len, flags: Integer): Integer;  stdcall;
begin
  @FSend:=GetFuncPtr('send');
  Result:=FSend(s, Buf, len, flags);
end;

function TmsWinsock.sendto(s: TSocket; Buf : PChar; len, flags: Integer; var addrto: TSockAddr;
  tolen: Integer): Integer;
var
  FSendTo : function(s: TSocket; Buf : PChar; len, flags: Integer; var addrto: TSockAddr;
  tolen: Integer): Integer;  stdcall;
begin
  @FSendTo:=GetFuncPtr('sendto');
  Result:=FSendTo(s, Buf, len, flags, addrto, tolen);
end;

function TmsWinsock.setsockopt(s: TSocket; level, optname: Integer; optval: PChar;
  optlen: Integer): Integer;
var
  FSetSockOpt : function(s: TSocket; level, optname: Integer; optval: PChar;
  optlen: Integer): Integer;  stdcall;
begin
  @FSetSockOpt:=GetFuncPtr('setsockopt');
  Result:=FSetSockOpt(s, level, optname, optval, optlen);
end;

function TmsWinsock.shutdown(s: TSocket; how: Integer): Integer;
var
  FShutDown : function(s: TSocket; how: Integer): Integer;  stdcall;
begin
  @FShutDown:=GetFuncPtr('shutdown');
  Result:=FShutDown(s,how);
end;

function TmsWinsock.socket(af, astruct, protocol: Integer): TSocket;
var
  FSocket : function(af, astruct, protocol: Integer): TSocket;  stdcall;
begin
  @FSocket:=GetFuncPtr('socket');
  Result:=FSocket(af, astruct, protocol);
end;

function TmsWinsock.gethostbyaddr(addr: Pointer; len, astruct: Integer): PHostEnt;
var
  FGetHostByAddr : function(addr: Pointer; len, astruct: Integer): PHostEnt;  stdcall;
begin
  @FGetHostByAddr:=GetFuncPtr('gethostbyaddr');
  Result:=FGetHostByAddr(addr, len, astruct);
end;

function TmsWinsock.gethostbyname(name: PChar): PHostEnt;
var
  FGetHostByName : function(name : PChar): PHostEnt;  stdcall;
begin
  @FGetHostByName:=GetFuncPtr('gethostbyname');
  Result:=FGetHostByName(name);
end;

function TmsWinsock.gethostname(name: PChar; len: Integer): Integer;
var
  FGetHostName : function(name: PChar; len: Integer): Integer;  stdcall;
begin
  @FGetHostName:=GetFuncPtr('gethostname');
  Result:=FGetHostName(name, len);
end;

function TmsWinsock.getservbyport(port: Integer; proto: PChar): PServEnt;
var
  FGetServByPort : function(port: Integer; proto: PChar): PServEnt;  stdcall;
begin
  @FGetServByPort:=GetFuncPtr('getservbyport');
  Result:=FGetServByPort(port, proto);
end;

function TmsWinsock.getservbyname(name, proto: PChar): PServEnt;
var
  FGetServByName : function(name, proto: PChar): PServEnt;  stdcall;
begin
  @FGetServByName:=GetFuncPtr('getservbyname');
  Result:=FGetServByName(name, proto);
end;

function TmsWinsock.getprotobynumber(proto: Integer): PProtoEnt;
var
  FGetProtoByNumber : function(proto: Integer): PProtoEnt;  stdcall;
begin
  @FGetProtoByNumber:=GetFuncPtr('getprotobynumber');
  Result:=FGetProtoByNumber(proto);
end;

function TmsWinsock.getprotobyname(name: PChar): PProtoEnt;
var
  FGetProtoByName : function(name : PChar): PProtoEnt;  stdcall;
begin
  @FGetProtoByName:=GetFuncPtr('getprotobyname');
  Result:=FGetProtoByName(name);
end;

function TmsWinsock.WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer;
var
  FWSAStartUp : function(wVersionRequired: word; var WSData: TWSAData): Integer;  stdcall;
begin
  @FWSAStartUp:=GetFuncPtr('WSAStartup');
  Result:=FWSAStartUp(wVersionRequired, WSData);
end;

function TmsWinsock.WSACleanup: Integer;
var
  FWSACleanUp : function : Integer;  stdcall;
begin
  @FWSACleanUp:=GetFuncPtr('WSACleanup');
  Result:=FWSACleanUp;
end;

procedure TmsWinsock.WSASetLastError(iError: Integer);
var
  FWSASetLastError : procedure(iError : Integer);  stdcall;
begin
  @FWSASetLastError:=GetFuncPtr('WSASetLastError');
  FWSASetLastError(iError);
end;

function TmsWinsock.WSAGetLastError: Integer;
var
  FWSAGetLastError : function : Integer;  stdcall;
begin
  @FWSAGetLastError:=GetFuncPtr('WSAGetLastError');
  Result:=FWSAGetLastError;
end;

function TmsWinsock.WSAIsBlocking: BOOL;
var
  FWSAIsBlocking : function : BOOL;  stdcall;
begin
  @FWSAIsBlocking:=GetFuncPtr('WSAIsBlocking');
  Result:=FWSAIsBlocking;
end;

function TmsWinsock.WSAUnhookBlockingHook: Integer;
var
  FWSAUnhookBlockingHook : function : Integer;  stdcall;
begin
  @FWSAUnhookBlockingHook:=GetFuncPtr('WSAUnhookBlockingHook');
  Result:=FWSAUnhookBlockingHook;
end;

function TmsWinsock.WSASetBlockingHook(lpBlockFunc: TFarProc): TFarProc;
var
  FWSASetBlockingHook : function(lpBlockFunc : TFarProc): TFarProc;  stdcall;
begin
  @FWSASetBlockingHook:=GetFuncPtr('WSASetBlockingHook');
  Result:=FWSASetBlockingHook(lpBlockFunc);
end;

function TmsWinsock.WSACancelBlockingCall: Integer;
var
  FWSACancelBlockingCall : function : Integer;  stdcall;
begin
  @FWSACancelBlockingCall:=GetFuncPtr('WSACancelBlockingCall');
  Result:=FWSACancelBlockingCall;
end;

function TmsWinsock.WSAAsyncGetServByName(HWindow: HWND; wMsg: u_int;
  name, proto, buf: PChar; buflen: Integer): THandle;
var
  FWSAAsyncGetServByName : function(HWindow: HWND; wMsg: u_int;
  name, proto, buf: PChar; buflen: Integer): THandle;  stdcall;
begin
  @FWSAAsyncGetServByName:=GetFuncPtr('WSAAsyncGetServByName');
  Result:=FWSAAsyncGetServByName(HWindow, wMsg, name, proto, buf, buflen);
end;

function TmsWinsock.WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int;
  proto, buf: PChar; buflen: Integer): THandle;
var
  FWSAAsyncGetServByPort : function( HWindow: HWND; wMsg, port: u_int;
  proto, buf: PChar; buflen: Integer): THandle;  stdcall;
begin
  @FWSAAsyncGetServByPort:=GetFuncPtr('WSAAsyncGetServByPort');
  Result:=FWSAAsyncGetServByPort(HWindow, wMsg, port, proto, buf, buflen);
end;

function TmsWinsock.WSAAsyncGetProtoByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;
var
  FWSAAsyncGetProtoByName : function(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;  stdcall;
begin
  @FWSAAsyncGetProtoByName:=GetFuncPtr('WSAAsyncGetProtoByName');
  Result:=FWSAAsyncGetProtoByName(HWindow, wMsg, name, buf, buflen);
end;

function TmsWinsock.WSAAsyncGetProtoByNumber(HWindow: HWND; wMsg: u_int; number: Integer;
  buf: PChar; buflen: Integer): THandle;
var
  FWSAAsyncGetProtoByNumber : function(HWindow: HWND; wMsg: u_int; number: Integer;
  buf: PChar; buflen: Integer): THandle;  stdcall;
begin
  @FWSAAsyncGetProtoByNumber:=GetFuncPtr('WSAAsyncGetProtoByNumber');
  Result:=FWSAAsyncGetProtoByNumber(HWindow, wMsg, number, buf, buflen);
end;

function TmsWinsock.WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int;
  name, buf: PChar; buflen: Integer): THandle;
var
  FWSAAsyncGetHostByName : function(HWindow: HWND; wMsg: u_int;
     name, buf: PChar; buflen: Integer): THandle;  stdcall;
begin
  @FWSAAsyncGetHostByName:=GetFuncPtr('WSAAsyncGetHostByName');
  Result:=FWSAAsyncGetHostByName(HWindow, wMsg, name, buf, buflen);
end;

function TmsWinsock.WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PChar;
  len, astruct: Integer; buf: PChar; buflen: Integer): THandle;
var
  FWSAAsyncGetHostByAddr : function(HWindow: HWND; wMsg: u_int; addr: PChar;
  len, astruct: Integer; buf: PChar; buflen: Integer): THandle;  stdcall;
begin
  @FWSAAsyncGetHostByAddr:=GetFuncPtr('WSAAsyncGetHostByAddr');
  Result:=FWSAAsyncGetHostByAddr(HWindow, wMsg, addr, len, astruct, buf, buflen);
end;

function TmsWinsock.WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer;
var
  FWSACancelAsyncRequest : function(hAsyncTaskHandle: THandle): Integer;  stdcall;
begin
  @FWSACancelAsyncRequest:=GetFuncPtr('WSACancelAsyncRequest');
  Result:=FWSACancelAsyncRequest(hAsyncTaskHandle);
end;

function TmsWinsock.WSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;
var
  FWSAAsyncSelect : function(s: TSocket; HWindow: HWND; wMsg: u_int;
       lEvent: Longint): Integer;  stdcall;
begin
  @FWSAAsyncSelect:=GetFuncPtr('WSAAsyncSelect');
  Result:=FWSAAsyncSelect(s, HWindow, wMsg, lEvent);
end;

function TmsWinsock.WSARecvEx(s: TSocket; Buf : PChar; len: Integer; var flags: Integer): Integer;
var
  FWSARecvEx : function(s: TSocket; Buf : PChar; len: Integer; var flags: Integer): Integer;  stdcall;
begin
  @FWSARecvEx:=GetFuncPtr('WSARecvEx');
  Result:=FWSARecvEx(s, buf, len, flags);
end;
{$ENDIF}

function TmsWinsock.WSAMakeSyncReply(Buflen, Error: Word): Longint;
begin
  WSAMakeSyncReply:= MakeLong(Buflen, Error);
end;

function TmsWinsock.WSAMakeSelectReply(Event, Error: Word): Longint;
begin
  WSAMakeSelectReply:= MakeLong(Event, Error);
end;

function TmsWinsock.WSAGetAsyncBuflen(Param: Longint): Word;
begin
  WSAGetAsyncBuflen:= LOWORD(Param);
end;

function TmsWinsock.WSAGetAsyncError(Param: Longint): Word;
begin
  WSAGetAsyncError:= HIWORD(Param);
end;

function TmsWinsock.WSAGetSelectEvent(Param: Longint): Word;
begin
  WSAGetSelectEvent:= LOWORD(Param);
end;

function TmsWinsock.WSAGetSelectError(Param: Longint): Word;
begin
  WSAGetSelectError:= HIWORD(Param);
end;

initialization
  msWinsock:=TmsWinsock.Create($0101);
{$IFDEF UNREGISTERED}
  Nag;
{$ENDIF}
finalization
  msWinsock.Free;
end.
