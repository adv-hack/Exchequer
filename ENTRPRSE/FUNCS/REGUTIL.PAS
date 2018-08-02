unit RegUtil;

{Registry Utilities}


{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Windows;

//PR 17/8/04 - GetCOMObjectDir no longer used.
//function GetCOMObjectDir(sObjectName : String) : string;

// CJS 2015-08-21 - 2015 R1 - ABSEXCH-16774 - VAT100 Submission
function RegKeyExists(hkRoot: HKEY; sPath: string): Boolean;

function RegReadString(hkRoot : HKEY; sPath, sKey : String) : string;
function RegWriteString(hkRoot : HKEY; sPath, sKey, sValue : String) : boolean;

implementation
uses
  Registry, SysUtils, Forms;
(*
function GetCOMObjectDir(sObjectName : String) : string;
var
  ClsId : string;
  oReg : TRegistry;
begin
  Result := '';

  oReg := TRegistry.Create;

  try
    oReg.Access := KEY_READ;

    {Check for COM Object}
    oReg.RootKey := HKEY_CLASSES_ROOT;
    If oReg.KeyExists(sObjectName + '\Clsid') Then
      {get path from com object registration}
      Begin
        { Key exists - get CLSID }
        If oReg.OpenKey(sObjectName + '\Clsid', False) Then Begin
          If oReg.KeyExists('') Then Begin
            ClsId := oReg.ReadString ('');
            { Open CLSID up and get executable name }
            oReg.CloseKey;
            If oReg.OpenKey('Clsid\'+ClsId+'\InprocServer32', False) Then Begin
              ClsId := oReg.ReadString ('');
              If FileExists (ClsId) Then Begin
                { Got File - Check its in current directory }
                Result := IncludeTrailingPathDelimiter(Trim(ExtractFilePath(ClsId)));
              End; { If }
            End; { If }
          End; { If }
        End; { If }
      End
    else Result := ExtractFilePath(Application.Exename);

    oReg.CloseKey;
  finally
    oReg.Free;
  end;{try}
end;{GetCOMObjectDir}
*)
// CJS 2015-08-21 - 2015 R1 - ABSEXCH-16774 - VAT100 Submission
function RegKeyExists(hkRoot: HKEY; sPath: string): Boolean;
var
  oReg : TRegistry;
begin
  oReg := TRegistry.Create;
  oReg.Access := KEY_READ;

  oReg.RootKey := hkRoot;
  Result := oReg.KeyExists(sPath);

  oReg.Free;
end;

function RegReadString(hkRoot : HKEY; sPath, sKey : String) : string;
var
  oReg : TRegistry;
begin
  Result := '';

  oReg := TRegistry.Create;
  oReg.Access := KEY_READ;

  oReg.RootKey := hkRoot;
  If oReg.KeyExists(sPath) Then begin
    if oReg.OpenKey(sPath, FALSE) then Result := oReg.ReadString(sKey);
  end;{if}

  oReg.CloseKey;
  oReg.Free;
end;

function RegWriteString(hkRoot : HKEY; sPath, sKey, sValue : String) : boolean;
var
  oReg : TRegistry;
begin
  Result := TRUE;

  oReg := TRegistry.Create;
  oReg.Access := KEY_WRITE;

  {Check for COM Object}
  oReg.RootKey := hkRoot;

  if oReg.OpenKey(sPath,TRUE) then oReg.WriteString(sKey, sValue)
  else Result := FALSE;

  oReg.CloseKey;
  oReg.Free;
end;



end.
