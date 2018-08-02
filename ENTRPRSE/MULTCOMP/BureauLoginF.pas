unit BureauLoginF;

// MCM Login dialog for Bureau Module

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, ExtCtrls, antLabel;

type
  TfrmBureauLogin = class(TForm)
    Image1: TImage;
    edtUserCode: Text8Pt;
    edtPassword: Text8Pt;
    btnCancel: TButton;
    btnOK: TButton;
    Label3: TLabel;
    Label4: TLabel;
    antLabel1: TantLabel;
    antLabel2: TantLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtUserCodeExit(Sender: TObject);
    procedure edtPasswordExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }

    // Window Handle of splash screen - needed so that it can be shown/hidden as reqd
    FSplashHandle : hWnd;

  public
    { Public declarations }

    // Window Handle of splash screen - needed so that it can be shown/hidden as reqd
    Property SplashHandle : hWnd Read FSplashHandle Write FSplashHandle;
  end;


implementation

{$R *.dfm}

Uses GlobVar, VarConst, BtrvU2, ETStrU,
     BureauSecurity,  // SecurityManager Object
     EntLicence,      // EnterpriseLicence Object for accessing the Enterprise Licence details
     GroupUsersFile,  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     Brand,
     VAOUtil,
     BTKeys1U, BTSupU1, BTSupU2;

//-------------------------------------------------------------------------

procedure TfrmBureauLogin.FormCreate(Sender: TObject);
Var
  WinLogin : ShortString;
  ShowGraphics : Boolean;
  CopyrightColorMode : Integer;
begin
  ClientHeight := 214;
  ClientWidth := 357;

  Caption := Branding.pbProductName + ' Bureau Login';
  Label3.Caption := Branding.pbProductName;
  Label4.Visible := (Branding.pbProduct = ptExchequer);

  ShowGraphics := Not VAOInfo.vaoHideBitmaps;
  If ShowGraphics Then
  Begin
    If Branding.BrandingFileExists(ebfOLE) Then
    Begin
      CopyrightColorMode := -1;

      //Branding.BrandingFile(ebfOLE).ExtractImageCD (Image1, 'Login')

      With Branding.BrandingFile(ebfOLE) Do
      Begin
        If EnterpriseLicence.IsSQL Then
        Begin
          ExtractImageCD (Image1, 'SQL_Login');
          CopyrightColorMode := pbfData.GetInteger('SQLVersionColour', -1);
          //lblESN.Top := lblESN.Top + pbfData.GetInteger('SQLVersionVAdjust', 0);
        End // If EnterpriseLicence.IsSQL
        Else
        Begin
          ExtractImageCD (Image1, 'Login');
          CopyrightColorMode := pbfData.GetInteger('PervVersionColour', -1);
          //lblESN.Top := lblESN.Top + pbfData.GetInteger('PervVersionVAdjust', 0);
        End; // Else
      End; // With Branding.BrandingFile(ebfOLE)

//      Case CopyrightColorMode Of
//        0 : lblESN.Font.Color := clWhite;
//      Else
//        lblESN.Font.Color := clGray;
//      End; // Case CopyrightColorMode
    End // If Branding.BrandingFileExists(ebfOLE)
    Else
      ShowGraphics := False;
  End; // If ShowGraphics

  If (Not ShowGraphics) Then
    Image1.Visible := False;

  // Enhanced Security Module - default login to Windows User Id if it exists
  If (EnterpriseLicence.elModules[modEnhSec] <> mrNone) Then
  Begin
    WinLogin:=UpCaseStr(WinGetUserName);
    If UserCodeExists(WinLogin) Then
    Begin
      edtUserCode.Text := WinLogin;
      edtUserCode.SelectAll;
    End; // If UserCodeExists(WinLogin)
  End; // If (EnterpriseLicence.elModules[modEnhSec] <> mrNone)

  // Add ESN into grey label across bottom as req'd for MCM Password generation
//  lblESN.Caption := 'Site No: ' + EnterpriseLicence.elFullESN;

  // Turn on the ENTER=TAB mode
  Syss.TxLateCr := True;
end;

//------------------------------

procedure TfrmBureauLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (ModalResult <> mrOK) Then
  Begin
    // re-show the Splash Screen
    PostMessage (FSplashHandle, WM_SBSFDMsg, 2, 2);
  End; // If (ModalResult <> mrOK)
end;

//------------------------------

procedure TfrmBureauLogin.FormShow(Sender: TObject);
begin
  // Use SendMessage to hide the Splash Screen, this will unfortunately
  // also hide the start bar icon so we then force that to be visible again.
  //
  // NOTE: Can't use PostMessage as that executes the hide after the ShowWindow
  // is done so the Start Bar icon still disappears
  SendMessage (FSplashHandle, WM_SBSFDMsg, 1, 1);
  ShowWindow (Application.Handle, SW_SHOW);
end;

//------------------------------

procedure TfrmBureauLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmBureauLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

procedure TfrmBureauLogin.edtUserCodeExit(Sender: TObject);
begin
  // Get the Bureau Security Manager to checkout the User Code and determine
  // whether it is valid
  If (Not SecurityManager.ValidLoginId (edtUserCode.Text)) Then
  Begin
    // Invalid - Restore focus to the User Code
    If (ActiveControl <> btnCancel) And edtUserCode.CanFocus Then
    Begin
      edtUserCode.SetFocus;
    End; // If (ActiveControl <> btnCancel) And edtUserCode.CanFocus
  End; // If (Not SecurityManager.ValidLoginId (edtUserCode.Text))
end;

//------------------------------

procedure TfrmBureauLogin.edtPasswordExit(Sender: TObject);
begin
  // Check with the Bureau Security Manager to see whether a valid User Id
  // has already been specified
  If (SecurityManager.smUserType <> utNotLoggedIn) Then
  Begin
    // We have a valid user loaded into the Security Manager - check the
    // password
    If SecurityManager.ValidPassword (Trim(edtPassword.Text)) Then
    Begin
      ModalResult := mrOk;
    End // If SecurityManager.ValidPassword (...
    Else
    Begin
      If (ActiveControl <> edtUserCode) And edtPassword.CanFocus Then
      Begin
        edtPassword.SetFocus;
      End; // If (ActiveControl <> edtUserCode) And edtPassword.CanFocus
    End; // Else
  End; // If (Not SecurityManager.ValidLoginId (edtUserCode.Text))
end;

//-------------------------------------------------------------------------

procedure TfrmBureauLogin.btnOKClick(Sender: TObject);
begin
  // Move focus to the OK button to cause the OnExit events to
  // happen on the User Code and Password fields
  If btnOK.CanFocus Then
  Begin
    btnOK.SetFocus;
  End; // If btnOK.CanFocus
end;

//-------------------------------------------------------------------------

end.
