{*********************************************************}
{*                   ADRSTAT.PAS 4.03                    *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdRStat;
  {-Delphi remote access (RAS) dialer status component}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  OoMisc,
  AdRas,
  ExtCtrls;


type {Status display}
  TRasStatusDisplay = class(TForm)
    CancelBtn: TButton;
    Panel1: TPanel;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    RasDialer : TApdCustomRasDialer;
  end;

type {RAS dial status component}
  TApdRasStatus = class(TApdAbstractRasStatus)
  protected
    FHandle : HWND;                                                  
    procedure CMRasStatus(var Msg : TMessage);                       
  public
    constructor Create(AOwner: TComponent); override;                
    destructor  Destroy; override;                                   

    procedure CreateDisplay(const EntryName : string); override;
    procedure DestroyDisplay; override;
    procedure UpdateDisplay(const StatusMsg : string); override;

    property Handle : HWND                                           
      read FHandle write FHandle;                                    
  end;

implementation

{$IFDEF TRIALRUN}
{$I TRIAL07.INC}
{$I TRIAL03.INC}
{$I TRIAL01.INC}
{$ENDIF}
const
  CM_APDRASSTATUS = WM_USER + $0719;
  CancelDialing = 1;

{$R *.DFM}

{ TRasStatusDisplay }
procedure TRasStatusDisplay.CancelBtnClick(Sender: TObject);
begin
  if (TApdRasStatus(Owner).Handle <> 0) then
    PostMessage(TApdRasStatus(Owner).Handle, CM_APDRASSTATUS, CancelDialing, 0);
end;


{ TApdRasStatus }

constructor TApdRasStatus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := AllocateHWnd(CMRasStatus);
end;

destructor TApdRasStatus.Destroy;
begin
  if (FHandle <> 0) then
    DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TApdRasStatus.CreateDisplay(const EntryName : string);
begin
  if not Assigned(FDisplay) then begin
    Display := TRasStatusDisplay.Create(Self);
    Display.Ctl3D := FCtl3D;
    Display.Position := FPosition;
    Display.Caption := 'Connecting to ' + EntryName + '...';
    TRasStatusDisplay(Display).RasDialer := RasDialer;
    Display.Show;
  end;
end;

procedure TApdRasStatus.DestroyDisplay;
begin
  if Assigned(Display) then
    Display.Free;
  Display := nil;
end;

procedure TApdRasStatus.UpdateDisplay(const StatusMsg : string);
{$IFDEF TRIALRUN}
{$I TRIAL04.INC}
{$ENDIF}
begin
  {$IFDEF TRIALRUN}
  TC;
  {$ENDIF}
  if Assigned(FDisplay) then
    TRasStatusDisplay(FDisplay).Panel1.Caption := StatusMsg;
end;

procedure TApdRasStatus.CMRasStatus(var Msg : TMessage);
begin
  if (Msg.Msg = CM_APDRASSTATUS) then begin
    if (Msg.wParam = CancelDialing) then
      if Assigned(RasDialer) then
        RasDialer.Hangup;
  end;
end;

end.
