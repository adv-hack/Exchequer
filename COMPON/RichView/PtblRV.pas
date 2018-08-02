
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TCustomRVPrint: ancestor of TRVPrint and        }
{       TRVReportHelper.                                }
{       TRVPrint: component for printing                }
{       RichView.                                       }
{       (registered on "RichView" page of               }
{       the Component Palette)                          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit PtblRV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RVScroll, RichView, RVItem, RVStyle, Printers, CommDlg, DLines, RVFuncs,
  CRVData, CRVFData, RVRVData, PtRVData,
  {$IFNDEF RVDONOTUSESEQ}
  RVNote,
  {$ENDIF}
  {$IFNDEF RVDONOTUSEDOCPARAMS}
  RVDocParams,
  {$ENDIF}
  RVClasses;

{$I RV_Defs.inc}

type
  TCustomRVPrint = class;
  TRVPrint = class;
  {------------------------------------------------------------}
  TRVPrintComponentEvent = procedure (Sender: TCustomRVPrint; PrintMe: TControl;
    var ComponentImage: TBitmap) of object;

  TRVPrintingEvent = procedure (Sender: TCustomRichView; PageCompleted: Integer;
    Step:TRVPrintingStep) of object;

  TRVPagePrepaintEvent = procedure (Sender: TRVPrint; PageNo: Integer;
    Canvas: TCanvas; Preview: Boolean; PageRect, PrintAreaRect: TRect) of object;
  {------------------------------------------------------------}
  TRVFixMarginsMode = (rvfmmAutoCorrect, rvfmmIgnore);
  {------------------------------------------------------------}
  {$IFNDEF RVDONOTUSESEQ}
  TRVEndnotePage = class
    public
      Index, Page: Integer;
  end;

  TRVEndnotePageList = class(TRVList)
  private
    function GetItems(Index: Integer): TRVEndnotePage;
    procedure SetItems(Index: Integer; const Value: TRVEndnotePage);
    public
      property Items[Index: Integer]: TRVEndnotePage read GetItems write SetItems; default;
  end;

  TRVEndnoteList = class (TRVList)
    private
      FOwner: TCustomRVPrint;
      Pages: TRVEndnotePageList;
      function GetItems(Index: Integer): TRVEndnotePtblRVData;
      procedure SetItems(Index: Integer; const Value: TRVEndnotePtblRVData);
    public
      constructor Create(AOwner: TCustomRVPrint);
      destructor Destroy; override;
      procedure DrawPage(RealPageNo, PageNo: Integer; Canvas: TCanvas;
        Preview, Correction: Boolean);
      property Items[Index: Integer]: TRVEndnotePtblRVData read GetItems write SetItems; default;
  end;

  TRVFootnoteList = class (TRVList)
    private
      FOwner: TCustomRVPrint;
      function GetItems(Index: Integer): TRVFootnotePtblRVData;
      procedure SetItems(Index: Integer; const Value: TRVFootnotePtblRVData);
    public
      constructor Create(AOwner: TCustomRVPrint);
      procedure SortByFootnotes;
      function FindByFootnote(Footnote: TRVFootnoteItemInfo): TRVFootnotePtblRVData;
      property Items[Index: Integer]: TRVFootnotePtblRVData read GetItems write SetItems; default;
  end;
  {
    Note: this class is inherited from TRVComplexLineHeightDrawLineInfo,
    not TRVDrawLineInfo, though it is not necessary used in paragraphs with
    complex line spacing. But it may be there...
  }
  TRVFootnoteDrawItem = class(TRVComplexLineHeightDrawLineInfo)
    public
      DocumentRVData: TRVFootnotePtblRVData;
  end;
  {$ENDIF}
  {------------------------------------------------------------}
  TCustomPrintableRV = class(TCustomRichView)
    private
      FRVPrint: TCustomRVPrint;
    protected
      {$IFNDEF RVDONOTUSESEQ}
      FNoteSeparatorHeight, FNoteLineWidth: Integer;
      FEndnotes: TRVEndnoteList;
      FFootnotes: TRVFootnoteList;
      {$ENDIF}
      procedure CreateParams(var Params: TCreateParams); override;
    public
      constructor Create(AOwner: TComponent); override;
      {$IFNDEF RVDONOTUSESEQ}
      destructor Destroy; override;
      function GetFootnoteRVData(
        Footnote: TRVFootnoteItemInfo): TRVFootnotePtblRVData;
      procedure DrawNoteSeparatorAbove(PageNo, Y: Integer; Canvas: TCanvas;
        FullSize: Boolean);
      procedure CalcFootnotesCoords(References: TList; PageNo: Integer);
      procedure FreeNotesLists;
      {$ENDIF}
      {$IFNDEF RVDONOTUSERVF}
      procedure ApplyLayoutInfo (Layout: TRVLayoutInfo); override;
      {$ENDIF}
      function CanUseCustomPPI: Boolean; virtual;
      procedure InitFormatPages;
      function FormatPages: Integer;
      procedure FinalizeFormatPages;
      procedure DrawPage(PageNo: Integer; Canvas: TCanvas; Preview,
        Correction: Boolean);
      property RVPrint: TCustomRVPrint read FRVPrint write FRVPrint;
      {$IFNDEF RVDONOTUSESEQ}
      property NoteSeparatorHeight: Integer read FNoteSeparatorHeight;
      {$ENDIF}
  end;
  {------------------------------------------------------------}
  TPrintableRV = class(TCustomPrintableRV)
    private
      procedure DoOnPrinting(PageCompleted: Integer; Step:TRVPrintingStep);
    protected
      function GetDataClass: TRichViewRVDataClass; override;
    public
      FMirrorMargins: Boolean;
      FLeftMarginMM, FRightMarginMM, FTopMarginMM, FBottomMarginMM: Integer;
      procedure PrintPages(firstPgNo, lastPgNo: Integer;
        const Title: String; Copies: Integer; Collate: Boolean);
      procedure Print(const Title: String; Copies: Integer; Collate: Boolean);
      procedure ContinuousPrint;
  end;
  {------------------------------------------------------------}
  TCustomRVPrint = class(TComponent)
    private
      { Private declarations }
      FPreviewCorrection: Boolean;
      FOnPrintComponent: TRVPrintComponentEvent;
      FMinPrintedItemNo, FMaxPrintedItemNo: Integer;
      function GetTransparentBackground: Boolean;
      procedure SetTransparentBackground(const Value: Boolean);
      function GetPreview100PercentHeight: Integer;
      function GetPreview100PercentWidth: Integer;
      function GetColorMode: TRVColorMode;
      procedure SetColorMode(const Value: TRVColorMode);
      function GetIsDestinationReady: Boolean;
      function GetFirstPageNo: Integer;
      function GetLastPageNo: Integer;
    protected
      { Protected declarations }
      procedure Loaded; override;
      function CreateRichView: TCustomPrintableRV; dynamic;
      function GetSourceRichView: TCustomRichView; dynamic;
      function GetPagesCount: Integer;
      {$IFNDEF RVDONOTUSESEQ}
      function FormatEndnotes: Integer;
      procedure PreformatFootnotes;
      procedure PostformatFootnotes;
      function IgnoreEndnotes: Boolean; dynamic;
      {$ENDIF}
    public
      { Public declarations }
      rv: TCustomPrintableRV;
      Ready: Boolean;
      StartAt,EndAt: Integer;
      FormattingID: Integer;
      constructor Create(AOwner: TComponent); override;
      procedure Clear;
      procedure UpdatePaletteInfo;
      procedure GetFirstItemOnPage(PageNo: Integer;
        var ItemNo, OffsetInItem: Integer);
      procedure GetFirstItemOnPageEx(PageNo: Integer;
        var ItemNo, OffsetInItem, ExtraData: Integer);
      function GetPageNo(RVData: TCustomRVData;
        ItemNo, OffsetInItem: Integer): Integer;
      function IsComplexSoftPageBreak(PageNo: Integer): Boolean;
      procedure AssignComplexSoftPageBreakToItem(PageNo: Integer;
        RVData: TCustomRVFormattedData);
      procedure DrawPreview(pgNo: Integer; Canvas:  TCanvas;
        const PageRect: TRect);
      procedure DrawMarginsRect(Canvas:  TCanvas; const PageRect: TRect;
        PageNo: Integer);
      {$IFNDEF RVDONOTUSERVF}
      function SavePageAsRVF(Stream: TStream; PageNo: Integer): Boolean;
      {$ENDIF}
      procedure GetMinimalMargins(var MarginsRect: TRect;
        ScreenResolution: Boolean);
      property PagesCount: Integer read GetPagesCount;
      property Preview100PercentWidth: Integer read GetPreview100PercentWidth;
      property Preview100PercentHeight: Integer read GetPreview100PercentHeight;
      property IsDestinationReady: Boolean read GetIsDestinationReady;
      property FirstPageNo: Integer read GetFirstPageNo;
      property LastPageNo: Integer read GetLastPageNo;
    published
      { Published declarations }
      property PreviewCorrection: Boolean
        read FPreviewCorrection  write FPreviewCorrection;
      property OnPrintComponent: TRVPrintComponentEvent
        read FOnPrintComponent write FOnPrintComponent;
      property TransparentBackground: Boolean
        read GetTransparentBackground write SetTransparentBackground default False;
      property ColorMode: TRVColorMode
        read GetColorMode write SetColorMode default rvcmPrinterColor;
      property MinPrintedItemNo: Integer read FMinPrintedItemNo write FMinPrintedItemNo default 0;
      property MaxPrintedItemNo: Integer read FMaxPrintedItemNo write FMaxPrintedItemNo default -1;
  end;

  TRVPrint = class(TCustomRVPrint)
    private
      { Private declarations }
      FOnFormatting, FOnPrinting: TRVPrintingEvent;
      FOnPagePrepaint, FOnPagePostPaint: TRVPagePrepaintEvent;
      FClipMargins: Boolean;
      FPrintMe: TCustomRichView;
      FFixMarginsMode: TRVFixMarginsMode;
      function GetLM: Integer;
      function GetRM: Integer;
      function GetTM: Integer;
      function GetBM: Integer;
      procedure SetLM(mm: Integer);
      procedure SetRM(mm: Integer);
      procedure SetTM(mm: Integer);
      procedure SetBM(mm: Integer);
      function GetMirrorMargins: Boolean;
      procedure SetMirrorMargins(const Value: Boolean);
      function GetFooterY: Integer;
      function GetHeaderY: Integer;
      procedure SetFooterY(const Value: Integer);
      procedure SetHeaderY(const Value: Integer);
    protected
      { Protected declarations }
      function CreateRichView: TCustomPrintableRV; override;
      function GetSourceRichView: TCustomRichView; override;
    public
      { Public declarations }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure AssignSource(PrintMe: TCustomRichView);
      {$IFNDEF RVDONOTUSEDOCPARAMS}
      procedure AssignDocParameters(DocParameters: TRVDocParameters);
      {$ENDIF}
      procedure SetHeader(RVData: TCustomRVFormattedData);
      procedure SetFooter(RVData: TCustomRVFormattedData);
      function FormatPages(PrintOptions:TRVDisplayOptions): Integer;
      procedure PrintPages(firstPgNo, lastPgNo: Integer; Title: String;
        Copies: Integer; Collate: Boolean);
      procedure Print(Title: String; Copies: Integer; Collate: Boolean);
      procedure ContinuousPrint;
      procedure MakePreview(pgNo: Integer; bmp: TBitmap);
      procedure MakeScaledPreview(pgNo: Integer; bmp: TBitmap);
      function GetHeaderRect: TRect;
      function GetFooterRect: TRect;
      procedure Clear;
    published
      { Published declarations }
      property ClipMargins:   Boolean read FClipMargins write FClipMargins default False;
      property MirrorMargins: Boolean read GetMirrorMargins write SetMirrorMargins default False;
      property LeftMarginMM:  Integer read GetLM write SetLM;
      property RightMarginMM: Integer read GetRM write SetRM;
      property TopMarginMM:   Integer read GetTM write SetTM;
      property BottomMarginMM:Integer read GetBM write SetBM;
      property FooterYMM:     Integer read GetFooterY write SetFooterY default 10;
      property HeaderYMM:     Integer read GetHeaderY write SetHeaderY default 10;
      property OnFormatting: TRVPrintingEvent read FOnFormatting write FOnFormatting;
      property OnSendingToPrinter: TRVPrintingEvent read FOnPrinting write FOnPrinting;
      property OnPagePrepaint: TRVPagePrepaintEvent read FOnPagePrepaint write FOnPagePrepaint;
      property OnPagePostpaint: TRVPagePrepaintEvent read FOnPagePostpaint write FOnPagePostpaint;
      property FixMarginsMode: TRVFixMarginsMode
        read FFixMarginsMode write FFixMarginsMode default rvfmmAutoCorrect;
  end;

function RV_GetPrinterDC: HDC;
implementation
{==============================================================================}
type
  TPrinterDevice = class
  public
    Driver, Device, Port: String;
  end;

function RV_GetPrinterDC: HDC;
var ADevice, ADriver, APort: array[0..79] of Char;
    ADeviceMode: THandle;
    DevMode: PDeviceMode;
begin
  Printer.GetPrinter(ADevice,ADriver,APort,ADeviceMode);
  if ADeviceMode<>0 then
    DevMode := PDeviceMode(GlobalLock(ADeviceMode))
  else
    DevMode := nil;
  Result := CreateDC(ADriver, ADevice, APort, DevMode);
  if ADeviceMode<>0 then
    GlobalUnlock(ADeviceMode);
end;
{=============================== TCustomRVPrint ===============================}
constructor TCustomRVPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMinPrintedItemNo := 0;
  FMaxPrintedItemNo := -1;
  rv := CreateRichView;
  rv.FRVPrint := Self;
  if not (csDesigning in ComponentState) and (Self.Owner is TWinControl) then
    rv.Parent := TWinControl(Self.Owner);
  PreviewCorrection := True;
  ColorMode := rvcmPrinterColor;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.CreateRichView: TCustomPrintableRV;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetSourceRichView: TCustomRichView;
begin
  Result := rv;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.Clear;
begin
  rv.Clear;
  {$IFNDEF RVDONOTUSESEQ}
  rv.FEndnotes.Free;
  rv.FEndnotes := nil;
  rv.FFootnotes.Free;
  rv.FFootnotes := nil;
  {$ENDIF}  
  Ready := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.GetFirstItemOnPageEx(PageNo: Integer;
  var ItemNo, OffsetInItem, ExtraData: Integer);
begin
  if PageNo <= TPrintableRVData(rv.RVData).Pages.Count then
    TPrintableRVData(rv.RVData).GetFirstItemOnPageEx(PageNo, ItemNo,
      OffsetInItem, ExtraData)
  else begin
    ItemNo := -1;
    OffsetInItem := -1;
    ExtraData := -1;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetPageNo(RVData: TCustomRVData;
  ItemNo, OffsetInItem: Integer): Integer;
begin
  Result := TPrintableRVData(rv.RVData).GetPageNo(RVData, ItemNo, OffsetInItem,
    GetSourceRichView.RVData);
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.IsComplexSoftPageBreak(PageNo: Integer): Boolean;
begin
  if PageNo <= TPrintableRVData(rv.RVData).Pages.Count then
    Result := TPrintableRVData(rv.RVData).IsComplexSoftPageBreak(PageNo)
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.AssignComplexSoftPageBreakToItem(PageNo: Integer;
  RVData: TCustomRVFormattedData);
begin
  if PageNo <= TPrintableRVData(rv.RVData).Pages.Count then
    TPrintableRVData(rv.RVData).AssignComplexSoftPageBreakToItem(PageNo, RVData);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.GetFirstItemOnPage(PageNo: Integer; var ItemNo,
  OffsetInItem: Integer);
var ExtraData: Integer;
begin
  GetFirstItemOnPageEx(PageNo, ItemNo, OffsetInItem, ExtraData);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
function TCustomRVPrint.SavePageAsRVF(Stream: TStream; PageNo: Integer): Boolean;
var Layout: TRVLayoutInfo;
begin
  Layout := rv.CreateLayoutInfo;
  try
    Result := TCustomMainPtblRVData(rv.RVData).SavePageAsRVF(Stream, PageNo,
      rv.Color, rv.Background, Layout);
  finally
    Layout.Free;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetPagesCount: Integer;
begin
  Result := TPrintableRVData(rv.RVData).Pages.Count;
  {$IFNDEF RVDONOTUSESEQ}
  if rv.FEndnotes<>nil then
    inc(Result, rv.FEndnotes.Pages.Count-1);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TCustomRVPrint.IgnoreEndnotes: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.FormatEndnotes: Integer;
var Endnote: TRVEndnoteItemInfo;
  RVData: TRVEndnotePtblRVData;
  PageInfo: TRVEndnotePage;
  LastPage: TRVPageInfo;
  DefMaxHeight, MaxHeight, LStartAt, LStartAt2, StartY, y, i, EndnotePage,
  CurHeight: Integer;
  Splitting: Boolean;
  FootnoteRVDataList: TRVFootnoteRefList;
begin
  Result := 0;
  if (TCustomMainPtblRVData(rv.RVData).Pages=nil) or
     (TCustomMainPtblRVData(rv.RVData).Pages.Count=0) then
    exit;
  LastPage := TCustomMainPtblRVData(rv.RVData).Pages[TCustomMainPtblRVData(rv.RVData).Pages.Count-1];
  DefMaxHeight := TCustomMainPtblRVData(rv.RVData).GetPageHeight-
    (TCustomMainPtblRVData(rv.RVData).TmpTMPix+TCustomMainPtblRVData(rv.RVData).TmpBMPix+
     TCustomMainPtblRVData(rv.RVData).TmpM.Top+TCustomMainPtblRVData(rv.RVData).TmpM.Bottom);
  if LastPage.FootnoteRVDataList<>nil then
    MaxHeight := LastPage.FootnoteRVDataList[0].Top-rv.NoteSeparatorHeight-
      TCustomMainPtblRVData(rv.RVData).TmpM.Top-
      (TCustomMainPtblRVData(rv.RVData).TmpTMPix+TCustomMainPtblRVData(rv.RVData).TmpBMPix)
  else
    MaxHeight := DefMaxHeight;

  if IgnoreEndnotes then
    Endnote := nil
  else
    Endnote := RVGetFirstEndnote(GetSourceRichView, False);

  if Endnote=nil then begin
    if LastPage.FootnoteRVDataList<>nil then
      EndAt := DefMaxHeight;
    exit;
  end;

  if Endnote<>nil then begin
    rv.Style.TextStyles[0].Apply(TCustomMainPtblRVData(rv.RVData).PrinterCanvas,
      rvbdUnspecified, False, nil, True, False, rv.Style.GraphicInterface);
    LStartAt := EndAt+rv.FNoteSeparatorHeight;
    rv.FEndnotes := TRVEndnoteList.Create(Self);
    PageInfo := TRVEndnotePage.Create;
    PageInfo.Index := 0;
    PageInfo.Page  := 1;
    repeat
      RVData := TRVEndnotePtblRVData.Create(rv);
      RVData.ShareItemsFrom(Endnote.Document);
      RVData.Endnote := Endnote;
      RVData.Format_(False, True, False, 0, RVData.GetCanvas, False, False, False, False);
      CurHeight := MaxHeight-LStartAt;
      if not RVData.CanPlaceFirstPageHere(CurHeight, False,
          TCustomMainPtblRVData(rv.RVData).PrnSad, False, False) then begin
        MaxHeight := DefMaxHeight;
        LStartAt := rv.FNoteSeparatorHeight;
        RVData.FromNewPage := True;
        if PageInfo<>nil then begin
          PageInfo.Index := -1;
          PageInfo.Page  := -1;
          rv.FEndnotes.Pages.Add(PageInfo);
        end;
        PageInfo := TRVEndnotePage.Create;
        PageInfo.Index := rv.FEndnotes.Count;
        PageInfo.Page  := 1;
      end;
      if PageInfo<>nil then begin
        rv.FEndnotes.Pages.Add(PageInfo);
        PageInfo := nil;
      end;
      RVData.StartAt := LStartAt;
      RVData.NextStartAt := rv.FNoteSeparatorHeight;
      i := 0;
      EndnotePage := 1;
      while i<RVData.DrawItems.Count do begin
        if EndnotePage>1 then begin
          MaxHeight := DefMaxHeight;
          PageInfo := TRVEndnotePage.Create;
          PageInfo.Page  := EndnotePage;
          PageInfo.Index := rv.FEndnotes.Count;
          rv.FEndnotes.Pages.Add(PageInfo);
          PageInfo := nil;
        end;
        FootnoteRVDataList := nil;
        RVData.FormatNextPage(i, LStartAt2, StartY, y,
          Splitting, MaxHeight, FootnoteRVDataList, False);
        inc(EndnotePage);
      end;
      LStartAt := RVData.EndAt;
      rv.FEndnotes.Add(RVData);
      Endnote := RVGetNextEndnote(GetSourceRichView, Endnote, False);
    until Endnote=nil;
    Result := rv.FEndnotes.Pages.Count-1;
    if (rv.FEndnotes.Pages.Count=0) and (LastPage.FootnoteRVDataList<>nil) then
      EndAt := DefMaxHeight
    else
      EndAt := LStartAt;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.PreformatFootnotes;
var Footnote: TRVFootnoteItemInfo;
  RVData: TRVFootnotePtblRVData;
  TmpM: TRect;
begin
  rv.FNoteSeparatorHeight := rv.Style.GraphicInterface.TextHeight(
    TCustomMainPtblRVData(rv.RVData).PrinterCanvas, '-');
  rv.FNoteLineWidth := RV_YToDevice(1, TCustomMainPtblRVData(rv.RVData).PrnSad);

  Footnote := RVGetFirstFootnote(GetSourceRichView, True);
  if Footnote=nil then
    exit;
  TmpM := TCustomMainPtblRVData(rv.RVData).TmpM;
  rv.FFootnotes := TRVFootnoteList.Create(Self);
  repeat
    RVData := TRVFootnotePtblRVData.Create(rv, Footnote.Document,
      TCustomPrintableRVData(rv.RVData));
    RVData.Footnote := Footnote;
    RVData.ParentDrawsBack := True;
    RVData.Transparent := True;
    RVData.FColor := clNone;
    RVData.Left := TmpM.Left;
    RVData.Width := TCustomMainPtblRVData(rv.RVData).GetPageWidth - (TmpM.Left+TmpM.Right);
    RVData.Top := 0;
    RVData.Height := 1;
    RVData.Format(True);
    rv.FFootnotes.Add(RVData);
    Footnote := RVGetNextFootnote(GetSourceRichView, Footnote, True);
  until Footnote=nil;
  rv.FFootnotes.SortByFootnotes;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.PostformatFootnotes;
var PageIndex, i, Delta, TopOffs: Integer;
    PageInfo: TRVPageInfo;
begin
  TopOffs := TCustomMainPtblRVData(rv.RVData).TmpM.Top+
    TCustomMainPtblRVData(rv.RVData).TmpTMPix;
  for PageIndex := 0 to TCustomMainPtblRVData(rv.RVData).Pages.Count-1 do begin
    PageInfo := TCustomMainPtblRVData(rv.RVData).Pages[PageIndex];
    if (PageInfo.FootnoteRVDataList<>nil) and
       (PageInfo.FootnoteRVDataList[0].Top<TopOffs+PageInfo.DocumentHeight+rv.NoteSeparatorHeight) then
    begin
      Delta := TopOffs+PageInfo.DocumentHeight+rv.NoteSeparatorHeight-PageInfo.FootnoteRVDataList[0].Top;
      for i := 0 to PageInfo.FootnoteRVDataList.Count-1 do
        inc(PageInfo.FootnoteRVDataList[i].Top, Delta);
    end;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetTransparentBackground: Boolean;
begin
  Result := TPrintableRVData(rv.RVData).Transparent;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.SetTransparentBackground(const Value: Boolean);
begin
  TPrintableRVData(rv.RVData).Transparent := Value;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.Loaded;
begin
  inherited Loaded;
  UpdatePaletteInfo;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.UpdatePaletteInfo;
begin
  rv.UpdatePaletteInfo;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetIsDestinationReady: Boolean;
begin
  Result := TCustomMainPtblRVData(rv.RVData).FIsDestinationReady;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetPreview100PercentHeight: Integer;
begin
  with TCustomMainPtblRVData(rv.RVData) do
    Result := RV_YToScreen(rv.ClientHeight+TmpM.Top+TmpM.Bottom, PrnSaD);
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetPreview100PercentWidth: Integer;
begin
  with TCustomMainPtblRVData(rv.RVData) do
    Result := RV_XToScreen(rv.ClientWidth+TmpM.Left+TmpM.Right, PrnSaD);
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetColorMode: TRVColorMode;
begin
  Result := TCustomMainPtblRVData(rv.RVData).ColorMode;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.SetColorMode(const Value: TRVColorMode);
begin
  TCustomMainPtblRVData(rv.RVData).ColorMode := Value;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.DrawPreview(pgNo: Integer; Canvas: TCanvas;
  const PageRect: TRect);
var OldMapMode, OldPPI: Integer;
    OldWindowExt, OldViewportExt: TSize;
    OldViewportOrg: TPoint;
begin
  if rv.Style=nil then
    exit;
  OldMapMode := rv.Style.GraphicInterface.GetMapMode(Canvas);
  rv.Style.GraphicInterface.SetMapMode(Canvas, MM_TEXT);
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clWhite;
  rv.Style.GraphicInterface.FillRect(Canvas, PageRect);
  rv.Style.GraphicInterface.SetMapMode(Canvas,MM_ANISOTROPIC);
  with TCustomMainPtblRVData(rv.RVData) do
   rv.Style.GraphicInterface.SetWindowExtEx(Canvas,
     rv.ClientWidth +TmpM.Left+TmpM.Right,
     rv.ClientHeight+TmpM.Top+TmpM.Bottom, @OldWindowExt);
  with PageRect do begin
    rv.Style.GraphicInterface.SetViewportExtEx(Canvas,
      Right-Left, Bottom-Top, @OldViewportExt);
    rv.Style.GraphicInterface.SetViewportOrgEx(Canvas,
      Left,Top, @OldViewportOrg);
  end;
  OldPPI := Canvas.Font.PixelsPerInch;
  Canvas.Font.PixelsPerInch := TCustomMainPtblRVData(rv.RVData).PrnSaD.ppiyDevice;
  try
    rv.DrawPage(pgNo, Canvas, True, PreviewCorrection);
  finally
    Canvas.Font.PixelsPerInch := OldPPI;
    rv.Style.GraphicInterface.SetViewportOrgEx(Canvas, OldViewportOrg.X, OldViewportOrg.Y, nil);
    rv.Style.GraphicInterface.SetViewportExtEx(Canvas, OldViewportExt.cx, OldViewportExt.cy, nil);
    rv.Style.GraphicInterface.SetWindowExtEx(Canvas, OldWindowExt.cx, OldWindowExt.cy, nil);
    rv.Style.GraphicInterface.SetMapMode(Canvas, OldMapMode);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.DrawMarginsRect(Canvas: TCanvas; const PageRect: TRect;
  PageNo: Integer);
var FullWidth, FullHeight: Integer;
    RectWidth, RectHeight, LM: Integer;
begin
  with TCustomMainPtblRVData(rv.RVData) do begin
     FullWidth  := rv.ClientWidth+TmpM.Left+TmpM.Right;
     FullHeight := rv.ClientHeight+TmpM.Top+TmpM.Bottom;
     RectWidth  := PageRect.Right-PageRect.Left;
     RectHeight := PageRect.Bottom-PageRect.Top;
     LM := TCustomPrintableRVData(rv.RVData).GetPrintableAreaLeft(PageNo);
     rv.Style.GraphicInterface.Rectangle(Canvas,
       PageRect.Left+MulDiv(LM,RectWidth,FullWidth),
       PageRect.Top+MulDiv(TmpM.Top,RectHeight,FullHeight),
       PageRect.Left+MulDiv(LM+rv.ClientWidth,RectWidth,FullWidth),
       PageRect.Top+MulDiv(TmpM.Top+rv.ClientHeight,RectHeight,FullHeight)
      );
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVPrint.GetMinimalMargins(var MarginsRect: TRect;
  ScreenResolution: Boolean);
begin
  MarginsRect := TCustomMainPtblRVData(rv.RVData).PhysM;
  if ScreenResolution then
    with TCustomMainPtblRVData(rv.RVData) do begin
      MarginsRect.Left   := RV_XToScreen(MarginsRect.Left,   PrnSaD);
      MarginsRect.Top    := RV_YToScreen(MarginsRect.Top,    PrnSaD);
      MarginsRect.Right  := RV_XToScreen(MarginsRect.Right,  PrnSaD);
      MarginsRect.Bottom := RV_YToScreen(MarginsRect.Bottom, PrnSaD);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetFirstPageNo: Integer;
begin
  if (FMinPrintedItemNo<=0) then
    Result := 1
  else begin
    if FMinPrintedItemNo>=GetSourceRichView.RVData.ItemCount then
      Result := PagesCount+1
    else
      Result := GetPageNo(GetSourceRichView.RVData,
        FMinPrintedItemNo, GetSourceRichView.RVData.GetOffsBeforeItem(FMinPrintedItemNo));
    if Result<=0 then
      Result := 1;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVPrint.GetLastPageNo: Integer;
begin
  if (FMaxPrintedItemNo<0) or (FMaxPrintedItemNo>=GetSourceRichView.RVData.ItemCount-1) then
    Result := PagesCount
  else begin
    Result := GetPageNo(GetSourceRichView.RVData,
      FMaxPrintedItemNo, GetSourceRichView.RVData.GetOffsAfterItem(FMaxPrintedItemNo));
    if Result<=0 then
      Result := PagesCount;
  end;
end;
{=============================== TRVPrint =====================================}
constructor TRVPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LeftMarginMM   := 20;
  RightMarginMM  := 20;
  TopMarginMM    := 20;
  BottomMarginMM := 20;
end;
{------------------------------------------------------------------------------}
destructor TRVPrint.Destroy;
begin
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.Clear;
begin
  inherited Clear;
  FPrintMe := nil;
end;
{------------------------------------------------------------------------------}
function TRVPrint.CreateRichView: TCustomPrintableRV;
begin
  Result := TPrintableRV.Create(Self);
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetSourceRichView: TCustomRichView;
begin
  Result := FPrintMe;
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetMirrorMargins: Boolean;
begin
  Result := TPrintableRV(rv).FMirrorMargins;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetMirrorMargins(const Value: Boolean);
begin
  TPrintableRV(rv).FMirrorMargins := Value;
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetLM: Integer;
begin
   GetLM := TPrintableRV(rv).FLeftMarginMM;
end;
{------------------------------------------------------------------------------}
function  TRVPrint.GetRM: Integer;
begin
   GetRM := TPrintableRV(rv).FRightMarginMM;
end;
{------------------------------------------------------------------------------}
function  TRVPrint.GetTM: Integer;
begin
   GetTM := TPrintableRV(rv).FTopMarginMM;
end;
{------------------------------------------------------------------------------}
function  TRVPrint.GetBM: Integer;
begin
   GetBM := TPrintableRV(rv).FBottomMarginMM;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetLM(mm: Integer);
begin
   TPrintableRV(rv).FLeftMarginMM := mm;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetRM(mm: Integer);
begin
   TPrintableRV(rv).FRightMarginMM := mm;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetTM(mm: Integer);
begin
   TPrintableRV(rv).FTopMarginMM := mm;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetBM(mm: Integer);
begin
   TPrintableRV(rv).FBottomMarginMM := mm;
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetFooterY: Integer;
begin
  Result := TPrintableRVData(rv.RVData).FooterY;
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetHeaderY: Integer;
begin
  Result := TPrintableRVData(rv.RVData).HeaderY;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetFooterY(const Value: Integer);
begin
  TPrintableRVData(rv.RVData).FooterY := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetHeaderY(const Value: Integer);
begin
  TPrintableRVData(rv.RVData).HeaderY := Value;
end;
{------------------------------------------------------------------------------}
function TRVPrint.FormatPages(PrintOptions:TRVDisplayOptions): Integer;
begin
  Result := 0;
  inc(FormattingID);
  if FormattingID=10000 then
    FormattingID := 0;
  rv.InitFormatPages;
  if IsDestinationReady then begin
    {$IFNDEF RVDONOTUSESEQ}
    PreformatFootnotes;
    {$ENDIF}
    Result := rv.FormatPages;
    {$IFNDEF RVDONOTUSESEQ}
    PostformatFootnotes;
    inc(Result, FormatEndnotes);
    {$ENDIF}
    rv.FinalizeFormatPages;
    Ready := True;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.Print(Title: String; Copies: Integer; Collate: Boolean);
begin
  TPrintableRV(rv).Print(Title, Copies, Collate);
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.PrintPages(firstPgNo, lastPgNo: Integer; Title: String;
                              Copies: Integer; Collate: Boolean);
begin
  TPrintableRV(rv).PrintPages(firstPgNo, lastPgNo, Title, Copies, Collate);
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.ContinuousPrint;
begin
  TPrintableRV(rv).ContinuousPrint;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.AssignSource(PrintMe: TCustomRichView);
begin
  FPrintMe := PrintMe;
  rv.RVData.ShareItemsFrom(PrintMe.RVData);
  rv.RVData.State := rv.RVData.State+[rvstSkipFormatting];
  try
    rv.LeftMargin   := PrintMe.LeftMargin;
    rv.RightMargin  := PrintMe.RightMargin;
    rv.TopMargin    := 0;
    rv.BottomMargin := 0;
    TPrintableRVData(rv.RVData).FTopMarginPix    := PrintMe.TopMargin;
    TPrintableRVData(rv.RVData).FBottomMarginPix := PrintMe.BottomMargin;
    rv.Style := PrintMe.Style;
    rv.DoInPaletteMode := PrintMe.DoInPaletteMode;
    rv.BackgroundBitmap := PrintMe.BackgroundBitmap;
    rv.BackgroundStyle := PrintMe.BackgroundStyle;
    rv.Color := PrintMe.Color;
    rv.BiDiMode := PrintMe.BiDiMode;
  finally
    rv.RVData.State := rv.RVData.State-[rvstSkipFormatting];
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDOCPARAMS}
procedure TRVPrint.AssignDocParameters(DocParameters: TRVDocParameters);
   {.......................................................................}
   function GetMM(Value: Extended): Integer;
   begin
     Result := Round(Value*
       DocParameters.UnitsPerInch(rvuMillimeters)/
       DocParameters.UnitsPerInch(DocParameters.Units));
   end;
   {.......................................................................}
begin
  LeftMarginMM   := GetMM(DocParameters.LeftMargin);
  RightMarginMM  := GetMM(DocParameters.RightMargin);
  TopMarginMM    := GetMM(DocParameters.TopMargin);
  BottomMarginMM := GetMM(DocParameters.BottomMargin);
  HeaderYMM      := GetMM(DocParameters.HeaderY);
  FooterYMM      := GetMM(DocParameters.FooterY);
  MirrorMargins  := MirrorMargins;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVPrint.SetHeader(RVData: TCustomRVFormattedData);
begin
  TPrintableRVData(rv.RVData).Header.Free;
  TPrintableRVData(rv.RVData).Header := nil;
  if RVData<>nil then begin
    TPrintableRVData(rv.RVData).Header :=
      TRVHeaderFooterRVData.Create(rv, RVData, rv.RVData as TCustomPrintableRVData);
    TPrintableRVData(rv.RVData).Header.FLeftMargin := RVData.GetLeftMargin;
    TPrintableRVData(rv.RVData).Header.FRightMargin := RVData.GetRightMargin;    
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.SetFooter(RVData: TCustomRVFormattedData);
begin
  TPrintableRVData(rv.RVData).Footer.Free;
  TPrintableRVData(rv.RVData).Footer := nil;
  if RVData<>nil then begin
    TPrintableRVData(rv.RVData).Footer :=
      TRVHeaderFooterRVData.Create(rv, RVData, rv.RVData as TCustomPrintableRVData);
    TPrintableRVData(rv.RVData).Footer.FLeftMargin := RVData.GetLeftMargin;
    TPrintableRVData(rv.RVData).Footer.FRightMargin := RVData.GetRightMargin;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.MakeScaledPreview(pgNo: Integer; bmp: TBitmap);
begin
  DrawPreview(pgNo, bmp.Canvas, Rect(0,0,bmp.Width, bmp.Height));
end;
{------------------------------------------------------------------------------}
procedure TRVPrint.MakePreview(pgNo: Integer; bmp: TBitmap);
var w,h: Integer;
begin
   w := GetPreview100PercentWidth;
   h := GetPreview100PercentHeight;

   if bmp.Width <> w then bmp.Width := w;
   if bmp.Height <> h then bmp.Height := h;
   MakeScaledPreview(pgNo,bmp);
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetFooterRect: TRect;
begin
  if TPrintableRVData(rv.RVData).Footer=nil then
    Result := Rect(0,0,0,0)
  else
    with TPrintableRVData(rv.RVData).Footer do
      Result := Bounds(Left+DX,Top+DY,Width,DocumentHeight);
end;
{------------------------------------------------------------------------------}
function TRVPrint.GetHeaderRect: TRect;
begin
  if TPrintableRVData(rv.RVData).Header=nil then
    Result := Rect(0,0,0,0)
  else
    with TPrintableRVData(rv.RVData).Header do
      Result := Bounds(Left+DX,Top+DY,Width,DocumentHeight);
end;
{======================== TCustomPrintableRV ==================================}
constructor TCustomPrintableRV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
  Flags := Flags - [rvflUseJumps, rvflCanUseCustomPPI, rvflCanProcessGetText] +
    [rvflPrinting,rvflShareContents,rvflAllowCustomDrawItems];
  TopMargin    := 0;     // do not change!
  BottomMargin := 0;  // do not change!
  BorderStyle  := bsNone;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
destructor TCustomPrintableRV.Destroy;
begin
  FreeNotesLists;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.FreeNotesLists;
begin
  FEndNotes.Free;
  FEndNotes := nil;
  FFootNotes.Free;
  FFootnotes := nil;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRV.GetFootnoteRVData(
  Footnote: TRVFootnoteItemInfo): TRVFootnotePtblRVData;
begin
  Result := FFootnotes.FindByFootnote(Footnote);
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.CalcFootnotesCoords(References: TList; PageNo: Integer);
var i, y: Integer;
    FootnoteData: TRVFootnotePtblRVData;
    DrawItem: TRVDrawLineInfo;
begin
  if References=nil then
    exit;
  // Calculating coordinates of footnotes, assigning numbers (if restarted on page)
  TRVFootnoteRefList(References).Sort;
  y := TCustomMainPtblRVData(RVData).GetPageHeight-TCustomMainPtblRVData(RVData).TmpM.Bottom;
  for i := References.Count-1 downto 0 do begin
    FootnoteData := TRVFootnotePtblRVData(References[i]);
    dec(y, FootnoteData.DocumentHeight);
    FootnoteData.Top := y;
    FootnoteData.Left :=
      TCustomMainPtblRVData(RVData).GetPrintableAreaLeft(PageNo)+
      RV_XToDevice(LeftMargin, TCustomMainPtblRVData(RVData).PrnSad);
    FootnoteData.IndexOnPage := i+1;
  end;
  if not Style.FootnotePageReset then
    exit;
  // Adjusting widths of footnote characters and references to them
  for i := 0 to References.Count-1 do begin
    FootnoteData := TRVFootnotePtblRVData(References[i]);
    DrawItem := FootnoteData.FootnoteItemRVData.DrawItems[FootnoteData.FootnoteDItemNo];
    FootnoteData.FootnoteItemRVData.ChangeDItemWidth(FootnoteData.FootnoteDItemNo,
      FootnoteData.Footnote.GetFinalPrintingWidth(
        TCustomMainPtblRVData(RVData).PrinterCanvas, DrawItem, FootnoteData.FootnoteItemRVData));
    FootnoteData.AdjustFootnoteRefWidths;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.DrawNoteSeparatorAbove(PageNo, Y: Integer;
  Canvas: TCanvas; FullSize: Boolean);
var X, Width: Integer;
begin
  X := TCustomMainPtblRVData(RVData).GetPrintableAreaLeft(PageNo)+
    RV_XToDevice(LeftMargin, TCustomMainPtblRVData(RVData).PrnSad);
  Canvas.Pen.Width := FNoteLineWidth;
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Pen.Color := clGray;
  //Canvas.Rectangle(X,Y,X+100,Y-FNoteSeparatorHeight);
  //exit;
  dec(Y, FNoteSeparatorHeight div 2);
  Style.GraphicInterface.MoveTo(Canvas, X+(FNoteSeparatorHeight div 2), Y);
  Width := Self.Width - RV_XToDevice(RightMargin+LeftMargin,
    TCustomMainPtblRVData(RVData).PrnSad);
  if not FullSize then
    Width := Width div 3;
  inc(X, Width-FNoteSeparatorHeight);
  Style.GraphicInterface.LineTo(Canvas, X, Y);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomPrintableRV.CanUseCustomPPI: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.InitFormatPages;
begin
  RVData.State := RVData.State+[rvstSkipformatting];
  try
    VScrollVisible := False;
    HScrollVisible := False;
  finally
    RVData.State := RVData.State-[rvstSkipformatting];
  end;
  {$IFNDEF RVDONOTUSESEQ}
  FreeNotesLists;
  {$ENDIF}
  TPrintableRVData(RVData).InitFormatPages;
end;
{------------------------------------------------------------------------------}
function TCustomPrintableRV.FormatPages: Integer;
begin
  Result := TPrintableRVData(RVData).FormatPages;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.FinalizeFormatPages;
begin
  TPrintableRVData(RVData).FinalizeFormatPages;
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.DrawPage(PageNo: Integer; Canvas: TCanvas;
  Preview, Correction: Boolean);
{$IFNDEF RVDONOTUSESEQ}
var LastItemNo: Integer;
{$ENDIF}
begin
  if (PageNo<RVPrint.FirstPageNo) or (PageNo>RVPrint.LastPageNo) then
    exit;
  TPrintableRVData(RVData).DrawPage(PageNo, Canvas, Preview, Correction);
  {$IFNDEF RVDONOTUSESEQ}
  LastItemNo := RVData.ItemCount-1;
  if (FEndnotes<>nil) and
     (PageNo>=TPrintableRVData(RVData).Pages.Count) and
     (LastItemNo>=RVPrint.MinPrintedItemNo) and
     ((RVPrint.MaxPrintedItemNo<0) or (LastItemNo<=RVPrint.MaxPrintedItemNo)) then
    FEndnotes.DrawPage(PageNo,
      PageNo-TPrintableRVData(RVData).Pages.Count, Canvas, Preview, Correction);
  {$ENDIF}  
end;
{------------------------------------------------------------------------------}
procedure TCustomPrintableRV.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := (Params.Style and not WS_CHILD) or WS_POPUP;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
procedure TCustomPrintableRV.ApplyLayoutInfo(Layout: TRVLayoutInfo);
begin
  inherited;
  if Layout.FirstParaAborted<>0 then begin
    Include(RVData.State, rvstFirstParaAborted);
    TCustomMainPtblRVData(RVData).FFirstParaListNo := Layout.FirstMarkerListNo;
    TCustomMainPtblRVData(RVData).FFirstParaLevel := Layout.FirstMarkerLevel;
    end
  else begin
    Exclude(RVData.State, rvstFirstParaAborted);
    TCustomMainPtblRVData(RVData).FFirstParaListNo := -1;
    TCustomMainPtblRVData(RVData).FFirstParaLevel := -1;
  end;
  if Layout.LastParaAborted<>0 then
    Include(RVData.State, rvstLastParaAborted)
  else
    Exclude(RVData.State, rvstLastParaAborted);
end;
{$ENDIF}
{============================= TPrintableRV ===================================}
function TPrintableRV.GetDataClass: TRichViewRVDataClass;
begin
  Result := TPrintableRVData;
end;
{------------------------------------------------------------------------------}
procedure TPrintableRV.ContinuousPrint;
var i: Integer;
begin
  for i := 1 to TPrintableRVData(RVData).Pages.Count do begin
    if i<>1 then
      Printer.NewPage;
    DrawPage(i, Printer.Canvas,False,False);
  end;
end;
{------------------------------------------------------------------------------}
procedure TPrintableRV.DoOnPrinting(PageCompleted: Integer; Step:TRVPrintingStep);
begin
  if Assigned(TRVPrint(RVPrint).FOnPrinting) then
    TRVPrint(RVPrint).FOnPrinting(Self, PageCompleted, Step);
end;
{------------------------------------------------------------------------------}
procedure TPrintableRV.PrintPages(firstPgNo, lastPgNo: Integer;
  const Title: String; Copies: Integer; Collate: Boolean);
var i,copyno: Integer;
    PrinterCopies: Integer;
begin
   if firstPgNo<RVPrint.FirstPageNo then
     firstPgNo := RVPrint.FirstPageNo;
   if lastPgNo>RVPrint.LastPageNo then
     lastPgNo := RVPrint.LastPageNo;
   if lastPgNo<firstPgNo then
     exit;
   FRVPrint.StartAt := 0;
   DoOnPrinting(0, rvpsStarting);
   Printer.Title := Title;
   PrinterCopies := Printer.Copies; { storing }
   if (pcCopies in Printer.Capabilities) and Collate then
     begin
       Printer.Copies := Copies;
                                 // Printer can make copies if needed
       Copies := 1;              // TRichView does not need to support copies itself
     end
   else
     Printer.Copies := 1;        // TRichView will provide copies and collation itself
   Printer.BeginDoc;
   if Collate then
     for copyno:= 1 to Copies do
       for i := firstPgNo to lastPgNo do begin
         DrawPage(i, Printer.Canvas,False,False);
         DoOnPrinting(i, rvpsProceeding);
         if not ((i=lastPgNo) and (copyno=Copies)) then
           Printer.NewPage;
       end
   else
     for i := firstPgNo to lastPgNo do
       for copyno:= 1 to Copies do begin
         DrawPage(i, Printer.Canvas,False,False);
         DoOnPrinting(i, rvpsProceeding);
         if not ((i=lastPgNo) and (copyno=Copies)) then
           Printer.NewPage;
       end;
   Printer.EndDoc;
   Printer.Copies := PrinterCopies; { restoring }
   DoOnPrinting(0, rvpsFinished);
end;
{------------------------------------------------------------------------------}
procedure TPrintableRV.Print(const Title: String; Copies: Integer; Collate: Boolean);
begin
   PrintPages(RVPrint.GetFirstPageNo, RVPrint.GetLastPageNo, Title, Copies, Collate);
end;
{$IFNDEF RVDONOTUSESEQ}
{=========================== TRVEndnotePageList ===============================}
function TRVEndnotePageList.GetItems(Index: Integer): TRVEndnotePage;
begin
  Result := TRVEndnotePage(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVEndnotePageList.SetItems(Index: Integer;
  const Value: TRVEndnotePage);
begin
  inherited Put(Index, Value);
end;
{=============================== TRVEndnoteList ===============================}
constructor TRVEndnoteList.Create(AOwner: TCustomRVPrint);
begin
  inherited Create;
  FOwner := AOwner;
  Pages := TRVEndnotePageList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVEndnoteList.Destroy;
begin
  Pages.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVEndnoteList.DrawPage(RealPageNo, PageNo: Integer; Canvas: TCanvas;
  Preview, Correction: Boolean);
var i, StartAt: Integer;
begin
  i := Pages[PageNo].Index;
  if i<0 then
    exit;
  if (PageNo=0) or (Pages[PageNo].Page>1) or
     Items[i].FromNewPage then begin
    if Pages[PageNo].Page<=1 then
      StartAt := Items[i].StartAt
    else
      StartAt := Items[i].NextStartAt;
    FOwner.rv.DrawNoteSeparatorAbove(RealPageNo,
      TCustomMainPtblRVData(FOwner.rv.RVData).TmpM.Top+
      TCustomMainPtblRVData(FOwner.rv.RVData).TmpTMPix+
      StartAt, Canvas, (Pages[PageNo].Page>1) or Items[i].FromNewPage);
  end;
  Items[i].DrawPage(Pages[PageNo].Page, Canvas, Preview,
    Correction);
  if Items[i].Pages.Count>Pages[PageNo].Page then
    exit;
  for i := Pages[PageNo].Index+1 to Count-1 do begin
    if Items[i].FromNewPage then
      break;
    Items[i].DrawPage(1, Canvas, Preview, Correction);
    if Items[i].Pages.Count>1 then
      break;
  end;
end;
{------------------------------------------------------------------------------}
function TRVEndnoteList.GetItems(Index: Integer): TRVEndnotePtblRVData;
begin
  Result := TRVEndnotePtblRVData(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVEndnoteList.SetItems(Index: Integer;
  const Value: TRVEndnotePtblRVData);
begin
  inherited Put(Index, Value);
end;
{================================ TRVFootnoteList =============================}
constructor TRVFootnoteList.Create(AOwner: TCustomRVPrint);
begin
  inherited Create;
  FOwner := AOwner;
end;
{------------------------------------------------------------------------------}
function TRVFootnoteList.GetItems(Index: Integer): TRVFootnotePtblRVData;
begin
  Result := TRVFootnotePtblRVData(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteList.SetItems(Index: Integer;
  const Value: TRVFootnotePtblRVData);
begin
  inherited Put(Index, Value);
end;
{------------------------------------------------------------------------------}
function CompareFootnoteRVData(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(TRVFootnotePtblRVData(Item1).Footnote)-Integer(TRVFootnotePtblRVData(Item2).Footnote);
end;
{------------------------------------------------------------------------------}
function CompareFootnoteRVDataAndFootnote(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(TRVFootnotePtblRVData(Item1).Footnote)-Integer(Item2);
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteList.SortByFootnotes;
begin
  Sort(CompareFootnoteRVData);
end;
{------------------------------------------------------------------------------}
function TRVFootnoteList.FindByFootnote(
  Footnote: TRVFootnoteItemInfo): TRVFootnotePtblRVData;
var Index: Integer;
begin
  Index := Find(Footnote, CompareFootnoteRVDataAndFootnote);
  if Index<0 then
    Result := nil
  else
    Result := Items[Index];
end;

{$ENDIF}

end.

