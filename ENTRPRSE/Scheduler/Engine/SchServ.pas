unit SchServ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TIRISExchequerScheduler = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
    FOkToRun : Boolean;
    procedure CallBack(WhichFunc : Byte; Const Msg : string = '');
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  IRISExchequerScheduler: TIRISExchequerScheduler;

implementation

{$R *.DFM}
uses
  MainF, Registry, SchedVar;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  IRISExchequerScheduler.Controller(CtrlCode);
end;

function TIRISExchequerScheduler.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TIRISExchequerScheduler.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  if Assigned(frmScheduler) then
  begin
    frmScheduler.ServiceCallBack := CallBack;
    frmScheduler.StartPolling;
  end;
  Started := True;
end;

procedure TIRISExchequerScheduler.ServiceCreate(Sender: TObject);
begin
  DisplayName := SchedServiceName;
  FOkToRun := True;
end;

procedure TIRISExchequerScheduler.CallBack(WhichFunc: Byte; const Msg: string);
begin
  Case WhichFunc of
    1  : begin
           LogMessage(Msg, EVENTLOG_WARNING_TYPE, 0, 2);
           Status := csStopped;
           ReportStatus;
           frmScheduler.ShutDown;
         end;
    2  : begin
           LogMessage(Msg, EVENTLOG_INFORMATION_TYPE, 0, 3);
         end;
  end;
end;

procedure TIRISExchequerScheduler.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  Stopped := True;
  frmScheduler.ShutDown;
end;

procedure TIRISExchequerScheduler.ServiceAfterInstall(Sender: TService);
begin
  with TRegistry.Create(KEY_READ or KEY_WRITE) do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('SYSTEM\CurrentControlSet\Services\' + Name, True) then
    begin
      WriteString('Description', SchedServiceDesc);
    end
  finally
    Free;
  end;
end;

end.
