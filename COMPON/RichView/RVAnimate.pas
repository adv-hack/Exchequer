{*******************************************************}
{                                                       }
{       RichView                                        }
{       Displaying animations in TRichView.             }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

{$I RV_Defs.inc}

unit RVAnimate;

interface

{$IFNDEF RVDONOTUSEANIMATION}

uses Classes, Windows, Graphics, Controls,
     DLines, RVItem, CRVFData, RVStyle;

type
  TRVAnimatorList = class;

  { ---------------------------------------------------------------------------
    TRVAnimator: abstract base class for all animators in TRichView
  }
  TRVAnimator = class
    private
      List: TRVAnimatorList;
    protected
      FrameIndex: Integer;
      Item: TCustomRVItemInfo;
      Interval: Integer;
      function GetFrameCount: Integer; virtual; abstract;
      function IsVisible: Boolean;
      procedure CalcNextFrameIndex;
      procedure DrawFrame;
      procedure ResetBackground; virtual;
    public
      RVData: TCustomRVFormattedData;    
      constructor Create(ARVData: TCustomRVFormattedData; AItem: TCustomRVItemInfo);
      procedure Update(ARVData: TCustomRVFormattedData; AItem: TCustomRVItemInfo);
      destructor Destroy; override;
      procedure Reset; virtual; abstract;
      procedure ChangeFrame; virtual; abstract;
      procedure Draw(X, Y: Integer; Canvas: TCanvas; Animation: Boolean); virtual; abstract;
      function GetExportImageSize: TSize; virtual;
      procedure DrawForExport(Canvas: TCanvas); virtual; abstract;
      function ExportIgnoresScale: Boolean; virtual;
  end;
  { ---------------------------------------------------------------------------
    TRVAnimatorList: list of animators (classes inherited from TRVAnimator).
    An object of this class is contained in TRichViewRVData (FAnimatorList) for
    root richviews.
  }
  TRVAnimatorList = class (TList)
    public
      Active: Boolean;
      LastMinInterval,
      MinInterval: Integer;
      constructor Create;
      destructor Destroy; override;
      procedure TimerEvent;
      procedure Clear; {$IFDEF RICHVIEWDEF4}override;{$ENDIF}
      procedure FreeAnimators;
      procedure Reset;
      procedure Add(var Item: TRVAnimator);
      procedure ResetBackground;
  end;
  { ---------------------------------------------------------------------------
    TRVBitmapAnimator: displaying animations for bitmaps.
    The source bitmap is sliced into frames (ImageWidth x ImageHeight).
    This animator is created for graphic items having nonzero Interval property
    (interval is a time to display one frame, in 1/100 sec.)
  }
  TRVBitmapAnimator = class (TRVAnimator)
    protected
      function GetFrameCount: Integer; override;
    public
      procedure Reset; override;
      procedure ChangeFrame; override;
      procedure Draw(X, Y: Integer; Canvas: TCanvas; Animation: Boolean); override;
      procedure DrawForExport(Canvas: TCanvas); override;
      function ExportIgnoresScale: Boolean; override;
  end;

  { Type of procedure to create animators }
  TRVMakeAnimatorProc = procedure (item: TCustomRVItemInfo; RVData: TCustomRVFormattedData;
      var anim: TRVAnimator);
  { Variable pointing to such procedure }
  var RV_MakeAnimator: TRVMakeAnimatorProc;

  { Maximal possible number of animations in one richview }
const RVMaxAnimations: Integer = 100000;

{$ENDIF}

implementation

{$IFNDEF RVDONOTUSEANIMATION}
uses RichView;
{================================== TRVAnimator ===============================}
{ Constructor }
constructor TRVAnimator.Create(ARVData: TCustomRVFormattedData; AItem: TCustomRVItemInfo);
begin
  inherited Create;
  Update(ARVData, AItem);
end;
{------------------------------------------------------------------------------}
{ Destructor. Removes itself from the list. }
destructor TRVAnimator.Destroy;
begin
  if List<>nil then begin
    List.Remove(Self);
    if List.Count=0 then
      List.Active := False;
  end;
  inherited;
end;
{------------------------------------------------------------------------------}
{ Advances FrameIndex }
procedure TRVAnimator.CalcNextFrameIndex;
begin
  inc(FrameIndex);
  if FrameIndex>=GetFrameCount then
    FrameIndex := 0;
end;
{------------------------------------------------------------------------------}
{ Returns image size used when exporting to RTF }
function TRVAnimator.GetExportImageSize: TSize;
begin
  Result.cx := Item.GetImageWidth(RVData.GetRVStyle);
  Result.cy := Item.GetImageHeight(RVData.GetRVStyle);
end;
{------------------------------------------------------------------------------}
{ Returns True if RTF export must ignore ImageWidth and ImageHeight item
  properties }
function TRVAnimator.ExportIgnoresScale: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
{ Sets new values of RVData and Item.
  If ARVData parameter = nil, it's not changed. }
procedure TRVAnimator.Update(ARVData: TCustomRVFormattedData; AItem: TCustomRVItemInfo);
begin
  if ARVData<>nil then
    RVData := ARVData;
  Item  := AItem;
end;
{------------------------------------------------------------------------------}
{ Draws the current frame of animation }
procedure TRVAnimator.DrawFrame;
var x,y: Integer;
    ditem: TRVDrawLineInfo;
    Ctrl: TControl;
begin
  RVData.GetOrigin(x,y);
  Ctrl := RVData.GetParentControl;
  if (Item.DrawItemNo<0) or (Item.DrawItemNo>=TCustomRVFormattedData(RVData.GetRVData).DrawItems.Count) then
    exit;
  ditem := TCustomRVFormattedData(RVData.GetRVData).DrawItems[Item.DrawItemNo];
  inc(x, ditem.ObjectLeft-TCustomRichView(Ctrl).HScrollPos);
  inc(y, ditem.ObjectTop-TCustomRichView(Ctrl).VScrollPos*TCustomRichView(Ctrl).VSmallStep);
  Draw(
    x+RVData.GetRVStyle.GetAsPixels(item.GetBorderWidth),
    y+RVData.GetRVStyle.GetAsPixels(item.GetBorderHeight),
    TCustomRichView(Ctrl).Canvas, True);
end;
{------------------------------------------------------------------------------}
{ A place to invalidate stored background images. }
procedure TRVAnimator.ResetBackground;
begin

end;
{------------------------------------------------------------------------------}
{ Is this animation visible? }
function TRVAnimator.IsVisible: Boolean;
var x,y,h: Integer;
    Ctrl: TControl;
begin
  RVData.GetOrigin(x,y);
  Ctrl := RVData.GetRootData.GetParentControl;
  if (Item.DrawItemNo<0) or (Item.DrawItemNo>=TCustomRVFormattedData(RVData.GetRVData).DrawItems.Count) then begin
    Result := False;
    exit;
  end;
  inc(y, TCustomRVFormattedData(RVData.GetRVData).DrawItems[item.DrawItemNo].ObjectTop -
   TCustomRichView(Ctrl).VScrollPos*TCustomRichView(Ctrl).VSmallStep);
  h := Ctrl.ClientHeight;
  Result := (y<h) and (y+TRVNonTextItemInfo(item).GetHeight(RVData.GetRVStyle)>0);
end;
{================================ TRVAnimatorList =============================}
{ Constructor }
constructor TRVAnimatorList.Create;
begin
  inherited Create;
  LastMinInterval := MaxInt;
  MinInterval     := MaxInt;
end;
{ Destructor }
destructor TRVAnimatorList.Destroy;
begin
  Clear;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Adds a new item.
  If the number of items exceeds the maximum, frees the Item instead. }
procedure TRVAnimatorList.Add(var Item: TRVAnimator);
begin
  if Count=RVMaxAnimations then begin
    Item.Free;
    Item := nil;
    exit;
  end;
  Item.Reset;
  if MinInterval>Item.Interval then
    MinInterval := Item.Interval;
  inherited Add(Item);
  Item.List := Self;
end;
{------------------------------------------------------------------------------}
{ Clears the list. Important: animators are not destroyed, just unlinked from
  the list. }
procedure TRVAnimatorList.Clear;
var i: Integer;
begin
  for i := 0 to Count-1 do
    TRVAnimator(Items[i]).List := nil;
  inherited Clear;
  Active := False;
end;
{------------------------------------------------------------------------------}
{ Clears the list, destroying all animators. }
procedure TRVAnimatorList.FreeAnimators;
var i: Integer;
begin
  for i := 0 to Count-1 do begin
    TRVAnimator(Items[i]).List := nil;
    TRVAnimator(Items[i]).Free;
  end;
  inherited Clear;
  Active := False;
end;
{------------------------------------------------------------------------------}
{ Calls ResetBackground of all items. }
procedure TRVAnimatorList.ResetBackground;
var i: Integer;
begin
  for i := 0 to Count-1 do
    TRVAnimator(Items[i]).ResetBackground;
end;
{------------------------------------------------------------------------------}
{ A procedure to call regularly on timer.
  It's called when MinInterval is elapsed.
  Decreases Interval of all animators by MinIterval.
  If it becomes 0, calls ChangeFrame and redraws visible animators.
  Calculates new MinInteval (min of Interval of all animators) }
procedure TRVAnimatorList.TimerEvent;
var i, Elapsed: Integer;
    Animator: TRVAnimator;
begin
  Elapsed := MinInterval;
  MinInterval := MaxInt;
  for i := 0 to Count-1 do begin
    Animator := TRVAnimator(Items[i]);
    dec(Animator.Interval, Elapsed);
    if Animator.Interval<=0 then begin
      Animator.ChangeFrame;
      if Animator.IsVisible then
        Animator.DrawFrame
      else
        Animator.ResetBackground;
    end;
    if MinInterval>Animator.Interval then
      MinInterval := Animator.Interval;
  end;
end;
{------------------------------------------------------------------------------}
{ Calls Reset for all animators. Calculates new MinInterval. }
procedure TRVAnimatorList.Reset;
var i: Integer;
    Animator: TRVAnimator;
begin
  MinInterval := MaxInt;
  for i := 0 to Count-1 do begin
    Animator := TRVAnimator(Items[i]);
    Animator.Reset;
    if MinInterval>Animator.Interval then
      MinInterval := Animator.Interval;
  end;
end;
{============================== TRVBitmapAnimator =============================}
{ Draws the current frame at (X,Y) on Canvas.
  Animation=True, if this is a drawing on timer.
  Animation=False, if this is a drawing from item.Paint. }  
procedure TRVBitmapAnimator.Draw(X, Y: Integer; Canvas: TCanvas; Animation: Boolean);
var bmp: TBitmap;
    w,h,nCols: Integer;
    RVStyle: TRVStyle;
begin
  bmp := TBitmap(TRVGraphicItemInfo(Item).ImageCopy);
  if bmp=nil then
    bmp := TBitmap(TRVGraphicItemInfo(Item).Image);
  RVStyle := RVData.GetRVStyle;
  w := TRVGraphicItemInfo(Item).GetImageWidth(RVStyle);
  h := TRVGraphicItemInfo(Item).GetImageHeight(RVStyle);
  nCols := bmp.Width div w;
  RVStyle.GraphicInterface.CopyRect(Canvas,
    Bounds(X,Y,w,h), bmp.Canvas,
    Bounds((FrameIndex mod nCols)*w, (FrameIndex div nCols)*h,w,h));
end;
{------------------------------------------------------------------------------}
{ Draws for RTF export }
procedure TRVBitmapAnimator.DrawForExport(Canvas: TCanvas);
var fi: Integer;
begin
  fi := FrameIndex;
  FrameIndex := 0;
  try
    Draw(0, 0, Canvas, False);
  finally
    FrameIndex := fi;
  end;
end;
{------------------------------------------------------------------------------}
{ RTF export must ignore image scaling }
function TRVBitmapAnimator.ExportIgnoresScale: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
{ Rewinds to the first frame. Updates Interval. }
procedure TRVBitmapAnimator.Reset;
begin
  Interval := TRVGraphicItemInfo(Item).Interval*10;
  FrameIndex := 0;
end;
{------------------------------------------------------------------------------}
{ Change frame to the next one. Updates Interval. }
procedure TRVBitmapAnimator.ChangeFrame;
begin
  Interval := TRVGraphicItemInfo(Item).Interval*10;
  CalcNextFrameIndex;
end;
{------------------------------------------------------------------------------}
{ Returns a number of frames in TRVBitmapAnimator for item } 
function GetBitmapFrameCount(item: TRVGraphicItemInfo; RVStyle: TRVStyle): Integer;
var w,h: Integer;
begin
  w := Item.GetImageWidth(RVStyle);
  h := Item.GetImageHeight(RVStyle);
  if (w=0) or (h=0) then
    Result := 0
  else
    Result := (Item.Image.Width div w)*(Item.Image.Height div h);
end;
{------------------------------------------------------------------------------}
{ Returns the count of frames }
function TRVBitmapAnimator.GetFrameCount: Integer;
begin
  Result := GetBitmapFrameCount(TRVGraphicItemInfo(Item), RVData.GetRVStyle);
end;
{==============================================================================}
{ This procedure creates an animator (anim) for the item, if it's necessary.
  Otherwise they free-and-nil anim.
  This procedure can create only TRVBitmapAnimator.
  In other units (for example, in RVGifAnimate), there may be other procedures
  creating different animators.
  They must be assigned to RV_MakeAnimator. They must do their work and call
  the previous RV_MakeAnimator, thus making a procedure chain. }
procedure RV_MakeAnimatorDef(item: TCustomRVItemInfo; RVData: TCustomRVFormattedData;
  var anim: TRVAnimator);
begin
  if item is TRVGraphicItemInfo then begin
    if (TRVGraphicItemInfo(item).Interval>0) and
       (TRVGraphicItemInfo(item).Image is TBitmap) and
       (GetBitmapFrameCount(TRVGraphicItemInfo(item), RVData.GetRVStyle)>1) then begin
        if (anim<>nil) and not (anim is TRVBitmapAnimator) then begin
          anim.Free;
          anim := nil;
        end;
        if anim=nil then begin
          anim := TRVBitmapAnimator.Create(RVData, Item);
          RVData.InsertAnimator(TObject(anim));
          end
        else if anim<>nil then begin
          anim.Update(RVData, Item);
          anim.Reset;
        end;
        exit;
    end;
  end;
  anim.Free;
  anim := nil;
end;

initialization
  RV_MakeAnimator := RV_MakeAnimatorDef;

{$ENDIF}

end.
