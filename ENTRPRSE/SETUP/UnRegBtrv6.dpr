program UnRegBtrv6;

uses
  Controls,
  Dialogs,
  Registry,
  Windows;

{$R *.res}

Var
  oReg : TRegistry;

begin
  If (MessageDlg('Please confirm that you want to remove the current users Btrieve v6.15 ' +
                 'Registration from the Registry on this workstation', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
  Begin
    oReg := TRegistry.Create;
    Try
      oReg.Access := KEY_READ Or KEY_WRITE;
      oReg.RootKey := HKEY_CURRENT_USER;

      If oReg.OpenKey ('Software\IRIS\IRIS Accounts Office\Btrieve615', False) Then
      Begin
        oReg.WriteBool('PreInstalled', False);
        oReg.WriteString('PreInstallDir', '');
      End; // If oReg.OpenKey ('Software\IRIS\IRIS Accounts Office\Btrieve615', False)
    Finally
      oReg.Free;
    End; // Try..Finally
  End; // If (MessageDlg('If (MessageDlg('...
end.
