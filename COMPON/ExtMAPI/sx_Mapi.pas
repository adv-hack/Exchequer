(******************************************************************************
*                                                                             *
*                   TsxMAPI_Session v.1.1 11.04.2004г.                        *
*           Component to work with Mail system using Messaging API            *
*                  (C) Chanov Nikolay, Moscow                                 *
*                                                                             *
******************************************************************************)
(*
Компонент задумывался как замена Simple MAPI с возможностью работать в сервисах
и убрать нехорошие сообщения от BG поставляемые со 2 SP
Распространяется "как есть"
На данный момент толком не тестировался (хотя в сервисе уже поработал :)
Заголовочники для MAPI с небольшими изменениями типа var/out TSomeType -> PSomeType
userenv.pas - ВЫЖИМКА из userenv.h для загрузки профайла из сервиса

Буду рад узнать об ошибках и багах: ch_kolyan@mail.ru
*)

unit sx_MAPI;

interface

{$R-}
uses Windows, SysUtils, Classes, MapiDefs, MapiTags, MapiGuid, MapiCode,
  ActiveX, MapiX, Dialogs;

type
  TsxMAPI_FolderType = (sxftInbox, sxftRoot, sxftOutbox, sxftSent, sxftDeleted);
  TsxMAPI_MsgSendFlag = (sxsfNoAction, sxsfToSent, sxsfDelete);
  TsxMAPI_MsgRecipientType = (sxrtTo, sxrtCC, sxrtBCC);
  TsxMAPI_Session = class;
  TsxMAPI_Folder = class;
  TsxMAPI_Message = class;



  TsxMAPI_Attachment = class
  private
    FMessage: TsxMAPI_Message;
    FAttach: IAttach;
    FFilled: Boolean;
    ulType: ULONG;
    pStream: IStream;
    FName, FFileName, FLongFileName, FPath, FLongPath: AnsiString;
    FSize: ULONG;
    function GetName: AnsiString;
    procedure SetName(const Value: AnsiString);
    function GetFileName: AnsiString;
    procedure SetFileName(const Value: AnsiString);
    function GetLongFileName: AnsiString;
    procedure SetLongFileName(const Value: AnsiString);
    function GetPath: AnsiString;
    procedure SetPath(const Value: AnsiString);
    function GetLongPath: AnsiString;
    procedure SetLongPath(const Value: AnsiString);
    function GetSize: ULONG;
    function GetAsString: AnsiString;
    procedure RefreshData;
    procedure SaveProperties;
    constructor Create(AttachNum, AttachType: Integer; Owner: TsxMAPI_Message);
  public
    property Name: AnsiString read GetName write SetName;
    property FileName: AnsiString read GetFileName write SetFileName;
    property LongFileName: AnsiString read GetLongFileName write SetLongFileName;
    property Path: AnsiString read GetPath write SetPath;
    property LongPath: AnsiString read GetLongPath write SetLongPath;
    property Size: ULONG read GetSize;
    property AsString: AnsiString read GetAsString;
    procedure Read(ToStream: TStream);
    procedure Write(FromStream: TStream);
    procedure CopyFromBuffer(pBuffer: Pointer; iSize: Integer; bGoStart: Boolean = True);
    procedure Save;
    procedure Refresh;
    destructor Destroy; override;
  end;

  TsxMAPI_MailUser = class
  private
    FUser: IMailUser;
    FSession: TsxMAPI_Session;
    FEntryID: PSBinary;
    FName, FAddress, FAccount: AnsiString;
    FFilled: Boolean;
    constructor Create(EntryData: PSBinary; Owner: TsxMAPI_Session); reintroduce;
    procedure RefreshData;
    function GetName: AnsiString;
  public
    property Name: AnsiString read GetName;
    destructor Destroy; override;
  end;

  TsxMAPI_Message = class
  private
    FFolder: TsxMAPI_Folder;
    FMessage: IMessage;
    FSenderName, FSenderAddress, FSubject, FBody: AnsiString;
    FSentTime: TDateTime;
    FSize: ULONG;
    FFilled, FRecFilled, FAttFilled, FNew: Boolean;
    FChanged, FRecChanged, FAttChanged: Boolean;
    FRec: array [TsxMAPI_MsgRecipientType] of TStrings;
    FAttach: TList;

    //PR: 27/07/04 Added Unread & Entry ID property
    FHeader : AnsiString;
    FUnread : Boolean;
    function GetUnread : Boolean;
    procedure SetUnread(Value : Boolean);
    function GetHeader : AnsiString;
    function GetSender: AnsiString;
    procedure SetSender(Value: AnsiString);
    function GetSenderAddr: AnsiString;
    function GetSentTime: TDateTime;
    function GetSubject: AnsiString;
    procedure SetSubject(Value: AnsiString);
    function GetSize: ULONG;
    function GetBody: AnsiString;
    procedure SetBody(Value: AnsiString);
    procedure DoRefreshCommon;
    procedure DoRefreshBody;
    procedure DoRefreshRecepients;
    procedure DoRefreshAttachments;
    procedure DoAssignRecepients;
    procedure DoAssignAttachments;
    function GetAttachCount: Integer;
    function GetAttachment(Index: Integer): TsxMAPI_Attachment;
    procedure SetSingleRecepient(Value: AnsiString);
    function GetProperty(ulProperty: ULONG): PSPropValue;
    constructor Create(EntryData: PSBinary; Owner: TsxMAPI_Folder); reintroduce;
  public
    property Sender: AnsiString read GetSender write SetSender;
    property SenderAddress: AnsiString read GetSenderAddr;
    property Subject: AnsiString read GetSubject write SetSubject;
    property SentTime: TDateTime read GetSentTime;
    property Size: ULONG read GetSize;
    property Body: AnsiString read GetBody write SetBody;
    property AttachCount: Integer read GetAttachCount;
    property Attachment[Index: Integer]: TsxMAPI_Attachment read GetAttachment;
    property Recepient: AnsiString write SetSingleRecepient;
    property Unread : Boolean read GetUnread write SetUnread;
    property Headers : AnsiString read GetHeader;
    procedure GetRecepientsList(Index: TsxMAPI_MsgRecipientType; ToList: TStrings);
    procedure AddRecepient(Index: TsxMAPI_MsgRecipientType; sRecipient: AnsiString);
    procedure SetRecepientsList(Index: TsxMAPI_MsgRecipientType; FromList: TStrings);
    procedure ClearRecepients;
    function AddAttachment: TsxMAPI_Attachment;
    procedure DeleteAttachment(Index: Integer);
    procedure ClearAttachments;
    procedure Save;
    procedure ResolveNames;
    procedure Send;
    procedure Refresh;
    destructor Destroy; override;
    procedure SetReadFlag;
  end;

  TsxMAPI_Folder = class
  private
    FFolder: IMAPIFolder;
    FSession: TsxMAPI_Session;
    FSubCount, FMsgCount: Integer;
    FFolderName: AnsiString;
    FSubs, FMsgs: TList;
    function GetFolderName: AnsiString;
    function GetSubCount: Integer;
    function GetSubFolder(Index: Integer): TsxMAPI_Folder;
    function GetMsgCount: Integer;
    function GetMessage(Index: Integer): TsxMAPI_Message;
    constructor Create(Folder: IMAPIFolder; Owner: TsxMAPI_Session); reintroduce;
  public
    property FolderName: AnsiString read GetFolderName;
    property SubCount: Integer read GetSubCount;
    property SubFolder[Index: Integer]: TsxMAPI_Folder read GetSubFolder;
    property MsgCount: Integer read GetMsgCount;
    property Msg[Index: Integer]: TsxMAPI_Message read GetMessage;
    procedure RefreshHierarchi;
    procedure ClearHierarchi;
    procedure RefreshContents;
    procedure ClearContents;
    function CreateMessage: TsxMAPI_Message;
    procedure DeleteMessage(Msg: TsxMAPI_Message);
    destructor Destroy; override;
  end;

  TsxMAPI_Session = class(TComponent)
  private
    FSession: IMAPISession;
    FAddrBook: IAddrBook;
    FDefaultMessageStore: IMsgStore;
    FPSentFolderEntryID: PSPropValue;
    FCurrentUser: TsxMAPI_MailUser;
    FMAPIInit, FDoMAPIInit, FInService: Boolean;
    FWndHandle: THandle;
    FProfile, FPassword: AnsiString;
    FMsgSendFlag: TsxMAPI_MsgSendFlag;
    FFolders: array [TsxMAPI_FolderType] of TsxMAPI_Folder;
    function OpenFolderByEntryID(cSize: Cardinal; pEntID: PENTRYID): IMsgStore;
    procedure CheckDefMsgStore;
    function GetIncomeFolder: TsxMAPI_Folder;
    function InternalGetFolder(ulID: ULONG): TsxMAPI_Folder;
    function SentFolderEntryID: PSBinary;
  protected
    procedure SetProfile(Value: AnsiString); virtual;
    procedure SetPassword(Value: AnsiString); virtual;
    procedure SetDoMAPIInit(Value: Boolean); virtual;
    procedure SetInService(Value: Boolean); virtual;
    function GetFolder(Index: TsxMAPI_FolderType): TsxMAPI_Folder; virtual;
    function GetCurrentUser: TsxMAPI_MailUser;
    function GetActive: Boolean; virtual;

    procedure DoInitialize; virtual;
    procedure DoUninitialize; virtual;
  public
    property WndHandle: THandle read FWndHandle write FWndHandle;
    property Folder[Index: TsxMAPI_FolderType]: TsxMAPI_Folder read GetFolder;
//    property CurrentUser: TsxMAPI_MailUser read FCurrentUser;
    property CurrentUser: TsxMAPI_MailUser read GetCurrentUser;
    property Active: Boolean read GetActive;
    procedure Logon;
    procedure Logoff(bShared: Boolean);
    procedure RefreshFolders;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ProfileName: AnsiString read FProfile write SetProfile;
    property ProfilePass: AnsiString read FPassword write SetPassword;
    property DoMAPIInit: Boolean read FDoMAPIInit write SetDoMAPIInit;
    property InService: Boolean read FInService write SetInService;
    property MessageSendFlag: TsxMAPI_MsgSendFlag read FMsgSendFlag write FMsgSendFlag;
  end;

procedure Register;
procedure CheckForError(ErrorCode: HRESULT; sMessage: AnsiString);
function FileDateTimeToDateTime(ft: TFILETIME): TDateTime;
function LastErrorString : AnsiString;
function LastErrorCode : Integer;
procedure ClearErrorCode;


implementation

uses sx_MAPI_Const, AxCtrls, MapiOptionsU;

const ulAttProps: array [0..6] of ULONG = (PR_DISPLAY_NAME_A, PR_ATTACH_FILENAME_A,
    PR_ATTACH_LONG_FILENAME_A, PR_ATTACH_PATHNAME_A, PR_ATTACH_LONG_PATHNAME_A, PR_ATTACH_METHOD, PR_ATTACH_SIZE);

var
  iLastErrorCode : integer;

function LastErrorString : AnsiString;
begin
  Result := SysErrorMessage(iLastErrorCode);
end;

function LastErrorCode : Integer;
begin
  Result := iLastErrorCode;
end;

procedure ClearErrorCode;
begin
  iLastErrorCode := 0;
end;

procedure CheckForError(ErrorCode: HRESULT; sMessage: AnsiString);
var
  S: AnsiString;
begin
  if not Succeeded(ErrorCode) then begin
    iLastErrorCode := ErrorCode;
    S := sMessage + #13#10 + SysErrorMessage(ErrorCode);
    raise Exception.Create(S);
  end
  else
    iLastErrorCode := 0;
end;

function FileDateTimeToDateTime(ft: TFILETIME): TDateTime;
var
  ld: Extended;
begin
{ FILETIME 64-bit int w/ number of 100ns periods since Jan 1,1601 }
{ TDateTime : 0 = 12/30/1899 12:00 am, 01-Jan-1601 = -109205}
  ld := ft.dwHighDateTime;
  ld := (ld *256*256 /13183593.75)- 109205;
  //  = 256^4  /  (24*60*60*1000*1000*10)
  ld := ld + (ft.dwLowDateTime /24/60/60/1000/10000);
  Result := ld;
end;

{ TsxMAPI_Attachment }

constructor TsxMAPI_Attachment.Create(AttachNum, AttachType: Integer; Owner: TsxMAPI_Message);
var
  dw: DWORD;
begin
  inherited Create;
  FMessage := Owner;
  ulType := AttachType;
  FFilled := False;
  if AttachNum<0 then//create new atatchment
    CheckForError(Owner.FMessage.CreateAttach(nil, 0, dw, FAttach), szErrorCreateAttach)
  else //open existing one
    CheckForError(Owner.FMessage.OpenAttach(AttachNum, nil, MAPI_BEST_ACCESS, FAttach), szErrorOpenAttach);

end;

destructor TsxMAPI_Attachment.Destroy;
begin
  pStream := nil;
  FAttach := nil;
  inherited;
end;

function TsxMAPI_Attachment.GetName: AnsiString;
begin
  if not FFilled then Refresh;
  if FName='' then Result := FLongFileName
  else Result := FName;
  if Result='' then Result := FFileName;
end;

procedure TsxMAPI_Attachment.SetName(const Value: AnsiString);
begin
  if not FFilled then Refresh;
  if FName = Value then Exit;
  FName := Value;
  FMessage.FAttChanged := True;
end;

function TsxMAPI_Attachment.GetFileName: AnsiString;
begin
  if not FFilled then Refresh;
  Result := FFileName;
end;

procedure TsxMAPI_Attachment.SetFileName(const Value: AnsiString);
begin
  if not FFilled then Refresh;
  if FFileName = Value then Exit;
  FFileName := Value;
  FMessage.FAttChanged := True;
end;

function TsxMAPI_Attachment.GetLongFileName: AnsiString;
begin
  if not FFilled then Refresh;
  Result := FLongFileName;
end;

procedure TsxMAPI_Attachment.SetLongFileName(const Value: AnsiString);
begin
  if not FFilled then Refresh;
  if FLongFileName = Value then Exit;
  FLongFileName := Value;
  FMessage.FAttChanged := True;
end;

function TsxMAPI_Attachment.GetPath: AnsiString;
begin
  if not FFilled then Refresh;
  Result := FPath;
end;

procedure TsxMAPI_Attachment.SetPath(const Value: AnsiString);
begin
  if not FFilled then Refresh;
  if FPath = Value then Exit;
  FPath := Value;
  FMessage.FAttChanged := True;
end;

function TsxMAPI_Attachment.GetLongPath: AnsiString;
begin
  if not FFilled then Refresh;
  Result := FLongPath;
end;

procedure TsxMAPI_Attachment.SetLongPath(const Value: AnsiString);
begin
  if not FFilled then Refresh;
  if FLongPath = Value then Exit;
  FLongPath := Value;
  FMessage.FAttChanged := True;
end;

function TsxMAPI_Attachment.GetSize: ULONG;
begin
  if not FFilled then Refresh;
  Result := FSize;
end;

function TsxMAPI_Attachment.GetAsString: AnsiString;
var
  i: Integer;
  li: LargeInt;
  st: STATSTG;
begin
  if pStream=nil then RefreshData;

  pStream.Seek(0, STREAM_SEEK_SET, li);
  pStream.Stat(st, STATFLAG_NONAME);
  if st.cbSize>$FFFFFFF then i := $FFFFFFF
  else i := st.cbSize;
  if i=0 then Result := ''
  else begin
    SetLength(Result, i);
    pStream.Write(@Result[1], i, nil);
  end;
end;

procedure TsxMAPI_Attachment.RefreshData;
var
  hRes: HRESULT;
  Prop: TSPropValue;
begin
  hRes := FAttach.OpenProperty(PR_ATTACH_DATA_BIN, IID_IStream, 0,
    MAPI_MODIFY, @pStream);
  if hRes = MAPI_E_NOT_FOUND then begin
    Prop.ulPropTag := PR_ATTACH_METHOD;
    Prop.dwAlignPad := 0;
    Prop.Value.l := ulType;
    CheckForError(FAttach.SetProps(1, @Prop, nil), szErrorSetProps);
    CheckForError(FAttach.OpenProperty(PR_ATTACH_DATA_BIN, IID_IStream, 0,
      MAPI_MODIFY or MAPI_CREATE, @pStream), szErrorOpenAttachStream);
  end else CheckForError(hRes, szErrorOpenAttachStream);
end;

procedure TsxMAPI_Attachment.SaveProperties;
var
  pProperty, pProp: PSPropValue;
  i, iCnt: Integer;
begin
  iCnt := High(ulAttProps)+1;
  _MAPIAllocateBuffer(iCnt * sizeof(TSPropValue), @pProperty);
  try
    pProp := pProperty;
    for i:=0 to iCnt-1 do begin
      pProp.ulPropTag := ulAttProps[i];
      pProp.dwAlignPad := 0;
      case ulAttProps[i] of
        PR_ATTACH_METHOD: pProp.Value.l := ulType;
        PR_DISPLAY_NAME_A: pProp.Value.lpszA := PAnsiChar(FName);
        PR_ATTACH_FILENAME_A: pProp.Value.lpszA := PAnsiChar(FFileName);
        PR_ATTACH_LONG_FILENAME_A: pProp.Value.lpszA := PAnsiChar(FLongFileName);
        PR_ATTACH_PATHNAME_A: pProp.Value.lpszA := PAnsiChar(FPath);
        PR_ATTACH_LONG_PATHNAME_A: pProp.Value.lpszA := PAnsiChar(FLongPath);
        PR_ATTACH_SIZE: pProp.ulPropTag := PR_NULL;
      end;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}
    end;
    CheckForError(FAttach.SetProps(iCnt, pProperty, nil), szErrorSetProps);
  finally
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
  end;
end;

procedure TsxMAPI_Attachment.Save;
begin
  SaveProperties;
  CheckForError(FAttach.SaveChanges(KEEP_OPEN_READWRITE), szErrorSaveAttachment);
end;

procedure TsxMAPI_Attachment.Refresh;
var
  pCols: PSPropTagArray;
  pProperty, pProp: PSPropValue;
  dw: DWORD;
  i, iCnt: Integer;
begin
  pCols := nil;
  try
    iCnt := High(ulAttProps)+1;
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*iCnt, @pCols);
    pCols.cValues := iCnt;
    for i:=0 to iCnt-1 do
      pCols.aulPropTag[i] := ulAttProps[i];
    FAttach.GetProps(pCols, 0, dw, pProperty);
    pProp := pProperty;
    for i:=0 to iCnt-1 do begin
      if pProp.ulPropTag=PR_DISPLAY_NAME_A then FName := pProp.Value.lpszA;
      if pProp.ulPropTag=PR_ATTACH_FILENAME_A then FFileName := pProp.Value.lpszA;
      if pProp.ulPropTag=PR_ATTACH_LONG_FILENAME_A then FLongFileName := pProp.Value.lpszA;
      if pProp.ulPropTag=PR_ATTACH_PATHNAME_A then FPath := pProp.Value.lpszA;
      if pProp.ulPropTag=PR_ATTACH_LONG_PATHNAME_A then FLongPath := pProp.Value.lpszA;
      if pProp.ulPropTag=PR_ATTACH_SIZE then FSize := pProp.Value.l;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}
    end;
  finally
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
    if pCols<>nil then _MAPIFreeBuffer(pCols);
  end;
  FFilled := True;
end;

procedure TsxMAPI_Attachment.Read(ToStream: TStream);
var
  st: STATSTG;
  str: TOleStream;
  li: LargeInt;
begin
  if pStream=nil then RefreshData;

  pStream.Seek(0, STREAM_SEEK_SET, li);
  ToStream.Position := 0;
  pStream.Stat(st, STATFLAG_NONAME);
  if st.cbSize=0 then ToStream.Size := 0
  else begin
    str := TOleStream.Create(pStream);
    try
      ToStream.CopyFrom(str, st.cbSize);
    finally
      str.Free;
    end;
  end;
end;

procedure TsxMAPI_Attachment.Write(FromStream: TStream);
var
  str: TOleStream;
  li: LargeInt;
begin
  if pStream=nil then RefreshData;
  if FromStream.Size=0 then pStream.SetSize(0)
  else begin
    pStream.Seek(0, STREAM_SEEK_SET, li);
    FromStream.Position := 0;
    str := TOleStream.Create(pStream);
    try
      li := FromStream.Size;
      str.CopyFrom(FromStream, li);
    finally
      str.Free;
    end;
  end;
  FMessage.FAttChanged := True;
end;

procedure TsxMAPI_Attachment.CopyFromBuffer(pBuffer: Pointer; iSize: Integer; bGoStart: Boolean);
var
  li: LargeInt;
begin
  if pStream=nil then RefreshData;
  if iSize=0 then pStream.SetSize(0)
  else begin
    if bGoStart then pStream.Seek(0, STREAM_SEEK_SET, li);
    pStream.Write(pBuffer, iSize, @li);
  end;
  FMessage.FAttChanged := True;
end;

{ TsxMAPI_MailUser }

constructor TsxMAPI_MailUser.Create(EntryData: PSBinary; Owner: TsxMAPI_Session);
var
  dw: DWORD;
begin
  inherited Create;
  FSession := Owner;
  FFilled := False;
  //store entryID
  _MAPIAllocateBuffer(sizeof(TSBinary) + EntryData.cb, @FEntryID);
  FEntryID.cb := EntryData.cb;
  {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
  FEntryID.lpb := Pointer(Int64(FEntryID)+sizeof(TSBinary));
  {$ELSE}
  FEntryID.lpb := Pointer(Integer(FEntryID)+sizeof(TSBinary));
  {$ENDIf WIN64}

  CopyMemory(FEntryID.lpb, EntryData.lpb, EntryData.cb);
  CheckForError(Owner.FSession.OpenEntry(EntryData.cb, PENTRYID(EntryData.lpb),
      IID_IMailUser, MAPI_BEST_ACCESS, dw, @FUser), szErrorOpenUser);
end;

destructor TsxMAPI_MailUser.Destroy;
begin
  FUser := nil;
  _MAPIFreeBuffer(FEntryID);
  inherited;
end;

procedure TsxMAPI_MailUser.RefreshData;
const iColsCount = 3;
  ulProperties: array [0..iColsCount-1] of ULONG =
    (PR_DISPLAY_NAME, PR_EMAIL_ADDRESS, PR_ACCOUNT);
var
  dw: DWORD;
  pProp, pProperty: PSPropValue;
  pCols: PSPropTagArray;
  i: Integer;
  s : AnsiString;
  ps : PAnsiChar;
begin
  pProperty := nil;
  FName := '';
  FAddress := '';
  FAccount := '';
  _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*iColsCount, @pCols);
  pCols.cValues := iColsCount;
  for i:=0 to iColsCount-1 do
    pCols.aulPropTag[i] := ulProperties[i];
  try
    CheckForError(FUser.GetProps(pCols, 0, dw, pProperty), szErrorGetProperties);
    pProp := pProperty;
    for i:=0 to dw-1 do begin
      case pProp.ulPropTag of
        {$IFNDEF VER140} //Adjustment for D10
        PR_DISPLAY_NAME: FName := PWideChar(pProp.Value.lpszA);
        PR_EMAIL_ADDRESS: FAddress := PWideChar(pProp.Value.lpszA);
        PR_ACCOUNT: FAccount := PWideChar(pProp.Value.lpszA);
        {$ELSE}
        PR_DISPLAY_NAME: FName := pProp.Value.lpszA;
        PR_EMAIL_ADDRESS: FAddress := pProp.Value.lpszA;
        PR_ACCOUNT: FAccount := pProp.Value.lpszA;
        {$ENDIF VER140}
      end;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}
    end;
  finally
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
    _MAPIFreeBuffer(pCols);
  end;
  FFilled := True;
end;

function TsxMAPI_MailUser.GetName: AnsiString;
begin
  if not FFilled then RefreshData;
  Result := FName;
end;

{ TsxMAPI_Message }

constructor TsxMAPI_Message.Create(EntryData: PSBinary; Owner: TsxMAPI_Folder);
var
  rt: TsxMAPI_MsgRecipientType;
  dw: DWORD;
begin
  inherited Create;
  FFolder := Owner;
  FFilled := False;
  FRecFilled := False;
  FAttFilled := False;
  FChanged := False;
  FRecChanged := False;
  FAttChanged := False;
  for rt:=Low(FRec) to High(FRec) do FRec[rt] := TStringList.Create;
  FAttach := Tlist.Create;
  FBody := #1;
  FNew := EntryData=nil;
  if FNew then //create new message
    CheckForError(Owner.FFolder.CreateMessage(nil, 0, FMessage), szErrorCreateNewMsg)
  else //open existing one
    CheckForError(Owner.FFolder.OpenEntry(EntryData.cb, PENTRYID(EntryData.lpb),
      IID_IMessage, MAPI_MODIFY, dw, @FMessage), szErrorOpenMessage);

end;

destructor TsxMAPI_Message.Destroy;
var
  rt: TsxMAPI_MsgRecipientType;
begin
  ClearAttachments;
  FAttach.Free;
  for rt:=Low(FRec) to High(FRec) do FRec[rt].Free;
  FMessage := nil;
  inherited;
end;

function TsxMAPI_Message.GetUnread : Boolean;
begin
  if not FFilled then DoRefreshCommon;
  Result := FUnread;
end;

function TsxMAPI_Message.GetSender: AnsiString;
begin
  if not FFilled then  DoRefreshCommon;
  Result := FSenderName;
end;

function TsxMAPI_Message.GetHeader: AnsiString;
begin
  if not FFilled then  DoRefreshCommon;
  Result := FHeader;
end;

procedure TsxMAPI_Message.SetUnread(Value : Boolean);
begin
  if not FFilled then  DoRefreshCommon;
  if FUnread=Value then Exit;
  FUnread := Value;
  FChanged := True;
end;


procedure TsxMAPI_Message.SetSender(Value: AnsiString);
begin
  if not FFilled then  DoRefreshCommon;
  if FSenderName=Value then Exit;
  FSenderName := Value;
  FChanged := True;
end;

function TsxMAPI_Message.GetSenderAddr: AnsiString;
begin
  if not FFilled then  DoRefreshCommon;
  Result := FSenderAddress;
end;

function TsxMAPI_Message.GetSentTime: TDateTime;
begin
  if not FFilled then  DoRefreshCommon;
  Result := FSentTime;
end;

function TsxMAPI_Message.GetSubject: AnsiString;
begin
  if not FFilled then  DoRefreshCommon;
  Result := FSubject;
end;

procedure TsxMAPI_Message.SetSubject(Value: AnsiString);
begin
  if not FFilled then  DoRefreshCommon;
  if FSubject=Value then Exit;
  FSubject := Value;
  FChanged := True;
end;

function TsxMAPI_Message.GetSize: ULONG;
begin
  if not FFilled then  DoRefreshCommon;
  Result := FSize;
end;

function TsxMAPI_Message.GetBody: AnsiString;
begin
  if FBody=#1 then DoRefreshBody;
  Result := FBody;
end;

procedure TsxMAPI_Message.SetBody(Value: AnsiString);
begin
  if FBody=#1 then DoRefreshBody;
  if FBody=Value then Exit;
  FBody := Value;
  FChanged := True;
end;

procedure TsxMAPI_Message.DoRefreshCommon;
const iColsCount = 7;
//PR: 27/07/04 Added PR_MESSAGE_FLAGS to the array to read Unread property
  ulProperties: array [0..iColsCount-1] of ULONG =
    (PR_DISPLAY_NAME, PR_SUBJECT, PR_SENT_REPRESENTING_NAME, PR_SENT_REPRESENTING_EMAIL_ADDRESS,
      PR_MESSAGE_DELIVERY_TIME, PR_MESSAGE_SIZE, PR_MESSAGE_FLAGS{, PR_TRANSPORT_MESSAGE_HEADERS});
var
  dw: DWORD;
  pProp, pProperty: PSPropValue;
  pCols: PSPropTagArray;
  i: Integer;
begin
  if FNew then Exit;
  pProperty := nil;
  FSubject := '';
  FSenderName := '';
  FSenderAddress := '';
  FSentTime := 0;
  _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*iColsCount, @pCols);
  pCols.cValues := iColsCount;
  for i:=0 to iColsCount-1 do
    pCols.aulPropTag[i] := ulProperties[i];
  try
    CheckForError(FMessage.GetProps(pCols, 0, dw, pProperty), szErrorGetProperties);
    pProp := pProperty;
    for i:=0 to dw-1 do begin
      case pProp.ulPropTag of
      {$IFNDEF VER140} //Adjustment for D10
        PR_SUBJECT: FSubject := PWideChar(pProp.Value.lpszA);
        PR_SENT_REPRESENTING_NAME: FSenderName := PWideChar(pProp.Value.lpszA);
        PR_SENT_REPRESENTING_EMAIL_ADDRESS: FSenderAddress := PWideChar(pProp.Value.lpszA);
      {$ELSE}
        PR_SUBJECT: FSubject := pProp.Value.lpszA;
        PR_SENT_REPRESENTING_NAME: FSenderName := pProp.Value.lpszA;
        PR_SENT_REPRESENTING_EMAIL_ADDRESS: FSenderAddress := pProp.Value.lpszA;
      {$ENDIF VER140}
        PR_MESSAGE_DELIVERY_TIME: FSentTime := FileDateTimeToDateTime(pProp.Value.ft);
        PR_MESSAGE_SIZE: FSize := pProp.Value.l;
        PR_MESSAGE_FLAGS : FUnread := pProp.Value.l and MSGFLAG_READ <> MSGFLAG_READ;
//        PR_TRANSPORT_MESSAGE_HEADERS : FHeaders := pProp.Value.lpszA;
      end;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}
    end;
  finally
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
    _MAPIFreeBuffer(pCols);
  end;

  FFilled := True;
end;

procedure TsxMAPI_Message.DoRefreshBody;
var
  _Str: IStream;
  st: STATSTG;
  i: Integer;
begin
  if FNew then Exit;
  CheckForError(FMessage.OpenProperty(PR_BODY, IID_IStream, 0, 0, @_Str), szErrorGetProperties);
  try
    _Str.Stat(st, STATFLAG_NONAME);
    if (st.cbSize>0) then begin
      if st.cbSize>DWORD(-1) then i := $7FFFFFFF
      else i := st.cbSize;
      SetLength(FBody, i);
      _Str.Read(@FBody[1], i, nil);
    end;
  finally
    _Str := nil;
  end;
end;

procedure TsxMAPI_Message.DoRefreshRecepients;
const iColsCount = 2;
  ulProperties: array [0..iColsCount-1] of ULONG =
    (PR_DISPLAY_NAME, PR_RECIPIENT_TYPE);
var
  Tbl: IMAPITable;
  pCols: PSPropTagArray;
  pRows: PSRowSet;
  i, j, iCnt: Integer;
  rt: TsxMAPI_MsgRecipientType;
  dw: DWORD;
  s: AnsiString;
begin
  if FNew then Exit;
  for rt:=Low(FRec) to High(FRec) do FRec[rt].Clear;
  pRows := nil;
  pCols := nil;
  try
    CheckForError(FMessage.GetRecipientTable(0, Tbl), szErrorGetRecepients);
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*iColsCount, @pCols);
    pCols.cValues := iColsCount;
    for i:=0 to iColsCount-1 do
      pCols.aulPropTag[i] := ulProperties[i];
    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);
    CheckForError(Tbl.QueryRows($7FFFFFFF, 0, pRows), szErrorGetRows);
    iCnt := pRows.cRows;
    j := 1;
    for i:=0 to iCnt-1 do begin
      {$IFNDEF VER140} //Adjustment for D10
      s := PWideChar(pRows.aRow[i].lpProps[0].Value.lpszA);
      {$ELSE}
      dw := pRows.aRow[i].lpProps[j].Value.l;
      {$ENDIF VER140}
      case dw of
        MAPI_CC: FRec[sxrtCC].Add(s);
        MAPI_BCC: FRec[sxrtBCC].Add(s);
      else
        FRec[sxrtTo].Add(s);
      end;
    end;
  finally
    if pRows<>nil then begin
      iCnt := pRows.cRows;
      for i:=0 to iCnt-1 do _MAPIFreeBuffer(pRows.aRow[i].lpProps);
      _MAPIFreeBuffer(pRows);
    end;
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    Tbl := nil;
  end;
  FRecFilled := True;
end;

procedure TsxMAPI_Message.DoRefreshAttachments;
const ulProps: array [0..1] of ULONG = (PR_ATTACH_NUM, PR_ATTACH_METHOD);
var
  Tbl: IMAPITable;
  pCols: PSPropTagArray;
  pRows: PSRowSet;
  Att: TsxMAPI_Attachment;
  i, iCnt, j: Integer;
  dw, dwType: DWORD;
begin
  if FNew then Exit;
  pRows := nil;
  pCols := nil;
  try
    CheckForError(FMessage.GetAttachmentTable(0, Tbl), szErrorGetAttachs);
    iCnt := High(ulProps)+1;
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*iCnt, @pCols);
    pCols.cValues := iCnt;
    for i:=0 to iCnt-1 do
      pCols.aulPropTag[i] := ulProps[i];
    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);

    CheckForError(Tbl.QueryRows($7FFFFFFF, 0, pRows), szErrorGetRows);
    iCnt := pRows.cRows;
    for i:=0 to iCnt-1 do begin
      dw := pRows.aRow[i].lpProps[0].Value.l;
      j := 1;
      dwType := pRows.aRow[i].lpProps[j].Value.l;
      if dwType = ATTACH_BY_VALUE then begin
        Att := TsxMAPI_Attachment.Create(dw, dwType, Self);
        FAttach.Add(Att);
      end;
    end;
  finally
    if pRows<>nil then begin
      iCnt := pRows.cRows;
      for i:=0 to iCnt-1 do _MAPIFreeBuffer(pRows.aRow[i].lpProps);
      _MAPIFreeBuffer(pRows);
    end;
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    Tbl := nil;
  end;
  FAttFilled := True;
end;
procedure TsxMAPI_Message.DoAssignRecepients;
var
  pAddL: PADRLIST;
  pProperty, pProp: PSPropValue;
  j, iInd, iCnt: Integer;
  rt: TsxMAPI_MsgRecipientType;
begin
  if not FRecChanged then Exit;
//  DoClearRecepients;
  iCnt := 0;
  for rt:=Low(FRec) to High(FRec) do iCnt := iCnt + FRec[rt].Count;
  if iCnt<1 then Exit;
  pProperty := nil;
  _MAPIAllocateBuffer(sizeof(ULONG) + iCnt * sizeof(TADRENTRY), @pAddL);
  FillChar(pAddL^, sizeof(ULONG) + iCnt * sizeof(TADRENTRY), 0);
  try
    pAddL.cEntries := iCnt;
    _MAPIAllocateBuffer(3 * sizeof(TSPropValue) * iCnt, @pProperty);
    FillChar(pProperty^, 3 * sizeof(TSPropValue) * iCnt, 0);
    pProp := pProperty;
    iInd := 0;
    for rt:=Low(FRec) to High(FRec) do begin
      for j:=0 to FRec[rt].Count-1 do begin
        pAddL.aEntries[iInd].ulReserved1 := 0;
        pAddL.aEntries[iInd].cValues := 3;
        pAddL.aEntries[iInd].rgPropVals := pProp;

        pProp.ulPropTag := PR_DISPLAY_NAME_A;
        pProp.dwAlignPad := 0;
        pProp.Value.lpszA := PAnsiChar(AnsiString(FRec[rt].Strings[j]));
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}

        pProp.ulPropTag := PR_RECIPIENT_TYPE;
        pProp.dwAlignPad := 0;
        case rt of
          sxrtCC: pProp.Value.l := MAPI_CC;
          sxrtBCC: pProp.Value.l := MAPI_BCC;
        else
          pProp.Value.l := MAPI_TO;
        end;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}

        pProp.ulPropTag := PR_SEND_RICH_INFO;
        pProp.dwAlignPad := 0;
        pProp.Value.b := 0;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}

        Inc(iInd);
      end;
    end;
    CheckForError(FMessage.ModifyRecipients(0, pAddL), szErrorModifyRecepients);
  finally
    pProp := pProperty;
    iCnt := pAddL.cEntries;
    for j:=0 to iCnt-1 do begin
      if pAddL.aEntries[j].rgPropVals<>pProp then
        _MAPIFreeBuffer(pAddL.aEntries[j].rgPropVals);
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}
    end;
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
    _MAPIFreeBuffer(pAddL);
  end;
end;

procedure TsxMAPI_Message.DoAssignAttachments;
var
  i, iCnt: Integer;
begin
  if not FAttChanged then Exit;
  iCnt := FAttach.Count-1;
  for i:=0 to iCnt do Attachment[i].Save;
end;

function TsxMAPI_Message.GetAttachCount: Integer;
begin
  if not FAttFilled then DoRefreshAttachments;
  Result := FAttach.Count;
end;

function TsxMAPI_Message.GetAttachment(Index: Integer): TsxMAPI_Attachment;
begin
  if not FAttFilled then DoRefreshAttachments;
  Result := nil;
  if (Index<0) or (Index>=FAttach.Count) then Exit;
  Result := FAttach.Items[Index];
end;

procedure TsxMAPI_Message.SetSingleRecepient(Value: AnsiString);
var
  rt: TsxMAPI_MsgRecipientType;
begin
  for rt:=Low(FRec) to High(FRec) do FRec[rt].Clear;
  if Value<>'' then FRec[sxrtTo].Add(Value);
  FRecChanged := True;
end;

function TsxMAPI_Message.GetProperty(ulProperty: ULONG): PSPropValue;
var
  dw: DWORD;
  pCols: PSPropTagArray;
begin
  Result := nil;
  _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
  pCols.cValues := 1;
  pCols.aulPropTag[0] := ulProperty;
  try
    CheckForError(FMessage.GetProps(pCols, 0, dw, Result), szErrorGetProperties);
  finally
    _MAPIFreeBuffer(pCols);
  end;
end;

procedure TsxMAPI_Message.GetRecepientsList(Index: TsxMAPI_MsgRecipientType; ToList: TStrings);
begin
  if not FRecFilled then DoRefreshRecepients;
  ToList.Clear;
  if (Index<Low(FRec)) or (Index>High(FRec)) then Exit;
  ToList.Assign(FRec[Index]);
end;

procedure TsxMAPI_Message.AddRecepient(Index: TsxMAPI_MsgRecipientType; sRecipient: AnsiString);
begin
  if not FRecFilled then DoRefreshRecepients;
  if (Index<Low(FRec)) or (Index>High(FRec)) then raise Exception.Create(szErrorOutOfBounds);
  FRec[Index].Add(sRecipient);
  FRecChanged := True;
end;

procedure TsxMAPI_Message.SetRecepientsList(Index: TsxMAPI_MsgRecipientType; FromList: TStrings);
begin
  if not FRecFilled then DoRefreshRecepients;
  if (Index<Low(FRec)) or (Index>High(FRec)) then raise Exception.Create(szErrorOutOfBounds);
  FRec[Index].Assign(FromList);
  FRecChanged := True;
end;

procedure TsxMAPI_Message.ClearRecepients;
var
  addL: PADRLIST;
  Tbl: IMAPITable;
  pCols: PSPropTagArray;
  pRows: PSRowSet;
  i, iCnt: Integer;
  rt: TsxMAPI_MsgRecipientType;
begin
  pRows := nil;
  pCols := nil;
  addL := nil;
  try
    CheckForError(FMessage.GetRecipientTable(0, Tbl), szErrorGetRecepients);
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
    pCols.cValues := 1;
    pCols.aulPropTag[0] := PR_ROWID;
    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);
    CheckForError(Tbl.QueryRows($7FFFFFFF, 0, pRows), szErrorGetRows);
    iCnt := pRows.cRows;
    if iCnt>0 then begin
      _MAPIAllocateBuffer(sizeof(ULONG) + iCnt * sizeof(TADRENTRY), @addL);
      addL.cEntries := iCnt;
      for i:=0 to iCnt-1 do begin
        addL.aEntries[i].ulReserved1 := 0;
        addL.aEntries[i].cValues := 1;
        addL.aEntries[i].rgPropVals := Pointer(pRows.aRow[i].lpProps);
      end;
      CheckForError(FMessage.ModifyRecipients(MODRECIP_REMOVE, addL), szErrorModifyRecepients);
    end;
  finally
    if addL<>nil then _MAPIFreeBuffer(addL);
    if pRows<>nil then begin
      iCnt := pRows.cRows;
      for i:=0 to iCnt-1 do _MAPIFreeBuffer(pRows.aRow[i].lpProps);
      _MAPIFreeBuffer(pRows);
    end;
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    Tbl := nil;
  end;
  for rt:=Low(FRec) to High(FRec) do FRec[rt].Clear;
end;

function TsxMAPI_Message.AddAttachment: TsxMAPI_Attachment;
begin
  Result := TsxMAPI_Attachment.Create(-1, ATTACH_BY_VALUE, Self);
  FAttach.Add(Result);
  FAttChanged := True;
end;

procedure TsxMAPI_Message.DeleteAttachment(Index: Integer);
begin
  if (Index<0) or (Index>=FAttach.Count) then Exit;
  FAttach.Delete(Index);
  FAttChanged := True;
end;

procedure TsxMAPI_Message.ClearAttachments;
var
  i: Integer;
begin
  for i:=0 to FAttach.Count-1 do TsxMAPI_Attachment(FAttach.Items[i]).Free;
  FAttach.Clear;
  FAttChanged := True;
end;

procedure TsxMAPI_Message.Save;
const iColsCount = 8;
  ulProptypeArr: array [0..iColsCount-1] of ULONG = (PR_MESSAGE_FLAGS, PR_BODY_A,
    PR_SUBJECT_A, PR_DELETE_AFTER_SUBMIT, PR_SENTMAIL_ENTRYID, PR_SENDER_ENTRYID,
    PR_SENT_REPRESENTING_NAME_A, PR_MESSAGE_CLASS_A);
var
  pProperty, pProp: PSPropValue;
  i: Integer;
  bSave: Boolean;
begin
  bSave := FChanged or FRecChanged or FAttChanged;
  if not bSave then Exit;
  pProperty := nil;
  try
    if FChanged then begin
      _MAPIAllocateBuffer(iColsCount * sizeof(TSPropValue), @pProperty);
      FillChar(pProperty^,iColsCount * sizeof(TSPropValue), 0);
      pProp := pProperty;
      for i:=Low(ulProptypeArr) to High(ulProptypeArr) do begin
        pProp.ulPropTag := ulProptypeArr[i];
        pProp.dwAlignPad := 0;
        case ulProptypeArr[i] of
          PR_MESSAGE_FLAGS: pProp.Value.l := MSGFLAG_UNSENT;
          PR_BODY_A: pProp.Value.lpszA := PAnsiChar(FBody);
          PR_SUBJECT_A: pProp.Value.lpszA := PAnsiChar(FSubject);
          PR_DELETE_AFTER_SUBMIT:
            if FFolder.FSession.MessageSendFlag = sxsfDelete then pProp.Value.b := -1
            else pProp.Value.b := 0;
          PR_SENTMAIL_ENTRYID:
            if FFolder.FSession.MessageSendFlag = sxsfToSent then
              pProp.Value.bin := FFolder.FSession.SentFolderEntryID^
            else begin
              pProp.Value.bin.cb := 0;
              pProp.Value.bin.lpb := nil;
            end;
          PR_SENDER_ENTRYID:
            pProp.Value.bin := FFolder.FSession.CurrentUser.FEntryID^;
          PR_SENT_REPRESENTING_NAME_A: pProp.Value.lpszA := PAnsiChar(FFolder.FSession.CurrentUser.Name);
          PR_MESSAGE_CLASS_A : pProp.Value.lpszA := 'IPM.Note';
        end;
      {$IFDEF WIN64} //Pointers are 8 bytes in 64-bit Delphi
      pProp := PSPropValue(Int64(pProp) + sizeof(TSPropValue));
      {$ELSE}
      pProp := PSPropValue(Integer(pProp) + sizeof(TSPropValue));
      {$ENDIf WIN64}
      end;
      CheckForError(FMessage.SetProps(iColsCount, pProperty, nil), szErrorSetProps);
    end;
    DoAssignRecepients;
    DoAssignAttachments;
    CheckForError(FMessage.SaveChanges(KEEP_OPEN_READWRITE), szErrorSaveMessage);
  finally
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
  end;
  FNew := False;
  FChanged := False;
  FRecChanged := False;
  FAttChanged := False;
end;

procedure TsxMAPI_Message.ResolveNames;
const iColsCount = 3;
  ulProperties: array [0..iColsCount-1] of ULONG = (PR_DISPLAY_NAME_A,
    PR_RECIPIENT_TYPE, PR_SEND_RICH_INFO);
var
  Tbl: IMAPITable;
  pAddL: PADRLIST;
  pCols: PSPropTagArray;
  pRows: PSRowSet;
  i, iCnt: Integer;

  pProp: PSPropValue;
begin
  Save;
  pRows := nil;
  pCols := nil;
  pAddL := nil;
  //try
    CheckForError(FMessage.GetRecipientTable(0, Tbl), szErrorGetRecepients);
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*iColsCount, @pCols);
    pCols.cValues := iColsCount;
    for i:=0 to iColsCount-1 do
      pCols.aulPropTag[i] := ulProperties[i];
    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);
    CheckForError(Tbl.QueryRows($7FFFFFFF, 0, pRows), szErrorGetRows);
    iCnt := pRows.cRows;
    _MAPIAllocateBuffer(sizeof(ULONG) + iCnt * sizeof(TADRENTRY), @pAddL);
    pAddL.cEntries := iCnt;
    for i:=0 to iCnt-1 do begin
      pAddL.aEntries[i].ulReserved1 := 0;
      pAddL.aEntries[i].cValues := iColsCount;
      pAddL.aEntries[i].rgPropVals := PSPropValue(pRows.aRow[i].lpProps);
    end;

//  CheckForError(FFolder.FSession.FAddrBook.ResolveName(FFolder.FSession.WndHandle, MAPI_DIALOG , nil, pAddL), szErrorResolveName);
    CheckForError(FFolder.FSession.FAddrBook.ResolveName(0, 0, nil, pAddL), szErrorResolveName);
    CheckForError(FMessage.ModifyRecipients(0, pAddL), szErrorModifyRecepients);
    CheckForError(FMessage.SaveChanges(KEEP_OPEN_READWRITE), szErrorSaveMessage);
  //finally
    iCnt := pAddL.cEntries;
    for i:=0 to iCnt-1 do _MAPIFreeBuffer(pAddL.aEntries[i].rgPropVals);
    if pAddL<>nil then _MAPIFreeBuffer(pAddL);
    if pRows<>nil then
    //pRows.aRow[i].lpProps cleared either by pAddL.aEntries[i].rgPropVals or ResolveName
      _MAPIFreeBuffer(pRows);
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    Tbl := nil;
  //end;
  DoRefreshRecepients;
end;

procedure TsxMAPI_Message.Send;
begin
  ResolveNames;
  CheckForError(FMessage.SubmitMessage(0), szErrorSendMessage);
end;

procedure TsxMAPI_Message.SetReadFlag;
begin
  CheckForError(FMessage.SetReadFlag(SUPPRESS_RECEIPT), szErrorSetReadFlag);
end;

procedure TsxMAPI_Message.Refresh;
begin
  DoRefreshCommon;
  DoRefreshBody;
  DoRefreshRecepients;
  DoRefreshAttachments;
  FChanged := False;
end;

{ TsxMAPI_Folder }

constructor TsxMAPI_Folder.Create(Folder: IMAPIFolder; Owner: TsxMAPI_Session);
begin
  inherited Create;
  FSession := Owner;
  FFolder := Folder;
  FSubs := TList.Create;
  FSubCount := -1;
  FMsgs := TList.Create;
  FMsgCount := -1;
  FFolderName := #1;
  if not Owner.Active then raise Exception.Create(szErrorMAPIUninitialized);
end;

destructor TsxMAPI_Folder.Destroy;
begin
  ClearHierarchi;
  ClearContents;
  FMsgs.Free;
  FSubs.Free;
  FFolder := nil;
  inherited
end;

function TsxMAPI_Folder.GetFolderName: AnsiString;
var
  pProperty: PSPropValue;
  pCols: PSPropTagArray;
  dw: DWORD;
begin
  if FFolderName = #1 then begin
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
    pCols.cValues := 1;
    pCols.aulPropTag[0] := PR_DISPLAY_NAME;
    try
      pProperty := nil;
      CheckForError(FFolder.GetProps(pCols, 0, dw, pProperty), szErrorGetName);
      FFolderName := pProperty.Value.lpszA;
    finally
      if pProperty<>nil then _MAPIFreeBuffer(pProperty);
      _MAPIFreeBuffer(pCols);
    end;
  end;
  Result := FFolderName;
end;

function TsxMAPI_Folder.GetSubCount: Integer;
begin
  if FSubCount<0 then RefreshHierarchi;
  Result := FSubCount;
end;

function TsxMAPI_Folder.GetSubFolder(Index: Integer): TsxMAPI_Folder;
begin
  Result := nil;
  if (Index<0) or (Index>=FSubs.Count) then Exit;
  Result := FSubs.Items[Index];
end;

function TsxMAPI_Folder.GetMsgCount: Integer;
begin
  if FMsgCount<0 then RefreshContents;
  Result := FMsgCount;
end;

function TsxMAPI_Folder.GetMessage(Index: Integer): TsxMAPI_Message;
begin
  Result := nil;
  if (Index<0) or (Index>=FMsgs.Count) then Exit;
  Result := FMsgs.Items[Index];
end;

procedure TsxMAPI_Folder.RefreshHierarchi;
var
  Tbl: IMAPITable;
  SubFolder: TsxMAPI_Folder;
  Child: IMAPIFolder;
  pRows: PSRowSet;
  pCols: PSPropTagArray;
  pEntID: PSBinary;
  i, iCnt: Integer;
  dw: DWORD;
begin
  ClearHierarchi;
  pRows := nil;
  pCols := nil;
  CheckForError(FFolder.GetHierarchyTable(0, Tbl), szErrorGetFolder);
  try
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
    pCols.cValues := 1;
    pCols.aulPropTag[0] := PR_ENTRYID;
    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);
    CheckForError(Tbl.QueryRows($7FFFFFFF, 0, pRows), szErrorGetRows);
    iCnt := pRows.cRows;
    for i:=0 to iCnt-1 do begin
      pEntID := @pRows.aRow[i].lpProps[0].Value.bin;
      if pEntID<>nil then begin
        CheckForError(FSession.FSession.OpenEntry(pEntID.cb, PENTRYID(pEntID.lpb), IID_IMAPIFolder, 0, dw, @Child),
            szErrorGetFolder);
        SubFolder := TsxMAPI_Folder.Create(Child, FSession);
        FSubs.Add(SubFolder);
        Child := nil;
      end;
    end;
  finally
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    if pRows<>nil then begin
      iCnt := pRows.cRows;
      for i:=0 to iCnt-1 do _MAPIFreeBuffer(pRows.aRow[i].lpProps);
      _MAPIFreeBuffer(pRows);
    end;
    Tbl := nil;
  end;
  FSubCount := FSubs.Count;
end;

procedure TsxMAPI_Folder.ClearHierarchi;
var
  i: Integer;
begin
  for i:=0 to FSubs.Count-1 do TsxMAPI_Folder(FSubs.Items[i]).Free;
  FSubs.Clear;
  FSubCount := -1;
end;

procedure TsxMAPI_Folder.RefreshContents;
var
  Tbl: IMAPITable;
  Msg: TsxMAPI_Message;
  pRows: PSRowSet;
  pCols: PSPropTagArray;
  i, iCnt: Integer;
  pEntID: PSBinary;
begin
  ClearContents;
  _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
  pCols.cValues := 1;
  pCols.aulPropTag[0] := PR_ENTRYID;
  try
    CheckForError(FFolder.GetContentsTable(0, Tbl), szErrorGetFolderContent);
    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);
    CheckForError(Tbl.QueryRows($7FFFFFF, 0, pRows), szErrorGetRows);
    iCnt := pRows.cRows;
    for i:=0 to iCnt-1 do begin
      pEntID := @pRows.aRow[i].lpProps[0].Value.bin;
      Msg := TsxMAPI_Message.Create(pEntID, Self);
      FMsgs.Add(Msg);
    end;
  finally
    if pRows<>nil then begin
      iCnt := pRows.cRows;
      for i:=0 to iCnt-1 do _MAPIFreeBuffer(pRows.aRow[i].lpProps);
      _MAPIFreeBuffer(pRows);
    end;
    Tbl := nil;
    _MAPIFreeBuffer(pCols);
  end;
  FMsgCount := FMsgs.Count;
end;

procedure TsxMAPI_Folder.ClearContents;
var
  i: Integer;
begin
  for i:=0 to FMsgs.Count-1 do TsxMAPI_Message(FMsgs.Items[i]).Free;
  FMsgs.Clear;
  FMsgCount := -1;
end;

function TsxMAPI_Folder.CreateMessage: TsxMAPI_Message;
begin
  Result := TsxMAPI_Message.Create(nil, Self);
end;

procedure TsxMAPI_Folder.DeleteMessage(Msg: TsxMAPI_Message);
var
  i: Integer;
  pData: PSPropValue;
  Lst: TENTRYLIST;
begin
  pData := Msg.GetProperty(PR_ENTRYID);
  try
    if pData.Value.bin.cb>0 then begin
      Lst.cValues := 1;
//      Lst.lpbin := Pointer(pData.Value.bin);
      Lst.lpbin := @pData.Value.bin;
      CheckForError(FFolder.DeleteMessages(@Lst, 0, nil, 0), szErrorDeleteMessage);
    end;
  finally
    _MAPIFreeBuffer(pData);
  end;
  i := FMsgs.IndexOf(Msg);
  if i>=0 then FMsgs.Delete(i);
  FMsgCount := FMsgs.Count;
  Msg.Free;
end;

{ TsxMAPI_Session }

constructor TsxMAPI_Session.Create(AOwner: TComponent);
var
  i: TsxMAPI_FolderType;
begin
  inherited Create(AOwner);
  LoadExtendedMAPIFuncs;
  FDoMAPIInit := True;
  FMAPIInit := False;
  FInService := False;
  FWndHandle := 0;
  FMsgSendFlag := sxsfToSent;
  FPSentFolderEntryID := nil;
  FCurrentUser := nil;
  for i:=Low(TsxMAPI_FolderType) to High(TsxMAPI_FolderType) do FFolders[i] := nil;
end;

destructor TsxMAPI_Session.Destroy;
begin
  if FPSentFolderEntryID<>nil then _MAPIFreeBuffer(FPSentFolderEntryID);
  RefreshFolders;
  DoUninitialize;
  inherited;
end;

function TsxMAPI_Session.OpenFolderByEntryID(cSize: Cardinal; pEntID: PENTRYID): IMsgStore;
var
  ulFlags : ULong;
begin
//  CheckForError(FSession.OpenMsgStore(FWndHandle, cSize, pEntID, nil, MDB_NO_DIALOG or MDB_WRITE, Result), szErrorGetMessageStore);
  //PR 07/05/2008 Added delay to try to solve problem on Garden & Leisure site
  SleepEx(1000, True);

  //PR: 25/01/2017 Allow optional bypass of outlook outbox
  ulFlags := MDB_NO_DIALOG or MDB_WRITE;
  if MapiOptions.moNoCachedMode then
    ulFlags := ulFlags or MDB_ONLINE;
  // MH 25/01/2016 2016-R1 ABSEXCH-14374: Removed MDB_ONLINE as that was causing emails to bypass
  // the Outlook Outbox when working offline - see JIRA for analysis of the origins of the change
// CheckForError(FSession.OpenMsgStore(FWndHandle, cSize, pEntID, nil, MDB_NO_DIALOG or MDB_WRITE or MDB_ONLINE, Result), szErrorGetMessageStore);
  CheckForError(FSession.OpenMsgStore(FWndHandle, cSize, pEntID, nil, ulFlags, Result), szErrorGetMessageStore);
end;

procedure TsxMAPI_Session.CheckDefMsgStore;
var
  Tbl: IMAPITable;
  pRows: PSRowSet;
  Filter: TSRestriction;
  FilterVal: TSPropValue;
  pCols: PSPropTagArray;
  iCnt, i: Integer;
  pEntID: PSBinary;
begin
  if not Active then raise Exception.Create(szErrorMAPIUninitialized);
  if FDefaultMessageStore<>nil then Exit;

  pRows := nil;
  pCols := nil;
  CheckForError(FSession.GetMsgStoresTable(0, Tbl), szErrorGetMessageStore);
  try
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
    pCols.cValues := 1;
    pCols.aulPropTag[0] := PR_ENTRYID;

    CheckForError(Tbl.SetColumns(pCols, 0), szErrorSetCols);
    FilterVal.dwAlignPad := 0; FilterVal.ulPropTag := PR_DEFAULT_STORE;
    FilterVal.Value.b := -1;
    Filter.rt := RES_PROPERTY;
    Filter.res.resProperty.relop := RELOP_EQ;
//    TSPropertyRestriction(Filter.res).relop := RELOP_NE;
    Filter.res.resProperty.ulPropTag := PR_DEFAULT_STORE;
    Filter.res.resProperty.lpProp := @FilterVal;
    CheckForError(Tbl.Restrict(@Filter, 0), szErrorApplyFilter);
    CheckForError(Tbl.QueryRows(1, 0, pRows), szErrorGetRows);
    if pRows.cRows<>1 then raise Exception.Create(szErrorGetMessageStore);
    pEntID := @pRows.aRow[0].lpProps[0].Value.bin;
    FDefaultMessageStore := OpenFolderByEntryID(pEntID.cb, PENTRYID(pEntID.lpb));
  finally
    if pRows<>nil then begin
      iCnt := pRows.cRows;
      for i:=0 to iCnt-1 do _MAPIFreeBuffer(pRows.aRow[i].lpProps);
      _MAPIFreeBuffer(pRows);
    end;
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    Tbl := nil;
  end;
end;

function TsxMAPI_Session.GetIncomeFolder: TsxMAPI_Folder;
var
  Folder: IMAPIFolder;
  pEntID: PENTRYID;
  dw: DWORD;
begin
  pEntID := nil;
  try
    CheckForError(FDefaultMessageStore.GetReceiveFolder(nil, 0, dw, pEntID, nil), szErrorGetEntryIDFolder);
    CheckForError(FDefaultMessageStore.OpenEntry(dw, pEntID, IID_IMAPIFolder,
      MAPI_BEST_ACCESS, dw, @Folder), szErrorGetFolder);
    Result := TsxMAPI_Folder.Create(Folder, Self);
  finally
    if pEntID<>nil then _MAPIFreeBuffer(pEntID);
    Folder := nil;
  end;
end;

function TsxMAPI_Session.InternalGetFolder(ulID: ULONG): TsxMAPI_Folder;
var
  Folder: IMAPIFolder;
  pEntID: PSBinary;
  pCols: PSPropTagArray;
  pProperty: PSPropValue;
  dw: DWORD;
begin
  pCols := nil;
  pProperty := nil;
  try
    _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
    pCols.cValues := 1;
    pCols.aulPropTag[0] := ulID;
    CheckForError(FDefaultMessageStore.GetProps(pCols, 0, dw, pProperty), szErrorGetEntryIDFolder);
    pEntID := @pProperty.Value.bin;
    CheckForError(FDefaultMessageStore.OpenEntry(pEntID.cb, PENTRYID(pEntID.lpb),
      IID_IMAPIFolder, MAPI_BEST_ACCESS, dw, @Folder), szErrorGetFolder);
    Result := TsxMAPI_Folder.Create(Folder, Self);
  finally
    if pProperty<>nil then _MAPIFreeBuffer(pProperty);
    if pCols<>nil then _MAPIFreeBuffer(pCols);
    Folder := nil;
  end;
end;

function TsxMAPI_Session.SentFolderEntryID: PSBinary;
var
  pCols: PSPropTagArray;
  dw: DWORD;
begin
  if FPSentFolderEntryID=nil then begin
    pCols := nil;
    try
      _MAPIAllocateBuffer(sizeof(ULONG) + sizeof(ULONG)*1, @pCols);
      pCols.cValues := 1;
      pCols.aulPropTag[0] := PR_IPM_SENTMAIL_ENTRYID;
      CheckForError(FDefaultMessageStore.GetProps(pCols, 0, dw, FPSentFolderEntryID), szErrorGetEntryIDFolder);
    finally
      if pCols<>nil then _MAPIFreeBuffer(pCols);
    end;
  end;
  Result := @FPSentFolderEntryID.Value.bin;
end;

procedure TsxMAPI_Session.SetProfile(Value: AnsiString);
begin
  if Value=FProfile then Exit;
  if FSession<>nil then raise Exception.Create(szErrorLoggedIn);
  FProfile := Value;
end;

procedure TsxMAPI_Session.SetPassword(Value: AnsiString);
begin
  if Value=FPassword then Exit;
  if FSession<>nil then raise Exception.Create(szErrorLoggedIn);
  FPassword := Value;
end;

procedure TsxMAPI_Session.SetDoMAPIInit(Value: Boolean);
begin
  if Value=FDoMAPIInit then Exit;
  if FMAPIInit then raise Exception.Create(szErrorMAPIInitialized);
  FDoMAPIInit := Value;
end;

procedure TsxMAPI_Session.SetInService(Value: Boolean);
begin
  if Value=FInService then Exit;
  if FMAPIInit then raise Exception.Create(szErrorMAPIInitialized);
  FInService := Value;
end;

function TsxMAPI_Session.GetFolder(Index: TsxMAPI_FolderType): TsxMAPI_Folder;
const ParTypeArr: array [TsxMAPI_FolderType] of ULONG = (0,
        PR_IPM_SUBTREE_ENTRYID,
        PR_IPM_OUTBOX_ENTRYID,
        PR_IPM_SENTMAIL_ENTRYID,
        PR_IPM_WASTEBASKET_ENTRYID);
begin
  CheckDefMsgStore;
  if FFolders[Index]=nil then begin
    if Index=sxftInbox then FFolders[Index] := GetIncomeFolder
    else FFolders[Index] := InternalGetFolder(ParTypeArr[Index]);
  end;
  Result := FFolders[Index];
end;

function TsxMAPI_Session.GetCurrentUser: TsxMAPI_MailUser;
var
  p: PENTRYID;
  ent: TSBinary;
begin
  if not Active then raise Exception.Create(szErrorMAPIUninitialized);
  if FCurrentUser=nil then begin
    CheckForError(FSession.QueryIdentity(ent.cb, p), szErrorGetProperties);
    try
      ent.lpb := Pointer(p);
      FCurrentUser := TsxMAPI_MailUser.Create(@ent, Self);
    finally
      _MAPIFreeBuffer(p);
    end;
  end;
  Result := FCurrentUser;
end;

function TsxMAPI_Session.GetActive: Boolean;
begin
  Result := FSession<>nil;
end;

procedure TsxMAPI_Session.DoInitialize;
type
  TMAPIInit = record
    ulVersion, ulFlags: ULONG;
  end;
var
  Ini: TMAPIInit;
begin
  if FMAPIInit then Exit;
  Ini.ulVersion := MAPI_INIT_VERSION;
  Ini.ulFlags := 0;
  if FInService then Ini.ulFlags := Ini.ulFlags or MAPI_NT_SERVICE;
  if not FDoMAPIInit then Ini.ulFlags := Ini.ulFlags or MAPI_NO_COINIT;
  CheckForError(_MAPIInitialize(@Ini), szErrorDoInit);
  FMAPIInit := True;
end;

procedure TsxMAPI_Session.DoUninitialize;
begin
  if not FMAPIInit then Exit;
  Logoff(False);
  _MAPIUninitialize;
  FMAPIInit := False;
end;

procedure TsxMAPI_Session.Logon;
var
  Flags: ULONG;
begin
  if not FMAPIInit then DoInitialize;
  if FSession<>nil then Logoff(False);
  Flags := MAPI_EXTENDED;
//  Flags := Flags or MAPI_NEW_SESSION;
  if FProfile<>szEmptyString then
    Flags := Flags or MAPI_NEW_SESSION or MAPI_EXPLICIT_PROFILE
  else
    Flags := Flags or MAPI_NEW_SESSION or MAPI_USE_DEFAULT;
  if FWndHandle<>0 then Flags := Flags or MAPI_LOGON_UI;
  if FInService then Flags := Flags or MAPI_NT_SERVICE;
  CheckForError(_MAPILogonEx(FWndHandle, PAnsiChar(FProfile), PAnsiChar(FPassword), Flags, FSession), szErrorMAPILogon);
  CheckForError(FSession.OpenAddressBook(FWndHandle, nil, 0, FAddrBook), szErrorOpenAB);
end;

procedure TsxMAPI_Session.Logoff(bShared: Boolean);
var
  Flags: ULONG;
begin
  if FCurrentUser<>nil then FCurrentUser.Free;
  FCurrentUser := nil;
  FDefaultMessageStore := nil;
  FAddrBook := nil;
  if FSession<>nil then begin
    Flags := 0;
    if bShared then Flags := Flags or MAPI_LOGOFF_SHARED;
    if FWndHandle<>0 then Flags := Flags or MAPI_LOGOFF_UI;
    CheckForError(FSession.Logoff(FWndHandle, Flags, 0), szEmptyString);
    FSession := nil;
  end;
end;

procedure TsxMAPI_Session.RefreshFolders;
var
  i: TsxMAPI_FolderType;
begin
  for i:=Low(TsxMAPI_FolderType) to High(TsxMAPI_FolderType) do
      if FFolders[i] <> nil then begin
    FFolders[i].Free;
    FFolders[i] := nil;
  end;
end;

procedure Register;
begin
  RegisterComponents('Aventis', [TsxMAPI_Session]);
end;

Initialization
  iLastErrorCode := 0;

end.
