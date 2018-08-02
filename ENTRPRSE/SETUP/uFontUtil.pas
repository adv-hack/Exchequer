unit uFontUtil;

interface

uses Windows, Sysutils, Registry, setupu;

function CheckFontIsInstalled(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{-----------------------------------------------------------------------------
  Procedure: CheckFontIsInstalled
  Author:    vmoura

  check if pFont is registered...
-----------------------------------------------------------------------------}
function CheckFontIsInstalled(var DLLParams: ParamRec): LongBool;
Var
  oReg : TRegistry;
  sFontName, sClsID: String;
Begin
  GetVariable(DLLParams, 'FONTNAME', sFontName);
  SetVariable(DLLParams,'FONTINSTALLED','N');
  // HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts
  Result := FAlse;
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_READ;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    // Check for COM Object registration Key
    If oReg.KeyExists('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts') Then
      if oReg.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', False) then
      begin
        // Get GUID from default property
          sClsID := oReg.ReadString (sFontName);
          oReg.CloseKey;

          Result := sClsID <> '';
          if Result then
            SetVariable(DLLParams,'FONTINSTALLED','Y');
        End; // If oReg.KeyExists('')
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally
end;


end.
