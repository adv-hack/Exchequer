unit PISecure;

interface

type
  TPluginType = (ptDLL, ptCOM, ptStandaloneEXE, ptTCM);

  function PICheckSecurity(sSystemCode, sSecurityCode, sDescription, sVersionNo : String
  ; iSecurityType : integer; PluginType : TPluginType; sPluginPath : string) : boolean;

const
  stSystemOnly = 0;

implementation
uses
  ApiUtil, COMObj, Dialogs, SysUtils, Variants, PIExpire, Forms, Controls, Windows;

function PICheckSecurity(sSystemCode, sSecurityCode, sDescription, sVersionNo : String
; iSecurityType : integer; PluginType : TPluginType; sPluginPath : string) : boolean;
// Checks whether a Plugin has been released and is allow to be run.
// Returns TRUE if it is OK to continue, or FALSE if it is not.
var
  pPluginPath, pDLLPath, pEntPath : PChar;
  oSecurity : Variant;
  iResult : integer;

  _RemovePlugIn  : Function(pEnterpriseDir, pPlugInPath : PChar) : SmallInt; StdCall;
  _MyGSRHandle : THandle;
//  DLLAddr      : TFarProc;
begin

  {$IF Defined(EX600) or Defined(LIC600) or Defined(EXSQL)}
    if (UpperCase(Copy(sVersionNo,1,2)) = 'V6')
    or (UpperCase(Copy(sVersionNo,1,2)) = 'B6') then
    begin
      // this is OK. It is a v6 plug-in, and it has v6 compiler directives defined
    end else
    begin
      if Trim(sVersionNo) = '' then
      begin
        // This is OK, since I sometimes have a version number of nothing for Plug-Ins that have more than one part.
        // This is because impossible to keep all the version numbers in sync.
      end else
      begin
        MessageDlg('PICheckSecurity : PISecure.pas'#13#13 +
        'The Plug-In (' + sDescription + ') has been compiled incorrectly'#13#13
        + 'You are compiling a v5 plug-in, but you have v6 compiler directives defined'
        , mtError, [mbOK], 0);
      end;{if}
    end;{if}
  {$IFEND}

  {$IF (not Defined(EX600)) or (not Defined(LIC600))}
    if UpperCase(Copy(sVersionNo,1,2)) = 'V6' then
    begin
      MessageDlg('PICheckSecurity : PISecure.pas'#13#13 +
      'The Plug-In (' + sDescription + ') has been compiled incorrectly'#13#13
      + 'You are compiling a v6 plug-in, but you have not got EX600 or LIC600 defined'
      , mtError, [mbOK], 0);
    end else
    begin
      // this is OK. It is a v5 plug-in, and no v6 compiler directives defined
    end;{if}
  {$IFEND}

  case iSecurityType of
    stSystemOnly : begin
      Result := FALSE;
      try
        {Initialise Security Object}
        oSecurity := CreateOleObject('EnterpriseSecurity.ThirdParty');
        oSecurity.tpSystemIDCode := sSystemCode;
        oSecurity.tpSecurityCode := sSecurityCode;
        oSecurity.tpDescription := sDescription + ' ' + sVersionNo;
        oSecurity.tpSecurityType := iSecurityType;
        oSecurity.tpMessage := 'For Sales or Technical Help, contact your Exchequer Reseller';

        {Check Security based on above settings}
        iResult := oSecurity.ReadSecurity;
        if iResult = 0 then
          begin
            case oSecurity.tpSystemStatus of

              0 : begin
                {Expired}
                with TfrmPlugInExpired.Create(application) do begin
                  try
                    sPluginDesc := sDescription;
                    WindowMode := Ord(PluginType);
                    if ShowModal = mrCancel then begin
                      {Remove Plug-In}

                      { Load ENTSETUP.DLL dynamically }

                      pEntPath := StrAlloc(255);
                      pDLLPath := StrAlloc(255);
                      StrPCopy(pEntPath, ExtractFilePath(Application.ExeName));
                      StrPCopy(pDLLPath, ExtractFilePath(Application.ExeName) + 'ENTSETUP.DLL');
                      _MyGSRHandle := LoadLibrary(pDLLPath);
                      StrDispose(pDLLPath);

                      Try
                        If (_MyGSRHandle > HInstance_Error) Then Begin

                          pPluginPath := StrAlloc(255);
                          StrPCopy(pPluginPath,sPluginPath);

                          case PluginType of
                            ptDLL : _RemovePlugIn := GetProcAddress(_MyGSRHandle, 'RemoveDLLPlugIn');
                            ptCOM : _RemovePlugIn := GetProcAddress(_MyGSRHandle, 'RemoveCOMPlugIn');
                          end;{case}

                          If Assigned(_RemovePlugIn) then Begin
                            _RemovePlugIn(pEntPath, pPluginPath);
                          End; { If }
                          StrDispose(pPlugInPath);

                          { Unload library }
                          FreeLibrary(_MyGSRHandle);
                          _MyGSRHandle:=0;
                        End; { If }
                      Except
                        FreeLibrary(_MyGSRHandle);
                        _MyGSRHandle:=0;

                        _RemovePlugIn := Nil;
                      End;
                      StrDispose(pEntPath);

                    end;{if}
                  finally
                    Free;
                  end;{try}
                end;{with}
              end;

              1,2 : Result := TRUE; {OK to continue}

              else begin
                {Invalid Value (should never happen)}
                MsgBox('oSecurity.tpSystemStatus Returned an invalid value : '
                + IntToStr(oSecurity.tpSystemStatus), mtError,[mbOK],mbOK,sDescription);
              end;
            end;{case}
          end
        else begin
          {Security could not be read}
          MsgBox('Could not read the Exchequer security using the COM object '
          + 'oSecurity.ReadSecurity returned a value of : ' + IntToStr(iResult) + #13#13
          + ' Error Description : ' + oSecurity.LastErrorString
          , mtError,[mbOK],mbOK, sDescription);
        end;{if}

      except
        {Object could not be created}
        MsgBox('Could not create an Exchequer Security COM object'
        , mtError,[mbOK],mbOK, sDescription);
      end;

      {Clear Up}
      oSecurity := Unassigned;
    end;

    else begin
      Result := FALSE;
    end;

  end;{case}
end;{PICheckSecurity}

end.
