{*******************************************************}
{                                                       }
{       RichView                                        }
{       A set of classes representing documents and     }
{       subdocuments in RichView stored in TRVPrint     }
{       and TRVReportHelper.                            }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit PtRVData;

interface
{$I RV_Defs.inc}

uses SysUtils, Classes, Windows, Graphics, Printers,
     DLines, RVFuncs, RVItem, RVBack,
     CRVData, CRVFData, RVRVData,
     {$IFNDEF RVDONOTUSELISTS}
     RVMarker,
     {$ENDIF}
     {$IFNDEF RVDONOTUSESEQ}
     RVNote,
     {$ENDIF}
     RVStyle, RVScroll, RichView, RVUni, RVClasses, RVGrIn;
type
  { ---------------------------------------------------------------------------}
  {$IFNDEF RVDONOTUSESEQ}
  TRVFootnotePtblRVData = class;

  { List of TRVFootnotePtblRVData }
  TRVFootnoteRefList = class (TList)
    private
      function Get(Index: Integer): TRVFootnotePtblRVData;
      procedure Put(Index: Integer; const Value: TRVFootnotePtblRVData);
    public
      procedure DeleteByFootnote(Footnote: TRVFootnoteItemInfo);
      procedure Sort;
      function GetFootnoteIndex(Footnote: TRVFootnoteItemInfo): Integer;
      property Items[Index: Integer]: TRVFootnotePtblRVData read Get write Put; default;
  end;
  {$ELSE}
  TRVFootnoteRefList = TList;
  {$ENDIF}

  { ----------------------------------------------------------------------------
    TRVMultiDrawItemPartsList: list of TRVMultiDrawItemPart.
    Used as TRVMultiDrawItemInfo.PartsList.
  }
  TRVMultiDrawItemPartsList = class (TRVList)
    private
      function Get(Index: Integer): TRVMultiDrawItemPart;
      procedure Put(Index: Integer; const Value: TRVMultiDrawItemPart);
    public
      property Items[Index: Integer]: TRVMultiDrawItemPart read Get write Put; default;
  end;
  { ----------------------------------------------------------------------------
    TRVMultiDrawItemInfo: ancestor class of drawing item containing multiple
    parts on several tables. Inherited classes: TRVTablePrintPart,
    TRVImagePrintPart.
    Note: this class is inherited from TRVComplexLineHeightDrawLineInfo,
    not TRVDrawLineInfo, though it is not necessary used in paragraphs with
    complex line spacing. But it may be there...
  }
  TRVMultiDrawItemInfo = class (TRVComplexLineHeightDrawLineInfo)
    private
      FPartsList: TRVMultiDrawItemPartsList;
    public
      constructor Create;
      destructor Destroy; override;
      procedure ResetPages(var FootnoteRVDataList: TRVFootnoteRefList;
        var ReleasedHeightAfterFootnotes: Integer;
        FootnotesChangeHeight: Boolean); dynamic;
      procedure UnformatLastPage(var FootnoteRVDataList: TRVFootnoteRefList;
        var ReleasedHeightAfterFootnotes: Integer;
        FootnotesChangeHeight: Boolean); dynamic;
      procedure AddAllFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
        var Height: Integer; FootnotesChangeHeight: Boolean); dynamic;
      procedure DecHeightByFootnotes(var Height: Integer;
        var ThisPageHasFootnotes: Boolean); dynamic;
      procedure RemoveAllFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
        var Height: Integer; FootnotesChangeHeight: Boolean); dynamic;
      function GetPartNo(RVData: TCustomRVData; ItemNo, OffsInItem: Integer): Integer; dynamic;
      property PartsList: TRVMultiDrawItemPartsList read FPartsList;
  end;
  { ----------------------------------------------------------------------------
    TRVPageInfo: information about one page.
  }
  TRVPageInfo = class (TCollectionItem)
    public
      StartY, StartDrawItemNo, StartPart, StartY2, DocumentHeight: Integer;
      {$IFNDEF RVDONOTUSESEQ}
      FootnoteRVDataList: TRVFootnoteRefList;
      destructor Destroy; override;
      {$ENDIF}
      procedure Assign(Source: TPersistent); override;
  end;
  { ----------------------------------------------------------------------------
    TRVPageCollection: collection of TRVPageInfo.
    Class of TCustomMainPtblRVData.Pages.
  }
  TRVPageCollection = class (TCollection)
    private
      function GetItem(Index: Integer): TRVPageInfo;
      procedure SetItem(Index: Integer; const Value: TRVPageInfo);
    public
      constructor Create;
      function Add: TRVPageInfo;
      property Items[Index: Integer]: TRVPageInfo
       read GetItem write SetItem; default;
  end;

  TCustomPrintableRVData = class(TRichViewRVData)
    private
      FBackgroundBmp: TBitmap;    // valid only in DrawPage
      FDrawItem: TRVDrawLineInfo; // valid only in DrawPage
      FItemTop: Integer;          // valid only in DrawPage
      FPageNo: Integer;
    protected
      function GetBack: TRVBackground; virtual;
      function GetTopCoord(PageNo: Integer): Integer; virtual;
      function GetPrintableAreaTop: Integer; virtual;
      function GetTopCoord2(PageNo: Integer): Integer; virtual;
      procedure DoPagePrepaint(Canvas: TCanvas; PageNo: Integer;
        Preview, Correction, InRange: Boolean); virtual;
      procedure DoPagePostpaint(Canvas: TCanvas; PageNo: Integer;
        Preview, InRange: Boolean); virtual;
      procedure CheckPageNo(PageNo: Integer); virtual;
      function ShareItems: Boolean; override;
      function InitPrinterCanvas: TCanvas; dynamic;
      procedure DonePrinterCanvas(Canvas: TCanvas); dynamic;
      function GetColorMode: TRVColorMode; virtual;
      function GetSourceRVDataForPrinting: TCustomRVData; dynamic;
      procedure DoOnHyperlink(RVData: TCustomRVData; ItemNo: Integer;
        const R: TRect); virtual;
      procedure DoOnCheckpoint(RVData: TCustomRVData;
        ItemNo, X, Y: Integer); virtual;
      function PageExists(PageNo: Integer): Boolean; virtual;
      {$IFNDEF RVDONOTUSESEQ}
      function IgnoreFootnotes: Boolean; dynamic;
      procedure CalcFootnoteCoords(References: TRVFootnoteRefList;
        PageNo: Integer);
      {$ENDIF}
    public
      ParentDrawsBack: Boolean;
      procedure GetDrawItemsRange(PageNo: Integer;
        var StartNo, EndNo, Part: Integer);  virtual;
      function GetPrintableAreaLeft(PageNo: Integer): Integer; virtual;
      procedure DrawPage(pgNo: Integer; Canvas: TCanvas;
        Preview, Correction: Boolean); virtual;
      procedure DrawBackToBitmap(Left,Top: Integer; bmp: TBitmap;
        const sad: TRVScreenAndDevice;
        ItemBackgroundLayer: Integer; // 0 - do not draw; -1 - draw completely; others - item specific
        RelativeToItem: Boolean); virtual;
      procedure GetPrintableItemsRange(var MinItemNo, MaxItemNo: Integer); dynamic;
  end;

  TCustomMultiPagePtblRVData = class(TCustomPrintableRVData)
    protected
      StreamSavePage: Integer;
      procedure DoFormatting(PageCompleted: Integer; Step:TRVPrintingStep); dynamic;
      function GetInitialStartAt: Integer; dynamic;
      function GetFurtherStartAt: Integer; dynamic;
      procedure SetEndAt(Value: Integer); dynamic;
      procedure IncEndAtByStartAt(PageNo: Integer); dynamic;
      function GetTopCoord(PageNo: Integer): Integer; override;
      function GetTopCoord2(PageNo: Integer): Integer; override;
      procedure RVFGetLimits(SaveScope: TRVFSaveScope;
        var StartItem, EndItem, StartOffs, EndOffs: Integer;
        var StartPart, EndPart: TRVMultiDrawItemPart;
        var SelectedItem: TCustomRVItemInfo); override;
      function PageExists(PageNo: Integer): Boolean; override;
      function AllowEmptyFirstPage: Boolean; dynamic;
      {$IFNDEF RVDONOTUSESEQ}
      function GetFootnoteRVData(
        Footnote: TRVFootnoteItemInfo): TRVFootnotePtblRVData;
      {$ENDIF}
    public
      Pages: TRVPageCollection;
      destructor Destroy; override;
      procedure GetDrawItemsRange(PageNo: Integer;
        var StartNo, EndNo, Part: Integer);  override;
      procedure FormatNextPage(var i, StartAt, StartY, Y: Integer;
        var Splitting: Boolean; var MaxHeight: Integer; 
        var FootnoteRVDataList: TRVFootnoteRefList;
        FootnotesChangeHeight: Boolean);
      function CanPlaceFirstPageHere(var Height: Integer;
        ParentIsFirstItemOnPage: Boolean;
        const sad: TRVScreenAndDevice;
        ThisPageHasFootnotes, FootnotesChangeHeight: Boolean): Boolean;
      {$IFNDEF RVDONOTUSERVF}
      function SavePageAsRVF(Stream: TStream; PageNo: Integer; Color: TColor;
        Background: TRVBackground; Layout: TRVLayoutInfo): Boolean;
      {$ENDIF}
      {$IFNDEF RVDONOTUSESEQ}
      function GetNoteSeparatorHeight: Integer;
      {$ENDIF}
      procedure GetFirstItemOnPageEx(PageNo: Integer; var ItemNo, OffsetInItem,
        ExtraData: Integer);
      function IsComplexSoftPageBreak(PageNo: Integer): Boolean;
      procedure AssignComplexSoftPageBreakToItem(PageNo: Integer;
        RVData: TCustomRVFormattedData);
      function GetPageNo(RVData: TCustomRVData;
        ItemNo, OffsetInItem: Integer; PrintSourceRVData: TCustomRVData): Integer;
  end;

  TCustomMainPtblRVData = class(TCustomMultiPagePtblRVData)
    private
      {$IFNDEF RVDONOTUSELISTS}
      FPrevMarkers: TRVMarkerList;
      {$ENDIF}
    protected
      procedure DoFormatting(PageCompleted: Integer; Step:TRVPrintingStep); override;
      function GetBack: TRVBackground; override;
      function GetTopCoord(PageNo: Integer): Integer; override;
      function GetTopCoord2(PageNo: Integer): Integer; override;
      procedure GetSADForFormatting(Canvas: TCanvas; var sad: TRVScreenAndDevice); override;
      function GetPrintableAreaTop: Integer; override;
      procedure CheckPageNo(PageNo: Integer); override;
      procedure Prepare; dynamic;
      function GetColorMode: TRVColorMode; override;
      function GetFirstItemMarker(var ListNo, Level: Integer): Boolean; override;
      function GetSourceRVDataForPrinting: TCustomRVData; override;
      function GetInitialStartAt: Integer; override;
      procedure SetEndAt(Value: Integer); override;
      procedure IncEndAtByStartAt(PageNo: Integer); override;
      {$IFNDEF RVDONOTUSESEQ}
      procedure DoPagePostpaint(Canvas: TCanvas; PageNo:Integer;
        Preview, InRange: Boolean); override;
      {$ENDIF}
    public
      PrinterCanvas : TCanvas;
      TmpTMPix, TmpBMPix: Integer;
      PrnSad: TRVScreenAndDevice;
      FTopMarginPix, FBottomMarginPix: Integer;
      Transparent: Boolean;
      TmpM, PhysM: TRect;
      ColorMode: TRVColorMode;
      FIsDestinationReady: Boolean;
      procedure Clear; override;
      function GetPageWidth: Integer; dynamic;
      function GetPageHeight: Integer; dynamic;      
      function GetPrintableAreaLeft(PageNo: Integer): Integer; override;
      procedure InitFormatPages;
      function FormatPages: Integer;
      procedure FinalizeFormatPages;
      function GetCanvas: TCanvas; override;
      procedure DrawPage(pgNo: Integer; Canvas: TCanvas; Preview, Correction: Boolean); override;
      function GetColor: TColor; override;
      {$IFNDEF RVDONOTUSELISTS}
      function GetPrevMarkers: TRVMarkerList; override;
      {$ENDIF}
      constructor Create(RichView: TRVScroller); override;
      procedure GetPrintableItemsRange(var MinItemNo, MaxItemNo: Integer); override;
  end;

  TRVHeaderFooterRVData = class;

  TPrintableRVData = class(TCustomMainPtblRVData)
    private
      Rgn: HRGN;
      RgnValid: Boolean;
    protected
      procedure DoFormatting(PageCompleted: Integer; Step:TRVPrintingStep); override;
      function InitPrinterCanvas: TCanvas; override;
      procedure DonePrinterCanvas(Canvas: TCanvas); override;
      procedure DoPagePrepaint(Canvas: TCanvas; PageNo: Integer;
        Preview, Correction, InRange: Boolean); override;
      procedure DoPagePostpaint(Canvas: TCanvas; PageNo: Integer;
        Preview, InRange: Boolean); override;
      procedure Prepare; override;
    public
      TmpLMMir: Integer;
      Header, Footer: TRVHeaderFooterRVData;
      HeaderY, FooterY: Integer;
      function GetPrintableAreaLeft(PageNo: Integer): Integer; override;
      constructor Create(RichView: TRVScroller); override;
      destructor Destroy; override;
      function GetPageWidth: Integer; override;
      function GetPageHeight: Integer; override;      
  end;

  TRectPtblRVData = class(TCustomMultiPagePtblRVData)
    protected
      procedure GetSADForFormatting(Canvas: TCanvas;
        var sad: TRVScreenAndDevice); override;
      function GetPrintableAreaTop: Integer; override;
      function GetTopCoord(PageNo: Integer): Integer; override;
      function GetTopCoord2(PageNo: Integer): Integer; override;
      function InitPrinterCanvas: TCanvas; override;
      function GetColorMode: TRVColorMode; override;
      function GetSourceRVDataForPrinting: TCustomRVData; override;
      procedure DoOnHyperlink(RVData: TCustomRVData; ItemNo: Integer;
        const R: TRect); override;
      procedure DoOnCheckpoint(RVData: TCustomRVData; ItemNo, X, Y: Integer); override;
      {$IFNDEF RVDONOTUSESEQ}
      function IgnoreFootnotes: Boolean; override;
      {$ENDIF}            
    public
      FSourceDataForPrinting: TCustomRVData;
      FParentPrintData: TCustomPrintableRVData;
      Left,Top,DX,DY,Width,Height: Integer;
      Transparent: Boolean;
      FColor: TColor;
      procedure CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas); override;
      procedure DestroyFontInfoCache(var Cache: TRVFontInfoCache); override;
      function GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
        RVData: TCustomRVFormattedData): TRVFontInfoCache; override;
      function GetMaxTextWidth: Integer; override;
      function GetMinTextWidth: Integer; override;
      function GetPrintableAreaLeft(PageNo: Integer): Integer; override;
      function GetParentData: TCustomRVData; override;
      function GetRootData: TCustomRVData; override;
      function GetAbsoluteParentData: TCustomRVData; override;
      function GetAbsoluteRootData: TCustomRVData; override;
      constructor Create(RichView: TRVScroller;
        SourceDataForPrinting: TCustomRVData;
        ParentPrintData: TCustomPrintableRVData); {$IFDEF RICHVIEWDEF4} reintroduce;{$ENDIF}
      procedure DrawBackToBitmap(Left,Top: Integer; bmp: TBitmap;
        const sad: TRVScreenAndDevice; ItemBackgroundLayer: Integer;
        RelativeToItem: Boolean); override;
      function GetWidth: Integer; override;
      function GetHeight: Integer; override;
      function GetLeftMargin: Integer; override;
      function GetRightMargin: Integer; override;
      function GetTopMargin: Integer; override;
      function GetBottomMargin: Integer; override;
      function GetCanvas: TCanvas; override;
      function GetColor: TColor; override;
  end;

  TRVHeaderFooterRVData = class (TRectPtblRVData)
    protected
      {$IFNDEF RVDONOTUSESEQ}
      function IgnoreFootnotes: Boolean; override;
      {$ENDIF}
    public
      FLeftMargin, FRightMargin, FTopMargin, FBottomMargin: Integer;
      constructor Create(RichView: TRVScroller; SourceDataForPrinting: TCustomRVData;
        ParentPrintData: TCustomPrintableRVData);
      function GetRVStyle: TRVStyle; override;
      procedure CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas); override;
      function GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
        RVData: TCustomRVFormattedData): TRVFontInfoCache; override;
      function GetLeftMargin: Integer; override;
      function GetRightMargin: Integer; override;
      function GetTopMargin: Integer; override;
      function GetBottomMargin: Integer; override;
  end;

  {$IFNDEF RVDONOTUSESEQ}
  TRVEndnotePtblRVData = class(TCustomMultiPagePtblRVData)
    protected
      function GetSourceRVDataForPrinting: TCustomRVData; override;
      function GetInitialStartAt: Integer; override;
      function GetFurtherStartAt: Integer; override;
      procedure SetEndAt(Value: Integer); override;
      procedure IncEndAtByStartAt(PageNo: Integer); override;
      procedure GetSADForFormatting(Canvas: TCanvas;
        var sad: TRVScreenAndDevice); override;
      function GetTopCoord(PageNo: Integer): Integer; override;
      function GetTopCoord2(PageNo: Integer): Integer; override;
      function AllowEmptyFirstPage: Boolean; override;
      function IgnoreFootnotes: Boolean; override;
    public
      Endnote: TRVEndnoteItemInfo;
      StartAt, NextStartAt, EndAt: Integer;
      FromNewPage: Boolean;
      constructor Create(RichView: TRVScroller); override;
      function GetCanvas: TCanvas; override;
      function GetDocProperties: TStringList; override;
      function GetPrintableAreaLeft(PageNo: Integer): Integer; override;
      function GetPrintableAreaTop: Integer; override;
      (*
      procedure CreateFontInfoCache(ACanvas: TCanvas); override;
      procedure DestroyFontInfoCache(var Cache: TRVFontInfoCache); override;
      function GetFontInfoCache(ACanvas: TCanvas;
        RVData: TCustomRVFormattedData): TRVFontInfoCache; override;
      *)
      function GetParentData: TCustomRVData; override;
      function GetRootData: TCustomRVData; override;
      function GetAbsoluteParentData: TCustomRVData; override;
      function GetAbsoluteRootData: TCustomRVData; override;
  end;

  TRVFootnotePtblRVData = class (TRectPtblRVData)
    protected
      function IgnoreFootnotes: Boolean; override;
    public
      IndexOnPage: Integer;
      Footnote: TRVFootnoteItemInfo;
      FootnoteItemRVData: TCustomRVFormattedData;
      FootnoteDItemNo: Integer;
      procedure AdjustFootnoteRefWidths;
  end;
  {$ENDIF}



implementation
uses PtblRV, RVStr, RVSeqItem;

{============================ TRVMultiDrawItemInfo ============================}
constructor TRVMultiDrawItemInfo.Create;
begin
  inherited Create;
  FPartsList := TRVMultiDrawItemPartsList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVMultiDrawItemInfo.Destroy;
begin
  FPartsList.Free;
  inherited  Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVMultiDrawItemInfo.ResetPages(var FootnoteRVDataList: TRVFootnoteRefList;
  var ReleasedHeightAfterFootnotes: Integer; FootnotesChangeHeight: Boolean);
begin
  FPartsList.Clear;
end;
{------------------------------------------------------------------------------}
procedure TRVMultiDrawItemInfo.UnformatLastPage(var FootnoteRVDataList: TRVFootnoteRefList;
  var ReleasedHeightAfterFootnotes: Integer; FootnotesChangeHeight: Boolean);
begin

end;
{------------------------------------------------------------------------------}
{ This function is called for drawing items that cannot be split }
procedure TRVMultiDrawItemInfo.AddAllFootnotes(
  var FootnoteRVDataList: TRVFootnoteRefList; var Height: Integer;
  FootnotesChangeHeight: Boolean);
begin

end;
{------------------------------------------------------------------------------}
{ This function is called for drawing items that cannot be split }
procedure TRVMultiDrawItemInfo.DecHeightByFootnotes(var Height: Integer;
  var ThisPageHasFootnotes: Boolean);
begin

end;
{------------------------------------------------------------------------------}
{ This function is called for drawing items that cannot be split }
procedure TRVMultiDrawItemInfo.RemoveAllFootnotes(
  var FootnoteRVDataList: TRVFootnoteRefList; var Height: Integer;
  FootnotesChangeHeight: Boolean);
begin

end;
{------------------------------------------------------------------------------}
{ Returns the index of part containing the given position, or -1 if not found }
function TRVMultiDrawItemInfo.GetPartNo(RVData: TCustomRVData;
  ItemNo, OffsInItem: Integer): Integer;
begin
  Result := -1;
end;
{=============================== TRVPageInfo ==================================}
{$IFNDEF RVDONOTUSESEQ}
destructor TRVPageInfo.Destroy;
begin
  FootnoteRVDataList.Free;
  inherited;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVPageInfo.Assign(Source: TPersistent);
{$IFNDEF RVDONOTUSESEQ}
var i: Integer;
{$ENDIF}
begin
  if Source is TRVPageInfo then begin
    StartY := TRVPageInfo(Source).StartY;
    StartDrawItemNo := TRVPageInfo(Source).StartDrawItemNo;
    StartPart := TRVPageInfo(Source).StartPart;
    StartY2 := TRVPageInfo(Source).StartY2;
    DocumentHeight := TRVPageInfo(Source).DocumentHeight;
    {$IFNDEF RVDONOTUSESEQ}
    FootnoteRVDataList.Free;
    if TRVPageInfo(Source).FootnoteRVDataList=nil then
      FootnoteRVDataList := nil
    else begin
      FootnoteRVDataList := TRVFootnoteRefList.Create;
      for i := 0 to TRVPageInfo(Source).FootnoteRVDataList.Count-1 do
        FootnoteRVDataList.Add(TRVPageInfo(Source).FootnoteRVDataList[i]);
    end;
    {$ENDIF}
    end
  else
    inherited Assign(Source);
end;
{============================= TRVPageCollection ==============================}
function TRVPageCollection.Add: TRVPageInfo;
begin
  Result := TRVPageInfo(inherited Add);
end;
{------------------------------------------------------------------------------}
constructor TRVPageCollection.Create;
begin
  inherited Create(TRVPageInfo);
end;
{------------------------------------------------------------------------------}
function TRVPageCollection.GetItem(Index: Integer): TRVPageInfo;
begin
  Result := TRVPageInfo(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVPageCollection.SetItem(Index: Integer;
  const Value: TRVPageInfo);
begin
  inherited SetItem(Index, Value);
end;
{======================== TRVMultiDrawItemPartsList ===========================}
function TRVMultiDrawItemPartsList.Get(
  Index: Integer): TRVMultiDrawItemPart;
begin
  Result := TRVMultiDrawItemPart(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVMultiDrawItemPartsList.Put(Index: Integer;
  const Value: TRVMultiDrawItemPart);
begin
  inherited Put(Index, Value);
end;
{============================== TCustomPrintableRVData ========================}
procedure TCustomPrintableRVData.DonePrinterCanvas(Canvas: TCanvas);
begin

end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetSourceRVDataForPrinting: TCustomRVData;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetColorMode: TRVColorMode;
begin
  Result := rvcmPrinterColor;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.ShareItems: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.InitPrinterCanvas: TCanvas;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetBack: TRVBackground;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetTopCoord(PageNo: Integer): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetTopCoord2(PageNo: Integer): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetPrintableAreaLeft(PageNo: Integer): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.GetPrintableAreaTop: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.DoPagePrepaint(Canvas: TCanvas; PageNo:Integer;
  Preview, Correction, InRange: Boolean);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.DoPagePostpaint(Canvas: TCanvas; PageNo: Integer;
  Preview, InRange: Boolean);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.GetDrawItemsRange(PageNo: Integer; var StartNo, EndNo, Part: Integer);
begin
  StartNo := 0;
  EndNo   := DrawItems.Count-1;
  Part    := -1;
  //FirstOffs := 0;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.CheckPageNo(PageNo: Integer);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.DrawBackToBitmap(Left, Top: Integer;
  bmp: TBitmap; const sad: TRVScreenAndDevice; ItemBackgroundLayer: Integer;
  RelativeToItem: Boolean);
var pi: TParaInfo;
    item: TCustomRVItemInfo;
    Clr: TColor;
    r,r2: TRect;
begin
  if RelativeToItem then begin
    inc(Left, RV_XToScreen(FDrawItem.Left, sad));
    inc(Top,  RV_YToScreen(FItemTop-GetPrintableAreaTop, sad));
  end;
  item := GetItem(FDrawItem.ItemNo);
  pi := GetRVStyle.ParaStyles[item.ParaNo];
  r := Rect(0,0, bmp.Width, bmp.Height);
  if (pi.Background.Color=clNone) and (FBackgroundBmp<>nil) then
    GetRVStyle.GraphicInterface.CopyRect(
      bmp.Canvas, Rect(0,0, bmp.Width, bmp.Height),
      FBackgroundBmp.Canvas, Bounds(Left, Top, bmp.Width, bmp.Height))
  else begin
    Clr := pi.Background.Color;
    if Clr = clNone then
      Clr := GetColor;
    if Clr = clNone then
      Clr := clWhite;
    bmp.Canvas.Pen.Color := Clr;
    bmp.Canvas.Brush.Color := Clr;
    GetRVStyle.GraphicInterface.FillRect(bmp.Canvas, r);
  end;
  if ItemBackgroundLayer<>0 then begin
    r2 := Bounds(RV_XToScreen(FDrawItem.Left, sad)-Left,
      RV_YToScreen(FItemTop-GetPrintableAreaTop, sad)-Top,
      RV_XToScreen(FDrawItem.Width,sad),
      RV_YToScreen(FDrawItem.Height,sad));
    item.DrawBackgroundForPrinting(bmp.Canvas, r, r2, GetColorMode,
      ItemBackgroundLayer, GetRVStyle.GraphicInterface);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.GetPrintableItemsRange(var MinItemNo, MaxItemNo: Integer);
begin
  MinItemNo := 0;
  MaxItemNo := ItemCount-1;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.DoOnHyperlink(RVData: TCustomRVData;
  ItemNo: Integer; const R: TRect);
begin
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.DoOnCheckpoint(RVData: TCustomRVData;
  ItemNo, X, Y: Integer);
begin
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRVData.PageExists(PageNo: Integer): Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TCustomPrintableRVData.IgnoreFootnotes: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.CalcFootnoteCoords(References: TRVFootnoteRefList;
  PageNo: Integer);
begin
  if Self is TCustomMainPtblRVData then
    TCustomPrintableRV((GetAbsoluteRootData as TCustomMainPtblRVData).
      FRichView).CalcFootnotesCoords(References, PageNo);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomPrintableRVData.DrawPage(pgNo: Integer; Canvas: TCanvas; Preview, Correction: Boolean);
var i,no: Integer;
    dli:TRVDrawLineInfo;
    item: TCustomRVItemInfo;
    zerocoord: Integer;
    first, last, part: Integer;
    tmpbmp : TBitmap;
    LeftOffs: Integer;
    RVStyle: TRVStyle;
    sad: TRVScreenAndDevice;
    MinItemNo, MaxItemNo: Integer;
    //FloatingDrawItems: TRVFloatingDrawItems;
    {.......................................}
    function GetDevX(ScreenX: Integer):Integer;
    begin
      Result := MulDiv(ScreenX, sad.ppixDevice, sad.ppixScreen);
    end;
    {.......................................}
    function GetDevY(ScreenY: Integer):Integer;
    begin
      Result := MulDiv(ScreenY, sad.ppiyDevice, sad.ppiyScreen);
    end;
    {.......................................}
    procedure DrawBackground; // in-out: backgroundbmp
                              // in: Canvas
    var BackWidth, BackHeight: Integer;
        Color: TColor;
    begin
      BackWidth  := RV_XToScreen(GetWidth,  sad);
      BackHeight := RV_YToScreen(GetHeight, sad);
      if (GetBack<>nil) and
         (GetBack.Style <> bsNoBitmap) and
         not GetBack.Bitmap.Empty then begin
        if GetBack.Style=bsTiledAndScrolled then
          GetBack.Style:=bsTiled;
        FBackgroundBmp := TBitmap.Create;
        FBackgroundBmp.Width := BackWidth;
        FBackgroundBmp.Height := BackHeight;
        if Preview and (GetRVLogPalette<>nil) then
          FBackgroundBmp.Palette := CreatePalette(GetRVLogPalette^);
        GetBack.Draw(FBackgroundBmp.Canvas, Rect(0,0, BackWidth, BackHeight),
          0,0, 0, 0, BackWidth, BackHeight, GetColor, False, False,
          RVStyle.GraphicInterface);
        RV_PictureToDevice(Canvas, GetPrintableAreaLeft(pgNo),
          GetPrintableAreaTop, -1, -1, @sad, FBackgroundBmp, Preview,
          RVStyle.GraphicInterface);
        end
      else begin
        FBackgroundBmp := nil;
        if not ParentDrawsBack then
          with Canvas do
            if GetColor<>clNone then begin
              case GetColorMode of
                rvcmColor:
                  Color := GetColor;
                rvcmPrinterColor:
                  Color := RV_GetPrnColor(GetColor);
                rvcmGrayScale:
                  Color := RV_GetGray(RV_GetPrnColor(GetColor));
                else
                  Color := clWhite;
              end;
              Pen.Color := Color;
              Brush.Color := Color;
              Brush.Style := bsSolid;
              Pen.Style := psClear;
              FillRect(Bounds(GetPrintableAreaLeft(pgNo), GetPrintableAreaTop, GetWidth,GetHeight));
              Pen.Style := psSolid;
            end;
      end;
    end;
    {.......................................}
    procedure DrawBackTotmpbmp(Top: Integer); // in: backgroundbmp,tmpbmp,dli,item
    begin
      DrawBackToBitmap(
        RV_XToScreen(FDrawItem.Left, sad)+RVStyle.GetAsPixels(item.GetBorderWidth),
        RV_YToScreen(FItemTop-GetPrintableAreaTop, sad)+RVStyle.GetAsPixels(item.GetBorderHeight),
        tmpbmp, sad, -1, False);
    end;
    {.......................................}
    procedure DrawParagraph(i: Integer);
    var R, R1: TRect;
        dli: TRVDrawLineInfo;
        item: TCustomRVItemInfo;
        pi: TParaInfo;
        j: Integer;
    begin
      dli := DrawItems[i];
      if (dli.ItemNo<MinItemNo) or (dli.ItemNo>MaxItemNo) then
        exit;
      item := GetItem(dli.ItemNo);
      pi := RVStyle.ParaStyles[item.ParaNo];
      if (pi.Border.Style<>rvbNone) or (pi.Background.Color<>clNone) or
        Assigned(RVStyle.OnDrawParaBack) then begin
        R.Left := LeftOffs+GetDevX(GetLeftMargin)+RVStyle.GetAsDevicePixelsX(pi.LeftIndent, @sad);
        if pi.FirstIndent<0 then
          inc(R.Left, RVStyle.GetAsDevicePixelsX(pi.FirstIndent, @sad));
        R.Right:= LeftOffs+GetDevX(GetLeftMargin)-RVStyle.GetAsDevicePixelsX(pi.RightIndent, @sad)+TextWidth;
        if (i=first) and (part>=0) then begin
          R.Top := 0;
          R.Bottom := TRVMultiDrawItemInfo(dli).PartsList[part].Height;
          end
        else begin
          R.Top := dli.Top-dli.ExtraSpaceAbove;
          if (i=last) and (dli is TRVMultiDrawItemInfo) and
            (TRVMultiDrawItemInfo(dli).PartsList.Count>0) then
            R.Bottom := dli.Top+TRVMultiDrawItemInfo(dli).PartsList[0].Height
          else
            R.Bottom := dli.Top+dli.Height+dli.ExtraSpaceBelow;
        end;
        for j := i+1 to last do begin
          dli := DrawItems[j];
          if (dli.ItemNo<>DrawItems[j-1].ItemNo) and
             GetItem(dli.ItemNo).CanBeBorderStart then break;
          if dli.Top-dli.ExtraSpaceAbove<R.Top then
            R.Top := dli.Top-dli.ExtraSpaceAbove;
          if (j=last) and (dli is TRVMultiDrawItemInfo) and
            (TRVMultiDrawItemInfo(dli).PartsList.Count>0) then
            R.Bottom := dli.Top+TRVMultiDrawItemInfo(dli).PartsList[0].Height
          else
            if dli.Top+dli.Height+dli.ExtraSpaceBelow>R.Bottom then
              R.Bottom := dli.Top+dli.Height+dli.ExtraSpaceBelow;
        end;
        {
        if (FloatingDrawItems<>nil) and (FloatingDrawItems.Count>0) then begin
          dec(R.Right, R.Left-1);
          FloatingDrawItems.AdjustLineSize(R.Left, 0, R.Left+R.Right,
            R.Top, R.Left, R.Right, True);
            inc(R.Right, R.Left-1);
        end;
        }
        OffsetRect(R,0,-zerocoord);
        dec(R.Right);
        dec(R.Bottom);
        R1 := R;
        pi.Background.PrepareDrawSaD(R1, RVStyle, sad);
        RVStyle.DrawParaBack(Canvas, item.ParaNo, R1, True, GetColorMode);
        pi.Border.DrawSaD(R, Canvas, RVStyle, sad, GetColorMode, RVStyle.GraphicInterface);
      end;
      {
      for j := i to last do begin
        dli := DrawItems[j];
        if (j>i) and (dli.ItemNo<>DrawItems[j-1].ItemNo) and
           GetItem(dli.ItemNo).CanBeBorderStart then
          break;
        if dli is TRVFloatingDrawLineInfo then begin
          if FloatingDrawItems=nil then
            FloatingDrawItems := TRVFloatingDrawItems.Create;
            FloatingDrawItems.Add(dli);
        end;
      end;
      }
    end;
    {.......................................}
var w, h, part2: Integer;
    BiDiMode, BiDiMode2: TRVBiDiMode;
    Dummy: Boolean;
    TextStyle: TFontInfo;
begin
  FPageNo := pgNo;
  RVStyle := GetRVStyle;
  if RVStyle=nil then
    raise ERichViewError.Create(errStyleIsNotAssigned);
  GetSADForFormatting(Canvas, sad);
  Canvas.Brush.Style := bsClear;
  FBackgroundBmp := nil;
  GetDrawItemsRange(pgNo, first, last, part);
  GetPrintableItemsRange(MinItemNo, MaxItemNo);
  if (first<0) or (last<0) or ((DrawItems[first].ItemNo>=MinItemNo) and (DrawItems[first].ItemNo<=MaxItemNo)) then
    DrawBackground;
  DoPagePrepaint(Canvas, pgNo, Preview, Correction,
    (first<0) or (last<0) or ((DrawItems[first].ItemNo>=MinItemNo) and (DrawItems[first].ItemNo<=MaxItemNo)));
  if not PageExists(PgNo) then begin
    FBackgroundBmp.Free;
    DoPagePostpaint(Canvas, pgNo, Preview,
      (last<0) or (last<0) or ((DrawItems[last].ItemNo>=MinItemNo) and (DrawItems[last].ItemNo<=MaxItemNo)));
    exit;
  end;
//  GetDrawItemsRange(pgNo, first, last, part);
  zerocoord := GetTopCoord(PgNo);
  LeftOffs  := GetPrintableAreaLeft(pgNo);
  tmpbmp := TBitmap.Create;
  {$IFDEF RVDEBUGTABLE}
  if Self is TRectPtblRVData then begin
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Width := 0;
    RVStyle.GraphicInterface.Rectangle(Canvas,
      GetPrintableAreaLeft, GetPrintableAreaTop,
      GetPrintableAreaLeft+TRectPtblRVData(Self).Width,
      GetPrintableAreaTop +TRectPtblRVData(Self).Height);
    end
  else begin
  { // Debug: drawing lines showing RVPrint.StartAt and EndAt
    if PgNo=1 then
      with Self as TCustomMainPtblRVData do  begin
        Canvas.Pen.Color := clRed;
        Canvas.Pen.Width := 0;
        Canvas.Pen.Style  := psDot;
        Canvas.MoveTo(LeftOffs-300, TmpTM+TmpTMPix+TPrintableRV(FRichView).FRVPrint.StartAt);
        Canvas.LineTo(300+GetWidth+LeftOffs-GetDevX(GetRightMargin), TmpTM+TmpTMPix+TPrintableRV(FRichView).FRVPrint.StartAt);
        Canvas.Pen.Style  := psSolid;
      end;
    if PgNo=(Self as TCustomMainPtblRVData).PagesColl.Count then
      with Self as TCustomMainPtblRVData do  begin
        Canvas.Pen.Color := clRed;
        Canvas.Pen.Width := 0;
        Canvas.Pen.Style  := psDot;
        Canvas.MoveTo(LeftOffs-300, TmpTM+TmpTMPix+TPrintableRV(FRichView).FRVPrint.EndAt);
        Canvas.LineTo(300+GetWidth+LeftOffs-GetDevX(GetRightMargin), TmpTM+TmpTMPix+TPrintableRV(FRichView).FRVPrint.EndAt);
        Canvas.Pen.Style  := psSolid;
      end
    }
  end;
  {$ENDIF}
  if Preview and (GetRVLogPalette<>nil) then
    tmpbmp.Palette := CreatePalette(GetRVLogPalette^);
  try
    part2 := part;
    //FloatingDrawItems := nil;
    //try
      for i:=first to last do begin
        dli := DrawItems[i];
        item := GetItem(dli.ItemNo);
        if (i=last) and (i<>first) and (dli is TRVMultiDrawItemInfo) and
            (TRVMultiDrawItemInfo(dli).PartsList.Count>0) then
          part := 0;
        if ((i=first) or
            ((dli.ItemNo<>DrawItems[i-1].ItemNo) and item.CanBeBorderStart)) and
           (item.StyleNo<>rvsBreak) then
          DrawParagraph(i);
        if part<>-1 then begin
          if i=first then
            zerocoord := GetTopCoord2(PgNo);
          part := -1;
        end;
      end;
    //finally
    //  FloatingDrawItems.Free;
    //end;
    zerocoord := GetTopCoord(PgNo);
    part := part2;
    for i:=first to last do begin
      dli := DrawItems[i];
      FDrawItem := dli;
      if dli.ItemNo<MinItemNo then
        continue;
      if dli.ItemNo>MaxItemNo then
        break;
      item := GetItem(dli.ItemNo);
      BiDiMode := GetParaBiDiMode(item.ParaNo);
      if (i=last) and (i<>first) and (dli is TRVMultiDrawItemInfo) and
          (TRVMultiDrawItemInfo(dli).PartsList.Count>0) then
        part := 0;
      if item.GetBoolValueEx(rvbpJump, RVStyle) then
        DoOnHyperlink(GetSourceRVDataForPrinting, dli.ItemNo,
          Bounds(dli.Left+LeftOffs, dli.Top-zerocoord, dli.Width, dli.Height));
      if (item.Checkpoint<>nil) and IsDrawItemItemStart(i) and (Part<=0) then begin
        if (Part>0) or ((Part=0)and(i=first)) then
          FItemTop := -zerocoord
        else
          FItemTop := dli.Top-zerocoord;
        DoOnCheckpoint(GetSourceRVDataForPrinting, dli.ItemNo,
          dli.Left+LeftOffs, FItemTop);
        if (rvoShowCheckpoints in Options) then
          RVStyle.DrawCheckpoint(Canvas, dli.Left+LeftOffs, FItemTop,
            LeftOffs, GetWidth, Self, dli.ItemNo,
            0, item.Checkpoint.RaiseEvent, nil);
      end;
      no := GetActualStyle(item);
      if no>=0 then begin{ text }
        RVStyle.ApplyStyleColor(Canvas, no, [], True, GetColorMode);
        RVStyle.ApplyStyle(Canvas, no, BiDiMode,
          TCustomPrintableRV(RichView).CanUseCustomPPI, nil, False, False);
        TextStyle := RVStyle.TextStyles[no];
        if TextStyle.BiDiMode=rvbdUnspecified then
          BidiMode2 := BiDiMode
        else
          BidiMode2 := TextStyle.BiDiMode;
        if BidiMode2=rvbdUnspecified then begin
          if TextStyle.CharSpacing<>0 then
            RVStyle.GraphicInterface.SetTextCharacterExtra(Canvas,
              RVStyle.GetAsDevicePixelsX(TextStyle.CharSpacing, @sad));
        end;
        if Assigned(RVStyle.OnDrawTextBack) then begin
          Dummy := True;
          RVStyle.OnDrawTextBack(RVStyle, Canvas, no, dli.Left+LeftOffs, dli.Top-zerocoord, dli.Width, dli.Height, [], Dummy);
        end;
        RVStyle.DrawStyleText(
          RV_ReturnProcessedString(DrawItems.GetString(i,Items), RVStyle.TextStyles[no],
            IsDrawItemLastOnWrappedLine(i), False, True),
          Canvas, dli.ItemNo, dli.Offs,  no, Self,
          dli.SpaceAtLeft,
          dli.Left+LeftOffs, dli.Top-zerocoord,
          dli.Width, dli.Height,
          {$IFDEF RVUSEBASELINE}dli.BaseLine{$ELSE}0{$ENDIF}-zerocoord,
          [], True, Preview and Correction, GetColorMode, BiDiMode, nil);
        end
      else begin // nontext
        if item.GetBoolValueEx(rvbpPrintToBMP, RVStyle) then begin
          if (Part>0) or ((Part=0) and (i=first)) then
            FItemTop := -zerocoord
          else
            FItemTop := dli.ObjectTop-zerocoord;
          if (Part>=0) then
            h := TRVMultiDrawItemInfo(dli).PartsList[Part].GetImageHeight
          else
            h := item.GetImageHeight(RVStyle);
          if item.GetBoolValue(rvbpFullWidth) then
            w := RV_XToScreen(GetWidth-GetDevX(GetRightMargin)-dli.Left, sad)
          else
            w  := item.GetImageWidth(RVStyle);
          tmpbmp.PixelFormat := pf32bit;
          tmpbmp.Width := w;
          tmpbmp.Height := h;
          DrawBackToTmpBmp(FItemTop);
          if item.PrintToBitmap(tmpbmp, Preview, FRichView, dli, Part, GetColorMode) then
            RV_PictureToDevice(Canvas,
              dli.ObjectLeft+LeftOffs+RVStyle.GetAsDevicePixelsX(item.GetBorderWidth, @sad),
              FItemTop + RVStyle.GetAsDevicePixelsY(item.GetBorderHeight, @sad),
              w, h, @sad, tmpbmp, Preview, RVStyle.GraphicInterface);
          end
        else begin
          if (Part>0) or ((Part=0) and (i=first)) then
            FItemTop := -zerocoord
          else
            FItemTop := dli.ObjectTop-zerocoord;
          if item.GetBoolValue(rvbpFullWidth) then
            item.Print(Canvas, dli.ObjectLeft+LeftOffs, FItemTop,
              LeftOffs+GetDevX(GetLeftMargin)+TextWidth, //GetWidth+LeftOffs-GetDevX(GetRightMargin),
              Preview, Correction, sad, nil, dli, part, GetColorMode, Self)
          else
            item.Print(Canvas, dli.ObjectLeft+LeftOffs, FItemTop,0,
              Preview, Correction, sad, nil, dli, part, GetColorMode, Self);
        end;
        if part<>-1 then begin
          if i=first then
            zerocoord := GetTopCoord2(PgNo);
          part := -1;
        end;
      end;
    end;
    {
     // Debug: drawing red line showing bottom of document
    if Self is TCustomMainPtblRVData then begin
      Canvas.Pen.Color := clRed;
      Canvas.MoveTo(LeftOffs, TCustomMultiPagePtblRVData(Self).Pages[pgNo-1].DocumentHeight+
        TCustomMainPtblRVData(Self).TmpTMPix+TCustomMainPtblRVData(Self).TmpM.Top);
      Canvas.LineTo(LeftOffs+100, TCustomMultiPagePtblRVData(Self).Pages[pgNo-1].DocumentHeight+
        TCustomMainPtblRVData(Self).TmpTMPix+TCustomMainPtblRVData(Self).TmpM.Top);
    end;
    }
    DoPagePostpaint(Canvas, pgNo, Preview,
      (last<0) or ((DrawItems[last].ItemNo>=MinItemNo) and (DrawItems[last].ItemNo<=MaxItemNo)));
    {$IFDEF RVWATERMARK}
    if rvflRoot in Flags then begin
      Canvas.Brush.Style := bsClear;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Size := 8;
      Canvas.Font.Style := [];
      Canvas.Font.Color := clRed;
      Canvas.TextOut(GetPrintableAreaLeft(PgNo), GetPrintableAreaTop, 'unregistered');
    end;
    {$ENDIF}
  finally
    FBackgroundBmp.Free;
    FBackgroundBmp := nil;
    FDrawItem := nil;
    tmpbmp.Free;
  end;
end;
{========================= TCustomMultiPagePtblRVData =========================}
destructor TCustomMultiPagePtblRVData.Destroy;
begin
  Pages.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.DoFormatting(PageCompleted: Integer;
  Step: TRVPrintingStep);
begin

end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.GetInitialStartAt: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.GetFurtherStartAt: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.SetEndAt(Value: Integer);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.IncEndAtByStartAt(PageNo: Integer);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.GetDrawItemsRange(PageNo: Integer;
  var StartNo, EndNo, Part: Integer);
begin
  if Pages=nil then begin
    inherited GetDrawItemsRange(PageNo, StartNo, EndNo, Part);
    exit;
  end;
  if PageNo>Pages.Count then begin
    StartNo := -1;
    EndNo := -1;
    exit;
  end;
  StartNo := Pages[PageNo-1].StartDrawItemNo;
  Part := Pages[PageNo-1].StartPart-1;
  //FirstOffs := TRVPageInfo(PagesColl.Items[PageNo-1]).FirstItemOff;
  if PageNo=Pages.Count then
    EndNo := DrawItems.Count-1
  else begin
    EndNo := Pages[PageNo].StartDrawItemNo-1;
    if Pages[PageNo].StartPart>1 then
      inc(EndNo);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.GetTopCoord(PageNo: Integer): Integer;
begin
  Result := Pages[PageNo-1].StartY;
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.GetTopCoord2(PageNo: Integer): Integer;
begin
  Result := Pages[PageNo-1].StartY2;
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.FormatNextPage(var i, StartAt, StartY, Y: Integer;
  var Splitting: Boolean; var MaxHeight: Integer;
  var FootnoteRVDataList: TRVFootnoteRefList; FootnotesChangeHeight: Boolean);
var dli :TRVDrawLineInfo;
    rvpi       : TRVPageInfo;
    nPages, EndAt: Integer;
    MustBreak: Boolean;
    pi: TParaInfo;
    SaD: TRVScreenAndDevice;
    RVStyle: TRVStyle;
    PageAdded: Boolean;
    {$IFNDEF RVDONOTUSESEQ}
    FootnoteRVData: TRVFootnotePtblRVData;
    {$ENDIF}
    {................................................}
    { Returns Y coordinate of bottom of the line ended on the LastDItemNo-th
      drawing item.
      The result is incremented by SpaceAfter of paragraph style.
      Floating items are taken into account. }
    function GetLineBottomCoord(LastDItemNo: Integer): Integer;
    var
      dli :TRVDrawLineInfo;
      pi: TParaInfo;
      i: Integer;
    begin
      if LastDItemNo<0 then begin
        Result := 0;
        exit;
      end;
      dli := DrawItems[LastDItemNo];
      pi := GetRVStyle.ParaStyles[GetItemPara(dli.ItemNo)];
      Result := dli.Top+dli.Height+dli.ExtraSpaceBelow;
      for i := LastDItemNo  downto 0 do begin
        dli := DrawItems[i];
        if dli.Top+dli.Height+dli.ExtraSpaceBelow>Result then
          Result := dli.Top+dli.Height+dli.ExtraSpaceBelow;
        if (dli is TRVFloatingDrawLineInfo) and
          (TRVFloatingDrawLineInfo(dli).FloatBottom>Result) then
          Result := TRVFloatingDrawLineInfo(dli).FloatBottom;
        if dli.FromNewLine and not dli.FloatingAboveUsed then
          break;
      end;
      inc(Result, RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD));
    end;
    {................................................}
    { Returns Y coordinate of top of the line started from FirstDItemNo-th
      drawing item.
      The result is decremented by SpaceBefore of paragraph style. }
    function GetLineTopCoord(FirstDItemNo: Integer): Integer;
    var
      dli :TRVDrawLineInfo;
      pi: TParaInfo;
      i: Integer;
    begin
      dli := DrawItems[FirstDItemNo];
      pi := GetRVStyle.ParaStyles[GetItemPara(dli.ItemNo)];
      Result := dli.Top-dli.ExtraSpaceAbove;
      for i := FirstDItemNo+1 to DrawItems.Count-1 do begin
        dli := DrawItems[i];
        if dli.FromNewLine then
          break;
        if dli.Top-dli.ExtraSpaceAbove<Result then
          Result := dli.Top-dli.ExtraSpaceAbove;
      end;
      dec(Result, RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD));
    end;
    {................................................}
    procedure ProcessEndAt;
    var rvpi: TRVPageInfo;
    begin
      rvpi := Pages[nPages-1];
      if rvpi.StartPart=0 then
        dec(EndAt,rvpi.StartY)
      else
        dec(EndAt,rvpi.StartY2);
      rvpi.DocumentHeight := EndAt{+TmpTMPix+TmpBMPix};
    end;
    {................................................}
    {
      function FindFirstItemOnPage.
      The main implicit hidden parameter of this function is i - index
      of the first drawitem that does not fit the page.
      This function goes from i downto 0 to find the first item that will
      start a new page (taking keep-with-next, keep-lines-together and
      floating pictures into account).

      If MultiItem, the i-th item is a table. For this table, a splitting
      may be initialized.
      For such tables, two options are possible.
       If this table cannot be splitted, OnlyIfExceedPage=False.
        Such tables are treated like other items, with the only exception:
        if i is not changed, this function does not add a page.
       If this table can be splitted, OnlyIfExceedPage=True.
        For such tables, we are interested only in floating pictures from
        the lines above, if these pictures exceed the page. If such pictures
        exist, the table is processed like if OnlyIfExceedPage=False.
      If i changed, a splitting unitialized for this table.

      Among other actions, this function undoes changes made for footnotes
      (for drawitems in range between old and new values of i, inclisive).
      If IgnoreLastFootnote=True, these changes were not made for the footnote
      corresponding to the i-th drawing item (old value of i),
      so they must not be undone for it.

      This function can be called for i = DrawItems.Count to check the document
      end. In this case, OnlyIfExceedPage=True.

      A new page is aded if:
      - (MultiItem=False or i is changed) and (new value of i <> DrawItems.Count) 
    }
    function FindFirstItemOnPage(MultiItem, IgnoreLastFootnote, OnlyIfExceedPage: Boolean;
      pi: TParaInfo): Boolean;
    var nextnewline, oldnexntewline, nextnewline2, j, k, tmp, oldi, oldi2,
        LastDItemOnTheFirstLineOfPage: Integer;
        LineUp: Boolean;
        {$IFNDEF RVDONOTUSESEQ}
        FootnoteRefIndex: Integer;
        {$ENDIF}
    begin
      oldi := i;
      if oldi<DrawItems.Count then
        oldi2 := oldi
      else
        oldi2 := oldi-1;
      LastDItemOnTheFirstLineOfPage := Pages.Items[nPages-1].StartDrawItemNo;
      for j := LastDItemOnTheFirstLineOfPage+1 to DrawItems.Count-1 do
        if DrawItems[j].FromNewLine then begin
          LastDItemOnTheFirstLineOfPage := j-1;
          break;
        end;
      { testing the previous line for floating pictures }
      if not OnlyIfExceedPage then begin
        LineUp := False;
        for j := i-1 downto j do begin
          if (DrawItems[j] is TRVFloatingDrawLineInfo) and
            (TRVFloatingDrawLineInfo(DrawItems[j]).FloatBottom > StartY+MaxHeight-StartAt) then
            LineUp := True;
          if DrawItems[j].FromNewLine then begin
            if LineUp and (j>Pages.Items[nPages-1].StartDrawItemNo) then
              i := j;
            break;
          end;
        end;
      end;
      { searching for the item which will be the first on the new page }
      nextnewline := i;
      while True do begin
        { checking keep-with-next and keep-lines-together }
        if not OnlyIfExceedPage then begin
          oldnexntewline := -1;
          while True do begin
            nextnewline2 := -1;
            for j:=nextnewline downto 0 do
              if DrawItems[j].FromNewLine then begin
                if nextnewline2<0 then
                  nextnewline2 := j;
                if not ((rvpaoKeepLinesTogether in pi.Options) or
                        (rvpaoKeepWithNext in pi.Options))
                   or IsDrawItemParaStart(j) then begin
                  nextnewline := j;
                  break;
                end;
              end;
            if (StartAt<=0) and (nextnewline2>=0) and
              (nextnewline <= Pages.Items[nPages-1].StartDrawItemNo) then begin
              if oldnexntewline>=0 then begin
                nextnewline := oldnexntewline;
                break;
              end;
              nextnewline := nextnewline2;
            end;
            if (StartAt<=0) and
               ((nextnewline <= Pages.Items[nPages-1].StartDrawItemNo) or (nextnewline<=0)) then
              break;
            if nextnewline=0 then
              break;
            pi := GetRVStyle.ParaStyles[GetItemPara(DrawItems[nextnewline-1].ItemNo)];
            if not IsDrawItemParaStart(nextnewline) or
               not (rvpaoKeepWithNext in pi.Options) or
               PageBreaksBeforeItems[DrawItems[nextnewline].ItemNo] then
              break;
            if oldnexntewline<0 then
              oldnexntewline := nextnewline;
            dec(nextnewline);
          end;
        end;
        { checking intersections with floating items }
        if nextnewline < DrawItems.Count then begin
          tmp := DrawItems[nextnewline].Top;
          k := nextnewline;
          for j := nextnewline+1 to DrawItems.Count-1 do begin
            if DrawItems[j].FromNewLine then
              break;
            if DrawItems[j].Top<tmp then begin
              tmp := DrawItems[j].Top;
              k := j;
            end;
          end;
          end
        else
          k := nextnewline;
        if OnlyIfExceedPage then
          j := StartY+MaxHeight-StartAt+1
        else
          j := 0;
        k := DrawItems.FindFirstFloatingAboveDrawItem(k,
          LastDItemOnTheFirstLineOfPage+1, j, OnlyIfExceedPage);
        if (k<0) or (k>=nextnewline) then
          break;
        OnlyIfExceedPage := False;
        nextnewline := k;
        if nextnewline=0 then
          break;
        pi := GetRVStyle.ParaStyles[GetItemPara(DrawItems[nextnewline-1].ItemNo)];
      end;
      { page must contain one line at least}
      if not OnlyIfExceedPage and ((StartAt<=0) or not AllowEmptyFirstPage) and
        (nextnewline <= Pages.Items[nPages-1].StartDrawItemNo) then begin
        tmp := nextnewline;
        nextnewline := DrawItems.Count;
        for j := tmp+1 to DrawItems.Count-1 do
          if DrawItems[j].FromNewLine then begin
            nextnewline := j;
            break;
          end;
        if (nextnewline<i) and not IsDrawItemParaStart(nextnewline) then
          for j := nextnewline+1 to i do
            if IsDrawItemParaStart(j) then begin
              nextnewline := j-1;
              break;
            end;
      end;
      {$IFNDEF RVDONOTUSESEQ}
      if (FootnoteRVDataList<>nil) and not IgnoreFootnotes then begin
        for j := oldi2 downto nextnewline do
          if (not IgnoreLastFootnote or (j<oldi)) then begin
            if (GetItem(DrawItems[j].ItemNo) is TRVFootnoteItemInfo) then begin
              FootnoteRefIndex := FootnoteRVDataList.GetFootnoteIndex(TRVFootnoteItemInfo(GetItem(DrawItems[j].ItemNo)));
              if FootnoteRefIndex>=0 then begin
                FootnoteRVDataList.Delete(FootnoteRefIndex);
                if FootnoteRVDataList.Count=0 then begin
                  FootnoteRVDataList.Free;
                  FootnoteRVDataList := nil;
                end;
              end;
            end;
            if DrawItems[j] is TRVMultiDrawItemInfo then
              if (oldi<>nextnewline) then begin
                TRVMultiDrawItemInfo(DrawItems[j]).ResetPages(FootnoteRVDataList,
                  MaxHeight, FootnotesChangeHeight);
              end;
              {
              else
                TRVMultiDrawItemInfo(DrawItems[j]).RemoveAllFootnotes(FootnoteRVDataList,
                  MaxHeight, FootnotesChangeHeight)};
            if FootnotesChangeHeight then
              MaxHeight := DrawItems[j].Top+(1)+StartAt-StartY;
          end;
        end
      else
      {$ENDIF}
      begin
        if (oldi<>nextnewline) then
          for j := oldi2 downto nextnewline do
            if DrawItems[j] is TRVMultiDrawItemInfo then
              TRVMultiDrawItemInfo(DrawItems[j]).ResetPages(FootnoteRVDataList,
                  MaxHeight, FootnotesChangeHeight);
      end;
      if (nextnewline<>DrawItems.Count) and ((nextnewline<>oldi) or not MultiItem) then begin
        { searching min y of first line in new page }
        StartY := GetLineTopCoord(nextnewline);
        rvpi             := Pages.Add;
        rvpi.StartDrawItemNo := nextnewline;
        rvpi.StartY      := StartY;
        PageAdded := True;
        {$IFNDEF RVDONOTUSESEQ}
        if not IgnoreFootnotes and (Self is TCustomMainPtblRVData) then begin
          Pages[Pages.Count-2].FootnoteRVDataList := FootnoteRVDataList;
          CalcFootnoteCoords(FootnoteRVDataList, nPages);
        end;
        {$ENDIF}
        StartAt := GetFurtherStartAt;
        EndAt := GetLineBottomCoord(nextnewline-1);
        Splitting := False;
        ProcessEndAt;
        if MultiItem then begin
          (DrawItems[oldi] as TRVMultiDrawItemInfo).PartsList.Clear;
          DoFormatting(nPages,rvpsProceeding);
        end;
      end;
      i := nextnewline;
      Result := i<>oldi;
    end;
    {................................................}
begin
  RVStyle := GetRVStyle;
  GetSADForFormatting(nil, SaD);
  if Pages.Count=0 then begin
    rvpi := Pages.Add;
    rvpi.StartY := 0;
    rvpi.StartDrawItemNo := 0;
    StartY := 0;
    i := 0;
    StartAt := GetInitialStartAt;
    Splitting := False;
  end;
  nPages := Pages.Count;
  PageAdded := False;
  if Splitting then begin
    inc(Y, MaxHeight);
    dli := DrawItems[i];
    pi := GetRVStyle.ParaStyles[GetItemPara(dli.ItemNo)];
    if dli.SplitAt(y, SaD, Pages[nPages-1].StartDrawItemNo=i,
      TList(FootnoteRVDataList), MaxHeight, FootnotesChangeHeight) then begin
      rvpi             := Pages.Add;
      rvpi.StartDrawItemNo := i;
      dli              := DrawItems[i];
      rvpi.StartY      := -RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD);
      rvpi.StartPart   := TRVMultiDrawItemInfo(dli).PartsList.Count;
      PageAdded := True;      
      {$IFNDEF RVDONOTUSESEQ}
      if not IgnoreFootnotes and (Self is TCustomMainPtblRVData) then begin
        Pages[nPages-1].FootnoteRVDataList := FootnoteRVDataList;
        CalcFootnoteCoords(FootnoteRVDataList, nPages);
      end;
      {$ENDIF}
      if Pages[nPages-1].StartDrawItemNo=i then begin
        Pages[nPages-1].StartY2 :=
          dli.Top+dli.Height-
           TRVMultiDrawItemInfo(dli).PartsList[TRVMultiDrawItemInfo(dli).PartsList.Count-2].Height-
           RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD);
        Pages[nPages-1].DocumentHeight :=
          TRVMultiDrawItemInfo(dli).PartsList[TRVMultiDrawItemInfo(dli).PartsList.Count-2].Height+
          RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD)+
          RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD)
        end
      else begin
        EndAt := dli.Top+
          TRVMultiDrawItemInfo(dli).PartsList[TRVMultiDrawItemInfo(dli).PartsList.Count-2].Height+
          RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD)+
          RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD);
        ProcessEndAt;
      end;
      DoFormatting(nPages, rvpsProceeding);
      StartAt := GetFurtherStartAt;
      StartY := 0;
      y := StartY{+MaxHeight}-StartAt+rvpi.StartY;
      dec(y, RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD));
      exit;
    end;
    if Pages[nPages-1].StartDrawItemNo=i then begin
      StartY := dli.Top+dli.Height-
        TRVMultiDrawItemInfo(dli).PartsList[TRVMultiDrawItemInfo(dli).PartsList.Count-1].Height-
        RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD);
      Pages[nPages-1].StartY2 := StartY;
    end;
    inc(i);
    Splitting := False;
  end;
  while i<DrawItems.Count do begin
    dli := DrawItems[i];
    pi := GetRVStyle.ParaStyles[GetItemPara(dli.ItemNo)];
    MustBreak := ((i>0) and (dli.ItemNo<>DrawItems[i-1].ItemNo) and
      GetItem(dli.ItemNo).PageBreakBefore and
      (Pages[nPages-1].StartDrawItemNo<>i));
    if (dli is TRVMultiDrawItemInfo) and dli.InitSplit(SaD) then begin
      if Pages[nPages-1].StartDrawItemNo=i then begin
        Pages[nPages-1].StartPart := 1;
        Pages[nPages-1].StartY := -RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD);
      end;
      y := StartY+MaxHeight-StartAt-dli.Top;
      dec(y, RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD));
      if MustBreak or //(y<=0) or
         ((Pages[nPages-1].StartDrawItemNo<>i) and
         not dli.CanSplitFirst(y, SaD, Pages[nPages-1].StartDrawItemNo=i,
           FootnoteRVDataList<>nil, FootnotesChangeHeight)) then begin
        { multipage item will not be placed on this page, it will start the next page }
        if not MustBreak and FindFirstItemOnPage(True, False, False, pi) then
          exit;
        rvpi := Pages.Add;
        rvpi.StartDrawItemNo := i;
        rvpi.StartY       := -RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @SaD);
        rvpi.StartPart    := 1;
        EndAt := GetLineBottomCoord(i-1);
        ProcessEndAt;
        DoFormatting(nPages, rvpsProceeding);
        StartY := 0;
        StartAt := GetFurtherStartAt;
        y := StartY{+MaxHeight}-StartAt+rvpi.StartY;
        dec(y, RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD));
        Splitting := True;
        PageAdded := True;        
        {$IFNDEF RVDONOTUSESEQ}
        if not IgnoreFootnotes and (Self is TCustomMainPtblRVData) then begin
          Pages[Pages.Count-2].FootnoteRVDataList := FootnoteRVDataList;
          CalcFootnoteCoords(FootnoteRVDataList, nPages);
        end;
        {$ENDIF}        
        exit;
      end;
      if FindFirstItemOnPage(True, False, True, pi) then
        exit;
      Splitting := True;
      dec(Y, MaxHeight);
      FormatNextPage(i, StartAt, StartY, Y, Splitting, MaxHeight,
        FootnoteRVDataList, FootnotesChangeHeight);
      exit;
    end;
    y := dli.Top+dli.Height+dli.ExtraSpaceBelow;
    if not MustBreak then begin
      inc(y, RVStyle.GetAsDevicePixelsY(pi.SpaceAfter, @SaD));
      {if (dli is TRVFloatingDrawLineInfo) then begin
        if (TRVFloatingDrawLineInfo(dli).FloatBottom>y) then
          y := TRVFloatingDrawLineInfo(dli).FloatBottom;
        //MustBreak := DrawItems.DoesFloatingExceedY(i, StartY+MaxHeight-StartAt, Items,
        //  GetRVStyle, @SaD);
      end;}
    end;
    if (y>StartY+MaxHeight-StartAt) or MustBreak then begin // i-th draw item does not fit in page, or mandatory break
      FindFirstItemOnPage(False, True, False, pi);
      break;
    end;
    {$IFNDEF RVDONOTUSESEQ}
    if not IgnoreFootnotes then begin
      if (GetItem(dli.ItemNo) is TRVFootnoteItemInfo) then begin
        FootnoteRVData := GetFootnoteRVData(TRVFootnoteItemInfo(GetItem(dli.ItemNo)));
        if (FootnoteRVDataList=nil) or
          (FootnoteRVDataList.GetFootnoteIndex(TRVFootnoteItemInfo(GetItem(dli.ItemNo)))<0) then begin
          if dli is TRVFootnoteDrawItem then begin
            TRVFootnoteDrawItem(dli).DocumentRVData := FootnoteRVData;
            FootnoteRVData.FootnoteItemRVData := Self;
            FootnoteRVData.FootnoteDItemNo := i;
          end;
          if FootnotesChangeHeight then
            dec(MaxHeight, FootnoteRVData.DocumentHeight);
          if FootnoteRVDataList=nil then begin
            FootnoteRVDataList := TRVFootnoteRefList.Create;
            if FootnotesChangeHeight then
              dec(MaxHeight, GetNoteSeparatorHeight);
          end;
          FootnoteRVDataList.Add(FootnoteRVData);
        end;
      end;
      if dli is TRVMultiDrawItemInfo then
        TRVMultiDrawItemInfo(dli).AddAllFootnotes(FootnoteRVDataList, MaxHeight,
          FootnotesChangeHeight);
      if y>StartY+MaxHeight-StartAt then begin // i-th draw item does not fit in page
        FindFirstItemOnPage(False, False, False, pi);
        break;
      end;
    end;
    {$ENDIF}
    inc(i);
  end;
  if not PageAdded then begin
    FindFirstItemOnPage(False, False, True, nil);  
    {$IFNDEF RVDONOTUSESEQ}
    if not IgnoreFootnotes and (Self is TCustomMainPtblRVData) then begin
      Pages[Pages.Count-1].FootnoteRVDataList := FootnoteRVDataList;
      CalcFootnoteCoords(FootnoteRVDataList, nPages);
    end;
    {$ENDIF}
    EndAt := GetLineBottomCoord(i-1);
    ProcessEndAt;
    SetEndAt(EndAt);
    IncEndAtByStartAt(nPages);
    DoFormatting(nPages,rvpsProceeding);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.CanPlaceFirstPageHere(var Height: Integer;
  ParentIsFirstItemOnPage: Boolean; const sad: TRVScreenAndDevice;
  ThisPageHasFootnotes, FootnotesChangeHeight: Boolean): Boolean;
var i, y, SpaceAfter: Integer;
    ParaStyle: TParaInfo;
    DrawItem: TRVDrawLineInfo;
    {........................................................}
    {$IFNDEF RVDONOTUSESEQ}
    procedure CheckFootnote(DItemNo: Integer);
    var FootnoteRVData: TRVFootnotePtblRVData;
    begin
      if IgnoreFootnotes then
        exit;
      if GetItem(DrawItems[DItemNo].ItemNo) is TRVFootnoteItemInfo then begin
        FootnoteRVData := GetFootnoteRVData(TRVFootnoteItemInfo(
          GetItem(DrawItems[DItemNo].ItemNo)));
        dec(Height, FootnoteRVData.DocumentHeight);
        if not ThisPageHasFootnotes then begin
          dec(Height, GetNoteSeparatorHeight);
          ThisPageHasFootnotes := True;
        end;
      end;
      if DrawItems[DItemNo] is TRVMultiDrawItemInfo then
        if TRVMultiDrawItemInfo(DrawItems[DItemNo]).InitSplit(sad) then
          TRVMultiDrawItemInfo(DrawItem).PartsList.Clear
        else
          TRVMultiDrawItemInfo(DrawItems[DItemNo]).DecHeightByFootnotes(Height,
            ThisPageHasFootnotes);
    end;
    {$ENDIF}
    {........................................................}
    function CanSplit(DItemNo: Integer): Boolean;
    begin
      DrawItem := DrawItems[DItemNo];
      if DrawItem is TRVMultiDrawItemInfo and
         TRVMultiDrawItemInfo(DrawItem).InitSplit(sad) then begin
        Result := TRVMultiDrawItemInfo(DrawItem).CanSplitFirst(
          Height-(DrawItem.Top+DrawItem.ExtraSpaceBelow+SpaceAfter), sad, False,
          ThisPageHasFootnotes, FootnotesChangeHeight);
        TRVMultiDrawItemInfo(DrawItem).PartsList.Clear;
        end
      else
        Result := False;
    end;
    {........................................................}
begin
  Result := True;

  // if no items, we can always place this RVData
  if DrawItems.Count=0 then
    exit;

  if ParentIsFirstItemOnPage then begin
    // If parent table is at the beginning of the page, we return True if
    // this RVData has more than 1 line
    { Actually, this function is never called with this parameter = True,
      because the printing procedure always attempts to split multipart items
      starting page }
    for i := 1 to DrawItems.Count-1 do
      if DrawItems[i].FromNewLine then
        exit;
    Result := False;
    exit;
  end;

  // Returning True if there is enough space for the first line ...
  // ... or for the first paragraph, if "KeepLinesTogether" is set;
  // ... or for several paragraphs, if "KeepWithNext" is set.
  Result := False;

  ParaStyle := GetRVStyle.ParaStyles[GetItemPara(0)];
  SpaceAfter := GetRVStyle.GetAsDevicePixelsY(ParaStyle.SpaceAfter, @sad);
  DrawItem := DrawItems[0];

  if CanSplit(0) then begin
    Result := True;
    exit;
  end;
  y := DrawItem.Top+DrawItem.Height+DrawItem.ExtraSpaceBelow+SpaceAfter;
  {$IFNDEF RVDONOTUSESEQ}
  if y>=Height then
    exit;
  if FootnotesChangeHeight then
    CheckFootnote(0);
  {$ENDIF}
  if y>=Height then
    exit;
  if (DrawItem is TRVFloatingDrawLineInfo) and
    (TRVFloatingDrawLineInfo(DrawItem).FloatBottom>=Height) then
    exit;

  for i := 1 to DrawItems.Count-1 do begin
    DrawItem := DrawItems[i];
    if DrawItem.FromNewLine then begin
      if IsDrawItemParaStart(i) then begin
        if not (rvpaoKeepWithNext in ParaStyle.Options) or
           PageBreaksBeforeItems[DrawItem.ItemNo] then
          break;
        ParaStyle := GetRVStyle.ParaStyles[GetItemPara(DrawItem.ItemNo)];
        SpaceAfter := GetRVStyle.GetAsDevicePixelsY(ParaStyle.SpaceAfter, @sad);
        end
      else
        if not ((rvpaoKeepLinesTogether in ParaStyle.Options) or
                (rvpaoKeepWithNext in ParaStyle.Options)) then
          break;
    end;
    if CanSplit(i) then
      break;
    y := DrawItem.Top+DrawItem.Height+DrawItem.ExtraSpaceBelow+SpaceAfter;
    {$IFNDEF RVDONOTUSESEQ}
    if y>=Height then
      exit;    
    if FootnotesChangeHeight then
      CheckFootnote(i);
    {$ENDIF}
    if y>=Height then
      exit;
    if (DrawItem is TRVFloatingDrawLineInfo) and
      (TRVFloatingDrawLineInfo(DrawItem).FloatBottom>=Height) then
      exit;
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
function TCustomMultiPagePtblRVData.SavePageAsRVF(Stream: TStream; PageNo: Integer;
  Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo): Boolean;
begin
  StreamSavePage := PageNo;
  try
    State := State + [rvstSavingPage];
    Result := SaveRVFToStreamEx(Stream, rvfss_Page, Color, Background, Layout, True)
  finally
    State := State - [rvstSavingPage];  
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.GetFirstItemOnPageEx(PageNo: Integer;
  var ItemNo, OffsetInItem, ExtraData: Integer);
var DItemNo, DItemOffs, Part: Integer;
begin
  DItemNo := Pages[PageNo-1].StartDrawItemNo;
  Part := Pages[PageNo-1].StartPart;
  if Part>0 then
    ExtraData := (DrawItems[DItemNo] as TRVMultiDrawItemInfo).PartsList[Part-1].
      GetSoftPageBreakInfo
  else
    ExtraData := -1;

  if GetItemStyle(DrawItems[DItemNo].ItemNo)<0 then
    DItemOffs := 0
  else
    DItemOffs := 1;

  DrawItem2Item(DItemNo, DItemOffs, ItemNo, OffsetInItem);
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.IsComplexSoftPageBreak(
  PageNo: Integer): Boolean;
var DItemNo, Part: Integer;
begin
  DItemNo := Pages[PageNo-1].StartDrawItemNo;
  Part := Pages[PageNo-1].StartPart;
  if Part>0 then
    Result := (DrawItems[DItemNo] as TRVMultiDrawItemInfo).PartsList[Part-1].
      IsComplexSoftPageBreak(TRVMultiDrawItemInfo(DrawItems[DItemNo]))
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.AssignComplexSoftPageBreakToItem(
  PageNo: Integer; RVData: TCustomRVFormattedData);
var DItemNo, Part: Integer;
begin
  DItemNo := Pages[PageNo-1].StartDrawItemNo;
  Part := Pages[PageNo-1].StartPart;
  if Part>0 then
    (DrawItems[DItemNo] as TRVMultiDrawItemInfo).
      PartsList[Part-1].AssignSoftPageBreaksToItem(
        TRVMultiDrawItemInfo(DrawItems[DItemNo]),
        RVData.GetRVData.GetItem(DrawItems[DItemNo].ItemNo))
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.GetPageNo(RVData: TCustomRVData;
  ItemNo, OffsetInItem: Integer; PrintSourceRVData: TCustomRVData): Integer;
var i, PageNo, StartItemNo, StartOffs: Integer;
begin
  // if RVData = main document
  if (PrintSourceRVData.GetRVData=RVData) or
     (PrintSourceRVData.GetSourceRVData=RVData) then begin
    if Pages=nil then begin
      Result := 1;
      exit;
    end;
    for PageNo := Pages.Count-1 downto 0 do begin
      StartItemNo := DrawItems[Pages[PageNo].StartDrawItemNo].ItemNo;
      if StartItemNo<ItemNo then begin
        Result := PageNo+1; // this page
        exit;
      end;
      if StartItemNo=ItemNo then begin
        StartOffs := DrawItems[Pages[PageNo].StartDrawItemNo].Offs;
        if StartOffs<=OffsetInItem then begin
          Result := PageNo+1; // this page
          exit;
        end;
      end;
    end;
  end;
  // may be RVData is contained in subitems?
  for i := 0 to DrawItems.Count-1 do
    if DrawItems[i] is TRVMultiDrawItemInfo then begin
      Result := TRVMultiDrawItemInfo(DrawItems[i]).GetPartNo(RVData,
        ItemNo, OffsetInItem);
      if Result>=0 then begin
        for PageNo := 0 to Pages.Count-1 do begin
          if Pages[PageNo].StartDrawItemNo=i then begin
            Result := PageNo+Result+1-(Pages[PageNo].StartPart-1); // prior page, or this page, or may be next, next next,...
            exit;
          end;
          if Pages[PageNo].StartDrawItemNo>i then begin
            Result := PageNo; // prior page
            exit;
          end;
        end;
        Result := Pages.Count; // last page
        exit;
      end;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
procedure TCustomMultiPagePtblRVData.RVFGetLimits(SaveScope: TRVFSaveScope;
  var StartItem, EndItem, StartOffs, EndOffs: Integer;
  var StartPart, EndPart: TRVMultiDrawItemPart;
  var SelectedItem: TCustomRVItemInfo);
var StartPartIndex, EndPartIndex: Integer;
begin
  if SaveScope=rvfss_Page then begin
    SelectedItem := nil;
    StartPartIndex := -1;
    EndPartIndex   := -1;
    GetDrawItemsRange(StreamSavePage, StartItem, EndItem, StartPartIndex);
    StartOffs := GetOffsBeforeDrawItem(StartItem);
    EndOffs   := GetOffsAfterDrawItem(EndItem);
    if (EndItem>StartItem) and
       (StreamSavePage<Pages.Count) and
       (Pages[StreamSavePage].StartPart>1) then
      EndPartIndex := 0;
    if StartPartIndex<0 then
      StartPart := nil
    else
      StartPart := (DrawItems[StartItem] as TRVMultiDrawItemInfo).PartsList[StartPartIndex];
    if EndPartIndex<0 then
      EndPart := nil
    else
      EndPart := (DrawItems[EndItem] as TRVMultiDrawItemInfo).PartsList[EndPartIndex];
    DrawItem2Item(StartItem, StartOffs, StartItem, StartOffs);
    DrawItem2Item(EndItem, EndOffs, EndItem, EndOffs);
    end
  else
    inherited RVFGetLimits(SaveScope, StartItem, EndItem, StartOffs, EndOffs,
                           StartPart, EndPart, SelectedItem);
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.PageExists(PageNo: Integer): Boolean;
begin
  if Pages=nil then
    Result := PageNo<=1
  else
    Result := PageNo<=Pages.Count;
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.AllowEmptyFirstPage: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TCustomMultiPagePtblRVData.GetFootnoteRVData(
  Footnote: TRVFootnoteItemInfo): TRVFootnotePtblRVData;
begin
  Result := TCustomPrintableRV((GetAbsoluteRootData as TCustomMainPtblRVData).
    FRichView).GetFootnoteRVData(Footnote);
end;
{------------------------------------------------------------------------------}
function TCustomMultiPagePtblRVData.GetNoteSeparatorHeight: Integer;
begin
  Result := TCustomPrintableRV((GetAbsoluteRootData as TCustomMainPtblRVData).
    FRichView).NoteSeparatorHeight;
end;
{$ENDIF}
{============================ TCustomMainPtblRVData ===========================}
constructor TCustomMainPtblRVData.Create(RichView: TRVScroller);
begin
  inherited;
  Pages := TRVPageCollection.Create;
  ColorMode := rvcmPrinterColor;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetSourceRVDataForPrinting: TCustomRVData;
begin
  Result := TCustomRichView(RichView).RVData;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetInitialStartAt: Integer;
begin
  Result := TPrintableRV(FRichView).RVPrint.StartAt;
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.SetEndAt(Value: Integer);
begin
  TPrintableRV(FRichView).RVPrint.EndAt := Value;
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.GetPrintableItemsRange(var MinItemNo, MaxItemNo: Integer);
begin
  MinItemNo := TPrintableRV(FRichView).RVPrint.MinPrintedItemNo;
  MaxItemNo := TPrintableRV(FRichView).RVPrint.MaxPrintedItemNo;
  if MaxItemNo<0 then
    MaxItemNo := ItemCount-1;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TCustomMainPtblRVData.DoPagePostpaint(Canvas: TCanvas; PageNo:Integer;
  Preview, InRange: Boolean);
var i, MinItemNo, MaxItemNo: Integer;
    FD: TRVFootnotePtblRVData;
begin
  if (PageNo<=Pages.Count) and (Pages[PageNo-1].FootnoteRVDataList<>nil) then begin
    GetPrintableItemsRange(MinItemNo, MaxItemNo);
    for i := 0 to Pages[PageNo-1].FootnoteRVDataList.Count-1 do begin
      FD := Pages[PageNo-1].FootnoteRVDataList[i];
      if (DrawItems[FD.FootnoteDItemNo].ItemNo>=MinItemNo) and
         (DrawItems[FD.FootnoteDItemNo].ItemNo<=MaxItemNo) then
        FD.DrawPage(1, Canvas, Preview,
          TRVPrint(TPrintableRV(FRichView).RVPrint).PreviewCorrection);
    end;
    FD := Pages[PageNo-1].FootnoteRVDataList[0];
    if (DrawItems[FD.FootnoteDItemNo].ItemNo>=MinItemNo) and
       (DrawItems[FD.FootnoteDItemNo].ItemNo<=MaxItemNo) then
      TPrintableRV(FRichView).DrawNoteSeparatorAbove(PageNo,
        FD.Top, Canvas, False);
    end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.IncEndAtByStartAt(PageNo: Integer);
begin
  if PageNo=1 then
    inc(TPrintableRV(FRichView).RVPrint.EndAt,
      TPrintableRV(FRichView).RVPrint.StartAt);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
function TCustomMainPtblRVData.GetPrevMarkers: TRVMarkerList;
begin
  if FPrevMarkers=nil then
    FPrevMarkers := TRVMarkerList.Create;
  Result := FPrevMarkers;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.Clear;
{$IFNDEF RVDONOTUSELISTS}
var i: Integer;
{$ENDIF}
begin
  inherited;
  {$IFNDEF RVDONOTUSELISTS}
  if FPrevMarkers<>nil then begin
    for i := 0 to FPrevMarkers.Count-1 do
      TRVMarkerItemInfo(FPrevMarkers.Items[i]).Free;
    FPrevMarkers.Free;
    FPrevMarkers := nil;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetFirstItemMarker(var ListNo,
  Level: Integer): Boolean;
begin
  if (rvstFirstParaAborted in State) then begin
    ListNo := FFirstParaListNo;
    Level  := FFirstParaLevel;
    Result := ListNo>=0;
    end
  else
    Result := inherited GetFirstItemMarker(ListNo, Level);
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetColor: TColor;
begin
  if Transparent then
    Result := clNone
  else
    Result := inherited GetColor;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetPageHeight: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetPageWidth: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.DrawPage(pgNo: Integer; Canvas: TCanvas;
  Preview, Correction: Boolean);
begin
  if pgNo>0 then
    inherited
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.InitFormatPages;
begin
   DoFormatting(0, rvpsStarting);
   PrinterCanvas := InitPrinterCanvas;
   FIsDestinationReady := PrinterCanvas<>nil;
   if FIsDestinationReady then begin
     Prepare;
     TCustomRichView(FRichView).MaxTextWidth :=
       RV_XToScreen(FRichView.Width, PrnSaD)-GetLeftMargin-GetRightMargin;
     Format_(False, True, False, 0, PrinterCanvas, False, False, False, False);
     end
   else
     ClearTemporal;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.FormatPages: Integer;
var i, StartAt, StartY,y: Integer;
    Splitting: Boolean;
    MaxHeight: Integer;
    FootnoteRVDataList: TRVFootnoteRefList;
begin
   Pages.Clear;
   Result := 0;
   if DrawItems.Count = 0 then exit;
   DoFormatting(0, rvpsProceeding);
   i := 0;
   while i<DrawItems.Count do begin
     FootnoteRVDataList := nil;
     MaxHeight := FRichView.Height - (TmpTMPix+TmpBMPix);     
     FormatNextPage(i, StartAt, StartY, Y, Splitting, MaxHeight,
       FootnoteRVDataList, True);
   end;
   Result := Pages.Count;
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.FinalizeFormatPages;
begin
  DonePrinterCanvas(PrinterCanvas);
  PrinterCanvas := nil;
  DoFormatting(Pages.Count, rvpsFinished);
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetCanvas: TCanvas;
begin
  Result := PrinterCanvas;
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.DoFormatting(PageCompleted: Integer; Step: TRVPrintingStep);
begin
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetPrintableAreaLeft(PageNo: Integer): Integer;
begin
  Result := TmpM.Left;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetPrintableAreaTop: Integer;
begin
  Result := TmpM.Top;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetBack: TRVBackground;
begin
  Result := TCustomRichView(FRichView).Background;
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetTopCoord(PageNo: Integer): Integer;
begin
  Result := Pages[PageNo-1].StartY-TmpM.Top-TmpTMPix;
  if PageNo=1 then
    dec(Result,TPrintableRV(FRichView).RVPrint.StartAt);
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetTopCoord2(PageNo: Integer): Integer;
begin
  Result := Pages[PageNo-1].StartY2-TmpM.Top-TmpTMPix;
  if PageNo=1 then
    dec(Result,TPrintableRV(FRichView).RVPrint.StartAt);
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.GetSADForFormatting(Canvas: TCanvas;
  var sad: TRVScreenAndDevice);
begin
  sad := PrnSaD;
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.CheckPageNo(PageNo: Integer);
begin
  if (PageNo<1) or (PageNo>Pages.Count) then
    raise ERichViewError.Create(errInvalidPageNo);
end;
{------------------------------------------------------------------------------}
procedure TCustomMainPtblRVData.Prepare;
begin
  RV_InfoAboutSaD(PrnSaD, PrinterCanvas, GetRVStyle.GraphicInterface);
  if RichViewPixelsPerInch<>0 then begin
    PrnSaD.ppixScreen := RichViewPixelsPerInch;
    PrnSaD.ppiyScreen := RichViewPixelsPerInch;
  end;
  GetSADForFormatting(PrinterCanvas, PrnSad);
  TmpTMPix := RV_YToDevice(FTopMarginPix, PrnSaD);
  TmpBMPix := RV_YToDevice(FBottomMarginPix, PrnSaD);
end;
{------------------------------------------------------------------------------}
function TCustomMainPtblRVData.GetColorMode: TRVColorMode;
begin
  Result := ColorMode;
end;
{============================== TPrintableRVData ==============================}
constructor TPrintableRVData.Create(RichView: TRVScroller);
begin
  inherited Create(RichView);
  HeaderY := 10;
  FooterY := 10;
end;
{------------------------------------------------------------------------------}
destructor TPrintableRVData.Destroy;
begin
  Footer.Free;
  Header.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TPrintableRVData.DoPagePrepaint(Canvas: TCanvas; PageNo:Integer;
  Preview, Correction, InRange: Boolean);
var r: TRect;
begin
  r := Bounds(GetPrintableAreaLeft(PageNo), GetPrintableAreaTop,GetWidth,GetHeight);
  if Assigned(TRVPrint(TPrintableRV(FRichView).RVPrint).OnPagePrepaint) then
    TRVPrint(TPrintableRV(FRichView).RVPrint).OnPagePrepaint(
      TRVPrint(TPrintableRV(FRichView).RVPrint), PageNo, Canvas, Preview,
        Rect(0, 0, TmpM.Left+TmpM.Right+GetWidth, TmpM.Top+TmpM.Bottom+GetHeight),
        r
      );

  if InRange and (Header<>nil) then begin
    Header.Left := GetPrintableAreaLeft(PageNo);
    Header.DrawPage(1, Canvas, Preview, Correction);
  end;
  if InRange and (Footer<>nil) then begin
    Footer.Left := GetPrintableAreaLeft(PageNo);
    Footer.DrawPage(1, Canvas, Preview, Correction);
  end;
  if TRVPrint(TPrintableRV(FRichView).RVPrint).ClipMargins then
    TPrintableRV(FRichView).Style.GraphicInterface.IntersectClipRectEx(Canvas,
      r.Left, r.Top, r.Right, r.Bottom, Rgn, RgnValid);
end;
{------------------------------------------------------------------------------}
procedure TPrintableRVData.DoPagePostpaint(Canvas: TCanvas; PageNo:Integer;
  Preview, InRange: Boolean);
var r: TRect;
begin
  if TRVPrint(TPrintableRV(FRichView).RVPrint).ClipMargins then
    TPrintableRV(FRichView).Style.GraphicInterface.RestoreClipRgn(Canvas, Rgn, RgnValid);
  try
    inherited;
  finally
    if InRange then begin
      r := Bounds(GetPrintableAreaLeft(PageNo), GetPrintableAreaTop,GetWidth,GetHeight);
      if Assigned(TRVPrint(TPrintableRV(FRichView).RVPrint).OnPagePostpaint) then
        TRVPrint(TPrintableRV(FRichView).RVPrint).OnPagePostpaint(
          TRVPrint(TPrintableRV(FRichView).RVPrint), PageNo, Canvas, Preview,
            Rect(0, 0, TmpM.Left+TmpM.Right+GetWidth, TmpM.Top+TmpM.Bottom+GetHeight),
            r
          );
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TPrintableRVData.InitPrinterCanvas: TCanvas;
begin
  if GetRVStyle=nil then
    Result := nil
  else
    Result := GetRVStyle.GraphicInterface.CreatePrinterCanvas;
end;
{------------------------------------------------------------------------------}
procedure TPrintableRVData.DonePrinterCanvas(Canvas: TCanvas);
begin
  if GetRVStyle<>nil then
    GetRVStyle.GraphicInterface.DestroyCompatibleCanvas(Canvas);
end;
{------------------------------------------------------------------------------}
procedure TPrintableRVData.DoFormatting(PageCompleted: Integer;
  Step: TRVPrintingStep);
begin
  if Assigned(TRVPrint(TPrintableRV(FRichView).RVPrint).OnFormatting) then
    TRVPrint(TPrintableRV(FRichView).RVPrint).OnFormatting(TPrintableRV(FRichView), PageCompleted, Step);
end;
{------------------------------------------------------------------------------}
function TPrintableRVData.GetPrintableAreaLeft(PageNo: Integer): Integer;
begin
  if not TPrintableRV(FRichView).FMirrorMargins or ((PageNo mod 2)=1) then
    Result := TmpM.Left
  else
    Result := TmpLMMir;
end;
{------------------------------------------------------------------------------}
function TPrintableRVData.GetPageHeight: Integer;
begin
  Result := Printer.PageHeight;
end;
{------------------------------------------------------------------------------}
function TPrintableRVData.GetPageWidth: Integer;
begin
  Result := Printer.PageWidth;
end;
{------------------------------------------------------------------------------}
procedure TPrintableRVData.Prepare;
var lpy, lpx, footeroffs: Integer;
    GraphicInterface: TRVGraphicInterface;
begin
  inherited Prepare;


  PrinterCanvas.Font.PixelsPerInch := PrnSaD.ppiyDevice;

  GraphicInterface := GetRVStyle.GraphicInterface;

  lpy := GraphicInterface.GetDeviceCaps(PrinterCanvas, LOGPIXELSY);
  lpx := GraphicInterface.GetDeviceCaps(PrinterCanvas, LOGPIXELSX);

  PhysM.Left := GraphicInterface.GetDeviceCaps(PrinterCanvas, PHYSICALOFFSETX);
  PhysM.Top  := GraphicInterface.GetDeviceCaps(PrinterCanvas, PHYSICALOFFSETY);
  PhysM.Right  := GraphicInterface.GetDeviceCaps(PrinterCanvas, PHYSICALWIDTH) -(PhysM.Left+GetPageWidth);
  PhysM.Bottom := GraphicInterface.GetDeviceCaps(PrinterCanvas, PHYSICALHEIGHT)-(PhysM.Top+GetPageHeight);

  {
  if phW>phoX+GetPageWidth then
    phW := phoX+GetPageWidth;
  if phH>phoY+GetPageHeight then
    phH := phoY+GetPageHeight;
  }

  with TPrintableRV(FRichView) do begin
    TmpM.Left   := MulDiv(FLeftMarginMM,   5*lpx, 127)- PhysM.Left;
    TmpM.Top    := MulDiv(FTopMarginMM,    5*lpy, 127)- PhysM.Top;
    TmpM.Right  := MulDiv(FRightMarginMM,  5*lpx, 127)- PhysM.Right;
    TmpM.Bottom := MulDiv(FBottomMarginMM, 5*lpy, 127)- PhysM.Bottom;
    TmpLMMir    := MulDiv(FRightMarginMM,  5*lpx, 127)- PhysM.Left;
  end;

  if (TPrintableRV(FRichView).RVPrint as TRVPrint).FixMarginsMode=rvfmmAutoCorrect then begin
    if TmpM.Left<0 then begin
      inc(TmpM.Right, TmpM.Left);
      TmpM.Left := 0;
    end;
    if TmpM.Top<0 then begin
      inc(TmpM.Bottom, TmpM.Top);
      TmpM.Top := 0;
    end;
    if TmpM.Right<0 then
      TmpM.Right := 0;
    if TmpM.Bottom<0 then
      TmpM.Bottom := 0;
    if TmpLMMir<0 then
      TmpLMMir := 0;
  end;

  if Header<>nil then begin
    Header.Left := TmpM.Left;
    Header.Width := GetPageWidth - (TmpM.Left+TmpM.Right);
    Header.Top := MulDiv(HeaderY,  5*lpy, 127)- PhysM.Top;
    if Header.Top<0 then
      Header.Top := 0;
    Header.Height := 1;
    Header.Format(True);
    if TmpM.Top<Header.Top+Header.DocumentHeight then
      TmpM.Top := Header.Top+Header.DocumentHeight;
  end;

  if Footer<>nil then begin
    Footer.Left := TmpM.Left;
    Footer.Width := GetPageWidth - (TmpM.Left+TmpM.Right);
    Footer.Top := 0;
    Footer.Height := 1;
    Footer.Format(True);
    footeroffs := MulDiv(FooterY,  5*lpy, 127)-PhysM.Bottom+Footer.DocumentHeight;
    Footer.Top := GetPageHeight-footeroffs;
    if TmpM.Bottom<footeroffs then
      TmpM.Bottom := footeroffs;
  end;

  State := State+[rvstSkipformatting];
  try
    FRichView.Width := GetPageWidth - (TmpM.Left+TmpM.Right);
    FRichView.Height:= GetPageHeight - (TmpM.Top+TmpM.Bottom);
    TCustomRichView(FRichView).VScrollVisible := False;
    TCustomRichView(FRichView).HScrollVisible := False;
  finally
    State := State-[rvstSkipformatting];
  end;
end;
{================================ TRectPtblRVData =============================}
constructor TRectPtblRVData.Create(RichView: TRVScroller;
  SourceDataForPrinting: TCustomRVData;
  ParentPrintData: TCustomPrintableRVData);
begin
  inherited Create(RichView);
  FSourceDataForPrinting := SourceDataForPrinting;
  FParentPrintData := ParentPrintData;
  ShareItemsFrom(SourceDataForPrinting);
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetPrintableAreaLeft(PageNo: Integer): Integer;
begin
  Result := Left+DX;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetPrintableAreaTop: Integer;
begin
  Result := Top+DY;
end;
{------------------------------------------------------------------------------}
procedure TRectPtblRVData.GetSADForFormatting(Canvas: TCanvas; var sad: TRVScreenAndDevice);
begin
  sad := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).PrnSaD;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetTopCoord(PageNo: Integer): Integer;
begin
  Result := -(Top+DY);
  if Pages<>nil then
    inc(Result, inherited GetTopCoord(PageNo));
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetTopCoord2(PageNo: Integer): Integer;
begin
  Result := -(Top+DY);
  if Pages<>nil then
    inc(Result, inherited GetTopCoord2(PageNo));
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetWidth: Integer;
begin
  Result := Width;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetHeight: Integer;
begin
  Result := Height;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.InitPrinterCanvas: TCanvas;
begin
  Result := GetCanvas;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetColorMode: TRVColorMode;
begin
  Result := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).ColorMode;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetCanvas: TCanvas;
begin
  Result := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).PrinterCanvas;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetColor: TColor;
begin
  Result := FColor;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetBottomMargin: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetLeftMargin: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetRightMargin: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetTopMargin: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRectPtblRVData.DoOnHyperlink(RVData: TCustomRVData;
  ItemNo: Integer; const R: TRect);
begin
  FParentPrintData.DoOnHyperlink(RVData, ItemNo, R);
end;
{------------------------------------------------------------------------------}
procedure TRectPtblRVData.DoOnCheckpoint(RVData: TCustomRVData;
  ItemNo, X, Y: Integer);
begin
  FParentPrintData.DoOnCheckpoint(RVData, ItemNo, X, Y);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TRectPtblRVData.IgnoreFootnotes: Boolean;
begin
  Result := FParentPrintData.IgnoreFootnotes;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetSourceRVDataForPrinting: TCustomRVData;
begin
  Result := FSourceDataForPrinting;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetParentData: TCustomRVData;
begin
  Result := FParentPrintData; // TCustomRichView(FRichView).RVData;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetRootData: TCustomRVData;
begin
  Result := GetParentData.GetRootData;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetAbsoluteParentData: TCustomRVData;
begin
  Result := FParentPrintData;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetAbsoluteRootData: TCustomRVData;
begin
  Result := GetAbsoluteParentData.GetRootData;
end;
{------------------------------------------------------------------------------}
procedure TRectPtblRVData.DrawBackToBitmap(Left, Top: Integer;
  bmp: TBitmap; const sad: TRVScreenAndDevice; ItemBackgroundLayer: Integer;
  RelativeToItem: Boolean);
var r, r2: TRect;
    l,t: Integer;
    pi: TParaInfo;
    item: TCustomRVItemInfo;
begin
  if RelativeToItem then begin
    inc(Left, RV_XToScreen(FDrawItem.Left, sad));
    inc(Top, RV_YToScreen(FItemTop-GetPrintableAreaTop, sad));
  end;
  item := GetItem(FDrawItem.ItemNo);
  pi := GetRVStyle.ParaStyles[item.ParaNo];
  r := Rect(0,0, bmp.Width, bmp.Height);
  if pi.Background.Color<>clNone then begin
    bmp.Canvas.Brush.Color := pi.Background.Color;
    GetRVStyle.GraphicInterface.FillRect(bmp.Canvas, r);
    end
  else if Transparent then begin
    l := Left+
      RV_XToScreen(GetPrintableAreaLeft(FPageNo)-
        FParentPrintData.GetPrintableAreaLeft(FParentPrintData.FPageNo), sad);
    t := Top+
      RV_YToScreen(GetPrintableAreaTop-FParentPrintData.GetPrintableAreaTop, sad);
    FParentPrintData.DrawBackToBitmap(l, t, bmp, sad, -1, False);
    end
  else
    inherited;
  if ItemBackgroundLayer<>0 then begin
    r2 := Bounds(RV_XToScreen(FDrawItem.Left, sad)-Left,
      RV_YToScreen(FItemTop-GetPrintableAreaTop, sad)-Top,
      RV_XToScreen(FDrawItem.Width,sad),
      RV_YToScreen(FDrawItem.Height,sad));
    GetItem(FDrawItem.ItemNo).DrawBackgroundForPrinting(bmp.Canvas, r, r2,
      GetColorMode, ItemBackgroundLayer, GetRVStyle.GraphicInterface);
  end;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetMaxTextWidth: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetMinTextWidth: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRectPtblRVData.CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas);
begin

end;
{------------------------------------------------------------------------------}
procedure TRectPtblRVData.DestroyFontInfoCache(var Cache: TRVFontInfoCache);
begin
  if (Cache<>nil) and (Cache.Owner=Self) then begin
    if Cache=FFontInfoCache then
      FFontInfoCache := nil;
    Cache.Free;
    Cache := nil;
  end;
end;
{------------------------------------------------------------------------------}
function TRectPtblRVData.GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
      RVData: TCustomRVFormattedData): TRVFontInfoCache;
begin
  Result := FParentPrintData.GetFontInfoCache(ACanvas, AFormatCanvas, RVData);
end;
{========================= TRVHeaderFooterRVData ==============================}
constructor TRVHeaderFooterRVData.Create(RichView: TRVScroller;
  SourceDataForPrinting: TCustomRVData;
  ParentPrintData: TCustomPrintableRVData);
begin
  inherited;
  FColor := clNone;
end;
{------------------------------------------------------------------------------}
procedure TRVHeaderFooterRVData.CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas);
begin
  FFontInfoCache.Free;
  FFontInfoCache := DoCreateFontInfoCache(ACanvas, AFormatCanvas, Self);
end;
{------------------------------------------------------------------------------}
function TRVHeaderFooterRVData.GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
  RVData: TCustomRVFormattedData): TRVFontInfoCache;
begin
  Result := FFontInfoCache;
  if Result = nil then
    Result := DoCreateFontInfoCache(ACanvas, AFormatCanvas, RVData);
end;
{------------------------------------------------------------------------------}
function TRVHeaderFooterRVData.GetBottomMargin: Integer;
begin
  Result := FBottomMargin;
end;
{------------------------------------------------------------------------------}
function TRVHeaderFooterRVData.GetLeftMargin: Integer;
begin
  Result := FLeftMargin;
end;
{------------------------------------------------------------------------------}
function TRVHeaderFooterRVData.GetRightMargin: Integer;
begin
  Result := FRightMargin;
end;
{------------------------------------------------------------------------------}
function TRVHeaderFooterRVData.GetTopMargin: Integer;
begin
  Result := FTopMargin;
end;
{------------------------------------------------------------------------------}
function TRVHeaderFooterRVData.GetRVStyle: TRVStyle;
begin
  Result := FSourceDataForPrinting.GetRVStyle;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TRVHeaderFooterRVData.IgnoreFootnotes: Boolean;
begin
  Result := True;
end;
{$ENDIF}
{========================== TRVEndnotePtblRVData ==============================}
{$IFNDEF RVDONOTUSESEQ}
constructor TRVEndnotePtblRVData.Create(RichView: TRVScroller);
begin
  inherited Create(RichView);
  Pages := TRVPageCollection.Create;
  ParentDrawsBack := True;
end;
(*
procedure TRVEndnotePtblRVData.CreateFontInfoCache(ACanvas: TCanvas);
begin
  inherited;

end;
{------------------------------------------------------------------------------}
procedure TRVEndnotePtblRVData.DestroyFontInfoCache(
  var Cache: TRVFontInfoCache);
begin
  inherited;

end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetFontInfoCache(ACanvas: TCanvas;
  RVData: TCustomRVFormattedData): TRVFontInfoCache;
begin

end;
*)
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetParentData: TCustomRVData;
begin
  Result := TPrintableRV(FRichView).RVData;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetRootData: TCustomRVData;
begin
  Result := TPrintableRV(FRichView).RVData;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetAbsoluteParentData: TCustomRVData;
begin
  Result := TPrintableRV(FRichView).RVData;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetAbsoluteRootData: TCustomRVData;
begin
  Result := TPrintableRV(FRichView).RVData;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetSourceRVDataForPrinting: TCustomRVData;
begin
  Result := Endnote.Document;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetInitialStartAt: Integer;
begin
  Result := StartAt;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetFurtherStartAt: Integer;
begin
  Result := NextStartAt;
end;
{------------------------------------------------------------------------------}
procedure TRVEndnotePtblRVData.IncEndAtByStartAt(PageNo: Integer);
begin
  if PageNo=1 then
    inc(EndAt, StartAt)
  else
    inc(EndAt, NextStartAt)  
end;
{------------------------------------------------------------------------------}
procedure TRVEndnotePtblRVData.SetEndAt(Value: Integer);
begin
  EndAt := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVEndnotePtblRVData.GetSADForFormatting(Canvas: TCanvas;
  var sad: TRVScreenAndDevice);
begin
  sad := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).PrnSaD;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetCanvas: TCanvas;
begin
  Result := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).PrinterCanvas;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetDocProperties: TStringList;
begin
  Result := nil;
end;
function TRVEndnotePtblRVData.GetTopCoord(PageNo: Integer): Integer;
begin
  Result := Pages[PageNo-1].StartY-
    TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).TmpM.Top-
    TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).TmpTMPix;
  if PageNo=1 then
    dec(Result,StartAt)
  else
    dec(Result,NextStartAt)
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetTopCoord2(PageNo: Integer): Integer;
begin
  Result := Pages[PageNo-1].StartY2-
    TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).TmpM.Top-
    TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).TmpTMPix;
  if PageNo=1 then
    dec(Result,StartAt)
  else
    dec(Result,NextStartAt)
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.AllowEmptyFirstPage: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetPrintableAreaLeft(
  PageNo: Integer): Integer;
begin
  Result := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).
    GetPrintableAreaLeft(PageNo);
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.GetPrintableAreaTop: Integer;
begin
  Result := TCustomMainPtblRVData(TPrintableRV(FRichView).RVData).
    GetPrintableAreaTop;
end;
{------------------------------------------------------------------------------}
function TRVEndnotePtblRVData.IgnoreFootnotes: Boolean;
begin
  Result := True;
end;
{======================= TRVFootnotePtblRVData ================================}
function TRVFootnotePtblRVData.IgnoreFootnotes: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVFootnotePtblRVData.AdjustFootnoteRefWidths;
var i: Integer;
begin
  // !!! not implemented: adjusting widths in tables
  for i := 0 to DrawItems.Count-1 do begin
    if GetItem(DrawItems[i].ItemNo) is TRVNoteReferenceItemInfo then
      ChangeDItemWidth(i, TRVNoteReferenceItemInfo(GetItem(DrawItems[i].ItemNo)).
        GetFinalPrintingWidth(GetCanvas, DrawItems[i], Self))
  end;
end;
{=========================== TRVFootnoteRefList ===============================}
procedure TRVFootnoteRefList.DeleteByFootnote(
  Footnote: TRVFootnoteItemInfo);
var i: Integer;
begin
  for i := Count-1 downto 0 do
    if Items[i].Footnote=Footnote then begin
      Delete(i);
      exit;
    end;
end;
{------------------------------------------------------------------------------}
function CompareFootnoteRVData(Item1, Item2: Pointer): Integer;
begin
  Result := TRVFootnotePtblRVData(Item1).Footnote.Counter-
    TRVFootnotePtblRVData(Item2).Footnote.Counter;
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteRefList.Sort;
begin
  inherited Sort(CompareFootnoteRVData);
end;
{------------------------------------------------------------------------------}
function TRVFootnoteRefList.GetFootnoteIndex(Footnote: TRVFootnoteItemInfo): Integer;
var i: Integer;
begin
  for i := Count-1 downto 0 do
    if Items[i].Footnote=Footnote then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
function TRVFootnoteRefList.Get(Index: Integer): TRVFootnotePtblRVData;
begin
  Result := TRVFootnotePtblRVData(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteRefList.Put(Index: Integer;
  const Value: TRVFootnotePtblRVData);
begin
  inherited Put(Index, Value);
end;
{$ENDIF}


end.
