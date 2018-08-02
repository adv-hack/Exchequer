unit SButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, GFXUtil;

type
  TColourImage = (ciLight, ciMedium, ciDark);
  TSButtonType = (btTop, btPageUp, btOneUp, btOneDown, btPageDown, btBottom);
  TSButtonStyle = (bsXP, bsStandard);

  TScrollButton = class(TButtonControl)
  private
    imgFace : TImage;
    bPrevEnabled  : boolean;
    FButtonType : TSButtonType;
    FButtonStyle : TSButtonStyle;
    CurrentShading : TColourImage;
    sCurrentResName : string;
    FLastKeyPressed : Word;
    FSendListKeyDown
                 : TKeyEvent;

    Procedure DrawImage(ciShading : TColourImage);
    procedure SetButtonType(Value: TSButtonType);
    procedure SetButtonStyle(Value: TSButtonStyle);
    procedure SetLastKeyPressed(Value: Word);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Click; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure CNKeyDown(var Message: TWMKeyUp); message CN_KeyDown;
  public
    bMouseOver  :  Boolean;
    bRunningXP  :  Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnKeyDown;
    property ButtonType : TSButtonType read FButtonType write SetButtonType default btOneUp;
    property ButtonStyle : TSButtonStyle read FButtonStyle write SetButtonStyle default bsStandard;
    property SendKeyDown: TKeyEvent read FSendListKeyDown write FSendListKeyDown;
    property LastKeyPressed : Word read FLastKeyPressed write SetLastKeyPressed default 0;
  end;

{$R SBUTTONS.RES}
{$R GSCRLBTN.RES}

procedure Register;

implementation


constructor TScrollButton.Create(AOwner: TComponent);
begin
  inherited;
  Width := 16;
  Height := 17;
  ControlStyle := [csClickEvents, csOpaque];
  TabStop := FALSE;
  FLastKeyPressed := 0;

  imgFace := TImage.Create(self);


  with imgFace do begin
    OnMouseMove := ImgMouseMove;
    Parent := Self;
    AutoSize := true;
    top := 0;
    left := 0;
  end;{with}

  CurrentShading := ciMedium;
  sCurrentResName := '';
  bPrevEnabled := TRUE;
  bRunningXP:=FALSE;

  FSendListKeyDown:=nil;


end;

procedure TScrollButton.SetButtonType(Value: TSButtonType);
begin
  FButtonType := Value;
  DrawImage(ciMedium);
end;

procedure TScrollButton.SetButtonStyle(Value: TSButtonStyle);
begin

  FButtonStyle := Value;


  {DrawImage(ciMedium);}
end;

procedure TScrollButton.SetLastKeyPressed(Value: Word);
begin
  FLastKeyPressed := Value;
end;

Procedure TScrollButton.DrawImage(ciShading : TColourImage);
var
  ARect : TRect;
  TmpBitmap : TBitMap;

  sResName : string;

  Procedure ChangeColor(const ColFrom, ColTo : TColor; bFirst : boolean);
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

      If (bRunningXP) and (FButtonStyle <> bsXP) then
        TmpBitmap.PixelFormat:=pf24bit; {Under XP colour replacement failed if this line not in}

//      DeleteObject(TmpBitmap.Palette);
//      TmpBitmap.Palette := CopyPalette(imgFace.Picture.Bitmap.Palette);

      ARect := Rect(0,0,TmpBitmap.Width,TmpBitmap.Height);
      imgFace.Picture.Bitmap.Height := TmpBitmap.Height;
      imgFace.Picture.Bitmap.Width := TmpBitmap.Width;
    end;{if}
  end;{InitialiseBitmap}

begin

  case FButtonStyle of
    bsXP : begin

      case FButtonType of
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
            ChangeColor(clBlack, DarkenColor(clHighLight,20), TRUE);
            case ciShading of
              ciLight : ChangeColor(clSilver, LightenColor(clHighLight, 75), FALSE);
              ciMedium : ChangeColor(clSilver, LightenColor(clHighLight, 65), FALSE);
              ciDark : ChangeColor(clSilver, LightenColor(clHighLight, 55), FALSE);
            end;{case}
          end
        else begin
          ChangeColor(clBlack, LightenColor(clHighLight,45), TRUE);
          ChangeColor(clSilver, LightenColor(clHighLight, 75), FALSE);
        end;
        ChangeColor(clGray, LightenColor(clHighLight, 50), FALSE);

        TmpBitmap.Free;
        Update;
      end;{if}
    end;


    bsStandard : begin
      if (csLButtonDown in ControlState) and bMouseOver then
        begin
          case FButtonType of
            btTop : sResName := 'GTOP2';
            btPageUp : sResName := 'GPGUP2';
            btOneUp : sResName := 'GONEUP2';
            btOneDown : sResName := 'GONEDN2';
            btPageDown : sResName := 'GPGDN2';
            btBottom : sResName := 'GBOT2';
          end;{case}
        end
      else begin
        case FButtonType of
          btTop : sResName := 'GTOP1';
          btPageUp : sResName := 'GPGUP1';
          btOneUp : sResName := 'GONEUP1';
          btOneDown : sResName := 'GONEDN1';
          btPageDown : sResName := 'GPGDN1';
          btBottom : sResName := 'GBOT1';
        end;{case}
      end;{if}

      if InitialiseBitmap then begin
        if not Enabled then ChangeColor(clBlack, clBtnShadow, FALSE);
        ChangeColor(clSilver, clBtnFace, TRUE);
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
  if GetCapture <> Handle then SetCapture(handle);

  if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
    begin
      if not bMouseOver then begin
        DrawImage(ciLight);
        bMouseOver := TRUE;
      end;{if}
    end
  else begin
    bMouseOver := FALSE;
    ReleaseCapture;
    DrawImage(ciMedium);
  end;
end;

procedure TScrollButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  
  if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
  Begin
    DrawImage(ciDark);
    
  end;
  
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
  SetCapture(handle);
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
  if not (csDesigning in ComponentState) then
    with Message do
    Begin

      If (CharCode In [VK_PRIOR,VK_NEXT,VK_DOWN,VK_UP,VK_END,VK_HOME,VK_RETURN]) and (Assigned(SendKeyDown)) and (Focused) then
      Begin
        SendKeyDown(Self,CharCode,[]);
        {Inherited;}
      end
      else
        Inherited;

    end
    else
      Inherited;
end;



destructor TScrollButton.Destroy;
begin
  imgFace.Free;


  inherited;
end;


procedure Register;
begin
  RegisterComponents('Samples', [TScrollButton]);
end;

end.
