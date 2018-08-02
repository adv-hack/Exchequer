
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TDBRichView: displays RVF/RTF/text field in     }
{       a dataset.                                      }
{       TDBRichViewEdit: edits RVF/RTF/text field in    }
{       a dataset.                                      }
{       (registered on "RichView" page of               }
{       the Component Palette)                          }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit DBRV;

interface
{$I RV_Defs.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RVScroll, RichView, RVEdit, DB, DBCtrls, CRVData, CRVFData, RVStyle, 
  RVTypes, RVClasses
  {$IFNDEF RICHVIEWCBDEF3}
  , DBTables
  {$ENDIF}
  ;
type
  TRVDBFieldFormat = (rvdbRVF, rvdbRTF, rvdbText);

  TRVCustomFormatEvent = procedure (Sender: TCustomRichView;
    Stream: TStream; var DoDefault: Boolean) of object;



  TDBRichView = class(TCustomRichView)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FOnNewDocument: TNotifyEvent;
    FOnLoadDocument: TNotifyEvent;
    FOnLoadCustomFormat: TRVCustomFormatEvent;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure SetAutoDisplay(Value: Boolean);
  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DblClick; override;
    procedure Paint; override;    
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadField;
    property Field: TField read GetField;
    {$IFDEF RICHVIEWDEF4}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    {$ENDIF}
  published
    { Published declarations: new for TDBRichView }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property OnLoadDocument: TNotifyEvent read FOnLoadDocument write FOnLoadDocument;
    property OnNewDocument: TNotifyEvent read FOnNewDocument write FOnNewDocument;
    property OnLoadCustomFormat: TRVCustomFormatEvent
      read FOnLoadCustomFormat write FOnLoadCustomFormat;
    { Published standard properties }
    property Align;
    {$IFDEF RICHVIEWDEF4}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Color default clNone;
    property Ctl3D;
    {$IFDEF RICHVIEWDEF4}
    property DragKind;
    {$ENDIF}    
    property DragMode;
    property Enabled;
    property HelpContext;
    property ParentCtl3D;
    property ParentShowHint;
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
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    {$IFDEF RICHVIEWDEF4}
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;    
    {$ENDIF}
    property OnStartDrag;
    { Published RichView properties }
    {$IFNDEF RVDONOTUSEANIMATION}
    property AnimationMode;
    {$ENDIF}
    property BackgroundBitmap;
    property BackgroundStyle default bsNoBitmap;
    property BiDiMode;
    property BorderStyle default bsSingle;
    property BottomMargin;
    property CPEventKind default cpeNone;
    property Cursor default crDefault;
    property Delimiters;
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    property DocParameters;
    {$ENDIF}    
    property DoInPaletteMode;
    property FirstJumpNo;
    property HScrollVisible;
    property LeftMargin;
    {$IFNDEF RVDONOTUSELIVESPELL}
    //property LiveSpellingMode;
    {$ENDIF}
    property MaxLength;
    property MaxTextWidth;
    property MinTextWidth;
    property Options;
    property RightMargin;
    property RTFOptions;
    property RTFReadProperties;
    property RVFOptions;
    property RVFParaStylesReadMode;
    property RVFTextStylesReadMode;
    {$IFDEF RVFLATSCROLLBARS}
    property ScrollBarColor;
    property ScrollBarStyle;
    {$ENDIF}
    property Style;
    property TabNavigation;
    property TopMargin;
    property Tracking;
    property UseXPThemes;
    {$IFDEF RICHVIEWDEF3}
    property VAlign;
    {$ENDIF}
    property VScrollVisible;
    {$IFDEF RICHVIEWDEF4}
    property WheelStep;
    {$ENDIF}
    property WordWrap;
    { Published RichView events }
    property OnAddStyle;
    property OnCheckpointVisible;
    property OnControlAction;
    property OnCopy;
    {$IFDEF RV_ODHC}
    property OnDocumentHeightChange;
    {$ENDIF}
    property OnGetItemCursor;
    property OnImportPicture;
    property OnItemAction;
    property OnItemHint;
    property OnJump;
    property OnHScrolled;    
    property OnHTMLSaveImage;
    property OnPaint;
    property OnProgress;
    property OnReadHyperlink;    
    property OnRVDblClick;
    property OnRVFImageListNeeded;
    property OnRVFControlNeeded;
    property OnRVFPictureNeeded;
    {$IFDEF RVFPICTURENEEDED2}
    property OnRVFPictureNeeded2;
    {$ENDIF}    
    property OnRVMouseDown;
    property OnRVMouseMove;
    property OnRVMouseUp;
    property OnRVRightClick;
    property OnSaveComponentToFile;
    property OnSaveHTMLExtra;
    property OnSaveImage2;
    property OnSaveItemToFile;    
    property OnSaveRTFExtra;    
    property OnSelect;
    {$IFNDEF RVDONOTUSELIVESPELL}
    property OnSpellingCheck;
    {$IFDEF RVLIVESPELLEXEVENT}
    property OnSpellingCheckEx;
    {$ENDIF}
    {$ENDIF}    
    property OnVScrolled;
    property OnWriteHyperlink;
    { obsolete properties }
    property AllowSelection;
    property SingleClick;
    property OnURLNeeded;
  end;
{-----------------------------------------------------------------------}
  TDBRichViewEdit = class(TCustomRichViewEdit)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FDataSaveStream: TRVMemoryStream;
    FFieldFormat: TRVDBFieldFormat;
    FAutoDeleteUnusedStyles: Boolean;
    FOnNewDocument: TNotifyEvent;
    FIgnoreEscape: Boolean;
    FOnLoadDocument: TNotifyEvent;
    FOnLoadCustomFormat, FOnSaveCustomFormat: TRVCustomFormatEvent;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function DBGetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetFocused(Value: Boolean);
    procedure DBSetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure BeginEditing;
    procedure DoLoadField(Check: Boolean);
    procedure WMReload(var Msg: TMessage); message WM_RVRELOAD;
    procedure CMWantSpecialKey(var Message: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DblClick; override;
    procedure KeyPress(var Key: Char); override;
    procedure Paint; override;
    procedure DoFormat; dynamic;
  public
    procedure DoChange(ClearRedo: Boolean); override;
    function BeforeChange(FromOutside: Boolean): Boolean; override;
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadField;
    property Field: TField read GetField;
    {$IFDEF RICHVIEWDEF4}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    {$ENDIF}
  published
    { Published declarations: new for TDBRichViewEdit }
    property IgnoreEscape: Boolean read FIgnoreEscape write FIgnoreEscape default False;
    property AutoDeleteUnusedStyles: Boolean read FAutoDeleteUnusedStyles write FAutoDeleteUnusedStyles default False;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read DBGetReadOnly write DBSetReadOnly;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property FieldFormat: TRVDBFieldFormat read FFieldFormat write FFieldFormat default rvdbRVF;
    property OnLoadDocument: TNotifyEvent read FOnLoadDocument write FOnLoadDocument;
    property OnNewDocument: TNotifyEvent read FOnNewDocument write FOnNewDocument;
    property OnLoadCustomFormat: TRVCustomFormatEvent
      read FOnLoadCustomFormat write FOnLoadCustomFormat;
    property OnSaveCustomFormat: TRVCustomFormatEvent
      read FOnSaveCustomFormat write FOnSaveCustomFormat;
    { Published declarations: new for TRichViewEdit }
    property AcceptDragDropFormats;
    property CustomCaretInterval;
    property EditorOptions;
    property UndoLimit;

    property OnCaretGetOut;
    property OnCaretMove;    
    property OnChange;
    property OnChanging;
    property OnCurParaStyleChanged;
    property OnCurTextStyleChanged;
    {$IFDEF RVONCUT}
    property OnCut;
    {$ENDIF}
    property OnDrawCustomCaret;
    property OnMeasureCustomCaret;
    property OnDropFiles;
    property OnItemResize;    
    property OnItemTextEdit;
    {$IFNDEF RVDONOTUSEDRAGDROP}
    property OnOleDragEnter;
    property OnOleDragLeave;
    property OnOleDragOver;
    property OnOleDrop;    
    {$ENDIF}    
    property OnParaStyleConversion;
    property OnPaste;
    property OnStyleConversion;
    property TabNavigation;
    { Published standard properties }
    property Align;
    {$IFDEF RICHVIEWDEF4}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Color default clNone;
    property Ctl3D;
    {$IFDEF RICHVIEWDEF4}
    property DragKind;
    {$ENDIF}    
    property DragMode;
    property Enabled;
    property HelpContext;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;    
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property UseXPThemes;
    property Visible;
    { Published standard events }
    property OnClick;
    {$IFDEF RICHVIEWDEF5}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    {$IFDEF RICHVIEWDEF4}
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;    
    {$ENDIF}
    property OnStartDrag;
    { Published RichView properties }
    {$IFNDEF RVDONOTUSEANIMATION}
    property AnimationMode;
    {$ENDIF}    
    property BackgroundBitmap;
    property BackgroundStyle default bsNoBitmap;
    property BiDiMode;
    property BorderStyle default bsSingle;
    property BottomMargin;
    //property CPEventKind;
    property Cursor default crIBeam;
    property Delimiters;
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    property DocParameters;
    {$ENDIF}
    property DoInPaletteMode;
    property FirstJumpNo;
    property HScrollVisible;
    property LeftMargin;
    {$IFNDEF RVDONOTUSESMARTPOPUP}
    property OnSmartPopupClick;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELIVESPELL}
    property LiveSpellingMode default rvlspOnChange;
    {$ENDIF}
    property MaxLength;
    property MaxTextWidth;
    property MinTextWidth;
    property Options;
    property RightMargin;
    property RTFOptions;
    property RTFReadProperties;
    property RVFOptions;
    property RVFParaStylesReadMode;
    property RVFTextStylesReadMode;
    {$IFNDEF RVDONOTUSESMARTPOPUP}
    property SmartPopupProperties;
    {$ENDIF}    
    {$IFDEF RVFLATSCROLLBARS}
    property ScrollBarColor;
    property ScrollBarStyle;
    {$ENDIF}
    property Style;
    //property TabNavigation;
    property TopMargin;
    property Tracking;
    {$IFDEF RICHVIEWDEF3}
    property VAlign;
    {$ENDIF}
    property VScrollVisible;
    {$IFDEF RICHVIEWDEF4}
    property WheelStep;
    {$ENDIF}
    property WordWrap;
    { Published RichView events }
    property OnAddStyle;
    //property OnCheckpointVisible;
    property OnControlAction;
    property OnCopy;
    {$IFDEF RV_ODHC}
    property OnDocumentHeightChange;
    {$ENDIF}
    property OnGetItemCursor;
    property OnImportPicture;
    property OnItemAction;
    property OnItemHint;    
    property OnJump;
    property OnHScrolled;    
    property OnHTMLSaveImage;
    property OnPaint;
    property OnProgress;    
    property OnReadHyperlink;
    property OnRVDblClick;
    property OnRVFImageListNeeded;
    property OnRVFControlNeeded;
    property OnRVFPictureNeeded;
    {$IFDEF RVFPICTURENEEDED2}
    property OnRVFPictureNeeded2;
    {$ENDIF}    
    property OnRVMouseDown;
    property OnRVMouseMove;
    property OnRVMouseUp;
    property OnRVRightClick;
    property OnSaveComponentToFile;
    property OnSaveHTMLExtra;
    property OnSaveImage2;
    property OnSaveItemToFile;
    property OnSaveRTFExtra;
    property OnSelect;
    {$IFNDEF RVDONOTUSELIVESPELL}
    property OnSpellingCheck;
    {$IFDEF RVLIVESPELLEXEVENT}
    property OnSpellingCheckEx;
    {$ENDIF}    
    {$ENDIF}
    property OnVScrolled;
    property OnWriteHyperlink;
    { obsolete properties }
    property AllowSelection;
    property SingleClick;
    property OnURLNeeded;
  end;

procedure Register;

implementation

const
  errFieldType = 'Unsupported field type: BLOB is required';

{$IFNDEF RICHVIEWDEF3}
function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,2
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
end;
{$ENDIF}
{==============================================================================}
function LoadFromFieldStream(rv: TCustomRichView; Stream: TStream;
  FieldType: TFieldType): Boolean;
{$IFNDEF RVDONOTUSEUNICODE}
{$IFDEF RICHVIEWDEF2006}
var ws: WideString;
    StringStream: TStringStream;
    i, StyleNo: Integer;
{$ENDIF}
{$ENDIF}
begin
  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFDEF RICHVIEWDEF2006}
  Result := False;
  Stream.Position := 0;
  if (FieldType = ftWideMemo) and (Stream.Size mod 2 = 0) then begin
    SetLength(ws, Stream.Size div 2);
    Stream.ReadBuffer(Pointer(ws)^, Stream.Size);
    {$IFNDEF RVDONOTUSERTFIMPORT}
    if (Length(ws)>5) and (Copy(ws, 1, 5)='{\rtf') then begin
      StringStream := TStringStream.Create(ws);
      try
        Result := rv.LoadRTFFromStream(StringStream);
      finally
        StringStream.Free;
      end;
    end;
    {$ENDIF}
    if not Result then begin
      StyleNo := 0;
      for i := 0 to rv.Style.TextStyles.Count - 1 do
        if rv.Style.TextStyles[i].Unicode then begin
          StyleNo := i;
          break;
        end;
      rv.AddTextNLW(ws, StyleNo, 0, 0, False);
      Result := True;
    end;
    end
  else
  {$ENDIF}
  {$ENDIF}
    Result := rv.LoadFromStream(Stream, rvynaNo);
end;
{------------------------------------------------------------------------------}
procedure PaintRVCopy(Canvas: TCanvas; const R: TRect; Field: TField; src: TCustomRichView);
var rv: TCustomRichView;
    Stream: TRVMemoryStream;
    bmp: TBitmap;
begin
  if Field=nil then
    exit;
  rv := TCustomRichView.Create(nil);
  try
    rv.Visible := False;
    rv.SetBounds(0,0,src.Width, src.Height);
    rv.Parent := src.Parent;
    rv.Style := TRVStyle.Create(rv);
    rv.Style.TextStyles := src.Style.TextStyles;
    rv.Style.ParaStyles := src.Style.ParaStyles;
    rv.Style.ListStyles := src.Style.ListStyles;
    rv.Style.Color := src.Style.Color;
    rv.AssignEvents(src);
    rv.LeftMargin := src.LeftMargin;
    rv.RightMargin := src.RightMargin;
    rv.TopMargin := src.TopMargin;
    rv.BottomMargin := src.BottomMargin;
    rv.MinTextWidth := src.MinTextWidth;
    rv.MaxTextWidth := src.MaxTextWidth;
    rv.WordWrap := src.WordWrap;
    rv.MaxLength := src.MaxLength;
    rv.Options := src.Options;
    rv.RTFReadProperties.Assign(src.RTFReadProperties);
    rv.RVFOptions := src.RVFOptions;    
    rv.RVFTextStylesReadMode := src.RVFTextStylesReadMode;
    rv.RVFParaStylesReadMode := src.RVFParaStylesReadMode;
    rv.VScrollVisible := False;
    rv.HScrollVisible := False;
    rv.Color := src.Color;
    rv.BackgroundBitmap := src.BackgroundBitmap;
    rv.BackgroundStyle := src.BackgroundStyle;
    Stream := TRVMemoryStream.Create;
    try
      (Field as TBlobField).SaveToStream(Stream);
      Stream.Position := 0;
      LoadFromFieldStream(rv, Stream, Field.DataType);
      rv.Format;
      bmp := TBitmap.Create;
      try
        bmp.Width := rv.ClientWidth;
        bmp.Height := rv.ClientHeight;
        rv.PaintTo_(bmp.Canvas.Handle, 0, 0);
        Canvas.Draw(R.Left, R.Top, bmp);
      finally
        bmp.Free;
      end;
    finally
      Stream.Free;
    end;
  finally
    rv.Free;
  end;
end;
{============================DBRichView=================================}
constructor TDBRichView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FAutoDisplay := True;
end;
{-----------------------------------------------------------------------}
destructor TDBRichView.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;
{-----------------------------------------------------------------------}
function TDBRichView.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;
{-----------------------------------------------------------------------}
function TDBRichView.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;
{-----------------------------------------------------------------------}
function TDBRichView.GetField: TField;
begin
  Result := FDataLink.Field;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadField;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.DblClick;
begin
  if not FMemoLoaded then
    LoadField
  else
    inherited;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.LoadField;
var Stream: TRVMemoryStream;
    DoDefault: Boolean;
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and (Style<>nil) then
  begin
    Clear;
    try
      if not (FDataLink.Field is TBlobField) then begin
        AddNL(errFieldType,0,0);
        Format;
        Invalidate;
        exit;
      end;
      Stream := TRVMemoryStream.Create;
      try
        (FDataLink.Field as TBlobField).SaveToStream(Stream);
        if Assigned(FOnNewDocument) then
          FOnNewDocument(Self);
        Stream.Position := 0;
        DoDefault := True;
        if Assigned(FOnLoadCustomFormat) then
          FOnLoadCustomFormat(Self, Stream, DoDefault);
        if DoDefault then begin
          Stream.Position := 0;
          LoadFromFieldStream(Self, Stream, FDataLink.Field.DataType);
        end;
        if Assigned(FOnLoadDocument) then
          FOnLoadDocument(Self);
      finally
        Stream.Free;
      end;
      if RVData.Items.Count = 0 then AddNLATag('',0,0,0);
      FMemoLoaded := True;
    except
      on E:EInvalidOperation do
        AddFmt('(%s)', [E.Message],0,0);
    end;
    Format;
    Invalidate;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichView.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    if {FDataLink.Field.IsBlob} True then
      if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then begin
        FMemoLoaded := False;
        LoadField;
        end
      else begin
        FMemoLoaded := False;
        Clear;
        AddFmt('(%s)', [FDataLink.Field.DisplayLabel],0,0);
        Format;
        Invalidate;
      end
    else begin
      Clear;
      if FFocused and FDataLink.CanModify then
        {$IFDEF RVUNICODESTR}AddNLWTag{$ELSE}AddNLATag{$ENDIF}
          (FDataLink.Field.Text,0,0,0)
      else
        {$IFDEF RVUNICODESTR}AddNLWTag{$ELSE}AddNLATag{$ENDIF}
          (FDataLink.Field.DisplayText,0,0,0);
      if RVData.Items.Count = 0 then AddNLATag('',0,0,0);
      Format;
      Invalidate;
      FMemoLoaded := True;
    end
  else begin
    Clear;
    Format;
    Invalidate;
    FMemoLoaded := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure TDBRichView.Paint;
begin
  if (csPaintCopy in ControlState) then
    PaintRVCopy(Canvas, ClientRect, FDataLink.Field, Self)
  else
    inherited;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF4}
function TDBRichView.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;
{------------------------------------------------------------------------------}
function TDBRichView.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;
{$ENDIF}
{==========================DBRichViewEdit===============================}
constructor TDBRichViewEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  FieldFormat := rvdbRVF;
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataSaveStream := nil;
  RVData.Flags := RVData.Flags + [rvflDBRichViewEdit];
end;
{-----------------------------------------------------------------------}
destructor TDBRichViewEdit.Destroy;
begin
  FDataSaveStream.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.DoChange(ClearRedo: Boolean);
begin
  if FMemoLoaded then FDataLink.Modified;
  inherited DoChange(ClearRedo);
end;
{-----------------------------------------------------------------------}
function TDBRichViewEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;
{-----------------------------------------------------------------------}
function TDBRichViewEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;
{-----------------------------------------------------------------------}
function TDBRichViewEdit.DBGetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.DBSetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;
{-----------------------------------------------------------------------}
function TDBRichViewEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.LoadField;
begin
  DoLoadField(FMemoLoaded);
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.DoLoadField(Check: Boolean);
var Stream, Stream2: TRVMemoryStream;
    sf, equal, DoDefault: Boolean;
    {..............................}
    function HasFocus: Boolean;
    var ctrl: TWinControl;
    begin
      Result := True;
      ctrl := Self;
      while ctrl<>nil do begin
        if ctrl.Focused then
          exit;
        if ctrl is TCustomRichViewEdit then
          ctrl := TCustomRichViewEdit(ctrl).InplaceEditor
        else
          ctrl := nil;
      end;
      Result := False;;
    end;
    {..............................}
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and (Style<>nil)
    {and FDataLink.Field.IsBlob} then
  begin
    equal := False;
    sf := HasFocus;
    try
      if not (FDataLink.Field is TBlobField) then begin
        Clear;
        AddNL(errFieldType,0,0);
        DoFormat;
        Invalidate;
        exit;
      end;
      Stream := TRVMemoryStream.Create;
      try
        (FDataLink.Field as TBlobField).SaveToStream(Stream);
        Stream.Position := 0;
        if Check and (FieldFormat=rvdbRVF) then begin
          Stream2 := TRVMemoryStream.Create;
          try
            SaveRVFToStream(Stream2, False);
            equal := (Stream.Size=Stream2.Size) and
              CompareMem(Stream.Memory, Stream2.Memory, Stream.Size);
          finally
            Stream2.Free;
          end;
        end;
        if not equal then begin
          Clear;
          if FAutoDeleteUnusedStyles then
            DeleteUnusedStyles(True, True, True);
          if Assigned(FOnNewDocument) then
            FOnNewDocument(Self);
          DoDefault := True;
          if Assigned(FOnLoadCustomFormat) then
            FOnLoadCustomFormat(Self, Stream, DoDefault);
          if DoDefault then begin
            Stream.Position := 0;
            LoadFromFieldStream(Self, Stream, FDataLink.Field.DataType);
          end;
          if FAutoDeleteUnusedStyles then
            DeleteUnusedStyles(True, True, True);          
          if Assigned(FOnLoadDocument) then
            FOnLoadDocument(Self);
        end;
      finally
        Stream.Free;
      end;
      if RVData.Items.Count = 0 then AddNLATag('',0,0,0);
      FMemoLoaded := True;
    except
      on E:EInvalidOperation do
        AddFmt('(%s)', [E.Message], 0, 0);
    end;
    if not equal then begin
      DoFormat;
      if sf then
        Windows.SetFocus(Handle);
      Invalidate;
    end;
    EditingChange(Self);
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.BeginEditing;
begin
  if not FDataLink.Editing then
  try
    if {FDataLink.Field.IsBlob} True then begin
      if FDataSaveStream=nil then
        FDataSaveStream := TRVMemoryStream.Create
      else
        FDataSaveStream.Clear;
      (FDataLink.Field as TBlobField).SaveToStream(FDataSaveStream);
    end;
    FDataLink.Edit;
  finally
    FDataSaveStream.Free;
    FDataSaveStream := nil;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.DataChange(Sender: TObject);
var Stream: TRVMemoryStream;
    equal, ml: Boolean;
begin
  if FDataLink.Field <> nil then begin
    if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then begin
      if (FDataSaveStream <> nil) then begin
        Stream := TRVMemoryStream.Create;
        try
          (FDataLink.Field as TBlobField).SaveToStream(Stream);
          equal := (Stream.Size=FDataSaveStream.Size) and
            CompareMem(Stream.Memory, FDataSaveStream.Memory, FDataSaveStream.Size);
        finally
          Stream.Free;
        end;
        if equal then exit;
        PostMessage(Handle, WM_RVRELOAD, 0, 0);
        exit;
      end;
      ml := FMemoLoaded;
      FMemoLoaded := False;
      DoLoadField(ml);
      end
    else begin
      FMemoLoaded := False;
      Clear;
      AddFmt('(%s)', [FDataLink.Field.DisplayLabel],0,0);
      DoFormat;
      Invalidate;
    end;
    end
  else begin
    Clear;
    DoFormat;
    Invalidate;
    FMemoLoaded := False;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.WMReload(var Msg: TMessage);
var ml: Boolean;
begin
  ml := FMemoLoaded;
  FMemoLoaded := False;
  DoLoadField(ml);
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not (FDataLink.Editing {FDataLink.CanModify} and FMemoLoaded);
end;
{-----------------------------------------------------------------------}

procedure TDBRichViewEdit.UpdateData(Sender: TObject);
var Stream: TRVMemoryStream;
    DoDefault : Boolean;
    {...................................................................}
    {$IFNDEF RVDONOTUSERTF}
    {$IFDEF RICHVIEWDEF2006}
    procedure SaveWideRTF(Stream: TStream);
    {$IFNDEF RVDONOTUSEUNICODE}
    var StringStream: TStringStream;
        ws: WideString;
    {$ENDIF}
    begin
    {$IFNDEF RVDONOTUSEUNICODE}
      ws := '';
      StringStream := TStringStream.Create('');
      try
        RTFOptions := RTFOptions-[rvrtfSavePicturesBinary];
        SaveRTFToStream(StringStream, False);
        ws := StringStream.DataString;
      finally
        StringStream.Free;
      end;
      Stream.WriteBuffer(Pointer(ws)^, Length(ws)*2);
    {$ELSE}
      SaveRTFToStream(Stream, False);
    {$ENDIF}
    end;
    {$ENDIF}
    {$ENDIF}
    {...................................................................}
begin
  if {FDataLink.Field.IsBlob} True then begin
    Stream := TRVMemoryStream.Create;
    try
      DoDefault := True;
      if Assigned(FOnSaveCustomFormat) then
        FOnSaveCustomFormat(Self, Stream, DoDefault);
      if DoDefault then begin
        Stream.Position := 0;
        case FieldFormat of
          rvdbRVF {$IFDEF RVDONOTUSERTF}, rvdbRTF{$ENDIF}:
           begin
             //if FAutoDeleteUnusedStyles then
             //  DeleteUnusedStyles(True, True, True);
             {$IFDEF RICHVIEWDEF2006}
             {$IFNDEF RVDONOTUSERTF}
             if FDataLink.Field.DataType = ftWideMemo then
               SaveWideRTF(Stream)
             else
             {$ENDIF}
             {$ENDIF}
               SaveRVFToStream(Stream, False);
           end;
          {$IFNDEF RVDONOTUSERTF}
          rvdbRTF:
           begin
             //if FAutoDeleteUnusedStyles then
             //  DeleteUnusedStyles(True, True, True);
             {$IFDEF RICHVIEWDEF2006}
             {$IFNDEF RVDONOTUSEUNICODE}
             if FDataLink.Field.DataType = ftWideMemo then
               SaveWideRTF(Stream)
             else
             {$ENDIF}
             {$ENDIF}
               SaveRTFToStream(Stream, False);
           end;
          {$ENDIF}
          rvdbText:
            {$IFDEF RICHVIEWDEF2006}
            {$IFNDEF RVDONOTUSEUNICODE}
            if FDataLink.Field.DataType = ftWideMemo then
              SaveTextToStreamW('', Stream, 80, False, True)
            else
            {$ENDIF}
            {$ENDIF}
              SaveTextToStream('', Stream, 80, False, True);
        end;
      end;
      Stream.Position := 0;
      (FDataLink.Field as TBlobField).LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not (rvstClearing in RVData.State) and  not Assigned(FDataLink.Field) {or not FDataLink.Field.IsBlob} then
      FDataLink.Reset;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.CMEnter(var Message: TCMEnter);
begin
//  if not FMemoLoaded then LoadField;
  SetFocused(True);
  inherited;
  if {$IFDEF RICHVIEWCBDEF3}SysLocale.FarEast and{$ENDIF}
     {FDataLink.CanModify}FDataLink.Editing then
    inherited ReadOnly := False;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.CMExit(var Message: TCMExit);
begin
  if rvstNoDBExitUpdate in RVData.State then
    exit;
  try
    with FDataLink do
      if (DataSet <> nil) and (DataSet.State in dsEditModes) then
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  inherited;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then
      DoLoadField(FMemoLoaded);
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.DblClick;
begin
  if not FMemoLoaded then
    DoLoadField(FMemoLoaded)
  else
    inherited;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FMemoLoaded and (Key=#27) and not IgnoreEscape then
    FDataLink.Reset;
  if not FMemoLoaded and (Key=#13) then begin
    DoLoadField(FMemoLoaded);
    Key := #0;
  end;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;
{-----------------------------------------------------------------------}
function TDBRichViewEdit.BeforeChange(FromOutside: Boolean): Boolean;
begin
  if FMemoLoaded then BeginEditing;
  Result := inherited BeforeChange(FromOutside);
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.Paint;
begin
  if (csPaintCopy in ControlState) then
    PaintRVCopy(Canvas, ClientRect, FDataLink.Field, Self)
  else
    inherited;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.DoFormat;
begin
  Format;
end;
{-----------------------------------------------------------------------}
procedure TDBRichViewEdit.CMWantSpecialKey(var Message: TCMWantSpecialKey);
begin
  inherited;
  if not IgnoreEscape and (Message.CharCode = VK_ESCAPE) then
    Message.Result := 1;
end;
{-----------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF4}
function TDBRichViewEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;
{-----------------------------------------------------------------------}
function TDBRichViewEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;
{$ENDIF}
{=======================================================================}
procedure Register;
begin
  RegisterComponents('RichView', [TDBRichView, TDBRichViewEdit]);
end;


end.
