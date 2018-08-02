unit KPIUtils;
{
  General-purpose utility routines for the KPI ActiveX control.
}
interface

uses SysUtils, Controls, Forms, Graphics;

type
  TLogEvent = procedure(Msg: string) of object;

  TKPILabelStyle = record
{
      <Caption></Caption>
      <Font>Tahoma</Font>
      <FontSize>8</FontSize>
      <FontColor>#000000</FontColor>
      <BackColor>#CCCCCC</BackColor>
}
    DefaultCaption: string;
    Caption: string;
    FontName: string;
    FontSize: Integer;
    FontStyle: TFontStyles;
    FontColor: TColor;
    BackColor: TColor;
  end;

// =============================================================================
// Resize/Drag handling
// =============================================================================
const
  ResizeLeft        = $F001;
  ResizeRight       = $F002;
  ResizeTop         = $F003;
  ResizeTopLeft     = $F004;
  ResizeTopRight    = $F005;
  ResizeBottom      = $F006;
  ResizeBottomLeft  = $F007;
  ResizeBottomRight = $F008;
  MoveComponent     = $F012;
  Proximity = 8;

function CoordinatesToAction(WinControl: TControl; X: integer; Y: integer): integer;
function ActionToCursor(intAction: integer): TCursor;
procedure MakeRounded(Control: TWinControl);
function WebColorToDelphiColor(WebColor: string): TColor;
function DelphiColorToWebColor(Color: TColor): string;
function GetExtension(FromCaption: string): string;
function CaptionWithoutExtension(FullCaption: string): string;

// =============================================================================

implementation

uses Windows, Messages, Types;

// =============================================================================
// Resize/Drag handling
// =============================================================================
function CoordinatesToAction(WinControl: TControl; X: integer; Y: integer): Integer;
begin
  if Y > (WinControl.Height - Proximity) then
    Result := ResizeBottom
  else
    Result := MoveComponent;
end;

// -----------------------------------------------------------------------------

function ActionToCursor(intAction: integer): TCursor;
begin
  case intAction of
    ResizeBottom: Result := crSizeNS;
    MoveComponent: Result := crSizeAll;
  else
    Result := crDefault;
  end;
end;

// -----------------------------------------------------------------------------

procedure MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

// -----------------------------------------------------------------------------

function WebColorToDelphiColor(WebColor: string): TColor;
{ Converts a web colour string (e.g. '#CCFFCC') to a TColor value }
var
  ColorString: string;
begin
  { Delphi interprets colour values in reverse (BGR instead of RGB), so we'll
    invert the supplied string. }
  ColorString := '$' +
                 Copy(WebColor, 6, 2) +
                 Copy(WebColor, 4, 2) +
                 Copy(WebColor, 2, 2);
  Result := StrToIntDef(ColorString, $FFFFFF);
end;

// -----------------------------------------------------------------------------

function DelphiColorToWebColor(Color: TColor): string;
{ Converts a TColor value into a web colour string (e.g. '#CCFFCC') }
var
  ColorString: string;
begin
  ColorString := IntToHex(Color, 6);
  { Delphi interprets colour values in reverse (BGR instead of RGB), so we'll
    invert the resulting string. }
  Result := '#' +
            Copy(ColorString, 6, 2) +
            Copy(ColorString, 4, 2) +
            Copy(ColorString, 2, 2);
end;

// -----------------------------------------------------------------------------

function GetExtension(FromCaption: string): string;
var
  StartPos, EndPos: Integer;
begin
  Result := '';
  StartPos := Pos('[', FromCaption);
  if (StartPos <> 0) then
  begin
    EndPos := Pos(']', Copy(FromCaption, StartPos, Length(FromCaption)));
    if (EndPos <> 0) then
    begin
      Result := Copy(FromCaption, StartPos, (StartPos + EndPos) - 1);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function CaptionWithoutExtension(FullCaption: string): string;
var
  Extension: string;
begin
  Result := FullCaption;
  Extension := GetExtension(Result);
  if (Trim(Extension) <> '') then
    Result := StringReplace(Result, Extension, '', [rfReplaceAll]);
end;

// -----------------------------------------------------------------------------

end.
