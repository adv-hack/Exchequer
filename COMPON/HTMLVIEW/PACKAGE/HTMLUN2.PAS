{Version 8.04}
{*********************************************************}
{*                     HTMLUN2.PAS                       *}
{*              Copyright (c) 1995-2001 by               *}
{*                   L. David Baldwin                    *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$i htmlcons.inc}

unit HTMLUn2;

interface
uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Clipbrd, StyleUn;

const
  VersionNo = '8.04';
  HandCursor = 1;
  ThickIBeamCursor = 2;
  UpDownCursor = 3;
  UpOnlyCursor = 4;
  DownOnlyCursor = 5;
  Tokenleng = 300;  
  TopLim = -200;   {drawing limits}
  BotLim = 3000;
  FmCtl = #2;
  ImgPan = #4;
  nbSp = #5;
  nbFmCtl = #6;
  nbImgPan = #7;
  BrkCh = #8;

type
  TScriptEvent = procedure(Sender: TObject; const Name, Language: string;  
       Script: PChar) of Object;

  TFreeList = class(TList)
  {like a TList but frees it's items.  Use only descendents of TObject}
    destructor Destroy; override;
    {$Warnings Off}
    procedure Clear;       {do not override}
    end;
    {$Warnings On}

  Transparency = (NotTransp, LLCorner, TGif, TPng);
  JustifyType = (NoJustify, Left, Centered, Right);

  Symb = (
    HtmlSy, TitleSy, BodySy, HeadSy, PSy, PEndSy, BSy, BEndSy, ISy, IEndSy,
    HtmlEndSy, TitleEndSy, BodyEndSy, HeadEndSy, BRSy, HeadingSy, HeadingEndSy,
    EmSy, EmEndSy, StrongSy, StrongEndSy, USy, UEndSy, HRSy,
    CiteSy, VarSy, CiteEndSy, VarEndSy, BaseSy,
       {Keep order}
    TTSy, CodeSy, KbdSy, SampSy,  TTEndSy, CodeEndSy, KbdEndSy, SampEndSy,
       {end order}
    OLSy, OLEndSy, LISy, ULSy, ULEndSy, DirSy, DirEndSy, MenuSy, MenuEndSy,
    DLSy, DLEndSy, DDSy, DTSy, AddressSy, AddressEndSy, BlockQuoteSy, BlockQuoteEndSy,
    PreSy, PreEndSy, ImageSy, Centersy, CenterEndSy,
    OtherAttribute, ASy, AEndSy, HrefSy, NameSy, SrcSy, AltSy, AlignSy,
    OtherChar, OtherSy, CommandSy, TextSy, EofSy, LinkSy, BGColorSy,
    BackgroundSy, TableSy, TableEndSy, TDSy, TDEndSy, TRSy, TREndSy, THSy, THEndSy,
    ColSpanSy, RowSpanSy, BorderSy, CellPaddingSy, CellSpacingSy, VAlignSy,
    WidthSy, CaptionSy, CaptionEndSy, StartSy, ButtonSy, InputSy, ValueSy,
    TypeSy, CheckBoxSy, RadioSy, FormSy, FormEndSy, MethodSy, ActionSy,
    CheckedSy, SizeSy, MaxLengthSy, TextAreaSy, TextAreaEndSy, ColsSy,
    RowsSy, SelectSy, SelectEndSy, OptionSy, OptionEndSy, SelectedSy,
    MultipleSy, FontSy, FontEndSy, ColorSy, FaceSy, BaseFontSy,
    TranspSy, SubSy, SubEndSy, SupSy, SupEndSy, ClearSy, IsMapSy,
    BigSy, BigEndSy, SmallSy, SmallEndSy, BorderColorSy, MapSy, MapEndSy,
    AreaSy, ShapeSy, CoordsSy, NoHrefSy, UseMapSy, HeightSy, PlainSy,
    FrameSetSy, FrameSetEndSy, FrameSy, TargetSy, NoFramesSy, NoFramesEndSy,
    NoResizeSy, ScrollingSy, PageSy, HSpaceSy, VSpaceSy, ScriptSy, ScriptEndSy,  
    LanguageSy, DivSy, DivEndSy, SSy, SEndSy, StrikeSy, StrikeEndSy,
    FrameBorderSy, MarginWidthSy, MarginHeightSy, BgSoundSy, LoopSy,
    OnClickSy, WrapSy, NoShadeSy, MetaSy, HttpEqSy, ContentSy, EncTypeSy,
    VLinkSy, OLinkSy, ActiveSy, PanelSy, NoBrSy, NoBrEndSy, WbrSy,
    ClassSy, IDSy, StyleSy, StyleEndSy, SpanSy, SpanEndSy, liAloneSy,
    RelSy, RevSy, NoWrapSy, BorderColorLightSy, BorderColorDarkSy,
    CharSetSy, EolSy);   

  TAttribute = class(TObject)  {holds a tag attribute}
  public
    Which: Symb;     {symbol of attribute such as HrefSy}
    Value: integer;  {numeric value if appropriate}
    Percent: boolean;{if value is in percent}
    Name: String;   {String (mixed case), value after '=' sign}
    constructor Create(ASym: Symb; AValue: integer; Const AString: String);
    destructor Destroy; override;
  end;

  TAttributeList = class(TFreeList)  {a list of tag attributes,(TAttributes)}
    private
      Prop: TProperties;
      SaveID: string;
      function GetClass: string;    
      function GetID: string;    
      function GetStyle: TProperties;
    public
      destructor Destroy; override;
      procedure Clear;
      function Find(Sy: Symb; var T: TAttribute): boolean;
      property TheClass: string read GetClass;    
      property TheID: string read GetID;    
      property TheStyle: TProperties read GetStyle;
    end;

  TBitmapItem = class(TObject)
  public
    AccessCount: integer;
    UsageCount: integer;     {how many in use}
    Transp: Transparency;    {identifies what the mask is for}
    MImage: TPersistent;     {main image, bitmap or animated GIF}
    Mask: TBitmap;  {its mask}
    constructor Create(AImage: TPersistent; AMask: TBitmap; Tr: Transparency);
    destructor Destroy; override;
  end;

  TStringBitmapList = class(TStringList)
      {a list of bitmap filenames and TBitmapItems}
  public
    MaxCache: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure DecUsage(const S: string);
    procedure IncUsage(const S: string);  
    procedure BumpAndCheck;
    procedure PurgeCache;
    function GetImage(I: integer): TPersistent;
    procedure SetCacheCount(N: integer);
  end;

  SelTextCount = class(TObject)
    Buffer: PChar;
    BufferLeng: integer;
    Leng: integer;
    procedure AddText(P: PChar; Size: integer); virtual;
    procedure AddTextCR(P: PChar; Size: integer);
    function Terminate: integer; virtual;
    end;

  SelTextBuf = class(SelTextCount)      
    constructor Create(ABuffer: PChar; Size: integer);
    procedure AddText(P: PChar; Size: integer); override;
    function Terminate: integer; override;
    end;

  ClipBuffer = class(SelTextBuf)
    constructor Create;
    destructor Destroy; override;
    function Terminate: integer; override;
    end;

  TUrlTarget = Class(TObject)
    URL,
    Target: String;
    ID: integer;
    constructor Create;
    procedure Copy(UT: TUrlTarget);
    destructor Destroy; override;
    procedure Assign(AnUrl, ATarget: String);
    procedure Clear;
    end;

  TMapItem = class(TObject)   {holds a client map info}
    MapName: String;
    Areas: TStringList;       {holds the URL and region handle}
    AreaTargets: TStringList; {holds the target window}
    constructor Create;
    destructor Destroy; override;
    function GetURL(X, Y: integer; var URLTarg: TURLTarget): boolean;
    procedure AddArea(Attrib: TAttributeList);
    end;

  TDib = class(TObject)
    private
      Info  : PBitmapInfoHeader;
      InfoSize: integer;
      Image: Pointer;
      ImageSize : integer;
      FHandle: THandle;
      procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP);
      procedure GetDIBX(DC: HDC; Bitmap: HBITMAP; Palette: HPALETTE);
      procedure Allocate(Size: integer);
      procedure DeAllocate;
    public
      constructor CreateDIB(DC: HDC; Bitmap: TBitmap);
      destructor Destroy; override;
      function CreateDIBmp: hBitmap;
      procedure DrawDIB(DC: HDC; X: Integer; Y: integer; W, H: integer;
                ROP: DWord);
    end;

  IndentRec = Class(TObject)
    X: integer;       {indent for this record}
    YT, YB: integer;  {top and bottom Y values for this record}
    ID: TObject;      {level inicator for this record, 0 for not applicable}
    Float: boolean;   {set if Floating block boundary}
    end;

  IndentManagerBasic = class(TObject)
    Width, ClipWidth: Integer;
    L, R: TFreeList;  {holds info (IndentRec's) on left and right indents}
    CurrentID: TObject;       {the current level (a TBlock pointer)}
    LfEdge, RtEdge: integer;     {current extreme edges}

    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Reset(Lf, Rt: integer);
    procedure UpdateTable(Y: integer; IW: integer; IH: integer; Justify: JustifyType);
    function LeftIndent(Y: integer): integer;
    function RightSide(Y: integer): integer;
    function ImageBottom: integer;
    procedure GetClearY(var CL, CR: integer);
    function GetNextWiderY(Y: integer): integer;
    function SetLeftIndent(XLeft, Y: integer): integer;
    function SetRightIndent(XRight, Y: integer): integer;
    procedure FreeLeftIndentRec(I: integer);   
    procedure FreeRightIndentRec(I: integer);   
    end;

  AllocRec = Class(TObject)
    Ptr: Pointer;
    ASize: integer;
    AHandle: THandle;
    end;

  IndexArray = array[1..TokenLeng] of integer;
  ChrArray = array[1..TokenLeng] of Char;   
  TokenObj= class     
  private
    St: string;
    StringOK: boolean;
    function GetString: string;
  public
    C: ^ChrArray;
    I: ^IndexArray;
    MaxIndex, Leng: integer;
    constructor Create;
    destructor Destroy; override;
    procedure AddChar(Ch: char; Ind: integer);
    procedure Concat(T: TokenObj);
    procedure Clear;
    procedure Remove(N: integer);
    procedure Replace(N: integer; Ch: char);
    property S: string read GetString;
    end;

  TIDObject = class(TObject)
  protected
    function GetYPosition: integer; virtual; abstract;
  public
    property YPosition: integer read GetYPosition;
    destructor Destroy; override;
    end;

  TChPosObj = class (TIDObject)
  private
    ChPos: integer;
    List: TList;
  protected
    function GetYPosition: integer; override;
    end;

  TIDNameList = class(TStringList)
  private
    OwnerList: TList;
  public
    constructor Create(List: TList);
    destructor Destroy; override;
    procedure Clear; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure AddChPosObject(const S: string; Pos: integer);
    end;

  ImageType = (NoImage, Bmp, Gif, Gif89, Png, Jpg);

var
  ColorBits: Byte;
  ThePalette: HPalette;       {the rainbow palette for 256 colors}
  DefBitMap, ErrorBitMap, ErrorBitmapMask: TBitMap;
  ABitmapList: TStringBitmapList; {the image cache}
  WaitStream: TMemoryStream;  

Function IntMin(A, B : Integer) : Integer;
Function IntMax(A, B : Integer) : Integer;

function GetImageFromFile(const Filename: String): TBitmap;
function GetImageAndMaskFromFile(const Filename: String; var Transparent: Transparency;
                            var Mask: TBitmap): TBitmap;
function HTMLToDos(FName: string): string;
  {convert an HTML style filename to one for Dos}
function HTMLServerToDos(FName, Root: string): string;
function Trim(S : String) : String;
{Trims leading and trailing spaces and control chars from string}

procedure WrapText(Canvas: TCanvas; X1, Y1, X2, Y2: integer; S: string);

procedure FinishTransparentBitmap (ahdc: HDC;
            InImage, Mask: TBitmap; xStart, yStart, W, H: integer);  
function GetImageMask(Image: TBitmap; ColorValid: boolean; AColor: TColor): TBitmap;
function TransparentGIF(const FName: string; var Color: TColor): boolean;
function Allocate(Size: integer): AllocRec;
procedure DeAllocate(AR: AllocRec);
function CopyPalette(Source: hPalette): hPalette;
procedure SetGlobalPalette(Value: HPalette);
function GetImageAndMaskFromStream(Stream: TMemoryStream;
        var Transparent: Transparency; var Mask: TBitmap): TBitmap;
function KindOfImage(Start: Pointer): ImageType;
procedure FormControlRect(Canvas: TCanvas; X1: integer;
           Y1: integer; X2: integer; Y2: integer; Raised: boolean);
function GetXExtent(DC: HDC; P: PChar; N: integer): integer;
function IsTransparent(Stream: TStream; var Color: TColor): boolean;
{$ifdef HtmlUseDll}
function GetImageFromStream(Stream: TMemoryStream; Convert: boolean): TBitmap;
{$endif}
procedure RaisedRect(SectionList: TFreeList; Canvas: TCanvas; X1: integer;
           Y1: integer; X2: integer; Y2: integer; Raised: boolean);
procedure RaisedRectColor(SectionList: TFreeList; Canvas: TCanvas; X1: integer;
           Y1: integer; X2: integer; Y2: integer; Light, Dark: TColor; Raised: boolean);
procedure PrintBitmap(Canvas: TCanvas; X, Y, W, H: integer;
             BMHandle: HBitmap);
procedure PrintTransparentBitmap1(Canvas: TCanvas; X, Y, NewW, NewH: integer;
             Bitmap, Mask: TBitmap; YI, HI: integer);
{$ifdef ver100_plus}
procedure PrintTransparentBitmap3(Canvas: TCanvas; X, Y, NewW, NewH: integer;
             Bitmap, Mask: TBitmap; YI, HI: integer);  
{$endif}
{$ifdef Ver90}
procedure Assert(B: boolean; const S: string);
{$endif}

implementation

uses
{$ifdef HtmlUseDLL}
  {$ifdef CppBuilder}        {C++Builder}
    {$ifdef ShareWare}
      DLLDemA,
    {$else}
      DLLINTBC,
    {$endif}
  {$else}
    {$ifdef ShareWare}
      DLLDEMA,
    {$else}
      DLLINTa,
    {$endif}
  {$endif}
{$endif}

{$ifndef HtmlUseDll}
  {$ifdef ver100_plus}
     jpeg, DitherUnit,
  {$endif}
{$endIf}
     htmlview, htmlsubs, HtmlGif, StylePars;

{$ifndef HtmlUseDll}
  {$ifdef ver100_plus}
type
  TJpegMod = class(TJpegImage)
  public
    property Bitmap;
  end;
  {$endif}
{$endIf}

var
  DC: HDC;
{$ifdef HtmlUseDll}
  Dither: byte;
{$endif}

Function IntMin(A, B : Integer) : Integer;
asm
  cmp edx, eax
  jnle @1
  mov eax, edx
@1:
end;

Function IntMax(A, B : Integer) : Integer;
asm
  cmp edx, eax
  jl @1
  mov eax, edx
@1:
end;

function HTMLServerToDos(FName, Root: string): string;
begin
Result := HTMLToDos(FName);
if (Length(Result) >= 1) and (Result[1] = '\') and
    not ((Length(Result) > 1) and (Result[2] = '\')) then   
  Result := Root+Result;
end;

function HTMLToDos(FName: string): string;
{convert an HTML style filename to one for Dos}
var
  I: integer;

  procedure Replace(Old, New: char);
  var
    I: integer;
  begin
  I := Pos(Old, FName);
  while I > 0 do
    begin
    FName[I] := New;
    I := Pos(Old, FName);
    end;
  end;

  procedure ReplaceEscapeChars;  
  var
    S: string[3];
    I: integer;
  begin
  I := Pos('%', FName);
  while (I > 1) and (I <= Length(FName)-2) do
    begin
    S := '$'+FName[I+1]+FName[I+2];
    try
      FName[I] := chr(StrToInt(S));
      Delete(FName, I+1, 2);
    except   {ignore exception}
      Exit;
      end;
    I := Pos('%', FName);
    end;
  end;

begin
ReplaceEscapeChars; 
I := pos('/', FName);
if I <> 0 then
  begin
  I := Pos('file:///', Lowercase(FName));
  if I > 0 then
    System.Delete(FName, I, 8)
  else
    begin
    I := Pos('file://', Lowercase(FName));
    if I > 0 then System.Delete(FName, I, 7);
    end;
  Replace('|', ':');
  Replace('/', '\');
  end;
Result := FName;
end;

function Trim(S : String) : String;
{Trims leading and trailing spaces and control chars from string}
var
  I, Len : Integer;
begin
while (Length(S) > 0) and (S[Length(S)] <= ' ') do  SetLength(S, Length(S)-1);
if Length(S) > 0 then
  begin
  I := 1;
  while S[I] <= ' ' do Inc(I);
  if I>1 then
    begin
    Len := Length(S) -I+1;
    Move(S[I], S[1], Len);
    SetLength(S, Len);
    end;
  end;
Trim := S;
end;

procedure WrapText(Canvas: TCanvas; X1, Y1, X2, Y2: integer; S: string);
{Wraps text in a clipping rectangle. Font must be set on entry}
var
  S1, S2: string;
  I, Y, Width, Step: integer;
  ARect: TRect;
  SaveStyle: TBrushStyle;
begin
with Canvas do
  begin
  SaveStyle := Brush.Style;  
  Brush.Style := bsClear;   
  ARect := Rect(X1, Y1, X2, Y2);
  Width := X2 - X1;                                
  Y := Y1;
  Step := TextHeight('A');
  SetTextAlign(Canvas.Handle, TA_Top);
  S1 := '';
  while (Length(S) > 0) and (Y+Step <= Y2) do
    begin
    S := Trim(S);   {in case of extra spaces}
    I := Pos(' ', S);
    if I > 0 then
      begin
      S2 := Copy(S, 1, I-1);
      Delete(S, 1, I);
      end
    else
      Begin
      S2 := S;
      S := '';
      end;
    if TextWidth(S1+S2) <= Width then
      begin
      S1 := S1+S2+' ';
      end
    else
      begin
      if S1 <> '' then
        begin
        TextRect(ARect, X1, Y, S1);
        Inc(Y, Step);
        end;
      S1 := S2+' ';
      end;
    end;
  if (S1 <> '') and (Y+Step <= Y2) then
    TextRect(ARect, X1, Y, S1);
  Brush.Style := SaveStyle;
  end;
end;

function Allocate(Size: integer): AllocRec;
begin
Result := AllocRec.Create;
with Result do
  begin
  ASize := Size;
  if Size < $FF00 then
    GetMem(Ptr, Size)
  else
     begin
     AHandle := GlobalAlloc(HeapAllocFlags, Size);
     if AHandle = 0 then
         ABort;
     Ptr := GlobalLock(AHandle);
     end;
  end;
end;

procedure DeAllocate(AR: AllocRec);
begin
with AR do
  if ASize < $FF00 then
    Freemem(Ptr, ASize)
  else
    begin
    GlobalUnlock(AHandle);
    GlobalFree(AHandle);
    end;
AR.Free;
end;

function GetXExtent(DC: HDC; P: PChar; N: integer): integer;
var
  ExtS: TSize;
 {$ifndef ver120_plus}
   NilP: integer absolute 0;
 {$endif}

begin
{$ifdef ver120_plus}
  GetTextExtentExPoint(DC, P, N, 0, Nil, Nil, ExtS);
{$else} {do Nil the hard way for Delphi 3}
  GetTextExtentExPoint(DC, P, N, 0, NilP, NilP, ExtS);
{$endif}
Result := ExtS.cx;
end;

procedure FormControlRect(Canvas: TCanvas; X1: integer;
           Y1: integer; X2: integer; Y2: integer; Raised: boolean);
{Draws lowered rectangles for form control printing}
var
  OldStyle: TPenStyle;
  OldWid: integer;
  OldBrushStyle: TBrushStyle;
  OldBrushColor: TColor;
  Mono: boolean;
begin
with Canvas do
  begin
  Mono := (GetDeviceCaps(Handle, BITSPIXEL) = 1) and
          (GetDeviceCaps(Handle, PLANES) = 1);
  Dec(X2);  Dec(Y2);
  OldWid := Pen.Width;
  OldStyle := Pen.Style;
  OldBrushStyle := Brush.Style;   {save style first}
  OldBrushColor := Brush.Color;
  Brush.Color := clWhite;
  Brush.Style := bsSolid;
  FillRect(Rect(X1, Y1, X2, Y2));
  Brush.Color := OldBrushColor;
  Brush.Style := OldBrushStyle;    {style after color as color changes style}

  Pen.Style := psInsideFrame;
  if Mono then
    begin
    Pen.Width := 1;
    Pen.Color := clBlack;
    end
  else
    begin
    Pen.Width := 2;
    if Raised then Pen.Color := clSilver
      else Pen.Color := clBtnShadow;
    end;
  MoveTo(X1, Y2);
  LineTo(X1, Y1);
  LineTo(X2, Y1);
  if not Mono then
    if Raised then Pen.Color := clBtnShadow
      else Pen.Color := clSilver;
  LineTo(X2, Y2);
  LineTo(X1, Y2);
  Pen.Style := OldStyle;
  Pen.Width := OldWid;
  end;
end;

procedure RaisedRect(SectionList: TFreeList; Canvas: TCanvas; X1: integer;
           Y1: integer; X2: integer; Y2: integer; Raised: boolean);
{Draws raised or lowered rectangles for table borders}
var
  White, BlackBorder: boolean;
begin
Y1 := IntMax(Y1, TopLim);
Y2 := IntMin(Y2, BotLim);
with Canvas do
  begin
  with SectionList as TSectionList do
    begin
    White := Printing or ((Background and $FFFFFF = clWhite) or
        ((Background = clWindow) and (GetSysColor(Color_Window) = $FFFFFF)));  
    BlackBorder := Printing and (GetDeviceCaps(Handle, BITSPIXEL) = 1) and
        (GetDeviceCaps(Handle, PLANES) = 1);    
    end;
  if BlackBorder then
    begin
    Pen.Color := clBlack;
    end
  else if Raised then
    if White then
      Pen.Color := clSilver
    else Pen.Color := clBtnHighLight
  else Pen.Color := clBtnShadow;

  MoveTo(X1, Y2);
  LineTo(X1, Y1);
  LineTo(X2, Y1);
  if BlackBorder then        
    Pen.Color := clBlack
  else if not Raised then
    if White then
      Pen.Color := clSilver
    else Pen.Color := clBtnHighLight
  else Pen.Color := clBtnShadow;
  LineTo(X2, Y2);
  LineTo(X1, Y2);
  end;
end;

procedure RaisedRectColor(SectionList: TFreeList; Canvas: TCanvas; X1: integer;
           Y1: integer; X2: integer; Y2: integer; Light, Dark: TColor; Raised: boolean);
{Draws colored raised or lowered rectangles for table borders}
begin
Y1 := IntMax(Y1, TopLim);
Y2 := IntMin(Y2, BotLim);
with Canvas do
  begin
  if Raised then
    Pen.Color := Light
  else Pen.Color := Dark;

  MoveTo(X1, Y2);
  LineTo(X1, Y1);
  LineTo(X2, Y1);
  if not Raised then
    Pen.Color := Light
  else Pen.Color := Dark;
  LineTo(X2, Y2);
  LineTo(X1, Y2); 
  end;
end;

{$ifdef Ver90}
procedure Assert(B: boolean; const S: string);
begin   {dummy Assert for Delphi 2}
end;
{$endif}

destructor TFreeList.Destroy;
var
  I: integer;
begin
for I := 0 to Count-1 do
  TObject(Items[I]).Free;
inherited Destroy;
end;

procedure TFreeList.Clear;
var
  I: integer;
begin
for I := 0 to Count-1 do
  TObject(Items[I]).Free;
inherited Clear;
end;

constructor TBitmapItem.Create(AImage:TPersistent; AMask: TBitmap; Tr: Transparency);
begin
inherited Create;
MImage := AImage;
Mask := AMask;
AccessCount := 0;
Transp := Tr;
end;

destructor TBitmapItem.Destroy;
begin
Assert(UsageCount = 0, 'Freeing Image still in use'); 
MImage.Free;
Mask.Free;
inherited Destroy;
end;

constructor TStringBitmapList.Create;
begin
inherited Create;
MaxCache := 4;
end;

destructor TStringBitmapList.Destroy;
var
  I: integer;
begin
for I := 0 to Count-1 do
  (Objects[I] as TBitmapItem).Free;
inherited Destroy;
end;

function TStringBitmapList.AddObject(const S: string; AObject: TObject): Integer;
begin
Result := inherited AddObject(S, AObject);
if AObject is TBitmapItem then
  Inc(TBitmapItem(AObject).UsageCount);
end;

procedure TStringBitmapList.DecUsage(const S: string);
var
  I: integer;
begin
I := IndexOf(S);
if I >= 0 then
  with Objects[I] as TBitmapItem do
    begin
    Dec(UsageCount);
    Assert(UsageCount >= 0, 'Cache image usage count < 0');  
    end;
end;

procedure TStringBitmapList.IncUsage(const S: string);
var
  I: integer;
begin
I := IndexOf(S);
if I >= 0 then
  with Objects[I] as TBitmapItem do
    Inc(UsageCount);
end;

procedure TStringBitmapList.SetCacheCount(N: integer);
var
  I: integer;
begin
for I := Count-1 downto 0 do
  with (Objects[I] as TBitmapItem)do
    begin
    if (AccessCount > N) and (UsageCount <= 0) then     
      begin
      Delete(I);
      Free;
      end;
    end;
MaxCache := N;
end;

function TStringBitmapList.GetImage(I: integer): TPersistent;
begin
with Objects[I] as TBitmapItem do
  begin
  Result := MImage;
  AccessCount := 0;
  Inc(UsageCount);
  end;
end;

procedure TStringBitmapList.BumpAndCheck;
var
  I: integer;
  Tmp: TBitmapItem;
begin
  for I := Count-1 downto 0 do
    begin
    Tmp := (Objects[I] as TBitmapItem);
    with Tmp do
      begin
      Inc(AccessCount);
      if (AccessCount > MaxCache) and (UsageCount <= 0) then
        begin
        Delete(I);
        Free;          {the TBitmapItem}
        end;
      end;
    end;
end;

procedure TStringBitmapList.PurgeCache;
var
  I: integer;
  Tmp: TBitmapItem;
begin
for I := Count-1 downto 0 do
  begin
  Tmp := (Objects[I] as TBitmapItem);
  with Tmp do
    begin
    if (UsageCount <= 0) then
      begin
      Delete(I);
      Free;          {the TBitmapItem}
      end;
    end;
  end;
end;

procedure TStringBitmapList.Clear;
var
  I: integer;
begin
for I := 0 to Count-1 do
  (Objects[I] as TBitmapItem).Free;
inherited Clear;
end;

constructor TAttribute.Create(ASym: Symb; AValue: integer; Const AString: String);
begin
inherited Create;
Which := ASym;
Value := AValue;
Name := AString;
end;

destructor TAttribute.Destroy;
begin
inherited Destroy;
end;

{----------------TAttributeList}
destructor TAttributeList.Destroy;
begin
Prop.Free;
inherited;
end;

procedure TAttributeList.Clear;
begin
SaveID := '';
inherited Clear;
end;

function TAttributeList.Find(Sy: Symb; var T: TAttribute): boolean;
var
  I: integer;
begin
for I := 0 to Count-1 do
  if TAttribute(Items[I]).which = Sy then
    begin
    Result := True;
    T := Items[I];
    Exit;
    end;
Result := False;
end;

function TAttributeList.GetClass: string;
var
  T: TAttribute;
begin
if Find(ClassSy, T) then
  Result := Lowercase(T.Name)
else Result := '';
end;

function TAttributeList.GetID: string;
var
  T: TAttribute;
begin
Result := SaveID;
if (Result = '') and Find(IDSy, T) then
  begin
  Result := Lowercase(T.Name);
  SaveID := Result;
  end;
end;

function TAttributeList.GetStyle: TProperties;
var
  T: TAttribute;
begin
if Find(StyleSy, T) then
  begin
  Prop.Free;
  Prop := TProperties.Create;
  Result := Prop;
  ParsePropertyStr(T.Name, Result);
  end
else Result := Nil;
end;

{----------------TUrlTarget.Create}
constructor TUrlTarget.Create;
begin
inherited Create;
end;

destructor TUrlTarget.Destroy;
begin
inherited Destroy;
end;

var
  Sequence: integer = 10;

procedure TUrlTarget.Assign(AnUrl, ATarget: String);
begin
Url := AnUrl;
Target := ATarget;
ID := Sequence;
Inc(Sequence);
end;

procedure TUrlTarget.Copy(UT: TUrlTarget);
begin
Url := UT.Url;
Target := UT.Target;
ID := UT.ID;
end;

procedure TUrlTarget.Clear;
begin
Url := '';
Target := '';
ID := 0;
end;

{----------------SelTextCount}
procedure SelTextCount.AddText(P: PChar; Size: integer);
var
  I: integer;
begin
for I := 0 to Size-1 do
  if not (P[I] in [FmCtl, ImgPan, nbFmCtl, nbImgPan]) then {ImgPan and FmCtl used to mark images, form controls}
    Inc(Leng);
end;

procedure SelTextCount.AddTextCR(P: PChar; Size: integer);
begin
AddText(P, Size);
AddText(^M^J, 2);
end;

function SelTextCount.Terminate: integer;
begin
Result := Leng;  
end;

{----------------SelTextBuf.Create}
constructor SelTextBuf.Create(ABuffer: PChar; Size: integer); 
begin
inherited Create;
Buffer := ABuffer;
BufferLeng := Size;
end;

procedure SelTextBuf.AddText(P: PChar; Size: integer);    
var
  SizeM1 : integer;
  I: integer;
begin
SizeM1 := BufferLeng-1;
for I := 0 to Size-1 do
  if not (P[I] in [FmCtl, ImgPan, nbFmCtl, nbImgPan, BrkCh]) then {ImgPan and FmCtl used to mark images, form controls, #8 for break}
    if Leng < SizeM1 then
      begin
      if P[I] = #160 then   
        Buffer[Leng] := ' '
      else Buffer[Leng] := P[I];
      Inc(Leng);
      end;
end;

function SelTextBuf.Terminate: integer;
begin
Buffer[Leng] := #0;
Result := Leng+1;
end;

{----------------ClipBuffer.Create}
constructor ClipBuffer.Create;
begin
inherited Create(Nil, 0);     
BufferLeng := 32500;
Getmem(Buffer, BufferLeng);
end;

destructor ClipBuffer.Destroy;
begin
if Assigned(Buffer) then FreeMem(Buffer, BufferLeng);
inherited Destroy;
end;

function ClipBuffer.Terminate: integer;
begin
Buffer[Leng] := #0;
Result := Leng+1;
Clipboard.SetTextBuf(Buffer);
end;

{----------------TMapItem.Create}
constructor TMapItem.Create;
begin
inherited Create;
Areas := TStringList.Create;
AreaTargets := TStringList.Create;
end;

destructor TMapItem.Destroy;
var
  I: integer;
begin
for I := 0 to Areas.Count-1 do
  DeleteObject(THandle(Areas.Objects[I]));
Areas.Free;
AreaTargets.Free;
inherited Destroy;
end;

function TMapItem.GetURL(X, Y: integer; var URLTarg: TUrlTarget): boolean;
var
  I: integer;
begin
Result := False;
with Areas do
  for I := 0 to Count-1 do
    if PtInRegion(THandle(Objects[I]), X, Y) then
      begin
      if Strings[I] <> '' then  {could be NoHRef}    
        begin
        URLTarg := TUrlTarget.Create;
        URLTarg.URL := Strings[I];
        URLTarg.Target := AreaTargets[I];
        Result := True;
        end;
      Exit;
      end;
end;

procedure TMapItem.AddArea(Attrib: TAttributeList);
Const
  MAXCNT = 300;  
var
  I, Cnt, Rad: integer;
  HRef, S, Target: string;
  S1, Nm: string[20];
  Coords: array[0..MAXCNT] of integer;
  Rect: TRect absolute Coords;
  Handle: THandle;
  Shape: (Rec, Circle, Poly);

  procedure GetSubStr;    
  var
    J,K: integer;
  begin
  J := Pos(',', S);
  K := Pos(' ', S);   {for non comma situations (bad syntax)}
  if (J > 0) and ((K = 0) or (K > J)) then
    begin
    S1 := copy(S, 1, J-1);
    Delete(S, 1, J);
    end
  else if K > 0 then
    begin
    S1 := copy(S, 1, K-1);
    Delete(S, 1, K);
    end
  else
    begin
    S1 := Trim(S);
    S := '';
    end;
  while (Length(S) > 0) and ((S[1]=',') or (S[1]=' ')) do
    Delete(S, 1, 1);
  end;

begin
HRef := '';
Target := '';
Shape := Rec;
Cnt := 0;
Handle := 0;
for I := 0 to Attrib.Count-1 do
  with TAttribute(Attrib[I]) do
    case Which of
      HRefSy:  HRef := Name;
      TargetSy:  Target := Name;
      NoHrefSy: HRef := '';
      CoordsSy:
        begin
        S := Trim(Name);
        Cnt := 0;
        GetSubStr;
        while (S1 <> '') and (Cnt <= MAXCNT) do
          begin
          Coords[Cnt] := StrToIntDef(S1, 0);
          GetSubStr;
          Inc(Cnt);
          end;
        end;
      ShapeSy:
        begin
        Nm := copy(Lowercase(Name),1, 4);
        if Nm = 'circ' then Shape := Circle
        else if (Nm = 'poly') then Shape := Poly;
        end;
      end;
case Shape of
  Rec:
    begin
    if Cnt < 4 then Exit;
    Inc(Coords[2]);
    Inc(Coords[3]);
    Handle := CreateRectRgnIndirect(Rect);
    end;
  Circle:
    begin
    if Cnt < 3 then Exit;
    Rad := Coords[2];
    Dec(Coords[0],Rad);
    Dec(Coords[1],Rad);
    Coords[2] := Coords[0] + 2*Rad +1;
    Coords[3] := Coords[1] + 2*Rad +1;
    Handle := CreateEllipticRgnIndirect(Rect);
    end;
  Poly:
    begin
    if Cnt < 6 then Exit;
    Handle := CreatePolygonRgn(Coords, Cnt div 2, Winding);
    end;
  end;
if Handle <> 0 then
  begin
  Areas.AddObject(HRef, TObject(Handle));
  AreaTargets.Add(Target);
  end;
end;

{$ifdef HtmlUseDll}      
Function ImageLibCallBack(i : integer) : integer; cdecl; export;
{Callback function from the dll, CDECL and EXPORT ARE REQUIRED}
begin
 if Application.Terminated then begin
   {User wants to terminate the program. Pass a 0 to the dll}
   Result:=0;
  end else begin
  {Be nice to others <g>}
   Application.ProcessMessages;
   {tell the dll that everything is OK}
   Result:=1;
   end;
end;
{$endif}

function KindOfImage(Start: Pointer): ImageType;
type
  ByteArray = array[0..10] of byte;
var
  PB: ^ByteArray absolute Start;
  PW: ^Word absolute Start;
  PL: ^DWord absolute Start;
begin
if PL^ = $38464947 then
  begin
  if PB^[4] = Ord('9') then Result := Gif89
  else Result := Gif;
  end
else if PW^ = $4D42 then Result := Bmp
else if PL^ = $474E5089 then Result := Png
{$ifdef HtmlUseDll}
else if PL^ = $E0FFD8FF then Result := Jpg
{$else}
else if PW^ = $D8FF then Result := Jpg   
{$endif}
else Result := NoImage;
end;

function KindOfImageFile(const FName: string): ImageType;
var
  Stream: TFileStream;
  Ar: Array[0..10] of byte;
begin
{Result := NoImage;}                      
Stream := TFileStream.Create(FName, fmShareDenyWrite or FmOpenRead);
try
  Stream.Read(Ar, Sizeof(Ar));
  Result := KindOfImage(@Ar);
finally
  Stream.Free;
  end;
end;

{$A-} {record field alignment off for this routine}

function IsTransparent(Stream: TStream; var Color: TColor): boolean;
{Makes some simplifying assumptions that seem to be generally true for single
 images.}
Type
  RGB = record
    Red, Green, Blue: byte;
    end;

  GifHeader = record
    GIF: array[0..2] of char;
    Version: array[0..2] of char;
    ScreenWidth, ScreenHeight: Word;
    Field: Byte;
    BackGroundColorIndex: byte;
    AspectRatio: byte;
    end;
  ColorArray = array[0..255] of RGB;

var
  Header: ^GifHeader;
  X: integer;
  Colors: ^ColorArray;
  Buff: array[0..Sizeof(GifHeader)+Sizeof(ColorArray)+8] of byte;
  P: PChar;
  OldPosition: integer;

begin
Result := False;
Fillchar(Buff, Sizeof(Buff), 0);  {in case read comes short}
OldPosition := Stream.Position;
Stream.Position := 0;
Stream.Read(Buff, Sizeof(Buff));
Stream.Position := OldPosition;

Header := @Buff;
if KindOfImage(Header) <> Gif89 then Exit; 
Colors := @Buff[Sizeof(GifHeader)];
with Header^ do
  begin
  X := 1 shl ((Field and 7) +1) - 1;  {X is last item in color table}
  if X = 0 then Exit;   {no main color table}
  end;
P := PChar(Colors)+(X+1)*Sizeof(RGB);
if (P^ <> #$21) or ((P+1)^ <> #$F9) then Exit;  {extension block not found}
if (ord(P[3]) and 1 <> 1) then Exit;     {no transparent color specified}

with Colors^[Ord(P[6])] do
  Color := integer(Blue) shl 16 or integer(Green) shl 8 or integer(Red);
Result := True;
end;

{$A+}

{$A-} {record field alignment off for this routine}

function IsTransparentPng(Stream: TStream; var Color: TColor): boolean;
Type
  RGB = record
    Red, Green, Blue: byte;
    end;

  PngHeader = record
    width       : integer;
    height      : integer;
    bitDepth    : byte;
    colorType   : byte;
    compression : byte;
    filter      : byte;
    interlace   : byte;
    end;
var
  Header: PngHeader;
  CRC: integer;
  OldPosition: integer;
  pngPalette: array[0..255] of RGB;
  dataSize : integer;
  chunkType: array[0..4] of Char;
  chunkTypeStr: string;
  done : Boolean;
  Ar: Array[0..10] of byte;

  function IntSwap(data: integer): integer;
  var
     byte0 : integer;
     byte1 : integer;
     byte2 : integer;
     byte3 : integer;
  begin
     byte0 := data and $FF;
     byte1 := (data shr 8) and $FF;
     byte2 := (data shr 16) and $FF;
     byte3 := (data shr 24) and $FF;

     result := (byte0 shl 24) or (byte1 shl 16) or (byte2 shl 8) or byte3;
  end;

begin
result := false;
OldPosition := Stream.Position;

try
   Stream.Position := 0;
   Stream.Read(Ar, 8);

   if KindOfImage(@Ar) <> Png then
     begin
     Stream.Position := OldPosition;
     Exit;
     end;

   Stream.Position := 8; {past the PNG Signature}
   done := False;

{Read Chunks}
   repeat
      Stream.Read(dataSize, 4);
      dataSize := IntSwap(dataSize);
      Stream.Read(chunkType, 4);
      chunkType[4] := #0; {make sure string is NULL terminated}
      chunkTypeStr := StrPas(chunkType);
      if chunkTypeStr = 'IHDR' then
      begin
         Stream.Read(Header, DataSize);
         Header.width := IntSwap(Header.width);
         Header.height := IntSwap(Header.height);
         Stream.Read(CRC, 4); {read it in case we need to read more}
         if (Header.colorType < 2) or (Header.colorType > 3) then
            done := True; {only type 2 and 3 use tRNS}
      end
      else if chunkTypeStr = 'PLTE' then
      begin
         Stream.Read(pngPalette, DataSize);
         Stream.Read(CRC, 4); {read it in case we need to read more}
      end
      else if chunkTypeStr =  'tRNS' then
      begin
         if Header.colorType = 3 then
         begin
            with pngPalette[dataSize - 1] do
               Color := integer(Blue) shl 16 or integer(Green) shl 8 or integer(Red);
         end
         else  {has to have been 2}
         begin
            {for now I am ignoring this since I can't make one}
         end;
         result := true;
         done := true; {got everything we need at this point}
      end
      else if chunkTypeStr = 'IDAT' then
         done := True {if this chunk is hit there is no tRNS}
      else
         Stream.Position := Stream.Position + dataSize + 4; {additional 4 for the CRC}
   until done = True;
except
   end;

Stream.Position := OldPosition;
end;

{$A+}

function TransparentGIF(const FName: string; var Color: TColor): boolean;
{Looks at a GIF image file to see if it's a transparent GIF.}
var
  Stream: TFileStream;
begin
Result := False;
try
  Stream := TFileStream.Create(FName, fmShareDenyWrite or FmOpenRead);
  try
    Result := IsTransparent(Stream, Color);
  finally
    Stream.Free;
  end;
except
  end;
end;

function TransparentPNG(const FName: string; var Color: TColor): boolean;
{Looks at a PNG image file to see if it's transparent.}
var
  Stream: TFileStream;
begin
Result := False;
try
  Stream := TFileStream.Create(FName, fmShareDenyWrite or FmOpenRead);
  try
    Result := IsTransparentPng(Stream, Color);
  finally
    Stream.Free;
  end;
except
  end;
end;

function ConvertImage(Bitmap: TBitmap): TBitmap;
{convert bitmap into a form for BitBlt later}

  function DIBConvert: TBitmap;
  var
    DC: HDC;
    DIB: TDib;
    OldBmp: HBitmap;
    OldPal: HPalette;
    Hnd: HBitmap;
  begin
  DC := CreateCompatibleDC(0);
  OldBmp := SelectObject(DC, Bitmap.Handle);
  OldPal := SelectPalette(DC, ThePalette, False);
  RealizePalette(DC);
  DIB := TDib.CreateDIB(DC, Bitmap);
  Hnd := DIB.CreateDIBmp;
  DIB.Free;
  SelectPalette(DC, OldPal, False);
  SelectObject(DC, OldBmp);
  DeleteDC(DC);
  Bitmap.Free;
  Result := TBitmap.Create;
  Result.Handle := Hnd;
  if (ColorBits = 8) and (Result.Palette = 0) then  
    Result.Palette := CopyPalette(ThePalette);
  end;

begin
if not Assigned(Bitmap) then
  begin
  Result := Nil;
  Exit;
  end;

{$ifndef ver100_plus}  {Delphis 1 and 2}
if ColorBits > 8 then
  begin
  Result := Bitmap;
  Exit;
  end;
Result := DIBConvert;
Exit;
{$endif}

{Remainder is for Delphis >= 3 or C++Builder >= 3}

{$ifdef ver100_plus}

if ColorBits > 8 then
  begin
  if Bitmap.PixelFormat <= pf8bit then
    Result := DIBConvert
  else
    Result := Bitmap;
  Exit;
  end;

{$ifndef HtmlUseDll}
if Bitmap.HandleType = bmDIB then
  begin
  Result := GetBitmap(Bitmap);
  Bitmap.Free;
  Exit;
  end;
{$endif}
Result := DIBConvert;
{$endif}
end;

{$ifdef HtmlUseDLL}
function GetImageFromStream(Stream: TMemoryStream; Convert: boolean): TBitmap;
var
  IT: ImageType;
  BmpLoaded: boolean;
begin
try
  Result := TBitmap.Create;
  try
    IT := KindOfImage(Stream.Memory);
    Convert := Convert and (IT in [Bmp, Gif, Gif89]);  

    if  (IT = Bmp) then
      begin
      try
        BmpLoaded := BmpStream(Stream, ColorBits, Dither, Result, ImageLibCallBack);
      except
        BmpLoaded := True;
        Result.LoadFromStream(Stream);
        end;
      if not BmpLoaded then Result.LoadFromStream(Stream);
      end     
    else if  (IT = Png) and PngStream(Stream, ColorBits, Dither, Result,
             ImageLibCallBack) then
    else if  (IT = Jpg) and JpgStream(Stream, ColorBits, Dither, Result,
             ImageLibCallBack) then
    else
        begin
        Result.Free;
        Result := Nil;
        Exit;
        end;
    if Convert then
      Result := ConvertImage(Result);
  except
    Result.Free;
    Result := Nil;
  end;
except
  Result := Nil;
  end;
end;
{$endif}

function GetImageFromFileInternal(const Filename: String; Convert: boolean): TBitmap;
var
  IT: ImageType;
{$ifdef HtmlUseDll}
  BmpLoaded: boolean;
{$else}
  {$ifdef ver100_plus}   
  jpImage: TJpegMod;      
  {$endif}
{$endif}

  function GetGif(var Rslt: TBitmap): boolean;  
  var
    TmpGif: TGifImage;
    NonAnimated: boolean;
  begin
  Result := False;
  TmpGif := CreateAGif(Filename, NonAnimated);
  if Assigned(TmpGif) then
    begin
    if NonAnimated then Convert := False;
    Rslt.Assign(TmpGif.Bitmap);
    TmpGif.Free;
    Result := True;
    end
  end;

begin
try
  Result := TBitmap.Create;
  try
    IT := KindOfImageFile(Filename);

    {$ifdef HtmlUseDll}
      if  (IT = Bmp) then
         begin
         try
           BmpLoaded := BmpFile(Filename, ColorBits, Dither, Result,
                        ImageLibCallBack);
         except
           BmpLoaded := True;
           Result.LoadFromFile(Filename);
           end;
         if not BmpLoaded then Result.LoadFromFile(Filename);
         end
      else if  ((IT = Png) and PngFile(Filename, ColorBits, Dither, Result,
               ImageLibCallBack)) then
      else if  ((IT = Jpg) and JpgFile(Filename, ColorBits, Dither, Result,
               ImageLibCallBack)) then
      else if (IT in [Gif, Gif89]) and GetGif(Result) then   
      else
          begin
          Result.Free;
          Result := Nil;
          Exit;
          end;
    {$else}          {No DLL}
      if IT = Bmp then
        Result.LoadFromFile(Filename)
      else if (IT in [Gif, Gif89]) and GetGif(Result) then   
         {$ifdef ver100_plus}  
      else if IT = Jpg then
         begin
         jpImage := TJpegMod.Create;
         try
           try
             jpImage.LoadFromFile(Filename);
             if ColorBits <= 8 then
               begin
               jpImage.PixelFormat := jf8bit;
               if not jpImage.GrayScale and (ColorBits = 8) then  
                 jpImage.Palette := CopyPalette(ThePalette);
               end
             else jpImage.PixelFormat := jf24bit;
             Result.Assign(jpImage.Bitmap);
           finally
             jpImage.Free;
             end;
         except
           Result.Free;
           Result := Nil;
           end;
         end
      {$endif}
      else begin Result.Free; Result := Nil; Exit; end;
    {$endif}
    if Convert then
      Result := ConvertImage(Result);
  except
    Result.Free;
    Result := Nil;
  end;
except
  Result := Nil;
  end;
end;

function GetImageFromFile(const Filename: String): TBitmap;
begin
Result := GetImageFromFileInternal(Filename, True);
end;

function GetImageAndMaskFromFile(const Filename: String; var Transparent: Transparency;
                            var Mask: TBitmap): TBitmap;
var
  Color: TColor;
  TmpBmp: TBitmap;
  {$ifdef HtmlUseDll}
  SavePalette: HPalette;
  {$endif}
  Ext: string[10];
begin
Result := Nil;
if not FileExists(Filename) then Exit;
Ext := LowerCase(ExtractFileExt(Filename));
{$ifndef NoGIF}
if (Ext = '.gif') and TransparentGIF(Filename, Color) then
  Transparent := TGif;
{$endif}
if (Ext = '.png') and TransparentPng(Filename, Color) then
  Transparent := TPng;
Mask := Nil;
if Transparent = NotTransp then
  Result := GetImageFromFile(Filename)
else
  begin
  {$ifndef HtmlUseDll}
  TmpBmp := GetImageFromFileInternal(Filename, False);
  {$else}
  SavePalette := GlobalPalette;
  GlobalPalette := 0;   {for mask, want to get undithered image}
  TmpBmp := GetImageFromFileInternal(Filename, False);
  GlobalPalette := SavePalette;
  {$endif}

  if Assigned(TmpBmp) then
    try
      case Transparent of
        {$ifndef NoGIF}
        TGif, Tpng: Mask := GetImageMask(TmpBmp, True, Color);   
        {$else}
        Tpng: Mask := GetImageMask(TmpBmp, True, Color);
        {$endif}
        LLCorner: Mask := GetImageMask(TmpBmp, False, 0);
        end;
      if Assigned(Mask) then
        Result := GetImageFromFile(Filename);  {the dithered image}
    finally
      TmpBmp.Free;
      end;
  end;
end;

{$ifndef HtmlUseDll}
function GetImageAndMaskFromStream(Stream: TMemoryStream;
        var Transparent: Transparency; var Mask: TBitmap): TBitmap;
var
  IT: ImageType;
{$ifdef ver100_plus}   
  jpImage: TJpegMod;      
{$endif}
begin
Result := Nil;
Mask := Nil;
if not Assigned(Stream) or (Stream.Memory = Nil) or (Stream.Size < 20) then
  Exit;
Stream.Position := 0;
IT := KindOfImage(Stream.Memory);
if not (IT in [Bmp, Jpg]) then
  Exit;
Result := TBitmap.Create;
try
  {$ifdef ver100_plus}          
  if IT = Jpg then
    begin
    Transparent := NotTransp;
    jpImage := TJpegMod.Create;
    try
      jpImage.LoadFromStream(Stream);
      if ColorBits <= 8 then
        begin
        jpImage.PixelFormat := jf8bit;
        if not jpImage.GrayScale and (ColorBits = 8) then  
          jpImage.Palette := CopyPalette(ThePalette);
        end
      else jpImage.PixelFormat := jf24bit;
      Result.Assign(jpImage.Bitmap);
    finally
      jpImage.Free;
      end;
    end
  else
    Result.LoadFromStream(Stream);
  {$else}
  Result.LoadFromStream(Stream);
  {$endif}
  if Transparent = LLCorner then
    Mask := GetImageMask(Result, False, 0);
  Result := ConvertImage(Result);
except
  Result.Free;
  Result := Nil;
  end;
end;

{$else}    {HtmlUseDll}

function GetImageAndMaskFromStream(Stream: TMemoryStream;
        var Transparent: Transparency; var Mask: TBitmap): TBitmap;
var
  Color: TColor;
  TmpBmp: TBitmap;
  SavePalette: HPalette;
begin
Result := Nil;
if not Assigned(Stream) or (Stream.Memory = Nil) or (Stream.Size < 20) then
  Exit;
Stream.Position := 0;
if IsTransparent(Stream, Color) then  {check for transparent GIF}
  Transparent := TGif
else if IsTransparentPNG(Stream, Color) then  {check for transparent PNG}
  Transparent := TPng;
Mask := Nil;
if Transparent = NotTransp then
  Result := GetImageFromStream(Stream, True)
else
  begin
  SavePalette := GlobalPalette;
  GlobalPalette := 0;   {for mask, want to get undithered image}
  TmpBmp := GetImageFromStream(Stream, False);
  GlobalPalette := SavePalette;

  if Assigned(TmpBmp) then
    try
      case Transparent of
        TGif, TPng: Mask := GetImageMask(TmpBmp, True, Color);
        LLCorner: Mask := GetImageMask(TmpBmp, False, 0);
        end;
      if Assigned(Mask) then
        Result := GetImageFromStream(Stream, True);  {the dithered image}
    finally
      TmpBmp.Free;
      end;
  end;
end;
{$endif}

function GetImageMask(Image: TBitmap; ColorValid: boolean; AColor: TColor): TBitmap;
var
  TransparentColor: TColor;
  cColor          : TColorRef;
  bmAndObject,
  bmObjectOld     : HBitmap;
  hdcObject,
  hdcTemp,
  DC              : HDC;
  ptSize          : TPoint;
  Pal: HPalette;
begin
DC := GetDC(0);

if ColorValid then
  TransparentColor := AColor  {color has already been selected}
else
  {set the transparent color to be the lower left pixel of the bitmap}
  TransparentColor := Image.Canvas.Pixels[0, Image.Height - 1];

TransparentColor := TransparentColor or $02000000;

hdcTemp := CreateCompatibleDC(DC);
SelectObject (hdcTemp, Image.Handle); { select the bitmap }

{ convert bitmap dimensions from device to logical points}
ptSize.x := Image.Width;
ptSize.y := Image.Height;
DPtoLP (hdcTemp, ptSize, 1);  { convert from device logical points }

{ create some DCs to hold temporary data}
hdcObject := CreateCompatibleDC(DC);

{ create a bitmap for each DC}
{ monochrome DC}
bmAndObject := CreateBitmap (ptSize.x, ptSize.y, 1, 1, nil);

{ each DC must select a bitmap object to store pixel data}
bmObjectOld := SelectObject (hdcObject, bmAndObject);

{ set proper mapping mode}
SetMapMode (hdcTemp, GetMapMode(DC));

{ set the background color of the source DC to the color.
  contained in the parts of the bitmap that should be transparent}
Pal := Image.Palette;
SelectPalette(hdcTemp, Pal, False);
RealizePalette(hdcTemp);
cColor := SetBkColor (hdcTemp, TransparentColor);

{ create the object mask for the bitmap by performing a BitBlt()
  from the source bitmap to a monochrome bitmap}
BitBlt (hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);

{ set the background color of the source DC back to the original color}
SetBkColor (hdcTemp, cColor);

{Save the Object bitmap}
try
  Result := TBitmap.Create;
  try
    Result.Handle := bmAndObject;
  except
    Result.Free;
    Raise;
  end;
except
  Result := Nil;
end;

{ delete the memory bitmaps}
SelectObject (hdcObject, bmObjectOld);

{ delete the memory DCs}
DeleteDC (hdcObject);
DeleteDC (hdcTemp);
ReleaseDC(0, DC);
end;

{----------------FinishTransparentBitmap }
procedure FinishTransparentBitmap (ahdc: HDC;
              InImage, Mask: TBitmap; xStart, yStart, W, H: integer);   
var
  bmAndBack,
  bmSave,
  bmBackOld,
  bmObjectOld : HBitmap;
  hdcInvMask,
  hdcMask,
  hdcImage: HDC;
  DestSize, SrcSize : TPoint;
  OldBack, OldFore: TColor;
  BM: Windows.TBitmap;
  Image: TBitmap;

begin
Image := TBitmap.Create;  {protect original image} 
try
  Image.Assign(InImage);

  hdcImage := CreateCompatibleDC (ahdc);
  SelectObject (hdcImage, Image.Handle); { select the bitmap }

  { convert bitmap dimensions from device to logical points}
  SrcSize.x := Image.Width;
  SrcSize.y := Image.Height;
  DPtoLP(hdcImage, SrcSize, 1);

  DestSize.x := W;
  DestSize.y := H;
  DPtoLP (hdcImage, DestSize, 1);

  { create a bitmap for each DC}
  { monochrome DC}
  bmAndBack := CreateBitmap (SrcSize.x, SrcSize.y, 1, 1, nil);

  bmSave := CreateCompatibleBitmap (ahdc, DestSize.x, DestSize.y);
  GetObject(bmSave, SizeOf(BM), @BM);
  if (BM.bmBitsPixel > 1) or (BM.bmPlanes > 1) then
    begin
    { create some DCs to hold temporary data}
    hdcInvMask   := CreateCompatibleDC(ahdc);
    hdcMask := CreateCompatibleDC(ahdc);

    { each DC must select a bitmap object to store pixel data}
    bmBackOld   := SelectObject (hdcInvMask, bmAndBack);

    { set proper mapping mode}
    SetMapMode (hdcImage, GetMapMode (ahdc));

    bmObjectOld := SelectObject(hdcMask, Mask.Handle);

    { create the inverse of the object mask}
    BitBlt (hdcInvMask, 0, 0, SrcSize.x, SrcSize.y, hdcMask, 0, 0, NOTSRCCOPY);

    {set the background color of the source DC to the color contained in the
     parts of the bitmap that should be transparent, the foreground to the parts that
     will show}
    OldBack := SetBkColor(ahDC, clWhite);
    OldFore := SetTextColor(ahDC, clBlack);

    { Punch out a black hole in the background where the image will go}
    SetStretchBltMode(ahDC, WhiteOnBlack);
    StretchBlt (ahDC, XStart, YStart, DestSize.x, DestSize.y, hdcMask, 0, 0, SrcSize.x, SrcSize.y, SRCAND);

    { mask out the transparent colored pixels on the bitmap}
    BitBlt (hdcImage, 0, 0, SrcSize.x, SrcSize.y, hdcInvMask, 0, 0, SRCAND);

    { XOR the bitmap with the background on the destination DC}
    SetStretchBltMode(ahDC, ColorOnColor);
    StretchBlt(ahDC, XStart, YStart, W, H, hdcImage, 0, 0, Image.Width, Image.Height, SRCPAINT);

    SetBkColor(ahDC, OldBack);
    SetTextColor(ahDC, OldFore);

    { delete the memory bitmaps}
    DeleteObject (SelectObject (hdcInvMask, bmBackOld));
    SelectObject (hdcMask, bmObjectOld);

    { delete the memory DCs}
    DeleteDC (hdcInvMask);
    DeleteDC (hdcMask);
    end
  else
    begin
    DeleteObject(bmAndBack);
    end;
  DeleteObject(bmSave);     
  DeleteDC (hdcImage);
finally
  Image.Free;
  end;
end;

{----------------TDib.CreateDIB}
constructor TDib.CreateDIB(DC: HDC; Bitmap: TBitmap);
{given a TBitmap, construct a device independent bitmap}
var
  ImgSize: DWord;
begin
InitializeBitmapInfoHeader(Bitmap.Handle);
ImgSize := Info^.biSizeImage;
Allocate(ImgSize);
try
  GetDIBX(DC, Bitmap.Handle, Bitmap.Palette);
except
  DeAllocate;
  Raise;
  end;
end;

destructor TDib.Destroy;
begin
DeAllocate;
inherited Destroy;
end;

procedure TDib.Allocate(Size: integer);
begin
ImageSize := Size;
if Size < $FF00 then
  GetMem(Image, Size)
else
   begin
   FHandle := GlobalAlloc(HeapAllocFlags, Size);
   if FHandle = 0 then
       ABort;
   Image := GlobalLock(FHandle);
   end;
end;

procedure TDib.DeAllocate;
begin
if ImageSize > 0 then
  begin
  if ImageSize < $FF00 then
    Freemem(Image, ImageSize)
  else
    begin
    GlobalUnlock(FHandle);
    GlobalFree(FHandle);
    end;
  ImageSize := 0;
  end;
if InfoSize > 0 then
  begin
  FreeMem(Info, InfoSize);
  InfoSize := 0;
  end;
end;

procedure TDib.InitializeBitmapInfoHeader(Bitmap: HBITMAP);
var
  BM: Windows.TBitmap;
  BitCount: integer;

   function WidthBytes(I: integer): integer;
   begin
     Result := ((I + 31) div 32) * 4;
   end;

begin
GetObject(Bitmap, SizeOf(BM), @BM);
BitCount := BM.bmBitsPixel * BM.bmPlanes;
if BitCount > 8 then
  InfoSize := SizeOf(TBitmapInfoHeader)
else
  InfoSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) * (1 shl BitCount);  
GetMem(Info, InfoSize);

with Info^ do
  begin
  biSize := SizeOf(TBitmapInfoHeader);
  biWidth := BM.bmWidth;
  biHeight := BM.bmHeight;
  biBitCount := BM.bmBitsPixel * BM.bmPlanes;
  biPlanes := 1;
  biXPelsPerMeter := 0;
  biYPelsPerMeter := 0;
  biClrUsed := 0;
  biClrImportant := 0;
  biCompression := BI_RGB;
  if biBitCount in [16, 32] then
    biBitCount := 24;
  biSizeImage := WidthBytes(biWidth * biBitCount) * biHeight;
  end;
end;

procedure TDib.GetDIBX(DC: HDC; Bitmap: HBITMAP; Palette: HPALETTE);
var
  OldPal: HPALETTE;
  Rslt: integer;
  bmInfo: PBitmapInfo;
begin
  OldPal := 0;
  if Palette <> 0 then
    begin
    OldPal := SelectPalette(DC, Palette, False);
    RealizePalette(DC);
    end;
  bmInfo := PBitmapInfo(Info);
  Rslt := GetDIBits(DC, Bitmap, 0, Info^.biHeight, Image, bmInfo^, DIB_RGB_COLORS);
  if OldPal <> 0 then
    SelectPalette(DC, OldPal, False);
  if Rslt = 0 then
    begin
    OutofMemoryError;
    end;
end;

procedure TDib.DrawDIB(DC: HDC; X: Integer; Y: integer; W, H: integer;
          ROP: DWord);
var
  bmInfo: PBitmapInfo;
begin
bmInfo := PBitmapInfo(Info);
with Info^ do
  StretchDIBits(DC, X, Y, W, H, 0, 0, biWidth, biHeight, Image,
      bmInfo^, DIB_RGB_COLORS, ROP);
end;

function TDib.CreateDIBmp: hBitmap;
var
  bmInfo: PBitmapInfo;
  DC: HDC;
  OldPal: HPalette;
begin
bmInfo := PBitmapInfo(Info);
DC := GetDC(0);
OldPal := SelectPalette(DC, ThePalette, False);
RealizePalette(DC);
try
  Result := CreateDIBitmap(DC, bmInfo^.bmiHeader, CBM_INIT, Image,
            bmInfo^, DIB_RGB_COLORS);
finally
  SelectPalette(DC, OldPal, False);
  ReleaseDC(0, DC);
  end;
end;

{----------------IndentManagerBasic.Create}
constructor IndentManagerBasic.Create;
begin
inherited Create;
R := TFreeList.Create;
L := TFreeList.Create;
end;

destructor IndentManagerBasic.Destroy;
begin
R.Free;
L.Free;
inherited Destroy;
end;

procedure IndentManagerBasic.Clear;
begin
R.Clear;
L.Clear;
CurrentID := Nil;
end;

{----------------IndentManagerBasic.Reset}
procedure IndentManagerBasic.Reset(Lf, Rt: integer);
begin
LfEdge := Lf;
RtEdge := Rt;
CurrentID := Nil;
end;

procedure IndentManagerBasic.UpdateTable(Y: integer; IW: integer; IH: integer;
                           Justify: JustifyType);
{Given a floating table, update the edge information. }
var
  IR: IndentRec;
begin
  IR := IndentRec.Create;
  if (Justify = Left) then
    begin
    with IR do
      begin
      X := -LfEdge + IW;
      YT := Y;
      YB := Y + IH;
      L.Add(IR);
      end;
    end
  else if (Justify = Right) then
    begin
    with IR do
      begin
      X := RightSide(Y) - IW;
      YT := Y;
      YB := Y + IH;
      R.Add(IR);
      end;
    end;
end;

const
  BigY = 9999999;

function IndentManagerBasic.LeftIndent(Y: integer): integer;
var
  I: integer;
begin
Result := -99999;
for I := 0 to L.Count-1 do
  with IndentRec(L.Items[I]) do
    begin
    if (Y >= YT) and (Y < YB) and (Result < X) then
      if not Assigned(ID) or (ID = CurrentID) then
        Result := X;
    end;
if Result = -99999 then  
  Result := 0;
Inc(Result, LfEdge);
end;

function IndentManagerBasic.RightSide(Y: integer): integer;
{returns the current right side dimension as measured from the left, a positive
 number}
var
  I: integer;
  IR: IndentRec;
begin
Result := 99999;
for I := 0 to R.Count-1 do
  begin
  IR := IndentRec(R.Items[I]);
  with IR do
    if (Y >= YT) and (Y < YB) and (Result > X) then
      if not Assigned(ID) or (ID = CurrentID) then
        Result := X;
  end;
if Result = 99999 then
  Result := RtEdge     
else Inc(Result, LfEdge);
end;

function IndentManagerBasic.ImageBottom: integer;
{finds the bottom of the last floating image}
var
  I: integer;
begin
Result := 0;
for I := 0 to L.Count-1 do
  with IndentRec(L.Items[I]) do
    if not Assigned(ID) and (YB > Result) then  
      Result := YB;
for I := 0 to R.Count-1 do
  with IndentRec(R.Items[I]) do
    if not Assigned(ID) and (YB > Result) then
      Result := YB;
end;

procedure IndentManagerBasic.GetClearY(var CL, CR: integer);
{returns the left and right Y values which will clear image margins}
var
  I: integer;
begin
CL := -1;
for I := 0 to L.Count-1 do
  with IndentRec(L.Items[I]) do
    if not Assigned(ID)and (YB > CL) then
      CL := YB;
CR := -1;
for I := 0 to R.Count-1 do
  with IndentRec(R.Items[I]) do
    if not Assigned(ID)and (YB > CR) then
      CR := YB;
Inc(CL);
Inc(CR);
end;

function IndentManagerBasic.GetNextWiderY(Y: integer): integer;
{returns the next Y value which offers a wider space or Y if none}
var
  I, CL, CR: integer;
begin
CL := Y;
for I := 0 to L.Count-1 do
  with IndentRec(L.Items[I]) do
    if not Assigned(ID)and (YB > Y) and ((YB < CL) or (CL = Y)) then
      CL := YB;
CR := Y;
for I := 0 to R.Count-1 do
  with IndentRec(R.Items[I]) do
    if not Assigned(ID)and (YB > Y) and ((YB < CR) or (CR = Y)) then
      CR := YB;
if CL = Y then
  Result := CR
else if CR = Y then
  Result := CL
else Result := IntMin(CL, CR);
end;

function IndentManagerBasic.SetLeftIndent(XLeft, Y: integer): integer;
var
  IR: IndentRec;
begin
IR := IndentRec.Create;
with IR do
  begin
  YT := Y;
  YB := BigY;
  X := XLeft;
  ID := CurrentID;
  end;
Result := L.Add(IR);
end;

function IndentManagerBasic.SetRightIndent(XRight, Y: integer): integer;
var
  IR: IndentRec;
begin
IR := IndentRec.Create;
with IR do
  begin
  YT := Y;
  YB := BigY;  
  X := XRight;
  ID := CurrentID;
  end;
Result := R.Add(IR);
end;

procedure IndentManagerBasic.FreeLeftIndentRec(I: integer);  
begin
IndentRec(L.Items[I]).Free;
L.Delete(I);
end;

procedure IndentManagerBasic.FreeRightIndentRec(I: integer);
begin
IndentRec(R.Items[I]).Free;
R.Delete(I);
end;

procedure SetGlobalPalette(Value: HPalette);
begin
{$ifdef HtmlUseDll}
GlobalPalette := Value;
{$endif}
end;

function CopyPalette(Source: hPalette): hPalette;
var
  LP: ^TLogPalette;
  NumEntries: integer;
begin
Result := 0;
if ColorBits > 8 then    
  Exit;
GetMem(LP, Sizeof(TLogPalette) + 256*Sizeof(TPaletteEntry));
try
  with LP^ do
    begin
    palVersion := $300;
    palNumEntries := 256;
    NumEntries := GetPaletteEntries(Source, 0, 256, palPalEntry);
    if NumEntries > 0 then
      begin
      palNumEntries := NumEntries;
      Result := CreatePalette(LP^);
      end;
    end;
finally
  FreeMem(LP, Sizeof(TLogPalette) + 256*Sizeof(TPaletteEntry));
  end;
end;

procedure CalcPalette(DC: HDC);
{calculate a rainbow palette, one with equally spaced colors}
const
  Values: array[0..5] of integer = (55, 115, 165, 205, 235, 255);
var
  LP: ^TLogPalette;
  I, J, K, Sub: integer;
begin
GetMem(LP, Sizeof(TLogPalette) + 256*Sizeof(TPaletteEntry));
try
  with LP^ do
    begin
    palVersion := $300;
    palNumEntries := 256;
    GetSystemPaletteEntries(DC, 0, 256, palPalEntry);
    Sub := 10;  {start at entry 10}
    for I := 0 to 5 do
      for J := 0 to 5 do
        for K := 0 to 5 do
          if not ((I=5) and (J=5) and (K=5)) then  {skip the white}
            with palPalEntry[Sub] do
              begin
              peBlue := Values[I];
              peGreen := Values[J];
              peRed := Values[K];
              peFlags := 0;
              Inc(Sub);
              end;
    for I := 1 to 24 do
       if not (I in [7, 15, 21]) then   {these would be duplicates}  
          with palPalEntry[Sub] do
            begin
            peBlue := 130 + 5*I;
            peGreen := 130 + 5*I;
            peRed := 130 + 5*I;
            peFlags := 0;
            Inc(Sub);
            end;
    ThePalette := CreatePalette(LP^);
    {$ifdef HtmlUseDll}
    GlobalPalette := ThePalette;
    {$endif}
    end;
finally
  FreeMem(LP, Sizeof(TLogPalette) + 256*Sizeof(TPaletteEntry));
  end;
end;

const
  DefaultBitmap = 1002;
  ErrBitmap = 1001;
  ErrBitmapMask = 1005;
  Hand_Cursor = 1003;
  ThickIBeam_Cursor = 1006;

procedure ThisExit; far;
begin
if ThePalette <> 0 then
  DeleteObject(ThePalette);
DefBitMap.Free;
ErrorBitMap.Free;
ErrorBitMapMask.Free;
WaitStream.Free;
end;

{----------------TIDNameList}
constructor TIDNameList.Create(List: TList);
begin
inherited Create;
Sorted := True;
OwnerList := List;
end;

destructor TIDNameList.Destroy;
begin
Clear;
inherited
end;

procedure TIDNameList.Clear;
var
  I: integer;
begin
for I := 0 to Count-1 do
  if Objects[I] is TChPosObj then
    Objects[I].Free;
inherited Clear;
end;

function TIDNameList.AddObject(const S: string; AObject: TObject): Integer;
var
  I: integer;
begin
if Find(S, I) then
  begin
  try
    if Objects[I] is TChPosObj then
      Objects[I].Free;
  except
    end;
  Delete(I);
  end;
Result := inherited AddObject(S, AObject);
end;

procedure TIDNameList.AddChPosObject(const S: string; Pos: integer);
var
  ChPosObj: TChPosObj;
begin
ChPosObj := TChPosObj.Create;
ChPosObj.List := OwnerList;
ChPosObj.ChPos := Pos;
AddObject(S, ChPosObj);
end;

destructor TIDObject.Destroy;
begin
inherited;
end;

{----------------TChPosObj.GetYPosition:}
function TChPosObj.GetYPosition: integer;
var
  Pos, X, Y: integer;
begin
with List as TSectionList do
  begin
  Pos := FindDocPos(ChPos, False);
  if CursorToXY(Nil, Pos, X, Y) then
      Result := Y
  else Result := 0;
  end;
end;

{----------------TokenObj.Create}
constructor TokenObj.Create;    
begin
inherited;
GetMem(C, TokenLeng*Sizeof(char));
GetMem(I, TokenLeng*Sizeof(integer));
MaxIndex := TokenLeng;
Leng := 0;
St := '';
StringOK := True;
end;

destructor TokenObj.Destroy;
begin
FreeMem(I);
FreeMem(C);
inherited;
end;

procedure TokenObj.AddChar(Ch: char; Ind: integer);
begin
if Leng >= MaxIndex then
  Begin
  ReallocMem(C, (MaxIndex+50)*Sizeof(char));
  ReallocMem(I, (MaxIndex+50)*Sizeof(integer));
  Inc(MaxIndex, 50);
  end;
Inc(Leng);
C^[Leng] := Ch;
I^[Leng] := Ind;
StringOK := False;
end;

procedure TokenObj.Clear;
begin
Leng := 0;
St := '';
StringOK := True;
end;

procedure TokenObj.Concat(T: TokenObj);
var
  K: integer;
begin
K := Leng + T.Leng;
if K > MaxIndex then
  begin
  ReallocMem(C, (K+50)*Sizeof(char));
  ReallocMem(I, (K+50)*Sizeof(integer));
  MaxIndex := K+50;
  end;
Move(T.C^, C^[Leng+1], T.Leng*Sizeof(char));
Move(T.I^, I^[Leng+1], T.Leng*Sizeof(integer));
Leng := K;
StringOK := False;
end;

procedure TokenObj.Remove(N: integer);
begin    {remove a single character}
if N <= Leng then
  begin
  Move(C^[N+1], C^[N], (Leng-N)*Sizeof(char));
  Move(I^[N+1], I^[N], (Leng-N)*Sizeof(integer));
  if StringOK then
    Delete(St, N, 1);
  Dec(Leng);
  end;
end;

procedure TokenObj.Replace(N: integer; Ch: char);
begin    {replace a single character}
if N <= Leng then
  begin
  C^[N] := Ch;
  if StringOK then
    St[N] := Ch;
  end;
end;

function TokenObj.GetString: string;
begin
if not StringOK then
  begin
  SetLength(St, Leng);
  Move(C^, St[1], Leng);
  StringOK := True;
  end;
Result := St;
end;

{$ifdef ver100_plus}
{----------------BitmapToRegion}          
function BitmapToRegion(ABmp: TBitmap; XForm: PXForm; TransparentColor: TColor): HRGN;
{Find a Region corresponding to the non-transparent area of a bitmap.

 Thanks to Felipe Machado.  See http://www.delphi3000.com/
 Minor modifications made.}
const
  AllocUnit = 100;
type
  PRectArray = ^TRectArray;
  TRectArray = Array[0..(MaxInt div SizeOf(TRect))-1] of TRect;
var
  pr: PRectArray;    // used to access the rects array of RgnData by index
  h: HRGN;           // Handles to regions
  RgnData: PRgnData; // Pointer to structure RGNDATA used to create regions
  lr, lg, lb: Byte; // values for lowest and hightest trans. colors
  x,y, x0: Integer;  // coordinates of current rect of visible pixels
  b: PByteArray;     // used to easy the task of testing the byte pixels (R,G,B)
  ScanLinePtr: Pointer; // Pointer to current ScanLine being scanned
  ScanLineInc: Integer; // Offset to next bitmap scanline (can be negative)
  maxRects: Cardinal;   // Number of rects to realloc memory by chunks of AllocUnit
  bmp: TBitmap;
begin
  Result := 0;
  lr := GetRValue(TransparentColor);
  lg := GetGValue(TransparentColor);
  lb := GetBValue(TransparentColor);
  { ensures that the pixel format is 32-bits per pixel }
  bmp := TBitmap.Create;
  try
    bmp.Assign(ABmp);
    bmp.PixelFormat := pf32bit;
    { alloc initial region data }
    maxRects := AllocUnit;
    GetMem(RgnData,SizeOf(TRgnDataHeader) + (SizeOf(TRect) * maxRects));
    try
      with RgnData^.rdh do
      begin
        dwSize := SizeOf(TRgnDataHeader);
        iType := RDH_RECTANGLES;
        nCount := 0;
        nRgnSize := 0;
        SetRect(rcBound, MAXLONG, MAXLONG, 0, 0);
      end;
      { scan each bitmap row - the orientation doesn't matter (Bottom-up or not) }
      ScanLinePtr := bmp.ScanLine[0];
      ScanLineInc := Integer(bmp.ScanLine[1]) - Integer(ScanLinePtr);
      for y := 0 to bmp.Height - 1 do
      begin
        x := 0;
        while x < bmp.Width do
        begin
          x0 := x;
          while x < bmp.Width do
          begin
            b := @PByteArray(ScanLinePtr)[x*SizeOf(TRGBQuad)];
            // BGR-RGB: Windows 32bpp BMPs are made of BGRa quads (not RGBa)
            if (b[2] = lr) and
               (b[1] = lg) and
               (b[0] = lb) then
              Break; // pixel is transparent
            Inc(x);
          end;
          { test to see if we have a non-transparent area in the image }
          if x > x0 then
          begin
            { increase RgnData by AllocUnit rects if we exceeds maxRects }
            if RgnData^.rdh.nCount >= maxRects then
            begin
              Inc(maxRects,AllocUnit);
              ReallocMem(RgnData,SizeOf(TRgnDataHeader) + (SizeOf(TRect) * MaxRects));
            end;
            { Add the rect (x0, y)-(x, y+1) as a new visible area in the region }
            pr := @RgnData^.Buffer; // Buffer is an array of rects
            with RgnData^.rdh do
            begin
              SetRect(pr[nCount], x0, y, x, y+1);
              { adjust the bound rectangle of the region if we are "out-of-bounds" }
              if x0 < rcBound.Left then rcBound.Left := x0;
              if y < rcBound.Top then rcBound.Top := y;
              if x > rcBound.Right then rcBound.Right := x;
              if y+1 > rcBound.Bottom then rcBound.Bottom := y+1;
              Inc(nCount);
            end;
          end; // if x > x0
          { Need to create the region by muliple calls to ExtCreateRegion, 'cause }
          { it will fail on Windows 98 if the number of rectangles is too large   }
          if RgnData^.rdh.nCount = 2000 then
          begin
            h := ExtCreateRegion(XForm, SizeOf(TRgnDataHeader) + (SizeOf(TRect) * maxRects), RgnData^);
            if Result > 0 then
            begin // Expand the current region
              CombineRgn(Result, Result, h, RGN_OR);
              DeleteObject(h);
            end
            else  // First region, assign it to Result
              Result := h;
            RgnData^.rdh.nCount := 0;
            SetRect(RgnData^.rdh.rcBound, MAXLONG, MAXLONG, 0, 0);
          end;
          Inc(x);
        end; // scan every sample byte of the image
        Inc(Integer(ScanLinePtr), ScanLineInc);
      end;
      { need to call ExCreateRegion one more time because we could have left    }
      { a RgnData with less than 2000 rects, so it wasn't yet created/combined  }
      if RgnData^.rdh.nCount > 0 then  {LDB  0 Count causes exception and abort in Win98}
        h := ExtCreateRegion(XForm, SizeOf(TRgnDataHeader) + (SizeOf(TRect) * MaxRects), RgnData^)
      else h := 0;
      if Result > 0 then
      begin
        CombineRgn(Result, Result, h, RGN_OR);
        DeleteObject(h);
      end
      else
        Result := h;
    finally
      FreeMem(RgnData,SizeOf(TRgnDataHeader) + (SizeOf(TRect) * MaxRects));
    end;
  finally
    bmp.Free;
    end;
end;
{$endif}

{----------------PrintBitmap}
procedure PrintBitmap(Canvas: TCanvas; X, Y, W, H: integer;
             BMHandle: HBitmap);
{Y relative to top of display here}
var
  OldPal: HPalette;
  DC: HDC;
  Info: PBitmapInfo;
  Image: AllocRec;
  ImageSize: DWord;
  InfoSize: DWord;
begin
if BMHandle = 0 then
  Exit;
DC := Canvas.Handle;
try
  GetDIBSizes(BMHandle, InfoSize, ImageSize);
  GetMem(Info, InfoSize);
  try
    Image := Allocate(ImageSize);
    OldPal := SelectPalette(DC, ThePalette, False);
    try
      GetDIB(BMHandle, ThePalette, Info^, Image.Ptr^);
      RealizePalette(DC);
      with Info^.bmiHeader do
        StretchDIBits(DC, X, Y, W, H,
           0, 0, biWidth, biHeight, Image.Ptr, Info^, DIB_RGB_COLORS, SRCCOPY);
    finally
      DeAllocate(Image);
      SelectPalette(DC, OldPal, False);
     end;
  finally
   FreeMem(Info, InfoSize);
   end;
except
  end;
end;

{----------------PrintTransparentBitmap1}
procedure PrintTransparentBitmap1(Canvas: TCanvas; X, Y, NewW, NewH: integer;
             Bitmap, Mask: TBitmap; YI, HI: integer);
{Y relative to top of display here}
{This routine prints transparently but only on a white background}
{X, Y are point where upper left corner will be printed.
 NewW, NewH are the Width and Height of the output (possibly stretched)
 Vertically only a portion of the Bitmap, Mask may be printed starting at
   Y=YI in the bitmap and a height of HI
}
var
  OldPal: HPalette;
  DC: HDC;
  Info: PBitmapInfo;
  Image: AllocRec;
  ImageSize: DWord;
  InfoSize: DWord;
  Abitmap: TBitmap;

begin
ABitmap := TBitmap.Create;
try
  Abitmap.Assign(Bitmap);
  ABitmap.Height := HI;
  BitBlt(ABitmap.Canvas.Handle, 0, 0, Bitmap.Width, HI, Bitmap.Canvas.Handle, 0, YI, SrcCopy);
  BitBlt(ABitmap.Canvas.Handle, 0, 0, Bitmap.Width, HI, Mask.Canvas.Handle, 0, YI, SRCPAINT);
  DC := Canvas.Handle;
  GetDIBSizes(ABitmap.Handle, InfoSize, ImageSize);
  GetMem(Info, InfoSize);
  try
    Image := Allocate(ImageSize);
    OldPal := SelectPalette(DC, ThePalette, False);
    try
      GetDIB(ABitmap.Handle, ThePalette, Info^, Image.Ptr^);
      RealizePalette(DC);
      with Info^.bmiHeader do
        StretchDIBits(DC, X, Y, NewW, NewH,
           0, 0, biWidth, biHeight, Image.Ptr, Info^, DIB_RGB_COLORS, SRCCOPY);
    finally
      DeAllocate(Image);
      SelectPalette(DC, OldPal, False);
     end;
  finally
   FreeMem(Info, InfoSize);
   end;
finally
  ABitmap.Free;
  end;
end;

{$ifdef ver100_plus}   {Delphi 3 and up only}
{----------------PrintTransparentBitmap3}
procedure PrintTransparentBitmap3(Canvas: TCanvas; X, Y, NewW, NewH: integer;
             Bitmap, Mask: TBitmap; YI, HI: integer);
{Y relative to top of display here}
{This routine prints transparently on complex background by printing through a clip region}
{X, Y are point where upper left corner will be printed.
 NewW, NewH are the Width and Height of the output (possibly stretched)
 Vertically only a portion of the Bitmap, Mask may be printed starting at
   Y=YI in the bitmap and a height of HI
}
var
  OldPal: HPalette;
  DC: HDC;
  Info: PBitmapInfo;
  Image: AllocRec;
  ImageSize: DWord;
  InfoSize: DWord;
  hRgn, OldRgn: THandle;
  Rslt: integer;
  XForm: TXForm;
  SizeV, SizeW: TSize;
  HF, VF: double;
  ABitmap, AMask: TBitmap;
  BitmapCopy: boolean;

begin
{the following converts the black masked area in the image to white.  This may look
 better in WPTools which currently doesn't handle the masking}
if (Bitmap.Handle = 0) or (HI <= 0) or (Bitmap.Width <= 0) then
  Exit;
BitmapCopy := Bitmap.Height <> HI;
try
  if BitmapCopy then
    begin
    ABitmap := TBitmap.Create;
    AMask := TBitmap.Create;
    end
  else
    begin
    ABitmap := Bitmap;
    AMask := Mask;
    end;
  try
    if BitmapCopy then
      begin
      Abitmap.Assign(Bitmap);
      ABitmap.Height := HI;
      BitBlt(ABitmap.Canvas.Handle, 0, 0, Bitmap.Width, HI, Bitmap.Canvas.Handle, 0, YI, SrcCopy);
      AMask.Assign(Mask);
      AMask.Height := HI;
      BitBlt(AMask.Canvas.Handle, 0, 0, AMask.Width, HI, Mask.Canvas.Handle, 0, YI, SrcCopy);
      end;

    BitBlt(ABitmap.Canvas.Handle, 0, 0, Bitmap.Width, HI, AMask.Canvas.Handle, 0, 0, SRCPAINT);

    DC := Canvas.Handle;
    {calculate a transform for the clip region as it may be a different size than
     the mask and needs to be positioned on the canvas.}
    GetViewportExtEx(DC, SizeV);
    GetWindowExtEx(DC, SizeW);
    HF := (SizeV.cx/SizeW.cx);  {Horizontal adjustment factor}
    VF := (SizeV.cy/SizeW.cy);  {Vertical adjustment factor}

    XForm.eM11 := HF * (NewW/Bitmap.Width);
    XForm.eM12 := 0;
    XForm.eM21 := 0;
    XForm.eM22 := VF * (NewH/HI);
    XForm.edx := HF*X;
    XForm.edy := VF*Y;          

    {Find the region for the white area of the Mask}
    hRgn := BitmapToRegion(AMask, @XForm, $FFFFFF);
    if hRgn <> 0 then  {else nothing to output--this would be unusual}
      begin
      OldRgn := CreateRectRgn(0,0,1,1);  {a valid region is needed for the next call}
      Rslt := GetClipRgn(DC, OldRgn);    {save the Old clip region}
      try
        if Rslt = 1 then
          CombineRgn(hRgn, hRgn, OldRgn, RGN_AND);
        SelectClipRgn(DC, hRgn);
        GetDIBSizes(ABitmap.Handle, InfoSize, ImageSize);   
        GetMem(Info, InfoSize);
        try
          Image := Allocate(ImageSize);
          OldPal := SelectPalette(DC, ThePalette, True);
          try
            GetDIB(ABitmap.Handle, ThePalette, Info^, Image.Ptr^);  
            RealizePalette(DC);
            with Info^.bmiHeader do
              StretchDIBits(DC, X, Y, NewW, NewH,
                 0, 0, biWidth, biHeight, Image.Ptr, Info^, DIB_RGB_COLORS, SRCCOPY);
          finally
            DeAllocate(Image);
            SelectPalette(DC, OldPal, False);
           end;
        finally
         FreeMem(Info, InfoSize);
         end;
      finally
        if Rslt = 1 then
          SelectClipRgn(DC, OldRgn)
        else SelectClipRgn(DC, 0);
        DeleteObject(hRgn);
        DeleteObject(OldRgn);
        end;
      end;
  finally
    if BitmapCopy then
      begin
      ABitmap.Free;
      AMask.Free;
      end;
    end;
except
  end;
end;
{$endif}

initialization
DC := GetDC(0);
try
{$ifndef HtmlUseDll}
  ColorBits := GetDeviceCaps(DC, BitsPixel)*GetDeviceCaps(DC, Planes);

  if ColorBits <= 4 then
    ColorBits := 4
  else if ColorBits <= 8 then
    ColorBits := 8
  else  ColorBits := 24;
{$else}
  ColorBits := GetDeviceRes(DC);
{$endif}

{$ifdef HtmlUseDll}
  Dither := 1;
{$endif}

  ThePalette := 0;
  if ColorBits = 8 then
    CalcPalette(DC);
finally
  ReleaseDC(0, DC);
  end;

{$ifdef HtmlUseDll}
ShowErrorInDLL := 0;     {set to 1 to show image error messages}
{$endif}

DefBitMap := TBitmap.Create;
DefBitMap.Handle := LoadBitmap(HInstance, MakeIntResource(DefaultBitmap));
ErrorBitMap := TBitmap.Create;
ErrorBitMap.Handle := LoadBitmap(HInstance, MakeIntResource(ErrBitmap));
ErrorBitMapMask := TBitmap.Create;
ErrorBitMapMask.Handle := LoadBitmap(HInstance, MakeIntResource(ErrBitmapMask));
Screen.Cursors[HandCursor] := LoadCursor(HInstance, MakeIntResource(Hand_Cursor));
Screen.Cursors[ThickIBeamCursor] := LoadCursor(HInstance, MakeIntResource(ThickIBeam_Cursor));
Screen.Cursors[UpDownCursor] := LoadCursor(HInstance, 'UPDOWNCURSOR');
Screen.Cursors[UpOnlyCursor] := LoadCursor(HInstance, 'UPONLYCURSOR');
Screen.Cursors[DownOnlyCursor] := LoadCursor(HInstance, 'DOWNONLYCURSOR');

WaitStream := TMemoryStream.Create;

Finalization
ThisExit;
end.



