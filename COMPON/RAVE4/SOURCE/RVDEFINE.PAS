{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVDefine;

{$I RPVer.pas }

interface

uses
  {$IFDEF Linux}
  QControls, QForms, QGraphics, Types, MiscKylix,
  {$ELSE}
  Windows, Controls, Forms, Graphics,
  {$ENDIF}
  Classes, SysUtils, RPBase, RPDefine;

const
  RaveVersion = 40005; { 3.0004 }
  RegRoot = {Trans-}'\Software\Nevrona Designs\Rave4\';
  RaveMajorVersion = 100;
  RaveMinorVersion = 1;
  RaveDelta: double = 0.0001;
  HexDigits = {Trans-}'0123456789ABCDEF';
{$IFDEF DESIGNER}
  InDesigner = true;
{$ELSE}
  InDesigner = false;
{$ENDIF}

{ TTabSheet Tag property types }
  SourceSheet = 1;
  DesignerSheet = 2;
  DataViewSheet = 3;
  QuerySheet = 4;

{ Alignment types }
  RaveAlignLeft = 1;
  RaveAlignHCenter = 2;
  RaveAlignRight = 3;
  RaveAlignHCenterInParent = 4;
  RaveAlignHSpace = 5;
  RaveAlignEquateWidths = 6;
  RaveAlignTop = 7;
  RaveAlignVCenter = 8;
  RaveAlignBottom = 9;
  RaveAlignVCenterInParent = 10;
  RaveAlignVSpace = 11;
  RaveAlignEquateHeights = 12;
  RaveAlignMoveForward = 13;
  RaveAlignMoveBehind = 14;
  RaveAlignBringToFront = 15;
  RaveAlignSendToBack = 16;
  RaveAlignTapLeft = 17;
  RaveAlignTapRight = 18;
  RaveAlignTapUp = 19;
  RaveAlignTapDown = 20;
  RaveAlignTapHSizeDown = 21;
  RaveAlignTapHSizeUp = 22;
  RaveAlignTapVSizeDown = 23;
  RaveAlignTapVSizeUp = 24;

type
  ERaveClass = class(Exception);

  TUserLevel = (ulBeginner,ulIntermediate,ulAdvanced);
  TLineWidthType = (wtPoints,wtPixels);
  TFontAttribute = (faAll,faName,faSize,faBold,faItalic,faUnderline);
  TDisplayOn = (doParent,doAll,doPreviewOnly,doPrinterOnly);
  TGotoMode = (gmGotoDone,gmGotoNotDone,gmCallEach);
  TRaveAnchor = type byte;
  TRaveVAnchor = (anvTop,anvBottom,anvCenter,anvStretch,anvResize,anvSpread);
  TRaveHAnchor = (anhLeft,anhRight,anhCenter,anhStretch,anhResize,anhSpread);
  TRaveFillStyle = (fsSolid,fsClear,fsHorizontal,fsVertical,fsFDiagonal,
   fsBDiagonal,fsCross,fsDiagCross,fsNone);
  TRaveCalcType = (ctCount,ctSum,ctMin,ctMax,ctAverage);

  TRaveFloat = double;
  TRaveUnits = type TRaveFloat;
  TRaveFieldName = type string;
  TRaveMemoString = type string;

  PRavePoint = ^TRavePoint;
  TRavePoint = record
    X: TRaveUnits;
    Y: TRaveUnits;
  end; { TRavePoint }

  PRaveRect = ^TRaveRect;
  TRaveRect = record
    Case byte of
      0:(Left: TRaveUnits;
         Top: TRaveUnits;
         Right: TRaveUnits;
         Bottom: TRaveUnits);
      1:(TopLeft: TRavePoint;
         BottomRight: TRavePoint);
  end; { TRaveRect }

  TRavePaperSize = type integer;
  TPaperSizeName = record
    Name: string;
    PaperSize: TRavePaperSize;
    PaperWidth: TRaveUnits;
    PaperHeight: TRaveUnits;
  end; { TPaperSizeName }

  TRaveBin = type integer;
  TRaveBinName = record
    Name: string;
    RaveBin: TRaveBin;
  end; { TRaveBinName }

  TRavePrinterDuplex = (pdSimplex,pdHorizontal,pdVertical,pdDefault);
  TRavePrinterCollate = (pcFalse,pcTrue,pcDefault);
  TRavePrinterResolution = (prDraft,prLow,prMedium,prHigh,prDefault);
  TRaveSaveCallbackProc = procedure(Buf: pointer;
                                    Size: longint;
                                    Data: pointer); stdcall;

const
  RavePrinterResolution: array[TRavePrinterResolution] of DWORD =
   (DMRES_DRAFT,DMRES_LOW,DMRES_MEDIUM,DMRES_HIGH,0);
{TransOff}
  RaveBinNameCnt = 14;
  RaveBinName: array[1..RaveBinNameCnt] of TRaveBinName = (
   (Name:'Default'; RaveBin:-1),
   (Name:'Upper/Primary Tray'; RaveBin:DMBIN_UPPER),
   (Name:'Lower Tray'; RaveBin:DMBIN_LOWER),
   (Name:'Middle Tray'; RaveBin:DMBIN_MIDDLE),
   (Name:'Manual Feed'; RaveBin:DMBIN_MANUAL),
   (Name:'Envelope'; RaveBin:DMBIN_ENVELOPE),
   (Name:'Envelope Manual Feed'; RaveBin:DMBIN_ENVMANUAL),
   (Name:'Auto Select'; RaveBin:DMBIN_AUTO),
   (Name:'Tractor Feed'; RaveBin:DMBIN_TRACTOR),
   (Name:'SmallFmt'; RaveBin:DMBIN_SMALLFMT),
   (Name:'LargeFmt'; RaveBin:DMBIN_LARGEFMT),
   (Name:'Large Capacity'; RaveBin:DMBIN_LARGECAPACITY),
   (Name:'Cassette'; RaveBin:DMBIN_CASSETTE),
   (Name:'Form Source'; RaveBin:DMBIN_FORMSOURCE)
  );

  PaperSizeNameCnt = 43;
  PaperSizeName: array[1..PaperSizeNameCnt] of TPaperSizeName = (
   (Name:'Default'; PaperSize:-1;PaperWidth:0;PaperHeight:0),
   (Name:'Custom'; PaperSize:DMPAPER_USER;PaperWidth:0;PaperHeight:0),
   (Name:'Letter, 8 1/2- by 11-inches'; PaperSize:DMPAPER_LETTER;PaperWidth:8.5;PaperHeight:11.0),
   (Name:'Legal, 8 1/2- by 14-inches'; PaperSize:DMPAPER_LEGAL;PaperWidth:8.5;PaperHeight:14.0),
   (Name:'A4 Sheet, 210- by 297-millimeters'; PaperSize:DMPAPER_A4;PaperWidth:210/25.4;PaperHeight:297/25.4),
   (Name:'C Sheet, 17- by 22-inches'; PaperSize:DMPAPER_CSHEET;PaperWidth:17.0;PaperHeight:22.0),
   (Name:'D Sheet, 22- by 34-inches'; PaperSize:DMPAPER_DSHEET;PaperWidth:22.0;PaperHeight:34.0),
   (Name:'E Sheet, 34- by 44-inches'; PaperSize:DMPAPER_ESHEET;PaperWidth:34.0;PaperHeight:44.0),
   (Name:'Letter Small, 8 1/2- by 11-inches'; PaperSize:DMPAPER_LETTERSMALL;PaperWidth:8.5;PaperHeight:11.0),
   (Name:'Tabloid, 11- by 17-inches'; PaperSize:DMPAPER_TABLOID;PaperWidth:11.0;PaperHeight:17.0),
   (Name:'Ledger, 17- by 11-inches'; PaperSize:DMPAPER_LEDGER;PaperWidth:17.0;PaperHeight:11.0),
   (Name:'Statement, 5 1/2- by 8 1/2-inches'; PaperSize:DMPAPER_STATEMENT;PaperWidth:5.5;PaperHeight:8.5),
   (Name:'Executive, 7 1/4- by 10 1/2-inches'; PaperSize:DMPAPER_EXECUTIVE;PaperWidth:7.25;PaperHeight:10.5),
   (Name:'A3 sheet, 297- by 420-millimeters'; PaperSize:DMPAPER_A3;PaperWidth:297/25.4;PaperHeight:420/25.4),
   (Name:'A4 small sheet, 210- by 297-millimeters'; PaperSize:DMPAPER_A4SMALL;PaperWidth:210/25.4;PaperHeight:297/25.4),
   (Name:'A5 sheet, 148- by 210-millimeters'; PaperSize:DMPAPER_A5;PaperWidth:148/25.4;PaperHeight:210/25.4),
   (Name:'B4 sheet, 250- by 354-millimeters'; PaperSize:DMPAPER_B4;PaperWidth:250/25.4;PaperHeight:354/25.4),
   (Name:'B5 sheet, 182- by 257-millimeter paper'; PaperSize:DMPAPER_B5;PaperWidth:182/25.4;PaperHeight:257/25.4),
   (Name:'Folio, 8 1/2- by 13-inch paper'; PaperSize:DMPAPER_FOLIO;PaperWidth:8.5;PaperHeight:13.0),
   (Name:'Quarto, 215- by 275-millimeter paper'; PaperSize:DMPAPER_QUARTO;PaperWidth:215/25.4;PaperHeight:275/25.4),
   (Name:'10- by 14-inch sheet'; PaperSize:DMPAPER_10X14;PaperWidth:10.0;PaperHeight:14.0),
   (Name:'11- by 17-inch sheet'; PaperSize:DMPAPER_11X17;PaperWidth:11.0;PaperHeight:17.0),
   (Name:'Note, 8 1/2- by 11-inches'; PaperSize:DMPAPER_NOTE;PaperWidth:8.5;PaperHeight:11.0),
   (Name:'#9 Envelope, 3 7/8- by 8 7/8-inches'; PaperSize:DMPAPER_ENV_9;PaperWidth:3.875;PaperHeight:8.875),
   (Name:'#10 Envelope, 4 1/8- by 9 1/2-inches'; PaperSize:DMPAPER_ENV_10;PaperWidth:4.125;PaperHeight:9.5),
   (Name:'#11 Envelope, 4 1/2- by 10 3/8-inches'; PaperSize:DMPAPER_ENV_11;PaperWidth:4.5;PaperHeight:10.375),
   (Name:'#12 Envelope, 4 3/4- by 11-inches'; PaperSize:DMPAPER_ENV_12;PaperWidth:4.75;PaperHeight:11.0),
   (Name:'#14 Envelope, 5- by 11 1/2-inches'; PaperSize:DMPAPER_ENV_14;PaperWidth:5.0;PaperHeight:11.5),
   (Name:'DL Envelope, 110- by 220-millimeters'; PaperSize:DMPAPER_ENV_DL;PaperWidth:110/25.4;PaperHeight:220/25.4),
   (Name:'C5 Envelope, 162- by 229-millimeters'; PaperSize:DMPAPER_ENV_C5;PaperWidth:162/25.4;PaperHeight:229/25.4),
   (Name:'C3 Envelope,  324- by 458-millimeters'; PaperSize:DMPAPER_ENV_C3;PaperWidth:324/25.4;PaperHeight:458/25.4),
   (Name:'C4 Envelope,  229- by 324-millimeters'; PaperSize:DMPAPER_ENV_C4;PaperWidth:229/25.4;PaperHeight:324/25.4),
   (Name:'C6 Envelope,  114- by 162-millimeters'; PaperSize:DMPAPER_ENV_C6;PaperWidth:114/25.4;PaperHeight:162/25.4),
   (Name:'C65 Envelope, 114- by 229-millimeters'; PaperSize:DMPAPER_ENV_C65;PaperWidth:114/25.4;PaperHeight:229/25.4),
   (Name:'B4 Envelope,  250- by 353-millimeters'; PaperSize:DMPAPER_ENV_B4;PaperWidth:250/25.4;PaperHeight:353/25.4),
   (Name:'B5 Envelope,  176- by 250-millimeters'; PaperSize:DMPAPER_ENV_B5;PaperWidth:176/25.4;PaperHeight:250/25.4),
   (Name:'B6 Envelope,  176- by 125-millimeters'; PaperSize:DMPAPER_ENV_B6;PaperWidth:176/25.4;PaperHeight:125/25.4),
   (Name:'Italy Envelope, 110- by 230-millimeters'; PaperSize:DMPAPER_ENV_ITALY;PaperWidth:110/25.4;PaperHeight:230/25.4),
   (Name:'Monarch Envelope, 3 7/8- by 7 1/2-inches'; PaperSize:DMPAPER_ENV_MONARCH;PaperWidth:3.875;PaperHeight:7.5),
   (Name:'6 3/4 Envelope, 3 5/8- by 6 1/2-inches'; PaperSize:DMPAPER_ENV_PERSONAL;PaperWidth:3.626;PaperHeight:6.5),
   (Name:'US Std Fanfold, 14 7/8- by 11-inches'; PaperSize:DMPAPER_FANFOLD_US;PaperWidth:14.875;PaperHeight:12.0),
   (Name:'German Std Fanfold, 8 1/2- by 12-inches'; PaperSize:DMPAPER_FANFOLD_STD_GERMAN;PaperWidth:8.5;PaperHeight:12.0),
   (Name:'German Legal Fanfold, 8 1/2- by 13-inches'; PaperSize:DMPAPER_FANFOLD_LGL_GERMAN;PaperWidth:8.5;PaperHeight:13.0)
  );

  LineWidths: array[0..11] of TRaveFloat = (1.0,0.25,0.50,0.75,1.0,1.5,2.25,3.0,
   4.5,6.0,7.5,0.0);
{TransOn}

var
  RaveTitle: string = {Trans-}'Rave Reports 4.0'; { Title to be displayed in Visual Designer }
  DeveloperLevel: boolean = false; { Is the developer version of RAVE running? }
  UserLevel: TUserLevel; { Current user level - beginner, intermediate or advanced }
  FloatPropPrecision: integer; { Specifies how many decimal digets to show }
  GBaseReport: TBaseReport = nil; { Global BaseReport object }
{ DataConnection timeout values }
  EventDelays: array[0..13] of word = (600,600,600,600,600,600,600,600,600,600,600,600,600,600);
  LargeTimeouts: array[0..13] of word = (50,50,50,50,50,50,50,50,50,50,50,50,50,50);
  AlwaysShowHeaders: boolean; { Always show band headers? }
  AdminMode: boolean; { Running in admin mode? }
  SaveEnvOnly: boolean; { Prompt to Save Environment Only Settings On Exit? }
{ Printing Preferences Values }
  PrintDestination: TReportDest = rdPreview;
  AllowSetup: boolean = true;
  PreviewShadowDepth: integer = 5;
  PreviewWindowState: TWindowState = wsNormal;
  PreviewGridHoriz: TRaveFloat = 0.0;
  PreviewGridVert: TRaveFloat = 0.0;
  PreviewZoomFactor: TRaveFloat = 100.0;
  PreviewZoomInc: integer = 10;
  PreviewMonochrome: boolean = false;
  PreviewGridColor: TColor = clAqua;
  PreviewGridPenStyle: TPenStyle = psSolid;
  PreviewRulerType: TRulerType = rtNone;
  ProjectUnitsFactor: TRaveFloat = 1.0;
  PaperSize: TRavePaperSize = -1;
  PaperWidth: TRaveUnits = 8.5;
  PaperHeight: TRaveUnits = 11.0;
  GridSpacing: double = 0.1; { Spacing between each grid line }
  GridLines: integer = 5; { Draw grid line every GridLine spacing }
  RaveInitialized: boolean = false;
  DeveloperRave: boolean = false;
  TrueTypeFontImage: TBitmap;
  DeviceFontImage: TBitmap;
  TapDist: TRaveUnits; { Distance to move when tapping controls }
  ShowTapButtons: boolean; { Show tapping buttons }
  ShowOrderButtons: boolean; { Show order buttons }
  HoldAddDeleteComponents: boolean = false;

implementation
end.