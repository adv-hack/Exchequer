{-----------------------------------------------------------------------------
 Unit Name: uSystemConfig
 Author:    vmoura
 Purpose:
 History:

         manage DSR and e-mail Settings
-----------------------------------------------------------------------------}
Unit uSystemConfig;

Interface

Uses
  Classes, SysUtils, strUtils, IniFiles, Variants,

  uConsts

  ;

{to be used externaly to read and write DSR properties}
Const
  cDSRSETTINGS = '<?xml version="1.0"?> ' +
    '<dsrsettings>  ' +
    '  <dbserver></dbserver> ' +
    '  <instance></instance> ' +
    '  <schedule> ' +
    '    <time></time> ' +
    '    <frequency></frequency> ' +
    '    <every></every> ' +
    '  </schedule> ' +
    '  <dripfeed></dripfeed> ' +
//    '  <companyname></companyname> ' +
    '  <usecis></usecis> ' +
    '</dsrsettings> ';

Type
  TSystemConf = Class
  Private
    fIniFile: String;

    Function GetInboxDir: String;
    Function GetOutboxDir: String;

    Function GetXMLDir: String;
    Function GetXSDDir: String;
    Function GetXSLDir: String;
    Function GetTempDir: String;
    Function GetPluginsDir: String;
    Function GetDbServer: String;
    Procedure SetDbServer(Const Value: String);

    Function GetSchTime: TDateTime;
    Procedure SetSchEvery(Const Value: Integer);
    Procedure SetSchFrequency(Const Value: Integer);
    Procedure SetSchTime(Const Value: TDateTime);
    Function GetSchFrequency: Integer;
    Function GetSchEvery: Integer;
    Function GetIniFile: String;
    Function GetAutomaticDripFeed: Boolean;
    Procedure SetAutomaticDripFeed(Const Value: Boolean);
//    Function GetCompanyName: String;
//    Procedure SetCompanyName(Const Value: String);
    Function GetUseCISSubsystem: Boolean;
    function GetEmailSystemDir: String;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function TranslateDSRSettingstoXml: Widestring;
    Function TranslateXmltoDSRSettings(Const pXml: WideString): Boolean;
  Published
    Property InboxDir: String Read GetInboxDir;
    Property OutboxDir: String Read GetOutboxDir;

    Property XMLDir: String Read GetXMLDir;
    Property XSLDir: String Read GetXSLDir;
    Property XSDDir: String Read GetXSDDir;
    Property PluginsDir: String Read GetPluginsDir;
    Property TempDir: String Read GetTempDir;
    property EmailSystemDir: String read GetEmailSystemDir;
    Property DBServer: String Read GetDbServer Write SetDbServer;

    Property IniFileName: String Read GetIniFile Write fIniFile;
    Property AutomaticDripFeed: Boolean Read GetAutomaticDripFeed Write
      SetAutomaticDripFeed;
//    Property CompanyName: String Read GetCompanyName Write SetCompanyName;
    Property UseCISSubsystem: Boolean Read GetUseCISSubsystem;
  End;

Implementation

Uses uXMLBaseClass, MSXML2_TLB, uCommon, uCrypto;

{ TSystemConf }

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TSystemConf.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetIniFile
  Author:    vmoura

  to set a temp file when necessary
-----------------------------------------------------------------------------}
Function TSystemConf.GetIniFile: String;
Begin
  If fIniFile = '' Then
    Result := cDSRINI
  Else
    Result := fIniFile;
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetInboxDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cINBOXDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetOutboxDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cOUTBOXDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetXMLDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetXMLDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cXMLDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetXSDDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetXSDDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cXSDDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetXSLDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetXSLDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cXSLDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetEmailSystemDir
  Author:    vmoura
-----------------------------------------------------------------------------}
function TSystemConf.GetEmailSystemDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cEMAILSYSTEMDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
end;


{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TSystemConf.Create;
Begin
  Inherited Create;
  fIniFile := '';
End;

{-----------------------------------------------------------------------------
  Procedure: GetTempDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetTempDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cTEMPDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetPluginsDir
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetPluginsDir: String;
Var
  lAux: String;
Begin
  lAux := _GetApplicationPath + cPLUGINSDIR;
  Result := IfThen(lAux <> '', IncludeTrailingPathDelimiter(lAux), '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetDbServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetDbServer: String;
Var
  lIni: TInifile;
Begin
  //lIni := TInifile.Create(_GetApplicationPath + cDSRINI);
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  Result := lIni.ReadString('database', 'dbserver', '');
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: GetSchTime
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetSchTime: TDateTime;
Const
  cDEFAULTTIME = '18:00:00';
Var
  lIni: TInifile;
Begin
  //lIni := TInifile.Create(_GetApplicationPath + cDSRINI);
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  RESULT := lIni.ReadTime('schedule', 'time', StrToTime(cDEFAULTTIME));
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: GetSchFrequency
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetSchFrequency: Integer;
Const
  cALLDAYS = 0;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  Result := lIni.Readinteger('schedule', 'frequency', cALLDAYS);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: GetSchEvery
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetSchEvery: Integer;
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  Result := lIni.ReadInteger('schedule', 'every', 0);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: SetSchEvery
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSystemConf.SetSchEvery(Const Value: Integer);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  If Value < 0 Then
    lIni.WriteInteger('schedule', 'every', 0)
  Else
    lIni.WriteInteger('schedule', 'every', Value);

  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: SetSchFrequency
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSystemConf.SetSchFrequency(Const Value: Integer);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  If Value < 0 Then
    lIni.writeinteger('schedule', 'frequency', 0)
  Else
    lIni.writeinteger('schedule', 'frequency', Value);

  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: SetSchTime
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSystemConf.SetSchTime(Const Value: TDateTime);
Const
  cDEFAULTTIME = '18:00:00';
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  Try
    lIni.WriteTime('schedule', 'time', Value);
  Except
    lIni.WriteTime('schedule', 'time', StrToTime(cDEFAULTTIME));
  End;

  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: SetDbServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSystemConf.SetDbServer(Const Value: String);
Var
  lIni: TInifile;
Begin
  lIni := TInifile.Create(_GetApplicationPath + IniFileName);
  lIni.WriteString('database', 'dbserver', Value);
  FreeAndNil(lINi);
End;

{-----------------------------------------------------------------------------
  Procedure: GetAutomaticDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetAutomaticDripFeed: Boolean;
Var
  lIni: TIniFile;
Begin
  lIni := TiniFile.Create(_GetApplicationPath + IniFileName);
  Result := lIni.ReadBool('dripfeed', 'active', False);
  FreeAndNil(lIni);
End;

{-----------------------------------------------------------------------------
  Procedure: SetAutomaticDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSystemConf.SetAutomaticDripFeed(Const Value: Boolean);
Var
  lIni: TIniFile;
Begin
  lIni := TiniFile.Create(_GetApplicationPath + IniFileName);
  lIni.WriteBool('dripfeed', 'active', Value);
  FreeAndNil(lIni);
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyName
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Function TSystemConf.GetCompanyName: String;
Var
  lIni: TIniFile;
Begin
  lIni := TiniFile.Create(_GetApplicationPath + IniFileName);
  Result := lIni.ReadString('company', 'name', '');
  FreeAndNil(lIni);
End;*)

{-----------------------------------------------------------------------------
  Procedure: SetCompanyName
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Procedure TSystemConf.SetCompanyName(Const Value: String);
Var
  lIni: TIniFile;
Begin
  lIni := TiniFile.Create(_GetApplicationPath + IniFileName);
  lIni.WriteString('company', 'name', value);
  FreeAndNil(lIni);
End;*)

{-----------------------------------------------------------------------------
  Procedure: GetUseCISSubsystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.GetUseCISSubsystem: Boolean;
Begin
  Result := FileExists(_GetApplicationPath + cCISINI);
End;

{-----------------------------------------------------------------------------
  Procedure: TranslateDSRSettingstoXml
  Author:    vmoura

  translate the .ini file to a XMl
  the ideia is to give this file to dashboard and change the settings when necessary
-----------------------------------------------------------------------------}
Function TSystemConf.TranslateDSRSettingstoXml: Widestring;
Var
  lDoc: TXMLDoc;
  lNode: IXMLDomNode;
  lPos: Integer;
Begin
  Result := '';
  Try
    lDoc := TXMLDoc.Create;
    lDoc.LoadXml(cDSRSETTINGS);
  {check the xml}
    If lDoc.Doc.xml <> '' Then
    Begin
    {get the first "valid" node}
      lNode := _GetNodeByName(lDoc.Doc, 'dsrsettings');
      If lNode <> Nil Then
      Begin
        lPos := Pos('\', Self.DBServer);

        _SetNodeValueByName(lNode, 'dbserver', Copy(Self.DBServer, 1, lPos -1));
        _SetNodeValueByName(lNode, 'instance', Copy(Self.DBServer, lPos + 1, length(Self.DBServer) - lPos));

        _SetNodeValueByName(lNode, 'dripfeed', Self.AutomaticDripFeed);
//        _SetNodeValueByName(lNode, 'companyname', Self.CompanyName);
        _SetNodeValueByName(lNode, 'usecis', Self.UseCISSubsystem);


        Result := lDoc.Doc.xml;
      End; {if lNode <> nil then}
    End; {if lDoc.Doc.xml <> '' then}
  Finally
    If Assigned(lDoc) Then
      FreeAndNil(lDoc);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: TranslateXmltoDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSystemConf.TranslateXmltoDSRSettings(Const pXml: WideString): Boolean;
Var
  lDoc: TXMLDoc;
  lNode: IXMLDomNode;
Begin
  Result := True;
  Try
    lDoc := TXMLDoc.Create;
    lDoc.LoadXml(pXml);
    {check the xml}
    If lDoc.Doc.xml <> '' Then
    Begin
      {get the first "valid" node}
      lNode := _GetNodeByName(lDoc.Doc, 'dsrsettings');
      If lNode <> Nil Then
      Begin
        Self.DBServer := _GetNodeValue(lNode, 'dbserver') + '\' + _GetNodeValue(lNode, 'instance');
        Try
          Self.AutomaticDripFeed := _GetNodeValue(lNode, 'dripfeed');
//          Self.CompanyName := _GetNodeValue(lNode, 'companyname');
        Except
          On e: exception Do
            _LogMSG('TSystemConf.TranslateXmltoDSRSettings :- Error setting DSR values. Error: '
              + e.message);
        End;
      End; {if lNode <> nil then}
    End; {if lDoc.Doc.xml <> '' then}
  Except
    On e: exception Do
    Begin
      _LogMSG('Error assigning XML values to DSR Settings. Error: ' + e.message);
      Result := False;
    End; {begin}
  End; {try}

  If Assigned(lDoc) Then
    FreeAndNil(lDoc);
End;

End.

