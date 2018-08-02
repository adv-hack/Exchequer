
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Constant and functions for loading RVF          }
{       documents in rvf_sInsertMap mode.               }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVMapWht;

interface
uses Graphics;

const
  // style map weights
  RVSMW_FONTNAME     = 10000;
  RVSMW_FONTSIZE     = 10000;
  RVSMW_FONTCHARSET  = 50000;
  RVSMW_EACHRGBCOLOR = 3333;
  RVSMW_COLORSET     = 3000;
  RVSMW_ALLCAPS      = 50000;
  RVSMW_OVERLINE     = 50000;
  RVSMW_EACHRGBBCOLOR = 10000;
  RVSMW_BCOLORSET     = 50000;
  RVSMW_FONTEACHSTYLE= 50000;
  RVSMW_HOVEREACHEFFECT = 10000;
  RVSMW_FONTSTYLESET = 50000;
  RVSMW_CHARSCALE    = 300;
  RVSMW_CHARSPACING  = 1000;
  RVSMW_TEXTBIDIMODE = 1000;
  RVSMW_VSHIFT       = 50000;
  RVSMW_VSHIFTRATIO  = 1000;
  RVSMW_CURSOR       = 5000;
  RVSMW_PROTECTION   = 100000;
  RVSMW_SPECIALCODE  = 50000;
  RVSMW_HIDDEN       = 5000;  
  RVSMW_LANGUAGE     = 100;
  RVSMW_SUBSUPERSCRIPTTYPE = 50000;
  RVSNW_PROTECTION   = 50000;

  RVSMW_ALIGNMENT    = 50000;
  RVSMW_PARABIDIMODE = 10000;
  RVSMW_OUTLINELEVEL = 50000;      
  RVSMW_LINESPACING  = 5000;
  RVSMW_INDENT       = 1000;
  RVSMW_BORDERSIDE   = 5000;
  RVSMW_BORDERNOSIDE = 20000;
  RVSMW_WIDTH        = 1000;
  RVSMW_BORDERSTYLE  = 1000;
  RVSMW_PADDING      = 100;
  RVSMW_NOWRAP       = 1000;
  RVSMW_READONLY     = 100000;
  RVSMW_STYLEPROTECT = 1000;
  RVSMW_DONOTWANTRETURNS= 10000;
  RVSMW_KEEPLINESTOGETHER= 500;
  RVSMW_KEEPWITHNEXT = 500;
  RVSMW_TABPOS       = 200;
  RVSMW_TABALIGN     = 100;
  RVSMW_LEADER       = 50;
  RVSMW_NOTAB        = 400;

  RVMW_LISTTYPE      = 5000;
  RVMW_LISTMISC      = 100;

function RV_CompareInts(New, Old, Weight: Integer): Integer;
function RV_CompareColors(Color1, Color2: TColor; w1, w2: Integer): Integer;

implementation

{------------------------------------------------------------------------------}
function RV_CompareInts(New, Old, Weight: Integer): Integer;
begin
  if New=0 then
    Result := Round((1-abs(Old))*Weight)
  else
    Result := Round((1-abs(New-Old)/abs(New))*Weight);
end;
{------------------------------------------------------------------------------}
function RV_CompareColors(Color1, Color2: TColor; w1, w2: Integer): Integer;
var c1,c2: Integer;
    b1,b2: Integer;

    procedure Cmp;
    begin
      if c1>$40 then
        inc(b1);
      if c2>$40 then
        inc(b2);
      dec(Result, abs(c1-c2) * w1 div $FF);
    end;
begin
  if (Color1=clNone) or (Color2=clNone) then begin
    if (Color1=clNone) = (Color2=clNone) then
      Result := w1*3+w2
    else
      Result := 0;
    exit;
  end;
  Color1 := ColorToRGB(Color1);
  Color2 := ColorToRGB(Color2);
  Result := 0;
  b1 := 0;
  b2 := 0;
  c1 := Color1 and $0000FF;
  c2 := Color2 and $0000FF;
  Cmp;

  c1 := (Color1 and $00FF00) shr 8;
  c2 := (Color2 and $00FF00) shr 8;
  Cmp;

  c1 := (Color1 and $FF0000) shr 16;
  c2 := (Color2 and $FF0000) shr 16;
  Cmp;

  if (b1=0) = (b2=0) then
    inc(Result, w2);
end;

end.
