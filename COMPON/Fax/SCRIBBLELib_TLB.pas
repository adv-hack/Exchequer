unit SCRIBBLELib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130.3.0.1.0  $
// File generated on 15/03/2010 10:09:24 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Image Viewer CP ActiveX Control2\ImageViewer2.OCX (1)
// LIBID: {C9460280-3EED-11D0-A647-00A0C91EF7B9}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SCRIBBLELibMajorVersion = 1;
  SCRIBBLELibMinorVersion = 0;

  LIBID_SCRIBBLELib: TGUID = '{C9460280-3EED-11D0-A647-00A0C91EF7B9}';

  DIID__DImageViewer: TGUID = '{C9460281-3EED-11D0-A647-00A0C91EF7B9}';
  DIID__DImageViewerEvents: TGUID = '{C9460282-3EED-11D0-A647-00A0C91EF7B9}';
  CLASS_ImageViewer: TGUID = '{C9460283-3EED-11D0-A647-00A0C91EF7B9}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TIF_COMPRESSION
type
  TIF_COMPRESSION = TOleEnum;
const
  CompressionLZW = $00000000;
  CompressionCCITT3 = $00000001;
  CompressionCCITT4 = $00000002;
  CompressionRle = $00000003;
  CompressionNone = $00000004;

// Constants for enum MOUSE_TRACKMODE
type
  MOUSE_TRACKMODE = TOleEnum;
const
  DragScrollMode = $00000000;
  SelectionRectMode = $00000001;
  NormalMode = $FFFFFFFF;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DImageViewer = dispinterface;
  _DImageViewerEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ImageViewer = _DImageViewer;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}


// *********************************************************************//
// DispIntf:  _DImageViewer
// Flags:     (4112) Hidden Dispatchable
// GUID:      {C9460281-3EED-11D0-A647-00A0C91EF7B9}
// *********************************************************************//
  _DImageViewer = dispinterface
    ['{C9460281-3EED-11D0-A647-00A0C91EF7B9}']
    property FileName: WideString dispid 1;
    property ViewSize: Double dispid 2;
    property View: Smallint dispid 3;
    property Border: WordBool dispid 4;
    property HighQuality: WordBool dispid 5;
    property OutputGrayScale: WordBool dispid 6;
    property CursorFileName: WideString dispid 7;
    property ShowCustomCursor: WordBool dispid 8;
    property JPEGQuality: Smallint dispid 9;
    property LicenseKey: WideString dispid 10;
    property FileWidth: Smallint dispid 11;
    property FileHeight: Smallint dispid 12;
    property TextColor: OLE_COLOR dispid 13;
    property TextStyle: Smallint dispid 14;
    property TextFontSize: Smallint dispid 15;
    property TextFontName: WideString dispid 16;
    property TextFontStyle: Smallint dispid 17;
    property ShowText: WordBool dispid 18;
    property SelectionRectHeight: Integer dispid 19;
    property SelectionRectWidth: Integer dispid 20;
    property SelectionRectLeft: Integer dispid 21;
    property SelectionRectTop: Integer dispid 22;
    property IsUseExif: WordBool dispid 23;
    property PrintMarginX: Smallint dispid 24;
    property PrintMarginY: Smallint dispid 25;
    property PrintSpaceX: Smallint dispid 26;
    property PrintSpaceY: Smallint dispid 27;
    property PrintOutline: WordBool dispid 28;
    property PrintStretch: WordBool dispid 29;
    property PrintVertAlign: Smallint dispid 30;
    property PrintHorzAlign: Smallint dispid 31;
    property PrintColCount: Smallint dispid 32;
    property PrintRowCount: Smallint dispid 33;
    property PrintStartPage: Smallint dispid 34;
    property PrintEndPage: Smallint dispid 35;
    property TextAlphaValue: Smallint dispid 36;
    property ShowImage: WordBool dispid 37;
    property ImageDPI: Smallint dispid 38;
    property TIFCompression: TIF_COMPRESSION dispid 39;
    property GrabScrollCursorFileName: WideString dispid 40;
    property MouseTrackMode: MOUSE_TRACKMODE dispid 41;
    procedure Rotate90; dispid 42;
    function Save(const strFileName: WideString; const strFileType: WideString): Smallint; dispid 43;
    function GetHorzScrollBarPos: Smallint; dispid 44;
    function GetVertScrollBarPos: Smallint; dispid 45;
    procedure SetScrollBarPos(x: Smallint; y: Smallint); dispid 46;
    function PrintImage(bShow: WordBool): Smallint; dispid 47;
    procedure SetBackgroundColor(bgColor: OLE_COLOR); dispid 48;
    procedure Redraw; dispid 49;
    function LoadMultiPage(const strFileName: WideString; iPage: Smallint): Smallint; dispid 50;
    function GetTotalPage: Smallint; dispid 51;
    function SaveBySize(const strFileName: WideString; const strFileType: WideString; 
                        iUserWidth: Smallint; iUserHeight: Smallint): Smallint; dispid 52;
    procedure Rotate180; dispid 53;
    procedure SetPrintText(iXPos: Smallint; iYPos: Smallint; const strFontName: WideString; 
                           iFontSize: Smallint; bFontBold: WordBool; bFontItalic: WordBool; 
                           bFontUnderline: WordBool; clrFontColor: OLE_COLOR; 
                           const strText: WideString); dispid 54;
    function Copy2PictureBox: IPictureDisp; dispid 55;
    function Copy2HBITMAP: Integer; dispid 56;
    function Copy2Clipboard: WordBool; dispid 57;
    function PrintImage2Printer(const strPrintName: WideString): Smallint; dispid 58;
    procedure Rotate270; dispid 59;
    procedure Rotate(iValue: Smallint); dispid 60;
    function PasteFromClipboard: WordBool; dispid 61;
    procedure SetOutlineTextBorderColor(clrBorder: OLE_COLOR); dispid 62;
    procedure SetOutlineTextBackColor(clrBack: OLE_COLOR); dispid 63;
    procedure SetHashBrushValue(iBrushStyle: Smallint; clrForeColor: OLE_COLOR; 
                                clrBackColor: OLE_COLOR); dispid 64;
    procedure SetTextureBrushImage(const strImage: WideString); dispid 65;
    function Crop(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): WordBool; dispid 66;
    function Crop2Clipbord(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): WordBool; dispid 67;
    function Crop2HBITMAP(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): Integer; dispid 68;
    function Crop2PictureBox(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): IPictureDisp; dispid 69;
    procedure ImportFromPictureBox(const pic: IPictureDisp); dispid 70;
    function ReadBinary(const pField: IUnknown): WordBool; dispid 71;
    function WriteBinary(const pField: IUnknown): WordBool; dispid 72;
    procedure InvertColor; dispid 73;
    function GetExifTagsName(index: Smallint): WideString; dispid 74;
    function GetExifTagsValue(index: Smallint): WideString; dispid 75;
    function SetExifStringValue(const strTagName: WideString; const strValue: WideString): WordBool; dispid 76;
    function GetExifTagsCount: Smallint; dispid 77;
    procedure AddBorder(iBorderWidth: Smallint; clrBorder: OLE_COLOR); dispid 78;
    procedure AddGradientBorder(iBorderWidth: Smallint; clrColor1: OLE_COLOR; clrColor2: OLE_COLOR; 
                                iGradientMode: Smallint); dispid 79;
    procedure DrawImage(iXPos: Smallint; iYPos: Smallint; const strImageFile: WideString; 
                        clrTranColor: OLE_COLOR; iAlphaValue: Smallint); dispid 80;
    procedure DrawSelectionRect(iLeft: Smallint; iTop: Smallint; iWidth: Smallint; iHeight: Smallint); dispid 81;
    procedure DrawText(iXPos: Smallint; iYPos: Smallint; const strText: WideString); dispid 82;
    function CreateThumbnail(const strFileName: WideString; const strFileType: WideString; 
                             iThumbnailWidth: Smallint; iThumbnailHeight: Smallint; 
                             clrBackColor: OLE_COLOR): Smallint; dispid 83;
    procedure HScroll(iSBCode: Smallint); dispid 84;
    function LoadFromStream(const pStream: IUnknown): WordBool; dispid 85;
    function LoadImageFromURL(const strURL: WideString; iPageNo: Smallint): WordBool; dispid 86;
    procedure VScroll(iSBCode: Smallint); dispid 87;
  end;

// *********************************************************************//
// DispIntf:  _DImageViewerEvents
// Flags:     (4096) Dispatchable
// GUID:      {C9460282-3EED-11D0-A647-00A0C91EF7B9}
// *********************************************************************//
  _DImageViewerEvents = dispinterface
    ['{C9460282-3EED-11D0-A647-00A0C91EF7B9}']
    procedure Click; dispid -600;
    procedure DblClick; dispid -601;
    procedure MouseMove(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -606;
    procedure MouseDown(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -605;
    procedure MouseUp(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -607;
    procedure SelectionRectDrawn(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer); dispid 1;
    procedure KeyDown(var KeyCode: Smallint; Shift: Smallint); dispid -602;
    procedure KeyUp(var KeyCode: Smallint; Shift: Smallint); dispid -604;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TImageViewer
// Help String      : ImageViewer CP Control
// Default Interface: _DImageViewer
// Def. Intf. DISP? : Yes
// Event   Interface: _DImageViewerEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TImageViewerSelectionRectDrawn = procedure(Sender: TObject; iLeft: Integer; iTop: Integer; 
                                                              iWidth: Integer; iHeight: Integer) of object;

  TImageViewer = class(TOleControl)
  private
    FOnSelectionRectDrawn: TImageViewerSelectionRectDrawn;
    FIntf: _DImageViewer;
    function  GetControlInterface: _DImageViewer;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Rotate90;
    function Save(const strFileName: WideString; const strFileType: WideString): Smallint;
    function GetHorzScrollBarPos: Smallint;
    function GetVertScrollBarPos: Smallint;
    procedure SetScrollBarPos(x: Smallint; y: Smallint);
    function PrintImage(bShow: WordBool): Smallint;
    procedure SetBackgroundColor(bgColor: OLE_COLOR);
    procedure Redraw;
    function LoadMultiPage(const strFileName: WideString; iPage: Smallint): Smallint;
    function GetTotalPage: Smallint;
    function SaveBySize(const strFileName: WideString; const strFileType: WideString; 
                        iUserWidth: Smallint; iUserHeight: Smallint): Smallint;
    procedure Rotate180;
    procedure SetPrintText(iXPos: Smallint; iYPos: Smallint; const strFontName: WideString; 
                           iFontSize: Smallint; bFontBold: WordBool; bFontItalic: WordBool; 
                           bFontUnderline: WordBool; clrFontColor: OLE_COLOR; 
                           const strText: WideString);
    function Copy2PictureBox: IPictureDisp;
    function Copy2HBITMAP: Integer;
    function Copy2Clipboard: WordBool;
    function PrintImage2Printer(const strPrintName: WideString): Smallint;
    procedure Rotate270;
    procedure Rotate(iValue: Smallint);
    function PasteFromClipboard: WordBool;
    procedure SetOutlineTextBorderColor(clrBorder: OLE_COLOR);
    procedure SetOutlineTextBackColor(clrBack: OLE_COLOR);
    procedure SetHashBrushValue(iBrushStyle: Smallint; clrForeColor: OLE_COLOR; 
                                clrBackColor: OLE_COLOR);
    procedure SetTextureBrushImage(const strImage: WideString);
    function Crop(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): WordBool;
    function Crop2Clipbord(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): WordBool;
    function Crop2HBITMAP(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): Integer;
    function Crop2PictureBox(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): IPictureDisp;
    procedure ImportFromPictureBox(const pic: IPictureDisp);
    function ReadBinary(const pField: IUnknown): WordBool;
    function WriteBinary(const pField: IUnknown): WordBool;
    procedure InvertColor;
    function GetExifTagsName(index: Smallint): WideString;
    function GetExifTagsValue(index: Smallint): WideString;
    function SetExifStringValue(const strTagName: WideString; const strValue: WideString): WordBool;
    function GetExifTagsCount: Smallint;
    procedure AddBorder(iBorderWidth: Smallint; clrBorder: OLE_COLOR);
    procedure AddGradientBorder(iBorderWidth: Smallint; clrColor1: OLE_COLOR; clrColor2: OLE_COLOR; 
                                iGradientMode: Smallint);
    procedure DrawImage(iXPos: Smallint; iYPos: Smallint; const strImageFile: WideString; 
                        clrTranColor: OLE_COLOR; iAlphaValue: Smallint);
    procedure DrawSelectionRect(iLeft: Smallint; iTop: Smallint; iWidth: Smallint; iHeight: Smallint);
    procedure DrawText(iXPos: Smallint; iYPos: Smallint; const strText: WideString);
    function CreateThumbnail(const strFileName: WideString; const strFileType: WideString; 
                             iThumbnailWidth: Smallint; iThumbnailHeight: Smallint; 
                             clrBackColor: OLE_COLOR): Smallint;
    procedure HScroll(iSBCode: Smallint);
    function LoadFromStream(const pStream: IUnknown): WordBool;
    function LoadImageFromURL(const strURL: WideString; iPageNo: Smallint): WordBool;
    procedure VScroll(iSBCode: Smallint);
    property  ControlInterface: _DImageViewer read GetControlInterface;
    property  DefaultInterface: _DImageViewer read GetControlInterface;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property  OnMouseUp;
    property  OnMouseMove;
    property  OnMouseDown;
    property  OnKeyUp;
    property  OnKeyDown;
    property  OnDblClick;
    property  OnClick;
    property FileName: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property ViewSize: Double index 2 read GetDoubleProp write SetDoubleProp stored False;
    property View: Smallint index 3 read GetSmallintProp write SetSmallintProp stored False;
    property Border: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property HighQuality: WordBool index 5 read GetWordBoolProp write SetWordBoolProp stored False;
    property OutputGrayScale: WordBool index 6 read GetWordBoolProp write SetWordBoolProp stored False;
    property CursorFileName: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property ShowCustomCursor: WordBool index 8 read GetWordBoolProp write SetWordBoolProp stored False;
    property JPEGQuality: Smallint index 9 read GetSmallintProp write SetSmallintProp stored False;
    property LicenseKey: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property FileWidth: Smallint index 11 read GetSmallintProp write SetSmallintProp stored False;
    property FileHeight: Smallint index 12 read GetSmallintProp write SetSmallintProp stored False;
    property TextColor: TColor index 13 read GetTColorProp write SetTColorProp stored False;
    property TextStyle: Smallint index 14 read GetSmallintProp write SetSmallintProp stored False;
    property TextFontSize: Smallint index 15 read GetSmallintProp write SetSmallintProp stored False;
    property TextFontName: WideString index 16 read GetWideStringProp write SetWideStringProp stored False;
    property TextFontStyle: Smallint index 17 read GetSmallintProp write SetSmallintProp stored False;
    property ShowText: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property SelectionRectHeight: Integer index 19 read GetIntegerProp write SetIntegerProp stored False;
    property SelectionRectWidth: Integer index 20 read GetIntegerProp write SetIntegerProp stored False;
    property SelectionRectLeft: Integer index 21 read GetIntegerProp write SetIntegerProp stored False;
    property SelectionRectTop: Integer index 22 read GetIntegerProp write SetIntegerProp stored False;
    property IsUseExif: WordBool index 23 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrintMarginX: Smallint index 24 read GetSmallintProp write SetSmallintProp stored False;
    property PrintMarginY: Smallint index 25 read GetSmallintProp write SetSmallintProp stored False;
    property PrintSpaceX: Smallint index 26 read GetSmallintProp write SetSmallintProp stored False;
    property PrintSpaceY: Smallint index 27 read GetSmallintProp write SetSmallintProp stored False;
    property PrintOutline: WordBool index 28 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrintStretch: WordBool index 29 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrintVertAlign: Smallint index 30 read GetSmallintProp write SetSmallintProp stored False;
    property PrintHorzAlign: Smallint index 31 read GetSmallintProp write SetSmallintProp stored False;
    property PrintColCount: Smallint index 32 read GetSmallintProp write SetSmallintProp stored False;
    property PrintRowCount: Smallint index 33 read GetSmallintProp write SetSmallintProp stored False;
    property PrintStartPage: Smallint index 34 read GetSmallintProp write SetSmallintProp stored False;
    property PrintEndPage: Smallint index 35 read GetSmallintProp write SetSmallintProp stored False;
    property TextAlphaValue: Smallint index 36 read GetSmallintProp write SetSmallintProp stored False;
    property ShowImage: WordBool index 37 read GetWordBoolProp write SetWordBoolProp stored False;
    property ImageDPI: Smallint index 38 read GetSmallintProp write SetSmallintProp stored False;
    property TIFCompression: TOleEnum index 39 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property GrabScrollCursorFileName: WideString index 40 read GetWideStringProp write SetWideStringProp stored False;
    property MouseTrackMode: TOleEnum index 41 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OnSelectionRectDrawn: TImageViewerSelectionRectDrawn read FOnSelectionRectDrawn write FOnSelectionRectDrawn;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

procedure TImageViewer.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $00000001);
  CLicenseKey: array[0..48] of Word = ( $0044, $0065, $0076, $0065, $006C, $006F, $0070, $0065, $0072, $0020, $006C
    , $0069, $0063, $0065, $006E, $0073, $0065, $003A, $0061, $0030, $0035
    , $0030, $0036, $0020, $0073, $0069, $006E, $0067, $006C, $0065, $0020
    , $0064, $0065, $0076, $0065, $006C, $006F, $0070, $0065, $0072, $0020
    , $006C, $0069, $0063, $0065, $006E, $0073, $0065, $0000);
  CControlData: TControlData2 = (
    ClassID: '{C9460283-3EED-11D0-A647-00A0C91EF7B9}';
    EventIID: '{C9460282-3EED-11D0-A647-00A0C91EF7B9}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnSelectionRectDrawn) - Cardinal(Self);
end;

procedure TImageViewer.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DImageViewer;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TImageViewer.GetControlInterface: _DImageViewer;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TImageViewer.Rotate90;
begin
  DefaultInterface.Rotate90;
end;

function TImageViewer.Save(const strFileName: WideString; const strFileType: WideString): Smallint;
begin
  Result := DefaultInterface.Save(strFileName, strFileType);
end;

function TImageViewer.GetHorzScrollBarPos: Smallint;
begin
  Result := DefaultInterface.GetHorzScrollBarPos;
end;

function TImageViewer.GetVertScrollBarPos: Smallint;
begin
  Result := DefaultInterface.GetVertScrollBarPos;
end;

procedure TImageViewer.SetScrollBarPos(x: Smallint; y: Smallint);
begin
  DefaultInterface.SetScrollBarPos(x, y);
end;

function TImageViewer.PrintImage(bShow: WordBool): Smallint;
begin
  Result := DefaultInterface.PrintImage(bShow);
end;

procedure TImageViewer.SetBackgroundColor(bgColor: OLE_COLOR);
begin
  DefaultInterface.SetBackgroundColor(bgColor);
end;

procedure TImageViewer.Redraw;
begin
  DefaultInterface.Redraw;
end;

function TImageViewer.LoadMultiPage(const strFileName: WideString; iPage: Smallint): Smallint;
begin
  Result := DefaultInterface.LoadMultiPage(strFileName, iPage);
end;

function TImageViewer.GetTotalPage: Smallint;
begin
  Result := DefaultInterface.GetTotalPage;
end;

function TImageViewer.SaveBySize(const strFileName: WideString; const strFileType: WideString; 
                                 iUserWidth: Smallint; iUserHeight: Smallint): Smallint;
begin
  Result := DefaultInterface.SaveBySize(strFileName, strFileType, iUserWidth, iUserHeight);
end;

procedure TImageViewer.Rotate180;
begin
  DefaultInterface.Rotate180;
end;

procedure TImageViewer.SetPrintText(iXPos: Smallint; iYPos: Smallint; 
                                    const strFontName: WideString; iFontSize: Smallint; 
                                    bFontBold: WordBool; bFontItalic: WordBool; 
                                    bFontUnderline: WordBool; clrFontColor: OLE_COLOR; 
                                    const strText: WideString);
begin
  DefaultInterface.SetPrintText(iXPos, iYPos, strFontName, iFontSize, bFontBold, bFontItalic, 
                                bFontUnderline, clrFontColor, strText);
end;

function TImageViewer.Copy2PictureBox: IPictureDisp;
begin
  Result := DefaultInterface.Copy2PictureBox;
end;

function TImageViewer.Copy2HBITMAP: Integer;
begin
  Result := DefaultInterface.Copy2HBITMAP;
end;

function TImageViewer.Copy2Clipboard: WordBool;
begin
  Result := DefaultInterface.Copy2Clipboard;
end;

function TImageViewer.PrintImage2Printer(const strPrintName: WideString): Smallint;
begin
  Result := DefaultInterface.PrintImage2Printer(strPrintName);
end;

procedure TImageViewer.Rotate270;
begin
  DefaultInterface.Rotate270;
end;

procedure TImageViewer.Rotate(iValue: Smallint);
begin
  DefaultInterface.Rotate(iValue);
end;

function TImageViewer.PasteFromClipboard: WordBool;
begin
  Result := DefaultInterface.PasteFromClipboard;
end;

procedure TImageViewer.SetOutlineTextBorderColor(clrBorder: OLE_COLOR);
begin
  DefaultInterface.SetOutlineTextBorderColor(clrBorder);
end;

procedure TImageViewer.SetOutlineTextBackColor(clrBack: OLE_COLOR);
begin
  DefaultInterface.SetOutlineTextBackColor(clrBack);
end;

procedure TImageViewer.SetHashBrushValue(iBrushStyle: Smallint; clrForeColor: OLE_COLOR; 
                                         clrBackColor: OLE_COLOR);
begin
  DefaultInterface.SetHashBrushValue(iBrushStyle, clrForeColor, clrBackColor);
end;

procedure TImageViewer.SetTextureBrushImage(const strImage: WideString);
begin
  DefaultInterface.SetTextureBrushImage(strImage);
end;

function TImageViewer.Crop(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): WordBool;
begin
  Result := DefaultInterface.Crop(iLeft, iTop, iWidth, iHeight);
end;

function TImageViewer.Crop2Clipbord(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): WordBool;
begin
  Result := DefaultInterface.Crop2Clipbord(iLeft, iTop, iWidth, iHeight);
end;

function TImageViewer.Crop2HBITMAP(iLeft: Integer; iTop: Integer; iWidth: Integer; iHeight: Integer): Integer;
begin
  Result := DefaultInterface.Crop2HBITMAP(iLeft, iTop, iWidth, iHeight);
end;

function TImageViewer.Crop2PictureBox(iLeft: Integer; iTop: Integer; iWidth: Integer; 
                                      iHeight: Integer): IPictureDisp;
begin
  Result := DefaultInterface.Crop2PictureBox(iLeft, iTop, iWidth, iHeight);
end;

procedure TImageViewer.ImportFromPictureBox(const pic: IPictureDisp);
begin
  DefaultInterface.ImportFromPictureBox(pic);
end;

function TImageViewer.ReadBinary(const pField: IUnknown): WordBool;
begin
  Result := DefaultInterface.ReadBinary(pField);
end;

function TImageViewer.WriteBinary(const pField: IUnknown): WordBool;
begin
  Result := DefaultInterface.WriteBinary(pField);
end;

procedure TImageViewer.InvertColor;
begin
  DefaultInterface.InvertColor;
end;

function TImageViewer.GetExifTagsName(index: Smallint): WideString;
begin
  Result := DefaultInterface.GetExifTagsName(index);
end;

function TImageViewer.GetExifTagsValue(index: Smallint): WideString;
begin
  Result := DefaultInterface.GetExifTagsValue(index);
end;

function TImageViewer.SetExifStringValue(const strTagName: WideString; const strValue: WideString): WordBool;
begin
  Result := DefaultInterface.SetExifStringValue(strTagName, strValue);
end;

function TImageViewer.GetExifTagsCount: Smallint;
begin
  Result := DefaultInterface.GetExifTagsCount;
end;

procedure TImageViewer.AddBorder(iBorderWidth: Smallint; clrBorder: OLE_COLOR);
begin
  DefaultInterface.AddBorder(iBorderWidth, clrBorder);
end;

procedure TImageViewer.AddGradientBorder(iBorderWidth: Smallint; clrColor1: OLE_COLOR; 
                                         clrColor2: OLE_COLOR; iGradientMode: Smallint);
begin
  DefaultInterface.AddGradientBorder(iBorderWidth, clrColor1, clrColor2, iGradientMode);
end;

procedure TImageViewer.DrawImage(iXPos: Smallint; iYPos: Smallint; const strImageFile: WideString; 
                                 clrTranColor: OLE_COLOR; iAlphaValue: Smallint);
begin
  DefaultInterface.DrawImage(iXPos, iYPos, strImageFile, clrTranColor, iAlphaValue);
end;

procedure TImageViewer.DrawSelectionRect(iLeft: Smallint; iTop: Smallint; iWidth: Smallint; 
                                         iHeight: Smallint);
begin
  DefaultInterface.DrawSelectionRect(iLeft, iTop, iWidth, iHeight);
end;

procedure TImageViewer.DrawText(iXPos: Smallint; iYPos: Smallint; const strText: WideString);
begin
  DefaultInterface.DrawText(iXPos, iYPos, strText);
end;

function TImageViewer.CreateThumbnail(const strFileName: WideString; const strFileType: WideString; 
                                      iThumbnailWidth: Smallint; iThumbnailHeight: Smallint; 
                                      clrBackColor: OLE_COLOR): Smallint;
begin
  Result := DefaultInterface.CreateThumbnail(strFileName, strFileType, iThumbnailWidth, 
                                             iThumbnailHeight, clrBackColor);
end;

procedure TImageViewer.HScroll(iSBCode: Smallint);
begin
  DefaultInterface.HScroll(iSBCode);
end;

function TImageViewer.LoadFromStream(const pStream: IUnknown): WordBool;
begin
  Result := DefaultInterface.LoadFromStream(pStream);
end;

function TImageViewer.LoadImageFromURL(const strURL: WideString; iPageNo: Smallint): WordBool;
begin
  Result := DefaultInterface.LoadImageFromURL(strURL, iPageNo);
end;

procedure TImageViewer.VScroll(iSBCode: Smallint);
begin
  DefaultInterface.VScroll(iSBCode);
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TImageViewer]);
end;

end.
