unit Serv1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TIRISExchequerScheduler = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
    Finished : Boolean;
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
  MainF, Registry, SchedVar, ElVar;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  IRISExchequerScheduler.Controller(CtrlCode);
end;

function TIRISExchequerScheduler.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TIRISExchequerScheduler.ServiceStart(Sender: TService; var Started: Boolean);
begin
  if Assigned(frmScheduler) then
  begin
    if Sender.ParamCount > 0 then
      DebugModeOn := UpperCase(Sender.Param[0]) = '/D';
    frmScheduler.ServiceCallBack := CallBack;
    PostMessage(frmScheduler.Handle, WM_StartPolling, 0, 0);
    Started := True;
  end
  else
    Started := False;
end;

procedure TIRISExchequerScheduler.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Stopped := True;
  if Assigned(frmScheduler) then
    PostMessage(frmScheduler.Handle, WM_ShutDown, 0, 0);
end;

procedure TIRISExchequerScheduler.CallBack(WhichFunc: Byte; const Msg: string);
begin
  Try
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

    3  : Try
           ServiceThread.ProcessRequests(False);
         Except
         End;
  end;
  Except
  End;
end;

procedure TIRISExchequerScheduler.ServiceCreate(Sender: TObject);
begin
  DisplayName := SchedServiceName;
end;

end.
