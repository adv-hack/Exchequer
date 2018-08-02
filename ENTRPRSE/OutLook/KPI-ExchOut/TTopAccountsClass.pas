unit TTopAccountsClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs;

type
  TTopAccounts = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section
    FMode : ShortString;         // Indicates the mode that the plug-in runs in - C=Customer, S=Supplier

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)
    FAcType: ShortString;        // Account Type
    FArea: ShortString;          // Area
    FCostCentre: ShortString;    // Cost Centre
    FDept: ShortString;          // Department
    FUDF1: ShortString;
    FUDF2: ShortString;
    FUDF3: ShortString;
    FUDF4: ShortString;
    FUDF5: ShortString;
    FUDF6: ShortString;
    FUDF7: ShortString;
    FUDF8: ShortString;
    FUDF9: ShortString;
    FUDF10: ShortString;

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FModeDesc : ShortString;     // "Customer" or "Supplier"

    procedure CheckUserAuth;
  public
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
     Controls, CTKUtil, ShellAPI, FileUtil, TopAccountsConfigForm, AccountForm, DrillDownForm;


Type
  TAccountBalancesSort = Class(TObject)
  Private
    FCode, FMode : ShortString;
    FBalance, FSortedBalance : Double;
    FCompany: ShortString;
  Public
    Property absCode : ShortString Read FCode;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    Property absBalance : Double Read FBalance;
    Property absSortedBalance : Double Read FSortedBalance;
    property absCompany: ShortString read FCompany;

    Constructor Create (Const Account : IAccount; Const Mode : ShortString; Const Balance : Double; Const Company: ShortString);
  End;

Constructor TAccountBalancesSort.Create (Const Account : IAccount; Const Mode : ShortString; Const Balance : Double; Const Company: ShortString);
Begin // Create
  Inherited Create;

{* POPULATE THE SORT OBJECT'S FIELDS *}

  FCode    := Account.acCode;
  FBalance := Balance;
  FMode    := Mode;
  FCompany := Company;

  // Switch signs on supplier balances so that the plug-ins just returns the top n rows,
  // otherwise for suppliers it would need to return the bottom n rows
  If (Mode[1] = 'S') Then FBalance := -FBalance; // to display negative supplier balances, comment-out this line
  FSortedBalance := FBalance;
{*//  If (Mode[1] = 'S') Then FSortedBalance := -FBalance; // to display negative supplier balances, uncomment this line*}
End;

// Sorts into descending order of balance
function SortObjects (Item1, Item2: Pointer) : Integer;
Var
  Obj1, Obj2 : TAccountBalancesSort;
Begin // SortObjects
  Obj1 := TAccountBalancesSort(Item1);
  Obj2 := TAccountBalancesSort(Item2);

  If (Obj1.absSortedBalance < Obj2.absSortedBalance) Then
    Result := 1
  Else If (Obj1.absSortedBalance > Obj2.absSortedBalance) Then
    Result := -1
  Else
    Result := 0;
End; // SortObjects

function TTopAccounts.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureTopAccounts;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureTopAccounts.Create(ocDataPath);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Caption    := format('Configure Top %ss', [FModeDesc]);
      CustSupp   := FModeDesc;
      Company    := ocCompanyCode;
      Currency   := ocCurrency;
      Host       := HostHandle;
      Rows       := ocRows;
      Area       := FArea;
      AcType     := FAcType;
      CostCentre := FCostCentre;
      Dept       := FDept;
      UDF1        := FUDF1;
      UDF2        := FUDF2;
      UDF3        := FUDF3;
      UDF4        := FUDF4;
      UDF5        := FUDF5;
      UDF6        := FUDF6;
      UDF7        := FUDF7;
      UDF8        := FUDF8;
      UDF9        := FUDF9;
      UDF10       := FUDF10;
      UserName   := ocUserId;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then
    Begin
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
        FArea        := Area;
        FAcType      := AcType;
        FCostCentre  := CostCentre;
        FDept        := Dept;
        FUDF1        := UDF1;
        FUDF2        := UDF2;
        FUDF3        := UDF3;
        FUDF4        := UDF4;
        FUDF5        := UDF5;
        FUDF6        := UDF6;
        FUDF7        := UDF7;
        FUDF8        := UDF8;
        FUDF9        := UDF9;
        FUDF10       := UDF10;
      end;
    End;
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;
end;

function TTopAccounts.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  ID: WideString;
  DrillDownCmd: string;
  CustSupp: string;
  PosEndUserID: integer;
  UserID: string;
  ExchYear: smallint;
  ExchPeriod: smallint;
Begin
  CrackDrillDownInfo(UniqueID);

  ID := ocUniqueIDEtc;

  case ID[1] of
    'C':  CustSupp := 'Cust';
    'S':  CustSupp := 'Supp';
  end;

  ID := copy(ID, 2, length(ID) - 1);

  PosEndUserID := pos('\/', ID) - 1;
  UserID    := copy(ID, 1, PosEndUserID);

  ID := copy(ID, PosEndUserID + 3, length(ID) - PosEndUserID - 2);

  if (ocClickedColumn <> ocFarRightColumn) then begin
    FExclusiveOp := true;
    try
      ShowAccountForm(ocDataPath, ID, FModeDesc, ocCurrency, '', '');
    finally
      FExclusiveOp := false;
    end;
  end
  else begin
      FExclusiveOp := true;
      try
        OpenComToolkit;
        if assigned(ocToolkit) then begin
          try
            with ocToolkit.SystemSetup do begin
              ExchYear   := ssCurrentYear;
              ExchPeriod := ssCurrentPeriod;
            end;
          finally
            CloseComToolkit
          end;
        end;
      finally
        FExclusiveOp := false;
      end;
    DrillDownCmd := format('=ent%sBalance("%s", %d, %d, "%s")', [CustSupp, ocCompanyCode, 1900 + ExchYear, 100 + ExchPeriod, ID]);
    DoDrillDown(DrillDownCmd, ocCompanyCode, UserId);
  end;
  result := false;
end;

function TTopAccounts.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
var
  ColumnTitle: string;
begin
  if (FMode[1] = 'C') Then
    ColumnTitle := 'Sales YTD'
  else
    ColumnTitle := 'Purchases YTD';

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

function TTopAccounts.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
    Result := Format('%s [%s]', [CheckAltCaption('Top ' + FModeDesc + 's'), ocCompanyCode]); // v20
end;

function TTopAccounts.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
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
  result := result + XMLise('UDF1',  FUDF1);
  result := result + XMLise('UDF2',  FUDF2);
  result := result + XMLise('UDF3',  FUDF3);
  result := result + XMLise('UDF4',  FUDF4);
  result := result + XMLise('UDF5',  FUDF5);
  result := result + XMLise('UDF6',  FUDF6);
  result := result + XMLise('UDF7',  FUDF7);
  result := result + XMLise('UDF8',  FUDF8);
  result := result + XMLise('UDF9',  FUDF9);
  result := result + XMLise('UDF10', FUDF10);
end;

function TTopAccounts.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TTopAccounts.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'ExchequerTop' + FModeDesc + 's'; // matches the entry in the <username>.dat file
end;

function TTopAccounts.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TTopAccounts.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := ocUserIsAuthorised;
end;

function TTopAccounts.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  oAccount : IAccount;
  oSortObj : TAccountBalancesSort;
  SortList : TObjectList;
  Res      : LongInt;
  i        : SmallInt;

  function AddUserID: string;
  begin
    result := ocUserID + '\/';
  end;

begin
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
        // As the Account Balance isn't on the account record or indexed in any way we will have
        // to process all accounts and then sort them to work out which to return
        SortList := TObjectList.Create;
        Try
          SortList.OwnsObjects := True;

          // Switch Account objects depending on the mode
          If (FMode[1] = 'C') Then
            oAccount := ocToolkit.Customer
          Else
            oAccount := ocToolkit.Supplier;

          // Load all accounts - use the formatted balance as the primary search string
          oAccount.Index := acIdxCode;
          Res := oAccount.GetFirst;
          While (Res = 0) Do
          Begin
            // filter
            with oAccount as IAccount4 do begin
              if  ((FAcType = '')     or (FAcType = acAccType))
              and ((FArea = '')       or (FArea = acArea))
              and ((FCostCentre = '') or (FCostCentre = acCostCentre))
              and ((FDept = '') or (FDept = acDepartment))
              and ((FUDF1 = '') or (FUDF1 = acUserDef1))
              and ((FUDF2 = '') or (FUDF2 = acUserDef2))
              and ((FUDF3 = '') or (FUDF3 = acUserDef3))
              and ((FUDF4 = '') or (FUDF4 = acUserDef4))
              and ((FUDF5 = '') or (FUDF5 = acUserDef5))
              and ((FUDF6 = '') or (FUDF6 = acUserDef6))
              and ((FUDF7 = '') or (FUDF7 = acUserDef7))
              and ((FUDF8 = '') or (FUDF8 = acUserDef8))
              and ((FUDF9 = '') or (FUDF9 = acUserDef9))
              and ((FUDF10 = '') or (FUDF10 = acUserDef10)) then
                // Get balance
                With oAccount, acHistory Do
                Begin
                  acCurrency := 0;
                  acPeriod := -99;  // YTD
                  acYear := ocToolkit.SystemSetup.ssCurrentYear;

                  if acSales <> 0 then
                    SortList.Add (TAccountBalancesSort.Create(oAccount, FMode, ConvertToCurrency(acSales), ShortString(acCompany)));
                End; // With oAccount.acHistory

              application.ProcessMessages;
              Res := GetNext;
            end;
          End; // While (Res = 0)


  {* SORT DATA *}
          // Sort into
          SortList.Sort(SortObjects);

  {* RETURN DATA AS XML *}
          // Write the top n accounts to the XML result
          Result := '<Data>';
          For I := 0 To IfThen(SortList.Count > ocRows, ocRows - 1, SortList.Count -1) Do
          Begin
            oSortObj := TAccountBalancesSort(SortList.Items[I]);

            if oSortObj.absBalance < 0 then
              if ocAreas < 3 then
                Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column> %s</Column><Column FontColor="#FF0000">%0.2n</Column></Row>', [FMode[1] + AddUserID + oSortObj.absCode, oSortObj.absCode, oSortObj.absCompany, oSortObj.absBalance])
              else
                Result := Result + Format('<Row UniqueId="%s"><Column> %s</Column><Column FontColor="#FF0000">%0.2n</Column></Row>', [FMode[1] + AddUserID + oSortObj.absCode, contract(oSortObj.absCompany, 20), oSortObj.absBalance])
            else
              if ocAreas < 3 then
                Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column> %s</Column><Column>%0.2n</Column></Row>', [FMode[1] + AddUserID + oSortObj.absCode, oSortObj.absCode, oSortObj.absCompany, oSortObj.absBalance])
              else
                Result := Result + Format('<Row UniqueId="%s"><Column> %s</Column><Column>%0.2n</Column></Row>', [FMode[1] + AddUserID + oSortObj.absCode, contract(oSortObj.absCompany, 20), oSortObj.absBalance]);

          End; // For I
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

procedure TTopAccounts.CheckIDPFile(const IDPPath: WideString); {* CHECK IDP FILE FOR PLUG-IN CONFIGURATION *}
begin
  inherited;
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

procedure TTopAccounts.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FAcType := '';
        Leaf := Nodes.NodeByName['AcType'];
        if assigned(Leaf) then
          FAcType := Leaf.AsString;

        FArea := '';
        Leaf := Nodes.NodeByName['Area'];
        if assigned(Leaf) then
          FArea := Leaf.AsString;

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

procedure TTopAccounts.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
begin
  OpenComToolkit;
  case FMode[1] of
    'C': ocUserIsAuthorised := CheckAccessSetting(404); // can view customer balances
    'S': ocUserIsAuthorised := CheckAccessSetting(424); // can view supplier balances
  end;
  CloseComToolkit;
end;

procedure TTopAccounts.Initialize;
begin
  ocRows := 10;
end;

end.
