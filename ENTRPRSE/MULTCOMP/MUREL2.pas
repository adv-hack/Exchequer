unit MUREL2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ClipBrd, Dialogs, SetupBas, StdCtrls, Mask, TEditVal, ExtCtrls;

type
  TfrmEntUserCount = class(TSetupTemplate)
    edtFullSec: Text8Pt;
    edtFullRel: Text8Pt;
    edt30Rel: Text8Pt;
    edt30Sec: Text8Pt;
    lblESN: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblFullStatus: TLabel;
    lbl30Status: TLabel;
    Label10: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtFullSecDblClick(Sender: TObject);
    procedure edtFullRelExit(Sender: TObject);
    procedure edt30RelExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblESNDblClick(Sender: TObject);
    procedure Label6DblClick(Sender: TObject);
    procedure Label3DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure Disp30Dets;
  public
    { Public declarations }
  end;


Function Control_USRLine : Boolean;


implementation

{$R *.dfm}

Uses
  GlobVar,
  VarConst,
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU1,
  BTSupU2,
  SysU3,
  HelpSupU,
  Phonetic,
  UserSec,
  SecSup2U,
  LicRec,
  LicFuncU,
  EntLic;

//---------------------------------------------------------------------------

Function Control_USRLine : Boolean;
Var
  LicRec              : EntLicenceRecType;
  PrevHState, Locked  : Boolean;
  Ent30Lic            : CompOptRelCodeType;
Begin
  Result := True;

  With SyssCompany^.CompOpt, TfrmEntUserCount.Create(Application) Do
    Try
      // HM 21/01/02: Load Licence to allow ESN Byte 7 to be displayed
      If ReadEntLic (EntLicFName, LicRec) Then
        lblESN.Caption := licESN7Str (LicRec.licISN, LicRec.licLicType)
      Else
        lblESN.Caption := licESNStr (ESNByteArrayType(optSystemESN));

      edtFullSec.Text := OptEntUserSecurity;
      edtFullRel.Text := OptEntUserRelease;
      edtFullRelExit(Application);

      Disp30Dets;

      ShowModal;

      If (ExitCode = 'B') Then Begin
        Locked:=BOn;

        If (GetMultiSys(BOff,Locked,SysR)) and (Locked) then
        Begin
          Syss.ExUsrSec := edtFullSec.Text;
          Syss.ExUsrRel := edtFullRel.Text;

          {* Update duplicate record *}

          TrackSecUpdates(BOff);

          PutMultiSys(SysR,BOn);

          // Reload and Lock MCM Global Security record
          Ent30Lic := SyssCompany^.CompOpt.OptSecurity[ucEnterprise30];
          LoadnLockCompanyOpt;

          // Enterprise Global Full User Count
          SyssCompany^.CompOpt.OptEntUserSecurity := Syss.ExUsrSec;
          SyssCompany^.CompOpt.OptEntUserRelease := Syss.ExUsrRel;

          // Enterprise Global 30-Day User Count
          With SyssCompany^.CompOpt.OptSecurity[ucEnterprise30] Do Begin
            rcSecurity := Ent30Lic.rcSecurity;
            rcUserCount := Ent30Lic.rcUserCount;
            rcExpiry := Ent30Lic.rcExpiry;
          End; { With }

          // Update the MCM Global Security record
          PutCompanyOpt (True);
        end;
      End; { If (ExitCode = 'B') }

      Result := (ExitCode = 'B');
    Finally
      Free;
    End; { Try.. }
end;

//---------------------------------------------------------------------

procedure TfrmEntUserCount.FormCreate(Sender: TObject);
begin
  inherited;

  ExitMsg := 255;
end;

//-------------------------------------

procedure TfrmEntUserCount.Disp30Dets;
begin { Disp30Dets }
  With SyssCompany^.CompOpt.OptSecurity[ucEnterprise30] Do Begin
    edt30Sec.Text := rcSecurity;
    edt30Rel.Text := '';

    // Check 30-Day Expiry Date
    If Not CheckUCountExpiry (ucEnterprise30, False) Then
      // AOK
      lbl30Status.Caption := IntToStr(rcUserCount) + ' User'
    Else
      // Expired
      lbl30Status.Caption := 'Expired';
  End; { With SyssCompany^.CompOpt.OptSecurity[ucEnterprise30] }
End; { Disp30Dets }

//-------------------------------------

procedure TfrmEntUserCount.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//-------------------------------------

procedure TfrmEntUserCount.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------

procedure TfrmEntUserCount.edtFullSecDblClick(Sender: TObject);
Var
  CodeType, ModDesc : String[20];
begin
  If Sender Is Text8Pt Then
    With Sender As Text8Pt Do Begin
      If (Tag > 100) Then CodeType := 'Release' Else CodeType := 'Security';
      If ((Tag Mod 100) = 1) Then ModDesc := 'Full' Else ModDesc := '30-Day';

      // Display Msg with phonetic version of Security/Release Code
      MessageDlg('The phonetic ' + CodeType + ' Code for the Exchequer ' + ModDesc + ' User Count is ' +
                 QuotedStr(StringToPhonetic (Text)), mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

//-------------------------------------

procedure TfrmEntUserCount.edtFullRelExit(Sender: TObject);
begin
  lblFullStatus.Caption := IntToStr(DeCode_Usrs(edtFullSec.Text, edtFullRel.Text)) + ' User'
end;

//-------------------------------------

procedure TfrmEntUserCount.edt30RelExit(Sender: TObject);
Var
  UC          : SmallInt;
begin
  If (Trim(edt30Rel.Text) <> '') Then
    With SyssCompany^.CompOpt, OptSecurity[ucEnterprise30] Do Begin
      // Validate Security Code
      UC := DeCode_Usrs(rcSecurity,Trim(edt30Rel.Text));

      If (UC > 0) Then Begin
        // Valid Release Code entered - generate new code and record details
        Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
        // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
        //CurSecy := Set_Security;
        //rcSecurity := Calc_SecStr(CurSecy, False);
        rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 247, 0, 0);
        rcUserCount := UC;

        // Set 30-Day expiry
        rcExpiry := CalcNewRelDate (30);

        // update screen with new details
        Disp30Dets;
      End { If (UC > 0) }
      Else
        lbl30Status.Caption := '';
    End; { With }
end;

//-------------------------------------

procedure TfrmEntUserCount.lblESNDblClick(Sender: TObject);
begin
  Clipboard.AsText := lblESN.Caption;
end;

//-------------------------------------

procedure TfrmEntUserCount.Label6DblClick(Sender: TObject);
begin
  // Reset the 30-Day details
  With SyssCompany^.CompOpt, OptSecurity[ucEnterprise30] Do Begin
    rcSecurity := Generate_ESN_BaseSecurity (optSystemESN, 247, 0, 0);
    rcUserCount := 0;
    rcExpiry := 0;
  End; { With }

  // update screen with new details
  Disp30Dets;

  If edt30Rel.CanFocus Then edt30Rel.SetFocus;
end;

procedure TfrmEntUserCount.Label3DblClick(Sender: TObject);
begin
  // Reset the Full details
  edtFullSec.Text := Generate_ESN_BaseSecurity (SyssCompany^.CompOpt.optSystemESN, 254, 0, 0);
  edtFullRel.Text := '';

  // update screen with new details
  edtFullRelExit(Application);

  If edtFullRel.CanFocus Then edtFullRel.SetFocus;
end;

end.
