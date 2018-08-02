unit TMessagesClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Classes, ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs, Outlook2000;

type
  TOLMessages = class(TOutlookControl)
  private
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FSelectedFolders: TStringList;

  public
    function  Configure(HostHandle: Integer): WordBool; override;
    function  DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; override;
    function  Get_dlpColumns: WideString; override;
    function  Get_dpCaption: WideString; override;
    function  Get_dpConfiguration: WideString; override;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType; override;
    function  Get_dpPluginID: WideString; override;
    function  Get_dpStatus: EnumDataPlugInStatus; override;
    function  Get_dpSupportsConfiguration: WordBool; override;
    function  Get_dpSupportsDrillDown: WordBool; override;
    function  GetData: WideString; override;
    procedure Initialize; override;
    procedure Set_dpConfiguration(const Value: WideString); override;
  public
    destructor destroy; override;
  end;

implementation

uses ComServ, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, MessagesConfigForm;


function TOLMessages.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureMessages;
  i: integer;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureMessages.Create(nil);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Caption    := format('Configure Messages', []);
      SelectedFolders.Clear;
      for i := 0 to FSelectedFolders.Count - 1 do
        SelectedFolders.Add(FSelectedFolders[i]);
      Startup;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then
    Begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        FSelectedFolders.Clear;
        for i := 0 to SelectedFolders.Count - 1 do
          FSelectedFolders.Add(SelectedFolders[i]);
      end;
    End;

  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;

end;

function TOLMessages.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  OL: outlook2000.TOutlookApplication;
  NS: NameSpace;
  AE: Explorer;
  PST: MAPIFolder;
  SomeFolder: MAPIFolder;
  FN: WideString;

  function MailBoxFolder(const AFolder: MAPIFolder): MAPIFolder;
  var
    IDisp: IDispatch;
    Folder: MAPIFolder;
  begin
    Result := nil;
    try
      Folder := AFolder;
      while Assigned(Folder) do begin
        result := folder;
        IDisp  := Folder.Parent;
        IDisp.QueryInterface(IID_MAPIFolder, Folder);
      end;
    except
      // mailbox permissions
    end;
  end;

  function DoSubFolders(ParentFolder: MAPIFolder): MAPIFolder;
  // recurses into all folders and sub-folders. If the matching folder name is found, the result bubbles up to the top level.
  var
    i: integer;
    ThisFolder: MAPIFolder;
  begin
    result := nil;
    if ParentFolder.Folders.Count > 0 then
      for i := 1 to ParentFolder.Folders.Count do begin
        ThisFolder := ParentFolder.Folders.Item(i);
        FN         := ThisFolder.Name;
        if FN = ocUniqueIDEtc then begin
          result := ThisFolder;                                                 // return the result
          break;
        end
        else begin
          result := DoSubFolders(ThisFolder);                                   // recurse into subfolders
          if result <> nil then                                                 // got a result from a deeper recursion
            break;
        end;
      end;
  end;
Begin
  CrackDrillDownInfo(UniqueID);

  ocUniqueIDEtc := StringReplace(ocUniqueIDEtc, '*', ' ', [rfReplaceAll]);

  OL  := TOutlookApplication.Create(nil);
  NS  := OL.GetNamespace('MAPI');
  AE  := IDispatch(OL.ActiveExplorer) as Explorer;
  try
    PST := MailBoxFolder(NS.GetDefaultFolder(olFolderInbox));                   // get default PST from the default Inbox for the namespace

    try
      AE.CurrentFolder := DoSubFolders(PST);
    except
      ShowMessage('This folder is no longer accessible');
    end;
  finally
    SomeFolder  := nil;
    AE          := nil;
    NS          := nil;
    OL          := nil;
  end;

  result := true; // tell the host to refresh the displayed data.
end;

function TOLMessages.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  Result :=
    '<Columns>' +
    '  <Column Title=" " Type="String" Align="Left"  Width="60%" ></Column>' +
    '  <Column Title=" " Type="String" Align="Right" Width="40%" FontStyle="Normal"></Column>' +
    '</Columns>';
end;

function TOLMessages.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s', [CheckAltCaption('Messages')]); // v20
end;

function TOLMessages.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
var
  i: integer;

  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  for i := 0 to FSelectedFolders.Count - 1 do begin
    if i = 0 then
      Result :=          XMLise(IntToStr(i + 1), FSelectedFolders[0])
    else
      result := result + XMLise(IntToStr(i + 1), FSelectedFolders[i]);
  end;
end;

function TOLMessages.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TOLMessages.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'OLMessages'; // matches the entry in the <username>.dat file
end;

function TOLMessages.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TOLMessages.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := true;
end;

function TOLMessages.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  OL: outlook2000.TOutlookApplication;
  NS: NameSpace;
  PST: MAPIFolder;
  EndResult: WideString;

  function MailBoxFolder(const AFolder: MAPIFolder): MAPIFolder;
  var
    IDisp: IDispatch;
    Folder: MAPIFolder;
  begin
    Result := nil;
    try
      Folder := AFolder;
      while Assigned(Folder) do begin
        result := folder;
        IDisp  := Folder.Parent;
        IDisp.QueryInterface(IID_MAPIFolder, Folder);
      end;
    except
      // mailbox permissions
    end;
  end;

  procedure DoSubFolders(ParentFolder: MAPIFolder);
  // Recurse through all MAPI folders and return an XML row to the host for each required folder
  var
    i: integer;
    ThisFolder: MAPIFolder;
    FN: WideString;
    ItemCount: integer;
  begin
    if ParentFolder.Folders.Count > 0 then
      for i := 1 to ParentFolder.Folders.Count do begin
        ThisFolder := ParentFolder.Folders.Item(i);
        FN         := ThisFolder.Name;
        if SameText(FN, 'Junk E-mail') or SameText(FN, 'Drafts') then
          ItemCount := ThisFolder.Items.Count                                   // Outlook displays total items not unread items for these
        else
          ItemCount  := ThisFolder.UnReadItemCount;
        if FSelectedFolders.IndexOf(FN) <> -1 then                 // is it in the list of required folders.
          if ItemCount <> 0 then
            EndResult := EndResult + Format('<Row UniqueId="%s"><Column>%s</Column><Column FontStyle="Bold">%d</Column></Row>', [StringReplace(FN, ' ', '*', [rfReplaceAll]), FN, ItemCount])
          else
            EndResult := EndResult + Format('<Row UniqueId="%s"><Column>%s</Column><Column >%d</Column></Row>', [StringReplace(FN, ' ', '*', [rfReplaceAll]), FN, ItemCount]);
        DoSubFolders(ThisFolder);                                               // recurse into subfolders
      end;
  end;

begin // GetData
  OL := TOutlookApplication.Create(nil);
  NS := OL.GetNamespace('MAPI');
  try

    PST := MailBoxFolder(NS.GetDefaultFolder(olFolderInbox));                 // get default PST from the default Inbox for the namespace
    DoSubFolders(PST);

  finally
    NS     := nil;
    OL     := nil;
  end;
  Result := '<Data>' + EndResult + '</Data>';
end;

procedure TOLMessages.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
  i: integer;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FSelectedFolders.Clear;
        for i := 1 to 99 do begin
          Leaf := Nodes.NodeByName[IntToStr(i)];
          if assigned(Leaf) then
            FSelectedFolders.Add(Leaf.AsString);
        end;
      end;
    finally
      FreeXML;
    end;
end;

procedure TOLMessages.Initialize;
begin
  ocRows := 10;
  FSelectedFolders := TStringList.create;
end;

destructor TOLMessages.destroy;
begin
  FreeAndNil(FSelectedFolders);
  inherited destroy;
end;

function TOLMessages.Get_dpStatus: EnumDataPlugInStatus;
begin
  if FSelectedFolders.Count > 0 then
    result := psReady
  else
    result := psConfigError;
end;

end.
