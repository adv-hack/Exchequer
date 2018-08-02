unit Statusbr;

interface

uses
  SysUtils, Windows,  Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Menus, Gauges;

Const
  gfsr_SystemResources  = $0000;

type
  TStatus = class(TCustomPanel)
  private
    FDate         : Boolean;
    FKeys         : Boolean;
    FTime         : Boolean;
    FResources    : Boolean;
    DateTimePanel : TPanel;
    ResPanel      : TPanel;
    ResGauge      : TGauge;
    CapPanel      : TPanel;

    NumPanel      : TPanel;
    InsPanel      : TPanel;
    HelpPanel     : TPanel;
    UpdateWidth   : Boolean;
    fDiskSize     : LongInt;

    FTimer        : TTimer;
    procedure SetDate(A: Boolean);
    procedure SetKeys(A: Boolean);
    procedure SetTime(A: Boolean);
    procedure SetResources(A: Boolean);
    procedure SetCaption(A: String);
    Function  GetCaption: String;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetupPanelFields(ThePanel: TPanel);
    procedure SetupPanel(ThePanel: TPanel; WidthMask: String);
    procedure UpdateStatusBar(Sender: TObject);
  published
    property ShowDate: Boolean read FDate write SetDate default True;
    property ShowKeys: Boolean read FKeys write SetKeys default True;

    property ShowTime: Boolean read FTime write SetTime default True;
    property ShowResources: Boolean read FResources write SetResources default True;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property BorderWidth;
    property Caption: string read GetCaption write SetCaption;

    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3d;
    property ParentFont;
    property ParentShowHint;
    property PopUpMenu;
    property ShowHint;
    property Visible;
  end;

procedure Register;


implementation

Uses
  ETMiscU;

function GetFreeDiskResource(Drive :  Word; MDiskSize  :  LongInt)  :  LongInt;

Var
  fDiskFree   :  LongInt;

Begin

  fDiskFree:=DiskFree(Drive);

  Result:=Round(DivWChk(fDiskFree,MDiskSize)*100);

end;

procedure Register;
begin
  RegisterComponents('Additional', [TStatus]);
end;

procedure TStatus.SetupPanelFields(ThePanel: TPanel);
begin
  with ThePanel do
    begin
      Alignment := taCenter;
      Caption := '';
      BevelInner := bvLowered;
      BevelOuter := bvNone;
      {Set all these true so they reflect the settings of the TStatus}
      ParentColor := True;
      ParentFont := True;

      ParentCtl3D := True;
    end;
end;

procedure TStatus.SetupPanel(ThePanel: TPanel; WidthMask: String);
begin
  SetupPanelFields(ThePanel);
  with ThePanel do
    begin
      Width := Canvas.TextWidth(WidthMask);
      Align := alRight;
    end;
end;

constructor TStatus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);

  FTime := True;
  FDate := True;
  FKeys := True;
  FResources := True;
  {Force the status bar to be aligned bottom}
  Align := alBottom;
  Height := 19;
  BevelInner := bvNone;
  BevelOuter := bvRaised;
  {When UpdateWidth is set TRUE, status bar will recalculate panel widths once}
  UpdateWidth := True;
  Locked := True;
  TabOrder := 0;;
  TabStop := False;
  Font.Name := 'Arial';
  Font.Size := 8;
  {Create the panel that will hold the date & time}

  DateTimePanel := TPanel.Create(Self);
  DateTimePanel.Parent := Self;
  SetupPanel(DateTimePanel,'  00/00/00 00:00:00 am  ');
  {Create the panel that will hold the resources graph}
  ResPanel := TPanel.Create(Self);
  ResPanel.Parent := Self;
  SetupPanel(ResPanel,'                    ');
  {Create the 2 Gauges that will reside within the Resource Panel}
  ResGauge := TGauge.Create(Self);
  ResGauge.Parent := ResPanel;
  ResGauge.Align := alClient;

  ResGauge.ParentFont := True;
  ResGauge.BackColor := Color;
  ResGauge.ForeColor := clLime;
  ResGauge.BorderStyle := bsNone;
  {Create the panel that will hold the CapsLock state}
  CapPanel := TPanel.Create(Self);
  CapPanel.Parent := Self;
  SetupPanel(CapPanel,'  Cap  ');
  {Create the panel that will hold the NumLock state}
  NumPanel := TPanel.Create(Self);
  NumPanel.Parent := Self;
  SetupPanel(NumPanel,'  Num  ');

  {Create the panel that will hold the Insert/Overwrite state}
  InsPanel := TPanel.Create(Self);
  InsPanel.Parent := Self;
  SetupPanel(InsPanel,'  Ins  ');
  {Create the panel that will hold the status text}
  HelpPanel := TPanel.Create(Self);
  HelpPanel.Parent := Self;
  SetupPanelFields(HelpPanel);
  {Have the help panel consume all remaining space}
  HelpPanel.Align := alClient;
  HelpPanel.Alignment := taLeftJustify;

  fDiskSize:=DiskSize(16);

  {This is the timer that will update the status bar at regular intervals}
  FTimer := TTimer.Create(Self);
  If FTimer <> Nil then
    begin
      FTimer.OnTimer := UpdateStatusBar;
      {Updates will occur twice a second}
      FTimer.Interval := 500;
      FTimer.Enabled := True;
    end;
end;

destructor TStatus.Destroy;
begin
  FTimer.Free;
  HelpPanel.Free;

  InsPanel.Free;
  NumPanel.Free;
  CapPanel.Free;
  ResGauge.Free;
  ResPanel.Free;
  DateTimePanel.Free;
  inherited Destroy;
end;

procedure TStatus.SetDate(A: Boolean);
begin
  FDate := A;
  UpdateWidth := True;
end;

procedure TStatus.SetKeys(A: Boolean);
begin
  FKeys := A;
  UpdateWidth := True;
end;

procedure TStatus.SetTime(A: Boolean);
begin

  FTime := A;
  UpdateWidth := True;
end;

procedure TStatus.SetResources(A: Boolean);
begin
  FResources := A;
  UpdateWidth := True;
end;

{When we set or get the TStatus caption, it is affecting the HelpPanel caption instead}
procedure TStatus.SetCaption(A: String);
begin
  HelpPanel.Caption := ' '+A;
end;

function TStatus.GetCaption: String;
begin

  GetCaption := HelpPanel.Caption;
end;

{This procedure sets the captions appropriately}
procedure TStatus.UpdateStatusBar(Sender: TObject);
begin
  if ShowDate and ShowTime then
    DateTimePanel.Caption := DateTimeToStr(Now)
  else
    if ShowDate and not ShowTime then
      DateTimePanel.Caption := DateToStr(Date)
    else
      if not ShowDate and ShowTime then

        DateTimePanel.Caption := TimeToStr(Time)
      else
        DateTimePanel.Caption := '';
  if UpdateWidth then with DateTimePanel do
    if ShowDate or ShowTime then
      Width := Canvas.TextWidth('  '+Caption+'  ')
    else
      Width := 0;
  if ShowResources then
    begin
      ResGauge.Progress := GetFreeDiskResource(16,fDiskSize);

      if ResGauge.Progress < 20 then
        ResGauge.ForeColor := clRed
      else
        ResGauge.ForeColor := clLime;
    end;
  if UpdateWidth then
    if ShowResources then
      ResPanel.Width := Canvas.TextWidth('                    ')
    else
      ResPanel.Width := 0;
  if ShowKeys then
    begin
      if (GetKeyState(vk_NumLock) and $01) <> 0 then

        NumPanel.Caption := '  Num  ' else NumPanel.Caption := '';
      if (GetKeyState(vk_Capital) and $01) <> 0 then
        CapPanel.Caption := '  Cap  ' else CapPanel.Caption := '';
      if (GetKeyState(vk_Insert) and $01) <> 0 then
        InsPanel.Caption := '  Ins  ' else InsPanel.Caption := '';
    end;
  if UpdateWidth then
    if ShowKeys then

      begin
        NumPanel.Width := Canvas.TextWidth(' Num ');
        InsPanel.Width := Canvas.TextWidth(' Ins ');
        CapPanel.Width := Canvas.TextWidth(' Cap ');
      end
    else
      begin
        NumPanel.Width := 0;
        InsPanel.Width := 0;
        CapPanel.Width := 0;
      end;
  UpdateWidth := False;
end;

{This allows font changes to be detected so the panels will be adjusted}

procedure TStatus.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateWidth := True;
end;

end.




