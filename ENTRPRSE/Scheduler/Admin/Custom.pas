unit Custom;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, ExScheduler_TLB, StdVcl;

type
  TScheduledTask = class(TAutoObject, IConnectionPointContainer, IScheduledTask)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IScheduledTaskEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
  public
    procedure Initialize; override;
  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function Get_stName: WideString; safecall;
    function Get_stType: WideString; safecall;
    procedure Run; safecall;
    procedure Set_stName(const Value: WideString); safecall;
    procedure ShowDetails(DisplayWindow: Integer); safecall;
    procedure FreeDetails; safecall;
    function ErrorString(ErrorNo: Integer): WideString; safecall;
    procedure Load; safecall;
    procedure Save; safecall;
    procedure SetActiveControl; safecall;
    function Get_stFirstControl: Integer; safecall;
    function Get_stNextControl: Integer; safecall;
    procedure Set_stNextControl(Value: Integer); safecall;
    function Get_stLastControl: Integer; safecall;
    function Get_stPrevControl: Integer; safecall;
    procedure Set_stPrevControl(Value: Integer); safecall;
    function Get_stDataPath: WideString; safecall;
    procedure Set_stDataPath(const Value: WideString); safecall;
    function Get_stPath: WideString; safecall;
    procedure Set_stPath(const Value: WideString); safecall;
  end;

implementation

uses ComServ;

procedure TScheduledTask.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IScheduledTaskEvents;
end;

procedure TScheduledTask.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
end;


function TScheduledTask.Get_stName: WideString;
begin

end;

function TScheduledTask.Get_stType: WideString;
begin

end;

procedure TScheduledTask.Run;
begin

end;

procedure TScheduledTask.Set_stName(const Value: WideString);
begin

end;

procedure TScheduledTask.ShowDetails(DisplayWindow: Integer);
begin

end;

procedure TScheduledTask.FreeDetails;
begin

end;

function TScheduledTask.ErrorString(ErrorNo: Integer): WideString;
begin

end;

procedure TScheduledTask.Load;
begin

end;

procedure TScheduledTask.Save;
begin

end;

procedure TScheduledTask.SetActiveControl;
begin

end;

function TScheduledTask.Get_stFirstControl: Integer;
begin

end;

function TScheduledTask.Get_stNextControl: Integer;
begin

end;

procedure TScheduledTask.Set_stNextControl(Value: Integer);
begin

end;

function TScheduledTask.Get_stLastControl: Integer;
begin

end;

function TScheduledTask.Get_stPrevControl: Integer;
begin

end;

procedure TScheduledTask.Set_stPrevControl(Value: Integer);
begin

end;

function TScheduledTask.Get_stDataPath: WideString;
begin

end;

procedure TScheduledTask.Set_stDataPath(const Value: WideString);
begin

end;

function TScheduledTask.Get_stPath: WideString;
begin

end;

procedure TScheduledTask.Set_stPath(const Value: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TScheduledTask, Class_ScheduledTask,
    ciSingleInstance, tmApartment);
end.
