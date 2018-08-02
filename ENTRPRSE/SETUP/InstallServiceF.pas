unit InstallServiceF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, SetupU, ServiceManager, WinSvc;

function InstallService (var DLLParams: ParamRec): LongBool; StdCall; export;

type
  TfrmInstallService = class(TSetupTemplate)
    lblDesc: TLabel;
    btnInstallService: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnInstallServiceClick(Sender: TObject);
  private
    FServiceName : ANSIString;
    FServiceDesc : ShortString;
    oServiceManager : TServiceManager;
    Procedure SetServiceName (Value : ANSIString);
    Procedure SetServiceDesc (Value : ShortString);
    Procedure UpdateDialog;
  public
    { Public declarations }
    Property ServiceName : ANSIString Read FServiceName Write SetServiceName;
    Property ServiceDesc : ShortString Read FServiceDesc Write SetServiceDesc;
  End; // TfrmInstallService


implementation

{$R *.dfm}

Uses StrUtils, APIUtil;

//=========================================================================

function InstallService (var DLLParams: ParamRec): LongBool;
Var
  frmInstallService : TfrmInstallService;
  W_ServiceName, W_ServiceDesc : String;
Begin // StartService
  Result := False;

  frmInstallService := TfrmInstallService.Create(Application);
  Try
    GetVariable(DLLParams, 'V_SERVICENAME', W_ServiceName);
    frmInstallService.ServiceName := W_ServiceName;

    GetVariable(DLLParams, 'V_SERVICEDESC', W_ServiceDesc);
    frmInstallService.ServiceDesc := W_ServiceDesc;

    frmInstallService.ShowModal;

    Result := (frmInstallService.ExitCode = 'Y');
  Finally
    frmInstallService.Free;
  End; // Try..Finally
End; // StartService

//=========================================================================

procedure TfrmInstallService.FormCreate(Sender: TObject);
begin
  inherited;
  ExitMsg := 255;  // Suppress query on close of form
end;

//-------------------------------------------------------------------------

Procedure TfrmInstallService.UpdateDialog;
Begin // UpdateDialog
  If (FServiceDesc <> '') Then ModifyCaptions ('<ServiceDesc>', FServiceDesc, [InstrLbl, lblDesc]);
End; // UpdateDialog

//------------------------------

Procedure TfrmInstallService.SetServiceName (Value : ANSIString);
Begin // SetServiceName
  If (Value <> FServiceName) Then
  Begin
    FServiceName := Value;
    UpdateDialog;
  End; // If (Value <> FServiceName)
End; // SetServiceName

//------------------------------

Procedure TfrmInstallService.SetServiceDesc (Value : ShortString);
Begin // SetServiceDesc
  If (Value <> FServiceDesc) Then
  Begin
    FServiceDesc := Value;
    UpdateDialog;
  End; // If (Value <> FServiceDesc)
End; // SetServiceDesc

//-------------------------------------------------------------------------

procedure TfrmInstallService.btnInstallServiceClick(Sender: TObject);
begin
  ExitCode := 'Y';
  Close;
end;

//-------------------------------------------------------------------------

end.
