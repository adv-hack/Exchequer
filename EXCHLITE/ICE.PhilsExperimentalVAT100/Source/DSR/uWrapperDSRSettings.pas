Unit uWrapperDSRSettings;

Interface

Uses Windows, Sysutils, ucommon, uConsts, uxmlbaseclass, WinSvc;

Procedure _ChangeWrapperSettings(pDSRPort: Integer);
Function _GetTaskPAth(Const pMachine, pService: String): String;
function QueryServiceConfig(Server: String; ServiceName: string; out MemToFree: integer): PQueryServiceConfig;

Implementation

Uses MSXML2_TLB;


function QueryServiceConfig(Server: String; ServiceName: string; out MemToFree: integer): PQueryServiceConfig;
var
  ServiceConfig: PQueryServiceConfig;
  R: DWORD;
  SCH   : SC_HANDLE;
  SvcSCH: SC_HANDLE;
begin
  Result    := nil;
  MemToFree := 0;
  try
    SCH := OpenSCManager(PChar(Server), nil, SC_MANAGER_ALL_ACCESS);
    try
      if SCH = 0 then
        Exit;

      SvcSCH := OpenService(SCH, PChar(ServiceName), SERVICE_ALL_ACCESS);
      if SvcSCH = 0 then
        Exit;

      try
        WinSvc.QueryServiceConfig(SvcSCH, nil, 0, R); // Get Buffer Length
        GetMem(ServiceConfig, R + 1);
        MemToFree := R + 1;
        try
          if not WinSvc.QueryServiceConfig(SvcSCH, ServiceConfig, R + 1, R) then // Get Buffer Length
            Exit;
          Result := ServiceConfig;
        finally
        end;
      finally
        CloseServiceHandle(SvcSCH);
      end;
    finally
      CloseServiceHandle(SCH);
    end;
  finally
  end;
end;

Function _GetTaskPAth(Const pMachine, pService: String): String;
Var
  ServiceConfig: PQueryServiceConfig;
  iMemToFree: integer;
Begin
  Try
    ServiceConfig := QueryServiceConfig(pMachine, pService, iMemToFree);
    if ServiceConfig <> nil then
    begin
      Result := ExtractFilePath(ServiceConfig.lpBinaryPathName);
      Result := StringReplace(result, '''', '', [rfReplaceAll]);
      Result := StringReplace(result, '"', '', [rfReplaceAll]); 
      FreeMem(ServiceConfig, iMemToFree);
    end;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _ChangeWrapperSettings
  Author:    vmoura

  apply the changes for the xml port number...
-----------------------------------------------------------------------------}
Procedure _ChangeWrapperSettings(pDSRPort: Integer);
Var
  lPath: String;
  lXml: TXMLDoc;
  lNode: IXMLDOMNode;
  lPort: Integer;
Begin
  If pDSRPort > 0 Then
  Begin
    {get wrapper path}
    lPath := _GetTaskPAth('', cDSRSERVICE);

    {if path is ok, load its conf file}
    If lPath <> '' Then
      if fileExists(lPath + cWRAPPEREXE + '.config') then
      Begin
        lXml := TXMLDoc.Create;
        lXml.Load(lPath + cWRAPPEREXE + '.config');

        If lXml.Doc.xml <> '' Then
        Begin
          lNode := _GetNodeByName(lXml.Doc, 'add');
          If lNode <> Nil Then
          try
            lPort := 0;
            try
              lPort := lNode.attributes.GetNamedItem('value').nodeValue;
            except
            end;

            If (lPort <> 0) and (lPort <> pDSRPort) Then
            Begin
              lNode.attributes.GetNamedItem('value').nodeValue := pDSRPort;

              lXml.ApplyEncondeEx(lXml.Doc.xml, 'utf-8');
              lXml.Save(lPath + cWRAPPEREXE + '.config');
            End; {if lPort <> pDSRPort then}
          except
            on E:exception do
              _LogMSG('_ChangeWrapperSettings :- Error loading Service parameters. Error: ' + e.Message);
          End; {if lNode <> nil then}
        End; {if lXml.Doc.xml <> '' then}

        lXml.Free;
      End; {if FileExists(lPath + cWRAPPEREXE + '.config') then}
  End; {if pConf <> nil then}
End;

End.

