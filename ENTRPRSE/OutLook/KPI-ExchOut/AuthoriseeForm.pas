unit AuthoriseeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, AdvMemo,
  Enterprise_TLB, MemMap, KPICommon;

type
  TfrmAuth = class(TForm)
    advPanel: TAdvPanel;
    btnClose: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpMessage: TAdvOfficePage;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label1: TLabel;
    edtAcCode: TAdvEdit;
    lblDebugInfo: TLabel;
    Label2: TLabel;
    edtAcName: TAdvEdit;
    edtOurRef: TAdvEdit;
    btnViewTrans: TAdvGlowButton;
    btnViewAc: TAdvGlowButton;
    Label3: TLabel;
    Label5: TLabel;
    edtTransDate: TAdvEdit;
    Label6: TLabel;
    edtAmount: TAdvEdit;
    AdvPanelStyler1: TAdvPanelStyler;
    pnlAuth: TAdvPanel;
    btnAuthorise: TAdvGlowButton;
    btnReject: TAdvGlowButton;
    Label7: TLabel;
    Label8: TLabel;
    edtAuthID: TAdvEdit;
    edtAuthCode: TAdvEdit;
    Label9: TLabel;
    edtRejectReason: TAdvEdit;
    Bevel1: TBevel;
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnViewAcClick(Sender: TObject);
    procedure btnViewTransClick(Sender: TObject);
    procedure edtAuthIDChange(Sender: TObject);
    procedure edtAuthCodeChange(Sender: TObject);
    procedure edtRejectReasonChange(Sender: TObject);
    procedure btnAuthoriseClick(Sender: TObject);
    procedure btnRejectClick(Sender: TObject);
    procedure edtAuthCodeKeyPress(Sender: TObject; var Key: Char);
  private
    FCanClose:    boolean;
    FDataPath:    WideString;
    FUserID:      WideString;
    FInstance:    integer;
    FToolkit:     IToolkit;
    FSentinel:    WideString;
    FRefreshData: WordBool;
    FOurRef:      ShortString;
    FRequestDate: ShortString;
    FAuthCode:    ShortString;
    FAuthID:      ShortString;
    FAcCode:      WideString;
    FAcName:      ShortString;
    FCompanyCode: ShortString;
    FTransDate:   WideString;
    FAmount:      double;
    FExpaSet:     THandle;
    FCurrSymb: WideString;
    procedure MakeRounded(Control: TWinControl);
    Procedure SetHost (Value : HWND);
    function AuthoriseRequest(CompanyCode, AuthID, AuthCode, OurRef: ShortString; Reject: WordBool; RejectReason: ShortString): SmallInt;
    procedure HideAuthPanel;
  public
    property  CompanyCode: ShortString read FCompanyCode write FCompanyCode;
    property  DataPath: WideString read FDataPath write FDataPath;
    property  Instance: integer read FInstance write FInstance;
    property  AuthID:   ShortString read FAuthID write FAuthID;
    property  AuthCode: ShortString read FAuthCode write FAuthCode;
    property  Host :    HWND write SetHost;
    property  OurRef:   ShortString read FOurRef write FOurRef;
    property  RefreshData: WordBool read FRefreshData;
    property  RequestDate: ShortString read FRequestDate write FRequestDate;
    property  Sentinel: WideString read FSentinel write FSentinel;
    property  CurrSymb: WideString read FCurrSymb write FCurrSymb;
    procedure CloseComToolkit;
    procedure GetTransInfo;
    procedure GetRequestInfo;
    procedure OpenComToolkit;
    procedure Startup;
    property  ExpaSet: THandle read FExpaSet write FExpaSet;
  end;

implementation

uses CtkUtil, DrillDownForm, AccountForm, FileUtil, VAOUtil, TransactionForm;

{$R *.dfm}

procedure TfrmAuth.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

//=========================================================================

procedure TfrmAuth.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
  pnlAuth.Collaps := false;
end;

Procedure TfrmAuth.SetHost (Value : HWND);
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


procedure TfrmAuth.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmAuth.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmAuth.MakeRounded(Control: TWinControl);
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

procedure TfrmAuth.FormActivate(Sender: TObject);
begin
  edtAuthCode.SetFocus;
end;

procedure TfrmAuth.Startup;
var
  res: integer;
  i: integer;
begin
  lblDebugInfo.caption := format('DataPath: %s, AuthID: %s, OurRef: %s, ReqDate: %s', [FDataPath, FAuthID, FOurRef, FRequestDate]);
  OpenComToolkit;
  GetTransInfo;
  edtAcCode.Text    := FAcCode;
  edtAcName.Text    := FAcName;
  edtOurRef.Text    := FOurRef;
  edtTransDate.Text := format('%s/%s/%s', [copy(FTransDate, 7, 2), copy(FTransDate, 5, 2), copy(FTransDate, 1, 4)]); 
  edtAmount.Text    := format('%s %0.2n', [FCurrSymb, FAmount]);
  edtAuthID.Text    := FAuthID;
  FUserID           := FAuthID;
  CloseComToolkit;
end;

procedure TfrmAuth.btnCloseClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmAuth.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
  if TransactionFrm <> nil then
  begin
    TransactionFrm.Free;
    TransactionFrm := nil;
  end;
  FToolkit   := nil;
end;

procedure TfrmAuth.btnViewAcClick(Sender: TObject);
begin
  ShowAccountForm(FDataPath, FAcCode, 'Supplier', 0, '', '');
end;

procedure TfrmAuth.GetTransInfo;
var
  res: integer;
begin
  with FToolkit, Transaction do begin
    Index := thIdxOurRef;
    res := GetEqual(BuildOurRefIndex(FOurRef));
    if res <> 0 then
      ShowMessage(format('The transaction with OurRef %s was not found', [FOurRef]))
    else
      FAcCode    := thAcCode;
      FTransDate := thTransDate;
      FAmount    := thTotals[TransTotInBase];
      with Supplier do begin
        Index := acIdxCode;
        res := GetEqual(BuildCodeIndex(FAcCode));
        if res <> 0 then
          ShowMessage(format('The account record for supplier %s was not found', [FAcCode]))
        else
          FAcName := acCompany;
      end;
  end;
end;

procedure TfrmAuth.OpenComToolkit;
begin
  FToolkit := OpenToolkit(FDataPath, true);
end;

procedure TfrmAuth.CloseComToolkit;
begin
  FToolkit.CloseToolkit;
  FToolkit := nil;
end;

procedure TfrmAuth.btnViewTransClick(Sender: TObject);
begin
  ShowTransactionForm(DataPath, edtOurRef.Text);
end;

procedure TfrmAuth.GetRequestInfo;
begin

end;

procedure TfrmAuth.edtAuthIDChange(Sender: TObject);
begin
  btnAuthorise.Enabled := (edtAuthID.Text <> '') and (edtAuthCode.Text <> '');
end;

procedure TfrmAuth.edtAuthCodeChange(Sender: TObject);
begin
  btnReject.Enabled    := (edtRejectReason.Text <> '') and (edtAuthID.Text <> '') and (edtAuthCode.Text <> '');
  btnAuthorise.Enabled := (edtAuthID.Text <> '') and (edtAuthCode.Text <> '') and (edtRejectReason.Text = '');
end;

procedure TfrmAuth.edtRejectReasonChange(Sender: TObject);
begin
  btnReject.Enabled    := (edtRejectReason.Text <> '') and (edtAuthID.Text <> '') and (edtAuthCode.Text <> '');
  btnAuthorise.Enabled := (edtAuthID.Text <> '') and (edtAuthCode.Text <> '') and (edtRejectReason.Text = '');
end;

function TfrmAuth.AuthoriseRequest(CompanyCode, AuthID, AuthCode, OurRef: ShortString; Reject: WordBool; RejectReason: ShortString): SmallInt;
type
    TAuthoriseRequest = function(CompanyCode, AuthID, AuthCode, OurRef: ShortString; Reject: WordBool; RejectReason: ShortString): SmallInt; StdCall;
var
  ExpaForm:          THandle;
  ExpaSet:           THandle;
  AuthoriseRequestF: TAuthoriseRequest;
begin
  result := -1;
  if not FileExists(VAOInfo.VAOAppsDir + 'ExpaSet.dll') then
    ShowMessage(format('ExpaSet.dll not found in %s', [VAOInfo.VAOAppsDir]))
  else begin
    ExpaSet := LoadLibrary(pchar(VAOInfo.VAOAppsDir + 'ExpaSet.dll'));
    if ExpaSet = 0 then
      ShowMessage('Cannot load ExpaSet library - ' + SysErrorMessage(GetLastError))
    else begin
      AuthoriseRequestF := GetProcAddress(ExpaSet, 'AuthoriseRequest');
      result            := AuthoriseRequestF(CompanyCode, AuthID, AuthCode, OurRef, Reject, RejectReason);
    end;
  end;
  if ExpaSet <> 0 then
    FreeLibrary(ExpaSet); // don't free ExpaForm !
end;

procedure TfrmAuth.HideAuthPanel;
begin
  ofConfig.Height      := ofConfig.Height - 146; //  154;
  advPanel.Height      := advPanel.Height - 146; //  240;
  btnClose.Top         := btnClose.Top - 146;
  self.Height          := self.Height - 146;
  btnAuthorise.Enabled := false;
  btnReject.Enabled    := false;
  MakeRounded(self);
  MakeRounded(AdvPanel);
  btnClose.SetFocus;
end;

procedure TfrmAuth.btnAuthoriseClick(Sender: TObject);
var
  res: integer;
begin
  if MessageDlg('Are you sure you want to AUTHORISE this transaction ?', mtConfirmation, [mbNo, mbYes], 0) = mrNo then EXIT;
  FAuthCode := edtAuthCode.Text;
  pnlAuth.Enabled := false;
  Screen.Cursor := crHourGlass;
  try
   res := AuthoriseRequest(FCompanyCode, FAuthID, FAuthCode, OurRef, false, '');
    case res of
      0:  begin
            ShowMessage('This transaction has been successfully authorised');
            btnAuthorise.Enabled := false;
            btnReject.Enabled    := false;
            FRefreshData         := true;
            HideAuthPanel;
          end;
      1:  ShowMessage('The Authorisation ID or Authorisation Code is not valid');
      2:  ShowMessage('This authorisation request cannot be found');
    else
      ShowMessage(format('Error %d occurred while trying to authorise this transaction', [res]));
    end;
  finally
    pnlAuth.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmAuth.btnRejectClick(Sender: TObject);
var
  res: integer;
begin
  if MessageDlg('Are you sure you want to REJECT this transaction ?', mtConfirmation, [mbNo, mbYes], 0) = mrNo then EXIT;
  FAuthCode := edtAuthCode.Text;
  pnlAuth.Enabled := false;
  Screen.Cursor := crHourGlass;
  try
    res := AuthoriseRequest(FCompanyCode, FAuthID, FAuthCode, OurRef, true, edtRejectReason.Text);
    case res of
      0:  begin
            ShowMessage('This authorisation request has been successfully rejected');
            btnAuthorise.Enabled := false;
            btnReject.Enabled    := false;
            FRefreshData         := true;
            HideAuthPanel;
          end;
      1:  ShowMessage('The Authorisation ID or Authorisation Code is not valid');
      2:  ShowMessage('This authorisation request cannot be found');
    else
      ShowMessage(format('Error %d occurred while trying to reject this authorisation request', [res]));
    end;
  finally
    pnlAuth.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmAuth.edtAuthCodeKeyPress(Sender: TObject; var Key: Char);
begin
//  key := UpperCase(Key)[1];
end;

end.
