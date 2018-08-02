unit KPIActivePluginsU;

interface

uses Classes, Contnrs, Messages, SysUtils,
  KPIHostControlU,
  KPIAvailablePluginsU;

type
  TKPIActivePlugins = class(TObject)
  private
    FDataHosts : TObjectList;
    function GetCount: Integer;
    function GetPlugin(Index: Integer): TKPIDataHost;
  public
    constructor Create;

    destructor Destroy; override;

    { Adds the supplied Data Host (Active Plug-in) to the internal list. }
    procedure Add (const DataHost : TKPIDataHost);

    { Disconnects, removes, and frees the Data Host identified by the supplied
      ID and Instance ID. Takes no action if no matching Data Host can be
      found. }
    procedure Remove(ID: string; InstanceID: Integer);

    { Disconnects, removes, and frees all the Data Hosts. }
    procedure Clear;

    { Connects all the Data Hosts to the supplied Host control. }
    procedure ConnectToHost(Host: TKPIHostControl);

    { Disconnects all the Data Hosts from the Host control. }
    procedure DisconnectFromHost;

    { OBSOLETE: Locates the Data Host that contains the plug-in identified by
      the supplied Plug-in Info. }
    function FindHostForPlugin(PluginInfo: TKPIPluginInfo): TKPIDataHost;

    { Called after a successful login to run through rechecking the logins for
      all plug-ins requiring the same authentication system. }
    procedure CheckLogins(const AuthenticationId : ShortString; Force: Boolean = False);

    { Called from the KPIManager to identify the destination plug-in and pass
      the message along. }
    procedure ProcessMessage (var Message: TMessage);

    { Resizes all the sections to match the ActiveX control size. }
    procedure Resize(Host: TKPIHostControl);

    { Switches the display of panel borders on or off, for all panels. }
    procedure ShowBorders(Show: Boolean);

    property Count: Integer read GetCount;

    property Plugins[Index: Integer]: TKPIDataHost read GetPlugin; default;
  end;

implementation

uses Dialogs;

// =============================================================================
// TKPIActivePlugins
// =============================================================================

constructor TKPIActivePlugins.Create;
begin
  inherited Create;

  FDataHosts := TObjectList.Create;
end;

// -----------------------------------------------------------------------------

destructor TKPIActivePlugins.Destroy;
begin
  Clear;
  // Destroy the list
  FreeAndNIL(FDataHosts);

  inherited Destroy;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.Add (const DataHost: TKPIDataHost);
begin
  FDataHosts.Add(DataHost);
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.ConnectToHost(Host: TKPIHostControl);
var
  i: SmallInt;
begin
  if (FDataHosts.Count > 0) then
  begin
    for I := 0 to (FDataHosts.Count - 1) do
    begin
      TKPIDataHost(FDataHosts.Items[I]).ConnectToHost(Host);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.DisconnectFromHost;
var
  i: SmallInt;
begin
  if (FDataHosts.Count > 0) then
  begin
    for I := 0 to (FDataHosts.Count - 1) do
    begin
      TKPIDataHost(FDataHosts.Items[I]).DisconnectFromHost;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.CheckLogins(const AuthenticationId : ShortString; Force: Boolean);
{ Called after a successful login to run through rechecking the logins for all
  plug-ins requiring the same authentication system. }
var
  i: SmallInt;
begin
  // Create DataSection objects
  if (FDataHosts.Count > 0) then
  begin
    for i := 0 to (FDataHosts.Count - 1) do
    begin
      TKPIDataHost(FDataHosts.Items[i]).CheckLogin(AuthenticationId, Force);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.ProcessMessage (var Message: TMessage);
{ Called from the SectionManager to identify the destination plug-in and pass
  the message along. }
var
  DataHost: TKPIDataHost;
  i: SmallInt;
begin
  if (FDataHosts.Count > 0) then
  begin
    for i := 0 to (FDataHosts.Count - 1) do
    begin
      DataHost := TKPIDataHost(FDataHosts.Items[i]);
      if (DataHost.InstanceId = Message.lParam) then
      begin
        DataHost.ProcessMessage (Message);
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIActivePlugins.GetPlugin(Index: Integer): TKPIDataHost;
begin
  Result := TKPIDataHost(FDataHosts.Items[Index]);
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.Resize(Host: TKPIHostControl);
var
  i: SmallInt;
begin
  for i := 0 To (FDataHosts.Count - 1) do
    TKPIDataHost(FDataHosts.Items[i]).Resize(Host);
end;

// -----------------------------------------------------------------------------

function TKPIActivePlugins.FindHostForPlugin(PluginInfo: TKPIPluginInfo): TKPIDataHost;
var
  i : SmallInt;
begin
  Result := nil;
  if (FDataHosts.Count > 0) then
  begin
    for i := 0 to (FDataHosts.Count - 1) do
    begin
      if TKPIDataHost(FDataHosts.Items[I]).PluginInfo = PluginInfo then
      begin
        Result := TKPIDataHost(FDataHosts.Items[I]);
        Break;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.Clear;
begin
  DisconnectFromHost;
  FDataHosts.Clear;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.Remove(ID: string; InstanceID: Integer);
var
  DataHost: TKPIDataHost;
  i: SmallInt;
begin
  if (FDataHosts.Count > 0) then
  begin
    for i := 0 to (FDataHosts.Count - 1) do
    begin
      DataHost := TKPIDataHost(FDataHosts.Items[i]);
      if (DataHost.PluginInfo.dpPluginId = ID) and (DataHost.InstanceId = InstanceID) then
      begin
        DataHost.DisconnectFromHost;
        { FDataHosts owns the objects it holds, so it will automatically free
          them when the entry is deleted. }
        FDataHosts.Delete(i);
        Break;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TKPIActivePlugins.GetCount: Integer;
begin
  Result := FDataHosts.Count;
end;

// -----------------------------------------------------------------------------

procedure TKPIActivePlugins.ShowBorders(Show: Boolean);
var
  i: SmallInt;
begin
  for i := 0 To (FDataHosts.Count - 1) do
    TKPIDataHost(FDataHosts.Items[i]).ShowBorders(Show);
end;

// -----------------------------------------------------------------------------

end.
