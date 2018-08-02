unit uMSXMLUtil;

interface

uses Windows, Sysutils, Registry;


function IsMSXMLInstalled: Longbool; StdCall; export;

implementation


{-----------------------------------------------------------------------------
  Procedure: IsMSXMLInstalled
  Author:    vmoura

  check if msxml is installed 
-----------------------------------------------------------------------------}
function IsMSXMLInstalled: Longbool;

Var
  oReg : TRegistry;
  sClsID, sPath: String;
Begin
  Result := FAlse;
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_READ;
    oReg.RootKey := HKEY_CLASSES_ROOT;

    // Check for COM Object registration Key
    If oReg.KeyExists('Msxml.DOMDocument\Clsid') Then
      if oReg.OpenKey('Msxml.DOMDocument\Clsid', False) then
        // Get GUID from default property
        If oReg.KeyExists('') Then
        Begin
          sClsID := oReg.ReadString ('');
          oReg.CloseKey;
          {check inprocserver}
          If oReg.OpenKey ('Clsid\' + sClsID + '\InprocServer32', False) Then
          Begin
            {read the directory from where the dll is registered}
            sPath := trim(oReg.ReadString(''));
            if sPath <> '' then
            begin
              {check if the dll was previous installed in win\systen32 directory}
              //Result := AnsiSameText(pDir, GetWinSys);
              Result := True;
            end; // if sPath <> '' then

            oReg.CloseKey;
          End; // If oReg.OpenKey ('Clsid\' + sClsID + '\InprocServer32', False)
        End; // If oReg.KeyExists('')
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally
end;


end.
