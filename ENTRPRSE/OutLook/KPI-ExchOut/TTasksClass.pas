unit TTasksClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs, Outlook2000;

type
  TOLTasks = class(TOutlookControl)
  private
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)
    FWhichTasks: WideString;
    FIncludeNoDueDate: boolean;
    FSort1: WideString;
    FSort2: WideString;
    FSort1Asc: boolean;
    FSort2Asc: boolean;

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}

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
  end;

implementation

uses Classes, ComServ, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, TasksConfigForm;

Type
  TSortData = Class(TObject)
  Private
    FDurationText: ShortString;
    FDayName: ShortString;
    FEndTime: TDateTime;
    FStartTime: TDateTime;
    FSubject: WideString;
    FSortKey: TDateTime;
  Public
    Property DayName: ShortString Read FDayName;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    Property DurationText: ShortString Read FDurationText;
    Property StartTime: TDateTime read FStartTime;
    property EndTime: TDateTime read FEndTime;
    property Subject: WideString read FSubject;
    property SortKey: TDateTime read FSortKey;

    Constructor Create(DayName: ShortString; DurationText: ShortString; StartTime: TDateTime; EndTime: TDateTime; Subject: WideString);
  End; // TAccountBalancesSort

Constructor TSortData.Create(DayName: ShortString; DurationText: ShortString; StartTime: TDateTime; EndTime: TDateTime; Subject: WideString);
Begin
  Inherited Create;

{* POPULATE THE SORT OBJECT'S FIELDS *}

  FDayName      := DayName;
  FDurationText := DurationText;
  FStartTime    := StartTime;
  FEndTime      := EndTime;
  FSubject      := Subject;

  FSortKey      := FStartTime;
End;

// Sorts into descending order of balance
function SortObjects (Item1, Item2: Pointer) : Integer;
Var
  Obj1, Obj2 : TSortData;
Begin
  Obj1 := TSortData(Item1);
  Obj2 := TSortData(Item2);

  If (Obj1.SortKey < Obj2.SortKey) Then
    Result := -1
  Else If (Obj1.SortKey > Obj2.SortKey) Then
    Result := 1
  Else
    Result := 0;
End;

function MakeUniqueID(TI: TaskItem): WideString;
begin
  result := StringReplace(DateTimeToStr(TI.CreationTime), ' ', '', [rfReplaceAll]);
end;

//=========================================================================

function TOLTasks.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureTasks;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureTasks.Create(nil);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Caption          := format('Configure Tasks', []);
      WhichTasks       := FWhichTasks;
      IncludeNoDueDate := FIncludeNoDueDate;
      Sort1            := FSort1;
      Sort2            := FSort2;
      Sort1Asc         := FSort1Asc;
      Sort2Asc         := FSort2Asc;
      Startup;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then
    Begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
      FWhichTasks       := WhichTasks;
      FIncludeNoDueDate := IncludeNoDueDate;
      FSort1            := Sort1;
      FSort2            := Sort2;
      FSort1Asc         := Sort1Asc;
      FSort2Asc         := Sort2Asc;
      end;
    End;

  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;

end;

function TOLTasks.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  OL: outlook2000.TOutlookApplication;
  NS: NameSpace;
  AE: Explorer;
  Tasks: MAPIFolder;
  TI: TaskItem;
  TIs: items;
  SearchCriteria: string;
Begin
  CrackDrillDownInfo(UniqueID);

  OL  := TOutlookApplication.Create(nil);
  NS  := OL.GetNamespace('MAPI');
  AE  := IDispatch(OL.ActiveExplorer) as Explorer;
  try
    Tasks := NS.GetDefaultFolder(olFolderTasks);
    TIs := Tasks.Items;
    SearchCriteria := '[Complete] = false';
    TI := TIs.Find(SearchCriteria) as TaskItem;
    while TI <> nil do begin
      if ocUniqueIDEtc = MakeUniqueId(TI) then begin
        TI.Display(0);
        break;
      end;
      TI := TIs.FindNext as TaskItem;
    end;
    if TI = nil then
      ShowMessage('This task no longer exists');
  finally
    TI          := nil;
    TIs         := nil;
    AE          := nil;
    NS          := nil;
    OL          := nil;
  end;
  result := true;
end;

function TOLTasks.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  if ocAreas < 3 then
    Result :=
      '<Columns>' +
      '  <Column Title=" " Type="String" Align="Left"  Width="23%" ></Column>' +
      '  <Column Title=" " Type="String" Align="Left"  Width="77%" ></Column>' +
      '</Columns>'
  else
    Result :=
      '<Columns>' +
      '  <Column Title=" " Type="String" Align="Left"  Width="35%" ></Column>' +
      '  <Column Title=" " Type="String" Align="Left"  Width="65%" ></Column>' +
      '</Columns>';
end;

function TOLTasks.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s', [CheckAltCaption('Tasks')]); // v20
end;

function TOLTasks.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('WhichTasks', FWhichTasks);
  Result := Result + XMLise('IncludeNoDueDate', IntToStr(ord(FIncludeNoDueDate)));
  Result := Result + XMLise('Sort1', FSort1);
  Result := Result + XMLise('Sort2', FSort2);
  Result := Result + XMLise('Sort1Asc', IntToStr(ord(FSort1Asc)));
  Result := Result + XMLise('Sort2Asc', IntToStr(ord(FSort2Asc)));
end;

function TOLTasks.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TOLTasks.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'OLTasks'; // matches the entry in the <username>.dat file
end;

function TOLTasks.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TOLTasks.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := true;
end;

function TOLTasks.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  OL: outlook2000.TOutlookApplication;
  NS: NameSpace;
  Tasks: MAPIFolder;
  TI: TaskItem;
  TIs: items;
  SortCriteria: string;
  SearchCriteria: string;
begin // GetData
  Result := '<Data>';
{* RETRIEVE DATA *}

  OL := TOutlookApplication.Create(nil);
  NS := OL.GetNamespace('MAPI');
  try

    Tasks := NS.GetDefaultFolder(olFolderTasks);
    TIs := Tasks.Items;

    SortCriteria := '';
    if FSort1 <> '(none)' then
      SortCriteria := format('[%s]', [FSort1]);
    if FSort2 <> '(none)' then
      SortCriteria := SortCriteria + format(',[%s]', [FSort2]);  // e.g. '[DueDate],[Importance]'
    TIs.Sort(SortCriteria, not FSort1Asc);

    SearchCriteria := format('[Complete] = false', []);

  {* RETURN DATA AS XML *}
    TI := TIs.Find(SearchCriteria) as TaskItem;
    while TI <> nil do begin

      if (FWhichTasks = 'All')
      or ( (FWhichTasks = 'Todays') and ( (TI.DueDate = Date) or ( (TI.DueDate > 100000) and (FIncludeNoDueDate) ) ) ) then begin
        if TI.DueDate > 100000 then
          Result := Result + Format('<Row UniqueId="%s"><Column FontSize="6">%s</Column><Column>%s</Column></Row>', [MakeUniqueId(TI), 'no due date ', TI.Subject])
        else
          if TI.DueDate < date then
            Result := Result + Format('<Row UniqueId="%s"><Column FontSize="8" FontColor="#FF0000">%s</Column><Column FontColor="#FF000">%s</Column></Row>', [MakeUniqueId(TI), DateToStr(TI.DueDate), TI.Subject])
          else
            Result := Result + Format('<Row UniqueId="%s"><Column FontSize="8">%s</Column><Column>%s</Column></Row>', [MakeUniqueId(TI), DateToStr(TI.DueDate), TI.Subject]);
      end;

      TI := TIs.FindNext as TaskItem;
    end;

  finally
    NS     := nil;
    OL     := nil;
  end;
  Result := result + '</Data>';
end;

procedure TOLTasks.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FWhichTasks := 'All';
        Leaf := Nodes.NodeByName['WhichTasks'];
        if assigned(Leaf) then
          FWhichTasks := Leaf.AsString;

        FIncludeNoDueDate := false;
        Leaf := Nodes.NodeByName['IncludeNoDueDate'];
        if assigned(Leaf) then
          FIncludeNoDueDate := Leaf.AsBoolean;

        FSort1 := '(none)';
        Leaf := Nodes.NodeByName['Sort1'];
        if assigned(Leaf) then
          FSort1 := Leaf.AsString;

        FSort2 := '(none)';
        Leaf := Nodes.NodeByName['Sort2'];
        if assigned(Leaf) then
          FSort2 := Leaf.AsString;

        FSort1Asc := false;
        Leaf := Nodes.NodeByName['Sort1Asc'];
        if assigned(Leaf) then
          FSort1Asc := Leaf.AsBoolean;

        FSort2Asc := false;
        Leaf := Nodes.NodeByName['Sort2Asc'];
        if assigned(Leaf) then
          FSort2Asc := Leaf.AsBoolean;
      end;
    finally
      FreeXML;
    end;
end;

procedure TOLTasks.Initialize;
begin
  ocRows := 10;
end;

function TOLTasks.Get_dpStatus: EnumDataPlugInStatus;
begin
  result := psReady;
end;

end.
