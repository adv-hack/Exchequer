unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Dialogs, Enterprise01_TLB, ComObj, AxCtrls, ActiveX, SchedulerPlugIn_TLB
  , ExScheduler_TLB, StdVcl;

type
  TReverseVATUpdateTX = class(TAutoObject, IConnectionPointContainer, IReverseVATUpdateTX, IScheduledTask)
  private
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IScheduledTaskEvents;
    procedure UpdateProgress(sMessage : string);
  public
    procedure Initialize; override;
  protected
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure ThisEventConnect(const Sink: IUnknown;  Connecting: Boolean);
    function Test: WideString; safecall;

    function Get_stType: WideString; safecall;
    function Get_stName: WideString; safecall;
    procedure Set_stName(const Value: WideString); safecall;
    procedure Run; safecall;
    procedure ShowDetails(DisplayWindow: Integer); safecall;
    procedure FreeDetails; safecall;
    procedure Load; safecall;
    procedure Save; safecall;
    function Get_stFirstControl: Integer; safecall;
    function Get_stNextControl: Integer; safecall;
    procedure Set_stNextControl(Value: Integer); safecall;
    function Get_stPrevControl: Integer; safecall;
    procedure Set_stPrevControl(Value: Integer); safecall;
    function Get_stLastControl: Integer; safecall;
    function Get_stDataPath: WideString; safecall;
    procedure Set_stDataPath(const Value: WideString); safecall;
    property stType: WideString read Get_stType;
    property stName: WideString read Get_stName write Set_stName;
    property stFirstControl: Integer read Get_stFirstControl;
    property stNextControl: Integer read Get_stNextControl write Set_stNextControl;
    property stPrevControl: Integer read Get_stPrevControl write Set_stPrevControl;
    property stLastControl: Integer read Get_stLastControl;
    property stDataPath: WideString read Get_stDataPath write Set_stDataPath;
  end;

implementation

uses
  RSCLProc, SysUtils, SecCodes, PIUtils, RVProc, Silencer, ComServ;

{ TReverseVATUpdateTX }

procedure TReverseVATUpdateTX.EventSinkChanged(
  const EventSink: IInterface);
begin
//  inherited;
  FEvents := EventSink as IScheduledTaskEvents;
end;

procedure TReverseVATUpdateTX.FreeDetails;
begin

end;

function TReverseVATUpdateTX.Get_stDataPath: WideString;
begin

end;

function TReverseVATUpdateTX.Get_stFirstControl: Integer;
begin

end;

function TReverseVATUpdateTX.Get_stLastControl: Integer;
begin

end;

function TReverseVATUpdateTX.Get_stName: WideString;
begin

end;

function TReverseVATUpdateTX.Get_stNextControl: Integer;
begin

end;

function TReverseVATUpdateTX.Get_stPrevControl: Integer;
begin

end;

function TReverseVATUpdateTX.Get_stType: WideString;
begin
  Result := 'Reverse Charge VAT RCSL Plug-In'
end;

procedure TReverseVATUpdateTX.Initialize;
begin
//  inherited;
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  FConnectionPoint := FConnectionPoints.CreateConnectionPoint(IScheduledTaskEvents
  , ckSingle, ThisEventConnect)
end;

procedure TReverseVATUpdateTX.Load;
begin

end;

procedure TReverseVATUpdateTX.Run;
begin
  UpdateRSCL(CompanyRec.Path, UpdateProgress, FALSE);
//  FEvents.OnProgress('Processing Transaction : ' + thOurRef,0);
end;

procedure TReverseVATUpdateTX.UpdateProgress(sMessage : string);
begin
  FEvents.OnProgress(sMessage,0);
end;

procedure TReverseVATUpdateTX.Save;
begin

end;

procedure TReverseVATUpdateTX.Set_stDataPath(const Value: WideString);
begin
  CompanyRec.Path := Value;
end;

procedure TReverseVATUpdateTX.Set_stName(const Value: WideString);
begin

end;

procedure TReverseVATUpdateTX.Set_stNextControl(Value: Integer);
begin

end;

procedure TReverseVATUpdateTX.Set_stPrevControl(Value: Integer);
begin

end;

procedure TReverseVATUpdateTX.ShowDetails(DisplayWindow: Integer);
begin

end;

function TReverseVATUpdateTX.Test: WideString;
begin

end;

procedure TReverseVATUpdateTX.ThisEventConnect(const Sink: IInterface;
  Connecting: Boolean);
var
  LEventSink : IUnknown;
begin
  if Connecting then
  begin
    OleCheck(Sink.QueryInterface(IScheduledTaskEvents, LEventSink));
    EventSink := LEventSink;
    EventSinkChanged(TMyDispatchSilencer.Create(Sink, IScheduledTaskEvents));
  end
  else
  begin
    EventSink := nil;
    EventSinkChanged(nil);
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TReverseVATUpdateTX, Class_ReverseVATUpdateTX,
    ciSingleInstance, tmApartment);
end.
