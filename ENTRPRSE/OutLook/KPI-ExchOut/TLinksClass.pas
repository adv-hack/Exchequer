unit TLinksClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs;

type
  TLink = class(TObject)
  private
    FLinkName:    WideString;
    FLinkAddress: WideString;
  public
    constructor Create(const LinkName: WideString; const LinkAddress: WideString);
    property LinkName: WideString read FLinkName;
    property LinkAddress: WideString read FLinkAddress write FLinkAddress;
  end;

  TLinkList = class(TObjectList)
    function  Get(Index: Integer): TLink;
    procedure Put(Index: Integer; Item: TLink);
  private
  public
    property  Items[Index: Integer]: TLink read Get write Put; default;
    function  IndexOf(const LinkName: WideString): integer;
  end;

  TLinks = class(TOutlookControl)
  private
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FLinkList : TLinkList;

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
    destructor Destroy; override;
  end;

implementation

uses Classes, ComServ, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, LinksConfigForm, grids;


{ TLink }

constructor TLink.Create(const LinkName: WideString; const LinkAddress: WideString);
begin
  FLinkName    := LinkName;
  FLinkAddress := LinkAddress;
end;

{ TLinkList }

function TLinkList.Get(Index: Integer): TLink;
begin
  result := TLink(inherited Get(Index));
end;

function TLinkList.IndexOf(const LinkName: WideString): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if items[i].LinkName = LinkName then begin
      result := i;
      break;
    end;
end;

procedure TLinkList.Put(Index: Integer; Item: TLink);
begin
  inherited Put(Index, pointer(item));
end;

//=========================================================================

function TLinks.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureLinks;
  i: integer;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureLinks.Create(NIL);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Host        := HostHandle;
      Caption     := 'Configure Links';
      LinkCount   := FLinkList.Count;
      Links.Strings.Clear;
      for i := 0 to FLinkList.Count - 1 do
        with FLinkList[i] do
          Links.InsertRow(LinkName, LinkAddress, true);
      if FLinkList.Count > 0 then
        for i := 1 to Links.RowCount - 1 do // ignore column titles
          Links.ItemProps[Links.Keys[i]].EditStyle := esEllipsis;
      startup;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then Begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        FLinkList.Clear;
        for i := 1 to Links.RowCount - 1 do // ignore column titles
          if (trim(Links.Keys[i]) <> '') or (trim(Links.Cells[1, i]) <> '') then
            FLinkList.Add(TLink.Create(Links.Keys[i], Links.Cells[1, i]));
      end;
    End; // If Result
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End; // Try..Finally
end;

function TLinks.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  FileName: string;
begin
  result := false;
  CrackDrillDownInfo(UniqueID);

  if trim(ocUniqueIDEtc) = '' then EXIT;                                                   // no path to be executed.
  FileName := StringReplace(ocUniqueIDEtc, '*', ' ', [rfReplaceAll]);                      // change the asterisks back to spaces. See GetData.
  ShellExecute(GetDesktopWindow, 'open', pchar(FileName), '', '', SW_SHOW);
  result := false;
end;

function TLinks.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  Result :=
  '<Columns>' +
  '  <Column Title=" "      Type="String" Align="Left" FontStyle="" Width="100%" ></Column>' +
  '</Columns>';
end;

function TLinks.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s', [CheckAltCaption('Links')]); // v20
end;

function TLinks.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
var
  i: integer;

  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);

  for i := 0 to FLinkList.Count - 1 do
    result := result + XMLise(format('Link%.2d', [i + 1]), FLinkList[i].LinkName + '=' + FLinkList[i].LinkAddress);
end;

function TLinks.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TLinks.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'ExchequerLinks'; // matches the entry in the <username>.dat file
end;

function TLinks.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TLinks.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := true;
end;

function TLinks.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  i: integer;
begin
{* RETURN DATA AS XML *}
  // Write the top n accounts to the XML result - aw heck, let's do the lot !
  Result := '<Data>';
  For i := 0 To FLinkList.Count - 1 Do
    with FLinkList[i] do
      Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column></Row>', [StringReplace(LinkAddress, ' ', '*', [rfReplaceAll]), LinkName]);
  Result := Result + '</Data>';
end;

procedure TLinks.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
  i: integer;
  PosEquals: integer;
  LinkNo: string;
  Link:        WideString;
  LinkName:    WideString;
  LinkAddress: WideString;
  LinkIx: integer;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FLinkList.Clear;
        for i := 1 to 99 do begin
          LinkNo := format('Link%.2d', [i]); // <Link01><linkname>=<linkaddress></Link01>
          Leaf := Nodes.NodeByName[LinkNo];
          if assigned(Leaf) then begin
            Link        := Leaf.AsString; // <linkname>=<linkaddress>
            PosEquals   := pos('=', Link);
            LinkName    := copy(Link, 1, PosEquals -1);
            LinkAddress := copy(Link, PosEquals + 1, length(Link) - PosEquals);
            FLinkList.Add(TLink.Create(LinkName, LinkAddress));
          end
          else
            break; // don't loop thru all 99 for only a handful of links
        end;
      end;
    finally
      FreeXML;
    end;
end;

procedure TLinks.Initialize;
begin
  ocRows := 10;
  FLinkList := TLinkList.Create(true);
end;

destructor TLinks.Destroy;
begin
  if assigned(FLinkList) then
    FLinkList.Free;
  inherited;
end;

function TLinks.Get_dpStatus: EnumDataPlugInStatus;
begin
  if FLinkList.Count > 0 then
    result := psReady
  else
    result := psConfigError;
end;

end.
