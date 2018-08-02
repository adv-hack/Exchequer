unit LoginF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, TEditVal, oDistLic;

type
  TfrmLogin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lblCopyright: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    lblVerNo: TLabel;
    lblLicencee: TLabel;
    panLogin: TPanel;
    Label82: Label8;
    btnOK: TButton;
    Timer1: TTimer;
    Label4: TLabel;
    edtPwrd: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin : TfrmLogin;
  oLicence : TDistributorLicence;

implementation

{$R *.dfm}

Uses APIUtil, SerialU, ContKey, DistRelF;

//---------------------------------------------------------------------------

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  ClientWidth := 393;
  ClientHeight := 111;

  Self.Top := (Screen.Height - Self.Height - panLogin.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;

  Caption := Application.Title;

  // Create the global licence object
  oLicence := TDistributorLicence.Create;

end;

//--------------------------------------

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oLicence);
end;

//---------------------------------------------------------------------------

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
  // Enable Timer to start off the Authorisation / Login process
  Timer1.Enabled := True;
end;

//---------------------------------------------------------------------------

procedure TfrmLogin.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//---------------------------------------

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//---------------------------------------------------------------------------

procedure TfrmLogin.Timer1Timer(Sender: TObject);
Var
  Res, I   : LongInt;
  ErrMsg   : ShortString;
  WantUpd  : Boolean;
begin
  // Turn off the timer to prevent this code executing again
  Timer1.Enabled := False;

  Case Timer1.Tag Of
    0   : Begin
            // Check Licence file exists
            If FileExists (ExtractFilePath(Application.ExeName) + DistLicenceFName) Then Begin
              // Read Licence
              Res := oLicence.Open (ExtractFilePath(Application.ExeName));
              If (Res = 0) Then Begin
                // Update licence label
                lblLicencee.Caption := 'Licenced To ' + oLicence.dlLicencee;

                // Check licence version is valid
                If (oLicence.dlLicenceMajorVer = 2) And (oLicence.dlLicenceMinorVer = 0) Then Begin
                  // Check for licence expiry
                  If (Not oLicence.Expired) Then Begin
                    // Licence is valid - give warning if expiring within one week
                    If (oLicence.dlLicenceExpiry < (Now + 7)) Then
                      MessageDlg ('Your Licence for the ' + Application.Title + ' expires on the ' + FormatDateTime('DD/MM/YYYY', oLicence.dlLicenceExpiry) +
                                  ', please contact Exchequer UK for a new licence as soon as possible.', mtWarning, [mbOk], 0);

                    // move to login/detail
                    With Timer1 Do Begin
                      // Move to login
                      Tag := 2;
                      Interval := 1000;
                      Enabled := True;
                    End { With Timer1 }
                  End { If (Not oLicence.Expired) }
                  Else Begin
                    // Licence Expired
                    Self.Hide;
                    MessageDlg ('The Licence for the ' + Application.Title + ' has expired.'#13#13'Please contact Exchequer UK', mtInformation, [mbOk], 0);
                    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
                  End; { Else }
                End { If }
                Else Begin
                  // Licence Version wrong
                  Self.Hide;
                  MessageDlg (Format('The Licence Version (%d.%d) of your current licence is invalid.'#13#13'Please contact Exchequer UK', [oLicence.dlLicenceMajorVer, oLicence.dlLicenceMinorVer]),
                              mtInformation, [mbOk], 0);
                  PostMessage (Self.Handle, WM_CLOSE, 0, 0);
                End; { Else }
              End { If (Res = 0)  }
              Else Begin
                // Error reading Licence - shut-down after displaying error
                Case Res Of
                  1000 : ErrMsg := 'Unknown Error';
                  //1001 : ErrMsg := 'Exception - ' + oLicence.ExceptMsg;
                  2001 : ErrMsg := 'File Signature Invalid';
                  2002 : ErrMsg := 'CRC/Checksum Error';
                  2003 : ErrMsg := 'Licence Locked by another Application';
                Else
                  ErrMsg := 'Unknown Error ' + IntToStr(Res);
                End; { Case }

                Self.Hide;
                MessageDlg ('The following error occurred whilst reading the Licence for the ' +
                            'Enterprise Plug-In Release Code Utility:-' + #13#13 +
                            QuotedStr(ErrMsg) + #13#13 + 'Please contact Exchequer UK',
                            mtError, [mbOk], 0);

                PostMessage (Self.Handle, WM_CLOSE, 0, 0);
              End; { Else }
            End { If FileExists }
            Else Begin
              // Licence Expired
              Self.Hide;
              MessageDlg ('The Licence for the ' + Application.Title + ' is missing.'#13#13'Please contact Exchequer UK', mtInformation, [mbOk], 0);
              PostMessage (Self.Handle, WM_CLOSE, 0, 0);
            End; { Else }
          End;

    // Go into main form without requiring a Login
    1   : Begin
            // Create main detail form
            frmMain := TfrmMain.Create(Self);

            // Show Main Detail form
            frmMain.Show;

            // Hide Splash screen
            Self.Hide;
          End;

    // Modify the splash form to ask for a User Id and PWord
    2   : Begin
            // Hide the splash and transform it into the login dialog
            ClientHeight := 187;
            panLogin.Visible := True;
            edtPwrd.Text := '';
            If edtPwrd.CanFocus Then edtPwrd.SetFocus;
          End;
  End; { Case Timer1.Tag }
end;

//---------------------------------------------------------------------------

procedure TfrmLogin.btnOKClick(Sender: TObject);
begin
  If (edtPwrd.Text = oLicence.dlPassword) Then Begin
    // Remove Password
    edtPwrd.Text := '';

    // Move to detail window
    frmMain := TfrmMain.Create(Self);
    frmMain.Show;
    Self.Hide;
  End { If (edtPwrd.Text = oLicence.dlPassword) }
  Else Begin
    Beep;
    If edtPwrd.CanFocus Then edtPwrd.SetFocus;
  End; { Else }
end;

//---------------------------------------------------------------------------

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

Procedure TestSecurity;
Var
  ExecPath : ShortString;
  SNo      : String;
  AOK      : Boolean;
Begin { TestSecurity }
  // Check for flag file in Windows dir
  AOK := FileExists(WinGetWindowsDir+'MSCOMXEN.DLL');

  If (Not AOK) Then
    Halt;
End; { TestSecurity }

Initialization
  TestSecurity;
end.
