unit KPIAvailablePluginsU;

interface

uses Classes, SysUtils, IKPIHost_TLB, Windows;

type
  //
  TKPIPluginInfo = class(TObject)
  private
    // The name of the COM Object from the IDP file
    FObjectName : ShortString;
    // The full path of the IDP file wwhich may contain additional configuration information
    FInfoFile : ShortString;
    // The Id Code of the Data Plug-In
    FPluginId : ShortString;
    // The Id Code of the Authentication Plug-In used by the Data Plug-In
    FAuthenticationId : ShortString;
    // The Caption of the plug-in, for display to the user
    FCaption: ShortString;
    // The display type (Data List, Chart, etc.)
    FDisplayType : EnumDataPluginDisplayType;
    // Is the plug-in active (i.e. should it be displayed?)
    FActive: Boolean;
    FSupportsConfiguration: Boolean;
    // The plug-in's unique id
    FMessageID: integer; // v.004 BJH
    // Should the plug-in be included in the list of available plugins?
    FIsAvailable: Boolean;
  public
    property dpInfoFile: ShortString read FInfoFile;
    property dpActive: Boolean read FActive write FActive;
    property dpPluginId : ShortString Read FPluginId;
    property dpCaption: ShortString read FCaption write FCaption; // v20 made it writeable
    property dpAuthenticationId : ShortString Read FAuthenticationId;
    property dpDisplayType : EnumDataPluginDisplayType Read FDisplayType;
    property dpSupportsConfiguration: Boolean read FSupportsConfiguration write FSupportsConfiguration;
    property dpIsAvailable: Boolean read FIsAvailable;

    constructor Create;
    destructor Destroy; Override;

    // Creates and returns an instance of the Plug-In
    function CreateInstance(AMessageID: integer) : IDataPlugin;

    // Loads and validates the configuration information for the plug-in, creates a temporary
    // instance of the plug-in in order to extract some of the information
    function Initialise (InfoFile : ShortString) : Boolean;
  end; // TKPIPluginInfo

  //------------------------------

  TKPIAvailablePlugins = Class(TObject)
  Private
    FPlugins : TStringList;

    Function GetCount : SmallInt;
    Function GetPluginByName (Index : ShortString) : TKPIPluginInfo;
    Function GetPluginByIndex (Index : SmallInt) : TKPIPluginInfo;
  Public
    Property Count : SmallInt Read GetCount;
    Property PluginsByName [Index : ShortString] : TKPIPluginInfo Read GetPluginByName;
    Property PluginsByIndex [Index : SmallInt] : TKPIPluginInfo Read GetPluginByIndex;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure Add (Const InfoFile : ShortString);
    procedure Clear;
  End; // TKPIAvailablePlugins

implementation

Uses Dialogs, IniFiles, ComObj, APIUtil, KPICOMUtils, History;

// =============================================================================
// TKPIPluginInfo
// =============================================================================

Constructor TKPIPluginInfo.Create;
Begin // Create
  Inherited Create;
End; // Create

// -----------------------------------------------------------------------------

Function TKPIPluginInfo.Initialise (InfoFile : ShortString) : Boolean;
Var
  oIDP : IDataPlugin;
  COMServerResult: TCOMServerErrorType;
  COMFileName: string;
  Format: string;
  Path: string;
Begin // Initialise
  Result := False;
  Try
    // Create an instance of the Data Plug-In to extract information
    With TIniFile.Create(InfoFile) Do
    Begin
      Try
        Path := IncludeTrailingPathDelimiter(ExtractFilePath(InfoFile));
        If SectionExists('COMObj') Then
        Begin
          FObjectName := ReadString('COMObj', 'NAME', '');
          COMFileName := ReadString('COMObj', 'FILENAME', '');
          Format      := Uppercase(ReadString('COMObj', 'FORMAT', 'WIN32'));
          FInfoFile   := InfoFile;

          { Is the plug-in registered? }
          COMServerResult := CheckCOMServer(FObjectName);
          if (COMServerResult <> cseOK) then
          begin
            { Not properly registered. Try to register it now, unless we are
              running under Windows Vista or later (when it won't be possible
              because of security restrictions, and the plug-ins have to be
              registered via an installation program).

              CJS - ABSEXCH-13896 - Modified to exclude versions from Vista
              onwards (rather than just Vista). }
            if GetWindowsVersion < wvVista then
            begin
              try
                if (Pos('.exe', Lowercase(COMFileName)) <> 0) then
                  { Exe, so call it with the regserver switch to register it. }
                  RunApp(Path + COMFileName + ' /regserver', True)
                else
                begin
                  { DLL, so register using the standard Windows procedure. }
                  if (Format = '.NET') then
                    RegisterAssembly(Path + COMFileName)
                  else
                    RegisterComServer(Path + COMFileName);
                end;
                { Check again. }
                COMServerResult := CheckCOMServer(FObjectName);
                { Still not registered. Report the problem and quit. }
                if (COMServerResult <> cseOK) then
                begin
                  MessageDlg('Unable to register Plugin: ' + COMServerErrors[COMServerResult],
                             mtError, [mbOk], 0);
                  Exit;
                end;
              except
                on E:Exception do
                begin
                  MessageDlg('Unable to register Plugin: ' + E.Message,
                             mtError, [mbOk], 0);
                  Exit;
                end;
              end;
            end
            else
            begin
              MessageDlg('Plugin ' + FObjectName + ' not registered',
                         mtError, [mbOk], 0);
              Exit;
            end;
          end;

          { Create the plug-in and extract the details. }
          oIDP := CreateInstance(FMessageID); // v.004 BJH
          if oIDP <> nil then
          Try
            // Copy the details out of the COM Object
            FPluginId := oIDP.dpPluginId;
            FCaption  := oIDP.dpCaption;
            FAuthenticationId := oIDP.dpAuthenticationId;
            FDisplayType := oIDP.dpDisplayType;
            FSupportsConfiguration := oIDP.dpSupportsConfiguration;
            FIsAvailable := (oIDP.dpStatus <> psNotAvailable);
//            FConfiguration := oIDP.dpConfiguration;

            Result := True;
          Finally
            oIDP := NIL;
          End; // Try..Finally
        End; // If SectionExists('COMObj')
      Finally
        Free;
      End; // Try..Finally
    End; // With TIniFile.Create(FOCXDirectory + IAPFileName)
  Except
    Result := False;
  End; // Try..Except
End; // Initialise

// -----------------------------------------------------------------------------

destructor TKPIPluginInfo.Destroy;
begin // Destroy

  inherited Destroy;                                              
end; // Destroy

// -----------------------------------------------------------------------------

// Returns an initialised instance of the Data Plug-In
function TKPIPluginInfo.CreateInstance(AMessageID: integer) : IDataPlugin; // v.004 BJH
var
  KPIHostPath: array[0..MAX_PATH] of char; // v.005 BJH
begin // CreateInstance
  try
    Result := CreateOLEObject(FObjectName) As IDataPlugin;
    // Call the configuration method to allow any custom settings to be read from the IDP
    // file - allows one COM Object to have multiple personalities, e.g. Customer Balances
    // or Supplier Balances.
    result.dpHostVersion := KPIVer;
    GetModuleFileName(hInstance, KPIHostPath, SizeOf(KPIHostPath)); // v.005 BJH
    result.dpHostPath    := KPIHostPath;                    // v.005 BJH
    FMessageID := AMessageID;         // v.004 BJH - must send message id before CheckIDPFile
    result.dpMessageID := AMessageID; // ExchOut uses MessageID and IDPFile to identify a plugin instance
    Result.CheckIDPFile(FInfoFile);
  except
    on E:Exception do
    begin
      Result := nil;
      ShowMessage(FObjectName + ': ' + E.Message);
      Exit;
    end;
  end;
end; // CreateInstance

// =============================================================================
// TKPIAvailablePlugins
// =============================================================================

procedure TKPIAvailablePlugins.Clear;
begin
  // Remove the Plug-Ins from the list
  While (FPlugins.Count > 0) Do
  Begin
    TKPIPluginInfo(FPlugins.Objects[0]).Free;
    FPlugins.Delete(0);
  End; // While (FPlugins.Count > 0)
end;

// -----------------------------------------------------------------------------

Constructor TKPIAvailablePlugins.Create;
Begin // Create
  Inherited Create;

  FPlugins := TStringList.Create;
End; // Create

// -----------------------------------------------------------------------------

Destructor TKPIAvailablePlugins.Destroy;
Begin // Destroy
  Clear;

  // Destroy the list
  FreeAndNIL(FPlugins);

  Inherited Destroy;
End; // Destroy

// -----------------------------------------------------------------------------

Function TKPIAvailablePlugins.GetCount : SmallInt;
Begin // GetCount
  Result := FPlugins.Count;
End; // GetCount

// -----------------------------------------------------------------------------

Function TKPIAvailablePlugins.GetPluginByIndex (Index : SmallInt) : TKPIPluginInfo;
Begin // GetPluginByIndex
  If (Index >= 0) And (Index < FPlugins.Count) Then
    Result := TKPIPluginInfo(FPlugins.Objects[Index])
  Else
    Raise Exception.Create ('TKPIAvailablePlugins.GetPluginByIndex - Invalid Data Plug-In Index (' + IntToStr(Index) + ')');
End; // GetPluginByIndex

// -----------------------------------------------------------------------------

Function TKPIAvailablePlugins.GetPluginByName (Index : ShortString) : TKPIPluginInfo;
Var
  Idx : SmallInt;
Begin // GetPluginByName
  Idx := FPlugins.IndexOf(Index);
  If (Idx >= 0) Then
    Result := GetPluginByIndex (Idx)
  Else
    Result := NIL;
End; // GetPluginByName

// -----------------------------------------------------------------------------

Procedure TKPIAvailablePlugins.Add (Const InfoFile : ShortString);
Var
  oPluginInfo : TKPIPluginInfo;
Begin // Add
  // Create an Plug-In Info wrapper and add it into the list using the Plugin code as an index string
  oPluginInfo := TKPIPluginInfo.Create;
  If oPluginInfo.Initialise(InfoFile) Then
    FPlugins.AddObject (oPluginInfo.dpPluginId, oPluginInfo);
End; // Add

// -----------------------------------------------------------------------------

end.
