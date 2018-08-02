unit TVRWReportsClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  IKPIHost_TLB, TOutlookControlClass, Forms, VRWCOM_TLB;  // VRWReportIF;

type
  TVRWReports = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FDataRows: WideString;
    FXMLValue: WideString;

    procedure CheckUserAuth;
    procedure ReadReports(CheckAccess: Boolean);
  public
    procedure CheckIDPFile(const IDPPath: WideString); override;
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
    function UserCanAccess(const ReportName: string): Boolean;
  end;

//function GetVRWReport: IVRWReport; external 'REPENGINE.DLL';
//procedure InitPreview(App: TApplication; Scr: TScreen); external 'REPENGINE.DLL';

implementation

uses Windows, SysUtils, ComObj, Controls, Inifiles, gmXML, VRWConfigForm, ComCtrls,
  Dialogs, KPICommon, EntLicence;

{* DISPLAY CONFIGURATION FORM *}
function TVRWReports.Configure(HostHandle: Integer): WordBool;
var
  frmConfigurePlugIn : TfrmConfigureVRW;
  Row: Integer;
begin
  frmConfigurePlugIn := TfrmConfigureVRW.Create(NIL);
  try
    with frmConfigurePlugIn do
    begin
      Host         := HostHandle;
      Caption      := 'Configure Reports Plug-In';
      Company      := ocCompanyCode;
      Rows         := ocRows;
      DataRows     := FDataRows;
      LoggedIn     := ocUserIsAuthorised;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    if Result Then
    begin
      with frmConfigurePlugIn do
      begin
        if ocCompanyCode <> Company then
        begin
          ocUserId   := '';
          ocUserIsAuthorised := false;
        end;
        ocCompanyCode := Company;
        ocRows        := Rows;
        FDataRows     := '<Data>';
        for Row := 0 to ReportList.Items.Count - 1 do
        begin
          FDataRows := FDataRows + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%s</Column></Row>', [ReportList.Items[Row].Caption, ReportList.Items[Row].Caption, ReportList.Items[Row].SubItems[0]]);
        end;
        FDataRows := FDataRows + '</Data>';
      end;
    end;
  finally
    FreeAndNIL(frmConfigurePlugIn);
  end;
end;

{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
function TVRWReports.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
var
  oReport: IReportTree;
  ReportFile: string;
begin
  CrackDrillDownInfo(UniqueID);
  ReportFile := ocUniqueIDEtc;
  try
    try
      oReport := CreateOLEObject('VRWCOM.ReportTree') as IReportTree;
      oReport.Datapath := Trim(ocDataPath);
      oReport.Report.Read(Trim(ocDataPath) + 'REPORTS\' + ReportFile + '.ERF');
      Screen.Cursor := crHourGlass;
      oReport.Print;
    except
      on E:Exception do
        ShowMessage('Error printing report: ' + E.message);
    end;
  finally
    oReport := nil;
    Screen.Cursor := crDefault;
  end;
  Result := True;
end;

function TVRWReports.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  CheckUserAuth;

  if ocUserIsAuthorised then
      Result :=
        '<Columns>' +
        '  <Column Title="Report"      Type="String" Align="Left"  Width="25%" BackColor="#EEEEFF"></Column>' +
        '  <Column Title="Description" Type="String" Align="Left"  Width="75%" ></Column>' +
        '</Columns>'
  else
    result := '<Columns>' +
              '  <Column Title=" " Type="String" Align="Left"  Width="100%"></Column>' + // one column to contain the error message
              '</Columns>';
end;

function TVRWReports.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s [%s]', [CheckAltCaption('Visual Report Writer Reports'), ocCompanyCode]); // v20
end;

function TVRWReports.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Currency', IntToStr(ocCurrency));
  result := result + XMLise('CurrencySymbol', ocCurrencySymbol);
  result := result + XMLise('Rows', IntToStr(ocRows));
  Result := Result + FDataRows;
end;

function TVRWReports.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TVRWReports.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'VisualReportWriterReports'; // matches the entry in the <username>.dat file
end;

function TVRWReports.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TVRWReports.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := ocUserIsAuthorised;
end;

function TVRWReports.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
begin
  Result := '';
  if not ocUserIsAuthorised then begin
    result := '<Data><Row UniqueId=" "><Column>Authorisation is required to view this data</Column></Row></Data>';
    EXIT;
  end;
  FExclusiveOp := true;
  try
    FXML := TGmXML.Create(NIL); // Don't free this, leave it for the descendent to do it.
    if assigned(FXML) then
    try
      with FXML do
      begin
        Text := FXMLValue;
        ReadReports(True);
      end;
    finally
      FreeXML;
    end;
    Result := FDataRows;
  finally
    FExclusiveOp := false;
  end;
end;

procedure TVRWReports.CheckIDPFile(const IDPPath: WideString); {* CHECK IDP FILE FOR PLUG-IN CONFIGURATION *}
begin
  inherited;
  With TIniFile.Create(IDPPath) Do
  Begin
    Try
{
      FMode := ReadString('Config', 'Type', FMode);
      Case FMode[1] Of
        'C' : FModeDesc := 'Customer';
        'S' : FModeDesc := 'Supplier';
      End; // Case FMode[1]
}
    Finally
      Free;
    End;
  End; // With TIniFile.Create(IDPPath)
end;

procedure TVRWReports.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
begin
  FXMLValue := Value;
  inherited;
  if assigned(ocXML) then
  try
    ReadReports(False);
  finally
    FreeXML;
  end;
end;

procedure TVRWReports.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
begin
  OpenComToolkit;
  ocUserIsAuthorised := CheckAccessSetting(193);
  if (ocUserIsAuthorised) then
    KPIUserId := ocUserId;
  CloseComToolkit;
end;

procedure TVRWReports.Initialize;
begin
  ocRows := 10;
end;

function TVRWReports.UserCanAccess(const ReportName: string): Boolean;
var
  oReportTree: IReportTree;
  NodeType: WideString;
  NodeName: WideString;
  NodeDesc: WideString;
  NodeParent: WideString;
  NodeChild: WideString;
  Filename: WideString;
  LastRun: WideString;
  AllowEdit: WordBool;
  FuncRes: LongInt;
begin
  oReportTree := CreateOLEObject('VRWCOM.ReportTree') as IReportTree;
  try
    if (ocDataPath <> '') then
    begin
      oReportTree.ReportData.Datapath := ocDataPath;
      oReportTree.ReportData.UserID   := KPIUserID;
      FuncRes := oReportTree.ReportData.FindByName(ReportName);
      Result := (FuncRes = 0);
    end
    else
      Result := False;
  finally
    oReportTree.NoPrintPreview;
    oReportTree := nil;
  end;
end;

function TVRWReports.Get_dpStatus: EnumDataPlugInStatus;
begin
  Result := psReady;
  if EnterpriseLicence.elModules[modVisualRW] = mrNone then
    Result := psNotAvailable
  else
    Result := inherited Get_dpStatus;
end;

procedure TVRWReports.ReadReports(CheckAccess: Boolean);
var
  DataNode : TGmXmlNode;
  ReportName: string;
  ReportDesc: string;
  Row: Integer;
begin
  with ocXML do
  begin
    DataNode := Nodes.NodeByName['Data'];
    if assigned(DataNode) then
    begin
      FDataRows := '<Data>';
      for Row := 0 to DataNode.Children.Count - 1 do
      begin
        ReportName := DataNode.Children[Row].Children[0].AsString;
        ReportDesc := DataNode.Children[Row].Children[1].AsString;
        if (not CheckAccess) or UserCanAccess(ReportName) then
        begin
          FDataRows := FDataRows + Format('<Row UniqueId="%s">', [ReportName]);
          FDataRows := FDataRows + '<Column>' + ReportName + '</Column>';
          FDataRows := FDataRows + '<Column>' + ReportDesc + '</Column>';
          FDataRows := FDataRows + '</Row>';
        end;
      end;
      FDataRows := FDataRows + '</Data>';
    end;
  end;
end;

end.
