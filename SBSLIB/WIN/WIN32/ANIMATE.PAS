unit ANIMATE;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, ExtCtrls, Dialogs;

type
  TAnimated = class(TGraphicControl)
  private
    FBitMap, TransparentBitmap : TBitmap;
    FFrameCount : integer;
    FFrame : Integer;
    Timer : TTimer;
    FInterval : integer;
    FLoop : boolean;
    FReverse : boolean;
    FPlay : boolean;
    FTransparentColor : TColor;
    FOnChangeFrame : TNotifyEvent;
    FVersion : string;
    procedure SetFrame(Value : Integer);
    procedure SetInterval(Value : integer);
    procedure SetBitMap(Value : TBitMap);
    procedure SetPlay(Onn : boolean);
    procedure SetTransparentColor(Value : TColor);
    procedure MakeTransparent;
  protected
    procedure Paint; override;
    procedure TimeHit(Sender : TObject);
  public
    BRect : TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Interval : integer read FInterval write SetInterval;
    {Note: FrameCount must precede Frame in order for initialization to be correct}
    property FrameCount : integer read FFrameCount write FFrameCount default 1;
    property Frame : Integer read FFrame write SetFrame;
    property BitMap : TBitMap read FBitMap write SetBitMap;
    property Play : boolean read FPlay write SetPlay;
    property Reverse: boolean read FReverse write FReverse;
    property Loop: boolean read FLoop write FLoop default True;
    property TransparentColor : TColor read FTransparentColor
             write SetTransparentColor default -1;
    property Height default 100;
    property Width default 100;
    property Version : string read FVersion write FVersion;
    property OnChangeFrame: TNotifyEvent read FOnChangeFrame
                            write FOnChangeFrame;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Visible;
  end;

{procedure Register;}

implementation

constructor TAnimated.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64;
  Height := 47;
  FBitMap := TBitMap.Create;
  TransparentBitmap := TBitMap.Create;
  FrameCount := 1;
  ControlStyle := ControlStyle +[csOpaque];
  FLoop := True;
  FTransparentColor := -1;
  FVersion := '1.29b';
  FInterval := 100;
  FFrameCount := 29;
{  MakeTransparent;}
end;

destructor TAnimated.Destroy;
begin
  Timer.Free;
  FBitMap.Free;
  TransparentBitmap.Free;
  inherited Destroy;
end;

procedure TAnimated.SetBitMap(Value : TBitMap);
begin
  FBitMap.Assign(Value);
  Height := FBitMap.Height;
  if Height = 0 then Height := 30;  {so something will display}
end;

procedure TAnimated.MakeTransparent;
var
  ARect : TRect;
  TmpBitmap : TBitMap;
begin
  TmpBitmap := TBitmap.Create;
  TmpBitmap.Height := FBitmap.Height;
  TmpBitmap.Width := FBitmap.Width;
  ARect := Rect(0,0,FBitmap.Width,FBitmap.Height);
  TmpBitmap.Canvas.Brush.Color := clbtnFace;
  TmpBitmap.Canvas.BrushCopy(ARect, FBitmap, ARect, FTransparentColor);
  TransparentBitmap.Assign(TmpBitmap);
  TmpBitmap.Free;
end;

procedure TAnimated.SetInterval(Value : Integer);
begin
  if Value <> FInterval then begin
    Timer.Free;
    Timer := nil;
    if FPlay and (Value > 0) then begin
      Timer := TTimer.Create(Self);
      Timer.Interval := Value;
      Timer.OnTimer := TimeHit;
    end;{if}
    FInterval := Value;
  end;{if}
end;

procedure TAnimated.SetPlay(Onn : boolean);
begin
  if Onn <> FPlay then begin
    FPlay := Onn;
    if not Onn then
      begin
        Timer.Free;
        Timer := Nil;
      end
    else if FInterval > 0 then begin
      Timer := TTimer.Create(Self);
      Timer.Interval := FInterval;
      Timer.OnTimer := TimeHit;
    end;{if}
  end;{if}
end;

procedure TAnimated.SetFrame(Value : Integer);
var
  Temp : Integer;
begin
  if Value < 0 then Temp := FFrameCount - 1
  else Temp := Value Mod FFrameCount;

  if Temp <> FFrame then begin
    FFrame := Temp;
    if Assigned(FOnChangeFrame) then FOnChangeFrame(Self);
    Invalidate;
  end;{if}
end;

procedure TAnimated.SetTransparentColor(Value : TColor);
begin
  if Value <> FTransparentColor then begin
    FTransparentColor := Value;
    Invalidate;
    MakeTransparent;
  end;{if}
end;

procedure TAnimated.TimeHit(Sender : TObject);

  procedure ChkStop;
  begin
  if not FLoop then
    begin
    FPlay := False;
    Timer.Free;
    Timer := Nil;
    end;
  end;{ChkStop}

begin
  if FReverse then
    begin
      Frame := Frame-1;
      if FFrame = 0 then ChkStop;
    end
  else begin
    Frame := Frame+1;
    if FFrame = FrameCount-1 then ChkStop;
  end;
end;

procedure TAnimated.Paint;
var
  ARect : TRect;
  X : Integer;
begin
  ARect := Rect(0,0,Width,Height);
  if TransparentBitmap.Height > 0 then
    begin
      X := Width*FFrame;
      BRect := Rect(X,0, X+Width, Height);
      Canvas.CopyRect(ARect, TransparentBitmap.Canvas, BRect);
    end
  else begin   {fill with something}
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(BoundsRect);
  end;{if}

  if csDesigning in ComponentState then begin
    {to add visibility when designing}
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end;{if}
end;

{procedure Register;
begin
  RegisterComponents('Samples', [TAnimated]);
end;}

end.
