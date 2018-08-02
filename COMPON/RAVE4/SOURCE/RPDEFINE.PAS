{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPDefine;

interface

{.$DEFINE DBG} { Used for data connection thread debugging }

{$I RPVer.pas}

uses
  {$IFDEF DEMO}{$IFDEF Linux}QDialogs{$ELSE}Dialogs{$ENDIF},{$ENDIF}
  {$IFDEF DESIGNER}{$IFDEF Linux}QForms{$ELSE}Forms{$ENDIF},{$ENDIF}
  {$IFDEF Linux}
  QGraphics, Qt, Libc,
  {$ELSE}
  Windows, Graphics,
  {$ENDIF}
  DB, SysUtils, Classes;

{ Status format characters }
{ %% - % character }
{ %p - Current Page }
{ %f - First Page }
{ %l - Last Page }
{ %d - Printer Device Name }
{ %r - Printer Driver Name }
{ %t - Printer Port }
{ %c - Current Pass - used for printers that don't support multiple pages }
{ %s - Total Passes - used for printers that don't support multiple pages }
{ %0 through %9 - Status Text Line }

const
{$IFDEF DEMO}
  RunMode = '/Demo';
{$ELSE}
  RunMode = '';
{$ENDIF}

{$IFDEF VER80}
  CompVer = 'D1';
{$ENDIF}
{$IFDEF VER90}
  CompVer = 'D2';
{$ENDIF}
{$IFDEF VER93}
  CompVer = 'C1';
{$ENDIF}
{$IFDEF VER100}
  CompVer = 'D3';
{$ENDIF}
{$IFDEF VER110}
  CompVer = 'C3';
{$ENDIF}
{$IFDEF VER120}
  CompVer = 'VCL4';
{$ENDIF}
{$IFDEF VER125}
  CompVer = 'VCL4';
{$ENDIF}
{$IFDEF VER130}
  CompVer = 'VCL5';
{$ENDIF}
{$IFDEF VER140}
  CompVer = 'VCL6';
{$ENDIF}
{$IFDEF VER150}
  CompVer = 'VCL7';
{$ENDIF}

  // RPDD - HM 27/11/02: Added Drill-Down support
  RPVersion = '4.05 (' + CompVer + RunMode + ') (ESL/DD)'; { Current revision number }

{ Specify versions of BCB that support HPPEMIT }
{$IFNDEF VER80}{$IFNDEF VER90}{$IFNDEF VER93}{$IFNDEF VER100}{$IFNDEF VER120}
{$IFNDEF VER130}{$IFNDEF VER140}{$IFNDEF VER150}
  {$DEFINE BCB_HPPEMIT}
{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}
{$IFDEF VER130}{$IFDEF BCB}
  {$DEFINE BCB_HPPEMIT}
{$ENDIF}{$ENDIF}

  NA = -32768; { n/a value }

  BOXLINENONE = 0;
  BOXLINELEFT = 1;
  BOXLINERIGHT = 2;
  BOXLINELEFTRIGHT = 3;
  BOXLINETOP = 4;
  BOXLINELEFTTOP = 5;
  BOXLINERIGHTTOP = 6;
  BOXLINENOBOTTOM = 7;
  BOXLINEBOTTOM = 8;
  BOXLINELEFTBOTTOM = 9;
  BOXLINERIGHTBOTTOM = 10;
  BOXLINENOTOP = 11;
  BOXLINETOPBOTTOM = 12;
  BOXLINENORIGHT = 13;
  BOXLINENOLEFT = 14;
  BOXLINEALL = 15;

  BOXLINEHORIZ = BOXLINETOPBOTTOM; { Don't use, replaced by BOXLINETOPBOTTOM }
  BOXLINEVERT = BOXLINELEFTRIGHT; { Don't use, replaced by BOXLINELEFTRIGHT }

  MAXSAVEFONT = 10;
  MAXSAVETABS = 10;
  MAXSAVEPOS = 10;

  MAXWORDLEN = 65520;
  MAXBUFSIZE = 2000000000;

  MINPREVIEWZOOM = 10.0;
  MAXPREVIEWZOOM = 200.0;

{ ReportPrinter Commands }
{ GDI commands }
  rpcArc = 1;
  rpcBrushCopy = 2;
  rpcChord = 3;
  rpcCopyRect = 4;
  rpcDraw = 5;
  rpcDrawFocusRect = 6;
  rpcEllipse = 7;
  rpcFillRect = 8;
  rpcFloodFill = 9;
  rpcFrameRect = 10;
  rpcLineTo = 11;
  rpcMoveTo = 12;
  rpcPie = 13;
  rpcPolygon = 14;
  rpcPolyline = 15;
  rpcPrintBitmap = 16;
  rpcPrintBitmapRect = 17;
  rpcRectangle = 18;
  rpcTabRectangle = 19;
  rpcRoundRect = 20;
  rpcStretchDraw = 21;
  rpcTextRect = 22;
  rpcCenterText = 23;
  rpcLeftText = 24;
  rpcRightText = 25;
  rpcSetTextBKMode = 26;
  rpcSetBKColor = 27;
  rpcSetScaleX = 28;
  rpcSetScaleY = 29;
  rpcPrintData = 30;
  rpcPrintDataStream = 31;
  rpcPrintSpaces = 32;
  rpcBlockText = 33;
  rpcTransBitmap = 34;
  rpcSetFrameMode = 35;
  rpcPrintImageRect = 36;
  rpcVariableData = 37;

{ Brush commands }
  rpcSetBrush = 40;
  rpcSetBrushColor = 41;
  rpcSetBrushStyle = 42;
  rpcSetBrushBitmap = 43;

{ Font commands }
  rpcSetFont = 50;
  rpcSetFontName = 51;
  rpcSetFontColor = 52;
  rpcSetFontPitch = 53;
  rpcSetFontHeight = 54;
  rpcSetFontBold = 55;
  rpcSetFontUnderline = 56;
  rpcSetFontItalic = 57;
  rpcSetFontStrikeout = 58;
  rpcSetFontSuperscript = 59;
  rpcSetFontSubscript = 60;
  rpcSetFontRotation = 61;
  rpcSetFontAlign = 62;
  rpcSetFontCharset = 63;

{ Pen commands }
  rpcSetPen = 70;
  rpcSetPenColor = 71;
  rpcSetPenMode = 72;
  rpcSetPenStyle = 73;
  rpcSetPenWidth = 74;

{ Misc commands }
  rpcNewPage = 80;
  rpcJobHeader11 = 81; { Old ReportPrinter 1.1 Header }
  rpcEndPage = 82;
  rpcResetLineHeight = 83;
  rpcAllowPreviewOnly = 84;
  rpcAllowPrinterOnly = 85;
  rpcAllowAll = 86;
  rpcSetOrientation = 87;
  rpcSetBin = 88;
  rpcJobHeader20i = 89; { Old ReportPriner Pro 2.0a-i Header }
  rpcJobHeader = 90; { ReportPriner Pro 2.0j- Header }

{ All user created commands should start here }
  rpcUser = 200;
  rpcJustText  = rpcUser + 1;
  rpcTextRect2 = rpcUser + 2;
  rpcPrintBitmapRect2 = rpcUser + 3;
  // RPDD - HM 27/11/02: Added Drill-Down support
  rpcDrillDown = rpcUser + 4;
  // RPDD - HM 27/11/02: Added generic bespoke support
  rpcBespoke = rpcUser + 5;

  FontString =
   'abcdefg hijklmnop qrstuv wxyz ABCDEFG HIJKLMNOP QRSTUV WXYZ 0123456789';

  RTFIgnoreDest: array[1..32] of string[10] = (
   'author','buptim','comment','creatim','doccomm',
   'footer','footerf','footerl','footerr','footnote',
   'ftncn','ftnsep','ftnsepc','header','headerf',
   'headerl','headerr','info','keywords','operator',
   'pict','printim','private1','revtim','rxe',
   'stylesheet','subject','tc','title','txe','xe','*');

{ *** RPTF Constants *** }
  RPTFPrefix = #1; { Begins an RPTF formatting block }
  RPTFInfix = #2; { Separates commands within an RPTF formatting blocks }
  RPTFSeparator = #3; { Used to separate parameters }
  RPTFSuffix = #4; { Ends an RPTF formatting block }

  RPTFOff = '0';
  RPTFOn = '1';
  RPTFLeft = 'L';
  RPTFCenter = 'C';
  RPTFRight = 'R';
  RPTFBlock = 'B';

{ RPTF Commands }
  RPTFIgnore = ' ';
  RPTFBold = 'B';
  RPTFItalic = 'I';
  RPTFUnderline = 'U';
  RPTFStrikeout = 'K';
  RPTFSuperscript = 'P';
  RPTFSubscript = 'S';
  RPTFName = 'N';
  RPTFSize = 'Z';
  RPTFColor = 'C';
  RPTFPitch = 'H';
  RPTFResetParagraph = 'R';
  RPTFResetStyle = 'r';
  RPTFJustify = 'J';
  RPTFFirstIndent = 'F';
  RPTFLeftIndent = 'L';
  RPTFRightIndent = 'G';

{ RPTF Macros }
{$IFNDEF BCB_HPPEMIT}
  BoldOn = RPTFPrefix + RPTFBold + RPTFOn + RPTFSuffix;
  BoldOff = RPTFPrefix + RPTFBold + RPTFOff + RPTFSuffix;
  ItalicOn = RPTFPrefix + RPTFItalic + RPTFOn + RPTFSuffix;
  ItalicOff = RPTFPrefix + RPTFItalic + RPTFOff + RPTFSuffix;
  UnderlineOn = RPTFPrefix + RPTFUnderline + RPTFOn + RPTFSuffix;
  UnderlineOff = RPTFPrefix + RPTFUnderline + RPTFOff + RPTFSuffix;
  StrikeoutOn = RPTFPrefix + RPTFStrikeout + RPTFOn + RPTFSuffix;
  StrikeoutOff = RPTFPrefix + RPTFStrikeout + RPTFOff + RPTFSuffix;
  SuperscriptOn = RPTFPrefix + RPTFSuperscript + RPTFOn + RPTFSuffix;
  SuperscriptOff = RPTFPrefix + RPTFSuperscript + RPTFOff + RPTFSuffix;
  SubscriptOn = RPTFPrefix + RPTFSubscript + RPTFOn + RPTFSuffix;
  SubscriptOff = RPTFPrefix + RPTFSubscript + RPTFOff + RPTFSuffix;
  JustifyLeft = RPTFPrefix + RPTFJustify + RPTFLeft + RPTFSuffix;
  JustifyCenter = RPTFPrefix + RPTFJustify + RPTFCenter + RPTFSuffix;
  JustifyRight = RPTFPrefix + RPTFJustify + RPTFRight + RPTFSuffix;
  JustifyBlock = RPTFPrefix + RPTFJustify + RPTFBlock + RPTFSuffix;
{$ELSE}
(*$HPPEMIT '#define BoldOn "\x01\x42\x31\x04"' *)
(*$HPPEMIT '#define BoldOff "\x01\x42\x30\x04"' *)
(*$HPPEMIT '#define ItalicOn "\x01\x49\x31\x04"' *)
(*$HPPEMIT '#define ItalicOff "\x01\x49\x30\x04"' *)
(*$HPPEMIT '#define UnderlineOn "\x01\x55\x31\x04"' *)
(*$HPPEMIT '#define UnderlineOff "\x01\x55\x30\x04"' *)
(*$HPPEMIT '#define StrikeoutOn "\x01\x4B\x31\x04"' *)
(*$HPPEMIT '#define StrikeoutOff "\x01\x4B\x30\x04"' *)
(*$HPPEMIT '#define SuperscriptOn "\x01\x50\x31\x04"' *)
(*$HPPEMIT '#define SuperscriptOff "\x01\x50\x30\x04"' *)
(*$HPPEMIT '#define SubscriptOn "\x01\x53\x31\x04"' *)
(*$HPPEMIT '#define SubscriptOff "\x01\x53\x30\x04"' *)
(*$HPPEMIT '#define JustifyLeft "\x01\x4A\x4C\x04"' *)
(*$HPPEMIT '#define JustifyCenter "\x01\x4A\x43\x04"' *)
(*$HPPEMIT '#define JustifyRight "\x01\x4A\x52\x04"' *)
(*$HPPEMIT '#define JustifyBlock "\x01\x4A\x42\x04"' *)
(*$HPPEMIT '#undef ResetPrinter' *)
{$ENDIF}

type
  EReportPrinter = class(Exception);

  TPrintPageEvent = function(    Sender: TObject;
                             var PageNum: integer): boolean of object;
  TDecodeImageEvent = procedure(Sender: TObject;
                                ImageStream: TStream;
                                ImageType: string;
                                Bitmap: TBitmap) of object;

  TVersion = string[20];
  TTitleString = string;
  TFormatString = string;
  TDeviceState = (dsNone,dsIC,dsDC);
  TAccuracyMethod = (amPositioning,amAppearance);
  TMarginMethod = (mmScaled,mmFixed);
  TRulerType = (rtNone,rtHorizCm,rtVertCm,rtBothCm,rtHorizIn,rtVertIn,rtBothIn);
  TPrintJustify = (pjCenter,pjLeft,pjRight,pjBlock);
  TTabJustify = (tjCenter,tjLeft,tjRight,tjBlock,tjNone);
  TPrintJustifyVert = (pjTop,pjMiddle,pjBottom);
  TPrintUnits = (unInch,unMM,unCM,unPoint,unUser);
  TLineHeightMethod = (lhmLinesPerInch,lhmFont,lhmUser);
  TBKMode = (bkTransparent,bkOpaque);
  TDestination = (destPrinter,destPreview,destFile,destNone,destCustomFile);
  TStreamMode = (smMemory,smFile,smUser,smTempFile);
  TOrientation = (poPortrait,poLandScape,poDefault);
  TDuplex = (dupSimplex,dupVertical,dupHorizontal);
  TReportEventType = (reBeginPage,reEndPage);
  TFontAlign = (faBaseline,faTop,faBottom);
  TReportDest = (rdPreview,rdPrinter,rdFile);
  TSystemSetup = (ssAllowSetup,ssAllowCopies,ssAllowCollate,ssAllowDuplex,
   ssAllowDestPreview,ssAllowDestPrinter,ssAllowDestFile,ssAllowPrinterSetup,
   ssAllowPreviewSetup);
  TSystemOption = (soUseFiler,soWaitForOK,soShowStatus,soAllowPrintFromPreview,
   soPreviewModal,soNoGenerate);
  TBoxLines = (blNone,blLeft,blRight,blLeftRight,blTop,blLeftTop,blRightTop,
   blNoBottom,blBottom,blLeftBottom,blRightBottom,blNoTop,blTopBottom,blNoRight,
   blNoLeft,blAll);
  TMacroID = (midCurrDateShort,midCurrDateLong,midCurrDateUS,midCurrDateInter,
   midCurrTimeShort,midCurrTimeLong,midCurrTimeAMPM,midCurrTime24,midFirstPage,
   midLastPage,midTotalPages,midCurrentPage,midRelativePage,
   midPrinterName,midDriverName,midPortName,
   midUser01,midUser02,midUser03,midUser04,midUser05,midUser06,midUser07,
   midUser08,midUser09,midUser10,midUser11,midUser12,midUser13,midUser14,
   midUser15,midUser16,midUser17,midUser18,midUser19,midUser20);
  TRTFTokenType = (ttControlWord,ttControlSymbol,ttGroupBegin,ttGroupEnd,ttText);
  TRTFTokenTypeSet = set of TRTFTokenType;
  PCharArray = ^TCharArray;
  TCharArray = array[0..MAXBUFSIZE] of char;
  TFrameMode = (fmInside,fmSplit,fmOutside);

  TSystemSetups = set of TSystemSetup;
  TSystemOptions = set of TSystemOption;

  TPosition = record
    X: double;
    Y: double;
  end; { TPosition }

  PPositionNode = ^TPositionNode;
  TPositionNode = record
    X: double;
    Y: double;
    Next: PPositionNode;
  end; { TPositionNode }

  PTab = ^TTab;
  TTab = record
    Pos: double; { X Position of tab in inches }
    Justify: TPrintJustify; { Tab justification }
    Width: double; { Width of Tab Box in inches }
    Margin: double; { Left or right margin for Tab Box }
    Left: boolean; { Draw line on left? }
    Right: boolean; { Draw line on right? }
    Top: boolean; { Draw line on top? }
    Bottom: boolean; { Draw line on bottom? }
    Shade: byte; { Percent shading for background }
    RefCount: word; { How many times is this tab list referenced? }
    Next: PTab; { Next tab in list }
    Prev: PTab; { Previous tab in list }
  end; { TTab }

  TSaveTab = record
    Head: PTab;
    Tail: PTab;
  end; { TSaveTab }

  PTabNode = ^TTabNode;
  TTabNode = record
    Head: PTab;
    Tail: PTab;
    Next: PTabNode;
  end; { TTabNode }

  TSaveBrush = record
    Color: TColor;
    Style: TBrushStyle;
    Bitmap: boolean;
  end; { TSaveBrush }

  TSaveFont = record
    Name: string[60];
    Color: TColor;
    Pitch: TFontPitch;
    Size: double; { Point size of normal font }
    Height: double; { Height of normal font in inches }
    Width: double; { Average width of normal font character in inches }
    Ascent: double; { Ascent height of true font in inches }
    Descent: double; { Descent height of true font in inches }
    InternalLeading: double; { Internal Leading height of true font in inches }
    Bold: boolean;
    Underline: boolean;
    Italic: boolean;
    Strikeout: boolean;
    Subscript: boolean; { Is the true font subscript? }
    Superscript: boolean; { Is the true font superscript? }
    Rotation: smallint; { Rotation in degrees }
    Align: TFontAlign; { Alignment for this font }
    Index: word; { Index for this font }
    Handle: HFont;
    CharSet: byte;
  end; { TSaveFont }

  PFontNode = ^TFontNode;
  TFontNode = record
    Font: TSaveFont;
    Next: PFontNode;
  end; { TFontNode }

  TSavePen = record
    Color: TColor;
    Mode: TPenMode;
    Style: TPenStyle;
    Width: double;
  end; { TSavePen }

  TFormatPara = record
    Justify: TPrintJustify;
    FirstIndent: double;
    LeftIndent: double;
    RightIndent: double;
  end; { TFormatPara }

  TFormatStyle = record
    Bold: boolean;
    Italic: boolean;
    Underline: boolean;
    Strikeout: boolean;
    Subscript: boolean;
    Superscript: boolean;
    Pitch: TFontPitch;
    Color: TColor;
  end; { TFormatStyle }

  PFormatState = ^TFormatState;
  TFormatState = record
    Name: string[40];
    Size: double;
    Style: TFormatStyle;
    Para: TFormatPara;
    Prev: PFormatState;
  end; { TFormatState }

  PLineList = ^TLineList;
  TLineList = record
    P1,P2: double; { Start and End points, P1 must be <= P2 }
    C1: double; { Common value }
    Color: TColor;
    Mode: TPenMode;
    Style: TPenStyle;
    Width: integer;
    Next: PLineList;
  end; { TLineList }

  TRPComponent = class(TComponent)
  protected
    FVersion: TVersion; { Internal revision number }
    procedure SetVersion(Value: TVersion);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Version: TVersion read FVersion write SetVersion stored false;
  end; { TRPComponent }

  TRPStringObject = class
    FValue: string;
  public
    constructor Create(InitValue: string);
    property Value: string read FValue write FValue;
  end; { TRPStringObject }

  {$IFDEF Linux}
//!!PORT!!  NEED TO DEFINE PDEVICEMODE
  {$ELSE}
  PRPDevMode = PDeviceMode;
  {$ENDIF}

  procedure RaiseError(ErrorMessage: string);
  function ShadeToColor(ShadeColor: TColor;
                        ShadePercent: byte): TColor;
  function MoneyToLongName(Value: extended): string;

{$IFDEF DEMO}
  procedure DisplayWarning;
  function Validate: boolean;
{$ENDIF}

type
  TRPDataType = (dtString,dtInteger,dtBoolean,dtFloat,dtCurrency,dtBCD,dtDate,
   dtTime,dtDateTime,dtBlob,dtMemo,dtGraphic,dtInt64);
  TRPDataTypeSet = set of TRPDataType;

const
  TRPDataSetType: array[low(TFieldType)..high(TFieldType)] of TRPDataType =
   (
    {ftUnknown=}dtString,
    {ftString=}dtString,
    {ftSmallint=}dtInteger,
    {ftInteger=}dtInteger,
    {ftWord=}dtInteger,
    {ftBoolean=}dtBoolean,
    {ftFloat=}dtFloat,
    {ftCurrency=}dtCurrency,
    {ftBCD=}dtBCD,
    {ftDate=}dtDate,
    {ftTime=}dtTime,
    {ftDateTime=}dtDateTime,
    {ftBytes=}dtBlob,
    {ftVarBytes=}dtBlob,
    {ftAutoInc=}dtInteger,
    {ftBlob=}dtBlob,
    {ftMemo=}dtMemo,
    {ftGraphic=}dtGraphic,
    {ftFmtMemo=}dtBlob,
    {ftParadoxOle=}dtBlob,
    {ftDBaseOle=}dtBlob,
    {ftTypedBinary=}dtBlob,
    {ftCursor=}dtBlob,
    {ftFixedChar=}dtString,
    {ftWideString=}dtString,
    {ftLargeint=}dtInt64,
    {ftADT=}dtBlob,
    {ftArray=}dtBlob,
    {ftReference=}dtBlob,
    {ftDataSet=}dtBlob{$IFDEF LEVEL5},
    {ftOraBlob=}dtBlob,
    {ftOraClob=}dtBlob,
    {ftVariant=}dtBlob,
    {ftInterface=}dtBlob,
    {ftIDispatch=}dtBlob,
    {ftGuid=}dtBlob{$IFDEF VER140},
    {ftTimeStamp}dtDateTime,
    {ftFMTBcd}dtBCD
    {$ENDIF VER140}
{$ENDIF}


  );

const
  FileMapSize = 65536;
  FileMapName = 'RAVEBUFFER';
  AltFileMapName = 'RAVEBUFFERALT';
  EVENTPREPARED = 0;

  DATAFIRST = 1;
  DATANEXT = 2;
  DATAEOF = 3;
  DATAGETCOLS = 4;
  DATAGETROW = 5;
  DATASETFILTER = 6;
  DATAGETSORTS = 7;
  DATASETSORT = 8;
  DATAOPEN = 9;
  DATARESTORE = 10;
  DATAACKNOWLEDGE = 11;
  DATAFREEALTBUF = 12;

  ControllerMutexName = 'RAVECONTROLER';
  CompletedEventName = 'RAVECOMPLETED';
  AcknowledgeRTEventName = 'RAVERTACK_';
  AcknowledgeDTEventName = 'RAVEDTACK_';
  ConnectEventName = 'RAVECONNECT';
  ErrorEventName = 'RAVEERROR';
  DisconnectEventName = 'RAVEDISCONNECT';
  DataRTEventName = 'RAVERTDATA_';
  DataDTEventName = 'RAVEDTDATA_';

type
  TRaveConnectionError = (ceAbort,ceInform,cePrompt);

  function InitEvent(EventName: string): THandle;
  function InitManualEvent(EventName: string): THandle;
  function InitMutex(MutexName: string): THandle;
  function OpenFileMap(    MapName: string;
                       var FileMap: THandle): boolean;
  function InitFileMap(MapName: string;
                       MapSize: integer): THandle;
  function InitFileBuf(FileMap: THandle): PChar;
{$IFDEF DBG}
const
  DebugMapSize = 500000;
  DebugMapName = 'RAVEDEBUGBUF';

  procedure WriteDebug(Value: string;
                       DebugBuf: PChar);
  function InitDebugMap: THandle;
{$ENDIF}

  function DefaultTrans(const Value: string): string;
{$IFDEF DESIGNER}
  procedure FormTrans(Form: TForm);
{$ENDIF}

var
  Trans: function(const Value: string): string;
{$IFDEF DESIGNER}
  TransCharset: TFontCharset;
{$ENDIF}
{$IFNDEF LEVEL5}
  procedure FreeAndNil(var Item);
{$ENDIF}

implementation

{$IFDEF DESIGNER}
uses
  TypInfo;
{$ELSE}
{$IFDEF Linux}
uses
  MiscKylix;
{$ENDIF}
{$ENDIF}

{$IFNDEF LEVEL5}
  procedure FreeAndNil(var Item);

  var
    SaveItem: TObject;

  begin { FreeAndNil }
    SaveItem := TObject(Item);
    TObject(Item) := nil;
    SaveItem.Free;
  end;  { FreeAndNil }
{$ENDIF}

  function DefaultTrans(const Value: string): string;

  begin { DefaultTrans }
    Result := Value;
  end;  { DefaultTrans }

{$IFDEF DESIGNER}
  procedure FormTrans(Form: TForm);

  var
    I1: integer;
    S1: string;
    S2: string;
    C1: TComponent;
    StringsType: PTypeInfo;

    procedure TransStrProp(Name: string);

    var
      PropInfo: PPropInfo;

    begin { TransStrProp }
      PropInfo := GetPropInfo(C1.ClassInfo,Name);
      If Assigned(PropInfo) and (PropInfo.PropType^.Kind = tkLString) then begin
        S1 := GetStrProp(C1,PropInfo);
        If S1 <> '' then begin
          S2 := Trans(S1);
          If S1 <> S2 then begin
            SetStrProp(C1,PropInfo,S2);
          end; { if }
        end; { if }
      end; { if }
    end;  { TransStrProp }

    procedure TransStringsProp(Name: string);

    var
      PropInfo: PPropInfo;
      StringList: TStringList;
      I1: integer;

    begin { TransStringsProp }
      PropInfo := GetPropInfo(C1.ClassInfo,Name);
      If Assigned(PropInfo) and (PropInfo.PropType^ = StringsType) then begin
        StringList := TStringList.Create;
        try
          StringList.Assign(TPersistent(GetOrdProp(C1,PropInfo)));
          For I1 := 0 to StringList.Count - 1 do begin
            StringList[I1] := Trans(StringList[I1]);
          end; { for }
          SetOrdProp(C1,PropInfo,integer(StringList));
        finally
          StringList.Free;
        end; { tryf }
      end; { if }
    end;  { TransStringsProp }

    procedure SetCharset;

    var
      PropInfo: PPropInfo;

    begin { SetCharset }
      PropInfo := GetPropInfo(C1.ClassInfo,'Font');
      If Assigned(PropInfo) and (PropInfo.PropType^ = TypeInfo(TFont)) then begin
        TFont(GetOrdProp(C1,PropInfo)).Charset := TransCharset;
      end; { if }
    end;  { SetCharset }

  begin { FormTrans }
    Form.Font.Charset := TransCharset;
    If Addr(Trans) = Addr(DefaultTrans) then Exit;
    StringsType := TStrings.ClassInfo;
    For I1 := 0 to Form.ComponentCount - 1 do begin
      C1 := Form.Components[I1];
      SetCharset;
      TransStrProp('Caption');
      TransStrProp('Hint');
      TransStringsProp('Items');
    end; { for }
  end;  { FormTrans }
{$ENDIF}

  function InitEvent(EventName: string): THandle;

  begin { InitEvent }
    If EventName = '' then begin
      Result := 0;
    end else begin
      {$IFDEF Linux}
      //!!PORT!! OpenEvent
      {$ELSE}
      Result := OpenEvent(EVENT_ALL_ACCESS,false,@EventName[1]);
      {$ENDIF}
      If Result = 0 then begin
        {$IFDEF Linux}
        //!!PORT!! CreateEvent
        {$ELSE}
        Result := CreateEvent(nil,false,false,@EventName[1]);
        {$ENDIF}
      end; { if }
    end; { else }
  end;  { InitEvent }

  function InitManualEvent(EventName: string): THandle;

  begin { InitManualEvent }
    If EventName = '' then begin
      Result := 0;
    end else begin
      {$IFDEF Linux}
      //!!PORT!! OpenEvent
      {$ELSE}
      Result := OpenEvent(EVENT_ALL_ACCESS,false,@EventName[1]);
      {$ENDIF}
      If Result = 0 then begin
        {$IFDEF Linux}
        //!!PORT!! CreateEvent
        {$ELSE}
        Result := CreateEvent(nil,true,false,@EventName[1]);
        {$ENDIF}
      end; { if }
    end; { else }
  end;  { InitManualEvent }

  function InitMutex(MutexName: string): THandle;

  begin { InitMutex }
    If MutexName = '' then begin
      Result := 0;
    end else begin
      {$IFDEF Linux}
      //!!PORT!! OpenMutex - Use pthread_mutex_****
      {$ELSE}
      Result := OpenMutex(MUTEX_ALL_ACCESS,false,@MutexName[1]);
      {$ENDIF}
      If Result = 0 then begin
        {$IFDEF Linux}
        //!!PORT!! CreateMutex - Use pthread_mutex_create (call init prior)
        {$ELSE}
        Result := CreateMutex(nil,false,@MutexName[1]);
        {$ENDIF}
      end; { if }
    end; { else }
  end;  { InitMutex }

  function OpenFileMap(    MapName: string;
                       var FileMap: THandle): boolean;

  begin { OpenFileMap }
    {$IFDEF Linux}
    //!!PORT!! OpenFileMapping - Mapped file
    Result := False; // Remove this when done.
    {$ELSE}
    FileMap := OpenFileMapping(FILE_MAP_WRITE,false,@MapName[1]);
    {$ENDIF}
    Result := FileMap <> 0;
  end;  { OpenFileMap }

  function InitFileMap(MapName: string;
                       MapSize: integer): THandle;

  begin { InitFileMap }
    If not OpenFileMap(MapName,Result) then begin
      {$IFDEF Linux}
      //!!PORT!! CreateFileMapping
      Result := 0; // Remove this when done
      {$ELSE}
      Result := CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,MapSize,@MapName[1]);
      {$ENDIF}
    end; { if }
  end;  { InitFileMap }

  function InitFileBuf(FileMap: THandle): PChar;

  begin { InitFileBuf }
    {$IFDEF Linux}
    //!!PORT!! MapViewOfFile
    Result := nil; // Remove this when done
    {$ELSE}
    Result := PChar(MapViewOfFile(FileMap,FILE_MAP_READ OR FILE_MAP_WRITE,0,0,0));
    {$ENDIF}
  end;  { InitFileBuf }

{$IFDEF DBG}
  procedure WriteDebug(Value: string;
                       DebugBuf: PChar);

  var
   DebugPtr: PChar;
   Offset: integer;
   CS: TRTLCriticalSection;

  begin { WriteDebug }
    InitializeCriticalSection(CS);
    try
      EnterCriticalSection(CS);
      Offset := integer(pointer(DebugBuf)^); { Get old offset }
      If (Offset + 128) < DebugMapSize then begin
        DebugPtr := DebugBuf + Offset + 4; { Move DebugPtr to write location }
        StrPCopy(DebugPtr,Value); { Write Value out }
        integer(pointer(DebugBuf)^) := Offset + Length(Value) + 1; { Update offset }
      end; { if }
    finally
      LeaveCriticalSection(CS);
      DeleteCriticalSection(CS);
    end; { with }
  end;  { WriteDebug }

  function InitDebugMap: THandle;

  begin { InitDebugMap }
    {$IFDEF Linux}
    //!!PORT!! OpenFileMapping
    Result := 0; // Remove this when done
    {$ELSE}
    Result := OpenFileMapping(FILE_MAP_WRITE,false,DebugMapName);
    {$ENDIF}
    If Result = 0 then begin
      {$IFDEF Linux}
      //!!PORT!! CreateFileMapping
      Result := 0; // Remove this when done
      {$ELSE}
      Result := CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,DebugMapSize,
       DebugMapName);
      {$ENDIF}
    end; { if }
  end;  { InitDebugMap }
{$ENDIF}

  procedure RaiseError(ErrorMessage: string);

  begin { RaiseError }
    Raise EReportPrinter.Create(ErrorMessage);
  end;  { RaiseError }

  function ShadeToColor(ShadeColor: TColor;
                        ShadePercent: byte): TColor;

  var
    Red: byte;
    Blue: byte;
    Green: byte;
    RGBVal: longint;

  begin { ShadeToColor }
    If ShadePercent > 100 then begin
      ShadePercent := 100;
    end; { if }
    RGBVal := ColorToRGB(ShadeColor);
    Red := ((255 - GetRValue(RGBVal)) * (100 - ShadePercent)) div 100 +
     GetRValue(RGBVal);
    Green := ((255 - GetGValue(RGBVal)) * (100 - ShadePercent)) div 100 +
     GetGValue(RGBVal);
    Blue := GetBValue(RGBVal);
    Blue := ((255 - Blue) * (100 - ShadePercent)) div 100 + Blue;
    Result := RGB(Red,Green,Blue);
  end;  { ShadeToColor }

  function MoneyToLongName(Value: extended): string;

  const
    Name1: array[0..9] of string = ('','One ','Two ','Three ','Four ','Five ',
    'Six ','Seven ','Eight ','Nine ');
    Name2: array[0..9] of string = ('Ten ','Eleven ','Twelve ','Thirteen ',
    'Fourteen ','Fifteen ','Sixteen ','Seventeen ','Eighteen ','Nineteen ');
    Name3: array[2..9] of string = ('Twenty ','Thirty ','Forty ','Fifty ',
    'Sixty ','Seventy ','Eighty ','Ninety ');
    Name4: array[0..4] of string = ('Trillion ','Billion ','Million ','Thousand ','');

    function MoneyToShortName(Value: longint;
                              AddName: string): string;

    var
      I1: longint;

    begin { MoneyToShortName }
      Result := '';
      If Value = 0 then Exit;
      I1 := Value div 100;
      If I1 > 0 then begin
        Result := Name1[I1] + 'Hundred ';
      end; { if }
      I1 := (Value div 10) mod 10;
      If I1 = 1 then begin
        Result := Result + Name2[Value mod 10];
      end else begin
        If I1 >= 2 then begin
          Result := Result + Name3[I1];
        end; { if }
        Result := Result + Name1[Value mod 10];
      end; { else }
      Result := Result + AddName;
    end;  { MoneyToShortName }

  var
    I1: integer;
    S1: string;

  begin { MoneyToLongName }
    S1 := FloatToStrF(Abs(Value),ffFixed,18,2);
    If Length(S1) > 18 then begin
      Result := '(overflow)';
      Exit;
    end; { if }
    While Length(S1) < 18 do begin
      S1 := '0' + S1;
    end; { while }
    If Value < 1.0 then begin
      Result := 'Zero ';
    end else begin
      Result := '';
      For I1 := 0 to 4 do begin
        Result := Result + MoneyToShortName(StrToInt(Copy(S1,I1 * 3 + 1,3)),Name4[I1]);
      end; { for }
    end; { else }
    Result := Result + 'and ' + Copy(S1,17,2) + '/100';
  end;  { MoneyToLongName }

  constructor TRPComponent.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FVersion := RPVersion;
  end;  { Create }

  procedure TRPComponent.SetVersion(Value: TVersion);

  begin { SetVersion }
  { Don't do anything since version was set in Create }
  end;  { SetVersion }

  constructor TRPStringObject.Create(InitValue: string);

  begin { Create }
    inherited Create;
    FValue := InitValue;
  end;  { Create }

{ The file DEMOUTIL.PAS is not included nor is it required
  for the full version of ReportPrinter Pro }

{$IFDEF DEMO}
{$I NONDIST\DEMOUTIL.PAS}
{$ENDIF}

initialization
  Trans := DefaultTrans;
end.


