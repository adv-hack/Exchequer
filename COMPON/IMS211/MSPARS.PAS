(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit mspars;

{$I msDef.inc}

interface

uses Classes, SysUtils,
{$IFDEF VCL}
     Dialogs, Forms,
{$ENDIF}
     msMsg, msMsgCls, msUtils, msCls, msMime, msUUCode, msConst;

type
  TmsCustomDecoder = class
  private
    { Private declarations }
    FInStream : TLineStream;
    FGlobalHeaders : TmsHeaders;
    FLocalHeaders : TmsHeaders;
    FMailMessage : TmsCustomMessage;
    FBoundary : string;
  protected
    { Protected declarations }
    QP : TQuotedPrintable;
    IsAltSection : boolean; {  These variables used for the}
    SaveBoundary : string;  {  multipart/alternative stuff}
    IsAlternative : boolean; { true if pure miltipart/alternative}
    procedure FillHeaders(Headers : TStrings);
    procedure ProcessError(const ErrMsg : string);
    procedure ProcessHeaders; virtual; abstract;
    procedure ProcessBody;
    procedure ProcessAttachments;
    procedure ProcessMultiPartMessage;
    procedure ProcessFileMessage;
    procedure ProcessSinglePartMessage;
    procedure ProcessMIMEMessage;
    procedure ProcessAlternativeMessage;
    procedure ProcessNotMIMEMessage;
    procedure Error(Ident : word);
    procedure RemoveTrailingDot;
  public
    { Public declarations }
    constructor Create(InStream : TStream);
    destructor Destroy; override;
    procedure Process;
    property MailMessage : TmsCustomMessage read FMailMessage write FMailMessage;
  end;

  TmsMessageDecoder = class(TmsCustomDecoder)
  protected
    procedure ProcessHeaders; override;
  end;

  TmsArticleDecoder = class(TmsCustomDecoder)
  protected
    procedure ProcessHeaders; override;
  end;

  TmsCustomEncoder = class
  private
    { Private declarations }
    FInMessage : TmsCustomMessage;
    FStream : TStream;
  protected
    { Protected declarations }
    TempLines : TStringList;
    QP : TQuotedPrintable;
    HasLongStrings : boolean;
    function MakeUniqueID : string;
    procedure FilterHeaders;
    procedure PrepareBody;
    procedure PrepareAnAttachment(Att : TmsAttItem);
    procedure PrepareGlobalHeaders; virtual; abstract;
    procedure PrepareMultipartMessage(IsAlternative : boolean);
    procedure PrepareTextPlainMessage;
    procedure PrepareFileMessage;
    procedure PrepareFancyMessage;
    procedure PrepareUUEncodedMessage; {1.2}
    procedure ListHeadersToStream(const ID : string; List : TmsAddressList);
    procedure StringToStream(const s : string);
  public
    { Public declarations }
    constructor Create(InMessage : TmsCustomMessage);
    procedure Process;
    property TheStream : TStream read FStream write FStream;
  end;

  TmsMessageEncoder = class(TmsCustomEncoder)
  protected
    procedure PrepareGlobalHeaders; override;
  end;

  TmsArticleEncoder = class(TmsCustomEncoder)
  protected
    procedure PrepareGlobalHeaders; override;
  end;

  EMessageParserError = class(Exception);

const
  ForceBCC : boolean = false;

implementation

{TmsCustomDecoder}
constructor TmsCustomDecoder.Create(InStream : TStream);
begin
  inherited Create;
  FGlobalHeaders:=TmsHeaders.Create;
  FLocalHeaders:=TmsHeaders.Create;
  FInStream:=TLineStream.Create;
  FInStream.LoadFromStream(InStream);
  FInStream.Reset;
  IsAlternative:=false;
end;

destructor TmsCustomDecoder.Destroy;
begin
  FInStream.Free;
  FLocalHeaders.Free;
  FGlobalHeaders.Free;
  inherited Destroy;
end;

procedure TmsCustomDecoder.FillHeaders(Headers : TStrings);
var
  Done : boolean;
  s : string;
begin
  Headers.Clear;
  repeat
    s:=FInStream.GetNextLine;
    Done:=(s='') or (s=BadString) or FInStream.EOS;
    if not Done then
      Headers.Add(s);
  until Done;
  if (s=BadString) and (not FInStream.EOS) then
    Error(msSUnableToRetrieveHeaders);
end;

procedure TmsCustomDecoder.Error(Ident : word);
begin
  raise EMessageParserError.CreateRes(Ident);
end;

procedure TmsCustomDecoder.ProcessError(const ErrMsg : string);
var
  Att : TmsAttItem;
begin
  FMailMessage.Body.Add('The following error has been occured while processing the message:');
  FMailMessage.Body.Add(ErrMsg);
  FMailMessage.Body.Add('The original message will be stored as an attachment');
  Att:=TmsAttItem.Create;
  try
    Att.FileName:='original.eml';
    Att.ContentTransferEncoding:=etNone;
    Att.ContentType:='message/rfc822';
    FInStream.Position:=0;
    Att.Contents.LoadFromStream(FInStream);
    FMailMessage.Attachments.Add(Att);
  except
    Att.Free;
  end;
end;

{Eudora Pro appears to use x-uuencoded content-type encoding,
 we will treat this content type as Base64 but decode data using
 UUCode. EudoraUU=true if this is a case}

procedure TmsCustomDecoder.ProcessAttachments;
var
  Done,LastDone : boolean;
  Att : TmsAttItem;
  s,s1 : ShortString;
  TempLines : TStringList;
  SaveEncoding : TmsEncoding;
  SaveContentType : string;
  EudoraUU : boolean;
begin
  if FInStream.EOS then Exit;
  EudoraUU:=false;
  LastDone:=false;
  repeat
{$IFDEF VCL}
    Application.ProcessMessages;
{$ENDIF}
{if there was no body and we exited}
    if (FMailMessage.Body.Count<>0) or (FMailMessage.Attachments.Count>0) then
    begin
      FLocalHeaders.Clear;
      FillHeaders(FLocalHeaders);
    end;
    Att:=TmsAttItem.Create;
    s:=FLocalHeaders.GetFieldBody('Content-type');
    if s='' then
      {Error(msSMissingContentType);}
      s:='text/plain';
    Att.ContentType:=GetFirstPart(s);
    Att.FileName:=GetParameter('name',s);
    s:=FLocalHeaders.GetFieldBody('Content-Transfer-Encoding');
    if (LowerCase(s)='base64') or (Pos('x-uue',LowerCase(s))=1) then {See note above}
    begin
      EudoraUU:=(Pos('x-uue',LowerCase(s))=1);
      Att.ContentTransferEncoding:=etBase64
    end
    else
    if LowerCase(s)='quoted-printable' then
      Att.ContentTransferEncoding:=etQP
    else
      Att.ContentTransferEncoding:=etNone;
    if Att.FileName='' then
    begin
      s:=FLocalHeaders.GetFieldBody('Content-Disposition');
      SaveEncoding:=Att.ContentTransferEncoding;
      Att.FileName:=GetParameter('filename',s);
      Att.ContentTransferEncoding:=SaveEncoding;
{If still, no filename}
      if Att.FileName='' then
      begin
        SaveContentType:=Att.ContentType;
        SaveEncoding:=Att.ContentTransferEncoding;
        if IsAltSection or IsAlternative then
          Att.FileName:=Concat('_alt.',IntToStr(FMailMessage.Attachments.Count))
        else
          Att.FileName:=Concat('att.',IntToStr(FMailMessage.Attachments.Count));
        Att.ContentTransferEncoding:=SaveEncoding;
        if SaveContentType<>'' then
          Att.ContentType:=SaveContentType;
      end;
    end;
    try
      if Att.ContentTransferEncoding=etBase64 then
      begin
        repeat
          s:=FInStream.GetNextLine;
          Done:=(Copy(s,1,Length(FBoundary))=FBoundary) or FInStream.EOS;
          if (not Done) and (s<>'') then
          begin
            if EudoraUU then
            begin
            {ignoring lines "begin 600 filename", "`", "end"}
              if (not IsUUCodeStart(s)) and (s<>'`') and (s<>'end') then
                UUMakeBinData(s,s1) else s1:='';
            end
            else
              MakeBinData(s,s1);
            Att.Contents.Write(s1[1],Length(s1));
          end;
        until Done;
      end
      else
      if Att.ContentTransferEncoding=etQP then
      begin
{Quoted Printable}
        TempLines:=TStringList.Create;
        try
          repeat
            s:=FInStream.GetNextLine;
            Done:=(Copy(s,1,Length(FBoundary))=FBoundary) or FInStream.EOS;
            if not Done then
              TempLines.Add(s);
          until Done;
          QP:=TQuotedPrintable.Create(Att.Contents,TempLines);
          try
            QP.Decode;
          finally
            QP.Free;
          end;
        finally
          TempLines.Free;
        end;
      end
      else
      begin
{Save as is}
        repeat
          s:=FInStream.GetNextLine;
          Done:=(Copy(s,1,Length(FBoundary))=FBoundary) or FInStream.EOS;
          if not Done then
          begin
            s:=Concat(s,^M^J);
            Att.Contents.Write(s[1],Length(s));
          end;
        until Done;
      end;
(* taken out because of bug in Pegasus 2.23, which does not put boundary
   also added or part in see also LastDone:=... below
     if FInStream.EOF then
        Error(msSMissingClosingBoundary);
*)
      FMailMessage.Attachments.Add(Att);
      LastDone:=(s=Concat(FBoundary,'--')) or FInStream.EOS;
      if LastDone and IsAltSection then
      begin
        LastDone:=false;
        IsAltSection:=false;
        FBoundary:=SaveBoundary;
        repeat
          s:=FInStream.GetNextLine;
          Done:=(Copy(s,1,Length(FBoundary))=FBoundary) or FInStream.EOS;
        until Done;
        if FInStream.EOS then
          Error(msSMissingClosingBoundary);
      end;
    except
      on EMessageParserError do
      begin
        Att.Free;
        raise
      end
      else
      begin
        Att.Free;
        Error(msSErrorDecoding);
      end;
    end;
  until LastDone;
end;

procedure TmsCustomDecoder.ProcessBody;
var
  s : string;
  s1,s2 : ShortString;
  IsQP,IsBase64,Done : boolean;
  TempStream : TMemoryStream;
begin
{Now fill the message body}
  Done:=false;
  FLocalHeaders.Clear;
  FillHeaders(FLocalHeaders);
  s:=FLocalHeaders.GetFieldBody('Content-Disposition');
  if Pos('attachment',LowerCase(s))>0 then
  begin
    Exit;
  end;
  s:=FLocalHeaders.GetFieldBody('Content-Type');
  s1:=GetParameter('CharSet',s);
  if LowerCase(s1)='iso-2022-jp' then
    FMailMessage.CharSet:=csISO2022jp;
  IsAltSection:=Pos('multipart/alternative',LowerCase(s))>0;
  if IsAltSection then
  begin
    SaveBoundary:=FBoundary;
    FBoundary:=GetParameter('boundary',s);
    FBoundary:=Concat('--',FBoundary);
    repeat
      s1:=FInStream.GetNextLine;
      Done:=(s1=FBoundary) or FInStream.EOS;
    until Done;
    if FInStream.EOS then
      Error(msSMissingBoundary);
    FLocalHeaders.Clear;
    FillHeaders(FLocalHeaders);
  end;
  s:=FLocalHeaders.GetFieldBody('Content-Transfer-Encoding');
  if (LowerCase(s)<>'base64') or (FMailMessage.CharSet=csISO2022jp) then
  begin
    FMailMessage.Body.Clear;
    IsQP:=LowerCase(s)='quoted-printable';
    IsBase64:=LowerCase(s)='base64';
    if IsQP then
      FMailMessage.CharSet:=csISO8859;
    if not IsBase64 then
    repeat
      s:=FInStream.GetNextLine;
      Done:=(s=FBoundary) or (s=FBoundary+'--') or FInStream.EOS;
      if not Done then
        FMailMessage.Body.Add(s);
    until Done;
    if Done and (FMailMessage.Body.Count=0) then
      FMailMessage.Body.Add('');
    if IsQP then
    begin
      TempStream:=TMemoryStream.Create;
      try
        QP:=TQuotedPrintable.Create(TempStream,FMailMessage.Body);
        try
          QP.Decode;
          TempStream.Position:=0;
          FMailMessage.Body.LoadFromStream(TempStream);
        finally
          QP.Free;
        end;
      finally
        TempStream.Free;
      end;
    end
    else
    if IsBase64 then
    begin
      TempStream:=TMemoryStream.Create;
      try
        repeat
          s1:=FInStream.GetNextLine;
          Done:=(Copy(s1,1,Length(FBoundary))=FBoundary) or FInStream.EOS;
          if (not Done) and (s1<>'') then
          begin
            MakeBinData(s1,s2);
            TempStream.Write(s2[1],Length(s2));
          end;
        until Done;
        TempStream.Position:=0;
        FMailMessage.Body.LoadFromStream(TempStream);
      finally
        TempStream.Free;
      end;
    end;
    if s=FBoundary+'--' then
    begin
      s1:=FLocalHeaders.GetFieldBody('Content-Type');
      FMailMessage.ContentType:=GetFirstPart(s1);
      repeat
        FInStream.GetNextLine;
      until FInStream.EOS;
    end
    else
    if FInStream.EOS then
      Error(msSMissingBoundary);
  end
  else
{if Base64, i.e. there is no body add back this field}
    FLocalHeaders.Add('Content-Transfer-Encoding: Base64');
end;

procedure TmsCustomDecoder.ProcessMultipartMessage;
var
  s : string;
  Done : boolean;
begin
  s:=FGlobalHeaders.GetFieldBody('Content-Type');
  FBoundary:=GetParameter('Boundary',s);
  FBoundary:=Concat('--',FBoundary);
{Find the boundary}
  repeat
    s:=FInStream.GetNextLine;
    Done:=(s=FBoundary) or FInStream.EOS;
  until Done;
  if FInStream.EOS then
    Error(msSMissingBoundary);
  ProcessBody;
  ProcessAttachments;
end;

procedure TmsCustomDecoder.ProcessFileMessage;
var
  Att : TmsAttItem;
  s,s1 : ShortString;
  s2 : string;
  Done : boolean;
  TempLines : TStringList;
  EudoraUU : boolean;
  SaveEncoding : TmsEncoding;
  SaveContentType : string;
begin
  EudoraUU:=false;
  Att:=TmsAttItem.Create;
  try
    s:=FGlobalHeaders.GetFieldBody('Content-type');
    if s='' then
      Error(msSMissingContentType);
    SaveContentType:=GetFirstPart(s);
    Att.ContentType:=s;
    Att.FileName:=GetParameter('name',s);
    Att.ContentType:=SaveContentType;
    s:=FGlobalHeaders.GetFieldBody('Content-Transfer-Encoding');
    if (LowerCase(s)='base64') or (Pos('x-uue',LowerCase(s))=1) then {See note at ProcessAttachments}
    begin
      EudoraUU:=(Pos('x-uue',LowerCase(s))=1);
      Att.ContentTransferEncoding:=etBase64
    end
    else
    if LowerCase(s)='quoted-printable' then
      Att.ContentTransferEncoding:=etQP
    else
      Att.ContentTransferEncoding:=etNone;
    if Att.FileName='' then
    begin
      SaveEncoding:=Att.ContentTransferEncoding;
      s:=FLocalHeaders.GetFieldBody('Content-Disposition');
      Att.FileName:=GetParameter('filename',s);
{if still, no filename}
      if Att.FileName='' then
        Att.FileName:=Concat('att.',IntToStr(FMailMessage.Attachments.Count));
      Att.ContentTransferEncoding:=SaveEncoding;
      Att.ContentType:=SaveContentType;
    end;
    if Att.ContentTransferEncoding=etBase64 then
    begin
      repeat
        s:=FInStream.GetNextLine;
        Done:=FInStream.EOS or (s='.');
        if (not Done) and (s<>'') then
        begin
            if EudoraUU then
            begin
            {ignoring lines "begin 600 filename", "`", "end"}
              if (not IsUUCodeStart(s)) and (s<>'`') and (s<>'end') then
                UUMakeBinData(s,s1) else s1:='';
            end
            else
              MakeBinData(s,s1);
          Att.Contents.Write(s1[1],Length(s1));
        end;
      until Done;
    end
    else
    if Att.ContentTransferEncoding=etQP then
    begin
{Quoted Printable}
      TempLines:=TStringList.Create;
      try
        repeat
          s:=FInStream.GetNextLine;
          Done:=FInStream.EOS;
          if not Done then
            TempLines.Add(s);
        until Done;
        QP:=TQuotedPrintable.Create(Att.Contents,TempLines);
        try
          QP.Decode;
        finally
          QP.Free;
        end;
      finally
        TempLines.Free;
      end;
    end
    else
    begin
{Save as is}
      repeat
        s2:=FInStream.GetNextLine;
        Done:=FInStream.EOS;
        if not Done then
        begin
          s2:=Concat(s2,^M^J);
          Att.Contents.Write(s2[1],Length(s2));
        end;
      until Done;
    end;
{    if FInStream.EOF then
      Error(msSMissingClosingBoundary);}
    FMailMessage.Attachments.Add(Att);
  except
    on EMessageParserError do
    begin
      Att.Free;
      raise
    end
    else
    begin
      Att.Free;
      Error(msSErrorDecoding);
    end;
  end;
end;

procedure TmsCustomDecoder.ProcessSinglePartMessage;
var
  s : string;
  s1,s2 : ShortString;
  TempStream : TMemoryStream;
  IsQP : boolean;
  IsBase64 : boolean;
  Done, IsUUCode : boolean;
begin
  IsUUCode:=false;
  s:=FGlobalHeaders.GetFieldBody('Content-Type');
  s1:=GetFirstPart(s);
  if LowerCase(s1)='text/html' then
    FMailMessage.ContentType:='text/html'
  else
  if LowerCase(s1)='text/rtf' then
    FMailMessage.ContentType:='text/rtf';
  s1:=GetParameter('CharSet',s);
  s:=FGlobalHeaders.GetFieldBody('Content-Transfer-Encoding');
  FMailMessage.Body.Clear;
  IsQP:=LowerCase(s)='quoted-printable';
  IsQP:=IsQP or (Pos('quoted-printable',FGlobalHeaders.GetFieldBody('X-MIME-Autoconverted'))>0);
  IsBase64:=LowerCase(s)='base64';
  if LowerCase(s1)='iso-2022-jp' then
    FMailMessage.CharSet:=csISO2022jp;
  if IsQP then
    FMailMessage.CharSet:=csISO8859;
  if not IsBase64 then
  begin
    repeat
      s:=FInStream.GetNextLine;
      if IsUUCodeStart(s) then
        IsUUCode:=true;           {Another violation of rules - MIME contains UUCode}
      if not FInStream.EOS then
        FMailMessage.Body.Add(s);
    until FInStream.EOS or IsUUCode;
  end;
  if IsUUCode then  {Reset everything and process not MIME message - comments above}
  begin
    FInStream.Reset;
    FMailMessage.Body.Clear;
    FGlobalHeaders.Clear;
    FillHeaders(FGlobalHeaders);
    ProcessHeaders;
    {If this kind of message pretends that it is MIME, remove MIME
     related headers, since it actually is _not_ MIME}
    FGlobalHeaders.Remove('MIME-VERSION');
    FGlobalHeaders.Remove('CONTENT-TYPE');
    FGlobalHeaders.Remove('CONTENT-TRANSFER-ENCODING');
    ProcessNotMIMEMessage;
    Exit;
  end;
  if IsQP then
  begin
    TempStream:=TMemoryStream.Create;
    try
      QP:=TQuotedPrintable.Create(TempStream,FMailMessage.Body);
      try
        QP.Decode;
        TempStream.Position:=0;
        FMailMessage.Body.LoadFromStream(TempStream);
      finally
        QP.Free;
      end;
    finally
      TempStream.Free;
    end;
  end
  else
  if IsBase64 then
  begin
    TempStream:=TMemoryStream.Create;
    try
      repeat
        s1:=FInStream.GetNextLine;
        Done:=FInStream.EOS;
        if (not Done) and (s1<>'') then
        begin
          MakeBinData(s1,s2);
          TempStream.Write(s2[1],Length(s2));
        end;
      until Done;
      TempStream.Position:=0;
      FMailMessage.Body.LoadFromStream(TempStream);
    finally
      TempStream.Free;
    end;
  end;
end;

procedure TmsCustomDecoder.ProcessAlternativeMessage;
var
  TempS : string;
begin
  TempS:=FGlobalHeaders.GetFieldBody('Content-Type');
  FBoundary:=GetParameter('Boundary',TempS);
  IsAlternative:=true;
  ProcessMultiPartMessage;
end;

procedure TmsCustomDecoder.ProcessMIMEMessage;
var
  TempS : string;
begin
  TempS:=FGlobalHeaders.GetFieldBody('X-Mailer');
  if TempS='V Mailsystem R #0001' then
    FGlobalHeaders.Remove('Content-Type');
  TempS:=FGlobalHeaders.GetFieldBody('Content-type');
  if (Pos('multipart/alternative',LowerCase(TempS))<>0) then
  begin
    ProcessAlternativeMessage
  end
  else
  if (Pos('multipart',LowerCase(TempS))<>0) then
  begin
    ProcessMultiPartMessage
  end
  else
  if (TempS='') or (Pos('text/',LowerCase(TempS))>0) then {1.2}
  begin
    if (GetParameter('name',TempS)<>'') and
      (GetParameter('name',TempS)<>'cc:Mail') then ProcessFileMessage {1.2}
      else ProcessSinglePartMessage
  end
  else
  begin
    ProcessFileMessage;
  end;
end;

procedure TmsCustomDecoder.ProcessNotMIMEMessage;
{ Version 1.2 - added UUDecode}
var
  s : string;
procedure UUDecodeData;
var
  Att : TmsAttItem;
  Done : boolean;
  s1 : ShortString;
begin
  repeat
    Att:=TmsAttItem.Create;
    try
      Att.FileName:=UUPickFileName(s);
      if Att.FileName='' then
        Att.FileName:=Concat('att.',IntToStr(FMailMessage.Attachments.Count));
      repeat
        s:=FInStream.GetNextLine;
        Done:=(s='`') or (UpperCase(s)='END') or FInStream.EOS;
        if (not Done) and (s<>'') then
        begin
          UUMakeBinData(s,s1);
          Att.Contents.Write(s1[1],Length(s1));
        end;
      until Done;
      FMailMessage.Attachments.Add(Att);
      repeat
        s:=FInStream.GetNextLine;
      until FInStream.EOS or IsUUCodeStart(s);
    except
      Att.Free;
      Error(msSErrorDecoding);
    end;
  until FInStream.EOS;
end;
begin
  repeat
    s:=FInStream.GetNextLine;
    if not FInStream.EOS and IsUUCodeStart(s) then  {Assuming there is nothing else to add to body}
    begin
      UUDecodeData;
      FMailMessage.Encoding:=meUU;
    end;
    if not FInStream.EOS then
      FMailMessage.Body.Add(s);
  until FInStream.EOS;
end;

procedure TmsCustomDecoder.RemoveTrailingDot; {1.9.1}
begin
  with FMailMessage.Body do
  begin
    if (Count>0) and (Strings[Count-1]='.') then
      Delete(Count-1);
  end;
end;

procedure TmsCustomDecoder.Process;
begin
  FillHeaders(FGlobalHeaders);
  ProcessHeaders;
  try
    if Pos('1.0',FGlobalHeaders.GetFieldBody('MIME-VERSION'))=0 then
      ProcessNotMIMEMessage
    else
      ProcessMIMEMessage;
  except
    on E:EMessageParserError do
      ProcessError(E.Message);
    else
      raise;
  end;
  RemoveTrailingDot;
end;

{TmsMessageDecoder}
procedure TmsMessageDecoder.ProcessHeaders;
begin
  (FMailMessage as TmsMessage).ProcessHeaders(FGlobalHeaders);
end;

{TmsArticleDecoder}
procedure TmsArticleDecoder.ProcessHeaders;
begin
  (FMailMessage as TmsArticle).ProcessHeaders(FGlobalHeaders);
end;

{TmsCustomEncoder}
constructor TmsCustomEncoder.Create(InMessage : TmsCustomMessage);
var
  i : Integer;
begin
  inherited Create;
  FInMessage:=InMessage;
{if body contains long strings (>255) then use quoted printable
At the same time, if there is '.' on the blank line,
replace it by '..';}
  HasLongStrings:=false;
  for i:=0 to FInMessage.Body.Count-1 do
  begin
    HasLongStrings:=HasLongStrings or (Length(FInMessage.Body[i])>255);
    if FInMessage.Body[i]='.' then
      FInMessage.Body[i]:='..';
  end;
end;

procedure TmsCustomEncoder.PrepareBody;
var
  TempStream : TMemoryStream;
  s,s1 : ShortString;
  sLen : byte absolute s;
  s1Len : byte absolute s1;
begin
  if (FInMessage.CharSet=csISO8859) or HasLongStrings then
  begin
    TempStream:=TMemoryStream.Create;
    FInMessage.Body.SaveToStream(TempStream);
    TempStream.Position:=0;
    QP:=TQuotedPrintable.Create(TempStream,TempLines);
    try
      QP.Encode;
    finally
      QP.Free;
      TempStream.Free;
    end;
  end
(*
  else
  if (FInMessage.CharSet=csISO2022jp) then
  begin
    TempStream:=TMemoryStream.Create;
    FInMessage.Body.SaveToStream(TempStream);
    TempStream.Position:=0;
    repeat
      sLen:=TempStream.Read(s[1],57);
      MakeTextData(s,s1);
      TempLines.Add(s1);
    until sLen<57;
  end
*)
  else
    TempLines.Assign(FInMessage.Body);
end;

function TmsCustomEncoder.MakeUniqueID : string;
var
  i,j : Integer;
begin
  for j:=0 to 100 do
  begin
    Randomize;
{$IFDEF VCL}
    Application.ProcessMessages;
{$ENDIF}
  end;
  j:=Random(30);
  for i:=0 to j do
  begin
    Randomize;
{$IFDEF VCL}
    Application.ProcessMessages;
{$ENDIF}
  end;
  Result:='';
  for i:=1 to 8 do
    Result:=Concat(Result,IntToStr(Random(9)));
end;

procedure TmsCustomEncoder.FilterHeaders;
{Remove from headers the fields we are supplying}
begin
  with FInMessage.Headers do
  begin
    Remove('From');
    Remove('To');
    Remove('CC');
    Remove('BCC');
    Remove('Return-Receipt-To');
    Remove('X-Priority');
    Remove('Subject');
    Remove('Mime-Version');
    Remove('Content-Type');
    Remove('X-Encoding');
    Remove('Content-Transfer-Encoding');
  end;
end;

procedure TmsCustomEncoder.PrepareAnAttachment(Att : TmsAttItem);
var
  s,s1 : ShortString;
  sLen : byte absolute s;
  s1Len : byte absolute s1;
  i : Integer;
begin
  if Att.ContentTransferEncoding=etBase64 then
  begin
{Base64}
    with Att.Contents do
    begin
      Position:=0;
      repeat
        sLen:=Read(s[1],57);
        MakeTextData(s,s1);
        StringToStream(s1);
      until sLen<57;
    end;
  end
  else
  if Att.ContentTransferEncoding=etQP then
  begin
{Quoted printable}
    TempLines:=TStringList.Create;
    try
      QP:=TQuotedPrintable.Create(Att.Contents,TempLines);
      try
        QP.Encode;
      finally
        QP.Free;
      end;
      for i:=0 to TempLines.Count-1 do
        StringToStream(TempLines[i]);
    finally
      TempLines.Free;
    end;
  end
  else
  begin
    TempLines:=TStringList.Create;
    try
      Att.Contents.Position:=0;
      TempLines.LoadFromStream(Att.Contents);
      for i:=0 to TempLines.Count-1 do
        StringToStream(TempLines[i]);
    finally
      TempLines.Free;
    end;
  end;
end;

procedure TmsCustomEncoder.PrepareMultipartMessage(IsAlternative : boolean);
var
  i : Integer;
  UniqueID, SaveUniqueID : string;
  s : string;
  IsAltSection : boolean;
  IsRTFBody : boolean;
  IsHTMLBody : boolean;
begin
  with FInMessage do
  begin
    IsHTMLBody:=(Attachments.Count>0) and (Body.Count=0) and
      (LowerCase(ExtractFileName(Attachments[0].FileName))='_htmbody.htm');
    IsRTFBody:=(Attachments.Count>0) and (Body.Count=0) and
      (LowerCase(ExtractFileName(Attachments[0].FileName))='_rtfbody.rtf');
{First write the global headers}
    UniqueID:=MakeUniqueID;
    StringToStream('Content-Type: '+FInMessage.ContentType+
                   '; boundary="'+UniqueID+'"');
    StringToStream('');
    StringToStream(LoadStr(msSMIMEExplanation));
    StringToStream('');
    StringToStream('--'+UniqueID);
{Check if multipart/alternative section}
    IsAltSection:=Copy(LowerCase(ExtractFileName(Attachments[0].FileName)),1,5)='_alt.';
    if IsAltSection and (not IsAlternative) then
    begin
      SaveUniqueID:=UniqueID;
      UniqueID:=MakeUniqueID;
      StringToStream('Content-Type:  multipart/alternative'+
                     '; boundary="'+UniqueID+'"');
      StringToStream('Content-Transfer-Encoding: 7bit');
      StringToStream('');
      StringToStream('--'+UniqueID);
    end;
    if Body.Count>0 then
    begin
      if CharSet in [csUSASCII,csISO2022jp] then
      begin
        if CharSet=csUSASCII then
          StringToStream('Content-Type: text/plain; charset="us-ascii"')
        else
          StringToStream('Content-Type: text/plain; charset="iso-2022-jp"');
        if HasLongStrings then
          StringToStream('Content-Transfer-Encoding: quoted-printable')
        else
          StringToStream('Content-Transfer-Encoding: 7bit');
      end
      else
      begin
        StringToStream('Content-Type: text/plain; charset="iso-8859-1"');
        StringToStream('Content-Transfer-Encoding: quoted-printable');
      end;
      StringToStream('');
{Encode and save body}
      TempLines:=TStringList.Create;
      try
        PrepareBody;
        for i:=0 to TempLines.Count-1 do
          StringToStream(TempLines[i]);
      finally
        TempLines.Free;
      end;
      StringToStream('');
      StringToStream('--'+UniqueID);
    end;
{Now deal with attachments}
    for i:=0 to Attachments.Count-1 do
    begin
      if i>0 then
      begin
        StringToStream('');
        StringToStream('--'+UniqueID);
        if IsHTMLBody then IsHTMLBody:=false;
        if IsRTFBody then IsRTFBody:=false;
      end;
      s:='Content-Type: '+Attachments[i].ContentType;
      if IsAlternative or IsAltSection or IsHTMLBody or IsRTFBody
        or (Attachments[i].FileName='') then
        StringToStream(s)
      else
        StringToStream(s+'; name="'+ExtractFileName(Attachments[i].FileName)+'"');
      StringToStream('Content-Transfer-Encoding: '+EncNames[Attachments[i].ContentTransferEncoding]);
      if not IsAlternative and not IsAltSection and not IsHTMLBody and not IsRTFBody
        and (ExtractFileName(Attachments[i].FileName)<>'') then
        StringToStream('Content-Disposition: attachment; filename="'
                       +ExtractFileName(Attachments[i].FileName)+'"');
      StringToStream('');
      PrepareAnAttachment(Attachments[i]);
      StringToStream('');
      if i=Attachments.Count-1 then
        StringToStream('--'+UniqueID+'--') {Last Attachment}
      else
      if IsAltSection and
        (Copy(LowerCase(ExtractFileName(Attachments[i+1].FileName)),1,5)<>'_alt.') then
      begin
        IsAltSection:=false;
        StringToStream('--'+UniqueID+'--');
        UniqueID:=SaveUniqueID;
      end;
    end;
  end;
end;

procedure TmsCustomEncoder.PrepareTextPlainMessage;
var
  i : Integer;
begin
  with FInMessage do
  begin
    if CharSet in [csUSASCII,csISO2022jp] then
    begin
      if CharSet=csUSASCII then
        StringToStream('Content-Type: text/plain; charset="us-ascii"')
      else
        StringToStream('Content-Type: text/plain; charset="iso-2022-jp"');
      if HasLongStrings then
        StringToStream('Content-Transfer-Encoding: quoted-printable')
      else
        StringToStream('Content-Transfer-Encoding: 7bit');
    end
    else
    begin
      StringToStream('Content-Type: text/plain; charset="iso-8859-1"');
      StringToStream('Content-Transfer-Encoding: quoted-printable');
    end;
    StringToStream('');
    TempLines:=TStringList.Create;
    try
      PrepareBody;
      for i:=0 to TempLines.Count-1 do
        StringToStream(TempLines[i]);
    finally
      TempLines.Free;
    end;
  end;
end;

procedure TmsCustomEncoder.PrepareFileMessage;
var
  IsRTFBody : boolean;
  IsHTMLBody : boolean;
  IsEdifact: boolean;
begin
  with FInMessage do
  begin
    IsHTMLBody:=(Attachments.Count=1) and
      (LowerCase(ExtractFileName(Attachments[0].FileName))='_htmbody.htm');
    IsRTFBody:=(Attachments.Count=1) and
      (LowerCase(ExtractFileName(Attachments[0].FileName))='_rtfbody.rtf');
    IsEdifact:=(Attachments.Count=1) and
      (LowerCase(ExtractFileName(Attachments[0].FileName))='_edifact');
{It means we are sending just one file, no body...}
    if IsHTMLBody then
      StringToStream('Content-Type: text/html')
    else
    if IsRTFBody then
      StringToStream('Content-Type: text/rtf')
    else
    if IsEdifact then
    begin
      StringToStream('Content-Type: application/edifact');
      Attachments[0].ContentTransferEncoding:=etQP;
    end
    else
      StringToStream('Content-Type: '+Attachments[0].ContentType+
                     '; name="'+ExtractFileName(Attachments[0].FileName)+'"');
    StringToStream('Content-Transfer-Encoding: '+EncNames[Attachments[0].ContentTransferEncoding]);
    if (not IsRTFBody) and (not IsHTMLBody) and (not IsEdifact) then
      StringToStream('Content-Disposition: attachment; filename="'
                 +ExtractFileName(Attachments[0].FileName)+'"');
    StringToStream('');
    PrepareAnAttachment(Attachments[0]);
  end;
end;

procedure TmsCustomEncoder.PrepareFancyMessage;
{We are here if contenttype is text/rtf or text/html}
var
  i : Integer;
  s : string;
  TempStream : TMemoryStream;
  TempLines : TStrings;
begin
  with FInMessage do
  begin
    if ContentType='text/html' then
      s:='Content-Type: text/html'
    else
      s:='Content-Type: text/rtf';
    if CharSet<>csUSASCII then
      s:=s+'; charset="iso-8859-1"';
    StringToStream(s);
    StringToStream('Content-Transfer-Encoding: quoted-printable');
    StringToStream('');
    TempLines:=TStringList.Create;
    try
      TempStream:=TMemoryStream.Create;
      try
        Body.SaveToStream(TempStream);
        TempStream.Position:=0;
        QP:=TQuotedPrintable.Create(TempStream,TempLines);
        try
          QP.Encode;
        finally
          QP.Free;
        end;
      finally
        TempStream.Free;
      end;
      Body.Assign(TempLines);
    finally
      TempLines.Free;
    end;
    for i:=0 to Body.Count-1 do
      StringToStream(Body[i]);
  end;
end;

procedure TmsCustomEncoder.PrepareUUEncodedMessage;
var
  i : Integer;
  s, s1 : ShortString;
  sLen : byte absolute s;
  s1Len : byte absolute s1;
begin
  with FInMessage do
  begin
    StringToStream('');
    for i:=0 to Body.Count-1 do
      StringToStream(Body[i]);
    for i:=0 to Attachments.Count-1 do
    begin
      StringToStream('');
      StringToStream('begin 600 '+ExtractFileName(Attachments[i].FileName));
      with Attachments[i].Contents do
      begin
        Position:=0;
        repeat
          sLen:=Read(s[1],45);
          UUMakeTextData(s,s1);
          StringToStream(s1);
        until sLen<45;
        StringToStream('`');
        StringToStream('end');
      end;
    end;
  end;
end;

procedure TmsCustomEncoder.ListHeadersToStream(const ID : string;
          List : TmsAddressList);
{Saves CC, BCC, or Recipients to the stream in ready-to-send format}
var
  Hdr, NameToSend : ShortString;
  i : Integer;
  TenSpaces : string;
begin
  TenSpaces:='          ';
  if List.Count>0 then
  begin
    Hdr:=ID;
    if Hdr[Length(Hdr)]<>':' then
      Hdr:=Concat(ID+':');
    while Length(Hdr)<10 do
      Hdr:=Concat(Hdr,' ');
    if List.Count>0 then
    begin
      NameToSend:=List[0].Name;
      if (Pos('"',NameToSend)=0) and ((Pos('.',NameToSend)>0) or (Pos(',',NameToSend)>0)) then
        NameToSend:=Concat('"',List[0].Name,'"');
      if (FInMessage.CharSet=csISO2022jp) and (FInMessage.Encoding=meMIME) then
        NameToSend:=EncodeHeader(NameToSend);
      if List.Count=1 then
        StringToStream(Hdr+NameToSend+' <'+List[0].Address+'>')
      else
        StringToStream(Hdr+NameToSend+' <'+List[0].Address+'>,');
      for i:=1 to List.Count-1 do
      begin
        NameToSend:=List[i].Name;
        if (Pos('"',NameToSend)=0) and ((Pos('.',NameToSend)>0) or (Pos(',',NameToSend)>0)) then
          NameToSend:=Concat('"',NameToSend,'"');
        if (FInMessage.CharSet=csISO2022jp) and (FInMessage.Encoding=meMIME) then
          NameToSend:=EncodeHeader(NameToSend);
        if i=List.Count-1 then
          StringToStream(TenSpaces+NameToSend+' <'+List[i].Address+'>')
        else
          StringToStream(TenSpaces+NameToSend+' <'+List[i].Address+'>,')
      end;
    end;
  end;
end;

procedure TmsCustomEncoder.StringToStream(const s : string);
var
  s1 : PChar;
begin
  if s='.' then exit;
  s1:=StrAlloc(Length(s)+4);
  try
    StrCat(StrPCopy(s1,s),^M^J#00);
    FStream.Write(s1^,StrLen(s1));
  finally
    StrDispose(s1);
  end;
end;

procedure TmsCustomEncoder.Process;
begin
  FStream.Position:=0;
  PrepareGlobalHeaders;
  if FInMessage.Encoding=meUU then
    PrepareUUEncodedMessage
  else
  if FInMessage.ContentType='multipart/mixed' then
    PrepareMultiPartMessage(false)
  else
  if FInMessage.ContentType='text/plain' then
  begin
    if FInMessage.Attachments.Count=0 then
      PrepareTextPlainMessage
    else
      PrepareFileMessage;
  end
  else
  if (FInMessage.ContentType='text/html') or (FInMessage.ContentType='text/rtf') then
    PrepareFancyMessage
  else
  if FInMessage.ContentType='multipart/alternative' then
    PrepareMultiPartMessage(true)
  else
    PrepareFileMessage;
end;

{TmsMessageEncoder}
procedure TmsMessageEncoder.PrepareGlobalHeaders;
var
  i : Integer;
  s : string;
begin
  with FInMessage as TmsMessage do
  begin
    s:=Sender.Name;
    if (Pos('"',s)=0) and (Pos('.',s)>0) then
      s:=Concat('"',Sender.Name,'"');
    if (CharSet=csISO2022jp) and (Encoding=meMIME) then
      s:=EncodeHeader(s);
    StringToStream('From:     '+s+' <'+Sender.Address+'>');
    ListHeadersToStream('To',Recipients);
    ListHeadersToStream('CC',CC);
{Skip BCC}
    if ForceBCC then
      ListHeadersToStream('BCC',BCC);
    if ReturnReceipt then
      StringToStream('Return-Receipt-To: <'+Sender.Address+'>');
    case Priority of
      ptNormal : {do nothing};
      ptHigh : StringToStream('X-Priority: 1');
      ptLow : StringToStream('X-Priority: 5');
    end;
    FilterHeaders;
    for i:=0 to Headers.Count-1 do
    begin
      StringToStream(Headers[i]);
    end;
    if Subject<>'' then
    begin
      if (CharSet=csISO2022jp) and (Encoding=meMIME) then
        s:=EncodeHeader(Subject)
      else
        s:=Subject;
      StringToStream('Subject: '+s);
    end;
    if Encoding=meMIME then
      StringToStream('Mime-Version: 1.0');
  end;
end;

{TmsArticleEncoder}
procedure TmsArticleEncoder.PrepareGlobalHeaders;
var
  i : Integer;
  s : string;
begin
  with FInMessage as TmsArticle do
  begin
    if (CharSet=csISO2022jp) and (Encoding=meMIME) then
      s:=EncodeHeader(Sender.Name)
    else
      s:=Sender.Name;
    StringToStream('From:     '+Sender.Name+' <'+Sender.Address+'>');
    StringToStream('Newsgroups: '+NewsGroups);
    FilterHeaders;
    for i:=0 to Headers.Count-1 do
    begin
      StringToStream(Headers[i]);
    end;
    if Subject<>'' then
    begin
      if (CharSet=csISO2022jp) and (Encoding=meMIME) then
        s:=EncodeHeader(Subject)
      else
        s:=Subject;
      StringToStream('Subject:  '+s);
    end;
    if Encoding=meMIME then
      StringToStream('Mime-Version: 1.0');
  end;
end;

end.
