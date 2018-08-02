unit PortReg;

interface
uses
  Registry, Windows, SysUtils, APIUtil, Dialogs, Classes;

const
  MaxNoOfComPorts = 4;

  Procedure ResetComPortReg(sApplication : string);
  Procedure SetComPortReg(sApplication : string; iComPortNo : integer; bSetTo : boolean);
  Function ComPortInUseReg(iComPortNo : integer) : boolean;
  Function ComPortAppInUseReg(iComPortNo : integer; sApplication : string) : boolean;
  Procedure RegAccessError(sKey, sOperation : string; iErrorNo : integer);


implementation


Procedure RegAccessError(sKey, sOperation : string; iErrorNo : integer);
{displays an error message when registry access is not allowed}
begin
  MsgBox('Could not ' + sOperation + ' the Registry entry : ' + #13#13#9
  + sKey, mtError,[mbOK],mbOK,'Registry Access Error : ' + IntToStr(iErrorNo));
end;

Procedure ResetComPortReg(sApplication : string);
{Resets registry entries for all the com ports of the defined application}
var
  iComPortNo : integer;
begin
  with TRegistry.create do begin
    try
      Access := KEY_ALL_ACCESS;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('Software\Exchequer\ComPorts\' + sApplication, True) then
        begin
          For iComPortNo := 1 to MaxNoOfComPorts do WriteBool('COM' + IntToStr(iComPortNo), FALSE);
        end
      else RegAccessError('HKEY_LOCAL_MACHINE\Software\Exchequer\ComPorts\' + sApplication, 'create',1);
    finally
      CloseKey;
      Free;
    end;{try}
  end;{with}
end;

Procedure SetComPortReg(sApplication : string; iComPortNo : integer; bSetTo : boolean);
{Sets the registry setting for the defined com port and application, to the value passed in (bSetTo)}
begin
  if (iComPortNo > 0) and (iComPortNo <= MaxNoOfComPorts) then begin
    with TRegistry.create do begin
      try
        Access := KEY_ALL_ACCESS;
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('Software\Exchequer\ComPorts\' + sApplication, TRUE) then
          begin
            WriteBool('COM' + IntToStr(iComPortNo), bSetTo);
          end
        else RegAccessError('HKEY_LOCAL_MACHINE\Software\Exchequer\ComPorts\' + sApplication, 'create',2);
      finally
        CloseKey;
        Free;
      end;{try}
    end;{with}
  end;{if}
end;

Function ComPortAppInUseReg(iComPortNo : integer; sApplication : string) : boolean;
{Checks in the registry against the application, to see if the defined Com Port is said to be in use}
var
  slApplications : TStringList;
  iApp : integer;
begin
  Result := FALSE;
  if (iComPortNo > 0) and (iComPortNo <= MaxNoOfComPorts) then begin
    with TRegistry.create do begin
      try
        slApplications := TStringList.Create;
        Access := KEY_READ;
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('Software\Exchequer\ComPorts\' + sApplication, TRUE) then
          begin
            Result := ReadBool('COM' + IntToStr(iComPortNo));
          end
        else RegAccessError('HKEY_LOCAL_MACHINE\Software\Exchequer\ComPorts\' + sApplication, 'read',3);
      finally
        CloseKey;
        Free;
      end;{try}
    end;{with}
  end;{if}
end;

Function ComPortInUseReg(iComPortNo : integer) : boolean;
{Checks in the registry against all applications, to see if the defined Com Port is said to be in use}
var
  slApplications : TStringList;
  iApp : integer;
begin
  Result := FALSE;
  if (iComPortNo > 0) and (iComPortNo <= MaxNoOfComPorts) then begin
    with TRegistry.create do begin
      try
        slApplications := TStringList.Create;
        Access := KEY_READ;
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('Software\Exchequer\ComPorts\', FALSE) then
          begin
            GetKeyNames(slApplications);
            For iApp := 0 to slApplications.Count -1 do begin
              with TRegistry.create do begin
                try
                  Access := KEY_READ;
                  RootKey := HKEY_LOCAL_MACHINE;
                  if OpenKey('Software\Exchequer\ComPorts\' + slApplications[iApp], FALSE) then
                    begin
                      if ReadBool('COM' + IntToStr(iComPortNo)) then begin
                        Result := TRUE;
                        Break;
                      end;{if}
                    end
                  else RegAccessError('HKEY_LOCAL_MACHINE\Software\Exchequer\ComPorts\' + slApplications[iApp], 'read',4);
                finally
                  CloseKey;
                  Free;
                end;{try}
              end;{with}
            end;{for}
          end
        else RegAccessError('HKEY_LOCAL_MACHINE\Software\Exchequer\ComPorts\', 'read',5);
      finally
        slApplications.Free;
        CloseKey;
        Free;
      end;{try}
    end;{with}
  end;{if}
end;


end.
