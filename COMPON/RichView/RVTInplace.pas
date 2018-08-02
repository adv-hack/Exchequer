
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVTableInplaceEdit: table cell editor.         }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVTInplace;

interface

{$I RV_Defs.inc}

uses
    Windows, Messages, SysUtils, Classes, Graphics,
    Controls, Forms,
    RVStyle, RVFuncs, RVItem,
    CRVData, CRVFData, RVRVData, RVERVData,
    RVScroll, RichView, RVEdit,
    RVRTFProps, RichEdit,
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    RVDocParams,
    {$ENDIF}
    RVTable, RVBack, RVGrIn, RVTypes;

const WM_RVMOVEEDITOR = WM_USER+10;
      WM_RVINPLACEUNDO = WM_USER+11;
      WM_RVINPLACEREDO = WM_USER+12;
      WM_RVEXPANDSEL = WM_USER+18;

type
  TRVTableInplaceRVData = class (TRVEditRVData)
    private
      resized: Boolean;
    protected
      //procedure Formatted(FirstItemNo, LastItemNo: Integer;Partial: Boolean); override;
      function GetSoftPageBreaks: TRVSoftPageBreakList; override;
    public
      DrawOnParentMode: Boolean;
      function GetBackground: TRVBackground; override;
      procedure DrawBackground(Canvas: TCanvas; r: TRect;
        GraphicInterface: TRVGraphicInterface); override;
      procedure GetParentInfo(var ParentItemNo: Integer;
                            var Location: TRVStoreSubRVData); override;
      function CanLoadLayout: Boolean; override;
      function GetSourceRVData: TCustomRVData; override;
      procedure ShowRectangle(Left, Top, Width, Height: Integer); override;
      procedure SetDocumentAreaSize(Width,Height: Integer; UpdateH: Boolean); override;
      function BuildJumpsCoords(IgnoreReadOnly: Boolean): Integer; override;
      function ReallyBuildJumpsCoords: Integer;
      procedure ClearJumpsCoords; override;
      procedure GetOriginEx(var ALeft, ATop: Integer); override;
      function GetAbsoluteParentData: TCustomRVData; override;
      function GetAbsoluteRootData: TCustomRVData; override;
      procedure DoRVDblClick(const ClickedWord: TRVRawByteString; StyleNo: Integer); override;
      procedure DoJump(id: Integer); override;
      procedure GetItemBackground(ItemNo: Integer; r: TRect; MakeImageRect: Boolean;
        var Color: TColor;
        var bmp: TBitmap; var UseBitmap: Boolean;
        GraphicInterface: TRVGraphicInterface); override;
      {$IFNDEF RVDONOTUSEITEMHINTS}
      function GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
        const UpperRVDataHint: String): String; override;
      {$ENDIF}
      function GetHOffs: Integer; override;
      function GetVOffs: Integer; override;
  end;

  TRVTableInplaceChangeEvent = procedure (Sender: TCustomRichViewEdit; ClearRedo: Boolean) of object;

  TRVTableInplaceEdit = class (TRichViewEdit)
    private
      FRVData: TCustomRVFormattedData;
      FTable: TRVTableItemInfo;
      FClearing: Boolean;
      //FOnFormat: TNotifyEvent;
      FColor: TColor;
      //FBusy: Boolean;
      FOnChangeEx: TRVTableInplaceChangeEvent;
      FTransparent: Boolean;
      procedure CMRelease(var Message: TMessage); message CM_RELEASE;
      procedure WMMoveEditor(var Message: TMessage); message WM_RVMOVEEDITOR;
      procedure WMExpandSel(var Message: TMessage); message WM_RVEXPANDSEL;
      procedure WMInplaceUndo(var Message: TMessage); message WM_RVINPLACEUNDO;
      procedure WMInplaceRedo(var Message: TMessage); message WM_RVINPLACEREDO;
      procedure WMUndo(var Message: TMessage); message WM_UNDO;
      procedure EMUndo(var Message: TMessage); message EM_UNDO;
      procedure EMRedo(var Message: TMessage); message EM_REDO;
      procedure EMCanUndo(var Message: TMessage); message EM_CANUNDO;
      procedure EMCanRedo(var Message: TMessage); message EM_CANREDO;
    protected
      function GetDataClass: TRichViewRVDataClass; override;
      procedure KeyPress(var Key: Char); override;
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
      function GetRTFReadProperties: TRVRTFReaderProperties; override;
      {$IFNDEF RVDONOTUSEDOCPARAMS}
      function GetDocParameters: TRVDocParameters; override;
      {$ENDIF}
      procedure WndProc(var Message: TMessage); override;
      procedure SetReadOnly(const Value: Boolean); override;
      function GetReadOnly: Boolean; override;
      procedure InplaceRedrawing(AllowRedrawItself: Boolean); override;
      procedure Paint; override;
    public
      FClickTime: Longint;
      FTableItemNo: Integer;
      FCell: TRVTableCellData;
      FRow, FCol: Integer;
      NormalScrolling: Boolean;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function RTFReaderAssigned: Boolean; override;
      {$IFNDEF RVDONOTUSEDOCPARAMS}
      function DocParametersAssigned: Boolean; override;
      {$ENDIF}
      procedure DoChange(ClearRedo: Boolean); override;
      procedure SetParentRVData(RVData: TCustomRVFormattedData);
      procedure SetCell(Row, Col: Integer; Table: TRVTableItemInfo;
        CellHPadding, CellVPadding: Integer);
      procedure SetVPos(p: Integer; Redraw: Boolean);override;
      procedure SetHPos(p: Integer);override;
      procedure SetClearingState;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      procedure SelectCompletely(Select: Boolean);
      function BeforeChange(FromOutside: Boolean): Boolean; override;
      function Resized: Boolean;
      procedure Undo; override;
      procedure Redo; override;
      procedure Click; override;
      procedure DragDrop(Source: TObject; X, Y: Integer); override;
      procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
      //procedure DblClick; override;
      //property OnFormat: TNotifyEvent read FOnFormat write FOnFormat;
      //property Busy: Boolean read FBusy;
      property OnChangeEx: TRVTableInplaceChangeEvent read FOnChangeEx write FOnChangeEx;
      property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
      property Transparent: Boolean read FTransparent write FTransparent;
      property Table: TRVTableItemInfo read FTable;
  end;

implementation
uses RVUndo;
{=============================== TRVTableInplaceEdit ==========================}
constructor TRVTableInplaceEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  Visible := False;
  Flags := Flags - [rvflRootEditor,rvflRoot];
  {$IFDEF RICHVIEWDEF4}
  WheelStep := 0;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceEdit.GetDataClass: TRichViewRVDataClass;
begin
  Result := TRVTableInplaceRVData;
end;
{------------------------------------------------------------------------------}
destructor TRVTableInplaceEdit.Destroy;
begin
  Destroying;
  if FClearing and (InplaceEditor<>nil) and (InplaceEditor is TRVTableInplaceEdit) then
    TRVTableInplaceEdit(InplaceEditor).SetClearingState;
  DestroyInplace;
  FRVData.UnAssignChosenRVData(FCell);
  FTable.InplaceDeleted(FClearing);
  if not FClearing and (Parent<>nil) and (Parent is TCustomRichView) then
  TCustomRichView(Parent).SetFocusSilent;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SetCell(Row, Col: Integer; Table: TRVTableItemInfo;
  CellHPadding, CellVPadding: Integer);
begin
  FRow  := Row;
  FCol  := Col;
  FCell  := Table.Cells[Row,Col];
  FTable := Table;
  FTableItemNo := FRVData.GetItemNo(FTable);
  LeftMargin   := CellHPadding;
  TopMargin    := CellVPadding;
  RightMargin  := CellHPadding;
  BottomMargin := CellVPadding;
  TRVEditRVData(RVData).UndoList.FRVData := TCustomRVFormattedData(RVData.GetAbsoluteRootData);
  TRVEditRVData(RVData).RedoList.FRVData := TCustomRVFormattedData(RVData.GetAbsoluteRootData);
  if rvstNoSpecialCharacters in FCell.State then
    RVData.State := RVData.State + [rvstNoSpecialCharacters];
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SetParentRVData(RVData: TCustomRVFormattedData);
begin
  FRVData    := RVData;
  Options    := RVData.Options;
  RVFOptions := RVData.RVFOptions;
  RTFOptions := RVData.RTFOptions;
  Style      := RVData.GetRVStyle;
  VSmallStep := 1;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SetVPos(p: Integer; Redraw: Boolean);
begin
  if NormalScrolling then
    inherited;
  // else no scroll
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SetHPos(p: Integer);
begin
  // no scroll
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SetClearingState;
begin
  FClearing := True;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceEdit.Resized: Boolean;
begin
  Result := TRVTableInplaceRVData(RVData).Resized;
  TRVTableInplaceRVData(RVData).Resized := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbLeft) and (rvstMakingSelection in RVData.State) then begin
    MouseUp(mbLeft, Shift, X, Y);
    //RVData.State := RVData.State-[rvstIgnoreNextMouseDown];
  end;
  inherited;
  if (Button=mbLeft) and not (rvstStartingDragDrop in RVData.GetAbsoluteRootData.State) and
    FTable.StartSelecting(FRow,FCol,False) then begin
    if (FRVData is TRichViewRVData)  then
      TCustomRichView(TRichViewRVData(FRVData).RichView).ActivateScrollTimer(False);
    //FBusy := True;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceEdit.BeforeChange(FromOutside: Boolean): Boolean;
begin
  if (FRVData is TRVEditRVData)  then
    Result := TCustomRichViewEdit(TRichViewRVData(FRVData).RichView).BeforeChange(True)
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
// var data: TRVMouseMoveMessageData;
//    p: TPoint;
begin
  if not (ssLeft in Shift) and (rvstMakingSelection in RVData.State) then begin
    MouseUp(mbLeft, Shift, X, Y);
    //RVData.State := RVData.State-[rvstIgnoreNextMouseDown];
  end;
  if (ssLeft in Shift) and
     (rvstMakingSelection in RVData.State) and
    (FRVData is TRichViewRVData) then
    TCustomRichView(TRichViewRVData(FRVData).RichView).MouseMove(Shift, X+Left, Y+Top);

  inherited;

  {
  data := TRVMouseMoveMessageData.Create;
  data.Event := rvetMouseMove;
  p := ClientToScreen(Point(X,Y));
  p := RVData.GetAbsoluteRootData.GetParentControl.ScreenToClient(p);
  data.X := p.X;
  data.Y := p.Y;
  data.Shift := Shift;
  PostMessage(RVData.GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
  }
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var OnMUp: TRVMouseEvent;
    ParentRichView: TCustomRichView;
begin
  if (Button in [mbLeft,mbRight]) and (GetCaptureControl=Self) then
    ReleaseCapture;
  inherited;
  if (Button=mbLeft) then begin
    //FBusy := False;
    if FTable.FMakingSelection and
       (FRVData is TRichViewRVData) then begin
      ParentRichView := TCustomRichView(TRichViewRVData(FRVData).RichView);
      OnMUp := ParentRichView.OnRVMouseUp;
      ParentRichView.OnRVMouseUp := nil;
      try
        ParentRichView.MouseUp(Button, Shift, X+Left, Y+Top);
      finally
        ParentRichView.OnRVMouseUp := OnMUp;
      end;
      if (rvstCompletelySelected in RVData.State) then
        PostMessage(Handle, CM_RELEASE, 0, 0)
      else
        SelectCompletely(False);
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SelectCompletely(Select: Boolean);
begin
  if Select = (rvstCompletelySelected in  RVData.State) then
    exit;
  if Select then begin
    RVData.State := RVData.State + [rvstCompletelySelected];
    FColor := Color;
    Color := Style.SelColor;
    end
  else begin
    RVData.State := RVData.State - [rvstCompletelySelected];
    Color := FColor;
  end;
  TRVEditRVData(RVData).ChangeCaret(True, False, True, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.CMRelease(var Message: TMessage);
var AParent: TWinControl;
begin
  AParent := Parent;
  FCell.GetTable.UpdateStoredInplaceSelection;
  Free;
  if (AParent<>nil) and (AParent.Visible) then
    AParent.SetFocus;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.WMMoveEditor(var Message: TMessage);
var NewRow, NewCol: Integer;
    dir: TRVCellDirection;
    AParent: TWinControl;
    idx, offs: Integer;
    LTable: TRVTableItemInfo;
    LTableItemNo: Integer;
begin
  AParent := Parent;
  LTable := FTable;              // inplace editor can be destroyed in GetCellTo,
  LTableItemNo := FTableItemNo;  // so copying fields to local variables
  dir := TRVCellDirection(Message.WParam);
  case dir of
    rvcdDocTop:
      begin
        idx := 0;
        offs := FRVData.GetRootData.GetOffsBeforeItem(idx);
        TCustomRVFormattedData(FRVData.GetRootData).SetSelectionBounds(idx,offs,idx,offs);
        AParent.SetFocus;
        exit;
      end;
    rvcdDocBottom:
      begin
        idx := FRVData.GetRootData.Items.Count-1;
        offs := FRVData.GetRootData.GetOffsAfterItem(idx);
        TCustomRVFormattedData(FRVData.GetRootData).SetSelectionBounds(idx,offs,idx,offs);
        AParent.SetFocus;
        exit;
      end;
  end;
  if LTable.GetCellTo(FRow,FCol, dir, NewRow,NewCol, False, RichViewTableAutoAddRow) then begin
    LTable.CreateInplace(LTableItemNo, NewRow, NewCol, False,
           dir in [rvcdRight, rvcdDown, rvcdNext],
           dir in [rvcdLeft, rvcdUp, rvcdPrev], False, False);
    end
  else begin
    if ((FCol=0) and (dir = rvcdLeft)) or
       ((FRow=0) and (dir = rvcdUp)) then begin
      FRVData.SetSelectionBounds(LTableItemNo,0,LTableItemNo,0);
      AParent.SetFocus;
      end
    else if ((FCol+FCell.ColSpan=LTable.Rows[FRow].Count) and (dir = rvcdRight)) or
       ((FRow+FCell.RowSpan=LTable.Rows.Count) and (dir = rvcdDown)) then begin
      FRVData.SetSelectionBounds(LTableItemNo,1,LTableItemNo,1);
      AParent.SetFocus;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.WMExpandSel(var Message: TMessage);
var AParent: TWinControl;
    LTable: TRVTableItemInfo;
begin
  AParent := Parent;              // inplace editor will be destroyed,
  LTable := FTable;               // so copying fields to local variables

  LTable.StartSelecting(FRow, FCol, True);
  Free;
  AParent.SetFocus;
  LTable.KeyDown(Message.WParam, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=VK_TAB then begin
    if ssCtrl in Shift then
      inherited
    else if ssShift in Shift then
      PostMessage(Handle, WM_RVMOVEEDITOR, ord(rvcdPrev),  0)
    else
      PostMessage(Handle, WM_RVMOVEEDITOR, ord(rvcdNext),  0);
    Key := 0;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.KeyPress(var Key: Char);
begin

  if (Key=Chr(VK_TAB)) and (GetAsyncKeyState(VK_CONTROL)and $8000=0) then
    Key := #0
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.DoChange(ClearRedo: Boolean);
begin
  inherited DoChange(ClearRedo);
  if Assigned(FOnChangeEx) then
    FOnChangeEx(Self,ClearRedo);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.Redo;
begin
  if RedoAction<>rvutNone then
    inherited Redo
  else
    TCustomRichViewEdit((FRVData as TRVEditRVData).RichView).Redo;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.Undo;
begin
  if UndoAction<>rvutNone then
    inherited Undo
  else
    TCustomRichViewEdit((FRVData as TRVEditRVData).RichView).Undo;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.WMInplaceRedo(var Message: TMessage);
begin
  ReadOnly := False;
  Redo;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.WMInplaceUndo(var Message: TMessage);
begin
  ReadOnly := False;
  Undo;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceEdit.GetRTFReadProperties: TRVRTFReaderProperties;
begin
  Result := TCustomRichView(TRichViewRVData(FRVData).RichView).RTFReadProperties;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDOCPARAMS}
function TRVTableInplaceEdit.GetDocParameters: TRVDocParameters;
begin
  Result := TCustomRichView(TRichViewRVData(FRVData).RichView).DocParameters;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTableInplaceEdit.RTFReaderAssigned: Boolean;
begin
  Result := TCustomRichView(TRichViewRVData(FRVData).RichView).RTFReaderAssigned;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDOCPARAMS}
function TRVTableInplaceEdit.DocParametersAssigned: Boolean;
begin
  Result := TCustomRichView(TRichViewRVData(FRVData).RichView).DocParametersAssigned;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.WndProc(var Message: TMessage);
{$IFDEF RICHVIEWDEF2006}
var Panned: Boolean;
{$ENDIF}
var data: TRVTripleClickMessageData;
begin
  case Message.Msg of
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK
        else
          FClickTime := 0;
      end;
    WM_LBUTTONDBLCLK:
      begin
        if FClickTime<>0 then begin
          data := TRVTripleClickMessageData.Create;
          data.Event := rvetTripleClick;
          PostMessage(RVData.GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
          FDblClickTime := 0;
          exit;
          FClickTime := 0;
        end;
      end;
    {$IFDEF RICHVIEWDEF2006}
    WM_MBUTTONDOWN:
      begin
        if (csPannable in GetRootEditor.ControlStyle) and
        (GetRootEditor.ControlState * [csDestroyingHandle, csPanning] = []) and
        not Mouse.IsDragging then begin
          Mouse.CreatePanningWindow;
          Panned := False;
          if Assigned(Mouse.PanningWindow) then
            Panned := Mouse.PanningWindow.StartPanning(TWinControl(GetRootEditor).Handle, GetRootEditor);
          if Panned then begin
            Message.Result := 1;
            Application.HideHint;
            end
          else
           if Assigned(Mouse.PanningWindow) then
             Mouse.PanningWindow := nil;
        end;
        exit;
      end;
    {$ENDIF}
  end;
  inherited WndProc(Message);
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceEdit.GetReadOnly: Boolean;
begin
  if (FRVData is TRVEditRVData)  then
    Result := TCustomRichViewEdit(TRichViewRVData(FRVData).RichView).ReadOnly
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.SetReadOnly(const Value: Boolean);
begin
  if (FRVData is TRVEditRVData) then
    TCustomRichViewEdit(TRichViewRVData(FRVData).RichView).ReadOnly := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.EMRedo(var Message: TMessage);
begin
  Message.Result := SendMessage(Parent.Handle,EM_REDO,Message.WParam,Message.LParam);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.EMUndo(var Message: TMessage);
begin
  Message.Result := SendMessage(Parent.Handle,EM_UNDO,Message.WParam,Message.LParam);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.WMUndo(var Message: TMessage);
begin
  Message.Result := SendMessage(Parent.Handle,WM_UNDO,Message.WParam,Message.LParam);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.EMCanRedo(var Message: TMessage);
begin
  Message.Result := SendMessage(Parent.Handle,EM_CANREDO,Message.WParam,Message.LParam);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.EMCanUndo(var Message: TMessage);
begin
  Message.Result := SendMessage(Parent.Handle,EM_CANUNDO,Message.WParam,Message.LParam);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.Click;
var data: TRVClickMessageData;
begin
  data := TRVClickMessageData.Create;
  data.Event := rvetClick;
  PostMessage(RVData.GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
end;
{------------------------------------------------------------------------------}
{
procedure TRVTableInplaceEdit.DblClick;
var data: TRVStdDblClickMessageData;
begin
  data := TRVStdDblClickMessageData.Create;
  data.Event := rvetDblClick;
  PostMessage(RVData.GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
end;
}
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.DoEndDrag(Target: TObject; X, Y: Integer);
var data: TRVDNDMessageData;
    p: TPoint;
begin
  data := TRVDNDMessageData.Create;
  data.Event := rvetEndDrag;
  p := ClientToScreen(Point(X,Y));
  p := RVData.GetAbsoluteRootData.GetParentControl.ScreenToClient(p);
  data.X := p.X;
  data.Y := p.Y;
  data.Obj := Target;
  PostMessage(RVData.GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.DragDrop(Source: TObject; X, Y: Integer);
var data: TRVDNDMessageData;
    p: TPoint;
begin
  data := TRVDNDMessageData.Create;
  data.Event := rvetDragDrop;
  p := ClientToScreen(Point(X,Y));
  p := RVData.GetAbsoluteRootData.GetParentControl.ScreenToClient(p);
  data.X := p.X;
  data.Y := p.Y;
  data.Obj := Source;
  PostMessage(RVData.GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.InplaceRedrawing(AllowRedrawItself: Boolean);
begin
  if not Transparent then
    exit;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceEdit.Paint;

var GridStyle: TPenStyle;
    VAlign: TRVCellVAlign;

begin
  inherited Paint;

  if ReadOnly then
    GridStyle := RichViewTableGridStyle2
  else
    GridStyle := RichViewTableGridStyle;
  if (GridStyle=psClear) or (RichViewTableGridColor=clNone) then
    Exit;
  VAlign := FCell.VAlign;
  if VAlign=rvcVDefault then
    VAlign := FCell.GetTable.Rows[FRow].VAlign;
  if VAlign=rvcVDefault then
    VAlign := rvcMiddle;
  if (FCell.GetTable.CellBorderWidth=0) or
    not FCell.VisibleBorders.IsAllEqual(True) then begin
    Canvas.Pen.Color := RichViewTableGridColor;
    Canvas.Pen.Style := GridStyle;
    Canvas.Pen.Width := 1;
    Canvas.Brush.Style := bsClear;
  end;
  if (FCell.GetTable.CellBorderWidth=0) and (VAlign=rvcTop) then
    Style.GraphicInterface.Rectangle(Canvas, 0, 0, ClientWidth, ClientHeight)
  else begin
    if not FCell.VisibleBorders.Left or (FCell.GetTable.CellBorderWidth=0) then
      Style.GraphicInterface.Line(Canvas, 0,0, 0,ClientHeight);
    if not FCell.VisibleBorders.Right or (FCell.GetTable.CellBorderWidth=0) then
      Style.GraphicInterface.Line(Canvas, ClientWidth-1,0, ClientWidth-1,ClientHeight);
    if (not FCell.VisibleBorders.Top or (FCell.GetTable.CellBorderWidth=0)) and (Height=FCell.Height) then
      Style.GraphicInterface.Line(Canvas, 0,0, ClientWidth,0);
    if not FCell.VisibleBorders.Bottom or (FCell.GetTable.CellBorderWidth=0) then
      Style.GraphicInterface.Line(Canvas, 0,ClientHeight-1, ClientWidth,ClientHeight-1);
  end;

end;
{========================= TRVTableInplaceRVData ==============================}
function TRVTableInplaceRVData.BuildJumpsCoords(IgnoreReadOnly: Boolean): Integer;
begin
  TRVEditRVData(TRVTableInplaceEdit(RichView).FRVData).BuildJumpsCoords(IgnoreReadOnly);
  Result := -100;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.ReallyBuildJumpsCoords: Integer;
begin
  Result := inherited BuildJumpsCoords(True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.ClearJumpsCoords;
begin
  TRVEditRVData(TRVTableInplaceEdit(RichView).FRVData).ClearJumpsCoords;
  inherited ClearJumpsCoords;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetSoftPageBreaks: TRVSoftPageBreakList;
begin
  Result := TRVTableInplaceEdit(FRichView).FCell.SoftPageBreaks;
end;
{------------------------------------------------------------------------------}
{
procedure TRVTableInplaceRVData.Formatted(FirstItemNo, LastItemNo: Integer;Partial: Boolean);
begin
  if Assigned(TRVTableInplaceEdit(FRichView).OnFormat) then
    TRVTableInplaceEdit(FRichView).OnFormat(FRichView);
end;
}
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.SetDocumentAreaSize(Width, Height: Integer; UpdateH: Boolean);
begin
  inherited;
  Resized := True;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.ShowRectangle(Left, Top, Width, Height: Integer);
var ParentRVData: TCustomRVFormattedData;
begin
  if TRVTableInplaceEdit(FRichView).NormalScrolling then
    inherited
  else begin
    ParentRVData := TRVTableInplaceEdit(FRichView).FRVData;
    ParentRVData.ShowRectangle(
      ParentRVData.GetHOffs+FRichView.Left+Left,
      ParentRVData.GetVOffs+FRichView.Top+Top,
      Width, Height);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.GetOriginEx(var ALeft, ATop: Integer);
begin
  TRVTableInplaceEdit(FRichView).FCell.GetOriginEx(ALeft, ATop);
  dec(ALeft, GetRVStyle.GetAsPixels(TRVTableInplaceEdit(FRichView).FTable.CellHPadding));
  dec(ATop, GetRVStyle.GetAsPixels(TRVTableInplaceEdit(FRichView).FTable.CellVPadding));
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetSourceRVData: TCustomRVData;
begin
  Result := TRVTableInplaceEdit(FRichView).FCell;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.CanLoadLayout: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetAbsoluteParentData: TCustomRVData;
begin
  if GetSourceRVData<>nil then
    Result := GetSourceRVData.GetAbsoluteParentData
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetAbsoluteRootData: TCustomRVData;
begin
  if GetSourceRVData<>nil then
    Result := GetSourceRVData.GetAbsoluteRootData
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.GetParentInfo(var ParentItemNo: Integer;
  var Location: TRVStoreSubRVData);
begin
  GetSourceRVData.GetParentInfo(ParentItemNo,Location);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.DoRVDblClick(const ClickedWord: TRVRawByteString;
  StyleNo: Integer);
var data: TRVDblClickMessageData;
begin
  data := TRVDblClickMessageData.Create;
  data.Event := rvetRVDblClick;
  data.ClickedWord := ClickedWord;
  data.StyleNo := StyleNo;
  PostMessage(GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.DoJump(id: Integer);
var data: TRVJumpMessageData;
begin
  data := TRVJumpMessageData.Create;
  data.Event := rvetJump;
  data.id := id;
  PostMessage(GetAbsoluteRootData.GetParentControl.Handle, WM_RVEVENT, Integer(Data), 0);
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.DrawBackground(Canvas: TCanvas; r: TRect;
  GraphicInterface: TRVGraphicInterface);
var ParentEditor: TCustomRichView;
    r2: TRect;
    Cell: TRVTableCellData;
    //stb: Boolean;
begin
  Cell := TRVTableCellData(GetSourceRVData);
  if not Cell.IsTransparent or (rvstCompletelySelected in GetSourceRVData.State) then begin
    GetBackground.Draw(Canvas, r, GetHOffs, GetVOffs, 0, -Cell.GetExtraVOffs,
    GetWidth, GetHeight+Cell.GetExtraVOffs, GetColor, False, False,
    GraphicInterface);
    exit;
  end;
  //stb := Cell.GetTable.IsSemiTransparentBackground;
  if TRVTableInplaceEdit(RichView).Transparent then begin
    ParentEditor := TCustomRichView(TRVTableInplaceEdit(FRichView).Parent);
    r2 := r;
    OffsetRect(r2, FRichView.Left, FRichView.Top);
    ParentEditor.RVData.DrawBackground(Canvas, r2, GraphicInterface);
  end;
  Cell.GetTable.DrawBackgroundUnderCell(Canvas, Cell, r, GraphicInterface);
  if (Cell.GetBackground<>nil) and (Cell.Color=clNone) then
    GetBackground.Draw(Canvas, r, GetHOffs, GetVOffs, 0, -Cell.GetExtraVOffs,
      GetWidth, GetHeight+Cell.GetExtraVOffs, Cell.Color, False, False,
      GraphicInterface);
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetBackground: TRVBackground;
begin
  if (rvstCompletelySelected in GetSourceRVData.State) or
     (TCustomRVFormattedData(GetSourceRVData).GetBackground=nil) then
    Result := TCustomRichView(RichView).Background
  else
    Result := TCustomRVFormattedData(GetSourceRVData).GetBackground;
end;
{------------------------------------------------------------------------------}
procedure TRVTableInplaceRVData.GetItemBackground(ItemNo: Integer;
  r: TRect; MakeImageRect: Boolean; var Color: TColor; var bmp: TBitmap;
  var UseBitmap: Boolean; GraphicInterface: TRVGraphicInterface);
begin
  TCustomRVFormattedData(GetSourceRVData).GetItemBackground(ItemNo,
    r, MakeImageRect, Color, bmp, UseBitmap, GraphicInterface);

end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEITEMHINTS}
function TRVTableInplaceRVData.GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
  const UpperRVDataHint: String): String;
begin
  Result := TCustomRVFormattedData(GetSourceRVData).GetItemHint(RVData, ItemNo,
    UpperRVDataHint);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetHOffs: Integer;
begin
  if not DrawOnParentMode then
    Result := inherited GetHOffs
  else
    Result := TRVTableCellData(GetSourceRVData).GetHOffs+
      GetRVStyle.GetAsPixels(TRVTableCellData(GetSourceRVData).GetTable.CellHPadding);
end;
{------------------------------------------------------------------------------}
function TRVTableInplaceRVData.GetVOffs: Integer;
begin
  if not DrawOnParentMode then
    Result := inherited GetVOffs
  else
    Result := TRVTableCellData(GetSourceRVData).GetVOffs+
      GetRVStyle.GetAsPixels(TRVTableCellData(GetSourceRVData).GetTable.CellVPadding);
end;



end.
