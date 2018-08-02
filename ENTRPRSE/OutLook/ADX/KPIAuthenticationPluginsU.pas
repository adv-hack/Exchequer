unit KPIAuthenticationPluginsU;

interface

uses Classes, SysUtils, Windows, IKPIHost_TLB;

type
  TKPIAuthenticationPluginInfo = Class(TObject)
  private
    // The name of the COM Object from the IAP file
    FObjectName : ShortString;
    // The full path of the IAP file wwhich may contain additional configuration information
    FConfigFile : ShortString;
    // The Id Code of the Authentication Plug-In
    FAuthenticationId : ShortString;
    // The Authentication State Data built up during this instance of the host containing login details
    FAuthenticationState : WideString;
    // Internal instance of the plug-in
    FPlugin : IAuthenticationPlugin;

    // Loads and validates the configuration information for the plug-in, creates a temporary
    // instance of the plug-in in order to extract some of the information
    function Initialise (ConfigFile : ShortString) : Boolean;
  public
    property apAuthenticationId : ShortString read FAuthenticationId;
    property apAuthenticationState: WideString read FAuthenticationState;

    // Creates/Destroys the internal instance of the Authentication Plug-In
    function CreatePlugin : Byte;
    procedure DestroyPlugin(const CreateStatus : Byte);

    // Maps onto IAuthenticationPlugin.CheckLogin, returns TRUE if the Authentication State data
    // contains a successful login.  The IPlugin.dpAuthenticationRequest property should be passed
    // in as the AuthData parameter and if the login is successful then the returned value should
    // be passed into the IPlugin.Authenticate method.
    function CheckLogin(var AuthData: WideString) : Boolean;

    // Maps onto IAuthenticationPlugin.Login, returns TRUE if a successful login was done.  The
    // IPlugin.dpAuthenticationRequest property should be passed in as the AuthData parameter and
    // if the login is successful then the returned value should be passed into the IPlugin.Authenticate
    // method.
    function Login (var AuthData: WideString; Const HostHandle : HWND) : Boolean;
  end; // TKPIAuthenticationPluginInfo

  TKPIAuthenticationPlugins = class(TObject)
  private
    FPlugins : TStringList;

    Function GetCount : SmallInt;
    Function GetPluginByName (Index : ShortString) : TKPIAuthenticationPluginInfo;
    Function GetPluginByIndex (Index : SmallInt) : TKPIAuthenticationPluginInfo;
  public
    Property Count : SmallInt Read GetCount;
    Property PluginsByName [Index : ShortString] : TKPIAuthenticationPluginInfo Read GetPluginByName;
    Property PluginsByIndex [Index : SmallInt] : TKPIAuthenticationPluginInfo Read GetPluginByIndex;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure Add (Const ConfigFile : ShortString);
    procedure Clear;
  end;

implementation

uses Dialogs, IniFiles, ComObj;

// =============================================================================
// TKPIAuthenticationPluginInfo
// =============================================================================

function TKPIAuthenticationPluginInfo.Initialise (ConfigFile : ShortString) : Boolean;
var
  PluginStatus : Byte;
begin
  FPlugin := nil;
  FAuthenticationState := '';

  Result := False;
  Try
    // Create an instance of the Data Plug-In to extract information
    With TIniFile.Create(ConfigFile) Do
    Begin
      Try
        If SectionExists('COMObj') Then
        Begin
          FObjectName := ReadString('COMObj', 'NAME', '');
          FConfigFile := ConfigFile;

          PluginStatus := CreatePlugin;
          Try
            // Copy the details out of the COM Object
            FAuthenticationId := FPlugin.apAuthenticationId;
            Result := True;
          Finally
            DestroyPlugin(PluginStatus);
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

// Creates/Destroys the internal instance of the Authentication Plug-In
Function TKPIAuthenticationPluginInfo.CreatePlugin : Byte;
Begin // CreatePlugin
  If (Not Assigned(FPlugin)) Then
  Begin
    FPlugin := CreateOLEObject(FObjectName) As IAuthenticationPlugin;

    // Call the configuration method to allow any custom settings to be read from the IAP
    // file - allows one Authentication Plug-In to have multiple personalities
    FPlugin.CheckIAPFile(FConfigFile);

    // Pass in the historical authentication data
    FPlugin.apAuthenticationState := FAuthenticationState;

    Result := 1;
  End // If (Not Assigned(FPlugin))
  Else
    Result := 0;
End; // CreatePlugin

// -----------------------------------------------------------------------------

Procedure TKPIAuthenticationPluginInfo.DestroyPlugin(Const CreateStatus : Byte);
Begin // DestroyPlugin
  If (CreateStatus = 1) And Assigned(FPlugin) Then
  Begin
    // Save state and destroy the Plug-In
    FAuthenticationState := FPlugin.apAuthenticationState;
    FPlugin := NIL;
  End; // If (CreateStatus = 1) And Assigned(FPlugin)
End; // DestroyPlugin

// -----------------------------------------------------------------------------

// Maps onto IAuthenticationPlugin.CheckLogin, returns TRUE if the Authentication State data
// contains a successful login.  The IPlugin.dpAuthenticationRequest property should be passed
// in as the AuthData parameter and if the login is successful then the returned value should
// be passed into the IPlugin.Authenticate method.
Function TKPIAuthenticationPluginInfo.CheckLogin(var AuthData: WideString) : Boolean;
Begin // CheckLogin
  If Assigned(FPlugin) Then
    Result := FPlugin.CheckLogin(AuthData)
  Else
    Result := False;
End; // CheckLogin

// -----------------------------------------------------------------------------

// Maps onto IAuthenticationPlugin.Login, returns TRUE if a successful login was done.  The
// IPlugin.dpAuthenticationRequest property should be passed in as the AuthData parameter and
// if the login is successful then the returned value should be passed into the IPlugin.Authenticate
// method.
Function TKPIAuthenticationPluginInfo.Login (Var AuthData: WideString; Const HostHandle : HWND) : Boolean;
Begin // Login
  If Assigned(FPlugin) Then
    Result := FPlugin.Login(AuthData, HostHandle)
  Else
    Result := False;
End; // Login

// =============================================================================
// TKPIAuthenticationPlugins
// =============================================================================

procedure TKPIAuthenticationPlugins.Clear;
begin
  // Remove the Plug-Ins from the list
  While (FPlugins.Count > 0) Do
  Begin
    TKPIAuthenticationPluginInfo(FPlugins.Objects[0]).Free;
    FPlugins.Delete(0);
  End; // While (FPlugins.Count > 0)
end;

// -----------------------------------------------------------------------------

Constructor TKPIAuthenticationPlugins.Create;
Begin // Create
  Inherited Create;

  FPlugins := TStringList.Create;
End; // Create

// -----------------------------------------------------------------------------

Destructor TKPIAuthenticationPlugins.Destroy;
Begin // Destroy
  Clear;

  // Destroy the list
  FreeAndNIL(FPlugins);

  Inherited Destroy;
End; // Destroy

// -----------------------------------------------------------------------------

Function TKPIAuthenticationPlugins.GetCount : SmallInt;
Begin // GetCount
  Result := FPlugins.Count;
End; // GetCount

// -----------------------------------------------------------------------------

Function TKPIAuthenticationPlugins.GetPluginByIndex (Index : SmallInt) : TKPIAuthenticationPluginInfo;
Begin // GetPluginByIndex
  If (Index >= 0) And (Index < FPlugins.Count) Then
    Result := TKPIAuthenticationPluginInfo(FPlugins.Objects[Index])
  Else
    Raise Exception.Create ('TKPIAuthenticationPlugins.GetPluginByIndex - Invalid Plug-In Index (' + IntToStr(Index) + ')');
End; // GetPluginByIndex

// -----------------------------------------------------------------------------

Function TKPIAuthenticationPlugins.GetPluginByName (Index : ShortString) : TKPIAuthenticationPluginInfo;
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

Procedure TKPIAuthenticationPlugins.Add (Const ConfigFile : ShortString);
Var
  oPluginInfo : TKPIAuthenticationPluginInfo;
Begin // Add
  // Create an Plug-In Info wrapper and add it into the list using the Plugin code as an index string
  oPluginInfo := TKPIAuthenticationPluginInfo.Create;
  If oPluginInfo.Initialise(ConfigFile) Then
    FPlugins.AddObject (oPluginInfo.apAuthenticationId, oPluginInfo);
End; // Add

// -----------------------------------------------------------------------------

end.
