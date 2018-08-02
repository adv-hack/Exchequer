unit Btr6_RegistryFlags;

interface

Uses Windows, Registry, SysUtils, WiseAPI;

// Writes the registry flags to be detected by the IAO CD Auto-Run and Installer
function btr6SetRegistryFlags (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

//-------------------------------------------------------------------------

// Writes the registry flags to be detected by the IAO CD Auto-Run and Installer
function btr6SetRegistryFlags (var DLLParams: ParamRec): LongBool;
Var
  oReg      : TRegistry;
  W_MainDir : String;
Begin // btr6SetRegistryFlags
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_READ Or KEY_WRITE;
    oReg.RootKey := HKEY_CURRENT_USER;

    If oReg.OpenKey ('Software\IRIS\IRIS Accounts Office\Btrieve615', True) Then
    Begin
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);

      oReg.WriteBool('PreInstalled', True);
      oReg.WriteString('PreInstallDir', W_MainDir);
    End; // If oReg.OpenKey ('Software\IRIS\IRIS Accounts Office', True)
  Finally
    oReg.Free;
  End; // Try..Finally
End; // btr6SetRegistryFlags

//-------------------------------------------------------------------------

end.
