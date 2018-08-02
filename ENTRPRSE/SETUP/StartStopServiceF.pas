unit StartStopServiceF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, SetupU, ServiceManager, WinSvc;

function StartService (var DLLParams: ParamRec): LongBool; StdCall; export;
function StopService (var DLLParams: ParamRec): LongBool; StdCall; export;

type
  TServiceMode = (smStart, smStop);

  TfrmStartStopService = class(TSetupTemplate)
    lblDesc: TLabel;
    btnStartStopService: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnStartStopServiceClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FMode : TServiceMode;
    FServiceName : ANSIString;
    FServiceDesc : ShortString;
    oServiceManager : TServiceManager;
    Procedure SetMode (Value : TServiceMode);
    Procedure SetServiceName (Value : ANSIString);
    Procedure SetServiceDesc (Value : ShortString);
    Procedure UpdateDialog;
  public
    { Public declarations }
    Property Mode : TServiceMode Read FMode Write SetMode;
    Property ServiceName : ANSIString Read FServiceName Write SetServiceName;
    Property ServiceDesc : ShortString Read FServiceDesc Write SetServiceDesc;
  End; // TfrmStartStopService


implementation

{$R *.dfm}

Uses StrUtils, APIUtil;

//=========================================================================

Procedure DisplayStartStopServiceDlg (var DLLParams: ParamRec; Const ServiceMode : TServiceMode);
Var
  frmStartStopService : TfrmStartStopService;
  W_ServiceName, W_ServiceDesc : String;
Begin // DisplayStartStopServiceDlg
  frmStartStopService := TfrmStartStopService.Create(Application);
  Try
    frmStartStopService.Mode := ServiceMode;

    GetVariable(DLLParams, 'V_SERVICENAME', W_ServiceName);
    frmStartStopService.ServiceName := W_ServiceName;

    GetVariable(DLLParams, 'V_SERVICEDESC', W_ServiceDesc);
    frmStartStopService.ServiceDesc := W_ServiceDesc;

    frmStartStopService.ShowModal;
  Finally
    frmStartStopService.Free;
  End; // Try..Finally
End; // DisplayStartStopServiceDlg

//------------------------------

function StartService (var DLLParams: ParamRec): LongBool;
Begin // StartService
  DisplayStartStopServiceDlg (DLLParams, smStart);
  Result := False;
End; // StartService

//------------------------------

function StopService (var DLLParams: ParamRec): LongBool;
Begin // StopService
  DisplayStartStopServiceDlg (DLLParams, smStop);
  Result := False;
End; // StopService

//=========================================================================

procedure TfrmStartStopService.FormCreate(Sender: TObject);
begin
  inherited;
  ExitMsg := 255;  // Suppress query on close of form
  oServiceManager:=NIL;
end;

//------------------------------

procedure TfrmStartStopService.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oServiceManager);
  inherited;
end;

//-------------------------------------------------------------------------

Procedure TfrmStartStopService.UpdateDialog;
Begin // UpdateDialog
  ModifyCaptions ('<Action>', IfThen(FMode=smStart, 'Start','Stop'), [TitleLbl, lblDesc, btnStartStopService]);
  ModifyCaptions ('<ServiceDesc>', FServiceDesc, [lblDesc]);

  Case FMode Of
    smStart : Begin
                Self.Caption := 'Start ' + FServiceDesc + ' Service?';
                InstrLbl.Caption := 'The ' + FServiceDesc + ' Service is already installed but is not currently running.';
              End; // smStart

    smStop  : Begin
                Self.Caption := 'Stop ' + FServiceDesc + ' Service?';
                InstrLbl.Caption := 'The ' + FServiceDesc + ' Service is already installed and is currently running.';
              End; // smStop
  End; // Case FMode
End; // UpdateDialog

//------------------------------

Procedure TfrmStartStopService.SetMode (Value : TServiceMode);
Begin // SetMode
  If (Value <> FMode) Then
  Begin
    FMode := Value;
    UpdateDialog;
  End; // If (Value <> FMode)
End; // SetMode

//------------------------------

Procedure TfrmStartStopService.SetServiceName (Value : ANSIString);
Begin // SetServiceName
  If (Value <> FServiceName) Then
  Begin
    FServiceName := Value;
    UpdateDialog;
  End; // If (Value <> FServiceName)
End; // SetServiceName

//------------------------------

Procedure TfrmStartStopService.SetServiceDesc (Value : ShortString);
Begin // SetServiceDesc
  If (Value <> FServiceDesc) Then
  Begin
    FServiceDesc := Value;
    UpdateDialog;
  End; // If (Value <> FServiceDesc)
End; // SetServiceDesc

//-------------------------------------------------------------------------

procedure TfrmStartStopService.btnStartStopServiceClick(Sender: TObject);
Var
  sComp : ANSIString;
begin
  // Connect to the Services sub-system
  sComp := WinGetComputerName;
  oServiceManager := TServiceManager.Create;
  If oServiceManager.Connect(PCHAR(sComp), NIL, SC_MANAGER_ALL_ACCESS) Then
  Begin
    // Connect to the service itself
    If oServiceManager.OpenServiceConnection(PCHAR(FServiceName)) Then
    Begin
      Case FMode Of
        smStart : Begin
                    If oServiceManager.StartService Then
                    Begin
                      MessageDlg ('The ' + FServiceDesc + ' Service has been successfully started', mtInformation, [mbOK], 0);
                      ModalResult := mrOK;
                    End // If oServiceManager.StartService
                    Else
                      MessageDlg ('An unknown error occurred trying to start the ' + FServiceDesc + ' Service', mtInformation, [mbOK], 0);
                  End; // smStart

        smStop  : Begin
                    If oServiceManager.StopService Then
                    Begin
                      MessageDlg ('The ' + FServiceDesc + ' Service has been successfully stopped', mtInformation, [mbOK], 0);
                      ModalResult := mrOK;
                    End // If oServiceManager.StopService
                    Else
                      MessageDlg ('An unknown error occurred trying to stop the ' + FServiceDesc + ' Service', mtInformation, [mbOK], 0);
                  End; // smStop
      End; // Case FMode
    End // If oServiceManager.OpenServiceConnection(FServiceName)
    Else
      ShowMessage ('Failed to open service connection');
  End // If oServiceManager.Connect(...
  Else
    ShowMessage ('Failed to connect');
end;

//-------------------------------------------------------------------------

end.
