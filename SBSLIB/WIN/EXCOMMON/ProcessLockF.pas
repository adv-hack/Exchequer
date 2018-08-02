unit ProcessLockF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, ComCtrls, AdvProgr;

type
  TProcessFormMode = (pfmMDI, pfmNormal);

  TRetryProc = function : Boolean of Object;

  TfrmProcessLock = class(TForm)
    btnCancel: TSBSButton;
    Label1: TLabel;
    Timer1: TTimer;
    ProgressBar: TAdvProgress;
    lblProcessType: TLabel;
    lblUserID: TLabel;
    lblTimeStamp: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FCancelProcedure : TNotifyEvent;
    FCurrentProgress : integer;
    FRetryProc : TRetryProc;
    FRetryCount : Integer;
  protected
    FFormMode : TProcessFormMode;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    constructor CreateWithMode(AOwner : TComponent; FormMode : TProcessFormMode = pfmMDI);
    property CancelProcedure : TNotifyEvent read FCancelProcedure write FCancelProcedure;
    property RetryProc : TRetryProc read FRetryProc write FRetryProc;
  end;

var
  frmProcessLock: TfrmProcessLock;

implementation

{$R *.dfm}

procedure TfrmProcessLock.btnCancelClick(Sender: TObject);
begin
  if Assigned(FCancelProcedure) then
    FCancelProcedure(Self);
end;

procedure TfrmProcessLock.CreateParams(var Params: TCreateParams);
begin
  if FFormMode = pfmMDI then
  begin
    FormStyle := fsMDIChild;
    Visible := True;
  end
  else
  begin
    FormStyle := fsNormal;
    Visible := False;
    Position := poMainFormCenter;
  end;

  inherited;

end;

constructor TfrmProcessLock.CreateWithMode(AOwner: TComponent;
  FormMode: TProcessFormMode = pfmMDI);
begin
  FFormMode := FormMode;
  inherited Create(AOwner);
end;

procedure TfrmProcessLock.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmProcessLock.FormCreate(Sender: TObject);
begin
  ClientHeight := 181;
  ClientWidth := 374;
{  Left := (Screen.Width div 2) - (Width div 2);
  Top  := (Screen.Height div 2) - (Height div 2);}
  FCurrentProgress := 2;
  FRetryProc := nil;
  FRetryCount :=0;
  ModalResult := mrNone;
end;

procedure TfrmProcessLock.Timer1Timer(Sender: TObject);
begin
  FCurrentProgress := FCurrentProgress + 2;
  if FCurrentProgress > 100 then
    FCurrentProgress := 2;

  ProgressBar.Position := FCurrentProgress;

  if Assigned(FRetryProc) then
  begin
    inc(FRetryCount);
    if FRetryCount >= 20 then
    begin
      FRetryCount := 0;
      if FRetryProc then
      begin
        ModalResult := mrOK;
        Timer1.Enabled := False;
//        FCancelProcedure(Self);
        PostMessage(Self.Handle, WM_Close, 0, 0);
      end;
//      Application.ProcessMessages;
    end;
  end;

end;


end.
