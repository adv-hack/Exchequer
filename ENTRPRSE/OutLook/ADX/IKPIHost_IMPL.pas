unit IKPIHost_IMPL;

interface

uses
  SysUtils, ComObj, ComServ, ActiveX, Variants, adxAddIn, IKPIHost_TLB,
  Classes, adxolFormsManager, KPIFormU, StdVcl, Windows, OleServer,
  Outlook2000, adxHostAppEvents;

type
  TKPIAddin = class(TadxAddin, IKPIAddin)
  end;

  TAddInModule = class(TadxCOMAddInModule)
    FormsManager: TadxOlFormsManager;
    OutlookAppEvents: TadxOutlookAppEvents;
    procedure adxCOMAddInModuleAddInInitialize(Sender: TObject);
    procedure OutlookAppEventsQuit(Sender: TObject);
    procedure OutlookAppEventsExplorerActivate(Sender: TObject);
  private
    function FindOutlookTodayFolder: string;
  protected
  public
  end;

implementation

{$R *.dfm}

uses Forms, Dialogs, KPIManagerU, VAOUtil;

// =============================================================================
// TAddInModule
// =============================================================================

function TAddInModule.FindOutlookTodayFolder: string;

  // ...........................................................................

  function GetFullFolderName(const AFolder: MAPIFolder): WideString;
  var
    IDisp: IDispatch;
    Folder: MAPIFolder;
  begin
    Result := '';
    try
      Folder := AFolder;
      while Assigned(Folder) do
      begin
        if (Folder.Name <> 'Inbox') then
          Result := '' + Folder.Name + Result;
        IDisp := Folder.Parent;
        if Assigned(IDisp) then
          IDisp.QueryInterface(IID_MAPIFolder, Folder)
        else
          Folder := nil;
      end;
      // if Result <> '' then Delete(Result, 1, 1);
    except
      // Any exceptions are probably caused by mailbox permissions
    end;
  end;

  // ...........................................................................

var
  S: WideString;
  IInbox: MAPIFolder;
begin
  IInbox := OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox);
  if Assigned(IInbox) then
    try
      S := GetFullFolderName(IInbox);
      Result := S;
    finally
      IInbox := nil;
    end;
end;

// -----------------------------------------------------------------------------

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
var
  EntDir, CurrentPath, NewPath: string;
begin
  FormsManager.Items[0].FolderName := FindOutlookTodayFolder;

  // Get current PATH for the process
  CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

//  EntDir := GetEnterpriseDirectory;
  EntDir := VAOInfo.vaoAppsDir;

  // Check to see if it is already present in the path
  If (Pos(UpperCase(EntDir), UpperCase(CurrentPath)) = 0) Then
  Begin
    // Build the new path with the Enterprise directory at the start
    NewPath := EntDir + ';' + CurrentPath;
    // Update the environment settings for the current process
    SetEnvironmentVariable('PATH', PChar(NewPath));
  End;

end;

// -----------------------------------------------------------------------------

procedure TAddInModule.OutlookAppEventsQuit(Sender: TObject);
begin
  KPIManager.OutlookClosing := True;
end;

// -----------------------------------------------------------------------------

procedure TAddInModule.OutlookAppEventsExplorerActivate(Sender: TObject);
begin
  if not KPIManager.Connected then
    KPIManager.Reset;
end;

// -----------------------------------------------------------------------------

initialization
  TadxFactory.Create(ComServer, TKPIAddin, CLASS_KPIAddin, TAddInModule);

end.
