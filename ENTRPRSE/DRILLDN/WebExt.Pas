unit WebExt;

{$ALIGN 1}

interface

// Returns TRUE if Web Extensions is enabled
Function CheckForWebExtensionsLicence : Boolean;

Implementation

Uses SQLUtils, oMCMSec;

Var
  Checked, GotWebExtensionsLicence : Boolean;

// Returns TRUE if Web Extensions is enabled
Function CheckForWebExtensionsLicence : Boolean;
Var
  oMCMSecurity : TMCMSecurity;
  Res : LongInt;
Begin // CheckForWebExtensionsLicence
  If (Not Checked) Then
  Begin
    If SQLUtils.UsingSQL Then
    Begin
      oMCMSecurity := TMCMSecurity.Create (ssEnterprise, 0);
      Try
        // MH 08/01/2010: Added function to check on Plug-In Release Code statuses
        //
        //   0   Not Licenced
        //   1   30-Day Licence
        //   2   Full Licence
        // -ve   Error - panic!
        //
        Res := oMCMSecurity.CheckPlugInLicence ('EXCHQRLIVE999001');
        GotWebExtensionsLicence := Res In [1, 2];
      Finally
        oMCMSecurity.Free;
      End; // Try..Finally
    End; // If SQLUtils.UsingSQL
    Checked := True;
  End; // If (Not Checked)

  Result := GotWebExtensionsLicence;
End; // CheckForWebExtensionsLicence

Initialization
  Checked := False;
  GotWebExtensionsLicence := False;
end.