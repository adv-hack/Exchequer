unit frmCustU;
{
  Displays Customer/Supplier Balance Ledger, from Transactions

  fcCustAgedBalance
  fcCustBalance
  fcCustCommitted

  fcSuppCommitted
  fcSuppAgedBalance
  fcSuppBalance
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SBSPanel, ComCtrls,
  ExWrap1U,
  BtSupU1,
  VarConst,
  SupListU,
  BtKeys1U,
  uSettings,
  DispDocF,
  DrillConst,
  FuncList,
  GlobVar,
  EBCustLine, Menus, StdCtrls, TEditVal;

type
  { Btrieve list (indirect descendant of TMULCtrl in SbsComp.pas) }
  TCustList = class(TGenList)
  private
    // Extended Btrieve Operations object
    DataObj: ^TExtBtrieveCustLines;

    lstAgeAsAt: TDateTime;
    lstAgeBy: Char;
    lstAgingPeriod: Byte;
    lstCurrency: Byte;
    lstCustCode: ShortString;
    lstFilterMode: TDataFilterMode;
    lstLocation: ShortString;
    lstPeriod: SmallInt;
    lstPeriodInterval: Integer;
    lstStockCode: ShortString;
    lstYear: SmallInt;

    { Function Category determines which set of records are displayed }
    lstFunctionCategory: TEnumFunctionCategory;

    TSales  : Real;
    TCost   : Real;
    TProfit : Real;

    function FilterForAging(B_End: Integer; var KeyS: Str255): Integer;
    procedure SetAgeBy(const Value: Char);

  public
    procedure DetermineFilterMode;
    function ExtFilter: Boolean; override;
    procedure ExtObjCreate; override;
    procedure ExtObjDestroy; override;
    function GetExtList(B_End: Integer; var KeyS: Str255): Integer; override;
    function OutLine(Col: Byte): Str255; override;
    function SetCheckKey: Str255; override;
    function SetFilter: Str255; override;

    property AgeAsAt: TDateTime
      read lstAgeAsAt write lstAgeAsAt;

    property AgeBy: Char
      read lstAgeBy write SetAgeBy;

    property AgingPeriod: Byte
      read lstAgingPeriod write lstAgingPeriod;

    property Currency: Byte
      read lstCurrency write lstCurrency;

    property CustCode: ShortString
      read lstCustCode write lstCustCode;

    property DataFilterMode: TDataFilterMode
      read lstFilterMode write lstFilterMode;

    property FunctionCategory: TEnumFunctionCategory
      read lstFunctionCategory write lstFunctionCategory;

    property Location: ShortString
      read lstLocation write lstLocation;

    property Period: SmallInt
      read lstPeriod write lstPeriod;

    property PeriodInterval: Integer
      read lstPeriodInterval write lstPeriodInterval;

    property StockCode: ShortString
      read lstStockCode write lstStockCode;

    property Year: SmallInt
      read lstYear write lstYear;

  end;

  TfrmCustHistory = class(TForm)
    PageControl: TPageControl;
    LedgerPage: TTabSheet;
    BtListBox: TScrollBox;
    BtListHeaderPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLAmtLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLTotLab: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    CLOrigLab: TSBSPanel;
    CLStatLab: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLTotPanel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
    CLOrigPanel: TSBSPanel;
    CLStatPanel: TSBSPanel;
    BtListBtnPanel: TSBSPanel;
    PopupMenu: TPopupMenu;
    ViewTransaction: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    CLORefPanel: TSBSPanel;
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
    procedure ResetCoordinates1Click(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ViewTransactionClick(Sender: TObject);
    procedure WMCustGetRec(var Msg: TMessage); message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  private
    FcustAgeAsAt: TDateTime;
    FcustAgeBy: Char;
    FcustCurrency: Byte;
    FcustCustCode: ShortString;
    FcustLocation: ShortString;
    FcustPeriod: SmallInt;
    FcustPeriodInterval: Integer;
    FcustStockCode: ShortString;
    FcustFunctionCategory: TEnumFunctionCategory;
    FcustYear: SmallInt;

    BtList: TCustList;

    DoneRestore: Boolean;
    InitSize: TPoint;
    BtListCoordsStored: Boolean;
    LastCoord: Boolean;
    StoreCoord: Boolean;
    ReadFormPos: Boolean;
    SetDefault: Boolean;
    ListOffset: Byte;
    ExLocal: TdExLocal;
    FromHistory: Boolean;
    FNeedCUpDate: Boolean;

    PagePoint: array[1..3] of TPoint;
    StartSize: TPoint;

    DisplayTrans : TfrmDisplayTransManager;

    function CheckListFinished: Boolean;

    procedure DisplayTransFrm(const IdFolio: LongInt; const DataChanged : Boolean);

    procedure FindFormCoords;

    function GetAgeAsAt: TDateTime;
    function GetAgeBy: Char;
    function GetCurrency: Byte;
    function GetCustCode: ShortString;
    function GetFunctionCategory: TEnumFunctionCategory;
    function GetLocation: ShortString;
    function GetPeriod: SmallInt;
    function GetPeriodInterval: Integer;
    function GetStockCode: ShortString;
    function GetYear: SmallInt;

    procedure RefreshList(ShowLines, IgnoreMessages: Boolean);
    procedure SetAgeAsAt(const Value: TDateTime);
    procedure SetAgeBy(const Value: Char);
    procedure SetCurrency(const Value: Byte);
    procedure SetCustCode(const Value: ShortString);
    procedure SetFunctionCategory(const Value: TEnumFunctionCategory);
    procedure SetLocation(const Value: ShortString);
    procedure SetNeedCUpdate(const Value: Boolean);
    procedure SetPeriod(const Value: SmallInt);
    procedure SetPeriodInterval(const Value: Integer);
    procedure SetStockCode(const Value: ShortString);
    procedure SetYear(const Value: SmallInt);

    procedure ShowRightMenu(X, Y, Mode: Integer);
    procedure StoreBtListCoords;
    procedure StoreFormCoords(UpdateMode: Boolean);

    property NeedCUpDate: Boolean read FNeedCUpDate write SetNeedCUpdate;

  public

    procedure BuildList;

    property custAgeAsAt: TDateTime
      read GetAgeAsAt write SetAgeAsAt;

    property custAgeBy: Char
      read GetAgeBy write SetAgeBy;

    property custCurrency: Byte
      read GetCurrency write SetCurrency;

    property custCustCode: ShortString
      read GetCustCode write SetCustCode;

    property custLocation: ShortString
      read GetLocation write SetLocation;

    property custPeriod: SmallInt
      read GetPeriod write SetPeriod;

    property custPeriodInterval: Integer
      read GetPeriodInterval write SetPeriodInterval;

    property custStockCode: ShortString
      read GetStockCode write SetStockCode;

    property custFunctionCategory: TEnumFunctionCategory
      read GetFunctionCategory write SetFunctionCategory;

    property custYear: SmallInt
      read GetYear write SetYear;

  end;

function NewCustHistoryDialog: TfrmCustHistory;

var
  frmCustHistory: TfrmCustHistory;

implementation

{$R *.dfm}

uses
  BtrvU2,
  ETDateU,
  CurrncyU,
  PWarnU,
  ETMiscU,
  SysU1,
  ComnU2,
  ComnUnit,
  SbsComp,
  CmpCtrlU,
  ColCtrlU,
  DateUtils,
  StrUtils,
  EntData,        // EntData object

  DocSupU1
  ;

function NewCustHistoryDialog: TfrmCustHistory;
begin
  if Assigned(frmCustHistory) then
    FreeAndNil(frmCustHistory);

  Result := TfrmCustHistory.Create (nil);
  // Record global reference to form for later use
  frmCustHistory := Result;
end;


//=============================================================================
// TCustList
//=============================================================================

procedure TCustList.DetermineFilterMode;
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

function TCustList.ExtFilter: Boolean;
begin
  Result := True;
end;

procedure TCustList.ExtObjCreate;
begin
  inherited;

  // Create Extended Btrieve Ops sub-object
//  New (DataObj, Init);
//  ExtObjPtr := DataObj;
//  ExtRecPtr := Pointer(1);

end;

//-----------------------------------------------------------------------------

procedure TCustList.ExtObjDestroy;
begin
  inherited;

  if Assigned(DataObj) then
    Dispose (DataObj, Done);
  DataObj := nil;
  ExtRecPtr := nil;

end;

//-----------------------------------------------------------------------------

function TCustList.FilterForAging(B_End: Integer;
  var KeyS: Str255): Integer;
{ Finds the next record matching the current filter, if any. Used when
  navigating through document records. }
begin
  { Select and call the appropriate filter function, to get the next record
    using Extended Btrieve. }
  Result := 0;
(*
  Result := DataObj.Filter01(
              B_End+30,                // Btrieve Operation (+30 = Extended version)
              ScanFileNum,             // File Number
              KeyPath,                 // Index Number
              KeyS,                    // Search Key
              lstCustCode
            );
*)
  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('FilterForAging(' + IntToStr(Ord(lstFilterMode)) + '): ' + IntToStr(Ord(Result)));
  {$ENDIF} // DRILLDEBUG
end;

//-----------------------------------------------------------------------------

function TCustList.GetExtList(B_End: Integer; var KeyS: Str255): Integer;
begin
  if (B_End in [B_GetPrev, B_GetNext]) and Assigned(DataObj) then
  begin
    // Display "Please Wait..." message
    DispExtMsg(BOn);
    try

      Result := -1;

      Result := Find_Rec(B_End, F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, KeyS);

      { If we are here, it is because the current record does not match with
        the filter, so use Extended Btrieve to find the next matching record,
        if any. }
      if (FunctionCategory in [fcCustAgedBalance]) then
        Result := FilterForAging(B_End, KeyS);

      if (Result = 62) then
        raise Exception.Create('Extended Filter failed because of badly-formed record structure')
      else if (Result = -1) then
        raise Exception.Create('Extended Filter failed because an unknown function category was specified');

    finally
      // Hide "Please Wait..." message
      DispExtMsg(BOff);
    end;
  end
  else
    Result := Find_Rec(B_End, F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, KeyS);
end;

function TCustList.OutLine(Col: Byte): Str255;
Var
  sOut : ShortString;

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
      sOut := GenStr + FormatFloat(Fmask, Value)
    else
      sOut := '';
    Result := sOut;
  end;

  function Show_CMG(DocHed: DocTypes): Boolean;
  { ============ Function to Determine if Cost/Margin info is displayed ====== }
  { --- Copied from X:\Entrprse\R&D\InvFSu3U.pas and amended ----------------- }
  begin
    Result := ((DocHed in SalesSplit) and (PChkAllowed_In(143)));
  end;

var
  GenStr : Str255;
  n      : Byte;
  TCr    : Byte;
  Rnum   : Real;
begin
  with Inv do
  begin
    case Col of
      0  : Result := OurRef;
      1  : Result := POutDateB(TransDate);
      2  : begin
             if (lstCurrency = 0) then
               Rnum:=Settled
             else
               Rnum:=CurrSettled;
             Result := FormatCurFloat(GenRealMask, Rnum, (DisplayMode = 0), lstCurrency);
           end;
      3  : begin
             if (lstCurrency = 0) then
               Rnum := BaseTotalOs(Inv)
             else
               Rnum := CurrencyOS(Inv, BOn, BOff, BOff);
             Result := FormatCurFloat(GenRealMask, Rnum, (DisplayMode = 0), lstCurrency);
           end;
      4  : begin
             TCr := lstCurrency;
             if (lstCurrency <> 0) then
               TCr := 0;
             Rnum := (ConvCurrItotal(Inv, BOff, BOn, BOn) * DocCnst[InvDocHed] * DocNotCnst);
             Result := FormatCurFloat(GenRealMask, Rnum, BOff, TCr);
           end;
      5  : begin
             Rnum := (ITotal(Inv) * DocCnst[InvDocHed] * DocNotCnst);
             Result := FormatCurFloat(GenRealMask, Rnum, BOff, Currency);
           end;
      6  : if (not SWInfoSOn) then
             Result := dbFormatSlash(YourRef, TransDesc)
           else
             Result := TransDesc;
      7  : Result := POutDate(DueDate);
      8  : begin
             Result := Disp_HoldPStat(HoldFlg, Tagged, PrintedDoc, BOff, OnPickRun);


             // MH 25/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
             //n := 0 + (1 * Ord((DiscSetAm <> 0))) + (1 * Ord((DiscTaken = True) or (PDiscTaken = True)));
             n := 0 +
                 (1 * Ord((DiscSetAm <> 0) Or (Inv.thPPDGoodsValue <> 0.0) Or (Inv.thPPDVATValue <> 0.0))) +
                 (1 * Ord(DiscTaken Or PDiscTaken Or (Inv.thPPDTaken <> ptPPDNotTaken)));

             if (n >= Low(DiscStatus)) and (n <= High(DiscStatus)) then
               GenStr := DiscStatus[n]
             else
               Genstr := '';

             if (Trim(GenStr) <> '') then
               Result := GenStr + ' ! ' + Result;
           end;
    else
      Result := '';
    end; { case Col of... }
  end; { with Inv do... }
end;

//-----------------------------------------------------------------------------

procedure TCustList.SetAgeBy(const Value: Char);
begin
  lstAgeBy := Value;
  case lstAgeBy of
    'D' : lstAgingPeriod := 1;
    'W' : lstAgingPeriod := 2;
    'M' : lstAgingPeriod := 3;
  end;
end;

function TCustList.SetCheckKey: Str255;
var
  IndexStr: Str255;
begin
  FillChar(IndexStr, Sizeof(IndexStr),0);

  with Inv do
  begin
    IndexStr := FullCustCode(CustCode);
  end;

  Result := IndexStr;
end;

//-----------------------------------------------------------------------------

function TCustList.SetFilter: Str255;
var
  LineAged: AgedTyp;
  AgeAsAt: LongDate;
  Amnt: Double;
  Status: string;
begin
  Result := INCLUDE_IN_DATASET;
  FillChar(LineAged, Sizeof(LineAged), 0);
  Amnt := BaseTotalOs(Inv);
  Status := IfThen(FunctionCategory = fcSuppAgedBalance, 'S', 'C');
  if (FunctionCategory in [fcCustAgedBalance, fcSuppAgedBalance]) then
  begin
    if ((Inv.InvDocHed in SalesSplit + PurchSplit) and (Amnt <> 0) and
        (Inv.AllocStat = Status)) then
    begin
      AgeAsAt := StrDate(YearOf(lstAgeAsAt), MonthOf(lstAgeAsAt), DayOf(lstAgeAsAt));

      if Syss.StaUIDate then
        MasterAged(LineAged, Inv.TransDate, AgeAsAt, Amnt, lstAgingPeriod, lstPeriodInterval)
      else
        MasterAged(LineAged, Inv.DueDate, AgeAsAt, Amnt, lstAgingPeriod, lstPeriodInterval);

      LineAged[1] := LineAged[1] + LineAged[0];

      if LineAged[lstPeriod + 1] = 0 then
        Result := EXCLUDE_FROM_DATASET
      { This 'else' clause is just so I can put a break-point on matching
        records. Remove when debugged. }
      else
        Result := INCLUDE_IN_DATASET;
    end
    else
      Result := EXCLUDE_FROM_DATASET;
  end
  else if (FunctionCategory in [fcCustBalance,   fcSuppBalance,
                                fcCustCommitted, fcSuppCommitted]) then
  begin
    if ((FunctionCategory in [fcCustBalance, fcSuppBalance]) and
        (not (Inv.InvDocHed in [SOR, POR]))) or
       ((FunctionCategory in [fcCustCommitted, fcSuppCommitted]) and
        (not (Inv.InvDocHed in [SIN, PIN, PCR, SCR]))) then
    begin
      if (lstPeriod > 100) Then
        Period := lstPeriod - 100
      else
        Period := lstPeriod;
      case lstFilterMode of
        dfToYear, dfToYearConsolidated:
          if (Inv.AcYr > lstYear) then
            Result := EXCLUDE_FROM_DATASET;
        dfToPeriod, dfToPeriodConsolidated:
          if (Inv.AcPr > Period) or
             (Inv.AcYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
        dfThisPeriodConsolidated:
          if (Inv.AcPr <> Period) or
             (Inv.AcYr <> lstYear) then
            Result := EXCLUDE_FROM_DATASET;
      end;
      if (Result = INCLUDE_IN_DATASET) then
      begin
        if (FunctionCategory = fcCustCommitted) and
           (Inv.RunNo <> OrdUSRunNo) then
          Result := EXCLUDE_FROM_DATASET
        else if (FunctionCategory = fcSuppCommitted) and
                (Inv.RunNo <> OrdUPRunNo) then
          Result := EXCLUDE_FROM_DATASET;
      end;
    end
    else
      Result := EXCLUDE_FROM_DATASET;
  end
end;

//=============================================================================
// TfrmCust
//=============================================================================

procedure TfrmCustHistory.BtListLabMouseDown(Sender: TObject;
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

procedure TfrmCustHistory.BtListLabMouseMove(Sender: TObject;
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

procedure TfrmCustHistory.BtListPanelMouseUp(Sender: TObject;
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

procedure TfrmCustHistory.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.btnViewLineClick(Sender: TObject);
begin
  ViewTransactionClick(Sender);
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.BuildList;
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
    BtList := NIL;
  End;
  BtList := TCustList.Create(Self);

  // Assign the filter fields
  BtList.AgeAsAt          := custAgeAsAt;
  BtList.AgeBy            := custAgeBy;
  BtList.Currency         := custCurrency;
  BtList.CustCode         := custCustCode;
  BtList.Location         := custLocation;
  BtList.Period           := custPeriod;
  BtList.PeriodInterval   := custPeriodInterval;
  BtList.StockCode        := custStockCode;
  BtList.Year             := custYear;
  BtList.FunctionCategory := custFunctionCategory;

  with BtList do
  begin
    try
      DetermineFilterMode;
      with VisiList do
      begin
        { Assign the panels and labels to the Btrieve list, to create the
          actual display columns }
        AddVisiRec(CLORefPanel,   CLORefLab);
        AddVisiRec(CLDatePanel,   CLDateLab);
        AddVisiRec(CLAMTPanel,    CLAMTLab);
        AddVisiRec(CLOSPanel,     CLOSLab);
        AddVisiRec(CLTotPanel,    CLTotLab);
        AddVisiRec(CLOrigPanel,   CLOrigLab);
        AddVisiRec(CLYRefPanel,   CLYRefLab);
        AddVisiRec(CLDuePanel,    CLDueLab);
        AddVisiRec(CLStatPanel,   CLStatLab);

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
    MUTotCols := 8; // NOTE: MUTotCols is actually the highest numbered column,
                    //       and the column list is zero-base, so this number
                    //       should be one less than the column count.
    Font := StartPanel.Font;

    LinkOtherDisp := BOn;

    WM_ListGetRec := WM_CustGetRec;

    Parent := StartPanel.Parent;

    MessHandle := Self.Handle;

    for n := 0 to MUTotCols do
    with ColAppear^[n] do
    begin
      AltDefault := BOn;
      if (n In [2..5]) then
      begin
        DispFormat := SGFloat;
        NoDecPlaces := 2;
      end;
    end;

    DisplayMode := 0;

    Filter[1, 0] := #1;

    ListLocal := @ExLocal;

    ListCreate;

    Set_Buttons(BtListBtnPanel);

    RefreshList(not FromHistory, BOff);

  end; {With}

  ReadFormPos := False;
  FindFormCoords;
  FormReSize(Self);

end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.CheckListFinished: Boolean;
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
      BtList.IRQSearch:=BOn;
      ShowMessage('Please wait a few seconds, then try closing again.');
    end;

  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.DisplayTransFrm(const IdFolio: LongInt;
  const DataChanged : Boolean);
var
  KeyS    : Str255;
  lStatus : SmallInt;
begin { Display_Trans }
  with ExLocal do
  begin
    if (not (Inv.InvDocHed in NomSplit + StkAdjSplit + TSTSplit)) then
    begin
      // Load Customer
      KeyS := FullCustCode(Inv.CustCode);
      lStatus := Find_Rec (B_GetEq, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
      if (lStatus = 0) then
      begin
        // Check the transaction display manager has been created
        if not Assigned (DisplayTrans) then
          DisplayTrans := TfrmDisplayTransManager.Create(Self);

        // Display the Transaction
        DisplayTrans.Display_Trans(Inv, Cust, DataChanged);
      end; { if (lStatus = 0) then... }
    end;
  end; { with ExLocal do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.FindFormCoords;
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
      PrimeKey := Format('C%2d', [Ord(self.FcustFunctionCategory)]);

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

procedure TfrmCustHistory.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  frmCustHistory := nil;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  n  : Integer;
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
    VertScrollBar.Position:=0;
    HorzScrollBar.Position:=0;
    if (NeedCUpdate or SetDefault or StoreCoordFlg.Checked) then
      StoreFormCoords(not SetDefault);
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.FormCreate(Sender: TObject);
begin
  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.AddReferenceCount;

  BtList := TCustList.Create(Self);

  { Record the initial form size. }
  InitSize.Y := self.Height;
  InitSize.X := self.Width;

  { Fix the form so that it cannot be shorter than the initial height, and
    cannot be wider than the initial width. }
  Constraints.MinHeight  := InitSize.Y - 1;

  Constraints.MinWidth   := 445;
  Constraints.MaxWidth   := InitSize.X;

  NeedCUpdate := BOff;
  ReadFormPos := BOff;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  LastCoord   := False;
  StoreCoord  := False;
  SetDefault  := False;

  StoreBtListCoords;

  StartSize.X := Width;
  StartSize.Y := Height;

  FromHistory := False;

  ExLocal.Create;

  ListOffset := 0;

//  Width := 638;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.FormDestroy(Sender: TObject);
begin
  if Assigned(DisplayTrans) then
    FreeAndNil(DisplayTrans);

  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.RemoveReferenceCount;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.FormResize(Sender: TObject);
begin
//  if BtListCoordsStored then
  if ReadFormPos then
  begin
    if Assigned(BtList) then
      BtList.LinkOtherDisp := BOff;

    self.HorzScrollBar.Position := 0;
    self.VertScrollBar.Position := 0;


    // Adjust the size of the page control
    PageControl.Left := 3;
    PageControl.Width := ClientWidth - (2 * PageControl.Left);

    PageControl.Left := 3;
    PageControl.Height := ClientHeight - (2 * PageControl.Left);
//    PageControl.Width  := Width  - PagePoint[1].X;
//    PageControl.Height := Height - PagePoint[1].Y;

    // Adjust the size of the scroll box
    BtListBox.Width  := LedgerPage.Width  - PagePoint[2].X;
    BtListBox.Height := LedgerPage.Height - PagePoint[2].Y;

    // Resize the Btrieve navigation bar
    BtListBtnPanel.Left   := LedgerPage.Width  - PagePoint[3].X;
    BtListBtnPanel.Height := LedgerPage.Height - PagePoint[3].Y;

    BtnPanel.Top := Self.ScreenToClient(LedgerPage.ClientToScreen(Point(0,BtListBox.Top))).Y;
    BtnPanel.Height := BtListBox.Height;
    BtnPanel.Left := PageControl.Width - (BtnPanel.Width + 4);
    //BtnPanel.Left := PageControl.Width - (BtnPanel.Width + 4);

    // Resize the Btrieve List columns
    if Assigned(BtList) then
    begin

      with BtList.VisiList do
      begin
        VisiRec := List[0];
        with (VisiRec^.PanelObj as TSBSPanel) do
          Height := BtListBtnPanel.Height;
      end; { With BtList.VisiList  }

      with BtList do
      begin
        ReFresh_Buttons;
        RefreshAllCols;
      end; { With BtList... }

      BtList.LinkOtherDisp := BOn;
    end; { If Assigned(BtList)... }

    NeedCUpdate := ((StartSize.X <> Width) or
                    (StartSize.Y <> Height));

  end; {If time to update}
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetAgeAsAt: TDateTime;
begin
  Result := FcustAgeAsAt;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetAgeBy: Char;
begin
  Result := FcustAgeBy;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetCurrency: Byte;
begin
  Result := FcustCurrency
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetCustCode: ShortString;
begin
  Result := FcustCustCode;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetFunctionCategory: TEnumFunctionCategory;
begin
  Result := FcustFunctionCategory;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetLocation: ShortString;
begin
  Result := FcustLocation;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetPeriod: SmallInt;
begin
  Result := FcustPeriod;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetPeriodInterval: Integer;
begin
  Result := FcustPeriodInterval;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetStockCode: ShortString;
begin
  Result := FcustStockCode;
end;

//-----------------------------------------------------------------------------

function TfrmCustHistory.GetYear: SmallInt;
begin
  Result := FcustYear;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.RefreshList(ShowLines, IgnoreMessages: Boolean);
var
  KeyStart: Str255;
  LKeyLen, KPath: Integer;
begin

  { Select the appropriate index and search key }
  KPath := InvCustK;
  KeyStart := FullCustCode(custCustCode);

  LKeyLen := Length(KeyStart);
  BtList.IgnoreMsg := IgnoreMessages;

  { Display the first page of records }
  BtList.StartList(InvF, KPath, KeyStart, '', '', LKeyLen, (not ShowLines));

  BtList.IgnoreMsg := BOff;

end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.ResetCoordinates1Click(Sender: TObject);
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

procedure TfrmCustHistory.SetAgeAsAt(const Value: TDateTime);
begin
  FcustAgeAsAt   := Value;
  BtList.AgeAsAt := FcustAgeAsAt;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetAgeBy(const Value: Char);
begin
  FcustAgeBy   := Value;
  BtList.AgeBy := FcustAgeBy;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetCurrency(const Value: Byte);
begin
  FcustCurrency   := Value;
  BtList.Currency := fcustCurrency;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetCustCode(const Value: ShortString);
begin
  FcustCustCode   := Value;
  BtList.CustCode := FcustCustCode;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetFunctionCategory(const Value: TEnumFunctionCategory);
begin
  FcustFunctionCategory   := Value;
  BtList.FunctionCategory := FcustFunctionCategory;
  Caption := FuncTitles[FcustFunctionCategory];
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetLocation(const Value: ShortString);
begin
  FcustLocation   := Value;
  BtList.Location := FcustLocation;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetNeedCUpdate(const Value: Boolean);
begin
  FNeedCUpDate := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetPeriod(const Value: SmallInt);
begin
  FcustPeriod   := Value;
  BtList.Period := FcustPeriod;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetPeriodInterval(const Value: Integer);
begin
  FcustPeriodInterval   := Value;
  BtList.PeriodInterval := FcustPeriodInterval;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetStockCode(const Value: ShortString);
begin
  FcustStockCode   := Value;
  BtList.StockCode := FcustStockCode;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.SetYear(const Value: SmallInt);
begin
  FcustYear   := Value;
  BtList.Year := FcustYear;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.ShowRightMenu(X, Y, Mode: Integer);
begin
  with PopUpMenu Do
    PopUp(X,Y);
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.StoreBtListCoords;
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

  BtListCoordsStored := True;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.StoreCoordFlgClick(Sender: TObject);
begin
  if StoreCoordFlg.Checked then
  begin
    SetDefault := False;
    ResetCoordinates1.Checked := False;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.StoreFormCoords(UpdateMode: Boolean);
var
  GlobComp:  TGlobCompRec;
begin
  New(GlobComp, Create(BOff));

  with GlobComp^ do
  begin
    GetValues := UpdateMode;

    PrimeKey := Format('C%2d', [Ord(FcustFunctionCategory)]);

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

procedure TfrmCustHistory.ViewTransactionClick(Sender: TObject);
begin
  with BtList do
  begin
    if ValidLine then
    begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      DisplayTransFrm(Id.FolioRef, False);
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
  begin
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
          if (WParam = 0) or ((WParam = 1) And Assigned(DisplayTrans)) Then
            DisplayTransFrm(Id.FolioRef, (WParam = 1));
        end;

      { pressed right click over list }
      2  : ShowRightMenu(LParamLo,LParamHi,1);

//      25 :  NeedCUpdate := BOn;
    end;
  end;
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmCustHistory.WMWindowPosChanged(var Msg: TMessage);
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

//-----------------------------------------------------------------------------

end.
