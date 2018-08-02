unit IAeverButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Buttons,Math,Extctrls,RotateRGN1,IARotateTimer;

  const
   cm_CloseTimer = cm_Base+101;
   

  type
  TIAButtonKind =
  (bkRect,bkRoundRect,bkElliptic,bkPoly,bkPolyStar,bkArc,bkDonut,bkUser,
   bkArrow,bkArrow1,bkArrow2,bkCross,bkCutRect,bkCross1);
  TIA3DKind =(dk3D,dkFlatten,dk3dsimple,dkFlattenSimple,dk3dBorder,dk3dBorderFlatten,dkNone);
  TIAGradientKind =(gkNone,gkLinear,gkCircular);
  TIACaption3dKind = (ckSimple,ckEmbossed,ckPressed);
  TIAHAlign = (haLeft,haCenter,haRight,haNone);
  TIAVAlign = (vaTop,vaCenter,vaBottom,vaNone);
  TIAStringRGNData =  string;

  TMouseInOutEvent = procedure(sender : Tobject) of object;



  TIAeverButton = class(TButton)
  private
    FRotatedTimer : TiaRotateTimer;
    FCaptionAngle : Integer;
    FCaption3dKind : TIACaption3dKind;

    FButtonColor1 : Tcolor;
    FGradientKind : TIAGradientKind;
    FGradientAngle : Integer;
    FGradientFixed : Boolean;
    FGradientBitmap : Tbitmap;
    FGradientBitmapLine : Integer;

    FRotatedTime : Integer;
    FCaptionFixed : boolean;
    FRotatedAngle : Integer;

    FRotated : boolean;
    FRadiusratio : double;
    FArcAngle : double;

    FRotationPointX : Integer;
    FRotationPointY : Integer;

    FRotationCenterFixed : Boolean;
    Nomove : Boolean;
    Dangle : integer;
    Left1,Top1,Ttop,Lleft : Integer;
    NewKind : Boolean;
    LeftTop : Boolean;
    Rwidth,Rheight : integer;
    RotateIs,RotateIs1 : Boolean;
    Iloaded : Boolean;

    Myxdata : XFORM;
    BackBitmap : Tbitmap;
    Needinrepaint : Boolean;
    oldismousein,oldenabled,oldisdown : Boolean;
    FMainPoly1 : Tpoints;
    FMainVertex1 : Tintegers;
    FMainPower1 : Tintegers;
    FUserRGNAUTO : Boolean;
    FUserWidth,FUserHeight : integer;
    FUserLeft,FUserTop : integer;
    LastInRGN : integer;

    first : boolean;
//    AnimaTimer : TTimer;
    NowH : Boolean;
    IsDown : Boolean;

    FMainBitmap : TBitmap;
    FMainBitmapGlyphs : integer;
    FOnEnterBitmap : TBitmap;
    FOnEnterGlyphs : integer;
    FOnEnterInterval : integer;
    OnEnterPlay : Boolean;
    OnEnterCount : integer;
    FOnPaint : TNotifyEvent;
    FOnExitBitmap : TBitmap;
    FOnExitGlyphs : integer;
    FOnExitInterval : integer;
    OnExitPlay : Boolean;
    OnExitCount : integer;
    FOnClickBitmap : TBitmap;
    FOnClickGlyphs : integer;
    FOnClickInterval : integer;
    OnClickPlay : Boolean;
    OnClickCount : integer;

    FBitmapTop : Integer;
    FBitmapLeft : Integer;

    FBitmapHAlign : TIAHAlign;
    FBitmapVAlign : TIAVAlign;
    FTransparent : Boolean;
    FPeaksNumber : Integer;
    FButtonAngle : Integer;
    FButtonWidth : Integer;
    FButtonHeight : Integer;

    FButtonRegion : HRGN;
    FButtonRegion1 : HRGN;
    FBrgn : HRGN;
    FOutBorder : HRGN;
    FInBorder :HRGN;

    F3DUpUpper,       //Верхняя тень трехмерной кнопки в приподнятом состоянии...
    F3DUpDownner,     //Нижняя тень....
    FSelectedRgn,      //
    F3DUpUpper1,       //Верхняя тень трехмерной кнопки в приподнятом состоянии...
    F3DUpDownner1     //Нижняя тень....
                        : HRGN;

    FStringButtonRegion : TIAStringRGNData;


    FCaptionTop : Integer;
    FCaptionLeft : Integer;

    FCaptionHAlign : TIAHAlign;
    FCaptionVAlign : TIAVAlign;
    FButtonColor : TColor;
    FButtonKind : TIAButtonKind;
    FLastButtonKind : TIAButtonKind;
    FButton3DKind : TIA3DKind;
    FButtonDepth : integer;

    FDrawS : TDrawItemStruct;
    FCanvas : TCanvas;
    isFocused : Boolean;
    isMousein : Boolean;
    FonMouseEnter : TMouseInOutEvent;
    FonMouseLeave  : TMouseInOutEvent;
    FCustomDraw: Boolean;
    FShowFocusRGN: Boolean;
    procedure WMPaint(var Message : TWMPaint); message WM_PAINT;
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Message : TWMDrawItem);message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage);message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure WMLButtonDblClick(var Message: TWMLButtonDblClk);message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Message : TWMLButtonDown);message WM_LBUTTONDOWN;


    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure CMCLOSETIMER(var Message: TMessage); message  cm_CloseTimer;
    procedure CMROTATEDON(var Message: TMessage); message  cm_RotatedOn;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure wmKeyDown(var Message : TwmKeyDown); message wm_KeyDown;

    procedure SetNewKind;
    Procedure GetMainBitmap;


    procedure ShiftPoly(var points : array of Tpoint;dx,dy : integer);

//    procedure AnimaGoOn(Sender : TObject);
//    procedure DrawBMPGlyph(Bitmap : TBitmap;Glyphs,Count : integer);

    function GetLColor(Value : Tcolor): Tcolor;
    function GetDColor(Value : Tcolor): Tcolor;
    Function GetSumColor(Value : Tcolor): integer;

    procedure GotMain_Arc(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Rect(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_RoundRect(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Elliptic(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Poly(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_PolyStar(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Donut(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Arrow(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Arrow1(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Arrow2(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_CutRect(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Cross(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
    procedure GotMain_Cross1(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);

    procedure GotMain_USERRGN(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);

    procedure GetGBitmaps(C1,C2 : Tcolor;updown : integer);
    procedure DrawTransparent(x,y : integer;Rfrom : Trect;var B : TBitmap;ToBack : Boolean);
    procedure DrawTextXY(x,y,AAngle,dcl : integer;Text : string;Aun : boolean);
    procedure DrawTextXYall(X0,Y0,AAngle : integer;Text : string);
    procedure SetCustomDraw(Value: Boolean);
    procedure SetShowFocusRGN(Value: Boolean);
  protected
    procedure Loaded; override;
    procedure SetCaptionTop(Value : integer); virtual;
    procedure SetCaptionLeft(Value : integer); virtual;
    procedure SetCaptionAngle(Value : integer); virtual;
    procedure SetGradientBitmap(Value : Tbitmap);virtual;
    procedure SetGradientBitmapLine(Value : integer);virtual;
    procedure SetButtoncolor(Value : TColor); virtual;
    procedure SetButtonKind(Value : TIAButtonKind);
    procedure SetButton3DKind(Value : TIA3DKind);
    procedure SetButtonDepth(Value : integer); virtual;
    procedure SetButtonRegion(Value : HRGN); virtual;
    procedure SetCaptionHAlign(Value : TIAHAlign); virtual;
    procedure SetCaptionVAlign(Value : TIAVAlign); virtual;
    procedure SetMainBitmap(Value : TBitmap); virtual;
    procedure SetMainBitmapGlyphs(Value : integer); virtual;
    procedure SetOnEnterBitmap(Value : TBitmap); virtual;
    procedure SetOnEnterGlyphs(Value : integer); virtual;
    procedure SetOnEnterInterval(Value : integer); virtual;
    procedure SetOnExitBitmap(Value : TBitmap); virtual;
    procedure SetOnExitGlyphs(Value : integer); virtual;
    procedure SetOnExitInterval(Value : integer); virtual;
    procedure SetOnClickBitmap(Value : TBitmap); virtual;
    procedure SetOnClickGlyphs(Value : integer); virtual;
    procedure SetOnClickInterval(Value : integer); virtual;

    procedure SetTransparent(Value : Boolean); virtual;
    procedure SetPeaksNumber(Value : Integer); virtual;
    procedure SetButtonAngle(Value : Integer); virtual;
    procedure SetButtonWidth(Value : Integer); virtual;
    procedure SetButtonHeight(Value : Integer); virtual;
    procedure SetBitmapTop(Value : integer); virtual;
    procedure SetBitmapLeft(Value : integer); virtual;
    procedure SetBitmapHAlign(Value : TIAHAlign); virtual;
    procedure SetBitmapVAlign(Value : TIAVAlign); virtual;

    procedure SetStringButtonRegion(Value : TIAStringRGNData); virtual;

    procedure SetUserRGNAUTO(Value : Boolean);virtual;

    procedure SetRotationPointX(Value : Integer); Virtual;
    procedure SetRotationPointY(Value : Integer); Virtual;
    procedure SetRotationCenterFixed(Value : Boolean); virtual;
    procedure SetRotated(Value : Boolean); virtual;
    procedure SetRotatedTime(Value : Integer); virtual;
    procedure SetRotatedAngle(Value : Integer); virtual;
    procedure SetCaptionFixed(Value : Boolean); virtual;

    procedure SetButtonColor1(Value : TColor); virtual;
    procedure SetGradientKind(Value : TIAGradientKind); virtual;
    procedure SetGradientAngle(Value : Integer);virtual;
    procedure SetGradientFixed(Value : Boolean); virtual;

    procedure SetCaption3dKind(Value : TIACaption3dKind);virtual;

    procedure SetRadiusRatio(Value : Double); virtual;
    procedure SetArcAngle(Value : Double); virtual;

    procedure Paint; virtual;
    procedure PaintBitmaps(isdown : Boolean); virtual;
    procedure PaintWindow(DC: HDC); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;
    procedure CreateHandle; override;

    { Protected declarations }
  public
    procedure DrawCaptionAll;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    { Public declarations }
    property ButtonRegion : HRGN read FButtonRegion1 write SetButtonRegion;
    property Canvas : TCanvas read FCanvas;
  published
    { Published declarations }
    property ButtonAngle : Integer read FButtonAngle write SetButtonAngle;
    property ButtonWidth : Integer read FButtonWidth write SetButtonWidth;
    property ButtonHeight : Integer read FButtonHeight write SetButtonHeight;


    property CaptionTop : integer read FCaptionTop write SetCaptionTop default 5;
    property CaptionLeft : integer read FCaptionLeft write SetCaptionLeft default 5;
    property CaptionAngle : integer read FCaptionAngle write SetCaptionAngle;
    property ButtonColor : TColor read FButtonColor write SetButtonColor default clBtnFace;
    property ButtonKind : TIAButtonKind read FbuttonKind write SetButtonKind default bkRect;
    property Button3DKind : TIA3DKind read FButton3DKind write Setbutton3dKind default dk3D;
    property ButtonDepth : integer read FButtonDepth write SetButtonDepth default 2;
    property CaptionHAlign : TIAHAlign read FCaptionHAlign write SetCaptionHAlign default haCenter;
    property CaptionVAlign : TIAVAlign read FCaptionVAlign write SetCaptionVAlign default vaCenter;
    property MainBitmap : TBitmap read FMainBitmap write SetMainBitmap;
    property MainBitmapGlyphs : integer read FMainBitmapGlyphs write SetMainBitmapGlyphs default 1;
    property OnEnterBitmap : TBitmap read FOnEnterBitmap write SetONEnterBitmap;
    property OnEnterGlyphs : integer read FONEnterGlyphs write SetOnEnterGlyphs default 1;
    property OnEnterInterval : integer read FOnEnterInterval write SetOnEnterInterval default 40;
    property OnExitBitmap : TBitmap read FOnExitBitmap write SetONExitBitmap;
    property OnExitGlyphs : integer read FONExitGlyphs write SetOnExitGlyphs default 1;
    property OnExitInterval : integer read FOnExitInterval write SetOnExitInterval default 40;
    property OnClickBitmap : TBitmap read FOnClickBitmap write SetONClickBitmap;
    property OnClickGlyphs : integer read FONClickGlyphs write SetOnClickGlyphs default 1;
    property OnClickInterval : integer read FOnClickInterval write SetOnClickInterval default 40;

    property Transparent : Boolean read FTransparent write SetTransparent;
    property PeaksNumber : Integer read FPeaksnumber write SetPeaksNumber default 6;

    property BitmapTop : integer read FBitmapTop write SetBitmapTop default 5;
    property BitmapLeft : integer read FBitmapLeft write SetBitmapLeft default 5;
    property BitmapHAlign : TIAHAlign read FBitmapHAlign write SetBitmapHAlign default haLeft;
    property BitmapVAlign : TIAVAlign read FBitmapVAlign write SetBitmapVAlign default vaTop;

    property StringButtonRegion : TIAStringRGNData read FStringButtonRegion write SetStringButtonRegion;
    property UserRGNAUTO : Boolean read FUserRGNAUTO write SetUserRGNAUTO;

    property RotationPointX : Integer read FRotationPointX write SetRotationPointX;
    property RotationPointY : Integer read FRotationPointY write SetRotationPointY;
    property RotationCenterFixed : Boolean read FRotationCenterFixed write SetRotationCenterFixed default false;
    property Rotated : Boolean read FRotated write SetRotated;
    property RotatedTime : Integer read FRotatedTime write SetRotatedTime default 40;
    property RotatedAngle : Integer read FRotatedAngle write SetRotatedAngle default 40;
    property CaptionFixed : Boolean read FCaptionFixed write SetCaptionFixed;

    property ButtonColor1 : TColor read FButtonColor1 write SetButtonColor1 default clBtnShadow;
    property GradientKind : TIAGradientKind read FGradientKind write SetGradientKind default gkNone;
    property GradientAngle : Integer read FGradientAngle write SetGradientAngle default 450;
    property GradientFixed : Boolean read FGradientFixed write SetGradientFixed;
    property GradientBitmap : TBitmap read FGradientBitmap write SetGradientBitmap;
    property GradientBitmapLine : integer read FGradientBitmapLine write SetGradientBitmapLine;

    property Caption3dKind : TIACaption3dKind read FCaption3dKind write SetCaption3dKind;

    property RadiusRatio : Double read FRadiusRatio write SetRadiusRatio;
    property ArcAngle: Double read FArcAngle write SetArcAngle;

    property onMouseEnter  : TMouseInOutEvent read FonMouseEnter write FonMouseEnter;
    property onMouseExit   : TMouseInOutEvent read FonMouseLeave  write FonMouseLeave;
    property OnPaint : TNotifyEvent read FOnPaint write FOnPaint;
    property CustomDraw : Boolean read FCustomDraw write SetCustomDraw default false;
    property ShowFocusRGN : Boolean read FShowFocusRGN write SetShowFocusRGN default true;
  end;
 

procedure Register;

implementation

constructor TIAeverButton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Iloaded:=false;
  FCanvas:=TControlCanvas.Create;
  TControlCanvas(FCanvas).Control:=Self;
  ControlStyle := ControlStyle + [csReflector];

  Needinrepaint:=true;
  first:=true;
  FCustomDraw:=false;
  FShowFocusRGN:=true;
  FOnPaint:=nil;

  F3DUpUpper:=0;
  F3DUpDownner:=0;


  FSelectedRgn:=0;
  FButtonRegion:=0;
  FButtonRegion1:=0;
  FBrgn:=0;
  FStringButtonRegion:='';
  FRotationPointX:=0;
  FRotationPointY:=0;
  FRotationCenterFixed:=false;
  Nomove:=false;
  Dangle:=0;
  FRadiusRatio:=0.5;
  FArcAngle:=2.0*pi/3.0;
  FRotatedTime:=40;
  FRotatedAngle:=40;
  

  FCaptionTop:=5;
  FCaptionLeft:=5;
  FCaptionAngle:=0;
  FButtoncolor:=clBtnFace;
  FButtonKind:=bkRect;
  FLastButtonKind:=bkRect;
  FBitmapTop:=5;
  FBitmapLeft:=5;
  FBitmapHAlign:=haLeft;
  FBitmapVAlign:=vaTop;
  FButtonDepth:=2;
  FCaptionHAlign:=haCenter;
  FcaptionVAlign:=vaCenter;
  FMainBitmap:=TBitmap.Create;
  FGradientBitmap:=TBitmap.create;
  FGradientBitmapLine:=0;
  FMainBitmapGlyphs:=1;
  FOnEnterBitmap:=TBitmap.Create;
  FOnenterGlyphs:=1;
  FOnEnterInterval:=40;
  OnEnterPlay:=False;
  
{NF: 27/02/2001
  FOnExitBitmap:=TBitmap.Create;}
  FOnExitBitmap:=nil;

  FOnExitGlyphs:=1;
  FOnExitInterval:=40;
  OnExitPlay:=False;
  FOnClickBitmap:=TBitmap.Create;
  FOnClickGlyphs:=1;
  FOnClickInterval:=40;
  OnClickPlay:=False;

  FPeaksNumber:=6;
  FbuttonAngle:=0;
  FButtonWidth:=Width;
  FButtonHeight:=Height;
  Rwidth:=width;
  Rheight:=height;
  NOWH:=False;
  oldenabled:=enabled;
  FUserRGNAUTO:=TRUE;

  FButtonColor1:=clBtnShadow;
  FGradientKind:=gkNone;
  FGradientAngle:=450;
  FGradientFixed:=False;
    self.font.Name:='Times New Roman';
  self.Canvas.Font.Name:='Times New Roman';
end;
procedure TIAeverButton.CreateHandle;
begin
  inherited CreateHandle;
  FRotatedTimer := TiaRotateTimer.Create(True);
  FRotatedTimer.Handle1:=self.Handle;
  FRotatedTimer.Dtime:=FRotatedTime;

  Needinrepaint:=true;
  SetNewKind;//Это процедура подготовки форм для рисования кнопки...

  oldenabled:=enabled;
  oldisdown:=false;
  oldismousein:=false;
end;
procedure TIAeverButton.Loaded;
begin
  inherited Loaded;
  if LeftTop then
    begin
      Nomove:=true;
      Left:=left1;
      Top:=top1;
      lLeft:=left1;
      tTop:=top1;
      Nomove:=false;
    end;
  Dangle:=0;
  Needinrepaint:=true;
  setnewkind;
  invalidate;
  ILoaded:=true;
end;
destructor TIAeverButton.Destroy;
begin
  if FRotatedTimer.Suspended then
    begin
      FRotatedTimer.Terminate;
      FRotatedTimer.Resume;
      FRotatedTimer.WaitFor;
    end else
    begin
      FRotatedTimer.Terminate;
      FRotatedTimer.WaitFor;
    end;
  FRotated:=False;
  FCanvas.Free;
  FMainBitmap.Free;
  FOnEnterBitmap.Free;
  FOnExitBitmap.Free;
  FOnClickBitmap.Free;
//  AnimaTimer.Free;
  BackBitmap.Free;
  GradientBitmap.free;


  deleteobject(F3DUpUpper);
  deleteobject(F3DUpDownner);
  
 

  deleteobject(F3DUpUpper1);
  deleteobject(F3DUpDownner1);
  

  deleteobject(FSelectedRgn);
  deleteobject(FButtonRegion);
  deleteobject(FButtonRegion1);
  deleteobject(FBrgn);
  deleteobject(FOutBorder);
  deleteobject(FInBorder);
  inherited Destroy;
end;

procedure TIAeverButton.WMPaint(var Message : TWMPaint);
begin
 ControlState:=ControlState+[csCustomPaint];
 inherited;
 ControlState:=ControlState-[csCustomPaint];
end;
procedure TIAeverButton.PaintWindow(DC: HDC);
begin
 FCanvas.Lock;
  try
    FCanvas.Handle:=DC;
     try
      TControlCanvas(FCanvas).UpdateTextFlags;
      Paint;
     finally
    FCanvas.Handle:=0;
    end;
  finally
  FCanvas.Unlock;
  end;
end;
procedure TIAeverButton.DrawCaptionAll;
var
  sz,sz1 : size;
  AText,s : string;
  X,Y,dx,dy,ax,ay,nx,ny,cx,cy,p1,p2 : integer;

begin
  x:=0;y:=0;
  BackBitmap.Canvas.font.Assign(self.font);
  AText:=caption;
  sz.cx:=0;sz.cy:=0;
  while AText<>'' do
    begin
      p1:=pos('&',AText);
      p2:=pos('&&',AText);
      if p1=0 then
        begin
          s:=AText;
          AText:='';
        end else
        begin
          if p1=p2 then
            begin
              s:=copy(AText,1,p1);
              AText:=copy(AText,p1+2,length(AText)-p1-1);
            end else
            begin
              s:=copy(AText,1,p1-1);
              AText:=copy(AText,p1+1,length(AText)-p1);
            end;
        end;
      GetTextExtentPoint32(BackBitmap.Canvas.handle,@(s[1]),length(s),sz1);
      inc(sz.cx,sz1.cx);if sz.cy=0 then inc(sz.cy,sz1.cy);
    end;
  AText:=caption;
  if  FCaptionFixed then
    begin
      dx:=round(sz.cx*abs(cos((CaptionAngle-ButtonAngle)*pi/1800))+sz.cy*abs(sin((CaptionAngle-ButtonAngle)*pi/1800)));
      dy:=round(sz.cx*abs(sin((CaptionAngle-ButtonAngle)*pi/1800))+sz.cy*abs(cos((CaptionAngle-ButtonAngle)*pi/1800)));
      if sin((CaptionAngle-ButtonAngle)*pi/1800)>0 then
        begin
          if cos((CaptionAngle-ButtonAngle)*pi/1800)>0 then
            begin
              ax:=0;ay:=round(sz.cx*abs(sin((CaptionAngle-ButtonAngle)*pi/1800)));
            end else
            begin
              ax:=round(sz.cx*abs(cos((CaptionAngle-ButtonAngle)*pi/1800)));ay:=dy;
            end;
        end else
        begin
          if cos((CaptionAngle-ButtonAngle)*pi/1800)>0 then
            begin
              ax:=round(sz.cy*abs(sin((CaptionAngle-ButtonAngle)*pi/1800)));ay:=0;
            end else
            begin
              ax:=dx;ay:=round(sz.cy*abs(cos((CaptionAngle-ButtonAngle)*pi/1800)));
            end;
        end;
      case FCaptionHAlign of
        haLeft :   x:=Buttondepth+4;
        haCenter : x:=(Buttonwidth-dx) div 2;
        haRight :  x:=Buttonwidth-Buttondepth-4-dx;
        haNone :   x:=CaptionLeft;
      end;
      case FCaptionVAlign of
        vaTop :    y:=Buttondepth+4;
        vaCenter : y:=(Buttonheight-dy) div 2;
        vaBottom : y:=Buttonheight-ButtonDepth-4-dy;
        vaNone :   y:=CaptionTop;
      end;
      nx:=round((x+ax)*cos(ButtonAngle*pi/1800)+(y+ay)*sin(ButtonAngle*pi/1800));
      ny:=round(-(x+ax)*sin(ButtonAngle*pi/1800)+(y+ay)*cos(ButtonAngle*pi/1800));
      cx:=round(Buttonwidth*cos(ButtonAngle*pi/1800)/2+Buttonheight*sin(ButtonAngle*pi/1800)/2);
      cy:=round(-Buttonwidth*sin(ButtonAngle*pi/1800)/2+Buttonheight*cos(ButtonAngle*pi/1800)/2);
      nx:=(width div 2-cx)+nx;
      ny:=(height div 2-cy)+ny;
      DrawTextXYall(nx,ny,CaptionAngle,AText);
    end else
    begin
      dx:=round(sz.cx*abs(cos(CaptionAngle*pi/1800))+sz.cy*abs(sin(CaptionAngle*pi/1800)));
      dy:=round(sz.cx*abs(sin(CaptionAngle*pi/1800))+sz.cy*abs(cos(CaptionAngle*pi/1800)));
      if sin((CaptionAngle)*pi/1800)>0 then
        begin
          if cos((CaptionAngle)*pi/1800)>0 then
            begin
              ax:=0;ay:=round(sz.cx*abs(sin((CaptionAngle)*pi/1800)));
            end else
            begin
              ax:=round(sz.cx*abs(cos((CaptionAngle)*pi/1800)));ay:=dy;
            end;
        end else
        begin
          if cos((CaptionAngle)*pi/1800)>0 then
            begin
              ax:=round(sz.cy*abs(sin((CaptionAngle)*pi/1800)));ay:=0;
            end else
            begin
              ax:=dx;ay:=round(sz.cy*abs(cos((CaptionAngle)*pi/1800)));
            end;
        end;
      case FCaptionHAlign of
        haLeft :   x:=Buttondepth+4;
        haCenter : x:=(width-dx) div 2;
        haRight :  x:=width-Buttondepth-4-dx;
        haNone :   x:=CaptionLeft;
      end;
      case FCaptionVAlign of
        vaTop :    y:=Buttondepth+4;
        vaCenter : y:=(height-dy) div 2;
        vaBottom : y:=height-ButtonDepth-4-dy;
        vaNone :   y:=CaptionTop;
      end;
      DrawTextXYall(x+ax,y+ay,CaptionAngle,AText);
    end;
end;
procedure TIAeverButton.DrawTextXYall(X0,Y0,AAngle : integer;Text : string);
var p1,p2,i,k,x,y,dx,dy : integer;
    AText,s : string;
    sz : size;
begin
  s:=Text;k:=0;x:=x0;y:=y0;dx:=0;dy:=0;
  for i:=-1 to 1 do
    begin
      case FCaption3dKind of
        ckSimple : if i<>0 then continue else begin k:=0; if IsDown then begin dx:=1;dy:=1; end else  begin dx:=0;;dy:=0; end; end;
        ckEmbossed : begin
                       if i=-1 then begin k:=1;dx:=-1;dy:=-1; end else
                       if i=0 then begin k:=-1;dx:=1;dy:=1; end else begin k:=0;dx:=0;dy:=0; end;
                       if isDown then begin inc(dx);inc(dy); end;
                     end;
        ckPressed :  begin
                       if i=-1 then begin k:=-1;dx:=-1;dy:=-1; end else
                       if i=0 then begin k:=1;dx:=1;dy:=1; end else begin k:=0;dx:=0;dy:=0; end;
                       if isDown then begin inc(dx);inc(dy); end;
                     end;
      end;
      Text:=s;x0:=x;y0:=y;    
      while Text<>'' do
        begin
          p1:=pos('&',Text);
          p2:=pos('&&',Text);
          if p1=0 then
            begin
              DrawTextXY(X0+dx,Y0+dy,AAngle,k,Text,false);
              Text:='';
            end else
            begin
              if p1=p2 then
                begin
                  AText:=copy(Text,1,p1);
                  GetTextExtentPoint32(BackBitmap.Canvas.handle,@(AText[1]),length(AText),sz);
                  DrawTextXY(X0+dx,Y0+dy,AAngle,k,AText,false);
                  X0:=X0+round(sz.cx*cos(AAngle*pi/1800));
                  Y0:=Y0+round(-sz.cx*sin(AAngle*pi/1800));
                  Text:=copy(Text,p1+2,length(Text)-p1-1);
                end else
                begin
                  AText:=copy(Text,1,p1-1);
                  GetTextExtentPoint32(BackBitmap.Canvas.handle,@(AText[1]),length(AText),sz);
                  DrawTextXY(X0+dx,Y0+dy,AAngle,k,AText,false);
                  X0:=X0+round(sz.cx*cos(AAngle*pi/1800));
                  Y0:=Y0+round(-sz.cx*sin(AAngle*pi/1800));
                  if p1=length(text) then text:=text+' ';
                  AText:=copy(Text,p1+1,1);
                  GetTextExtentPoint32(BackBitmap.Canvas.handle,@(AText[1]),length(AText),sz);
                  DrawTextXY(X0+dx,Y0+dy,AAngle,k,AText,true);
                  X0:=X0+round(sz.cx*cos(AAngle*pi/1800));
                  Y0:=Y0+round(-sz.cx*sin(AAngle*pi/1800));
                  Text:=copy(Text,p1+2,length(Text)-p1-1);
                end;
            end;
        end;
  end;
end;
procedure TIAeverButton.DrawTextXY(x,y,AAngle,dcl : integer;Text : string;Aun : boolean);
var
   MyFont,Oldfont : HFONT;
   MyLFont : LOGFONT;
begin
  if not enabled then
  BackBitmap.Canvas.font.Color:=Buttoncolor else
  BackBitmap.Canvas.font.Color:=self.font.color;
  if BackBitmap.Canvas.Font.Color=clNone then Exit;
  if dcl>0 then BackBitmap.Canvas.font.Color:=getLColor(FButtonColor);
  if dcl<0 then BackBitmap.Canvas.font.Color:=getDColor(FButtonColor);
  GETOBJECT(BackBitmap.Canvas.Font.Handle,sizeof(MyLFont),@MyLFont);
  MyLfont.lfEscapement :=AAngle;
  MyLFont.lfOrientation:=AAngle;
  if Aun then MyLFont.lfUnderline:=1;
  MyFont:=CREATEFONTINDIRECT(MyLFont);
  Oldfont:=selectObject(BackBitmap.canvas.handle,MyFont);
  BackBitmap.Canvas.Brush.Style:=bsClear;
  BackBitmap.Canvas.TextOut(X,Y,Text);
  deleteobject(selectobject(BackBitmap.canvas.handle,Oldfont));
  BackBitmap.Canvas.Brush.Style:=bsSolid;
end;
Procedure TIAeverButton.GetMainBitmap;
var
 dx,dy,x,y : integer;
 Col1,Col2 : Tcolor;
 CUU,CUU1,CDD,CDD1,CU,CD : Tcolor;
begin
  if Needinrepaint then
    begin

          if not assigned(backBitmap) then backBitmap:=Tbitmap.Create
                                      else BackBitmap.freeimage;
          Backbitmap.Width:=self.rWidth;
          BackBitmap.Height:=self.rHeight;
          BackBitmap.PixelFormat:=pf24bit;
      with BackBitmap.Canvas do
        begin
          if not FCustomDraw then
            begin
              //Прорисовка фона...
              if GradientKind=gkNone then
                begin
                  if ButtonColor<>clNone then
                    begin
                      if Enabled then
                                   BackBitmap.Canvas.brush.color:=Buttoncolor
                                 else
                                   BackBitmap.Canvas.brush.color:=GetLcolor(ButtonColor);
                                   BackBitmap.Canvas.fillrect(Rect(0,0,Rwidth,Rheight));
                    end;
                end else
                begin
//                  SelectClipRgn(BackBitmap.Canvas.Handle,0);
                  if enabled then
                     GetGBitmaps(FButtonColor,FButtonColor1,0)
                              else
                     GetGBitmaps(GetLcolor(FButtonColor),GetLcolor(FButtonColor1),2);
                end;
              //Конец прорисовки фона...
              paintBitmaps(isdown);

              //Рисуем Caption;
              DrawCaptionAll;
            end else BackBitmap.canvas.FillRect(clientRect);//customDraw...
          //Конец рисованию Caption
          //Рисуем тени...
          //===================================================
          //===================================================
          if (not UserRGNAUTO) and (ButtonKind=bkUser) then
            begin
            end else
            begin
              if GradientKind=gkNone then
              begin
              if Enabled then
                begin
                  if isDown then
                    begin
                      CUU:=GetDColor(FButtonColor);
                      CDD:=GetLColor(FButtonColor);
                      CUU1:=GetLColor(FButtonColor);
                      CDD1:=GetDColor(FButtonColor);
                      if GetSumColor(FButtonColor)>360 then
                        begin
                          CU:=GetDColor(GetDColor(FButtonColor));
                          CD:=GetDColor(GetDColor(FButtonColor));
                        end else
                        begin
                          CU:=GetLColor(GetLColor(FButtonColor));
                          CD:=GetLColor(GetLColor(FButtonColor));
                        end;
                    end else
                    begin
                      CUU:=GetLColor(FButtonColor);
                      CDD:=GetDColor(FButtonColor);
                      CUU1:=GetLColor(FButtonColor);
                      CDD1:=GetDColor(FButtonColor);
                      if GetSumColor(FButtonColor)>360 then
                        begin
                          CU:=GetDColor(GetDColor(FButtonColor));
                          CD:=GetDColor(GetDColor(FButtonColor));
                        end else
                        begin
                          CU:=GetLColor(GetLColor(FButtonColor));
                          CD:=GetLColor(GetLColor(FButtonColor));
                        end;
                    end;
                end else//enabled...
                begin
                  CUU:=GetLColor(GetLColor(FButtonColor));
                  CDD:=GetDColor(GetLColor(FButtonColor));
                  CUU1:=GetLColor(GetLColor(FButtonColor));
                  CDD1:=GetDColor(GetLColor(FButtonColor));
                  if GetSumColor(FButtonColor)>360 then
                    begin
                      CU:=GetDColor(FButtonColor);
                      CD:=GetDColor(FButtonColor);
                    end else
                    begin
                      CU:=GetLColor(GetLColor(GetLColor(FButtonColor)));
                      CD:=GetLColor(GetLColor(GetLColor(FButtonColor)));
                    end;
                end;//enabled...

              //Colors are ready... Now we get the regions....
              if (Button3DKind=dk3D) or (Button3DKind=dk3dsimple) or (Button3DKind=dk3dBorder) or isMousein then
                begin
                  BackBitmap.Canvas.Brush.color:=CUU;
                  fillRgn(BackBitmap.Canvas.Handle,F3DUpUpper,BackBitmap.Canvas.Brush.Handle);
                  BackBitmap.Canvas.Brush.color:=CDD;
                  fillRgn(BackBitmap.Canvas.Handle,F3DUpDownner,BackBitmap.Canvas.Brush.Handle);
                end;
              if (Button3DKind=dk3dBorder) or (isMousein and (Button3DKind=dk3dBorderFlatten)) then
                begin
                  BackBitmap.Canvas.Brush.color:=CUU1;
                  fillRgn(BackBitmap.Canvas.Handle,F3DUpUpper1,BackBitmap.Canvas.Brush.Handle);
                  BackBitmap.Canvas.Brush.color:=CDD1;
                  fillRgn(BackBitmap.Canvas.Handle,F3DUpDownner1,BackBitmap.Canvas.Brush.Handle);
                end;
              if (Button3DKind=dk3D) or (Button3DKind=dk3dBorder) or
                 (isMousein and ((Button3DKind=dkFlatten) or (Button3DKind=dk3dBorderFlatten))) then
                begin
                  BackBitmap.Canvas.Brush.Color:=CU;
                  BackBitmap.Canvas.Brush.Style:=bsSolid;
                  FrameRgn(BackBitmap.Canvas.handle,FOutBorder,BackBitmap.Canvas.Brush.Handle,1,1);
                end;
              if (Button3DKind=dk3dBorder) or (isMousein and (Button3DKind=dk3dBorderFlatten)) then
                begin
                  BackBitmap.Canvas.Brush.Color:=CD;
                  BackBitmap.Canvas.Brush.Style:=bsSolid;
                  FrameRgn(BackBitmap.Canvas.handle,FInBorder,BackBitmap.Canvas.Brush.Handle,1,1);
                end;
              if isfocused and FShowFocusRGN then
                begin
                  BackBitmap.Canvas.Brush.Color:=CD;
                  BackBitmap.Canvas.Brush.Style:=bsSolid;
                  FrameRgn(BackBitmap.Canvas.handle,FSelectedRgn,BackBitmap.Canvas.Brush.Handle,1,1);
                end;
              //(dk3D,dkFlatten,dk3dsimple,dkFlattenSimple,dk3dBorder,dk3dBorderFlatten,dkNone);
              //CUU,CUU1,CDD,CDD1,CU,CD : Tcolor;
              end else
              begin //of Grad kind;
                 if not Isdown then
                      begin
                        if (Button3DKind=dk3D) or (Button3DKind=dk3dsimple) or (Button3DKind=dk3dBorder) or isMousein then
                          begin
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpUpper);
                            GetGBitmaps(GetLcolor(FButtonColor),GetLcolor(FButtonColor1),1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpDownner);
                            GetGBitmaps(GetDcolor(FButtonColor),GetDcolor(FButtonColor1),-1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                          end;
                        if (Button3DKind=dk3dBorder) or (isMousein and (Button3DKind=dk3dBorderFlatten)) then
                          begin
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpUpper1);
                            GetGBitmaps(GetLcolor(FButtonColor),GetLcolor(FButtonColor1),1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpDownner1);
                            GetGBitmaps(GetDcolor(FButtonColor),GetDcolor(FButtonColor1),-1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                           end;
                        if (Button3DKind=dk3D) or (Button3DKind=dk3dBorder) or
                        (isMousein and ((Button3DKind=dkFlatten) or (Button3DKind=dk3dBorderFlatten))) then
                           begin
                             BackBitmap.Canvas.Brush.Color:=GetDcolor(GetDcolor(FButtonColor));
                             BackBitmap.Canvas.Brush.Style:=bsSolid;
                             FrameRgn(BackBitmap.Canvas.handle,FOutBorder,BackBitmap.Canvas.Brush.Handle,1,1);
                           end;
                        if (Button3DKind=dk3dBorder) or (isMousein and (Button3DKind=dk3dBorderFlatten)) then
                           begin
                             BackBitmap.Canvas.Brush.Color:=GetDcolor(GetDcolor(FButtonColor));
                             BackBitmap.Canvas.Brush.Style:=bsSolid;
                             FrameRgn(BackBitmap.Canvas.handle,FInBorder,BackBitmap.Canvas.Brush.Handle,1,1);
                           end;
                        if isfocused and enabled and FShowFocusRGN then
                           begin
                             BackBitmap.Canvas.Brush.Color:=GetDcolor(FButtonColor);
                             BackBitmap.Canvas.Brush.Style:=bsSolid;
                             FrameRgn(BackBitmap.Canvas.handle,FSelectedRgn,BackBitmap.Canvas.Brush.Handle,1,1);
                           end;
                      end else
                      begin
                        if (Button3DKind=dk3D) or (Button3DKind=dk3dsimple) or (Button3DKind=dk3dBorder) or isMousein then
                          begin
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpUpper);
                            GetGBitmaps(GetDcolor(FButtonColor),GetDcolor(FButtonColor1),-1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpDownner);
                            GetGBitmaps(GetLcolor(FButtonColor),GetLcolor(FButtonColor1),1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                          end;
                        if (Button3DKind=dk3dBorder) or (isMousein and (Button3DKind=dk3dBorderFlatten)) then
                          begin
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpUpper1);
                            GetGBitmaps(GetLcolor(FButtonColor),GetLcolor(FButtonColor1),1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                            SelectClipRgn(BackBitmap.Canvas.Handle,F3DUpDownner1);
                            GetGBitmaps(GetDcolor(FButtonColor),GetDcolor(FButtonColor1),-1);
                            SelectClipRgn(BackBitmap.Canvas.Handle,0);
                           end;
                        if (Button3DKind=dk3D) or (Button3DKind=dk3dBorder) or
                        (isMousein and ((Button3DKind=dkFlatten) or (Button3DKind=dk3dBorderFlatten))) then
                           begin
                             BackBitmap.Canvas.Brush.Color:=GetDcolor(GetDcolor(FButtonColor));
                             BackBitmap.Canvas.Brush.Style:=bsSolid;
                             FrameRgn(BackBitmap.Canvas.handle,FOutBorder,BackBitmap.Canvas.Brush.Handle,1,1);
                           end;
                        if (Button3DKind=dk3dBorder) or (isMousein and (Button3DKind=dk3dBorderFlatten)) then
                           begin
                             BackBitmap.Canvas.Brush.Color:=GetDcolor(GetDcolor(FButtonColor));
                             BackBitmap.Canvas.Brush.Style:=bsSolid;
                             FrameRgn(BackBitmap.Canvas.handle,FInBorder,BackBitmap.Canvas.Brush.Handle,1,1);
                           end;
                        if isfocused and enabled and FShowFocusRGN then
                           begin
                             BackBitmap.Canvas.Brush.Color:=GetDcolor(FButtonColor);
                             BackBitmap.Canvas.Brush.Style:=bsSolid;
                             FrameRgn(BackBitmap.Canvas.handle,FSelectedRgn,BackBitmap.Canvas.Brush.Handle,1,1);
                           end;     
                      end;
              end;
            end;//if  Auto and User...
          //===================================================
          //===================================================

         // The Crossarrow of rotation point...
         if csDesigning in ComponentState then
           begin
             if FRotationCenterFixed then
               begin
                 dx:=FButtonWidth div 2;dy:=FButtonHeight div 2;
               end else
               begin
                 dx:=FRotationPointX;dy:=FrotationPointY;
               end;
             x:=round(abs(FButtonWidth/2.0*cos(FButtonAngle*pi/1800))
                     +abs(FButtonHeight/2.0*sin(FButtonAngle*pi/1800))
                     +(dx-FButtonWidth/2.0)*cos(FButtonAngle*pi/1800)
                     +(dy-FButtonHeight/2.0)*sin(FButtonAngle*pi/1800) );
             y:=round(abs(FButtonWidth/2.0*sin(FButtonAngle*pi/1800))
                     +abs(FButtonHeight/2.0*cos(FButtonAngle*pi/1800))
                     -(dx-FButtonWidth/2.0)*sin(FButtonAngle*pi/1800)
                     +(dy-FButtonHeight/2.0)*cos(FButtonAngle*pi/1800) );
             if GetSumColor(FButtonColor)>360 then
               begin
                 BackBitmap.Canvas.Pen.Color:=clBlack;
                 Col1:=clYellow;
               end else
               begin
                 BackBitmap.Canvas.Pen.Color:=clWhite;
                 Col1:=clBlue;
               end;
             BackBitmap.Canvas.Pen.Style:=psSolid;
             BackBitmap.Canvas.Pen.Width:=1;
             BackBitmap.Canvas.MoveTo(x-5,y);
             BackBitmap.Canvas.LineTo(x-2,y);
             BackBitmap.Canvas.MoveTo(x+3,y);
             BackBitmap.Canvas.LineTo(x+6,y);
             BackBitmap.Canvas.MoveTo(x,y-5);
             BackBitmap.Canvas.LineTo(x,y-2);
             BackBitmap.Canvas.MoveTo(x,y+3);
             BackBitmap.Canvas.LineTo(x,y+6);
             BackBitmap.Canvas.Ellipse(x-2,y-2,x+3,y+3);
             Col2:= BackBitmap.Canvas.Pen.Color;

             BackBitmap.Canvas.Pen.Color:=Col1;
             BackBitmap.Canvas.Ellipse(x-1,y-1,x+2,y+2);
             BackBitmap.Canvas.Pixels[x,y]:=Col2;
           end; //csDesigning
         if Enabled then
           BackBitmap.Canvas.brush.color:=Buttoncolor
                    else
           BackBitmap.Canvas.brush.color:=GetLcolor(ButtonColor);
        end;//BackBitmap Canvas
     end;//Need in repaint
   Needinrepaint:=true;
end;
procedure TIAeverButton.Paint;
var
 stateischanged :Boolean;
begin
 IsDown:=FDrawS.itemState and ODS_SELECTED <> 0;
 stateischanged:=(oldisdown<>isdown) or (oldismousein<>ismousein) or (oldenabled<>enabled);
 if StateisChanged then
   begin
     OldIsDown:=IsDown;
     OldIsMousein:=IsMousein;
     OldEnabled:=Enabled;
   end;

if StateisChanged  then
 begin
   GetMainBitmap;
 end;
 
        if NewKind then
          begin
            NewKind:=false;
            Needinrepaint:=false;
            try
             if FBRgn<>0 then  setwindowRgn(self.handle,FBrgn,True);
            except
            end;
            FBrgn:=0;
            try
            self.Canvas.Draw(0,0,BackBitmap);
            except
            end;
            Needinrepaint:=true;
          end else
          begin
            try
            self.Canvas.Draw(0,0,BackBitmap);
            except
            end;
            Needinrepaint:=true;
          end;
  if Assigned(FOnPaint) then FOnPaint(self);        
end;

procedure TIAeverButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;
procedure TIAeverButton.SetButtonStyle(ADefault: Boolean);
begin
  if ADefault <> IsFocused then
  begin
    IsFocused := ADefault;
    Needinrepaint:=true;
    SetNewKind;
    invalidate;
  end;
end;
procedure TIAeverButton.CNMeasureItem(var Message: TWMMeasureItem);
begin
 with Message.MeasureItemStruct^ do
 begin
   itemHeight:=Height;
   itemWidth:=Width;
 end;
end;
procedure TIAeverButton.CNDrawItem(var Message : TWMDrawItem);
begin
  FDrawS:=Message.DrawItemStruct^;
  Needinrepaint:=true;
  GetMainBitmap;
  invalidate;

  inherited;
end;
procedure TIAeverButton.CMFontChanged(var Message: TMessage);
begin
 inherited;
 Needinrepaint:=true;
 GetMainBitmap;
 invalidate;
end;
procedure TIAeverButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
 Needinrepaint:=true;
 GetMainBitmap;
 
end;
procedure TIAeverButton.WMLButtonDblClick(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN,Message.Keys,Longint(Message.Pos));
end;

//properties
procedure TIAeverButton.SetCaptionTop(Value : integer);
begin
  if value<>FCaptionTop then
  begin
   FCaptionTop:=Value;
   if ILoaded then FCaptionVAlign:=vaNone;
   Needinrepaint:=true;
   GetMainBitmap;
   invalidate;
  end;
end;
procedure TIAeverButton.SetCaptionLeft(Value : integer);
begin
  if value<>FCaptionLeft then
  begin
   FCaptionLeft:=Value;
   if ILoaded then FCaptionHAlign:=haNone;
   Needinrepaint:=true;
   GetMainBitmap;
   invalidate;
  end;
end;
procedure TIAeverButton.SetCaptionAngle(Value : integer);
begin
  if value<>FCaptionAngle then
  begin
   FCaptionAngle:=Value;
   Needinrepaint:=true;
   GetMainBitmap;
   invalidate;
  end;
end;
procedure TIAeverButton.SetButtoncolor(Value : TColor);
begin
  if value<>FButtonColor then
  begin
   FButtonColor:=Value;
   Needinrepaint:=true;
   GetMainBitmap;
   invalidate;
  end;
end;
procedure TIAeverButton.SetButtonKind(Value : TIAButtonKind);
var
  R : Trect;
begin
  if Value<>FButtonKind then
    begin
      FLastButtonKind:=FButtonKind;
      FButtonKind:=Value;
      Dangle:=0;
      if FButtonKind<>bkUser then
        begin
          Needinrepaint:=true;
          SetNewKind;
          invalidate;
        end else
        begin
           if LastinRGN=-1 then
             begin
               if FUserRGNAUTO and (FButtonRegion<>0 )then
                 begin
                   GetRgnBox(FButtonRegion,R);
                   RgnToPoly(FButtonRegion, FMainPoly1,FMainVertex1,FMainPower1);

                   FUserleft:=r.left;
                   FUserTop:=r.Top;
                   FUserWidth:=R.Right-R.Left;
                   FUserHeight:=R.Bottom-R.Top;
                 end;
             end else
             begin
               if FUserRGNAUTO and (FButtonRegion1<>0 )then
                 begin
                   GetRgnBox(FButtonRegion1,R);
                   RgnToPoly(FButtonRegion1, FMainPoly1,FMainVertex1,FMainPower1);

                   FUserleft:=r.left;
                   FUserTop:=r.Top;
                   FUserWidth:=R.Right-R.Left;
                   FUserHeight:=R.Bottom-R.Top;
                 end;
             end;
          Needinrepaint:=true;
          SetNewKind;
          invalidate;
        end;
      FLastButtonKind:=FButtonKind;  
    end;
end;
procedure TIAeverButton.SetButton3DKind(Value : TIA3DKind);
begin
  if Value<>FButton3DKind then
    begin
      FButton3DKind:=Value;
      Needinrepaint:=true;
      SetNewKind;
      invalidate;
    end;
end;
procedure TIAeverButton.SetNewKind;
var

 MainPPoly,InnerPPoly,SelPPoly,Lppoly,Dppoly,OutBorderPoly,InInnerPPoly,Lppoly1,Dppoly1 : Tpoints;
 MainVertex,MaininPower,LVertex,Dvertex,LVertex1,Dvertex1 : Tintegers;
 LN,DN,dx,dy,LN1,DN1 : integer;


begin
//Это процедура подготовки форм для рисования кнопки...
if FBrgn<>0 then
begin
  Newkind:=false;
  deleteobject(FBrgn);
  Fbrgn:=0;
end;

case FButtonKind of
     bkRect :
            begin
              GotMain_Rect(MainPPoly,MainVertex,MaininPower);
            end;
     bkRoundRect :
            begin
              GotMain_RoundRect(MainPPoly,MainVertex,MaininPower);

            end;
     bkElliptic :
            begin
              GotMain_Elliptic(MainPPoly,MainVertex,MaininPower);

            end;
     bkPoly :
            begin
              GotMain_Poly(MainPPoly,MainVertex,MaininPower);

            end;
     bkPolyStar :
            begin
              GotMain_PolyStar(MainPPoly,MainVertex,MaininPower);

            end;
     bkArc :
            begin
              GotMain_Arc(MainPPoly,MainVertex,MaininPower);

            end;
     BkDonut :
            begin
              GotMain_Donut(MainPPoly,MainVertex,MaininPower);

            end;
     bkArrow :
            begin
              GotMain_Arrow(MainPPoly,MainVertex,MaininPower);

            end;
     bkArrow1 :
            begin
              GotMain_Arrow1(MainPPoly,MainVertex,MaininPower);

            end;
     bkArrow2 :
            begin
              GotMain_Arrow2(MainPPoly,MainVertex,MaininPower);

            end;       
     bkCutRect:
            begin
              GotMain_CutRect(MainPPoly,MainVertex,MaininPower);

            end;
     bkCross :
            begin
              GotMain_Cross(MainPPoly,MainVertex,MaininPower);

            end;
     bkCross1 :
            begin
              GotMain_Cross1(MainPPoly,MainVertex,MaininPower);

            end;             
     bkUser :
            begin
              if UserRGNAUTO then
                begin
                  if LastinRGN=1 then
                  begin
                    if FButtonregion1=0 then
                      GotMain_Rect(MainPPoly,MainVertex,MaininPower)
                    else
                      GotMain_USERRGN(MainPPoly,MainVertex,MaininPower);
                  end else
                  begin
                    if FButtonregion=0 then
                      GotMain_Rect(MainPPoly,MainVertex,MaininPower)
                    else
                      GotMain_USERRGN(MainPPoly,MainVertex,MaininPower);
                  end;  
                end;
            end;


   end;
  if (not UserRGNAUTO) and (ButtonKind=bkUser) then
   begin
     FBRGN:=createrectRGN(0,0,0,0);
     if FButtonregion<>0 then
     if LastinRGN=1 then
        begin
          CombineRgn(FBRGN,FButtonregion1,0,RGN_Copy);
        end else
        begin
          CombineRgn(FBRGN,FButtonregion,0,RGN_Copy);
        end;
   end else
   begin
              if RotationCenterFixed then
                begin
                  dx:=FButtonWidth div 2;dy:=FButtonHeight div 2;
                end else
                begin
                  dx:=FRotationPointX;dy:=RotationPointY;
                end;
              nomove:=true;
                ttop:=top-
                round(-FButtonHeight/2.0+
                abs(FbuttonHeight*cos(Fbuttonangle*pi/1800))/2.0+
                abs(FbuttonWidth* sin(Fbuttonangle*pi/1800))/2.0)
                +
                round(-FButtonHeight/2.0+
                abs(FbuttonHeight*cos((Fbuttonangle-Dangle)*pi/1800))/2.0+
                abs(FbuttonWidth* sin((Fbuttonangle-Dangle)*pi/1800))/2.0)
                +round((-FButtonwidth/2.0+dx)*sin(Fbuttonangle*pi/1800)+
                       (FButtonheight/2.0-dy)*cos(Fbuttonangle*pi/1800))
                -round((-FButtonwidth/2.0+dx)*sin((Fbuttonangle-Dangle)*pi/1800)+
                       (FButtonheight/2.0-dy)*cos((Fbuttonangle-Dangle)*pi/1800))

                ;
                lleft:=left-
                round(-FButtonwidth/2.0+
                abs(Fbuttonwidth* cos(Fbuttonangle*pi/1800))/2.0+
                abs(FbuttonHeight*sin(Fbuttonangle*pi/1800))/2.0)
                +
                round(-FButtonwidth/2.0+
                abs(Fbuttonwidth* cos((Fbuttonangle-Dangle)*pi/1800))/2.0+
                abs(FbuttonHeight*sin((Fbuttonangle-Dangle)*pi/1800))/2.0)
                +round((FButtonwidth/2.0-dx)*cos(Fbuttonangle*pi/1800)+
                       (FButtonheight/2.0-dy)*sin(Fbuttonangle*pi/1800))
                -round((FButtonwidth/2.0-dx)*cos((Fbuttonangle-Dangle)*pi/1800)+
                       (FButtonheight/2.0-dy)*sin((Fbuttonangle-Dangle)*pi/1800))

                ;
                Dangle:=0;
              nomove:=false;

              InnerPPoly:=GetPPCopy(MainPPoly);
              GetInner(InnerPPoly,MainVertex,MaininPower,Buttondepth,True,true);
              SelPPoly:=GetPPCopy(MainPPoly);
              if (Button3dKind=dk3dBorder) or (Button3dKind=dk3dBorderFlatten) then
               Getinner(SelPPoly,MainVertex,MaininPower,2*Buttondepth+4,True,true) else
               Getinner(SelPPoly,MainVertex,MaininPower,Buttondepth+4,True,true);
              OutBorderPoly:=GetPPCopy(MainPPoly);
              InInnerPPoly:=GetPPCopy(InnerPPoly);
              GetInner(InInnerPPoly,MainVertex,MaininPower,Buttondepth,True,true);
              //Getinner(OutBorderPoly,MainVertex,MaininPower,1,false,false);

              PolyRotate(MainPpoly,Buttonwidth div 2,Buttonheight div 2,ButtonAngle);
              PolyRotate(SelPPoly,Buttonwidth div 2,Buttonheight div 2,ButtonAngle);
              PolyRotate(InnerPPoly,Buttonwidth div 2,Buttonheight div 2,ButtonAngle);
              PolyRotate(OutBorderPoly,Buttonwidth div 2,Buttonheight div 2,ButtonAngle);
              PolyRotate(InInnerPPoly,Buttonwidth div 2,Buttonheight div 2,ButtonAngle);

              ShiftPoly(MainPPoly,(rWidth-ButtonWidth) div 2,(rHeight-ButtonHeight) div 2);
              ShiftPoly(SelPPoly,(rWidth-ButtonWidth) div 2,(rHeight-ButtonHeight) div 2);
              ShiftPoly(InnerPPoly,(rWidth-ButtonWidth) div 2,(rHeight-ButtonHeight) div 2);
              ShiftPoly(OutBorderPoly,(rWidth-ButtonWidth) div 2,(rHeight-ButtonHeight) div 2);
              ShiftPoly(InInnerPPoly,(rWidth-ButtonWidth) div 2,(rHeight-ButtonHeight) div 2);

              GetLDppoly(MainPpoly,InnerPPoly,MainVertex,Maininpower,Lppoly,DPpoly,Lvertex,Dvertex,Ln,Dn);
              GetLDppoly(InnerPPoly,InInnerPPoly,MainVertex,Maininpower,Lppoly1,DPpoly1,Lvertex1,Dvertex1,Ln1,Dn1);

              FBrgn:=ReCreateRgn(MainPPoly,MainVertex,MaininPower);
              deleteobject(FOutBorder);
              FOutBorder:=ReCreateRgn(OutBorderPoly,MainVertex,MaininPower);
              deleteobject(FInBorder);
              FInBorder:=ReCreateRgn(InInnerPPoly,MainVertex,MaininPower);




              deleteObject(FselectedRgn);
              FSelectedRgn:=ReCreateRgn(SelPPoly,MainVertex,MaininPower);

                   deleteobject(F3DUpUpper);
                   deleteobject(F3DUpDownner);
                   F3DUpUpper:=CreatePolyPolygonRgn(LPPoly[0],LVertex[0],Ln,ALTERNATE);
                   F3DUpDownner:=CreatePolyPolygonRgn(DPPoly[0],DVertex[0],Dn,ALTERNATE);

                   deleteobject(F3DUpUpper1);
                   deleteobject(F3DUpDownner1);
                   F3DUpUpper1:=CreatePolyPolygonRgn(DPPoly1[0],DVertex1[0],Dn1,ALTERNATE);
                   F3DUpDownner1:=CreatePolyPolygonRgn(LPPoly1[0],LVertex1[0],Ln1,ALTERNATE);

                   //------


      end;
   NewKind:=true;
   GetMainBitmap;
  //setwindowRgn(self.handle,FBrgn,True);


end;
procedure TIAeverButton.WMLButtonDown(var Message : TWMLButtonDown);
begin
   if OnEnterPlay then
   begin
//     AnimaTimer.Enabled:=False;
     OnEnterPlay:=False;
     Sendmessage(self.handle,cm_CloseTimer,0,0);

   end;
  if Assigned(FOnClickBitmap) and (not OnClickPlay) then
        begin
          //Оставляю место для остановки предыдущей Анимации...

           //Определяем таймер...
//          if Assigned(AnimaTimer) then AnimaTimer.Free;
//          AnimaTimer:=TTimer.Create(self);
//          AnimaTimer.Interval:=self.OnClickInterval;
          OnClickCount:=0;
          OnClickPlay:=True;
//          AnimaTimer.OnTimer:=AnimaGoOn;
//          AnimaTimer.Enabled:=True;
        end;
  inherited;

end;
procedure TIAeverButton.CMMouseEnter(var Message: TMessage);
begin
 isMouseIn:=True;
 GetMainBitmap;
 invalidate;
 if OnExitPlay then
   begin
//     AnimaTimer.Enabled:=False;
     OnExitPlay:=False;
     Sendmessage(self.handle,cm_CloseTimer,0,0);

   end;
 if Assigned(FOnEnterBitmap) and (not OnEnterPlay) then
   begin
     //Оставляю место для остановки предыдущей Анимации...

     //Определяем таймер...
//     if Assigned(AnimaTimer) then AnimaTimer.Free;
//     AnimaTimer:=TTimer.Create(self);
//     AnimaTimer.Interval:=self.OnEnterInterval;
     OnEnterCount:=0;
     OnEnterPlay:=True;
//     AnimaTimer.OnTimer:=AnimaGoOn;
//     AnimaTimer.Enabled:=True;
   end;

 if assigned(onMouseenter) then onMouseenter(self);
 inherited;
end;
procedure TIAeverButton.CMMouseLeave(var Message: TMessage);
begin
 isMouseIn:=False;
 GetMainBitmap;
 invalidate;
 if OnEnterPlay then
   begin
//     AnimaTimer.Enabled:=False;
     OnEnterPlay:=False;
     Sendmessage(self.handle,cm_CloseTimer,0,0);

   end;
 if OnClickPlay then
   begin
//     AnimaTimer.Enabled:=False;
     OnClickPlay:=False;
     Sendmessage(self.handle,cm_CloseTimer,0,0);

   end;
 if Assigned(FOnExitBitmap) and (not OnExitPlay) then
   begin
     //Оставляю место для остановки предыдущей Анимации...

     //Определяем таймер...
//     if Assigned(AnimaTimer) then AnimaTimer.Free;
//     AnimaTimer:=TTimer.Create(self);
//     AnimaTimer.Interval:=self.OnExitInterval;
     OnExitCount:=0;
     OnExitPlay:=True;
//     AnimaTimer.OnTimer:=AnimaGoOn;
//     AnimaTimer.Enabled:=True;
   end;

 if assigned(onMouseexit) then onMouseExit(self);
 inherited;
end;
procedure TIAeverButton.WMSize(var Message: TWMSize);
var
 al,Oldw,OldH,k : double;
begin
  if not Rotateis then
  begin
  if not Nowh then
    begin
      inherited;
      Rwidth:=width;
      Rheight:=height;
      al:=FButtonangle*pi/1800;
      if abs(sin(al))<1.0e-5 then
        begin
          FButtonwidth:=width;
          FButtonHeight:=height;
          Needinrepaint:=true;
          SetNewKind;
          invalidate;
          end else
        begin
          if abs(cos(al))<1.0e-5 then
            begin
              FButtonwidth:=height;
              FButtonHeight:=width;
              Needinrepaint:=true;
              SetNewKind;
              invalidate;
            end else
            begin
              OldW:=FButtonWidth*cos(al)+FButtonHeight*sin(al);
              OldH:=FButtonWidth*sin(al)+FButtonHeight*cos(al);
              if (OldW>=1) and (OldH>=1) then
              K:=max(width/Oldw,Height/OldH) else k:=1;
              rwidth:=round(k*Oldw);
              rHeight:=round(k*Oldh);
              FButtonWidth:=round(FbuttonWidth*k);
              FButtonHeight:=Round(FButtonHeight*k);
              Needinrepaint:=true;
              SetNewKind;
              NoWh:=true;
              Nomove:=true;
              MoveWindow(self.Handle,lleft,ttop,Rwidth,Rheight,true);
              Nomove:=false;
              NoWh:=false;
            end;
        end;


    end else
    begin
    inherited;
    Rwidth:=width;
    Rheight:=height;
    NOWH:=False;
    end;
    end else
    begin
      rotateis:=false;
      Message.Result:=0;
    end;
end;

procedure TIAeverButton.WMMove(var Message: TWMMove);
begin
  if not Rotateis1 then
  begin

  if not Nomove then
  begin
      inherited;
      GetMainBitmap;
      invalidate;
    if ((csLoading  in ComponentState) or (csReading in ComponentState) )

    then
    begin
      LeftTop:=true;
      Left1:=Left;
      Top1:=top;
    end;
  end else
  begin
    inherited;
    GetMainBitmap;
    invalidate;
  end;
  end else
  begin
    Rotateis1:=false;
    Message.Result:=0;
  end;
end;
procedure TIAeverButton.SetButtonDepth(Value : integer);
begin
  if Value<>FButtonDepth then
    begin
      FButtondepth:=Value;
      Needinrepaint:=true;
      SetNewKind;
      invalidate;
    end;
end;
function TIAeverButton.GetLColor(Value : Tcolor): Tcolor;
var
  pR,pB,pG : pByte;
begin
  result:=colortoRGB(Value);
  pR:=@result;
  pG:=pByte(integer(pR)+1);
  pB:=pByte(integer(pG)+1);
  if pR^>223 then pR^:=255 else inc(pR^,32);
  if pG^>223 then pG^:=255 else inc(pG^,32);
  if pB^>223 then pB^:=255 else inc(pB^,32);
end;
function TIAeverButton.GetDColor(Value : Tcolor): Tcolor;
var
  pR,pB,pG : pByte;
begin
  result:=colortoRGB(Value);
  pR:=@result;
  pG:=pByte(integer(pR)+1);
  pB:=pByte(integer(pG)+1);
  if pR^<32 then pR^:=0 else dec(pR^,32);
  if pG^<32 then pG^:=0 else dec(pG^,32);
  if pB^<32 then pB^:=0 else dec(pB^,32);
end;
procedure TIAeverButton.SetButtonRegion(Value : HRGN);
var
  R : Trect;
begin
  if (Value<>FbuttonRegion1) and (FButtonkind=bkUser) then
    begin
      deleteobject(FButtonRegion1);
      FButtonRegion1:=CreateRectRgn(0,0,0,0);
      CombineRgn(FButtonRegion1,Value,0,RGN_COPY);
      Deleteobject(Value);
      LastinRGn:=1;
      if FButtonKind=bkUser then
        begin
          if FUserRGNAUTO and (FButtonRegion1<>0 )then
            begin
              GetRgnBox(FButtonregion1,R);
              RgnToPoly(FButtonregion1, FMainPoly1,FMainVertex1,FMainPower1);
              FUserleft:=r.left;
              FUserTop:=r.Top;
              FUserWidth:=R.Right-R.Left;
              FUserHeight:=R.Bottom-R.Top;
            end;
          Needinrepaint:=true;
          SetNewKind;
          invalidate;
        end;
    end;
end;
procedure TIAeverButton.SetCaptionHAlign(Value : TIAHAlign);
begin
  if Value<>FCaptionHAlign then
    begin
      FCaptionHAlign:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetCaptionVAlign(Value : TIAVAlign);
begin
  if Value<>FCaptionVAlign then
    begin
      FCaptionVAlign:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetMainBitmap(Value : TBitmap);
begin
  if Value<>FMainBitmap then
    begin
      if (Value=nil) or (Value.height=0) then
        begin
          FMainBitmap.height:=0;
          FMainBitmap.pixelformat:=pf24bit;
        end else
        begin
          FMainBitmap.width:=Value.width;
          FMainBitmap.height:=Value.height;
          FMainBitmap.pixelformat:=pf24bit;
          FmainBitmap.canvas.draw(0,0,Value);
        end;
      Needinrepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetONEnterBitmap(Value : TBitmap);
begin
  if Value<>FOnEnterBitmap then
    begin
      if (Value=nil) or (Value.height=0) then
        begin
          FOnEnterBitmap.height:=0;
          FOnEnterBitmap.pixelformat:=pf24bit;
        end else
        begin
          FOnEnterBitmap.width:=Value.width;
          FOnEnterBitmap.height:=Value.height;
          FOnEnterBitmap.pixelformat:=pf24bit;
          FOnEnterBitmap.canvas.draw(0,0,Value);
        end;
    end;
end;
procedure TIAeverButton.SetONExitBitmap(Value : TBitmap);
begin
  if Value<>FOnExitBitmap then
    begin
      if (Value=nil) or (Value.height=0) then
        begin
          FOnExitBitmap.height:=0;
          FOnExitBitmap.pixelformat:=pf24bit;
        end else
        begin
          FOnExitBitmap.width:=Value.width;
          FOnExitBitmap.height:=Value.height;
          FOnExitBitmap.pixelformat:=pf24bit;
          FOnExitBitmap.canvas.draw(0,0,Value);
        end;
    end;
end;
procedure TIAeverButton.SetONClickBitmap(Value : TBitmap);
begin
  if Value<>FOnClickBitmap then
    begin
      if (Value=nil) or (Value.height=0) then
        begin
          FOnClickBitmap.height:=0;
          FOnClickBitmap.pixelformat:=pf24bit;
        end else
        begin
          FOnClickBitmap.width:=Value.width;
          FOnClickBitmap.height:=Value.height;
          FOnClickBitmap.pixelformat:=pf24bit;
          FOnClickBitmap.canvas.draw(0,0,Value);
        end;
    end;
end;
procedure TIAeverButton.DrawTransparent(x,y : integer;Rfrom : Trect;var B : TBitmap;ToBack : Boolean);
var p1,p2 : pByteArray;
    i,j : integer;
    TrColor : TColor;
    pR,pG,PB : pByte;
    ImageBtnB : TBitmap;
begin
  if not ToBack then
    begin
      ImageBtnB:=TBitmap.Create;
      ImageBtnB.width:=width;
      ImageBtnB.height:=height;
      ImageBtnB.pixelformat:=pf24bit;
      bitblt(ImageBtnB.canvas.handle,0,0,width,height,canvas.handle,0,0,SRCCOPY);
    end else ImageBtnB:=nil; 
  Trcolor:=B.Canvas.Pixels[0,0];
  pR:=@Trcolor;pG:=pByte(integer(pR)+1);pB:=pByte(integer(pG)+1);p2:=nil;
  for i:=Rfrom.top to Rfrom.bottom do
    begin
      if i>=B.height then break else if i<0 then continue;
      p1:=B.scanline[i];
      if ToBack then
        begin
          if ((i-Rfrom.top)+y)>=BackBitmap.height then break else if ((i-Rfrom.top)+y)<0 then continue;
          p2:=BackBitmap.scanline[((i-Rfrom.top)+y)];
        end else
        begin
          if ((i-Rfrom.top)+y)>=ImageBtnB.height then break else if ((i-Rfrom.top)+y)<0 then continue;
          p2:=ImageBtnB.scanline[((i-Rfrom.top)+y)];
        end;
      for j:=Rfrom.left to Rfrom.right do
        begin
          if j>=B.width then break else if j<0 then continue;
          if ToBack then
            begin
              if ((j-Rfrom.left)+x)>=BackBitmap.width then break else if ((j-Rfrom.left)+x)<0 then continue;
            end else
            begin
              if ((j-Rfrom.left)+x)>=ImageBtnB.width then break else if ((j-Rfrom.left)+x)<0 then continue;
            end;
          if (pB^<>p1[3*j]) or (pG^<>p1[3*j+1]) or (pR^<>p1[3*j+2]) then
            begin
              p2[3*((j-Rfrom.left)+x)]:=p1[3*j];
              p2[3*((j-Rfrom.left)+x)+1]:=p1[3*j+1];
              p2[3*((j-Rfrom.left)+x)+2]:=p1[3*j+2];
            end;
        end;
    end;
  if not ToBack then
    begin
      bitblt(canvas.handle,0,0,width,height,ImageBtnB.canvas.handle,0,0,SRCCOPY);
      ImageBtnB.free;
    end;
end;
procedure TIAeverButton.PaintBitmaps(isdown : Boolean);
var
R1,R2,toR : TRECT;
Ng,Dw,dx,dy: integer;

begin
  dx:=0;dy:=0;
  with BackBitmap.canvas do
    begin
      if (FMainBitmap<>nil) and (FMainBitmap.height<>0) then
        begin
          //Определения точки, относительно которой идёт запись Битмапа...
          Ng:=MainBitmapGlyphs;//Переобзываем, а то слишком длинно
          case BitmapHAlign of
            haLeft :
                     begin
                       dx:=ButtonDepth;
                     end;
            haNone :
                     begin
                       dx:=BitmapLeft;
                     end;
            haRight :
                     begin
                       dx:=Width-ButtonDepth-FMainBitmap.Width div Ng;
                     end;
            haCenter :
                     begin
                       dx:=(Width-FMainBitmap.Width div Ng) div 2;
                     end;
          end;
          case BitmapVAlign of
            vaTop :
                     begin
                       dy:=ButtonDepth;
                     end;
            vaNone :
                     begin
                       dy:=BitmapTop;
                     end;
            vaBottom :
                     begin
                       dy:=Height-ButtonDepth-FMainBitmap.Height;
                     end;
            vaCenter :
                     begin
                       dy:=(Height-FMainBitmap.Height) div 2;
                     end;
          end;


          Dw:=FMainBitmap.Width div Ng;
          R1.TopLeft:=Point(0,0);
          R1.BottomRight:=Point(Dw,FMainBitmap.Height);
          toR.TopLeft:=R1.TopLeft;
          toR.BottomRight:=R1.BottomRight;


          Offsetrect(toR,ButtonDepth,ButtonDepth);
          R2.TopLeft:=toR.TopLeft;
          R2.BottomRight:=toR.BottomRight;
          Offsetrect(r2,dx-ButtonDepth,dy-ButtonDepth);
          // Проверка на состояние кнопки...
          if (not isDown) and enabled and (not ismousein) then
            begin //Мыши нет кнопка не нажата и включена... Основное состояние...
              if Transparent then
                begin
                  DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                end else
                begin
                  BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                end;
            end;
          if not enabled then
            begin //Второе основное состояние... отключка...
              if Ng>=2 then
                begin
                  Offsetrect(R1,Dw,0);
                  if Transparent then
                    begin
                      DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                    end else
                    begin
                      BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                    end;
                end else
                begin
                  copymode:=cmMergeCopy;
                  if Transparent then
                    begin
                      DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                    end else
                    begin
                      BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                    end;
                  copymode:=cmSrcCopy;
                end;

            end;
          if (not isDown) and enabled and ismousein then
            begin //Мышa есть кнопка не нажата и включена...  3 e состояние Основное состояние...
              if Ng>=3 then
                begin
                  Offsetrect(R1,2*Dw,0);
                  if Transparent then
                    begin
                      DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                    end else
                    begin
                      BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                    end;
                end else
                begin
                  if Transparent then
                    begin
                      DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                    end else
                    begin
                      BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                    end;
                end;
            end;
          if isDown then
            begin //Мышa нажата...  4 e состояние Основное состояние...
              if Ng=4 then
                begin
                  Offsetrect(R1,3*Dw-1,-1);
                  if Transparent then
                    begin
                      DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                    end else
                    begin
                      BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                    end;
                end else
                begin
                  Offsetrect(R1,-1,-1);
                  if Transparent then
                    begin
                      DrawTransparent(r2.left,r2.top,R1,FMainBitmap,True);
                    end else
                    begin
                      BackBitmap.canvas.Copyrect(R2,FMainBitmap.Canvas,R1);
                    end;
                end;
            end;
        end;
    end;
end;
procedure TIAeverButton.SetMainBitmapGlyphs(Value : integer);
begin
  if (Value>=1) and (Value<=4) and (Value<>FMainBitmapGlyphs) then
    begin
      FMainBitmapGlyphs:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetOnEnterGlyphs(Value : integer);
begin
  if (Value>=1) and (Value<>FOnEnterGlyphs) then
    begin
      FOnEnterGlyphs:=Value;
    end;
end;
procedure TIAeverButton.SetOnExitGlyphs(Value : integer);
begin
  if (Value>=1) and (Value<>FOnExitGlyphs) then
    begin
      FOnExitGlyphs:=Value;
    end;
end;
procedure TIAeverButton.SetOnClickGlyphs(Value : integer);
begin
  if (Value>=1) and (Value<>FOnClickGlyphs) then
    begin
      FOnClickGlyphs:=Value;
    end;
end;
procedure TIAeverButton.SetTransparent(Value : Boolean);
begin
  if Value<>Ftransparent then
    begin
      Ftransparent:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      Invalidate;
    end;
end;
procedure TIAeverButton.SetPeaksNumber(Value : Integer);
begin
  if (Value>=3) and (Value<=20) and (Value<>FPeaksNumber) then
    begin
      FPeaksNumber:=Value;
      if (ButtonKind=bkPoly) or (ButtonKind=bkPolyStar) then
        begin
          Needinrepaint:=true;
          SetNewKind;
          invalidate;
        end;
    end;
end;
procedure TIAeverButton.SetButtonAngle(Value : Integer);
var
 R1,R2 : Hrgn;
begin
  if Value<>FbuttonAngle then
    begin
      Dangle:=Value-FbuttonAngle;
      if CaptionFixed Then
        begin
          inc(FCaptionAngle,Dangle);
          while FCaptionAngle>1800 do dec(FCaptionAngle,3600);
          while FCaptionAngle<=-1800 do inc(FCaptionAngle,3600);
        end;
      if GradientFixed Then
        begin
          inc(FGradientAngle,Dangle);
          while FGradientAngle>1800 do dec(FGradientAngle,3600);
          while FGradientAngle<=-1800 do inc(FGradientAngle,3600);
        end;
      FbuttonAngle:=Value;
      while FbuttonAngle>1800 do dec(FbuttonAngle,3600);
      while FbuttonAngle<=-1800 do inc(FbuttonAngle,3600);
      RWidth:=round(abs(FButtonwidth*cos(FButtonangle*pi/1800))+abs(FButtonHeight*sin(FButtonangle*pi/1800)));
      RHeight:=round(abs(FButtonwidth*sin(FButtonangle*pi/1800))+abs(FButtonHeight*cos(FButtonangle*pi/1800)));
      Needinrepaint:=true;

      SetNewKind;
      NoWh:=true;
      Nomove:=true;
      Rotateis:=true;
      Rotateis1:=true;
      //=======
                try
                  if Parent is Tform then self.Canvas.Brush.Color:=(Parent as TForm).Color;
                  if Parent is TPanel then self.Canvas.Brush.Color:=(Parent as TPanel).Color;
                  self.Canvas.Brush.Style:=bsSolid;

                  if FBrgn<>0 then
                  begin
                        R1:=CreateRectRgn(0,0,0,0);
                        GetWindowRgn(Self.handle,R1);
                        R2:=CreateRectRgn(0,0,0,0);
                        CombineRgn(R2,FBrgn,0,RGN_Copy);
                        OffsetRgn(r2,-Left+Lleft,-Top+Ttop);
                        CombineRgn(R2,R1,R2,RGN_DIFF);
                        deleteobject(R1);
                        OffsetRgn(R2,Left,top);
                        if assigned(parent) then Invalidatergn(parent.handle,r2,true);
                        deleteobject(R2);
                  end else
                  begin
                  self.Canvas.FillRect(Rect(0,0,Width,height));
                  end;
                except
                end;
      //========
      rotateis:=true;
      Rotateis1:=true;
      MoveWindow(self.Handle,lleft,ttop,Rwidth,Rheight,false);
      Nomove:=false;
      NoWh:=false;
      GetMainBitmap;
      invalidate;
      rotateis:=false;
      Rotateis1:=false;
  end;
end;
procedure TIAeverButton.SetButtonWidth(Value : Integer);
begin
  if (Value<>FbuttonWidth) and (Value>=0) then
    begin
      FbuttonWidth:=Value;
      rWidth:=round(abs(FButtonwidth*cos(FButtonangle*pi/1800))+abs(FButtonHeight*sin(FButtonangle*pi/1800)));
      rHeight:=round(abs(FButtonwidth*sin(FButtonangle*pi/1800))+abs(FButtonHeight*cos(FButtonangle*pi/1800)));
      Needinrepaint:=true;
      SetNewKind;

      NoWh:=true;
      Nomove:=true;
      MoveWindow(self.Handle,lleft,ttop,Rwidth,Rheight,true);
      Nomove:=false;
      NoWh:=false;
      invalidate;


    end;
end;

procedure TIAeverButton.SetButtonHeight(Value : Integer);
begin
  if (Value<>FbuttonHeight) and (Value>=0) then
    begin
      FbuttonHeight:=Value;
      rHeight:=round(abs(FButtonwidth*sin(FButtonangle*pi/1800))+abs(FButtonHeight*cos(FButtonangle*pi/1800)));
      rWidth:=round(abs(FButtonwidth*cos(FButtonangle*pi/1800))+abs(FButtonHeight*sin(FButtonangle*pi/1800)));

      Needinrepaint:=true;
      SetNewKind;
      
      NoWh:=true;
      Nomove:=true;
      MoveWindow(self.Handle,lleft,ttop,Rwidth,Rheight,true);
      Nomove:=false;
      NoWh:=false;
      invalidate;

    end;
end;
procedure TIAeverButton.ShiftPoly(var points : array of Tpoint;dx,dy : integer);
var
i: integer;
begin
  for i:=0 to High(Points) do
    begin
      points[i].x:=points[i].x+dx;
      points[i].y:=points[i].y+dy;
    end;
end;


procedure TIAeverButton.SetBitmapHAlign(Value : TIAHAlign);
begin
  if Value<>FBitmapHAlign then
    begin
      FBitmapHAlign:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetBitmapVAlign(Value : TIAVAlign);
begin
  if Value<>FBitmapVAlign then
    begin
      FBitmapVAlign:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetBitmapTop(Value : integer);
begin
  if value<>FBitmapTop then
  begin
   FBitmapTop:=Value;
   if ILoaded then FBitmapVAlign:=vaNone;
   Needinrepaint:=true;
   GetMainBitmap;
   invalidate;
  end;
end;
procedure TIAeverButton.SetBitmapLeft(Value : integer);
begin
  if value<>FBitmapLeft then
  begin
   FBitmapLeft:=Value;
   if ILoaded then FBitmapHAlign:=haNone;
   Needinrepaint:=true;
   GetMainBitmap;
   invalidate;
  end;
end;
procedure TIAeverButton.SetOnEnterInterval(Value : integer);
begin
  if (not OnEnterPlay) and (value <> FOnEnterInterval) then
    begin
      FOnEnterInterval:=Value;
    end;
end;
procedure TIAeverButton.SetOnExitInterval(Value : integer);
begin
  if (not OnExitPlay) and (value <> FOnExitInterval) then
    begin
      FOnExitInterval:=Value;
    end;
end;
procedure TIAeverButton.SetOnClickInterval(Value : integer);
begin
  if (not OnClickPlay) and (value <> FOnClickInterval) then
    begin
      FOnClickInterval:=Value;
    end;
end;
(*
procedure TIAeverButton.AnimaGoOn(Sender : TObject);
begin
  if OnenterPlay then
  begin
  if OnEnterCount<OnEnterGlyphs then
    begin
      DrawBMPGlyph(OnEnterBitmap,OnEnterGlyphs,OnEnterCount);
      inc(OnEnterCount);
    end else
    begin
      invalidate;
//      AnimaTimer.Enabled:=False;
      OnEnterPlay:=False;
      Sendmessage(self.handle,cm_CloseTimer,0,0);

    end;
  end;
  if OnexitPlay then
  begin
  if OnExitCount<OnExitGlyphs then
    begin
      DrawBMPGlyph(OnExitBitmap,OnExitGlyphs,OnExitCount);
      inc(OnExitCount);
    end else
    begin
      invalidate;
//      AnimaTimer.Enabled:=False;
      OnExitPlay:=False;
      Sendmessage(self.handle,cm_CloseTimer,0,0);

    end;
  end;
  if OnClickPlay then
  begin
  if OnClickCount<OnClickGlyphs then
    begin
      DrawBMPGlyph(OnClickBitmap,OnClickGlyphs,OnClickCount);
      inc(OnClickCount);
    end else
    begin
      invalidate;
//      AnimaTimer.Enabled:=False;
      OnClickPlay:=False;
      Sendmessage(self.handle,cm_CloseTimer,0,0);

    end;
  end;
end;

procedure TIAeverButton.DrawBMPGlyph(Bitmap : TBitmap;Glyphs,Count : integer);
var
R1,R2,toR : TRECT;
Ng,Dw,dx,dy: integer;

begin
  dx:=0;dy:=0;
  with canvas do
    begin
          //Определения точки, относительно которой идёт запись Битмапа...
          Ng:=Glyphs;//Переобзываем, а то слишком длинно
          case BitmapHAlign of
            haLeft :
                     begin
                       dx:=ButtonDepth;
                     end;
            haNone :
                     begin
                       dx:=BitmapLeft;
                     end;
            haRight :
                     begin
                       dx:=Width-ButtonDepth-Bitmap.Width div Ng;
                     end;
            haCenter :
                     begin
                       dx:=(Width-Bitmap.Width div Ng) div 2;
                     end;
          end;
          case BitmapVAlign of
            vaTop :
                     begin
                       dy:=ButtonDepth;
                     end;
            vaNone :
                     begin
                       dy:=BitmapTop;
                     end;
            vaBottom :
                     begin
                       dy:=Height-ButtonDepth-Bitmap.Height;
                     end;
            vaCenter :
                     begin
                       dy:=(Height-Bitmap.Height) div 2;
                     end;
          end;


          Dw:=Bitmap.Width div Ng;
          R1.TopLeft:=Point(0,0);
          R1.BottomRight:=Point(Dw,ClientRect.Bottom);
          toR.TopLeft:=R1.TopLeft;
          toR.BottomRight:=R1.BottomRight;


          Offsetrect(toR,ButtonDepth,ButtonDepth);
          R2.TopLeft:=toR.TopLeft;
          R2.BottomRight:=toR.BottomRight;
          Offsetrect(r2,dx-ButtonDepth,dy-ButtonDepth);
          OffsetRect(R1,Count*Dw,0);
          // Проверка на состояние кнопки...
                if self.Transparent then
                begin
                  DrawTransparent(r2.left,r2.top,R1,Bitmap,false);
                end else
                begin
                  Copyrect(R2,Bitmap.Canvas,R1);
                end;
    end;
end;
*)
procedure TIAeverButton.CMCLOSETIMER(var Message: TMessage);
begin
  inherited;
//  Animatimer.OnTimer:=Nil;
//  AnimaTimer.Free;
//  AnimaTimer:=Nil;
end;
procedure TIAeverButton.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  if not First then
  begin
  if Focused then
    begin
      if OnExitPlay then
        begin
//          AnimaTimer.Enabled:=False;
          OnExitPlay:=False;
          Sendmessage(self.handle,cm_CloseTimer,0,0);

        end;
      if Assigned(FOnEnterBitmap) and (not OnEnterPlay) then
        begin
         //Оставляю место для остановки предыдущей Анимации...

         //Определяем таймер...
//         if Assigned(AnimaTimer) then AnimaTimer.Free;
//         AnimaTimer:=TTimer.Create(self);
//         AnimaTimer.Interval:=self.OnEnterInterval;
         OnEnterCount:=0;
         OnEnterPlay:=True;
//         AnimaTimer.OnTimer:=AnimaGoOn;
//         AnimaTimer.Enabled:=True;
   end;
    end else
    begin
      if OnEnterPlay then
        begin
//          AnimaTimer.Enabled:=False;
          OnEnterPlay:=False;
          Sendmessage(self.handle,cm_CloseTimer,0,0);

        end;
      if OnClickPlay then
        begin
//          AnimaTimer.Enabled:=False;
          OnClickPlay:=False;
          Sendmessage(self.handle,cm_CloseTimer,0,0);

        end;
      if Assigned(FOnExitBitmap) and (not OnExitPlay) then
        begin
          //Оставляю место для остановки предыдущей Анимации...

           //Определяем таймер...
//          if Assigned(AnimaTimer) then AnimaTimer.Free;
//          AnimaTimer:=TTimer.Create(self);
//          AnimaTimer.Interval:=self.OnExitInterval;
          OnExitCount:=0;
          OnExitPlay:=True;
//          AnimaTimer.OnTimer:=AnimaGoOn;
//          AnimaTimer.Enabled:=True;
        end;
    end;
   end else first:=false;
end;
procedure TIAeverButton.wmKeyDown(var Message : TwmKeyDown);
begin
  inherited;
  if Message.CharCode=32 then
    begin
      if OnEnterPlay then
        begin
//          AnimaTimer.Enabled:=False;
          OnEnterPlay:=False;
          Sendmessage(self.handle,cm_CloseTimer,0,0);
        end;
      if Assigned(FOnClickBitmap) and (not OnClickPlay) then
        begin
          //Оставляю место для остановки предыдущей Анимации...

           //Определяем таймер...
//          if Assigned(AnimaTimer) then AnimaTimer.Free;
//          AnimaTimer:=TTimer.Create(self);
//          AnimaTimer.Interval:=self.OnClickInterval;
          OnClickCount:=0;
          OnClickPlay:=True;
//          AnimaTimer.OnTimer:=AnimaGoOn;
//          AnimaTimer.Enabled:=True;
        end;
    end;
end;
procedure TIAeverButton.SetStringButtonRegion(Value : TIASTRINGRGNDATA);
  var
    RD1 : PRGNDATA;
    I,RGNSize : integer;
    p1,p2 : pByte;
    R : TRect;
begin
  if Value<>FStringButtonRegion then
    begin
      FStringButtonRegion:=Value;
      if Value='' then
        begin
           if FButtonRegion<>0 then deleteobject(FButtonRegion);
            FButtonRegion:=CreateRectRgn(0,0,FButtonWidth,FButtonHeight);
        end else
        begin
      RGNSize:=Length(FStringButtonRegion) div 2;
      Getmem(pointer(RD1),RGNSize+sizeof(RD1^));
      p1:=pbyte(FStringButtonRegion);
      p2:=pbyte(rd1);
      for i:=1 to RGNSize do
      begin
        if p1^=33 then
          begin
            p1:=pbyte(integer(p1)+1);
            p2^:=p1^-128;
            p1:=pbyte(integer(p1)+1);
          end else
          begin
            p2^:=p1^;
            p1:=pbyte(integer(p1)+2);
          end;
        p2:=pbyte(integer(p2)+1);
      end;
      Myxdata.eM11:=1.0;
      Myxdata.eM22:=1.0;
      Myxdata.eM12:=0.0;
      Myxdata.eM21:=0.0;
      Myxdata.eDx:=0.0;
      Myxdata.eDy:=0.0;

      if FButtonRegion<>0 then deleteobject(FButtonRegion);
      FButtonRegion:=extCreateRegion(@Myxdata,RgnSize,RD1^);
      freemem(pointer(RD1),RGNSize+sizeof(RD1^));
      end;//Null string...

      LastinRGN:=-1;

      if FButtonKind=bkUser then
        begin
          if FUserRGNAUTO and (FButtonRegion<>0 )then
            begin

              GetRgnBox(FButtonRegion,R);
              RgnToPoly(FButtonRegion, FMainPoly1,FMainVertex1,FMainPower1);

              FUserleft:=r.left;
              FUserTop:=r.Top;
              FUserWidth:=R.Right-R.Left;
              FUserHeight:=R.Bottom-R.Top;
            end;
          Needinrepaint:=true;
          SetNewKind;
          invalidate;
        end;
    end;
end;
procedure TIAeverButton.SetUserRGNAUTO(Value : Boolean);
var
  R : TRect;
begin
  if Value<>FUserRGNAUTO then
    begin

      FUserRGNAUTO:=Value;
      if FButtonKind=bkUser then
        begin
           if LastinRGN=1 then
        begin
        if FUserRGNAUTO and (FButtonRegion1<>0 )then
        begin
        GetRgnBox(FButtonregion1,R);
        RgnToPoly(FButtonregion1, FMainPoly1,FMainVertex1,FMainPower1);
        FUserleft:=r.left;
        FUserTop:=r.Top;
        FUserWidth:=R.Right-R.Left;
        FUserHeight:=R.Bottom-R.Top;
        end;
        end else
        begin
        if FUserRGNAUTO and (FButtonRegion<>0 )then
        begin

        GetRgnBox(FButtonRegion,R);
        RgnToPoly(FButtonRegion, FMainPoly1,FMainVertex1,FMainPower1);

        FUserleft:=r.left;
        FUserTop:=r.Top;
        FUserWidth:=R.Right-R.Left;
        FUserHeight:=R.Bottom-R.Top;
        end;
        end;

        end;
        Needinrepaint:=true;
        SetNewKind;
        invalidate;
    end;
end;
procedure TIAeverButton.SetRotationPointX(Value : Integer);
begin
  if (Value<>FRotationPointX) then
    begin
      FRotationPointX:=Value;
      FRotationCenterFixed:=false;
      Needinrepaint:=true;
      SetnewKind;
      Invalidate;
    end;
end;
procedure TIAeverButton.SetRotationPointY(Value : Integer);
begin
  if (Value<>FRotationPointY) then
    begin
      FRotationPointY:=Value;
      FRotationCenterFixed:=false;
      Needinrepaint:=true;
      SetnewKind;
      Invalidate;
    end;
end;

procedure TIAeverButton.SetRotationCenterFixed(Value : Boolean);
begin
  if Value<>FRotationCenterFixed then
    begin
      FRotationCenterFixed:=Value;
      Needinrepaint:=true;
      SetnewKind;
      Invalidate;
    end;
end;
Function TIAeverButton.GetSumColor(Value : Tcolor): integer;
var
 pR,pG,pB : pByte;
 C : Tcolor;


begin
  C:=ColorToRGB(Value);
  pR:=pByte(@C);
  pG:=pbyte(integer(pR)+1);
  pB:=pbyte(integer(pG)+1);
  Result:=pR^+pB^+pG^;

end;
procedure TIAeverButton.SetArcAngle(Value : Double);
begin
  if (Value>=0.01) and (Value<=2.0*Pi) and (Value<>FArcAngle) then
    begin
      FArcAngle:=Value;
      if (FButtonKind=bkArc) then
        begin
          Needinrepaint:=true;
          SetnewKind;
          Invalidate;
        end;
    end;
end;
procedure TIAeverButton.SetGradientBitmap(Value : Tbitmap);
begin
  FGradientBitmap.assign(Value);
  Needinrepaint:=true;
          SetnewKind;
          Invalidate;
end;
procedure TIAeverButton.SetRadiusRatio(Value : Double);
begin
  if Value<>FRadiusRatio then
    begin
      if (Value>=0.0) and (Value<=1.0) then
        begin
          FRadiusRatio:=Value;
          if (FButtonKind=bkDonut) or (FButtonKind=bkArc) then
            begin
              Needinrepaint:=true;
              SetnewKind;
              Invalidate;
            end;
        end;
    end;
end;
procedure TIAeverButton.SetRotated(Value : Boolean);
begin
  if Value<>Frotated then
    begin
      Frotated:=Value;
      if Value  then
        begin
          FRotatedTimer.Resume;
        end else
        begin
          FRotatedTimer.Suspend;
        end;
    end;
end;
procedure TIAeverButton.CMROTATEDON(var Message: TMessage);
begin
  self.ButtonAngle:=self.ButtonAngle+self.RotatedAngle;
end;

procedure TIAeverButton.SetRotatedTime(Value : Integer);
begin
  if (Value<>FRotatedTime) and (Value>=0) then
    begin
      FRotatedTime:=Value;
      if FRotatedTimer.Suspended then
        begin
          FRotatedTimer.Dtime:=Value;
        end else
        begin
          FRotatedTimer.Suspend;
          FRotatedTimer.Dtime:=Value;
          FRotatedTimer.Resume;
        end;
    end;
end;

procedure TIAeverButton.SetRotatedAngle(Value : Integer);
begin
  if (Value<1800) and (value>-1800) and (value<>FRotatedangle) then
    begin
      FRotatedangle:=Value;
    end;
end;
procedure TIAeverButton.SetCaptionFixed(Value : Boolean);
begin
  if Value<>FCaptionFixed then
    begin
      FCaptionFixed:=Value;
      NeedinRepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetCaption3dKind(Value : TIACaption3dKind);
begin
  if Value<>FCaption3dKind then
    begin
      FCaption3dKind:=Value;
      NeedinRepaint:=true;
      GetMainBitmap;
      invalidate;
    end;
end;
procedure TIAeverButton.SetButtonColor1(Value : TColor);
begin
  if Value<>FButtonColor1 then
    begin
      FButtonColor1:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      Invalidate;
    end;
end;
procedure TIAeverButton.SetGradientKind(Value : TIAGradientKind);
begin
  if Value<>FGradientKind then
    begin
      FGradientKind:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      Invalidate;
    end;
end;
procedure TIAeverButton.SetGradientAngle(Value : Integer);
begin
  if Value<>FGradientAngle then
    begin
      FGradientAngle:=Value;
      Needinrepaint:=true;
      GetMainBitmap;
      Invalidate;
    end;
end;
procedure TIAeverButton.SetGradientFixed(Value : Boolean);
begin
  if Value<>FGradientFixed then
    begin
      FGradientFixed:=Value;
    end;
end;
procedure TIAeverButton.SetGradientBitmapLine(Value : integer);
begin
  if (Value<>FGradientBitmapLine) and (Value>=0) then
    begin
       FGradientBitmapLine:=value;
       Needinrepaint:=true;
       GetMainBitmap;
       Invalidate;
    end;
end;
function GetCColor(Color01,Color02: Tcolor;R,i :integer): Tcolor;
var
  C1,C2 : Tcolor;
  R1,G1,B1,R2,G2,B2 : Byte;
begin
  c1:=ColorTorgb(Color01);
  c2:=ColorTorgb(Color02);
  R1:=Pbyte(@C1)^;
  G1:=Pbyte(integer(@C1)+1)^;
  B1:=Pbyte(integer(@C1)+2)^;
  R2:=Pbyte(@C2)^;
  G2:=Pbyte(integer(@C2)+1)^;
  B2:=Pbyte(integer(@C2)+2)^;
  if R<>0 then
  Result:=RGB((R1+(R2-R1)*i div R),(G1+(G2-G1)*i div R),(B1+(B2-B1)*i div R))
  else result:=Color01;


end;
procedure TIAeverButton.GetGBitmaps(C1,C2 : Tcolor;updown : integer);
var
  NofLines,i,Q,L1 : Integer;
  L,dx,dy,x0,y0,L0,Cs,Sn : Double;
begin
  if FGradientKind<>gkNone then
    begin
      if FGradientKind=gkLinear then
      begin
      backBitmap.Canvas.Pen.width:=3;
      Cs:=cos(FGradientAngle*pi/1800);
      Sn:=sin(FGradientAngle*pi/1800);
      L:=abs(Rwidth*Sn)+abs(Rheight*Cs);
      L0:=sqrt(sqr(Rwidth)+sqr(Rheight));
      NofLines:=round(L/3);q:=0;
      if (Cs>=0) and (Sn>=0) then Q:=1;
      if (Cs>=0) and (Sn<0) then Q:=4;
      if (Cs<0)  and (Sn>=0) then Q:=2;
      if (Cs<0)  and (Sn<0) then Q:=3;
      dx:=3*Sn;dy:=3*Cs;x0:=0;y0:=0;
      if q=1 then
        begin
          x0:=Rwidth*(1-sqr(Sn));
          y0:=-Rwidth*Sn*Cs;
        end;
      if q=2 then
        begin
          x0:=Rheight*Sn*Cs;
          y0:=RHeight*(1-sqr(Sn));
        end;
      if q=3 then
        begin
          x0:=Rwidth*sqr(Sn);
          y0:=Rheight+Rwidth*Sn*Cs;
        end;
      if q=4 then
        begin
          x0:=Rwidth-Rheight*Sn*Cs;
          y0:=RHeight*(1-sqr(Cs));
        end;
      for i:=0 to NofLines do
        begin
          if (not assigned(FGradientBitmap)) or (FGradientBitmap.width=0)then
            begin
              BackBitmap.Canvas.Pen.color:=GetCColor(C1,C2,NofLines,i);
            end else
            begin
              if FGradientBitmapLine<FGradientBitmap.height then
                L1:=FGradientBitmapLine else
                L1:=0;
              case Updown of
                1 :
                  begin
                    BackBitmap.Canvas.Pen.color:=
                    GetLColor(FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1]);
                  end;
                 0 :
                   begin
                     BackBitmap.Canvas.Pen.color:=
                     FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1];
                   end;
                -1 :
                   begin
                     BackBitmap.Canvas.Pen.color:=
                     GetDColor(FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1]);
                   end;
                2: begin
                     BackBitmap.Canvas.Pen.color:=
                     getLColor(getLColor(FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1]));
                   end;
                else
                   begin
                     BackBitmap.Canvas.Pen.color:=
                     FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1];
                   end;
            end;             

            end;
          BackBitmap.Canvas.Moveto(round(x0+i*dx),Round(y0+i*dy));
          BackBitmap.Canvas.Lineto(round(x0+i*dx-L0*Cs),
                                   Round(y0+i*dy+L0*Sn));
        end;
    end else//gkLinear...
    begin
      backBitmap.Canvas.Pen.width:=3;
      L:=sqrt(sqr(Rwidth)+sqr(Rheight))/2.0;
      NofLines:=round(L/3);
      BackBitmap.Canvas.Brush.Color:=C1;
      for i:=NofLines downto 0 do
        begin
           if (not assigned(FGradientBitmap)) or (FGradientBitmap.width=0)then
            begin
              BackBitmap.Canvas.Pen.color:=GetCColor(C1,C2,NofLines,i);
            end else
            begin
              if FGradientBitmapLine<FGradientBitmap.height then
                L1:=FGradientBitmapLine else
                L1:=0;
              case Updown of
                1 :
                  begin
                    BackBitmap.Canvas.Pen.color:=
                    GetLColor(FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1]);
                  end;
                 0 :
                   begin
                     BackBitmap.Canvas.Pen.color:=
                     FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1];
                   end;
                -1 :
                   begin
                     BackBitmap.Canvas.Pen.color:=
                     GetDColor(FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1]);
                   end;
                2: begin
                     BackBitmap.Canvas.Pen.color:=
                     getLColor(getLColor(FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1]));
                   end;
                else
                   begin
                     BackBitmap.Canvas.Pen.color:=
                     FGradientBitmap.canvas.pixels[FGradientBitmap.width*i div NofLines,L1];
                   end;
            end;             

            end;
           BackBitmap.Canvas.ellipse((Rwidth div 2)-i*3,(Rheight div 2)-i*3,(Rwidth div 2)+i*3,(Rheight div 2)+i*3);
        end;
    end;//gkLinear..
    end;//GradKind...
end;
// ---- There will begin the defined forms -------------------------------------------------------
procedure TIAeverButton.GotMain_Arc(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
  var
    i,L,N,d,N1,N2 : integer;
    Rout,Rin : integer;
    th,tw : integer;
begin
  d:=max(2,FButtondepth);
  L:=Max(FButtonWidth,FButtonHeight);
  N1:=L div d;
  N2:=round(N1*FRadiusRatio);
  N:=N1+N2;
  if (Farcangle<0.1)   then
   begin
     GotMain_Rect(MainPPoly,MainVertex,MaininPower);
   end else
   begin
     Rout:=round(FButtonwidth/(2*sin(arcangle/2.0)));
     if arcangle>=pi then
     begin
       Rout:=(FButtonwidth div 2);
       Rin:= round(FRadiusratio*Rout);
       FbuttonHeight:=round(Rout-Rout*cos(arcangle/2.0));
     end else
     begin
     Rin:=round(FRadiusratio*Rout);
     FbuttonHeight:=round(Rout*(1-RadiusRatio*cos(arcangle/2.0)));
     end;

      th:=round(abs(FButtonwidth*sin(FButtonangle*pi/1800))+abs(FButtonHeight*cos(FButtonangle*pi/1800)));
      tw:=round(abs(FButtonwidth*cos(FButtonangle*pi/1800))+abs(FButtonHeight*sin(FButtonangle*pi/1800)));

      NoWh:=true;
      if assigned(parent) then
        begin
          if FLastButtonKind<>bkArc then MoveWindow(self.Handle,left,top,tw,th,true) else
            MoveWindow(self.Handle,left,top,tw,th,false)
         end else
         begin
           width:=tw;
           NoWh:=true;
           height:=th;
         end;               
      NoWh:=false;

      SetLength(MainPPoly,N);
      Setlength(MainVertex,1);
      SetLength(Maininpower,1);

      for i:=0 to N1-1 do
        begin
          MainPPoly[i].x:=round(ButtonWidth/2.0+Rout*sin(i*arcangle/(N1-1)-arcangle/2));
          MainPPoly[i].y:=round(Rout-Rout*cos(i*arcangle/(N1-1)-arcangle/2));
        end;
      for i:=0 to N2-1 do
        begin
          MainPPoly[N-1-i].x:=round(ButtonWidth/2.0+Rin*sin(i*arcangle/(N2-1)-arcangle/2));
          MainPPoly[N-1-i].y:=round(Rout-Rin*cos(i*arcangle/(N2-1)-arcangle/2));
        end;

  MainVertex[0]:=N;
  Maininpower[0]:=0;
  end;
end;
procedure TIAeverButton.GotMain_Rect(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,4);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);
  MainPPoly[0].x:=0;
  MainPPoly[0].y:=0;
  MainPPoly[1].x:=Buttonwidth;
  MainPPoly[1].y:=0;
  MainPPoly[2].x:=Buttonwidth;
  MainPPoly[2].y:=ButtonHeight;
  MainPPoly[3].x:=0;
  MainPPoly[3].y:=ButtonHeight;


  MainVertex[0]:=4;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_RoundRect(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
var
  dd,Bw,Bh : integer;
begin
  dd:=2*ButtonDepth;
  Bw:=ButtonWidth;
  Bh:=ButtonHeight;
  SetLength(MainPPoly,20);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);
  MainPPoly[0].x:=dd;
  MainPPoly[0].y:=0;
  MainPPoly[1].x:=Bw-dd;
  MainPPoly[1].y:=0;
  MainPPoly[2].x:=Bw-dd+round(dd*sin(pi/8));
  MainPPoly[2].y:=dd-round(dd*cos(pi/8));
  MainPPoly[3].x:=Bw-dd+round(dd*sin(2*pi/8));
  MainPPoly[3].y:=dd-round(dd*cos(2*pi/8));
  MainPPoly[4].x:=Bw-dd+round(dd*sin(3*pi/8));
  MainPPoly[4].y:=dd-round(dd*cos(3*pi/8));

  MainPPoly[5].x:=Bw;
  MainPPoly[5].y:=dd;
  MainPPoly[6].x:=Bw;
  MainPPoly[6].y:=Bh-dd;
  MainPPoly[7].x:=Bw-dd+round(dd*cos(pi/8));
  MainPPoly[7].y:=Bh-dd+round(dd*sin(pi/8));
  MainPPoly[8].x:=Bw-dd+round(dd*cos(2*pi/8));
  MainPPoly[8].y:=Bh-dd+round(dd*sin(2*pi/8));
  MainPPoly[9].x:=Bw-dd+round(dd*cos(3*pi/8));
  MainPPoly[9].y:=Bh-dd+round(dd*sin(3*pi/8));

  MainPPoly[10].x:=Bw-dd;
  MainPPoly[10].y:=Bh;
  MainPPoly[11].x:=dd;
  MainPPoly[11].y:=Bh;
  MainPPoly[12].x:=dd-round(dd*sin(pi/8));
  MainPPoly[12].y:=Bh-dd+round(dd*cos(pi/8));
  MainPPoly[13].x:=dd-round(dd*sin(2*pi/8));
  MainPPoly[13].y:=Bh-dd+round(dd*cos(2*pi/8));
  MainPPoly[14].x:=dd-round(dd*sin(3*pi/8));
  MainPPoly[14].y:=Bh-dd+round(dd*cos(3*pi/8));

  MainPPoly[15].x:=0;
  MainPPoly[15].y:=Bh-dd;
  MainPPoly[16].x:=0;
  MainPPoly[16].y:=dd;
  MainPPoly[17].x:=dd-round(dd*cos(pi/8));
  MainPPoly[17].y:=dd-round(dd*sin(pi/8));
  MainPPoly[18].x:=dd-round(dd*cos(2*pi/8));
  MainPPoly[18].y:=dd-round(dd*sin(2*pi/8));
  MainPPoly[19].x:=dd-round(dd*cos(3*pi/8));
  MainPPoly[19].y:=dd-round(dd*sin(3*pi/8));





  MainVertex[0]:=20;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Donut(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
var
  i,L,N,d : integer;
begin
  d:=max(2,FButtondepth);
  L:=Max(FButtonWidth,FButtonHeight);
  N:=2*L div d;
  SetLength(MainPPoly,2*N);
  Setlength(MainVertex,2);
  SetLength(Maininpower,2);
  for i:=0 to N-1 do
    begin
      MainPPoly[i].x:=round(ButtonWidth*sin(2*pi*i/N)/2+Buttonwidth/2.0);
      MainPPoly[i].y:=round(-ButtonHeight*cos(2*pi*i/N)/2+ButtonHeight/2.0);
    end;
  for i:=N to 2*N-1 do
    begin
      MainPPoly[i].x:=round(ButtonWidth*sin(2*pi*i/N)*FRadiusRatio/2+Buttonwidth/2.0);
      MainPPoly[i].y:=round(-ButtonHeight*cos(2*pi*i/N)*FRadiusRatio/2+ButtonHeight/2.0);
    end;


  MainVertex[0]:=N;
  MainVertex[1]:=N;
  Maininpower[0]:=0;
  Maininpower[1]:=1;
end;
procedure  TIAeverButton.GotMain_Elliptic(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
var
  i,L,N,d : integer;
begin
  d:=max(2,FButtondepth);
  L:=Max(FButtonWidth,FButtonHeight);
  N:=L div d;
  SetLength(MainPPoly,N);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);
  for i:=0 to N-1 do
    begin
      MainPPoly[i].x:=round(FButtonWidth*sin(2*pi*i/N)/2+FButtonwidth/2.0);
      MainPPoly[i].y:=round(-FButtonHeight*cos(2*pi*i/N)/2+FButtonHeight/2.0);
    end;

  MainVertex[0]:=N;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Poly(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
var
  i : integer;
begin
  SetLength(MainPPoly,PeaksNumber);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);
  for i:=0 to PeaksNumber-1 do
    begin
      MainPPoly[i].x:=round(ButtonWidth*sin(2*pi*i/(PeaksNumber))/2+Buttonwidth/2.0);
      MainPPoly[i].y:=round(-ButtonHeight*cos(2*pi*i/(PeaksNumber))/2+ButtonHeight/2.0);
    end;

  MainVertex[0]:=PeaksNumber;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Arrow(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,7);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);

  MainPPoly[0].x:=0;                MainPPoly[0].y:=Buttonheight div 3;
  MainPPoly[1].x:=Buttonwidth div 2;MainPPoly[1].y:=Buttonheight div 3;
  MainPPoly[2].x:=Buttonwidth div 2;MainPPoly[2].y:=0;
  MainPPoly[3].x:=Buttonwidth;      MainPPoly[3].y:=Buttonheight div 2;
  MainPPoly[4].x:=Buttonwidth div 2;MainPPoly[4].y:=Buttonheight;
  MainPPoly[5].x:=Buttonwidth div 2;MainPPoly[5].y:=2*Buttonheight div 3;
  MainPPoly[6].x:=0;                MainPPoly[6].y:=2*Buttonheight div 3;

  MainVertex[0]:=7;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Arrow1(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,11);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);

  MainPPoly[0].x:=0;                  MainPPoly[0].y:=Buttonheight;
  MainPPoly[1].x:=0;                  MainPPoly[1].y:=Buttonheight div 4;
  MainPPoly[2].x:=Buttonwidth div 12;  MainPPoly[2].y:=Buttonheight div 6;
  MainPPoly[3].x:=2*Buttonwidth div 3;MainPPoly[3].y:=Buttonheight div 6;
  MainPPoly[4].x:=2*Buttonwidth div 3;MainPPoly[4].y:=0;
  MainPPoly[5].x:=Buttonwidth;        MainPPoly[5].y:=Buttonheight div 4;
  MainPPoly[6].x:=2*Buttonwidth div 3;MainPPoly[6].y:=Buttonheight div 2;
  MainPPoly[7].x:=2*Buttonwidth div 3;MainPPoly[7].y:=Buttonheight div 3;
  MainPPoly[8].x:=5*Buttonwidth div 24;  MainPPoly[8].y:=Buttonheight div 3;
  MainPPoly[9].x:=Buttonwidth div 6;MainPPoly[9].y:=9*Buttonheight div 24;
  MainPPoly[10].x:=Buttonwidth div 6;MainPPoly[10].y:=Buttonheight;

  MainVertex[0]:=11;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Arrow2(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,11);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);

  MainPPoly[10].x:=0;                  MainPPoly[10].y:=0;
  MainPPoly[9].x:=0;                  MainPPoly[9].y:=3*Buttonheight div 4;
  MainPPoly[8].x:=Buttonwidth div 12;  MainPPoly[8].y:=5*Buttonheight div 6;
  MainPPoly[7].x:=2*Buttonwidth div 3;MainPPoly[7].y:=5*Buttonheight div 6;
  MainPPoly[6].x:=2*Buttonwidth div 3;MainPPoly[6].y:=Buttonheight;
  MainPPoly[5].x:=Buttonwidth;        MainPPoly[5].y:=3*Buttonheight div 4;
  MainPPoly[4].x:=2*Buttonwidth div 3;MainPPoly[4].y:=Buttonheight div 2;
  MainPPoly[3].x:=2*Buttonwidth div 3;MainPPoly[3].y:=2*Buttonheight div 3;
  MainPPoly[2].x:=5*Buttonwidth div 24;  MainPPoly[2].y:=2*Buttonheight div 3;
  MainPPoly[1].x:=Buttonwidth div 6;MainPPoly[1].y:=15*Buttonheight div 24;
  MainPPoly[0].x:=Buttonwidth div 6;MainPPoly[0].y:=0;

  MainVertex[0]:=11;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_CutRect(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,6);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);

  MainPPoly[0].x:=0;                MainPPoly[0].y:=Buttonheight div 6;
  MainPPoly[1].x:=Buttonwidth div 6;MainPPoly[1].y:=0;
  MainPPoly[2].x:=Buttonwidth;MainPPoly[2].y:=0;
  MainPPoly[3].x:=Buttonwidth;      MainPPoly[3].y:=5*Buttonheight div 6;
  MainPPoly[4].x:=5*Buttonwidth div 6;MainPPoly[4].y:=Buttonheight;
  MainPPoly[5].x:=0;MainPPoly[5].y:=Buttonheight;

  MainVertex[0]:=6;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Cross(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,24);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);

  MainPPoly[0].x:=2*ButtonWidth div 9;   MainPPoly[0].y:=3*Buttonheight div 9;
  MainPPoly[1].x:=3*ButtonWidth div 9;   MainPPoly[1].y:=2*Buttonheight div 9;
  MainPPoly[2].x:=3*ButtonWidth div 9;   MainPPoly[2].y:=1*Buttonheight div 9;
  MainPPoly[3].x:=4*ButtonWidth div 9;   MainPPoly[3].y:=0*Buttonheight div 9;
  MainPPoly[4].x:=5*ButtonWidth div 9;   MainPPoly[4].y:=0*Buttonheight div 9;
  MainPPoly[5].x:=6*ButtonWidth div 9;   MainPPoly[5].y:=1*Buttonheight div 9;
  MainPPoly[6].x:=6*ButtonWidth div 9;   MainPPoly[6].y:=2*Buttonheight div 9;
  MainPPoly[7].x:=7*ButtonWidth div 9;   MainPPoly[7].y:=3*Buttonheight div 9;
  MainPPoly[8].x:=8*ButtonWidth div 9;   MainPPoly[8].y:=3*Buttonheight div 9;
  MainPPoly[9].x:=9*ButtonWidth div 9;   MainPPoly[9].y:=4*Buttonheight div 9;
  MainPPoly[10].x:=9*ButtonWidth div 9;  MainPPoly[10].y:=5*Buttonheight div 9;
  MainPPoly[11].x:=8*ButtonWidth div 9;  MainPPoly[11].y:=6*Buttonheight div 9;
  MainPPoly[12].x:=7*ButtonWidth div 9;  MainPPoly[12].y:=6*Buttonheight div 9;
  MainPPoly[13].x:=6*ButtonWidth div 9;  MainPPoly[13].y:=7*Buttonheight div 9;
  MainPPoly[14].x:=6*ButtonWidth div 9;  MainPPoly[14].y:=8*Buttonheight div 9;
  MainPPoly[15].x:=5*ButtonWidth div 9;  MainPPoly[15].y:=9*Buttonheight div 9;
  MainPPoly[16].x:=4*ButtonWidth div 9;  MainPPoly[16].y:=9*Buttonheight div 9;
  MainPPoly[17].x:=3*ButtonWidth div 9;  MainPPoly[17].y:=8*Buttonheight div 9;
  MainPPoly[18].x:=3*ButtonWidth div 9;  MainPPoly[18].y:=7*Buttonheight div 9;
  MainPPoly[19].x:=2*ButtonWidth div 9;  MainPPoly[19].y:=6*Buttonheight div 9;
  MainPPoly[20].x:=1*ButtonWidth div 9;  MainPPoly[20].y:=6*Buttonheight div 9;
  MainPPoly[21].x:=0*ButtonWidth div 9;  MainPPoly[21].y:=5*Buttonheight div 9;
  MainPPoly[22].x:=0*ButtonWidth div 9;  MainPPoly[22].y:=4*Buttonheight div 9;
  MainPPoly[23].x:=1*ButtonWidth div 9;  MainPPoly[23].y:=3*Buttonheight div 9;
  
  MainVertex[0]:=24;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_Cross1(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
begin
  SetLength(MainPPoly,20);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);

  MainPPoly[0].x:=0*ButtonWidth div 9;   MainPPoly[0].y:=0*Buttonheight div 9;
  MainPPoly[1].x:=2*ButtonWidth div 9;   MainPPoly[1].y:=0*Buttonheight div 9;
  MainPPoly[2].x:=4*ButtonWidth div 9;   MainPPoly[2].y:=2*Buttonheight div 9;
  MainPPoly[3].x:=5*ButtonWidth div 9;   MainPPoly[3].y:=2*Buttonheight div 9;
  MainPPoly[4].x:=7*ButtonWidth div 9;   MainPPoly[4].y:=0*Buttonheight div 9;
  MainPPoly[5].x:=9*ButtonWidth div 9;   MainPPoly[5].y:=0*Buttonheight div 9;
  MainPPoly[6].x:=9*ButtonWidth div 9;   MainPPoly[6].y:=2*Buttonheight div 9;
  MainPPoly[7].x:=7*ButtonWidth div 9;   MainPPoly[7].y:=4*Buttonheight div 9;
  MainPPoly[8].x:=7*ButtonWidth div 9;   MainPPoly[8].y:=5*Buttonheight div 9;
  MainPPoly[9].x:=9*ButtonWidth div 9;   MainPPoly[9].y:=7*Buttonheight div 9;
  MainPPoly[10].x:=9*ButtonWidth div 9;  MainPPoly[10].y:=9*Buttonheight div 9;
  MainPPoly[11].x:=7*ButtonWidth div 9;  MainPPoly[11].y:=9*Buttonheight div 9;
  MainPPoly[12].x:=5*ButtonWidth div 9;  MainPPoly[12].y:=7*Buttonheight div 9;
  MainPPoly[13].x:=4*ButtonWidth div 9;  MainPPoly[13].y:=7*Buttonheight div 9;
  MainPPoly[14].x:=2*ButtonWidth div 9;  MainPPoly[14].y:=9*Buttonheight div 9;
  MainPPoly[15].x:=0*ButtonWidth div 9;  MainPPoly[15].y:=9*Buttonheight div 9;
  MainPPoly[16].x:=0*ButtonWidth div 9;  MainPPoly[16].y:=7*Buttonheight div 9;
  MainPPoly[17].x:=2*ButtonWidth div 9;  MainPPoly[17].y:=5*Buttonheight div 9;
  MainPPoly[18].x:=2*ButtonWidth div 9;  MainPPoly[18].y:=4*Buttonheight div 9;
  MainPPoly[19].x:=0*ButtonWidth div 9;  MainPPoly[19].y:=2*Buttonheight div 9;
    
  MainVertex[0]:=20;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_PolyStar(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
var
  i : integer;
  k : double;
begin
  SetLength(MainPPoly,2*PeaksNumber);
  Setlength(MainVertex,1);
  SetLength(Maininpower,1);
  for i:=0 to PeaksNumber-1 do
    begin
      MainPPoly[i*2].x:=round(ButtonWidth*sin(2*pi*i/(PeaksNumber))/2+Buttonwidth/2.0);
      MainPPoly[i*2].y:=round(-ButtonHeight*cos(2*pi*i/(PeaksNumber))/2+ButtonHeight/2.0);
    end;
  if PeaksNumber>4 then
                k:=cos(2*pi/(PeaksNumber))/cos(2*pi/(PeaksNumber*2.0))
                else
                k:=1/3.0;

   for i:=0 to PeaksNumber-1 do
    begin
      MainPPoly[i*2+1].x:=round(k*ButtonWidth*sin(2*pi*i/(PeaksNumber)+2*pi/(PeaksNumber*2.0))/2+Buttonwidth/2.0);
      MainPPoly[i*2+1].y:=round(-k*ButtonHeight*cos(2*pi*i/(PeaksNumber)+2*pi/(PeaksNumber*2.0))/2+ButtonHeight/2.0);
    end;

  MainVertex[0]:=2*PeaksNumber;
  Maininpower[0]:=0;

end;
procedure TIAeverButton.GotMain_USERRGN(var MainPPoly: TPoints; var MainVertex,MaininPower : Tintegers);
  var
   i : integer;
begin
  if (High(FMainPoly1)>=0) and (High(FMainVertex1)>=0) and (High(FMainPower1)>=0) then
  begin
  SetLength(MainPPoly,1+High(FMainPoly1));
  SetLength(MainVertex,1+High(FMainVertex1));
  SetLength(Maininpower,1+High(FMainPower1));

  for i:=0 to High(FMainPoly1) do
    begin
      if (FUserWidth>0) and (FUserHeight>0) then
        begin
          MainPPoly[i].x:=((FMainPoly1[i].x-FUserLeft)*FButtonWidth) div FUserWidth;
          MainPPoly[i].y:=((FMainPoly1[i].y-FUserTop)*FButtonHeight) div FUserHeight;
        end else
        begin
          MainPPoly[i].x:=0;
          MainPPoly[i].y:=0;
        end;
    end;
  for i:=0 to High(FMainVertex1) do
    begin
      MainVertex[i]:=FMainVertex1[i];
    end;
  for i:=0 to High(FMainPower1) do
    begin
      MaininPower[i]:=FMainPower1[i];
    end;
  end else
  begin
    GotMain_Rect(MainPPoly,MainVertex,MaininPower);
  end;
  RemovePointsPP(MainPPoly,MainVertex,MaininPower,FButtonDepth);
end;
procedure Register;
begin
  RegisterComponents('TIA', [TIAeverButton]);
end;

procedure TIAeverButton.SetCustomDraw(Value: Boolean);
begin
  if FCustomDraw<>Value then
    begin
      FCustomDraw := Value;
      GetMainBitmap;
      invalidate;
    end;
end;

procedure TIAeverButton.SetShowFocusRGN(Value: Boolean);
begin
  if FShowFocusRGN<>Value then
    begin
      FShowFocusRGN := Value;
      GetMainBitmap;
      invalidate;
    end;
end;

end.
