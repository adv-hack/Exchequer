
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVReportHelper: contains RichView document     }
{       and draws/prints in onto the specified          }
{       Canvas                                          }
{       (registered on "RichView" page of               }
{       the Component Palette)                          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVReport;

interface

{$I RV_Defs.inc}
uses Windows, Graphics, Classes, RVStyle, RVClasses, RVItem, RVScroll,
     CRVData, CRVFData, RVRVData, RichView, PtRVData, PtblRV, RVFuncs;


type
  TRVReportHelper = class;
  TRVDrawHyperlinkEvent = procedure (Sender: TRVReportHelper;
    RVData: TCustomRVData; ItemNo: Integer; R: TRect) of object;
  TRVDrawCheckpointEvent = procedure (Sender: TRVReportHelper;
    RVData: TCustomRVData; ItemNo: Integer; X, Y: Integer) of object;
  { ----------------------------------------------------------------------------
    TReportRVData: main data object for TReportRichView
  }
  TReportRVData = class(TCustomMainPtblRVData)
    private
      StartY, StartAt, Y, DrawItemNo, CurHeight: Integer;
      Splitting: Boolean;
      procedure StoreMargins;
      procedure RestoreMargins;
      procedure Init(ACanvas: TCanvas; APageWidth: Integer);
      function FormatNextPage(AMaxHeight: Integer): Boolean;
      function Finished: Boolean;
      procedure Reset;
    protected
      function ShareItems: Boolean; override;
      procedure DoOnHyperlink(RVData: TCustomRVData; ItemNo: Integer;
        const R: TRect); override;
      procedure DoOnCheckpoint(RVData: TCustomRVData; ItemNo, X, Y: Integer); override;
    public
      function GetHeight: Integer; override;
      function GetPageHeight: Integer; override;
      function GetPageWidth: Integer; override;
  end;
  { ----------------------------------------------------------------------------
    TReportRichView: class of hidden TRichView inside TRVReportHelper
  }
  TReportRichView = class(TCustomPrintableRV)
    private
      function GetHeight: Integer;
      function GetWidth: Integer;
      function GetLeft: Integer;
      function GetTop: Integer;
    protected
      function GetDataClass: TRichViewRVDataClass; override;
      procedure SetBiDiModeRV(const Value: TRVBiDiMode); override;
    public
      constructor Create(AOwner: TComponent); override;
      function CanUseCustomPPI: Boolean; override;
    published
      { Published standard properties }
      property Color default clNone;
      { Published RichView properties }
      property BackgroundBitmap;
      property BackgroundStyle;
      property BiDiMode;
      property BottomMargin;
      property Delimiters;
      property LeftMargin;
      property Options;
      property RightMargin;
      property RTFOptions;
      property RTFReadProperties;
      property RVFOptions;
      property RVFParaStylesReadMode;
      property RVFTextStylesReadMode;
      property Style;
      property TopMargin;
      { Published RichView events }
      property OnControlAction;
      property OnHTMLSaveImage;
      property OnRVFImageListNeeded;
      property OnRVFControlNeeded;
      property OnRVFPictureNeeded;
      property OnSaveComponentToFile;
      property OnURLNeeded;
      property OnReadHyperlink;
      property OnWriteHyperlink;
      property Width: Integer read GetWidth;
      property Height: Integer read GetHeight;
      property Left: Integer read GetLeft;
      property Top: Integer read GetTop;
  end;

  TRVReportHelper = class (TCustomRVPrint)
    private
      FOnDrawHyperlink: TRVDrawHyperlinkEvent;
      FOnDrawCheckpoint: TRVDrawCheckpointEvent;
      function GetRichView: TReportRichView;
    protected
      function CreateRichView: TCustomPrintableRV; override;
    public
      { Create & Destroy }
      constructor Create(AOwner: TComponent); override;
      { Formatting }
      procedure Init(ACanvas: TCanvas; APageWidth: Integer);
      function FormatNextPage(AMaxHeight: Integer): Boolean;
      procedure Reset;
      { Drawing }
      procedure DrawPage(APageNo: Integer; ACanvas: TCanvas; APreview: Boolean;
        AHeight: Integer);
      procedure DrawPageAt(Left, Top, APageNo: Integer; ACanvas: TCanvas;
        APreview: Boolean; AHeight: Integer);
      { Information }
      function Finished: Boolean;
      function GetLastPageHeight: Integer;
    {$IFDEF RICHVIEWDEF6}
    published
    {$ENDIF}
      property RichView: TReportRichView read GetRichView;
    published
      property ColorMode default rvcmColor;
      property OnDrawHyperlink: TRVDrawHyperlinkEvent
        read FOnDrawHyperlink write FOnDrawHyperlink;
      property OnDrawCheckpoint: TRVDrawCheckpointEvent
        read FOnDrawCheckpoint write FOnDrawCheckpoint;
  end;

implementation

uses DLines, RVCtrlData;

{============================ TRVReportData ===================================}
function TReportRVData.ShareItems: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TReportRVData.Reset;
var i, Height: Integer;
    dli: TRVDrawLineInfo;
    FootnoteRVDataList: TRVFootnoteRefList;
begin
  FootnoteRVDataList := nil;
  Height := 0;
  for i := 0 to DrawItems.Count-1 do begin
    dli := TRVDrawLineInfo(DrawItems[i]);
    if dli is TRVMultiDrawItemInfo then
      TRVMultiDrawItemInfo(dli).ResetPages(FootnoteRVDataList, Height, False);
  end;
  Pages.Clear;
  DrawItemNo := 0;
end;
(*
var PageNo, i, Height: Integer;
    dli: TRVDrawLineInfo;
    StartDItemNo, EndDItemNo, Part: Integer;
    FootnoteRVDataList: TRVFootnoteRefList;
begin
  Height := 0;
  for PageNo := Pages.Count downto 1 do begin
    GetDrawItemsRange(PageNo, StartDItemNo, EndDItemNo, Part);
    {$IFNDEF RVDONOTUSESEQ}
    FootnoteRVDataList := Pages[PageNo-1].FootnoteRVDataList;
    {$ELSE}
    FootnoteRVDataList := nil;
    {$ENDIF}
    for i := StartDItemNo to EndDItemNo do begin
      dli := TRVDrawLineInfo(DrawItems[i]);
      if dli is TRVMultiDrawItemInfo then
        TRVMultiDrawItemInfo(dli).ResetPages(FootnoteRVDataList, Height, False);
    end;
    {$IFNDEF RVDONOTUSESEQ}
    Pages[PageNo-1].FootnoteRVDataList := FootnoteRVDataList;
    {$ENDIF}
  end;
  Pages.Clear;
  DrawItemNo := 0;
end;
*)
{------------------------------------------------------------------------------}
procedure TReportRVData.Init(ACanvas: TCanvas; APageWidth: Integer);
begin
  Reset;

  PrinterCanvas := ACanvas;
  TmpM.Left := 0;
  TmpM.Top := 0;
  StoreMargins;
  Prepare;
  State := State+[rvstSkipformatting];
  try
    TCustomRichView(FRichView).HandleNeeded;
    TCustomRichView(FRichView).VScrollVisible := False;
    TCustomRichView(FRichView).HScrollVisible := False;
    FRichView.ClientWidth := APageWidth;
    FRichView.ClientHeight:= APageWidth;
  finally
    State := State-[rvstSkipformatting];
  end;
  TCustomRichView(FRichView).MaxTextWidth := RV_XToScreen(APageWidth, PrnSaD)-
    TCustomRichView(FRichView).LeftMargin-TCustomRichView(FRichView).RightMargin;
  TCustomRichView(FRichView).MinTextWidth := TCustomRichView(FRichView).MaxTextWidth;

  Format_(False, True, False, 0, PrinterCanvas, False, False, False, False);
  RestoreMargins;
  FIsDestinationReady := True;
end;
{------------------------------------------------------------------------------}
procedure TReportRVData.StoreMargins;
begin
  FTopMarginPix    := TCustomRichView(FRichView).TopMargin;
  FBottomMarginPix := TCustomRichView(FRichView).BottomMargin;
  TCustomRichView(FRichView).TopMargin := 0;
  TCustomRichView(FRichView).BottomMargin := 0;
end;
{------------------------------------------------------------------------------}
procedure TReportRVData.RestoreMargins;
begin
  TCustomRichView(FRichView).TopMargin    := FTopMarginPix;
  TCustomRichView(FRichView).BottomMargin := FBottomMarginPix;
end;
{------------------------------------------------------------------------------}
function TReportRVData.Finished: Boolean;
begin
  Result := (DrawItems.Count=0) or (DrawItemNo>=DrawItems.Count);
end;
{------------------------------------------------------------------------------}
function TReportRVData.FormatNextPage(AMaxHeight: Integer): Boolean;
var FootnoteRVDataList: TRVFootnoteRefList;
begin
  Result := not Finished;
  if Result then begin
    StoreMargins;
    try
      dec(AMaxHeight, TmpTMPix+TmpBMPix);
      FootnoteRVDataList := nil;
      inherited FormatNextPage(DrawItemNo, StartAt, StartY, Y, Splitting,
        AMaxHeight, FootnoteRVDataList, True);
    finally
      RestoreMargins;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TReportRVData.GetPageHeight: Integer;
begin
  Result := CurHeight;
end;
{------------------------------------------------------------------------------}
function TReportRVData.GetPageWidth: Integer;
begin
  Result := FRichView.ClientWidth;
end;
{------------------------------------------------------------------------------}
function TReportRVData.GetHeight: Integer;
begin
  Result := CurHeight;
end;
{------------------------------------------------------------------------------}
procedure TReportRVData.DoOnHyperlink(RVData: TCustomRVData;
  ItemNo: Integer; const R: TRect);
var Helper: TRVReportHelper;
begin
  Helper := TRVReportHelper(TReportRichView(FRichView).RVPrint);
  if Assigned(Helper.FOnDrawHyperlink) then
    Helper.FOnDrawHyperlink(Helper, RVData, ItemNo, R);
end;
{------------------------------------------------------------------------------}
procedure TReportRVData.DoOnCheckpoint(RVData: TCustomRVData; ItemNo, X,
  Y: Integer);
var Helper: TRVReportHelper;
begin
  Helper := TRVReportHelper(TReportRichView(FRichView).RVPrint);
  if Assigned(Helper.FOnDrawCheckpoint) then
    Helper.FOnDrawCheckpoint(Helper, RVData, ItemNo, X, Y);
end;
{================================ TReportRichView =============================}
constructor TReportRichView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Flags := Flags - [rvflShareContents]+[rvflCanUseCustomPPI];  
  Name := 'RichView';
  {$IFDEF RICHVIEWDEF6}
  SetSubComponent(True);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TReportRichView.GetDataClass: TRichViewRVDataClass;
begin
  Result := TReportRVData;
end;
{------------------------------------------------------------------------------}
procedure TReportRichView.SetBiDiModeRV(const Value: TRVBiDiMode);
begin
  FBiDiMode := Value;
end;
{------------------------------------------------------------------------------}
function TReportRichView.CanUseCustomPPI: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
function TReportRichView.GetHeight: Integer;
begin
  Result := inherited ClientHeight;
end;
{------------------------------------------------------------------------------}
function TReportRichView.GetLeft: Integer;
begin
  Result := inherited Left;
end;
{------------------------------------------------------------------------------}
function TReportRichView.GetTop: Integer;
begin
  Result := inherited Top;
end;
{------------------------------------------------------------------------------}
function TReportRichView.GetWidth: Integer;
begin
  Result := inherited ClientWidth;
end;
{================================ TRVReportHelper =============================}
{ Constructor.                                                                 }
constructor TRVReportHelper.Create(AOwner: TComponent);
begin
  inherited;
  ColorMode := rvcmColor;
end;
{------------------------------------------------------------------------------}
function TRVReportHelper.CreateRichView: TCustomPrintableRV;
begin
  Result := TReportRichView.Create(Self);
end;
{------------------------------------------------------------------------------}
procedure TRVReportHelper.Init(ACanvas: TCanvas; APageWidth: Integer);
begin
  {$IFNDEF RVDONOTUSESEQ}
  TReportRichView(rv).FreeNotesLists;
  {$ENDIF}
  inc(FormattingID);
  if FormattingID=10000 then
    FormattingID := 0;
  TReportRVData(TReportRichView(rv).RVData).Init(ACanvas,APageWidth);
  {$IFNDEF RVDONOTUSESEQ}
  PreformatFootnotes;
  {$ENDIF};
end;
{------------------------------------------------------------------------------}
function TRVReportHelper.Finished: Boolean;
begin
  Result := TReportRVData(TReportRichView(rv).RVData).Finished;
end;
{------------------------------------------------------------------------------}
function TRVReportHelper.FormatNextPage(AMaxHeight: Integer): Boolean;
begin
  TReportRVData(TReportRichView(rv).RVData).CurHeight := AMaxHeight;
  Result := TReportRVData(TReportRichView(rv).RVData).FormatNextPage(AMaxHeight);
  {$IFNDEF RVDONOTUSESEQ}
  if Finished then begin
    PostformatFootnotes;
    FormatEndnotes;
  end;
  {$ENDIF};
end;
{------------------------------------------------------------------------------}
function TRVReportHelper.GetRichView: TReportRichView;
begin
  Result := TReportRichView(rv);
end;
{------------------------------------------------------------------------------}
procedure TRVReportHelper.DrawPage(APageNo: Integer; ACanvas: TCanvas;
  APreview: Boolean; AHeight: Integer);
begin
  TReportRVData(TReportRichView(rv).RVData).CurHeight := AHeight;
  rv.DrawPage(APageNo, ACanvas, APreview, PreviewCorrection);
end;
{------------------------------------------------------------------------------}
procedure TRVReportHelper.DrawPageAt(Left, Top, APageNo: Integer;
  ACanvas: TCanvas; APreview: Boolean; AHeight: Integer);
var pt: TPoint;
begin
  if rv.Style=nil then
    exit;
  rv.Style.GraphicInterface.SetWindowOrgEx(ACanvas, -Left, -Top, @pt);
  try
    DrawPage(APageNo, ACanvas, APreview, AHeight);
  finally
    rv.Style.GraphicInterface.SetWindowOrgEx(ACanvas, pt.x, pt.y, nil);
  end;
end;
{------------------------------------------------------------------------------}
function TRVReportHelper.GetLastPageHeight: Integer;
begin
  Result := EndAt+TReportRVData(RichView.RVData).TmpTMPix+
    TReportRVData(RichView.RVData).TmpBMPix;
end;
{------------------------------------------------------------------------------}
procedure TRVReportHelper.Reset;
begin
  TReportRVData(TReportRichView(rv).RVData).Reset;
end;


end.
