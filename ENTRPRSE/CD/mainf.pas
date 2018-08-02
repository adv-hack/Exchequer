Unit mainf;

{ markd6 10:35 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1} { Variable Alignment Disabled }

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ShellAPI, LicRec, IniFiles, Buttons, FileCtrl, strutils,
  AdvToolBar, AdvToolBarStylers;

Type
  TfrmMain = Class(TForm)
    AdvToolBarPager: TAdvToolBarPager;
    AdvToolBarOfficeStyler: TAdvToolBarOfficeStyler;
    tmClose: TTimer;
    Image1: TImage;
    lblInstallationInstructions: TLabel;
    lblReadExchequerLicence: TLabel;
    lblInstallProduct: TLabel;
    imbProductIcon: TImage;
    lblCopyright: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure tmCloseTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ConfigureLabelsEnter(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblInstallationInstructionsClick(Sender: TObject);
    procedure lblReadExchequerLicenceClick(Sender: TObject);
    procedure lblInstallProductClick(Sender: TObject);
  Private
    { Private declarations }
    OrigCapt: ShortString;
    Procedure SetupLabels;

    Procedure WMSysCommand(Var Message: TMessage); Message WM_SysCommand;
    Procedure CreateParams(Var Params: TCreateParams); Override;
  Public
    { Public declarations }
  End;

Var
  frmMain: TfrmMain;
  CDLic: CDLicenceRecType;

Implementation

{$R *.DFM}

Uses ReadLicF, Crypto, WLicFile, StrUtil, APIUtil, History;

Const
  CM_About = $F0;

//=========================================================================

Procedure TfrmMain.WMSysCommand(Var Message: TMessage);
Var
  MsgText: ANSIString;
Begin
  Case Message.WParam Of
    CM_About : Begin
                 MsgText := Application.Title + '  (' + CurrVer_SetupAutoRun + ')' + #13 + GetCopyrightMessage;
                 Application.MessageBox(PCHAR(MsgText), 'About...', 0);
               End;
  End; // Case Message.WParam

  Inherited;
End;

//-------------------------------------------------------------------------

Procedure TfrmMain.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  Params.Style := Params.Style And Not WS_CAPTION Or WS_POPUP;
End;

//-------------------------------------------------------------------------

Procedure TfrmMain.FormCreate(Sender: TObject);
Var
  IniF: TIniFile;
  LicPath: ShortString;
  SysMenuH: HWnd;
Begin
  OrigCapt := Caption;

  ClientHeight := AdvToolBarPager.Height + Image1.Height;

  // Set corporate colour
  Self.Font.Color := RGB(99, 99, 99);  // Advanced Dark Grey

  // MH 08/07/2013 v7.0.5: Redirected to use copyright text from standard funcion
  lblCopyright.Caption := GetCopyrightMessage + ' All rights reserved.';
  lblCopyright.Font.Color := Self.Font.Color;

  // HM 26/03/02: Added About option into System Menu
  SysMenuH := GetSystemMenu(Handle, False);
  AppendMenu(SysMenuH, MF_SEPARATOR, 0, '');
  AppendMenu(SysMenuH, MF_String, CM_About, 'About...');

  { Initialise the licence to install as a Standard Demo }
  FillChar(CDLic, SizeOf(CDLic), #0);
  With CDLic Do
  Begin
    licLicType := 2;      // 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
    licType := 0;         // 0=Install, 1=Upgrade, 2=Auto-Upgrade
    licCountry := 1;      // 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA

    licCompany := 'Exchequer Demo';

    licEntDB := 0;         // 0-Btrieve, 1-MS SQL
    licEntCVer := 2;      // 0-Prof, 1-Euro, 2-MC
    licEntModVer := 2;    // 0-Basic, 1-Stock, 2-SPOP
    licEntClSvr := 0;     // 0-Non C/S, 1=C/S
    licUserCnt := 5;

    licClServer := 0;     // 0-None, 1=NT, 2=Netware
    licCSUserCnt := 0;

    LicPath := ExtractFilePath(Application.ExeName) + 'ENtRPRSE\SETUP.BIN';
    If FileExists(LicPath) Then
    Begin
      IniF := TIniFile.Create(LicPath);
      Try
        { Read Default Country for Demo's }
        licCountry := IniF.ReadInteger('DemoConfig', 'Country', licCountry);
        If (licCountry < 1) Or (licCountry > 6) Then
        Begin
          licCountry := 1;
        End; { If }
      Finally
        IniF.Free;
      End;
    End; { If FileExists }
  End; { With CDLic }

  SetupLabels;
End;

//-----------------------------------

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssAlt in Shift then
  begin
    case key of
      ord('I'), ord('i') : lblInstallationInstructionsClick(Sender);
      ord('R'), ord('r') : lblReadExchequerLicenceClick(Sender);
      ord('E'), ord('e') : lblInstallProductClick(Sender);
    end;
  end;
end;

//-------------------------------------------------------------------------

// Controls the highlighting of the labels which can be clicked on
procedure TfrmMain.ConfigureLabelsEnter(Sender: TObject);

  //-----------------------------------

  Procedure SelectLabel (Const TheLabel : TLabel);
  Begin // SelectLabel
    TheLabel.Font.Style := TheLabel.Font.Style + [fsBold, fsUnderline];
    TheLabel.Cursor := crHandPoint;
  End; // SelectLabel

  //-----------------------------------

  Procedure DeselectLabel (Const TheLabel : TLabel);
  Begin // DeselectLabel
    TheLabel.Font.Style := TheLabel.Font.Style - [fsBold, fsUnderline];
    TheLabel.Cursor := crDefault;
  End; // DeselectLabel

  //-----------------------------------

begin
  If (Sender = lblInstallationInstructions) Then
    SelectLabel (lblInstallationInstructions)
  Else
    DeselectLabel (lblInstallationInstructions);

  If (Sender = lblReadExchequerLicence) Then
    SelectLabel (lblReadExchequerLicence)
  Else
    DeselectLabel (lblReadExchequerLicence);

  If (Sender = lblInstallProduct) Or (Sender = imbProductIcon) Then
    SelectLabel (lblInstallProduct)
  Else
    DeselectLabel (lblInstallProduct);
end;

//-----------------------------------

procedure TfrmMain.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ConfigureLabelsEnter(Sender);
end;

//-------------------------------------------------------------------------

procedure TfrmMain.lblInstallationInstructionsClick(Sender: TObject);
begin
  Application.HelpContext(1);
end;

//-----------------------------------

procedure TfrmMain.lblReadExchequerLicenceClick(Sender: TObject);
Var
  frmReadLic: TfrmReadLic;
  TmpStr: ShortString;
  I: Byte;
  OrigDir: ShortString;
Begin
  // HM 26/03/02: Modified to keep current dir intact
  OrigDir := GetCurrentDir;
  Try
    frmReadLic := TfrmReadLic.Create(Self);
    Try
      With frmReadLic Do
      Begin
        ShowModal;

        If OK Then
        Begin
          { Load licencing information }
          Self.Caption := OrigCapt + ' - ' + CDLic.licCompany;

          SetupLabels;

          Invalidate;
        End; { If }
      End; { With }
    Except
      frmReadLic.Free;
    End;
  Finally
    // Restore starting directory
    SetCurrentDir(OrigDir);
  End;
end;

//-----------------------------------

procedure TfrmMain.lblInstallProductClick(Sender: TObject);
Var
  LicFName: ShortString;
Begin
  If FileExists(ExtractFilePath(Application.ExeName) + 'ENTRPRSE\SETUP.EXE') Then
  Begin
    { Write licencing info file }
    LicFName := WriteLicFile(CDLic);

    If FileExists(LicFName) Then
    Begin
      // Use CreateProcess to shell it as ShellExecute fails under Vista RC1 when running from the CD
      RunApp(ExtractFilePath(Application.ExeName) + 'ENTRPRSE\SETUP.EXE /lf:' + LicFName, False);

      // For SQL Edition close the CD Auto-Run due to some weird problem Vini had - don't know what
      // the problem was or I'd remove it and see if it was still necessary
      If (CDLic.licEntDB = 1) Then // 1-MS SQL
        tmClose.Enabled := True;
    End; { If }
  End; { If }
end;

//-------------------------------------------------------------------------

// Works out what 'Install Product' option to show based on the currently loaded licence
Procedure TfrmMain.SetupLabels;
Begin { SetupLabels }
  // Check Licence Type - 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
  If (CDLic.licLicType In [0, 1]) Then
  Begin
    // 0-Btrieve, 1-MS SQL
    If (CDLic.licEntDB = 0) Then
      lblInstallProduct.Caption := 'Install &Exchequer (Pervasive Edition)'
    Else
      lblInstallProduct.Caption := 'Install &Exchequer (Microsoft SQL Edition)';
  End // If (CDLic.licLicType In [0, 1])
  Else
    lblInstallProduct.Caption := 'Install &Exchequer Demo (Pervasive Edition)';
End; { SetupLabels }

//-------------------------------------------------------------------------

Procedure TfrmMain.tmCloseTimer(Sender: TObject);
Begin
  tmClose.Enabled := False;
  Close;
End;

//-------------------------------------------------------------------------

End.

