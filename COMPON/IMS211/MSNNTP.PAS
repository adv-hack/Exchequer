(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msNNTP;

{ Modified by: Bruce W. Caron                }
{ Excelsoft Design Limited                   }
{ 22 Clearview Drive                         }
{ Bedford, NS, Canada, B4A3C8                }
{ February 19,1998                           }
{ Added: RFC977-NNTP-Ext 3.1 AUTHINFO        }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  msSocket, msDef, msMsg;

const
  AuthRequest1 = 480;                      {bwc}
  AuthRequest2 = 450;

type

  TmsNewsgroupItem = class
  protected
    procedure ParseString(const s: string);
    function ToString: string;
  public
    Name: string;
    FirstArticle: LongInt;
    LastArticle: LongInt;
    Flag: Char; {'y'-posting allowed, 'n'-posting not allowed, 'm'-moderated}
  end;

  TmsNewsgroupItemRetrievedEvent = procedure(Sender: TObject;
     NewsgroupItem: TmsNewsgroupItem) of Object;

  TmsNewsgroupList = class
  private
    FList : TList;
    function Get(Index : Integer) : TmsNewsgroupItem;
    procedure Put(Index : Integer; Value : TmsNewsgroupItem);
    function GetCount : Integer;
  protected
    function PickAPart(s : string; Position : Integer) : string;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Value : TmsNewsgroupItem) : Integer;
    procedure Delete(Index: Integer);
    procedure SaveToFile(const FileName : string);
    procedure SaveToStream(Stream : TStream);
    procedure LoadFromFile(const FileName : string);
    procedure LoadFromStream(Stream : TStream);
    procedure Clear;
    property Items[Index : Integer] : TmsNewsgroupItem read Get write Put; default;
    property Count : Integer read GetCount;
  end;

  TmsOverviewItem = class
  private
    FFmt: TStringList;
    function PickData(const Header,Data: string): string;
    function PickMsgNo(const s: string): Integer;
  public
    ArticleNo: LongInt;
    Subject: string;
    SenderName: string;
    SenderAddress: string;
    Date: TDateTime;
    TimeZone: ShortString;
    MessageID: string;
    References: string;
    Bytes: LongInt;
    Lines: Integer;
    constructor Create(Fmt: TStringList);
    destructor Destroy; override;
    procedure ParseString(const s: string);
  end;

  TmsOverviewItemRetrievedEvent = procedure(Sender: TObject;
     OverviewItem: TmsOverviewItem) of Object;

  TmsOverviewList = class
  private
    FList: TList;
    function Get(Index: Integer): TmsOverviewItem;
    procedure Put(Index: Integer; Value: TmsOverviewItem);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(Value: TmsOverviewItem): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TmsOverviewItem read Get write Put; default;
  end;

  TmsNNTPClient = class(TmsClientSocket)
  private
    { Private declarations }
    FArticle: TmsArticle;
    FNewsgroup: string;
    FFirstArticle: LongInt;
    FLastArticle: LongInt;
    FTotalArticles: LongInt;
    FCurrentArticle: LongInt;
    FAuthorization: boolean;   {bwc}
    FUserName: string;         {bwc}
    FPassword: string;         {bwc}
    FOverFmt: TStringList;
    FOverview: TmsOverviewList;
    FNewsgroupList: TmsNewsgroupList;
    FOnNewsgroupItemRetrieved: TmsNewsgroupItemRetrievedEvent;
    FOnOverviewItemRetrieved: TmsOverviewItemRetrievedEvent;
    procedure Setnewsgroup(const Value: string);
    function GetEOA: boolean;
    function GetBOA: boolean;
    procedure SetCurrentArticle(Value: LongInt);
    function SendLineHook(const Cmd: string): Integer;
  protected
    { Protected declarations }
    function GetServerReplyCode(const s: string): Integer; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure XOverFmt;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Login;
    procedure AuthLogin;
    procedure First;
    procedure Last;
    procedure Next;
    procedure Retrieve;
    procedure Post;
    procedure RetrieveHeaders;
    function RetrieveHeader(const Header: string): string;
    procedure RetrieveArticleByID(const ID: string);
    procedure RetrieveArticleByNumber(Number: LongInt);
    procedure Logout;
    procedure GetOverview(FirstMsgNo, LastMsgNo: LongInt);
    procedure RetrieveNewsgroupList;
    procedure RetrieveNewGroups(Since: TDateTime; const TimeZone: string);
    procedure LoadNewsgroupList(const FileName: string);
    procedure SaveNewsgroupList(const FileName: string);
    property Overview: TmsOverviewList read FOverview write FOverview;
    property NewsgroupList: TmsNewsgroupList read FNewsgroupList write FNewsgroupList;
    property FirstArticle: LongInt read FFirstArticle;
    property LastArticle: LongInt read FLastArticle;
    property TotalArticles: LongInt read FTotalArticles;
    property EOA: boolean read GetEOA;
    property BOA: boolean read GetBOA;
    property CurrentArticle: LongInt read FCurrentArticle write SetCurrentArticle;
  published
    { Published declarations }
    property Article: TmsArticle read FArticle write FArticle;
    property Authorization: boolean read FAuthorization write FAuthorization;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Newsgroup: string read FNewsGroup write SetNewsgroup;
    property OnOverviewItemRetrieved: TmsOverviewItemRetrievedEvent
      read FOnOverviewItemRetrieved write FOnOverviewItemRetrieved;
    property OnNewsgroupItemRetrieved: TmsNewsgroupItemRetrievedEvent
      read FOnNewsgroupItemRetrieved write FOnNewsgroupItemRetrieved;
  end;

implementation

uses msUtils, msMsgCls;

procedure StringToList(const s: string; SL: TStrings);
const
  Tab=^I;
var
  i: Integer;
  s1,s2: string;
begin
  SL.Clear;
  s1:=s;
  while (Pos(Tab,s1)>0) do
  begin
    i:=Pos(Tab,s1);
    s2:=Copy(s1,1,i-1);
    System.Delete(s1,1,i);
    SL.Add(s2);
  end;
  SL.Add(s1);
end;

{ TmsNewsgroupItem }
procedure TmsNewsgroupItem.ParseString(const s: string);
var
  s1: string;
begin
  Name:=PickString(s,0,true);
  LastArticle:=PickNumber(s,1);
  FirstArticle:=PickNumber(s,2);
  s1:=Copy(Trim(PickString(s,3,true)),1,1);
  if Length(s1)=1 then
    Flag:=s1[1]
  else
    Flag:=#00;
end;

function TmsNewsgroupItem.ToString: string;
begin
  Result:=Concat(Name,' ',IntToStr(LastArticle),' ',
         IntToStr(FirstArticle),' ',Flag);
end;

{ TmsNewsGroupList }
constructor TmsNewsGroupList.Create;
begin
  inherited Create;
  FList:=TList.Create;
end;

destructor TmsNewsGroupList.Destroy;
var
  i : Integer;
begin
  if FList<>nil then
  begin
    for i:=Count-1 DownTo 0 do
      Items[i].Free;
    FList.Free;
  end;
  inherited Destroy;
end;

function TmsNewsGroupList.Get(Index : Integer) : TmsNewsgroupItem;
begin
  Result:=FList[Index];
end;

procedure TmsNewsGroupList.Put(Index : Integer; Value : TmsNewsgroupItem);
begin
  FList[Index]:=Value;
end;

function TmsNewsGroupList.GetCount : Integer;
begin
  Result:=FList.Count;
end;

function TmsNewsGroupList.Add(Value : TmsNewsgroupItem) : Integer;
begin
  Result:=FList.Add(Value);
end;

procedure TmsNewsGroupList.Delete(Index: Integer);
begin
  Items[Index].Free;
  FList.Delete(Index);
end;

procedure TmsNewsGroupList.Clear;
var
  i : Integer;
begin
  for i:=Count-1 DownTo 0 do
    Items[i].Free;
  FList.Clear;
end;

procedure TmsNewsGroupList.SaveToStream(Stream : TStream);
var
  s : string;
  i : Integer;
begin
  Stream.Position:=0;
  for i:=0 to Count-1 do
  begin
    s:=Concat(Items[i].ToString,^M^J);
    Stream.Write(s[1],Length(s));
  end;
end;

procedure TmsNewsGroupList.SaveToFile(const FileName : string);
var
  FileStream : TFileStream;
begin
  FileStream:=TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

function TmsNewsGroupList.PickAPart(s : string; Position : Integer) : string;
var
  sp : Integer;
  i : Integer;
begin
  Result:=''; sp:=-1;
  for i:=1 to Position do
  begin
    sp:=Pos(' ',s);
    if sp<>0 then
    begin
      System.Delete(s,1,sp);
      s:=Trim(s);
    end
    else
    begin
      Result:='';
      Break;
    end;
  end;
  if sp<>0 then
  begin
    sp:=Pos(' ',s);
    if sp>0 then
      s:=Trim(Copy(s,1,sp-1))
    else
      s:=Trim(s);
    Result:=s;
  end;
end;

procedure TmsNewsGroupList.LoadFromStream(Stream : TStream);
var
  SL : TStrings;
  NG : TmsNewsgroupItem;
  i : Integer;
begin
  Stream.Position:=0;
  Clear;
  SL:=TStringList.Create;
  try
    SL.LoadFromStream(Stream);
    for i:=0 to SL.Count-1 do
    begin
      NG:=TmsNewsgroupItem.Create;
      NG.ParseString(SL[i]);
      Add(NG);
    end;
  finally
    SL.Free;
  end;
end;

procedure TmsNewsGroupList.LoadFromFile(const FileName : string);
var
  FileStream : TFileStream;
begin
  FileStream:=TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

{ TmsOverviewItem }

constructor TmsOverviewItem.Create(Fmt: TStringList);
var
  i: Integer;
begin
  inherited Create;
  FFmt:=TStringList.Create;
  for i:=0 to Fmt.Count-1 do
    FFmt.Add(LowerCase(Fmt[i]));
end;

destructor TmsOverviewItem.Destroy;
begin
  FFmt.Free;
  inherited Destroy;
end;

function TmsOverviewItem.PickMsgNo(const s: string): Integer;
const
  Tab=^I;
var
  i: Integer;
begin
  i:=Pos(Tab,s);
  if i>0 then
    Result:=StrToIntDef(Copy(s,1,i-1),-1)
  else
    Result:=-1;
end;

procedure TmsOverviewItem.ParseString(const s: string);
begin
  ArticleNo:=PickMsgNo(s);
  Subject:=PickData('Subject:',s);
  SplitAddress(PickData('From:',s),SenderAddress,SenderName);
  try
    MailDateToDateTime(PickData('Date:',s),Date,TimeZone);
  except
    Date:=Now;
    TimeZone:='';
  end;
  MessageID:=PickData('Message-ID:',s);
  References:=PickData('References:',s);
  Bytes:=StrToIntDef(PickData('Bytes:',s),-1);
  Lines:=StrToIntDef(PickData('Lines:',s),-1);
end;

function TmsOverviewItem.PickData(const Header, Data: string): string;
var
  i: Integer;
  SL: TStrings;
begin
  i:=FFmt.IndexOf(LowerCase(Header));
  if (i>-1) and (Length(Data)>0) then
  begin
    SL:=TStringList.Create;
    try
      StringToList(Data,SL);
      SL.Delete(0); // Remove the message number
      if i<SL.Count then
        Result:=SL[i]
      else
        Result:='';
    finally
      SL.Free;
    end;
  end
  else
    Result:='';
end;

{ TmsOverviewList }

constructor TmsOverviewList.Create;
begin
  inherited Create;
  FList:=TList.Create;
end;

destructor TmsOverviewList.Destroy;
var
  i: Integer;
begin
  for i:=FList.Count-1 DownTo 0 do
    Items[i].Free;
  FList.Free;
  inherited Destroy;
end;

procedure TmsOverviewList.Clear;
var
  i: Integer;
begin
  for i:=FList.Count-1 DownTo 0 do
    Items[i].Free;
  FList.Clear;
end;

function TmsOverviewList.Get(Index: Integer): TmsOverviewItem;
begin
  Result:=FList[Index];
end;

procedure TmsOverviewList.Put(Index: Integer; Value: TmsOverviewItem);
begin
  FList[Index]:=Value;
end;

function TmsOverviewList.GetCount: Integer;
begin
  Result:=FList.Count;
end;

function TmsOverviewList.Add(Value: TmsOverviewItem): Integer;
begin
  Result:=FList.Add(Value);
end;

{ TmsNNTPClient }
constructor TmsNNTPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Port:=119;
  FOverFmt:=TStringList.Create;
  FOverview:=TmsOverviewList.Create;
  FNewsgroupList:=TmsNewsgroupList.Create;
end;

destructor TmsNNTPClient.Destroy;
begin
  FNewsgroupList.Free;
  FOverview.Free;
  FOverFmt.Free;
  inherited Destroy;
end;

function TmsNNTPClient.GetServerReplyCode(const s: string): Integer;
begin
  Result:=StrToIntDef(Copy(s,1,3),-1);
end;

function TmsNNTPClient.SendLineHook(const Cmd: string): Integer;
var
  rs: Integer;
begin
  SendLine(Cmd);
  rs:=iRecvLine(TempS);
  if TempS='.' then
    rs:=iRecvLine(TempS);
  Result:=rs;
  if FAuthorization and ((rs = AuthRequest1) or (rs = AuthRequest2)) then
  begin
    SendLine('AUTHINFO USER ' + FUsername );
    rs:=iRecvLine(TempS);
    if (rs=381) then
    begin
      SendLine('AUTHINFO PASS ' + FPassword );
      rs:=iRecvLine(TempS);
      if (rs=281) or (rs=250) then
      begin
        SendLine(Cmd);
        rs:=iRecvLine(TempS);
        Result:=rs;
      end;
    end else
      Result:=rs;
  end;
end;

procedure TmsNNTPClient.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (AComponent=FArticle) then
    FArticle:=nil;
end;

function TmsNNTPClient.GetBOA: boolean;
begin
  Result:=FCurrentArticle=FFirstArticle;
end;

function TmsNNTPClient.GetEOA: boolean;
begin
  Result:=FCurrentArticle=FLastArticle;
end;

procedure TmsNNTPClient.SetCurrentArticle(Value: LongInt);
var
  rs: Integer;
begin
  rs:=SendLineHook(Concat('STAT ',IntToStr(Value)));
  if (rs>223) or (rs<220) then
    raise EmsServerError.Create(TempS);
  FCurrentArticle:=Value;
end;

procedure TmsNNTPClient.AuthLogin;
var
  rs: Integer;
begin
  Connect;
  rs:=iRecvLine(TempS);
  if (rs<>200) and (rs<>201) then
    raise EmsServerError.Create(TempS);
  SendLine('AUTHINFO USER ' + FUsername );
  rs:=iRecvLine(TempS);
  if rs<>381 then
    raise EmsServerError.Create(TempS);
  SendLine('AUTHINFO PASS ' + FPassword );
  rs:=iRecvLine(TempS);
  if (rs<>281) and (rs<>250) then
    raise EmsServerError.Create(TempS);
  XOverFmt;
end;

procedure TmsNNTPClient.Login;
var
  rs: Integer;
begin
  Connect;
  rs:=iRecvLine(TempS);
  if (rs<>200) and (rs<>201) then
    raise EmsServerError.Create(TempS);
  XOverFmt;
end;

procedure TmsNNTPClient.First;
begin
  CurrentArticle:=FFirstArticle;
end;

procedure TmsNNTPClient.Last;
begin
  CurrentArticle:=FLastArticle;
end;

procedure TmsNNTPClient.Next;
var
  rs: Integer;
begin
  rs:=SendLineHook('NEXT');
  if (rs<>421) and (rs<>223) then
    raise EmsServerError.Create(TempS);
  if rs=421 then { No next article in this group}
    FCurrentArticle:=FLastArticle
  else
    FCurrentArticle:=PickNumber(TempS,1);
end;

procedure TmsNNTPClient.Retrieve;
begin
  RetrieveArticleByID('');
end;

procedure TmsNNTPClient.Post;
var
  TempStream: TStream;
  rs: Integer;
begin
  TempStream:=TMemoryStream.Create;
  try
    rs:=SendLineHook('POST');
    if rs<>340 then
      raise EmsServerError.Create(TempS);
    Article.SaveToStream(TempStream);
    TempStream.Position:=0;
    SendStream(TempStream,0);
    SendLine('.');
    rs:=iRecvLine(TempS);
    if rs<>240 then
      raise EmsServerError.Create(TempS);
  finally
    TempStream.Free;
  end;
end;

procedure TmsNNTPClient.RetrieveHeaders;
var
  rs: Integer;
  TempStream: TStream;
  TempHeaders: TmsHeaders;
begin
  rs:=SendLineHook('HEAD');
  if (rs>223) or (rs<220) then
    raise EmsServerError.Create(TempS);
  TempStream:=TMemoryStream.Create;
  try
    RecvLineStream(TempStream,-1);
    TempStream.Position:=0;
    TempHeaders:=TmsHeaders.Create;
    try
      TempHeaders.LoadFromStream(TempStream);
      Article.ProcessHeaders(TempHeaders);
    finally
      TempHeaders.Free;
    end;
  finally
    TempStream.Free;
  end;
end;

function TmsNNTPClient.RetrieveHeader(const Header: string): string;
var
  rs: Integer;
  s: string;
  i: Integer;
begin
  rs:=SendLineHook(Concat('XHDR ',Header));
  if rs<>221 then
    raise EmsServerError.Create(TempS);
  s:=RecvLine;
  i:=Pos(' ',s);
  if i>0 then
    Result:=Copy(s,i+1,Length(s))
  else
    Result:='';
  RecvLine; {.}
end;

procedure TmsNNTPClient.RetrieveArticleByID(const ID: string);
var
  rs: Integer;
  TempStream: TStream;
  Size: LongInt;
  s: string;
begin
  rs:=SendLineHook(ConcatIfNotBlank('XHDR bytes',ID));
  if rs=221 then
  begin
    s:=RecvLine;
    if s<>'.' then
    begin
      Size:=PickNumber(s,1);
      RecvLine; {.}
    end
    else
      Size:=-1;
  end
  else
    Size:=-1;
  rs:=SendLineHook(ConcatIfNotBlank('ARTICLE',ID));
  if (rs>223) or (rs<220) then
    raise EmsServerError.Create(TempS);
  TempStream:=TMemoryStream.Create;
  try
    RecvLineStream(TempStream,Size);
    TempStream.Position:=0;
    FArticle.Clear;
    FArticle.LoadFromStream(TempStream);
  finally
    TempStream.Free;
  end;
end;

procedure TmsNNTPClient.RetrieveArticleByNumber(Number: LongInt);
begin
  RetrieveArticleById(IntToStr(Number));
end;

procedure TmsNNTPClient.Logout;
var
  rs: Integer;
begin
  rs:=SendLineHook('QUIT');
  if rs<>205 then
    raise EmsServerError.Create(TempS);
  Disconnect;
end;

procedure TmsNNTPClient.SetNewsgroup(const Value: string);
var
  rs: Integer;
begin
  rs:=SendLineHook('GROUP '+Value);
  if rs<>211 then
    raise EmsServerError.Create(TempS);
  FNewsgroup:=Value;
  FTotalArticles:=PickNumber(TempS,1);
  FFirstArticle:=PickNumber(TempS,2);
  FLastArticle:=PickNumber(TempS,3);
end;

procedure TmsNNTPClient.XOverFmt;
var
  rs: Integer;
  TempStream: TStream;
begin
  rs:=SendLineHook('LIST OVERVIEW.FMT');
  if rs<>215 then
    raise EmsServerError.Create(TempS);
  TempStream:=TMemoryStream.Create;
  try
    RecvLineStream(TempStream,-1);
    TempStream.Position:=0;
    FOverFmt.LoadFromStream(TempStream);
    FOverFmt.Delete(FOverFmt.Count-1);
  finally
    TempStream.Free;
  end;
end;

procedure TmsNNTPClient.GetOverview(FirstMsgNo, LastMsgNo: LongInt);
var
  rs: Integer;
  TempStream: TStream;
  s: string;
  SL: TStrings;
  i: Integer;
  OverItem: TmsOverviewItem;
begin
  if FOverFmt.Count<>0 then
  begin
    s:='';
    if (FirstMsgNo<>0) and (LastMsgNo<>0) then
      s:=Concat(IntToStr(FirstMsgNo),'-',IntToStr(LastMsgNo));
    rs:=SendLineHook(Concat('XOVER ',s));
    if rs<>224 then
      raise EmsServerError.Create(TempS);
    if Assigned(FOnOverviewItemRetrieved) then
    begin
      repeat
        s:=RecvLine;
        if s<>'.' then
        begin
          OverItem:=TmsOverviewItem.Create(FOverFmt);
          OverItem.ParseString(s);
          FOverview.Add(OverItem);
          FOnOverviewItemRetrieved(Self,OverItem);
        end;
      until s='.';
    end
    else
    begin
      TempStream:=TMemoryStream.Create;
      try
        RecvLineStream(TempStream,-1);
        TempStream.Position:=0;
        SL:=TStringList.Create;
        try
          SL.LoadFromStream(TempStream);
          SL.Delete(SL.Count-1);
          FOverview.Clear;
          for i:=0 to SL.Count-1 do
          begin
            OverItem:=TmsOverviewItem.Create(FOverFmt);
            OverItem.ParseString(SL[i]);
            FOverview.Add(OverItem);
          end;
        finally
          SL.Free;
        end;
      finally
        TempStream.Free;
      end;
    end;
  end
  else
    raise EmsServerError.Create('Extended commands not supported');
end;

procedure TmsNNTPClient.RetrieveNewsgroupList;
var
  rs: Integer;
  TempStream: TStream;
  NewsgroupItem: TmsNewsgroupItem;
  s: string;
begin
  FNewsGroupList.Clear;
  rs:=SendLineHook('LIST');
  if rs<>215 then
    raise EmsServerError.Create(TempS);
  if Assigned(FOnNewsgroupItemRetrieved) then
  begin
    repeat
      s:=RecvLine;
      if s<>'.' then
      begin
        NewsgroupItem:=TmsNewsgroupItem.Create;
        NewsgroupItem.ParseString(s);
        NewsgroupList.Add(NewsgroupItem);
        FOnNewsgroupItemRetrieved(Self,NewsgroupItem);
      end;
    until s='.';
  end
  else
  begin
    TempStream:=TMemoryStream.Create;
    try
      RecvLineStream(TempStream,-1);
      TempStream.Position:=0;
      FNewsGroupList.LoadFromStream(TempStream);
      FNewsGroupList.Delete(FNewsGroupList.Count-1);
    finally
      TempStream.Free;
    end;
  end;
end;

procedure TmsNNTPClient.RetrieveNewGroups(Since: TDateTime; const TimeZone: string);
var
  rs: Integer;
  TempStream: TStream;
  NewsgroupItem: TmsNewsgroupItem;
  s: string;
begin
  FNewsGroupList.Clear;
  s:=FormatDateTime('yymmdd hhmmss',Since);
  if TimeZone<>'' then s:=Concat(s,' ',TimeZone);
  rs:=SendLineHook('NEWGROUPS '+s);
  if rs<>231 then
    raise EmsServerError.Create(TempS);
  if Assigned(FOnNewsgroupItemRetrieved) then
  begin
    repeat
      s:=RecvLine;
      if s<>'.' then
      begin
        NewsgroupItem:=TmsNewsgroupItem.Create;
        NewsgroupItem.ParseString(s);
        NewsgroupList.Add(NewsgroupItem);
        FOnNewsgroupItemRetrieved(Self,NewsgroupItem);
      end;
    until s='.';
  end
  else
  begin
    TempStream:=TMemoryStream.Create;
    try
      RecvLineStream(TempStream,-1);
      TempStream.Position:=0;
      FNewsGroupList.LoadFromStream(TempStream);
      FNewsGroupList.Delete(FNewsGroupList.Count-1);
    finally
      TempStream.Free;
    end;
  end;
end;

procedure TmsNNTPClient.LoadNewsgroupList(const FileName: string);
begin
  FNewsgroupList.LoadFromFile(FileName);
end;

procedure TmsNNTPClient.SaveNewsgroupList(const FileName: string);
begin
  FNewsgroupList.SaveToFile(FileName);
end;

end.
