unit TTopProductsClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs;

type
  TTopProducts = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)
    FCostCentre: ShortString;    // Cost Centre
    FDept: ShortString;          // Department
    FStockGroup: integer;        // 0=all, 1=Groups, 2=products, descs and BoM's
    FLocation: ShortString;      // stock location
    FUDF1: ShortString;
    FUDF2: ShortString;
    FUDF3: ShortString;
    FUDF4: ShortString;
    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    FUDF5: ShortString;
    FUDF6: ShortString;
    FUDF7: ShortString;
    FUDF8: ShortString;
    FUDF9: ShortString;
    FUDF10: ShortString;

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}

    procedure CheckUserAuth;
  public
    function  Configure(HostHandle: Integer): WordBool; override;
    function  DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; override;
    function  Get_dlpColumns: WideString; override;
    function  Get_dpCaption: WideString; override;
    function  Get_dpConfiguration: WideString; override;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType; override;
    function  Get_dpPluginID: WideString; override;
    function  Get_dpSupportsConfiguration: WordBool; override;
    function  Get_dpSupportsDrillDown: WordBool; override;
    function  GetData: WideString; override;
    procedure Initialize; override;
    procedure Set_dpConfiguration(const Value: WideString); override;
  end;

implementation

uses Classes, ComServ, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, TopProductsConfigForm, StockForm;


Type
  TSortData = Class(TObject)
  Private
    FSortKey:       double;
    FCode:          ShortString;
    FDesc:          ShortString;
    FQtyYTD:        integer;
    FSalesYTD:      double;
  Public
    property SortKey: double read FSortKey;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    property code: ShortString read FCode;
    property Desc: ShortString read FDesc;
    property QtyYTD: integer read FQtyYTD;
    property SalesYTD: double read FSalesYTD;

    Constructor Create (Const Stock : IStock; const QtyYTD: double; const SalesYTD: double);
  End;

//=========================================================================

Constructor TSortData.Create (Const Stock : IStock; const QtyYTD: double; const SalesYTD: double);
Begin // Create
  Inherited Create;

{* POPULATE THE SORT OBJECT'S FIELDS *}

  FSortKey       := SalesYTD;
  FCode          := Stock.stCode;
  FDesc          := Stock.stDesc[1];
  FQtyYTD        := trunc(QtyYTD);
  FSalesYTD      := SalesYTD;

End;

// Sorts into descending order of balance
function SortObjects (Item1, Item2: Pointer) : Integer;
Var
  Obj1, Obj2 : TSortData;
Begin // SortObjects
  Obj1 := TSortData(Item1);
  Obj2 := TSortData(Item2);

  If (Obj1.SortKey < Obj2.SortKey) Then
    Result := 1
  Else If (Obj1.SortKey > Obj2.SortKey) Then
    Result := -1
  Else
    Result := 0;
End;

function TTopProducts.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureTopProducts;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureTopProducts.Create(NIL);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Host        := HostHandle;
      Caption     := 'Configure Top Products Plug-In';
      Company     := ocCompanyCode;
      Currency    := ocCurrency;
      DataPath    := ocDataPath;
      Rows        := ocRows;
      CostCentre  := FCostCentre;
      Dept        := FDept;
      Location    := FLocation;
      StockGroup  := FStockGroup;
      UDF1        := FUDF1;
      UDF2        := FUDF2;
      UDF3        := FUDF3;
      UDF4        := FUDF4;
      { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
      UDF5        := FUDF5;
      UDF6        := FUDF6;
      UDF7        := FUDF7;
      UDF8        := FUDF8;
      UDF9        := FUDF9;
      UDF10       := FUDF10;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then Begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        if ocCompanyCode <> Company then begin
          ocUserId   := '';
          ocUserIsAuthorised := false;
        end;
        ocCompanyCode := Company;
        if Currency <> -1 then
          ocCurrency  := Currency;
        ocCurrencySymbol := CurrSymb;
        ocRows        := Rows;
        FCostCentre  := CostCentre;
        FDept        := Dept;
        FLocation    := Location;
        FStockGroup  := StockGroup;
        FUDF1        := UDF1;
        FUDF2        := UDF2;
        FUDF3        := UDF3;
        FUDF4        := UDF4;
        { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
        FUDF5        := UDF5;
        FUDF6        := UDF6;
        FUDF7        := UDF7;
        FUDF8        := UDF8;
        FUDF9        := UDF9;
        FUDF10       := UDF10;
      end;
    End; // If Result
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End; // Try..Finally
end;

function TTopProducts.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
Begin
  CrackDrillDownInfo(UniqueID);

  FExclusiveOp := true;
  try
    ShowStockForm(ocDataPath, ocUniqueIDEtc, ocCurrency, '');
  finally
    FExclusiveOp := false;
  end;
  result := false;
end;

function TTopProducts.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  CheckUserAuth;

  if ocUserIsAuthorised then
    if ocAreas < 3 then
      Result :=
      '<Columns>' +
      '  <Column Title="Desc"      Type="String" Align="Left"  Width="55%" ></Column>' +
      '  <Column Title="Sales YTD(' + ocCurrencySymbol + ')" Type="String" Align="Right" Width="25%" FontStyle="Normal"></Column>' +
      '  <Column Title="Qty YTD"   Type="String" Align="Right" Width="20%" FontStyle="Normal"></Column>' +
      '</Columns>'
    else
      Result :=
      '<Columns>' +
      '  <Column Title="Desc"      Type="String" Align="Left"  Width="60%" ></Column>' +
      '  <Column Title="Sales YTD(' + ocCurrencySymbol + ')" Type="String" Align="Right" Width="40%" FontStyle="Normal"></Column>' +
      '</Columns>'
  else
    result := '<Columns>' +
              '  <Column Title=" " Type="String" Align="Left"  Width="100%"></Column>' + // one column to contain the error message
              '</Columns>';
end;

function TTopProducts.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s [%s]', [CheckAltCaption('Top Products'), ocCompanyCode]); // v20
end;

function TTopProducts.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Currency', IntToStr(ocCurrency));
  result := result + XMLise('CurrencySymbol', ocCurrencySymbol);
  result := result + XMLise('Rows', IntToStr(ocRows));
  result := result + XMLise('CostCentre', FCostCentre);
  result := result + XMLise('Dept', FDept);
  result := result + XMLise('Location', FLocation);
  result := result + XMLise('StockGroup', IntToStr(FStockGroup));
  result := result + XMLise('UDF1',  FUDF1);
  result := result + XMLise('UDF2',  FUDF2);
  result := result + XMLise('UDF3',  FUDF3);
  result := result + XMLise('UDF4',  FUDF4);
{ CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
  result := result + XMLise('UDF5',  FUDF5);
  result := result + XMLise('UDF6',  FUDF6);
  result := result + XMLise('UDF7',  FUDF7);
  result := result + XMLise('UDF8',  FUDF8);
  result := result + XMLise('UDF9',  FUDF9);
  result := result + XMLise('UDF10', FUDF10);
end;

function TTopProducts.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TTopProducts.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'ExchequerTopProducts'; // matches the entry in the <username>.dat file
end;

function TTopProducts.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TTopProducts.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := true;
end;

function TTopProducts.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  oStock   : IStock2;
  oSortObj : TSortData;
  SortList : TObjectList;
  Res      : LongInt;
  I        : SmallInt;
  stkGroup : integer;
  Qty, Sales: double;
Begin
  Result := '';
  if not ocUserIsAuthorised then begin
    result := '<Data><Row UniqueId=" "><Column>Authorisation is required to view this data</Column></Row></Data>';
    EXIT;
  end;

{* RETRIEVE DATA *}
  FExclusiveOp := true;
  try
    OpenComToolkit;
    if assigned(ocToolkit) then begin
    try
        SortList := TObjectList.Create;
        Try
          SortList.OwnsObjects := True;

          oStock := ocToolkit.Stock as IStock2;

          // Load the sort list with all products - use SalesYTD as the sort key

          oStock.Index := stIdxCode;

          Res := oStock.GetFirst;

          While (Res = 0) Do Begin
            with oStock as IStock6 do begin
              case stType of
                stTypeGroup:                                             stkGroup := 1;
                stTypeProduct, stTypeDescription, stTypeBillOfMaterials: stkGroup := 2;
              else
                stkGroup := 0;
              end;
              if  ((FCostCentre = '') or (FCostCentre = stCostCentre))
              and ((FDept = '') or (FDept = stDepartment))
              and ((FLocation = '') or (FLocation = stLocation))
              and ((FStockGroup = 0) or (FStockGroup = stkGroup))
              and ((FUDF1 = '') or (FUDF1 = stUserField1))
              and ((FUDF2 = '') or (FUDF2 = stUserField2))
              and ((FUDF3 = '') or (FUDF3 = stUserField3))
              and ((FUDF4 = '') or (FUDF4 = stUserField4))
              { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
              and ((FUDF5 = '') or (FUDF5 = stUserField5))
              and ((FUDF6 = '') or (FUDF6 = stUserField6))
              and ((FUDF7 = '') or (FUDF7 = stUserField7))
              and ((FUDF8 = '') or (FUDF8 = stUserField8))
              and ((FUDF9 = '') or (FUDF9 = stUserField9))
              and ((FUDF10 = '') or (FUDF10 = stUserField10)) then
                // Get balance
              with oStock.stSalesAnalysis do begin
                Qty := 0;
                Sales := 0;
                  with saHistory do begin
                    saCurrency := 0;
                    saPeriod := -99;  // YTD
                    saYear := ocToolkit.SystemSetup.ssCurrentYear;
                    saFilterType := ftNone;

                    Qty := Qty + saQty;
                    Sales := Sales + saSales;
                  end;

                if (Qty <> 0) or (Sales <> 0) then
                  SortList.Add (TSortData.Create(oStock, Qty, ConvertToCurrency(Sales))); {* ADD THE RETRIEVED DATA TO SORT *}
              end;

              application.ProcessMessages;
              Res := GetNext;
            end;
          end;


  {* SORT DATA *}
          // Sort into
          SortList.Sort(SortObjects);

  {* RETURN DATA AS XML *}
          // Write the top n accounts to the XML result
          Result := '<Data>';
          For I := 0 To IfThen(SortList.Count > ocRows, ocRows - 1, SortList.Count -1) Do
          Begin
            oSortObj := TSortData(SortList.Items[I]);
            if ocAreas < 3 then
              Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%0.2n</Column><Column>%d</Column></Row>', [oSortObj.Code, oSortObj.Desc, oSortObj.SalesYTD, oSortObj.QtyYTD])
            else
              Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%0.2n</Column></Row>', [oSortObj.Code, contract(oSortObj.Desc, 20), oSortObj.SalesYTD]);
          End;
          Result := Result + '</Data>';
        Finally
          FreeAndNIL(SortList);
        End; // Try..Finally

    finally
      CloseComToolkit;
    end;
    end;
  finally
    FExclusiveOp := false;
  end;
end;

procedure TTopProducts.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
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

        FLocation := '';
        Leaf := Nodes.NodeByName['Location'];
        if assigned(Leaf) then
          FLocation := Leaf.AsString;

        FStockGroup := 0;
        Leaf := Nodes.NodeByName['StockGroup'];
        if assigned(Leaf) then
          FStockGroup := Leaf.AsInteger;

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

        { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
        FUDF5 := '';
        Leaf := Nodes.NodeByName['UDF5'];
        if assigned(Leaf) then
          FUDF5 := Leaf.AsString;

        FUDF6 := '';
        Leaf := Nodes.NodeByName['UDF6'];
        if assigned(Leaf) then
          FUDF6 := Leaf.AsString;

        FUDF7 := '';
        Leaf := Nodes.NodeByName['UDF7'];
        if assigned(Leaf) then
          FUDF7 := Leaf.AsString;

        FUDF8 := '';
        Leaf := Nodes.NodeByName['UDF8'];
        if assigned(Leaf) then
          FUDF8 := Leaf.AsString;

        FUDF9 := '';
        Leaf := Nodes.NodeByName['UDF9'];
        if assigned(Leaf) then
          FUDF9 := Leaf.AsString;

        FUDF10 := '';
        Leaf := Nodes.NodeByName['UDF10'];
        if assigned(Leaf) then
          FUDF10 := Leaf.AsString;

      end;
    finally
      FreeXML;
    end;
end;

procedure TTopProducts.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
begin
  OpenComToolkit;
  ocUserIsAuthorised := CheckAccessSetting(469); // can view stock balances
  CloseComToolkit;
end;

procedure TTopProducts.Initialize;
begin
  ocRows := 10;
end;

end.
