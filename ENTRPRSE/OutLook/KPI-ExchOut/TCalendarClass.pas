unit TCalendarClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Outlook2000;

type
  TOLCalendar = class(TOutlookControl)
  private
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
  FDays: integer;

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

uses Classes, ComServ, Contnrs, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, FileUtil, CalendarConfigForm;

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

function MakeUniqueID(StartTime: TDateTime; EndTime: TDateTime): WideString;
// returns a string comprised of the start and end dates and times which can be
// used by the KPI Host as the UniqueID for each row.
// N.B. As you can have more than one Calendar item with the same start time and
// duration on the same day, this value isn't actually unique but serves the purpose.
begin
  result := FormatDateTime('yyyymmddhhnn', StartTime) + '-' + FormatDateTime('yyyymmddhhnn', EndTime);
end;

//=========================================================================

function TOLCalendar.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
var
  frmConfigurePlugIn : TfrmConfigureCalendar;
  i: integer;
begin // Configure
  frmConfigurePlugIn := TfrmConfigureCalendar.Create(nil);
  try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Caption    := format('Configure Calendar', []);
      Days := FDays;
      Startup;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    if Result then begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        FDays := Days;
      end;
    end;

  finally
    FreeAndNIL(frmConfigurePlugIn);
  end;
end;

function TOLCalendar.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  XML : TGmXML;
  Leaf : TGmXmlNode;
  OL: outlook2000.TOutlookApplication;
  NS: NameSpace;
  AE: Explorer;
  Calendar: MAPIFolder;
  AI: AppointmentItem;
  AIs: items; // will contain the collection of found appointment items
  i: integer;
  SearchCriteria: string;
Begin
  CrackDrillDownInfo(UniqueID);

  OL  := TOutlookApplication.Create(nil);
  NS  := OL.GetNamespace('MAPI');
  AE  := IDispatch(OL.ActiveExplorer) as Explorer;
  try
    Calendar := NS.GetDefaultFolder(olFolderCalendar);
    AIs := Calendar.Items;
    AIs.Sort('[Start]', false);     // Sort in Start DateTime order, descending=false
    AIs.IncludeRecurrences := true; // include recurring appointments
    SearchCriteria := format('[Start] >= "%s" and [Start] < "%s"', [DateToStr(date), DateToStr(Date + FDays)]); // Limit the data returned to calendar items for today + FDays
    AI := AIs.Find(SearchCriteria) as AppointmentItem;
    while AI <> nil do begin                             // Loop thru the matching calendar items.
      if ocUniqueIDEtc = MakeUniqueId(AI.Start, AI.End_) then begin // encode the start and end date/time to match the format created in GetData.
        AI.Display(0);                                   // display the calendar item.
        break;
      end;
      AI := AIs.FindNext as AppointmentItem;             // FindNext
    end;
    if AI = nil then
      ShowMessage('This appointment no longer exists');
  finally
    AI          := nil;
    AIs         := nil;
    AE          := nil;
    NS          := nil;
    OL          := nil;
  end;

  result := false;
end;

function TOLCalendar.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  if ocAreas < 3 then
    Result :=
      '<Columns>' +
      '  <Column Title=" " Type="String" Align="Left"  Width="22%" ></Column>' +
      '  <Column Title=" " Type="String" Align="Left"  Width="78%" ></Column>' +
      '</Columns>'
  else
    Result :=
          '<Columns>' +
          '  <Column Title=" " Type="String" Align="Left"  Width="35%" ></Column>' +
          '  <Column Title=" " Type="String" Align="Left"  Width="65%" ></Column>' +
          '</Columns>';
end;

function TOLCalendar.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s', [CheckAltCaption('Calendar')]); // v20
end;

function TOLCalendar.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Days', IntToStr(FDays));
end;

function TOLCalendar.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TOLCalendar.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'OLCalendar'; // matches the entry in the <username>.dat file
end;

function TOLCalendar.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TOLCalendar.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := ocUserIsAuthorised;
end;

function TOLCalendar.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  OL: outlook2000.TOutlookApplication;
  NS: NameSpace;
  Calendar: MAPIFolder;
  AI: AppointmentItem;
  AIs: items;
  i: integer;
  DayName: string;
  PrevDayName: string;
  DurationText: string;
  SortList: TObjectList;
  SortData: TSortData;
  SearchCriteria: string;
begin // GetData
{* RETRIEVE DATA *}

  OL := TOutlookApplication.Create(nil);
  NS := OL.GetNamespace('MAPI');
  SortList := TObjectList.Create;
  try
    try

      SortList.OwnsObjects := true;
      PrevDayName := '';
      Calendar := NS.GetDefaultFolder(olFolderCalendar);
      AIs := Calendar.Items;
      AIs.Sort('[Start]', false);     // Sort in Start DateTime order
      AIs.IncludeRecurrences := true; // include recurring appointments
      SearchCriteria := format('[Start] >= "%s" and [Start] < "%s"', [DateToStr(date), DateToStr(Date + FDays)]); // limit data to calendar items for today + FDays
      AI := AIs.Find(SearchCriteria) as AppointmentItem;
      while AI <> nil do begin
        if trunc(AI.Start) = date then
          DayName := 'Today'
        else
          DayName := format('%-8s', [FormatDateTime('dddd', AI.Start)]);

        if AI.AllDayEvent then
          DurationText := 'All day event'
        else
          if trunc(AI.Start) <> trunc(AI.End_) then // starts and ends on different days
            DurationText := 'Multi-day event'
          else
            DurationText := FormatDateTime('hh:nn', AI.Start) + ' - ' + FormatDateTime('hh:nn', AI.End_);

        SortList.Add (TSortData.Create(Dayname, DurationText, AI.Start, AI.End_, AI.Subject)); {* ADD THE RETRIEVED DATA TO SORT *}

        AI := AIs.FindNext as AppointmentItem;
      end;
    finally
      NS     := nil;
      OL     := nil;
    end;


  {* SORT DATA *}
    SortList.Sort(SortObjects); // sort by start date.

  {* RETURN DATA AS XML *}
    Result := '<Data>';
    for i := 0 to SortList.Count - 1 do begin
      SortData := TSortData(SortList.Items[i]);
      if SortData.DayName <> PrevDayName then
        Result := Result + Format('<Row UniqueId="%s"><Column FontStyle="Bold,Underline" FontSize="8">%s</Column><Column FontStyle="Underline" FontColor="#E0DFE3">                                     </Column></Row>', [MakeUniqueId(SortData.StartTime, SortData.EndTime), SortData.DayName]);
      PrevDayName := SortData.DayName;
      Result := Result + Format('<Row UniqueId="%s"><Column FontSize="6" FontStyle"Bold">%s</Column><Column FontSize="7">%s</Column></Row>', [MakeUniqueId(SortData.StartTime, SortData.EndTime), SortData.DurationText ,SortData.Subject]);
    end;

    Result := result + '</Data>';

  finally
    FreeAndNil(SortList);
  end;
end;

procedure TOLCalendar.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FDays := 5;
        Leaf := Nodes.NodeByName['Days'];
        if assigned(Leaf) then
          FDays := Leaf.AsInteger;
      end;
    finally
      FreeXML;
    end;

//  CheckPluginStatus;
end;

procedure TOLCalendar.Initialize;
begin
  ocRows := 10;
end;

function TOLCalendar.Get_dpStatus: EnumDataPlugInStatus;
begin
  if FDays > 0 then
    result := psReady
  else
    result := psConfigError;
end;

end.
