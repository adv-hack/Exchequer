unit JobActlF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SBSPanel, Menus, SupListU, GlobVar, VarConst, ExWrap1U,
  JHistDDU, EBJCLine, uMultiList, uDBMColumns, ETStrU, StdCtrls, FuncList,
  DrillConst, BtSupU1, DispDocF, TEditVal, ComCtrls;

type
  { Btrieve list (indirect descendant of TMULCtrl in SbsComp.pas) }
  TJLMList = class(TGenList)
  private
    // Extended Btrieve Operations object
    DataObj: ^TExtBtrieveJCLines;

    // Property fields
    lstAnalysisCode: ShortString;
    lstCurrency: Byte;
    lstFilterMode: TDataFilterMode;
    lstJAType: Integer;
    lstJobCode: ShortString;
    lstPeriod: SmallInt;
    lstStockCode: ShortString;
    lstYear: SmallInt;
    lstStatus: TPostedStatus;

    { Function Category determines which set of records are displayed: Analysis
      (fcJCAnalActual) or Totals (fcJCTotActual). }
    lstFunctionCategory: TEnumFunctionCategory;

    LNHCtrl:  TNHCtrlRec;        // Contains selection set-up details
    function FilterAnalysis(B_End: Integer; var KeyS: Str255): Integer;
    function FilterStock(B_End: Integer; var KeyS: Str255): Integer;
    function FilterTotals(B_End: Integer; var KeyS: Str255): Integer;
  public
    procedure DetermineFilterMode;
    function ExtFilter: Boolean; override;
    procedure ExtObjCreate; override;
    procedure ExtObjDestroy; override;
    function GetExtList(B_End: Integer; var KeyS: Str255): Integer; override;
    function OutLine(Col: Byte): Str255; override;
    function SetCheckKey: Str255; override;
    function StkMatchWCard(JobR: JobDetlRec): Char;
    function SetFilter: Str255; override;

    property AnalysisCode: ShortString
      read lstAnalysisCode write lstAnalysisCode;

    property Currency: Byte
      read lstCurrency write lstCurrency;

    property DataFilterMode: TDataFilterMode
      read lstFilterMode write lstFilterMode;

    property FunctionCategory: TEnumFunctionCategory
      read lstFunctionCategory write lstFunctionCategory;

    property JAType: Integer
      read lstJAType write lstJAType;

    property JobCode: ShortString
      read lstJobCode write lstJobCode;

    property Period: SmallInt
      read lstPeriod write lstPeriod;

    property Status: TPostedStatus
      read lstStatus write lstStatus;

    property StockCode: ShortString
      read lstStockCode write lstStockCode;

    property Year: SmallInt
      read lstYear write lstYear;
  end;

  // --------------------------------------------------------------------------

  TfrmJobActual = class(TForm)
    PopupMenu: TPopupMenu;
    ViewTransaction: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    btnViewLine: TButton;
    btnClose: TButton;
    PageControl: TPageControl;
    LedgerPage: TTabSheet;
    BtListBox: TScrollBox;
    BtListHeaderPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLOOLab: TSBSPanel;
    CLQOLab: TSBSPanel;
    CLALLab: TSBSPanel;
    CLACLab: TSBSPanel;
    CLUPLab: TSBSPanel;
    CLACCLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLOOPanel: TSBSPanel;
    CLQOPanel: TSBSPanel;
    CLALPanel: TSBSPanel;
    CLAcPanel: TSBSPanel;
    CLUPPanel: TSBSPanel;
    CLACCPanel: TSBSPanel;
    BtListBtnPanel: TSBSPanel;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ResetCoordinates1Click(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ViewTransactionClick(Sender: TObject);
    procedure WMCustGetRec(var Msg: TMessage); message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  private
    { Private declarations }
    DoneRestore: Boolean;
    InitSize: TPoint;
    BtListCoordsStored: Boolean;
    LastCoord: Boolean;
    ReadFormPos: Boolean;
    SetDefault: Boolean;
    BtList: TJLMList;
    ListOffset: Byte;
    ExLocal: TdExLocal;
    FromHistory: Boolean;
    DDMode: Byte;
    FNeedCUpDate: Boolean;

    DisplayTrans: TfrmDisplayTransManager;

    PagePoint: array[1..3] of TPoint;
    StartSize: TPoint;

    procedure DisplayTransactions(const IdFolio: LongInt; const DataChanged: Boolean);
    procedure FindFormCoords;
    procedure FreeList;
    function GetAnalysisCode: Str20;
    function GetCurrency: Byte;
    function GetFunctionCategory: TEnumFunctionCategory;
    function GetJAType: Integer;
    function GetJobCode: ShortString;
    function GetPeriod: SmallInt;
    function GetStatus: TPostedStatus;
    function GetYear: SmallInt;
    procedure RefreshList(ShowLines, IgnoreMessages: Boolean);
    procedure SetAnalysisCode(const Value: Str20);
    procedure SetCurrency(const Value: Byte);
    procedure SetFunctionCategory(const Value: TEnumFunctionCategory);
    procedure SetJAType(const Value: Integer);
    procedure SetJobCode(const Value: ShortString);
    procedure SetNeedCUpdate(const Value: Boolean);
    procedure SetPeriod(const Value: SmallInt);
    procedure SetStatus(const Value: TPostedStatus);
    procedure SetYear(const Value: SmallInt);
    procedure ShowRightMenu(X, Y, Mode: Integer);
    procedure StoreBtListCoords;
    procedure StoreFormCoords(UpdateMode: Boolean);
    function GetStockCode: ShortString;
    procedure SetStockCode(const Value: ShortString);

    property NeedCUpDate: Boolean read FNeedCUpDate write SetNeedCUpdate;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BuildList;
    property jaJobCode: ShortString read GetJobCode write SetJobCode;
    property jaAnalysisCode: Str20 read GetAnalysisCode write SetAnalysisCode;
    property jaCurrency: Byte read GetCurrency write SetCurrency;
    property jaJAType: Integer read GetJAType write SetJAType;
    property jaYear: SmallInt read GetYear write SetYear;
    property jaPeriod: SmallInt read GetPeriod write SetPeriod;
    property jaStatus: TPostedStatus read GetStatus write SetStatus;
    property jaStockCode: ShortString read GetStockCode write SetStockCode;
    property jaFunctionCategory: TEnumFunctionCategory
      read GetFunctionCategory write SetFunctionCategory;
  end;

function NewJobActualDialog: TfrmJobActual;

var
  frmJobActual: TfrmJobActual;

implementation

{$R *.dfm}

uses
  EntData,
  uSettings,
  BtKeys1U,
  JobSup1U,
  ETDateU,
  ETMiscU,
  CurrncyU,
  VarJCstU,
  Btrvu2,
  CmpCtrlU,
  SbsComp,
  ColCtrlU,
  SQLUtils
  ;

function NewJobActualDialog: TfrmJobActual;
begin { NewJobActualDialog }
  Result := nil;
  if Assigned(frmJobActual) then
    FreeAndNil(frmJobActual);
(*
    try
      // Try to access the caption to determine whether the form is still
      // in existance - if not then should get an Access Violation
      if (frmJobActual.Caption <> '') then
        Result := frmJobActual
    except
      on Exception do
      ;
    end;

  // If no pre-existing form then create a new one
*)
  if (not Assigned(Result)) then
    Result := TfrmJobActual.Create (nil);

  // Record global reference to form for later use
  frmJobActual := Result;
end; { NewJobActualDialog }


//=============================================================================
// TJLMList }
//=============================================================================

procedure TJLMList.DetermineFilterMode;
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

function TJLMList.ExtFilter: Boolean;
{ When the Btrieve list is traversing the database records, it will call
  this function for each record, to determine whether or not it should be
  included. Returning False will force the Btrieve list to skip over this
  record. }
var
  Period: SmallInt;
begin
  Result := True;

  { Periods > 100 are for the current year only. Subtract 100 to get the
    actual period. }
  if (lstPeriod > 100) Then
    Period := lstPeriod - 100
  else
    Period := lstPeriod;

  case lstFilterMode of

    { All records up to and including the specified year. }
  	dfToYear, dfToYearConsolidated:
      Result := (JobDetl.JobActual.ActYr <= lstYear);

    { All periods up to and including the specified period, for the specified
      year. }
    dfToPeriod, dfToPeriodConsolidated:
      Result := (JobDetl.JobActual.ActPr <= Period) and
                (JobDetl.JobActual.ActYr = lstYear);

    { Specified year and period only. }
  	dfThisPeriodConsolidated:
      Result := (JobDetl.JobActual.ActPr = Period) and
                (JobDetl.JobActual.ActYr = lstYear);

  end;

  // MH 06/03/2012 v6.10 ABSEXCH-11389: Added checks on JobCode/AnalCode for Analysis Code totals as was getting rows displayed for different analysis codes
  if Result And (lstFunctionCategory In [fcJCAnalActual, fcJCAnalActualQty]) Then
    Result := (JobDetl.JobActual.AnalKey = FullJDAnalKey(lstJobCode, lstAnalysisCode));

  if Result and (lstStatus <> psAll) then
  begin
    // MH 06/03/2012 v6.10 ABSEXCH-11389: Separated logic for EntJCTotal and EntJCAnal functions and duplicated Exchequer filtering for EntJCAnal section
    If (lstFunctionCategory In [fcJCAnalActual, fcJCAnalActualQty]) Then
    Begin
      if lstStatus = psPosted then
        Result := (Not (JobDetl.JobActual.JDDT In PSOPSet+QuotesSet +JAPOrdSplit-StkExcSet)) and (JobDetl.JobActual.PostedRun <> OrdPPRunNo)
      else
        Result := (JobDetl.JobActual.JDDT In PSOPSet+QuotesSet+JAPOrdSplit-StkExcSet) or (JobDetl.JobActual.PostedRun=OrdPPRunNo);
    End // If (lstFunctionCategory In [fcJCAnalActual, fcJCAnalActualQty])
    Else
    Begin
      if lstStatus = psPosted then
        { For psPosted, only include records which have a valid posted run
          number (i.e. a run number greater than zero). }
        // MH 01/12/2010 v6.5 ABSEXCH-2930: Extended to support Apps & Vals
        Result := (JobDetl.JobActual.PostedRun > 0) Or ((lstJAType In [SysAppSal, SysAppPur]) And (JobDetl.JobActual.PostedRun = JPAPRunNo))
      else
        { For psCommitted, only included records marked as unposted Purchase Order
          entries. }
        Result := (JobDetl.JobActual.PostedRun = OrdPPRunNo) And (JobDetl.JobActual.JAType = lstJAType);
    End; // Else
  end;
  if Result and (FunctionCategory in [fcJCStkActual, fcJCStkActualQty]) then
  begin
    { Only include records marked as posted to stock budget. }
    Result := JobDetl.JobActual.Post2Stk;
  end;

  // MH 12/11/2010 v6.5 ABSEXCH-2930: P&L Drill-Down including irrelevant transactions
  If Result And (lstJAType = SysAnlsProfit) Then
  Begin
    Result := HFolio_Txlate(JobDetl.JobActual.JAType) <= HFolio_Txlate(SysAnlsEnd)
  End; // If Result And (lstJAType = SysAnlsProfit)

  // MH 12/11/2010 v6.5 ABSEXCH-2930: WIP Drill-Down including irrelevant transactions
  If Result And (lstJAType = SysAnlsWIP) Then
  Begin
    Result := (HFolio_Txlate(JobDetl.JobActual.JAType) <= HFolio_Txlate(SysAnlsEnd)) And (JobDetl.JobActual.JAType <> SysAnlsRev) Or (JobDetl.JobActual.JAType=SysAnlsWIP);
  End; // If Result And (lstJAType = SysAnlsWIP)
end;

//-----------------------------------------------------------------------------

procedure TJLMList.ExtObjCreate;
begin
  inherited;

  // MH 10/11/2010 v6.5 ABSEXCH-2930: Disabled Extended Btrieve under SQL as it doesn't work on
  // fields outside of the fixed part of the variant table
  if (Not SQLUtils.UsingSQL) And (lstFilterMode in TJCExtendedBtrieveFilters) then
  begin
    // Create Extended Btrieve Ops sub-object
    New (DataObj, Init);
    ExtObjPtr := DataObj;
    ExtRecPtr := Pointer(1);
  end
  else
  begin
    DataObj := nil;
    ExtRecPtr := nil;
  end;

end;

//-----------------------------------------------------------------------------

procedure TJLMList.ExtObjDestroy;
begin

  if Assigned(DataObj) then
    Dispose (DataObj, Done);
  DataObj := nil;
  ExtRecPtr := nil;

  inherited;

end;

//-----------------------------------------------------------------------------

function TJLMList.FilterAnalysis(B_End: Integer; var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through Job Costing analysis records. }
var
  Period : Integer;
  Period1xx       : Boolean;
  PostedStatus: TPostedStatus;
begin
  PostedStatus := psPosted;

  { Periods > 100 are for the current year only. Subtract 100 to get the
    actual period. }
  Period1xx := (lstPeriod > 100);
  If Period1xx Then
    Period := lstPeriod - 100
  Else
    Period := lstPeriod;

  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. }
  case lstFilterMode Of
    dfToYear:
      Result := DataObj.Filter01(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstAnalysisCode,
                    lstCurrency,
                    lstYear,
                    PostedStatus
                  );

    dfToPeriod:
      Result :=  DataObj.Filter02(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstAnalysisCode,
                    lstCurrency,
                    lstYear,
                    Period,
                    PostedStatus
                  );

    dfThisPeriodConsolidated:
      Result :=  DataObj.Filter03(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstAnalysisCode,
                    lstYear,
                    Period,
                    PostedStatus
                  );

    dfToYearConsolidated:
      Result :=  DataObj.Filter04(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstAnalysisCode,
                    lstYear,
                    PostedStatus
                  );

    dfToPeriodConsolidated:
      Result :=  DataObj.Filter05(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstAnalysisCode,
                    lstYear,
                    Period,
                    PostedStatus
                  );

  else
    raise Exception.Create ('TJCLinesList.FilterAnalysis - Unsupported Data Mode (' + IntToStr(Ord(lstFilterMode)) + ')');
  end; { Case lstFilterMode }

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('FilterAnalysis(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

//-----------------------------------------------------------------------------

function TJLMList.FilterStock(B_End: Integer; var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through Job Costing stock records. }
var
  Period : Integer;
  Period1xx       : Boolean;
  PostedStatus: TPostedStatus;
begin
  PostedStatus := psPosted;

  { Periods > 100 are for the current year only. Subtract 100 to get the
    actual period. }
  Period1xx := (lstPeriod > 100);
  If Period1xx Then
    Period := lstPeriod - 100
  Else
    Period := lstPeriod;

  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. }
  case lstFilterMode Of
    dfToYear:
      Result := DataObj.Filter11(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstStockCode,
                    lstCurrency,
                    lstYear,
                    PostedStatus
                  );

    dfToPeriod:
      Result :=  DataObj.Filter12(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstStockCode,
                    lstCurrency,
                    lstYear,
                    Period,
                    PostedStatus
                  );

    dfThisPeriodConsolidated:
      Result :=  DataObj.Filter13(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstStockCode,
                    lstYear,
                    Period,
                    PostedStatus
                  );

    dfToYearConsolidated:
      Result :=  DataObj.Filter14(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstStockCode,
                    lstYear,
                    PostedStatus
                  );

    dfToPeriodConsolidated:
      Result :=  DataObj.Filter15(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstStockCode,
                    lstYear,
                    Period,
                    PostedStatus
                  );

  else
    raise Exception.Create ('TJCLinesList.FilterStock - Unsupported Data Mode (' + IntToStr(Ord(lstFilterMode)) + ')');
  end; { Case lstFilterMode }

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('FilterStock(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

//-----------------------------------------------------------------------------

function TJLMList.FilterTotals(B_End: Integer; var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through Job Costing total records. }
var
  Period : Integer;
  Period1xx: Boolean;
  PostedStatus: TPostedStatus;
begin
  PostedStatus := psPosted;

  { Periods > 100 are for the current year only. Subtract 100 to get the
    actual period. }
  Period1xx := (lstPeriod > 100);
  If Period1xx Then
    Period := lstPeriod - 100
  Else
    Period := lstPeriod;

  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. Return the Btrieve result code. }
  case lstFilterMode Of

    dfToYear:
      Result :=  DataObj.Filter06(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstJAType,
                    lstCurrency,
                    lstYear,
                    PostedStatus
                  );

    dfToPeriod:
      Result :=  DataObj.Filter07(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstJAType,
                    lstCurrency,
                    lstYear,
                    Period,
                    PostedStatus
                  );

    dfThisPeriodConsolidated:
      Result :=  DataObj.Filter08(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstJAType,
                    lstYear,
                    Period,
                    PostedStatus
                  );

    dfToYearConsolidated:
      Result :=  DataObj.Filter09(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstJAType,
                    lstYear,
                    PostedStatus
                  );

    dfToPeriodConsolidated:
      Result :=  DataObj.Filter10(
                    B_End+30,                // Btrieve Operation (+30 = Extended version)
                    ScanFileNum,             // File Number
                    KeyPath,                 // Index Number
                    KeyS,                    // Search Key
                    lstJobCode,
                    lstJAType,
                    lstYear,
                    Period,
                    PostedStatus
                  );

  else
    raise Exception.Create ('TJCLinesList.FilterTotals - Unsupported Data Mode (' + IntToStr(Ord(lstFilterMode)) + ')');
  end; { Case lstFilterMode }

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('FilterTotals(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

//-----------------------------------------------------------------------------

function TJLMList.GetExtList(B_End: Integer; var KeyS: Str255): Integer;
{ Override of the base class method, for use with Extended Btrieve filters. This
  method will only be called if the ExtRecPtr and ExtObjPtr pointers have been
  assigned. See TMULCtrl.GetMatch in X:\Entrprse\R&D\SbsComp.pas. }
begin
  if (B_End in [B_GetPrev, B_GetNext]) and Assigned(DataObj) then
  begin
    // Display "Please Wait..." message
    DispExtMsg(BOn);
    try
      if (lstFunctionCategory in [fcJCTotActual, fcJCTotActualQty]) then
        Result := FilterTotals(B_End, KeyS)
      else if (lstFunctionCategory in [fcJCStkActual, fcJCStkActualQty]) then
        Result := FilterStock(B_End, KeyS)
      else if (lstFunctionCategory in [fcJCAnalActual, fcJCAnalActualQty]) then
        Result := FilterAnalysis(B_End, KeyS)
      else
        Result := -1;

{
      if (Result = 62) then
        raise Exception.Create('Extended Filter failed because of badly-formed record structure')
      else if (Result = -1) then
        raise Exception.Create('Extended Filter failed because an unknown function category was specified');
}
    finally
      // Hide "Please Wait..." message
      DispExtMsg(BOff);
    end;
  end
  else
    Result := Find_Rec(B_End, F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, KeyS);
end; {Func..}

//-----------------------------------------------------------------------------

function TJLMList.OutLine(Col: Byte): Str255;
{ Returns the contents (as a string) of the field in the current record, for
  the specified column in the Btrieve list. }

  function FormatCurFloat(FMask: Str255; Value: Double; Cr: Byte): Str255;
  var
    GenStr: Str5;
  begin
    GenStr := '';
    {$IFDEF MC_On}
      GenStr := SSymb(Cr);
    {$ENDIF}
    if (Value <> 0.0) then
      Result := GenStr + FormatFloat(Fmask, Value)
    else
      Result := '';
  end;

var
  Cr: Byte;
  Dnum: Double;
  ExLocal: ^TdExLocal;
const
  MASK_FOR_SALES    = True;   // BOn
  MASK_FOR_PURCHASE = False;  // BOff
begin
  ExLocal := ListLocal;
  with ExLocal^, LNHCtrl, JobDetl^, JobActual do
  begin
    case Col of
      0:  Result := LineORef;
      1:  Result := POutDate(JDate);
      2:  Result := AnalCode;
      3:
        begin
          Dnum := Qty * DocCnst[JDDT];
          if (JDDT In SalesSplit) then
            Dnum := Dnum * DocNotCnst;
          if (DNum <> 0.0) then
            Result := FormatFloat(GenQtyMask, DNum)
          else
            Result := '';
        end;
      4:
        begin
          Cr := ActCurr;
          if (JDDT in JAPSplit) then
            Dnum := (Round_Up(Cost, 2) * DocCnst[JDDT])
          else
            Dnum := (Round_Up(Qty*Cost, 2) * DocCnst[JDDT]);

          {$IFDEF MC_On}
           if (NHCr=0) then
           begin
             UOR := fxUseORate(BOff, BOn, PCRates, JUseORate, ActCurr, 0);
             Dnum := Conv_TCurr(Dnum, XRate(PCRates,BOff,ActCurr), ActCurr, UOR, BOff);
             Cr:=0;
           end;

           if (NHTxCr<>0) then
           begin
             Dnum := Currency_Txlate(Dnum,NHCr,NHTxCr);
             Cr   := NHTxCr;
           end;
          {$ENDIF}

          Result := FormatCurFloat(GenUnitMask[MASK_FOR_PURCHASE],Dnum,Cr);

        end;
      5:
        begin
          if (JDDT = TSH) then
           Cr := CurrCharge
          else
           Cr := LJobRec^.CurrPrice;
          Dnum   := Currency_ConvFT(Charge, CurrCharge, Cr, UseCoDayRate);
          Result := FormatCurFloat(GenUnitMask[MASK_FOR_SALES], DNum, Cr);
        end;
      6:
        begin
          Cr := ActCurr;
          Dnum := (Round_Up(Qty * UpliftTotal, 2) * DocCnst[JDDT]);
          {$IFDEF MC_On}
          if (NHCr=0) then
          begin
            UOR  := fxUseORate(BOff, BOn, PCRates, JUseORate, ActCurr, 0);
            Dnum := Conv_TCurr(Dnum, XRate(PCRates, BOff, ActCurr), ActCurr, UOR, BOff);
            Cr   := 0;
          end;
          if (NHTxCr<>0) then
          begin
            Dnum := Currency_Txlate(Dnum, NHCr, NHTxCr);
            Cr   := NHTxCr;
          end;
          {$ENDIF}
          Result := FormatCurFloat(GenUnitMask[MASK_FOR_SALES], DNum, Cr);
        end;
      7: Result := ActCCode;
    else
      Result := '';
    end; {Case..}
  end; {With..}
end;

//-----------------------------------------------------------------------------

function TJLMList.SetCheckKey: Str255;
var
  IndexStr: Str255;
begin
  FillChar(IndexStr, Sizeof(IndexStr),0);

  with JobDetl^, JobActual do
  begin
    if lstStatus = psCommitted then
      IndexStr := PartCCKey(RecPfix, SubType) +
                  FullNomKey(OrdPPRunNo) + FullJobCode(JobCode) +
                  JDate
    else
    begin
      if (FunctionCategory in [fcJCAnalActual, fcJCAnalActualQty]) then
        IndexStr := PartCCKey(RecPfix, SubType) +
                    FullJADDKey(AnalKey, ActCurr, ActYr, ActPr)
      else if (FunctionCategory in [fcJCStkActual, fcJCStkActualQty]) then
        IndexStr := PartCCKey(RecPFix, SubType) +
                    FullJDStkKey(JobCode, StockCode) +
                    Chr(ActCurr) +
                    Chr(ActYr) +
                    Chr(ActPr)
      else if (FunctionCategory in [fcJCTotActual, fcJCTotActualQty]) then
        IndexStr := PartCCKey(RecPFix, SubType) +
                    FullJDHedKey(JobCode, lstJAType) +
                    Chr(ActCurr) +
                    Chr(ActYr) +
                    Chr(ActPr);
    end
  end;

  Result := IndexStr;
end;

//-----------------------------------------------------------------------------

function TJLMList.SetFilter: Str255;
var
  Period: SmallInt;
const
  Found: Char    = #1;
  NotFound: Char = #2;
begin
(**** MH 12/11/2010: Modified to use ExtFilter which duplicates this
  Result := Found; //StkMatchWCard(JobDetl^);
  if (lstPeriod > 100) Then
    Period := lstPeriod - 100
  else
    Period := lstPeriod;
  case lstFilterMode of
    dfToYear, dfToYearConsolidated:
      if (JobDetl.JobActual.ActYr <= lstYear) then
        Result := Found
      else
        Result := NotFound;
    dfToPeriod, dfToPeriodConsolidated:
      if (JobDetl.JobActual.ActPr <= Period) and
         (JobDetl.JobActual.ActYr = lstYear) then
        Result := Found
      else
        Result := NotFound;
    dfThisPeriodConsolidated:
      if (JobDetl.JobActual.ActPr = Period) and
         (JobDetl.JobActual.ActYr = lstYear) then
        Result := Found
      else
        Result := NotFound;
  end;
  if (Result = Found) and (lstStatus <> psAll) then
  begin
    if (lstStatus = psCommitted) then
    begin
      if (JobDetl.JobActual.PostedRun <> OrdPPRunNo) Or ((JobDetl.JobActual.PostedRun = OrdPPRunNo) And (JobDetl.JobActual.JAType <> lstJAType)) then
        Result := NotFound
      else if (FunctionCategory in [fcJCAnalActual, fcJCAnalActual]) and
              (Trim(JobDetl.JobActual.AnalCode) <> lstAnalysisCode) then
        Result := NotFound;
    end
    else
    begin
      if (JobDetl.JobActual.PostedRun < 0) then
        Result := NotFound;
    end;
  end;
  if (Result = Found) and (FunctionCategory in [fcJCStkActual, fcJCStkActualQty]) then
  begin
    { Only include records marked as posted to stock budget. }
    if (not JobDetl.JobActual.Post2Stk) then
      Result := NotFound;
  end;
****)
  If ExtFilter Then
    Result := Found
  Else
    Result := NotFound;
end;

//-----------------------------------------------------------------------------

function TJLMList.StkMatchWCard(JobR: JobDetlRec): Char;
var
  TChr: Char;
begin
  { TODO: StkMatchWCard }
  TChr := NdxWeight;
  Result := TChr;
end;

//-----------------------------------------------------------------------------

{ TfrmJobActual }

procedure TfrmJobActual.BtListLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TfrmJobActual.BtListLabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
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

procedure TfrmJobActual.BtListPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TfrmJobActual.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.btnViewLineClick(Sender: TObject);
begin
  ViewTransactionClick(Sender);
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.BuildList;
{ Sets up the Btrieve columns, and displays the first page of records (control
  of the display is subsequently handled by the Btrieve list itself, which
  will call the appropriate search and filter routines as required when the
  user navigates through the list). }
var
  StartPanel: TSBSPanel;
  n         : Byte;
begin
  with BtList do
  begin
    try
      DetermineFilterMode;
      with VisiList do
      begin
        { Assign the panels and labels to the Btrieve list, to create the
          actual display columns.

          Note that the first seven letters of each of the control names
          must be unique (they are used as part of an index key). }
        AddVisiRec(CLORefPanel,   CLORefLab);
        AddVisiRec(CLDatePanel,   CLDateLab);
        AddVisiRec(CLACPanel,     CLACLab);
        AddVisiRec(CLQOPanel,     CLQOLab);
        AddVisiRec(CLALPanel,     CLALLab);
        AddVisiRec(CLOOPanel,     CLOOLab);
        AddVisiRec(CLUPPanel,     CLUPLab);
        AddVisiRec(CLACCPanel,    CLACCLab);

        VisiRec := List[0];

        StartPanel := (VisiRec^.PanelObj as TSBSPanel);
        LabHedPanel := BtListHeaderPanel;
        SetHedPanel(ListOffSet);

      end;
    except
      VisiList.Free;
      raise;
    end;

    TabOrder := -1;
    TabStop := BOff;
    Visible := BOff;
    BevelOuter := bvNone;
    ParentColor := False;
    Color := StartPanel.Color;
    MUTotCols := 7;
    Font := StartPanel.Font;

    LinkOtherDisp := BOn;

    WM_ListGetRec := WM_CustGetRec;

    Parent := StartPanel.Parent;

    MessHandle := Self.Handle;

    for n := 0 to MUTotCols do
    with ColAppear^[n] do
    begin
      AltDefault := BOn;
      if (n In [3..6]) then
      begin
        DispFormat := SGFloat;
        case n of
          3:    NoDecPlaces := Syss.NoQtyDec;
          4,6:  NoDecPlaces := Syss.NoCosDec;
          5  :  NoDecPlaces := Syss.NoNetDec;
        end; {Case..}
      end;
    end;

    DisplayMode := 2;

    Filter[1, 0] := #1;

    ListLocal := @ExLocal;

    ListCreate;

    Set_Buttons(BtListBtnPanel);

    RefreshList(not FromHistory, BOff);

  end; { with BtList do... }

  StoreBtListCoords;
  ReadFormPos := False;
  FindFormCoords;
  FormResize(self);

//    DefaultPageResize;
end;

//-----------------------------------------------------------------------------

constructor TfrmJobActual.Create(AOwner: TComponent);
begin
  inherited;
end;

//-----------------------------------------------------------------------------

destructor TfrmJobActual.Destroy;
begin
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.DisplayTransactions(const IdFolio: Integer;
  const DataChanged: Boolean);
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
    lStatus := Find_Rec (B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
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

procedure TfrmJobActual.FindFormCoords;
var
  ThisForm   : TForm;
  GlobComp   : TGlobCompRec;
  Key: string;
begin
  if (not ReadFormPos) then
  begin
    New(GlobComp, Create(BOn));

    ThisForm := self;

    with GlobComp^ do
    begin
      GetValues := BOn;

      Key := Format('J%.2d', [Ord(self.jaFunctionCategory)]);
      PrimeKey := Key;

      if (GetbtControlCsm(ThisForm)) then
      begin
        StoreCoordFlg.Checked := False;
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

    end; { with GlobComp^ do... }

    with BtList.VisiList do
      LabHedPanel.Color := IdPanel(0,BOn).Color;

    Dispose(GlobComp,Destroy);

    StartSize.X := Width;
    StartSize.Y := Height;
    ReadFormPos := True;
  end; { if (not ReadFormPos) then... }
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (NeedCUpdate or SetDefault or StoreCoordFlg.Checked) then
    StoreFormCoords(not SetDefault);
  Action := caFree;
  frmJobActual := nil;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.FormCreate(Sender: TObject);
begin
  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.AddReferenceCount;

  BtList := TJLMList.Create(Self);

  { Record the initial form size. }
  InitSize.Y := 333;
  InitSize.X := 763;
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;

  { Fix the form so that it cannot be shorter than the initial height, and
    cannot be wider than the initial width. }
  Constraints.MinHeight  := InitSize.Y - 1;

  Constraints.MinWidth   := 445;
//  Constraints.MaxWidth   := InitSize.X;

  NeedCUpdate := BOff;
  ReadFormPos := BOff;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  LastCoord   := False;
  SetDefault  := False;

  FromHistory := False;
  DDMode := 16;

  ExLocal.Create;

  ListOffset := 0;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.FormDestroy(Sender: TObject);
begin
  if Assigned(DisplayTrans) then
    FreeAndNil(DisplayTrans);

  // Remove global reference to form
  frmJobActual := nil;

  FreeList;

  // Close the global Settings object (it will be automatically recreated
  // when needed -- see uSettings.pas, function oSettings).
  oSettings.Free;

  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  // Closes any open data files in the range CustF (1) to SysF (15)
  //CloseDataFiles;
  EnterpriseData.RemoveReferenceCount;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.FormResize(Sender: TObject);
begin
//  if BtListCoordsStored then
  if ReadFormPos then
  begin
    BtList.LinkOtherDisp := BOff;

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

    BtnPanel.Left := PageControl.Width - (BtnPanel.Width + 4);
    BtnPanel.Height := BtListBox.Height;

    if (BtList <> nil) then
    begin
      LockWindowUpDate(Handle);

      with BtList, VisiList do
      begin
        VisiRec := List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height := BtListBtnPanel.Height;

        ReFresh_Buttons;
        RefreshAllCols;
      end;

      LockWindowUpDate(0);
    end;{Loop..}

    BtList.LinkOtherDisp:=BOn;

  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.FreeList;
begin
  BtList.Destroy;
  BtList := nil;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetAnalysisCode: Str20;
begin
  Result := BtList.AnalysisCode;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetCurrency: Byte;
begin
  Result := BtList.Currency;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetFunctionCategory: TEnumFunctionCategory;
begin
  Result := BtList.lstFunctionCategory;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetJAType: Integer;
begin
  Result := BtList.JAType;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetJobCode: ShortString;
begin
  Result := BtList.JobCode;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetPeriod: SmallInt;
begin
  Result := BtList.Period;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetStatus: TPostedStatus;
begin
  Result := BtList.lstStatus;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetStockCode: ShortString;
begin
  Result := BtList.StockCode;
end;

//-----------------------------------------------------------------------------

function TfrmJobActual.GetYear: SmallInt;
begin
  Result := BtList.Year;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.RefreshList(ShowLines, IgnoreMessages: Boolean);
{ Sets up the index and search key for the current display, and displays the
  first page of records in the Btrieve list. }
var
  KeyStart: Str255;
  LKeyLen, KPath: Integer;
  InclCcyPeriodInfo : Boolean;
begin

  { Select the appropriate index and search key, based on whether we are
    displaying posted or committed items. }

  if (BtList.lstStatus = psCommitted) then
  begin
    { Use the Posted Run Number index }
    KPath := JDPostedK;
    { Committed records have a Posted Run Number of -52 (OrdPPRunNo) }
    KeyStart := PartCCKey(JBRCode, JBECode) +
                FullNomKey(OrdPPRunNo) + FullJobCode(BtList.JobCode);
  end
  else
  begin
    InclCcyPeriodInfo := True;

    if (jaFunctionCategory in [fcJCTotActual, fcJCTotActualQty]) then
    begin
      { Use the JA Type index (based on Job Code + Job Analysis Line Type) }
      KPath := JDHedK;

      // MH 11/11/2010 v6.5 ABSEXCH-2930: Added special case for WIP and Profit
      If (BtList.lstJAType = SysAnlsWIP) Or (BtList.lstJAType = SysAnlsProfit) Then
      Begin
        KeyStart := PartCCKey(JBRCode, JBECode) + FullJobCode(BtList.JobCode);
        InclCcyPeriodInfo := False;
      End // If (BtList.lstJAType = SysAnlsWIP)
      Else
        KeyStart := PartCCKey(JBRCode, JBECode) +
                    FullJDHedKey(BtList.JobCode, BtList.lstJAType);

    end
    else if (jaFunctionCategory in [fcJCStkActual, fcJCStkActualQty]) then
    begin
      { Use the Stock Key index (based on Job Code + Stock Code) }
      KPath := JDStkK;

      KeyStart := PartCCKey(JBRCode, JBECode) +
                  FullJDStkKey(BtList.JobCode, BtList.StockCode);
    end
    else
    // if (jaFunctionCategory in [fcJCAnalActual, fcJCAnalActualQty]) then
    begin
      { Use the Analysis Key index (based on Job Code + Analysis Code) }
      KPath := JDAnalK;

      KeyStart := PartCCKey(JBRCode, JBECode) +
                  FullJDAnalKey(BtList.JobCode, BtList.AnalysisCode);

    end; // ...else if (jaFunctionCategory = fcJCAnalActual)...

    { If a currency has been specified (i.e. non-consolidated), we can use
      more of the index, for faster searching. }
    if InclCcyPeriodInfo And (BtList.DataFilterMode < dfThisPeriodConsolidated) then
    begin

      { Add the Currency to the search key }
      KeyStart := KeyStart + Chr(BtList.Currency);

      { Add the Year to the search key }
      if (BtList.DataFilterMode in [dfThisPeriod, dfToPeriod, dfThisPeriodConsolidated, dfToPeriodConsolidated]) then
        KeyStart := KeyStart + Chr(BtList.Year);

      { If a specific Period was requested, add it to the search key }
      if (BtList.DataFilterMode in [dfThisPeriod, dfThisPeriodConsolidated]) then
      begin
        { Periods > 100 are for the current year only. Subtract 100 to get the
          actual period. }
        if (BtList.Period > 100) then
          KeyStart := KeyStart + Chr(BtList.Period - 100)
        else
          KeyStart := KeyStart + Chr(BtList.Period);
      end;

    end; // if (BtList.DataFilterMode < dfThisPeriodConsolidated)...

  end; // if (BtList.lstStatus = psCommitted)...

  LKeyLen := Length(KeyStart);
  BtList.IgnoreMsg := IgnoreMessages;

  { Display the first page of records }
  BtList.StartList(JDetlF, KPath, KeyStart, '', '', LKeyLen, (not ShowLines));

  BtList.IgnoreMsg := BOff;

end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.ResetCoordinates1Click(Sender: TObject);
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

procedure TfrmJobActual.SetAnalysisCode(const Value: Str20);
begin
  BtList.AnalysisCode := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetCurrency(const Value: Byte);
begin
  BtList.Currency := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetFunctionCategory(
  const Value: TEnumFunctionCategory);
begin
  BtList.lstFunctionCategory := Value;
  case Value of
    fcJCAnalActual:     Caption := 'Job Costing Analysis';
    fcJCAnalActualQty:  Caption := 'Job Costing Analysis - Quantities';
    fcJCStkActual:      Caption := 'Job Costing Stock';
    fcJCStkActualQty:   Caption := 'Job Costing Stock - Quantities';
    fcJCTotActual:      Caption := 'Job Costing Totals';
    fcJCTotActualQty:   Caption := 'Job Costing Totals - Quantities';
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetJAType(const Value: Integer);
begin
  BtList.JAType := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetJobCode(const Value: ShortString);
begin
  BtList.JobCode := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetNeedCUpdate(const Value: Boolean);
begin
  FNeedCUpDate := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetPeriod(const Value: SmallInt);
begin
  BtList.Period := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetStatus(const Value: TPostedStatus);
begin
  BtList.lstStatus := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetStockCode(const Value: ShortString);
begin
  BtList.StockCode := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.SetYear(const Value: SmallInt);
begin
  BtList.Year := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.ShowRightMenu(X, Y, Mode: Integer);
begin
  with PopUpMenu Do
    PopUp(X,Y);
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.StoreBtListCoords;
begin
  PagePoint[1].X := Width  - PageControl.Width;
  PagePoint[1].Y := Height - PageControl.Height;

  PagePoint[2].X := LedgerPage.Width  - BtListBox.Width;
  PagePoint[2].Y := LedgerPage.Height - BtListBox.Height;

  PagePoint[3].X := LedgerPage.Width  - BtListBtnPanel.Left;
  PagePoint[3].Y := LedgerPage.Height - BtListBtnPanel.Height;

  BtListCoordsStored := True;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.StoreCoordFlgClick(Sender: TObject);
begin
  if StoreCoordFlg.Checked then
  begin
    SetDefault := False;
    ResetCoordinates1.Checked := False;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.StoreFormCoords(UpdateMode: Boolean);
var
  GlobComp:  TGlobCompRec;
  Key: string;
begin
  New(GlobComp, Create(BOff));

  with GlobComp^ do
  begin
    GetValues := UpdateMode;

    Key := Format('J%.2d', [Ord(self.jaFunctionCategory)]);
    PrimeKey := Key;

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
  End; { With GlobComp^ }

  Dispose(GlobComp,Destroy);
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.ViewTransactionClick(Sender: TObject);
begin
  with BtList do
    if ValidLine then
    begin
      RefreshLine(MUListBoxes[0].Row, BOff);
      DisplayTransactions(JobDetl.JobActual.LineFolio, False);
    end;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
    case WParam of
      { 0 = dbl click on line, 1 = Selected line changed, 169 = pressed drill down button}
      0, 1, 169:
        begin
          if (WParam=169) then {* Treat as 0 *}
          begin
            BtList.GetSelRec(BOff);
            WParam := 0;
          end;

          // Display Trans
          if (WParam = 0) or ((WParam = 1) And Assigned(DisplayTrans)) then
            DisplayTransactions(JobDetl.JobActual.LineFolio, (WParam = 1));
        end;

      { pressed right click over list }
      2:  ; //ShowRightMeny(LParamLo,LParamHi,1);

      25:  NeedCUpdate := BOn;
    end; { Case WParam }
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmJobActual.WMWindowPosChanged(var Msg: TMessage);
var
  TopWindow : TWinControl;
begin
  inherited;
  // HM 22/10/03: Added Visible check as it hangs under Win98 otherwise
  if self.Visible then
  begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    if not Assigned(TopWindow) then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
                   SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  end; // if self.Visible...
end;

//-----------------------------------------------------------------------------

end.


