
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Miscellaneous procedures related to             }
{       RichView Format (RVF).                          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVFMisc;

interface
{$I RV_Defs.inc}
uses Classes, SysUtils, Graphics, Controls, RVClasses,
     RVStyle, RVUni, RVTypes;

procedure RVFWrite(Stream: TStream; const s: TRVAnsiString);
procedure RVFWriteLine(Stream: TStream; s: TRVAnsiString);
procedure RVFWriteLineX(Stream: TStream; const s: TRVRawByteString;
  Unicode, HexUnicode: Boolean);
function RVFStream2TextString(Stream: TRVMemoryStream): TRVAnsiString;
function RVFTextString2Stream(const str: TRVAnsiString; Stream: TRVMemoryStream): Boolean;
procedure RVFSaveStreamToStream(SourceStream, Stream: TStream);
function RVFStringToStream(const str: TRVRawByteString): TRVMemoryStream;

function RVEncodeString(const str: TRVAnsiString): TRVAnsiString;
function RVDecodeString(const str: TRVAnsiString): TRVAnsiString;

{$IFDEF RICHVIEWCBDEF3}
function RVEncodeWideString(const str: TRVUnicodeString): TRVAnsiString;
function RVDecodeWideString(const str: TRVAnsiString): TRVUnicodeString;
{$ENDIF}

function RVFLoadPicture(const s: TRVAnsiString; gr: TGraphic): Boolean;
function RVFSavePicture(gr: TGraphic): TRVAnsiString;
function RVFSavePictureBinaryWithoutSize(gr: TGraphic): TRVAnsiString;
procedure RVFLoadPictureBinary(const Data: TRVAnsiString; gr: TGraphic);
procedure RVFLoadPictureBinary2(AStream: TStream; gr: TGraphic);
procedure RVFSavePictureBinary(Stream: TStream; gr: TGraphic);
function RVFLoadControl(const s: TRVAnsiString; var ctrl: TComponent;
  const ClassName: String; ParentControl: TWinControl; OnError: TReaderError): Boolean;
function RVFSaveControl(ctrl: TComponent): TRVAnsiString;
function RVFLoadControlBinary(const Data: TRVRawByteString; var ctrl: TComponent;
  const ClassName: String; ParentControl: TWinControl; OnError: TReaderError): Boolean;
procedure RVFSaveControlBinary(Stream: TStream; ctrl: TComponent);

function RVFReadString(var P: PRVAnsiChar; var s: TRVRawByteString): Boolean;
function RVFReadInteger(var P: PRVAnsiChar; var V: Integer): Boolean;
{$IFDEF RICHVIEWCBDEF3}
function RVFReadText(var P: PRVAnsiChar): TRVRawByteString;
{$ENDIF}
function RVFReadTag(var P: PRVAnsiChar; TagsArePChars, Quoted: Boolean;
  var Tag: Integer; UTF8Strings: Boolean): Boolean;
function RVFReadParaStyle(RVStyle: TRVStyle; var P: PRVAnsiChar; var V: Integer;
  UTF8Strings: Boolean; var StyleNameUsed: Boolean): Boolean;
function RVFReadTextStyle(RVStyle: TRVStyle; var P: PRVAnsiChar; var V: Integer;
  UTF8Strings: Boolean; var StyleNameUsed: Boolean): Boolean;

function RVFSaveTag(TagsArePChars:Boolean; Tag: Integer): TRVRawByteString;
function RVFSaveText(RVStyle:TRVStyle; UseStyleNames: Boolean; TextIdx: Integer): TRVRawByteString;
function RVFSavePara(RVStyle:TRVStyle; UseStyleNames: Boolean; TextIdx: Integer): TRVRawByteString;
function RVFItemSavePara(ParaNo: Integer; RVData: TPersistent;
  ForceSameAsPrev: Boolean): TRVRawByteString;
function RVFEncodeLineBreaks(const s: TRVRawByteString): TRVRawByteString;
function RVFDecodeLineBreaks(const s: TRVRawByteString): TRVRawByteString;
function StringToRVFString(const s: String): TRVRawByteString;
function RVFStringToString(const s: TRVRawByteString; UTF8: Boolean): String;

const
  RichViewWriteControlIgnoreChildren: Boolean = False;

implementation
uses RVStr, RVFuncs, CRVData;
const
  crlf: TRVAnsiString = TRVAnsiString(#13#10);
{-----------------------------------------------------------------------}
procedure RVFWrite(Stream: TStream; const s: TRVAnsiString);
begin
  Stream.WriteBuffer(PRVAnsiChar(s)^, Length(s));
end;
{-----------------------------------------------------------------------}
procedure RVFWriteLine(Stream: TStream; s: TRVAnsiString);
begin
  s := s+crlf;
  Stream.WriteBuffer(PRVAnsiChar(s)^, Length(s));
end;
{-----------------------------------------------------------------------}
procedure RVFWriteLineX(Stream: TStream; const s: TRVRawByteString;
  Unicode, HexUnicode: Boolean);
var sep: TRVAnsiString;
    s2: TRVRawByteString;
    ps: PRVWordArray;
    i: Integer;
begin
  s2 := s;
  if Unicode then begin
    ps := PRVWordArray(s2);
    for i := 0 to Length(s2) div 2-1 do
      if ps[i]=0 then
        ps[i] := ord('?');
    end
  else begin
    for i := 1 to Length(s2) do
      if s2[i]=#0 then
        s2[i] := '?';
  end;
  {$IFDEF RICHVIEWCBDEF3}
  if Unicode and HexUnicode then begin
    sep := RVEncodeString(s2);
    Stream.WriteBuffer(PRVAnsiChar(sep)^, Length(sep));
    end
  else
  {$ENDIF}
    Stream.WriteBuffer(PRVAnsiChar(s2)^, Length(s2));
  if Unicode and not HexUnicode then
    sep := TRVAnsiString(Chr(Lo(UNI_ParagraphSeparator)))+Chr(Hi(UNI_ParagraphSeparator))
  else
    sep := crlf;
  Stream.WriteBuffer(PRVAnsiChar(sep)^, Length(sep));
end;
{-----------------------------------------------------------------------}
function RVFStream2TextString(Stream: TRVMemoryStream): TRVAnsiString;
var i: Integer;
    hex: String;
begin
 SetLength(Result, Stream.Size*2);
 for i := 0 to Stream.Size-1 do begin
   hex := IntToHex(Ord(PRVAnsiChar(Stream.Memory)[i]),2);
   Result[i*2+1] := TRVAnsiChar(ord(hex[1]));
   Result[i*2+2] := TRVAnsiChar(ord(hex[2]));
 end;
end;
{-----------------------------------------------------------------------}
function RVEncodeString(const str: TRVAnsiString): TRVAnsiString;
var i: Integer;
    hex: String;
begin
 SetLength(Result, Length(str)*2);
 for i := 0 to Length(str)-1 do begin
   hex := IntToHex(Ord(str[i+1]),2);
   Result[i*2+1] := TRVAnsiChar(ord(hex[1]));
   Result[i*2+2] := TRVAnsiChar(ord(hex[2]));
 end;
end;
{-----------------------------------------------------------------------}
function RVFTextString2Stream(const str: TRVAnsiString; Stream: TRVMemoryStream): Boolean;
var i,d1,d2, idx1, idx2: Integer;
begin
 Result := False;
 if (Length(str) mod 2)<>0 then exit;
 Stream.SetSize(Length(str) div 2);
 for i := 0 to (Length(str) div 2)-1 do begin
   idx1 := i*2+1;
   idx2 := i*2+2;
   if not (str[idx1] in ['0'..'9','A'..'F','a'..'f']) or
     not (str[idx2] in ['0'..'9','A'..'F','a'..'f']) then exit;
   if str[idx1] in ['0'..'9'] then
     d1 := Ord(str[idx1])-Ord('0')
   else if str[idx1] in ['A'..'F'] then
     d1 := Ord(str[idx1])-Ord('A')+10
   else
     d1 := Ord(str[idx1])-Ord('a')+10;
   if str[idx2] in ['0'..'9'] then
     d2 := Ord(str[idx2])-Ord('0')
   else if str[idx2] in ['A'..'F'] then
     d2 := Ord(str[idx2])-Ord('A')+10
   else
     d2 := Ord(str[idx2])-Ord('a')+10;
   PRVAnsiChar(Stream.Memory)[i] := TRVAnsiChar(Chr(d1*16+d2));
 end;
 Result := True;
end;
{-----------------------------------------------------------------------}
function RVDecodeString(const str: TRVAnsiString): TRVAnsiString;
var i,d1,d2, idx1, idx2: Integer;
begin
 Result := '';
 if (Length(str) mod 2)<>0 then exit;
 SetLength(Result, Length(str) div 2);
 for i := 0 to (Length(str) div 2)-1 do begin
   idx1 := i*2+1;
   idx2 := i*2+2;
   if not (str[idx1] in ['0'..'9','A'..'F','a'..'f']) or
     not (str[idx2] in ['0'..'9','A'..'F','a'..'f']) then exit;
   if str[idx1] in ['0'..'9'] then
     d1 := Ord(str[idx1])-Ord('0')
   else if str[idx1] in ['A'..'F'] then
     d1 := Ord(str[idx1])-Ord('A')+10
   else
     d1 := Ord(str[idx1])-Ord('a')+10;
   if str[idx2] in ['0'..'9'] then
     d2 := Ord(str[idx2])-Ord('0')
   else if str[idx2] in ['A'..'F'] then
     d2 := Ord(str[idx2])-Ord('A')+10
   else
     d2 := Ord(str[idx2])-Ord('a')+10;   
   Result[i+1] := TRVAnsiChar(d1*16+d2);
 end;
end;
{-----------------------------------------------------------------------}
procedure RVFSaveStreamToStream(SourceStream, Stream: TStream);
var Size: Integer;
begin
  Size := SourceStream.Size;
  Stream.WriteBuffer(Size, sizeof(Size));
  Stream.CopyFrom(SourceStream, 0);
end;
{-----------------------------------------------------------------------}
function RVFStringToStream(const str: TRVRawByteString): TRVMemoryStream;
begin
  Result := TRVMemoryStream.Create;
  Result.WriteBuffer(Pointer(str)^, Length(str));
  Result.Position := 0;
end;
{-----------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
function RVEncodeWideString(const str: TRVUnicodeString): TRVAnsiString;
var i: Integer;
    hex: String;
begin
 SetLength(Result, Length(str)*4);
 for i := 0 to Length(str)-1 do begin
   hex := IntToHex(Word(str[i+1]),4);
   Result[i*4+1] := TRVAnsiChar(hex[1]);
   Result[i*4+2] := TRVAnsiChar(hex[2]);
   Result[i*4+3] := TRVAnsiChar(hex[3]);
   Result[i*4+4] := TRVAnsiChar(hex[4]);
 end;
end;
{-----------------------------------------------------------------------}
function RVDecodeWideString(const str: TRVAnsiString): TRVUnicodeString;
var i,d1,d2,d3,d4, idx1, idx2, idx3, idx4: Integer;
begin
 Result := '';
 if (Length(str) mod 4)<>0 then exit;
 SetLength(Result, Length(str) div 4);
 for i := 0 to (Length(str) div 4)-1 do begin
   idx1 := i*4+1;
   idx2 := idx1+1;
   idx3 := idx2+1;
   idx4 := idx3+1;
   if not (str[idx1] in ['0'..'9','A'..'F','a'..'f']) or
     not (str[idx2] in ['0'..'9','A'..'F','a'..'f']) or
     not (str[idx3] in ['0'..'9','A'..'F','a'..'f']) or
     not (str[idx4] in ['0'..'9','A'..'F','a'..'f']) then exit;
   if str[idx1] in ['0'..'9'] then
     d1 := Ord(str[idx1])-Ord('0')
   else if str[idx1] in ['A'..'F'] then
     d1 := Ord(str[idx1])-Ord('A')+10
   else
     d1 := Ord(str[idx1])-Ord('a')+10;   
   if str[idx2] in ['0'..'9'] then
     d2 := Ord(str[idx2])-Ord('0')
   else if str[idx2] in ['A'..'F'] then
     d2 := Ord(str[idx2])-Ord('A')+10
   else
     d2 := Ord(str[idx2])-Ord('a')+10;
   if str[idx3] in ['0'..'9'] then
     d3 := Ord(str[idx3])-Ord('0')
   else if str[idx3] in ['A'..'F'] then
     d3 := Ord(str[idx3])-Ord('A')+10
   else
     d3 := Ord(str[idx3])-Ord('a')+10;
   if str[idx4] in ['0'..'9'] then
     d4 := Ord(str[idx4])-Ord('0')
   else if str[idx4] in ['A'..'F'] then
     d4 := Ord(str[idx4])-Ord('A')+10
   else
     d4 := Ord(str[idx4])-Ord('a')+10;
   Result[i+1] := TRVUnicodeChar(((d1*16+d2)*16+d3)*16+d4);
 end;
end;
{$ENDIF}
{-----------------------------------------------------------------------}
function RVFLoadPicture(const s: TRVAnsiString; gr: TGraphic): Boolean;
var Stream: TRVMemoryStream;
begin
  Stream := TRVMemoryStream.Create;
  try
    Result := RVFTextString2Stream(s,Stream);
    Stream.Position := 0;
    gr.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
function RVFSavePicture(gr: TGraphic): TRVAnsiString;
var Stream: TRVMemoryStream;
begin
  Stream := TRVMemoryStream.Create;
  try
    gr.SaveToStream(Stream);
    Result := RVFStream2TextString(Stream);
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
function RVFSavePictureBinaryWithoutSize(gr: TGraphic): TRVAnsiString;
var Stream: TRVMemoryStream;
begin
  Stream := TRVMemoryStream.Create;
  try
    gr.SaveToStream(Stream);
    SetLength(Result, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(PRVAnsiChar(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure RVFLoadPictureBinary(const Data: TRVAnsiString; gr: TGraphic);
var Stream: TRVMemoryStream;
begin
  Stream  := TRVMemoryStream.Create;
  try
    Stream.SetSize(Length(Data));
    Move(PRVAnsiChar(Data)^, Stream.Memory^, Length(Data));
    Stream.Position := 0;
    gr.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure RVFLoadPictureBinary2(AStream: TStream; gr: TGraphic);
var Stream: TRVMemoryStream;
    v: Integer;
begin
  Stream  := TRVMemoryStream.Create;
  try
    AStream.ReadBuffer(v, sizeof(v));
    Stream.SetSize(v);
    AStream.ReadBuffer(Stream.Memory^, v);
    Stream.Position := 0;
    gr.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure RVFSavePictureBinary(Stream: TStream; gr: TGraphic);
var p, newp: Integer;
begin
  // writes size of picture body, then picture body
  p := Stream.Position;
  Stream.WriteBuffer(p, SizeOf(p));
  gr.SaveToStream(Stream);
  newp := Stream.Position;
  Stream.Position := p;
  p := newp - p - SizeOf(p);
  Stream.WriteBuffer(p, SizeOf(p));
  Stream.Position := newp;
end;
{-----------------------------------------------------------------------}
function RVFLoadControl(const s: TRVAnsiString; var ctrl: TComponent;
  const ClassName: String; ParentControl: TWinControl;
  OnError: TReaderError): Boolean;
var Stream: TRVMemoryStream;
    Reader: TReader;
begin
  Stream := TRVMemoryStream.Create;
  try
    if ClassName<>'' then
      ctrl := TComponentClass(GetClass(ClassName)).Create(nil);
    if (ctrl<>nil) and (ctrl is TControl) then
      TControl(ctrl).Parent := ParentControl;
    Result := RVFTextString2Stream(s,Stream);
    if Result then begin
      Stream.Position := 0;
      try
        Reader := TReader.Create(Stream, 4096);
        try
          Reader.OnError := OnError;
          ctrl := Reader.ReadRootComponent(ctrl);
        finally
          Reader.Free;
        end;
      except
        ctrl := nil;
        Result := False;
      end;
      if (ParentControl<>nil) and (ctrl<>nil) and (ctrl is TControl) then
        TControl(ctrl).Parent := ParentControl;
    end;
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
function RVFSaveControl(ctrl: TComponent): TRVAnsiString;
var Stream: TRVMemoryStream;
    Writer: TWriter;
begin
  Stream := TRVMemoryStream.Create;
  try
    //Stream.WriteComponent(ctrl);
    Writer := TWriter.Create(Stream, 4096);
    try
      Writer.IgnoreChildren := RichViewWriteControlIgnoreChildren;
      Writer.WriteDescendent(ctrl, nil);
    finally
      Writer.Free;
    end;
    Result := RVFStream2TextString(Stream);
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
function RVFLoadControlBinary(const Data: TRVRawByteString; var ctrl: TComponent;
  const ClassName: String; ParentControl: TWinControl;
  OnError: TReaderError): Boolean;
var Stream: TRVMemoryStream;
    Reader: TReader;
begin
  Result := True;
  Stream := TRVMemoryStream.Create;
  try
    Stream.SetSize(Length(Data));
    Move(PRVAnsiChar(Data)^, Stream.Memory^, Length(Data));
    if ClassName<>'' then
      ctrl := TComponentClass(GetClass(ClassName)).Create(nil);
    if (ctrl<>nil) and (ctrl is TControl) then
      TControl(ctrl).Parent := ParentControl;
    Stream.Position := 0;
    try
      Reader := TReader.Create(Stream, 4096);
      try
        Reader.OnError := OnError;
        ctrl := Reader.ReadRootComponent(ctrl);
      finally
        Reader.Free;
      end;
    except
      ctrl := nil;
      Result := False;
    end;
    if (ParentControl<>nil) and (ctrl<>nil) and (ctrl is TControl) then
      TControl(ctrl).Parent := ParentControl;
  finally
    Stream.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure RVFSaveControlBinary(Stream: TStream; ctrl: TComponent);
var p, newp: Integer;
    Writer: TWriter;
begin
  p := Stream.Position;
  Stream.WriteBuffer(p, SizeOf(p));
  //Stream.WriteComponent(ctrl);
  Writer := TWriter.Create(Stream, 4096);
  try
    Writer.IgnoreChildren := RichViewWriteControlIgnoreChildren;
    Writer.WriteDescendent(ctrl, nil);
  finally
    Writer.Free;
  end;
  newp := Stream.Position;
  Stream.Position := p;
  p := newp - p - SizeOf(p);
  Stream.WriteBuffer(p, SizeOf(p));
  Stream.Position := newp;
end;
{-----------------------------------------------------------------------}
function RVFReadString(var P: PRVAnsiChar; var s: TRVRawByteString): Boolean;
begin
  s := '';
  while not (P[0] in [#0,' ']) do begin
    s := s + P[0];
    inc(P);
  end;
  if P[0]=' ' then inc(P);
  Result := s<>'';
end;
{-----------------------------------------------------------------------}
function RVFReadInteger(var P: PRVAnsiChar; var V: Integer): Boolean;
var minus: ByteBool;
begin
  if not (P[0] in ['-','0'..'9']) then begin
    Result := False;
    exit;
  end;
  V:=0;
  minus := (P[0]='-');
  if minus then inc(P);
  while not (P[0] in [#0,' ']) do
    if P[0] in ['0'..'9'] then begin
      V := V*10+(Ord(P[0])-Ord('0'));
      inc(P);
      end
    else begin
      Result := False;
      exit;
    end;
    if P[0]=' ' then inc(P);
    if minus then V := -V;
    Result := True;
end;
{--------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
function RVFReadText(var P: PRVAnsiChar): TRVRawByteString;
begin
  Result := AnsiExtractQuotedStr(P, '"');
  if (P^ = ' ') then inc(P);
end;
{$ENDIF}
{--------------------------------------------------------------------}
function RVFReadTag(var P: PRVAnsiChar; TagsArePChars, Quoted: Boolean;
  var Tag: Integer; UTF8Strings: Boolean): Boolean;
var s: TRVRawByteString;
    TagString: String;
begin
  {$IFDEF RICHVIEWCBDEF3}
  Quoted := Quoted and (P^ = '"');
  if Quoted then begin
    s := AnsiExtractQuotedStr(P, '"');
    if (P^ = ' ') then
      inc(P);
    end
  else
  {$ENDIF}
  if not RVFReadString(P,s) then begin
    Result := False;
    exit;
  end;
  TagString := RVFStringToString(s, UTF8Strings);
  Result := True;
  if TagsArePChars then
    if (TagString=RVFTagEmptyStr) and not Quoted then
      Tag := 0
    else
      Tag := Integer(StrNew(PChar(TagString)))
  else
    try
      Tag := RVStrToInt(s);
    except
      Result := False;
    end;
end;
{------------------------------------------------------------------------------}
function RVFReadParaStyle(RVStyle: TRVStyle; var P: PRVAnsiChar; var V: Integer;
  UTF8Strings: Boolean; var StyleNameUsed: Boolean): Boolean;
   {$IFDEF RICHVIEWCBDEF3}
    function ParaNameToIndex(const aParaName: String): Integer;
    begin
      with RVStyle.ParaStyles do
        for Result := 0 to Count-1 do
          if Items[result].StyleName = aParaName then Exit;
      Result := 0;
    end;
    {$ENDIF}
begin
  Result := RVFReadInteger(P, V);
  {$IFDEF RICHVIEWCBDEF3}
  StyleNameUsed := not Result;
  if not Result then begin
    V := ParaNameToIndex(RVFStringToString(RVFReadText(P), UTF8Strings));
    Result := True;
  end;
  {$ELSE}
  StyleNameUsed := False;
  {$ENDIF}
end;
{-----------------------------------------------------------------------}
function RVFReadTextStyle(RVStyle: TRVStyle; var P: PRVAnsiChar; var V: Integer;
  UTF8Strings: Boolean; var StyleNameUsed: Boolean): Boolean;
    {$IFDEF RICHVIEWCBDEF3}
    function TextNameToIndex(const aStyleName: String): Integer;
    begin
      with RVStyle.TextStyles do
        for Result := 0 to Count-1 do
          if Items[result].StyleName = aStyleName then Exit;
      Result := 0;
    end;
    {$ENDIF}
begin
  Result := RVFReadInteger(P, V);
  {$IFDEF RICHVIEWCBDEF3}
  StyleNameUsed := not Result;
  if not Result then begin
    V := TextNameToIndex(RVFStringToString(RVFReadText(P), UTF8Strings));
    Result := True;
  end;
  {$ELSE}
  StyleNameUsed := False;
  {$ENDIF}
end;
{-----------------------------------------------------------------------}
function RVFSaveTag(TagsArePChars:Boolean; Tag: Integer): TRVRawByteString;
begin
  if TagsArePChars then
    if (Tag=0) or (PRVAnsiChar(Tag)[0]=#0) then
      Result := RVFTagEmptyStr
    else
     {$IFDEF RICHVIEWCBDEF3}
      Result := StringToRVFString(AnsiQuotedStr(PChar(Tag), '"'))
     {$ELSE}
     Result := TRVAnsiString(PChar(Tag))
     {$ENDIF}
  else
    Result := RVIntToStr(Tag)
end;
{-----------------------------------------------------------------------}
function RVFSaveText(RVStyle:TRVStyle; UseStyleNames: Boolean;
  TextIdx: Integer): TRVRawByteString;
begin
  {$IFDEF RICHVIEWCBDEF3}
  with RVStyle.TextStyles do
    if (TextIdx>=0) and (TextIdx<>rvsDefStyle) and UseStyleNames then
      Result := StringToRVFString(AnsiQuotedStr(Items[TextIdx].StyleName, '"'))
    else
  {$ENDIF}
      Result := RVIntToStr(TextIdx);
end;
{-----------------------------------------------------------------------}
function RVFSavePara(RVStyle:TRVStyle; UseStyleNames: Boolean;
  TextIdx: Integer): TRVRawByteString;
begin
  {$IFDEF RICHVIEWCBDEF3}
  with RVStyle.ParaStyles do
    if (TextIdx>=0) and UseStyleNames then
      Result := StringToRVFString(AnsiQuotedStr(Items[TextIdx].StyleName, '"'))
    else
  {$ENDIF}
      Result := RVIntToStr(TextIdx);
end;
{-----------------------------------------------------------------------}
function RVFItemSavePara(ParaNo: Integer; RVData: TPersistent;
  ForceSameAsPrev: Boolean): TRVRawByteString;
begin
  if ForceSameAsPrev then
    ParaNo := -1;
  Result := RVFSavePara(TCustomRVData(RVData).GetRVStyle,
    rvfoUseStyleNames in TCustomRVData(RVData).RVFOptions, ParaNo);
end;
{-----------------------------------------------------------------------}
function RVFEncodeLineBreaks(const s: TRVRawByteString): TRVRawByteString;
var i: Integer;
begin
  Result := s;
  for i := 1 to Length(Result) do
    case Result[i] of
      #13:
        Result[i] := #1;
      #10:
        Result[i] := #2;
    end;
end;
{-----------------------------------------------------------------------}
function RVFDecodeLineBreaks(const s: TRVRawByteString): TRVRawByteString;
var i: Integer;
begin
  Result := s;
  for i := 1 to Length(Result) do
    case Result[i] of
      #1:
        Result[i] := #13;
      #2:
        Result[i] := #10;
    end;
end;
{------------------------------------------------------------------------------}
// Prepares string for saving to RVF
// For Delphi 2009+, converts string (Unicode) to UTF-8
// For older versions of Delphi, uses the string as it is.
// For all cases, CR and LF characters are replaced to #1 and #2.
function StringToRVFString(const s: String): TRVRawByteString;
begin
  {$IFDEF RVUNICODESTR}
  Result := RVFEncodeLineBreaks(UTF8Encode(s));
  {$ELSE}
  Result := RVFEncodeLineBreaks(s);
  {$ENDIF}
end;
// Opposite conversion
function RVFStringToString(const s: TRVRawByteString; UTF8: Boolean): String;
begin
  {$IFDEF RVUNICODESTR}
  if UTF8 then
    Result := UTF8ToString(RVFDecodeLineBreaks(s))
  else
    Result := String(RVFDecodeLineBreaks(s))
  {$ELSE}
  if UTF8 then
    Result := UTF8Decode(RVFDecodeLineBreaks(s)) // automatic conversion from WideString to String 
  else
    Result := RVFDecodeLineBreaks(s);
  {$ENDIF}
end;

end.
