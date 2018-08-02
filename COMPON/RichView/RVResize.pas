
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVItemResizer: helps to resize RichView        }
{       item.                                           }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVResize;

interface

uses Windows, Classes, Graphics, Controls, DLines, RVItem, RVGrIn;

type

  TRVResizeHandleIndex = (rvrhLeftTop, rvrhRightTop, rvrhRightBottom, rvrhLeftBottom,
    rvrhTop, rvrhRight, rvrhBottom, rvrhLeft);

  TRVResizeHandlesPosition = (rvhpInside, rvhpOutside);

  TRVItemResizer = class
    private
      FWidth, FHeight: Integer;
      FDrawItem: TRVDrawLineInfo;
      FBorderWidth, FBorderHeight: Integer;
      FDrawItemNo, FItemNo: Integer;
      FDragging, FDragCancelled: Boolean;
      FDx, FDy: Integer;
      FDragRect: TRect;
      FDraggedResizeHandle: TRVResizeHandleIndex;
      FItem: TCustomRVItemInfo;
      FPosition: TRVResizeHandlesPosition;
      function IsCornerResizeHandle(Index: TRVResizeHandleIndex): Boolean;
      procedure GetResizeHandleShift(Index: TRVResizeHandleIndex; var DX, DY: Integer);
    public
      constructor Create(ADrawItem: TRVDrawLineInfo; AItem: TCustomRVItemInfo;
        ADrawItemNo, ABorderWidth, ABorderHeight: Integer);
      procedure Draw(Canvas: TCanvas; HOffs, VOffs: Integer;
        GraphicInterface: TRVGraphicInterface);
      procedure GetResizeHandleCoords(Index: TRVResizeHandleIndex; Shifted: Boolean; var X, Y: Integer);
      function GetResizeHandleAt(X, Y, HOffs, VOffs: Integer;
        var Index: TRVResizeHandleIndex): Boolean;
      function MouseDown(X, Y, HOffs, VOffs: Integer): Boolean;
      procedure MouseUp(X, Y, HOffs, VOffs: Integer);

      procedure DragTo(Shift: TShiftState; X, Y, HOffs, VOffs: Integer);
      function GetResizeHandleCursor(Index: TRVResizeHandleIndex): TCursor;
      procedure XorDrawing(Canvas: TCanvas; HOffs, VOffs: Integer);
      procedure CancelDrag;
      procedure UpdateItem(ADrawItem: TRVDrawLineInfo;
        AItem: TCustomRVItemInfo; ADrawItemNo, ABorderWidth, ABorderHeight: Integer);
      property Dragging: Boolean read FDragging;
      property DragCancelled: Boolean read FDragCancelled;
      property ItemNo: Integer read FItemNo;
      property DrawItemNo: Integer read FDrawItemNo;
      property DrawItem: TRVDrawLineInfo read FDrawItem;
      property Width: Integer read FWidth;
      property Height: Integer read FHeight;
      property Position: TRVResizeHandlesPosition read FPosition write FPosition;
  end;

const
  RichViewResizeHandleSize = 6; // must be even number

implementation
uses RVERVData;

{============================== TRVItemResizer ================================}
constructor TRVItemResizer.Create(ADrawItem: TRVDrawLineInfo;
  AItem: TCustomRVItemInfo; ADrawItemNo, ABorderWidth, ABorderHeight: Integer);
begin
  inherited Create;
  UpdateItem(ADrawItem, AItem, ADrawItemNo, ABorderWidth, ABorderHeight);
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.UpdateItem(ADrawItem: TRVDrawLineInfo;
  AItem: TCustomRVItemInfo; ADrawItemNo, ABorderWidth, ABorderHeight: Integer);
begin
  FDrawItem := ADrawItem;
  FDrawItemNo := ADrawItemNo;
  FWidth := FDrawItem.ObjectWidth;
  FHeight := FDrawItem.ObjectHeight;
  FItemNo := FDrawItem.ItemNo;
  FItem := AItem;
  FBorderWidth := ABorderWidth;
  FBorderHeight := ABorderHeight;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.Draw(Canvas: TCanvas; HOffs, VOffs: Integer;
  GraphicInterface: TRVGraphicInterface);
  {.................................................}
  procedure DrawResizeHandle(X,Y: Integer);
  var size: Integer;
  begin
    size := RichViewResizeHandleSize;
    dec(X, size div 2);
    dec(Y, size div 2);
    Canvas.Pen.Mode  := pmCopy;
    GraphicInterface.Rectangle(Canvas, X,Y,X+size,Y+size);
    inc(X);
    inc(Y);
    dec(size,2);
    Canvas.Pen.Mode  := pmNot;
    while size>1 do begin
      GraphicInterface.Rectangle(Canvas, X,Y,X+size,Y+size);
      inc(X);
      inc(Y);
      dec(size,2);
    end;
  end;
  {.................................................}
var i: TRVResizeHandleIndex;
   Left, Top, X, Y: Integer;
begin
   Left := FDrawItem.ObjectLeft-HOffs;
   Top  := FDrawItem.ObjectTop -VOffs;
   Canvas.Pen.Width := 1;
   Canvas.Pen.Color := clBlack;
   Canvas.Pen.Style := psSolid;
   Canvas.Brush.Style := bsClear;
   for i := Low(TRVResizeHandleIndex) to High(TRVResizeHandleIndex) do begin
     GetResizeHandleCoords(i, True, X, Y);
     DrawResizeHandle(Left+X,Top+Y);
   end;
   Canvas.Pen.Mode  := pmCopy;
end;
{------------------------------------------------------------------------------}
function TRVItemResizer.GetResizeHandleAt(X, Y, HOffs, VOffs: Integer;
  var Index: TRVResizeHandleIndex): Boolean;
var i: TRVResizeHandleIndex;
    HX, HY, Delta: Integer;
begin
  dec(X, FDrawItem.ObjectLeft-HOffs);
  dec(Y, FDrawItem.ObjectTop-VOffs);
  Delta := (RichViewResizeHandleSize+1) div 2;
  for i := Low(TRVResizeHandleIndex) to High(TRVResizeHandleIndex) do begin
    GetResizeHandleCoords(i, True, HX, HY);
    Result := (abs(HX-X)<=Delta) and (abs(HY-Y)<=Delta);
    if Result then begin
      Index := i;
      exit;
    end;
  end;
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.GetResizeHandleCoords(Index: TRVResizeHandleIndex;
  Shifted: Boolean; var X, Y: Integer);
var DX, DY: Integer;
begin
  case Index of
    rvrhLeftTop:
      begin
        X := 0;
        Y := 0;
      end;
    rvrhRightTop:
      begin
        X := FWidth;
        Y := 0;
      end;
    rvrhRightBottom:
      begin
        X := FWidth;
        Y := FHeight;
      end;
    rvrhLeftBottom:
      begin
        X := 0;
        Y := FHeight;
      end;
    rvrhTop:
      begin
        X := FWidth div 2;
        Y := 0;
      end;
    rvrhRight:
      begin
        X := FWidth;
        Y := FHeight div 2;
      end;
    rvrhBottom:
      begin
        X := FWidth div 2;
        Y := FHeight;
      end;
    rvrhLeft:
      begin
        X := 0;
        Y := FHeight div 2;
      end;
  end;
  if Shifted then begin
    GetResizeHandleShift(Index, DX, DY);
    inc(X, DX);
    inc(Y, DY);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.GetResizeHandleShift(Index: TRVResizeHandleIndex;
  var DX, DY: Integer);
var delta: Integer;
    APosition: TRVResizeHandlesPosition;
begin
  APosition := Position;
  if (FWidth<RichViewResizeHandleSize*2) or
     (FHeight<RichViewResizeHandleSize*2) then
    APosition := rvhpOutside;
  case APosition of
    rvhpInside:
      delta := RichViewResizeHandleSize div 2;
    rvhpOutside:
      delta := -RichViewResizeHandleSize div 2;
    else
      delta := 0;
  end;
  case Index of
    rvrhLeft, rvrhLeftTop, rvrhLeftBottom:
      DX := delta;
    rvrhRight, rvrhRightTop, rvrhRightBottom:
      DX := -delta;
    else
      DX := 0;
  end;
  case Index of
    rvrhLeftTop, rvrhRightTop, rvrhTop:
      DY := delta;
    rvrhLeftBottom, rvrhRightBottom, rvrhBottom:
      DY := -delta;
    else
      DY := 0;
  end;
end;
{------------------------------------------------------------------------------}
function TRVItemResizer.GetResizeHandleCursor(
  Index: TRVResizeHandleIndex): TCursor;
begin
  case Index of
    rvrhLeftTop, rvrhRightBottom:
      Result := crSizeNWSE;
    rvrhRightTop, rvrhLeftBottom:
      Result := crSizeNESW;
    rvrhTop, rvrhBottom:
      Result := crSizeNS;
    else
      Result := crSizeWE;
  end;
end;
{------------------------------------------------------------------------------}
function TRVItemResizer.MouseDown(X, Y, HOffs, VOffs: Integer): Boolean;
var Index: TRVResizeHandleIndex;
    HX, HY: Integer;
begin
  Result := GetResizeHandleAt(X, Y, HOffs, VOffs, Index);
  if not Result then
    exit;
  FDragging := True;
  FDraggedResizeHandle := Index;
  GetResizeHandleCoords(Index, False, HX, HY);
  dec(X, FDrawItem.ObjectLeft-HOffs);
  dec(Y, FDrawItem.ObjectTop-VOffs);
  FDx := X-HX;
  FDy := Y-HY;
  FDragRect := Rect(0,0,FDrawItem.ObjectWidth, FDrawItem.ObjectHeight);
  FDragCancelled := False;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.DragTo(Shift: TShiftState; X, Y, HOffs, VOffs: Integer);
  {........................................}
  procedure AdjustRect(L,T,R,B: Boolean);
  var XRatio, YRatio: Double;
      Delta: Integer;
      OriginalWidth, OriginalHeight: Integer;
  begin
    with FDragRect do begin
      if (Left>=Right-1) then begin
        if L then
          Left := Right-2;
        if R then
          Right := Left+2;
      end;
      if (Top>=Bottom-1) then begin
        if T then
          Top := Bottom-2;
        if B then
          Bottom := Top+2;
      end;
      if ssCtrl in Shift then begin
        if L then
          Right := FDrawItem.ObjectWidth-Left;
        if T then
          Bottom := FDrawItem.ObjectHeight-Top;
        if R then
          Left := FDrawItem.ObjectWidth-Right;
        if B then
          Top := FDrawItem.ObjectHeight-Bottom;
      end;
      if (ssShift in Shift) or
         (RichViewEditDefaultProportionalResize and IsCornerResizeHandle(FDraggedResizeHandle)) then begin
        OriginalWidth  := FDrawItem.ObjectWidth;
        OriginalHeight := FDrawItem.ObjectHeight;
        if FItem is TRVRectItemInfo then begin
          dec(OriginalWidth, FBorderWidth*2);
          dec(OriginalHeight, FBorderHeight*2);          
        end;
        if (OriginalWidth>0) and (OriginalHeight>0) then begin
          XRatio := (Right-Left)/OriginalWidth;
          YRatio := (Bottom-Top)/OriginalHeight;
          if XRatio>YRatio then begin
            Delta := Round(XRatio*OriginalHeight)-(Bottom-Top);
            if ssCtrl in Shift then begin
              dec(Top, Delta div 2);
              inc(Bottom, Delta div 2);
              end
            else if T then
              dec(Top, Delta)
            else
              inc(Bottom, Delta);
            end
          else begin
            Delta := Round(YRatio*OriginalWidth)-(Right-Left);
            if ssCtrl in Shift then begin
              dec(Left, Delta div 2);
              inc(Right, Delta div 2);
              end
            else if L then
              dec(Left, Delta)
            else
              inc(Right, Delta);
          end;
        end;
      end;
    end;
  end;
  {........................................}
begin
  dec(X, FDx);
  dec(Y, FDy);
  dec(X, FDrawItem.ObjectLeft-HOffs);
  dec(Y, FDrawItem.ObjectTop-VOffs);
  FDragRect := Rect(0,0,FDrawItem.ObjectWidth, FDrawItem.ObjectHeight);
  case FDraggedResizeHandle of
    rvrhLeftTop:
      begin
        FDragRect.Left := X;
        FDragRect.Top  := Y;
        AdjustRect(True, True, False, False);
      end;
    rvrhRightTop:
      begin
        FDragRect.Right := X;
        FDragRect.Top  := Y;
        AdjustRect(False, True, True, False);
      end;
    rvrhRightBottom:
      begin
        FDragRect.Right := X;
        FDragRect.Bottom  := Y;
        AdjustRect(False, False, True, True);
      end;
    rvrhLeftBottom:
      begin
        FDragRect.Left := X;
        FDragRect.Bottom  := Y;
        AdjustRect(True, False, False, True);        
      end;
    rvrhTop:
      begin
        FDragRect.Top  := Y;
        AdjustRect(False, True, False, False);
      end;
    rvrhRight:
      begin
        FDragRect.Right := X;
        AdjustRect(False, False, True, False);
      end;
    rvrhBottom:
      begin
        FDragRect.Bottom  := Y;
        AdjustRect(False, False, False, True);
      end;
    rvrhLeft:
      begin
        FDragRect.Left := X;
        AdjustRect(True, False, False, False);
      end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.XorDrawing(Canvas: TCanvas; HOffs, VOffs: Integer);
begin
  with Canvas do begin
    Pen.Mode := pmNot;
    Pen.Width := 1;
    Brush.Style := bsClear;
    Pen.Style := psDot;
    with FDragRect do
      Rectangle(FDrawItem.ObjectLeft+Left-HOffs,
        FDrawItem.ObjectTop+Top-VOffs,
        FDrawItem.ObjectLeft+Right-HOffs,
        FDrawItem.ObjectTop+Bottom-VOffs);
    Pen.Mode := pmCopy;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.MouseUp(X, Y, HOffs, VOffs: Integer);
begin
  if not FDragCancelled then begin
    FWidth := FDragRect.Right-FDragRect.Left;
    FHeight := FDragRect.Bottom-FDragRect.Top;
  end;
  FDragging := False;
  FDragCancelled := False;
end;
{------------------------------------------------------------------------------}
procedure TRVItemResizer.CancelDrag;
begin
  FDragging := False;
  FDragCancelled := True;
end;
{------------------------------------------------------------------------------}
function TRVItemResizer.IsCornerResizeHandle(Index: TRVResizeHandleIndex): Boolean;
begin
  Result := Index in [rvrhLeftTop, rvrhRightTop, rvrhRightBottom, rvrhLeftBottom];
end;

end.
