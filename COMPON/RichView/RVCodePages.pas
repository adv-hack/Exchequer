
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Procedures for design-time property editor      }
{       for TRVCodePage.                                }
{       This unit should not be used by applications    }
{       themselves.                                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVCodePages;

interface
uses SysUtils, Classes,  RVStyle;

procedure GetCodePageValues(Proc: TGetStrProc);
function CodePageToIdent(CodePage: TRVCodePage): String;
function IdentToCodePage(const Ident: string; var CodePage: TRVCodePage): Boolean;

implementation

const CodePageNames: array [0..15] of String =
(
      '0 Default ANSI code page',
      '1 Default OEM code page',
      '874 ANSI/OEM - Thai (same as 28605, ISO 8859-15)',
      '932 ANSI/OEM - Japanese, Shift-JIS',
      '936 ANSI/OEM - Simplified Chinese (PRC, Singapore)',
      '949 ANSI/OEM - Korean (Unified Hangeul Code)',
      '950 ANSI/OEM - Traditional Chinese (Taiwan; Hong Kong SAR, PRC)',
      '1250 ANSI - Central European',
      '1251 ANSI - Cyrillic',
      '1252 ANSI - Latin I',
      '1253 ANSI - Greek',
      '1254 ANSI - Turkish',
      '1255 ANSI - Hebrew',
      '1256 ANSI - Arabic',
      '1257 ANSI - Baltic',
      '1258 ANSI/OEM - Vietnamese'
);

const CodePageValues: array [0..15] of TRVCodePage =
(
      0,    //  Default ANSI code page
      1,    //  Default OEM code page
      874,  //  ANSI/OEM - Thai (same as 28605, ISO 8859-15)
      932,  //  ANSI/OEM - Japanese, Shift-JIS
      936,  //  ANSI/OEM - Simplified Chinese (PRC, Singapore)
      949,  //  ANSI/OEM - Korean (Unified Hangeul Code)
      950,  //  ANSI/OEM - Traditional Chinese (Taiwan; Hong Kong SAR, PRC)
      1250, //  ANSI - Central European
      1251, //  ANSI - Cyrillic
      1252, //  ANSI - Latin I
      1253, //  ANSI - Greek
      1254, //  ANSI - Turkish
      1255, //  ANSI - Hebrew
      1256, //  ANSI - Arabic
      1257, //  ANSI - Baltic
      1258  //  ANSI/OEM - Vietnamese
);
{------------------------------------------------------------------------------}
procedure GetCodePageValues(Proc: TGetStrProc);
var i: Integer;
begin
  for i := Low(CodePageNames) to High(CodePageNames) do
   Proc(CodePageNames[I]);
end;
{------------------------------------------------------------------------------}
function CodePageToIdent(CodePage: TRVCodePage): String;
var i: Integer;
begin
  for i := Low(CodePageNames) to High(CodePageNames) do
    if CodePageValues[i] = CodePage then begin
       Result := CodePageNames[i];
       exit;
    end;
  FmtStr(Result, '%u', [CodePage]);
end;
{------------------------------------------------------------------------------}
function IdentToCodePage(const Ident: string; var CodePage: TRVCodePage): Boolean;
var i: Integer;
begin
  for i := Low(CodePageNames) to High(CodePageNames) do
    if CodePageNames[i] = Ident then begin
       CodePage := CodePageValues[i];
       Result := True;
       exit;
    end;
  Result := False;
end;

end.
