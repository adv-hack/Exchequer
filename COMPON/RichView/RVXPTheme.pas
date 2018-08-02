
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Windows XP Themes API                           }
{       (only functions required for RichView)          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVXPTheme;

interface
{$I RV_Defs.inc}

uses SysUtils, Windows;

type
  HTheme = Cardinal;
  TThemeSize = (
    TS_MIN,             // minimum size
    TS_TRUE,            // size without stretching
    TS_DRAW             // size that theme mgr will use to draw part
  );

  TRV_IsThemeActiveProc = function : boolean; stdcall;
  TRV_IsAppThemedProc =  function: boolean; stdcall;
  TRV_OpenThemeDataProc = function (hwnd : HWND; pszClassList : PWideChar) : HTheme; stdcall;
  TRV_CloseThemeDataProc= function (Theme : HTheme) : HRESULT; stdcall;
  TRV_DrawThemeParentBackgroundProc = function (hwnd : HWND; hdc : HDC; Rect : PRect) : HRESULT; stdcall;
  TRV_DrawThemeEdgeProc = function(Theme : HTheme; hdc : HDC;
    iPartId, iStateId: Integer; const pDestRect: TRect; uEdge, uFlags: UINT;
    pContentRect: PRect): HRESULT; stdcall;
  TRV_DrawThemeBackgroundProc = function (Theme : HTheme; hdc : HDC;
    iPartId : integer; iStateId : integer; const Rect : TRect; {OPTIONAL} pClipRect : PRect) : HRESULT; stdcall;
  TRV_DrawThemeTextProc = function (Theme : HTheme; hdc : HDC; iPartId, iStateId : integer;
    pszText : PWideChar; iCharCount : integer; dwTextFlags : DWORD;
    dwTextFlags2 : DWORD; var Rect : TRect) : HRESULT; stdcall;
  TRV_IsThemeBackgroundPartiallyTransparentProc =
    function(hTheme: HTheme; iPartId, iStateId: Integer): Boolean; stdcall;
  TRV_GetThemeRectProc = function(Theme: HTheme; iPartId, iStateId, iPropId: Integer;
    var pRect: TRect): HRESULT; stdcall;
  TRV_GetThemePartSizeProc = function (hTheme: HTheme; hdc: HDC;
    iPartId, iStateId: Integer; prc: PRECT; eSize: TThemeSize;
    var psz: TSize): HRESULT; stdcall;

var
  RV_IsThemeActive: TRV_IsThemeActiveProc;
  RV_IsAppThemed: TRV_IsAppThemedProc;
  RV_OpenThemeData: TRV_OpenThemeDataProc;
  RV_CloseThemeData: TRV_CloseThemeDataProc;
  RV_DrawThemeParentBackground: TRV_DrawThemeParentBackgroundProc;
  RV_DrawThemeEdge: TRV_DrawThemeEdgeProc;
  RV_DrawThemeBackground: TRV_DrawThemeBackgroundProc;
  RV_DrawThemeText: TRV_DrawThemeTextProc;
  RV_IsThemeBackgroundPartiallyTransparent: TRV_IsThemeBackgroundPartiallyTransparentProc;
  RV_GetThemeRect: TRV_GetThemeRectProc;
  RV_GetThemePartSize: TRV_GetThemePartSizeProc;

const
{$IFNDEF RICHVIEWDEF2006}
  WM_THEMECHANGED          = $031A;
{$ENDIF}

  // Parts and states

  EP_EDITTEXT              = 1;

  ETS_NORMAL               = 1;
  ETS_HOT                  = 2;
  ETS_SELECTED             = 3;
  ETS_DISABLED             = 4;
  ETS_FOCUSED              = 5;
  ETS_READONLY             = 6;
  ETS_ASSIST               = 7;

  BP_RADIOBUTTON          = 2;

  RBS_UNCHECKEDNORMAL     = 1;
  RBS_UNCHECKEDHOT        = 2;
  RBS_UNCHECKEDPRESSED    = 3;
  RBS_UNCHECKEDDISABLED   = 4;
  RBS_CHECKEDNORMAL       = 5;
  RBS_CHECKEDHOT          = 6;
  RBS_CHECKEDPRESSED      = 7;
  RBS_CHECKEDDISABLED     = 8;

  BP_CHECKBOX             = 3;

  CBS_UNCHECKEDNORMAL     = 1;
  CBS_UNCHECKEDHOT        = 2;
  CBS_UNCHECKEDPRESSED    = 3;
  CBS_UNCHECKEDDISABLED   = 4;
  CBS_CHECKEDNORMAL       = 5;
  CBS_CHECKEDHOT          = 6;
  CBS_CHECKEDPRESSED      = 7;
  CBS_CHECKEDDISABLED     = 8;
  CBS_MIXEDNORMAL         = 9;
  CBS_MIXEDHOT            = 10;
  CBS_MIXEDPRESSED        = 11;
  CBS_MIXEDDISABLED       = 12;

  BP_GROUPBOX             = 4;

  GBS_NORMAL              = 1;
  GBS_DISABLED            = 2;

  CP_DROPDOWNBUTTON        = 1;

  CBXS_NORMAL              = 1;
  CBXS_HOT                 = 2;
  CBXS_PRESSED             = 3;
  CBXS_DISABLED            = 4;

  SBP_ARROWBTN             = 1;
  SBP_THUMBBTNHORZ         = 2;
  SBP_THUMBBTNVERT         = 3;
  SBP_LOWERTRACKHORZ       = 4;
  SBP_UPPERTRACKHORZ       = 5;
  SBP_LOWERTRACKVERT       = 6;
  SBP_UPPERTRACKVERT       = 7;
  SBP_GRIPPERHORZ          = 8;
  SBP_GRIPPERVERT          = 9;
  SBP_SIZEBOX              = 10;

  ABS_UPNORMAL             = 1;
  ABS_UPHOT                = 2;
  ABS_UPPRESSED            = 3;
  ABS_UPDISABLED           = 4;
  ABS_DOWNNORMAL           = 5;
  ABS_DOWNHOT              = 6;
  ABS_DOWNPRESSED          = 7;
  ABS_DOWNDISABLED         = 8;
  ABS_LEFTNORMAL           = 9;
  ABS_LEFTHOT              = 10;
  ABS_LEFTPRESSED          = 11;
  ABS_LEFTDISABLED         = 12;
  ABS_RIGHTNORMAL          = 13;
  ABS_RIGHTHOT             = 14;
  ABS_RIGHTPRESSED         = 15;
  ABS_RIGHTDISABLED        = 16;
  ABS_UPHOVER              = 17;   { For Windows >= Vista }
  ABS_DOWNHOVER            = 18;   { For Windows >= Vista }
  ABS_LEFTHOVER            = 19;   { For Windows >= Vista }
  ABS_RIGHTHOVER           = 20;   { For Windows >= Vista }

  SCRBS_NORMAL             = 1;
  SCRBS_HOT                = 2;
  SCRBS_PRESSED            = 3;
  SCRBS_DISABLED           = 4;
  SCRBS_HOVER              = 5;   { For Windows >= Vista }

  // Properties

  TMT_DEFAULTPANESIZE      = 5002;

implementation

var hThemeLib: HINST;

procedure Init;
begin
  hThemeLib := 0;
  if (Win32Platform  = VER_PLATFORM_WIN32_NT)
     {$IFDEF RICHVIEWCBDEF3}
      and
     (((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)) or
      (Win32MajorVersion > 5))
     {$ENDIF}
      then
  begin
    RV_IsThemeActive := nil;
    RV_IsAppThemed := nil;
    RV_OpenThemeData := nil;
    RV_CloseThemeData := nil;
    RV_DrawThemeParentBackground := nil;
    RV_DrawThemeText := nil;
    RV_DrawThemeEdge := nil;
    RV_DrawThemeBackground := nil;
    RV_IsThemeBackgroundPartiallyTransparent := nil;
    RV_GetThemeRect := nil;
    RV_GetThemePartSize := nil;
    hThemeLib := LoadLibrary('uxtheme.dll');
    if hThemeLib <> 0 then
    begin
      RV_IsThemeActive := GetProcAddress(hThemeLib, 'IsThemeActive');
      RV_IsAppThemed   := GetProcAddress(hThemeLib, 'IsAppThemed');
      RV_OpenThemeData := GetProcAddress(hThemeLib, 'OpenThemeData');
      RV_CloseThemeData := GetProcAddress(hThemeLib, 'CloseThemeData');
      RV_DrawThemeParentBackground := GetProcAddress(hThemeLib, 'DrawThemeParentBackground');
      RV_DrawThemeText := GetProcAddress(hThemeLib, 'DrawThemeText');
      RV_DrawThemeEdge := GetProcAddress(hThemeLib, 'DrawThemeEdge');
      RV_DrawThemeBackground := GetProcAddress(hThemeLib, 'DrawThemeBackground');
      RV_IsThemeBackgroundPartiallyTransparent := GetProcAddress(hThemeLib, 'IsThemeBackgroundPartiallyTransparent');
      RV_GetThemeRect := GetProcAddress(hThemeLib, 'GetThemeRect');
      RV_GetThemePartSize := GetProcAddress(hThemeLib, 'GetThemePartSize');
    end;
  end;
end;

initialization
  Init;
finalization
  if hThemeLib <> 0 then
    FreeLibrary(hThemeLib);


end.
