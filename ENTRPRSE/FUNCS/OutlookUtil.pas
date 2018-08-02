unit OutlookUtil;

interface

Uses Registry, Windows;

// Returns TRUE if MS Outlook is installed
Function OutlookInstalled : Boolean;

implementation

// Returns TRUE if MS Outlook is installed
Function OutlookInstalled : Boolean;
Begin // OutlookInstalled
  Result := False;

  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;
      Result := KeyExists('Outlook.Application');
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
End; // OutlookInstalled

end.
