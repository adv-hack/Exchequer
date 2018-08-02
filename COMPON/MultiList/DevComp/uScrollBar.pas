unit uScrollBar;

interface

uses Classes, Windows, Controls, ExtCtrls, Graphics, Forms, Dialogs, StdCtrls,
     SysUtils, ImgList, Messages, GfxUtil, APIUtil, XPThemes;

type
//  TScrollType = (stNil, stFirst, stPageUp, stLineUp, stLineDown, stPageDown, stLast, stSearch);
  TSButtonType = (btTop, btPageUp, btOneUp, btOneDown, btPageDown, btBottom, btNil, btSearch);
  TDBScrollClickEvent = procedure(Sender: TObject; ScrollType: TSButtonType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;

  TColourImage = (ciLight, ciMedium, ciDark);
  TSButtonStyle = (bsXP, bsStandard);

const
  XPResNames : array[0..5] of string = ('XPTOP', 'XPPAGEUP', 'XPONEUP', 'XPONEDOWN', 'XPPAGEDOWN', 'XPBOTTOM');
  StdResNamesUp : array[0..5] of string = ('TOP1', 'PGUP1', 'ONEUP1', 'ONEDN1', 'PGDN1', 'BOT1');
  StdResNamesDown : array[0..5] of string = ('TOP2', 'PGUP2', 'ONEUP2', 'ONEDN2', 'PGDN2', 'BOT2');
  SCROLL_BAR_WIDTH = 21;

type
  TScrollButton = class(TButtonControl)
  private
    imgFace : TImage;
    bPrevEnabled  : boolean;
    FButtonType : TSButtonType;
    FButtonStyle : TSButtonStyle;
    CurrentShading : TColourImage;
    sCurrentResName : string;
    hPrevCapture : HWND;
//    FLastKeyPressed : Word;
//    FSendListKeyDown : TKeyEvent;
    CurrentShiftState : TShiftState;
    Procedure DrawImage(ciShading : TColourImage);
    procedure SetButtonType(Value: TSButtonType);
    procedure SetButtonStyle(Value: TSButtonStyle);
//  procedure SetLastKeyPressed(Value: Word);
    procedure ScrollButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ScrollButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//    procedure ScrollButtonKeyPress(Sender: TObject; var Key: Char);
    procedure ScrollButtonResize(Sender: TObject);
//    procedure ScrollButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
//    procedure OnExit;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Click; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure CNKeyDown(var Message: TWMKeyUp); message CN_KeyDown;
    procedure CNKeyUp(var Message: TWMKeyUp); message CN_KeyUp;
//    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure DoExit; override;
//    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
//    procedure KeyPress(var Key: Char); override;
    procedure CNChar(var Message: TWMChar); message CN_CHAR;
  public
    bMouseOver  :  Boolean;
    bRunningXP  :  Boolean;

    constructor Create(AOwner: TComponent; NewTag: integer); reintroduce; overload;
    destructor Destroy; override;
  published
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
//    property OnKeyDown;
    property ButtonType : TSButtonType read FButtonType write SetButtonType default btOneUp;
    property ButtonStyle : TSButtonStyle read FButtonStyle write SetButtonStyle default bsStandard;
//    property SendKeyDown: TKeyEvent read FSendListKeyDown write FSendListKeyDown;
//    property LastKeyPressed : Word read FLastKeyPressed write SetLastKeyPressed default 0;
  end;

{$R MLXPBUT.RES}
{$R MLSTDBUT.RES}

  TCustomScrollBar = class(TCustomPanel)
  private
    fControl: TWinControl;
//    fbnBlank: TScrollButton;
//  fImgBlank: TImage;
    fImgBlank: TPaintBox;
    fbnFirst: TScrollButton;
    fbnPageUp: TScrollButton;
    fbnLineUp: TScrollButton;
    fbnLineDown: TScrollButton;
    fbnPageDown: TScrollButton;
    fbnLast: TScrollButton;
//    fDefaultImages: TImageList;

    fActive: boolean;
//    fBevel: TBevelCut;
    fBorderScroll: TBorderStyle;
    fButtonColor: TColor;
    fFixedColor: TColor;
//  fImageList: TImageList;
    fLineRepeatPause: cardinal;
    fRepeatDelay: cardinal;
    fDepressed: boolean;
    fOnScrollClick: TDBScrollClickEvent;
    fButtonStyle : TSButtonStyle;
    fRunningXP : boolean;

//    procedure DepressGlyph(ScrollButton: TScrollButton);
    procedure SetControl(Control: TWinControl);
//    procedure SetBevel(Bevel: TBevelCut);
    procedure SetBorderScroll(const Value: TBorderStyle);
//    procedure SetButtonColor(ButtonColor: TColor);
    procedure SetFixedColor(FixedColor: TColor);
//    procedure SetImages(ImageList: TImageList);
//    procedure SetScrollWidth(NewWidth: integer);
    procedure InitButton(Button: TScrollButton);
    procedure ReAlignButtons;
    function GetControl: TWinControl;
//    function GetScrollWidth: integer;
//    procedure PanelKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetActive(const Value: boolean); virtual;
    procedure ScrollPanelDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure ScrollPanelUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure ScrollButtonMDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure ScrollButtonMUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
//    procedure ScrollButtonKeyPress(Sender: TObject; var Key: Char);
//    procedure ScrollButtonKDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property WinControl: TWinControl read GetControl write SetControl;
    procedure ReAlign;
    procedure ForceXP;
    procedure Invalidate; override;
  published
    property Active: boolean read fActive write SetActive default false;
//    property Bevel: TBevelCut read fBevel write SetBevel default bvNone;
    property BorderScroll: TBorderStyle read fBorderScroll write SetBorderScroll;
//    property ButtonColor: TColor read fButtonColor write SetButtonColor default clBtnFace;
    property FixedColor: TColor read fFixedColor write SetFixedColor default clBtnFace;
//    property ImageList: TImageList read fImageList write SetImages;
    property RepeatDelay: cardinal read fRepeatDelay write fRepeatDelay;
    property LineRepeatPause: cardinal read fLineRepeatPause write fLineRepeatPause;
//    property ScrollWidth: integer read GetScrollWidth write SetScrollWidth;
    property OnScrollClick: TDBScrollClickEvent read fOnScrollClick write fOnScrollClick;
    property ButtonStyle : TSButtonStyle read fButtonStyle write fButtonStyle;
    property RunningXP : boolean read fRunningXP write fRunningXP;
//    procedure PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
//    property OnKeyDown;
    procedure PaintScrollBar;
  end;

implementation
uses
  uMultiList;

constructor TScrollButton.Create(AOwner: TComponent; NewTag: integer);
begin
  inherited Create(Aowner);

  hPrevCapture := 0;
  Width := 17;
  Height := 17;
  ControlStyle := [csClickEvents, csOpaque];
  CurrentShiftState := [];
  TabStop := FALSE;
//  FLastKeyPressed := 0;

  if NewTag <> -1 then begin
    imgFace := TImage.Create(self);
    with imgFace do begin
      OnMouseMove := ImgMouseMove;
      OnMouseDown:= ScrollButtonMouseDown;
      OnMouseUp:= ScrollButtonMouseUp;
      OnResize:= ScrollButtonResize;
      Align:= alClient;
      Parent := Self;
      AutoSize := true;
      top := 0;
      left := 0;
    end;{with}
  end;{if}

  CurrentShading := ciMedium;
  sCurrentResName := '';
  bPrevEnabled := TRUE;
  bRunningXP := TCustomScrollBar(Owner).RunningXP;
  fButtonStyle := TCustomScrollBar(Owner).ButtonStyle;
//  FSendListKeyDown:=nil;

  // new
  Tag:= NewTag;
  if NewTag > 3 then Align:= alBottom else Align:= alTop;
  Case NewTag of
    -1 : ButtonType := btNil;
    1 : ButtonType := btTop;
    2 : ButtonType := btPageUp;
    3 : ButtonType := btOneUp;
    4 : ButtonType := btOneDown;
    5 : ButtonType := btPageDown;
    6 : ButtonType := btBottom;
  end;{case}
end;

procedure TScrollButton.SetButtonType(Value: TSButtonType);
begin
  FButtonType := Value;
  DrawImage(ciMedium);
end;

procedure TScrollButton.SetButtonStyle(Value: TSButtonStyle);
begin
  FButtonStyle := Value;
end;
{
procedure TScrollButton.SetLastKeyPressed(Value: Word);
begin
  FLastKeyPressed := Value;
end;
}
Procedure TScrollButton.DrawImage(ciShading : TColourImage);
var
  ARect : TRect;
  TmpBitmap : TBitMap;

  sResName : string;

  Procedure ChangeColor(const ColFrom, ColTo : TColor);
  begin
    imgFace.Picture.Bitmap.Canvas.Brush.Color := ColTo;
    imgFace.Picture.Bitmap.Canvas.BrushCopy(ARect, TmpBitmap, ARect, ColFrom);
    TmpBitmap.Canvas.CopyRect(ARect,imgFace.Picture.Bitmap.Canvas,ARect);
  end;{ChangeColor}

  Function InitialiseBitmap : boolean;
  begin
    Result := (bPrevEnabled <> Enabled) or (sCurrentResName <> sResName) or ((FButtonStyle = bsXP) and (CurrentShading <> ciShading));
    if Result then begin

      TmpBitmap := TBitmap.Create;

      CurrentShading := ciShading;
      sCurrentResName := sResName;
      bPrevEnabled := Enabled;

      TmpBitmap.LoadFromResourceName(HInstance, sResName);

//      If (bRunningXP) and (FButtonStyle <> bsXP) then
//        TmpBitmap.PixelFormat:=pf24bit; {Under XP colour replacement failed if this line not in}

      if ColorMode(imgFace.Canvas) <> cm256Colors
      then TmpBitmap.PixelFormat:=pf24bit;

      ARect := Rect(0,0,TmpBitmap.Width,TmpBitmap.Height);
      imgFace.Picture.Bitmap.Height := TmpBitmap.Height;
      imgFace.Picture.Bitmap.Width := TmpBitmap.Width;
    end;{if}
  end;{InitialiseBitmap}

begin

  if FButtonType = btNil then exit;

  case FButtonStyle of
    bsXP : begin

      sResName := XPResNames[Ord(FButtonType)];

{      case FButtonType of
        btTop : sResName := 'TOP';
        btPageUp : sResName := 'PAGEUP';
        btOneUp : sResName := 'ONEUP';
        btOneDown : sResName := 'ONEDOWN';
        btPageDown : sResName := 'PAGEDOWN';
        btBottom : sResName := 'BOTTOM';
      end;{case}

      if InitialiseBitmap then begin
        if Enabled then
          begin
//            ChangeColor(clBlack, DarkenColor(clHighLight,20), TRUE);
            ChangeColor(clBlack, DarkenColor(clHighLight,35));
            case ciShading of
              ciLight : ChangeColor(clSilver, LightenColor(clHighLight, 75));
              ciMedium : ChangeColor(clSilver, LightenColor(clHighLight, 65));
              ciDark : ChangeColor(clSilver, LightenColor(clHighLight, 55));
            end;{case}
          end
        else begin
          ChangeColor(clBlack, LightenColor(clHighLight,45));
          ChangeColor(clSilver, LightenColor(clHighLight, 75));
        end;
        ChangeColor(clGray, LightenColor(clHighLight, 50));

        TmpBitmap.Free;
        Update;
      end;{if}
    end;


    bsStandard : begin
//      if (csLButtonDown in ControlState) and bMouseOver
      if TCustomScrollBar(Owner).fDepressed {and bMouseOver}
      then sResName := StdResNamesDown[Ord(FButtonType)]
      else sResName := StdResNamesUp[Ord(FButtonType)];

{          case FButtonType of
            btTop : sResName := 'GTOP2';
            btPageUp : sResName := 'GPGUP2';
            btOneUp : sResName := 'GONEUP2';
            btOneDown : sResName := 'GONEDN2';
            btPageDown : sResName := 'GPGDN2';
            btBottom : sResName := 'GBOT2';
          end;{case}
{        end
      else begin
        case FButtonType of
          btTop : sResName := 'GTOP1';
          btPageUp : sResName := 'GPGUP1';
          btOneUp : sResName := 'GONEUP1';
          btOneDown : sResName := 'GONEDN1';
          btPageDown : sResName := 'GPGDN1';
          btBottom : sResName := 'GBOT1';
        end;{case}
{      end;{if}

      if InitialiseBitmap then begin
        if Enabled then ChangeColor(clBlack, clBtnText)
        else ChangeColor(clBlack, clGrayText);

        ChangeColor(clSilver, clBtnFace);
        ChangeColor(clAqua, DarkenColor(clBtnFace, 70));
        ChangeColor(clGray, clBtnShadow);
        ChangeColor(clWhite, clBtnHighlight);

{        if not Enabled then ChangeColor(clBlack, clBtnShadow, FALSE);
        ChangeColor(clSilver, clBtnFace, TRUE);
        ChangeColor(clAqua, DarkenColor(clBtnFace, 70), TRUE);}

  {      ChangeColor(clBlack, clRed, FALSE);
        ChangeColor(clSilver, LightenColor(clAqua, 60), FALSE);
        ChangeColor(clAqua, LightenColor(clFuchsia, 20), FALSE);
        ChangeColor(clGray, LightenColor(clYellow, 40), FALSE);
        ChangeColor(clWhite, LightenColor(clLime, 80), FALSE);}

//        ChangeColor(clGray, clBtnShadow, FALSE);
//        ChangeColor(clWhite, clBtnHighlight, FALSE);

        TmpBitmap.Free;
        {Update;}
      end;{if}
    end;

  end;{case}
end;

procedure TScrollButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'BUTTON');
  Params.Style := WS_CHILD or WS_CLIPSIBLINGS or WS_CLIPCHILDREN or BS_OWNERDRAW;
end;

procedure TScrollButton.ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  MouseMove(Shift, X, Y);
end;

procedure TScrollButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  Inherited;

  if GetCapture <> Handle then hPrevCapture := GetCapture;
  if hPrevCapture <> Handle then SetCapture(handle);



//      TForm(Owner.Owner.Owner).caption := 'SetCapture';
//    end;
//  end;{if}

//  bMouseOver := TRUE;

  if TCustomScrollBar(Owner).fDepressed then DrawImage(ciDark)
  else DrawImage(ciLight);


  if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight - 1) then
    begin
      if not bMouseOver then begin
        DrawImage(ciLight);
        bMouseOver := TRUE;
      end;{if}
    end
  else begin
    bMouseOver := FALSE;
    if GetCapture = Handle then begin
      ReleaseCapture;
      if hPrevCapture <> 0 then SetCapture(hPrevCapture);
    end;
    TCustomScrollBar(Owner).fDepressed := FALSE;
    DrawImage(ciMedium);
  end;{if}
end;

procedure TScrollButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{  if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
  Begin
    DrawImage(ciDark);
  end;}

  Inherited;
end;

procedure TScrollButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
  Begin
    DrawImage(ciDark);
  end;}

  Inherited;
end;

procedure TScrollButton.Click;
begin
  inherited;

  if GetCapture <> Handle then hPrevCapture := GetCapture;
  if hPrevCapture <> Handle then SetCapture(handle);
//  SetCapture(handle);
//  TForm(Owner.Owner.Owner).caption := 'SetCapture';
  bMouseOver := FALSE;
end;

procedure TScrollButton.SetEnabled(Value: Boolean);
begin
  If (Value<>Enabled) then
  Begin
    inherited;
    DrawImage(ciMedium);
  end;
end;

procedure TScrollButton.CNKeyDown(var Message: TWMKeyUp);
begin
{  if Tform(owner.owner.owner).activecontrol is TDBMPanel then ShowMessage('TDBMPanel');
  if Tform(owner.owner.owner).activecontrol is TDBMScrollBox then ShowMessage('TDBMScrollBox');
  if Tform(owner.owner.owner).activecontrol is TMultiList then ShowMessage('TMultiList');
  if Tform(owner.owner.owner).activecontrol is TCustomScrollBar then ShowMessage('TCustomScrollBar');
  if Tform(owner.owner.owner).activecontrol is TPanel then ShowMessage('TPanel');
  if Tform(owner.owner.owner).activecontrol is TEdit then ShowMessage('TEdit');}
//  if Tform(owner.owner.owner).activecontrol is TDBMColumns then ShowMessage('TDBMColumns');

  if (not (csDesigning in ComponentState))
//  and (Tform(owner.owner.owner).activecontrol is TScrollButton) // Stops 2 KeyDowns being sent to the list when the list is focused
    then begin
      with Message do Begin
        case CharCode of

          16 : CurrentShiftState := [ssShift];

          VK_RETURN, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR
          , VK_NEXT, VK_RIGHT, VK_LEFT, VK_ESCAPE : Begin

            TMultiList(Owner.Owner).ScrollButtonKeyDown(Self, CharCode, CurrentShiftState);

  //        SendKeyDown(Self,CharCode,[]);
  //        TForm(Owner.Owner.Owner).caption := TWincontrol(TForm(Owner.Owner.Owner).ActiveControl).Name;
  //        if Copy(TWincontrol(TForm(Owner.Owner.Owner).ActiveControl).Name, 1, 12) = 'ScrollButton'
  //        then TMultiList(Owner.Owner).ScrollButtonKeyDown(CharCode)
  //        else Inherited;
  //        TMultiList(Owner.Owner).ScrollButtonKeyDown(CharCode);
  //        Inherited;
          end;
        end;{case}
      end;{with}
    end
  else Inherited;
end;


destructor TScrollButton.Destroy;
begin
  if FButtonType <> btNil then imgFace.Free;
  inherited;
end;
{
procedure TScrollButton.ScrollButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {Scroll button Keys are passed on to the scrollbar;}
{  TCustomScrollBar(Owner).ScrollButtonKDown(Sender, Key, Shift);
end;
}
procedure TScrollButton.ScrollButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Scroll button clicks are passed on to the scrollbar;}
  TCustomScrollBar(Owner).ScrollButtonMDown(Self, Button, Shift, X, Y);
end;

procedure TScrollButton.ScrollButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Scroll button clicks are passed on to the scrollbar;}
  TCustomScrollBar(Owner).ScrollButtonMUp(Self, Button, Shift, X, Y);
end;
{
procedure TScrollButton.OnExit();
begin
end;
}
procedure TScrollButton.ScrollButtonResize(Sender: TObject);
begin
  {Ensure the scroll buttons are always square;}
//  Height:= Width;
end;
{
procedure TScrollButton.SetButtonGlyph(ButtonGlyph: TImage);
begin
  {Property setting for the scroll button's image glyph;}
{  if Assigned(ButtonGlyph) then fGlyph.Picture:= ButtonGlyph.Picture;
end;
}
//*** TScrollButton ************************************************************
(*
constructor TScrollButton.Create(AOwner: TComponent; NewTag: integer);
begin
  {Scroll buttons are panels tagged 1 to 6 according to their location down the
   scrollbar; The first three buttons are aligned to the top of the scroll bar
   and the last three to the bottom; The scroll button glyph is an image created
   on the panel and aligned to client; Click handlers are passed from the images
   to the buttons;}

  inherited Create(Aowner);

  Tag:= NewTag;
  if NewTag > 3 then Align:= alBottom else Align:= alTop;

  fGlyph:= TImage.Create(Self);
  with fGlyph do
  begin
    OnMouseDown:= ScrollButtonMouseDown;
    OnMouseUp:= ScrollButtonMouseUp;
    OnResize:= ScrollButtonResize;
    Align:= alClient;
    Parent:= Self;
  end;
end;

procedure TScrollButton.ScrollButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Scroll button clicks are passed on to the scrollbar;}
  TCustomScrollBar(Owner).ScrollButtonDown(Self, Button, Shift, X, Y);
end;

procedure TScrollButton.ScrollButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Scroll button clicks are passed on to the scrollbar;}
  TCustomScrollBar(Owner).ScrollButtonUp(Self, Button, Shift, X, Y);
end;

procedure TScrollButton.ScrollButtonResize(Sender: TObject);
begin
  {Ensure the scroll buttons are always square;}
  Height:= Width;
end;

procedure TScrollButton.SetButtonGlyph(ButtonGlyph: TImage);
begin
  {Property setting for the scroll button's image glyph;}
  if Assigned(ButtonGlyph) then fGlyph.Picture:= ButtonGlyph.Picture;
end;
*)
//*** TCustomScrollBar Create/Destroy **********************************************

constructor TCustomScrollBar.Create(AOwner: TComponent);
begin
  {Initialize variables, redirect mouse clicks, create the six scroll buttons;}

  inherited;

  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelWidth := 1;
  BorderWidth := 2;
  BorderStyle := bsNone;
//  Visible := FALSE;

  fRepeatDelay:= 200;
  fLineRepeatPause := 25;
  fButtonColor:= clBtnFace;
  fFixedColor:= clBtnFace;

  OnMouseDown:= ScrollPanelDown;
  OnMouseUp:= ScrollPanelUp;
//  OnKeyPress := ScrollButtonKeyPress;
//  OnKeyDown := ScrollButtonKDown;

//  fDefaultImages:= TImageList.Create(Self);
//  InitDefaultImages;

{  if ForceXP then
    begin
      RunningXP := TRUE;
      fButtonStyle := bsXP;
    end
  else begin}
    RunningXP := GetWindowsVersion in wvXPStyle;
    if XP_UsingThemes then fButtonStyle := bsXP
    else fButtonStyle := bsStandard;
{  end;{if}

  fImgBlank := TPaintBox.Create(Self);
//  fbnBlank:= TScrollButton.Create(Self, -1);
  fbnFirst:= TScrollButton.Create(Self, 1);
  fbnPageUp:= TScrollButton.Create(Self, 2);
  fbnLineUp:= TScrollButton.Create(Self, 3);
  fbnLineDown:= TScrollButton.Create(Self, 4);
  fbnPageDown:= TScrollButton.Create(Self, 5);
  fbnLast:= TScrollButton.Create(Self, 6);

  case ColorMode(fbnFirst.imgFace.Canvas) of
    cm16Colors, cmMonochrome : Color := clBtnFace;
    cm256Colors : Color := LightenColor(clBtnFace,31);
    else Color := LightenColor(clBtnFace,40);
  end;{case}

  fImgBlank.Parent := Self;

//  InitButton(fbnBlank);
  InitButton(fbnFirst);
  InitButton(fbnPageUp);
  InitButton(fbnLineUp);
  InitButton(fbnLineDown);
  InitButton(fbnPageDown);
  InitButton(fbnLast);

//  BorderScroll:= bsSingle;

//  SetBevel(bvNone);
  Width:= SCROLL_BAR_WIDTH;

  ReAlignButtons;
end;

procedure TCustomScrollBar.CreateParams(var Params: TCreateParams);
begin
  {To set the scrollbar border style, the window must be recreated; The
  BorderStyle is set during CreateParams;}

  if TMultiList(owner).dimensions <> nil
  then fImgBlank.Height := TMultiList(owner).dimensions.HeaderHeight + 2;

  inherited CreateParams(Params);
  if fBorderScroll = bsSingle then Params.ExStyle:= Params.ExStyle or WS_EX_CLIENTEDGE;
end;
{
procedure TCustomScrollBar.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = fImageList) then
  begin
    fImageList:= nil;
    SetImages(nil);
  end;
end;
}
//*** TCustomScrollBar Methods *****************************************************

procedure TCustomScrollBar.ReAlign;
begin
  {The scrollbar is realigned to ensure it remains further right than the
   ScrollSpace bevel;}

  Align:= alNone;
  Align:= alRight;
end;

procedure TCustomScrollBar.ReAlignButtons;
begin
  {Scroll buttons need realigning when the scrollbar width is changed;}

//  fbnBlank.Align:= alNone;
  fImgBlank.Align:= alNone;
  fbnLineUp.Align:= alNone;
  fbnPageUp.Align:= alNone;
  fbnFirst.Align:= alNone;
  fbnLineDown.Align:= alNone;
  fbnPageDown.Align:= alNone;
  fbnLast.Align:= alNone;

  fImgBlank.Align:= alTop;
//  fbnBlank.Align:= alTop;
  fbnFirst.Align:= alTop;
  fbnPageUp.Align:= alTop;
  fbnLineUp.Align:= alTop;
  fbnLast.Align:= alBottom;
  fbnPageDown.Align:= alBottom;
  fbnLineDown.Align:= alBottom;
end;

procedure TCustomScrollBar.InitButton(Button: TScrollButton);
begin
  {Redirect the click events for each button and display on the scrollbar;}

  Button.onMouseDown:= ScrollButtonMDown;
  Button.onMouseUp:= ScrollButtonMUp;
//  Button.onKeyDown:= ScrollButtonKDown;
  Button.onKeyDown := OnKeyDown;
  Button.Parent:= Self;
end;

//*** TCustomScrollBar Property Setting ********************************************

function TCustomScrollBar.GetControl: TWinControl;
begin
  if Assigned(fControl) then GetControl:= fControl else GetControl:= nil;
end;
{
function TCustomScrollBar.GetScrollWidth: integer;
begin
  // A ScrollWidth property is needed to ensure the scroll buttons are realigned when the width is changed;

  Result:= Width;
end;
}
procedure TCustomScrollBar.SetActive(const Value: boolean);
begin
  {This property set is overridden by CustomScrollBar descendants;}

  fActive:= Value;
end;
{
procedure TCustomScrollBar.SetBevel(Bevel: TBevelCut);
begin
  {The scrollbar bevel property only alters the outer bevel;

//  fBevel:= Bevel;
//  BevelOuter:= Bevel;
end;
}
procedure TCustomScrollBar.SetBorderScroll(const Value: TBorderStyle);
begin
  {To set the scrollbar border style, the window must be recreated; The
   BorderStyle is set during CreateParams;}

  fBorderScroll:= Value;
  RecreateWnd;
end;
{
procedure TCustomScrollBar.SetButtonColor(ButtonColor: TColor);
begin
  {If the scroll button colour changes, redraw all the button images;}

{  fButtonColor:= ButtonColor;
//  SetImages(fImageList);
end;
}
procedure TCustomScrollBar.SetControl(Control: TWinControl);
begin
  {The control is the scrollbar parent; The scrollbar is right aligned to the
   control;}

{  if fControl is TMultiList then showmessage('TMultiList');
  if fControl is TDBMScrollBox then showmessage('TDBMScrollBox');
  if fControl is TDBMPanel then showmessage('TDBMPanel');}

  fControl:= Control;
  if Assigned(fControl) then Parent:= fControl;
{  Top := 16;
  Left := 0;
  Height := fControl.Height - 16;
  Width := SCROLL_BAR_WIDTH;}
  Align:= alRight;
end;

procedure TCustomScrollBar.SetFixedColor(FixedColor: TColor);
begin
  fFixedColor:= FixedColor;
  Color:= FixedColor;
end;
{
procedure TCustomScrollBar.SetImages(ImageList: TImageList);
var
ButtonGlyph: TImage;
begin
//  if Assigned(ImageList) then fImageList:= ImageList else ImageList:= fDefaultImages;

  {Create a TImage, and fill the image with the scroll button colour; Fetch the
   associated bitmap from the imagelist to the canvas of the TImage; Transfer
   the image to the scroll button glyph; Perform for all six scroll buttons;}

{  ButtonGlyph:= TImage.Create(nil);
  with ButtonGlyph.Canvas do
  try
    Brush.Color:= fButtonColor;

    FillRect(ClipRect);
    ImageList.GetBitmap(0, ButtonGlyph.Picture.Bitmap);
    fbnFirst.Glyph:= ButtonGlyph;

    FillRect(ClipRect);
    ImageList.GetBitmap(1, ButtonGlyph.Picture.Bitmap);
    fbnPageUp.Glyph:= ButtonGlyph;

    FillRect(ClipRect);
    ImageList.GetBitmap(2, ButtonGlyph.Picture.Bitmap);
    fbnLineUp.Glyph:= ButtonGlyph;

    FillRect(ClipRect);
    ImageList.GetBitmap(3, ButtonGlyph.Picture.Bitmap);
    fbnLineDown.Glyph:= ButtonGlyph;

    FillRect(ClipRect);
    ImageList.GetBitmap(4, ButtonGlyph.Picture.Bitmap);
    fbnPageDown.Glyph:= ButtonGlyph;

    FillRect(ClipRect);
    ImageList.GetBitmap(5, ButtonGlyph.Picture.Bitmap);
    fbnLast.Glyph:= ButtonGlyph;
  finally
    FreeAndNil(ButtonGlyph);
  end;
end;}
{
procedure TCustomScrollBar.SetScrollWidth(NewWidth: integer);
begin
  {Scroll buttons need realigning when the scrollbar width is changed;}

{  Width:= NewWidth;
  ReAlignButtons;
end;
}
//*** Virtual methods **********************************************************

procedure TCustomScrollBar.ScrollPanelDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {When the main panel is clicked, a page up or page down is effected depending
   on the location of the click;}

  if Y < Height div 2 then ScrollButtonMDown(fbnPageUp, Button, Shift, X, Y)
  else ScrollButtonMDown(fbnPageDown, Button, Shift, X, Y);

//  showmessage(IntToStr(Ord(BevelInner)) + ', ' + IntToStr(Ord(BevelOuter)));
//  PaintScrollBar;
end;

procedure TCustomScrollBar.ScrollButtonMDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
// ScrollType: TSButtonType;
BeginTime: Cardinal;
begin
  {The depressed button is determined from the tag on the sender; Visually the
   button click is a toggling of the sender's outer bevel; The click is delayed
   by fRepeatDelay ms; A click will occur at least once, and will occur multiple
   times where the sender button remains depressed beyond fRepeatDelay; A click
   fires the descendant's ScrollButtonClick method, causing cursor movement, and
   also fires the OnScrollClick event;}

  if Button <> mbLeft then Exit;

  with Sender as TScrollButton do
  begin
    fDepressed:= true;
//    ScrollType:= TSButtonType(Tag);
//    BevelOuter:= bvLowered;
//    DepressGlyph(TScrollButton(Sender));
    DrawImage(ciDark);

    BeginTime:= GetTickCount + fRepeatDelay;
    while (GetTickCount < BeginTime) and fDepressed do Application.ProcessMessages;

    repeat
      try
        if Assigned(OnScrollClick) then OnScrollClick(Self, FButtonType, Button, Shift, X, Y);
      finally
        Application.ProcessMessages;
        SleepEX(fLineRepeatPause,TRUE);
      end;
    until not fDepressed;

//    fGlyph.Align:= alClient;
//    BevelOuter:= bvRaised;
//    Application.ProcessMessages;
  end;
end;

procedure TCustomScrollBar.ScrollButtonMUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {fDepressed enables click repeating; Repeats cease OnButtonUp;}
  fDepressed:= false;

  if Sender is TScrollButton then begin
    with Sender as TScrollButton do begin
      if bMouseOver then DrawImage(ciLight)
      else DrawImage(ciMedium);
    end;{with}
  end;{if}
end;

procedure TCustomScrollBar.PaintScrollBar;
begin
//  DrawVertLine(clBlack, 0, 1, Height - TMultiList(Owner).dimensions.HeaderHeight, Canvas);
  if (Owner <> nil) and (TMultiList(Owner).dimensions <> nil) then begin
    DrawVertLine(cl3DDkShadow, 1, TMultiList(Owner).dimensions.HeaderHeight + 3, Height - 2, Canvas);
    DrawHorizLine(cl3DDkShadow, fImgBlank.Height - 1, 0, Width, fImgBlank.Canvas);

    DrawVertLine(clBtnShadow, 0, TMultiList(Owner).dimensions.HeaderHeight, Height - 1, Canvas);
    DrawHorizLine(clBtnShadow, TMultiList(Owner).dimensions.HeaderHeight + 2, 0, Width, Canvas);
    DrawHorizLine(clBtnShadow, fImgBlank.Height - 2, 0, Width + 1, fImgBlank.Canvas);

    DrawVertLine(clBtnFace, Width -2, TMultiList(Owner).dimensions.HeaderHeight + 3, Height - 2, Canvas);
    DrawHorizLine(clBtnFace, Height - 2, 1, Width - 1, Canvas);

    DrawVertLine(clBtnHighlight, Width -1, TMultiList(Owner).dimensions.HeaderHeight, Height - 1, Canvas);
    DrawHorizLine(clBtnHighlight, Height - 1, 0, Width, Canvas);

    DrawFilledRect(clBtnFace, 0, 0, fImgBlank.Width, fImgBlank.Height - 2, fImgBlank.Canvas);
    DrawFilledRect(clBtnFace, 0, 0, Width, fImgBlank.Height, Canvas);
  end;{if}

//  fbnBlank.PaintAsBlank;

//  DrawHorizLine(clBlack, Height, 0, Width, fImgBlank.Canvas);
//  DrawHorizLine(clBlack, 1, 1, 100, fImgBlank.Canvas);
end;


//******************************************************************************

procedure TScrollButton.DoExit;
begin
  Inherited;
//  TCustomScrollBar(Owner).fDepressed := FALSE;
//  MouseMove([], -1, -1);
//  showmessage('x');
//  bMouseOver := FALSE;
end;
(*
procedure TCustomScrollBar.ScrollButtonKDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not (csDesigning in ComponentState) then
    begin
      TMultiList(Owner).ScrollButtonKeyDown(Key);

  {    with Message do
      Begin}

//{      If (Key In [VK_PRIOR,VK_NEXT,VK_DOWN,VK_UP,VK_END,VK_HOME,VK_RETURN]) {and (Assigned(SendKeyDown)) and (Focused)} then
//        Begin
  //        SendKeyDown(Self,CharCode,[]);
  //        TForm(Owner.Owner.Owner).caption := TWincontrol(TForm(Owner.Owner.Owner).ActiveControl).Name;
  //        if Copy(TWincontrol(TForm(Owner.Owner.Owner).ActiveControl).Name, 1, 12) = 'ScrollButton'
  //        then TMultiList(Owner.Owner).ScrollButtonKeyDown(CharCode)
  //        else Inherited;
{        TMultiList(Owner).ScrollButtonKeyDown(Key);
  //        Inherited;
        end
      else Inherited;}


  //    end
    end
  else Inherited;
end;
*)
{
procedure TScrollButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (not (csDesigning in ComponentState))
  and (Key In [VK_PRIOR,VK_NEXT,VK_DOWN,VK_UP,VK_END,VK_HOME,VK_RETURN])
  then TMultiList(Owner.Owner).ScrollButtonKeyDown(Self, Key, Shift)
//  then TMultiList(Owner.Owner).PanelKeyDown(Self, Key, Shift);
  else inherited KeyDown(Key, Shift);
end;

procedure TScrollButton.KeyPress(var Key: Char);
begin
  ShowMessage(Key);
  if not (csDesigning in ComponentState)
  then TMultiList(Owner.Owner).ScrollButtonKeyPress(Self, Key)
  else inherited;
end;
}
{
procedure TCustomScrollBar.PanelKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
end;
}

procedure TCustomScrollBar.ScrollPanelUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {When the main panel is clicked, a page up or page down is effected depending
   on the location of the click;}

  if Y < Height div 2 then ScrollButtonMUp(fbnPageUp, Button, Shift, X, Y)
  else ScrollButtonMUp(fbnPageDown, Button, Shift, X, Y);
end;


procedure TCustomScrollBar.ForceXP;
begin
  RunningXP := TRUE;
  fButtonStyle := bsXP;

  fbnFirst.ButtonStyle := bsXP;
  fbnFirst.DrawImage(fbnFirst.CurrentShading);
  fbnPageUp.ButtonStyle := bsXP;
  fbnPageUp.DrawImage(fbnPageUp.CurrentShading);
  fbnLineUp.ButtonStyle := bsXP;
  fbnLineUp.DrawImage(fbnLineUp.CurrentShading);
  fbnLineDown.ButtonStyle := bsXP;
  fbnLineDown.DrawImage(fbnLineDown.CurrentShading);
  fbnPageDown.ButtonStyle := bsXP;
  fbnPageDown.DrawImage(fbnPageDown.CurrentShading);
  fbnLast.ButtonStyle := bsXP;
  fbnLast.DrawImage(fbnLast.CurrentShading);
end;
{
procedure TScrollButton.ScrollButtonKeyPress(Sender: TObject;
  var Key: Char);
begin
  showmessage(Key);
end;

procedure TCustomScrollBar.ScrollButtonKeyPress(Sender: TObject;
  var Key: Char);
begin
//  showmessage(Key);
end;

procedure TScrollButton.CMDialogChar(var Message: TCMDialogChar);
begin
  showmessage(Char(Message.CharCode));
end;
}

procedure TScrollButton.CNChar(var Message: TWMChar);
var
  cChar : char;
  KeyMessage : TWMKey;

  function IsAlphaNumeric(Key: Char): boolean;
  begin
    {Examines the ASCII code for the given character and returns true if it is alphanumeric;}
    Result:= Ord(Key) in [32, 45, 46, 48..57, 65..90, 97..122];
  end;

begin
//  showmessage(Char(Message.CharCode));
  cChar := Char(Message.CharCode);

  KeyMessage := Message;

  if not (csDesigning in ComponentState) and IsAlphaNumeric(cChar)
  then TMultiList(Owner.Owner).ScrollButtonKeyPress(Self, cChar)
  else begin
    Inherited;
    if Assigned(TMultiList(Owner.Owner).OnScrollButtonKeyPress)
    then TMultiList(Owner.Owner).OnScrollButtonKeyPress(cChar);
  end;{if}
//  else SendMessage(TWinControl(Owner.Owner.Owner).Handle, KeyMessage.Msg
//  , KeyMessage.CharCode, KeyMessage.CharCode);
//  else PostMessage(TWinControl(Owner.Owner.Owner).Handle, Message.Msg
//  , Tmessage(Message).WParam, Tmessage(Message).lParam);
//  else TWinControl(Owner.Owner.Owner).DoKeyPress(Message);
//  else SendMessage(TWinControl(Owner.Owner.Owner).Handle, Message.Msg
//  , Tmessage(Message).WParam, Tmessage(Message).lParam);
end;

procedure TCustomScrollBar.Paint;
begin
  inherited;
  PaintScrollBar;
end;

procedure TCustomScrollBar.Invalidate;
begin
  if TMultiList(owner).dimensions <> nil then PaintScrollBar;
end;

procedure TScrollButton.CNKeyUp(var Message: TWMKeyUp);
begin
  if (not (csDesigning in ComponentState))
    then begin
      with Message do Begin
        case CharCode of
          16 : begin
            CurrentShiftState := [];
            TMultiList(Owner.Owner).ScrollButtonKeyUp(Self, CharCode, CurrentShiftState);
          end;

          VK_RETURN, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR
          , VK_NEXT, VK_RIGHT, VK_LEFT, VK_ESCAPE : Begin
            TMultiList(Owner.Owner).ScrollButtonKeyUp(Self, CharCode, CurrentShiftState);
          end;
        end;{case}
      end;{with}
    end
  else Inherited;
end;

end.
