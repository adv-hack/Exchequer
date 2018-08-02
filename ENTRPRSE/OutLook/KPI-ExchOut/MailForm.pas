unit MailForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, AdvMemo, Sentimail_TLB;

type
  TfrmMail = class(TForm)
    advPanel: TAdvPanel;
    btnClose: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpMessage: TAdvOfficePage;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    btnDelete: TAdvGlowButton;
    Label1: TLabel;
    edtSubject: TAdvEdit;
    Label2: TLabel;
    ccbEmailAddresses: TColumnComboBox;
    Label3: TLabel;
    ccbSMSNumbers: TColumnComboBox;
    memoText: TAdvMemo;
    lblDebug: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
  private
    FCanClose: boolean;
    FDataPath: WideString;
    FUserID:   WideString;
    FInstance: integer;
    FToolkit:  IToolkit;
    FTriggered: ITriggeredEvent;
    FSentinel: WideString;
    FRefreshData: WordBool;
    procedure MakeRounded(Control: TWinControl);
    Procedure SetHost (Value : HWND);
  public
    property  DataPath: WideString read FDataPath write FDataPath;
    property  Instance: integer read FInstance write FInstance;
    property  UserID:   WideString read FUserID write FUserID;
    property  Host :    HWND write SetHost;
    property  RefreshData: WordBool read FRefreshData;
    property  Sentinel: WideString read FSentinel write FSentinel;
    procedure Startup;
  end;

implementation

uses CtkUtil;

{$R *.dfm}

//=========================================================================

procedure TfrmMail.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

Procedure TfrmMail.SetHost (Value : HWND);
Var
  lpRect: TRect;
Begin // SetHost
  If (Value <> 0) Then
  Begin
    // Get the host window position and centre the login dialog over it
    If GetWindowRect(Value, lpRect) Then
    Begin
      // Top = Top of Host + (0.5 * Host Height) - (0.5 * Self Height)
      Self.Top := lpRect.Top + ((lpRect.Bottom - lpRect.Top - Self.Height) Div 2);

      // Left = Left of Host + (0.5 * Host Width) - (0.5 * Self Width)
      Self.Left := lpRect.Left + ((lpRect.Right - lpRect.Left - Self.Width) Div 2);

      // Make sure it is still fully on the screen
      If (Self.Top < 0) Then Self.Top := 0;
      If ((Self.Top + Self.Height) > Screen.Height) Then Self.Top := Screen.Height - Self.Height;
      If (Self.Left < 0) Then Self.Left := 0;
      If ((Self.Left + Self.Width) > Screen.Width) Then Self.Left := Screen.Width - Self.Width;
    End; // If GetWindowRect(Value, lpRect)
  End; // If (Value <> 0)
End; // SetHost


procedure TfrmMail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmMail.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmMail.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmMail.FormActivate(Sender: TObject);
begin
  ofpMessage.SetFocus;
end;

procedure TfrmMail.Startup;
var
  res: integer;
  i: integer;
begin
  lblDebug.caption := format('DataPath: %s, UserId: %s, Sentinel: %s, Instance: %d', [FDataPath, FUserId, FSentinel, FInstance]);
  FToolkit := CreateToolkitWithBackDoor;
  FTriggered := CreateOLEObject('Sentimail.TriggeredEvent') as ITriggeredEvent;
  with FTriggered do begin
    teDataPath := FDataPath;
    Res := GetEqual(FUserID, FSentinel, FInstance);
    if res = 0 then begin
        edtSubject.Text := teEmailSubject;

        for i := 1 to teEmailAddressCount do
          with ccbEmailAddresses.ComboItems.Add do
            strings.Add(teEmailAddress[i]);

        for i := 1 to teSMSNumberCount do
          with ccbSMSNumbers.ComboItems.Add do
            strings.Add(teSMSNumber[i]);

        for i := 1 to teLineCount do
          memoText.Lines.Add(teLine[i]);

        res := -1;
        btnDelete.Enabled := true;
    end
    else
      ShowMessage('Cannot locate the selected message');
  end;

  if ccbEmailAddresses.ComboItems.Count > 0 then
    ccbEmailAddresses.ItemIndex := 0;
  if ccbSMSNumbers.ComboItems.Count > 0 then
    ccbSMSNumbers.ItemIndex := 0;
end;

procedure TfrmMail.btnCloseClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmMail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
  FTriggered := nil;
  FToolkit   := nil;
end;

procedure TfrmMail.btnDeleteClick(Sender: TObject);
var
  res: integer;
begin
  lblDebug.Caption := FToolkit.Version;
  if FTriggered <> nil then
    if MessageDlg('Are you sure you want to delete this message ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin

      res          := FTriggered.Delete;
//      ShowMessage(format('delete res = %d', [res]));
      FCanClose    := true;
      FRefreshData := true;
      close;
    end;
end;

end.
