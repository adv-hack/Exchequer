unit CheckForPlugIns;

interface

Uses Classes, Forms, SysUtils, IniFiles, Dialogs, GmXML;

Type
  TPlugInDetail = Class(TObject)
  Private
    FPlugInFilename : ShortString;
    FPlugInName : ShortString;
    FPlugInDesc : ShortString;
    FPlugInInstaller : ShortString;
  Public
    Property pdFilename : ShortString Read FPlugInFilename;
    Property pdName : ShortString Read FPlugInName;
    Property pdDescription : ShortString Read FPlugInDesc;
    Property pdInstallerPath : ShortString Read FPlugInInstaller;

    Constructor Create(Const PlugInFilename, PlugInName, PlugInDesc, PlugInInstaller : ShortString);
  End; // TPlugInDetail

  //------------------------------

  TCheckForPlugIns = Class(TObject)
  Private
    FExchequerDirectory : ShortString;
    FPlugIns : TStringList;
    FXML : TGmXML;

    Function GetPlugInCount : Integer;
    Function GetPlugIn(Index : Integer) : TPlugInDetail;
    Procedure SetExchequerDirectory (Value : ShortString);

    Procedure ScanForPlugIns;
    Procedure ProcessExchequerPlugIn(Const PlugInName : ShortString);
    Procedure ProcessTradeCounterPlugIn(Const PlugInCOMName : ShortString);
    Procedure AddPlugIn (Const PlugInFilename, PlugInName, PlugInDesc, PlugInInstaller : ShortString);
  Public
    Property cpExchequerDirectory : ShortString Read FExchequerDirectory Write SetExchequerDirectory;
    Property cpPlugInCount : Integer Read GetPlugInCount;
    Property cpPlugIn[Index : Integer] : TPlugInDetail Read GetPlugIn;

    Constructor Create;
    Destructor Destroy; Override;
  End; // TCheckForPlugIns

implementation

//=========================================================================

Constructor TPlugInDetail.Create(Const PlugInFilename, PlugInName, PlugInDesc, PlugInInstaller : ShortString);
Begin // Create
  Inherited Create;

  FPlugInFilename := PlugInFilename;
  FPlugInName := PlugInName;
  FPlugInDesc := PlugInDesc;
  FPlugInInstaller := PlugInInstaller;
End; // Create

//=========================================================================

Constructor TCheckForPlugIns.Create;
Begin // Create
  Inherited Create;

  gmXMLAllowAttributeSpaces := True;
  FXML := TGmXML.Create(NIL);
  FXML.LoadFromFile(ExtractFilePath(Application.ExeName) + 'PlugIns.Xml');

  FPlugIns := TStringList.Create;
  FPlugIns.Sorted := True;
End; // Create

//------------------------------

Destructor TCheckForPlugIns.Destroy;
Begin // Destroy
  FreeAndNIL(FXML);

  While (FPlugIns.Count > 0) Do
  Begin
    TPlugInDetail(FPlugIns.Objects[0]).Free;
    FPlugIns.Delete(0);
  End; // While (FPlugIns.Count > 0)
  FreeAndNIL(FPlugIns);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TCheckForPlugIns.GetPlugInCount : Integer;
Begin // GetPlugInCount
  Result := FPlugIns.Count;
End; // GetPlugInCount

//------------------------------

Function TCheckForPlugIns.GetPlugIn(Index : Integer) : TPlugInDetail;
Begin // GetPlugIn
  If (Index < FPlugIns.Count) Then
    Result := TPlugInDetail(FPlugIns.Objects[Index])
  Else
    Raise Exception.Create ('TCheckForPlugIns.GetPlugIn: Invalid Index (' + IntToStr(Index) + ')');
End; // GetPlugIn

//------------------------------

Procedure TCheckForPlugIns.SetExchequerDirectory (Value : ShortString);
Begin // SetExchequerDirectory
  If (Value <> FExchequerDirectory) Then
  Begin
    FExchequerDirectory := IncludeTrailingPathDelimiter(Value);
    ScanForPlugIns;
  End; // If (Value <> FExchequerDirectory)
End; // SetExchequerDirectory

//-------------------------------------------------------------------------

Procedure TCheckForPlugIns.ScanForPlugIns;
Var
  oIni : TIniFile;
  sPlugIn : ShortString;
  ComCounter : SmallInt;
Begin // ScanForPlugIns
  If FileExists(FExchequerDirectory + 'EntCustm.Ini') Then
  Begin
    oIni := TIniFile.Create(FExchequerDirectory + 'EntCustm.Ini');
    Try
      // Check for DLL Plug-Ins
      sPlugIn := oIni.ReadString('HookChain', 'EntCustm', '');
      While (sPlugIn <> '') Do
      Begin
        ProcessExchequerPlugIn(sPlugIn + '.Dll');
        sPlugIn := oIni.ReadString('HookChain', sPlugIn, '');
      End; // While (sDLLPlugIn <> '')

      // Check for COM Plug-Ins
      ComCounter := 1;
      Repeat
        sPlugIn := oIni.ReadString ('COMClients', IntToStr(ComCounter), '');
        If (sPlugIn <> '') Then
        Begin
          ProcessExchequerPlugIn(ExtractfileName(sPlugIn));
        End; // If (sPlugIn <> '')
        Inc(ComCounter);
      Until (sPlugIn = '');
    Finally
      oIni.Free;
    End; // Try..Finally
  End; // If FileExists(FExchequerDirectory + 'EntCustm.Ini')

  If FileExists(FExchequerDirectory + 'Trade\TCCustom.Ini') Then
  Begin
    oIni := TIniFile.Create(FExchequerDirectory + 'Trade\TCCustom.Ini');
    Try
      // Check for COM Plug-Ins
      ComCounter := 1;
      Repeat
        sPlugIn := oIni.ReadString ('PlugIns', IntToStr(ComCounter), '');
        If (sPlugIn <> '') Then
        Begin
          ProcessTradeCounterPlugIn(sPlugIn);
        End; // If (sPlugIn <> '')
        Inc(ComCounter);
      Until (sPlugIn = '');
    Finally
      oIni.Free;
    End; // Try..Finally
  End; // If FileExists(FExchequerDirectory + 'Trade\TCCustom.Ini')
End; // ScanForPlugIns

//-------------------------------------------------------------------------

Procedure TCheckForPlugIns.ProcessExchequerPlugIn(Const PlugInName : ShortString);
Var
  oExchPlugIns, oPlugIn : TGmXMLNode;
  oIgnoreAttr : TGmXmlAttribute;
  sPlugInName, sNodeName : ShortString;
  Found : Boolean;
  I : SmallInt;
Begin // ProcessExchequerPlugIn
  sPlugInName := Trim(UpperCase(PlugInName));

  oExchPlugIns := FXML.Nodes.NodeByName['ExchequerPlugIns'];
  If Assigned(oExchPlugIns) Then
  Begin
    Found := False;

    For I := 0 To (oExchPlugIns.Children.Count - 1) Do
    Begin
      oPlugIn := oExchPlugIns.Children.Node[I];
      sNodeName := Trim(UpperCase(oPlugIn.Attributes.ElementByName['FileName'].Value));
      If (sNodeName = sPlugInName) Then
      Begin
        // Check for ignore flag - needed for plug-ins installed by the upgrade program
        oIgnoreAttr := oPlugIn.Attributes.ElementByName['Ignore'];
        If (Not Assigned(oIgnoreAttr)) Then
        Begin
          AddPlugIn (sNodeName,
                     oPlugIn.Attributes.ElementByName['Name'].Value,
                     oPlugIn.Attributes.ElementByName['Description'].Value,
                     oPlugIn.Attributes.ElementByName['Installer'].Value);
        End; // If (Not Assigned(oIgnoreAttr))
        Found := True;
      End; // If (sNodeName = sPlugInName)
    End; // For I

    If (Not Found) Then
    Begin
      AddPlugIn (PlugInName,
                 'Unknown Plug-In (' + PlugInName + ')',
                 'Please contact the author of this plug-in regarding compatibility with your version of Exchequer',
                 '');
    End; // If (Not Found)
  End // If Assigned(oExchPlugIns)
  Else
    Raise Exception.Create ('TCheckForPlugIns.ProcessExchequerPlugIn: ExchequerPlugIns Node not found in XML');
End; // ProcessExchequerPlugIn

//-------------------------------------------------------------------------

Procedure TCheckForPlugIns.ProcessTradeCounterPlugIn(Const PlugInCOMName : ShortString);
Var
  oTCPlugIns, oPlugIn : TGmXMLNode;
  sPlugInCOMName, sNodeName : ShortString;
  Found : Boolean;
  I : SmallInt;
Begin // ProcessTradeCounterPlugIn
  sPlugInCOMName := Trim(UpperCase(PlugInCOMName));

  oTCPlugIns := FXML.Nodes.NodeByName['TradeCounterPlugIns'];
  If Assigned(oTCPlugIns) Then
  Begin
    Found := False;

    For I := 0 To (oTCPlugIns.Children.Count - 1) Do
    Begin
      oPlugIn := oTCPlugIns.Children.Node[I];
      sNodeName := Trim(UpperCase(oPlugIn.Attributes.ElementByName['COMName'].Value));
      If (sNodeName = sPlugInCOMName) Then
      Begin
        AddPlugIn (sNodeName,
                   oPlugIn.Attributes.ElementByName['Name'].Value,
                   oPlugIn.Attributes.ElementByName['Description'].Value,
                   oPlugIn.Attributes.ElementByName['Installer'].Value);
        Found := True;
      End; // If (sNodeName = sPlugInCOMName)
    End; // For I

    If (Not Found) Then
    Begin
      AddPlugIn (PlugInCOMName,
                 'Unknown Trade Counter Plug-In (' + PlugInCOMName + ')',
                 'Please contact the author of this plug-in regarding compatibility with your version of Exchequer',
                  '');
    End; // If (Not Found)
  End // If Assigned(oTCPlugIns)
  Else
    Raise Exception.Create ('TCheckForPlugIns.ProcessTradeCounterPlugIn: TradeCounterPlugIns Node not found in XML');
End; // ProcessTradeCounterPlugIn

//-------------------------------------------------------------------------

Procedure TCheckForPlugIns.AddPlugIn (Const PlugInFilename, PlugInName, PlugInDesc, PlugInInstaller : ShortString);
Var
  oPlugIn : TPlugInDetail;
Begin // AddPlugIn
  // Don't list duplicates
  If (FPlugIns.IndexOf(PluginName) = -1) Then
  Begin
    oPlugIn := TPlugInDetail.Create(PlugInFilename, PlugInName, PlugInDesc, PlugInInstaller);
    FPlugIns.AddObject (PlugInName, oPlugIn);
  End; // If (FPlugIns.IndexOf(PluginName) > -1)
End; // AddPlugIn

//-------------------------------------------------------------------------

end.
