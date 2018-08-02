unit MapiWrap;

interface

uses
  IniFiles, MapiEx, Email;

type
  TMAPIWrapper = Class(TComponent)
  protected
    FIniFile : TIniFile;
    FMapiEx  : TMapiExEmail;
    FMapiS   : TEmail;
    FUseExtended : Boolean;
    function GetLeaveUnread : Boolean;
    procedure SetLeaveUnread(Value : Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function GetLongText                                   : PChar;
    function GetNextMessageId                              : ShortString;
    function Logoff                                        : Integer;
    function Logon                                         : Integer;
    function ReadMail                                      : Integer;
    function SendMail                                      : Integer;
    function SetLongText(pLongText : PChar)                : Integer;

    function GetFirstUnread : Integer;
    function GetNextUnread : Integer;
    function ErrorString(ErrCode : Integer) : string;
    procedure DeleteReadMessages;
    property LeaveUnread  : Boolean read GetLeaveUnread   write SetleaveUnread;
    property WindowHandle : GetHandle read FHandle write SetHandle;
    property DeleteAfterRead : Boolean read GetDeleteAfterRead write SetDeleteAfterRead;
  published
    property Attachment   : TStrings    read GetAttachment    write SetAttachment;
    property Bcc          : TStrings    read GetBcc           write SetBcc;
    property CC           : TStrings    read GetCC            write SetCC;
    property MapiAvail    : boolean     read GetMapiAvail;
    property Password     : ShortString     read GetPassword      write SetPassword;
    property Profile      : ShortString     read GetProfile       write SetProfile;
    property Recipient    : TStrings    read GetRecip         write SetRecip;
    property ShowDialog   : Boolean     read GetShowDialog    write SetShowDialog
    property Subject      : ShortString     read GetSubject       write SetSubject;
    property UseDefProfile: Boolean     read GetUseDefProfile write SetUseDefProfile
    property Version      : ShortString     read GetVersion;
    property OrigAddress : ShortString read GetOrigAddress;
    property Originator : ShortString read GetOriginator;
  end;


  { TMAPIWrapper }


implementation

end.
