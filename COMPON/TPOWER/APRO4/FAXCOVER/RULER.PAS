unit Ruler;

interface

uses
  Classes, Controls, ExtCtrls, Forms, Graphics, SysUtils, FDUtils;


type
  TRuler = class(TPanel)
  private
    FSizePixels     : Integer;
    FSizeInches     : Double;
    FIsMetric       : Boolean;
    FIsHorizontal   : Boolean;
    FStartPosition  : Integer;
    FLoMarkPosition : Integer;
    FHiMarkPosition : Integer;
    rPixelsPerInch  : Double;
    rPixelsPerCM    : Double;  {Pixels per centimeter}
    procedure SetSizePixels(ASizePixels : Integer);
    procedure SetSizeInches(ASizeInches : Double);
    procedure SetIsMetric(AIsMetric : Boolean);
    procedure SetIsHorizontal(AIsHorizontal : Boolean);
    procedure SetStartPosition(APosition : Integer);
    procedure SetLoMarkPosition(APosition : Integer);
    procedure SetHiMarkPosition(APosition : Integer);
  protected
    procedure Paint; override;
    property Canvas;
  public
    constructor Create(AOwner : TComponent); override;
    procedure SetMarkPositions(LoPosition, HiPosition : Integer);
      {-Sets the positions for drawing the low and high position marks. To
        suppress drawing the marks, set to negative value. Calling this proc
        is the same as setting the LoMarkPosition and HiMarkPosition properties,
        except this will cause only one repaint instead of two.}
    property SizePixels : Integer read FSizePixels write SetSizePixels;
    property SizeInches : Double read FSizeInches write SetSizeInches;
    property IsMetric : Boolean read FIsMetric write SetIsMetric;
    property IsHorizontal : Boolean read FIsHorizontal write SetIsHorizontal;
    property StartPosition : Integer read FStartPosition write SetStartPosition;
      {-Sets the starting position in pixels for painting the inch marks within
        the ruler, for simulating scrolling}
    property LoMarkPosition : Integer read FLoMarkPosition write SetLoMarkPosition;
      {-Sets the position for drawing the low red position mark on the ruler
        bar. To suppress drawing the mark, set it to a negative number.}
    property HiMarkPosition : Integer read FHiMarkPosition write SetHiMarkPosition;
      {-Sets the position for drawing the high red position mark on the ruler
        bar. To suppress drawing the mark, set it to a negative number.}
  end;


implementation

const
  ctDefaultWidth        = 16;
  ctDefaultHeight       = 16;
  ctDefaultWidthPixels  = 600;
  ctDefaultHeightPixels = 900;
  ctDefaultWidthInches  = 8.5;
  ctDefaultHeightInches = 11.0;

constructor TRuler.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  BevelInner      := bvNone;
  BevelOuter      := bvRaised;
  BorderStyle     := bsNone;
  Color           := clWindow;
  FLoMarkPosition := -1;
  FHiMarkPosition := -1;
  SetIsHorizontal(True);  {Default to a horizontal ruler}
end;  { Create }

procedure TRuler.Paint;
var
  I       : Integer;
  BasePos : Integer;
  Offset  : Integer;
  MarkPos : Integer;
  SizeCMs : Double; {Size in centimeters}
  NumStr  : string[4];
begin
  inherited Paint;
  Canvas.Font.Color := clWindowText;
  if FIsHorizontal then begin
    if FIsMetric then begin
      SizeCMs := InchesToMillimeters(FSizeInches) / 10.0;
      for I := 1 to Trunc(SizeCMs * 4) do begin
        BasePos := Round(I * rPixelsPerCM / 4) - FStartPosition;
        if BasePos > 0 then begin
          if I mod 4 = 0 then begin
            NumStr := IntToStr(I div 4);
            if Length(NumStr) = 1 then
              Offset := 2
            else
              Offset := 5;
            Canvas.TextOut(BasePos - Offset, 1, IntToStr(I div 4))
          end else if I mod 2 = 0 then
            Canvas.TextOut(BasePos - 2, 1, '+')
          else
            Canvas.Pixels[BasePos, 8] := clBlack;
        end;
      end;  { for }
    end else begin
      for I := 1 to Trunc(FSizeInches * 10) do begin
        BasePos := Round(I * rPixelsPerInch / 10) - FStartPosition;
        if BasePos > 0 then begin
          if I mod 10 = 0 then begin
            NumStr := IntToStr(I div 10);
            if Length(NumStr) = 1 then
              Offset := 3
            else
              Offset := 7;
            Canvas.TextOut(BasePos - Offset, 1, IntToStr(I div 10))
          end else if I mod 5 = 0 then
            Canvas.TextOut(BasePos - 3, 1, '+')
          else
            Canvas.Pixels[BasePos, 8] := clBlack;
        end;
      end;  
    end;
    Canvas.Pen.Color := clHighlight;
    Canvas.Pen.Width := 2;
    MarkPos := FLoMarkPosition - FStartPosition;
    if MarkPos >= 0 then
      with Canvas do begin
        MoveTo(MarkPos, 0);
        LineTo(MarkPos, Height);
      end;
    MarkPos := FHiMarkPosition - FStartPosition;
    if MarkPos >= 0 then
      with Canvas do begin
        MoveTo(MarkPos, 0);
        LineTo(MarkPos, Height);
      end;
  end else begin
    if FIsMetric then begin
      SizeCMs := InchesToMillimeters(FSizeInches) / 10.0;
      for I := 1 to Trunc(SizeCMs * 4) do begin
        BasePos := Round(I * rPixelsPerCM / 4) - FStartPosition;
        if BasePos > 0 then begin
          if I mod 4 = 0 then begin
            NumStr := IntToStr(I div 4);
            if Length(NumStr) = 1 then
              Offset := 4                        
            else
              Offset := 1;
            Canvas.TextOut(Offset, BasePos - 6, IntToStr(I div 4))
          end else if I mod 2 = 0 then
            Canvas.TextOut(4, BasePos - 7, '+')
          else
            Canvas.Pixels[7, BasePos] := clBlack;
        end;
      end;  { for }
    end else begin
      for I := 1 to Trunc(FSizeInches * 10) do begin
        BasePos := Round(I * rPixelsPerInch / 10) - FStartPosition;
        if BasePos > 0 then begin
          if I mod 10 = 0 then begin
            NumStr := IntToStr(I div 10);
            if Length(NumStr) = 1 then
              Offset := 4
            else
              Offset := 1;
            Canvas.TextOut(Offset, BasePos - 6, IntToStr(I div 10))
          end else if I mod 5 = 0 then
            Canvas.TextOut(4, BasePos - 7, '+')
          else
            Canvas.Pixels[7, BasePos] := clBlack;
        end;
      end;
    end;
    Canvas.Pen.Color := clHighlight;
    Canvas.Pen.Width := 2;
    MarkPos := FLoMarkPosition - FStartPosition;
    if MarkPos >= 0 then
      with Canvas do begin
        MoveTo(0, MarkPos);
        LineTo(Width, MarkPos);
      end;
    MarkPos := FHiMarkPosition - FStartPosition;
    if MarkPos >= 0 then
      with Canvas do begin
        MoveTo(0, MarkPos);
        LineTo(Width, MarkPos);
      end;
  end;
end;  { Paint }

procedure TRuler.SetSizePixels(ASizePixels : Integer);
var
  SizeCMs : Double;
begin
  if (ASizePixels <> FSizePixels) and (ASizePixels <> 0) then begin
    FSizePixels := ASizePixels;
    if FSizeInches = 0.0 then begin
      rPixelsPerInch := 0.0;
      rPixelsPerCM   := 0.0;
    end else begin
      SizeCMs := InchesToMillimeters(FSizeInches) / 10.0;
      rPixelsPerInch := FSizePixels / FSizeInches;
      rPixelsPerCM   := FSizePixels / SizeCMs;
    end;
    Invalidate;
  end;
end;

procedure TRuler.SetSizeInches(ASizeInches : Double);
var
  SizeCMs : Double;
begin
  if (ASizeInches <> FSizeInches) and (ASizeInches <> 0.0) then begin
    FSizeInches    := ASizeInches;
    SizeCMs        := InchesToMillimeters(FSizeInches) / 10.0;
    rPixelsPerInch := FSizePixels / FSizeInches;
    rPixelsPerCM   := FSizePixels / SizeCMs;
    Invalidate;
  end;
end;

procedure TRuler.SetIsMetric(AIsMetric : Boolean);
begin
  if AIsMetric <> FIsMetric then begin
    FIsMetric := AIsMetric;
    Invalidate;
  end;
end;

procedure TRuler.SetIsHorizontal(AIsHorizontal : Boolean);
begin
  if AIsHorizontal <> FIsHorizontal then begin
    FIsHorizontal := AIsHorizontal;
    Align := alNone;
    if FIsHorizontal then begin
      SizePixels := ctDefaultWidthPixels;
      SizeInches := ctDefaultWidthInches;
      Height     := ctDefaultHeight;
    end else begin
      SizePixels := ctDefaultHeightPixels;
      SizeInches := ctDefaultHeightInches;
      Width      := ctDefaultWidth;
    end;
  end;
end;

procedure TRuler.SetStartPosition(APosition : Integer);
begin
  if APosition <> FStartPosition then begin
    FStartPosition := APosition;
    Invalidate;
  end;
end;

procedure TRuler.SetLoMarkPosition(APosition : Integer);
begin
  if APosition <> FLoMarkPosition then begin
   FLoMarkPosition := APosition;
   Invalidate;
  end;
end;

procedure TRuler.SetHiMarkPosition(APosition : Integer);
begin
  if APosition <> FHiMarkPosition then begin
   FHiMarkPosition := APosition;
   Invalidate;
  end;
end;

procedure TRuler.SetMarkPositions(LoPosition, HiPosition : Integer);
  {-Sets the positions for drawing the low and high position marks. To
    suppress drawing the marks, set to negative value. Calling this proc
    is the same as setting the LoMarkPosition and HiMarkPosition properties,
    except this will cause only one repaint instead of two.}
begin
  if LoPosition < -1 then
    LoPosition := -1;
  if HiPosition < -1 then
    HiPosition := -1;
  if (LoPosition <> FLoMarkPosition) or (HiPosition <> FHiMarkPosition) then begin
    FLoMarkPosition := LoPosition;
    FHiMarkPosition := HiPosition;
    Invalidate;
  end;
end;

end.
