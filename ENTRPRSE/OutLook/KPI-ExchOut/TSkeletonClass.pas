unit TSkeletonClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs;

type
  TSkeleton = class(TOutlookControl)
  private
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section
    FMode : ShortString;         // Indicates the mode that the plug-in runs in - C=Customer, S=Supplier

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FModeDesc : ShortString;     // "Customer" or "Supplier"

    procedure CheckUserAuth;
  protected
    procedure CheckIDPFile(const IDPPath: WideString); override;
    function  Configure(HostHandle: Integer): WordBool; override;
    function  DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; override;
    function  Get_dlpColumns: WideString; override;
    function  Get_dpCaption: WideString; override;
    function  Get_dpConfiguration: WideString; override;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType; override;
    function  Get_dpPluginID: WideString; override;
//    function  Get_dpStatus: EnumDataPlugInStatus; override;
    function  Get_dpSupportsConfiguration: WordBool; override;
    function  Get_dpSupportsDrillDown: WordBool; override;
    function  GetData: WideString; override;
    procedure Initialize; override;
    procedure Set_dpConfiguration(const Value: WideString); override;
  end;

implementation

uses Classes, ComServ, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, ConfigForm;


function TSkeleton.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigure;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigure.Create(nil);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Caption    := format('Configure %ss on Hold', [FModeDesc]);
      CustSupp   := FModeDesc;
      Company    := ocCompanyCode;
      UserName   := ocUserId;
      Currency   := ocCurrency;
      Host       := HostHandle;
      Rows       := ocRows;
      Startup;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then
    Begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        if ocCompanyCode <> Company then begin
          ocUserId           := '';
          ocUserIsAuthorised := false;
        end;
        ocCompanyCode := Company;
        if Currency <> -1 then
          ocCurrency  := Currency;
        ocCurrencySymbol := CurrSymb;
        ocRows        := Rows;
      end;
    End;
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;
end;

function TSkeleton.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
Begin
  CrackDrillDownInfo(UniqueID);


  result := true; // tell the host to refresh the displayed data.
end;

function TSkeleton.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
var
  ColumnTitle: string;
begin
  ColumnTitle := 'Credit Limit';

  CheckUserAuth;

  if ocUserIsAuthorised then
    if ocAreas < 3 then
      Result :=
        '<Columns>' +
        '  <Column Title="Code"    Type="String" Align="Left"  Width="15%" BackColor="#EEEEFF"></Column>' +
        '  <Column Title="Name"    Type="String" Align="Left"  Width="60%" ></Column>' +
        '  <Column Title="' + ColumnTitle + '(' + ocCurrencySymbol + ')" Type="String" Align="Right" Width="25%" FontStyle="Normal"></Column>' +
        '</Columns>'
    else
      Result :=
        '<Columns>' +
        '  <Column Title="Name"    Type="String" Align="Left"  Width="60%" ></Column>' +
        '  <Column Title="' + ColumnTitle + '(' + ocCurrencySymbol + ')" Type="String" Align="Right" Width="40%" FontStyle="Normal"></Column>' +
        '</Columns>'
  else
    result := '<Columns>' +
              '  <Column Title=" " Type="String" Align="Left"  Width="100%"></Column>' + // one column to contain the error message
              '</Columns>';
end;

function TSkeleton.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  result := Format('%ss on Hold [%s]', [FModeDesc, ocCompanyCode]);
end;

function TSkeleton.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Currency', IntToStr(ocCurrency));
  result := result + XMLise('CurrencySymbol', ocCurrencySymbol);
  result := result + XMLise('Rows', IntToStr(ocRows));
  result := result + XMLise('AcType', FAcType);
  result := result + XMLise('Area', FArea);
  result := result + XMLise('CostCentre', FCostCentre);
  result := result + XMLise('Dept', FDept);
  result := result + XMLise('UDF1', FUDF1);
  result := result + XMLise('UDF2', FUDF2);
  result := result + XMLise('UDF3', FUDF3);
  result := result + XMLise('UDF4', FUDF4);
end;

function TSkeleton.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TSkeleton.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  result := Format('%ssOnHold', [FModeDesc]); // DON'T INCLUDE SPACES otherwise it will not match with what's in username.dat
end;

function TSkeleton.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TSkeleton.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := ocUserIsAuthorised;
end;

function TSkeleton.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
Begin
  Result := '';
  if not ocUserIsAuthorised then begin
    result := '<Data><Row UniqueId=" "><Column>Authorisation is required to view this data</Column></Row></Data>';
    EXIT;
  end;

{* RETRIEVE DATA *}
  OpenComToolkit;
  if assigned(ocToolkit) then begin
  try
  finally
    CloseComToolkit;
  end;
  end;
end;

procedure TSkeleton.CheckIDPFile(const IDPPath: WideString); {* CHECK IDP FILE FOR PLUG-IN CONFIGURATION *}
begin
  With TIniFile.Create(IDPPath) Do
  Begin
    Try
      FMode := ReadString('Config', 'Type', FMode);

      Case FMode[1] Of
        'C' : FModeDesc := 'Customer';
        'S' : FModeDesc := 'Supplier';
      End; // Case FMode[1]
    Finally
      Free;
    End;
  End; // With TIniFile.Create(IDPPath)
end;

procedure TSkeleton.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FCostCentre := '';
        Leaf := Nodes.NodeByName['CostCentre'];
        if assigned(Leaf) then
          FCostCentre := Leaf.AsString;

        FDept := '';
        Leaf := Nodes.NodeByName['Dept'];
        if assigned(Leaf) then
          FDept := Leaf.AsString;

        FUDF1 := '';
        Leaf := Nodes.NodeByName['UDF1'];
        if assigned(Leaf) then
          FUDF1 := Leaf.AsString;

        FUDF2 := '';
        Leaf := Nodes.NodeByName['UDF2'];
        if assigned(Leaf) then
          FUDF2 := Leaf.AsString;

        FUDF3 := '';
        Leaf := Nodes.NodeByName['UDF3'];
        if assigned(Leaf) then
          FUDF3 := Leaf.AsString;

        FUDF4 := '';
        Leaf := Nodes.NodeByName['UDF4'];
        if assigned(Leaf) then
          FUDF4 := Leaf.AsString;
      end;
    finally
      FreeXML;
    end;
end;

procedure TSkeleton.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
begin
  OpenComToolkit;
  case FMode[1] of
    'C': ocUserIsAuthorised := CheckAccessSetting(404); // can view customer balances
    'S': ocUserIsAuthorised := CheckAccessSetting(424); // can view supplier balances
  end;
  CloseComToolkit;
end;

procedure TSkeleton.Initialize;
begin
  ocRows := 10;
end;

end.
