unit CustLst2;

interface

{$I DEFOVR.Inc}

{$F+}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls, SBSPanel, Tabnotbk, Buttons,
  ETMiscU,GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,ColCtrlU,  CmpCtrlU,
  CustR3U,

  {$IFDEF LTR}
    Letters,
  {$ENDIF}
  VarSortV,
  SortCust,
  BtrvU2,
  ImgModu,

  Menus, TCustom,
  {$IFDEF CU}
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  CustomBtnHandler,
  {$ENDIF}

  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf,

  EntWindowSettings, uExDatasets, uSQLDatasets,
  dmMainTraderList;

type

 {=== Cust List ===}

  TCustList  =  Class(TMULCtrl)
  private
    function GetSortView: TCustomerSortView;
    procedure SetSortView(const Value: TCustomerSortView);
  public
    FilterMode  :  Byte;

    // CJS 2013-10-02 - MRD1.1.14 - Trader List
    ListType: Byte;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function GetCustBal(CCode  :  Str10;
                        BalPr,
                        BalYr  :  Byte)  :  Double;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure Find_ListCoord(GlobComp  :  TGlobCompRec);

    procedure Store_ListCoord(GlobComp  :  TGlobCompRec);

    Procedure SetNewFilter(Filter  :  Byte);

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SortViewType(Value: Integer);
    property SortView: TCustomerSortView read GetSortView write SetSortView;

  end;


  TTradList = class(TForm)
    PageControl1: TPageControl;
    // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers - renamed tabs, and
    // added new Consumer tab
    CustomerPage: TTabSheet;
    SupplierPage: TTabSheet;
    ConsumerPage: TTabSheet;
    ScrolBox5: TScrollBox;
    TLCompPanel: TSBSPanel;
    TLBalPanel: TSBSPanel;
    TLAccPanel: TSBSPanel;
    TLTelPanel: TSBSPanel;
    SBSPanel1: TSBSPanel;
    TLSScrollBox: TScrollBox;
    TLSCompPanel: TSBSPanel;
    TLSAccPanel: TSBSPanel;
    TLSTelPanel: TSBSPanel;
    TLSBalPanel: TSBSPanel;
    TLHedPanel: TSBSPanel;
    TPSCtrlPanel: TSBSPanel;
    Button1: TButton;
    TPSScrollBox: TScrollBox;
    TLSAddBtn: TButton;
    TLSEditBtn: TButton;
    TLSFindBtn: TButton;
    TLSDelBtn: TButton;
    TLSNoteBtn: TButton;
    TLSChkBtn: TButton;
    TLSPrnBtn: TButton;
    TLSLedBtn: TButton;
    TLSHistBtn: TButton;
    Panel1: TSBSPanel;
    Button13: TButton;
    ScrolBox6: TScrollBox;
    TLCAddBtn: TButton;
    TLCEditBtn: TButton;
    TLCFindBtn: TButton;
    TLCDelBtn: TButton;
    TLCNoteBtn: TButton;
    TLCChkBtn: TButton;
    TLCPrnBtn: TButton;
    TLCLedBtn: TButton;
    TLCHistBtn: TButton;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    N2: TMenuItem;
    Find1: TMenuItem;
    Ledger1: TMenuItem;
    Notes1: TMenuItem;
    N3: TMenuItem;
    Delete1: TMenuItem;
    TLSAccLab: TSBSPanel;
    TLSCompLab: TSBSPanel;
    TLSBalLab: TSBSPanel;
    TLSTelLab: TSBSPanel;
    Hist1: TMenuItem;
    Print1: TMenuItem;
    Check1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Bal1: TMenuItem;
    Profit1: TMenuItem;
    TLAccLab: TSBSPanel;
    TLCompLab: TSBSPanel;
    TLBalLab: TSBSPanel;
    TLTelLab: TSBSPanel;
    TLCLetrBtn: TButton;
    TLSLetrBtn: TButton;
    Letters1: TMenuItem;
    TLCSABtn: TButton;
    TLCTSBtn: TButton;
    StkAnal1: TMenuItem;
    TeleSales1: TMenuItem;
    TLSSABtn: TButton;
    TLSTSBtn: TButton;
    EntCustom2: TCustomisation;
    CustCuBtn1: TSBSButton;
    CustCuBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    CustSuBtn1: TSBSButton;
    CustSuBtn2: TSBSButton;
    PopupMenu3: TPopupMenu;
    FindAc1: TMenuItem;
    MenuItem2: TMenuItem;
    FiltBal1: TMenuItem;
    N4: TMenuItem;
    FiltBal2: TMenuItem;
    TLSSortBtn: TButton;
    SortViewPopupMenu: TPopupMenu;
    RefreshView1: TMenuItem;
    CloseView1: TMenuItem;
    N5: TMenuItem;
    SortViewOptions1: TMenuItem;
    TLCSortBtn: TButton;
    SortView1: TMenuItem;
    RefreshView2: TMenuItem;
    CloseView2: TMenuItem;
    N7: TMenuItem;
    SortViewOptions2: TMenuItem;
    TLAddr1Panel: TSBSPanel;
    TLAddr1Lab: TSBSPanel;
    TLAddr2Panel: TSBSPanel;
    TLAddr3Panel: TSBSPanel;
    TLAddr4Panel: TSBSPanel;
    TLAddr5Panel: TSBSPanel;
    TLPCPanel: TSBSPanel;
    TLAddr2Lab: TSBSPanel;
    TLAddr3Lab: TSBSPanel;
    TLAddr4Lab: TSBSPanel;
    TLAddr5Lab: TSBSPanel;
    TLPCLab: TSBSPanel;
    TLSAdd1Pan: TSBSPanel;
    TLSAdd1Lab: TSBSPanel;
    TLSAdd2Pan: TSBSPanel;
    TLSAdd2Lab: TSBSPanel;
    TLSAdd3Pan: TSBSPanel;
    TLSAdd3Lab: TSBSPanel;
    TLSAdd4Pan: TSBSPanel;
    TLSAdd4Lab: TSBSPanel;
    TLSAdd5Pan: TSBSPanel;
    TLSAdd5Lab: TSBSPanel;
    TLSPCPanel: TSBSPanel;
    TLSPCLab: TSBSPanel;
    panCustUpDown: TSBSPanel;
    TLSCtrlPanel: TSBSPanel;
    TLEmailPanel: TSBSPanel;
    SBSEmail: TSBSPanel;
    TLStatusPanel: TSBSPanel;
    SBSStatus: TSBSPanel;
    TLSEmailPanel: TSBSPanel;
    TLSStatusPanel: TSBSPanel;
    SBSSEmail: TSBSPanel;
    SBSSStatus: TSBSPanel;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    CustSuBtn3: TSBSButton;
    CustSuBtn4: TSBSButton;
    CustSuBtn5: TSBSButton;
    CustSuBtn6: TSBSButton;
    CustCuBtn3: TSBSButton;
    CustCuBtn4: TSBSButton;
    CustCuBtn5: TSBSButton;
    CustCuBtn6: TSBSButton;
    ConsumerListScrollBox: TScrollBox;
    ConsumerListCompanyPanel: TSBSPanel;
    ConsumerListCodePanel: TSBSPanel;
    ConsumerListTelephonePanel: TSBSPanel;
    ConsumerListBalancePanel: TSBSPanel;
    ConsumerListHeaderPanel: TSBSPanel;
    ConsumerListCodeLabel: TSBSPanel;
    ConsumerListCompanyLabel: TSBSPanel;
    ConsumerListBalanceLabel: TSBSPanel;
    ConsumerListTelephoneLabel: TSBSPanel;
    ConsumerListAddressLine1Label: TSBSPanel;
    ConsumerListAddressLine2Label: TSBSPanel;
    ConsumerListAddressLine3Label: TSBSPanel;
    ConsumerListAddressLine4Label: TSBSPanel;
    ConsumerListAddressLine5Label: TSBSPanel;
    ConsumerListPostCodeLabel: TSBSPanel;
    ConsumerListEmailLabel: TSBSPanel;
    ConsumerListStatusLabel: TSBSPanel;
    ConsumerListAddressLine1Panel: TSBSPanel;
    ConsumerListAddressLine2Panel: TSBSPanel;
    ConsumerListAddressLine3Panel: TSBSPanel;
    ConsumerListAddressLine4Panel: TSBSPanel;
    ConsumerListAddressLine5Panel: TSBSPanel;
    ConsumerListPostCodePanel: TSBSPanel;
    ConsumerListEmailPanel: TSBSPanel;
    ConsumerListStatusPanel: TSBSPanel;
    ConsumerListScrollBar: TSBSPanel;
    ConsumerListButtonPanel: TSBSPanel;
    ConsumerListCloseButton: TButton;
    ConsumerListButtonBox: TScrollBox;
    ConsumerListAddButton: TButton;
    ConsumerListEditButton: TButton;
    ConsumerListFindButton: TButton;
    ConsumerListDeleteButton: TButton;
    ConsumerListNotesButton: TButton;
    ConsumerListCheckButton: TButton;
    ConsumerListPrintButton: TButton;
    ConsumerListLedgerButton: TButton;
    ConsumerListHistoryButton: TButton;
    ConsumerListLinksButton: TButton;
    ConsumerListStockAnalysisButton: TButton;
    ConsumerListTeleSalesButton: TButton;
    ConsumerListCustomButton1: TSBSButton;
    ConsumerListCustomButton2: TSBSButton;
    ConsumerListSortViewButton: TButton;
    ConsumerListCustomButton3: TSBSButton;
    ConsumerListCustomButton4: TSBSButton;
    ConsumerListCustomButton5: TSBSButton;
    ConsumerListCustomButton6: TSBSButton;
    SQLDatasets1: TSQLDatasets;
    WindowExport: TWindowExport;
    procedure FormCreate(Sender: TObject);
    procedure TLAccPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TLAccLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TLAccLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure TLCloseBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TLCAddBtnClick(Sender: TObject);
    procedure TLCFindBtnClick(Sender: TObject);
    procedure TLCHistBtnClick(Sender: TObject);
    procedure Bal1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TLCLetrBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TLCPrnBtnClick(Sender: TObject);
    procedure TLCChkBtnClick(Sender: TObject);
    procedure TLCSABtnClick(Sender: TObject);
    procedure CustCuBtn1Click(Sender: TObject);
    procedure FindAc1Click(Sender: TObject);
    procedure TLSSortBtnClick(Sender: TObject);
    procedure RefreshView1Click(Sender: TObject);
    procedure CloseView1Click(Sender: TObject);
    procedure SortViewOptions1Click(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer; Const ProgressHWnd : HWnd);
    function WindowExportGetExportDescription: String;

  private
    { Private declarations }

    //AnkitaP - 
    FdmTrader: TdmTraderList;

    // CJS 06/09/2013 - MRD1.1 - Consumer tab (removed redundant 4th tab page)
    LastBTag   :  Array[0..2] of LongInt;

    MULCtrlO   :  Array[0..2] of TCustList;

    ListOfSet  :  Integer;

    ListActive,
    StoreCoord,
    InAutoRefresh,
    fFrmClosing,
    fDoingDestroy,
    fDoingClose,
    fNeedCUpdate,
    LastCoord,
    SetDefault,
    FColorsChanged,
    GotCoord   :  Boolean;

    FindMCount :  LongInt;

    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP     :  TPoint;

    StartSize,
    InitSize   :  TPoint;

    // CJS 06/09/2013 - MRD1.1 - Consumer tab (removed redundant 4th tab page)
    CustActive :  Array[0..2] of Boolean;

    CustRecForm:  Array[0..2] of TCustRec3;

    // array index is PageNo (or tab number).
    CustBtnList:  Array[0..2] of TVisiBtns;

    {$IFDEF Ltr}
      LettersActive: Array[0..2] of Boolean;
      LettersForm:   Array[0..2] of TLettersList;
    {$ENDIF}

    {$IFDEF CU}
    // 25/01/2013  PKR   ABSEXCH-13449/38
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}
    
    //PR: 03/11/2010
    FSettings :IWindowSettings;

    procedure Display_Account(Mode  :  Byte);

    procedure FormSetOfSet;

    procedure BuildMenus(CreatedNow  :  Boolean);

    procedure PrimeButtons(PageNo  :  Integer;
                           PWRef   :  Boolean);


    procedure SetTabs2;

    Procedure Send_ParentMsg(Mode   :  Integer);

    Procedure SetDeleteStat(CPage  :  Integer;
                            CCode  :  Str10);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure SendObjectCC;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    Function KeyPressOk  :  Boolean;

    procedure SetFormProperties;

    procedure Find_Page1Coord;

    procedure Store_Page1Coord(UpMode  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure TLCFindAccount(Sender: TObject);

    // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers - added PageNo
    // parameter to distinguish between Consumer tab and Supplier tab (Customer
    // tab is created at form creation).
    procedure Page1Create(Sender: TObject; PageNo: Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    procedure SetHelpContextIDsForPage; // NF: 10/04/06

    procedure ShowSortViewDlg;

    procedure ActivateSortView;
    
  public
    { Public declarations }
    ExLocal    :  TdExLocal;

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

  end;


 Procedure Set_TradListFormMode(State  :  Byte);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  DebugU,
  BTSupU2,

  {$IFDEF GF}
    {FindRecU,}
    FindCtlU,
  {$ENDIF}

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  BTKeys1U,

  {$IFDEF JC}
    JChkUseU,
  {$ENDIF}

  {$IFDEF POST}
     PostingU,
  {$ENDIF}
  UA_Const,

  SortViewOptionsF,
  SortViewU,

  Event1U,
  SysU1,
  SysU2,
  PWarnU,
  ExThrd2U,
  BTSupU3,
  SavePos,
  ConsumerUtils,

  SQL_CheckAllAccounts,
  SQLUtils,
  SQLRep_Config,
  oProcessLock,
  GDPRConst,

  // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  oExcelExport;


{$R *.DFM}

Var
  TradListFormMode  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_TradListFormMode(State  :  Byte);
Begin
  If (State<>TradListFormMode) then
    TradListFormMode:=State;
end;


{ ============== TCustList Methods =============== }

constructor TCustList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SortView := TCustomerSortView.Create(True);
end;

destructor TCustList.Destroy;
begin
  FreeAndNil(FSortView);
  inherited Destroy;
end;

function TCustList.GetSortView: TCustomerSortView;
begin
  Result := FSortView as TCustomerSortView;
end;

procedure TCustList.SetSortView(const Value: TCustomerSortView);
begin
  inherited SetSortView(Value);
end;

procedure TCustList.SortViewType(Value: Integer);
begin
  // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
  case Value of
    CUSTOMER_TYPE:
  begin
    FSortView.ListType := svltCustomer;
    FSortView.ListDesc := 'Customer List';
      end;
    CONSUMER_TYPE:
      begin
        FSortView.ListType := svltConsumer;
        FSortView.ListDesc := 'Consumer List';
      end;
    SUPPLIER_TYPE:
  begin
    FSortView.ListType := svltSupplier;
    FSortView.ListDesc := 'Supplier List';
  end;
end;
end;

Function TCustList.SetCheckKey  :  Str255;
// Used by SBSComp.pas to get the key to check against when ensuring that the
// current record matches the search key
Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  if SortViewEnabled then
    DumStr := SortTempRec.svtField1 + SortTempRec.svtField2 + FullNomKey(SortTempRec.svtFolio)
  else
    // CJS 06/09/2013 - MRD 1.1 - Consumer List tab - changed search key prefix
    // to new SubType instead of Cust.CustSupp
    DumStr := Cust.acSubType + Cust.CustCode;

  Result := DumStr;
end;




Function TCustList.SetFilter  :  Str255;
// Returns the string to be used by PassFilter (in SBSComp.pas) when filtering
// the list to Customers, Consumers, and Suppliers. If Filter On Balance is
// active this returns #255 if the current record has a zero balance (which
// will then exclude this record), otherwise it returns the SubType ('C', 'U',
// or 'S').

// CJS 06/09/2013 - MRD 1.1 - Consumer List tab - amended the filter to use
// acSubType instead of CustSupp.
Begin
  Case FilterMode of
    1  :  With Cust do
          Begin
            If (Round_Up(GetCustBal(CustCode,GetLocalPr(0).CPr,GetLocalPr(0).CYr),2)<>0.0) then
              Result := Cust.acSubType
            else
              Result:=NdxWeight;
          end
    else  Result := Cust.acSubType; // Cust.CustSupp;
  end; {Case..}
end;


Function TCustList.Ok2Del :  Boolean;
// Always returns False. The Trader List actually uses Ok2DelAcc() to check
// whether a Trader record can be deleted.
Begin
  Result:=BOff;
end;

Procedure TCustList.SetNewFilter(Filter  :  Byte);
// Sets a new filter. At the moment the only valid Filter value is 1, which
// activates Filter On Balance.

// CJS 06/09/2013 - MRD 1.1 - Consumer List tab - amended StartList() to use
// the new SubType + LongAcCode index (CustACCodeK) for Consumers
Begin
  FilterMode:=Filter;

  if SortView.Enabled then
    StartList(SortTempF, STFieldK, FullNomKey(FSortView.ListID), '', '', 0, BOff)
  else if ListType = CONSUMER_TYPE then
    StartList(CustF, CustLongACCodeK, KeyRef, '', '', 1, BOff)
  else
    StartList(CustF,ATCodeK,KeyRef,'','',1,BOff);
end;

Function TCustList.GetCustBal(CCode  :  Str10;
                              BalPr,
                              BalYr  :  Byte)  :  Double;

Var
  Profit,
  Sales,
  Purch,
  Cleared      :  Double;

Begin

  Result:=Profit_to_Date(CustHistCde,CCode,0,BalYr,BalPr,Purch,Sales,Cleared,BOn);

end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TCustList.OutLine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str10;
  FoundOk    :  Boolean;
  Dnum       :  Double;
  ReturnVal : Integer;
  SearchKey: Str255;
  RecordPosition: TBtrieveSavePosition;

Begin
  Dnum:=0;
   With Cust do
     Case Col of

       0  : begin
              // CJS 2013-09-30 - MRD1.1.14 - Trader List - for Consumers,
              // display the new Long Account Code field
              if acSubType = 'U' then
                OutLine := acLongAcCode
              else
                OutLine := CustCode;
            end;
       1  :  begin
               // SSK 22/10/2017 ABSEXCH-19386: Implements anonymisation behaviour for trader
               if GDPROn and (acAnonymisationStatus = asAnonymised) then
                 OutLine:= capAnonymised
               else
                 OutLine:= Company;
             end;
       2  :  Begin
               {$B-}
               // CJS 2013-10-01 - MRD1.1.14 - Trader List - Consumers
               if ((acSubType = 'C') and PChkAllowed_In(uaCustomerViewBalance)) or
                  ((acSubType = 'U') and PChkAllowed_In(uaConsumerViewBalance)) or
                  ((acSubType = 'S') and PChkAllowed_In(uaSupplierViewBalance)) then
               {$B+}
                  Dnum:=GetCustBal(CustCode,GetLocalPr(0).CPr,GetLocalPr(0).CYr);

               OutLine:=FormatFloat(GenRealMask,Dnum);
             end;

       3  :  OutLine:=Phone;

       // Address 1..5
       4..8 :  Outline := Trim(Addr[Col-3]);

       9    :  OutLine := Trim(PostCode);

       //GS 15/03/2012 ABSEXCH-11271: added 10th column to the trader list; email address
       10   :  OutLine := Trim(EmailAddr);

       //GS 15/03/2012 ABSEXCH-11271: added 11th column to the trader list; status (boolean representing if the user has notes)
       11   :  OutLine := Show_AccStatus(AccStatus);

       else
             OutLine:='';

     end; {Case..}
end;




Procedure TCustList.Find_ListCoord(GlobComp  :  TGlobCompRec);

Var
  TmpList :  TList;

  n       :  Byte;

  TmpColO :  Integer;

  TmpPanel:  TSBSPanel;

  LoopCtrl:  Boolean;

Begin
  LoopCtrl:=BOff;

  TmpList:=TList.Create;


  With GlobComp^,VisiList do
  Begin

    For n:= 0 to Pred(Count) do
    Begin
      TmpList.Add(nil);
    end;

    For n:= 0 to Pred(Count) do
    Begin

      VisiRec:=List[n];

      With VisiRec^ ,ColAppear^[n] do
      Begin

        TmpPanel:=(PanelObj as TSBSPanel);

        Repeat

          If GetbtControlCsm(TmpPanel) then
          Begin
            HBkColor:=HLite;
            HTextColor:=HTLite;

            If (Not LoopCtrl) and (HasCoord) then
            Begin
              TmpList.Items[ColOrd]:=Items[n];
            end
          end;


          TmpPanel:=(LabelObj as TSBSPanel);


          LoopCtrl:=Not LoopCtrl;

        Until (Not LoopCtrl);

      end; {With..}
    end; {Loop..}

    If (TmpList.Items[0]<>nil) then
    For n:= 0 to Pred(Count) do
    Begin
      Items[n]:=TmpList.Items[n];
    end;

    TmpList.Free;
  end; {With..}
end; {Proc..}


procedure TCustList.Store_ListCoord(GlobComp  :  TGlobCompRec);


Var
  n       :  Byte;

  TmpPanel:  TSBSPanel;

  LoopCtrl:  Boolean;


Begin

  With GlobComp^ do
  Begin


    LoopCtrl:=BOff;

    With VisiList do
    Begin
      For n:= 0 to Pred(Count) do
      Begin

        VisiRec:=List[n];

        With VisiRec^ ,ColAppear^[n] do
        Begin

          TmpPanel:=(PanelObj as TSBSPanel);

          Repeat

            ColOrd:=n;

            HLite:=HBkColor;
            HTLite:=HTextColor;

            StorebtControlCsm(TmpPanel);


            TmpPanel:=(LabelObj as TSBSPanel);

            LoopCtrl:=Not LoopCtrl;

          Until (Not LoopCtrl);

        end;
      end; {Loop..}

    end; {With..}

  end; {With GlobComp..}

end;


{ =================================================================================== }



Function TTradList.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;


procedure TTradList.Display_Account(Mode  :  Byte);

Var
  CPage    :  Integer;

  TSBtn    :  TObject;

Begin

  CPage:=Current_Page;

  If (CustRecForm[CPage]=nil) then
  Begin

    // CJS 24/09/2013 - MRD1.1.14 - Trader List - Consumers Record
    case CPage of
      0: Set_CustFormMode(CUSTOMER_TYPE);
      1: Set_CustFormMode(CONSUMER_TYPE);
      2: Set_CustFormMode(SUPPLIER_TYPE);
    end;

    CustRecForm[CPage]:=TCustRec3.Create(Self);

  end
  else //HV 06/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
    CustRecForm[CPage].ListScanningOn  := True;

  Try

   CustActive[CPage]:=BOn;

   With CustRecForm[CPage] do
   Begin
     // SSK 29/11/2017 ABSEXCH-19386: Implements anonymisation behaviour for trader
     // SSK 08/12/2017 ABSEXCH-19546: this needs to be checked
     // HV 11/07/2018 2018R1.1 ABSEXCH-21082: Anon. Pending banner is displayed for "Open" Trader > If in ledger, SRC is allocated and User tries to switch to any closed customer record.
     if (Not ExLocal.InAddEdit) and (AllocateOk(BOff)) then
       AnonymisationON := GDPROn and (Mode <> 1) and (Cust.acAnonymisationStatus in [asPending, asAnonymised]);

     WindowState:=wsNormal;

     CanAllocate:=BOn;
     SetTabs;

     If (HistFormPtr=nil) or (Mode In [1..9,20,21]) then
       Show;

     If (Not ExLocal.InAddEdit) and (AllocateOk(BOff)) then
       ShowLink;


     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) and (AllocateOk(BOff)) then
     Begin
       ChangePage(CustR3U.MainPno);

       If (Mode=3) then
         DeleteAccount
       else
         EditAccount((Mode=2));
     end;

     Case Mode of

       5  :  ChangePage(CustR3U.NotesPNo);
       6..9
          :  Begin
               If (Current_Page<>CustR3U.LedgerPNo) then
                 ChangePage(CustR3U.LedgerPNo);

               If (Mode>6) and (HistFormPtr=nil) then
                 Display_History(Mode-6,BOn);

             end;

       {$IFDEF STK}
         20,21
            :  Begin
                 If (Mode=20) then
                   TSBtn:=StkCCP1Btn
                 else
                   TSBtn:=TeleSCP1Btn;

                 StkCCP1BtnClick(TSBtn);

               end;

       {$ENDIF}
     end;



   end; {With..}


  except

   CustActive[Current_Page]:=BOff;

   CustRecForm[Current_Page].Free;

  end;


end;



procedure TTradList.Find_Page1Coord;
Begin
  //PR: 05/11/2010 Changed to use new Window Position System
  // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers Record
  if Assigned(FSettings) and Assigned(MULCtrlO[1]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO[1]);
  if Assigned(FSettings) and Assigned(MULCtrlO[2]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO[2]);
end;


procedure TTradList.Store_Page1Coord(UpMode  :  Boolean);
Begin
end;



Procedure  TTradList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TTradList.Find_FormCoord;
Begin
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(MULCtrlO[0]);
  end;

  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TTradList.Store_FormCoord(UpMode  :  Boolean);


Begin
end;



procedure TTradList.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(PageControl1.Width);
  PageP.Y:=ClientHeight-(PageControl1.Height);

  ScrollAP.X:=PageControl1.Width-(ScrolBox5.Width);
  ScrollAP.Y:=PageControl1.Height-(ScrolBox5.Height);

  ScrollBP.X:=PageControl1.Width-(Panel1.Left);
  ScrollBP.Y:=PageControl1.Height-(Panel1.Height);

  Misc1P.X:=Panel1.Height-(ScrolBox6.Height);
  Misc1P.Y:=ScrolBox5.ClientHeight-(TLAccPanel.Height);

//  PanelP.X:=PageControl1.Width-(SBSPanel14.Left);
//  PanelP.Y:=Panel1.Height-(SBSPanel14.Height);


  GotCoord:=BOn;

end;

procedure TTradList.BuildMenus(CreatedNow  :  Boolean);

Begin

  CreateSubMenu(PopUpMenu2,Hist1);

  If (CreatedNow) then
  Begin
    //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
    //instead of using Windows API calls (GetMenuItemCount)
    FindMCount:=Pred(PopUpMenu3.Items.Count);
    CreateSubMenu(PopUpMenu3,Find1);
  end;

end;


procedure TTradList.PrimeButtons(PageNo  :  Integer;
                                 PWRef   :  Boolean);

Var
  LastPage  :  TTabSheet;
{$IFDEF CU}
  cBtnIsEnabled : Boolean;
{$ENDIF}
Begin
  If (PWRef) and (Assigned(CustBtnList[PageNo])) then
  Begin
    LastPage:=PageControl1.ActivePage;

    SetTabs2;

    If (PageControl1.ActivePage<>LastPage) then
      PageControl1.ActivePage:=LastPage;

    CustBtnList[PageNo].ResetButtons;
    CustBtnList[PageNo].Free;
    CustBtnList[PageNo]:=nil;
  end;

  If (CustBtnList[PageNo]=Nil) then
  Begin
    CustBtnList[PageNo]:=TVisiBtns.Create;

    try

      With CustBtnList[PageNo] do
      Case PageNo of

        0   :  Begin
            {00} PWAddVisiRec(TLCAddBtn,Syss.ExternCust or (ICEDFM=2) ,31);
            {01} PWAddVisiRec(TLCEditBtn,Syss.ExternCust,32);
            {02} PWAddVisiRec(TLCFindBtn,BOff,34);
            {03} PWAddVisiRec(TLCDelBtn,BOff,35);

            {04} PWAddVisiRec(TLCSortBtn,BOff,uaAccessSortView);

            {05} PWAddVisiRec(TLCLedBtn,BOff,33);
            {06} PWAddVisiRec(TLCHistBtn,BOff,38);
            {07} PWAddVisiRec(TLCNoteBtn,BOff,104);
            {08} PWAddVisiRec(TLCLetrBtn,BOff,39);



            {09}   AddVisiRec(TLCSABtn,(Not AnalCuStk));
            {10}   AddVisiRec(TLCTSBtn,(Not TeleSModule));



            {11} PWAddVisiRec(TLCPrnBtn,BOff,39);
                {AddVisiRec(TLCStatBtn,BOff);}
            {12} PWAddVisiRec(TLCChkBtn,BOff,36);

            {$IFDEF CU}
              // 25/01/2013 PKR ABSEXCH-13449
              // Use the custom button handler to determine visibility of the custom buttons
              formPurpose := fpCustomerList;
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn1.Tag);
              {13}  AddVisiRec(CustCuBtn1, not cBtnIsEnabled);
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn2.Tag);
              {14}  AddVisiRec(CustCuBtn2, not cBtnIsEnabled);
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn3.Tag);
              {15}  AddVisiRec(CustCuBtn3, not cBtnIsEnabled);
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn4.Tag);
              {16}  AddVisiRec(CustCuBtn4, not cBtnIsEnabled);
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn5.Tag);
              {17}  AddVisiRec(CustCuBtn5, not cBtnIsEnabled);
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn6.Tag);
              {18}  AddVisiRec(CustCuBtn6, not cBtnIsEnabled);
            {$ELSE}
              {13}  AddVisiRec(CustCuBtn1,BOn);
              {14}  AddVisiRec(CustCuBtn2,BOn);
                    // 15/01/2013 PKR ABSEXCH-13449
              {15}  AddVisiRec(CustCuBtn3,BOn);
              {16}  AddVisiRec(CustCuBtn4,BOn);
              {17}  AddVisiRec(CustCuBtn5,BOn);
              {18}  AddVisiRec(CustCuBtn6,BOn);
            {$ENDIF}


                 HideButtons;
               end;

        // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
        1   :  Begin
            {00} PWAddVisiRec(ConsumerListAddButton,         Syss.ExternCust or (ICEDFM=2), uaAddConsumer);
            {01} PWAddVisiRec(ConsumerListEditButton,        Syss.ExternCust, uaEditConsumer);
            {02} PWAddVisiRec(ConsumerListFindButton,        False, uaFindConsumer);
            {03} PWAddVisiRec(ConsumerListDeleteButton,      False, uaDeleteConsumer);
            {04} PWAddVisiRec(ConsumerListSortViewButton,    False, uaAccessSortView);
            {05} PWAddVisiRec(ConsumerListLedgerButton,      False, uaConsumerViewLedger);
            {06} PWAddVisiRec(ConsumerListHistoryButton,     False, uaConsumerViewHistory);
            {07} PWAddVisiRec(ConsumerListNotesButton,       False, uaConsumerAccessNotes);
            {08} PWAddVisiRec(ConsumerListLinksButton,       False, uaConsumerAccessLinks);

            {09} AddVisiRec(ConsumerListStockAnalysisButton, (Not AnalCuStk));
            {10} AddVisiRec(ConsumerListTeleSalesButton,     (Not TeleSModule));

            {11} PWAddVisiRec(ConsumerListPrintButton,       False, uaPrintConsumer);
            {12} PWAddVisiRec(ConsumerListCheckButton,       False, uaConsumerCheckAlloc);

            {$IFDEF CU}
              // 25/01/2013 PKR ABSEXCH-13449
              // Use the custom button handler to determine visibility of the custom buttons

              // Note that the Consumer custom buttons use the same event IDs as
              // the Customer buttons -- see CustomBtnHandler.pas
              formPurpose := fpConsumerList;

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn1.Tag);
              {13}  AddVisiRec(ConsumerListCustomButton1, not cBtnIsEnabled);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn2.Tag);
              {14}  AddVisiRec(ConsumerListCustomButton2, not cBtnIsEnabled);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn3.Tag);
              {15}  AddVisiRec(ConsumerListCustomButton3, not cBtnIsEnabled);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn4.Tag);
              {16}  AddVisiRec(ConsumerListCustomButton4, not cBtnIsEnabled);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn5.Tag);
              {17}  AddVisiRec(ConsumerListCustomButton5, not cBtnIsEnabled);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustCuBtn6.Tag);
              {18}  AddVisiRec(ConsumerListCustomButton6, not cBtnIsEnabled);
            {$ELSE}
              {13}  AddVisiRec(ConsumerListCustomButton1, True);
              {14}  AddVisiRec(ConsumerListCustomButton2, True);
                    // 15/01/2013 PKR ABSEXCH-13449
              {15}  AddVisiRec(ConsumerListCustomButton3, True);
              {16}  AddVisiRec(ConsumerListCustomButton4, True);
              {17}  AddVisiRec(ConsumerListCustomButton5, True);
              {18}  AddVisiRec(ConsumerListCustomButton6, True);
            {$ENDIF}

                 HideButtons;
               end;

        2   :  Begin
             {00} PWAddVisiRec(TLSAddBtn,(ICEDFM=2) ,41);
             {01}    PWAddVisiRec(TLSEditBtn,BOff,42);
             {02}    PWAddVisiRec(TLSFindBtn,BOff,44);
             {03}    PWAddVisiRec(TLSDelBtn,BOff,45);
             {04}    PWAddVisiRec(TLSSortBtn,BOff,uaAccessSortView);
             {05}    PWAddVisiRec(TLSLedBtn,BOff,43);
             {06}    PWAddVisiRec(TLSHistBtn,BOff,48);
             {07}    PWAddVisiRec(TLSNoteBtn,BOff,105);
             {08}    PWAddVisiRec(TLSLetrBtn,BOff,49);


             {09}      AddVisiRec(TLSSABtn,(Not AnalCuStk));
             {10}      AddVisiRec(TLSTSBtn,BOn);


             {11}    PWAddVisiRec(TLSPrnBtn,BOff,49);

                 {AddVisiRec(TLSStatBtn,BOff);}

             {12}    PWAddVisiRec(TLSChkBtn,BOff,46);

                 {$IFDEF CU}
                   // 25/01/2013 PKR ABSEXCH-13449
                   // Use the custom button handler to determine visibility of the custom buttons
                   formPurpose := fpSupplierList;

                   cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustSuBtn1.Tag);
                   {13}  AddVisiRec(CustSuBtn1, not cBtnIsEnabled);
                   
                   cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustSuBtn2.Tag);
                   {14}  AddVisiRec(CustSuBtn2, not cBtnIsEnabled);
                   
                   cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustSuBtn3.Tag);
                   {15}  AddVisiRec(CustSuBtn3, not cBtnIsEnabled);
                   
                   cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustSuBtn4.Tag);
                   {16}  AddVisiRec(CustSuBtn4, not cBtnIsEnabled);
                   
                   cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustSuBtn5.Tag);
                   {17}  AddVisiRec(CustSuBtn5, not cBtnIsEnabled);
                   
                   cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, rsAny, CustSuBtn6.Tag);
                   {18}  AddVisiRec(CustSuBtn6, not cBtnIsEnabled);
                 {$ELSE}
                   {13}  AddVisiRec(CustSuBtn1, BOn);
                   {14}  AddVisiRec(CustSuBtn2, BOn);
                         // 15/01/2013 PKR ABSEXCH-13449
                   {15}  AddVisiRec(CustSuBtn3, BOn);
                   {16}  AddVisiRec(CustSuBtn4, BOn);
                   {17}  AddVisiRec(CustSuBtn5, BOn);
                   {18}  AddVisiRec(CustSuBtn6, BOn);
                 {$ENDIF}


                 HideButtons;
               end;

      end; {Case..}

    except

      CustBtnList[PageNo].Free;

    end; {Try..}

  end;

end;

procedure TTradList.SetTabs2;
// Displays or hides the tabs based on the current user's access permissions.
Begin
  CustomerPage.TabVisible := ChkAllowed_In(30);
  // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
  ConsumerPage.TabVisible := Syss.ssConsumersEnabled and ChkAllowed_In(uaConsumerDetailsAccess);
  SupplierPage.TabVisible := ChkAllowed_In(40);
end;

procedure TTradList.FormCreate(Sender: TObject);
Var
  n  :  Byte;

  StartPanel
     :  TSBSPanel;

begin
  StartPanel := nil;
  Blank(LastBTag,Sizeof(LastBTag));
  
  PrimeButtons(0,BOff);

  BuildMenus(BOn);

  ListActive:=BOff;
  GotCoord:=BOff;

  LastCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;

  InAutoRefresh:=BOff;
  fFrmClosing:=BOff;
  fDoingDestroy:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;


  SetTabs2;

  //AnkitaP - Disable list
  ScrolBox5.Visible := False;

  //AnkitaP - DataModule stuff
  FdmTrader := TdmTraderList.Create(Self);

  ScrolBox5.HorzScrollBar.Position:=0;
  ScrolBox5.VertScrollBar.Position:=0;

  // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
  ConsumerListScrollBox.HorzScrollBar.Position := 0;
  ConsumerListScrollBox.VertScrollBar.Position := 0;

  TLSScrollBox.HorzScrollBar.Position:=0;
  TLSScrollBox.VertScrollBar.Position:=0;

  MULCtrlO[0]:=TCustList.Create(Self);
  MulCtrlO[0].Name := 'TraderList_Customer';
  // CJS 02/10/2013 - MRD 1.1 - Consumer List tab
  MULCtrlO[0].ListType := CUSTOMER_TYPE;

  PageControl1.ActivePage:=CustomerPage;

  Try

    With MULCtrlO[0] do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(TLAccPanel,TLAccLab);
          AddVisiRec(TLCompPanel,TLCompLab);
          AddVisiRec(TLBalPanel,TLBalLab);
          AddVisiRec(TLTelPanel,TLTelLab);
          AddVisiRec(TLAddr1Panel,TLAddr1Lab);        // NOTE: Due3 to extreme shiteness of EL's position
          AddVisiRec(TLAddr2Panel,TLAddr2Lab);        // saving code only the 1st 8 characters of the
          AddVisiRec(TLAddr3Panel,TLAddr3Lab);        // control name are used to 'uniquely' identify the control
          AddVisiRec(TLAddr4Panel,TLAddr4Lab);
          AddVisiRec(TLAddr5Panel,TLAddr5Lab);
          AddVisiRec(TLPCPanel,TLPCLab);
          //GS 15/03/2012 ABSEXCH-11271: added SBS panels for columns to display 'status' and 'email'
          AddVisiRec(TLEmailPanel,SBSEmail);
          AddVisiRec(TLStatusPanel, SBSStatus);

          // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[2].ExportMetadata := emtNonCurrencyAmount;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=SBSPanel1;

        end;
      except
        VisiList.Free;

      end;

      {InitSize.Y:=366;
      InitSize.X:=472;

      Self.Height:=InitSize.Y;
      Self.Width:=InitSize.X;}

      InitSize.Y:=342;
      InitSize.X:=462;

      Self.ClientHeight:=InitSize.Y;
      Self.ClientWidth:=InitSize.X;


      MDI_SetFormCoord(TForm(Self));

      //PR: 05/11/2010 Added to use new Window Positioning system
      FSettings := GetWindowSettings(Self.Name);
      if Assigned(FSettings) then
        FSettings.LoadSettings;


      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      //GS 15/03/2012 ABSEXCH-11271: adjusted MUTotCols from 9 to 11 for the +2 colums added
      MUTotCols:=11;
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


        If (n=2) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;

      Filter[1,0]:=TradeCode[BOn];

      Self.Refresh;

      Find_FormCoord;
      ListCreate;


      //Set_Buttons(SBSPanel14);
      Set_Buttons(panCustUpDown);

      AbortOnEmpty:=BOn;

      {StartList(CustF,CustCodeK,'','','',0,BOff);}

      { CJS 2012-11-02 - ABSEXCH-13653 - incorrect default Sort View }
      MULCtrlO[Current_Page].SortViewType(Current_Page);
      
      { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
      if MulCtrlO[Current_Page].SortView.LoadDefaultSortView then
        ActivateSortView
      else
        StartList(CustF,ATCodeK,TradeCode[BOn],'','',1,BOff);

      ListOfSet:=10;



    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

  ChangePage(TradListFormMode);

  {$IFDEF CU}
  try
    EntCustom2.Execute;
  except
    ShowMessage('Customisation Control Failed to initialise');
  end;

  {$ENDIF}
end;


procedure TTradList.FormActivate(Sender: TObject);
begin
  If (MULCtrlO[TradListFormMode]<>nil) then
    MULCtrlO[TradListFormMode].SetListFocus;

  ListActive:=BOn;
end;


procedure TTradList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;


begin
  If (Not fDoingDestroy) then
  Begin
    fDoingDestroy:=BOn;



    ExLocal.Destroy;

    For n:=Low(CustBtnList) to High(CustBtnList) do
      If (CustBtnList[n]<>nil) then
      Begin
        CustBtnList[n].Free;
        CustBtnList[n]:=nil;
      end;


  end;
end;




procedure TTradList.Page1Create(Sender: TObject; PageNo: Integer);
Var
  n  :  Byte;
  SubType: Char;
begin
  // CJS 06/09/2013 - MRD1.1 - Consumer tab
  PrimeButtons(PageNo, BOff);

  MULCtrlO[PageNo] := TCustList.Create(Self);

  Try

    case PageNo of
      1: // Consumers
    Begin
        MulCtrlO[PageNo].Name := 'TraderList_Consumer';
        MULCtrlO[PageNo].SortViewType(1);  // Consumer
        // CJS 2013-10-02  MRD 1.1 - Consumer List tab
        MULCtrlO[PageNo].ListType := CONSUMER_TYPE;

        with MULCtrlO[PageNo].VisiList do
        begin
          Try
            AddVisiRec(ConsumerListCodePanel,         ConsumerListCodeLabel        );
            AddVisiRec(ConsumerListCompanyPanel,      ConsumerListCompanyLabel     );
            AddVisiRec(ConsumerListBalancePanel,      ConsumerListBalanceLabel     );
            AddVisiRec(ConsumerListTelephonePanel,    ConsumerListTelephoneLabel   );
            AddVisiRec(ConsumerListAddressLine1Panel, ConsumerListAddressLine1Label);
            AddVisiRec(ConsumerListAddressLine2Panel, ConsumerListAddressLine2Label);
            AddVisiRec(ConsumerListAddressLine3Panel, ConsumerListAddressLine3Label);
            AddVisiRec(ConsumerListAddressLine4Panel, ConsumerListAddressLine4Label);
            AddVisiRec(ConsumerListAddressLine5Panel, ConsumerListAddressLine5Label);
            AddVisiRec(ConsumerListPostCodePanel,     ConsumerListPostCodeLabel    );
            AddVisiRec(ConsumerListEmailPanel,        ConsumerListEmailLabel       );
            AddVisiRec(ConsumerListStatusPanel,       ConsumerListStatusLabel      );

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            MULCtrlO[PageNo].ColAppear^[2].ExportMetadata := emtNonCurrencyAmount;

            // Copy the details from the Customer list
            Match_VisiList(MULCtrlO[0].VisiList, MULCtrlO[PageNo].VisiList);

            LabHedPanel := ConsumerListHeaderPanel;

          except
            MULCtrlO[PageNo].VisiList.Free;
          end;
        end;
        MULCtrlO[PageNo].Parent := ConsumerListCodePanel.Parent;
      end;

      2: // Suppliers
      begin
        MulCtrlO[PageNo].Name := 'TraderList_Supplier';
        MULCtrlO[PageNo].SortViewType(2);  // Supplier
        // CJS 2013-10-02  MRD 1.1 - Consumer List tab
        MULCtrlO[PageNo].ListType := SUPPLIER_TYPE;
        With MULCtrlO[PageNo].VisiList do
        Begin
          Try
            AddVisiRec(TLSAccPanel, TLSAccLab);
            AddVisiRec(TLSCompPanel, TLSCompLab);
            AddVisiRec(TLSBalPanel, TLSBalLab);
            AddVisiRec(TLSTelPanel, TLSTelLab);
            AddVisiRec(TLSAdd1Pan, TLSAdd1Lab);
            AddVisiRec(TLSAdd2Pan, TLSAdd2Lab);
            AddVisiRec(TLSAdd3Pan, TLSAdd3Lab);
            AddVisiRec(TLSAdd4Pan, TLSAdd4Lab);
            AddVisiRec(TLSAdd5Pan, TLSAdd5Lab);
            AddVisiRec(TLSPCPanel, TLSPCLab);

            //GS 15/03/2012 ABSEXCH-11271: added SBS panels as columns, to display 'status' and 'email'
            AddVisiRec(TLSEmailPanel,SBSSEmail);
            AddVisiRec(TLSStatusPanel, SBSSStatus);

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            MULCtrlO[PageNo].ColAppear^[2].ExportMetadata := emtNonCurrencyAmount;

            // Copy the details from the Customer list
            Match_VisiList(MULCtrlO[0].VisiList, MULCtrlO[PageNo].VisiList);

            LabHedPanel:=TLHedPanel;
          except
            MULCtrlO[PageNo].VisiList.Free;
          end;
        end;
        MULCtrlO[PageNo].Parent:=TLSAccPanel.Parent;
        end;
      end;

    With MULCtrlO[PageNo] do
    Begin
      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=TLSAccPanel.Color;
      //GS 15/03/2012 ABSEXCH-11271: adjusted MUTotCols from 9 to 11 for the +2 colums added
      MUTotCols:=11;
      Font:=TLSAccPanel.Font;
      LinkOtherDisp:=Bon;

      WM_ListGetRec:=WM_CustGetRec;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n=2) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;

      // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
      SubType := 'S';
      if (PageNo = CONSUMER_TYPE) then
        SubType := 'U';

      Filter[1, 0] := SubType; // TradeCode[BOff];

      Self.Refresh;

      Find_Page1Coord;
      ListCreate;

      if (PageNo = CONSUMER_TYPE) then
        Set_Buttons(ConsumerListScrollBar)
      else
      Set_Buttons(TLSCtrlPanel);

      AbortOnEmpty:=BOn;

      { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
      if MulCtrlO[PageNo].SortView.LoadDefaultSortView then
        ActivateSortView
      else
        // CJS 06/09/2013 - MRD 1.1 - Consumer List tab - amended StartList() to
        // use the new SubType + LongAcCode index (CustACCodeK) for Consumers
        if (PageNo = CONSUMER_TYPE) then
          StartList(CustF, CustLongACCodeK, SubType, '', '', 1, BOff)
        else
          StartList(CustF, ATCodeK, SubType, '', '', 1, BOff);

    end; {With}


    FormResize(Sender);
  Except
    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo] := Nil;
  end;

  MDI_UpdateParentStat;

end;

Procedure TTradList.SetDeleteStat(CPage  :  Integer;
                                  CCode  :  Str10);
Var
  CanDelete  :  Boolean;

Begin

  CanDelete:=Ok2DelAcc(CCode);

  {$IFDEF JC}
    {$IFDEF JAP}
      {$IFNDEF SOPDLL}
         If (CanDelete and JBCostOn) then
           CanDelete:=(Check_AnyEmployee(CCode)='');

      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  Case Current_Page of

    CUSTOMER_TYPE :
      Begin
            TLCDelBtn.Enabled:=CanDelete;

            If (TeleSModule) then
              // CJS 21/05/2010 - Changed Telesales button to only disable on 'Closed' status
              TLCTSBtn.Enabled:=(Cust.AccStatus<>3)
          end;
    // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
    CONSUMER_TYPE :
      begin
        ConsumerListDeleteButton.Enabled := CanDelete;
        if TeleSModule then
          ConsumerListTeleSalesButton.Enabled := (Cust.AccStatus <> 3);
      end;
    SUPPLIER_TYPE : TLSDelBtn.Enabled:=CanDelete;

  end; {Case..}

end;


Procedure TTradList.WMCustGetRec(Var Message  :  TMessage);
var
  CustCode: string[6];
  SubType: Char;
Begin
  SubType := #0;

  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of


      0,169
         :  Begin

              Display_Account(0);

            end;

      1  :  PostMessage(Self.Handle,WM_FormCloseMsg,1000+WParam,0); {* This was placed here to stop the mouse up event from being corrupted *}


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

    // CJS 24/09/2013 - MRD1.1.14 - Trader List - Consumers Record
    100,
    101,
    102  :  With MULCtrlO[WParam-100] do
            Begin
              AddNewRow(MUListBoxes[0].Row,(LParam=1));
            end;

    170  :  TLCPrnBtnClick(nil);
    175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    177  :  Begin
              PrimeButtons(Current_Page,BOn);

              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);

            end;

    
    // CJS 24/09/2013 - MRD1.1.14 - Trader List - Consumers Record
    200,
    201,
    202  :  Begin
              CustActive[WParam-200]:=Boff;
              CustRecForm[WParam-200]:=nil;

            end;

    // CJS 24/09/2013 - MRD1.1.14 - Trader List - Consumers Record
    300,
    301,
    302  :  With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;


    // CJS 24/09/2013 - MRD1.1.14 - Trader List - Consumers Record
    400,
    401,
    402  :  Begin
              {$IFDEF Ltr}
                LettersActive[WParam-400]:=Boff;
                LettersForm[WParam-400]:=nil;
              {$ENDIF}
            end;


    // CJS 06/09/2013 - MRD 1.1 - Consumer Tab list - amended Find to include
    // support for Consumers, and to use SubType field instead of CustSupp field
    3000,
    3001,
    3002  : With MULCtrlO[WParam-3000] do
            Begin
              case WParam of
                3000: SubType := 'C';
                3001: SubType := 'U';
                3002: SubType := 'S';
              end;
              if SortView.Enabled then
                Find_OnActualList(CustF, SubType + Cust.CustCode, CustACCodeK)
              else
                Find_OnList(SubType + Cust.CustCode, CustACCodeK);

              With MUListBoxes[0] do
                If (CanFocus) then
                  SetFocus;
            end;

    // CJS 06/09/2013 - MRD 1.1 - Consumer Tab list - amended Find to include
    // support for Consumers, and to use SubType field instead of CustSupp field
    3100,
    3101,
    3102  : With MULCtrlO[WParam-3100] do
            Begin
              InAutoRefresh:=BOn;
              try
                case WParam of
                  3100: SubType := 'C';
                  3101: SubType := 'U';
                  3102: SubType := 'S';
                end;
                if SortViewEnabled then
                begin
                  CustCode := SubType + Cust.CustCode;
                  StartList(SortTempF, STFieldK, FullNomKey(SortView.ListID), '', '', 0, BOff);
                  Find_OnActualList(CustF, CustCode, CustACCodeK);
                  MUListBox1Click(MUListBoxes[0]);
                  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
                    KeyRef was previously outside this 'if' and was being set
                    to the TraderCode value ('C' or 'S') instead of the Sort
                    List ID. }
                  KeyRef := FullNomKey(SortView.ListID);
                end
                else if (LineOk(SetCheckKey)) then
                Begin
                  // CJS 2013-10-02  MRD 1.1 - Consumer List tab
                  if MULCtrlO[Current_Page].ListType = CONSUMER_TYPE then
                    StartList(CustF, CustLongACCodeK, SubType + Cust.acLongAcCode, '', '', 1, BOff)
                  else
                    StartList(CustF, ATCodeK, SubType + Cust.CustCode, '', '', 1, BOff);

                  MUListBox1Click(MUListBoxes[0]);
                  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
                  KeyRef := SubType;
                end;


                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;
              finally
                InAutoRefresh:=BOff;
              end;
            end;


    end; {Case..}

    If (WParam in [1,2]) then
     SetDeleteStat(Current_Page,Cust.CustCode);

  end;
  Inherited;
end;


procedure TTradList.SendObjectCC;

Begin
  SendToObjectCC(Cust.CustCode,0);
end;

Procedure TTradList.WMFormCloseMsg(Var Message  :  TMessage);
var
  PageNo: Integer;
Begin

  With Message do
  Begin

    Case WParam of
      1001  : {* This handling was placed here so to give the list a chance to see the mouse up event *}

            Begin
              PageNo := Current_Page;
              If (CustRecForm[PageNo]<>nil) and (CustActive[PageNo]) then
              With CustRecForm[PageNo] do
              Begin
                If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Cust.CustCode<>ExLocal.LCust.CustCode) and (AllocateOk(BOff)) then
                Begin
                  If (InOSFilt) then {* When in ledger filtmode, mouseup event is destryoed, so force it off here *}

                    Self.MULCtrlO[Self.Current_Page].AutoRepeat1:=BOff;
                  // HV 07/12/2017 ABSEXCH-19386: Implements anonymisation behaviour for trader
                  ListScanningOn := True;
                  AnonymisationON := GDPROn and (Cust.acAnonymisationStatus in [asPending, asAnonymised]);
                  ShowLink;
                end;
              end;

              SendObjectCC;

              {$IFDEF Ltr}
                { Check for link to letters }
                If Assigned(LettersForm[Current_Page]) And LettersActive[Current_Page] Then
                  With LettersForm[Current_Page] Do Begin
                    If (WindowState <> wsMinimized) and (Cust.CustCode <> ExLocal.LCust.CustCode) Then Begin
                      {ShowLink(True);}

                      // CJS 2013-09-30 - MRD1.1.14 - Consumers Record - changed
                      // LoadLettersFor to use SubType instead of CustSupp
                      LoadLettersFor (Cust.CustCode,
                                      Cust.CustCode,
                                      Trim(Cust.CustCode),
                                      Cust.acSubType,
                                      @Cust, Nil, Nil, Nil, Nil);
                    End; { If }
                  End; { With }
              {$ENDIF}
            End; { 1 }


    end; {Case..}

  end; {With..}

end; {Proc..}



Procedure TTradList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

procedure TTradList.TLAccPanelMouseUp(Sender: TObject;
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

    // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers
    Case Current_Page of
      CUSTOMER_TYPE : BarPos := ScrolBox5.HorzScrollBar.Position;
      CONSUMER_TYPE : BarPos := ConsumerListScrollBox.HorzScrollBar.Position;
      SUPPLIER_TYPE : BarPos := TLSScrollBox.HorzScrollBar.Position;
    end;

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;


procedure TTradList.TLAccLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
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

procedure TTradList.TLAccLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);
    NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
  end;

end;

procedure TTradList.FormResize(Sender: TObject);
Var
  n          :  Byte;
  ActiveScrollBox : TScrollBox;
  ActiveListBtnPanel: TSBSPanel;
  ReloadData : Boolean;
begin
  If (GotCoord) and (Not (fDoingDestroy or fDoingClose)) then
  Begin
    LockWindowUpdate(Handle);
    Try
      MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

      Self.HorzScrollBar.Position:=0;
      Self.VertScrollBar.Position:=0;

      // Note: Using PageControl1.Left as a generic divider measurement

      // Page Control
      //PageControl1.Width:=ClientWidth-PageP.X;
      //PageControl1.Height:=ClientHeight-PageP.Y;
      PageControl1.Width := Self.ClientWidth - (2 * PageControl1.Left) + 1;
      PageControl1.Height := Self.ClientHeight - (2 * PageControl1.Top) + 1;

      // Customer List ------------------------------------------

      // Button Panel
      Panel1.Top := PageControl1.Left;
      Panel1.Height := CustomerPage.ClientHeight - (2 * Panel1.Top);
      Panel1.Left := CustomerPage.ClientWidth - Panel1.Width - PageControl1.Left;

      // Buttons scroll-box in button panel
      ScrolBox6.Height := Panel1.Height - ScrolBox6.Top - 1;

      // List scroll up/down panel
      panCustUpDown.Left := Panel1.Left - panCustUpDown.Width - PageControl1.Left;

      // List Scroll Box
      ScrolBox5.Width := panCustUpDown.Left - ScrolBox5.Left;
      ScrolBox5.Height := CustomerPage.ClientHeight - PageControl1.Left - ScrolBox5.Top;

      // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers
      // Consumer List ------------------------------------------

      // Button Panel
      ConsumerListButtonPanel.Left := Panel1.Left;
      ConsumerListButtonPanel.Top := Panel1.Top;
      ConsumerListButtonPanel.Height := Panel1.Height;

      // Buttons scroll-box in button panel
      ConsumerListButtonBox.Height := TPSCtrlPanel.Height - TPSScrollBox.Top - 1;

      // List scroll up/down panel
      ConsumerListScrollBar.Left := panCustUpDown.Left;

      // List Scroll Box
      ConsumerListScrollBox.Width := TLSCtrlPanel.Left - TLSScrollBox.Left;
      ConsumerListScrollBox.Height := SupplierPage.ClientHeight - PageControl1.Left - TLSScrollBox.Top;

      // Supplier List ------------------------------------------

      // Button Panel
      TPSCtrlPanel.Left := Panel1.Left;
      TPSCtrlPanel.Top := Panel1.Top;
      TPSCtrlPanel.Height := Panel1.Height;

      // Buttons scroll-box in button panel
      TPSScrollBox.Height := TPSCtrlPanel.Height - TPSScrollBox.Top - 1;

      // List scroll up/down panel
      TLSCtrlPanel.Left := panCustUpDown.Left;

      // List Scroll Box
      TLSScrollBox.Width := TLSCtrlPanel.Left - TLSScrollBox.Left;
      TLSScrollBox.Height := SupplierPage.ClientHeight - PageControl1.Left - TLSScrollBox.Top;

      // Resize columns in lists --------------------------------
      // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers
      For n := CUSTOMER_TYPE to SUPPLIER_TYPE Do
      Begin
        If Assigned(MULCtrlO[n]) Then
        Begin
          Case N Of
            CUSTOMER_TYPE:
              Begin
                  ActiveScrollBox := ScrolBox5;
                  ActiveListBtnPanel := panCustUpDown;
              End;
            CONSUMER_TYPE:
              begin
                ActiveScrollBox    := ConsumerListScrollBox;
                ActiveListBtnPanel := ConsumerListScrollBar;
              end;
            SUPPLIER_TYPE:
              Begin
                  ActiveScrollBox := TLSScrollBox;
                  ActiveListBtnPanel := TLSCtrlPanel;
              End;
          Else
            ActiveScrollBox := NIL;
            ActiveListBtnPanel := NIL;
          End; // Case N

          If Assigned(ActiveScrollBox) And Assigned(ActiveListBtnPanel) then
          Begin
            With MULCtrlO[n].VisiList Do
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
            ActiveListBtnPanel.Height := CustomerPage.ScreenToClient(ActiveScrollBox.ClientToScreen(Point(0,ActiveScrollBox.ClientHeight))).Y - ActiveListBtnPanel.Top;

            MULCtrlO[n].ReFresh_Buttons;
            If ReloadData Then MULCtrlO[n].RefreshAllCols;
          End; // If Assigned(ActiveScrollBox) And Assigned(ActiveListBtnPanel)
        End; // If Assigned(MULCtrlO[n])
      End; // For n

      MULCtrlO[Current_Page].LinkOtherDisp:=BOn;

      NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
    Finally
      LockWindowUpdate(0);
    End; // Try..Finally
  end; {If time to update}
end; {Proc..}

procedure TTradList.TLCloseBtnClick(Sender: TObject);
begin
  If (not fDoingClose) then
  begin
   if (Not MULCtrlO[Current_Page].InListFind)  then
    Close;
  end;
end;

procedure TTradList.SetFormProperties;
Begin
  //PR: 05/11/2010 Changed to use new Window Position System
  if Assigned(FSettings) and Assigned(MULCtrlO[Current_Page]) then
    if FSettings.Edit(MULCtrlO[Current_Page], MULCtrlO[Current_Page]) = mrOK then
      NeedCUpdate := True;
end;

procedure TTradList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TTradList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TTradList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  // Make the Custom MENU item captions match the corresponding Custom BUTTON captions.
  // Also hide menu items for buttons that aren't visible.
  Case Current_Page of
    CUSTOMER_TYPE:
      Begin
            Custom1.Caption := CustCuBtn1.Caption;
            custom1.Visible := CustCuBtn1.Visible;

            Custom2.Caption := CustCuBtn2.Caption;
            custom2.Visible := CustCuBtn2.Visible;

            // 15/01/2013  PKR   ABSEXCH-13449/38
            Custom3.Caption := CustCuBtn3.Caption;
            custom3.Visible := CustCuBtn3.Visible;

            Custom4.Caption := CustCuBtn4.Caption;
            custom4.Visible := CustCuBtn4.Visible;

            Custom5.Caption := CustCuBtn5.Caption;
            custom5.Visible := CustCuBtn5.Visible;

            Custom6.Caption := CustCuBtn6.Caption;
            custom6.Visible := CustCuBtn6.Visible;
          end;
    // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
    CONSUMER_TYPE:
      begin
        Custom1.Caption := ConsumerListCustomButton1.Caption;
        custom1.Visible := ConsumerListCustomButton1.Visible;

        Custom2.Caption := ConsumerListCustomButton2.Caption;
        custom2.Visible := ConsumerListCustomButton2.Visible;

        Custom3.Caption := ConsumerListCustomButton3.Caption;
        custom3.Visible := ConsumerListCustomButton3.Visible;

        Custom4.Caption := ConsumerListCustomButton4.Caption;
        custom4.Visible := ConsumerListCustomButton4.Visible;

        Custom5.Caption := ConsumerListCustomButton5.Caption;
        custom5.Visible := ConsumerListCustomButton5.Visible;

        Custom6.Caption := ConsumerListCustomButton6.Caption;
        custom6.Visible := ConsumerListCustomButton6.Visible;
        end;
    SUPPLIER_TYPE:
      Begin
            Custom1.Caption := CustSuBtn1.Caption;
            custom1.Visible := CustSuBtn1.Visible;

            Custom2.Caption := CustSuBtn2.Caption;
            custom2.Visible := CustSuBtn2.Visible;

            // 15/01/2013  PKR   ABSEXCH-13449/38
            Custom3.Caption := CustSuBtn3.Caption;
            custom3.Visible := CustSuBtn3.Visible;

            Custom4.Caption := CustSuBtn4.Caption;
            custom4.Visible := CustSuBtn4.Visible;

            Custom5.Caption := CustSuBtn5.Caption;
            custom5.Visible := CustSuBtn5.Visible;

            Custom6.Caption := CustSuBtn6.Caption;
            custom6.Visible := CustSuBtn6.Visible;
          end;
  end; {case..}

  With PopUpMenu1 do
  Begin

    For n:=0 to Items.Count-1 do
    With Items[n] do
      If (Tag=1) then
        Visible:=(N3.Tag=99);

  end;{With..}

  With CustBtnList[Current_Page] do
  Begin
    Delete1.Enabled:=IdButton(3).Enabled;

    SetMenuFBtn(Add1,0);
    SetMenuFBtn(Edit1,1);
    SetMenuFBtn(Find1,2);
    SetMenuFBtn(Delete1,3);
    SetMenuFBtn(SortView1, 4);
    if not MulCtrlO[Current_Page].SortView.Enabled then
    begin
      RefreshView2.Visible := False;
      CloseView2.Visible := False;
      N7.Visible := False;
    end
    else
    begin
      RefreshView2.Visible := True;
      CloseView2.Visible := True;
      N7.Visible := True;
    end;

    SetMenuFBtn(Ledger1,5);
    SetMenuFBtn(Notes1,6);

    StkAnal1.Visible:=BOn;
    StkAnal1.Enabled:=BOn;

    SetMenuFBtn(StkAnal1,9);

    TeleSales1.Visible:=BOn;
    TeleSales1.Enabled:=BOn;

    SetMenuFBtn(TeleSales1,10);

    SetMenuFBtn(Custom1,13);
    SetMenuFBtn(Custom2,14);
    // 29/01/2013 PKR ABSEXCH-13449
    SetMenuFBtn(Custom3,15);
    SetMenuFBtn(Custom4,16);
    SetMenuFBtn(Custom5,17);
    SetMenuFBtn(Custom6,18);

  end; {With..}

end;

procedure TTradList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin
    N3.Tag:=99*Mode;

    PopUp(X,Y);

    N3.Tag:=0;
  end;


end;


{ == Procedure to Send Message to Get Record == }

Procedure TTradList.Send_ParentMsg(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=1;

  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TTradList.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    Send_ParentMsg(0); {Form closing..}

  //PR: 05/11/2010 Changed to use new Window Position System
    if Assigned(FSettings) and NeedCUpdate then
    begin
      // Customers
      if Assigned(MULCtrlO[0]) then
        FSettings.ParentToSettings(MULCtrlO[0], MULCtrlO[0]);

      // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
      // Consumers
      if Assigned(MULCtrlO[1]) then
        FSettings.ParentToSettings(MULCtrlO[1], MULCtrlO[1]);

      // Suppliers
      if Assigned(MULCtrlO[2]) then
        FSettings.ParentToSettings(MULCtrlO[2], MULCtrlO[2]);

      FSettings.WindowToSettings(Self);
      FSettings.SaveSettings(StoreCoord);
      FSettings := nil;
    end;
    {.$IFDEF XXXXX} {*EN430}
      For n:=0 to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
        If (MULCtrlO[n]<>nil) then
        Begin
          MULCtrlO[n].Destroy;
          MULCtrlO[n]:=nil;
        end;

    {.$ENDIF}
  end;

end;

Function TTradList.CheckListFinished  :  Boolean;

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


procedure TTradList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n  :  Byte;

begin

  If (Not fFrmClosing) and (Not fDoingDestroy) then
  Begin
    fFrmClosing:=BOn;

    Try
      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;


      If (CanClose) then
        CanClose:=Not InAutoRefresh;

      If (CanClose) then
      Begin
        ScrolBox5.HorzScrollBar.Position:=0;
        ScrolBox5.VertScrollBar.Position:=0;

        // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
        ConsumerListScrollBox.HorzScrollBar.Position := 0;
        ConsumerListScrollBox.VertScrollBar.Position := 0;

        TLSScrollBox.HorzScrollBar.Position:=0;
        TLSScrollBox.VertScrollBar.Position:=0;

        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
          Store_FormCoord(Not SetDefault);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;




procedure TTradList.PageControl1Change(Sender: TObject);
Var
  n,
  NewIndex  :  Integer;
begin
  SetHelpContextIDsForPage; // NF: 10/04/06

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers
      If (MULCtrlO[NewIndex] = nil) then
        Page1Create(Parent, NewIndex);

      Case NewIndex of
      { TODO: ??? }
        0, 1 : If (Hist1.Count < 2) then
                BuildMenus(Boff);
        2 : DeleteSubMenu(Hist1);
      end; {Case..}

      SetCheckedMenuItems(Find1,FindMCount,LastBTag[NewIndex]);

      If (MULCtrlO[NewIndex]<>nil) and (ListActive) then
        MULCtrlO[NewIndex].SetListFocus;
    end;

end;

procedure TTradList.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

begin

  Release_PageHandle(Sender);

end;

Procedure TTradList.ChangePage(NewPage  :  Integer);


Begin
  SetHelpContextIDsForPage; // NF: 10/04/06

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    Case NewPage of

      { CJS 05/09/2013 - MRD1.1 - Consumers - Reorganised tab-sheets, added
                                  Consumers tab, and removed TabSheet4 }
      CUSTOMER_TYPE : ActivePage := CustomerPage;
      CONSUMER_TYPE : ActivePage := ConsumerPage;
      SUPPLIER_TYPE : ActivePage := SupplierPage;

    end; {Case..}

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


Function TTradList.KeyPressOk  :  Boolean;

Begin
  If (Assigned(MULCtrlO[Current_Page])) then
    Result:=Not MULCtrlO[Current_Page].InListFind
  else
    Result:=BOn;
end;

procedure TTradList.TLCAddBtnClick(Sender: TObject);

Var
  AddMode,
  EditMode,
  DelMode,
  NoteMode,
  HistMode,
  LedgMode   :  Boolean;

begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin

    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);

    AddMode := ((Sender = TLCAddBtn) or (Sender = ConsumerListAddButton) or (Sender = TLSAddBtn));

    if AddMode or MULCtrlO[Current_Page].ValidLine then
    begin
      // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
      EditMode := ((Sender=TLCEditBtn) or (Sender = ConsumerListEditButton) or
                   (Sender=TLSEditBtn) or (Sender=Edit1));

      DelMode := ((Sender=TLCDelBtn) or (Sender=TLSDelBtn) or
                  (Sender = ConsumerListDeleteButton) or (Sender=Delete1));

      NoteMode := ((Sender=TLCNoteBtn) or (Sender=TLSNoteBtn) or
                   (Sender = ConsumerListNotesButton) or (Sender=Notes1));

      LedgMode := ((Sender=TLCLedBtn) or (Sender=TLSLedBtn) or
                   (Sender = ConsumerListLedgerButton) or (Sender=Ledger1));

    {$B-}
      If (Not DelMode) or (Ok2DelAcc(Cust.CustCode)) then
        Display_Account(1+(1*Ord(EditMode))+(2*Ord(DelMode))+(4*Ord(NoteMode))+(5*Ord(LedgMode)));
    {$B+}
    end;
  end;
end;


procedure TTradList.TLCSABtnClick(Sender: TObject);
begin
  {$IFDEF STK}

  If (Not MULCtrlO[Current_Page].InListFind) and MULCtrlO[Current_Page].ValidLine then
  Begin

    With MULCtrlO[Current_Page] do
      GetSelRec(BOn);

    Display_Account(TComponent(Sender).Tag);
  end;

  {$ENDIF}

end;


procedure TTradList.TLCFindAccount(Sender: TObject);

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
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        {ManualClose:=BOn;}

        Ctrl_GlobalFind(Self,ReturnCtrl,Current_Page);

      end;
    end; {If in list find..}

  {$ENDIF}
end;


procedure TTradList.TLCFindBtnClick(Sender: TObject);


Var
  ListPoint  :  TPoint;

begin
  {SS 29/03/2016 2016-R2
   ABSEXCH-14996:Consumer trader list filter on balance.
   -Added a condition (FiltBal1.Tag = LastBTag[Current_Page],(FindAc1.Tag = LastBTag[Current_Page]) (to If condition) to show Popup even if validline return zero.}
  If (Sender is TButton) and
     (Not MULCtrlO[Current_Page].InListFind) and
     ((MULCtrlO[Current_Page].ValidLine) or (FiltBal1.Tag = LastBTag[Current_Page]) or (FindAc1.Tag = LastBTag[Current_Page]))  then
  Begin

    GetCursorPos(ListPoint);
    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;

    SetCheckedPopUpMenu(PopUpMenu3,FindMCount,LastBTag[Current_Page]);

    PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
  end;

end;


procedure TTradList.FindAc1Click(Sender: TObject);
Var
  BTagNo,
  PageNo  :  Integer;
  mbRet   :  Word;

begin
   If (Sender is TMenuItem) then
     With TMenuItem(Sender) do
     Begin
       BTagNo:=Tag;
       PageNo:=Current_Page;

       Case BTagNo of
         0  :  TLCFindAccount(Sender);
         1,2
            :  Begin
                 MULCtrlO[PageNo].SetNewFilter(BTagNo);
                 SetCheckedMenuItems(Find1,FindMCount,BTagNo);

               end;
       end; {Case..}

       
       LastBTag[PageNo]:=BTagNo;

     end; {With..}
end;


procedure TTradList.TLCHistBtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin

  If (KeyPressOk) and MULCtrlO[Current_Page].ValidLine then
  Begin

    If (Current_Page in [CUSTOMER_TYPE, CONSUMER_TYPE]) then
    Begin
      If (Sender<>Hist1) then
      Begin
        With TWinControl(Sender) do
        Begin
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint:=ClientToScreen(ListPoint);

        end;

        PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
      end;
    end
    else
      Bal1Click(Bal1);
  end;
end;



procedure TTradList.Bal1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) and (KeyPressOk) then
  With TMenuItem(Sender) do
  Begin
    With MULCtrlO[Current_Page] do
       GetSelRec(BOff);
       
    Display_Account(Tag+6);
  end;
end;


procedure TTradList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TTradList.TLCLetrBtnClick(Sender: TObject);
Var
  CPage : Integer;
begin
  If (KeyPressOk) and MULCtrlO[Current_Page].ValidLine then
  Begin

  {$IFDEF Ltr}

    { Take copy of page }
    CPage := Current_Page;

    { Create form if not already created }
    If Not Assigned (LettersForm[CPage]) Then Begin
      { Create letters form }
      LettersForm[CPage] := TLettersList.Create (Self);
    End; { If }

    Try
      { mark form as active }
      LettersActive[CPage] := BOn;

      { Get customer record }
        MULCtrlO[Current_Page].GetSelRec(BOff);

      With LettersForm[CPage] Do Begin
        { Display form }
        WindowState := wsNormal;
        Show;

        // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers - amended to
        // use SubType instead of CustSupp flag
        LoadLettersFor (Cust.CustCode,
                        Cust.CustCode,
                        Trim(Cust.CustCode),
                        Cust.acSubType,
                        @Cust, Nil, Nil, Nil, Nil);
      End; { With }
    Except
     LettersActive[Current_Page] := BOff;
     LettersForm[Current_Page].Free;
    End;
  {$ENDIF}
  end;
end;


procedure TTradList.TLCPrnBtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
  PrintMode  :  Byte;
  Odisabled  :  Boolean;
begin                              
  {$IFDEF FRM}
  //RJ 17/02/2016 2016-R1 ABSEXCH-17035: Check user Permission  before print actions.

  Odisabled := not TLCPrnBtn.Visible;
  if Current_Page = CONSUMER_TYPE then
    Odisabled := not ConsumerListPrintButton.Visible
  else if Current_Page = SUPPLIER_TYPE then
    Odisabled := not TLSPrnBtn.Visible;

  if Odisabled then
  begin
    Showmessage('You are not authorised to print the account');
    Exit;
  end;
  If (KeyPressOk) and MULCtrlO[Current_Page].ValidLine then
  With ExLocal do
    With MulCtrlO[Current_Page] do
              Begin
                GetSelRec(BOff);
                AssignFromGlobal(CustF);

                If (Sender is TButton) then
                With TWinControl(Sender) do
                Begin
                  ListPoint.X:=1;
                  ListPoint.Y:=1;

                  ListPoint:=ClientToScreen(ListPoint);
                end
                else
                Begin
                  GetCursorPos(ListPoint);
                  With ListPoint do
                  Begin
                    X:=X-50;
                    Y:=Y-15;
                  end;
                end;

                PrintMode:=Get_CustPrint(Self,ListPoint,1);

                If (PrintMode>0) then
                  Control_DefProcess(PrintMode,
                                     InvF,InvCustK,
                                     FullCustType(LCust.CustCode,LCust.CustSupp),
                                     ExLocal,
                                     BOn);
              end;

  {$ENDIF}

end;

procedure TTradList.TLCChkBtnClick(Sender: TObject);
// CJS 2012-03-31 - ABSEXCH-12203 - Check All Accounts, SQL improvements
var
  Confirm: Boolean;
//  Unallocate: Boolean;
begin
  {$IFDEF POST}
  If (KeyPressOk) and MULCtrlO[Current_Page].ValidLine then
  With MulCtrlO[Current_Page] do
  Begin
    GetSelRec(BOff);

    If (Not Check_AccountEdit(Cust.CustCode)) then
    // CJS 09/03/2011 v6.7 ABSEXCH-10901 - CustSupp parameter added
    // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers
    begin
      // CJS 2015-03-31 - ABSEXCH-16163 - Check All Accounts, SQL improvements
      // MH 14/08/2015 2015-R1 ABSEXCH-16761: Removed Unallocate question from Check on Trader List
      //Confirm := ConfirmCheckAccountAndUnallocate(Cust.CustSupp, Cust.CustCode, Unallocate);
      Confirm := ConfirmCheckAccount(Cust.CustCode);
      if Confirm then
      begin
        //PR: 01/06/2017 ABSEXCH-18683 v2017 R1 Check for running processes
        if not GetProcessLock(plCheckAccounts) then
         EXIT;

          // Under SQL, provided the user has not opted to unallocate, we can
          // use the SQL-optimised version, otherwise we have to use the original
          // version.
          if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLCheckAllAccounts then
            CheckSingleAccount(self, Cust.CustCode, False)
          else
            AddCheckCust2Thread(Self, Cust.CustCode, False, True, False, Cust.acSubType);
        end; //if Confirm
    end;
  end;
  {$ENDIF}
end;


procedure TTradList.CustCuBtn1Click(Sender: TObject);
Var
  PageNo  :  Integer;
  // 17/01/2013 PKR ABSEXCH-13449
  customButtonNumber : integer;
begin
  PageNo:=Current_Page;

  {$IFDEF CU}
    If (Assigned(MULCtrlO[PageNo])) then
    With MULCtrlO[PageNo],ExLocal do
    Begin
      If (ValidLine) then
      Begin
        LCust:=Cust;

        // 17/01/2013 PKR ABSEXCH-13449
        // The button or menu item Tag property is set to the button number.
        customButtonNumber := -1;
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;

        // CJS 06/09/2013 - MRD 1.1 - Consumer List tab
        if PageNo = CUSTOMER_TYPE then
          formPurpose := fpCustomerList
        else if PageNo = CONSUMER_TYPE then
          formPurpose := fpConsumerList
        else
          formPurpose := fpSupplierList;
            
        custBtnHandler.CustomButtonClick(formPurpose,
                                         PageNo,
                                         rsAny,
                                         customButtonNumber,
                                         ExLocal);

//        ExecuteCustBtn(1000,((11+(10*PageNo))*Ord((Sender=CustCuBtn1) or (Sender=Custom1) or (Sender=CustSuBtn1)))+
//                      ((12+(10*PageNo))*Ord((Sender=CustCuBtn2) or (Sender=Custom2) or (Sender=CustSuBtn2))), ExLocal);

      end;
    end; {With..}
  {$ENDIF}
end;

procedure TTradList.SetHelpContextIDsForPage; // NF: 10/04/06
begin
  {$IFDEF LTE}
    if PageControl1.ActivePage = CustomerPage then
    begin
      // Customers
      PageControl1.ActivePage.HelpContext := 62;
    end else
    begin
      // Suppliers
      PageControl1.ActivePage.HelpContext := 5062;
    end;

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;

    // Customer Buttons
    TLCAddBtn.HelpContext := 76;
    TLCEditBtn.HelpContext := 75;
    TLCFindBtn.HelpContext := 72;
    TLCDelBtn.HelpContext := 77;
    TLCLedBtn.HelpContext := 78;
    TLCHistBtn.HelpContext := 79;
    TLCNoteBtn.HelpContext := 80;
    TLCLetrBtn.HelpContext := 81;
    TLCSABtn.HelpContext := 810;
    TLCTSBtn.HelpContext := 780;
    TLCPrnBtn.HelpContext := 82;
    TLCChkBtn.HelpContext := 84;

    // Supplier Buttons
    TLSAddBtn.HelpContext := 5076;
    TLSEditBtn.HelpContext := 5075;
    TLSFindBtn.HelpContext := 5072;
    TLSDelBtn.HelpContext := 5077;
    TLSLedBtn.HelpContext := 5078;
    TLSHistBtn.HelpContext := 5079;
    TLSNoteBtn.HelpContext := 5080;
    TLSLetrBtn.HelpContext := 5081;
    TLSSABtn.HelpContext := 5810;
    TLSTSBtn.HelpContext := 780;  // not used
    TLSPrnBtn.HelpContext := 5082;
    TLSChkBtn.HelpContext := 5084;

    // NF: 09/05/06 Fixes for incorrect Context IDs
    if CustCuBtn1.Caption = 'Contacts' then CustCuBtn1.HelpContext := 1710;
    if CustCuBtn2.Caption = 'Contacts' then CustCuBtn2.HelpContext := 1710;
    if CustSuBtn1.Caption = 'Contacts' then CustSuBtn1.HelpContext := 6710;
    if CustSUBtn2.Caption = 'Contacts' then CustSUBtn2.HelpContext := 6710;
  {$ENDIF}
end;

procedure TTradList.TLSSortBtnClick(Sender: TObject);
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
  MenuPoint: TPoint;
begin
  if (KeyPressOk) then
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

procedure TTradList.ShowSortViewDlg;
var
  Dlg: TSortViewOptionsFrm;
begin
  Dlg := TSortViewOptionsFrm.Create(nil);
  Dlg.SortView := MULCtrlO[Current_Page].SortView;
  try
    if (Dlg.ShowModal = mrOk) then
    begin
      { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View - extracted
        code into separate function }
      ActivateSortView;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TTradList.RefreshView1Click(Sender: TObject);
var
  FuncRes: Integer;
begin
  FuncRes := MulCtrlO[Current_Page].SortView.Refresh;
  if (FuncRes = 0) then
  begin
    MulCtrlO[Current_Page].SortView.Enabled := True;
    MulCtrlO[Current_Page].StartList(SortTempF, STFieldK, FullNomKey(MulCtrlO[Current_Page].SortView.ListID), '', '', 0, BOff);
    if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
      PageControl1.Pages[Current_Page].ImageIndex := 1
    else
      PageControl1.Pages[Current_Page].ImageIndex := 2;
  end
  else
    ShowMessage('Failed to refresh Sort View, error #' + IntToStr(FuncRes));
end;

procedure TTradList.CloseView1Click(Sender: TObject);
begin
  MulCtrlO[Current_Page].SortView.CloseView;
  MulCtrlO[Current_Page].SortView.Enabled := False;
  with MulCtrlO[Current_Page] do
  begin
    if (Current_Page = 0) then
      // Customers
      StartList(CustF, ATCodeK, 'C', '', '', 1, BOff)
    else if (Current_Page = 1) then
      // Consumers
      StartList(CustF, CustLongACCodeK, 'U', '', '', 1, BOff)
    else
      // Suppliers
      StartList(CustF, ATCodeK, 'S', '', '', 1, BOff);
  end;
  PageControl1.Pages[Current_Page].ImageIndex := -1;
end;

procedure TTradList.SortViewOptions1Click(Sender: TObject);
begin
  ShowSortViewDlg;
end;

{ CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
procedure TTradList.ActivateSortView;
var
  FuncRes: LongInt;
begin
  FuncRes := MulCtrlO[Current_Page].SortView.Apply;
  if (FuncRes = 0) then
  begin
    MulCtrlO[Current_Page].SortView.Enabled := True;
    MulCtrlO[Current_Page].StartList(SortTempF, STFieldK, FullNomKey(MulCtrlO[Current_Page].SortView.ListID), '', '', 0, BOff);
    if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
      PageControl1.Pages[Current_Page].ImageIndex := 1
    else
      PageControl1.Pages[Current_Page].ImageIndex := 2;
  end
  else
    ShowMessage('Failed to initialise Sort View, error #' + IntToStr(FuncRes));
end;

//-------------------------------------------------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
function TTradList.WindowExportEnableExport: Boolean;
begin
  Result := True;
  WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
  WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
  WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
end;

//-----------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TTradList.WindowExportExecuteCommand(const CommandID: Integer; Const ProgressHWnd : HWnd);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  Try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    Begin
      // Get the active Btrieve List to export the data
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

function TTradList.WindowExportGetExportDescription: String;
begin
  // Generate relevant worksheet title
  Case Current_Page of
    0 : Result := 'Customer List';
    1 : Result := 'Consumer List';
    2 : Result := 'Supplier List';
  Else
    Result := 'Unknown Export';
  End; // Case Current_Page
end;

//-------------------------------------------------------------------------

Initialization

  TradListFormMode:=0;

end.
