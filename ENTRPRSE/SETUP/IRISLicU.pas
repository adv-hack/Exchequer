unit IRISLicU;

interface

Uses SetupU;

function iaoGetIRISClientInstallerDir (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses Dialogs, Registry, SysUtils, Windows;

// Used during the network install to return the directory containing the IRIS Licencing
// Client Installer on the local machine
function iaoGetIRISClientInstallerDir (var DLLParams: ParamRec): LongBool;
Var
  oReg : TRegistry;
  sClsID, sPath : ShortString;
Begin // iaoGetIRISClientInstallerDir
  Result := False;

  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_CLASSES_ROOT;
    // Check for existence of IRIS Licencing COM Object
    If oReg.OpenKey('Iris.Systems.Licensing\ClsID', False) Then
    Begin
      // Get GUID from default property
      If oReg.KeyExists('') Then
      Begin
        sClsID := oReg.ReadString ('');
        oReg.CloseKey;

        If oReg.OpenKey ('Clsid\' + sClsID + '\InprocServer32', False) Then
        Begin
          // CodeBase should be "C:\Program Files\IRIS Software Ltd\IRIS Licensing Network Client\Iris Account Office Licensing COM.dll"
          sPath := oReg.ReadString('CodeBase');
          If FileExists(sPath) Then
          Begin
            sPath := ExtractFilePath(sPath);
            SetVariable(DLLParams,'V_IRISLICDIR',sPath);
            Result := DirectoryExists(sPath + 'WSETUP');
          End; // If FileExists(sPath)
        End; // If oReg.OpenKey ('Clsid\' + sClsID + '\InprocServer32', False)
      End; // If oReg.KeyExists('')
    End; // If oReg.OpenKey('Iris.Systems.Licensing\ClsID', False)
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally
End; // iaoGetIRISClientInstallerDir


end.
