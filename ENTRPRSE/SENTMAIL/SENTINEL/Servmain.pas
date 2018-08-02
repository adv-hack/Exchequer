unit Servmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TSentimailVAOService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
    FOkToRun : Boolean;
    procedure CallBack(WhichFunc : Byte; Const Msg : string = '');
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  SentimailVAOService: TSentimailVAOService;

implementation

{$R *.DFM}
uses
  Thread1, Registry, ElVar;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SentimailVAOService.Controller(CtrlCode);
end;

procedure TSentimailVAOService.CallBack(WhichFunc: Byte; Const Msg : string = '');
begin
  Case WhichFunc of
    1  : begin
           LogMessage(Msg, EVENTLOG_ERROR_TYPE, 0, 0);
           Status := csStopped;
           ReportStatus;
           frmThreadMaster.ShutDown;
         end;
    2  : begin
           LogMessage(Msg, EVENTLOG_INFORMATION_TYPE, 0, 3);
         end;
  end;
end;

function TSentimailVAOService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TSentimailVAOService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  if Assigned(frmThreadMaster) then
  begin
    frmThreadMaster.ServiceCallBack := CallBack;
    frmThreadMaster.StartPolling;
    Started := True;
  end;
end;

procedure TSentimailVAOService.ServiceCreate(Sender: TObject);
begin
  FOkToRun := True;
end;

procedure TSentimailVAOService.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
   frmThreadMaster.ShutDown;
{   SleepEx(1000, True);
   Stopped := True;}
end;




procedure TSentimailVAOService.ServiceAfterInstall(Sender: TService);
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

procedure TSentimailVAOService.ServiceExecute(Sender: TService);
begin
    while not Terminated do begin

      ServiceThread.ProcessRequests(True);
    end;
end;

end.
