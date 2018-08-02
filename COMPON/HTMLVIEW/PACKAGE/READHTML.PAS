
{Version 8.04}
{*********************************************************}
{*                     READHTML.PAS                      *}
{*              Copyright (c) 1995-2001 by               *}
{*                   L. David Baldwin                    *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$i htmlcons.inc}

{             The Parser
This module contains the parser which reads thru the document.  It divides it
into sections storing the pertinent information in Section objects.  The
document itself is then a TList of section objects.  See the HTMLSubs unit for
the definition of the section objects.

Key Variables:

  Sy:
      An enumerated type which indicates what the current token is.  For
      example, a value of TextSy would indicate a hunk of text, PSy that a <P>
      tag was encountered, etc.
  LCh:
      The next character in the stream to be analyzed.  In mixed case.
  Ch:
      The same character in upper case.
  LCToken:
      A string which is associated with the current token.  If Sy is TextSy,
      then LCToken contains the text.
  Attributes:
      A list of TAttribute's for tokens such as <img>, <a>, which have
      attributes.
  Section:
      The current section being built.
  SectionList:
      The list of sections which form the document.  When in a Table,
      SectionList will contain the list that makes up the current cell.

Key Routines:

  GetCh:
      Gets the next character from the stream.  Fills Ch and LCh.  Skips
      comments.
  Next:
      Gets the next token.  Fills Sy, LCToken, Attributes.  Calls GetCh so the
      next character after the present token is available.  Each part of the
      parser is responsible for calling Next after it does its thing.
}

unit Readhtml;

interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, HTMLUn2, StyleUn;

type
  LoadStyleType = (lsFile, lsBuffer, lsStrings, lsStream, lsInclude);
  TIncludeType = procedure(Sender: TObject; const Command: string;
                    Params: TStrings; var Buffer: PChar; var BuffSize: integer) of Object;
  TSoundType = procedure(Sender: TObject; const SRC: string; Loop: integer;
                    Terminate: boolean) of Object;
  TMetaType = procedure(Sender: TObject; const HttpEq, Name, Content: string) of Object;

  TGetStreamEvent = procedure(Sender: TObject; const SRC: string;
                    var Stream: TMemoryStream) of Object;
  TFrameViewerBase = class(TWinControl)
    private
      procedure wmerase(var msg:TMessage); message wm_erasebkgnd; 
    protected
    FOnInclude: TIncludeType;
    FOnSoundRequest: TSoundType;
    FOnScript: TScriptEvent;

    procedure AddFrame(FrameSet: TObject; Attr: TAttributeList; const FName: string); virtual; abstract;
    function CreateSubFrameSet(FrameSet: TObject): TObject; virtual; abstract;
    procedure DoAttributes(FrameSet: TObject; Attr: TAttributeList); virtual; abstract;
    procedure EndFrameSet(FrameSet: TObject); virtual; abstract;
    end;

    TPropStack = class(TFreeList)
    private
      function GetProp(Index: integer): TProperties;
    public
      property AnItem[Index: integer]: TProperties read GetProp; default;
      function Last: TProperties;
      procedure Delete(Index: integer);
    end;

var
  PropStack: TPropStack;    
  Title: string;
  Base: string;
  BaseTarget: string;
  NoBreak: boolean;       {set when in <NoBr>}

procedure HtmlParseFile(ASectionList: TList; 
                   const FName : string; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
procedure HtmlParseStrings(ASectionList: TList;
                   Strings : TStrings; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
procedure HtmlParseBuffer(ASectionList: TList;
                   ABuffer : PChar; BuffSize: integer; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
procedure HtmlParseStream(ASectionList: TList;
                   AStream: TStream; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
procedure HtmlParseTextFile(ASectionList: TList;
                   const FName : string);
procedure HtmlParseTextStrings(ASectionList: TList;
                   Strings : TStrings);
procedure HtmlParseTextStream(ASectionList: TList;
                   AStream: TStream);

procedure FrameParseFile(FrameViewer: TFrameViewerBase; FrameSet: TObject;  ALoadStyle: LoadStyleType;
          const FName : string; Strings : TStrings; AStream: TStream;
          ABuffer : PChar; BuffSize: integer; AMetaEvent: TMetaType);
function IsFrameFile(ALoadStyle: LoadStyleType;
          const FName : string; Strings : TStrings; AStream: TStream;
          ABuffer : PChar; BuffSize: integer; FrameViewer: TObject): boolean;
{$ifdef ver100_plus}
function TranslateCharset(DefCharset: TFontCharset; const Content: string): TFontCharset;
{$endif}
function StrToSymb(const S: string): Symb;
procedure InitializeFontSizes(Size: integer);   
function PushNewProp(const Tag, AClass, AnID, APseudo: string; AProp: TProperties): boolean;
procedure PopAProp(Tag: string);

implementation

uses
  htmlsubs, htmlsbs1, htmlview, StylePars, UrlSubs;

Const
  Tab = #9;
  EofChar = ^Z;

var
  Sy : Symb;
  Section : TSection;
  SectionList: TCellBasic;
  MasterList: TSectionList;
  CurrentURLTarget: TURLTarget;
  InHref: boolean;
  Attributes : TAttributeList;
  PreFormat: boolean;    {set when doing preformat <pre> text}
  BaseFontSize: integer;
  InScript: boolean;     {when in a <SCRIPT>}
  TagIndex: integer;
  BodyBlock: TBodyBlock;
  ListLevel: integer;     
  TableLevel: integer;    

type
  SymString = string[12];

Const
  MaxRes = 71;
  MaxEndRes = 51;
  ResWords : array[1..MaxRes] of SymString =
     ('HTML', 'TITLE', 'BODY', 'HEAD', 'B', 'I', 'H', 'EM', 'STRONG',
      'U', 'CITE', 'VAR', 'TT', 'CODE', 'KBD', 'SAMP', 'OL', 'UL', 'DIR',
      'MENU', 'DL',
      'A', 'ADDRESS', 'BLOCKQUOTE', 'PRE', 'CENTER', 'TABLE', 'TD', 'TH',
      'CAPTION', 'FORM', 'TEXTAREA', 'SELECT', 'OPTION', 'FONT', 'SUB', 'SUP',
      'BIG', 'SMALL', 'P', 'MAP', 'FRAMESET', 'NOFRAMES', 'SCRIPT', 'DIV',
      'S', 'STRIKE', 'TR', 'NOBR', 'STYLE', 'SPAN',

      'LI', 'BR', 'HR', 'DD', 'DT', 'IMG', 'BASE', 'BUTTON','INPUT',
      'SELECTED', 'BASEFONT', 'AREA', 'FRAME', 'PAGE', 'BGSOUND', 'WRAP',
      'META', 'PANEL', 'WBR', 'LINK');

  ResSy : array[1..MaxRes] of Symb =
     (htmlSy, TitleSy, BodySy, HeadSy, BSy, ISy, HeadingSy, EmSy, StrongSy,
      USy, CiteSy, VarSy, TTSy, CodeSy, KbdSy, SampSy, OLSy, ULSy, DirSy,
      MenuSy, DLSy, ASy, AddressSy, BlockQuoteSy, PreSy, CenterSy,TableSy,
      TDsy, THSy, CaptionSy, FormSy, TextAreaSy,  SelectSy, OptionSy, FontSy,
      SubSy, SupSy, BigSy, SmallSy, PSy, MapSy, FrameSetSy, NoFramesSy,
      ScriptSy, DivSy, SSy, StrikeSy, TRSy, NoBrSy, StyleSy, SpanSy,

      LISy, BRSy, HRSy, DDSy, DTSy, ImageSy, BaseSy, ButtonSy,
      InputSy, SelectedSy, BaseFontSy, AreaSy, FrameSy, PageSy, BgSoundSy,
      WrapSy, MetaSy, PanelSy, WbrSy, LinkSy);

  {keep these in order with those above}
  EndResSy : array[1..MaxEndRes] of Symb =
     (HtmlEndSy, TitleEndSy, BodyEndSy, HeadEndSy, BEndSy, IEndSy, HeadingEndSy,
      EmEndSy, StrongEndSy, UEndSy, CiteEndSy, VarEndSy, TTEndSy, CodeEndSy,
      KbdEndSy, SampEndSy,
      OLEndSy, ULEndSy, DirEndSy, MenuEndSy, DLEndSy, AEndSy, AddressEndSy,
      BlockQuoteEndSy, PreEndSy, CenterEndSy, TableEndSy, TDEndSy, THEndSy,
      CaptionEndSy, FormEndSy, TextAreaEndSy, SelectEndSy, OptionEndSy, FontEndSy,
      SubEndSy, SupEndSy, BigEndSy, SmallEndSy, PEndSy, MapEndSy, FrameSetEndSy,
      NoFramesEndSy, ScriptEndSy, DivEndSy, SEndSy, StrikeEndSy, TREndSy,
      NoBrEndSy, StyleEndSy, SpanEndSy);

  TextBuffSize = 2000;

Type
  EParseError = class(Exception);
Var
  LCh, Ch: Char;
  SIndex: integer;
  LastChar: (lcOther, lcCR, lcLF);
  Value : integer;
  LCToken : TokenObj;
  LoadStyle: LoadStyleType;
  Buffer, BuffEnd: PChar;

  IBuff, IBuffEnd: PChar;
  IncludeEvent: TIncludeType;
  CallingObject: TObject;
  SaveLoadStyle: LoadStyleType;
  SoundEvent: TSoundType;
  MetaEvent: TMetaType;

function GetAttribute(var Sym: Symb; var St, S: String; var Val: integer): boolean; forward;

function PropStackIndex: integer;
begin
Result := PropStack.Count-1;
end;

function SymbToStr(Sy: Symb): string;
var
  I: integer;
begin
for I := 1 to MaxRes do
  if ResSy[I] = Sy then
    begin
    Result := Lowercase(ResWords[I]);
    Exit;
    end;
Result := '';
end;

function EndSymbToStr(Sy: Symb): string;
var
  I: integer;
begin
for I := 1 to MaxEndRes do
  if EndResSy[I] = Sy then
    begin
    Result := Lowercase(ResWords[I]);
    Exit;
    end;
Result := '';
end;

function EndSymbFromSymb(Sy: Symb): Symb;
var
  I: integer;
begin
for I := 1 to MaxEndRes do
  if ResSy[I] = Sy then
    begin
    Result := EndResSy[I];
    Exit;
    end;
Result := HtmlSy;  {won't match}
end;

function StrToSymb(const S: string): Symb;
var
  I: integer;
  S1: string;
begin
S1 := UpperCase(S);
for I := 1 to MaxRes do
  if ResWords[I] = S1 then
    begin
    Result := ResSy[I];
    Exit;
    end;
Result := OtherSy;
end;

function ReadChar: char;
begin
case LoadStyle of
  lsBuffer, lsFile, lsStream, lsStrings:
     begin
     if Buffer < BuffEnd then
       begin
       Result := Buffer^;
       Inc(Buffer);
       Inc(SIndex);
       end
     else
       Result := EOFChar;
     end;

  lsInclude:
     if IBuff < IBuffEnd then
       begin
       Result := IBuff^;
       Inc(IBuff);
       end
     else
       begin
       LoadStyle := SaveLoadStyle;
       Result := ReadChar;
       end;
  else Result := #0;       {to prevent warning msg}
  end;
end;

var
  InComment: boolean;   

{----------------GetchBasic; }
function GetchBasic: char; {read a character}
begin
LCh := ReadChar;
case LCh of    {skip a ^J after a ^M or a ^M after a ^J}
  ^M: if LastChar = lcLF then
        LCh := ReadChar;
  ^J: if LastChar = lcCR then
        LCh := ReadChar;
  end;
case LCh of
  ^M: LastChar := lcCR;
  ^J: begin
      LastChar := lcLF;
      LCh := ^M;
      end;
  else
      begin
      LastChar := lcOther;
      if LCh = Tab then LCh := ' ';
      end;
  end;
Ch := UpCase(LCh);
if (LCh = EofChar) and InComment then   
  Raise EParseError.Create('Open Comment at End of HTML File');
Result := LCh
end;

{-------------GetCh}
PROCEDURE GetCh;
{Return next char in Lch, its uppercase value in Ch.  Ignore comments}
var
  Done, Comment: boolean;   

  function Peek: char;  {take a look at the next char}
  begin
  case LoadStyle of
    lsBuffer, lsFile, lsStream, lsStrings:
       begin
       if Buffer < BuffEnd then
         Result := Buffer^
       else
         Result := EOFChar;
       end;

    lsInclude:
       if IBuff < IBuffEnd then
         Result := IBuff^
       else
         begin
         LoadStyle := SaveLoadStyle;
         Result := Peek;
         end;
    else Result := #0;       {to prevent warning msg}
    end;
  end;

  procedure DoDashDash;   {do the comment after a <!-- }
  begin
  repeat
    while Ch <> '-' do GetChBasic; {get first '-'}
    GetChBasic;
    if Ch = '-' then  {second '-'}
      begin
      while Ch = '-' do GetChBasic;  {any number of '-'}
      while (Ch = ' ') or (Ch = ^M) do GetChBasic;  {eat white space}
      Done := Ch = '>';
      end
    else Done := False;
  until Done;
  InComment := False;    
  end;

  procedure ReadToGT;    {read to the next '>' }
  begin
  while Ch <> '>' do
    GetChBasic;
  InComment := False;    
  end;

  procedure DoInclude;
  var
    S, SymStr, AttrStr: string;
    L: integer;
    Sym: Symb;
    BuffSize: integer;
    SL: TStringList;
  begin
  S := '';
  GetChBasic;
  while Ch in ['A'..'Z'] do
    begin
    S := S + LCh;
    GetChBasic;
    end;
  SL := TStringList.Create;
  while GetAttribute(Sym, SymStr, AttrStr, L) do
    SL.Add(SymStr+'="'+AttrStr+'"');
  DoDashDash;
  IncludeEvent(CallingObject, S, SL, IBuff, BuffSize);
  if BuffSize > 0 then
    begin
    SaveLoadStyle := LoadStyle;
    LoadStyle := lsInclude;
    IBuffEnd := IBuff+BuffSize;
    end;
  end;

begin  {Getch}
repeat    {in case a comment immediately follows another comment}
   {comments may be either '<! stuff >' or '<!-- stuff -->'  }
  Comment := False;
  GetchBasic;
  if (Ch = '<') and not InScript then
    begin
    if Peek = '!' then
      begin
      GetChBasic;
      Comment:=True;
      InComment := True;    
      GetChBasic;
      if Ch = '-' then
        begin
        GetChBasic;
        if Ch = '-' then
          begin
          GetChBasic;
          if Assigned(IncludeEvent) and (Ch = '#') and (LoadStyle <> lsInclude) then
            DoInclude
          else
            DoDashDash;  {a <!-- comment}
          end
        else ReadToGT;
        end
      else ReadToGT;
      end;
    end;
until not Comment;
end;

{-------------SkipWhiteSpace}
procedure SkipWhiteSpace;
begin
while (LCh in [' ', Tab, ^M]) do
  GetCh;
end;

{----------------GetValue}
function GetValue(var S: string; var Value: integer): boolean;
{read a numeric}
var
  Code: integer;
  ValD: double;
begin
Result := Ch in ['-', '+', '0'..'9'];
if not Result then Exit;
Value := 0;
if Ch in ['-', '+'] then
  begin
  S := Ch;
  GetCh;
  end
else S := '';
while not (Ch in [' ', Tab, ^M, '>', '%', EofChar]) do
  begin
  S := S + Ch;
  GetCh;
  end;
SkipWhiteSpace;
Val(S, ValD, Code);
if Code <> 0 then
  Value := 0
else Value := Round(ValD);
if LCh = '%' then
  begin
  S := S + '%';
  GetCh;
  end;
end;

{----------------IsOddChar}
function IsOddChar : boolean;
const
  Lim = 8;
  MaxChars = Lim+96;
  OddCharStr : array[1..MaxChars] of string[6] =
    ('amp', 'lt', 'gt', 'quot', 'rsquo', 'ndash', 'trade', 'hellip', {Lim special items}
'nbsp',      {no-break space}
'iexcl',     {inverted exclamation mark}
'cent',      {cent sign}
'pound',     {pound sterling sign}
'curren',    {general currency sign}
'yen',       {yen sign}
'brvbar',    {broken (vertical) bar}
'sect',      {section sign}
'uml',       {umlaut (dieresis)}
'copy',      {copyright sign}
'ordf',      {ordinal indicator', feminine}
'laquo',     {angle quotation mark', left}
'not',       {not sign}
'shy',       {soft hyphen}
'reg',       {registered sign}
'macr',      {macron}
'deg',       {degree sign}
'plusmn',    {plus-or-minus sign}
'sup2',      {superscript two}
'sup3',      {superscript three}
'acute',     {acute accent}
'micro',     {micro sign}
'para',      {pilcrow (paragraph sign)}
'middot',    {middle dot}
'cedil',     {cedilla}
'sup1',      {superscript one}
'ordm',      {ordinal indicator', masculine}
'raquo',     {angle quotation mark', right}
'frac14',    {fraction one-quarter}
'frac12',    {fraction one-half}
'frac34',    {fraction three-quarters}
'iquest',    {inverted question mark}

'Agrave',    {Capital A, grave accent}
'Aacute',    {Capital A, acute accent}
'Acirc',     {Capital A, circumflex accent}
'Atilde',    {Capital A, tilde}
'Auml',      {Capital A, dieresis or umlaut mark}
'Aring',     {Capital A, ring}
'AElig',     {Capital AE dipthong (ligature)}
'Ccedil',    {Capital C, cedilla}
'Egrave',    {Capital E, grave accent}
'Eacute',    {Capital E, acute accent}
'Ecirc',     {Capital E, circumflex accent}
'Euml',      {Capital E, dieresis or umlaut mark}
'Igrave',    {Capital I, grave accent}
'Iacute',    {Capital I, acute accent}
'Icirc',     {Capital I, circumflex accent}
'Iuml',      {Capital I, dieresis or umlaut mark}
'ETH',       {Capital Eth, Icelandic}
'Ntilde',    {Capital N, tilde}
'Ograve',    {Capital O, grave accent}
'Oacute',    {Capital O, acute accent}
'Ocirc',     {Capital O, circumflex accent}
'Otilde',    {Capital O, tilde}
'Ouml',      {Capital O, dieresis or umlaut mark}
'times',          {missing}
'Oslash',    {Capital O, slash}
'Ugrave',    {Capital U, grave accent}
'Uacute',    {Capital U, acute accent}
'Ucirc',     {Capital U, circumflex accent}
'Uuml',      {Capital U, dieresis or umlaut mark}
'Yacute',    {Capital Y, acute accent}
'THORN',     {Capital THORN, Icelandic}
'szlig',     {Small sharp s, German (sz ligature)}
'agrave',    {Small a, grave accent}
'aacute',    {Small a, acute accent}
'acirc',     {Small a, circumflex accent}
'atilde',    {Small a, tilde}
'auml',      {Small a, dieresis or umlaut mark}
'aring',     {Small a, ring}
'aelig',     {Small ae dipthong (ligature)}
'ccedil',    {Small c, cedilla}
'egrave',    {Small e, grave accent}
'eacute',    {Small e, acute accent}
'ecirc',     {Small e, circumflex accent}
'euml',      {Small e, dieresis or umlaut mark}
'igrave',    {Small i, grave accent}
'iacute',    {Small i, acute accent}
'icirc',     {Small i, circumflex accent}
'iuml',      {Small i, dieresis or umlaut mark}
'eth',       {Small eth, Icelandic}
'ntilde',    {Small n, tilde}
'ograve',    {Small o, grave accent}
'oacute',    {Small o, acute accent}
'ocirc',     {Small o, circumflex accent}
'otilde',    {Small o, tilde}
'ouml',      {Small o, dieresis or umlaut mark}
'divide',          {missing}
'oslash',    {Small o, slash}
'ugrave',    {Small u, grave accent}
'uacute',    {Small u, acute accent}
'ucirc',     {Small u, circumflex accent}
'uuml',      {Small u, dieresis or umlaut mark}
'yacute',    {Small y, acute accent}
'thorn',     {Small thorn, Icelandic}
'yuml');     {Small y, dieresis or umlaut mark}


  OddChar : array[1..Lim] of string[3] =
    ('&', '<', '>', '"', '''', '-', #153, '...');  
Label 2;
var
  I, J, N: integer;
  S: string[8];
  Collect: TokenObj;   
  SaveIndex: integer;
  W: WideChar;

  procedure NextCh; 
  begin {collect chars and Indices in case of failure}
  Collect.AddChar(LCh, SIndex);
  GetCh;
  end;

begin
if Ch <> '&' then
  begin
  Result := False;
  Exit;
  end;
Result := True;
Sy := TextSy;
I := 0;
S := '';
SaveIndex := SIndex;  
Collect := TokenObj.Create;  
try
  NextCh;
  if Ch = '#' then
    begin   {look for char #}
    NextCh;
    while I <=5 do
      begin
      if not (Ch in ['0'..'9']) then
        begin
        if Ch = ';' then NextCh;
        if S <> '' then
          begin
          N := StrToInt(S);
          if (N > 255) then    
            begin     
            W := WideChar(N);
            S := WideCharLenToString(@W, 1);
            LCToken.AddChar(S[1], SaveIndex);
            GoTo 2;
            end
          else if (byte(N) in [9, 10, 32..255]) then
            begin
            if N = 9 then LCToken.AddChar(' ', SaveIndex)
            else LCToken.AddChar(chr(N), SaveIndex);
            GoTo 2;
            end;
          end;
        LCToken.Concat(Collect);
        GoTo 2;
        end;
      S := S+LCh;
      Inc(I);
      NextCh;
      end;
    LCToken.Concat(Collect);
    GoTo 2;
    end
  else while I <= 6 do
    begin
    if not (Ch in ['A'..'Z', '0'..'9']) then  {note: Ch is always upper case}
      begin
      if Ch = ';' then NextCh;
      for  J := 1 to MaxChars do
        if S = OddCharStr[J] then
          begin
          if J <= Lim then
            if S = 'hellip' then
              begin
              LCToken.AddChar('.', SaveIndex);  
              LCToken.AddChar('.', SaveIndex+1);  
              LCToken.AddChar('.', SaveIndex+2);  
              end
            else
              LCToken.AddChar(OddChar[J][1], SaveIndex)
          else LCToken.AddChar(chr(J - Lim + 159), SaveIndex);
          GoTo 2;
          end;
      LCToken.Concat(Collect);
      GoTo 2;
      end;
    S := S+LCh;
    Inc(I);
    NextCh;
    end;
  {too many chars, assume it's just text}
  LCToken.Concat(Collect);
2:
finally
  Collect.Free;
  end;
end;

{----------------GetQuotedStr}
function GetQuotedStr(var S: String; var Value: integer): boolean;
{get a quoted string but strip the quotes, check to see if it is numerical}
var
  Term: char;
  S1: string;
  Code: integer;
  ValD: double;
  SaveSy: Symb;
begin
Result := False;
Term := Ch;
if (Term <> '"') and (Term <> '''') then Exit;
Result := True;
SaveSy := Sy;
GetCh;
while not (Ch in [Term, EofChar]) do
  begin
  if LCh <> ^M then
    begin
    if IsOddChar then  
      begin
      S := S + LCToken.S;
      LCToken.Clear;       
      end
    else
      begin
      S := S + LCh;
      GetCh;
      end;
    end
  else GetCh;   {pass ^M by}
  end;
if Ch = Term then GetCh;  {pass termination char}
S1 := Trim(S);
if Pos('%', S1) = Length(S1) then SetLength(S1, Length(S1)-1);
Val(S1, ValD, Code);
if Code <> 0 then
  Value := 0
else Value := Round(ValD);
Sy := SaveSy;
end;

{----------------GetSomething}
procedure GetSomething(var S: String);

begin
while not (Ch in [' ', Tab, ^M, '>', EofChar]) do
  begin
  S := S+LCh;
  GetCh;
  end;
end;

{----------------GetID}
function GetID(var S: String): boolean;

begin
Result := False;
if not (Ch in ['A'..'Z']) then Exit;
while Ch in ['A'..'Z', '-'] do
  begin
  S := S+Ch;
  GetCh;
  end;
Result := True;
end;

{----------------GetAttribute}
function GetAttribute(var Sym: Symb; var St, S: String; var Val: integer): boolean;

const
  MaxAttr = 71;
  Attrib : array[1..MaxAttr] of string[16] =
     ('HREF', 'NAME', 'SRC', 'ALT', 'ALIGN', 'TEXT', 'BGCOLOR', 'LINK',
      'BACKGROUND', 'COLSPAN', 'ROWSPAN', 'BORDER', 'CELLPADDING',
      'CELLSPACING', 'VALIGN', 'WIDTH', 'START', 'VALUE', 'TYPE',
      'CHECKBOX', 'RADIO', 'METHOD', 'ACTION', 'CHECKED', 'SIZE',
      'MAXLENGTH', 'COLS', 'ROWS', 'MULTIPLE', 'VALUE', 'SELECTED',
      'FACE', 'COLOR', 'TRANSP', 'CLEAR', 'ISMAP', 'BORDERCOLOR',
      'USEMAP', 'SHAPE', 'COORDS', 'NOHREF', 'HEIGHT', 'PLAIN', 'TARGET',
      'NORESIZE', 'SCROLLING', 'HSPACE', 'LANGUAGE', 'FRAMEBORDER',
      'MARGINWIDTH', 'MARGINHEIGHT', 'LOOP', 'ONCLICK', 'WRAP', 'NOSHADE',
      'HTTP-EQUIV', 'CONTENT', 'ENCTYPE', 'VLINK', 'OLINK', 'ACTIVE',
      'VSPACE', 'CLASS', 'ID', 'STYLE', 'REL', 'REV', 'NOWRAP',
      'BORDERCOLORLIGHT', 'BORDERCOLORDARK', 'CHARSET');
  AttribSym: array[1..MaxAttr] of Symb =
     (HrefSy, NameSy, SrcSy, AltSy, AlignSy, TextSy, BGColorSy, LinkSy,
      BackgroundSy, ColSpanSy, RowSpanSy, BorderSy, CellPaddingSy,
      CellSpacingSy, VAlignSy, WidthSy, StartSy, ValueSy, TypeSy,
      CheckBoxSy, RadioSy, MethodSy, ActionSy, CheckedSy, SizeSy,
      MaxLengthSy, ColsSy, RowsSy, MultipleSy, ValueSy, SelectedSy,
      FaceSy, ColorSy, TranspSy, ClearSy, IsMapSy, BorderColorSy,
      UseMapSy, ShapeSy, CoordsSy, NoHrefSy, HeightSy, PlainSy, TargetSy,
      NoResizeSy, ScrollingSy, HSpaceSy, LanguageSy, FrameBorderSy,
      MarginWidthSy, MarginHeightSy, LoopSy, OnClickSy, WrapSy, NoShadeSy,
      HttpEqSy, ContentSy, EncTypeSy, VLinkSy, OLinkSy, ActiveSy,
      VSpaceSy, ClassSy, IDSy, StyleSy, RelSy, RevSy, NoWrapSy,
      BorderColorLightSy, BorderColorDarkSy, CharSetSy);   
var
  I: integer;
begin
Sym := OtherAttribute;
Result := False;
SkipWhiteSpace;
St := '';
if GetID(St) then
  begin
  for I := 1 to MaxAttr do
    if St = Attrib[I] then
      begin
      Sym := AttribSym[I];
      Break;
      end;
  end
else Exit;   {no ID}
SkipWhiteSpace;
S := '';
if Sym = BorderSy then Val := 1 else Val := 0;
Result := True;      {at least have an ID}
if Ch <> '=' then Exit;
GetCh;

SkipWhiteSpace;
if not GetQuotedStr(S, Val) then   {either it's a quoted string or a number}
if not GetValue(S, Val) then
  GetSomething(S);    {in case quotes left off string}
if (Sym = IDSy) and (S <> '') then
  MasterList.IDNameList.AddChPosObject(S, SIndex);
end;

{-------------GetTag}
function GetTag: boolean;  {Pick up a Tag or pass a single '<'}
Var
  Done, EndTag : Boolean;
  Compare: String[255];
  SymStr, AttrStr: string;
  I: Integer;
  L: integer;
  Save: integer;  
  Sym: Symb;
begin
if Ch <> '<' then
  begin
  Result := False;
  Exit;
  end
else Result := True;
Save := SIndex;   
TagIndex := SIndex;  
Compare := '';
GetCh;
if Ch = '/' then
  begin
  EndTag := True;
  GetCh;
  end
else if not (Ch in ['A'..'Z']) then
  begin     {an odd '<'}
  Sy := TextSy;
  LCToken.AddChar('<', Save);
  Exit;
  end
else
  EndTag := False;
Sy := CommandSy;
Done := False;
while not Done do
  case Ch of
    'A'..'Z' :
          begin
          if Length(Compare) < 255 then
            begin
            Inc(Compare[0]);
            Compare[Length(Compare)] := Ch;
            end;
          GetCh;
          end;
    else Done := True;
   end;
for I := 1 to MaxRes do
  if Compare = ResWords[I] then
    begin
    if not EndTag then
      Sy := ResSy[I]
    else
      if I <= MaxEndRes then
        Sy := EndResSy[I];   {else Sy  := CommandSy}
    Break;
    end;
SkipWhiteSpace;
Value := 0;
if ((Sy = HeadingSy) or (Sy = HeadingEndSy)) and (Ch in ['1'..'6']) then
  begin
  Value := ord(Ch)-ord('0');
  GetCh;
  end;

Attributes.Clear;
while GetAttribute(Sym, SymStr, AttrStr, L) do
    Attributes.Add(TAttribute.Create(Sym, L, AttrStr));

while (Ch <> '>') and (Ch <> EofChar) do
  GetCh;
if Sy <> StyleSy then {in case <!-- comment immediately follows}
  GetCh;
end;

{----------------IsText}
function IsText : boolean;
begin
LCToken.Clear;   
while (LCToken.Leng < 100) and   
      (LCh in [^M, ' '..'%', ''''..';', '=', '?'..#255, '>']) do
  if not PreFormat and ((LCh = ' ') or (LCh = ^M)) then
    begin
    if NoBreak then
      LCToken.AddChar(nbSp, SIndex)  {nbSp is NoBreak space representation} 
    else 
      LCToken.AddChar(' ', SIndex);   {^M becomes space}
    SkipWhiteSpace;      {eliminate multiple spaces}
    end
  else
    begin
    LCToken.AddChar(LCh, SIndex);  
    GetCh;
    end;
if LCToken.Leng > 0 then  
  begin
  Sy := TextSy;
  IsText := True;
  end
else IsText := False;
end;

{-----------Next}
PROCEDURE Next;
  {Get the next token}
begin  {already have fresh character loaded here}
LCToken.Clear;
if LCh = EofChar then Sy := EofSy
else if GetTag then     {handles '<'}  
else if IsOddChar then
else if IsText then
else
  begin
  Sy := OtherChar;
  LCToken.AddChar(LCh, SIndex);
  GetCh;
  end;
end;

function PushNewProp(const Tag, AClass, AnID, APseudo: string; AProp: TProperties): boolean;
{add a TProperties to the Prop stack}
begin
PropStack.Add(TProperties.Create);
PropStack.Last.Inherit(PropStack[PropStackIndex-1]);
PropStack.Last.Combine(MasterList.Styles, Tag, AClass, AnID, APseudo, AProp);
Result := True;
end;

procedure PopProp;
{pop and free a TProperties from the Prop stack}
begin
if PropStackIndex > 0 then
  PropStack.Delete(PropStackIndex);
end;

procedure PopAProp(Tag: string);
{pop and free a TProperties from the Prop stack.  It should be on top but in
 case of a nesting error, find it anyway}
var
  I, J: integer;
begin
for I := PropStackIndex downto 1 do
  if PropStack[I].Proptag = Tag then
    begin
    PropStack.Delete(I);
    if I > 1 then      {update any stack items which follow the deleted one}
      for J := I to PropStackIndex do
        PropStack[J].Update(PropStack[J-1], MasterList.Styles, J);
    Break;
    end;
end;

procedure DoTextArea(TxtArea: TTextAreaFormControlObj);
{read and save the text for a TextArea form control}
var
  S: string;
  Token: string;

  procedure Next1;
    {Special Next routine to get the next token}
    procedure GetTag1;  {simplified Pick up a Tag routine}
    begin
    Token := '<';
    GetCh;
    Sy := CommandSy;
    while not (LCh in [' ', ^M, Tab, '>']) do
      begin
      Token := Token + LCh;
      GetCh;
      end;
    if CompareText(Token, '</textarea') = 0 then
      Sy := TextAreaEndSy
    else Sy := CommandSy;    {anything else}
    end;

    function IsText1 : boolean;
    begin
    while (Length(Token) < 100) and  not (LCh in [^M, '<', '&', EofChar]) do
      begin
      Token := Token+LCh;
      GetCh;
      end;
    if Length(Token) > 0 then
      begin
      Sy := TextSy;
      IsText1 := True;
      end
    else IsText1 := False;
    end;

  begin  {already have fresh character loaded here}
  Token := '';
  LCToken.Clear;     
  if LCh = EofChar then Sy := EofSy
  else if LCh = ^M then
    begin
    Sy := EolSy;
    GetCh;
    end
  else if LCh = '<' then
     begin GetTag1;  Exit;  end
  else if IsOddChar then
    Token := LCToken.S
  else if IsText1 then
  else
    begin
    Sy := OtherChar;
    Token := LCh;
    GetCh;
    end;
  end;

begin
Next1;
S := '';
while (Sy <> TextAreaEndSy) and (Sy <> EofSy) do
  begin
  case Sy of
    TextSy: S := S + Token;
    EolSy:
      begin
      if TxtArea.Wrap = wrOff then  
        S := S+^M^J
      else S := S+' ';
      TxtArea.AddStr(S);
      S := '';
      end;
    else
      S := S + Token;
    end;
  Next1;
  end;
while not (LCh in ['>', EofChar]) do
  GetCh; {remove chars to and past '>'}
GetCh;
if S <> '' then TxtArea.AddStr(S);
TxtArea.ResetToValue;
end;

function FindAlignment: string;  {pick up Align= attribute}  
var
  T: TAttribute;
  S: string;
begin
Result := '';
if Attributes.Find(AlignSy, T) then
  begin
  S := LowerCase(T.Name);
  if (S = 'left') or (S = 'center') or (S = 'right') then
    Result := S;
  end;
end;

procedure CheckForAlign;
var
  S: string;
begin
S := FindAlignment;
if S <> '' then
  PropStack.Last.Assign(S, TextAlign);    
end;

type
  SymbSet = Set of Symb;
const
  TableTermSet = [TableEndSy, TDSy, TRSy, TREndSy, THSy, THEndSy, TDEndSy,
                  CaptionSy, CaptionEndSy];

procedure DoBody(const TermSet: SymbSet); forward;

procedure DoLists(Sym: Symb; const TermSet: SymbSet); forward;

procedure DoAEnd;  {do the </a>}
begin
if InHref then   {see if we're in an href}
  begin
  CurrentUrlTarget.Clear;
  InHref := False;
  end;
PopAProp('a');
if Assigned(Section) then
  Section.HRef(AEndSy, MasterList, CurrentUrlTarget, PropStack.Last); 
end;

procedure DoDivEtc(Sym: Symb; const TermSet: SymbSet);
var
  FormBlock, DivBlock: TBlock;
begin
case Sym of
  DivSy:
    begin
    SectionList.Add(Section);
    PushNewProp('div', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
    CheckForAlign;

    DivBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
    SectionList.Add(DivBlock);
    SectionList := DivBlock.MyCell;

    Section := TSection.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
    Next;
    DoBody([DivEndSy]+TermSet);
    SectionList.Add(Section);
    PopAProp('div');
    SectionList.CheckLastBottomMargin;

    SectionList := DivBlock.OwnerCell;

    Section := TSection.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
    if Sy in [DivEndSy] then
      Next;
    end;
  CenterSy:
    begin
    SectionList.Add(Section);
    PushNewProp('center', '', '', '', Nil);
    Section := TSection.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
    Next;
    DoBody([CenterEndSy]+TermSet);
    SectionList.Add(Section);
    PopAProp('center');
    Section := TSection.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
    if Sy in [CenterEndSy] then
      Next;
    end;
  FormSy:
    repeat
      SectionList.Add(Section);
      Section := Nil;
      PushNewProp('form', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
      FormBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
      SectionList.Add(FormBlock);
      SectionList := FormBlock.MyCell;

      CurrentForm := ThtmlForm.Create(MasterList, Attributes);

      Next;
      DoBody(TermSet+[FormEndSy, FormSy]);

      SectionList.Add(Section);
      Section := Nil;
      PopAProp('form');
      SectionList.CheckLastBottomMargin;
      SectionList := FormBlock.OwnerCell;
      if Sy = FormEndSy then
        begin
        CurrentForm := Nil;
        Next;
        end;
    until Sy <> FormSy;  {in case <form> terminated by andother <form>}
  BlockQuoteSy, AddressSy:
    begin
    SectionList.Add(Section);
    Section := Nil;
    DoLists(Sy, TermSet);
    Next;
    end;
  else Next;
  end;
end;

{----------------DoTable}
procedure DoTable;
var
  Table: ThtmlTable;
  SaveSectionList, JunkSaveSectionList: TCellBasic;
  SaveStyle: TFontStyles;
  SaveNoBreak: boolean;
  SaveListLevel: integer;       
  RowVAlign, VAlign: AlignmentType;
  Row: TCellList;
  CellObj: TCellObj;
  T: TAttribute;
  RowStack: integer;
  NewBlock: TTableBlock;
  SetJustify: JustifyType;    

  function GetVAlign(Default: AlignmentType): AlignmentType;
  var
    S: string[9];
    T: TAttribute;
  begin
  Result := Default;
  if Attributes.Find(VAlignSy, T) then
    begin
    S := LowerCase(T.Name);
    if (S = 'top') or (S = 'baseline') then Result := ATop  
    else if S = 'middle' then Result := AMiddle
    else if (S = 'bottom') then Result := ABottom;
    end;
  end;

  procedure AddSection;
  begin
  if Assigned(SectionList) then
    begin
    SectionList.Add(Section);
    Section := Nil;
    if CellObj.Cell = SectionList then
      begin
      SectionList.CheckLastBottomMargin;
      Row.Add(CellObj);
      end
    else
    {$ifdef DebugIt}
    ShowMessage('Table cell error, ReadHTML.pas, DoTable')   
    {$endif}
    ;
    SectionList := Nil;
    end;
  end;

begin
Inc(TableLevel);   
if TableLevel > 10 then
  begin
  Next;
  Exit;
  end;
if InHref then DoAEnd;    {terminate <a>}
SectionList.Add(Section);
Section := Nil;
SaveSectionList := SectionList;
SaveStyle := CurrentStyle;
SaveNoBreak := NoBreak;
SaveListLevel := ListLevel;   
SectionList := Nil;
if PropStack.Last.Props[TextAlign] = 'center' then   
  SetJustify := centered
else if PropStack.Last.Props[TextAlign] = 'right' then
  SetJustify := Right
else SetJustify := NoJustify;
PushNewProp('table', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
Table := ThtmlTable.Create(MasterList, Attributes, PropStack.Last,  
            SaveSectionList);
NewBlock := TTableBlock.Create(MasterList, PropStack.Last,
	SaveSectionList, Table, Attributes, TableLevel);   
if (NewBlock.Justify <> Centered) and not (NewBlock.FloatLR in [ALeft, ARight]) then   
  NewBlock.Justify := SetJustify;   
NewBlock.MyCell.Add(Table);  {the only item in the cell}
try
  Row := Nil;
  RowVAlign := AMiddle;
  RowStack := PropStackIndex;   {to prevent warning message}
  Next;
  while (Sy <> TableEndSy) and (Sy <> EofSy) do
    case Sy of
      TDSy, THSy:
        Begin
        if InHref then DoAEnd;
        CurrentStyle := SaveStyle;
        ListLevel := 0;     
        if not Assigned(Row) then   {in case <tr> is missing}
          begin
          RowVAlign := AMiddle;
          RowStack := PropStackIndex;
          PushNewProp('tr', '', '', '', Nil);
          Row := TCellList.Create(Nil, PropStack.Last);
          end
        else
          begin
          AddSection;
          while PropStackIndex > RowStack+1 do
            PopProp;          {back stack off to Row item}
          end;
        if Sy = THSy then
          begin
          PushNewProp('th', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
          CheckForAlign;     {see if there is Align override}
          if PropStack.Last.Props[TextAlign] = 'none' then
            PropStack.Last.Assign('center', TextAlign);    
          end
        else
          begin
          PushNewProp('td', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
          CheckForAlign;     {see if there is Align override}
          if PropStack.Last.Props[TextAlign] = 'none' then
            PropStack.Last.Assign('left', TextAlign);    
          end;
        VAlign := GetVAlign(RowVAlign);
        CellObj := TCellObj.Create(MasterList, VAlign, Attributes, PropStack.Last);
        SectionList := CellObj.Cell;
        if ((CellObj.WidthAttr = 0) or CellObj.AsPercent) and Attributes.Find(NoWrapSy, T) then   {!!}
          NoBreak := True
        else NoBreak := False;
        SkipWhiteSpace;
        Next;
        DoBody(TableTermSet);
        end;
      CaptionSy:
        begin
        if InHref then DoAEnd;
        CurrentStyle := SaveStyle;
        NoBreak := False;
        AddSection;
        if Attributes.Find(AlignSy, T) then
          Table.TopCaption := Lowercase(T.Name) <> 'bottom';
        SectionList := Table.Caption.Cell;
        PushNewProp('caption', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
        Next;
        DoBody(TableTermSet);

        SectionList.Add(Section);
        PopAProp('caption');
        Section := Nil;
        SectionList := Nil;
        if Sy = CaptionEndSy then Next;  {else it's TDSy, THSy, etc}
        end;
      TREndSy:
        begin
        if InHref then DoAEnd;
        if Assigned(Row) then
          begin
          AddSection;
          Table.Rows.Add(Row);
          Row := Nil;
          while PropStackIndex > RowStack do
            PopProp;
          end;
        Next;
        end;
      TRSy:
        begin
        if InHref then DoAEnd;
        if Assigned(Row) then
          begin
          AddSection;
          Table.Rows.Add(Row);
          while PropStackIndex > RowStack do
            PopProp;
          end;
        RowStack := PropStackIndex;
        PushNewProp('tr', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
        CheckForAlign;
        Row := TCellList.Create(Attributes, PropStack.Last);
        RowVAlign := GetVAlign(AMiddle);
        Next;
        end;
      TDEndSy, THEndSy:
        begin AddSection; Next; end;
      TextSy:
        begin
        JunkSaveSectionList := SectionList;
        SectionList := SaveSectionList;   {the original one}
        DoBody(TableTermSet);
        SectionList.Add(Section);
        Section := Nil;
        SectionList := JunkSaveSectionList;
        end;
      else Next;  {ignore all else}
      end;
  if InHref then DoAEnd;
  AddSection;
  if Assigned(Row) then
    begin
    Table.Rows.Add(Row);
    while PropStackIndex > RowStack do
      PopProp;
    end;
finally
  PopaProp('table');
  SectionList := SaveSectionList;
  SectionList.Add(NewBlock);
  CurrentStyle := SaveStyle;
  NoBreak := SaveNoBreak;
  ListLevel := SaveListLevel;    
  Dec(TableLevel);    
  end;
Next;
end;

procedure GetOptions(Select: TListBoxFormControlObj);
 {get the <option>s for Select form control}
var
  Selected, InOption, ValueFound: boolean;
  Value, S: string[255];
  T: TAttribute;
  SaveNoBreak: boolean;
begin
SaveNoBreak := NoBreak;
NoBreak := False;
Next;
S := '';  Value := '';
Selected := False;  InOption := False;
ValueFound := False;
while not (Sy in[SelectEndSy, InputSy, PSy, EofSy]+TableTermSet) do
  begin
  case Sy of
    OptionSy, OptionEndSy:
      begin
      S := Trim(S);
      if InOption then
        begin
        if not ValueFound then   
          Value := S;
        Select.AddStr(S, Value, Selected);
        end;
      S := '';
      Value := '';
      Selected := False;
      InOption := Sy = OptionSy;
      if InOption then
        begin
        Selected := Attributes.Find(SelectedSy, T);
        ValueFound := Attributes.Find(ValueSy, T);  
        if ValueFound then
          Value := T.Name;
        end;
      end;
    TextSy: if InOption then
              S := S+LCToken.S;  
    end;
  Next;
  end;
if InOption then
  begin
  S := Trim(S);
  if not ValueFound then   
    Value := S;
  Select.AddStr(S, Value, Selected);
  end;
Select.ResetToValue;
NoBreak := SaveNoBreak;   
end;

{----------------DoMap}
procedure DoMap;
var
  Item: TMapItem;
  T: TAttribute;
  ErrorCnt: integer;
begin
Item := TMapItem.Create;
ErrorCnt := 0;
try
  if Attributes.Find(NameSy, T) then
    Item.MapName := Uppercase(T.Name);
  Next;
  while (Sy <> MapEndSy) and (Sy <> EofSy) and (ErrorCnt < 3) do
    begin
    if Sy = AreaSy then Item.AddArea(Attributes)
    else if Sy <> TextSy then
      Inc(ErrorCnt);
    Next;
    end;
  if Sy = MapEndSy then MasterList.MapList.Add(Item)
    else Item.Free;
except
  Item.Free;
  Raise;
  end;
Next;
end;

procedure DoScript(Ascript: TScriptEvent);
const
  Block = 32500;
var
  Lang, AName: string;
  T: TAttribute;
  Buffer: PChar;
  Pos, Size: integer;

  procedure AddText(const S: string);
  begin
  if Pos + Length(S) >= Size then
      begin   {Delphi 2,3, add to buffer}
      ReAllocMem(Buffer, Size+10000);
      Inc(Size, 10000);
      end;
  Move(S[1], Buffer[Pos], Length(S));
  Inc(Pos, Length(S));
  end;

  procedure Next1;
    {Special Next routine to get the next token}
    procedure GetTag1;  {simplified 'Pick up a Tag' routine}
    var
      Count: integer;
    begin
    LCToken.AddChar('<', SIndex);
    GetCh;
    Sy := CommandSy;   {catch all}
    Count := 0;
    while (Ch in ['A'..'Z', '/']) and (Count <= 6) do
      begin
      LCToken.AddChar(LCh, SIndex);
      GetCh;
      Inc(Count);
      end;
    if LCh = '>' then
      begin
      LCToken.AddChar(LCh, SIndex);
      GetCh;
      end;
    if CompareText(LCToken.S, '</script>') = 0 then
      Sy := ScriptEndSy;
    end;

  begin  {already have fresh character loaded here}
  LCToken.Clear;
  if LCh = EofChar then Sy := EofSy
  else if LCh = ^M then
    begin
    Sy := EolSy;
    GetCh;
    end
  else if LCh = '<' then
     GetTag1
  else
    begin
    Sy := TextSy;
    while (LCToken.Leng < 100) and  not (LCh in [^M, '<', EofChar]) do 
      begin
      LCToken.AddChar(LCh, SIndex);
      GetCh;
      end;
    end;
  end;

begin
try
  if Assigned(AScript) then
    begin
    InScript := True;
    if Attributes.Find(LanguageSy, T) then
      Lang := T.Name
    else Lang := '';
    if Attributes.Find(NameSy, T) then 
      AName := T.Name
    else AName := '';                  

    GetMem(Buffer, Block);
    Pos := 0;
    Size := Block;
    try
      Next1;
      while (Sy <> ScriptEndSy) and (Sy <> EofSy) do
        begin
        if Sy = EolSy then AddText(^M^J)
        else
          AddText(LCToken.S);  
        Next1;
        end;
      AddText(#0);
      ReAllocMem(Buffer, Size);
      AScript(CallingObject, AName, Lang, Buffer);
    except
      FreeMem(Buffer);
      Raise;
      end;
    end
  else
    begin
    repeat
      Next1;
    until Sy in [ScriptEndSy, EofSy];
    end;
finally
  InScript := False;
  end;
end;

procedure DoP(const TermSet: SymbSet); forward;
procedure DoBr(const TermSet: SymbSet); forward;

const
  FontConvBase: array[1..7] of double = (8.0,10.0,12.0,14.0,18.0,24.0,36.0);
  PreFontConvBase:  array[1..7] of double = (7.0,8.0,10.0,12.0,15.0,20.0,30.0);

var
  FontConv: array[1..7] of double;
  PreFontConv:  array[1..7] of double;

procedure InitializeFontSizes(Size: integer);   
var
  I: integer;
begin
for I := 1 to 7 do
  begin
  FontConv[I] := FontConvBase[I] * Size / 12.0;
  PreFontConv[I] := PreFontConvBase[I] * Size / 12.0;
  end;
end;

{----------------DoCommonSy}
procedure DoCommonSy;
var
  I: integer;
  TxtArea: TTextAreaFormControlObj;
  FormControl: TFormControlObj;
  T: TAttribute;
  Tmp: string;
  HeadingBlock: TBlock;
  HRBlock: THRBlock;
  HorzLine: THorzLine;
  HeadingStr, Link: string;
  Done, FoundHRef: boolean;
  IO: TImageObj;
  Page: TPage;

  function ChangeTheFont(Sy: Symb; Pre: boolean): boolean;
  var
    FaceName: string;   
    CharSetName: string;  
    NewColor: TColor;
    NewSize, I: integer;
    FontResults: set of (Face, Colr, Siz, CharS);   
    DNewSize: double;    
  begin
  FontResults := [];
  NewSize := 0;  {get rid of warning}
  for I := 0 to Attributes.Count-1 do
    with TAttribute(Attributes[I]) do
      case Which of
        SizeSy:
          begin
          if (Length(Name) >= 2) and (Name[1] in ['+', '-']) then
            Value := BaseFontSize + Value;
          NewSize := IntMax(1, IntMin(7, Value)); {limit 1..7}
          if (Sy = BaseFontSy) then BaseFontSize := NewSize;
          Include(FontResults, Siz);
          end;
        ColorSy:
          if ColorFromString(Name, False, NewColor) then
            Include(FontResults, Colr);
        FaceSy:
          if (Sy <> BaseFontSy) and (Name <> '') then
            begin
            FaceName := Name;
            if FaceName <> '' then
              Include(FontResults, Face);
            end;
        CharSetSy:         
          if Pos('CHARSET', Uppercase(Name)) > 0 then
            begin
            CharSetName := Name;
            Include(FontResults, CharS)
            end;
        end;
  Result := False;
  if PushNewProp('font', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle)
                         and (FontResults <> []) then
    begin
    PropStack.Last.SetFontBG;
    if Colr in FontResults then
      begin
        PropStack.Last.Assign(NewColor or $2000000, StyleUn.Color);
      end;
   if Siz in FontResults then
      begin
      if Pre then DNewSize := PreFontConv[NewSize]   
      else DNewSize := FontConv[NewSize];
      PropStack.Last.Assign(double(DNewSize), FontSize);
      end;
    if Face in FontResults then
      begin
      PropStack.Last.Assign(ReadFontName(FaceName), FontFamily);
      end;
    if CharS in FontResults then  
      begin
      PropStack.Last.AssignCharset(CharSetName);
      end;
    Result := True;
    end;
  end;

  procedure DoPreSy;
  var
    S: TokenObj;
    Tmp, Link: String;
    Done, InForm, InP: boolean;
    I, InitialStackIndex: integer;
    PreBlock, FormBlock, PBlock: TBlock;
    SaveSy: Symb;
    FoundHRef: boolean;

    procedure FormEnd;
    begin
    CurrentForm := Nil;
    if Assigned(Section) then   
      begin
      Section.AddTokenObj(S);
      SectionList.Add(Section);
      end;
    S.Clear;      
    Section := Nil;   
    PopAProp('form');
    SectionList := FormBlock.OwnerCell;
    InForm := False;
    end;

    procedure PEnd;
    begin
    Section.AddTokenObj(S);
    S.Clear;
    if Section.Len > 0 then
      SectionList.Add(Section)
    else
      begin
      Section.CheckFree;
      Section.Free;
      end;
    Section := Nil;   
    PopAProp('p');
    SectionList := PBlock.OwnerCell;
    InP := False;
    end;

    procedure NewSection;
    begin
    Section.AddTokenObj(S);
    S.Clear;
    SectionList.Add(Section);
    Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
    end;

  begin
  InForm := False;
  InP := False;     
  S := TokenObj.Create;
  FormBlock := Nil;
  try
    SectionList.Add(Section);
    PushNewProp('pre', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
    InitialStackIndex := PropStackIndex;
    PreBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
    SectionList.Add(PreBlock);
    SectionList := PreBlock.MyCell;
    Section := TPreformated.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
    S.Clear;
    PreFormat := True;
    Done := False;
    while not Done do
      case Ch of
        '&': begin
             Next;
             S.Concat(LCToken);
             end;
        '<':
           begin
           Next;
           case Sy of
             BRSy:
               begin
               NewSection;
               if Ch = ^M then GetCh;
               end;
             PSy:
               begin         
               if InP then
                 PEnd
               else
                 if S.Leng <> 0 then  
                   begin
                   Section.AddTokenObj(S);
                   S.Clear;
                   SectionList.Add(Section);
                   end
                 else 
                   begin
                   Section.CheckFree;  
                   Section.Free;
                   end;
               if Ch = ^M then GetCh;
               PushNewProp('p', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
               PBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
               SectionList.Add(PBlock);
               SectionList := PBlock.MyCell;
               Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
                          CurrentUrlTarget, SectionList);
               InP := True;
               end;
             PEndSy:
               begin
               If InP then
                 begin
                 PEnd;
                 Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
                          CurrentUrlTarget, SectionList);
                 end;
               end;

             PreEndSy, TDEndSy, THEndSy:
               Done := True;

             BSy, ISy, BEndSy, IEndSy, EmSy, EmEndSy, StrongSy, StrongEndSy,
                 USy, UEndSy, CiteSy, CiteEndSy, VarSy, VarEndSy,
                 SSy, SEndSy, StrikeSy, StrikeEndSy, SpanSy, SpanEndSy:
               begin
               Section.AddTokenObj(S);
               S.Clear;
               case Sy of
                  BSy, ISy, StrongSy, EmSy, CiteSy, VarSy, USy, SSy, StrikeSy, SpanSy:
                    begin
                    PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
                    PropStack.Last.SetFontBG;
                    end;
                  BEndSy, IEndSy, StrongEndSy, EmEndSy, CiteEndSy, VarEndSy, UEndSy,
                      SEndSy, StrikeEndSy, SpanEndSy:
                    PopAProp(EndSymbToStr(Sy));
                  end;

               TSection(Section).ChangeFont(PropStack.Last);
               end;

             FontSy, BaseFontSy:
               begin
               Section.AddTokenObj(S);
               S.Clear;
               if ChangeTheFont(Sy, True) then
                 TSection(Section).ChangeFont(PropStack.Last);
               end;
             FontEndSy:
               if PropStackIndex > InitialStackIndex then
                 begin
                 PopAProp('font');
                 Section.AddTokenObj(S);
                 S.Clear;
                 TSection(Section).ChangeFont(PropStack.Last);
                 end;
             ASy:
               begin
               Section.AddTokenObj(S);
               S.Clear;
               FoundHRef := False;
               Link := '';
               for I := 0 to Attributes.Count-1 do
                 with TAttribute(Attributes[I]) do
                   if (Which = HRefSy) then
                     begin
                     FoundHRef := True;
                     if InHref then DoAEnd;
                     InHref := True;
                     if Attributes.Find(TargetSy, T) then
                       CurrentUrlTarget.Assign(Name, T.Name)
                     else CurrentUrlTarget.Assign(Name, '');
                     Link := 'link';
                     Break;
                     end;
               PushNewProp('a', Attributes.TheClass, Attributes.TheID, Link,
                                Attributes.TheStyle);
               PropStack.Last.SetFontBG;
               TSection(Section).ChangeFont(PropStack.Last);

               if Attributes.Find(NameSy, T) then
                 begin
                 Tmp := UpperCase(T.Name);
                 {Author may have added '#' by mistake}
                 if (Length(Tmp) > 0) and (Tmp[1] = '#') then
                   Delete(Tmp, 1, 1);
                 MasterList.IDNameList.AddObject(Tmp, Section);
                 Section.AnchorName := True;
                 end;
               if FoundHRef then
                 if Assigned(Section) then
                   Section.HRef(HRefSy, MasterList, CurrentUrlTarget, PropStack.Last);
               end;
             AEndSy:
               begin
               Section.AddTokenObj(S);
               S.Clear;
               DoAEnd;
               end;
             ImageSy:
               begin
               Section.AddTokenObj(S);
               PushNewProp('img', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
               IO := TSection(Section).AddImage(Attributes, SectionList, TagIndex);
               IO.ProcessProperties(PropStack.Last);
               PopAProp('img');
               S.Clear;
               end;
             PanelSy:
               begin
               Section.AddTokenObj(S);
               PushNewProp('panel', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
               TSection(Section).AddPanel(MasterList, Attributes, SectionList, TagIndex);
               PopAProp('panel');
               S.Clear;
               end;
             PageSy:
               begin
               Section.AddTokenObj(S);
               S.Clear;
               SectionList.Add(Section);
               SectionList.Add(TPage.Create(MasterList));
               Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
                          CurrentUrlTarget, SectionList);
               end;
             InputSy, SelectSy:
               begin
               SaveSy := Sy;
               Section.AddTokenObj(S);
               PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
               FormControl := TSection(Section).AddFormControl(Sy, MasterList,
                           Attributes, SectionList, TagIndex, PropStack.Last);  
               FormControl.ProcessProperties(PropStack.Last);
               if Sy = SelectSy then
                 GetOptions(FormControl as TListBoxFormControlObj);
               PopAProp(SymbToStr(SaveSy));
               S.Clear;;
               end;
             TextAreaSy:
               Begin
               Section.AddTokenObj(S);
               PushNewProp('textarea', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
               TxtArea := TSection(Section).AddFormControl(TextAreaSy, MasterList,
                          Attributes, SectionList, TagIndex, PropStack.Last) as TTextAreaFormControlObj;
               DoTextArea(TxtArea);
               TxtArea.ProcessProperties(PropStack.Last);
               PopAProp('textarea');
               S.Clear;
               end;
             FormSy:
               begin
               if InP then
                 PEnd;
               if InForm then
                 FormEnd
               else if Assigned(Section) then  
                 begin
                 Section.AddTokenObj(S);
                 S.Clear;
                 SectionList.Add(Section);
                 end;

               PushNewProp('form', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
               FormBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
               SectionList.Add(FormBlock);
               SectionList := FormBlock.MyCell;
               CurrentForm := ThtmlForm.Create(MasterList, Attributes);
               Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
                          CurrentUrlTarget, SectionList);
               InForm := True;
               end;
             FormEndSy:
               begin
               if InP then   
                 PEnd;
               If InForm then
                 FormEnd;
               if not Assigned(Section) then  
                 Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
                          CurrentUrlTarget, SectionList);
               end;
             MapSy: DoMap;
             ScriptSy: DoScript(MasterList.ScriptEvent);
             end;
           end;
        ^M : begin NewSection; GetCh; end;
        EofChar : Done := True;
        else
          begin   {all other chars}
          S.AddChar(LCh, SIndex);
          if S.Leng > 200 then  
            begin
            Section.AddTokenObj(S);
            S.Clear;
            end;
          GetCh;
          end;
        end;
    If InForm then
      FormEnd
    else
      begin
      Section.AddTokenObj(S);
      SectionList.Add(Section);
      end;
    Section := Nil;
    PreFormat := False;
    while PropStackIndex >= InitialStackIndex do
      PopProp;
    SectionList := PreBlock.OwnerCell;
    Next;
  finally
    S.Free;
    end;
  end;

begin
case Sy of
  TextSy :
    begin
    if not Assigned(Section) then
      Section := TSection.Create(MasterList, Nil, PropStack.Last,
                 CurrentUrlTarget, SectionList);  
    Section.AddTokenObj(LCToken);
    Next;
    end;
  ImageSy, PanelSy:
    begin
    if not Assigned(Section) then
      Section := TSection.Create(MasterList, Nil, PropStack.Last,
                 CurrentUrlTarget, SectionList);   
    PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
    if Sy = ImageSy then
      begin
      IO := TSection(Section).AddImage(Attributes, SectionList, TagIndex);
      IO.ProcessProperties(PropStack.Last);
      end
    else TSection(Section).AddPanel(MasterList, Attributes, SectionList, TagIndex);
    PopAProp(SymbToStr(Sy));
    Next;
    end;
  InputSy, SelectSy:
    begin
    if not Assigned(Section) then
      Section := TSection.Create(MasterList, Nil, PropStack.Last,
                 CurrentUrlTarget, SectionList);   
    PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
    FormControl := TSection(Section).AddFormControl(Sy, MasterList, Attributes,
                        SectionList, TagIndex, PropStack.Last); 
    if Sy = SelectSy then
      GetOptions(FormControl as TListBoxFormControlObj);
    FormControl.ProcessProperties(PropStack.Last);
    PopAProp(SymbToStr(Sy));
    Next;
    end;
  TextAreaSy:
    Begin
    if not Assigned(Section) then
      Section := TSection.Create(MasterList, Nil, PropStack.Last,
                 CurrentUrlTarget, SectionList);
    PushNewProp('textarea', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
    TxtArea := TSection(Section).AddFormControl(TextAreaSy, MasterList,
               Attributes, SectionList, TagIndex,
               PropStack.Last) as TTextAreaFormControlObj;  
    DoTextArea(TxtArea);
    TxtArea.ProcessProperties(PropStack.Last);
    PopAProp('textarea');
    Next;
    end;
  TextAreaEndSy:   {a syntax error but shouldn't hang}
    Next;
  PageSy:
    begin
    SectionList.Add(Section);
    Section := Nil;
    Page := TPage.Create(MasterList);
    SectionList.Add(Page);
    Next;
    end;
  BRSy:
    DoBr([]);
  NoBrSy, NoBrEndSy:
    begin
    NoBreak := Sy = NoBrSy;
    if Assigned(Section) then
      Section.AddTokenObj(LCToken);
    Next;
    end;
  WbrSy:
    begin
    if Assigned(Section) and NoBreak then
      Section.AddChar(' ', TagIndex);
    Next;
    end;
  BSy, BEndSy, ISy, IEndSy, StrongSy, StrongEndSy, EmSy, EmEndSy,      
     CiteSy, CiteEndSy, VarSy, VarEndSy, USy, UEndSy, SSy, SEndSy, StrikeSy, StrikeEndSy:    
    begin
    case Sy of
       BSy, ISy, StrongSy, EmSy, CiteSy, VarSy, USy, SSy, StrikeSy:
         begin
         PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
         PropStack.Last.SetFontBG;
         end;
       BEndSy, IEndSy, StrongEndSy, EmEndSy, CiteEndSy, VarEndSy, UEndSy, SEndSy, StrikeEndSy:
         PopAProp(EndSymbToStr(Sy));
       end;
    if Assigned(Section) then
      TSection(Section).ChangeFont(PropStack.Last);
    Next;
    end;

  SubSy, SubEndSy, SupSy, SupEndSy, BigSy, BigEndSy, SmallSy, SmallEndSy:   
    begin
    case Sy of
      SubEndSy, SupEndSy, SmallEndSy, BigEndSy:
        begin
        if Sy in [SubEndSy, SupEndSy] then
          CurrentSScript := Normal;
        PopAProp(EndSymbToStr(Sy));
        end;
      SubSy, SupSy, BigSy, SmallSy:
        begin
        if not Assigned(Section) then
          Section := TSection.Create(MasterList, Nil, PropStack.Last,
                     CurrentUrlTarget, SectionList);  
        if Sy = SubSy then CurrentSScript := SubSc
          else if Sy = SupSy then CurrentSScript := SupSc;
        PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
        PropStack.Last.SetFontBG;
        end;
      end;

    if Assigned(Section) then
      TSection(Section).ChangeFont(PropStack.Last);
    Next;
    end;
  CodeSy, TTSy, KbdSy, SampSy, CodeEndSy, TTEndSy, KbdEndSy, SampEndSy,
          SpanSy, SpanEndSy:   
    begin
    case Sy of
       CodeSy, TTSy, KbdSy, SampSy, SpanSy:
         begin
         PushNewProp(SymbToStr(Sy), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
         PropStack.Last.SetFontBG;
         end;
       CodeEndSy, TTEndSy, KbdEndSy, SampEndSy, SpanEndSy:
         PopAProp(EndSymbToStr(Sy));
       end;
     if Assigned(Section) then
      TSection(Section).ChangeFont(PropStack.Last);
    Next;
    end;
  FontEndSy:
    begin
    PopAProp('font');
      if Assigned(Section) then
        TSection(Section).ChangeFont(PropStack.Last);
    Next;
    end;
  FontSy, BaseFontSy:
    begin
    if ChangeTheFont(Sy, False) and Assigned(Section) then
      TSection(Section).ChangeFont(PropStack.Last);
    Next;
    end;
  ASy:
    begin
    FoundHRef := False;
    Link := '';
    for I := 0 to Attributes.Count-1 do
      with TAttribute(Attributes[I]) do
        if (Which = HRefSy) then
          begin
          FoundHRef := True;
          if InHref then DoAEnd;
          InHref := True;
          if Attributes.Find(TargetSy, T) then
            CurrentUrlTarget.Assign(Name, T.Name)
          else CurrentUrlTarget.Assign(Name, '');
          Link := 'link';
          Break;
          end;
    PushNewProp('a', Attributes.TheClass, Attributes.TheID, Link, Attributes.TheStyle);
    PropStack.Last.SetFontBG;
    if not Assigned(Section) then
      Section := TSection.Create(MasterList, Nil, PropStack.Last,
                 CurrentUrlTarget, SectionList)
    else TSection(Section).ChangeFont(PropStack.Last);

    if Attributes.Find(NameSy, T) then
      begin
      Tmp := UpperCase(T.Name);
      {Author may have added '#' by mistake}
      if (Length(Tmp) > 0) and (Tmp[1] = '#') then
        Delete(Tmp, 1, 1);
      MasterList.IDNameList.AddObject(Tmp, Section);
      Section.AnchorName := True;
      end;
    if FoundHRef then
      if Assigned(Section) then
        Section.HRef(HRefSy, MasterList, CurrentUrlTarget, PropStack.Last);
    Next;
    end;
  AEndSy:
    begin
    DoAEnd;
    Next;
    end;
  HeadingSy:
    if (Value in [1..6]) then 
      begin
      SectionList.Add(Section);
      HeadingStr := 'h'+IntToStr(Value);
      PushNewProp(HeadingStr, Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
      CheckForAlign;
      SkipWhiteSpace;  
      Next;   
      if Sy = CenterSy then  
        begin
        PropStack.Last.Assign('center', TextAlign);
        Next;
        end;
      HeadingBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
      SectionList.Add(HeadingBlock);
      SectionList := HeadingBlock.MyCell;

      Section := TSection.Create(MasterList, Attributes, PropStack.Last,
                 CurrentUrlTarget, SectionList);
      Done := False;
      while not Done do
        case Sy of
          TextSy, BrSy, NoBrSy, NoBrEndSy, WbrSy, BSy, ISy, BEndSy, IEndSy,
                   EmSy, EmEndSy, StrongSy, StrongEndSy, USy, UEndSy, CiteSy,
                   CiteEndSy, VarSy, VarEndSy, SubSy, SubEndSy, SupSy, SupEndSy,
                   SSy, SEndSy, StrikeSy, StrikeEndSy, TTSy, CodeSy, KbdSy, SampSy,
                   TTEndSy, CodeEndSy, KbdEndSy, SampEndSy, BigEndSy,
                   SmallEndSy, BigSy, SmallSy, ASy, AEndSy, SpanSy, SpanEndSy,
                   InputSy, TextAreaSy, TextAreaEndSy, SelectSy,
                   ImageSy, FontSy, FontEndSy, BaseFontSy,
                   ScriptSy, ScriptEndSy, PanelSy:
            DoCommonSy;
          CommandSy:
            Next;
          PSy: DoP([]);
          else Done := True;
          end;
      SectionList.Add(Section);
      Section := Nil;
      PopAProp(HeadingStr);
      SectionList := HeadingBlock.OwnerCell;
      if Sy = HeadingEndSy then
        Next;
      end
    else
      Next;
  HeadingEndSy: Next;  {in case of extra entry}

  HRSy:    
    begin
    SectionList.Add(Section);
    PushNewProp('hr', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);    
      {Create Horzline first as it effects the PropStack}
      HorzLine := THorzLine.Create(MasterList, Attributes, PropStack.Last);
      HRBlock := THRBlock.Create(MasterList, PropStack.Last, SectionList);
      HRBlock.MyHRule := Horzline;
      HRBlock.Align := Horzline.Align;
      SectionList.Add(HRBlock);
      SectionList := HRBlock.MyCell;

      SectionList.Add(HorzLine);
      SectionList := HRBlock.OwnerCell;
    PopAProp('hr');
    Section := Nil;
    Next;
    end;
  PreSy:  DoPreSy;
  TableSy: DoTable;
  MapSy: DoMap;
  ScriptSy: begin DoScript(MasterList.ScriptEvent); Next; end;
  
  else
    begin
    Assert(False, 'DoCommon can''t handle <'+ SymbToStr(Sy)+'>');
    Next;   {as loop protection}
    end;
  end;
end;   {DoCommon}

{----------------DoP}
procedure DoP(const TermSet: SymbSet);
var
  NewBlock: TBlock;
  LastAlign, LastClass, LastID: string;
  LastStyle: TProperties;
begin
if PSy in TermSet then
  Exit;
SectionList.Add(Section);
Section := Nil;
SkipWhiteSpace;
LastAlign := FindAlignment;  
LastClass := Attributes.TheClass;
LastID := Attributes.TheID;
LastStyle := Attributes.TheStyle;  
Next;
while Sy in [PSy, PEndSy] do
  begin           {recognize only the first <p>}
  if Sy = PSy then
    begin
    LastAlign := FindAlignment;   {if a series of <p>, get last alignment}
    LastClass := Attributes.TheClass;  
    LastID := Attributes.TheID;  
    LastStyle := Attributes.TheStyle;  
    end;
  SkipWhiteSpace;
  Next;
  end;
PushNewProp('p', LastClass, LastID, '', LastStyle);    
if LastAlign <> '' then
  PropStack.Last.Assign(LastAlign, TextAlign);    

NewBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
SectionList.Add(NewBlock);
SectionList := NewBlock.MyCell;

while not (Sy in Termset) and
          (Sy in [TextSy, NoBrSy, NoBrEndSy, WbrSy, BSy, ISy, BEndSy, IEndSy,
             EmSy, EmEndSy, StrongSy, StrongEndSy, USy, UEndSy, CiteSy,
             CiteEndSy, VarSy, VarEndSy, SubSy, SubEndSy, SupSy, SupEndSy,
             SSy, SEndSy, StrikeSy, StrikeEndSy, TTSy, CodeSy, KbdSy, SampSy,
             TTEndSy, CodeEndSy, KbdEndSy, SampEndSy, FontEndSy, BigEndSy,
             SmallEndSy, BigSy, SmallSy, ASy, AEndSy, SpanSy, SpanEndSy,
             InputSy, TextAreaSy, TextAreaEndSy, SelectSy,
             ImageSy, FontSy, FontEndSy, BaseFontSy, BRSy,
             MapSy, PageSy, ScriptSy, ScriptEndSy, PanelSy, NoBrSy, NoBrEndSy, WbrSy, CommandSy]) do
    if Sy <> CommandSy then
      DoCommonSy
    else Next;     {unknown tag}
SectionList.Add(Section);
Section := Nil;
PopAProp('p');
SectionList := NewBlock.OwnerCell;
if Sy = PEndSy then
  Next;
end;

{----------------DoBr}
procedure DoBr(const TermSet: SymbSet);    
var
  T: TAttribute;
begin
if BRSy in TermSet then
  Exit;
if Attributes.Find(ClearSy, T) then
  begin
  if Assigned(Section) then
    SectionList.Add(Section);
  Section := TSection.Create(MasterList, Attributes, PropStack.Last, CurrentUrlTarget, SectionList);
  end
else if Assigned(Section) then
  if (Section.Len > 0) then
    begin
    SectionList.Add(Section);
    Section := Nil;
    end
  else Section.AddChar(#8, TagIndex)
else
  begin
  Section := TSection.Create(MasterList, Attributes, PropStack.Last, CurrentUrlTarget, SectionList);
  Section.AddChar(#8, TagIndex);
  end;
Next;
end;

procedure DoListItem(BlockType, Sym: Symb; LineCount: integer; Index: char;
                                Plain: boolean; const TermSet: SymbSet);
var
  Done: boolean;
  LiBlock: TBlock;

begin
SectionList.Add(Section);
PushNewProp(SymbToStr(Sym), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
LiBlock := TBlockLI.Create(MasterList, PropStack.Last, SectionList,
            BlockType, Plain, Index, LineCount, ListLevel);     
SectionList.Add(LiBlock);
SectionList := LiBlock.MyCell;

Section := TSection.Create(MasterList, Nil, PropStack.Last,
                CurrentUrlTarget, SectionList);

SkipWhiteSpace;
Next;
Done := False;
while not Done do   {handle second part like after a <p>}
  case Sy of         
    TextSy, NoBrSy, NoBrEndSy, WbrSy, BSy, ISy, BEndSy, IEndSy,
         EmSy, EmEndSy, StrongSy, StrongEndSy, USy, UEndSy, CiteSy,
         CiteEndSy, VarSy, VarEndSy, SubSy, SubEndSy, SupSy, SupEndSy,
         SSy, SEndSy, StrikeSy, StrikeEndSy, TTSy, CodeSy, KbdSy, SampSy,
         TTEndSy, CodeEndSy, KbdEndSy, SampEndSy, FontEndSy, BigEndSy,
         SmallEndSy, BigSy, SmallSy, ASy, AEndSy, SpanSy, SpanEndSy,
         InputSy, TextAreaSy, TextAreaEndSy, SelectSy,
         ImageSy, FontSy, BaseFontSy, BrSy, HeadingSy,
         MapSy, PageSy, ScriptSy, ScriptEndSy, PanelSy:
       DoCommonSy;
    PSy:
      if BlockType in [OLSy, ULSy, DirSy, MenuSy, DLSy] then
        DoP([])
       else Done := True;  {else terminate lone <li>s on <p>}
    DivSy, CenterSy, FormSy, AddressSy, BlockquoteSy:
      DoDivEtc(Sy, TermSet+[LiSy, DDSy, DTSy,
                             OLSy, ULSy, DirSy, MenuSy, DLSy]);   
    OLSy, ULSy, DirSy, MenuSy, DLSy:
      begin
      DoLists(Sy, TermSet);
      LIBlock.MyCell.CheckLastBottomMargin;
      Next;
      end;
    CommandSy: Next;
    TableSy: DoTable;
  else Done := True;
  end;
SectionList.Add(Section);
Section := Nil;
SectionList.CheckLastBottomMargin;  
PopAProp(SymbToStr(Sym));
SectionList := LiBlock.OwnerCell;
end;

{-------------DoLists}
procedure DoLists(Sym: Symb; const TermSet: SymbSet);
var
  T: TAttribute;
  LineCount: integer;
  Plain: boolean;
  Index: char;
  NewBlock: TBlock;
  EndSym: Symb;

begin
LineCount := 1;
Index := '1';
EndSym := EndSymbFromSymb(Sym);
Plain := False;
if (Sym = OLSy) then
  begin
  if Attributes.Find(StartSy, T) then
    if T.Value >= 0 then LineCount := T.Value;
  if Attributes.Find(TypeSy, T) and (T.Name <> '') then
    Index := T.Name[1];
  end
else Plain := (Sym = ULSy) and Attributes.Find(PlainSy, T);
SectionList.Add(Section);
Section := Nil;
PushNewProp(SymbToStr(Sym), Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);

NewBlock := TBlock.Create(MasterList, PropStack.Last, SectionList);
NewBlock.IsListBlock := not (Sym in [AddressSy, BlockquoteSy, DLSy]);
SectionList.Add(NewBlock);
SectionList := NewBlock.MyCell;
Next;
if Sy in [OLEndSy, ULEndSy, DirEndSy, MenuEndSy, DLEndSy, BlockQuoteEndSy] then
  begin    {guard against <ul></ul> and similar combinations}
  PopAProp(EndSymbToStr(Sy));
  SectionList := NewBlock.OwnerCell;
  Exit;
  end;
if Sym in [ULSy, OLSy, DirSy, MenuSy] then    
  Inc(ListLevel);
repeat
  case Sy of
    LISy, DDSy, DTSy:
      begin
      DoListItem(Sym, Sy, LineCount, Index, Plain, TermSet);
      Inc(LineCount);
      end;
    OLSy, ULSy, DirSy, MenuSy, DLSy:
      begin
      DoLists(Sy, TermSet);
      Next;
      end;
    PSy:  DoP(TermSet);
    BlockQuoteSy, AddressSy:
      DoDivEtc(Sy, TermSet);     
    DivSy, CenterSy, FormSy:    
      DoDivEtc(Sy,  [OLEndSy, ULEndSy, DirEndSy, MenuEndSy, DLEndSy,
             LISy, DDSy, DTSy,
             BlockQuoteEndSy, EofSy]+TermSet);

    TextSy, BRSy, HRSy, TableSy,
    BSy, ISy, BEndSy, IEndSy, EmSy, EmEndSy, StrongSy, StrongEndSy,
        USy, UEndSy, CiteSy, CiteEndSy, VarSy, VarEndSy,
        SubSy, SubEndSy, SupSy, SupEndSy, SSy, SEndSy, StrikeSy, StrikeEndSy,
    TTSy, CodeSy, KbdSy, SampSy,  TTEndSy, CodeEndSy, KbdEndSy, SampEndSy,
    NameSy, HRefSy, ASy, AEndSy, SpanSy, SpanEndSy,
    HeadingSy, HeadingEndSy, PreSy,
    InputSy, TextAreaSy, TextAreaEndSy, SelectSy,
    ImageSy, FontSy, FontEndSy, BaseFontSy, BigSy, BigEndSy, SmallSy,
    SmallEndSy, MapSy, PageSy, ScriptSy, PanelSy, NoBrSy, NoBrEndSy, WbrSy:
      DoCommonSy;
    else if Sy in TermSet then  {exit below}
      else Next;
    end;
Until (Sy in [EndSym, EofSy]) or (Sy in TermSet);
if Sym in [ULSy, OLSy, DirSy, MenuSy] then
  Dec(ListLevel);        
SectionList.Add(Section);
SectionList.CheckLastBottomMargin;
Section := Nil;
PopAProp(EndSymbToStr(Sy));  {maybe save stack position}
SectionList := NewBlock.OwnerCell;
end;

{----------------DoBase}
procedure DoBase;
var
  I: integer;
begin
with Attributes do
  for I := 0 to Count-1 do
    with TAttribute(Attributes[I]) do
      if Which = HrefSy then
        Base := Name
      else if Which = TargetSy then
        BaseTarget := Name;
Next;
end;

{----------------DoSound}
procedure DoSound;
var
  Loop: integer;
  T, T1: TAttribute;
begin
if Assigned(SoundEvent) and Attributes.Find(SrcSy, T) then
  begin
  if Attributes.Find(LoopSy, T1) then Loop := T1.Value
    else Loop := 1;
  SoundEvent(CallingObject, T.Name, Loop, False);
  end;
Next;
end;

{$ifdef ver100_plus}     
function TranslateCharset(DefCharset: TFontCharset; const Content: string): TFontCharset;
type
  XRec = record S: string; CSet: TFontCharset; end;
const
  MaxX = 14;
  XTable: array[1..MaxX] of XRec =
     ((S:'1252';    CSet:ANSI_CHARSET),
      (S:'8859-1';    CSet:ANSI_CHARSET),
      (S:'1253';    CSet:GREEK_CHARSET),
      (S:'8859-7';    CSet:GREEK_CHARSET),
      (S:'1250';    CSet:EASTEUROPE_CHARSET),
      (S:'8859-2';    CSet:EASTEUROPE_CHARSET),
      (S:'1251';    CSet:RUSSIAN_CHARSET),
      (S:'8859-5';    CSet:RUSSIAN_CHARSET),
      (S:'koi8-r';    CSet:RUSSIAN_CHARSET),
      (S:'1254';    CSet:TURKISH_CHARSET),
      (S:'8859-3';    CSet:TURKISH_CHARSET),
      (S:'8859-9';    CSet:TURKISH_CHARSET),
      (S:'1257';    CSet:BALTIC_CHARSET),
      (S:'8859-4';    CSet:BALTIC_CHARSET));
var
  I: integer;
begin
Result := DefCharset;
for I := 1 to MaxX do
  if Pos(XTable[I].S, Lowercase(Content)) > 0 then
    Begin
    Result := XTable[I].CSet;
    Break;
    end;
end;
{$endif}

{----------------DoMeta}
procedure DoMeta(Sender: TObject); 
var
  T: TAttribute;
  HttpEq, Name, Content: string;
begin
if Attributes.Find(HttpEqSy, T) then HttpEq := T.Name
  else HttpEq := '';
if Attributes.Find(NameSy, T) then Name := T.Name
  else Name := '';
if Attributes.Find(ContentSy, T) then Content := T.Name
  else Content := '';
{$ifdef ver100_plus}
if (Sender is ThtmlViewer) and (CompareText(HttpEq, 'content-type') = 0) then
  PropStack.Last.Charset := TranslateCharset(PropStack.Last.Charset, Content);
{$endif}
if Assigned(MetaEvent) then
  MetaEvent(Sender, HttpEq, Name, Content);
Next;
end;

{----------------DoTitle}
procedure DoTitle;
begin
Title := '';
Next;
while Sy = TextSy do
  begin
  Title := Title+LCToken.S;
  Next;
  end;
end;

var
  slS: string;
  slI: integer;

function slGet: char;
  function Get: char;
  begin
  if slI <= Length(slS) then
    begin
    Result := slS[slI];
    Inc(slI);
    end
  else Result := ^Z;
  end;
begin
repeat
  Result := Get;
until (Result <> ^J);
if Result = Tab then    
  Result := ' ';
end;

procedure DoStyleLink;   {handle <link> for stylesheets}
var
  Stream: TMemoryStream;
  C: char;
  I: integer;
  Url: string;
  OK: boolean;
  Request: TGetStreamEvent;
  RStream: TMemoryStream;
  Viewer: ThtmlViewer;
  Path: string;
begin
OK := False;
for I := 0 to Attributes.Count-1 do
  with TAttribute(Attributes[I]) do
    case Which of
      RelSy, RevSy:
        if CompareText(Name, 'stylesheet') = 0  then
          OK := True;
      HRefSy:
        Url := Name;
      end;
if OK and (Url <> '') then
  begin
  Stream := TMemoryStream.Create;
  try
    Viewer := (CallingObject as ThtmlViewer);
    Request := Viewer.OnHtStreamRequest;
    if Assigned(Request) then
      begin
      if Assigned(Viewer.OnExpandName) then
        begin    {must be using TFrameBrowser}
        Viewer.OnExpandName(Viewer, Url, Url);
        Path := GetBase(Url);
        end
      else
        Path := '';  {for TFrameViewer requests, don't know path}
      RStream := Nil;
      Request(Viewer, Url, RStream);
      if Assigned(RStream) then
        Stream.LoadFromStream(RStream);
      end
    else  {assume it's a file}
      begin
      Url := Viewer.HTMLExpandFilename(Url);
      Path := ExtractFilePath(Url);
      Stream.LoadFromFile(Url);
      end;
    if Stream.Size > 0 then
      begin
      SetLength(slS, Stream.Size);
      Move(Stream.Memory^, slS[1], Stream.Size);
      slS := AdjustLineBreaks(slS);  {put in uniform CRLF format}
      slI := 1;
      C := slGet;
      DoStyle(MasterList.Styles, C, slGet, Path);
      end;
    Stream.Free;
    SetLength(slS, 0);
  except
    Stream.Free;
    SetLength(slS, 0);
    end;
  end;
Next;
end;

{-------------DoBody}
procedure DoBody(const TermSet: SymbSet);
var
  I: integer;
  Val: TColor;
  Image: string;
  AMarginHeight, AMarginWidth: integer;

begin
repeat
  if Sy in TermSet then
    Exit;
  case Sy of
    TextSy, BRSy, HRSy,
    NameSy, HRefSy, ASy, AEndSy,
    BSy, ISy, BEndSy, IEndSy, EmSy, EmEndSy, StrongSy, StrongEndSy,
        USy, UEndSy, CiteSy, CiteEndSy, VarSy, VarEndSy,
        SubSy, SubEndSy, SupSy, SupEndSy,  SSy, SEndSy, StrikeSy, StrikeEndSy,
    TTSy, CodeSy, KbdSy, SampSy,  TTEndSy, CodeEndSy, KbdEndSy, SampEndSy, SpanSy, SpanEndSy,
    HeadingSy, HeadingEndSy, PreSy, TableSy,
    InputSy, TextAreaSy, TextAreaEndSy, SelectSy,
    ImageSy, FontSy, FontEndSy, BaseFontSy, BigSy, BigEndSy, SmallSy,
    SmallEndSy, MapSy, PageSy, ScriptSy, PanelSy, NoBrSy, NoBrEndSy, WbrSy:
      DoCommonSy;
    BodySy:
      begin
      if (BodyBlock.MyCell.Count = 0) and
           (PropStackIndex = 0) then   {make sure we're at beginning}
        begin
        Section.Free;   {Will start with a new section}
        PushNewProp('body', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
        AMarginHeight := (CallingObject as ThtmlViewer).MarginHeight;
        AMarginWidth := (CallingObject as ThtmlViewer).MarginWidth;
        for I := 0 to Attributes.Count-1 do
          with TAttribute(Attributes[I]) do
            case Which of
              BackgroundSy: PropStack.Last.Assign('url('+Name+')', BackgroundImage);
              TextSy:
                if ColorFromString(Name, False, Val) then
                  PropStack.Last.Assign(Val or $2000000, Color);
              BGColorSy:
                if ColorFromString(Name, False, Val) then
                  PropStack.Last.Assign(Val or $2000000, BackgroundColor);
              LinkSy:
                if ColorFromString(Name, False, Val) then
                  MasterList.Styles.ModifyLinkColor('link', Val);
              VLinkSy:
                if ColorFromString(Name, False, Val) then
                  MasterList.Styles.ModifyLinkColor('visited', Val);
              OLinkSy:
                if ColorFromString(Name, False, Val) then
                  begin
                  MasterList.Styles.ModifyLinkColor('hover', Val);
                  MasterList.LinksActive := True;
                  end;
              MarginWidthSy:   
                AMarginWidth := IntMin(IntMax(0,Value), 200);
              MarginHeightSy:  
                AMarginHeight := IntMin(IntMax(0,Value), 200);
            end;
        PropStack.Last.Assign(AMarginWidth, MarginLeft);
        PropStack.Last.Assign(AMarginWidth, MarginRight);
        PropStack.Last.Assign(AMarginHeight, MarginTop);
        PropStack.Last.Assign(AMarginHeight, MarginBottom);

        SectionList := BodyBlock.OwnerCell;
        SectionList.Remove(BodyBlock);
        BodyBlock.Free;
        BodyBlock := TBodyBlock.Create(MasterList, PropStack.Last, SectionList);
        SectionList.Add(BodyBlock);
        SectionList := BodyBlock.MyCell;

        if PropStack.Last.GetBackgroundImage(Image) and (Image <> '') then
           MasterList.SetBackgroundBitmap(Image);
        Val := PropStack.Last.GetBackgroundColor;
        if Val <> clNone then
          MasterList.SetBackGround(Val or $2000000);

        Section := TSection.Create(MasterList, Nil, PropStack.Last, Nil, SectionList);
        end;
      Next;
      end;
    OLSy, ULSy, DirSy, MenuSy, DLSy:
      begin
      DoLists(Sy, TermSet);
      if not (Sy in TermSet) then     
        Next;
      end;
    LISy:
      DoListItem(LiAloneSy, Sy, 1, '1', False, TermSet);
    DDSy, DTSy:
      DoListItem(DLSy, Sy, 1, '1', False, TermSet);
    PSy:  DoP(TermSet);

    FormEndSy:
      begin
      CurrentForm := Nil;
      Next;
      end;

    DivSy, CenterSy, FormSy, BlockQuoteSy, AddressSy:  DoDivEtc(Sy, TermSet);    
    TitleSy:
        DoTitle;   
    LinkSy:
      if (BodyBlock.MyCell.Count = 0) and
           (PropStackIndex = 0) then   {make sure we're at beginning}
        DoStyleLink
      else Next;
    StyleSy:
        begin
        DoStyle(MasterList.Styles, LCh, GetChBasic, '');
        Ch := UpCase(LCh);  {LCh is returned so next char is available}
        Next;
        end;
    BgSoundSy:
        DoSound;
    MetaSy:
        DoMeta(CallingObject);
    BaseSy:
      DoBase;  
    else Next;
    end;
Until (Sy = EofSy);
Next;
end;

procedure DoFrameSet(FrameViewer: TFrameViewerBase; FrameSet: TObject; const FName: string);
var
  NewFrameSet: TObject;
begin
FrameViewer.DoAttributes(FrameSet, Attributes);
Next;
while (Sy <> FrameSetEndSy) and (Sy <> EofSy) do
  begin
  case Sy of
    FrameSy:
      begin
      FrameViewer.AddFrame(FrameSet, Attributes, FName);
      end;
    FrameSetSy:
      begin
      NewFrameSet := FrameViewer.CreateSubFrameSet(FrameSet);
      DoFrameSet(FrameViewer, NewFrameSet, FName);
      end;
    NoFramesSy:
      begin
      repeat
        Next;
      until (Sy = NoFramesEndSy) or (Sy = EofSy);
      end;
    ScriptSy:  begin DoScript(FrameViewer.FOnScript); Next; end;
    end;
  Next;
  end;
FrameViewer.EndFrameSet(FrameSet);
end;

{----------------ParseInit}
procedure ParseInit(ASectionList: TList;  AIncludeEvent: TIncludeType);
begin
SectionList := TSectionList(ASectionList);
MasterList := TSectionList(SectionList);
CallingObject := TSectionList(ASectionList).TheOwner;
IncludeEvent := AIncludeEvent;
PreFormat := False;
PropStack.Clear;         
PropStack.Add(TProperties.Create);
PropStack[0].CopyDefault(MasterList.Styles.DefProp);

BodyBlock := TBodyBlock.Create(MasterList, PropStack[0], SectionList);
SectionList.Add(BodyBlock);
SectionList := BodyBlock.MyCell;

CurrentURLTarget := TUrlTarget.Create;
InHref := False;
BaseFontSize := 3;

Title := '';
Base := '';
BaseTarget := '';
CurrentStyle := [];
CurrentForm := Nil;
Section := TSection.Create(MasterList, Nil, PropStack.Last, Nil, SectionList);  
Attributes := TAttributeList.Create;
SIndex := -1;
InScript := False;
NoBreak := False;
InComment := False;
ListLevel := 0;    
TableLevel := 0;   
end;

{----------------HtmlParseStream}
procedure HtmlParseStream(ASectionList: TList; 
                   AStream: TStream; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
var
  Stream: TMemoryStream;
begin
LoadStyle := lsStream;
ParseInit(ASectionList, AIncludeEvent);
SoundEvent := ASoundEvent;
MetaEvent := AMetaEvent;

Stream := TMemoryStream.Create;
try
  Stream.LoadFromStream(AStream);
  Buffer := Stream.Memory;
  BuffEnd := Buffer+Stream.Size;
  try
    GetCh; {get the reading started}
    Next;
    DoBody([]);
  except
    On E:Exception do
      Assert(False, E.Message);
  end;

finally
  Stream.Free;
  Attributes.Free;
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentURLTarget.Free;
 end;   {finally}
end;

{----------------HtmlParseBuffer}
procedure HtmlParseBuffer(ASectionList: TList;
                   ABuffer : PChar; BuffSize: integer; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
var
  S: string;
begin
LoadStyle := lsBuffer;
ParseInit(ASectionList, AIncludeEvent);
SoundEvent := ASoundEvent;
MetaEvent := AMetaEvent;
SetLength(S, BuffSize+1);
Move(ABuffer^, S[1], BuffSize);
Buffer := PChar(S);
BuffEnd := Buffer+BuffSize;
try
  try
    GetCh; {get the reading started}
    Next;
    DoBody([]);
  except
    On E:Exception do
      Assert(False, E.Message);
  end;
finally
  Attributes.Free;     
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentURLTarget.Free;
  end;
end;

{----------------HtmlParseStrings}
procedure HtmlParseStrings(ASectionList: TList;
                   Strings : TStrings; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
var
  S: string;
begin
LoadStyle := lsStrings;
ParseInit(ASectionList, AIncludeEvent);
SoundEvent := ASoundEvent;
MetaEvent := AMetaEvent;

try
  S := Strings.Text;
  Buffer := PChar(S);
  BuffEnd := Buffer+Length(Strings.Text);
  try
    GetCh; {get the reading started}
    Next;
    DoBody([]);
  except
    On E:Exception do
      Assert(False, E.Message);
  end;

finally
  Attributes.Free;
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentURLTarget.Free;
 end;   {finally}
end;

{-------------HtmlParseFile}
procedure HtmlParseFile(ASectionList: TList;
                   const FName : string; AIncludeEvent: TIncludeType;
                   ASoundEvent: TSoundType; AMetaEvent: TMetaType);
var
  Stream: TMemoryStream;
begin
LoadStyle := lsFile;
ParseInit(ASectionList, AIncludeEvent);
SoundEvent := ASoundEvent;
MetaEvent := AMetaEvent;

Stream := TMemoryStream.Create;
try
  Stream.LoadFromFile(FName);
  Buffer := Stream.Memory;
  BuffEnd := Buffer+Stream.Size;
  try
    GetCh; {get the reading started}
    Next;
    DoBody([]);
  except
    On E:Exception do
      Assert(False, E.Message);
  end;

finally
  Stream.Free;
  Attributes.Free;
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentURLTarget.Free;
 end;   {finally}
end;

{----------------DoText}
procedure DoText;
var
  S: TokenObj;
  Done: boolean;

  procedure NewSection;
  begin
  Section.AddTokenObj(S);
  S.Clear;
  SectionList.Add(Section);
  Section := TPreFormated.Create(MasterList, Nil, PropStack.Last,
               CurrentUrlTarget, SectionList);
  end;

begin
S := TokenObj.Create;
try
  SectionList.Add(Section);
  PushNewProp('pre', Attributes.TheClass, Attributes.TheID, '', Attributes.TheStyle);
  Section := TPreformated.Create(MasterList, Nil, PropStack.Last,
             CurrentUrlTarget, SectionList);
  PreFormat := True;
  Done := False;
  while not Done do
    case Ch of
      ^M : begin NewSection; GetCh; end;
      EofChar : Done := True;
      else
        begin   {all other chars}
        S.AddChar(LCh, SIndex);
        if S.Leng > 200 then   
          begin
          Section.AddTokenObj(S);
          S.Clear;
          end;
        GetCh;
        end;
      end;
  Section.AddTokenObj(S);
  SectionList.Add(Section);
  Section := Nil;
  PreFormat := False;
  PopAProp('pre');
finally
  S.Free;
  end;
end;

{-------------HtmlParseTextFile}
procedure HtmlParseTextFile(ASectionList: TList;
                   const FName : string);
var
  Stream: TMemoryStream;
begin
LoadStyle := lsFile;
ParseInit(ASectionList, Nil);
Inscript := True;   

Stream := TMemoryStream.Create;
try
  Stream.LoadFromFile(FName);
  Buffer := Stream.Memory;
  BuffEnd := Buffer+Stream.Size;
  try
    GetCh; {get the reading started}
    DoText;
  except
    On E:Exception do
      Assert(False, E.Message);
  end;

finally
  Stream.Free;
  Attributes.Free;
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentUrlTarget.Free;
 end;   {finally}
end;

{----------------HtmlParseTextStream}
procedure HtmlParseTextStream(ASectionList: TList;
                   AStream: TStream);
var
  Stream: TMemoryStream;
begin
LoadStyle := lsStream;
ParseInit(ASectionList, Nil);
Inscript := True;   
Stream := TMemoryStream.Create;
try
  Stream.LoadFromStream(AStream);
  Buffer := Stream.Memory;
  BuffEnd := Buffer+Stream.Size;
  try
    GetCh; {get the reading started}
    DoText;
  except
    On E:Exception do
      Assert(False, E.Message);
  end;
finally
  Stream.Free;
  Attributes.Free;
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentUrlTarget.Free;
  end;
end;

{----------------HtmlParseTextStrings}
procedure HtmlParseTextStrings(ASectionList: TList;
                   Strings : TStrings);
var
  S: string;
begin
LoadStyle := lsStrings;
ParseInit(ASectionList, Nil);
InScript := True;   

try
  S := Strings.Text;
  Buffer := PChar(S);
  BuffEnd := Buffer+Length(Strings.Text);
  GetCh; {get the reading started}
  DoText;

finally
  Attributes.Free;
  if Assigned(Section) then
    SectionList.Add(Section);
  PropStack.Clear;
  CurrentUrlTarget.Free;
  end;   {finally}
end;

{-------------FrameParseFile}
procedure FrameParseFile(FrameViewer: TFrameViewerBase; FrameSet: TObject;  ALoadStyle: LoadStyleType;
          const FName : string; Strings : TStrings; AStream: TStream;
          ABuffer : PChar; BuffSize: integer; AMetaEvent: TMetaType);
var
  Stream: TMemoryStream;
  S: string;

  procedure Parse;
  var
    SetExit: boolean;
  begin
  SetExit := False;
  GetCh; {get the reading started}
  Next;
  repeat
    case Sy of
      FrameSetSy:
        begin
        DoFrameSet(FrameViewer, FrameSet, FName);
        end;
      BaseSy: DoBase;
      TitleSy: DoTitle;
      BgSoundSy: DoSound;
      ScriptSy: begin DoScript(FrameViewer.FOnScript); Next; end;
      NoFramesSy:
        begin
        repeat
          Next;
        until (Sy = NoFramesEndSy) or (Sy = EofSy);
        Next;
        end;
      MetaSy: DoMeta(FrameSet);
      BodySy, HeadingSy, HRSy, TableSy, ImageSy, OLSy, ULSy, MenuSy, DirSy,
      PSy, PreSy, FormSy, AddressSy, BlockQuoteSy, DLSy:
        SetExit := True;
      else Next;
      end;
  until SetExit or (Sy = EofSy);
  end;

begin
LoadStyle := ALoadStyle;
if (LoadStyle = lsStrings) and not Assigned(Strings) or
   (LoadStyle = lsStream) and not Assigned(AStream) or
   (LoadStyle = lsBuffer) and not Assigned(ABuffer) then
     Exit;
CallingObject := FrameViewer;
IncludeEvent := FrameViewer.FOnInclude;
SoundEvent := FrameViewer.FOnSoundRequest;
MetaEvent := AMetaEvent;
Attributes := TAttributeList.Create;
Title := '';
Base := '';
BaseTarget := '';
InScript := False;
NoBreak := False;
InComment := False;
ListLevel := 0;

if LoadStyle = lsFile then
  begin
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(FName);
    Buffer := Stream.Memory;
    BuffEnd := Buffer+Stream.Size;
    try
      Parse;
    except
      On E:Exception do
        Assert(False, E.Message);
    end;
  finally
    Stream.Free;
    Attributes.Free;
   end;   {finally}
  end
else if LoadStyle = lsStrings then
  begin
  S := Strings.Text;
  Buffer := PChar(S);
  BuffEnd := Buffer+Length(Strings.Text);
  try
    Parse;
  except    {ignore error}
    end;
  Attributes.Free;
  end
else if LoadStyle = lsStream then
  begin
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromStream(AStream);
    Buffer := Stream.Memory;
    BuffEnd := Buffer+Stream.Size;
    try
      Parse;
    except    {ignore error}
      end;
  finally
    Stream.Free;
    Attributes.Free;
    end;
  end
else if LoadStyle = lsBuffer then
  begin
  Buffer := ABuffer;
  BuffEnd := Buffer+BuffSize;
  try
    Parse;
  except    {ignore error}
    end;
  Attributes.Free;
  end;
end;

{----------------IsFrameFile}
function IsFrameFile(ALoadStyle: LoadStyleType;
          const FName : string; Strings : TStrings; AStream: TStream;
          ABuffer : PChar; BuffSize: integer; FrameViewer: TObject): boolean;
var
  Stream: TMemoryStream;
  S: string;

  function Parse: boolean;
  var
    SetExit: boolean;
  begin
  Result := False;
  SetExit := False;
  GetCh; {get the reading started}
  Next;
  repeat
    case Sy of
      FrameSetSy:
        begin
        Result := True;
        break;
        end;
      ScriptSy: begin DoScript(Nil); Next; end;  {to skip the script stuff}

      BodySy, HeadingSy, HRSy, TableSy, ImageSy, OLSy, ULSy, MenuSy, DirSy,
      PSy, PreSy, FormSy, AddressSy, BlockQuoteSy, DLSy:
        SetExit := True;
      else Next;
      end;
  until SetExit or (Sy = EofSy);
  end;

begin
LoadStyle := ALoadStyle;
if (LoadStyle = lsStrings) and not Assigned(Strings) or
   (LoadStyle = lsStream) and not Assigned(AStream) or
   (LoadStyle = lsBuffer) and not Assigned(ABuffer) then
     begin
     Result := False;
     Exit;
     end;
CallingObject := FrameViewer;
SoundEvent := Nil;
Attributes := TAttributeList.Create;
Title := '';
Base := '';
BaseTarget := '';
Result := False;
InScript := False;
NoBreak := False;
InComment := False;   

if LoadStyle = lsFile then
  begin
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(FName);
    Buffer := Stream.Memory;
    BuffEnd := Buffer+Stream.Size;
    try
      Result := Parse;
    except
      On E:Exception do
        Assert(False, E.Message);
    end;

  finally
    Stream.Free;
    Attributes.Free;
   end;   {finally}
  end
else if LoadStyle = lsStrings then
  begin
  S := Strings.Text;
  Buffer := PChar(S);
  BuffEnd := Buffer+Length(Strings.Text);
  try
    Result := Parse;
  except    {ignore error}
    end;
  Attributes.Free;
  end
else if LoadStyle = lsStream then
  begin
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromStream(AStream);
    Buffer := Stream.Memory;
    BuffEnd := Buffer+Stream.Size;
    try
      Result := Parse;
    except    {ignore error}
      end;
  finally
    Stream.Free;
    Attributes.Free;
    end;
  end
else if LoadStyle = lsBuffer then
  begin
  Buffer := ABuffer;
  BuffEnd := Buffer+BuffSize;
  try
    Result := Parse;
  except    {ignore error}
    end;
  Attributes.Free;
  end;
end;

{ TFrameViewerBase }

procedure TFrameViewerBase.wmerase(var msg: TMessage);
begin
   msg.result := 1;
end;

function TPropStack.GetProp(Index: integer): TProperties;
begin
Result := Items[Index];
end;

function TPropStack.Last: TProperties;
begin
Result := Items[Count-1];
end;

procedure TPropStack.Delete(Index: integer);
begin
TObject(Items[Index]).Free;
inherited Delete(Index);
end;

initialization

LCToken := TokenObj.Create;
PropStack := TPropStack.Create;

Finalization

LCToken.Free;
PropStack.Free;

end.
