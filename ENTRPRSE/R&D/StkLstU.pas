Unit StkLstU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VARRec2U,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,ColCtrlU,
  CmpCtrlU,SupListU, StockU,Menus,
  StkPricU,StkWarnU,
  {$IFDEF SOP}
    StkROrdr,
    SOPFOFiU,
    StkTakeU,
    MLoc0U,

    AltCLs2U,

  {$ENDIF}

  VarSortV,
  SortViewU,
  SortStk,
  ImgModU,

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  ExtGetU,
  BarGU, TCustom,
  EntWindowSettings,
  // SSK 21/05/2018 2018-R1.1 ABSEXCH-20306: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport;




type
  // PKR. 10/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to relevant suppliers
  // Provide different print options.
  TReorderModes = (rmCreateOnly, rmCreateAndPrint, rmUseSupplierDefaults);

  {=== Daybook List ===}
  TStkMList  =  Class(TDDMList)
  private
    TempStockRec: StockRec;
    function GetSortView: TBaseSortView;
    procedure SetSortView(const Value: TBaseSortView);
  Public

    MinFilt,
    CovMode,
    Back2Back,
    GrpFilt,
    GenWORMode,
    NoDelist    :  Boolean;

    MLStkLocFilt:  ^Str20;
//    CStkGrpFilt,
    StkGrpFilt  :  ^Str20;

    DelMode     :  Byte;

//    GrpTList    :  TList;  {*EL: Ex v6.01 Memory cache holder for filter by Product Group *}
    GroupList   :  TStringList; { CJS: Cache of Product Groups }

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    UseDefaultSortView: Boolean;

    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    {*EL: Ex v6.01 Memory cache holder for filter by Product Group *}

    Procedure ClearStkGrpCache(FinalCall  :  Boolean);

    Procedure AddStkGrpCacheNode(SeedGrp  :  Str20);

    Procedure BuildStkGrpCache(SeedGrp  :  Str20;
                               Level    :  LongInt);

    Function CompareGrpCache(SeedGrp  :  Str20)  :  Boolean;

    {*====*}

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowSubEmph :  Boolean;

    Function CheckRowEmph :  Byte; Override;

    Procedure Find_SuppOnList(RecMainKey  :  Str255);

    Function OutSList(Col  :  Byte)  :  Str255;


    {$IFDEF SOP}
      Function OutROLine(Col  :  Byte)  :  Str255;

      Function OutSTake(Col  :  Byte)  :  Str255;
    {$ENDIF}

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Function FindxCode(KeyChk  :  Str255;
                       SM      :  SmallInt)  :  Boolean;


    constructor Create(AOwner: TComponent);
    destructor Destroy;
    procedure CreateSortView(Mode: Integer);
    property SortView: TBaseSortView read GetSortView write SetSortView;
  end;


type
  TStkList = class(TForm)
    pcStockList: TPageControl;
    TabSheet1: TTabSheet;
    SLSBox: TScrollBox;
    SLDPanel: TSBSPanel;
    SLCPanel: TSBSPanel;
    SLFPanel: TSBSPanel;
    SLIPanel: TSBSPanel;
    SLHedPanel: TSBSPanel;
    SLCLab: TSBSPanel;
    SLDLab: TSBSPanel;
    SLILab: TSBSPanel;
    SLFLab: TSBSPanel;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    SLOPanel: TSBSPanel;
    SLOLab: TSBSPanel;
    SLListBtnPanel: TSBSPanel;
    SLBtnPanel: TSBSPanel;
    ClsDb1Btn: TButton;
    SLBSBox: TScrollBox;
    Editdb1Btn: TButton;
    FindDb1Btn: TButton;
    Deldb1Btn: TButton;
    Notedb1Btn: TButton;
    Chkdb1Btn: TButton;
    Valdb1Btn: TButton;
    Pricdb1Btn: TButton;
    Leddb1Btn: TButton;
    Histdb1Btn: TButton;
    Builddb1Btn: TButton;
    Sortdb1Btn: TButton;
    Qtydb1Btn: TButton;
    Agedb1Btn: TButton;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    Ledger1: TMenuItem;
    History1: TMenuItem;
    Notes1: TMenuItem;
    Sort1: TMenuItem;
    Build1: TMenuItem;
    Prices1: TMenuItem;
    Value1: TMenuItem;
    QtyBreaks1: TMenuItem;
    Check1: TMenuItem;
    Delete1: TMenuItem;
    Age1: TMenuItem;
    UPBOMP: TSBSPanel;
    PopupMenu2: TPopupMenu;
    Build2: TMenuItem;
    UpdateCostings1: TMenuItem;
    ROSBox: TScrollBox;
    ROCPanel: TSBSPanel;
    ROSPanel: TSBSPanel;
    ROMPanel: TSBSPanel;
    ROFPanel: TSBSPanel;
    ROHedPanel: TSBSPanel;
    ROCLab: TSBSPanel;
    ROSLab: TSBSPanel;
    RONLab: TSBSPanel;
    ROFLab: TSBSPanel;
    ROOLab: TSBSPanel;
    RONPanel: TSBSPanel;
    ROMLab: TSBSPanel;
    ROOPanel: TSBSPanel;
    RORPanel: TSBSPanel;
    RORLab: TSBSPanel;
    ROTLab: TSBSPanel;
    ROTPanel: TSBSPanel;
    STSBox: TScrollBox;
    STCPanel: TSBSPanel;
    STBPanel: TSBSPanel;
    STDPanel: TSBSPanel;
    STHedPanel: TSBSPanel;
    STCLab: TSBSPanel;
    STBLab: TSBSPanel;
    STALab: TSBSPanel;
    STDLAb: TSBSPanel;
    STILab: TSBSPanel;
    STFLab: TSBSPanel;
    STAPanel: TSBSPanel;
    STIPanel: TSBSPanel;
    STFPanel: TSBSPanel;
    ROListBtnPanel: TSBSPanel;
    STListBtnPanel: TSBSPanel;
    DLdb1Btn: TButton;
    Mindb1Btn: TButton;
    ASdb1Btn: TButton;
    BOdb1Btn: TButton;
    FIDb1Btn: TButton;
    FRdb1Btn: TButton;
    DeList1: TMenuItem;
    Min1: TMenuItem;
    AutoSet1: TMenuItem;
    BackOrder1: TMenuItem;
    Freeze1: TMenuItem;
    Process1: TMenuItem;
    Filter1: TMenuItem;
    PRdb1Btn: TButton;
    Locdb1Btn: TButton;
    Loc1: TMenuItem;
    PopupMenu3: TPopupMenu;
    FList1: TMenuItem;
    View1: TMenuItem;
    Lnkdb1Btn: TButton;
    Links1: TMenuItem;
    Altdb1Btn: TButton;
    AltCodes1: TMenuItem;
    EntCustom4: TCustomisation;
    CustdbBtn1: TSBSButton;
    CustdbBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    PopupMenu4: TPopupMenu;
    ASROQty1: TMenuItem;
    ARROQty1: TMenuItem;
    Adddb1Btn: TButton;
    Add1: TMenuItem;
    SortViewBtn: TButton;
    SortView1: TMenuItem;
    Refreshview1: TMenuItem;
    Closeview1: TMenuItem;
    N4: TMenuItem;
    SortViewOptions1: TMenuItem;
    SortViewPopupMenu: TPopupMenu;
    RefreshView2: TMenuItem;
    CloseView2: TMenuItem;
    MenuItem3: TMenuItem;
    SortViewOptions2: TMenuItem;
    ProcessButtonPopupMenu: TPopupMenu;
    CreatePurchaseOrdersOnly: TMenuItem;
    PrintPurchaseOrders: TMenuItem;
    UseSupplierDefaults: TMenuItem;
    N5: TMenuItem;
    Cancel: TMenuItem;
    WindowExport: TWindowExport;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pcStockListChange(Sender: TObject);
    procedure pcStockListChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure SLCPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SLCLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SLCLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ClsDb1BtnClick(Sender: TObject);
    procedure Sortdb1BtnClick(Sender: TObject);
    procedure Editdb1BtnClick(Sender: TObject);
    procedure Pricdb1BtnClick(Sender: TObject);
    procedure Agedb1BtnClick(Sender: TObject);
    procedure UpdateCostings1Click(Sender: TObject);
    procedure Builddb1BtnClick(Sender: TObject);
    procedure Chkdb1BtnClick(Sender: TObject);
    procedure FindDb1BtnClick(Sender: TObject);
    procedure DLdb1BtnClick(Sender: TObject);
    procedure ASdb1BtnClick(Sender: TObject);
    procedure FIDb1BtnClick(Sender: TObject);
    procedure PRdb1BtnClick(Sender: TObject);
    procedure FRdb1BtnClick(Sender: TObject);
    procedure Locdb1BtnClick(Sender: TObject);
    procedure FList1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure Lnkdb1BtnClick(Sender: TObject);
    procedure Altdb1BtnClick(Sender: TObject);
    procedure CustdbBtn1Click(Sender: TObject);
    procedure ASROQty1Click(Sender: TObject);
    procedure Refreshview1Click(Sender: TObject);
    procedure Closeview1Click(Sender: TObject);
    procedure SortViewOptions1Click(Sender: TObject);
    procedure SortViewBtnClick(Sender: TObject);
    procedure CreatePurchaseOrdersOnlyClick(Sender: TObject);
    procedure PrintPurchaseOrdersClick(Sender: TObject);
    procedure UseSupplierDefaultsClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    function WindowExportGetExportDescription: String;
    procedure WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);

  private
    { Private declarations }

    ListActive,
    KeepLive,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    FColorsChanged,
    fFrmClosing,
    fFrmAutoClose,
    fDoingClose,
    InAutoRefresh,
    fResetBinLoc,
    GotCoord   :  Boolean;

    StkLocFilt :  Str10;
    LastSLFilt :  Array[0..2] of Str10;

    Sorted,
    SKeypath   :  Integer;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;

    CustBtnList:  Array[0..5] of TVisiBtns;

    FormBitMap :  TBitMap;

    StkActive  :  Boolean;

    StkRecForm :  TStockRec;

    {$IFDEF SOP}
       SRORec  :  TStkReOrd;
       STARec  :  TStkTake;
       ROFIRec :  TSOPROFiFrm;
       MLocList:  TLocnList;
       AltCList:  TAltCList;
    {$ENDIF}

    ShowPrice  :  TPrices;
    ShowAge    :  TStkWarn;
    Progress   :  TBarP;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

     ROLineCUPtr  :  Pointer;

    // PKR. 10/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to relevant suppliers
    ReorderMode : TReorderModes;

    // CJS: 13/12/2010 - Amendments for new Window Settings system
    FSettings: IWindowSettings;
    procedure LoadListSettings(ForListNo: Integer);
    procedure SaveListSettings(ForListNo: Integer);
    procedure LoadWindowSettings;
    procedure SaveWindowSettings;
    procedure EditWindowSettings;

    {$IFDEF PF_On}
      procedure Warn_UPBOM;
    {$ENDIF}

    procedure BuildMenus;

    procedure SetTabs2;

    procedure FormSetOfSet;

    Function ChkPWord(PageNo :  Integer) :  LongInt;

    Function SetHelpC(PageNo :  Integer;
                      Help0,
                      Help1,
                      Help2  :  LongInt) :  LongInt;

    procedure SetProcessCaption;

    procedure PrimeButtons(PageNo  :  Integer;
                           PWRef   :  Boolean);

    Procedure Send_ParentMsg(Mode   :  Integer);

    procedure HidePanels(PageNo  :  Byte);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_Account(Mode  :  Byte);

    Procedure SetDeleteStat(StockR  :  StockRec);

    Procedure ExecuteListCU;

    Procedure WMDayBkGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMSetFocus(Var Message  :  TMessage); Message WM_SetFocus;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    


    Procedure Update_Kits(StockR  :  StockRec);

    Procedure Scan_Bill;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    Procedure SetMainCaption;

    {$IFDEF SOP}
      procedure Display_SRORec;
      procedure Display_SROFIRec;
      procedure Display_STARec;

      procedure SetListCaption(B2B  :  Boolean);

      procedure Link2MLoc(ScanMode  :  Boolean);

      procedure Link2AltC(ScanMode  :  Boolean);

      function SetLocDefs  :  Boolean;

      Procedure sdb_SetRODet(TMisc    :  sdbStkType);

    {$ENDIF}

    procedure SetHelpContextIDs; // NF: 20/06/06

    // PKR. 11/12/2015. ABSEXCH-15333. Add reorder mode for selective printing/email etc.
    procedure ProcessReorder(aReorderMode : TReorderModes);
  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    ListOfSet  :  Integer;

    MULCtrlO   :  Array[0..5] of TStkMList;
    MULAddr    :  Array[0..5] of LongInt;


    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

    procedure ShowSortViewDlg;

  end;


  Procedure Set_SListFormMode(StagePage   :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BtKeys1U,
  Comnunit,
  ComnU2,
  CurrncyU,
  SysU1,
  SalTxl1U,

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  PayF2U,
  Warn1U,
  PWarnU,


  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF POST}
    ReValueU,
  {$ENDIF}

  {$IFDEF SOP}
    StkROCtl,
    InvListU,
    InvLst3U,
    DiscU3U,
    {$IFDEF WOP}
      WORIWizU,
    {$ENDIF}
    InvCTSuU,
    StkROFrm,
  {$ENDIF}


  ExThrd2U,

  {$IFDEF CU}
    Event1U,
    CustWinU,
    CustIntU,
    OStock,
  {$ENDIF}

  SortViewOptionsF,

  SysU2,

  oProcessLock;




{$R *.DFM}


Var
  SListFormPage  :  Byte;


{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_SListFormMode(StagePage   :  Byte);
Begin
  If (StagePage<>SListFormPage) and (StagePage<=2) then
    SListFormPage:=StagePage;
end;



{ ============== TStkMList Methods =============== }

constructor TStkMList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TStkMList.CreateSortView(Mode: Integer);
begin
  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
  UseDefaultSortView := True;

  case Mode of
    0: SortView := TStockListSortView.Create;
    1: SortView := TStockReorderSortView.Create;
    2: SortView := TStockTakeSortView.Create;
  else
    raise Exception.Create('Invalid TStkMList SortView mode of ' + IntToStr(Mode));
  end;
end;

destructor TStkMList.Destroy;
begin
  FreeAndNil(FSortView);
  inherited Destroy;
end;

function TStkMList.GetSortView: TBaseSortView;
begin
  Result := FSortView;
end;

procedure TStkMList.SetSortView(const Value: TBaseSortView);
begin
  inherited SetSortView(Value);
end;

procedure TStkMList.ExtObjCreate;

Begin
  Inherited;

  MinFilt:=BOff;
  CovMode:=BOff;
  NoDeList:=BOff;
  Back2Back:=BOff;
  GenWORMode:=BOff;
  GrpFilt:=BOff;
  New(StkGrpFilt);

  StkGrpFilt^:='';
//  CStkGrpFilt:=Nil;
//  GrpTList:=Nil;
  GroupList := nil;

end;


procedure TStkMList.ExtObjDestroy;

Begin
  Inherited;

  Dispose(StkGrpFilt);

  ClearStkGrpCache(BOn); {*EL: Ex v6.01 Memory cache holder for filter by Product Group *}

  {$IFDEF SOP}
  InvLst3U.ResetCache;
  {$ENDIF}
end;


{*EL: Ex v6.01 Memory cache holder for filter by Product Group *}
{ CJS: Modified cache holder to use TStringList }

Procedure TStkMList.ClearStkGrpCache(FinalCall  :  Boolean);
Begin
  If (Assigned(GroupList)) then
  try
    GroupList.Clear;
    if (FinalCall) then
      FreeAndNil(GroupList);
  except
    FreeAndNil(GroupList);
  end; {try..}
end; {Proc..}


Procedure TStkMList.AddStkGrpCacheNode(SeedGrp  :  Str20);
Begin
  If (Not Assigned(GroupList)) then
    GroupList := TStringList.Create;

  try
    GroupList.Add(SeedGrp);
  except
    ClearStkGrpCache(BOn);
  end; {try..}
end; {Proc..}

Procedure TStkMList.BuildStkGrpCache(SeedGrp  :  Str20;
                                     Level    :  LongInt);

Const
  FnumS     =  StockF;
  KeypathS  =  StkCatK;


Var
  KeyChkS,
  KeySS   :  Str255;
  FoundOk :  Boolean;
  TmpKPath,
  TmpStat,
  LastStat:  Integer;

  TStock  :  StockRec;

  TmpRecAddr
          :  LongInt;


Begin
  If (Level=0) then {* Clear any previous cache *}
  Begin
    If (Assigned(GroupList)) then
      ClearStkGrpCache(BOff)
    else
      GroupList:=TStringList.Create;
  end;

  LastStat:=Status;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(FnumS,TmpKPath,F[FnumS],TmpRecAddr,BOff,BOff);

  TStock:=Stock;

  KeySS:=FullStockCode(SeedGrp);
  KeyChkS:=KeySS;

  If (Not EmptyKey(SeedGrp,StkKeyLen)) and (Assigned(GroupList)) then
  Begin
    AddStkGrpCacheNode(KeyChkS);

    Status:=Find_Rec(B_GetGEq,F[FnumS],FnumS,RecPtr[FnumS]^,KeypathS,KeySS);


    While (StatusOk) and (CheckKey(KeyChkS,KeySS,Length(KeyChkS),BOff)) and (Assigned(GroupList)) do
    With Stock do
    Begin
      If (StockType =StkGrpCode) then
        BuildStkGrpCache(StockCode,Succ(Level));

      Status:=Find_Rec(B_GetNext,F[FnumS],FnumS,RecPtr[FnumS]^,KeypathS,KeySS);
    end; {While..}

    TmpStat:=Presrv_BTPos(FnumS,TmpKPath,F[FnumS],TmpRecAddr,BOn,BOff);

    Stock:=TStock;

    Status:=LastStat;
  end; {If..}
  GroupList.Sorted := True;
end; {Proc..}


Function TStkMList.CompareGrpCache(SeedGrp  :  Str20)  :  Boolean;
Begin
  Result := False;
  If (Assigned(GroupList)) then
    Result := (GroupList.IndexOf(SeedGrp) <> -1);
end; {func..}


Function TStkMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;

  TmpRunNo,
  TmpFolio  :  LongInt;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Stock do
  Begin

    Case Keypath of


      StkCodeK  :  DumStr:=StockCode;
      StkDescK  :  DumStr:=Desc[1];
      StkBinK   :  DumStr:=BinLoc;
      StkMinK   :  DumStr:=SuppTemp;
    end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;




Function TStkMList.SetFilter  :  Str255;
Var
  ExcTypSet  : CharSet;
  TmpStk     :  StockRec;
Begin
  ExcTypSet:=[StkDListCode];

  If (Not GenWORMode) then
    ExcTypSet:=ExcTypSet+[StkBillCode];

  TmpStk:=Stock;

  case DisplayMode of
    1,2  :  begin
              if (TmpStk.StockType = StkGrpCode) or
                 ((Not NoDeList) and (TmpStk.StockType In ExcTypSet)) then
                Result := '!'
              else
              begin
                {$IFDEF SOP}
                InvLst3U.UseCache := True;
                Stock_LocROSubst(TmpStk,MLStkLocFilt^);
                {$ENDIF}
                with TmpStk do
                begin
                  {$B-}
                    if ((MinFilt) and (Not MinFlg) and (Not Back2Back))
                      or ((MinFilt) and (AllocStock(TmpStk)=0) and (Back2Back))
                      or (GenWORMode and (StockType<>StkBillCode))                             {*EL: Ex v6.01 Memory cache holder for filter by Product Group *}
                      or ((StkGrpFilt^<>'') and (Not CompareGrpCache(StockCat))) then
                    Result:='!'
                  else
                    Result:=TmpStk.StockType;
                  {$B+}
                end;
              end;
            end;
    else
    begin
      {$IFDEF SOP}
      InvLst3U.UseCache := True;
      Stock_LocROSubst(TmpStk,MLStkLocFilt^);
      {$ENDIF}
      Result := TmpStk.StockType;
    end;

  end; {case..}
end;


Function TStkMList.Ok2Del :  Boolean;


Begin
  Result:=Ok2DelStk(DelMode,Stock);
end;


Function TStkMList.CheckRowSubEmph :  Boolean;

Var
  TmpStk  :  StockRec;
Begin
  TmpStk:=Stock;
  Result := False;
  With TmpStk do
    Case DisplayMode of
      0  :  Result:=BOff;
      1  :  Begin
              {$IFDEF SOP}
                Stock_LocROSubst(TmpStk,MLStkLocFilt^);
              {$ENDIF}
                Result:=ROFlg;
            end;

      2  :  Begin
              {$IFDEF SOP}
                Stock_LocTKSubst(TmpStk,MLStkLocFilt^);
              {$ENDIF}

              Result:=StkFlg;
            end;
    end; {Case..}
end;

Function TStkMList.CheckRowEmph :  Byte;
Begin
  With Stock do
    Result:=(1*Ord(StockType=StkBillCode))+(2*Ord(CheckRowSubEmph))+(4*Ord(StockType=StkDListCode));
end;


Procedure TStkMList.Find_SuppOnList(RecMainKey  :  Str255);
Var
  KeyChk  :  Str255;

Begin

  KeyChk:=RecMainKey;

//  Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,RecMainKey);
  Status:=Find_Rec(B_GetGEq,F[StockF],StockF,RecPtr[StockF]^,4,RecMainKey);

  If (Not StatusOk) or (Not CheckKey(KeyChk,RecMainKey,Length(KeyChk),BOff)) then
    ShowMessage('Unable to find any re-order stock for Supplier '+Strip('B',[#32],KeyChk));

  If (StatusOk) then
  Begin
    if SortViewEnabled then
    begin
      SortView.SyncTemp;
      Status:=GetPos(F[SortTempF],SortTempF,PageKeys^[0]);
      KeyRef := '';
    end
    else
      Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);

    PageUpDn(0,BOn);
  end;

end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TStkMList.OutSList(Col  :  Byte)  :  Str255;

Var
  TmpStk  :  StockRec;

Begin
  TmpStk:=Stock;

   {$IFDEF SOP}

      Stock_LocSubst(TmpStk,MLStkLocFilt^);

    {$ENDIF}

   With TmpStk do
     Case Col of

       0  :  Result:=StockCode;
       1  :  Result:=Desc[1];

       2  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,QtyInStock));
       3  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,FreeStock(TmpStk)));
       4  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,QtyOnOrder));

       else
             Result:='';

     end; {Case..}
end;


{$IFDEF SOP}

  { ========== Generic Function to Return Formatted Display for List ======= }


  Function TStkMList.OutROLine(Col  :  Byte)  :  Str255;


  Var
    FoundOk    :  Boolean;
    Dnum       :  Double;
    GenStr     :  Str255;
    TmpStk     :  StockRec;

    QQty,
    QPrice,
    QDisc      :  Real;

    CHDisc     :  Char;

    TDate      :  LongDate;


  Begin
    TmpStk:=Stock; QDisc:=0.0; CHDisc:=#0; QPrice:=0.0; TDate:='';

   {$IFDEF SOP}
     if Col = 0 then
     begin
       TempStockRec := Stock;
       InvLst3U.UseCache := True;
//       Stock_LocSubst(TmpStk,MLStkLocFilt^);
//       Stock_LocROSubst(TmpStk,MLStkLocFilt^);

       Stock_LocSubst(TempStockRec,MLStkLocFilt^);
       Stock_LocROSubst(TempStockRec,MLStkLocFilt^);

     end
     else
       TmpStk := TempStockRec;
   {$ENDIF}

     With TmpStk do
       Case Col of

         0  :  Result:=SuppTemp;
         1  :  Result:=StockCode;
         2  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,FreeStock(TmpStk)));

         3  :  Begin
                 If (Back2Back) then
                   Dnum:=AllocStock(TmpStk)
                 else
                   Dnum:=QtyMin;

                 Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,Dnum));
               end;

         4  :  Begin
                 Dnum:=QtyOnOrder;

                 {If (GenWORMode) and (StockType=StkBillCode) then {Show whats already on the Works Order}
                 {Begin
                   Dnum:=Dnum-WOPAllocStock(TmpStk);

                   If (Dnum<0) then
                     Dnum:=0;

                   Disabled as in this mode it is confusing to hide any that are allocated to a works order.
                 end;}

                 Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,Dnum));
               end;

         5  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,Stk_SuggROQ(TmpStk,Back2Back,(GenWORMode and (StockType=StkBillCode)))));
         6  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,Stock.ROQty));

         7  :  Begin
                 If (KeyRef<>'') then
                 Begin
                   If (ROQty>0) then
                     QQty:=ROQty
                   else
                     QQty:=1;

                   TDate:=Today;
                   Calc_StockPrice(Stock,Cust,ROCurrency,QQty,TDate,QPrice,QDisc,CHDisc,MLStkLocFilt^,FoundOk,0);

                   If (FoundOk) then
                     Dnum:=Round_Up(QPrice-Calc_PAmount(QPrice,QDisc,CHDisc),Syss.NoCosDec)
                   else
                     Dnum:=ROCPrice;

                   Result:=FormatCurFloat(GenUnitMask[BOff],Dnum,BOff,ROCurrency);
                 end
                 else
                   Result:=FormatCurFloat(GenUnitMask[BOff],ROCPrice,BOff,ROCurrency);
               end;


         else
               Result:='';

       end; {Case..}
  end;


  { ========== Generic Function to Return Formatted Display for List ======= }


  Function TStkMList.OutSTake(Col  :  Byte)  :  Str255;


  Var
    Dnum       :  Double;
    GenStr     :  Str255;
    TmpStk     :  StockRec;

  Begin
    TmpStk:=Stock;

   {$IFDEF SOP}
     Stock_LocSubst(TmpStk,MLStkLocFilt^);
     Stock_LocTKSubst(TmpStk,MLStkLocFilt^);

   {$ENDIF}

     With TmpStk do
     Case Col of

         0  :  Result:=BinLoc;
         1  :  Result:=StockCode;
         2  :  Result:=Desc[1];

         3  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,QtyFreeze));
         4  :  Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,QtyTake));

         5  :  Begin
                 If (StkFlg) then
                   Dnum:=QtyTake-QtyFreeze
                 else
                   Dnum:=0;

                 Result:=FormatFloat(GenQtyMask,CaseQty(TmpStk,Dnum));
               end;



         else
               Result:='';

       end; {Case..}
  end;

{$ENDIF}

{ ========== Generic Function to Return Formatted Display for List ======= }

Function TStkMList.OutLine(Col  :  Byte)  :  Str255;

Var
  KeySupp  :  Str255;

Begin
  KeySupp:=Stock.SuppTemp;

  Case DisplayMode of
    0  :  Begin
            Result:=OutSList(Col);
            KeySupp:=Stock.Supplier;
          end;

  {$IFDEF SOP}

    1  :  Result:=OutROLine(Col);
    2  :  Result:=OutSTake(Col);

  {$ENDIF}
  end;

  If (KeySupp<>Cust.CustCode) then {* For Link to F2 *}
    Global_GetMainRec(CustF,KeySupp);


end;

Function TStkMList.FindxCode(KeyChk  :  Str255;
                             SM      :  SmallInt)  :  Boolean;

Const
  OFnum     =  StockF;

Var
  OKeyS     :  Str255;
  OKeypath  :  Integer;

Begin
  OKeyPath := 0;
  OKeyS:=KeyChk;

  Case SM of
    30  :  OKeypath:=StkCodeK;
    31  :  OKeypath:=StkDescK;
    32  :  OKeypath:=StkAltK;
    33  :  OKeyPath:=StkBarCK;
  end; {case..}

  Status:=Find_Rec(B_GetGEq,F[OFnum],OFnum,RecPtr[OFnum]^,OKeyPath,OKeyS);

  If (Status=0) and (CheckKey(KeyChk,OKeyS,Length(KeyChk),BOff)) and (LineOk(SetCheckKey)) then
  Begin
    Result:=BOn;
    if SortViewEnabled then
    begin
      SortView.SyncTemp;
      Status:=GetPos(F[SortTempF],SortTempF,PageKeys^[0]);
      KeyRef := '';
    end
    else
      Status:=GetPos(F[OFnum],OFnum,PageKeys^[0]);

    MUListBoxes[0].Row:=0;
    PageUpDn(0,BOn);
  end
  else
    Result:=BOff;

end;



{ =================================================================================== }


{ =================================================================================== }




Function TStkList.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(pcStockList);

end;



Procedure  TStkList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TStkList.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(pcStockList.Width);
  PagePoint[0].Y:=ClientHeight-(pcStockList.Height);

  PagePoint[1].X:=pcStockList.Width-(SLSBox.Width);
  PagePoint[1].Y:=pcStockList.Height-(SLSBox.Height);

  PagePoint[2].X:=pcStockList.Width-(SLBtnPanel.Left);
  PagePoint[2].Y:=pcStockList.Height-(SLBtnPanel.Height);

  PagePoint[3].X:=SLBtnPanel.Height-(SLBSBox.Height);
  PagePoint[3].Y:=SLSBox.ClientHeight-(SLCPanel.Height);

  PagePoint[4].X:=pcStockList.Width-(SLListBtnPanel.Left);
  PagePoint[4].Y:=pcStockList.Height-(SLListBtnPanel.Height);

  GotCoord:=BOn;

end;


Function TStkList.ChkPWord(PageNo :  Integer):  LongInt;


Begin
  Result:=-255;

  Case PageNo of
    1  :  Result:=175;
    2  :  Result:=178;
  end;

end;

Function TStkList.SetHelpC(PageNo :  Integer;
                           Help0,
                           Help1,
                           Help2  :  LongInt) :  LongInt;

Begin
  Case PageNo of
    0  :  Result:=Help0;
    1  :  Result:=Help1;
    2  :  Result:=Help2;
    else  Result:=-1;

  end; {Case..}
end;


procedure TStkList.SetProcessCaption;

Var
  ThisPage  :  Integer;

Begin
  ThisPage:=Current_Page;


  {$B-}
  If (Assigned(MULCtrlO[ThisPage])) and (MULCtrlO[ThisPage].GenWORMode) and (ThisPage=1) then
  {$B+}
  Begin
    PrDb1Btn.Caption:='&Works Order';
    Process1.Caption:='&Works Order';
//    HelpContext:=1247;
    Process1.HelpContext:=1247; // NF: Corrected
    PrDb1Btn.Hint:='Generate a Works Order|Generate a Works Order for the currently highlighted item based on the order quantity set.'
  end
  else
  Begin
    PrDb1Btn.Caption:='P&rocess';
    Process1.Caption:='P&rocess';
//    HelpContext:=525;
    Process1.HelpContext:=525; // NF: Corrected
    PrDb1Btn.Hint:='Process the list|Process the list as highlighted.'
  end;
end;

procedure TStkList.PrimeButtons(PageNo  :  Integer;
                                PWRef   :  Boolean);
Var
  HideAge  :  Boolean;

Begin
  If (PWRef) and (Assigned(CustBtnList[PageNo])) then
  Begin
    LockWindowUpDate(Handle);

    SetTabs2;
    CustBtnList[PageNo].ResetButtons;
    CustBtnList[PageNo].Free;
    CustBtnList[PageNo]:=nil;

  end;


  If (CustBtnList[PageNo]=nil) then
  Begin
    CustBtnList[PageNo]:=TVisiBtns.Create;

    {$IFNDEF SOP}
      HideAge:=BOn;
    {$ELSE}
      HideAge:=Not ChkAllowed_In(148);
    {$ENDIF}

    try

      With CustBtnList[PageNo] do
        Begin

     {00} PWAddVisiRec(Adddb1Btn,{$IFDEF LTE} (PageNo<>0) or (ICEDFM=2) {$ELSE} BOn {$ENDIF},110);
          SetBtnHelp(0,SetHelpC(PageNo,156,518,527));

     {01} PWAddVisiRec(Editdb1Btn,BOff,111);
          SetBtnHelp(1,SetHelpC(PageNo,155,518,527));

     {02} AddVisiRec(Finddb1Btn,BOff);
          SetBtnHelp(2,SetHelpC(PageNo,165,519,519));

     {03} PWAddVisiRec(Leddb1Btn,BOff,109);
     {04} PWAddVisiRec(Histdb1Btn,BOff,302);

     {05} PWAddVisiRec(SortViewBtn,BOff,589);

     {06} AddVisiRec(Notedb1Btn,BOff);
     {07} AddVisiRec(Sortdb1Btn,(PageNo=1));
     {08} PWAddVisiRec(Builddb1Btn,Not FullStkSysOn,114);
     {09} PWAddVisiRec(Pricdb1Btn,(PageNo<>0),474);
     {10} PWAddVisiRec(Valdb1Btn,BOff,149);
     {11} PWAddVisiRec(Qtydb1Btn,(PageNo<>0),147);
     {12} AddVisiRec(Agedb1Btn,(HideAge or (PageNo<>0)));
     {13} PWAddVisiRec(Deldb1Btn,BOff,112);


       {$IFDEF SOP}
     {14} AddVisiRec(Locdb1Btn,Not Syss.UseMLoc);
       {$ELSE}

     {14} AddVisiRec(Locdb1Btn,BOn);
       {$ENDIF}

     {15} PWAddVisiRec(Chkdb1Btn,(PageNo<>0) or (ICEDFM<>0),112);
     {16} AddVisiRec(Dldb1Btn,(PageNo=0));
     {17} AddVisiRec(Mindb1Btn,(PageNo<>1));
     {18} AddVisiRec(ASdb1Btn,(PageNo<>1));
     {19} AddVisiRec(BOdb1Btn,(PageNo<>1));
     {20} PWAddVisiRec(FRdb1Btn,(PageNo<>2),177);
     {21} AddVisiRec(FIdb1Btn,{$IFDEF LTE} (PageNo=2) {$ELSE} (PageNo<>1) {$ENDIF});
     {22} PWAddVisiRec(PRdb1Btn,(PageNo=0) or (ICEDFM<>0),ChkPWord(PageNo));
          SetBtnHelp(21,SetHelpC(PageNo,525,525,535));

          {$IFNDEF SOP}
     {23}   AddVisiRec(Altdb1Btn,BOn);
          {$ELSE}
            {$IFDEF LTE}
              AddVisiRec(Altdb1Btn,BOn);
            {$ELSE}
              AddVisiRec(Altdb1Btn,BOff);
            {$ENDIF}

          {$ENDIF}

     {24} AddVisiRec(Lnkdb1Btn,BOff);

     {$IFDEF CU}
       {25}  AddVisiRec(CustdbBtn1,Not EnableCustBtns(3000,10+PageNo));
       {26}  AddVisiRec(CustdbBtn2,Not EnableCustBtns(3000,20+PageNo));
     {$ELSE}
       {25}  AddVisiRec(CustdbBtn1,BOn);
       {26}  AddVisiRec(CustdbBtn2,BOn);
     {$ENDIF}


          HideButtons;
        end; {With..}

    except

      CustBtnList[PageNo].Free;
      CustBtnList[PageNo]:=nil;
    end; {Try..}

    If (PWRef) then
      LockWindowUpDate(0);


  end {If needs creating }
  else
    CustBtnList[PageNo].RefreshButtons;

  SetProcessCaption;

end;


procedure TStkList.BuildMenus;

Begin
  CreateSubMenu(PopUpMenu2,Build1);
  CreateSubMenu(PopUpMenu3,Loc1);

  {$IFDEF SOP}
    CreateSubMenu(PopUpMenu4,AutoSet1);
  {$ENDIF}
end;

procedure TStkList.SetTabs2;

Begin
  {$IFDEF SOP}

    TabSheet2.TabVisible:=BoChkAllowed_In(BOn,174) and (FullStkSysOn) ;
    TabSheet3.TabVisible:=BoChkAllowed_In(BOn,176) and (FullStkSysOn) ;

  {$ELSE}

    TabSheet2.TabVisible:=BOff;
    TabSheet3.TabVisible:=BOff;

  {$ENDIF}



end;


Procedure TStkList.SetMainCaption;

Begin
  Caption:='Stock List.';

  {$IFDEF SOP}
    If (Not EmptyKey(StkLocFilt,LocKeyLen)) then
      Caption:=Caption+' - Location : '+StkLocFilt;

  {$ENDIF}

end;

procedure TStkList.FormCreate(Sender: TObject);
Var
  n  :  Byte;

  StartPanel
     :  TSBSPanel;

  KeyStart,
  KeyEnd
     :  Str255;

begin
  StartPanel := nil;
  ListActive:=BOff;

  LastCoord:=BOff;

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;

  fFrmClosing:=BOff;
  fFrmAutoClose:=BOff;
  fDoingClose:=BOff;
  fResetBinLoc:=BOff;

  ExLocal.Create;

  InAutoRefresh:=BOff;

  ROLineCUPtr:=nil;

  StkLocFilt:='';

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  pcStockList.ActivePage:=TabSheet1;

  SetTabs2;

  {$IFDEF SOP}
    SRORec:=nil;
    STARec:=nil;
    ROFIRec:=nil;
    MLocList:=nil;
    AltCList:=nil;

  {$ENDIF}

  {$IFNDEF PF_On}
    UPBOMP.Visible:=BOff;
  {$ENDIF}

  InitSize.Y:=333;
  InitSize.X:=614;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Self.Height:=360;
  Self.Width:=622;}

  MDI_SetFormCoord(TForm(Self));

  {$IFDEF LTE}
    Fidb1Btn.Hint:='Toggles filtering the list by Stock Group or Product...|Filter the  list by Products or Stock Groups.';
  {$ENDIF}

  MULCtrlO[0]:=TStkMList.Create(Self);
  MULCtrlO[0].Name := 'StockList';

  MULCtrlO[0].CreateSortView(0);

  // CJS: 13/12/2010 Added to use new Window Positioning system
  FSettings := GetWindowSettings(Self.Name);
  LoadWindowSettings;

  Try

    With MULCtrlO[0] do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(SLCPanel,SLCLab);
          AddVisiRec(SLDPanel,SLDLab);
          AddVisiRec(SLIPanel,SLILab);
          AddVisiRec(SLFPanel,SLFLab);
          AddVisiRec(SLOPanel,SLOLab);

          // SSK 21/05/2018 2018-R1.1 ABSEXCH-20306: Added metadata info for Stock List tab
          ColAppear^[2].ExportMetadata := emtQuantity;           // In Stock
          ColAppear^[3].ExportMetadata := emtQuantity;           // Free Stock
          ColAppear^[4].ExportMetadata := emtQuantity;           // On Order

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=SLHedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=4;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;

      MLStkLocFilt:=@StkLocFilt;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        {HBkColor:=ClHighLight;
        HTextColor:=ClHighLightText;}


        If (n In [2..4]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=Syss.NoQtyDec;
        end;
      end;

      // CJS: 13/12/2010 - Amended for new Window Settings system
      // Find_Page1Coord(0);
      LoadListSettings(0);

      ListCreate;

      Filter[1,1]:=StkGrpCode;   {* Exclude Grp types *}
      Filter[2,1]:=StkDListCode;   {* Exclude Delisted items *}

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsUnderline];

      Set_Buttons(SLListBtnPanel);

      KeyStart:='';
      KeyEnd:='';

      { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
      RefreshList(True, False);
      // StartList(StockF,StkCodeK,KeyStart,KeyEnd,'',0,BOff);

      ListOfSet:=10;



    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;

  StkActive:=BOff;

  Sorted:=0;

  FormSetOfSet;

  FormReSize(Self);

  BuildMenus;

  ChangePage(SListFormPage);

  PrimeButtons(SListFormPage,BOff);

  SetDeleteStat(Stock);

  {$IFDEF CU}
    try
      EntCustom4.Execute;
    except
      ShowMessage('Customisation Control Failed to initialise');
    end;

  {$ENDIF}

  SetHelpContextIDs; // NF: 20/06/06 Fix for incorrect Context IDs

end;


{$IFDEF PF_On}
  procedure TStkList.Warn_UPBOM;


  Begin
    If (Syss.NeedBMUp) or (Current_Page=1) then
    Begin
      UPBOMP.Visible:=BOn;
      UPBOMp.BringToFront;

      If (Current_Page=1) and (Assigned(MULCtrlO[1])) then
      Begin
        If (MULCtrlO[1].Back2Back) then
          UPBOMP.Caption:='Back to Back '
        else
          UPBOMP.Caption:='Min Stock Lev';
      end
      else
        UPBOMP.Caption:='Update Build Costings!'
    end
    else
    Begin
      UPBOMP.Visible:=BOff;
      UPBOMP.Caption:='';
    end;

  end;

{$ENDIF}

procedure TStkList.FormActivate(Sender: TObject);
begin

  If (Assigned(FormBitMap)) then
    FormResize(nil);

  If (MULCtrlO[Current_Page]<>nil) then
    MULCtrlO[Current_Page].SetListFocus;

  {$IFDEF PF_On}
    Warn_UPBOM;

  {$ENDIF}

  ListActive:=BOn;

   OpoLineHandle:=Self.Handle;

end;


{* These routines free up resources, by freeing up the handle for pcStockList
   as soon as the focus is lost. To give the illusion of continuity, a bit map is created
   of the image of the form, and this is displayed instead of the form.
   Whilst this is a good idea, no updating can go on of the form whilst it does not have the
   focus.

   Routines used: FormDeactivate, Formpaint, FormActivate, WMSendFocus FormResize Formmouse down
                  Apparently, if the focus is returned from a form which is not an MDI
                  child, OnActivate does not get called, so we rely on the user clicking
                  crude, and gives the impresion that the firat click is ignored.

*}

procedure TStkList.FormDeactivate(Sender: TObject);
begin
  If (Not KeepLive) and (Syss.ConsvMem) then
  Begin
    FormBitMap:=GetFormImage;
    LockWindowUpDate(Handle);
    THintWindow(pcStockList).ReleaseHandle;
    LockWindowUpDate(0);
  end;
end;

procedure TStkList.FormPaint(Sender: TObject);
begin
  If (Assigned(FormBitMap)) then
    Canvas.Draw(0,0,FormBitMap);
end;

procedure TStkList.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Assigned(FormBitMap)) then
    FormResize(nil);
end;

procedure TStkList.FormResize(Sender: TObject);

Var
  n           :  Byte;
  ParentForm  :  TCustomForm;
  BtnPanelCoords : TPoint;
  ActiveScrollBox : TScrollBox;
  ActiveListBtnPanel: TSBSPanel;
  ReloadData : Boolean;
begin
  If (Assigned(FormBitMap)) then
  Begin
    FormBitMap.Free;
    FormBitMap:=nil;

    LockWindowUpdate(Handle);
    pcStockList.HandleNeeded;
    ParentForm:=GetParentForm(pcStockList);
    ParentForm.ActiveControl:=pcStockList;
    With pcStockList do
    Begin
      BringToFront;
      Visible:=BOff;
      Visible:=BOn;
    end;

    With SLBtnPanel do
    Begin
      BringToFront;
      Visible:=BOff;
      Visible:=BOn;
    end;

    LockWindowUpdate(0);

  end;

  If (GotCoord) and (Not fDoingClose) then
  Begin
    GotCoord:=BOff;

    LockWindowUpdate(Handle);

    MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    // Page Control
    pcStockList.Width := Self.ClientWidth - (2 * pcStockList.Left) + 1;
    pcStockList.Height := Self.ClientHeight - (2 * pcStockList.Top) + 1;

    // Buttons panel - need to calculate position on tab and convert to form level as buttons panel is on form
    BtnPanelCoords := Self.ScreenToClient(Tabsheet1.ClientToScreen(Point(Tabsheet1.Width - SLBtnPanel.Width - 3, 3)));
    SLBtnPanel.Left := BtnPanelCoords.X;
    SLBtnPanel.Top := BtnPanelCoords.Y;
    SLBtnPanel.Height := Tabsheet1.Height - 6;

    SLBSBox.Height := SLBtnPanel.Height - SLBSBox.Top - 1;

    // Update BoM Costs warning
    UPBOMP.Left := SLBtnPanel.Left;

    // Stock List - scroll up/down panel
    SLListBtnPanel.Left := Tabsheet1.ScreenToClient(Self.ClientToScreen(BtnPanelCoords)).X - SLListBtnPanel.Width - 3;

    // Stock List scroll box
    SLSBox.Width := SLListBtnPanel.Left - 3 - SLSBox.Left;
    SLSBox.Height := Tabsheet1.Height - SLSBox.Top - 3;

    // Re-Order List scroll box
    ROSBox.Width := SLSBox.Width;
    ROSBox.Height := SLSBox.Height;

    // Re-Order List - scroll up/down panel
    ROListBtnPanel.Top := SLListBtnPanel.Top;
    ROListBtnPanel.Left := SLListBtnPanel.Left;

    // Stock Take scroll box
    STSBox.Width := SLSBox.Width;
    STSBox.Height := SLSBox.Height;

    // Stock Take - scroll up/down panel
    STListBtnPanel.Top := SLListBtnPanel.Top;
    STListBtnPanel.Left := SLListBtnPanel.Left;

    // Vertically resize columns to take horizontal scroll bar into account and adjust the
    // vertical up/down list scroll bar
    For n := 0 To 5 Do
    Begin
      If Assigned(MULCtrlO[n]) Then
      Begin
        Case N Of
          0 : Begin
                ActiveScrollBox := SLSBox;
                ActiveListBtnPanel := SLListBtnPanel;
              End; // 0
          1 : Begin
                ActiveScrollBox := ROSBox;
                ActiveListBtnPanel := ROListBtnPanel;
              End; // 1
          2 : Begin
                ActiveScrollBox := STSBox;
                ActiveListBtnPanel := STListBtnPanel;
              End; // 2
        Else
          ActiveScrollBox := NIL;
          ActiveListBtnPanel := NIL;
        End; // Case N

        If Assigned(ActiveScrollBox) And Assigned(ActiveListBtnPanel) then
        Begin
          With MULCtrlO[n].VisiList do
          Begin
            VisiRec:=List[0];

            With (VisiRec^.PanelObj as TSBSPanel) Do
            Begin
              // Check for changes - if not changed then don't reload the data
              ReloadData := (Height <> (ActiveScrollBox.ClientHeight - Top));
              If ReloadData Then
                Height := ActiveScrollBox.ClientHeight - Top;
            End; // With (VisiRec^.PanelObj as TSBSPanel)
          End; // With MULCtrlO[n].VisiList

          // Adjust the height of the list scroll buttons to match the column height
          ActiveListBtnPanel.Height := TabSheet1.ScreenToClient(ActiveScrollBox.ClientToScreen(Point(0,ActiveScrollBox.ClientHeight))).Y - ActiveListBtnPanel.Top;

          MULCtrlO[n].ReFresh_Buttons;
          If ReloadData Then MULCtrlO[n].RefreshAllCols;
        End; // If Assigned(MULCtrlO[n]) And Assigned(ActiveScrollBox)
      End; // If Assigned(MULCtrlO[n])
    End; // For n

    LockWindowUpdate(0);

    MULCtrlO[Current_Page].LinkOtherDisp:=BOn;

    GotCoord:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;



Procedure TStkList.Send_ParentMsg(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;

  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TStkList.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;
    Action:=caFree;

    Send_ParentMsg(47); {Form closing..}

    For n:=0 to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
      If (MULCtrlO[n]<>nil) then
      Begin
        // MH 31/05/2016 2016-R2 ABSEXCH-17574: Crashing on shutdown of Exchequer if Stock List left open
        //                                      See Daybk2.pas for details of fault. 
        FreeAndNIL(MULCtrlO[n]);
        //MULCtrlO[n].Destroy;
        //MULCtrlO[n]:=nil;
      end;

  end;


end;


Function TStkList.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  For n:=Low(MULCtrlO) to High(MULCtrlO) do
  Begin
    If (Assigned(MULCtrlO[n])) then
      Result:=Not MULCtrlO[n].ListStillBusy;

    If (Not Result) then
    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

      If (mBRet=mrYes) then
      Begin
        MULCtrlO[n].IRQSearch:=BOn;

        ShowMessage('Please wait a few seconds, then try closing again.');
      end;

      Set_BackThreadMVisible(BOff);

      Break;
    end;
  end;
end;


procedure TStkList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

const
  //PR: 18/08/2015 ABSEXCH-15445  Constants to make code more readable
  DefaultSuppliers = 3;
  MasterBins = 5;
  ProcessDescription : Array[1..2] of string = ('default suppliers.', 'master bin locations.');

Var
  n       :  Integer;
  mbRet   :  Word;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      {$IFDEF SOP}
       {$IFDEF POST}
         If fResetBinLoc and (StkLocFilt<>'') then
         Begin
           //PR: 18/08/2015 ABSEXCH-15445 Depending upon which page we're on, should be restoring either SuppTemp (1) or Bin (2)
           if Current_Page=2 then
             AddStkLocOR2Thread(Self,'',MasterBins,2)
           else
             AddStkLocOR2Thread(Self,'',DefaultSuppliers,2);

           CanClose:=BOff;
           fResetBinLoc:=BOff; StkLocFilt:='';

           Set_BackThreadMVisible(BOn);

           mbRet:=MessageDlg('This screen cannot be closed until the Object Thread'+#13+#13+
                        'Controller has finished restoring the ' + ProcessDescription[Current_Page],mtInformation,[mbOK],0);


           Set_BackThreadMVisible(BOff);

           fFrmAutoClose:=BOn;
         end
         else
           fFrmAutoClose:=BOff;

       {$ENDIF}

     {$ENDIF}


      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
        CanClose:=GenCheck_InPrint;

      If (CanClose) then
        CanClose:=Not InAutoRefresh;

      If (CanClose) then
      Begin

        For n:=0 to Pred(ComponentCount) do
          If (Components[n] is TScrollBox) then
          With TScrollBox(Components[n]) do
          Begin
            VertScrollBar.Position:=0;
            HorzScrollBar.Position:=0;
          end;

        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;

//        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
//          Store_FormCoord(Not SetDefault);

        // CJS: 13/12/2010 Changed to use new Window Position System
        SaveWindowSettings;

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TStkList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin
  ExLocal.Destroy;

  For n:=Low(CustBtnList) to High(CustBtnList) do
    If (CustBtnList[n]<>nil) then
      CustBtnList[n].Free;

  If (ShowPrice<>nil) then
    ShowPrice.Free;

  If (ShowAge<>nil) then
    ShowAge.Free;

  If (Assigned(ROLineCUPtr)) then
  Begin
    {$IFDEF CU}
      TCustomEvent(ROLineCUPtr).Free;
    {$ENDIF}
  end;

  
end;


procedure TStkList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TStkList.Display_Account(Mode  :  Byte);

Var
  NomNHCtrl  :  TNHCtrlRec;

Begin

  If (StkRecForm=nil) then
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    Set_DDFormMode(NomNHCtrl);

    StkRecForm:=TStockRec.Create(Self);

  end;

  Try

   StkActive:=BOn;

   With StkRecForm do
   Begin
     SRecLocFilt:=StkLocFilt;

     WindowState:=wsNormal;

     SetTabs;

     If (HistFormPtr=nil) or (Mode In [1..10]) then
       Show;

     If (Not ExLocal.InAddEdit) then
       ShowLink;


     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
     Begin
       ChangePage(StockU.SMainPNo);

       If (Mode=3) then
       Begin
         If (Ok2DelStk(0,Stock)) then
           DeleteAccount;
       end
       else
         EditAccount((Mode=2));
     end;

     Case Mode of

       5  :  ChangePage(StockU.SNotesPNo);
       6..7
          :  Begin
               FromHist:=(Mode=7);

               If (Current_Page<>StockU.SLedgerPNo) then
                 ChangePage(StockU.SLedgerPNo);

               FromHist:=BOff;

               If (Mode>6) and (HistFormPtr=nil) then
                 Display_History(9,BOn);

             end;
       8  :  Begin
               {$IFDEF PF_On}
                 If (Current_Page<>StockU.SBuildPNo) then
                   ChangePage(StockU.SBuildPNo);

                 BOMBuildPage;

               {$ENDIF}

             end;

     {$IFDEF PF_On}
       9  :  With Stock do
             Begin
               If (IS_FIFO(StkValType)) then
                 ChangePage(StockU.SValuePNo)
               else
                 If IS_SerNo(StkValType) then
                   ChangePage(StockU.SSerialPNo);
             end;


      10  :  ChangePage(StockU.SQtyBPNo);
     {$ENDIF}

     end;



   end; {With..}


  except

   StkActive:=BOff;

   StkRecForm.Free;

  end;


end;



Procedure TStkList.SetDeleteStat(StockR  :  StockRec);
Var
  CanDelete  :  Boolean;

Begin

  CanDelete:=Ok2DelStk(0,StockR);

  Case Current_Page of

    0..2  :  Deldb1Btn.Enabled:=CanDelete;

  end; {Case..}

end;



{$IFDEF SOP}
{ ========= Proc to Set RO-Details from Alt  List ======== }

Procedure TStkList.sdb_SetRODet(TMisc    :  sdbStkType);


Var
  LOk,
  LLocked  :  Boolean;

  KeyS    :  Str255;


Begin

  LLocked:=BOff; LOk:=BOff;

  With MULCtrlO[Current_Page], ExLocal do
  Begin

    If (ValidLine) then
      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,LLocked);


    If (LOk) and (LLocked) then
    With LStock do
    With TMisc do
    Begin

      LGetRecAddr(ScanFileNum);

      LOk:=(Not EmptyKey(sdSuppCode,CustKeyLen));

      If (LOk) then

        LOk:=LGetMainRecPos(CustF,sdSuppCode);

      If (LOk) and (Not IsACust(LCust.CustSupp)) then
        SuppTemp:=sdSuppCode;

      If (sdOverRO) then
      Begin
        If (sdROCurrency<>0) then {* Coming from Stk Take Adj *}
          ROCurrency:=sdROCurrency
        else
          ROCurrency:=1;

        ROCPrice:=sdROPrice;
      end;


      If (sdOverMinEcc) then
      Begin
        ROQty:=sdMinEccQty;
      end;

      Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,Keypath);


      Report_BError(ScanFileNum,Status);


      UnLockMLock(ScanFileNum,LastRecAddr[ScanFilenum]);

      AddNewRow(MUListBoxes[0].Row,BOn);
    end; {With..}
  end; {With..}
end; {Proc..}


{$ENDIF}

Procedure TStkList.WMDayBkGetRec(Var Message  :  TMessage);

var
{$IFDEF SOP}
    OpoLineCtrl  :  TOpoLineCtrl;

{$ENDIF}
  StockCode: string[16];

Begin

  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO[Current_Page].GetSelRec(BOff);

              Case Current_Page of
                0  :  Display_Account(0);

                {$IFDEF SOP}
                   1  :  Display_SRORec;
                   2  :  Display_STARec;

                {$ENDIF}
              end; {Case..}
            end;


      1  :  PostMessage(Self.Handle,WM_FormCloseMsg,1000+WParam,0); {* This was placed here to stop the mouse up event from being corrupted *}


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

            {* This siwtch used here to stop the screen from freeing up memory
            while the please wait message is shown, otherwise the list is not
            updated *}

     20,    {* Do not disable screen whilst please wait message is on *}
     21  :  KeepLive:=(WParam=20);

     25  :  NeedCUpdate:=BOn;

     38  :  {$IFDEF PF_On}

             Scan_Bill;

            {$ENDIF}


    100..102
         :  With MULCtrlO[WParam-100] do
            Begin
                If (LParam=1) and (WParam=101) then {* v5.61 Only update row as multiple filters caused lareg delays *}
                begin
                //GS 28/02/2012 ABSEXCH-10903 :
                //reset the cache before updating the selected row
                //PR: 29/02/2012 Added ifdef sop so it compiled for stk. 
                {$IFDEF SOP}
                ResetCache;
                InvLst3U.UseCache := True;
                {$ENDIF}
                  Set_Row(MUListBoxes[0].Row);
                end
                else
                  AddNewRow(MUListBoxes[0].Row,(LParam=1));
              
            end;

    {$IFDEF FRM}
       170  :  Begin
                 If (Assigned(MULCtrlO[Current_Page])) then
                 With MULCtrlO[Current_Page] do
                 Begin
                   Exlocal.AssignFromGlobal(StockF);

                   PrintStockRecord(ExLocal,BOn);
                 end;
               end;
    {$ENDIF}

    175  :  With pcStockList do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    177  :  Begin
              PrimeButtons(Current_Page,BOn);

              Check_TabAfterPW(pcStockList,Self,WM_CustGetRec);
            end;

    182  :  With MULCtrlO[Current_Page] do {From WOR Wizard, refresh list}
            Begin
              {$IFDEF SOP}
                If ValidLine then
                  ResetOrderQty(ScanFileNum,Keypath,StkLocFilt);

                If (MUListBox1.Row<>0) then
                  PageUpDn(0,BOn)
                else
                  InitPage;
              {$ENDIF}    
            end;


    200
         :  Begin
              KeepLive:=BOff;

              StkActive:=BOff;
              StkRecForm:=nil;
            end;

    210  :  Begin
              KeepLive:=BOff;
              ShowPrice:=nil;
            end;
    211  :  Begin
              KeepLive:=BOff;
              ShowAge:=nil;
            end;

    {$IFDEF SOP}
      213  :  Begin
                KeepLive:=BOff;
                SRORec:=nil;
              end;

      214,215
           :  If (Assigned(MULCtrlO[1])) and (Assigned(ROFiRec)) then
              With MULCtrlO[1],ROFiRec do
              Begin
                If (WParam=215) then
                Begin
                  StkGrpFilt^:=KCode;

                  BuildStkGrpCache(KCode,0); {*EL: Ex v6.01 Memory cache holder for filter by Product Group *}

                  KeyRef:=SCode;
                  GenWORMode:=BOMWOR;
                  KeyLen:=Length(KeyRef);

                  SetProcessCaption;

                  if SortViewEnabled then
                  begin
                    if (FSortView is TStockReorderSortView) then
                      (FSortView as TStockReorderSortView).GenWORMode := GenWORMode;
                    RefreshList(True, False);
                  end
                  else
                  begin
                    InvLst3U.ResetCache;
                    InvLst3U.UseCache := True;
                    StartList(ScanFileNum,KeyPath,KeyRef,'','',KeyLen,BOff);
                  end;

                  {* Send message moved to after Startlist, as caused GPF's *}
                end;

                SendMessage(ROFiRec.Handle,WM_Close,0,0);
              end;

      216  :  Begin
                KeepLive:=BOff;
                ROFiRec:=nil;
              end;

      217  :  Begin
                KeepLive:=BOff;
                STARec:=nil;
              end;



    {$ENDIF}

    300..302
         :  If (Assigned(MULCtrlO[WParam-300])) then
            With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;

              If (fFrmAutoClose) then
                PostMessage(Self.Handle,WM_Close,0,0);
            end;

     400,
     401  : Begin
              {$IFDEF Ltr}
                LetterActive:=Boff;
                LetterForm:=nil;
              {$ENDIF}
            end;

    {$IFDEF SOP}
       1100 :  If (Current_Page=1) then
               Begin
                 New(OpoLineCtrl,Create(Pointer(LParam)));

                  try
                    With OpoLineCtrl^ do
                    Begin
                      If (MapToStkWarn) then
                      Begin
                        If GetSelMLocRec(ExLocal.LMLocCtrl^) then
                          PostMessage(Self.Handle,WM_FormCloseMsg,49,0);
                      end;
                    end;
                  finally
                    Dispose(OpoLineCtrl,Destroy);

                  end; {try..}

               end;

       1129  :  Begin {* Respond that we do not require the opo section *}

                  If (Current_Page=1) then
                    SendMessage(THandle(LParam),WM_CustGetRec,1129,0);

                end;

    {$ENDIF}

   {$IFDEF GF}

    3003
          : If (Assigned(FindCust)) then
              With MULCtrlO[LParam],FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                Case ActiveFindPage of
                  tabFindSupplier  :  Find_SuppOnList(RecMainKey);
                  tabFindStock     :  Case SearchMode of
                          30..33  :  If Not FindxCode(SearchKey,SearchMode) then
                                       Find_OnList(SearchMode,SearchKey);

                          else       Find_OnList(SearchMode,SearchKey);
                        end; {Case..}
                end; {Case..}


                InFindLoop:=BOff;
              end;

   {$ENDIF}

   3103  :  With MULCtrlO[0] do
            Begin
              InAutoRefresh:=BOn;
              try

                if SortViewEnabled then
                begin
                  StockCode := Stock.StockCode;
                  StartList(SortTempF, STFieldK, FullNomKey(SortView.ListID), '', '', 0, BOff);
                  Find_OnActualList(StockF, StockCode, StkCodeK);
                  MUListBox1Click(MUListBoxes[0]);
                end
                else if (LineOk(SetCheckKey)) then
                Begin
                  StartList(StockF,StkCodeK,Stock.StockCode,'','',0,BOff);

                  MUListBox1Click(MUListBoxes[0]);
                end;

                KeyRef:='';

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;
              finally

                InAutoRefresh:=BOff;
              end;
            end;

    end; {Case..}

    If (WParam in [1,2]) or (WParam=300) then
      SetDeleteStat(Stock);

  end;
  Inherited;
end;


Procedure TStkList.ExecuteListCU;

Var
  {$IFDEF CU}

    ROLineCU  :  TCustomEvent;

  {$ELSE}

    ROLineCU  :  Byte;

  {$ENDIF}

Begin
  {$IFDEF CU}
    ROLineCU := nil;
    Try
      {$B-}
      If (Current_Page=1) and (Assigned(MULCtrlO[Current_Page])) and (MULCtrlO[Current_Page].ValidLine) then
      {$B+}
      Begin
        ExLocal.AssignFromGlobal(StockF);

        If (Not Assigned(ROLineCUPtr)) then
        Begin
          ROLineCU:=TCustomEvent.Create(EnterpriseBase+3000,50);

          If (ROLineCU.GotEvent) then
            ROLineCU.BuildEvent(ExLocal);

          ROLineCUPtr:=ROLineCU;
        end
        else
          ROLineCU:=ROLineCUPtr;

        If (ROLineCU.GotEvent) then
        With ROLineCU do
        Begin
          TStock(EntSysObj.Stock).Assign(EnterpriseBase+3000,50,ExLocal.LStock);
          Execute;
        end;
      end; {If on re-order page}

    Except
        ROLineCU.Free;

        ROLineCUPtr:=nil;

    end; {Try..}

  {$ENDIF}
end;

Procedure TStkList.WMFormCloseMsg(Var Message  :  TMessage);
{$IFDEF Ltr}
Var
  OldCust : ^CustRec;
{$ENDIF}
Begin

  With Message do
  Begin

    Case WParam of

      8  :  {$IFDEF PF_On}
               Warn_UPBOM;
            {$ENDIF}

      {$IFDEF SOP}
        43 :  MLocList:=nil;
        48 :  AltCList:=nil;

        49 :  If (Current_Page=1) then
              Begin
                ExLocal.AssignFromGlobal(MLocF);

                sdb_setRODet(MLocCtrl^.sdbStkRec);
              end;


      {$ENDIF}

      1001 :  Begin
                {* This handling was placed here so to give the list a chance to see the mouse up event *}

                If (StkRecForm<>nil) and (StkActive) then
                With StkRecForm do
                Begin
                  If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Stock.StockCode<>ExLocal.LStock.StockCode) then
                  Begin
                    KeepLive:=BOn;
                    SRecLocFilt:=StkLocFilt;
                    ShowLink;
                  end;
                end;

                If (ShowPrice<>nil) then
                  try
                    KeepLive:=BOn;
                    ShowPrice.OutPrices(StkLocFilt);
                  except
                    ShowPrice.Free;
                    ShowPrice:=nil;
                  end;

                If (ShowAge<>nil) then
                  try
                    KeepLive:=BOn;

                    ShowAge.fLocFilt:=StkLocFilt;

                    ShowAge.ShowAged;
                  except
                    ShowAge.Free;
                    ShowAge:=nil;
                  end;

                {$IFDEF SOP}
                  If (Assigned(MLocList)) then
                    Link2MLoc(BOn);

                  If (Assigned(AltCList)) then
                    Link2AltC(BOn);
                {$ENDIF}

                {$IFDEF Ltr}
                  { Check for link to letters }
                  If Assigned(LetterForm) And LetterActive Then
                    With LetterForm Do Begin
                      If (WindowState <> wsMinimized) and (Stock.StockCode <> ExLocal.LStock.StockCode) Then Begin
                        New (OldCust);
                        OldCust^ := Cust;

                        If CheckRecExsists(FullCustCode(Stock.Supplier), CustF, CustCodeK) Then
                          LetterForm.LoadLettersFor (FullNomKey(Stock.StockFolio),  { Index Key }
                                                     Stock.StockCode,               { Caption }
                                                     CodeToFName (Stock.StockCode), { FName }
                                                     LetterStkCode,
                                                     @Cust, @Stock, Nil, Nil, Nil)
                        Else
                          LetterForm.LoadLettersFor (FullNomKey(Stock.StockFolio),  { Index Key }
                                                     Stock.StockCode,               { Caption }
                                                     CodeToFName (Stock.StockCode), { FName }
                                                     LetterStkCode,
                                                     Nil, @Stock, Nil, Nil, Nil);
                        Cust := OldCust^;
                        Dispose(OldCust);
                      End; { If }
                    End; { With }
                {$ENDIF}

                SendToObjectStkEnq(Stock.StockCode,StkLocFilt,Stock.SuppTemp,-1,-1,0);

                ExecuteListCU;
              end;


    end; {Case..}

  end;

  Inherited;
end;


Procedure TStkList.WMSetFocus(Var Message  :  TMessage);
Begin

  FormActivate(nil);

end;


Procedure TStkList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;


  end;

  Message.Result:=0;

  Inherited;

end;

procedure TStkList.HidePanels(PageNo  :  Byte);


Begin
  With MULCtrlO[PageNo],VisiList do
  Begin

    {SetHidePanel(3,NomDayBk,BOff);
    SetHidePanel(5,NomDayBk,BOff);

    SetHidePanel(4,Not NomDayBk,BOn);}


  end;
end;


procedure TStkList.Page1Create(Sender   : TObject;
                               NewPage  : Byte);

Var
  n : Byte;
  StartPanel : TSBSPanel;
  TKeyLen, TKeypath : Integer;
  KeyStart, KeyEnd : Str255;
  scrollbarSize : TSize;
begin
   StartPanel := nil;
   TKeyLen:=0;
   TKeyPath:=StkCodeK;

   KeyStart:='';
   KeyEnd:='';

   MULCtrlO[NewPage]:=TStkMList.Create(Self);
   if (NewPage = 1) then
     MULCtrlO[NewPage].Name := 'StockReOrderList'
   else if (NewPage = 2) then
     MULCtrlO[NewPage].Name := 'StockTakeList';

   MULCtrlO[NewPage].CreateSortView(NewPage);

   Try

     With MULCtrlO[NewPage] do
     Begin

       Try

         With VisiList do
         Begin
           Case NewPage of
             1  :  Begin
                     AddVisiRec(ROSPanel,ROSLab);
                     AddVisiRec(ROCPanel,ROCLab);
                     AddVisiRec(ROFPanel,ROFLab);
                     AddVisiRec(ROMPanel,ROMLab);
                     AddVisiRec(ROOPanel,ROOLab);
                     AddVisiRec(RONPanel,RONLab);
                     AddVisiRec(RORPanel,RORLab);
                     AddVisiRec(ROTPanel,ROTLab);

                     // SSK 21/05/2018 2018-R1.1 ABSEXCH-20306: Added metadata info for Reorder tab
                     ColAppear^[2].ExportMetadata := emtQuantity;           // Free
                     ColAppear^[3].ExportMetadata := emtQuantity;           // Min Stk
                     ColAppear^[4].ExportMetadata := emtQuantity;           // On Ord
                     ColAppear^[5].ExportMetadata := emtQuantity;           // Need
                     ColAppear^[6].ExportMetadata := emtQuantity;           // Order
                     ColAppear^[7].ExportMetadata := emtCurrencyAmount;     // Cost
                   end;

             2  :  Begin
                     AddVisiRec(STBPanel,STBLab);
                     AddVisiRec(STCPanel,STCLab);
                     AddVisiRec(STDPanel,STDLab);
                     AddVisiRec(STIPanel,STILab);
                     AddVisiRec(STAPanel,STALab);
                     AddVisiRec(STFPanel,STFLab);
                   end;

           end; {Case..}


           HidePanels(NewPage);

           VisiRec:=List[0];

           StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

         end;
       except
         VisiList.Free;

       end;

       // CJS: 13/12/2010 - Amended for new Window Settings system
       // Find_Page1Coord(NewPage);
       LoadListSettings(NewPage);

       Match_VisiList(MULCtrlO[0].VisiList,VisiList);

       TabOrder := -1;
       TabStop:=BOff;
       Visible:=BOff;
       BevelOuter := bvNone;
       ParentColor := False;
       Color:=StartPanel.Color;

       DisplayMode:=NewPage;

       Case DisplayMode of
         1  :  MUTotCols:=7;
         2  :  MUTotCols:=5;
       end;

       Font:=StartPanel.Font;
       LinkOtherDisp:=BOn;

       WM_ListGetRec:=WM_CustGetRec;


       Parent:=StartPanel.Parent;

       MessHandle:=Self.Handle;

       For n:=0 to MUTotCols do
       With ColAppear^[n] do
       Begin
         AltDefault:=BOn;

         {HBkColor:=ClHighLight;
         HTextColor:=ClHighLightText;}
         If ((DisplayMode=1) and (n In [2..7])) or ((DisplayMode=2) and (n In [3..5])) then
         Begin
           DispFormat:=SGFloat;
           If (n<7) then
             NoDecPlaces:=Syss.NoQtyDec
           else
             NoDecPlaces:=Syss.NoCosDec;
         end;
       end;

       Filter[1,1]:='!';


       ListCreate;

       HighLiteStyle[1]:=[fsUnderline];
       HighLiteStyle[2]:=[fsBold];
       HighLiteStyle[3]:=[fsBold,fsUnderline];
       HighLiteStyle[4]:=[fsItalic];
       HighLiteStyle[6]:=[fsBold,fsItalic];

       MLStkLocFilt:=@StkLocFilt;


       NoUpCaseCheck:=BOn;

       Case NewPage of

         1  :  Begin
                 VisiList.LabHedPanel:=ROHedPanel;

                 //TW ABSEXCH-11575 26/10/2011: Added scrollbar size fix on PageCreate
                 Height := SLListBtnPanel.ClientHeight - Top;
                 ROListBtnPanel.Height := TabSheet1.ScreenToClient(ROSBox.ClientToScreen(Point(0,ROSBox.ClientHeight))).Y - ROListBtnPanel.Top;
                 Set_Buttons(ROListBtnPanel);

                 ROSBox.HorzScrollBar.Position:=0;
                 ROSBox.VertScrollBar.Position:=0;

                 //AP 07/02/2018 ABSEXCH-19678-Stock not linked to a preferred supplier are not displyed in Stock List > Re-Order tab.
                 TKeypath:=StkCodeK;

                 TKeyLen:=Length(KeyStart);

                 UseSet4End:=BOff;

                 NoUpCaseCheck:=BOff;

               end;
         2  :  Begin
                 VisiList.LabHedPanel:=STHedPanel;

                 //TW ABSEXCH-11575 26/10/2011: Added scrollbar size dirty fix on PageCreate as there seems
                 //                             to be no way to tell how big the scrollbar is.
                 Height := SLListBtnPanel.ClientHeight - Top;

                 if(RosBox.HorzScrollBar.IsScrollBarVisible) then
                    STListBtnPanel.Height := TabSheet1.ScreenToClient(STSBox.ClientToScreen(Point(0,STSBox.ClientHeight))).Y - STListBtnPanel.Top - 16
                 else
                   STListBtnPanel.Height := TabSheet1.ScreenToClient(STSBox.ClientToScreen(Point(0,STSBox.ClientHeight))).Y - STListBtnPanel.Top;
                         
                 Set_Buttons(STListBtnPanel);

                 STSBox.HorzScrollBar.Position:=0;
                 STSBox.VertScrollBar.Position:=0;

                 TKeypath:=StkBinK;
                 TKeyLen:=Length(KeyStart);

                 UseSet4End:=BOff;

                 NoUpCaseCheck:=BOff;

               end;

       end; {Case..}

       With VisiList do
       Begin
         LabHedPanel.Color:=IdPanel(0,BOn).Color;

         SetHedPanel(ListOfSet);
       end;

       //PR: 25/02/2013 ABSEXCH-13936/ABSEXCH-14060 Need to move setting SKeyPath from TKeypath to
       // above RefreshList call, otherwise call has the wrong index.
       SKeypath:=TKeypath;

       { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
       RefreshList(True, False);
       // StartList(StockF,TKeyPath,KeyStart,KeyEnd,'',TKeyLen,BOff);


       If (MULAddr[NewPage]<>0) then {* Attempt to re-establish position *}
       Begin
         Status:=Presrv_BTPos(ScanFileNum,Keypath,F[ScanFileNum],MULAddr[NewPage],BOn,BOn);

         If (StatusOk) then
           AddNewRow(1,BOn)
       end;
     end {With}


   Except

     MULCtrlO[NewPage].Free;
     MULCtrlO[NewPage]:=Nil;
   end;

   MDI_UpdateParentStat;


end;


procedure TStkList.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin


  With MULCtrlO[Current_Page] do
  Begin
    KeyStart:=KeyRef;

    IgnoreMsg:=IgMsg;

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    if UseDefaultSortView then
      UseDefaultSortView := SortView.LoadDefaultSortView;

    if SortViewEnabled or UseDefaultSortView then
    begin
      SortView.HostListSearchKey := '';
      case Current_Page of
        0: SortView.HostListIndexNo := StkCodeK;
        1: SortView.HostListIndexNo := StkMinK;
        2: SortView.HostListIndexNo := StkBinK;
      end;
      SortView.Apply;
      SortView.Enabled := True;
      StartList(SortTempF, STFieldK, FullNomKey(SortView.ListID), '', '', 0, BOff);
      if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
        pcStockList.Pages[Current_Page].ImageIndex := 1
      else
        pcStockList.Pages[Current_Page].ImageIndex := 2;
    end
    else
    begin
      {$IFDEF SOP}
      InvLst3U.ResetCache;
      InvLst3U.UseCache := True;
      {$ENDIF}
      StartList(StockF,SKeypath,KeyStart,'','',Length(KeyRef),(Not ShowLines));
    end;

    IgnoreMsg:=BOff;

    {$IFDEF CU}
      If (Current_Page=1) then
        ExecuteListCU;
    {$ENDIF}
  end;

end;


procedure TStkList.pcStockListChanging(Sender: TObject;
                                    var AllowChange: Boolean);

Var
  OldIndex  :  Integer;

begin

  OldIndex:=pcLivePage(pcStockList);

  If (OldIndex<>0) and (MULCtrlO[OldIndex]<>nil) and (Syss.ConsvMem) then
  With MULCtrlO[OldIndex] do
  Begin

    {* Preserve Last position *}

    {* This was disabled as when on formActivate is called, for some reason the
       list being destroyed here is not being recognised as nil, and causes a GPF
       when trying to SetListFocus, would not have caused a problem in this DB1BT,
       however (as there is only one page) but disabled to keep inline with DayBk2 *}

    {MULAddr[OldIndex]:=PageKeys^[MUListBoxes[0].Row];

    Destroy;

    MULCtrlO[OldIndex]:=nil;}
  end;

  Release_PageHandle(Sender);

end;


procedure TStkList.pcStockListChange(Sender: TObject);
Var
  NewIndex  :  Integer;

  RefreshL  :  Boolean;
begin

  Begin
    NewIndex:=pcLivePage(pcStockList);

    RefreshL:=Assigned(MULCtrlO[NewIndex]);

    Case NewIndex of

      0..5  :  Begin
                 If (MULCtrlO[NewIndex]=nil) then
                   Page1Create(Sender,NewIndex);

                 {$IFDEF SOP}

                   If (LastSLFilt[NewIndex]<>StkLocFilt) and (ListActive) then
                   Begin
                     If (NewIndex<>0) then
                       RefreshL:=(SetLocDefs or RefreshL);

                     If (RefreshL) then
                       MULCtrlO[NewIndex].PageUpDn(0,BOn);
                     LastSLFilt[NewIndex]:=StkLocFilt;
                   end;
                 {$ENDIF}

                 Case NewIndex of
                   0   :  pcStockList.HelpContext:=178;
                   1   :  pcStockList.HelpContext:=516;
                   2   :  pcStockList.HelpContext:=517;
                 end; {Case..}
               end;

    end; {Case..}

    If (MULCtrlO[NewIndex]<>nil) and (ListActive) then
      MULCtrlO[NewIndex].SetListFocus;

    PrimeButtons(NewIndex,BOff);

    if (MULCtrlO[NewIndex].SortViewEnabled) then
    begin
      Sortdb1Btn.Enabled := False;
      FIDb1Btn.Enabled := False;
      FList1.Enabled := False;
      FList1.Hint := 'Filtering by location is not available while a sort view is active.';
    end
    else
    begin
      Sortdb1Btn.Enabled := True;
      FIDb1Btn.Enabled := True;
      FList1.Enabled := True;
      FList1.Hint := 'Choosing this option filters the current list by location, specifying a blank location gives a consolidated view.';
    end;

    Deldb1Btn.Enabled:=BOff; {* Disable delete by default, as new stock record not know at this point, and
                                moving over it will refresh this button anyway *}

    {$IFDEF PF_On}

      Warn_UPBOM;

    {$ENDIF}

    // SSK 21/05/2018 2018-R1.1 ABSEXCH-20306: Added support for exporting lists
    WindowExport.ReevaluateExportStatus;

  end;
end;

Procedure TStkList.ChangePage(NewPage  :  Integer);

Begin

  If (Current_Page<>NewPage) then
  With pcStockList do
  Begin
    ActivePage:=Pages[NewPage];

    pcStockListChange(ActivePage);
  end; {With..}

  ROSBox.Enabled:=BOn;
end; {Proc..}

procedure TStkList.Clsdb1BtnClick(Sender: TObject);
begin
  If (Not MULCtrlO[Current_Page].InListFind) then
    Close;
end;

procedure TStkList.SLCPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    Case Current_Page of
      0  :  BarPos:=SLSBox.HorzScrollBar.Position;
      1  :  BarPos:=ROSBox.HorzScrollBar.Position;
      2  :  BarPos:=STSBox.HorzScrollBar.Position;
    end;

      If (PanRsized) then
        MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;


procedure TStkList.SLCLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO[Current_Page]<>nil) then
        MULCtrlO[Current_Page].VisiList.PrimeMove(Sender);

      NeedCUpdate:=BOn;

    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;

procedure TStkList.SLCLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO[Current_Page]<>nil) then
      MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
  end;

end;



procedure TStkList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);

  end;


end;


procedure TStkList.PropFlgClick(Sender: TObject);
begin
  // CJS: 13/12/2010 - Amended for new Window Settings system
  // SetFormProperties;
  EditWindowSettings;
end;

procedure TStkList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TStkList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;


  With CustBtnList[Current_Page] do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

  if not MulCtrlO[Current_Page].SortView.Enabled then
  begin
    RefreshView1.Visible := False;
    CloseView1.Visible := False;
    N4.Visible := False;
  end
  else
  begin
    RefreshView1.Visible := True;
    CloseView1.Visible := True;
    N4.Visible := True;
  end;

  {PopUpMenu2PopUp(Sender);}

end;



procedure TStkList.Sortdb1BtnClick(Sender: TObject);
begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin
    Inc(Sorted);

    If (Sorted>2) then
      Sorted:=0;

    Case Current_Page of
      0  :  Case Sorted Of

              0    :  SKeyPath:=StkCodeK;
              1    :  SKeyPath:=StkDescK;
              2    :  SKeypath:=StkCatK;

            end; {Case..}

      2  :  Case Sorted Of

              0    :  SKeypath:=StkBinK;
              1    :  SKeyPath:=StkCodeK;
              2    :  SKeyPath:=StkDescK;
            end; {Case..}
    end; {Case..}

    RefreshList(BOn,BOff);
  end;
end;

procedure TStkList.Editdb1BtnClick(Sender: TObject);

Var
  EditMode,
  DelMode,
  NoteMode,
  HistMode,
  BOMMode,
  ValMode,
  QtyMode,
  LedgMode   :  Boolean;

begin
  {$B-}
  If (Not MULCtrlO[Current_Page].InListFind) and ({$IFDEF LTE} (Sender=Adddb1Btn)  or {$ENDIF} (MULCtrlO[Current_Page].ValidLine) ) then
  Begin
  {$B+}
    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);

    EditMode:=((Sender=Editdb1Btn) or (Sender=Edit1));

    DelMode:=((Sender=Deldb1Btn) or (Sender=Delete1));

    NoteMode:=((Sender=Notedb1Btn) or (Sender=Notes1));

    LedgMode:=((Sender=Leddb1Btn) or (Sender=Ledger1));

    HistMode:=((Sender=Histdb1Btn) or (Sender=History1));

    ValMode:=((Sender=Valdb1Btn) or (Sender=Value1));

    QtyMode:=((Sender=Qtydb1Btn) or (Sender=QtyBreaks1));

    If (Sender is TMenuItem) then
      BOMMode:=((Sender=Build2) or (TMenuItem(Sender).Tag=7))
    else
      BOMMode:=BOff;

    Display_Account(1+(1*Ord(EditMode))
                     +(2*Ord(DelMode))
                     +(4*Ord(NoteMode))
                     +(5*Ord(LedgMode))
                     +(6*Ord(HistMode))
                     +(7*Ord(BOMMode))
                     +(8*Ord(ValMode))
                     +(9*Ord(QtyMode)));

  end;
end;



procedure TStkList.Pricdb1BtnClick(Sender: TObject);
begin
  With MULCtrlO[Current_Page] do
  If (Not InListFind) then
  Begin
    GetSelRec(BOff);

    If (ShowPrice=nil) then
      ShowPrice:=TPrices.Create(Self);

    try
      ShowPrice.OutPrices(StkLocFilt);

    except
      ShowPrice.Free;
      ShowPrice:=nil;
    end;
  end;

end;



procedure TStkList.Agedb1BtnClick(Sender: TObject);
Var
  WasNew  :  Boolean;

begin
  WasNew:=BOff;

  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin
    If (ShowAge=nil) then
    Begin
      ShowAge:=TStkWarn.Create(Self);
      WasNew:=BOn;

    end;

    try
      ShowAge.fLocFilt:=StkLocFilt;

      If (WasNew) then
        ShowAge.InitScanMode;

      ShowAge.ShowAged;

    except
      ShowAge.Free;
      ShowAge:=nil;
    end;
  end;

end;


{ ==== Follow Chain and update Cost Prices ==== }

{* these routines have been replaced by a thread based update.. *}

Procedure TStkList.Update_Kits(StockR  :  StockRec);

Const

  Fnum     =  PWrdF;

  Keypath  =  HelpNdxK;


  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;



Var
  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  NewCost  :  Real;

  NewTime,
  RecAddr  :  LongInt;

  Locked   :  Boolean;



Begin

  With StockR do
  Begin

    KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyChk:=KeyS;

  end;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With Password.BillMatRec do
  Begin

    Locked:=BOff;


    Status:=GetPos(F[Fnum],Fnum,RecAddr);


    Ok:=GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked);

    If (Ok) and (Locked) then
    Begin

      NewCost:=Round_Up(Calc_StkCP(Currency_ConvFT(StockR.CostPrice,StockR.PCurrency,QCurrency,
                                            UseCoDayRate),StockR.BuyUnit,StockR.CalcPack),Syss.NoCosDec);

      With StockR do
        NewTime:=BOMProdTime+ProdTime;

      If (NewCost<>QtyCost) or (QtyTime<>NewTime) then
      Begin

        KeySTk:=Copy(StockLink,1,Sizeof(RecAddr));

        Ok:=GetMultiRec(B_GetEq,B_SingLock,KeyStk,KeyPath2,Fnum2,BOn,Locked);

        If (Ok) and (Locked) then
        Begin

          Calc_BillCost(QtyUsed,QtyCost,BOff,Stock,QtyTime);

          QtyCost:=NewCost;
          QtyTime:=NewTime;

          Calc_BillCost(QtyUsed,QtyCost,BOn,Stock,QtyTime);

          {* Update last edited flag *}

          Stock.LastUsed:=Today;
          Stock.TimeChange:=TimeNowStr;

          Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

          Report_BError(Fnum2,Status);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          UpDate_Kits(Stock);

          Application.ProcessMessages;
        end;

      end {If Cost Changed..}
      else
        Status:=Find_Rec(B_Unlock,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,Keys);

    end; {If Locked Ok..}


    SetDataRecOfs(Fnum,RecAddr);

    Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);


    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

end; {Proc..}


{ ========= Scan all Cost Prices ======= }


Procedure TStkList.Scan_Bill;



Const
  Fnum      =  StockF;
  Keypath   =  StkFolioK;




Var
  KeyS,
  KeyChk,
  KeyStk    :  Str255;

  ContRun   :  Boolean;

  ItemCount,
  ItemTotal,
  RecAddr   :  LongInt;




Begin

  KeyS:=FullNomKey(1);

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  ContRun:=BOn;

  RecAddr:=0;

  ItemCount:=0;

  Progress.Gauge1.MaxValue:=Used_Recs(F[Fnum],Fnum);

  While (StatusOk) and (ContRun) do
  With Stock do
  Begin

    KeyChk:=FullNomKey(StockFolio);

    Inc(ItemCount);

    Progress.Gauge1.Progress:=ItemCount;

    Status:=GetPos(F[Fnum],Fnum,RecAddr);

    Update_Kits(Stock);

    SetDataRecOfs(Fnum,RecAddr);

    Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    Loop_CheckKey(ContRun,Progress.Keyr);

    Progress.KeyR:=mrNone;

    Application.ProcessMessages;

  end; {While..}

  Progress.ShutDown;

  Update_UpChange(BOff);

  {$IFDEF PF_On}

     Warn_UPBOM;

  {$ENDIF}

end; {Proc..}




procedure TStkList.UpdateCostings1Click(Sender: TObject);
begin
  {$IFDEF PF_On}
    {$IFDEF POST}
      AddBOMUpdate2Thread(Self,0);    {* EL BoM Check implementation from DOS code *}
    {$ENDIF}
  {$ENDIF}

  {Progress:=TBarP.Create(Self);

  try
    Progress.Caption:='Update Build Costings.';

    Progress.ShowModal;

  finally

    Progress.Free;

  end;}

end;

procedure TStkList.Builddb1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;


procedure TStkList.Locdb1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;


procedure TStkList.Chkdb1BtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO[Current_Page])) then
    With MULCtrlO[Current_Page] do
    If (Not InListFind) then
    Begin
      GetSelRec(BOff);

      {$IFDEF POST}
        Check_StockLevels(BOff,Self,ScanFileNum,Keypath);
      {$ENDIF}

    end;
end;


procedure TStkList.FindDb1BtnClick(Sender: TObject);
Var
  ReturnCtrl  :  TReturnCtrlRec;

begin

  {$IFDEF GF}

    If (Not MULCtrlO[Current_Page].InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        LParam:=Current_Page;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOn;
        ShowSome:=(LParam=1);

        AllowAnyField:=BOn;

        If (ShowSome) then
          DontHide:=[tabFindSupplier,tabFindStock];

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindStock);

      end;
    end; {If in list find..}

  {$ENDIF}
end;



{$IFDEF SOP}

  procedure TStkList.Display_SRORec;

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (SRORec=nil) then
    Begin

      If (Assigned(MULCtrlO[1])) then
      Begin
        StkROB2B:=MULCtrlO[1].Back2Back;
        StkROGWOR:=MULCtrlO[1].GenWORMode;

      end;

      SRORec:=TStkReOrd.Create(Self);
      WasNew:=BOn;

    end;

    Try


     With SRORec do
     Begin

       WindowState:=wsNormal;

       If (Not ExLocal.InAddEdit) then
         EditLine(BOn,BOff,MULCtrlO[1].Keypath,Self.StkLocFilt)
       else
         Show;


     end; {With..}


    except

     SRORec.Free;
     SRORec:=nil;

    end;

  end;


   procedure TStkList.Display_SROFIRec;

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (ROFiRec=nil) then
    Begin

      ROFiRec:=TSOPROFiFrm.Create(Self);
      WasNew:=BOn;

    end;

    Try


     With MULCtrlO[1],ROFiRec do
     Begin

       If (WasNew) then
       Begin
         KCode:=StkGrpFilt^;
         SCode:=KeyRef;
         BOMWOR:=GenWORMode;
         SetFields;
       end;

       Show;
     end; {With..}


    except

     ROFiRec.Free;
     ROFiRec:=nil;

    end;

  end;


  procedure TStkList.Display_STARec;

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (STARec=nil) then
    Begin

      STARec:=TStkTake.Create(Self);
      WasNew:=BOn;

    end;

    Try


     With STARec do
     Begin

       WindowState:=wsNormal;

       If (Not ExLocal.InAddEdit) then
         EditLine(BOn,BOff,MULCtrlO[2].Keypath,StkLocFilt)
       else
         Show;


     end; {With..}


    except

     STARec.Free;
     STARec:=nil;

    end;

  end;


  procedure TStkList.SetListCaption(B2B  :  Boolean);

  Var
    BackStr  :  Str10;

  Begin

    If (B2B) then
      BackStr:='Alloc '
    else
      BackStr:='Min Stk ';

    ROMLab.Caption:=BackStr;

    Warn_UPBOM;
  end;
{$ENDIF}


procedure TStkList.DLdb1BtnClick(Sender: TObject);
Var
  TN  :  Integer;

begin
  {$IFDEF SOP}

    If (Sender Is TComponent) and (Assigned(MULCtrlO[Current_Page])) then
    With MULCtrlO[Current_Page] do
    If (Not InListFind) then
    Begin
      TN:=TComponent(Sender).Tag;

      Case TN of
        1  :  NoDeList:=Not NoDeList;
        2  :  MinFilt:=Not MinFilt;
        3  :  Begin
                Back2Back:=Not Back2Back;

                MinFilt:=Back2Back;

                SetListCaption(Back2Back);

                if (FSortView is TStockReorderSortView) then
                  (FSortView as TStockReorderSortView).Back2Back := Back2Back;
                  
              end;
      end;

      PageUpDn(0,BOn);
    end;

  {$ENDIF}
end;



procedure TStkList.ASdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  {$IFDEF SOP}
    If (Not MULCtrlO[Current_Page].InListFind) then
    Begin
      ListPoint.X:=1;
      ListPoint.Y:=1;

      With TWinControl(Sender) do
        ListPoint:=ClientToScreen(ListPoint);

      PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);
    end;

  {$ENDIF}

end;



procedure TStkList.ASROQty1Click(Sender: TObject);

Var
  mbRet      :  Word;
  ResetMode  :  Boolean;
  MStr       :  Str255;

begin
  {$IFDEF SOP}
   If (Not MULCtrlO[Current_Page].InListFind) then
   Begin
      ResetMode:=(TComponent(Sender).Tag=1);

      If (ResetMode) then
        MStr:='Please Confirm you wish to reset the order qty.'
      else
        MStr:='Please Confirm you wish to set the order qty from the need qty.';

      MbRet:=MessageDlg(MStr,mtConfirmation,[mbYes,mbNo],0);


      If (mbRet=mrYes) then
      With MULCtrlO[1] do
      Begin
        With TROCtrlForm.Create(Self) do
        Try
          Prime_ROCtrl(Back2Back,GenWORMode,ResetMode,StkGrpFilt^,StkLocFilt,ScanFileNum,Keypath,KeyRef,2, rmCreateOnly);

        finally
          Free;

        end;

        {Generate_AutoNeed(Back2Back,GenWORMode,ResetMode,StkGrpFilt^,StkLocFilt,ScanFileNum,Keypath,KeyRef);}

        PageUpDn(0,BOn);
      end;
    end;
  {$ENDIF}

end;

procedure TStkList.FIDb1BtnClick(Sender: TObject);

Var
  ThisPage  :  Integer;

begin
  ThisPage:=Current_Page;

  Case ThisPage of

  {$IFDEF LTE}
    0  :  If Assigned(MULCtrlO[ThisPage]) then
          With MULCtrlO[ThisPage] do
          Begin
            GrpFilt:=Not GrpFilt;

            If (GrpFilt) then
            Begin
              Blank(Filter[1,1],1);
              Blank(Filter[2,1],1);

              Filter[1,0]:=StkGrpCode;
            end
            else
            Begin
              Filter[1,1]:=StkGrpCode;   {* Exclude Grp types *}
              Filter[2,1]:=StkDListCode;   {* Exclude Delisted items *}

              Blank(Filter[1,0],1);
            end;

            InvLst3U.ResetCache;
            InvLst3U.UseCache := True;
            StartList(ScanFileNum,KeyPath,KeyRef,'','',KeyLen,BOff);
          end;

  {$ELSE}
    0  :  ;
  {$ENDIF}

    {$IFDEF SOP}
       1  :   Display_SROFiRec;
    {$ENDIF}
  end; {Case..}
end;

//------------------------------------------------------------------------------
procedure TStkList.PRdb1BtnClick(Sender: TObject);
Var
  mbRet    :  Word;
  Ok2Pro   :  Boolean;
  ThisPage :  Integer;
  btnPoint :  TPoint;

begin
  ThisPage:=Current_Page;

  {$IFDEF SOP}

  If (Not MULCtrlO[ThisPage].InListFind) then
  Begin
    If (ThisPage<>1) or (Not MULCtrlO[ThisPage].GenWORMode) then
    Begin
      // PKR. 10/12/2015. ABSEXC-15333. Re-order list to email all generated PORs to relevant suppliers
      // Multi-tabbed print dialog replaced by a popup menu.

      // Display the popup menu if this was invoked from the Stock Reorder tab
      if (ThisPage = 1) then
      begin
        GetCursorPos(btnPoint);
        with btnPoint do
        begin
          X := X-50;
          Y := Y-15;
        end;
        ProcessButtonPopupMenu.Popup(btnPoint.X, btnPoint.Y);
      end
      else
      begin
        // PKR. 10/12/2015. ABSEXC-15333. Re-order list to email all generated PORs to relevant suppliers
        // Not the Stock Reorder tab.  It must be Stock Take, so the original code applies.
        MbRet:=MessageDlg('Please Confirm you wish to process this list.',
                           mtConfirmation,[mbYes,mbNo],0);
        If (mbRet=mrYes) then
        begin
          With MULCtrlO[ThisPage] do
          Begin
            Ok2Pro:=BOff;

            If ((Not EmptyKey(StkLocFilt,LocKeyLen)) or (ThisPage=1)) or (Not Syss.UseMLoc) then
            Begin
              If (EmptyKey(StkLocFilt,LocKeyLen)) and (Syss.UseMLoc) then
              Begin
                FList1Click(nil);
                Ok2Pro:=(Not EmptyKey(StkLocFilt,LocKeyLen));
              end;

              If ((Ok2Pro) or ((Not EmptyKey(StkLocFilt,LocKeyLen)) or (Not Syss.UseMLoc))) then
              Begin
                // PKR. 10/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to relevant suppliers
                // This code only applies to Stock Take now, so case statement removed.

                //PR: 23/05/2017 ABSEXCH-18683 v2017 R1 Try to get a process lock
                if not GetProcessLock(plStockTake) then
                  EXIT;

                Try
                  Generate_ADJ(StkLocFilt);
                  PageUpDn(0,BOn);
                Finally
                  //Release process lock
                  SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plStockTake), 0);
                End;
              end
            end
            else
              ShowMessage('You must specify a location before processing');
          end;
        end;
      end
    end
    else
      If (FullWOP) then {Generate the WOR from here}
      With ExLocal,MULCtrlO[ThisPage],LId do
      If (ValidLine) and (Stock.StockType=StkBillCode) then
      Begin
        {$IFDEF WOP}
          LResetRec(InvF);
          LResetRec(IdetailF);

          StockCode:=Stock.StockCode;
          QtyMul:=1;
          Qty:=Stock.ROQty;

          If (Qty<=0) then
            Qty:=Stock.MinEccQty;

          Run_WORWizard(LInv,LId,255,Self);


        {$ENDIF} // IFDEF WOP
      end
      else
        ShowMessage('A Works Order can only be generated for a valid Bill of Material Record.');
    end;
  {$ENDIF}  // IFDEF SOP
end;

//------------------------------------------------------------------------------
// PKR. 10/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to
//      relevant suppliers
//
// Process Button popup menu event handlers
//------------------------------------------------------------------------------
// CREATE PURCHASE ORDERS ONLY option
//------------------------------------------------------------------------------
procedure TStkList.CreatePurchaseOrdersOnlyClick(Sender: TObject);
var
  ThisPage   : Integer;
  Ok2Process : Boolean;
begin
  // Create PORs only.  (Don't print, email or fax)
  ProcessReorder(rmCreateOnly);
end;

//------------------------------------------------------------------------------
// PRINT PURCHASE ORDERS option
//------------------------------------------------------------------------------
procedure TStkList.PrintPurchaseOrdersClick(Sender: TObject);
var
  ThisPage :  Integer;
begin
  // Create and Print PORs
  ProcessReorder(rmCreateAndPrint);
end;

//------------------------------------------------------------------------------
// USE SUPPLIER DEFAULTS option
//------------------------------------------------------------------------------
procedure TStkList.UseSupplierDefaultsClick(Sender: TObject);
begin
  // // Use the Supplier Defaults
  ProcessReorder(rmUseSupplierDefaults);
end;

//------------------------------------------------------------------------------
// NB. The CANCEL menu option doesn't need an event handler as all it needs to
//     do is close the menu, which happens anyway.

//------------------------------------------------------------------------------
procedure TStkList.ProcessReorder(aReorderMode : TReorderModes);
var
  ThisPage   : Integer;
  Ok2Process : Boolean;
begin
  ThisPage := Current_Page;

  {$IFDEF SOP}

  With MULCtrlO[ThisPage] do
  begin
    Ok2Process := false;

    // If no location filter set, prompt for one.
    if (EmptyKey(StkLocFilt,LocKeyLen)) and (Syss.UseMLoc) then
    begin
      FList1Click(nil);
      Ok2Process := (not EmptyKey(StkLocFilt,LocKeyLen));
    end;

    If ((Ok2Process) or ((Not EmptyKey(StkLocFilt,LocKeyLen)) or (Not Syss.UseMLoc))) then
    Begin
      with TROCtrlForm.Create(Self) do
        try
          // RJ 07/03/2016 2016-R2 ABSEXCH-10589: If the Sortview is enabled PO are not getting created in the Re-Oder Screen
          if MULCtrlO[ThisPage].SortViewEnabled then
            KeyRef := '';

          Prime_ROCtrl(Ok2Process, false, false, StkGrpFilt^, StkLocFilt, ScanFileNum, Keypath, KeyRef, Pred(Current_Page), aReorderMode);
        finally
          Free;
        end;

      PageUpDn(0,BOn);
    end;
  end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------
procedure TStkList.FRdb1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;

begin
  {$IFDEF SOP}
    If (Not MULCtrlO[Current_Page].InListFind) then
    Begin
      mbRet:=MessageDlg('Please Confirm you wish to start a new stock take',
                           mtConfirmation,[mbYes,mbNo],0);


      If (mbRet=mrYes) then
      With MULCtrlO[Current_Page] do
      Begin
        mbRet:=MessageDlg('Do you wish to use the current live stock levels?',
                           mtConfirmation,[mbYes,mbNo],0);

        {$IFDEF POST}
          AddStkFreeze2Thread(Self,(mbRet=mrNo),StkLocFilt);
        {$ENDIF}

      end;
    end;
  {$ENDIF}

end;


{$IFDEF SOP}

  function TStkList.SetLocDefs  :  Boolean;

  Const
    LocDesc  :  Array[BOff..BOn] of Str20 = ('Supplier','Bin Location');

  Var
    mbRet    :  Word;

  Begin
    Result:=BOff;

    If ((StkLocFilt='') and ((Current_Page=1) or (Current_Page=2))) or (LocOverride(StkLocFilt,3+Ord(Current_Page=2))) then
    Begin
      mbRet:=MessageDlg('Do you wish to use the location '+LocDesc[Current_Page=2]+'?',
                       mtConfirmation,[mbYes,mbNo],0);

      
      Result:=(mbRet=mrYes);

      fResetBinLoc:=(Result and (StkLocFilt<>''));

      {$IFDEF POST}
        If Result then
          AddStkLocOR2Thread(Self,StkLocFilt,(2*Ord(Current_Page=2))+(3*Ord(StkLocFilt='')),2);
      {$ENDIF}
    end;

  end;

{$ENDIF}


procedure TStkList.FList1Click(Sender  : TObject);


Var
  InpOk,
  FoundOk  :  Boolean;


  OCode,
  SCode    :  String;

Begin

  SCode:=StkLocFilt;
  OCode:=SCode;
  FoundOK := False;
  Repeat

    InpOk:=InputQuery('Location Filter','Enter the Location Code you wish to filter by.',SCode);

    {$IFDEF SOP}
      If (InpOk) then
        If (Not EmptyKey(SCode,LocKeyLen)) then
          FoundOk:=GetMLoc(Self,SCode,StkLocFilt,'',0)
        else
        Begin
          StkLocfilt:='';
          FoundOk:=BOn;
        end;
    {$ENDIF}

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) and (SCode<>OCode) and (Assigned(MULCtrlO[Current_Page])) and (Assigned(Sender)) then
  With MULCtrlO[Current_Page] do
  Begin
    SetMainCaption;

     If (Assigned(StkRecForm)) then
    With StkRecForm do
      If (Not ExLocal.InAddEdit) then
      Begin
        KeepLive:=BOn;
        SRecLocFilt:=StkLocFilt;
        ShowLink;
      end;

    {$IFDEF SOP}
      If (Current_Page<>0) then
        SetLocDefs;
    {$ENDIF}

    PageUpDn(0,BOn);
    LastSLFilt[Current_Page]:=StkLocFilt;


  end;


end;


{$IFDEF SOP}
  procedure TStkList.Link2MLoc(ScanMode  :  Boolean);

  Var
    WasNew  :  Boolean;

  begin
    WasNew:=BOff;


    With MULCtrlO[Current_Page] do
    Begin

      If (Not Assigned(MLocList)) then
      Begin
        Set_MLFormMode(21);
        MLocList:=TLocnList.Create(Self);
        WasNew:=BOn;
      end;


      With MLocList do
      Begin
        try
          LSRKey:=Stock.StockCode;
          ExLocal.AssignFromGlobal(StockF);

          If (WasNew) then
            ChangePage(1)
          else
          Begin

            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            RefreshList(BOn,BOn);

            If (Not ScanMode) then
              Show;
          end;

        except
          MLocList.Free;
          MLocList:=nil;
        end; {try..}
      end; {With..}
    end;
  end;


  procedure TStkList.Link2AltC(ScanMode  :  Boolean);

  Var
    WasNew  :  Boolean;
    CMode,
    CPage   :  Byte;

    CSFilt  :  Str10;

  begin
    WasNew:=BOff;

    CPage:=Current_Page;

    With MULCtrlO[CPage] do
    Begin
      CMode:=1+(1*Ord(CPage=1))+(1*Ord(KeyRef<>''));
      CSFilt:=KeyRef;

      If (Not Assigned(AltCList)) then
      Begin

        Set_ACFormMode(CMode,Stock.StockFolio,CSFilt);

        AltCList:=TAltCList.Create(Self);
        WasNew:=BOn;
      end;


      With AltCList do
      Begin
        try
          ExLocal.AssignFromGlobal(StockF);

          If (Not WasNew) then
          Begin
            RecFolio:=ExLocal.LStock.StockFolio;
            RecMode:=CMode;
            RecSupp:=CSFilt;

            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            RefreshList(BOn,BOn);

            If (Not ScanMode) then
              Show;
          end;

          SetCaption;
        except
          AltCList.Free;
          AltCList:=nil;
        end; {try..}
      end; {With..}
    end;
  end;
{$ENDIF}

procedure TStkList.View1Click(Sender: TObject);

begin

  {$IFDEF SOP}
    With MULCtrlO[Current_Page] do
      If (ValidLine) and (Not InListFind) then
        Link2MLoc(BOff);
  {$ENDIF}
end;

procedure TStkList.Lnkdb1BtnClick(Sender: TObject);
{$IFDEF Ltr}
Var
  NKey    : String[4];
  OldCust : ^CustRec;
{$ENDIF}
begin
  {$IFDEF Ltr}
    If (MULCtrlO[Current_Page].ValidLine) and (Not MULCtrlO[Current_Page].InListFind) Then
    Begin
      With MULCtrlO[Current_Page] do
        RefreshLine(MUListBoxes[0].Row,BOff);

      { Create form if not already created }
      If Not Assigned (LetterForm) Then
      Begin
        { Create letters form }
        LetterForm := TLettersList.Create (Self);
      End; { If }

      Try
        { mark form as active }
        LetterActive := BOn;

        { Display form }
        LetterForm.WindowState := wsNormal;
        LetterForm.Show;

        { Get Supplier }
        New (OldCust);
        OldCust^ := Cust;
        NKey := FullNomKey(Stock.StockFolio);
        If CheckRecExsists(FullCustCode(Stock.Supplier), CustF, CustCodeK) Then
          LetterForm.LoadLettersFor (NKey,                          { Index Key }
                                     Stock.StockCode,               { Caption }
                                     CodeToFName (Stock.StockCode), { FName }
                                     LetterStkCode,
                                     @Cust, @Stock, Nil, Nil, Nil)
        Else
          LetterForm.LoadLettersFor (NKey,                          { Index Key }
                                     Stock.StockCode,               { Caption }
                                     CodeToFName (Stock.StockCode), { FName }
                                     LetterStkCode,
                                     Nil, @Stock, Nil, Nil, Nil);
        Cust := OldCust^;
        Dispose(OldCust);
      Except
       LetterActive := BOff;
       LetterForm.Free;
      End;
    End; { If }
  {$ENDIF}
end;

procedure TStkList.Altdb1BtnClick(Sender: TObject);
begin
  {$IFDEF SOP}
    With MULCtrlO[Current_Page] do
      If (ValidLine) and (Not InListFind) then
        Link2AltC(BOff);
  {$ENDIF}
end;

procedure TStkList.CustdbBtn1Click(Sender: TObject);
Var
  PageNo  :  Integer;
begin
  PageNo:=Current_Page;

  {$IFDEF CU}
    If (Assigned(MULCtrlO[PageNo])) then
    With MULCtrlO[PageNo],ExLocal do
    Begin
      If (ValidLine) then
      Begin
        LStock:=Stock;

        
        With LPassWord, CostCtrRec do
        Begin
          LResetRec(PwrdF);
          RecPfix:=CostCCode;
          Subtype:=CSubCode[BOff];
          
          If (MLStkLocFilt^<>'') then {* A location filter is in operation *}
            PCostC:=MLStkLocFilt^;
        end;


        ExecuteCustBtn(3000,((10+PageNo)*Ord((Sender=CustdbBtn1) or (Sender=Custom1)))+
                      ((20+PageNo)*Ord((Sender=CustdbBtn2) or (Sender=Custom2))), ExLocal);

      end;
    end; {With..}
  {$ENDIF}
end;

procedure TStkList.SetHelpContextIDs;
// NF: 20/06/06 Fix for incorrect Context IDs
begin
  // Fix incorrect IDs
  Lnkdb1Btn.HelpContext := 1845;
end;



procedure TStkList.ShowSortViewDlg;
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
  PageNo: Integer;
begin
  PageNo := Current_Page;
  Dlg := TSortViewOptionsFrm.Create(nil);
  Dlg.SortView := MULCtrlO[PageNo].SortView;
  try
    if (Dlg.ShowModal = mrOk) then
    begin
{
      FuncRes := MulCtrlO[Current_Page].SortView.Apply;
      if (FuncRes = 0) then
}
      begin
        MulCtrlO[PageNo].SortView.Enabled := True;
        RefreshList(True, False);
        if MulCtrlO[PageNo].SortView.Sorts[1].svsAscending then
          pcStockList.Pages[PageNo].ImageIndex := 1
        else
          pcStockList.Pages[PageNo].ImageIndex := 2;
        Sortdb1Btn.Enabled := False;
        FIDb1Btn.Enabled := False;
        FList1.Enabled := False;
        FList1.Hint := 'Filtering by location is not available while a sort view is active.';
      end
{
      else
        ShowMessage('Failed to initialise Sort View, error #' + IntToStr(FuncRes)
};
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TStkList.Refreshview1Click(Sender: TObject);
var
  FuncRes: Integer;
begin
  FuncRes := MulCtrlO[Current_Page].SortView.Refresh;
  if (FuncRes = 0) then
  begin
    MulCtrlO[Current_Page].SortView.Enabled := True;
    RefreshList(True, False);
    if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
      pcStockList.Pages[Current_Page].ImageIndex := 1
    else
      pcStockList.Pages[Current_Page].ImageIndex := 2;
  end
  else
    ShowMessage('Failed to refresh Sort View, error #' + IntToStr(FuncRes));
end;

procedure TStkList.Closeview1Click(Sender: TObject);
begin
  MulCtrlO[Current_Page].SortView.CloseView;
  MulCtrlO[Current_Page].SortView.Enabled := False;
  pcStockList.Pages[Current_Page].ImageIndex := -1;
  MulCtrlO[Current_Page].ScanFileNum := StockF;
  MulCtrlO[Current_Page].KeyRef := '';
  MulCtrlO[Current_Page].UseDefaultSortView := False;
  RefreshList(True, False);
  Sortdb1Btn.Enabled := True;
  FIDb1Btn.Enabled := True;
  FList1.Enabled := True;
  FList1.Hint := 'Choosing this option filters the current list by location, specifying a blank location gives a consolidated view.';
end;

procedure TStkList.SortViewOptions1Click(Sender: TObject);
begin
  ShowSortViewDlg;
end;

procedure TStkList.SortViewBtnClick(Sender: TObject);
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
  MenuPoint: TPoint;
begin
  if (not MulCtrlO[Current_Page].SortView.IsBuildingFile) then
  begin
    if (Sender is TButton) and MulCtrlO[Current_Page].SortView.Enabled then
    begin
      GetCursorPos(MenuPoint);
      with MenuPoint do
      begin
        X := X - 50;
        Y := Y - 15;
      end;
      SortViewPopupMenu.PopUp(MenuPoint.X, MenuPoint.Y);
    end
    else
      ShowSortViewDlg;
  end;
end;

// -----------------------------------------------------------------------------
// CJS: 13/12/2010 - Amendments for new Window Settings system
// -----------------------------------------------------------------------------
procedure TStkList.LoadListSettings(ForListNo: Integer);
begin
  if Assigned(FSettings) and Assigned(MULCtrlO[ForListNo]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO[ForListNo]);
end;

// -----------------------------------------------------------------------------

procedure TStkList.LoadWindowSettings;
begin
  if Assigned(FSettings) then
  begin
    FSettings.LoadSettings;
    if not FSettings.UseDefaults then
      FSettings.SettingsToWindow(Self);
  end;
end;

// -----------------------------------------------------------------------------

procedure TStkList.SaveListSettings(ForListNo: Integer);
begin
  if Assigned(MULCtrlO[ForListNo]) then
    FSettings.ParentToSettings(MULCtrlO[ForListNo], MULCtrlO[ForListNo]);
end;

// -----------------------------------------------------------------------------

procedure TStkList.SaveWindowSettings;
var
  i: Integer;
begin
  if Assigned(FSettings) and NeedCUpdate then
  begin
    for i := Low(MULCtrlO) to High(MULCtrlO) do
      SaveListSettings(i);
    FSettings.WindowToSettings(self);
    FSettings.SaveSettings(StoreCoord);
  end;
  FSettings := nil;
end;

// -----------------------------------------------------------------------------

procedure TStkList.EditWindowSettings;
begin
  if Assigned(FSettings) and Assigned(MULCtrlO[Current_Page]) then
    if FSettings.Edit(MULCtrlO[Current_Page], MULCtrlO[Current_Page]) = mrOK then
      NeedCUpdate := True;
end;

// -----------------------------------------------------------------------------

function TStkList.WindowExportEnableExport: Boolean;
begin
  Result := (Current_Page In [0, 1]);
  If Result Then
  begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  end; // If Result
end;


procedure TStkList.WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    begin
      // Get the active Btrieve List to export the data
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    end; // If ListExportIntf.StartExport(sTitle)
  finally
    ListExportIntf := NIL;
  end; // Try..Finally

end;

function TStkList.WindowExportGetExportDescription: String;
begin
  Case Current_Page of
    0 : Result := 'Stock List';
    1 : Result := 'Re-Order';
  else
    Result := 'Unknown Export';
  end; // Case Current_Page

end;

Initialization

  SListFormPage:=0;

end.
