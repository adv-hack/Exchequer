unit TDaybookTotalsClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows,
  Forms, TOutlookControlClass, Contnrs, DaybookTotalsConfigForm;

const
  NO_OF_OPTIONS = 5; // The number of Y/N options stored against each document type in <username>.dat

// These document types will be displayed in this order on the config form.
// If these lists are reordered or added to, the FTLAList mechanism means that no other code changes are required

const TLAs: array[0..19] of string = ('SIN', 'SQU', 'SJI', 'SRI', 'SRF', 'SOR', 'SDN', 'SCR', 'SJC', 'SRC',
                                      'PIN', 'PQU', 'PJI', 'PPI', 'PRF', 'POR', 'PDN', 'PCR', 'PJC', 'PPY');
const TLADesc: array[0..19] of string = ('Invoices', 'Quotations', 'Journal Invoices', 'Receipts & Invoice',
                                         'Refunds', 'Orders', 'Delivery Notes', 'Credit Notes', 'Journal Credit Notes', 'Receipts',
                                         'Invoices', 'Quotations', 'Journal Invoices', 'Payments & Invoice',
                                         'Refunds', 'Orders', 'Delivery Notes', 'Credit Notes', 'Journal Credit Notes', 'Payments');

type
  TOnRefreshDataProc = procedure(NewCurrency: Integer) of object;
  TTLA = class(TObject) // Stores the totals and display options for a given TLA, e.g. SIN, SOR etc.
  private
    FTLA: String;       // SIN, POR, SDN, etc.
    FIdx: integer;      // the corresponding ItemIndex of the Config form's CheckListBox
    FRqd: boolean;      // user requires this document type's details to be displayed ?
    FTot: boolean;      // Total value to be displayed ?
    FOut: boolean;      // Outstanding value to be displayed ?
    FTod: boolean;      // Today value to be displayed ?
    FVAT: boolean;      // Total to be inclusive of VAT ?
    FUserAuth: boolean; // is the user authorised to view this document type's totals
    FTotal: double;     // Sum of Transaction Total values
    FTotalincVAT: double;
    FOS: double;        // Sum of Transaction Outstanding values
    FToday: double;     // Sum of Transaction Total values for current date
    FTodayincVAT: double;
    FTotalNet: double;
    FTotalVAT: double;
    function  GetOptions: WideString;
    function GetSP: Char;
    function GetSalPur: string;
    function GetVatTxt: string;
    procedure SetOptions(const options: WideString);
    function GetSalesPurchase: string;
  public
    constructor create(const TLA: string; const Idx: integer; options: string);
    property TLA:         String     read FTLA         write FTLA;
    property Idx:         integer    read FIdx         write FIdx;
    property Options:     WideString read GetOptions   write SetOptions;
    property Rqd:         boolean    read FRqd         write FRqd;
    property TotRqd:      boolean    read FTot         write FTot;
    property OutRqd:      boolean    read FOut         write FOut;
    property TodRqd:      boolean    read FTod         write FTod;
    property VATRqd:      boolean    read FVAT         write FVAT;
    property UserAuth:    boolean    read FUserAuth    write FUserAuth;
    property Total:       double     read FTotal       write FTotal;
    property TotalincVAT: double     read FTotalincVAT write FTotalincVAT;
    property OS:          double     read FOS          write FOS;
    property Today:       double     read FToday       write FToday;
    property TodayincVAT: double     read FTodayincVAT write FTodayincVAT;
    property TotalNet:    double     read FTotalNet    write FTotalNet;
    property TotalVAT:    double     read FTotalVAT    write FTotalVAT;
    property SP:          Char       read GetSP;
    property SalPur:      string     read GetSalPur;
    property SalesPurchase: string   read GetSalesPurchase;
    property VatTxt:      string     read GetVatTxt;
  end;

  TTLAList = class(TObjectList)                        // using our own descendant.....
    function  Get(Index: Integer): TTLA;
    procedure Put(Index: Integer; Item: TTLA);
  private
  public                                                               // a) alleviates the need to keep typecasting every
    property  Items[Index: Integer]: TTLA read Get write Put; default; //    reference to "items", e.g. "TTLA(FTLAList.items[i]).xxxx"
    function  Rqd(TLA: string): boolean;                               // b) allows us to encapsulate this function
    function  UserAuth(TLA: string): boolean;                          // c) and this one.
    function  IndexOf(TLA: string): integer;                           // d) you get the idea
  end;

  TDaybookTotals = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)
    FGetTLA:  string;            // used to limit which transactions (SINs, SORs,etc) GetData uses for the DrillDown totals

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FTLAList: TTLAList;     // each item in the list is a TLA (SIN, POR, PDN, etc) with its display requirements from the config form
                            // It gets populated with the display options in Set_dpConfiguration,
                            // and populated with Exchequer data in GetData

    procedure CheckUserAuth;
    function  Contract(AString: WideString): WideString;
    function  FormatRow(const UniqueRowId: integer; const TLAix: integer; Extra: String; Total: double): string;
    function  IsDayBook(RunNo: integer): boolean;
    procedure ConfigureCheckboxes(frmConfigurePlugIn: TfrmConfigureDaybookTotals);
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
  public
    destructor destroy; override;
    procedure RefreshData(NewCurrency: Integer);
  end;

implementation

uses Classes, StdCtrls, ExtCtrls, ComServ, Dialogs, IniFiles, Math, SysUtils,
     Enterprise01_TLB, Controls, CTKUtil, ShellAPI, FileUtil, DaybookTotalsForm,
     AdvOfficeButtons;

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

Constructor TSortData.Create (Const Stock : IStock; const QtyYTD: double; const SalesYTD: double);
Begin
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
End; // SortObjects

procedure TDaybookTotals.ConfigureCheckboxes(
  frmConfigurePlugIn: TfrmConfigureDaybookTotals);
var
  i: Integer;
begin
  with frmConfigurePlugIn do
  begin
    for i := low(TLAs) to High(TLAs) do
    begin
      case TLAs[i][1] of
        'S': AddRow('Sales ' + TLADesc[i], not (i = 5));
        'P': AddRow('Purchase ' + TLADesc[i], not (i = 15));
      end;
      SetDocTypeRequired(i, FTLAList[i].Rqd);
      SetTotalRequired(i, FTLAList[i].TotRqd);
      SetOSRequired(i, FTLAList[i].OutRqd);
      SetTodayRequired(i, FTLAList[i].TodRqd);
      SetVATRequired(i, FTLAList[i].VATRqd);
    end;
  end;
end;

function TDaybookTotals.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn: TfrmConfigureDaybookTotals;
  i: integer;
Begin // Configure
  frmConfigurePlugIn   := TfrmConfigureDaybookTotals.Create(NIL);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Host          := HostHandle;
      Caption       := 'Configure Daybook Totals';
      Company       := ocCompanyCode;
      DataPath      := ocDataPath;
      Currency      := ocCurrency;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    end;

    ConfigureCheckboxes(frmConfigurePlugin);

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
        for i := low(TLAs) to high(TLAs) do
          with FTLAList[i] do begin
            Rqd    := DocTypeRequired(i);
            TotRqd := TotalRequired(i);
            OutRqd := OSRequired(i);
            TodRqd := TodayRequired(i);
            VATRqd := VATRequired(i);
          end;
      end;
    End; // If Result
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End; // Try..Finally
end;

function TDaybookTotals.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  TLAix: integer;
Begin // DrillDown
  CrackDrillDownInfo(UniqueID);

  TLAix   := StrToInt(copy(ocUniqueIDEtc, 1, 2)); // Id starts with two digits representing the ix of the TLA
  FGetTLA := TLAs[TLAix];              // limit the data processed by GetData
  GetData;                             // Outlook will have re-initialized the host by now
  ShowTotalsForm(FTLAList, TLAix, ocDataPath, ocCurrency, RefreshData);
  FGetTLA := '';
  result := false;
end;

function TDaybookTotals.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  if ocAreas < 3 then
    Result :=
    '<Columns>' +
    '  <Column Title="_" Type="String" Align="Left"  Width="60%"></Column>' +
    '  <Column Title="Total YTD(' + ocCurrencySymbol + ')"   Type="String" Align="Right" Width="40%" FontStyle="Normal"></Column>' +
    '</Columns>'
  else
    Result :=
    '<Columns>' +
    '  <Column Title="_" Type="String" Align="Left"  Width="60%"></Column>' +
    '  <Column Title="Total YTD(' + ocCurrencySymbol + ')"   Type="String" Align="Right" Width="40%" FontStyle="Normal"></Column>' +
    '</Columns>';
end;

function TDaybookTotals.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := format('%s [%s]', [CheckAltCaption('Daybook Totals'), ocCompanyCode]); // v20
end;

function TDaybookTotals.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
// returns e.g. "<SIN>YYNYN</SIN>" where YYNYN represents whether the check boxes on the config form are checked.
var
  i: integer;
    function XMLise(ANode: string; AValue: string): string;
    begin
      result := format('<%s>%s</%0:s>', [ANode, AValue]);
    end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Currency', IntToStr(ocCurrency));
  result := result + XMLise('CurrencySymbol', ocCurrencySymbol);
  with FTLAList do
    for i := 0 to Count - 1 do
      result := result + XMLise(Items[i].TLA, Items[i].Options);
end;

function TDaybookTotals.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TDaybookTotals.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'DaybookTotals'; // matches the entry in the <username>.dat file
end;

function TDaybookTotals.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TDaybookTotals.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := false;
end;

function TDaybookTotals.Contract(AString: WideString): WideString;
// limit the width of displayed data depending on the number of columns (areas) the KPI host is displaying
var
  limit: integer;
begin
  if ocAreas < 3 then
    limit := 35
  else
    limit := 20;

  if length(AString) > limit then
    result := copy(AString, 1, limit) + '..'
  else
    result := AString;
end;

function TDayBookTotals.FormatRow(const UniqueRowId: integer; const TLAix: integer; Extra: String; Total: double): string;
const
  AUTHREQD = 'Authorisation is required to view this data';
var
  desc: string; // the description of the monetary value being displayed
begin
  desc := contract(format('%s %s%s%s', [FTLAList[TLAix].SalPur, TLADesc[TLAix], Extra, FTLAList[TLAix].VATTxt])); // e.g. "Sales" + "Invoices" + "Outstanding" + " + VAT";
  result :=          format('<Row UniqueId="%.2d%.2d">', [TLAix, UniqueRowId]); // first two digits are used in DrillDown
  CheckUserAuth;
  if FTLAList[TLAix].UserAuth then begin
    result := result + format('  <Column>%s</Column>', [desc]);
    result := result + format('  <Column>%0.2n</Column>', [Total]);
  end
  else begin
    result := result + format('  <Column>%s</Column>', [desc]);
    result := result + format('  <Column>%s</Column>', [AUTHREQD]); // must return correct number of columns to KPI host
  end;
  result := result +        '</Row>';
end;

function TDaybookTotals.IsDayBook(RunNo: integer): boolean;
// Given the transaction RunNo, is this a daybook transaction ?
const
  ALL_CURRENT_DAYBOOK = 0;
  SOP_DBK_UNP_OUT     = -40; // from COM toolkit help file and TechDocs.Doc
  SOP_DBK_AUTO_UNP    = -41;
  POP_DBK_UNP_OUT     = -50;
  POP_DBK_AUTO_UNP    = -51;
//  SRN_DBK_UNP         = -125;
//  PRN_DBK_UNP         = -128;
begin
  result :=    (RunNo = ALL_CURRENT_DAYBOOK)
            or (RunNo = SOP_DBK_UNP_OUT)
            or (RunNo = SOP_DBK_AUTO_UNP)
            or (RunNo = POP_DBK_UNP_OUT)
            or (RunNo = POP_DBK_AUTO_UNP);
//            or (RunNo = SRN_DBK_UNP)
//            or (RunNo = PRN_DBK_UNP);
end;


function TDaybookTotals.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
// this is also called from DrillDown in which case FGetTLA will be set to the TLA
// of the required transactions and can be used this to filter out any other transactions.
const
  FINANCIAL_TRANSACTIONS = [dtSIN, dtSJI, dtSCR, dtSJC, dtSRC, dtPIN, dtPJI, dtPCR, dtPJC, dtPPY];
  NON_FINANCIAL_TRANSACTIONS = [dtSOR, dtSDN, dtPOR, dtPDN];
  SELF_SETTLING_TRANSACTIONS = [dtSQU, dtSRI, dtSRF, dtPQU, dtPPI, dtPRF];
  PURCHASE_TRANSACTIONS = [dtPIN, dtPJI, dtPCR, dtPJC, dtPPY, dtPOR, dtPDN, dtPQU, dtPPI, dtPRF];
var
  oTrans:      ITransaction;
  Res:         LongInt;
  i:           integer;
  TLAix:       integer;
  UniqueRowId: integer;
  CurrYear: smallint;
  InvOS: Double;
  TempStr: AnsiString;

  procedure ClearTotals;
  // clear all totals for all TLA's
  var
    i: integer;
  begin
    for i := 0 to FTLAList.Count - 1 do
      with FTLAList[i] do begin
        Total       := 0;
        TotalincVAT := 0;
        OS          := 0;
        Today       := 0;
        TodayIncVAT := 0;
        TotalNet    := 0;
        TotalVAT    := 0;
      end;
  end;

begin // GetData
  Result := '';
  ClearTotals;

{* RETRIEVE DATA *}
  FExclusiveOp := true;
  try
    OpenComToolkit;
    if assigned(ocToolkit) then
    try
      CurrYear := ocToolkit.SystemSetup.ssCurrentYear;
      oTrans := ocToolkit.Transaction;
      with oTrans do begin
        Index := thIdxYearPeriod;                                                 // get current year's records in YearPeriod order
        res := GetGreaterThanOrEqual(BuildYearPeriodIndex(CurrYear, 01));         // starting with period 01
        while res = 0 do begin
          if (thYear = CurrYear) and IsDayBook(thRunNo) then begin                // thYear = CurrYear ??? WHY !!!???
            TLAix := FTLAList.IndexOf(FGetTLA);                                   // if FGetTLA isn't set this will return -1
            if (TLAix <> -1) and (TLAix <> FTLAList.IndexOf(thOurRef)) then       // FGetTLA is set and doesn't match transaction doc type
              TLAix := -1                                                         // skip this record
            else
              TLAix := FTLAList.IndexOf(thOurRef); // IndexOf only uses the document type TLA, e.g SIN, when passed a full thOurRef
            if TLAix <> -1 then                                                   // need to process this record
              with FTLAList[TLAix] do begin
                if Rqd then begin
(*
TempStr := thOurRef;
OutputDebugString(PChar(TempStr));
OutputDebugString(PChar('Today: ' + FloatToStr(ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]))));
OutputDebugString(PChar('Total Order OS: ' + FloatToStr(ConvertToThisCurrency(thCurrency, thTotalOrderOS))));
OutputDebugString(PChar('Total OS: ' + FloatToStr(ConvertToThisCurrency(thCurrency, thTotals[TransTotOutstandingInCcy]))));
OutputDebugString(PChar('Total Net: ' + FloatToStr(ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]))));
OutputDebugString(PChar('Total VAT: ' + FloatToStr(ConvertToThisCurrency(thCurrency, thTotalVAT))));
OutputDebugString(PChar('Total: ' + FloatToStr(ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]))));
OutputDebugString(PChar('-------------------------------------------------------'));
*)
                  if (thDocType in FINANCIAL_TRANSACTIONS) then
                  begin
                    FTLAList[TLAix].OS       := FTLAList[TLAix].OS + ConvertToThisCurrency(thCurrency, thTotals[TransTotOutstandingInCcy]);
                    FTLAList[TLAix].Total    := FTLAList[TLAix].Total + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                    FTLAList[TLAix].TotalNet := FTLAList[TLAix].TotalNet + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                    FTLAList[TLAix].TotalVAT := FTLAList[TLAix].TotalVAT + ConvertToThisCurrency(thCurrency, thTotalVAT);
                    if (thTransDate = FormatDateTime('YYYYMMDD', Date)) then
                    begin
                      FTLAList[TLAix].Today := FTLAList[TLAix].Today + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                      FTLAList[TLAix].TodayIncVAT := FTLAList[TLAix].TodayIncVAT + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                    end;
                  end
                  else if (thDocType in SELF_SETTLING_TRANSACTIONS) then
                  begin
                    FTLAList[TLAix].Total    := FTLAList[TLAix].Total + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                    FTLAList[TLAix].TotalNet := FTLAList[TLAix].TotalNet + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                    FTLAList[TLAix].TotalVAT := FTLAList[TLAix].TotalVAT + ConvertToThisCurrency(thCurrency, thTotalVAT);
                    if (thTransDate = FormatDateTime('YYYYMMDD', Date)) then
                    begin
                      FTLAList[TLAix].Today := FTLAList[TLAix].Today + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                      FTLAList[TLAix].TodayIncVAT := FTLAList[TLAix].TodayIncVAT + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                    end;
                  end
                  else if (thDocType in NON_FINANCIAL_TRANSACTIONS) then
                  begin
                    FTLAList[TLAix].OS       := FTLAList[TLAix].OS + ConvertToThisCurrency(thCurrency, thTotalOrderOS);
                    FTLAList[TLAix].Total    := FTLAList[TLAix].Total + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                    FTLAList[TLAix].TotalNet := FTLAList[TLAix].TotalNet + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                    FTLAList[TLAix].TotalVAT := FTLAList[TLAix].TotalVAT + ConvertToThisCurrency(thCurrency, thTotalVAT);
                    if (thTransDate = FormatDateTime('YYYYMMDD', Date)) then
                    begin
                      FTLAList[TLAix].Today := FTLAList[TLAix].Today + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                      FTLAList[TLAix].TodayIncVAT := FTLAList[TLAix].TodayIncVAT + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                    end;
                  end;

(*
                  else
                  begin
                  TotalincVAT := TotalincVAT + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);          // regardless of display options, total everything
                  Total       := Total + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);             // so that the figures are there for the drill down.

                  // CJS 24/05/2010 - amended VAT handling.
                    if (thDocType in [dtPOR, dtSOR, dtSQU, dtPQU, dtSDN, dtPDN, dtSRC, dtPPY]) then
                    InvOS := thTotalOrderOS
                  else
                  begin
                    InvOS := thTotals[TransTotOutstandingInCcy];
                      if (not VATRqd) and (InvOS <> 0.0) then
                      begin
                        if (thDocType in [dtSCR, dtSJC, dtPIN, dtPJI]) then
                          InvOS := InvOS + thTotalVAT
                        else
                      InvOS := InvOS - thTotalVAT;
                  end;
                    end;
                  OS := OS + ConvertToThisCurrency(thCurrency, InvOS);

                  if (thTransDate = FormatDateTime('YYYYMMDD', Date)) then begin
                      TodayincVAT := TodayincVAT + ConvertToThisCurrency(thCurrency, thTotals[TransTotInCcy]);
                      Today       := Today + ConvertToThisCurrency(thCurrency, thTotals[TransTotNetInCcy]);
                  end;
                  end;
*)

                end;
              end;
          end;
          application.ProcessMessages;
          res := GetNext;                                                         // get record for next period
        end;
      end;
{
      for i := 0 to FTLAList.Count - 1 do // convert totals to the display currency selected by the user
        with FTLAList[i] do begin
          Today       := ConvertToCurrency(Today);
          TodayincVAT := ConvertToCurrency(TodayincVAT);
          OS          := ConvertToCurrency(OS);
          Total       := ConvertToCurrency(Total);
          TotalincVAT := ConvertToCurrency(TotalincVAT);
        end;
}
      if FGetTLA <> '' then EXIT; // This call to GetData was forced in DrillDown not by the KPIHost so we don't need the XML

  {* RETURN DATA AS XML *}
      UniqueRowId := 0;
      Result := '<Data>';
      for i := 0 to FTLAList.Count - 1 do begin
        with FTLAList[i] do
          if Rqd then begin                                                       // should this TLA be displayed ?
            if TotRqd then                                                        // Total...
              case VATRqd of
                {
                true:  result := result + FormatRow(UniqueRowId + 1, i, '', TotalincVAT); // including VAT
                false: result := result + FormatRow(UniqueRowId + 1, i, '', Total);       // without VAT
                }
                true:  result := result + FormatRow(UniqueRowId + 1, i, '', Total); // including VAT
                false: result := result + FormatRow(UniqueRowId + 1, i, '', TotalNet);       // without VAT
              end;
            if OutRqd then
              result := result + FormatRow(UniqueRowId + 2, i, ' Outstanding', OS); // Outstanding
            if TodRqd then                                                          // Total for today...
              case VATRqd of
                true:  result := result + FormatRow(UniqueRowId + 3, i, ' Today', TodayIncVAT); // including VAT
                false: result := result + FormatRow(UniqueRowId + 3, i, ' Today', Today);       // without VAT
              end;
            inc(UniqueRowId, 3);
          end;
      end;
      Result := Result + '</Data>';
    finally
      CloseComToolkit;
    end; // Try..Finally
  finally
    FExclusiveOp := false;
  end;
end;

procedure TDaybookTotals.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
  i: integer;
  TLAix: integer;
  options: WideString;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do
        for i := low(TLAs) to high(TLAs) do begin           // loop thru the list of TLAs
          Leaf := Nodes.NodeByName[TLAs[i]];          // is there a corresponding entry in <username>.dat ?
          if assigned(Leaf) then
            options := Leaf.AsString                       // if so get the options string
          else
            options := 'NNNNN';                             // otherwise, create one. (starting point for any new record types)

          TLAix := FTLAList.IndexOf(TLAs[i]);               // TLA already in list ?
          if TLAix = -1 then
            FTLAList.Add(TTLA.create(TLAs[i], -1, options)) // add a new list item
          else
            FTLAList[TLAix].Options := options;             // update the existing item
        end;
    finally
      FreeXML;
    end;
end;

procedure TDaybookTotals.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
var
  i: integer;
begin
  OpenComToolkit;
  for i := 0 to FTLAList.Count - 1 do
    case FTLAList[i].TLA[1] of // set the access authorisation against each TLA
      'S': FTLAList[i].UserAuth := CheckAccessSetting(187); // can view sales daybook totals
      'P': FTLAList[i].UserAuth := CheckAccessSetting(192); // can view purchase daybook totals
    end;
  CloseComToolkit;
end;

destructor TDaybookTotals.destroy;
begin
  FTLAList.Free;
  inherited destroy;
end;

procedure TDaybookTotals.Initialize;
begin
  ocRows := 10;
  FTLAList := TTLAList.Create(true);
end;

{ TTLAList }

function TTLAList.Get(Index: Integer): TTLA;
begin
  result := TTLA(inherited Get(Index));
end;

function TTLAList.IndexOf(TLA: string): integer;
var
  i: integer;
begin
  result := -1;

  if length(TLA) > 3 then
    system.delete(TLA, 4, length(TLA) - 3);

  for i := 0 to Count - 1 do begin
    if items[i].TLA = TLA then begin
      result := i;
      break;
    end;
  end;
end;

procedure TTLAList.Put(Index: Integer; Item: TTLA);
begin
  inherited Put(Index, pointer(item));
end;

function TTLAList.Rqd(TLA: string): boolean;
var
  i: integer;
begin
  result := false;

  if length(TLA) > 3 then // might have been called with a full thOurRef
    system.delete(TLA, 4, length(TLA) - 3);

  for i := 0 to Count - 1 do begin
    if items[i].TLA = TLA then begin
      result := items[i].Rqd; // is this TLA required to be displayed ?
      break;
    end;
  end;
end;

function TTLAList.UserAuth(TLA: string): boolean;
var
  i: integer;
begin
  result := false;

  if length(TLA) > 3 then
    system.delete(TLA, 4, length(TLA) - 3);

  for i := 0 to Count - 1 do begin
    if items[i].TLA = TLA then begin
      result := items[i].UserAuth;
      break;
    end;
  end;
end;

{ TTLA }

constructor TTLA.create(const TLA: string; const Idx: integer; options: string);
begin
  FTLA := TLA;
  FIdx := Idx;

  while length(options) < NO_OF_OPTIONS do // will automatically adjust the <username>.dat file when new options are added
    options := options + 'N';

  SetOptions(options);
end;

function TTLA.GetOptions: WideString;
// return a string like "YYNYN" to indicate which options have been selected for this TLA
const
  YN: array[false..true] of char = ('N', 'Y');
begin
  result := YN[FRqd] + YN[FTot] + YN[FOut] + YN[FTod] + YN[FVAT];
end;

procedure TTLA.SetOptions(const options: WideString);
begin
  FRqd := options[1] = 'Y'; // The order of these cannot be changed once this plugin has gone live.
  FTot := options[2] = 'Y';
  FOut := options[3] = 'Y';
  FTod := options[4] = 'Y';
  FVAT := options[5] = 'Y';
end;

function TTLA.GetSalPur: string;
// is this TLA a Sales or Purchase item ?
begin
  case FTLA[1] of
    'S': result := 'S.';
    'P': result := 'P.';
  end;
end;

function TTLA.GetSP: char;
// return the first character of the TLA to indicate [S]ales or [P]urchase
begin
  result := FTLA[1];
end;

function TTLA.GetVatTxt: string;
begin
  case FVAT of
    true:  result := ' + VAT';
    false: result := '';
  end;
end;

function TTLA.GetSalesPurchase: string;
begin
  case FTLA[1] of
    'S': result := 'Sales';
    'P': result := 'Purchase';
  end;
end;

procedure TDaybookTotals.RefreshData(NewCurrency: Integer);
begin
  ocCurrency := NewCurrency;
  GetData;
end;

end.
