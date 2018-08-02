(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msmsgcls;

{$I msdef.inc}

{.$DEFINE A2D}

interface

uses Classes, SysUtils,
{$IFDEF VCL}
     Controls,
{$ENDIF}
     msCls;

type
{$IFNDEF WIN32}
  ShortString=string;
{$ENDIF}
  TmsEncoding = (etNone, etBase64, etQP); {Encoding types}
  TmsMsgEncoding = (meMIME, meUU);   {Global encoding types}
  TmsCharSet = (csUSASCII,csISO8859,csISO2022jp);  {Character Sets}
  TmsPriority = (ptLow,ptNormal,ptHigh);

const
  EncNames : array[TmsEncoding] of string = ('7 bit','Base64','Quoted-Printable');

type
{The Mail address}
  TmsMailAddress = class(TPersistent)
  private
    FName : ShortString;
    FAddress : ShortString;
  public
    procedure Assign(Source : TPersistent); override;
{$IFDEF VCL}
    procedure Edit; virtual;
{$ENDIF}
    procedure Clear;
  published
    property Name : ShortString read FName write FName;
    property Address : ShortString read FAddress write FAddress;
  end;

{List of Mail Addresses for Recipients, CC and BCC}
  TmsAddressList = class(TPersistent)
  private
    FList : TList;
    function GetItem(Index : Integer) : TmsMailAddress;
    procedure SetItem(Index : Integer; Value : TmsMailAddress);
    function GetCount : Integer;
    procedure ReadData(Reader : TReader);
    procedure WriteData(Writer : TWriter);
  protected
    procedure DefineProperties(Filer : TFiler); override;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Value : TmsMailAddress) : Integer;
    function AddAddress(const TheAddress, TheName : string) : Integer;
    procedure Clear;
    procedure Delete(Index : Integer);
    procedure Assign(Source : TPersistent); override;
    property Count : Integer read GetCount;
    property Items[Index : Integer] : TmsMailAddress read GetItem write SetItem;
             default;
  end;

{ Each Item of the TAttList}
  TmsAttItem = class(TPersistent)
  private
{$IFDEF A2D}
    FContents : TTempFileStream;
{$ELSE}
    FContents : TMemoryStream;
{$ENDIF}
    FFileName : ShortString;
    FContentType : ShortString;
    FContentTransferEncoding : TmsEncoding;
    procedure SetFileName(Value : ShortString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
{$IFDEF A2D}
    property Contents : TTempFileStream read FContents
                          write FContents;
{$ELSE}
    property Contents : TMemoryStream read FContents
                          write FContents;
{$ENDIF}
    property ContentType : ShortString read FContentType write FContentType;
    property ContentTransferEncoding : TmsEncoding read FContentTransferEncoding
                    write FContentTransferEncoding;
    property FileName : ShortString read FFileName write SetFileName;
  end;

{The list of attachments}
  TmsAttList = class(TPersistent)
  private
    FList : TList;
    function GetItem(Index : Integer) : TmsAttItem;
    procedure SetItem(Index : Integer; Value : TmsAttItem);
    function GetCount : Integer;
    procedure ReadData(Reader : TReader);
    procedure WriteData(Writer : TWriter);
  protected
    procedure DefineProperties(Filer : TFiler); override;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Value : TmsAttItem) : Integer;
    function AddFile(const FileName : string) : Integer;
    procedure Clear;
    procedure Delete(Index : Integer);
    procedure Assign(Source : TPersistent); override;
    procedure Exchange(Index1,Index2 : Integer);
    property Count : Integer read GetCount;
    property Items[Index : Integer] : TmsAttItem read GetItem write SetItem;
             default;
  end;

  TmsHeaders = class(TStringList)
  public
    function GetFieldBody(FieldName : string) : string;
    procedure RemoveXHeaders;
    procedure Remove(FieldName : string);
    procedure GetMultiLineFieldBody(FieldName : string; FieldBody : TStrings);
    function Contains(const ss : string; MatchCase : boolean) : boolean;
    function PickAddress(FieldName: string): string;
    procedure CleanUp;
  end;

  procedure PreprocessMultiLineAddressField(SL: TStrings);

implementation

{$IFDEF WIN32}
{$R msconst.res}
{$ELSE}
{$R mscons16.res}
{$ENDIF}

uses msUtils,
{$IFDEF VCL}
     msaddred,
{$ENDIF}
     msMIME;

{TmsMailAddress}
procedure TmsMailAddress.Assign(Source : TPersistent);
begin
  if Source is TmsMailAddress then
  begin
    FName:=(Source as TmsMailAddress).Name;
    FAddress:=(Source as TmsMailAddress).Address;
    Exit;
  end;
  inherited Assign(Source);
end;

{$IFDEF VCL}
procedure TmsMailAddress.Edit;
begin
  with TMailAddressDlg.Create(nil) do
  try
    MailAddress:=Self;
    if ShowModal=mrOk then
      Self.Assign(MailAddress);
  finally
    Free;
  end;
end;
{$ENDIF}

procedure TmsMailAddress.Clear;
begin
  FName:='';
  FAddress:='';
end;

{TmsAddressList}
constructor TmsAddressList.Create;
begin
  inherited Create;
  FList:=TList.Create;
end;

destructor TmsAddressList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TmsAddressList.GetItem(Index : Integer) : TmsMailAddress;
begin
  Result:=TmsMailAddress(FList.Items[Index]);
end;

procedure TmsAddressList.SetItem(Index : Integer; Value : TmsMailAddress);
var
  TempAddress : TmsMailAddress;
begin
  TempAddress:=FList[Index];
  TempAddress.Free;
  FList[Index]:=Value;
end;

function TmsAddressList.GetCount : Integer;
begin
  Result:=FList.Count;
end;

procedure TmsAddressList.WriteData(Writer : TWriter);
var
  i : Integer;
  TempAddress : TmsMailAddress;
begin
  Writer.WriteListBegin;
  for i:=0 to Count-1 do
  begin
    TempAddress:=GetItem(i);
    Writer.WriteString(TempAddress.Name);
    Writer.WriteString(TempAddress.Address);
  end;
  Writer.WriteListEnd;
end;

procedure TmsAddressList.ReadData(Reader : TReader);
var
  TempAddress : TmsMailAddress;
begin
  Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    TempAddress:=TmsMailAddress.Create;
    TempAddress.Name:=Reader.ReadString;
    TempAddress.Address:=Reader.ReadString;
    Add(TempAddress);
  end;
  Reader.ReadListEnd;
end;

procedure TmsAddressList.DefineProperties(Filer : TFiler);
begin
  Filer.DefineProperty('Items',ReadData,WriteData,Count>0);
end;

function TmsAddressList.Add(Value : TmsMailAddress) : Integer;
begin
  Result:=FList.Add(Value);
end;

function TmsAddressList.AddAddress(const TheAddress,TheName : string) : Integer;
var
  MA : TmsMailAddress;
begin
  MA:=TmsMailAddress.Create;
  MA.Address:=TheAddress;
  MA.Name:=TheName;
  Result:=Add(MA);
end;

procedure TmsAddressList.Clear;
var
  i : Integer;
begin
  for i:=FList.Count-1 DownTo 0 do
    Items[i].Free;
  FList.Clear;
end;

procedure TmsAddressList.Delete(Index : Integer);
begin
  Items[Index].Free;
  FList.Delete(Index);
end;

procedure TmsAddressList.Assign(Source : TPersistent);
var
  i : Integer;
  TempAddress : TmsMailAddress;
  AL : TmsAddressList;
begin
  if Source is TmsAddressList then
  begin
    AL:=Source as TmsAddressList;
    Clear;
    for i:=0 to AL.Count-1 do
    begin
      TempAddress:=TmsMailAddress.Create;
      TempAddress.Assign(AL[i]);
      Add(TempAddress);
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

{TmsAttItem}
constructor TmsAttItem.Create;
begin
  inherited Create;
{$IFDEF A2D}
  FContents:=TTempFileStream.Create;
{$ELSE}
  FContents:=TMemoryStream.Create;
{$ENDIF}
end;

destructor TmsAttItem.Destroy;
begin
  FContents.Free;
  inherited Destroy;
end;

procedure TmsAttItem.SetFileName(Value : ShortString);
begin
  FFileName:=Value;
  if FFileName<>'' then
  begin
    FContentType:=GetContentType(FFileName);
    if (UpperCase(FContentType)='TEXT/PLAIN') or
      (UpperCase(FContentType)='TEXT/RTF') or
      (UpperCase(FContentType)='TEXT/HTML') then
         FContentTransferEncoding:=etQP
    else
    if (UpperCase(FContentType)='MESSAGE/RFC822') then
         FContentTransferEncoding:=etNone
    else
      FContentTransferEncoding:=etBase64;
  end;
end;

procedure TmsAttItem.Assign(Source : TPersistent);
var
  AI : TmsAttItem;
begin
  if Source is TmsAttItem then
  begin
    AI:=Source as TmsAttItem;
    FContents.LoadFromStream(AI.Contents);
    FContentType:=AI.ContentType;
    FContentTransferEncoding:=AI.ContentTransferEncoding;
    FFileName:=AI.FileName;
    Exit;
  end;
  inherited Assign(Source);
end;

{TmsAttList}
constructor TmsAttList.Create;
begin
  inherited Create;
  FList:=TList.Create;
end;

destructor TmsAttList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TmsAttList.GetItem(Index : Integer) : TmsAttItem;
begin
  Result:=TmsAttItem(FList.Items[Index]);
end;

procedure TmsAttList.SetItem(Index : Integer; Value : TmsAttItem);
var
  AttItem : TmsAttItem;
begin
  AttItem:=FList[Index];
  AttItem.Free;
  FList[Index]:=Value;
end;

function TmsAttList.GetCount : Integer;
begin
  Result:=FList.Count;
end;

function TmsAttList.AddFile(const FileName : string) : Integer;
var
  TempItem : TmsAttItem;
begin
  TempItem:=TmsAttItem.Create;
  TempItem.FileName:=FileName;
  TempItem.Contents.LoadFromFile(FileName);
  Result:=Add(TempItem);
end;

procedure TmsAttList.ReadData(Reader : TReader);
var
  TempAttItem : TmsAttItem;
begin
  Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    TempAttItem:=TmsAttItem.Create;
    TempAttItem.FileName:=Reader.ReadString;
    TempAttItem.ContentType:=Reader.ReadString;
    TempAttItem.ContentTransferEncoding:=TmsEncoding(Reader.ReadInteger);
    Add(TempAttItem);
  end;
  Reader.ReadListEnd;
end;

procedure TmsAttList.WriteData(Writer : TWriter);
var
  i : Integer;
  TempAttItem : TmsAttItem;
begin
  Writer.WriteListBegin;
  for i:=0 to Count-1 do
  begin
    TempAttItem:=GetItem(i);
    Writer.WriteString(TempAttItem.FileName);
    Writer.WriteString(TempAttItem.ContentType);
    Writer.WriteInteger(Ord(TempAttItem.ContentTransferEncoding));
  end;
  Writer.WriteListEnd;
end;

procedure TmsAttList.DefineProperties(Filer : TFiler);
begin
  Filer.DefineProperty('Items',ReadData,WriteData,Count>0);
end;

function TmsAttList.Add(Value : TmsAttItem) : Integer;
begin
  Result:=FList.Add(Value);
end;

procedure TmsAttList.Clear;
var
  i : Integer;
begin
  for i:=FList.Count-1 DownTo 0 do
    Items[i].Free;
  FList.Clear;
end;

procedure TmsAttList.Delete(Index : Integer);
begin
  Items[Index].Free;
  FList.Delete(Index);
end;

procedure TmsAttList.Exchange(Index1, Index2 : Integer);
begin
  FList.Exchange(Index1,Index2);
end;

procedure TmsAttList.Assign(Source : TPersistent);
var
  i : Integer;
  AttItem : TmsAttItem;
  AL : TmsAttList;
begin
  if Source is TmsAttList then
  begin
    AL:=Source as TmsAttList;
    Clear;
    for i:=0 to AL.Count-1 do
    begin
      AttItem:=TmsAttItem.Create;
      AttItem.Assign(AL[i]);
      Add(AttItem);
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

{TmsHeader}
function TmsHeaders.GetFieldBody(FieldName : string) : string;
{Improved in v1.9}
var
  Found : boolean;
  i,j : Integer;
{$IFDEF DECODEHEADERS}
  Decode: boolean;
  ss: string;
{$ENDIF}
begin
  Result:='';
{$IFDEF DECODEHEADERS}
  Decode:=(UpperCase(FieldName)<>'CONTENT-TYPE')
    and (UpperCase(FieldName)<>'X-UIDL');
{$ENDIF}
  if Count=0 then exit;
  i:=-1;
  if FieldName[Length(FieldName)]<>':' then
    FieldName:=Concat(FieldName,':');
  repeat
    Inc(i);
    Found:=Pos(UpperCase(FieldName),UpperCase(Strings[i]))=1;
  until Found or (i=Count-1);
  if Found then
  begin
    Result:=Strings[i];
    j:=Pos(':',Result);
    System.Delete(Result,1,j+1);
    Result:=Trim(Result);
{$IFDEF DECODEHEADERS}
    if Decode then
      Result:=DecodeHeader(Result);
{$ENDIF}
    Inc(i);
    while (i<=Count-1) and ((Copy(Strings[i],1,1)=' ') or (Copy(Strings[i],1,1)=^I)) do
    begin
{$IFDEF DECODEHEADERS}
      ss:=Trim(Strings[i]);
      if Decode then
        ss:=DecodeHeader(ss);
      Result:=Concat(Result,' ',ss);
{$ELSE}
      Result:=Concat(Result,' ',Trim(Strings[i]));
{$ENDIF}
      Inc(i);
    end;
  end;
end;

procedure TmsHeaders.GetMultiLineFieldBody(FieldName : string; FieldBody : TStrings);
Label DoItAgain;
var
  i,j,k : Integer;
  QuoteOpen : boolean;
  s : string;
begin
  FieldBody.Clear;
  if Count=0 then Exit;
  i:=0;
  while i<=Count-1 do
  begin
    if Pos(UpperCase(FieldName),UpperCase(Strings[i]))=1 then {found!!!}
    begin
      s:=Strings[i];
{Remove the ID itself}
      j:=Pos(':',s);
      if j=0 then Break; {Something is wrong and just stop here}
      System.Delete(s,1,j+1);
     DoItAgain: { We will need to jump here if next line does not contain haeders}
 {Check for "s, 1.01b}
      j:=Pos('"',s);
      if (j>0)then
      begin
        QuoteOpen:=false;
        for k:=1 to Length(s) do
        begin
          if s[k]='"' then
            QuoteOpen:=not QuoteOpen;
          if (s[k]=',') and QuoteOpen then
            s[k]:=#255;
        end;
      end;
 {Look if there is comma inside}
      j:=Pos(',',s);
      while j<>0 do
      begin
{$IFDEF DECODEHEADERS}
        FieldBody.Add(DecodeHeader(Trim(Copy(s,1,j-1))));
{$ELSE}
        FieldBody.Add(Trim(Copy(s,1,j-1)));
{$ENDIF}
        System.Delete(s,1,j);
        j:=Pos(',',s);
      end;
      if s<>'' then
      begin
{$IFDEF DECODEHEADERS}
        s:=DecodeHeader(Trim(s));
{$ENDIF}
        FieldBody.Add(Trim(s));
      end;
{Check if the current section has continuation}
      Inc(i);
      if (i<=Count-1) then
      begin
        s:=Strings[i];
        if Pos(':',s)=0 then GoTo DoItAgain;
      end;
    end
    else
      Inc(i);
  end;
  for i:=0 to FieldBody.Count-1 do
  begin
    s:=FieldBody[i];
    for k:=1 to Length(s) do
      if s[k]=#255 then s[k]:=',';  {If there were quotes}
    FieldBody[i]:=s;
  end;
end;

procedure TmsHeaders.RemoveXHeaders;
{New in v1.7}
function XHeaderPosition : Integer;
var
  i : Integer;
  Found : boolean;
begin
  Result:=-1;
  if Count>0 then
  begin
    i:=-1;
    repeat
      Inc(i);
      Found:=Pos('X-',UpperCase(Strings[i]))=1;
    until Found or (i>=Count-1);
    if Found then Result:=i;
  end;
end;
var
  j : Integer;
begin
  while XHeaderPosition<>-1 do
  begin
    j:=XHeaderPosition;
    Delete(j);
    while (Count>j) and (Pos(' ',Strings[j])=1) or (Pos(^I,Strings[j])=1) do
      Delete(j);
  end;
end;

procedure TmsHeaders.Remove(FieldName : string);
var
  i : Integer;
  Found : boolean;
begin
  if Count>0 then
  begin
    if FieldName[Length(FieldName)]<>':' then
      FieldName:=Concat(FieldName,':');
    i:=-1;
    repeat
      Inc(i);
      Found:=Pos(UpperCase(FieldName),UpperCase(Strings[i]))=1;
    until Found or (i>=Count-1);
    if Found then
    begin
      Delete(i);
      while (Count>i) do
        if (Pos(' ',Strings[i])=1) or (Pos(^I,Strings[i])=1) then
          Delete(i)
        else
          Break;
    end;
  end;
end;

function TmsHeaders.Contains(const ss : string; MatchCase : boolean) : boolean;
var
  i : Integer;
begin
  i:=0;
  repeat
    if MatchCase then
      Result:=Pos(ss,Strings[i])<>0
    else
      Result:=Pos(UpperCase(ss),UpperCase(Strings[i]))<>0;
    Inc(i);
  until Result or (i<=Count-1);
end;

procedure TmsHeaders.CleanUp;
var
  i : Integer;
begin
  i:=IndexOf('');
  if (i<>-1) then
  repeat
    Delete(Count-1);
  until (Count=i);
end;

function TmsHeaders.PickAddress(FieldName: string): string;
var
  TempS, Addr, Name: string;
begin
  try
    TempS:=GetFieldBody(FieldName);
    SplitAddress(TempS,Addr,Name);
    Result:=Addr;
  except
    Result:='';
  end;
end;

procedure PreprocessMultiLineAddressField(SL: TStrings);
var
  TempSL: TStrings;
  i, Len: Integer;
  Done: boolean;
  s: string;
begin
  EXIT;
  TempSL:=TStringList.Create;
  try
    i:=0;
    Done:=false;
    while not Done do
    begin
      if i>=SL.Count-1 then
      begin
        TempSL.Add(Trim(SL[i]));
        Done:=true;
      end
      else
      begin
        s:=Trim(SL[i]);
        Len:=Length(s);
        if s[Len]='>' then
        begin
          TempSL.Add(s);
          Inc(i);
        end
        else
        begin
          Inc(i);
          if i<SL.Count then
          begin
            s:=Concat(s,' ',Trim(SL[i]));
            Len:=Length(s);
            if s[Len]='>' then
              Inc(i);
            TempSL.Add(s);
          end;
          if i>=SL.Count then
            Done:=true;
        end;
      end;
    end;
    SL.Assign(TempSL);
  finally
    TempSL.Free;
  end;
end;

end.
