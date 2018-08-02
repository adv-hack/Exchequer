unit frmStockU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SBSPanel, uMultiList, uDBMColumns, SupListU,
  EBStockLine, GlobVar, VarConst, FuncList, ExWrap1U, Menus, StdCtrls,
  TCustom, BorBtns, TEditVal, Mask, bkgroup, ComCtrls, BTSupU1,
  DrillConst, DispDocF;

type
  { Btrieve list (indirect descendant of TMULCtrl in SbsComp.pas) }
  TStockList = class(TGenList)
  private
    // Extended Btrieve Operations object
    DataObj: ^TExtBtrieveStockLines;

    WaitMsgDlg: TForm;

    lstCurrency: Byte;
    lstFilterMode: TDataFilterMode;
    lstLocation: ShortString;
    lstPeriod: SmallInt;
    lstStockCode: ShortString;
    lstCustCode: ShortString;
    lstYear: SmallInt;
    lstCostCentre: ShortString;
    lstDepartment: ShortString;

    { Function Category determines which set of records are displayed }
    lstFunctionCategory: TEnumFunctionCategory;

    function DefaultFilter(B_End: Integer; var KeyS: Str255): Integer;
    function FilterForCustomer(B_End: Integer; var KeyS: Str255): Integer;
    function FilterForPeriod(B_End: Integer; var KeyS: Str255): Integer;
    procedure ParseQty(var StockPos: StockPosType; DQty: Real;
      ShowSign: Boolean);

  public
    procedure DetermineFilterMode;
    function ExtFilter: Boolean; override;
    procedure ExtObjCreate; override;
    procedure ExtObjDestroy; override;
    function GetExtList(B_End: Integer; var KeyS: Str255): Integer; override;
    function OutLine(Col: Byte): Str255; override;
    function SetCheckKey: Str255; override;
    function SetFilter: Str255; override;

    property CostCentre: ShortString
      read lstCostCentre write lstCostCentre;

    property Currency: Byte
      read lstCurrency write lstCurrency;

    property CustCode: ShortString
      read lstCustCode write lstCustCode;

    property DataFilterMode: TDataFilterMode
      read lstFilterMode write lstFilterMode;

    property Department: ShortString
      read lstDepartment write lstDepartment;

    property FunctionCategory: TEnumFunctionCategory
      read lstFunctionCategory write lstFunctionCategory;

    property Location: ShortString
      read lstLocation write lstLocation;

    property Period: SmallInt
      read lstPeriod write lstPeriod;

    property StockCode: ShortString
      read lstStockCode write lstStockCode;

    property Year: SmallInt
      read lstYear write lstYear;

  end;

  TfrmStock = class(TForm)
    PageControl: TPageControl;
    LedgerPage: TTabSheet;
    BtListBox: TScrollBox;
    BtListHeaderPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLUPLab: TSBSPanel;
    CLOOLab: TSBSPanel;
    CLQOLab: TSBSPanel;
    CLALLab: TSBSPanel;
    CLQILab: TSBSPanel;
    CLACLab: TSBSPanel;
    CLAWLab: TSBSPanel;
    CLIWLab: TSBSPanel;
    CLSRLab: TSBSPanel;
    CLPRLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLUPPanel: TSBSPanel;
    CLOOPanel: TSBSPanel;
    CLQOPanel: TSBSPanel;
    CLALPanel: TSBSPanel;
    CLQIPanel: TSBSPanel;
    CLAcPanel: TSBSPanel;
    CLAWPanel: TSBSPanel;
    CLIWPanel: TSBSPanel;
    CLSRPanel: TSBSPanel;
    CLPRPanel: TSBSPanel;
    BtListBtnPanel: TSBSPanel;
    PopupMenu: TPopupMenu;
    ViewTransaction: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    MainPage: TTabSheet;
    TCMScrollBox: TScrollBox;
    SBSBackGroup1: TSBSBackGroup;
    Label85: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Label828: Label8;
    Label829: Label8;
    Label830: Label8;
    SBSBackGroup3: TSBSBackGroup;
    ValLab: Label8;
    ValLab2: Label8;
    SBSBackGroup4: TSBSBackGroup;
    Label836: Label8;
    Label837: Label8;
    Label838: Label8;
    Label834: Label8;
    Label835: Label8;
    Label827: Label8;
    Label831: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label832: Label8;
    Label1: TLabel;
    SROOF: TCurrencyEdit;
    SRCF: Text8Pt;
    SRISF: TCurrencyEdit;
    SRPOF: TCurrencyEdit;
    SRALF: TCurrencyEdit;
    SRFRF: TCurrencyEdit;
    SRCPF: TCurrencyEdit;
    SRRPF: TCurrencyEdit;
    SRRPCF: TSBSComboBox;
    SRMIF: TCurrencyEdit;
    SRMXF: TCurrencyEdit;
    SRSPF: TBorCheck;
    SRSP1F: TCurrencyEdit;
    SRGP1: TCurrencyEdit;
    SRMBF: TBorCheck;
    SRSBox1: TScrollBox;
    Label812: Label8;
    Label813: Label8;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    Label817: Label8;
    SRD1F: Text8Pt;
    SRD2F: Text8Pt;
    SRD3F: Text8Pt;
    SRD4F: Text8Pt;
    SRD5F: Text8Pt;
    SRD6F: Text8Pt;
    SRTF: TEdit;
    txtStockPricing: Text8Pt;
    SRCPCF: Text8Pt;
    SRVMF: Text8Pt;
    WOPPage: TTabSheet;
    SBSBackGroup11: TSBSBackGroup;
    SBSBackGroup10: TSBSBackGroup;
    Label854: Label8;
    Label845: Label8;
    Label846: Label8;
    Label855: Label8;
    Label856: Label8;
    Bevel10: TBevel;
    Label857: Label8;
    Label858: Label8;
    Label859: Label8;
    Label860: Label8;
    Label861: Label8;
    Label862: Label8;
    SRPWF: TCurrencyEdit;
    SRIWF: TCurrencyEdit;
    SRAWF: TCurrencyEdit;
    SRGIF: Text8Pt;
    FGLIF: Text8Pt;
    SRROLTF: TCurrencyEdit;
    SRASSDF: TCurrencyEdit;
    SRASSHF: TCurrencyEdit;
    SRASSMF: TCurrencyEdit;
    CBCalcProdT: TBorCheck;
    SRMEBQF: TCurrencyEdit;
    ReturnsPage: TTabSheet;
    SBSBackGroup12: TSBSBackGroup;
    SBSBackGroup13: TSBSBackGroup;
    Label820: Label8;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    SBSBackGroup14: TSBSBackGroup;
    Label825: Label8;
    Label864: Label8;
    SRRPRF: TCurrencyEdit;
    SRRSRF: TCurrencyEdit;
    SRRGLF: Text8Pt;
    SRRGLDF: Text8Pt;
    SRRSWDF: TCurrencyEdit;
    SRRMWDF: TCurrencyEdit;
    SRRSWMF: TSBSComboBox;
    SRRSMMF: TSBSComboBox;
    SRRPGLF: Text8Pt;
    SRRGLPDF: Text8Pt;
    SRRRCF: Text8Pt;
    CLPWPanel: TSBSPanel;
    CLPWLab: TSBSPanel;
    BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    btnViewLine: TButton;
    btnClose: TButton;
    ResetCoordinates1: TMenuItem;
    procedure BtListLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtListLabMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BtListPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure ResetCoordinates1Click(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ViewTransactionClick(Sender: TObject);
    procedure WMCustGetRec(var Msg: TMessage); message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); message WM_WindowPosChanged;
    procedure PageControlChange(Sender: TObject);
  private
    { Private declarations }
    FstkCostCentre: ShortString;
    FstkCurrency: Byte;
    FstkDepartment: ShortString;
    FstkFunctionCategory: TEnumFunctionCategory;
    FstkLocation: ShortString;
    FstkPeriod: SmallInt;
    FstkStockCode: ShortString;
    FstkCustCode: ShortString;
    FstkYear: SmallInt;

    DisplayTrans: TfrmDisplayTransManager;

    DoneRestore: Boolean;
    ReadFormPos: Boolean;
    LastCoord: Boolean;
    GotCoord: Boolean;
    SetDefault: Boolean;
    InitSize: TPoint;
    StoreCoord: Boolean;
    StartSize: TPoint;
    BtList: TStockList;
    ListOffset: Byte;
    ExLocal: TdExLocal;
    FromHistory: Boolean;
    FNeedCUpDate: Boolean;

    PagePoint: array[1..3] of TPoint;

    { Array to hold the Stock Description Lines text controls (so that we can
      easily loop through these controls). Populated in FormCreate. }
    DescLineControls: array[1..6] of TExt8pt;

    function CheckListFinished: Boolean;
    procedure DisplayTransactions(const IdFolio: LongInt; const DataChanged: Boolean);
    procedure FindFormCoords;
    procedure FreeList;
    function GetCurrency: Byte;
    function GetCustCode: ShortString;
    function GetFunctionCategory: TEnumFunctionCategory;
    function GetLocation: ShortString;
    function GetPeriod: SmallInt;
    function GetStockCode: ShortString;
    function GetYear: SmallInt;
    procedure RefreshList(ShowLines, IgnoreMessages: Boolean);
//    procedure SetFormProperties;
    procedure SetFunctionCategory(const Value: TEnumFunctionCategory);
    procedure SetStockCode(const Value: ShortString);
    procedure SetLocation(const Value: ShortString);
    procedure SetCurrency(const Value: Byte);
    procedure SetPeriod(const Value: SmallInt);
    procedure SetYear(const Value: SmallInt);
    procedure SetCustCode(const Value: ShortString);
    procedure SetNeedCUpdate(const Value: Boolean);
    procedure ShowRightMenu(X, Y, Mode: Integer);
    procedure StoreBtListCoords;
    procedure StoreFormCoords(UpdateMode: Boolean);
    procedure UpdateMainPage;

    property NeedCUpDate: Boolean read FNeedCUpDate write SetNeedCUpdate;
    function GetCostCentre: ShortString;
    function GetDepartment: ShortString;
    procedure SetCostCentre(const Value: ShortString);
    procedure SetDepartment(const Value: ShortString);

  public

    procedure BuildList;

    property stkCostCentre: ShortString
      read GetCostCentre write SetCostCentre;

    property stkCurrency: Byte
      read GetCurrency write SetCurrency;

    property stkCustCode: ShortString
      read GetCustCode write SetCustCode;

    property stkDepartment: ShortString
      read GetDepartment write SetDepartment;

    property stkLocation: ShortString
      read GetLocation write SetLocation;

    property stkPeriod: SmallInt
      read GetPeriod write SetPeriod;

    property stkStockCode: ShortString
      read GetStockCode write SetStockCode;

    property stkFunctionCategory: TEnumFunctionCategory
      read GetFunctionCategory write SetFunctionCategory;

    property stkYear: SmallInt
      read GetYear write SetYear;

  end;

function NewStkHistoryDialog: TfrmStock;

var
  frmStock: TfrmStock;

implementation

uses
  Math,
  EntData,
  uSettings,
  BtKeys1U,
  ETDateU,
  ETMiscU,
  CurrncyU,
  Btrvu2,
  ETStru,
  ComnU2,
  PWarnU,
  SysU1,
  SysU2,
  BtSupU2,
  DrillUtils,
  SbsComp,
  CmpCtrlU,
  ColCtrlU,
  VarRec2U,
  EntLicence,
  DateUtils,
  SQLUtils,
  SQLRep_Config
  ;

const
  { Stock Types }

  { Descriptions taken from X:\Entrprse\R&D\BtSupU2.pas,
    procedure Init_STDStkTList }
  StockTypeDescs: array[0..4] of string =
  (
    'Product',
    'Description Only',
    'Group',
    'Discontinued',
    'Bill of Materials'
  );

  { Descriptions taken from X:\Entrprse\R&D\StockU.pas, function Outstock,
    and X:\Entrprse\R&D\BtSupU2.pas, function InitStdValList. }
  StockValuationMethods: array[0..5] of string =
  (
    'Last Cost',
    'Standard',
    'FIFO',
    'LIFO',
    'Average',
    'Serial/Batch'
  );

  { Because the columns and column-numbering can change according to which
    list is being displayed, these constants map the fields to the columns.
    These are mainly used by the Outline method. }
  Col_OurRef    = 0;
  Col_Date      = 1;
  Col_ACCode    = 2;

  Col_QtyIn     = 3;
  Col_QtyOut    = 4;
  Col_Alloc     = 5;
  Col_OnOrder   = 6;
  Col_AllocWOR  = 7;
  Col_IssuedWOR = 8;
  Col_PickedWOR = 9;

  Col_SalesRet  = 10;
  Col_PurchRet  = 11;

  Col_UnitPrice = 12;

{$R *.dfm}

function NewStkHistoryDialog: TfrmStock;
begin
  Result := nil;
  if Assigned(frmStock) then
    FreeAndNil(frmStock);

{
    try
      // Try to access the caption to determine whether the form is still
      // in existance - if not then should get an Access Violation
      if (frmStock.Caption <> '') then
        Result := frmStock
    except
      on Exception do
      ;
    end;
}

  // If no pre-existing form then create a new one
  if (not Assigned(Result)) then
    Result := TfrmStock.Create (nil);

  // Record global reference to form for later use
  frmStock := Result;
end;

//=============================================================================
// TStockList
//=============================================================================

function TStockList.DefaultFilter(B_End: Integer;
  var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through transaction records. }
begin
  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. }
  Result := DataObj.Filter01(
              B_End+30,                // Btrieve Operation (+30 = Extended version)
              ScanFileNum,             // File Number
              KeyPath,                 // Index Number
              KeyS,                    // Search Key
              lstStockCode
            );

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('DefaultFilter(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

//-----------------------------------------------------------------------------

procedure TStockList.DetermineFilterMode;
{
  Uses the following rules:

  Period = 0:   Display ledger for specified year.

  Period > 100: Display ledger for specified year, up to and including
                including (Period - 100) (i.e. 106 will display ledger for
                periods 1 to 6).

  Period = -98: Display ledger all years and periods.
}
begin
  lstFilterMode := dfInvalid;
  case lstPeriod of
    -98:   lstFilterMode := dfAllPeriods;
    0:     lstFilterMode := dfToYear;
    1..99: lstFilterMode := dfThisPeriod;
  else
    lstFilterMode := dfToPeriod;
  end;

  // Adjust mode for consolidated currency.
  if (lstCurrency = 0) and (lstFilterMode <> dfInvalid) then
    lstFilterMode := TDataFilterMode(Ord(lstFilterMode) + 5);
end;

//-----------------------------------------------------------------------------

function TStockList.ExtFilter: Boolean;
begin
  Result := True;
end;

//-----------------------------------------------------------------------------

procedure TStockList.ExtObjCreate;
begin
  inherited;

  // Create Extended Btrieve Ops sub-object
  New (DataObj, Init);
  ExtObjPtr := DataObj;
  ExtRecPtr := Pointer(1);

  WaitMsgDlg := CreateMessageDialog(
                  'Please Wait...' + #13 + '...Searching...',
                  mtInformation,
                  []
                );

end;

//-----------------------------------------------------------------------------

procedure TStockList.ExtObjDestroy;
begin
  inherited;

  if Assigned(DataObj) then
    Dispose (DataObj, Done);
  DataObj := nil;
  ExtRecPtr := nil;

  if Assigned(WaitMsgDlg) then
    WaitMsgDlg.Free;

end;

//-----------------------------------------------------------------------------

function TStockList.FilterForCustomer(B_End: Integer;
  var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through transaction records. }
var
  Period : Integer;
  Period1xx       : Boolean;
begin
  { Periods > 100 are for the current year only. Subtract 100 to get the
    actual period. }
  Period1xx := (lstPeriod > 100);
  If Period1xx Then
    Period := lstPeriod - 100
  Else
    Period := lstPeriod;

  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. }
  Result := DataObj.Filter03(
              B_End+30,                // Btrieve Operation (+30 = Extended version)
              ScanFileNum,             // File Number
              KeyPath,                 // Index Number
              KeyS,                    // Search Key
              lstFilterMode,
              lstCustCode,
              lstYear,
              Period
            );

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('FilterForCustomer(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

function TStockList.FilterForPeriod(B_End: Integer;
  var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through transaction records. }
var
  Period : Integer;
  Period1xx       : Boolean;
  Currency: Byte;
begin
  { Periods > 100 are for the current year only. Subtract 100 to get the
    actual period. }
  Period1xx := (lstPeriod > 100);
  If Period1xx Then
    Period := lstPeriod - 100
  Else
    Period := lstPeriod;

  Currency := lstCurrency;
  { The Drill-Down spreadsheet function EntStkLocQtyUsed cannot report on
    specific currencies, only on consolidated. To emulate this in the list,
    use an invalid currency value. }
  if ((FunctionCategory in [fcStkLocQtyUsed]) and (Currency <> 0)) then
    Currency := 255;

  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. }
  Result := DataObj.Filter02(
              B_End+30,                // Btrieve Operation (+30 = Extended version)
              ScanFileNum,             // File Number
              KeyPath,                 // Index Number
              KeyS,                    // Search Key
              lstFilterMode,
              lstStockCode,
              Currency,
              lstYear,
              Period
            );

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('FilterForPeriod(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

//-----------------------------------------------------------------------------

function TStockList.GetExtList(B_End: Integer; var KeyS: Str255): Integer;
begin
  if (B_End in [B_GetPrev, B_GetNext]) and Assigned(DataObj) then
  begin
    // Display "Please Wait..." message
//    DispExtMsg(BOn);
//    WaitMsgDlg.Show;
    Screen.Cursor := crHourGlass;
    try

      Result := -1;

      { If we are here, it is because the current record does not match with
        the filter, so use Extended Btrieve to find the next matching record,
        if any. }
      if (FunctionCategory in [fcStkLocQtyUsed]) then
        Result := FilterForPeriod(B_End, KeyS)
      else if (FunctionCategory in [fcCustNetSales]) then
        Result := FilterForCustomer(B_End, KeyS)
      else
        Result := DefaultFilter(B_End, KeyS);

      if (Result = 62) then
        raise Exception.Create('Extended Filter failed because of badly-formed record structure')
      else if (Result = -1) then
        raise Exception.Create('Extended Filter failed because an unknown function category was specified');

    finally
      Screen.Cursor := crDefault;
      // Hide "Please Wait..." message
//      WaitMsgDlg.Hide;
//      DispExtMsg(BOff);
    end;
  end
  else
    Result := Find_Rec(B_End, F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, KeyS);
end;

//-----------------------------------------------------------------------------

function TStockList.OutLine(Col: Byte): Str255;
{ Returns the contents (as a string) of the field in the current record, for
  the specified column in the Btrieve list. }

  function FormatBFloat(FMask: Str255; Value: Double; SBlnk: Boolean): Str255;
  { --- Copied from X:\Entrprse\R&D\SalTxl1U.pas and amended ----------------- }
  begin
    if (Value <> 0.0) or (not SBlnk) then
      Result := FormatFloat(Fmask, Value)
    else
      Result := '';
  end;

  function FormatCurFloat(Fmask: Str255; Value: Double; SBlnk: Boolean;
    Cr: Byte): Str255;
  { --- Copied from X:\Entrprse\R&D\SalTxl1U.pas and amended ----------------- }
  var
    GenStr: Str5;
  begin
    GenStr := '';
    {$IFDEF MC_On}
      GenStr:=SSymb(Cr);
    {$ENDIF}
    if (Value<>0.0) or (not SBlnk) then
      Result := GenStr + FormatFloat(Fmask, Value)
    else
      Result := '';
  end;

  procedure Job_StockEffect(var StockPos: StockPosType);
  { ==== Procedure to artificially show stock as going in/out for
         purchase lines with a job code ==== }

  { --- Copied from X:\Entrprse\R&D\InvCtSuU.pas and amended ----------------- }
  begin
    with Id do
    begin
      if  (not Emptykey(JobCode,JobKeyLen)) and
          (JBCostOn) and
          (DeductQty = 0.0) and
          (IdDocHed in StkInSet + PurchSet) then
      begin
        StockPos[1] := (Qty_OS(Id) * QtyMul) * StkAdjCnst[IdDocHed];
        StockPos[2] := StockPos[1];
      end;
    end;
  end;

  procedure ClearStockPos(var StockPos: StockPosType);
  var
    i: Integer;
  begin
    for i := Low(StockPos) to High(StockPos) do
      StockPos[i] := 0.00;
  end;

{ --- Copied from X:\Entrprse\R&D\SLTI1U.pas and amended --------------------- }
const
  Fnum     =  InvF;
  KeyPath2 =  InvFolioK;
var
  UPCost   : Double;
  StockPos : StockPosType;
  TmpQtyMul: Real;
  TmpQty   : Real;
  Rnum     : Real;
  UOR      : Byte;
  ExLocal  : ^TdExLocal;
begin
  with Id do
  begin
    UPCost := 0.0;
    TmpQty := 0;

    ClearStockPos(StockPos);

    // Check for OSSOR
    if (IdDocHed = SOR) and (lstFunctionCategory in [fcStkQtyOSSOR, fcStkLocQtyOSSOR]) then
      TmpQty := Round_Up((Qty-(QtyDel+QtyWOff)),Syss.NoQtyDec);

    if (TmpQty > 0) then
    begin
      // OSSOR found, enter into array
      StockPos[4] := TmpQty;
    end
    else
    begin
      // No OSSOR, use normal quantity
      ParseQty(StockPos, DeductQty, True);

      // Substitute 'Picked' for 'Allocated'
      if (Syss.UsePick4All) then
        StockPos[3] := StockPos[5];

      { Adjust display for Purch docs with a jobcode present, although
        they have no effect on stock, show as if they went in, and came
        out }
      Job_StockEffect(StockPos);
    end;

    ExLocal := ListLocal;

    DrillUtils.Link2Inv(ExLocal);

    with ExLocal^, LInv do
    begin
      case Col of
        Col_OurRef:    Result := OurRef;
        Col_Date:      Result := POutDate(PDate);
        Col_ACCode:    Result := CustCode;
        Col_QtyIn:     Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[1]),  (StockPos[1] = 0.0));
        Col_QtyOut:    Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[2]),  (StockPos[2] = 0.0));
        Col_Alloc:
          begin
            if (lstFunctionCategory in [fcStkQtyPicked, fcStkLocQtyPicked, fcStkLocWORQtyPicked]) then
              Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[5]),  (StockPos[5] = 0.0))
            else
              Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[3]),  (StockPos[3] = 0.0));
          end;
        Col_OnOrder:   Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[4]),  (StockPos[4] = 0.0));
        Col_AllocWOR:  Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[6]),  (StockPos[6] = 0.0));
        Col_IssuedWOR: Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[7]),  (StockPos[7] = 0.0));
        Col_PickedWOR: Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[8]),  (StockPos[7] = 0.0));
//        Col_SalesRet:  Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[9]),  (StockPos[9] = 0.0));
//        Col_PurchRet:  Result := FormatBFloat(GenQtyMask, CaseQty(Stock, StockPos[10]), (StockPos[10] = 0.0));
        Col_UnitPrice:
          begin
            if (IdDocHed in StkAdjSplit) then
            begin
              if (Qty < 0) then
                TmpQty := -1
              else
                TmpQty := 1;
              Rnum := CostPrice * TmpQty;
            end
            else
            begin
             TmpQty    := Qty;
             TmpQtyMul := QtyMul;

             if (Stock.CalcPack) then
               QtyMul := 1;

             Qty := 1;

             if (IdDocHed in PurchSplit) then
               UPCost := CostPrice;

             Rnum := (DetLTotalND(Id, BOn, BOff, BOn, LInv.DiscSetl) + UPCost) * DocNotCnst;

             Qty    := TmpQty;
             QtyMul := TmpQtyMul;

            end;

            UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);
            Rnum:=Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

            if (not PChkAllowed_In(143)) and (not (IdDocHed in SalesSplit)) then
              Rnum := 0.0;

            Result := FormatCurFloat(GenUnitMask[BOn], Rnum, BOff, self.lstCurrency);
          end;
      else
        Result := '';
      end; { case Col of... }
    end; {With..}
  end; {With..}
end;

//-----------------------------------------------------------------------------

procedure TStockList.ParseQty(var StockPos: StockPosType; DQty: Real;
  ShowSign: Boolean);
{ --- Copied from X:\Entrprse\R&D\InvCtSuU.pas, Stock_Effect(), and amended -- }

{
  Assigns the supplied quantity to the correct element in the StockPos array:

  StockPos[ 1]   Quantity in
  StockPos[ 2]   Quantity out
  StockPos[ 3]   Quantity allocated
  StockPos[ 4]   Quantity on order
  StockPos[ 5]   Quantity picked
  StockPos[ 6]   Quantity allocated to works order
  StockPos[ 7]   Issued less built to works order
  StockPos[ 8]   Issued now to works order
  StockPos[ 9]   +/- ?RN returns level  (Sales)
  StockPos[10]   +/- ?RN returns level  (Purchase)
}
var
  Mode   :  Byte;
  DCnst  :  Integer;
begin
  DCnst := 1;
  with Id do
  begin
    if (ShowSign) and (IdDocHed in StkOpoSet) then
      DCnst := DocNotCnst;

    FillChar(StockPos, Sizeof(StockPos), 0);

    if (not (IdDocHed in [Adj] + StkExcSet)) then
    begin

      Mode := 1 + (1 * Ord(IdDocHed in StkOutSet))
                + (2 * Ord(IdDocHed in StkAllSet))
                + (3 * Ord(IdDocHed in StkOrdSet));

      StockPos[Mode] := (DQty * DCnst);

      if (IdDocHed in StkAllSet) then {* Set Qty Picked value *}
        StockPos[5] := (QtyPick * QtyMul * DCnst);

    end
    else
      if (IdDocHed In [Adj]) then
      begin
        Mode := 1 + Ord(((DQty * StkAdjCnst[IdDocHed]) < 0));

        if (ShowSign) then
          StockPos[Mode] := Abs(DQty)
        else
          StockPos[Mode] := DQty;
      end
      else
        if (IdDocHed = WOR) then
        begin
          StockPos[2] := Qty_Os(Id) * DCnst;
          if (ABSLineNo = 1) then
            StockPos[4] := Qty_Os(Id) * DCnst {If its the first line, we need to increase on order}
          else
            StockPos[6] := Qty_Os(Id) * DCnst; {Allocated to works order}

          StockPos[7] := (QtyDel - QtyWOff) * DCnst; {Issued less built to works order}
          StockPos[8] := QtyPick * DCnst; {Issued now to works order}
        end
        else
          if (IdDocHed In StkRetSplit) then {* Process return *}
          begin
            Mode := 9 + Ord(IdDocHed = PRN);

            StockPos[Mode] := Qty_Os(Id) * DCnst; {+/- ?RN returns level}

            StockPos[1 + Ord((IdDocHed in StkRetPurchSplit))] := (DQty * DCnst);   {PRN auto affects stock out when its returned - replaced by Adj}
          end;

  end; { with Id... }

end;

//-----------------------------------------------------------------------------

function TStockList.SetCheckKey: Str255;
var
  IndexStr: Str255;
begin
  FillChar(IndexStr, Sizeof(IndexStr),0);

  with Id do
  begin
    if (StockCode <> '') then
      IndexStr := FullStockCode(StockCode);
  end;

  Result := IndexStr;
end;

//-----------------------------------------------------------------------------

function TStockList.SetFilter: Str255;
var
  Period: SmallInt;
  TmpQty: Real;
  byLocation: Boolean;
begin
  Result := INCLUDE_IN_DATASET;
  byLocation := (FunctionCategory in [fcStkLocQtyOnOrder,
                                      fcStkLocQtySold,
                                      fcStkLocQtyAllocated,
                                      fcStkLocWORQtyAllocated,
                                      fcStkLocQtyOSSOR,
                                      fcStkLocQtyInStock,
                                      fcStkLocWORQtyIssued,
                                      fcStkLocQtyPicked,
                                      fcStkLocWORQtyPicked,
                                      fcStkLocQtyUsed,
                                      fcCustStkQty,
                                      fcCustStkSales]);

  // Stock Quantity on Order
  if (FunctionCategory in [fcStkQtyOnOrder, fcStkLocQtyOnOrder]) then
  begin
    if not (Id.IdDocHed in StkOrdSet + StkExcSet) then
      Result := EXCLUDE_FROM_DATASET
    else if Round_Up((Id.Qty-(Id.QtyDel+Id.QtyWOff)),Syss.NoQtyDec) = 0 then
      Result := EXCLUDE_FROM_DATASET;
  end
  // Stock Quantity sold
  else if (FunctionCategory in [fcStkQtySold, fcCustStkSales, fcStkLocQtySold, fcCustNetSales]) then
  begin
    if (Id.IdDocHed in PSOPSet+StkAllSet+StkOrdSet+PurchSplit+StkADJSplit) then  
      Result := EXCLUDE_FROM_DATASET
    else if (Trim(CustCode) <> '') and (Trim(CustCode) <> Trim(Id.CustCode)) then
      Result := EXCLUDE_FROM_DATASET
    else
    begin
      if (lstPeriod > 100) Then
        Period := lstPeriod - 100
      else
        Period := lstPeriod;
      case lstFilterMode of
        dfToYear, dfToYearConsolidated:
          if (Id.PYr > lstYear) then
            Result := EXCLUDE_FROM_DATASET;
{
        dfThisYear:
          if (Id.PYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
}
        dfToPeriod, dfToPeriodConsolidated:
          if (Id.PPr > Period) or
             (Id.PYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
        dfThisPeriodConsolidated:
          if (Id.PPr <> Period) or
             (Id.PYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
      end;
    end;
    if (Result = INCLUDE_IN_DATASET) then
      if (Qty_Os(Id) = 0) or (Id.PostedRun = 0) then
        Result := EXCLUDE_FROM_DATASET;
  end
  // Stock Quantity Allocated
  else if (FunctionCategory in [fcStkQtyAllocated,
                                fcStkLocQtyAllocated]) then
  begin
    if (Id.IdDocHed in [Adj] + StkExcSet) or
       (not (Id.IdDocHed in StkAllSet)) then
      Result := EXCLUDE_FROM_DATASET
    else if (Id.DeductQty = 0.00) or
            (Syss.UsePick4All and ((Id.QtyPick * Id.QtyMul) = 0)) then
      Result := EXCLUDE_FROM_DATASET;
  end
  // Stock Quantity Allocated on Works Order
  else if (FunctionCategory in [fcStkWORQtyAllocated,
                                fcStkLocWORQtyAllocated]) then
  begin
    if not (Id.IdDocHed = WOR) then
      Result := EXCLUDE_FROM_DATASET
    else if (Qty_Os(Id) = 0.00) then
      Result := EXCLUDE_FROM_DATASET;
  end
  // Outstanding Sales Orders (OSSOR)
  else if (FunctionCategory in [fcStkQtyOSSOR, fcStkLocQtyOSSOR]) then
  begin
    // Check for OSSOR
    with Id do
    begin
      if (IdDocHed = SOR) then
      begin
        TmpQty := Round_Up((Qty-(QtyDel+QtyWOff)),Syss.NoQtyDec);
        if (TmpQty = 0) then
          Result := EXCLUDE_FROM_DATASET
      end
      else
        Result := EXCLUDE_FROM_DATASET;
    end;
  end
  // Stock Quantity in stock
  else if (FunctionCategory in [fcStkQtyInStock, fcStkLocQtyInStock]) then
  begin
    if not (Id.IdDocHed in [PIN, PCR, PDN, PJC, PJI, PPI, PRF,
                            SIN, SCR, SDN, SJC, SJI, SRF, SRI,
                            ADJ]) then
      Result := EXCLUDE_FROM_DATASET
    else
    begin
      TmpQty := Round_Up(Id.Qty, Syss.NoQtyDec);
      if (TmpQty = 0) then
        Result := EXCLUDE_FROM_DATASET
    end;
  end
  // Customer Stock Quantity
  else if (FunctionCategory in [fcCustStkQty]) then
  begin
    if not (Id.IdDocHed in [PIN, PCR, PDN, PJC, PJI, PPI, PRF,
                            SIN, SCR, SDN, SJC, SJI, SRF, SRI,
                            ADJ]) then
      Result := EXCLUDE_FROM_DATASET
    else if (Trim(CustCode) <> Trim(Id.CustCode)) then
      Result := EXCLUDE_FROM_DATASET
    else
    begin
      if (lstPeriod > 100) Then
        Period := lstPeriod - 100
      else
        Period := lstPeriod;
      case lstFilterMode of
        dfToYear, dfToYearConsolidated:
          if (Id.PYr > lstYear) then
            Result := EXCLUDE_FROM_DATASET;
{
        dfThisYear:
          if (Id.PYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
}
        dfToPeriod, dfToPeriodConsolidated:
          if (Id.PPr > Period) or
             (Id.PYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
        dfThisPeriodConsolidated:
          if (Id.PPr <> Period) or
             (Id.PYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
      end;
    end;
    if (Result = INCLUDE_IN_DATASET) then
    begin
      TmpQty := Round_Up(Id.Qty, Syss.NoQtyDec);
      if (TmpQty = 0) then
        Result := EXCLUDE_FROM_DATASET
    end;
  end
  // Stock Quantity issued on Works Order
  else if (FunctionCategory in [fcStkWORQtyIssued, fcStkLocWORQtyIssued]) then
  begin
    if (Id.IdDocHed <> WOR) then
      Result := EXCLUDE_FROM_DATASET
    else if (Id.QtyDel - Id.QtyWOff) = 0 then
      Result := EXCLUDE_FROM_DATASET;
  end
  // Stock Quantity picked
  else if (FunctionCategory in [fcStkQtyPicked, fcStkLocQtyPicked]) then
  begin
    if not (Id.IdDocHed in StkAllSet) then
      Result := EXCLUDE_FROM_DATASET
    else if ((Id.QtyPick * Id.QtyMul) = 0) then
      Result := EXCLUDE_FROM_DATASET;
  end
  // Stock Quantity picked on Works Order
  else if (FunctionCategory in [fcStkWORQtyPicked,
                                fcStkLocWORQtyPicked]) then
  begin
    if (Id.IdDocHed <> WOR) then
      Result := EXCLUDE_FROM_DATASET
    else if Id.QtyPick = 0 then
      Result := EXCLUDE_FROM_DATASET;
  end
  // Stock Quantity used (stock items used in BOMs)
  else if (FunctionCategory in [fcStkQtyUsed, fcStkLocQtyUsed]) then
  begin
    { Quantity Out on Adjustments and certain Sales Invoices. }
    if not (Id.IdDocHed in [ADJ, SIN]) then
      Result := EXCLUDE_FROM_DATASET
    { Only include SIN transactions with a Posted Run Number of 0 (these are
      invoices for BOMs where the BOM was not currently in stock and therefore
      the items had to be taken out of stock to make up the BOM). }
    else if ((Id.IdDocHed in [SIN]) and not (ID.PostedRun = 0)) then
      Result := EXCLUDE_FROM_DATASET
    else if Id.Qty = 0 then
      Result := EXCLUDE_FROM_DATASET;
  end
  else
    // Invalid Function Category -- should never happen.
  ;

  // Check location
  if ((Result = INCLUDE_IN_DATASET) and byLocation) and
     (Trim(lstLocation) <> '') and
     (Id.MLocStk <> lstLocation) then
    Result := EXCLUDE_FROM_DATASET;

  // Check Cost Centre
  if (Result = INCLUDE_IN_DATASET) and
     (Trim(lstCostCentre) <> '') and
     (Id.CCDep[True] <> lstCostCentre) then
    Result := EXCLUDE_FROM_DATASET;

  // Check Department
  if (Result = INCLUDE_IN_DATASET) and
     (Trim(lstDepartment) <> '') and
     (Id.CCDep[False] <> lstDepartment) then
    Result := EXCLUDE_FROM_DATASET;

end;

//-----------------------------------------------------------------------------

//=============================================================================
// TfrmStock
//=============================================================================

procedure TfrmStock.BtListLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ListPoint: TPoint;
begin
  if (Sender is TSBSPanel) then
    with (Sender as TSBSPanel) do
    begin
      if (not ReadyToDrag) and (Button = mbLeft) then
      begin
        if Assigned(BtList) then
          BtList.VisiList.PrimeMove(Sender);
        NeedCUpdate := BOn;
      end
      else
        if (Button = mbRight) Then
        begin
          ListPoint := ClientToScreen(Point(X, Y));
          ShowRightMenu(ListPoint.X, ListPoint.Y, 0);
        end;
    end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.BtListLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Sender is TSBSPanel) then
    with (Sender as TSBSPanel) do
    begin
      if Assigned(BtList) then
      begin
        BtList.VisiList.MoveLabel(X,Y);
        NeedCUpdate := BtList.VisiList.MovingLab;
      end;
    end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.BtListPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  BarPos    : Integer;
  PanRSized : Boolean;
begin
  if (Sender is TSBSPanel) then
    with (Sender as TSBSPanel) do
    begin
      PanRSized := ReSized;

      BarPos := BtListBox.HorzScrollBar.Position;

      if (PanRsized) then
        BtList.ResizeAllCols(BtList.VisiList.FindxHandle(Sender), BarPos);

      BtList.FinishColMove(BarPos + (ListOffset * Ord(PanRSized)), PanRsized);

      NeedCUpdate := (BtList.VisiList.MovingLab or PanRSized);
    end; { With (Sender as TSBSPanel) }
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.btnViewLineClick(Sender: TObject);
begin
  ViewTransactionClick(Sender);
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.BuildList;
var
  StartPanel: TSBSPanel;
  n         : Byte;
begin
  // This routine is called each time the Drill-Down is performed
  // even if the window is already visible.  To prevent problems any
  // existing BtList is destroyed and a new one is created
  if Assigned(BtList) then
  begin
    BtList.Destroy;
    BtList := nil;
  end;

  BtList := TStockList.Create(Self);

  // Assign filter properties
  BtList.Currency         := stkCurrency;
  BtList.FunctionCategory := stkFunctionCategory;
  BtList.Location         := stkLocation;
  BtList.Period           := stkPeriod;
  BtList.StockCode        := stkStockCode;
  BtList.CustCode         := stkCustCode;
  BtList.Year             := stkYear;
  BtList.Period           := stkPeriod;
  BtList.CostCentre       := stkCostCentre;
  BtList.Department       := stkDepartment;

  with BtList do
  begin
    try
      DetermineFilterMode;
      with VisiList do
      begin

        AddVisiRec(CLORefPanel,   CLORefLab);   //  0 Our Ref
        AddVisiRec(CLDatePanel,   CLDateLab);   //  1 Date
        AddVisiRec(CLACPanel,     CLACLab);     //  2 A/C Code
        AddVisiRec(CLQIPanel,     CLQILab);     //  3 Quantity In
        AddVisiRec(CLQOPanel,     CLQOLab);     //  4 Quantity Out
        AddVisiRec(CLALPanel,     CLALLab);     //  5 Allocated
        AddVisiRec(CLOOPanel,     CLOOLab);     //  6 Outstanding
        AddVisiRec(CLAWPanel,     CLAWLab);     //  7 Allocated WOR
        AddVisiRec(CLIWPanel,     CLIWLab);     //  8 Issued WOR
        AddVisiRec(CLPWPanel,     CLPWLab);     //  9 Picked WOR
        AddVisiRec(CLSRPanel,     CLSRLab);     // 10 Sales Ret.
        AddVisiRec(CLPRPanel,     CLPRLab);     // 11 Purchase Ret.
        AddVisiRec(CLUPPanel,     CLUPLab);     // 12 Unit Price


        if (lstFunctionCategory in [fcStkQtyOnOrder, fcStkLocQtyOnOrder]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          SetHidePanel(Col_Alloc,      True, False);
          { Col_OnOrder is visible }
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkQtySold, fcStkQtyUsed, fcStkLocQtySold, fcStkLocQtyUsed, fcCustStkSales, fcCustNetSales]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          { Col_QtyOut is visible }
          SetHidePanel(Col_Alloc,      True, False);
          SetHidePanel(Col_OnOrder,    True, False);
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkQtyAllocated, fcStkLocQtyAllocated]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          { Col_Alloc is visible }
          SetHidePanel(Col_OnOrder,    True, False);
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkQtyOSSOR, fcStkLocQtyOSSOR]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          SetHidePanel(Col_Alloc,      True, False);
          { Col_OnOrder is visible }
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkQtyInStock, fcStkLocQtyInStock, fcCustStkQty]) then
        begin
          { Col_QtyIn is visible }
          { Col_QtyOut is visible }
          SetHidePanel(Col_Alloc,      True, False);
          SetHidePanel(Col_OnOrder,    True, False);
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkQtyPicked, fcStkLocQtyPicked]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          { Col_Alloc is visible }
          SetHidePanel(Col_OnOrder,    True, False);
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkWORQtyAllocated, fcStkLocWORQtyAllocated]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          SetHidePanel(Col_Alloc,      True, False);
          SetHidePanel(Col_OnOrder,    True, False);
          { Col_AllocWOR is visible }
          SetHidePanel(Col_IssuedWOR,  True, False);
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkWORQtyIssued, fcStkLocWORQtyIssued]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          SetHidePanel(Col_Alloc,      True, False);
          SetHidePanel(Col_OnOrder,    True, False);
          SetHidePanel(Col_AllocWOR,   True, False);
          { Col_IssuedWOR is visible }
          SetHidePanel(Col_PickedWOR,  True, False);
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;
        if (lstFunctionCategory in [fcStkWORQtyPicked, fcStkLocWORQtyPicked]) then
        begin
          SetHidePanel(Col_QtyIn,      True, False);
          SetHidePanel(Col_QtyOut,     True, False);
          SetHidePanel(Col_Alloc,      True, False);
          SetHidePanel(Col_OnOrder,    True, False);
          SetHidePanel(Col_AllocWOR,   True, False);
          SetHidePanel(Col_IssuedWOR,  True, False);
          { Col_PickedWOR is visible }
          SetHidePanel(Col_SalesRet,   True, False);
          SetHidePanel(Col_PurchRet,   True, True);
        end;

        VisiRec := List[0];

        StartPanel  := (VisiRec^.PanelObj as TSBSPanel);
        LabHedPanel := BtListHeaderPanel;
        SetHedPanel(ListOffSet);

      end;
    except
      VisiList.Free;
      raise;
    end;

    if (lstFunctionCategory in [fcCustNetSales]) then
    begin
      MainPage.TabVisible    := False;
      MainPage.Visible       := False;
      WOPPage.TabVisible     := False;
      WOPPage.Visible        := False;
      ReturnsPage.TabVisible := False;
      ReturnsPage.Visible    := False;
    end;

    TabOrder := -1;
    TabStop := BOff;
    Visible := BOff;
    BevelOuter := bvNone;
    ParentColor := False;
    Color := StartPanel.Color;
    MUTotCols := 12;
    Font := StartPanel.Font;

    LinkOtherDisp := BOn;
    WM_ListGetRec := WM_CustGetRec;
    Parent        := StartPanel.Parent;
    MessHandle    := Self.Handle;

    for n := 0 to MUTotCols do
    with ColAppear^[n] do
    begin
      AltDefault := BOn;
      if (n in [3..9, 12]) then
      begin
        DispFormat := SGFloat;
        case n of
          3, 4, 5, 6..9:  NoDecPlaces := Syss.NoQtyDec;
          12:             NoDecPlaces := Syss.NoNetDec;
        end; {Case..}
      end;
    end;

    DisplayMode  := 2;
    Filter[1, 0] := #1;
    ListLocal    := @ExLocal;

    ListCreate;

    Set_Buttons(BtListBtnPanel);

    if (FunctionCategory = fcStkQtyOSSOR) then
      CLOOLab.Caption := 'OSSOR '
    else
      CLOOLab.Caption := 'On Order ';

    if (FunctionCategory in [fcStkQtyPicked, fcStkLocQtyPicked]) then
      CLALLab.Caption := 'Picked'
    else
      CLALLab.Caption := 'Allocated';

    RefreshList(not FromHistory, BOff);

  end; {With}

  // Resize the form
  Width       := CLUPPanel.Left + 244;
  ReadFormPos := False;
  FindFormCoords;
  FormReSize(Self);

end;

//-----------------------------------------------------------------------------

function TfrmStock.CheckListFinished: Boolean;
var
  mbRet: Word;
begin
  Result := BOn;
  if Assigned(BtList) then
    Result := not BtList.ListStillBusy;

  if (not Result) then
  begin
    mbRet := MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',
                        mtConfirmation,
                        [mbYes,mbNo],
                        0);
    if (mBRet = mrYes) then
    begin
      BtList.IRQSearch := BOn;
      ShowMessage('Please wait a few seconds, then try closing again.');
    end;

  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.DisplayTransactions(const IdFolio: LongInt; const DataChanged: Boolean);
var
  KeyS    : Str255;
  lStatus : SmallInt;
begin
  // Find Transaction
  KeyS := FullNomKey (IdFolio);
  lStatus := Find_Rec (B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);

  if (lStatus = 0) and (not (Inv.InvDocHed In NomSplit + StkAdjSplit + TSTSplit)) then
  begin
    // Find Customer Record
    KeyS := FullCustCode(Inv.CustCode);
//    lStatus := Find_Rec (B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
    Find_Rec (B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
  end; { If (lStatus = 0) }

  if (lStatus = 0) then
  begin
    // Check the transaction display manager has been created
    if not Assigned (DisplayTrans) then
      DisplayTrans := TfrmDisplayTransManager.Create(Application);

    // Display the Transaction
    DisplayTrans.Display_Trans(Inv, Cust, DataChanged);
  end; { If (lStatus = 0) }
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FindFormCoords;
var
  ThisForm   : TForm;
  GlobComp   : TGlobCompRec;
begin
  if (not ReadFormPos) then
  begin
    New(GlobComp, Create(BOn));

    ThisForm := self;

    with GlobComp^ do
    begin
      GetValues := BOn;
      PrimeKey := Format('S%2d', [Ord(FStkFunctionCategory)]);

      if (GetbtControlCsm(ThisForm)) then
      begin
        StoreCoord := BOff;
        HasCoord   := (HLite = 1);
        LastCoord  := HasCoord;
        if (HasCoord) then
          SetPosition(ThisForm);
      end;

//      GetbtControlCsm(PageControl);
//      GetbtControlCsm(BtListBox);
//      GetbtControlCsm(BtListBtnPanel);
      GetbtControlCsm(BtListHeaderPanel);
      BtList.Find_ListCoord(GlobComp);

    end; { with GlobComp^ }

    with BtList.VisiList do
      LabHedPanel.Color := IdPanel(0,BOn).Color;

    Dispose(GlobComp,Destroy);

    StartSize.X := Width;
    StartSize.Y := Height;
    ReadFormPos := True;
  end; { if (not ReadFormPos) }
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmStock := nil;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  n: Integer;
begin
  CanClose := CheckListFinished;
  if CanClose then
  begin
    for n := 0 to Pred(ComponentCount) do
      if (Components[n] is TScrollBox) then
        with TScrollBox(Components[n]) do
        begin
          VertScrollBar.Position:=0;
          HorzScrollBar.Position:=0;
        end;
    VertScrollBar.Position := 0;
    HorzScrollBar.Position := 0;
    if (NeedCUpdate or SetDefault) then
      StoreFormCoords(not SetDefault);
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FormCreate(Sender: TObject);
begin
  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.AddReferenceCount;

  DescLineControls[1] := SRD1F;
  DescLineControls[2] := SRD2F;
  DescLineControls[3] := SRD3F;
  DescLineControls[4] := SRD4F;
  DescLineControls[5] := SRD5F;
  DescLineControls[6] := SRD6F;

  BtList := TStockList.Create(Self);

  { Record the initial form size. }
  self.ClientHeight := 356;
  self.ClientWidth := 716;
  InitSize.Y := self.Height;
  InitSize.X := self.Width;

  { Fix the form so that it cannot be shorter than the initial height, and
    cannot be wider than the initial width. }
  Constraints.MinHeight := InitSize.Y - 1;
  Constraints.MinWidth  := 580;
  Constraints.MaxWidth  := InitSize.X;

  LastCoord   := False;
  NeedCUpdate := False;
  ReadFormPos := False;
  DoneRestore := False;
  StoreCoord  := False;
  SetDefault  := False;

  SRSP1F.DecPlaces := Syss.NoNetDec;
  SRCPF.DecPlaces  := Syss.NoCosDec;
  SRRPF.DecPlaces  := Syss.NoCosDec;
  SRMIF.DecPlaces  := Syss.NoQtyDec;
  SRMXF.DecPlaces  := Syss.NoQtyDec;
  SRISF.DecPlaces  := Syss.NoQtyDec;
  SRPOF.DecPlaces  := Syss.NoQtyDec;
  SRALF.DecPlaces  := Syss.NoQtyDec;
  SRFRF.DecPlaces  := Syss.NoQtyDec;
  SROOF.DecPlaces  := Syss.NoQtyDec;
  SRAWF.DecPlaces  := Syss.NoQtyDec;
  SRIWF.DecPlaces  := Syss.NoQtyDec;
  SRPWF.DecPlaces  := Syss.NoQtyDec;

  FromHistory := False;

  ExLocal.Create;

  PageControl.ActivePage := LedgerPage;

  StoreBtListCoords;

  StartSize.X := Width;
  StartSize.Y := Height;

  if EnterpriseLicence.elModules[modProWOP] = mrNone then
    WOPPage.TabVisible := False;

  if EnterpriseLicence.elModules[modGoodsRet] = mrNone then
    ReturnsPage.TabVisible := False;

  ListOffset := 0;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FormDestroy(Sender: TObject);
begin
  FreeList;
  if Assigned(DisplayTrans) then
    FreeAndNil(DisplayTrans);
  frmStock := nil;

  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.RemoveReferenceCount;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FormResize(Sender: TObject);
begin
//  if GotCoord then
  if ReadFormPos then
  begin
    if Assigned(BtList) then
      BtList.LinkOtherDisp:=BOff;

    self.HorzScrollBar.Position := 0;
    self.VertScrollBar.Position := 0;

    // Adjust the size of the page control
    PageControl.Width  := Width  - PagePoint[1].X;
    PageControl.Height := Height - PagePoint[1].Y;

    // Adjust the size of the scroll box
    BtListBox.Width  := LedgerPage.Width  - PagePoint[2].X;
    BtListBox.Height := LedgerPage.Height - PagePoint[2].Y;

    // Resize the Btrieve navigation bar
    BtListBtnPanel.Left   := LedgerPage.Width  - PagePoint[3].X;
    BtListBtnPanel.Height := LedgerPage.Height - PagePoint[3].Y;

    // Reposition the main button panel
    BtnPanel.Left := PageControl.Width - (BtnPanel.Width + 4);
    BtnPanel.Height := BtListBox.Height;

    // Adjust the height of the Btrieve List columns
    if Assigned(BtList) then
    begin

      with BtList.VisiList do
      begin
        VisiRec := List[0];
        with (VisiRec^.PanelObj as TSBSPanel) do
          Height := BtListBtnPanel.Height;
      end; { with BtList.VisiList...  }

      with BtList do
      begin
        ReFresh_Buttons;
        RefreshAllCols;
      end; { with BtList... }

      BtList.LinkOtherDisp := BOn;
    end; { if Assigned(BtList)... }

    NeedCUpdate := ((StartSize.X <> Width) or (StartSize.Y <> Height));

  end; { if GotCoord... }
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.FreeList;
begin
  BtList.Destroy;
  BtList := nil;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetCostCentre: ShortString;
begin
  Result := FstkCostCentre;
end;

function TfrmStock.GetCurrency: Byte;
begin
  Result := FstkCurrency;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetCustCode: ShortString;
begin
  Result := FstkCustCode;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetDepartment: ShortString;
begin
  Result := FstkDepartment;
end;

function TfrmStock.GetFunctionCategory: TEnumFunctionCategory;
begin
  Result := FstkFunctionCategory;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetLocation: ShortString;
begin
  Result := FstkLocation;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetPeriod: SmallInt;
begin
  Result := FstkPeriod;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetStockCode: ShortString;
begin
  Result := FstkStockCode;
end;

//-----------------------------------------------------------------------------

function TfrmStock.GetYear: SmallInt;
begin
  Result := FstkYear;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.PropFlgClick(Sender: TObject);
begin
//  SetFormProperties;
end;

//-----------------------------------------------------------------------------

// CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
procedure TfrmStock.RefreshList(ShowLines, IgnoreMessages: Boolean);
var
  KeyStart: Str255;
  LKeyLen, KPath: Integer;
  Where: WideString;
  CompareYear: string;
  ComparePeriod: string;
begin

  { Select the appropriate index and search key }
  if (stkFunctionCategory in [fcCustNetSales]) then
  begin
    KPath    := IdCAnalK;
    KeyStart := '';
    Where    := '';

    // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
    if SQLUtils.UsingSQL and SQLUtils.UsingSQLAlternateFuncs and
       SQLReportsConfiguration.UseEntCustNetSalesOptimisation then
    begin
      {
        Specific year:          dfThisPeriod, dfToPeriod
        Up to specific year:    dfToYear
        Any year:               dfAllPeriods
      }
      if (BTList.lstFilterMode in [dfThisPeriod, dfThisPeriodConsolidated,
                 dfToPeriod,   dfToPeriodConsolidated]) then
          CompareYear := Format('tlYear = %d', [BTList.lstYear])
      else if (BTList.lstFilterMode in [dfToYear, dfToYearConsolidated]) then
          CompareYear := Format('tlYear <= %d', [BTList.lstYear])
      else
          CompareYear := 'tlYear >= 0';

      {
        Specific period:        dfThisPeriod
        Up to specified period: dfToPeriod
        Any period:             dfAllPeriods, dfToYear
      }
      if (BTList.lstFilterMode in [dfThisPeriod, dfThisPeriodConsolidated]) then
          ComparePeriod := Format('tlPeriod = %d', [BTList.lstPeriod])
      else if (BTList.lstFilterMode in [dfToPeriod, dfToPeriodConsolidated]) then
          ComparePeriod := Format('tlPeriod <= %d', [BTList.lstPeriod])
      else
          ComparePeriod := 'tlPeriod >= 0';

      Where := CompareYear + ' AND ' +
               ComparePeriod + ' AND ' +
               'tlAcCode = ' + QuotedStr(BTList.lstCustCode);

    end;
  end
  else
  begin
    KPath    := IdStkK;
    KeyStart := FullStockCode(stkStockCode);
  end;

  LKeyLen := Length(KeyStart);
  BtList.IgnoreMsg := IgnoreMessages;

  { Display the first page of records }
  BtList.StartList(IdetailF, KPath, KeyStart, '', '', LKeyLen, (not ShowLines), Where);

  BtList.IgnoreMsg := BOff;

end;

//-----------------------------------------------------------------------------

procedure TfrmStock.ResetCoordinates1Click(Sender: TObject);
begin
  if ResetCoordinates1.Checked then
  begin
    SetDefault := True;
    StoreCoordFlg.Checked := False;
  end
  else
    SetDefault := False;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetCostCentre(const Value: ShortString);
begin
  FstkCostCentre    := Value;
  BtList.CostCentre := Value;
end;

procedure TfrmStock.SetCurrency(const Value: Byte);
begin
  FstkCurrency    := Value;
  BtList.Currency := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetCustCode(const Value: ShortString);
begin
  FstkCustCode    := Value;
  BtList.CustCode := Value;
end;

(*
//-----------------------------------------------------------------------------

procedure TfrmStock.SetFormProperties;
var
  TmpPanel                   : Array[1..3] of TPanel;
  n                          : Byte;
  ResetDefaults, BeenChange  : Boolean;
  ColourCtrl                 : TCtrlColor;
begin
  ResetDefaults := BOff;

  for n := 1 to 3 do
  begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    With BtList.VisiList do
    Begin
      VisiRec := List[0];

      TmpPanel[1].Font  := (VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color := (VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font  := (VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color := (VisiRec^.LabelObj as TSBSPanel).Color;

      TmpPanel[3].Color := BtList.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);
    TmpPanel[3].Font.Color := BtList.ColAppear^[0].HTextColor;

    ColourCtrl := TCtrlColor.Create(Self);
    try
      with ColourCtrl do
      Begin
        SetProperties(TmpPanel[1], TmpPanel[2], TmpPanel[3], 1,
                      'List Properties', BeenChange, ResetDefaults);

        NeedCUpdate := (BeenChange or ResetDefaults);

        if (BeenChange) and (not ResetDefaults) then
        begin
          for n:=1 to 3 do
            with TmpPanel[n] do
              case n of
                1, 2: BtList.ReColorCol(Font, Color, (n = 2));

                3   : BtList.ReColorBar(Font, Color);
              end; {Case..}

          BtList.VisiList.LabHedPanel.Color := TmpPanel[2].Color;
        end;
      end;
    finally
      ColourCtrl.Free;
    end; { with ColourCtrl do... }
  finally
    for n := 1 to 3 do
      TmpPanel[n].Free;
  end;

  if (ResetDefaults) then
  begin
    SetDefault := BOn;
    Close;
  end;
end;
*)

//-----------------------------------------------------------------------------

procedure TfrmStock.SetDepartment(const Value: ShortString);
begin
  FstkDepartment    := Value;
  BtList.Department := Value;
end;

procedure TfrmStock.SetFunctionCategory(
  const Value: TEnumFunctionCategory);
begin
  FstkFunctionCategory    := Value;
  BtList.FunctionCategory := Value;
  Caption := FuncTitles[FstkFunctionCategory];
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetLocation(const Value: ShortString);
begin
  FstkLocation    := Value;
  BtList.Location := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetNeedCUpdate(const Value: Boolean);
begin
  FNeedCUpDate := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetPeriod(const Value: SmallInt);
begin
  FstkPeriod    := Value;
  BtList.Period := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetStockCode(const Value: ShortString);
var
  Status: LongInt;
  Key: Str255;
begin
  FstkStockCode    := Value;
  BtList.StockCode := Value;

  { Locate the stock code record }
  Key := FullStockCode(BtList.StockCode);
  Status := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);

  { Update the record page display }
  if (Status = 0) then
  begin
    UpdateMainPage;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.SetYear(const Value: SmallInt);
begin
  FstkYear    := Value;
  BtList.Year := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.ShowRightMenu(X, Y, Mode: Integer);
begin
  with PopUpMenu Do
    PopUp(X,Y);
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.StoreBtListCoords;
begin
  // Record co-ordinates for resizing the page control
  PagePoint[1].X := Width  - PageControl.Width;
  PagePoint[1].Y := Height - PageControl.Height;

  // Record co-ordinates for resizing the scroll box
  PagePoint[2].X := LedgerPage.Width  - BtListBox.Width;
  PagePoint[2].Y := LedgerPage.Height - BtListBox.Height;

  // Record co-ordinates for resizing and repositioning the Btrieve List
  // navigation panel and the Btrieve List columns.
  PagePoint[3].X := LedgerPage.Width  - BtListBtnPanel.Left;
  PagePoint[3].Y := LedgerPage.Height - BtListBtnPanel.Height;

  GotCoord := BOn;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.StoreCoordFlgClick(Sender: TObject);
begin
  if StoreCoordFlg.Checked then
  begin
    SetDefault                := False;
    ResetCoordinates1.Checked := False;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.StoreFormCoords(UpdateMode: Boolean);
var
  GlobComp:  TGlobCompRec;
begin
  New(GlobComp, Create(BOff));

  with GlobComp^ do
  begin
    GetValues := UpdateMode;

    PrimeKey := Format('S%2d', [Ord(FStkFunctionCategory)]);

    ColOrd    := Ord(StoreCoordFlg.Checked);
    HLite     := Ord(LastCoord);
    SaveCoord := StoreCoordFlg.Checked;

    if (not LastCoord) then
      HLite := ColOrd;
    StorebtControlCsm(self);
//    StorebtControlCsm(PageControl);
//    StorebtControlCsm(BtListBox);
//    StorebtControlCsm(BtListBtnPanel);
    StorebtControlCsm(BtListHeaderPanel);
    BtList.Store_ListCoord(GlobComp);
  End; { with GlobComp^ do... }

  Dispose(GlobComp,Destroy);
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.UpdateMainPage;

  { --- Copied from X:\Entrprse\R&D\StockU.pas and amended ------------------- }
  function CalcGP(BNo: Byte): Double;
  begin
    with Stock, SaleBands[BNo] do
    begin
      if ((SalesPrice <> 0) and ChkAllowed_In(143)) then
        Result := Stock_Gp(CostPrice, Currency_ConvFT(SalesPrice, Currency,
                                                      PCurrency, UseCoDayRate),
                           BuyUnit, SellUnit, Ord(Syss.ShowStkGP), CalcPack)
      else
        Result := 0;
    end;
  end;

  { --- Copied from X:\Entrprse\R&D\WOPCt1U.pas and amended ------------------ }
  procedure Time2Mins(var MTime: LongInt; var Days, Hrs, Mins: Extended);
  var
    TimeLeft: Extended;
  begin
    Days     := Trunc(MTime/1440);
    TimeLeft := Round(MTime-(Days*1440));
    Hrs      := Trunc(TimeLeft/60);
    Mins     := Round(TimeLeft-(Hrs*60));
  end;

  { --- Copied from X:\Entrprse\R&D\StockU.pas and amended ------------------ }
  procedure Out_GLDesc(GLCode: LongInt; OutObj:  Text8pt);
  var
    FoundOk: Boolean;
    Status: LongInt;
    NomCode: Str255;
  begin
    NomCode := FullNomKey(GLCode);
    if ((Nom.NomCode <> GLCode) and (GLCode <> 0)) then
    begin
      Status := Find_Rec(B_GetEq, F[NomF], NomF, RecPtr[NomF]^, NomCodeK, NomCode);
      FoundOk := (Status = 0);
    end
    else
      FoundOk := (GLCode <> 0);

    if (FoundOk) then
      OutObj.Text := Nom.Desc
    else
      OutObj.Text := '';
  end;

  { --- Copied from X:\Entrprse\R&D\InvList3U.pas and amended --------------- }
  function LinkMLoc_Stock(lc: Str10; sc: Str20; var TSL: MStkLocType): Boolean;
  const
    Fnum      =  MLocF;
    Keypath   =  MLSecK;
  var
    KeyS,
    KeyChk     :  Str255;
    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;
    TmpMLoc    :  MLocRec;
  begin
    TmpMLoc := MLocCtrl^;

    Blank(TSL,Sizeof(TSL));

    Result := BOff;

    KeyChk := PartCCKey(CostCCode, CSubCode[BOff]) +
              Full_MLocKey(lc) +
              FullStockCode(sc);
    KeyS   := KeyChk;

    TmpKPath := GetPosKey;
    TmpStat  := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOff, BOff);
    TmpStat  := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    if (TmpStat = 0) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)) then
    begin
      Result := BOn;
      TSL    := MLocCtrl^.MStkLoc;
    end;

    TmpStat   := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOn, BOff);
    MLocCtrl^ := TmpMLoc;
    
  end;

  { --- Copied from X:\Entrprse\R&D\InvList3U.pas and amended --------------- }
  procedure Stock_LocSubst(var StockR: StockRec; Location: Str10);
  var
   TSL    : MStkLocType;
   TLL    : MLocLocType;
   n      : Byte;
   FoundOk: Boolean;
  begin
    if (Syss.UseMLoc) and
       (not EmptyKey(Location, MLocKeyLen)) and
       (not EmptyKey(StockR.StockCode, StkKeyLen)) then
    with StockR, TSL do
    begin
       FoundOk      := LinkMLoc_Stock(Location, StockCode, TSL);
       QtyInStock   := lsQtyInStock;
       QtyAllocated := lsQtyAlloc;
       QtyOnOrder   := lsQtyOnOrder;
       QtyPosted    := lsQtyPosted;
       QtyPicked    := lsQtyPicked;
       QtyAllocWOR  := lsQtyAllocWOR;
       QtyIssueWOR  := lsQtyIssueWOR;
       QtyPickWOR   := lsQtyPickWOR;
       QtyMin       := lsQtyMin;
       QtyMax       := lsQtyMax;
       QtyReturn    := lsQtyReturn;
       QtyPReturn   := lsQtyPReturn;
    end;
  end;

var
  i: Integer;
  Desc: ShortString;
  PricingType: Integer;
  ValuationMethod: Integer;
  Commit: Double;
  CrDr: DrCrDType;
  D, H, M: Extended;
  Yr, Pr: SmallInt;
begin
  SRCF.Text := Strip('B', [#32], Stock.StockCode);

  { Codes taken from X:\Entrprse\R&D\SysU2.pas, function StkPT2I }
  if Stock.StockType = StkDescCode then
    SRTF.Text := StockTypeDescs[1]
  else if Stock.StockType = StkGrpCode then
    SRTF.Text := StockTypeDescs[2]
  else if Stock.StockType = StkDListCode then
    SRTF.Text := StockTypeDescs[3]
  else if Stock.StockType = StkBillCode then
    SRTF.Text := StockTypeDescs[4]
  else
    SRTF.Text := StockTypeDescs[0];

{
  If (Not FullStkSysOn) and (Result > 0)  then
    Result := Pred(Result);
}

  if (Trim(stkLocation) <> '') then
    Stock_LocSubst(Stock, stkLocation );

  { Description lines }
  for i := Low(DescLineControls) to High(DescLineControls) do
  begin
    Desc := Stock.Desc[i];
    DescLineControls[i].Text := Desc;
  end;

  { Pricing type. Codes taken from X:\Entrprse\R&D\StockU.pas,
    function SetPricing and function Outstock, and X:\Entrprse\R&D\BtSupU2.pas,
    function StkPriceIndex. }
  PricingType := StkPriceIndex(Stock);
  case PricingType of
    0: txtStockPricing.Text := 'Stock Unit - ' + Stock.UnitK;
    1: txtStockPricing.Text := 'Sales Unit - ' + Stock.UnitS;
    2: txtStockPricing.Text := 'Split Pack - ' + Stock.UnitP;
  end;

  { Sales }
  SRSP1F.CurrencySymb := PSymb(Stock.SaleBands[1].Currency);
  SRSP1F.Value        := Stock.SaleBands[1].SalesPrice;
  SRGP1.Value         := CalcGP(1);

  { Cost & Re-order Cost }
  SRCPCF.Text := ExtractWords(1, 1, STDCurrList[Pred(Stock.PCurrency)]);
  SRRPCF.Text := ExtractWords(1, 1, STDCurrList[Pred(Stock.ROCurrency)]);
  if PChkAllowed_In(143) then
  begin
    SRCPF.Value := Stock.CostPrice;
    SRRPF.Value := Stock.ROCPrice;
  end
  else
  begin
    SRCPF.Value := 0.00;
    SRRPF.Value := 0.00;
  end;

  { Valuation method. }
  ValuationMethod := StkVM2I(SetStkVal(Stock.StkValType, Stock.SerNoWAvg, BOn));
  SRVMF.Text      := StockValuationMethods[ValuationMethod];

  { Multibin flag }
  SRMBF.Checked := Stock.MultiBinMode;

  { Min & Max quantities }
  SRMIF.Value := CaseQty(Stock, Stock.QtyMin);
  SRMXF.Value := CaseQty(Stock, Stock.QtyMax);

  { Stock quantities }
  if (stkYear <> 0) then
  begin
    Yr := stkYear;
    Pr := stkPeriod;
  end
  else
  begin
    Yr := GetLocalPr(0).Cyr;
    Pr := GetLocalPr(0).CPr;
  end;
  Profit_to_Date(
    Calc_AltStkHCode(Stock.StockType),
    CalcKeyHist(Stock.StockFolio, stkLocation),
    0,
    Yr,
    Pr,
    CrDr[BOff],
    CrDr[BOn],
    Commit,
    BOn
  );
  SRISF.Value := CaseQty(Stock, Stock.QtyInStock);
  SRPOF.Value := CaseQty(Stock, Commit);
  SRALF.Value := CaseQty(Stock, AllocStock(Stock));
  SRFRF.Value := CaseQty(Stock, FreeStock(Stock));
  SROOF.Value := CaseQty(Stock, Stock.QtyOnOrder);

  SRSPF.Checked := Stock.DPackQty;

  { Works Order Processing }
  Time2Mins(Stock.ProdTime, D, H, M);
  SRASSDF.Value := D;
  SRASSHF.Value := H;
  SRASSMF.Value := M;

  SRROLTF.Value := Stock.LeadTime;
  SRMEBQF.value := Stock.MinEccQty;

  CBCalcProdT.Checked := Stock.CalcProdTime;

  SRGIF.Text := Form_BInt(Stock.WOPWIPGL, 0);

  Out_GLDesc(Stock.WOPWIPGL, FGLIF);

  SRAWF.Value := CaseQty(Stock, WOPAllocStock(Stock));
  SRIWF.Value := CaseQty(Stock, Stock.QtyIssueWOR);
  SRPWF.Value := CaseQty(Stock, Stock.QtyPickWOR);

  { Returns }
  SRRSWDF.Value := Stock.SWarranty;
  SRRMWDF.Value := Stock.MWarranty;

  SRRGLF.Text   := Form_BInt(Stock.ReturnGL, 0);
  SRRPGLF.Text  := Form_BInt(Stock.PReturnGL, 0);

  Out_GLDesc(Stock.ReturnGL, SRRGLDF);
  Out_GLDesc(Stock.PReturnGL, SRRGLPDF);

  SRRRCF.Text := PPR_PamountStr(Stock.ReStockPcnt, Stock.ReStockPChr);

  SRRSRF.Value := CaseQty(Stock, Stock.QtyReturn);
  SRRPRF.Value := CaseQty(Stock, Stock.QtyPReturn);

end;

//-----------------------------------------------------------------------------

procedure TfrmStock.ViewTransactionClick(Sender: TObject);
begin
  with BtList do
    if ValidLine then
    begin
      RefreshLine(MUListBoxes[0].Row, BOff);
      DisplayTransactions(Id.FolioRef, False);
    end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
    case WParam of
      { 0 = dbl click on line, 1 = Selected line changed, 169 = pressed drill down button}
      0, 1, 169:
        begin
          if (WParam = 169) then {* Treat as 0 *}
          begin
            BtList.GetSelRec(BOff);
            WParam := 0;
          end;

          // Display Trans
          if (WParam = 0) or ((WParam = 1) And Assigned(DisplayTrans)) then
            DisplayTransactions(Id.FolioRef, (WParam = 1));
        end;

      { pressed right click over list }
      2:  ; //ShowRightMeny(LParamLo,LParamHi,1);

      25:  NeedCUpdate := BOn;
    End; { Case WParam }
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmStock.WMWindowPosChanged(var Msg: TMessage);
var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  inherited;
  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  if self.Visible then
  begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    if not Assigned(TopWindow) then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  end; { if self.Visible... }
end;

procedure TfrmStock.PageControlChange(Sender: TObject);
begin
  btnViewLine.Visible := (PageControl.ActivePage = LedgerPage);
end;

end.

