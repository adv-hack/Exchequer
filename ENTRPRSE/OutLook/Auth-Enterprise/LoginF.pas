unit LoginF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, ExtCtrls, Enterprise01_TLB, EnterToTab;

type
  TfrmEnterpriseLogin = class(TForm)
    BackgroundImg: TImage;
    UserLab: Label8;
    Label82: Label8;
    edtUserCode: Text8Pt;
    edtPassword: Text8Pt;
    btnCancel: TButton;
    btnOK: TButton;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtUserCodeExit(Sender: TObject);
    procedure edtPasswordExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FToolkit : IToolkit2;
    Procedure SetHost (Value : HWND);
    Function GetUserId : ShortString;
    Procedure SetUserId (Value : ShortString);
  public
    { Public declarations }
    Property Host : HWND Write SetHost;
    Property Toolkit : IToolkit2 Read FToolkit Write FToolkit;
    Property UserId : ShortString Read GetUserId Write SetUserId;
  end;


implementation

{$R *.dfm}

uses Brand, EntLicence, APIUtil, VAOUtil;


function  EnterToTab(Key: char; handle: HWND): char;
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    result := #0;
  end
  else
    result := Key;
end;

//=========================================================================

procedure TfrmEnterpriseLogin.FormCreate(Sender: TObject);
Var
  WinLogin : ShortString;
begin
  ClientHeight := 214;
  ClientWidth := 357;

  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height - - Self.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;

  // Branding
  InitBranding (IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir));
//ShowMessage(VAOInfo.vaoAppsDir);
  self.Icon.Assign(Branding.pbProductIcon);
  Caption := Branding.pbProductName + ' Login';
  Branding.BrandingFile(ebfOLE).ExtractImageCD(BackgroundImg, 'Login');
  BackgroundImg.Repaint;
  Application.ProcessMessages;

  // Enhanced Security Module - default login to Windows User Id if it exists
//  If (EnterpriseLicence.elModules[modEnhSec] <> mrNone) Then
//  Begin
//    WinLogin:=UpperCase(WinGetUserName);
//    If UserCodeExists(WinLogin) Then
//    Begin
//      edtUserCode.Text := WinLogin;
//      edtUserCode.SelectAll;
//    End; // If UserCodeExists(WinLogin)
//  End; // If (EnterpriseLicence.elModules[modEnhSec] <> mrNone)
end;

//------------------------------

procedure TfrmEnterpriseLogin.FormDestroy(Sender: TObject);
begin
  FToolkit := NIL;
end;

//-------------------------------------------------------------------------

Procedure TfrmEnterpriseLogin.SetHost (Value : HWND);
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

//------------------------------

Function TfrmEnterpriseLogin.GetUserId : ShortString;
Begin // GetUserId
  Result := edtUserCode.Text;
End; // GetUserId
Procedure TfrmEnterpriseLogin.SetUserId (Value : ShortString);
Begin // SetUserId
  edtUserCode.Text := UpperCase(Trim(Value));
End; // SetUserId

//-------------------------------------------------------------------------

procedure TfrmEnterpriseLogin.edtUserCodeExit(Sender: TObject);
begin
//PR: 07/09/2017 v2017 R2 ABSEXCH-18858 Don't validate user in isolation
//from password
end;

//-------------------------------------------------------------------------

procedure TfrmEnterpriseLogin.edtPasswordExit(Sender: TObject);
begin
  If (FToolkit.Functions.entCheckPassword(edtUserCode.Text, edtPassword.Text) = 0) Then
  Begin
    // AOK - lets  get outa here
    ModalResult := mrOK;
  End // If (FToolkit.Functions.entCheckPassword(edtUserCode.Text, edtPassword.Text) = 0)
  Else
  Begin
    //PR: 07/09/2017 v2017 R2 ABSEXCH-18858 Show appropriate error message then
    //shift focus to the UserId field
    ShowMessage(FToolkit.LastErrorString);
    If edtUserID.CanFocus Then
    Begin
      edtUserId.SetFocus;
    End; //
  End; // Else
end;

//-------------------------------------------------------------------------

procedure TfrmEnterpriseLogin.btnOKClick(Sender: TObject);
begin
  // Move focus to the OK button to cause the OnExit events to
  // happen on the User Code and Password fields
  If btnOK.CanFocus Then
  Begin
    btnOK.SetFocus;
  End; // If btnOK.CanFocus
end;

//=========================================================================

end.
