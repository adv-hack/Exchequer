unit KPIManagerU;

interface

uses Classes, ComObj, Controls, Forms, SysUtils, Windows, IKPIHost_TLB,
     ExtCtrls, Messages,
     KPIHostControlU,
     KPIAuthenticationPluginsU,   // List of installed Authentication Plug-Ins
     KPIAvailablePluginsU,        // List of installed Data Plug-Ins
     KPIActivePluginsU,           // List of running Data Plug-In instances
     MessageF,                    // Hidden form used to receive messages sent by Plug-Ins
     KPIUtils,
     KPILayoutManagerU;

type
  TCreatePlugin = procedure(const FileName : ShortString) of object;
  TPluginCallBack = procedure(PluginInfo: TKPIPluginInfo) of object;
  TDataHostCallBack = procedure(DataHost: TKPIDataHost) of object;

  TKPIManager = class(TObject)
  private
    FAuthenticationPlugins: TKPIAuthenticationPlugins;
    FAvailablePlugins: TKPIAvailablePlugins;
    FActivePlugins: TKPIActivePlugins;
    FOCXDirectory: ShortString;
    FDatDirectory: ShortString;
    FHostHandle : HWND;
    FHost: TKPIHostControl;
    FMessageForm : TfrmOCXMessaging;
    FLayoutManager: TKPILayoutManager;
    FConfigFileName: string;
    FHostType: TKPIHostType;
    FLastAuthenticationID: string;
    FTimer: TTimer;
    FOnLog: TLogEvent;
    FOnLoadConfiguration: TNotifyEvent;
    FOutlookClosing: Boolean;
    FConnected: Boolean;
    FOnReset: TNotifyEvent;
    FExclusiveOpInProgress: boolean;

    function GetAuthenticationPlugin(Name: ShortString): TKPIAuthenticationPluginInfo;
    function GetMessageHandle: HWND;

    procedure CreateAuthenticationPlugin (const IAPFileName : ShortString);
    procedure CreateKPIPluginInfo (const IDPFileName : ShortString);
    procedure LoadConfiguration;
    procedure FindAvailablePlugins (const SearchMask : ShortString; CreateProc : TCreatePlugin);
    procedure OpenConfig(FileName: string);
    procedure SetHostType(const Value: TKPIHostType);

    procedure OnRedrawLayout(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    function GetActiveAreas: TKPIDisplayAreas;

    procedure ChangeAreas(NewCount: Integer);
    function GetAvailablePlugin(ID: string): TKPIPluginInfo;

  public
    // List of Authentication Plug-In Information objects
    property AuthenticationPlugins[Name: ShortString]: TKPIAuthenticationPluginInfo read GetAuthenticationPlugin;

    // List of standard Plug-In Information objects
    property AvailablePlugins[ID: string]: TKPIPluginInfo read GetAvailablePlugin;

    // List of the plug-ins actually installed into the host page/form.
    property ActivePlugins: TKPIActivePlugins read FActivePlugins;

    // This flag is set to True when the KPI Manager has successfully loaded
    // and displayed all the KPI panels (it doesn't indicate that the plug-ins
    // have been logged in).
    property Connected: Boolean read FConnected;

    // Determines if any of the active plugins is currently carrying out an exclusive operation
    // such as having the COM toolkit open.
    property ExclusiveOpInProgress: boolean read FExclusiveOpInProgress write FExclusiveOpInProgress; // v.006 BJH

    // Handle to the Outlook main window - used by plug-ins for reparenting
    // windows and for centering popup dialogs
    property HostHandle: HWND read FHostHandle;

    // The scroll-box control that hosts the KPI panels.
    property Host: TKPIHostControl read FHost;

    // When the user logs in, the authentication information is stored here,
    // and is then used to automatically log in other plugins that use the same
    // details (most commonly, the Company ID). This means that the user does
    // not need to log in to every plug-in separately.
    property LastAuthenticationID: string read FLastAuthenticationID;

    // Returns a handle to the hidden form used internally by the KPIManager
    // for the receipt of messages from the plug-ins. This is needed as the
    // OCX/DataSections are continually created/destroyed during the lifecycle
    // of an Outlook instance.
    property MessageHandle: HWND read GetMessageHandle;

    // Directory for DLLs, OCX, and Plug-in Configuration files.
    property OCXDirectory: ShortString read FOCXDirectory;

    // Directory for Section Configuration file (user-specific).
    property DatDirectory: ShortString read FDatDirectory;

    // The file name of the user's configuration file.
    property ConfigFileName: string read FConfigFileName;

    // Layout Manager for reading and updating the user configuration file,
    // which stores the plug-ins that are include on the page, along with their
    // positioning, and other details.
    property LayoutManager: TKPILayoutManager read FLayoutManager;

    // HostType tells the KPI Manager whether it is running in a web-page (as
    // with Outlook Today) or on an actual form.
    property HostType: TKPIHostType read FHostType write SetHostType;

    // Any 'log' messages are passed to the handler assigned to this property.
    property OnLog: TLogEvent read FOnLog write FOnLog;

    // If assigned, this event handler is called after the KPI Manager has
    // loaded the configuration details for the page.
    property OnLoadConfiguration: TNotifyEvent read FOnLoadConfiguration write FOnLoadConfiguration;

    // If assigned, this event handler is called once the KPI Manager has
    // completed a reset.
    property OnReset: TNotifyEvent read FOnReset write FOnReset;

    // This flag is set by the host module (TAddinModule in IKPIHost_IMPL.pas)
    // when the 'Quit' event is received from Outlook.
    property OutlookClosing: Boolean read FOutlookClosing write FOutlookClosing;

    // Returns the Display Areas object which is currently in use (this will
    // either be FormAreas or WebAreas, depending on the current Host Type).
    property ActiveAreas: TKPIDisplayAreas read GetActiveAreas;

    // The timer is used to regularly refresh the data for plug-ins (based on
    // refresh interval settings assigned by the user).
    property Timer: TTimer read FTimer;

    constructor Create;

    destructor Destroy; override;

    // Called from the constructor of the ActiveX control to allow the sections to be linked
    // in and activated
    procedure ConnectToHost(Host: TKPIHostControl);

    // Called from the destructor of the ActiveX control to allow the sections to be frozen
    // and disconnected from the control
    procedure DisconnectFromHost;

    // Called after a successful login to run through rechecking the logins for all plug-ins
    // requiring the same authentication system
    procedure CheckLogins(const AuthenticationId : ShortString; Force: Boolean = False);

    // Called from the Message Form to process received messages
    procedure ProcessMessage (var Message: TMessage);

    // Calls the supplied procedure for each Plugin.
    procedure ForEachPlugin(PluginCallBack: TPluginCallBack);

    // Call the supplied procedure for each Data Host (active plug-in).
    procedure ForEachActivePlugin(DataHostCallBack: TDataHostCallBack);

    // Called when the ActiveX control is resized, to resize all the sections.
    procedure OnResize(Host: TKPIHostControl);

    // Called for each Plugin when the timer fires, to see if the Plugin is
    // ready to be updated yet, refreshing the data if it is.
    procedure OnActivePluginUpdate(DataHost: TKPIDataHost);

    // Forces the plug-in to refresh its set-up information (columns, etc) and
    // reload the data.
    procedure OnActivePluginRefresh(DataHost: TKPIDataHost);

    // Called when the 'Borders' setting is changed.
    procedure ShowBorders(Show: Boolean);

    // Redisplays the panels
    procedure RedrawLayout;

    // Clears and reloads all the plug-ins;
    procedure Reset;

    // Saves the user configuration file, using the ConfigFileName value.
    procedure SaveConfiguration;

    // Logs the supplied message (for debugging purposes). This only works if
    // the OnLog event handler has been assigned.
    procedure Log(Msg: string);

    // Adds a plug-in to the page.
    procedure InstallPlugin(PluginInfo: TKPIPluginInfo);

    // Removes the specified plug-in from the page. Takes no action if a
    // matching plug-in cannot be found.
    procedure RemovePlugin(ID: string; InstanceID: Integer);

    // Increases the number of display columns on the pages.
    procedure IncrementAreas(Sender: TObject);

    // Decreases the number of display columns on the pages.
    procedure DecrementAreas(Sender: TObject);

  end; // TKPIManager

// Returns the singleton instance of the KPI Manager.
function KPIManager: TKPIManager;

// Destroys the singleton instance of the KPI Manager. Note that calling the
// KPIManager function (above) will recreate the KPI Manager, so calling
// ShutDownKPIManager followed by KPIManager will force a complete reset of
// the KPI system.
procedure ShutDownKPIManager;

implementation

uses Dialogs, IniFiles, ApiUtil, VAOUtil;

var
  lKPIManager : TKPIManager;

// =============================================================================

function KPIManager : TKPIManager;
begin
  if (not Assigned(lKPIManager)) then
    lKPIManager := TKPIManager.Create;
  Result := lKPIManager;
end;

// -----------------------------------------------------------------------------

procedure ShutDownKPIManager;
begin
  if Assigned(lKPIManager) then
    FreeAndNIL(lKPIManager);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TKPIManager
// =============================================================================

procedure TKPIManager.ChangeAreas(NewCount: Integer);
var
  Areas: TKPIDisplayAreas;
  Area: TKPIDisplayArea;
  PluginList: TList;
  i, j: Integer;
{
  Response: Word;
  Msg: string;
}
begin
  Areas := ActiveAreas;

  { If the number of areas has increased, simply add new areas, and leave
    them empty. }
  if (Areas.Count > 0) and (NewCount > Areas.Count) then
  begin
    while (Areas.Count < NewCount) do
      Areas.Add(-1, 25);
    { Resize the areas }
    for i := 0 to Areas.Count - 1 do
    begin
      case NewCount of
        1: Areas[i].PercentWidth := 100;
        2: Areas[i].PercentWidth := 50;
        3: Areas[i].PercentWidth := 33;
        4: Areas[i].PercentWidth := 25;
      end;
    end;
    SaveConfiguration;
    RedrawLayout;
    ForEachActivePlugin(OnActivePluginRefresh);
    Exit;
  end;

  { If the number of areas has decreased... }
  if (Areas.Count > 0) and (NewCount < Areas.Count) then
  begin
    { Collect a list of all the plug-ins that were on the areas which are
      being removed. }
    PluginList := TList.Create;
    try
      for i := NewCount + 1 to Areas.Count do
      begin
        Area := Areas[i - 1];
        for j := 0 to Area.Panels.Count - 1 do
          PluginList.Add(Area.Panels[j].DataHost.PluginInfo);
      end;

{
      if PluginList.Count > 0 then
      begin
        Msg := 'The column that is being removed contains plug-ins. Do you ' +
               'want to transfer these plug-ins to the remaining column';
        if (NewCount > 1) then
          Msg := Msg + 's?'
        else
          Msg := Msg + '?';
        Response := MessageDlg(Msg, mtConfirmation, mbYesNoCancel, 0);
        case Response of
          mrNo: PluginList.Clear;
          mrCancel: Exit;
        end;
      end;
}

      { Remove the areas }
      while Areas.Count > NewCount do
      begin
        Area := Areas[Areas.Count - 1];
        for i := 0 to Area.Panels.Count - 1 do
          FActivePlugins.Remove(Area.Panels[i].ID, Area.Panels[i].InstanceID);
        Areas.Delete(Areas.Count - 1);
      end;

      { Resize the areas }
      for i := 0 to Areas.Count - 1 do
      begin
        case NewCount of
          1: Areas[i].PercentWidth := 100;
          2: Areas[i].PercentWidth := 50;
          3: Areas[i].PercentWidth := 33;
          4: Areas[i].PercentWidth := 25;
        end;
      end;

      { Reassign the plug-ins to the remaining areas. }
      for i := 0 to PluginList.Count - 1 do
        InstallPlugin(TKPIPluginInfo(PluginList[i]));

      SaveConfiguration;
      RedrawLayout;
      ForEachActivePlugin(OnActivePluginRefresh);

    finally
      PluginList.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.CheckLogins(const AuthenticationId : ShortString; Force: Boolean);
{ Called after a successful login to run through rechecking the logins for all
  plug-ins requiring the same authentication system. }
begin
  FActivePlugins.CheckLogins (AuthenticationId, Force);
  FLastAuthenticationID := AuthenticationID;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.ConnectToHost(Host: TKPIHostControl);
{ Called from the constructor of the ActiveX control to allow the sections to be linked
  in and activated. }
Begin // ConnectToSectionHost
  FHost := Host;

  try
    // Once we know the Host, we can load the configuration details.
    LoadConfiguration;

    If (FHostHandle = 0) Then
    Begin
      // Get the SectionHost to calculate the correct Host Handle - although we will have
      // different instances of the section host during the lifetime of a single outlook
      // session the outlook handle itself won't change
      FHostHandle := Host.GetHostHandle;

    End; // If (FHostHandle = 0)

    FActivePlugins.ConnectToHost(Host);

    FHost.OnRedrawLayout := self.OnRedrawLayout;

    OnRedrawLayout(self);

    FTimer.Enabled := True;
  except
    on E:Exception do
    begin
      ShowMessage('An error occured while connecting the plug-ins: ' + E.Message);
      FConnected := False;
    end;
  end;
End; // ConnectToSectionHost

// -----------------------------------------------------------------------------

constructor TKPIManager.Create;
begin // Create
  inherited Create;

  FConnected := False;
  FOutlookClosing := False;

  // Initialise the handle - the proper setting will be done when the OCX control connects up
  FHostHandle := 0;

  // Create the hidden messaging form
  FMessageForm := TfrmOCXMessaging.Create(nil);
  FMessageForm.OnMessage := ProcessMessage;

  // Create custom lists to store the plug-ins
  FAuthenticationPlugins := TKPIAuthenticationPlugins.Create;
  FAvailablePlugins := TKPIAvailablePlugins.Create;
  FActivePlugins := TKPIActivePlugins.Create;

  // Get the directory we are running from
  FOCXDirectory := IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir) + 'KPI\';
  FDatDirectory := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir) + 'KPI\';

  FLayoutManager := TKPILayoutManager.Create;

  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 60000; // 1 minute
  FTimer.OnTimer := OnTimer;

  // Load authentication plug-ins
  FAuthenticationPlugins.Clear;
  FindAvailablePlugins ('*.IAP', CreateAuthenticationPlugin);

  Reset;
end; // Create

// -----------------------------------------------------------------------------

procedure TKPIManager.CreateAuthenticationPlugin (const IAPFileName : ShortString);
Begin // CreateAuthenticationPlugin
  FAuthenticationPlugins.Add(FOCXDirectory + IAPFileName);
End; // CreateAuthenticationPlugin

// -----------------------------------------------------------------------------

procedure TKPIManager.CreateKPIPluginInfo (const IDPFileName : ShortString);
Begin // CreateKPIPluginInfo
  FAvailablePlugins.Add(FOCXDirectory + IDPFileName);
End; // CreateKPIPluginInfo

// -----------------------------------------------------------------------------

procedure TKPIManager.DecrementAreas(Sender: TObject);
begin
  ChangeAreas(ActiveAreas.Count - 1);
end;

// -----------------------------------------------------------------------------

destructor TKPIManager.Destroy;
begin // Destroy
  try
    // Save configuration data to ??? file

    // Destroy the various lists of objects/interfaces
    FreeAndNIL(FAuthenticationPlugins);
    FreeAndNIL(FAvailablePlugins);
    FreeAndNIL(FActivePlugins);
    FreeAndNil(FLayoutManager);

    // Destroy the hidden messaging form
    FreeAndNIL(FMessageForm);
  except
    on E:Exception do
      ShowMessage ('TKPIManager.Destroy.Exception ' + E.Message);
  end;

  inherited Destroy;
end; // Destroy

// -----------------------------------------------------------------------------

procedure TKPIManager.DisconnectFromHost;
{ Called from the destructor of the ActiveX control to allow the sections to be frozen
  and disconnected from the control. }
begin
  FTimer.Enabled := False;
  FActivePlugins.DisconnectFromHost;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.ForEachPlugin(PluginCallBack: TPluginCallBack);
var
  PluginInfo: TKPIPluginInfo;
  Entry: Integer;
begin
  for Entry := 0 to FAvailablePlugins.Count - 1 do
  begin
    PluginInfo := FAvailablePlugins.PluginsByIndex[Entry];
    PluginCallBack(PluginInfo);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.ForEachActivePlugin(DataHostCallBack: TDataHostCallBack);
var
  DataHost: TKPIDataHost;
  Entry: Integer;
begin
  for Entry := 0 to FActivePlugins.Count - 1 do
  begin
    DataHost := FActivePlugins[Entry];
    DataHostCallBack(DataHost);
  end;
end;

// -----------------------------------------------------------------------------

function TKPIManager.GetActiveAreas: TKPIDisplayAreas;
begin
  if HostType = htForm then
    Result := FLayoutManager.FormAreas
  else
    Result := FLayoutManager.WebAreas;
end;

// -----------------------------------------------------------------------------

function TKPIManager.GetAuthenticationPlugin(Name : ShortString): TKPIAuthenticationPluginInfo;
begin
  Result := FAuthenticationPlugins.PluginsByName[Name];
end;

// -----------------------------------------------------------------------------

function TKPIManager.GetAvailablePlugin(ID: string): TKPIPluginInfo;
begin
  Result := FAvailablePlugins.PluginsByName[ID];
end;

// -----------------------------------------------------------------------------

function TKPIManager.GetMessageHandle : HWND;
Begin // GetMessageHandle
  If Assigned(FMessageForm) Then
    Result := FMessageForm.Handle
  Else
    Result := 0;
End; // GetMessageHandle

// -----------------------------------------------------------------------------

procedure TKPIManager.IncrementAreas(Sender: TObject);
begin
  ChangeAreas(ActiveAreas.Count + 1);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.InstallPlugin(PluginInfo: TKPIPluginInfo);
{ Adds the Plugin to the layout and the .dat file. }
var
  Areas: TKPIDisplayAreas;
  Panel: TKPIDisplayPanel;
  DataHost: TKPIDataHost;
begin
  Areas := ActiveAreas;

  Panel := Areas.LeastUsed.Panels.Add(PluginInfo.dpPluginId, PluginInfo.dpCaption);
  DataHost := TKPIDataHost.Create;
  DataHost.Configure(PluginInfo, Panel.Configuration);
  FActivePlugins.Add(DataHost);
  Panel.DataHost := DataHost;
  DataHost.ConnectToHost(FHost);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.LoadConfiguration;
{ Loads and parses the Configuration file storing all the configuration info
  for the sections. }
var
  Areas: TKPIDisplayAreas;
  Area: TKPIDisplayArea;
  Panel: TKPIDisplayPanel;
  X, Y, W: Integer;
  i, j: Integer;
  PluginInfo: TKPIPluginInfo;
  DataHost: TKPIDataHost;
  Units: Double;
begin
  Units := (FHost.Width / 100);
  // Load user-specific configuration information
  FConfigFileName := FDatDirectory + WinGetUserName + '.dat';
  OpenConfig(FConfigFileName);

  X := 0;
  Y := 0;
  if self.HostType = htForm then
    Areas := FLayoutManager.FormAreas
  else
    Areas := FLayoutManager.WebAreas;
  if (Areas <> nil) then
  begin
    { Process each panel on each display area }
    for i := 0 to Areas.Count - 1 do
    begin
      Area := Areas[i];
      if FHostType = htWebpage then
        Y := 0;
      Area.Top := Y;
      Area.Left := X;
      Area.Height := FHost.Height;
      W := Trunc(Units * Area.PercentWidth);
      Area.Width := W;
      for j := 0 to Area.Panels.Count - 1 do
      begin
        Panel := Area.Panels[j];
        PluginInfo := FAvailablePlugins.PluginsByName[Panel.Id];
        if Assigned(PluginInfo) then
        begin
          // Add the Plugin to the Data Host list
          DataHost := TKPIDataHost.Create;
          DataHost.Running  := False;
          DataHost.Interval := Panel.Interval;
          DataHost.Configure(PluginInfo, Panel.Configuration);
          FActivePlugins.Add(DataHost);
{
          DataHost.Top := Y + 8;
          DataHost.Left := X + 8;
          DataHost.Width := Area.Width - 16;
          DataHost.Height := Panel.Height;
}
          Panel.DataHost := DataHost;
          Y := Y + Panel.Height + 8;
        end
        else
        begin
          MessageDlg('The ' + Panel.ID + ' Plug-In is not recognized and cannot be loaded, please notify your technical support.', mtWarning, [mbOK], 0);
        end; // if Assigned(PluginInfo)...
      end; // for j := 0 to Area.Panels.Count - 1 do...
      if (FHostType = htWebpage) then
      begin
        X := X + W;
      end;
    end;
  end;
  if Assigned(FOnLoadConfiguration) then
    OnLoadConfiguration(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.FindAvailablePlugins(const SearchMask : ShortString; CreateProc : TCreatePlugin);
var
  Info : TSearchRec;
  Res  : SmallInt;
begin // LoadPlugins
  Res :=  FindFirst(FOCXDirectory + SearchMask, faAnyFile, Info);
  try
    while (Res = 0) Do
    begin
      CreateProc(Info.Name);
      Res := FindNext(Info);
    end; // while (Res = 0)
  finally
    SysUtils.FindClose (Info);
  end; // finally
end; // LoadPlugins

// -----------------------------------------------------------------------------

procedure TKPIManager.Log(Msg: string);
begin
  if Assigned(FOnLog) then
    OnLog(Msg);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.OnActivePluginRefresh(DataHost: TKPIDataHost);
begin
//  if (DataHost.Running) then
  DataHost.PushData;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.OnActivePluginUpdate(DataHost: TKPIDataHost);
begin
  if DataHost.Running then
  begin
    DataHost.NextUpdate := DataHost.NextUpdate - 1;
    if (DataHost.NextUpdate < 1) then
      DataHost.PushData;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.OnRedrawLayout(Sender: TObject);
var
  Areas: TKPIDisplayAreas;
  Area: TKPIDisplayArea;
  Panel: TKPIDisplayPanel;
  X, Y, W: Integer;
  i, j: Integer;
  DataHost: TKPIDataHost;
  Units: Double;
begin
  Units := (FHost.Width / 100);
  X := 0;
  Y := 0;
  if self.HostType = htForm then
    Areas := FLayoutManager.FormAreas
  else
    Areas := FLayoutManager.WebAreas;
  if (Areas <> nil) then
  begin
    { Process each panel on each display area }
    for i := 0 to Areas.Count - 1 do
    begin
      Area := Areas[i];
      if FHostType = htWebpage then
        Y := 0;
      Area.Top  := Y;
      Area.Left := X;
      Area.Height := FHost.Height;
      W := Trunc(Units * Area.PercentWidth);
      Area.Width := W;
      for j := 0 to Area.Panels.Count - 1 do
      begin
        Panel := Area.Panels[j];
        DataHost := Panel.DataHost;
        DataHost.Top  := Y + 8 - FHost.VertScrollBar.Position;
        DataHost.Left := X + 8;
        DataHost.Width := Area.Width - 16;
        DataHost.Height := Panel.Height;
        DataHost.Interval := Panel.Interval;
        Y := Y + DataHost.Height + 8;
      end; // for j := 0 to Area.Panels.Count - 1 do...
      if (FHostType = htWebpage) then
      begin
        X := X + W;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.OnResize(Host: TKPIHostControl);
begin
  FLayoutManager.Resize(Host.Width, Host.Height);
  ForEachActivePlugin(OnActivePluginUpdate);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.OnTimer(Sender: TObject);
begin
  ForEachActivePlugin(OnActivePluginUpdate);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.OpenConfig(FileName: string);
var
  FileReader: TStringList;
const
  FileContents =
    '<?xml version="1.0"?>' + #13#10 +
    '<Root>' + #13#10 +
    '  <Config>' + #13#10 +
    '    <Comment>Config Info</Comment>' + #13#10 +
    '    <Width>50</Width>' + #13#10 +
    '    <Height>400</Height>' + #13#10 +
    '  </Config>' + #13#10 +
    '  <WebLayout>' + #13#10 +
    '    <KPIHost style="left">' + #13#10 +
    '    </KPIHost>' + #13#10 +
    '  </WebLayout>' + #13#10 +
    '  <FormLayout>' + #13#10 +
    '    <KPIHost style="left">' + #13#10 +
    '    </KPIHost>' + #13#10 +
    '  </FormLayout>' + #13#10 +
    '<Root>';
begin
  { Make sure we actually have a user configuration file. }
  if not FileExists(FileName) then
  begin
    FileReader := TStringList.Create;
    try
      { User file not found -- copy from the default if possible }
      if FileExists(FDatDirectory + 'default.dat') then
      begin
        FileReader.LoadFromFile(FDatDirectory + 'default.dat');
        FileReader.SaveToFile(FileName);
      end
      else
      begin
        { Final fallback -- no user file, and no default file. }
        FileReader.Text := FileContents;
        FileReader.SaveToFile(FileName);
      end;
    finally
      FileReader.Free;
    end;
  end;
  FLayoutManager.LoadFromFile(FileName);
//  UpdateConfig;
//  FLayoutManager.SaveToFile(FileName);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.ProcessMessage (var Message: TMessage);
{ Called from the Message Form to process received messages. }
begin
  FActivePlugins.ProcessMessage (Message);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.RedrawLayout;
begin
  OnRedrawLayout(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.RemovePlugin(ID: string; InstanceID: Integer);
var
  Area: TKPIDisplayArea;
  Panel: TKPIDisplayPanel;
begin
  Area  := nil;
  Panel := nil;
  if KPIManager.LayoutManager.LocatePlugin(ID, InstanceID, Area, Panel) then
  begin
    Area.Panels.DeletePanel(ID, InstanceID);
    FActivePlugins.Remove(ID, InstanceID);
    SaveConfiguration;
    RedrawLayout;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.Reset;
begin
  FConnected := False;

  FActivePlugins.Clear;

  // Load data plug-in information
  if (FAvailablePlugins.Count = 0) then
//  FAvailablePlugins.Clear;
    FindAvailablePlugins ('*.IDP', CreateKPIPluginInfo);

  // Redisplay the page, provided the host type has been set.
  if FHostType <> htUnknown then
  begin
    FLayoutManager.Clear;
    LoadConfiguration;
    if FLastAuthenticationID <> '' then
      CheckLogins(FLastAuthenticationID, True);
    FActivePlugins.ConnectToHost(FHost);
    RedrawLayout;
    if Assigned(FOnReset) then
      OnReset(self);
  end;

  FConnected := True;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.SaveConfiguration;
begin
  FLayoutManager.SaveToFile(FConfigFileName);
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.SetHostType(const Value: TKPIHostType);
begin
  if FHostType = htUnknown then
  begin
    FHostType := Value;
  end
  else
    FHostType := Value;
end;

// -----------------------------------------------------------------------------

procedure TKPIManager.ShowBorders(Show: Boolean);
begin
  FActivePlugins.ShowBorders(Show);
  FLayoutManager.ShowBorders := Show;
  SaveConfiguration;
  RedrawLayout;
end;

// -----------------------------------------------------------------------------

initialization
  lKPIManager := NIL;

// -----------------------------------------------------------------------------

finalization
  ShutDownKPIManager;

// -----------------------------------------------------------------------------

end.
