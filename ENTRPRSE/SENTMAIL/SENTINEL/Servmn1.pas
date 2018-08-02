unit Servmn1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TSentimailService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceShutdown(Sender: TService);
  private
    { Private declarations }
    FOkToRun : Boolean;
    procedure CallBack(WhichFunc : Byte; Const Msg : string = '');
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  SentimailService: TSentimailService;

implementation

{$R *.DFM}
uses
  SDIMainf, Registry, ElVar;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SentimailService.Controller(CtrlCode);
end;

procedure TSentimailService.CallBack(WhichFunc: Byte; Const Msg : string = '');
begin
  Case WhichFunc of
    1  : begin
           LogMessage(Msg, EVENTLOG_WARNING_TYPE, 0, 2);
           Status := csStopped;
           ReportStatus;
           frmEngine.ShutDown;
         end;
    2  : begin
           LogMessage(Msg, EVENTLOG_INFORMATION_TYPE, 0, 3);
         end;
  end;
end;

function TSentimailService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TSentimailService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  if Assigned(frmEngine) then
  begin
    frmEngine.ServiceCallBack := CallBack;
    PostMessage(frmEngine.Handle, WM_StartPolling, 0, 0);
//    frmThreadMaster.StartPolling;
  end;
  Started := True;
end;

procedure TSentimailService.ServiceCreate(Sender: TObject);
begin
  FOkToRun := True;
end;

procedure TSentimailService.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
   Stopped := True;
   PostMessage(frmEngine.Handle, WM_SHUTDOWN, 0, 0);
//   frmThreadMaster.ShutDown;
{   SleepEx(1000, True);
   Stopped := True;}
end;




procedure TSentimailService.ServiceAfterInstall(Sender: TService);
begin
  with TRegistry.Create(KEY_READ or KEY_WRITE) do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('SYSTEM\CurrentControlSet\Services\' + Name, True) then
    begin
      WriteString('Description', ElServiceDesc);
    end
  finally
    Free;
  end;
end;


procedure TSentimailService.ServiceShutdown(Sender: TService);
var
  FinishCount : longint;
begin
  SleepEx(2000, True);
  FinishCount := 1;
  while not OKToClose and (FinishCount < ServiceTimeOut) do
  begin
    SleepEx(1000, True);
    inc(FinishCount);
  end;
end;

end.
