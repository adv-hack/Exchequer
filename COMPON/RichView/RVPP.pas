
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVPrintPreview: print preview for RichView     }
{       (registered on "RichView" page of               }
{       the Component Palette)                          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVPP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  RVScroll, PtblRV, Printers, CRVPP;
{$I RV_Defs.inc}
type

  TRVPrintPreview = class(TCustomRVPrintPreview)
  private
    { Private declarations }
    FRVPrint: TCustomRVPrint;
    FStoredPageNo: Integer;
    FStoredRect: TRect;
    FStoredDocID: Integer;
    FMetafile: TMetafile;
    FCachePageImage: Boolean;
    procedure SetRVPrint(const Value: TCustomRVPrint);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    function CanDrawContents: Boolean; override;
    procedure DrawContents(Canvas:TCanvas; const R: TRect); override;
    procedure DrawMargins(Canvas:TCanvas; const R: TRect;
      PageNo: Integer); override;
    function GetPreview100PercentWidth: Integer; override;
    function GetPreview100PercentHeight: Integer; override;
    function GetPhysMargins: TRect; override;
    function GetPageCount: Integer; override;
    procedure SetPageNo(const Value: Integer); override;
    procedure Loaded; override;
    procedure UpdateImage(PageNo: Integer; R: TRect);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property CachePageImage: Boolean read FCachePageImage write FCachePageImage default False;
    property RVPrint: TCustomRVPrint read FRVPrint write SetRVPrint;
    property ZoomInCursor;
    property ZoomOutCursor;
    property OnZoomChanged;
    property MarginsPen;
    property PrintableAreaPen;
    property ClickMode;
    property PageBorderColor;
    property PageBorderWidth;
    property ShadowColor;
    property ShadowWidth;
    property BackgroundMargin;
    { Published standard properties }
    property Align;
    {$IFDEF RICHVIEWDEF4}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Ctl3D;
    {$IFDEF RICHVIEWDEF4}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property HelpContext;
    property ParentCtl3D;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    { Published standard events }
    property OnClick;
    {$IFDEF RICHVIEWDEF5}
    property OnContextPopup;
    {$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    {$IFDEF RICHVIEWDEF4}
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    {$ENDIF}
    property OnStartDrag;
    { Published RichView properties }
    property BorderStyle;
    property HScrollVisible;    
    {$IFDEF RVFLATSCROLLBARS}
    property ScrollBarColor;
    property ScrollBarStyle;
    {$ENDIF}
    property Tracking;
    property UseXPThemes;
    property VScrollVisible;
    {$IFDEF RICHVIEWDEF4}
    property WheelStep;
    {$ENDIF}
  end;

implementation
{========================== TRVPrintPreview ============================}
constructor TRVPrintPreview.Create(AOwner: TComponent);
begin
  inherited;
  FCachePageImage := False;
end;
{-----------------------------------------------------------------------}
destructor TRVPrintPreview.Destroy;
begin
  FMetafile.Free;
  inherited;
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (AComponent=RVPrint) then begin
      FRVPrint := nil;
  end;
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.Loaded;
begin
  inherited Loaded;
  UpdatePaletteInfo;
end;
{-----------------------------------------------------------------------}
function TRVPrintPreview.CanDrawContents: Boolean;
begin
  Result := (RVPrint<>nil) and RVPrint.Ready and RVPrint.IsDestinationReady;
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.DrawContents(Canvas:TCanvas; const R: TRect);
begin
  if CachePageImage then begin
    UpdateImage(PageNo, R);
    Canvas.Draw(R.Left,R.Top, FMetafile);
    end
  else
    RVPrint.DrawPreview(PageNo, Canvas, R);
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.DrawMargins(Canvas:TCanvas; const R: TRect;
  PageNo: Integer);
begin
  inherited DrawMargins(Canvas, R, PageNo);
  RVPrint.DrawMarginsRect(Canvas, R, PageNo);
end;
{-----------------------------------------------------------------------}
function TRVPrintPreview.GetPreview100PercentHeight: Integer;
begin
  Result := FRVPrint.Preview100PercentHeight;
end;
{-----------------------------------------------------------------------}
function TRVPrintPreview.GetPhysMargins: TRect;
begin
  FRVPrint.GetMinimalMargins(Result, True);
end;
{-----------------------------------------------------------------------}
function TRVPrintPreview.GetPreview100PercentWidth: Integer;
begin
  Result := FRVPrint.Preview100PercentWidth;
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.SetRVPrint(const Value: TCustomRVPrint);
begin
  FRVPrint := Value;
  if FRVPrint<>nil then
    DoInPaletteMode := FRVPrint.rv.DoInPaletteMode;
  UpdateView;
end;
{-----------------------------------------------------------------------}
function TRVPrintPreview.GetPageCount: Integer;
begin
  Result := FRVPrint.PagesCount;
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.SetPageNo(const Value: Integer);
begin
  if FRVPrint<>nil then
    DoInPaletteMode := FRVPrint.rv.DoInPaletteMode;
  inherited;
end;
{-----------------------------------------------------------------------}
procedure TRVPrintPreview.UpdateImage(PageNo: Integer; R: TRect);
var Canvas: TMetafileCanvas;
    DocID: Integer;
begin
  if FRVPrint<>nil then
    DocID := FRVPrint.FormattingID
  else
    DocID := -1;
  OffsetRect(R, -R.Left, -R.Top);
  if (FMetafile<>nil) and (PageNo=FStoredPageNo) and
     (DocID=FStoredDocID) and (FStoredRect.Left=R.Left) and
     (FStoredRect.Right=R.Right) and (FStoredRect.Top=R.Top) and
     (FStoredRect.Bottom=R.Bottom) then
    exit;
  FMetafile.Free;
  if FRVPrint=nil then begin
    FMetafile := nil;
    exit;
  end;
  FMetafile := TMetafile.Create;
  FStoredPageNo := PageNo;
  FStoredRect := R;
  FStoredDocID := DocID;
  FMetafile.Width := R.Right-R.Left;
  FMetafile.Height := R.Bottom-R.Top;
  Canvas := TMetafileCanvas.Create(FMetafile, 0);
  RVPrint.DrawPreview(PageNo, Canvas, R);
  Canvas.Free;
end;


end.
