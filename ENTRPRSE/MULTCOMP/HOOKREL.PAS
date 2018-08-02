unit HookRel;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ClipBrd, IniFiles, Setupbas, ExtCtrls, StdCtrls, Mask, TEditVal, HookSec;

type
  TfrmHookRelCode = class(TSetupTemplate)
    Label1: TLabel;
    Label9: TLabel;
    edtESN: Text8Pt;
    edtSecCode: Text8Pt;
    edtRelCode: Text8Pt;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblPhoneNo: TLabel;
    lblPhoneContact: TLabel;
    procedure Label3DblClick(Sender: TObject);
  private
    { Private declarations }
    FModSec : ModuleSecurityRecType;
    FValid  : ValidCodesRecType;
  protected
    Procedure LoadSetupInfo (Const EntPath : ShortString);
    Procedure SetModSec (Value : ModuleSecurityRecType);
    Procedure SetValid (Value : ValidCodesRecType);
    Function  ValidOk(VCode : Char) : Boolean; Override;
  public
    { Public declarations }
    Property ModuleSecurity : ModuleSecurityRecType Read FModSec Write SetModSec;
    Property ValidRelCodes : ValidCodesRecType Read FValid Write SetValid;
  end;


// Displays a dialog to allow a release code to be entered for a hook
Function InputReleaseCode (Var   ModSecurity : ModuleSecurityRecType;
                           Const ValidCodes  : ValidCodesRecType;
                           Const EntPath     : ShortString;
                           Const ModuleDesc  : ShortString) : Boolean;


implementation

{$R *.DFM}

Uses GlobVar, HelpSupU, SecureU, SecSup2U;

// Displays a dialog to allow a release code to be entered for a hook
Function InputReleaseCode (Var   ModSecurity : ModuleSecurityRecType;
                           Const ValidCodes  : ValidCodesRecType;
                           Const EntPath     : ShortString;
                           Const ModuleDesc  : ShortString) : Boolean;
Begin { InputReleaseCode }
  With TfrmHookRelCode.Create (Application) Do
    Try
      Caption := ModuleDesc;

      LoadSetupInfo (EntPath);

      ModuleSecurity := ModSecurity;
      ValidRelCodes := ValidCodes;

      ShowModal;

      Case ExitCode Of
        // Accept
        'B' : Begin
                // Validate Release Code
                ModSecurity := ModuleSecurity;
                Result := True;
              End;

        // Cancel
        'N' : Result := False;
      End; { Case ExitCode }
    Finally
      Free;
    End;
End; { InputReleaseCode }

//----------------------------------------------------------------

Procedure TfrmHookRelCode.LoadSetupInfo (Const EntPath : ShortString);
Begin { LoadSetupInfo }
  With TIniFile.Create (EntPath + '\wstation\setup.bin') Do
    Try
      { Telephone Settings ------------------------------------------------------ }
      lblPhoneContact.Caption := ReadString('VendorDetails', 'vdContact', '?');
      lblPhoneNo.Caption := ReadString('VendorDetails', 'vdPhone', '?');
    Finally
      Free;
    End;
End; { LoadSetupInfo }

//------------------------------------

procedure TfrmHookRelCode.SetModSec(Value: ModuleSecurityRecType);
begin
  FModSec := Value;

  With FModSec Do Begin
    edtSecCode.Text := msSecurityCode;
    edtRelCode.Text := '';
  End; { With FModSec }
end;

//------------------------------------

procedure TfrmHookRelCode.SetValid(Value: ValidCodesRecType);
begin
  FValid := Value;

  With FValid Do
    edtESN.Text := Format ('%3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d', [vcESN[1], vcESN[2], vcESN[3],
                                                                   vcESN[4], vcESN[5], vcESN[6]]);
end;

//------------------------------------

{ Perform any required validation - should be overridden }
Function TfrmHookRelCode.ValidOk(VCode : Char) : Boolean;
Var
  CurrRel : LongInt;
Begin
  If (VCode = 'B') Then
    // Accept Button - Check entered code
    With FModSec, FValid Do Begin
      // Copy Release Code into licence info
      msReleaseCode := UpperCase(Trim(edtRelCode.Text));

      // Calculate value of Release Code
      CurrRel := Calc_Security (msReleaseCode, BOn);

      // Check for validity
      Result := (CurrRel = vcFullCode) Or (CurrRel = vc30DayCode);

      If Result Then Begin
        // Release Code valid - check for Full/30-Day
        msReleaseDate := 0;

        If (CurrRel = vc30DayCode) Then Begin
          // 30-Day - set Expiry Date and new Security Code
          msSecurityCode := Get_ISNSecurity(vcESN);
          msReleaseCode := '';
          msReleaseDate := CalcNewRelDate(MaxDaysSecy);
        End; { If (CurrRel = vc30DayCode) }
      End { If Result }
      Else
        MessageDlg ('The Release Code is wrong, carefully check the Release Code and correct it', mtError, [mbOk], 0);
    End { With FModSec, FValid }
  Else
    Result := True;
End;

//------------------------------------



procedure TfrmHookRelCode.Label3DblClick(Sender: TObject);
begin
  inherited;

  Clipboard.AsText := edtESN.Text + #13 + edtSecCode.Text;
end;

end.
