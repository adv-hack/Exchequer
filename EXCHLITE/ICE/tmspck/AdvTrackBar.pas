{*************************************************************************}
{ TMS TAdvTrackBar component                                              }
{ for Delphi & C++Builder                                                 }
{ version 1.0                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright ©  2007                                             }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvTrackBar;

{$R ADVTRACKBAR.RES}
                                            
{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, ComCtrls,
  CommCtrl, AdvGDIP, GDIPicture, ImgList, Math, AdvStyleIf, ExtCtrls, forms;

const

  MAJ_VER = 1; // Major version nr.
  MIN_VER = 1; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 0; // Build nr.
  
  // version history
  // v1.0.0.0 : first version
  // v1.1.0.0 : New : added mousewheel support
  //          : Improved : focus drawing


type
  TGradientDirection = (gdHorizontal, gdVertical, gdHorizontalInOut, gdVerticalInOut);
  TThumbShape = (tsPointer, tsRectangle, tsRoundRect, tsRound, tsLine);
  TThumbStyle = (tstOffice2007, tstCustom);
  TTrackButtonShape = (bsRound, bsRectangle{, bsConcave});
  TGDIPGradient = (ggRadial, ggVertical, ggDiagonalForward, ggDiagonalBackward);

  TCustomTrackBar = class;

  TTrackBarThumb = class(TPersistent)
  private
    FSteps: Integer;
    FColor: TColor;
    FColorTo: TColor;
    FOnChange: TNotifyEvent;
    FBorderColor: TColor;
    FColorHotTo: TColor;
    FColorHot: TColor;
    FBorderColorHot: TColor;
    FWidth: Integer;
    FColorDisabledTo: TColor;
    FBorderColorDown: TColor;
    FBorderColorDisabled: TColor;
    FColorDown: TColor;
    FColorDownTo: TColor;
    FColorDisabled: TColor;
    FIPicture: TGDIPPicture;
    FShape: TThumbShape;
    FStyle: TThumbStyle;
    FIPictureDisabled: TGDIPPicture;
    FIPictureDown: TGDIPPicture;
    FIPictureHot: TGDIPPicture;
    FColorMirrorHot: TColor;
    FColorMirror: TColor;
    FColorMirrorTo: TColor;
    FColorMirrorDisabledTo: TColor;
    FColorMirrorDisabled: TColor;
    FColorMirrorHotTo: TColor;
    FColorMirrorDown: TColor;
    FColorMirrorDownTo: TColor;
    FGradient: TGDIPGradient;
    FGradientMirror: TGDIPGradient;
    FPictureStretched: Boolean;
    FAdvTrackBar: TCustomTrackBar;
    FSize: Integer;
    FShowAtMinMax: boolean;
    procedure SetColor(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetSteps(const Value: Integer);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderColorHot(const Value: TColor);
    procedure SetColorHot(const Value: TColor);
    procedure SetColorHotTo(const Value: TColor);
    procedure SetBorderColorDisabled(const Value: TColor);
    procedure SetBorderColorDown(const Value: TColor);
    procedure SetColorDisabled(const Value: TColor);
    procedure SetColorDisabledTo(const Value: TColor);
    procedure SetColorDown(const Value: TColor);
    procedure SetColorDownTo(const Value: TColor);
    procedure SetPicture(const Value: TGDIPPicture);
    procedure SetShape(const Value: TThumbShape);
    procedure SetStyle(const Value: TThumbStyle);
    procedure SetWidth(const Value: Integer);
    procedure PictureChanged(Sender: TObject);
    procedure SetPictureDisabled(const Value: TGDIPPicture);
    procedure SetPictureDown(const Value: TGDIPPicture);
    procedure SetPictureHot(const Value: TGDIPPicture);
    procedure SetColorMirrorDisabled(const Value: TColor);
    procedure SetColorMirrorDisabledTo(const Value: TColor);
    procedure SetColorMirror(const Value: TColor);
    procedure SetColorMirrorTo(const Value: TColor);
    procedure SetGradientMirror(const Value: TGDIPGradient);
    procedure SetGradient(const Value: TGDIPGradient);
    procedure SetSize(const Value: Integer);
    procedure SetShowAtMinMax(const Value: boolean);
  protected
    procedure Changed;
    property Steps: Integer read FSteps write SetSteps default 64;
    property Style: TThumbStyle read FStyle write SetStyle;
    property AdvTrackBar: TCustomTrackBar read FAdvTrackBar write FAdvTrackBar;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderColorHot: TColor read FBorderColorHot write SetBorderColorHot;
    property BorderColorDown: TColor read FBorderColorDown write SetBorderColorDown;
    property BorderColorDisabled: TColor read FBorderColorDisabled write SetBorderColorDisabled;
    property Color: TColor read FColor write SetColor;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property ColorDown: TColor read FColorDown write SetColorDown;
    property ColorDownTo: TColor read FColorDownTo write SetColorDownTo;
    property ColorHot: TColor read FColorHot write SetColorHot;
    property ColorHotTo: TColor read FColorHotTo write SetColorHotTo;
    property ColorDisabled: TColor read FColorDisabled write SetColorDisabled;
    property ColorDisabledTo: TColor read FColorDisabledTo write SetColorDisabledTo;
    property ColorMirror: TColor read FColorMirror write SetColorMirror;
    property ColorMirrorTo: TColor read FColorMirrorTo write SetColorMirrorTo;
    property ColorMirrorHot: TColor read FColorMirrorHot write FColorMirrorHot;
    property ColorMirrorHotTo: TColor read FColorMirrorHotTo write FColorMirrorHotTo;
    property ColorMirrorDown: TColor read FColorMirrorDown write FColorMirrorDown;
    property ColorMirrorDownTo: TColor read FColorMirrorDownTo write FColorMirrorDownTo;
    property ColorMirrorDisabled: TColor read FColorMirrorDisabled write SetColorMirrorDisabled;
    property ColorMirrorDisabledTo: TColor read FColorMirrorDisabledTo write SetColorMirrorDisabledTo;
    property Gradient: TGDIPGradient read FGradient write SetGradient;
    property GradientMirror: TGDIPGradient read FGradientMirror write SetGradientMirror;
    property Picture: TGDIPPicture read FIPicture write SetPicture;
    property PictureHot: TGDIPPicture read FIPictureHot write SetPictureHot;
    property PictureDown: TGDIPPicture read FIPictureDown write SetPictureDown;
    property PictureDisabled: TGDIPPicture read FIPictureDisabled write SetPictureDisabled;
    //property PictureStretched: Boolean read FPictureStretched write SetPictureStretched default false;
    property ShowAtMinMax: boolean read FShowAtMinMax write SetShowAtMinMax default true;
    property Size: Integer read FSize write SetSize default 15;
    property Width: Integer read FWidth write SetWidth default 10;
    property Shape: TThumbShape read FShape write SetShape;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTrackBarSlider = class(TPersistent)
  private
    FSteps: Integer;
    FColor: TColor;
    FColorTo: TColor;
    FDirection: TGradientDirection;
    FOnChange: TNotifyEvent;
    FBorderColor: TColor;
    FRounded: Boolean;
    FBorder3D: Boolean;
    FIPicture: TGDIPPicture;
    FColorDisabledTo: TColor;
    FBorderColorDisabled: TColor;
    FColorDisabled: TColor;
    FIPictureDisabled: TGDIPPicture;
    FSize: Integer;
    FVisible: Boolean;
    FPictureStretched: Boolean;
    FColorCompletedDisabledTo: TColor;
    FColorCompletedTo: TColor;
    FColorCompleted: TColor;
    FColorCompletedDisabled: TColor;
    FPictureCompletedDisabled: TGDIPPicture;
    FPictureCompleted: TGDIPPicture;
    FOffset: Integer;
    FAdvTrackBar: TCustomTrackBar;    
    procedure SetColor(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetDirection(const Value: TGradientDirection);
    procedure SetSteps(const Value: Integer);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorder3D(const Value: Boolean);
    procedure SetPicture(const Value: TGDIPPicture);
    procedure SetRounded(const Value: Boolean);
    procedure PictureChanged(Sender: TObject);
    procedure SetBorderColorDisabled(const Value: TColor);
    procedure SetColorDisabled(const Value: TColor);
    procedure SetColorDisabledTo(const Value: TColor);
    procedure SetPictureDisabled(const Value: TGDIPPicture);
    procedure SetSize(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetPictureStretched(const Value: Boolean);
    procedure SetColorCompleted(const Value: TColor);
    procedure SetColorCompletedDisabled(const Value: TColor);
    procedure SetColorCompletedDisabledTo(const Value: TColor);
    procedure SetColorCompletedTo(const Value: TColor);
    procedure SetPictureCompleted(const Value: TGDIPPicture);
    procedure SetPictureCompletedDisabled(const Value: TGDIPPicture);
    procedure SetOffset(const Value: Integer);
  protected
    procedure Changed;
    property Steps: Integer read FSteps write SetSteps default 64;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property AdvTrackBar: TCustomTrackBar read FAdvTrackBar write FAdvTrackBar;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderColorDisabled: TColor read FBorderColorDisabled write SetBorderColorDisabled;
    property Color: TColor read FColor write SetColor;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property ColorDisabled: TColor read FColorDisabled write SetColorDisabled;
    property ColorDisabledTo: TColor read FColorDisabledTo write SetColorDisabledTo;
    property ColorCompleted: TColor read FColorCompleted write SetColorCompleted;
    property ColorCompletedTo: TColor read FColorCompletedTo write SetColorCompletedTo;
    property ColorCompletedDisabled: TColor read FColorCompletedDisabled write SetColorCompletedDisabled;
    property ColorCompletedDisabledTo: TColor read FColorCompletedDisabledTo write SetColorCompletedDisabledTo;
    property Direction: TGradientDirection read FDirection write SetDirection;
    property Picture: TGDIPPicture read FIPicture write SetPicture;
    property PictureDisabled: TGDIPPicture read FIPictureDisabled write SetPictureDisabled;
    property PictureCompleted: TGDIPPicture read FPictureCompleted write SetPictureCompleted;
    property PictureCompletedDisabled: TGDIPPicture read FPictureCompletedDisabled write SetPictureCompletedDisabled;
    property PictureStretched: Boolean read FPictureStretched write SetPictureStretched default false;
    property Size: Integer read FSize write SetSize default 2;
    property Border3D: Boolean read FBorder3D write SetBorder3D default true;
    property Rounded: Boolean read FRounded write SetRounded default false;
    property Visible: Boolean read FVisible write SetVisible default true;
    property Offset: Integer read FOffset write SetOffset default 10;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTrackBarTick = class(TPersistent)
  private
    FColor: TColor;
    FOnChange: TNotifyEvent;
    FIPicture: TGDIPPicture;
    FColorDisabled: TColor;
    FIPictureDisabled: TGDIPPicture;
    FPosition: TTickMark;
    FStyle: TTickStyle;
    FShowText: Boolean;
    FFont: TFont;
    FLine3D: Boolean;
    FShowImageAtThumbOnly: Boolean;
    FShowImageAtSteps: Integer;
    FSpacing: Integer;
    FSize: Integer;
    FRotateFontVert: boolean;
    procedure SetColor(const Value: TColor);
    procedure SetPicture(const Value: TGDIPPicture);
    procedure PictureChanged(Sender: TObject);
    procedure OnFontChanged(Sender: TObject);
    procedure SetColorDisabled(const Value: TColor);
    procedure SetPictureDisabled(const Value: TGDIPPicture);
    procedure SetPosition(const Value: TTickMark);
    procedure SetStyle(const Value: TTickStyle);
    procedure SetFont(const Value: TFont);
    procedure SetShowText(const Value: Boolean);
    procedure SetLine3D(const Value: Boolean);
    procedure SetShowImageAtThumbOnly(const Value: Boolean);
    procedure SetShowImageAtSteps(const Value: Integer);
    procedure SetSpacing(const Value: Integer);
    procedure SetSize(const Value: Integer);
    procedure SetRotateFontVert(const Value: boolean);
  protected
    procedure Changed;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write SetColor;
    property ColorDisabled: TColor read FColorDisabled write SetColorDisabled;
    property Font: TFont read FFont write SetFont;
    property Line3D: Boolean read FLine3D write SetLine3D default False;
    property Picture: TGDIPPicture read FIPicture write SetPicture;
    property PictureDisabled: TGDIPPicture read FIPictureDisabled write SetPictureDisabled;
    property Position: TTickMark read FPosition write SetPosition default tmBottomRight;
    property RotateFontVert: boolean read FRotateFontVert write SetRotateFontVert default true;
    property Style: TTickStyle read FStyle write SetStyle default tsAuto;
    property ShowText: Boolean read FShowText write SetShowText default False;
    property ShowImageAtThumbOnly: Boolean read FShowImageAtThumbOnly write SetShowImageAtThumbOnly default false;
    property ShowImageAtSteps: Integer read FShowImageAtSteps write SetShowImageAtSteps default 1;
    property Spacing: Integer read FSpacing write SetSpacing default 8;
    property Size: Integer read FSize write SetSize default 4;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTrackBarButtons = class(TPersistent)
  private
    FVisible: Boolean;
    FColorHot: TColor;
    FColor: TColor;
    FColorTo: TColor;
    FColorHotTo: TColor;
    FColorDownTo: TColor;
    FColorDown: TColor;
    FBorderColorDown: TColor;
    FBorderColorHot: TColor;
    FBorderColor: TColor;
    FIMaxPictureHot: TGDIPPicture;
    FIMaxPictureDown: TGDIPPicture;
    FIMinPicture: TGDIPPicture;
    FIMaxPicture: TGDIPPicture;
    FIMinPictureHot: TGDIPPicture;
    FIMinPictureDown: TGDIPPicture;
    FOnChange: TNotifyEvent;
    FShape: TTrackButtonShape;
    FColorMirror: TColor;
    FColorMirrorTo: TColor;
    FColorMirrorHot: TColor;
    FColorMirrorDownTo: TColor;
    FColorMirrorHotTo: TColor;
    FColorMirrorDown: TColor;
    FGradientMirror: TGDIPGradient;
    FGradient: TGDIPGradient;
    FCornerRadius: Integer;
    FRepeatClick: boolean;
    FInitRepeatPause: Integer;
    FRepeatPause: Integer;
    FSize: Integer;
    FAdvTrackBar: TCustomTrackBar;
    FSpacing: Integer;
    procedure PictureChanged(Sender: TObject);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderColorDown(const Value: TColor);
    procedure SetBorderColorHot(const Value: TColor);
    procedure SetColor(const Value: TColor);
    procedure SetColorDown(const Value: TColor);
    procedure SetColorDownTo(const Value: TColor);
    procedure SetColorHot(const Value: TColor);
    procedure SetColorHotTo(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetMaxPicture(const Value: TGDIPPicture);
    procedure SetMaxPictureDown(const Value: TGDIPPicture);
    procedure SetMaxPictureHot(const Value: TGDIPPicture);
    procedure SetMinPicture(const Value: TGDIPPicture);
    procedure SetMinPictureDown(const Value: TGDIPPicture);
    procedure SetMinPictureHot(const Value: TGDIPPicture);
    procedure SetVisible(const Value: Boolean);
    procedure SetShape(const Value: TTrackButtonShape);
    procedure SetCornerRadius(const Value: Integer);
    procedure SetSize(const Value: Integer);
    procedure SetGradient(const Value: TGDIPGradient);
    procedure SetGradientMirror(const Value: TGDIPGradient);
    procedure SetSpacing(const Value: Integer);
  protected
    procedure Changed;
    property CornerRadius: Integer read FCornerRadius write SetCornerRadius;
    property AdvTrackBar: TCustomTrackBar read FAdvTrackBar write FAdvTrackBar;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderColorHot: TColor read FBorderColorHot write SetBorderColorHot;
    property BorderColorDown: TColor read FBorderColorDown write SetBorderColorDown;
    property Color: TColor read FColor write SetColor;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property ColorHot: TColor read FColorHot write SetColorHot;
    property ColorHotTo: TColor read FColorHotTo write SetColorHotTo;
    property ColorDown: TColor read FColorDown write SetColorDown;
    property ColorDownTo: TColor read FColorDownTo write SetColorDownTo;
    property ColorMirror: TColor read FColorMirror write FColorMirror default clSilver;
    property ColorMirrorTo: TColor read FColorMirrorTo write FColorMirrorTo default clWhite;
    property ColorMirrorHot: TColor read FColorMirrorHot write FColorMirrorHot;
    property ColorMirrorHotTo: TColor read FColorMirrorHotTo write FColorMirrorHotTo;
    property ColorMirrorDown: TColor read FColorMirrorDown write FColorMirrorDown;
    property ColorMirrorDownTo: TColor read FColorMirrorDownTo write FColorMirrorDownTo;
    property Gradient: TGDIPGradient read FGradient write SetGradient default ggVertical;
    property GradientMirror: TGDIPGradient read FGradientMirror write SetGradientMirror;
    property MinPicture: TGDIPPicture read FIMinPicture write SetMinPicture;
    property MinPictureHot: TGDIPPicture read FIMinPictureHot write SetMinPictureHot;
    property MinPictureDown: TGDIPPicture read FIMinPictureDown write SetMinPictureDown;
    property MaxPicture: TGDIPPicture read FIMaxPicture write SetMaxPicture;
    property MaxPictureHot: TGDIPPicture read FIMaxPictureHot write SetMaxPictureHot;
    property MaxPictureDown: TGDIPPicture read FIMaxPictureDown write SetMaxPictureDown;
    property InitRepeatPause: Integer read FInitRepeatPause write FInitRepeatPause default 400;
    property RepeatPause: Integer read FRepeatPause write FRepeatPause default 100;
    property RepeatClick: boolean read FRepeatClick write FRepeatClick default True;
    property Visible: Boolean read FVisible write SetVisible default False;
    property Size: Integer read FSize write SetSize default 20;
    property Shape: TTrackButtonShape read FShape write SetShape default bsRound;
    property Spacing: Integer read FSpacing write SetSpacing default 2;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  {TTrackHintWindow}

  TTrackHintWindow = class(THintWindow)
  private
    FTextHeight, FTextWidth: Integer;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    {$IFNDEF TMSDOTNET}
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
    {$ENDIF}
    {$IFDEF TMSDOTNET}
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: TObject): TRect; override;
    {$ENDIF}
  end;

  //TTrackBarOrientation = (trHorizontal, trVertical);
  //TTickStyle = (tsNone, tsAuto, tsManual);
  TDrawTickEvent = procedure(Sender: TObject; Canvas: TCanvas; Location: TPoint; Position: Integer; TickPos: TTickMark; var Length: Integer; var Color, TextColor: TColor; var Text: string; var DefaultDraw: Boolean) of object;
  TGetTrackHintEvent = procedure (Sender: TObject; Position: Integer; var HintStr: string) of object;

  TCustomTrackBar = class(TCustomControl, ITMSStyle)
  private
    FThumb: TTrackBarThumb;
    FSlider: TTrackBarSlider;
    FTickMark: TTrackBarTick;
    FMax: Integer;
    FMin: Integer;
    FOrientation: TTrackBarOrientation;
    FPageSize: Integer;
    FPosition: Integer;
    FSliding: Boolean;
    FOnChange: TNotifyEvent;
    FOnDrawTick: TDrawTickEvent;
    FColorDisabled: TColor;
    FColorTo: TColor;
    FBorderColorDisabled: TColor;
    FBorderColor: TColor;
    FColorDisabledTo: TColor;
    FIBackGround: TGDIPPicture;
    FDirection: TGradientDirection;
    FTransparent: Boolean;
    FSliderTickOffset: Integer;
    FOffset: Integer;
    FTickTextOffset: Integer;
    FThumbHot: Boolean;
    FThumbDown: Boolean;
    FImages: TCustomImageList;
    FIRateInActive: TGDIPPicture;
    FIRateActive: TGDIPPicture;
    FIBackGroundDisabled: TGDIPPicture;
    FButtons: TTrackBarButtons;
    FBorderWidth: Integer;
    FMinButtonHot: Boolean;
    FMinButtonDown: Boolean;
    FMaxButtonHot: Boolean;
    FMaxButtonDown: Boolean;
    FTextHeight: Integer;
    FRepeatTimer: TTimer;
    FTrackHint: Boolean;
    FOnGetTrackHint: TGetTrackHintEvent;
    FBackGroundStretched: Boolean;
    FHintTickIndex: Integer;
    FTrackHintWnd: TTrackHintWindow;
    FTrackHintShow: Boolean;
    FShowFocus: Boolean;
    procedure WMGetDlgCode(var Msg:TWMGetDlgCode); message wm_GetDlgCode;
    procedure WMSize(var Msg:TWMSize); message wm_Size;
    procedure CMEnabledChanged(var Msg:TMessage); message cm_EnabledChanged;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure BackGroundChanged(Sender: TObject);
    procedure OnThumbChanged(Sender: TObject);
    procedure OnSliderChanged(Sender: TObject);
    procedure OnTickMarkChanged(Sender: TObject);
    procedure OnRatePictureChanged(Sender: TObject);
    procedure OnButtonsChanged(Sender: TObject);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetOrientation(Value: TTrackBarOrientation);
    procedure SetPosition(Value: Integer);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderColorDisabled(const Value: TColor);
    procedure SetColorDisabled(const Value: TColor);
    procedure SetColorDisabledTo(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
    procedure SetDirection(const Value: TGradientDirection);
    procedure SetBackGround(const Value: TGDIPPicture);
    procedure SetTransparent(const Value: Boolean);
    procedure SetSlider(const Value: TTrackBarSlider);
    procedure SetThumb(const Value: TTrackBarThumb);
    procedure SetTickMark(const Value: TTrackBarTick);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetRateActive(const Value: TGDIPPicture);
    procedure SetRateInActive(const Value: TGDIPPicture);
    procedure SetBackGroundDisabled(const Value: TGDIPPicture);
    procedure SetButtons(const Value: TTrackBarButtons);
    procedure SetBorderWidth(const Value: Integer);
    procedure SetBackGroundStretched(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure Change;	dynamic;
    procedure DoEnter; override;
    procedure DoExit;	override;
    procedure KeyDown(var Key:Word; Shift:TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure RepeatTimerExpired(Sender: TObject); virtual;
    function InternalClientRect: TRect;
    function TrackClientRect: TRect;
    function TickMarkTopRect: TRect;
    function TickMarkBottomRect: TRect;
    function SliderRect: TRect;
    function ThumbRect: TRect;
    function TrackingRect: TRect;

    function RateSize: TSize;
    function RateRect(Index: Integer): TRect;
    function IndexOfRate(X, Y: Integer): Integer;

    function MinButtonRect: TRect;
    function MaxButtonRect: TRect;
    function ButtonWidth: Integer;
    procedure ClickMinButton;
    procedure ClickMaxButton;

    function IndexOfTickAt(X, Y: Integer): Integer;

    procedure DrawBackGround;
    procedure DrawSlider;
    procedure DrawTickMarks;
    procedure DrawThumb;

    procedure DrawRate(Index: Integer);
    procedure DrawRates;

    procedure DrawMinButton;
    procedure DrawMaxButton;
    procedure DrawButtons;

    function IsRating: Boolean;
    {
    property Frequency: Integer read FFrequency write SetFrequency default 1;
    property SelEnd: Integer read FSelEnd write SetSelEnd default 0;
    property SelStart: Integer read FSelStart write SetSelStart default 0;
    }
    property Max: Integer read FMax write SetMax default 10;
    property Min: Integer read FMin write SetMin default 0;
    property Orientation: TTrackBarOrientation read FOrientation write SetOrientation default trHorizontal;
    property PageSize: Integer read FPageSize write FPageSize default 1;
    property Position: Integer read FPosition write SetPosition default 0;

    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderColorDisabled: TColor read FBorderColorDisabled write SetBorderColorDisabled;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 1;
    property ColorTo: TColor read FColorTo write SetColorTo;
    property ColorDisabled: TColor read FColorDisabled write SetColorDisabled;
    property ColorDisabledTo: TColor read FColorDisabledTo write SetColorDisabledTo;
    property Direction: TGradientDirection read FDirection write SetDirection;
    property BackGround: TGDIPPicture read FIBackGround write SetBackGround;
    property BackGroundDisabled: TGDIPPicture read FIBackGroundDisabled write SetBackGroundDisabled;
    property BackGroundStretched: Boolean read FBackGroundStretched write SetBackGroundStretched default false;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
    property Thumb: TTrackBarThumb read FThumb write SetThumb;
    property Slider: TTrackBarSlider read FSlider write SetSlider;
    property ShowFocus: Boolean read FShowFocus write FShowFocus default false;
    property TrackHint: Boolean read FTrackHint write FTrackHint;
    property TickMark: TTrackBarTick read FTickMark write SetTickMark;
    property TickImages: TCustomImageList read FImages write SetImages;
    property RateActive: TGDIPPicture read FIRateActive write SetRateActive;
    property RateInActive: TGDIPPicture read FIRateInActive write SetRateInActive;
    property Buttons: TTrackBarButtons read FButtons write SetButtons;
    property OnChange: TNotifyEvent	read FOnChange write FOnChange;
    property OnGetTrackHint: TGetTrackHintEvent read FOnGetTrackHint write FOnGetTrackHint;
    property OnDrawTick: TDrawTickEvent read FOnDrawTick write FOnDrawTick;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetComponentStyle(AStyle: TTMSStyle);
  end;

  TAdvTrackBar = class(TCustomTrackBar)
  published
    property Align;
    property Anchors;
    //property BorderWidth;
    property BackGroundStretched;
    property BackGround;
    property BackGroundDisabled;
    property BorderColor;
    property BorderColorDisabled;
    property Buttons;
    property ColorTo;
    property ColorDisabled;
    property ColorDisabledTo;
    property Ctl3D;
    property Direction;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Constraints;
    property Color;
    property HelpContext;
    property Hint;
    property Max;
    property Min;
    property Orientation;
    property ParentCtl3D;
    property ParentShowHint;
    property PageSize;
    property PopupMenu;
    property Position;
    property RateActive;
    property RateInActive;
    property ShowHint;
    property Slider;
    property ShowFocus;
    property TabOrder;
    property TabStop default True;
    property Thumb;
    property TickMark;
    property TickImages;
    property TrackHint;
    property Transparent;
    property Visible;
    property OnContextPopup;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;

    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDrawTick;
    property OnGetTrackHint;
  end;

  TWinCtrl = class(TWinControl)
  public
    procedure PaintCtrls(DC: HDC; First: TControl);
  end;

implementation

uses
  Consts;
  
//----------------------------------------------------------------- DrawGradient

procedure DrawGradient(Canvas: TCanvas; FromColor, ToColor: TColor; Steps: Integer; R: TRect; Direction: Boolean);
var
  diffr, startr, endr: Integer;
  diffg, startg, endg: Integer;
  diffb, startb, endb: Integer;
  rstepr, rstepg, rstepb, rstepw: Real;
  i, stepw: Word;

begin
  if Direction then
    R.Right := R.Right - 1
  else
    R.Bottom := R.Bottom - 1;

  if Steps = 0 then
    Steps := 1;

  FromColor := ColorToRGB(FromColor);
  ToColor := ColorToRGB(ToColor);

  startr := (FromColor and $0000FF);
  startg := (FromColor and $00FF00) shr 8;
  startb := (FromColor and $FF0000) shr 16;
  endr := (ToColor and $0000FF);
  endg := (ToColor and $00FF00) shr 8;
  endb := (ToColor and $FF0000) shr 16;

  diffr := endr - startr;
  diffg := endg - startg;
  diffb := endb - startb;

  rstepr := diffr / steps;
  rstepg := diffg / steps;
  rstepb := diffb / steps;

  if Direction then
    rstepw := (R.Right - R.Left) / Steps
  else
    rstepw := (R.Bottom - R.Top) / Steps;

  with Canvas do
  begin
    for i := 0 to steps - 1 do
    begin
      endr := startr + Round(rstepr * i);
      endg := startg + Round(rstepg * i);
      endb := startb + Round(rstepb * i);
      stepw := Round(i * rstepw);
      Pen.Color := endr + (endg shl 8) + (endb shl 16);
      Brush.Color := Pen.Color;
      if Direction then
        Rectangle(R.Left + stepw, R.Top, R.Left + stepw + Round(rstepw) + 1, R.Bottom)
      else
        Rectangle(R.Left, R.Top + stepw, R.Right, R.Top + stepw + Round(rstepw) + 1);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure DrawInOutGradient(Canvas: TCanvas; FromColor, ToColor: TColor; Steps: Integer; R: TRect; Direction: TGradientDirection);
var
  R1, R2: TRect;
  i: Integer;
begin
  case Direction of
    gdHorizontal, gdVertical:
    begin
      DrawGradient(Canvas, FromColor, ToColor, Steps, R, Direction = gdHorizontal);
    end;
    gdHorizontalInOut:
    begin
      i := R.Left + (R.Right - R.Left) div 2;
      R1 := Rect(R.Left, R.Top, i, R.Bottom);
      R2 := Rect(i - 1, R.Top, R.Right, R.Bottom);
      DrawGradient(Canvas, FromColor, ToColor, Steps, R1, True);
      DrawGradient(Canvas, ToColor, FromColor, Steps, R2, True);
    end;
    gdVerticalInOut:
    begin
      i := R.Top + (R.Bottom - R.Top) div 2;
      R1 := Rect(R.Left, R.Top, R.Right, i);
      R2 := Rect(R.Left, i - 1, R.Right, R.Bottom);
      DrawGradient(Canvas, FromColor, ToColor, Steps, R1, False);
      DrawGradient(Canvas, ToColor, FromColor, Steps, R2, False);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TextSize(Canvas: TCanvas; f: TFont; Text: string; var h, w: Integer);
var
  OldF: TFont;
begin
  OldF := TFont.Create;
  OldF.Assign(Canvas.Font);
  Canvas.Font.Assign(f);
  h := Canvas.TextHeight(Text);
  w := Canvas.TextWidth(Text);
  Canvas.Font.Assign(OldF);
  OldF.Free;
end;

//------------------------------------------------------------------------------

function BlendColor(Col1,Col2:TColor; BlendFactor:Integer): TColor;
var
  r1,g1,b1: Integer;
  r2,g2,b2: Integer;

begin
  if BlendFactor >= 100 then
  begin
    Result := Col1;
    Exit;
  end;
  if BlendFactor <= 0 then
  begin
    Result := Col2;
    Exit;
  end;

  Col1 := Longint(ColorToRGB(Col1));
  r1 := GetRValue(Col1);
  g1 := GetGValue(Col1);
  b1 := GetBValue(Col1);

  Col2 := Longint(ColorToRGB(Col2));
  r2 := GetRValue(Col2);
  g2 := GetGValue(Col2);
  b2 := GetBValue(Col2);

  r1 := Round( BlendFactor/100 * r1 + (1 - BlendFactor/100) * r2);
  g1 := Round( BlendFactor/100 * g1 + (1 - BlendFactor/100) * g2);
  b1 := Round( BlendFactor/100 * b1 + (1 - BlendFactor/100) * b2);

  Result := RGB(r1,g1,b1);
end;

//------------------------------------------------------------------------------

procedure Draw3DRect(Canvas: TCanvas; R: TRect; Embossed: Boolean; Clr1, Clr2: TColor);
var
  h: Integer;
begin
  h := (R.Bottom - R.Top);
  with Canvas do
  begin
    if Embossed then
      Pen.Color := Clr1 //clWhite
    else
      Pen.Color := Clr2; //clBtnShadow;

    if (h > 2) then
    begin
      MoveTo(R.Left, R.Top);
      LineTo(R.Left, R.Bottom);
    end;
    MoveTo(R.Left, R.Top);
    LineTo(R.Right, R.Top);
    MoveTo(R.Right - 2, R.Top);
    LineTo(R.Right - 2, R.Bottom -2);
    MoveTo(R.Right - 2, R.Bottom - 2);
    LineTo(R.Left, R.Bottom - 2);

    if Embossed then
      Pen.Color := Clr2 //clBtnShadow
    else
      Pen.Color := Clr1; //clWhite;

    MoveTo(R.Left + 1, R.Bottom - 1);
    LineTo(R.Right - 1, R.Bottom - 1);
    MoveTo(R.Right - 1, R.Bottom - 1);
    LineTo(R.Right - 1, R.Top-1);
    MoveTo(R.Left + 1, R.Bottom - 1);
    LineTo(R.Left + 1, R.Top + 1);
    MoveTo(R.Left + 1, R.Top + 1);
    LineTo(R.Right - 2, R.Top + 1);
  end;
end;

//------------------------------------------------------------------------------

procedure Draw3DLine(Canvas: TCanvas; FromPoint, ToPoint: TPoint; Embossed: Boolean; Clr1, Clr2: TColor;  VerticalLine: Boolean = true);
begin
  with Canvas do
  begin
    if Embossed then
      Pen.Color := Clr1 //clWhite
    else
      Pen.Color := Clr2; //clBtnShadow;

    if VerticalLine then
    begin
      MoveTo(FromPoint.X - 1, FromPoint.Y - 1);
      LineTo(ToPoint.X - 1, ToPoint.Y);
      LineTo(ToPoint.X + 1, ToPoint.Y);
    end
    else
    begin
      MoveTo(FromPoint.X - 1, FromPoint.Y + 1);
      LineTo(FromPoint.X - 1, FromPoint.Y - 1);
      LineTo(ToPoint.X + 1, ToPoint.Y - 1);
    end;

    if Embossed then
      Pen.Color := Clr2 //clBtnShadow
    else
      Pen.Color := Clr1; //clWhite;

    if VerticalLine then
    begin
      MoveTo(ToPoint.X + 1, ToPoint.Y);
      LineTo(ToPoint.X + 1, FromPoint.Y);
      LineTo(ToPoint.X - 1, FromPoint.Y);
    end
    else
    begin
      MoveTo(ToPoint.X + 1, ToPoint.Y - 1);
      LineTo(ToPoint.X + 1, ToPoint.Y + 1);
      LineTo(FromPoint.X, FromPoint.Y + 1);
    end;
  end;
end;

//------------------------------------------------------------------------------

function BrightnessColor(Col: TColor; Brightness: integer): TColor; overload;
var
  r1,g1,b1: Integer;
begin
  Col := ColorToRGB(Col);
  r1 := GetRValue(Col);
  g1 := GetGValue(Col);
  b1 := GetBValue(Col);

  if r1 = 0 then
    r1 := Max(0,Brightness)
  else
    r1 := Round( Min(100,(100 + Brightness))/100 * r1 );

  if g1 = 0 then
    g1 := Max(0,Brightness)
  else
    g1 := Round( Min(100,(100 + Brightness))/100 * g1 );

  if b1 = 0 then
    b1 := Max(0,Brightness)
  else
    b1 := Round( Min(100,(100 + Brightness))/100 * b1 );

  Result := RGB(r1,g1,b1);
end;

//------------------------------------------------------------------------------

function BrightnessColor(Col: TColor; BR,BG,BB: integer): TColor; overload;
var
  r1,g1,b1: Integer;
begin
  Col := Longint(ColorToRGB(Col));
  r1 := GetRValue(Col);
  g1 := GetGValue(Col);
  b1 := GetBValue(Col);

  if r1 = 0 then
    r1 := Max(0,BR)
  else
    r1 := Round( Min(100,(100 + BR))/100 * r1 );

  if g1 = 0 then
    g1 := Max(0,BG)
  else
    g1 := Round( Min(100,(100 + BG))/100 * g1 );

  if b1 = 0 then
    b1 := Max(0,BB)
  else
    b1 := Round( Min(100,(100 + BB))/100 * b1 );

  Result := RGB(r1,g1,b1);
end;

//------------------------------------------------------------------------------

function ColorToARGB(Color: TColor): ARGB;
var
  c: TColor;
begin
  c := ColorToRGB(Color);
  Result := ARGB( $FF000000 or ((DWORD(c) and $FF) shl 16) or ((DWORD(c) and $FF00) or ((DWORD(c) and $ff0000) shr 16)));
end;

//------------------------------------------------------------------------------

function CreatePointerPolygon(R: TRect; Pt, Pb: TPoint; Orientation: TTrackBarOrientation; Position: TTickMark): TGPGraphicsPath;
begin
  Result := TGPGraphicsPath.Create;
  if (Orientation = trHorizontal) then
  begin
    Result.AddLine(R.Left, R.Bottom, R.Left, R.Top);
    if (Position in [tmTopLeft, tmBoth]) then
    begin
      Result.AddLine(R.Left, R.Top, Pt.X, Pt.Y);
      Result.AddLine(Pt.X, Pt.Y, R.Right, R.Top);
    end
    else
      Result.AddLine(R.Left, R.Top, R.Right, R.Top);

    Result.AddLine(R.Right, R.Top, R.Right, R.Bottom);

    if (Position in [tmBottomRight, tmBoth]) then
    begin
      Result.AddLine(R.Right, R.Bottom, Pb.X, Pb.Y);
      Result.AddLine(Pb.X, Pb.Y, R.Left, R.Bottom);
    end
    else
      Result.AddLine(R.Left, R.Bottom, R.Right, R.Bottom);

  end
  else // (Orientation = trVertical)
  begin
    Result.AddLine(R.Right, R.Bottom, R.Left, R.Bottom);
    if (Position in [tmTopLeft, tmBoth]) then
    begin
      Result.AddLine(R.Left, R.Bottom, Pt.X, Pt.Y);
      Result.AddLine(Pt.X, Pt.Y, R.Left, R.Top);
    end
    else
      Result.AddLine(R.Left, R.Bottom, R.Left, R.Top);

    Result.AddLine(R.Left, R.Top, R.Right, R.Top);

    if (Position in [tmBottomRight, tmBoth]) then
    begin
      Result.AddLine(R.Right, R.Top, Pb.X, Pb.Y);
      Result.AddLine(Pb.X, Pb.Y, R.Right, R.Bottom);
    end
    else
      Result.AddLine(R.Right, R.Top, R.Right, R.Bottom);

  end;
  Result.CloseFigure();
end;

//------------------------------------------------------------------------------

procedure DrawRoundRectangle(graphic: TGPGraphics; R: TRect; Radius: Integer; Clr: TColor);
var
  path: TGPGraphicsPath;
  l, t, w, h, d: Integer;
  gppen: TGPPen;
begin
  if not Assigned(graphic) then
    Exit;
  path := TGPGraphicsPath.Create;
  l := R.Left;
  t := R.Top;
  w := R.Right;
  h := R.Bottom;
  d := Radius shl 1;
  path.AddArc(l, t, d, d, 180, 90); // topleft
  path.AddLine(l + radius, t, l + w - radius, t); // top
  path.AddArc(l + w - d, t, d, d, 270, 90); // topright
  path.AddLine(l + w, t + radius, l + w, t + h - radius); // right
  path.AddArc(l + w - d, t + h - d, d, d, 0, 90); // bottomright
  path.AddLine(l + w - radius, t + h, l + radius, t + h); // bottom
  path.AddArc(l, t + h - d, d, d, 90, 90); // bottomleft
  path.AddLine(l, t + h - radius, l, t + radius); // left
  path.CloseFigure();
  gppen := TGPPen.Create(ColorToARGB(Clr));
  graphic.DrawPath(gppen, path);
  gppen.Free;
  path.Free;
end;

//------------------------------------------------------------------------------

function CreateRoundRectangle(R: TRect; Radius: Integer): TGPGraphicsPath;
var
  l, t, w, h, d: Integer;
begin
  Result := TGPGraphicsPath.Create;
  l := R.Left;
  t := R.Top;
  w := R.Right;
  h := R.Bottom;
  d := Radius shl 1;
  Result.AddArc(l, t, d, d, 180, 90); // topleft
  Result.AddLine(l + radius, t, l + w - radius, t); // top
  Result.AddArc(l + w - d, t, d, d, 270, 90); // topright
  Result.AddLine(l + w, t + radius, l + w, t + h - radius); // right
  Result.AddArc(l + w - d, t + h - d, d, d, 0, 90); // bottomright
  Result.AddLine(l + w - radius, t + h, l + radius, t + h); // bottom
  Result.AddArc(l, t + h - d, d, d, 90, 90); // bottomleft
  Result.AddLine(l, t + h - radius, l, t + radius); // left
  Result.CloseFigure();
end;

//------------------------------------------------------------------------------

procedure DrawButtonBackground(Graphics: TGPGraphics; R: TRect; CF,CT: TColor; Gradient: TGDIPGradient; Upper: boolean);
var
  path: TGPGraphicsPath;
  pthGrBrush: TGPPathGradientBrush;
  linGrBrush: TGPLinearGradientBrush;
  solGrBrush: TGPSolidBrush;
  
  w,h,w2,h2: Integer;
  colors : array[0..0] of TGPColor;
  count: Integer;

begin
  w := r.Right - r.Left;
  h := r.Bottom - r.Top;

  h2 := h div 2;
  w2 := w div 2;

  if (Gradient = ggRadial) then
  begin
    if Upper then
      solGrBrush := TGPSolidBrush.Create(ColorToARGB(CF))
    else
      solGrBrush := TGPSolidBrush.Create(ColorToARGB(CT));

    Graphics.FillRectangle(solGrBrush, MakeRect(r.Left , r.Top, w , h));

    solGrBrush.Free;
  end;

  // Create a path that consists of a single ellipse.
  path := TGPGraphicsPath.Create;

  if Upper then        // take borders in account
    path.AddEllipse(r.Left, r.Top - h2 + 2, w, h)
  else
    path.AddEllipse(r.Left, r.Top, w, h);

  pthGrBrush := nil;
  linGrBrush := nil;

  case Gradient of
  ggRadial: pthGrBrush := TGPPathGradientBrush.Create(path);
  ggVertical: linGrBrush := TGPLinearGradientBrush.Create(MakeRect(r.Left,r.Top,w,h),ColorToARGB(CF),ColorToARGB(CT), LinearGradientModeVertical);
  ggDiagonalForward: linGrBrush := TGPLinearGradientBrush.Create(MakeRect(r.Left,r.Top,w,h),ColorToARGB(CF),ColorToARGB(CT), LinearGradientModeForwardDiagonal);
  ggDiagonalBackward: linGrBrush := TGPLinearGradientBrush.Create(MakeRect(r.Left,r.Top,w,h),ColorToARGB(CF),ColorToARGB(CT), LinearGradientModeBackwardDiagonal);
  end;

  if Gradient = ggRadial then
  begin
    if Upper then
      pthGrBrush.SetCenterPoint(MakePoint(r.Left + w2, r.Top))
    else
      pthGrBrush.SetCenterPoint(MakePoint(r.Left + w2, r.Bottom));

    // Set the color at the center point to blue.
    if Upper then
    begin
      pthGrBrush.SetCenterColor(ColorToARGB(CT));
      colors[0] := ColorToARGB(CF);
    end
    else
    begin
      pthGrBrush.SetCenterColor(ColorToARGB(CF));
      colors[0] := ColorToARGB(CT);
    end;

    count := 1;
    pthGrBrush.SetSurroundColors(@colors, count);
    graphics.FillRectangle(pthGrBrush, r.Left, r.Top, w, h);
    pthGrBrush.Free;
  end
  else
  begin
    graphics.FillRectangle(linGrBrush, r.Left, r.Top, w, h);
    linGrBrush.Free;
  end;

  path.Free;
end;

//------------------------------------------------------------------------------

procedure DrawVistaBorder(graphic: TGPGraphics; R: TRect; ButtonShape: TTrackButtonShape; BrOuterClr, BrInnerClr: TColor;
     Orientation: TTrackBarOrientation);
var
  i, w, h: Integer;
  R2: TRect;
begin
  w := (R.Right - R.Left);
  h := (R.Bottom - R.Top);

  // Draw Border
  if (BrOuterClr <> clNone) then
  begin
    case (ButtonShape) of
      bsRound:
      begin
        if (Orientation = trHorizontal) then
        begin
          i := R.Top + ((R.Bottom - R.Top) - w) div 2;
          R2 := Rect(R.Left, i, w, h);
          DrawRoundRectangle(graphic, R2, w div 2, BrOuterClr);
        end
        else // (Orientation = trVertical
        begin
          i := R.Left + ((R.Right - R.Left) - h) div 2;
          R2 := Rect(i, R.Top, w, h);

          //R2 := Rect(R.Left, R.Top, w, h);
          DrawRoundRectangle(graphic, R2, h div 2, BrOuterClr);
        end;
      end;
      bsRectangle:
      begin
        DrawRoundRectangle(graphic, Rect(R.Left, R.Top, w, h), 0, BrOuterClr);
      end;
      {btsCurvedRectangle:
      begin
        path := CreateConcaveRectangle(R, ButtonDirection);
        gppen := TGPPen.Create(ColorToARGB(OuterBorderColor));
        graphic.DrawPath(gppen, path);
        gppen.Free;
        path.Free;
      end; }
    end;
  end;

  if (BrInnerClr <> clNone) then
  begin
    case (ButtonShape) of
      bsRound:
      begin
        if (Orientation = trHorizontal) then
        begin
          i := R.Top + ((R.Bottom - R.Top) - w) div 2;
          R2 := Rect(R.Left + 1, i + 1, w - 2, h - 2);
          DrawRoundRectangle(graphic, R2, ((w - 2) div 2), BrInnerClr);
        end
        else // (Orientation = trVertical
        begin
          i := R.Left + ((R.Right - R.Left) - h) div 2;
          R2 := Rect(i + 1, R.Top + 1, w - 2, h - 2);
          //R2 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          DrawRoundRectangle(graphic, R2, ((h - 2) div 2), BrInnerClr);
        end;
      end;
      bsRectangle:
      begin
        DrawRoundRectangle(graphic, Rect(R.Left, R.Top, w, h), 0, BrInnerClr);
      end;
      {btsCurvedRectangle:
      begin
        path := CreateConcaveRectangle(R, ButtonDirection);
        gppen := TGPPen.Create(ColorToARGB(InnerBorderColor));
        graphic.DrawPath(gppen, path);
        gppen.Free;
        path.Free;
      end; }
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure DrawVistaGradient(Graphics: TGPGraphics; Canvas: TCanvas; R: TRect; ButtonShape: TTrackButtonShape;
     BrOuterClr, BrInnerClr, Clr, ClrTo, ClrM, ClrMTo: TColor; Gradient, GradientM: TGDIPGradient; Orientation: TTrackBarOrientation);
var
  graphic: TGPGraphics;
  h2: Integer;
begin
  if Assigned(Graphics) then
    graphic := Graphics
  else
    graphic := TGPGraphics.Create(Canvas.Handle);

  graphic.SetSmoothingMode(SmoothingModeAntiAlias);

  //w := (R.Right - R.Left);
  //h := (R.Bottom - R.Top);

  h2 := (R.Bottom - R.Top) div 2;  
  // Draw BackGround
  if (clr <> clNone) and (clrTo <> clNone) and (clrM <> clNone) and (ClrMTo <> clNone) then
  begin
    DrawButtonBackground(Graphics, Rect(R.left, r.Top + h2 - 1, r.Right, r.Bottom), ClrMTo, ClrM, GradientM, False);
    DrawButtonBackground(Graphics, Rect(r.Left, r.Top, r.Right, r.Bottom - h2 + 1), Clr, ClrTo, Gradient, True);
  end;

  DrawVistaBorder(graphic, R, ButtonShape, BrOuterClr, BrInnerClr, Orientation);
  
  if (graphic <> Graphics) then
    graphic.Free;
end;

//------------------------------------------------------------------------------

function CreateConcaveRectangle(R: TRect; LeftDirection: Boolean): TGPGraphicsPath;
var
  l, t, w, h: Integer;
  points : array[0..5] of TGPPoint;
begin
  Result := TGPGraphicsPath.Create;
  l := R.Left;
  t := R.Top;
  w := R.Right;
  h := R.Bottom;

  if (LeftDirection) then
  begin
    Result.AddArc(l, t, h, h, 90, 180);
    Result.AddLine(l + h, t, l + w, t);
    points[0].X := (l + w); points[0].Y := t;
    points[1].X := (l + w - h div 6); points[1].Y := (t + h div 4);
    points[2].X := (round(l + w - (h / 4.7))); points[2].Y := (t + h div 2);
    points[3].X := (l + w - h div 6); points[3].Y := (t + 3 * h div 4);
    points[4].X := (l + w); points[4].Y := (t + h);
    Result.AddCurve(PGPPoint(@points), 5);
    Result.AddLine(l + h, t + h, l + w, t + h);
  end
  else
  begin
    points[0].X := l; points[0].Y := t;
    points[1].X := (l + h div 6); points[1].Y := (t + h div 4);
    points[2].X := (round(l + (h / 4.85))); points[2].Y := (t + h div 2);
    points[3].X := (l + h div 6); points[3].Y := (t + 3 * h div 4);
    points[4].X := l; points[4].Y := (t + h);
    Result.AddCurve(PGPPoint(@points), 5);
    Result.AddLine(l, t + h, l + w - h, t + h);
    Result.AddArc(l + w - h, t, h, h, 90, -180);
    Result.AddLine(l + w - h, t, l, t);
  end;  
  Result.CloseFigure();
end;

//------------------------------------------------------------------------------

procedure DrawConcaveRectangle(graphic: TGPGraphics; R: TRect; LeftDirection: Boolean; Clr: TColor);
var
  l, t, w, h: Integer;
  points : array[0..5] of TGPPoint;
  gppen: TgpPen;
  path: TGPGraphicsPath;
begin
  path := TGPGraphicsPath.Create;
  l := R.Left;
  t := R.Top;
  w := R.Right;
  h := R.Bottom;

  if (LeftDirection) then
  begin
    path.AddArc(l, t, h, h, 90, 180);
    path.AddLine(l + h, t, l + w, t);
    points[0].X := (l + w); points[0].Y := t;
    points[1].X := (l + w - h div 6); points[1].Y := (t + h div 4);
    points[2].X := (round(l + w - (h / 4.7))); points[2].Y := (t + h div 2);
    points[3].X := (l + w - h div 6); points[3].Y := (t + 3 * h div 4);
    points[4].X := (l + w); points[4].Y := (t + h);
    path.AddCurve(PGPPoint(@points), 5);
    path.AddLine(l + h, t + h, l + w, t + h);
  end
  else
  begin
    points[0].X := l; points[0].Y := t;
    points[1].X := (l + h div 6); points[1].Y := (t + h div 4);
    points[2].X := (round(l + (h / 4.85))); points[2].Y := (t + h div 2);
    points[3].X := (l + h div 6); points[3].Y := (t + 3 * h div 4);
    points[4].X := l; points[4].Y := (t + h);
    path.AddCurve(PGPPoint(@points), 5);
    path.AddLine(l, t + h, l + w - h, t + h);
    path.AddArc(l + w - h, t, h, h, 90, -180);
    path.AddLine(l + w - h, t, l, t);
  end;
  path.CloseFigure();
  gppen := TGPPen.Create(ColorToARGB(Clr));
  graphic.DrawPath(gppen, path);
  gppen.Free;
end;

//------------------------------------------------------------------------------

procedure DrawFocusRect(ACanvas: TCanvas; R: TRect; Clr: TColor);
var
  LB: TLogBrush;
  HPen, HOldPen: THandle;
begin
  ACanvas.Pen.Color := Clr;

  lb.lbColor := ColorToRGB(Clr);
  lb.lbStyle := bs_Solid;

  HPen := ExtCreatePen(PS_COSMETIC or PS_ALTERNATE,1, lb, 0, nil);
  HOldPen := SelectObject(ACanvas.Handle, HPen);

  Windows.MoveToEx(ACanvas.Handle, R.Left, R.Top, nil);
  Windows.LineTo(ACanvas.Handle, R.Right, R.Top);

  Windows.MoveToEx(ACanvas.Handle, R.Right, R.Top, nil);
  Windows.LineTo(ACanvas.Handle, R.Right, R.Bottom);

  Windows.MoveToEx(ACanvas.Handle, R.Right, R.Bottom, nil);
  Windows.LineTo(ACanvas.Handle, R.Left, R.Bottom);

  Windows.MoveToEx(ACanvas.Handle, R.Left, R.Top, nil);
  Windows.LineTo(ACanvas.Handle, R.Left, R.Bottom);

  DeleteObject(SelectObject(ACanvas.Handle,HOldPen));
end;

//------------------------------------------------------------------------------

{ TWinCtrl }

procedure TWinCtrl.PaintCtrls(DC: HDC; First: TControl);
begin
  PaintControls(DC, First);
end;

//------------------------------------------------------------------------------

{ TCustomTrackBar }

constructor TCustomTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 150;
  Height := 26;
  TabStop := True;
  FMin := 0;
  FMax := 10;
  FPosition := 0;
  //FLineSize := 1;
  FPageSize := 1;
  //FFrequency := 1;
  //FSelStart := 0;
  //FSelEnd := 0;
  FOrientation := trHorizontal;
  ControlStyle := ControlStyle - [csDoubleClicks];
  //FSliderVisible := True;

  FShowFocus := False;

  FBorderColor := clNone;
  FBorderColorDisabled := clNone;
  Color := clNone;
  FColorTo := clNone;
  FColorDisabled := clNone;
  FColorDisabledTo := clNone;

  FIBackGround := TGDIPPicture.Create;
  FIBackGround.OnChange := BackGroundChanged;

  FIBackGroundDisabled := TGDIPPicture.Create;
  FIBackGroundDisabled.OnChange := BackGroundChanged;

  FThumb := TTrackBarThumb.Create;
  FThumb.AdvTrackBar := Self;
  FThumb.OnChange := OnThumbChanged;

  FSlider := TTrackBarSlider.Create;
  FSlider.AdvTrackBar := Self;
  FSlider.OnChange := OnSliderChanged;

  FTickMark := TTrackBarTick.Create;
  FTickMark.OnChange := OnTickMarkChanged;

  FSliderTickOffset := 3;
  FOffset := 2;
  BorderWidth := 1;
  FTickTextOffset := 2;

  FIRateInActive := TGDIPPicture.Create;
  FIRateInActive.OnChange := OnRatePictureChanged;
  FIRateActive := TGDIPPicture.Create;
  FIRateActive.OnChange := OnRatePictureChanged;

  FButtons := TTrackBarButtons.Create;
  FButtons.AdvTrackBar := Self;
  FButtons.OnChange := OnButtonsChanged;
  
  FSliding := False;

  FTransparent := True;
  inherited BorderWidth := 0;
  DoubleBuffered := True;
  FTextHeight := 0;

  FTrackHint := ShowHint;
  FBackGroundStretched := False;
  FHintTickIndex := -1;

  FTrackHintWnd := TTrackHintWindow.Create(Self);
  FTrackHintShow := False;
end;

//------------------------------------------------------------------------------

destructor TCustomTrackBar.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;

  FIBackGround.Free;
  FIBackGroundDisabled.Free;
  FThumb.Free;
  FSlider.Free;
  FTickMark.Free;
  FIRateActive.Free;
  FIRateInActive.Free;
  FButtons.Free;
  FTrackHintWnd.Free;
  
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetMax(Value: Integer);
begin
	if (Value <> FMax) then
  begin
  	FMax := Value;
    if (FPosition > FMax) then
      Position := FMax;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetMin(Value: Integer);
begin
	if (Value <> FMin) then
  begin
  	FMin := Value;
    if (FPosition < FMin) then
      Position := FMin;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetOrientation(Value: TTrackBarOrientation);
begin
	if (Value <> FOrientation) then
  begin
  	FOrientation := Value;
    if ComponentState * [csLoading, csUpdating] = [] then
      SetBounds(Left, Top, Height, Width);
    RecreateWnd;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetPosition(Value: Integer);
var
  OldR, R, R2: TRect;
  rgn1, rgn2: HRGN;
  OldPos, i: Integer;
begin
	if (Value <> FPosition) then
  begin
  	if (Value < FMin) then
      Value := FMin
    else
    begin
    	if Value > FMax then
        Value := FMax;
    end;

    OldR := ThumbRect;
    OldPos := FPosition;
		FPosition :=	Value;
    R := ThumbRect;

    if csDesigning in ComponentState then
    	Invalidate
    else
    begin
      if IsRating then
      begin
        if (OldPos < FPosition) then
        begin
          for i := OldPos to FPosition do
            DrawRate(i);
        end
        else
        begin
          for i := OldPos downto FPosition do
            DrawRate(i);
        end;
      end
      else
      begin
        InflateRect(R, 1, 1);
        InflateRect(OldR, 1, 1);
        rgn1 := CreateRectRgn(OldR.Left, OldR.Top, OldR.Right, OldR.Bottom);
        rgn2 := CreateRectRgn(R.Left, R.Top, R.Right, R.Bottom);
        CombineRgn(rgn2, rgn1, rgn2, RGN_OR);
        if (Slider.ColorCompleted <> clNone) or not (Slider.PictureCompleted.Empty) then
        begin
          DeleteObject(rgn1);
          R2 := SliderRect;
          rgn1 := CreateRectRgn(R2.Left, R2.Top, R2.Right, R2.Bottom);
          CombineRgn(rgn2, rgn1, rgn2, RGN_OR);
        end;
        if TickMark.ShowImageAtThumbOnly then
        begin
          if (Orientation = trHorizontal) then
            R2 := Rect(R.Left, TrackClientRect.Top, R.Right, TrackClientRect.Bottom)
          else
            R2 := Rect(TrackClientRect.Left, R.Top, TrackClientRect.Right, R.Bottom);
            
          DeleteObject(rgn1);
          rgn1 := CreateRectRgn(R2.Left, R2.Top, R2.Right, R2.Bottom);
          CombineRgn(rgn2, rgn1, rgn2, RGN_OR);

          if (Orientation = trHorizontal) then
            R2 := Rect(OldR.Left, TrackClientRect.Top, OldR.Right, TrackClientRect.Bottom)
          else
            R2 := Rect(TrackClientRect.Left, OldR.Top, TrackClientRect.Right, OldR.Bottom);

          DeleteObject(rgn1);
          rgn1 := CreateRectRgn(R2.Left, R2.Top, R2.Right, R2.Bottom);
          CombineRgn(rgn2, rgn1, rgn2, RGN_OR);
        end;
        InvalidateRgn(Handle, rgn2, true);
        DeleteObject(rgn1);
        DeleteObject(rgn2);
      end;
      Change;
    end;
	end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.InternalClientRect: TRect;
var
  R: TRect;
begin
  R := ClientRect;
  //Result := Rect(BorderWidth + FOffset, BorderWidth + FOffset, Width - ((BorderWidth * 2) + (FOffset * 2)), Height {- 1} -((BorderWidth * 2) + (FOffset*2)));
  Result := Rect(R.Left + BorderWidth + FOffset, R.Top + BorderWidth + FOffset, R.Right - (BorderWidth + FOffset), R.Bottom -(BorderWidth + FOffset));
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.TrackClientRect: TRect;
begin
  Result := InternalClientRect;
  if (FOrientation = trHorizontal) then
    Result.Top := Result.Top + Slider.Offset
  else // (FOrientation = trVertical)
    Result.Left := Result.Left + Slider.Offset;
      
  if Buttons.Visible then
  begin
    if (FOrientation = trHorizontal) then
    begin
      Result.Left := MinButtonRect.Right + Buttons.Spacing;
      Result.Right := MaxButtonRect.Left - Buttons.Spacing;
    end
    else // (FOrientation = trVertical)
    begin
      Result.Bottom := MinButtonRect.Top - Buttons.Spacing;
      Result.Top := MaxButtonRect.Bottom + Buttons.Spacing;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.IndexOfTickAt(X, Y: Integer): Integer;
var
  i, L, w: Integer;
  R, Rt, Rb, R1: TRect;
  P, P1: TPoint;
  d: Double;
begin
  Result := -10;

  if IsRating or (TickMark.Size <= 0) or (TickMark.Style <> tsAuto) then
    Exit;

  R := TrackClientRect;
  Rt := TickMarkTopRect;
  Rb := TickMarkBottomRect;
  w := 2;
  P1 := Point(X, Y);
  if (Orientation = trHorizontal) then
  begin
    if FTickMark.ShowText then
    begin
      Rt.Top := Rt.Top + FTextHeight;
      Rb.Bottom := Rb.Bottom - FTextHeight;
    end;

    d := ((R.Right - R.Left) - FThumb.Width) / (Fmax - FMin);

    for i:= Min to Max do
    begin
      p.X := Trunc(D * (i - Min));
      if (TickMark.FPosition in [tmTopLeft, tmBoth]) then
      begin
        L := TickMark.Size;
        {DefaultDraw := True;
        if TickMark.ShowImageAtThumbOnly then
          DefaultDraw := (i = Position);
        if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
          DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);

        if DefaultDraw then }
          R1 := Rect(Rt.Left + p.X - w, Rt.Top, Rt.Left + p.X + w, Rt.Top + L);
        if PtInRect(R1, P1) then
        begin
          Result := i;
          Break;
        end;
      end;

      if (TickMark.FPosition in [tmBottomRight, tmBoth]) then
      begin
        L := TickMark.Size;
        {DefaultDraw := True;
        if TickMark.ShowImageAtThumbOnly then
          DefaultDraw := (i = Position);
        if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
          DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);

        if DefaultDraw then}
          R1 := Rect(Rb.Left + p.X - w, Rb.Bottom - L, Rb.Left + p.X + w, Rb.Bottom);
        if PtInRect(R1, P1) then
        begin
          Result := i;
          Break;
        end;
        
      end;
    end;

  end
  else // (Orientation = trVertical)
  begin
    if FTickMark.ShowText then
    begin
      Rt.Left := Rt.Left + FTextHeight;
      Rb.Right := Rb.Right - FTextHeight;
    end;

    d := ((R.Bottom - R.Top) - FThumb.Width) / (Fmax - FMin);

    for i:= Min to Max do
    begin
      p.X := Trunc(D * (i - Min));
      if (TickMark.FPosition in [tmTopLeft, tmBoth]) then
      begin
        L := TickMark.Size;
        {DefaultDraw := True;
        if TickMark.ShowImageAtThumbOnly then
          DefaultDraw := (i = Position);
        if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
          DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);

        if DefaultDraw then }
          R1 := Rect(Rt.Left, Rt.Bottom - p.X + w, Rt.Left + L, Rt.Bottom - p.X - w);
        if PtInRect(R1, P1) then
        begin
          Result := i;
          Break;
        end;
      end;

      if (TickMark.FPosition in [tmBottomRight, tmBoth]) then
      begin
        L := TickMark.Size;
        {DefaultDraw := True;
        if TickMark.ShowImageAtThumbOnly then
          DefaultDraw := (i = Position);
        if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
          DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);

        if DefaultDraw then }
          R1 := Rect(Rb.Right - L, Rb.Bottom - p.X + w, Rb.Right, Rb.Bottom - p.X - w);
        if PtInRect(R1, P1) then
        begin
          Result := i;
          Break;
        end;
      end;
    end;

  end;

end;

//------------------------------------------------------------------------------

function TCustomTrackBar.TickMarkTopRect: TRect;
var
  R: TRect;
  i, j: Integer;
begin
  R := TrackClientRect;
  if (FTickMark.Style = tsNone) or not (FTickMark.Position in [tmTopLeft, tmBoth]) then
  begin
    Result := Rect(-1, -1, -1, -1);
    Exit;
  end;

  i := 0;
  j := 0;
  if (Thumb.Width > 0) then
    j := (Thumb.Width div 2);

  if FTickMark.ShowText then
  begin
    //TextSize(Canvas, FTickMark.Font, 'gh', h, w);
    i := FTextHeight {+ (FTickTextOffset * 2)};
  end;
  
  if (FOrientation = trHorizontal) then
  begin
    i := i + FTickMark.Size;

    Result := Rect(R.Left + j, R.Top, R.Right - j, R.Top + i);
  end
  else // (FOrientation = trVertical)
  begin
    i := i + FTickMark.Size;

    Result := Rect(R.Left, R.Top + j, R.Left + i, R.Bottom - j);
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.TickMarkBottomRect: TRect;
var
  R, R2: TRect;
  i, j: Integer;
begin
  R := TrackClientRect;
  if (FTickMark.Style = tsNone) or not (FTickMark.Position in [tmBottomRight, tmBoth]) then
  begin
    Result := Rect(-1, -1, -1, -1);
    Exit;
  end;

  i := 0;
  j := 0;
  if (Thumb.Width > 0) then
    j := (Thumb.Width div 2);

  if FTickMark.ShowText then
  begin
    //TextSize(Canvas, FTickMark.Font, 'gh', h, w);
    i := FTextHeight {+ (FTickTextOffset * 2)};
  end;

  if (FOrientation = trHorizontal) then
  begin
    i := i + FTickMark.Size;

    if Slider.Visible and (FSlider.Size > 0) then
    begin
      R2 := SliderRect;

      // compensate for visual 3D border effect
      if FSlider.Border3D then
       R2.Bottom := R2.Bottom - 1;

      Result := Rect(R.Left + j, R2.Bottom + TickMark.Spacing, R.Right - j, R2.Bottom + TickMark.Spacing + i);
    end
    else if (FTickMark.Style <> tsNone) and (FTickMark.Position in [tmTopLeft, tmBoth]) then
    begin
      R2 := TickMarkTopRect;
      Result := Rect(R.Left + j, R2.Bottom + (TickMark.Spacing * 2), R.Right - j, R2.Bottom + (TickMark.Spacing * 2) + i);
    end
    else
    begin
      R2 := TrackClientRect;
      Result := Rect(R.Left + j, R2.Top, R.Right - j, R2.Top + i);
    end;
  end
  else // (FOrientation = trVertical)
  begin
    i := i + FTickMark.Size;

    if Slider.Visible and (FSlider.Size > 0) then
    begin
      R2 := SliderRect;

      if FSlider.Border3D then
       R2.Right := R2.Right - 1;

      Result := Rect(R2.Right + TickMark.Spacing, R.Top + j, R2.Right + TickMark.Spacing + i, R.Bottom - j);
    end
    else if (FTickMark.Style <> tsNone) and (FTickMark.Position in [tmTopLeft, tmBoth]) then
    begin
      R2 := TickMarkTopRect;
      Result := Rect(R2.Right + (TickMark.Spacing * 2), R.Top + j, R2.Right + (TickMark.Spacing * 2) + i, R.Bottom - j);
    end
    else
    begin
      R2 := TrackClientRect;
      Result := Rect(R2.Left, R.Top + j, R2.Left + i, R.Bottom - j);
    end;


  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.SliderRect: TRect;
var
  R: TRect;
begin
  if (slider.Size <= 0) or not Slider.Visible then
  begin
    Result := Rect(-1, -1, -1, -1);
    Exit;
  end;

  R := TrackClientRect;
  Result := R;
  
  if (FOrientation = trHorizontal) then
  begin
    if (FTickMark.Style <> tsNone) and (FTickMark.Position in [tmTopLeft, tmBoth]) then
      Result.Top := TickMarkTopRect.Bottom + TickMark.Spacing
    else
      Result.Top := R.Top;

    Result.Bottom := Result.Top + Slider.Size;
  end
  else // (FOrientation = trVertical)
  begin
    if (FTickMark.Style <> tsNone) and (FTickMark.Position in [tmTopLeft, tmBoth]) then
      Result.Left := TickMarkTopRect.Right + TickMark.Spacing
    else
      Result.Left := R.Left;
    Result.Right := Result.Left + Slider.Size;  
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.ThumbRect: TRect;
var
  R, R2: TRect;
  i: Integer;
begin
  Result := Rect(0, 0, 0, 0);

  R := TrackClientRect;
  if (FOrientation = trHorizontal) then
  begin
    if Slider.Visible and (Slider.Size > 0) then
    begin
      R2 := SliderRect;
      Result.Top := (R2.Top + (R2.Bottom - R2.Top) div 2) - (Thumb.Size div 2);
      Result.Bottom := Result.Top + FThumb.Size;
    end
    else if (FTickMark.Style <> tsNone) then
    begin
      if (FTickMark.Position in [tmTopLeft, tmBoth]) then
      begin
        R2 := TickMarkTopRect;
        Result.Top := R2.Top + TickMark.Spacing - (Thumb.Size div 2);
        Result.Bottom := Result.Top + FThumb.Size;
      end
      else
      begin
        R2 := TickMarkBottomRect;
        Result.Top := R2.Top;
        Result.Bottom := Result.Top + FThumb.Size;
      end;
    end
    else // (FTickMark.Style = tsNone)
    begin
      R2 := TrackClientRect;
      Result.Top := R2.Top;
      Result.Bottom := Result.Top + FThumb.Size;
    end;

    i := ((R.Right - R.Left) - FThumb.Width) * (FPosition - FMin) div (Fmax - FMin);
    Result.Left := R.Left + i;
    Result.Right := Result.Left + FThumb.Width;

    if (Thumb.Shape = tsLine) and  FThumb.Picture.Empty then
    begin
      Result.Top := InternalClientRect.Top;
      Result.Bottom := Height - BorderWidth; //InternalClientRect.Bottom;
    end;
  end
  else // (FOrientation = trVertical)
  begin
    if Slider.Visible and (Slider.Size > 0) then
    begin
      R2 := SliderRect;
      Result.Left := (R2.Left + (R2.Right - R2.Left) div 2) - (Thumb.Size div 2);
      Result.Right := Result.Left + FThumb.Size;
    end
    else if (FTickMark.Style <> tsNone) then
    begin
      if (FTickMark.Position in [tmTopLeft, tmBoth]) then
      begin
        R2 := TickMarkTopRect;
        Result.Left := R2.Left + TickMark.Spacing - (Thumb.Size div 2);
        Result.Right := Result.Left + FThumb.Size;
      end
      else
      begin
        R2 := TickMarkBottomRect;
        Result.Left := R2.Left;
        Result.Right := Result.Left + FThumb.Size;
      end;
    end
    else // (FTickMark.Style = tsNone)
    begin
      R2 := TrackClientRect;
      Result.Left := R2.Left;
      Result.Right := Result.Left + FThumb.Size;
    end;

    i := ((R.Bottom - R.Top) - FThumb.Width) * (FPosition - FMin) div (Fmax - FMin);
    Result.Bottom := R.Bottom - i;
    Result.Top := Result.Bottom - FThumb.Width;

    if (Thumb.Shape = tsLine) and FThumb.Picture.Empty then
    begin
      Result.Left := InternalClientRect.Left;
      Result.Right := Width - BorderWidth;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.TrackingRect: TRect;
begin
  Result := TrackClientRect;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.Paint;
var
  Rgn1: HRGN;
  R: TRect;
  i: Integer;
  p: TPoint;
begin
  if Transparent then
  begin
    // TRANSPARENCY CODE
    R := ClientRect;
    rgn1 :=  CreateRectRgn(R.Left, R.Top, R.Right, R.Bottom);
    SelectClipRgn(Canvas.Handle, rgn1);

    i := SaveDC(Canvas.Handle);
    p := ClientOrigin;
    Windows.ScreenToClient(Parent.Handle, p);
    p.x := -p.x;
    p.y := -p.y;
    MoveWindowOrg(Canvas.Handle, p.x, p.y);

    SendMessage(Parent.Handle, WM_ERASEBKGND, Canvas.Handle, 0);
    // transparency ?
    SendMessage(Parent.Handle, WM_PAINT, Canvas.Handle, 0);

    if (Parent is TWinCtrl) then
     (Parent as TWinCtrl).PaintCtrls(Canvas.Handle, nil);

    RestoreDC(Canvas.Handle, i);

    SelectClipRgn(Canvas.Handle, 0);
    DeleteObject(rgn1);
  end;

  DrawBackGround;
  if IsRating then
    DrawRates
  else
  begin
    DrawSlider;
    DrawTickMarks;
    DrawThumb;
    DrawButtons;
    
    if Focused and ShowFocus then
    begin
      {    
      //DrawFocusRect(handle, ClientRect);
      Canvas.Pen.Color :=clSilver;
      Canvas.Pen.Style := psDot;
      Canvas.Brush.Style := bsClear;
      Canvas.MoveTo(R.Left, R.Top);
      Canvas.LineTo(R.Right - 1, R.Top);
      Canvas.MoveTo(R.Right - 1, R.Top);
      Canvas.LineTo(R.Right - 1, R.Bottom - 1);
      Canvas.MoveTo(R.Right - 1, R.Bottom - 1);
      Canvas.LineTo(R.Left, R.Bottom - 1);
      Canvas.MoveTo(R.Left, R.Bottom - 1);
      Canvas.LineTo(R.Left, R.Top);
      Canvas.Pen.Style := psSolid;}
      DrawFocusRect(Canvas, Rect(R.Left, R.Top, R.Right - 1, R.Bottom - 1), clBlack);            
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawBackGround;
var
  R: TRect;
  Pic: TGDIPPicture;
  BrClr, Clr, ClrTo: TColor;
  bmp: TBitmap;
begin

  Pic := BackGround;
  if Self.Enabled then
  begin
    Pic := BackGround;
    BrClr := BorderColor;
    Clr := Color;
    ClrTo := ColorTo;
  end
  else
  begin
    if not BackGroundDisabled.Empty then
      Pic := BackGroundDisabled;
    BrClr := BorderColorDisabled;
    Clr := ColorDisabled;
    ClrTo := ColorDisabledTo;
  end;

  R := ClientRect;

  if not Pic.Empty then
  begin
    if BackGroundStretched then
    begin
      Pic.GetImageSizes;
      bmp := TBitmap.Create;
      bmp.Width := Pic.Width;
      bmp.Height := Pic.Height;
      bmp.Transparent := True;
      //Pic.Transparent := True;
      bmp.Canvas.Draw(0, 0, Pic);
      Canvas.StretchDraw(R, bmp);
      bmp.Free;
    end
    else
    begin
      Pic.Transparent := True;
      Canvas.Draw(R.Left, R.Top, Pic);
    end;  
  end
  else if not Transparent then
  begin
    if (Clr <> clNone) or (ClrTo <> clNone) then
    begin
      if (Clr <> clNone) and (ClrTo <> clNone) then
        DrawInOutGradient(Canvas, Clr, ClrTo, 80, R, Direction)
      else
      begin
        Canvas.Brush.Color := Clr;
        Canvas.FillRect(R);
      end;
    end;
  end;

  // DrawBorder
  if (BrClr <> clNone) and (BorderWidth > 0) then
  begin
    Canvas.Pen.Color := BrClr;
    Canvas.Pen.Width := BorderWidth;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(R);
    Canvas.Pen.Width := 1;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawSlider;
var
  R, R1, R2: TRect;
  Pic, PicCM: TGDIPPicture;
  BrClr, Clr, ClrTo, ClrCM, ClrCMTo, BrOutClr: TColor;
  rgn1: HRGN;
  rd, i: Integer;
  bmp: TBitmap;
  DrawCM: Boolean;
begin
  if IsRating or (Slider.Size <= 0) or not Slider.Visible then
    Exit;

  with Slider do
  begin
    Pic := Picture;
    if Self.Enabled then
    begin
      Pic := Picture;
      PicCM := PictureCompleted;
      BrClr := BorderColor;
      Clr := Color;
      ClrTo := ColorTo;
      ClrCM := ColorCompleted;
      ClrCMTo := ColorCompletedTo;
    end
    else
    begin
      if not PictureDisabled.Empty then
        Pic := PictureDisabled;
      PicCM := PictureCompletedDisabled;
      BrClr := BorderColorDisabled;
      Clr := ColorDisabled;
      ClrTo := ColorDisabledTo;
      ClrCM := ColorCompletedDisabled;
      ClrCMTo := ColorCompletedDisabledTo;
    end;
  end;

  BrOutClr := clWhite;

  R := SliderRect;
  DrawCM := (ClrCM <> clNone) or (not PicCM.Empty);
  if DrawCM then
  begin
    if (Orientation = trHorizontal) then
    begin
      i := ThumbRect.Left + (Thumb.Width div 2);
      R1 := Rect(R.Left, R.Top, i, R.Bottom);
      R2 := Rect(R1.Right-1, R.Top, R.Right, R.Bottom);
    end
    else
    begin
      i := ThumbRect.Top + (Thumb.Width div 2);
      R1 := Rect(R.Left, i, R.Right, R.Bottom);
      R2 := Rect(R1.Left, R.Top, R.Right, i + 1);
    end;

    if (Position = FMin) then
    begin
      R1 := Rect(-1, -1, -1, -1);
      R2 := R;
    end;

    if (Position = FMax) then
    begin
      R2 := Rect(-1, -1, -1, -1);
      R1 := R;
    end;
  end
  else
  begin
    R1 := Rect(-1, -1, -1, -1);
    R2 := R;
  end;

  rd := 7;

  rgn1 := 0;
  if Slider.Rounded and Pic.Empty then
  begin
    rgn1 := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, rd, rd);
    SelectClipRgn(Canvas.Handle, rgn1);
  end;

  // Draw BackGround
  if not Pic.Empty then
  begin
    if DrawCM and not PicCM.Empty then
    begin
      PicCM.GetImageSizes;
      if Slider.PictureStretched then
      begin
        bmp := TBitmap.Create;
        bmp.Width := PicCM.Width;
        bmp.Height := PicCM.Height;
        bmp.Transparent := true;
        bmp.Canvas.Draw(0, 0, PicCM);
        Canvas.StretchDraw(R1, bmp);
        bmp.Free;
      end
      else if (R1.Left > 0) and (R1.Right > 0) then
      begin
        PicCM.Transparent := true;
        rgn1 := CreateRectRgn(R1.Left, R1.Top, R1.Right, R1.Bottom);
        SelectClipRgn(Canvas.Handle, rgn1);

        Canvas.Draw(R.Left, R.Top, PicCM);

        SelectClipRgn(Canvas.Handle, 0);
        DeleteObject(rgn1);
      end;
    end;

    Pic.GetImageSizes;
    if Slider.PictureStretched then
    begin
      bmp := TBitmap.Create;
      bmp.Width := Pic.Width;
      bmp.Height := Pic.Height;
      bmp.Transparent := true;
      bmp.Canvas.Draw(0, 0, Pic);
      Canvas.StretchDraw(R2, bmp);
      bmp.Free;
    end
    else if (R2.Left > 0) and (R2.Right > 0) then
    begin
      Pic.Transparent := true;
      rgn1 := CreateRectRgn(R2.Left, R2.Top, R2.Right, R2.Bottom);
      SelectClipRgn(Canvas.Handle, rgn1);

      Canvas.Draw(R.Left, R.Top, Pic);

      SelectClipRgn(Canvas.Handle, 0);
      DeleteObject(rgn1);
    end;
  end
  else
  begin
    if DrawCM then
    begin
      if (ClrCM <> clNone) or (ClrCMTo <> clNone) then
      begin
        if (ClrCM <> clNone) and (ClrCMTo <> clNone) then
          DrawInOutGradient(Canvas, ClrCM, ClrCMTo, Slider.Steps, R1, Slider.Direction)
        else
        begin
          Canvas.Brush.Color := ClrCM;
          Canvas.FillRect(R2);
        end;
      end;
    end;

    if (Clr <> clNone) or (ClrTo <> clNone) then
    begin
      if (Clr <> clNone) and (ClrTo <> clNone) then
        DrawInOutGradient(Canvas, Clr, ClrTo, Slider.Steps, R2, Slider.Direction)
      else
      begin
        Canvas.Brush.Color := Clr;
        Canvas.FillRect(R2);
      end;
    end;
  end;

  if Slider.Rounded then
  begin
    SelectClipRgn(Canvas.Handle, 0);
    if (rgn1 <> 0) then
      DeleteObject(rgn1);
  end;

  // DrawBorder
  if (BrClr <> clNone) then
  begin
    if Slider.Rounded then
    begin
      if Slider.Border3D then
      begin
        Canvas.Pen.Color := BrClr;
        Canvas.Brush.Style := bsClear;
        Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, rd, rd);
        InflateRect(R, -1, -1);
        Canvas.Pen.Color := BrOutClr;
        Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, rd, rd);
      end
      else
      begin
        Canvas.Pen.Color := BrClr;
        Canvas.Brush.Style := bsClear;
        Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, rd, rd);
      end;
    end
    else
    begin
      if Slider.Border3D then
      begin
        Draw3DRect(Canvas, R, True, BrClr, BlendColor(BrClr, BrOutClr, 10));
      end
      else
      begin
        Canvas.Pen.Color := BrClr;
        Canvas.Brush.Style := bsClear;
        Canvas.Rectangle(R);
      end;
    end;
  end;

end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawTickMarks;
var
  R, Rt, Rb: TRect;
  i, j, h, w: Integer;
  d: Double;
  p, PTxt: TPoint;
  Clr, Clr1, ClrTxt: TColor;
  DefaultDraw: Boolean;
  L: Integer;
  s: string;
  tf: TFont;
  lf: TLogFont;
begin
  if IsRating or (TickMark.Size <= 0) or (TickMark.Style <> tsAuto) then
    Exit;

  R := TrackClientRect;
  Rt := TickMarkTopRect;
  Rb := TickMarkBottomRect;
  PTxt := Point(-20, -20);
  if (Orientation = trHorizontal) then
  begin

    if FTickMark.ShowText then
    begin
      Rt.Top := Rt.Top + FTextHeight;
      Rb.Bottom := Rb.Bottom - FTextHeight;
    end;

    d := ((R.Right - R.Left) - FThumb.Width) / (Fmax - FMin);

    if Self.Enabled then
      Clr := TickMark.Color
    else
      Clr := TickMark.ColorDisabled;

    for i:= Min to Max do
    begin
      p.X := Trunc(D * (i - Min));
      if (TickMark.FPosition in [tmTopLeft, tmBoth]) then
      begin
        DefaultDraw := True;
        L := TickMark.Size;
        s := '';
        Clr1 := Clr;
        ClrTxt := TickMark.Font.Color;
        if Assigned(FOnDrawTick) then
          FOnDrawTick(Self, Canvas, Point(Rt.Left + P.X, Rt.Top), i, tmTopLeft, L, Clr1, ClrTxt, s, DefaultDraw)
        else if TickMark.ShowText then
        begin
          s := InttoStr(i);
        end;

        Canvas.Pen.Color := Clr1;

        if DefaultDraw then
        begin
          if TickMark.ShowImageAtThumbOnly then
            DefaultDraw := (i = Position);
          if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
            DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);
        end;

        if DefaultDraw then
        begin
          if Assigned(TickImages) then
          begin
            if (TickImages.Count > 0) then
            begin
              j := FImages.Width div 2;
              if (i < TickImages.Count) then
                TickImages.Draw(Canvas, Rt.Left + p.X - j, Rt.Top, i, Enabled)
              else
                TickImages.Draw(Canvas, Rt.Left + p.X - j, Rt.Top, 0, Enabled);
            end;
          end
          else
          begin
            if TickMark.Line3D then
            begin
              Canvas.MoveTo(Rt.Left + p.X, Rt.Top);
              Canvas.LineTo(Rt.Left + p.X, Rt.Top + L);
              Canvas.Pen.Color := BlendColor(Clr1, clWhite, 10);
              Canvas.MoveTo(Rt.Left + p.X + 1, Rt.Top);
              Canvas.LineTo(Rt.Left + p.X + 1, Rt.Top + L);
              //Draw3DLine(Canvas, Point(Rt.Left, Rt.Top), Point(Rt.Left, Rt.Top + L), False, clWhite, Clr)
            end
            else
            begin
              Canvas.MoveTo(Rt.Left + p.X, Rt.Top);
              Canvas.LineTo(Rt.Left + p.X, Rt.Top + L);
            end;
          end;

          // Draw text
          if FTickMark.ShowText then
          begin
            PTxt := Point(Rt.Left + p.X, Rt.Top - FTextHeight + FTickTextOffset);
            TextSize(Canvas, TickMark.Font, S, h, w);
            PTxt.X := PTxt.X - (W div 2);
            
            Canvas.Font.Assign(TickMark.Font);
            Canvas.Font.Color := ClrTxt;
            Canvas.Brush.Style := bsClear;
            Canvas.TextOut(PTxt.X, PTxt.Y, S);
          end;

        end;
      end;

      if (TickMark.FPosition in [tmBottomRight, tmBoth]) then
      begin
        DefaultDraw := True;
        L := TickMark.Size;
        s := '';
        Clr1 := Clr;
        ClrTxt := TickMark.Font.Color;
        if Assigned(FOnDrawTick) then
          FOnDrawTick(Self, Canvas, Point(Rb.Left + P.X, Rb.Top), i, tmBottomRight, L, Clr1, ClrTxt, s, DefaultDraw)
        else if TickMark.ShowText then
          s := InttoStr(i);

        Canvas.Pen.Color := Clr1;
        if DefaultDraw then
        begin
          if TickMark.ShowImageAtThumbOnly then
            DefaultDraw := (i = Position);
          if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
            DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);
        end;
        
        if DefaultDraw then
        begin
          if Assigned(TickImages) then
          begin
            if (TickImages.Count > 0) then
            begin
              j := FImages.Width div 2;
              if (i < TickImages.Count) then
                TickImages.Draw(Canvas, Rb.Left + p.X - j, Rb.Top, i, Enabled)
              else
                TickImages.Draw(Canvas, Rb.Left + p.X - j, Rb.Top, 0, Enabled);
            end;
          end
          else
          begin
            if TickMark.Line3D then
            begin
              //Draw3DLine(Canvas, Point(Rb.Left, Rb.Bottom - L), Point(Rb.Left, Rb.Bottom), False, clWhite, Clr1)
              Canvas.MoveTo(Rb.Left + p.X, Rb.Bottom - L);
              Canvas.LineTo(Rb.Left + p.X, Rb.Bottom);
              Canvas.Pen.Color := BlendColor(Clr1, clWhite, 10);
              Canvas.MoveTo(Rb.Left + p.X + 1, Rb.Bottom - L);
              Canvas.LineTo(Rb.Left + p.X + 1, Rb.Bottom);
            end
            else
            begin
              Canvas.MoveTo(Rb.Left + p.X, Rb.Bottom - L);
              Canvas.LineTo(Rb.Left + p.X, Rb.Bottom);
            end;
          end;

          // Draw text
          if FTickMark.ShowText then
          begin
            PTxt := Point(Rb.Left + p.X, Rb.Bottom + FTickTextOffset);
            TextSize(Canvas, TickMark.Font, S, h, w);
            PTxt.X := PTxt.X - (W div 2);

            Canvas.Font.Assign(TickMark.Font);
            Canvas.Font.Color := ClrTxt;
            Canvas.Brush.Style := bsClear;
            Canvas.TextOut(PTxt.X, PTxt.Y, S);
          end;

        end;
      end;
    end;

  end
  else // (Orientation = trVertical)
  begin
    if FTickMark.ShowText then
    begin
      Rt.Left := Rt.Left + FTextHeight;
      Rb.Right := Rb.Right - FTextHeight;
    end;

    d := ((R.Bottom - R.Top) - FThumb.Width) / (Fmax - FMin);

    if Self.Enabled then
      Clr := TickMark.Color
    else
      Clr := TickMark.ColorDisabled;

    for i:= Min to Max do
    begin
      p.X := Trunc(D * (i - Min));
      if (TickMark.FPosition in [tmTopLeft, tmBoth]) then
      begin
        DefaultDraw := True;
        L := TickMark.Size;
        s := '';
        Clr1 := Clr;
        ClrTxt := TickMark.Font.Color;
        if Assigned(FOnDrawTick) then
          FOnDrawTick(Self, Canvas, Point(Rt.Left, Rt.Bottom - P.X), i, tmTopLeft, L, Clr1, ClrTxt, s, DefaultDraw)
        else if TickMark.ShowText then
          s := InttoStr(i);
          
        Canvas.Pen.Color := Clr1;
        if DefaultDraw then
        begin
          if TickMark.ShowImageAtThumbOnly then
            DefaultDraw := (i = Position);
          if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
            DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);
        end;

        if DefaultDraw then
        begin
          if Assigned(TickImages) then
          begin
            if (TickImages.Count > 0) then
            begin
              j := FImages.Height div 2;
              if (i < TickImages.Count) then
                TickImages.Draw(Canvas, Rt.Left, (Rt.Bottom - P.X) - j, i, Enabled)
              else
                TickImages.Draw(Canvas, Rt.Left, (Rt.Bottom - P.X) - j, 0, Enabled);
            end;
          end
          else
          begin
            if TickMark.Line3D then
            begin
              Canvas.MoveTo(Rt.Left, Rt.Bottom - p.X);
              Canvas.LineTo(Rt.Left + L, Rt.Bottom - p.X);
              Canvas.Pen.Color := BlendColor(Clr1, clWhite, 10);
              Canvas.MoveTo(Rt.Left, Rt.Bottom - p.X - 1);
              Canvas.LineTo(Rt.Left + L, Rt.Bottom - p.X - 1);
            end
            else
            begin
              Canvas.MoveTo(Rt.Left, Rt.Bottom - p.X);
              Canvas.LineTo(Rt.Left + L, Rt.Bottom - p.X);
            end;
          end;

          // Draw text
          if FTickMark.ShowText then
          begin
            TextSize(Canvas, TickMark.Font, S, h, w);

            Canvas.Font.Assign(TickMark.Font);
            Canvas.Font.Color := ClrTxt;
            Canvas.Brush.Style := bsClear;

            if FTickMark.RotateFontVert then
            begin
              PTxt := Point(Rt.Left  - FTextHeight + FTickTextOffset, Rt.Bottom - p.X);
              PTxt.Y := PTxt.Y + (w div 2);

              tf := TFont.Create;
              try
        {$IFNDEF TMSDOTNET}
                FillChar(lf, SizeOf(lf), 0);
        {$ENDIF}
                tf.Assign(Canvas.Font);
        {$IFNDEF TMSDOTNET}
                GetObject(tf.Handle, SizeOf(Lf), @Lf);
        {$ENDIF}
        {$IFDEF TMSDOTNET}
                GetObject(tf.Handle, Marshal.SizeOf(TypeOf(Lf)), Lf);
        {$ENDIF}

                lf.lfEscapement := -2700;
                lf.lfOrientation := 30;

                tf.Handle := CreateFontIndirect(Lf);
                Canvas.Font.Assign(tf);
              finally
                tf.Free;
              end;
            end
            else
            begin
              PTxt := Point(Rt.Left  - Canvas.TextWidth(s) - FTickTextOffset, Rt.Bottom - p.X);
              PTxt.Y := PTxt.Y - (FTextHeight div 2);
            end;

            Canvas.TextOut(PTxt.X, PTxt.Y, S);
            //DrawText(Canvas.Handle, PChar(s), -1, R, DT_SINGLELINE or DT_VCENTER or DT_Left)
          end;

        end;
      end;

      if (TickMark.FPosition in [tmBottomRight, tmBoth]) then
      begin
        DefaultDraw := True;
        L := TickMark.Size;
        s := '';
        Clr1 := Clr;
        ClrTxt := TickMark.Font.Color;
        if Assigned(FOnDrawTick) then
          FOnDrawTick(Self, Canvas, Point(Rb.Right - L, Rb.Bottom - P.X), i, tmBottomRight, L, Clr1, ClrTxt, s, DefaultDraw)
        else if TickMark.ShowText then
          s := InttoStr(i);
          
        Canvas.Pen.Color := Clr1;
        if DefaultDraw then
        begin
          if TickMark.ShowImageAtThumbOnly then
            DefaultDraw := (i = Position);
          if DefaultDraw and (TickMark.ShowImageAtSteps > 1) then
            DefaultDraw := ((i mod TickMark.ShowImageAtSteps) = 0);
        end;
        
        if DefaultDraw then
        begin
          if Assigned(TickImages) then
          begin
            if (TickImages.Count > 0) then
            begin
              j := FImages.Height div 2;
              if (i < TickImages.Count) then
                TickImages.Draw(Canvas, Rb.Right - L, (Rb.Bottom - P.X) - j, i, Enabled)
              else
                TickImages.Draw(Canvas, Rb.Right - L, (Rb.Bottom - P.X) - j, 0, Enabled);
            end;
          end
          else
          begin
            if TickMark.Line3D then
            begin
              Canvas.MoveTo(Rb.Right - L, Rb.Bottom - p.X);
              Canvas.LineTo(Rb.Right, Rb.Bottom - p.X);
              Canvas.Pen.Color := BlendColor(Clr1, clWhite, 10);
              Canvas.MoveTo(Rb.Right - L, Rb.Bottom - p.X - 1);
              Canvas.LineTo(Rb.Right, Rb.Bottom - p.X - 1);
            end
            else
            begin
              Canvas.MoveTo(Rb.Right - L, Rb.Bottom - p.X);
              Canvas.LineTo(Rb.Right, Rb.Bottom - p.X);
            end;
          end;

          // Draw text
          if FTickMark.ShowText then
          begin
            TextSize(Canvas, TickMark.Font, S, h, w);

            Canvas.Font.Assign(TickMark.Font);
            Canvas.Font.Color := ClrTxt;
            Canvas.Brush.Style := bsClear;

            if FTickMark.RotateFontVert then
            begin
              PTxt := Point(Rb.Right + FTextHeight, Rb.Bottom - p.X);
              PTxt.Y := PTxt.Y - (w div 2);
              tf := TFont.Create;
              try
        {$IFNDEF TMSDOTNET}
                FillChar(lf, SizeOf(lf), 0);
        {$ENDIF}
                tf.Assign(Canvas.Font);
        {$IFNDEF TMSDOTNET}
                GetObject(tf.Handle, SizeOf(Lf), @Lf);
        {$ENDIF}
        {$IFDEF TMSDOTNET}
                GetObject(tf.Handle, Marshal.SizeOf(TypeOf(Lf)), Lf);
        {$ENDIF}

                lf.lfEscapement := -900;
                lf.lfOrientation := 30;

                tf.Handle := CreateFontIndirect(Lf);
                Canvas.Font.Assign(tf);
              finally
                tf.Free;
              end;
            end
            else
            begin
              PTxt := Point(Rb.Left + FTickMark.Size + FTickTextOffset, Rt.Bottom - p.X);
              PTxt.Y := PTxt.Y - (FTextHeight div 2);
            end;

            Canvas.TextOut(PTxt.X, PTxt.Y, S);
          end;

        end;
      end;
    end;

  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawThumb;
var
  R, R2, R3: TRect;
  Pic: TGDIPPicture;
  BrClr, Clr, ClrTo, ClrM, ClrMTo, BrOutClr: TColor;
  i, j: Integer;
  rgn1, rgn2, rgn3: HRGN;
  PtArrowT, PtArrowB: array[0..2] of TPoint;
  graphic: TGPGraphics;
  path: TGPGraphicsPath;
  Rgn: TGPRegion;
  Pt: TPoint;
  GradDir: TGradientDirection;
begin
  if IsRating or (Thumb.Size <= 0) then
    Exit;

  if not Thumb.ShowAtMinMax and 
    ((Position = Min) or (Position = Max)) then
    Exit;


  with Thumb do
  begin
    Pic := Picture;
    BrClr := BorderColor;
    Clr := Color;
    ClrTo := ColorTo;
    ClrM := ColorMirror;
    ClrMTo := ColorMirrorTo;

    BrOutClr := clWhite;
    
    if FThumbDown then
    begin
      if not PictureDown.Empty then
        Pic := PictureDown;
      BrClr := BorderColorDown;
      Clr := ColorDown;
      ClrTo := ColorDownTo;
      ClrM := ColorMirrorDown;
      ClrMTo := ColorMirrorDownTo;
    end
    else if FThumbHot then
    begin
      if not PictureHot.Empty then
        Pic := PictureHot;
      BrClr := BorderColorHot;
      Clr := ColorHot;
      ClrTo := ColorHotTo;
      ClrM := ColorMirrorHot;
      ClrMTo := ColorMirrorHotTo;
    end;

    if not Self.Enabled then
    begin
      if not PictureDisabled.Empty then
        Pic := PictureDisabled;
      BrClr := BorderColorDisabled;
      Clr := ColorDisabled;
      ClrTo := ColorDisabledTo;
      ClrM := ColorMirrorDisabled;
      ClrMTo := ColorMirrorDisabledTo;
    end;
  end;

  R := ThumbRect;

  case Thumb.Gradient of
    ggDiagonalForward: GradDir := gdHorizontalInOut;
    ggDiagonalBackward: GradDir := gdVertical;
    ggVertical: GradDir := gdVertical;
    ggRadial: GradDir := gdHorizontal;
    else
      GradDir := gdHorizontal;
  end;

  if not Pic.Empty then
  begin
    Pic.GetImageSizes;
    Pic.Transparent := True;
    {if Thumb.PictureStretched then
    begin
      bmp := TBitmap.Create;
      bmp.Width := Pic.Width;
      bmp.Height := Pic.Height;
      bmp.Transparent := True;
      bmp.Canvas.Draw(0, 0, Pic);
      Canvas.StretchDraw(R, bmp);
      bmp.Free;
    end
    else}
      Canvas.Draw(R.Left, R.Top, Pic);
  end
  else
  begin
    case Thumb.Shape of
      tsPointer:
      begin
        if (Orientation = trHorizontal) then
        begin
          R2 := R;
          i := (R.Right - R.Left) div 2;
          if (TickMark.Position in [tmTopLeft, tmBoth]) then
          begin
            R2.Top := R2.Top + i;
            PtArrowT[0] := Point(R.Left, R.Top + i);
            PtArrowT[1] := Point(R.Left + i, R.Top);
            PtArrowT[2] := Point(R.Right, R.Top + i);
          end
          else
          begin
            PtArrowT[0] := Point(0, 0);
            PtArrowT[1] := Point(0, 0);
            PtArrowT[2] := Point(0, 0);
          end;

          if (TickMark.Position in [tmBottomRight, tmBoth]) then
          begin
            R2.Bottom := R2.Bottom - i;
            PtArrowB[0] := Point(R.Left, R.Bottom - i);
            PtArrowB[1] := Point(R.Left + i, R.Bottom);
            PtArrowB[2] := Point(R.Right, R.Bottom - i);
          end
          else
          begin
            PtArrowB[0] := Point(0, 0);
            PtArrowB[1] := Point(0, 0);
            PtArrowB[2] := Point(0, 0);
          end;
        end
        else // (Orientation = trVertical)
        begin
          R2 := R;
          i := (R.Bottom - R.Top) div 2;
          if (TickMark.Position in [tmTopLeft, tmBoth]) then
          begin
            R2.Left := R2.Left + i;
            PtArrowT[0] := Point(R.Left + i, R.Bottom);
            PtArrowT[1] := Point(R.Left, R.Top + i);
            PtArrowT[2] := Point(R.Left + i, R.Top);
          end
          else
          begin
            PtArrowT[0] := Point(0, 0);
            PtArrowT[1] := Point(0, 0);
            PtArrowT[2] := Point(0, 0);
          end;

          if (TickMark.Position in [tmBottomRight, tmBoth]) then
          begin
            R2.Right := R2.Right - i;
            PtArrowB[0] := Point(R.Right - i, R.Bottom);
            PtArrowB[1] := Point(R.Right, R.Bottom - i);
            PtArrowB[2] := Point(R.Right - i, R.Top);
          end
          else
          begin
            PtArrowB[0] := Point(0, 0);
            PtArrowB[1] := Point(0, 0);
            PtArrowB[2] := Point(0, 0);
          end;
        end;

        R3 := Rect(R2.Left, R2.Top, R2.Right - R2.Left, R2.Bottom - R2.Top);
        
        graphic := TGPGraphics.Create(Canvas.Handle);
        path := CreatePointerPolygon(R2, PtArrowT[1], PtArrowB[1], Orientation, TickMark.Position);
        Rgn := TGPRegion.Create(path);
        path.Free;

        rgn1 := CreatePolygonRgn(PtArrowT, 3, ALTERNATE);
        rgn2 := CreatePolygonRgn(PtArrowB, 3, WINDING);
        rgn3 := CreateRectRgn(R2.Left, R2.Top, R2.Right, R2.Bottom);
        CombineRgn(rgn2, rgn1, rgn2, RGN_OR);
        CombineRgn(rgn3, rgn2, rgn3, RGN_OR);

        case Thumb.Style of
          tstOffice2007:  // Thumb.Shape = tsPointer
          begin
            if (Clr <> clNone) and (ClrTo <> clNone) then
            begin
              if (ClrM <> clNone) and (ClrMTo <> clNone) then
              begin
                graphic.SetClip(Rgn);
                DrawVistaGradient(graphic, Canvas, R, bsRectangle, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Thumb.Gradient, Thumb.GradientMirror, Orientation);
                graphic.ResetClip();
              end
              else
              begin
                SelectClipRgn(Canvas.Handle, rgn3);
                DrawInOutGradient(Canvas, Clr, ClrTo, Thumb.Steps, R, GradDir);
                SelectClipRgn(Canvas.Handle, 0);
              end;
            end
            else if (Clr <> clNone) then
            begin
              SelectClipRgn(Canvas.Handle, rgn3);
              Canvas.Brush.Color := Clr;
              Canvas.FillRect(R);
              SelectClipRgn(Canvas.Handle, 0);
            end;

            if (BrClr <> clNone) then
            begin
              if (Orientation = trHorizontal) then
              begin
                Canvas.Pen.Color := BrOutClr;
                Canvas.Brush.Style := bsClear;
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Left, R2.Bottom);
                Canvas.MoveTo(R2.Right, R2.Top);
                Canvas.LineTo(R2.Right, R2.Bottom+1);
                if (TickMark.Position in [tmTopLeft, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowT[0].X, ptArrowT[0].Y);
                  Canvas.LineTo(PtArrowT[1].X, ptArrowT[1].Y);
                  Canvas.MoveTo(PtArrowT[1].X, ptArrowT[1].Y);
                  Canvas.LineTo(PtArrowT[2].X, ptArrowT[2].Y);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Right, R2.Top);
                end;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowB[0].X, ptArrowB[0].Y);
                  Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y);
                  Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y);
                  Canvas.LineTo(PtArrowB[2].X, ptArrowB[2].Y);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Bottom);
                  Canvas.LineTo(R2.Right, R2.Bottom);
                end;

                InflateRect(R2, -1, -1);
                Canvas.Pen.Color := BrClr;
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Left, R2.Bottom + 1);
                Canvas.MoveTo(R2.Right, R2.Top);
                Canvas.LineTo(R2.Right, R2.Bottom+1);
                if (TickMark.Position in [tmTopLeft, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowT[0].X + 1, ptArrowT[0].Y);
                  Canvas.LineTo(PtArrowT[1].X, ptArrowT[1].Y + 1);
                  Canvas.MoveTo(PtArrowT[1].X, ptArrowT[1].Y + 1);
                  Canvas.LineTo(PtArrowT[2].X, ptArrowT[2].Y + 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Right, R2.Top);
                end;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowB[0].X + 1, ptArrowB[0].Y);
                  Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y - 1);
                  Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y - 1);
                  Canvas.LineTo(PtArrowB[2].X, ptArrowB[2].Y - 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Bottom);
                  Canvas.LineTo(R2.Right, R2.Bottom);
                end;

                InflateRect(R2, -1, -1);
                Canvas.Pen.Color := BrOutClr; //BlendColor(ClrTo, BrClr, 50);
                j := 1;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                  j := 2;
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Left, R2.Bottom + j);
                Canvas.MoveTo(R2.Right, R2.Top);
                Canvas.LineTo(R2.Right, R2.Bottom + j);

                if (TickMark.Position in [tmTopLeft, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowT[0].X + 2, ptArrowT[0].Y);
                  Canvas.LineTo(PtArrowT[1].X, ptArrowT[1].Y + 2);
                  Canvas.MoveTo(PtArrowT[1].X, ptArrowT[1].Y + 2);
                  Canvas.LineTo(PtArrowT[2].X - 1, ptArrowT[2].Y + 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Right, R2.Top);
                end;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowB[0].X + 2, ptArrowB[0].Y);
                  Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y - 2);
                  Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y - 2);
                  Canvas.LineTo(PtArrowB[2].X - 1, ptArrowB[2].Y - 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Bottom);
                  Canvas.LineTo(R2.Right, R2.Bottom);
                end;

                // Draw Line |
                j := (R.Bottom - R.Top) div 2 - 2;
                Pt := Point(R2.Left + (R2.Right - R2.Left) div 2, R.Top + (R.Bottom - R.Top - j) div 2);
                Canvas.Pen.Color := BrClr;
                Canvas.MoveTo(pt.X, pt.Y);
                Canvas.LineTo(pt.X, pt.Y + j);
                //Canvas.Polygon(ptArrowB);
              end
              else // (Orientation = trVertical)
              begin
                Canvas.Pen.Color := BrOutClr;
                Canvas.Brush.Style := bsClear;
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Right, R2.Top);
                Canvas.MoveTo(R2.Left, R2.Bottom);
                Canvas.LineTo(R2.Right, R2.Bottom);
                if (TickMark.Position in [tmTopLeft, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowT[0].X, ptArrowT[0].Y);
                  Canvas.LineTo(PtArrowT[1].X, ptArrowT[1].Y);
                  Canvas.MoveTo(PtArrowT[1].X, ptArrowT[1].Y);
                  Canvas.LineTo(PtArrowT[2].X, ptArrowT[2].Y);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Left, R2.Bottom);
                end;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowB[0].X, ptArrowB[0].Y);
                  Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y);
                  Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y);
                  Canvas.LineTo(PtArrowB[2].X - 1, ptArrowB[2].Y - 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Right, R2.Top);
                  Canvas.LineTo(R2.Right, R2.Bottom + 1);
                end;

                InflateRect(R2, -1, -1);
                Canvas.Pen.Color := BrClr;
                Canvas.MoveTo(R2.Left, R2.Bottom);
                Canvas.LineTo(R2.Right + 1, R2.Bottom);
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Right + 1, R2.Top);
                if (TickMark.Position in [tmTopLeft, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowT[0].X, ptArrowT[0].Y - 1);
                  Canvas.LineTo(PtArrowT[1].X + 1, ptArrowT[1].Y);
                  Canvas.MoveTo(PtArrowT[1].X + 1, ptArrowT[1].Y);
                  Canvas.LineTo(PtArrowT[2].X + 1, ptArrowT[2].Y);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Left, R2.Bottom);
                end;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowB[0].X, ptArrowB[0].Y - 1);
                  Canvas.LineTo(PtArrowB[1].X - 1, ptArrowB[1].Y);
                  Canvas.MoveTo(PtArrowB[1].X - 1, ptArrowB[1].Y);
                  Canvas.LineTo(PtArrowB[2].X - 1, ptArrowB[2].Y);
                end
                else
                begin
                  Canvas.MoveTo(R2.Right, R2.Top);
                  Canvas.LineTo(R2.Right, R2.Bottom);
                end;

                InflateRect(R2, -1, -1);
                Canvas.Pen.Color := BrOutClr;
                j := 1;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                  j := 2;

                if (TickMark.Position = tmBottomRight) then
                begin
                  Canvas.MoveTo(R2.Left, R2.Bottom);
                  Canvas.LineTo(R2.Right + j, R2.Bottom);
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Right + j, R2.Top);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left - 1, R2.Bottom);
                  Canvas.LineTo(R2.Right + j, R2.Bottom);
                  Canvas.MoveTo(R2.Left - 1, R2.Top);
                  Canvas.LineTo(R2.Right + j, R2.Top);
                end;

                if (TickMark.Position in [tmTopLeft, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowT[0].X, ptArrowT[0].Y - 2);
                  Canvas.LineTo(PtArrowT[1].X + 2, ptArrowT[1].Y);
                  Canvas.MoveTo(PtArrowT[1].X + 2, ptArrowT[1].Y);
                  Canvas.LineTo(PtArrowT[2].X + 1, ptArrowT[2].Y + 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Left, R2.Top);
                  Canvas.LineTo(R2.Left, R2.Bottom);
                end;
                if (TickMark.Position in [tmBottomRight, tmBoth]) then
                begin
                  Canvas.MoveTo(PtArrowB[0].X, ptArrowB[0].Y - 2);
                  Canvas.LineTo(PtArrowB[1].X - 2, ptArrowB[1].Y);
                  Canvas.MoveTo(PtArrowB[1].X - 2, ptArrowB[1].Y);
                  Canvas.LineTo(PtArrowB[2].X - 1, ptArrowB[2].Y + 1);
                end
                else
                begin
                  Canvas.MoveTo(R2.Right, R2.Top);
                  Canvas.LineTo(R2.Right, R2.Bottom);
                end;

                // Draw Line |
                j := (R.Right - R.Left) div 2 - 3;
                Pt := Point(R.Left + ((R.Right - R.Left) - j + 1) div 2, R.Top + (R.Bottom - R.Top) div 2);
                Canvas.Pen.Color := BrClr;
                Canvas.MoveTo(pt.X, pt.Y);
                Canvas.LineTo(pt.X + j, pt.Y);
              end;
            end;

          end;
          tstCustom:  // Thumb.Shape = tsPointer // not using
          begin
            if (Clr <> clNone) and (ClrTo <> clNone) then
            begin
              if (ClrM <> clNone) and (ClrMTo <> clNone) then
              begin
                graphic.SetClip(Rgn);
                DrawVistaGradient(graphic, Canvas, R, bsRectangle, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Thumb.Gradient, Thumb.GradientMirror, Orientation);
                graphic.ResetClip();
              end
              else
              begin
                SelectClipRgn(Canvas.Handle, rgn3);
                DrawInOutGradient(Canvas, Clr, ClrTo, Thumb.Steps, R, GradDir);
                SelectClipRgn(Canvas.Handle, 0);
              end;
            end
            else if (Clr <> clNone) then
            begin
              SelectClipRgn(Canvas.Handle, rgn3);
              Canvas.Brush.Color := Clr;
              Canvas.FillRect(R);
              SelectClipRgn(Canvas.Handle, 0);
            end;

            if (BrClr <> clNone) then
            begin
              Canvas.Pen.Color := BrOutClr;
              Canvas.Brush.Style := bsClear;
              //Canvas.Rectangle(R);
              //R2.Right := R2.Right - 1;
              Canvas.MoveTo(R2.Left, R2.Top);
              Canvas.LineTo(R2.Left, R2.Bottom);
              Canvas.MoveTo(R2.Right, R2.Top);
              Canvas.LineTo(R2.Right, R2.Bottom+1);
              if (TickMark.Position in [tmTopLeft, tmBoth]) then
              begin
                Canvas.LineTo(PtArrowT[0].X, ptArrowT[0].Y);
                Canvas.LineTo(PtArrowT[1].X, ptArrowT[1].Y);
                Canvas.MoveTo(PtArrowT[1].X, ptArrowT[1].Y);
                Canvas.LineTo(PtArrowT[2].X, ptArrowT[2].Y);
              end
              else
              begin
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Right, R2.Top);
              end;
              if (TickMark.Position in [tmBottomRight, tmBoth]) then
              begin
                Canvas.MoveTo(PtArrowB[0].X, ptArrowB[0].Y);
                Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y);
                Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y);
                Canvas.LineTo(PtArrowB[2].X, ptArrowB[2].Y);
              end
              else
              begin
                Canvas.MoveTo(R2.Left, R2.Bottom);
                Canvas.LineTo(R2.Right, R2.Bottom);
              end;

              InflateRect(R2, -1, -1);
              Canvas.Pen.Color := BrClr;
              Canvas.MoveTo(R2.Left, R2.Top);
              Canvas.LineTo(R2.Left, R2.Bottom + 1);
              Canvas.MoveTo(R2.Right, R2.Top);
              Canvas.LineTo(R2.Right, R2.Bottom+1);
              if (TickMark.Position in [tmTopLeft, tmBoth]) then
              begin
                Canvas.MoveTo(PtArrowT[0].X + 1, ptArrowT[0].Y - 1);
                Canvas.LineTo(PtArrowT[1].X + 1, ptArrowT[1].Y - 1);
                Canvas.MoveTo(PtArrowT[1].X + 1, ptArrowT[1].Y - 1);
                Canvas.LineTo(PtArrowT[2].X + 1, ptArrowT[2].Y - 1);
              end
              else
              begin
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Right, R2.Top);
              end;
              if (TickMark.Position in [tmBottomRight, tmBoth]) then
              begin
                Canvas.MoveTo(PtArrowB[0].X + 1, ptArrowB[0].Y);
                Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y - 1);
                Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y - 1);
                Canvas.LineTo(PtArrowB[2].X, ptArrowB[2].Y - 1);
              end
              else
              begin
                Canvas.MoveTo(R2.Left, R2.Bottom);
                Canvas.LineTo(R2.Right, R2.Bottom);
              end;

              InflateRect(R2, -1, -1);
              Canvas.Pen.Color := BrOutClr; //BlendColor(ClrTo, BrClr, 50);
              Canvas.MoveTo(R2.Left, R2.Top);
              Canvas.LineTo(R2.Left, R2.Bottom + 2);
              Canvas.MoveTo(R2.Right, R2.Top);
              Canvas.LineTo(R2.Right, R2.Bottom+2);
              if (TickMark.Position in [tmTopLeft, tmBoth]) then
              begin
                Canvas.MoveTo(PtArrowT[0].X + 2, ptArrowT[0].Y - 2);
                Canvas.LineTo(PtArrowT[1].X + 2, ptArrowT[1].Y - 2);
                Canvas.MoveTo(PtArrowT[1].X + 2, ptArrowT[1].Y - 2);
                Canvas.LineTo(PtArrowT[2].X + 2, ptArrowT[2].Y - 2);
              end
              else
              begin
                Canvas.MoveTo(R2.Left, R2.Top);
                Canvas.LineTo(R2.Right, R2.Top);
              end;
              if (TickMark.Position in [tmBottomRight, tmBoth]) then
              begin
                Canvas.MoveTo(PtArrowB[0].X + 2, ptArrowB[0].Y);
                Canvas.LineTo(PtArrowB[1].X, ptArrowB[1].Y - 2);
                Canvas.MoveTo(PtArrowB[1].X, ptArrowB[1].Y - 2);
                Canvas.LineTo(PtArrowB[2].X - 1, ptArrowB[2].Y - 1);
              end
              else
              begin
                Canvas.MoveTo(R2.Left, R2.Bottom);
                Canvas.LineTo(R2.Right, R2.Bottom);
              end;

            end;

            // Draw Line |
            j := (R.Bottom - R.Top) div 2 - 2;
            Pt := Point(R2.Left + (R2.Right - R2.Left) div 2, R.Top + (R.Bottom - R.Top - j) div 2);
            Canvas.Pen.Color := BrClr;
            Canvas.MoveTo(pt.X, pt.Y);
            Canvas.LineTo(pt.X, pt.Y + j);
          end;
        end;

        DeleteObject(rgn1);
        DeleteObject(rgn2);
        DeleteObject(rgn3);

        Rgn.Free;
        graphic.Free;
      end;
      {tsRectangle:
      begin
        case Thumb.Style of
          tstOffice2007:
          begin
            //DrawGradient(Canvas, Clr, ClrTo, Thumb.Steps, R, Thumb.Direction = gdHorizontal);
            if (BrClr <> clNone) then
            begin
              Canvas.Pen.Color := BlendColor(ClrTo, clWhite, 50);
              Canvas.Brush.Style := bsClear;
              Canvas.Rectangle(R);
              R2 := R;
              InflateRect(R2, -1, -1);
              Canvas.Pen.Color := BrClr;
              Canvas.Brush.Style := bsClear;
              Canvas.Rectangle(R);
              InflateRect(R2, -1, -1);
              Canvas.Pen.Color := clWhite;
              Canvas.Brush.Style := bsClear;
              Canvas.Rectangle(R);
            end;
          end;
          tstOffice2003:
          begin
          end;
          tstCustom:
          begin
          end;
        end;
      end;}
      tsRectangle, tsRoundRect:
      begin
        if (Thumb.Shape = tsRoundRect) then
          i := 8
        else
          i := 1;

        R2 := R;
        if (Orientation = trHorizontal) then
        begin
          if (TickMark.Position in [tmTopLeft, tmBoth]) then
          begin
          end
          else
          begin
          end;

          if (TickMark.Position in [tmBottomRight, tmBoth]) then
          begin
          end
          else
          begin
          end;
        end
        else // (Orientation = trVertical)
        begin
        end;

        graphic := TGPGraphics.Create(Canvas.Handle);
        path := CreateRoundRectangle(Rect(R.Left, R.Top, (R.Right - R.Left), (R.Bottom - R.Top)), i);
        Rgn := TGPRegion.Create(path);
        path.Free;

        rgn1 := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, i, i);

        case Thumb.Style of
          tstOffice2007:
          begin
            if (Clr <> clNone) and (ClrTo <> clNone) then
            begin
              if (ClrM <> clNone) and (ClrMTo <> clNone) then
              begin
                graphic.SetClip(Rgn);
                //DrawVistaGradient(graphic, Canvas, R, bsRectangle, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Thumb.Gradient, Thumb.GradientMirror, Orientation);
                if (Orientation = trHorizontal) then
                  R2 := Rect(R.Left, R.Top, R.Right-1, R.Bottom-1)
                else // (Orientation = trVertical)
                  R2 := Rect(R.Left, R.Top, R.Right-1, R.Bottom-1);
                  
                DrawVistaGradient(graphic, Canvas, R2, bsRectangle, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Thumb.Gradient, Thumb.GradientMirror, Orientation);
                graphic.ResetClip();
              end
              else
              begin
                SelectClipRgn(Canvas.Handle, rgn1);
                DrawInOutGradient(Canvas, Clr, ClrTo, Thumb.Steps, R, GradDir);
                SelectClipRgn(Canvas.Handle, 0);
              end;
            end
            else if (Clr <> clNone) then
            begin
              SelectClipRgn(Canvas.Handle, rgn1);
              Canvas.Brush.Color := Clr;
              Canvas.FillRect(R);
              SelectClipRgn(Canvas.Handle, 0);
            end;

            if (BrClr <> clNone) then
            begin
              Canvas.Pen.Color := BrOutClr;
              Canvas.Brush.Style := bsClear;
              Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, i, i);
              R2 := R;
              InflateRect(R2, -1, -1);
              Canvas.Pen.Color := BrClr;
              Canvas.RoundRect(R2.Left, R2.Top, R2.Right, R2.Bottom, i, i);

              if (Thumb.Shape = tsRectangle) then
              begin
                InflateRect(R2, -1, -1);
                Canvas.Pen.Color := BrOutClr; //BlendColor(ClrTo, BrClr, 50);
                Canvas.Rectangle(R2);
              end;
            end;

            // Draw Line |
            if (Orientation = trHorizontal) then
            begin
              j := (R.Bottom - R.Top) div 2 - 2;
              Pt := Point(R.Left + (R.Right - R.Left) div 2, R.Top + (R.Bottom - R.Top - j) div 2);
              Canvas.Pen.Color := BrClr;
              Canvas.MoveTo(pt.X, pt.Y);
              Canvas.LineTo(pt.X, pt.Y + j);
            end
            else // (Orientation = trVertical)
            begin
              j := (R.Right - R.Left) div 2 - 2;
              Pt := Point(R.Left + (R.Right - R.Left - j) div 2, R.Top + (R.Bottom - R.Top) div 2);
              Canvas.Pen.Color := BrClr;
              Canvas.MoveTo(pt.X, pt.Y);
              Canvas.LineTo(pt.X + j, pt.Y);
            end;

          end;
          tstCustom:    // RoundRect
          begin

          end;
        end;

        DeleteObject(rgn1);

        Rgn.Free;
        graphic.Free;
      end;
      tsRound:
      begin
        //BrOutClr := BlendColor(BrClr, clWhite, 30);
        if (Orientation = trHorizontal) then
        begin
          i := Thumb.Size div 2;
          R2 := Rect(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);
          if (TickMark.Position in [tmTopLeft, tmBoth]) then
          begin
          end
          else
          begin
          end;

          if (TickMark.Position in [tmBottomRight, tmBoth]) then
          begin
          end
          else
          begin
          end;
        end
        else // (Orientation = trVertical)
        begin
          i := Thumb.Size div 2;
          R2 := Rect(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);
        end;

        graphic := TGPGraphics.Create(Canvas.Handle);
        path := CreateRoundRectangle(R2, i);
        Rgn := TGPRegion.Create(path);
        path.Free;

        rgn1 := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, i, i);

        case Thumb.Style of
          tstOffice2007:
          begin
            if (Clr <> clNone) and (ClrTo <> clNone) then
            begin
              if (ClrM <> clNone) and (ClrMTo <> clNone) then
              begin
                graphic.SetClip(Rgn);
                DrawVistaGradient(graphic, Canvas, R, bsRound, BrOutClr, BrClr, Clr, ClrTo, ClrM, ClrMTo, Thumb.Gradient, Thumb.GradientMirror, Orientation);
                graphic.ResetClip();
              end
              else
              begin
                SelectClipRgn(Canvas.Handle, rgn1);
                DrawInOutGradient(Canvas, Clr, ClrTo, Thumb.Steps, R, GradDir);
                SelectClipRgn(Canvas.Handle, 0);
              end;
            end
            else if (Clr <> clNone) then
            begin
              SelectClipRgn(Canvas.Handle, rgn1);
              Canvas.Brush.Color := Clr;
              Canvas.FillRect(R);
              SelectClipRgn(Canvas.Handle, 0);
            end;

            //DrawVistaBorder(graphic, R, bsRound, BrOutClr, BrClr, Orientation);
            // Draw center point
            //j := (R.Bottom - R.Top) div 2 - 2;
            Pt := Point(R.Left + (R.Right - R.Left) div 2 + 1, R.Top + (R.Bottom - R.Top) div 2 + 1);
            R2 := Rect(Pt.X - 2, Pt.Y - 2, Pt.X + 2, Pt.Y + 2);
            //Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := BrClr;
            Canvas.RoundRect(R2.Left, R2.Top, R2.Right, R2.Bottom, 5, 5);
          end;
          tstCustom:    // tsRound //not using
          begin
            if (Clr <> clNone) and (ClrTo <> clNone) then
            begin
              if (ClrM <> clNone) and (ClrMTo <> clNone) then
              begin
                graphic.SetClip(Rgn);
                DrawVistaGradient(graphic, Canvas, R, bsRectangle, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Thumb.Gradient, Thumb.GradientMirror, Orientation);
                graphic.ResetClip();
              end
              else
              begin
                SelectClipRgn(Canvas.Handle, rgn1);
                DrawInOutGradient(Canvas, Clr, ClrTo, Thumb.Steps, R, GradDir{Thumb.Gradient <> ggVertical});
                SelectClipRgn(Canvas.Handle, 0);
              end;
            end
            else if (Clr <> clNone) then
            begin
              SelectClipRgn(Canvas.Handle, rgn1);
              Canvas.Brush.Color := Clr;
              Canvas.FillRect(R);
              SelectClipRgn(Canvas.Handle, 0);
            end;

            if (BrClr <> clNone) then
            begin
              Canvas.Pen.Color := BrOutClr;
              Canvas.Brush.Style := bsClear;
              Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, i, i);
              R2 := R;
              InflateRect(R2, -1, -1);
              Canvas.Pen.Color := BrClr;
              Canvas.RoundRect(R2.Left, R2.Top, R2.Right, R2.Bottom, i, i);
            end;

          end;
        end;

        DeleteObject(rgn1);

        Rgn.Free;
        graphic.Free;
      end;
      tsLine:
      begin
        case Thumb.Style of
          tstOffice2007:
          begin
            if (Orientation = trHorizontal) then
            begin
              i := (R.Right - R.Left) div 2;
              Canvas.Pen.Color := ClrTo;
              Canvas.MoveTo(R.Left + i- 1, R.Top);
              Canvas.LineTo(R.Left + i- 1, R.Bottom);
              Canvas.Pen.Color := Clr;
              Canvas.MoveTo(R.Left + i, R.Top);
              Canvas.LineTo(R.Left + i, R.Bottom);
              Canvas.Pen.Color := BlendColor(Clr, BrOutClr, 60);;
              Canvas.MoveTo(R.Left + i + 1, R.Top);
              Canvas.LineTo(R.Left + i + 1, R.Bottom);
              Canvas.Pen.Color := BlendColor(Clr, BrOutClr, 10);
              Canvas.MoveTo(R.Left + i + 2, R.Top);
              Canvas.LineTo(R.Left + i + 2, R.Bottom);
            end
            else // (Orientation = trVertical)
            begin
              i := (R.Bottom - R.Top) div 2;
              Canvas.Pen.Color := ClrTo;
              Canvas.MoveTo(R.Left, R.Top + i- 1);
              Canvas.LineTo(R.Right, R.Top + i- 1);
              Canvas.Pen.Color := Clr;
              Canvas.MoveTo(R.Left, R.Top + i);
              Canvas.LineTo(R.Right, R.Top + i);
              Canvas.Pen.Color := BlendColor(Clr, BrOutClr, 60);;
              Canvas.MoveTo(R.Left, R.Top + i + 1);
              Canvas.LineTo(R.Right, R.Top + i + 1);
              Canvas.Pen.Color := BlendColor(Clr, BrOutClr, 10);
              Canvas.MoveTo(R.Left, R.Top + i + 2);
              Canvas.LineTo(R.Left, R.Top + i + 2);
            end;
          end;
          tstCustom:
          begin
          end;
        end;
      end;
    end;
  end;

end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.Change;
begin
	if Assigned(FOnChange) then
    FOnChange(Self);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DoEnter;
begin
	inherited DoEnter;
  Refresh;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DoExit;
begin
	inherited DoExit;
  Refresh;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.KeyDown(var Key:Word; Shift:TShiftState);
begin
	inherited KeyDown(Key,Shift);
  
  case Key of
  	vk_Prior:	Position := FPosition + FPageSize;
    vk_Next: Position := FPosition - FPageSize;
    vk_End:
    begin
      if (FOrientation = trVertical) then
	      Position := FMin
      else
        Position := FMax;
    end;
    vk_Home:
    begin
      if (FOrientation = trVertical) then
        Position := FMax
      else
        Position := FMin;
    end;
    vk_Left,vk_Down:
    begin
      if (FPosition > FMin) then
        Position := FPosition - 1;
    end;
		vk_Right,vk_Up:
    begin
      if (FPosition < FMax) then
        Position := FPosition + 1;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.MouseDown(Button: TMouseButton; Shift:TShiftState; X, Y: Integer);
var
  R: TRect;
	PtX, ptY: Integer;
  d: Double;
  pt: TPoint;
begin
	inherited MouseDown(Button, Shift, X, Y);

  if not Focused then
    Self.SetFocus;

  pt := Point(X, Y);
  if (Button = mbLeft) and not IsRating then
  begin
  	if PtInRect(ThumbRect, Point(X,Y)) then
    begin
      FSliding := True;
      FThumbDown := True;
      DrawThumb;
    end
  	else if PtInRect(TrackingRect, Point(X,Y)) then
    begin
      R := TrackClientRect;
      if (Orientation = trHorizontal) then
      begin
      	d := ((R.Right - R.Left) - Thumb.Width) / (FMax - FMin);
        PtX	:= R.Left + Trunc(d * ((FPosition) - FMin));
        if X < PtX then
        	Position := FPosition - FPageSize
        else
        begin
        	Position := FPosition + FPageSize;
        end;
      end
      else // (Orientation = trVertical)
      begin
      	d := ((R.Bottom - R.Top) - FThumb.Width) / (FMax - FMin);
        //PtY	:=	R.Top + Trunc(d * ((FMax - FPosition) - FMin)) + BorderWidth;
        PtY	:=	R.Bottom - Trunc(d * ((FPosition) - FMin));
        if Y < PtY then
        	Position := FPosition + FPageSize
        else
        begin
        	Position := FPosition - FPageSize
        end;
      end;
      
    end
    else if Buttons.Visible then
    begin

      if PtInRect(MinButtonRect, Pt) then
      begin
        if not FMinButtonDown then
        begin
          FMinButtonDown := True;
          DrawMinButton;

          if Buttons.RepeatClick then
          begin
            if FRepeatTimer = nil then
              FRepeatTimer := TTimer.Create(Self);

            FRepeatTimer.OnTimer := RepeatTimerExpired;
            FRepeatTimer.Interval := Buttons.InitRepeatPause;
            FRepeatTimer.Enabled  := True;
          end;
        end;
      end;

      if PtInRect(MaxButtonRect, Pt) then
      begin
        if not FMaxButtonDown then
        begin
          FMaxButtonDown := True;
          DrawMaxButton;

          if Buttons.RepeatClick then
          begin
            if FRepeatTimer = nil then
              FRepeatTimer := TTimer.Create(Self);

            FRepeatTimer.OnTimer := RepeatTimerExpired;
            FRepeatTimer.Interval := Buttons.InitRepeatPause;
            FRepeatTimer.Enabled  := True;
          end;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.MouseMove(Shift:TShiftState; X,Y:Integer);
var
	P, W, H: Integer;
  R: TRect;
  Pt, Pt2: TPoint;
  S: string;
begin
	inherited MouseMove(Shift, X, Y);

  Pt := Point(X, Y);
  if not IsRating then
  begin
    if FSliding then
    begin
      R := TrackClientRect;
      if (Orientation = trHorizontal) then
      begin
        W	:= (R.Right - R.Left) - (Thumb.Width div 2);
        P	:= Round((((X - R.Left) - (Thumb.Width div 2)) / W) * (FMax - FMin) + FMin);
      end
      else // Orientation = trVertical
      begin
        H	:= (R.Bottom - R.Top) - (Thumb.Width div 2);
        P	:= Round(((H - Y + R.Top) / H) * (FMax - FMin) + FMin);
      end;

      if (P > FMax) then
        P := FMax;
      if (P < FMin) then
        P := FMin;

      if (P <> Position) and TrackHint and (P <> FHintTickIndex) then
      begin
        FHintTickIndex := P;

        s := InttoStr(P);
        if Assigned(FOnGetTrackHint) then
          FOnGetTrackHint(self, P, S);

        r := FTrackHintWnd.CalcHinTRect(100, s, Nil);
        FTrackHintWnd.Caption := s;
        FTrackHintWnd.Color := clInfoBk; //FHintColor;

        GetCursorPos(pt2);
        r.Left := r.Left + pt2.x + 10;
        r.Right := r.Right + pt2.x + 10;
        r.Top := r.Top + pt2.y;
        r.Bottom := r.Bottom + pt2.y;

        FTrackHintWnd.ActivateHint(r, s);
        FTrackHintShow := True;
      end;

      Position	:=	P;
    end
    else
    begin
      if Buttons.Visible then
      begin
        if PtInRect(MinButtonRect, Pt) then
        begin
          if not FMinButtonHot then
          begin
            FMinButtonHot := True;
            DrawMinButton;
          end;
        end
        else if FMinButtonHot then
        begin
          FMinButtonHot := False;
          FMinButtonDown := False;
          DrawMinButton;
        end;

        if PtInRect(MaxButtonRect, Pt) then
        begin
          if not FMaxButtonHot then
          begin
            FMaxButtonHot := True;
            DrawMaxButton;
          end;
        end
        else if FMaxButtonHot then
        begin
          FMaxButtonHot := False;
          FMaxButtonDown := False;
          DrawMaxButton;
        end;
      end;

      if PtInRect(ThumbRect, Pt) then
      begin
        if not FThumbHot then
        begin
          FThumbHot := True;
          DrawThumb;
        end;
      end
      else if FThumbHot then
      begin
        FThumbHot := False;
        FThumbDown := False;
        DrawThumb;
      end;

      {i := IndexOfTickAt(X, Y);
      if (i >= FMin) then
      begin
        if (i <> FHintTickIndex) then
        begin
          FHintTickIndex := i;
          Application.CancelHint;
        end;
      end
      else if (FHintTickIndex >= FMin) then
      begin
        FHintTickIndex := -1;
        Application.CancelHint;
      end;}
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  R: TRect;
  pt: TPoint;
begin
	inherited MouseUp(Button, Shift, X, Y);

  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;

  pt := Point(X, Y);
  if IsRating then
  begin
    if (Button = mbLeft) then
    begin
      i := IndexOfRate(X, Y);
      if (i >= 0) then
      begin
        Position := i;
      end
      else
      begin
        R := RateRect(FMin + 1);
        if (X >= R.Left - 4) and (X < R.Left) and (Y >= R.Top) and (Y <= R.Bottom) then
          Position := FMin;
      end;
    end;
  end
  else
  begin
    if (Button = mbLeft) then
    begin
      if FTrackHintShow then
      begin
        FTrackHintWnd.ReleaseHandle;
        FTrackHintShow := False;
      end;

      FSliding := False;
      if FThumbDown then
      begin
        FThumbDown := False;
        if FThumbHot and not PtInRect(ThumbRect, Pt) then
          FThumbHot := False;
        DrawThumb;
      end;

      if Buttons.Visible then
      begin
        if PtInRect(MinButtonRect, Pt) then
        begin
          if FMinButtonDown then
          begin
            FMinButtonDown := False;
            DrawMinButton;
            ClickMinButton;
          end;
        end;

        if PtInRect(MaxButtonRect, Pt) then
        begin
          if FMaxButtonDown then
          begin
            FMaxButtonDown := False;
            DrawMaxButton;
            ClickMaxButton;
          end;
        end;
      end;

    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.WMGetDlgCode(var Msg:TWMGetDlgCode);
begin
	inherited;
  Msg.Result := dlgc_WantArrows;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.WMSize(var Msg:TWMSize);
begin
	inherited;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.CMEnabledChanged(var Msg:TMessage);
begin
	inherited;
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetBorderColor(const Value: TColor);
begin
  if (FBorderColor <> Value) then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetBorderColorDisabled(const Value: TColor);
begin
  if (FBorderColorDisabled <> Value) then
  begin
    FBorderColorDisabled := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetColorDisabled(const Value: TColor);
begin
  if (FColorDisabled <> Value) then
  begin
    FColorDisabled := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetColorDisabledTo(const Value: TColor);
begin
  if (FColorDisabledTo <> Value) then
  begin
    FColorDisabledTo := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetColorTo(const Value: TColor);
begin
  if (FColorTo <> Value) then
  begin
    FColorTo := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetDirection(const Value: TGradientDirection);
begin
  if (FDirection <> Value) then
  begin
    FDirection := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetBackGround(const Value: TGDIPPicture);
begin
  FIBackGround.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.BackGroundChanged(Sender: TObject);
begin
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetTransparent(const Value: Boolean);
begin
  if (FTransparent <> Value) then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.OnSliderChanged(Sender: TObject);
begin
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.OnThumbChanged(Sender: TObject);
begin
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.OnTickMarkChanged(Sender: TObject);
var
  w: Integer;
begin
  TextSize(Canvas, FTickMark.Font, 'gh', FTextHeight, w);
  FTextHeight := FTextHeight + (FTickTextOffset * 2);

  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if Transparent then
    Message.Result := 1;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.IsRating: Boolean;
begin
  Result := not RateActive.Empty and not RateInActive.Empty;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.IndexOfRate(X, Y: Integer): Integer;
var
  i: Integer;
  R: TRect;
  p: TPoint;
begin
  Result := -1;
  p := Point(X, Y);
  for i := FMin + 1 to FMax do
  begin
    R := RateRect(i);
    if PtInRect(R, p) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.RateRect(Index: Integer): TRect;
var
  S: TSize;
  i, x, y, sp: Integer;
  R: TRect;
begin
  Result := Rect(-1, -1, -1, -1);
  if IsRating then
  begin
    R := TrackClientRect;
    s := RateSize;
    x := R.Left;
    y := R.Top;
    sp := 0;    // space between rates/images

    for i := FMin + 1 to Index do
    begin
      if (i = Index) then
      begin
        Result := Rect(x, y, x + s.cx, y + s.cy);
        Break;
      end;
      
      x := x + s.cx + sp;
      if (x + s.cx > R.Right) then
      begin
        x := R.Left;
        y := y + s.cy + sp;
      end;

      //y := y + s.cy + sp;
      if (y > R.Bottom) then
      begin
        Break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.RateSize: TSize;
begin
  Result.cx := 0;
  Result.cy := 0;
  if not RateActive.Empty then
  begin
    RateActive.GetImageSizes;
    Result.cx := RateActive.Width;
    Result.cy := RateActive.Height;
  end;

  if not RateInActive.Empty then
  begin
    RateInActive.GetImageSizes;
    Result.cx := Math.Max(Result.cx, RateInActive.Width);
    Result.cy := Math.Max(Result.cy, RateInActive.Height);
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawRate(Index: Integer);
var
  R: TRect;
begin
  if not IsRating or (Index <= FMin) then
    Exit;

  R := RateRect(Index);
  if (R.Left > 0) and (R.Bottom > 0) then
  begin
    if (Index <= Position) then // RateActive
    begin
      if not RateActive.Empty then
      begin
        RateActive.Transparent := True;
        Canvas.Draw(R.Left, R.Top, RateActive);
      end;
    end
    else
    begin
      if not RateInActive.Empty then
      begin
        RateInActive.Transparent := True;
        Canvas.Draw(R.Left, R.Top, RateInActive);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawRates;
var
  i: Integer;
begin
  if not IsRating then
    Exit;
    
  for i := FMin + 1 to FMax do
    DrawRate(i);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetSlider(const Value: TTrackBarSlider);
begin
  FSlider.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetThumb(const Value: TTrackBarThumb);
begin
  FThumb.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetTickMark(const Value: TTrackBarTick);
begin
  FTickMark.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetImages(const Value: TCustomImageList);
begin
  if (FImages <> Value) then
  begin
    FImages := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.Loaded;
begin
  inherited;
  OnTickMarkChanged(FTickMark);
  Buttons.PictureChanged(Buttons);
  Thumb.PictureChanged(Thumb);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if not (csDestroying in ComponentState) and (Operation = opRemove) then
  begin
    if (AComponent = TickImages) then
    begin
      TickImages := nil;
      Invalidate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetRateActive(const Value: TGDIPPicture);
begin
  FIRateActive.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetRateInActive(const Value: TGDIPPicture);
begin
  FIRateInActive.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.OnRatePictureChanged(Sender: TObject);
begin
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetBackGroundDisabled(const Value: TGDIPPicture);
begin
  FIBackGroundDisabled.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetButtons(const Value: TTrackBarButtons);
begin
  FButtons.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.OnButtonsChanged(Sender: TObject);
begin
  Invalidate;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawButtons;
begin
  if not IsRating and Buttons.FVisible then
  begin
    DrawMinButton;
    DrawMaxButton;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawMaxButton;
var
  R, R2, R3, R4: TRect;
  OuterBrClr: TColor;
  BrClr, Clr, ClrTo, ClrM, ClrMTo: TColor;
  graphic: TGPGraphics;
  h: Integer;
  Pic: TGDIPPicture;
  path: TGPGraphicsPath;
  Rgn: TGPRegion;
  rgn1: HRGN;
begin
  if not IsRating and Buttons.FVisible then
  begin
    R := MaxButtonRect;

    with Buttons do
    begin
      if FMaxButtonDown then
      begin
        BrClr := BorderColorDown;
        Clr := ColorDown;
        ClrTo := ColorDownTo;
        ClrM := ColorMirrorDown;
        ClrMTo := ColorMirrorDownTo;
        Pic := MaxPictureDown;
      end
      else if FMaxButtonHot then
      begin
        BrClr := BorderColorHot;
        Clr := ColorHot;
        ClrTo := ColorHotTo;
        ClrM := ColorMirrorHot;
        ClrMTo := ColorMirrorHotTo;
        Pic := MaxPictureHot;
      end
      else
      begin
        BrClr := BorderColor;
        Clr := Color;
        ClrTo := ColorTo;
        ClrM := ColorMirror;
        ClrMTo := ColorMirrorTo;
        Pic := MaxPicture;
      end;
    end;

    if not Pic.Empty then
    begin
      Pic.GetImageSizes;
      if (Orientation = trHorizontal) then
      begin
        {if (Pic.Width > Buttons.Size) then
          h := R.Right - Pic.Width
        else}
          h := R.Left;
        rgn1 := CreateRectRgn(R.Left, R.Top, R.Right, R.Bottom);
        SelectClipRgn(Canvas.Handle, rgn1);

        Canvas.Draw(h, R.Top, Pic);

        SelectClipRgn(Canvas.Handle, 0);
        DeleteObject(rgn1);
      end
      else // (Orientation = trVertical
      begin
        if (Pic.Height > Buttons.Size) then
          h := R.Bottom - Pic.Width
        else
          h := R.Top;
        Canvas.Draw(R.Left, h, Pic);
      end;
    end
    else
    begin
      OuterBrClr := BlendColor(BrClr, clWhite, 30);

      graphic := TGPGraphics.Create(Canvas.Handle);

      case (Buttons.Shape) of
        bsRound:
        begin
          if (Orientation = trHorizontal) then
          begin
            h := R.Top + ((R.Bottom - R.Top) - Buttons.Size) div 2;
            R2 := Rect(R.Left, h, Buttons.Size, Buttons.Size);
            R3 := Rect(R.Left, h, R.Right, h + Buttons.Size);
          end
          else // (Orientation = trVertical
          begin
            h := R.Left + ((R.Right - R.Left) - Buttons.Size) div 2;
            R2 := Rect(h, R.Top, Buttons.Size, Buttons.Size);
            R3 := Rect(h, R.Top, h + Buttons.Size, R.Bottom);
          end;

          path := CreateRoundRectangle(R2, Buttons.Size div 2);
          Rgn := TGPRegion.Create(path);
          graphic.SetClip(Rgn);
          path.Free;

          DrawVistaGradient(graphic, Canvas, R3, Buttons.Shape, OuterBrClr, BrClr, Clr, ClrTo, ClrM, ClrMTo, Buttons.Gradient, Buttons.GradientMirror, Orientation);

          if Assigned(Rgn) then
          begin
            graphic.ResetClip();
            Rgn.Free;
          end;
        end;
        bsRectangle:
        begin
          if (Orientation = trHorizontal) then
          begin
            R2 := Rect(R.Left, R.Top, Buttons.Size, Buttons.Size);
            R3 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          end
          else // (Orientation = trVertical
          begin
            R2 := Rect(R.Left, R.Top, Buttons.Size, Buttons.Size);
            R3 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          end;

          DrawVistaGradient(graphic, Canvas, R3, Buttons.Shape, OuterBrClr, BrClr, Clr, ClrTo, ClrM, ClrMTo, Buttons.Gradient, Buttons.GradientMirror, Orientation);
        end;
        (*bsConcave:
        begin
          if (Orientation = trHorizontal) then
          begin
            h := R.Top + ((R.Bottom - R.Top) - Buttons.Width) div 2;
            R2 := Rect(R.Left, h, Buttons.Width, Buttons.Width);
            R3 := Rect(R.Left, h, R.Right, h + Buttons.Width);
          end
          else // (Orientation = trVertical
          begin
            R2 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          end;

          {path := CreateConcaveRectangle(R3, False);
          gppen := TGPPen.Create(ColorToARGB(clWhite));
          graphic.DrawPath(gppen, path);
          gppen.Free;
          path.Free;}

          path := CreateConcaveRectangle(R2, False);
          Rgn := TGPRegion.Create(path);
          graphic.SetClip(Rgn);
          path.Free;

          DrawVistaGradient(graphic, Canvas, R3, Buttons.Shape, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Buttons.Gradient, Buttons.GradientMirror, Orientation);
          if Assigned(Rgn) then
          begin
            graphic.ResetClip();
            Rgn.Free;
          end;

          DrawConcaveRectangle(graphic, R3, False, BrClr);
        end; *)
      end;

      // Draw Plus ( + )
      if (Orientation = trHorizontal) then
      begin
          { - }
        h := Buttons.Size div 2 - 4;
        h := h + (h mod 2);
        R4.Left := R3.Left - 1 + (Buttons.Size - h) div 2;
        R4.Right := R4.Left + h + 4;
        R4.Top := R3.Top + ((R3.Bottom - R3.Top)) div 2 - 1;
        R4.Bottom := R4.Top + 4;
        Canvas.Pen.Color := Clr;
        Canvas.Rectangle(R4);
        Canvas.Pen.Color := BrClr;
        Canvas.MoveTo(R4.Left + 1, R4.Top + 1);
        Canvas.LineTo(R4.Right - 1, R4.Top + 1);
        Canvas.MoveTo(R4.Left + 1, R4.Top + 2);
        Canvas.LineTo(R4.Right - 1, R4.Top + 2);
          { | }
        R4.Left := R3.Left + 1 + (Buttons.Size - 4) div 2;
        R4.Right := R4.Left + 3;
        R4.Top := R3.Top + ((R3.Bottom - R3.Top) - h - 2) div 2;
        R4.Bottom := R4.Top + h + 2;
        Canvas.Pen.Color := Clr;
        //Canvas.Rectangle(R4);
        Canvas.MoveTo(R4.Left, R4.Top);
        Canvas.LineTo(R4.Left, R4.Bottom - h div 2 - 1);
        Canvas.MoveTo(R4.Right, R4.Top);
        Canvas.LineTo(R4.Right, R4.Bottom - h div 2 - 1);

        Canvas.MoveTo(R4.Left, R4.Top + (h div 2) + 4);
        Canvas.LineTo(R4.Left, R4.Bottom + 2);
        Canvas.MoveTo(R4.Right, R4.Top + (h div 2) + 4);
        Canvas.LineTo(R4.Right, R4.Bottom + 2);

        Canvas.MoveTo(R4.Left, R4.Top);
        Canvas.LineTo(R4.Right, R4.Top);
        Canvas.MoveTo(R4.Left, R4.Bottom + 1);
        Canvas.LineTo(R4.Right, R4.Bottom + 1);

        Canvas.Pen.Color := BrClr;
        Canvas.MoveTo(R4.Left + 1, R4.Top + 1);
        Canvas.LineTo(R4.Left + 1, R4.Bottom + 1);
        Canvas.MoveTo(R4.Left + 2, R4.Top + 1);
        Canvas.LineTo(R4.Left + 2, R4.Bottom + 1);
      end
      else // (Orientation = trVertical
      begin
          { - }
        h := Buttons.Size div 2 - 4;
        h := h + (h mod 2);
        R4.Left := R3.Left - 1 + ((R3.Right - R3.Left) - h) div 2;
        R4.Right := R4.Left + h + 4;
        R4.Top := R3.Top + ((R3.Bottom - R3.Top)) div 2 - 1;
        R4.Bottom := R4.Top + 4;
        Canvas.Pen.Color := Clr;
        Canvas.Rectangle(R4);
        Canvas.Pen.Color := BrClr;
        Canvas.MoveTo(R4.Left + 1, R4.Top + 1);
        Canvas.LineTo(R4.Right - 1, R4.Top + 1);
        Canvas.MoveTo(R4.Left + 1, R4.Top + 2);
        Canvas.LineTo(R4.Right - 1, R4.Top + 2);
          { | }
        R4.Left := R3.Left + 1 + ((R3.Right - R3.Left) - 4) div 2;
        R4.Right := R4.Left + 3;
        R4.Top := R3.Top + ((R3.Bottom - R3.Top) - h - 2) div 2;
        R4.Bottom := R4.Top + h + 2;
        Canvas.Pen.Color := Clr;
        //Canvas.Rectangle(R4);
        Canvas.MoveTo(R4.Left, R4.Top);
        Canvas.LineTo(R4.Left, R4.Bottom - h div 2 - 1);
        Canvas.MoveTo(R4.Right, R4.Top);
        Canvas.LineTo(R4.Right, R4.Bottom - h div 2 - 1);

        Canvas.MoveTo(R4.Left, R4.Top + (h div 2) + 4);
        Canvas.LineTo(R4.Left, R4.Bottom + 2);
        Canvas.MoveTo(R4.Right, R4.Top + (h div 2) + 4);
        Canvas.LineTo(R4.Right, R4.Bottom + 2);

        Canvas.MoveTo(R4.Left, R4.Top);
        Canvas.LineTo(R4.Right, R4.Top);
        Canvas.MoveTo(R4.Left, R4.Bottom + 1);
        Canvas.LineTo(R4.Right, R4.Bottom + 1);

        Canvas.Pen.Color := BrClr;
        Canvas.MoveTo(R4.Left + 1, R4.Top + 1);
        Canvas.LineTo(R4.Left + 1, R4.Bottom + 1);
        Canvas.MoveTo(R4.Left + 2, R4.Top + 1);
        Canvas.LineTo(R4.Left + 2, R4.Bottom + 1);
      end;

      graphic.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.DrawMinButton;
var
  R, R2, R3, R4: TRect;
  OuterBrClr: TColor;
  BrClr, Clr, ClrTo, ClrM, ClrMTo: TColor;
  graphic: TGPGraphics;
  h: Integer;
  Pic: TGDIPPicture;
  path: TGPGraphicsPath;
  Rgn: TGPRegion;
  rgn1: HRGN;
begin
  if not IsRating and Buttons.FVisible then
  begin
    R := MinButtonRect;

    with Buttons do
    begin
      if FMinButtonDown then
      begin
        BrClr := BorderColorDown;
        Clr := ColorDown;
        ClrTo := ColorDownTo;
        ClrM := ColorMirrorDown;
        ClrMTo := ColorMirrorDownTo;
        Pic := MinPictureDown;
      end
      else if FMinButtonHot then
      begin
        BrClr := BorderColorHot;
        Clr := ColorHot;
        ClrTo := ColorHotTo;
        ClrM := ColorMirrorHot;
        ClrMTo := ColorMirrorHotTo;
        Pic := MinPictureHot;
      end
      else
      begin
        BrClr := BorderColor;
        Clr := Color;
        ClrTo := ColorTo;
        ClrM := ColorMirror;
        ClrMTo := ColorMirrorTo;
        Pic := MinPicture;
      end;
    end;

    if not Pic.Empty then
    begin
      Pic.GetImageSizes;
      if (Orientation = trHorizontal) then
      begin
        {if (Pic.Width > Buttons.Size) then
          h := R.Right - Pic.Width
        else}
          h := R.Left;
        rgn1 := CreateRectRgn(R.Left, R.Top, R.Right, R.Bottom);
        SelectClipRgn(Canvas.Handle, rgn1);

        Canvas.Draw(h, R.Top, Pic);

        SelectClipRgn(Canvas.Handle, 0);
        DeleteObject(rgn1);
      end
      else // (Orientation = trVertical
      begin
        Canvas.Draw(R.Left, R.Top, Pic);
      end;
    end
    else
    begin
      OuterBrClr := BlendColor(BrClr, clWhite, 30);

      graphic := TGPGraphics.Create(Canvas.Handle);
      
      case (Buttons.Shape) of
        bsRound:
        begin
          if (Orientation = trHorizontal) then
          begin
            h := R.Top + ((R.Bottom - R.Top) - Buttons.Size) div 2;
            R2 := Rect(R.Left, h, Buttons.Size, Buttons.Size);
            R3 := Rect(R.Left, h, R.Right, h + Buttons.Size);
          end
          else // (Orientation = trVertical
          begin
            h := R.Left + ((R.Right - R.Left) - Buttons.Size) div 2;
            R2 := Rect(h, R.Top, Buttons.Size, Buttons.Size);
            R3 := Rect(h, R.top, h + Buttons.Size, R.Bottom);
          end;

          path := CreateRoundRectangle(R2, Buttons.Size div 2);
          Rgn := TGPRegion.Create(path);
          graphic.SetClip(Rgn);
          path.Free;

          DrawVistaGradient(graphic, Canvas, R3, Buttons.Shape, OuterBrClr, BrClr, Clr, ClrTo, ClrM, ClrMTo, Buttons.Gradient, Buttons.GradientMirror, Orientation);

          if Assigned(Rgn) then
          begin
            graphic.ResetClip();
            Rgn.Free;
          end;
        end;
        bsRectangle:
        begin
          if (Orientation = trHorizontal) then
          begin
            R2 := Rect(R.Left, R.Top, Buttons.Size, Buttons.Size);
            R3 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          end
          else // (Orientation = trVertical
          begin
            R2 := Rect(R.Left, R.Top, Buttons.Size, Buttons.Size);
            R3 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          end;

          DrawVistaGradient(graphic, Canvas, R3, Buttons.Shape, OuterBrClr, BrClr, Clr, ClrTo, ClrM, ClrMTo, Buttons.Gradient, Buttons.GradientMirror, Orientation);
        end;
        (*bsConcave:
        begin
          if (Orientation = trHorizontal) then
          begin
            h := R.Top + ((R.Bottom - R.Top) - Buttons.Width) div 2;
            R2 := Rect(R.Left, h, Buttons.Width, Buttons.Width);
            R3 := Rect(R.Left, h, R.Right, h + Buttons.Width);
          end
          else // (Orientation = trVertical
          begin
            R2 := Rect(R.Left, R.Top, R.Right, R.Bottom);
          end;

          path := CreateConcaveRectangle(R2, True);
          Rgn := TGPRegion.Create(path);
          graphic.SetClip(Rgn);
          path.Free;

          DrawVistaGradient(graphic, Canvas, R3, Buttons.Shape, clNone, clNone, Clr, ClrTo, ClrM, ClrMTo, Buttons.Gradient, Buttons.GradientMirror, Orientation);
          if Assigned(Rgn) then
          begin
            graphic.ResetClip();
            Rgn.Free;
          end;

          DrawConcaveRectangle(graphic, R3, True, BrClr);
        end; *)
      end;

      // Draw Minus ( - )
      if (Orientation = trHorizontal) then
      begin
        h := Buttons.Size div 2 - 4;
        R4.Left := R3.Left - 1 + (Buttons.Size - h) div 2;
        R4.Right := R4.Left + h + 4;
        R4.Top := R3.Top + ((R3.Bottom - R3.Top)) div 2 - 1;
        R4.Bottom := R4.Top + 4;
        Canvas.Pen.Color := Clr;
        Canvas.Rectangle(R4);
        Canvas.Pen.Color := BrClr;
        Canvas.MoveTo(R4.Left + 1, R4.Top + 1);
        Canvas.LineTo(R4.Right - 1, R4.Top + 1);
        Canvas.MoveTo(R4.Left + 1, R4.Top + 2);
        Canvas.LineTo(R4.Right - 1, R4.Top + 2);
      end
      else // (Orientation = trVertical
      begin
        h := Buttons.Size div 2 - 4;
        R4.Left :=   R3.Left + ((R3.Right - R3.Left)) div 2 - 1;
        R4.Right := R4.Left + 4;
        R4.Top := R3.Top - 1 + (Buttons.Size - h) div 2;
        R4.Bottom :=  R4.Top + h + 4;
        Canvas.Pen.Color := Clr;
        Canvas.Rectangle(R4);
        Canvas.Pen.Color := BrClr;
        Canvas.MoveTo(R4.Left + 1, R4.Top + 1);
        Canvas.LineTo(R4.Left + 1, R4.Bottom - 1);
        Canvas.MoveTo(R4.Left + 2, R4.Top + 1);
        Canvas.LineTo(R4.Left + 2, R4.Bottom -1);
      end;

      graphic.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.MaxButtonRect: TRect;
begin
  Result := InternalClientRect;
  if (FOrientation = trHorizontal) then
    Result.Left := Result.Right - ButtonWidth
  else // (FOrientation = trVertical)
    Result.Bottom := Result.Top + ButtonWidth;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.MinButtonRect: TRect;
begin
  Result := InternalClientRect;
  if (FOrientation = trHorizontal) then
    Result.Right := Result.Left + ButtonWidth
  else // (FOrientation = trVertical)
    Result.Top := Result.Bottom - ButtonWidth;
end;

//------------------------------------------------------------------------------

function TCustomTrackBar.ButtonWidth: Integer;
begin
  Result := FButtons.Size;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetBorderWidth(const Value: Integer);
begin
  if (FBorderWidth <> Value) then
  begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.ClickMinButton;
begin
  if (Position > FMin) then
  begin
    Position := Position - 1;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.ClickMaxButton;
begin
  if (Position < FMax) then
  begin
    Position := Position + 1;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetComponentStyle(AStyle: TTMSStyle);
begin
  Slider.Offset := 10;
  Slider.Picture := nil;
  Slider.PictureCompleted := nil;
  Slider.PictureDisabled := nil;
  Slider.PictureCompletedDisabled := nil;
  Slider.PictureStretched := false;
  TickMark.Picture := nil;
  TickMark.PictureDisabled := nil;
  TickMark.Position := tmBottomRight;
  Thumb.Picture := nil;
  Thumb.PictureDown := nil;
  Thumb.PictureHot := nil;
  Thumb.PictureDisabled := nil;
  Thumb.Shape := tsPointer;
  Buttons.Spacing := 2;
  Height := 26;


  if (Astyle in [tsOffice2003Blue, tsOffice2003Silver, tsOffice2003Olive, tsWhidbey]) then
  begin
    with Thumb do
    begin
      ColorHot := $CCF4FF;//$EBFDFF;
      ColorHotTo := $ACECFF;
      ColorMirrorHot := $59DAFF;
      ColorMirrorHotTo := $91D0FF;//$A4E9FF;
      BorderColorHot := $99CEDB;
      Gradient := ggVertical;
      GradientMirror := ggVertical;

      ColorDown := $76AFF1;
      ColorDownTo := $4190F3;
      ColorMirrorDown := $0E72F1;
      ColorMirrorDownTo := $4C9FFD;
      BorderColorDown := $45667B;
    end;

    with Buttons do
    begin
      ColorHot := $CCF4FF;//$EBFDFF;
      ColorHotTo := $ACECFF;
      ColorMirrorHot := $59DAFF;
      ColorMirrorHotTo := $91D0FF;//$A4E9FF;
      BorderColorHot := $99CEDB;
      Gradient := ggVertical;
      GradientMirror := ggVertical;

      ColorDown := $76AFF1;
      ColorDownTo := $4190F3;
      ColorMirrorDown := $0E72F1;
      ColorMirrorDownTo := $4C9FFD;
      BorderColorDown := $45667B;
    end;

  end;

 case AStyle of
    tsOffice2003Blue:
      begin
        with Thumb do
        begin
          Color := $EEDBC8;
          ColorTo := $F6DDC9;
          ColorMirror := $EDD4C0;
          ColorMirrorTo := $F7E1D0;
          BorderColor := $E0B99B;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Buttons do
        begin
          Color := $FEECDD;//$EEDBC8;
          ColorTo := $F9DBC4;//$F6DDC9;
          ColorMirror := $FEECDD;//$EDD4C0;
          ColorMirrorTo := $E2A981;//$F7E1D0;
          BorderColor := $9C613B;//$E0B99B;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Slider do
        begin
          BorderColor := $C29674;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;

      end;
    tsOffice2003Olive:
      begin
        with Thumb do
        begin
          Color := $CFF0EA;
          ColorTo := $CFF0EA;
          ColorMirror := $CFF0EA;
          ColorMirrorTo := $8CC0B1;
          BorderColor := $8CC0B1;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Buttons do
        begin
          Color := $CFF0EA;
          ColorTo := $CFF0EA;
          ColorMirror := $CFF0EA;
          ColorMirrorTo := $8CC0B1;
          BorderColor := $8CC0B1;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Slider do
        begin
          BorderColor := $8CC0B1;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;

      end;
    tsOffice2003Silver:
      begin
        with Thumb do
        begin
          Color := $EDD4C0;
          ColorTo := $00E6D8D8;
          ColorMirror := $EDD4C0;
          ColorMirrorTo := $C8B2B3;
          BorderColor := $927476;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Buttons do
        begin
          Color := $EDD4C0;
          ColorTo := $00E6D8D8;
          ColorMirror := $EDD4C0;
          ColorMirrorTo := $C8B2B3;
          BorderColor := $927476;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Slider do
        begin
          BorderColor := $927476;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;

      end;
    tsOffice2003Classic:
      begin
        with Thumb do
        begin
          Color := clWhite;
          ColorTo := $C9D1D5;
          ColorMirror := clWhite;
          ColorMirrorTo := $C9D1D5;
          BorderColor := clBlack;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Buttons do
        begin
          Color := clWhite;
          ColorTo := $C9D1D5;
          ColorMirror := clWhite;
          ColorMirrorTo := $C9D1D5;
          BorderColor := clBlack;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Slider do
        begin
          BorderColor := $927476;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;
      end;
    tsOffice2007Luna:
      begin
        with Thumb do
        begin
          Color := $EEDBC8;
          ColorTo := $F6DDC9;
          ColorMirror := $EDD4C0;
          ColorMirrorTo := $F7E1D0;
          BorderColor := $E0B99B;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Buttons do
        begin
          Color := $EEDBC8;
          ColorTo := $F6DDC9;
          ColorMirror := $EDD4C0;
          ColorMirrorTo := $F7E1D0;
          BorderColor := $E0B99B;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Slider do
        begin
          BorderColor := $C29674;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;
      end;
    tsOffice2007Obsidian:
      begin
        with Thumb do
        begin
          Color := $DFDED6;
          ColorTo := $E4E2DB;
          ColorMirror := $D7D5CE;
          ColorMirrorTo := $E7E5E0;
          BorderColor := $C0BCB2;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Buttons do
        begin
          Color := $DFDED6;
          ColorTo := $E4E2DB;
          ColorMirror := $D7D5CE;
          ColorMirrorTo := $E7E5E0;
          BorderColor := $C0BCB2;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Slider do
        begin
          BorderColor := $C0BCB2;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;

      end;
    tsOffice2007Silver:
      begin
        with Thumb do
        begin
          Color := $F3F3F1;
          ColorTo := $F5F5F3;
          ColorMirror := $EEEAE7;
          ColorMirrorTo := $F8F7F6;
          BorderColor := $CCCAC9;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Buttons do
        begin
          Color := $F3F3F1;
          ColorTo := $F5F5F3;
          ColorMirror := $EEEAE7;
          ColorMirrorTo := $F8F7F6;
          BorderColor := $CCCAC9;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EBFDFF;
          ColorHotTo := $ACECFF;
          ColorMirrorHot := $59DAFF;
          ColorMirrorHotTo := $A4E9FF;
          BorderColorHot := $99CEDB;

          ColorDown := $76AFF1;
          ColorDownTo := $4190F3;
          ColorMirrorDown := $0E72F1;
          ColorMirrorDownTo := $4C9FFD;
          BorderColorDown := $45667B;
        end;

        with Slider do
        begin
          BorderColor := $CCCAC9;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;

      end;
    tsWindowsXP:
      begin
        with Thumb do
        begin
          Color := clWhite;
          ColorTo := $B9D8DC;
          ColorMirror := $B9D8DC;
          ColorMirrorTo := $B9D8DC;
          BorderColor := $B9D8DC;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EFD3C6;
          ColorHotTo := $EFD3C6;
          ColorMirrorHot := $EFD3C6;
          ColorMirrorHotTo := $EFD3C6;
          BorderColorHot := clHighlight;

          ColorDown := $B59284;
          ColorDownTo := $B59284;
          ColorMirrorDown := $B59284;
          ColorMirrorDownTo := $B59284;
          BorderColorDown := clHighlight;
        end;

        with Buttons do
        begin
          Color := clWhite;
          ColorTo := $B9D8DC;
          ColorMirror := $B9D8DC;
          ColorMirrorTo := $B9D8DC;
          BorderColor := $B9D8DC;
          Gradient := ggVertical;
          GradientMirror := ggVertical;

          ColorHot := $EFD3C6;
          ColorHotTo := $EFD3C6;
          ColorMirrorHot := $EFD3C6;
          ColorMirrorHotTo := $EFD3C6;
          BorderColorHot := clHighlight;

          ColorDown := $B59284;
          ColorDownTo := $B59284;
          ColorMirrorDown := $B59284;
          ColorMirrorDownTo := $B59284;
          BorderColorDown := clHighlight;
        end;

        with Slider do
        begin
          BorderColor := $927476;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;
      end;
    tsWhidbey:
      begin
        with Thumb do
        begin
          Color := clWhite;
          ColorTo := $DFEDF0;
          ColorMirror := $DFEDF0;
          ColorMirrorTo := $DFEDF0;
          BorderColor := $99A8AC;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Buttons do
        begin
          Color := clWhite;
          ColorTo := $DFEDF0;
          ColorMirror := $DFEDF0;
          ColorMirrorTo := $DFEDF0;
          BorderColor := $99A8AC;
          Gradient := ggVertical;
          GradientMirror := ggVertical;
        end;

        with Slider do
        begin
          BorderColor := $927476;
        end;

        with TickMark do
        begin
          Color := Slider.BorderColor;
        end;
      end;
    tsCustom:
      begin
      end;
  end;
  Invalidate;
end;


//------------------------------------------------------------------------------

procedure TCustomTrackBar.CMMouseEnter(var Message: TMessage);
begin
  inherited;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  
  if FMinButtonHot or FMinButtonDown then
  begin
    FMinButtonHot := False;
    FMinButtonHot := False;
    DrawMinButton;
  end;

  if FMaxButtonHot or FMaxButtonDown then
  begin
    FMaxButtonHot := False;
    FMaxButtonHot := False;
    DrawMaxButton;
  end;

  if (FThumbHot or FThumbDown) and not FSliding then
  begin
    FThumbHot := False;
    FThumbDown := False;
    DrawThumb;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.WMPaint(var Msg: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  PS: TPaintStruct;
begin
  if not FDoubleBuffered or (Msg.DC <> 0) then
  begin
    if not (csCustomPaint in ControlState) and (ControlCount = 0) then
      inherited
    else
      PaintHandler(Msg);
  end
  else
  begin
    DC := GetDC(0);
    MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
    ReleaseDC(0, DC);
    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, MemBitmap);
    try
      DC := BeginPaint(Handle, PS);
      Perform(WM_ERASEBKGND, MemDC, MemDC);
      Msg.DC := MemDC;
      WMPaint(Msg);
      Msg.DC := 0;
      BitBlt(DC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0, 0, SRCCOPY);
      EndPaint(Handle, PS);
    finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.RepeatTimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := Buttons.RepeatPause;
  if MouseCapture then
  begin
    try
      if FMinButtonDown then
        ClickMinButton
      else if FMaxButtonDown then
        ClickMaxButton
      else
        FRepeatTimer.Enabled := False;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.SetBackGroundStretched(const Value: Boolean);
begin
  if (FBackGroundStretched <> Value) then
  begin
    FBackGroundStretched := Value;
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.CMHintShow(var Message: TMessage);
{var
  PHI: PHintInfo; }
begin
  inherited;

  {PHI := TCMHintShow(Message).HintInfo;
  if TrackHint then
  begin
    if (FHintTickIndex >= FMin) then
    begin
      s := InttoStr(FHintTickIndex);
      if Assigned(FOnGetTrackHint) then
        FOnGetTrackHint(self, FHintTickIndex, s);
      PHI^.HintStr := s;
    end;
  end;}
end;

//------------------------------------------------------------------------------

procedure TCustomTrackBar.WMMouseWheel(var Message: TWMMouseWheel);
begin
  inherited;
  
  if (Message.WheelDelta < 0) then   // WheelDown
  begin
    if (Orientation = trHorizontal) then
    begin
      if (Position < FMax) then
        Position := Position + 1;
    end
    else  // (Orientation = trVertical)
    begin
      if (Position > FMin) then
        Position := Position - 1;
    end;
  end
  else                               // WheelUp
  begin
    if (Orientation = trHorizontal) then
    begin
      if (Position > FMin) then
        Position := Position - 1;
    end
    else  // (Orientation = trVertical)
    begin
      if (Position < FMax) then
        Position := Position + 1;
    end;
  end;
end;


//------------------------------------------------------------------------------

{ TTrackBarTick }

constructor TTrackBarTick.Create;
begin
  inherited;
  FIPicture := TGDIPPicture.Create;
  FIPicture.OnChange := PictureChanged;

  FIPictureDisabled := TGDIPPicture.Create;
  FIPictureDisabled.OnChange := PictureChanged;

  FColor := clBlack;
  FSize := 4;
  FPosition := tmBottomRight;
  FStyle := tsAuto;
  FFont := TFont.Create;
  FFont.Name := 'Tahoma';
  FFont.OnChange := OnFontChanged;
  FLine3D := False;
  FShowImageAtThumbOnly := False;
  FShowImageAtSteps := 1;
  FSpacing := 8;
  FRotateFontVert := true;
end;

//------------------------------------------------------------------------------

destructor TTrackBarTick.destroy;
begin
  FIPicture.Free;
  FIPictureDisabled.Free;
  FFont.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.Assign(Source: TPersistent);
begin
  if (Source is TTrackBarTick) then
  begin
    Color := (Source as TTrackBarTick).Color;
    ColorDisabled := (Source as TTrackBarTick).ColorDisabled;
    Size := (Source as TTrackBarTick).Size;
    Position := (Source as TTrackBarTick).Position;
    Style := (Source as TTrackBarTick).Style;
    Picture.Assign((Source as TTrackBarTick).Picture);
    PictureDisabled.Assign((Source as TTrackBarTick).PictureDisabled);
    Font.Assign((Source as TTrackBarTick).Font);
    ShowText := (Source as TTrackBarTick).ShowText;
    Line3D := (Source as TTrackBarTick).Line3D;
    FShowImageAtThumbOnly := (Source as TTrackBarTick).ShowImageAtThumbOnly;
    FShowImageAtSteps := (Source as TTrackBarTick).ShowImageAtSteps;
    Spacing := (Source as TTrackBarTick).Spacing;
  end
  else
    inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.PictureChanged(Sender: TObject);
begin
  Changed;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetColor(const Value: TColor);
begin
  if (FColor <> Value) then
  begin
    FColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetPicture(const Value: TGDIPPicture);
begin
  FIPicture.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetColorDisabled(const Value: TColor);
begin
  if (FColorDisabled <> Value) then
  begin
    FColorDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetPictureDisabled(const Value: TGDIPPicture);
begin
  FIPictureDisabled.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetPosition(const Value: TTickMark);
begin
  if (FPosition <> Value) then
  begin
    FPosition := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetStyle(const Value: TTickStyle);
begin
  if (FStyle <> Value) then
  begin
    FStyle := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetShowText(const Value: Boolean);
begin
  if (FShowText <> Value) then
  begin
    FShowText := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.OnFontChanged(Sender: TObject);
begin
  Changed;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetLine3D(const Value: Boolean);
begin
  if (FLine3D <> Value) then
  begin
    FLine3D := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetShowImageAtThumbOnly(const Value: Boolean);
begin
  if (FShowImageAtThumbOnly <> Value) then
  begin
    FShowImageAtThumbOnly := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetShowImageAtSteps(const Value: Integer);
begin
  if (FShowImageAtSteps <> Value) then
  begin
    FShowImageAtSteps := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetSpacing(const Value: Integer);
begin
  if (FSpacing <> Value) then
  begin
    FSpacing := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetSize(const Value: Integer);
begin
  if (FSize <> Value) then
  begin
    FSize := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarTick.SetRotateFontVert(const Value: boolean);
begin
  if (FRotateFontVert <> Value) then
  begin
    FRotateFontVert := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

{ TTrackBarSlider }

constructor TTrackBarSlider.Create;
begin
  inherited;
  FIPicture := TGDIPPicture.Create;
  FIPicture.OnChange := PictureChanged;

  FIPictureDisabled := TGDIPPicture.Create;
  FIPictureDisabled.OnChange := PictureChanged;

  FColor := clWhite;
  FColorTo := clBlack;
  FBorderColor := $00C29674;
  FBorder3D := True;
  FRounded := False;
  FSteps := 20;
  FSize := 2;
  FVisible := True;
  FOffset := 10;
  FPictureStretched := False;
  FColorCompletedTo := clNone;
  FColorCompleted := clNone;
  FColorCompletedDisabled := clNone;
  FColorCompletedDisabledTo := clNone;
  FPictureCompleted := TGDIPPicture.Create;
  FPictureCompleted.OnChange := PictureChanged;
  FPictureCompletedDisabled := TGDIPPicture.Create;
  FPictureCompletedDisabled.OnChange := PictureChanged;
end;

//------------------------------------------------------------------------------

destructor TTrackBarSlider.Destroy;
begin
  FIPicture.Free;
  FIPictureDisabled.Free;
  FPictureCompleted.Free;
  FPictureCompletedDisabled.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.Assign(Source: TPersistent);
begin
  if (Source is TTrackBarSlider) then
  begin
    FBorderColor := (Source as TTrackBarSlider).BorderColor;
    FBorderColorDisabled := (Source as TTrackBarSlider).BorderColorDisabled;
    FColor := (Source as TTrackBarSlider).Color;
    FColorTo := (Source as TTrackBarSlider).ColorTo;
    FColorDisabled := (Source as TTrackBarSlider).ColorDisabled;
    FColorDisabledTo := (Source as TTrackBarSlider).ColorDisabledTo;
    FColorCompletedTo := (Source as TTrackBarSlider).ColorCompletedTo;
    FColorCompleted := (Source as TTrackBarSlider).ColorCompleted;
    FColorCompletedDisabled := (Source as TTrackBarSlider).ColorCompletedDisabled;
    FColorCompletedDisabledTo := (Source as TTrackBarSlider).ColorCompletedDisabledTo;
    FSize := (Source as TTrackBarSlider).Size;
    FRounded := (Source as TTrackBarSlider).Rounded;
    Border3D := (Source as TTrackBarSlider).Border3D;
    Visible := (Source as TTrackBarSlider).Visible;
    Picture.Assign((Source as TTrackBarSlider).Picture);
    PictureDisabled.Assign((Source as TTrackBarSlider).PictureDisabled);
    FPictureStretched := (Source as TTrackBarSlider).PictureStretched;
    FPictureCompleted.Assign((Source as TTrackBarSlider).PictureCompleted);
    FPictureCompletedDisabled.Assign((Source as TTrackBarSlider).PictureCompletedDisabled);
    Offset := (Source as TTrackBarSlider).Offset;
  end
  else
    inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetBorder3D(const Value: Boolean);
begin
  if (FBorder3D <> Value) then
  begin
    FBorder3D := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetBorderColor(const Value: TColor);
begin
  if (FBorderColor <> Value) then
  begin
    FBorderColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColor(const Value: TColor);
begin
  if (FColor <> Value) then
  begin
    FColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorTo(const Value: TColor);
begin
  if (FColorTo <> Value) then
  begin
    FColorTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetDirection(const Value: TGradientDirection);
begin
  if (FDirection <> Value) then
  begin
    FDirection := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetPicture(const Value: TGDIPPicture);
begin
  FIPicture.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetRounded(const Value: Boolean);
begin
  if (FRounded <> Value) then
  begin
    FRounded := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetSteps(const Value: Integer);
begin
  if (FSteps <> Value) then
  begin
    FSteps := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.PictureChanged(Sender: TObject);
begin
  if not Picture.Empty then
  begin
    Picture.GetImageSizes;
    if (AdvTrackBar.Orientation = trHorizontal) then
    begin
      FSize := Picture.Height;
      BorderColor := clNone;
    end
    else
    begin
      FSize := Picture.Width;
      BorderColor := clNone;
    end;
  end;

  Changed;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetBorderColorDisabled(const Value: TColor);
begin
  if (FBorderColorDisabled <> Value) then
  begin
    FBorderColorDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorDisabled(const Value: TColor);
begin
  if (FColorDisabled <> Value) then
  begin
    FColorDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorDisabledTo(const Value: TColor);
begin
  if (FColorDisabledTo <> Value) then
  begin
    FColorDisabledTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetPictureDisabled(const Value: TGDIPPicture);
begin
  FIPictureDisabled.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetSize(const Value: Integer);
begin
  if (FSize <> Value) then
  begin
    FSize := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetVisible(const Value: Boolean);
begin
  if (FVisible <> Value) then
  begin
    FVisible := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetPictureStretched(const Value: Boolean);
begin
  if (FPictureStretched <> Value) then
  begin
    FPictureStretched := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorCompleted(const Value: TColor);
begin
  if (FColorCompleted <> Value) then
  begin
    FColorCompleted := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorCompletedDisabled(const Value: TColor);
begin
  if (FColorCompletedDisabled <> Value) then
  begin
    FColorCompletedDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorCompletedDisabledTo(const Value: TColor);
begin
  if (FColorCompletedDisabledTo <> Value) then
  begin
    FColorCompletedDisabledTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetColorCompletedTo(const Value: TColor);
begin
  if (FColorCompletedTo <> Value) then
  begin
    FColorCompletedTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetPictureCompleted(const Value: TGDIPPicture);
begin
  FPictureCompleted.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetPictureCompletedDisabled(
  const Value: TGDIPPicture);
begin
  FPictureCompletedDisabled.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarSlider.SetOffset(const Value: Integer);
begin
  if (FOffset <> Value) then
  begin
    FOffset := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

{ TTrackBarThumb }

constructor TTrackBarThumb.Create;
begin
  inherited;
  FAdvTrackBar := nil;
  FIPicture := TGDIPPicture.Create;
  FIPicture.OnChange := PictureChanged;

  FIPictureHot := TGDIPPicture.Create;
  FIPictureHot.OnChange := PictureChanged;

  FIPictureDown := TGDIPPicture.Create;
  FIPictureDown.OnChange := PictureChanged;

  FIPictureDisabled := TGDIPPicture.Create;
  FIPictureDisabled.OnChange := PictureChanged;

  FBorderColor := $009D6F40;
  FColor := $EEDBC8;
  FColorTo := $F6DDC9;
  FColorMirror := $EDD4C0;
  FColorMirrorTo := $F7E1D0;

  FBorderColorHot := $99CEDB;
  FColorHot := $EBFDFF;
  FColorHotTo := $ACECFF;
  FColorMirrorHot := $59DAFF;
  FColorMirrorHotTo := $A4E9FF;
  FGradient := ggVertical;
  FGradientMirror := ggVertical;

  FBorderColorDown := $45667B;
  FColorDown := $76AFF1;
  FColorDownTo := $4190F3;
  FColorMirrorDown := $0E72F1;
  FColorMirrorDownTo := $4C9FFD;

  FSteps := 64;

  FSize := 15;

  FGradientMirror := ggRadial;

  FWidth := 10;
  FShape := tsPointer;
  FStyle := tstOffice2007;
  FPictureStretched := False;
  FShowAtMinMax := true;
end;

//------------------------------------------------------------------------------

destructor TTrackBarThumb.Destroy;
begin
  FIPicture.Free;
  FIPictureHot.Free;
  FIPictureDown.Free;
  FIPictureDisabled.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.Assign(Source: TPersistent);
begin
  if (Source is TTrackBarThumb) then
  begin
    FBorderColor := (Source as TTrackBarThumb).BorderColor;
    FColor := (Source as TTrackBarThumb).Color;
    FColorTo := (Source as TTrackBarThumb).ColorTo;
    FBorderColorHot := (Source as TTrackBarThumb).BorderColorHot;
    FColorHot := (Source as TTrackBarThumb).ColorHot;
    FColorHotTo := (Source as TTrackBarThumb).ColorHotTo;
    FSteps := (Source as TTrackBarThumb).Steps;
    FBorderColorDown := (Source as TTrackBarThumb).BorderColorDown;
    FColorDown := (Source as TTrackBarThumb).ColorDown;
    FColorDownTo := (Source as TTrackBarThumb).ColorDownTo;
    FBorderColorDisabled := (Source as TTrackBarThumb).BorderColorDisabled;
    FColorDisabled := (Source as TTrackBarThumb).ColorDisabled;
    FColorDisabledTo := (Source as TTrackBarThumb).ColorDisabledTo;
    FColorMirror := (Source as TTrackBarThumb).ColorMirror;
    FColorMirrorTo := (Source as TTrackBarThumb).ColorMirrorTo;
    FColorMirrorHot := (Source as TTrackBarThumb).ColorMirrorHot;
    FColorMirrorHotTo := (Source as TTrackBarThumb).ColorMirrorHotTo;
    FColorMirrorDown := (Source as TTrackBarThumb).ColorMirrorDown;
    FColorMirrorDownTo := (Source as TTrackBarThumb).ColorMirrorDownTo;
    FColorMirrorDisabled := (Source as TTrackBarThumb).ColorMirrorDisabled;
    FColorMirrorDisabledTo := (Source as TTrackBarThumb).ColorMirrorDisabledTo;
    FGradient := (Source as TTrackBarThumb).Gradient;
    FGradientMirror := (Source as TTrackBarThumb).GradientMirror;
    Picture.Assign((Source as TTrackBarThumb).Picture);
    PictureHot.Assign((Source as TTrackBarThumb).PictureHot);
    PictureDown.Assign((Source as TTrackBarThumb).PictureDown);
    PictureDisabled.Assign((Source as TTrackBarThumb).PictureDisabled);
    Width := (Source as TTrackBarThumb).Width;
    Shape := (Source as TTrackBarThumb).Shape;
    Style := (Source as TTrackBarThumb).Style;
    Size := (Source as TTrackBarThumb).Size;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.Changed;
begin
  if Assigned(OnChange) then
    OnChange(Self);
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColor(const Value: TColor);
begin
  if (FColor <> Value) then
  begin
    FColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorTo(const Value: TColor);
begin
  if (FColorTo <> Value) then
  begin
    FColorTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetSteps(const Value: Integer);
begin
  if (FSteps <> Value) then
  begin
    FSteps := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetBorderColor(const Value: TColor);
begin
  if (FBorderColor <> Value) then
  begin
    FBorderColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetBorderColorHot(const Value: TColor);
begin
  if (FBorderColorHot <> Value) then
  begin
    FBorderColorHot := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorHot(const Value: TColor);
begin
  if (FColorHot <> Value) then
  begin
    FColorHot := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorHotTo(const Value: TColor);
begin
  if (FColorHotTo <> Value) then
  begin
    FColorHotTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetBorderColorDisabled(const Value: TColor);
begin
  if (FBorderColorDisabled <> Value) then
  begin
    FBorderColorDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetBorderColorDown(const Value: TColor);
begin
  if (FBorderColorDown <> Value) then
  begin
    FBorderColorDown := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorDisabled(const Value: TColor);
begin
  if (FColorDisabled <> Value) then
  begin
    FColorDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorDisabledTo(const Value: TColor);
begin
  if (FColorDisabledTo <> Value) then
  begin
    FColorDisabledTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorDown(const Value: TColor);
begin
  if (FColorDown <> Value) then
  begin
    FColorDown := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorDownTo(const Value: TColor);
begin
  if (FColorDownTo <> Value) then
  begin
    FColorDownTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetPicture(const Value: TGDIPPicture);
begin
  FIPicture.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetShape(const Value: TThumbShape);
begin
  if (FShape <> Value) then
  begin
    FShape := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetShowAtMinMax(const Value: boolean);
begin
  if (FShowAtMinMax <> Value) then
  begin
    FShowAtMinMax := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetStyle(const Value: TThumbStyle);
begin
  if (FStyle <> Value) then
  begin
    FStyle := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetWidth(const Value: Integer);
begin
  if (FWidth <> Value) and Picture.Empty then
  begin
    FWidth := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.PictureChanged(Sender: TObject);
begin
  if not Picture.Empty and Assigned(AdvTrackBar) then
  begin
    Picture.GetImageSizes;
    if (AdvTrackBar.Orientation = trHorizontal) then
    begin
      FSize := Picture.Height;
      FWidth := Picture.Width;
    end
    else
    begin
      FWidth := Picture.Height;
      FSize := Picture.Width;
    end;
  end;
  Changed;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetPictureDisabled(const Value: TGDIPPicture);
begin
  FIPictureDisabled.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetPictureDown(const Value: TGDIPPicture);
begin
  FIPictureDown.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetPictureHot(const Value: TGDIPPicture);
begin
  FIPictureHot.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorMirrorDisabled(const Value: TColor);
begin
  if (FColorMirrorDisabled <> Value) then
  begin
    FColorMirrorDisabled := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorMirrorDisabledTo(const Value: TColor);
begin
  if (FColorMirrorDisabledTo <> Value) then
  begin
    FColorMirrorDisabledTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorMirror(const Value: TColor);
begin
  if (FColorMirror <> Value) then
  begin
    FColorMirror := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetColorMirrorTo(const Value: TColor);
begin
  if (FColorMirrorTo <> Value) then
  begin
    FColorMirrorTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetGradientMirror(const Value: TGDIPGradient);
begin
  if (FGradientMirror <> Value) then
  begin
    FGradientMirror := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetGradient(const Value: TGDIPGradient);
begin
  if (FGradient <> Value) then
  begin
    FGradient := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarThumb.SetSize(const Value: Integer);
begin
  if (FSize <> Value) and Picture.Empty then
  begin
    FSize := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

{ TTrackBarButtons }

constructor TTrackBarButtons.Create;
begin
  inherited;
  FIMinPicture := TGDIPPicture.Create;
  FIMinPicture.OnChange := PictureChanged;
  FIMinPictureHot := TGDIPPicture.Create;
  FIMinPictureDown := TGDIPPicture.Create;

  FIMaxPicture := TGDIPPicture.Create;
  FIMaxPicture.OnChange := PictureChanged;
  FIMaxPictureHot := TGDIPPicture.Create;
  FIMaxPictureDown := TGDIPPicture.Create;

  FVisible := False;
  FSize := 20;
  FShape := bsRound;
  FSpacing := 2;

  FBorderColor := $008D572F;
  FColor := $EEDBC8;
  FColorTo := $F6DDC9;
  FColorMirror := $EDD4C0;
  FColorMirrorTo := $F7E1D0;

  FBorderColorHot := $99CEDB;
  FColorHot := $EBFDFF;
  FColorHotTo := $ACECFF;
  FColorMirrorHot := $59DAFF;
  FColorMirrorHotTo := $A4E9FF;
  FGradient := ggVertical;
  FGradientMirror := ggVertical;

  FBorderColorDown := $45667B;
  FColorDown := $76AFF1;
  FColorDownTo := $4190F3;
  FColorMirrorDown := $0E72F1;
  FColorMirrorDownTo := $4C9FFD;

  FCornerRadius := 0;

  FInitRepeatPause := 400;
  FRepeatPause := 100;
  FRepeatClick := True;
end;

//------------------------------------------------------------------------------

destructor TTrackBarButtons.Destroy;
begin
  FIMinPicture.Free;
  FIMinPictureHot.Free;
  FIMinPictureDown.Free;
  FIMaxPicture.Free;
  FIMaxPictureHot.Free;
  FIMaxPictureDown.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.Assign(Source: TPersistent);
begin
  if (Source is TTrackBarButtons) then
  begin
    BorderColor := (Source as TTrackBarButtons).BorderColor;
    BorderColorHot := (Source as TTrackBarButtons).BorderColorHot;
    BorderColorDown := (Source as TTrackBarButtons).BorderColorDown;
    Color := (Source as TTrackBarButtons).Color;
    ColorTo := (Source as TTrackBarButtons).ColorTo;
    ColorHot := (Source as TTrackBarButtons).ColorHot;
    ColorHotTo := (Source as TTrackBarButtons).ColorHotTo;
    ColorDown := (Source as TTrackBarButtons).ColorDown;
    ColorDownTo := (Source as TTrackBarButtons).ColorDownTo;
    ColorMirror := (Source as TTrackBarButtons).ColorMirror;
    ColorMirrorTo := (Source as TTrackBarButtons).ColorMirrorTo;
    ColorMirrorHot := (Source as TTrackBarButtons).ColorMirrorHot;
    ColorMirrorHotTo := (Source as TTrackBarButtons).ColorMirrorHotTo;
    ColorMirrorDown := (Source as TTrackBarButtons).ColorMirrorDown;
    ColorMirrorDownTo := (Source as TTrackBarButtons).ColorMirrorDownTo;
    MinPicture.Assign((Source as TTrackBarButtons).MinPicture);
    MinPictureHot.Assign((Source as TTrackBarButtons).MinPictureHot);
    MinPictureDown.Assign((Source as TTrackBarButtons).MinPictureDown);
    MaxPicture.Assign((Source as TTrackBarButtons).MaxPicture);
    MaxPictureHot.Assign((Source as TTrackBarButtons).MaxPictureHot);
    MaxPictureDown.Assign((Source as TTrackBarButtons).MaxPictureDown);
    Visible:= (Source as TTrackBarButtons).Visible;
    Size:= (Source as TTrackBarButtons).Size;
    Shape:= (Source as TTrackBarButtons).Shape;
    CornerRadius := (Source as TTrackBarButtons).CornerRadius;
    RepeatClick := (Source as TTrackBarButtons).RepeatClick;
    RepeatPause := (Source as TTrackBarButtons).RepeatPause;
    InitRepeatPause := (Source as TTrackBarButtons).InitRepeatPause;
    Spacing := (Source as TTrackBarButtons).Spacing;
  end
  else
    inherited;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetBorderColor(const Value: TColor);
begin
  if (FBorderColor <> Value) then
  begin
    FBorderColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetBorderColorDown(const Value: TColor);
begin
  if (FBorderColorDown <> Value) then
  begin
    FBorderColorDown := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetBorderColorHot(const Value: TColor);
begin
  if (FBorderColorHot <> Value) then
  begin
    FBorderColorHot := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetColor(const Value: TColor);
begin
  if (FColor <> Value) then
  begin
    FColor := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetColorDown(const Value: TColor);
begin
  if (FColorDown <> Value) then
  begin
    FColorDown := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetColorDownTo(const Value: TColor);
begin
  if (FColorDownTo <> Value) then
  begin
    FColorDownTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetColorHot(const Value: TColor);
begin
  if (FColorHot <> Value) then
  begin
    FColorHot := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetColorHotTo(const Value: TColor);
begin
  if (FColorHotTo <> Value) then
  begin
    FColorHotTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetColorTo(const Value: TColor);
begin
  if (FColorTo <> Value) then
  begin
    FColorTo := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetMaxPicture(const Value: TGDIPPicture);
begin
  FIMaxPicture.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetMaxPictureDown(const Value: TGDIPPicture);
begin
  FIMaxPictureDown.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetMaxPictureHot(const Value: TGDIPPicture);
begin
  FIMaxPictureHot.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetMinPicture(const Value: TGDIPPicture);
begin
  FIMinPicture.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetMinPictureDown(const Value: TGDIPPicture);
begin
  FIMinPictureDown.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetMinPictureHot(const Value: TGDIPPicture);
begin
  FIMinPictureHot.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetVisible(const Value: Boolean);
begin
  if (FVisible <> Value) then
  begin
    FVisible := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.PictureChanged(Sender: TObject);
var
  Pic: TGDIPPicture;
begin
  if (not MinPicture.Empty or not MaxPicture.Empty) and Assigned(AdvTrackBar) then
  begin
    if not MinPicture.Empty then
      Pic := MinPicture
    else
      Pic := MaxPicture;

    Pic.GetImageSizes;
    if (AdvTrackBar.Orientation = trHorizontal) then
      FSize := Pic.Width
    else
      FSize := Pic.Height;
  end;
  Changed;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetShape(const Value: TTrackButtonShape);
begin
  if (FShape <> Value) then
  begin
    FShape := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetCornerRadius(const Value: Integer);
begin
  if (FCornerRadius <> Value) then
  begin
    FCornerRadius := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetSize(const Value: Integer);
begin
  if (FSize <> Value) and MinPicture.Empty and MaxPicture.Empty then
  begin
    FSize := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetGradient(const Value: TGDIPGradient);
begin
  if (FGradient <> Value) then
  begin
    FGradient := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetGradientMirror(const Value: TGDIPGradient);
begin
  if (FGradientMirror <> Value) then
  begin
    FGradientMirror := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

procedure TTrackBarButtons.SetSpacing(const Value: Integer);
begin
  if (FSpacing <> Value) then
  begin
    FSpacing := Value;
    Changed;
  end;
end;

//------------------------------------------------------------------------------

{ TTrackHintWindow }

procedure TTrackHintWindow.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;

begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;

  if (Win32Platform = VER_PLATFORM_WIN32_NT) and
     ((Win32MajorVersion > 5) or
      ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1))) then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

//------------------------------------------------------------------------------

procedure TTrackHintWindow.Paint;
var
  DC: HDC;
  R, rd: TRect;
  Brush, SaveBrush: HBRUSH;

  procedure DCFrame3D(var R: TRect; const TopLeftColor, BottomRightColor: TColor);
  var
    Pen, SavePen: HPEN;
    P: array[0..2] of TPoint;
  begin
    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(TopLeftColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-2);
    P[1] := Point(R.Left, R.Top);
    P[2] := Point(R.Right-1, R.Top);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);

    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(BottomRightColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-1);
    P[1] := Point(R.Right-1, R.Bottom-1);
    P[2] := Point(R.Right-1, R.Top-1);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);
  end;

begin
  DC := Canvas.Handle;
  R := ClientRect;
  RD := ClientRect;

  // Background
  Brush := CreateSolidBrush(ColorToRGB(Color));

  SaveBrush := SelectObject(DC, Brush);
  FillRect(DC, R, Brush);
  SelectObject(DC, SaveBrush);
  DeleteObject(Brush);

  // Border
  DCFrame3D(R, cl3DLight, cl3DDkShadow);

  // Caption
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption), RD, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

procedure TTrackHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  dx, dy : Integer;
  Pnt: TPoint;
{$IFDEF DELPHI6_LVL}
  Monitor : TMonitor;
{$ENDIF}
  XSize, YSize: Integer;
begin
  Caption := AHint;
  dx := 16;
  dy := 4;

  with Rect do
  begin
    // Calculate width and height
    TextSize(Canvas, Font, Caption, YSize, XSize);
    
    FTextWidth := XSize;
    Right := Left + FTextWidth + dx;

    FTextHeight := YSize;
    Bottom := Top + FTextHeight + dy;

    // Calculate position
    Pnt := Point(Rect.Left,Rect.Top);
    Left := Pnt.X;
    Top := Pnt.Y;
    Right := Right - Left + Pnt.X;
    Bottom := Bottom - Top + Pnt.Y;

    {$IFDEF DELPHI6_LVL}
    Monitor := Screen.MonitorFromPoint(Pnt);

    if Right - Monitor.Left > Monitor.Width then
    begin
      Left := Monitor.Left + Monitor.Width - Right + Left - 2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom - Monitor. Top > Monitor. Height then
    begin
      Bottom := Monitor. Top + Monitor. Height - 2;
      Top := Bottom - FTextHeight - dy;
    end;
    {$ELSE}

    {$IFDEF DELPHI4_LVL}
    if Right > Screen.DesktopWidth then
    begin
      Left := Screen.DesktopWidth - Right + Left -2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom > Screen.DesktopHeight then
    begin
      Bottom := Screen.DesktopHeight - 2;
      Top := Bottom - FTextHeight - dy;
    end;
    {$ELSE}
    if Right > GetSystemMetrics(SM_CXSCREEN) then
    begin
      Left := GetSystemMetrics(SM_CXSCREEN) - Right + Left -2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom > GetSystemMetrics(SM_CYSCREEN) then
    begin
      Bottom := GetSystemMetrics(SM_CYSCREEN) - 2;
      Top := Bottom - FTextHeight - dy;
    end;

    {$ENDIF}
    {$ENDIF}
  end;

  BoundsRect := Rect;

  Pnt := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, Pnt.X, Pnt.Y, 0, 0,
               SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
  invalidate;
end;

//------------------------------------------------------------------------------

{$IFNDEF TMSDOTNET}
function TTrackHintWindow.CalcHintRect(MaxWidth: Integer;
  const AHint: string; AData: Pointer): TRect;
{$ENDIF}
{$IFDEF TMSDOTNET}
function TTrackHintWindow.CalcHintRect(MaxWidth: Integer;
  const AHint: string; AData: TObject): TRect;
{$ENDIF}
var
  XSize, YSize: Integer;
begin
  TextSize(Canvas, Self.Font, Caption, YSize, XSize);
  Result := Rect(0, 0, XSize, YSize);
end;

//------------------------------------------------------------------------------

procedure TTrackHintWindow.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

{$IFDEF FREEWARE}
{$I TRIAL.INC}
{$ENDIF}


end.
