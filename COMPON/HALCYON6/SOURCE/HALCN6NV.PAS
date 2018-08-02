unit Halcn6Nv;
{$I gs6_flag.pas}
interface

uses Windows, SysUtils, SysHalc, Messages, Classes, Controls, Forms,
     Dialogs, Graphics, Menus, StdCtrls, ExtCtrls, Buttons, DB;


resourcestring
  SFirstRecord = 'First record';
  SPriorRecord = 'Prior record';
  SNextRecord = 'Next record';
  SLastRecord = 'Last record'; 
  SInsertRecord = 'Append record';
  SDeleteRecord = 'Delete record';
  SEditRecord = 'Edit record';
  SPostEdit = 'Save record';
  SCopyRecord = ' Copy record';
  SFindRecord = 'Find record';
  SCancelEdit = 'Cancel edit';
  SRefreshRecord = 'Refresh data';
  SDeleteRecordQuestion = 'Delete record?';

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

type
   THalcyonNavButton = class;
   THalcyonNavDataLink = class;

   THalcyonNavDirection = (nbHorz,nbVert);
   THalcyonNavGlyph = (ngEnabled, ngDisabled);
   THalcyonNavigateBtn = (nbTop, nbPrev, nbNext, nbBttm, nbInsert, nbCopy,
                   nbEdit, nbDelete, nbPost, nbCancel, nbFind, nbRefresh);
   THalcyonButtonSet = set of THalcyonNavigateBtn;
   THalcyonNavButtonStyle = set of (nsAllowTimer, nsFocusRect);

   EHalcyonNavClick = procedure (Sender: TObject; Button: THalcyonNavigateBtn) of object;

{ THalcyonNavigator }

  THalcyonNavigator = class (TCustomPanel)
  private
    FDataLink: THalcyonNavDataLink;
    FVisibleButtons: THalcyonButtonSet;
    FHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: EHalcyonNavClick;
    FBeforeAction: EHalcyonNavClick;
    FocusedButton: THalcyonNavigateBtn;
    FConfirmDelete: Boolean;
    FFlat: Boolean;
    FDoCopy: TDataSetNotifyEvent;
    FDoFind: TDataSetNotifyEvent;
    procedure ClickHandler(Sender: TObject);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure InitButtons;
    procedure InitHints;
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetVisible(Value: THAlcyonButtonSet);
    procedure AdjustNavSize (var W: Integer; var H: Integer);
    procedure HintsChanged(Sender: TObject);
    procedure SetHints(Value: TStrings);
    procedure SetFlat(Value: Boolean);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    Buttons: array[THalcyonNavigateBtn] of THalcyonNavButton;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: THalcyonNavigateBtn);
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property VisibleButtons: THalcyonButtonSet read FVisibleButtons write SetVisible
               default [nbTop, nbPrev, nbNext, nbBttm, nbInsert, nbCopy,
                        nbDelete, nbEdit, nbPost, nbCancel, nbFind,
                        nbRefresh];
    property Align;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Ctl3D;
    property Hints: TStrings read FHints write SetHints;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property BeforeAction: EHalcyonNavClick read FBeforeAction write FBeforeAction;
    property OnClick: EHalcyonNavClick read FOnNavClick write FOnNavClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDrag;
    property OnCopyClick: TDataSetNotifyEvent read FDoCopy write FDoCopy;
    property OnFindClick: TDataSetNotifyEvent read FDoFind write FDoFind;
  end;

{ THalcyonNavButton }

  THalcyonNavButton = class(TSpeedButton)
  private
    FIndex: THalcyonNavigateBtn;
    FNavStyle: THalcyonNavButtonStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    destructor Destroy; override;
    property NavStyle: THalcyonNavButtonStyle read FNavStyle write FNavStyle;
    property Index : THalcyonNavigateBtn read FIndex write FIndex;
  end;

{ THalcyonNavDataLink }

  THalcyonNavDataLink = class(TDataLink)
  private
    FNavigator: THalcyonNavigator;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: THalcyonNavigator);
    destructor Destroy; override;
  end;


implementation
{$R HALCN6NV.RES}

const
   BtnTypeName: array[THalcyonNavigateBtn] of PChar = ('TOP', 'PREVIOUS', 'NEXT',
                   'BOTTOM', 'APPEND', 'COPY', 'EDIT', 'DELETE',
                   'SAVE', 'CANCEL', 'FIND', 'REFRESH');
   BtnHintId: array[THalcyonNavigateBtn] of String = (SFirstRecord, SPriorRecord,
        SNextRecord, SLastRecord, SInsertRecord, SCopyRecord, SEditRecord,
        SDeleteRecord, SPostEdit, SCancelEdit, SFindRecord, SRefreshRecord);

constructor THalcyonNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FDataLink := THalcyonNavDataLink.Create(Self);
   FVisibleButtons := [nbTop, nbPrev, nbNext, nbBttm, nbInsert, nbCopy,
                      nbEdit, nbDelete, nbPost, nbCancel, nbFind, nbRefresh];
  FHints := TStringList.Create;
  TStringList(FHints).OnChange := HintsChanged;
  InitButtons;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  FocusedButton := nbTop;
  FConfirmDelete := True;
  FullRepaint := False;
end;

destructor THalcyonNavigator.Destroy;
begin
  FDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure THalcyonNavigator.InitButtons;
var
  I: THalcyonNavigateBtn;
  Btn: THalcyonNavButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := THalcyonNavButton.Create (Self);
    Btn.Flat := Flat;
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    FmtStr(ResName, 'halcn_%s', [BtnTypeName[I]]);
    Btn.Glyph.LoadFromResourceName(HInstance, ResName);
    Btn.NumGlyphs := 2;
    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := ClickHandler;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
  end;
  InitHints;
  Buttons[nbPrev].NavStyle := Buttons[nbPrev].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure THalcyonNavigator.InitHints;
var
  I: Integer;
  J: THalcyonNavigateBtn;
begin
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := BtnHintId[J];
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure THalcyonNavigator.HintsChanged(Sender: TObject);
begin
  InitHints;
end;

procedure THalcyonNavigator.SetFlat(Value: Boolean);
var
  I: THalcyonNavigateBtn;
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Flat := Value;
  end;
end;

procedure THalcyonNavigator.SetHints(Value: TStrings);
begin
  FHints.Assign(Value);
end;

procedure THalcyonNavigator.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure THalcyonNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure THalcyonNavigator.SetVisible(Value: THalcyonButtonSet);
var
  I: THalcyonNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  AdjustNavSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure THalcyonNavigator.AdjustNavSize (var W: Integer; var H: Integer);
var
  Count: Integer;
  MinW: Integer;
  I: THalcyonNavigateBtn;
  Space, Temp, Remain: Integer;
  X: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbTop] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Inc(Count);
    end;
  end;
  if Count = 0 then Inc(Count);

  MinW := Count * MinBtnSize.X;
  if W < MinW then W := MinW;
  if H < MinBtnSize.Y then H := MinBtnSize.Y;

  ButtonWidth := W div Count;
  Temp := Count * ButtonWidth;
  if Align = alNone then W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Space := 0;
      if Remain <> 0 then
      begin
        Dec(Temp, Remain);
        if Temp < 0 then
        begin
          Inc(Temp, Count);
          Space := 1;
        end;
      end;
      Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
      Inc(X, ButtonWidth + Space);
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure THalcyonNavigator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  if not HandleAllocated then AdjustNavSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure THalcyonNavigator.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  { check for minimum size }
  W := Width;
  H := Height;
  AdjustNavSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure THalcyonNavigator.ClickHandler(Sender: TObject);
begin
  BtnClick (THalcyonNavButton (Sender).Index);
end;

procedure THalcyonNavigator.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: THalcyonNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := THalcyonNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure THalcyonNavigator.BtnClick(Index: THalcyonNavigateBtn);
var
   DSet: TDataSet;
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    if not (csDesigning in ComponentState) and Assigned(FBeforeAction) then
      FBeforeAction(Self, Index);
    DSet := DataSource.DataSet;
    with DataSource.DataSet do
    begin
      case Index of
        nbPrev: Prior;
        nbNext: Next;
        nbTop: First;
        nbBttm: Last;
        nbInsert: Insert;
        nbEdit: Edit;
        nbCancel: Cancel;
        nbPost: Post;
        nbRefresh: Refresh;
        nbDelete:
          if not FConfirmDelete or
            (MessageDlg(SDeleteRecordQuestion, mtConfirmation,
            mbOKCancel, 0) <> idCancel) then Delete;
        nbCopy: if Assigned(FDoCopy) then FDoCopy(DSet);
        nbFind: if Assigned(FDoFind) then FDoFind(DSet);
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure THalcyonNavigator.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure THalcyonNavigator.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure THalcyonNavigator.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: THalcyonNavigateBtn;
  OldFocus: THalcyonNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus < High(Buttons) then
            NewFocus := Succ(NewFocus);
        until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure THalcyonNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure THalcyonNavigator.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF;
  Buttons[nbTop].Enabled := UpEnable;
  Buttons[nbPrev].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbBttm].Enabled := DnEnable;
  Buttons[nbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);
end;

procedure THalcyonNavigator.EditingChanged;
var
   CanModify: Boolean;
   InEdit: Boolean;
begin
   CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;
   InEdit := FDataLink.Editing;
   Buttons[nbInsert].Enabled := CanModify and not InEdit;
   Buttons[nbDelete].Enabled := CanModify and not InEdit;
   Buttons[nbEdit].Enabled := CanModify and not InEdit;
   Buttons[nbPost].Enabled := CanModify and InEdit;
   Buttons[nbCancel].Enabled := CanModify and InEdit;
   Buttons[nbRefresh].Enabled := not InEdit;
   Buttons[nbCopy].Enabled := CanModify and not InEdit;
   Buttons[nbFind].Enabled := not InEdit;
end;

procedure THalcyonNavigator.ActiveChanged;
var
  I: THalcyonNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False
  else
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure THalcyonNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure THalcyonNavigator.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
end;

function THalcyonNavigator.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure THalcyonNavigator.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustNavSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  ActiveChanged;
end;

{THalcyonNavButton}

destructor THalcyonNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure THalcyonNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure THalcyonNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure THalcyonNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure THalcyonNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = THalcyonNavigator (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ THalcyonNavDataLink }

constructor THalcyonNavDataLink.Create(ANav: THalcyonNavigator);
begin
  inherited Create;
  FNavigator := ANav;
end;

destructor THalcyonNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure THalcyonNavDataLink.EditingChanged;
begin
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure THalcyonNavDataLink.DataSetChanged;
begin
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure THalcyonNavDataLink.ActiveChanged;
begin
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;


end.
