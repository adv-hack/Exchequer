
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Miscellaneous procedures.                       }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVFuncs;

interface

{$I RV_Defs.inc}

uses {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     SysUtils, Windows, Classes, RVStyle, RVStr,
     {$IFNDEF RVDONOTUSEJPEGIMAGE}
     Jpeg,
    {$ENDIF}
     Graphics, RVTypes, RVGrIn;

{$IFDEF RVNORANGECHECK}
{$R-}
{$ENDIF}

const
  { Number of pixels in the screen inch. If 0 (default) - use screen resolution.
    Affects converting pixels to mm, inches, twips and vice versa:
    printing, RTF.
    Main possible values: 96 (small font mode), 120 (large font mode). }
  RichViewPixelsPerInch : Integer = 0;
  { Floating point precision }
  RVEps = 1e-20;

{---------------------------  Text & Tags  ------------------------------------}

function RV_CopyTag(SourceTag: Integer; TagsArePChars: Boolean): Integer;
function RV_CompareTags(Tag1, Tag2: Integer; TagsArePChars: Boolean): Boolean;
function RV_ReplaceTabsA(const s: TRVAnsiString; SpacesInTab: Integer): TRVAnsiString;
function RV_ReplaceTabsW(const s: TRVRawByteString; SpacesInTab: Integer): TRVRawByteString;
function RV_CharPos(const Str: PRVAnsiChar; Chr: TRVAnsiChar; Length: Integer): Integer; assembler;
procedure RV_ReplaceStrA(var str: TRVAnsiString; oldstr, newstr: TRVAnsiString);
procedure RV_ReplaceStr(var str: String; oldstr, newstr: String);
function RV_GetHintStr(DocFormat: TRVSaveFormat; const Hint: String): String;
function RV_GetOutlineTextMetrics(Canvas: TCanvas;
  GraphicInterface: TRVGraphicInterface): POutlineTextmetric;
function RV_GetDefSubSuperScriptSize(NormalSize: Integer): Integer;
function RV_GetDefSubSuperScriptSizeRev(ScriptSize: Integer): Integer;
function RV_IntToRoman(Value: Integer): String;
function RV_IntToAlpha(Value: Integer): String;
{--------------------------  HTML functions  ----------------------------------}

function RV_GetHTMLRGBStr(Color: TColor; Quotes: Boolean): TRVAnsiString;
function RV_GetHTMLRGBStr2(Color: TColor; Quotes: Boolean): String;
function RV_GetCSSBkColor(Color: TColor): TRVAnsiString;
function RV_GetHTMLPath(const Path: String): String;
function RV_GetHTMLFontCSS(Font: TFont; UseFontName: Boolean): String;
function RV_HTMLGetFontSize(pts: Integer): Integer;
function RV_HTMLOpenFontTag(ts, normalts: TFontInfo; Relative: Boolean;
  SaveOptions: TRVSaveOptions): String;
function RV_HTMLOpenFontTag2(fnt: TFont; normalts: TFontInfo; UseFontName: Boolean;
  SaveOptions: TRVSaveOptions): String;
function RV_HTMLCloseFontTag(ts: TFontInfo; normalts: TFontInfo; Relative: Boolean):TRVAnsiString;
function RV_HTMLCloseFontTag2(fnt: TFont; normalts: TFontInfo;
  UseFontName: Boolean):TRVAnsiString;
{$IFNDEF RVDONOTUSEHTML}
function RV_MakeHTMLSymbolStr(const s: String): TRVAnsiString;
function RV_MakeHTMLSymbolStrA(const s: TRVAnsiString): TRVAnsiString;
function RV_MakeHTMLSymbolStrRaw(const s: TRVRawByteString): TRVAnsiString;
function RV_MakeHTMLStr(const str:TRVAnsiString; SpecialCode, NextSpace:Boolean): TRVAnsiString;
function RV_MakeHTMLValueStr(const str:String): String;
{$IFDEF RICHVIEWCBDEF3}
function RV_CharSet2HTMLLang(CharSet: TFontCharset): TRVAnsiString;
{$ENDIF}
{$ENDIF}
function RV_DecodeURL(const s: String; DecodeLineBreaks: Boolean): String;
function RV_HTMLGetEndingSlash(SaveOptions: TRVSaveOptions): TRVAnsiString;
function RV_HTMLGetNoValueAttribute(const Attr: TRVAnsiString;
  SaveOptions: TRVSaveOptions): TRVAnsiString;
function RV_HTMLGetIntAttrVal(Value: Integer; SaveOptions: TRVSaveOptions): TRVAnsiString;
function RV_HTMLGetIntAttrVal2(Value: Integer; SaveOptions: TRVSaveOptions): String;
function RV_HTMLGetStrAttrVal(const Value: TRVAnsiString;
  SaveOptions: TRVSaveOptions): TRVAnsiString;

{--------------------------  RTF functions  -----------------------------------}

{$IFNDEF RVDONOTUSERTF}
function RVMakeRTFStr(const s:TRVAnsiString;
  SpecialCode, UseNamedEntities, RTFControlsToCodes: Boolean): TRVAnsiString;
{$IFDEF RICHVIEWCBDEF3}
{$IFNDEF RVDONOTUSEUNICODE}
function RVMakeRTFStrW(const s: TRVUnicodeString; CodePage: TRVCodePage;
  SaveAnsi, ForceSaveAnsi, SpecialCode, RTFControlsToCodes: Boolean): TRVAnsiString;
{$ENDIF}
{$ENDIF}
function RVMakeRTFFileNameStr(const s: String; CodePage: TRVCodePage;
  SaveAnsi: Boolean): TRVAnsiString;
function MakeRTFIdentifierStr(const s:String; CodePage: TRVCodePage;
  SaveAnsi: Boolean): TRVAnsiString;
function MakeRTFBookmarkNameStr(const s:String): String;
procedure RVWriteUnicodeRTFStr(Stream: TStream; const s: TRVRawByteString;
  CodePage: TRVCodePage; SaveAnsi, ForceSaveAnsi, SpecialCode, DoubleBSlashes,
  RTFControlsToCodes: Boolean);
{$ENDIF}

{-------------------------- URL Detection -------------------------------------}

{ Assign your function to RVIsCustomURL, if you want to process your own
  types of URL }
type
  TCustomRVIsURLFunction = function (const Word: String): Boolean;
const
  RVIsCustomURL: TCustomRVIsURLFunction = nil;

function RVIsURL(const s: String): Boolean;
function RVIsEmail(const s: String): Boolean;

{----------------------  Conversion of coordinates  ---------------------------}

function RV_XToDevice(X: Integer; const sad: TRVScreenAndDevice): Integer;
function RV_YToDevice(Y: Integer; const sad: TRVScreenAndDevice): Integer;
function RV_XToScreen(X: Integer; const sad: TRVScreenAndDevice): Integer;
function RV_YToScreen(Y: Integer; const sad: TRVScreenAndDevice): Integer;
procedure RV_RectToScreen(var R: TRect; const sad: TRVScreenAndDevice);
procedure RV_InfoAboutSaD(var sad:TRVScreenAndDevice; Canvas: TCanvas;
  GraphicInterface: TRVGraphicInterface);
function RV_GetPixelsPerInch: Integer;
function RV_PointInRect(X,Y: Integer; Left,Top,Width,Height: Integer): Boolean;

{--------------------------  Conversion of units  -----------------------------}

function RV_UnitsPerInch(Units: TRVUnits): TRVLength;
function RV_UnitsToTwips(Value: TRVLength; Units: TRVUnits): Integer;
function RV_TwipsToUnits(Value: Integer; Units: TRVUnits): TRVLength;

{------------------------  Graphics & Colors  ---------------------------------}

function RV_CreateGraphicsDefault(GraphicClass: TGraphicClass): TGraphic;
procedure RV_AfterImportGraphicDefault(Graphic: TGraphic);
function RV_GetLuminance(Color: TColor): Integer;
function RV_GetGray(Color: TColor): TColor;
function RV_GetPrnColor(Color: TColor): TColor;
function RV_GetColor(Color: TColor; ColorMode: TRVColorMode): TColor;
function RV_GetBackColor(Color: TColor; ColorMode: TRVColorMode): TColor;
function RV_IsGraphicTransparent(gr: TGraphic): Boolean;
procedure RV_SetPaletteToPicture(gr: TGraphic; PLogPal: PLogPalette);
procedure RV_PictureToDevice(Canvas: TCanvas; x,y, width, height: Integer;
  sad: PRVScreenAndDevice; gr: TGraphic; ToScreen: Boolean;
  GraphicInterface: TRVGraphicInterface);
procedure ShadeRectangle(Canvas: TCanvas; const R: TRect; Color: TColor);
type TRVLineStyle =
  (rvlsNormal,
   rvlsRoundDotted,
   rvlsDotted,
   rvlsDashed,
   rvlsDashDotted,
   rvlsDashDotDotted,
   rvlsHidden
   );
procedure RVDrawCustomHLine(Canvas: TCanvas; Color: TColor; LineStyle: TRVLineStyle;
  LineWidth, Left, Right, Y, PeriodLength: Integer;
  GraphicInterface: TRVGraphicInterface);
function RVGetDefaultUnderlineWidth(FontSize: Integer): Integer;
procedure RVDrawLineBetweenRects(Left1, Top1, Width1, Height1,
  Left2, Top2, Width2, Height2: Integer; Canvas: TCanvas;
  GraphicInterface: TRVGraphicInterface);

procedure RV_PictureToDeviceAlt(Canvas: TCanvas; X, Y,
  PrintWidth, PrintHeight: Integer; gr: TBitmap);
procedure RV_BltTBitmapAsDib(DestDc : hdc; X, Y, PrintWidth, PrintHeight: Integer;
  bm : TBitmap);

{ ---------------------------- Others -----------------------------------------}
function RVExtractDomain(const URL: String): String;
function RVExtractDomainOrDrive(const Path: String): String;
function RVExtractRelativePath(const BaseName, DestName: String): string;
procedure RV_AddStrA(var s1: TRVAnsiString; const s2: TRVAnsiString);
procedure RV_AddStrExA(var s1: TRVAnsiString; const s2, Delimiter: TRVAnsiString);
procedure RV_AddStr(var s1: String; const s2: String);
procedure RV_AddStrEx(var s1: String; const s2, Delimiter: String);
function RV_Sign(Value: Integer): Integer;

type
  TRV_CreateGraphicsFunction = function (GraphicClass: TGraphicClass): TGraphic;
  TRV_AfterImportGraphicsProc = procedure(Graphic: TGraphic);
var
  { Procedure for creating graphic object by graphic class
    used as a workaround for D2-D5, CB1-CB5 bug (private constructor in
    TGraphic). Assign your own procedure if you use third-party graphic
    classes }
  RV_CreateGraphics: TRV_CreateGraphicsFunction;
  { Procedure for calling after importing external graphics from RTF documents }
  RV_AfterImportGraphic: TRV_AfterImportGraphicsProc;

  { If set to True, alternative picture printing procedure will be used.
    The alt procedure is less reliable, but does not rely on screen DC. }
  RichViewAlternativePicPrint: Boolean = False;

implementation

uses RVFMisc, RVUni, CRVData, Forms;

type SetOfChar = set of TRVAnsiChar;

{ Simplifies call to GetOutlineTextMetrics.
  Returns pointer to TOutlineTextmetric allocated by GetMem. Nil if failed }
function RV_GetOutlineTextMetrics(Canvas: TCanvas; GraphicInterface: TRVGraphicInterface): POutlineTextmetric;
var sz: Cardinal;
begin
  Result := nil;
  sz := GraphicInterface.GetOutlineTextMetrics(Canvas, 0, nil);
  if sz=0 then
    exit;
  GetMem(Result, sz);
  FillChar(Result^, sz, 0);
  GraphicInterface.GetOutlineTextMetrics(Canvas, sz, Result);
  if Result.otmsUnderscoreSize=0 then
    Result.otmsUnderscoreSize := 1;
end;


//procedure ReplaceCharsAnsi(var str: TRVAnsiString; Replacer: TRVAnsiChar;
//  Replaced: SetOfChar); forward;
procedure ReplaceChars(var str: String; Replacer: Char;
  Replaced: SetOfChar); forward;

{===========================  Text & Tags  ====================================}
{ Returns a copy of SourceTag. If TagsArePChars, it assumes that SourceTag is
  a pointer to ANSIZ string, creates a copy of this string and returns it      }
function RV_CopyTag(SourceTag: Integer; TagsArePChars: Boolean): Integer;
begin
  if (SourceTag<>0) and TagsArePChars then
    Result := Integer(StrNew(PChar(SourceTag)))
  else
    Result := SourceTag;
end;
{------------------------------------------------------------------------------}
{ Returns true if Tag1 is equal to Tag2. If TagsArePChars, tags are compared
  as strings, otherwise as integers                                            }
function RV_CompareTags(Tag1, Tag2: Integer; TagsArePChars: Boolean): Boolean;
begin
  if TagsArePChars then
    if (Tag1=0) then
      if (Tag2=0) then
        Result := True
      else
        Result := False
    else
      if (Tag2=0) then
        Result := False
      else
        Result := StrComp(PChar(Tag1),PChar(Tag2))=0
  else
    Result := Tag1=Tag2;
end;
{------------------------------------------------------------------------------}
{ Replaces all tabs (#9) with a sequence of SpacesInTab space characters       }
function RV_ReplaceTabsA(const s: TRVAnsiString; SpacesInTab: Integer): TRVAnsiString;
var p: Integer;
    spaces: TRVAnsiString;
begin
  Result := s;
  p := RVPos(#9,Result);
  if p<>0 then begin
    SetLength(spaces,SpacesInTab);
    FillChar(PRVAnsiChar(spaces)^, SpacesInTab, ' ');
  end;
  while p<>0 do begin
    Delete(Result,p,1);
    Insert(spaces,Result,p);
    p := RVPos(#9,Result);
  end;
end;
{------------------------------------------------------------------------------}
{ The same for unicode string (represented as "raw unicode")                   }
function CharPosW(str: PRVUnicodeChar; Len: Integer; ch: TRVUnicodeChar): Integer;
var i: Integer;
begin
  if str <> nil then
    for i := 0 to Len do
      if ch=str[i] then begin
        Result := i*2+1;
        exit;
      end;
  Result := 0;
end;

function RV_ReplaceTabsW(const s: TRVRawByteString; SpacesInTab: Integer): TRVRawByteString;
var i,p: Integer;
    spaces: TRVRawByteString;
begin
  Result := s;
  p := CharPosW(PRVUnicodeChar(Pointer(Result)), Length(Result) div 2, #9);
  if p<>0 then begin
    SetLength(spaces,SpacesInTab*2);
    FillChar(PRVAnsiChar(spaces)^, SpacesInTab*2, 0);
    for i := 1 to SpacesInTab do
      spaces[(i-1)*2+1] := ' ';
  end;
  while p<>0 do begin
    Delete(Result,p,2);
    Insert(spaces,Result,p);
    p := CharPosW(PRVUnicodeChar(Pointer(Result)), Length(Result) div 2, #9);
  end;
end;
{------------------------------------------------------------------------------}
{ Returns index of character (Chr) in string (Str) having length Length.
  Returns 0 if not found. Otherwise index of the first occurence of the character
  (1-based).                                                                   }
function RV_CharPos(const Str: PRVAnsiChar {EAX}; Chr: TRVAnsiChar {DL} ;
  Length: Integer {ECX}): Integer; assembler;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EDI
        PUSH    EBX
        MOV     EDI,Str
        MOV     EBX,Str
        MOV     AL,Chr
        REPNE   SCASB
        MOV     EAX,0
        JNE     @@1
        MOV     EAX,EDI
        SUB     EAX,EBX
@@1:    POP     EBX
        POP     EDI
@@2:
end;
{------------------------------------------------------------------------------}
{ Replaces in str all substrings oldstr with substring newstr.
  Case insensitive. Newstr CANNOT contain oldstr as a substring.               }
procedure RV_ReplaceStr(var str: String; oldstr, newstr: String);
var p: Integer;
begin
   while True do begin
     p := Pos(oldstr, str);
     if p=0 then
       break;
     Delete(str,p, Length(oldstr));
     Insert(newstr, str, p);
   end;
end;

procedure RV_ReplaceStrA(var str: TRVAnsiString; oldstr, newstr: TRVAnsiString);
var p: Integer;
begin
   while True do begin
     p := RVPos(oldstr, str);
     if p=0 then
       break;
     Delete(str,p, Length(oldstr));
     Insert(newstr, str, p);
   end;
end;
{------------------------------------------------------------------------------}
{ Replaces in str all substrings oldstr with substring newstr.
  Case insensitive. Newstr can contain oldstr as a substring.                  }
procedure RV_ReplaceStr2A(var str: TRVAnsiString; const oldstr, newstr: TRVAnsiString);
var p,ptr: Integer;
    s: TRVAnsiString;
begin
   s := str;
   ptr := 1;
   while true do begin
     p := RVPos(oldstr, s);
     if p=0 then
       break;
     inc(p, ptr-1);
     Delete(str,p, Length(oldstr));
     Insert(newstr, str, p);
     ptr := p+Length(newstr);
     s := Copy(str, ptr, Length(str)+1-ptr);
   end;
end;
{------------------------------------------------------------------------------}
procedure RV_ReplaceStr2(var str: String; const oldstr, newstr: String);
var p,ptr: Integer;
    s: String;
begin
   s := str;
   ptr := 1;
   while true do begin
     p := Pos(oldstr, s);
     if p=0 then
       break;
     inc(p, ptr-1);
     Delete(str,p, Length(oldstr));
     Insert(newstr, str, p);
     ptr := p+Length(newstr);
     s := Copy(str, ptr, Length(str)+1-ptr);
   end;
end;
{------------------------------------------------------------------------------}
{ Returns code for inserting hint (tool tip) in HTML and RTF                   }
function RV_GetHintStr(DocFormat: TRVSaveFormat; const Hint: String): String;
begin
  Result := Hint;
  if Result='' then
    exit;
  case DocFormat of
    rvsfHTML:
      begin
        {$IFNDEF RVDONOTUSEHTML}
        Result := 'title="'+RV_MakeHTMLValueStr(Result)+'"';
        {$ENDIF}
      end;
    rvsfRTF:
      begin
        {$IFNDEF RVDONOTUSERTF}
        ReplaceChars(Result , '''', ['"']);
        Result := '\o "'+Result+'"';
        {$ENDIF}
      end;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns subscript (or superscript) size for the given normal text size.
  (does not used for text drawing) }
function RV_GetDefSubSuperScriptSize(NormalSize: Integer): Integer;
begin
  if (NormalSize mod 3) = 0 then
    Result := (NormalSize div 3) * 2
  else if ((NormalSize+1) mod 3) = 0 then
    Result := ((NormalSize+1) div 3) * 2 - 1
  else
    Result := ((NormalSize+2) div 3) * 2 - 1;
end;
{------------------------------------------------------------------------------}
{ Reverse function to RV_GetDefSubSuperScriptSize }
function RV_GetDefSubSuperScriptSizeRev(ScriptSize: Integer): Integer;
begin
  if (ScriptSize mod 2) = 0 then
    Result := ScriptSize + (ScriptSize div 2)
  else
    Result := ScriptSize + ((ScriptSize+1) div 2);
end;
{------------------------------------------------------------------------------}
{ Returns Roman number }
function RV_IntToRoman(Value: Integer): String;
const
  Arabics: Array[0..12] of Integer =
    (1,4,5,9,10,40,50,90,100,400,500,900,1000);
  Romans:  Array[0..12] of String =
    ('I','IV','V','IX','X','XL','L','XC','C','CD','D','CM','M');
var i: Integer;
begin
  if Value<1 then begin
    Result := '?';
    exit;
  end;
  Result := '';
  for i := 12 downto 0 do
    while (Value >= Arabics[i]) do begin
      Value := Value - Arabics[i];
      Result := Result + Romans[i];
    end;
end;
{------------------------------------------------------------------------------}
{ Returns string in the sequence A, B, ..., Y, Z, AA, AB, ... }
function RV_IntToAlpha(Value: Integer): String;
const CharCount = ord('Z')-ord('A')+1;
begin
  Result := '';
  while Value>0 do begin
    Result := Chr((Value-1) mod CharCount+ord('A'))+Result;
    Value := (Value-1) div CharCount;
  end;
end;
{==========================  HTML functions  ==================================}
{ Returns HTML representation of color ('#RRGGBB' string).
  For clNone, returns empty string.
  Processes clWindowText as clBlack.                                           }
function RV_GetHTMLRGBStr(Color: TColor; Quotes: Boolean): TRVAnsiString;
begin
  if Color=clWindowText then
    Color := clBlack;
  if Color=clNone then
    Result := ''
  else begin
    Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}LowerCase(RVIntToHex(ColorToRGB(Color) and $FFFFFF,6));
    Result := '#'+System.Copy(Result,5,2)+System.Copy(Result,3,2)+System.Copy(Result,1,2);
    if Quotes then
      Result := '"'+Result+'"';
  end;
end;

function RV_GetHTMLRGBStr2(Color: TColor; Quotes: Boolean): String;
begin
  if Color=clWindowText then
    Color := clBlack;
  if Color=clNone then
    Result := ''
  else begin
    Result := LowerCase(IntToHex(ColorToRGB(Color) and $FFFFFF,6));
    Result := '#'+System.Copy(Result,5,2)+System.Copy(Result,3,2)+System.Copy(Result,1,2);
    if Quotes then
      Result := '"'+Result+'"';
  end;
end;
{------------------------------------------------------------------------------}
{ The same as RV_GetHTMLRGBStr, but returns 'transparent' for clNone           }
function RV_GetCSSBkColor(Color: TColor): TRVAnsiString;
begin
  if Color=clNone then
    Result := 'transparent'
  else
    Result := RV_GetHTMLRGBStr(Color, False);
end;
{------------------------------------------------------------------------------}
{ Replaces all '\' with '/'                                                    }
function RV_GetHTMLPath(const Path: String): String;
var i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
    if Result[i]='\' then
      Result[i] := '/';
end;
{------------------------------------------------------------------------------}
{ Special concatenation of two strings                                         }
procedure RV_AddStrEx(var s1: String; const s2, Delimiter: String);
begin
  if s1<>'' then begin
    if s2<>'' then
      s1 := s1+Delimiter+s2
    end
  else
    s1 := s2;
end;

procedure RV_AddStr(var s1: String; const s2: String);
begin
  RV_AddStrEx(s1, s2, ' ');
end;

procedure RV_AddStrExA(var s1: TRVAnsiString; const s2, Delimiter: TRVAnsiString);
begin
  if s1<>'' then begin
    if s2<>'' then
      s1 := s1+Delimiter+s2
    end
  else
    s1 := s2;
end;

procedure RV_AddStrA(var s1: TRVAnsiString; const s2: TRVAnsiString);
begin
  RV_AddStrExA(s1, s2, ' ');
end;
{------------------------------------------------------------------------------}
{ Returns string describing the given font in CSS format                       }
function RV_GetHTMLFontCSS(Font: TFont; UseFontName: Boolean): String;
var s: String;
begin
  Result := '';
  if fsBold in Font.Style then
    Result := 'font-weight: bold;';
  if fsItalic in Font.Style then
    RV_AddStr(Result, 'font-style: italic;');
  if Font.Size>0 then
    RV_AddStr(Result, Format('font-size: %dpt;',[Font.Size]))
  else
    RV_AddStr(Result, Format('font-size: %dpx;',[Font.Height]));
  if UseFontName then begin
    s := ''''+Font.Name+'''';
    if (AnsiCompareText(Font.Name, RVFONT_SYMBOL)=0) or
       (AnsiCompareText(Font.Name, RVFONT_WINGDINGS)=0) then
      s := '''Arial Unicode MS'', ''Lucida Sans Unicode'', ''Arial''';
    RV_AddStr(Result, Format('font-family: %s;',[s]));
  end;
  s := '';
  if fsUnderline in Font.Style then
    s := 'underline';
  if fsStrikeOut in Font.Style then
    RV_AddStr(s, 'line-through');
  if s<>'' then
    Result := Format('%s text-decoration: %s;',[Result,s]);
  Result := Format('%s color: %s;',[Result,RV_GetHTMLRGBStr(Font.Color, False)]);
end;
{------------------------------------------------------------------------------}
{ Converts the font size in points to the font size for HTML (without CSS).
  HTML uses 7 font sizes.                                                      }
function RV_HTMLGetFontSize(pts: Integer): Integer;
begin
  if pts<=8 then
    Result := 1
  else
    case pts of
      9..10:  Result := 2;
      11..12: Result := 3;
      13..14: Result := 4;
      15..18: Result := 5;
      19..24: Result := 6;
      else    Result := 7;
    end;
end;
{------------------------------------------------------------------------------}
{ Returns opening HTML tags for formatting of text style ts.
  If Relative, it returns a difference in formatting between ts and normalts   }
function RV_HTMLOpenFontTag(ts, normalts: TFontInfo; Relative: Boolean;
  SaveOptions: TRVSaveOptions): String;
var s: String;
begin
  s := '';
  if not Relative or (ts.Size<>normalts.Size) then
    s := s+' size='+RV_HTMLGetIntAttrVal2(RV_HTMLGetFontSize(ts.Size), SaveOptions);
  if not Relative or (ts.Color<>normalts.Color) then
    s := s+' color='+RV_GetHTMLRGBStr2(ts.Color, True);
  if not Relative or (AnsiCompareText(ts.FontName,normalts.FontName)<>0) then
    s := s+' face="'+ts.FontName+'"';
  if s<>'' then
    s := '<font'+s+'>';
  if Relative then begin
    if not (fsStrikeOut in ts.Style) and (fsStrikeOut in normalts.Style) then s := s+'</s>';
    if not (fsUnderline in ts.Style) and (fsUnderline in normalts.Style) then s := s+'</u>';
    if not (fsItalic    in ts.Style) and (fsItalic    in normalts.Style) then s := s+'</i>';
    if not (fsBold      in ts.Style) and (fsBold      in normalts.Style) then s := s+'</b>';
    if (fsBold      in ts.Style) and not (fsBold      in normalts.Style) then s := s+'<b>';
    if (fsItalic    in ts.Style) and not (fsItalic    in normalts.Style) then s := s+'<i>';
    if (fsUnderline in ts.Style) and not (fsUnderline in normalts.Style) then s := s+'<u>';
    if (fsStrikeOut in ts.Style) and not (fsStrikeOut in normalts.Style) then s := s+'<s>';
    end
  else begin
    if (fsBold in ts.Style)      then s := s+'<b>';
    if (fsItalic in ts.Style)    then s := s+'<i>';
    if (fsUnderline in ts.Style) then s := s+'<u>';
    if (fsStrikeOut in ts.Style) then s := s+'<s>';
  end;
  case ts.SubSuperScriptType of
    rvsssSubscript:
      s := s+'<sub>';
    rvsssSuperScript:
      s := s+'<sup>';
    rvsssNormal:
      if ts.VShift < 0 then
        s := s+'<sub>'
      else if ts.VShift > 0 then
        s := s+'<sup>';
  end;
  Result := s;
end;
{------------------------------------------------------------------------------}
{ The same as RV_HTMLOpenFontTag(..., True), but formatting is defined by
  fnt: TFont                                                                   }
function RV_HTMLOpenFontTag2(fnt: TFont; normalts: TFontInfo;
  UseFontName: Boolean; SaveOptions: TRVSaveOptions): String;
var s: String;
begin
  s := '';
  if (fnt.Size<>normalts.Size) then
    s := s+' size='+RV_HTMLGetIntAttrVal2(RV_HTMLGetFontSize(fnt.Size), SaveOptions);
  if (fnt.Color<>normalts.Color) then
    s := s+' color='+RV_GetHTMLRGBStr2(fnt.Color, True);
  if UseFontName and (AnsiCompareText(fnt.Name,normalts.FontName)<>0) then
    s := s+' face="'+fnt.Name+'"';
  if s<>'' then
    s := '<font'+s+'>';
  if not (fsStrikeOut in fnt.Style) and (fsStrikeOut in normalts.Style) then s := s+'</s>';
  if not (fsUnderline in fnt.Style) and (fsUnderline in normalts.Style) then s := s+'</u>';
  if not (fsItalic    in fnt.Style) and (fsItalic    in normalts.Style) then s := s+'</i>';
  if not (fsBold      in fnt.Style) and (fsBold      in normalts.Style) then s := s+'</b>';
  if (fsBold      in fnt.Style) and not (fsBold      in normalts.Style) then s := s+'<b>';
  if (fsItalic    in fnt.Style) and not (fsItalic    in normalts.Style) then s := s+'<i>';
  if (fsUnderline in fnt.Style) and not (fsUnderline in normalts.Style) then s := s+'<u>';
  if (fsStrikeOut in fnt.Style) and not (fsStrikeOut in normalts.Style) then s := s+'<s>';
  Result := s;
end;
{------------------------------------------------------------------------------}
{ Closes HTML tags opened in RV_HTMLOpenFontTag                                }
function RV_HTMLCloseFontTag(ts: TFontInfo; normalts: TFontInfo; Relative: Boolean):TRVAnsiString;
var s: TRVAnsiString;
begin
  case ts.SubSuperScriptType of
    rvsssSubscript:
      s := s+'</sub>';
    rvsssSuperScript:
      s := s+'</sup>';
    rvsssNormal:
      if ts.VShift < 0 then
        s := s+'</sub>'
      else if ts.VShift > 0 then
        s := s+'</sup>';
  end;
  if Relative then begin
    if (fsStrikeOut in ts.Style) and not (fsStrikeOut in normalts.Style) then s := s+'</s>';
    if (fsUnderline in ts.Style) and not (fsUnderline in normalts.Style) then s := s+'</u>';
    if (fsItalic    in ts.Style) and not (fsItalic    in normalts.Style) then s := s+'</i>';
    if (fsBold      in ts.Style) and not (fsBold      in normalts.Style) then s := s+'</b>';
    if not (fsBold      in ts.Style) and (fsBold      in normalts.Style) then s := s+'<b>';
    if not (fsItalic    in ts.Style) and (fsItalic    in normalts.Style) then s := s+'<i>';
    if not (fsUnderline in ts.Style) and (fsUnderline in normalts.Style) then s := s+'<u>';
    if not (fsStrikeOut in ts.Style) and (fsStrikeOut in normalts.Style) then s := s+'<s>';
    end
  else begin
    if (fsStrikeOut in ts.Style) then s := s+'</s>';
    if (fsUnderline in ts.Style) then s := s+'</u>';
    if (fsItalic in ts.Style)    then s := s+'</i>';
    if (fsBold in ts.Style)      then s := s+'</b>';
  end;
  if not Relative or (ts.Size<>normalts.Size) or (ts.Color<>normalts.Color) or
    (AnsiCompareText(ts.FontName,normalts.FontName)<>0) then
    s:= s+'</font>';
  Result := s;
end;
{------------------------------------------------------------------------------}
{ Closes HTML tags opened in RV_HTMLOpenFontTag2                               }
function RV_HTMLCloseFontTag2(fnt: TFont; normalts: TFontInfo; UseFontName: Boolean):TRVAnsiString;
var s: TRVAnsiString;
begin
  if (fsStrikeOut in fnt.Style) and not (fsStrikeOut in normalts.Style) then s := s+'</s>';
  if (fsUnderline in fnt.Style) and not (fsUnderline in normalts.Style) then s := s+'</u>';
  if (fsItalic    in fnt.Style) and not (fsItalic    in normalts.Style) then s := s+'</i>';
  if (fsBold      in fnt.Style) and not (fsBold      in normalts.Style) then s := s+'</b>';
  if not (fsBold      in fnt.Style) and (fsBold      in normalts.Style) then s := s+'<b>';
  if not (fsItalic    in fnt.Style) and (fsItalic    in normalts.Style) then s := s+'<i>';
  if not (fsUnderline in fnt.Style) and (fsUnderline in normalts.Style) then s := s+'<u>';
  if not (fsStrikeOut in fnt.Style) and (fsStrikeOut in normalts.Style) then s := s+'<s>';
  if (fnt.Size<>normalts.Size) or (fnt.Color<>normalts.Color) or
    (UseFontName and (AnsiCompareText(fnt.Name,normalts.FontName)<>0)) then
    s:= s+'</font>';
  Result := s;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
const SymbolEntities: array [$20..$FE] of PRVAnsiChar =
(
  ' ',
  '!', 'forall', '#', 'exist', '%', '&', '?', '(', ')', '*',
  '+', ',', '-', '.', '/', '0', '1', '2', '3', '4',
  '5', '6', '7', '8', '9', ':', ';', '<', '=', '>',
  '?', 'cong', 'Alpha', 'Beta', 'Chi', 'Delta', 'Epsilon', 'Phi', 'Gamma', 'Eta',
  'Iota', '#977', 'Kappa', 'Lambda', 'Mu', 'Nu', 'Omicron', 'Pi', 'Theta', 'Rho',
  'Sigma', 'Tau', 'Upsilon', 'sigmaf', 'Omega', 'Xi', 'Psi', 'Zeta', '[', 'there4',
  ']', 'perp', '_', '-', 'alpha', 'beta', 'chi', 'delta', 'epsilon', '#981',
  'gamma', 'eta', 'iota', 'phi', 'kappa', 'lambda', 'mu', 'nu', 'omicron', 'pi',
  'theta', 'rho', 'sigma', 'tau', 'upsilon', '#982', 'omega', 'xi', 'psi', 'zeta',
  '{', '|', '}', '~', '', '', '', '', '', '',
  '', '', '', '', '', '', '', '', '', '',
  '', '', '', '', '', '', '', '', '', '',
  '', '', '', '', '', '', '', '', '#978', 'prime',
  'le', 'frasl', 'infin', 'fnof', 'clubs', 'diams', 'hearts', 'spades', 'harr', 'larr',
  'uarr', 'rarr', 'darr', #176, 'plusmn', 'Prime', 'ge', 'times', 'prop', 'part',
  '#8226', 'divide', 'ne', 'equiv', 'asymp', 'hellip', '|', '-', 'crarr', 'alefsym',
  'image', 'real', 'weierp', 'otimes', 'oplus', 'empty', 'cap', 'cup', 'sup', 'supe',
  'nsub', 'sub', 'sube', 'isin', 'notin', 'ang', 'nabla', 'reg', 'copy', 'trade',
  'prod', 'radic', 'sdot', 'not', 'and', 'or', 'hArr', 'lArr', 'uArr', 'rArr',
  'dArr', 'loz', 'lang', 'reg', 'copy', 'trade', 'sum', '/', '|', '\',
  '/', '|', '\', '/', '{', '\', '|', 'euro', 'rang', 'int',
  '#8992', '|', '#8993', '\', '|', '/', '\', '|', '/', '\',
  '}', '/');
{ Converts string of Symbol font to HTML string }
function RV_MakeHTMLSymbolStrA(const s: TRVAnsiString): TRVAnsiString;
var i: Integer;
    s1: TRVAnsiString;
begin
  Result := '';
  for i := 1 to Length(s) do
    if ord(s[i]) in [$20..$FE] then begin
      s1 := SymbolEntities[ord(s[i])];
      if Length(s1)>1 then
        s1 := '&'+s1+';';
      Result := Result+s1;
    end;
end;
{ Converts Raw Unicode string of Symbol font to HTML string }
function RV_MakeHTMLSymbolStrRaw(const s: TRVRawByteString): TRVAnsiString;
var i: Integer;
    s1: TRVAnsiString;
    ps: PRVWordArray;
    ch: Word;
begin
  RVCheckUni(Length(s));
  Result := '';
  ps := PRVWordArray(PRVAnsiChar(s));
  for i := 0 to (Length(s) div 2) - 1 do  begin
    ch := ps[i];
    if ch>=61440 then
      dec(ch, 61440);
    if (ch>=$20) and (ch<=$FE) then begin
      s1 := SymbolEntities[ch];
      if Length(s1)>1 then
        s1 := '&'+s1+';';
      Result := Result+s1;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function RV_MakeHTMLSymbolStr(const s: String): TRVAnsiString;
begin
  {$IFDEF RVUNICODESTR}
  Result := RV_MakeHTMLSymbolStrRaw(RVU_GetRawUnicode(s));
  {$ELSE}
  Result := RV_MakeHTMLSymbolStrA(s);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Converts str to a string for insertion in HTML.
  If SpecialCode=True, does nothing (returns the original string).
  Replaces:
    '&' --> '&amp;'
    '>' --> '&gt;'
    '<' --> '&lt;'
    '  ' (two spaces) --> '&nbsp; '.
}
function RV_MakeHTMLStr(const str:TRVAnsiString; SpecialCode, NextSpace: Boolean): TRVAnsiString;
begin
  Result := str;
  if not SpecialCode then begin
    RV_ReplaceStr2A(Result, '&', '&amp;');
    RV_ReplaceStrA(Result, '>', '&gt;');
    RV_ReplaceStrA(Result, '<', '&lt;');
    RV_ReplaceStrA(Result, '  ', '&nbsp; ');
    if NextSpace and (Result<>'') and (Result[Length(Result)]=' ') then begin
      Result[Length(Result)] := '&';
      Result := Result+'nbsp;';
    end;
  end;
end;
{------------------------------------------------------------------------------}
function RV_MakeHTMLValueStr(const str:String): String;
begin
  Result := str;
  RV_ReplaceStr2(Result, '&', '&amp;');
  RV_ReplaceStr(Result, '>', '&gt;');
  RV_ReplaceStr(Result, '<', '&lt;');
  RV_ReplaceStr(Result, '  ', '&nbsp; ');
  RV_ReplaceStr(Result, '"', '&quot;');
end;
{------------------------------------------------------------------------------}
{ For HTML saving. Returns value for '%s' in
  '<META HTTP-EQUIV="Content-Type"  CONTENT="text/html; CHARSET=%s">'          }
{$IFDEF RICHVIEWCBDEF3}
function RV_CharSet2HTMLLang(CharSet: TFontCharset): TRVAnsiString;
begin
  case CharSet of // please report me about errors and holes in this table!
    SHIFTJIS_CHARSET:    Result := 'shift_jis';
    HANGEUL_CHARSET:     Result := 'EUC-KR';
    JOHAB_CHARSET:       Result := 'CP1361';
    GB2312_CHARSET:      Result := 'gb2312';
    CHINESEBIG5_CHARSET: Result := 'big5';
    GREEK_CHARSET:       Result := 'Windows-1253';
    TURKISH_CHARSET:     Result := 'Windows-1254';
    VIETNAMESE_CHARSET:  Result := 'Windows-1258';
    HEBREW_CHARSET:      Result := 'Windows-1255';
    ARABIC_CHARSET:      Result := 'Windows-1256';
    BALTIC_CHARSET:      Result := 'Windows-1257';
    RUSSIAN_CHARSET:     Result := 'Windows-1251';
    THAI_CHARSET:        Result := 'Windows-874';
    EASTEUROPE_CHARSET:  Result := 'Windows-1250';
    OEM_CHARSET:         Result := 'ascii';
    ANSI_CHARSET:        Result := 'Windows-1252';
    else                 Result := '';
  end;
end;
{$ENDIF}
{$ENDIF}
{------------------------------------------------------------------------------}
{ Replaces %xx codes in s with chr(xx), where xx - hexadecimal code.
  If DecodeLineBreaks=False, %0A and %0D are not decoded }
function RV_DecodeURL(const s: String; DecodeLineBreaks: Boolean): String;
var i: Integer;
    ch: Char;
  {...........................................}
  function GetHexValue(ch: Char): Integer;
  begin
    case ch of
      '0'..'9':
        Result := ord(ch)-ord('0');
      'a'..'f':
        Result := ord(ch)-ord('a')+10;
      'A'..'F':
        Result := ord(ch)-ord('A')+10;
      else
        Result := 0;
    end;
  end;
  {...........................................}
  function Is16Digit(ch: Char): Boolean;
  begin
    case ch of
      '0'..'9','a'..'f','A'..'F':
        Result := True;
      else
        Result := False;
    end;
  end;
  {...........................................}
begin
  Result := s;
  i := 1;
  while i<=Length(Result)-2 do begin
    if (Result[i]='%') and Is16Digit(Result[i+1]) and Is16Digit(Result[i+2]) then begin
      ch := Chr(GetHexValue(Result[i+1])*16+GetHexValue(Result[i+2]));
      if DecodeLineBreaks or not ((ch=#13) or (ch=#10)) then begin
        Result[i] := ch;
        Delete(Result, i+1, 2);
      end;
    end;
    inc(i);
  end;
end;
{------------------------------------------------------------------------------}
{ Returns '/' for XHTML}
function RV_HTMLGetEndingSlash(SaveOptions: TRVSaveOptions): TRVAnsiString;
begin
  if (rvsoXHTML in SaveOptions) then
   // if AddSpace then
      Result := ' /'
   // else
   //   Result := '/'
  else
    Result := '';
end;
{------------------------------------------------------------------------------}
{ For HTML, returns Attr. For XHTML, returns Attr="Attr". }
function RV_HTMLGetNoValueAttribute(const Attr: TRVAnsiString;
  SaveOptions: TRVSaveOptions): TRVAnsiString;
begin
  if (rvsoXHTML in SaveOptions) then
    Result := Attr+'="'+Attr+'"'
  else
    Result := Attr;
end;
{------------------------------------------------------------------------------}
{ For HTML, returns Value. For XHTML, returns "Value". }
function RV_HTMLGetIntAttrVal2(Value: Integer; SaveOptions: TRVSaveOptions): String;
begin
  if (rvsoXHTML in SaveOptions) then
    Result := '"'+IntToStr(Value)+'"'
  else
    Result := IntToStr(Value);
end;

function RV_HTMLGetIntAttrVal(Value: Integer; SaveOptions: TRVSaveOptions): TRVAnsiString;
begin
  if (rvsoXHTML in SaveOptions) then
    Result := '"'+RVIntToStr(Value)+'"'
  else
    Result := RVIntToStr(Value);
end;
{------------------------------------------------------------------------------}
{ For HTML, returns Value. For XHTML, returns "Value". }
function RV_HTMLGetStrAttrVal(const Value: TRVAnsiString;
  SaveOptions: TRVSaveOptions): TRVAnsiString;
begin
  if (rvsoXHTML in SaveOptions) then
    if (Length(Value)>0) and (Value[1]='"') and (Value[Length(Value)]='"') then
      Result := Value
    else
      Result := '"'+Value+'"'
  else
    Result := Value;
end;
{------------------------------------------------------------------------------}
{ Replaces all characters from the set Replaced with the character Replacer
  in the string s.                                                             }
procedure ReplaceChars(var str: String; Replacer: Char; Replaced: SetOfChar);
var i: Integer;
begin
  for i := 1 to Length(str) do
    {$IFDEF RVUNICODESTR}
    if (ord(Str[i])<128) and (TRVAnsiChar(Str[i]) in Replaced) then
    {$ELSE}
    if Str[i] in Replaced then
    {$ENDIF}
      Str[i] := Replacer;
end;
{
procedure ReplaceCharsAnsi(var str: TRVAnsiString; Replacer: TRVAnsiChar;
  Replaced: SetOfChar);
var i: Integer;
begin
  for i := 1 to Length(str) do
    if Str[i] in Replaced then
      Str[i] := Replacer;
end;
}
{==========================  RTF functions  ===================================}
{$IFNDEF RVDONOTUSERTF}
{ Inserts the character Prefix before all characters from the set Prefixed
  in the string s.                                                                 }
procedure PrecedeCharacters(var s: TRVAnsiString;
  Prefix: TRVAnsiChar; Prefixed: SetOfChar);
var i: Integer;
begin
  i := 1;
  while i<=Length(s) do begin
    if s[i] in Prefixed then begin
      Insert(Prefix, s, i);
      inc(i);
    end;
    inc(i);
  end;
end;
{------------------------------------------------------------------------------}
{ Writes hexadecimal value of the character s in the 2nd and 3rd characters
  of the string s. s must have length >=3.                                     } 
procedure ToHex_(c: TRVAnsiChar; var s: TRVAnsiString);
begin
  s[3] := TRVAnsiChar(ord(c) mod 16);
  if s[3]<#10 then
    inc(s[3],ord('0'))
  else
    inc(s[3],ord('a')-10);
  s[2] := TRVAnsiChar(ord(c) div 16);
  if s[2]<#10 then
    inc(s[2],ord('0'))
  else
    inc(s[2],ord('a')-10);
end;
{------------------------------------------------------------------------------}
// Replaces all characters with codes <= $19 and >=$80 with their hexadecimal
//  codes, prefixed with '\'''.
//  If UseNamedEntities=True, it also replaces nonbreaking space and bullet with
//  their codes.
//  If ReplaceRTFControls=True, it also replaces {,},\ to their codes                                                                }
procedure RTFReplaceHex(var str: TRVAnsiString; UseNamedEntities, ReplaceRTFControls: Boolean);
var i: Integer;
    shex: TRVAnsiString;
begin
  shex := '''  ';
  for i := Length(str) downto 1 do
    case str[i] of
      #$20..#$7F:
        if ReplaceRTFControls and (str[i] in ['\','}','{']) then begin
          ToHex_(str[i],shex);
          Insert(shex, str, i+1);
          str[i] := '\';
        end;
      #$A0: // Nonbreaking space
        begin
          if UseNamedEntities then begin
            str[i] := '\';
            Insert('~', str, i+1);
            end
          else begin
            ToHex_(str[i],shex);
            Insert(shex, str, i+1);
            str[i] := '\';
          end;
        end;
      #$95: // Bullet
        begin
          if UseNamedEntities then begin
            str[i] := '\';
            Insert('bullet ', str, i+1);
            end
          else begin
            ToHex_(str[i],shex);
            Insert(shex, str, i+1);
            str[i] := '\';
          end;
        end;
      else
        begin
          ToHex_(str[i],shex);
          Insert(shex, str, i+1);
          str[i] := '\';
        end;
    end;
end;
{------------------------------------------------------------------------------}
(* Converts s to a string for insertion in RTF.
  If SpecialCode=True, does nothing (returns the original string).
  if RTFControlsToCodes=False, adds '\' before '\','}','{'
  If RTFControlsToCodes=True, changes these characters to their codes (used for list text)
  Then replaces all characters with codes <= $19 and >=$80 with their
  hexadecimal codes prefixed with '\'''
  If UseNamedEntities=True, it also replaces nonbreaking space and bullet with
  their codes.                                                                *)
function RVMakeRTFStr(const s:TRVAnsiString;
  SpecialCode, UseNamedEntities, RTFControlsToCodes: Boolean): TRVAnsiString;
begin
  Result := s;
  if not SpecialCode and not RTFControlsToCodes then
    PrecedeCharacters(Result, '\', ['\','}','{']);
  RTFReplaceHex(Result, UseNamedEntities, RTFControlsToCodes);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{$IFNDEF RVDONOTUSEUNICODE}
function RVMakeRTFStrW(const s:TRVUnicodeString; CodePage: TRVCodePage;
  SaveAnsi, ForceSaveAnsi, SpecialCode, RTFControlsToCodes: Boolean): TRVAnsiString;
var Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    RVWriteUnicodeRTFStr(Stream, RVU_GetRawUnicode(s), CodePage, SaveAnsi,
      ForceSaveAnsi, SpecialCode, False, RTFControlsToCodes);
    SetLength(Result, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(PRVAnsiChar(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
end;
{$ENDIF}
{$ENDIF}
{------------------------------------------------------------------------------}
{ Prepares file name for saving to RTF. It is saved as normal Unicode
  identifier, except for '\' is saved as '\\\\' instead of '\\' }
function RVMakeRTFFileNameStr(const s:String; CodePage: TRVCodePage;
  SaveAnsi: Boolean): TRVAnsiString;
{$IFDEF RVUNICODESTR}
var Stream: TMemoryStream;
{$ENDIF}
begin
  {$IFDEF RVUNICODESTR}
  Stream := TMemoryStream.Create;
  try
    RVWriteUnicodeRTFStr(Stream, RVU_GetRawUnicode(s), CodePage, SaveAnsi, True,
      False, True, False);
    SetLength(Result, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(PRVAnsiChar(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
  {$ELSE}
  Result := s;
  PrecedeCharacters(Result, '\', ['\']);  
  PrecedeCharacters(Result, '\', ['\','}','{']);
  RTFReplaceHex(Result, False, False);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
(* Converts s to a string for insertion in RTF as an identifier or something
  like this.
  obsolete-> Replaces '\','}','{' with '_'.
  obsolete-> Then replaces all characters with codes <= $19 and >=$80 with their
  obsolete-> hexadecimal codes prefixed with '\'''                                       *)
function MakeRTFIdentifierStr(const s:String; CodePage: TRVCodePage;
  SaveAnsi: Boolean): TRVAnsiString;
{$IFDEF RVUNICODESTR}
var Stream: TMemoryStream;
{$ENDIF}
begin
  {$IFDEF RVUNICODESTR}
  Stream := TMemoryStream.Create;
  try
    RVWriteUnicodeRTFStr(Stream, RVU_GetRawUnicode(s), CodePage, SaveAnsi, True,
      False, False, False);
    SetLength(Result, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(PRVAnsiChar(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
  {$ELSE}
  Result := RVMakeRTFStr(s, False, False, False);
  {$ENDIF}
  (*
  Result := TRVAnsiString(s);
  ReplaceCharsAnsi(Result, '_',  ['\','}','{']);
  RTFReplaceHex(Result, False);
  *)
end;
{------------------------------------------------------------------------------}
{ Converts s to a string for insertion in RTF as a bookmark name.
  Replaces all non alpha-numeric characters with '_'.
  Note: IsCharAlphaNumericA depends on Windows locale.                         }
function MakeRTFBookmarkNameStr(const s:String): String;
var i: Integer;
begin
  Result := s;
  for i := 1 to Length(Result) do
    if not IsCharAlphaNumeric(Result[i]) then
      Result[i] := '_';
end;
{------------------------------------------------------------------------------}
{ Writes "raw Unicode" string s in RTF Stream.
  If SaveAnsi=True, saves ANSI version of text as well (in this case, assumes
  that the default RTF UC setting "number of ANSI characters representing 1 Unicode
  character"=1. CodePage is used for conversion Unicode to ANSI.
  Some special characters are replaced with their RTF codes (if SpecialCode=False).
  Unicode characters with codes <128 are saved only as ANSI characters,
  RVMakeRTFStr(...,SpecialCode) is used for them.
  If ForceSaveAnsi=True, then the procedure work like if SaveAnsi=True, then
  restores the default UC setting (0 if SaveAnsi=False, 1 if SaveAnsi=True)
  DoubleBSlashes tells to save '\' as '\\\\' instead of '\\'. It is required for
  file names in URL targets.
}
// If RTFControlsToCodes, then it replaces {,},\ to its codes
procedure RVWriteUnicodeRTFStr(Stream: TStream;
  const s: TRVRawByteString; CodePage: TRVCodePage;
  SaveAnsi, ForceSaveAnsi, SpecialCode, DoubleBSlashes, RTFControlsToCodes: Boolean);
type
    PWord = ^Word;
var i: Integer;
    ws: PWord;
    uni: TRVRawByteString;
    ansi: TRVAnsiString;
    AnsiLen, DefAnsiLen: Integer;
    Saved: Boolean;
begin
  ws := PWord(PRVAnsiChar(s));
  SetLength(uni,2);
  if SaveAnsi then
    DefAnsiLen := 1
  else
    DefAnsiLen := 0;
  AnsiLen := DefAnsiLen;
  if ForceSaveAnsi then
    SaveAnsi := True;
  for i := 0 to (Length(s) div 2)-1 do begin
    if (ws^>0) and (ws^<128) then begin
      if not SpecialCode and (ws^=Word(ord('\'))) and DoubleBSlashes then
        ansi := '\\\\'
      else begin
        ansi := TRVAnsiChar(ws^);
        ansi := RVMakeRTFStr(ansi, SpecialCode, True, RTFControlsToCodes);
      end;
      if Length(ansi)>0 then
        RVFWrite(Stream, ansi);
      end
    else begin
      Saved := False;
      if not SpecialCode then begin
        Saved := True;
        case PWordArray(ws)[0] of
          $00A0:
            RVFWrite(Stream, '\~');
          $00AD:
            RVFWrite(Stream, '\-');
          $0095:
            RVFWrite(Stream, '\bullet ');
          $201C:
            RVFWrite(Stream, '\ldblquote ');
          $201D:
            RVFWrite(Stream, '\rdblquote ');
          $2018:
            RVFWrite(Stream, '\lquote ');
          $2019:
            RVFWrite(Stream, '\rquote ');
          $2013:
            RVFWrite(Stream, '\endash ');
          $2014:
            RVFWrite(Stream, '\emdash ');
          $2002:
            RVFWrite(Stream, '{\enspace }');
          $2003:
            RVFWrite(Stream, '{\emspace }');
          $2005:
            RVFWrite(Stream, '{\qmspace }');
          else
            Saved := False;
        end;
      end;
      if not Saved then begin
        if SaveAnsi then begin
          Move(ws^, PRVAnsiChar(uni)^, 2);
          ansi := RVU_UnicodeToAnsi(CodePage, uni);
          if Length(ansi)<>AnsiLen then begin
            AnsiLen := Length(ansi);
            RVFWrite(Stream, '\uc');
            RVFWrite(Stream, RVIntToStr(AnsiLen));
          end;
        end;
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\u%d ',[ws^]));
        if SaveAnsi then begin
          ansi := RVMakeRTFStr(ansi, False, True, False);
          if Length(ansi)>0 then
            RVFWrite(Stream, ansi);
        end;
      end;
    end;
    inc(PRVAnsiChar(ws),2);
  end;
  if AnsiLen<>DefAnsiLen then begin
    RVFWrite(Stream, '\uc');
    RVFWrite(Stream, RVIntToStr(DefAnsiLen));
  end;
end;
{$ENDIF}
{=========================== URL Detection ====================================}
{ Is URL? }
function RVIsURL(const s: String): Boolean;
var str: String;
    {....................................}
    function CheckPrefix(const Prefix: String): Boolean;
    begin
      Result := (Length(str)>Length(Prefix)) and
        (Copy(str, 1, Length(Prefix))=Prefix);
    end;
    {....................................}
begin
  if Assigned(RVIsCustomURL) then
    Result := RVIsCustomURL(s)
  else
    Result := False;
  if not Result then begin
    str := AnsiLowerCase(s);
    Result :=
          CheckPrefix('http://') or
          CheckPrefix('ftp://') or
          CheckPrefix('file://') or
          CheckPrefix('gopher://') or
          CheckPrefix('mailto:') or
          CheckPrefix('https://') or
          CheckPrefix('news:') or
          CheckPrefix('telnet:') or
          CheckPrefix('wais:') or
          CheckPrefix('www.') or
          CheckPrefix('ftp.');
  end;
end;
{------------------------------------------------------------------------------}
{ Is e-mail address? }
function RVIsEmail(const s: String): Boolean;
var pAt, pDot: PChar;
begin
  //'@' must exist and '.' must be after it. This is not a comprehensive test,
  //but I think it's ok
  Result := False;
  pAt := StrScan(PChar(s), '@');
  if pAt=nil then
    exit;
  pDot := StrRScan(PChar(s),'.');
  if pDot = nil then
    exit;
  Result := pAt<pDot;
end;
{======================  Conversion of coordinates  ===========================}
{ Converts X-coordinate from screen resolution to device resolution            }
function RV_XToDevice(X: Integer; const sad: TRVScreenAndDevice): Integer;
begin
  Result := MulDiv(X, sad.ppixDevice, sad.ppixScreen);
end;
{------------------------------------------------------------------------------}
{ Converts Y-coordinate from screen resolution to device resolution            }
function RV_YToDevice(Y: Integer; const sad: TRVScreenAndDevice): Integer;
begin
  Result := MulDiv(Y, sad.ppiyDevice, sad.ppiyScreen);
end;
{------------------------------------------------------------------------------}
{ Converts X-coordinate from device resolution to screen resolution            }
function RV_XToScreen(X: Integer; const sad: TRVScreenAndDevice): Integer;
begin
  Result := MulDiv(X, sad.ppixScreen, sad.ppixDevice);
end;
{------------------------------------------------------------------------------}
{ Converts Y-coordinate from device resolution to screen resolution            }
function RV_YToScreen(Y: Integer; const sad: TRVScreenAndDevice): Integer;
begin
  Result := MulDiv(Y, sad.ppiyScreen, sad.ppiyDevice);
end;
{------------------------------------------------------------------------------}
{ Converts coordinates in rectangle R from device resolution to screen
  resolution                                                                   }
procedure RV_RectToScreen(var R: TRect; const sad: TRVScreenAndDevice);
begin
  R.Left   := MulDiv(R.Left,   sad.ppixScreen, sad.ppixDevice);
  R.Right  := MulDiv(R.Right,  sad.ppixScreen, sad.ppixDevice);
  R.Top    := MulDiv(R.Top,    sad.ppiyScreen, sad.ppiyDevice);
  R.Bottom := MulDiv(R.Bottom, sad.ppiyScreen, sad.ppiyDevice);
end;
{------------------------------------------------------------------------------}
{ Fills the main properties of sad - information about the screen resolution
  and about the device resolution (device is represented by Canvas)            }
procedure RV_InfoAboutSaD(var sad:TRVScreenAndDevice; Canvas: TCanvas;
  GraphicInterface: TRVGraphicInterface);
var ScreenCanvas: TCanvas;
begin
   sad.ppixDevice := GraphicInterface.GetDeviceCaps(Canvas, LOGPIXELSX);
   sad.ppiyDevice := GraphicInterface.GetDeviceCaps(Canvas, LOGPIXELSY);
   ScreenCanvas := GraphicInterface.CreateScreenCanvas;
   try
     sad.ppixScreen := GraphicInterface.GetDeviceCaps(ScreenCanvas, LOGPIXELSX);
     sad.ppiyScreen := GraphicInterface.GetDeviceCaps(ScreenCanvas, LOGPIXELSY);
   finally
     GraphicInterface.DestroyScreenCanvas(ScreenCanvas);
   end;
end;
{------------------------------------------------------------------------------}
{ Returns screen pixels-per-inch value }
function RV_GetPixelsPerInch: Integer;
var screenDC: HDC;
begin
   if RichViewPixelsPerInch<=0 then begin
     screenDc := CreateCompatibleDC(0);
     Result := GetDeviceCaps(screenDC, LOGPIXELSY);
     DeleteDC(screenDC);
     end
   else
     Result := RichViewPixelsPerInch;
end;
{------------------------------------------------------------------------------}
{ Returns true, if (X,Y) is inside the given rectangle                         }
function RV_PointInRect(X,Y: Integer; Left,Top,Width,Height: Integer): Boolean;
begin
  Result := (X>=Left) and (X<Left+Width) and
            (Y>=Top)  and (Y<Top+Height);
end;
{==========================  Conversion of units  =============================}
const
  cmPerInch = 2.54;
  mmPerInch = 25.4;
  PicasPerInch = 6;
  PointsPerInch = 72;
{------------------------------------------------------------------------------}
{ Returns Units per 1 inch }
function RV_UnitsPerInch(Units: TRVUnits): TRVLength;
begin
  case Units of
    rvuCentimeters:
      Result := cmPerInch;
    rvuMillimeters:
      Result := mmPerInch;
    rvuPicas:
      Result := PicasPerInch;
    rvuPixels:
      if RichViewPixelsPerInch=0 then
        Result := Screen.PixelsPerInch
      else
        Result := RichViewPixelsPerInch;
    rvuPoints:
      Result := PointsPerInch;
  else
    Result := 1;
  end;
end;
{------------------------------------------------------------------------------}
{ Converts value from Units to twips }
function RV_UnitsToTwips(Value: TRVLength; Units: TRVUnits): Integer;
begin
  Result := Round(Value*1440/RV_UnitsPerInch(Units));
end;
{------------------------------------------------------------------------------}
{ Converts value from twips to Units }
function RV_TwipsToUnits(Value: Integer; Units: TRVUnits): TRVLength;
begin
  Result := Value*RV_UnitsPerInch(Units)/1440;
end;
{========================  Graphics & Colors  =================================}
{ This procedure creates a graphic object by its class.
  This is a workaround for D2-D5 bug (private constructor of TGraphic).
  This procedure is assigned to variable RV_CreateGraphics.                    }
type
  TGraphicAccess=class(TGraphic);

function RV_CreateGraphicsDefault(GraphicClass: TGraphicClass): TGraphic;
begin
  Result:=TGraphic(GraphicClass.NewInstance);
  TGraphicAccess(Result).Create;
end;
{------------------------------------------------------------------------------}
{ This is a default procedure called after importing external files by links
  in documents (RTF).
  This procedure is assigned to variable RV_AfterImportGraphic.                }
procedure RV_AfterImportGraphicDefault(Graphic: TGraphic);
begin

end;
{------------------------------------------------------------------------------}
{ Returns luminance of Color                                                   }
function RV_GetLuminance(Color: TColor): Integer;
var
  R, G, B: Word;
begin
  Color := ColorToRGB(Color);
  R := Color and $0000FF;
  G := (Color and $00FF00) shr 8;
  B := (Color and $FF0000) shr 16;
  Result := Round(0.3*R + 0.59*G + 0.11*B);
end;
{------------------------------------------------------------------------------}
{ Converts Color to grayscale.                                                 }
function RV_GetGray(Color: TColor): TColor;
var
  R, G, B, C: Word;
begin
  if Color=clNone then begin
    Result := clNone;
    exit;
  end;
  Color := ColorToRGB(Color);
  R := Color and $0000FF;
  G := (Color and $00FF00) shr 8;
  B := (Color and $FF0000) shr 16;

  C := Round(0.3*R + 0.59*G + 0.11*B);
  if C>255 then
    C := 255;
  Result := RGB(C,C,C);
end;
{------------------------------------------------------------------------------}
{ Returns color as it will be printed, if ColorMode=rvcmPrinterColor
  (converts clWindow to clWhite and clWindowText to clBlack)                   }
function RV_GetPrnColor(Color: TColor): TColor;
begin
  case Color of
    clWindowText:
      Result := clBlack;
    clWindow, clBtnHighlight:
      Result := clWhite;
    clBtnShadow:
      Result := clGray;
    clBtnFace, clScrollbar:
      Result := clSilver;
    else
      Result := Color;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns foreground color as it will be printed                               }
function RV_GetColor(Color: TColor; ColorMode: TRVColorMode): TColor;
begin
  if Color=clNone then begin
    Result := clNone;
    exit;
  end;
  case ColorMode of
    rvcmColor:
      Result := Color;
    rvcmPrinterColor:
      Result := RV_GetPrnColor(Color);
    rvcmGrayScale:
      Result := RV_GetGray(RV_GetPrnColor(Color));
    else
      if Color<>clWhite then
        Result := clBlack
      else
        Result := clWhite;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns background color as it will be printed                               }
function RV_GetBackColor(Color: TColor; ColorMode: TRVColorMode): TColor;
begin
  if Color=clNone then begin
    Result := clNone;
    exit;
  end;
  case ColorMode of
    rvcmColor:
      Result := Color;
    rvcmPrinterColor:
      Result := RV_GetPrnColor(Color);
    rvcmGrayScale:
      Result := RV_GetGray(RV_GetPrnColor(Color));
    else
      Result := clWhite;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns true, if graphic object (gr) can contain transparent areas           }
function RV_IsGraphicTransparent(gr: TGraphic): Boolean;
begin
  {$IFDEF RICHVIEWCBDEF3}
  if gr is TBitmap then
    Result := gr.Transparent
  {$IFNDEF RVDONOTUSEJPEGIMAGE}
  else if gr is TJpegImage then
    Result := False
  {$ENDIF}
  else
    Result := True;
  {$ELSE}
  Result := True;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Assigns the palette (PLogPal) to the picture (gr).
  Does something only on D3+, CB3+                                             }
procedure RV_SetPaletteToPicture(gr: TGraphic; PLogPal: PLogPalette);
{$IFDEF RICHVIEWCBDEF3}
var Palette: HPALETTE;
{$ENDIF}
begin
  if PLogPal<>nil then begin
    {$IFNDEF RVDONOTUSEJPEGIMAGE}
    if gr is TJpegImage then
      TJpegImage(gr).PixelFormat := jf8Bit;
    {$ENDIF}
    {$IFDEF RICHVIEWCBDEF3}
      Palette := CreatePalette(PLogPal^);
      gr.Palette := Palette;
      if gr.Palette<>Palette then
        DeleteObject(Palette);
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
 type
   PPalEntriesArray = ^TPalEntriesArray; {for palette re-construction}
   TPalEntriesArray = array[0..0] of TPaletteEntry;
{ Printing bitmap                                                              }
procedure RV_BltTBitmapAsDib(DestDc : hdc;   {Handle of where to blt}
  X, Y, PrintWidth, PrintHeight: Integer;
  bm : TBitmap);  {the TBitmap to Blt}
 var
   OriginalWidth :LongInt;               {width of BM}
   dc : hdc;                             {screen dc}
   IsPaletteDevice : bool;               {if the device uses palettes}
   IsDestPaletteDevice : bool;           {if the device uses palettes}
   BitmapInfoSize : integer;             {sizeof the bitmapinfoheader}
   lpBitmapInfo : PBitmapInfo;           {the bitmap info header}
   hBm : hBitmap;                        {handle to the bitmap}
   hPal : hPalette;                      {handle to the palette}
   OldPal : hPalette;                    {temp palette}
   hBits : THandle;                      {handle to the DIB bits}
   pBits : pointer;                      {pointer to the DIB bits}
   lPPalEntriesArray : PPalEntriesArray; {palette entry array}
   NumPalEntries : integer;              {number of palette entries}
   i : integer;                          {looping variable}
 begin
 {If range checking is on - lets turn it off for now}
 {we will remember if range checking was on by defining}
 {a define called CKRANGE if range checking is on.}
 {We do this to access array members past the arrays}
 {defined index range without causing a range check}
 {error at runtime. To satisfy the compiler, we must}
 {also access the indexes with a variable. ie: if we}
 {have an array defined as a: array[0..0] of byte,}
 {and an integer i, we can now access a[3] by setting}
 {i := 3; and then accessing a[i] without error}
 {$IFOPT R+}
   {$DEFINE CKRANGE}
   {$R-}
 {$ENDIF}

  {Save the original width of the bitmap}
   OriginalWidth := bm.Width;

  {Get the screen's dc to use since memory dc's are not reliable}
   dc := GetDc(0);
  {Are we a palette device?}
   IsPaletteDevice :=
     GetDeviceCaps(dc, RASTERCAPS) and RC_PALETTE = RC_PALETTE;
  {Give back the screen dc}
   ReleaseDc(0, dc);

  {Allocate the BitmapInfo structure}
   if IsPaletteDevice then
     BitmapInfoSize := sizeof(TBitmapInfo) + (sizeof(TRGBQUAD) * 255)
   else
     BitmapInfoSize := sizeof(TBitmapInfo);
   lpBitmapInfo := Pointer(GlobalAlloc(GPTR, BitmapInfoSize));
   if lpBitmapInfo=nil then
     exit;

  {Fill in the BitmapInfo structure}
   lpBitmapInfo^.bmiHeader.biSize := sizeof(TBitmapInfoHeader);
   lpBitmapInfo^.bmiHeader.biWidth := OriginalWidth;
   lpBitmapInfo^.bmiHeader.biHeight := bm.Height;
   lpBitmapInfo^.bmiHeader.biPlanes := 1;
   if IsPaletteDevice then
     lpBitmapInfo^.bmiHeader.biBitCount := 8
   else
     lpBitmapInfo^.bmiHeader.biBitCount := 24;
   lpBitmapInfo^.bmiHeader.biCompression := BI_RGB;
   lpBitmapInfo^.bmiHeader.biSizeImage :=
     ((lpBitmapInfo^.bmiHeader.biWidth *
       longint(lpBitmapInfo^.bmiHeader.biBitCount)) div 8) *
       lpBitmapInfo^.bmiHeader.biHeight;
   lpBitmapInfo^.bmiHeader.biXPelsPerMeter := 0;
   lpBitmapInfo^.bmiHeader.biYPelsPerMeter := 0;
   if IsPaletteDevice then begin
     lpBitmapInfo^.bmiHeader.biClrUsed := 256;
     lpBitmapInfo^.bmiHeader.biClrImportant := 256;
   end else begin
     lpBitmapInfo^.bmiHeader.biClrUsed := 0;
     lpBitmapInfo^.bmiHeader.biClrImportant := 0;
   end;

  {Take ownership of the bitmap handle and palette}
   hBm := bm.ReleaseHandle;
   hPal := bm.ReleasePalette;

  {Get the screen's dc to use since memory dc's are not reliable}
   dc := GetDc(0);

   if IsPaletteDevice then begin
    {If we are using a palette, it must be}
    {selected into the dc during the conversion}
     OldPal := SelectPalette(dc, hPal, TRUE);
    {Realize the palette}
     RealizePalette(dc);
     end
   else
     OldPal := 0;
  {Tell GetDiBits to fill in the rest of the bitmap info structure}
   GetDiBits(dc,
             hBm,
             0,
             lpBitmapInfo^.bmiHeader.biHeight,
             nil,
             TBitmapInfo(lpBitmapInfo^),
             DIB_RGB_COLORS);

  {Allocate memory for the Bits}
   hBits := GlobalAlloc(GMEM_MOVEABLE,
                        lpBitmapInfo^.bmiHeader.biSizeImage);
   pBits := GlobalLock(hBits);
  {Get the bits}
   GetDiBits(dc,
             hBm,
             0,
             lpBitmapInfo^.bmiHeader.biHeight,
             pBits,
             TBitmapInfo(lpBitmapInfo^),
             DIB_RGB_COLORS);


   if IsPaletteDevice then begin
    {Lets fix up the color table for buggy video drivers}
     lPPalEntriesArray := Pointer(GlobalAlloc(GPTR, sizeof(TPaletteEntry) * 256));
    {$IFDEF VER100}
       NumPalEntries := GetPaletteEntries(hPal,
                                          0,
                                          256,
                                          lPPalEntriesArray^);
    {$ELSE}
       NumPalEntries := GetSystemPaletteEntries(dc,
                                                0,
                                                256,
                                                lPPalEntriesArray^);
    {$ENDIF}
     for i := 0 to (NumPalEntries - 1) do begin
       lpBitmapInfo^.bmiColors[i].rgbRed :=
         lPPalEntriesArray^[i].peRed;
       lpBitmapInfo^.bmiColors[i].rgbGreen :=
         lPPalEntriesArray^[i].peGreen;
       lpBitmapInfo^.bmiColors[i].rgbBlue :=
         lPPalEntriesArray^[i].peBlue;
     end;
     GlobalFree(Cardinal(lPPalEntriesArray));
   end;

   if IsPaletteDevice then begin
    {Select the old palette back in}
     SelectPalette(dc, OldPal, TRUE);
    {Realize the old palette}
     RealizePalette(dc);
   end;

  {Give back the screen dc}
   ReleaseDc(0, dc);

  {Is the Dest dc a palette device?}
   IsDestPaletteDevice :=
     GetDeviceCaps(DestDc, RASTERCAPS) and RC_PALETTE = RC_PALETTE;


   if IsPaletteDevice then begin
    {If we are using a palette, it must be}
    {selected into the dc during the conversion}
     OldPal := SelectPalette(DestDc, hPal, TRUE);
    {Realize the palette}
     RealizePalette(DestDc);
   end;

  {Do the blt}
   StretchDiBits(DestDc,
                 x,
                 y,
                 PrintWidth,
                 PrintHeight,
                 0,
                 0,
                 OriginalWidth,
                 lpBitmapInfo^.bmiHeader.biHeight,
                 pBits,
                 lpBitmapInfo^,
                 DIB_RGB_COLORS,
                 SrcCopy);

   if IsDestPaletteDevice then begin
    {Select the old palette back in}
     SelectPalette(DestDc, OldPal, TRUE);
    {Realize the old palette}
     RealizePalette(DestDc);
   end;

  {De-Allocate the Dib Bits}
   GlobalUnLock(hBits);
   GlobalFree(hBits);

  {De-Allocate the BitmapInfo}
   GlobalFree(Cardinal(lpBitmapInfo));

  {Set the ownership of the bimap handles back to the bitmap}
   bm.Handle := hBm;
   bm.Palette := hPal;

   {Turn range checking back on if it was on when we started}
 {$IFDEF CKRANGE}
   {$UNDEF CKRANGE}
   {$R+}
 {$ENDIF}
 end;
{------------------------------------------------------------------------------}
{ Alternative bitmap printing procedure }
procedure RV_PictureToDeviceAlt(Canvas: TCanvas; X, Y,
  PrintWidth, PrintHeight: Integer; gr: TBitmap);
var
  Info: PBitmapInfo;
  InfoSize: DWORD;
  Image: Pointer;
  ImageSize: DWORD;
  Bits: HBITMAP;
  DIBWidth, DIBHeight: Longint;
  palHalftone, palOrig: HPALETTE;
  nOldStretchBltMode: Integer;
begin
  palHalftone := CreateHalftonePalette(Canvas.Handle);
  palOrig := SelectPalette(Canvas.Handle, palHalftone, False);
  RealizePalette(Canvas.Handle);
  nOldStretchBltMode := GetStretchBltMode(Canvas.Handle);
  SetStretchBltMode(Canvas.Handle, HALFTONE);

  try
    Bits := gr.Handle;
    GetDIBSizes(Bits, InfoSize, ImageSize);
    Info := AllocMem(InfoSize);
    try
      Image := AllocMem(ImageSize);
      try
        GetDIB(Bits, 0, Info^, Image^);
        with Info^.bmiHeader do begin
          DIBWidth := biWidth;
          DIBHeight := biHeight;
        end;
        StretchDIBits(Canvas.Handle, x, y, PrintWidth, PrintHeight, 0, 0,
          DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
      finally
        FreeMem(Image, ImageSize);
      end;
    finally
      FreeMem(Info, InfoSize);
    end;
  finally
    SetStretchBltMode(Canvas.Handle, nOldStretchBltMode);
    SelectPalette(Canvas.Handle, palOrig, FALSE);
  end;
end;
{------------------------------------------------------------------------------}
{ This function is used for printing and drawing bitmaps.
  Canvas - destination canvas;
  x,y - destination coordinates of the left top corner, in Canvas resolution
  width, height - size of source graphics (may not be equal to the actual size
    of image), in screen resolution
  sad - contains information about screen and destination device resolutions.
    The image will be scaled according to it.
  gr - source graphics (must be bitmap)
  ToScreen - true, if the destination device is a screen (no special processing
    is required)                                                               }
procedure RV_PictureToDevice(Canvas: TCanvas; X,Y, Width, Height: Integer;
  sad: PRVScreenAndDevice; gr: TGraphic; ToScreen: Boolean;
  GraphicInterface: TRVGraphicInterface);
var
  PrintWidth, PrintHeight: Integer;
begin
 if Width<0 then
   Width := gr.Width;
 if Height<0 then
   Height := gr.Height;
 if sad<>nil then begin
   PrintWidth := RV_XToDevice(Width,  sad^);
   PrintHeight:= RV_YToDevice(Height, sad^);
   end
 else begin
   PrintWidth := Width;
   PrintHeight:= Height;
 end;
 if ToScreen then
   GraphicInterface.StretchDrawGraphic(Canvas,
     Bounds(x, y, PrintWidth, PrintHeight), gr)
 else if gr is TBitmap then begin
   GraphicInterface.PrintBitmap(Canvas,
     Bounds(x, y, PrintWidth, PrintHeight), TBitmap(gr));
 end;
end;
{------------------------------------------------------------------------------}
procedure ShadeRectangle(Canvas: TCanvas; const R: TRect; Color: TColor);
const
  Bits: array[0..7] of Word =
       ($55, $aa, $55, $aa,
       $55, $aa, $55, $aa);
var
  Bitmap: HBitmap;
  SaveBrush: HBrush;
  SaveTextColor, SaveBkColor: TColorRef;
  DC: HDC;
begin
  DC := Canvas.Handle;
  Bitmap := CreateBitmap(8, 8, 1, 1, @Bits);
  SaveBrush := SelectObject(DC, CreatePatternBrush(Bitmap));
  try
    SaveTextColor := SetTextColor(DC, clBlack);
    SaveBkColor := SetBkColor(DC, clWhite);
    with R do
      PatBlt(DC, Left, Top, Right - Left, Bottom - Top, $00A000C9); // and
    SetTextColor(DC, ColorToRGB(Color));
    SetBkColor(DC, clBlack);
    with R do
      PatBlt(DC, Left, Top, Right - Left, Bottom - Top, $00FA0089); // or
    SetBkColor(DC, SaveBkColor);
    SetTextColor(DC, SaveTextColor);
  finally
    DeleteObject(SelectObject(DC, SaveBrush));
    DeleteObject(Bitmap);
  end;
end;
{------------------------------------------------------------------------------}
// Returns the domain part of URL (including prefix)
// URL may be without a prefix, but it is assumed that it contains a domain name
function RVExtractDomain(const URL: String): String;
var p,p2: Integer;
    Prefix: String;
begin
  Result := URL;
  p := Pos('://', Result);
  if p>0 then begin
    Prefix := Copy(Result, 1, p+2);
    Result := Copy(Result, p+3, Length(Result));
    end
  else
    Prefix := '';
  p := Pos('/', Result);
  p2 := Pos('\', Result);
  if (p2>0) and (p2<p) then
    p := p2;
  p2 := Pos('?', Result);
  if (p2>0) and (p2<p) then
    p := p2;
  if p>0 then
    Result := Copy(Result, 1, p-1);
  Result := Prefix+Result;
end;
{------------------------------------------------------------------------------}
// If Path contains '://', the function returns the domain name from Path, including prefix.
// Otherwise, it returns ExtractFileDrive.
function RVExtractDomainOrDrive(const Path: String): String;
var p,p2: Integer;
    Prefix: String;
begin
  Result := Path;
  p := Pos('://', Result);
  if p>0 then begin
    Prefix := Copy(Result, 1, p+2);
    Result := Copy(Result, p+3, Length(Result));
    end
  else begin
    Result := ExtractFileDrive(Path);
    exit;
  end;
  p := Pos('/', Result);
  p2 := Pos('\', Result);
  if (p2>0) and (p2<p) then
    p := p2;
  p2 := Pos('?', Result);
  if (p2>0) and (p2<p) then
    p := p2;
  if p>0 then
    Result := Copy(Result, 1, p-1);
  Result := Prefix+Result;
end;
{------------------------------------------------------------------------------}
// Similar to ExtractRelativePath, but:
// - supports URLs
// - replaces '\' to '//' in result.
function RVExtractRelativePath(const BaseName, DestName: string): string;
var
  BasePath, DestPath, FileName: string;
  BaseLead, DestLead: PChar;
  BasePtr, DestPtr: PChar;

  function ExtractFilePathNoDrive(const FileName: string): string;
  var p: Integer;
  begin
    Result := FileName;
    Delete(Result, 1, Length(RVExtractDomainOrDrive(FileName)));
    p := LastDelimiter(':/\', Result);
    Result := Copy(Result, 1, p);
  end;

  function Next(var Lead: PChar): PChar;
  begin
    Result := Lead;
    if Result = nil then Exit;
    Lead := StrScan(Lead, '/');
    if Lead <> nil then
    begin
      Lead^ := #0;
      Inc(Lead);
    end;
  end;

begin
  if (AnsiPos('?', DestName)=0) and
     (AnsiCompareStr(RVExtractDomainOrDrive(BaseName), RVExtractDomainOrDrive(DestName))=0) then
  begin
    BasePath := RV_GetHTMLPath(ExtractFilePathNoDrive(BaseName));
    UniqueString(BasePath);
    DestPath := RV_GetHTMLPath(ExtractFilePathNoDrive(DestName));
    FileName := Copy(DestName, Length(RVExtractDomainOrDrive(DestName)+ExtractFilePathNoDrive(DestName))+1,
      Length(DestName));
    UniqueString(DestPath);
    BaseLead := Pointer(BasePath);
    BasePtr := Next(BaseLead);
    DestLead := Pointer(DestPath);
    DestPtr := Next(DestLead);
    while (BasePtr <> nil) and (DestPtr <> nil) and (AnsiCompareStr(BasePtr, DestPtr)=0) do
    begin
      BasePtr := Next(BaseLead);
      DestPtr := Next(DestLead);
    end;
    Result := '';
    while BaseLead <> nil do
    begin
      Result := Result + '..' + '/';
      Next(BaseLead);
    end;
    if (DestPtr <> nil) and (DestPtr^ <> #0) then
      Result := Result + DestPtr + '/';
    if DestLead <> nil then
      Result := Result + DestLead;
    Result := Result + FileName;
  end
  else
    Result := DestName;
end;
{------------------------------------------------------------------------------}
function RV_Sign(Value: Integer): Integer;
begin
  if Value=0 then
    Result := 0
  else if Value>0 then
    Result := 1
  else
    Result := -1;
end;
{------------------------------------------------------------------------------}
{ Draws line from (Left,Y) to (Right,Y) using Color and LineStyle. }
procedure RVDrawCustomHLine(Canvas: TCanvas; Color: TColor; LineStyle: TRVLineStyle;
  LineWidth, Left, Right, Y, PeriodLength: Integer;
  GraphicInterface: TRVGraphicInterface);
var X,X2,DashLength,DotLength,DashPeriod,DotPeriod: Integer;
begin
  Canvas.Pen.Color := Color;
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Brush.Style := bsClear;
  case LineStyle of
    rvlsNormal:
      if LineWidth=1 then begin
        Canvas.Pen.Width := LineWidth;
        GraphicInterface.Line(Canvas, Left, Y, Right, Y);
        end
      else begin
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := Color;
        Canvas.Pen.Width := 0;
        Canvas.Pen.Style := psClear;
        GraphicInterface.FillRect(Canvas,
          Rect(Left, Y-LineWidth div 2, Right, Y-LineWidth div 2+LineWidth));
      end;
  rvlsRoundDotted:
    begin
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Style := psClear;
      X := Left;
      Y := Y - LineWidth div 2;
      if LineWidth<=2 then
        while X+LineWidth<Right do begin
          GraphicInterface.FillRect(Canvas, Rect(X,Y, X+LineWidth, Y+LineWidth));
          inc(X, LineWidth*2);
        end
      else
        while X+LineWidth<Right do begin
          GraphicInterface.Ellipse(Canvas, X,Y, X+LineWidth+1, Y+LineWidth+1);
          inc(X, LineWidth*2);
        end
    end;
  rvlsHidden:
    begin
      DotLength := LineWidth;
      PeriodLength := LineWidth*3;
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Style := psClear;
      X := Left;
      Y := Y - LineWidth div 2;
      while X<Right do begin
        X2 := X+DotLength;
        if X2>Right then
          X2 := Right;
        GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
        inc(X, PeriodLength);
      end;
    end;
  rvlsDotted:
    begin
      if PeriodLength=0 then begin
        DotLength := LineWidth;
        PeriodLength := LineWidth*2;
        end
      else begin
        PeriodLength := Round(PeriodLength*Canvas.Font.PixelsPerInch/96);
        DotLength := Round(PeriodLength/2);
      end;
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Style := psClear;
      X := Left;
      Y := Y - LineWidth div 2;
      while X<Right do begin
        X2 := X+DotLength;
        if X2>Right then
          X2 := Right;
        GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
        inc(X, PeriodLength);
      end;
    end;
  rvlsDashed:
    begin
      if PeriodLength=0 then begin
        DashLength := LineWidth*2;
        PeriodLength := LineWidth*3;
        end
      else begin
        PeriodLength := Round(PeriodLength*Canvas.Font.PixelsPerInch/96);
        DashLength := Round(PeriodLength*2/3)
      end;
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Style := psClear;
      X := Left;
      Y := Y - LineWidth div 2;
      while X<Right do begin
        X2 := X+DashLength;
        if X2>Right then
          X2 := Right;
        GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
        inc(X, PeriodLength);
      end;
    end;
  rvlsDashDotted:
    begin
      if PeriodLength=0 then begin
        // 2 units dash, 1 unit spacing, 1 unit dot, 1 unit spacing
        DashLength := LineWidth*2;
        DotLength  := LineWidth;
        DashPeriod := LineWidth*3;
        DotPeriod  := LineWidth*2;
        end
      else begin
        // 4 units dash, 1 unit spacing, 1 unit dot, 1 unit spacing
        PeriodLength := Round(PeriodLength*Canvas.Font.PixelsPerInch/96);
        DashLength := Round(PeriodLength*4/7);
        DotLength := Round(PeriodLength/7);
        DashPeriod := Round(PeriodLength*5/7);;
        DotPeriod  := Round(PeriodLength*2/7);
      end;
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Style := psClear;
      X := Left;
      Y := Y - LineWidth div 2;
      while X<Right do begin
        X2 := X+DashLength;
        if X2>Right then
          X2 := Right;
        GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
        inc(X, DashPeriod);
        if X<Right then begin
          X2 := X+DotLength;
          if X2>Right then
            X2 := Right;
          GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
          inc(X, DotPeriod);
        end;
      end;
    end;
  rvlsDashDotDotted:
    begin
      if PeriodLength=0 then begin
        // 2 units dash, 1 unit spacing, 1 unit dot, 1 unit spacing,
        // 1 unit dot, 1 unit spacing
        DashLength := LineWidth*2;
        DotLength  := LineWidth;
        DashPeriod := LineWidth*3;
        DotPeriod  := LineWidth*2;
        end
      else begin
        // 3 units dash, 1 unit spacing, 1 unit dot, 1 unit spacing,
        // 1 unit dot, 1 unit spacing
        PeriodLength := Round(PeriodLength*Canvas.Font.PixelsPerInch/96);
        DashLength := Round(PeriodLength*3/8);
        DotLength := Round(PeriodLength/8);
        DashPeriod := Round(PeriodLength/2);
        DotPeriod  := Round(PeriodLength/4);
      end;
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Style := psClear;
      X := Left;
      Y := Y - LineWidth div 2;
      while X<Right do begin
        X2 := X+DashLength;
        if X2>Right then
          X2 := Right;
        GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
        inc(X, DashPeriod);
        if X<Right then begin
          X2 := X+DotLength;
          if X2>Right then
            X2 := Right;
          GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
          inc(X, DotPeriod);
        end;
        if X<Right then begin
          X2 := X+DotLength;
          if X2>Right then
            X2 := Right;
          GraphicInterface.FillRect(Canvas, Rect(X,Y, X2,Y+LineWidth));
          inc(X, DotPeriod);
        end;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function RVGetDefaultUnderlineWidth(FontSize: Integer): Integer;
begin
  if FontSize<23 then
    Result := 1
  else
    Result := (FontSize-23) div 15 + 2;
end;
{------------------------------------------------------------------------------}
// Draws the shortest line (using the current Canvas.Pen) between corners of
// two rectangles
procedure RVDrawLineBetweenRects(Left1, Top1, Width1, Height1,
  Left2, Top2, Width2, Height2: Integer; Canvas: TCanvas;
  GraphicInterface: TRVGraphicInterface);

  procedure TestPair(C1, C2: Integer; var BestD, Res1, Res2: Integer);
  begin
    if Abs(C1-C2)<BestD then begin
      BestD := Abs(C1-C2);
      Res1 := C1;
      Res2 := C2;
    end;
  end;

  procedure CheckOneDim(C1, S1, C2, S2: Integer; var Res1, Res2: Integer);
  var D: Integer;
  begin
    D := MaxInt;
    TestPair(C1, C2, D, Res1, Res2);
    TestPair(C1+S1, C2, D, Res1, Res2);
    TestPair(C1, C2+S2, D, Res1, Res2);
    TestPair(C1+S1, C2+S2, D, Res1, Res2);
  end;

var X1, X2, Y1, Y2: Integer;

begin
  CheckOneDim(Left1, Width1, Left2, Width2, X1, X2);
  CheckOneDim(Top1, Height1, Top2, Height2, Y1, Y2);
  GraphicInterface.Line(Canvas, X1, Y1, X2, Y2);
end;

initialization
  RV_CreateGraphics := RV_CreateGraphicsDefault;
  RV_AfterImportGraphic := RV_AfterImportGraphicDefault;
end.
