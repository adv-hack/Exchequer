
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Unicode-related procedures.                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVUni;

interface
{$I RV_Defs.inc}

uses
  {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
  SysUtils, Windows, Classes, Graphics,
     RVItem, RVStyle, RVScroll, RVTypes, RVGrIn;

{$IFDEF RVNORANGECHECK}
{$R-}
{$ENDIF}

type TRVIntegerArray = array[0..100000] of Integer;
     PRVIntegerArray = ^TRVIntegerArray;
type TRVUnsignedArray = array[0..100000] of Cardinal;
     PRVUnsignedArray = ^TRVUnsignedArray;
type TRVWordArray = array[0..100000] of Word;
     PRVWordArray = ^TRVWordArray;

{$IFNDEF RVDONOTUSEUNICODE}
function RVU_FindLineBreak(Str: PRVWordArray; Length: Integer; FullString,
  IgnoreEndingSpaces: Boolean): Pointer;
function RVU_FindFirstLineBreak(Str: TRVRawByteString; PrevChar: Word;
  SpacesBefore: Boolean; var LastChar: Word): Integer;

procedure RVU_GetTextExtentPoint32W(Canvas: TCanvas; str: Pointer; Len: Integer;
  var sz: TSize; GraphicInterface: TRVGraphicInterface);
{$ENDIF}
function RVU_Copy(const s: TRVRawByteString; Index, Count: Integer;
  ItemOptions: TRVItemOptions): TRVRawByteString;
procedure RVU_Delete(var s: TRVRawByteString; Index, Count: Integer;
  ItemOptions: TRVItemOptions);
procedure RVU_Insert(const Source: TRVRawByteString; var s: TRVRawByteString; Index: Integer;
  ItemOptions: TRVItemOptions);
procedure RVU_GetTextExtentExPoint(Canvas: TCanvas; const s: TRVRawByteString;
  MaxExtent: Integer; var Fit: Integer; PDx: PRVIntegerArray;
  ItemOptions: TRVItemOptions; GraphicInterface: TRVGraphicInterface);
procedure RVU_GetTextExtentExPointPC(Canvas: TCanvas; pc: PRVAnsiChar; Length: Integer;
  MaxExtent: Integer; var Fit: Integer; PDx: PRVIntegerArray;
  ItemOptions: TRVItemOptions; var sz: TSize; GraphicInterface: TRVGraphicInterface);
function RVU_GetTextCaretPos(Canvas: TCanvas; const s: TRVRawByteString;
  PCP: PRVIntegerArray; ItemOptions: TRVItemOptions;
  Width, Delta: Integer; GraphicInterface: TRVGraphicInterface): Boolean;
function RVU_GetTextGlyphDX(Canvas: TCanvas; const s: TRVRawByteString;
  PDx: PRVIntegerArray; PGlyphs: PRVWordArray;
  ItemOptions: TRVItemOptions; Width: Integer; var nGlyphs: Integer;
  GraphicInterface: TRVGraphicInterface): Boolean;
function RVU_GetTextRangeCoords(Canvas: TCanvas; const s: TRVRawByteString;
  RangeStartOffs, RangeLength: Integer; ItemOptions: TRVItemOptions;
  Width, Delta: Integer; var X1,X2: Integer;
  GraphicInterface: TRVGraphicInterface): Boolean;
function RVU_Length(const s: TRVRawByteString; ItemOptions: TRVItemOptions): Integer;
function RVU_TextWidth(const s: TRVRawByteString; Canvas: TCanvas;
  ItemOptions: TRVItemOptions; GraphicInterface: TRVGraphicInterface): Integer;
function RVU_IsSpace(const s: TRVRawByteString; Index: Integer;
  ItemOptions: TRVItemOptions): Boolean;
function RVU_OffsInPChar(Offs: Integer; ItemOptions: TRVItemOptions): Integer;
{$IFDEF RICHVIEWCBDEF3}
function RVU_Charset2CodePage(Charset: TFontCharset): TRVCodePage;
function RVU_CodePage2Charset(CodePage: TRVCodePage): TFontCharset;
function RVU_Charset2Language(Charset: TFontCharset): Cardinal;
function RVU_GetRawUnicode(const s: TRVUnicodeString):TRVRawByteString;
function RVU_RawUnicodeToWideString(const s: TRVRawByteString):TRVUnicodeString;
{$ELSE}
function RVU_GetRawUnicode(const s: TRVRawByteString):TRVRawByteString;
{$ENDIF}
procedure RVU_SwapWordBytes(arr: PWord; Count: Integer);
procedure RVU_ProcessByteOrderMark(var arr: PWord; Count: Integer);

function RVU_AnsiToUnicode(CodePage: TRVCodePage; const s: TRVAnsiString): TRVRawByteString;
function RVU_AnsiToUTF8(CodePage: TRVCodePage; const s: TRVAnsiString): TRVRawByteString;
function RVU_UnicodeToAnsi(CodePage: TRVCodePage; const s: TRVRawByteString): TRVAnsiString;
function RVU_CanBeConvertedToAnsi(CodePage: TRVCodePage; const s: TRVRawByteString): Boolean;
function RVU_StrScanW(Str: Pointer; Ch: Word; Length: Integer): Pointer;
function RVU_StrLenW(Str: Pointer): Cardinal;

type TRVUnicodeTestResult = (rvutNo, rvutYes, rvutProbably, rvutEmpty, rvutError);

function RV_TestStreamUnicode(Stream: TStream): TRVUnicodeTestResult;
function RV_TestFileUnicode(const FileName: String): TRVUnicodeTestResult;
function RV_TestStringUnicode(const s: TRVRawByteString): TRVUnicodeTestResult;

function RVU_GetKeyboardCodePage: TRVCodePage;
function RVU_GetKeyboardLanguage: Cardinal;
function RVU_KeyToUnicode(const Key: TRVAnsiString): TRVRawByteString;

{$IFNDEF RVDONOTUSEHTML}
procedure RVU_WriteHTMLEncodedUnicode(Stream: TStream; const s: TRVRawByteString;
  NoEmptyLines, SpecialCode, NextSpace: Boolean);
function RVU_GetHTMLEncodedUnicode(const s: TRVRawByteString;
  SpecialCode, NextSpace:Boolean): TRVAnsiString;
function RVU_GetHTMLUTF8EncodedUnicode(const s: TRVRawByteString;
  SpecialCode, NextSpace:Boolean): TRVRawByteString;
{$ENDIF}

function RV_ReturnProcessedString(const s: TRVRawByteString; TextStyle: TFontInfo;
  LastOnLine, ShowSpecialChars, ForDisplay: Boolean): TRVRawByteString;
function RV_ReturnProcessedStringEx(const s: TRVRawByteString; TextStyle: TFontInfo;
  LastOnLine, ShowSpecialChars, ForDisplay: Boolean;
  var SelOffs1, SelOffs2: Integer): TRVRawByteString;  

function RVU_DrawSelectedTextEx(Left, Top, Width: Integer; const s: TRVRawByteString;
  Canvas, RefCanvas: TCanvas; Index1,Index2: Integer; ItemOptions: TRVItemOptions;
  BiDiMode: TRVBiDiMode; UseRefCanvasRes: Boolean;
  GraphicInterface: TRVGraphicInterface): Boolean;
{$IFNDEF RICHVIEWDEF6}
{$IFDEF RICHVIEWCBDEF3}
function Utf8Decode(const S: TRVRawByteString): TRVUnicodeString;
function Utf8Encode(const WS: TRVUnicodeString): TRVRawByteString;
{$ENDIF}
{$ENDIF}

function StrPosW(Str, SubStr: Pointer): Pointer;
function StrPosLW(Str, SubStr: Pointer; StrLen, SubStrLen: Integer): Pointer;

function RVU_RawByteStringToString(const s: TRVRawByteString; RawUnicode: Boolean;
  CodePage: TRVCodePage): String;
function RVU_StringToRawByteString(const s: String; RawUnicode: Boolean;
  CodePage: TRVCodePage): TRVRawByteString;


const
  UNI_LF                 = Word($000A);
  UNI_CR                 = Word($000D);
  UNI_LineSeparator      = Word($2028);
  UNI_ParagraphSeparator = Word($2029);
  UNI_Tab                = Word($0009);  
  UNI_VerticalTab        = Word($000B);
  UNI_FormFeed           = Word($000C);
  UNI_LSB_FIRST          = Word($FEFF);
  UNI_MSB_FIRST          = Word($FFFE);
  UNI_FF                 = Word($000C);
  UNI_HYPHEN             = Word($002D);
  UNI_Space              = Word(ord(' '));
  UNI_ZERO_WIDTH_SPACE   = Word($200B);
  UNI_ZERO_WIDTH_JOINER  = Word($200D);
  UNI_WORD_JOINER        = Word($2060); // zero width non breaking space
  UNI_SOFT_HYPHEN        = Word($00AD);
  UNI_NOT_SIGN           = Word($00AC);
  UNI_NON_BREAKING_HYPHEN = Word($2011);

  UNI_LSB_FIRST1         = #$FF;
  UNI_LSB_FIRST2         = #$FE;


function RVMAKELCID(plgid: Word): Cardinal;

var RVNT, RVVista: Boolean;
  //RVDI_GETDRAGIMAGE: Cardinal;

implementation
uses CRVData, RVStr;

function MAKELCID(lgid, srtid: Word): Cardinal;
begin
  Result := (Cardinal(srtid) shl 16) or Cardinal(lgid);
end;

function MAKELANGID(p, s: Word): Word;
begin
  Result := (s shl 10) or p;
end;

function RVMAKELCID(plgid: Word): Cardinal;
begin
  Result := MAKELCID(MAKELANGID(plgid, SUBLANG_DEFAULT), SORT_DEFAULT);
end;

{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
type
  TRVLineBreakClass =
  (
  rvu_lb_OP, // Opening Punctuation
  rvu_lb_CL, // Closing Punctuation
  rvu_lb_QU, // Ambiguous Quotation
  rvu_lb_GL, // Non-breaking ("Glue")
  rvu_lb_NS, // Non Starter
  rvu_lb_EX, // Exclamation/Interrogation
  rvu_lb_SY, // Symbols Allowing Breaks
  rvu_lb_IS, // Infix Separator (Numeric)
  rvu_lb_PR, // Prefix (Numeric)
  rvu_lb_PO, // Postfix (Numeric)
  rvu_lb_NU, // Numeric
  rvu_lb_AL, // Ordinary Alphabetic and Symbol Characters
  rvu_lb_ID, // Ideographic
  rvu_lb_IN, // Inseparable
  rvu_lb_HY, // Hyphen
  rvu_lb_BA, // Break Opportunity After
  rvu_lb_BB, // Break Opportunity Before
  rvu_lb_B2, // Break Opportunity Before and After
  rvu_lb_ZW, // Zero Width Space
  rvu_lb_CM // Attached Characters and Combining Marks
  );

  {
  rvu_lb_BK, // Mandatory Break // may not occur
  rvu_lb_CR, // Carriage Return // may not occur
  rvu_lb_LF, // Line Feed       // may not occur

  rvu_lb_SP, // Space           // special processing
  rvu_lb_SG, // Surrogates                            // treated as AL
  rvu_lb_CB, // Contingent Break Opportunity          // treated as AL
  rvu_lb_XX, // Unknown                               // treated as AL
  rvu_lb_SA, // Complex Context (South East Asian)    // treated as AL
  rvu_lb_AI, // Ambiguous (Alphabetic or Ideographic) // treated as AL
  }

  TRVLineBreakAction =
  (
     bk_DBK,  // direct break
     bk_IBK,  // indirect break
     bk_PBK   // prohibited break
  );
const
  BreakPairs : array [TRVLineBreakClass,TRVLineBreakClass] of TRVLineBreakAction =
  (
  (bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_IBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_PBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_IBK),
  (bk_IBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_IBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_IBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_IBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_IBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_IBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_PBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK),
  (bk_DBK,bk_PBK,bk_IBK,bk_IBK,bk_IBK,bk_PBK,bk_PBK,bk_PBK,bk_DBK,bk_DBK,bk_IBK,bk_IBK,bk_DBK,bk_IBK,bk_IBK,bk_IBK,bk_DBK,bk_DBK,bk_PBK,bk_IBK)
  );
{------------------------------------------------------------------------------}
function GetCharLineBreakClass(Char: Word): TRVLineBreakClass; forward;
{------------------------------------------------------------------------------}
// (We assume that Str[Length] character exists)
// Returns the last character to leave on the line.
function RVU_FindLineBreak(Str: PRVWordArray; Length: Integer;
  FullString, IgnoreEndingSpaces: Boolean): Pointer;
var i,j: Integer;
    cls, cls2: TRVLineBreakClass;
    act: TRVLineBreakAction;
begin
  Result := nil;
  if not IgnoreEndingSpaces and (Str[Length]=UNI_Space) then begin
    { Result := @(Str[Length]);
      exit; // commented Jun 24 2004
    }
    if FullString then begin
      dec(Length);
      if Length=0 then
        exit;
    end;
  end;
  if IgnoreEndingSpaces then
    for i := Length downto 0 do
      if Str[i]<>UNI_Space then begin
          Length := i;
          break;
      end;
  cls := GetCharLineBreakClass(Str[Length]);
  for i := Length-1 downto 0 do begin
    if Str[i]=UNI_Space then
      continue;
    cls2 := GetCharLineBreakClass(Str[i]);
    act := BreakPairs[cls2, cls];
    if (act = bk_IBK) then
      if Str[i+1]<>UNI_Space then
        act := bk_PBK;
    if act in [bk_IBK, bk_DBK] then begin
      j := i;
      while (j+1<Length) and (Str[j+1]=UNI_Space) do
        inc(j);
      Result := @(Str[j]);
      exit;
    end;
    cls := cls2;
  end;
end;
{------------------------------------------------------------------------------}
// Returns the count of (Unicode) characters from the beginning of the string
// to the first allowed line break

// Input parameters:
// Str - Unicode string
// PrevChar - last non-space character in the string before Str; 0 if does not exist
// SpacesBefore - True if there is 1 or more spaces between PrevChar and Str (if PrevChar<>0)

// Result - count of Unicode characters in Str before line break. Special case:
// -1 means that break should be added after PrevChar.

// Output parameters:
// LastChar receives the last nonspace character, if line break is undecided.
// (i.e. if it can be after this character, but we need to examinate characters
// after Str to make sure). In this case, Result is a position of line break
// after this character. In case of decided line break, LastChar=0.

// A special case - Str is all spaces. In this case, we return LastChar=' ',
// Result := 0.

function RVU_FindFirstLineBreak(Str: TRVRawByteString; PrevChar: Word;
  SpacesBefore: Boolean; var LastChar: Word): Integer;
var i, FirstIndex: Integer;
    cls, cls2: TRVLineBreakClass;
    act: TRVLineBreakAction;
    PStr: PRVWordArray;
    Len: Integer;
    TestingBreakInPrevString: Boolean;
begin
  Result := 0;
  if Length(Str)=0 then
    exit;
  PStr := PRVWordArray(Str);
  if PrevChar<>0 then begin
    cls := GetCharLineBreakClass(PrevChar);
    TestingBreakInPrevString := SpacesBefore;
    FirstIndex := 0;
    end
  else begin
    cls := GetCharLineBreakClass(PStr[0]);
    FirstIndex := 1;
    SpacesBefore := False;
    TestingBreakInPrevString := False;
  end;
  Len := Length(Str) div 2;
  LastChar := 0;
  for i := FirstIndex to Len-1 do begin
    if PStr[i]=UNI_Space then begin
      SpacesBefore := True;
      continue;
    end;
    cls2 := GetCharLineBreakClass(PStr[i]);
    act := BreakPairs[cls, cls2];
    if (act = bk_IBK) then
      if not SpacesBefore then
        act := bk_PBK;
    if act in [bk_IBK, bk_DBK] then begin
      if TestingBreakInPrevString then
        Result := -1
      else begin
        Result := i;
        while (Result>0) and (PStr[Result-1]=UNI_Space) do
          dec(Result);
      end;
      exit;
    end;
    cls := cls2;
    SpacesBefore := False;
    TestingBreakInPrevString := False;
  end;
  LastChar := UNI_Space;
  Result := 0;
  for i := Len-1 downto 0 do
    if PStr[i]<>UNI_Space then begin
      LastChar := PStr[i];
      Result := i+1;
      exit;
    end;
end;

{$ENDIF}

{------------------------------------------------------------------------------}
function RVU_DrawSelectedTextEx_(Left, Top, Width: Integer;
  const s: TRVRawByteString;
  Canvas, RefCanvas: TCanvas; Index1,Index2: Integer;
  ItemOptions: TRVItemOptions; UseRefCanvasRes: Boolean;
  GraphicInterface: TRVGraphicInterface): Boolean;
var res: TGCPResultsA;
    i,j{,Delta}: Integer;
    wesz: TSize;
    wopt: TPoint;
    POrder,POrderRev: PRVUnsignedArray;
    PDX, PDX2: PRVIntegerArray;
    PGlyphs: PRVWordArray;
    Selected: PRVAnsiChar;
    PClass: PRVAnsiChar;
    OldSelectedCount, SelectedCount: Integer;
    DX, idx, idx1, idx2, Start: Integer;
    Len, StrLen: Integer;
    r: TRect;
    sz, sz2: TSmallPoint;
    UseSz2: Boolean;
    ETOOption: Integer;
    Str: Pointer;
    {..........................................}
    procedure InitStructure;
    begin
      FillChar(res, sizeof(res), 0);
      FillChar(POrder^, Len*sizeof(Cardinal), 0);
      FillChar(POrderRev^, Len*sizeof(Cardinal), -1);
      FillChar(PClass^, Length(s),            0);
      FillChar(PDX^, Len*sizeof(Integer)*2, 0);
      res.lStructSize := sizeof(res);
      res.lpOrder := @(POrder[0]);
      res.lpDx    := @(PDX[0]);
      res.lpClass := PClass;
      if PGlyphs<>nil then begin
        res.lpGlyphs := @(PGlyphs[0]);
        FillChar(PGlyphs^, Len*sizeof(Word)*2, 0);
        Str := res.lpGlyphs;
        ETOOption := ETO_GLYPH_INDEX;
        PDX2 := PDX;
        end
      else begin
        Str := PRVAnsiChar(s);
        ETOOption := 0;
        PDX2 := nil;
      end;
      res.nGlyphs := Len;
    end;
    {..........................................}
begin
  if rvioUnicode in ItemOptions then
    Len := Length(s) div 2
  else
    Len := Length(s);
  POrder := nil;
  POrderRev := nil;
  PDX       := nil;
  Selected  := nil;
  PGlyphs   := nil;
  StrLen := Len;
  //Delta := 2;
  if UseRefCanvasRes then begin
    GraphicInterface.GetWindowOrgEx(Canvas, wopt);
    GraphicInterface.GetWindowExtEx(Canvas, wesz);
    GraphicInterface.SetWindowExtEx(Canvas,
      wesz.cx * RVFORMATCANVASFACTOR, wesz.cy * RVFORMATCANVASFACTOR, @wesz);
    GraphicInterface.SetWindowOrgEx(Canvas, wopt.x * RVFORMATCANVASFACTOR, wopt.y * RVFORMATCANVASFACTOR, @wopt);
    Top := RVConvertToFormatCanvas(Top, True);
    Left := RVConvertToFormatCanvas(Left, True);
    //Width := RVConvertToFormatCanvas(Width, True);
    //Delta := RVConvertToFormatCanvas(Delta, True);
  end;
  try
    GetMem(POrder,    Len*sizeof(Cardinal));
    GetMem(POrderRev, Len*sizeof(Cardinal));
    GetMem(PDX,       Len*sizeof(Integer)*2);
    if Canvas<>RefCanvas then
      GetMem(PGlyphs, Len*sizeof(Word)*2);
    SelectedCount := Index2-Index1+1;
    GetMem(Selected, SelectedCount);
    GetMem(PClass,    Length(s)); // for any case
    FillChar(Selected^, SelectedCount, 1);
    InitStructure;
    UseSz2 := (rvioUnicode in ItemOptions) or
      GraphicInterface.FontHasLigationGlyphs(RefCanvas);
    if UseSz2 then begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if rvioUnicode in ItemOptions then
        sz2 := TSmallPoint(GraphicInterface.GetCharacterPlacement_W(RefCanvas,
          Pointer(s), Len, res, True))
      else
      {$ENDIF}
        sz2 := TSmallPoint(GraphicInterface.GetCharacterPlacement_A(RefCanvas,
          PRVAnsiChar(s), Len, res, True));
      end
    else begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if rvioUnicode in ItemOptions then
        sz := TSmallPoint(GraphicInterface.GetCharacterPlacement_W(RefCanvas,
          Pointer(s), Len, res, False))
      else
      {$ENDIF}
        sz := TSmallPoint(GraphicInterface.GetCharacterPlacement_A(RefCanvas,
          PRVAnsiChar(s), Len, res, False));
    end;
    if UseSz2 then
      sz := sz2;
    Result := {((Width<0) or (Abs(sz.x-Width)<Delta)) and} (sz.y>0);
    r.Top := Top;    
    r.Bottom := Top+sz.y;
    if Result then begin
      if PGlyphs<>nil then
        StrLen := res.nGlyphs;
      for i := 0 to Len-1 do
        POrderRev[POrder[i]] := i;
      {$IFNDEF RVDONOTUSESOFTHYPHENS}
      if (PGlyphs=nil) and (rvioUnicode in ItemOptions) then
        for i := 0 to Len-1 do
          if ((PRVWordArray(s)[i]=UNI_ZERO_WIDTH_SPACE) or
              {(PRVWordArray(s)[i]=UNI_ZERO_WIDTH_JOINER) or}
              (PRVWordArray(s)[i]=UNI_WORD_JOINER)) then
            PDX[i] := 0;
      {$ENDIF}
      while SelectedCount>0 do begin
        OldSelectedCount := SelectedCount;
        Start := 0;
        for i := 0 to Len-1 do begin
          idx := Integer(POrderRev[i]);
          if  (idx+1>=Index1) and (idx+1<=Index2) and
              (Selected[idx+1-Index1]<>#0) then begin
            idx1 := idx+1-1;
            idx2 := idx+1+1;
            while (idx2<=Index2) and (POrder[idx2-1]>POrder[idx+1-1]) and
                  (Integer(POrder[idx2-1]-POrder[idx+1-1])=idx2-(idx+1)) do
              inc(idx2);
            dec(idx2);
            while (idx1>=Index1) and (POrder[idx+1-1]>POrder[idx1-1]) and
                  (Integer(POrder[idx+1-1]-POrder[idx1-1])=(idx+1)-idx1) do
              dec(idx1);
            inc(idx1);
            r.Left := Left+Start;
            r.Right := r.Left;
            for j := idx1 to idx2 do begin
              //Assert(Selected[j-Index1]<>#0);
              Selected[j-Index1] := #0;
              dec(SelectedCount);
              inc(r.Right, PDX[POrder[j-1]]);
            end;
            {$IFNDEF RVDONOTUSEUNICODE}
            if rvioUnicode in ItemOptions then
              GraphicInterface.ExtTextOut_W(Canvas, Left,Top,
                ETO_CLIPPED or ETO_OPAQUE or ETOOption, @r,
                Str, StrLen, Pointer(PDX2))
            else
            {$ENDIF}
              GraphicInterface.ExtTextOut_A(Canvas, Left,Top,
                ETO_CLIPPED or ETO_OPAQUE or ETOOption, @r,
                Str, StrLen, Pointer(PDX2));
            break;
          end;
          dx  := PDX[i];
          inc(Start,dx);
        end;
        if OldSelectedCount=SelectedCount then
          break;
      end;
    end;
  finally
    if UseRefCanvasRes then begin
      GraphicInterface.SetWindowOrgEx(Canvas, wopt.x, wopt.y, nil);
      GraphicInterface.SetWindowExtEx(Canvas, wesz.cx, wesz.cy, nil);
    end;
    FreeMem(POrder);
    FreeMem(POrderRev);
    FreeMem(PDX);
    FreeMem(Selected);
    FreeMem(PClass);    
    if PGlyphs<>nil then
      FreeMem(PGlyphs);
  end;
end;
{------------------------------------------------------------------------------}
function RVU_GetTextCaretPos(Canvas: TCanvas; const s: TRVRawByteString;
  PCP: PRVIntegerArray; ItemOptions: TRVItemOptions; Width, Delta: Integer;
  GraphicInterface: TRVGraphicInterface): Boolean;
var res: TGCPResultsA;
    i: Integer;
    POrder,POrderRev: PRVUnsignedArray;
    PDX: PRVIntegerArray;
    PClass: PRVAnsiChar;
    DX, idx: Integer;
    cls: TRVAnsiChar;
    p: Integer;
    Len: Integer;
    sz, sz2: TSmallPoint;
    UseSz2: Boolean;
    HasUnpositionedChars: Boolean;
    {..........................................}
    procedure InitStructure;
    begin
      FillChar(res, sizeof(res), 0);
      FillChar(POrder^, Len*sizeof(Cardinal), 0);
      FillChar(POrderRev^, Len*sizeof(Cardinal), $FF);
      FillChar(PDX^,    Len*sizeof(Integer),  0);
      FillChar(PClass^, Length(s),            0);
      res.lStructSize := sizeof(res);
      res.nGlyphs := Len;
      res.lpOrder := @(POrder[0]);
      res.lpClass := PClass;
      res.lpDx    := @(PDX[0]);
    end;
    {..........................................}
begin
  if rvioUnicode in ItemOptions then
    Len := Length(s) div 2
  else
    Len := Length(s);
  POrder := nil;
  POrderRev := nil;
  PClass := nil;
  PDX    := nil;
  FillChar(PCP^, (Len+1)*sizeof(Integer), -1);
  try
    GetMem(POrder,    Len*sizeof(Cardinal));
    GetMem(POrderRev, Len*sizeof(Cardinal));
    GetMem(PDX,       Len*sizeof(Integer));
    GetMem(PClass,    Length(s)); // for any case
    InitStructure;
    UseSz2 := (rvioUnicode in ItemOptions) or
      GraphicInterface.FontHasLigationGlyphs(Canvas);
    if UseSz2 then begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if rvioUnicode in ItemOptions then
        sz2 := TSmallPoint(GraphicInterface.GetCharacterPlacement_W(Canvas,
          Pointer(s), Len, res, True))
      else
      {$ENDIF}
        sz2 := TSmallPoint(GraphicInterface.GetCharacterPlacement_A(Canvas,
          PRVAnsiChar(s), Len, res, True));
      end
    else begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if rvioUnicode in ItemOptions then
        sz := TSmallPoint(GraphicInterface.GetCharacterPlacement_W(Canvas,
          Pointer(s), Len, res, False))
      else
      {$ENDIF}
        sz := TSmallPoint(GraphicInterface.GetCharacterPlacement_A(Canvas,
          PRVAnsiChar(s), Len, res, False));
    end;
    if UseSz2 then
      sz := sz2;
    Result := {(Abs(sz.x-Width)<Delta) and }(sz.y>0);
    if Result then begin
      p := 0;
      for i := 0 to Len-1 do
        POrderRev[POrder[i]] := i;
      HasUnpositionedChars := False;
      for i := 0 to Len-1 do begin
        idx := Integer(POrderRev[i]);
        if idx<0 then begin
          HasUnpositionedChars := True;
          continue;
        end;
        {$IFNDEF RVDONOTUSESOFTHYPHENS}
        if (rvioUnicode in ItemOptions) and
           ((PRVWordArray(s)[i]=UNI_ZERO_WIDTH_SPACE) or
            {(PRVWordArray(s)[i]=UNI_ZERO_WIDTH_JOINER) or}
            (PRVWordArray(s)[i]=UNI_WORD_JOINER)) then
          PDX[i] := 0;
        {$ENDIF}
        dx  := PDX[i];
        cls := PClass[idx];
        if cls in [chr(GCPCLASS_ARABIC),
                   chr(GCPCLASS_HEBREW)] then begin
          PCP[idx+1] := p;
          if idx=0 then
            PCP[0] := p+dx;
          end
        else begin
          PCP[idx+1] := p+dx+1;
          if idx=0 then
            PCP[0] := p;
        end;
        inc(p,dx);
      end;
      if HasUnpositionedChars then begin
        for i := 0 to Len do
          if PCP[i]<0 then
            if i=0 then
              PCP[i] := 0
            else
              PCP[i] := PCP[i-1];
      end;
    end;
  finally
    FreeMem(POrder);
    FreeMem(POrderRev);
    FreeMem(PClass);
    FreeMem(PDX);
  end;
end;
{------------------------------------------------------------------------------}
{ It's assumed that PGlyphs contains at least (length of text) x 2 characters }
function RVU_GetTextGlyphDX(Canvas: TCanvas; const s: TRVRawByteString;
  PDx: PRVIntegerArray; PGlyphs: PRVWordArray;
  ItemOptions: TRVItemOptions; Width: Integer;
  var nGlyphs: Integer; GraphicInterface: TRVGraphicInterface): Boolean;
var res: TGCPResultsA;
    Len: Integer;
    sz, sz2: TSmallPoint;
    UseSz2: Boolean;
    {..........................................}
    procedure InitStructure;
    begin
      FillChar(res, sizeof(res), 0);
      FillChar(PDX^,    Len*sizeof(Integer),  0);
      FillChar(PGlyphs^, Len*sizeof(Word)*2,0);
      res.lStructSize := sizeof(res);
      res.nGlyphs := Len;
      res.lpDx    := @(PDX[0]);
      res.lpGlyphs := @(PGlyphs[0]);
      res.nGlyphs := Len*2;
    end;
    {..........................................}
begin
  if rvioUnicode in ItemOptions then
    Len := Length(s) div 2
  else
    Len := Length(s);

  InitStructure;
  UseSz2 := (rvioUnicode in ItemOptions) or
    GraphicInterface.FontHasLigationGlyphs(Canvas);
  if UseSz2 then begin
    {$IFNDEF RVDONOTUSEUNICODE}
    if rvioUnicode in ItemOptions then
      sz2 := TSmallPoint(GraphicInterface.GetCharacterPlacement_W(Canvas,
        Pointer(s), Len, res, True))
    else
    {$ENDIF}
      sz2 := TSmallPoint(GraphicInterface.GetCharacterPlacement_A(Canvas,
        PRVAnsiChar(s), Len, res, True));
    end
  else begin
    {$IFNDEF RVDONOTUSEUNICODE}
    if rvioUnicode in ItemOptions then
      sz := TSmallPoint(GraphicInterface.GetCharacterPlacement_W(Canvas,
        Pointer(s), Len, res, False))
    else
    {$ENDIF}
      sz := TSmallPoint(GraphicInterface.GetCharacterPlacement_A(Canvas,
        PRVAnsiChar(s), Len, res, False));
  end;
  if UseSz2 then
    sz := sz2;
  Result := {(Abs(sz.x-Width)<2*RVFORMATCANVASFACTOR) and} (sz.y>0);
  nGlyphs := res.nGlyphs;
end;
{------------------------------------------------------------------------------}
function RVU_GetTextRangeCoords(Canvas: TCanvas; const s: TRVRawByteString;
  RangeStartOffs, RangeLength: Integer; ItemOptions: TRVItemOptions;
  Width, Delta: Integer; var X1,X2: Integer;
  GraphicInterface: TRVGraphicInterface): Boolean;
var PCP: PRVIntegerArray;
    X: Integer;
    Len: Integer;
begin
  if rvioUnicode in ItemOptions then
    Len := Length(s) div 2
  else
    Len := Length(s);
  GetMem(PCP, (Len+1)*sizeof(Integer));
  try
    Result := RVU_GetTextCaretPos(Canvas, s, PCP, ItemOptions, Width, Delta,
      GraphicInterface);
    if Result then begin
      X1 := PCP[RangeStartOffs-1];
      X2 := PCP[RangeStartOffs-1+RangeLength];
      if X2<X1 then begin
        X := X1;
        X1 := X2;
        X2 := X;
      end;
    end;
  finally
    FreeMem(PCP);
  end;
end;
{$IFNDEF RVDONOTUSEUNICODE}
{------------------------------------------------------------------------------}
function RVU_Copy(const s: TRVRawByteString; Index, Count: Integer;
  ItemOptions: TRVItemOptions): TRVRawByteString;
begin
  if not (rvioUnicode in ItemOptions) then
    Result := Copy(s, Index, Count)
  else
    Result := Copy(s, 1+(Index-1)*2, Count*2);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESOFTHYPHENS}
function GetZWSWidth(Canvas: TCanvas; GraphicInterface: TRVGraphicInterface): Integer;
var sz: TSize;
    ch: WideChar;
begin
  ch := WideChar(UNI_ZERO_WIDTH_SPACE);
  GraphicInterface.GetTextExtentPoint32_W(Canvas, @ch, 1, sz);
  Result := sz.cx;
end;

function GetWJWidth(Canvas: TCanvas; GraphicInterface: TRVGraphicInterface): Integer;
var sz: TSize;
    ch: WideChar;
begin
  ch := WideChar(UNI_WORD_JOINER);
  GraphicInterface.GetTextExtentPoint32_W(Canvas, @ch, 1, sz);
  Result := sz.cx;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure RVU_GetTextExtentPoint32W(Canvas: TCanvas; str: Pointer; Len: Integer;
  var sz: TSize; GraphicInterface: TRVGraphicInterface);
{$IFNDEF RVDONOTUSESOFTHYPHENS}
var i: Integer;
    ZWSWidth, {ZWJWidth, }WJWidth: Integer;
{$ENDIF}
begin
  GraphicInterface.GetTextExtentPoint32_W(Canvas, str, Len, sz);
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
  ZWSWidth := -1;
  {ZWJWidth := -1;}
  WJWidth  := -1;
  for i := 0 to Len-1 do
    case PRVWordArray(str)[i] of
      UNI_ZERO_WIDTH_SPACE:
        begin
          if ZWSWidth<0 then
            ZWSWidth := GetZWSWidth(Canvas, GraphicInterface);
          dec(sz.cx, ZWSWidth);
        end;
      {UNI_ZERO_WIDTH_JOINER:
        begin
          if ZWJWidth<0 then
            ZWJWidth := GetZWJWidth(Canvas, GraphicInterface);
          dec(sz.cx, ZWJWidth);
        end;}
      UNI_WORD_JOINER:
        begin
          if WJWidth<0 then
            WJWidth := GetWJWidth(Canvas, GraphicInterface);
          dec(sz.cx, WJWidth);
        end;
    end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure RVU_GetTextExtentExPoint(Canvas: TCanvas; const s: TRVRawByteString;
  MaxExtent: Integer; var Fit: Integer; PDx: PRVIntegerArray;
  ItemOptions: TRVItemOptions; GraphicInterface: TRVGraphicInterface);
var sz: TSize;
    Len: Integer;
begin
  Len := Length(s);
  if rvioUnicode in ItemOptions then
    Len := Len div 2;
  RVU_GetTextExtentExPointPC(Canvas, PRVAnsiChar(s), Len, MaxExtent, Fit, PDx,
    ItemOptions, sz, GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Length - length in characters (not bytes) }
procedure RVU_GetTextExtentExPointPC(Canvas: TCanvas; pc: PRVAnsiChar; Length: Integer;
  MaxExtent: Integer; var Fit: Integer; PDx: PRVIntegerArray;
  ItemOptions: TRVItemOptions; var sz: TSize; GraphicInterface: TRVGraphicInterface);
var i, delta, Width: Integer;
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
    j: Integer;
    ZWSWidth, {ZWJWidth,} WJWidth: Integer;
  {$ENDIF}
  {$IFNDEF RICHVIEWDEF4}
    allocated: Boolean;
  {$ELSE}
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
    allocated: Boolean;
  {$ENDIF}
  {$ENDIF}
begin
  if Length=0 then begin
    Fit := 0;
    exit;
  end;
  {$IFNDEF RICHVIEWDEF4}
  allocated := False;
  {$ELSE}
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
  allocated := False;
  {$ENDIF}
  {$ENDIF}
  if not (rvioUnicode in ItemOptions) then begin
    {$IFNDEF RICHVIEWDEF4}
    if PDx=nil then begin
      GetMem(PDx, (Length+1)*sizeof(Integer));
      allocated := True;
    end;
    {$ENDIF}
     GraphicInterface.GetTextExtentExPoint_A(Canvas,  pc, Length, MaxExtent,
      @Fit, PInteger(PDx), sz);
    if Fit<Length then
      GraphicInterface.GetTextExtentPoint32_A(Canvas, pc, Fit, sz);
    end
  else if not (RVNT) then begin
    Fit := -1;
    {$IFNDEF RVDONOTUSESOFTHYPHENS}
    ZWSWidth := -1;
    {ZWJWidth := -1;}
    WJWidth  := -1;
    {$ENDIF}
    for i := 1 to Length do begin
      GraphicInterface.GetTextExtentPoint32_W(Canvas, Pointer(pc), i, sz);
      {$IFNDEF RVDONOTUSESOFTHYPHENS}
      case PRVWordArray(pc)[i-1] of
        UNI_ZERO_WIDTH_SPACE:
          begin
            if ZWSWidth<0 then
              ZWSWidth := GetZWSWidth(Canvas, GraphicInterface);
            dec(sz.cx, ZWSWidth);
          end;
        {UNI_ZERO_WIDTH_JOINER:
          begin
            if ZWJWidth<0 then
              ZWJWidth := GetZWJWidth(Canvas, GraphicInterface);
            dec(sz.cx, ZWJWidth);
          end;}
        UNI_WORD_JOINER:
          begin
            if WJWidth<0 then
              WJWidth := GetWJWidth(Canvas, GraphicInterface);
            dec(sz.cx, WJWidth);
          end;
      end;
      {$ENDIF}
      if sz.cx>MaxExtent then begin
        Fit := i-1;
        break;
      end;
      if PDx<>nil then
        PDx[i-1] := sz.cx;
    end;
    if Fit<0 then
      Fit := Length;
    end
  else begin
    {$IFNDEF RICHVIEWDEF4}
    if PDx=nil then begin
      GetMem(PDx, (Length+1)*sizeof(Integer));
      allocated := True;
    end;
    {$ENDIF}
    delta := 0;
    {$IFNDEF RVDONOTUSESOFTHYPHENS}
    if (PDx=nil) and
       ((RVU_StrScanW(pc, UNI_ZERO_WIDTH_SPACE, Length)<>nil) or
        {(RVU_StrScanW(pc, UNI_ZERO_WIDTH_JOINER, Length)<>nil) or}
        (RVU_StrScanW(pc, UNI_WORD_JOINER, Length)<>nil)) then begin
      GetMem(PDx, (Length+1)*sizeof(Integer));
      allocated := True;
    end;
    ZWSWidth := -1;
    WJWidth  := -1;
    if PDx<>nil then begin
      for i := 0 to Length-1 do
        case PRVWordArray(pc)[i] of
          UNI_ZERO_WIDTH_SPACE:
            begin
              if ZWSWidth<0 then
                ZWSWidth := GetZWSWidth(Canvas, GraphicInterface);
              inc(delta, ZWSWidth);
            end;
          UNI_WORD_JOINER:
            begin
              if WJWidth<0 then
                WJWidth := GetWJWidth(Canvas, GraphicInterface);
              inc(delta, WJWidth);
            end;
        end;
    end;
    {$ENDIF}
    if MaxExtent<>MaxInt then
      Width := MaxExtent+delta
    else
      Width := MaxExtent;
    GraphicInterface.GetTextExtentExPoint_W(Canvas, Pointer(pc), Length,
      Width, @Fit, PInteger(PDx), sz);
    {$IFNDEF RVDONOTUSESOFTHYPHENS}
    if delta<>0 then begin
      for i := 0 to Fit-1 do
        if (PRVWordArray(pc)[i]=UNI_ZERO_WIDTH_SPACE) or
           {(PRVWordArray(pc)[i]=UNI_ZERO_WIDTH_JOINER) or}
           (PRVWordArray(pc)[i]=UNI_WORD_JOINER) then begin
          if i=0 then
            delta := PDx[0]
          else
            delta := PDx[i]-PDx[i-1];
          if delta<>0 then begin
            for j := i to Fit-1 do
              dec(PDx[j], delta);
          end;
      end;
      while (Fit>0) and (PDx[Fit-1]>MaxExtent) do
        dec(Fit);
    end;
    {$ENDIF}
    if Fit<Length then
      GraphicInterface.GetTextExtentPoint32_W(Canvas, Pointer(pc), Fit, sz);
    {$IFNDEF RVDONOTUSESOFTHYPHENS}
    if delta<>0 then
      while True do begin
        for i := 0 to Fit-1 do
          case PRVWordArray(pc)[i] of
            UNI_ZERO_WIDTH_SPACE:
              begin
                if ZWSWidth<0 then
                  ZWSWidth := GetZWSWidth(Canvas, GraphicInterface);
                dec(sz.cx, ZWSWidth);
              end;
            UNI_WORD_JOINER:
              begin
                if WJWidth<0 then
                  WJWidth := GetWJWidth(Canvas, GraphicInterface);
                dec(sz.cx, WJWidth);
              end;
          end;
        if (Fit>0) and (sz.cx>MaxExtent) then begin
          dec(Fit);
          GraphicInterface.GetTextExtentPoint32_W(Canvas, Pointer(pc), Fit, sz);
          end
        else
          break;
      end;
    {$ENDIF}
  end;
  {$IFNDEF RICHVIEWDEF4}
  if allocated then
    FreeMem(PDx);
  {$ELSE}
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
  if allocated then
    FreeMem(PDx);  
  {$ENDIF}
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function RVU_Length(const s: TRVRawByteString; ItemOptions: TRVItemOptions): Integer;
begin
  if not (rvioUnicode in ItemOptions) then
    Result := Length(s)
  else
    Result := Length(s) div 2;
end;
{------------------------------------------------------------------------------}
function RVU_TextWidth(const s: TRVRawByteString; Canvas: TCanvas;
  ItemOptions: TRVItemOptions; GraphicInterface: TRVGraphicInterface): Integer;
var Size: TSize;
begin
  if not (rvioUnicode in ItemOptions) then
    GraphicInterface.GetTextExtentPoint32_A(Canvas,
      PRVAnsiChar(s), Length(s), Size)
  else
    RVU_GetTextExtentPoint32W(Canvas,
      Pointer(PRVAnsiChar(s)), Length(s) div 2, Size, GraphicInterface);
  Result := Size.cx;
end;
{------------------------------------------------------------------------------}
function RVU_IsSpace(const s: TRVRawByteString; Index: Integer;
  ItemOptions: TRVItemOptions): Boolean;
begin
  if not (rvioUnicode in ItemOptions) then
    Result := s[Index]=' '
  else
    Result := (s[(Index-1)*2+1]=' ') and (s[Index*2]=#0);
end;
{------------------------------------------------------------------------------}
procedure RVU_Delete(var s: TRVRawByteString; Index, Count: Integer;
  ItemOptions: TRVItemOptions);
begin
  if not (rvioUnicode in ItemOptions) then
    Delete(s, Index, Count)
  else
    Delete(s, (Index-1)*2+1, Count*2);
end;
{------------------------------------------------------------------------------}
procedure RVU_Insert(const Source: TRVRawByteString; var s: TRVRawByteString;
  Index: Integer; ItemOptions: TRVItemOptions);
begin
  if not (rvioUnicode in ItemOptions) then
    Insert(Source, s, Index)
  else
    Insert(Source, s, (Index-1)*2+1);
end;
{------------------------------------------------------------------------------}
function RVU_OffsInPChar(Offs: Integer; ItemOptions: TRVItemOptions): Integer;
begin
  if not (rvioUnicode in ItemOptions) then
    Result := Offs
  else
    Result := Offs*2;
end;
{------------------------------------------------------------------------------}
{$ELSE}
{------------------------------------------------------------------------------}
function RVU_Copy(const s: TRVRawByteString; Index, Count: Integer;
  ItemOptions: TRVItemOptions): TRVRawByteString;
begin
  Result := Copy(s, Index, Count);
end;
{------------------------------------------------------------------------------}
procedure RVU_GetTextExtentExPoint(Canvas: TCanvas; const s: TRVRawByteString;
  MaxExtent: Integer; var Fit: Integer; PDx: PRVIntegerArray;
  ItemOptions: TRVItemOptions; GraphicInterface: TRVGraphicInterface);
var sz: TSize;
{$IFNDEF RICHVIEWDEF4}
    allocated: Boolean;
{$ENDIF}
begin
  if Length(s)=0 then begin
    Fit := 0;
    exit;
  end;
  {$IFNDEF RICHVIEWDEF4}
  if PDx=nil then begin
    GetMem(PDx, (Length(s)+1)*sizeof(Integer));
    allocated := True;
    end
  else
    allocated := False;
  {$ENDIF}
  GraphicInterface.GetTextExtentExPoint_A(Canvas,  PRVAnsiChar(s), Length(s),
    MaxExtent, @Fit, PInteger(PDx), sz);
  {$IFNDEF RICHVIEWDEF4}
  if allocated then
    FreeMem(PDx);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure RVU_GetTextExtentExPointPC(Canvas: TCanvas; pc: PRVAnsiChar;
  Length: Integer; MaxExtent: Integer; var Fit: Integer;
  PDx: PRVIntegerArray; ItemOptions: TRVItemOptions; var sz: TSize;
  GraphicInterface: TRVGraphicInterface);

{$IFNDEF RICHVIEWDEF4}
var
    allocated: Boolean;
{$ENDIF}
begin
  if Length=0 then begin
    Fit := 0;
    exit;
  end;
  {$IFNDEF RICHVIEWDEF4}
  if PDx=nil then begin
    GetMem(PDx, (Length+1)*sizeof(Integer));
    allocated := True;
    end
  else
    allocated := False;
  {$ENDIF}
  GraphicInterface.GetTextExtentExPoint_A(Canvas, pc, Length, MaxExtent,
    @Fit, PInteger(PDx), sz);
  {$IFNDEF RICHVIEWDEF4}
  if allocated then
    FreeMem(PDx);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function RVU_Length(const s: TRVRawByteString; ItemOptions: TRVItemOptions): Integer;
begin
  Result := Length(s);
end;
{------------------------------------------------------------------------------}
function RVU_TextWidth(const s: TRVRawByteString; Canvas: TCanvas;
  ItemOptions: TRVItemOptions; GraphicInterface: TRVGraphicInterface): Integer;
var Size: TSize;
begin
  GraphicInterface.GetTextExtentPoint32_A(Canvas, PRVAnsiChar(s), Length(s), Size);
  Result := Size.cx;
end;
{------------------------------------------------------------------------------}
function RVU_IsSpace(const s: TRVRawByteString; Index: Integer;
                     ItemOptions: TRVItemOptions): Boolean;
begin
  Result := s[Index]=' ';
end;
{------------------------------------------------------------------------------}
procedure RVU_Delete(var s: TRVRawByteString; Index, Count: Integer;
  ItemOptions: TRVItemOptions);
begin
  Delete(s, Index, Count);
end;
{------------------------------------------------------------------------------}
procedure RVU_Insert(const Source: TRVRawByteString; var s: TRVRawByteString;
  Index: Integer; ItemOptions: TRVItemOptions);
begin
  Insert(Source, s, Index);
end;
{------------------------------------------------------------------------------}
function RVU_OffsInPChar(Offs: Integer; ItemOptions: TRVItemOptions): Integer;
begin
  Result := Offs;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function RVU_DrawSelectedTextEx(Left, Top, Width: Integer;
  const s: TRVRawByteString; Canvas, RefCanvas: TCanvas; Index1,Index2: Integer;
  ItemOptions: TRVItemOptions; BiDiMode: TRVBiDiMode;
  UseRefCanvasRes: Boolean; GraphicInterface: TRVGraphicInterface): Boolean;
begin
  if BiDiMode=rvbdUnspecified then
    Result := False
  else
    Result := RVU_DrawSelectedTextEx_(Left, Top, Width, s, Canvas,
      RefCanvas, Index1, Index2, ItemOptions, UseRefCanvasRes, GraphicInterface);
end;
{------------------------------------------------------------------------------}
function RVU_CodePage2Charset(CodePage: TRVCodePage): TFontCharset;
begin
  case CodePage of
    CP_OEMCP:
      Result := OEM_CHARSET;
    CP_MACCP:
      Result := MAC_CHARSET;
    1258:
      Result := VIETNAMESE_CHARSET;
    1252:
      Result := ANSI_CHARSET;
    932:
      Result := SHIFTJIS_CHARSET;
    949:
      Result := HANGEUL_CHARSET;
    1361:
      Result := JOHAB_CHARSET;
    936:
      Result := GB2312_CHARSET;
    950:
      Result := CHINESEBIG5_CHARSET;
    1253:
      Result := GREEK_CHARSET;
    1254:
      Result := TURKISH_CHARSET;
    1255:
      Result := HEBREW_CHARSET;
    1256:
      Result := ARABIC_CHARSET;
    1257:
      Result := BALTIC_CHARSET;
    1251:
      Result := RUSSIAN_CHARSET;
    874:
      Result := THAI_CHARSET;
    1250:
      Result := EASTEUROPE_CHARSET;
    else
       Result := DEFAULT_CHARSET;
  end;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
function IsDBCSACP: Boolean;
var Info: TCPInfo;
begin
  if GetCPInfo(CP_ACP, Info) then
    Result := Info.MaxCharSize>1
  else
    Result := False;
end;

function RVU_Charset2CodePage(Charset: TFontCharset): TRVCodePage;
begin
  case Charset of
    DEFAULT_CHARSET:
      Result := CP_ACP;
    OEM_CHARSET:
       Result := CP_OEMCP;
    MAC_CHARSET:
       Result := CP_MACCP;
    SYMBOL_CHARSET:
      if IsDBCSACP then
        Result := 1252
      else
        Result := CP_ACP;
    VIETNAMESE_CHARSET:
       Result := 1258;
    ANSI_CHARSET, 254: // 254 = Western OEM Charset in RTF. It is supposed that text
                       // is converted to ANSI
      Result := 1252;   // ANSI
    SHIFTJIS_CHARSET:
       Result := 932;   // Japan
    HANGEUL_CHARSET:
       Result := 949;   // Korean
    JOHAB_CHARSET:
       Result := 1361;  // Korean (Johab)
    GB2312_CHARSET:
       Result := 936;   // Chinese (PRC, Singapore)
    CHINESEBIG5_CHARSET:
       Result := 950;   // Chinese (Taiwan, Hong Kong)
    GREEK_CHARSET:
       Result := 1253;  // Greek
    TURKISH_CHARSET:
       Result := 1254;  // Turkish
    HEBREW_CHARSET:
       Result := 1255;   // Hebrew
    ARABIC_CHARSET:
       Result := 1256;   // Arabic
    BALTIC_CHARSET:
       Result := 1257;   // Baltic
    RUSSIAN_CHARSET:
       Result := 1251;   // Cyrillic
    THAI_CHARSET:
       Result := 874;    // Thai
    EASTEUROPE_CHARSET:
       Result := 1250;   // Eastern European
    else
       Result := CP_ACP;
  end;
end;
{------------------------------------------------------------------------------}
function RVU_Charset2Language(Charset: TFontCharset): Cardinal;
begin
  // PLEASE REPORT ME ABOUT ERRORS IN THIS TABLE
  // Note: trying to make a best guess here;
  // one charset can be used by a lots of languages
  case Charset of
    DEFAULT_CHARSET:
      Result := $0000; // default
    OEM_CHARSET:
       Result := $0400; // default
    MAC_CHARSET:
       Result := $0400; // default
    SYMBOL_CHARSET:
      Result := $0400; // default
    VIETNAMESE_CHARSET:
       Result := $042A;  // by experement with MS Word
    ANSI_CHARSET:
      Result := $0000;   // default - too many options
    SHIFTJIS_CHARSET:
       Result := $0411;   // Japanese
    HANGEUL_CHARSET:
       Result := $0412;   // Korean
    JOHAB_CHARSET:
       Result := $0812;  // Korean (Johab)
    GB2312_CHARSET:
       Result := $0804;   // Chinese (PRC; more options possible here)
    CHINESEBIG5_CHARSET:
       Result := $0404;	  // Chinese (Taiwan; more options possible here)
    GREEK_CHARSET:
       Result := $0408;  // Greek
    TURKISH_CHARSET:
       Result := $041F;  // Turkish
    HEBREW_CHARSET:
       Result := $040D;  // Hebrew
    ARABIC_CHARSET:
       Result := $0000;	 // default - too many options
    BALTIC_CHARSET:
       Result := $0000;  // default - too many options
    RUSSIAN_CHARSET:
       Result := $0419;   // Russian
    THAI_CHARSET:
       Result := $041E;    // Thai
    EASTEUROPE_CHARSET:
       Result := $0000;   // default - too many options
    else
       Result := $0400;
  end;
end;
{------------------------------------------------------------------------------}
function RVU_RawUnicodeToWideString(const s: TRVRawByteString): TRVUnicodeString;
begin
  RVCheckUni(Length(s));
  SetLength(Result, Length(s) div 2);
  Move(Pointer(s)^, Pointer(Result)^, Length(s));
end;
{------------------------------------------------------------------------------}
function RVU_GetRawUnicode(const s: TRVUnicodeString): TRVRawByteString;
begin
  SetLength(Result, Length(s)*2);
  Move(Pointer(s)^, Pointer(Result)^, Length(Result));
end;
{$ELSE}
{------------------------------------------------------------------------------}
function RVU_GetRawUnicode(const s: String):String;
begin
  Result := s;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure RVU_SwapWordBytes(arr: PWord; Count: Integer);
var i: Integer;
begin
  for i := 0 to Count-1 do begin
    arr^ := Swap(Word(arr^));
    inc(PRVAnsiChar(arr),2);
  end;
end;
{------------------------------------------------------------------------------}
procedure RVU_ProcessByteOrderMark(var arr: PWord; Count: Integer);
begin
  if Count=0 then
    exit;
  case arr^ of
    UNI_MSB_FIRST:
      begin
        inc(PRVAnsiChar(arr), 2);
        RVU_SwapWordBytes(arr, Count-1);
      end;
    UNI_LSB_FIRST:
      inc(PRVAnsiChar(arr), 2);
  end;
end;
{------------------------------------------------------------------------------}
function RVU_AnsiToUnicode(CodePage: TRVCodePage;
  const s: TRVAnsiString): TRVRawByteString;
var l: Integer;
    Flags: Integer;
begin
  if Length(s)=0 then begin
    Result := '';
    exit;
  end;
  Flags := MB_PRECOMPOSED or MB_USEGLYPHCHARS;
  l := MultiByteToWideChar(CodePage, Flags, PRVAnsiChar(s), Length(s),
                           nil, 0);
  if (l=0) and (CodePage<>CP_ACP) then begin
    CodePage := CP_ACP;
    l := MultiByteToWideChar(CodePage, Flags, PRVAnsiChar(s), Length(s),
                           nil, 0);
  end;
  if l<>0 then begin
    SetLength(Result, l*2);
    MultiByteToWideChar(CodePage, Flags, PRVAnsiChar(s), Length(s),
                             Pointer(Result), l);
    end
  else begin
    SetLength(Result, Length(s)*2);
    FillChar(PRVAnsiChar(Result)^, Length(Result), 0);
    for l := 0 to Length(s)-1 do
      Result[l*2+1] := RVDEFAULTCHARACTER
  end;
end;
{------------------------------------------------------------------------------}
function RVU_AnsiToUTF8(CodePage: TRVCodePage; const s: TRVAnsiString): TRVRawByteString;
begin
  {$IFDEF RICHVIEWCBDEF3}
  if s='' then
    Result := ''
  else
    Result := UTF8Encode(RVU_RawUnicodeToWideString((RVU_AnsiToUnicode(CodePage, s))));
  {$ELSE}
    Result := s;
  {$ENDIF}
end;

{------------------------------------------------------------------------------}
function RVU_UnicodeToAnsi(CodePage: TRVCodePage; const s: TRVRawByteString): TRVAnsiString;
var l: Integer;
    DefChar: Char;
    Flags: Integer;
    Len: Integer;
begin
  if Length(s)=0 then begin
    Result := '';
    exit;
  end;
  RVCheckUni(Length(s));
  DefChar := RVDEFAULTCHARACTER;
  Flags := 0;// WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR;
  Len := Length(s) div 2;
  l := WideCharToMultiByte(CodePage, Flags, Pointer(s), Len, nil, 0, @DefChar, nil);
  if (l=0) and (CodePage<>CP_ACP) then begin
    CodePage := CP_ACP;
    l := WideCharToMultiByte(CodePage, Flags, Pointer(s), Len, nil, 0, @DefChar, nil);
  end;
  if l<>0 then begin
    SetLength(Result, l);
    WideCharToMultiByte(CodePage, Flags, Pointer(s), Len, PRVAnsiChar(Result), l, @DefChar, nil);
    end
  else begin
    SetLength(Result, Len);
    FillChar(PRVAnsiChar(Result)^, Len, RVDEFAULTCHARACTER);
  end;
end;
{------------------------------------------------------------------------------}
function RVU_CanBeConvertedToAnsi(CodePage: TRVCodePage;
  const s: TRVRawByteString): Boolean;
var l: Integer;
    DefChar: Char;
    Flags: Integer;
    Len: Integer;
    UsedDefChar: LongBool;
begin
  Result := False;
  exit;
  if Length(s)=0 then begin
    Result := True;
    exit;
  end;
  RVCheckUni(Length(s));
  DefChar := RVDEFAULTCHARACTER;
  Flags := WC_COMPOSITECHECK	or WC_DEFAULTCHAR;
  Len := Length(s) div 2;
  UsedDefChar := False;
  l := WideCharToMultiByte(CodePage, Flags, Pointer(s), Len, nil, 0, @DefChar, @UsedDefChar);
  Result := (l>0) and not UsedDefChar;
end;
{------------------------------------------------------------------------------}
function RV_TestStreamUnicode(Stream: TStream): TRVUnicodeTestResult;
var FirstChar: Word;
    Len: Integer;
    s: TRVRawByteString;
begin
  try
    if Stream.Size=0 then
      Result := rvutEmpty
    else if Stream.Size mod 2 <> 0 then
      Result := rvutNo
    else begin
      Stream.ReadBuffer(FirstChar, 2);
      if (FirstChar=UNI_LSB_FIRST) or
         (FirstChar=UNI_MSB_FIRST) then
        Result := rvutYes
      else begin
        Len := Stream.Size-2;
        if Len>500 then Len := 500;
        SetLength(s, Len);
        Stream.ReadBuffer(PRVAnsiChar(s)^, Len);
        if RVPos(#0, s)<>0 then
          Result := rvutYes
        else
          Result := rvutProbably;
      end;
    end;
  except
    Result := rvutError;
  end;
end;
{------------------------------------------------------------------------------}
function RV_TestFileUnicode(const FileName: String): TRVUnicodeTestResult;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    Result := RV_TestStreamUnicode(Stream);
    Stream.Free;
  except
    Result := rvutError;
  end;
end;
{------------------------------------------------------------------------------}
function RV_TestStringUnicode(const s: TRVRawByteString): TRVUnicodeTestResult;
var Stream: TMemoryStream;
    Len: Integer;
begin
  if Length(s) mod 2 <> 0 then begin
    Result := rvutNo;
    exit;
  end;
  Len := Length(s);
  if Len>500 then
    Len := 500;
  try
    Stream := TMemoryStream.Create;
    try
      Stream.SetSize(Len);
      Stream.WriteBuffer(PRVAnsiChar(s)^, Len);
      Stream.Position := 0;
      Result := RV_TestStreamUnicode(Stream);
    finally
      Stream.Free;
    end;
  except
    Result := rvutError;
  end;
end;
{------------------------------------------------------------------------------}
function RVU_GetKeyboardCodePage: TRVCodePage;
var Buf: String;
    Len: Integer;
    Locale: LCID;
    {$IFNDEF RICHVIEWCBDEF3}
const LOCALE_IDEFAULTANSICODEPAGE = $00001004;
    {$ENDIF}
begin
  Locale := GetKeyboardLayout(0) and $FFFF;
  Len := GetLocaleInfo(Locale, LOCALE_IDEFAULTANSICODEPAGE, nil, 0);
  SetLength(Buf, Len);
  GetLocaleInfo(Locale, LOCALE_IDEFAULTANSICODEPAGE, PChar(Buf), Len);
  Result := StrToIntDef(Buf, GetACP);
end;
{------------------------------------------------------------------------------}
{ Returns language of keyboard layout as hexadecimal string }
function RVU_GetKeyboardLanguage: Cardinal;
var Buf: String;
    Len: Integer;
    Locale: LCID;
    {$IFNDEF RICHVIEWCBDEF3}
const LOCALE_ILANGUAGE = $00000001;
    {$ENDIF}

    function GetHex(ch: TRVAnsiChar): Cardinal;
    begin
      if ch in ['0'..'9'] then
        Result := ord(ch)-ord('0')
      else if ch in ['a'..'f'] then
        Result := ord(ch)-ord('a')+10
      else if ch in ['A'..'F'] then
        Result := ord(ch)-ord('A')+10
      else
        Result := 0;
    end;

begin
  Locale := GetKeyboardLayout(0) and $FFFF;
  Len := GetLocaleInfo(Locale, LOCALE_ILANGUAGE, nil, 0);
  SetLength(Buf, Len);
  GetLocaleInfo(Locale, LOCALE_ILANGUAGE, PChar(Buf), Len);
  Len := Pos(#0, Buf);
  if Len>0 then
    SetLength(Buf, Len-1);
  Result := 0;
  for Len := 1 to Length(Buf) do
    Result := Result*16+GetHex(TRVAnsiChar(Buf[Len]));
end;
{------------------------------------------------------------------------------}
function RVU_KeyToUnicode(const Key: TRVAnsiString): TRVRawByteString;
begin
  Result :=  RVU_AnsiToUnicode(RVU_GetKeyboardCodePage, Key);
end;
{------------------------------------------------------------------------------}
function RVU_StrScanW(Str: Pointer; Ch: Word; Length: Integer): Pointer;
// in: Str -> EAX, Ch -> EDX, Length -> ECX
// out: Result -> EAX
// Assums Str<>nil
asm
    JCXZ @@RetNil
@@Loop:
    CMP [EAX], DX
    JE @@Done
    INC EAX
    INC EAX
    DEC ECX
    JNZ @@Loop
@@RetNil:
    XOR EAX, EAX
@@Done:
end;
{------------------------------------------------------------------------------}
{ returns number of characters in a string excluding the null terminator       }
function RVU_StrLenW(Str: Pointer): Cardinal;
// in: Str -> EAX
// out: Result -> EAX
asm
    MOV EDX, EDI
    MOV EDI, EAX
    MOV ECX, 0FFFFFFFFH
    XOR AX, AX
    REPNE SCASW
    MOV EAX, 0FFFFFFFEH
    SUB EAX, ECX
    MOV EDI, EDX
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function GetCharHTMLCode(ch: TRVAnsiChar;
  var prevspace, specialcode: Boolean; last: Boolean): TRVAnsiString;
begin
  if specialcode then begin
    Result := ch;
    prevspace := False;
    exit;
  end;
  if ch='&' then begin
    Result := '&amp;';
    prevspace := False;
    end
  else if ch='<' then begin
    Result := '&lt;';
    prevspace := False;
    end
  else if ch='>' then begin
    Result := '&gt;';
    prevspace := False;
    end
  else if ch=' ' then begin
    if prevspace or last then begin
      Result := '&nbsp;';
      prevspace := False;
      end
    else begin
      Result := ch;
      prevspace := True;
      end
    end
  else begin
    Result := ch;
    prevspace := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure RVU_WriteHTMLEncodedUnicode(Stream: TStream; const s: TRVRawByteString;
  NoEmptyLines,SpecialCode, NextSpace:Boolean);
var p: PWord;
    chars: TRVAnsiString;
    i: Integer;
    prevspace: Boolean;
    Len: Integer;
begin
  if (Length(s)=0) and NoEmptyLines then begin
    chars := '&nbsp;';
    Stream.WriteBuffer(PRVAnsiChar(chars)^,Length(chars));
  end;
  prevspace := True;
  p := PWord(PRVAnsiChar(s));
  Len := Length(s) div 2;
  for i := 1 to Len do begin
    if (p^<128) then
      chars := GetCharHTMLCode(TRVAnsiChar(p^), prevspace, SpecialCode, NextSpace and (i=Len))
    else begin
      chars := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('&#%d;',[p^]);
      prevspace := False;
    end;
    Stream.WriteBuffer(PRVAnsiChar(chars)^,Length(chars));
    inc(PRVAnsiChar(p),2);
  end;
end;
{------------------------------------------------------------------------------}
function RVU_GetHTMLEncodedUnicode(const s: TRVRawByteString;
  SpecialCode, NextSpace:Boolean): TRVAnsiString;
var p: PWord;
    i, Len: Integer;
    prevspace: Boolean;
begin
  prevspace := False;
  Result := '';
  p := PWord(PRVAnsiChar(s));
  Len := Length(s) div 2;
  for i := 1 to Len do begin
    if (p^<128) then
      Result := Result+GetCharHTMLCode(TRVAnsiChar(p^), prevspace,SpecialCode, NextSpace and (i=Len))
    else if p^=160 then
      Result := Result+'&nbsp;'
    else begin
      Result := Result+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('&#%d;',[p^]);
      prevspace := False;
    end;
    inc(PRVAnsiChar(p),2);
  end;
end;
{------------------------------------------------------------------------------}
function GetHTMLEntity(ch: Char): TRVAnsiString;
begin
  case ch of
    '&':
      Result := '&amp;';
    '<':
      Result := '&lt;';
    '>':
      Result := '&gt;';
    RVCHAR_NBSP:
      Result := '&nbsp;';
    else
      Result := '';
  end;
end;
{------------------------------------------------------------------------------}
function RVU_GetHTMLUTF8EncodedUnicode(const s: TRVRawByteString;
  SpecialCode, NextSpace:Boolean): TRVRawByteString;
{$IFDEF RICHVIEWCBDEF3}
var p: PWord;
    i, Len, SeqLen: Integer;
    prevspace: Boolean;
    {....................................}
    procedure AddUTF8(var res: TRVRawByteString);
    var ws: TRVUnicodeString;
    begin
      SetLength(ws, SeqLen);
      Move((PRVAnsiChar(p)-SeqLen*2)^, PWideChar(ws)^, SeqLen*2);
      res := res+UTF8Encode(ws);
      SeqLen := 0;
    end;
    {....................................}
{$ENDIF}
begin
{$IFDEF RICHVIEWCBDEF3}
  if SpecialCode then begin
    Result := UTF8Encode(RVU_RawUnicodeToWideString(s));
    exit;
  end;
  prevspace := False;
  Result := '';
  p := PWord(PRVAnsiChar(s));
  Len := Length(s) div 2;
  SeqLen := 0;
  for i := 1 to Len do begin
    case p^ of
      ord('&'), ord('<'), ord('>'), 160:
        begin
          if SeqLen>0 then
            AddUTF8(Result);
          Result := Result+GetHTMLEntity(Chr(p^));
          prevspace := False;
        end;
      ord(' '):
        begin
          if prevspace or (NextSpace and (i=Len)) then begin
            if SeqLen>0 then
              AddUTF8(Result);
            Result := Result+'&nbsp;';
            prevspace := False;
            end
          else begin
            inc(SeqLen);
            prevspace := True;
          end;
        end;
      else
        begin
          inc(SeqLen);
          prevspace := False;
        end;
    end;
    inc(PRVAnsiChar(p),2);
  end;
  if SeqLen>0 then
    AddUTF8(Result);
{$ELSE}
  Result :=RVU_GetHTMLEncodedUnicode(s, SpecialCode);
{$ENDIF}
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function RV_ReturnProcessedStringEx(const s: TRVRawByteString; TextStyle: TFontInfo;
  LastOnLine, ShowSpecialChars, ForDisplay: Boolean;
  var SelOffs1, SelOffs2: Integer): TRVRawByteString;
{$IFNDEF RVDONOTUSESOFTHYPHENS}
{$IFNDEF RVDONOTUSEUNICODE}
var i, len: Integer;
    Changed: Boolean;
{$ENDIF}
{$ENDIF}
begin
  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
  if not (rvscSoftHyphen in RVVisibleSpecialCharacters) then
    ShowSpecialChars := False;
  {$ENDIF}
  {$ENDIF}
  {$IFNDEF RVDONOTUSEALLCAPS}
  if rvfsAllCaps in TextStyle.StyleEx then begin
    {$IFNDEF RVDONOTUSEUNICODE}
    if TextStyle.Unicode then begin
      if RVNT then begin
        SetString(Result, PRVAnsiChar(s), Length(s));
        CharUpperBuffW(Pointer(Result), Length(s) div 2);
        end
      else
        Result := s;
      end
    else
   {$ENDIF}
     Result := {$IFDEF RICHVIEWDEF2009}AnsiStrings.{$ENDIF}AnsiUpperCase(s);
   end
  else
    Result := s;
  {$ELSE}
  Result := s;
  {$ENDIF}
  {$IFNDEF RVDONOTUSESOFTHYPHENS}
  {$IFNDEF RVDONOTUSEUNICODE}
  if TextStyle.Unicode then begin
    Changed := False;
    len := (Length(Result) div 2);
    for i := 0 to len-1 do
      if PRVWordArray(PRVAnsiChar(Result))[i]=UNI_NON_BREAKING_HYPHEN then begin
        if not Changed then begin
          SetLength(Result, Length(Result));
          Changed := True;
        end;
         PRVWordArray(PRVAnsiChar(Result))[i] := UNI_HYPHEN;
        end
      else if (PRVWordArray(PRVAnsiChar(Result))[i]=UNI_SOFT_HYPHEN) and
        not (LastOnLine and not ShowSpecialChars and (i=len-1)) then begin
        if not Changed then begin
          SetLength(Result, Length(Result));
          Changed := True;
        end;
        if ShowSpecialChars then
          PRVWordArray(PRVAnsiChar(Result))[i] := UNI_NOT_SIGN
        else
          PRVWordArray(PRVAnsiChar(Result))[i] := UNI_ZERO_WIDTH_SPACE;
      end;
    if ForDisplay then
      for i := (Length(Result) div 2)-1 downto 0 do
        if (PRVWordArray(PRVAnsiChar(Result))[i]=UNI_ZERO_WIDTH_SPACE) or
           {(PRVWordArray(PRVAnsiChar(Result))[i]=UNI_ZERO_WIDTH_JOINER) or}
           (PRVWordArray(PRVAnsiChar(Result))[i]=UNI_WORD_JOINER) then begin
          if not Changed then begin
            SetLength(Result, Length(Result));
            Changed := True;
          end;
          Delete(Result, i*2+1, 2);
          if SelOffs1-1>i then
            dec(SelOffs1);
          if SelOffs2-1>i then
            dec(SelOffs2);
        end;
  end;
  {$ENDIF}
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function RV_ReturnProcessedString(const s: TRVRawByteString; TextStyle: TFontInfo;
  LastOnLine, ShowSpecialChars, ForDisplay: Boolean): TRVRawByteString;
var a, b: Integer;
begin
  a := 0;
  b := 0;
  Result := RV_ReturnProcessedStringEx(s, TextStyle,
    LastOnLine, ShowSpecialChars, ForDisplay, a, b);
end;
{------------------------------------------------------------------------------}
procedure RVCheckNT;
var vi: TOSVersionInfo;
begin
  vi.dwOSVersionInfoSize := sizeof(vi);
  GetVersionEx(vi);
  RVNT := vi.dwPlatformId=VER_PLATFORM_WIN32_NT;
  RVVista := RVNT and (vi.dwMajorVersion>=6);
  if not RVNT then begin
    RVFORMATCANVASFACTOR := 10;
    RVFORMATCANVASRESOLUTION := 96*RVFORMATCANVASFACTOR;
  end;  
  {
  if RVNT then
    RVDI_GETDRAGIMAGE := RegisterWindowMessage('ShellGetDragImage')
  else
    RVDI_GETDRAGIMAGE := 0;
  }
end;

{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
{$O+}
function GetCharLineBreakClass(Char: Word): TRVLineBreakClass;
begin
  case Char of
    $002D:
      Result := rvu_lb_HY;
    $002F:
      Result := rvu_lb_SY;
    $200B:
      Result := rvu_lb_ZW;
    $2014:
      Result := rvu_lb_B2;
    $2024..$2026:
      Result := rvu_lb_IN;
    $002C,$002E,$003A..$003B,$0589:
      Result := rvu_lb_IS;
    $0024,$00A0,$0F0C,$2007,$2011,$202F,$2060,$FEFF:
      Result := rvu_lb_GL;
    $00B4,$02C8,$02CC,$1806:
      Result := rvu_lb_BB;
    $0009,$007C,$00AD,$058A,$0F0B,$1361,$1680,$17D5,$2000..$2006,$2008..$200A,
    $2010,$2012..$2013,$2027,$205F:
      Result := rvu_lb_BA;
    $0021,$003F,$2762..$2763,$FE56..$FE57,$FF01,$FF1F:
      Result := rvu_lb_EX;
    $0022,$0027,$00AB,$00BB,$2018..$2019,$201B..$201D,$201F,$2039..$203A,$23B6,
    $275B..$275E:
      Result := rvu_lb_QU;
    $002B,$005C,$00A3..$00A5,$00B1,$09F2..$09F3,$0E3F,$17DB,$20A0..$20A6,
    $20A8..$20B1,$2116,$2212..$2213,$FE69,$FF04,$FFE1,$FFE5..$FFE6:
      Result := rvu_lb_PR;
    $0025,$00A2,$00B0,$2030..$2037,$20A7,$2103,$2109,$2126,$FDFC,$FE6A,$FF05,
    $FFE0:
      Result := rvu_lb_PO;
    $0028,$005B,$007B,$0F3A,$0F3C,$169B,$201A,$201E,$2045,$207D,$208D,$2329,
    $23B4,$2768,$276A,$276C,$276E,$2770,$2772,$2774,$27E6,$27E8,$27EA,$2983,
    $2985,$2987,$2989,$298B,$298D,$298F,$2991,$2993,$2995,$2997,$29D8,$29DA,
    $29FC,$3008,$300A,$300C,$300E,$3010,$3014,$3016,$3018,$301A,$301D,$FD3E,
    $FE35,$FE37,$FE39,$FE3B,$FE3D,$FE3F,$FE41,$FE43,$FE59,$FE5B,$FE5D,$FF08,
    $FF3B,$FF5B,$FF5F,$FF62:
      Result := rvu_lb_OP;
    $0029,$005D,$007D,$0F3B,$0F3D,$169C,$2046,$207E,$208E,$232A,$23B5,$2769,
    $276B,$276D,$276F,$2771,$2773,$2775,$27E7,$27E9,$27EB,$2984,$2986,$2988,
    $298A,$298C,$298E,$2990,$2992,$2994,$2996,$2998,$29D9,$29DB,$29FD,
    $3001..$3002,$3009,$300B,$300D,$300F,$3011,$3015,$3017,$3019,$301B,
    $301E..$301F,$FD3F,$FE36,$FE38,$FE3A,$FE3C,$FE3E,$FE40,$FE42,$FE44,
    $FE50,$FE52,$FE5A,$FE5C,$FE5E,$FF09,$FF0C,$FF0E,$FF3D,$FF5D,$FF60..$FF61,
    $FF63..$FF64:
      Result := rvu_lb_CL;
    $0030..$0039,$0660..$0669,$06F0..$06F9,$0966..$096F,$09E6..$09EF,
    $0A66..$0A6F,$0AE6..$0AEF,$0B66..$0B6F,$0BE7..$0BEF,$0C66..$0C6F,
    $0CE6..$0CEF,$0D66..$0D6F,$0E50..$0E59,$0ED0..$0ED9,$0F20..$0F29,
    $1040..$1049,$1369..$1371,$17E0..$17E9,$1810..$1819:
      Result := rvu_lb_NU;
    $0E5A..$0E5B,$17D4,$17D6..$17DA,$203C,$2044,$3005,$301C,$303B..$303C,
    $3041,$3043,$3045,$3047,$3049,$3063,$3083,$3085,$3087,$308E,$3095..$3096,
    $309B..$309E,$30A0..$30A1,$30A3,$30A5,$30A7,$30A9,$30C3,$30E3,$30E5,$30E7,
    $30EE,$30F5..$30F6,$30FB,$30FD,$31F0..$31FF,$FE54..$FE55,$FF1A..$FF1B,
    $FF65,$FF67..$FF70,$FF9E..$FF9F:
      Result := rvu_lb_NS;
    $1100..$1159,$115F,$2E80..$2E99,$2E9B..$2EF3,$2F00..$2FD5,$2FF0..$2FFB,
    $3000,$3003..$3004,$3006..$3007,$3012..$3013,$3020..$3029,$3030..$303A,
    $303D..$303F,$3042,$3044,$3046,$3048,$304A..$3062,$3064..$3082,$3084,
    $3086,$3088..$308D,$308F..$3094,$309F,$30A2,$30A4,$30A6,$30A8,$30AA..$30C2,
    $30C4..$30E2,$30E4,$30E6,$30E8..$30ED,$30EF..$30F4,$30F7..$30FA,$30FC,
    $30FE..$30FF,$3105..$312C,$3131..$318E,$3190..$31B7,$3200..$321C,
    $3220..$3243,$3251..$327B,$327F..$32CB,$32D0..$32FE,$3300..$3376,
    $337B..$33DD,$33E0..$33FE,$3400..$4DB5,$4E00..$9FA5,$A000..$A48C,
    $A490..$A4C6,$AC00..$D7A3,$F900..$FA2D,$FA30..$FA6A,$FE30..$FE34,
    $FE45..$FE46,$FE49..$FE4F,$FE51,$FE58,$FE5F..$FE66,$FE68,$FE6B,
    $FF02..$FF03,$FF06..$FF07,$FF0A..$FF0B,$FF0D,$FF0F..$FF19,$FF1C..$FF1E,
    $FF20..$FF3A,$FF3C,$FF3E..$FF5A,$FF5C,$FF5E,$FFE2..$FFE4:
      Result := rvu_lb_ID;
    $0000..$0008,$000B,$000E..$001F,$007F..$009F,$0300..$034F,$0360..$036F,
    $0483..$0486,$0488..$0489,$0591..$05A1,$05A3..$05B9,$05BB..$05BD,$05BF,
    $05C1..$05C2,$05C4,$064B..$0655,$0670,$06D6..$06E4,$06E7..$06E8,
    $06EA..$06ED,$070F,$0711,$0730..$074A,$07A6..$07B0,$0901..$0903,$093C,
    $093E..$094D,$0951..$0954,$0962..$0963,$0981..$0983,$09BC,$09BE..$09C4,
    $09C7..$09C8,$09CB..$09CD,$09D7,$09E2..$09E3,$0A02,$0A3C,$0A3E..$0A42,
    $0A47..$0A48,$0A4B..$0A4D,$0A70..$0A71,$0A81..$0A83,$0ABC,$0ABE..$0AC5,
    $0AC7..$0AC9,$0ACB..$0ACD,$0B01..$0B03,$0B3C,$0B3E..$0B43,$0B47..$0B48,
    $0B4B..$0B4D,$0B56..$0B57,$0B82,$0BBE..$0BC2,$0BC6..$0BC8,$0BCA..$0BCD,
    $0BD7,$0C01..$0C03,$0C3E..$0C44,$0C46..$0C48,$0C4A..$0C4D,$0C55..$0C56,
    $0C82..$0C83,$0CBE..$0CC4,$0CC6..$0CC8,$0CCA..$0CCD,$0CD5..$0CD6,
    $0D02..$0D03,$0D3E..$0D43,$0D46..$0D48,$0D4A..$0D4D,$0D57,$0D82..$0D83,
    $0DCA,$0DCF..$0DD4,$0DD6,$0DD8..$0DDF,$0DF2..$0DF3,$0E31,$0E34..$0E3A,
    $0E47..$0E4E,$0EB1,$0EB4..$0EB9,$0EBB..$0EBC,$0EC8..$0ECD,$0F18..$0F19,
    $0F35,$0F37,$0F39,$0F3E..$0F3F,$0F71..$0F84,$0F86..$0F87,$0F90..$0F97,
    $0F99..$0FBC,$0FC6,$102C..$1032,$1036..$1039,$1056..$1059,$1160..$11A2,
    $11A8..$11F9,$1712..$1714,$1732..$1734,$1752..$1753,$1772..$1773,
    $17B4..$17D3,$180B..$180E,$18A9,$200C..$200F,$202A..$202E,$206A..$206F,
    $20D0..$20EA,$302A..$302F,$3099..$309A,$FB1E,$FE00..$FE0F,$FE20..$FE23,
    $FFF9..$FFFB:
      Result := rvu_lb_CM;
    else
      Result := rvu_lb_AL;
  end;
end;
{$ENDIF}

{$IFNDEF RICHVIEWDEF6}
{$IFDEF RICHVIEWCBDEF3}
function Utf8ToUnicode(Dest: PRVUnicodeChar; MaxDestChars: Cardinal;
  Source: PRVAnsiChar; SourceBytes: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  if Source = nil then
  begin
    Result := 0;
    Exit;
  end;
  Result := Cardinal(-1);
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceBytes) and (count < MaxDestChars) do
    begin
      wc := Cardinal(Source[i]);
      Inc(i);
      if (wc and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        wc := wc and $3F;
        if (wc and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
          wc := (wc shl 6) or (c and $3F);
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte

        Dest[count] := WideChar((wc shl 6) or (c and $3F));
      end
      else
        Dest[count] := WideChar(wc);
      Inc(count);
    end;
    if count >= MaxDestChars then count := MaxDestChars-1;
    Dest[count] := #0;
  end
  else
  begin
    while (i < SourceBytes) do
    begin
      c := Byte(Source[i]);
      Inc(i);
      if (c and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        c := c and $3F;
        if (c and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte
      end;
      Inc(count);
    end;
  end;
  Result := count+1;
end;

function UnicodeToUtf8(Dest: PRVAnsiChar; MaxDestBytes: Cardinal;
  Source: PRVUnicodeChar; SourceChars: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Cardinal;
begin
  Result := 0;
  if Source = nil then Exit;
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceChars) and (count < MaxDestBytes) do
    begin
      c := Cardinal(Source[i]);
      Inc(i);
      if c <= $7F then
      begin
        Dest[count] := Char(c);
        Inc(count);
      end
      else if c > $7FF then
      begin
        if count + 3 > MaxDestBytes then
          break;
        Dest[count] := Char($E0 or (c shr 12));
        Dest[count+1] := Char($80 or ((c shr 6) and $3F));
        Dest[count+2] := Char($80 or (c and $3F));
        Inc(count,3);
      end
      else //  $7F < Source[i] <= $7FF
      begin
        if count + 2 > MaxDestBytes then
          break;
        Dest[count] := Char($C0 or (c shr 6));
        Dest[count+1] := Char($80 or (c and $3F));
        Inc(count,2);
      end;
    end;
    if count >= MaxDestBytes then count := MaxDestBytes-1;
    Dest[count] := #0;
  end
  else
  begin
    while i < SourceChars do
    begin
      c := Integer(Source[i]);
      Inc(i);
      if c > $7F then
      begin
        if c > $7FF then
          Inc(count);
        Inc(count);
      end;
      Inc(count);
    end;
  end;
  Result := count+1;  // convert zero based index to byte count
end;

function Utf8Decode(const S: TRVRawByteString): TRVUnicodeString;
var
  L: Cardinal;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := Utf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PRVAnsiChar(S), Length(S));
  if L <> Cardinal(-1) then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

function Utf8Encode(const WS: TRVUnicodeString): TRVRawByteString;
var
  L: Integer;
  Temp: TRVAnsiString;
begin
  Result := '';
  if WS = '' then Exit;
  SetLength(Temp, Length(WS) * 3); // SetLength includes space for null terminator

  L := UnicodeToUtf8(PRVAnsiChar(Temp), Length(Temp)+1, PWideChar(WS), Length(WS));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

{$ENDIF}
{$ENDIF}

{

type TRVBiDiClass =
 (
   rvu_bd_BN,  // Boundary neutral (type of RLE etc after explicit levels)
   rvu_bd_S,   // Segment Separator (TAB)
   rvu_bd_B,   // Paragraph Separator
   rvu_bd_WS,  // White space
   rvu_bd_ON,  // Other Neutral
   rvu_bd_ET,  // European Terminator (post/prefix e.g. $ and %)
   rvu_bd_CS,  // Common Separator
   rvu_bd_ES,  // European Separator
   rvu_bd_EN,  // European Number
   rvu_bd_L,   // Left Letter
   rvu_bd_NSM, // Non-spacing Mark
   rvu_bd_R,   // Right Letter
   rvu_bd_AL,  // Arabic Letter (Right-to-left)
   rvu_bd_AN,  // Arabic Number
   rvu_bd_LRE,
   rvu_bd_RLE,
   rvu_bd_RLE,
   rvu_bd_PDF,
   rvu_bd_LRO,
   rvu_bd_RLO
 );

function GetBiDiClass(chr: WideChar): TRVBiDiClass;
begin
  case ord(chr) of
    $0000..$0008,$000E..$001B,$007F..$0084,$0086..$009F,$070F,$180B..$180E,
    $200B..$200D,$206A..$206F,$FEFF,$FFF9..$FFFB:
      Result := rvu_bd_BN;
    $0009,$000B,$001F:
      Result := rvu_bd_S;
    $000A,$000D,$001C..$001E,$0085,$2029:
      Result := rvu_bd_B
    $000C,$0020,$1680,$2000..$200A,$2028,$202F,$3000:
      Result := rvu_bd_WS
    $0021..$0022,$0026..$002A,$003B..$0040,$005B..$0060,$007B..$007E,$00A1,
    $00A6..$00A9,$00AB..$00AF,$00B4,$00B6..$00B8,$00BB..$00BF,$00D7,$00F7,
    $02B9..$02BA,$02C2..$02CF,$02D2..$02DF,$02E5..$02ED,$0374..$0375,
    $037E..$0385,$0387,$058A,$06E9,$0F3A..$0F3D,$169B..$169C,$1800..$180A,
    $1FBD,$1FBF..$1FC1,$1FCD..$1FCF,$1FDD..$1FDF,$1FED..$1FEF,$1FFD..$1FFE,
    $2010..$2027,$2035..$204D,$207C..$207E,$208C..$208E,$2100..$2101,
    $2103..$2106,$2108..$2109,$2114,$2116..$2118,$211E..$2123,$2125,$2127,$2129,
    $2132,$213A..$215F,$2190..$2211,$2214..$2335,$237B..$2394,$2396..$244A,
    $2500..$2FFB,$3001..$3004,$3008..$3020,$3030,$3036..$3037,$303E..$303F,
    $309B..$309C,$30FB,$A490..$A4C6,$FD3E..$FD3F,$FE30..$FE4F,$FE51,$FE54,
    $FE56..$FE5E,$FE60..$FE61,$FE64..$FE68,$FE6B,$FF01..$FF02,$FF06..$FF0A,
    $FF1B..$FF20,$FF3B..$FF40,$FF5B..$FF65,$FFE2..$FFE4,$FFE8..$FFEE,
    $FFFC..$FFFD:
      Result := rvu_bd_ON;
    $0023..$0025,$002B,$002D,$00A2..$00A5,$00B0..$00B1,$066A,$09F2..$09F3,$0E3F,
    $17DB,$2030..$2034,$207A..$207B,$208A..$208B,$20A0..$20AF,$212E,
    $2212..$2213,$FB29,$FE5F,$FE62..$FE63,$FE69..$FE6A,$FF03..$FF05,
    $FF0B,$FF0D,$FFE0..$FFE1,$FFE5..$FFE6:
      Result := rvu_bd_ET;
    $002C,$002E,$003A,$00A0,$060C,$FE50,$FE52,$FE55,$FF0C,$FF0E,$FF1A:
      Result := rvu_bd_CS;
    $002F,$FF0F:
      Result := rvu_bd_ES;
    $0030..$0039,$00B2..$00B3,$00B9,$06F0..$06F9,$2070..$2079,$2080..$2089,
    $2460..$249B,$24EA,$FF10..$FF19:
      Result := rvu_bd_EN;
    $0300..$0362,$0483..$0489,$0591..$05BD,$05BF,$05C1..$05C2,$05C4,
    $064B..$0655,$0670,$06D6..$06E4,$06E7..$06E8,$06EA..$06ED,$0711,
    $0730..$074A,$07A6..$0902,$093C,$0941..$0948,$094D,$0951..$0954,
    $0962..$0963,$0981,$09BC,$09C1..$09C4,$09CD,$09E2..$09E3,$0A02,$0A3C,
    $0A41..$0A4D,$0A70..$0A71,$0A81..$0A82,$0ABC,$0AC1..$0AC8,$0ACD,$0B01,$0B3C,
    $0B3F,$0B41..$0B43,$0B4D..$0B56,$0B82,$0BC0,$0BCD,$0C3E..$0C40,$0C46..$0C56,
    $0CBF,$0CC6,$0CCC..$0CCD,$0D41..$0D43,$0D4D,$0DCA,$0DD2..$0DD6,$0E31,
    $0E34..$0E3A,$0E47..$0E4E,$0EB1,$0EB4..$0EBC,$0EC8..$0ECD,$0F18..$0F19,
    $0F35,$0F37,$0F39,$0F71..$0F7E,$0F80..$0F84,$0F86..$0F87,$0F90..$0FBC,$0FC6,
    $102D..$1030,$1032..$1037,$1039,$1058..$1059,$17B7..$17BD,$17C6,
    $17C9..$17D3,$18A9,$20D0..$20E3,$302A..$302F,$3099..$309A,$FB1E,
    $FE20..$FE23:
      Result := rvu_bd_NSM;
    $05BE,$05C0,$05C3,$05D0..$05F4,$200F,$FB1D,$FB1F..$FB28,$FB2A..$FB4F:
      Result := rvu_bd_R;
    $061B..$064A,$066D,$0671..$06D5,$06E5..$06E6,$06FA..$070D,$0710,
    $0712..$072C,$0780..$07A5,$FB50..$FD3D,$FD50..$FDFB,$FE70..$FEFC:
      Result := rvu_bd_AL;
    $0660..$0669,$066B..$066C:
      Result := rvu_bd_AN;
    $202A:
      Result := rvu_bd_LRE;
    $202B:
      Result := rvu_bd_RLE;
    $202C:
      Result := rvu_bd_PDF;
    $202D:
      Result := rvu_bd_LRO;
    $202E:
      Result := rvu_bd_RLO;
    else
      Result :=  rvu_bd_L;
  end;
end;

}
{------------------------------------------------------------------------------}
function StrPosW(Str, SubStr: Pointer): Pointer;
asm
       PUSH    EDI
       PUSH    ESI
       PUSH    EBX
       OR      EAX, EAX
       JZ      @@2
       OR      EDX, EDX
       JZ      @@2
       MOV     EBX, EAX
       MOV     EDI, EDX
       XOR     AX, AX
       MOV     ECX, 0FFFFFFFFH
       REPNE   SCASW
       NOT     ECX
       DEC     ECX
       JZ      @@2
       MOV     ESI, ECX
       MOV     EDI, EBX
       MOV     ECX, 0FFFFFFFFH
       REPNE   SCASW
       NOT     ECX
       SUB     ECX, ESI
       JBE     @@2
       MOV     EDI, EBX
       LEA     EBX, [ESI - 1]
@@1:
       MOV     ESI, EDX
       LODSW
       REPNE   SCASW
       JNE     @@2
       MOV     EAX, ECX
       PUSH    EDI
       MOV     ECX, EBX
       REPE    CMPSW
       POP     EDI
       MOV     ECX, EAX
       JNE     @@1
       LEA     EAX, [EDI - 2]
       JMP     @@3
@@2:
       XOR     EAX, EAX
@@3:
       POP     EBX
       POP     ESI
       POP     EDI
end;
{------------------------------------------------------------------------------}
function StrPosLW(Str, SubStr: Pointer; StrLen, SubStrLen: Integer): Pointer;
asm
       PUSH    EDI
       PUSH    ESI
       PUSH    EBX
       OR      EAX, EAX
       JZ      @@2
       OR      EDX, EDX
       JZ      @@2
       MOV     EBX, EAX
       MOV     ESI, [ESP+20]
       OR      ESI, ESI
       JZ      @@2
       INC     ECX
       SUB     ECX, ESI
       JBE     @@2
       MOV     EDI, EBX
       LEA     EBX, [ESI - 1]
@@1:
       MOV     ESI, EDX
       LODSW
       REPNE   SCASW
       JNE     @@2
       MOV     EAX, ECX
       PUSH    EDI
       MOV     ECX, EBX
       REPE    CMPSW
       POP     EDI
       MOV     ECX, EAX
       JNE     @@1
       LEA     EAX, [EDI - 2]
       JMP     @@3
@@2:
       XOR     EAX, EAX
@@3:
       POP     EBX
       POP     ESI
       POP     EDI
end;
{------------------------------------------------------------------------------}
{ Converts RawByteString to String. If RawUnicode=True, s contains "raw Unicode",
  otherwise it contains ANSI }
function RVU_RawByteStringToString(const s: TRVRawByteString;
  RawUnicode: Boolean; CodePage: TRVCodePage): String;
{$IFDEF RVUNICODESTR}
var s2: TRVRawByteString;
{$ENDIF}
begin
  {$IFDEF RVUNICODESTR}
  if not RawUnicode then
    s2 := RVU_AnsiToUnicode(CodePage, s)
  else
    s2 := s;
  Result := RVU_RawUnicodeToWideString(s2);
  {$ELSE}
  {$IFNDEF RVDONOTUSEUNICODE}
  if RawUnicode then
    Result := RVU_UnicodeToAnsi(CodePage, s)
  else
  {$ENDIF}
    Result := s;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function RVU_StringToRawByteString(const s: String; RawUnicode: Boolean;
  CodePage: TRVCodePage): TRVRawByteString;
begin
  {$IFDEF RVUNICODESTR}
  Result := RVU_GetRawUnicode(s);
  if not RawUnicode then
    Result := RVU_UnicodeToAnsi(CodePage, Result);
  {$ELSE}
  {$IFNDEF RVDONOTUSEUNICODE}
  if RawUnicode then
    Result := RVU_AnsiToUnicode(CodePage, s)
  else
  {$ENDIF}
    Result := s;
  {$ENDIF}
end;

initialization
  RVCheckNT


end.
