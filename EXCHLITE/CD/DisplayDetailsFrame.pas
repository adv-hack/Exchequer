unit DisplayDetailsFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets;

type
  TfraDisplaysDets = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblContinue: TLabel;
    lblInfo: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    lblCDKey: TLabel;
    lblCompanyName: TLabel;
    lblLITEVer: TLabel;
    lblPervasive: TLabel;
    procedure lblContinueClick(Sender: TObject);
    procedure lblIntroDblClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
    FWibble : Boolean;
  public
    { Public declarations }
    Procedure InitLicence (Const Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, WizdMsg, DateUtils, LicRec, LicFuncU, APIUtil,
     {$IFDEF COMP}
       GlobVar, VarConst, BtrvU2, CommonMCM, ModRels, BTSupU1, SecSup2U,
     {$ENDIF}
     ShellAPI;

//=========================================================================

Procedure TfraDisplaysDets.InitLicence (Const Licence : TLicenceDetails);
Var
  {$IFDEF COMP}
  CDLicence : CDLicenceRecType;
  bLocked, bOK : Boolean;
  {$ENDIF}
  Res : SmallInt;
Begin // InitLicence
  FLicence := Licence;
  FWibble := False;

  // Update Branding
  Case FLicence.ldMode Of
    lmDemo    : Begin
                  lblTitle.Caption := 'Install ' + Branding.pbProductName + ' Demo';
                  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<TYPE>', 'installation');
                  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
                  lblContinue.Caption := 'Install Demo';
                End; // lmDemo
    lmInstall : Begin
                  lblTitle.Caption := 'Install ' + Branding.pbProductName;
                  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<TYPE>', 'installation');
                  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
                  lblContinue.Caption := 'Install';
                End; // lmInstall
    lmUpgrade : Begin
                  {$IFDEF COMP}
                    // Licence Update wizard off MCM
                    lblContinue.Visible := False;

                    lblTitle.Caption := 'Update ' + Branding.pbProductName + ' Licence';
                    lblIntro.Caption := 'The licence for this installation of ' + Branding.pbProductName +
                                        ' has been updated as follows:-';
                  {$ELSE} // COMP
                    // IAO CD Autorun
                    lblTitle.Caption := 'Upgrade ' + Branding.pbProductName;
                    lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<TYPE>', 'upgrade');
                    lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
                    lblContinue.Caption := 'Upgrade';
                  {$ENDIF} // COMP
                End; // lmUpgrade
  Else
    Raise Exception.Create('TfraDownload.InitLicence: Unhandled Mode (' + IntToStr(Ord(FLicence.ldMode)) + ')');
  End; // Case FLicence.ldMode

  {$IFDEF COMP}
    // Keep a copy of the current licence so we can look for changes
    CDLicence := FLicence.ldCDLicence;
  {$ENDIF}

  If (FLicence.ldMode <> lmDemo) Then
    // Install/Upgrade - Build a full CD Licence from the supplied licencing info
    Res := FLicence.BuildLicence
  Else
    // Demo - Run with it
    Res := 0;

  If (Res <> 0) Then
  Begin
    MessageDlg (Format('Error %d: The Licencing Information provided is incomplete, please contact your Technical Support', [Res]),
                mtError, [mbOK], 0);
    lblContinue.Visible := False;
  End // If (Res <> 0)
  Else
  Begin
    // CD-Key
    lblCDKey.Caption := FormatCDKey (FLicence.ldCDLicence.licCDKey);

    // Company Name
    lblCompanyName.Caption := FLicence.ldCDLicence.licCompany;

    // Version Information
    lblLITEVer.Caption := licCDEntVersion (FLicence.ldCDLicence, False) +
                          Format (' - %d User / %d Company', [FLicence.ldCDLicence.licUserCnt, FLicence.ldCDLicence.licUserCounts[ucCompanies]]) +
                          '  (' + licCountryStr (FLicence.ldCDLicence.licCountry, True) + ')' +
                          IfThen(FLicence.ldCDLicence.licLicType = 1, '[DEMO]', '');

    // Perverted Squirrel - Key
    lblPervasive.Caption := FLicence.ldCDLicence.licPSQLLicKey;

    // Check the licence is for the correct version
    If (FLicence.ldVersion <> sCurrentIAOVersion) Then
    Begin
      MessageDlg ('The Licencing Information provided is for a different version of ' + Branding.pbProductName + ', please contact your Technical Support for an updated licence',
                  mtError, [mbOK], 0);
      lblContinue.Visible := False;
      Res := 101;  // Invalid Version
    End; // If (FLicence.ldVersion <> '1.0')
  End; // Else

  {$IFDEF COMP}
  If (Res = 0) Then
  Begin
    // Multi-Company Manager

    // Check for changes requiring an Upgrade to be run
    If (FLicence.ldCDLicence.licProductType <> CDLicence.licProductType) Or
       (FLicence.ldCDLicence.licEntEdition <> CDLicence.licEntEdition) Or
       (FLicence.ldCDLicence.licEntModVer <> CDLicence.licEntModVer) Or
       (FLicence.ldCDLicence.licEntCVer <> CDLicence.licEntCVer) Then
    Begin
      Refresh;
      MessageDlg('The licence changes will require new components to be installed which this wizard cannot do.' + #13#13 +
                 'Please use your ' + Branding.pbProductName + ' CD to run an Upgrade, this will then update your Licence ' +
                 'Details and install the new components.', mtInformation, [mbOK], 0);
      (Owner As TForm).Close;
    End // If
    Else
    Begin
      // Country - Don't change on existing data as could break the system
      //If (FLicence.ldCDLicence.licCountry <> CDLicence.licCountry) Then
      //Begin
      //  Syss.USRCntryCode := GetCountryCode(W_Country);
      //End; // If (FLicence.ldCDLicence.licCountry <> CDLicence.licCountry)

      // User Count
      If (FLicence.ldCDLicence.licUserCnt <> CDLicence.licUserCnt) Then
      Begin
        // Get and lock SysR
        bLocked := True;
        bOk := GetMultiSys(BOn, bLocked, SysR);
        If bOK Then
        Begin
          // Get and lock the Company Options record in Company.Dat which contains copies of
          // various system setup bits 'n pieces
          If LoadnLockCompanyOpt Then
          Begin
            // Update the user count security/release codes
            SetUserCount (FLicence.ldCDLicence.licUserCnt);

            // Copy the user count into the MCM - why is there a copy in the mcm?
            SyssCompany^.CompOpt.OptEntUserSecurity := Syss.ExUsrSec;
            SyssCompany^.CompOpt.OptEntUserRelease := Syss.ExUsrRel;

            // Update SysR
            PutMultiSys(SysR, True);  // Unlock

            // Update the MCM Global Security record
            PutCompanyOpt (True);

            // Write Exchequer and IRIS Licence info
            FLicence.UpdateLicencing;

            // Update all company datasets
            ReplicateSecurity;
          End; // If LoadnLockCompanyOpt
        End; // If OK
      End; // If (FLicence.ldCDLicence.licUserCnt <> CDLicence.licUserCnt)

      // Company Count
      If (FLicence.ldCDLicence.licUserCounts[ucCompanies] <> CDLicence.licUserCounts[ucCompanies]) Then
      Begin
        // Get and lock the Company Options record in Company.Dat which contains copies of
        // various system setup bits 'n pieces
        If LoadnLockCompanyOpt Then
        Begin
          With SyssCompany^.CompOpt.OptSecurity[ucCompanies] Do
          Begin
            rcSecurity := Generate_ESN_BaseSecurity (SyssCompany^.CompOpt.optSystemESN, 253, 0, 1);
            rcUserCount := FLicence.ldCDLicence.licUserCounts[ucCompanies];
          End; // With SyssCompany^.CompOpt.OptSecurity[ucCompanies]

          // Update the MCM Global Security record
          PutCompanyOpt (True);

          // Write Exchequer and IRIS Licence info
          FLicence.UpdateLicencing;
        End; // If LoadnLockCompanyOpt
      End; // If (FLicence.ldCDLicence.licUserCounts[ucCompanies] <> CDLicence.licUserCounts[ucCompanies])
    End; // Else
  End // If (Res = 0)
  {$ENDIF}
End; // InitLicence

//-------------------------------------------------------------------------

procedure TfraDisplaysDets.lblContinueClick(Sender: TObject);
begin
  // Install Pervasive.SQL Licence Key
  FLicence.InstallPervasiveKey;

  // Install LITE and revert to the initial options dialog so that additional companies can be added if necessary
  FLicence.StartInstaller;

  If (Not FWibble) Then PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amOptions))
end;

//-------------------------------------------------------------------------

procedure TfraDisplaysDets.lblIntroDblClick(Sender: TObject);
begin
  FWibble := True;
end;

end.
