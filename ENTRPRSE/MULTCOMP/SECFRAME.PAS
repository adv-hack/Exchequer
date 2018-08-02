unit SecFrame;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, GlobVar, VarConst, VarRec2U;

type
  TPlugInSecFrame = class(TFrame)
    lblId: TLabel;
    lblDesc: TLabel;
    Label831: Label8;
    txtSystemSec: Text8Pt;
    lblSystem: Label8;
    lblUserCount: Label8;
    txtUserSec: Text8Pt;
    txtUserRel: Text8Pt;
    Label830: Label8;
    txtSystemRel: Text8Pt;
    Label832: Label8;
    txtSystemStatus: Text8Pt;
    txtUserStatus: Text8Pt;
    Bevel1: TBevel;
    lblMessage: Label8;
    procedure DispPhoneticCode(Sender: TObject);
    procedure txtSystemRelExit(Sender: TObject);
    procedure txtUserRelExit(Sender: TObject);
  private
    { Private declarations }
  protected
    constructor Create(AOwner: TComponent); override;
  public
    { Public declarations }
    Changed    : Boolean;
    lHookDets  : HookSecurityRecType;
    SecurityNo : LongInt;
    SysESN     : ISNArrayType;

    Procedure ResetSecurityCode;
    Procedure SaveChanges;
    Procedure SetDets (Const HookDets : HookSecurityRecType; Const HideFields : Boolean);
    Procedure SetTags (Const TagBase : SmallInt);
  end;

implementation

{$R *.DFM}

Uses Phonetic, BtrvU2, BTSupU1, HelpSupU, SecureU, LicRec, ESNPWF, SecSup2U;

constructor TPlugInSecFrame.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  Changed := False;
  FillChar (lHookDets, SizeOf(lHookDets), #0);
  FillChar (SysESN, SizeOf(SysESN), #0);
end;

//---------------------------------------------------------------------------

Procedure TPlugInSecFrame.SetDets (Const HookDets : HookSecurityRecType; Const HideFields : Boolean);
Begin { SetDets }
  lHookDets := HookDets;

  With lHookDets Do Begin
    // HM 11/01/02: Calculate Security Number for security release code system
    SecurityNo := StrToInt(Copy (hkId, 11, 6));

    lblDesc.Caption := Trim(hkDesc);
    lblId.Caption := hkId;

    lblMessage.Caption := Trim(HookDets.hkMessage);
    lblMessage.Visible := (lblMessage.Caption <> '');

    If (Not lblMessage.Visible) And HideFields Then
      // Resize frame to hide missing message area
      Self.Height := Self.Height - (Bevel1.Top - lblMessage.Top);

    If (hkSecType In [0, 2]) Then Begin
      // System Security
      txtSystemSec.Text := hkSysSecurity;
      txtSystemRel.Text := '';
      Case hkSysRelStatus Of
        0  : txtSystemStatus.Text := 'Disabled';
        1  : txtSystemStatus.Text := '30-Day';
        2  : txtSystemStatus.Text := 'Enabled';
      Else
        txtSystemStatus.Text := 'Error - Call Support';
      End; { Case }
    End { If (hkSecType In [0, 2]) }
    Else
      If HideFields Then Begin
        // No User Count Security - Hide section and adjust frame to cover
        Self.Height := Self.Height - (txtUserSec.Top - txtSystemSec.Top);

        // hide unwanted system security fields
        lblSystem.Visible := False;
        txtSystemSec.Visible := False;
        txtSystemRel.Visible := False;
        txtSystemStatus.Visible := False;

        // Reposition message field
        If lblMessage.Visible Then
          lblMessage.Top := lblMessage.Top - (txtUserSec.Top - txtSystemSec.Top);

        // reposition user count fields
        lblUserCount.Top := lblSystem.Top;
        txtUserSec.Top := txtSystemSec.Top;
        txtUserRel.Top := txtSystemRel.Top;
        txtUserStatus.Top := txtSystemStatus.Top;
      End; { Else }

    If (hkSecType In [1, 2]) Then Begin
      // User Count Security
      txtUserSec.Text := hkUCSecurity;
      txtUserRel.Text := '';
      txtUserStatus.Text := IntToStr (hkLicUCount) + ' User';
      If (hkLicUCount <> 1) Then
        txtUserStatus.Text := txtUserStatus.Text + 's';
    End { If (hkSecType In [1, 2]) }
    Else
      If HideFields Then Begin
        // No User Count Security - Hide section and adjust frame to cover
        lblUserCount.Visible := False;
        txtUserSec.Visible := False;
        txtUserRel.Visible := False;
        txtUserStatus.Visible := False;

        // Reposition message field
        If lblMessage.Visible Then
          lblMessage.Top := lblMessage.Top - (txtUserSec.Top - txtSystemSec.Top);

        Self.Height := Self.Height - (txtUserSec.Top - txtSystemSec.Top);
      End; { Else }
  End; { With HookDets }
End; { SetDets }

//---------------------------------------------------------------------------

Procedure TPlugInSecFrame.SetTags (Const TagBase : SmallInt);
Begin { SetTags }
  // Plug-In ID Code
  lblId.Tag := TagBase;

  // System Security Code and Release Code
  txtSystemSec.Tag := TagBase;
  txtSystemRel.Tag := 100 + TagBase;

  // User Count Security Code and Release Code
  txtUserSec.Tag := 200 + TagBase;
  txtUserRel.Tag := 300 + TagBase;
End; { SetTags }

//---------------------------------------------------------------------------

procedure TPlugInSecFrame.DispPhoneticCode(Sender: TObject);
Var
  sType : ShortString;
  ModNo   : LongInt;
begin
  If Sender Is Text8pt Then
    With Sender As Text8Pt Do Begin
      ModNo := (Tag Div 100);

      // Determine Module Desc
      Case ModNo Of
        // system Security Code
        0 : Begin
              sType := 'System Security';
            End;
        // System Release Code
        1 : Begin
              sType := 'System Release';
            End;
        // User Security Code
        2 : Begin
              sType := 'User Count Security';
            End;
        // User Release Code
        3 : Begin
              sType := 'User Count Release';
            End;
      End; { Case }

      // Display Msg with phonetic version of Release Code
      MessageDlg('The phonetic ' + sType + ' Code for ' + QuotedStr(Trim(lHookDets.hkDesc)) + ' is ' +
                 QuotedStr(StringToPhonetic (Text)),
                 mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

//---------------------------------------------------------------------------

// Exit System Release Code
procedure TPlugInSecFrame.txtSystemRelExit(Sender: TObject);
Var
  //FullExSec, NextDSec, CurRel, CurSecy : LongInt;
  FullExSec, NextDSec, CurRel : String[10];
Begin
  If (Trim(txtSystemRel.Text) <> '') Then
    With lHookDets Do Begin
      { Calculate valid release codes }
      // V5SECREL HM 11/01/02: Modified for new v5.00 Security/Release Code system
      //CurSecy := Calc_Security(hkSysSecurity, BOff);
      //FullExSec := CurSecy + SecRelCode;
      //NextDSec := CurSecy + SecXtra30Code;

      {$IFDEF EN561}
      FullExSec := Generate_ESN_BaseRelease (hkSysSecurity, 252, PI_CheckSum(SecurityNo), 0, ExNewVer);
      NextDSec  := Generate_ESN_BaseRelease (hkSysSecurity, 252, PI_CheckSum(SecurityNo), 1, ExNewVer);
      {$ELSE}
      FullExSec := Generate_ESN_BaseRelease (hkSysSecurity, 252, PI_CheckSum(SecurityNo), False, ExNewVer);
      NextDSec  := Generate_ESN_BaseRelease (hkSysSecurity, 252, PI_CheckSum(SecurityNo), True, ExNewVer);
      {$ENDIF}

      { Check entered release code }
      // V5SECREL HM 11/01/02: Modified for new v5.00 Security/Release Code system
      //CurRel := Calc_Security(Trim(txtSystemRel.Text), BOn);
      CurRel := Trim(txtSystemRel.Text);
      If (CurRel = FullExSec) Then Begin
        // Full Release Code
        Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
        // V5SECREL HM 11/01/02: Modified for new v5.00 Security/Release Code system
        //hkSysSecurity  := Get_ISNSecurity(SysESN);
        hkSysSecurity  := Generate_ESN_BaseSecurity (SysESN, 252, PI_CheckSum(SecurityNo), 0);
        hkSysExpiry    := 0;
        hkSysRelStatus := 2;   // Fully Released

        // Update screen & Mark for storage
        SetDets (lHookDets, False);
        Changed := True;
      End { If }
      Else
        If (CurRel = NextDSec) Then Begin
          // 30-Day Release Code
          Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
          // V5SECREL HM 11/01/02: Modified for new v5.00 Security/Release Code system
          //hkSysSecurity  := Get_ISNSecurity(SysESN);
          hkSysSecurity  := Generate_ESN_BaseSecurity (SysESN, 252, PI_CheckSum(SecurityNo), 0);
          hkSysExpiry    := CalcNewRelDate(MaxDaysSecy);
          hkSysRelStatus := 1;   // 30-Day

          // Update screen & Mark for storage
          SetDets (lHookDets, False);
          Changed := True;
        End { If (CurRel = NextDSec) }
        Else Begin
          // Invalid Release Code
          txtSystemStatus.Text := '';
          Beep;
        End; { Else }
    End; { With lHookDets }
end;

//---------------------------------------------------------------------------

// Exit User Count Release Code
procedure TPlugInSecFrame.txtUserRelExit(Sender: TObject);
Var
  RMode, Idx  : Byte;
  UC          : SmallInt;
  //CurSecy     : LongInt;
begin
  If (Trim(txtUserRel.Text) <> '') Then
    With lHookDets Do Begin
      // Validate Security Code
      UC := DeCode_Usrs(hkUCSecurity, Trim(txtUserRel.Text));

      If (UC > 0) Then Begin
        // Valid Release Code entered - generate new code and record details
        Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
        // HM 24/01/02: Updated for v5.00 ESN based RelCodes
        //CurSecy      := Set_Security;
        //hkUCSecurity := Calc_SecStr(CurSecy, False);
        hkUCSecurity := Generate_ESN_BaseSecurity (SysESN, 250, PI_CheckSum(SecurityNo), 0);
        hkLicUCount  := UC;

        // Update screen & Mark for storage
        SetDets (lHookDets, False);
        Changed := True;
      End { If (UC > 0) }
      Else Begin
        txtUserStatus.Text := '';
        Beep;
      End; { Else }
    End; { With lHookDets }
end;

//---------------------------------------------------------------------------

Procedure TPlugInSecFrame.SaveChanges;
Var
  RecAddr : LongInt;
  KeyS    : Str255;
  LStatus : SmallInt;
  Locked  : Boolean;
Begin { SaveChanges }
  If Changed Then Begin
    // Find and lock the Plug-In security record
    KeyS := cmPlugInSecurity + lHookDets.hkPath;
    Locked := False;
    If GetMultiRec(B_GetEq, B_MultLock, KeyS, CompPathK, CompF, True, Locked) And Locked Then Begin
      // Get record position so the record can be unlocked
      GetPos(F[CompF], CompF, RecAddr);

      // Copy details in from local record
      Company^.PlugInSec := lHookDets;

      // Update record
      LStatus := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompPathK);
      Report_BError (CompF, LStatus);

      // Unlock record
      UnlockMultiSing(F[CompF], CompF, RecAddr);
    End { If GetMultiRec ... }
    Else
      // Failed to lock record
      MessageDlg('The Security Record for ' + QuotedStr(lHookDets.hkDesc) +
                 ' could not be locked for updating, please try again later',
                 mtWarning, [mbOK], 0);
  End; { If Changed }
End; { SaveChanges }

//---------------------------------------------------------------------------

// Resets the Security Code for the Plug-In
Procedure TPlugInSecFrame.ResetSecurityCode;
{Var
  CurSecy : LongInt;}
Begin { ResetSecurityCode }
  With lHookDets Do Begin
    // generate new code and record details

    // System Security Code
    Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
    // HM 24/01/02: Updated for v5.00 ESN based RelCodes
    //hkSysSecurity  := Get_ISNSecurity(SysESN);
    hkSysSecurity  := Generate_ESN_BaseSecurity (SysESN, 252, PI_CheckSum(SecurityNo), 0);

    // User Count Security Code
    Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
    // HM 24/01/02: Updated for v5.00 ESN based RelCodes
    //CurSecy      := Set_Security;
    //hkUCSecurity := Calc_SecStr(CurSecy, False);
    hkUCSecurity := Generate_ESN_BaseSecurity (SysESN, 250, PI_CheckSum(SecurityNo), 0);

    // Update screen & Mark for storage
    SetDets (lHookDets, False);
    Changed := True;
  End; { With lHookDets }
End; { ResetSecurityCode }

//---------------------------------------------------------------------------

end.
