
{*****************************************************************************}
{                                                                             }
{    WinG Import Unit & Components for Delphi                                 }
{                                                                             }
{    Copyright (c) 1995 Mike Scott All Rights Reserved                        }
{                                                                             }
{    For support or information, contact Mike Scott at:-                      }
{      Internet   : 100140.2420@compuserve.com                                }
{      CompuServe : 100140,2420                                               }
{      Telephone  : +44 131 467 3267                                          }
{      Snail-mail : 3 East End, West Calder, West Lothian EH55 8AB, UK.       }
{                                                                             }
{    FT5k "Final Release Candidate (7)" version - 11th December 1995          }
{                                                                             }
{    *** WIN32 compatible ***                                                 }
{                                                                             }
{    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,          }
{    EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED    }
{    MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. MICHAEL SCOTT   }
{    CANNOT BE HELD RESPONSIBLE FOR ANY LOSSES, EITHER DIRECT OR INDIRECT,    }
{    OF ANY PARTY MAKING USE OF THIS SOFTWARE. IN MAKING USE OF THIS          }
{    SOFTWARE, YOU AGREE TO BE BOUND BY THE TERMS AND CONDITIONS FOUND IN     }
{    THE ACCOMPANYING WINDOWS HELP FILE AND TO INDEMNIFY MICHAEL SCOTT        }
{    AGAINST ANY ACTION TAKEN AGAINST HIM WITH RESPECT TO YOUR OR YOUR        }
{    CLIENTS USE OF THIS SOFTWARE.                                            }
{                                                                             }
{*****************************************************************************}

unit WinG ;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, MMSystem ;

{ debugging }
type
  TDebugLevel = ( dlNone, dlShowMessage, dlDebugOutput, dlRaiseException ) ;

const Total  : longint = 0 ;
      Count  : longint = 0 ;
      DebugLevel : TDebugLevel = dlNone ;

{ WinG Types }

type
  PPointer = ^pointer ;
  PRGBQuad = ^TRGBQuad ;
  WING_DITHER_TYPE = word ;

const
  WING_DISPERSED_4x4 = 0 ;
  WING_DISPERSED_8x8 = 1 ;
  WING_CLUSTERED_4x4 = 2 ;

{ WinG DC's & WinG Bitmaps }

var WinGCreateDC : function : HDC {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGCreateBitmap : function( hWinGDC : HDC ;
                                 pHeader : PBitmapInfo ;
                                 ppBits  : PPointer ) : HBitmap {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGGetDIBPointer : function( hWinGBitmap : HBitmap ;
                                  pHeader     : PBitmapInfo ) : pointer {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGRecommendDIBFormat : function( pHeader : PBitmapInfo ) : Bool {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGGetDIBColorTable : function( hWinGDC         : HDC ;
                                     StartIndex      : word ;
                                     NumberOfEntries : word ;
                                     pColors         : PRGBQuad ) : word {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGSetDIBColorTable : function( hWinGDC         : HDC ;
                                     StartIndex      : word ;
                                     NumberOfEntries : word ;
                                     pColors         : PRGBQuad ) : word {$IFDEF WIN32} StdCall {$ENDIF} ;

{ Blts }

    WinGBitBlt : function( hdcDest      : HDC ;
                           nXOriginDest : SmallInt ;
                           nYOriginDest : SmallInt ;
                           nWidthDest   : SmallInt ;
                           nHeightDest  : SmallInt ;
                           hdcSrc       : HDC ;
                           nXOriginSrc  : SmallInt ;
                           nYOriginSrc  : SmallInt ) : Bool {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGStretchBlt : function( hdcDest      : HDC ;
                               nXOriginDest : SmallInt ;
                               nYOriginDest : SmallInt ;
                               nWidthDest   : SmallInt ;
                               nHeightDest  : SmallInt ;
                               hdcSrc       : HDC ;
                               nXOriginSrc  : SmallInt ;
                               nYOriginSrc  : SmallInt ;
                               nWidthSrc    : SmallInt ;
                               nHeightSrc   : SmallInt ) : Bool {$IFDEF WIN32} StdCall {$ENDIF} ;

{ Halftoning }

    WinGCreateHalftoneBrush : function( DC         : HDC ;
                                        Color      : TColorRef ;
                                        DitherType : WING_DITHER_TYPE ) : HBrush {$IFDEF WIN32} StdCall {$ENDIF} ;
    WinGCreateHalftonePalette : function : HPalette {$IFDEF WIN32} StdCall {$ENDIF} ;

{ WinG Error Exception }

type
  EWinGError = class( Exception ) ;
  EWinGDebug = class( Exception ) ;

{ TDIB }

type
  TDIB = class( TGraphic )
  private
    FBitmapInfo : PBitmapInfo ;
    InfoSize   : word ;
    FBitsHandle      : THandle ;
    FPixels    : pointer ;
    FPalette   : HPalette ;
    FScanWidth : word ; { number of bytes in a single raster line }
  protected
    procedure Changed( Sender : TObject ) ; virtual ;
    procedure FreePalette ; dynamic ;
    procedure DisposeBitmapInfo ;
    function  GetEmpty: Boolean; override;
    function  GetHeight: integer ; override;
    procedure SetHeight(Value: integer); override;
    function  GetWidth: integer; override;
    procedure SetWidth(Value: integer); override;
    function  GetPalette : HPalette ; virtual ;
    procedure CalculateImageSize ; virtual ;
    procedure FreeImage ; virtual ;
    procedure AllocateImage ; virtual ;
    procedure LockPixels ; dynamic ;
    procedure SetBitsHandle( Value : THandle ) ; virtual ;
    procedure SetPixels( Value : pointer ) ; virtual ;
    procedure InternalClear ; virtual ;
  public
    constructor Create ; override ;
    destructor Destroy ; override ;
    procedure Clear ; virtual ;
    procedure Assign( Source : TPersistent ) ; override ;
    procedure AssignTo( Dest : TPersistent ) ; override ;
    function  CreateCopy: TGraphic; virtual ;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override ;
    procedure RectToCanvas( DestinationRect   : TRect ;
                            DestinationCanvas : TCanvas ;
                            SourceRect        : TRect ) ; virtual ;
    function  RemapcolorTable( FromBitmapInfo   : PBitmapInfo ;
                               MatchingPalette  : HPalette ;
                               TransparentColor : byte ) : byte ;
    property BitmapInfo : PBitmapInfo read FBitmapInfo ;
    property Palette : HPalette read GetPalette ;
    property BitsHandle : THandle read FBitsHandle write SetBitsHandle ;
    property Pixels : pointer read FPixels write SetPixels ;
  end ;

const
  CoordMultiplier = 65536.000000 ;

  { default values }
  defAnimationFrames = 1 ;
  defAnimationInterval = 20 ; { milliseconds }

const
  BitmapInfoSize   = sizeof( TBitmapInfoHeader ) + sizeof( TRGBQuad ) * 256 ;
  LogPaletteSize   = sizeof( TLogPalette ) + sizeof( TPaletteEntry ) * 255 ;
  DefaultFrameInterval = 20 ;

type
  TDIBFormat = ( dfAuto, dfBottomUp, dfTopDown ) ;

{ TWinGCanvas }

type
  TWinGCanvas = class( TCanvas )
  private
    FWinGBitmap        : HBITMAP ;
    FOriginalBitmap    : HBITMAP ;
    FOriginalPalette   : HPALETTE ;
    FBitmapBits        : pointer ;
    FBitmapInfo        : PBitmapInfo ;
    Orientation        : SmallInt ;
    FPalette           : HPalette ;
    FDIBFormat         : TDIBFormat ;
    FOnSetupColorTable : TNotifyEvent ;
    FWinGDCValid       : boolean ;
    procedure FreeContext ;
  protected
    procedure FreePalette ; virtual ;
    procedure CreateHandle ; override ;
    function  GetPalette : HPalette ; virtual ;
    procedure SetPalette( Value : HPalette ) ; virtual ;
    procedure SetDIBFormat( Value : TDIBFormat ) ; virtual ;
    procedure SetupColorTable ; dynamic ;
  public
    constructor Create( AWidth, AHeight : word ) ;
    destructor Destroy ; override ;
    procedure CopyColorTableFromDIB( ABitmapInfo : PBitmapInfo ;
                                     CreatePaletteNow : boolean ) ; virtual ;
    procedure CloneColorTable( SourceWinGCanvas  : TWinGCanvas ;
                               CreatePaletteNow  : boolean ) ; virtual ;
    procedure CopyDIB( ADIB : TDIB ) ; virtual ;
    procedure Resize( AWidth, AHeight : SmallInt ) ; dynamic ;
    procedure WinGCopy( DestX, DestY, DestWidth, DestHeight : SmallInt ;
                        DestCanvas : TCanvas ;
                        SourceX, SourceY : SmallInt ) ; virtual ;
    procedure WinGStretchCopy( DestX, DestY, DestWidth, DestHeight : SmallInt ;
                               DestCanvas : TCanvas ;
                               SourceX, SourceY,
                               SourceWidth, SourceHeight : SmallInt ) ; virtual ;
    procedure TransparentBlt( DIB  : TDIB ;
                              x, y : SmallInt ;
                              TransparentValue : byte ) ; virtual ;
    property Palette : HPalette read GetPalette write SetPalette ;
    property BitmapBits : pointer read FBitmapBits ;
    property BitmapInfo : PBitmapInfo read FBitmapInfo ;
    property OnSetupColorTable : TNotifyEvent read FOnSetupColorTable
                              write FOnSetupColorTable ;
    property DIBFormat : TDIBFormat read FDIBFormat write SetDIBFormat ;
    property WinGDCValid : boolean read FWinGDCValid ;
  end;

  { TWinGDIB - a TDIB with a TWinGCanvas to draw on }

  TWinGDIB = class( TDIB )
  private
    FCanvas : TWinGCanvas ;
  protected
    procedure Changed( Sender : TObject ) ; override ;
    function  GetCanvas : TWinGCanvas ; virtual ;
  public
    destructor Destroy ; override ;
    property Canvas : TWinGCanvas read GetCanvas ;
  end ;

  { TWinGDIBCanvas - the canvas of a TWinGDIB }

  TWinGDIBCanvas = class( TWinGCanvas )
  private
    FWinGDIB : TWinGDIB ;
  protected
    procedure CreateHandle ; override ;
  public
    constructor Create( AWinGDIB : TWinGDIB ) ;
  end ;

  { TWinGSurface }

  TWinGSurface = class( TCustomControl )
  private
    FWinGCanvas : TWinGCanvas ;
    procedure WMSize( var Message : TWMSize ) ; message wm_Size ;
    procedure WMEraseBkgnd( var Message : TWmEraseBkgnd ) ; message WM_ERASEBKGND ;
    procedure CMColorChanged( var Message : TMessage ) ; message CM_ColorChanged ;
  protected
    procedure CreateParams( var Params : TCreateParams ) ; override ;
    procedure ClearOnColorChanged ; dynamic ;
    function  GetPalette : HPalette ; override ;
    function  GetDIBFormat : TDIBFormat ; virtual ;
    procedure SetDIBFormat( Value : TDIBFormat ) ; virtual ;
    procedure Paint ; override ;
  public
    constructor Create( AOwner : TComponent ) ; override ;
    destructor Destroy ; override ;
    property Canvas ;
    property WinGCanvas : TWinGCanvas read FWinGCanvas write FWinGCanvas ;
  published
    property Align ;
    property OnMouseDown ;
    property OnMouseMove ;
    property OnMouseUp ;
    property ParentColor ;
    property Width default 200 ;
    property Height default 150 ;
    property Color ;
    property DIBFormat : TDIBFormat read GetDIBFormat write SetDIBFormat default dfAuto ;
  end ;

  TSpriteAbs = class( TComponent ) ;
  TSprite = class ;

  TssOptions = ( ssTiled ) ;
  TSpriteSurfaceOptions = set of TssOptions ;
  TImageChanged = ( icBackground, icSprite ) ;
  TImageChangedSet = set of TImageChanged ;
  TSpriteSurface = class ;
  TNextFrameEvent = procedure( SpriteSurface           : TSpriteSurface ;
                               Ticks                   : longint ;
                               TicksSinceLastFrame     : longint ;
                               var OverrunFrames       : longint ;
                               var DoDefaultProcessing : boolean ) of object ;


  { TSpriteSurface }

  TSpriteSurface = class( TWinGSurface )
  private
    FFrameInterval     : word ;
    FMaxOverrun        : word ;
    DirtyRects         : TList ;
    CombinedRects      : TList ;
    FBackground        : TDIB ;
    FOptions           : TSpriteSurfaceOptions ;
    FPaletteSource     : TSpriteAbs ;
    FSprites           : TList ;
    FBackgroundCanvas  : TWinGCanvas ;
    FOnNextFrame       : TNextFrameEvent ;
    FDebugging         : boolean ;
    procedure WMSize( var Message : TWMSize ) ; message wm_Size ;
    procedure CMColorChanged( var Message : TMessage ) ; message CM_ColorChanged ;
    procedure ClearList( List : TList ) ;
    procedure CombineRects ;
    procedure SetDIBFormat( Value : TDIBFormat ) ; override ;
  protected
    LastTick  : longint ;
    procedure Loaded ; override ;
    function  CreateBackgroundDIB : TDIB ; dynamic ;
    procedure ClearOnColorChanged ; override ;
    procedure NextFrame( Ticks               : longint ;
                         TicksSinceLastFrame : longint ;
                         var OverrunFrames   : longint ) ; virtual ;
    procedure CheckAnimation( ATick : longint ) ; virtual ;
    procedure SetFrameInterval( Value : word ) ; virtual ;
    function  GetBackground : TGraphic ; virtual ;
    procedure SetBackground( Value : TGraphic ) ; virtual ;
    procedure SetOptions( Value : TSpriteSurfaceOptions ) ; virtual ;
    procedure PaintBackgroundCanvas ; virtual ;
    function  GetMasterDIB : TDIB ; virtual ;
    procedure SetPaletteSource( Value : TSpriteAbs ) ; virtual ;
    procedure Notification( AComponent : TComponent ;
                            Operation  : TOperation ) ; override ;
    procedure BackgroundChanged( Sender : TObject ) ; virtual ;
  public
    nOverruns : word ;
    constructor Create( AOwner : TComponent ) ; override ;
    destructor Destroy ; override ;
    procedure AddSprite( ASprite : TSprite ) ; virtual ;
    procedure RemoveSprite( ASprite : TSprite ) ; virtual ;
    procedure SpriteImageChanged( Sprite : TSprite ) ; virtual ;
    procedure PaletteSourceChanged ; virtual ;
    property MasterDIB : TDIB read GetMasterDIB ;
    property Sprites : TList read FSprites ;
    property BackgroundCanvas : TWinGCanvas read FBackgroundCanvas ;
  published
    property FrameInterval : word read FFrameInterval write SetFrameInterval
                             default DefaultFrameInterval ;
    property Background : TGraphic read GetBackground write SetBackground ;
    property Options : TSpriteSurfaceOptions read FOptions write SetOptions ;
    property PaletteSource : TSpriteAbs read FPaletteSource
                             write SetPaletteSource ;
    property OnNextFrame : TNextFrameEvent read FOnNextFrame write FOnNextFrame ;
    { Debugging currently has no effect - retained for backward compatibility }
    property Debugging : boolean read FDebugging write FDebugging default false ;
  end ;

  TCoord = record
             case byte of
               0 : ( Value : longint ) ;
               1 : ( Frac  : word ;
                     Int   : SmallInt ) ;
           end ;

  TFrameEvent = procedure( Sender              : TObject ;
                           Ticks               : longint ;
                           TicksSinceLastFrame : longint ;
                           FrameNumber         : word ;
                           var DIB             : TDIB ;
                           var Rect            : TRect ) of object ;
  TFrameNumberEvent = procedure( Sender              : TObject ;
                                 Ticks               : longint ;
                                 TicksSinceLastFrame : longint ;
                                 var FrameNumber     : word ) of object ;
  TPaintEvent = procedure( Sprite                : TSprite ;
                           Canvas                : TCanvas ;
                           Ticks                 : longint ;
                           TicksSinceLastFrame   : longint ;
                           var DefaultProcessing : boolean ) of object ;
  TCheckLimitsEvent = procedure( Sprite : TSprite ;
                                 var DoDefaultProcessing : boolean ) of object ;
  TNatural = 1..65535 ;

  {TspOptions = ( ssDemoBounce, ssAutoReverseAnim, ssBackwardAnim ) ;}
  TspOptions = ( soDemoBounce, soAutoReverseAnim, soBackwardAnim ) ;
  TSpriteOptions = set of TspOptions ;

  { TSprite }

  TSprite = class( TSpriteAbs )
  private
    FSpriteSurface : TSpriteSurface ;
    FOptions       : TSpriteOptions ;
    FVisible       : boolean ;

    { position and size }
    FX : TCoord ;
    FY : TCoord ;
    FW : SmallInt ;
    FH : SmallInt ;

    { actual position and size on the sprite surface }
    ActualX : SmallInt ;
    ActualY : SmallInt ;
    ActualW : SmallInt ;
    ActualH : SmallInt ;

    { velocity }
    FVelocityX : TCoord ;
    FVelocityY : TCoord ;

    { acceleration }
    FAccelerationX : TCoord ;
    FAccelerationY : TCoord ;

    { Bitmap }
    FImage             : TDIB ;
    FTransparentValue  : byte ;
    FAnimationFrames   : TNatural ;
    FAnimationInterval : TNatural ;
    FAnimationStart    : word ;
    FAnimationStop     : word ;
    FFrames            : TList ;

    { events }
    FOnGetFrameNumber : TFrameNumberEvent ;
    FOnGetFrame       : TFrameEvent ;
    FOnCheckLimits    : TCheckLimitsEvent ;
    FOnPaint          : TPaintEvent ;
  protected
    FrameWidth    : word ;
    function  CreateImageDIB : TDIB ; dynamic ;
    procedure SetSpriteSurface( ASpriteSurface : TSpriteSurface ) ; virtual ;
    procedure SetOptions( Value : TSpriteOptions ) ; virtual ;
    function  GetImage : TGraphic ; virtual ;
    procedure SetImage( Value : TGraphic ) ; virtual ;
    function  GetX : SmallInt ; virtual ;
    procedure SetX( Value : SmallInt ) ; virtual ;
    function  GetY : SmallInt ; virtual ;
    procedure SetY( Value : SmallInt ) ; virtual ;
    function  GetVelocityX : double ; virtual ;
    procedure SetVelocityX( Value : double ) ; virtual ;
    function  GetVelocityY : double ; virtual ;
    procedure SetVelocityY( Value : double ) ; virtual ;
    function  GetAccelerationX : double ; virtual ;
    procedure SetAccelerationX( Value : double ) ; virtual ;
    function  GetAccelerationY : double ; virtual ;
    procedure SetAccelerationY( Value : double ) ; virtual ;
    procedure SetAnimationFrames( Value : TNatural ) ; virtual ;
    procedure CreateFrames ; virtual ;
    procedure GetFrameNumber( Ticks : longint ;
                              TicksSinceLastFrame : longint ;
                              var FrameNumber : word ) ; virtual ;
    procedure GetFrame( Ticks               : longint ;
                        TicksSinceLastFrame : longint ;
                        var DIB             : TDIB ;
                        var FrameRect       : TRect ) ; virtual ;
    procedure SetAnimationStart( Value : word ) ; virtual ;
    procedure SetAnimationStop( Value : word ) ; virtual ;
    procedure CheckBounce ; virtual ;
    procedure CheckLimits ; virtual ;
    procedure Move( TicksSinceLastFrame : longint ) ; virtual ;
    procedure RepaintBackground ; virtual ;
    procedure Paint( Canvas : TCanvas ;
                     Ticks  : longint ;
                     TicksSinceLastFrame : longint ) ; virtual ;
    procedure SetVisible( Value : boolean ) ; virtual ;
    procedure ImageChanged( Sender : TObject ) ; virtual ;
  public
    LastVelocityX : SmallInt ; { meant to aid 'bounce damping' type calcs }
    LastVelocityY : SmallInt ;
    ActualTransparentValue : byte ;
    property Frames : TList read FFrames ;
    constructor Create( AOwner : TComponent ) ; override ;
    destructor Destroy ; override ;
  published
    property X : SmallInt read GetX write SetX ;
    property Y : SmallInt read GetY write SetY ;
    property W : SmallInt read FW write FW ;
    property H : SmallInt read FH write FH ;
    property VelocityX : double read GetVelocityX write SetVelocityX ;
    property VelocityY : double read GetVelocityY write SetVelocityY ;
    property AccelerationX : double read GetAccelerationX write SetAccelerationX ;
    property AccelerationY : double read GetAccelerationY write SetAccelerationY ;
    property Image : TGraphic read GetImage write SetImage ;
    property TransparentValue : byte read FTransparentValue
                                write FTransparentValue ;
    property AnimationFrames : TNatural read FAnimationFrames write SetAnimationFrames
                               default defAnimationFrames ;
    property AnimationInterval : TNatural read FAnimationInterval
                                 write FAnimationInterval
                                 default defAnimationInterval ;
    property AnimationStart : word read FAnimationStart
                              write SetAnimationStart ;
    property AnimationStop : word read FAnimationStop write
                             SetAnimationStop ;
    property SpriteSurface : TSpriteSurface read FSpriteSurface write
                             SetSpriteSurface ;
    property Options : TSpriteOptions read FOptions write SetOptions ;
    property OnGetFrameNumber : TFrameNumberEvent read FOnGetFrameNumber
                                write FOnGetFrameNumber ;
    property OnGetFrame : TFrameEvent read FOnGetFrame write FOnGetFrame ;
    property OnCheckLimits : TCheckLimitsEvent read FOnCheckLimits write FOnCheckLimits ;
    property OnPaint : TPaintEvent read FOnPaint write FOnPaint ;
    property Visible : boolean read FVisible write SetVisible default true ;
  end ;

function  PaletteFromDIB( BitmapInfo : PBitmapInfo ) : HPalette ;

const
  mpBackground = nil ;

const WinGLastTick : longint = 0 ;

procedure CheckWinGAnimation ;

{ Debugging and error reporting }

procedure WinGDebug( const s : string ) ;
procedure WinGError( const s : string ) ;
procedure DumpColorTable( const Filename : string ;
                          const Message  : string ;
                          BitmapInfo     : PBitmapInfo ) ;


implementation

uses LibConst, Consts, Dialogs,
     {$IFDEF Win32} Trans32 {$ELSE} TransBlt {$ENDIF},
     IniFiles ;

const
  IniFileName = 'SpriteKt.ini' ;

type TLongints = array[ 0..16000 ] of longint ;

const
  Longints       : ^TLongints = nil ;
  DebugBuffer    : PChar = nil ;
  SpriteSurfaces : TList = nil ;

  nLongints      : SmallInt = -1 ;



procedure AHIncr; far; external 'KERNEL' index 114;

const Spaces : word = 0 ;

procedure LogIt( const s : string ) ;

var T : Text ;

begin
  assign( T, '\WinGLog.txt' ) ;
  if FileExists( '\WinGLog.txt' ) then append( T ) else rewrite( T ) ;
  if Spaces > 0 then write( T, '':Spaces ) ;
  writeln( T, s ) ;
  close( T ) ;
end ;


procedure WinGDebug( const s : string ) ;

begin
  case DebugLevel of
    dlShowMessage : ShowMessage( s ) ;
    dlDebugOutput : if DebugBuffer <> nil then
                      OutputDebugString( StrPCopy( DebugBuffer, s + #13 ) ) ;
    dlRaiseException : Raise EWinGDebug.Create( s ) ;
  end ;
end ;


procedure WinGError( const s : string ) ;

begin
  Raise EWinGError.Create( s )
end ;


procedure CantGetDC ;

begin
  WinGDebug( 'Unable to get a Device Context' ) ;
end ;


procedure Message( const s : string ) ;

begin
  LogIt( s ) ;
  MessageDlg( s, mtInformation, [ mbOK ], 0 ) ;
end ;


function  GetColorsUsed( BitmapInfo : PBitmapInfo ) : SmallInt ;

begin
  with BitmapInfo^.bmiHeader do begin
    Result := biClrUsed ;
    if ( Result = 0 ) and
       ( biBitCount in [ 1, 4, 8 ] ) then Result := 1 shl biBitCount ;
  end ;
end ;


procedure DumpcolorTable( const Filename : string ;
                          const Message  : string ;
                          BitmapInfo     : PBitmapInfo ) ;

var T : Text ;
    i, n : SmallInt ;

begin
  assign( T, Filename ) ;
  rewrite( T ) ;
  try
    writeln( T, Message ) ;
    if Assigned( BitmapInfo ) then with BitmapInfo^, bmiHeader do begin
      n := GetColorsUsed( BitmapInfo ) ;
      {$IFDEF Win32}
      writeln( T, Format( 'PBitmapInfo(%d)', [ SmallInt( BitmapInfo ) ] ) ) ;
      {$ELSE}
      writeln( T, Format( 'PBitmapInfo(%.4x:%.4x)',
                          [ Seg( BitmapInfo^ ), Ofs( BitmapInfo^ ) ]
                           ) ) ;
      {$ENDIF}
      writeln( T, 'biWidth=', biWidth ) ;
      writeln( T, 'biHeight=', biHeight ) ;
      writeln( T, 'biClrUsed=', n ) ;
      writeln( T, '     R      G      B' ) ;
      for i := 0 to n - 1 do with bmiColors[ i ] do
        writeln( T, rgbRed:6, ' ', rgbGreen:6, ' ', rgbBlue:6 ) ;
    end else writeln( T, 'BitmapInfo=nil!' ) ;
  finally
    close( T ) ;
  end ;
end ;


procedure GetBitmapData( Stream       : TStream ;
                         BitsHandle   : THandle ;
                         BitsByteSize : Longint);

var P : pointer ;

begin
  P := GlobalLock( BitsHandle ) ;
  if P = nil then WinGDebug( 'GlobalLock failed in GetBitmapData' ) ;
  Stream.ReadBuffer( P^, BitsByteSize ) ;
  GlobalUnlock( BitsHandle ) ;
end;


procedure LoadDIB( Stream : TStream ;
                   var BitmapInfo : PBitmapInfo ;
                   var BitmapInfoSize : word ;
                   var DIBBits        : THandle ) ;

var BitmapFileHeader : TBitmapFileHeader ;
    BitmapInfoHeader : TBitmapInfoHeader ;
    Bytes            : longint ;

begin
  BitmapInfo := nil ;
  BitmapInfoSize := 0 ;
  DIBBits := 0 ;

  with Stream do begin
    ReadBuffer( BitmapFileHeader, sizeof( BitmapFileHeader ) ) ;
    with BitmapFileHeader do begin

      { check format etc. }
      if BitmapFileHeader.bfType <> $4D42 then  { 'BF' }
        WinGError( 'not a Windows Bitmap' ) ;

      { read bitmap info header }
      ReadBuffer( BitmapInfoHeader, sizeof( BitmapInfoHeader ) ) ;
      with BitmapInfoHeader do begin

        { check colors & compression to make sure we can handle it }
        if not ( biBitCount in [ 1, 4, 8 ] ) or ( biCompression <> bi_RGB ) then
          WinGError( 'unsupported bitmap format' ) ;

        { update image size }
        biSizeImage := ( ( ( biWidth * biBitCount ) + 31 ) div 32 ) * 4 * biHeight ;

        { make sure other fields are correct }
        case biBitCount of
          1 : biClrUsed := 2 ;
          4 : biClrUsed := 16 ;
        end ;

        { calculate size of BitmapInfo & create }
        BitmapInfoSize := sizeof( BitmapInfo^ ) +
                          ( biClrUsed - 1 ) * sizeof( TRGBQuad ) ;
        GetMem( BitmapInfo, BitmapInfoSize ) ;
        try
          with BitmapInfo^ do begin
            { copy bitmap info header and load color table }
            bmiHeader := BitmapInfoHeader ;
            Bytes := BitmapInfoSize - sizeof( bmiHeader ) ;
            ReadBuffer( bmiColors, Bytes ) ;

            { allocate handle for bitmap bits & load }
            DIBBits := GlobalAlloc( gmem_Moveable, biSizeImage ) ;
            try
              try
                Stream.ReadBuffer( GlobalLock( DIBBits )^, biSizeImage ) ;
              finally
                GlobalUnlock( DIBBits ) ;
              end ;
            except
              GlobalFree( DIBBits ) ;
              DIBBits := 0 ;
              Raise ;
            end ;
          end ;
        except
          FreeMem( BitmapInfo, BitmapInfoSize ) ;
          BitmapInfo := nil ;
          Raise ;
        end ;
      end ;
    end ;
  end ;
end ;


procedure SwapRedBlue( NumColors : SmallInt ;
                       var RGBQuad ) ;

var Entries : array[ 0..255 ] of TRGBQuad absolute RGBQuad ;
    Temp    : byte ;

begin
  dec( NumColors ) ;
  while NumColors >= 0 do with Entries[ NumColors ] do begin
    Temp := rgbRed ;
    rgbRed := rgbBlue ;
    rgbBlue := Temp ;
    dec( NumColors ) ;
  end ;
end ;


function  PaletteFromDIB( BitmapInfo : PBitmapInfo ) : HPalette ;

var LogPalette : PLogPalette ;
    LogPaletteSize : word ;
    i              : SmallInt ;
    ncolors       : SmallInt ;
    DC             : HDC ;
    nReserved      : SmallInt ;
    HalfReserved   : SmallInt ;

begin
  with BitmapInfo^, bmiHeader do begin
    ncolors := GetColorsUsed( BitmapInfo ) ;
    LogPaletteSize := sizeof( TLogPalette ) +
                      ( ncolors - 1 ) * sizeof( TPaletteEntry ) ;
    GetMem( LogPalette, LogPaletteSize ) ;
    try
      with LogPalette^ do begin
        palVersion := $300 ;
        palNumEntries := 256 ;

        { get entries from the system palette }
        DC := GetDC( 0 ) ;
        if DC = 0 then CantGetDC ;
        try
          nReserved := GetDeviceCaps( DC, NUMRESERVED ) ;
          HalfReserved := nReserved div 2 ;
          if nReserved > 0 then begin
            if ( GetSystemPaletteEntries( DC, 0, HalfReserved, palPalEntry ) = 0 ) or
               ( GetSystemPaletteEntries( DC, 256 - HalfReserved, HalfReserved,
                                     palPalEntry[ 256 - HalfReserved ] ) = 0 ) then
              WinGDebug( 'GetSystemPaletteEntries failed in PaletteFromDIB' ) ;
          end ;
        finally
          ReleaseDC( 0, DC ) ;
        end ;

        { copy the rest of the colors from the DIB color table }
        if ncolors > 256 - nReserved then ncolors := 256 - nReserved ;
        for i := HalfReserved + ncolors - 1 downto HalfReserved do
          with palPalEntry[ i ], BitmapInfo^.bmiColors[ i ] do
        begin
          peRed := rgbRed ;
          peGreen := rgbGreen ;
          peBlue := rgbBlue ;
          peFlags := PC_NOCOLLAPSE ;
        end ;

        { set any remaining entries to black }
        for i := ncolors + HalfReserved to 255 - HalfReserved do
          with palPalEntry[ i ] do
        begin
          peRed := 0 ;
          peGreen := 0 ;
          peBlue := 0 ;
          peFlags := PC_NOCOLLAPSE ;
        end ;

        { create the palette }
        Result := CreatePalette( LogPalette^ ) ;
        if Result = 0 then WinGDebug( 'Unable to create HPalette' ) ;
      end ;
    finally
      FreeMem( LogPalette, LogPaletteSize ) ;
    end ;
  end ;
end ;


function  ClonePalette( APalette : HPalette ) : HPalette ;

var LogPalette : PLogPalette ;
    DC         : HDC ;

begin
  if APalette = 0 then WinGDebug( 'Empty palette passed to ClonePalette' ) ;
  GetMem( LogPalette, LogPaletteSize ) ;
  try
    with LogPalette^ do begin
      palVersion := $300 ;
      if GetObject( APalette, sizeof( integer ), @palNumEntries ) = 0 then
        WinGDebug( 'GetObject failed in ClonePalette' ) ;
      DC := GetDC( 0 ) ;
      if DC = 0 then CantGetDC ;
      try
        if GetPaletteEntries( DC, 0, palNumEntries, palPalEntry ) = 0 then
          WinGDebug( 'GetPaletteEntries failed in ClonePalette' ) ;
      finally
        ReleaseDC( 0, DC ) ;
      end ;
      Result := CreatePalette( LogPalette^ ) ;
      if Result = 0 then WinGDebug( 'CreatePalette failed' ) ;
    end ;
  finally
    FreeMem( LogPalette, LogPaletteSize ) ;
  end ;
end ;


function MemAlloc(Size: Longint): Pointer;
var
  Handle: THandle;
begin
  if Size < 65535 then
    GetMem(Result, Size)
  else
  begin
    Handle := GlobalAlloc(GMEM_MOVEABLE, Size);
    if Handle = 0 then WinGDebug( 'GlobalAlloc failed in MemAlloc - out of memory?' ) ;
    try
      Result := GlobalLock(Handle);
      if Result = nil then WinGDebug( 'GlobalLock failed in MemAlloc' ) ;
    except
      GlobalFree( Handle ) ;
      Raise ;
    end ;
  end;
end;


procedure RemapDuplicates( var palPalEntry : TPaletteEntry ) ;

var Entries : array[ 0..255 ] of TPaletteEntry absolute palPalEntry ;
    SortArray : array[ 0..255 ] of byte ;
    Dups      : array[ 0..255 ] of boolean ;
    NextIndex : SmallInt ;
    NewEntry : TPaletteEntry ;
    RemappedEntries : TList ;
    AnEntry         : PPaletteEntry ;

  function  Less( First, Second : SmallInt ) : boolean ;

  var Entry1, Entry2 : PPaletteEntry ;

  begin
    Entry1 := @Entries[ SortArray[ First ] ] ;
    Entry2 := @Entries[ SortArray[ Second ] ] ;
    Result := true ;
    with Entry1^ do begin
      if peGreen < Entry2^.peGreen then exit ;
      if peGreen = Entry2^.peGreen then begin
        if peBlue < Entry2^.peBlue then exit ;
        if peBlue = Entry2^.peBlue then begin
          if peRed < Entry2^.peRed then exit ;
          if peRed = Entry2^.peRed then begin
            { mark the entries as duplicates }
            Dups[ First ] := true ;
            Dups[ Second ] := true ;
            if ( SortArray[ First ] < 10 ) or
               ( SortArray[ First ] > 245 ) then
            begin
              if ( SortArray[ Second ] > 9 ) or
                 ( SortArray[ Second ] < 246 ) then exit ;
            end ;
          end ;
        end ;
      end ;
    end ;
    Result := false ;
  end ;

  procedure QuickSort( left, right : SmallInt ) ;

  var i, j, middle : SmallInt ;
      Temp         : byte ;
      TempBool     : boolean ;

  begin
    i := left ; j := right ; middle := ( left + right ) div 2 ;
    repeat
      while ( i <> middle ) and Less( i, middle ) do inc( i ) ;
      while ( j <> middle ) and Less( middle, j ) do dec( j ) ;
      if i <= j then begin
        if i <> j then begin
          Temp := SortArray[ i ] ;
          SortArray[ i ] := SortArray[ j ] ;
          SortArray[ j ] := Temp ;
          TempBool := Dups[ i ] ;
          Dups[ i ] := Dups[ j ] ;
          Dups[ j ] := TempBool ;
          if middle = i then middle := j else
          if middle = j then middle := i ;
        end ;
        inc( i ) ;
        dec( j ) ;
      end ;
    until i > j ;
    if left < j then QuickSort( left, j ) ;
    if i < right then QuickSort( i, right ) ;
  end;

  procedure Remap( Index : SmallInt ) ;

    function  EqualsNextEntry : boolean ;

    begin
      { returns true if the new entry candidate equals the next entry }
      with Entries[ SortArray[ NextIndex ] ] do
        Result := ( peRed = NewEntry.peRed ) and
                  ( peGreen = NewEntry.peGreen ) and
                  ( peBlue = NewEntry.peBlue ) ;
    end ;

    procedure IncNewEntry ;

    begin
      { increments the color of the new entry candidate }
      with NewEntry do begin
        inc( peRed ) ;
        if peRed = 0 then begin
          inc( peBlue ) ;
          if peBlue = 0 then inc( peGreen ) ;
        end ;
      end ;
    end ;

  var NotedEntry : PPaletteEntry ;

  begin
    { get the next free entry }
    while ( NextIndex < 256 ) and EqualsNextEntry do begin
      repeat
        inc( NextIndex ) ;
      until ( NextIndex > 255 ) or not EqualsNextEntry ;
      IncNewEntry ;
    end ;

    { take a note of this one }
    new( NotedEntry ) ;
    NotedEntry^ := NewEntry ;

    { store the actual entry index in the peFlags value }
    NotedEntry^.peFlags := SortArray[ Index ] ;
    RemappedEntries.Add( TObject( NotedEntry ) ) ;
    IncNewEntry ;
  end ;

  function  Equal( Entry1, Entry2 : TPaletteEntry ) : boolean ;

  begin
    with Entry1 do
      Result := ( peRed = Entry2.peRed ) and ( peGreen = Entry2.peGreen ) and
                ( peBlue = Entry2.peBlue ) ;
  end ;

var i : SmallInt ;
    FirstDupe     : TPaletteEntry ;

begin
  { create the sort array and clear the duplicate flags }
  for i := 0 to 255 do
    SortArray[ i ] := i ;
  FillChar( Dups, sizeof( Dups ), 0 ) ;

  { sort the entries }
  QuickSort( 0, 255 ) ;

  { fix up any duplicates }
  i := 0 ;
  NextIndex := 0 ;
  NewEntry := Entries[ SortArray[ 0 ] ] ;
  RemappedEntries := TList.Create ;
  try
    while i < 256 do begin
      if Dups[ i ] then begin
        { remap entries which are duplicates of this one }
        FirstDupe := Entries[ SortArray[ i ] ] ;
        inc( i ) ;
        while ( i < 256 ) and
              Equal( FirstDupe, Entries[ SortArray[ i ] ] ) and Dups[ i ] do
        begin
          Remap( i ) ;
          inc( i ) ;
        end ;
      end else inc( i ) ;
    end ;

    { change the entries }
    with RemappedEntries do for i := Count - 1 downto 0 do begin
      AnEntry := PPaletteEntry( RemappedEntries[ i ] ) ;
      Entries[ AnEntry^.peFlags ] := AnEntry^ ;
      Entries[ AnEntry^.peFlags ].peFlags := PC_NOCOLLAPSE ;
      dispose( AnEntry ) ;
    end ;
  finally
    RemappedEntries.Free ;
  end ;
end ;


function PaletteFromW3DIB(var BI: TBitmapInfo): HPALETTE;
var
  DstPal: PLogPalette;
  Colors, n: SmallInt;
  Size: Longint;
  DC: HDC;
  Focus: HWND;
  SysPalSize: SmallInt;
  I: SmallInt;
begin
  Result := 0;

  { If the ClrUsed field of the header is non-zero, it means that we could
    have a short color table }
  Colors := GetColorsUsed( @BI ) ;

  if Colors <= 2 then Exit;

  Size := SizeOf(TLogPalette) + ((Colors - 1) * SizeOf(TPaletteEntry));
  DstPal := MemAlloc(Size);
  try
    FillChar(DstPal^, Size, 0);
    with DstPal^ do
    begin
      palNumEntries := Colors;
      palVersion := $300;
      Focus := GetFocus;
      DC := GetDC(Focus);
      if DC = 0 then CantGetDC ;
      try
        SysPalSize := GetDeviceCaps(DC, SIZEPALETTE);
        if (Colors = 16) and (SysPalSize >= 16) then
        begin
          { Ignore the disk image of the palette for 16 color bitmaps use
            instead the first 8 and last 8 of the current system palette }
          if SysPalSize > 0 then begin
            if GetSystemPaletteEntries(DC, 0, 8, palPalEntry) = 0 then
              WinGDebug( 'GetSystemPaletteEntries failed in PaletteFromW3DIB' ) ;
            I := 8;
            if GetSystemPaletteEntries(DC, SysPalSize - I, I, palPalEntry[I]) = 0 then
              WinGDebug( 'GetSystemPaletteEntries failed in PaletteFromW3DIB' ) ;
          end ;
        end
        else
          { Copy the palette for all others (i.e. 256 colors) }
          for N := 0 to Colors - 1 do
          begin
            palPalEntry[N].peRed := BI.bmiColors[N].rgbRed;
            palPalEntry[N].peGreen := BI.bmiColors[N].rgbGreen;
            palPalEntry[N].peBlue := BI.bmiColors[N].rgbBlue;
            palPalEntry[N].peFlags := 0;
          end;
      finally
        ReleaseDC(Focus, DC);
      end;
    end;
    Result := CreatePalette(DstPal^);
    if Result = 0 then WinGDebug( 'CreatePalette failed in PaletteFromW3DIB' ) ;
  finally
    FreeMem(DstPal, Size);
  end;
end;


procedure TryDeleteObject( AnObject    : THandle ;
                           const Where : string ) ;

begin
  if not DeleteObject( AnObject ) then
    WinGDebug( Format( 'DeleteObject($%.4X) failed in %s',
                       [ AnObject, Where ] ) ) ;
end ;


{ TDIB }

constructor TDIB.Create ;

begin
  inherited Create ;
  Clear ;
end ;


destructor TDIB.Destroy ;

begin
  inherited Destroy ;
  DisposeBitmapInfo ;
  if ( FPixels <> nil ) and ( FBitsHandle <> 0 ) then
    GlobalUnlock( FBitsHandle ) ;
  if FBitsHandle <> 0 then GlobalFree( FBitsHandle ) ;
  FreePalette ;
end ;


procedure TDIB.Changed( Sender : TObject ) ;

begin
  { need this because inherited Changed is a static method :-( }
  inherited Changed( Sender ) ;
end ;


procedure TDIB.FreePalette ;

begin
  if FPalette <> 0 then begin
    try
      TryDeleteObject( FPalette, 'TDIB.FreePalette' ) ;
    finally
      FPalette := 0 ;
    end ;
  end ;
end ;


procedure TDIB.DisposeBitmapInfo ;

begin
  if Assigned( FBitmapInfo ) then FreeMem( FBitmapInfo, InfoSize ) ;
  FBitmapInfo := nil ;
  InfoSize := 0 ;
end ;


procedure TDIB.InternalClear ;

begin
  if ( FBitmapInfo = nil ) or ( InfoSize <> BitmapInfoSize ) then begin
    DisposeBitmapInfo ;
    InfoSize := BitmapInfoSize ;
    GetMem( FBitmapInfo, InfoSize ) ;
  end ;

  { create a TBitmapInfo structure with default 8 bit 256 colors }
  with FBitmapInfo^.bmiHeader do begin
    biSize := sizeof( TBitmapInfoHeader ) ;
    biWidth := 0 ;
    biHeight := 0 ;
    biPlanes := 1 ;
    biBitCount := 8 ;
    biCompression := BI_RGB ;
    biSizeImage := 0 ;
    biXPelsPerMeter := 0 ;
    biYPelsPerMeter := 0 ;
    biClrUsed := 256 ;
    biClrImportant := 256 ;
  end ;

  { clear the color table }
  FillChar( FBitmapInfo^.bmiColors, SizeOf( TRGBQuad ) * 256, 0 ) ;

  { free any pixel data }
  if FBitsHandle <> 0 then begin
    GlobalFree( FBitsHandle ) ;
    FBitsHandle := 0 ;
  end ;
  FPixels := nil ;

  { free any palette }
  FreePalette ;
end ;


procedure TDIB.Clear ;

begin
  InternalClear ;

  { something's changed }
  Changed( Self ) ;
end ;


procedure TDIB.Assign( Source : TPersistent ) ;

var ADIB       : TDIB ;
    ABitmap    : TBitmap ;
    OldPalette : HPalette ;
    DC         : HDC ;
    AHandle    : HBITMAP ;

begin
  { test for silly condition }
  if Source = Self then exit ;

  { copy the graphic }
  if Assigned( Source ) then begin
    if not ( ( Source is TDIB ) or ( Source is TBitmap ) ) then
      inherited Assign( Source ) else
    begin
      try
        { clear any existing bitmap }
        InternalClear ;

        { assign from a TDIB }
        if Source is TDIB then begin
          ADIB := TDIB( Source ) ;
          if ADIB.InfoSize <> InfoSize then begin
            FreeMem( FBitmapInfo, InfoSize ) ;
            InfoSize := ADIB.InfoSize ;
            GetMem( FBitmapInfo, InfoSize ) ;
          end ;

          { free the old palette }
          FreePalette ;

          try
            { copy the bitmap info }
            Move( ADIB.FBitmapInfo^, FBitmapInfo^, InfoSize ) ;

            { now copy the bitmap's bits }
            FPixels := nil ;
            FBitsHandle := GlobalAlloc( GMEM_MOVEABLE,
                                  FBitmapInfo^.bmiHeader.biSizeImage ) ;
            LockPixels ;
            if ( Pixels <> nil ) and ( ADIB.Pixels <> nil ) then
              {$IFDEF Win32}
              Move( ADIB.Pixels^, Pixels^, FBitmapInfo^.bmiHeader.biSizeImage ) ;
              {$ELSE}
              hMemCpy( Pixels, ADIB.Pixels, FBitmapInfo^.bmiHeader.biSizeImage ) ;
              {$ENDIF}

          except
            { something went wrong - initialise bitmap info back to default }
            InternalClear ;
            Raise ;
          end ;
        end else begin
          ABitmap := TBitmap( Source ) ;
          Width := ABitmap.Width ;
          Height := ABitmap.Height ;
          FreePalette ;
          OldPalette := 0 ;
          DC := GetDC( 0 ) ;
          if DC = 0 then CantGetDC ;
          try
            { need to force the handle to be created so we can get the palette }
            AHandle := ABitmap.Handle ;
            OldPalette := SelectPalette( DC, ABitmap.Palette, false ) ;
            RealizePalette( DC ) ;
            GetDIBits( DC, AHandle, 0, ABitmap.Height, Pixels,
                       BitmapInfo^, DIB_RGB_COLORS ) ;
          finally
            if OldPalette <> 0 then SelectPalette( DC, OldPalette, true ) ;
            ReleaseDC( 0, DC ) ;
          end ;
        end ;
      finally
        { something's changed }
        Changed( Self ) ;
      end ;
    end ;
  end else Clear ;
end ;


procedure TDIB.AssignTo( Dest : TPersistent ) ;

var Bitmap : TBitmap ;

begin
  if Dest is TBitmap then begin
    Bitmap := TBitmap( Dest ) ;
    Bitmap.Width := Width ;
    Bitmap.Height := Height ;
    Bitmap.Palette := Palette ;
    Draw( Bitmap.Canvas, Rect( 0, 0, Width, Height ) ) ;
  end else inherited AssignTo( Dest ) ;
end ;


function  TDIB.GetEmpty : Boolean ;

begin
  Result := true ;
  if Assigned( FBitmapInfo ) then with FBitmapInfo^.bmiHeader do
    Result := ( biWidth = 0 ) or ( biHeight = 0 ) ;
end ;


procedure TDIB.Draw( ACanvas : TCanvas ; const Rect : TRect ) ;

var OldPalette : HPalette ;
    OldStretchMode : SmallInt ;

begin
  { use StretchDIBits to display the DIB }
  if not Empty then with FBitmapInfo^.bmiHeader, Rect do begin
    OldPalette := SelectPalette( ACanvas.Handle, Palette, true ) ;
    try
      RealizePalette( ACanvas.Handle ) ;
      OldStretchMode := SetStretchBltMode( ACanvas.Handle, STRETCH_DELETESCANS ) ;
      StretchDIBits( ACanvas.Handle, Left, Top, Right - Left, Bottom - Top, 0, 0,
                     biWidth, biHeight, Pixels, FBitmapInfo^,
                     DIB_RGB_COLORS, SRCCOPY ) ;
      SetStretchBltMode( ACanvas.Handle, OldStretchMode ) ;
    finally
      SelectPalette( ACanvas.Handle, OldPalette, true ) ;
    end ;
  end ;
end ;


procedure TDIB.FreeImage ;

begin
  if not Empty then begin
    FPixels := nil ;
    GlobalUnlock( FBitsHandle ) ;
    GlobalFree( FBitsHandle ) ;
    FBitsHandle := 0 ;
  end ;
end ;


procedure TDIB.AllocateImage ;

begin
  if not Empty then begin
    FBitsHandle := GlobalAlloc( GMEM_MOVEABLE or GMEM_ZEROINIT,
                         FBitmapInfo^.bmiHeader.biSizeImage ) ;
    if FBitsHandle = 0 then WinGDebug( 'GlobalAlloc failed in TDIB.AllocateImage - ' +
                                 'out of memory?' ) ;
    FPixels := NIL ;
    LockPixels ;
    Changed( Self ) ;
    Modified := false ;
  end ;
end ;


procedure TDIB.LockPixels ;

begin
  if FBitsHandle <> 0 then FPixels := GlobalLock( FBitsHandle ) ;
end ;


procedure TDIB.SetBitsHandle( Value : THandle ) ;

begin
  if Value <> FBitsHandle then begin
    GlobalUnlock( FBitsHandle ) ;
    GlobalFree( FBitsHandle ) ;
    FBitsHandle := Value ;
    FPixels := NIL ;
    LockPixels ;
  end ;
end ;


procedure TDIB.SetPixels( Value : pointer ) ;

begin
  if FPixels <> Value then begin
    BitsHandle := 0 ;
    FPixels := Value ;
  end ;
end ;


function  TDIB.GetHeight : integer ;

begin
  Result := FBitmapInfo^.bmiHeader.biHeight ;
end ;


procedure TDIB.CalculateImageSize ;

begin
  with BitmapInfo^.bmiHeader do
    biSizeImage := ( ( ( biWidth * biBitCount ) + 31 ) div 32 ) * 4 * biHeight ;
end ;


procedure TDIB.SetHeight( Value : integer ) ;

begin
  with FBitmapInfo^.bmiHeader do begin
    FreeImage ;
    biHeight := Value ;
    CalculateImageSize ;
    AllocateImage ;
  end ;
end ;


function  TDIB.GetWidth : integer ;

begin
  Result := FBitmapInfo^.bmiHeader.biWidth ;
end ;


procedure TDIB.SetWidth( Value : integer ) ;

begin
  with FBitmapInfo^.bmiHeader do begin
    FreeImage ;
    biWidth := Value ;
    CalculateImageSize ;
    AllocateImage ;
  end ;
end ;


function  TDIB.GetPalette : HPalette ;

begin
  if ( FPalette = 0 ) and not Empty then
    FPalette := PaletteFromW3DIB( FBitmapInfo^ ) ;
  Result := FPalette ;
end ;


function  TDIB.CreateCopy : TGraphic ;

begin
  Result := TDIB.Create ;
  TDIB( Result ).Assign( Self ) ;
end ;


procedure TDIB.LoadFromStream( Stream : TStream ) ;

begin
  DisposeBitmapInfo ;
  if Stream.Size - Stream.Position > 0 then begin
    LoadDIB( Stream, FBitmapInfo, InfoSize, FBitsHandle ) ;
    FreePalette ;
    FPixels := NIL ;
    LockPixels ;
    Changed( Self ) ;
    Modified := false ;
  end ;
end ;


procedure TDIB.SaveToStream( Stream : TStream ) ;

var BitmapFileHeader : TBitmapFileHeader ;

begin
  if ( Pixels = NIL ) or ( FBitmapInfo = nil ) then exit ;

  { create and save the file header }
  with BitmapFileHeader, FBitmapInfo^.bmiHeader do begin
    bfType := $4D42 ;
    CalculateImageSize ;
    bfSize := sizeof( TBitmapFileHeader ) + BitmapInfoSize +
              biSizeImage ;
    bfReserved1 := 0 ;
    bfReserved2 := 0 ;
    bfOffBits := sizeof( TBitmapFileHeader ) + BitmapInfoSize ;

    { write the header }
    Stream.WriteBuffer( BitmapFileHeader,
                        sizeof( TBitmapFileHeader ) ) ;

    { save the bitmap info header and color table }
    Stream.WriteBuffer( FBitmapInfo^, InfoSize ) ;

    { write out the DIB bits }
    Stream.WriteBuffer( Pixels^, biSizeImage ) ;
  end ;
end ;


procedure TDIB.LoadFromClipboardFormat( AFormat : Word ; AData : THandle ;
  APalette : HPALETTE ) ;

begin
  Raise Exception.Create( 'TDIB.LoadFromClipboardFormat not yet implemented' ) ;
end ;


procedure TDIB.SaveToClipboardFormat( var AFormat : Word ; var AData : THandle ;
  var APalette : HPALETTE ) ;

begin
  Raise Exception.Create( 'TDIB.SaveToClipboardFormat not yet implemented' ) ;
end ;


procedure TDIB.RectToCanvas( DestinationRect   : TRect ;
                             DestinationCanvas : TCanvas ;
                             SourceRect        : TRect ) ;

begin
  if not Empty then begin
    if StretchDIBits( DestinationCanvas.Handle,
                      DestinationRect.Left,
                      DestinationRect.Top,
                      DestinationRect.Right - DestinationRect.Left,
                      DestinationRect.Bottom - DestinationRect.Top,
                      SourceRect.Left,
                      SourceRect.Top,
                      SourceRect.Right - SourceRect.Left,
                      SourceRect.Bottom - SourceRect.Top,
                      Pixels,
                      BitmapInfo^, DIB_RGB_COLORS, SRCCOPY ) = 0 then
      WinGDebug( 'StretchDIBits failed in TDIB.RectToCanvas' ) ;
  end ;
end ;


function  TDIB.RemapColorTable( FromBitmapInfo   : PBitmapInfo ;
                                MatchingPalette  : HPalette ;
                                TransparentColor : byte ) : byte ;

type PcolorTable = ^TcolorTable ;
     TcolorTable = array[ 0..255 ] of TRGBQuad ;

var TranslationTable : array[ 0..255 ] of byte ;
    i                : SmallInt ;
    TempcolorTable  : PcolorTable ;
    TempSize         : longint ;
    Pixel            : PByte ;
    Offset           : longint ;
    AnImageSize      : longint ;
    ncolors         : SmallInt ;

begin
  { remap the color table and pixel data to match the one supplied -
    first create a translation table }
  with FBitmapInfo^ do begin
    ncolors := GetColorsUsed( FBitmapInfo ) ;
    for i := ncolors - 1 downto 0 do begin
      with bmiColors[ i ] do
        TranslationTable[ i ] :=
          GetNearestPaletteIndex( MatchingPalette,
                                  PaletteRGB( rgbRed, rgbBlue, rgbGreen ) ) ;
    end ;
    Result := TranslationTable[ TransparentColor ] ;

    { change the color table }
    TempSize := ncolors * sizeof( TRGBQuad ) ;
    GetMem( TempColorTable, TempSize ) ;
    try
      for i := ncolors - 1 downto 0 do
        TempcolorTable^[ TranslationTable[ i ] ] := bmiColors[ i ] ;
      Move( TempColorTable^, bmiColors, TempSize ) ;
    finally
      FreeMem( TempColorTable, TempSize ) ;
    end ;

    { go through the pixels, substituting the new values }
    Offset := 0 ;
    AnImageSize := bmiHeader.biSizeImage ;
    if AnImageSize = 0 then with bmiHeader do
      AnImageSize := ( ( longint( biWidth ) + 3 ) and not 3 ) * biHeight ;
    Pixel := Pixels ;
    while Offset < AnImageSize do begin
      Pixel^ := TranslationTable[ Pixel^ ] ;
      inc( Pixel ) ;
      {$IFNDEF Win32}
      if Ofs( Pixel^ ) = 0 then
        Pixel := Ptr( Seg( Pixel^ ) + SelectorInc, 0 ) ;
      inc( Offset ) ;
      {$ENDIF}
    end ;
  end ;
  Changed( Self ) ;
end;


{ TWinGCanvas }

constructor TWinGCanvas.Create( AWidth, AHeight : word ) ;

begin
  inherited Create ;
  Resize( AWidth, AHeight ) ;
  GetPalette ;
end;


destructor TWinGCanvas.Destroy ;
begin
  FreeContext ;
  inherited Destroy ;
end;


procedure TWinGCanvas.CopyColorTableFromDIB( ABitmapInfo      : PBitmapInfo ;
                                             CreatePaletteNow : boolean ) ;

var ALogPalette  : PLogPalette ;
    i            : SmallInt ;
    DC           : HDC ;
    HalfReserved : SmallInt ;
    LastUnreserved : SmallInt ;
    n              : SmallInt ;

begin
  if FBitmapInfo = nil then exit ;
  FreePalette ;

  { create an identity palette from the DIB's color table -
    get the system colors as PALETTEENTRIES }
  GetMem( ALogPalette, LogPaletteSize ) ;
  try
    with ALogPalette^ do begin
      palVersion := $300 ;
      palNumEntries := 256 ;
      DC := GetDC( 0 ) ;
      if DC = 0 then CantGetDC ;
      try
        HalfReserved := GetDeviceCaps( DC, NUMRESERVED ) div 2 ;

        { copy the rest of the colors from the DIB color table }
        LastUnreserved := 255 - HalfReserved ;
        with ABitmapInfo^.bmiHeader do begin
          n := GetColorsUsed( ABitmapInfo ) ;
          if LastUnreserved >= n - HalfReserved then
            LastUnreserved := n - HalfReserved - 1 ;
        end ;
        for i := HalfReserved to LastUnreserved do
          with palPalEntry[ i ], ABitmapInfo^.bmiColors[ i ] do
        begin
          peRed := rgbRed ;
          peGreen := rgbGreen ;
          peBlue := rgbBlue ;
          peFlags := PC_NOCOLLAPSE ;
        end ;

        { clear any remaining entries }
        inc( LastUnreserved ) ;
        if LastUnreserved < HalfReserved then LastUnReserved := HalfReserved ;
        for i := LastUnreserved to 255 - HalfReserved do
          with palPalEntry[ i ] do
        begin
          peRed := 0 ;
          peGreen := 0 ;
          peBlue := 0 ;
          peFlags := PC_NOCOLLAPSE ;
        end ;

        if HalfReserved > 0 then begin
          if ( GetSystemPaletteEntries( DC, 0, HalfReserved, palPalEntry ) = 0 ) or
             ( GetSystemPaletteEntries( DC, 256 - HalfReserved, HalfReserved,
                                        palPalEntry[ 256 - HalfReserved ] ) = 0 ) then
            WinGDebug( 'GetSystemPaletteEntries failed in ' +
                       'TWinGCanvas.CopyColorTableFromDIB' ) ;
        end ;
        for i := HalfReserved - 1 downto 0 do
          palPalEntry[ i ].peFlags := 0 ;
        for i := 256 - HalfReserved to 255 do
          palPalEntry[ i ].peFlags := 0 ;
      finally
        ReleaseDC( 0, DC ) ;
      end ;

      { deal with any duplicate entries }
      RemapDuplicates( palPalEntry[ 0 ] ) ;

      { copy from the palette to the WinG bitmap color table }
      for i := 0 to 255 do
        with FBitmapInfo^.bmiColors[ i ], palPalEntry[ i ] do
      begin
        rgbRed := peRed ;
        rgbGreen := peGreen ;
        rgbBlue := peBlue ;
        rgbReserved := 0 ;
      end ;

      { if there's a WingDC, change it's color table }
      if ( Handle <> 0 ) and ( FOriginalBitmap <> 0 ) and
         ( WinGSetDIBColorTable( Handle, 0, 256,
                                 @FBitmapInfo^.bmiColors[ 0 ] ) = 0 ) then
        WinGDebug( 'WinGSetDIBColorTable failed in ' +
                   'TWinGCanvas.CopyColorTableFromDIB' ) ;

      { create the palette now if requested }
      if CreatePaletteNow then begin
        FPalette := CreatePalette( ALogPalette^ ) ;
        if FPalette = 0 then WinGDebug( 'CreatePalette failed in ' +
                                        'TWinGCanvas.CopyColorTableFromDIB' ) ;
      end ;
    end ;
  finally
    { tidy up }
    FreeMem( ALogPalette, LogPaletteSize ) ;
  end ;
end ;


procedure TWinGCanvas.CloneColorTable( SourceWinGCanvas  : TWinGCanvas ;
                                       CreatePaletteNow  : boolean ) ;

begin
  { copy the color table }
  Move( SourceWinGCanvas.BitmapInfo^.bmiColors, BitmapInfo^.bmiColors,
        sizeof( TRGBQuad ) * 256 ) ;
  if ( Handle <> 0 ) and ( FOriginalBitmap <> 0 ) and
     ( WinGSetDIBColorTable( Handle, 0, 256,
                             @FBitmapInfo^.bmiColors[ 0 ] ) = 0 ) then
    WinGDebug( 'WinGSetDIBColorTable failed in ' +
               'TWinGCanvas.CloneColorTable' ) ;

  { clear any palette }
  FreePalette ;

  { clone the palette now if requested }
  if CreatePaletteNow then begin
    if SourceWinGCanvas.FPalette <> 0 then
      FPalette := ClonePalette( SourceWinGCanvas.Palette ) else
      FPalette := PaletteFromDIB( BitmapInfo ) ;
  end ;
end ;


procedure TWinGCanvas.CopyDIB( ADIB : TDIB ) ;

var ARect : TRect ;

begin
  if ( ADIB = nil ) or ADIB.Empty then
    FillRect( Rect( 0, 0, ADIB.Width, ADIB.Height ) ) else
  begin
    ARect := Rect( 0, 0, ADIB.Width, ADIB.Height ) ;
    ADIB.RectToCanvas( ARect, Self, ARect ) ;
  end ;
end ;


function  TWinGCanvas.GetPalette : HPalette ;

begin
  if FPalette = 0 then FPalette := PaletteFromDIB( FBitmapInfo ) ;
  Result := FPalette ;
end ;


procedure TWinGCanvas.SetPalette( Value : HPalette ) ;

var LogPalette   : PLogPalette ;
    HalfReserved : SmallInt ;
    nReserved    : SmallInt ;
    DC           : HDC ;
    i            : SmallInt ;

begin
  { Copy the palette, making sure it's an identity palette.
    This may mean losing colors from the beginning and end of
    the palette to accomodate the fixed system static colors
    (typically 10 colors from each end). }
  if Value = 0 then exit ;

  { allocate a memory for a logical palette }
  GetMem( LogPalette, LogPaletteSize ) ;
  try
    with LogPalette^ do begin
      palVersion := $300 ;
      palNumEntries := 256 ;
      DC := GetDC( 0 ) ;
      if DC = 0 then CantGetDC ;
      try
        nReserved := GetDeviceCaps( DC, NUMRESERVED ) ;
        HalfReserved := nReserved div 2 ;
        if nReserved > 0 then begin
          if ( GetSystemPaletteEntries( DC, 0, HalfReserved,
                                        palPalEntry ) = 0 ) or
             ( GetSystemPaletteEntries( DC, 256 - HalfReserved, HalfReserved,
                                        palPalEntry[ 256 - HalfReserved ] ) = 0 )
          then
            WinGDebug( 'GetSystemPaletteEntries failed in TWinGCanvas.SetPalette' ) ;
        end ;
      finally
        ReleaseDC( 0, DC ) ;
      end ;

      { get the rest of the colors from the palette and mark them no collapse }
      if GetPaletteEntries( Value, HalfReserved, 256 - nReserved,
                            palPalEntry[ HalfReserved ] ) = 0 then
        WinGDebug( 'GetPaletteEntries failed in TWinGCanvas.SetPalette' ) ;
      for i := 255 - HalfReserved downto HalfReserved do
        palPalEntry[ i ].peFlags := PC_NOCOLLAPSE ;

      { copy to the bitmap color table }
      if FBitmapInfo <> nil then begin
        for i := 0 to 255 do with
          palPalEntry[ i ], BitmapInfo^.bmiColors[ i ] do
        begin
          rgbRed := peRed ;
          rgbGreen := peGreen ;
          rgbBlue := peBlue ;
          rgbReserved := 0 ;
        end ;
      end ;

      { update the WinG color table }
      if ( Handle <> 0 ) and ( FOriginalBitmap <> 0 ) and 
         ( WinGSetDIBColorTable( Handle, 0, 256,
                                 @FBitmapInfo^.bmiColors[ 0 ] ) = 0 ) then
        WinGDebug( 'WinGSetDIBColorTable failed in TWinGCanvas.SetPalette' ) ;


      { finally, create a palette with using the logical palette }
      FreePalette ;
      FPalette := CreatePalette( LogPalette^ ) ;
      if FPalette = 0 then
        WinGDebug( 'CreatePalette failed in TWinGCanvas.SetPalette' ) ;

      { select the palette }
      FOriginalPalette := SelectPalette( Handle, FPalette, false ) ;
      RealizePalette( Handle ) ; 
    end ;
  finally
    FreeMem( LogPalette, LogPaletteSize ) ;
  end ;
end ;


procedure TWinGCanvas.SetDIBFormat( Value : TDIBFormat ) ;

var AWidth, AHeight : SmallInt ;

begin
  if FDIBFormat <> Value then begin
    FDIBFormat := Value ;
    if FBitmapInfo <> nil then begin
      with FBitmapInfo^.bmiHeader do begin
        AWidth := biWidth ;
        AHeight := biHeight ;
        if FOriginalBitmap <> 0 then begin
          SelectObject( Handle, FOriginalBitmap ) ;
          DeleteObject( FWinGBitmap ) ;
          FOriginalBitmap := 0 ;
          FWinGBitmap := 0 ;
        end ;
      end ;
      FreeMem( FBitmapInfo, BitmapInfoSize ) ;
      FBitmapInfo := nil ;
      Resize( AWidth, AHeight ) ;
    end ;
  end ;
end ;


procedure TWinGCanvas.SetupColorTable ;

var DC : HDC ;
    HalfReserved : SmallInt ;
    i            : SmallInt ;
    Temp         : byte ;

begin
  if Assigned( FOnSetupColorTable ) then FOnSetupColorTable( Self ) else
  begin
    DC := GetDC( 0 ) ;
    if DC = 0 then CantGetDC ;
    try
      HalfReserved := GetDeviceCaps( DC, NUMRESERVED ) div 2 ;
      with FBitmapInfo^ do begin
        if HalfReserved > 0 then begin
          if ( GetSystemPaletteEntries( DC, 0, HalfReserved,
                                        PPaletteEntry( @bmiColors )^ ) = 0 ) or
             ( GetSystemPaletteEntries( DC, 256 - HalfReserved, HalfReserved,
                 PPaletteEntry( @bmiColors[ 256 - HalfReserved ] )^ ) = 0 ) then
          WinGDebug( 'GetSystemPaletteEntries failed in TWinGCanvas.SetupColorTable' ) ;
        end ;
      end ;
    finally
      ReleaseDC( 0, DC ) ;
    end ;

    with FBitmapInfo^ do begin
      { swap the red and blue values }
      for i := HalfReserved - 1 downto 0 do with bmiColors[ i ] do begin
        Temp := rgbRed ;
        rgbRed := rgbBlue ;
        rgbBlue := Temp ;
      end ;
      for i := 256 - HalfReserved to 255 do with bmiColors[ i ] do begin
        Temp := rgbRed ;
        rgbRed := rgbBlue ;
        rgbBlue := Temp ;
      end ;

      { set the WinG DC's color table }
      if WinGDCValid and ( FOriginalBitmap <> 0 ) and
         ( WinGSetDIBColorTable( Handle, 0, 256,
                                 @FBitmapInfo^.bmiColors[ 0 ] ) = 0 ) then
        WinGDebug( 'WinGSetDIBColorTable failed in TWinGCanvas.SetupColorTable' ) ;
    end ;
  end ;
end ;


procedure TWinGCanvas.Resize( AWidth, AHeight : SmallInt ) ;

var APreviousBitmap : HBITMAP ;

begin
  { create a bitmap }
  if FBitmapInfo = nil then begin
    GetMem( FBitmapInfo, BitmapInfoSize ) ;
    if not WinGRecommendDIBFormat( FBitmapInfo ) then
      WinGDebug( 'WinGRecommendDIBFormat failed in TWinGCanvas.Resize' ) ;
    with FBitmapInfo^.bmiHeader do begin
      biBitCount := 8 ;
      biCompression := BI_RGB ;
      case FDIBFormat of
        dfAuto : Orientation := biHeight ;
        dfBottomUp : Orientation := 1 ;
        dfTopDown : Orientation := -1 ;
      end ;
    end ;
    SetupColorTable ;
  end ;

  { set the width and height, remembering DIB orientation }
  with FBitmapInfo^.bmiHeader do begin
    if ( AWidth = biWidth ) and ( AHeight = abs( biHeight ) ) then exit ;
    biWidth := AWidth ;
    biHeight := AHeight * Orientation ;
  end ;

  { create the new WinGBitmap }
  with FBitmapInfo^.bmiHeader do if ( biWidth > 0 ) and ( biHeight <> 0 ) then
  begin
    FWinGBitmap := WinGCreateBitmap( Handle, FBitmapInfo, @FBitmapBits ) ;
    if FWinGBitmap = 0 then with FBitmapInfo^.bmiHeader do
      Raise EWinGError.CreateFmt( 'Unable to create WinG bitmap of size %d by %d',
                                  [ biWidth, biHeight ] ) ;

    { select the bitmap and get the previous one }
    APreviousBitmap := SelectObject( Handle, FWinGBitmap ) ;

    { if it's the first time remember original bitmap, otherwise delete previous }
    if FOriginalBitmap = 0 then FOriginalBitmap := APreviousBitmap else
      TryDeleteObject( APreviousBitmap,
                       'TWinGCanvas.Resize[1]' ) ;

    { erase the bitmap }
    FillRect( Rect( 0, 0, AWidth, AHeight ) ) ;
  end else begin
    { bitmap is empty - reselect original and free current }
    if FOriginalBitmap <> 0 then begin
      TryDeleteObject( SelectObject( Handle, FOriginalBitmap ),
                       'TWinGCanvas.Resize[2]' ) ;
      FOriginalBitmap := 0 ;
    end ;
  end ;
end ;


procedure TWinGCanvas.FreeContext ;

var AWinGDC : HDC ;

begin
  if Handle <> 0 then begin
    AWinGDC := Handle ;
    FreePalette ;
    if FOriginalBitmap <> 0 then
      TryDeleteObject( SelectObject( AWinGDC, FOriginalBitmap ),
                       'FreeContext' ) ;
    Handle := 0 ;
    if not DeleteDC( AWinGDC ) then
      WinGDebug( 'DeleteDC failed in TWinGCanvas.FreeContext' ) ;
  end ;
end ;


procedure TWinGCanvas.FreePalette ;

begin
  if FOriginalPalette <> 0 then
    SelectPalette( Handle, FOriginalPalette, true ) ;
  if FPalette <> 0 then begin
    try
      TryDeleteObject( FPalette, 'TWinGCanvas.FreePalette' ) ;
    finally
      FPalette := 0 ;
    end ;
  end ;
end ;


procedure TWinGCanvas.CreateHandle ;

begin
  Handle := WinGCreateDC ;
  if Handle = 0 then
    WinGDebug( 'WinGCreateDC failed in TWinGCanvas.CreateHandle' ) ;
  FWinGDCValid := true ;
  FOriginalPalette := SelectPalette( Handle, Palette, false ) ;
  RealizePalette( Handle ) ;
end ;


procedure TWinGCanvas.WinGCopy( DestX, DestY, DestWidth, DestHeight : SmallInt ;
                                DestCanvas : TCanvas ;
                                SourceX, SourceY : SmallInt ) ;

var AnOldPalette : HPalette ;
    APalette     : HPalette ;

begin
  { blt's an area of the WinG canvas to a screen DC }
  if ( DestWidth = 0 ) or ( DestHeight = 0 ) then begin
    WinGDebug( Format( 'Attempting to WinGCopy zero-sized area (%d by %d)',
                       [ DestWidth, DestHeight ] ) ) ;
    exit ;
  end ;
  APalette := Palette ;
  if APalette <> 0 then begin
    AnOldPalette := SelectPalette( DestCanvas.Handle, APalette, true ) ;
    if AnOldPalette = 0 then
      WinGDebug( 'SelectPalette[1] failed in TWinGCanvas.WinGCopy' ) ;
    RealizePalette( DestCanvas.Handle ) ;
  end ;
  if not WinGBitBlt( DestCanvas.Handle, DestX, DestY, DestWidth, DestHeight,
                     Handle, SourceX, SourceY ) then
    WinGDebug( 'WinGBitBlt failed in TWinGCanvas.WinGCopy' ) ;
  if ( APalette <> 0 ) and
     ( SelectPalette( DestCanvas.Handle, AnOldPalette, true ) = 0 ) then
   WinGDebug( 'SelectPalette[2] failed in TWinGCanvas.WinGCopy' ) ;     
end ;


procedure TWinGCanvas.WinGStretchCopy( DestX, DestY, DestWidth, DestHeight : SmallInt ;
                                       DestCanvas : TCanvas ;
                                       SourceX, SourceY,
                                       SourceWidth, SourceHeight : SmallInt ) ;

var AnOldPalette : HPalette ;

begin
  { blt to a screen canvas with stretching }
  if ( DestWidth = 0 ) or ( DestHeight = 0 ) then begin
    WinGError( Format( 'Attempting to WinGStretchCopy zero-sized dest area (%d by %d)',
                       [ DestWidth, DestHeight ] ) ) ;
    exit ;
  end ;
  if ( SourceWidth = 0 ) or ( SourceHeight = 0 ) then begin
    WinGError( Format( 'Attempting to WinGStretchCopy zero-sized source area (%d by %d)',
                       [ SourceWidth, SourceHeight ] ) ) ;
    exit ;
  end ;
  if Palette <> 0 then begin
    AnOldPalette := SelectPalette( DestCanvas.Handle, Palette, true ) ;
    RealizePalette( DestCanvas.Handle ) ;
    if AnOldPalette = 0 then
      WinGDebug( 'SelectPalette[1] failed in TWinGCanvas.WinGStretchCopy' ) ;
  end ;
  if not WinGStretchBlt( DestCanvas.Handle, DestX, DestY,
                         DestWidth, DestHeight,
                         Handle, SourceX, SourceY,
                         SourceWidth, SourceHeight ) then
    WinGDebug( 'WinGBitBlt failed in TWinGCanvas.WinGStretchCopy' ) ;
  if ( Palette <> 0 ) and
     ( SelectPalette( DestCanvas.Handle, AnOldPalette, true ) = 0 ) then
   WinGDebug( 'SelectPalette[2] failed in TWinGCanvas.WinGStretchCopy' ) ;
end ;


procedure TWinGCanvas.TransparentBlt( DIB  : TDIB ;
                                      x, y : SmallInt ;
                                      TransparentValue : byte ) ;

begin
  TransparentDIBits( FBitmapInfo,
                     BitmapBits,
                     X,
                     Y,
                     DIB.FBitmapInfo,
                     DIB.Pixels,
                     0, 0 ,
                     DIB_RGB_COLORS,
                     TransparentValue ) ;
end ;


constructor TWinGDIBCanvas.Create( AWinGDIB : TWinGDIB ) ;

begin
  FWinGDIB := AWinGDIB ;
  inherited Create( 0, 0 ) ;
end ;


procedure TWinGDIBCanvas.CreateHandle ;

begin
  inherited CreateHandle ;

  { tell the WinGDIB that something has changed to make it copy over
    the DIB into the canvas. }
  FWinGDIB.Changed( Self ) ;
end ;


{ TWinGDIB }

destructor TWinGDIB.Destroy ;

begin
  FCanvas.Free ;
  inherited Destroy ;
end ;


function  TWinGDIB.GetCanvas : TWinGCanvas ;

begin
  if FCanvas = NIL then FCanvas := TWinGDIBCanvas.Create( Self ) ;
  Result := FCanvas ;
end ;


procedure TWinGDIB.Changed( Sender : TObject ) ;

begin
  inherited Changed( Sender ) ;
  if ( FCanvas = NIL ) or not FCanvas.WinGDCValid then exit ;

  { set the canvas to the correct size }
  FCanvas.Resize( Width, Height ) ;

  { copy the DIB data over to the canvas }
  FCanvas.CopyColorTableFromDIB( BitmapInfo, false ) ;

  { now copy the bits }
  if ( Pixels <> nil ) and ( FCanvas.BitmapBits <> nil ) and
     ( Pixels <> FCanvas.BitmapBits ) then
    {$IFDEF Win32}
    Move( Pixels^, FCanvas.BitmapBits^, BitmapInfo^.bmiHeader.biSizeImage ) ;
    {$ELSE}
    hMemCpy( FCanvas.BitmapBits, Pixels, BitmapInfo^.bmiHeader.biSizeImage ) ;
    {$ENDIF}

  { set the the DIB's pixels to point to the WinG bitmap's pixels }
  Pixels := FCanvas.BitmapBits ;

  { select the palette }
  FCanvas.Palette := Palette ;
end ;


{ TWinGSurface }

constructor TWinGSurface.Create( AOwner : TComponent ) ;

begin
  inherited Create( AOwner ) ;
  ControlStyle := ControlStyle + [ csOpaque ] ;
  ControlState := ControlState + [ csPalette ] ;
  Width := 200 ;
  Height := 150 ;

  { create a WinG canvas }
  FWinGCanvas := TWinGCanvas.Create( Width, Height ) ;
  Color := clWindow ;
  FWinGCanvas.Brush.Color := Color ;
end ;


destructor TWinGSurface.Destroy ;

begin
  inherited Destroy ;
  FWinGCanvas.Free ;
end ;


procedure TWinGSurface.CreateParams( var Params : TCreateParams ) ;

begin
  inherited CreateParams( Params ) ;
  with Params.WindowClass do Style := Style or CS_OWNDC ;
end ;


procedure TWinGSurface.WMSize( var Message : TWMSize ) ;

begin
  inherited ;

  { resize the WinG canvas to match }
  if FWinGCanvas <> nil then
    FWinGCanvas.Resize( Message.Width, Message.Height ) ;
end ;


procedure TWinGSurface.WMEraseBkgnd( var Message : TWMEraseBkgnd ) ;

begin
  { no need to paint background since canvas should fill it }
  Message.Result := 1 ;
end;

function  TWinGSurface.GetPalette : HPalette ;

begin
  Result := FWinGCanvas.Palette ;
end ;


procedure TWinGSurface.ClearOnColorChanged ;

begin
  FWinGCanvas.FillRect( Rect( 0, 0, Width, Height ) ) ;
end ;


procedure TWinGSurface.CMColorChanged( var Message : TMessage ) ;

begin
  inherited ;
  FWinGCanvas.Brush.Color := Color ;
  ClearOnColorChanged ;
end ;


function  TWinGSurface.GetDIBFormat : TDIBFormat ;

begin
  Result := WinGCanvas.DIBFormat ;
end ;


procedure TWinGSurface.SetDIBFormat( Value : TDIBFormat ) ;

begin
  WinGCanvas.DIBFormat := Value ;
end ;


procedure TWinGSurface.Paint ;

begin
  FWinGCanvas.WinGCopy( 0, 0, Width, Height, Canvas, 0, 0 ) ;
  if csDesigning in ComponentState then with Canvas do begin
    Pen.Style := psDash;
    Brush.Style := bsClear;
    Rectangle(0, 0, Width, Height);
  end ;
end ;


{ TDirtyRect }

type
  TDirtyRect = class( TObject )
  public
    Rect : TRect ;
    Combined : boolean ;
    constructor Create( const ARect : TRect ) ;
  end ;

constructor TDirtyRect.Create( const ARect : TRect ) ;

begin
  inherited Create ;
  Rect := ARect ;
end ;


{ TSprite }

constructor TSprite.Create( AOwner : TComponent ) ;

begin
  inherited Create( AOwner ) ;
  FVisible := true ;
  FImage := CreateImageDIB ;
  FImage.OnChange := ImageChanged ;
  FAnimationFrames := defAnimationFrames ;
  FAnimationInterval := defAnimationInterval ;
  FFrames := TList.Create ;
end ;


destructor TSprite.Destroy ;

var i : SmallInt ;

begin
  { hide it to remove image from surface }
  Visible := false ;

  { set the sprite surface to nil to disconnect the sprite }
  SpriteSurface := nil ;

  { call inherited }
  inherited Destroy ;

  { free up the DIB's and do inherited cleanup }
  FImage.Free ;
  for i := FFrames.Count - 1 downto 0 do
    TDIB( FFrames[ i ] ).Free ;
  FFrames.Free ;
end ;


function  TSprite.CreateImageDIB : TDIB ;

begin
  Result := TWinGDIB.Create ;
end ;


procedure TSprite.SetVisible( Value : boolean ) ;

begin
  if Value <> FVisible then begin
    { if hiding, update the background and add a dirty rect }
    if FSpriteSurface <> NIL then begin
      { repaint the background and add the sprite to the surface's dirty rects }
      RepaintBackground ;
      SpriteSurface.DirtyRects.Add( TDirtyRect.Create( Bounds( ActualX, ActualY,
                                                               ActualW, ActualH ) ) ) ;
    end ;
    FVisible := Value ;
  end ;
end ;


procedure TSprite.SetSpriteSurface( ASpriteSurface : TSpriteSurface ) ;

begin
  if ASpriteSurface <> FSpriteSurface then begin
    { disconnect the sprite from its existing surface and connect to new one }
    if Assigned( FSpriteSurface ) then begin
      if Visible and not ( csDestroying in FSpriteSurface.ComponentState ) then
      begin
        { set invisible then back to visible to trigger background repaint }
        Visible := false ;
        Visible := true ;
      end ;
      FSpriteSurface.RemoveSprite( Self ) ;
    end ;
    if Assigned( ASpriteSurface ) then ASpriteSurface.AddSprite( Self ) ;
    FSpriteSurface := ASpriteSurface ;
  end ;
end ;


procedure TSprite.SetOptions( Value : TSpriteOptions ) ;

begin
  if FOptions <> Value then begin
    FOptions := Value ;
  end ;
end ;


function  TSprite.GetImage : TGraphic ;

begin
  Result := FImage ;
end ;


procedure TSprite.SetImage( Value : TGraphic ) ;

begin
  if Value <> FImage then FImage.Assign( Value ) ;
end ;


procedure TSprite.ImageChanged ;

begin
  { copy the DIB's width and height to that of the sprite }
  if not FImage.Empty then with FImage.FBitmapInfo^.bmiHeader do
  begin
    W := biWidth ;
    H := biHeight ;
    FrameWidth := W ;
    { set the transparent color by default to the first pixel -
      note that no check is made here for the bottom-up or top-down
      nature of the DIB. For simplicity it's just the first pixel that's
      examined - it could be the top left or bottom left corner. }
    TransparentValue := PByte( FImage.Pixels )^ ;
    SetAnimationFrames( FAnimationFrames ) ;  { recalculate FrameWidth }
  end else begin
    W := 0 ;
    H := 0 ;
    AnimationFrames := 1 ;
  end ;

  { inform the sprite surface }
  if SpriteSurface <> nil then SpriteSurface.SpriteImageChanged( Self ) ;
end ;


function  TSprite.GetX : SmallInt ;

begin
  Result := FX.Int ;
  if FX.Frac > $7FFF then inc( Result ) ;
end ;


procedure TSprite.SetX( Value : SmallInt ) ;

begin
  FX.Int := Value ;
  FX.Frac := 0 ;
end ;


function  TSprite.GetY : SmallInt ;

begin
  Result := FY.Int ;
  if FY.Frac > $7FFF then inc( Result ) ;
end ;


procedure TSprite.SetY( Value : SmallInt ) ;

begin
  FY.Int := Value ;
  FY.Frac := 0 ;
end ;


function  TSprite.GetVelocityX : double ;

begin
  Result := FVelocityX.Value / CoordMultiplier ;
end ;


procedure TSprite.SetVelocityX( Value : double ) ;

begin
  FVelocityX.Value := Round( Value * CoordMultiplier ) ;
end ;


function  TSprite.GetVelocityY : double ;

begin
  Result := FVelocityY.Value / CoordMultiplier ;
end ;


procedure TSprite.SetVelocityY( Value : double ) ;

begin
  FVelocityY.Value := Round( Value * CoordMultiplier ) ;
end ;


function  TSprite.GetAccelerationX : double ;

begin
  Result := FAccelerationX.Value / CoordMultiplier ;
end ;


procedure TSprite.SetAccelerationX( Value : double ) ;

begin
  FAccelerationX.Value := Round( Value * CoordMultiplier ) ;
end ;


function  TSprite.GetAccelerationY : double ;

begin
  Result := FAccelerationY.Value / CoordMultiplier ;
end ;


procedure TSprite.SetAccelerationY( Value : double ) ;

begin
  FAccelerationY.Value := Round( Value * CoordMultiplier ) ;
end ;


procedure TSprite.SetAnimationFrames( Value : TNatural ) ;

begin
  { make sure it's a natural number }
  if Value = 0 then Value := 1 ;

  { recalculate the frame width regardless }
  FAnimationFrames := Value ;
  if not FImage.Empty then
    FrameWidth := FImage.Width div FAnimationFrames ;
  W := FrameWidth ;

  { create animation frames }
  CreateFrames ;
end ;


procedure TSprite.CreateFrames ;

var i            : SmallInt ;
    AWinGCanvas  : TWinGCanvas ;
    AFrameCanvas : TWinGCanvas ;
    ADIB         : TDIB ;
    MasterBitmapInfo : PBitmapInfo ;
    P                : PByte ;
    ANotedValue      : byte ;

begin
  { don't bother if we're designing }
  if csDesigning in ComponentState then exit ;

  { free any existing frames }
  for i := FFrames.Count - 1 downto 0 do
    TDIB( FFrames[ i ] ).Free ;
  FFrames.Clear ;

  { create frames for animation and remapping of the color table }
  if not Image.Empty then begin

    { set the frame width }
    FrameWidth := Image.Width div AnimationFrames ;

    { create a WinG canvas and move the image into it }
    AWinGCanvas := TWinGCanvas.Create( Image.Width, Image.Height ) ;
    try
      { attempt to get the master bitmap info from the sprite surface }
      if SpriteSurface <> nil then
        MasterBitmapInfo := SpriteSurface.WinGCanvas.BitmapInfo
      else
        MasterBitmapInfo := FImage.BitmapInfo ;

      { copy the master color table and then the image }
      if SpriteSurface <> nil then
        AWinGCanvas.CloneColorTable( SpriteSurface.WinGCanvas, false )
      else
        AWinGCanvas.CopyColorTableFromDIB( MasterBitmapInfo, false ) ;
      AWinGCanvas.CopyDIB( FImage ) ;

      { create another temporary WinGCanvas to get the individual frames }
      AFrameCanvas := TWinGCanvas.Create( FrameWidth, Image.Height ) ;
      try
        { now get each frame from the WinGCanvas }
        if SpriteSurface <> nil then
          AFrameCanvas.CloneColorTable( SpriteSurface.WinGCanvas, false )
        else
          AFrameCanvas.CopyColorTableFromDIB( MasterBitmapInfo, false ) ;
        for i := 1 to FAnimationFrames do begin

          { copy the frame into the frame canvas }
          if not BitBlt( AFrameCanvas.Handle, 0, 0, FrameWidth, Image.Height,
                         AWinGCanvas.Handle, ( i - 1 ) * FrameWidth, 0,
                         SRCCOPY ) then
            WinGDebug( 'BitBlt failed in TSprite.CreateFrames' ) ;


          { create a DIB }
          ADIB := TDIB.Create ;
          try
            ADIB.Width := FrameWidth ;
            ADIB.Height := Image.Height ;

            { now get the bits into the DIB }
            SelectObject( AFrameCanvas.Handle, AFrameCanvas.FOriginalBitmap ) ;
            if GetDIBits( AFrameCanvas.Handle, AFrameCanvas.FWinGBitmap,
                         0, Image.Height,
                         ADIB.Pixels, ADIB.BitmapInfo^,
                         DIB_RGB_COLORS ) = 0 then
              WinGDebug( 'GetDIBits failed in TSprite.CreateFrames' ) ;
            SelectObject( AFrameCanvas.Handle, AFrameCanvas.FWinGBitmap ) ;

            { and add it to the list }
            FFrames.Add( ADIB ) ;
          except
            ADIB.Free ;
            Raise ;
          end ;
        end ;

        { calculate the actual transparent value for the mapped frames }
        P := FImage.Pixels ;
        ANotedValue := P^ ;
        P^ := TransparentValue ;
        AWinGCanvas.Resize( 1, 1 ) ;
        if StretchDIBits( AWinGCanvas.Handle, 0, 0, 1, 1, 0, 0, 1, 1,
                          P, FImage.BitmapInfo^, DIB_RGB_COLORS, SRCCOPY ) = 0 then
          WinGDebug( 'StretchDIBits failed in TSprite.CreateFrames' ) ;
        P^ := ANotedValue ;
        ActualTransparentValue := PByte( AWinGCanvas.BitmapBits )^ ;
      finally
        AFrameCanvas.Free ;
      end ;
    finally
      AWinGCanvas.Free ;
    end ;
  end ;
end ;


procedure TSprite.GetFrameNumber( Ticks               : longint ;
                                  TicksSinceLastFrame : longint ;
                                  var FrameNumber     : word ) ;

var AnimationInc : SmallInt ;
    AnimationDiff : SmallInt ;
    AnimationDiff2 : SmallInt ;

begin
  { calculate the default next frame number }
  if AnimationStop > AnimationStart then begin
    { see if we're auto reversing }
    if soAutoReverseAnim in Options then begin
      AnimationDiff := AnimationStop - AnimationStart ;
      AnimationDiff2 := AnimationDiff + AnimationDiff ;
      AnimationInc := ( Ticks div FAnimationInterval ) mod
                      AnimationDiff2 ;
      if AnimationInc >= AnimationDiff then
        AnimationInc := AnimationDiff2 - AnimationInc ;
      FrameNumber := AnimationStart + AnimationInc ;
    end else begin
      AnimationInc := ( Ticks div FAnimationInterval ) mod
                      ( AnimationStop - AnimationStart + 1 ) ;

      if soBackwardAnim in Options then
        FrameNumber := AnimationStop - AnimationInc else
        FrameNumber := AnimationStart + AnimationInc ;
    end ;
  end else
    if AnimationStart = AnimationStop then FrameNumber := AnimationStart ;

  { give the handler a crack at it }
  if Assigned( FOnGetFrameNumber ) then
    FOnGetFrameNumber( Self, Ticks, TicksSinceLastFrame, FrameNumber ) ;
end ;


procedure TSprite.GetFrame( Ticks               : longint ;
                            TicksSinceLastFrame : longint ;
                            var DIB             : TDIB ;
                            var FrameRect       : TRect ) ;

var FrameNumber : word ;

begin
  { don't bother to do all the calcs if there is an event handler }
  DIB := FImage ;
  FrameRect := Rect( 0, 0, Image.Width, Image.Height ) ;
  FrameNumber := 0 ;
  if AnimationFrames > 1 then
    GetFrameNumber( Ticks, TicksSinceLastFrame, FrameNumber ) ;
  if Assigned( FOnGetFrame ) then
    FOnGetFrame( Self, Ticks, TicksSinceLastFrame, FrameNumber, DIB, FrameRect )
  else begin
    if FrameNumber >= AnimationFrames then FrameNumber := AnimationFrames - 1 ;
    if FrameNumber < FFrames.Count then begin
      DIB := TDIB( FFrames[ FrameNumber ] ) ;
      FrameRect := Rect( 0, 0, DIB.Width, DIB.Height ) ;
    end ;
  end ;
end ;


procedure TSprite.SetAnimationStart( Value : word ) ;

begin
  if Value <> FAnimationStart then begin
    if Value >= FAnimationFrames then Value := FAnimationFrames - 1 ;
    FAnimationStart := Value ;
    if FAnimationStart > FAnimationStop then
      FAnimationStop := FAnimationStart ;
  end ;
end ;


procedure TSprite.SetAnimationStop( Value : word ) ;

begin
  if Value <> FAnimationStop then begin
    if Value >= FAnimationFrames then Value := FAnimationFrames - 1 ;
    FAnimationStop := Value ;
    if FAnimationStart > FAnimationStop then
      FAnimationStart := FAnimationStop ;
  end ;
end ;


procedure TSprite.CheckBounce ;

begin
  { default CheckLimits calls this to make sprite bounce around }
  if SpriteSurface <> nil then begin
    if X < 1 then
      VelocityX := abs( VelocityX ) else
    if ( X + W + 1 >= SpriteSurface.Width ) then
      VelocityX := -abs( VelocityX ) ;
    if Y < 1 then VelocityY := abs( VelocityY ) else
    if ( Y + H + 1 >= SpriteSurface.Height ) then begin
      if LastVelocityY >= 0 then begin
        VelocityX := 10 - longint( Random( 20 ) ) ;
        LastVelocityY := - ( longint( Random( 40 ) ) + 5 ) ;
      end else
        LastVelocityY := ( LastVelocityY * 9 ) div 10 ;
      VelocityY := LastVelocityY ;
    end ;
  end ;
end ;


procedure TSprite.CheckLimits ;

var DoDefaultProcessing : boolean ;

begin
  { this routine is called by Move after the sprite has been moved,
    and can check and alter position, velocity or acceleration as required. }
  DoDefaultProcessing := true ;
  if Assigned( FOnCheckLimits ) then begin
    DoDefaultProcessing := false ;
    FOnCheckLimits( Self, DoDefaultProcessing ) ;
  end ;
  if DoDefaultProcessing and ( soDemoBounce in Options ) then CheckBounce ;
end ;


procedure TSprite.Move( TicksSinceLastFrame : longint ) ;

begin
  { use velocity if the sprite has not been moved manually }
  if ( X = ActualX ) and ( Y = ActualY ) then begin
    inc( FX.Value, FVelocityX.Value ) ;
    inc( FY.Value, FVelocityY.Value ) ;
  end ;
  inc( FVelocityX.Value, FAccelerationX.Value ) ;
  inc( FVelocityY.Value, FAccelerationY.Value ) ;
  CheckLimits ;
end ;


procedure TSprite.RepaintBackground ;

var t1, t2 : longint ;

begin
  if Assigned( FSpriteSurface ) then begin
    { if there's a background DIB, use that to repaint }
    if ( FSpriteSurface.BackgroundCanvas.BitmapInfo^.bmiHeader.biWidth =
         FSpriteSurface.Width ) then
      with FSpriteSurface do
    begin
      t1 := timeGetTime ;
      if not BitBlt( WinGCanvas.Handle, ActualX, ActualY,
                     ActualW, ActualH, FBackgroundCanvas.Handle,
                     ActualX, ActualY, SRCCOPY ) then
        WinGDebug( 'BitBlt failed in TSprite.RepaintBackground' ) ;
      t2 := timeGetTime ;
      Total := Total + t2 - t1 ;
      inc( Count ) ;
    end
    else
      { otherwise, just erase the background }
      FSpriteSurface.WinGCanvas.FillRect( Bounds( ActualX, ActualY,
                                                  ActualW, ActualH ) ) ;
  end ;
end ;


procedure TSprite.Paint( Canvas : TCanvas ;
                         Ticks  : longint ;
                         TicksSinceLastFrame : longint ) ;

var Continue : boolean ;
    ADIB     : TDIB ;
    ARect    : TRect ;

begin
  Continue := true ;
  if Assigned( FOnPaint ) then
    FOnPaint( Self, Canvas, Ticks, TicksSinceLastFrame, Continue ) ;
  if Continue then begin
    { get the image to paint }
    ADIB := nil ;
    GetFrame( Ticks, TicksSinceLastFrame, ADIB, ARect ) ;
    if ( ADIB <> nil ) and not ADIB.Empty then with ADIB do begin
      if Canvas is TWinGCanvas then
        TWinGCanvas( Canvas ).TransparentBlt( ADIB, X, Y,
                                              ActualTransparentValue )
      else
        Raise EInvalidOperation.Create(
          'Painting sprites on to non-WinG canvases is not yet implemented' ) ;
    end else begin
      { just invert a rectangle so we can see something }
      SetRect( ARect, X, Y, X + W, Y + H ) ;
      InvertRect( Canvas.Handle, ARect ) ;
    end ;
  end ;
end ;


{ TSpriteSurface }

constructor TSpriteSurface.Create( AOwner : TComponent ) ;

begin
  inherited Create( AOwner ) ;
  FFrameInterval := DefaultFrameInterval ;
  FMaxOverrun := FFrameInterval + FFrameInterval ;
  FSprites := TList.Create ;
  LastTick := timeGetTime ;
  SpriteSurfaces.Add( Self ) ;
  DirtyRects := TList.Create ;
  CombinedRects := TList.Create ;
  FBackground := CreateBackgroundDIB ;
  FBackground.OnChange := BackgroundChanged ;
  FBackgroundCanvas := TWinGCanvas.Create( 0, 0 ) ;
end ;


destructor TSpriteSurface.Destroy ;

var i : SmallInt ;

begin
  { remove from global list of sprite surfaces }
  SpriteSurfaces.Remove( Self ) ;

  { call inherited now }
  inherited Destroy ;

  { complete the cleanup }
  if Assigned( FSprites ) then begin
    for i := FSprites.Count - 1 downto 0 do
      TSprite( FSprites[ i ] ).SpriteSurface := nil ;
    FSprites.Free ;
  end ;
  if Assigned( DirtyRects ) then begin
    ClearList( DirtyRects ) ;
    DirtyRects.Free ;
  end ;
  if Assigned( CombinedRects ) then begin
    ClearList( CombinedRects ) ;
    CombinedRects.Free ;
  end ;
  FBackground.Free ;
  FBackground := nil ;
  FBackgroundCanvas.Free ;
end ;


procedure TSpriteSurface.Loaded ;

begin
  inherited Loaded ;
  if PaletteSource = mpBackground then PaletteSourceChanged ;
end ;


function  TSpriteSurface.CreateBackgroundDIB : TDIB ;

begin
  Result := TWinGDIB.Create ;
end ;


procedure TSpriteSurface.AddSprite( ASprite : TSprite ) ;

begin
  if FSprites.IndexOf( ASprite ) < 0 then begin
    FSprites.Add( ASprite ) ;
    SpriteImageChanged( ASprite ) ;
  end ;
end ;


procedure TSpriteSurface.RemoveSprite( ASprite : TSprite ) ;

begin
  FSprites.Remove( ASprite ) ;
  if not ( csDestroying in ComponentState ) and
         ( FPaletteSource = ASprite ) then
    PaletteSource := mpBackground ;
end ;


procedure TSpriteSurface.SpriteImageChanged( Sprite : TSprite ) ;

begin
  if FPaletteSource = Sprite then PaletteSourceChanged ;
end ;


procedure TSpriteSurface.ClearList( List : TList ) ;

var i : SmallInt ;

begin
  for i := List.Count - 1 downto 0 do
    TObject( List[ i ] ).Free ;
  List.Clear ;
end ;


procedure TSpriteSurface.CombineRects ;

var ARect : TRect ;
    i, j  : SmallInt ;
    ADirtyRect : TDirtyRect ;
    ASecondRect : TDirtyRect ;

begin
  ClearList( CombinedRects ) ;
  for i := DirtyRects.Count - 1 downto 0 do begin

    { get the rect and remove it }
    ADirtyRect := TDirtyRect( DirtyRects[ i ] ) ;
    DirtyRects.Delete( i ) ;

    { if this one's not been combined }
    if not ADirtyRect.Combined then begin
      for j := i - 1 downto 0 do begin
        ASecondRect := TDirtyRect( DirtyRects[ j ] ) ;
        with ASecondRect do if not Combined then begin
          if Bool( IntersectRect( ARect, Rect,
                            ADirtyRect.Rect ) )then
          begin
            UnionRect( ADirtyRect.Rect, ADirtyRect.Rect, Rect ) ;
            Combined := true ;
          end ;
        end ;
      end ;
      CombinedRects.Add( ADirtyRect ) ;
    end else ADirtyRect.Free ;
  end ;
end ;


procedure TSpriteSurface.SetDIBFormat( Value : TDIBFormat ) ;

begin
  if Value <> DIBFormat then begin
    inherited SetDIBFormat( Value ) ;
    PaintBackgroundCanvas ;
    Invalidate ;
    Update ;
  end ;
end ;


procedure TSpriteSurface.ClearOnColorChanged ;

begin
  { don't clear the WinG canvas because the background will be repainted }
end ;


procedure TSpriteSurface.NextFrame( Ticks               : longint ;
                                    TicksSinceLastFrame : longint ;
                                    var OverrunFrames   : longint ) ;

var i, n : SmallInt ;
    OldRect, NewRect, ARect : TRect ;
    OldPalette : HPalette ;
    FrameCount : longint ;
    TicksSince : longint ;
    Rects      : TList ;
    DoDefault  : boolean ;

begin
  if Assigned( FOnNextFrame ) then begin
    DoDefault := true ;
    FOnNextFrame( Self, Ticks, TicksSinceLastFrame, OverrunFrames, DoDefault ) ;
    if not DoDefault then exit ;
  end ;

  { repaint the background }
  n := FSprites.Count - 1 ;
  for i := 0 to n do with TSprite( FSprites[ i ] ) do
    if FVisible then RepaintBackground ;

  { move them all, noting the dirty rects }
  FrameCount := 0 ;
  for i := 0 to n do with TSprite( FSprites[ i ] ) do begin
    if FVisible then OldRect:= Bounds( ActualX, ActualY, ActualW, ActualH ) ;

    { catch up with lost frames }
    FrameCount := TicksSinceLastFrame ;
    TicksSince := FrameInterval ;
    while FrameCount > 0 do begin
      if FrameCount < FrameInterval then TicksSince := FrameCount ;
      Move( TicksSince ) ;
      dec( FrameCount, FrameInterval ) ;
    end ;

    { update the actual position and size }
    ActualX := x ;
    ActualY := y ;
    ActualW := w ;
    ActualH := h ;

    { calculate the new position rect and update canvas }
    if FVisible then begin
      NewRect := Bounds( ActualX, ActualY, ActualW, ActualH ) ;

      { note the dirty rects - combine if the old and new overlap }
      if Bool( IntersectRect( ARect, OldRect, NewRect ) ) then
      begin
        UnionRect( ARect, OldRect, NewRect ) ;
        DirtyRects.Add( TDirtyRect.Create( ARect ) ) ;
      end else begin
        if not IsRectEmpty( OldRect ) then
          DirtyRects.Add( TDirtyRect.Create( OldRect ) ) ;
        if not IsRectEmpty( NewRect ) then
          DirtyRects.Add( TDirtyRect.Create( NewRect ) ) ;
      end ;

      { paint to the WinG canvas }
      Paint( WinGCanvas, Ticks, TicksSinceLastFrame ) ;
    end ;
  end ;

  { and blast the combined rects on to the screen }
  OldPalette := SelectPalette( Canvas.Handle, WinGCanvas.Palette, true ) ;
  try
    if OldPalette = 0 then
      WinGDebug( 'SelectPalette[1] failed in TSpriteSurface.NextFrame' ) ;
    RealizePalette( Canvas.Handle ) ;
    Rects := DirtyRects ;
    for i := Rects.Count - 1 downto 0 do
      with TDirtyRect( Rects[ i ] ).Rect do
        WinGCanvas.WinGCopy( Left, Top, Right - Left, Bottom - Top,
                             Canvas, Left, Top ) ;
  finally
    if SelectPalette( Canvas.Handle, OldPalette, true ) = 0 then
      WinGDebug( 'SelectPalette[2] failed in TSpriteSurface.NextFrame' ) ;
  end ;

  { clear the list of dirty rects }
  ClearList( DirtyRects ) ;

  { return the number of frames we've overrun }
  OverrunFrames := FrameCount ;
end ;


procedure TSpriteSurface.CheckAnimation( ATick : longint ) ;

var ATicksSinceLastFrame : longint ;
    OverrunFrames        : longint ;

begin
  ATicksSinceLastFrame := abs( ATick - LastTick ) ;
  if ATicksSinceLastFrame >= FFrameInterval then begin
    if ATicksSinceLastFrame > FMaxOverrun then
      ATicksSinceLastFrame := FMaxOverrun ;
    NextFrame( ATick, ATicksSinceLastFrame, OverrunFrames ) ;
    LastTick := ATick - OverrunFrames ;
    if ( nLongints < 16000 ) and ( Longints <> nil ) then begin
      inc( nLongints ) ;
      Longints^[ nLongints ] := ATick ;
    end ;
  end ;
end ;


procedure TSpriteSurface.PaintBackgroundCanvas ;

var x, y       : SmallInt ;
    BitsPtr    : pointer ;

begin
  { don't need to do anything if the WinG canvas is zero sized }
  with WinGCanvas.BitmapInfo^.bmiHeader do
    if ( biWidth = 0 ) or ( biHeight = 0 ) then exit ;

  { copy the background color table from the main WinG canvas }
  FBackgroundCanvas.CloneColorTable( WinGCanvas, false ) ;

  { see if there's a background canvas to fill }
  if FBackgroundCanvas.BitmapInfo^.bmiHeader.biWidth > 0 then begin

    { erase the background canvas to make sure }
    if not ( ssTiled in Options ) or FBackground.Empty or
       ( FBackground.Width < Width ) or ( FBackground.Height < Height ) then
      FBackgroundCanvas.FillRect( Rect( 0, 0, Width, Height ) ) ;

    { if we have a background, paint it now }
    if not FBackground.Empty then begin
      BitsPtr := FBackground.Pixels ;
      if ssTiled in Options then begin
        y := 0 ;
        while y < Height do begin
          x := 0 ;
          while x < Width do begin
            if ( x = 0 ) and ( y = 0 ) then begin
              if StretchDIBits( FBackgroundCanvas.Handle,
                                x, y, FBackground.Width, FBackground.Height,
                                0, 0, FBackground.Width, FBackground.Height,
                                BitsPtr,
                                FBackground.BitmapInfo^,
                                DIB_RGB_COLORS, SRCCOPY ) = 0 then
                WinGDebug( 'StretchDIBits[1] failed in PaintBackgroundCanvas' ) ;
            end else begin
              if not BitBlt( FBackgroundCanvas.Handle,
                             x, y, FBackground.Width, FBackground.Height,
                             FBackgroundCanvas.Handle, 0, 0, SRCCOPY ) then
                WinGDebug( 'BitBlt[1] failed in ' +
                           'TSpriteSurface.PaintBackgroundCanvas' ) ;
            end ;
            inc( x, FBackground.Width ) ;
          end ;
          inc( y, FBackground.Height ) ;
        end ;
      end else begin
        { if the image is smaller than the canvas then centre it }
        x := 0 ;
        y := 0 ;
        if Width > FBackground.Width then
          x := ( Width - FBackground.Width ) div 2 ;
        if Height > FBackground.Height then
          y := ( Height - FBackground.Height ) div 2 ;
        if StretchDIBits( FBackgroundCanvas.Handle,
                          x, y,
                          FBackground.Width, FBackground.Height,
                          0, 0, FBackground.Width, FBackground.Height,
                          BitsPtr,
                          FBackground.BitmapInfo^,
                          DIB_RGB_COLORS, SRCCOPY ) = 0 then
          WinGDebug( 'StretchDIBits[2] failed in ' +
                     'TSpriteSurface.PaintBackgroundCanvas' ) ;
      end ;
    end ;

    { now copy from the background canvas to the WinGCanvas }
    if not BitBlt( WinGCanvas.Handle, 0, 0, Width, Height,
                   FBackgroundCanvas.Handle, 0, 0, SRCCOPY ) then
      WinGDebug( 'BitBlt[2] failed in TSpriteSurface.PaintBackgroundCanvas' ) ;

  end else
    WinGCanvas.FillRect( Rect( 0, 0, Width, Height ) ) ;
end ;


function  TSpriteSurface.GetMasterDIB : TDIB ;

var i : SmallInt ;

begin
  { get the master DIB from the background or a sprite }
  Result := nil ;
  if PaletteSource = mpBackground then Result := FBackground else
  begin
    i := FSprites.IndexOf( PaletteSource ) ;
    if i >= 0 then Result := TSprite( PaletteSource ).Image as TDIB ;
  end ;
end ;


procedure TSpriteSurface.PaletteSourceChanged ;

var AMasterDIB : TDIB ;
    i          : SmallInt ;

begin
  { put up the hourglass if we're designing }
  if csDesigning in ComponentState then Screen.Cursor := crHourGlass ;
  try
    { if we have a valid DIB, then set the WinG color table from that }
    AMasterDIB := MasterDIB ;
    if Assigned( AMasterDIB ) then begin
      WinGCanvas.CopyColorTableFromDIB( AMasterDIB.BitmapInfo, true ) ;

      { now update the background canvas }
      PaintBackgroundCanvas ;
      Repaint ;

      { and the sprites }
      for i := FSprites.Count - 1 downto 0 do
        TSprite( FSprites[ i ] ).CreateFrames ;

      { if we're designing then force an update since it doesn't always work }
      if csDesigning in ComponentState then Update ;
    end ;
  finally
    if csDesigning in ComponentState then Screen.Cursor := crDefault ;
  end ;
end ;


procedure TSpriteSurface.SetPaletteSource( Value : TSpriteAbs ) ;

begin
  if FPaletteSource <> Value then begin
    FPaletteSource := Value ;
    if not Assigned( Value ) or not ( csLoading in Value.ComponentState ) then
      PaletteSourceChanged ;
  end ;
end ;


procedure TSpriteSurface.Notification( AComponent : TComponent ;
                                       Operation  : TOperation ) ;

begin
  inherited Notification( AComponent, Operation ) ;
  if ( Operation = opRemove ) and ( PaletteSource = AComponent ) and
     not ( csDestroying in ComponentState ) then
    PaletteSource := NIL ;
end ;


procedure TSpriteSurface.SetFrameInterval( Value : word ) ;

begin
  if FFrameInterval <> Value then begin
    FFrameInterval := Value ;
    FMaxOverrun := Value + Value ;
  end ;
end ;


procedure TSpriteSurface.BackgroundChanged( Sender : TObject ) ;

begin
  { set the size }
  FBackgroundCanvas.Resize( Width, Height ) ;

  { set the palette or explicitly recreate the background canvas }
  if PaletteSource = mpBackground then PaletteSourceChanged else
    PaintBackgroundCanvas ;

  { update the display }
  Invalidate ;
end ;


function  TSpriteSurface.GetBackground : TGraphic ;

begin
  Result := FBackground ;
end ;


procedure TSpriteSurface.SetBackground( Value : TGraphic ) ;

begin
  if Value <> FBackground then FBackground.Assign( Value ) ;
end ;


procedure TSpriteSurface.SetOptions( Value : TSpriteSurfaceOptions ) ;

var OldOptions : TSpriteSurfaceOptions ;

begin
  if Value <> FOptions then begin
    OldOptions := FOptions ;
    FOptions := Value ;
    if ( ssTiled in Options ) <> ( ssTiled in OldOptions ) then begin
      PaintBackgroundCanvas ;
      InvalidateRect( Handle, nil, false ) {Repaint} ;
    end ;
  end ;
end ;


procedure TSpriteSurface.WMSize( var Message : TWMSize ) ;

begin
  inherited ;
  { recreate the background canvas in the new size }
  FBackgroundCanvas.Resize( Message.Width, Message.Height ) ;
  PaintBackgroundCanvas ;
end ;


procedure TSpriteSurface.CMColorChanged( var Message : TMessage ) ;

begin
  inherited ;
  FBackgroundCanvas.Brush.Color := Color ;
  PaintBackgroundCanvas ;
end ;


{ Exception handler }

type
  TMyHandler = class
    procedure HandleException( Sender : TObject ;
                               E      : Exception ) ;
  end ;

procedure TMyHandler.HandleException( Sender : TObject ;
                                      E      : Exception ) ;

var NotedOnMessage : TMessageEvent ;
    NotedOnIdle    : TIdleEvent ;

begin
  LogIt( Format( '*** Exception caught by SpriteKit at %s on %s:-',
                 [ TimeToStr( Time ), DateToStr( Date ) ] ) ) ;
  LogIt( '  -' + E.Message ) ;
  LogIt( Format( '  -Exe name is %s', [ Forms.Application.ExeName ] ) ) ;

  { disable any OnMessage and OnIdle processing }
  NotedOnMessage := Application.OnMessage ;
  NotedOnIdle := Application.OnIdle ;
  try
    Application.OnMessage := NIL ;
    Application.OnIdle := NIL ;
    if MessageDlg( Format( 'SpriteKit has detected the following exception:'#13 +
                           '%s'#13'Do you want to continue?', [ E.Message ] ),
                   mtInformation, [ mbYes, mbNo ], 0 ) = mrNo then
    begin
      LogIt( '  -Halting' ) ;
      Halt ;
    end else LogIt( '  -Continuing' ) ;
  finally
    Application.OnIdle := NotedOnIdle ;
    Application.OnMessage := NotedOnMessage ;
  end ;
end ;


const WinGModule : THandle = 0 ;

procedure LoadWinG ;

  function  Get( const ProcName : string ) : pointer ;

  var Temp : array[ 0..63 ] of char ;

  begin
    Result := GetProcAddress( WinGModule, StrPCopy( Temp, ProcName ) ) ;
    if Result = nil then WinGError( 'Unable to get address of ' + ProcName ) ;
  end ;

const DLLName = {$IFDEF Win32} 'WING32.DLL' {$ELSE} 'WING.DLL' {$ENDIF} ;

begin
  WinGModule := LoadLibrary( DLLName ) ;
  if WinGModule < 32 then
    WinGError( Format( 'Unable to load %s (LoadLibrary=%d)',
                       [ StrPas( DLLName ), WinGModule ] ) ) ;
  try
    @WinGCreateDC := Get( 'WinGCreateDC' ) ;
    @WinGCreateBitmap := Get( 'WinGCreateBitmap' ) ;
    @WinGGetDIBPointer := Get( 'WinGGetDIBPointer' ) ;
    @WinGRecommendDIBFormat := Get( 'WinGRecommendDIBFormat' ) ;
    @WinGGetDIBColorTable := Get( 'WinGGetDIBColorTable' ) ;
    @WinGSetDIBColorTable := Get( 'WinGSetDIBColorTable' ) ;
    @WinGBitBlt := Get( 'WinGBitBlt' ) ;
    @WinGStretchBlt := Get( 'WinGStretchBlt' ) ;
    @WinGCreateHalftoneBrush := Get( 'WinGCreateHalftoneBrush' ) ;
    @WinGCreateHalftonePalette := Get( 'WinGCreateHalftoneBrush' ) ;
  except
    FreeLibrary( WinGModule ) ;
    WinGModule := 0 ;
    Raise ;
  end ;
end ;


{ clear the system palette to black }

procedure ClearSystemPalette ;

var ALogPalette  : PLogPalette ;
    i            : integer ;
    DC           : HDC ;
    APalette     : HPalette ;
    AnOldPalette : HPalette ;
    AWindow      : HWnd ;

begin
  GetMem( ALogPalette, LogPaletteSize ) ;
  with ALogPalette^ do try
    palVersion := $300 ;
    palNumEntries := 256 ;
    for i := 0 to 255 do with palPalEntry[ i ] do begin
      peRed := 0 ;
      peGreen := 0 ;
      peBlue := 0 ;
      peFlags := PC_NOCOLLAPSE ;
    end ;

    { select and realise the palette and clean up }
    APalette := 0 ;
    AnOldPalette := 0 ;
    AWindow := GetFocus ;
    DC := GetDC( AWindow ) ;
    try
      APalette := CreatePalette( ALogPalette^ ) ;
      AnOldPalette := SelectPalette( DC, APalette, false ) ;
      RealizePalette( DC ) ;
    finally
      if AnOldPalette <> 0 then SelectPalette( DC, AnOldPalette, true ) ;
      if APalette <> 0 then DeleteObject( APalette ) ;
      ReleaseDC( AWindow, DC ) ;
    end ;
  finally
    FreeMem( ALogPalette, LogPaletteSize ) ;
  end ;
end ;


{ Animation checking procedure }

procedure CheckWinGAnimation ;

var ATick     : longint ;
    i, n      : SmallInt ;

begin
  { give sprites a crack at the whip }
  ATick := timeGetTime ;
  if ATick <> WinGLastTick then begin
    n := SpriteSurfaces.Count - 1 ;
    for i := 0 to n do
      TSpriteSurface( SpriteSurfaces[ i ] ).CheckAnimation( ATick ) ;
    WinGLastTick := ATick ;
  end ;
end ;


{ TAnimationChecker }

type
  TAnimationChecker = class
  private
    procedure OnIdle( Sender   : TObject ;
                      var Done : boolean ) ;
    procedure OnMessage( var Msg     : TMsg ;
                         var Handled : Boolean ) ;
  end ;

procedure TAnimationChecker.OnIdle( Sender   : TObject ;
                                    var Done : boolean ) ;

begin
  CheckWinGAnimation ;
  Done := false ;
end ;


procedure TAnimationChecker.OnMessage( var Msg     : TMsg ;
                                       var Handled : Boolean ) ;

begin
  CheckWinGAnimation ;
  Handled := false ;
end ;

const AnimationChecker : TAnimationChecker = NIL ;

var MyHandler : TMyHandler ;

{ Unit cleanup }

procedure DoneApplication ; far ;

begin
  SpriteSurfaces.Free ;

  { if debugging, log that we've finished and free exception handler }
  if DebugLevel > dlNone then begin
    LogIt( Format( 'Module is %s', [ Forms.Application.ExeName ] ) ) ;
    LogIt( Format( 'SpriteKit closing at %s on %s (HInstance=%-.4xH)',
                   [ TimeToStr( Time ), DateToStr( Date ), HInstance ] ) ) ;
    LogIt( '--------------------------------------------------------------------' ) ;
    Forms.Application.OnException := nil ;
    MyHandler.Free ;
  end ;

  { clean up and log if necessary }
  if WinGModule >= 32 then FreeLibrary( WinGModule ) ;
  if DebugLevel = dlDebugOutput then begin
    OutputDebugString( StrFmt( DebugBuffer, 'SpriteKit closing at %s on %s'#13,
                               [ TimeToStr( Time ), DateToStr( Date ) ] ) ) ;
    OutputDebugString( StrFmt( DebugBuffer, 'HInstance=%-.4xH'#13,
                               [ HInstance ] ) ) ;
  end ;
  FreeMem( DebugBuffer, 256 ) ;
  DebugBuffer := nil ;
  AnimationChecker.Free ;
end;


{ Get debugging level from INI file }
procedure GetDebugLevel ;

const Strings : array[ TDebugLevel ] of string[ 15 ] =
                ( 'dlNone', 'dlShowMessage', 'dlDebugOutput',
                  'dlRaiseException' ) ;

var IniFile     : TIniFile ;
    sDebugLevel : string ;
    nDebugLevel : SmallInt ;
    DL          : TDebugLevel ;
    Decoded     : boolean ;

begin
  IniFile := TIniFile.Create( IniFileName ) ;
  try
    sDebugLevel := IniFile.ReadString( 'Debugging', 'DebugLevel', '' ) ;
    if sDebugLevel <> '' then begin
      Decoded := false ;
      if sDebugLevel[ 1 ] in [ '0'..'9' ] then begin
        nDebugLevel := StrToInt( sDebugLevel ) ;
        if TDebugLevel( nDebugLevel ) in [ dlNone..dlRaiseException ] then
        begin
          DebugLevel := TDebugLevel( nDebugLevel ) ;
          Decoded := true ;
        end ;
      end else begin
        for DL := dlNone to dlRaiseException do
          if CompareText( sDebugLevel, Strings[ DL ] ) = 0 then
        begin
          DebugLevel := DL ;
          Decoded := true ;
          break ;
        end ;
      end ;
      if not Decoded then
        ShowMessage( Format( 'Invalid debug entry in %s - '#13'DebugLevel=%s',
                             [ IniFileName, sDebugLevel ] ) ) ;
    end ;
  finally
    IniFile.Free ;
  end ;
end ;


{ CheckDVA386 - this is required because the installer cannot add a
  device=dva.386 entry to the INI file without having it replace the first
  device=xxxx entry. This is presumably because the Windows API function
  WritePrivateProfileString has no way to add duplicate entries to an
  INI file. Grrrrr - what a PAIN! :-( }

procedure CheckDVA386 ;

const Section = '[386ENH]' ;

var T, OutFile : System.Text ;
    S : string ;
    WinDir : array[ 0..255 ] of char ;

  function  FindDVADriverEntry : boolean ;
  begin
    Result := false ;
    System.Reset( T ) ;
    try
      { find the 386Enh section }
      Result := false ;
      while not EOF( T ) and not Result do begin
        readln( T, S ) ;
        if ( S <> '' ) and ( S[ 1 ] = '[' ) then begin
          S := UpperCase( S ) ;
          if not EOF( T ) and ( Pos( Section, S ) = 1 ) then begin
            repeat
              Readln( T, S ) ;
              if ( S <> '' ) and ( S[ 1 ] = '[' ) then exit ;
              S := UpperCase( S ) ;
              if pos( 'DEVICE', S ) = 1 then begin
                Result := pos( 'DVA.386', S ) <> 0 ;
                if Result then break ;
              end ;
            until EOF( T ) ;
          end ;
        end ;
      end ;
    finally
      System.Close( T ) ;
    end ;
  end ;

var DVAInstalled : boolean ;

begin
  { see if DVA.386 is marked as installed }
  with TIniFile.Create( IniFileName ) do try
    DVAInstalled := ReadBool( 'Installation', 'DVA386', false ) ;
  finally
    Free ;
  end ;
  if DVAInstalled then exit ;

  { try to install DVA.386 }
  GetWindowsDirectory( WinDir, sizeof( WinDir ) - 1 ) ;
  System.Assign( T, StrPas( WinDir ) + '\system.ini' ) ;
  DVAInstalled := FindDVADriverEntry ;
  if not DVAInstalled then begin
    ShowMessage( 'This is the first time SpriteKit has loaded.'#13#13 +
                 'Your system will now be updated to complete the SpriteKit installation procedure.' ) ;
    WritePrivateProfileString( '386Enh', 'MDSdevice',
                               'dva.386', 'SYSTEM.INI' ) ;
    Reset( T ) ;
    try
      System.Assign( OutFile, StrPas( WinDir ) + '\System.$$$' ) ;
      System.Rewrite( OutFile ) ;
      try
        try
          while not EOF( T ) do begin
            readln( T, S ) ;
            if S = 'MDSdevice=dva.386' then S := 'device=dva.386' ;
            writeln( OutFile, S ) ;
          end ;
        finally
          System.Close( OutFile ) ;
        end ;
      except
        System.Erase( OutFile ) ;
        Raise ;
      end ;
    finally
      System.Close( T ) ;
    end ;
    S := StrPas( WinDir ) ;
    SysUtils.DeleteFile( S + '\system.mds' ) ;
    if not RenameFile( S + '\System.ini', S + '\system.mds' ) then
      Raise Exception.Create( 'Unable to rename system.ini to system.mds' ) ;
    try
      if not RenameFile( S + '\System.$$$', S + '\system.ini' ) then
        Raise Exception.Create( 'Unable to rename system.$$$ to system.ini' ) ;
    except
      RenameFile( S + '\system.mds', S + '\system.ini' ) ;
      Raise ;
    end ;
    ShowMessage( 'SpriteKit installation complete.'#13#13+
                 'You need to restart Windows for the changes to take effect.' ) ;
    DVAInstalled := true ;
  end ;

  { mark installed in the ini file }
  if DVAInstalled then with TIniFile.Create( IniFileName ) do try
    WriteBool( 'Installation', 'DVAInstalled', true ) ;
  finally
    Free ;
  end ;
end ;


procedure InstallApplicationHandlers ;

var OldOnIdle : TIdleEvent ;
    OldOnMessage : TMessageEvent ;

begin
  AnimationChecker := TAnimationChecker.Create ;

  { only install if there are not already events installed }
  OldOnIdle := Application.OnIdle ;
  if not Assigned( OldOnIdle ) then
    Application.OnIdle := AnimationChecker.OnIdle ;
  OldOnMessage := Application.OnMessage ;
  if not Assigned( OldOnMessage ) then
    Application.OnMessage := AnimationChecker.OnMessage ;
end ;


begin
  { add the exit proc }
  AddExitProc( DoneApplication ) ;
  CheckDVA386 ;

  { allocate space for debugging PChar and get debugging level }
  GetMem( DebugBuffer, 256 ) ;
  GetDebugLevel ;

  { if debugging set to the debugging output, log some info }
  if DebugLevel = dlDebugOutput then begin
    OutputDebugString( StrFmt( DebugBuffer,
                               'SpriteKit starting at %s on %s'#13,
                               [ TimeToStr( Time ), DateToStr( Date ) ] ) ) ;
    OutputDebugString( StrFmt( DebugBuffer,
                               'Module is %s'#13,
                               [ Forms.Application.ExeName ] ) ) ;
    OutputDebugString( StrFmt( DebugBuffer, 'HInstance=%-.4xH'#13,
                               [ HInstance ] ) ) ;
  end ;

  { load WinG library }
  LoadWinG ;

  { set up a logging exception handler if debugging }
  if DebugLevel > dlNone then begin
    MyHandler := TMyHandler.Create ;
    Forms.Application.OnException := MyHandler.HandleException ;
    LogIt( '===================================================================' ) ;
    LogIt( Format( 'SpriteKit starting at %s on %s (HInstance=%-.4xH)',
                   [ TimeToStr( Time ), DateToStr( Date ), HInstance ] ) ) ;
    LogIt( Format( 'Module is %s', [ Forms.Application.ExeName ] ) ) ;
  end ;

  { clear the system palette }
  ClearSystemPalette ;

  { create list of sprite surfaces and register stuff }
  SpriteSurfaces := TList.Create ;

  { install Application OnMessage and OnIdle handlers }
  InstallApplicationHandlers ;
end.
