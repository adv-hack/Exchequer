{*******************************************************}
{                                                       }
{       RichView                                        }
{       Classes for extra painting over items.          }
{       Used for live spelling check.                   }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVWordPaint;

{$I RV_Defs.inc}

interface
uses Windows, Graphics, Classes, SysUtils,
     RVClasses, DLines;

type

  { ---------------------------------------------------------------------------
    TRVWordPainter: abstract ancestor class for painting over part of text items.
    Fields:
    - StartOff - start of text fragment (from 1)
    - Length - length of text fragment.
    Text fragment is usually a word.
  }
  TRVWordPainter = class
    public
      StartOffs, Length: Integer;
      procedure Draw(Canvas: TCanvas; ditem: TRVDrawLineInfo;
        RVData: TPersistent; const r: TRect; Index: Integer); virtual; abstract;
      constructor Create(AStartOffs, ALength: Integer);
  end;
  { ---------------------------------------------------------------------------
    TRVWordPainterList: list of TRVWordPainter.
    Each text item contains such list.
  }
  TRVWordPainterList = class (TRVList)
  private
    function Get(Index: Integer): TRVWordPainter;
    procedure Put(Index: Integer; const Value: TRVWordPainter);
  public
    property Items[Index: Integer]: TRVWordPainter read Get write Put; default;
  end;
  { ---------------------------------------------------------------------------
    TRVWordMisspellPainter: class for drawing red curved underlines
    for misspelled words.
  }
  TRVWordMisspellPainter = class (TRVWordPainter)
  public
    procedure Draw(Canvas: TCanvas; ditem: TRVDrawLineInfo;
      RVData: TPersistent; const r: TRect; Index: Integer); override;
  end;

implementation

uses CRVData;

{================================= TRVWordPainter =============================}

constructor TRVWordPainter.Create(AStartOffs, ALength: Integer);
begin
  inherited Create;
  StartOffs := AStartOffs;
  Length    := ALength;
end;

{============================= TRVWordMisspellPainter =========================}

procedure TRVWordMisspellPainter.Draw(Canvas: TCanvas;
  ditem: TRVDrawLineInfo; RVData: TPersistent; const r: TRect; Index: Integer);
var OldColor: TColor;
    OldWidth: Integer;
    OldStyle: TPenStyle;
    Points: array[0..1023] of TPoint;
    PointCount: Integer;
    Up: Boolean;
    StartX, EndX, Y: Integer;
    {
    FN: String;
    FS: Integer;
    }
begin
  PointCount  := 0;
  Up          := True;
  StartX := r.Left;
  EndX   := r.Right;
  Y      := r.Bottom+2{+Random(5)};
  while (PointCount < 1024) and (StartX < EndX) do begin
    Points[PointCount].X := StartX;
    inc(StartX, 2);
    if Up then
      Points[PointCount].Y := Y-4
    else
      Points[PointCount].Y := Y-2;
    inc(PointCount);
    Up := not Up;
  end;
  if (PointCount > 1) then begin
    OldColor := Canvas.Pen.Color;
    OldWidth := Canvas.Pen.Width;
    OldStyle := Canvas.Pen.Style;
    Canvas.Pen.Color := TCustomRVData(RVData).GetRVStyle.LiveSpellingColor;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    Points[PointCount-1].X := EndX;
    TCustomRVData(RVData).GetRVStyle.GraphicInterface.Polyline(Canvas,
      Points, PointCount);
    Canvas.Pen.Style := OldStyle;
    Canvas.Pen.Width := OldWidth;
    Canvas.Pen.Color := OldColor;
  end;
  {
  FS := Canvas.Font.Size;
  FN := Canvas.Font.Name;
  Canvas.Font.Color := clRed;
  Canvas.Font.Name := 'Small Fonts';
  Canvas.Font.Size := 6;
  Canvas.Brush.Style := bsClear;
  Canvas.TextOut(r.Right,r.Bottom, IntToStr(Index));
  Canvas.Font.Size := FS;
  Canvas.Font.Name := FN;
  }
end;

{ TRVWordPainterList }

function TRVWordPainterList.Get(Index: Integer): TRVWordPainter;
begin
  Result := TRVWordPainter(inherited Get(Index));
end;

procedure TRVWordPainterList.Put(Index: Integer; const Value: TRVWordPainter);
begin
  inherited Put(Index, Value);
end;

end.
