
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TCustomRVFormattedData is an ancestor class     }
{       representing RichView document linked with      }
{       RichView control. It's an ancestor of           }
{       TRichViewRVData.                                }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVCtrlData;

interface

{$I RV_Defs.inc}

uses SysUtils, Windows, Classes, Graphics, Controls, Forms,
     CRVData, CRVFData,
     RVStyle, RVScroll,
     RVItem;

type                                    
  TRVControlData = class (TCustomRVFormattedData)
    public
      TopLevelFocusedItemNo: Integer;
      TopLevelFocusedRVData: TCustomRVFormattedData;
      TabNavigation: TRVTabNavigationType;
      procedure ClearTemporal; override;
      procedure DoTabNavigation(Shift: Boolean; PrevCtrl: TWinControl);
      procedure PaintBuffered; virtual;
      procedure DrawFocusedRect(Canvas: TCanvas);
      procedure Deselect(NewPartiallySelected: TCustomRVItemInfo; MakeEvent: Boolean); override;
      procedure ExecuteFocused;
      procedure AdjustFocus(NewFocusedItemNo: Integer; TopLevelRVData: TPersistent; TopLevelItemNo: Integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      constructor Create;
  end;

implementation

{=============================== TRVControlData ===============================}
constructor TRVControlData.Create;
begin
  inherited Create;
  TabNavigation := rvtnTab;
  TopLevelFocusedItemNo := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.AdjustFocus(NewFocusedItemNo: Integer;
  TopLevelRVData: TPersistent; TopLevelItemNo: Integer);
begin
  if (TopLevelFocusedRVData<>nil) and (TopLevelFocusedItemNo>=0) and
     (TopLevelFocusedItemNo<TopLevelFocusedRVData.ItemCount) then
    TopLevelFocusedRVData.GetItem(TopLevelFocusedItemNo).ClearFocus;
  inherited AdjustFocus(NewFocusedItemNo, TopLevelRVData, TopLevelItemNo);
  TopLevelFocusedItemNo := TopLevelItemNo;
  TopLevelFocusedRVData := TCustomRVFormattedData(TopLevelRVData);
end;
{------------------------------------------------------------------------------}
function FindNextControl(ParentControl, CurControl: TWinControl;
                         GoForward: Boolean): TWinControl;
var
  i, StartIdx: Integer;
  OldCurControl: TWinControl;
  TabList: TList;
  {....................................................}
  function HasAsParent(CurControl: TWinControl): Boolean;
  begin
     while CurControl<>nil do begin
       if CurControl=OldCurControl then begin
         Result := True;
         exit;
       end;
       CurControl := CurControl.Parent;
     end;
     Result := False;
  end;
  {....................................................}
begin
  OldCurControl := CurControl;
  Result := nil;
  TabList := TList.Create;
  try
    ParentControl.GetTabOrderList(TabList);
    if TabList.Count > 0 then begin
      StartIdx := TabList.IndexOf(CurControl);
      if StartIdx = -1 then
        if GoForward then
          StartIdx := TabList.Count-1
        else
          StartIdx := 0;
      i := StartIdx;
      repeat
        if GoForward then begin
          inc(i);
          if i = TabList.Count then
            i := 0;
          end
        else begin
          if i = 0 then
            i := TabList.Count;
          dec(i);
        end;
        CurControl := TabList[i];
        if not HasAsParent(CurControl) and
           CurControl.CanFocus and CurControl.TabStop then begin
          Result := CurControl;
          break;
        end;
      until i = StartIdx;
    end;
  finally
    TabList.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.ClearTemporal;
begin
  if DrawItems<>nil then begin
    //ClearFocus;
    TopLevelFocusedItemNo := -1;
    TopLevelFocusedRVData := nil;
  end;
  inherited ClearTemporal;
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.Deselect(NewPartiallySelected: TCustomRVItemInfo;
                                  MakeEvent: Boolean);
begin
  if rvstDeselecting in State then
    exit;
  State := State + [rvstDeselecting];
  try
    ClearFocus;
    if TopLevelFocusedItemNo<>-1 then
      Invalidate;
    TopLevelFocusedItemNo := -1;
    TopLevelFocusedRVData := nil;
  finally
    State := State - [rvstDeselecting];
  end;
  inherited Deselect(NewPartiallySelected, MakeEvent);
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.DoTabNavigation(Shift: Boolean;
  PrevCtrl: TWinControl);
var ItemNo: Integer;
    Next: TWinControl;
    TopLevelItem, item: TCustomRVItemInfo;
    OldFocusedItemNo: Integer;
begin
  if rvstDoNotTab in State then begin
    Exclude(State,rvstDoNotTab);
    exit;
  end;
  if PrevCtrl<>nil then
    try
      if GetParentForm(PrevCtrl)<>GetParentForm(GetParentControl) then
        exit;
    except
      PrevCtrl := nil;
    end;
  if (FocusedItemNo<>-1) and (PrevCtrl=nil) then
    exit;
  OldFocusedItemNo := FocusedItemNo;

  if PrevCtrl<>nil then begin
    // May be focus was moved to another control inside RichView?
    if (FocusedItemNo=-1) or
       not GetItem(FocusedItemNo).OwnsControl(PrevCtrl) then
      ItemNo := FindControlItemNo(PrevCtrl)
    else
      ItemNo := FocusedItemNo;
    if ItemNo<>-1 then begin
      DrawFocusedRect(GetCanvas);
      if TopLevelFocusedRVData<>nil then
        TopLevelFocusedRVData.ClearFocus;
      FocusedItemNo := ItemNo;
      item := GetItem(ItemNo);
      item.AdjustFocusToControl(PrevCtrl, TPersistent(TopLevelFocusedRVData),TopLevelFocusedItemNo);
      if item.GetBoolValue(rvbpImmediateControlOwner) then begin
        TopLevelFocusedItemNo := ItemNo;
        TopLevelFocusedRVData := Self;
      end;
      DrawFocusedRect(GetCanvas);
    end;
  end;
  // Moving focus to next/previous focusable item
  DrawFocusedRect(GetCanvas);
 if TopLevelFocusedRVData<>nil then
   TopLevelFocusedRVData.ClearFocus;
  ItemNo := GetNextFocusedItem(FocusedItemNo, not Shift,
    TopLevelFocusedRVData, TopLevelFocusedItemNo);
  if ItemNo=-1 then begin
    TopLevelFocusedItemNo := -1;
    TopLevelFocusedRVData := nil;
  end;
  if (PrevCtrl<>GetParentControl) and (ItemNo=-1) and (FocusedItemNo=-1) then begin
    GetParentControl.SetFocus;
    exit;
  end;
  FocusedItemNo := ItemNo;
  if TopLevelFocusedItemNo<>-1 then begin
    TopLevelItem := TopLevelFocusedRVData.GetItem(TopLevelFocusedItemNo);
    TopLevelItem.Focusing;
    end
  else
    TopLevelItem := nil;
  DrawFocusedRect(GetCanvas);
  if TopLevelItem<>nil then
    with TopLevelFocusedRVData.DrawItems[TopLevelItem.DrawItemNo] do
      TopLevelFocusedRVData.ShowRectangle(Left,Top,Width,Height)
  else begin
    Next := GetParentForm(GetParentControl);
    if Next=nil then
      Next := GetParentControl.Parent;
    Next := FindNextControl(Next, GetParentControl, (not Shift));
    if Next<>nil then
      Next.SetFocus
    else if OldFocusedItemNo<>-1 then
      DoTabNavigation(Shift, GetParentControl);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.DrawFocusedRect(Canvas: TCanvas);
var i: Integer;
    item: TCustomRVItemInfo;
    x,y: Integer;
    ax, ay: Integer;
begin
  if TopLevelFocusedItemNo<>-1 then begin
    item := TopLevelFocusedRVData.GetItem(TopLevelFocusedItemNo);
    if item.GetBoolValueEx(rvbpXORFocus, GetRVStyle) then begin
      TopLevelFocusedRVData.GetOriginEx(x,y);
      GetOriginEx(ax,ay);
      Canvas.Font.Color := clBlack;
      Canvas.Brush.Style := bsSolid;
      for i := item.DrawItemNo to TopLevelFocusedRVData.DrawItems.Count-1 do begin
        if TopLevelFocusedRVData.DrawItems[i].ItemNo<>TopLevelFocusedItemNo then break;
        with TopLevelFocusedRVData.DrawItems[i] do
          GetRVStyle.GraphicInterface.DrawFocusRect(Canvas,
            Bounds(x+Left-GetHOffs-1-ax,y+Top-GetVOffs-1-ay,Width+2,Height+2));
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.ExecuteFocused;
begin
  if TopLevelFocusedRVData<>nil then
    TopLevelFocusedRVData.GetItem(TopLevelFocusedItemNo).Execute(Self);
end;
{------------------------------------------------------------------------------}
procedure TRVControlData.PaintBuffered;
var r,r2: TRect;
    OldPalette: HPALETTE;
    MemBitmap, OldBitmap: HBITMAP;
    MemDC: HDC;
    BufferCanvas: TCanvas;
    errmsg: String;
    error: Boolean;
    Canvas: TCanvas;
begin
  if (rvstSkipFormatting in State) or
     (rvstFormattingPart in GetAbsoluteRootData.State) then
    exit;
  Canvas := GetCanvas;
  r := Canvas.ClipRect;
  DrawFocusedRect(Canvas);
  {$IFNDEF RVDONOTUSEDRAGDROP}
  DrawDragDropCaret(Canvas, False);
  {$ENDIF}
  with r do
    MemBitmap := CreateCompatibleBitmap(Canvas.Handle, Right-Left, Bottom-Top);
  MemDC := CreateCompatibleDC(0);
  OldBitmap := SelectObject(MemDC, MemBitmap);
  if GetRVPalette<>0 then begin
    OldPalette := SelectPalette(MemDC, GetRVPalette, False);
    RealizePalette(MemDC);
    end
  else
    OldPalette := 0;
  BufferCanvas := TCanvas.Create;
  BufferCanvas.Handle := MemDC;
  if GetRVStyle<>nil then
    DrawBackground(BufferCanvas, r, GetRVStyle.GraphicInterface);
  r2 := r;
  error := False;
  errmsg := '';
  try
    PaintTo(BufferCanvas, r2, False, False, False, False, 0, 0, 0, ItemCount-1);
  except
    on E: Exception do begin
      error := True;
      errmsg := E.Message;
    end;
  end;
  with r do
    BitBlt(Canvas.Handle, Left, Top, Right-Left, Bottom-Top, MemDC, 0, 0, SRCCOPY);
  if GetRVPalette<>0 then
    SelectPalette(MemDC, OldPalette, True);
  SelectObject(MemDC, OldBitmap);
  BufferCanvas.Handle := 0;
  BufferCanvas.Free;
  DeleteDC(MemDC);
  DeleteObject(MemBitmap);

  if error then begin
    with Canvas.Font do begin
      Name := 'Arial';
      Size := 10;
      Color := clRed;
      Style := [];
    end;
    Canvas.Brush.Color := clWhite;
    Canvas.TextOut(0,0,'Error:'+errmsg);
  end;
  {$IFNDEF RVDONOTUSEDRAGDROP}
  DrawDragDropCaret(Canvas, False);
  {$ENDIF}
  DrawFocusedRect(Canvas);

end;
{------------------------------------------------------------------------------}
procedure TRVControlData.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  DrawFocusedRect(GetCanvas);
  inherited MouseUp(Button, Shift, X, Y);
  DrawFocusedRect(GetCanvas);
end;

end.
