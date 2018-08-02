{*********************************************************}
{*                   ADSTMACH.PAS 4.03                   *}
{*      COPYRIGHT (C) TURBOPOWER SOFTWARE 1996-2002      *}
{*                 ALL RIGHTS RESERVED.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStMach;

{
  Design philosophy: The TApdCustomStateMachine is a container for
  TApdCustomStates.  TApdCustomStateMachine manages the TApdCustomStates.
  The TApdCustomStateMachine contains the reference to the TApdComPort,
  the TApdCustomState contains definitions for the data conditions (through
  published properties in the Conditions property).
  To start the state machine, call the TApdCustomStateMachine.Start method;
  the TApdCustomState that is designated the TApdCustomStateMachine.StartState
  gets activated.  As a TApdCustomState is activated, a TApdDataPacket is
  created for each condition, and the appropriate/applicable TApdDataPacket
  properties are set. All of the TApdDataPacket's .OnPacket event handlers
  point to the TApdCustomStateMachine.PacketEvent method. When that event is generated
  the collected data is placed in the TApdCustomState's and TApdStateMachine's
  .Data property. The current TApdCustomState is then deactivated (data packets
  disabled and freed), and the condition's NextState is activated. This
  continues until the Condition does not define a NextState (when we assume that
  is a terminal state) or the state defined by the TApdCustomStateMachine's
  TerminalState is activated.
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Graphics,
  Forms,
  Dialogs,
  StdCtrls,
  OoMisc,
  AdPacket,
  AdPort,
  AdExcept,
  TypInfo;

type
  TApdConnectAddType = (atAdd, atSub, atNone);
  TApdCustomStateMachine = class;
  TApdCustomState = class;
  TApdStateCondition = class;

  { defines how the connectoid line appears }
  TApdStateConnectoid = class (TPersistent)
  private
    FWidth: Integer;
    FCaption: TCaption;
    FColor: TColor;
    FCondition : TApdStateCondition;
    FSelected : Boolean;
    FFont : TFont;
    procedure SetCaption(const Value: TCaption);
    procedure SetColor(const Value: TColor);
    procedure SetFont (const Value : TFont);
    procedure SetWidth(const Value: Integer);
  protected
  public
    constructor Create(AOwner : TApdStateCondition);
    destructor Destroy; override;
    procedure Changed;
  published
    property Caption : TCaption read FCaption write SetCaption;
    property Color : TColor read FColor write SetColor;
    property Width : Integer read FWidth write SetWidth;
    property Font : TFont read FFont write SetFont;
  end;

  { describes the conditions for failure/success/etc }
  TApdStateCondition = class (TCollectionItem)
  protected
    function GetDisplayName: string; override;
  private
    FPacketSize: Integer;
    FTimeout: Integer;
    FErrorCode: Integer;
    FNextState: TApdCustomState;
    FEndString: string;
    FStartString: string;
    FConnectoid: TApdStateConnectoid;
    FIgnoreCase: Boolean;
    procedure SetNextState(const Value: TApdCustomState);
    procedure SetConnectoid(const Value: TApdStateConnectoid);
  protected
    function GetCaption : TCaption;
    function GetColor : TColor;
    function GetFont : TFont;
    procedure SetCaption (const v : TCaption);
    procedure SetColor (const v : TColor);
    procedure SetFont (const v : TFont);
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;

    procedure Changed;
  published
    property StartString : string
      read FStartString write FStartString;
    property EndString : string
      read FEndString write FEndString;
    property PacketSize : Integer
      read FPacketSize write FPacketSize;
    property Timeout : Integer
      read FTimeout write FTimeout;
    property NextState : TApdCustomState
      read FNextState write SetNextState;
    property ErrorCode : Integer
      read FErrorCode write FErrorCode;
    property IgnoreCase : Boolean
      read FIgnoreCase write FIgnoreCase;
    property Connectoid : TApdStateConnectoid
      read FConnectoid write SetConnectoid;
    property Caption : TCaption read GetCaption write SetCaption;
    property Color : TColor read GetColor write SetColor;
    property Font : TFont read GetFont write SetFont;
  end;

  { describes the container for the aforementioned conditions }
  TApdStateConditions = class(TCollection)
  private
    function GetItem(Index: Integer): TApdStateCondition;
    procedure SetItem(Index: Integer; const Value: TApdStateCondition);
  protected
    FState : TApdCustomState;
    function GetOwner : TPersistent; override;
  public
    constructor Create(State : TApdCustomState;
      ItemClass: TCollectionItemClass);
    procedure Update(Item: TCollectionItem); override;
    function Add : TApdStateCondition;
    property Items[Index: Integer] : TApdStateCondition
      read GetItem write SetItem; default;
  end;

  { TApdCustomStateMachine events }
  TApdStateMachineStateChangeEvent = procedure(StateMachine : TApdCustomStateMachine;
    FromState, ToState : TApdCustomState) of object;
  TApdStateMachineFinishEvent = procedure(StateMachine : TApdCustomStateMachine;
    ErrorCode : Integer) of object;

  { TApdCustomState events }
  TApdStateFinishEvent = procedure(State : TApdCustomState;
    Condition : TApdStateCondition; var NextState : TApdCustomState) of object;
  TApdStateNotifyEvent = procedure(State : TApdCustomState) of object;

  { the container for the states }
  TApdCustomStateMachine = class(TApdBaseScrollingWinControl)
  private
    FStartState: TApdCustomState;
    FTerminalState: TApdCustomState;
    FCurrentState : TApdCustomState;
    FCanvas : TCanvas;
    FComPort: TApdCustomComPort;

    FOnStateMachineFinish: TApdStateMachineFinishEvent;
    FOnStateChange: TApdStateMachineStateChangeEvent;
    FBorderStyle: TBorderStyle;
    FData: Pointer;
    FDataSize: Integer;
    FDataString: string;
    FLastErrorCode: Integer;
    PacketList : TList;
    FCaption: TCaption;
    FActive: Boolean;

    procedure SetStartState(const Value: TApdCustomState);
    procedure SetTerminalState(const Value: TApdCustomState);
    procedure SetComPort(const Value: TApdCustomComPort);
    procedure SetBorderStyle(const Value: TBorderStyle);

    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetData: Pointer;
    function GetDataSize: Integer;
    function GetDataString: string;
    function GetStateNames: TStringList;
    procedure SetCaption(const Value: TCaption);
  protected
    { Protected declarations }

    procedure CMDesignHitTest (var Msg : TWMMouse); message CM_DESIGNHITTEST;
    procedure ConnectoidAtPoint (AddType : TApdConnectAddType; Point : TPoint);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC : HDC); override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;

    procedure DoActivate(NewState : TApdCustomState);
    procedure DoDeactivate;
    procedure DoStateChange(var M: TMessage); message apw_StateChange;
    { internal OnPacket event for our Items' data packets }
    procedure PacketEvent(Sender: TObject; Data : Pointer; Size : Integer);
    procedure PacketTimeout(Sender: TObject);
    procedure RenderConnectoid (Connectoid : TApdStateConnectoid;
                                State, DestState : TApdCustomState);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure StateMachinePaint;

    { starts the state machine }
    procedure Start;

    { cancels the state machine }
    procedure Cancel;

    {the data collected by our packets }
    property Data : Pointer
      read GetData;
    property DataSize : Integer
      read GetDataSize;
    property DataString : string
      read GetDataString;

    property Active : Boolean read FActive default False;                {!!.02}
    property BorderStyle: TBorderStyle
      read FBorderStyle write SetBorderStyle default bsSingle;
    property Canvas : TCanvas
      read FCanvas;

    property Caption : TCaption read FCaption write SetCaption;
    property ComPort : TApdCustomComPort read FComPort write SetComPort;
    property CurrentState : TApdCustomState
      read FCurrentState;
    property StateNames : TStringList
      read GetStateNames;
    property StartState : TApdCustomState
      read FStartState write SetStartState;
    property TerminalState : TApdCustomState
      read FTerminalState write SetTerminalState;

    property LastErrorCode : Integer
      read FLastErrorCode;
    property OnStateChange : TApdStateMachineStateChangeEvent
      read FOnStateChange write FOnStateChange;
    property OnStateMachineFinish : TApdStateMachineFinishEvent
      read FOnStateMachineFinish write FOnStateMachineFinish;
  end;

  TApdCustomState = class(TApdBaseGraphicControl)
  private
    { Private declarations }
    FActive: Boolean;
    FCompleted : Boolean;
    FGlyph: TBitmap;
    FOutputOnActivate: string;
    FConditions: TApdStateConditions;
    FGlyphCells: Integer;
    FActiveColor: TColor;
    FInactiveColor: TColor;
    FOnStateActivate: TApdStateNotifyEvent;
    FOnStateFinish: TApdStateFinishEvent;
    FCaption: TCaption;

    procedure SetActiveColor(const NewColor : TColor);
    procedure SetInactiveColor(const NewColor : TColor);
    procedure SetConditions(const Value: TApdStateConditions);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetGlyphCells(const Value: Integer);
    procedure SetCaption(const Value: TCaption);

  protected
    { Protected declarations }
    HaveGlyph : Boolean;
    FStateMachine : TApdCustomStateMachine;

    procedure Activate;
    procedure Deactivate;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure SetParent(AParent : TWinControl); override;
    function FindStateMachine : TApdCustomStateMachine;

  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    { other overriden methods }
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;

    { terminate the state }
    procedure Terminate(ErrorCode : Integer);

    property Caption : TCaption read FCaption write SetCaption;
    { True if we're waiting for a condition, False otherwise }
    property Active : Boolean read FActive;
    { True if we've already been activated and have met our conditions }
    property Completed : Boolean read FCompleted;
    property ActiveColor : TColor
      read FActiveColor write SetActiveColor;
    property InactiveColor : TColor
      read FInactiveColor write SetInactiveColor;

    property Conditions : TApdStateConditions
      read FConditions write SetConditions;

    property Glyph : TBitmap read FGlyph write SetGlyph;
    { GlyphCells is used to show a different 'cell' of the Glyph depending on }
    { the state of the state according to the following. All cells need to be }
    { the same dimensions. When rendering, the width of the rendered image is }
    { obtained by Glyph.Width div GlyphCells }
    {   Cell 1 is the inactive cell }
    {   Cell 2 is the active cell }
    {   Cell 3 is a state that has already been deactivated }
    property GlyphCells : Integer
      read FGlyphCells write SetGlyphCells;

    property OutputOnActivate : string
      read FOutputOnActivate write FOutputOnActivate;

    property OnStateActivate : TApdStateNotifyEvent
      read FOnStateActivate write FOnStateActivate;
    property OnStateFinish : TApdStateFinishEvent
      read FOnStateFinish write FOnStateFinish;
  end;

  TApdStateMachine = class(TApdCustomStateMachine)
  published
    { our published declarations }
    property Caption;
    property ComPort;
    property StartState;
    property TerminalState;

    property OnStateChange;
    property OnStateMachineFinish;

    { publishing from TScrollingWinControl }
    property Align;
    {$IFDEF Delphi5}
    property Anchors;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BiDiMode;
    property Constraints;
    property ParentBiDiMode;
    property OnContextPopup;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    {$ENDIF}
    property Color; 
    property AutoScroll;
    property Ctl3D;
    property Font;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;       
  end;

  TApdState = class(TApdCustomState)
  published
    { Published declarations }
    property ActiveColor;
    property Caption;
    property Conditions;
    property Font;
    property Glyph;
    property GlyphCells;
    property InactiveColor;
    property OutputOnActivate;

    property OnStateActivate;
    property OnStateFinish;
  end;


implementation

{$IFDEF TRIALRUN}
  {$I TRIAL07.INC}
  {$I TRIAL03.INC}
  {$I TRIAL01.INC}
{$ENDIF}

{ TApdCustomStateMachine }

procedure TApdCustomStateMachine.Cancel;
begin

end;

procedure TApdCustomStateMachine.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;
  inherited;
end;

procedure TApdCustomStateMachine.CMDesignHitTest (var Msg : TWMMouse);
var
  i : Integer;
  Point : TPoint;
  State : TApdCustomState;
  AddType : TApdConnectAddType;
begin
  Msg.Result := 0;
  if (Msg.Keys and MK_LBUTTON) <> 0 then begin
    Point.x := Msg.XPos;
    Point.y := Msg.YPos;
    if (Point.x < Left) or (Point.x > Left + Width) or
       (Point.y < Top) or (Point.y > Top + Height) then
      Exit;
    for i := 0 to pred (ControlCount) do begin
      if Controls[i] is TApdCustomState then begin
        State := TApdCustomState(Controls[i]);
        if (Point.x >= State.Left) and
           (Point.x <= State.Left + State.Width) and
           (Point.y >= State.Top) and
           (Point.y <= State.Top + State.Height) then
          Exit;
      end;
    end;
    if (Msg.Keys and MK_SHIFT) <> 0 then
      AddType := atAdd
    else if (Msg.Keys and MK_CONTROL) <> 0 then
      AddType := atSub
    else
      AddType := atNone;

    ConnectoidAtPoint (AddType, Point);
  end;
end;

procedure TApdCustomStateMachine.ConnectoidAtPoint (
                                             AddType : TApdConnectAddType;
                                             Point : TPoint);

  function PointInRect (Point : TPoint; Rect : TRect;
                        Offset : Integer) : Boolean;
  var
    t : Integer;
  begin
    Result := False;
    { Sort the rectangle points }
    if (Rect.Left > Rect.Right) then begin
      t := Rect.Right;
      Rect.Right := Rect.Left;
      Rect.Left := t;
    end;
    if (Rect.Top > Rect.Bottom) then begin
      t := Rect.Bottom;
      Rect.Bottom := Rect.Top;
      Rect.Top := t;
    end;
    if (Point.x >= Rect.Left - Offset) and
       (Point.x <= Rect.Right + Offset) and
       (Point.y >= Rect.Top - Offset) and
       (Point.y <= Rect.Bottom + Offset) then
      Result := True;
  end;

  function CheckConnectoid (State, DestState: TApdCustomState) : Boolean;
  const
    ApdCCOffset = 4;

  var
    StartAt : TPoint;
    EndAt : TPoint;
    MidPoint : TPoint;
    MinPoint : TPoint;
    MaxPoint : TPoint;

  begin
    Result := False;
    if Assigned (State) and Assigned(DestState) and
      (State <> nil) and (DestState <> nil) then begin
      StartAt.x := State.Left + (State.Width div 2);
      StartAt.y := State.Top + (State.Height div 2);
      EndAt.x := DestState.Left + (DestState.Width div 2);
      EndAt.y := DestState.Top + (DestState.Height div 2);
      if StartAt.x > EndAt.x then begin
        MinPoint.x := EndAt.x;
        MaxPoint.x := StartAt.x;
      end else begin
        MinPoint.x := StartAt.x;
        MaxPoint.x := EndAt.x;
      end;
      if StartAt.y > EndAt.y then begin
        MinPoint.y := EndAt.y;
        MaxPoint.y := StartAt.y;
      end else begin
        MinPoint.y := StartAt.y;
        MaxPoint.y := EndAt.y;
      end;
      MidPoint.x := (MaxPoint.x - MinPoint.x) div 2 + MinPoint.x;
      MidPoint.y := (MaxPoint.y - MinPoint.y) div 2 + MinPoint.y;

      { Important note:
        If the mechanism by which the connectoids are drawn is changed,
        this code must be changed to reflect the drawing mechanism }
      if DestState = State then begin
        Dec (StartAt.x, 8);
        if PointInRect (Point, Rect (State.Left + State.Width - 14,
                                     State.Top - 6,
                                     State.Left + State.Width - 8,
                                     State.Top),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (State.Left + State.Width + 12,
                                     State.Top - 12,
                                     State.Left + State.Width - 12,
                                     State.Top + 12),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (DestState.Left + DestState.Width + 4,
                                     State.Top + 14,
                                     DestState.Left + DestState.Width,
                                     State.Top + 6),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Top > State.Top + State.Height) then begin
        Dec (StartAt.x, 8);
        Dec (EndAt.x, 8);
        Dec (MidPoint.y, 4);
        { Check Start }
        if PointInRect (Point, Rect (StartAt.x - 3,
                                     State.Top + State.Height + 6,
                                     StartAt.x + 3,
                                     State.Top + State.Height),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     StartAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;

        if PointInRect (Point, Rect (StartAt.x, MidPoint.y,
                                     EndAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;

        if PointInRect (Point, Rect (EndAt.x, MidPoint.y,
                                     EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (EndAt.x - 4, DestState.Top,
                                     EndAt.x + 4, DestState.Top - 4),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Top + DestState.Height < State.Top) then begin
        Inc (StartAt.x, 8);
        Inc (EndAt.x, 8);
        Inc (MidPoint.y, 4);
        { Check Start }
        if PointInRect (Point, Rect (StartAt.x - 3, State.Top - 6,
                                     StartAt.x + 3, State.Top),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     StartAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (StartAt.x, MidPoint.y,
                                     EndAt.x, MidPoint.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (EndAt.x, MidPoint.y,
                                     EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (EndAt.x - 4,
                                     DestState.Top + DestState.Height,
                                     EndAt.x + 4,
                                     DestState.Top + DestState.Height + 4),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Left > State.Left + State.Width) then begin
        Dec (StartAt.y, 8);
        Dec (EndAt.y, 8);
        Dec (MidPoint.x, 4);
        { Check Start }
        if PointInRect (Point, Rect (State.Left + State.Width,
                                     StartAt.y - 3,
                                     State.Left + State.Width + 6,
                                     StartAt.y + 3),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     MidPoint.x, StartAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, StartAt.y,
                                     MidPoint.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, EndAt.y,
                                     EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (DestState.Left - 4, EndAt.y - 4,
                                     DestState.Left, EndAt.y + 4),
                        ApdCCOffset) then
          Result := True;
      end else if (DestState.Left + DestState.Width < State.Left) then begin
        Inc (StartAt.y, 8);
        Inc (EndAt.y, 8);
        Inc (MidPoint.x, 4);
        { Check Start }
        if PointInRect (Point, Rect (State.Left - 6, StartAt.y - 3,
                                     State.Left, StartAt.y + 3),
                        ApdCCOffset) then
          Result := True;
        { Check Connectoid }
        if PointInRect (Point, Rect (StartAt.x, StartAt.y,
                                     MidPoint.x, StartAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, StartAt.y,
                                     MidPoint.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        if PointInRect (Point, Rect (MidPoint.x, EndAt.y, EndAt.x, EndAt.y),
                        ApdCCOffset) then
          Result := True;
        { Check Arrow }
        if PointInRect (Point, Rect (DestState.Left + DestState.Width,
                                     EndAt.y - 4,
                                     DestState.Left + DestState.Width + 4,
                                     EndAt.y + 4),
                        ApdCCOffset) then
          Result := True;
      end;
    end;
  end;

var
  i : Integer;
  c : Integer;
  State : TApdCustomState;

begin
  for i := 0 to pred(ControlCount) do begin
    if Controls[i] is TApdCustomState then begin
      State := TApdCustomState(Controls[i]);
      if State.Conditions.Count > 0 then begin
        for c := 0 to pred(State.Conditions.Count) do
          if State.Conditions[c].NextState <> nil then begin
            if AddType = atNone then
              State.Conditions[c].Connectoid.FSelected := False;
            if CheckConnectoid (State, State.Conditions[c].NextState) then begin
              if AddType <> atSub then
                State.Conditions[c].Connectoid.FSelected := True
              else
                State.Conditions[c].Connectoid.FSelected := False;
            end;
          end;
      end;
    end;
  end;
  Invalidate;
end;

constructor TApdCustomStateMachine.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csOpaque, csAcceptsControls, csFramed, csCaptureMouse,
                   csClickEvents, csSetCaption, csDoubleClicks];
  {create our canvas}
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FBorderStyle := bsSingle;
  Color := clWhite;
  Height := 200;
  Width := 200;
  PacketList := TList.Create;
  FComPort := SearchComPort(Owner);
end;

procedure TApdCustomStateMachine.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

destructor TApdCustomStateMachine.Destroy;
begin
  if Assigned (CurrentState) then
    DoDeactivate; 
  PacketList.Free;
  FCanvas.Free;
  inherited;
end;

procedure TApdCustomStateMachine.DoActivate(NewState : TApdCustomState);
var
  I : Integer;
begin
  if NewState.Conditions.Count = 0 then begin
    { no conditions set, must be done }
    FCurrentState := NewState;
    NewState.Activate;
    if Assigned(FOnStateMachineFinish) then
      FOnStateMachineFinish(Self, FLastErrorCode);
    FActive := False;                                                    {!!.02}
  end else begin
    { we're activating a state, get the parameters for the packets }
    for I := 0 to pred(NewState.Conditions.Count) do begin
      PacketList.Add(TApdDataPacket.Create(Self));
      with TApdDataPacket(PacketList[I]) do begin
        Name := NewState.Name + '_StatePacket' + IntToStr(I);
        Tag := I;
        AutoEnable := False;
        Enabled := False;

        { assign the port and OnPacket event handler }
        ComPort := FComPort;
        OnPacket := PacketEvent;
        OnTimeout := PacketTimeout;

        { set up the Start and End conditions }
        StartString := NewState.Conditions[I].StartString;
        if StartString = '' then
          StartCond := scAnyData
        else
          StartCond := scString;

        EndCond := [];
        EndString := NewState.Conditions[I].EndString;
        if EndString <> '' then
          EndCond := EndCond + [ecString];
        PacketSize := NewState.Conditions[I].PacketSize;
        if PacketSize > 0 then
          EndCond := EndCond + [ecPacketSize];

        Timeout := NewState.Conditions[I].Timeout;
        Enabled := True;
        InternalManager.KeepAlive := True;
      end;
    end;

    FCurrentState := NewState;
    NewState.Activate;
    FActive := True;                                                     {!!.02}
  end;
end;

procedure TApdCustomStateMachine.DoDeactivate;
var
  I : Integer;
begin
  { disable and free our Condition's data packets }
  for I := 0 to pred(PacketList.Count) do begin
    FComPort.AddStringToLog ('Deactivate_Data_Packet:' + IntToStr (i));
    TApdDataPacket(PacketList[I]).Enabled := False;
    TApdDataPacket(PacketList[I]).Free;
  end;
  FCurrentState.Deactivate;
end;

procedure TApdCustomStateMachine.DoStateChange(var M: TMessage);
begin
  { tell the state to deactivate }
  DoDeactivate;
  PacketList.Clear; 

  { generate the appropriate events }
  if Assigned(FOnStateChange) then
    FOnStateChange(Self, FCurrentState, FCurrentState.Conditions[M.WParam].NextState);

  { activate the next state }
  DoActivate(FCurrentState.Conditions[M.WParam].NextState);
end;

function TApdCustomStateMachine.GetData: Pointer;
begin
  Result := FData;
end;

function TApdCustomStateMachine.GetDataSize: Integer;
begin
  Result := FDataSize;
end;

function TApdCustomStateMachine.GetDataString: string;
begin
  Result := FDataString;
end;

function TApdCustomStateMachine.GetStateNames: TStringList;
var
  I : Integer;
begin
  Result := TStringList.Create;
  for I := 0 to pred(Owner.ComponentCount) do
    if Owner.Components[I] is TApdCustomState then
      if TApdCustomState(Owner.Components[I]).FStateMachine = Self then
      Result.Add(TApdCustomState(Owner.Components[I]).Name);
end;

procedure TApdCustomStateMachine.Loaded;
begin
  inherited;
end;

procedure TApdCustomStateMachine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then begin
    {See if our com port is going away}
    if (AComponent = FComPort) then
      FComPort := nil;
  end else if (Operation = opInsert) then begin
    {Check for a com port being installed}
    if not Assigned(FComPort) and (AComponent is TApdCustomComPort) then
      FComPort := TApdCustomComPort(AComponent);
  end;
end;

procedure TApdCustomStateMachine.PacketEvent(Sender: TObject;
  Data: Pointer; Size: Integer);
var
  Index : Integer;
begin
  Index := TApdDataPacket(Sender).Tag;
  {$IFOPT H-}
  if Size > 255 then
    raise EStringSizeError.Create(ecPacketTooLong, False);
  {$ENDIF}
  SetLength(FDataString, Size);
  Move(Data^, FDataString[1], Size);
  FData := Data;
  FDataSize := Size;
  PostMessage(Handle, apw_StateChange, Index, 0);
end;

procedure TApdCustomStateMachine.PacketTimeout(Sender: TObject);
begin
  PostMessage(Handle, apw_StateChange, TApdDataPacket(Sender).Tag, 1);     
end;

procedure TApdCustomStateMachine.StateMachinePaint;
var
  R   : TRect;
  I, C  : Integer;
  State : TApdCustomState;
  HintText : string;

begin
  HintText := '';
  {get the display dimensions}
  R := GetClientRect;
  { clear the existing display }
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(R);
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := clActiveBorder;
  Canvas.TextRect(R, 2, 2, Caption);

  { draw the connectoids }
  for I := 0 to pred(ControlCount) do begin
    if Controls[I] is TApdCustomState then begin
      State := TApdCustomState(Controls[I]);
      if State.Conditions.Count > 0 then begin
        for C := 0 to pred(State.Conditions.Count) do
          if State.Conditions[C].NextState <> nil then begin
            RenderConnectoid (State.Conditions[C].Connectoid,
                              State, State.Conditions[C].NextState);
            if State.Conditions[C].Connectoid.FSelected then
              HintText := HintText + State.Name + ' -> ' +
                          State.Conditions[C].NextState.Name + '   ';
          end;
      end;
    end;
  end;

  { tell the states to draw themselves }
  for I := 0 to pred(ComponentCount) do begin
    if Components[I] is TApdCustomState then
      TApdCustomState(Components[I]).Paint;
  end;

  { Display Hint Text }

  if HintText <> '' then begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    Canvas.Brush.Color := $00bfffff;
    Canvas.Font.Color := clBlack;
    Canvas.Rectangle (3, 3,
                      Canvas.TextWidth (HintText) + 7,
                      Canvas.TextHeight (HintText) + 7);
    Canvas.TextOut (5, 5, HintText);
    Canvas.Brush.Color := clWhite;
  end;
end;

procedure TApdCustomStateMachine.PaintWindow(DC: HDC);
var
  R : TRect;
begin
  Canvas.Handle := DC;
  try
    R := ClientRect;
    InvalidateRect(Canvas.Handle, @R, True);
    StateMachinePaint;
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TApdCustomStateMachine.RenderConnectoid (
                                           Connectoid : TApdStateConnectoid;
                                           State, DestState : TApdCustomState);
var
  StartAt : TPoint;
  EndAt : TPoint;
  MidPoint : TPoint;
  MinPoint : TPoint;
  MaxPoint : TPoint;
  OldColor : TColor;
  {HintText : string;}
begin
    if Assigned(Connectoid) and Assigned(DestState) and
      (Connectoid <> nil) and (DestState <> nil) then begin
      StartAt.x := State.Left + (State.Width div 2);
      StartAt.y := State.Top + (State.Height div 2);
      EndAt.x := DestState.Left + (DestState.Width div 2);
      EndAt.y := DestState.Top + (DestState.Height div 2);
      if StartAt.x > EndAt.x then begin
        MinPoint.x := EndAt.x;
        MaxPoint.x := StartAt.x;
      end else begin
        MinPoint.x := StartAt.x;
        MaxPoint.x := EndAt.x;
      end;
      if StartAt.y > EndAt.y then begin
        MinPoint.y := EndAt.y;
        MaxPoint.y := StartAt.y;
      end else begin
        MinPoint.y := StartAt.y;
        MaxPoint.y := EndAt.y;
      end;
      MidPoint.x := (MaxPoint.x - MinPoint.x) div 2 + MinPoint.x;
      MidPoint.y := (MaxPoint.y - MinPoint.y) div 2 + MinPoint.y;
      
      OldColor := Canvas.Pen.Color;
      Canvas.Font.Assign (Connectoid.Font);
      if Connectoid.FSelected then begin
        if Connectoid.Color = clRed then
          Canvas.Pen.Color := clFuchsia
        else
          Canvas.Pen.Color := clRed;
        Canvas.Font.Color := clRed;
      end else
        Canvas.Pen.Color := Connectoid.Color;
      Canvas.Pen.Width := Connectoid.Width;

      if DestState = State then begin
        Dec (StartAt.x, 8);
        Canvas.Ellipse (State.Left + State.Width - 14, State.Top - 6,
                        State.Left + State.Width - 8, State.Top);
        Canvas.Ellipse (State.Left + State.Width + 12, State.Top - 12,
                        State.Left + State.Width - 12, State.Top + 12);
        { Draw Arrow }
        Canvas.MoveTo (DestState.Left + DestState.Width, State.Top + 10);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, State.Top + 6);
        Canvas.MoveTo (DestState.Left + DestState.Width, State.Top + 10);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, State.Top + 14);
        Canvas.TextOut(State.Left + State.Width -
                       Canvas.TextWidth (Connectoid.Caption) div 2,
                       State.Top - 14 - Canvas.TextHeight (Connectoid.Caption),
                       Connectoid.Caption);
      end else if (DestState.Top > State.Top + State.Height) then begin
        Dec (StartAt.x, 8);
        Dec (EndAt.x, 8);
        Dec (MidPoint.y, 4);
        { Draw Start }
        Canvas.Ellipse (StartAt.x - 3, State.Top + State.Height + 6,
                        StartAt.x + 3, State.Top + State.Height);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (StartAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (EndAt.x, DestState.Top);
        Canvas.LineTo (EndAt.x - 4, DestState.Top - 4);
        Canvas.MoveTo (EndAt.x, DestState.Top);
        Canvas.LineTo (EndAt.x + 4, DestState.Top - 4);
        if EndAt.x > StartAt.x then
          Canvas.TextOut(StartAt.x + 2,
                         MidPoint.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(StartAt.x - 2 - Canvas.TextWidth (Connectoid.Caption),
                         MidPoint.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
      end else if (DestState.Top + DestState.Height < State.Top) then begin
        Inc (StartAt.x, 8);
        Inc (EndAt.x, 8);
        Inc (MidPoint.y, 4);
        { Draw Start }
        Canvas.Ellipse (StartAt.x - 3, State.Top - 6,
                        StartAt.x + 3, State.Top);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (StartAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, MidPoint.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (EndAt.x, DestState.Top + DestState.Height);
        Canvas.LineTo (EndAt.x - 4, DestState.Top + DestState.Height + 4);
        Canvas.MoveTo (EndAt.x, DestState.Top + DestState.Height);
        Canvas.LineTo (EndAt.x + 4, DestState.Top + DestState.Height + 4);
        if EndAt.x >= StartAt.x then
          Canvas.TextOut(StartAt.x + 2,
                         MidPoint.y + 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(StartAt.x - 2 - Canvas.TextWidth (Connectoid.Caption),
                         MidPoint.y + 2,
                         Connectoid.Caption)
      end else if (DestState.Left > State.Left + State.Width) then begin
        Dec (StartAt.y, 8);
        Dec (EndAt.y, 8);
        Dec (MidPoint.x, 4);
        { Draw Start }
        Canvas.Ellipse (State.Left + State.Width, StartAt.y - 3,
                        State.Left + State.Width + 6, StartAt.y + 3);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, EndAt.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (DestState.Left, EndAt.y);
        Canvas.LineTo (DestState.Left - 4, EndAt.y - 4);
        Canvas.MoveTo (DestState.Left, EndAt.y);
        Canvas.LineTo (DestState.Left - 4, EndAt.y + 4);
        if EndAt.y >= StartAt.y then
          Canvas.TextOut(State.Left + State.Width + 10,
                         StartAt.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(DestState.Left - Canvas.TextWidth (Connectoid.Caption) -  2,
                         EndAt.y - Canvas.TextHeight (Connectoid.Caption) - 2,
                         Connectoid.Caption)
      end else if (DestState.Left + DestState.Width < State.Left) then begin
        Inc (StartAt.y, 8);
        Inc (EndAt.y, 8);
        Inc (MidPoint.x, 4);
        { Draw Start }
        Canvas.Ellipse (State.Left - 6, StartAt.y - 3,
                        State.Left, StartAt.y + 3);
        { Draw Connectoid }
        Canvas.MoveTo (StartAt.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, StartAt.y);
        Canvas.LineTo (MidPoint.x, EndAt.y);
        Canvas.LineTo (EndAt.x, EndAt.y);
        { Draw Arrow }
        Canvas.MoveTo (DestState.Left + DestState.Width, EndAt.y);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, EndAt.y - 4);
        Canvas.MoveTo (DestState.Left + DestState.Width, EndAt.y);
        Canvas.LineTo (DestState.Left + DestState.Width + 4, EndAt.y + 4);
        if EndAt.y <= StartAt.y then
          Canvas.TextOut(State.Left - Canvas.TextWidth (Connectoid.Caption) - 2,
                         StartAt.y + 2,
                         Connectoid.Caption)
        else
          Canvas.TextOut(DestState.Left + DestState.Width + 2,
                         EndAt.y + 2,
                         Connectoid.Caption)
      end else begin
      end;
      if Connectoid.FSelected then begin
        Canvas.Pen.Color := clMaroon;
        Canvas.Pen.Style := psDot;
        Canvas.Pen.Width := 1;
        Canvas.MoveTo (State.Left + State.Width div 2,
                       State.Top + State.Height div 2);
        Canvas.LineTo (DestState.Left + DestState.Width div 2,
                       DestState.Top + DestState.Height div 2);
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Width := Connectoid.Width;
      end;

      Canvas.Pen.Color := OldColor;
    end;
end;

procedure TApdCustomStateMachine.SetBorderStyle(const Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TApdCustomStateMachine.SetCaption(const Value: TCaption);
begin
  inherited Caption := Value;
  FCaption := Value;
  Refresh;
end;

procedure TApdCustomStateMachine.SetComPort(
  const Value: TApdCustomComPort);
begin
  FComPort := Value;
end;

procedure TApdCustomStateMachine.SetStartState(
  const Value: TApdCustomState);
begin
  FStartState := Value;
end;

procedure TApdCustomStateMachine.SetTerminalState(
  const Value: TApdCustomState);
begin
  FTerminalState := Value;
end;

procedure TApdCustomStateMachine.Start;
{$IFDEF TRIALRUN}
  {$I TRIAL04.INC}
{$ENDIF}
  begin
{$IFDEF TRIALRUN}
  TC;
{$ENDIF}
  if not Assigned(FComPort) then
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);
  if not(FComPort.Open) and (FComPort.AutoOpen) then
    FComPort.Open := True;
  if Assigned(FStartState) then begin
    FLastErrorCode := ecOK;
    DoActivate(FStartState);
  end else
    raise Exception.Create('StartState not set');
end;


procedure TApdCustomStateMachine.WMNCHitTest(var Message: TMessage);
begin
  DefaultHandler(Message);
end;

{ TApdCustomState }

procedure TApdCustomState.Activate;
  { called by the state machine after the condition's data packets are set up }
{$IFDEF TRIALRUN}
  {$I TRIAL04.INC}
{$ENDIF}
begin
{$IFDEF TRIALRUN}
  TC;       
{$ENDIF}
  FStateMachine.FComPort.AddStringToLog(Name+ ': Activate');
  FActive := True;
  FCompleted := False;
  Refresh;
  if OutputOnActivate <> '' then
    FStateMachine.FComPort.Output := OutputOnActivate;

  if Assigned(FOnStateActivate) then
    FOnStateActivate(Self);
end;

constructor TApdCustomState.Create(AOwner: TComponent);
begin
  inherited;
  Color := clWhite;
  UpdateBoundsRect(Rect(Left, Top, 75, 50));
  FActive := False;
  FCompleted := False;
  HaveGlyph := False;
  FActiveColor := clYellow;
  FGlyph := TBitmap.Create;
  Conditions := TApdStateConditions.Create(Self, TApdStateCondition);
end;

procedure TApdCustomState.Deactivate;
begin
  FStateMachine.FComPort.AddStringToLog(Name + ': Deactivate');
  FActive := False;
  FCompleted := True;
  Refresh;
end;

destructor TApdCustomState.Destroy;
begin
  FGlyph.Free;
  FConditions.Free;
  FStateMachine.Refresh;
  inherited;
end;

procedure TApdCustomState.Loaded;
begin
  inherited;
  SetGlyph(FGlyph);
  FInactiveColor := FStateMachine.Color;
  Refresh;
end;

procedure TApdCustomState.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

procedure TApdCustomState.Paint;
var
  R, Dest, Src : TRect;
  DispWidth : Integer;
begin
  {get the display dimensions}
  R := GetClientRect;
  Canvas.Font.Assign (Font);
  if Active then
    Canvas.Brush.Color := FActiveColor
  else if HaveGlyph then
    Canvas.Brush.Color := Parent.Brush.Color
  else
    Canvas.Brush.Color := FInactiveColor;
  if HaveGlyph then begin
    Dest := R;
    Dest.Top := Dest.Top + Canvas.TextHeight(Name);
    if FGlyphCells > 1 then begin
      DispWidth := FGlyph.Width div FGlyphCells;
      if FActive then
        Src := Rect(DispWidth, 0, DispWidth * 2, FGlyph.Height)
      else if FCompleted then begin
        if FGlyphCells = 3 then
          Src := Rect(DispWidth * 2, 0, DispWidth * 3, FGlyph.Height)
        else
          Src := Rect(0, 0, DispWidth, FGlyph.Height);
      end else
        Src := Rect(0, 0, DispWidth, FGlyph.Height);
      Canvas.CopyRect(Dest, Glyph.Canvas, Src);

    end else
      Canvas.CopyRect(Dest, Glyph.Canvas, Glyph.Canvas.ClipRect);
  end else begin
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);

    Canvas.Brush.Style := bsClear;
    {$IFDEF Delphi6}
    Canvas.Rectangle(R);
    {$ELSE}
    Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    {$ENDIF}
  end;
  Canvas.TextRect(Rect(2, 0, Width, Canvas.TextHeight(Caption)), 2, 0, Caption);
end;

procedure TApdCustomState.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  { we've moved, refresh the state machine }
  if Assigned(FStateMachine) then
    FStateMachine.Refresh;
end;

procedure TApdCustomState.SetConditions(const Value: TApdStateConditions);
begin
  FConditions := Value;
  Invalidate;
end;

procedure TApdCustomState.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  HaveGlyph := FGlyph.Height > 0;
  Refresh;
end;

procedure TApdCustomState.SetGlyphCells(const Value: Integer);
begin
  if (Value <> FGlyphCells) and (Value in [0..3]) then begin
    FGlyphCells := Value;
    Refresh;
  end;
end;

procedure TApdCustomState.SetParent(AParent: TWinControl);
var
  AStateMachine : TApdCustomStateMachine;
  I : Integer;
begin
  { TApdCustomState must be parented by a TApdCustomStateMachine }
  if (AParent is TApdCustomStateMachine) or (AParent = nil) then begin
   FStateMachine := TApdCustomStateMachine(AParent);
   inherited SetParent(AParent);
  end else 
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then begin
    { not a TApdCustomStateMachine, find one }
    AStateMachine := FindStateMachine;
    if AStateMachine = nil then begin
      { can't find one, create one }
      I := 1;
      with TApdStateMachine.Create(Owner) do begin
        while Owner.FindComponent(Format('ApdStateMachine%d', [I])) <> nil do
          inc(I);
        Name := Format('ApdStateMachine%d', [I]);
        Parent := TCustomForm(Owner);
      end;
      AStateMachine := FindStateMachine;
    end;
    FStateMachine := AStateMachine;
    inherited SetParent(AStateMachine);
    Left := 10;
    Top := 10;
  end;
  if FStateMachine <> nil then
    FInactiveColor := FStateMachine.Color;
end;

function TApdCustomState.FindStateMachine : TApdCustomStateMachine;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to pred(Owner.ComponentCount) do
    if Owner.Components[I] is TApdCustomStateMachine then begin
      Result := TApdCustomStateMachine(Owner.Components[I]);
      Break;
    end;
end;

procedure TApdCustomState.Terminate(ErrorCode: Integer);
begin

end;

procedure TApdCustomState.SetActiveColor(const NewColor: TColor);
begin
  if NewColor <> FActiveColor then begin
    FActiveColor := NewColor;
    Refresh;
  end;
end;

procedure TApdCustomState.SetInactiveColor(const NewColor: TColor);
begin
  if NewColor <> FInactiveColor then begin
    FInactiveColor := NewColor;
    Invalidate;
  end;
end;

procedure TApdCustomState.SetCaption(const Value: TCaption);
begin
  inherited Caption := Value;
  FCaption := Value;
  Invalidate;
end;

{ TApdStateConnectoid }

procedure TApdStateConnectoid.Changed;
begin
  FCondition.Changed;
end;

constructor TApdStateConnectoid.Create(AOwner : TApdStateCondition);
begin
  FFont := TFont.Create;
  FCondition := AOwner;
  FCaption := 'Connectoid';
  FColor := clBlue;
  FWidth := 2;
  FSelected := False;
end;

destructor TApdStateConnectoid.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TApdStateConnectoid.SetCaption(const Value: TCaption);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TApdStateConnectoid.SetColor(const Value: TColor);
begin
  if FColor <> Value then begin
    FColor := Value;
    Changed;
  end;
end;

procedure TApdStateConnectoid.SetFont (const Value : TFont);
begin
  Font.Assign (Value);
end;

procedure TApdStateConnectoid.SetWidth (const Value: Integer);
begin
  if FWidth <> Value then begin
    FWidth := Value;
    Changed;
  end;
end;


{ TApdStateCondition }

procedure TApdStateCondition.Changed;
begin
  { force the state machine to redraw by setting the bounds of our state }
  { don't know why this works, but it does } 
  with TApdStateConditions(Collection).FState do
    SetBounds(Left, Top, Width, Height);
end;

constructor TApdStateCondition.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPacketSize := 0;
  FTimeout := 2048;
  FErrorCode := ecOK;
  FNextState := nil;
  FEndString := '';
  FStartString := '';
  FConnectoid := TApdStateConnectoid.Create (Self);
end;

destructor TApdStateCondition.Destroy;
begin
  FConnectoid.Free;
  inherited;
end;

function TApdStateCondition.GetCaption : TCaption;
begin
  if Assigned (FConnectoid) then
    Result := FConnectoid.Caption
  else
    Result := '';
end;

function TApdStateCondition.GetColor : TColor;
begin
  if Assigned (FConnectoid) then
    Result := FConnectoid.Color
  else
    Result := clNone;
end;

function TApdStateCondition.GetDisplayName: string;
begin
  Result := FConnectoid.Caption;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TApdStateCondition.GetFont : TFont;
begin
  if Assigned (FConnectoid) then
    Result := FConnectoid.Font
  else
    Result := TApdStateConditions(Collection).FState.Font;
end;

procedure TApdStateCondition.SetCaption (const v : TCaption);
begin
  if Assigned (FConnectoid) then
    FConnectoid.Caption := v;
end;

procedure TApdStateCondition.SetColor (const v : TColor);
begin
  if Assigned (FConnectoid) then
    FConnectoid.Color := v;
end;

procedure TApdStateCondition.SetConnectoid(
  const Value: TApdStateConnectoid);
begin
  if FConnectoid <> Value then begin
    FConnectoid := Value;
    Changed;
  end;
end;

procedure TApdStateCondition.SetFont (const v : TFont);
begin
  if Assigned (FConnectoid) then
    FConnectoid.Font.Assign (v);
end;

procedure TApdStateCondition.SetNextState(const Value: TApdCustomState);
begin
  if FNextState <> Value then begin
    FNextState := Value;
    Changed;
  end;
end;

{ TApdStateConditions }

function TApdStateConditions.Add: TApdStateCondition;
begin
  Result := TApdStateCondition(inherited Add);
  if (FState.Owner) is TWinControl then
    (FState.Owner as TWinControl).Repaint;
end;

constructor TApdStateConditions.Create(
  State: TApdCustomState; ItemClass: TCollectionItemClass);
begin
  FState := State;
  inherited Create(ItemClass);
end;

function TApdStateConditions.GetItem(Index: Integer): TApdStateCondition;
begin
  Result := TApdStateCondition(inherited GetItem(Index));
end;

function TApdStateConditions.GetOwner: TPersistent;
begin
  Result := FState;
end;

procedure TApdStateConditions.SetItem(Index: Integer;
  const Value: TApdStateCondition);
begin
  inherited SetItem(Index, Value);
end;

procedure TApdStateConditions.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  FState.FStateMachine.StateMachinePaint;
end;

end.

