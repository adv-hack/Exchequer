{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPFont;

interface

uses
  {$IFDEF Linux}
  QGraphics, Qt, Libc,
  {$ELSE}
  Windows, Graphics,
  {$ENDIF}
  SysUtils, Classes, RPDefine;

const
  BaseSize = 600;

type
  TRPBaseFontHandler = class
  public
    constructor Create(Font: TFont); virtual;
    function TextWidth(Value: string;
                       FontSize: double;
                       DPI: integer): integer; virtual; abstract;
  end; { TRPBaseFontHandler }

  TRPTrueTypeFontHandler = class(TRPBaseFontHandler)
  protected
    FFontTable: array[0..255] of integer;
  public
    constructor Create(Font: TFont); override;
    function TextWidth(Value: string;
                       FontSize: double;
                       DPI: integer): integer; override;
  end; { TRPTrueTypeFontHandler }

  TRPNonProportionalFontHandler = class(TRPBaseFontHandler)
  protected
    FFontWidth: integer;
  public
    constructor Create(Font: TFont); override;
    function TextWidth(Value: string;
                       FontSize: double;
                       DPI: integer): integer; override;
  end; { TRPNonProportionalFontHandler }

  TRPFontManager = class
  protected
    FFontList: TStringList;
    FDPI: integer;

    function FontNameOf(Font: TFont): string;
    function GetFontHandler(Font: TFont): TRPBaseFontHandler;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function TextWidth(Font: TFont;
                       Value: string): integer;
  end; { TRPFontManager }

var
  FontManager: TRPFontManager;

implementation

(*****************************************************************************}
( class TRPBaseFontHandler
(*****************************************************************************)

constructor TRPBaseFontHandler.Create(Font: TFont);
begin { Create }
end;  { Create }

(*****************************************************************************}
( class TRPTrueTypeFontHandler
(*****************************************************************************)

{$IFDEF Linux}
constructor TRPTrueTypeFontHandler.Create(Font: TFont);
var
  QFontM: QFontMetricsH;
  i: Integer;
begin
  inherited Create(Font);
  QFontM := QFontMetrics_create(Font.Handle);
  try
    for i := 0 to 255 do begin
      FFontTable[i] := QFontMetrics_width(QFontM, Chr(i));
    end;
  finally
    QFontMetrics_destroy(QFontM);
  end;
end;
{$ELSE}
constructor TRPTrueTypeFontHandler.Create(Font: TFont);
var
  ABCTable: array[0..255] of ABC;
  I1: integer;
begin { Create }
  inherited Create(Font);

// Get ABCTable
  With TBitmap.Create do try
    Canvas.Font.Assign(Font);
    Canvas.Font.Height := -BaseSize;
    GetCharABCWidths(Canvas.Handle,0,255,ABCTable);
  finally
    Free;
  end; { with }

// Convert ABCTable to FontTable
  For I1 := 0 to 255 do begin
    FFontTable[I1] := ABCTable[I1].abcA + integer(ABCTable[I1].abcB) + ABCTable[I1].abcC;
  end; { for }
end;  { Create }
{$ENDIF}

function TRPTrueTypeFontHandler.TextWidth(Value: string;
                                          FontSize: double;
                                          DPI: integer): integer;
var
  I1: integer;
begin { TextWidth }
  Result := 0;
  For I1 := 1 to Length(Value) do begin
    Result := Result + FFontTable[Ord(Value[I1])];
  end; { for }
  Result := Round((Result * FontSize * DPI) / (72 * BaseSize));
end;  { TextWidth }

(*****************************************************************************}
( class TRPNonProportionalFontHandler
(*****************************************************************************)

{$IFDEF Linux}
constructor TRPNonProportionalFontHandler.Create(Font: TFont);
begin
  //!!PORT!! Need to port this
  inherited Create(Font);
  raise Exception.Create('NonProportionalFontHandler.Create not implemented');
end;
{$ELSE}
constructor TRPNonProportionalFontHandler.Create(Font: TFont);
var
  ABCVal: ABC;
begin { Create }
  inherited Create(Font);

// Get FFontWidth
  With TBitmap.Create do try
    Canvas.Font.Assign(Font);
    Canvas.Font.Height := -BaseSize;
    GetCharABCWidths(Canvas.Handle,65,65,ABCVal);
    FFontWidth := ABCVal.abcA + integer(ABCVal.abcB) + ABCVal.abcC;
  finally
    Free;
  end; { with }
end;  { Create }
{$ENDIF}

function TRPNonProportionalFontHandler.TextWidth(Value: string;
                                                 FontSize: double;
                                                 DPI: integer): integer;
begin { TextWidth }
  Result := Round((Length(Value) * FFontWidth * FontSize * DPI) / (72 * BaseSize));
end;  { TextWidth }

(*****************************************************************************}
( class TRPFontManager
(*****************************************************************************)

constructor TRPFontManager.Create;
begin { Create }
  inherited Create;
  FFontList := TStringList.Create;
  FFontList.Sorted := true;
end;  { Create }

destructor TRPFontManager.Destroy;
var
  I1: integer;
begin { Destroy }
  For I1 := 0 to FFontList.Count - 1 do begin
    TRPBaseFontHandler(FFontList.Objects[I1]).Free;
  end; { for }
  FFontList.Free;
  inherited Destroy;
end;  { Destroy }

function TRPFontManager.FontNameOf(Font: TFont): string;
begin { FontNameOf }
  {$IFDEF Linux}
  Result := Font.Name + '|' + IntToStr(Ord(Font.CharSet));
  {$ELSE}
  Result := Font.Name + '|' + IntToStr(Font.Charset);
  {$ENDIF}
  If fsBold in Font.Style then begin
    Result := Result + '|B';
  end; { if }
  If fsItalic in Font.Style then begin
    Result := Result + '|I';
  end; { if }
  Case Font.Pitch of
    fpVariable: Result := Result + '|V';
    fpFixed: Result := Result + '|F';
  end; { case }
end;  { FontNameOf }

var
  CS: TRTLCriticalSection;

function TRPFontManager.GetFontHandler(Font: TFont): TRPBaseFontHandler;
var
  Index: integer;
  {$IFDEF Linux}
  QFontI: QFontInfoH;
  {$ELSE}
  TM: TextMetric;
  {$ENDIF}
begin { GetFontHandler }
// Find FontHandler for current font
// Use a critical section since Index may be invalid if a new font handler is
// inserted into the sorted FFontList between the Find() and the [Index] calls
  EnterCriticalSection(CS);
  try
    If FFontList.Find(FontNameOf(Font),Index) then begin // Found
      Result := TRPBaseFontHandler(FFontList.Objects[Index]);
      Exit;
    end; { if }
  finally
    LeaveCriticalSection(CS);
  end; { tryf }

// Create font handler since one wasn't found
  {$IFDEF Linux}
  QFontI := QFontInfo_create(Font.Handle);
  try
    //!!PORT!! what about Type1 fonts? This is only Windows platform
    if QFontInfo_fixedPitch(QFontI) then begin
      Result := TRPNonProportionalFontHandler.Create(Font);
    end else begin
      Result := TRPTrueTypeFontHandler.Create(Font);
    end;
    if Assigned(Result) then begin
      FFontList.AddObject(FontNameOf(Font), Result);
    end;
  finally
    QFontInfo_destroy(QFontI);
  end;
  {$ELSE}
  With TBitmap.Create do try
    Canvas.Font.Assign(Font);
    GetTextMetrics(Canvas.Handle,TM);
  finally
    Free;
  end; { with }
  Result := nil;
  try
    If (TMPF_FIXED_PITCH and TM.tmPitchAndFamily) = 0 then begin
      Result := TRPNonProportionalFontHandler.Create(Font);
    end else begin
      Result := TRPTrueTypeFontHandler.Create(Font);
    end; { else }
  finally
    If Assigned(Result) then begin
      FFontList.AddObject(FontNameOf(Font),Result);
    end; { if }
  end; { tryf }
  {$ENDIF}
end;  { GetFontHandler }

function TRPFontManager.TextWidth(Font: TFont;
                                  Value: string): integer;
begin { TextWidth }
  Result := GetFontHandler(Font).TextWidth(Value,
   (72 * Abs(Font.Height)) / Font.PixelsPerInch,Font.PixelsPerInch);
end;  { TextWidth }

initialization
  InitializeCriticalSection(CS);
  FontManager := TRPFontManager.Create;
finalization
  FontManager.Free;
  DeleteCriticalSection(CS);
end.
