(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msmsg;

{$I msDef.inc}

interface

uses
  Windows,
  SysUtils, Messages, Classes,
{$IFDEF VCL}
  Graphics, Controls,
  Forms, Dialogs, ShellAPI,
{$ENDIF}
  MSMsgCls, msMime, msDef,
  msConst;

type
  EMessageError = class(Exception);

{$IFDEF VCL}
  TmsCustomMessage = class(TComponent)
{$ELSE}
  TmsCustomMessage=class(TPersistent)
{$ENDIF}
  private
    { Private declarations }
    FSender : TmsMailAddress;
    FSubject : ShortString;
    FEncoding : TmsMsgEncoding;  {Enabled in version 1.2}
    FCharSet : TmsCharSet;
    FHeaders : TmsHeaders;
    FBody : TStrings;
    FAttachments : TmsAttList;
    FContentType : ShortString;
    procedure SetHeaders(Value : TmsHeaders);
    procedure SetBody(Value : TStrings);
    procedure SetAttachments(Value : TmsAttList);
    function GetContentType : ShortString;
    procedure SetContentType(Value : ShortString);
    function GetVersion: string;
    procedure SetVersion(const Value: string);
  protected
    { Protected declarations }
    CleanUpList : TStrings;
    procedure CleanUpFiles;
    procedure Error(Index : word);
{$IFNDEF WIN32}
    function AdjustFileName(const FileName : string) : string;
{$ENDIF}
  public
    { Public declarations }
{$IFDEF VCL}
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create;
{$ENDIF}
    destructor Destroy; override;
{$IFDEF VCL}
    procedure Loaded; override;
{$ENDIF}
    procedure Assign(Value : TPersistent); override;
    procedure Verify; virtual;
    procedure SaveToStream(AStream : TStream); virtual; abstract;
    procedure LoadFromStream(AStream : TStream); virtual; abstract;
    procedure SaveToFile(const FileName : string);
    procedure LoadFromFile(const FileName : string);
    procedure LoadHeaders(AStream : TStream);
    procedure Clear; virtual;
    procedure SaveAttachment(Index : Integer; const Path : string);
{$IFDEF WIN32}
{$IFDEF VCL}
    procedure ExecuteAttachment(Index : Integer);
{$ENDIF}
{$ENDIF}
    procedure ProcessHeaders(TheHeaders : TmsHeaders); virtual; abstract;
{$IFDEF VCL}
  published
{$ENDIF}
    { Published declarations }
    property Attachments : TmsAttList read FAttachments write SetAttachments;
    property ContentType : ShortString read GetContentType write SetContentType;
    property Encoding : TmsMsgEncoding read FEncoding write FEncoding
                         default meMIME;
    property Sender : TmsMailAddress read FSender write FSender;
    property Subject : ShortString read FSubject write FSubject;
    property CharSet : TmsCharSet read FCharSet write FCharSet
                          default csUSASCII;
    property Headers : TmsHeaders read FHeaders write SetHeaders;
    property Body : TStrings read FBody write SetBody;
    property Version: string read GetVersion write SetVersion;
  end;

  TmsMessage = class(TmsCustomMessage)  {The email message}
  private
    FRecipients : TmsAddressList;
    FCC : TmsAddressList;
    FBCC : TmsAddressList;
    FReturnReceipt : boolean;
    FPriority : TmsPriority;
    procedure SetRecipients(Value : TmsAddressList);
    procedure SetCC(Value : TmsAddressList);
    procedure SetBCC(Value : TmsAddressList);
  public
{$IFDEF VCL}
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create;
{$ENDIF}
    destructor Destroy; override;
    procedure Assign(Value : TPersistent); override;
    procedure Clear; override;
    procedure Verify; override;
    procedure SaveToStream(AStream : TStream); override;
    procedure LoadFromStream(AStream : TStream); override;
    procedure ProcessHeaders(TheHeaders : TmsHeaders); override;
{$IFDEF VCL}
  published
{$ENDIF}
    property Recipients : TmsAddressList read FRecipients write SetRecipients;
    property ReturnReceipt : boolean read FReturnReceipt write FReturnReceipt;
    property Priority : TmsPriority read FPriority write FPriority default ptNormal;
    property CC : TmsAddressList read FCC write SetCC;
    property BCC : TmsAddressList read FBCC write SetBCC;
  end;

  TmsArticle = class(TmsCustomMessage)
  private
    FNewsGroups : string;
    FMessageID : string;
    FPath : string;
  public
    procedure Assign(Value : TPersistent); override;
    procedure Clear; override;
    procedure Verify; override;
    procedure SaveToStream(AStream : TStream); override;
    procedure LoadFromStream(AStream : TStream); override;
    procedure ProcessHeaders(TheHeaders : TmsHeaders); override;
    property MessageID : string read FMessageID write FMessageID;
    property Path : string read FPath write FPath;
{$IFDEF VCL}
  published
{$ENDIF}
    property NewsGroups : string read FNewsGroups write FNewsGroups;
  end;

implementation

uses msutils, mspars;

{$IFDEF VCL}
constructor TmsCustomMessage.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
{$ELSE}
constructor TmsCustomMessage.Create;
begin
  inherited Create;
{$ENDIF}
  FContentType:='text/plain';
  FEncoding:=meMIME;
  FCharSet:=csUSASCII;
  FHeaders:=TmsHeaders.Create;
  FBody:=TStringList.Create;
  FAttachments:=TmsAttList.Create;
  FSender:=TmsMailAddress.Create;
  CleanUpList:=TStringList.Create;
end;

destructor TmsCustomMessage.Destroy;
begin
  CleanUpFiles;
  CleanUpList.Free;
  FSender.Free;
  FAttachments.Free;
  FBody.Free;
  FHeaders.Free;
  inherited Destroy;
end;

{$IFDEF VCL}
procedure TmsCustomMessage.Loaded;
var
  i : Integer;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
    for i:=0 to FAttachments.Count-1 do
      FAttachments[i].Contents.LoadFromFile(FAttachments[i].FileName);
end;
{$ENDIF}

procedure TmsCustomMessage.Assign(Value : TPersistent);
var
  VMsg : TmsCustomMessage;
begin
  if Value.InheritsFrom(TmsCustomMessage) then
  begin
    VMsg:=Value as TmsCustomMessage;
    FSender.Assign(VMsg.Sender);
    FSubject:=VMsg.Subject;
    FEncoding:=VMsg.Encoding;
    FCharSet:=VMsg.CharSet;
    FHeaders.Assign(VMsg.Headers);
    FBody.Assign(VMsg.Body);
    FAttachments.Assign(VMsg.Attachments);
    FContentType:=VMsg.ContentType;
{$IFDEF VCL}
    Tag:=VMsg.Tag;
{$ENDIF}
  end
  else
    inherited Assign(Value);
end;

procedure TmsCustomMessage.SetHeaders(Value : TmsHeaders);
begin
  FHeaders.Assign(Value);
end;

procedure TmsCustomMessage.SetBody(Value : TStrings);
begin
  FBody.Assign(Value);
end;

procedure TmsCustomMessage.SetAttachments(Value : TmsAttList);
var
  i : Integer;
{$IFDEF VCL}
  AttItem : TmsAttItem;
{$ENDIF}  
begin
  FAttachments.Clear;
{$IFDEF VCL}
  if csDesigning in ComponentState then
  begin
    for i:=0 to Value.Count-1 do
    begin
      AttItem:=TmsAttItem.Create;
      AttItem.FileName:=Value[i].FileName;
      AttItem.ContentType:=Value[i].ContentType;
      AttItem.ContentTransferEncoding:=Value[i].ContentTransferEncoding;
      FAttachments.Add(AttItem);
    end
  end
  else
    for i:=0 to Value.Count-1 do
      FAttachments.Add(Value[i]);
{$ELSE}
  for i:=0 to Value.Count-1 do
    FAttachments.Add(Value[i]);
{$ENDIF}
  if FAttachments.Count>0 then
    FContentType:='multipart/mixed'
  else
    FContentType:='text/plain';
end;

function TmsCustomMessage.GetContentType : ShortString;
var
  i : Integer;
  IsMA : boolean;
  JustFileName : string;
begin
{if UUCode then return blank}
  if FEncoding=meUU then
  begin
    FContentType:='';
    Result:='';
    Exit;
  end;
{Check for multipart/alternative
All file names must be _alt.*}
  IsMA:=FAttachments.Count>0;
  for i:=0 to FAttachments.Count-1 do
  begin
    JustFileName:=ExtractFileName(LowerCase(FAttachments[i].FileName));
    IsMA:=IsMA and (Copy(JustFileName,1,5)='_alt.');
  end;
  if IsMA then
    FContentType:='multipart/alternative'
  else
  if (FAttachments.Count=1) and (FBody.Count=0) and
     (LowerCase(ExtractFileName(FAttachments[0].FileName))='_rtfbody.rtf') then
    FContentType:='text/rtf'
  else
  if (FAttachments.Count=1) and (FBody.Count=0) and
     (LowerCase(ExtractFileName(FAttachments[0].FileName))='_htmbody.htm') then
    FContentType:='text/html'
  else
  begin
    {if the body of message is blank}
    if FBody.Count=0 then
    begin
      if FAttachments.Count=1 then
        FContentType:=FAttachments[0].ContentType
      else
      if FAttachments.Count>1 then
        FContentType:='multipart/mixed'
      else
        FContentType:='text/plain';
    end
    else
    begin
      if FAttachments.Count>0 then
        FContentType:='multipart/mixed'
      else
      if FContentType='' then
        FContentType:='text/plain';
    end;
  end;
  Result:=FContentType;
end;

procedure TmsCustomMessage.SetContentType(Value : ShortString);
begin
  FContentType:=LowerCase(Value);
end;

function TmsCustomMessage.GetVersion: string;
begin
  Result:=msVersion;
end;

procedure TmsCustomMessage.SetVersion(const Value: string);
begin
end;

procedure TmsCustomMessage.Verify;
begin
  if Sender.Address='' then
    Error(msSSenderRequired);
end;

procedure TmsCustomMessage.Error(Index : word);
begin
  raise EMessageError.CreateRes(Index);
end;

procedure TmsCustomMessage.CleanUpFiles;
{Cleanup files created when shellexec, if possible}
var
  i : Integer;
  F : file;
begin
  for i:=0 to CleanUpList.Count-1 do
  begin
    AssignFile(F,CleanUpList[i]);
    try
      Erase(F);
    except
      {Do nothing}
    end;
  end;
end;

procedure TmsCustomMessage.SaveToFile(const FileName : string);
var
  FileStream : TFileStream;
begin
  FileStream:=TFileStream.Create(FileName,fmCreate or fmOpenWrite);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TmsCustomMessage.LoadFromFile(const FileName : string);
var
  FileStream : TFileStream;
begin
  Clear;
  FileStream:=TFileStream.Create(FileName,fmOpenRead);
  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TmsCustomMessage.LoadHeaders(AStream : TStream);
const
  BufSize=2048;
var
  Buf : PChar;
  TempHeaders : TmsHeaders;
  rc : LongInt;
begin
  Buf:=StrAlloc(BufSize);
  try
    AStream.Position:=0;
    FillChar(Buf^,StrBufSize(Buf),0);
    rc:=AStream.Read(Buf^,BufSize);
    if rc<>0 then
    begin
      TempHeaders:=TmsHeaders.Create;
      try
        TempHeaders.SetText(Buf);
        TempHeaders.CleanUp;
        ProcessHeaders(TempHeaders);
      finally
        TempHeaders.Free;
      end;
    end;
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsCustomMessage.Clear;
begin
  FBody.Clear;
  FAttachments.Clear;
  FSender.Clear;
  FHeaders.Clear;
  FSubject:='';
  FEncoding:=meMime;
  FCharSet:=csUSASCII;
  FContentType:='';
end;

{$IFNDEF WIN32}
function TmsCustomMessage.AdjustFileName(const FileName : string) : string; {1.21} {Long filenames}
var
  JustFileName, JustExtension, s : string;
  i : Integer;
begin
  s:=ExtractFileName(FileName);
  JustExtension:=ExtractFileExt(s);
  i:=Pos(JustExtension,s);
  if i>0 then
    JustFileName:=Copy(s,1,i-1)
  else
    JustFileName:=s;
  if Length(JustExtension)>4 then
    JustExtension:=Copy(JustExtension,1,4);
  if Length(JustFileName)>8 then
    JustFileName:=Trim(Copy(JustFileName,1,8));
  Result:=Concat(JustFileName,JustExtension);
end;
{$ENDIF}

procedure TmsCustomMessage.SaveAttachment(Index : Integer; const Path : string);
var
  FileName : string;
begin
  FileName:=ExtractFileName(Attachments[Index].FileName);
{$IFDEF WIN32}
  Attachments[Index].Contents.SaveToFile(Concat(AddBackSlash(Path),FileName));
{$ELSE}
  Attachments[Index].Contents.SaveToFile(Concat(AddBackSlash(Path),
       AdjustFileName(FileName)));
{$ENDIF}
end;

{$IFDEF WIN32}
{$IFDEF VCL}
procedure TmsCustomMessage.ExecuteAttachment(Index : Integer);
var
  TempPath,s : string;
  TheHandle : THandle;
  Buf : array[0..255] of char;
begin
  if FAttachments[Index].FileName='' then
    raise Exception.CreateResFmt(msSFileNameBlank,[Index]);
  GetTempPath(255,@Buf);
  TempPath:=StrPas(@Buf);
  SaveAttachment(Index,TempPath);
  s:=Concat(TempPath,FAttachments[Index].FileName);
  CleanUpList.Add(s);
  TheHandle:=ShellExecute(Application.Handle,'Open',PChar(s),nil,nil,SW_SHOW);
  if TheHandle<=31 then
    raise Exception.CreateResFmt(msSShellExecFailed,[TheHandle]);
end;
{$ENDIF}
{$ENDIF}

{TmsMessage}
{$IFDEF VCL}
constructor TmsMessage.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
{$ELSE}
constructor TmsMessage.Create;
begin
  inherited Create;
{$ENDIF}
  FCC:=TmsAddressList.Create;
  FBCC:=TmsAddressList.Create;
  FRecipients:=TmsAddressList.Create;
  FPriority:=ptNormal;
end;

destructor TmsMessage.Destroy;
begin
  FRecipients.Free;
  FBCC.Free;
  FCC.Free;
  inherited Destroy;
end;

procedure TmsMessage.SetRecipients(Value : TmsAddressList);
begin
  FRecipients.Assign(Value);
end;

procedure TmsMessage.SetCC(Value : TmsAddressList);
begin
  FCC.Assign(Value);
end;

procedure TmsMessage.SetBCC(Value : TmsAddressList);
begin
  FBCC.Assign(Value);
end;

procedure TmsMessage.Assign(Value : TPersistent);
begin
  if Value is TmsMessage then
  begin
    FRecipients.Assign((Value as TmsMessage).Recipients);
    FCC.Assign((Value as TmsMessage).CC);
    FBCC.Assign((Value as TmsMessage).BCC);
    FPriority:=((Value as TmsMessage).Priority);
    FReturnReceipt:=(Value as TmsMessage).ReturnReceipt;
  end
  else
  if Value is TmsArticle then
  begin
    FHeaders.Assign((Value as TmsArticle).Headers);
  end;
  inherited Assign(Value);
end;

procedure TmsMessage.Clear;
begin
  inherited Clear;
  FCC.Clear;
  FBCC.Clear;
  FRecipients.Clear;
end;

procedure TmsMessage.Verify;
var
  i : Integer;
  Ok : boolean;
begin
  inherited Verify;
  i:=0; Ok:=false;
  while (not Ok) and (i<Recipients.Count) do
  begin
    Ok:=Recipients[i].Address<>'';
    Inc(i);
  end;
  if not Ok then
  begin
    i:=0; Ok:=false;
    while (not Ok) and (i<CC.Count) do
    begin
      Ok:=CC[i].Address<>'';
      Inc(i);
    end;
  end;
  if not Ok then
  begin
    i:=0; Ok:=false;
    while (not Ok) and (i<BCC.Count) do
    begin
      Ok:=BCC[i].Address<>'';
      Inc(i);
    end;
  end;
  if not Ok then
    Error(msSRecipientRequired);
end;

procedure TmsMessage.ProcessHeaders(TheHeaders : TmsHeaders);
var
  s : string;
  TempLines : TStringList;
  i : Integer;
  TheAddress : TmsMailAddress;
begin
  TempLines:=TStringList.Create;
  try
{Sender}
    s:=TheHeaders.GetFieldBody('FROM');
    PickMailAddress(s,Sender);
{Recipients}
    TheHeaders.GetMultiLineFieldBody('TO',TempLines);
    i:=0;
    while (i<TempLines.Count) do
    begin
      PreprocessMultiLineAddressField(TempLines);
      TheAddress:=TmsMailAddress.Create;
      PickMailAddress(TempLines[i],TheAddress);
      Recipients.Add(TheAddress);
      Inc(i);
    end;
{CC}
    TempLines.Clear;
    TheHeaders.GetMultiLineFieldBody('CC',TempLines);
    i:=0;
    while i<TempLines.Count do
    begin
      PreprocessMultiLineAddressField(TempLines);
      TheAddress:=TmsMailAddress.Create;
      PickMailAddress(TempLines[i],TheAddress);
      CC.Add(TheAddress);
      Inc(i);
    end;
{BCC, just in case}
    TempLines.Clear;
    TheHeaders.GetMultiLineFieldBody('BCC',TempLines);
    i:=0;
    while i<TempLines.Count do
    begin
      PreprocessMultiLineAddressField(TempLines);
      TheAddress:=TmsMailAddress.Create;
      PickMailAddress(TempLines[i],TheAddress);
      BCC.Add(TheAddress);
      Inc(i);
    end;
    s:=TheHeaders.GetFieldBody('Subject');
    if s<>'' then Subject:=s;
{Priority and return-receipt-to}
    s:=TheHeaders.GetFieldBody('X-Priority');
    if s='1' then
      Priority:=ptHigh
    else
    if s='5' then
      Priority:=ptLow
    else
      Priority:=ptNormal;
    s:=TheHeaders.GetFieldBody('Return-receipt-to');
    if s<>'' then
      ReturnReceipt:=true;
    FHeaders.Assign(TheHeaders);
  finally
    TempLines.Free;
  end;
end;

procedure TmsMessage.SaveToStream(AStream : TStream);
var
  MessageEncoder : TmsMessageEncoder;
begin
  MessageEncoder:=TmsMessageEncoder.Create(Self);
  try
    MessageEncoder.TheStream:=AStream;
    MessageEncoder.Process;
  finally
    MessageEncoder.Free;
  end;
end;

procedure TmsMessage.LoadFromStream(AStream : TStream);
var
  MessageDecoder : TmsMessageDecoder;
begin
  MessageDecoder:=TmsMessageDecoder.Create(AStream);
  try
    MessageDecoder.MailMessage:=Self;
    MessageDecoder.Process;
  finally
    MessageDecoder.Free;
  end;
end;

{TmsAtricle}
procedure TmsArticle.Clear;
begin
  NewsGroups:='';
  inherited Clear;
end;

procedure TmsArticle.Assign(Value : TPersistent);
begin
  if Value is TmsArticle then
    FNewsGroups:=(Value as TmsArticle).NewsGroups;
  inherited Assign(Value);
end;

procedure TmsArticle.Verify;
begin
  inherited Verify;
  if FNewsGroups='' then
    Error(msSNewsGroupRequired);
  if FSubject='' then
    Error(msSSubjectRequired);
end;

procedure TmsArticle.ProcessHeaders(TheHeaders : TmsHeaders);
var
  s : string;
  TempLines : TStringList;
begin
  TempLines:=TStringList.Create;
  try
{Sender}
    s:=TheHeaders.GetFieldBody('FROM');
   PickMailAddress(s,Sender);
{Path}
   Path:=TheHeaders.GetFieldBody('PATH');
{NewsGroups}
    NewsGroups:=TheHeaders.GetFieldBody('NEWSGROUPS');
{MessageID}
    MessageID:=TheHeaders.GetFieldBody('MESSAGE-ID');
    s:=TheHeaders.GetFieldBody('Subject');
    if s<>'' then
      Subject:=s;
    Headers.Assign(TheHeaders);
  finally
    TempLines.Free;
  end;
end;

procedure TmsArticle.SaveToStream(AStream : TStream);
var
  ArticleEncoder : TmsArticleEncoder;
begin
  ArticleEncoder:=TmsArticleEncoder.Create(Self);
  try
    ArticleEncoder.TheStream:=AStream;
    ArticleEncoder.Process;
  finally
    ArticleEncoder.Free;
  end;
end;

procedure TmsArticle.LoadFromStream(AStream : TStream);
var
  MessageDecoder : TmsArticleDecoder;
begin
  MessageDecoder:=TmsArticleDecoder.Create(AStream);
  try
    MessageDecoder.MailMessage:=Self;
    MessageDecoder.Process;
  finally
    MessageDecoder.Free;
  end;
end;

end.
