unit Security;

interface

uses
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, ExtCtrls;

Const
  TSystemSecurity_Version = 'v1.00 (D6)';

type
  TAutoClose = (acNo, acManual, acAuto);

  TTimeoutEvent = procedure (Sender: TObject; Var RestartTimer : Boolean) Of Object;

  TSystemSecurity = class(TComponent)
  private
    { Private declarations }
    FEnabled: Boolean;
    FLastActionTime: DWord;
    FTimeout: DWord;
    FTimeoutResolution: LongInt;

    FOnTimeout: TTimeoutEvent;

    { For Hidden Properties }
    FTag : LongInt;

    function GetVersion: ShortString;
    procedure SetVersion(const Value: ShortString);
    procedure SetTimeoutResolution(const Value: LongInt);
    procedure SetTimeout(const Value: DWord);
    procedure SetEnabled(const Value: Boolean);
  protected
    { Protected declarations }
    FTimeoutTimer : TTimer;

    Procedure   Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    procedure AppOnMessage (var Msg: TMsg; var Handled: Boolean);
    procedure TimerOnTimer(Sender: TObject);
  published
    { Published declarations }
    Property Enabled : Boolean Read FEnabled Write SetEnabled;
    Property Timeout : DWord Read FTimeout Write SetTimeout;
    Property TimeoutResolution : LongInt Read FTimeoutResolution Write SetTimeoutResolution;
    Property Version : ShortString Read GetVersion Write SetVersion;

    Property OnTimeout : TTimeoutEvent Read FOnTimeout Write FOnTimeout;

    { Hide the following declarations }
    Property Tag : LongInt Read FTag;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SBS', [TSystemSecurity]);
end;

//---------------------------------------------------------------------------

constructor TSystemSecurity.Create(AOwner: TComponent);
begin
  inherited;

  // Set default properties
  FEnabled := True;

  // Properties for the Timeout mechanism
  FLastActionTime := 0;
  FTimeout := 0;                    // 0 - Disabled
  FTimeoutResolution := 20000;      // 20 seconds
  FOnTimeout := NIL;
  FTimeoutTimer := NIL;

  // Create lists for storing UserIds, ComputerNames, etc...
end;

destructor TSystemSecurity.Destroy;
begin
  // Destroy any timer in existance
  If Assigned(FTimeoutTimer) Then Begin
    FTimeoutTimer.Enabled := False;
    FreeAndNIL(FTimeoutTimer);
  End; { If Assigned(FTimeoutTimer) }

  inherited;
end;

//-------------------------------------------

procedure TSystemSecurity.Loaded;
begin
  inherited;

  If FEnabled Then Begin
    // Component Loaded - Check Security
    // ???

    If (FTimeout > 0) And Assigned(FTimeoutTimer) Then Begin
      // Setup hook on Application.OnMessage for timeout
      Application.OnMessage := AppOnMessage;
      FTimeoutTimer.Enabled := True;
    End; { If (FTimeout > 0) And Assigned(FTimeoutTimer) }
  End; { If FEnabled }
end;

//---------------------------------------------------------------------------

procedure TSystemSecurity.SetTimeout(const Value: DWord);
begin
  FTimeout := Value;

  If (FTimeout > 0) Then Begin
    // Timeout Enabled - Create and configure the timer as necessary
    If (Not Assigned(FTimeoutTimer)) Then
      FTimeoutTimer := TTimer.Create(Self);

    With FTimeoutTimer Do Begin
      Enabled := False;
      Interval := FTimeoutResolution;
      OnTimer := TimerOnTimer;
    End; { With FTimeoutTimer }
  End { If (FTimeout > 0) }
  Else
    // timeout disabled - destroy timer if it exists
    FreeAndNIL(FTimeoutTimer);
end;

//-------------------------------------------

procedure TSystemSecurity.SetTimeoutResolution(const Value: LongInt);
begin
  If (FTimeoutResolution <> Value) Then Begin
    FTimeoutResolution := Value;

    If Assigned(FTimeoutTimer) Then
      FTimeoutTimer.Interval := FTimeoutResolution;
  End; { If (FTimeoutResolution <> Value) }
end;

//---------------------------------------------------------------------------

function TSystemSecurity.GetVersion: ShortString;
begin
  Result := TSystemSecurity_Version;
end;

procedure TSystemSecurity.SetVersion(const Value: ShortString);
begin
  // Do nothing - version is Read Only
end;

//---------------------------------------------------------------------------

// Watches for user actions with Keyboard or Mouse for Security Timeouts
procedure TSystemSecurity.AppOnMessage (var Msg: TMsg; var Handled: Boolean);
begin
     // KeyPress
  If (Msg.message = WM_KEYDOWN) Or (Msg.message = WM_KEYUP) Or
     // Any mouse button/wheel click
     ((Msg.message >= WM_LBUTTONDOWN) and (Msg.message <= WM_MOUSELAST)) Then
    // Retrieve time in Milliseconds since windows was started
    FLastActionTime := GetTickCount;
end;

//---------------------------------------------------------------------------

procedure TSystemSecurity.TimerOnTimer(Sender: TObject);
Var
  CurrTime, ElapsedTime : DWord;
  Restart               : Boolean;
Begin
  // Check base time has been initialised before checking for a timeout - otherwise
  // it could expire straight away - which would be Baaaaad!
  If (FLastActionTime > 0) Then Begin
    // Retrieve current time in Milliseconds since windows was started
    CurrTime := GetTickCount;

    // Calculate elapsed time since last action in mins
    ElapsedTime := Round(CurrTime - FLastActionTime);

    // Check if elapsed time with no actions is >= 1 minute
    If (ElapsedTime >= FTimeout) Then Begin
      // Timeout preiod elapsed - Disable Timer to prevent re-occurance of envent
      FTimeoutTimer.Enabled := False;

      // Call user-defined handler or apply default closedown logic
      If Assigned(FOnTimeout) Then Begin
        Restart := False;
        FOnTimeout(Self, Restart);
        FTimeoutTimer.Enabled := Restart;
      End { If Assigned(FOnTimeout) }
      Else
        Application.Terminate;
    End; { If (ElapsedTime >= FTimeout) }
  End { If (FLastActionTime > 0) }
  Else
    // Initialise base time for timeout
    FLastActionTime := GetTickCount;
end;

//---------------------------------------------------------------------------

procedure TSystemSecurity.SetEnabled(const Value: Boolean);
begin
  If (FEnabled <> Value) Then Begin
    FEnabled := Value;

    If Assigned(FTimeoutTimer) Then Begin
      FTimeoutTimer.Enabled := FEnabled;
      FLastActionTime := GetTickCount;
    End; { If Assigned(FTimeoutTimer) }
  End; { If (FEnabled <> Value) }
end;

end.
