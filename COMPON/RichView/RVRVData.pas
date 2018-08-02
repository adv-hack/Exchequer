
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRichViewRVData represents RichView document.   }
{       This is a type of TRichView.RVData.             }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVRVData;

interface

{$I RV_Defs.inc}

uses Windows, Classes, Controls, Graphics, Forms, StdCtrls,
     RVItem, RVBack, RVStyle, CRVData, CRVFData, RVCtrlData, RVScroll,
    {$IFDEF RICHVIEWDEF4}
     ImgList,
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
     RVMarker,
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    RVSeqItem,
    {$ENDIF}
    {$IFNDEF RVDONOTUSEDRAGDROP}
     ActiveX, RVDragDrop,
    {$ENDIF}
    {$IFNDEF RVDONOTUSESMARTPOPUP}
    RVPopup,
    {$ENDIF}
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    RVDocParams,
    {$ENDIF}
     RVClasses, RVFuncs, RVAnimate, RVTypes, RVGrIn
     ;

type
  // This event type is for ScaleRichView
  TRVGetMouseClientCoords = procedure (Sender: TControl; var X, Y: Integer)
    of object;
  TRVAfterReadNoteEvent = procedure(RVData: TCustomRVData; ItemNo: Integer)
  of object;

  TRVFGlobalReadData = class
    public
      RVFTextStylesMapping, RVFParaStylesMapping, RVFListStylesMapping: TRVIntegerList;
      Units: TRVStyleUnits;
      destructor Destroy; override;
  end;

  TRichViewRVData = class (TRVControlData)
  private
    FOnClear: TNotifyEvent;
    {$IFNDEF RVDONOTUSESEQ}
    FOnAfterReadNote: TRVAfterReadNoteEvent;
    {$ENDIF}
    FOnBeforeSaving: TNotifyEvent;
    function GetExtraDocumentsList: TStrings;
    procedure SetExtraDocumentsList(const Value: TStrings);
  protected
    FRVFGlobalReadData: TRVFGlobalReadData;
    FExtraDocuments: TStringList;
    FOnDrawHyperlink: TRVDataDrawHyperlinkEvent;
    FRichView: TRVScroller;
    FFontInfoCache: TRVFontInfoCache;
    FClickX, FClickY: Integer;
    {$IFNDEF RVDONOTUSESEQ}
    FSeqList: TRVSeqList;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    FMarkers: TRVMarkerList;
    procedure DestroyMarkers; override;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    procedure DestroySeqList; override;
    {$ENDIF}
    function GetInplaceEditor: TControl; override;
    procedure DestroyInplaceEditor; override;
    function GetRTFProperties: TPersistent{TRVRTFReaderProperties}; override;
    {$IFNDEF RVDONOTUSEDRAGDROP}
    { Drag & drop: drop from }
    function CanStartDragging: Boolean; override;
    function InitDragging(var DropSource: TRVDropSource;
      var OKEffect: Integer): Boolean; override;
    procedure DoneDragging(FDeleteSelection: Boolean); override;
    procedure SetClickCoords(X, Y: Integer); override;
    function CanStartDragBecauseMouseMoved(X, Y: Integer): Boolean; override;    
    {$ENDIF}
    function GetRVDataExtraVOffs: Integer; override;
    function DoCreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
      Owner: TCustomRVFormattedData): TRVFontInfoCache;
    function GetMaxLength: Integer; override;
    function IsWordWrapAllowed: Boolean; override;
    function GetExtraDocuments: TStrings; override;
  public
    {$IFNDEF RVDONOTUSEANIMATION}
    FPlayingAnimation: Boolean;
    FAnimatorList: TRVAnimatorList;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEDRAGDROP}
    FDropSource: TRVDropSource; // object implemeting IDropSource and IDataObject
    {$ENDIF}
    {$IFNDEF RVDONOTUSESMARTPOPUP}
    FSmartPopupButton: TRVSmartPopupButton;
    {$ENDIF}
    OnSetHint: TNotifyEvent;
    OnGetMouseClientCoords: TRVGetMouseClientCoords;
    procedure InitStyleMappings(var PTextStylesMapping,
      PParaStylesMapping, PListStylesMapping: PRVIntegerList;
      var PUnits: PRVStyleUnits); override;
    procedure DoneStyleMappings(AsSubDoc: Boolean); override;
    procedure CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas); override;
    procedure DestroyFontInfoCache(var Cache: TRVFontInfoCache); override;
    function GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
      RVData: TCustomRVFormattedData): TRVFontInfoCache; override;
    {$IFNDEF RVDONOTUSESMARTPOPUP}
    procedure AdjustSpecialControlsCoords(RVData: TCustomRVFormattedData); override;
    procedure SetSmartPopupCoords;
    //procedure InternalFreeItem(item: TCustomRVItemInfo; Clearing: Boolean); override;
    {$ENDIF}
    procedure Clear; override;
    destructor Destroy; override;
    function GetFormatCanvasEx(DefCanvas: TCanvas): TCanvas; override;    
    function CanLoadLayout: Boolean; override;
    function GetExtraRTFCode(Area: TRVRTFSaveArea; Obj: TObject;
      Index1, Index2: Integer; InStyleSheet: Boolean): TRVAnsiString; override;
    function GetExtraHTMLCode(Area: TRVHTMLSaveArea; CSSVersion: Boolean): String; override;
    function GetParaHTMLCode(RVData: TCustomRVData; ItemNo: Integer;
      ParaStart, CSSVersion: Boolean): String; override;
    function GetChosenRVData: TCustomRVData; override;
    function GetChosenItem: TCustomRVItemInfo; override;
    procedure AssignChosenRVData(RVData: TCustomRVFormattedData;
                                 Item: TCustomRVItemInfo); override;
    procedure SilentReplaceChosenRVData(RVData: TCustomRVFormattedData); override;
    procedure UnassignChosenRVData(RVData: TCustomRVData); override;
    function GetParentControl: TWinControl; override;
    procedure GetMouseClientCoords(Control: TWinControl; var X, Y: Integer); override;
    function GetDoInPaletteMode: TRVPaletteAction; override;
    function GetRVPalette: HPALETTE; override;
    function GetRVStyle: TRVStyle; override;
    function GetRVLogPalette: PLogPalette; override;
    function GetURL(id: Integer): String; override;
    procedure ReadHyperlink(const Target, Extras: String; DocFormat: TRVLoadFormat;
      var StyleNo, ItemTag: Integer; var ItemName: TRVRawByteString); override;
    procedure WriteHyperlink(id: Integer; RVData: TCustomRVData; ItemNo: Integer;
       SaveFormat: TRVSaveFormat; var Target, Extras: String); override;
    function GetOptions: TRVOptions; override;
    procedure SetOptions(const Value: TRVOptions); override;
    function GetDocProperties: TStringList; override;
    function GetRVFOptions: TRVFOptions; override;
    procedure SetRVFOptions(const Value: TRVFOptions); override;
    function GetRVFWarnings: TRVFWarnings; override;
    procedure SetRVFWarnings(const Value: TRVFWarnings); override;
    function GetRTFOptions: TRVRTFOptions; override;
    procedure SetRTFOptions(const Value: TRVRTFOptions); override;
    function GetAreaWidth: Integer; override;
    function GetAreaHeight: Integer; override;
    procedure GetOrigin(var ALeft, ATop: Integer); override;
    procedure GetOriginEx(var ALeft, ATop: Integer); override;
    function GetMinTextWidth: Integer; override;
    function GetMaxTextWidth: Integer; override;
    function GetLeftMargin: Integer; override;
    function GetRightMargin: Integer; override;
    function GetTopMargin: Integer; override;
    function GetBottomMargin: Integer; override;
    function GetFlags: TRVFlags; override;
    procedure SetFlags(const Value: TRVFlags); override;
    procedure AdjustVScrollUnits; override;
    procedure SetDocumentAreaSize(Width,Height: Integer; UpdateH: Boolean); override;
    procedure ScrollTo(Y: Integer; Redraw: Boolean); override;
    procedure HScrollTo(X: Integer); override;
    function GetVSmallStep: Integer; override;
    function GetBackground: TRVBackground; override;

    function IsAssignedCopy: Boolean; override;
    function IsAssignedRVMouseDown: Boolean; override;
    function IsAssignedRVMouseUp: Boolean; override;
    function IsAssignedRVRightClick: Boolean; override;
    function IsAssignedJump: Boolean; override;
    function IsAssignedRVDblClick: Boolean; override;
    function IsAssignedCheckpointVisible: Boolean; override;
    function IsAssignedOnProgress: Boolean; override;

    procedure DoProgress(Operation: TRVLongOperation; Stage: TRVProgressStage;
      PercentDone: Byte); override;
    procedure DoCopy; override;
    procedure DoRVMouseMove(id: Integer); override;
    procedure DoRVMouseDown(Button: TMouseButton; Shift: TShiftState;
      ItemNo, X, Y: Integer); override;
    procedure DoRVMouseUp(Button: TMouseButton; Shift: TShiftState;
      ItemNo, X, Y: Integer); override;
    procedure DoRVRightClick(const ClickedWord: TRVRawByteString; StyleNo,
      X, Y: Integer); override;
    procedure DoRVDblClick(const ClickedWord: TRVRawByteString; StyleNo: Integer); override;
    procedure DoCheckpointVisible(CheckpointData: TCheckpointData); override;
    procedure DoDrawHyperlink(RVData: TCustomRVData; ItemNo: Integer; R: TRect); override;
    procedure DoGetItemCursor(RVData: TCustomRVData; ItemNo: Integer;
      var Cursor: TCursor); override;

    procedure DoJump(id: Integer); override;
    procedure DoSelect; override;
    function GetNormalCursor: TCursor; override;
    function GetCPEventKind: TCPEventKind; override;
    procedure HTMLSaveImage(RVData: TCustomRVData; ItemNo: Integer;
      const Path: String; BackgroundColor: TColor; var Location: String;
      var DoDefault: Boolean); override;
    procedure SaveImage2(Graphic: TGraphic; SaveFormat: TRVSaveFormat;
      const Path, ImagePrefix: String; var ImageSaveNo: Integer;
      var Location: String; var DoDefault: Boolean); override;
    constructor Create(RichView: TRVScroller); virtual;
    function GetHOffs: Integer; override;
    function GetVOffs: Integer; override;
    function GetCanvas: TCanvas; override;
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
    function GetColor: TColor; override;
    function SaveComponentToFile(const Path: String; SaveMe: TComponent;
      SaveFormat: TRVSaveFormat): String; override;
    function SaveItemToFile(const Path: String; RVData: TCustomRVData;
      ItemNo: Integer; SaveFormat: TRVSaveFormat; Unicode: Boolean;
      var Text: TRVRawByteString): Boolean; override;
    function ImportPicture(const Location: String;
      Width, Height: Integer; var Invalid: Boolean): TGraphic; override;
    function GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
      const UpperRVDataHint: String): String; override;
    function RVFPictureNeeded(const ItemName: String;
      ItemTag: Integer; PictureInsideRVF: Boolean): TGraphic; override;
    function RVFControlNeeded(const ItemName: String;
      ItemTag: Integer): TControl; override;
    procedure SetControlHint(const Hint: String); override;
    function RVFImageListNeeded(ImageListTag: Integer): TCustomImageList; override;
    function GetDelimiters: String; override;
    function GetRVFTextStylesReadMode: TRVFReaderStyleMode; override;
    function GetRVFParaStylesReadMode: TRVFReaderStyleMode; override;
    function GetBiDiMode: TRVBiDiMode; override;
    procedure ControlAction2(RVData: TCustomRVData; ControlAction: TRVControlAction;
      ItemNo: Integer; var Control:TControl); override;
    procedure ItemAction(ItemAction: TRVItemAction; Item: TCustomRVItemInfo;
      var Text: TRVRawByteString; RVData: TCustomRVData); override;
    {$IFNDEF RVDONOTUSESEQ}
    procedure AfterReadNote(RVData: TCustomRVData; ItemNo: Integer); override;
    {$ENDIF}
    procedure DoBeforeSaving; override;
    procedure AfterAddStyle(StyleInfo: TCustomRVInfo); override;
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    function GetDocParameters(AllowCreate: Boolean): TRVDocParameters; override;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEDRAGDROP}
    { Drag & drop: drop to }
    function GetDragDropCaretInfo: TRVDragDropCaretInfo; override;
    { Drag & drop: drop from }
    function IsDragging: Boolean; override;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEANIMATION}
    procedure InsertAnimator(var Animator: TObject); override;
    function AllowAnimation: Boolean; override;
    procedure ResetAniBackground; override;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    function GetSeqList(AllowCreate: Boolean): TRVSeqList; override;
    function GetNoteText: String; override;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    function GetMarkers(AllowCreate: Boolean): TRVMarkerList; override;
    {$ENDIF}
    property RichView: TRVScroller read FRichView;
    property OnDrawHyperlink: TRVDataDrawHyperlinkEvent read FOnDrawHyperlink write FOnDrawHyperlink;
    property ExtraDocumentsList: TStrings read GetExtraDocumentsList write SetExtraDocumentsList;
    property OnClear: TNotifyEvent read FOnClear write FOnClear;
    {$IFNDEF RVDONOTUSESEQ}
    property OnAfterReadNote: TRVAfterReadNoteEvent read FOnAfterReadNote write FOnAfterReadNote;
    {$ENDIF}
    property OnBeforeSaving: TNotifyEvent read FOnBeforeSaving write FOnBeforeSaving;
  end;

  TRichViewRVDataClass = class of TRichViewRVData;

  TRVFontInfoCacheFast = class(TRVFontInfoCache)
  protected
    function GetItems(Index: Integer): TRVFontInfoCacheItem; override;
  public
    procedure Clear; {$IFDEF RICHVIEWDEF4}override;{$ENDIF}
    {$IFNDEF RICHVIEWDEF4}
    destructor Destroy; override;
    {$ENDIF}
  end;

  TRVFontInfoCacheLowResource = class(TRVFontInfoCache)
  protected
    function GetItems(Index: Integer): TRVFontInfoCacheItem; override;
  end;

implementation
uses RichView, RVUni;
{============================ TRVFGlobalReadData ==============================}
destructor TRVFGlobalReadData.Destroy;
begin
  RVFTextStylesMapping.Free;
  RVFParaStylesMapping.Free;
  RVFListStylesMapping.Free;
  inherited;
end;
{============================ TRichViewRVData =================================}
constructor TRichViewRVData.Create(RichView: TRVScroller);
begin
  inherited Create;
  FRichView := RichView;
end;
{------------------------------------------------------------------------------}
destructor TRichViewRVData.Destroy;
begin
  {$IFNDEF RVDONOTUSELISTS}
  FMarkers.Free;
  FMarkers := nil;
  {$ENDIF}
  {$IFNDEF RVDONOTUSEANIMATION}
  TCustomRichView(RichView).StopAnimation;
  FAnimatorList.Free;
  FAnimatorList := nil;
  {$ENDIF}
  FFontInfoCache.Free;
  FExtraDocuments.Free;
  FRVFGlobalReadData.Free;  
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetDoInPaletteMode: TRVPaletteAction;
begin
  Result := TCustomRichView(FRichView).DoInPaletteMode;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetOptions: TRVOptions;
begin
  Result := TCustomRichView(FRichView).Options;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetOptions(const Value: TRVOptions);
begin
  TCustomRichView(FRichView).Options := Value;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetParentControl: TWinControl;
begin
  Result := TWinControl(FRichView);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.GetMouseClientCoords(Control: TWinControl; var X, Y: Integer);
var pt: TPoint;
begin
  if (rvflRoot in Flags) then
    if Assigned(OnGetMouseClientCoords) then
      // This event is assigned when working in ScaleRichView
      OnGetMouseClientCoords(FRichView, X, Y)
    else begin
      GetCursorPos(pt);
      pt := Control.ScreenToClient(pt);
      X := pt.X;
      Y := pt.Y;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVFOptions: TRVFOptions;
begin
  Result := TCustomRichView(FRichView).RVFOptions;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetRVFOptions(const Value: TRVFOptions);
begin
  TCustomRichView(FRichView).RVFOptions := Value;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRTFOptions: TRVRTFOptions;
begin
  Result := TCustomRichView(FRichView).RTFOptions;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetRTFOptions(const Value: TRVRTFOptions);
begin
  TCustomRichView(FRichView).RTFOptions := Value;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVFWarnings: TRVFWarnings;
begin
  Result := TCustomRichView(FRichView).RVFWarnings;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetRVFWarnings(const Value: TRVFWarnings);
begin
  TCustomRichView(FRichView).RVFWarnings := Value;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVLogPalette: PLogPalette;
begin
  Result := TCustomRichView(FRichView).PRVLogPalette;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVPalette: HPALETTE;
begin
  Result := TCustomRichView(FRichView).RVPalette;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetURL(id: Integer): String;
begin
  Result := '';
  if Assigned(TCustomRichView(FRichView).OnURLNeeded) then
    TCustomRichView(FRichView).OnURLNeeded(TCustomRichView(FRichView), id, Result);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.CanLoadLayout: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetExtraRTFCode(Area: TRVRTFSaveArea;
  Obj: TObject; Index1, Index2: Integer; InStyleSheet: Boolean): TRVAnsiString;
begin
  Result := '';
  if Assigned(TCustomRichView(FRichView).OnSaveRTFExtra) then
    TCustomRichView(FRichView).OnSaveRTFExtra(TCustomRichView(FRichView),
      Area, Obj, Index1, Index2, InStyleSheet, Result);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetExtraHTMLCode(Area: TRVHTMLSaveArea;
  CSSVersion: Boolean): String;
begin
  Result := '';
  if Assigned(TCustomRichView(FRichView).OnSaveHTMLExtra) then
    TCustomRichView(FRichView).OnSaveHTMLExtra(TCustomRichView(FRichView),
      Area, CSSVersion, Result);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetParaHTMLCode(RVData: TCustomRVData;
  ItemNo: Integer; ParaStart, CSSVersion: Boolean): String;
begin
  Result := '';
  if Assigned(TCustomRichView(FRichView).OnSaveParaToHTML) then
    TCustomRichView(FRichView).OnSaveParaToHTML(TCustomRichView(FRichView),
      RVData, ItemNo, ParaStart, CSSVersion, Result);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.ReadHyperlink(const Target, Extras: String;
  DocFormat: TRVLoadFormat; var StyleNo, ItemTag: Integer;
  var ItemName: TRVRawByteString);
begin
  case StyleNo of
    rvsPicture:
      StyleNo := rvsHotPicture;
    rvsBullet:
      StyleNo := rvsHotspot;
  end;
  if Assigned(TCustomRichView(FRichView).OnReadHyperlink) then
    TCustomRichView(FRichView).OnReadHyperlink(TCustomRichView(FRichView),
      Target, Extras, DocFormat, StyleNo, ItemTag, ItemName);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.WriteHyperlink(id: Integer; RVData: TCustomRVData;
  ItemNo: Integer; SaveFormat: TRVSaveFormat;
  var Target, Extras: String);
begin
  Target := '';
  Extras := '';
  if rvflRoot in Flags then begin
    {$IFNDEF RVDONOTUSEITEMHINTS}
    RVData.GetItem(ItemNo).GetExtraStrProperty(rvespHint, Extras);
    Extras := RV_GetHintStr(SaveFormat, Extras);
    {$ENDIF}
    if Assigned(TCustomRichView(FRichView).OnWriteHyperlink) then
      TCustomRichView(FRichView).OnWriteHyperlink(TCustomRichView(FRichView),
        id, RVData, ItemNo, SaveFormat, Target, Extras)
    else
      Target := GetURL(id)
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.RVFControlNeeded(const ItemName: String;
  ItemTag: Integer): TControl;
begin
  Result := nil;
  if Assigned(  TCustomRichView(FRichView).OnRVFControlNeeded) then
      TCustomRichView(FRichView).OnRVFControlNeeded(TCustomRichView(FRichView),
        ItemName, ItemTag, Result);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetControlHint(const Hint: String);
var OldHint: String;
{$IFDEF RICHVIEWDEF5}
    pt: TPoint;
{$ENDIF}
begin
  if (rvflRoot in Flags) then begin
    OldHint := FRichView.Hint;
    FRichView.Hint := Hint;
    // This event is assigned when working in ScaleRichView
    if Assigned(OnSetHint) then
      OnSetHint(FRichView)
    else begin
      if Hint='' then begin
        {$IFDEF RICHVIEWDEF2009}
        if FRichView.CustomHint<>nil then
          FRichView.CustomHint.HideHint;
        {$ENDIF}
        Application.CancelHint;
        end
      else if (Hint<>OldHint) then begin
        {$IFDEF RICHVIEWDEF5}
        {$IFDEF RICHVIEWDEF2009}
        if FRichView.CustomHint<>nil then
          FRichView.CustomHint.ShowHint(FRichView)
        else
        {$ENDIF}
        begin
          GetCursorPos(pt);
          Application.ActivateHint(pt);
        end;
        {$ENDIF}
      end;
    end;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.RVFImageListNeeded(ImageListTag: Integer): TCustomImageList;
begin
  Result := nil;
  if Assigned(TCustomRichView(FRichView).OnRVFImageListNeeded) then
    TCustomRichView(FRichView).OnRVFImageListNeeded(TCustomRichView(FRichView),
                                              ImageListTag, Result);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.RVFPictureNeeded(const ItemName: String;
  ItemTag: Integer; PictureInsideRVF: Boolean): TGraphic;
begin
  Result := nil;
  {$IFDEF RVFPICTURENEEDED2}
  if PictureInsideRVF then
    if Assigned(TCustomRichView(FRichView).OnRVFPictureNeeded2) then
      TCustomRichView(FRichView).OnRVFPictureNeeded2(TCustomRichView(FRichView),
        ItemName, ItemTag, Result)
  else
  {$ENDIF}
    if Assigned(TCustomRichView(FRichView).OnRVFPictureNeeded) then
      TCustomRichView(FRichView).OnRVFPictureNeeded(TCustomRichView(FRichView),
        ItemName, ItemTag, Result);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.SaveComponentToFile(const Path: String;
  SaveMe: TComponent; SaveFormat: TRVSaveFormat): String;
begin
  Result := '';
  if Assigned(TCustomRichView(FRichView).OnSaveComponentToFile) then
    TCustomRichView(FRichView).OnSaveComponentToFile(
      TCustomRichView(FRichView), Path, SaveMe, SaveFormat, Result);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.SaveItemToFile(const Path: String; 
  RVData: TCustomRVData; ItemNo: Integer; SaveFormat: TRVSaveFormat;
  Unicode: Boolean; var Text: TRVRawByteString): Boolean;
begin
  if Assigned(TCustomRichView(FRichView).OnSaveItemToFile) then begin
    Result := True;
    TCustomRichView(FRichView).OnSaveItemToFile(TCustomRichView(FRichView),
      Path, RVData, ItemNo, SaveFormat, Unicode, Text, Result);
    Result := not Result;
    end
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.ImportPicture(const Location: String; Width,
  Height: Integer; var Invalid: Boolean): TGraphic;
begin
  Result := nil;
  if Assigned(TCustomRichView(FRichView).OnImportPicture) then begin
    TCustomRichView(FRichView).CurPictureInvalid := False;
    TCustomRichView(FRichView).OnImportPicture(TCustomRichView(FRichView),
      Location, Width, Height, Result);
    Invalid := TCustomRichView(FRichView).CurPictureInvalid;
    TCustomRichView(FRichView).CurPictureInvalid := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetItemHint(RVData: TCustomRVData;
  ItemNo: Integer; const UpperRVDataHint: String): String;
begin
  if ItemNo<0 then begin
    Result := UpperRVDataHint;
    exit;
  end;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  RVData.GetItem(ItemNo).GetExtraStrProperty(rvespHint, Result);
  {$ELSE}
  Result := '';
  {$ENDIF}
  if Assigned(TCustomRichView(FRichView).OnItemHint) then
    TCustomRichView(FRichView).OnItemHint(TCustomRichView(FRichView),
      RVData, ItemNo, Result);
  if Result='' then
    Result := UpperRVDataHint;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedCopy: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnCopy);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoCopy;
begin
  if Assigned(TCustomRichView(FRichView).OnCopy) then
    TCustomRichView(FRichView).OnCopy(TCustomRichView(FRichView));
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoRVMouseMove(id: Integer);
begin
  if Assigned(TCustomRichView(FRichView).OnRVMouseMove) then
    TCustomRichView(FRichView).OnRVMouseMove(TCustomRichView(FRichView),id);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoRVMouseDown(Button: TMouseButton;
  Shift: TShiftState; ItemNo, X, Y: Integer);
begin
  if Assigned(TCustomRichView(FRichView).OnRVMouseDown) then
    TCustomRichView(FRichView).OnRVMouseDown(TCustomRichView(FRichView),Button,Shift,ItemNo,X,Y);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedRVMouseUp: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnRVMouseUp);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedRVMouseDown: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnRVMouseDown);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedRVRightClick: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnRVRightClick);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedJump: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnJump);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedRVDblClick: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnRVDblClick);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedCheckpointVisible: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnCheckpointVisible);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoRVMouseUp(Button: TMouseButton;
  Shift: TShiftState; ItemNo, X, Y: Integer);
begin
  if IsAssignedRVMouseUp then
    TCustomRichView(FRichView).OnRVMouseUp(TCustomRichView(FRichView),Button,Shift,ItemNo,X,Y);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoRVRightClick(const ClickedWord: TRVRawByteString;
  StyleNo, X, Y: Integer);
begin
  if Assigned(TCustomRichView(FRichView).OnRVRightClick) then
    TCustomRichView(FRichView).OnRVRightClick(TCustomRichView(FRichView),
      ClickedWord, StyleNo, X, Y);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoJump(id: Integer);
begin
  if Assigned(TCustomRichView(FRichView).OnJump) then
    TCustomRichView(FRichView).OnJump(TCustomRichView(FRichView), id);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.HTMLSaveImage(RVData: TCustomRVData; ItemNo: Integer;
  const Path: String; BackgroundColor: TColor;
  var Location: String; var DoDefault: Boolean);
begin
  DoDefault := True;
  if Assigned(TCustomRichView(FRichView).OnHTMLSaveImage) then
    TCustomRichView(FRichView).OnHTMLSaveImage(TCustomRichView(FRichView),
      RVData, ItemNo, Path, BackgroundColor, Location, DoDefault);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SaveImage2(Graphic: TGraphic; SaveFormat: TRVSaveFormat;
  const Path, ImagePrefix: String; var ImageSaveNo: Integer;
  var Location: String; var DoDefault: Boolean); 
begin
  DoDefault := True;
  if Assigned(TCustomRichView(FRichView).OnSaveImage2) then
    TCustomRichView(FRichView).OnSaveImage2(TCustomRichView(FRichView),
      Graphic, SaveFormat, Path, ImagePrefix, ImageSaveNo, Location, DoDefault);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoRVDblClick(const ClickedWord: TRVRawByteString; StyleNo: Integer);
begin
  if Assigned(TCustomRichView(FRichView).OnRVDblClick) then
    TCustomRichView(FRichView).OnRVDblClick(TCustomRichView(FRichView), ClickedWord, StyleNo);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoSelect;
begin
  if Assigned(TCustomRichView(FRichView).OnSelect) and
     not (csDestroying in FRichView.ComponentState) and
     FRichView.HandleAllocated then
    TCustomRichView(FRichView).OnSelect(TCustomRichView(FRichView));
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoCheckpointVisible(CheckpointData: TCheckpointData);
begin
  if Assigned(TCustomRichView(FRichView).OnCheckpointVisible) then
    TCustomRichView(FRichView).OnCheckpointVisible(TCustomRichView(FRichView), CheckpointData);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoDrawHyperlink(RVData: TCustomRVData;
  ItemNo: Integer; R: TRect);
begin
  if rvflRoot in Flags then begin
    if Assigned(FOnDrawHyperlink) then
      FOnDrawHyperlink(RVData, ItemNo, R);
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoGetItemCursor(RVData: TCustomRVData; ItemNo: Integer;
  var Cursor: TCursor);
begin
  if rvflRoot in Flags then begin
    if Assigned(TCustomRichView(FRichView).OnGetItemCursor) then
      TCustomRichView(FRichView).OnGetItemCursor(TCustomRichView(FRichView),
        RVData, ItemNo, Cursor);
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.ControlAction2(RVData: TCustomRVData;
  ControlAction: TRVControlAction; ItemNo: Integer; var Control: TControl);
begin
  if rvflRoot in Flags then begin
    if Assigned(TCustomRichView(FRichView).OnControlAction) then begin
      GetRVStyle.RVData := RVData;
      TCustomRichView(FRichView).OnControlAction(TCustomRichView(FRichView),
        ControlAction, ItemNo, Control);
    end;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.ItemAction(ItemAction: TRVItemAction;
  Item: TCustomRVItemInfo; var Text: TRVRawByteString; RVData: TCustomRVData);
begin
  if Assigned(TCustomRichView(FRichView).OnItemAction) then
    TCustomRichView(FRichView).OnItemAction(TCustomRichView(FRichView),
      ItemAction, Item, Text, RVData);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TRichViewRVData.AfterReadNote(RVData: TCustomRVData; ItemNo: Integer);
begin
  if rvflRoot in Flags then begin
    if Assigned(OnAfterReadNote) then
      OnAfterReadNote(RVData, ItemNo)
    end
  else
    inherited;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoBeforeSaving;
begin
  if (rvflRoot in Flags) and Assigned(OnBeforeSaving) then
    OnBeforeSaving(Self);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoProgress(Operation: TRVLongOperation;
  Stage: TRVProgressStage; PercentDone: Byte);
begin
  if Assigned(TCustomRichView(FRichView).OnProgress) then
    TCustomRichView(FRichView).OnProgress(TCustomRichView(FRichView),
      Operation, Stage, PercentDone);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsAssignedOnProgress: Boolean;
begin
  Result := Assigned(TCustomRichView(FRichView).OnProgress);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetWidth: Integer;
begin
  Result := FRichView.ClientWidth;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetHeight: Integer;
begin
  Result := FRichView.ClientHeight;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetAreaWidth: Integer;
begin
  Result := FRichView.AreaWidth;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetAreaHeight: Integer;
begin
  Result := FRichView.AreaHeight;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetFlags: TRVFlags;
begin
  Result := TCustomRichView(FRichView).Flags;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetFlags(const Value: TRVFlags);
begin
  TCustomRichView(FRichView).Flags := Value;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetHOffs: Integer;
begin
  Result := TCustomRichView(FRichView).HScrollPos;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetVOffs: Integer;
begin
  Result := TCustomRichView(FRichView).VScrollPos*TCustomRichView(FRichView).VSmallStep
    -GetRVDataExtraVOffs;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetLeftMargin: Integer;
begin
  Result := TCustomRichView(FRichView).LeftMargin;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRightMargin: Integer;
begin
  Result := TCustomRichView(FRichView).RightMargin;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetBottomMargin: Integer;
begin
  Result := TCustomRichView(FRichView).BottomMargin;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetTopMargin: Integer;
begin
  Result := TCustomRichView(FRichView).TopMargin;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetMaxTextWidth: Integer;
begin
  Result := TCustomRichView(FRichView).MaxTextWidth;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetMinTextWidth: Integer;
begin
  Result := TCustomRichView(FRichView).MinTextWidth;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.AdjustVScrollUnits;
var v: Integer;
begin
  if  TCustomRichView(FRichView).VScrollVisible and
     (DocumentHeight div TCustomRichView(FRichView).VSmallStep > 32000) then begin
    v := DocumentHeight div 32000;
    if DocumentHeight div v > 32000 then
      inc(v);
    TCustomRichView(FRichView).VSmallStep := v;
    end
  {$IFNDEF DONOTDECVSCROLLUNITS}
  else if (TCustomRichView(FRichView).VSmallStep>10) and
          (DocumentHeight div 10 <= 32000) then
    TCustomRichView(FRichView).VSmallStep := 10;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetDocumentAreaSize(Width, Height: Integer;
  UpdateH: Boolean);
var h: Integer;
begin
  //Width := MulDiv(Width,ZoomPercent,100);
  //Height := MulDiv(Height,ZoomPercent,100);
  {$IFDEF RVDEBUG}{$I Debug\c.inc}{$ENDIF}
  h := Height div TCustomRichView(FRichView).VSmallStep;
  if (Height mod TCustomRichView(FRichView).VSmallStep)>0 then
    inc(h);
  FRichView.UpdateScrollBars(Width, h, UpdateH,True);
  {$IFDEF RV_ODHC}
  if Assigned(TCustomRichView(FRichView).OnDocumentHeightChange) then
    TCustomRichView(FRichView).OnDocumentHeightChange(FRichView);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.ScrollTo(Y: Integer; Redraw: Boolean);
begin
  if rvstNoScroll in State then
    exit;
  if Redraw then
    FRichView.ScrollTo(Y)
  else
    FRichView.ScrollToNoRedraw(Y)
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.HScrollTo(X: Integer);
begin
  if rvstNoScroll in State then
    exit;
  TCustomRichView(FRichView).HScrollPos := X;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetVSmallStep: Integer;
begin
  Result := TCustomRichView(FRichView).VSmallStep;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetBackground: TRVBackground;
begin
  Result := TCustomRichView(FRichView).Background;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetColor: TColor;
begin
  if TCustomRichView(FRichView).Color<>clNone then
    Result := TCustomRichView(FRichView).Color
  else
    Result :=  TCustomRichView(FRichView).Style.Color;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetNormalCursor: TCursor;
begin
  Result := TCustomRichView(FRichView).Cursor;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetDelimiters: String;
begin
  Result := TCustomRichView(FRichView).Delimiters;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetCPEventKind: TCPEventKind;
begin
  Result := TCustomRichView(FRichView).CPEventKind;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetCanvas: TCanvas;
begin
  Result := TCustomRichView(FRichView).Canvas;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVStyle: TRVStyle;
begin
  Result := TCustomRichView(FRichView).Style;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.AssignChosenRVData(RVData: TCustomRVFormattedData;
                                             Item: TCustomRVItemInfo);
begin
  FRichView.AssignChosenRVData(RVData, Item);
  inherited AssignChosenRVData(RVData, Item);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SilentReplaceChosenRVData(
  RVData: TCustomRVFormattedData);
begin
  FRichView.SilentReplaceChosenRVData(RVData);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.UnassignChosenRVData(RVData: TCustomRVData);
begin
  if rvstUnAssigningChosen in State then
    exit;
  State := State+[rvstUnAssigningChosen];
  try
    inherited UnassignChosenRVData(RVData);
    FRichView.UnassignChosenRVData(RVData);
  finally
    State := State-[rvstUnAssigningChosen]
  end;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetInplaceEditor: TControl;
begin
  Result := TCustomRichView(FRichView).InplaceEditor;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetChosenRVData: TCustomRVData;
begin
  Result := TCustomRichView(FRichView).ChosenRVData as TCustomRVData;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetChosenItem: TCustomRVItemInfo;
begin
  Result := TCustomRichView(FRichView).ChosenItem as TCustomRVItemInfo;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DestroyInplaceEditor;
begin
  FRichView.DestroyInplace;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRTFProperties: TPersistent;
begin
  Result := TCustomRichView(FRichView).RTFReadProperties
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDOCPARAMS}
function TRichViewRVData.GetDocParameters(AllowCreate: Boolean): TRVDocParameters;
begin
  if not AllowCreate and not TCustomRichView(FRichView).DocParametersAssigned then
    Result := nil
  else
    Result := TCustomRichView(FRichView).DocParameters;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVFParaStylesReadMode: TRVFReaderStyleMode;
begin
  Result := TCustomRichView(FRichView).RVFParaStylesReadMode;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVFTextStylesReadMode: TRVFReaderStyleMode;
begin
  Result := TCustomRichView(FRichView).RVFTextStylesReadMode;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetBiDiMode: TRVBiDiMode;
begin
  Result := TCustomRichView(FRichView).BiDiMode;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.InitStyleMappings(var PTextStylesMapping,
  PParaStylesMapping, PListStylesMapping: PRVIntegerList;
  var PUnits: PRVStyleUnits);
begin
  if FRVFGlobalReadData=nil then
    FRVFGlobalReadData := TRVFGlobalReadData.Create;
  PTextStylesMapping := @(FRVFGlobalReadData.RVFTextStylesMapping);
  PParaStylesMapping := @(FRVFGlobalReadData.RVFParaStylesMapping);
  PListStylesMapping := @(FRVFGlobalReadData.RVFListStylesMapping);
  PUnits := @(FRVFGlobalReadData.Units);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DoneStyleMappings(AsSubDoc: Boolean);
begin
  FRVFGlobalReadData.Free;
  FRVFGlobalReadData := nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TRichViewRVData.GetSeqList(AllowCreate: Boolean): TRVSeqList;
begin
  if rvflRoot in Flags then begin
    if (FSeqList=nil) and AllowCreate then begin
      FSeqList := TRVSeqList.Create;
    end;
    Result := FSeqList;
    end
  else
    Result := inherited GetSeqList(AllowCreate);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetNoteText: String;
begin
  if rvflRoot in Flags then
    Result := TCustomRichView(FRichView).NoteText
  else
    Result := inherited GetNoteText;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DestroySeqList;
begin
  if rvflRoot in Flags then begin
    FSeqList.Free;
    FSeqList := nil;
    end
  else
    inherited DestroySeqList;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
function TRichViewRVData.GetMarkers(AllowCreate: Boolean): TRVMarkerList;
begin
  if rvflRoot in Flags then begin
    if (FMarkers=nil) and AllowCreate then begin
      FMarkers := TRVMarkerList.Create;
      FMarkers.PrevMarkerList := GetPrevMarkers;
    end;
    Result := FMarkers;
    end
  else
    Result := inherited GetMarkers(AllowCreate);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DestroyMarkers;
begin
  if rvflRoot in Flags then begin
    FMarkers.Free;
    FMarkers := nil;
    end
  else
    inherited DestroyMarkers;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRichViewRVData.GetDocProperties: TStringList;
begin
  if rvflRoot in Flags then
    Result := TCustomRichView(RichView).DocProperties
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDRAGDROP}
{------------------------------------------------------------------------------}
{ Drag&Drop: IDropTarget related                                               }
{------------------------------------------------------------------------------}
{ Returns information about drag&drop caret location.
  D&d caret is not allowed in TRichView.
  This method is overriden in TRVEditRVData.                                   }
function TRichViewRVData.GetDragDropCaretInfo: TRVDragDropCaretInfo;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
{ Drag&Drop: IDropSource related                                               }
{------------------------------------------------------------------------------}
{ Can dragging from this TRichView be started?                                 } 
function TRichViewRVData.CanStartDragging: Boolean;
begin
  if not (rvflRoot in Flags) then begin
    Result := inherited CanStartDragging;
    exit;
  end;
  if rvoDisallowDrag in GetOptions then
    Result := False
  else
    Result := FDropSource=nil;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetClickCoords(X, Y: Integer);
begin
  if rvflRoot in Flags then begin
    FClickX := X;
    FClickY := Y;
    end
  else
    inherited SetClickCoords(X, Y);
end;
{------------------------------------------------------------------------------}
{ Is cursor moved far enough from the click point to start dragging? }
function TRichViewRVData.CanStartDragBecauseMouseMoved(X, Y: Integer): Boolean;
var DX, DY: Integer;
begin
  if rvflRoot in Flags then begin
    DX := (GetSystemMetrics(SM_CXDRAG)+1) div 2;
    DY := (GetSystemMetrics(SM_CYDRAG)+1) div 2;
    Result := (DX<=Abs(X-FClickX)) or (DY<=Abs(Y-FClickY))
    end
  else
    Result := inherited CanStartDragBecauseMouseMoved(X, Y);
end;
{------------------------------------------------------------------------------}
{ Is dragging from this TRichView in process? Overriden in TRichViewRVData.    }
function TRichViewRVData.IsDragging: Boolean;
begin
  if not (rvflRoot in Flags) then
    Result := inherited IsDragging
  else
    Result := FDropSource<>nil;
end;
{------------------------------------------------------------------------------}
{ Initializing dragging. Overriden in TRVEditRVData.
  Returns True on success.
  Returns DropSource and OKEffect for call of DoDragDrop.                      }
function TRichViewRVData.InitDragging(var DropSource: TRVDropSource;
  var OKEffect: Integer): Boolean;
begin
  if not (rvflRoot in Flags) then begin
    Result := inherited InitDragging(DropSource, OKEffect);
    exit;
  end;
  if rvoDisallowDrag in GetOptions then
    Result := False
  else begin
    Result := FDropSource=nil;
    if Result then begin
      FDropSource := TCustomRichView(FRichView).GetRVDropSourceClass.Create(FRichView);
      OKEffect := DROPEFFECT_COPY;
    end;
    DropSource := FDropSource;
  end;
end;
{------------------------------------------------------------------------------}
{ Finalizing dragging.
  Note: if FDropSource<>nil, this function loses the object.                   }
procedure TRichViewRVData.DoneDragging(FDeleteSelection: Boolean);
begin
  FDropSource := nil;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRichViewRVData.GetRVDataExtraVOffs: Integer;
begin
  {$IFDEF RICHVIEWDEF3}
  case TCustomRichView(RichView).VAlign of
    tlBottom:
      begin
        Result := GetHeight-DocumentHeight;
        if Result<0 then
          Result := 0;
      end;
    tlCenter:
      begin
        Result := (GetHeight-DocumentHeight) div 2;
        if Result<0 then
          Result := 0;
      end;
    else
      Result := 0;
  end;
  {$ELSE}
  Result := 0;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.GetOrigin(var ALeft, ATop: Integer);
begin
  ALeft := 0;
  ATop := GetRVDataExtraVOffs;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.GetOriginEx(var ALeft, ATop: Integer);
begin
  ALeft := 0;
  ATop := GetRVDataExtraVOffs;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.Clear;
begin
  {$IFNDEF RVDONOTUSELIVESPELL}
  if RichView<>nil then
    TCustomRichView(RichView).ClearLiveSpellingResults;
  {$ENDIF}
  {$IFNDEF RVDONOTUSEANIMATION}
  if TCustomRichView(RichView).AnimationMode=rvaniOnFormat then
    TCustomRichView(RichView).StopAnimation;
  {$ENDIF}
  {$IFNDEF RVDONOTUSESMARTPOPUP}
  FSmartPopupButton.Free;
  FSmartPopupButton := nil;
  {$ENDIF}
  inherited;
  if Assigned(OnClear) then
    OnClear(Self);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEANIMATION}
procedure TRichViewRVData.InsertAnimator(var Animator: TObject);
begin
  if rvflRoot in Flags then begin
    if FAnimatorList=nil then
      FAnimatorList := TRVAnimatorList.Create;
    FAnimatorList.Add(TRVAnimator(Animator));
    if FPlayingAnimation then
      TCustomRichView(RichView).StartAnimation;
    end
  else
    inherited InsertAnimator(Animator);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.AllowAnimation: Boolean;
begin
  if rvflRoot in Flags then
    Result := TCustomRichView(RichView).AnimationMode<>rvaniDisabled
  else
    Result := inherited AllowAnimation;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.ResetAniBackground;
begin
  if rvflRoot in Flags then begin
    if FAnimatorList<>nil then
      FAnimatorList.ResetBackground;
    end
  else
    inherited ResetAniBackground;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRichViewRVData.DoCreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
  Owner: TCustomRVFormattedData): TRVFontInfoCache;
begin
  if (rvoFastFormatting in Options) and RVNT then
    Result := TRVFontInfoCacheFast.Create(Owner, GetRVStyle, AFormatCanvas, ACanvas,
      rvflCanUseCustomPPI in Flags)
  else
    Result := TRVFontInfoCacheLowResource.Create(Owner, GetRVStyle, AFormatCanvas, ACanvas,
      rvflCanUseCustomPPI in Flags);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas);
begin
  FFontInfoCache.Free;
  FFontInfoCache := DoCreateFontInfoCache(ACanvas, AFormatCanvas, Self);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.DestroyFontInfoCache(var Cache: TRVFontInfoCache);
begin
  if Cache=FFontInfoCache then
    FFontInfoCache := nil;
  inherited DestroyFontInfoCache(Cache);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
  RVData: TCustomRVFormattedData): TRVFontInfoCache;
begin
  Result := FFontInfoCache;
  if Result = nil then
    Result := DoCreateFontInfoCache(ACanvas, AFormatCanvas, RVData);
end;
{==============================================================================}
function AssignSSProperties(CacheItem: TRVFontInfoCacheItem;
  UseFormatCanvas: Boolean; GraphicInterface: TRVGraphicInterface): Boolean;
var potm: POutlineTextmetric;
begin
  if CacheItem.FontInfo.SubSuperScriptType=rvsssNormal then begin
    CacheItem.VerticalOffset := 0;
    Result := False;
    exit;
  end;
  potm := RV_GetOutlineTextMetrics(CacheItem.Canvas, GraphicInterface);
  if potm<>nil then
    try
      case CacheItem.FontInfo.SubSuperScriptType of
        rvsssSubscript:
          begin
            CacheItem.ExtraFontInfo.ScriptHeight := potm.otmptSubscriptSize.Y;
            CacheItem.VerticalOffset := -potm.otmptSubscriptOffset.Y;
          end;
        rvsssSuperscript:
          begin
            CacheItem.ExtraFontInfo.ScriptHeight := potm.otmptSuperscriptSize.Y;
            CacheItem.VerticalOffset := potm.otmTextMetrics.tmAscent-potm.otmptSuperscriptOffset.Y;
          end;
      end;
    finally
      FreeMem(potm);
    end
  else
    case CacheItem.FontInfo.SubSuperScriptType of
      rvsssSubscript:
        begin
          CacheItem.ExtraFontInfo.ScriptHeight := Abs(Round(CacheItem.Canvas.Font.Height*2/3));
          CacheItem.VerticalOffset := -Abs(Round(CacheItem.Canvas.Font.Height*0.25));
        end;
      rvsssSuperscript:
        begin
          CacheItem.ExtraFontInfo.ScriptHeight := Abs(Round(CacheItem.Canvas.Font.Height*2/3));
          CacheItem.VerticalOffset := Abs(Round(CacheItem.Canvas.Font.Height*0.45));
        end;
    end;
  if UseFormatCanvas then begin
    CacheItem.ExtraFontInfo.ScriptHeight :=
      RVConvertFromFormatCanvas(CacheItem.ExtraFontInfo.ScriptHeight, True);
    CacheItem.VerticalOffset :=
      RVConvertFromFormatCanvas(CacheItem.VerticalOffset, True);
  end;
  Result := True;
end;
{========================== TRVFontInfoCacheFast ==============================}
procedure TRVFontInfoCacheFast.Clear;
var
  CacheItem: TRVFontInfoCacheItem;
  i: Integer;
begin
  for i := 0 to Count-1 do
    if Get(i) <> nil then begin
      CacheItem := Get(i);
      FRVStyle.GraphicInterface.DestroyCompatibleCanvas(CacheItem.Canvas);
    end;
  inherited Clear;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RICHVIEWDEF4}
destructor TRVFontInfoCacheFast.Destroy;
begin
  Clear;
  inherited Destroy;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVFontInfoCacheFast.GetItems(Index: Integer): TRVFontInfoCacheItem;
var
  CacheItem: TRVFontInfoCacheItem;
  sz: TSize;
begin
  if (Index<0) or (Index>=Count) then
    CacheItem := FInvalidItem
  else
    CacheItem := Get(Index);
  if CacheItem = nil then begin
    CacheItem := TRVFontInfoCacheItem.Create;
    CacheItem.Canvas := FRVStyle.GraphicInterface.CreateCompatibleCanvas(FCanvas);
    if (FCanvas<>FDrawCanvas) and
      (FRVStyle.GraphicInterface.GetMapMode(FCanvas)=MM_ANISOTROPIC) then begin
      FRVStyle.GraphicInterface.SetMapMode(CacheItem.Canvas, MM_ANISOTROPIC);
      FRVStyle.GraphicInterface.GetWindowExtEx(FCanvas, sz);
      FRVStyle.GraphicInterface.SetWindowExtEx(CacheItem.Canvas, sz.cx, sz.cy, nil);
      FRVStyle.GraphicInterface.GetViewportExtEx(FCanvas, sz);
      FRVStyle.GraphicInterface.SetViewportExtEx(CacheItem.Canvas, sz.cx, sz.cy, nil);
    end;
    CacheItem.FontInfo := FRVStyle.TextStyles[Index];
    FRVStyle.ApplyStyle(CacheItem.Canvas, Index, CurParaBiDiMode, FCanUseCustomPPI,
      nil, True, FCanvas<>FDrawCanvas);
    CacheItem.LastBiDiMode := CurParaBiDiMode;
    if AssignSSProperties(CacheItem, FCanvas<>FDrawCanvas, FRVStyle.GraphicInterface) then
      FRVStyle.ApplyStyle(CacheItem.Canvas, Index, CurParaBiDiMode,
        FCanUseCustomPPI, nil, False, FCanvas<>FDrawCanvas);
    FRVStyle.GraphicInterface.GetTextMetrics(CacheItem.Canvas, CacheItem.TextMetric);
    FRVStyle.GraphicInterface.GetTextExtentPoint32_A(CacheItem.Canvas, '-', 1, sz);
    CacheItem.EmptyLineHeight := sz.cy;
    CacheItem.HyphenWidth := sz.cx;    
    if FCanvas<>FDrawCanvas then begin
      CacheItem.TextMetric.tmAscent :=
        RVConvertFromFormatCanvas(CacheItem.TextMetric.tmAscent, True);
      CacheItem.TextMetric.tmHeight :=
        RVConvertFromFormatCanvas(CacheItem.TextMetric.tmHeight, True);
      CacheItem.EmptyLineHeight :=
        RVConvertFromFormatCanvas(CacheItem.EmptyLineHeight, True);
      CacheItem.HyphenWidth :=
        RVConvertFromFormatCanvas(CacheItem.HyphenWidth, True);
      CacheItem.TextMetric.tmDescent :=
        CacheItem.EmptyLineHeight - CacheItem.TextMetric.tmAscent;
        //RVConvertFromFormatCanvas(CacheItem.TextMetric.tmDescent, True);        
    end;
    inc(CacheItem.VerticalOffset,
      MulDiv(CacheItem.TextMetric.tmHeight, CacheItem.FontInfo.VShift, 100));
    if (Index<0) or (Index>=Count) then
      FInvalidItem := CacheItem
    else
      Put(Index, CacheItem);
  end;
  Result := CacheItem;
  if CacheItem.LastBiDiMode<>CurParaBiDiMode then
    CacheItem.FontInfo.ApplyBiDiMode(CacheItem.Canvas, CurParaBiDiMode,
      FCanvas<>FDrawCanvas, FRVStyle.GraphicInterface);
end;
{======================== TRVFontInfoCacheLowResource =========================}
function TRVFontInfoCacheLowResource.GetItems(Index: Integer): TRVFontInfoCacheItem;
var
  CacheItem, CacheItem2: TRVFontInfoCacheItem;
  sz: TSize;
begin
  if (Index<0) or (Index>=Count) then
    CacheItem := FInvalidItem
  else
    CacheItem := Get(Index);
  CacheItem2 := CacheItem;
  if CacheItem = nil then begin
    CacheItem := TRVFontInfoCacheItem.Create;
    CacheItem.Canvas := FCanvas;
    CacheItem.FontInfo := FRVStyle.TextStyles[Index];
    if (Index<0) or (Index>=Count) then
      FInvalidItem := CacheItem
    else
      Put(Index, CacheItem);
  end;
  if (LastTextStyle <> Index) or (CacheItem.LastBiDiMode<>CurParaBiDiMode) then begin
    CacheItem.LastBiDiMode := CurParaBiDiMode;
    FRVStyle.ApplyStyle(CacheItem.Canvas, Index, CurParaBiDiMode, FCanUseCustomPPI,
      nil, False, FCanvas<>FDrawCanvas);
  end;
  if CacheItem2 = nil then begin
    if FRVStyle.TextStyles[Index].SubSuperScriptType<>rvsssNormal then begin
      FRVStyle.ApplyStyle(CacheItem.Canvas, Index, CurParaBiDiMode, FCanUseCustomPPI,
        nil, True, FCanvas<>FDrawCanvas);
      AssignSSProperties(CacheItem, FCanvas<>FDrawCanvas, FRVStyle.GraphicInterface);
      FRVStyle.ApplyStyle(CacheItem.Canvas, Index, CurParaBiDiMode, FCanUseCustomPPI,
        nil, False, FCanvas<>FDrawCanvas);
    end;
    FRVStyle.GraphicInterface.GetTextMetrics(CacheItem.Canvas, CacheItem.TextMetric);
    FRVStyle.GraphicInterface.GetTextExtentPoint32_A(CacheItem.Canvas, '-', 1, sz);
    CacheItem.EmptyLineHeight := sz.cy;
    CacheItem.HyphenWidth := sz.cx;
    if FCanvas<>FDrawCanvas then begin
      CacheItem.TextMetric.tmAscent :=
        RVConvertFromFormatCanvas(CacheItem.TextMetric.tmAscent, True);
      CacheItem.TextMetric.tmHeight :=
        RVConvertFromFormatCanvas(CacheItem.TextMetric.tmHeight, True);
      CacheItem.EmptyLineHeight :=
        RVConvertFromFormatCanvas(CacheItem.EmptyLineHeight, True);
      CacheItem.HyphenWidth :=
        RVConvertFromFormatCanvas(CacheItem.HyphenWidth, True);
      CacheItem.TextMetric.tmDescent :=
        CacheItem.EmptyLineHeight - CacheItem.TextMetric.tmAscent;
        //RVConvertFromFormatCanvas(CacheItem.TextMetric.tmDescent, True);
    end;
    inc(CacheItem.VerticalOffset,
      MulDiv(CacheItem.TextMetric.tmHeight, CacheItem.FontInfo.VShift, 100));
  end;
  Result := CacheItem;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESMARTPOPUP}
procedure TRichViewRVData.AdjustSpecialControlsCoords(RVData: TCustomRVFormattedData);
begin
  if (FSmartPopupButton=nil) or (FSmartPopupButton.RVData<>RVData.GetSourceRVData) then
    exit;
  RVData := TCustomRVFormattedData(RVData.GetRVData);
  if (FSmartPopupButton.ItemNo<0) or (FSmartPopupButton.ItemNo>=RVData.ItemCount) or
    (RVData.GetItem(FSmartPopupButton.ItemNo)<>FSmartPopupButton.Item) then
    FSmartPopupButton.ItemNo := RVData.GetItemNo(FSmartPopupButton.Item);
  SetSmartPopupCoords;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetSmartPopupCoords;
var DItemNo: Integer;
    Left, Top, X, Y, Width, Height: Integer;
    RVData: TCustomRVFormattedData;
begin
  RVData := TCustomRVFormattedData(FSmartPopupButton.RVData.GetRVData);
  if rvstFormattingPart in RVData.GetAbsoluteRootData.State then
    exit;
  RVData.Item2LastDrawItem(FSmartPopupButton.ItemNo, DItemNo);
  if DItemNo<0 then begin
    FSmartPopupButton.Free;
    FSmartPopupButton := nil;
    exit;
  end;
  RVData.GetOriginEx(Left, Top);
  X := Left + RVData.DrawItems[DItemNo].Left;
  Y := Top  + RVData.DrawItems[DItemNo].Top;
  case FSmartPopupButton.SmartPopupProperties.Position of
    rvsppTopLeft:
      begin
        dec(X, FSmartPopupButton.Width);
        dec(Y, FSmartPopupButton.Height);
      end;
    rvsppTopRight:
      begin
        inc(X, RVData.DrawItems[DItemNo].Width);
        dec(Y, FSmartPopupButton.Height);
      end;
    rvsppBottomRight:
      begin
        inc(X, RVData.DrawItems[DItemNo].Width);
        inc(Y, RVData.DrawItems[DItemNo].Height);
      end;
    rvsppBottomLeft:
      begin
        dec(X, FSmartPopupButton.Width);
        inc(Y, RVData.DrawItems[DItemNo].Height);
      end;
  end;
  Width := GetAreaWidth;
  if GetWidth>Width then
    Width := GetWidth;
  if X+FSmartPopupButton.Width>Width then
    X := Width-FSmartPopupButton.Width;
  Height := GetAreaHeight*TCustomRichView(FRichView).VSmallStep;
  if GetHeight>Height then
    Height := GetHeight;
  if Y+FSmartPopupButton.Height>Height then
    Y := Height-FSmartPopupButton.Height;
  FSmartPopupButton.Left := X - GetHOffs;
  FSmartPopupButton.Tag  := Y - GetVOffs;
  RV_Tag2Y(FSmartPopupButton);
end;
{------------------------------------------------------------------------------}
{
procedure TRichViewRVData.InternalFreeItem(item: TCustomRVItemInfo;
  Clearing: Boolean);
begin
  inherited;
  if not Clearing and (FSmartPopupButton<>nil) and
    (FSmartPopupButton.Item=item) then begin
    FSmartPopupButton.Free;
    FSmartPopupButton := nil;
  end;
end;
}
{$ENDIF}
{------------------------------------------------------------------------------}
function TRichViewRVData.GetMaxLength: Integer;
begin
  if rvflRoot in Flags then
    Result := TCustomRichView(FRichView).MaxLength
  else
    Result := inherited GetMaxLength;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.IsWordWrapAllowed: Boolean;
begin
  if rvflRoot in Flags then
    Result := TCustomRichView(FRichView).WordWrap
  else
    Result := inherited IsWordWrapAllowed;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetFormatCanvasEx(DefCanvas: TCanvas): TCanvas;
begin
  Result := TCustomRichView(FRichView).GetFormatCanvas(DefCanvas);
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetExtraDocuments: TStrings;
begin
  Result := FExtraDocuments;
end;
{------------------------------------------------------------------------------}
function TRichViewRVData.GetExtraDocumentsList: TStrings;
begin
  if FExtraDocuments=nil then
    FExtraDocuments := TStringList.Create;
  Result := FExtraDocuments;
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.SetExtraDocumentsList(const Value: TStrings);
begin
  if Value=nil then
    ExtraDocumentsList.Clear
  else if Value<>ExtraDocumentsList then
    ExtraDocumentsList.Assign(Value);
end;
{------------------------------------------------------------------------------}
procedure TRichViewRVData.AfterAddStyle(StyleInfo: TCustomRVInfo);
begin
  if rvflRoot in Flags then begin
    if Assigned(TCustomRichView(FRichView).OnAddStyle) then
      TCustomRichView(FRichView).OnAddStyle(TCustomRichView(FRichView), StyleInfo);
    end
  else
    inherited;
end;



end.

