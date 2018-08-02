unit SplashF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, oPlugLic, StdCtrls, Mask, TEditVal;

type
  TfrmSplash = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    lblVerNo: TLabel;
    lblLicencee: TLabel;
    panLogin: TPanel;
    Label82: Label8;
    edtPwrd: Text8Pt;
    btnOK: TButton;
    btnCancel: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  TLoginType = (ltUnknown, ltUser, ltMaster);

Var
  frmSplash : TfrmSplash;
  oLicence  : TPlugInUtilityLicenceType;
  LoginType : TLoginType = ltUnknown;

implementation

{$R *.dfm}

Uses DetailF, oConfig, Crypto, SerialU;

//---------------------------------------------------------------------------

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  // Set version label on splash screen
  lblVerNo.Caption := lblVerNo.Caption + UtilVerNo;

  // Create the global licence object
  oLicence := TPlugInUtilityLicenceType.Create;

  ClientHeight := 111;
end;

//---------------------------------------------------------------------------

procedure TfrmSplash.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oLicence);
end;

//---------------------------------------------------------------------------

procedure TfrmSplash.FormActivate(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

//---------------------------------------------------------------------------

procedure TfrmSplash.Timer1Timer(Sender: TObject);
Var
  Res, I   : LongInt;
  ErrMsg   : ShortString;
  WantUpd  : Boolean;
begin
  // Turn off the timer to prevent this code executing again
  Timer1.Enabled := False;

  Case Timer1.Tag Of
    0   : Begin
            // Read Licence
            Res := oLicence.Open (ExtractFilePath(Application.ExeName) + 'ENPLUGIN.PIL', True);
            If (Res = 0) Then Begin
              // Update licence label
              lblLicencee.Caption := 'Licenced To ' + oLicence.Licencee;

              // Update Usage Stats if required
              If (oLicence.PlugInCount > 0) Then Begin
                WantUpd := False;

                For I := 0 To Pred(oLicence.PlugInCount) Do
                  With oLicence.PlugIn[I], oConfiguration.cfgPlugIns[piCode] Do
                    If (picSystem30DayInst <> pi30Day) Or (picSystemFullInst <> piFull) Or
                       (picUserCountInst <> piUCount) Or (picUserCountTotal <> piUCTotal) Then Begin
                      // Usage stats changed - update licence
                      pi30Day := picSystem30DayInst;
                      piFull := picSystemFullInst;
                      piUCount := picUserCountInst;
                      piUCTotal := picUserCountTotal;
                      WantUpd := True;
                    End; { If }

                If WantUpd Then
                  // Stats changed - update licence
                  oLicence.Save (ExtractFilePath(Application.ExeName) + 'ENPLUGIN.PIL');
              End; { If (oLicence.PlugInCount > 0) }

              If (Not oLicence.Expired) Then Begin
                // Licence is valid - give warning if expiring within 5 days
                If (oLicence.Expiry < (Now + 6)) Then
                  MessageDlg ('Your Licence for the ' + Application.Title + ' expires on the ' + FormatDateTime('DD/MM/YYYY', oLicence.Expiry) +
                              ', please contact your Technical Support Helpline for a new licence as soon as possible.', mtWarning, [mbOk], 0);

                // move to login/detail
                With Timer1 Do Begin
                  If (oConfiguration.cfgUserPW <> '') Or (oConfiguration.cfgMasterPW <> '') Then Begin
                    // Move to login
                    Tag := 2;
                    Interval := 1000;
                  End { If (oConfiguration.cfgUserPW <> '') Or (oConfiguration.cfgMasterPW <> '') }
                  Else Begin
                    // Move to detail
                    Tag := 1;
                    Interval := 2000;
                    LoginType := ltMaster;
                  End; { Else }
                  Enabled := True;
                End { With Timer1 }
              End { If (Not oLicence.Expired) }
              Else Begin
                // Licence Expired
                Self.Hide;
                MessageDlg ('The Licence for the ' + Application.Title + ' has expired.'#13#13'Please contact your Technical Support Helpline', mtInformation, [mbOk], 0);
                PostMessage (Self.Handle, WM_CLOSE, 0, 0);
              End; { Else }
            End { If (Res = 0)  }
            Else Begin
              // Error reading Licence - shut-down after displaying error
              Case Res Of
                1000 : ErrMsg := 'Unknown Error';
                1001 : ErrMsg := 'Exception - ' + oLicence.ExceptMsg;
                2001 : ErrMsg := 'File Signature Invalid';
                2002 : ErrMsg := 'CRC/Checksum Error';
                2003 : ErrMsg := 'Licence Locked by another Application';
              Else
                ErrMsg := 'Unknown Error ' + IntToStr(Res);
              End; { Case }

              Self.Hide;
              MessageDlg ('The following error occurred whilst reading the Licence for the ' +
                          'Enterprise Plug-In Release Code Utility:-' + #13#13 +
                          QuotedStr(ErrMsg) + #13#13 + 'Please contact your Technical Support',
                          mtError, [mbOk], 0);

              PostMessage (Self.Handle, WM_CLOSE, 0, 0);
            End; { Else }
          End;
    1   : Begin
            // Create main detail form
            frmDetail := TfrmDetail.Create(Self);

            // Show Main Detail form
            frmDetail.Show;

            // Hide Splash screen
            Self.Hide;
          End;
    2   : Begin
            // Hide the splash and transform it into the login dialog
            Self.Hide;
            BorderStyle := bsDialog;
            Caption := 'Password Required For Entry';
            ClientHeight := 231;
            panLogin.Visible := True;
            Top := (Screen.Height - Self.Height) Div 2;
            edtPwrd.Text := '';
            Self.Show;
            If edtPwrd.CanFocus Then edtPwrd.SetFocus;
          End;
  End; { Case Timer1.Tag }
end;

//---------------------------------------------------------------------------

procedure TfrmSplash.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

procedure TfrmSplash.btnOKClick(Sender: TObject);
begin
  LoginType := ltUnknown;

  // Validate the password against the Master and then the User passwords
  // in the Configuration object - must do most priviliged first
  If (EncodeKey (23130, edtPwrd.Text) = oConfiguration.cfgMasterPW) Then
    LoginType := ltMaster
  Else
    If (EncodeKey (23130, edtPwrd.Text) = oConfiguration.cfgUserPW) Then
      LoginType := ltUser
    Else Begin
      edtPwrd.Text := '';
      If edtPwrd.CanFocus Then edtPwrd.SetFocus;
      Beep;
    End; { Else }

  If (LoginType <> ltUnknown) Then Begin
    // Move to detail window
    frmDetail := TfrmDetail.Create(Self);
    frmDetail.Show;
    Self.Hide;
  End; { If (LoginType <> ltUnknown) }
end;

//---------------------------------------------------------------------------

Procedure TestSecurity;
Var
  ExecPath : ShortString;
  SNo      : String;
  AOK      : Boolean;
Begin { TestSecurity }
  // Check path app is running from
  ExecPath := UpperCase(Trim(ExtractFilePath(Application.ExeName)));
  AOK := (ExecPath = 'X:\ENTRPRSE\LICENCE\PITHIRD\') Or
         (ExecPath = 'S:\TEMP\MARK\PILIC\') Or
         (ExecPath = 'T:\TEMP\MARK\PILIC\');

  If (Not AOK) Then Begin
    // Check Serial Number of C: Hard Disk
    SNo := GetDriveSerial('C');
    AOK := (Sno = '88EC-C9A0');          // Kevin Horlock - Notebook
  End; { If (Not AOK) }

  If (Not AOK) Then
    Halt;
End; { TestSecurity }

//---------------------------------------------------------------------------

Initialization
  TestSecurity;
end.
